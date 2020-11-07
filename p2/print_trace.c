#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(void){
	int time;
	int first_time = 0;
	while(1){
		time = uptime();
		if(time - first_time >= 500){
          trace_syscalls(0);
          first_time = time;
          continue;
        }
		
	}

	exit();
}