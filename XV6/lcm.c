#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int find_gcd(int a, int b)
{
    if (a == 0)
        return b;
    else
        return find_gcd(b % a, a);     
} 

int find_lcm(int array[], int n) 
{ 
    int result = array[0]; 
  
    for (int i = 1; i < n; i++) 
    {
        result = ((result * array[i]) / find_gcd(result, array[i])); 
    }
  
    return result;
} 


int main(int argc, char *argv[])
{  
    int *arr;
    arr = (int*)malloc((argc-1)* sizeof(int));

    for (int i = 0; i < (argc-1); i++) 
        arr[i] = atoi(argv[i+1]);

    int file = open("lcm_result.txt", O_CREATE | O_WRONLY);
    printf(file, "%d \n", find_lcm(arr, argc-1));
    close(file);
    
    exit();  
}  