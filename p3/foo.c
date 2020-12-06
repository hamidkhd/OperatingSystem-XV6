#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[])
{
    for (int i = 0; i < 4; i++)
    {
        if(fork() == 0){
            while(1);
        }

    }
    
    exit();
    return 0;
}