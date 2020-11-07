#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(){
	int (*func_ptr)(void) = (int(*) (void)) 2148555936;
	
	(*func_ptr)();
	exit();
}