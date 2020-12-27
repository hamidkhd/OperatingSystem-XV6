#include "types.h"
#include "user.h"
#include "fcntl.h"

#define BUFFER_SIZE 5
#define MUTEX 0
#define EMPTY 1
#define FULL 2

void producer();
void consumer();

int main()
{
    semaphore_initialize(MUTEX, 1, 0); //mutex
    semaphore_initialize(EMPTY, BUFFER_SIZE, 0); //empty
    semaphore_initialize(FULL, BUFFER_SIZE, BUFFER_SIZE); //full

    int pid = fork();

    if (pid == -1)
    {
        printf(1, "Erorr in create new process! \n");
        exit();
    }

    else if (pid == 0)
        producer();   

    else
        consumer();


    wait();
    exit();
}

void producer()
{
    int read_counter = 0;
    while(read_counter <= 10)
    {
        printf(1, "Produce an item in next_produced! Index: %d \n", read_counter);

        semaphore_aquire(EMPTY);
        semaphore_aquire(MUTEX);

        printf(1, "Add next_produced to the buffer! Index: %d \n", read_counter);

        semaphore_release(MUTEX);
        semaphore_release(FULL);

        read_counter++;

        sleep(10);
    }
    exit();
}

void consumer()
{
    int write_counter = 0;
    while(write_counter <= 10)
    {
        semaphore_aquire(FULL);
        semaphore_aquire(MUTEX);

        printf(1, "Remove an item from buffer to next_consumed! Index: %d \n", write_counter);

        semaphore_release(MUTEX);
        semaphore_release(EMPTY);

        printf(1, "Consume the item in next_consumed! Index: %d \n", write_counter);

        write_counter++;

        sleep(10);
    }
    exit();
}