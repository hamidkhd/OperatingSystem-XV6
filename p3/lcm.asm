
_lcm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return result;
} 


int main(int argc, char *argv[])
{  
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 19                	mov    (%ecx),%ebx
  16:	8b 79 04             	mov    0x4(%ecx),%edi
    if (argc < 2)
  19:	83 fb 01             	cmp    $0x1,%ebx
  1c:	0f 8e 06 01 00 00    	jle    128 <main+0x128>
    {
        printf(1, "No number entered ! \n");
        exit();
    }
    else if (argc > 9)
  22:	83 fb 09             	cmp    $0x9,%ebx
  25:	0f 8f ea 00 00 00    	jg     115 <main+0x115>
    {
        printf(1, "More than 8 numbers have been entered ! \n");
        exit();
    }

    int* arr = (int*)malloc((argc-1)* sizeof(int));
  2b:	8d 43 ff             	lea    -0x1(%ebx),%eax
  2e:	83 ec 0c             	sub    $0xc,%esp

    for (int i = 0; i < (argc-1); i++) 
  31:	31 db                	xor    %ebx,%ebx
    int* arr = (int*)malloc((argc-1)* sizeof(int));
  33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	50                   	push   %eax
  3a:	e8 f1 08 00 00       	call   930 <malloc>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	89 c6                	mov    %eax,%esi
  44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        arr[i] = atoi(argv[i+1]);
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	ff 74 9f 04          	pushl  0x4(%edi,%ebx,4)
  4f:	e8 7c 04 00 00       	call   4d0 <atoi>
    for (int i = 0; i < (argc-1); i++) 
  54:	83 c4 10             	add    $0x10,%esp
        arr[i] = atoi(argv[i+1]);
  57:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
    for (int i = 0; i < (argc-1); i++) 
  5a:	83 c3 01             	add    $0x1,%ebx
  5d:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  60:	75 e6                	jne    48 <main+0x48>

    int number = find_lcm(arr, argc-1);
  62:	50                   	push   %eax
  63:	50                   	push   %eax
    if (number)
  64:	31 db                	xor    %ebx,%ebx
    int number = find_lcm(arr, argc-1);
  66:	ff 75 e4             	pushl  -0x1c(%ebp)
  69:	56                   	push   %esi
  6a:	e8 f1 01 00 00       	call   260 <find_lcm>
  6f:	83 c4 10             	add    $0x10,%esp
    if (number)
  72:	85 c0                	test   %eax,%eax
    int number = find_lcm(arr, argc-1);
  74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (number)
  77:	89 c1                	mov    %eax,%ecx
  79:	74 18                	je     93 <main+0x93>
        return count_digit(number/10, ++digit);
  7b:	bf 67 66 66 66       	mov    $0x66666667,%edi
  80:	89 c8                	mov    %ecx,%eax
  82:	c1 f9 1f             	sar    $0x1f,%ecx
  85:	83 c3 01             	add    $0x1,%ebx
  88:	f7 ef                	imul   %edi
  8a:	c1 fa 02             	sar    $0x2,%edx
    if (number)
  8d:	29 ca                	sub    %ecx,%edx
  8f:	89 d1                	mov    %edx,%ecx
  91:	75 ed                	jne    80 <main+0x80>
    int digit = count_digit(number, 0);

    char* result = int_to_char_array(number, digit);
  93:	52                   	push   %edx
  94:	52                   	push   %edx
  95:	53                   	push   %ebx
  96:	ff 75 e4             	pushl  -0x1c(%ebp)
  99:	e8 e2 00 00 00       	call   180 <int_to_char_array>

    if (open("lcm_result.txt", O_RDWR) != -1)
  9e:	59                   	pop    %ecx
  9f:	5f                   	pop    %edi
  a0:	6a 02                	push   $0x2
  a2:	68 3e 0a 00 00       	push   $0xa3e
    char* result = int_to_char_array(number, digit);
  a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (open("lcm_result.txt", O_RDWR) != -1)
  aa:	e8 d3 04 00 00       	call   582 <open>
  af:	83 c4 10             	add    $0x10,%esp
  b2:	83 c0 01             	add    $0x1,%eax
  b5:	74 10                	je     c7 <main+0xc7>
        unlink("lcm_result.txt");
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	68 3e 0a 00 00       	push   $0xa3e
  bf:	e8 ce 04 00 00       	call   592 <unlink>
  c4:	83 c4 10             	add    $0x10,%esp
        
    int file = open("lcm_result.txt", O_CREATE | O_WRONLY);
  c7:	50                   	push   %eax
  c8:	50                   	push   %eax
  c9:	68 01 02 00 00       	push   $0x201
  ce:	68 3e 0a 00 00       	push   $0xa3e
  d3:	e8 aa 04 00 00       	call   582 <open>
    write(file, result, digit);
  d8:	83 c4 0c             	add    $0xc,%esp
    int file = open("lcm_result.txt", O_CREATE | O_WRONLY);
  db:	89 c7                	mov    %eax,%edi
    write(file, result, digit);
  dd:	53                   	push   %ebx
  de:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  e1:	53                   	push   %ebx
  e2:	50                   	push   %eax
  e3:	e8 7a 04 00 00       	call   562 <write>
    write(file, "\0\n", 2);
  e8:	83 c4 0c             	add    $0xc,%esp
  eb:	6a 02                	push   $0x2
  ed:	68 7c 0a 00 00       	push   $0xa7c
  f2:	57                   	push   %edi
  f3:	e8 6a 04 00 00       	call   562 <write>
    close(file);
  f8:	89 3c 24             	mov    %edi,(%esp)
  fb:	e8 6a 04 00 00       	call   56a <close>

    free(arr);
 100:	89 34 24             	mov    %esi,(%esp)
 103:	e8 98 07 00 00       	call   8a0 <free>
    free(result);
 108:	89 1c 24             	mov    %ebx,(%esp)
 10b:	e8 90 07 00 00       	call   8a0 <free>
    
    exit();  
 110:	e8 2d 04 00 00       	call   542 <exit>
        printf(1, "More than 8 numbers have been entered ! \n");
 115:	50                   	push   %eax
 116:	50                   	push   %eax
 117:	68 50 0a 00 00       	push   $0xa50
 11c:	6a 01                	push   $0x1
 11e:	e8 ad 05 00 00       	call   6d0 <printf>
        exit();
 123:	e8 1a 04 00 00       	call   542 <exit>
        printf(1, "No number entered ! \n");
 128:	50                   	push   %eax
 129:	50                   	push   %eax
 12a:	68 28 0a 00 00       	push   $0xa28
 12f:	6a 01                	push   $0x1
 131:	e8 9a 05 00 00       	call   6d0 <printf>
        exit();
 136:	e8 07 04 00 00       	call   542 <exit>
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <count_digit>:
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	56                   	push   %esi
 144:	53                   	push   %ebx
 145:	8b 4d 08             	mov    0x8(%ebp),%ecx
 148:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (number)
 14b:	85 c9                	test   %ecx,%ecx
 14d:	74 1c                	je     16b <count_digit+0x2b>
        return count_digit(number/10, ++digit);
 14f:	be 67 66 66 66       	mov    $0x66666667,%esi
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 158:	89 c8                	mov    %ecx,%eax
 15a:	c1 f9 1f             	sar    $0x1f,%ecx
 15d:	83 c3 01             	add    $0x1,%ebx
 160:	f7 ee                	imul   %esi
 162:	c1 fa 02             	sar    $0x2,%edx
    if (number)
 165:	29 ca                	sub    %ecx,%edx
 167:	89 d1                	mov    %edx,%ecx
 169:	75 ed                	jne    158 <count_digit+0x18>
}
 16b:	89 d8                	mov    %ebx,%eax
 16d:	5b                   	pop    %ebx
 16e:	5e                   	pop    %esi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <int_to_char_array>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <int_to_char_array>:
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
 186:	83 ec 18             	sub    $0x18,%esp
 189:	8b 75 0c             	mov    0xc(%ebp),%esi
 18c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char* array = (char*)malloc(digit);
 18f:	56                   	push   %esi
 190:	e8 9b 07 00 00       	call   930 <malloc>
    if (number == 0)
 195:	83 c4 10             	add    $0x10,%esp
 198:	85 db                	test   %ebx,%ebx
    char* array = (char*)malloc(digit);
 19a:	89 c7                	mov    %eax,%edi
    if (number == 0)
 19c:	74 4a                	je     1e8 <int_to_char_array+0x68>
        for (int i = 0; i < digit; i++) 
 19e:	85 f6                	test   %esi,%esi
 1a0:	7e 35                	jle    1d7 <int_to_char_array+0x57>
 1a2:	8d 4c 30 ff          	lea    -0x1(%eax,%esi,1),%ecx
 1a6:	8d 70 ff             	lea    -0x1(%eax),%esi
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            array[digit-i-1] = number % 10 + 48;
 1b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
 1b5:	83 e9 01             	sub    $0x1,%ecx
 1b8:	f7 eb                	imul   %ebx
 1ba:	89 d8                	mov    %ebx,%eax
 1bc:	c1 f8 1f             	sar    $0x1f,%eax
 1bf:	c1 fa 02             	sar    $0x2,%edx
 1c2:	29 c2                	sub    %eax,%edx
 1c4:	8d 04 92             	lea    (%edx,%edx,4),%eax
 1c7:	01 c0                	add    %eax,%eax
 1c9:	29 c3                	sub    %eax,%ebx
 1cb:	83 c3 30             	add    $0x30,%ebx
 1ce:	88 59 01             	mov    %bl,0x1(%ecx)
        for (int i = 0; i < digit; i++) 
 1d1:	39 ce                	cmp    %ecx,%esi
            number /= 10;
 1d3:	89 d3                	mov    %edx,%ebx
        for (int i = 0; i < digit; i++) 
 1d5:	75 d9                	jne    1b0 <int_to_char_array+0x30>
}
 1d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1da:	89 f8                	mov    %edi,%eax
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        array[0] = '0'; 
 1e8:	c6 00 30             	movb   $0x30,(%eax)
}
 1eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ee:	89 f8                	mov    %edi,%eax
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    
 1f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <find_gcd>:
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
 206:	8b 5d 08             	mov    0x8(%ebp),%ebx
 209:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20c:	89 de                	mov    %ebx,%esi
 20e:	0f 4f 75 0c          	cmovg  0xc(%ebp),%esi
    while (counter <= a && counter <= b)
 212:	85 f6                	test   %esi,%esi
 214:	7e 3a                	jle    250 <find_gcd+0x50>
 216:	83 c6 01             	add    $0x1,%esi
    int gcd = 1, counter = 1;
 219:	b9 01 00 00 00       	mov    $0x1,%ecx
 21e:	bf 01 00 00 00       	mov    $0x1,%edi
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (a % counter == 0 && b % counter == 0) 
 228:	89 d8                	mov    %ebx,%eax
 22a:	99                   	cltd   
 22b:	f7 f9                	idiv   %ecx
 22d:	85 d2                	test   %edx,%edx
 22f:	75 0b                	jne    23c <find_gcd+0x3c>
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	99                   	cltd   
 235:	f7 f9                	idiv   %ecx
 237:	85 d2                	test   %edx,%edx
 239:	0f 44 f9             	cmove  %ecx,%edi
        counter++;
 23c:	83 c1 01             	add    $0x1,%ecx
    while (counter <= a && counter <= b)
 23f:	39 f1                	cmp    %esi,%ecx
 241:	75 e5                	jne    228 <find_gcd+0x28>
} 
 243:	5b                   	pop    %ebx
 244:	89 f8                	mov    %edi,%eax
 246:	5e                   	pop    %esi
 247:	5f                   	pop    %edi
 248:	5d                   	pop    %ebp
 249:	c3                   	ret    
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int gcd = 1, counter = 1;
 250:	bf 01 00 00 00       	mov    $0x1,%edi
} 
 255:	5b                   	pop    %ebx
 256:	89 f8                	mov    %edi,%eax
 258:	5e                   	pop    %esi
 259:	5f                   	pop    %edi
 25a:	5d                   	pop    %ebp
 25b:	c3                   	ret    
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <find_lcm>:
{ 
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
 265:	53                   	push   %ebx
 266:	83 ec 0c             	sub    $0xc,%esp
 269:	8b 55 0c             	mov    0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
    for (int i = 1; i < n; i++) 
 26f:	83 fa 01             	cmp    $0x1,%edx
    int result = array[0]; 
 272:	8b 18                	mov    (%eax),%ebx
    for (int i = 1; i < n; i++) 
 274:	7e 6e                	jle    2e4 <find_lcm+0x84>
 276:	8d 78 04             	lea    0x4(%eax),%edi
 279:	8d 04 90             	lea    (%eax,%edx,4),%eax
 27c:	89 7d ec             	mov    %edi,-0x14(%ebp)
 27f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        result *= (array[i] / find_gcd(result, array[i])); 
 288:	8b 45 ec             	mov    -0x14(%ebp),%eax
 28b:	8b 30                	mov    (%eax),%esi
 28d:	89 d8                	mov    %ebx,%eax
 28f:	39 de                	cmp    %ebx,%esi
 291:	0f 4e c6             	cmovle %esi,%eax
    while (counter <= a && counter <= b)
 294:	85 c0                	test   %eax,%eax
 296:	7e 3d                	jle    2d5 <find_lcm+0x75>
 298:	83 c0 01             	add    $0x1,%eax
    int gcd = 1, counter = 1;
 29b:	89 75 f0             	mov    %esi,-0x10(%ebp)
 29e:	bf 01 00 00 00       	mov    $0x1,%edi
 2a3:	b9 01 00 00 00       	mov    $0x1,%ecx
 2a8:	89 c6                	mov    %eax,%esi
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (a % counter == 0 && b % counter == 0) 
 2b0:	89 d8                	mov    %ebx,%eax
 2b2:	99                   	cltd   
 2b3:	f7 f9                	idiv   %ecx
 2b5:	85 d2                	test   %edx,%edx
 2b7:	75 0b                	jne    2c4 <find_lcm+0x64>
 2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2bc:	99                   	cltd   
 2bd:	f7 f9                	idiv   %ecx
 2bf:	85 d2                	test   %edx,%edx
 2c1:	0f 44 f9             	cmove  %ecx,%edi
        counter++;
 2c4:	83 c1 01             	add    $0x1,%ecx
    while (counter <= a && counter <= b)
 2c7:	39 f1                	cmp    %esi,%ecx
 2c9:	75 e5                	jne    2b0 <find_lcm+0x50>
 2cb:	8b 75 f0             	mov    -0x10(%ebp),%esi
 2ce:	89 f0                	mov    %esi,%eax
 2d0:	99                   	cltd   
 2d1:	f7 ff                	idiv   %edi
 2d3:	89 c6                	mov    %eax,%esi
 2d5:	83 45 ec 04          	addl   $0x4,-0x14(%ebp)
        result *= (array[i] / find_gcd(result, array[i])); 
 2d9:	0f af de             	imul   %esi,%ebx
 2dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    for (int i = 1; i < n; i++) 
 2df:	39 45 e8             	cmp    %eax,-0x18(%ebp)
 2e2:	75 a4                	jne    288 <find_lcm+0x28>
} 
 2e4:	83 c4 0c             	add    $0xc,%esp
 2e7:	89 d8                	mov    %ebx,%eax
 2e9:	5b                   	pop    %ebx
 2ea:	5e                   	pop    %esi
 2eb:	5f                   	pop    %edi
 2ec:	5d                   	pop    %ebp
 2ed:	c3                   	ret    
 2ee:	66 90                	xchg   %ax,%ax

000002f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 300:	83 c1 01             	add    $0x1,%ecx
 303:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 307:	83 c2 01             	add    $0x1,%edx
 30a:	84 db                	test   %bl,%bl
 30c:	88 5a ff             	mov    %bl,-0x1(%edx)
 30f:	75 ef                	jne    300 <strcpy+0x10>
    ;
  return os;
}
 311:	5b                   	pop    %ebx
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    
 314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 31a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 55 08             	mov    0x8(%ebp),%edx
 327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 32a:	0f b6 02             	movzbl (%edx),%eax
 32d:	0f b6 19             	movzbl (%ecx),%ebx
 330:	84 c0                	test   %al,%al
 332:	75 1c                	jne    350 <strcmp+0x30>
 334:	eb 2a                	jmp    360 <strcmp+0x40>
 336:	8d 76 00             	lea    0x0(%esi),%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 340:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 343:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 346:	83 c1 01             	add    $0x1,%ecx
 349:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 34c:	84 c0                	test   %al,%al
 34e:	74 10                	je     360 <strcmp+0x40>
 350:	38 d8                	cmp    %bl,%al
 352:	74 ec                	je     340 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 354:	29 d8                	sub    %ebx,%eax
}
 356:	5b                   	pop    %ebx
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 360:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 362:	29 d8                	sub    %ebx,%eax
}
 364:	5b                   	pop    %ebx
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <strlen>:

uint
strlen(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 376:	80 39 00             	cmpb   $0x0,(%ecx)
 379:	74 15                	je     390 <strlen+0x20>
 37b:	31 d2                	xor    %edx,%edx
 37d:	8d 76 00             	lea    0x0(%esi),%esi
 380:	83 c2 01             	add    $0x1,%edx
 383:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 387:	89 d0                	mov    %edx,%eax
 389:	75 f5                	jne    380 <strlen+0x10>
    ;
  return n;
}
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 390:	31 c0                	xor    %eax,%eax
}
 392:	5d                   	pop    %ebp
 393:	c3                   	ret    
 394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 39a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	89 d7                	mov    %edx,%edi
 3af:	fc                   	cld    
 3b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3b2:	89 d0                	mov    %edx,%eax
 3b4:	5f                   	pop    %edi
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <strchr>:

char*
strchr(const char *s, char c)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3ca:	0f b6 10             	movzbl (%eax),%edx
 3cd:	84 d2                	test   %dl,%dl
 3cf:	74 1d                	je     3ee <strchr+0x2e>
    if(*s == c)
 3d1:	38 d3                	cmp    %dl,%bl
 3d3:	89 d9                	mov    %ebx,%ecx
 3d5:	75 0d                	jne    3e4 <strchr+0x24>
 3d7:	eb 17                	jmp    3f0 <strchr+0x30>
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e0:	38 ca                	cmp    %cl,%dl
 3e2:	74 0c                	je     3f0 <strchr+0x30>
  for(; *s; s++)
 3e4:	83 c0 01             	add    $0x1,%eax
 3e7:	0f b6 10             	movzbl (%eax),%edx
 3ea:	84 d2                	test   %dl,%dl
 3ec:	75 f2                	jne    3e0 <strchr+0x20>
      return (char*)s;
  return 0;
 3ee:	31 c0                	xor    %eax,%eax
}
 3f0:	5b                   	pop    %ebx
 3f1:	5d                   	pop    %ebp
 3f2:	c3                   	ret    
 3f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <gets>:

char*
gets(char *buf, int max)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 406:	31 f6                	xor    %esi,%esi
 408:	89 f3                	mov    %esi,%ebx
{
 40a:	83 ec 1c             	sub    $0x1c,%esp
 40d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 410:	eb 2f                	jmp    441 <gets+0x41>
 412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 418:	8d 45 e7             	lea    -0x19(%ebp),%eax
 41b:	83 ec 04             	sub    $0x4,%esp
 41e:	6a 01                	push   $0x1
 420:	50                   	push   %eax
 421:	6a 00                	push   $0x0
 423:	e8 32 01 00 00       	call   55a <read>
    if(cc < 1)
 428:	83 c4 10             	add    $0x10,%esp
 42b:	85 c0                	test   %eax,%eax
 42d:	7e 1c                	jle    44b <gets+0x4b>
      break;
    buf[i++] = c;
 42f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 433:	83 c7 01             	add    $0x1,%edi
 436:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 439:	3c 0a                	cmp    $0xa,%al
 43b:	74 23                	je     460 <gets+0x60>
 43d:	3c 0d                	cmp    $0xd,%al
 43f:	74 1f                	je     460 <gets+0x60>
  for(i=0; i+1 < max; ){
 441:	83 c3 01             	add    $0x1,%ebx
 444:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 447:	89 fe                	mov    %edi,%esi
 449:	7c cd                	jl     418 <gets+0x18>
 44b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 450:	c6 03 00             	movb   $0x0,(%ebx)
}
 453:	8d 65 f4             	lea    -0xc(%ebp),%esp
 456:	5b                   	pop    %ebx
 457:	5e                   	pop    %esi
 458:	5f                   	pop    %edi
 459:	5d                   	pop    %ebp
 45a:	c3                   	ret    
 45b:	90                   	nop
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 460:	8b 75 08             	mov    0x8(%ebp),%esi
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	01 de                	add    %ebx,%esi
 468:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 46a:	c6 03 00             	movb   $0x0,(%ebx)
}
 46d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 470:	5b                   	pop    %ebx
 471:	5e                   	pop    %esi
 472:	5f                   	pop    %edi
 473:	5d                   	pop    %ebp
 474:	c3                   	ret    
 475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <stat>:

int
stat(const char *n, struct stat *st)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	56                   	push   %esi
 484:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 485:	83 ec 08             	sub    $0x8,%esp
 488:	6a 00                	push   $0x0
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 f0 00 00 00       	call   582 <open>
  if(fd < 0)
 492:	83 c4 10             	add    $0x10,%esp
 495:	85 c0                	test   %eax,%eax
 497:	78 27                	js     4c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 499:	83 ec 08             	sub    $0x8,%esp
 49c:	ff 75 0c             	pushl  0xc(%ebp)
 49f:	89 c3                	mov    %eax,%ebx
 4a1:	50                   	push   %eax
 4a2:	e8 f3 00 00 00       	call   59a <fstat>
  close(fd);
 4a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4aa:	89 c6                	mov    %eax,%esi
  close(fd);
 4ac:	e8 b9 00 00 00       	call   56a <close>
  return r;
 4b1:	83 c4 10             	add    $0x10,%esp
}
 4b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4b7:	89 f0                	mov    %esi,%eax
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4c5:	eb ed                	jmp    4b4 <stat+0x34>
 4c7:	89 f6                	mov    %esi,%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <atoi>:

int
atoi(const char *s)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	53                   	push   %ebx
 4d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4d7:	0f be 11             	movsbl (%ecx),%edx
 4da:	8d 42 d0             	lea    -0x30(%edx),%eax
 4dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 4df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 4e4:	77 1f                	ja     505 <atoi+0x35>
 4e6:	8d 76 00             	lea    0x0(%esi),%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 4f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4f3:	83 c1 01             	add    $0x1,%ecx
 4f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4fa:	0f be 11             	movsbl (%ecx),%edx
 4fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 500:	80 fb 09             	cmp    $0x9,%bl
 503:	76 eb                	jbe    4f0 <atoi+0x20>
  return n;
}
 505:	5b                   	pop    %ebx
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
 508:	90                   	nop
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000510 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	56                   	push   %esi
 514:	53                   	push   %ebx
 515:	8b 5d 10             	mov    0x10(%ebp),%ebx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 51e:	85 db                	test   %ebx,%ebx
 520:	7e 14                	jle    536 <memmove+0x26>
 522:	31 d2                	xor    %edx,%edx
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 528:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 52c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 52f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 532:	39 d3                	cmp    %edx,%ebx
 534:	75 f2                	jne    528 <memmove+0x18>
  return vdst;
}
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5d                   	pop    %ebp
 539:	c3                   	ret    

0000053a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53a:	b8 01 00 00 00       	mov    $0x1,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <exit>:
SYSCALL(exit)
 542:	b8 02 00 00 00       	mov    $0x2,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <wait>:
SYSCALL(wait)
 54a:	b8 03 00 00 00       	mov    $0x3,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <pipe>:
SYSCALL(pipe)
 552:	b8 04 00 00 00       	mov    $0x4,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <read>:
SYSCALL(read)
 55a:	b8 05 00 00 00       	mov    $0x5,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <write>:
SYSCALL(write)
 562:	b8 10 00 00 00       	mov    $0x10,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <close>:
SYSCALL(close)
 56a:	b8 15 00 00 00       	mov    $0x15,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <kill>:
SYSCALL(kill)
 572:	b8 06 00 00 00       	mov    $0x6,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <exec>:
SYSCALL(exec)
 57a:	b8 07 00 00 00       	mov    $0x7,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <open>:
SYSCALL(open)
 582:	b8 0f 00 00 00       	mov    $0xf,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <mknod>:
SYSCALL(mknod)
 58a:	b8 11 00 00 00       	mov    $0x11,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <unlink>:
SYSCALL(unlink)
 592:	b8 12 00 00 00       	mov    $0x12,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <fstat>:
SYSCALL(fstat)
 59a:	b8 08 00 00 00       	mov    $0x8,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <link>:
SYSCALL(link)
 5a2:	b8 13 00 00 00       	mov    $0x13,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <mkdir>:
SYSCALL(mkdir)
 5aa:	b8 14 00 00 00       	mov    $0x14,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <chdir>:
SYSCALL(chdir)
 5b2:	b8 09 00 00 00       	mov    $0x9,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <dup>:
SYSCALL(dup)
 5ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <getpid>:
SYSCALL(getpid)
 5c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <sbrk>:
SYSCALL(sbrk)
 5ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <sleep>:
SYSCALL(sleep)
 5d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <uptime>:
SYSCALL(uptime)
 5da:	b8 0e 00 00 00       	mov    $0xe,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <trace_syscalls>:
SYSCALL(trace_syscalls)
 5e2:	b8 16 00 00 00       	mov    $0x16,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <reverse_number>:
SYSCALL(reverse_number)
 5ea:	b8 17 00 00 00       	mov    $0x17,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <get_children>:
SYSCALL(get_children)
 5f2:	b8 18 00 00 00       	mov    $0x18,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <change_process_queue>:
SYSCALL(change_process_queue)
 5fa:	b8 19 00 00 00       	mov    $0x19,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <quantify_lottery_tickets>:
SYSCALL(quantify_lottery_tickets)
 602:	b8 1a 00 00 00       	mov    $0x1a,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <quantify_BJF_parameters_process_level>:
SYSCALL(quantify_BJF_parameters_process_level)
 60a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <quantify_BJF_parameters_kernel_level>:
SYSCALL(quantify_BJF_parameters_kernel_level)
 612:	b8 1c 00 00 00       	mov    $0x1c,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <print_information>:
 61a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    
 622:	66 90                	xchg   %ax,%ax
 624:	66 90                	xchg   %ax,%ax
 626:	66 90                	xchg   %ax,%ax
 628:	66 90                	xchg   %ax,%ax
 62a:	66 90                	xchg   %ax,%ax
 62c:	66 90                	xchg   %ax,%ax
 62e:	66 90                	xchg   %ax,%ax

00000630 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 639:	85 d2                	test   %edx,%edx
{
 63b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 63e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 640:	79 76                	jns    6b8 <printint+0x88>
 642:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 646:	74 70                	je     6b8 <printint+0x88>
    x = -xx;
 648:	f7 d8                	neg    %eax
    neg = 1;
 64a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 651:	31 f6                	xor    %esi,%esi
 653:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 656:	eb 0a                	jmp    662 <printint+0x32>
 658:	90                   	nop
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 660:	89 fe                	mov    %edi,%esi
 662:	31 d2                	xor    %edx,%edx
 664:	8d 7e 01             	lea    0x1(%esi),%edi
 667:	f7 f1                	div    %ecx
 669:	0f b6 92 88 0a 00 00 	movzbl 0xa88(%edx),%edx
  }while((x /= base) != 0);
 670:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 672:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 675:	75 e9                	jne    660 <printint+0x30>
  if(neg)
 677:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 67a:	85 c0                	test   %eax,%eax
 67c:	74 08                	je     686 <printint+0x56>
    buf[i++] = '-';
 67e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 683:	8d 7e 02             	lea    0x2(%esi),%edi
 686:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 68a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
 690:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 693:	83 ec 04             	sub    $0x4,%esp
 696:	83 ee 01             	sub    $0x1,%esi
 699:	6a 01                	push   $0x1
 69b:	53                   	push   %ebx
 69c:	57                   	push   %edi
 69d:	88 45 d7             	mov    %al,-0x29(%ebp)
 6a0:	e8 bd fe ff ff       	call   562 <write>

  while(--i >= 0)
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	39 de                	cmp    %ebx,%esi
 6aa:	75 e4                	jne    690 <printint+0x60>
    putc(fd, buf[i]);
}
 6ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5f                   	pop    %edi
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6bf:	eb 90                	jmp    651 <printint+0x21>
 6c1:	eb 0d                	jmp    6d0 <printf>
 6c3:	90                   	nop
 6c4:	90                   	nop
 6c5:	90                   	nop
 6c6:	90                   	nop
 6c7:	90                   	nop
 6c8:	90                   	nop
 6c9:	90                   	nop
 6ca:	90                   	nop
 6cb:	90                   	nop
 6cc:	90                   	nop
 6cd:	90                   	nop
 6ce:	90                   	nop
 6cf:	90                   	nop

000006d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 6dc:	0f b6 1e             	movzbl (%esi),%ebx
 6df:	84 db                	test   %bl,%bl
 6e1:	0f 84 b3 00 00 00    	je     79a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 6e7:	8d 45 10             	lea    0x10(%ebp),%eax
 6ea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 6ed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 6ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6f2:	eb 2f                	jmp    723 <printf+0x53>
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6f8:	83 f8 25             	cmp    $0x25,%eax
 6fb:	0f 84 a7 00 00 00    	je     7a8 <printf+0xd8>
  write(fd, &c, 1);
 701:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 704:	83 ec 04             	sub    $0x4,%esp
 707:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 70a:	6a 01                	push   $0x1
 70c:	50                   	push   %eax
 70d:	ff 75 08             	pushl  0x8(%ebp)
 710:	e8 4d fe ff ff       	call   562 <write>
 715:	83 c4 10             	add    $0x10,%esp
 718:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 71b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 71f:	84 db                	test   %bl,%bl
 721:	74 77                	je     79a <printf+0xca>
    if(state == 0){
 723:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 725:	0f be cb             	movsbl %bl,%ecx
 728:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 72b:	74 cb                	je     6f8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72d:	83 ff 25             	cmp    $0x25,%edi
 730:	75 e6                	jne    718 <printf+0x48>
      if(c == 'd'){
 732:	83 f8 64             	cmp    $0x64,%eax
 735:	0f 84 05 01 00 00    	je     840 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 73b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 741:	83 f9 70             	cmp    $0x70,%ecx
 744:	74 72                	je     7b8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 746:	83 f8 73             	cmp    $0x73,%eax
 749:	0f 84 99 00 00 00    	je     7e8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74f:	83 f8 63             	cmp    $0x63,%eax
 752:	0f 84 08 01 00 00    	je     860 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 758:	83 f8 25             	cmp    $0x25,%eax
 75b:	0f 84 ef 00 00 00    	je     850 <printf+0x180>
  write(fd, &c, 1);
 761:	8d 45 e7             	lea    -0x19(%ebp),%eax
 764:	83 ec 04             	sub    $0x4,%esp
 767:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 76b:	6a 01                	push   $0x1
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 ec fd ff ff       	call   562 <write>
 776:	83 c4 0c             	add    $0xc,%esp
 779:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 77c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 77f:	6a 01                	push   $0x1
 781:	50                   	push   %eax
 782:	ff 75 08             	pushl  0x8(%ebp)
 785:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 788:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 78a:	e8 d3 fd ff ff       	call   562 <write>
  for(i = 0; fmt[i]; i++){
 78f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 793:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 796:	84 db                	test   %bl,%bl
 798:	75 89                	jne    723 <printf+0x53>
    }
  }
}
 79a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 79d:	5b                   	pop    %ebx
 79e:	5e                   	pop    %esi
 79f:	5f                   	pop    %edi
 7a0:	5d                   	pop    %ebp
 7a1:	c3                   	ret    
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 7a8:	bf 25 00 00 00       	mov    $0x25,%edi
 7ad:	e9 66 ff ff ff       	jmp    718 <printf+0x48>
 7b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7b8:	83 ec 0c             	sub    $0xc,%esp
 7bb:	b9 10 00 00 00       	mov    $0x10,%ecx
 7c0:	6a 00                	push   $0x0
 7c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	8b 17                	mov    (%edi),%edx
 7ca:	e8 61 fe ff ff       	call   630 <printint>
        ap++;
 7cf:	89 f8                	mov    %edi,%eax
 7d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7d4:	31 ff                	xor    %edi,%edi
        ap++;
 7d6:	83 c0 04             	add    $0x4,%eax
 7d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7dc:	e9 37 ff ff ff       	jmp    718 <printf+0x48>
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7eb:	8b 08                	mov    (%eax),%ecx
        ap++;
 7ed:	83 c0 04             	add    $0x4,%eax
 7f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 7f3:	85 c9                	test   %ecx,%ecx
 7f5:	0f 84 8e 00 00 00    	je     889 <printf+0x1b9>
        while(*s != 0){
 7fb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 7fe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 800:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 802:	84 c0                	test   %al,%al
 804:	0f 84 0e ff ff ff    	je     718 <printf+0x48>
 80a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 80d:	89 de                	mov    %ebx,%esi
 80f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 812:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 815:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 818:	83 ec 04             	sub    $0x4,%esp
          s++;
 81b:	83 c6 01             	add    $0x1,%esi
 81e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 821:	6a 01                	push   $0x1
 823:	57                   	push   %edi
 824:	53                   	push   %ebx
 825:	e8 38 fd ff ff       	call   562 <write>
        while(*s != 0){
 82a:	0f b6 06             	movzbl (%esi),%eax
 82d:	83 c4 10             	add    $0x10,%esp
 830:	84 c0                	test   %al,%al
 832:	75 e4                	jne    818 <printf+0x148>
 834:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 837:	31 ff                	xor    %edi,%edi
 839:	e9 da fe ff ff       	jmp    718 <printf+0x48>
 83e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 840:	83 ec 0c             	sub    $0xc,%esp
 843:	b9 0a 00 00 00       	mov    $0xa,%ecx
 848:	6a 01                	push   $0x1
 84a:	e9 73 ff ff ff       	jmp    7c2 <printf+0xf2>
 84f:	90                   	nop
  write(fd, &c, 1);
 850:	83 ec 04             	sub    $0x4,%esp
 853:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 856:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 859:	6a 01                	push   $0x1
 85b:	e9 21 ff ff ff       	jmp    781 <printf+0xb1>
        putc(fd, *ap);
 860:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 863:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 866:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 868:	6a 01                	push   $0x1
        ap++;
 86a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 86d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 870:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 873:	50                   	push   %eax
 874:	ff 75 08             	pushl  0x8(%ebp)
 877:	e8 e6 fc ff ff       	call   562 <write>
        ap++;
 87c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 87f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 882:	31 ff                	xor    %edi,%edi
 884:	e9 8f fe ff ff       	jmp    718 <printf+0x48>
          s = "(null)";
 889:	bb 7f 0a 00 00       	mov    $0xa7f,%ebx
        while(*s != 0){
 88e:	b8 28 00 00 00       	mov    $0x28,%eax
 893:	e9 72 ff ff ff       	jmp    80a <printf+0x13a>
 898:	66 90                	xchg   %ax,%ax
 89a:	66 90                	xchg   %ax,%ax
 89c:	66 90                	xchg   %ax,%ax
 89e:	66 90                	xchg   %ax,%ax

000008a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a1:	a1 04 0e 00 00       	mov    0xe04,%eax
{
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	57                   	push   %edi
 8a9:	56                   	push   %esi
 8aa:	53                   	push   %ebx
 8ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	39 c8                	cmp    %ecx,%eax
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	73 32                	jae    8f0 <free+0x50>
 8be:	39 d1                	cmp    %edx,%ecx
 8c0:	72 04                	jb     8c6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	39 d0                	cmp    %edx,%eax
 8c4:	72 32                	jb     8f8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8cc:	39 fa                	cmp    %edi,%edx
 8ce:	74 30                	je     900 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8d3:	8b 50 04             	mov    0x4(%eax),%edx
 8d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d9:	39 f1                	cmp    %esi,%ecx
 8db:	74 3a                	je     917 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8dd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8df:	a3 04 0e 00 00       	mov    %eax,0xe04
}
 8e4:	5b                   	pop    %ebx
 8e5:	5e                   	pop    %esi
 8e6:	5f                   	pop    %edi
 8e7:	5d                   	pop    %ebp
 8e8:	c3                   	ret    
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f0:	39 d0                	cmp    %edx,%eax
 8f2:	72 04                	jb     8f8 <free+0x58>
 8f4:	39 d1                	cmp    %edx,%ecx
 8f6:	72 ce                	jb     8c6 <free+0x26>
{
 8f8:	89 d0                	mov    %edx,%eax
 8fa:	eb bc                	jmp    8b8 <free+0x18>
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 900:	03 72 04             	add    0x4(%edx),%esi
 903:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 906:	8b 10                	mov    (%eax),%edx
 908:	8b 12                	mov    (%edx),%edx
 90a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 90d:	8b 50 04             	mov    0x4(%eax),%edx
 910:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 913:	39 f1                	cmp    %esi,%ecx
 915:	75 c6                	jne    8dd <free+0x3d>
    p->s.size += bp->s.size;
 917:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 91a:	a3 04 0e 00 00       	mov    %eax,0xe04
    p->s.size += bp->s.size;
 91f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 922:	8b 53 f8             	mov    -0x8(%ebx),%edx
 925:	89 10                	mov    %edx,(%eax)
}
 927:	5b                   	pop    %ebx
 928:	5e                   	pop    %esi
 929:	5f                   	pop    %edi
 92a:	5d                   	pop    %ebp
 92b:	c3                   	ret    
 92c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000930 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 930:	55                   	push   %ebp
 931:	89 e5                	mov    %esp,%ebp
 933:	57                   	push   %edi
 934:	56                   	push   %esi
 935:	53                   	push   %ebx
 936:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 939:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 93c:	8b 15 04 0e 00 00    	mov    0xe04,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 942:	8d 78 07             	lea    0x7(%eax),%edi
 945:	c1 ef 03             	shr    $0x3,%edi
 948:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 94b:	85 d2                	test   %edx,%edx
 94d:	0f 84 9d 00 00 00    	je     9f0 <malloc+0xc0>
 953:	8b 02                	mov    (%edx),%eax
 955:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 958:	39 cf                	cmp    %ecx,%edi
 95a:	76 6c                	jbe    9c8 <malloc+0x98>
 95c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 962:	bb 00 10 00 00       	mov    $0x1000,%ebx
 967:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 96a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 971:	eb 0e                	jmp    981 <malloc+0x51>
 973:	90                   	nop
 974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 978:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 97a:	8b 48 04             	mov    0x4(%eax),%ecx
 97d:	39 f9                	cmp    %edi,%ecx
 97f:	73 47                	jae    9c8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 981:	39 05 04 0e 00 00    	cmp    %eax,0xe04
 987:	89 c2                	mov    %eax,%edx
 989:	75 ed                	jne    978 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	56                   	push   %esi
 98f:	e8 36 fc ff ff       	call   5ca <sbrk>
  if(p == (char*)-1)
 994:	83 c4 10             	add    $0x10,%esp
 997:	83 f8 ff             	cmp    $0xffffffff,%eax
 99a:	74 1c                	je     9b8 <malloc+0x88>
  hp->s.size = nu;
 99c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 99f:	83 ec 0c             	sub    $0xc,%esp
 9a2:	83 c0 08             	add    $0x8,%eax
 9a5:	50                   	push   %eax
 9a6:	e8 f5 fe ff ff       	call   8a0 <free>
  return freep;
 9ab:	8b 15 04 0e 00 00    	mov    0xe04,%edx
      if((p = morecore(nunits)) == 0)
 9b1:	83 c4 10             	add    $0x10,%esp
 9b4:	85 d2                	test   %edx,%edx
 9b6:	75 c0                	jne    978 <malloc+0x48>
        return 0;
  }
}
 9b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9bb:	31 c0                	xor    %eax,%eax
}
 9bd:	5b                   	pop    %ebx
 9be:	5e                   	pop    %esi
 9bf:	5f                   	pop    %edi
 9c0:	5d                   	pop    %ebp
 9c1:	c3                   	ret    
 9c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9c8:	39 cf                	cmp    %ecx,%edi
 9ca:	74 54                	je     a20 <malloc+0xf0>
        p->s.size -= nunits;
 9cc:	29 f9                	sub    %edi,%ecx
 9ce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9d4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9d7:	89 15 04 0e 00 00    	mov    %edx,0xe04
}
 9dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9e0:	83 c0 08             	add    $0x8,%eax
}
 9e3:	5b                   	pop    %ebx
 9e4:	5e                   	pop    %esi
 9e5:	5f                   	pop    %edi
 9e6:	5d                   	pop    %ebp
 9e7:	c3                   	ret    
 9e8:	90                   	nop
 9e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 9f0:	c7 05 04 0e 00 00 08 	movl   $0xe08,0xe04
 9f7:	0e 00 00 
 9fa:	c7 05 08 0e 00 00 08 	movl   $0xe08,0xe08
 a01:	0e 00 00 
    base.s.size = 0;
 a04:	b8 08 0e 00 00       	mov    $0xe08,%eax
 a09:	c7 05 0c 0e 00 00 00 	movl   $0x0,0xe0c
 a10:	00 00 00 
 a13:	e9 44 ff ff ff       	jmp    95c <malloc+0x2c>
 a18:	90                   	nop
 a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a20:	8b 08                	mov    (%eax),%ecx
 a22:	89 0a                	mov    %ecx,(%edx)
 a24:	eb b1                	jmp    9d7 <malloc+0xa7>
