
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8e013103          	ld	sp,-1824(sp) # 800088e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0fd050ef          	jal	ra,80005912 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	29e080e7          	jalr	670(ra) # 800062f8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	33e080e7          	jalr	830(ra) # 800063ac <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d36080e7          	jalr	-714(ra) # 80005dc0 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	172080e7          	jalr	370(ra) # 80006268 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	1ca080e7          	jalr	458(ra) # 800062f8 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	266080e7          	jalr	614(ra) # 800063ac <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	23c080e7          	jalr	572(ra) # 800063ac <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	bee080e7          	jalr	-1042(ra) # 80000f16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	bd2080e7          	jalr	-1070(ra) # 80000f16 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	ab4080e7          	jalr	-1356(ra) # 80005e0a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8ec080e7          	jalr	-1812(ra) # 80001c52 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f82080e7          	jalr	-126(ra) # 800052f0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	198080e7          	jalr	408(ra) # 8000150e <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	952080e7          	jalr	-1710(ra) # 80005cd0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c64080e7          	jalr	-924(ra) # 80005fea <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a74080e7          	jalr	-1420(ra) # 80005e0a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a64080e7          	jalr	-1436(ra) # 80005e0a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a54080e7          	jalr	-1452(ra) # 80005e0a <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a92080e7          	jalr	-1390(ra) # 80000e68 <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	84c080e7          	jalr	-1972(ra) # 80001c2a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	86c080e7          	jalr	-1940(ra) # 80001c52 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	eec080e7          	jalr	-276(ra) # 800052da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	efa080e7          	jalr	-262(ra) # 800052f0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	09e080e7          	jalr	158(ra) # 8000249c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	72c080e7          	jalr	1836(ra) # 80002b32 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6de080e7          	jalr	1758(ra) # 80003aec <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ffa080e7          	jalr	-6(ra) # 80005410 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	eb6080e7          	jalr	-330(ra) # 800012d4 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	938080e7          	jalr	-1736(ra) # 80005dc0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	812080e7          	jalr	-2030(ra) # 80005dc0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	802080e7          	jalr	-2046(ra) # 80005dc0 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	7b6080e7          	jalr	1974(ra) # 80005dc0 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	702080e7          	jalr	1794(ra) # 80000dd4 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	66a080e7          	jalr	1642(ra) # 80005dc0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	65a080e7          	jalr	1626(ra) # 80005dc0 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	64a080e7          	jalr	1610(ra) # 80005dc0 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	63a080e7          	jalr	1594(ra) # 80005dc0 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	55c080e7          	jalr	1372(ra) # 80005dc0 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	418080e7          	jalr	1048(ra) # 80005dc0 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	33a080e7          	jalr	826(ra) # 80005dc0 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	32a080e7          	jalr	810(ra) # 80005dc0 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	2c0080e7          	jalr	704(ra) # 80005dc0 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <_vmprint>:

void _vmprint(pagetable_t pagetable, int level) {
    80000cd2:	7119                	addi	sp,sp,-128
    80000cd4:	fc86                	sd	ra,120(sp)
    80000cd6:	f8a2                	sd	s0,112(sp)
    80000cd8:	f4a6                	sd	s1,104(sp)
    80000cda:	f0ca                	sd	s2,96(sp)
    80000cdc:	ecce                	sd	s3,88(sp)
    80000cde:	e8d2                	sd	s4,80(sp)
    80000ce0:	e4d6                	sd	s5,72(sp)
    80000ce2:	e0da                	sd	s6,64(sp)
    80000ce4:	fc5e                	sd	s7,56(sp)
    80000ce6:	f862                	sd	s8,48(sp)
    80000ce8:	f466                	sd	s9,40(sp)
    80000cea:	f06a                	sd	s10,32(sp)
    80000cec:	ec6e                	sd	s11,24(sp)
    80000cee:	0100                	addi	s0,sp,128
    80000cf0:	8aae                	mv	s5,a1
 for (int i = 0; i < 512; i++) {
    80000cf2:	8a2a                	mv	s4,a0
    80000cf4:	4981                	li	s3,0
  pte_t pte = pagetable[i];
  if (pte & PTE_V) {
   uint64 pa = PTE2PA(pte);
   for (int j = 0; j < level; j++) {
    80000cf6:	4d81                	li	s11,0
   if (j) printf(" ");
   printf("..");
    80000cf8:	00007b17          	auipc	s6,0x7
    80000cfc:	468b0b13          	addi	s6,s6,1128 # 80008160 <etext+0x160>
   if (j) printf(" ");
    80000d00:	00007c17          	auipc	s8,0x7
    80000d04:	458c0c13          	addi	s8,s8,1112 # 80008158 <etext+0x158>
   }
  printf("%d: pte %p pa %p\n", i, pte, pa);
    80000d08:	00007d17          	auipc	s10,0x7
    80000d0c:	460d0d13          	addi	s10,s10,1120 # 80008168 <etext+0x168>
  if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
  _vmprint((pagetable_t)pa, level+1);
    80000d10:	0015879b          	addiw	a5,a1,1
    80000d14:	f8f43423          	sd	a5,-120(s0)
 for (int i = 0; i < 512; i++) {
    80000d18:	20000c93          	li	s9,512
    80000d1c:	a00d                	j	80000d3e <_vmprint+0x6c>
  printf("%d: pte %p pa %p\n", i, pte, pa);
    80000d1e:	86de                	mv	a3,s7
    80000d20:	864a                	mv	a2,s2
    80000d22:	85ce                	mv	a1,s3
    80000d24:	856a                	mv	a0,s10
    80000d26:	00005097          	auipc	ra,0x5
    80000d2a:	0e4080e7          	jalr	228(ra) # 80005e0a <printf>
  if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d2e:	00e97913          	andi	s2,s2,14
    80000d32:	04090063          	beqz	s2,80000d72 <_vmprint+0xa0>
 for (int i = 0; i < 512; i++) {
    80000d36:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d38:	0a21                	addi	s4,s4,8
    80000d3a:	05998463          	beq	s3,s9,80000d82 <_vmprint+0xb0>
  pte_t pte = pagetable[i];
    80000d3e:	000a3903          	ld	s2,0(s4)
  if (pte & PTE_V) {
    80000d42:	00197793          	andi	a5,s2,1
    80000d46:	dbe5                	beqz	a5,80000d36 <_vmprint+0x64>
   uint64 pa = PTE2PA(pte);
    80000d48:	00a95b93          	srli	s7,s2,0xa
    80000d4c:	0bb2                	slli	s7,s7,0xc
   for (int j = 0; j < level; j++) {
    80000d4e:	84ee                	mv	s1,s11
    80000d50:	fd5057e3          	blez	s5,80000d1e <_vmprint+0x4c>
   printf("..");
    80000d54:	855a                	mv	a0,s6
    80000d56:	00005097          	auipc	ra,0x5
    80000d5a:	0b4080e7          	jalr	180(ra) # 80005e0a <printf>
   for (int j = 0; j < level; j++) {
    80000d5e:	2485                	addiw	s1,s1,1
    80000d60:	fa9a8fe3          	beq	s5,s1,80000d1e <_vmprint+0x4c>
   if (j) printf(" ");
    80000d64:	d8e5                	beqz	s1,80000d54 <_vmprint+0x82>
    80000d66:	8562                	mv	a0,s8
    80000d68:	00005097          	auipc	ra,0x5
    80000d6c:	0a2080e7          	jalr	162(ra) # 80005e0a <printf>
    80000d70:	b7d5                	j	80000d54 <_vmprint+0x82>
  _vmprint((pagetable_t)pa, level+1);
    80000d72:	f8843583          	ld	a1,-120(s0)
    80000d76:	855e                	mv	a0,s7
    80000d78:	00000097          	auipc	ra,0x0
    80000d7c:	f5a080e7          	jalr	-166(ra) # 80000cd2 <_vmprint>
    80000d80:	bf5d                	j	80000d36 <_vmprint+0x64>
   }
  }
 }
}
    80000d82:	70e6                	ld	ra,120(sp)
    80000d84:	7446                	ld	s0,112(sp)
    80000d86:	74a6                	ld	s1,104(sp)
    80000d88:	7906                	ld	s2,96(sp)
    80000d8a:	69e6                	ld	s3,88(sp)
    80000d8c:	6a46                	ld	s4,80(sp)
    80000d8e:	6aa6                	ld	s5,72(sp)
    80000d90:	6b06                	ld	s6,64(sp)
    80000d92:	7be2                	ld	s7,56(sp)
    80000d94:	7c42                	ld	s8,48(sp)
    80000d96:	7ca2                	ld	s9,40(sp)
    80000d98:	7d02                	ld	s10,32(sp)
    80000d9a:	6de2                	ld	s11,24(sp)
    80000d9c:	6109                	addi	sp,sp,128
    80000d9e:	8082                	ret

0000000080000da0 <vmprint>:
void vmprint(pagetable_t pagetable) {
    80000da0:	1101                	addi	sp,sp,-32
    80000da2:	ec06                	sd	ra,24(sp)
    80000da4:	e822                	sd	s0,16(sp)
    80000da6:	e426                	sd	s1,8(sp)
    80000da8:	1000                	addi	s0,sp,32
    80000daa:	84aa                	mv	s1,a0
printf("page table %p\n", pagetable);
    80000dac:	85aa                	mv	a1,a0
    80000dae:	00007517          	auipc	a0,0x7
    80000db2:	3d250513          	addi	a0,a0,978 # 80008180 <etext+0x180>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	054080e7          	jalr	84(ra) # 80005e0a <printf>
_vmprint(pagetable, 1);
    80000dbe:	4585                	li	a1,1
    80000dc0:	8526                	mv	a0,s1
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	f10080e7          	jalr	-240(ra) # 80000cd2 <_vmprint>
}
    80000dca:	60e2                	ld	ra,24(sp)
    80000dcc:	6442                	ld	s0,16(sp)
    80000dce:	64a2                	ld	s1,8(sp)
    80000dd0:	6105                	addi	sp,sp,32
    80000dd2:	8082                	ret

0000000080000dd4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dd4:	7139                	addi	sp,sp,-64
    80000dd6:	fc06                	sd	ra,56(sp)
    80000dd8:	f822                	sd	s0,48(sp)
    80000dda:	f426                	sd	s1,40(sp)
    80000ddc:	f04a                	sd	s2,32(sp)
    80000dde:	ec4e                	sd	s3,24(sp)
    80000de0:	e852                	sd	s4,16(sp)
    80000de2:	e456                	sd	s5,8(sp)
    80000de4:	e05a                	sd	s6,0(sp)
    80000de6:	0080                	addi	s0,sp,64
    80000de8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dea:	00008497          	auipc	s1,0x8
    80000dee:	69648493          	addi	s1,s1,1686 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df2:	8b26                	mv	s6,s1
    80000df4:	00007a97          	auipc	s5,0x7
    80000df8:	20ca8a93          	addi	s5,s5,524 # 80008000 <etext>
    80000dfc:	01000937          	lui	s2,0x1000
    80000e00:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e02:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e04:	0000ea17          	auipc	s4,0xe
    80000e08:	27ca0a13          	addi	s4,s4,636 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e0c:	fffff097          	auipc	ra,0xfffff
    80000e10:	30e080e7          	jalr	782(ra) # 8000011a <kalloc>
    80000e14:	862a                	mv	a2,a0
    if(pa == 0)
    80000e16:	c129                	beqz	a0,80000e58 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e18:	416485b3          	sub	a1,s1,s6
    80000e1c:	8591                	srai	a1,a1,0x4
    80000e1e:	000ab783          	ld	a5,0(s5)
    80000e22:	02f585b3          	mul	a1,a1,a5
    80000e26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e2a:	4719                	li	a4,6
    80000e2c:	6685                	lui	a3,0x1
    80000e2e:	40b905b3          	sub	a1,s2,a1
    80000e32:	854e                	mv	a0,s3
    80000e34:	fffff097          	auipc	ra,0xfffff
    80000e38:	7ae080e7          	jalr	1966(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3c:	17048493          	addi	s1,s1,368
    80000e40:	fd4496e3          	bne	s1,s4,80000e0c <proc_mapstacks+0x38>
  }
}
    80000e44:	70e2                	ld	ra,56(sp)
    80000e46:	7442                	ld	s0,48(sp)
    80000e48:	74a2                	ld	s1,40(sp)
    80000e4a:	7902                	ld	s2,32(sp)
    80000e4c:	69e2                	ld	s3,24(sp)
    80000e4e:	6a42                	ld	s4,16(sp)
    80000e50:	6aa2                	ld	s5,8(sp)
    80000e52:	6b02                	ld	s6,0(sp)
    80000e54:	6121                	addi	sp,sp,64
    80000e56:	8082                	ret
      panic("kalloc");
    80000e58:	00007517          	auipc	a0,0x7
    80000e5c:	33850513          	addi	a0,a0,824 # 80008190 <etext+0x190>
    80000e60:	00005097          	auipc	ra,0x5
    80000e64:	f60080e7          	jalr	-160(ra) # 80005dc0 <panic>

0000000080000e68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e68:	7139                	addi	sp,sp,-64
    80000e6a:	fc06                	sd	ra,56(sp)
    80000e6c:	f822                	sd	s0,48(sp)
    80000e6e:	f426                	sd	s1,40(sp)
    80000e70:	f04a                	sd	s2,32(sp)
    80000e72:	ec4e                	sd	s3,24(sp)
    80000e74:	e852                	sd	s4,16(sp)
    80000e76:	e456                	sd	s5,8(sp)
    80000e78:	e05a                	sd	s6,0(sp)
    80000e7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e7c:	00007597          	auipc	a1,0x7
    80000e80:	31c58593          	addi	a1,a1,796 # 80008198 <etext+0x198>
    80000e84:	00008517          	auipc	a0,0x8
    80000e88:	1cc50513          	addi	a0,a0,460 # 80009050 <pid_lock>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	3dc080e7          	jalr	988(ra) # 80006268 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e94:	00007597          	auipc	a1,0x7
    80000e98:	30c58593          	addi	a1,a1,780 # 800081a0 <etext+0x1a0>
    80000e9c:	00008517          	auipc	a0,0x8
    80000ea0:	1cc50513          	addi	a0,a0,460 # 80009068 <wait_lock>
    80000ea4:	00005097          	auipc	ra,0x5
    80000ea8:	3c4080e7          	jalr	964(ra) # 80006268 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eac:	00008497          	auipc	s1,0x8
    80000eb0:	5d448493          	addi	s1,s1,1492 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000eb4:	00007b17          	auipc	s6,0x7
    80000eb8:	2fcb0b13          	addi	s6,s6,764 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000ebc:	8aa6                	mv	s5,s1
    80000ebe:	00007a17          	auipc	s4,0x7
    80000ec2:	142a0a13          	addi	s4,s4,322 # 80008000 <etext>
    80000ec6:	01000937          	lui	s2,0x1000
    80000eca:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ecc:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ece:	0000e997          	auipc	s3,0xe
    80000ed2:	1b298993          	addi	s3,s3,434 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000ed6:	85da                	mv	a1,s6
    80000ed8:	8526                	mv	a0,s1
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	38e080e7          	jalr	910(ra) # 80006268 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ee2:	415487b3          	sub	a5,s1,s5
    80000ee6:	8791                	srai	a5,a5,0x4
    80000ee8:	000a3703          	ld	a4,0(s4)
    80000eec:	02e787b3          	mul	a5,a5,a4
    80000ef0:	00d7979b          	slliw	a5,a5,0xd
    80000ef4:	40f907b3          	sub	a5,s2,a5
    80000ef8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efa:	17048493          	addi	s1,s1,368
    80000efe:	fd349ce3          	bne	s1,s3,80000ed6 <procinit+0x6e>
  }
}
    80000f02:	70e2                	ld	ra,56(sp)
    80000f04:	7442                	ld	s0,48(sp)
    80000f06:	74a2                	ld	s1,40(sp)
    80000f08:	7902                	ld	s2,32(sp)
    80000f0a:	69e2                	ld	s3,24(sp)
    80000f0c:	6a42                	ld	s4,16(sp)
    80000f0e:	6aa2                	ld	s5,8(sp)
    80000f10:	6b02                	ld	s6,0(sp)
    80000f12:	6121                	addi	sp,sp,64
    80000f14:	8082                	ret

0000000080000f16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f16:	1141                	addi	sp,sp,-16
    80000f18:	e422                	sd	s0,8(sp)
    80000f1a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f1c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f1e:	2501                	sext.w	a0,a0
    80000f20:	6422                	ld	s0,8(sp)
    80000f22:	0141                	addi	sp,sp,16
    80000f24:	8082                	ret

0000000080000f26 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f26:	1141                	addi	sp,sp,-16
    80000f28:	e422                	sd	s0,8(sp)
    80000f2a:	0800                	addi	s0,sp,16
    80000f2c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f2e:	2781                	sext.w	a5,a5
    80000f30:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f32:	00008517          	auipc	a0,0x8
    80000f36:	14e50513          	addi	a0,a0,334 # 80009080 <cpus>
    80000f3a:	953e                	add	a0,a0,a5
    80000f3c:	6422                	ld	s0,8(sp)
    80000f3e:	0141                	addi	sp,sp,16
    80000f40:	8082                	ret

0000000080000f42 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f42:	1101                	addi	sp,sp,-32
    80000f44:	ec06                	sd	ra,24(sp)
    80000f46:	e822                	sd	s0,16(sp)
    80000f48:	e426                	sd	s1,8(sp)
    80000f4a:	1000                	addi	s0,sp,32
  push_off();
    80000f4c:	00005097          	auipc	ra,0x5
    80000f50:	360080e7          	jalr	864(ra) # 800062ac <push_off>
    80000f54:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f56:	2781                	sext.w	a5,a5
    80000f58:	079e                	slli	a5,a5,0x7
    80000f5a:	00008717          	auipc	a4,0x8
    80000f5e:	0f670713          	addi	a4,a4,246 # 80009050 <pid_lock>
    80000f62:	97ba                	add	a5,a5,a4
    80000f64:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	3e6080e7          	jalr	998(ra) # 8000634c <pop_off>
  return p;
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6105                	addi	sp,sp,32
    80000f78:	8082                	ret

0000000080000f7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f7a:	1141                	addi	sp,sp,-16
    80000f7c:	e406                	sd	ra,8(sp)
    80000f7e:	e022                	sd	s0,0(sp)
    80000f80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	fc0080e7          	jalr	-64(ra) # 80000f42 <myproc>
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	422080e7          	jalr	1058(ra) # 800063ac <release>

  if (first) {
    80000f92:	00008797          	auipc	a5,0x8
    80000f96:	8fe7a783          	lw	a5,-1794(a5) # 80008890 <first.1>
    80000f9a:	eb89                	bnez	a5,80000fac <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f9c:	00001097          	auipc	ra,0x1
    80000fa0:	cce080e7          	jalr	-818(ra) # 80001c6a <usertrapret>
}
    80000fa4:	60a2                	ld	ra,8(sp)
    80000fa6:	6402                	ld	s0,0(sp)
    80000fa8:	0141                	addi	sp,sp,16
    80000faa:	8082                	ret
    first = 0;
    80000fac:	00008797          	auipc	a5,0x8
    80000fb0:	8e07a223          	sw	zero,-1820(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80000fb4:	4505                	li	a0,1
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	afc080e7          	jalr	-1284(ra) # 80002ab2 <fsinit>
    80000fbe:	bff9                	j	80000f9c <forkret+0x22>

0000000080000fc0 <allocpid>:
allocpid() {
    80000fc0:	1101                	addi	sp,sp,-32
    80000fc2:	ec06                	sd	ra,24(sp)
    80000fc4:	e822                	sd	s0,16(sp)
    80000fc6:	e426                	sd	s1,8(sp)
    80000fc8:	e04a                	sd	s2,0(sp)
    80000fca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fcc:	00008917          	auipc	s2,0x8
    80000fd0:	08490913          	addi	s2,s2,132 # 80009050 <pid_lock>
    80000fd4:	854a                	mv	a0,s2
    80000fd6:	00005097          	auipc	ra,0x5
    80000fda:	322080e7          	jalr	802(ra) # 800062f8 <acquire>
  pid = nextpid;
    80000fde:	00008797          	auipc	a5,0x8
    80000fe2:	8b678793          	addi	a5,a5,-1866 # 80008894 <nextpid>
    80000fe6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe8:	0014871b          	addiw	a4,s1,1
    80000fec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fee:	854a                	mv	a0,s2
    80000ff0:	00005097          	auipc	ra,0x5
    80000ff4:	3bc080e7          	jalr	956(ra) # 800063ac <release>
}
    80000ff8:	8526                	mv	a0,s1
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <proc_pagetable>:
{
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	e04a                	sd	s2,0(sp)
    80001010:	1000                	addi	s0,sp,32
    80001012:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	7b8080e7          	jalr	1976(ra) # 800007cc <uvmcreate>
    8000101c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000101e:	cd39                	beqz	a0,8000107c <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001020:	4729                	li	a4,10
    80001022:	00006697          	auipc	a3,0x6
    80001026:	fde68693          	addi	a3,a3,-34 # 80007000 <_trampoline>
    8000102a:	6605                	lui	a2,0x1
    8000102c:	040005b7          	lui	a1,0x4000
    80001030:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001032:	05b2                	slli	a1,a1,0xc
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	50e080e7          	jalr	1294(ra) # 80000542 <mappages>
    8000103c:	04054763          	bltz	a0,8000108a <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001040:	4719                	li	a4,6
    80001042:	05893683          	ld	a3,88(s2)
    80001046:	6605                	lui	a2,0x1
    80001048:	020005b7          	lui	a1,0x2000
    8000104c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000104e:	05b6                	slli	a1,a1,0xd
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	4f0080e7          	jalr	1264(ra) # 80000542 <mappages>
    8000105a:	04054063          	bltz	a0,8000109a <proc_pagetable+0x94>
   if (mappages(pagetable, USYSCALL, PGSIZE,
    8000105e:	4749                	li	a4,18
    80001060:	16893683          	ld	a3,360(s2)
    80001064:	6605                	lui	a2,0x1
    80001066:	040005b7          	lui	a1,0x4000
    8000106a:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000106c:	05b2                	slli	a1,a1,0xc
    8000106e:	8526                	mv	a0,s1
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	4d2080e7          	jalr	1234(ra) # 80000542 <mappages>
    80001078:	04054463          	bltz	a0,800010c0 <proc_pagetable+0xba>
}
    8000107c:	8526                	mv	a0,s1
    8000107e:	60e2                	ld	ra,24(sp)
    80001080:	6442                	ld	s0,16(sp)
    80001082:	64a2                	ld	s1,8(sp)
    80001084:	6902                	ld	s2,0(sp)
    80001086:	6105                	addi	sp,sp,32
    80001088:	8082                	ret
    uvmfree(pagetable, 0);
    8000108a:	4581                	li	a1,0
    8000108c:	8526                	mv	a0,s1
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	93c080e7          	jalr	-1732(ra) # 800009ca <uvmfree>
    return 0;
    80001096:	4481                	li	s1,0
    80001098:	b7d5                	j	8000107c <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109a:	4681                	li	a3,0
    8000109c:	4605                	li	a2,1
    8000109e:	040005b7          	lui	a1,0x4000
    800010a2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010a4:	05b2                	slli	a1,a1,0xc
    800010a6:	8526                	mv	a0,s1
    800010a8:	fffff097          	auipc	ra,0xfffff
    800010ac:	660080e7          	jalr	1632(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010b0:	4581                	li	a1,0
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	916080e7          	jalr	-1770(ra) # 800009ca <uvmfree>
    return 0;
    800010bc:	4481                	li	s1,0
    800010be:	bf7d                	j	8000107c <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010c0:	4681                	li	a3,0
    800010c2:	4605                	li	a2,1
    800010c4:	020005b7          	lui	a1,0x2000
    800010c8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010ca:	05b6                	slli	a1,a1,0xd
    800010cc:	8526                	mv	a0,s1
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	63a080e7          	jalr	1594(ra) # 80000708 <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d6:	4681                	li	a3,0
    800010d8:	4605                	li	a2,1
    800010da:	040005b7          	lui	a1,0x4000
    800010de:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010e0:	05b2                	slli	a1,a1,0xc
    800010e2:	8526                	mv	a0,s1
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	624080e7          	jalr	1572(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ec:	4581                	li	a1,0
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	8da080e7          	jalr	-1830(ra) # 800009ca <uvmfree>
    return 0;
    800010f8:	4481                	li	s1,0
    800010fa:	b749                	j	8000107c <proc_pagetable+0x76>

00000000800010fc <proc_freepagetable>:
{
    800010fc:	7179                	addi	sp,sp,-48
    800010fe:	f406                	sd	ra,40(sp)
    80001100:	f022                	sd	s0,32(sp)
    80001102:	ec26                	sd	s1,24(sp)
    80001104:	e84a                	sd	s2,16(sp)
    80001106:	e44e                	sd	s3,8(sp)
    80001108:	1800                	addi	s0,sp,48
    8000110a:	84aa                	mv	s1,a0
    8000110c:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000110e:	4681                	li	a3,0
    80001110:	4605                	li	a2,1
    80001112:	04000937          	lui	s2,0x4000
    80001116:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000111a:	05b2                	slli	a1,a1,0xc
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	5ec080e7          	jalr	1516(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001124:	4681                	li	a3,0
    80001126:	4605                	li	a2,1
    80001128:	020005b7          	lui	a1,0x2000
    8000112c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000112e:	05b6                	slli	a1,a1,0xd
    80001130:	8526                	mv	a0,s1
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	5d6080e7          	jalr	1494(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, USYSCALL,1,0);
    8000113a:	4681                	li	a3,0
    8000113c:	4605                	li	a2,1
    8000113e:	1975                	addi	s2,s2,-3
    80001140:	00c91593          	slli	a1,s2,0xc
    80001144:	8526                	mv	a0,s1
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	5c2080e7          	jalr	1474(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    8000114e:	85ce                	mv	a1,s3
    80001150:	8526                	mv	a0,s1
    80001152:	00000097          	auipc	ra,0x0
    80001156:	878080e7          	jalr	-1928(ra) # 800009ca <uvmfree>
}
    8000115a:	70a2                	ld	ra,40(sp)
    8000115c:	7402                	ld	s0,32(sp)
    8000115e:	64e2                	ld	s1,24(sp)
    80001160:	6942                	ld	s2,16(sp)
    80001162:	69a2                	ld	s3,8(sp)
    80001164:	6145                	addi	sp,sp,48
    80001166:	8082                	ret

0000000080001168 <freeproc>:
{
    80001168:	1101                	addi	sp,sp,-32
    8000116a:	ec06                	sd	ra,24(sp)
    8000116c:	e822                	sd	s0,16(sp)
    8000116e:	e426                	sd	s1,8(sp)
    80001170:	1000                	addi	s0,sp,32
    80001172:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001174:	6d28                	ld	a0,88(a0)
    80001176:	c509                	beqz	a0,80001180 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	ea4080e7          	jalr	-348(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001180:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    80001184:	1684b503          	ld	a0,360(s1)
    80001188:	c509                	beqz	a0,80001192 <freeproc+0x2a>
   kfree((void*)p->usyscall);
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	e92080e7          	jalr	-366(ra) # 8000001c <kfree>
  p->usyscall=0;
    80001192:	1604b423          	sd	zero,360(s1)
  if(p->pagetable)
    80001196:	68a8                	ld	a0,80(s1)
    80001198:	c511                	beqz	a0,800011a4 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    8000119a:	64ac                	ld	a1,72(s1)
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	f60080e7          	jalr	-160(ra) # 800010fc <proc_freepagetable>
  p->pagetable = 0;
    800011a4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011a8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011ac:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011b0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011b4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011b8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011bc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011c0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011c4:	0004ac23          	sw	zero,24(s1)
}
    800011c8:	60e2                	ld	ra,24(sp)
    800011ca:	6442                	ld	s0,16(sp)
    800011cc:	64a2                	ld	s1,8(sp)
    800011ce:	6105                	addi	sp,sp,32
    800011d0:	8082                	ret

00000000800011d2 <allocproc>:
{
    800011d2:	1101                	addi	sp,sp,-32
    800011d4:	ec06                	sd	ra,24(sp)
    800011d6:	e822                	sd	s0,16(sp)
    800011d8:	e426                	sd	s1,8(sp)
    800011da:	e04a                	sd	s2,0(sp)
    800011dc:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	00008497          	auipc	s1,0x8
    800011e2:	2a248493          	addi	s1,s1,674 # 80009480 <proc>
    800011e6:	0000e917          	auipc	s2,0xe
    800011ea:	e9a90913          	addi	s2,s2,-358 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011ee:	8526                	mv	a0,s1
    800011f0:	00005097          	auipc	ra,0x5
    800011f4:	108080e7          	jalr	264(ra) # 800062f8 <acquire>
    if(p->state == UNUSED) {
    800011f8:	4c9c                	lw	a5,24(s1)
    800011fa:	cf81                	beqz	a5,80001212 <allocproc+0x40>
      release(&p->lock);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00005097          	auipc	ra,0x5
    80001202:	1ae080e7          	jalr	430(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001206:	17048493          	addi	s1,s1,368
    8000120a:	ff2492e3          	bne	s1,s2,800011ee <allocproc+0x1c>
  return 0;
    8000120e:	4481                	li	s1,0
    80001210:	a0bd                	j	8000127e <allocproc+0xac>
  p->pid = allocpid();
    80001212:	00000097          	auipc	ra,0x0
    80001216:	dae080e7          	jalr	-594(ra) # 80000fc0 <allocpid>
    8000121a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000121c:	4785                	li	a5,1
    8000121e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	efa080e7          	jalr	-262(ra) # 8000011a <kalloc>
    80001228:	892a                	mv	s2,a0
    8000122a:	eca8                	sd	a0,88(s1)
    8000122c:	c125                	beqz	a0,8000128c <allocproc+0xba>
 if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	eec080e7          	jalr	-276(ra) # 8000011a <kalloc>
    80001236:	892a                	mv	s2,a0
    80001238:	16a4b423          	sd	a0,360(s1)
    8000123c:	c525                	beqz	a0,800012a4 <allocproc+0xd2>
  p->usyscall->pid=p->pid;
    8000123e:	589c                	lw	a5,48(s1)
    80001240:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	dc2080e7          	jalr	-574(ra) # 80001006 <proc_pagetable>
    8000124c:	892a                	mv	s2,a0
    8000124e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001250:	c535                	beqz	a0,800012bc <allocproc+0xea>
  memset(&p->context, 0, sizeof(p->context));
    80001252:	07000613          	li	a2,112
    80001256:	4581                	li	a1,0
    80001258:	06048513          	addi	a0,s1,96
    8000125c:	fffff097          	auipc	ra,0xfffff
    80001260:	f1e080e7          	jalr	-226(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001264:	00000797          	auipc	a5,0x0
    80001268:	d1678793          	addi	a5,a5,-746 # 80000f7a <forkret>
    8000126c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000126e:	60bc                	ld	a5,64(s1)
    80001270:	6705                	lui	a4,0x1
    80001272:	97ba                	add	a5,a5,a4
    80001274:	f4bc                	sd	a5,104(s1)
p->usyscall->pid=p->pid;
    80001276:	1684b783          	ld	a5,360(s1)
    8000127a:	5898                	lw	a4,48(s1)
    8000127c:	c398                	sw	a4,0(a5)
}
    8000127e:	8526                	mv	a0,s1
    80001280:	60e2                	ld	ra,24(sp)
    80001282:	6442                	ld	s0,16(sp)
    80001284:	64a2                	ld	s1,8(sp)
    80001286:	6902                	ld	s2,0(sp)
    80001288:	6105                	addi	sp,sp,32
    8000128a:	8082                	ret
    freeproc(p);
    8000128c:	8526                	mv	a0,s1
    8000128e:	00000097          	auipc	ra,0x0
    80001292:	eda080e7          	jalr	-294(ra) # 80001168 <freeproc>
    release(&p->lock);
    80001296:	8526                	mv	a0,s1
    80001298:	00005097          	auipc	ra,0x5
    8000129c:	114080e7          	jalr	276(ra) # 800063ac <release>
    return 0;
    800012a0:	84ca                	mv	s1,s2
    800012a2:	bff1                	j	8000127e <allocproc+0xac>
    freeproc(p);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	ec2080e7          	jalr	-318(ra) # 80001168 <freeproc>
    release(&p->lock);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	0fc080e7          	jalr	252(ra) # 800063ac <release>
    return 0;
    800012b8:	84ca                	mv	s1,s2
    800012ba:	b7d1                	j	8000127e <allocproc+0xac>
    freeproc(p);
    800012bc:	8526                	mv	a0,s1
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	eaa080e7          	jalr	-342(ra) # 80001168 <freeproc>
    release(&p->lock);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00005097          	auipc	ra,0x5
    800012cc:	0e4080e7          	jalr	228(ra) # 800063ac <release>
    return 0;
    800012d0:	84ca                	mv	s1,s2
    800012d2:	b775                	j	8000127e <allocproc+0xac>

00000000800012d4 <userinit>:
{
    800012d4:	1101                	addi	sp,sp,-32
    800012d6:	ec06                	sd	ra,24(sp)
    800012d8:	e822                	sd	s0,16(sp)
    800012da:	e426                	sd	s1,8(sp)
    800012dc:	1000                	addi	s0,sp,32
  p = allocproc();
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	ef4080e7          	jalr	-268(ra) # 800011d2 <allocproc>
    800012e6:	84aa                	mv	s1,a0
  initproc = p;
    800012e8:	00008797          	auipc	a5,0x8
    800012ec:	d2a7b423          	sd	a0,-728(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012f0:	03400613          	li	a2,52
    800012f4:	00007597          	auipc	a1,0x7
    800012f8:	5ac58593          	addi	a1,a1,1452 # 800088a0 <initcode>
    800012fc:	6928                	ld	a0,80(a0)
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	4fc080e7          	jalr	1276(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    80001306:	6785                	lui	a5,0x1
    80001308:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000130a:	6cb8                	ld	a4,88(s1)
    8000130c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001310:	6cb8                	ld	a4,88(s1)
    80001312:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001314:	4641                	li	a2,16
    80001316:	00007597          	auipc	a1,0x7
    8000131a:	ea258593          	addi	a1,a1,-350 # 800081b8 <etext+0x1b8>
    8000131e:	15848513          	addi	a0,s1,344
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	fa2080e7          	jalr	-94(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000132a:	00007517          	auipc	a0,0x7
    8000132e:	e9e50513          	addi	a0,a0,-354 # 800081c8 <etext+0x1c8>
    80001332:	00002097          	auipc	ra,0x2
    80001336:	1b6080e7          	jalr	438(ra) # 800034e8 <namei>
    8000133a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000133e:	478d                	li	a5,3
    80001340:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	068080e7          	jalr	104(ra) # 800063ac <release>
}
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <growproc>:
{
    80001356:	1101                	addi	sp,sp,-32
    80001358:	ec06                	sd	ra,24(sp)
    8000135a:	e822                	sd	s0,16(sp)
    8000135c:	e426                	sd	s1,8(sp)
    8000135e:	e04a                	sd	s2,0(sp)
    80001360:	1000                	addi	s0,sp,32
    80001362:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001364:	00000097          	auipc	ra,0x0
    80001368:	bde080e7          	jalr	-1058(ra) # 80000f42 <myproc>
    8000136c:	892a                	mv	s2,a0
  sz = p->sz;
    8000136e:	652c                	ld	a1,72(a0)
    80001370:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001374:	00904f63          	bgtz	s1,80001392 <growproc+0x3c>
  } else if(n < 0){
    80001378:	0204cd63          	bltz	s1,800013b2 <growproc+0x5c>
  p->sz = sz;
    8000137c:	1782                	slli	a5,a5,0x20
    8000137e:	9381                	srli	a5,a5,0x20
    80001380:	04f93423          	sd	a5,72(s2)
  return 0;
    80001384:	4501                	li	a0,0
}
    80001386:	60e2                	ld	ra,24(sp)
    80001388:	6442                	ld	s0,16(sp)
    8000138a:	64a2                	ld	s1,8(sp)
    8000138c:	6902                	ld	s2,0(sp)
    8000138e:	6105                	addi	sp,sp,32
    80001390:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001392:	00f4863b          	addw	a2,s1,a5
    80001396:	1602                	slli	a2,a2,0x20
    80001398:	9201                	srli	a2,a2,0x20
    8000139a:	1582                	slli	a1,a1,0x20
    8000139c:	9181                	srli	a1,a1,0x20
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	514080e7          	jalr	1300(ra) # 800008b4 <uvmalloc>
    800013a8:	0005079b          	sext.w	a5,a0
    800013ac:	fbe1                	bnez	a5,8000137c <growproc+0x26>
      return -1;
    800013ae:	557d                	li	a0,-1
    800013b0:	bfd9                	j	80001386 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013b2:	00f4863b          	addw	a2,s1,a5
    800013b6:	1602                	slli	a2,a2,0x20
    800013b8:	9201                	srli	a2,a2,0x20
    800013ba:	1582                	slli	a1,a1,0x20
    800013bc:	9181                	srli	a1,a1,0x20
    800013be:	6928                	ld	a0,80(a0)
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	4ac080e7          	jalr	1196(ra) # 8000086c <uvmdealloc>
    800013c8:	0005079b          	sext.w	a5,a0
    800013cc:	bf45                	j	8000137c <growproc+0x26>

00000000800013ce <fork>:
{
    800013ce:	7139                	addi	sp,sp,-64
    800013d0:	fc06                	sd	ra,56(sp)
    800013d2:	f822                	sd	s0,48(sp)
    800013d4:	f426                	sd	s1,40(sp)
    800013d6:	f04a                	sd	s2,32(sp)
    800013d8:	ec4e                	sd	s3,24(sp)
    800013da:	e852                	sd	s4,16(sp)
    800013dc:	e456                	sd	s5,8(sp)
    800013de:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	b62080e7          	jalr	-1182(ra) # 80000f42 <myproc>
    800013e8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	de8080e7          	jalr	-536(ra) # 800011d2 <allocproc>
    800013f2:	10050c63          	beqz	a0,8000150a <fork+0x13c>
    800013f6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013f8:	048ab603          	ld	a2,72(s5)
    800013fc:	692c                	ld	a1,80(a0)
    800013fe:	050ab503          	ld	a0,80(s5)
    80001402:	fffff097          	auipc	ra,0xfffff
    80001406:	602080e7          	jalr	1538(ra) # 80000a04 <uvmcopy>
    8000140a:	04054863          	bltz	a0,8000145a <fork+0x8c>
  np->sz = p->sz;
    8000140e:	048ab783          	ld	a5,72(s5)
    80001412:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001416:	058ab683          	ld	a3,88(s5)
    8000141a:	87b6                	mv	a5,a3
    8000141c:	058a3703          	ld	a4,88(s4)
    80001420:	12068693          	addi	a3,a3,288
    80001424:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001428:	6788                	ld	a0,8(a5)
    8000142a:	6b8c                	ld	a1,16(a5)
    8000142c:	6f90                	ld	a2,24(a5)
    8000142e:	01073023          	sd	a6,0(a4)
    80001432:	e708                	sd	a0,8(a4)
    80001434:	eb0c                	sd	a1,16(a4)
    80001436:	ef10                	sd	a2,24(a4)
    80001438:	02078793          	addi	a5,a5,32
    8000143c:	02070713          	addi	a4,a4,32
    80001440:	fed792e3          	bne	a5,a3,80001424 <fork+0x56>
  np->trapframe->a0 = 0;
    80001444:	058a3783          	ld	a5,88(s4)
    80001448:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000144c:	0d0a8493          	addi	s1,s5,208
    80001450:	0d0a0913          	addi	s2,s4,208
    80001454:	150a8993          	addi	s3,s5,336
    80001458:	a00d                	j	8000147a <fork+0xac>
    freeproc(np);
    8000145a:	8552                	mv	a0,s4
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	d0c080e7          	jalr	-756(ra) # 80001168 <freeproc>
    release(&np->lock);
    80001464:	8552                	mv	a0,s4
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	f46080e7          	jalr	-186(ra) # 800063ac <release>
    return -1;
    8000146e:	597d                	li	s2,-1
    80001470:	a059                	j	800014f6 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001472:	04a1                	addi	s1,s1,8
    80001474:	0921                	addi	s2,s2,8
    80001476:	01348b63          	beq	s1,s3,8000148c <fork+0xbe>
    if(p->ofile[i])
    8000147a:	6088                	ld	a0,0(s1)
    8000147c:	d97d                	beqz	a0,80001472 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000147e:	00002097          	auipc	ra,0x2
    80001482:	700080e7          	jalr	1792(ra) # 80003b7e <filedup>
    80001486:	00a93023          	sd	a0,0(s2)
    8000148a:	b7e5                	j	80001472 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000148c:	150ab503          	ld	a0,336(s5)
    80001490:	00002097          	auipc	ra,0x2
    80001494:	85e080e7          	jalr	-1954(ra) # 80002cee <idup>
    80001498:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000149c:	4641                	li	a2,16
    8000149e:	158a8593          	addi	a1,s5,344
    800014a2:	158a0513          	addi	a0,s4,344
    800014a6:	fffff097          	auipc	ra,0xfffff
    800014aa:	e1e080e7          	jalr	-482(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800014ae:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014b2:	8552                	mv	a0,s4
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	ef8080e7          	jalr	-264(ra) # 800063ac <release>
  acquire(&wait_lock);
    800014bc:	00008497          	auipc	s1,0x8
    800014c0:	bac48493          	addi	s1,s1,-1108 # 80009068 <wait_lock>
    800014c4:	8526                	mv	a0,s1
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	e32080e7          	jalr	-462(ra) # 800062f8 <acquire>
  np->parent = p;
    800014ce:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014d2:	8526                	mv	a0,s1
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	ed8080e7          	jalr	-296(ra) # 800063ac <release>
  acquire(&np->lock);
    800014dc:	8552                	mv	a0,s4
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	e1a080e7          	jalr	-486(ra) # 800062f8 <acquire>
  np->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014ec:	8552                	mv	a0,s4
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	ebe080e7          	jalr	-322(ra) # 800063ac <release>
}
    800014f6:	854a                	mv	a0,s2
    800014f8:	70e2                	ld	ra,56(sp)
    800014fa:	7442                	ld	s0,48(sp)
    800014fc:	74a2                	ld	s1,40(sp)
    800014fe:	7902                	ld	s2,32(sp)
    80001500:	69e2                	ld	s3,24(sp)
    80001502:	6a42                	ld	s4,16(sp)
    80001504:	6aa2                	ld	s5,8(sp)
    80001506:	6121                	addi	sp,sp,64
    80001508:	8082                	ret
    return -1;
    8000150a:	597d                	li	s2,-1
    8000150c:	b7ed                	j	800014f6 <fork+0x128>

000000008000150e <scheduler>:
{
    8000150e:	7139                	addi	sp,sp,-64
    80001510:	fc06                	sd	ra,56(sp)
    80001512:	f822                	sd	s0,48(sp)
    80001514:	f426                	sd	s1,40(sp)
    80001516:	f04a                	sd	s2,32(sp)
    80001518:	ec4e                	sd	s3,24(sp)
    8000151a:	e852                	sd	s4,16(sp)
    8000151c:	e456                	sd	s5,8(sp)
    8000151e:	e05a                	sd	s6,0(sp)
    80001520:	0080                	addi	s0,sp,64
    80001522:	8792                	mv	a5,tp
  int id = r_tp();
    80001524:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001526:	00779a93          	slli	s5,a5,0x7
    8000152a:	00008717          	auipc	a4,0x8
    8000152e:	b2670713          	addi	a4,a4,-1242 # 80009050 <pid_lock>
    80001532:	9756                	add	a4,a4,s5
    80001534:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001538:	00008717          	auipc	a4,0x8
    8000153c:	b5070713          	addi	a4,a4,-1200 # 80009088 <cpus+0x8>
    80001540:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001542:	498d                	li	s3,3
        p->state = RUNNING;
    80001544:	4b11                	li	s6,4
        c->proc = p;
    80001546:	079e                	slli	a5,a5,0x7
    80001548:	00008a17          	auipc	s4,0x8
    8000154c:	b08a0a13          	addi	s4,s4,-1272 # 80009050 <pid_lock>
    80001550:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001552:	0000e917          	auipc	s2,0xe
    80001556:	b2e90913          	addi	s2,s2,-1234 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000155a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000155e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001562:	10079073          	csrw	sstatus,a5
    80001566:	00008497          	auipc	s1,0x8
    8000156a:	f1a48493          	addi	s1,s1,-230 # 80009480 <proc>
    8000156e:	a811                	j	80001582 <scheduler+0x74>
      release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	e3a080e7          	jalr	-454(ra) # 800063ac <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000157a:	17048493          	addi	s1,s1,368
    8000157e:	fd248ee3          	beq	s1,s2,8000155a <scheduler+0x4c>
      acquire(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	d74080e7          	jalr	-652(ra) # 800062f8 <acquire>
      if(p->state == RUNNABLE) {
    8000158c:	4c9c                	lw	a5,24(s1)
    8000158e:	ff3791e3          	bne	a5,s3,80001570 <scheduler+0x62>
        p->state = RUNNING;
    80001592:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001596:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000159a:	06048593          	addi	a1,s1,96
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	620080e7          	jalr	1568(ra) # 80001bc0 <swtch>
        c->proc = 0;
    800015a8:	020a3823          	sd	zero,48(s4)
    800015ac:	b7d1                	j	80001570 <scheduler+0x62>

00000000800015ae <sched>:
{
    800015ae:	7179                	addi	sp,sp,-48
    800015b0:	f406                	sd	ra,40(sp)
    800015b2:	f022                	sd	s0,32(sp)
    800015b4:	ec26                	sd	s1,24(sp)
    800015b6:	e84a                	sd	s2,16(sp)
    800015b8:	e44e                	sd	s3,8(sp)
    800015ba:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	986080e7          	jalr	-1658(ra) # 80000f42 <myproc>
    800015c4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	cb8080e7          	jalr	-840(ra) # 8000627e <holding>
    800015ce:	c93d                	beqz	a0,80001644 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015d2:	2781                	sext.w	a5,a5
    800015d4:	079e                	slli	a5,a5,0x7
    800015d6:	00008717          	auipc	a4,0x8
    800015da:	a7a70713          	addi	a4,a4,-1414 # 80009050 <pid_lock>
    800015de:	97ba                	add	a5,a5,a4
    800015e0:	0a87a703          	lw	a4,168(a5)
    800015e4:	4785                	li	a5,1
    800015e6:	06f71763          	bne	a4,a5,80001654 <sched+0xa6>
  if(p->state == RUNNING)
    800015ea:	4c98                	lw	a4,24(s1)
    800015ec:	4791                	li	a5,4
    800015ee:	06f70b63          	beq	a4,a5,80001664 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015f2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015f6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015f8:	efb5                	bnez	a5,80001674 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015fa:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015fc:	00008917          	auipc	s2,0x8
    80001600:	a5490913          	addi	s2,s2,-1452 # 80009050 <pid_lock>
    80001604:	2781                	sext.w	a5,a5
    80001606:	079e                	slli	a5,a5,0x7
    80001608:	97ca                	add	a5,a5,s2
    8000160a:	0ac7a983          	lw	s3,172(a5)
    8000160e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001610:	2781                	sext.w	a5,a5
    80001612:	079e                	slli	a5,a5,0x7
    80001614:	00008597          	auipc	a1,0x8
    80001618:	a7458593          	addi	a1,a1,-1420 # 80009088 <cpus+0x8>
    8000161c:	95be                	add	a1,a1,a5
    8000161e:	06048513          	addi	a0,s1,96
    80001622:	00000097          	auipc	ra,0x0
    80001626:	59e080e7          	jalr	1438(ra) # 80001bc0 <swtch>
    8000162a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000162c:	2781                	sext.w	a5,a5
    8000162e:	079e                	slli	a5,a5,0x7
    80001630:	993e                	add	s2,s2,a5
    80001632:	0b392623          	sw	s3,172(s2)
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6145                	addi	sp,sp,48
    80001642:	8082                	ret
    panic("sched p->lock");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b8c50513          	addi	a0,a0,-1140 # 800081d0 <etext+0x1d0>
    8000164c:	00004097          	auipc	ra,0x4
    80001650:	774080e7          	jalr	1908(ra) # 80005dc0 <panic>
    panic("sched locks");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	b8c50513          	addi	a0,a0,-1140 # 800081e0 <etext+0x1e0>
    8000165c:	00004097          	auipc	ra,0x4
    80001660:	764080e7          	jalr	1892(ra) # 80005dc0 <panic>
    panic("sched running");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b8c50513          	addi	a0,a0,-1140 # 800081f0 <etext+0x1f0>
    8000166c:	00004097          	auipc	ra,0x4
    80001670:	754080e7          	jalr	1876(ra) # 80005dc0 <panic>
    panic("sched interruptible");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b8c50513          	addi	a0,a0,-1140 # 80008200 <etext+0x200>
    8000167c:	00004097          	auipc	ra,0x4
    80001680:	744080e7          	jalr	1860(ra) # 80005dc0 <panic>

0000000080001684 <yield>:
{
    80001684:	1101                	addi	sp,sp,-32
    80001686:	ec06                	sd	ra,24(sp)
    80001688:	e822                	sd	s0,16(sp)
    8000168a:	e426                	sd	s1,8(sp)
    8000168c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	8b4080e7          	jalr	-1868(ra) # 80000f42 <myproc>
    80001696:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	c60080e7          	jalr	-928(ra) # 800062f8 <acquire>
  p->state = RUNNABLE;
    800016a0:	478d                	li	a5,3
    800016a2:	cc9c                	sw	a5,24(s1)
  sched();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	f0a080e7          	jalr	-246(ra) # 800015ae <sched>
  release(&p->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	cfe080e7          	jalr	-770(ra) # 800063ac <release>
}
    800016b6:	60e2                	ld	ra,24(sp)
    800016b8:	6442                	ld	s0,16(sp)
    800016ba:	64a2                	ld	s1,8(sp)
    800016bc:	6105                	addi	sp,sp,32
    800016be:	8082                	ret

00000000800016c0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016c0:	7179                	addi	sp,sp,-48
    800016c2:	f406                	sd	ra,40(sp)
    800016c4:	f022                	sd	s0,32(sp)
    800016c6:	ec26                	sd	s1,24(sp)
    800016c8:	e84a                	sd	s2,16(sp)
    800016ca:	e44e                	sd	s3,8(sp)
    800016cc:	1800                	addi	s0,sp,48
    800016ce:	89aa                	mv	s3,a0
    800016d0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	870080e7          	jalr	-1936(ra) # 80000f42 <myproc>
    800016da:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	c1c080e7          	jalr	-996(ra) # 800062f8 <acquire>
  release(lk);
    800016e4:	854a                	mv	a0,s2
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	cc6080e7          	jalr	-826(ra) # 800063ac <release>

  // Go to sleep.
  p->chan = chan;
    800016ee:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016f2:	4789                	li	a5,2
    800016f4:	cc9c                	sw	a5,24(s1)

  sched();
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	eb8080e7          	jalr	-328(ra) # 800015ae <sched>

  // Tidy up.
  p->chan = 0;
    800016fe:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	ca8080e7          	jalr	-856(ra) # 800063ac <release>
  acquire(lk);
    8000170c:	854a                	mv	a0,s2
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	bea080e7          	jalr	-1046(ra) # 800062f8 <acquire>
}
    80001716:	70a2                	ld	ra,40(sp)
    80001718:	7402                	ld	s0,32(sp)
    8000171a:	64e2                	ld	s1,24(sp)
    8000171c:	6942                	ld	s2,16(sp)
    8000171e:	69a2                	ld	s3,8(sp)
    80001720:	6145                	addi	sp,sp,48
    80001722:	8082                	ret

0000000080001724 <wait>:
{
    80001724:	715d                	addi	sp,sp,-80
    80001726:	e486                	sd	ra,72(sp)
    80001728:	e0a2                	sd	s0,64(sp)
    8000172a:	fc26                	sd	s1,56(sp)
    8000172c:	f84a                	sd	s2,48(sp)
    8000172e:	f44e                	sd	s3,40(sp)
    80001730:	f052                	sd	s4,32(sp)
    80001732:	ec56                	sd	s5,24(sp)
    80001734:	e85a                	sd	s6,16(sp)
    80001736:	e45e                	sd	s7,8(sp)
    80001738:	e062                	sd	s8,0(sp)
    8000173a:	0880                	addi	s0,sp,80
    8000173c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	804080e7          	jalr	-2044(ra) # 80000f42 <myproc>
    80001746:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001748:	00008517          	auipc	a0,0x8
    8000174c:	92050513          	addi	a0,a0,-1760 # 80009068 <wait_lock>
    80001750:	00005097          	auipc	ra,0x5
    80001754:	ba8080e7          	jalr	-1112(ra) # 800062f8 <acquire>
    havekids = 0;
    80001758:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000175a:	4a15                	li	s4,5
        havekids = 1;
    8000175c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000175e:	0000e997          	auipc	s3,0xe
    80001762:	92298993          	addi	s3,s3,-1758 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001766:	00008c17          	auipc	s8,0x8
    8000176a:	902c0c13          	addi	s8,s8,-1790 # 80009068 <wait_lock>
    havekids = 0;
    8000176e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001770:	00008497          	auipc	s1,0x8
    80001774:	d1048493          	addi	s1,s1,-752 # 80009480 <proc>
    80001778:	a0bd                	j	800017e6 <wait+0xc2>
          pid = np->pid;
    8000177a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000177e:	000b0e63          	beqz	s6,8000179a <wait+0x76>
    80001782:	4691                	li	a3,4
    80001784:	02c48613          	addi	a2,s1,44
    80001788:	85da                	mv	a1,s6
    8000178a:	05093503          	ld	a0,80(s2)
    8000178e:	fffff097          	auipc	ra,0xfffff
    80001792:	37a080e7          	jalr	890(ra) # 80000b08 <copyout>
    80001796:	02054563          	bltz	a0,800017c0 <wait+0x9c>
          freeproc(np);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	9cc080e7          	jalr	-1588(ra) # 80001168 <freeproc>
          release(&np->lock);
    800017a4:	8526                	mv	a0,s1
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	c06080e7          	jalr	-1018(ra) # 800063ac <release>
          release(&wait_lock);
    800017ae:	00008517          	auipc	a0,0x8
    800017b2:	8ba50513          	addi	a0,a0,-1862 # 80009068 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	bf6080e7          	jalr	-1034(ra) # 800063ac <release>
          return pid;
    800017be:	a09d                	j	80001824 <wait+0x100>
            release(&np->lock);
    800017c0:	8526                	mv	a0,s1
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	bea080e7          	jalr	-1046(ra) # 800063ac <release>
            release(&wait_lock);
    800017ca:	00008517          	auipc	a0,0x8
    800017ce:	89e50513          	addi	a0,a0,-1890 # 80009068 <wait_lock>
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	bda080e7          	jalr	-1062(ra) # 800063ac <release>
            return -1;
    800017da:	59fd                	li	s3,-1
    800017dc:	a0a1                	j	80001824 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017de:	17048493          	addi	s1,s1,368
    800017e2:	03348463          	beq	s1,s3,8000180a <wait+0xe6>
      if(np->parent == p){
    800017e6:	7c9c                	ld	a5,56(s1)
    800017e8:	ff279be3          	bne	a5,s2,800017de <wait+0xba>
        acquire(&np->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	b0a080e7          	jalr	-1270(ra) # 800062f8 <acquire>
        if(np->state == ZOMBIE){
    800017f6:	4c9c                	lw	a5,24(s1)
    800017f8:	f94781e3          	beq	a5,s4,8000177a <wait+0x56>
        release(&np->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	bae080e7          	jalr	-1106(ra) # 800063ac <release>
        havekids = 1;
    80001806:	8756                	mv	a4,s5
    80001808:	bfd9                	j	800017de <wait+0xba>
    if(!havekids || p->killed){
    8000180a:	c701                	beqz	a4,80001812 <wait+0xee>
    8000180c:	02892783          	lw	a5,40(s2)
    80001810:	c79d                	beqz	a5,8000183e <wait+0x11a>
      release(&wait_lock);
    80001812:	00008517          	auipc	a0,0x8
    80001816:	85650513          	addi	a0,a0,-1962 # 80009068 <wait_lock>
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	b92080e7          	jalr	-1134(ra) # 800063ac <release>
      return -1;
    80001822:	59fd                	li	s3,-1
}
    80001824:	854e                	mv	a0,s3
    80001826:	60a6                	ld	ra,72(sp)
    80001828:	6406                	ld	s0,64(sp)
    8000182a:	74e2                	ld	s1,56(sp)
    8000182c:	7942                	ld	s2,48(sp)
    8000182e:	79a2                	ld	s3,40(sp)
    80001830:	7a02                	ld	s4,32(sp)
    80001832:	6ae2                	ld	s5,24(sp)
    80001834:	6b42                	ld	s6,16(sp)
    80001836:	6ba2                	ld	s7,8(sp)
    80001838:	6c02                	ld	s8,0(sp)
    8000183a:	6161                	addi	sp,sp,80
    8000183c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000183e:	85e2                	mv	a1,s8
    80001840:	854a                	mv	a0,s2
    80001842:	00000097          	auipc	ra,0x0
    80001846:	e7e080e7          	jalr	-386(ra) # 800016c0 <sleep>
    havekids = 0;
    8000184a:	b715                	j	8000176e <wait+0x4a>

000000008000184c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000184c:	7139                	addi	sp,sp,-64
    8000184e:	fc06                	sd	ra,56(sp)
    80001850:	f822                	sd	s0,48(sp)
    80001852:	f426                	sd	s1,40(sp)
    80001854:	f04a                	sd	s2,32(sp)
    80001856:	ec4e                	sd	s3,24(sp)
    80001858:	e852                	sd	s4,16(sp)
    8000185a:	e456                	sd	s5,8(sp)
    8000185c:	0080                	addi	s0,sp,64
    8000185e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001860:	00008497          	auipc	s1,0x8
    80001864:	c2048493          	addi	s1,s1,-992 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001868:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000186a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	0000e917          	auipc	s2,0xe
    80001870:	81490913          	addi	s2,s2,-2028 # 8000f080 <tickslock>
    80001874:	a811                	j	80001888 <wakeup+0x3c>
      }
      release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	b34080e7          	jalr	-1228(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	17048493          	addi	s1,s1,368
    80001884:	03248663          	beq	s1,s2,800018b0 <wakeup+0x64>
    if(p != myproc()){
    80001888:	fffff097          	auipc	ra,0xfffff
    8000188c:	6ba080e7          	jalr	1722(ra) # 80000f42 <myproc>
    80001890:	fea488e3          	beq	s1,a0,80001880 <wakeup+0x34>
      acquire(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a62080e7          	jalr	-1438(ra) # 800062f8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000189e:	4c9c                	lw	a5,24(s1)
    800018a0:	fd379be3          	bne	a5,s3,80001876 <wakeup+0x2a>
    800018a4:	709c                	ld	a5,32(s1)
    800018a6:	fd4798e3          	bne	a5,s4,80001876 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018aa:	0154ac23          	sw	s5,24(s1)
    800018ae:	b7e1                	j	80001876 <wakeup+0x2a>
    }
  }
}
    800018b0:	70e2                	ld	ra,56(sp)
    800018b2:	7442                	ld	s0,48(sp)
    800018b4:	74a2                	ld	s1,40(sp)
    800018b6:	7902                	ld	s2,32(sp)
    800018b8:	69e2                	ld	s3,24(sp)
    800018ba:	6a42                	ld	s4,16(sp)
    800018bc:	6aa2                	ld	s5,8(sp)
    800018be:	6121                	addi	sp,sp,64
    800018c0:	8082                	ret

00000000800018c2 <reparent>:
{
    800018c2:	7179                	addi	sp,sp,-48
    800018c4:	f406                	sd	ra,40(sp)
    800018c6:	f022                	sd	s0,32(sp)
    800018c8:	ec26                	sd	s1,24(sp)
    800018ca:	e84a                	sd	s2,16(sp)
    800018cc:	e44e                	sd	s3,8(sp)
    800018ce:	e052                	sd	s4,0(sp)
    800018d0:	1800                	addi	s0,sp,48
    800018d2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d4:	00008497          	auipc	s1,0x8
    800018d8:	bac48493          	addi	s1,s1,-1108 # 80009480 <proc>
      pp->parent = initproc;
    800018dc:	00007a17          	auipc	s4,0x7
    800018e0:	734a0a13          	addi	s4,s4,1844 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	0000d997          	auipc	s3,0xd
    800018e8:	79c98993          	addi	s3,s3,1948 # 8000f080 <tickslock>
    800018ec:	a029                	j	800018f6 <reparent+0x34>
    800018ee:	17048493          	addi	s1,s1,368
    800018f2:	01348d63          	beq	s1,s3,8000190c <reparent+0x4a>
    if(pp->parent == p){
    800018f6:	7c9c                	ld	a5,56(s1)
    800018f8:	ff279be3          	bne	a5,s2,800018ee <reparent+0x2c>
      pp->parent = initproc;
    800018fc:	000a3503          	ld	a0,0(s4)
    80001900:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001902:	00000097          	auipc	ra,0x0
    80001906:	f4a080e7          	jalr	-182(ra) # 8000184c <wakeup>
    8000190a:	b7d5                	j	800018ee <reparent+0x2c>
}
    8000190c:	70a2                	ld	ra,40(sp)
    8000190e:	7402                	ld	s0,32(sp)
    80001910:	64e2                	ld	s1,24(sp)
    80001912:	6942                	ld	s2,16(sp)
    80001914:	69a2                	ld	s3,8(sp)
    80001916:	6a02                	ld	s4,0(sp)
    80001918:	6145                	addi	sp,sp,48
    8000191a:	8082                	ret

000000008000191c <exit>:
{
    8000191c:	7179                	addi	sp,sp,-48
    8000191e:	f406                	sd	ra,40(sp)
    80001920:	f022                	sd	s0,32(sp)
    80001922:	ec26                	sd	s1,24(sp)
    80001924:	e84a                	sd	s2,16(sp)
    80001926:	e44e                	sd	s3,8(sp)
    80001928:	e052                	sd	s4,0(sp)
    8000192a:	1800                	addi	s0,sp,48
    8000192c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	614080e7          	jalr	1556(ra) # 80000f42 <myproc>
    80001936:	89aa                	mv	s3,a0
  if(p == initproc)
    80001938:	00007797          	auipc	a5,0x7
    8000193c:	6d87b783          	ld	a5,1752(a5) # 80009010 <initproc>
    80001940:	0d050493          	addi	s1,a0,208
    80001944:	15050913          	addi	s2,a0,336
    80001948:	02a79363          	bne	a5,a0,8000196e <exit+0x52>
    panic("init exiting");
    8000194c:	00007517          	auipc	a0,0x7
    80001950:	8cc50513          	addi	a0,a0,-1844 # 80008218 <etext+0x218>
    80001954:	00004097          	auipc	ra,0x4
    80001958:	46c080e7          	jalr	1132(ra) # 80005dc0 <panic>
      fileclose(f);
    8000195c:	00002097          	auipc	ra,0x2
    80001960:	274080e7          	jalr	628(ra) # 80003bd0 <fileclose>
      p->ofile[fd] = 0;
    80001964:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001968:	04a1                	addi	s1,s1,8
    8000196a:	01248563          	beq	s1,s2,80001974 <exit+0x58>
    if(p->ofile[fd]){
    8000196e:	6088                	ld	a0,0(s1)
    80001970:	f575                	bnez	a0,8000195c <exit+0x40>
    80001972:	bfdd                	j	80001968 <exit+0x4c>
  begin_op();
    80001974:	00002097          	auipc	ra,0x2
    80001978:	d94080e7          	jalr	-620(ra) # 80003708 <begin_op>
  iput(p->cwd);
    8000197c:	1509b503          	ld	a0,336(s3)
    80001980:	00001097          	auipc	ra,0x1
    80001984:	566080e7          	jalr	1382(ra) # 80002ee6 <iput>
  end_op();
    80001988:	00002097          	auipc	ra,0x2
    8000198c:	dfe080e7          	jalr	-514(ra) # 80003786 <end_op>
  p->cwd = 0;
    80001990:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001994:	00007497          	auipc	s1,0x7
    80001998:	6d448493          	addi	s1,s1,1748 # 80009068 <wait_lock>
    8000199c:	8526                	mv	a0,s1
    8000199e:	00005097          	auipc	ra,0x5
    800019a2:	95a080e7          	jalr	-1702(ra) # 800062f8 <acquire>
  reparent(p);
    800019a6:	854e                	mv	a0,s3
    800019a8:	00000097          	auipc	ra,0x0
    800019ac:	f1a080e7          	jalr	-230(ra) # 800018c2 <reparent>
  wakeup(p->parent);
    800019b0:	0389b503          	ld	a0,56(s3)
    800019b4:	00000097          	auipc	ra,0x0
    800019b8:	e98080e7          	jalr	-360(ra) # 8000184c <wakeup>
  acquire(&p->lock);
    800019bc:	854e                	mv	a0,s3
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	93a080e7          	jalr	-1734(ra) # 800062f8 <acquire>
  p->xstate = status;
    800019c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019ca:	4795                	li	a5,5
    800019cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019d0:	8526                	mv	a0,s1
    800019d2:	00005097          	auipc	ra,0x5
    800019d6:	9da080e7          	jalr	-1574(ra) # 800063ac <release>
  sched();
    800019da:	00000097          	auipc	ra,0x0
    800019de:	bd4080e7          	jalr	-1068(ra) # 800015ae <sched>
  panic("zombie exit");
    800019e2:	00007517          	auipc	a0,0x7
    800019e6:	84650513          	addi	a0,a0,-1978 # 80008228 <etext+0x228>
    800019ea:	00004097          	auipc	ra,0x4
    800019ee:	3d6080e7          	jalr	982(ra) # 80005dc0 <panic>

00000000800019f2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019f2:	7179                	addi	sp,sp,-48
    800019f4:	f406                	sd	ra,40(sp)
    800019f6:	f022                	sd	s0,32(sp)
    800019f8:	ec26                	sd	s1,24(sp)
    800019fa:	e84a                	sd	s2,16(sp)
    800019fc:	e44e                	sd	s3,8(sp)
    800019fe:	1800                	addi	s0,sp,48
    80001a00:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a02:	00008497          	auipc	s1,0x8
    80001a06:	a7e48493          	addi	s1,s1,-1410 # 80009480 <proc>
    80001a0a:	0000d997          	auipc	s3,0xd
    80001a0e:	67698993          	addi	s3,s3,1654 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	8e4080e7          	jalr	-1820(ra) # 800062f8 <acquire>
    if(p->pid == pid){
    80001a1c:	589c                	lw	a5,48(s1)
    80001a1e:	01278d63          	beq	a5,s2,80001a38 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	988080e7          	jalr	-1656(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2c:	17048493          	addi	s1,s1,368
    80001a30:	ff3491e3          	bne	s1,s3,80001a12 <kill+0x20>
  }
  return -1;
    80001a34:	557d                	li	a0,-1
    80001a36:	a829                	j	80001a50 <kill+0x5e>
      p->killed = 1;
    80001a38:	4785                	li	a5,1
    80001a3a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a3c:	4c98                	lw	a4,24(s1)
    80001a3e:	4789                	li	a5,2
    80001a40:	00f70f63          	beq	a4,a5,80001a5e <kill+0x6c>
      release(&p->lock);
    80001a44:	8526                	mv	a0,s1
    80001a46:	00005097          	auipc	ra,0x5
    80001a4a:	966080e7          	jalr	-1690(ra) # 800063ac <release>
      return 0;
    80001a4e:	4501                	li	a0,0
}
    80001a50:	70a2                	ld	ra,40(sp)
    80001a52:	7402                	ld	s0,32(sp)
    80001a54:	64e2                	ld	s1,24(sp)
    80001a56:	6942                	ld	s2,16(sp)
    80001a58:	69a2                	ld	s3,8(sp)
    80001a5a:	6145                	addi	sp,sp,48
    80001a5c:	8082                	ret
        p->state = RUNNABLE;
    80001a5e:	478d                	li	a5,3
    80001a60:	cc9c                	sw	a5,24(s1)
    80001a62:	b7cd                	j	80001a44 <kill+0x52>

0000000080001a64 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a64:	7179                	addi	sp,sp,-48
    80001a66:	f406                	sd	ra,40(sp)
    80001a68:	f022                	sd	s0,32(sp)
    80001a6a:	ec26                	sd	s1,24(sp)
    80001a6c:	e84a                	sd	s2,16(sp)
    80001a6e:	e44e                	sd	s3,8(sp)
    80001a70:	e052                	sd	s4,0(sp)
    80001a72:	1800                	addi	s0,sp,48
    80001a74:	84aa                	mv	s1,a0
    80001a76:	892e                	mv	s2,a1
    80001a78:	89b2                	mv	s3,a2
    80001a7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	4c6080e7          	jalr	1222(ra) # 80000f42 <myproc>
  if(user_dst){
    80001a84:	c08d                	beqz	s1,80001aa6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a86:	86d2                	mv	a3,s4
    80001a88:	864e                	mv	a2,s3
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	6928                	ld	a0,80(a0)
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	07a080e7          	jalr	122(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret
    memmove((char *)dst, src, len);
    80001aa6:	000a061b          	sext.w	a2,s4
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	854a                	mv	a0,s2
    80001aae:	ffffe097          	auipc	ra,0xffffe
    80001ab2:	728080e7          	jalr	1832(ra) # 800001d6 <memmove>
    return 0;
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	bff9                	j	80001a96 <either_copyout+0x32>

0000000080001aba <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	e052                	sd	s4,0(sp)
    80001ac8:	1800                	addi	s0,sp,48
    80001aca:	892a                	mv	s2,a0
    80001acc:	84ae                	mv	s1,a1
    80001ace:	89b2                	mv	s3,a2
    80001ad0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	470080e7          	jalr	1136(ra) # 80000f42 <myproc>
  if(user_src){
    80001ada:	c08d                	beqz	s1,80001afc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001adc:	86d2                	mv	a3,s4
    80001ade:	864e                	mv	a2,s3
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	6928                	ld	a0,80(a0)
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	0b0080e7          	jalr	176(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aec:	70a2                	ld	ra,40(sp)
    80001aee:	7402                	ld	s0,32(sp)
    80001af0:	64e2                	ld	s1,24(sp)
    80001af2:	6942                	ld	s2,16(sp)
    80001af4:	69a2                	ld	s3,8(sp)
    80001af6:	6a02                	ld	s4,0(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
    memmove(dst, (char*)src, len);
    80001afc:	000a061b          	sext.w	a2,s4
    80001b00:	85ce                	mv	a1,s3
    80001b02:	854a                	mv	a0,s2
    80001b04:	ffffe097          	auipc	ra,0xffffe
    80001b08:	6d2080e7          	jalr	1746(ra) # 800001d6 <memmove>
    return 0;
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	bff9                	j	80001aec <either_copyin+0x32>

0000000080001b10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b10:	715d                	addi	sp,sp,-80
    80001b12:	e486                	sd	ra,72(sp)
    80001b14:	e0a2                	sd	s0,64(sp)
    80001b16:	fc26                	sd	s1,56(sp)
    80001b18:	f84a                	sd	s2,48(sp)
    80001b1a:	f44e                	sd	s3,40(sp)
    80001b1c:	f052                	sd	s4,32(sp)
    80001b1e:	ec56                	sd	s5,24(sp)
    80001b20:	e85a                	sd	s6,16(sp)
    80001b22:	e45e                	sd	s7,8(sp)
    80001b24:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	52250513          	addi	a0,a0,1314 # 80008048 <etext+0x48>
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	2dc080e7          	jalr	732(ra) # 80005e0a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b36:	00008497          	auipc	s1,0x8
    80001b3a:	aa248493          	addi	s1,s1,-1374 # 800095d8 <proc+0x158>
    80001b3e:	0000d917          	auipc	s2,0xd
    80001b42:	69a90913          	addi	s2,s2,1690 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b46:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b48:	00006997          	auipc	s3,0x6
    80001b4c:	6f098993          	addi	s3,s3,1776 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001b50:	00006a97          	auipc	s5,0x6
    80001b54:	6f0a8a93          	addi	s5,s5,1776 # 80008240 <etext+0x240>
    printf("\n");
    80001b58:	00006a17          	auipc	s4,0x6
    80001b5c:	4f0a0a13          	addi	s4,s4,1264 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b60:	00006b97          	auipc	s7,0x6
    80001b64:	718b8b93          	addi	s7,s7,1816 # 80008278 <states.0>
    80001b68:	a00d                	j	80001b8a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6a:	ed86a583          	lw	a1,-296(a3)
    80001b6e:	8556                	mv	a0,s5
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	29a080e7          	jalr	666(ra) # 80005e0a <printf>
    printf("\n");
    80001b78:	8552                	mv	a0,s4
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	290080e7          	jalr	656(ra) # 80005e0a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b82:	17048493          	addi	s1,s1,368
    80001b86:	03248263          	beq	s1,s2,80001baa <procdump+0x9a>
    if(p->state == UNUSED)
    80001b8a:	86a6                	mv	a3,s1
    80001b8c:	ec04a783          	lw	a5,-320(s1)
    80001b90:	dbed                	beqz	a5,80001b82 <procdump+0x72>
      state = "???";
    80001b92:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b94:	fcfb6be3          	bltu	s6,a5,80001b6a <procdump+0x5a>
    80001b98:	02079713          	slli	a4,a5,0x20
    80001b9c:	01d75793          	srli	a5,a4,0x1d
    80001ba0:	97de                	add	a5,a5,s7
    80001ba2:	6390                	ld	a2,0(a5)
    80001ba4:	f279                	bnez	a2,80001b6a <procdump+0x5a>
      state = "???";
    80001ba6:	864e                	mv	a2,s3
    80001ba8:	b7c9                	j	80001b6a <procdump+0x5a>
  }
}
    80001baa:	60a6                	ld	ra,72(sp)
    80001bac:	6406                	ld	s0,64(sp)
    80001bae:	74e2                	ld	s1,56(sp)
    80001bb0:	7942                	ld	s2,48(sp)
    80001bb2:	79a2                	ld	s3,40(sp)
    80001bb4:	7a02                	ld	s4,32(sp)
    80001bb6:	6ae2                	ld	s5,24(sp)
    80001bb8:	6b42                	ld	s6,16(sp)
    80001bba:	6ba2                	ld	s7,8(sp)
    80001bbc:	6161                	addi	sp,sp,80
    80001bbe:	8082                	ret

0000000080001bc0 <swtch>:
    80001bc0:	00153023          	sd	ra,0(a0)
    80001bc4:	00253423          	sd	sp,8(a0)
    80001bc8:	e900                	sd	s0,16(a0)
    80001bca:	ed04                	sd	s1,24(a0)
    80001bcc:	03253023          	sd	s2,32(a0)
    80001bd0:	03353423          	sd	s3,40(a0)
    80001bd4:	03453823          	sd	s4,48(a0)
    80001bd8:	03553c23          	sd	s5,56(a0)
    80001bdc:	05653023          	sd	s6,64(a0)
    80001be0:	05753423          	sd	s7,72(a0)
    80001be4:	05853823          	sd	s8,80(a0)
    80001be8:	05953c23          	sd	s9,88(a0)
    80001bec:	07a53023          	sd	s10,96(a0)
    80001bf0:	07b53423          	sd	s11,104(a0)
    80001bf4:	0005b083          	ld	ra,0(a1)
    80001bf8:	0085b103          	ld	sp,8(a1)
    80001bfc:	6980                	ld	s0,16(a1)
    80001bfe:	6d84                	ld	s1,24(a1)
    80001c00:	0205b903          	ld	s2,32(a1)
    80001c04:	0285b983          	ld	s3,40(a1)
    80001c08:	0305ba03          	ld	s4,48(a1)
    80001c0c:	0385ba83          	ld	s5,56(a1)
    80001c10:	0405bb03          	ld	s6,64(a1)
    80001c14:	0485bb83          	ld	s7,72(a1)
    80001c18:	0505bc03          	ld	s8,80(a1)
    80001c1c:	0585bc83          	ld	s9,88(a1)
    80001c20:	0605bd03          	ld	s10,96(a1)
    80001c24:	0685bd83          	ld	s11,104(a1)
    80001c28:	8082                	ret

0000000080001c2a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c2a:	1141                	addi	sp,sp,-16
    80001c2c:	e406                	sd	ra,8(sp)
    80001c2e:	e022                	sd	s0,0(sp)
    80001c30:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c32:	00006597          	auipc	a1,0x6
    80001c36:	67658593          	addi	a1,a1,1654 # 800082a8 <states.0+0x30>
    80001c3a:	0000d517          	auipc	a0,0xd
    80001c3e:	44650513          	addi	a0,a0,1094 # 8000f080 <tickslock>
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	626080e7          	jalr	1574(ra) # 80006268 <initlock>
}
    80001c4a:	60a2                	ld	ra,8(sp)
    80001c4c:	6402                	ld	s0,0(sp)
    80001c4e:	0141                	addi	sp,sp,16
    80001c50:	8082                	ret

0000000080001c52 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c52:	1141                	addi	sp,sp,-16
    80001c54:	e422                	sd	s0,8(sp)
    80001c56:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c58:	00003797          	auipc	a5,0x3
    80001c5c:	5c878793          	addi	a5,a5,1480 # 80005220 <kernelvec>
    80001c60:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c64:	6422                	ld	s0,8(sp)
    80001c66:	0141                	addi	sp,sp,16
    80001c68:	8082                	ret

0000000080001c6a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c6a:	1141                	addi	sp,sp,-16
    80001c6c:	e406                	sd	ra,8(sp)
    80001c6e:	e022                	sd	s0,0(sp)
    80001c70:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	2d0080e7          	jalr	720(ra) # 80000f42 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c80:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c84:	00005697          	auipc	a3,0x5
    80001c88:	37c68693          	addi	a3,a3,892 # 80007000 <_trampoline>
    80001c8c:	00005717          	auipc	a4,0x5
    80001c90:	37470713          	addi	a4,a4,884 # 80007000 <_trampoline>
    80001c94:	8f15                	sub	a4,a4,a3
    80001c96:	040007b7          	lui	a5,0x4000
    80001c9a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c9c:	07b2                	slli	a5,a5,0xc
    80001c9e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ca4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ca6:	18002673          	csrr	a2,satp
    80001caa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cac:	6d30                	ld	a2,88(a0)
    80001cae:	6138                	ld	a4,64(a0)
    80001cb0:	6585                	lui	a1,0x1
    80001cb2:	972e                	add	a4,a4,a1
    80001cb4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cb6:	6d38                	ld	a4,88(a0)
    80001cb8:	00000617          	auipc	a2,0x0
    80001cbc:	13860613          	addi	a2,a2,312 # 80001df0 <usertrap>
    80001cc0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cc2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cc4:	8612                	mv	a2,tp
    80001cc6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ccc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cd0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cd8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cda:	6f18                	ld	a4,24(a4)
    80001cdc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ce0:	692c                	ld	a1,80(a0)
    80001ce2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001ce4:	00005717          	auipc	a4,0x5
    80001ce8:	3ac70713          	addi	a4,a4,940 # 80007090 <userret>
    80001cec:	8f15                	sub	a4,a4,a3
    80001cee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cf0:	577d                	li	a4,-1
    80001cf2:	177e                	slli	a4,a4,0x3f
    80001cf4:	8dd9                	or	a1,a1,a4
    80001cf6:	02000537          	lui	a0,0x2000
    80001cfa:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001cfc:	0536                	slli	a0,a0,0xd
    80001cfe:	9782                	jalr	a5
}
    80001d00:	60a2                	ld	ra,8(sp)
    80001d02:	6402                	ld	s0,0(sp)
    80001d04:	0141                	addi	sp,sp,16
    80001d06:	8082                	ret

0000000080001d08 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d12:	0000d497          	auipc	s1,0xd
    80001d16:	36e48493          	addi	s1,s1,878 # 8000f080 <tickslock>
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	5dc080e7          	jalr	1500(ra) # 800062f8 <acquire>
  ticks++;
    80001d24:	00007517          	auipc	a0,0x7
    80001d28:	2f450513          	addi	a0,a0,756 # 80009018 <ticks>
    80001d2c:	411c                	lw	a5,0(a0)
    80001d2e:	2785                	addiw	a5,a5,1
    80001d30:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	b1a080e7          	jalr	-1254(ra) # 8000184c <wakeup>
  release(&tickslock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	670080e7          	jalr	1648(ra) # 800063ac <release>
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret

0000000080001d4e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d58:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d5c:	00074d63          	bltz	a4,80001d76 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d60:	57fd                	li	a5,-1
    80001d62:	17fe                	slli	a5,a5,0x3f
    80001d64:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d66:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d68:	06f70363          	beq	a4,a5,80001dce <devintr+0x80>
  }
}
    80001d6c:	60e2                	ld	ra,24(sp)
    80001d6e:	6442                	ld	s0,16(sp)
    80001d70:	64a2                	ld	s1,8(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret
     (scause & 0xff) == 9){
    80001d76:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d7a:	46a5                	li	a3,9
    80001d7c:	fed792e3          	bne	a5,a3,80001d60 <devintr+0x12>
    int irq = plic_claim();
    80001d80:	00003097          	auipc	ra,0x3
    80001d84:	5a8080e7          	jalr	1448(ra) # 80005328 <plic_claim>
    80001d88:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d8a:	47a9                	li	a5,10
    80001d8c:	02f50763          	beq	a0,a5,80001dba <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d90:	4785                	li	a5,1
    80001d92:	02f50963          	beq	a0,a5,80001dc4 <devintr+0x76>
    return 1;
    80001d96:	4505                	li	a0,1
    } else if(irq){
    80001d98:	d8f1                	beqz	s1,80001d6c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d9a:	85a6                	mv	a1,s1
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	51450513          	addi	a0,a0,1300 # 800082b0 <states.0+0x38>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	066080e7          	jalr	102(ra) # 80005e0a <printf>
      plic_complete(irq);
    80001dac:	8526                	mv	a0,s1
    80001dae:	00003097          	auipc	ra,0x3
    80001db2:	59e080e7          	jalr	1438(ra) # 8000534c <plic_complete>
    return 1;
    80001db6:	4505                	li	a0,1
    80001db8:	bf55                	j	80001d6c <devintr+0x1e>
      uartintr();
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	45e080e7          	jalr	1118(ra) # 80006218 <uartintr>
    80001dc2:	b7ed                	j	80001dac <devintr+0x5e>
      virtio_disk_intr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	a14080e7          	jalr	-1516(ra) # 800057d8 <virtio_disk_intr>
    80001dcc:	b7c5                	j	80001dac <devintr+0x5e>
    if(cpuid() == 0){
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	148080e7          	jalr	328(ra) # 80000f16 <cpuid>
    80001dd6:	c901                	beqz	a0,80001de6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dd8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ddc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dde:	14479073          	csrw	sip,a5
    return 2;
    80001de2:	4509                	li	a0,2
    80001de4:	b761                	j	80001d6c <devintr+0x1e>
      clockintr();
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	f22080e7          	jalr	-222(ra) # 80001d08 <clockintr>
    80001dee:	b7ed                	j	80001dd8 <devintr+0x8a>

0000000080001df0 <usertrap>:
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	e04a                	sd	s2,0(sp)
    80001dfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e00:	1007f793          	andi	a5,a5,256
    80001e04:	e3ad                	bnez	a5,80001e66 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e06:	00003797          	auipc	a5,0x3
    80001e0a:	41a78793          	addi	a5,a5,1050 # 80005220 <kernelvec>
    80001e0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e12:	fffff097          	auipc	ra,0xfffff
    80001e16:	130080e7          	jalr	304(ra) # 80000f42 <myproc>
    80001e1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e1c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1e:	14102773          	csrr	a4,sepc
    80001e22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e28:	47a1                	li	a5,8
    80001e2a:	04f71c63          	bne	a4,a5,80001e82 <usertrap+0x92>
    if(p->killed)
    80001e2e:	551c                	lw	a5,40(a0)
    80001e30:	e3b9                	bnez	a5,80001e76 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e32:	6cb8                	ld	a4,88(s1)
    80001e34:	6f1c                	ld	a5,24(a4)
    80001e36:	0791                	addi	a5,a5,4
    80001e38:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e42:	10079073          	csrw	sstatus,a5
    syscall();
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	2e0080e7          	jalr	736(ra) # 80002126 <syscall>
  if(p->killed)
    80001e4e:	549c                	lw	a5,40(s1)
    80001e50:	ebc1                	bnez	a5,80001ee0 <usertrap+0xf0>
  usertrapret();
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	e18080e7          	jalr	-488(ra) # 80001c6a <usertrapret>
}
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6902                	ld	s2,0(sp)
    80001e62:	6105                	addi	sp,sp,32
    80001e64:	8082                	ret
    panic("usertrap: not from user mode");
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	46a50513          	addi	a0,a0,1130 # 800082d0 <states.0+0x58>
    80001e6e:	00004097          	auipc	ra,0x4
    80001e72:	f52080e7          	jalr	-174(ra) # 80005dc0 <panic>
      exit(-1);
    80001e76:	557d                	li	a0,-1
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	aa4080e7          	jalr	-1372(ra) # 8000191c <exit>
    80001e80:	bf4d                	j	80001e32 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	ecc080e7          	jalr	-308(ra) # 80001d4e <devintr>
    80001e8a:	892a                	mv	s2,a0
    80001e8c:	c501                	beqz	a0,80001e94 <usertrap+0xa4>
  if(p->killed)
    80001e8e:	549c                	lw	a5,40(s1)
    80001e90:	c3a1                	beqz	a5,80001ed0 <usertrap+0xe0>
    80001e92:	a815                	j	80001ec6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e94:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e98:	5890                	lw	a2,48(s1)
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	45650513          	addi	a0,a0,1110 # 800082f0 <states.0+0x78>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	f68080e7          	jalr	-152(ra) # 80005e0a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eaa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eae:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	46e50513          	addi	a0,a0,1134 # 80008320 <states.0+0xa8>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	f50080e7          	jalr	-176(ra) # 80005e0a <printf>
    p->killed = 1;
    80001ec2:	4785                	li	a5,1
    80001ec4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ec6:	557d                	li	a0,-1
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	a54080e7          	jalr	-1452(ra) # 8000191c <exit>
  if(which_dev == 2)
    80001ed0:	4789                	li	a5,2
    80001ed2:	f8f910e3          	bne	s2,a5,80001e52 <usertrap+0x62>
    yield();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	7ae080e7          	jalr	1966(ra) # 80001684 <yield>
    80001ede:	bf95                	j	80001e52 <usertrap+0x62>
  int which_dev = 0;
    80001ee0:	4901                	li	s2,0
    80001ee2:	b7d5                	j	80001ec6 <usertrap+0xd6>

0000000080001ee4 <kerneltrap>:
{
    80001ee4:	7179                	addi	sp,sp,-48
    80001ee6:	f406                	sd	ra,40(sp)
    80001ee8:	f022                	sd	s0,32(sp)
    80001eea:	ec26                	sd	s1,24(sp)
    80001eec:	e84a                	sd	s2,16(sp)
    80001eee:	e44e                	sd	s3,8(sp)
    80001ef0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001efe:	1004f793          	andi	a5,s1,256
    80001f02:	cb85                	beqz	a5,80001f32 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f04:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f08:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f0a:	ef85                	bnez	a5,80001f42 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	e42080e7          	jalr	-446(ra) # 80001d4e <devintr>
    80001f14:	cd1d                	beqz	a0,80001f52 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f16:	4789                	li	a5,2
    80001f18:	06f50a63          	beq	a0,a5,80001f8c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f1c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f20:	10049073          	csrw	sstatus,s1
}
    80001f24:	70a2                	ld	ra,40(sp)
    80001f26:	7402                	ld	s0,32(sp)
    80001f28:	64e2                	ld	s1,24(sp)
    80001f2a:	6942                	ld	s2,16(sp)
    80001f2c:	69a2                	ld	s3,8(sp)
    80001f2e:	6145                	addi	sp,sp,48
    80001f30:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	40e50513          	addi	a0,a0,1038 # 80008340 <states.0+0xc8>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	e86080e7          	jalr	-378(ra) # 80005dc0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	42650513          	addi	a0,a0,1062 # 80008368 <states.0+0xf0>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	e76080e7          	jalr	-394(ra) # 80005dc0 <panic>
    printf("scause %p\n", scause);
    80001f52:	85ce                	mv	a1,s3
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	43450513          	addi	a0,a0,1076 # 80008388 <states.0+0x110>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	eae080e7          	jalr	-338(ra) # 80005e0a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f68:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	42c50513          	addi	a0,a0,1068 # 80008398 <states.0+0x120>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	e96080e7          	jalr	-362(ra) # 80005e0a <printf>
    panic("kerneltrap");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	43450513          	addi	a0,a0,1076 # 800083b0 <states.0+0x138>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	e3c080e7          	jalr	-452(ra) # 80005dc0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	fb6080e7          	jalr	-74(ra) # 80000f42 <myproc>
    80001f94:	d541                	beqz	a0,80001f1c <kerneltrap+0x38>
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	fac080e7          	jalr	-84(ra) # 80000f42 <myproc>
    80001f9e:	4d18                	lw	a4,24(a0)
    80001fa0:	4791                	li	a5,4
    80001fa2:	f6f71de3          	bne	a4,a5,80001f1c <kerneltrap+0x38>
    yield();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	6de080e7          	jalr	1758(ra) # 80001684 <yield>
    80001fae:	b7bd                	j	80001f1c <kerneltrap+0x38>

0000000080001fb0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	1000                	addi	s0,sp,32
    80001fba:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	f86080e7          	jalr	-122(ra) # 80000f42 <myproc>
  switch (n) {
    80001fc4:	4795                	li	a5,5
    80001fc6:	0497e163          	bltu	a5,s1,80002008 <argraw+0x58>
    80001fca:	048a                	slli	s1,s1,0x2
    80001fcc:	00006717          	auipc	a4,0x6
    80001fd0:	41c70713          	addi	a4,a4,1052 # 800083e8 <states.0+0x170>
    80001fd4:	94ba                	add	s1,s1,a4
    80001fd6:	409c                	lw	a5,0(s1)
    80001fd8:	97ba                	add	a5,a5,a4
    80001fda:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret
    return p->trapframe->a1;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	7fa8                	ld	a0,120(a5)
    80001fee:	bfcd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a2;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	63c8                	ld	a0,128(a5)
    80001ff4:	b7f5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a3;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	67c8                	ld	a0,136(a5)
    80001ffa:	b7dd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a4;
    80001ffc:	6d3c                	ld	a5,88(a0)
    80001ffe:	6bc8                	ld	a0,144(a5)
    80002000:	b7c5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a5;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	6fc8                	ld	a0,152(a5)
    80002006:	bfe9                	j	80001fe0 <argraw+0x30>
  panic("argraw");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	3b850513          	addi	a0,a0,952 # 800083c0 <states.0+0x148>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	db0080e7          	jalr	-592(ra) # 80005dc0 <panic>

0000000080002018 <fetchaddr>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
    80002024:	84aa                	mv	s1,a0
    80002026:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	f1a080e7          	jalr	-230(ra) # 80000f42 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002030:	653c                	ld	a5,72(a0)
    80002032:	02f4f863          	bgeu	s1,a5,80002062 <fetchaddr+0x4a>
    80002036:	00848713          	addi	a4,s1,8
    8000203a:	02e7e663          	bltu	a5,a4,80002066 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000203e:	46a1                	li	a3,8
    80002040:	8626                	mv	a2,s1
    80002042:	85ca                	mv	a1,s2
    80002044:	6928                	ld	a0,80(a0)
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	b4e080e7          	jalr	-1202(ra) # 80000b94 <copyin>
    8000204e:	00a03533          	snez	a0,a0
    80002052:	40a00533          	neg	a0,a0
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6902                	ld	s2,0(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret
    return -1;
    80002062:	557d                	li	a0,-1
    80002064:	bfcd                	j	80002056 <fetchaddr+0x3e>
    80002066:	557d                	li	a0,-1
    80002068:	b7fd                	j	80002056 <fetchaddr+0x3e>

000000008000206a <fetchstr>:
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
    80002078:	892a                	mv	s2,a0
    8000207a:	84ae                	mv	s1,a1
    8000207c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	ec4080e7          	jalr	-316(ra) # 80000f42 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002086:	86ce                	mv	a3,s3
    80002088:	864a                	mv	a2,s2
    8000208a:	85a6                	mv	a1,s1
    8000208c:	6928                	ld	a0,80(a0)
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	b94080e7          	jalr	-1132(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002096:	00054763          	bltz	a0,800020a4 <fetchstr+0x3a>
  return strlen(buf);
    8000209a:	8526                	mv	a0,s1
    8000209c:	ffffe097          	auipc	ra,0xffffe
    800020a0:	25a080e7          	jalr	602(ra) # 800002f6 <strlen>
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret

00000000800020b2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	e426                	sd	s1,8(sp)
    800020ba:	1000                	addi	s0,sp,32
    800020bc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	ef2080e7          	jalr	-270(ra) # 80001fb0 <argraw>
    800020c6:	c088                	sw	a0,0(s1)
  return 0;
}
    800020c8:	4501                	li	a0,0
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	64a2                	ld	s1,8(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	ed0080e7          	jalr	-304(ra) # 80001fb0 <argraw>
    800020e8:	e088                	sd	a0,0(s1)
  return 0;
}
    800020ea:	4501                	li	a0,0
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	e04a                	sd	s2,0(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84ae                	mv	s1,a1
    80002104:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	eaa080e7          	jalr	-342(ra) # 80001fb0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000210e:	864a                	mv	a2,s2
    80002110:	85a6                	mv	a1,s1
    80002112:	00000097          	auipc	ra,0x0
    80002116:	f58080e7          	jalr	-168(ra) # 8000206a <fetchstr>
}
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	64a2                	ld	s1,8(sp)
    80002120:	6902                	ld	s2,0(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <syscall>:



void
syscall(void)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	e426                	sd	s1,8(sp)
    8000212e:	e04a                	sd	s2,0(sp)
    80002130:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	e10080e7          	jalr	-496(ra) # 80000f42 <myproc>
    8000213a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000213c:	05853903          	ld	s2,88(a0)
    80002140:	0a893783          	ld	a5,168(s2)
    80002144:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002148:	37fd                	addiw	a5,a5,-1
    8000214a:	4775                	li	a4,29
    8000214c:	00f76f63          	bltu	a4,a5,8000216a <syscall+0x44>
    80002150:	00369713          	slli	a4,a3,0x3
    80002154:	00006797          	auipc	a5,0x6
    80002158:	2ac78793          	addi	a5,a5,684 # 80008400 <syscalls>
    8000215c:	97ba                	add	a5,a5,a4
    8000215e:	639c                	ld	a5,0(a5)
    80002160:	c789                	beqz	a5,8000216a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002162:	9782                	jalr	a5
    80002164:	06a93823          	sd	a0,112(s2)
    80002168:	a839                	j	80002186 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000216a:	15848613          	addi	a2,s1,344
    8000216e:	588c                	lw	a1,48(s1)
    80002170:	00006517          	auipc	a0,0x6
    80002174:	25850513          	addi	a0,a0,600 # 800083c8 <states.0+0x150>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	c92080e7          	jalr	-878(ra) # 80005e0a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002180:	6cbc                	ld	a5,88(s1)
    80002182:	577d                	li	a4,-1
    80002184:	fbb8                	sd	a4,112(a5)
  }
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6902                	ld	s2,0(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000219a:	fec40593          	addi	a1,s0,-20
    8000219e:	4501                	li	a0,0
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	f12080e7          	jalr	-238(ra) # 800020b2 <argint>
    return -1;
    800021a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021aa:	00054963          	bltz	a0,800021bc <sys_exit+0x2a>
  exit(n);
    800021ae:	fec42503          	lw	a0,-20(s0)
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	76a080e7          	jalr	1898(ra) # 8000191c <exit>
  return 0;  // not reached
    800021ba:	4781                	li	a5,0
}
    800021bc:	853e                	mv	a0,a5
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021c6:	1141                	addi	sp,sp,-16
    800021c8:	e406                	sd	ra,8(sp)
    800021ca:	e022                	sd	s0,0(sp)
    800021cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	d74080e7          	jalr	-652(ra) # 80000f42 <myproc>
}
    800021d6:	5908                	lw	a0,48(a0)
    800021d8:	60a2                	ld	ra,8(sp)
    800021da:	6402                	ld	s0,0(sp)
    800021dc:	0141                	addi	sp,sp,16
    800021de:	8082                	ret

00000000800021e0 <sys_fork>:

uint64
sys_fork(void)
{
    800021e0:	1141                	addi	sp,sp,-16
    800021e2:	e406                	sd	ra,8(sp)
    800021e4:	e022                	sd	s0,0(sp)
    800021e6:	0800                	addi	s0,sp,16
  return fork();
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	1e6080e7          	jalr	486(ra) # 800013ce <fork>
}
    800021f0:	60a2                	ld	ra,8(sp)
    800021f2:	6402                	ld	s0,0(sp)
    800021f4:	0141                	addi	sp,sp,16
    800021f6:	8082                	ret

00000000800021f8 <sys_wait>:

uint64
sys_wait(void)
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002200:	fe840593          	addi	a1,s0,-24
    80002204:	4501                	li	a0,0
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	ece080e7          	jalr	-306(ra) # 800020d4 <argaddr>
    8000220e:	87aa                	mv	a5,a0
    return -1;
    80002210:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002212:	0007c863          	bltz	a5,80002222 <sys_wait+0x2a>
  return wait(p);
    80002216:	fe843503          	ld	a0,-24(s0)
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	50a080e7          	jalr	1290(ra) # 80001724 <wait>
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000222a:	7179                	addi	sp,sp,-48
    8000222c:	f406                	sd	ra,40(sp)
    8000222e:	f022                	sd	s0,32(sp)
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002234:	fdc40593          	addi	a1,s0,-36
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	e78080e7          	jalr	-392(ra) # 800020b2 <argint>
    80002242:	87aa                	mv	a5,a0
    return -1;
    80002244:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002246:	0207c063          	bltz	a5,80002266 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	cf8080e7          	jalr	-776(ra) # 80000f42 <myproc>
    80002252:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002254:	fdc42503          	lw	a0,-36(s0)
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	0fe080e7          	jalr	254(ra) # 80001356 <growproc>
    80002260:	00054863          	bltz	a0,80002270 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002264:	8526                	mv	a0,s1
}
    80002266:	70a2                	ld	ra,40(sp)
    80002268:	7402                	ld	s0,32(sp)
    8000226a:	64e2                	ld	s1,24(sp)
    8000226c:	6145                	addi	sp,sp,48
    8000226e:	8082                	ret
    return -1;
    80002270:	557d                	li	a0,-1
    80002272:	bfd5                	j	80002266 <sys_sbrk+0x3c>

0000000080002274 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002274:	7139                	addi	sp,sp,-64
    80002276:	fc06                	sd	ra,56(sp)
    80002278:	f822                	sd	s0,48(sp)
    8000227a:	f426                	sd	s1,40(sp)
    8000227c:	f04a                	sd	s2,32(sp)
    8000227e:	ec4e                	sd	s3,24(sp)
    80002280:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002282:	fcc40593          	addi	a1,s0,-52
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	e2a080e7          	jalr	-470(ra) # 800020b2 <argint>
    return -1;
    80002290:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002292:	06054563          	bltz	a0,800022fc <sys_sleep+0x88>
  acquire(&tickslock);
    80002296:	0000d517          	auipc	a0,0xd
    8000229a:	dea50513          	addi	a0,a0,-534 # 8000f080 <tickslock>
    8000229e:	00004097          	auipc	ra,0x4
    800022a2:	05a080e7          	jalr	90(ra) # 800062f8 <acquire>
  ticks0 = ticks;
    800022a6:	00007917          	auipc	s2,0x7
    800022aa:	d7292903          	lw	s2,-654(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022ae:	fcc42783          	lw	a5,-52(s0)
    800022b2:	cf85                	beqz	a5,800022ea <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022b4:	0000d997          	auipc	s3,0xd
    800022b8:	dcc98993          	addi	s3,s3,-564 # 8000f080 <tickslock>
    800022bc:	00007497          	auipc	s1,0x7
    800022c0:	d5c48493          	addi	s1,s1,-676 # 80009018 <ticks>
    if(myproc()->killed){
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	c7e080e7          	jalr	-898(ra) # 80000f42 <myproc>
    800022cc:	551c                	lw	a5,40(a0)
    800022ce:	ef9d                	bnez	a5,8000230c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022d0:	85ce                	mv	a1,s3
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	3ec080e7          	jalr	1004(ra) # 800016c0 <sleep>
  while(ticks - ticks0 < n){
    800022dc:	409c                	lw	a5,0(s1)
    800022de:	412787bb          	subw	a5,a5,s2
    800022e2:	fcc42703          	lw	a4,-52(s0)
    800022e6:	fce7efe3          	bltu	a5,a4,800022c4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022ea:	0000d517          	auipc	a0,0xd
    800022ee:	d9650513          	addi	a0,a0,-618 # 8000f080 <tickslock>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	0ba080e7          	jalr	186(ra) # 800063ac <release>
  return 0;
    800022fa:	4781                	li	a5,0
}
    800022fc:	853e                	mv	a0,a5
    800022fe:	70e2                	ld	ra,56(sp)
    80002300:	7442                	ld	s0,48(sp)
    80002302:	74a2                	ld	s1,40(sp)
    80002304:	7902                	ld	s2,32(sp)
    80002306:	69e2                	ld	s3,24(sp)
    80002308:	6121                	addi	sp,sp,64
    8000230a:	8082                	ret
      release(&tickslock);
    8000230c:	0000d517          	auipc	a0,0xd
    80002310:	d7450513          	addi	a0,a0,-652 # 8000f080 <tickslock>
    80002314:	00004097          	auipc	ra,0x4
    80002318:	098080e7          	jalr	152(ra) # 800063ac <release>
      return -1;
    8000231c:	57fd                	li	a5,-1
    8000231e:	bff9                	j	800022fc <sys_sleep+0x88>

0000000080002320 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002320:	711d                	addi	sp,sp,-96
    80002322:	ec86                	sd	ra,88(sp)
    80002324:	e8a2                	sd	s0,80(sp)
    80002326:	e4a6                	sd	s1,72(sp)
    80002328:	e0ca                	sd	s2,64(sp)
    8000232a:	fc4e                	sd	s3,56(sp)
    8000232c:	f852                	sd	s4,48(sp)
    8000232e:	f456                	sd	s5,40(sp)
    80002330:	1080                	addi	s0,sp,96
     uint64 va;
  int len;
  uint64 abits_addr;
  if(argaddr(0, &va) < 0)
    80002332:	fb840593          	addi	a1,s0,-72
    80002336:	4501                	li	a0,0
    80002338:	00000097          	auipc	ra,0x0
    8000233c:	d9c080e7          	jalr	-612(ra) # 800020d4 <argaddr>
    80002340:	0c054863          	bltz	a0,80002410 <sys_pgaccess+0xf0>
    return -1;
  if(argint(1, &len) < 0)
    80002344:	fb440593          	addi	a1,s0,-76
    80002348:	4505                	li	a0,1
    8000234a:	00000097          	auipc	ra,0x0
    8000234e:	d68080e7          	jalr	-664(ra) # 800020b2 <argint>
    80002352:	0c054163          	bltz	a0,80002414 <sys_pgaccess+0xf4>
    return -1;
  if(argaddr(2, &abits_addr) < 0)
    80002356:	fa840593          	addi	a1,s0,-88
    8000235a:	4509                	li	a0,2
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	d78080e7          	jalr	-648(ra) # 800020d4 <argaddr>
    80002364:	0a054a63          	bltz	a0,80002418 <sys_pgaccess+0xf8>
    return -1;
  if(len < 0 || len > 32)
    80002368:	fb442703          	lw	a4,-76(s0)
    8000236c:	02000793          	li	a5,32
    80002370:	0ae7e663          	bltu	a5,a4,8000241c <sys_pgaccess+0xfc>
    return -1;
  
  uint32 ret = 0;
    80002374:	fa042223          	sw	zero,-92(s0)
  pte_t *pte;
  struct proc *p = myproc();
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	bca080e7          	jalr	-1078(ra) # 80000f42 <myproc>
    80002380:	892a                	mv	s2,a0

  for(int i = 0; i < len; i++){
    80002382:	fb442783          	lw	a5,-76(s0)
    80002386:	04f05f63          	blez	a5,800023e4 <sys_pgaccess+0xc4>
    8000238a:	4481                	li	s1,0
    if(va >= MAXVA)
    8000238c:	59fd                	li	s3,-1
    8000238e:	01a9d993          	srli	s3,s3,0x1a
    
    if(pte == 0)
      return -1;
    /* if pte has been accessed add bit of ret and clear*/
    if(*pte & PTE_A){
      ret |= (1 << i);
    80002392:	4a85                	li	s5,1
      *pte &= ~PTE_A;
    }
    /* va of next page */
    va += PGSIZE;    
    80002394:	6a05                	lui	s4,0x1
    80002396:	a819                	j	800023ac <sys_pgaccess+0x8c>
    80002398:	fb843783          	ld	a5,-72(s0)
    8000239c:	97d2                	add	a5,a5,s4
    8000239e:	faf43c23          	sd	a5,-72(s0)
  for(int i = 0; i < len; i++){
    800023a2:	2485                	addiw	s1,s1,1
    800023a4:	fb442783          	lw	a5,-76(s0)
    800023a8:	02f4de63          	bge	s1,a5,800023e4 <sys_pgaccess+0xc4>
    if(va >= MAXVA)
    800023ac:	fb843583          	ld	a1,-72(s0)
    800023b0:	06b9e863          	bltu	s3,a1,80002420 <sys_pgaccess+0x100>
    pte = walk(p->pagetable, va, 0);
    800023b4:	4601                	li	a2,0
    800023b6:	05093503          	ld	a0,80(s2)
    800023ba:	ffffe097          	auipc	ra,0xffffe
    800023be:	0a0080e7          	jalr	160(ra) # 8000045a <walk>
    if(pte == 0)
    800023c2:	c12d                	beqz	a0,80002424 <sys_pgaccess+0x104>
    if(*pte & PTE_A){
    800023c4:	611c                	ld	a5,0(a0)
    800023c6:	0407f793          	andi	a5,a5,64
    800023ca:	d7f9                	beqz	a5,80002398 <sys_pgaccess+0x78>
      ret |= (1 << i);
    800023cc:	009a973b          	sllw	a4,s5,s1
    800023d0:	fa442783          	lw	a5,-92(s0)
    800023d4:	8fd9                	or	a5,a5,a4
    800023d6:	faf42223          	sw	a5,-92(s0)
      *pte &= ~PTE_A;
    800023da:	611c                	ld	a5,0(a0)
    800023dc:	fbf7f793          	andi	a5,a5,-65
    800023e0:	e11c                	sd	a5,0(a0)
    800023e2:	bf5d                	j	80002398 <sys_pgaccess+0x78>
  }

  if(copyout(p->pagetable, abits_addr, (char*)&ret, sizeof(ret)) < 0)
    800023e4:	4691                	li	a3,4
    800023e6:	fa440613          	addi	a2,s0,-92
    800023ea:	fa843583          	ld	a1,-88(s0)
    800023ee:	05093503          	ld	a0,80(s2)
    800023f2:	ffffe097          	auipc	ra,0xffffe
    800023f6:	716080e7          	jalr	1814(ra) # 80000b08 <copyout>
    800023fa:	41f5551b          	sraiw	a0,a0,0x1f
    return -1;
  return 0;
}
    800023fe:	60e6                	ld	ra,88(sp)
    80002400:	6446                	ld	s0,80(sp)
    80002402:	64a6                	ld	s1,72(sp)
    80002404:	6906                	ld	s2,64(sp)
    80002406:	79e2                	ld	s3,56(sp)
    80002408:	7a42                	ld	s4,48(sp)
    8000240a:	7aa2                	ld	s5,40(sp)
    8000240c:	6125                	addi	sp,sp,96
    8000240e:	8082                	ret
    return -1;
    80002410:	557d                	li	a0,-1
    80002412:	b7f5                	j	800023fe <sys_pgaccess+0xde>
    return -1;
    80002414:	557d                	li	a0,-1
    80002416:	b7e5                	j	800023fe <sys_pgaccess+0xde>
    return -1;
    80002418:	557d                	li	a0,-1
    8000241a:	b7d5                	j	800023fe <sys_pgaccess+0xde>
    return -1;
    8000241c:	557d                	li	a0,-1
    8000241e:	b7c5                	j	800023fe <sys_pgaccess+0xde>
      return -1;
    80002420:	557d                	li	a0,-1
    80002422:	bff1                	j	800023fe <sys_pgaccess+0xde>
      return -1;
    80002424:	557d                	li	a0,-1
    80002426:	bfe1                	j	800023fe <sys_pgaccess+0xde>

0000000080002428 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002430:	fec40593          	addi	a1,s0,-20
    80002434:	4501                	li	a0,0
    80002436:	00000097          	auipc	ra,0x0
    8000243a:	c7c080e7          	jalr	-900(ra) # 800020b2 <argint>
    8000243e:	87aa                	mv	a5,a0
    return -1;
    80002440:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002442:	0007c863          	bltz	a5,80002452 <sys_kill+0x2a>
  return kill(pid);
    80002446:	fec42503          	lw	a0,-20(s0)
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	5a8080e7          	jalr	1448(ra) # 800019f2 <kill>
}
    80002452:	60e2                	ld	ra,24(sp)
    80002454:	6442                	ld	s0,16(sp)
    80002456:	6105                	addi	sp,sp,32
    80002458:	8082                	ret

000000008000245a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000245a:	1101                	addi	sp,sp,-32
    8000245c:	ec06                	sd	ra,24(sp)
    8000245e:	e822                	sd	s0,16(sp)
    80002460:	e426                	sd	s1,8(sp)
    80002462:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002464:	0000d517          	auipc	a0,0xd
    80002468:	c1c50513          	addi	a0,a0,-996 # 8000f080 <tickslock>
    8000246c:	00004097          	auipc	ra,0x4
    80002470:	e8c080e7          	jalr	-372(ra) # 800062f8 <acquire>
  xticks = ticks;
    80002474:	00007497          	auipc	s1,0x7
    80002478:	ba44a483          	lw	s1,-1116(s1) # 80009018 <ticks>
  release(&tickslock);
    8000247c:	0000d517          	auipc	a0,0xd
    80002480:	c0450513          	addi	a0,a0,-1020 # 8000f080 <tickslock>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	f28080e7          	jalr	-216(ra) # 800063ac <release>
  return xticks;
}
    8000248c:	02049513          	slli	a0,s1,0x20
    80002490:	9101                	srli	a0,a0,0x20
    80002492:	60e2                	ld	ra,24(sp)
    80002494:	6442                	ld	s0,16(sp)
    80002496:	64a2                	ld	s1,8(sp)
    80002498:	6105                	addi	sp,sp,32
    8000249a:	8082                	ret

000000008000249c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000249c:	7179                	addi	sp,sp,-48
    8000249e:	f406                	sd	ra,40(sp)
    800024a0:	f022                	sd	s0,32(sp)
    800024a2:	ec26                	sd	s1,24(sp)
    800024a4:	e84a                	sd	s2,16(sp)
    800024a6:	e44e                	sd	s3,8(sp)
    800024a8:	e052                	sd	s4,0(sp)
    800024aa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024ac:	00006597          	auipc	a1,0x6
    800024b0:	04c58593          	addi	a1,a1,76 # 800084f8 <syscalls+0xf8>
    800024b4:	0000d517          	auipc	a0,0xd
    800024b8:	be450513          	addi	a0,a0,-1052 # 8000f098 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	dac080e7          	jalr	-596(ra) # 80006268 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024c4:	00015797          	auipc	a5,0x15
    800024c8:	bd478793          	addi	a5,a5,-1068 # 80017098 <bcache+0x8000>
    800024cc:	00015717          	auipc	a4,0x15
    800024d0:	e3470713          	addi	a4,a4,-460 # 80017300 <bcache+0x8268>
    800024d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024dc:	0000d497          	auipc	s1,0xd
    800024e0:	bd448493          	addi	s1,s1,-1068 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024e8:	00006a17          	auipc	s4,0x6
    800024ec:	018a0a13          	addi	s4,s4,24 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    800024f0:	2b893783          	ld	a5,696(s2)
    800024f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024fa:	85d2                	mv	a1,s4
    800024fc:	01048513          	addi	a0,s1,16
    80002500:	00001097          	auipc	ra,0x1
    80002504:	4c2080e7          	jalr	1218(ra) # 800039c2 <initsleeplock>
    bcache.head.next->prev = b;
    80002508:	2b893783          	ld	a5,696(s2)
    8000250c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000250e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002512:	45848493          	addi	s1,s1,1112
    80002516:	fd349de3          	bne	s1,s3,800024f0 <binit+0x54>
  }
}
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret

000000008000252a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000252a:	7179                	addi	sp,sp,-48
    8000252c:	f406                	sd	ra,40(sp)
    8000252e:	f022                	sd	s0,32(sp)
    80002530:	ec26                	sd	s1,24(sp)
    80002532:	e84a                	sd	s2,16(sp)
    80002534:	e44e                	sd	s3,8(sp)
    80002536:	1800                	addi	s0,sp,48
    80002538:	892a                	mv	s2,a0
    8000253a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000253c:	0000d517          	auipc	a0,0xd
    80002540:	b5c50513          	addi	a0,a0,-1188 # 8000f098 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	db4080e7          	jalr	-588(ra) # 800062f8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000254c:	00015497          	auipc	s1,0x15
    80002550:	e044b483          	ld	s1,-508(s1) # 80017350 <bcache+0x82b8>
    80002554:	00015797          	auipc	a5,0x15
    80002558:	dac78793          	addi	a5,a5,-596 # 80017300 <bcache+0x8268>
    8000255c:	02f48f63          	beq	s1,a5,8000259a <bread+0x70>
    80002560:	873e                	mv	a4,a5
    80002562:	a021                	j	8000256a <bread+0x40>
    80002564:	68a4                	ld	s1,80(s1)
    80002566:	02e48a63          	beq	s1,a4,8000259a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000256a:	449c                	lw	a5,8(s1)
    8000256c:	ff279ce3          	bne	a5,s2,80002564 <bread+0x3a>
    80002570:	44dc                	lw	a5,12(s1)
    80002572:	ff3799e3          	bne	a5,s3,80002564 <bread+0x3a>
      b->refcnt++;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	2785                	addiw	a5,a5,1
    8000257a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	b1c50513          	addi	a0,a0,-1252 # 8000f098 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	e28080e7          	jalr	-472(ra) # 800063ac <release>
      acquiresleep(&b->lock);
    8000258c:	01048513          	addi	a0,s1,16
    80002590:	00001097          	auipc	ra,0x1
    80002594:	46c080e7          	jalr	1132(ra) # 800039fc <acquiresleep>
      return b;
    80002598:	a8b9                	j	800025f6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259a:	00015497          	auipc	s1,0x15
    8000259e:	dae4b483          	ld	s1,-594(s1) # 80017348 <bcache+0x82b0>
    800025a2:	00015797          	auipc	a5,0x15
    800025a6:	d5e78793          	addi	a5,a5,-674 # 80017300 <bcache+0x8268>
    800025aa:	00f48863          	beq	s1,a5,800025ba <bread+0x90>
    800025ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025b0:	40bc                	lw	a5,64(s1)
    800025b2:	cf81                	beqz	a5,800025ca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025b4:	64a4                	ld	s1,72(s1)
    800025b6:	fee49de3          	bne	s1,a4,800025b0 <bread+0x86>
  panic("bget: no buffers");
    800025ba:	00006517          	auipc	a0,0x6
    800025be:	f4e50513          	addi	a0,a0,-178 # 80008508 <syscalls+0x108>
    800025c2:	00003097          	auipc	ra,0x3
    800025c6:	7fe080e7          	jalr	2046(ra) # 80005dc0 <panic>
      b->dev = dev;
    800025ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025d6:	4785                	li	a5,1
    800025d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025da:	0000d517          	auipc	a0,0xd
    800025de:	abe50513          	addi	a0,a0,-1346 # 8000f098 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	dca080e7          	jalr	-566(ra) # 800063ac <release>
      acquiresleep(&b->lock);
    800025ea:	01048513          	addi	a0,s1,16
    800025ee:	00001097          	auipc	ra,0x1
    800025f2:	40e080e7          	jalr	1038(ra) # 800039fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025f6:	409c                	lw	a5,0(s1)
    800025f8:	cb89                	beqz	a5,8000260a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025fa:	8526                	mv	a0,s1
    800025fc:	70a2                	ld	ra,40(sp)
    800025fe:	7402                	ld	s0,32(sp)
    80002600:	64e2                	ld	s1,24(sp)
    80002602:	6942                	ld	s2,16(sp)
    80002604:	69a2                	ld	s3,8(sp)
    80002606:	6145                	addi	sp,sp,48
    80002608:	8082                	ret
    virtio_disk_rw(b, 0);
    8000260a:	4581                	li	a1,0
    8000260c:	8526                	mv	a0,s1
    8000260e:	00003097          	auipc	ra,0x3
    80002612:	f44080e7          	jalr	-188(ra) # 80005552 <virtio_disk_rw>
    b->valid = 1;
    80002616:	4785                	li	a5,1
    80002618:	c09c                	sw	a5,0(s1)
  return b;
    8000261a:	b7c5                	j	800025fa <bread+0xd0>

000000008000261c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	addi	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002628:	0541                	addi	a0,a0,16
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	46c080e7          	jalr	1132(ra) # 80003a96 <holdingsleep>
    80002632:	cd01                	beqz	a0,8000264a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002634:	4585                	li	a1,1
    80002636:	8526                	mv	a0,s1
    80002638:	00003097          	auipc	ra,0x3
    8000263c:	f1a080e7          	jalr	-230(ra) # 80005552 <virtio_disk_rw>
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret
    panic("bwrite");
    8000264a:	00006517          	auipc	a0,0x6
    8000264e:	ed650513          	addi	a0,a0,-298 # 80008520 <syscalls+0x120>
    80002652:	00003097          	auipc	ra,0x3
    80002656:	76e080e7          	jalr	1902(ra) # 80005dc0 <panic>

000000008000265a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000265a:	1101                	addi	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	e04a                	sd	s2,0(sp)
    80002664:	1000                	addi	s0,sp,32
    80002666:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002668:	01050913          	addi	s2,a0,16
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	428080e7          	jalr	1064(ra) # 80003a96 <holdingsleep>
    80002676:	c92d                	beqz	a0,800026e8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002678:	854a                	mv	a0,s2
    8000267a:	00001097          	auipc	ra,0x1
    8000267e:	3d8080e7          	jalr	984(ra) # 80003a52 <releasesleep>

  acquire(&bcache.lock);
    80002682:	0000d517          	auipc	a0,0xd
    80002686:	a1650513          	addi	a0,a0,-1514 # 8000f098 <bcache>
    8000268a:	00004097          	auipc	ra,0x4
    8000268e:	c6e080e7          	jalr	-914(ra) # 800062f8 <acquire>
  b->refcnt--;
    80002692:	40bc                	lw	a5,64(s1)
    80002694:	37fd                	addiw	a5,a5,-1
    80002696:	0007871b          	sext.w	a4,a5
    8000269a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000269c:	eb05                	bnez	a4,800026cc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000269e:	68bc                	ld	a5,80(s1)
    800026a0:	64b8                	ld	a4,72(s1)
    800026a2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026a4:	64bc                	ld	a5,72(s1)
    800026a6:	68b8                	ld	a4,80(s1)
    800026a8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026aa:	00015797          	auipc	a5,0x15
    800026ae:	9ee78793          	addi	a5,a5,-1554 # 80017098 <bcache+0x8000>
    800026b2:	2b87b703          	ld	a4,696(a5)
    800026b6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026b8:	00015717          	auipc	a4,0x15
    800026bc:	c4870713          	addi	a4,a4,-952 # 80017300 <bcache+0x8268>
    800026c0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026c2:	2b87b703          	ld	a4,696(a5)
    800026c6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026c8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026cc:	0000d517          	auipc	a0,0xd
    800026d0:	9cc50513          	addi	a0,a0,-1588 # 8000f098 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	cd8080e7          	jalr	-808(ra) # 800063ac <release>
}
    800026dc:	60e2                	ld	ra,24(sp)
    800026de:	6442                	ld	s0,16(sp)
    800026e0:	64a2                	ld	s1,8(sp)
    800026e2:	6902                	ld	s2,0(sp)
    800026e4:	6105                	addi	sp,sp,32
    800026e6:	8082                	ret
    panic("brelse");
    800026e8:	00006517          	auipc	a0,0x6
    800026ec:	e4050513          	addi	a0,a0,-448 # 80008528 <syscalls+0x128>
    800026f0:	00003097          	auipc	ra,0x3
    800026f4:	6d0080e7          	jalr	1744(ra) # 80005dc0 <panic>

00000000800026f8 <bpin>:

void
bpin(struct buf *b) {
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
    80002702:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002704:	0000d517          	auipc	a0,0xd
    80002708:	99450513          	addi	a0,a0,-1644 # 8000f098 <bcache>
    8000270c:	00004097          	auipc	ra,0x4
    80002710:	bec080e7          	jalr	-1044(ra) # 800062f8 <acquire>
  b->refcnt++;
    80002714:	40bc                	lw	a5,64(s1)
    80002716:	2785                	addiw	a5,a5,1
    80002718:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000271a:	0000d517          	auipc	a0,0xd
    8000271e:	97e50513          	addi	a0,a0,-1666 # 8000f098 <bcache>
    80002722:	00004097          	auipc	ra,0x4
    80002726:	c8a080e7          	jalr	-886(ra) # 800063ac <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <bunpin>:

void
bunpin(struct buf *b) {
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002740:	0000d517          	auipc	a0,0xd
    80002744:	95850513          	addi	a0,a0,-1704 # 8000f098 <bcache>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	bb0080e7          	jalr	-1104(ra) # 800062f8 <acquire>
  b->refcnt--;
    80002750:	40bc                	lw	a5,64(s1)
    80002752:	37fd                	addiw	a5,a5,-1
    80002754:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002756:	0000d517          	auipc	a0,0xd
    8000275a:	94250513          	addi	a0,a0,-1726 # 8000f098 <bcache>
    8000275e:	00004097          	auipc	ra,0x4
    80002762:	c4e080e7          	jalr	-946(ra) # 800063ac <release>
}
    80002766:	60e2                	ld	ra,24(sp)
    80002768:	6442                	ld	s0,16(sp)
    8000276a:	64a2                	ld	s1,8(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret

0000000080002770 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    8000277c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000277e:	00d5d59b          	srliw	a1,a1,0xd
    80002782:	00015797          	auipc	a5,0x15
    80002786:	ff27a783          	lw	a5,-14(a5) # 80017774 <sb+0x1c>
    8000278a:	9dbd                	addw	a1,a1,a5
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	d9e080e7          	jalr	-610(ra) # 8000252a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002794:	0074f713          	andi	a4,s1,7
    80002798:	4785                	li	a5,1
    8000279a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000279e:	14ce                	slli	s1,s1,0x33
    800027a0:	90d9                	srli	s1,s1,0x36
    800027a2:	00950733          	add	a4,a0,s1
    800027a6:	05874703          	lbu	a4,88(a4)
    800027aa:	00e7f6b3          	and	a3,a5,a4
    800027ae:	c69d                	beqz	a3,800027dc <bfree+0x6c>
    800027b0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027b2:	94aa                	add	s1,s1,a0
    800027b4:	fff7c793          	not	a5,a5
    800027b8:	8f7d                	and	a4,a4,a5
    800027ba:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027be:	00001097          	auipc	ra,0x1
    800027c2:	120080e7          	jalr	288(ra) # 800038de <log_write>
  brelse(bp);
    800027c6:	854a                	mv	a0,s2
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	e92080e7          	jalr	-366(ra) # 8000265a <brelse>
}
    800027d0:	60e2                	ld	ra,24(sp)
    800027d2:	6442                	ld	s0,16(sp)
    800027d4:	64a2                	ld	s1,8(sp)
    800027d6:	6902                	ld	s2,0(sp)
    800027d8:	6105                	addi	sp,sp,32
    800027da:	8082                	ret
    panic("freeing free block");
    800027dc:	00006517          	auipc	a0,0x6
    800027e0:	d5450513          	addi	a0,a0,-684 # 80008530 <syscalls+0x130>
    800027e4:	00003097          	auipc	ra,0x3
    800027e8:	5dc080e7          	jalr	1500(ra) # 80005dc0 <panic>

00000000800027ec <balloc>:
{
    800027ec:	711d                	addi	sp,sp,-96
    800027ee:	ec86                	sd	ra,88(sp)
    800027f0:	e8a2                	sd	s0,80(sp)
    800027f2:	e4a6                	sd	s1,72(sp)
    800027f4:	e0ca                	sd	s2,64(sp)
    800027f6:	fc4e                	sd	s3,56(sp)
    800027f8:	f852                	sd	s4,48(sp)
    800027fa:	f456                	sd	s5,40(sp)
    800027fc:	f05a                	sd	s6,32(sp)
    800027fe:	ec5e                	sd	s7,24(sp)
    80002800:	e862                	sd	s8,16(sp)
    80002802:	e466                	sd	s9,8(sp)
    80002804:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002806:	00015797          	auipc	a5,0x15
    8000280a:	f567a783          	lw	a5,-170(a5) # 8001775c <sb+0x4>
    8000280e:	cbc1                	beqz	a5,8000289e <balloc+0xb2>
    80002810:	8baa                	mv	s7,a0
    80002812:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002814:	00015b17          	auipc	s6,0x15
    80002818:	f44b0b13          	addi	s6,s6,-188 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000281e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002820:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002822:	6c89                	lui	s9,0x2
    80002824:	a831                	j	80002840 <balloc+0x54>
    brelse(bp);
    80002826:	854a                	mv	a0,s2
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e32080e7          	jalr	-462(ra) # 8000265a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002830:	015c87bb          	addw	a5,s9,s5
    80002834:	00078a9b          	sext.w	s5,a5
    80002838:	004b2703          	lw	a4,4(s6)
    8000283c:	06eaf163          	bgeu	s5,a4,8000289e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002840:	41fad79b          	sraiw	a5,s5,0x1f
    80002844:	0137d79b          	srliw	a5,a5,0x13
    80002848:	015787bb          	addw	a5,a5,s5
    8000284c:	40d7d79b          	sraiw	a5,a5,0xd
    80002850:	01cb2583          	lw	a1,28(s6)
    80002854:	9dbd                	addw	a1,a1,a5
    80002856:	855e                	mv	a0,s7
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	cd2080e7          	jalr	-814(ra) # 8000252a <bread>
    80002860:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002862:	004b2503          	lw	a0,4(s6)
    80002866:	000a849b          	sext.w	s1,s5
    8000286a:	8762                	mv	a4,s8
    8000286c:	faa4fde3          	bgeu	s1,a0,80002826 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002870:	00777693          	andi	a3,a4,7
    80002874:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002878:	41f7579b          	sraiw	a5,a4,0x1f
    8000287c:	01d7d79b          	srliw	a5,a5,0x1d
    80002880:	9fb9                	addw	a5,a5,a4
    80002882:	4037d79b          	sraiw	a5,a5,0x3
    80002886:	00f90633          	add	a2,s2,a5
    8000288a:	05864603          	lbu	a2,88(a2)
    8000288e:	00c6f5b3          	and	a1,a3,a2
    80002892:	cd91                	beqz	a1,800028ae <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002894:	2705                	addiw	a4,a4,1
    80002896:	2485                	addiw	s1,s1,1
    80002898:	fd471ae3          	bne	a4,s4,8000286c <balloc+0x80>
    8000289c:	b769                	j	80002826 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000289e:	00006517          	auipc	a0,0x6
    800028a2:	caa50513          	addi	a0,a0,-854 # 80008548 <syscalls+0x148>
    800028a6:	00003097          	auipc	ra,0x3
    800028aa:	51a080e7          	jalr	1306(ra) # 80005dc0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028ae:	97ca                	add	a5,a5,s2
    800028b0:	8e55                	or	a2,a2,a3
    800028b2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	026080e7          	jalr	38(ra) # 800038de <log_write>
        brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	d98080e7          	jalr	-616(ra) # 8000265a <brelse>
  bp = bread(dev, bno);
    800028ca:	85a6                	mv	a1,s1
    800028cc:	855e                	mv	a0,s7
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	c5c080e7          	jalr	-932(ra) # 8000252a <bread>
    800028d6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028d8:	40000613          	li	a2,1024
    800028dc:	4581                	li	a1,0
    800028de:	05850513          	addi	a0,a0,88
    800028e2:	ffffe097          	auipc	ra,0xffffe
    800028e6:	898080e7          	jalr	-1896(ra) # 8000017a <memset>
  log_write(bp);
    800028ea:	854a                	mv	a0,s2
    800028ec:	00001097          	auipc	ra,0x1
    800028f0:	ff2080e7          	jalr	-14(ra) # 800038de <log_write>
  brelse(bp);
    800028f4:	854a                	mv	a0,s2
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	d64080e7          	jalr	-668(ra) # 8000265a <brelse>
}
    800028fe:	8526                	mv	a0,s1
    80002900:	60e6                	ld	ra,88(sp)
    80002902:	6446                	ld	s0,80(sp)
    80002904:	64a6                	ld	s1,72(sp)
    80002906:	6906                	ld	s2,64(sp)
    80002908:	79e2                	ld	s3,56(sp)
    8000290a:	7a42                	ld	s4,48(sp)
    8000290c:	7aa2                	ld	s5,40(sp)
    8000290e:	7b02                	ld	s6,32(sp)
    80002910:	6be2                	ld	s7,24(sp)
    80002912:	6c42                	ld	s8,16(sp)
    80002914:	6ca2                	ld	s9,8(sp)
    80002916:	6125                	addi	sp,sp,96
    80002918:	8082                	ret

000000008000291a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000291a:	7179                	addi	sp,sp,-48
    8000291c:	f406                	sd	ra,40(sp)
    8000291e:	f022                	sd	s0,32(sp)
    80002920:	ec26                	sd	s1,24(sp)
    80002922:	e84a                	sd	s2,16(sp)
    80002924:	e44e                	sd	s3,8(sp)
    80002926:	e052                	sd	s4,0(sp)
    80002928:	1800                	addi	s0,sp,48
    8000292a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000292c:	47ad                	li	a5,11
    8000292e:	04b7fe63          	bgeu	a5,a1,8000298a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002932:	ff45849b          	addiw	s1,a1,-12
    80002936:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000293a:	0ff00793          	li	a5,255
    8000293e:	0ae7e463          	bltu	a5,a4,800029e6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002942:	08052583          	lw	a1,128(a0)
    80002946:	c5b5                	beqz	a1,800029b2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002948:	00092503          	lw	a0,0(s2)
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	bde080e7          	jalr	-1058(ra) # 8000252a <bread>
    80002954:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002956:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000295a:	02049713          	slli	a4,s1,0x20
    8000295e:	01e75593          	srli	a1,a4,0x1e
    80002962:	00b784b3          	add	s1,a5,a1
    80002966:	0004a983          	lw	s3,0(s1)
    8000296a:	04098e63          	beqz	s3,800029c6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000296e:	8552                	mv	a0,s4
    80002970:	00000097          	auipc	ra,0x0
    80002974:	cea080e7          	jalr	-790(ra) # 8000265a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002978:	854e                	mv	a0,s3
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6a02                	ld	s4,0(sp)
    80002986:	6145                	addi	sp,sp,48
    80002988:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000298a:	02059793          	slli	a5,a1,0x20
    8000298e:	01e7d593          	srli	a1,a5,0x1e
    80002992:	00b504b3          	add	s1,a0,a1
    80002996:	0504a983          	lw	s3,80(s1)
    8000299a:	fc099fe3          	bnez	s3,80002978 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000299e:	4108                	lw	a0,0(a0)
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	e4c080e7          	jalr	-436(ra) # 800027ec <balloc>
    800029a8:	0005099b          	sext.w	s3,a0
    800029ac:	0534a823          	sw	s3,80(s1)
    800029b0:	b7e1                	j	80002978 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029b2:	4108                	lw	a0,0(a0)
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e38080e7          	jalr	-456(ra) # 800027ec <balloc>
    800029bc:	0005059b          	sext.w	a1,a0
    800029c0:	08b92023          	sw	a1,128(s2)
    800029c4:	b751                	j	80002948 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029c6:	00092503          	lw	a0,0(s2)
    800029ca:	00000097          	auipc	ra,0x0
    800029ce:	e22080e7          	jalr	-478(ra) # 800027ec <balloc>
    800029d2:	0005099b          	sext.w	s3,a0
    800029d6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029da:	8552                	mv	a0,s4
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	f02080e7          	jalr	-254(ra) # 800038de <log_write>
    800029e4:	b769                	j	8000296e <bmap+0x54>
  panic("bmap: out of range");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	b7a50513          	addi	a0,a0,-1158 # 80008560 <syscalls+0x160>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	3d2080e7          	jalr	978(ra) # 80005dc0 <panic>

00000000800029f6 <iget>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	e052                	sd	s4,0(sp)
    80002a04:	1800                	addi	s0,sp,48
    80002a06:	89aa                	mv	s3,a0
    80002a08:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a0a:	00015517          	auipc	a0,0x15
    80002a0e:	d6e50513          	addi	a0,a0,-658 # 80017778 <itable>
    80002a12:	00004097          	auipc	ra,0x4
    80002a16:	8e6080e7          	jalr	-1818(ra) # 800062f8 <acquire>
  empty = 0;
    80002a1a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1c:	00015497          	auipc	s1,0x15
    80002a20:	d7448493          	addi	s1,s1,-652 # 80017790 <itable+0x18>
    80002a24:	00016697          	auipc	a3,0x16
    80002a28:	7fc68693          	addi	a3,a3,2044 # 80019220 <log>
    80002a2c:	a039                	j	80002a3a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2e:	02090b63          	beqz	s2,80002a64 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a32:	08848493          	addi	s1,s1,136
    80002a36:	02d48a63          	beq	s1,a3,80002a6a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a3a:	449c                	lw	a5,8(s1)
    80002a3c:	fef059e3          	blez	a5,80002a2e <iget+0x38>
    80002a40:	4098                	lw	a4,0(s1)
    80002a42:	ff3716e3          	bne	a4,s3,80002a2e <iget+0x38>
    80002a46:	40d8                	lw	a4,4(s1)
    80002a48:	ff4713e3          	bne	a4,s4,80002a2e <iget+0x38>
      ip->ref++;
    80002a4c:	2785                	addiw	a5,a5,1
    80002a4e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a50:	00015517          	auipc	a0,0x15
    80002a54:	d2850513          	addi	a0,a0,-728 # 80017778 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	954080e7          	jalr	-1708(ra) # 800063ac <release>
      return ip;
    80002a60:	8926                	mv	s2,s1
    80002a62:	a03d                	j	80002a90 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a64:	f7f9                	bnez	a5,80002a32 <iget+0x3c>
    80002a66:	8926                	mv	s2,s1
    80002a68:	b7e9                	j	80002a32 <iget+0x3c>
  if(empty == 0)
    80002a6a:	02090c63          	beqz	s2,80002aa2 <iget+0xac>
  ip->dev = dev;
    80002a6e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a72:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a76:	4785                	li	a5,1
    80002a78:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a7c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a80:	00015517          	auipc	a0,0x15
    80002a84:	cf850513          	addi	a0,a0,-776 # 80017778 <itable>
    80002a88:	00004097          	auipc	ra,0x4
    80002a8c:	924080e7          	jalr	-1756(ra) # 800063ac <release>
}
    80002a90:	854a                	mv	a0,s2
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6a02                	ld	s4,0(sp)
    80002a9e:	6145                	addi	sp,sp,48
    80002aa0:	8082                	ret
    panic("iget: no inodes");
    80002aa2:	00006517          	auipc	a0,0x6
    80002aa6:	ad650513          	addi	a0,a0,-1322 # 80008578 <syscalls+0x178>
    80002aaa:	00003097          	auipc	ra,0x3
    80002aae:	316080e7          	jalr	790(ra) # 80005dc0 <panic>

0000000080002ab2 <fsinit>:
fsinit(int dev) {
    80002ab2:	7179                	addi	sp,sp,-48
    80002ab4:	f406                	sd	ra,40(sp)
    80002ab6:	f022                	sd	s0,32(sp)
    80002ab8:	ec26                	sd	s1,24(sp)
    80002aba:	e84a                	sd	s2,16(sp)
    80002abc:	e44e                	sd	s3,8(sp)
    80002abe:	1800                	addi	s0,sp,48
    80002ac0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ac2:	4585                	li	a1,1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	a66080e7          	jalr	-1434(ra) # 8000252a <bread>
    80002acc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ace:	00015997          	auipc	s3,0x15
    80002ad2:	c8a98993          	addi	s3,s3,-886 # 80017758 <sb>
    80002ad6:	02000613          	li	a2,32
    80002ada:	05850593          	addi	a1,a0,88
    80002ade:	854e                	mv	a0,s3
    80002ae0:	ffffd097          	auipc	ra,0xffffd
    80002ae4:	6f6080e7          	jalr	1782(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ae8:	8526                	mv	a0,s1
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	b70080e7          	jalr	-1168(ra) # 8000265a <brelse>
  if(sb.magic != FSMAGIC)
    80002af2:	0009a703          	lw	a4,0(s3)
    80002af6:	102037b7          	lui	a5,0x10203
    80002afa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afe:	02f71263          	bne	a4,a5,80002b22 <fsinit+0x70>
  initlog(dev, &sb);
    80002b02:	00015597          	auipc	a1,0x15
    80002b06:	c5658593          	addi	a1,a1,-938 # 80017758 <sb>
    80002b0a:	854a                	mv	a0,s2
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	b56080e7          	jalr	-1194(ra) # 80003662 <initlog>
}
    80002b14:	70a2                	ld	ra,40(sp)
    80002b16:	7402                	ld	s0,32(sp)
    80002b18:	64e2                	ld	s1,24(sp)
    80002b1a:	6942                	ld	s2,16(sp)
    80002b1c:	69a2                	ld	s3,8(sp)
    80002b1e:	6145                	addi	sp,sp,48
    80002b20:	8082                	ret
    panic("invalid file system");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	a6650513          	addi	a0,a0,-1434 # 80008588 <syscalls+0x188>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	296080e7          	jalr	662(ra) # 80005dc0 <panic>

0000000080002b32 <iinit>:
{
    80002b32:	7179                	addi	sp,sp,-48
    80002b34:	f406                	sd	ra,40(sp)
    80002b36:	f022                	sd	s0,32(sp)
    80002b38:	ec26                	sd	s1,24(sp)
    80002b3a:	e84a                	sd	s2,16(sp)
    80002b3c:	e44e                	sd	s3,8(sp)
    80002b3e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b40:	00006597          	auipc	a1,0x6
    80002b44:	a6058593          	addi	a1,a1,-1440 # 800085a0 <syscalls+0x1a0>
    80002b48:	00015517          	auipc	a0,0x15
    80002b4c:	c3050513          	addi	a0,a0,-976 # 80017778 <itable>
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	718080e7          	jalr	1816(ra) # 80006268 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b58:	00015497          	auipc	s1,0x15
    80002b5c:	c4848493          	addi	s1,s1,-952 # 800177a0 <itable+0x28>
    80002b60:	00016997          	auipc	s3,0x16
    80002b64:	6d098993          	addi	s3,s3,1744 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b68:	00006917          	auipc	s2,0x6
    80002b6c:	a4090913          	addi	s2,s2,-1472 # 800085a8 <syscalls+0x1a8>
    80002b70:	85ca                	mv	a1,s2
    80002b72:	8526                	mv	a0,s1
    80002b74:	00001097          	auipc	ra,0x1
    80002b78:	e4e080e7          	jalr	-434(ra) # 800039c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b7c:	08848493          	addi	s1,s1,136
    80002b80:	ff3498e3          	bne	s1,s3,80002b70 <iinit+0x3e>
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6145                	addi	sp,sp,48
    80002b90:	8082                	ret

0000000080002b92 <ialloc>:
{
    80002b92:	715d                	addi	sp,sp,-80
    80002b94:	e486                	sd	ra,72(sp)
    80002b96:	e0a2                	sd	s0,64(sp)
    80002b98:	fc26                	sd	s1,56(sp)
    80002b9a:	f84a                	sd	s2,48(sp)
    80002b9c:	f44e                	sd	s3,40(sp)
    80002b9e:	f052                	sd	s4,32(sp)
    80002ba0:	ec56                	sd	s5,24(sp)
    80002ba2:	e85a                	sd	s6,16(sp)
    80002ba4:	e45e                	sd	s7,8(sp)
    80002ba6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba8:	00015717          	auipc	a4,0x15
    80002bac:	bbc72703          	lw	a4,-1092(a4) # 80017764 <sb+0xc>
    80002bb0:	4785                	li	a5,1
    80002bb2:	04e7fa63          	bgeu	a5,a4,80002c06 <ialloc+0x74>
    80002bb6:	8aaa                	mv	s5,a0
    80002bb8:	8bae                	mv	s7,a1
    80002bba:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bbc:	00015a17          	auipc	s4,0x15
    80002bc0:	b9ca0a13          	addi	s4,s4,-1124 # 80017758 <sb>
    80002bc4:	00048b1b          	sext.w	s6,s1
    80002bc8:	0044d593          	srli	a1,s1,0x4
    80002bcc:	018a2783          	lw	a5,24(s4)
    80002bd0:	9dbd                	addw	a1,a1,a5
    80002bd2:	8556                	mv	a0,s5
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	956080e7          	jalr	-1706(ra) # 8000252a <bread>
    80002bdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bde:	05850993          	addi	s3,a0,88
    80002be2:	00f4f793          	andi	a5,s1,15
    80002be6:	079a                	slli	a5,a5,0x6
    80002be8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bea:	00099783          	lh	a5,0(s3)
    80002bee:	c785                	beqz	a5,80002c16 <ialloc+0x84>
    brelse(bp);
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	a6a080e7          	jalr	-1430(ra) # 8000265a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf8:	0485                	addi	s1,s1,1
    80002bfa:	00ca2703          	lw	a4,12(s4)
    80002bfe:	0004879b          	sext.w	a5,s1
    80002c02:	fce7e1e3          	bltu	a5,a4,80002bc4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	9aa50513          	addi	a0,a0,-1622 # 800085b0 <syscalls+0x1b0>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	1b2080e7          	jalr	434(ra) # 80005dc0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c16:	04000613          	li	a2,64
    80002c1a:	4581                	li	a1,0
    80002c1c:	854e                	mv	a0,s3
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	55c080e7          	jalr	1372(ra) # 8000017a <memset>
      dip->type = type;
    80002c26:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c2a:	854a                	mv	a0,s2
    80002c2c:	00001097          	auipc	ra,0x1
    80002c30:	cb2080e7          	jalr	-846(ra) # 800038de <log_write>
      brelse(bp);
    80002c34:	854a                	mv	a0,s2
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	a24080e7          	jalr	-1500(ra) # 8000265a <brelse>
      return iget(dev, inum);
    80002c3e:	85da                	mv	a1,s6
    80002c40:	8556                	mv	a0,s5
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	db4080e7          	jalr	-588(ra) # 800029f6 <iget>
}
    80002c4a:	60a6                	ld	ra,72(sp)
    80002c4c:	6406                	ld	s0,64(sp)
    80002c4e:	74e2                	ld	s1,56(sp)
    80002c50:	7942                	ld	s2,48(sp)
    80002c52:	79a2                	ld	s3,40(sp)
    80002c54:	7a02                	ld	s4,32(sp)
    80002c56:	6ae2                	ld	s5,24(sp)
    80002c58:	6b42                	ld	s6,16(sp)
    80002c5a:	6ba2                	ld	s7,8(sp)
    80002c5c:	6161                	addi	sp,sp,80
    80002c5e:	8082                	ret

0000000080002c60 <iupdate>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
    80002c6c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6e:	415c                	lw	a5,4(a0)
    80002c70:	0047d79b          	srliw	a5,a5,0x4
    80002c74:	00015597          	auipc	a1,0x15
    80002c78:	afc5a583          	lw	a1,-1284(a1) # 80017770 <sb+0x18>
    80002c7c:	9dbd                	addw	a1,a1,a5
    80002c7e:	4108                	lw	a0,0(a0)
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	8aa080e7          	jalr	-1878(ra) # 8000252a <bread>
    80002c88:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8a:	05850793          	addi	a5,a0,88
    80002c8e:	40d8                	lw	a4,4(s1)
    80002c90:	8b3d                	andi	a4,a4,15
    80002c92:	071a                	slli	a4,a4,0x6
    80002c94:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c96:	04449703          	lh	a4,68(s1)
    80002c9a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c9e:	04649703          	lh	a4,70(s1)
    80002ca2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ca6:	04849703          	lh	a4,72(s1)
    80002caa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cae:	04a49703          	lh	a4,74(s1)
    80002cb2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cb6:	44f8                	lw	a4,76(s1)
    80002cb8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cba:	03400613          	li	a2,52
    80002cbe:	05048593          	addi	a1,s1,80
    80002cc2:	00c78513          	addi	a0,a5,12
    80002cc6:	ffffd097          	auipc	ra,0xffffd
    80002cca:	510080e7          	jalr	1296(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	c0e080e7          	jalr	-1010(ra) # 800038de <log_write>
  brelse(bp);
    80002cd8:	854a                	mv	a0,s2
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	980080e7          	jalr	-1664(ra) # 8000265a <brelse>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret

0000000080002cee <idup>:
{
    80002cee:	1101                	addi	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	1000                	addi	s0,sp,32
    80002cf8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cfa:	00015517          	auipc	a0,0x15
    80002cfe:	a7e50513          	addi	a0,a0,-1410 # 80017778 <itable>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	5f6080e7          	jalr	1526(ra) # 800062f8 <acquire>
  ip->ref++;
    80002d0a:	449c                	lw	a5,8(s1)
    80002d0c:	2785                	addiw	a5,a5,1
    80002d0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d10:	00015517          	auipc	a0,0x15
    80002d14:	a6850513          	addi	a0,a0,-1432 # 80017778 <itable>
    80002d18:	00003097          	auipc	ra,0x3
    80002d1c:	694080e7          	jalr	1684(ra) # 800063ac <release>
}
    80002d20:	8526                	mv	a0,s1
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret

0000000080002d2c <ilock>:
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d38:	c115                	beqz	a0,80002d5c <ilock+0x30>
    80002d3a:	84aa                	mv	s1,a0
    80002d3c:	451c                	lw	a5,8(a0)
    80002d3e:	00f05f63          	blez	a5,80002d5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d42:	0541                	addi	a0,a0,16
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	cb8080e7          	jalr	-840(ra) # 800039fc <acquiresleep>
  if(ip->valid == 0){
    80002d4c:	40bc                	lw	a5,64(s1)
    80002d4e:	cf99                	beqz	a5,80002d6c <ilock+0x40>
}
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6902                	ld	s2,0(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret
    panic("ilock");
    80002d5c:	00006517          	auipc	a0,0x6
    80002d60:	86c50513          	addi	a0,a0,-1940 # 800085c8 <syscalls+0x1c8>
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	05c080e7          	jalr	92(ra) # 80005dc0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d6c:	40dc                	lw	a5,4(s1)
    80002d6e:	0047d79b          	srliw	a5,a5,0x4
    80002d72:	00015597          	auipc	a1,0x15
    80002d76:	9fe5a583          	lw	a1,-1538(a1) # 80017770 <sb+0x18>
    80002d7a:	9dbd                	addw	a1,a1,a5
    80002d7c:	4088                	lw	a0,0(s1)
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	7ac080e7          	jalr	1964(ra) # 8000252a <bread>
    80002d86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d88:	05850593          	addi	a1,a0,88
    80002d8c:	40dc                	lw	a5,4(s1)
    80002d8e:	8bbd                	andi	a5,a5,15
    80002d90:	079a                	slli	a5,a5,0x6
    80002d92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d94:	00059783          	lh	a5,0(a1)
    80002d98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d9c:	00259783          	lh	a5,2(a1)
    80002da0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002da4:	00459783          	lh	a5,4(a1)
    80002da8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dac:	00659783          	lh	a5,6(a1)
    80002db0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002db4:	459c                	lw	a5,8(a1)
    80002db6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db8:	03400613          	li	a2,52
    80002dbc:	05b1                	addi	a1,a1,12
    80002dbe:	05048513          	addi	a0,s1,80
    80002dc2:	ffffd097          	auipc	ra,0xffffd
    80002dc6:	414080e7          	jalr	1044(ra) # 800001d6 <memmove>
    brelse(bp);
    80002dca:	854a                	mv	a0,s2
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	88e080e7          	jalr	-1906(ra) # 8000265a <brelse>
    ip->valid = 1;
    80002dd4:	4785                	li	a5,1
    80002dd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd8:	04449783          	lh	a5,68(s1)
    80002ddc:	fbb5                	bnez	a5,80002d50 <ilock+0x24>
      panic("ilock: no type");
    80002dde:	00005517          	auipc	a0,0x5
    80002de2:	7f250513          	addi	a0,a0,2034 # 800085d0 <syscalls+0x1d0>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	fda080e7          	jalr	-38(ra) # 80005dc0 <panic>

0000000080002dee <iunlock>:
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	e426                	sd	s1,8(sp)
    80002df6:	e04a                	sd	s2,0(sp)
    80002df8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dfa:	c905                	beqz	a0,80002e2a <iunlock+0x3c>
    80002dfc:	84aa                	mv	s1,a0
    80002dfe:	01050913          	addi	s2,a0,16
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	c92080e7          	jalr	-878(ra) # 80003a96 <holdingsleep>
    80002e0c:	cd19                	beqz	a0,80002e2a <iunlock+0x3c>
    80002e0e:	449c                	lw	a5,8(s1)
    80002e10:	00f05d63          	blez	a5,80002e2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	00001097          	auipc	ra,0x1
    80002e1a:	c3c080e7          	jalr	-964(ra) # 80003a52 <releasesleep>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6902                	ld	s2,0(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret
    panic("iunlock");
    80002e2a:	00005517          	auipc	a0,0x5
    80002e2e:	7b650513          	addi	a0,a0,1974 # 800085e0 <syscalls+0x1e0>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	f8e080e7          	jalr	-114(ra) # 80005dc0 <panic>

0000000080002e3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e3a:	7179                	addi	sp,sp,-48
    80002e3c:	f406                	sd	ra,40(sp)
    80002e3e:	f022                	sd	s0,32(sp)
    80002e40:	ec26                	sd	s1,24(sp)
    80002e42:	e84a                	sd	s2,16(sp)
    80002e44:	e44e                	sd	s3,8(sp)
    80002e46:	e052                	sd	s4,0(sp)
    80002e48:	1800                	addi	s0,sp,48
    80002e4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e4c:	05050493          	addi	s1,a0,80
    80002e50:	08050913          	addi	s2,a0,128
    80002e54:	a021                	j	80002e5c <itrunc+0x22>
    80002e56:	0491                	addi	s1,s1,4
    80002e58:	01248d63          	beq	s1,s2,80002e72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e5c:	408c                	lw	a1,0(s1)
    80002e5e:	dde5                	beqz	a1,80002e56 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	90c080e7          	jalr	-1780(ra) # 80002770 <bfree>
      ip->addrs[i] = 0;
    80002e6c:	0004a023          	sw	zero,0(s1)
    80002e70:	b7dd                	j	80002e56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e72:	0809a583          	lw	a1,128(s3)
    80002e76:	e185                	bnez	a1,80002e96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e7c:	854e                	mv	a0,s3
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	de2080e7          	jalr	-542(ra) # 80002c60 <iupdate>
}
    80002e86:	70a2                	ld	ra,40(sp)
    80002e88:	7402                	ld	s0,32(sp)
    80002e8a:	64e2                	ld	s1,24(sp)
    80002e8c:	6942                	ld	s2,16(sp)
    80002e8e:	69a2                	ld	s3,8(sp)
    80002e90:	6a02                	ld	s4,0(sp)
    80002e92:	6145                	addi	sp,sp,48
    80002e94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	fffff097          	auipc	ra,0xfffff
    80002e9e:	690080e7          	jalr	1680(ra) # 8000252a <bread>
    80002ea2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ea4:	05850493          	addi	s1,a0,88
    80002ea8:	45850913          	addi	s2,a0,1112
    80002eac:	a021                	j	80002eb4 <itrunc+0x7a>
    80002eae:	0491                	addi	s1,s1,4
    80002eb0:	01248b63          	beq	s1,s2,80002ec6 <itrunc+0x8c>
      if(a[j])
    80002eb4:	408c                	lw	a1,0(s1)
    80002eb6:	dde5                	beqz	a1,80002eae <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002eb8:	0009a503          	lw	a0,0(s3)
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	8b4080e7          	jalr	-1868(ra) # 80002770 <bfree>
    80002ec4:	b7ed                	j	80002eae <itrunc+0x74>
    brelse(bp);
    80002ec6:	8552                	mv	a0,s4
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	792080e7          	jalr	1938(ra) # 8000265a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ed0:	0809a583          	lw	a1,128(s3)
    80002ed4:	0009a503          	lw	a0,0(s3)
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	898080e7          	jalr	-1896(ra) # 80002770 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ee0:	0809a023          	sw	zero,128(s3)
    80002ee4:	bf51                	j	80002e78 <itrunc+0x3e>

0000000080002ee6 <iput>:
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	e04a                	sd	s2,0(sp)
    80002ef0:	1000                	addi	s0,sp,32
    80002ef2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ef4:	00015517          	auipc	a0,0x15
    80002ef8:	88450513          	addi	a0,a0,-1916 # 80017778 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	3fc080e7          	jalr	1020(ra) # 800062f8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f04:	4498                	lw	a4,8(s1)
    80002f06:	4785                	li	a5,1
    80002f08:	02f70363          	beq	a4,a5,80002f2e <iput+0x48>
  ip->ref--;
    80002f0c:	449c                	lw	a5,8(s1)
    80002f0e:	37fd                	addiw	a5,a5,-1
    80002f10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f12:	00015517          	auipc	a0,0x15
    80002f16:	86650513          	addi	a0,a0,-1946 # 80017778 <itable>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	492080e7          	jalr	1170(ra) # 800063ac <release>
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6902                	ld	s2,0(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2e:	40bc                	lw	a5,64(s1)
    80002f30:	dff1                	beqz	a5,80002f0c <iput+0x26>
    80002f32:	04a49783          	lh	a5,74(s1)
    80002f36:	fbf9                	bnez	a5,80002f0c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f38:	01048913          	addi	s2,s1,16
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	00001097          	auipc	ra,0x1
    80002f42:	abe080e7          	jalr	-1346(ra) # 800039fc <acquiresleep>
    release(&itable.lock);
    80002f46:	00015517          	auipc	a0,0x15
    80002f4a:	83250513          	addi	a0,a0,-1998 # 80017778 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	45e080e7          	jalr	1118(ra) # 800063ac <release>
    itrunc(ip);
    80002f56:	8526                	mv	a0,s1
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	ee2080e7          	jalr	-286(ra) # 80002e3a <itrunc>
    ip->type = 0;
    80002f60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	cfa080e7          	jalr	-774(ra) # 80002c60 <iupdate>
    ip->valid = 0;
    80002f6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f72:	854a                	mv	a0,s2
    80002f74:	00001097          	auipc	ra,0x1
    80002f78:	ade080e7          	jalr	-1314(ra) # 80003a52 <releasesleep>
    acquire(&itable.lock);
    80002f7c:	00014517          	auipc	a0,0x14
    80002f80:	7fc50513          	addi	a0,a0,2044 # 80017778 <itable>
    80002f84:	00003097          	auipc	ra,0x3
    80002f88:	374080e7          	jalr	884(ra) # 800062f8 <acquire>
    80002f8c:	b741                	j	80002f0c <iput+0x26>

0000000080002f8e <iunlockput>:
{
    80002f8e:	1101                	addi	sp,sp,-32
    80002f90:	ec06                	sd	ra,24(sp)
    80002f92:	e822                	sd	s0,16(sp)
    80002f94:	e426                	sd	s1,8(sp)
    80002f96:	1000                	addi	s0,sp,32
    80002f98:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	e54080e7          	jalr	-428(ra) # 80002dee <iunlock>
  iput(ip);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	f42080e7          	jalr	-190(ra) # 80002ee6 <iput>
}
    80002fac:	60e2                	ld	ra,24(sp)
    80002fae:	6442                	ld	s0,16(sp)
    80002fb0:	64a2                	ld	s1,8(sp)
    80002fb2:	6105                	addi	sp,sp,32
    80002fb4:	8082                	ret

0000000080002fb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fb6:	1141                	addi	sp,sp,-16
    80002fb8:	e422                	sd	s0,8(sp)
    80002fba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fbc:	411c                	lw	a5,0(a0)
    80002fbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fc0:	415c                	lw	a5,4(a0)
    80002fc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc4:	04451783          	lh	a5,68(a0)
    80002fc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fcc:	04a51783          	lh	a5,74(a0)
    80002fd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd4:	04c56783          	lwu	a5,76(a0)
    80002fd8:	e99c                	sd	a5,16(a1)
}
    80002fda:	6422                	ld	s0,8(sp)
    80002fdc:	0141                	addi	sp,sp,16
    80002fde:	8082                	ret

0000000080002fe0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe0:	457c                	lw	a5,76(a0)
    80002fe2:	0ed7e963          	bltu	a5,a3,800030d4 <readi+0xf4>
{
    80002fe6:	7159                	addi	sp,sp,-112
    80002fe8:	f486                	sd	ra,104(sp)
    80002fea:	f0a2                	sd	s0,96(sp)
    80002fec:	eca6                	sd	s1,88(sp)
    80002fee:	e8ca                	sd	s2,80(sp)
    80002ff0:	e4ce                	sd	s3,72(sp)
    80002ff2:	e0d2                	sd	s4,64(sp)
    80002ff4:	fc56                	sd	s5,56(sp)
    80002ff6:	f85a                	sd	s6,48(sp)
    80002ff8:	f45e                	sd	s7,40(sp)
    80002ffa:	f062                	sd	s8,32(sp)
    80002ffc:	ec66                	sd	s9,24(sp)
    80002ffe:	e86a                	sd	s10,16(sp)
    80003000:	e46e                	sd	s11,8(sp)
    80003002:	1880                	addi	s0,sp,112
    80003004:	8baa                	mv	s7,a0
    80003006:	8c2e                	mv	s8,a1
    80003008:	8ab2                	mv	s5,a2
    8000300a:	84b6                	mv	s1,a3
    8000300c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000300e:	9f35                	addw	a4,a4,a3
    return 0;
    80003010:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003012:	0ad76063          	bltu	a4,a3,800030b2 <readi+0xd2>
  if(off + n > ip->size)
    80003016:	00e7f463          	bgeu	a5,a4,8000301e <readi+0x3e>
    n = ip->size - off;
    8000301a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000301e:	0a0b0963          	beqz	s6,800030d0 <readi+0xf0>
    80003022:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003028:	5cfd                	li	s9,-1
    8000302a:	a82d                	j	80003064 <readi+0x84>
    8000302c:	020a1d93          	slli	s11,s4,0x20
    80003030:	020ddd93          	srli	s11,s11,0x20
    80003034:	05890613          	addi	a2,s2,88
    80003038:	86ee                	mv	a3,s11
    8000303a:	963a                	add	a2,a2,a4
    8000303c:	85d6                	mv	a1,s5
    8000303e:	8562                	mv	a0,s8
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	a24080e7          	jalr	-1500(ra) # 80001a64 <either_copyout>
    80003048:	05950d63          	beq	a0,s9,800030a2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000304c:	854a                	mv	a0,s2
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	60c080e7          	jalr	1548(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003056:	013a09bb          	addw	s3,s4,s3
    8000305a:	009a04bb          	addw	s1,s4,s1
    8000305e:	9aee                	add	s5,s5,s11
    80003060:	0569f763          	bgeu	s3,s6,800030ae <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003064:	000ba903          	lw	s2,0(s7)
    80003068:	00a4d59b          	srliw	a1,s1,0xa
    8000306c:	855e                	mv	a0,s7
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	8ac080e7          	jalr	-1876(ra) # 8000291a <bmap>
    80003076:	0005059b          	sext.w	a1,a0
    8000307a:	854a                	mv	a0,s2
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	4ae080e7          	jalr	1198(ra) # 8000252a <bread>
    80003084:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	3ff4f713          	andi	a4,s1,1023
    8000308a:	40ed07bb          	subw	a5,s10,a4
    8000308e:	413b06bb          	subw	a3,s6,s3
    80003092:	8a3e                	mv	s4,a5
    80003094:	2781                	sext.w	a5,a5
    80003096:	0006861b          	sext.w	a2,a3
    8000309a:	f8f679e3          	bgeu	a2,a5,8000302c <readi+0x4c>
    8000309e:	8a36                	mv	s4,a3
    800030a0:	b771                	j	8000302c <readi+0x4c>
      brelse(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	5b6080e7          	jalr	1462(ra) # 8000265a <brelse>
      tot = -1;
    800030ac:	59fd                	li	s3,-1
  }
  return tot;
    800030ae:	0009851b          	sext.w	a0,s3
}
    800030b2:	70a6                	ld	ra,104(sp)
    800030b4:	7406                	ld	s0,96(sp)
    800030b6:	64e6                	ld	s1,88(sp)
    800030b8:	6946                	ld	s2,80(sp)
    800030ba:	69a6                	ld	s3,72(sp)
    800030bc:	6a06                	ld	s4,64(sp)
    800030be:	7ae2                	ld	s5,56(sp)
    800030c0:	7b42                	ld	s6,48(sp)
    800030c2:	7ba2                	ld	s7,40(sp)
    800030c4:	7c02                	ld	s8,32(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)
    800030cc:	6165                	addi	sp,sp,112
    800030ce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	89da                	mv	s3,s6
    800030d2:	bff1                	j	800030ae <readi+0xce>
    return 0;
    800030d4:	4501                	li	a0,0
}
    800030d6:	8082                	ret

00000000800030d8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d8:	457c                	lw	a5,76(a0)
    800030da:	10d7e863          	bltu	a5,a3,800031ea <writei+0x112>
{
    800030de:	7159                	addi	sp,sp,-112
    800030e0:	f486                	sd	ra,104(sp)
    800030e2:	f0a2                	sd	s0,96(sp)
    800030e4:	eca6                	sd	s1,88(sp)
    800030e6:	e8ca                	sd	s2,80(sp)
    800030e8:	e4ce                	sd	s3,72(sp)
    800030ea:	e0d2                	sd	s4,64(sp)
    800030ec:	fc56                	sd	s5,56(sp)
    800030ee:	f85a                	sd	s6,48(sp)
    800030f0:	f45e                	sd	s7,40(sp)
    800030f2:	f062                	sd	s8,32(sp)
    800030f4:	ec66                	sd	s9,24(sp)
    800030f6:	e86a                	sd	s10,16(sp)
    800030f8:	e46e                	sd	s11,8(sp)
    800030fa:	1880                	addi	s0,sp,112
    800030fc:	8b2a                	mv	s6,a0
    800030fe:	8c2e                	mv	s8,a1
    80003100:	8ab2                	mv	s5,a2
    80003102:	8936                	mv	s2,a3
    80003104:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003106:	00e687bb          	addw	a5,a3,a4
    8000310a:	0ed7e263          	bltu	a5,a3,800031ee <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000310e:	00043737          	lui	a4,0x43
    80003112:	0ef76063          	bltu	a4,a5,800031f2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003116:	0c0b8863          	beqz	s7,800031e6 <writei+0x10e>
    8000311a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003120:	5cfd                	li	s9,-1
    80003122:	a091                	j	80003166 <writei+0x8e>
    80003124:	02099d93          	slli	s11,s3,0x20
    80003128:	020ddd93          	srli	s11,s11,0x20
    8000312c:	05848513          	addi	a0,s1,88
    80003130:	86ee                	mv	a3,s11
    80003132:	8656                	mv	a2,s5
    80003134:	85e2                	mv	a1,s8
    80003136:	953a                	add	a0,a0,a4
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	982080e7          	jalr	-1662(ra) # 80001aba <either_copyin>
    80003140:	07950263          	beq	a0,s9,800031a4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003144:	8526                	mv	a0,s1
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	798080e7          	jalr	1944(ra) # 800038de <log_write>
    brelse(bp);
    8000314e:	8526                	mv	a0,s1
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	50a080e7          	jalr	1290(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003158:	01498a3b          	addw	s4,s3,s4
    8000315c:	0129893b          	addw	s2,s3,s2
    80003160:	9aee                	add	s5,s5,s11
    80003162:	057a7663          	bgeu	s4,s7,800031ae <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003166:	000b2483          	lw	s1,0(s6)
    8000316a:	00a9559b          	srliw	a1,s2,0xa
    8000316e:	855a                	mv	a0,s6
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	7aa080e7          	jalr	1962(ra) # 8000291a <bmap>
    80003178:	0005059b          	sext.w	a1,a0
    8000317c:	8526                	mv	a0,s1
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	3ac080e7          	jalr	940(ra) # 8000252a <bread>
    80003186:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003188:	3ff97713          	andi	a4,s2,1023
    8000318c:	40ed07bb          	subw	a5,s10,a4
    80003190:	414b86bb          	subw	a3,s7,s4
    80003194:	89be                	mv	s3,a5
    80003196:	2781                	sext.w	a5,a5
    80003198:	0006861b          	sext.w	a2,a3
    8000319c:	f8f674e3          	bgeu	a2,a5,80003124 <writei+0x4c>
    800031a0:	89b6                	mv	s3,a3
    800031a2:	b749                	j	80003124 <writei+0x4c>
      brelse(bp);
    800031a4:	8526                	mv	a0,s1
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	4b4080e7          	jalr	1204(ra) # 8000265a <brelse>
  }

  if(off > ip->size)
    800031ae:	04cb2783          	lw	a5,76(s6)
    800031b2:	0127f463          	bgeu	a5,s2,800031ba <writei+0xe2>
    ip->size = off;
    800031b6:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ba:	855a                	mv	a0,s6
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	aa4080e7          	jalr	-1372(ra) # 80002c60 <iupdate>

  return tot;
    800031c4:	000a051b          	sext.w	a0,s4
}
    800031c8:	70a6                	ld	ra,104(sp)
    800031ca:	7406                	ld	s0,96(sp)
    800031cc:	64e6                	ld	s1,88(sp)
    800031ce:	6946                	ld	s2,80(sp)
    800031d0:	69a6                	ld	s3,72(sp)
    800031d2:	6a06                	ld	s4,64(sp)
    800031d4:	7ae2                	ld	s5,56(sp)
    800031d6:	7b42                	ld	s6,48(sp)
    800031d8:	7ba2                	ld	s7,40(sp)
    800031da:	7c02                	ld	s8,32(sp)
    800031dc:	6ce2                	ld	s9,24(sp)
    800031de:	6d42                	ld	s10,16(sp)
    800031e0:	6da2                	ld	s11,8(sp)
    800031e2:	6165                	addi	sp,sp,112
    800031e4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031e6:	8a5e                	mv	s4,s7
    800031e8:	bfc9                	j	800031ba <writei+0xe2>
    return -1;
    800031ea:	557d                	li	a0,-1
}
    800031ec:	8082                	ret
    return -1;
    800031ee:	557d                	li	a0,-1
    800031f0:	bfe1                	j	800031c8 <writei+0xf0>
    return -1;
    800031f2:	557d                	li	a0,-1
    800031f4:	bfd1                	j	800031c8 <writei+0xf0>

00000000800031f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031f6:	1141                	addi	sp,sp,-16
    800031f8:	e406                	sd	ra,8(sp)
    800031fa:	e022                	sd	s0,0(sp)
    800031fc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031fe:	4639                	li	a2,14
    80003200:	ffffd097          	auipc	ra,0xffffd
    80003204:	04a080e7          	jalr	74(ra) # 8000024a <strncmp>
}
    80003208:	60a2                	ld	ra,8(sp)
    8000320a:	6402                	ld	s0,0(sp)
    8000320c:	0141                	addi	sp,sp,16
    8000320e:	8082                	ret

0000000080003210 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003210:	7139                	addi	sp,sp,-64
    80003212:	fc06                	sd	ra,56(sp)
    80003214:	f822                	sd	s0,48(sp)
    80003216:	f426                	sd	s1,40(sp)
    80003218:	f04a                	sd	s2,32(sp)
    8000321a:	ec4e                	sd	s3,24(sp)
    8000321c:	e852                	sd	s4,16(sp)
    8000321e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003220:	04451703          	lh	a4,68(a0)
    80003224:	4785                	li	a5,1
    80003226:	00f71a63          	bne	a4,a5,8000323a <dirlookup+0x2a>
    8000322a:	892a                	mv	s2,a0
    8000322c:	89ae                	mv	s3,a1
    8000322e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003230:	457c                	lw	a5,76(a0)
    80003232:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003234:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003236:	e79d                	bnez	a5,80003264 <dirlookup+0x54>
    80003238:	a8a5                	j	800032b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	3ae50513          	addi	a0,a0,942 # 800085e8 <syscalls+0x1e8>
    80003242:	00003097          	auipc	ra,0x3
    80003246:	b7e080e7          	jalr	-1154(ra) # 80005dc0 <panic>
      panic("dirlookup read");
    8000324a:	00005517          	auipc	a0,0x5
    8000324e:	3b650513          	addi	a0,a0,950 # 80008600 <syscalls+0x200>
    80003252:	00003097          	auipc	ra,0x3
    80003256:	b6e080e7          	jalr	-1170(ra) # 80005dc0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325a:	24c1                	addiw	s1,s1,16
    8000325c:	04c92783          	lw	a5,76(s2)
    80003260:	04f4f763          	bgeu	s1,a5,800032ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003264:	4741                	li	a4,16
    80003266:	86a6                	mv	a3,s1
    80003268:	fc040613          	addi	a2,s0,-64
    8000326c:	4581                	li	a1,0
    8000326e:	854a                	mv	a0,s2
    80003270:	00000097          	auipc	ra,0x0
    80003274:	d70080e7          	jalr	-656(ra) # 80002fe0 <readi>
    80003278:	47c1                	li	a5,16
    8000327a:	fcf518e3          	bne	a0,a5,8000324a <dirlookup+0x3a>
    if(de.inum == 0)
    8000327e:	fc045783          	lhu	a5,-64(s0)
    80003282:	dfe1                	beqz	a5,8000325a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003284:	fc240593          	addi	a1,s0,-62
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	f6c080e7          	jalr	-148(ra) # 800031f6 <namecmp>
    80003292:	f561                	bnez	a0,8000325a <dirlookup+0x4a>
      if(poff)
    80003294:	000a0463          	beqz	s4,8000329c <dirlookup+0x8c>
        *poff = off;
    80003298:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000329c:	fc045583          	lhu	a1,-64(s0)
    800032a0:	00092503          	lw	a0,0(s2)
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	752080e7          	jalr	1874(ra) # 800029f6 <iget>
    800032ac:	a011                	j	800032b0 <dirlookup+0xa0>
  return 0;
    800032ae:	4501                	li	a0,0
}
    800032b0:	70e2                	ld	ra,56(sp)
    800032b2:	7442                	ld	s0,48(sp)
    800032b4:	74a2                	ld	s1,40(sp)
    800032b6:	7902                	ld	s2,32(sp)
    800032b8:	69e2                	ld	s3,24(sp)
    800032ba:	6a42                	ld	s4,16(sp)
    800032bc:	6121                	addi	sp,sp,64
    800032be:	8082                	ret

00000000800032c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032c0:	711d                	addi	sp,sp,-96
    800032c2:	ec86                	sd	ra,88(sp)
    800032c4:	e8a2                	sd	s0,80(sp)
    800032c6:	e4a6                	sd	s1,72(sp)
    800032c8:	e0ca                	sd	s2,64(sp)
    800032ca:	fc4e                	sd	s3,56(sp)
    800032cc:	f852                	sd	s4,48(sp)
    800032ce:	f456                	sd	s5,40(sp)
    800032d0:	f05a                	sd	s6,32(sp)
    800032d2:	ec5e                	sd	s7,24(sp)
    800032d4:	e862                	sd	s8,16(sp)
    800032d6:	e466                	sd	s9,8(sp)
    800032d8:	e06a                	sd	s10,0(sp)
    800032da:	1080                	addi	s0,sp,96
    800032dc:	84aa                	mv	s1,a0
    800032de:	8b2e                	mv	s6,a1
    800032e0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032e2:	00054703          	lbu	a4,0(a0)
    800032e6:	02f00793          	li	a5,47
    800032ea:	02f70363          	beq	a4,a5,80003310 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ee:	ffffe097          	auipc	ra,0xffffe
    800032f2:	c54080e7          	jalr	-940(ra) # 80000f42 <myproc>
    800032f6:	15053503          	ld	a0,336(a0)
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	9f4080e7          	jalr	-1548(ra) # 80002cee <idup>
    80003302:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003304:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003308:	4cb5                	li	s9,13
  len = path - s;
    8000330a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000330c:	4c05                	li	s8,1
    8000330e:	a87d                	j	800033cc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003310:	4585                	li	a1,1
    80003312:	4505                	li	a0,1
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	6e2080e7          	jalr	1762(ra) # 800029f6 <iget>
    8000331c:	8a2a                	mv	s4,a0
    8000331e:	b7dd                	j	80003304 <namex+0x44>
      iunlockput(ip);
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c6c080e7          	jalr	-916(ra) # 80002f8e <iunlockput>
      return 0;
    8000332a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000332c:	8552                	mv	a0,s4
    8000332e:	60e6                	ld	ra,88(sp)
    80003330:	6446                	ld	s0,80(sp)
    80003332:	64a6                	ld	s1,72(sp)
    80003334:	6906                	ld	s2,64(sp)
    80003336:	79e2                	ld	s3,56(sp)
    80003338:	7a42                	ld	s4,48(sp)
    8000333a:	7aa2                	ld	s5,40(sp)
    8000333c:	7b02                	ld	s6,32(sp)
    8000333e:	6be2                	ld	s7,24(sp)
    80003340:	6c42                	ld	s8,16(sp)
    80003342:	6ca2                	ld	s9,8(sp)
    80003344:	6d02                	ld	s10,0(sp)
    80003346:	6125                	addi	sp,sp,96
    80003348:	8082                	ret
      iunlock(ip);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	aa2080e7          	jalr	-1374(ra) # 80002dee <iunlock>
      return ip;
    80003354:	bfe1                	j	8000332c <namex+0x6c>
      iunlockput(ip);
    80003356:	8552                	mv	a0,s4
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	c36080e7          	jalr	-970(ra) # 80002f8e <iunlockput>
      return 0;
    80003360:	8a4e                	mv	s4,s3
    80003362:	b7e9                	j	8000332c <namex+0x6c>
  len = path - s;
    80003364:	40998633          	sub	a2,s3,s1
    80003368:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000336c:	09acd863          	bge	s9,s10,800033fc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003370:	4639                	li	a2,14
    80003372:	85a6                	mv	a1,s1
    80003374:	8556                	mv	a0,s5
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	e60080e7          	jalr	-416(ra) # 800001d6 <memmove>
    8000337e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003380:	0004c783          	lbu	a5,0(s1)
    80003384:	01279763          	bne	a5,s2,80003392 <namex+0xd2>
    path++;
    80003388:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000338a:	0004c783          	lbu	a5,0(s1)
    8000338e:	ff278de3          	beq	a5,s2,80003388 <namex+0xc8>
    ilock(ip);
    80003392:	8552                	mv	a0,s4
    80003394:	00000097          	auipc	ra,0x0
    80003398:	998080e7          	jalr	-1640(ra) # 80002d2c <ilock>
    if(ip->type != T_DIR){
    8000339c:	044a1783          	lh	a5,68(s4)
    800033a0:	f98790e3          	bne	a5,s8,80003320 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033a4:	000b0563          	beqz	s6,800033ae <namex+0xee>
    800033a8:	0004c783          	lbu	a5,0(s1)
    800033ac:	dfd9                	beqz	a5,8000334a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033ae:	865e                	mv	a2,s7
    800033b0:	85d6                	mv	a1,s5
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	e5c080e7          	jalr	-420(ra) # 80003210 <dirlookup>
    800033bc:	89aa                	mv	s3,a0
    800033be:	dd41                	beqz	a0,80003356 <namex+0x96>
    iunlockput(ip);
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	bcc080e7          	jalr	-1076(ra) # 80002f8e <iunlockput>
    ip = next;
    800033ca:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033cc:	0004c783          	lbu	a5,0(s1)
    800033d0:	01279763          	bne	a5,s2,800033de <namex+0x11e>
    path++;
    800033d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	ff278de3          	beq	a5,s2,800033d4 <namex+0x114>
  if(*path == 0)
    800033de:	cb9d                	beqz	a5,80003414 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	89a6                	mv	s3,s1
  len = path - s;
    800033e6:	8d5e                	mv	s10,s7
    800033e8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ea:	01278963          	beq	a5,s2,800033fc <namex+0x13c>
    800033ee:	dbbd                	beqz	a5,80003364 <namex+0xa4>
    path++;
    800033f0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033f2:	0009c783          	lbu	a5,0(s3)
    800033f6:	ff279ce3          	bne	a5,s2,800033ee <namex+0x12e>
    800033fa:	b7ad                	j	80003364 <namex+0xa4>
    memmove(name, s, len);
    800033fc:	2601                	sext.w	a2,a2
    800033fe:	85a6                	mv	a1,s1
    80003400:	8556                	mv	a0,s5
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	dd4080e7          	jalr	-556(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000340a:	9d56                	add	s10,s10,s5
    8000340c:	000d0023          	sb	zero,0(s10)
    80003410:	84ce                	mv	s1,s3
    80003412:	b7bd                	j	80003380 <namex+0xc0>
  if(nameiparent){
    80003414:	f00b0ce3          	beqz	s6,8000332c <namex+0x6c>
    iput(ip);
    80003418:	8552                	mv	a0,s4
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	acc080e7          	jalr	-1332(ra) # 80002ee6 <iput>
    return 0;
    80003422:	4a01                	li	s4,0
    80003424:	b721                	j	8000332c <namex+0x6c>

0000000080003426 <dirlink>:
{
    80003426:	7139                	addi	sp,sp,-64
    80003428:	fc06                	sd	ra,56(sp)
    8000342a:	f822                	sd	s0,48(sp)
    8000342c:	f426                	sd	s1,40(sp)
    8000342e:	f04a                	sd	s2,32(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    80003432:	e852                	sd	s4,16(sp)
    80003434:	0080                	addi	s0,sp,64
    80003436:	892a                	mv	s2,a0
    80003438:	8a2e                	mv	s4,a1
    8000343a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000343c:	4601                	li	a2,0
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	dd2080e7          	jalr	-558(ra) # 80003210 <dirlookup>
    80003446:	e93d                	bnez	a0,800034bc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003448:	04c92483          	lw	s1,76(s2)
    8000344c:	c49d                	beqz	s1,8000347a <dirlink+0x54>
    8000344e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	4741                	li	a4,16
    80003452:	86a6                	mv	a3,s1
    80003454:	fc040613          	addi	a2,s0,-64
    80003458:	4581                	li	a1,0
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	b84080e7          	jalr	-1148(ra) # 80002fe0 <readi>
    80003464:	47c1                	li	a5,16
    80003466:	06f51163          	bne	a0,a5,800034c8 <dirlink+0xa2>
    if(de.inum == 0)
    8000346a:	fc045783          	lhu	a5,-64(s0)
    8000346e:	c791                	beqz	a5,8000347a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003470:	24c1                	addiw	s1,s1,16
    80003472:	04c92783          	lw	a5,76(s2)
    80003476:	fcf4ede3          	bltu	s1,a5,80003450 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000347a:	4639                	li	a2,14
    8000347c:	85d2                	mv	a1,s4
    8000347e:	fc240513          	addi	a0,s0,-62
    80003482:	ffffd097          	auipc	ra,0xffffd
    80003486:	e04080e7          	jalr	-508(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000348a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348e:	4741                	li	a4,16
    80003490:	86a6                	mv	a3,s1
    80003492:	fc040613          	addi	a2,s0,-64
    80003496:	4581                	li	a1,0
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	c3e080e7          	jalr	-962(ra) # 800030d8 <writei>
    800034a2:	872a                	mv	a4,a0
    800034a4:	47c1                	li	a5,16
  return 0;
    800034a6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034a8:	02f71863          	bne	a4,a5,800034d8 <dirlink+0xb2>
}
    800034ac:	70e2                	ld	ra,56(sp)
    800034ae:	7442                	ld	s0,48(sp)
    800034b0:	74a2                	ld	s1,40(sp)
    800034b2:	7902                	ld	s2,32(sp)
    800034b4:	69e2                	ld	s3,24(sp)
    800034b6:	6a42                	ld	s4,16(sp)
    800034b8:	6121                	addi	sp,sp,64
    800034ba:	8082                	ret
    iput(ip);
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	a2a080e7          	jalr	-1494(ra) # 80002ee6 <iput>
    return -1;
    800034c4:	557d                	li	a0,-1
    800034c6:	b7dd                	j	800034ac <dirlink+0x86>
      panic("dirlink read");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	14850513          	addi	a0,a0,328 # 80008610 <syscalls+0x210>
    800034d0:	00003097          	auipc	ra,0x3
    800034d4:	8f0080e7          	jalr	-1808(ra) # 80005dc0 <panic>
    panic("dirlink");
    800034d8:	00005517          	auipc	a0,0x5
    800034dc:	24050513          	addi	a0,a0,576 # 80008718 <syscalls+0x318>
    800034e0:	00003097          	auipc	ra,0x3
    800034e4:	8e0080e7          	jalr	-1824(ra) # 80005dc0 <panic>

00000000800034e8 <namei>:

struct inode*
namei(char *path)
{
    800034e8:	1101                	addi	sp,sp,-32
    800034ea:	ec06                	sd	ra,24(sp)
    800034ec:	e822                	sd	s0,16(sp)
    800034ee:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034f0:	fe040613          	addi	a2,s0,-32
    800034f4:	4581                	li	a1,0
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	dca080e7          	jalr	-566(ra) # 800032c0 <namex>
}
    800034fe:	60e2                	ld	ra,24(sp)
    80003500:	6442                	ld	s0,16(sp)
    80003502:	6105                	addi	sp,sp,32
    80003504:	8082                	ret

0000000080003506 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003506:	1141                	addi	sp,sp,-16
    80003508:	e406                	sd	ra,8(sp)
    8000350a:	e022                	sd	s0,0(sp)
    8000350c:	0800                	addi	s0,sp,16
    8000350e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003510:	4585                	li	a1,1
    80003512:	00000097          	auipc	ra,0x0
    80003516:	dae080e7          	jalr	-594(ra) # 800032c0 <namex>
}
    8000351a:	60a2                	ld	ra,8(sp)
    8000351c:	6402                	ld	s0,0(sp)
    8000351e:	0141                	addi	sp,sp,16
    80003520:	8082                	ret

0000000080003522 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003522:	1101                	addi	sp,sp,-32
    80003524:	ec06                	sd	ra,24(sp)
    80003526:	e822                	sd	s0,16(sp)
    80003528:	e426                	sd	s1,8(sp)
    8000352a:	e04a                	sd	s2,0(sp)
    8000352c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000352e:	00016917          	auipc	s2,0x16
    80003532:	cf290913          	addi	s2,s2,-782 # 80019220 <log>
    80003536:	01892583          	lw	a1,24(s2)
    8000353a:	02892503          	lw	a0,40(s2)
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	fec080e7          	jalr	-20(ra) # 8000252a <bread>
    80003546:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003548:	02c92683          	lw	a3,44(s2)
    8000354c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000354e:	02d05863          	blez	a3,8000357e <write_head+0x5c>
    80003552:	00016797          	auipc	a5,0x16
    80003556:	cfe78793          	addi	a5,a5,-770 # 80019250 <log+0x30>
    8000355a:	05c50713          	addi	a4,a0,92
    8000355e:	36fd                	addiw	a3,a3,-1
    80003560:	02069613          	slli	a2,a3,0x20
    80003564:	01e65693          	srli	a3,a2,0x1e
    80003568:	00016617          	auipc	a2,0x16
    8000356c:	cec60613          	addi	a2,a2,-788 # 80019254 <log+0x34>
    80003570:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003572:	4390                	lw	a2,0(a5)
    80003574:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003576:	0791                	addi	a5,a5,4
    80003578:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000357a:	fed79ce3          	bne	a5,a3,80003572 <write_head+0x50>
  }
  bwrite(buf);
    8000357e:	8526                	mv	a0,s1
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	09c080e7          	jalr	156(ra) # 8000261c <bwrite>
  brelse(buf);
    80003588:	8526                	mv	a0,s1
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	0d0080e7          	jalr	208(ra) # 8000265a <brelse>
}
    80003592:	60e2                	ld	ra,24(sp)
    80003594:	6442                	ld	s0,16(sp)
    80003596:	64a2                	ld	s1,8(sp)
    80003598:	6902                	ld	s2,0(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000359e:	00016797          	auipc	a5,0x16
    800035a2:	cae7a783          	lw	a5,-850(a5) # 8001924c <log+0x2c>
    800035a6:	0af05d63          	blez	a5,80003660 <install_trans+0xc2>
{
    800035aa:	7139                	addi	sp,sp,-64
    800035ac:	fc06                	sd	ra,56(sp)
    800035ae:	f822                	sd	s0,48(sp)
    800035b0:	f426                	sd	s1,40(sp)
    800035b2:	f04a                	sd	s2,32(sp)
    800035b4:	ec4e                	sd	s3,24(sp)
    800035b6:	e852                	sd	s4,16(sp)
    800035b8:	e456                	sd	s5,8(sp)
    800035ba:	e05a                	sd	s6,0(sp)
    800035bc:	0080                	addi	s0,sp,64
    800035be:	8b2a                	mv	s6,a0
    800035c0:	00016a97          	auipc	s5,0x16
    800035c4:	c90a8a93          	addi	s5,s5,-880 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035ca:	00016997          	auipc	s3,0x16
    800035ce:	c5698993          	addi	s3,s3,-938 # 80019220 <log>
    800035d2:	a00d                	j	800035f4 <install_trans+0x56>
    brelse(lbuf);
    800035d4:	854a                	mv	a0,s2
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	084080e7          	jalr	132(ra) # 8000265a <brelse>
    brelse(dbuf);
    800035de:	8526                	mv	a0,s1
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	07a080e7          	jalr	122(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e8:	2a05                	addiw	s4,s4,1
    800035ea:	0a91                	addi	s5,s5,4
    800035ec:	02c9a783          	lw	a5,44(s3)
    800035f0:	04fa5e63          	bge	s4,a5,8000364c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f4:	0189a583          	lw	a1,24(s3)
    800035f8:	014585bb          	addw	a1,a1,s4
    800035fc:	2585                	addiw	a1,a1,1
    800035fe:	0289a503          	lw	a0,40(s3)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	f28080e7          	jalr	-216(ra) # 8000252a <bread>
    8000360a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000360c:	000aa583          	lw	a1,0(s5)
    80003610:	0289a503          	lw	a0,40(s3)
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	f16080e7          	jalr	-234(ra) # 8000252a <bread>
    8000361c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000361e:	40000613          	li	a2,1024
    80003622:	05890593          	addi	a1,s2,88
    80003626:	05850513          	addi	a0,a0,88
    8000362a:	ffffd097          	auipc	ra,0xffffd
    8000362e:	bac080e7          	jalr	-1108(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	fe8080e7          	jalr	-24(ra) # 8000261c <bwrite>
    if(recovering == 0)
    8000363c:	f80b1ce3          	bnez	s6,800035d4 <install_trans+0x36>
      bunpin(dbuf);
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	0f2080e7          	jalr	242(ra) # 80002734 <bunpin>
    8000364a:	b769                	j	800035d4 <install_trans+0x36>
}
    8000364c:	70e2                	ld	ra,56(sp)
    8000364e:	7442                	ld	s0,48(sp)
    80003650:	74a2                	ld	s1,40(sp)
    80003652:	7902                	ld	s2,32(sp)
    80003654:	69e2                	ld	s3,24(sp)
    80003656:	6a42                	ld	s4,16(sp)
    80003658:	6aa2                	ld	s5,8(sp)
    8000365a:	6b02                	ld	s6,0(sp)
    8000365c:	6121                	addi	sp,sp,64
    8000365e:	8082                	ret
    80003660:	8082                	ret

0000000080003662 <initlog>:
{
    80003662:	7179                	addi	sp,sp,-48
    80003664:	f406                	sd	ra,40(sp)
    80003666:	f022                	sd	s0,32(sp)
    80003668:	ec26                	sd	s1,24(sp)
    8000366a:	e84a                	sd	s2,16(sp)
    8000366c:	e44e                	sd	s3,8(sp)
    8000366e:	1800                	addi	s0,sp,48
    80003670:	892a                	mv	s2,a0
    80003672:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003674:	00016497          	auipc	s1,0x16
    80003678:	bac48493          	addi	s1,s1,-1108 # 80019220 <log>
    8000367c:	00005597          	auipc	a1,0x5
    80003680:	fa458593          	addi	a1,a1,-92 # 80008620 <syscalls+0x220>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	be2080e7          	jalr	-1054(ra) # 80006268 <initlock>
  log.start = sb->logstart;
    8000368e:	0149a583          	lw	a1,20(s3)
    80003692:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003694:	0109a783          	lw	a5,16(s3)
    80003698:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000369a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000369e:	854a                	mv	a0,s2
    800036a0:	fffff097          	auipc	ra,0xfffff
    800036a4:	e8a080e7          	jalr	-374(ra) # 8000252a <bread>
  log.lh.n = lh->n;
    800036a8:	4d34                	lw	a3,88(a0)
    800036aa:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036ac:	02d05663          	blez	a3,800036d8 <initlog+0x76>
    800036b0:	05c50793          	addi	a5,a0,92
    800036b4:	00016717          	auipc	a4,0x16
    800036b8:	b9c70713          	addi	a4,a4,-1124 # 80019250 <log+0x30>
    800036bc:	36fd                	addiw	a3,a3,-1
    800036be:	02069613          	slli	a2,a3,0x20
    800036c2:	01e65693          	srli	a3,a2,0x1e
    800036c6:	06050613          	addi	a2,a0,96
    800036ca:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036cc:	4390                	lw	a2,0(a5)
    800036ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036d0:	0791                	addi	a5,a5,4
    800036d2:	0711                	addi	a4,a4,4
    800036d4:	fed79ce3          	bne	a5,a3,800036cc <initlog+0x6a>
  brelse(buf);
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	f82080e7          	jalr	-126(ra) # 8000265a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036e0:	4505                	li	a0,1
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	ebc080e7          	jalr	-324(ra) # 8000359e <install_trans>
  log.lh.n = 0;
    800036ea:	00016797          	auipc	a5,0x16
    800036ee:	b607a123          	sw	zero,-1182(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	e30080e7          	jalr	-464(ra) # 80003522 <write_head>
}
    800036fa:	70a2                	ld	ra,40(sp)
    800036fc:	7402                	ld	s0,32(sp)
    800036fe:	64e2                	ld	s1,24(sp)
    80003700:	6942                	ld	s2,16(sp)
    80003702:	69a2                	ld	s3,8(sp)
    80003704:	6145                	addi	sp,sp,48
    80003706:	8082                	ret

0000000080003708 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003708:	1101                	addi	sp,sp,-32
    8000370a:	ec06                	sd	ra,24(sp)
    8000370c:	e822                	sd	s0,16(sp)
    8000370e:	e426                	sd	s1,8(sp)
    80003710:	e04a                	sd	s2,0(sp)
    80003712:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003714:	00016517          	auipc	a0,0x16
    80003718:	b0c50513          	addi	a0,a0,-1268 # 80019220 <log>
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	bdc080e7          	jalr	-1060(ra) # 800062f8 <acquire>
  while(1){
    if(log.committing){
    80003724:	00016497          	auipc	s1,0x16
    80003728:	afc48493          	addi	s1,s1,-1284 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000372c:	4979                	li	s2,30
    8000372e:	a039                	j	8000373c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003730:	85a6                	mv	a1,s1
    80003732:	8526                	mv	a0,s1
    80003734:	ffffe097          	auipc	ra,0xffffe
    80003738:	f8c080e7          	jalr	-116(ra) # 800016c0 <sleep>
    if(log.committing){
    8000373c:	50dc                	lw	a5,36(s1)
    8000373e:	fbed                	bnez	a5,80003730 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003740:	5098                	lw	a4,32(s1)
    80003742:	2705                	addiw	a4,a4,1
    80003744:	0007069b          	sext.w	a3,a4
    80003748:	0027179b          	slliw	a5,a4,0x2
    8000374c:	9fb9                	addw	a5,a5,a4
    8000374e:	0017979b          	slliw	a5,a5,0x1
    80003752:	54d8                	lw	a4,44(s1)
    80003754:	9fb9                	addw	a5,a5,a4
    80003756:	00f95963          	bge	s2,a5,80003768 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000375a:	85a6                	mv	a1,s1
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	f62080e7          	jalr	-158(ra) # 800016c0 <sleep>
    80003766:	bfd9                	j	8000373c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003768:	00016517          	auipc	a0,0x16
    8000376c:	ab850513          	addi	a0,a0,-1352 # 80019220 <log>
    80003770:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003772:	00003097          	auipc	ra,0x3
    80003776:	c3a080e7          	jalr	-966(ra) # 800063ac <release>
      break;
    }
  }
}
    8000377a:	60e2                	ld	ra,24(sp)
    8000377c:	6442                	ld	s0,16(sp)
    8000377e:	64a2                	ld	s1,8(sp)
    80003780:	6902                	ld	s2,0(sp)
    80003782:	6105                	addi	sp,sp,32
    80003784:	8082                	ret

0000000080003786 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003786:	7139                	addi	sp,sp,-64
    80003788:	fc06                	sd	ra,56(sp)
    8000378a:	f822                	sd	s0,48(sp)
    8000378c:	f426                	sd	s1,40(sp)
    8000378e:	f04a                	sd	s2,32(sp)
    80003790:	ec4e                	sd	s3,24(sp)
    80003792:	e852                	sd	s4,16(sp)
    80003794:	e456                	sd	s5,8(sp)
    80003796:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003798:	00016497          	auipc	s1,0x16
    8000379c:	a8848493          	addi	s1,s1,-1400 # 80019220 <log>
    800037a0:	8526                	mv	a0,s1
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	b56080e7          	jalr	-1194(ra) # 800062f8 <acquire>
  log.outstanding -= 1;
    800037aa:	509c                	lw	a5,32(s1)
    800037ac:	37fd                	addiw	a5,a5,-1
    800037ae:	0007891b          	sext.w	s2,a5
    800037b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037b4:	50dc                	lw	a5,36(s1)
    800037b6:	e7b9                	bnez	a5,80003804 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037b8:	04091e63          	bnez	s2,80003814 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037bc:	00016497          	auipc	s1,0x16
    800037c0:	a6448493          	addi	s1,s1,-1436 # 80019220 <log>
    800037c4:	4785                	li	a5,1
    800037c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037c8:	8526                	mv	a0,s1
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	be2080e7          	jalr	-1054(ra) # 800063ac <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037d2:	54dc                	lw	a5,44(s1)
    800037d4:	06f04763          	bgtz	a5,80003842 <end_op+0xbc>
    acquire(&log.lock);
    800037d8:	00016497          	auipc	s1,0x16
    800037dc:	a4848493          	addi	s1,s1,-1464 # 80019220 <log>
    800037e0:	8526                	mv	a0,s1
    800037e2:	00003097          	auipc	ra,0x3
    800037e6:	b16080e7          	jalr	-1258(ra) # 800062f8 <acquire>
    log.committing = 0;
    800037ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ee:	8526                	mv	a0,s1
    800037f0:	ffffe097          	auipc	ra,0xffffe
    800037f4:	05c080e7          	jalr	92(ra) # 8000184c <wakeup>
    release(&log.lock);
    800037f8:	8526                	mv	a0,s1
    800037fa:	00003097          	auipc	ra,0x3
    800037fe:	bb2080e7          	jalr	-1102(ra) # 800063ac <release>
}
    80003802:	a03d                	j	80003830 <end_op+0xaa>
    panic("log.committing");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	e2450513          	addi	a0,a0,-476 # 80008628 <syscalls+0x228>
    8000380c:	00002097          	auipc	ra,0x2
    80003810:	5b4080e7          	jalr	1460(ra) # 80005dc0 <panic>
    wakeup(&log);
    80003814:	00016497          	auipc	s1,0x16
    80003818:	a0c48493          	addi	s1,s1,-1524 # 80019220 <log>
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	02e080e7          	jalr	46(ra) # 8000184c <wakeup>
  release(&log.lock);
    80003826:	8526                	mv	a0,s1
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	b84080e7          	jalr	-1148(ra) # 800063ac <release>
}
    80003830:	70e2                	ld	ra,56(sp)
    80003832:	7442                	ld	s0,48(sp)
    80003834:	74a2                	ld	s1,40(sp)
    80003836:	7902                	ld	s2,32(sp)
    80003838:	69e2                	ld	s3,24(sp)
    8000383a:	6a42                	ld	s4,16(sp)
    8000383c:	6aa2                	ld	s5,8(sp)
    8000383e:	6121                	addi	sp,sp,64
    80003840:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003842:	00016a97          	auipc	s5,0x16
    80003846:	a0ea8a93          	addi	s5,s5,-1522 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000384a:	00016a17          	auipc	s4,0x16
    8000384e:	9d6a0a13          	addi	s4,s4,-1578 # 80019220 <log>
    80003852:	018a2583          	lw	a1,24(s4)
    80003856:	012585bb          	addw	a1,a1,s2
    8000385a:	2585                	addiw	a1,a1,1
    8000385c:	028a2503          	lw	a0,40(s4)
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	cca080e7          	jalr	-822(ra) # 8000252a <bread>
    80003868:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000386a:	000aa583          	lw	a1,0(s5)
    8000386e:	028a2503          	lw	a0,40(s4)
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	cb8080e7          	jalr	-840(ra) # 8000252a <bread>
    8000387a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000387c:	40000613          	li	a2,1024
    80003880:	05850593          	addi	a1,a0,88
    80003884:	05848513          	addi	a0,s1,88
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	94e080e7          	jalr	-1714(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003890:	8526                	mv	a0,s1
    80003892:	fffff097          	auipc	ra,0xfffff
    80003896:	d8a080e7          	jalr	-630(ra) # 8000261c <bwrite>
    brelse(from);
    8000389a:	854e                	mv	a0,s3
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	dbe080e7          	jalr	-578(ra) # 8000265a <brelse>
    brelse(to);
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	db4080e7          	jalr	-588(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ae:	2905                	addiw	s2,s2,1
    800038b0:	0a91                	addi	s5,s5,4
    800038b2:	02ca2783          	lw	a5,44(s4)
    800038b6:	f8f94ee3          	blt	s2,a5,80003852 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ba:	00000097          	auipc	ra,0x0
    800038be:	c68080e7          	jalr	-920(ra) # 80003522 <write_head>
    install_trans(0); // Now install writes to home locations
    800038c2:	4501                	li	a0,0
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	cda080e7          	jalr	-806(ra) # 8000359e <install_trans>
    log.lh.n = 0;
    800038cc:	00016797          	auipc	a5,0x16
    800038d0:	9807a023          	sw	zero,-1664(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	c4e080e7          	jalr	-946(ra) # 80003522 <write_head>
    800038dc:	bdf5                	j	800037d8 <end_op+0x52>

00000000800038de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038de:	1101                	addi	sp,sp,-32
    800038e0:	ec06                	sd	ra,24(sp)
    800038e2:	e822                	sd	s0,16(sp)
    800038e4:	e426                	sd	s1,8(sp)
    800038e6:	e04a                	sd	s2,0(sp)
    800038e8:	1000                	addi	s0,sp,32
    800038ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038ec:	00016917          	auipc	s2,0x16
    800038f0:	93490913          	addi	s2,s2,-1740 # 80019220 <log>
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	a02080e7          	jalr	-1534(ra) # 800062f8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038fe:	02c92603          	lw	a2,44(s2)
    80003902:	47f5                	li	a5,29
    80003904:	06c7c563          	blt	a5,a2,8000396e <log_write+0x90>
    80003908:	00016797          	auipc	a5,0x16
    8000390c:	9347a783          	lw	a5,-1740(a5) # 8001923c <log+0x1c>
    80003910:	37fd                	addiw	a5,a5,-1
    80003912:	04f65e63          	bge	a2,a5,8000396e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003916:	00016797          	auipc	a5,0x16
    8000391a:	92a7a783          	lw	a5,-1750(a5) # 80019240 <log+0x20>
    8000391e:	06f05063          	blez	a5,8000397e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003922:	4781                	li	a5,0
    80003924:	06c05563          	blez	a2,8000398e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003928:	44cc                	lw	a1,12(s1)
    8000392a:	00016717          	auipc	a4,0x16
    8000392e:	92670713          	addi	a4,a4,-1754 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003932:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003934:	4314                	lw	a3,0(a4)
    80003936:	04b68c63          	beq	a3,a1,8000398e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000393a:	2785                	addiw	a5,a5,1
    8000393c:	0711                	addi	a4,a4,4
    8000393e:	fef61be3          	bne	a2,a5,80003934 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003942:	0621                	addi	a2,a2,8
    80003944:	060a                	slli	a2,a2,0x2
    80003946:	00016797          	auipc	a5,0x16
    8000394a:	8da78793          	addi	a5,a5,-1830 # 80019220 <log>
    8000394e:	97b2                	add	a5,a5,a2
    80003950:	44d8                	lw	a4,12(s1)
    80003952:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003954:	8526                	mv	a0,s1
    80003956:	fffff097          	auipc	ra,0xfffff
    8000395a:	da2080e7          	jalr	-606(ra) # 800026f8 <bpin>
    log.lh.n++;
    8000395e:	00016717          	auipc	a4,0x16
    80003962:	8c270713          	addi	a4,a4,-1854 # 80019220 <log>
    80003966:	575c                	lw	a5,44(a4)
    80003968:	2785                	addiw	a5,a5,1
    8000396a:	d75c                	sw	a5,44(a4)
    8000396c:	a82d                	j	800039a6 <log_write+0xc8>
    panic("too big a transaction");
    8000396e:	00005517          	auipc	a0,0x5
    80003972:	cca50513          	addi	a0,a0,-822 # 80008638 <syscalls+0x238>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	44a080e7          	jalr	1098(ra) # 80005dc0 <panic>
    panic("log_write outside of trans");
    8000397e:	00005517          	auipc	a0,0x5
    80003982:	cd250513          	addi	a0,a0,-814 # 80008650 <syscalls+0x250>
    80003986:	00002097          	auipc	ra,0x2
    8000398a:	43a080e7          	jalr	1082(ra) # 80005dc0 <panic>
  log.lh.block[i] = b->blockno;
    8000398e:	00878693          	addi	a3,a5,8
    80003992:	068a                	slli	a3,a3,0x2
    80003994:	00016717          	auipc	a4,0x16
    80003998:	88c70713          	addi	a4,a4,-1908 # 80019220 <log>
    8000399c:	9736                	add	a4,a4,a3
    8000399e:	44d4                	lw	a3,12(s1)
    800039a0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039a2:	faf609e3          	beq	a2,a5,80003954 <log_write+0x76>
  }
  release(&log.lock);
    800039a6:	00016517          	auipc	a0,0x16
    800039aa:	87a50513          	addi	a0,a0,-1926 # 80019220 <log>
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	9fe080e7          	jalr	-1538(ra) # 800063ac <release>
}
    800039b6:	60e2                	ld	ra,24(sp)
    800039b8:	6442                	ld	s0,16(sp)
    800039ba:	64a2                	ld	s1,8(sp)
    800039bc:	6902                	ld	s2,0(sp)
    800039be:	6105                	addi	sp,sp,32
    800039c0:	8082                	ret

00000000800039c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039c2:	1101                	addi	sp,sp,-32
    800039c4:	ec06                	sd	ra,24(sp)
    800039c6:	e822                	sd	s0,16(sp)
    800039c8:	e426                	sd	s1,8(sp)
    800039ca:	e04a                	sd	s2,0(sp)
    800039cc:	1000                	addi	s0,sp,32
    800039ce:	84aa                	mv	s1,a0
    800039d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039d2:	00005597          	auipc	a1,0x5
    800039d6:	c9e58593          	addi	a1,a1,-866 # 80008670 <syscalls+0x270>
    800039da:	0521                	addi	a0,a0,8
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	88c080e7          	jalr	-1908(ra) # 80006268 <initlock>
  lk->name = name;
    800039e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ec:	0204a423          	sw	zero,40(s1)
}
    800039f0:	60e2                	ld	ra,24(sp)
    800039f2:	6442                	ld	s0,16(sp)
    800039f4:	64a2                	ld	s1,8(sp)
    800039f6:	6902                	ld	s2,0(sp)
    800039f8:	6105                	addi	sp,sp,32
    800039fa:	8082                	ret

00000000800039fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039fc:	1101                	addi	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	e04a                	sd	s2,0(sp)
    80003a06:	1000                	addi	s0,sp,32
    80003a08:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a0a:	00850913          	addi	s2,a0,8
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	8e8080e7          	jalr	-1816(ra) # 800062f8 <acquire>
  while (lk->locked) {
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	cb89                	beqz	a5,80003a2c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a1c:	85ca                	mv	a1,s2
    80003a1e:	8526                	mv	a0,s1
    80003a20:	ffffe097          	auipc	ra,0xffffe
    80003a24:	ca0080e7          	jalr	-864(ra) # 800016c0 <sleep>
  while (lk->locked) {
    80003a28:	409c                	lw	a5,0(s1)
    80003a2a:	fbed                	bnez	a5,80003a1c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a2c:	4785                	li	a5,1
    80003a2e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a30:	ffffd097          	auipc	ra,0xffffd
    80003a34:	512080e7          	jalr	1298(ra) # 80000f42 <myproc>
    80003a38:	591c                	lw	a5,48(a0)
    80003a3a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	96e080e7          	jalr	-1682(ra) # 800063ac <release>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6902                	ld	s2,0(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a52:	1101                	addi	sp,sp,-32
    80003a54:	ec06                	sd	ra,24(sp)
    80003a56:	e822                	sd	s0,16(sp)
    80003a58:	e426                	sd	s1,8(sp)
    80003a5a:	e04a                	sd	s2,0(sp)
    80003a5c:	1000                	addi	s0,sp,32
    80003a5e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a60:	00850913          	addi	s2,a0,8
    80003a64:	854a                	mv	a0,s2
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	892080e7          	jalr	-1902(ra) # 800062f8 <acquire>
  lk->locked = 0;
    80003a6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a72:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a76:	8526                	mv	a0,s1
    80003a78:	ffffe097          	auipc	ra,0xffffe
    80003a7c:	dd4080e7          	jalr	-556(ra) # 8000184c <wakeup>
  release(&lk->lk);
    80003a80:	854a                	mv	a0,s2
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	92a080e7          	jalr	-1750(ra) # 800063ac <release>
}
    80003a8a:	60e2                	ld	ra,24(sp)
    80003a8c:	6442                	ld	s0,16(sp)
    80003a8e:	64a2                	ld	s1,8(sp)
    80003a90:	6902                	ld	s2,0(sp)
    80003a92:	6105                	addi	sp,sp,32
    80003a94:	8082                	ret

0000000080003a96 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a96:	7179                	addi	sp,sp,-48
    80003a98:	f406                	sd	ra,40(sp)
    80003a9a:	f022                	sd	s0,32(sp)
    80003a9c:	ec26                	sd	s1,24(sp)
    80003a9e:	e84a                	sd	s2,16(sp)
    80003aa0:	e44e                	sd	s3,8(sp)
    80003aa2:	1800                	addi	s0,sp,48
    80003aa4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aa6:	00850913          	addi	s2,a0,8
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	84c080e7          	jalr	-1972(ra) # 800062f8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab4:	409c                	lw	a5,0(s1)
    80003ab6:	ef99                	bnez	a5,80003ad4 <holdingsleep+0x3e>
    80003ab8:	4481                	li	s1,0
  release(&lk->lk);
    80003aba:	854a                	mv	a0,s2
    80003abc:	00003097          	auipc	ra,0x3
    80003ac0:	8f0080e7          	jalr	-1808(ra) # 800063ac <release>
  return r;
}
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	70a2                	ld	ra,40(sp)
    80003ac8:	7402                	ld	s0,32(sp)
    80003aca:	64e2                	ld	s1,24(sp)
    80003acc:	6942                	ld	s2,16(sp)
    80003ace:	69a2                	ld	s3,8(sp)
    80003ad0:	6145                	addi	sp,sp,48
    80003ad2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ad4:	0284a983          	lw	s3,40(s1)
    80003ad8:	ffffd097          	auipc	ra,0xffffd
    80003adc:	46a080e7          	jalr	1130(ra) # 80000f42 <myproc>
    80003ae0:	5904                	lw	s1,48(a0)
    80003ae2:	413484b3          	sub	s1,s1,s3
    80003ae6:	0014b493          	seqz	s1,s1
    80003aea:	bfc1                	j	80003aba <holdingsleep+0x24>

0000000080003aec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aec:	1141                	addi	sp,sp,-16
    80003aee:	e406                	sd	ra,8(sp)
    80003af0:	e022                	sd	s0,0(sp)
    80003af2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003af4:	00005597          	auipc	a1,0x5
    80003af8:	b8c58593          	addi	a1,a1,-1140 # 80008680 <syscalls+0x280>
    80003afc:	00016517          	auipc	a0,0x16
    80003b00:	86c50513          	addi	a0,a0,-1940 # 80019368 <ftable>
    80003b04:	00002097          	auipc	ra,0x2
    80003b08:	764080e7          	jalr	1892(ra) # 80006268 <initlock>
}
    80003b0c:	60a2                	ld	ra,8(sp)
    80003b0e:	6402                	ld	s0,0(sp)
    80003b10:	0141                	addi	sp,sp,16
    80003b12:	8082                	ret

0000000080003b14 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b14:	1101                	addi	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b1e:	00016517          	auipc	a0,0x16
    80003b22:	84a50513          	addi	a0,a0,-1974 # 80019368 <ftable>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	7d2080e7          	jalr	2002(ra) # 800062f8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b2e:	00016497          	auipc	s1,0x16
    80003b32:	85248493          	addi	s1,s1,-1966 # 80019380 <ftable+0x18>
    80003b36:	00016717          	auipc	a4,0x16
    80003b3a:	7ea70713          	addi	a4,a4,2026 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b3e:	40dc                	lw	a5,4(s1)
    80003b40:	cf99                	beqz	a5,80003b5e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b42:	02848493          	addi	s1,s1,40
    80003b46:	fee49ce3          	bne	s1,a4,80003b3e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b4a:	00016517          	auipc	a0,0x16
    80003b4e:	81e50513          	addi	a0,a0,-2018 # 80019368 <ftable>
    80003b52:	00003097          	auipc	ra,0x3
    80003b56:	85a080e7          	jalr	-1958(ra) # 800063ac <release>
  return 0;
    80003b5a:	4481                	li	s1,0
    80003b5c:	a819                	j	80003b72 <filealloc+0x5e>
      f->ref = 1;
    80003b5e:	4785                	li	a5,1
    80003b60:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b62:	00016517          	auipc	a0,0x16
    80003b66:	80650513          	addi	a0,a0,-2042 # 80019368 <ftable>
    80003b6a:	00003097          	auipc	ra,0x3
    80003b6e:	842080e7          	jalr	-1982(ra) # 800063ac <release>
}
    80003b72:	8526                	mv	a0,s1
    80003b74:	60e2                	ld	ra,24(sp)
    80003b76:	6442                	ld	s0,16(sp)
    80003b78:	64a2                	ld	s1,8(sp)
    80003b7a:	6105                	addi	sp,sp,32
    80003b7c:	8082                	ret

0000000080003b7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b7e:	1101                	addi	sp,sp,-32
    80003b80:	ec06                	sd	ra,24(sp)
    80003b82:	e822                	sd	s0,16(sp)
    80003b84:	e426                	sd	s1,8(sp)
    80003b86:	1000                	addi	s0,sp,32
    80003b88:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b8a:	00015517          	auipc	a0,0x15
    80003b8e:	7de50513          	addi	a0,a0,2014 # 80019368 <ftable>
    80003b92:	00002097          	auipc	ra,0x2
    80003b96:	766080e7          	jalr	1894(ra) # 800062f8 <acquire>
  if(f->ref < 1)
    80003b9a:	40dc                	lw	a5,4(s1)
    80003b9c:	02f05263          	blez	a5,80003bc0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ba0:	2785                	addiw	a5,a5,1
    80003ba2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ba4:	00015517          	auipc	a0,0x15
    80003ba8:	7c450513          	addi	a0,a0,1988 # 80019368 <ftable>
    80003bac:	00003097          	auipc	ra,0x3
    80003bb0:	800080e7          	jalr	-2048(ra) # 800063ac <release>
  return f;
}
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	60e2                	ld	ra,24(sp)
    80003bb8:	6442                	ld	s0,16(sp)
    80003bba:	64a2                	ld	s1,8(sp)
    80003bbc:	6105                	addi	sp,sp,32
    80003bbe:	8082                	ret
    panic("filedup");
    80003bc0:	00005517          	auipc	a0,0x5
    80003bc4:	ac850513          	addi	a0,a0,-1336 # 80008688 <syscalls+0x288>
    80003bc8:	00002097          	auipc	ra,0x2
    80003bcc:	1f8080e7          	jalr	504(ra) # 80005dc0 <panic>

0000000080003bd0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bd0:	7139                	addi	sp,sp,-64
    80003bd2:	fc06                	sd	ra,56(sp)
    80003bd4:	f822                	sd	s0,48(sp)
    80003bd6:	f426                	sd	s1,40(sp)
    80003bd8:	f04a                	sd	s2,32(sp)
    80003bda:	ec4e                	sd	s3,24(sp)
    80003bdc:	e852                	sd	s4,16(sp)
    80003bde:	e456                	sd	s5,8(sp)
    80003be0:	0080                	addi	s0,sp,64
    80003be2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003be4:	00015517          	auipc	a0,0x15
    80003be8:	78450513          	addi	a0,a0,1924 # 80019368 <ftable>
    80003bec:	00002097          	auipc	ra,0x2
    80003bf0:	70c080e7          	jalr	1804(ra) # 800062f8 <acquire>
  if(f->ref < 1)
    80003bf4:	40dc                	lw	a5,4(s1)
    80003bf6:	06f05163          	blez	a5,80003c58 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bfa:	37fd                	addiw	a5,a5,-1
    80003bfc:	0007871b          	sext.w	a4,a5
    80003c00:	c0dc                	sw	a5,4(s1)
    80003c02:	06e04363          	bgtz	a4,80003c68 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c06:	0004a903          	lw	s2,0(s1)
    80003c0a:	0094ca83          	lbu	s5,9(s1)
    80003c0e:	0104ba03          	ld	s4,16(s1)
    80003c12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c1e:	00015517          	auipc	a0,0x15
    80003c22:	74a50513          	addi	a0,a0,1866 # 80019368 <ftable>
    80003c26:	00002097          	auipc	ra,0x2
    80003c2a:	786080e7          	jalr	1926(ra) # 800063ac <release>

  if(ff.type == FD_PIPE){
    80003c2e:	4785                	li	a5,1
    80003c30:	04f90d63          	beq	s2,a5,80003c8a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c34:	3979                	addiw	s2,s2,-2
    80003c36:	4785                	li	a5,1
    80003c38:	0527e063          	bltu	a5,s2,80003c78 <fileclose+0xa8>
    begin_op();
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	acc080e7          	jalr	-1332(ra) # 80003708 <begin_op>
    iput(ff.ip);
    80003c44:	854e                	mv	a0,s3
    80003c46:	fffff097          	auipc	ra,0xfffff
    80003c4a:	2a0080e7          	jalr	672(ra) # 80002ee6 <iput>
    end_op();
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	b38080e7          	jalr	-1224(ra) # 80003786 <end_op>
    80003c56:	a00d                	j	80003c78 <fileclose+0xa8>
    panic("fileclose");
    80003c58:	00005517          	auipc	a0,0x5
    80003c5c:	a3850513          	addi	a0,a0,-1480 # 80008690 <syscalls+0x290>
    80003c60:	00002097          	auipc	ra,0x2
    80003c64:	160080e7          	jalr	352(ra) # 80005dc0 <panic>
    release(&ftable.lock);
    80003c68:	00015517          	auipc	a0,0x15
    80003c6c:	70050513          	addi	a0,a0,1792 # 80019368 <ftable>
    80003c70:	00002097          	auipc	ra,0x2
    80003c74:	73c080e7          	jalr	1852(ra) # 800063ac <release>
  }
}
    80003c78:	70e2                	ld	ra,56(sp)
    80003c7a:	7442                	ld	s0,48(sp)
    80003c7c:	74a2                	ld	s1,40(sp)
    80003c7e:	7902                	ld	s2,32(sp)
    80003c80:	69e2                	ld	s3,24(sp)
    80003c82:	6a42                	ld	s4,16(sp)
    80003c84:	6aa2                	ld	s5,8(sp)
    80003c86:	6121                	addi	sp,sp,64
    80003c88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c8a:	85d6                	mv	a1,s5
    80003c8c:	8552                	mv	a0,s4
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	34c080e7          	jalr	844(ra) # 80003fda <pipeclose>
    80003c96:	b7cd                	j	80003c78 <fileclose+0xa8>

0000000080003c98 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c98:	715d                	addi	sp,sp,-80
    80003c9a:	e486                	sd	ra,72(sp)
    80003c9c:	e0a2                	sd	s0,64(sp)
    80003c9e:	fc26                	sd	s1,56(sp)
    80003ca0:	f84a                	sd	s2,48(sp)
    80003ca2:	f44e                	sd	s3,40(sp)
    80003ca4:	0880                	addi	s0,sp,80
    80003ca6:	84aa                	mv	s1,a0
    80003ca8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	298080e7          	jalr	664(ra) # 80000f42 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cb2:	409c                	lw	a5,0(s1)
    80003cb4:	37f9                	addiw	a5,a5,-2
    80003cb6:	4705                	li	a4,1
    80003cb8:	04f76763          	bltu	a4,a5,80003d06 <filestat+0x6e>
    80003cbc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cbe:	6c88                	ld	a0,24(s1)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	06c080e7          	jalr	108(ra) # 80002d2c <ilock>
    stati(f->ip, &st);
    80003cc8:	fb840593          	addi	a1,s0,-72
    80003ccc:	6c88                	ld	a0,24(s1)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	2e8080e7          	jalr	744(ra) # 80002fb6 <stati>
    iunlock(f->ip);
    80003cd6:	6c88                	ld	a0,24(s1)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	116080e7          	jalr	278(ra) # 80002dee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ce0:	46e1                	li	a3,24
    80003ce2:	fb840613          	addi	a2,s0,-72
    80003ce6:	85ce                	mv	a1,s3
    80003ce8:	05093503          	ld	a0,80(s2)
    80003cec:	ffffd097          	auipc	ra,0xffffd
    80003cf0:	e1c080e7          	jalr	-484(ra) # 80000b08 <copyout>
    80003cf4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cf8:	60a6                	ld	ra,72(sp)
    80003cfa:	6406                	ld	s0,64(sp)
    80003cfc:	74e2                	ld	s1,56(sp)
    80003cfe:	7942                	ld	s2,48(sp)
    80003d00:	79a2                	ld	s3,40(sp)
    80003d02:	6161                	addi	sp,sp,80
    80003d04:	8082                	ret
  return -1;
    80003d06:	557d                	li	a0,-1
    80003d08:	bfc5                	j	80003cf8 <filestat+0x60>

0000000080003d0a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d0a:	7179                	addi	sp,sp,-48
    80003d0c:	f406                	sd	ra,40(sp)
    80003d0e:	f022                	sd	s0,32(sp)
    80003d10:	ec26                	sd	s1,24(sp)
    80003d12:	e84a                	sd	s2,16(sp)
    80003d14:	e44e                	sd	s3,8(sp)
    80003d16:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d18:	00854783          	lbu	a5,8(a0)
    80003d1c:	c3d5                	beqz	a5,80003dc0 <fileread+0xb6>
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	89ae                	mv	s3,a1
    80003d22:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d24:	411c                	lw	a5,0(a0)
    80003d26:	4705                	li	a4,1
    80003d28:	04e78963          	beq	a5,a4,80003d7a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d2c:	470d                	li	a4,3
    80003d2e:	04e78d63          	beq	a5,a4,80003d88 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d32:	4709                	li	a4,2
    80003d34:	06e79e63          	bne	a5,a4,80003db0 <fileread+0xa6>
    ilock(f->ip);
    80003d38:	6d08                	ld	a0,24(a0)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	ff2080e7          	jalr	-14(ra) # 80002d2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d42:	874a                	mv	a4,s2
    80003d44:	5094                	lw	a3,32(s1)
    80003d46:	864e                	mv	a2,s3
    80003d48:	4585                	li	a1,1
    80003d4a:	6c88                	ld	a0,24(s1)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	294080e7          	jalr	660(ra) # 80002fe0 <readi>
    80003d54:	892a                	mv	s2,a0
    80003d56:	00a05563          	blez	a0,80003d60 <fileread+0x56>
      f->off += r;
    80003d5a:	509c                	lw	a5,32(s1)
    80003d5c:	9fa9                	addw	a5,a5,a0
    80003d5e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d60:	6c88                	ld	a0,24(s1)
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	08c080e7          	jalr	140(ra) # 80002dee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	70a2                	ld	ra,40(sp)
    80003d6e:	7402                	ld	s0,32(sp)
    80003d70:	64e2                	ld	s1,24(sp)
    80003d72:	6942                	ld	s2,16(sp)
    80003d74:	69a2                	ld	s3,8(sp)
    80003d76:	6145                	addi	sp,sp,48
    80003d78:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d7a:	6908                	ld	a0,16(a0)
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	3c0080e7          	jalr	960(ra) # 8000413c <piperead>
    80003d84:	892a                	mv	s2,a0
    80003d86:	b7d5                	j	80003d6a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d88:	02451783          	lh	a5,36(a0)
    80003d8c:	03079693          	slli	a3,a5,0x30
    80003d90:	92c1                	srli	a3,a3,0x30
    80003d92:	4725                	li	a4,9
    80003d94:	02d76863          	bltu	a4,a3,80003dc4 <fileread+0xba>
    80003d98:	0792                	slli	a5,a5,0x4
    80003d9a:	00015717          	auipc	a4,0x15
    80003d9e:	52e70713          	addi	a4,a4,1326 # 800192c8 <devsw>
    80003da2:	97ba                	add	a5,a5,a4
    80003da4:	639c                	ld	a5,0(a5)
    80003da6:	c38d                	beqz	a5,80003dc8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003da8:	4505                	li	a0,1
    80003daa:	9782                	jalr	a5
    80003dac:	892a                	mv	s2,a0
    80003dae:	bf75                	j	80003d6a <fileread+0x60>
    panic("fileread");
    80003db0:	00005517          	auipc	a0,0x5
    80003db4:	8f050513          	addi	a0,a0,-1808 # 800086a0 <syscalls+0x2a0>
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	008080e7          	jalr	8(ra) # 80005dc0 <panic>
    return -1;
    80003dc0:	597d                	li	s2,-1
    80003dc2:	b765                	j	80003d6a <fileread+0x60>
      return -1;
    80003dc4:	597d                	li	s2,-1
    80003dc6:	b755                	j	80003d6a <fileread+0x60>
    80003dc8:	597d                	li	s2,-1
    80003dca:	b745                	j	80003d6a <fileread+0x60>

0000000080003dcc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dcc:	715d                	addi	sp,sp,-80
    80003dce:	e486                	sd	ra,72(sp)
    80003dd0:	e0a2                	sd	s0,64(sp)
    80003dd2:	fc26                	sd	s1,56(sp)
    80003dd4:	f84a                	sd	s2,48(sp)
    80003dd6:	f44e                	sd	s3,40(sp)
    80003dd8:	f052                	sd	s4,32(sp)
    80003dda:	ec56                	sd	s5,24(sp)
    80003ddc:	e85a                	sd	s6,16(sp)
    80003dde:	e45e                	sd	s7,8(sp)
    80003de0:	e062                	sd	s8,0(sp)
    80003de2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003de4:	00954783          	lbu	a5,9(a0)
    80003de8:	10078663          	beqz	a5,80003ef4 <filewrite+0x128>
    80003dec:	892a                	mv	s2,a0
    80003dee:	8b2e                	mv	s6,a1
    80003df0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003df2:	411c                	lw	a5,0(a0)
    80003df4:	4705                	li	a4,1
    80003df6:	02e78263          	beq	a5,a4,80003e1a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dfa:	470d                	li	a4,3
    80003dfc:	02e78663          	beq	a5,a4,80003e28 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e00:	4709                	li	a4,2
    80003e02:	0ee79163          	bne	a5,a4,80003ee4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e06:	0ac05d63          	blez	a2,80003ec0 <filewrite+0xf4>
    int i = 0;
    80003e0a:	4981                	li	s3,0
    80003e0c:	6b85                	lui	s7,0x1
    80003e0e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e12:	6c05                	lui	s8,0x1
    80003e14:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e18:	a861                	j	80003eb0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e1a:	6908                	ld	a0,16(a0)
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	22e080e7          	jalr	558(ra) # 8000404a <pipewrite>
    80003e24:	8a2a                	mv	s4,a0
    80003e26:	a045                	j	80003ec6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e28:	02451783          	lh	a5,36(a0)
    80003e2c:	03079693          	slli	a3,a5,0x30
    80003e30:	92c1                	srli	a3,a3,0x30
    80003e32:	4725                	li	a4,9
    80003e34:	0cd76263          	bltu	a4,a3,80003ef8 <filewrite+0x12c>
    80003e38:	0792                	slli	a5,a5,0x4
    80003e3a:	00015717          	auipc	a4,0x15
    80003e3e:	48e70713          	addi	a4,a4,1166 # 800192c8 <devsw>
    80003e42:	97ba                	add	a5,a5,a4
    80003e44:	679c                	ld	a5,8(a5)
    80003e46:	cbdd                	beqz	a5,80003efc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e48:	4505                	li	a0,1
    80003e4a:	9782                	jalr	a5
    80003e4c:	8a2a                	mv	s4,a0
    80003e4e:	a8a5                	j	80003ec6 <filewrite+0xfa>
    80003e50:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	8b4080e7          	jalr	-1868(ra) # 80003708 <begin_op>
      ilock(f->ip);
    80003e5c:	01893503          	ld	a0,24(s2)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	ecc080e7          	jalr	-308(ra) # 80002d2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e68:	8756                	mv	a4,s5
    80003e6a:	02092683          	lw	a3,32(s2)
    80003e6e:	01698633          	add	a2,s3,s6
    80003e72:	4585                	li	a1,1
    80003e74:	01893503          	ld	a0,24(s2)
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	260080e7          	jalr	608(ra) # 800030d8 <writei>
    80003e80:	84aa                	mv	s1,a0
    80003e82:	00a05763          	blez	a0,80003e90 <filewrite+0xc4>
        f->off += r;
    80003e86:	02092783          	lw	a5,32(s2)
    80003e8a:	9fa9                	addw	a5,a5,a0
    80003e8c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e90:	01893503          	ld	a0,24(s2)
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	f5a080e7          	jalr	-166(ra) # 80002dee <iunlock>
      end_op();
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	8ea080e7          	jalr	-1814(ra) # 80003786 <end_op>

      if(r != n1){
    80003ea4:	009a9f63          	bne	s5,s1,80003ec2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ea8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eac:	0149db63          	bge	s3,s4,80003ec2 <filewrite+0xf6>
      int n1 = n - i;
    80003eb0:	413a04bb          	subw	s1,s4,s3
    80003eb4:	0004879b          	sext.w	a5,s1
    80003eb8:	f8fbdce3          	bge	s7,a5,80003e50 <filewrite+0x84>
    80003ebc:	84e2                	mv	s1,s8
    80003ebe:	bf49                	j	80003e50 <filewrite+0x84>
    int i = 0;
    80003ec0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ec2:	013a1f63          	bne	s4,s3,80003ee0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ec6:	8552                	mv	a0,s4
    80003ec8:	60a6                	ld	ra,72(sp)
    80003eca:	6406                	ld	s0,64(sp)
    80003ecc:	74e2                	ld	s1,56(sp)
    80003ece:	7942                	ld	s2,48(sp)
    80003ed0:	79a2                	ld	s3,40(sp)
    80003ed2:	7a02                	ld	s4,32(sp)
    80003ed4:	6ae2                	ld	s5,24(sp)
    80003ed6:	6b42                	ld	s6,16(sp)
    80003ed8:	6ba2                	ld	s7,8(sp)
    80003eda:	6c02                	ld	s8,0(sp)
    80003edc:	6161                	addi	sp,sp,80
    80003ede:	8082                	ret
    ret = (i == n ? n : -1);
    80003ee0:	5a7d                	li	s4,-1
    80003ee2:	b7d5                	j	80003ec6 <filewrite+0xfa>
    panic("filewrite");
    80003ee4:	00004517          	auipc	a0,0x4
    80003ee8:	7cc50513          	addi	a0,a0,1996 # 800086b0 <syscalls+0x2b0>
    80003eec:	00002097          	auipc	ra,0x2
    80003ef0:	ed4080e7          	jalr	-300(ra) # 80005dc0 <panic>
    return -1;
    80003ef4:	5a7d                	li	s4,-1
    80003ef6:	bfc1                	j	80003ec6 <filewrite+0xfa>
      return -1;
    80003ef8:	5a7d                	li	s4,-1
    80003efa:	b7f1                	j	80003ec6 <filewrite+0xfa>
    80003efc:	5a7d                	li	s4,-1
    80003efe:	b7e1                	j	80003ec6 <filewrite+0xfa>

0000000080003f00 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f00:	7179                	addi	sp,sp,-48
    80003f02:	f406                	sd	ra,40(sp)
    80003f04:	f022                	sd	s0,32(sp)
    80003f06:	ec26                	sd	s1,24(sp)
    80003f08:	e84a                	sd	s2,16(sp)
    80003f0a:	e44e                	sd	s3,8(sp)
    80003f0c:	e052                	sd	s4,0(sp)
    80003f0e:	1800                	addi	s0,sp,48
    80003f10:	84aa                	mv	s1,a0
    80003f12:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f14:	0005b023          	sd	zero,0(a1)
    80003f18:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	bf8080e7          	jalr	-1032(ra) # 80003b14 <filealloc>
    80003f24:	e088                	sd	a0,0(s1)
    80003f26:	c551                	beqz	a0,80003fb2 <pipealloc+0xb2>
    80003f28:	00000097          	auipc	ra,0x0
    80003f2c:	bec080e7          	jalr	-1044(ra) # 80003b14 <filealloc>
    80003f30:	00aa3023          	sd	a0,0(s4)
    80003f34:	c92d                	beqz	a0,80003fa6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f36:	ffffc097          	auipc	ra,0xffffc
    80003f3a:	1e4080e7          	jalr	484(ra) # 8000011a <kalloc>
    80003f3e:	892a                	mv	s2,a0
    80003f40:	c125                	beqz	a0,80003fa0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f42:	4985                	li	s3,1
    80003f44:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f48:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f4c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f50:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f54:	00004597          	auipc	a1,0x4
    80003f58:	76c58593          	addi	a1,a1,1900 # 800086c0 <syscalls+0x2c0>
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	30c080e7          	jalr	780(ra) # 80006268 <initlock>
  (*f0)->type = FD_PIPE;
    80003f64:	609c                	ld	a5,0(s1)
    80003f66:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f6a:	609c                	ld	a5,0(s1)
    80003f6c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f70:	609c                	ld	a5,0(s1)
    80003f72:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f76:	609c                	ld	a5,0(s1)
    80003f78:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f7c:	000a3783          	ld	a5,0(s4)
    80003f80:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f84:	000a3783          	ld	a5,0(s4)
    80003f88:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f8c:	000a3783          	ld	a5,0(s4)
    80003f90:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f94:	000a3783          	ld	a5,0(s4)
    80003f98:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f9c:	4501                	li	a0,0
    80003f9e:	a025                	j	80003fc6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fa0:	6088                	ld	a0,0(s1)
    80003fa2:	e501                	bnez	a0,80003faa <pipealloc+0xaa>
    80003fa4:	a039                	j	80003fb2 <pipealloc+0xb2>
    80003fa6:	6088                	ld	a0,0(s1)
    80003fa8:	c51d                	beqz	a0,80003fd6 <pipealloc+0xd6>
    fileclose(*f0);
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	c26080e7          	jalr	-986(ra) # 80003bd0 <fileclose>
  if(*f1)
    80003fb2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fb6:	557d                	li	a0,-1
  if(*f1)
    80003fb8:	c799                	beqz	a5,80003fc6 <pipealloc+0xc6>
    fileclose(*f1);
    80003fba:	853e                	mv	a0,a5
    80003fbc:	00000097          	auipc	ra,0x0
    80003fc0:	c14080e7          	jalr	-1004(ra) # 80003bd0 <fileclose>
  return -1;
    80003fc4:	557d                	li	a0,-1
}
    80003fc6:	70a2                	ld	ra,40(sp)
    80003fc8:	7402                	ld	s0,32(sp)
    80003fca:	64e2                	ld	s1,24(sp)
    80003fcc:	6942                	ld	s2,16(sp)
    80003fce:	69a2                	ld	s3,8(sp)
    80003fd0:	6a02                	ld	s4,0(sp)
    80003fd2:	6145                	addi	sp,sp,48
    80003fd4:	8082                	ret
  return -1;
    80003fd6:	557d                	li	a0,-1
    80003fd8:	b7fd                	j	80003fc6 <pipealloc+0xc6>

0000000080003fda <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fda:	1101                	addi	sp,sp,-32
    80003fdc:	ec06                	sd	ra,24(sp)
    80003fde:	e822                	sd	s0,16(sp)
    80003fe0:	e426                	sd	s1,8(sp)
    80003fe2:	e04a                	sd	s2,0(sp)
    80003fe4:	1000                	addi	s0,sp,32
    80003fe6:	84aa                	mv	s1,a0
    80003fe8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	30e080e7          	jalr	782(ra) # 800062f8 <acquire>
  if(writable){
    80003ff2:	02090d63          	beqz	s2,8000402c <pipeclose+0x52>
    pi->writeopen = 0;
    80003ff6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ffa:	21848513          	addi	a0,s1,536
    80003ffe:	ffffe097          	auipc	ra,0xffffe
    80004002:	84e080e7          	jalr	-1970(ra) # 8000184c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004006:	2204b783          	ld	a5,544(s1)
    8000400a:	eb95                	bnez	a5,8000403e <pipeclose+0x64>
    release(&pi->lock);
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	39e080e7          	jalr	926(ra) # 800063ac <release>
    kfree((char*)pi);
    80004016:	8526                	mv	a0,s1
    80004018:	ffffc097          	auipc	ra,0xffffc
    8000401c:	004080e7          	jalr	4(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004020:	60e2                	ld	ra,24(sp)
    80004022:	6442                	ld	s0,16(sp)
    80004024:	64a2                	ld	s1,8(sp)
    80004026:	6902                	ld	s2,0(sp)
    80004028:	6105                	addi	sp,sp,32
    8000402a:	8082                	ret
    pi->readopen = 0;
    8000402c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004030:	21c48513          	addi	a0,s1,540
    80004034:	ffffe097          	auipc	ra,0xffffe
    80004038:	818080e7          	jalr	-2024(ra) # 8000184c <wakeup>
    8000403c:	b7e9                	j	80004006 <pipeclose+0x2c>
    release(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	36c080e7          	jalr	876(ra) # 800063ac <release>
}
    80004048:	bfe1                	j	80004020 <pipeclose+0x46>

000000008000404a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000404a:	711d                	addi	sp,sp,-96
    8000404c:	ec86                	sd	ra,88(sp)
    8000404e:	e8a2                	sd	s0,80(sp)
    80004050:	e4a6                	sd	s1,72(sp)
    80004052:	e0ca                	sd	s2,64(sp)
    80004054:	fc4e                	sd	s3,56(sp)
    80004056:	f852                	sd	s4,48(sp)
    80004058:	f456                	sd	s5,40(sp)
    8000405a:	f05a                	sd	s6,32(sp)
    8000405c:	ec5e                	sd	s7,24(sp)
    8000405e:	e862                	sd	s8,16(sp)
    80004060:	1080                	addi	s0,sp,96
    80004062:	84aa                	mv	s1,a0
    80004064:	8aae                	mv	s5,a1
    80004066:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	eda080e7          	jalr	-294(ra) # 80000f42 <myproc>
    80004070:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	284080e7          	jalr	644(ra) # 800062f8 <acquire>
  while(i < n){
    8000407c:	0b405363          	blez	s4,80004122 <pipewrite+0xd8>
  int i = 0;
    80004080:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004082:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004084:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004088:	21c48b93          	addi	s7,s1,540
    8000408c:	a089                	j	800040ce <pipewrite+0x84>
      release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	31c080e7          	jalr	796(ra) # 800063ac <release>
      return -1;
    80004098:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000409a:	854a                	mv	a0,s2
    8000409c:	60e6                	ld	ra,88(sp)
    8000409e:	6446                	ld	s0,80(sp)
    800040a0:	64a6                	ld	s1,72(sp)
    800040a2:	6906                	ld	s2,64(sp)
    800040a4:	79e2                	ld	s3,56(sp)
    800040a6:	7a42                	ld	s4,48(sp)
    800040a8:	7aa2                	ld	s5,40(sp)
    800040aa:	7b02                	ld	s6,32(sp)
    800040ac:	6be2                	ld	s7,24(sp)
    800040ae:	6c42                	ld	s8,16(sp)
    800040b0:	6125                	addi	sp,sp,96
    800040b2:	8082                	ret
      wakeup(&pi->nread);
    800040b4:	8562                	mv	a0,s8
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	796080e7          	jalr	1942(ra) # 8000184c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040be:	85a6                	mv	a1,s1
    800040c0:	855e                	mv	a0,s7
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	5fe080e7          	jalr	1534(ra) # 800016c0 <sleep>
  while(i < n){
    800040ca:	05495d63          	bge	s2,s4,80004124 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040ce:	2204a783          	lw	a5,544(s1)
    800040d2:	dfd5                	beqz	a5,8000408e <pipewrite+0x44>
    800040d4:	0289a783          	lw	a5,40(s3)
    800040d8:	fbdd                	bnez	a5,8000408e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040da:	2184a783          	lw	a5,536(s1)
    800040de:	21c4a703          	lw	a4,540(s1)
    800040e2:	2007879b          	addiw	a5,a5,512
    800040e6:	fcf707e3          	beq	a4,a5,800040b4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ea:	4685                	li	a3,1
    800040ec:	01590633          	add	a2,s2,s5
    800040f0:	faf40593          	addi	a1,s0,-81
    800040f4:	0509b503          	ld	a0,80(s3)
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	a9c080e7          	jalr	-1380(ra) # 80000b94 <copyin>
    80004100:	03650263          	beq	a0,s6,80004124 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004104:	21c4a783          	lw	a5,540(s1)
    80004108:	0017871b          	addiw	a4,a5,1
    8000410c:	20e4ae23          	sw	a4,540(s1)
    80004110:	1ff7f793          	andi	a5,a5,511
    80004114:	97a6                	add	a5,a5,s1
    80004116:	faf44703          	lbu	a4,-81(s0)
    8000411a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000411e:	2905                	addiw	s2,s2,1
    80004120:	b76d                	j	800040ca <pipewrite+0x80>
  int i = 0;
    80004122:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004124:	21848513          	addi	a0,s1,536
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	724080e7          	jalr	1828(ra) # 8000184c <wakeup>
  release(&pi->lock);
    80004130:	8526                	mv	a0,s1
    80004132:	00002097          	auipc	ra,0x2
    80004136:	27a080e7          	jalr	634(ra) # 800063ac <release>
  return i;
    8000413a:	b785                	j	8000409a <pipewrite+0x50>

000000008000413c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000413c:	715d                	addi	sp,sp,-80
    8000413e:	e486                	sd	ra,72(sp)
    80004140:	e0a2                	sd	s0,64(sp)
    80004142:	fc26                	sd	s1,56(sp)
    80004144:	f84a                	sd	s2,48(sp)
    80004146:	f44e                	sd	s3,40(sp)
    80004148:	f052                	sd	s4,32(sp)
    8000414a:	ec56                	sd	s5,24(sp)
    8000414c:	e85a                	sd	s6,16(sp)
    8000414e:	0880                	addi	s0,sp,80
    80004150:	84aa                	mv	s1,a0
    80004152:	892e                	mv	s2,a1
    80004154:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	dec080e7          	jalr	-532(ra) # 80000f42 <myproc>
    8000415e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	196080e7          	jalr	406(ra) # 800062f8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416a:	2184a703          	lw	a4,536(s1)
    8000416e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004172:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004176:	02f71463          	bne	a4,a5,8000419e <piperead+0x62>
    8000417a:	2244a783          	lw	a5,548(s1)
    8000417e:	c385                	beqz	a5,8000419e <piperead+0x62>
    if(pr->killed){
    80004180:	028a2783          	lw	a5,40(s4)
    80004184:	ebc9                	bnez	a5,80004216 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004186:	85a6                	mv	a1,s1
    80004188:	854e                	mv	a0,s3
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	536080e7          	jalr	1334(ra) # 800016c0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004192:	2184a703          	lw	a4,536(s1)
    80004196:	21c4a783          	lw	a5,540(s1)
    8000419a:	fef700e3          	beq	a4,a5,8000417a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a2:	05505463          	blez	s5,800041ea <piperead+0xae>
    if(pi->nread == pi->nwrite)
    800041a6:	2184a783          	lw	a5,536(s1)
    800041aa:	21c4a703          	lw	a4,540(s1)
    800041ae:	02f70e63          	beq	a4,a5,800041ea <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041b2:	0017871b          	addiw	a4,a5,1
    800041b6:	20e4ac23          	sw	a4,536(s1)
    800041ba:	1ff7f793          	andi	a5,a5,511
    800041be:	97a6                	add	a5,a5,s1
    800041c0:	0187c783          	lbu	a5,24(a5)
    800041c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c8:	4685                	li	a3,1
    800041ca:	fbf40613          	addi	a2,s0,-65
    800041ce:	85ca                	mv	a1,s2
    800041d0:	050a3503          	ld	a0,80(s4)
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	934080e7          	jalr	-1740(ra) # 80000b08 <copyout>
    800041dc:	01650763          	beq	a0,s6,800041ea <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e0:	2985                	addiw	s3,s3,1
    800041e2:	0905                	addi	s2,s2,1
    800041e4:	fd3a91e3          	bne	s5,s3,800041a6 <piperead+0x6a>
    800041e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ea:	21c48513          	addi	a0,s1,540
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	65e080e7          	jalr	1630(ra) # 8000184c <wakeup>
  release(&pi->lock);
    800041f6:	8526                	mv	a0,s1
    800041f8:	00002097          	auipc	ra,0x2
    800041fc:	1b4080e7          	jalr	436(ra) # 800063ac <release>
  return i;
}
    80004200:	854e                	mv	a0,s3
    80004202:	60a6                	ld	ra,72(sp)
    80004204:	6406                	ld	s0,64(sp)
    80004206:	74e2                	ld	s1,56(sp)
    80004208:	7942                	ld	s2,48(sp)
    8000420a:	79a2                	ld	s3,40(sp)
    8000420c:	7a02                	ld	s4,32(sp)
    8000420e:	6ae2                	ld	s5,24(sp)
    80004210:	6b42                	ld	s6,16(sp)
    80004212:	6161                	addi	sp,sp,80
    80004214:	8082                	ret
      release(&pi->lock);
    80004216:	8526                	mv	a0,s1
    80004218:	00002097          	auipc	ra,0x2
    8000421c:	194080e7          	jalr	404(ra) # 800063ac <release>
      return -1;
    80004220:	59fd                	li	s3,-1
    80004222:	bff9                	j	80004200 <piperead+0xc4>

0000000080004224 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004224:	de010113          	addi	sp,sp,-544
    80004228:	20113c23          	sd	ra,536(sp)
    8000422c:	20813823          	sd	s0,528(sp)
    80004230:	20913423          	sd	s1,520(sp)
    80004234:	21213023          	sd	s2,512(sp)
    80004238:	ffce                	sd	s3,504(sp)
    8000423a:	fbd2                	sd	s4,496(sp)
    8000423c:	f7d6                	sd	s5,488(sp)
    8000423e:	f3da                	sd	s6,480(sp)
    80004240:	efde                	sd	s7,472(sp)
    80004242:	ebe2                	sd	s8,464(sp)
    80004244:	e7e6                	sd	s9,456(sp)
    80004246:	e3ea                	sd	s10,448(sp)
    80004248:	ff6e                	sd	s11,440(sp)
    8000424a:	1400                	addi	s0,sp,544
    8000424c:	892a                	mv	s2,a0
    8000424e:	dea43423          	sd	a0,-536(s0)
    80004252:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	cec080e7          	jalr	-788(ra) # 80000f42 <myproc>
    8000425e:	84aa                	mv	s1,a0

  begin_op();
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	4a8080e7          	jalr	1192(ra) # 80003708 <begin_op>

  if((ip = namei(path)) == 0){
    80004268:	854a                	mv	a0,s2
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	27e080e7          	jalr	638(ra) # 800034e8 <namei>
    80004272:	c93d                	beqz	a0,800042e8 <exec+0xc4>
    80004274:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004276:	fffff097          	auipc	ra,0xfffff
    8000427a:	ab6080e7          	jalr	-1354(ra) # 80002d2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000427e:	04000713          	li	a4,64
    80004282:	4681                	li	a3,0
    80004284:	e5040613          	addi	a2,s0,-432
    80004288:	4581                	li	a1,0
    8000428a:	8556                	mv	a0,s5
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	d54080e7          	jalr	-684(ra) # 80002fe0 <readi>
    80004294:	04000793          	li	a5,64
    80004298:	00f51a63          	bne	a0,a5,800042ac <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000429c:	e5042703          	lw	a4,-432(s0)
    800042a0:	464c47b7          	lui	a5,0x464c4
    800042a4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042a8:	04f70663          	beq	a4,a5,800042f4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042ac:	8556                	mv	a0,s5
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	ce0080e7          	jalr	-800(ra) # 80002f8e <iunlockput>
    end_op();
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	4d0080e7          	jalr	1232(ra) # 80003786 <end_op>
  }
  return -1;
    800042be:	557d                	li	a0,-1
}
    800042c0:	21813083          	ld	ra,536(sp)
    800042c4:	21013403          	ld	s0,528(sp)
    800042c8:	20813483          	ld	s1,520(sp)
    800042cc:	20013903          	ld	s2,512(sp)
    800042d0:	79fe                	ld	s3,504(sp)
    800042d2:	7a5e                	ld	s4,496(sp)
    800042d4:	7abe                	ld	s5,488(sp)
    800042d6:	7b1e                	ld	s6,480(sp)
    800042d8:	6bfe                	ld	s7,472(sp)
    800042da:	6c5e                	ld	s8,464(sp)
    800042dc:	6cbe                	ld	s9,456(sp)
    800042de:	6d1e                	ld	s10,448(sp)
    800042e0:	7dfa                	ld	s11,440(sp)
    800042e2:	22010113          	addi	sp,sp,544
    800042e6:	8082                	ret
    end_op();
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	49e080e7          	jalr	1182(ra) # 80003786 <end_op>
    return -1;
    800042f0:	557d                	li	a0,-1
    800042f2:	b7f9                	j	800042c0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042f4:	8526                	mv	a0,s1
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	d10080e7          	jalr	-752(ra) # 80001006 <proc_pagetable>
    800042fe:	8b2a                	mv	s6,a0
    80004300:	d555                	beqz	a0,800042ac <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004302:	e7042783          	lw	a5,-400(s0)
    80004306:	e8845703          	lhu	a4,-376(s0)
    8000430a:	c735                	beqz	a4,80004376 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000430c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000430e:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004312:	6a05                	lui	s4,0x1
    80004314:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004318:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000431c:	6d85                	lui	s11,0x1
    8000431e:	7d7d                	lui	s10,0xfffff
    80004320:	a4b9                	j	8000456e <exec+0x34a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004322:	00004517          	auipc	a0,0x4
    80004326:	3a650513          	addi	a0,a0,934 # 800086c8 <syscalls+0x2c8>
    8000432a:	00002097          	auipc	ra,0x2
    8000432e:	a96080e7          	jalr	-1386(ra) # 80005dc0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004332:	874a                	mv	a4,s2
    80004334:	009c86bb          	addw	a3,s9,s1
    80004338:	4581                	li	a1,0
    8000433a:	8556                	mv	a0,s5
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	ca4080e7          	jalr	-860(ra) # 80002fe0 <readi>
    80004344:	2501                	sext.w	a0,a0
    80004346:	1ca91463          	bne	s2,a0,8000450e <exec+0x2ea>
  for(i = 0; i < sz; i += PGSIZE){
    8000434a:	009d84bb          	addw	s1,s11,s1
    8000434e:	013d09bb          	addw	s3,s10,s3
    80004352:	1f74fe63          	bgeu	s1,s7,8000454e <exec+0x32a>
    pa = walkaddr(pagetable, va + i);
    80004356:	02049593          	slli	a1,s1,0x20
    8000435a:	9181                	srli	a1,a1,0x20
    8000435c:	95e2                	add	a1,a1,s8
    8000435e:	855a                	mv	a0,s6
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	1a0080e7          	jalr	416(ra) # 80000500 <walkaddr>
    80004368:	862a                	mv	a2,a0
    if(pa == 0)
    8000436a:	dd45                	beqz	a0,80004322 <exec+0xfe>
      n = PGSIZE;
    8000436c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000436e:	fd49f2e3          	bgeu	s3,s4,80004332 <exec+0x10e>
      n = sz - i;
    80004372:	894e                	mv	s2,s3
    80004374:	bf7d                	j	80004332 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004376:	4481                	li	s1,0
  iunlockput(ip);
    80004378:	8556                	mv	a0,s5
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	c14080e7          	jalr	-1004(ra) # 80002f8e <iunlockput>
  end_op();
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	404080e7          	jalr	1028(ra) # 80003786 <end_op>
  p = myproc();
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	bb8080e7          	jalr	-1096(ra) # 80000f42 <myproc>
    80004392:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004394:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004398:	6785                	lui	a5,0x1
    8000439a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000439c:	97a6                	add	a5,a5,s1
    8000439e:	777d                	lui	a4,0xfffff
    800043a0:	8ff9                	and	a5,a5,a4
    800043a2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043a6:	6609                	lui	a2,0x2
    800043a8:	963e                	add	a2,a2,a5
    800043aa:	85be                	mv	a1,a5
    800043ac:	855a                	mv	a0,s6
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	506080e7          	jalr	1286(ra) # 800008b4 <uvmalloc>
    800043b6:	8c2a                	mv	s8,a0
  ip = 0;
    800043b8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043ba:	14050a63          	beqz	a0,8000450e <exec+0x2ea>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043be:	75f9                	lui	a1,0xffffe
    800043c0:	95aa                	add	a1,a1,a0
    800043c2:	855a                	mv	a0,s6
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	712080e7          	jalr	1810(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    800043cc:	7afd                	lui	s5,0xfffff
    800043ce:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043d0:	df043783          	ld	a5,-528(s0)
    800043d4:	6388                	ld	a0,0(a5)
    800043d6:	c925                	beqz	a0,80004446 <exec+0x222>
    800043d8:	e9040993          	addi	s3,s0,-368
    800043dc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043e0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043e2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	f12080e7          	jalr	-238(ra) # 800002f6 <strlen>
    800043ec:	0015079b          	addiw	a5,a0,1
    800043f0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043f4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043f8:	13596f63          	bltu	s2,s5,80004536 <exec+0x312>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043fc:	df043d83          	ld	s11,-528(s0)
    80004400:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004404:	8552                	mv	a0,s4
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	ef0080e7          	jalr	-272(ra) # 800002f6 <strlen>
    8000440e:	0015069b          	addiw	a3,a0,1
    80004412:	8652                	mv	a2,s4
    80004414:	85ca                	mv	a1,s2
    80004416:	855a                	mv	a0,s6
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	6f0080e7          	jalr	1776(ra) # 80000b08 <copyout>
    80004420:	10054f63          	bltz	a0,8000453e <exec+0x31a>
    ustack[argc] = sp;
    80004424:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004428:	0485                	addi	s1,s1,1
    8000442a:	008d8793          	addi	a5,s11,8
    8000442e:	def43823          	sd	a5,-528(s0)
    80004432:	008db503          	ld	a0,8(s11)
    80004436:	c911                	beqz	a0,8000444a <exec+0x226>
    if(argc >= MAXARG)
    80004438:	09a1                	addi	s3,s3,8
    8000443a:	fb3c95e3          	bne	s9,s3,800043e4 <exec+0x1c0>
  sz = sz1;
    8000443e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004442:	4a81                	li	s5,0
    80004444:	a0e9                	j	8000450e <exec+0x2ea>
  sp = sz;
    80004446:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004448:	4481                	li	s1,0
  ustack[argc] = 0;
    8000444a:	00349793          	slli	a5,s1,0x3
    8000444e:	f9078793          	addi	a5,a5,-112
    80004452:	97a2                	add	a5,a5,s0
    80004454:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004458:	00148693          	addi	a3,s1,1
    8000445c:	068e                	slli	a3,a3,0x3
    8000445e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004462:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004466:	01597663          	bgeu	s2,s5,80004472 <exec+0x24e>
  sz = sz1;
    8000446a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000446e:	4a81                	li	s5,0
    80004470:	a879                	j	8000450e <exec+0x2ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004472:	e9040613          	addi	a2,s0,-368
    80004476:	85ca                	mv	a1,s2
    80004478:	855a                	mv	a0,s6
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	68e080e7          	jalr	1678(ra) # 80000b08 <copyout>
    80004482:	0c054263          	bltz	a0,80004546 <exec+0x322>
  p->trapframe->a1 = sp;
    80004486:	058bb783          	ld	a5,88(s7)
    8000448a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000448e:	de843783          	ld	a5,-536(s0)
    80004492:	0007c703          	lbu	a4,0(a5)
    80004496:	cf11                	beqz	a4,800044b2 <exec+0x28e>
    80004498:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000449a:	02f00693          	li	a3,47
    8000449e:	a039                	j	800044ac <exec+0x288>
      last = s+1;
    800044a0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044a4:	0785                	addi	a5,a5,1
    800044a6:	fff7c703          	lbu	a4,-1(a5)
    800044aa:	c701                	beqz	a4,800044b2 <exec+0x28e>
    if(*s == '/')
    800044ac:	fed71ce3          	bne	a4,a3,800044a4 <exec+0x280>
    800044b0:	bfc5                	j	800044a0 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800044b2:	4641                	li	a2,16
    800044b4:	de843583          	ld	a1,-536(s0)
    800044b8:	158b8513          	addi	a0,s7,344
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	e08080e7          	jalr	-504(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800044c4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800044c8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044cc:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044d0:	058bb783          	ld	a5,88(s7)
    800044d4:	e6843703          	ld	a4,-408(s0)
    800044d8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044da:	058bb783          	ld	a5,88(s7)
    800044de:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044e2:	85ea                	mv	a1,s10
    800044e4:	ffffd097          	auipc	ra,0xffffd
    800044e8:	c18080e7          	jalr	-1000(ra) # 800010fc <proc_freepagetable>
  if(p->pid==1){
    800044ec:	030ba703          	lw	a4,48(s7)
    800044f0:	4785                	li	a5,1
    800044f2:	00f70563          	beq	a4,a5,800044fc <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044f6:	0004851b          	sext.w	a0,s1
    800044fa:	b3d9                	j	800042c0 <exec+0x9c>
   vmprint(p->pagetable);
    800044fc:	050bb503          	ld	a0,80(s7)
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	8a0080e7          	jalr	-1888(ra) # 80000da0 <vmprint>
    80004508:	b7fd                	j	800044f6 <exec+0x2d2>
    8000450a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000450e:	df843583          	ld	a1,-520(s0)
    80004512:	855a                	mv	a0,s6
    80004514:	ffffd097          	auipc	ra,0xffffd
    80004518:	be8080e7          	jalr	-1048(ra) # 800010fc <proc_freepagetable>
  if(ip){
    8000451c:	d80a98e3          	bnez	s5,800042ac <exec+0x88>
  return -1;
    80004520:	557d                	li	a0,-1
    80004522:	bb79                	j	800042c0 <exec+0x9c>
    80004524:	de943c23          	sd	s1,-520(s0)
    80004528:	b7dd                	j	8000450e <exec+0x2ea>
    8000452a:	de943c23          	sd	s1,-520(s0)
    8000452e:	b7c5                	j	8000450e <exec+0x2ea>
    80004530:	de943c23          	sd	s1,-520(s0)
    80004534:	bfe9                	j	8000450e <exec+0x2ea>
  sz = sz1;
    80004536:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000453a:	4a81                	li	s5,0
    8000453c:	bfc9                	j	8000450e <exec+0x2ea>
  sz = sz1;
    8000453e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004542:	4a81                	li	s5,0
    80004544:	b7e9                	j	8000450e <exec+0x2ea>
  sz = sz1;
    80004546:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000454a:	4a81                	li	s5,0
    8000454c:	b7c9                	j	8000450e <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000454e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004552:	e0843783          	ld	a5,-504(s0)
    80004556:	0017869b          	addiw	a3,a5,1
    8000455a:	e0d43423          	sd	a3,-504(s0)
    8000455e:	e0043783          	ld	a5,-512(s0)
    80004562:	0387879b          	addiw	a5,a5,56
    80004566:	e8845703          	lhu	a4,-376(s0)
    8000456a:	e0e6d7e3          	bge	a3,a4,80004378 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000456e:	2781                	sext.w	a5,a5
    80004570:	e0f43023          	sd	a5,-512(s0)
    80004574:	03800713          	li	a4,56
    80004578:	86be                	mv	a3,a5
    8000457a:	e1840613          	addi	a2,s0,-488
    8000457e:	4581                	li	a1,0
    80004580:	8556                	mv	a0,s5
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	a5e080e7          	jalr	-1442(ra) # 80002fe0 <readi>
    8000458a:	03800793          	li	a5,56
    8000458e:	f6f51ee3          	bne	a0,a5,8000450a <exec+0x2e6>
    if(ph.type != ELF_PROG_LOAD)
    80004592:	e1842783          	lw	a5,-488(s0)
    80004596:	4705                	li	a4,1
    80004598:	fae79de3          	bne	a5,a4,80004552 <exec+0x32e>
    if(ph.memsz < ph.filesz)
    8000459c:	e4043603          	ld	a2,-448(s0)
    800045a0:	e3843783          	ld	a5,-456(s0)
    800045a4:	f8f660e3          	bltu	a2,a5,80004524 <exec+0x300>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045a8:	e2843783          	ld	a5,-472(s0)
    800045ac:	963e                	add	a2,a2,a5
    800045ae:	f6f66ee3          	bltu	a2,a5,8000452a <exec+0x306>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045b2:	85a6                	mv	a1,s1
    800045b4:	855a                	mv	a0,s6
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	2fe080e7          	jalr	766(ra) # 800008b4 <uvmalloc>
    800045be:	dea43c23          	sd	a0,-520(s0)
    800045c2:	d53d                	beqz	a0,80004530 <exec+0x30c>
    if((ph.vaddr % PGSIZE) != 0)
    800045c4:	e2843c03          	ld	s8,-472(s0)
    800045c8:	de043783          	ld	a5,-544(s0)
    800045cc:	00fc77b3          	and	a5,s8,a5
    800045d0:	ff9d                	bnez	a5,8000450e <exec+0x2ea>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045d2:	e2042c83          	lw	s9,-480(s0)
    800045d6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045da:	f60b8ae3          	beqz	s7,8000454e <exec+0x32a>
    800045de:	89de                	mv	s3,s7
    800045e0:	4481                	li	s1,0
    800045e2:	bb95                	j	80004356 <exec+0x132>

00000000800045e4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045e4:	7179                	addi	sp,sp,-48
    800045e6:	f406                	sd	ra,40(sp)
    800045e8:	f022                	sd	s0,32(sp)
    800045ea:	ec26                	sd	s1,24(sp)
    800045ec:	e84a                	sd	s2,16(sp)
    800045ee:	1800                	addi	s0,sp,48
    800045f0:	892e                	mv	s2,a1
    800045f2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045f4:	fdc40593          	addi	a1,s0,-36
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	aba080e7          	jalr	-1350(ra) # 800020b2 <argint>
    80004600:	04054063          	bltz	a0,80004640 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004604:	fdc42703          	lw	a4,-36(s0)
    80004608:	47bd                	li	a5,15
    8000460a:	02e7ed63          	bltu	a5,a4,80004644 <argfd+0x60>
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	934080e7          	jalr	-1740(ra) # 80000f42 <myproc>
    80004616:	fdc42703          	lw	a4,-36(s0)
    8000461a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    8000461e:	078e                	slli	a5,a5,0x3
    80004620:	953e                	add	a0,a0,a5
    80004622:	611c                	ld	a5,0(a0)
    80004624:	c395                	beqz	a5,80004648 <argfd+0x64>
    return -1;
  if(pfd)
    80004626:	00090463          	beqz	s2,8000462e <argfd+0x4a>
    *pfd = fd;
    8000462a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000462e:	4501                	li	a0,0
  if(pf)
    80004630:	c091                	beqz	s1,80004634 <argfd+0x50>
    *pf = f;
    80004632:	e09c                	sd	a5,0(s1)
}
    80004634:	70a2                	ld	ra,40(sp)
    80004636:	7402                	ld	s0,32(sp)
    80004638:	64e2                	ld	s1,24(sp)
    8000463a:	6942                	ld	s2,16(sp)
    8000463c:	6145                	addi	sp,sp,48
    8000463e:	8082                	ret
    return -1;
    80004640:	557d                	li	a0,-1
    80004642:	bfcd                	j	80004634 <argfd+0x50>
    return -1;
    80004644:	557d                	li	a0,-1
    80004646:	b7fd                	j	80004634 <argfd+0x50>
    80004648:	557d                	li	a0,-1
    8000464a:	b7ed                	j	80004634 <argfd+0x50>

000000008000464c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000464c:	1101                	addi	sp,sp,-32
    8000464e:	ec06                	sd	ra,24(sp)
    80004650:	e822                	sd	s0,16(sp)
    80004652:	e426                	sd	s1,8(sp)
    80004654:	1000                	addi	s0,sp,32
    80004656:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004658:	ffffd097          	auipc	ra,0xffffd
    8000465c:	8ea080e7          	jalr	-1814(ra) # 80000f42 <myproc>
    80004660:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004662:	0d050793          	addi	a5,a0,208
    80004666:	4501                	li	a0,0
    80004668:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000466a:	6398                	ld	a4,0(a5)
    8000466c:	cb19                	beqz	a4,80004682 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000466e:	2505                	addiw	a0,a0,1
    80004670:	07a1                	addi	a5,a5,8
    80004672:	fed51ce3          	bne	a0,a3,8000466a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004676:	557d                	li	a0,-1
}
    80004678:	60e2                	ld	ra,24(sp)
    8000467a:	6442                	ld	s0,16(sp)
    8000467c:	64a2                	ld	s1,8(sp)
    8000467e:	6105                	addi	sp,sp,32
    80004680:	8082                	ret
      p->ofile[fd] = f;
    80004682:	01a50793          	addi	a5,a0,26
    80004686:	078e                	slli	a5,a5,0x3
    80004688:	963e                	add	a2,a2,a5
    8000468a:	e204                	sd	s1,0(a2)
      return fd;
    8000468c:	b7f5                	j	80004678 <fdalloc+0x2c>

000000008000468e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000468e:	715d                	addi	sp,sp,-80
    80004690:	e486                	sd	ra,72(sp)
    80004692:	e0a2                	sd	s0,64(sp)
    80004694:	fc26                	sd	s1,56(sp)
    80004696:	f84a                	sd	s2,48(sp)
    80004698:	f44e                	sd	s3,40(sp)
    8000469a:	f052                	sd	s4,32(sp)
    8000469c:	ec56                	sd	s5,24(sp)
    8000469e:	0880                	addi	s0,sp,80
    800046a0:	89ae                	mv	s3,a1
    800046a2:	8ab2                	mv	s5,a2
    800046a4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046a6:	fb040593          	addi	a1,s0,-80
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	e5c080e7          	jalr	-420(ra) # 80003506 <nameiparent>
    800046b2:	892a                	mv	s2,a0
    800046b4:	12050e63          	beqz	a0,800047f0 <create+0x162>
    return 0;

  ilock(dp);
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	674080e7          	jalr	1652(ra) # 80002d2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046c0:	4601                	li	a2,0
    800046c2:	fb040593          	addi	a1,s0,-80
    800046c6:	854a                	mv	a0,s2
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	b48080e7          	jalr	-1208(ra) # 80003210 <dirlookup>
    800046d0:	84aa                	mv	s1,a0
    800046d2:	c921                	beqz	a0,80004722 <create+0x94>
    iunlockput(dp);
    800046d4:	854a                	mv	a0,s2
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	8b8080e7          	jalr	-1864(ra) # 80002f8e <iunlockput>
    ilock(ip);
    800046de:	8526                	mv	a0,s1
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	64c080e7          	jalr	1612(ra) # 80002d2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046e8:	2981                	sext.w	s3,s3
    800046ea:	4789                	li	a5,2
    800046ec:	02f99463          	bne	s3,a5,80004714 <create+0x86>
    800046f0:	0444d783          	lhu	a5,68(s1)
    800046f4:	37f9                	addiw	a5,a5,-2
    800046f6:	17c2                	slli	a5,a5,0x30
    800046f8:	93c1                	srli	a5,a5,0x30
    800046fa:	4705                	li	a4,1
    800046fc:	00f76c63          	bltu	a4,a5,80004714 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004700:	8526                	mv	a0,s1
    80004702:	60a6                	ld	ra,72(sp)
    80004704:	6406                	ld	s0,64(sp)
    80004706:	74e2                	ld	s1,56(sp)
    80004708:	7942                	ld	s2,48(sp)
    8000470a:	79a2                	ld	s3,40(sp)
    8000470c:	7a02                	ld	s4,32(sp)
    8000470e:	6ae2                	ld	s5,24(sp)
    80004710:	6161                	addi	sp,sp,80
    80004712:	8082                	ret
    iunlockput(ip);
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	878080e7          	jalr	-1928(ra) # 80002f8e <iunlockput>
    return 0;
    8000471e:	4481                	li	s1,0
    80004720:	b7c5                	j	80004700 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004722:	85ce                	mv	a1,s3
    80004724:	00092503          	lw	a0,0(s2)
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	46a080e7          	jalr	1130(ra) # 80002b92 <ialloc>
    80004730:	84aa                	mv	s1,a0
    80004732:	c521                	beqz	a0,8000477a <create+0xec>
  ilock(ip);
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	5f8080e7          	jalr	1528(ra) # 80002d2c <ilock>
  ip->major = major;
    8000473c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004740:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004744:	4a05                	li	s4,1
    80004746:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	514080e7          	jalr	1300(ra) # 80002c60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004754:	2981                	sext.w	s3,s3
    80004756:	03498a63          	beq	s3,s4,8000478a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000475a:	40d0                	lw	a2,4(s1)
    8000475c:	fb040593          	addi	a1,s0,-80
    80004760:	854a                	mv	a0,s2
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	cc4080e7          	jalr	-828(ra) # 80003426 <dirlink>
    8000476a:	06054b63          	bltz	a0,800047e0 <create+0x152>
  iunlockput(dp);
    8000476e:	854a                	mv	a0,s2
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	81e080e7          	jalr	-2018(ra) # 80002f8e <iunlockput>
  return ip;
    80004778:	b761                	j	80004700 <create+0x72>
    panic("create: ialloc");
    8000477a:	00004517          	auipc	a0,0x4
    8000477e:	f6e50513          	addi	a0,a0,-146 # 800086e8 <syscalls+0x2e8>
    80004782:	00001097          	auipc	ra,0x1
    80004786:	63e080e7          	jalr	1598(ra) # 80005dc0 <panic>
    dp->nlink++;  // for ".."
    8000478a:	04a95783          	lhu	a5,74(s2)
    8000478e:	2785                	addiw	a5,a5,1
    80004790:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004794:	854a                	mv	a0,s2
    80004796:	ffffe097          	auipc	ra,0xffffe
    8000479a:	4ca080e7          	jalr	1226(ra) # 80002c60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000479e:	40d0                	lw	a2,4(s1)
    800047a0:	00004597          	auipc	a1,0x4
    800047a4:	f5858593          	addi	a1,a1,-168 # 800086f8 <syscalls+0x2f8>
    800047a8:	8526                	mv	a0,s1
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	c7c080e7          	jalr	-900(ra) # 80003426 <dirlink>
    800047b2:	00054f63          	bltz	a0,800047d0 <create+0x142>
    800047b6:	00492603          	lw	a2,4(s2)
    800047ba:	00004597          	auipc	a1,0x4
    800047be:	9a658593          	addi	a1,a1,-1626 # 80008160 <etext+0x160>
    800047c2:	8526                	mv	a0,s1
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	c62080e7          	jalr	-926(ra) # 80003426 <dirlink>
    800047cc:	f80557e3          	bgez	a0,8000475a <create+0xcc>
      panic("create dots");
    800047d0:	00004517          	auipc	a0,0x4
    800047d4:	f3050513          	addi	a0,a0,-208 # 80008700 <syscalls+0x300>
    800047d8:	00001097          	auipc	ra,0x1
    800047dc:	5e8080e7          	jalr	1512(ra) # 80005dc0 <panic>
    panic("create: dirlink");
    800047e0:	00004517          	auipc	a0,0x4
    800047e4:	f3050513          	addi	a0,a0,-208 # 80008710 <syscalls+0x310>
    800047e8:	00001097          	auipc	ra,0x1
    800047ec:	5d8080e7          	jalr	1496(ra) # 80005dc0 <panic>
    return 0;
    800047f0:	84aa                	mv	s1,a0
    800047f2:	b739                	j	80004700 <create+0x72>

00000000800047f4 <sys_dup>:
{
    800047f4:	7179                	addi	sp,sp,-48
    800047f6:	f406                	sd	ra,40(sp)
    800047f8:	f022                	sd	s0,32(sp)
    800047fa:	ec26                	sd	s1,24(sp)
    800047fc:	e84a                	sd	s2,16(sp)
    800047fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004800:	fd840613          	addi	a2,s0,-40
    80004804:	4581                	li	a1,0
    80004806:	4501                	li	a0,0
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	ddc080e7          	jalr	-548(ra) # 800045e4 <argfd>
    return -1;
    80004810:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004812:	02054363          	bltz	a0,80004838 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004816:	fd843903          	ld	s2,-40(s0)
    8000481a:	854a                	mv	a0,s2
    8000481c:	00000097          	auipc	ra,0x0
    80004820:	e30080e7          	jalr	-464(ra) # 8000464c <fdalloc>
    80004824:	84aa                	mv	s1,a0
    return -1;
    80004826:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004828:	00054863          	bltz	a0,80004838 <sys_dup+0x44>
  filedup(f);
    8000482c:	854a                	mv	a0,s2
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	350080e7          	jalr	848(ra) # 80003b7e <filedup>
  return fd;
    80004836:	87a6                	mv	a5,s1
}
    80004838:	853e                	mv	a0,a5
    8000483a:	70a2                	ld	ra,40(sp)
    8000483c:	7402                	ld	s0,32(sp)
    8000483e:	64e2                	ld	s1,24(sp)
    80004840:	6942                	ld	s2,16(sp)
    80004842:	6145                	addi	sp,sp,48
    80004844:	8082                	ret

0000000080004846 <sys_read>:
{
    80004846:	7179                	addi	sp,sp,-48
    80004848:	f406                	sd	ra,40(sp)
    8000484a:	f022                	sd	s0,32(sp)
    8000484c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000484e:	fe840613          	addi	a2,s0,-24
    80004852:	4581                	li	a1,0
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	d8e080e7          	jalr	-626(ra) # 800045e4 <argfd>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004860:	04054163          	bltz	a0,800048a2 <sys_read+0x5c>
    80004864:	fe440593          	addi	a1,s0,-28
    80004868:	4509                	li	a0,2
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	848080e7          	jalr	-1976(ra) # 800020b2 <argint>
    return -1;
    80004872:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004874:	02054763          	bltz	a0,800048a2 <sys_read+0x5c>
    80004878:	fd840593          	addi	a1,s0,-40
    8000487c:	4505                	li	a0,1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	856080e7          	jalr	-1962(ra) # 800020d4 <argaddr>
    return -1;
    80004886:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004888:	00054d63          	bltz	a0,800048a2 <sys_read+0x5c>
  return fileread(f, p, n);
    8000488c:	fe442603          	lw	a2,-28(s0)
    80004890:	fd843583          	ld	a1,-40(s0)
    80004894:	fe843503          	ld	a0,-24(s0)
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	472080e7          	jalr	1138(ra) # 80003d0a <fileread>
    800048a0:	87aa                	mv	a5,a0
}
    800048a2:	853e                	mv	a0,a5
    800048a4:	70a2                	ld	ra,40(sp)
    800048a6:	7402                	ld	s0,32(sp)
    800048a8:	6145                	addi	sp,sp,48
    800048aa:	8082                	ret

00000000800048ac <sys_write>:
{
    800048ac:	7179                	addi	sp,sp,-48
    800048ae:	f406                	sd	ra,40(sp)
    800048b0:	f022                	sd	s0,32(sp)
    800048b2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b4:	fe840613          	addi	a2,s0,-24
    800048b8:	4581                	li	a1,0
    800048ba:	4501                	li	a0,0
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	d28080e7          	jalr	-728(ra) # 800045e4 <argfd>
    return -1;
    800048c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c6:	04054163          	bltz	a0,80004908 <sys_write+0x5c>
    800048ca:	fe440593          	addi	a1,s0,-28
    800048ce:	4509                	li	a0,2
    800048d0:	ffffd097          	auipc	ra,0xffffd
    800048d4:	7e2080e7          	jalr	2018(ra) # 800020b2 <argint>
    return -1;
    800048d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048da:	02054763          	bltz	a0,80004908 <sys_write+0x5c>
    800048de:	fd840593          	addi	a1,s0,-40
    800048e2:	4505                	li	a0,1
    800048e4:	ffffd097          	auipc	ra,0xffffd
    800048e8:	7f0080e7          	jalr	2032(ra) # 800020d4 <argaddr>
    return -1;
    800048ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ee:	00054d63          	bltz	a0,80004908 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048f2:	fe442603          	lw	a2,-28(s0)
    800048f6:	fd843583          	ld	a1,-40(s0)
    800048fa:	fe843503          	ld	a0,-24(s0)
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	4ce080e7          	jalr	1230(ra) # 80003dcc <filewrite>
    80004906:	87aa                	mv	a5,a0
}
    80004908:	853e                	mv	a0,a5
    8000490a:	70a2                	ld	ra,40(sp)
    8000490c:	7402                	ld	s0,32(sp)
    8000490e:	6145                	addi	sp,sp,48
    80004910:	8082                	ret

0000000080004912 <sys_close>:
{
    80004912:	1101                	addi	sp,sp,-32
    80004914:	ec06                	sd	ra,24(sp)
    80004916:	e822                	sd	s0,16(sp)
    80004918:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000491a:	fe040613          	addi	a2,s0,-32
    8000491e:	fec40593          	addi	a1,s0,-20
    80004922:	4501                	li	a0,0
    80004924:	00000097          	auipc	ra,0x0
    80004928:	cc0080e7          	jalr	-832(ra) # 800045e4 <argfd>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000492e:	02054463          	bltz	a0,80004956 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004932:	ffffc097          	auipc	ra,0xffffc
    80004936:	610080e7          	jalr	1552(ra) # 80000f42 <myproc>
    8000493a:	fec42783          	lw	a5,-20(s0)
    8000493e:	07e9                	addi	a5,a5,26
    80004940:	078e                	slli	a5,a5,0x3
    80004942:	953e                	add	a0,a0,a5
    80004944:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004948:	fe043503          	ld	a0,-32(s0)
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	284080e7          	jalr	644(ra) # 80003bd0 <fileclose>
  return 0;
    80004954:	4781                	li	a5,0
}
    80004956:	853e                	mv	a0,a5
    80004958:	60e2                	ld	ra,24(sp)
    8000495a:	6442                	ld	s0,16(sp)
    8000495c:	6105                	addi	sp,sp,32
    8000495e:	8082                	ret

0000000080004960 <sys_fstat>:
{
    80004960:	1101                	addi	sp,sp,-32
    80004962:	ec06                	sd	ra,24(sp)
    80004964:	e822                	sd	s0,16(sp)
    80004966:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004968:	fe840613          	addi	a2,s0,-24
    8000496c:	4581                	li	a1,0
    8000496e:	4501                	li	a0,0
    80004970:	00000097          	auipc	ra,0x0
    80004974:	c74080e7          	jalr	-908(ra) # 800045e4 <argfd>
    return -1;
    80004978:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000497a:	02054563          	bltz	a0,800049a4 <sys_fstat+0x44>
    8000497e:	fe040593          	addi	a1,s0,-32
    80004982:	4505                	li	a0,1
    80004984:	ffffd097          	auipc	ra,0xffffd
    80004988:	750080e7          	jalr	1872(ra) # 800020d4 <argaddr>
    return -1;
    8000498c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000498e:	00054b63          	bltz	a0,800049a4 <sys_fstat+0x44>
  return filestat(f, st);
    80004992:	fe043583          	ld	a1,-32(s0)
    80004996:	fe843503          	ld	a0,-24(s0)
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	2fe080e7          	jalr	766(ra) # 80003c98 <filestat>
    800049a2:	87aa                	mv	a5,a0
}
    800049a4:	853e                	mv	a0,a5
    800049a6:	60e2                	ld	ra,24(sp)
    800049a8:	6442                	ld	s0,16(sp)
    800049aa:	6105                	addi	sp,sp,32
    800049ac:	8082                	ret

00000000800049ae <sys_link>:
{
    800049ae:	7169                	addi	sp,sp,-304
    800049b0:	f606                	sd	ra,296(sp)
    800049b2:	f222                	sd	s0,288(sp)
    800049b4:	ee26                	sd	s1,280(sp)
    800049b6:	ea4a                	sd	s2,272(sp)
    800049b8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ba:	08000613          	li	a2,128
    800049be:	ed040593          	addi	a1,s0,-304
    800049c2:	4501                	li	a0,0
    800049c4:	ffffd097          	auipc	ra,0xffffd
    800049c8:	732080e7          	jalr	1842(ra) # 800020f6 <argstr>
    return -1;
    800049cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ce:	10054e63          	bltz	a0,80004aea <sys_link+0x13c>
    800049d2:	08000613          	li	a2,128
    800049d6:	f5040593          	addi	a1,s0,-176
    800049da:	4505                	li	a0,1
    800049dc:	ffffd097          	auipc	ra,0xffffd
    800049e0:	71a080e7          	jalr	1818(ra) # 800020f6 <argstr>
    return -1;
    800049e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049e6:	10054263          	bltz	a0,80004aea <sys_link+0x13c>
  begin_op();
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	d1e080e7          	jalr	-738(ra) # 80003708 <begin_op>
  if((ip = namei(old)) == 0){
    800049f2:	ed040513          	addi	a0,s0,-304
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	af2080e7          	jalr	-1294(ra) # 800034e8 <namei>
    800049fe:	84aa                	mv	s1,a0
    80004a00:	c551                	beqz	a0,80004a8c <sys_link+0xde>
  ilock(ip);
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	32a080e7          	jalr	810(ra) # 80002d2c <ilock>
  if(ip->type == T_DIR){
    80004a0a:	04449703          	lh	a4,68(s1)
    80004a0e:	4785                	li	a5,1
    80004a10:	08f70463          	beq	a4,a5,80004a98 <sys_link+0xea>
  ip->nlink++;
    80004a14:	04a4d783          	lhu	a5,74(s1)
    80004a18:	2785                	addiw	a5,a5,1
    80004a1a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	240080e7          	jalr	576(ra) # 80002c60 <iupdate>
  iunlock(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	3c4080e7          	jalr	964(ra) # 80002dee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a32:	fd040593          	addi	a1,s0,-48
    80004a36:	f5040513          	addi	a0,s0,-176
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	acc080e7          	jalr	-1332(ra) # 80003506 <nameiparent>
    80004a42:	892a                	mv	s2,a0
    80004a44:	c935                	beqz	a0,80004ab8 <sys_link+0x10a>
  ilock(dp);
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	2e6080e7          	jalr	742(ra) # 80002d2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a4e:	00092703          	lw	a4,0(s2)
    80004a52:	409c                	lw	a5,0(s1)
    80004a54:	04f71d63          	bne	a4,a5,80004aae <sys_link+0x100>
    80004a58:	40d0                	lw	a2,4(s1)
    80004a5a:	fd040593          	addi	a1,s0,-48
    80004a5e:	854a                	mv	a0,s2
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	9c6080e7          	jalr	-1594(ra) # 80003426 <dirlink>
    80004a68:	04054363          	bltz	a0,80004aae <sys_link+0x100>
  iunlockput(dp);
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	520080e7          	jalr	1312(ra) # 80002f8e <iunlockput>
  iput(ip);
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	46e080e7          	jalr	1134(ra) # 80002ee6 <iput>
  end_op();
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	d06080e7          	jalr	-762(ra) # 80003786 <end_op>
  return 0;
    80004a88:	4781                	li	a5,0
    80004a8a:	a085                	j	80004aea <sys_link+0x13c>
    end_op();
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	cfa080e7          	jalr	-774(ra) # 80003786 <end_op>
    return -1;
    80004a94:	57fd                	li	a5,-1
    80004a96:	a891                	j	80004aea <sys_link+0x13c>
    iunlockput(ip);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	4f4080e7          	jalr	1268(ra) # 80002f8e <iunlockput>
    end_op();
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	ce4080e7          	jalr	-796(ra) # 80003786 <end_op>
    return -1;
    80004aaa:	57fd                	li	a5,-1
    80004aac:	a83d                	j	80004aea <sys_link+0x13c>
    iunlockput(dp);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	4de080e7          	jalr	1246(ra) # 80002f8e <iunlockput>
  ilock(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	272080e7          	jalr	626(ra) # 80002d2c <ilock>
  ip->nlink--;
    80004ac2:	04a4d783          	lhu	a5,74(s1)
    80004ac6:	37fd                	addiw	a5,a5,-1
    80004ac8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	192080e7          	jalr	402(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	4b6080e7          	jalr	1206(ra) # 80002f8e <iunlockput>
  end_op();
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	ca6080e7          	jalr	-858(ra) # 80003786 <end_op>
  return -1;
    80004ae8:	57fd                	li	a5,-1
}
    80004aea:	853e                	mv	a0,a5
    80004aec:	70b2                	ld	ra,296(sp)
    80004aee:	7412                	ld	s0,288(sp)
    80004af0:	64f2                	ld	s1,280(sp)
    80004af2:	6952                	ld	s2,272(sp)
    80004af4:	6155                	addi	sp,sp,304
    80004af6:	8082                	ret

0000000080004af8 <sys_unlink>:
{
    80004af8:	7151                	addi	sp,sp,-240
    80004afa:	f586                	sd	ra,232(sp)
    80004afc:	f1a2                	sd	s0,224(sp)
    80004afe:	eda6                	sd	s1,216(sp)
    80004b00:	e9ca                	sd	s2,208(sp)
    80004b02:	e5ce                	sd	s3,200(sp)
    80004b04:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b06:	08000613          	li	a2,128
    80004b0a:	f3040593          	addi	a1,s0,-208
    80004b0e:	4501                	li	a0,0
    80004b10:	ffffd097          	auipc	ra,0xffffd
    80004b14:	5e6080e7          	jalr	1510(ra) # 800020f6 <argstr>
    80004b18:	18054163          	bltz	a0,80004c9a <sys_unlink+0x1a2>
  begin_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	bec080e7          	jalr	-1044(ra) # 80003708 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b24:	fb040593          	addi	a1,s0,-80
    80004b28:	f3040513          	addi	a0,s0,-208
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	9da080e7          	jalr	-1574(ra) # 80003506 <nameiparent>
    80004b34:	84aa                	mv	s1,a0
    80004b36:	c979                	beqz	a0,80004c0c <sys_unlink+0x114>
  ilock(dp);
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	1f4080e7          	jalr	500(ra) # 80002d2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b40:	00004597          	auipc	a1,0x4
    80004b44:	bb858593          	addi	a1,a1,-1096 # 800086f8 <syscalls+0x2f8>
    80004b48:	fb040513          	addi	a0,s0,-80
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	6aa080e7          	jalr	1706(ra) # 800031f6 <namecmp>
    80004b54:	14050a63          	beqz	a0,80004ca8 <sys_unlink+0x1b0>
    80004b58:	00003597          	auipc	a1,0x3
    80004b5c:	60858593          	addi	a1,a1,1544 # 80008160 <etext+0x160>
    80004b60:	fb040513          	addi	a0,s0,-80
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	692080e7          	jalr	1682(ra) # 800031f6 <namecmp>
    80004b6c:	12050e63          	beqz	a0,80004ca8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b70:	f2c40613          	addi	a2,s0,-212
    80004b74:	fb040593          	addi	a1,s0,-80
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	696080e7          	jalr	1686(ra) # 80003210 <dirlookup>
    80004b82:	892a                	mv	s2,a0
    80004b84:	12050263          	beqz	a0,80004ca8 <sys_unlink+0x1b0>
  ilock(ip);
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	1a4080e7          	jalr	420(ra) # 80002d2c <ilock>
  if(ip->nlink < 1)
    80004b90:	04a91783          	lh	a5,74(s2)
    80004b94:	08f05263          	blez	a5,80004c18 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b98:	04491703          	lh	a4,68(s2)
    80004b9c:	4785                	li	a5,1
    80004b9e:	08f70563          	beq	a4,a5,80004c28 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ba2:	4641                	li	a2,16
    80004ba4:	4581                	li	a1,0
    80004ba6:	fc040513          	addi	a0,s0,-64
    80004baa:	ffffb097          	auipc	ra,0xffffb
    80004bae:	5d0080e7          	jalr	1488(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bb2:	4741                	li	a4,16
    80004bb4:	f2c42683          	lw	a3,-212(s0)
    80004bb8:	fc040613          	addi	a2,s0,-64
    80004bbc:	4581                	li	a1,0
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	518080e7          	jalr	1304(ra) # 800030d8 <writei>
    80004bc8:	47c1                	li	a5,16
    80004bca:	0af51563          	bne	a0,a5,80004c74 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bce:	04491703          	lh	a4,68(s2)
    80004bd2:	4785                	li	a5,1
    80004bd4:	0af70863          	beq	a4,a5,80004c84 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	3b4080e7          	jalr	948(ra) # 80002f8e <iunlockput>
  ip->nlink--;
    80004be2:	04a95783          	lhu	a5,74(s2)
    80004be6:	37fd                	addiw	a5,a5,-1
    80004be8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bec:	854a                	mv	a0,s2
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	072080e7          	jalr	114(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	396080e7          	jalr	918(ra) # 80002f8e <iunlockput>
  end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	b86080e7          	jalr	-1146(ra) # 80003786 <end_op>
  return 0;
    80004c08:	4501                	li	a0,0
    80004c0a:	a84d                	j	80004cbc <sys_unlink+0x1c4>
    end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	b7a080e7          	jalr	-1158(ra) # 80003786 <end_op>
    return -1;
    80004c14:	557d                	li	a0,-1
    80004c16:	a05d                	j	80004cbc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c18:	00004517          	auipc	a0,0x4
    80004c1c:	b0850513          	addi	a0,a0,-1272 # 80008720 <syscalls+0x320>
    80004c20:	00001097          	auipc	ra,0x1
    80004c24:	1a0080e7          	jalr	416(ra) # 80005dc0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c28:	04c92703          	lw	a4,76(s2)
    80004c2c:	02000793          	li	a5,32
    80004c30:	f6e7f9e3          	bgeu	a5,a4,80004ba2 <sys_unlink+0xaa>
    80004c34:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c38:	4741                	li	a4,16
    80004c3a:	86ce                	mv	a3,s3
    80004c3c:	f1840613          	addi	a2,s0,-232
    80004c40:	4581                	li	a1,0
    80004c42:	854a                	mv	a0,s2
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	39c080e7          	jalr	924(ra) # 80002fe0 <readi>
    80004c4c:	47c1                	li	a5,16
    80004c4e:	00f51b63          	bne	a0,a5,80004c64 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c52:	f1845783          	lhu	a5,-232(s0)
    80004c56:	e7a1                	bnez	a5,80004c9e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c58:	29c1                	addiw	s3,s3,16
    80004c5a:	04c92783          	lw	a5,76(s2)
    80004c5e:	fcf9ede3          	bltu	s3,a5,80004c38 <sys_unlink+0x140>
    80004c62:	b781                	j	80004ba2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c64:	00004517          	auipc	a0,0x4
    80004c68:	ad450513          	addi	a0,a0,-1324 # 80008738 <syscalls+0x338>
    80004c6c:	00001097          	auipc	ra,0x1
    80004c70:	154080e7          	jalr	340(ra) # 80005dc0 <panic>
    panic("unlink: writei");
    80004c74:	00004517          	auipc	a0,0x4
    80004c78:	adc50513          	addi	a0,a0,-1316 # 80008750 <syscalls+0x350>
    80004c7c:	00001097          	auipc	ra,0x1
    80004c80:	144080e7          	jalr	324(ra) # 80005dc0 <panic>
    dp->nlink--;
    80004c84:	04a4d783          	lhu	a5,74(s1)
    80004c88:	37fd                	addiw	a5,a5,-1
    80004c8a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c8e:	8526                	mv	a0,s1
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	fd0080e7          	jalr	-48(ra) # 80002c60 <iupdate>
    80004c98:	b781                	j	80004bd8 <sys_unlink+0xe0>
    return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	a005                	j	80004cbc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	2ee080e7          	jalr	750(ra) # 80002f8e <iunlockput>
  iunlockput(dp);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	2e4080e7          	jalr	740(ra) # 80002f8e <iunlockput>
  end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	ad4080e7          	jalr	-1324(ra) # 80003786 <end_op>
  return -1;
    80004cba:	557d                	li	a0,-1
}
    80004cbc:	70ae                	ld	ra,232(sp)
    80004cbe:	740e                	ld	s0,224(sp)
    80004cc0:	64ee                	ld	s1,216(sp)
    80004cc2:	694e                	ld	s2,208(sp)
    80004cc4:	69ae                	ld	s3,200(sp)
    80004cc6:	616d                	addi	sp,sp,240
    80004cc8:	8082                	ret

0000000080004cca <sys_open>:

uint64
sys_open(void)
{
    80004cca:	7131                	addi	sp,sp,-192
    80004ccc:	fd06                	sd	ra,184(sp)
    80004cce:	f922                	sd	s0,176(sp)
    80004cd0:	f526                	sd	s1,168(sp)
    80004cd2:	f14a                	sd	s2,160(sp)
    80004cd4:	ed4e                	sd	s3,152(sp)
    80004cd6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cd8:	08000613          	li	a2,128
    80004cdc:	f5040593          	addi	a1,s0,-176
    80004ce0:	4501                	li	a0,0
    80004ce2:	ffffd097          	auipc	ra,0xffffd
    80004ce6:	414080e7          	jalr	1044(ra) # 800020f6 <argstr>
    return -1;
    80004cea:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cec:	0c054163          	bltz	a0,80004dae <sys_open+0xe4>
    80004cf0:	f4c40593          	addi	a1,s0,-180
    80004cf4:	4505                	li	a0,1
    80004cf6:	ffffd097          	auipc	ra,0xffffd
    80004cfa:	3bc080e7          	jalr	956(ra) # 800020b2 <argint>
    80004cfe:	0a054863          	bltz	a0,80004dae <sys_open+0xe4>

  begin_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	a06080e7          	jalr	-1530(ra) # 80003708 <begin_op>

  if(omode & O_CREATE){
    80004d0a:	f4c42783          	lw	a5,-180(s0)
    80004d0e:	2007f793          	andi	a5,a5,512
    80004d12:	cbdd                	beqz	a5,80004dc8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d14:	4681                	li	a3,0
    80004d16:	4601                	li	a2,0
    80004d18:	4589                	li	a1,2
    80004d1a:	f5040513          	addi	a0,s0,-176
    80004d1e:	00000097          	auipc	ra,0x0
    80004d22:	970080e7          	jalr	-1680(ra) # 8000468e <create>
    80004d26:	892a                	mv	s2,a0
    if(ip == 0){
    80004d28:	c959                	beqz	a0,80004dbe <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d2a:	04491703          	lh	a4,68(s2)
    80004d2e:	478d                	li	a5,3
    80004d30:	00f71763          	bne	a4,a5,80004d3e <sys_open+0x74>
    80004d34:	04695703          	lhu	a4,70(s2)
    80004d38:	47a5                	li	a5,9
    80004d3a:	0ce7ec63          	bltu	a5,a4,80004e12 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	dd6080e7          	jalr	-554(ra) # 80003b14 <filealloc>
    80004d46:	89aa                	mv	s3,a0
    80004d48:	10050263          	beqz	a0,80004e4c <sys_open+0x182>
    80004d4c:	00000097          	auipc	ra,0x0
    80004d50:	900080e7          	jalr	-1792(ra) # 8000464c <fdalloc>
    80004d54:	84aa                	mv	s1,a0
    80004d56:	0e054663          	bltz	a0,80004e42 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d5a:	04491703          	lh	a4,68(s2)
    80004d5e:	478d                	li	a5,3
    80004d60:	0cf70463          	beq	a4,a5,80004e28 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d64:	4789                	li	a5,2
    80004d66:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d6a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d6e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d72:	f4c42783          	lw	a5,-180(s0)
    80004d76:	0017c713          	xori	a4,a5,1
    80004d7a:	8b05                	andi	a4,a4,1
    80004d7c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d80:	0037f713          	andi	a4,a5,3
    80004d84:	00e03733          	snez	a4,a4
    80004d88:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d8c:	4007f793          	andi	a5,a5,1024
    80004d90:	c791                	beqz	a5,80004d9c <sys_open+0xd2>
    80004d92:	04491703          	lh	a4,68(s2)
    80004d96:	4789                	li	a5,2
    80004d98:	08f70f63          	beq	a4,a5,80004e36 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d9c:	854a                	mv	a0,s2
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	050080e7          	jalr	80(ra) # 80002dee <iunlock>
  end_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	9e0080e7          	jalr	-1568(ra) # 80003786 <end_op>

  return fd;
}
    80004dae:	8526                	mv	a0,s1
    80004db0:	70ea                	ld	ra,184(sp)
    80004db2:	744a                	ld	s0,176(sp)
    80004db4:	74aa                	ld	s1,168(sp)
    80004db6:	790a                	ld	s2,160(sp)
    80004db8:	69ea                	ld	s3,152(sp)
    80004dba:	6129                	addi	sp,sp,192
    80004dbc:	8082                	ret
      end_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	9c8080e7          	jalr	-1592(ra) # 80003786 <end_op>
      return -1;
    80004dc6:	b7e5                	j	80004dae <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dc8:	f5040513          	addi	a0,s0,-176
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	71c080e7          	jalr	1820(ra) # 800034e8 <namei>
    80004dd4:	892a                	mv	s2,a0
    80004dd6:	c905                	beqz	a0,80004e06 <sys_open+0x13c>
    ilock(ip);
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	f54080e7          	jalr	-172(ra) # 80002d2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004de0:	04491703          	lh	a4,68(s2)
    80004de4:	4785                	li	a5,1
    80004de6:	f4f712e3          	bne	a4,a5,80004d2a <sys_open+0x60>
    80004dea:	f4c42783          	lw	a5,-180(s0)
    80004dee:	dba1                	beqz	a5,80004d3e <sys_open+0x74>
      iunlockput(ip);
    80004df0:	854a                	mv	a0,s2
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	19c080e7          	jalr	412(ra) # 80002f8e <iunlockput>
      end_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	98c080e7          	jalr	-1652(ra) # 80003786 <end_op>
      return -1;
    80004e02:	54fd                	li	s1,-1
    80004e04:	b76d                	j	80004dae <sys_open+0xe4>
      end_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	980080e7          	jalr	-1664(ra) # 80003786 <end_op>
      return -1;
    80004e0e:	54fd                	li	s1,-1
    80004e10:	bf79                	j	80004dae <sys_open+0xe4>
    iunlockput(ip);
    80004e12:	854a                	mv	a0,s2
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	17a080e7          	jalr	378(ra) # 80002f8e <iunlockput>
    end_op();
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	96a080e7          	jalr	-1686(ra) # 80003786 <end_op>
    return -1;
    80004e24:	54fd                	li	s1,-1
    80004e26:	b761                	j	80004dae <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e28:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e2c:	04691783          	lh	a5,70(s2)
    80004e30:	02f99223          	sh	a5,36(s3)
    80004e34:	bf2d                	j	80004d6e <sys_open+0xa4>
    itrunc(ip);
    80004e36:	854a                	mv	a0,s2
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	002080e7          	jalr	2(ra) # 80002e3a <itrunc>
    80004e40:	bfb1                	j	80004d9c <sys_open+0xd2>
      fileclose(f);
    80004e42:	854e                	mv	a0,s3
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	d8c080e7          	jalr	-628(ra) # 80003bd0 <fileclose>
    iunlockput(ip);
    80004e4c:	854a                	mv	a0,s2
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	140080e7          	jalr	320(ra) # 80002f8e <iunlockput>
    end_op();
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	930080e7          	jalr	-1744(ra) # 80003786 <end_op>
    return -1;
    80004e5e:	54fd                	li	s1,-1
    80004e60:	b7b9                	j	80004dae <sys_open+0xe4>

0000000080004e62 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e62:	7175                	addi	sp,sp,-144
    80004e64:	e506                	sd	ra,136(sp)
    80004e66:	e122                	sd	s0,128(sp)
    80004e68:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	89e080e7          	jalr	-1890(ra) # 80003708 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e72:	08000613          	li	a2,128
    80004e76:	f7040593          	addi	a1,s0,-144
    80004e7a:	4501                	li	a0,0
    80004e7c:	ffffd097          	auipc	ra,0xffffd
    80004e80:	27a080e7          	jalr	634(ra) # 800020f6 <argstr>
    80004e84:	02054963          	bltz	a0,80004eb6 <sys_mkdir+0x54>
    80004e88:	4681                	li	a3,0
    80004e8a:	4601                	li	a2,0
    80004e8c:	4585                	li	a1,1
    80004e8e:	f7040513          	addi	a0,s0,-144
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	7fc080e7          	jalr	2044(ra) # 8000468e <create>
    80004e9a:	cd11                	beqz	a0,80004eb6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	0f2080e7          	jalr	242(ra) # 80002f8e <iunlockput>
  end_op();
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	8e2080e7          	jalr	-1822(ra) # 80003786 <end_op>
  return 0;
    80004eac:	4501                	li	a0,0
}
    80004eae:	60aa                	ld	ra,136(sp)
    80004eb0:	640a                	ld	s0,128(sp)
    80004eb2:	6149                	addi	sp,sp,144
    80004eb4:	8082                	ret
    end_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	8d0080e7          	jalr	-1840(ra) # 80003786 <end_op>
    return -1;
    80004ebe:	557d                	li	a0,-1
    80004ec0:	b7fd                	j	80004eae <sys_mkdir+0x4c>

0000000080004ec2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ec2:	7135                	addi	sp,sp,-160
    80004ec4:	ed06                	sd	ra,152(sp)
    80004ec6:	e922                	sd	s0,144(sp)
    80004ec8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	83e080e7          	jalr	-1986(ra) # 80003708 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed2:	08000613          	li	a2,128
    80004ed6:	f7040593          	addi	a1,s0,-144
    80004eda:	4501                	li	a0,0
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	21a080e7          	jalr	538(ra) # 800020f6 <argstr>
    80004ee4:	04054a63          	bltz	a0,80004f38 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ee8:	f6c40593          	addi	a1,s0,-148
    80004eec:	4505                	li	a0,1
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	1c4080e7          	jalr	452(ra) # 800020b2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ef6:	04054163          	bltz	a0,80004f38 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004efa:	f6840593          	addi	a1,s0,-152
    80004efe:	4509                	li	a0,2
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	1b2080e7          	jalr	434(ra) # 800020b2 <argint>
     argint(1, &major) < 0 ||
    80004f08:	02054863          	bltz	a0,80004f38 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f0c:	f6841683          	lh	a3,-152(s0)
    80004f10:	f6c41603          	lh	a2,-148(s0)
    80004f14:	458d                	li	a1,3
    80004f16:	f7040513          	addi	a0,s0,-144
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	774080e7          	jalr	1908(ra) # 8000468e <create>
     argint(2, &minor) < 0 ||
    80004f22:	c919                	beqz	a0,80004f38 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	06a080e7          	jalr	106(ra) # 80002f8e <iunlockput>
  end_op();
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	85a080e7          	jalr	-1958(ra) # 80003786 <end_op>
  return 0;
    80004f34:	4501                	li	a0,0
    80004f36:	a031                	j	80004f42 <sys_mknod+0x80>
    end_op();
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	84e080e7          	jalr	-1970(ra) # 80003786 <end_op>
    return -1;
    80004f40:	557d                	li	a0,-1
}
    80004f42:	60ea                	ld	ra,152(sp)
    80004f44:	644a                	ld	s0,144(sp)
    80004f46:	610d                	addi	sp,sp,160
    80004f48:	8082                	ret

0000000080004f4a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f4a:	7135                	addi	sp,sp,-160
    80004f4c:	ed06                	sd	ra,152(sp)
    80004f4e:	e922                	sd	s0,144(sp)
    80004f50:	e526                	sd	s1,136(sp)
    80004f52:	e14a                	sd	s2,128(sp)
    80004f54:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f56:	ffffc097          	auipc	ra,0xffffc
    80004f5a:	fec080e7          	jalr	-20(ra) # 80000f42 <myproc>
    80004f5e:	892a                	mv	s2,a0
  
  begin_op();
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	7a8080e7          	jalr	1960(ra) # 80003708 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f68:	08000613          	li	a2,128
    80004f6c:	f6040593          	addi	a1,s0,-160
    80004f70:	4501                	li	a0,0
    80004f72:	ffffd097          	auipc	ra,0xffffd
    80004f76:	184080e7          	jalr	388(ra) # 800020f6 <argstr>
    80004f7a:	04054b63          	bltz	a0,80004fd0 <sys_chdir+0x86>
    80004f7e:	f6040513          	addi	a0,s0,-160
    80004f82:	ffffe097          	auipc	ra,0xffffe
    80004f86:	566080e7          	jalr	1382(ra) # 800034e8 <namei>
    80004f8a:	84aa                	mv	s1,a0
    80004f8c:	c131                	beqz	a0,80004fd0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	d9e080e7          	jalr	-610(ra) # 80002d2c <ilock>
  if(ip->type != T_DIR){
    80004f96:	04449703          	lh	a4,68(s1)
    80004f9a:	4785                	li	a5,1
    80004f9c:	04f71063          	bne	a4,a5,80004fdc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	e4c080e7          	jalr	-436(ra) # 80002dee <iunlock>
  iput(p->cwd);
    80004faa:	15093503          	ld	a0,336(s2)
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	f38080e7          	jalr	-200(ra) # 80002ee6 <iput>
  end_op();
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	7d0080e7          	jalr	2000(ra) # 80003786 <end_op>
  p->cwd = ip;
    80004fbe:	14993823          	sd	s1,336(s2)
  return 0;
    80004fc2:	4501                	li	a0,0
}
    80004fc4:	60ea                	ld	ra,152(sp)
    80004fc6:	644a                	ld	s0,144(sp)
    80004fc8:	64aa                	ld	s1,136(sp)
    80004fca:	690a                	ld	s2,128(sp)
    80004fcc:	610d                	addi	sp,sp,160
    80004fce:	8082                	ret
    end_op();
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	7b6080e7          	jalr	1974(ra) # 80003786 <end_op>
    return -1;
    80004fd8:	557d                	li	a0,-1
    80004fda:	b7ed                	j	80004fc4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fdc:	8526                	mv	a0,s1
    80004fde:	ffffe097          	auipc	ra,0xffffe
    80004fe2:	fb0080e7          	jalr	-80(ra) # 80002f8e <iunlockput>
    end_op();
    80004fe6:	ffffe097          	auipc	ra,0xffffe
    80004fea:	7a0080e7          	jalr	1952(ra) # 80003786 <end_op>
    return -1;
    80004fee:	557d                	li	a0,-1
    80004ff0:	bfd1                	j	80004fc4 <sys_chdir+0x7a>

0000000080004ff2 <sys_exec>:

uint64
sys_exec(void)
{
    80004ff2:	7145                	addi	sp,sp,-464
    80004ff4:	e786                	sd	ra,456(sp)
    80004ff6:	e3a2                	sd	s0,448(sp)
    80004ff8:	ff26                	sd	s1,440(sp)
    80004ffa:	fb4a                	sd	s2,432(sp)
    80004ffc:	f74e                	sd	s3,424(sp)
    80004ffe:	f352                	sd	s4,416(sp)
    80005000:	ef56                	sd	s5,408(sp)
    80005002:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005004:	08000613          	li	a2,128
    80005008:	f4040593          	addi	a1,s0,-192
    8000500c:	4501                	li	a0,0
    8000500e:	ffffd097          	auipc	ra,0xffffd
    80005012:	0e8080e7          	jalr	232(ra) # 800020f6 <argstr>
    return -1;
    80005016:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005018:	0c054b63          	bltz	a0,800050ee <sys_exec+0xfc>
    8000501c:	e3840593          	addi	a1,s0,-456
    80005020:	4505                	li	a0,1
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	0b2080e7          	jalr	178(ra) # 800020d4 <argaddr>
    8000502a:	0c054263          	bltz	a0,800050ee <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000502e:	10000613          	li	a2,256
    80005032:	4581                	li	a1,0
    80005034:	e4040513          	addi	a0,s0,-448
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	142080e7          	jalr	322(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005040:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005044:	89a6                	mv	s3,s1
    80005046:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005048:	02000a13          	li	s4,32
    8000504c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005050:	00391513          	slli	a0,s2,0x3
    80005054:	e3040593          	addi	a1,s0,-464
    80005058:	e3843783          	ld	a5,-456(s0)
    8000505c:	953e                	add	a0,a0,a5
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	fba080e7          	jalr	-70(ra) # 80002018 <fetchaddr>
    80005066:	02054a63          	bltz	a0,8000509a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000506a:	e3043783          	ld	a5,-464(s0)
    8000506e:	c3b9                	beqz	a5,800050b4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005070:	ffffb097          	auipc	ra,0xffffb
    80005074:	0aa080e7          	jalr	170(ra) # 8000011a <kalloc>
    80005078:	85aa                	mv	a1,a0
    8000507a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000507e:	cd11                	beqz	a0,8000509a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005080:	6605                	lui	a2,0x1
    80005082:	e3043503          	ld	a0,-464(s0)
    80005086:	ffffd097          	auipc	ra,0xffffd
    8000508a:	fe4080e7          	jalr	-28(ra) # 8000206a <fetchstr>
    8000508e:	00054663          	bltz	a0,8000509a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005092:	0905                	addi	s2,s2,1
    80005094:	09a1                	addi	s3,s3,8
    80005096:	fb491be3          	bne	s2,s4,8000504c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509a:	f4040913          	addi	s2,s0,-192
    8000509e:	6088                	ld	a0,0(s1)
    800050a0:	c531                	beqz	a0,800050ec <sys_exec+0xfa>
    kfree(argv[i]);
    800050a2:	ffffb097          	auipc	ra,0xffffb
    800050a6:	f7a080e7          	jalr	-134(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050aa:	04a1                	addi	s1,s1,8
    800050ac:	ff2499e3          	bne	s1,s2,8000509e <sys_exec+0xac>
  return -1;
    800050b0:	597d                	li	s2,-1
    800050b2:	a835                	j	800050ee <sys_exec+0xfc>
      argv[i] = 0;
    800050b4:	0a8e                	slli	s5,s5,0x3
    800050b6:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    800050ba:	00878ab3          	add	s5,a5,s0
    800050be:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050c2:	e4040593          	addi	a1,s0,-448
    800050c6:	f4040513          	addi	a0,s0,-192
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	15a080e7          	jalr	346(ra) # 80004224 <exec>
    800050d2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d4:	f4040993          	addi	s3,s0,-192
    800050d8:	6088                	ld	a0,0(s1)
    800050da:	c911                	beqz	a0,800050ee <sys_exec+0xfc>
    kfree(argv[i]);
    800050dc:	ffffb097          	auipc	ra,0xffffb
    800050e0:	f40080e7          	jalr	-192(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e4:	04a1                	addi	s1,s1,8
    800050e6:	ff3499e3          	bne	s1,s3,800050d8 <sys_exec+0xe6>
    800050ea:	a011                	j	800050ee <sys_exec+0xfc>
  return -1;
    800050ec:	597d                	li	s2,-1
}
    800050ee:	854a                	mv	a0,s2
    800050f0:	60be                	ld	ra,456(sp)
    800050f2:	641e                	ld	s0,448(sp)
    800050f4:	74fa                	ld	s1,440(sp)
    800050f6:	795a                	ld	s2,432(sp)
    800050f8:	79ba                	ld	s3,424(sp)
    800050fa:	7a1a                	ld	s4,416(sp)
    800050fc:	6afa                	ld	s5,408(sp)
    800050fe:	6179                	addi	sp,sp,464
    80005100:	8082                	ret

0000000080005102 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005102:	7139                	addi	sp,sp,-64
    80005104:	fc06                	sd	ra,56(sp)
    80005106:	f822                	sd	s0,48(sp)
    80005108:	f426                	sd	s1,40(sp)
    8000510a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	e36080e7          	jalr	-458(ra) # 80000f42 <myproc>
    80005114:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005116:	fd840593          	addi	a1,s0,-40
    8000511a:	4501                	li	a0,0
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	fb8080e7          	jalr	-72(ra) # 800020d4 <argaddr>
    return -1;
    80005124:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005126:	0e054063          	bltz	a0,80005206 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000512a:	fc840593          	addi	a1,s0,-56
    8000512e:	fd040513          	addi	a0,s0,-48
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	dce080e7          	jalr	-562(ra) # 80003f00 <pipealloc>
    return -1;
    8000513a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000513c:	0c054563          	bltz	a0,80005206 <sys_pipe+0x104>
  fd0 = -1;
    80005140:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005144:	fd043503          	ld	a0,-48(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	504080e7          	jalr	1284(ra) # 8000464c <fdalloc>
    80005150:	fca42223          	sw	a0,-60(s0)
    80005154:	08054c63          	bltz	a0,800051ec <sys_pipe+0xea>
    80005158:	fc843503          	ld	a0,-56(s0)
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	4f0080e7          	jalr	1264(ra) # 8000464c <fdalloc>
    80005164:	fca42023          	sw	a0,-64(s0)
    80005168:	06054963          	bltz	a0,800051da <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516c:	4691                	li	a3,4
    8000516e:	fc440613          	addi	a2,s0,-60
    80005172:	fd843583          	ld	a1,-40(s0)
    80005176:	68a8                	ld	a0,80(s1)
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	990080e7          	jalr	-1648(ra) # 80000b08 <copyout>
    80005180:	02054063          	bltz	a0,800051a0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005184:	4691                	li	a3,4
    80005186:	fc040613          	addi	a2,s0,-64
    8000518a:	fd843583          	ld	a1,-40(s0)
    8000518e:	0591                	addi	a1,a1,4
    80005190:	68a8                	ld	a0,80(s1)
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	976080e7          	jalr	-1674(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000519a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000519c:	06055563          	bgez	a0,80005206 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051a0:	fc442783          	lw	a5,-60(s0)
    800051a4:	07e9                	addi	a5,a5,26
    800051a6:	078e                	slli	a5,a5,0x3
    800051a8:	97a6                	add	a5,a5,s1
    800051aa:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ae:	fc042783          	lw	a5,-64(s0)
    800051b2:	07e9                	addi	a5,a5,26
    800051b4:	078e                	slli	a5,a5,0x3
    800051b6:	00f48533          	add	a0,s1,a5
    800051ba:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051be:	fd043503          	ld	a0,-48(s0)
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	a0e080e7          	jalr	-1522(ra) # 80003bd0 <fileclose>
    fileclose(wf);
    800051ca:	fc843503          	ld	a0,-56(s0)
    800051ce:	fffff097          	auipc	ra,0xfffff
    800051d2:	a02080e7          	jalr	-1534(ra) # 80003bd0 <fileclose>
    return -1;
    800051d6:	57fd                	li	a5,-1
    800051d8:	a03d                	j	80005206 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051da:	fc442783          	lw	a5,-60(s0)
    800051de:	0007c763          	bltz	a5,800051ec <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051e2:	07e9                	addi	a5,a5,26
    800051e4:	078e                	slli	a5,a5,0x3
    800051e6:	97a6                	add	a5,a5,s1
    800051e8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051ec:	fd043503          	ld	a0,-48(s0)
    800051f0:	fffff097          	auipc	ra,0xfffff
    800051f4:	9e0080e7          	jalr	-1568(ra) # 80003bd0 <fileclose>
    fileclose(wf);
    800051f8:	fc843503          	ld	a0,-56(s0)
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	9d4080e7          	jalr	-1580(ra) # 80003bd0 <fileclose>
    return -1;
    80005204:	57fd                	li	a5,-1
}
    80005206:	853e                	mv	a0,a5
    80005208:	70e2                	ld	ra,56(sp)
    8000520a:	7442                	ld	s0,48(sp)
    8000520c:	74a2                	ld	s1,40(sp)
    8000520e:	6121                	addi	sp,sp,64
    80005210:	8082                	ret
	...

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	fc22                	sd	s0,56(sp)
    80005232:	e0a6                	sd	s1,64(sp)
    80005234:	e4aa                	sd	a0,72(sp)
    80005236:	e8ae                	sd	a1,80(sp)
    80005238:	ecb2                	sd	a2,88(sp)
    8000523a:	f0b6                	sd	a3,96(sp)
    8000523c:	f4ba                	sd	a4,104(sp)
    8000523e:	f8be                	sd	a5,112(sp)
    80005240:	fcc2                	sd	a6,120(sp)
    80005242:	e146                	sd	a7,128(sp)
    80005244:	e54a                	sd	s2,136(sp)
    80005246:	e94e                	sd	s3,144(sp)
    80005248:	ed52                	sd	s4,152(sp)
    8000524a:	f156                	sd	s5,160(sp)
    8000524c:	f55a                	sd	s6,168(sp)
    8000524e:	f95e                	sd	s7,176(sp)
    80005250:	fd62                	sd	s8,184(sp)
    80005252:	e1e6                	sd	s9,192(sp)
    80005254:	e5ea                	sd	s10,200(sp)
    80005256:	e9ee                	sd	s11,208(sp)
    80005258:	edf2                	sd	t3,216(sp)
    8000525a:	f1f6                	sd	t4,224(sp)
    8000525c:	f5fa                	sd	t5,232(sp)
    8000525e:	f9fe                	sd	t6,240(sp)
    80005260:	c85fc0ef          	jal	ra,80001ee4 <kerneltrap>
    80005264:	6082                	ld	ra,0(sp)
    80005266:	6122                	ld	sp,8(sp)
    80005268:	61c2                	ld	gp,16(sp)
    8000526a:	7282                	ld	t0,32(sp)
    8000526c:	7322                	ld	t1,40(sp)
    8000526e:	73c2                	ld	t2,48(sp)
    80005270:	7462                	ld	s0,56(sp)
    80005272:	6486                	ld	s1,64(sp)
    80005274:	6526                	ld	a0,72(sp)
    80005276:	65c6                	ld	a1,80(sp)
    80005278:	6666                	ld	a2,88(sp)
    8000527a:	7686                	ld	a3,96(sp)
    8000527c:	7726                	ld	a4,104(sp)
    8000527e:	77c6                	ld	a5,112(sp)
    80005280:	7866                	ld	a6,120(sp)
    80005282:	688a                	ld	a7,128(sp)
    80005284:	692a                	ld	s2,136(sp)
    80005286:	69ca                	ld	s3,144(sp)
    80005288:	6a6a                	ld	s4,152(sp)
    8000528a:	7a8a                	ld	s5,160(sp)
    8000528c:	7b2a                	ld	s6,168(sp)
    8000528e:	7bca                	ld	s7,176(sp)
    80005290:	7c6a                	ld	s8,184(sp)
    80005292:	6c8e                	ld	s9,192(sp)
    80005294:	6d2e                	ld	s10,200(sp)
    80005296:	6dce                	ld	s11,208(sp)
    80005298:	6e6e                	ld	t3,216(sp)
    8000529a:	7e8e                	ld	t4,224(sp)
    8000529c:	7f2e                	ld	t5,232(sp)
    8000529e:	7fce                	ld	t6,240(sp)
    800052a0:	6111                	addi	sp,sp,256
    800052a2:	10200073          	sret
    800052a6:	00000013          	nop
    800052aa:	00000013          	nop
    800052ae:	0001                	nop

00000000800052b0 <timervec>:
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	e10c                	sd	a1,0(a0)
    800052b6:	e510                	sd	a2,8(a0)
    800052b8:	e914                	sd	a3,16(a0)
    800052ba:	6d0c                	ld	a1,24(a0)
    800052bc:	7110                	ld	a2,32(a0)
    800052be:	6194                	ld	a3,0(a1)
    800052c0:	96b2                	add	a3,a3,a2
    800052c2:	e194                	sd	a3,0(a1)
    800052c4:	4589                	li	a1,2
    800052c6:	14459073          	csrw	sip,a1
    800052ca:	6914                	ld	a3,16(a0)
    800052cc:	6510                	ld	a2,8(a0)
    800052ce:	610c                	ld	a1,0(a0)
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	30200073          	mret
	...

00000000800052da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e422                	sd	s0,8(sp)
    800052de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052e0:	0c0007b7          	lui	a5,0xc000
    800052e4:	4705                	li	a4,1
    800052e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052e8:	c3d8                	sw	a4,4(a5)
}
    800052ea:	6422                	ld	s0,8(sp)
    800052ec:	0141                	addi	sp,sp,16
    800052ee:	8082                	ret

00000000800052f0 <plicinithart>:

void
plicinithart(void)
{
    800052f0:	1141                	addi	sp,sp,-16
    800052f2:	e406                	sd	ra,8(sp)
    800052f4:	e022                	sd	s0,0(sp)
    800052f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	c1e080e7          	jalr	-994(ra) # 80000f16 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005300:	0085171b          	slliw	a4,a0,0x8
    80005304:	0c0027b7          	lui	a5,0xc002
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	40200713          	li	a4,1026
    8000530e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005312:	00d5151b          	slliw	a0,a0,0xd
    80005316:	0c2017b7          	lui	a5,0xc201
    8000531a:	97aa                	add	a5,a5,a0
    8000531c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005328:	1141                	addi	sp,sp,-16
    8000532a:	e406                	sd	ra,8(sp)
    8000532c:	e022                	sd	s0,0(sp)
    8000532e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	be6080e7          	jalr	-1050(ra) # 80000f16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005338:	00d5151b          	slliw	a0,a0,0xd
    8000533c:	0c2017b7          	lui	a5,0xc201
    80005340:	97aa                	add	a5,a5,a0
  return irq;
}
    80005342:	43c8                	lw	a0,4(a5)
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000534c:	1101                	addi	sp,sp,-32
    8000534e:	ec06                	sd	ra,24(sp)
    80005350:	e822                	sd	s0,16(sp)
    80005352:	e426                	sd	s1,8(sp)
    80005354:	1000                	addi	s0,sp,32
    80005356:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	bbe080e7          	jalr	-1090(ra) # 80000f16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005360:	00d5151b          	slliw	a0,a0,0xd
    80005364:	0c2017b7          	lui	a5,0xc201
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	c3c4                	sw	s1,4(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret

0000000080005376 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005376:	1141                	addi	sp,sp,-16
    80005378:	e406                	sd	ra,8(sp)
    8000537a:	e022                	sd	s0,0(sp)
    8000537c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000537e:	479d                	li	a5,7
    80005380:	06a7c863          	blt	a5,a0,800053f0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005384:	00016717          	auipc	a4,0x16
    80005388:	c7c70713          	addi	a4,a4,-900 # 8001b000 <disk>
    8000538c:	972a                	add	a4,a4,a0
    8000538e:	6789                	lui	a5,0x2
    80005390:	97ba                	add	a5,a5,a4
    80005392:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005396:	e7ad                	bnez	a5,80005400 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005398:	00451793          	slli	a5,a0,0x4
    8000539c:	00018717          	auipc	a4,0x18
    800053a0:	c6470713          	addi	a4,a4,-924 # 8001d000 <disk+0x2000>
    800053a4:	6314                	ld	a3,0(a4)
    800053a6:	96be                	add	a3,a3,a5
    800053a8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053ac:	6314                	ld	a3,0(a4)
    800053ae:	96be                	add	a3,a3,a5
    800053b0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053b4:	6314                	ld	a3,0(a4)
    800053b6:	96be                	add	a3,a3,a5
    800053b8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053bc:	6318                	ld	a4,0(a4)
    800053be:	97ba                	add	a5,a5,a4
    800053c0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053c4:	00016717          	auipc	a4,0x16
    800053c8:	c3c70713          	addi	a4,a4,-964 # 8001b000 <disk>
    800053cc:	972a                	add	a4,a4,a0
    800053ce:	6789                	lui	a5,0x2
    800053d0:	97ba                	add	a5,a5,a4
    800053d2:	4705                	li	a4,1
    800053d4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053d8:	00018517          	auipc	a0,0x18
    800053dc:	c4050513          	addi	a0,a0,-960 # 8001d018 <disk+0x2018>
    800053e0:	ffffc097          	auipc	ra,0xffffc
    800053e4:	46c080e7          	jalr	1132(ra) # 8000184c <wakeup>
}
    800053e8:	60a2                	ld	ra,8(sp)
    800053ea:	6402                	ld	s0,0(sp)
    800053ec:	0141                	addi	sp,sp,16
    800053ee:	8082                	ret
    panic("free_desc 1");
    800053f0:	00003517          	auipc	a0,0x3
    800053f4:	37050513          	addi	a0,a0,880 # 80008760 <syscalls+0x360>
    800053f8:	00001097          	auipc	ra,0x1
    800053fc:	9c8080e7          	jalr	-1592(ra) # 80005dc0 <panic>
    panic("free_desc 2");
    80005400:	00003517          	auipc	a0,0x3
    80005404:	37050513          	addi	a0,a0,880 # 80008770 <syscalls+0x370>
    80005408:	00001097          	auipc	ra,0x1
    8000540c:	9b8080e7          	jalr	-1608(ra) # 80005dc0 <panic>

0000000080005410 <virtio_disk_init>:
{
    80005410:	1101                	addi	sp,sp,-32
    80005412:	ec06                	sd	ra,24(sp)
    80005414:	e822                	sd	s0,16(sp)
    80005416:	e426                	sd	s1,8(sp)
    80005418:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000541a:	00003597          	auipc	a1,0x3
    8000541e:	36658593          	addi	a1,a1,870 # 80008780 <syscalls+0x380>
    80005422:	00018517          	auipc	a0,0x18
    80005426:	d0650513          	addi	a0,a0,-762 # 8001d128 <disk+0x2128>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	e3e080e7          	jalr	-450(ra) # 80006268 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005432:	100017b7          	lui	a5,0x10001
    80005436:	4398                	lw	a4,0(a5)
    80005438:	2701                	sext.w	a4,a4
    8000543a:	747277b7          	lui	a5,0x74727
    8000543e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005442:	0ef71063          	bne	a4,a5,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	43dc                	lw	a5,4(a5)
    8000544c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544e:	4705                	li	a4,1
    80005450:	0ce79963          	bne	a5,a4,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	479c                	lw	a5,8(a5)
    8000545a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000545c:	4709                	li	a4,2
    8000545e:	0ce79263          	bne	a5,a4,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005462:	100017b7          	lui	a5,0x10001
    80005466:	47d8                	lw	a4,12(a5)
    80005468:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546a:	554d47b7          	lui	a5,0x554d4
    8000546e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005472:	0af71863          	bne	a4,a5,80005522 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	100017b7          	lui	a5,0x10001
    8000547a:	4705                	li	a4,1
    8000547c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	470d                	li	a4,3
    80005480:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005482:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005484:	c7ffe6b7          	lui	a3,0xc7ffe
    80005488:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000548c:	8f75                	and	a4,a4,a3
    8000548e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	472d                	li	a4,11
    80005492:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005494:	473d                	li	a4,15
    80005496:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005498:	6705                	lui	a4,0x1
    8000549a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000549c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054a0:	5bdc                	lw	a5,52(a5)
    800054a2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a4:	c7d9                	beqz	a5,80005532 <virtio_disk_init+0x122>
  if(max < NUM)
    800054a6:	471d                	li	a4,7
    800054a8:	08f77d63          	bgeu	a4,a5,80005542 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054ac:	100014b7          	lui	s1,0x10001
    800054b0:	47a1                	li	a5,8
    800054b2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054b4:	6609                	lui	a2,0x2
    800054b6:	4581                	li	a1,0
    800054b8:	00016517          	auipc	a0,0x16
    800054bc:	b4850513          	addi	a0,a0,-1208 # 8001b000 <disk>
    800054c0:	ffffb097          	auipc	ra,0xffffb
    800054c4:	cba080e7          	jalr	-838(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054c8:	00016717          	auipc	a4,0x16
    800054cc:	b3870713          	addi	a4,a4,-1224 # 8001b000 <disk>
    800054d0:	00c75793          	srli	a5,a4,0xc
    800054d4:	2781                	sext.w	a5,a5
    800054d6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054d8:	00018797          	auipc	a5,0x18
    800054dc:	b2878793          	addi	a5,a5,-1240 # 8001d000 <disk+0x2000>
    800054e0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054e2:	00016717          	auipc	a4,0x16
    800054e6:	b9e70713          	addi	a4,a4,-1122 # 8001b080 <disk+0x80>
    800054ea:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054ec:	00017717          	auipc	a4,0x17
    800054f0:	b1470713          	addi	a4,a4,-1260 # 8001c000 <disk+0x1000>
    800054f4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5)
    800054fc:	00e78ca3          	sb	a4,25(a5)
    80005500:	00e78d23          	sb	a4,26(a5)
    80005504:	00e78da3          	sb	a4,27(a5)
    80005508:	00e78e23          	sb	a4,28(a5)
    8000550c:	00e78ea3          	sb	a4,29(a5)
    80005510:	00e78f23          	sb	a4,30(a5)
    80005514:	00e78fa3          	sb	a4,31(a5)
}
    80005518:	60e2                	ld	ra,24(sp)
    8000551a:	6442                	ld	s0,16(sp)
    8000551c:	64a2                	ld	s1,8(sp)
    8000551e:	6105                	addi	sp,sp,32
    80005520:	8082                	ret
    panic("could not find virtio disk");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	26e50513          	addi	a0,a0,622 # 80008790 <syscalls+0x390>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	896080e7          	jalr	-1898(ra) # 80005dc0 <panic>
    panic("virtio disk has no queue 0");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	27e50513          	addi	a0,a0,638 # 800087b0 <syscalls+0x3b0>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	886080e7          	jalr	-1914(ra) # 80005dc0 <panic>
    panic("virtio disk max queue too short");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	28e50513          	addi	a0,a0,654 # 800087d0 <syscalls+0x3d0>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	876080e7          	jalr	-1930(ra) # 80005dc0 <panic>

0000000080005552 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005552:	7119                	addi	sp,sp,-128
    80005554:	fc86                	sd	ra,120(sp)
    80005556:	f8a2                	sd	s0,112(sp)
    80005558:	f4a6                	sd	s1,104(sp)
    8000555a:	f0ca                	sd	s2,96(sp)
    8000555c:	ecce                	sd	s3,88(sp)
    8000555e:	e8d2                	sd	s4,80(sp)
    80005560:	e4d6                	sd	s5,72(sp)
    80005562:	e0da                	sd	s6,64(sp)
    80005564:	fc5e                	sd	s7,56(sp)
    80005566:	f862                	sd	s8,48(sp)
    80005568:	f466                	sd	s9,40(sp)
    8000556a:	f06a                	sd	s10,32(sp)
    8000556c:	ec6e                	sd	s11,24(sp)
    8000556e:	0100                	addi	s0,sp,128
    80005570:	8aaa                	mv	s5,a0
    80005572:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005574:	00c52c83          	lw	s9,12(a0)
    80005578:	001c9c9b          	slliw	s9,s9,0x1
    8000557c:	1c82                	slli	s9,s9,0x20
    8000557e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005582:	00018517          	auipc	a0,0x18
    80005586:	ba650513          	addi	a0,a0,-1114 # 8001d128 <disk+0x2128>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	d6e080e7          	jalr	-658(ra) # 800062f8 <acquire>
  for(int i = 0; i < 3; i++){
    80005592:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005594:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005596:	00016c17          	auipc	s8,0x16
    8000559a:	a6ac0c13          	addi	s8,s8,-1430 # 8001b000 <disk>
    8000559e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800055a0:	4b0d                	li	s6,3
    800055a2:	a0ad                	j	8000560c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800055a4:	00fc0733          	add	a4,s8,a5
    800055a8:	975e                	add	a4,a4,s7
    800055aa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055ae:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055b0:	0207c563          	bltz	a5,800055da <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055b4:	2905                	addiw	s2,s2,1
    800055b6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800055b8:	19690c63          	beq	s2,s6,80005750 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800055bc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055be:	00018717          	auipc	a4,0x18
    800055c2:	a5a70713          	addi	a4,a4,-1446 # 8001d018 <disk+0x2018>
    800055c6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055c8:	00074683          	lbu	a3,0(a4)
    800055cc:	fee1                	bnez	a3,800055a4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055ce:	2785                	addiw	a5,a5,1
    800055d0:	0705                	addi	a4,a4,1
    800055d2:	fe979be3          	bne	a5,s1,800055c8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055d6:	57fd                	li	a5,-1
    800055d8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055da:	01205d63          	blez	s2,800055f4 <virtio_disk_rw+0xa2>
    800055de:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055e0:	000a2503          	lw	a0,0(s4)
    800055e4:	00000097          	auipc	ra,0x0
    800055e8:	d92080e7          	jalr	-622(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    800055ec:	2d85                	addiw	s11,s11,1
    800055ee:	0a11                	addi	s4,s4,4
    800055f0:	ff2d98e3          	bne	s11,s2,800055e0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055f4:	00018597          	auipc	a1,0x18
    800055f8:	b3458593          	addi	a1,a1,-1228 # 8001d128 <disk+0x2128>
    800055fc:	00018517          	auipc	a0,0x18
    80005600:	a1c50513          	addi	a0,a0,-1508 # 8001d018 <disk+0x2018>
    80005604:	ffffc097          	auipc	ra,0xffffc
    80005608:	0bc080e7          	jalr	188(ra) # 800016c0 <sleep>
  for(int i = 0; i < 3; i++){
    8000560c:	f8040a13          	addi	s4,s0,-128
{
    80005610:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005612:	894e                	mv	s2,s3
    80005614:	b765                	j	800055bc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005616:	00018697          	auipc	a3,0x18
    8000561a:	9ea6b683          	ld	a3,-1558(a3) # 8001d000 <disk+0x2000>
    8000561e:	96ba                	add	a3,a3,a4
    80005620:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005624:	00016817          	auipc	a6,0x16
    80005628:	9dc80813          	addi	a6,a6,-1572 # 8001b000 <disk>
    8000562c:	00018697          	auipc	a3,0x18
    80005630:	9d468693          	addi	a3,a3,-1580 # 8001d000 <disk+0x2000>
    80005634:	6290                	ld	a2,0(a3)
    80005636:	963a                	add	a2,a2,a4
    80005638:	00c65583          	lhu	a1,12(a2)
    8000563c:	0015e593          	ori	a1,a1,1
    80005640:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005644:	f8842603          	lw	a2,-120(s0)
    80005648:	628c                	ld	a1,0(a3)
    8000564a:	972e                	add	a4,a4,a1
    8000564c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005650:	20050593          	addi	a1,a0,512
    80005654:	0592                	slli	a1,a1,0x4
    80005656:	95c2                	add	a1,a1,a6
    80005658:	577d                	li	a4,-1
    8000565a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000565e:	00461713          	slli	a4,a2,0x4
    80005662:	6290                	ld	a2,0(a3)
    80005664:	963a                	add	a2,a2,a4
    80005666:	03078793          	addi	a5,a5,48
    8000566a:	97c2                	add	a5,a5,a6
    8000566c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000566e:	629c                	ld	a5,0(a3)
    80005670:	97ba                	add	a5,a5,a4
    80005672:	4605                	li	a2,1
    80005674:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005676:	629c                	ld	a5,0(a3)
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	4809                	li	a6,2
    8000567c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005680:	629c                	ld	a5,0(a3)
    80005682:	97ba                	add	a5,a5,a4
    80005684:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005688:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000568c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005690:	6698                	ld	a4,8(a3)
    80005692:	00275783          	lhu	a5,2(a4)
    80005696:	8b9d                	andi	a5,a5,7
    80005698:	0786                	slli	a5,a5,0x1
    8000569a:	973e                	add	a4,a4,a5
    8000569c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800056a0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056a4:	6698                	ld	a4,8(a3)
    800056a6:	00275783          	lhu	a5,2(a4)
    800056aa:	2785                	addiw	a5,a5,1
    800056ac:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056b0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056b4:	100017b7          	lui	a5,0x10001
    800056b8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056bc:	004aa783          	lw	a5,4(s5)
    800056c0:	02c79163          	bne	a5,a2,800056e2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056c4:	00018917          	auipc	s2,0x18
    800056c8:	a6490913          	addi	s2,s2,-1436 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056cc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ce:	85ca                	mv	a1,s2
    800056d0:	8556                	mv	a0,s5
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	fee080e7          	jalr	-18(ra) # 800016c0 <sleep>
  while(b->disk == 1) {
    800056da:	004aa783          	lw	a5,4(s5)
    800056de:	fe9788e3          	beq	a5,s1,800056ce <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056e2:	f8042903          	lw	s2,-128(s0)
    800056e6:	20090713          	addi	a4,s2,512
    800056ea:	0712                	slli	a4,a4,0x4
    800056ec:	00016797          	auipc	a5,0x16
    800056f0:	91478793          	addi	a5,a5,-1772 # 8001b000 <disk>
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056fa:	00018997          	auipc	s3,0x18
    800056fe:	90698993          	addi	s3,s3,-1786 # 8001d000 <disk+0x2000>
    80005702:	00491713          	slli	a4,s2,0x4
    80005706:	0009b783          	ld	a5,0(s3)
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005710:	854a                	mv	a0,s2
    80005712:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	c60080e7          	jalr	-928(ra) # 80005376 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000571e:	8885                	andi	s1,s1,1
    80005720:	f0ed                	bnez	s1,80005702 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005722:	00018517          	auipc	a0,0x18
    80005726:	a0650513          	addi	a0,a0,-1530 # 8001d128 <disk+0x2128>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	c82080e7          	jalr	-894(ra) # 800063ac <release>
}
    80005732:	70e6                	ld	ra,120(sp)
    80005734:	7446                	ld	s0,112(sp)
    80005736:	74a6                	ld	s1,104(sp)
    80005738:	7906                	ld	s2,96(sp)
    8000573a:	69e6                	ld	s3,88(sp)
    8000573c:	6a46                	ld	s4,80(sp)
    8000573e:	6aa6                	ld	s5,72(sp)
    80005740:	6b06                	ld	s6,64(sp)
    80005742:	7be2                	ld	s7,56(sp)
    80005744:	7c42                	ld	s8,48(sp)
    80005746:	7ca2                	ld	s9,40(sp)
    80005748:	7d02                	ld	s10,32(sp)
    8000574a:	6de2                	ld	s11,24(sp)
    8000574c:	6109                	addi	sp,sp,128
    8000574e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005750:	f8042503          	lw	a0,-128(s0)
    80005754:	20050793          	addi	a5,a0,512
    80005758:	0792                	slli	a5,a5,0x4
  if(write)
    8000575a:	00016817          	auipc	a6,0x16
    8000575e:	8a680813          	addi	a6,a6,-1882 # 8001b000 <disk>
    80005762:	00f80733          	add	a4,a6,a5
    80005766:	01a036b3          	snez	a3,s10
    8000576a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000576e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005772:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005776:	7679                	lui	a2,0xffffe
    80005778:	963e                	add	a2,a2,a5
    8000577a:	00018697          	auipc	a3,0x18
    8000577e:	88668693          	addi	a3,a3,-1914 # 8001d000 <disk+0x2000>
    80005782:	6298                	ld	a4,0(a3)
    80005784:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005786:	0a878593          	addi	a1,a5,168
    8000578a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000578c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000578e:	6298                	ld	a4,0(a3)
    80005790:	9732                	add	a4,a4,a2
    80005792:	45c1                	li	a1,16
    80005794:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005796:	6298                	ld	a4,0(a3)
    80005798:	9732                	add	a4,a4,a2
    8000579a:	4585                	li	a1,1
    8000579c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057a0:	f8442703          	lw	a4,-124(s0)
    800057a4:	628c                	ld	a1,0(a3)
    800057a6:	962e                	add	a2,a2,a1
    800057a8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800057ac:	0712                	slli	a4,a4,0x4
    800057ae:	6290                	ld	a2,0(a3)
    800057b0:	963a                	add	a2,a2,a4
    800057b2:	058a8593          	addi	a1,s5,88
    800057b6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057b8:	6294                	ld	a3,0(a3)
    800057ba:	96ba                	add	a3,a3,a4
    800057bc:	40000613          	li	a2,1024
    800057c0:	c690                	sw	a2,8(a3)
  if(write)
    800057c2:	e40d1ae3          	bnez	s10,80005616 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057c6:	00018697          	auipc	a3,0x18
    800057ca:	83a6b683          	ld	a3,-1990(a3) # 8001d000 <disk+0x2000>
    800057ce:	96ba                	add	a3,a3,a4
    800057d0:	4609                	li	a2,2
    800057d2:	00c69623          	sh	a2,12(a3)
    800057d6:	b5b9                	j	80005624 <virtio_disk_rw+0xd2>

00000000800057d8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057d8:	1101                	addi	sp,sp,-32
    800057da:	ec06                	sd	ra,24(sp)
    800057dc:	e822                	sd	s0,16(sp)
    800057de:	e426                	sd	s1,8(sp)
    800057e0:	e04a                	sd	s2,0(sp)
    800057e2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e4:	00018517          	auipc	a0,0x18
    800057e8:	94450513          	addi	a0,a0,-1724 # 8001d128 <disk+0x2128>
    800057ec:	00001097          	auipc	ra,0x1
    800057f0:	b0c080e7          	jalr	-1268(ra) # 800062f8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f4:	10001737          	lui	a4,0x10001
    800057f8:	533c                	lw	a5,96(a4)
    800057fa:	8b8d                	andi	a5,a5,3
    800057fc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057fe:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005802:	00017797          	auipc	a5,0x17
    80005806:	7fe78793          	addi	a5,a5,2046 # 8001d000 <disk+0x2000>
    8000580a:	6b94                	ld	a3,16(a5)
    8000580c:	0207d703          	lhu	a4,32(a5)
    80005810:	0026d783          	lhu	a5,2(a3)
    80005814:	06f70163          	beq	a4,a5,80005876 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005818:	00015917          	auipc	s2,0x15
    8000581c:	7e890913          	addi	s2,s2,2024 # 8001b000 <disk>
    80005820:	00017497          	auipc	s1,0x17
    80005824:	7e048493          	addi	s1,s1,2016 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005828:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000582c:	6898                	ld	a4,16(s1)
    8000582e:	0204d783          	lhu	a5,32(s1)
    80005832:	8b9d                	andi	a5,a5,7
    80005834:	078e                	slli	a5,a5,0x3
    80005836:	97ba                	add	a5,a5,a4
    80005838:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583a:	20078713          	addi	a4,a5,512
    8000583e:	0712                	slli	a4,a4,0x4
    80005840:	974a                	add	a4,a4,s2
    80005842:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005846:	e731                	bnez	a4,80005892 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005848:	20078793          	addi	a5,a5,512
    8000584c:	0792                	slli	a5,a5,0x4
    8000584e:	97ca                	add	a5,a5,s2
    80005850:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005852:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005856:	ffffc097          	auipc	ra,0xffffc
    8000585a:	ff6080e7          	jalr	-10(ra) # 8000184c <wakeup>

    disk.used_idx += 1;
    8000585e:	0204d783          	lhu	a5,32(s1)
    80005862:	2785                	addiw	a5,a5,1
    80005864:	17c2                	slli	a5,a5,0x30
    80005866:	93c1                	srli	a5,a5,0x30
    80005868:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000586c:	6898                	ld	a4,16(s1)
    8000586e:	00275703          	lhu	a4,2(a4)
    80005872:	faf71be3          	bne	a4,a5,80005828 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005876:	00018517          	auipc	a0,0x18
    8000587a:	8b250513          	addi	a0,a0,-1870 # 8001d128 <disk+0x2128>
    8000587e:	00001097          	auipc	ra,0x1
    80005882:	b2e080e7          	jalr	-1234(ra) # 800063ac <release>
}
    80005886:	60e2                	ld	ra,24(sp)
    80005888:	6442                	ld	s0,16(sp)
    8000588a:	64a2                	ld	s1,8(sp)
    8000588c:	6902                	ld	s2,0(sp)
    8000588e:	6105                	addi	sp,sp,32
    80005890:	8082                	ret
      panic("virtio_disk_intr status");
    80005892:	00003517          	auipc	a0,0x3
    80005896:	f5e50513          	addi	a0,a0,-162 # 800087f0 <syscalls+0x3f0>
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	526080e7          	jalr	1318(ra) # 80005dc0 <panic>

00000000800058a2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a2:	1141                	addi	sp,sp,-16
    800058a4:	e422                	sd	s0,8(sp)
    800058a6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058a8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058ac:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b0:	0037979b          	slliw	a5,a5,0x3
    800058b4:	02004737          	lui	a4,0x2004
    800058b8:	97ba                	add	a5,a5,a4
    800058ba:	0200c737          	lui	a4,0x200c
    800058be:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c2:	000f4637          	lui	a2,0xf4
    800058c6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ca:	9732                	add	a4,a4,a2
    800058cc:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058ce:	00259693          	slli	a3,a1,0x2
    800058d2:	96ae                	add	a3,a3,a1
    800058d4:	068e                	slli	a3,a3,0x3
    800058d6:	00018717          	auipc	a4,0x18
    800058da:	72a70713          	addi	a4,a4,1834 # 8001e000 <timer_scratch>
    800058de:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058e4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058e8:	00000797          	auipc	a5,0x0
    800058ec:	9c878793          	addi	a5,a5,-1592 # 800052b0 <timervec>
    800058f0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058f8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058fc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005900:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005904:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005908:	30479073          	csrw	mie,a5
}
    8000590c:	6422                	ld	s0,8(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <start>:
{
    80005912:	1141                	addi	sp,sp,-16
    80005914:	e406                	sd	ra,8(sp)
    80005916:	e022                	sd	s0,0(sp)
    80005918:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000591a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000591e:	7779                	lui	a4,0xffffe
    80005920:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005924:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005926:	6705                	lui	a4,0x1
    80005928:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000592c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000592e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005932:	ffffb797          	auipc	a5,0xffffb
    80005936:	9ee78793          	addi	a5,a5,-1554 # 80000320 <main>
    8000593a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000593e:	4781                	li	a5,0
    80005940:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005944:	67c1                	lui	a5,0x10
    80005946:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005948:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000594c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005950:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005954:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005958:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000595c:	57fd                	li	a5,-1
    8000595e:	83a9                	srli	a5,a5,0xa
    80005960:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005964:	47bd                	li	a5,15
    80005966:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000596a:	00000097          	auipc	ra,0x0
    8000596e:	f38080e7          	jalr	-200(ra) # 800058a2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005972:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005976:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005978:	823e                	mv	tp,a5
  asm volatile("mret");
    8000597a:	30200073          	mret
}
    8000597e:	60a2                	ld	ra,8(sp)
    80005980:	6402                	ld	s0,0(sp)
    80005982:	0141                	addi	sp,sp,16
    80005984:	8082                	ret

0000000080005986 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005986:	715d                	addi	sp,sp,-80
    80005988:	e486                	sd	ra,72(sp)
    8000598a:	e0a2                	sd	s0,64(sp)
    8000598c:	fc26                	sd	s1,56(sp)
    8000598e:	f84a                	sd	s2,48(sp)
    80005990:	f44e                	sd	s3,40(sp)
    80005992:	f052                	sd	s4,32(sp)
    80005994:	ec56                	sd	s5,24(sp)
    80005996:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005998:	04c05763          	blez	a2,800059e6 <consolewrite+0x60>
    8000599c:	8a2a                	mv	s4,a0
    8000599e:	84ae                	mv	s1,a1
    800059a0:	89b2                	mv	s3,a2
    800059a2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059a4:	5afd                	li	s5,-1
    800059a6:	4685                	li	a3,1
    800059a8:	8626                	mv	a2,s1
    800059aa:	85d2                	mv	a1,s4
    800059ac:	fbf40513          	addi	a0,s0,-65
    800059b0:	ffffc097          	auipc	ra,0xffffc
    800059b4:	10a080e7          	jalr	266(ra) # 80001aba <either_copyin>
    800059b8:	01550d63          	beq	a0,s5,800059d2 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059bc:	fbf44503          	lbu	a0,-65(s0)
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	77e080e7          	jalr	1918(ra) # 8000613e <uartputc>
  for(i = 0; i < n; i++){
    800059c8:	2905                	addiw	s2,s2,1
    800059ca:	0485                	addi	s1,s1,1
    800059cc:	fd299de3          	bne	s3,s2,800059a6 <consolewrite+0x20>
    800059d0:	894e                	mv	s2,s3
  }

  return i;
}
    800059d2:	854a                	mv	a0,s2
    800059d4:	60a6                	ld	ra,72(sp)
    800059d6:	6406                	ld	s0,64(sp)
    800059d8:	74e2                	ld	s1,56(sp)
    800059da:	7942                	ld	s2,48(sp)
    800059dc:	79a2                	ld	s3,40(sp)
    800059de:	7a02                	ld	s4,32(sp)
    800059e0:	6ae2                	ld	s5,24(sp)
    800059e2:	6161                	addi	sp,sp,80
    800059e4:	8082                	ret
  for(i = 0; i < n; i++){
    800059e6:	4901                	li	s2,0
    800059e8:	b7ed                	j	800059d2 <consolewrite+0x4c>

00000000800059ea <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ea:	7159                	addi	sp,sp,-112
    800059ec:	f486                	sd	ra,104(sp)
    800059ee:	f0a2                	sd	s0,96(sp)
    800059f0:	eca6                	sd	s1,88(sp)
    800059f2:	e8ca                	sd	s2,80(sp)
    800059f4:	e4ce                	sd	s3,72(sp)
    800059f6:	e0d2                	sd	s4,64(sp)
    800059f8:	fc56                	sd	s5,56(sp)
    800059fa:	f85a                	sd	s6,48(sp)
    800059fc:	f45e                	sd	s7,40(sp)
    800059fe:	f062                	sd	s8,32(sp)
    80005a00:	ec66                	sd	s9,24(sp)
    80005a02:	e86a                	sd	s10,16(sp)
    80005a04:	1880                	addi	s0,sp,112
    80005a06:	8aaa                	mv	s5,a0
    80005a08:	8a2e                	mv	s4,a1
    80005a0a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a0c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a10:	00020517          	auipc	a0,0x20
    80005a14:	73050513          	addi	a0,a0,1840 # 80026140 <cons>
    80005a18:	00001097          	auipc	ra,0x1
    80005a1c:	8e0080e7          	jalr	-1824(ra) # 800062f8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a20:	00020497          	auipc	s1,0x20
    80005a24:	72048493          	addi	s1,s1,1824 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a28:	00020917          	auipc	s2,0x20
    80005a2c:	7b090913          	addi	s2,s2,1968 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a30:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a32:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a34:	4ca9                	li	s9,10
  while(n > 0){
    80005a36:	07305863          	blez	s3,80005aa6 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a3a:	0984a783          	lw	a5,152(s1)
    80005a3e:	09c4a703          	lw	a4,156(s1)
    80005a42:	02f71463          	bne	a4,a5,80005a6a <consoleread+0x80>
      if(myproc()->killed){
    80005a46:	ffffb097          	auipc	ra,0xffffb
    80005a4a:	4fc080e7          	jalr	1276(ra) # 80000f42 <myproc>
    80005a4e:	551c                	lw	a5,40(a0)
    80005a50:	e7b5                	bnez	a5,80005abc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a52:	85a6                	mv	a1,s1
    80005a54:	854a                	mv	a0,s2
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	c6a080e7          	jalr	-918(ra) # 800016c0 <sleep>
    while(cons.r == cons.w){
    80005a5e:	0984a783          	lw	a5,152(s1)
    80005a62:	09c4a703          	lw	a4,156(s1)
    80005a66:	fef700e3          	beq	a4,a5,80005a46 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a6a:	0017871b          	addiw	a4,a5,1
    80005a6e:	08e4ac23          	sw	a4,152(s1)
    80005a72:	07f7f713          	andi	a4,a5,127
    80005a76:	9726                	add	a4,a4,s1
    80005a78:	01874703          	lbu	a4,24(a4)
    80005a7c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a80:	077d0563          	beq	s10,s7,80005aea <consoleread+0x100>
    cbuf = c;
    80005a84:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a88:	4685                	li	a3,1
    80005a8a:	f9f40613          	addi	a2,s0,-97
    80005a8e:	85d2                	mv	a1,s4
    80005a90:	8556                	mv	a0,s5
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	fd2080e7          	jalr	-46(ra) # 80001a64 <either_copyout>
    80005a9a:	01850663          	beq	a0,s8,80005aa6 <consoleread+0xbc>
    dst++;
    80005a9e:	0a05                	addi	s4,s4,1
    --n;
    80005aa0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005aa2:	f99d1ae3          	bne	s10,s9,80005a36 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aa6:	00020517          	auipc	a0,0x20
    80005aaa:	69a50513          	addi	a0,a0,1690 # 80026140 <cons>
    80005aae:	00001097          	auipc	ra,0x1
    80005ab2:	8fe080e7          	jalr	-1794(ra) # 800063ac <release>

  return target - n;
    80005ab6:	413b053b          	subw	a0,s6,s3
    80005aba:	a811                	j	80005ace <consoleread+0xe4>
        release(&cons.lock);
    80005abc:	00020517          	auipc	a0,0x20
    80005ac0:	68450513          	addi	a0,a0,1668 # 80026140 <cons>
    80005ac4:	00001097          	auipc	ra,0x1
    80005ac8:	8e8080e7          	jalr	-1816(ra) # 800063ac <release>
        return -1;
    80005acc:	557d                	li	a0,-1
}
    80005ace:	70a6                	ld	ra,104(sp)
    80005ad0:	7406                	ld	s0,96(sp)
    80005ad2:	64e6                	ld	s1,88(sp)
    80005ad4:	6946                	ld	s2,80(sp)
    80005ad6:	69a6                	ld	s3,72(sp)
    80005ad8:	6a06                	ld	s4,64(sp)
    80005ada:	7ae2                	ld	s5,56(sp)
    80005adc:	7b42                	ld	s6,48(sp)
    80005ade:	7ba2                	ld	s7,40(sp)
    80005ae0:	7c02                	ld	s8,32(sp)
    80005ae2:	6ce2                	ld	s9,24(sp)
    80005ae4:	6d42                	ld	s10,16(sp)
    80005ae6:	6165                	addi	sp,sp,112
    80005ae8:	8082                	ret
      if(n < target){
    80005aea:	0009871b          	sext.w	a4,s3
    80005aee:	fb677ce3          	bgeu	a4,s6,80005aa6 <consoleread+0xbc>
        cons.r--;
    80005af2:	00020717          	auipc	a4,0x20
    80005af6:	6ef72323          	sw	a5,1766(a4) # 800261d8 <cons+0x98>
    80005afa:	b775                	j	80005aa6 <consoleread+0xbc>

0000000080005afc <consputc>:
{
    80005afc:	1141                	addi	sp,sp,-16
    80005afe:	e406                	sd	ra,8(sp)
    80005b00:	e022                	sd	s0,0(sp)
    80005b02:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b04:	10000793          	li	a5,256
    80005b08:	00f50a63          	beq	a0,a5,80005b1c <consputc+0x20>
    uartputc_sync(c);
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	560080e7          	jalr	1376(ra) # 8000606c <uartputc_sync>
}
    80005b14:	60a2                	ld	ra,8(sp)
    80005b16:	6402                	ld	s0,0(sp)
    80005b18:	0141                	addi	sp,sp,16
    80005b1a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b1c:	4521                	li	a0,8
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	54e080e7          	jalr	1358(ra) # 8000606c <uartputc_sync>
    80005b26:	02000513          	li	a0,32
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	542080e7          	jalr	1346(ra) # 8000606c <uartputc_sync>
    80005b32:	4521                	li	a0,8
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	538080e7          	jalr	1336(ra) # 8000606c <uartputc_sync>
    80005b3c:	bfe1                	j	80005b14 <consputc+0x18>

0000000080005b3e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b3e:	1101                	addi	sp,sp,-32
    80005b40:	ec06                	sd	ra,24(sp)
    80005b42:	e822                	sd	s0,16(sp)
    80005b44:	e426                	sd	s1,8(sp)
    80005b46:	e04a                	sd	s2,0(sp)
    80005b48:	1000                	addi	s0,sp,32
    80005b4a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b4c:	00020517          	auipc	a0,0x20
    80005b50:	5f450513          	addi	a0,a0,1524 # 80026140 <cons>
    80005b54:	00000097          	auipc	ra,0x0
    80005b58:	7a4080e7          	jalr	1956(ra) # 800062f8 <acquire>

  switch(c){
    80005b5c:	47d5                	li	a5,21
    80005b5e:	0af48663          	beq	s1,a5,80005c0a <consoleintr+0xcc>
    80005b62:	0297ca63          	blt	a5,s1,80005b96 <consoleintr+0x58>
    80005b66:	47a1                	li	a5,8
    80005b68:	0ef48763          	beq	s1,a5,80005c56 <consoleintr+0x118>
    80005b6c:	47c1                	li	a5,16
    80005b6e:	10f49a63          	bne	s1,a5,80005c82 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b72:	ffffc097          	auipc	ra,0xffffc
    80005b76:	f9e080e7          	jalr	-98(ra) # 80001b10 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b7a:	00020517          	auipc	a0,0x20
    80005b7e:	5c650513          	addi	a0,a0,1478 # 80026140 <cons>
    80005b82:	00001097          	auipc	ra,0x1
    80005b86:	82a080e7          	jalr	-2006(ra) # 800063ac <release>
}
    80005b8a:	60e2                	ld	ra,24(sp)
    80005b8c:	6442                	ld	s0,16(sp)
    80005b8e:	64a2                	ld	s1,8(sp)
    80005b90:	6902                	ld	s2,0(sp)
    80005b92:	6105                	addi	sp,sp,32
    80005b94:	8082                	ret
  switch(c){
    80005b96:	07f00793          	li	a5,127
    80005b9a:	0af48e63          	beq	s1,a5,80005c56 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b9e:	00020717          	auipc	a4,0x20
    80005ba2:	5a270713          	addi	a4,a4,1442 # 80026140 <cons>
    80005ba6:	0a072783          	lw	a5,160(a4)
    80005baa:	09872703          	lw	a4,152(a4)
    80005bae:	9f99                	subw	a5,a5,a4
    80005bb0:	07f00713          	li	a4,127
    80005bb4:	fcf763e3          	bltu	a4,a5,80005b7a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bb8:	47b5                	li	a5,13
    80005bba:	0cf48763          	beq	s1,a5,80005c88 <consoleintr+0x14a>
      consputc(c);
    80005bbe:	8526                	mv	a0,s1
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	f3c080e7          	jalr	-196(ra) # 80005afc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc8:	00020797          	auipc	a5,0x20
    80005bcc:	57878793          	addi	a5,a5,1400 # 80026140 <cons>
    80005bd0:	0a07a703          	lw	a4,160(a5)
    80005bd4:	0017069b          	addiw	a3,a4,1
    80005bd8:	0006861b          	sext.w	a2,a3
    80005bdc:	0ad7a023          	sw	a3,160(a5)
    80005be0:	07f77713          	andi	a4,a4,127
    80005be4:	97ba                	add	a5,a5,a4
    80005be6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bea:	47a9                	li	a5,10
    80005bec:	0cf48563          	beq	s1,a5,80005cb6 <consoleintr+0x178>
    80005bf0:	4791                	li	a5,4
    80005bf2:	0cf48263          	beq	s1,a5,80005cb6 <consoleintr+0x178>
    80005bf6:	00020797          	auipc	a5,0x20
    80005bfa:	5e27a783          	lw	a5,1506(a5) # 800261d8 <cons+0x98>
    80005bfe:	0807879b          	addiw	a5,a5,128
    80005c02:	f6f61ce3          	bne	a2,a5,80005b7a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c06:	863e                	mv	a2,a5
    80005c08:	a07d                	j	80005cb6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c0a:	00020717          	auipc	a4,0x20
    80005c0e:	53670713          	addi	a4,a4,1334 # 80026140 <cons>
    80005c12:	0a072783          	lw	a5,160(a4)
    80005c16:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c1a:	00020497          	auipc	s1,0x20
    80005c1e:	52648493          	addi	s1,s1,1318 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c22:	4929                	li	s2,10
    80005c24:	f4f70be3          	beq	a4,a5,80005b7a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c28:	37fd                	addiw	a5,a5,-1
    80005c2a:	07f7f713          	andi	a4,a5,127
    80005c2e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c30:	01874703          	lbu	a4,24(a4)
    80005c34:	f52703e3          	beq	a4,s2,80005b7a <consoleintr+0x3c>
      cons.e--;
    80005c38:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c3c:	10000513          	li	a0,256
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	ebc080e7          	jalr	-324(ra) # 80005afc <consputc>
    while(cons.e != cons.w &&
    80005c48:	0a04a783          	lw	a5,160(s1)
    80005c4c:	09c4a703          	lw	a4,156(s1)
    80005c50:	fcf71ce3          	bne	a4,a5,80005c28 <consoleintr+0xea>
    80005c54:	b71d                	j	80005b7a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c56:	00020717          	auipc	a4,0x20
    80005c5a:	4ea70713          	addi	a4,a4,1258 # 80026140 <cons>
    80005c5e:	0a072783          	lw	a5,160(a4)
    80005c62:	09c72703          	lw	a4,156(a4)
    80005c66:	f0f70ae3          	beq	a4,a5,80005b7a <consoleintr+0x3c>
      cons.e--;
    80005c6a:	37fd                	addiw	a5,a5,-1
    80005c6c:	00020717          	auipc	a4,0x20
    80005c70:	56f72a23          	sw	a5,1396(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c74:	10000513          	li	a0,256
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	e84080e7          	jalr	-380(ra) # 80005afc <consputc>
    80005c80:	bded                	j	80005b7a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c82:	ee048ce3          	beqz	s1,80005b7a <consoleintr+0x3c>
    80005c86:	bf21                	j	80005b9e <consoleintr+0x60>
      consputc(c);
    80005c88:	4529                	li	a0,10
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	e72080e7          	jalr	-398(ra) # 80005afc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c92:	00020797          	auipc	a5,0x20
    80005c96:	4ae78793          	addi	a5,a5,1198 # 80026140 <cons>
    80005c9a:	0a07a703          	lw	a4,160(a5)
    80005c9e:	0017069b          	addiw	a3,a4,1
    80005ca2:	0006861b          	sext.w	a2,a3
    80005ca6:	0ad7a023          	sw	a3,160(a5)
    80005caa:	07f77713          	andi	a4,a4,127
    80005cae:	97ba                	add	a5,a5,a4
    80005cb0:	4729                	li	a4,10
    80005cb2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cb6:	00020797          	auipc	a5,0x20
    80005cba:	52c7a323          	sw	a2,1318(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cbe:	00020517          	auipc	a0,0x20
    80005cc2:	51a50513          	addi	a0,a0,1306 # 800261d8 <cons+0x98>
    80005cc6:	ffffc097          	auipc	ra,0xffffc
    80005cca:	b86080e7          	jalr	-1146(ra) # 8000184c <wakeup>
    80005cce:	b575                	j	80005b7a <consoleintr+0x3c>

0000000080005cd0 <consoleinit>:

void
consoleinit(void)
{
    80005cd0:	1141                	addi	sp,sp,-16
    80005cd2:	e406                	sd	ra,8(sp)
    80005cd4:	e022                	sd	s0,0(sp)
    80005cd6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cd8:	00003597          	auipc	a1,0x3
    80005cdc:	b3058593          	addi	a1,a1,-1232 # 80008808 <syscalls+0x408>
    80005ce0:	00020517          	auipc	a0,0x20
    80005ce4:	46050513          	addi	a0,a0,1120 # 80026140 <cons>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	580080e7          	jalr	1408(ra) # 80006268 <initlock>

  uartinit();
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	32c080e7          	jalr	812(ra) # 8000601c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cf8:	00013797          	auipc	a5,0x13
    80005cfc:	5d078793          	addi	a5,a5,1488 # 800192c8 <devsw>
    80005d00:	00000717          	auipc	a4,0x0
    80005d04:	cea70713          	addi	a4,a4,-790 # 800059ea <consoleread>
    80005d08:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	c7c70713          	addi	a4,a4,-900 # 80005986 <consolewrite>
    80005d12:	ef98                	sd	a4,24(a5)
}
    80005d14:	60a2                	ld	ra,8(sp)
    80005d16:	6402                	ld	s0,0(sp)
    80005d18:	0141                	addi	sp,sp,16
    80005d1a:	8082                	ret

0000000080005d1c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d1c:	7179                	addi	sp,sp,-48
    80005d1e:	f406                	sd	ra,40(sp)
    80005d20:	f022                	sd	s0,32(sp)
    80005d22:	ec26                	sd	s1,24(sp)
    80005d24:	e84a                	sd	s2,16(sp)
    80005d26:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d28:	c219                	beqz	a2,80005d2e <printint+0x12>
    80005d2a:	08054763          	bltz	a0,80005db8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d2e:	2501                	sext.w	a0,a0
    80005d30:	4881                	li	a7,0
    80005d32:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d36:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d38:	2581                	sext.w	a1,a1
    80005d3a:	00003617          	auipc	a2,0x3
    80005d3e:	afe60613          	addi	a2,a2,-1282 # 80008838 <digits>
    80005d42:	883a                	mv	a6,a4
    80005d44:	2705                	addiw	a4,a4,1
    80005d46:	02b577bb          	remuw	a5,a0,a1
    80005d4a:	1782                	slli	a5,a5,0x20
    80005d4c:	9381                	srli	a5,a5,0x20
    80005d4e:	97b2                	add	a5,a5,a2
    80005d50:	0007c783          	lbu	a5,0(a5)
    80005d54:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d58:	0005079b          	sext.w	a5,a0
    80005d5c:	02b5553b          	divuw	a0,a0,a1
    80005d60:	0685                	addi	a3,a3,1
    80005d62:	feb7f0e3          	bgeu	a5,a1,80005d42 <printint+0x26>

  if(sign)
    80005d66:	00088c63          	beqz	a7,80005d7e <printint+0x62>
    buf[i++] = '-';
    80005d6a:	fe070793          	addi	a5,a4,-32
    80005d6e:	00878733          	add	a4,a5,s0
    80005d72:	02d00793          	li	a5,45
    80005d76:	fef70823          	sb	a5,-16(a4)
    80005d7a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d7e:	02e05763          	blez	a4,80005dac <printint+0x90>
    80005d82:	fd040793          	addi	a5,s0,-48
    80005d86:	00e784b3          	add	s1,a5,a4
    80005d8a:	fff78913          	addi	s2,a5,-1
    80005d8e:	993a                	add	s2,s2,a4
    80005d90:	377d                	addiw	a4,a4,-1
    80005d92:	1702                	slli	a4,a4,0x20
    80005d94:	9301                	srli	a4,a4,0x20
    80005d96:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d9a:	fff4c503          	lbu	a0,-1(s1)
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	d5e080e7          	jalr	-674(ra) # 80005afc <consputc>
  while(--i >= 0)
    80005da6:	14fd                	addi	s1,s1,-1
    80005da8:	ff2499e3          	bne	s1,s2,80005d9a <printint+0x7e>
}
    80005dac:	70a2                	ld	ra,40(sp)
    80005dae:	7402                	ld	s0,32(sp)
    80005db0:	64e2                	ld	s1,24(sp)
    80005db2:	6942                	ld	s2,16(sp)
    80005db4:	6145                	addi	sp,sp,48
    80005db6:	8082                	ret
    x = -xx;
    80005db8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dbc:	4885                	li	a7,1
    x = -xx;
    80005dbe:	bf95                	j	80005d32 <printint+0x16>

0000000080005dc0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc0:	1101                	addi	sp,sp,-32
    80005dc2:	ec06                	sd	ra,24(sp)
    80005dc4:	e822                	sd	s0,16(sp)
    80005dc6:	e426                	sd	s1,8(sp)
    80005dc8:	1000                	addi	s0,sp,32
    80005dca:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dcc:	00020797          	auipc	a5,0x20
    80005dd0:	4207aa23          	sw	zero,1076(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005dd4:	00003517          	auipc	a0,0x3
    80005dd8:	a3c50513          	addi	a0,a0,-1476 # 80008810 <syscalls+0x410>
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	02e080e7          	jalr	46(ra) # 80005e0a <printf>
  printf(s);
    80005de4:	8526                	mv	a0,s1
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	024080e7          	jalr	36(ra) # 80005e0a <printf>
  printf("\n");
    80005dee:	00002517          	auipc	a0,0x2
    80005df2:	25a50513          	addi	a0,a0,602 # 80008048 <etext+0x48>
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	014080e7          	jalr	20(ra) # 80005e0a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dfe:	4785                	li	a5,1
    80005e00:	00003717          	auipc	a4,0x3
    80005e04:	20f72e23          	sw	a5,540(a4) # 8000901c <panicked>
  for(;;)
    80005e08:	a001                	j	80005e08 <panic+0x48>

0000000080005e0a <printf>:
{
    80005e0a:	7131                	addi	sp,sp,-192
    80005e0c:	fc86                	sd	ra,120(sp)
    80005e0e:	f8a2                	sd	s0,112(sp)
    80005e10:	f4a6                	sd	s1,104(sp)
    80005e12:	f0ca                	sd	s2,96(sp)
    80005e14:	ecce                	sd	s3,88(sp)
    80005e16:	e8d2                	sd	s4,80(sp)
    80005e18:	e4d6                	sd	s5,72(sp)
    80005e1a:	e0da                	sd	s6,64(sp)
    80005e1c:	fc5e                	sd	s7,56(sp)
    80005e1e:	f862                	sd	s8,48(sp)
    80005e20:	f466                	sd	s9,40(sp)
    80005e22:	f06a                	sd	s10,32(sp)
    80005e24:	ec6e                	sd	s11,24(sp)
    80005e26:	0100                	addi	s0,sp,128
    80005e28:	8a2a                	mv	s4,a0
    80005e2a:	e40c                	sd	a1,8(s0)
    80005e2c:	e810                	sd	a2,16(s0)
    80005e2e:	ec14                	sd	a3,24(s0)
    80005e30:	f018                	sd	a4,32(s0)
    80005e32:	f41c                	sd	a5,40(s0)
    80005e34:	03043823          	sd	a6,48(s0)
    80005e38:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e3c:	00020d97          	auipc	s11,0x20
    80005e40:	3c4dad83          	lw	s11,964(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e44:	020d9b63          	bnez	s11,80005e7a <printf+0x70>
  if (fmt == 0)
    80005e48:	040a0263          	beqz	s4,80005e8c <printf+0x82>
  va_start(ap, fmt);
    80005e4c:	00840793          	addi	a5,s0,8
    80005e50:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e54:	000a4503          	lbu	a0,0(s4)
    80005e58:	14050f63          	beqz	a0,80005fb6 <printf+0x1ac>
    80005e5c:	4981                	li	s3,0
    if(c != '%'){
    80005e5e:	02500a93          	li	s5,37
    switch(c){
    80005e62:	07000b93          	li	s7,112
  consputc('x');
    80005e66:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e68:	00003b17          	auipc	s6,0x3
    80005e6c:	9d0b0b13          	addi	s6,s6,-1584 # 80008838 <digits>
    switch(c){
    80005e70:	07300c93          	li	s9,115
    80005e74:	06400c13          	li	s8,100
    80005e78:	a82d                	j	80005eb2 <printf+0xa8>
    acquire(&pr.lock);
    80005e7a:	00020517          	auipc	a0,0x20
    80005e7e:	36e50513          	addi	a0,a0,878 # 800261e8 <pr>
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	476080e7          	jalr	1142(ra) # 800062f8 <acquire>
    80005e8a:	bf7d                	j	80005e48 <printf+0x3e>
    panic("null fmt");
    80005e8c:	00003517          	auipc	a0,0x3
    80005e90:	99450513          	addi	a0,a0,-1644 # 80008820 <syscalls+0x420>
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	f2c080e7          	jalr	-212(ra) # 80005dc0 <panic>
      consputc(c);
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	c60080e7          	jalr	-928(ra) # 80005afc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ea4:	2985                	addiw	s3,s3,1
    80005ea6:	013a07b3          	add	a5,s4,s3
    80005eaa:	0007c503          	lbu	a0,0(a5)
    80005eae:	10050463          	beqz	a0,80005fb6 <printf+0x1ac>
    if(c != '%'){
    80005eb2:	ff5515e3          	bne	a0,s5,80005e9c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eb6:	2985                	addiw	s3,s3,1
    80005eb8:	013a07b3          	add	a5,s4,s3
    80005ebc:	0007c783          	lbu	a5,0(a5)
    80005ec0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ec4:	cbed                	beqz	a5,80005fb6 <printf+0x1ac>
    switch(c){
    80005ec6:	05778a63          	beq	a5,s7,80005f1a <printf+0x110>
    80005eca:	02fbf663          	bgeu	s7,a5,80005ef6 <printf+0xec>
    80005ece:	09978863          	beq	a5,s9,80005f5e <printf+0x154>
    80005ed2:	07800713          	li	a4,120
    80005ed6:	0ce79563          	bne	a5,a4,80005fa0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	4605                	li	a2,1
    80005ee8:	85ea                	mv	a1,s10
    80005eea:	4388                	lw	a0,0(a5)
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e30080e7          	jalr	-464(ra) # 80005d1c <printint>
      break;
    80005ef4:	bf45                	j	80005ea4 <printf+0x9a>
    switch(c){
    80005ef6:	09578f63          	beq	a5,s5,80005f94 <printf+0x18a>
    80005efa:	0b879363          	bne	a5,s8,80005fa0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005efe:	f8843783          	ld	a5,-120(s0)
    80005f02:	00878713          	addi	a4,a5,8
    80005f06:	f8e43423          	sd	a4,-120(s0)
    80005f0a:	4605                	li	a2,1
    80005f0c:	45a9                	li	a1,10
    80005f0e:	4388                	lw	a0,0(a5)
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	e0c080e7          	jalr	-500(ra) # 80005d1c <printint>
      break;
    80005f18:	b771                	j	80005ea4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f1a:	f8843783          	ld	a5,-120(s0)
    80005f1e:	00878713          	addi	a4,a5,8
    80005f22:	f8e43423          	sd	a4,-120(s0)
    80005f26:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f2a:	03000513          	li	a0,48
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	bce080e7          	jalr	-1074(ra) # 80005afc <consputc>
  consputc('x');
    80005f36:	07800513          	li	a0,120
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	bc2080e7          	jalr	-1086(ra) # 80005afc <consputc>
    80005f42:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f44:	03c95793          	srli	a5,s2,0x3c
    80005f48:	97da                	add	a5,a5,s6
    80005f4a:	0007c503          	lbu	a0,0(a5)
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	bae080e7          	jalr	-1106(ra) # 80005afc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f56:	0912                	slli	s2,s2,0x4
    80005f58:	34fd                	addiw	s1,s1,-1
    80005f5a:	f4ed                	bnez	s1,80005f44 <printf+0x13a>
    80005f5c:	b7a1                	j	80005ea4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f5e:	f8843783          	ld	a5,-120(s0)
    80005f62:	00878713          	addi	a4,a5,8
    80005f66:	f8e43423          	sd	a4,-120(s0)
    80005f6a:	6384                	ld	s1,0(a5)
    80005f6c:	cc89                	beqz	s1,80005f86 <printf+0x17c>
      for(; *s; s++)
    80005f6e:	0004c503          	lbu	a0,0(s1)
    80005f72:	d90d                	beqz	a0,80005ea4 <printf+0x9a>
        consputc(*s);
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	b88080e7          	jalr	-1144(ra) # 80005afc <consputc>
      for(; *s; s++)
    80005f7c:	0485                	addi	s1,s1,1
    80005f7e:	0004c503          	lbu	a0,0(s1)
    80005f82:	f96d                	bnez	a0,80005f74 <printf+0x16a>
    80005f84:	b705                	j	80005ea4 <printf+0x9a>
        s = "(null)";
    80005f86:	00003497          	auipc	s1,0x3
    80005f8a:	89248493          	addi	s1,s1,-1902 # 80008818 <syscalls+0x418>
      for(; *s; s++)
    80005f8e:	02800513          	li	a0,40
    80005f92:	b7cd                	j	80005f74 <printf+0x16a>
      consputc('%');
    80005f94:	8556                	mv	a0,s5
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	b66080e7          	jalr	-1178(ra) # 80005afc <consputc>
      break;
    80005f9e:	b719                	j	80005ea4 <printf+0x9a>
      consputc('%');
    80005fa0:	8556                	mv	a0,s5
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	b5a080e7          	jalr	-1190(ra) # 80005afc <consputc>
      consputc(c);
    80005faa:	8526                	mv	a0,s1
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	b50080e7          	jalr	-1200(ra) # 80005afc <consputc>
      break;
    80005fb4:	bdc5                	j	80005ea4 <printf+0x9a>
  if(locking)
    80005fb6:	020d9163          	bnez	s11,80005fd8 <printf+0x1ce>
}
    80005fba:	70e6                	ld	ra,120(sp)
    80005fbc:	7446                	ld	s0,112(sp)
    80005fbe:	74a6                	ld	s1,104(sp)
    80005fc0:	7906                	ld	s2,96(sp)
    80005fc2:	69e6                	ld	s3,88(sp)
    80005fc4:	6a46                	ld	s4,80(sp)
    80005fc6:	6aa6                	ld	s5,72(sp)
    80005fc8:	6b06                	ld	s6,64(sp)
    80005fca:	7be2                	ld	s7,56(sp)
    80005fcc:	7c42                	ld	s8,48(sp)
    80005fce:	7ca2                	ld	s9,40(sp)
    80005fd0:	7d02                	ld	s10,32(sp)
    80005fd2:	6de2                	ld	s11,24(sp)
    80005fd4:	6129                	addi	sp,sp,192
    80005fd6:	8082                	ret
    release(&pr.lock);
    80005fd8:	00020517          	auipc	a0,0x20
    80005fdc:	21050513          	addi	a0,a0,528 # 800261e8 <pr>
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	3cc080e7          	jalr	972(ra) # 800063ac <release>
}
    80005fe8:	bfc9                	j	80005fba <printf+0x1b0>

0000000080005fea <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fea:	1101                	addi	sp,sp,-32
    80005fec:	ec06                	sd	ra,24(sp)
    80005fee:	e822                	sd	s0,16(sp)
    80005ff0:	e426                	sd	s1,8(sp)
    80005ff2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ff4:	00020497          	auipc	s1,0x20
    80005ff8:	1f448493          	addi	s1,s1,500 # 800261e8 <pr>
    80005ffc:	00003597          	auipc	a1,0x3
    80006000:	83458593          	addi	a1,a1,-1996 # 80008830 <syscalls+0x430>
    80006004:	8526                	mv	a0,s1
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	262080e7          	jalr	610(ra) # 80006268 <initlock>
  pr.locking = 1;
    8000600e:	4785                	li	a5,1
    80006010:	cc9c                	sw	a5,24(s1)
}
    80006012:	60e2                	ld	ra,24(sp)
    80006014:	6442                	ld	s0,16(sp)
    80006016:	64a2                	ld	s1,8(sp)
    80006018:	6105                	addi	sp,sp,32
    8000601a:	8082                	ret

000000008000601c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000601c:	1141                	addi	sp,sp,-16
    8000601e:	e406                	sd	ra,8(sp)
    80006020:	e022                	sd	s0,0(sp)
    80006022:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006024:	100007b7          	lui	a5,0x10000
    80006028:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000602c:	f8000713          	li	a4,-128
    80006030:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006034:	470d                	li	a4,3
    80006036:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000603a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006042:	469d                	li	a3,7
    80006044:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006048:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000604c:	00003597          	auipc	a1,0x3
    80006050:	80458593          	addi	a1,a1,-2044 # 80008850 <digits+0x18>
    80006054:	00020517          	auipc	a0,0x20
    80006058:	1b450513          	addi	a0,a0,436 # 80026208 <uart_tx_lock>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	20c080e7          	jalr	524(ra) # 80006268 <initlock>
}
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  push_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	234080e7          	jalr	564(ra) # 800062ac <push_off>

  if(panicked){
    80006080:	00003797          	auipc	a5,0x3
    80006084:	f9c7a783          	lw	a5,-100(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006088:	10000737          	lui	a4,0x10000
  if(panicked){
    8000608c:	c391                	beqz	a5,80006090 <uartputc_sync+0x24>
    for(;;)
    8000608e:	a001                	j	8000608e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006090:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006094:	0207f793          	andi	a5,a5,32
    80006098:	dfe5                	beqz	a5,80006090 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000609a:	0ff4f513          	zext.b	a0,s1
    8000609e:	100007b7          	lui	a5,0x10000
    800060a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	2a6080e7          	jalr	678(ra) # 8000634c <pop_off>
}
    800060ae:	60e2                	ld	ra,24(sp)
    800060b0:	6442                	ld	s0,16(sp)
    800060b2:	64a2                	ld	s1,8(sp)
    800060b4:	6105                	addi	sp,sp,32
    800060b6:	8082                	ret

00000000800060b8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060b8:	00003797          	auipc	a5,0x3
    800060bc:	f687b783          	ld	a5,-152(a5) # 80009020 <uart_tx_r>
    800060c0:	00003717          	auipc	a4,0x3
    800060c4:	f6873703          	ld	a4,-152(a4) # 80009028 <uart_tx_w>
    800060c8:	06f70a63          	beq	a4,a5,8000613c <uartstart+0x84>
{
    800060cc:	7139                	addi	sp,sp,-64
    800060ce:	fc06                	sd	ra,56(sp)
    800060d0:	f822                	sd	s0,48(sp)
    800060d2:	f426                	sd	s1,40(sp)
    800060d4:	f04a                	sd	s2,32(sp)
    800060d6:	ec4e                	sd	s3,24(sp)
    800060d8:	e852                	sd	s4,16(sp)
    800060da:	e456                	sd	s5,8(sp)
    800060dc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060de:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e2:	00020a17          	auipc	s4,0x20
    800060e6:	126a0a13          	addi	s4,s4,294 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060ea:	00003497          	auipc	s1,0x3
    800060ee:	f3648493          	addi	s1,s1,-202 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060f2:	00003997          	auipc	s3,0x3
    800060f6:	f3698993          	addi	s3,s3,-202 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060fa:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060fe:	02077713          	andi	a4,a4,32
    80006102:	c705                	beqz	a4,8000612a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006104:	01f7f713          	andi	a4,a5,31
    80006108:	9752                	add	a4,a4,s4
    8000610a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000610e:	0785                	addi	a5,a5,1
    80006110:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006112:	8526                	mv	a0,s1
    80006114:	ffffb097          	auipc	ra,0xffffb
    80006118:	738080e7          	jalr	1848(ra) # 8000184c <wakeup>
    
    WriteReg(THR, c);
    8000611c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006120:	609c                	ld	a5,0(s1)
    80006122:	0009b703          	ld	a4,0(s3)
    80006126:	fcf71ae3          	bne	a4,a5,800060fa <uartstart+0x42>
  }
}
    8000612a:	70e2                	ld	ra,56(sp)
    8000612c:	7442                	ld	s0,48(sp)
    8000612e:	74a2                	ld	s1,40(sp)
    80006130:	7902                	ld	s2,32(sp)
    80006132:	69e2                	ld	s3,24(sp)
    80006134:	6a42                	ld	s4,16(sp)
    80006136:	6aa2                	ld	s5,8(sp)
    80006138:	6121                	addi	sp,sp,64
    8000613a:	8082                	ret
    8000613c:	8082                	ret

000000008000613e <uartputc>:
{
    8000613e:	7179                	addi	sp,sp,-48
    80006140:	f406                	sd	ra,40(sp)
    80006142:	f022                	sd	s0,32(sp)
    80006144:	ec26                	sd	s1,24(sp)
    80006146:	e84a                	sd	s2,16(sp)
    80006148:	e44e                	sd	s3,8(sp)
    8000614a:	e052                	sd	s4,0(sp)
    8000614c:	1800                	addi	s0,sp,48
    8000614e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006150:	00020517          	auipc	a0,0x20
    80006154:	0b850513          	addi	a0,a0,184 # 80026208 <uart_tx_lock>
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	1a0080e7          	jalr	416(ra) # 800062f8 <acquire>
  if(panicked){
    80006160:	00003797          	auipc	a5,0x3
    80006164:	ebc7a783          	lw	a5,-324(a5) # 8000901c <panicked>
    80006168:	c391                	beqz	a5,8000616c <uartputc+0x2e>
    for(;;)
    8000616a:	a001                	j	8000616a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616c:	00003717          	auipc	a4,0x3
    80006170:	ebc73703          	ld	a4,-324(a4) # 80009028 <uart_tx_w>
    80006174:	00003797          	auipc	a5,0x3
    80006178:	eac7b783          	ld	a5,-340(a5) # 80009020 <uart_tx_r>
    8000617c:	02078793          	addi	a5,a5,32
    80006180:	02e79b63          	bne	a5,a4,800061b6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006184:	00020997          	auipc	s3,0x20
    80006188:	08498993          	addi	s3,s3,132 # 80026208 <uart_tx_lock>
    8000618c:	00003497          	auipc	s1,0x3
    80006190:	e9448493          	addi	s1,s1,-364 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006194:	00003917          	auipc	s2,0x3
    80006198:	e9490913          	addi	s2,s2,-364 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619c:	85ce                	mv	a1,s3
    8000619e:	8526                	mv	a0,s1
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	520080e7          	jalr	1312(ra) # 800016c0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a8:	00093703          	ld	a4,0(s2)
    800061ac:	609c                	ld	a5,0(s1)
    800061ae:	02078793          	addi	a5,a5,32
    800061b2:	fee785e3          	beq	a5,a4,8000619c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061b6:	00020497          	auipc	s1,0x20
    800061ba:	05248493          	addi	s1,s1,82 # 80026208 <uart_tx_lock>
    800061be:	01f77793          	andi	a5,a4,31
    800061c2:	97a6                	add	a5,a5,s1
    800061c4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061c8:	0705                	addi	a4,a4,1
    800061ca:	00003797          	auipc	a5,0x3
    800061ce:	e4e7bf23          	sd	a4,-418(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	ee6080e7          	jalr	-282(ra) # 800060b8 <uartstart>
      release(&uart_tx_lock);
    800061da:	8526                	mv	a0,s1
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	1d0080e7          	jalr	464(ra) # 800063ac <release>
}
    800061e4:	70a2                	ld	ra,40(sp)
    800061e6:	7402                	ld	s0,32(sp)
    800061e8:	64e2                	ld	s1,24(sp)
    800061ea:	6942                	ld	s2,16(sp)
    800061ec:	69a2                	ld	s3,8(sp)
    800061ee:	6a02                	ld	s4,0(sp)
    800061f0:	6145                	addi	sp,sp,48
    800061f2:	8082                	ret

00000000800061f4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061f4:	1141                	addi	sp,sp,-16
    800061f6:	e422                	sd	s0,8(sp)
    800061f8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061fa:	100007b7          	lui	a5,0x10000
    800061fe:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006202:	8b85                	andi	a5,a5,1
    80006204:	cb81                	beqz	a5,80006214 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006206:	100007b7          	lui	a5,0x10000
    8000620a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000620e:	6422                	ld	s0,8(sp)
    80006210:	0141                	addi	sp,sp,16
    80006212:	8082                	ret
    return -1;
    80006214:	557d                	li	a0,-1
    80006216:	bfe5                	j	8000620e <uartgetc+0x1a>

0000000080006218 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006218:	1101                	addi	sp,sp,-32
    8000621a:	ec06                	sd	ra,24(sp)
    8000621c:	e822                	sd	s0,16(sp)
    8000621e:	e426                	sd	s1,8(sp)
    80006220:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006222:	54fd                	li	s1,-1
    80006224:	a029                	j	8000622e <uartintr+0x16>
      break;
    consoleintr(c);
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	918080e7          	jalr	-1768(ra) # 80005b3e <consoleintr>
    int c = uartgetc();
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	fc6080e7          	jalr	-58(ra) # 800061f4 <uartgetc>
    if(c == -1)
    80006236:	fe9518e3          	bne	a0,s1,80006226 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000623a:	00020497          	auipc	s1,0x20
    8000623e:	fce48493          	addi	s1,s1,-50 # 80026208 <uart_tx_lock>
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	0b4080e7          	jalr	180(ra) # 800062f8 <acquire>
  uartstart();
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	e6c080e7          	jalr	-404(ra) # 800060b8 <uartstart>
  release(&uart_tx_lock);
    80006254:	8526                	mv	a0,s1
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	156080e7          	jalr	342(ra) # 800063ac <release>
}
    8000625e:	60e2                	ld	ra,24(sp)
    80006260:	6442                	ld	s0,16(sp)
    80006262:	64a2                	ld	s1,8(sp)
    80006264:	6105                	addi	sp,sp,32
    80006266:	8082                	ret

0000000080006268 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006268:	1141                	addi	sp,sp,-16
    8000626a:	e422                	sd	s0,8(sp)
    8000626c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000626e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006270:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006274:	00053823          	sd	zero,16(a0)
}
    80006278:	6422                	ld	s0,8(sp)
    8000627a:	0141                	addi	sp,sp,16
    8000627c:	8082                	ret

000000008000627e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000627e:	411c                	lw	a5,0(a0)
    80006280:	e399                	bnez	a5,80006286 <holding+0x8>
    80006282:	4501                	li	a0,0
  return r;
}
    80006284:	8082                	ret
{
    80006286:	1101                	addi	sp,sp,-32
    80006288:	ec06                	sd	ra,24(sp)
    8000628a:	e822                	sd	s0,16(sp)
    8000628c:	e426                	sd	s1,8(sp)
    8000628e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006290:	6904                	ld	s1,16(a0)
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	c94080e7          	jalr	-876(ra) # 80000f26 <mycpu>
    8000629a:	40a48533          	sub	a0,s1,a0
    8000629e:	00153513          	seqz	a0,a0
}
    800062a2:	60e2                	ld	ra,24(sp)
    800062a4:	6442                	ld	s0,16(sp)
    800062a6:	64a2                	ld	s1,8(sp)
    800062a8:	6105                	addi	sp,sp,32
    800062aa:	8082                	ret

00000000800062ac <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062b6:	100024f3          	csrr	s1,sstatus
    800062ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062be:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062c0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062c4:	ffffb097          	auipc	ra,0xffffb
    800062c8:	c62080e7          	jalr	-926(ra) # 80000f26 <mycpu>
    800062cc:	5d3c                	lw	a5,120(a0)
    800062ce:	cf89                	beqz	a5,800062e8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062d0:	ffffb097          	auipc	ra,0xffffb
    800062d4:	c56080e7          	jalr	-938(ra) # 80000f26 <mycpu>
    800062d8:	5d3c                	lw	a5,120(a0)
    800062da:	2785                	addiw	a5,a5,1
    800062dc:	dd3c                	sw	a5,120(a0)
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret
    mycpu()->intena = old;
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	c3e080e7          	jalr	-962(ra) # 80000f26 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062f0:	8085                	srli	s1,s1,0x1
    800062f2:	8885                	andi	s1,s1,1
    800062f4:	dd64                	sw	s1,124(a0)
    800062f6:	bfe9                	j	800062d0 <push_off+0x24>

00000000800062f8 <acquire>:
{
    800062f8:	1101                	addi	sp,sp,-32
    800062fa:	ec06                	sd	ra,24(sp)
    800062fc:	e822                	sd	s0,16(sp)
    800062fe:	e426                	sd	s1,8(sp)
    80006300:	1000                	addi	s0,sp,32
    80006302:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006304:	00000097          	auipc	ra,0x0
    80006308:	fa8080e7          	jalr	-88(ra) # 800062ac <push_off>
  if(holding(lk))
    8000630c:	8526                	mv	a0,s1
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	f70080e7          	jalr	-144(ra) # 8000627e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006316:	4705                	li	a4,1
  if(holding(lk))
    80006318:	e115                	bnez	a0,8000633c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000631a:	87ba                	mv	a5,a4
    8000631c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006320:	2781                	sext.w	a5,a5
    80006322:	ffe5                	bnez	a5,8000631a <acquire+0x22>
  __sync_synchronize();
    80006324:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	bfe080e7          	jalr	-1026(ra) # 80000f26 <mycpu>
    80006330:	e888                	sd	a0,16(s1)
}
    80006332:	60e2                	ld	ra,24(sp)
    80006334:	6442                	ld	s0,16(sp)
    80006336:	64a2                	ld	s1,8(sp)
    80006338:	6105                	addi	sp,sp,32
    8000633a:	8082                	ret
    panic("acquire");
    8000633c:	00002517          	auipc	a0,0x2
    80006340:	51c50513          	addi	a0,a0,1308 # 80008858 <digits+0x20>
    80006344:	00000097          	auipc	ra,0x0
    80006348:	a7c080e7          	jalr	-1412(ra) # 80005dc0 <panic>

000000008000634c <pop_off>:

void
pop_off(void)
{
    8000634c:	1141                	addi	sp,sp,-16
    8000634e:	e406                	sd	ra,8(sp)
    80006350:	e022                	sd	s0,0(sp)
    80006352:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006354:	ffffb097          	auipc	ra,0xffffb
    80006358:	bd2080e7          	jalr	-1070(ra) # 80000f26 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000635c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006360:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006362:	e78d                	bnez	a5,8000638c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006364:	5d3c                	lw	a5,120(a0)
    80006366:	02f05b63          	blez	a5,8000639c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000636a:	37fd                	addiw	a5,a5,-1
    8000636c:	0007871b          	sext.w	a4,a5
    80006370:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006372:	eb09                	bnez	a4,80006384 <pop_off+0x38>
    80006374:	5d7c                	lw	a5,124(a0)
    80006376:	c799                	beqz	a5,80006384 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006378:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000637c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006380:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006384:	60a2                	ld	ra,8(sp)
    80006386:	6402                	ld	s0,0(sp)
    80006388:	0141                	addi	sp,sp,16
    8000638a:	8082                	ret
    panic("pop_off - interruptible");
    8000638c:	00002517          	auipc	a0,0x2
    80006390:	4d450513          	addi	a0,a0,1236 # 80008860 <digits+0x28>
    80006394:	00000097          	auipc	ra,0x0
    80006398:	a2c080e7          	jalr	-1492(ra) # 80005dc0 <panic>
    panic("pop_off");
    8000639c:	00002517          	auipc	a0,0x2
    800063a0:	4dc50513          	addi	a0,a0,1244 # 80008878 <digits+0x40>
    800063a4:	00000097          	auipc	ra,0x0
    800063a8:	a1c080e7          	jalr	-1508(ra) # 80005dc0 <panic>

00000000800063ac <release>:
{
    800063ac:	1101                	addi	sp,sp,-32
    800063ae:	ec06                	sd	ra,24(sp)
    800063b0:	e822                	sd	s0,16(sp)
    800063b2:	e426                	sd	s1,8(sp)
    800063b4:	1000                	addi	s0,sp,32
    800063b6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	ec6080e7          	jalr	-314(ra) # 8000627e <holding>
    800063c0:	c115                	beqz	a0,800063e4 <release+0x38>
  lk->cpu = 0;
    800063c2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063c6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063ca:	0f50000f          	fence	iorw,ow
    800063ce:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	f7a080e7          	jalr	-134(ra) # 8000634c <pop_off>
}
    800063da:	60e2                	ld	ra,24(sp)
    800063dc:	6442                	ld	s0,16(sp)
    800063de:	64a2                	ld	s1,8(sp)
    800063e0:	6105                	addi	sp,sp,32
    800063e2:	8082                	ret
    panic("release");
    800063e4:	00002517          	auipc	a0,0x2
    800063e8:	49c50513          	addi	a0,a0,1180 # 80008880 <digits+0x48>
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	9d4080e7          	jalr	-1580(ra) # 80005dc0 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
