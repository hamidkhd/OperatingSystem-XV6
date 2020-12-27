#include "types.h"
#include "user.h"
#include "spinlock.h"

struct Condvar{
  struct spinlock lock;
};

int main()
{
    struct Condvar condvar;

    int pid = fork();

    if (pid < 0)
    {
        printf(1, "Error forking first child.\n");
    }
    else if (pid == 0)
    {
        sleep(50);
        printf(1, "Child 1 Executing\n");
        cv_signal(&condvar);
    }
    else
    {
        pid = fork();
        if (pid < 0)
        {
            printf(1, "Error forking second child.\n");
        }
        else if (pid == 0)
        {
            cv_wait(&condvar);
            printf(1, "Child 2 Executing\n");
            cv_signal(&condvar);
        }
        else
        {
            int i;
            for (i = 0; i < 2; i++)          
                wait();
        }
    }
    exit();
}
