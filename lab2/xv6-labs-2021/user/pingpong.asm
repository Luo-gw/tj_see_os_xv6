
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int main()
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	1880                	addi	s0,sp,112
  int pfd1[2];//parent写->child读
  int pfd2[2];//child写->parent读
  pipe(pfd1);
   a:	fd840513          	addi	a0,s0,-40
   e:	00000097          	auipc	ra,0x0
  12:	36a080e7          	jalr	874(ra) # 378 <pipe>
  pipe(pfd2);
  16:	fd040513          	addi	a0,s0,-48
  1a:	00000097          	auipc	ra,0x0
  1e:	35e080e7          	jalr	862(ra) # 378 <pipe>
  if(fork()!=0)
  22:	00000097          	auipc	ra,0x0
  26:	33e080e7          	jalr	830(ra) # 360 <fork>
  2a:	c535                	beqz	a0,96 <main+0x96>
  {  
  //parent
  int parent_pid=getpid();
  2c:	00000097          	auipc	ra,0x0
  30:	3bc080e7          	jalr	956(ra) # 3e8 <getpid>
  34:	84aa                	mv	s1,a0
  char parent_msg[50];
  close(pfd1[0]);
  36:	fd842503          	lw	a0,-40(s0)
  3a:	00000097          	auipc	ra,0x0
  3e:	356080e7          	jalr	854(ra) # 390 <close>
  close(pfd2[1]);
  42:	fd442503          	lw	a0,-44(s0)
  46:	00000097          	auipc	ra,0x0
  4a:	34a080e7          	jalr	842(ra) # 390 <close>
  //parent send a byte to child by pipe1
  char* ping="a";
  write(pfd1[1],ping,1);
  4e:	4605                	li	a2,1
  50:	00001597          	auipc	a1,0x1
  54:	84058593          	addi	a1,a1,-1984 # 890 <malloc+0xe6>
  58:	fdc42503          	lw	a0,-36(s0)
  5c:	00000097          	auipc	ra,0x0
  60:	32c080e7          	jalr	812(ra) # 388 <write>
  //close pipe write
   if(read(pfd2[0],parent_msg,1)!=0)
  64:	4605                	li	a2,1
  66:	f9840593          	addi	a1,s0,-104
  6a:	fd042503          	lw	a0,-48(s0)
  6e:	00000097          	auipc	ra,0x0
  72:	312080e7          	jalr	786(ra) # 380 <read>
  76:	e511                	bnez	a0,82 <main+0x82>
   {
    printf("%d: received pong\n",parent_pid);
   }
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	2ee080e7          	jalr	750(ra) # 368 <exit>
    printf("%d: received pong\n",parent_pid);
  82:	85a6                	mv	a1,s1
  84:	00001517          	auipc	a0,0x1
  88:	81450513          	addi	a0,a0,-2028 # 898 <malloc+0xee>
  8c:	00000097          	auipc	ra,0x0
  90:	666080e7          	jalr	1638(ra) # 6f2 <printf>
  94:	b7d5                	j	78 <main+0x78>
  }
    else
   {
   //child
   int child_pid=getpid();
  96:	00000097          	auipc	ra,0x0
  9a:	352080e7          	jalr	850(ra) # 3e8 <getpid>
  9e:	84aa                	mv	s1,a0
   char child_msg[50];
   close(pfd1[1]);
  a0:	fdc42503          	lw	a0,-36(s0)
  a4:	00000097          	auipc	ra,0x0
  a8:	2ec080e7          	jalr	748(ra) # 390 <close>
   close(pfd2[0]);
  ac:	fd042503          	lw	a0,-48(s0)
  b0:	00000097          	auipc	ra,0x0
  b4:	2e0080e7          	jalr	736(ra) # 390 <close>
   //child receive byte
   if(read(pfd1[0],child_msg,1)!=0)
  b8:	4605                	li	a2,1
  ba:	f9840593          	addi	a1,s0,-104
  be:	fd842503          	lw	a0,-40(s0)
  c2:	00000097          	auipc	ra,0x0
  c6:	2be080e7          	jalr	702(ra) # 380 <read>
  ca:	ed19                	bnez	a0,e8 <main+0xe8>
  {
   printf("%d: received ping\n",child_pid);
  }
  //close pipe read
  //child send a byte
  write(pfd2[1],child_msg,1);
  cc:	4605                	li	a2,1
  ce:	f9840593          	addi	a1,s0,-104
  d2:	fd442503          	lw	a0,-44(s0)
  d6:	00000097          	auipc	ra,0x0
  da:	2b2080e7          	jalr	690(ra) # 388 <write>
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	288080e7          	jalr	648(ra) # 368 <exit>
   printf("%d: received ping\n",child_pid);
  e8:	85a6                	mv	a1,s1
  ea:	00000517          	auipc	a0,0x0
  ee:	7c650513          	addi	a0,a0,1990 # 8b0 <malloc+0x106>
  f2:	00000097          	auipc	ra,0x0
  f6:	600080e7          	jalr	1536(ra) # 6f2 <printf>
  fa:	bfc9                	j	cc <main+0xcc>

00000000000000fc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
    ;
  return os;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strlen>:

uint
strlen(const char *s)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf91                	beqz	a5,16a <strlen+0x26>
 150:	0505                	addi	a0,a0,1
 152:	87aa                	mv	a5,a0
 154:	4685                	li	a3,1
 156:	9e89                	subw	a3,a3,a0
 158:	00f6853b          	addw	a0,a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	fb7d                	bnez	a4,158 <strlen+0x14>
    ;
  return n;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  for(n = 0; s[n]; n++)
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strlen+0x20>

000000000000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 174:	ca19                	beqz	a2,18a <memset+0x1c>
 176:	87aa                	mv	a5,a0
 178:	1602                	slli	a2,a2,0x20
 17a:	9201                	srli	a2,a2,0x20
 17c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x12>
  }
  return dst;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  for(; *s; s++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
    if(*s == c)
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
  for(; *s; s++)
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
      return (char*)s;
  return 0;
 1a8:	4501                	li	a0,0
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  return 0;
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d863          	bge	s1,s4,20a <gets+0x56>
    cc = read(0, &c, 1);
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	19a080e7          	jalr	410(ra) # 380 <read>
    if(cc < 1)
 1ee:	00a05e63          	blez	a0,20a <gets+0x56>
    buf[i++] = c;
 1f2:	faf44783          	lbu	a5,-81(s0)
 1f6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1fa:	01578763          	beq	a5,s5,208 <gets+0x54>
 1fe:	0905                	addi	s2,s2,1
 200:	fd679be3          	bne	a5,s6,1d6 <gets+0x22>
  for(i=0; i+1 < max; ){
 204:	89a6                	mv	s3,s1
 206:	a011                	j	20a <gets+0x56>
 208:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 20a:	99de                	add	s3,s3,s7
 20c:	00098023          	sb	zero,0(s3)
  return buf;
}
 210:	855e                	mv	a0,s7
 212:	60e6                	ld	ra,88(sp)
 214:	6446                	ld	s0,80(sp)
 216:	64a6                	ld	s1,72(sp)
 218:	6906                	ld	s2,64(sp)
 21a:	79e2                	ld	s3,56(sp)
 21c:	7a42                	ld	s4,48(sp)
 21e:	7aa2                	ld	s5,40(sp)
 220:	7b02                	ld	s6,32(sp)
 222:	6be2                	ld	s7,24(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e426                	sd	s1,8(sp)
 230:	e04a                	sd	s2,0(sp)
 232:	1000                	addi	s0,sp,32
 234:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	4581                	li	a1,0
 238:	00000097          	auipc	ra,0x0
 23c:	170080e7          	jalr	368(ra) # 3a8 <open>
  if(fd < 0)
 240:	02054563          	bltz	a0,26a <stat+0x42>
 244:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 246:	85ca                	mv	a1,s2
 248:	00000097          	auipc	ra,0x0
 24c:	178080e7          	jalr	376(ra) # 3c0 <fstat>
 250:	892a                	mv	s2,a0
  close(fd);
 252:	8526                	mv	a0,s1
 254:	00000097          	auipc	ra,0x0
 258:	13c080e7          	jalr	316(ra) # 390 <close>
  return r;
}
 25c:	854a                	mv	a0,s2
 25e:	60e2                	ld	ra,24(sp)
 260:	6442                	ld	s0,16(sp)
 262:	64a2                	ld	s1,8(sp)
 264:	6902                	ld	s2,0(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret
    return -1;
 26a:	597d                	li	s2,-1
 26c:	bfc5                	j	25c <stat+0x34>

000000000000026e <atoi>:

int
atoi(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 274:	00054683          	lbu	a3,0(a0)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	4625                	li	a2,9
 282:	02f66863          	bltu	a2,a5,2b2 <atoi+0x44>
 286:	872a                	mv	a4,a0
  n = 0;
 288:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28a:	0705                	addi	a4,a4,1
 28c:	0025179b          	slliw	a5,a0,0x2
 290:	9fa9                	addw	a5,a5,a0
 292:	0017979b          	slliw	a5,a5,0x1
 296:	9fb5                	addw	a5,a5,a3
 298:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29c:	00074683          	lbu	a3,0(a4)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	fef671e3          	bgeu	a2,a5,28a <atoi+0x1c>
  return n;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  n = 0;
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <atoi+0x3e>

00000000000002b6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2bc:	02b57463          	bgeu	a0,a1,2e4 <memmove+0x2e>
    while(n-- > 0)
 2c0:	00c05f63          	blez	a2,2de <memmove+0x28>
 2c4:	1602                	slli	a2,a2,0x20
 2c6:	9201                	srli	a2,a2,0x20
 2c8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2cc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ce:	0585                	addi	a1,a1,1
 2d0:	0705                	addi	a4,a4,1
 2d2:	fff5c683          	lbu	a3,-1(a1)
 2d6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2da:	fee79ae3          	bne	a5,a4,2ce <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
    dst += n;
 2e4:	00c50733          	add	a4,a0,a2
    src += n;
 2e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ea:	fec05ae3          	blez	a2,2de <memmove+0x28>
 2ee:	fff6079b          	addiw	a5,a2,-1
 2f2:	1782                	slli	a5,a5,0x20
 2f4:	9381                	srli	a5,a5,0x20
 2f6:	fff7c793          	not	a5,a5
 2fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fc:	15fd                	addi	a1,a1,-1
 2fe:	177d                	addi	a4,a4,-1
 300:	0005c683          	lbu	a3,0(a1)
 304:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 308:	fee79ae3          	bne	a5,a4,2fc <memmove+0x46>
 30c:	bfc9                	j	2de <memmove+0x28>

000000000000030e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 314:	ca05                	beqz	a2,344 <memcmp+0x36>
 316:	fff6069b          	addiw	a3,a2,-1
 31a:	1682                	slli	a3,a3,0x20
 31c:	9281                	srli	a3,a3,0x20
 31e:	0685                	addi	a3,a3,1
 320:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 322:	00054783          	lbu	a5,0(a0)
 326:	0005c703          	lbu	a4,0(a1)
 32a:	00e79863          	bne	a5,a4,33a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32e:	0505                	addi	a0,a0,1
    p2++;
 330:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 332:	fed518e3          	bne	a0,a3,322 <memcmp+0x14>
  }
  return 0;
 336:	4501                	li	a0,0
 338:	a019                	j	33e <memcmp+0x30>
      return *p1 - *p2;
 33a:	40e7853b          	subw	a0,a5,a4
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  return 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <memcmp+0x30>

0000000000000348 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 350:	00000097          	auipc	ra,0x0
 354:	f66080e7          	jalr	-154(ra) # 2b6 <memmove>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 360:	4885                	li	a7,1
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exit>:
.global exit
exit:
 li a7, SYS_exit
 368:	4889                	li	a7,2
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <wait>:
.global wait
wait:
 li a7, SYS_wait
 370:	488d                	li	a7,3
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 378:	4891                	li	a7,4
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <read>:
.global read
read:
 li a7, SYS_read
 380:	4895                	li	a7,5
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <write>:
.global write
write:
 li a7, SYS_write
 388:	48c1                	li	a7,16
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <close>:
.global close
close:
 li a7, SYS_close
 390:	48d5                	li	a7,21
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <kill>:
.global kill
kill:
 li a7, SYS_kill
 398:	4899                	li	a7,6
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a0:	489d                	li	a7,7
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <open>:
.global open
open:
 li a7, SYS_open
 3a8:	48bd                	li	a7,15
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b0:	48c5                	li	a7,17
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b8:	48c9                	li	a7,18
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c0:	48a1                	li	a7,8
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <link>:
.global link
link:
 li a7, SYS_link
 3c8:	48cd                	li	a7,19
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d0:	48d1                	li	a7,20
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d8:	48a5                	li	a7,9
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e0:	48a9                	li	a7,10
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e8:	48ad                	li	a7,11
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f0:	48b1                	li	a7,12
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f8:	48b5                	li	a7,13
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 400:	48b9                	li	a7,14
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <trace>:
.global trace
trace:
 li a7, SYS_trace
 408:	48d9                	li	a7,22
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 410:	48dd                	li	a7,23
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	1000                	addi	s0,sp,32
 420:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 424:	4605                	li	a2,1
 426:	fef40593          	addi	a1,s0,-17
 42a:	00000097          	auipc	ra,0x0
 42e:	f5e080e7          	jalr	-162(ra) # 388 <write>
}
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret

000000000000043a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43a:	7139                	addi	sp,sp,-64
 43c:	fc06                	sd	ra,56(sp)
 43e:	f822                	sd	s0,48(sp)
 440:	f426                	sd	s1,40(sp)
 442:	f04a                	sd	s2,32(sp)
 444:	ec4e                	sd	s3,24(sp)
 446:	0080                	addi	s0,sp,64
 448:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x16>
 44c:	0805c963          	bltz	a1,4de <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 450:	2581                	sext.w	a1,a1
  neg = 0;
 452:	4881                	li	a7,0
 454:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 458:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45a:	2601                	sext.w	a2,a2
 45c:	00000517          	auipc	a0,0x0
 460:	4cc50513          	addi	a0,a0,1228 # 928 <digits>
 464:	883a                	mv	a6,a4
 466:	2705                	addiw	a4,a4,1
 468:	02c5f7bb          	remuw	a5,a1,a2
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	97aa                	add	a5,a5,a0
 472:	0007c783          	lbu	a5,0(a5)
 476:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47a:	0005879b          	sext.w	a5,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	addi	a3,a3,1
 484:	fec7f0e3          	bgeu	a5,a2,464 <printint+0x2a>
  if(neg)
 488:	00088c63          	beqz	a7,4a0 <printint+0x66>
    buf[i++] = '-';
 48c:	fd070793          	addi	a5,a4,-48
 490:	00878733          	add	a4,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef70823          	sb	a5,-16(a4)
 49c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05863          	blez	a4,4d0 <printint+0x96>
 4a4:	fc040793          	addi	a5,s0,-64
 4a8:	00e78933          	add	s2,a5,a4
 4ac:	fff78993          	addi	s3,a5,-1
 4b0:	99ba                	add	s3,s3,a4
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	1702                	slli	a4,a4,0x20
 4b6:	9301                	srli	a4,a4,0x20
 4b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4bc:	fff94583          	lbu	a1,-1(s2)
 4c0:	8526                	mv	a0,s1
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f56080e7          	jalr	-170(ra) # 418 <putc>
  while(--i >= 0)
 4ca:	197d                	addi	s2,s2,-1
 4cc:	ff3918e3          	bne	s2,s3,4bc <printint+0x82>
}
 4d0:	70e2                	ld	ra,56(sp)
 4d2:	7442                	ld	s0,48(sp)
 4d4:	74a2                	ld	s1,40(sp)
 4d6:	7902                	ld	s2,32(sp)
 4d8:	69e2                	ld	s3,24(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf85                	j	454 <printint+0x1a>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	7119                	addi	sp,sp,-128
 4e8:	fc86                	sd	ra,120(sp)
 4ea:	f8a2                	sd	s0,112(sp)
 4ec:	f4a6                	sd	s1,104(sp)
 4ee:	f0ca                	sd	s2,96(sp)
 4f0:	ecce                	sd	s3,88(sp)
 4f2:	e8d2                	sd	s4,80(sp)
 4f4:	e4d6                	sd	s5,72(sp)
 4f6:	e0da                	sd	s6,64(sp)
 4f8:	fc5e                	sd	s7,56(sp)
 4fa:	f862                	sd	s8,48(sp)
 4fc:	f466                	sd	s9,40(sp)
 4fe:	f06a                	sd	s10,32(sp)
 500:	ec6e                	sd	s11,24(sp)
 502:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c903          	lbu	s2,0(a1)
 508:	18090f63          	beqz	s2,6a6 <vprintf+0x1c0>
 50c:	8aaa                	mv	s5,a0
 50e:	8b32                	mv	s6,a2
 510:	00158493          	addi	s1,a1,1
  state = 0;
 514:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 516:	02500a13          	li	s4,37
 51a:	4c55                	li	s8,21
 51c:	00000c97          	auipc	s9,0x0
 520:	3b4c8c93          	addi	s9,s9,948 # 8d0 <malloc+0x126>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 524:	02800d93          	li	s11,40
  putc(fd, 'x');
 528:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52a:	00000b97          	auipc	s7,0x0
 52e:	3feb8b93          	addi	s7,s7,1022 # 928 <digits>
 532:	a839                	j	550 <vprintf+0x6a>
        putc(fd, c);
 534:	85ca                	mv	a1,s2
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	ee0080e7          	jalr	-288(ra) # 418 <putc>
 540:	a019                	j	546 <vprintf+0x60>
    } else if(state == '%'){
 542:	01498d63          	beq	s3,s4,55c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 546:	0485                	addi	s1,s1,1
 548:	fff4c903          	lbu	s2,-1(s1)
 54c:	14090d63          	beqz	s2,6a6 <vprintf+0x1c0>
    if(state == 0){
 550:	fe0999e3          	bnez	s3,542 <vprintf+0x5c>
      if(c == '%'){
 554:	ff4910e3          	bne	s2,s4,534 <vprintf+0x4e>
        state = '%';
 558:	89d2                	mv	s3,s4
 55a:	b7f5                	j	546 <vprintf+0x60>
      if(c == 'd'){
 55c:	11490c63          	beq	s2,s4,674 <vprintf+0x18e>
 560:	f9d9079b          	addiw	a5,s2,-99
 564:	0ff7f793          	zext.b	a5,a5
 568:	10fc6e63          	bltu	s8,a5,684 <vprintf+0x19e>
 56c:	f9d9079b          	addiw	a5,s2,-99
 570:	0ff7f713          	zext.b	a4,a5
 574:	10ec6863          	bltu	s8,a4,684 <vprintf+0x19e>
 578:	00271793          	slli	a5,a4,0x2
 57c:	97e6                	add	a5,a5,s9
 57e:	439c                	lw	a5,0(a5)
 580:	97e6                	add	a5,a5,s9
 582:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 584:	008b0913          	addi	s2,s6,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000b2583          	lw	a1,0(s6)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	ea8080e7          	jalr	-344(ra) # 43a <printint>
 59a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b765                	j	546 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	008b0913          	addi	s2,s6,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000b2583          	lw	a1,0(s6)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e8c080e7          	jalr	-372(ra) # 43a <printint>
 5b6:	8b4a                	mv	s6,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b771                	j	546 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	4681                	li	a3,0
 5c2:	866a                	mv	a2,s10
 5c4:	000b2583          	lw	a1,0(s6)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e70080e7          	jalr	-400(ra) # 43a <printint>
 5d2:	8b4a                	mv	s6,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bf85                	j	546 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5d8:	008b0793          	addi	a5,s6,8
 5dc:	f8f43423          	sd	a5,-120(s0)
 5e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5e4:	03000593          	li	a1,48
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e2e080e7          	jalr	-466(ra) # 418 <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e20080e7          	jalr	-480(ra) # 418 <putc>
 600:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	03c9d793          	srli	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e0a080e7          	jalr	-502(ra) # 418 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	397d                	addiw	s2,s2,-1
 61a:	fe0914e3          	bnez	s2,602 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 61e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 622:	4981                	li	s3,0
 624:	b70d                	j	546 <vprintf+0x60>
        s = va_arg(ap, char*);
 626:	008b0913          	addi	s2,s6,8
 62a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 62e:	02098163          	beqz	s3,650 <vprintf+0x16a>
        while(*s != 0){
 632:	0009c583          	lbu	a1,0(s3)
 636:	c5ad                	beqz	a1,6a0 <vprintf+0x1ba>
          putc(fd, *s);
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	dde080e7          	jalr	-546(ra) # 418 <putc>
          s++;
 642:	0985                	addi	s3,s3,1
        while(*s != 0){
 644:	0009c583          	lbu	a1,0(s3)
 648:	f9e5                	bnez	a1,638 <vprintf+0x152>
        s = va_arg(ap, char*);
 64a:	8b4a                	mv	s6,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bde5                	j	546 <vprintf+0x60>
          s = "(null)";
 650:	00000997          	auipc	s3,0x0
 654:	27898993          	addi	s3,s3,632 # 8c8 <malloc+0x11e>
        while(*s != 0){
 658:	85ee                	mv	a1,s11
 65a:	bff9                	j	638 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 65c:	008b0913          	addi	s2,s6,8
 660:	000b4583          	lbu	a1,0(s6)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	db2080e7          	jalr	-590(ra) # 418 <putc>
 66e:	8b4a                	mv	s6,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bdd1                	j	546 <vprintf+0x60>
        putc(fd, c);
 674:	85d2                	mv	a1,s4
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	da0080e7          	jalr	-608(ra) # 418 <putc>
      state = 0;
 680:	4981                	li	s3,0
 682:	b5d1                	j	546 <vprintf+0x60>
        putc(fd, '%');
 684:	85d2                	mv	a1,s4
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d90080e7          	jalr	-624(ra) # 418 <putc>
        putc(fd, c);
 690:	85ca                	mv	a1,s2
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d84080e7          	jalr	-636(ra) # 418 <putc>
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b565                	j	546 <vprintf+0x60>
        s = va_arg(ap, char*);
 6a0:	8b4a                	mv	s6,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b54d                	j	546 <vprintf+0x60>
    }
  }
}
 6a6:	70e6                	ld	ra,120(sp)
 6a8:	7446                	ld	s0,112(sp)
 6aa:	74a6                	ld	s1,104(sp)
 6ac:	7906                	ld	s2,96(sp)
 6ae:	69e6                	ld	s3,88(sp)
 6b0:	6a46                	ld	s4,80(sp)
 6b2:	6aa6                	ld	s5,72(sp)
 6b4:	6b06                	ld	s6,64(sp)
 6b6:	7be2                	ld	s7,56(sp)
 6b8:	7c42                	ld	s8,48(sp)
 6ba:	7ca2                	ld	s9,40(sp)
 6bc:	7d02                	ld	s10,32(sp)
 6be:	6de2                	ld	s11,24(sp)
 6c0:	6109                	addi	sp,sp,128
 6c2:	8082                	ret

00000000000006c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c4:	715d                	addi	sp,sp,-80
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e010                	sd	a2,0(s0)
 6ce:	e414                	sd	a3,8(s0)
 6d0:	e818                	sd	a4,16(s0)
 6d2:	ec1c                	sd	a5,24(s0)
 6d4:	03043023          	sd	a6,32(s0)
 6d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e0:	8622                	mv	a2,s0
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e04080e7          	jalr	-508(ra) # 4e6 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <printf>:

void
printf(const char *fmt, ...)
{
 6f2:	711d                	addi	sp,sp,-96
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e40c                	sd	a1,8(s0)
 6fc:	e810                	sd	a2,16(s0)
 6fe:	ec14                	sd	a3,24(s0)
 700:	f018                	sd	a4,32(s0)
 702:	f41c                	sd	a5,40(s0)
 704:	03043823          	sd	a6,48(s0)
 708:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	00840613          	addi	a2,s0,8
 710:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 714:	85aa                	mv	a1,a0
 716:	4505                	li	a0,1
 718:	00000097          	auipc	ra,0x0
 71c:	dce080e7          	jalr	-562(ra) # 4e6 <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6125                	addi	sp,sp,96
 726:	8082                	ret

0000000000000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	1141                	addi	sp,sp,-16
 72a:	e422                	sd	s0,8(sp)
 72c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	00000797          	auipc	a5,0x0
 736:	20e7b783          	ld	a5,526(a5) # 940 <freep>
 73a:	a02d                	j	764 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	4618                	lw	a4,8(a2)
 73e:	9f2d                	addw	a4,a4,a1
 740:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	6398                	ld	a4,0(a5)
 746:	6310                	ld	a2,0(a4)
 748:	a83d                	j	786 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74a:	ff852703          	lw	a4,-8(a0)
 74e:	9f31                	addw	a4,a4,a2
 750:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 752:	ff053683          	ld	a3,-16(a0)
 756:	a091                	j	79a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	6398                	ld	a4,0(a5)
 75a:	00e7e463          	bltu	a5,a4,762 <free+0x3a>
 75e:	00e6ea63          	bltu	a3,a4,772 <free+0x4a>
{
 762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	fed7fae3          	bgeu	a5,a3,758 <free+0x30>
 768:	6398                	ld	a4,0(a5)
 76a:	00e6e463          	bltu	a3,a4,772 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fee7eae3          	bltu	a5,a4,762 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 772:	ff852583          	lw	a1,-8(a0)
 776:	6390                	ld	a2,0(a5)
 778:	02059813          	slli	a6,a1,0x20
 77c:	01c85713          	srli	a4,a6,0x1c
 780:	9736                	add	a4,a4,a3
 782:	fae60de3          	beq	a2,a4,73c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78a:	4790                	lw	a2,8(a5)
 78c:	02061593          	slli	a1,a2,0x20
 790:	01c5d713          	srli	a4,a1,0x1c
 794:	973e                	add	a4,a4,a5
 796:	fae68ae3          	beq	a3,a4,74a <free+0x22>
    p->s.ptr = bp->s.ptr;
 79a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79c:	00000717          	auipc	a4,0x0
 7a0:	1af73223          	sd	a5,420(a4) # 940 <freep>
}
 7a4:	6422                	ld	s0,8(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret

00000000000007aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7aa:	7139                	addi	sp,sp,-64
 7ac:	fc06                	sd	ra,56(sp)
 7ae:	f822                	sd	s0,48(sp)
 7b0:	f426                	sd	s1,40(sp)
 7b2:	f04a                	sd	s2,32(sp)
 7b4:	ec4e                	sd	s3,24(sp)
 7b6:	e852                	sd	s4,16(sp)
 7b8:	e456                	sd	s5,8(sp)
 7ba:	e05a                	sd	s6,0(sp)
 7bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	02051493          	slli	s1,a0,0x20
 7c2:	9081                	srli	s1,s1,0x20
 7c4:	04bd                	addi	s1,s1,15
 7c6:	8091                	srli	s1,s1,0x4
 7c8:	0014899b          	addiw	s3,s1,1
 7cc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ce:	00000517          	auipc	a0,0x0
 7d2:	17253503          	ld	a0,370(a0) # 940 <freep>
 7d6:	c515                	beqz	a0,802 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7da:	4798                	lw	a4,8(a5)
 7dc:	02977f63          	bgeu	a4,s1,81a <malloc+0x70>
 7e0:	8a4e                	mv	s4,s3
 7e2:	0009871b          	sext.w	a4,s3
 7e6:	6685                	lui	a3,0x1
 7e8:	00d77363          	bgeu	a4,a3,7ee <malloc+0x44>
 7ec:	6a05                	lui	s4,0x1
 7ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f6:	00000917          	auipc	s2,0x0
 7fa:	14a90913          	addi	s2,s2,330 # 940 <freep>
  if(p == (char*)-1)
 7fe:	5afd                	li	s5,-1
 800:	a895                	j	874 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 802:	00000797          	auipc	a5,0x0
 806:	14678793          	addi	a5,a5,326 # 948 <base>
 80a:	00000717          	auipc	a4,0x0
 80e:	12f73b23          	sd	a5,310(a4) # 940 <freep>
 812:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 814:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 818:	b7e1                	j	7e0 <malloc+0x36>
      if(p->s.size == nunits)
 81a:	02e48c63          	beq	s1,a4,852 <malloc+0xa8>
        p->s.size -= nunits;
 81e:	4137073b          	subw	a4,a4,s3
 822:	c798                	sw	a4,8(a5)
        p += p->s.size;
 824:	02071693          	slli	a3,a4,0x20
 828:	01c6d713          	srli	a4,a3,0x1c
 82c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 832:	00000717          	auipc	a4,0x0
 836:	10a73723          	sd	a0,270(a4) # 940 <freep>
      return (void*)(p + 1);
 83a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 83e:	70e2                	ld	ra,56(sp)
 840:	7442                	ld	s0,48(sp)
 842:	74a2                	ld	s1,40(sp)
 844:	7902                	ld	s2,32(sp)
 846:	69e2                	ld	s3,24(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	6121                	addi	sp,sp,64
 850:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	e118                	sd	a4,0(a0)
 856:	bff1                	j	832 <malloc+0x88>
  hp->s.size = nu;
 858:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85c:	0541                	addi	a0,a0,16
 85e:	00000097          	auipc	ra,0x0
 862:	eca080e7          	jalr	-310(ra) # 728 <free>
  return freep;
 866:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 86a:	d971                	beqz	a0,83e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	fa9775e3          	bgeu	a4,s1,81a <malloc+0x70>
    if(p == freep)
 874:	00093703          	ld	a4,0(s2)
 878:	853e                	mv	a0,a5
 87a:	fef719e3          	bne	a4,a5,86c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 87e:	8552                	mv	a0,s4
 880:	00000097          	auipc	ra,0x0
 884:	b70080e7          	jalr	-1168(ra) # 3f0 <sbrk>
  if(p == (char*)-1)
 888:	fd5518e3          	bne	a0,s5,858 <malloc+0xae>
        return 0;
 88c:	4501                	li	a0,0
 88e:	bf45                	j	83e <malloc+0x94>
