#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct sleeplock {
  uint locked;     
  struct spinlock lk;     
};

void initlock(struct spinlock *lk, char *name)
{
  lk->locked = 0;
}

void lock(struct spinlock *lk)
{
  while(xchg(&lk->locked, 1) != 0);
}

void unlock(struct spinlock *lk)
{
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
}
