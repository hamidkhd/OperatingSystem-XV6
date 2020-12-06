
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
char *argv[] = { "sh", 0 };
char *arg[] = { "print_trace", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;
  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 98 08 00 00       	push   $0x898
  19:	e8 d4 03 00 00       	call   3f2 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 07 01 00 00    	js     130 <main+0x130>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 f7 03 00 00       	call   42a <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 eb 03 00 00       	call   42a <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //   exec("print_trace", arg);

    // }
    // else
    // {
      printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 a0 08 00 00       	push   $0x8a0
  50:	6a 01                	push   $0x1
  52:	e8 e9 04 00 00       	call   540 <printf>
      printf(1, "init: starting sh\n");
  57:	58                   	pop    %eax
  58:	5a                   	pop    %edx
  59:	68 a0 08 00 00       	push   $0x8a0
  5e:	6a 01                	push   $0x1
  60:	e8 db 04 00 00       	call   540 <printf>
      printf(1, "***********************************\n");
  65:	59                   	pop    %ecx
  66:	5b                   	pop    %ebx
  67:	68 48 09 00 00       	push   $0x948
  6c:	6a 01                	push   $0x1
  6e:	e8 cd 04 00 00       	call   540 <printf>
      printf(1, "Group Members:\n");
  73:	58                   	pop    %eax
  74:	5a                   	pop    %edx
  75:	68 b3 08 00 00       	push   $0x8b3
  7a:	6a 01                	push   $0x1
  7c:	e8 bf 04 00 00       	call   540 <printf>
      printf(1, "1- Melika Morafegh\n");
  81:	59                   	pop    %ecx
  82:	5b                   	pop    %ebx
  83:	68 c3 08 00 00       	push   $0x8c3
  88:	6a 01                	push   $0x1
  8a:	e8 b1 04 00 00       	call   540 <printf>
      printf(1, "2- Nazanin Yousefian\n");
  8f:	58                   	pop    %eax
  90:	5a                   	pop    %edx
  91:	68 d7 08 00 00       	push   $0x8d7
  96:	6a 01                	push   $0x1
  98:	e8 a3 04 00 00       	call   540 <printf>
      printf(1, "3- Hamidreza Khodadadi\n");
  9d:	59                   	pop    %ecx
  9e:	5b                   	pop    %ebx
  9f:	68 ed 08 00 00       	push   $0x8ed
  a4:	6a 01                	push   $0x1
  a6:	e8 95 04 00 00       	call   540 <printf>
      printf(1, "***********************************\n");
  ab:	58                   	pop    %eax
  ac:	5a                   	pop    %edx
  ad:	68 48 09 00 00       	push   $0x948
  b2:	6a 01                	push   $0x1
  b4:	e8 87 04 00 00       	call   540 <printf>
      
      pid = fork();
  b9:	e8 ec 02 00 00       	call   3aa <fork>
      if(pid < 0){
  be:	83 c4 10             	add    $0x10,%esp
  c1:	85 c0                	test   %eax,%eax
      pid = fork();
  c3:	89 c3                	mov    %eax,%ebx
      if(pid < 0){
  c5:	78 32                	js     f9 <main+0xf9>
        printf(1, "init: fork failed\n");
        exit();
      }
      if(pid == 0){
  c7:	74 43                	je     10c <main+0x10c>
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        exec("sh", argv);
        printf(1, "init: exec sh failed\n");
        exit();
      }
     
      while((wpid=wait()) >= 0 && wpid != pid)// && wpid != poo)
  d0:	e8 e5 02 00 00       	call   3ba <wait>
  d5:	85 c0                	test   %eax,%eax
  d7:	0f 88 6b ff ff ff    	js     48 <main+0x48>
  dd:	39 c3                	cmp    %eax,%ebx
  df:	0f 84 63 ff ff ff    	je     48 <main+0x48>
        printf(1, "zombie!\n");
  e5:	83 ec 08             	sub    $0x8,%esp
  e8:	68 31 09 00 00       	push   $0x931
  ed:	6a 01                	push   $0x1
  ef:	e8 4c 04 00 00       	call   540 <printf>
  f4:	83 c4 10             	add    $0x10,%esp
  f7:	eb d7                	jmp    d0 <main+0xd0>
        printf(1, "init: fork failed\n");
  f9:	53                   	push   %ebx
  fa:	53                   	push   %ebx
  fb:	68 05 09 00 00       	push   $0x905
 100:	6a 01                	push   $0x1
 102:	e8 39 04 00 00       	call   540 <printf>
        exit();
 107:	e8 a6 02 00 00       	call   3b2 <exit>
        exec("sh", argv);
 10c:	50                   	push   %eax
 10d:	50                   	push   %eax
 10e:	68 28 0c 00 00       	push   $0xc28
 113:	68 18 09 00 00       	push   $0x918
 118:	e8 cd 02 00 00       	call   3ea <exec>
        printf(1, "init: exec sh failed\n");
 11d:	5a                   	pop    %edx
 11e:	59                   	pop    %ecx
 11f:	68 1b 09 00 00       	push   $0x91b
 124:	6a 01                	push   $0x1
 126:	e8 15 04 00 00       	call   540 <printf>
        exit();
 12b:	e8 82 02 00 00       	call   3b2 <exit>
    mknod("console", 1, 1);
 130:	51                   	push   %ecx
 131:	6a 01                	push   $0x1
 133:	6a 01                	push   $0x1
 135:	68 98 08 00 00       	push   $0x898
 13a:	e8 bb 02 00 00       	call   3fa <mknod>
    open("console", O_RDWR);
 13f:	5b                   	pop    %ebx
 140:	58                   	pop    %eax
 141:	6a 02                	push   $0x2
 143:	68 98 08 00 00       	push   $0x898
 148:	e8 a5 02 00 00       	call   3f2 <open>
 14d:	83 c4 10             	add    $0x10,%esp
 150:	e9 d4 fe ff ff       	jmp    29 <main+0x29>
 155:	66 90                	xchg   %ax,%ax
 157:	66 90                	xchg   %ax,%ax
 159:	66 90                	xchg   %ax,%ax
 15b:	66 90                	xchg   %ax,%ax
 15d:	66 90                	xchg   %ax,%ax
 15f:	90                   	nop

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	83 c1 01             	add    $0x1,%ecx
 173:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 db                	test   %bl,%bl
 17c:	88 5a ff             	mov    %bl,-0x1(%edx)
 17f:	75 ef                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 181:	5b                   	pop    %ebx
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 55 08             	mov    0x8(%ebp),%edx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	0f b6 19             	movzbl (%ecx),%ebx
 1a0:	84 c0                	test   %al,%al
 1a2:	75 1c                	jne    1c0 <strcmp+0x30>
 1a4:	eb 2a                	jmp    1d0 <strcmp+0x40>
 1a6:	8d 76 00             	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1b6:	83 c1 01             	add    $0x1,%ecx
 1b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1bc:	84 c0                	test   %al,%al
 1be:	74 10                	je     1d0 <strcmp+0x40>
 1c0:	38 d8                	cmp    %bl,%al
 1c2:	74 ec                	je     1b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1c4:	29 d8                	sub    %ebx,%eax
}
 1c6:	5b                   	pop    %ebx
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1d2:	29 d8                	sub    %ebx,%eax
}
 1d4:	5b                   	pop    %ebx
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strlen>:

uint
strlen(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 23a:	0f b6 10             	movzbl (%eax),%edx
 23d:	84 d2                	test   %dl,%dl
 23f:	74 1d                	je     25e <strchr+0x2e>
    if(*s == c)
 241:	38 d3                	cmp    %dl,%bl
 243:	89 d9                	mov    %ebx,%ecx
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
 275:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	31 f6                	xor    %esi,%esi
 278:	89 f3                	mov    %esi,%ebx
{
 27a:	83 ec 1c             	sub    $0x1c,%esp
 27d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 280:	eb 2f                	jmp    2b1 <gets+0x41>
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 288:	8d 45 e7             	lea    -0x19(%ebp),%eax
 28b:	83 ec 04             	sub    $0x4,%esp
 28e:	6a 01                	push   $0x1
 290:	50                   	push   %eax
 291:	6a 00                	push   $0x0
 293:	e8 32 01 00 00       	call   3ca <read>
    if(cc < 1)
 298:	83 c4 10             	add    $0x10,%esp
 29b:	85 c0                	test   %eax,%eax
 29d:	7e 1c                	jle    2bb <gets+0x4b>
      break;
    buf[i++] = c;
 29f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a3:	83 c7 01             	add    $0x1,%edi
 2a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2a9:	3c 0a                	cmp    $0xa,%al
 2ab:	74 23                	je     2d0 <gets+0x60>
 2ad:	3c 0d                	cmp    $0xd,%al
 2af:	74 1f                	je     2d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 2b1:	83 c3 01             	add    $0x1,%ebx
 2b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b7:	89 fe                	mov    %edi,%esi
 2b9:	7c cd                	jl     288 <gets+0x18>
 2bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    
 2cb:	90                   	nop
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d0:	8b 75 08             	mov    0x8(%ebp),%esi
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	01 de                	add    %ebx,%esi
 2d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2da:	c6 03 00             	movb   $0x0,(%ebx)
}
 2dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e0:	5b                   	pop    %ebx
 2e1:	5e                   	pop    %esi
 2e2:	5f                   	pop    %edi
 2e3:	5d                   	pop    %ebp
 2e4:	c3                   	ret    
 2e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	pushl  0x8(%ebp)
 2fd:	e8 f0 00 00 00       	call   3f2 <open>
  if(fd < 0)
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	pushl  0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f3 00 00 00       	call   40a <fstat>
  close(fd);
 317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31a:	89 c6                	mov    %eax,%esi
  close(fd);
 31c:	e8 b9 00 00 00       	call   3da <close>
  return r;
 321:	83 c4 10             	add    $0x10,%esp
}
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 347:	0f be 11             	movsbl (%ecx),%edx
 34a:	8d 42 d0             	lea    -0x30(%edx),%eax
 34d:	3c 09                	cmp    $0x9,%al
  n = 0;
 34f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 354:	77 1f                	ja     375 <atoi+0x35>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 360:	8d 04 80             	lea    (%eax,%eax,4),%eax
 363:	83 c1 01             	add    $0x1,%ecx
 366:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 36a:	0f be 11             	movsbl (%ecx),%edx
 36d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	5b                   	pop    %ebx
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 5d 10             	mov    0x10(%ebp),%ebx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38e:	85 db                	test   %ebx,%ebx
 390:	7e 14                	jle    3a6 <memmove+0x26>
 392:	31 d2                	xor    %edx,%edx
 394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 398:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 39c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 39f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3a2:	39 d3                	cmp    %edx,%ebx
 3a4:	75 f2                	jne    398 <memmove+0x18>
  return vdst;
}
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5d                   	pop    %ebp
 3a9:	c3                   	ret    

000003aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3aa:	b8 01 00 00 00       	mov    $0x1,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <exit>:
SYSCALL(exit)
 3b2:	b8 02 00 00 00       	mov    $0x2,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <wait>:
SYSCALL(wait)
 3ba:	b8 03 00 00 00       	mov    $0x3,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <pipe>:
SYSCALL(pipe)
 3c2:	b8 04 00 00 00       	mov    $0x4,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <read>:
SYSCALL(read)
 3ca:	b8 05 00 00 00       	mov    $0x5,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <write>:
SYSCALL(write)
 3d2:	b8 10 00 00 00       	mov    $0x10,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <close>:
SYSCALL(close)
 3da:	b8 15 00 00 00       	mov    $0x15,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <kill>:
SYSCALL(kill)
 3e2:	b8 06 00 00 00       	mov    $0x6,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <exec>:
SYSCALL(exec)
 3ea:	b8 07 00 00 00       	mov    $0x7,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <open>:
SYSCALL(open)
 3f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <mknod>:
SYSCALL(mknod)
 3fa:	b8 11 00 00 00       	mov    $0x11,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <unlink>:
SYSCALL(unlink)
 402:	b8 12 00 00 00       	mov    $0x12,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <fstat>:
SYSCALL(fstat)
 40a:	b8 08 00 00 00       	mov    $0x8,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <link>:
SYSCALL(link)
 412:	b8 13 00 00 00       	mov    $0x13,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <mkdir>:
SYSCALL(mkdir)
 41a:	b8 14 00 00 00       	mov    $0x14,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <chdir>:
SYSCALL(chdir)
 422:	b8 09 00 00 00       	mov    $0x9,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <dup>:
SYSCALL(dup)
 42a:	b8 0a 00 00 00       	mov    $0xa,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <getpid>:
SYSCALL(getpid)
 432:	b8 0b 00 00 00       	mov    $0xb,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <sbrk>:
SYSCALL(sbrk)
 43a:	b8 0c 00 00 00       	mov    $0xc,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sleep>:
SYSCALL(sleep)
 442:	b8 0d 00 00 00       	mov    $0xd,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <uptime>:
SYSCALL(uptime)
 44a:	b8 0e 00 00 00       	mov    $0xe,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <trace_syscalls>:
SYSCALL(trace_syscalls)
 452:	b8 16 00 00 00       	mov    $0x16,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <reverse_number>:
SYSCALL(reverse_number)
 45a:	b8 17 00 00 00       	mov    $0x17,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <get_children>:
SYSCALL(get_children)
 462:	b8 18 00 00 00       	mov    $0x18,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <change_process_queue>:
SYSCALL(change_process_queue)
 46a:	b8 19 00 00 00       	mov    $0x19,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <quantify_lottery_tickets>:
SYSCALL(quantify_lottery_tickets)
 472:	b8 1a 00 00 00       	mov    $0x1a,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <quantify_BJF_parameters_process_level>:
SYSCALL(quantify_BJF_parameters_process_level)
 47a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <quantify_BJF_parameters_kernel_level>:
SYSCALL(quantify_BJF_parameters_kernel_level)
 482:	b8 1c 00 00 00       	mov    $0x1c,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <print_information>:
 48a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    
 492:	66 90                	xchg   %ax,%ax
 494:	66 90                	xchg   %ax,%ax
 496:	66 90                	xchg   %ax,%ax
 498:	66 90                	xchg   %ax,%ax
 49a:	66 90                	xchg   %ax,%ax
 49c:	66 90                	xchg   %ax,%ax
 49e:	66 90                	xchg   %ax,%ax

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a9:	85 d2                	test   %edx,%edx
{
 4ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 4ae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 4b0:	79 76                	jns    528 <printint+0x88>
 4b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4b6:	74 70                	je     528 <printint+0x88>
    x = -xx;
 4b8:	f7 d8                	neg    %eax
    neg = 1;
 4ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4c1:	31 f6                	xor    %esi,%esi
 4c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4c6:	eb 0a                	jmp    4d2 <printint+0x32>
 4c8:	90                   	nop
 4c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	89 fe                	mov    %edi,%esi
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	8d 7e 01             	lea    0x1(%esi),%edi
 4d7:	f7 f1                	div    %ecx
 4d9:	0f b6 92 78 09 00 00 	movzbl 0x978(%edx),%edx
  }while((x /= base) != 0);
 4e0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 4e5:	75 e9                	jne    4d0 <printint+0x30>
  if(neg)
 4e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4ea:	85 c0                	test   %eax,%eax
 4ec:	74 08                	je     4f6 <printint+0x56>
    buf[i++] = '-';
 4ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 4f3:	8d 7e 02             	lea    0x2(%esi),%edi
 4f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 4fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 503:	83 ec 04             	sub    $0x4,%esp
 506:	83 ee 01             	sub    $0x1,%esi
 509:	6a 01                	push   $0x1
 50b:	53                   	push   %ebx
 50c:	57                   	push   %edi
 50d:	88 45 d7             	mov    %al,-0x29(%ebp)
 510:	e8 bd fe ff ff       	call   3d2 <write>

  while(--i >= 0)
 515:	83 c4 10             	add    $0x10,%esp
 518:	39 de                	cmp    %ebx,%esi
 51a:	75 e4                	jne    500 <printint+0x60>
    putc(fd, buf[i]);
}
 51c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51f:	5b                   	pop    %ebx
 520:	5e                   	pop    %esi
 521:	5f                   	pop    %edi
 522:	5d                   	pop    %ebp
 523:	c3                   	ret    
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 528:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 52f:	eb 90                	jmp    4c1 <printint+0x21>
 531:	eb 0d                	jmp    540 <printf>
 533:	90                   	nop
 534:	90                   	nop
 535:	90                   	nop
 536:	90                   	nop
 537:	90                   	nop
 538:	90                   	nop
 539:	90                   	nop
 53a:	90                   	nop
 53b:	90                   	nop
 53c:	90                   	nop
 53d:	90                   	nop
 53e:	90                   	nop
 53f:	90                   	nop

00000540 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 549:	8b 75 0c             	mov    0xc(%ebp),%esi
 54c:	0f b6 1e             	movzbl (%esi),%ebx
 54f:	84 db                	test   %bl,%bl
 551:	0f 84 b3 00 00 00    	je     60a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 557:	8d 45 10             	lea    0x10(%ebp),%eax
 55a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 55d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 55f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 562:	eb 2f                	jmp    593 <printf+0x53>
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	0f 84 a7 00 00 00    	je     618 <printf+0xd8>
  write(fd, &c, 1);
 571:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 574:	83 ec 04             	sub    $0x4,%esp
 577:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 57a:	6a 01                	push   $0x1
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 4d fe ff ff       	call   3d2 <write>
 585:	83 c4 10             	add    $0x10,%esp
 588:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 58b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 58f:	84 db                	test   %bl,%bl
 591:	74 77                	je     60a <printf+0xca>
    if(state == 0){
 593:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 595:	0f be cb             	movsbl %bl,%ecx
 598:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 59b:	74 cb                	je     568 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 59d:	83 ff 25             	cmp    $0x25,%edi
 5a0:	75 e6                	jne    588 <printf+0x48>
      if(c == 'd'){
 5a2:	83 f8 64             	cmp    $0x64,%eax
 5a5:	0f 84 05 01 00 00    	je     6b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5b1:	83 f9 70             	cmp    $0x70,%ecx
 5b4:	74 72                	je     628 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5b6:	83 f8 73             	cmp    $0x73,%eax
 5b9:	0f 84 99 00 00 00    	je     658 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5bf:	83 f8 63             	cmp    $0x63,%eax
 5c2:	0f 84 08 01 00 00    	je     6d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	0f 84 ef 00 00 00    	je     6c0 <printf+0x180>
  write(fd, &c, 1);
 5d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5d4:	83 ec 04             	sub    $0x4,%esp
 5d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5db:	6a 01                	push   $0x1
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 ec fd ff ff       	call   3d2 <write>
 5e6:	83 c4 0c             	add    $0xc,%esp
 5e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5ef:	6a 01                	push   $0x1
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5fa:	e8 d3 fd ff ff       	call   3d2 <write>
  for(i = 0; fmt[i]; i++){
 5ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 603:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 606:	84 db                	test   %bl,%bl
 608:	75 89                	jne    593 <printf+0x53>
    }
  }
}
 60a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60d:	5b                   	pop    %ebx
 60e:	5e                   	pop    %esi
 60f:	5f                   	pop    %edi
 610:	5d                   	pop    %ebp
 611:	c3                   	ret    
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 618:	bf 25 00 00 00       	mov    $0x25,%edi
 61d:	e9 66 ff ff ff       	jmp    588 <printf+0x48>
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 628:	83 ec 0c             	sub    $0xc,%esp
 62b:	b9 10 00 00 00       	mov    $0x10,%ecx
 630:	6a 00                	push   $0x0
 632:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	8b 17                	mov    (%edi),%edx
 63a:	e8 61 fe ff ff       	call   4a0 <printint>
        ap++;
 63f:	89 f8                	mov    %edi,%eax
 641:	83 c4 10             	add    $0x10,%esp
      state = 0;
 644:	31 ff                	xor    %edi,%edi
        ap++;
 646:	83 c0 04             	add    $0x4,%eax
 649:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 64c:	e9 37 ff ff ff       	jmp    588 <printf+0x48>
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 65b:	8b 08                	mov    (%eax),%ecx
        ap++;
 65d:	83 c0 04             	add    $0x4,%eax
 660:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 663:	85 c9                	test   %ecx,%ecx
 665:	0f 84 8e 00 00 00    	je     6f9 <printf+0x1b9>
        while(*s != 0){
 66b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 66e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 670:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 672:	84 c0                	test   %al,%al
 674:	0f 84 0e ff ff ff    	je     588 <printf+0x48>
 67a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 67d:	89 de                	mov    %ebx,%esi
 67f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 682:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 685:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 688:	83 ec 04             	sub    $0x4,%esp
          s++;
 68b:	83 c6 01             	add    $0x1,%esi
 68e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 691:	6a 01                	push   $0x1
 693:	57                   	push   %edi
 694:	53                   	push   %ebx
 695:	e8 38 fd ff ff       	call   3d2 <write>
        while(*s != 0){
 69a:	0f b6 06             	movzbl (%esi),%eax
 69d:	83 c4 10             	add    $0x10,%esp
 6a0:	84 c0                	test   %al,%al
 6a2:	75 e4                	jne    688 <printf+0x148>
 6a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6a7:	31 ff                	xor    %edi,%edi
 6a9:	e9 da fe ff ff       	jmp    588 <printf+0x48>
 6ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6b8:	6a 01                	push   $0x1
 6ba:	e9 73 ff ff ff       	jmp    632 <printf+0xf2>
 6bf:	90                   	nop
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6c9:	6a 01                	push   $0x1
 6cb:	e9 21 ff ff ff       	jmp    5f1 <printf+0xb1>
        putc(fd, *ap);
 6d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
        ap++;
 6da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 6dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6e3:	50                   	push   %eax
 6e4:	ff 75 08             	pushl  0x8(%ebp)
 6e7:	e8 e6 fc ff ff       	call   3d2 <write>
        ap++;
 6ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f2:	31 ff                	xor    %edi,%edi
 6f4:	e9 8f fe ff ff       	jmp    588 <printf+0x48>
          s = "(null)";
 6f9:	bb 70 09 00 00       	mov    $0x970,%ebx
        while(*s != 0){
 6fe:	b8 28 00 00 00       	mov    $0x28,%eax
 703:	e9 72 ff ff ff       	jmp    67a <printf+0x13a>
 708:	66 90                	xchg   %ax,%ax
 70a:	66 90                	xchg   %ax,%ax
 70c:	66 90                	xchg   %ax,%ax
 70e:	66 90                	xchg   %ax,%ax

00000710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 710:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	a1 30 0c 00 00       	mov    0xc30,%eax
{
 716:	89 e5                	mov    %esp,%ebp
 718:	57                   	push   %edi
 719:	56                   	push   %esi
 71a:	53                   	push   %ebx
 71b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 71e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	39 c8                	cmp    %ecx,%eax
 72a:	8b 10                	mov    (%eax),%edx
 72c:	73 32                	jae    760 <free+0x50>
 72e:	39 d1                	cmp    %edx,%ecx
 730:	72 04                	jb     736 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	39 d0                	cmp    %edx,%eax
 734:	72 32                	jb     768 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 736:	8b 73 fc             	mov    -0x4(%ebx),%esi
 739:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73c:	39 fa                	cmp    %edi,%edx
 73e:	74 30                	je     770 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 740:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 749:	39 f1                	cmp    %esi,%ecx
 74b:	74 3a                	je     787 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 74d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 74f:	a3 30 0c 00 00       	mov    %eax,0xc30
}
 754:	5b                   	pop    %ebx
 755:	5e                   	pop    %esi
 756:	5f                   	pop    %edi
 757:	5d                   	pop    %ebp
 758:	c3                   	ret    
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	39 d0                	cmp    %edx,%eax
 762:	72 04                	jb     768 <free+0x58>
 764:	39 d1                	cmp    %edx,%ecx
 766:	72 ce                	jb     736 <free+0x26>
{
 768:	89 d0                	mov    %edx,%eax
 76a:	eb bc                	jmp    728 <free+0x18>
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 770:	03 72 04             	add    0x4(%edx),%esi
 773:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 12                	mov    (%edx),%edx
 77a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 783:	39 f1                	cmp    %esi,%ecx
 785:	75 c6                	jne    74d <free+0x3d>
    p->s.size += bp->s.size;
 787:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 78a:	a3 30 0c 00 00       	mov    %eax,0xc30
    p->s.size += bp->s.size;
 78f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 792:	8b 53 f8             	mov    -0x8(%ebx),%edx
 795:	89 10                	mov    %edx,(%eax)
}
 797:	5b                   	pop    %ebx
 798:	5e                   	pop    %esi
 799:	5f                   	pop    %edi
 79a:	5d                   	pop    %ebp
 79b:	c3                   	ret    
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ac:	8b 15 30 0c 00 00    	mov    0xc30,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	8d 78 07             	lea    0x7(%eax),%edi
 7b5:	c1 ef 03             	shr    $0x3,%edi
 7b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7bb:	85 d2                	test   %edx,%edx
 7bd:	0f 84 9d 00 00 00    	je     860 <malloc+0xc0>
 7c3:	8b 02                	mov    (%edx),%eax
 7c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7c8:	39 cf                	cmp    %ecx,%edi
 7ca:	76 6c                	jbe    838 <malloc+0x98>
 7cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7e1:	eb 0e                	jmp    7f1 <malloc+0x51>
 7e3:	90                   	nop
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7ea:	8b 48 04             	mov    0x4(%eax),%ecx
 7ed:	39 f9                	cmp    %edi,%ecx
 7ef:	73 47                	jae    838 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f1:	39 05 30 0c 00 00    	cmp    %eax,0xc30
 7f7:	89 c2                	mov    %eax,%edx
 7f9:	75 ed                	jne    7e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	56                   	push   %esi
 7ff:	e8 36 fc ff ff       	call   43a <sbrk>
  if(p == (char*)-1)
 804:	83 c4 10             	add    $0x10,%esp
 807:	83 f8 ff             	cmp    $0xffffffff,%eax
 80a:	74 1c                	je     828 <malloc+0x88>
  hp->s.size = nu;
 80c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	83 c0 08             	add    $0x8,%eax
 815:	50                   	push   %eax
 816:	e8 f5 fe ff ff       	call   710 <free>
  return freep;
 81b:	8b 15 30 0c 00 00    	mov    0xc30,%edx
      if((p = morecore(nunits)) == 0)
 821:	83 c4 10             	add    $0x10,%esp
 824:	85 d2                	test   %edx,%edx
 826:	75 c0                	jne    7e8 <malloc+0x48>
        return 0;
  }
}
 828:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 82b:	31 c0                	xor    %eax,%eax
}
 82d:	5b                   	pop    %ebx
 82e:	5e                   	pop    %esi
 82f:	5f                   	pop    %edi
 830:	5d                   	pop    %ebp
 831:	c3                   	ret    
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 838:	39 cf                	cmp    %ecx,%edi
 83a:	74 54                	je     890 <malloc+0xf0>
        p->s.size -= nunits;
 83c:	29 f9                	sub    %edi,%ecx
 83e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 841:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 844:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 847:	89 15 30 0c 00 00    	mov    %edx,0xc30
}
 84d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 850:	83 c0 08             	add    $0x8,%eax
}
 853:	5b                   	pop    %ebx
 854:	5e                   	pop    %esi
 855:	5f                   	pop    %edi
 856:	5d                   	pop    %ebp
 857:	c3                   	ret    
 858:	90                   	nop
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 860:	c7 05 30 0c 00 00 34 	movl   $0xc34,0xc30
 867:	0c 00 00 
 86a:	c7 05 34 0c 00 00 34 	movl   $0xc34,0xc34
 871:	0c 00 00 
    base.s.size = 0;
 874:	b8 34 0c 00 00       	mov    $0xc34,%eax
 879:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 880:	00 00 00 
 883:	e9 44 ff ff ff       	jmp    7cc <malloc+0x2c>
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 890:	8b 08                	mov    (%eax),%ecx
 892:	89 0a                	mov    %ecx,(%edx)
 894:	eb b1                	jmp    847 <malloc+0xa7>
