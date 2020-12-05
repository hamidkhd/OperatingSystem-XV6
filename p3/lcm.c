#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int count_digit(int number, int digit)
{
    if (number)
        return count_digit(number/10, ++digit);
    return digit;
}

char *int_to_char_array(int number, int digit)
{
    char* array = (char*)malloc(digit);
    
    if (number == 0)
    {
        array[0] = '0'; 
        return (char*) array;
    }
    else 
    {
        for (int i = 0; i < digit; i++) 
        {
            array[digit-i-1] = number % 10 + 48;
            number /= 10;
        }
    }

    return (char*) array; 
}

int find_gcd(int a, int b)
{
    int gcd = 1, counter = 1;
    while (counter <= a && counter <= b)
    {
        if (a % counter == 0 && b % counter == 0) 
            gcd = counter;
        counter++;
    } 
    return gcd; 
} 

int find_lcm(int array[], int n) 
{ 
    int result = array[0]; 

    for (int i = 1; i < n; i++) 
        result *= (array[i] / find_gcd(result, array[i])); 
  
    return result;
} 


int main(int argc, char *argv[])
{  
    if (argc < 2)
    {
        printf(1, "No number entered ! \n");
        exit();
    }
    else if (argc > 9)
    {
        printf(1, "More than 8 numbers have been entered ! \n");
        exit();
    }

    int* arr = (int*)malloc((argc-1)* sizeof(int));

    for (int i = 0; i < (argc-1); i++) 
        arr[i] = atoi(argv[i+1]);

    int number = find_lcm(arr, argc-1);
    int digit = count_digit(number, 0);

    char* result = int_to_char_array(number, digit);

    if (open("lcm_result.txt", O_RDWR) != -1)
        unlink("lcm_result.txt");
        
    int file = open("lcm_result.txt", O_CREATE | O_WRONLY);
    write(file, result, digit);
    write(file, "\0\n", 2);
    close(file);

    free(arr);
    free(result);
    
    exit();  
}  