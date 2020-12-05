#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]){
	quantify_BJF_parameters_kernel_level(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]));
}