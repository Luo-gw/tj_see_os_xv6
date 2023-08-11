
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"
int readline(char* new_argv[32], int curr_argc) {
   0:	bc010113          	addi	sp,sp,-1088
   4:	42113c23          	sd	ra,1080(sp)
   8:	42813823          	sd	s0,1072(sp)
   c:	42913423          	sd	s1,1064(sp)
  10:	43213023          	sd	s2,1056(sp)
  14:	41313c23          	sd	s3,1048(sp)
  18:	41413823          	sd	s4,1040(sp)
  1c:	41513423          	sd	s5,1032(sp)
  20:	41613023          	sd	s6,1024(sp)
  24:	44010413          	addi	s0,sp,1088
  28:	8b2a                	mv	s6,a0
  2a:	8aae                	mv	s5,a1
	char buf[1024];
	int n = 0;
	while (read(0, buf + n, 1)) {
  2c:	bc040913          	addi	s2,s0,-1088
	int n = 0;
  30:	4481                	li	s1,0
		if (n == 1023)
  32:	3ff00993          	li	s3,1023
		{
			fprintf(2, "argument is too long\n");
			exit(1);
		}
		if (buf[n] == '\n')
  36:	4a29                	li	s4,10
	while (read(0, buf + n, 1)) {
  38:	4605                	li	a2,1
  3a:	85ca                	mv	a1,s2
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	464080e7          	jalr	1124(ra) # 4a2 <read>
  46:	c905                	beqz	a0,76 <readline+0x76>
		if (n == 1023)
  48:	01348963          	beq	s1,s3,5a <readline+0x5a>
		if (buf[n] == '\n')
  4c:	0905                	addi	s2,s2,1
  4e:	fff94783          	lbu	a5,-1(s2)
  52:	03478263          	beq	a5,s4,76 <readline+0x76>
		{
			break;
		}
		n++;
  56:	2485                	addiw	s1,s1,1
  58:	b7c5                	j	38 <readline+0x38>
			fprintf(2, "argument is too long\n");
  5a:	00001597          	auipc	a1,0x1
  5e:	94e58593          	addi	a1,a1,-1714 # 9a8 <malloc+0xec>
  62:	4509                	li	a0,2
  64:	00000097          	auipc	ra,0x0
  68:	772080e7          	jalr	1906(ra) # 7d6 <fprintf>
			exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	41c080e7          	jalr	1052(ra) # 48a <exit>
	}
	buf[n] = 0;
  76:	fc048793          	addi	a5,s1,-64
  7a:	97a2                	add	a5,a5,s0
  7c:	c0078023          	sb	zero,-1024(a5)
	if (n == 0)return 0;
  80:	8526                	mv	a0,s1
  82:	c4b1                	beqz	s1,ce <readline+0xce>
	int offset = 0;
	while (offset < n) {
  84:	06905863          	blez	s1,f4 <readline+0xf4>
  88:	003a9793          	slli	a5,s5,0x3
  8c:	00fb0833          	add	a6,s6,a5
  90:	8556                	mv	a0,s5
	int offset = 0;
  92:	4781                	li	a5,0
		new_argv[curr_argc++] = buf + offset;
		while (buf[offset] != ' ' && offset < n) {
  94:	02000693          	li	a3,32
  98:	a021                	j	a0 <readline+0xa0>
	while (offset < n) {
  9a:	0821                	addi	a6,a6,8
  9c:	0297d963          	bge	a5,s1,ce <readline+0xce>
		new_argv[curr_argc++] = buf + offset;
  a0:	2505                	addiw	a0,a0,1
  a2:	bc040713          	addi	a4,s0,-1088
  a6:	973e                	add	a4,a4,a5
  a8:	00e83023          	sd	a4,0(a6)
		while (buf[offset] != ' ' && offset < n) {
  ac:	fc078613          	addi	a2,a5,-64
  b0:	9622                	add	a2,a2,s0
  b2:	c0064603          	lbu	a2,-1024(a2)
  b6:	04d60163          	beq	a2,a3,f8 <readline+0xf8>
  ba:	0097da63          	bge	a5,s1,ce <readline+0xce>
			offset++;
  be:	2785                	addiw	a5,a5,1
		while (buf[offset] != ' ' && offset < n) {
  c0:	00174603          	lbu	a2,1(a4)
  c4:	02d60a63          	beq	a2,a3,f8 <readline+0xf8>
  c8:	0705                	addi	a4,a4,1
  ca:	fef49ae3          	bne	s1,a5,be <readline+0xbe>
		while (buf[offset] == ' ' && offset < n) {
			buf[offset++] = 0;
		}
	}
	return curr_argc;
}
  ce:	43813083          	ld	ra,1080(sp)
  d2:	43013403          	ld	s0,1072(sp)
  d6:	42813483          	ld	s1,1064(sp)
  da:	42013903          	ld	s2,1056(sp)
  de:	41813983          	ld	s3,1048(sp)
  e2:	41013a03          	ld	s4,1040(sp)
  e6:	40813a83          	ld	s5,1032(sp)
  ea:	40013b03          	ld	s6,1024(sp)
  ee:	44010113          	addi	sp,sp,1088
  f2:	8082                	ret
	while (offset < n) {
  f4:	8556                	mv	a0,s5
  f6:	bfe1                	j	ce <readline+0xce>
		while (buf[offset] == ' ' && offset < n) {
  f8:	fc97dbe3          	bge	a5,s1,ce <readline+0xce>
  fc:	bc040713          	addi	a4,s0,-1088
 100:	973e                	add	a4,a4,a5
			buf[offset++] = 0;
 102:	2785                	addiw	a5,a5,1
 104:	00070023          	sb	zero,0(a4)
		while (buf[offset] == ' ' && offset < n) {
 108:	00174603          	lbu	a2,1(a4)
 10c:	f8d617e3          	bne	a2,a3,9a <readline+0x9a>
 110:	0705                	addi	a4,a4,1
 112:	fef498e3          	bne	s1,a5,102 <readline+0x102>
 116:	bf65                	j	ce <readline+0xce>

0000000000000118 <main>:
int main(int argc, char const* argv[])
{
 118:	7129                	addi	sp,sp,-320
 11a:	fe06                	sd	ra,312(sp)
 11c:	fa22                	sd	s0,304(sp)
 11e:	f626                	sd	s1,296(sp)
 120:	f24a                	sd	s2,288(sp)
 122:	ee4e                	sd	s3,280(sp)
 124:	ea52                	sd	s4,272(sp)
 126:	e656                	sd	s5,264(sp)
 128:	e25a                	sd	s6,256(sp)
 12a:	0280                	addi	s0,sp,320
	if (argc <= 1)
 12c:	4785                	li	a5,1
 12e:	0aa7d163          	bge	a5,a0,1d0 <main+0xb8>
 132:	8a2a                	mv	s4,a0
 134:	8b2e                	mv	s6,a1
	{
		fprintf(2, "Usage: xargs command (arg ...)\n");
		exit(1);
	}
	char* command = malloc(strlen(argv[1]) + 1);
 136:	6588                	ld	a0,8(a1)
 138:	00000097          	auipc	ra,0x0
 13c:	12e080e7          	jalr	302(ra) # 266 <strlen>
 140:	2505                	addiw	a0,a0,1
 142:	00000097          	auipc	ra,0x0
 146:	77a080e7          	jalr	1914(ra) # 8bc <malloc>
 14a:	89aa                	mv	s3,a0
	char* new_argv[MAXARG];
	strcpy(command, argv[1]);
 14c:	008b3583          	ld	a1,8(s6)
 150:	00000097          	auipc	ra,0x0
 154:	0ce080e7          	jalr	206(ra) # 21e <strcpy>
	for (int i = 1; i < argc; ++i)
 158:	008b0493          	addi	s1,s6,8
 15c:	ec040913          	addi	s2,s0,-320
 160:	ffea0a9b          	addiw	s5,s4,-2
 164:	020a9793          	slli	a5,s5,0x20
 168:	01d7da93          	srli	s5,a5,0x1d
 16c:	0b41                	addi	s6,s6,16
 16e:	9ada                	add	s5,s5,s6
	{
		new_argv[i - 1] = malloc(strlen(argv[i]) + 1);
 170:	6088                	ld	a0,0(s1)
 172:	00000097          	auipc	ra,0x0
 176:	0f4080e7          	jalr	244(ra) # 266 <strlen>
 17a:	2505                	addiw	a0,a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	740080e7          	jalr	1856(ra) # 8bc <malloc>
 184:	00a93023          	sd	a0,0(s2)
		strcpy(new_argv[i - 1], argv[i]);
 188:	608c                	ld	a1,0(s1)
 18a:	00000097          	auipc	ra,0x0
 18e:	094080e7          	jalr	148(ra) # 21e <strcpy>
	for (int i = 1; i < argc; ++i)
 192:	04a1                	addi	s1,s1,8
 194:	0921                	addi	s2,s2,8
 196:	fd549de3          	bne	s1,s5,170 <main+0x58>
	}
	int curr_argc;
	while ((curr_argc = readline(new_argv, argc - 1)) != 0)
 19a:	3a7d                	addiw	s4,s4,-1
 19c:	85d2                	mv	a1,s4
 19e:	ec040513          	addi	a0,s0,-320
 1a2:	00000097          	auipc	ra,0x0
 1a6:	e5e080e7          	jalr	-418(ra) # 0 <readline>
 1aa:	c535                	beqz	a0,216 <main+0xfe>
	{
		new_argv[curr_argc] = 0;
 1ac:	050e                	slli	a0,a0,0x3
 1ae:	fc050793          	addi	a5,a0,-64
 1b2:	00878533          	add	a0,a5,s0
 1b6:	f0053023          	sd	zero,-256(a0)
		if (fork() == 0) {
 1ba:	00000097          	auipc	ra,0x0
 1be:	2c8080e7          	jalr	712(ra) # 482 <fork>
 1c2:	c50d                	beqz	a0,1ec <main+0xd4>
			exec(command, new_argv);
			fprintf(2, "exec failed\n");
			exit(1);
		}
		wait(0);
 1c4:	4501                	li	a0,0
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2cc080e7          	jalr	716(ra) # 492 <wait>
 1ce:	b7f9                	j	19c <main+0x84>
		fprintf(2, "Usage: xargs command (arg ...)\n");
 1d0:	00000597          	auipc	a1,0x0
 1d4:	7f058593          	addi	a1,a1,2032 # 9c0 <malloc+0x104>
 1d8:	4509                	li	a0,2
 1da:	00000097          	auipc	ra,0x0
 1de:	5fc080e7          	jalr	1532(ra) # 7d6 <fprintf>
		exit(1);
 1e2:	4505                	li	a0,1
 1e4:	00000097          	auipc	ra,0x0
 1e8:	2a6080e7          	jalr	678(ra) # 48a <exit>
			exec(command, new_argv);
 1ec:	ec040593          	addi	a1,s0,-320
 1f0:	854e                	mv	a0,s3
 1f2:	00000097          	auipc	ra,0x0
 1f6:	2d0080e7          	jalr	720(ra) # 4c2 <exec>
			fprintf(2, "exec failed\n");
 1fa:	00000597          	auipc	a1,0x0
 1fe:	7e658593          	addi	a1,a1,2022 # 9e0 <malloc+0x124>
 202:	4509                	li	a0,2
 204:	00000097          	auipc	ra,0x0
 208:	5d2080e7          	jalr	1490(ra) # 7d6 <fprintf>
			exit(1);
 20c:	4505                	li	a0,1
 20e:	00000097          	auipc	ra,0x0
 212:	27c080e7          	jalr	636(ra) # 48a <exit>
	}
	exit(0);
 216:	00000097          	auipc	ra,0x0
 21a:	274080e7          	jalr	628(ra) # 48a <exit>

000000000000021e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 224:	87aa                	mv	a5,a0
 226:	0585                	addi	a1,a1,1
 228:	0785                	addi	a5,a5,1
 22a:	fff5c703          	lbu	a4,-1(a1)
 22e:	fee78fa3          	sb	a4,-1(a5)
 232:	fb75                	bnez	a4,226 <strcpy+0x8>
    ;
  return os;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb91                	beqz	a5,258 <strcmp+0x1e>
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00f71763          	bne	a4,a5,258 <strcmp+0x1e>
    p++, q++;
 24e:	0505                	addi	a0,a0,1
 250:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	fbe5                	bnez	a5,246 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 258:	0005c503          	lbu	a0,0(a1)
}
 25c:	40a7853b          	subw	a0,a5,a0
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strlen>:

uint
strlen(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf91                	beqz	a5,28c <strlen+0x26>
 272:	0505                	addi	a0,a0,1
 274:	87aa                	mv	a5,a0
 276:	4685                	li	a3,1
 278:	9e89                	subw	a3,a3,a0
 27a:	00f6853b          	addw	a0,a3,a5
 27e:	0785                	addi	a5,a5,1
 280:	fff7c703          	lbu	a4,-1(a5)
 284:	fb7d                	bnez	a4,27a <strlen+0x14>
    ;
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  for(n = 0; s[n]; n++)
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strlen+0x20>

0000000000000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ca19                	beqz	a2,2ac <memset+0x1c>
 298:	87aa                	mv	a5,a0
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a6:	0785                	addi	a5,a5,1
 2a8:	fee79de3          	bne	a5,a4,2a2 <memset+0x12>
  }
  return dst;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strchr>:

char*
strchr(const char *s, char c)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cb99                	beqz	a5,2d2 <strchr+0x20>
    if(*s == c)
 2be:	00f58763          	beq	a1,a5,2cc <strchr+0x1a>
  for(; *s; s++)
 2c2:	0505                	addi	a0,a0,1
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbfd                	bnez	a5,2be <strchr+0xc>
      return (char*)s;
  return 0;
 2ca:	4501                	li	a0,0
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <strchr+0x1a>

00000000000002d6 <gets>:

char*
gets(char *buf, int max)
{
 2d6:	711d                	addi	sp,sp,-96
 2d8:	ec86                	sd	ra,88(sp)
 2da:	e8a2                	sd	s0,80(sp)
 2dc:	e4a6                	sd	s1,72(sp)
 2de:	e0ca                	sd	s2,64(sp)
 2e0:	fc4e                	sd	s3,56(sp)
 2e2:	f852                	sd	s4,48(sp)
 2e4:	f456                	sd	s5,40(sp)
 2e6:	f05a                	sd	s6,32(sp)
 2e8:	ec5e                	sd	s7,24(sp)
 2ea:	1080                	addi	s0,sp,96
 2ec:	8baa                	mv	s7,a0
 2ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f0:	892a                	mv	s2,a0
 2f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f4:	4aa9                	li	s5,10
 2f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f8:	89a6                	mv	s3,s1
 2fa:	2485                	addiw	s1,s1,1
 2fc:	0344d863          	bge	s1,s4,32c <gets+0x56>
    cc = read(0, &c, 1);
 300:	4605                	li	a2,1
 302:	faf40593          	addi	a1,s0,-81
 306:	4501                	li	a0,0
 308:	00000097          	auipc	ra,0x0
 30c:	19a080e7          	jalr	410(ra) # 4a2 <read>
    if(cc < 1)
 310:	00a05e63          	blez	a0,32c <gets+0x56>
    buf[i++] = c;
 314:	faf44783          	lbu	a5,-81(s0)
 318:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31c:	01578763          	beq	a5,s5,32a <gets+0x54>
 320:	0905                	addi	s2,s2,1
 322:	fd679be3          	bne	a5,s6,2f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 326:	89a6                	mv	s3,s1
 328:	a011                	j	32c <gets+0x56>
 32a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 32c:	99de                	add	s3,s3,s7
 32e:	00098023          	sb	zero,0(s3)
  return buf;
}
 332:	855e                	mv	a0,s7
 334:	60e6                	ld	ra,88(sp)
 336:	6446                	ld	s0,80(sp)
 338:	64a6                	ld	s1,72(sp)
 33a:	6906                	ld	s2,64(sp)
 33c:	79e2                	ld	s3,56(sp)
 33e:	7a42                	ld	s4,48(sp)
 340:	7aa2                	ld	s5,40(sp)
 342:	7b02                	ld	s6,32(sp)
 344:	6be2                	ld	s7,24(sp)
 346:	6125                	addi	sp,sp,96
 348:	8082                	ret

000000000000034a <stat>:

int
stat(const char *n, struct stat *st)
{
 34a:	1101                	addi	sp,sp,-32
 34c:	ec06                	sd	ra,24(sp)
 34e:	e822                	sd	s0,16(sp)
 350:	e426                	sd	s1,8(sp)
 352:	e04a                	sd	s2,0(sp)
 354:	1000                	addi	s0,sp,32
 356:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 358:	4581                	li	a1,0
 35a:	00000097          	auipc	ra,0x0
 35e:	170080e7          	jalr	368(ra) # 4ca <open>
  if(fd < 0)
 362:	02054563          	bltz	a0,38c <stat+0x42>
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	00000097          	auipc	ra,0x0
 36e:	178080e7          	jalr	376(ra) # 4e2 <fstat>
 372:	892a                	mv	s2,a0
  close(fd);
 374:	8526                	mv	a0,s1
 376:	00000097          	auipc	ra,0x0
 37a:	13c080e7          	jalr	316(ra) # 4b2 <close>
  return r;
}
 37e:	854a                	mv	a0,s2
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	64a2                	ld	s1,8(sp)
 386:	6902                	ld	s2,0(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret
    return -1;
 38c:	597d                	li	s2,-1
 38e:	bfc5                	j	37e <stat+0x34>

0000000000000390 <atoi>:

int
atoi(const char *s)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 396:	00054683          	lbu	a3,0(a0)
 39a:	fd06879b          	addiw	a5,a3,-48
 39e:	0ff7f793          	zext.b	a5,a5
 3a2:	4625                	li	a2,9
 3a4:	02f66863          	bltu	a2,a5,3d4 <atoi+0x44>
 3a8:	872a                	mv	a4,a0
  n = 0;
 3aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ac:	0705                	addi	a4,a4,1
 3ae:	0025179b          	slliw	a5,a0,0x2
 3b2:	9fa9                	addw	a5,a5,a0
 3b4:	0017979b          	slliw	a5,a5,0x1
 3b8:	9fb5                	addw	a5,a5,a3
 3ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3be:	00074683          	lbu	a3,0(a4)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	fef671e3          	bgeu	a2,a5,3ac <atoi+0x1c>
  return n;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  n = 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <atoi+0x3e>

00000000000003d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3de:	02b57463          	bgeu	a0,a1,406 <memmove+0x2e>
    while(n-- > 0)
 3e2:	00c05f63          	blez	a2,400 <memmove+0x28>
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f0:	0585                	addi	a1,a1,1
 3f2:	0705                	addi	a4,a4,1
 3f4:	fff5c683          	lbu	a3,-1(a1)
 3f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fc:	fee79ae3          	bne	a5,a4,3f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
    dst += n;
 406:	00c50733          	add	a4,a0,a2
    src += n;
 40a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40c:	fec05ae3          	blez	a2,400 <memmove+0x28>
 410:	fff6079b          	addiw	a5,a2,-1
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	fff7c793          	not	a5,a5
 41c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 41e:	15fd                	addi	a1,a1,-1
 420:	177d                	addi	a4,a4,-1
 422:	0005c683          	lbu	a3,0(a1)
 426:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42a:	fee79ae3          	bne	a5,a4,41e <memmove+0x46>
 42e:	bfc9                	j	400 <memmove+0x28>

0000000000000430 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 436:	ca05                	beqz	a2,466 <memcmp+0x36>
 438:	fff6069b          	addiw	a3,a2,-1
 43c:	1682                	slli	a3,a3,0x20
 43e:	9281                	srli	a3,a3,0x20
 440:	0685                	addi	a3,a3,1
 442:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 444:	00054783          	lbu	a5,0(a0)
 448:	0005c703          	lbu	a4,0(a1)
 44c:	00e79863          	bne	a5,a4,45c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 450:	0505                	addi	a0,a0,1
    p2++;
 452:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 454:	fed518e3          	bne	a0,a3,444 <memcmp+0x14>
  }
  return 0;
 458:	4501                	li	a0,0
 45a:	a019                	j	460 <memcmp+0x30>
      return *p1 - *p2;
 45c:	40e7853b          	subw	a0,a5,a4
}
 460:	6422                	ld	s0,8(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  return 0;
 466:	4501                	li	a0,0
 468:	bfe5                	j	460 <memcmp+0x30>

000000000000046a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 472:	00000097          	auipc	ra,0x0
 476:	f66080e7          	jalr	-154(ra) # 3d8 <memmove>
}
 47a:	60a2                	ld	ra,8(sp)
 47c:	6402                	ld	s0,0(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret

0000000000000482 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 482:	4885                	li	a7,1
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <exit>:
.global exit
exit:
 li a7, SYS_exit
 48a:	4889                	li	a7,2
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <wait>:
.global wait
wait:
 li a7, SYS_wait
 492:	488d                	li	a7,3
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49a:	4891                	li	a7,4
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <read>:
.global read
read:
 li a7, SYS_read
 4a2:	4895                	li	a7,5
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <write>:
.global write
write:
 li a7, SYS_write
 4aa:	48c1                	li	a7,16
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <close>:
.global close
close:
 li a7, SYS_close
 4b2:	48d5                	li	a7,21
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ba:	4899                	li	a7,6
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c2:	489d                	li	a7,7
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <open>:
.global open
open:
 li a7, SYS_open
 4ca:	48bd                	li	a7,15
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d2:	48c5                	li	a7,17
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4da:	48c9                	li	a7,18
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e2:	48a1                	li	a7,8
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <link>:
.global link
link:
 li a7, SYS_link
 4ea:	48cd                	li	a7,19
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f2:	48d1                	li	a7,20
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fa:	48a5                	li	a7,9
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <dup>:
.global dup
dup:
 li a7, SYS_dup
 502:	48a9                	li	a7,10
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50a:	48ad                	li	a7,11
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 512:	48b1                	li	a7,12
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51a:	48b5                	li	a7,13
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 522:	48b9                	li	a7,14
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	e822                	sd	s0,16(sp)
 530:	1000                	addi	s0,sp,32
 532:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 536:	4605                	li	a2,1
 538:	fef40593          	addi	a1,s0,-17
 53c:	00000097          	auipc	ra,0x0
 540:	f6e080e7          	jalr	-146(ra) # 4aa <write>
}
 544:	60e2                	ld	ra,24(sp)
 546:	6442                	ld	s0,16(sp)
 548:	6105                	addi	sp,sp,32
 54a:	8082                	ret

000000000000054c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54c:	7139                	addi	sp,sp,-64
 54e:	fc06                	sd	ra,56(sp)
 550:	f822                	sd	s0,48(sp)
 552:	f426                	sd	s1,40(sp)
 554:	f04a                	sd	s2,32(sp)
 556:	ec4e                	sd	s3,24(sp)
 558:	0080                	addi	s0,sp,64
 55a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55c:	c299                	beqz	a3,562 <printint+0x16>
 55e:	0805c963          	bltz	a1,5f0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 562:	2581                	sext.w	a1,a1
  neg = 0;
 564:	4881                	li	a7,0
 566:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 56c:	2601                	sext.w	a2,a2
 56e:	00000517          	auipc	a0,0x0
 572:	4e250513          	addi	a0,a0,1250 # a50 <digits>
 576:	883a                	mv	a6,a4
 578:	2705                	addiw	a4,a4,1
 57a:	02c5f7bb          	remuw	a5,a1,a2
 57e:	1782                	slli	a5,a5,0x20
 580:	9381                	srli	a5,a5,0x20
 582:	97aa                	add	a5,a5,a0
 584:	0007c783          	lbu	a5,0(a5)
 588:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 58c:	0005879b          	sext.w	a5,a1
 590:	02c5d5bb          	divuw	a1,a1,a2
 594:	0685                	addi	a3,a3,1
 596:	fec7f0e3          	bgeu	a5,a2,576 <printint+0x2a>
  if(neg)
 59a:	00088c63          	beqz	a7,5b2 <printint+0x66>
    buf[i++] = '-';
 59e:	fd070793          	addi	a5,a4,-48
 5a2:	00878733          	add	a4,a5,s0
 5a6:	02d00793          	li	a5,45
 5aa:	fef70823          	sb	a5,-16(a4)
 5ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b2:	02e05863          	blez	a4,5e2 <printint+0x96>
 5b6:	fc040793          	addi	a5,s0,-64
 5ba:	00e78933          	add	s2,a5,a4
 5be:	fff78993          	addi	s3,a5,-1
 5c2:	99ba                	add	s3,s3,a4
 5c4:	377d                	addiw	a4,a4,-1
 5c6:	1702                	slli	a4,a4,0x20
 5c8:	9301                	srli	a4,a4,0x20
 5ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ce:	fff94583          	lbu	a1,-1(s2)
 5d2:	8526                	mv	a0,s1
 5d4:	00000097          	auipc	ra,0x0
 5d8:	f56080e7          	jalr	-170(ra) # 52a <putc>
  while(--i >= 0)
 5dc:	197d                	addi	s2,s2,-1
 5de:	ff3918e3          	bne	s2,s3,5ce <printint+0x82>
}
 5e2:	70e2                	ld	ra,56(sp)
 5e4:	7442                	ld	s0,48(sp)
 5e6:	74a2                	ld	s1,40(sp)
 5e8:	7902                	ld	s2,32(sp)
 5ea:	69e2                	ld	s3,24(sp)
 5ec:	6121                	addi	sp,sp,64
 5ee:	8082                	ret
    x = -xx;
 5f0:	40b005bb          	negw	a1,a1
    neg = 1;
 5f4:	4885                	li	a7,1
    x = -xx;
 5f6:	bf85                	j	566 <printint+0x1a>

00000000000005f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f8:	7119                	addi	sp,sp,-128
 5fa:	fc86                	sd	ra,120(sp)
 5fc:	f8a2                	sd	s0,112(sp)
 5fe:	f4a6                	sd	s1,104(sp)
 600:	f0ca                	sd	s2,96(sp)
 602:	ecce                	sd	s3,88(sp)
 604:	e8d2                	sd	s4,80(sp)
 606:	e4d6                	sd	s5,72(sp)
 608:	e0da                	sd	s6,64(sp)
 60a:	fc5e                	sd	s7,56(sp)
 60c:	f862                	sd	s8,48(sp)
 60e:	f466                	sd	s9,40(sp)
 610:	f06a                	sd	s10,32(sp)
 612:	ec6e                	sd	s11,24(sp)
 614:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 616:	0005c903          	lbu	s2,0(a1)
 61a:	18090f63          	beqz	s2,7b8 <vprintf+0x1c0>
 61e:	8aaa                	mv	s5,a0
 620:	8b32                	mv	s6,a2
 622:	00158493          	addi	s1,a1,1
  state = 0;
 626:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 628:	02500a13          	li	s4,37
 62c:	4c55                	li	s8,21
 62e:	00000c97          	auipc	s9,0x0
 632:	3cac8c93          	addi	s9,s9,970 # 9f8 <malloc+0x13c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 636:	02800d93          	li	s11,40
  putc(fd, 'x');
 63a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	00000b97          	auipc	s7,0x0
 640:	414b8b93          	addi	s7,s7,1044 # a50 <digits>
 644:	a839                	j	662 <vprintf+0x6a>
        putc(fd, c);
 646:	85ca                	mv	a1,s2
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	ee0080e7          	jalr	-288(ra) # 52a <putc>
 652:	a019                	j	658 <vprintf+0x60>
    } else if(state == '%'){
 654:	01498d63          	beq	s3,s4,66e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 658:	0485                	addi	s1,s1,1
 65a:	fff4c903          	lbu	s2,-1(s1)
 65e:	14090d63          	beqz	s2,7b8 <vprintf+0x1c0>
    if(state == 0){
 662:	fe0999e3          	bnez	s3,654 <vprintf+0x5c>
      if(c == '%'){
 666:	ff4910e3          	bne	s2,s4,646 <vprintf+0x4e>
        state = '%';
 66a:	89d2                	mv	s3,s4
 66c:	b7f5                	j	658 <vprintf+0x60>
      if(c == 'd'){
 66e:	11490c63          	beq	s2,s4,786 <vprintf+0x18e>
 672:	f9d9079b          	addiw	a5,s2,-99
 676:	0ff7f793          	zext.b	a5,a5
 67a:	10fc6e63          	bltu	s8,a5,796 <vprintf+0x19e>
 67e:	f9d9079b          	addiw	a5,s2,-99
 682:	0ff7f713          	zext.b	a4,a5
 686:	10ec6863          	bltu	s8,a4,796 <vprintf+0x19e>
 68a:	00271793          	slli	a5,a4,0x2
 68e:	97e6                	add	a5,a5,s9
 690:	439c                	lw	a5,0(a5)
 692:	97e6                	add	a5,a5,s9
 694:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 696:	008b0913          	addi	s2,s6,8
 69a:	4685                	li	a3,1
 69c:	4629                	li	a2,10
 69e:	000b2583          	lw	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	ea8080e7          	jalr	-344(ra) # 54c <printint>
 6ac:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b765                	j	658 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	008b0913          	addi	s2,s6,8
 6b6:	4681                	li	a3,0
 6b8:	4629                	li	a2,10
 6ba:	000b2583          	lw	a1,0(s6)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e8c080e7          	jalr	-372(ra) # 54c <printint>
 6c8:	8b4a                	mv	s6,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b771                	j	658 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ce:	008b0913          	addi	s2,s6,8
 6d2:	4681                	li	a3,0
 6d4:	866a                	mv	a2,s10
 6d6:	000b2583          	lw	a1,0(s6)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e70080e7          	jalr	-400(ra) # 54c <printint>
 6e4:	8b4a                	mv	s6,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bf85                	j	658 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ea:	008b0793          	addi	a5,s6,8
 6ee:	f8f43423          	sd	a5,-120(s0)
 6f2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f6:	03000593          	li	a1,48
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e2e080e7          	jalr	-466(ra) # 52a <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e20080e7          	jalr	-480(ra) # 52a <putc>
 712:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	03c9d793          	srli	a5,s3,0x3c
 718:	97de                	add	a5,a5,s7
 71a:	0007c583          	lbu	a1,0(a5)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	e0a080e7          	jalr	-502(ra) # 52a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	397d                	addiw	s2,s2,-1
 72c:	fe0914e3          	bnez	s2,714 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 730:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 734:	4981                	li	s3,0
 736:	b70d                	j	658 <vprintf+0x60>
        s = va_arg(ap, char*);
 738:	008b0913          	addi	s2,s6,8
 73c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 740:	02098163          	beqz	s3,762 <vprintf+0x16a>
        while(*s != 0){
 744:	0009c583          	lbu	a1,0(s3)
 748:	c5ad                	beqz	a1,7b2 <vprintf+0x1ba>
          putc(fd, *s);
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	dde080e7          	jalr	-546(ra) # 52a <putc>
          s++;
 754:	0985                	addi	s3,s3,1
        while(*s != 0){
 756:	0009c583          	lbu	a1,0(s3)
 75a:	f9e5                	bnez	a1,74a <vprintf+0x152>
        s = va_arg(ap, char*);
 75c:	8b4a                	mv	s6,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	bde5                	j	658 <vprintf+0x60>
          s = "(null)";
 762:	00000997          	auipc	s3,0x0
 766:	28e98993          	addi	s3,s3,654 # 9f0 <malloc+0x134>
        while(*s != 0){
 76a:	85ee                	mv	a1,s11
 76c:	bff9                	j	74a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 76e:	008b0913          	addi	s2,s6,8
 772:	000b4583          	lbu	a1,0(s6)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	db2080e7          	jalr	-590(ra) # 52a <putc>
 780:	8b4a                	mv	s6,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	bdd1                	j	658 <vprintf+0x60>
        putc(fd, c);
 786:	85d2                	mv	a1,s4
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	da0080e7          	jalr	-608(ra) # 52a <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	b5d1                	j	658 <vprintf+0x60>
        putc(fd, '%');
 796:	85d2                	mv	a1,s4
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	d90080e7          	jalr	-624(ra) # 52a <putc>
        putc(fd, c);
 7a2:	85ca                	mv	a1,s2
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	d84080e7          	jalr	-636(ra) # 52a <putc>
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b565                	j	658 <vprintf+0x60>
        s = va_arg(ap, char*);
 7b2:	8b4a                	mv	s6,s2
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b54d                	j	658 <vprintf+0x60>
    }
  }
}
 7b8:	70e6                	ld	ra,120(sp)
 7ba:	7446                	ld	s0,112(sp)
 7bc:	74a6                	ld	s1,104(sp)
 7be:	7906                	ld	s2,96(sp)
 7c0:	69e6                	ld	s3,88(sp)
 7c2:	6a46                	ld	s4,80(sp)
 7c4:	6aa6                	ld	s5,72(sp)
 7c6:	6b06                	ld	s6,64(sp)
 7c8:	7be2                	ld	s7,56(sp)
 7ca:	7c42                	ld	s8,48(sp)
 7cc:	7ca2                	ld	s9,40(sp)
 7ce:	7d02                	ld	s10,32(sp)
 7d0:	6de2                	ld	s11,24(sp)
 7d2:	6109                	addi	sp,sp,128
 7d4:	8082                	ret

00000000000007d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d6:	715d                	addi	sp,sp,-80
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e010                	sd	a2,0(s0)
 7e0:	e414                	sd	a3,8(s0)
 7e2:	e818                	sd	a4,16(s0)
 7e4:	ec1c                	sd	a5,24(s0)
 7e6:	03043023          	sd	a6,32(s0)
 7ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f2:	8622                	mv	a2,s0
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e04080e7          	jalr	-508(ra) # 5f8 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6161                	addi	sp,sp,80
 802:	8082                	ret

0000000000000804 <printf>:

void
printf(const char *fmt, ...)
{
 804:	711d                	addi	sp,sp,-96
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e40c                	sd	a1,8(s0)
 80e:	e810                	sd	a2,16(s0)
 810:	ec14                	sd	a3,24(s0)
 812:	f018                	sd	a4,32(s0)
 814:	f41c                	sd	a5,40(s0)
 816:	03043823          	sd	a6,48(s0)
 81a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	00840613          	addi	a2,s0,8
 822:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 826:	85aa                	mv	a1,a0
 828:	4505                	li	a0,1
 82a:	00000097          	auipc	ra,0x0
 82e:	dce080e7          	jalr	-562(ra) # 5f8 <vprintf>
}
 832:	60e2                	ld	ra,24(sp)
 834:	6442                	ld	s0,16(sp)
 836:	6125                	addi	sp,sp,96
 838:	8082                	ret

000000000000083a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83a:	1141                	addi	sp,sp,-16
 83c:	e422                	sd	s0,8(sp)
 83e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 840:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	00000797          	auipc	a5,0x0
 848:	2247b783          	ld	a5,548(a5) # a68 <freep>
 84c:	a02d                	j	876 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 84e:	4618                	lw	a4,8(a2)
 850:	9f2d                	addw	a4,a4,a1
 852:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	6398                	ld	a4,0(a5)
 858:	6310                	ld	a2,0(a4)
 85a:	a83d                	j	898 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85c:	ff852703          	lw	a4,-8(a0)
 860:	9f31                	addw	a4,a4,a2
 862:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 864:	ff053683          	ld	a3,-16(a0)
 868:	a091                	j	8ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	6398                	ld	a4,0(a5)
 86c:	00e7e463          	bltu	a5,a4,874 <free+0x3a>
 870:	00e6ea63          	bltu	a3,a4,884 <free+0x4a>
{
 874:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 876:	fed7fae3          	bgeu	a5,a3,86a <free+0x30>
 87a:	6398                	ld	a4,0(a5)
 87c:	00e6e463          	bltu	a3,a4,884 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	fee7eae3          	bltu	a5,a4,874 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 884:	ff852583          	lw	a1,-8(a0)
 888:	6390                	ld	a2,0(a5)
 88a:	02059813          	slli	a6,a1,0x20
 88e:	01c85713          	srli	a4,a6,0x1c
 892:	9736                	add	a4,a4,a3
 894:	fae60de3          	beq	a2,a4,84e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89c:	4790                	lw	a2,8(a5)
 89e:	02061593          	slli	a1,a2,0x20
 8a2:	01c5d713          	srli	a4,a1,0x1c
 8a6:	973e                	add	a4,a4,a5
 8a8:	fae68ae3          	beq	a3,a4,85c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ae:	00000717          	auipc	a4,0x0
 8b2:	1af73d23          	sd	a5,442(a4) # a68 <freep>
}
 8b6:	6422                	ld	s0,8(sp)
 8b8:	0141                	addi	sp,sp,16
 8ba:	8082                	ret

00000000000008bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8bc:	7139                	addi	sp,sp,-64
 8be:	fc06                	sd	ra,56(sp)
 8c0:	f822                	sd	s0,48(sp)
 8c2:	f426                	sd	s1,40(sp)
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	ec4e                	sd	s3,24(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
 8ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d0:	02051493          	slli	s1,a0,0x20
 8d4:	9081                	srli	s1,s1,0x20
 8d6:	04bd                	addi	s1,s1,15
 8d8:	8091                	srli	s1,s1,0x4
 8da:	0014899b          	addiw	s3,s1,1
 8de:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e0:	00000517          	auipc	a0,0x0
 8e4:	18853503          	ld	a0,392(a0) # a68 <freep>
 8e8:	c515                	beqz	a0,914 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	02977f63          	bgeu	a4,s1,92c <malloc+0x70>
 8f2:	8a4e                	mv	s4,s3
 8f4:	0009871b          	sext.w	a4,s3
 8f8:	6685                	lui	a3,0x1
 8fa:	00d77363          	bgeu	a4,a3,900 <malloc+0x44>
 8fe:	6a05                	lui	s4,0x1
 900:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 904:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 908:	00000917          	auipc	s2,0x0
 90c:	16090913          	addi	s2,s2,352 # a68 <freep>
  if(p == (char*)-1)
 910:	5afd                	li	s5,-1
 912:	a895                	j	986 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 914:	00000797          	auipc	a5,0x0
 918:	15c78793          	addi	a5,a5,348 # a70 <base>
 91c:	00000717          	auipc	a4,0x0
 920:	14f73623          	sd	a5,332(a4) # a68 <freep>
 924:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 926:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92a:	b7e1                	j	8f2 <malloc+0x36>
      if(p->s.size == nunits)
 92c:	02e48c63          	beq	s1,a4,964 <malloc+0xa8>
        p->s.size -= nunits;
 930:	4137073b          	subw	a4,a4,s3
 934:	c798                	sw	a4,8(a5)
        p += p->s.size;
 936:	02071693          	slli	a3,a4,0x20
 93a:	01c6d713          	srli	a4,a3,0x1c
 93e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 940:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 944:	00000717          	auipc	a4,0x0
 948:	12a73223          	sd	a0,292(a4) # a68 <freep>
      return (void*)(p + 1);
 94c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 950:	70e2                	ld	ra,56(sp)
 952:	7442                	ld	s0,48(sp)
 954:	74a2                	ld	s1,40(sp)
 956:	7902                	ld	s2,32(sp)
 958:	69e2                	ld	s3,24(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	6121                	addi	sp,sp,64
 962:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 964:	6398                	ld	a4,0(a5)
 966:	e118                	sd	a4,0(a0)
 968:	bff1                	j	944 <malloc+0x88>
  hp->s.size = nu;
 96a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96e:	0541                	addi	a0,a0,16
 970:	00000097          	auipc	ra,0x0
 974:	eca080e7          	jalr	-310(ra) # 83a <free>
  return freep;
 978:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97c:	d971                	beqz	a0,950 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 980:	4798                	lw	a4,8(a5)
 982:	fa9775e3          	bgeu	a4,s1,92c <malloc+0x70>
    if(p == freep)
 986:	00093703          	ld	a4,0(s2)
 98a:	853e                	mv	a0,a5
 98c:	fef719e3          	bne	a4,a5,97e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 990:	8552                	mv	a0,s4
 992:	00000097          	auipc	ra,0x0
 996:	b80080e7          	jalr	-1152(ra) # 512 <sbrk>
  if(p == (char*)-1)
 99a:	fd5518e3          	bne	a0,s5,96a <malloc+0xae>
        return 0;
 99e:	4501                	li	a0,0
 9a0:	bf45                	j	950 <malloc+0x94>
