#include "types.h"
#include "user.h"
#include "fcntl.h"

int main()
{
    init_spinlock();

    for (int i = 0; i < 4; i++)
    {
        int pid = fork();
        if (pid == -1)
        {
            printf(1, "Error in make new process! \n");
            exit();
        }
        else if (pid == 0)
        {
            writers();
        }
        else
        {
            readers();
            wait();
        }
    }
    exit();
}