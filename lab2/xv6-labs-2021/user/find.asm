
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h"
#include "kernel/fs.h"

char* des = 0;
void find(const char* path)
{
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	24913c23          	sd	s1,600(sp)
  10:	25213823          	sd	s2,592(sp)
  14:	25313423          	sd	s3,584(sp)
  18:	25413023          	sd	s4,576(sp)
  1c:	23513c23          	sd	s5,568(sp)
  20:	23613823          	sd	s6,560(sp)
  24:	1c80                	addi	s0,sp,624
  26:	892a                	mv	s2,a0
    //buf中存放的是绝对路径
	char buf[512],*p;
	strcpy(buf,path);
  28:	85aa                	mv	a1,a0
  2a:	dc040513          	addi	a0,s0,-576
  2e:	00000097          	auipc	ra,0x0
  32:	1c6080e7          	jalr	454(ra) # 1f4 <strcpy>
	p = buf + strlen(path);
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	204080e7          	jalr	516(ra) # 23c <strlen>
  40:	1502                	slli	a0,a0,0x20
  42:	9101                	srli	a0,a0,0x20
  44:	dc040793          	addi	a5,s0,-576
  48:	00a789b3          	add	s3,a5,a0
	*p++ = '/';
  4c:	02f00793          	li	a5,47
  50:	00f98023          	sb	a5,0(s3)
	int fd;
	struct stat st;
	if (0 > (fd = open(path,O_RDONLY)))
  54:	4581                	li	a1,0
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	448080e7          	jalr	1096(ra) # 4a0 <open>
  60:	0a054663          	bltz	a0,10c <find+0x10c>
  64:	84aa                	mv	s1,a0
	{
		fprintf(2,"cannot open %s\n",path);
		return;
	}
	if (0 > fstat(fd,&st))
  66:	da840593          	addi	a1,s0,-600
  6a:	00000097          	auipc	ra,0x0
  6e:	44e080e7          	jalr	1102(ra) # 4b8 <fstat>
  72:	0a054863          	bltz	a0,122 <find+0x122>
	*p++ = '/';
  76:	0985                	addi	s3,s3,1
		if (stat(buf,&st) < 0)
		{
			fprintf(2,"cannot stat %s\n",buf);
			continue;
		}
		switch(st.type)
  78:	4905                	li	s2,1
				if (!strcmp(dir.name,des))
					printf("%s\n",buf);
				break;

			case T_DIR:
				if (strcmp(".",dir.name) && strcmp("..",dir.name))
  7a:	00001a97          	auipc	s5,0x1
  7e:	94ea8a93          	addi	s5,s5,-1714 # 9c8 <malloc+0x126>
  82:	00001b17          	auipc	s6,0x1
  86:	94eb0b13          	addi	s6,s6,-1714 # 9d0 <malloc+0x12e>
				if (!strcmp(dir.name,des))
  8a:	00001a17          	auipc	s4,0x1
  8e:	9e6a0a13          	addi	s4,s4,-1562 # a70 <des>
	while (read(fd,&dir,len) == len)
  92:	4641                	li	a2,16
  94:	d9840593          	addi	a1,s0,-616
  98:	8526                	mv	a0,s1
  9a:	00000097          	auipc	ra,0x0
  9e:	3de080e7          	jalr	990(ra) # 478 <read>
  a2:	47c1                	li	a5,16
  a4:	0cf51d63          	bne	a0,a5,17e <find+0x17e>
		if (0 == dir.inum)
  a8:	d9845783          	lhu	a5,-616(s0)
  ac:	d3fd                	beqz	a5,92 <find+0x92>
		strcpy(p,dir.name);
  ae:	d9a40593          	addi	a1,s0,-614
  b2:	854e                	mv	a0,s3
  b4:	00000097          	auipc	ra,0x0
  b8:	140080e7          	jalr	320(ra) # 1f4 <strcpy>
		if (stat(buf,&st) < 0)
  bc:	da840593          	addi	a1,s0,-600
  c0:	dc040513          	addi	a0,s0,-576
  c4:	00000097          	auipc	ra,0x0
  c8:	25c080e7          	jalr	604(ra) # 320 <stat>
  cc:	06054663          	bltz	a0,138 <find+0x138>
		switch(st.type)
  d0:	db041783          	lh	a5,-592(s0)
  d4:	0007871b          	sext.w	a4,a5
  d8:	07270c63          	beq	a4,s2,150 <find+0x150>
  dc:	87ba                	mv	a5,a4
  de:	4709                	li	a4,2
  e0:	fae799e3          	bne	a5,a4,92 <find+0x92>
				if (!strcmp(dir.name,des))
  e4:	000a3583          	ld	a1,0(s4)
  e8:	d9a40513          	addi	a0,s0,-614
  ec:	00000097          	auipc	ra,0x0
  f0:	124080e7          	jalr	292(ra) # 210 <strcmp>
  f4:	fd59                	bnez	a0,92 <find+0x92>
					printf("%s\n",buf);
  f6:	dc040593          	addi	a1,s0,-576
  fa:	00001517          	auipc	a0,0x1
  fe:	8c650513          	addi	a0,a0,-1850 # 9c0 <malloc+0x11e>
 102:	00000097          	auipc	ra,0x0
 106:	6e8080e7          	jalr	1768(ra) # 7ea <printf>
 10a:	b761                	j	92 <find+0x92>
		fprintf(2,"cannot open %s\n",path);
 10c:	864a                	mv	a2,s2
 10e:	00001597          	auipc	a1,0x1
 112:	87a58593          	addi	a1,a1,-1926 # 988 <malloc+0xe6>
 116:	4509                	li	a0,2
 118:	00000097          	auipc	ra,0x0
 11c:	6a4080e7          	jalr	1700(ra) # 7bc <fprintf>
		return;
 120:	a0a5                	j	188 <find+0x188>
		fprintf(2,"cannot fstat %s\n",path);
 122:	864a                	mv	a2,s2
 124:	00001597          	auipc	a1,0x1
 128:	87458593          	addi	a1,a1,-1932 # 998 <malloc+0xf6>
 12c:	4509                	li	a0,2
 12e:	00000097          	auipc	ra,0x0
 132:	68e080e7          	jalr	1678(ra) # 7bc <fprintf>
		return;
 136:	a889                	j	188 <find+0x188>
			fprintf(2,"cannot stat %s\n",buf);
 138:	dc040613          	addi	a2,s0,-576
 13c:	00001597          	auipc	a1,0x1
 140:	87458593          	addi	a1,a1,-1932 # 9b0 <malloc+0x10e>
 144:	4509                	li	a0,2
 146:	00000097          	auipc	ra,0x0
 14a:	676080e7          	jalr	1654(ra) # 7bc <fprintf>
			continue;
 14e:	b791                	j	92 <find+0x92>
				if (strcmp(".",dir.name) && strcmp("..",dir.name))
 150:	d9a40593          	addi	a1,s0,-614
 154:	8556                	mv	a0,s5
 156:	00000097          	auipc	ra,0x0
 15a:	0ba080e7          	jalr	186(ra) # 210 <strcmp>
 15e:	d915                	beqz	a0,92 <find+0x92>
 160:	d9a40593          	addi	a1,s0,-614
 164:	855a                	mv	a0,s6
 166:	00000097          	auipc	ra,0x0
 16a:	0aa080e7          	jalr	170(ra) # 210 <strcmp>
 16e:	d115                	beqz	a0,92 <find+0x92>
					find(buf);
 170:	dc040513          	addi	a0,s0,-576
 174:	00000097          	auipc	ra,0x0
 178:	e8c080e7          	jalr	-372(ra) # 0 <find>
 17c:	bf19                	j	92 <find+0x92>

			default:
				break;
		}
	}
	close(fd);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	308080e7          	jalr	776(ra) # 488 <close>
}
 188:	26813083          	ld	ra,616(sp)
 18c:	26013403          	ld	s0,608(sp)
 190:	25813483          	ld	s1,600(sp)
 194:	25013903          	ld	s2,592(sp)
 198:	24813983          	ld	s3,584(sp)
 19c:	24013a03          	ld	s4,576(sp)
 1a0:	23813a83          	ld	s5,568(sp)
 1a4:	23013b03          	ld	s6,560(sp)
 1a8:	27010113          	addi	sp,sp,624
 1ac:	8082                	ret

00000000000001ae <main>:

int main(int argc,const char* argv[])
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
	if (argc < 3)
 1b6:	4789                	li	a5,2
 1b8:	00a7cf63          	blt	a5,a0,1d6 <main+0x28>
	{
		printf("Usage: find <dir> <file> ...\n");
 1bc:	00001517          	auipc	a0,0x1
 1c0:	81c50513          	addi	a0,a0,-2020 # 9d8 <malloc+0x136>
 1c4:	00000097          	auipc	ra,0x0
 1c8:	626080e7          	jalr	1574(ra) # 7ea <printf>
		exit(1);
 1cc:	4505                	li	a0,1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	292080e7          	jalr	658(ra) # 460 <exit>
	}
	des = (char*)argv[2];
 1d6:	699c                	ld	a5,16(a1)
 1d8:	00001717          	auipc	a4,0x1
 1dc:	88f73c23          	sd	a5,-1896(a4) # a70 <des>
	find(argv[1]);
 1e0:	6588                	ld	a0,8(a1)
 1e2:	00000097          	auipc	ra,0x0
 1e6:	e1e080e7          	jalr	-482(ra) # 0 <find>
	exit(0);
 1ea:	4501                	li	a0,0
 1ec:	00000097          	auipc	ra,0x0
 1f0:	274080e7          	jalr	628(ra) # 460 <exit>

00000000000001f4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fa:	87aa                	mv	a5,a0
 1fc:	0585                	addi	a1,a1,1
 1fe:	0785                	addi	a5,a5,1
 200:	fff5c703          	lbu	a4,-1(a1)
 204:	fee78fa3          	sb	a4,-1(a5)
 208:	fb75                	bnez	a4,1fc <strcpy+0x8>
    ;
  return os;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 216:	00054783          	lbu	a5,0(a0)
 21a:	cb91                	beqz	a5,22e <strcmp+0x1e>
 21c:	0005c703          	lbu	a4,0(a1)
 220:	00f71763          	bne	a4,a5,22e <strcmp+0x1e>
    p++, q++;
 224:	0505                	addi	a0,a0,1
 226:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 228:	00054783          	lbu	a5,0(a0)
 22c:	fbe5                	bnez	a5,21c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 22e:	0005c503          	lbu	a0,0(a1)
}
 232:	40a7853b          	subw	a0,a5,a0
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret

000000000000023c <strlen>:

uint
strlen(const char *s)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 242:	00054783          	lbu	a5,0(a0)
 246:	cf91                	beqz	a5,262 <strlen+0x26>
 248:	0505                	addi	a0,a0,1
 24a:	87aa                	mv	a5,a0
 24c:	4685                	li	a3,1
 24e:	9e89                	subw	a3,a3,a0
 250:	00f6853b          	addw	a0,a3,a5
 254:	0785                	addi	a5,a5,1
 256:	fff7c703          	lbu	a4,-1(a5)
 25a:	fb7d                	bnez	a4,250 <strlen+0x14>
    ;
  return n;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
  for(n = 0; s[n]; n++)
 262:	4501                	li	a0,0
 264:	bfe5                	j	25c <strlen+0x20>

0000000000000266 <memset>:

void*
memset(void *dst, int c, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 26c:	ca19                	beqz	a2,282 <memset+0x1c>
 26e:	87aa                	mv	a5,a0
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 278:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27c:	0785                	addi	a5,a5,1
 27e:	fee79de3          	bne	a5,a4,278 <memset+0x12>
  }
  return dst;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strchr>:

char*
strchr(const char *s, char c)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb99                	beqz	a5,2a8 <strchr+0x20>
    if(*s == c)
 294:	00f58763          	beq	a1,a5,2a2 <strchr+0x1a>
  for(; *s; s++)
 298:	0505                	addi	a0,a0,1
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbfd                	bnez	a5,294 <strchr+0xc>
      return (char*)s;
  return 0;
 2a0:	4501                	li	a0,0
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	bfe5                	j	2a2 <strchr+0x1a>

00000000000002ac <gets>:

char*
gets(char *buf, int max)
{
 2ac:	711d                	addi	sp,sp,-96
 2ae:	ec86                	sd	ra,88(sp)
 2b0:	e8a2                	sd	s0,80(sp)
 2b2:	e4a6                	sd	s1,72(sp)
 2b4:	e0ca                	sd	s2,64(sp)
 2b6:	fc4e                	sd	s3,56(sp)
 2b8:	f852                	sd	s4,48(sp)
 2ba:	f456                	sd	s5,40(sp)
 2bc:	f05a                	sd	s6,32(sp)
 2be:	ec5e                	sd	s7,24(sp)
 2c0:	1080                	addi	s0,sp,96
 2c2:	8baa                	mv	s7,a0
 2c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	892a                	mv	s2,a0
 2c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ca:	4aa9                	li	s5,10
 2cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ce:	89a6                	mv	s3,s1
 2d0:	2485                	addiw	s1,s1,1
 2d2:	0344d863          	bge	s1,s4,302 <gets+0x56>
    cc = read(0, &c, 1);
 2d6:	4605                	li	a2,1
 2d8:	faf40593          	addi	a1,s0,-81
 2dc:	4501                	li	a0,0
 2de:	00000097          	auipc	ra,0x0
 2e2:	19a080e7          	jalr	410(ra) # 478 <read>
    if(cc < 1)
 2e6:	00a05e63          	blez	a0,302 <gets+0x56>
    buf[i++] = c;
 2ea:	faf44783          	lbu	a5,-81(s0)
 2ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f2:	01578763          	beq	a5,s5,300 <gets+0x54>
 2f6:	0905                	addi	s2,s2,1
 2f8:	fd679be3          	bne	a5,s6,2ce <gets+0x22>
  for(i=0; i+1 < max; ){
 2fc:	89a6                	mv	s3,s1
 2fe:	a011                	j	302 <gets+0x56>
 300:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 302:	99de                	add	s3,s3,s7
 304:	00098023          	sb	zero,0(s3)
  return buf;
}
 308:	855e                	mv	a0,s7
 30a:	60e6                	ld	ra,88(sp)
 30c:	6446                	ld	s0,80(sp)
 30e:	64a6                	ld	s1,72(sp)
 310:	6906                	ld	s2,64(sp)
 312:	79e2                	ld	s3,56(sp)
 314:	7a42                	ld	s4,48(sp)
 316:	7aa2                	ld	s5,40(sp)
 318:	7b02                	ld	s6,32(sp)
 31a:	6be2                	ld	s7,24(sp)
 31c:	6125                	addi	sp,sp,96
 31e:	8082                	ret

0000000000000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	e426                	sd	s1,8(sp)
 328:	e04a                	sd	s2,0(sp)
 32a:	1000                	addi	s0,sp,32
 32c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32e:	4581                	li	a1,0
 330:	00000097          	auipc	ra,0x0
 334:	170080e7          	jalr	368(ra) # 4a0 <open>
  if(fd < 0)
 338:	02054563          	bltz	a0,362 <stat+0x42>
 33c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33e:	85ca                	mv	a1,s2
 340:	00000097          	auipc	ra,0x0
 344:	178080e7          	jalr	376(ra) # 4b8 <fstat>
 348:	892a                	mv	s2,a0
  close(fd);
 34a:	8526                	mv	a0,s1
 34c:	00000097          	auipc	ra,0x0
 350:	13c080e7          	jalr	316(ra) # 488 <close>
  return r;
}
 354:	854a                	mv	a0,s2
 356:	60e2                	ld	ra,24(sp)
 358:	6442                	ld	s0,16(sp)
 35a:	64a2                	ld	s1,8(sp)
 35c:	6902                	ld	s2,0(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret
    return -1;
 362:	597d                	li	s2,-1
 364:	bfc5                	j	354 <stat+0x34>

0000000000000366 <atoi>:

int
atoi(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36c:	00054683          	lbu	a3,0(a0)
 370:	fd06879b          	addiw	a5,a3,-48
 374:	0ff7f793          	zext.b	a5,a5
 378:	4625                	li	a2,9
 37a:	02f66863          	bltu	a2,a5,3aa <atoi+0x44>
 37e:	872a                	mv	a4,a0
  n = 0;
 380:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 382:	0705                	addi	a4,a4,1
 384:	0025179b          	slliw	a5,a0,0x2
 388:	9fa9                	addw	a5,a5,a0
 38a:	0017979b          	slliw	a5,a5,0x1
 38e:	9fb5                	addw	a5,a5,a3
 390:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 394:	00074683          	lbu	a3,0(a4)
 398:	fd06879b          	addiw	a5,a3,-48
 39c:	0ff7f793          	zext.b	a5,a5
 3a0:	fef671e3          	bgeu	a2,a5,382 <atoi+0x1c>
  return n;
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  n = 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <atoi+0x3e>

00000000000003ae <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b4:	02b57463          	bgeu	a0,a1,3dc <memmove+0x2e>
    while(n-- > 0)
 3b8:	00c05f63          	blez	a2,3d6 <memmove+0x28>
 3bc:	1602                	slli	a2,a2,0x20
 3be:	9201                	srli	a2,a2,0x20
 3c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c6:	0585                	addi	a1,a1,1
 3c8:	0705                	addi	a4,a4,1
 3ca:	fff5c683          	lbu	a3,-1(a1)
 3ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d2:	fee79ae3          	bne	a5,a4,3c6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
    dst += n;
 3dc:	00c50733          	add	a4,a0,a2
    src += n;
 3e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e2:	fec05ae3          	blez	a2,3d6 <memmove+0x28>
 3e6:	fff6079b          	addiw	a5,a2,-1
 3ea:	1782                	slli	a5,a5,0x20
 3ec:	9381                	srli	a5,a5,0x20
 3ee:	fff7c793          	not	a5,a5
 3f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f4:	15fd                	addi	a1,a1,-1
 3f6:	177d                	addi	a4,a4,-1
 3f8:	0005c683          	lbu	a3,0(a1)
 3fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 400:	fee79ae3          	bne	a5,a4,3f4 <memmove+0x46>
 404:	bfc9                	j	3d6 <memmove+0x28>

0000000000000406 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e422                	sd	s0,8(sp)
 40a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40c:	ca05                	beqz	a2,43c <memcmp+0x36>
 40e:	fff6069b          	addiw	a3,a2,-1
 412:	1682                	slli	a3,a3,0x20
 414:	9281                	srli	a3,a3,0x20
 416:	0685                	addi	a3,a3,1
 418:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 41a:	00054783          	lbu	a5,0(a0)
 41e:	0005c703          	lbu	a4,0(a1)
 422:	00e79863          	bne	a5,a4,432 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 426:	0505                	addi	a0,a0,1
    p2++;
 428:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 42a:	fed518e3          	bne	a0,a3,41a <memcmp+0x14>
  }
  return 0;
 42e:	4501                	li	a0,0
 430:	a019                	j	436 <memcmp+0x30>
      return *p1 - *p2;
 432:	40e7853b          	subw	a0,a5,a4
}
 436:	6422                	ld	s0,8(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
  return 0;
 43c:	4501                	li	a0,0
 43e:	bfe5                	j	436 <memcmp+0x30>

0000000000000440 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 448:	00000097          	auipc	ra,0x0
 44c:	f66080e7          	jalr	-154(ra) # 3ae <memmove>
}
 450:	60a2                	ld	ra,8(sp)
 452:	6402                	ld	s0,0(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret

0000000000000458 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 458:	4885                	li	a7,1
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <exit>:
.global exit
exit:
 li a7, SYS_exit
 460:	4889                	li	a7,2
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <wait>:
.global wait
wait:
 li a7, SYS_wait
 468:	488d                	li	a7,3
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 470:	4891                	li	a7,4
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <read>:
.global read
read:
 li a7, SYS_read
 478:	4895                	li	a7,5
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <write>:
.global write
write:
 li a7, SYS_write
 480:	48c1                	li	a7,16
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <close>:
.global close
close:
 li a7, SYS_close
 488:	48d5                	li	a7,21
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <kill>:
.global kill
kill:
 li a7, SYS_kill
 490:	4899                	li	a7,6
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <exec>:
.global exec
exec:
 li a7, SYS_exec
 498:	489d                	li	a7,7
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <open>:
.global open
open:
 li a7, SYS_open
 4a0:	48bd                	li	a7,15
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a8:	48c5                	li	a7,17
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b0:	48c9                	li	a7,18
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b8:	48a1                	li	a7,8
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <link>:
.global link
link:
 li a7, SYS_link
 4c0:	48cd                	li	a7,19
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c8:	48d1                	li	a7,20
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d0:	48a5                	li	a7,9
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d8:	48a9                	li	a7,10
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e0:	48ad                	li	a7,11
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e8:	48b1                	li	a7,12
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f0:	48b5                	li	a7,13
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f8:	48b9                	li	a7,14
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <trace>:
.global trace
trace:
 li a7, SYS_trace
 500:	48d9                	li	a7,22
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 508:	48dd                	li	a7,23
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 510:	1101                	addi	sp,sp,-32
 512:	ec06                	sd	ra,24(sp)
 514:	e822                	sd	s0,16(sp)
 516:	1000                	addi	s0,sp,32
 518:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51c:	4605                	li	a2,1
 51e:	fef40593          	addi	a1,s0,-17
 522:	00000097          	auipc	ra,0x0
 526:	f5e080e7          	jalr	-162(ra) # 480 <write>
}
 52a:	60e2                	ld	ra,24(sp)
 52c:	6442                	ld	s0,16(sp)
 52e:	6105                	addi	sp,sp,32
 530:	8082                	ret

0000000000000532 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 532:	7139                	addi	sp,sp,-64
 534:	fc06                	sd	ra,56(sp)
 536:	f822                	sd	s0,48(sp)
 538:	f426                	sd	s1,40(sp)
 53a:	f04a                	sd	s2,32(sp)
 53c:	ec4e                	sd	s3,24(sp)
 53e:	0080                	addi	s0,sp,64
 540:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 542:	c299                	beqz	a3,548 <printint+0x16>
 544:	0805c963          	bltz	a1,5d6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 548:	2581                	sext.w	a1,a1
  neg = 0;
 54a:	4881                	li	a7,0
 54c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 550:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 552:	2601                	sext.w	a2,a2
 554:	00000517          	auipc	a0,0x0
 558:	50450513          	addi	a0,a0,1284 # a58 <digits>
 55c:	883a                	mv	a6,a4
 55e:	2705                	addiw	a4,a4,1
 560:	02c5f7bb          	remuw	a5,a1,a2
 564:	1782                	slli	a5,a5,0x20
 566:	9381                	srli	a5,a5,0x20
 568:	97aa                	add	a5,a5,a0
 56a:	0007c783          	lbu	a5,0(a5)
 56e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 572:	0005879b          	sext.w	a5,a1
 576:	02c5d5bb          	divuw	a1,a1,a2
 57a:	0685                	addi	a3,a3,1
 57c:	fec7f0e3          	bgeu	a5,a2,55c <printint+0x2a>
  if(neg)
 580:	00088c63          	beqz	a7,598 <printint+0x66>
    buf[i++] = '-';
 584:	fd070793          	addi	a5,a4,-48
 588:	00878733          	add	a4,a5,s0
 58c:	02d00793          	li	a5,45
 590:	fef70823          	sb	a5,-16(a4)
 594:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 598:	02e05863          	blez	a4,5c8 <printint+0x96>
 59c:	fc040793          	addi	a5,s0,-64
 5a0:	00e78933          	add	s2,a5,a4
 5a4:	fff78993          	addi	s3,a5,-1
 5a8:	99ba                	add	s3,s3,a4
 5aa:	377d                	addiw	a4,a4,-1
 5ac:	1702                	slli	a4,a4,0x20
 5ae:	9301                	srli	a4,a4,0x20
 5b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b4:	fff94583          	lbu	a1,-1(s2)
 5b8:	8526                	mv	a0,s1
 5ba:	00000097          	auipc	ra,0x0
 5be:	f56080e7          	jalr	-170(ra) # 510 <putc>
  while(--i >= 0)
 5c2:	197d                	addi	s2,s2,-1
 5c4:	ff3918e3          	bne	s2,s3,5b4 <printint+0x82>
}
 5c8:	70e2                	ld	ra,56(sp)
 5ca:	7442                	ld	s0,48(sp)
 5cc:	74a2                	ld	s1,40(sp)
 5ce:	7902                	ld	s2,32(sp)
 5d0:	69e2                	ld	s3,24(sp)
 5d2:	6121                	addi	sp,sp,64
 5d4:	8082                	ret
    x = -xx;
 5d6:	40b005bb          	negw	a1,a1
    neg = 1;
 5da:	4885                	li	a7,1
    x = -xx;
 5dc:	bf85                	j	54c <printint+0x1a>

00000000000005de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5de:	7119                	addi	sp,sp,-128
 5e0:	fc86                	sd	ra,120(sp)
 5e2:	f8a2                	sd	s0,112(sp)
 5e4:	f4a6                	sd	s1,104(sp)
 5e6:	f0ca                	sd	s2,96(sp)
 5e8:	ecce                	sd	s3,88(sp)
 5ea:	e8d2                	sd	s4,80(sp)
 5ec:	e4d6                	sd	s5,72(sp)
 5ee:	e0da                	sd	s6,64(sp)
 5f0:	fc5e                	sd	s7,56(sp)
 5f2:	f862                	sd	s8,48(sp)
 5f4:	f466                	sd	s9,40(sp)
 5f6:	f06a                	sd	s10,32(sp)
 5f8:	ec6e                	sd	s11,24(sp)
 5fa:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fc:	0005c903          	lbu	s2,0(a1)
 600:	18090f63          	beqz	s2,79e <vprintf+0x1c0>
 604:	8aaa                	mv	s5,a0
 606:	8b32                	mv	s6,a2
 608:	00158493          	addi	s1,a1,1
  state = 0;
 60c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60e:	02500a13          	li	s4,37
 612:	4c55                	li	s8,21
 614:	00000c97          	auipc	s9,0x0
 618:	3ecc8c93          	addi	s9,s9,1004 # a00 <malloc+0x15e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61c:	02800d93          	li	s11,40
  putc(fd, 'x');
 620:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	436b8b93          	addi	s7,s7,1078 # a58 <digits>
 62a:	a839                	j	648 <vprintf+0x6a>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	ee0080e7          	jalr	-288(ra) # 510 <putc>
 638:	a019                	j	63e <vprintf+0x60>
    } else if(state == '%'){
 63a:	01498d63          	beq	s3,s4,654 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 63e:	0485                	addi	s1,s1,1
 640:	fff4c903          	lbu	s2,-1(s1)
 644:	14090d63          	beqz	s2,79e <vprintf+0x1c0>
    if(state == 0){
 648:	fe0999e3          	bnez	s3,63a <vprintf+0x5c>
      if(c == '%'){
 64c:	ff4910e3          	bne	s2,s4,62c <vprintf+0x4e>
        state = '%';
 650:	89d2                	mv	s3,s4
 652:	b7f5                	j	63e <vprintf+0x60>
      if(c == 'd'){
 654:	11490c63          	beq	s2,s4,76c <vprintf+0x18e>
 658:	f9d9079b          	addiw	a5,s2,-99
 65c:	0ff7f793          	zext.b	a5,a5
 660:	10fc6e63          	bltu	s8,a5,77c <vprintf+0x19e>
 664:	f9d9079b          	addiw	a5,s2,-99
 668:	0ff7f713          	zext.b	a4,a5
 66c:	10ec6863          	bltu	s8,a4,77c <vprintf+0x19e>
 670:	00271793          	slli	a5,a4,0x2
 674:	97e6                	add	a5,a5,s9
 676:	439c                	lw	a5,0(a5)
 678:	97e6                	add	a5,a5,s9
 67a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 67c:	008b0913          	addi	s2,s6,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000b2583          	lw	a1,0(s6)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	ea8080e7          	jalr	-344(ra) # 532 <printint>
 692:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 694:	4981                	li	s3,0
 696:	b765                	j	63e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	008b0913          	addi	s2,s6,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000b2583          	lw	a1,0(s6)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	e8c080e7          	jalr	-372(ra) # 532 <printint>
 6ae:	8b4a                	mv	s6,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b771                	j	63e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b4:	008b0913          	addi	s2,s6,8
 6b8:	4681                	li	a3,0
 6ba:	866a                	mv	a2,s10
 6bc:	000b2583          	lw	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e70080e7          	jalr	-400(ra) # 532 <printint>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bf85                	j	63e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d0:	008b0793          	addi	a5,s6,8
 6d4:	f8f43423          	sd	a5,-120(s0)
 6d8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6dc:	03000593          	li	a1,48
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e2e080e7          	jalr	-466(ra) # 510 <putc>
  putc(fd, 'x');
 6ea:	07800593          	li	a1,120
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e20080e7          	jalr	-480(ra) # 510 <putc>
 6f8:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e0a080e7          	jalr	-502(ra) # 510 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	397d                	addiw	s2,s2,-1
 712:	fe0914e3          	bnez	s2,6fa <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 716:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b70d                	j	63e <vprintf+0x60>
        s = va_arg(ap, char*);
 71e:	008b0913          	addi	s2,s6,8
 722:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 726:	02098163          	beqz	s3,748 <vprintf+0x16a>
        while(*s != 0){
 72a:	0009c583          	lbu	a1,0(s3)
 72e:	c5ad                	beqz	a1,798 <vprintf+0x1ba>
          putc(fd, *s);
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	dde080e7          	jalr	-546(ra) # 510 <putc>
          s++;
 73a:	0985                	addi	s3,s3,1
        while(*s != 0){
 73c:	0009c583          	lbu	a1,0(s3)
 740:	f9e5                	bnez	a1,730 <vprintf+0x152>
        s = va_arg(ap, char*);
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bde5                	j	63e <vprintf+0x60>
          s = "(null)";
 748:	00000997          	auipc	s3,0x0
 74c:	2b098993          	addi	s3,s3,688 # 9f8 <malloc+0x156>
        while(*s != 0){
 750:	85ee                	mv	a1,s11
 752:	bff9                	j	730 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 754:	008b0913          	addi	s2,s6,8
 758:	000b4583          	lbu	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	db2080e7          	jalr	-590(ra) # 510 <putc>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bdd1                	j	63e <vprintf+0x60>
        putc(fd, c);
 76c:	85d2                	mv	a1,s4
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	da0080e7          	jalr	-608(ra) # 510 <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	b5d1                	j	63e <vprintf+0x60>
        putc(fd, '%');
 77c:	85d2                	mv	a1,s4
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d90080e7          	jalr	-624(ra) # 510 <putc>
        putc(fd, c);
 788:	85ca                	mv	a1,s2
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	d84080e7          	jalr	-636(ra) # 510 <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	b565                	j	63e <vprintf+0x60>
        s = va_arg(ap, char*);
 798:	8b4a                	mv	s6,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b54d                	j	63e <vprintf+0x60>
    }
  }
}
 79e:	70e6                	ld	ra,120(sp)
 7a0:	7446                	ld	s0,112(sp)
 7a2:	74a6                	ld	s1,104(sp)
 7a4:	7906                	ld	s2,96(sp)
 7a6:	69e6                	ld	s3,88(sp)
 7a8:	6a46                	ld	s4,80(sp)
 7aa:	6aa6                	ld	s5,72(sp)
 7ac:	6b06                	ld	s6,64(sp)
 7ae:	7be2                	ld	s7,56(sp)
 7b0:	7c42                	ld	s8,48(sp)
 7b2:	7ca2                	ld	s9,40(sp)
 7b4:	7d02                	ld	s10,32(sp)
 7b6:	6de2                	ld	s11,24(sp)
 7b8:	6109                	addi	sp,sp,128
 7ba:	8082                	ret

00000000000007bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7bc:	715d                	addi	sp,sp,-80
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e010                	sd	a2,0(s0)
 7c6:	e414                	sd	a3,8(s0)
 7c8:	e818                	sd	a4,16(s0)
 7ca:	ec1c                	sd	a5,24(s0)
 7cc:	03043023          	sd	a6,32(s0)
 7d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d8:	8622                	mv	a2,s0
 7da:	00000097          	auipc	ra,0x0
 7de:	e04080e7          	jalr	-508(ra) # 5de <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6161                	addi	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <printf>:

void
printf(const char *fmt, ...)
{
 7ea:	711d                	addi	sp,sp,-96
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 804:	00840613          	addi	a2,s0,8
 808:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80c:	85aa                	mv	a1,a0
 80e:	4505                	li	a0,1
 810:	00000097          	auipc	ra,0x0
 814:	dce080e7          	jalr	-562(ra) # 5de <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	1141                	addi	sp,sp,-16
 822:	e422                	sd	s0,8(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00000797          	auipc	a5,0x0
 82e:	24e7b783          	ld	a5,590(a5) # a78 <freep>
 832:	a02d                	j	85c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 834:	4618                	lw	a4,8(a2)
 836:	9f2d                	addw	a4,a4,a1
 838:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	6310                	ld	a2,0(a4)
 840:	a83d                	j	87e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 842:	ff852703          	lw	a4,-8(a0)
 846:	9f31                	addw	a4,a4,a2
 848:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84a:	ff053683          	ld	a3,-16(a0)
 84e:	a091                	j	892 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	6398                	ld	a4,0(a5)
 852:	00e7e463          	bltu	a5,a4,85a <free+0x3a>
 856:	00e6ea63          	bltu	a3,a4,86a <free+0x4a>
{
 85a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	fed7fae3          	bgeu	a5,a3,850 <free+0x30>
 860:	6398                	ld	a4,0(a5)
 862:	00e6e463          	bltu	a3,a4,86a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	fee7eae3          	bltu	a5,a4,85a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86a:	ff852583          	lw	a1,-8(a0)
 86e:	6390                	ld	a2,0(a5)
 870:	02059813          	slli	a6,a1,0x20
 874:	01c85713          	srli	a4,a6,0x1c
 878:	9736                	add	a4,a4,a3
 87a:	fae60de3          	beq	a2,a4,834 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 882:	4790                	lw	a2,8(a5)
 884:	02061593          	slli	a1,a2,0x20
 888:	01c5d713          	srli	a4,a1,0x1c
 88c:	973e                	add	a4,a4,a5
 88e:	fae68ae3          	beq	a3,a4,842 <free+0x22>
    p->s.ptr = bp->s.ptr;
 892:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 894:	00000717          	auipc	a4,0x0
 898:	1ef73223          	sd	a5,484(a4) # a78 <freep>
}
 89c:	6422                	ld	s0,8(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret

00000000000008a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a2:	7139                	addi	sp,sp,-64
 8a4:	fc06                	sd	ra,56(sp)
 8a6:	f822                	sd	s0,48(sp)
 8a8:	f426                	sd	s1,40(sp)
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
 8b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b6:	02051493          	slli	s1,a0,0x20
 8ba:	9081                	srli	s1,s1,0x20
 8bc:	04bd                	addi	s1,s1,15
 8be:	8091                	srli	s1,s1,0x4
 8c0:	0014899b          	addiw	s3,s1,1
 8c4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c6:	00000517          	auipc	a0,0x0
 8ca:	1b253503          	ld	a0,434(a0) # a78 <freep>
 8ce:	c515                	beqz	a0,8fa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d2:	4798                	lw	a4,8(a5)
 8d4:	02977f63          	bgeu	a4,s1,912 <malloc+0x70>
 8d8:	8a4e                	mv	s4,s3
 8da:	0009871b          	sext.w	a4,s3
 8de:	6685                	lui	a3,0x1
 8e0:	00d77363          	bgeu	a4,a3,8e6 <malloc+0x44>
 8e4:	6a05                	lui	s4,0x1
 8e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ee:	00000917          	auipc	s2,0x0
 8f2:	18a90913          	addi	s2,s2,394 # a78 <freep>
  if(p == (char*)-1)
 8f6:	5afd                	li	s5,-1
 8f8:	a895                	j	96c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8fa:	00000797          	auipc	a5,0x0
 8fe:	18678793          	addi	a5,a5,390 # a80 <base>
 902:	00000717          	auipc	a4,0x0
 906:	16f73b23          	sd	a5,374(a4) # a78 <freep>
 90a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 910:	b7e1                	j	8d8 <malloc+0x36>
      if(p->s.size == nunits)
 912:	02e48c63          	beq	s1,a4,94a <malloc+0xa8>
        p->s.size -= nunits;
 916:	4137073b          	subw	a4,a4,s3
 91a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91c:	02071693          	slli	a3,a4,0x20
 920:	01c6d713          	srli	a4,a3,0x1c
 924:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 926:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92a:	00000717          	auipc	a4,0x0
 92e:	14a73723          	sd	a0,334(a4) # a78 <freep>
      return (void*)(p + 1);
 932:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	74a2                	ld	s1,40(sp)
 93c:	7902                	ld	s2,32(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	6121                	addi	sp,sp,64
 948:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94a:	6398                	ld	a4,0(a5)
 94c:	e118                	sd	a4,0(a0)
 94e:	bff1                	j	92a <malloc+0x88>
  hp->s.size = nu;
 950:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 954:	0541                	addi	a0,a0,16
 956:	00000097          	auipc	ra,0x0
 95a:	eca080e7          	jalr	-310(ra) # 820 <free>
  return freep;
 95e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 962:	d971                	beqz	a0,936 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 966:	4798                	lw	a4,8(a5)
 968:	fa9775e3          	bgeu	a4,s1,912 <malloc+0x70>
    if(p == freep)
 96c:	00093703          	ld	a4,0(s2)
 970:	853e                	mv	a0,a5
 972:	fef719e3          	bne	a4,a5,964 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 976:	8552                	mv	a0,s4
 978:	00000097          	auipc	ra,0x0
 97c:	b70080e7          	jalr	-1168(ra) # 4e8 <sbrk>
  if(p == (char*)-1)
 980:	fd5518e3          	bne	a0,s5,950 <malloc+0xae>
        return 0;
 984:	4501                	li	a0,0
 986:	bf45                	j	936 <malloc+0x94>
