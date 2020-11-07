#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{ 

  int a =trace_syscalls(1);
  printf(1,"%d\n", a);
  
  exit(); 
} 