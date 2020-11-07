#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  myproc()->call_nums[0] ++;
  return fork();
}

int
sys_exit(void)
{
  myproc()->call_nums[1] ++;
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  myproc()->call_nums[2] ++;
  return wait();
}

int
sys_kill(void)
{
  int pid;
  myproc()->call_nums[5] ++;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  
  myproc()->call_nums[10] ++;
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  myproc()->call_nums[11] ++;
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  myproc()->call_nums[12] ++;
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  myproc()->call_nums[13] ++;
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_trace_syscalls(void)
{
  int n;
  myproc()->call_nums[21] ++;
  if(argint(0, &n) == 0){
    if(myproc()->pid == 2){
      trace_syscalls(2);
      return 0;
    }
    else if (n==1 || n== 0) {
      myproc()-> print_state = n;
      trace_syscalls(n);
      return 0;
    }
    else
      return -1;
  }
  else
    return -1;
}

int sys_reverse_number(void)
{
  myproc()->call_nums[22] ++;
  int n;
  asm("movl %%edi, %0;" : "=r"(n)); 
  reverse_number(n);

  return 0;
}