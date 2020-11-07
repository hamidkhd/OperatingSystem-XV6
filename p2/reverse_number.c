#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{ 
    if (argc < 2)
    {
        printf(1, "No number entered! \n");
        exit();
    }  

    int n = atoi(argv[1]);

    int prev_value; 

    asm("movl %%edi, %0;" : "=r"(prev_value)); 

    asm("movl %0, %%edi;" : : "r"(n)); 

    reverse_number();

    asm("movl %0, %%edi;" : : "r"(prev_value)); 

    exit(); 
} 