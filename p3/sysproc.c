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

int
sys_get_children(void){
  myproc()->call_nums[23] ++;
  int pid;
  if(argint(0, &pid) < 0)
    return -1;
  return children(pid);
}

int sys_change_process_queue(void)
{
  myproc()->call_nums[24] ++;
  int pid, dest_queue;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &dest_queue) < 0)
    return -1;

  change_process_queue(pid, dest_queue);
  return 0;
}

int sys_quantify_lottery_tickets(void)
{
  myproc()->call_nums[25] ++;
  int pid, ticket;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &ticket) < 0)
    return -1;

  quantify_lottery_tickets(pid, ticket);
  return 0;
}

int sys_quantify_BJF_parameters_process_level(void)
{
  myproc()->call_nums[26] ++;
  int pid, priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(0, &priority_ratio) < 0)
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
    return -1;
  if(argint(1, &exect_ratio) < 0)
    return -1;

  quantify_BJF_parameters_process_level(pid, priority_ratio, arrivt_ratio, exect_ratio);
  return 0;
}

int sys_quantify_BJF_parameters_kernel_level(void)
{
  myproc()->call_nums[27] ++;
  int priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &priority_ratio) < 0)
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
    return -1;
  if(argint(1, &exect_ratio) < 0)
    return -1;

  quantify_BJF_parameters_kernel_level(priority_ratio, arrivt_ratio, exect_ratio);
  return 0;
}

int sys_print_information(void)
{
  myproc()->call_nums[28] ++;
  print_information();
  return 0;
}