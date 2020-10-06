#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int count_digit(int number)
{
    int digit = 0;

    while (number)
    {
        digit++;
        number /= 10;
    }
    return digit;
}

char *int_to_char_array(int number)
{
    int digit = count_digit(number);
    char* array = (char*)malloc(digit);
    char* temp_array = (char*)malloc(digit);
    
    int counter = 0;

    if (number == 0)
    {
        array[counter] = '0'; 
        array[++counter] = '\0';       
        //array[++counter] = '\n';
        return array;
    }
    else 
    {
        while (number != 0) 
        {
            counter++;
            temp_array[counter] = number % 10 + 48;
            number /= 10;
        }

        for (int i = 0; i < counter; i++) 
            array[i] = temp_array[counter- i];
        
        array[counter] = '\n';
        array[++counter] = '\0';
    }
    return array; 
}

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
    int* arr = (int*)malloc((argc-1)* sizeof(int));

    for (int i = 0; i < (argc-1); i++) 
        arr[i] = atoi(argv[i+1]);

    char* result = int_to_char_array(find_lcm(arr, argc-1));
    printf(1,"%d\n",strlen(result));

    int file = open("lcm_result.txt", O_CREATE | O_WRONLY);
    write(file, result, 5);
    close(file);

    exit();  
}  