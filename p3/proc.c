#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

struct proc * BJF(struct proc** list, int size){

  struct proc* chosen = list[0];
  int rank = 0, ind = 0;
  for (int i=0; i < size; i++){
    if (list[i] -> state == RUNNABLE){
      rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
      chosen = list[i];
      ind = i;
      break;
    }
    
  }
  for (int i=ind + 1; i < size; i++){
    if (list[i]->state == RUNNABLE){
      int cur_rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
      if (cur_rank < rank){
        chosen = list[i];
        rank = cur_rank;
      }
    }
  }
  return chosen;

}

struct proc* RR(struct proc ** list, int size){
  
  for (int i=0; i < size; i++){
    if(list[i]->state != RUNNABLE && list[i]->visit)
        continue;
    return list[i];
  }

  for (int i=0; i < size; i++)
    list[i]->visit = 0;

  for (int i=0; i < size; i++){
    if(list[i]->state != RUNNABLE)
        continue;
    return list[i];
  }

  

  return list[0];

}

int generate_random(int m){
 int random;
 int a = ticks % m;
 int seed = ticks % m;
 random = (a * seed )% m;
 random = (a * random )% m;
 return random; 
}


struct proc* lotteryScheduling(struct proc ** list,int size){


  int sum_lotteries = 0;
  int random_ticket = 0;
  int curr_sum = 0;

  struct proc *golden_ticket = 0;
 

  for(int p = 0; p < size;p++){
    if(list[p]->state == RUNNABLE)
       sum_lotteries += list[p]->lottery_ticket;

  } 
  if(sum_lotteries == 0)
      return 0;

  random_ticket = generate_random(sum_lotteries);

  for(int p = 0; p < size ;p++){

    if(list[p]->state == RUNNABLE){
      curr_sum += list[p]->lottery_ticket;

      if(curr_sum > random_ticket) {
          golden_ticket = list[p];
          break;
        
        } 
    } 

  }
  return golden_ticket;
}


void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  int cycle = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    struct proc* level1 [NPROC];
    struct proc* level2 [NPROC];
    struct proc* level3 [NPROC];
    int index1 = 0;
    int index2 = 0;
    int index3 = 0;
    int run1 = 0, run2 =0, run3 = 0;
    
    for(p = ptable.proc; p >= &ptable.proc[NPROC]; p++){
      if (strlen(p->name) == 0)
        break;
    
      if (p->level == 1){
        level1 [index1] = p;
        index1 ++;
        if (p-> state == RUNNABLE)
          run1 ++;

      }

      else if (p->level == 2){
        level2[index2] = p;
        index2 ++;
        if (p-> state == RUNNABLE)
          run2 ++;
      }

      else {
        level3[index3] = p;
        index3 ++;
        if (p-> state == RUNNABLE)
          run3 ++;
      }
      
    }

    if(index1 && run1){

      p =  RR(level1, index1);
      p->visit = 1;

    }


    if (index2 && run2)
      p = lotteryScheduling(level2, index2);


    if (index3  && run3)
      p = BJF(level3, index3);




    release(&ptable.lock);
    

    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    p->waiting_time = 0;
    p->last_cycle = cycle;
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;
    if (p -> level == 3)
      p -> exect += 0.1;

    swtch(&(c->scheduler), p->context);
    switchkvm();

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;
    cycle += 1;
    struct proc *prc;
    for(prc = ptable.proc; prc >= &ptable.proc[NPROC]; prc++){
      if (strlen(prc->name) == 0)
        break;
      if (prc == p)
        continue;
      prc->waiting_time++;
      if(prc->waiting_time - prc->last_cycle >= 10000){
        prc->level = 1;
        prc->waiting_time = 0;
        prc->last_cycle = cycle;
      }

    }

    
    

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void print_name(int num)
{
  switch(num)
  {
    case 1:
      cprintf("Fork");
      break;
    case 2:
      cprintf("Exit");
      break;
    case 3:
      cprintf("Wait");
      break;
    case 4:
      cprintf("Pipe");
      break;
    case 5:
      cprintf("Read");
      break;
    case 6:
      cprintf("Kill");
      break;
    case 7:
      cprintf("Exec");
      break;
    case 8:
      cprintf("Fstat");
      break;
    case 9:
      cprintf("Chdir");
      break;
    case 10:
      cprintf("Dup");
      break;
    case 11:
      cprintf("Getpid");
      break;
    case 12:
      cprintf("Sbrk");
      break;
    case 13:
      cprintf("Sleep");
      break;
    case 14:
      cprintf("Uptime");
      break;
    case 15:
      cprintf("Open");
      break;
    case 16:
      cprintf("Write");
      break;
    case 17:
      cprintf("Mknod");
      break;
    case 18:
      cprintf("Unlink");
      break;
    case 19:
      cprintf("Link");
      break;
    case 20:
      cprintf("Mkdir");
      break;
    case 21:
      cprintf("Close");
      break;
    case 22:
      cprintf("Trace_syscalls");
      break;
    case 23:
      cprintf("Reverse_number");
      break;
    case 24:
      cprintf("Get_children");
      break;
  }

}
void allone(void){
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {

    if(strlen(p->name) == 0)
      break;
    p->print_state = 1;
    
  }
  

}
void all_zero(void)
{
  struct proc *p;
  int i;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(strlen(p->name) == 0)
      break;
    p->print_state = 0;
    for (i =0; i < SYSNUM; i++){
        
       p->call_nums[i] = 0;
    }
  }

}

int trace_syscalls(int state)
{
  
  struct proc *p;
  int i;
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
  {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(strlen(p->name) == 0)
        break;

      p->print_state = 1;
      cprintf("%s:\n",p->name);

      for (i =0; i < SYSNUM; i++)
      {
        cprintf("   ");
        print_name(i + 1);
        cprintf(": %d\n", p->call_nums[i]);
      }

    }
    return 0;
  }

  if(state == 0)
  {
    all_zero();
    return 0;
  }
  return -1;
 
}

int reverse_number(int n)
{

  int digit = 0;
  int temp = n;

  while (temp)
  {
    ++digit;
    temp /= 10;
  }

  int array[200] = {0};
  
  for (int i = 0; i < digit; i++) 
    {
      array[i] = n % 10;
      n /= 10;
    }
  
  for(int j = 0; j < digit; j++)
    cprintf("%d", array[j]);
  cprintf("\n");

  return 0;

}
int
children(int pid)
{
  struct proc *p;
  
  int childs[NPROC] = {-1};
  int curr_index = 0;
  int index = 0;
  //int parent_pid = pid ; 

  acquire(&ptable.lock);

  for(int i = 0 ; i < NPROC ; i++){

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

      //cprintf("proc pid: %d  parent pid: %d \n",  p->pid, p->parent->pid);

        if(p->parent->pid == pid){
           childs[index] = p->pid ;
           index++;
       //  cprintf(" parent pid ,%d", pid , " child pid: %d \n",  p->pid);
        }
    }
     if(childs[curr_index] == -1)
         break;
     else{
       pid = childs[curr_index];
       curr_index++;
      } 
  }
  release(&ptable.lock);
  
  int pid_list = 0;
  int cpy ; 

  for(int i = 0 ; i < index ;i++){

  cpy = childs[i];
  while(cpy > 0){
        pid_list *= 10;
        cpy /= 10 ;
     }
  pid_list += childs[i];
}


  return pid_list;
}

void change_process_queue(int pid, int dest_queue)
{
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid)
    {
      p->level = dest_queue;
    }
  }
}

void quantify_lottery_tickets(int pid, int ticket)
{
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid)
    {
      p->lottery_ticket = ticket;
    }
  }
}

void quantify_BJF_parameters_process_level(int pid, int priority_ratio, int arrivt_ratio, int exect_ratio)
{
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid)
    {
      p->priority_ratio = priority_ratio;
      p->arrivt_ratio = arrivt_ratio;
      p->exect_ratio = exect_ratio;
    }
  }
}

void quantify_BJF_parameters_kernel_level(int priority_ratio, int arrivt_ratio, int exect_ratio)
{
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
  {
    p->priority_ratio = priority_ratio;
    p->arrivt_ratio = arrivt_ratio;
    p->exect_ratio = exect_ratio;
  }
}

const char* state_to_string(enum procstate const state)
{
  switch (state) 
  { 
    case UNUSED:  
      return "UNUSED";
      break; 

    case EMBRYO:  
      return "EMBRYO";
      break; 

    case SLEEPING:
      return "SLEEPING";  
      break;  

    case RUNNABLE:  
      return "RUNNABLE";
      break;

    case RUNNING:  
      return "RUNNING";
      break;

    case ZOMBIE:  
      return "ZOMBIE";
      break;
  }
  return 0;
}

void print_information()
{
  struct proc* p;
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
  cprintf("...............................................................................................................\n");
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
  {
    int rank = p->priority * p->priority_ratio + p->arrivt * p->arrivt_ratio + p->exect * p->exect_ratio;

    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
    p->name, p->pid, state_to_string(p->state), p->level, p->lottery_ticket, p->priority_ratio, p->arrivt_ratio, p->exect_ratio, rank, p->last_cycle);
  }
}