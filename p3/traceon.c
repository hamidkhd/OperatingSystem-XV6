#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{ 

  trace_syscalls(1);
  
  exit(); 
} 