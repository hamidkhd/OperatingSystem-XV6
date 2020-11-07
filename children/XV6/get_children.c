#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"


int main(int argc, char *argv[])
{
	int pid = getpid();
	printf(1, "pid %d\n", pid);

	int child1 = fork();
	
        if(child1 == 0){
        	int child1_pid = getpid();
		printf(1, "pid %d\n", child1_pid);

		int gchild1 = fork();
                //if( gchild1 == 0){ //
                //    int ggchild1 = fork();
                    //if (ggchild1 > 0){
                     // printf(1, "children pids: %d\n", get_children(ggchild1));
                    //  printf(1, "children pids: %d\n", get_children(pid));
                  //    wait();
		//}
               // }
		if (gchild1 > 0){

			int gchild2 = fork();

			if (gchild2 > 0){
		
				printf(1, " children pids: %d\n", get_children(child1_pid));
                                printf(1, " children pids: %d\n", get_children(pid));
				wait();	
			}
		wait(); 
		}
              
                exit();
	}
       else if(child1 > 0){
          wait();
        
     }
	exit();

}
