
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	71c050ef          	jal	ra,80005732 <start>

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
    8000005e:	122080e7          	jalr	290(ra) # 8000617c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1c2080e7          	jalr	450(ra) # 80006230 <release>
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
    8000008e:	be4080e7          	jalr	-1052(ra) # 80005c6e <panic>

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
    800000fa:	ff6080e7          	jalr	-10(ra) # 800060ec <initlock>
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
    80000132:	04e080e7          	jalr	78(ra) # 8000617c <acquire>
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
    8000014a:	0ea080e7          	jalr	234(ra) # 80006230 <release>

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
    80000174:	0c0080e7          	jalr	192(ra) # 80006230 <release>
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
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
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
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	96a080e7          	jalr	-1686(ra) # 80005cc0 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	744080e7          	jalr	1860(ra) # 80001aaa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	da2080e7          	jalr	-606(ra) # 80005110 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	ff0080e7          	jalr	-16(ra) # 80001366 <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	772080e7          	jalr	1906(ra) # 80005af0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	85a080e7          	jalr	-1958(ra) # 80005be0 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	92a080e7          	jalr	-1750(ra) # 80005cc0 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	91a080e7          	jalr	-1766(ra) # 80005cc0 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	90a080e7          	jalr	-1782(ra) # 80005cc0 <printf>
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
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6a4080e7          	jalr	1700(ra) # 80001a82 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6c4080e7          	jalr	1732(ra) # 80001aaa <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d0c080e7          	jalr	-756(ra) # 800050fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d1a080e7          	jalr	-742(ra) # 80005110 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	eda080e7          	jalr	-294(ra) # 800022d8 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	568080e7          	jalr	1384(ra) # 8000296e <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	51a080e7          	jalr	1306(ra) # 80003928 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	e1a080e7          	jalr	-486(ra) # 80005230 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d0e080e7          	jalr	-754(ra) # 8000112c <userinit>
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
    80000488:	00005097          	auipc	ra,0x5
    8000048c:	7e6080e7          	jalr	2022(ra) # 80005c6e <panic>
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
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	6c0080e7          	jalr	1728(ra) # 80005c6e <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	6b0080e7          	jalr	1712(ra) # 80005c6e <panic>
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
    8000060e:	664080e7          	jalr	1636(ra) # 80005c6e <panic>

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
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
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
    8000075a:	518080e7          	jalr	1304(ra) # 80005c6e <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	508080e7          	jalr	1288(ra) # 80005c6e <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	4f8080e7          	jalr	1272(ra) # 80005c6e <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	4e8080e7          	jalr	1256(ra) # 80005c6e <panic>
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
    80000868:	40a080e7          	jalr	1034(ra) # 80005c6e <panic>

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
    800009ac:	2c6080e7          	jalr	710(ra) # 80005c6e <panic>
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
    80000a8a:	1e8080e7          	jalr	488(ra) # 80005c6e <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	1d8080e7          	jalr	472(ra) # 80005c6e <panic>
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
    80000b04:	16e080e7          	jalr	366(ra) # 80005c6e <panic>

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

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000fa17          	auipc	s4,0xf
    80000d06:	97ea0a13          	addi	s4,s4,-1666 # 8000f680 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	858d                	srai	a1,a1,0x3
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	18848493          	addi	s1,s1,392
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	f0e080e7          	jalr	-242(ra) # 80005c6e <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	360080e7          	jalr	864(ra) # 800060ec <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	348080e7          	jalr	840(ra) # 800060ec <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0000f997          	auipc	s3,0xf
    80000dd2:	8b298993          	addi	s3,s3,-1870 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	312080e7          	jalr	786(ra) # 800060ec <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	878d                	srai	a5,a5,0x3
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	18848493          	addi	s1,s1,392
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	2e2080e7          	jalr	738(ra) # 80006130 <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	368080e7          	jalr	872(ra) # 800061d0 <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	3a4080e7          	jalr	932(ra) # 80006230 <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	99c7a783          	lw	a5,-1636(a5) # 80008830 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c24080e7          	jalr	-988(ra) # 80001ac2 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9807a123          	sw	zero,-1662(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	a36080e7          	jalr	-1482(ra) # 800028ee <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	2a4080e7          	jalr	676(ra) # 8000617c <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	95478793          	addi	a5,a5,-1708 # 80008834 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	33e080e7          	jalr	830(ra) # 80006230 <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	61e90913          	addi	s2,s2,1566 # 8000f680 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	110080e7          	jalr	272(ra) # 8000617c <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	1b6080e7          	jalr	438(ra) # 80006230 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	18848493          	addi	s1,s1,392
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a08d                	j	800010ee <allocproc+0xa0>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07e080e7          	jalr	126(ra) # 8000011a <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c931                	beqz	a0,800010fc <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	cd31                	beqz	a0,80001114 <allocproc+0xc6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
  p->interval=0;
    800010de:	1604a423          	sw	zero,360(s1)
  p->handler=0;
    800010e2:	1604b823          	sd	zero,368(s1)
  p->passedticks=0;
    800010e6:	1604ac23          	sw	zero,376(s1)
  p->trapframecopy=0;
    800010ea:	1804b023          	sd	zero,384(s1)
}
    800010ee:	8526                	mv	a0,s1
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	ef8080e7          	jalr	-264(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	128080e7          	jalr	296(ra) # 80006230 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	bff1                	j	800010ee <allocproc+0xa0>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ee0080e7          	jalr	-288(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	110080e7          	jalr	272(ra) # 80006230 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	b7d1                	j	800010ee <allocproc+0xa0>

000000008000112c <userinit>:
{
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	1000                	addi	s0,sp,32
  p = allocproc();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f18080e7          	jalr	-232(ra) # 8000104e <allocproc>
    8000113e:	84aa                	mv	s1,a0
  initproc = p;
    80001140:	00008797          	auipc	a5,0x8
    80001144:	eca7b823          	sd	a0,-304(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	6f458593          	addi	a1,a1,1780 # 80008840 <initcode>
    80001154:	6928                	ld	a0,80(a0)
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	6a4080e7          	jalr	1700(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000115e:	6785                	lui	a5,0x1
    80001160:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001162:	6cb8                	ld	a4,88(s1)
    80001164:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116c:	4641                	li	a2,16
    8000116e:	00007597          	auipc	a1,0x7
    80001172:	01258593          	addi	a1,a1,18 # 80008180 <etext+0x180>
    80001176:	15848513          	addi	a0,s1,344
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	14a080e7          	jalr	330(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	00e50513          	addi	a0,a0,14 # 80008190 <etext+0x190>
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	19a080e7          	jalr	410(ra) # 80003324 <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	094080e7          	jalr	148(ra) # 80006230 <release>
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <growproc>:
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	c88080e7          	jalr	-888(ra) # 80000e44 <myproc>
    800011c4:	892a                	mv	s2,a0
  sz = p->sz;
    800011c6:	652c                	ld	a1,72(a0)
    800011c8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011cc:	00904f63          	bgtz	s1,800011ea <growproc+0x3c>
  } else if(n < 0){
    800011d0:	0204cd63          	bltz	s1,8000120a <growproc+0x5c>
  p->sz = sz;
    800011d4:	1782                	slli	a5,a5,0x20
    800011d6:	9381                	srli	a5,a5,0x20
    800011d8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011dc:	4501                	li	a0,0
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6902                	ld	s2,0(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011ea:	00f4863b          	addw	a2,s1,a5
    800011ee:	1602                	slli	a2,a2,0x20
    800011f0:	9201                	srli	a2,a2,0x20
    800011f2:	1582                	slli	a1,a1,0x20
    800011f4:	9181                	srli	a1,a1,0x20
    800011f6:	6928                	ld	a0,80(a0)
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	6bc080e7          	jalr	1724(ra) # 800008b4 <uvmalloc>
    80001200:	0005079b          	sext.w	a5,a0
    80001204:	fbe1                	bnez	a5,800011d4 <growproc+0x26>
      return -1;
    80001206:	557d                	li	a0,-1
    80001208:	bfd9                	j	800011de <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120a:	00f4863b          	addw	a2,s1,a5
    8000120e:	1602                	slli	a2,a2,0x20
    80001210:	9201                	srli	a2,a2,0x20
    80001212:	1582                	slli	a1,a1,0x20
    80001214:	9181                	srli	a1,a1,0x20
    80001216:	6928                	ld	a0,80(a0)
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	654080e7          	jalr	1620(ra) # 8000086c <uvmdealloc>
    80001220:	0005079b          	sext.w	a5,a0
    80001224:	bf45                	j	800011d4 <growproc+0x26>

0000000080001226 <fork>:
{
    80001226:	7139                	addi	sp,sp,-64
    80001228:	fc06                	sd	ra,56(sp)
    8000122a:	f822                	sd	s0,48(sp)
    8000122c:	f426                	sd	s1,40(sp)
    8000122e:	f04a                	sd	s2,32(sp)
    80001230:	ec4e                	sd	s3,24(sp)
    80001232:	e852                	sd	s4,16(sp)
    80001234:	e456                	sd	s5,8(sp)
    80001236:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	c0c080e7          	jalr	-1012(ra) # 80000e44 <myproc>
    80001240:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001242:	00000097          	auipc	ra,0x0
    80001246:	e0c080e7          	jalr	-500(ra) # 8000104e <allocproc>
    8000124a:	10050c63          	beqz	a0,80001362 <fork+0x13c>
    8000124e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001250:	048ab603          	ld	a2,72(s5)
    80001254:	692c                	ld	a1,80(a0)
    80001256:	050ab503          	ld	a0,80(s5)
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	7aa080e7          	jalr	1962(ra) # 80000a04 <uvmcopy>
    80001262:	04054863          	bltz	a0,800012b2 <fork+0x8c>
  np->sz = p->sz;
    80001266:	048ab783          	ld	a5,72(s5)
    8000126a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000126e:	058ab683          	ld	a3,88(s5)
    80001272:	87b6                	mv	a5,a3
    80001274:	058a3703          	ld	a4,88(s4)
    80001278:	12068693          	addi	a3,a3,288
    8000127c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001280:	6788                	ld	a0,8(a5)
    80001282:	6b8c                	ld	a1,16(a5)
    80001284:	6f90                	ld	a2,24(a5)
    80001286:	01073023          	sd	a6,0(a4)
    8000128a:	e708                	sd	a0,8(a4)
    8000128c:	eb0c                	sd	a1,16(a4)
    8000128e:	ef10                	sd	a2,24(a4)
    80001290:	02078793          	addi	a5,a5,32
    80001294:	02070713          	addi	a4,a4,32
    80001298:	fed792e3          	bne	a5,a3,8000127c <fork+0x56>
  np->trapframe->a0 = 0;
    8000129c:	058a3783          	ld	a5,88(s4)
    800012a0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012a4:	0d0a8493          	addi	s1,s5,208
    800012a8:	0d0a0913          	addi	s2,s4,208
    800012ac:	150a8993          	addi	s3,s5,336
    800012b0:	a00d                	j	800012d2 <fork+0xac>
    freeproc(np);
    800012b2:	8552                	mv	a0,s4
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	d42080e7          	jalr	-702(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012bc:	8552                	mv	a0,s4
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	f72080e7          	jalr	-142(ra) # 80006230 <release>
    return -1;
    800012c6:	597d                	li	s2,-1
    800012c8:	a059                	j	8000134e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ca:	04a1                	addi	s1,s1,8
    800012cc:	0921                	addi	s2,s2,8
    800012ce:	01348b63          	beq	s1,s3,800012e4 <fork+0xbe>
    if(p->ofile[i])
    800012d2:	6088                	ld	a0,0(s1)
    800012d4:	d97d                	beqz	a0,800012ca <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	6e4080e7          	jalr	1764(ra) # 800039ba <filedup>
    800012de:	00a93023          	sd	a0,0(s2)
    800012e2:	b7e5                	j	800012ca <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012e4:	150ab503          	ld	a0,336(s5)
    800012e8:	00002097          	auipc	ra,0x2
    800012ec:	842080e7          	jalr	-1982(ra) # 80002b2a <idup>
    800012f0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f4:	4641                	li	a2,16
    800012f6:	158a8593          	addi	a1,s5,344
    800012fa:	158a0513          	addi	a0,s4,344
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	fc6080e7          	jalr	-58(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001306:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000130a:	8552                	mv	a0,s4
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f24080e7          	jalr	-220(ra) # 80006230 <release>
  acquire(&wait_lock);
    80001314:	00008497          	auipc	s1,0x8
    80001318:	d5448493          	addi	s1,s1,-684 # 80009068 <wait_lock>
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	e5e080e7          	jalr	-418(ra) # 8000617c <acquire>
  np->parent = p;
    80001326:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000132a:	8526                	mv	a0,s1
    8000132c:	00005097          	auipc	ra,0x5
    80001330:	f04080e7          	jalr	-252(ra) # 80006230 <release>
  acquire(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	e46080e7          	jalr	-442(ra) # 8000617c <acquire>
  np->state = RUNNABLE;
    8000133e:	478d                	li	a5,3
    80001340:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001344:	8552                	mv	a0,s4
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	eea080e7          	jalr	-278(ra) # 80006230 <release>
}
    8000134e:	854a                	mv	a0,s2
    80001350:	70e2                	ld	ra,56(sp)
    80001352:	7442                	ld	s0,48(sp)
    80001354:	74a2                	ld	s1,40(sp)
    80001356:	7902                	ld	s2,32(sp)
    80001358:	69e2                	ld	s3,24(sp)
    8000135a:	6a42                	ld	s4,16(sp)
    8000135c:	6aa2                	ld	s5,8(sp)
    8000135e:	6121                	addi	sp,sp,64
    80001360:	8082                	ret
    return -1;
    80001362:	597d                	li	s2,-1
    80001364:	b7ed                	j	8000134e <fork+0x128>

0000000080001366 <scheduler>:
{
    80001366:	7139                	addi	sp,sp,-64
    80001368:	fc06                	sd	ra,56(sp)
    8000136a:	f822                	sd	s0,48(sp)
    8000136c:	f426                	sd	s1,40(sp)
    8000136e:	f04a                	sd	s2,32(sp)
    80001370:	ec4e                	sd	s3,24(sp)
    80001372:	e852                	sd	s4,16(sp)
    80001374:	e456                	sd	s5,8(sp)
    80001376:	e05a                	sd	s6,0(sp)
    80001378:	0080                	addi	s0,sp,64
    8000137a:	8792                	mv	a5,tp
  int id = r_tp();
    8000137c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000137e:	00779a93          	slli	s5,a5,0x7
    80001382:	00008717          	auipc	a4,0x8
    80001386:	cce70713          	addi	a4,a4,-818 # 80009050 <pid_lock>
    8000138a:	9756                	add	a4,a4,s5
    8000138c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001390:	00008717          	auipc	a4,0x8
    80001394:	cf870713          	addi	a4,a4,-776 # 80009088 <cpus+0x8>
    80001398:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000139a:	498d                	li	s3,3
        p->state = RUNNING;
    8000139c:	4b11                	li	s6,4
        c->proc = p;
    8000139e:	079e                	slli	a5,a5,0x7
    800013a0:	00008a17          	auipc	s4,0x8
    800013a4:	cb0a0a13          	addi	s4,s4,-848 # 80009050 <pid_lock>
    800013a8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013aa:	0000e917          	auipc	s2,0xe
    800013ae:	2d690913          	addi	s2,s2,726 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ba:	10079073          	csrw	sstatus,a5
    800013be:	00008497          	auipc	s1,0x8
    800013c2:	0c248493          	addi	s1,s1,194 # 80009480 <proc>
    800013c6:	a811                	j	800013da <scheduler+0x74>
      release(&p->lock);
    800013c8:	8526                	mv	a0,s1
    800013ca:	00005097          	auipc	ra,0x5
    800013ce:	e66080e7          	jalr	-410(ra) # 80006230 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	18848493          	addi	s1,s1,392
    800013d6:	fd248ee3          	beq	s1,s2,800013b2 <scheduler+0x4c>
      acquire(&p->lock);
    800013da:	8526                	mv	a0,s1
    800013dc:	00005097          	auipc	ra,0x5
    800013e0:	da0080e7          	jalr	-608(ra) # 8000617c <acquire>
      if(p->state == RUNNABLE) {
    800013e4:	4c9c                	lw	a5,24(s1)
    800013e6:	ff3791e3          	bne	a5,s3,800013c8 <scheduler+0x62>
        p->state = RUNNING;
    800013ea:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013ee:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f2:	06048593          	addi	a1,s1,96
    800013f6:	8556                	mv	a0,s5
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	620080e7          	jalr	1568(ra) # 80001a18 <swtch>
        c->proc = 0;
    80001400:	020a3823          	sd	zero,48(s4)
    80001404:	b7d1                	j	800013c8 <scheduler+0x62>

0000000080001406 <sched>:
{
    80001406:	7179                	addi	sp,sp,-48
    80001408:	f406                	sd	ra,40(sp)
    8000140a:	f022                	sd	s0,32(sp)
    8000140c:	ec26                	sd	s1,24(sp)
    8000140e:	e84a                	sd	s2,16(sp)
    80001410:	e44e                	sd	s3,8(sp)
    80001412:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001414:	00000097          	auipc	ra,0x0
    80001418:	a30080e7          	jalr	-1488(ra) # 80000e44 <myproc>
    8000141c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000141e:	00005097          	auipc	ra,0x5
    80001422:	ce4080e7          	jalr	-796(ra) # 80006102 <holding>
    80001426:	c93d                	beqz	a0,8000149c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001428:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000142a:	2781                	sext.w	a5,a5
    8000142c:	079e                	slli	a5,a5,0x7
    8000142e:	00008717          	auipc	a4,0x8
    80001432:	c2270713          	addi	a4,a4,-990 # 80009050 <pid_lock>
    80001436:	97ba                	add	a5,a5,a4
    80001438:	0a87a703          	lw	a4,168(a5)
    8000143c:	4785                	li	a5,1
    8000143e:	06f71763          	bne	a4,a5,800014ac <sched+0xa6>
  if(p->state == RUNNING)
    80001442:	4c98                	lw	a4,24(s1)
    80001444:	4791                	li	a5,4
    80001446:	06f70b63          	beq	a4,a5,800014bc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000144a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000144e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001450:	efb5                	bnez	a5,800014cc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001452:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001454:	00008917          	auipc	s2,0x8
    80001458:	bfc90913          	addi	s2,s2,-1028 # 80009050 <pid_lock>
    8000145c:	2781                	sext.w	a5,a5
    8000145e:	079e                	slli	a5,a5,0x7
    80001460:	97ca                	add	a5,a5,s2
    80001462:	0ac7a983          	lw	s3,172(a5)
    80001466:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008597          	auipc	a1,0x8
    80001470:	c1c58593          	addi	a1,a1,-996 # 80009088 <cpus+0x8>
    80001474:	95be                	add	a1,a1,a5
    80001476:	06048513          	addi	a0,s1,96
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	59e080e7          	jalr	1438(ra) # 80001a18 <swtch>
    80001482:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	993e                	add	s2,s2,a5
    8000148a:	0b392623          	sw	s3,172(s2)
}
    8000148e:	70a2                	ld	ra,40(sp)
    80001490:	7402                	ld	s0,32(sp)
    80001492:	64e2                	ld	s1,24(sp)
    80001494:	6942                	ld	s2,16(sp)
    80001496:	69a2                	ld	s3,8(sp)
    80001498:	6145                	addi	sp,sp,48
    8000149a:	8082                	ret
    panic("sched p->lock");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	cfc50513          	addi	a0,a0,-772 # 80008198 <etext+0x198>
    800014a4:	00004097          	auipc	ra,0x4
    800014a8:	7ca080e7          	jalr	1994(ra) # 80005c6e <panic>
    panic("sched locks");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	cfc50513          	addi	a0,a0,-772 # 800081a8 <etext+0x1a8>
    800014b4:	00004097          	auipc	ra,0x4
    800014b8:	7ba080e7          	jalr	1978(ra) # 80005c6e <panic>
    panic("sched running");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	cfc50513          	addi	a0,a0,-772 # 800081b8 <etext+0x1b8>
    800014c4:	00004097          	auipc	ra,0x4
    800014c8:	7aa080e7          	jalr	1962(ra) # 80005c6e <panic>
    panic("sched interruptible");
    800014cc:	00007517          	auipc	a0,0x7
    800014d0:	cfc50513          	addi	a0,a0,-772 # 800081c8 <etext+0x1c8>
    800014d4:	00004097          	auipc	ra,0x4
    800014d8:	79a080e7          	jalr	1946(ra) # 80005c6e <panic>

00000000800014dc <yield>:
{
    800014dc:	1101                	addi	sp,sp,-32
    800014de:	ec06                	sd	ra,24(sp)
    800014e0:	e822                	sd	s0,16(sp)
    800014e2:	e426                	sd	s1,8(sp)
    800014e4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	95e080e7          	jalr	-1698(ra) # 80000e44 <myproc>
    800014ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	c8c080e7          	jalr	-884(ra) # 8000617c <acquire>
  p->state = RUNNABLE;
    800014f8:	478d                	li	a5,3
    800014fa:	cc9c                	sw	a5,24(s1)
  sched();
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	f0a080e7          	jalr	-246(ra) # 80001406 <sched>
  release(&p->lock);
    80001504:	8526                	mv	a0,s1
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	d2a080e7          	jalr	-726(ra) # 80006230 <release>
}
    8000150e:	60e2                	ld	ra,24(sp)
    80001510:	6442                	ld	s0,16(sp)
    80001512:	64a2                	ld	s1,8(sp)
    80001514:	6105                	addi	sp,sp,32
    80001516:	8082                	ret

0000000080001518 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001518:	7179                	addi	sp,sp,-48
    8000151a:	f406                	sd	ra,40(sp)
    8000151c:	f022                	sd	s0,32(sp)
    8000151e:	ec26                	sd	s1,24(sp)
    80001520:	e84a                	sd	s2,16(sp)
    80001522:	e44e                	sd	s3,8(sp)
    80001524:	1800                	addi	s0,sp,48
    80001526:	89aa                	mv	s3,a0
    80001528:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	91a080e7          	jalr	-1766(ra) # 80000e44 <myproc>
    80001532:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001534:	00005097          	auipc	ra,0x5
    80001538:	c48080e7          	jalr	-952(ra) # 8000617c <acquire>
  release(lk);
    8000153c:	854a                	mv	a0,s2
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	cf2080e7          	jalr	-782(ra) # 80006230 <release>

  // Go to sleep.
  p->chan = chan;
    80001546:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000154a:	4789                	li	a5,2
    8000154c:	cc9c                	sw	a5,24(s1)

  sched();
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	eb8080e7          	jalr	-328(ra) # 80001406 <sched>

  // Tidy up.
  p->chan = 0;
    80001556:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	cd4080e7          	jalr	-812(ra) # 80006230 <release>
  acquire(lk);
    80001564:	854a                	mv	a0,s2
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	c16080e7          	jalr	-1002(ra) # 8000617c <acquire>
}
    8000156e:	70a2                	ld	ra,40(sp)
    80001570:	7402                	ld	s0,32(sp)
    80001572:	64e2                	ld	s1,24(sp)
    80001574:	6942                	ld	s2,16(sp)
    80001576:	69a2                	ld	s3,8(sp)
    80001578:	6145                	addi	sp,sp,48
    8000157a:	8082                	ret

000000008000157c <wait>:
{
    8000157c:	715d                	addi	sp,sp,-80
    8000157e:	e486                	sd	ra,72(sp)
    80001580:	e0a2                	sd	s0,64(sp)
    80001582:	fc26                	sd	s1,56(sp)
    80001584:	f84a                	sd	s2,48(sp)
    80001586:	f44e                	sd	s3,40(sp)
    80001588:	f052                	sd	s4,32(sp)
    8000158a:	ec56                	sd	s5,24(sp)
    8000158c:	e85a                	sd	s6,16(sp)
    8000158e:	e45e                	sd	s7,8(sp)
    80001590:	e062                	sd	s8,0(sp)
    80001592:	0880                	addi	s0,sp,80
    80001594:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	8ae080e7          	jalr	-1874(ra) # 80000e44 <myproc>
    8000159e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015a0:	00008517          	auipc	a0,0x8
    800015a4:	ac850513          	addi	a0,a0,-1336 # 80009068 <wait_lock>
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	bd4080e7          	jalr	-1068(ra) # 8000617c <acquire>
    havekids = 0;
    800015b0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015b2:	4a15                	li	s4,5
        havekids = 1;
    800015b4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015b6:	0000e997          	auipc	s3,0xe
    800015ba:	0ca98993          	addi	s3,s3,202 # 8000f680 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015be:	00008c17          	auipc	s8,0x8
    800015c2:	aaac0c13          	addi	s8,s8,-1366 # 80009068 <wait_lock>
    havekids = 0;
    800015c6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c8:	00008497          	auipc	s1,0x8
    800015cc:	eb848493          	addi	s1,s1,-328 # 80009480 <proc>
    800015d0:	a0bd                	j	8000163e <wait+0xc2>
          pid = np->pid;
    800015d2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d6:	000b0e63          	beqz	s6,800015f2 <wait+0x76>
    800015da:	4691                	li	a3,4
    800015dc:	02c48613          	addi	a2,s1,44
    800015e0:	85da                	mv	a1,s6
    800015e2:	05093503          	ld	a0,80(s2)
    800015e6:	fffff097          	auipc	ra,0xfffff
    800015ea:	522080e7          	jalr	1314(ra) # 80000b08 <copyout>
    800015ee:	02054563          	bltz	a0,80001618 <wait+0x9c>
          freeproc(np);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	a02080e7          	jalr	-1534(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015fc:	8526                	mv	a0,s1
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	c32080e7          	jalr	-974(ra) # 80006230 <release>
          release(&wait_lock);
    80001606:	00008517          	auipc	a0,0x8
    8000160a:	a6250513          	addi	a0,a0,-1438 # 80009068 <wait_lock>
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	c22080e7          	jalr	-990(ra) # 80006230 <release>
          return pid;
    80001616:	a09d                	j	8000167c <wait+0x100>
            release(&np->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	c16080e7          	jalr	-1002(ra) # 80006230 <release>
            release(&wait_lock);
    80001622:	00008517          	auipc	a0,0x8
    80001626:	a4650513          	addi	a0,a0,-1466 # 80009068 <wait_lock>
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	c06080e7          	jalr	-1018(ra) # 80006230 <release>
            return -1;
    80001632:	59fd                	li	s3,-1
    80001634:	a0a1                	j	8000167c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001636:	18848493          	addi	s1,s1,392
    8000163a:	03348463          	beq	s1,s3,80001662 <wait+0xe6>
      if(np->parent == p){
    8000163e:	7c9c                	ld	a5,56(s1)
    80001640:	ff279be3          	bne	a5,s2,80001636 <wait+0xba>
        acquire(&np->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	b36080e7          	jalr	-1226(ra) # 8000617c <acquire>
        if(np->state == ZOMBIE){
    8000164e:	4c9c                	lw	a5,24(s1)
    80001650:	f94781e3          	beq	a5,s4,800015d2 <wait+0x56>
        release(&np->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	bda080e7          	jalr	-1062(ra) # 80006230 <release>
        havekids = 1;
    8000165e:	8756                	mv	a4,s5
    80001660:	bfd9                	j	80001636 <wait+0xba>
    if(!havekids || p->killed){
    80001662:	c701                	beqz	a4,8000166a <wait+0xee>
    80001664:	02892783          	lw	a5,40(s2)
    80001668:	c79d                	beqz	a5,80001696 <wait+0x11a>
      release(&wait_lock);
    8000166a:	00008517          	auipc	a0,0x8
    8000166e:	9fe50513          	addi	a0,a0,-1538 # 80009068 <wait_lock>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	bbe080e7          	jalr	-1090(ra) # 80006230 <release>
      return -1;
    8000167a:	59fd                	li	s3,-1
}
    8000167c:	854e                	mv	a0,s3
    8000167e:	60a6                	ld	ra,72(sp)
    80001680:	6406                	ld	s0,64(sp)
    80001682:	74e2                	ld	s1,56(sp)
    80001684:	7942                	ld	s2,48(sp)
    80001686:	79a2                	ld	s3,40(sp)
    80001688:	7a02                	ld	s4,32(sp)
    8000168a:	6ae2                	ld	s5,24(sp)
    8000168c:	6b42                	ld	s6,16(sp)
    8000168e:	6ba2                	ld	s7,8(sp)
    80001690:	6c02                	ld	s8,0(sp)
    80001692:	6161                	addi	sp,sp,80
    80001694:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001696:	85e2                	mv	a1,s8
    80001698:	854a                	mv	a0,s2
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	e7e080e7          	jalr	-386(ra) # 80001518 <sleep>
    havekids = 0;
    800016a2:	b715                	j	800015c6 <wait+0x4a>

00000000800016a4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016a4:	7139                	addi	sp,sp,-64
    800016a6:	fc06                	sd	ra,56(sp)
    800016a8:	f822                	sd	s0,48(sp)
    800016aa:	f426                	sd	s1,40(sp)
    800016ac:	f04a                	sd	s2,32(sp)
    800016ae:	ec4e                	sd	s3,24(sp)
    800016b0:	e852                	sd	s4,16(sp)
    800016b2:	e456                	sd	s5,8(sp)
    800016b4:	0080                	addi	s0,sp,64
    800016b6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b8:	00008497          	auipc	s1,0x8
    800016bc:	dc848493          	addi	s1,s1,-568 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016c0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016c2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c4:	0000e917          	auipc	s2,0xe
    800016c8:	fbc90913          	addi	s2,s2,-68 # 8000f680 <tickslock>
    800016cc:	a811                	j	800016e0 <wakeup+0x3c>
      }
      release(&p->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	b60080e7          	jalr	-1184(ra) # 80006230 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d8:	18848493          	addi	s1,s1,392
    800016dc:	03248663          	beq	s1,s2,80001708 <wakeup+0x64>
    if(p != myproc()){
    800016e0:	fffff097          	auipc	ra,0xfffff
    800016e4:	764080e7          	jalr	1892(ra) # 80000e44 <myproc>
    800016e8:	fea488e3          	beq	s1,a0,800016d8 <wakeup+0x34>
      acquire(&p->lock);
    800016ec:	8526                	mv	a0,s1
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	a8e080e7          	jalr	-1394(ra) # 8000617c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f6:	4c9c                	lw	a5,24(s1)
    800016f8:	fd379be3          	bne	a5,s3,800016ce <wakeup+0x2a>
    800016fc:	709c                	ld	a5,32(s1)
    800016fe:	fd4798e3          	bne	a5,s4,800016ce <wakeup+0x2a>
        p->state = RUNNABLE;
    80001702:	0154ac23          	sw	s5,24(s1)
    80001706:	b7e1                	j	800016ce <wakeup+0x2a>
    }
  }
}
    80001708:	70e2                	ld	ra,56(sp)
    8000170a:	7442                	ld	s0,48(sp)
    8000170c:	74a2                	ld	s1,40(sp)
    8000170e:	7902                	ld	s2,32(sp)
    80001710:	69e2                	ld	s3,24(sp)
    80001712:	6a42                	ld	s4,16(sp)
    80001714:	6aa2                	ld	s5,8(sp)
    80001716:	6121                	addi	sp,sp,64
    80001718:	8082                	ret

000000008000171a <reparent>:
{
    8000171a:	7179                	addi	sp,sp,-48
    8000171c:	f406                	sd	ra,40(sp)
    8000171e:	f022                	sd	s0,32(sp)
    80001720:	ec26                	sd	s1,24(sp)
    80001722:	e84a                	sd	s2,16(sp)
    80001724:	e44e                	sd	s3,8(sp)
    80001726:	e052                	sd	s4,0(sp)
    80001728:	1800                	addi	s0,sp,48
    8000172a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000172c:	00008497          	auipc	s1,0x8
    80001730:	d5448493          	addi	s1,s1,-684 # 80009480 <proc>
      pp->parent = initproc;
    80001734:	00008a17          	auipc	s4,0x8
    80001738:	8dca0a13          	addi	s4,s4,-1828 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000173c:	0000e997          	auipc	s3,0xe
    80001740:	f4498993          	addi	s3,s3,-188 # 8000f680 <tickslock>
    80001744:	a029                	j	8000174e <reparent+0x34>
    80001746:	18848493          	addi	s1,s1,392
    8000174a:	01348d63          	beq	s1,s3,80001764 <reparent+0x4a>
    if(pp->parent == p){
    8000174e:	7c9c                	ld	a5,56(s1)
    80001750:	ff279be3          	bne	a5,s2,80001746 <reparent+0x2c>
      pp->parent = initproc;
    80001754:	000a3503          	ld	a0,0(s4)
    80001758:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000175a:	00000097          	auipc	ra,0x0
    8000175e:	f4a080e7          	jalr	-182(ra) # 800016a4 <wakeup>
    80001762:	b7d5                	j	80001746 <reparent+0x2c>
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6a02                	ld	s4,0(sp)
    80001770:	6145                	addi	sp,sp,48
    80001772:	8082                	ret

0000000080001774 <exit>:
{
    80001774:	7179                	addi	sp,sp,-48
    80001776:	f406                	sd	ra,40(sp)
    80001778:	f022                	sd	s0,32(sp)
    8000177a:	ec26                	sd	s1,24(sp)
    8000177c:	e84a                	sd	s2,16(sp)
    8000177e:	e44e                	sd	s3,8(sp)
    80001780:	e052                	sd	s4,0(sp)
    80001782:	1800                	addi	s0,sp,48
    80001784:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001786:	fffff097          	auipc	ra,0xfffff
    8000178a:	6be080e7          	jalr	1726(ra) # 80000e44 <myproc>
    8000178e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001790:	00008797          	auipc	a5,0x8
    80001794:	8807b783          	ld	a5,-1920(a5) # 80009010 <initproc>
    80001798:	0d050493          	addi	s1,a0,208
    8000179c:	15050913          	addi	s2,a0,336
    800017a0:	02a79363          	bne	a5,a0,800017c6 <exit+0x52>
    panic("init exiting");
    800017a4:	00007517          	auipc	a0,0x7
    800017a8:	a3c50513          	addi	a0,a0,-1476 # 800081e0 <etext+0x1e0>
    800017ac:	00004097          	auipc	ra,0x4
    800017b0:	4c2080e7          	jalr	1218(ra) # 80005c6e <panic>
      fileclose(f);
    800017b4:	00002097          	auipc	ra,0x2
    800017b8:	258080e7          	jalr	600(ra) # 80003a0c <fileclose>
      p->ofile[fd] = 0;
    800017bc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017c0:	04a1                	addi	s1,s1,8
    800017c2:	01248563          	beq	s1,s2,800017cc <exit+0x58>
    if(p->ofile[fd]){
    800017c6:	6088                	ld	a0,0(s1)
    800017c8:	f575                	bnez	a0,800017b4 <exit+0x40>
    800017ca:	bfdd                	j	800017c0 <exit+0x4c>
  begin_op();
    800017cc:	00002097          	auipc	ra,0x2
    800017d0:	d78080e7          	jalr	-648(ra) # 80003544 <begin_op>
  iput(p->cwd);
    800017d4:	1509b503          	ld	a0,336(s3)
    800017d8:	00001097          	auipc	ra,0x1
    800017dc:	54a080e7          	jalr	1354(ra) # 80002d22 <iput>
  end_op();
    800017e0:	00002097          	auipc	ra,0x2
    800017e4:	de2080e7          	jalr	-542(ra) # 800035c2 <end_op>
  p->cwd = 0;
    800017e8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017ec:	00008497          	auipc	s1,0x8
    800017f0:	87c48493          	addi	s1,s1,-1924 # 80009068 <wait_lock>
    800017f4:	8526                	mv	a0,s1
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	986080e7          	jalr	-1658(ra) # 8000617c <acquire>
  reparent(p);
    800017fe:	854e                	mv	a0,s3
    80001800:	00000097          	auipc	ra,0x0
    80001804:	f1a080e7          	jalr	-230(ra) # 8000171a <reparent>
  wakeup(p->parent);
    80001808:	0389b503          	ld	a0,56(s3)
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	e98080e7          	jalr	-360(ra) # 800016a4 <wakeup>
  acquire(&p->lock);
    80001814:	854e                	mv	a0,s3
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	966080e7          	jalr	-1690(ra) # 8000617c <acquire>
  p->xstate = status;
    8000181e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001822:	4795                	li	a5,5
    80001824:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001828:	8526                	mv	a0,s1
    8000182a:	00005097          	auipc	ra,0x5
    8000182e:	a06080e7          	jalr	-1530(ra) # 80006230 <release>
  sched();
    80001832:	00000097          	auipc	ra,0x0
    80001836:	bd4080e7          	jalr	-1068(ra) # 80001406 <sched>
  panic("zombie exit");
    8000183a:	00007517          	auipc	a0,0x7
    8000183e:	9b650513          	addi	a0,a0,-1610 # 800081f0 <etext+0x1f0>
    80001842:	00004097          	auipc	ra,0x4
    80001846:	42c080e7          	jalr	1068(ra) # 80005c6e <panic>

000000008000184a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000184a:	7179                	addi	sp,sp,-48
    8000184c:	f406                	sd	ra,40(sp)
    8000184e:	f022                	sd	s0,32(sp)
    80001850:	ec26                	sd	s1,24(sp)
    80001852:	e84a                	sd	s2,16(sp)
    80001854:	e44e                	sd	s3,8(sp)
    80001856:	1800                	addi	s0,sp,48
    80001858:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000185a:	00008497          	auipc	s1,0x8
    8000185e:	c2648493          	addi	s1,s1,-986 # 80009480 <proc>
    80001862:	0000e997          	auipc	s3,0xe
    80001866:	e1e98993          	addi	s3,s3,-482 # 8000f680 <tickslock>
    acquire(&p->lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	910080e7          	jalr	-1776(ra) # 8000617c <acquire>
    if(p->pid == pid){
    80001874:	589c                	lw	a5,48(s1)
    80001876:	01278d63          	beq	a5,s2,80001890 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000187a:	8526                	mv	a0,s1
    8000187c:	00005097          	auipc	ra,0x5
    80001880:	9b4080e7          	jalr	-1612(ra) # 80006230 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001884:	18848493          	addi	s1,s1,392
    80001888:	ff3491e3          	bne	s1,s3,8000186a <kill+0x20>
  }
  return -1;
    8000188c:	557d                	li	a0,-1
    8000188e:	a829                	j	800018a8 <kill+0x5e>
      p->killed = 1;
    80001890:	4785                	li	a5,1
    80001892:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001894:	4c98                	lw	a4,24(s1)
    80001896:	4789                	li	a5,2
    80001898:	00f70f63          	beq	a4,a5,800018b6 <kill+0x6c>
      release(&p->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	992080e7          	jalr	-1646(ra) # 80006230 <release>
      return 0;
    800018a6:	4501                	li	a0,0
}
    800018a8:	70a2                	ld	ra,40(sp)
    800018aa:	7402                	ld	s0,32(sp)
    800018ac:	64e2                	ld	s1,24(sp)
    800018ae:	6942                	ld	s2,16(sp)
    800018b0:	69a2                	ld	s3,8(sp)
    800018b2:	6145                	addi	sp,sp,48
    800018b4:	8082                	ret
        p->state = RUNNABLE;
    800018b6:	478d                	li	a5,3
    800018b8:	cc9c                	sw	a5,24(s1)
    800018ba:	b7cd                	j	8000189c <kill+0x52>

00000000800018bc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018bc:	7179                	addi	sp,sp,-48
    800018be:	f406                	sd	ra,40(sp)
    800018c0:	f022                	sd	s0,32(sp)
    800018c2:	ec26                	sd	s1,24(sp)
    800018c4:	e84a                	sd	s2,16(sp)
    800018c6:	e44e                	sd	s3,8(sp)
    800018c8:	e052                	sd	s4,0(sp)
    800018ca:	1800                	addi	s0,sp,48
    800018cc:	84aa                	mv	s1,a0
    800018ce:	892e                	mv	s2,a1
    800018d0:	89b2                	mv	s3,a2
    800018d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018d4:	fffff097          	auipc	ra,0xfffff
    800018d8:	570080e7          	jalr	1392(ra) # 80000e44 <myproc>
  if(user_dst){
    800018dc:	c08d                	beqz	s1,800018fe <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018de:	86d2                	mv	a3,s4
    800018e0:	864e                	mv	a2,s3
    800018e2:	85ca                	mv	a1,s2
    800018e4:	6928                	ld	a0,80(a0)
    800018e6:	fffff097          	auipc	ra,0xfffff
    800018ea:	222080e7          	jalr	546(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018ee:	70a2                	ld	ra,40(sp)
    800018f0:	7402                	ld	s0,32(sp)
    800018f2:	64e2                	ld	s1,24(sp)
    800018f4:	6942                	ld	s2,16(sp)
    800018f6:	69a2                	ld	s3,8(sp)
    800018f8:	6a02                	ld	s4,0(sp)
    800018fa:	6145                	addi	sp,sp,48
    800018fc:	8082                	ret
    memmove((char *)dst, src, len);
    800018fe:	000a061b          	sext.w	a2,s4
    80001902:	85ce                	mv	a1,s3
    80001904:	854a                	mv	a0,s2
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	8d0080e7          	jalr	-1840(ra) # 800001d6 <memmove>
    return 0;
    8000190e:	8526                	mv	a0,s1
    80001910:	bff9                	j	800018ee <either_copyout+0x32>

0000000080001912 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001912:	7179                	addi	sp,sp,-48
    80001914:	f406                	sd	ra,40(sp)
    80001916:	f022                	sd	s0,32(sp)
    80001918:	ec26                	sd	s1,24(sp)
    8000191a:	e84a                	sd	s2,16(sp)
    8000191c:	e44e                	sd	s3,8(sp)
    8000191e:	e052                	sd	s4,0(sp)
    80001920:	1800                	addi	s0,sp,48
    80001922:	892a                	mv	s2,a0
    80001924:	84ae                	mv	s1,a1
    80001926:	89b2                	mv	s3,a2
    80001928:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	51a080e7          	jalr	1306(ra) # 80000e44 <myproc>
  if(user_src){
    80001932:	c08d                	beqz	s1,80001954 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001934:	86d2                	mv	a3,s4
    80001936:	864e                	mv	a2,s3
    80001938:	85ca                	mv	a1,s2
    8000193a:	6928                	ld	a0,80(a0)
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	258080e7          	jalr	600(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001944:	70a2                	ld	ra,40(sp)
    80001946:	7402                	ld	s0,32(sp)
    80001948:	64e2                	ld	s1,24(sp)
    8000194a:	6942                	ld	s2,16(sp)
    8000194c:	69a2                	ld	s3,8(sp)
    8000194e:	6a02                	ld	s4,0(sp)
    80001950:	6145                	addi	sp,sp,48
    80001952:	8082                	ret
    memmove(dst, (char*)src, len);
    80001954:	000a061b          	sext.w	a2,s4
    80001958:	85ce                	mv	a1,s3
    8000195a:	854a                	mv	a0,s2
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	87a080e7          	jalr	-1926(ra) # 800001d6 <memmove>
    return 0;
    80001964:	8526                	mv	a0,s1
    80001966:	bff9                	j	80001944 <either_copyin+0x32>

0000000080001968 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001968:	715d                	addi	sp,sp,-80
    8000196a:	e486                	sd	ra,72(sp)
    8000196c:	e0a2                	sd	s0,64(sp)
    8000196e:	fc26                	sd	s1,56(sp)
    80001970:	f84a                	sd	s2,48(sp)
    80001972:	f44e                	sd	s3,40(sp)
    80001974:	f052                	sd	s4,32(sp)
    80001976:	ec56                	sd	s5,24(sp)
    80001978:	e85a                	sd	s6,16(sp)
    8000197a:	e45e                	sd	s7,8(sp)
    8000197c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000197e:	00006517          	auipc	a0,0x6
    80001982:	6ca50513          	addi	a0,a0,1738 # 80008048 <etext+0x48>
    80001986:	00004097          	auipc	ra,0x4
    8000198a:	33a080e7          	jalr	826(ra) # 80005cc0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000198e:	00008497          	auipc	s1,0x8
    80001992:	c4a48493          	addi	s1,s1,-950 # 800095d8 <proc+0x158>
    80001996:	0000e917          	auipc	s2,0xe
    8000199a:	e4290913          	addi	s2,s2,-446 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000199e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019a0:	00007997          	auipc	s3,0x7
    800019a4:	86098993          	addi	s3,s3,-1952 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a8:	00007a97          	auipc	s5,0x7
    800019ac:	860a8a93          	addi	s5,s5,-1952 # 80008208 <etext+0x208>
    printf("\n");
    800019b0:	00006a17          	auipc	s4,0x6
    800019b4:	698a0a13          	addi	s4,s4,1688 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b8:	00007b97          	auipc	s7,0x7
    800019bc:	888b8b93          	addi	s7,s7,-1912 # 80008240 <states.0>
    800019c0:	a00d                	j	800019e2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019c2:	ed86a583          	lw	a1,-296(a3)
    800019c6:	8556                	mv	a0,s5
    800019c8:	00004097          	auipc	ra,0x4
    800019cc:	2f8080e7          	jalr	760(ra) # 80005cc0 <printf>
    printf("\n");
    800019d0:	8552                	mv	a0,s4
    800019d2:	00004097          	auipc	ra,0x4
    800019d6:	2ee080e7          	jalr	750(ra) # 80005cc0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019da:	18848493          	addi	s1,s1,392
    800019de:	03248263          	beq	s1,s2,80001a02 <procdump+0x9a>
    if(p->state == UNUSED)
    800019e2:	86a6                	mv	a3,s1
    800019e4:	ec04a783          	lw	a5,-320(s1)
    800019e8:	dbed                	beqz	a5,800019da <procdump+0x72>
      state = "???";
    800019ea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ec:	fcfb6be3          	bltu	s6,a5,800019c2 <procdump+0x5a>
    800019f0:	02079713          	slli	a4,a5,0x20
    800019f4:	01d75793          	srli	a5,a4,0x1d
    800019f8:	97de                	add	a5,a5,s7
    800019fa:	6390                	ld	a2,0(a5)
    800019fc:	f279                	bnez	a2,800019c2 <procdump+0x5a>
      state = "???";
    800019fe:	864e                	mv	a2,s3
    80001a00:	b7c9                	j	800019c2 <procdump+0x5a>
  }
}
    80001a02:	60a6                	ld	ra,72(sp)
    80001a04:	6406                	ld	s0,64(sp)
    80001a06:	74e2                	ld	s1,56(sp)
    80001a08:	7942                	ld	s2,48(sp)
    80001a0a:	79a2                	ld	s3,40(sp)
    80001a0c:	7a02                	ld	s4,32(sp)
    80001a0e:	6ae2                	ld	s5,24(sp)
    80001a10:	6b42                	ld	s6,16(sp)
    80001a12:	6ba2                	ld	s7,8(sp)
    80001a14:	6161                	addi	sp,sp,80
    80001a16:	8082                	ret

0000000080001a18 <swtch>:
    80001a18:	00153023          	sd	ra,0(a0)
    80001a1c:	00253423          	sd	sp,8(a0)
    80001a20:	e900                	sd	s0,16(a0)
    80001a22:	ed04                	sd	s1,24(a0)
    80001a24:	03253023          	sd	s2,32(a0)
    80001a28:	03353423          	sd	s3,40(a0)
    80001a2c:	03453823          	sd	s4,48(a0)
    80001a30:	03553c23          	sd	s5,56(a0)
    80001a34:	05653023          	sd	s6,64(a0)
    80001a38:	05753423          	sd	s7,72(a0)
    80001a3c:	05853823          	sd	s8,80(a0)
    80001a40:	05953c23          	sd	s9,88(a0)
    80001a44:	07a53023          	sd	s10,96(a0)
    80001a48:	07b53423          	sd	s11,104(a0)
    80001a4c:	0005b083          	ld	ra,0(a1)
    80001a50:	0085b103          	ld	sp,8(a1)
    80001a54:	6980                	ld	s0,16(a1)
    80001a56:	6d84                	ld	s1,24(a1)
    80001a58:	0205b903          	ld	s2,32(a1)
    80001a5c:	0285b983          	ld	s3,40(a1)
    80001a60:	0305ba03          	ld	s4,48(a1)
    80001a64:	0385ba83          	ld	s5,56(a1)
    80001a68:	0405bb03          	ld	s6,64(a1)
    80001a6c:	0485bb83          	ld	s7,72(a1)
    80001a70:	0505bc03          	ld	s8,80(a1)
    80001a74:	0585bc83          	ld	s9,88(a1)
    80001a78:	0605bd03          	ld	s10,96(a1)
    80001a7c:	0685bd83          	ld	s11,104(a1)
    80001a80:	8082                	ret

0000000080001a82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a82:	1141                	addi	sp,sp,-16
    80001a84:	e406                	sd	ra,8(sp)
    80001a86:	e022                	sd	s0,0(sp)
    80001a88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a8a:	00006597          	auipc	a1,0x6
    80001a8e:	7e658593          	addi	a1,a1,2022 # 80008270 <states.0+0x30>
    80001a92:	0000e517          	auipc	a0,0xe
    80001a96:	bee50513          	addi	a0,a0,-1042 # 8000f680 <tickslock>
    80001a9a:	00004097          	auipc	ra,0x4
    80001a9e:	652080e7          	jalr	1618(ra) # 800060ec <initlock>
}
    80001aa2:	60a2                	ld	ra,8(sp)
    80001aa4:	6402                	ld	s0,0(sp)
    80001aa6:	0141                	addi	sp,sp,16
    80001aa8:	8082                	ret

0000000080001aaa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aaa:	1141                	addi	sp,sp,-16
    80001aac:	e422                	sd	s0,8(sp)
    80001aae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ab0:	00003797          	auipc	a5,0x3
    80001ab4:	59078793          	addi	a5,a5,1424 # 80005040 <kernelvec>
    80001ab8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001abc:	6422                	ld	s0,8(sp)
    80001abe:	0141                	addi	sp,sp,16
    80001ac0:	8082                	ret

0000000080001ac2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aca:	fffff097          	auipc	ra,0xfffff
    80001ace:	37a080e7          	jalr	890(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ad2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ad6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001adc:	00005697          	auipc	a3,0x5
    80001ae0:	52468693          	addi	a3,a3,1316 # 80007000 <_trampoline>
    80001ae4:	00005717          	auipc	a4,0x5
    80001ae8:	51c70713          	addi	a4,a4,1308 # 80007000 <_trampoline>
    80001aec:	8f15                	sub	a4,a4,a3
    80001aee:	040007b7          	lui	a5,0x4000
    80001af2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001af4:	07b2                	slli	a5,a5,0xc
    80001af6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af8:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001afc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001afe:	18002673          	csrr	a2,satp
    80001b02:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b04:	6d30                	ld	a2,88(a0)
    80001b06:	6138                	ld	a4,64(a0)
    80001b08:	6585                	lui	a1,0x1
    80001b0a:	972e                	add	a4,a4,a1
    80001b0c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b0e:	6d38                	ld	a4,88(a0)
    80001b10:	00000617          	auipc	a2,0x0
    80001b14:	13860613          	addi	a2,a2,312 # 80001c48 <usertrap>
    80001b18:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b1c:	8612                	mv	a2,tp
    80001b1e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b24:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b28:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b2c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b32:	6f18                	ld	a4,24(a4)
    80001b34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b38:	692c                	ld	a1,80(a0)
    80001b3a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b3c:	00005717          	auipc	a4,0x5
    80001b40:	55470713          	addi	a4,a4,1364 # 80007090 <userret>
    80001b44:	8f15                	sub	a4,a4,a3
    80001b46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b48:	577d                	li	a4,-1
    80001b4a:	177e                	slli	a4,a4,0x3f
    80001b4c:	8dd9                	or	a1,a1,a4
    80001b4e:	02000537          	lui	a0,0x2000
    80001b52:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b54:	0536                	slli	a0,a0,0xd
    80001b56:	9782                	jalr	a5
}
    80001b58:	60a2                	ld	ra,8(sp)
    80001b5a:	6402                	ld	s0,0(sp)
    80001b5c:	0141                	addi	sp,sp,16
    80001b5e:	8082                	ret

0000000080001b60 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b60:	1101                	addi	sp,sp,-32
    80001b62:	ec06                	sd	ra,24(sp)
    80001b64:	e822                	sd	s0,16(sp)
    80001b66:	e426                	sd	s1,8(sp)
    80001b68:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b6a:	0000e497          	auipc	s1,0xe
    80001b6e:	b1648493          	addi	s1,s1,-1258 # 8000f680 <tickslock>
    80001b72:	8526                	mv	a0,s1
    80001b74:	00004097          	auipc	ra,0x4
    80001b78:	608080e7          	jalr	1544(ra) # 8000617c <acquire>
  ticks++;
    80001b7c:	00007517          	auipc	a0,0x7
    80001b80:	49c50513          	addi	a0,a0,1180 # 80009018 <ticks>
    80001b84:	411c                	lw	a5,0(a0)
    80001b86:	2785                	addiw	a5,a5,1
    80001b88:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b8a:	00000097          	auipc	ra,0x0
    80001b8e:	b1a080e7          	jalr	-1254(ra) # 800016a4 <wakeup>
  release(&tickslock);
    80001b92:	8526                	mv	a0,s1
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	69c080e7          	jalr	1692(ra) # 80006230 <release>
}
    80001b9c:	60e2                	ld	ra,24(sp)
    80001b9e:	6442                	ld	s0,16(sp)
    80001ba0:	64a2                	ld	s1,8(sp)
    80001ba2:	6105                	addi	sp,sp,32
    80001ba4:	8082                	ret

0000000080001ba6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ba6:	1101                	addi	sp,sp,-32
    80001ba8:	ec06                	sd	ra,24(sp)
    80001baa:	e822                	sd	s0,16(sp)
    80001bac:	e426                	sd	s1,8(sp)
    80001bae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bb0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bb4:	00074d63          	bltz	a4,80001bce <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb8:	57fd                	li	a5,-1
    80001bba:	17fe                	slli	a5,a5,0x3f
    80001bbc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bbe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bc0:	06f70363          	beq	a4,a5,80001c26 <devintr+0x80>
  }
}
    80001bc4:	60e2                	ld	ra,24(sp)
    80001bc6:	6442                	ld	s0,16(sp)
    80001bc8:	64a2                	ld	s1,8(sp)
    80001bca:	6105                	addi	sp,sp,32
    80001bcc:	8082                	ret
     (scause & 0xff) == 9){
    80001bce:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bd2:	46a5                	li	a3,9
    80001bd4:	fed792e3          	bne	a5,a3,80001bb8 <devintr+0x12>
    int irq = plic_claim();
    80001bd8:	00003097          	auipc	ra,0x3
    80001bdc:	570080e7          	jalr	1392(ra) # 80005148 <plic_claim>
    80001be0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001be2:	47a9                	li	a5,10
    80001be4:	02f50763          	beq	a0,a5,80001c12 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be8:	4785                	li	a5,1
    80001bea:	02f50963          	beq	a0,a5,80001c1c <devintr+0x76>
    return 1;
    80001bee:	4505                	li	a0,1
    } else if(irq){
    80001bf0:	d8f1                	beqz	s1,80001bc4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bf2:	85a6                	mv	a1,s1
    80001bf4:	00006517          	auipc	a0,0x6
    80001bf8:	68450513          	addi	a0,a0,1668 # 80008278 <states.0+0x38>
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	0c4080e7          	jalr	196(ra) # 80005cc0 <printf>
      plic_complete(irq);
    80001c04:	8526                	mv	a0,s1
    80001c06:	00003097          	auipc	ra,0x3
    80001c0a:	566080e7          	jalr	1382(ra) # 8000516c <plic_complete>
    return 1;
    80001c0e:	4505                	li	a0,1
    80001c10:	bf55                	j	80001bc4 <devintr+0x1e>
      uartintr();
    80001c12:	00004097          	auipc	ra,0x4
    80001c16:	48a080e7          	jalr	1162(ra) # 8000609c <uartintr>
    80001c1a:	b7ed                	j	80001c04 <devintr+0x5e>
      virtio_disk_intr();
    80001c1c:	00004097          	auipc	ra,0x4
    80001c20:	9dc080e7          	jalr	-1572(ra) # 800055f8 <virtio_disk_intr>
    80001c24:	b7c5                	j	80001c04 <devintr+0x5e>
    if(cpuid() == 0){
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	1f2080e7          	jalr	498(ra) # 80000e18 <cpuid>
    80001c2e:	c901                	beqz	a0,80001c3e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c30:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c34:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c36:	14479073          	csrw	sip,a5
    return 2;
    80001c3a:	4509                	li	a0,2
    80001c3c:	b761                	j	80001bc4 <devintr+0x1e>
      clockintr();
    80001c3e:	00000097          	auipc	ra,0x0
    80001c42:	f22080e7          	jalr	-222(ra) # 80001b60 <clockintr>
    80001c46:	b7ed                	j	80001c30 <devintr+0x8a>

0000000080001c48 <usertrap>:
{
    80001c48:	1101                	addi	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	e04a                	sd	s2,0(sp)
    80001c52:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c54:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c58:	1007f793          	andi	a5,a5,256
    80001c5c:	e3ad                	bnez	a5,80001cbe <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c5e:	00003797          	auipc	a5,0x3
    80001c62:	3e278793          	addi	a5,a5,994 # 80005040 <kernelvec>
    80001c66:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c6a:	fffff097          	auipc	ra,0xfffff
    80001c6e:	1da080e7          	jalr	474(ra) # 80000e44 <myproc>
    80001c72:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c74:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c76:	14102773          	csrr	a4,sepc
    80001c7a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c7c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c80:	47a1                	li	a5,8
    80001c82:	04f71c63          	bne	a4,a5,80001cda <usertrap+0x92>
    if(p->killed)
    80001c86:	551c                	lw	a5,40(a0)
    80001c88:	e3b9                	bnez	a5,80001cce <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c8a:	6cb8                	ld	a4,88(s1)
    80001c8c:	6f1c                	ld	a5,24(a4)
    80001c8e:	0791                	addi	a5,a5,4
    80001c90:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c96:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c9a:	10079073          	csrw	sstatus,a5
    syscall();
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	31a080e7          	jalr	794(ra) # 80001fb8 <syscall>
  if(p->killed)
    80001ca6:	549c                	lw	a5,40(s1)
    80001ca8:	e7c5                	bnez	a5,80001d50 <usertrap+0x108>
  usertrapret();
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	e18080e7          	jalr	-488(ra) # 80001ac2 <usertrapret>
}
    80001cb2:	60e2                	ld	ra,24(sp)
    80001cb4:	6442                	ld	s0,16(sp)
    80001cb6:	64a2                	ld	s1,8(sp)
    80001cb8:	6902                	ld	s2,0(sp)
    80001cba:	6105                	addi	sp,sp,32
    80001cbc:	8082                	ret
    panic("usertrap: not from user mode");
    80001cbe:	00006517          	auipc	a0,0x6
    80001cc2:	5da50513          	addi	a0,a0,1498 # 80008298 <states.0+0x58>
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	fa8080e7          	jalr	-88(ra) # 80005c6e <panic>
      exit(-1);
    80001cce:	557d                	li	a0,-1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	aa4080e7          	jalr	-1372(ra) # 80001774 <exit>
    80001cd8:	bf4d                	j	80001c8a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	ecc080e7          	jalr	-308(ra) # 80001ba6 <devintr>
    80001ce2:	892a                	mv	s2,a0
    80001ce4:	c501                	beqz	a0,80001cec <usertrap+0xa4>
  if(p->killed)
    80001ce6:	549c                	lw	a5,40(s1)
    80001ce8:	c3a1                	beqz	a5,80001d28 <usertrap+0xe0>
    80001cea:	a815                	j	80001d1e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cec:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cf0:	5890                	lw	a2,48(s1)
    80001cf2:	00006517          	auipc	a0,0x6
    80001cf6:	5c650513          	addi	a0,a0,1478 # 800082b8 <states.0+0x78>
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	fc6080e7          	jalr	-58(ra) # 80005cc0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d02:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d06:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d0a:	00006517          	auipc	a0,0x6
    80001d0e:	5de50513          	addi	a0,a0,1502 # 800082e8 <states.0+0xa8>
    80001d12:	00004097          	auipc	ra,0x4
    80001d16:	fae080e7          	jalr	-82(ra) # 80005cc0 <printf>
    p->killed = 1;
    80001d1a:	4785                	li	a5,1
    80001d1c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d1e:	557d                	li	a0,-1
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	a54080e7          	jalr	-1452(ra) # 80001774 <exit>
  if(which_dev == 2){   // timer interrupt
    80001d28:	4789                	li	a5,2
    80001d2a:	f8f910e3          	bne	s2,a5,80001caa <usertrap+0x62>
    if(p->interval != 0 && ++p->passedticks == p->interval){
    80001d2e:	1684a783          	lw	a5,360(s1)
    80001d32:	cb91                	beqz	a5,80001d46 <usertrap+0xfe>
    80001d34:	1784a703          	lw	a4,376(s1)
    80001d38:	2705                	addiw	a4,a4,1
    80001d3a:	0007069b          	sext.w	a3,a4
    80001d3e:	16e4ac23          	sw	a4,376(s1)
    80001d42:	00d78963          	beq	a5,a3,80001d54 <usertrap+0x10c>
    yield();
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	796080e7          	jalr	1942(ra) # 800014dc <yield>
    80001d4e:	bfb1                	j	80001caa <usertrap+0x62>
  int which_dev = 0;
    80001d50:	4901                	li	s2,0
    80001d52:	b7f1                	j	80001d1e <usertrap+0xd6>
   p->trapframecopy = p->trapframe + 512;  
    80001d54:	6cac                	ld	a1,88(s1)
    80001d56:	00024537          	lui	a0,0x24
    80001d5a:	952e                	add	a0,a0,a1
    80001d5c:	18a4b023          	sd	a0,384(s1)
      memmove(p->trapframecopy,p->trapframe,sizeof(struct trapframe));    // copy trapframe
    80001d60:	12000613          	li	a2,288
    80001d64:	ffffe097          	auipc	ra,0xffffe
    80001d68:	472080e7          	jalr	1138(ra) # 800001d6 <memmove>
      p->trapframe->epc = p->handler;   // execute handler() when return to user space
    80001d6c:	6cbc                	ld	a5,88(s1)
    80001d6e:	1704b703          	ld	a4,368(s1)
    80001d72:	ef98                	sd	a4,24(a5)
    80001d74:	bfc9                	j	80001d46 <usertrap+0xfe>

0000000080001d76 <kerneltrap>:
{
    80001d76:	7179                	addi	sp,sp,-48
    80001d78:	f406                	sd	ra,40(sp)
    80001d7a:	f022                	sd	s0,32(sp)
    80001d7c:	ec26                	sd	s1,24(sp)
    80001d7e:	e84a                	sd	s2,16(sp)
    80001d80:	e44e                	sd	s3,8(sp)
    80001d82:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d84:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d8c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d90:	1004f793          	andi	a5,s1,256
    80001d94:	cb85                	beqz	a5,80001dc4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d9a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d9c:	ef85                	bnez	a5,80001dd4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	e08080e7          	jalr	-504(ra) # 80001ba6 <devintr>
    80001da6:	cd1d                	beqz	a0,80001de4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001da8:	4789                	li	a5,2
    80001daa:	06f50a63          	beq	a0,a5,80001e1e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dae:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db2:	10049073          	csrw	sstatus,s1
}
    80001db6:	70a2                	ld	ra,40(sp)
    80001db8:	7402                	ld	s0,32(sp)
    80001dba:	64e2                	ld	s1,24(sp)
    80001dbc:	6942                	ld	s2,16(sp)
    80001dbe:	69a2                	ld	s3,8(sp)
    80001dc0:	6145                	addi	sp,sp,48
    80001dc2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	54450513          	addi	a0,a0,1348 # 80008308 <states.0+0xc8>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	ea2080e7          	jalr	-350(ra) # 80005c6e <panic>
    panic("kerneltrap: interrupts enabled");
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	55c50513          	addi	a0,a0,1372 # 80008330 <states.0+0xf0>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	e92080e7          	jalr	-366(ra) # 80005c6e <panic>
    printf("scause %p\n", scause);
    80001de4:	85ce                	mv	a1,s3
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	56a50513          	addi	a0,a0,1386 # 80008350 <states.0+0x110>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	ed2080e7          	jalr	-302(ra) # 80005cc0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dfa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	56250513          	addi	a0,a0,1378 # 80008360 <states.0+0x120>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	eba080e7          	jalr	-326(ra) # 80005cc0 <printf>
    panic("kerneltrap");
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	56a50513          	addi	a0,a0,1386 # 80008378 <states.0+0x138>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	e58080e7          	jalr	-424(ra) # 80005c6e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	026080e7          	jalr	38(ra) # 80000e44 <myproc>
    80001e26:	d541                	beqz	a0,80001dae <kerneltrap+0x38>
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	01c080e7          	jalr	28(ra) # 80000e44 <myproc>
    80001e30:	4d18                	lw	a4,24(a0)
    80001e32:	4791                	li	a5,4
    80001e34:	f6f71de3          	bne	a4,a5,80001dae <kerneltrap+0x38>
    yield();
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	6a4080e7          	jalr	1700(ra) # 800014dc <yield>
    80001e40:	b7bd                	j	80001dae <kerneltrap+0x38>

0000000080001e42 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e42:	1101                	addi	sp,sp,-32
    80001e44:	ec06                	sd	ra,24(sp)
    80001e46:	e822                	sd	s0,16(sp)
    80001e48:	e426                	sd	s1,8(sp)
    80001e4a:	1000                	addi	s0,sp,32
    80001e4c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	ff6080e7          	jalr	-10(ra) # 80000e44 <myproc>
  switch (n) {
    80001e56:	4795                	li	a5,5
    80001e58:	0497e163          	bltu	a5,s1,80001e9a <argraw+0x58>
    80001e5c:	048a                	slli	s1,s1,0x2
    80001e5e:	00006717          	auipc	a4,0x6
    80001e62:	55270713          	addi	a4,a4,1362 # 800083b0 <states.0+0x170>
    80001e66:	94ba                	add	s1,s1,a4
    80001e68:	409c                	lw	a5,0(s1)
    80001e6a:	97ba                	add	a5,a5,a4
    80001e6c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e6e:	6d3c                	ld	a5,88(a0)
    80001e70:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret
    return p->trapframe->a1;
    80001e7c:	6d3c                	ld	a5,88(a0)
    80001e7e:	7fa8                	ld	a0,120(a5)
    80001e80:	bfcd                	j	80001e72 <argraw+0x30>
    return p->trapframe->a2;
    80001e82:	6d3c                	ld	a5,88(a0)
    80001e84:	63c8                	ld	a0,128(a5)
    80001e86:	b7f5                	j	80001e72 <argraw+0x30>
    return p->trapframe->a3;
    80001e88:	6d3c                	ld	a5,88(a0)
    80001e8a:	67c8                	ld	a0,136(a5)
    80001e8c:	b7dd                	j	80001e72 <argraw+0x30>
    return p->trapframe->a4;
    80001e8e:	6d3c                	ld	a5,88(a0)
    80001e90:	6bc8                	ld	a0,144(a5)
    80001e92:	b7c5                	j	80001e72 <argraw+0x30>
    return p->trapframe->a5;
    80001e94:	6d3c                	ld	a5,88(a0)
    80001e96:	6fc8                	ld	a0,152(a5)
    80001e98:	bfe9                	j	80001e72 <argraw+0x30>
  panic("argraw");
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	4ee50513          	addi	a0,a0,1262 # 80008388 <states.0+0x148>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	dcc080e7          	jalr	-564(ra) # 80005c6e <panic>

0000000080001eaa <fetchaddr>:
{
    80001eaa:	1101                	addi	sp,sp,-32
    80001eac:	ec06                	sd	ra,24(sp)
    80001eae:	e822                	sd	s0,16(sp)
    80001eb0:	e426                	sd	s1,8(sp)
    80001eb2:	e04a                	sd	s2,0(sp)
    80001eb4:	1000                	addi	s0,sp,32
    80001eb6:	84aa                	mv	s1,a0
    80001eb8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	f8a080e7          	jalr	-118(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ec2:	653c                	ld	a5,72(a0)
    80001ec4:	02f4f863          	bgeu	s1,a5,80001ef4 <fetchaddr+0x4a>
    80001ec8:	00848713          	addi	a4,s1,8
    80001ecc:	02e7e663          	bltu	a5,a4,80001ef8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ed0:	46a1                	li	a3,8
    80001ed2:	8626                	mv	a2,s1
    80001ed4:	85ca                	mv	a1,s2
    80001ed6:	6928                	ld	a0,80(a0)
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	cbc080e7          	jalr	-836(ra) # 80000b94 <copyin>
    80001ee0:	00a03533          	snez	a0,a0
    80001ee4:	40a00533          	neg	a0,a0
}
    80001ee8:	60e2                	ld	ra,24(sp)
    80001eea:	6442                	ld	s0,16(sp)
    80001eec:	64a2                	ld	s1,8(sp)
    80001eee:	6902                	ld	s2,0(sp)
    80001ef0:	6105                	addi	sp,sp,32
    80001ef2:	8082                	ret
    return -1;
    80001ef4:	557d                	li	a0,-1
    80001ef6:	bfcd                	j	80001ee8 <fetchaddr+0x3e>
    80001ef8:	557d                	li	a0,-1
    80001efa:	b7fd                	j	80001ee8 <fetchaddr+0x3e>

0000000080001efc <fetchstr>:
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	e44e                	sd	s3,8(sp)
    80001f08:	1800                	addi	s0,sp,48
    80001f0a:	892a                	mv	s2,a0
    80001f0c:	84ae                	mv	s1,a1
    80001f0e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	f34080e7          	jalr	-204(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f18:	86ce                	mv	a3,s3
    80001f1a:	864a                	mv	a2,s2
    80001f1c:	85a6                	mv	a1,s1
    80001f1e:	6928                	ld	a0,80(a0)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	d02080e7          	jalr	-766(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f28:	00054763          	bltz	a0,80001f36 <fetchstr+0x3a>
  return strlen(buf);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	ffffe097          	auipc	ra,0xffffe
    80001f32:	3c8080e7          	jalr	968(ra) # 800002f6 <strlen>
}
    80001f36:	70a2                	ld	ra,40(sp)
    80001f38:	7402                	ld	s0,32(sp)
    80001f3a:	64e2                	ld	s1,24(sp)
    80001f3c:	6942                	ld	s2,16(sp)
    80001f3e:	69a2                	ld	s3,8(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret

0000000080001f44 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	ef2080e7          	jalr	-270(ra) # 80001e42 <argraw>
    80001f58:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f5a:	4501                	li	a0,0
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6105                	addi	sp,sp,32
    80001f64:	8082                	ret

0000000080001f66 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	ed0080e7          	jalr	-304(ra) # 80001e42 <argraw>
    80001f7a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f7c:	4501                	li	a0,0
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6105                	addi	sp,sp,32
    80001f86:	8082                	ret

0000000080001f88 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	e04a                	sd	s2,0(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84ae                	mv	s1,a1
    80001f96:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	eaa080e7          	jalr	-342(ra) # 80001e42 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fa0:	864a                	mv	a2,s2
    80001fa2:	85a6                	mv	a1,s1
    80001fa4:	00000097          	auipc	ra,0x0
    80001fa8:	f58080e7          	jalr	-168(ra) # 80001efc <fetchstr>
}
    80001fac:	60e2                	ld	ra,24(sp)
    80001fae:	6442                	ld	s0,16(sp)
    80001fb0:	64a2                	ld	s1,8(sp)
    80001fb2:	6902                	ld	s2,0(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret

0000000080001fb8 <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80001fb8:	1101                	addi	sp,sp,-32
    80001fba:	ec06                	sd	ra,24(sp)
    80001fbc:	e822                	sd	s0,16(sp)
    80001fbe:	e426                	sd	s1,8(sp)
    80001fc0:	e04a                	sd	s2,0(sp)
    80001fc2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	e80080e7          	jalr	-384(ra) # 80000e44 <myproc>
    80001fcc:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fce:	05853903          	ld	s2,88(a0)
    80001fd2:	0a893783          	ld	a5,168(s2)
    80001fd6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fda:	37fd                	addiw	a5,a5,-1
    80001fdc:	4759                	li	a4,22
    80001fde:	00f76f63          	bltu	a4,a5,80001ffc <syscall+0x44>
    80001fe2:	00369713          	slli	a4,a3,0x3
    80001fe6:	00006797          	auipc	a5,0x6
    80001fea:	3e278793          	addi	a5,a5,994 # 800083c8 <syscalls>
    80001fee:	97ba                	add	a5,a5,a4
    80001ff0:	639c                	ld	a5,0(a5)
    80001ff2:	c789                	beqz	a5,80001ffc <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001ff4:	9782                	jalr	a5
    80001ff6:	06a93823          	sd	a0,112(s2)
    80001ffa:	a839                	j	80002018 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ffc:	15848613          	addi	a2,s1,344
    80002000:	588c                	lw	a1,48(s1)
    80002002:	00006517          	auipc	a0,0x6
    80002006:	38e50513          	addi	a0,a0,910 # 80008390 <states.0+0x150>
    8000200a:	00004097          	auipc	ra,0x4
    8000200e:	cb6080e7          	jalr	-842(ra) # 80005cc0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002012:	6cbc                	ld	a5,88(s1)
    80002014:	577d                	li	a4,-1
    80002016:	fbb8                	sd	a4,112(a5)
  }
}
    80002018:	60e2                	ld	ra,24(sp)
    8000201a:	6442                	ld	s0,16(sp)
    8000201c:	64a2                	ld	s1,8(sp)
    8000201e:	6902                	ld	s2,0(sp)
    80002020:	6105                	addi	sp,sp,32
    80002022:	8082                	ret

0000000080002024 <sys_sigalarm>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"


uint64 sys_sigalarm(void) {
    80002024:	1101                	addi	sp,sp,-32
    80002026:	ec06                	sd	ra,24(sp)
    80002028:	e822                	sd	s0,16(sp)
    8000202a:	1000                	addi	s0,sp,32
    int interval;
    uint64 handler;
    struct proc *p;
    // 要求时间间隔非负
    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    8000202c:	fec40593          	addi	a1,s0,-20
    80002030:	4501                	li	a0,0
    80002032:	00000097          	auipc	ra,0x0
    80002036:	f12080e7          	jalr	-238(ra) # 80001f44 <argint>
        return -1;
    8000203a:	577d                	li	a4,-1
    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    8000203c:	02054f63          	bltz	a0,8000207a <sys_sigalarm+0x56>
    80002040:	fe040593          	addi	a1,s0,-32
    80002044:	4505                	li	a0,1
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	f20080e7          	jalr	-224(ra) # 80001f66 <argaddr>
    8000204e:	fec42783          	lw	a5,-20(s0)
    80002052:	8fc9                	or	a5,a5,a0
    80002054:	2781                	sext.w	a5,a5
        return -1;
    80002056:	577d                	li	a4,-1
    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002058:	0207c163          	bltz	a5,8000207a <sys_sigalarm+0x56>
    }
    // lab4-3
    p = myproc();
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	de8080e7          	jalr	-536(ra) # 80000e44 <myproc>
    p->interval = interval;
    80002064:	fec42783          	lw	a5,-20(s0)
    80002068:	16f52423          	sw	a5,360(a0)
    p->handler = handler;
    8000206c:	fe043783          	ld	a5,-32(s0)
    80002070:	16f53823          	sd	a5,368(a0)
    p->passedticks = 0;    // 重置过去时钟数
    80002074:	16052c23          	sw	zero,376(a0)

    return 0;
    80002078:	4701                	li	a4,0
}
    8000207a:	853a                	mv	a0,a4
    8000207c:	60e2                	ld	ra,24(sp)
    8000207e:	6442                	ld	s0,16(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    80002084:	1101                	addi	sp,sp,-32
    80002086:	ec06                	sd	ra,24(sp)
    80002088:	e822                	sd	s0,16(sp)
    8000208a:	e426                	sd	s1,8(sp)
    8000208c:	1000                	addi	s0,sp,32
 struct proc* p = myproc();
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	db6080e7          	jalr	-586(ra) # 80000e44 <myproc>
    80002096:	84aa                	mv	s1,a0
    // trapframecopy must have the copy of trapframe
    if(p->trapframecopy != p->trapframe + 512) {
    80002098:	18053583          	ld	a1,384(a0)
    8000209c:	6d38                	ld	a4,88(a0)
    8000209e:	000247b7          	lui	a5,0x24
    800020a2:	97ba                	add	a5,a5,a4
        return -1;
    800020a4:	557d                	li	a0,-1
    if(p->trapframecopy != p->trapframe + 512) {
    800020a6:	00f58763          	beq	a1,a5,800020b4 <sys_sigreturn+0x30>
    }
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
    p->passedticks = 0;     // prevent re-entrant
    p->trapframecopy = 0;    // 置零
    return 0;
}
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
    800020b4:	12000613          	li	a2,288
    800020b8:	853a                	mv	a0,a4
    800020ba:	ffffe097          	auipc	ra,0xffffe
    800020be:	11c080e7          	jalr	284(ra) # 800001d6 <memmove>
    p->passedticks = 0;     // prevent re-entrant
    800020c2:	1604ac23          	sw	zero,376(s1)
    p->trapframecopy = 0;    // 置零
    800020c6:	1804b023          	sd	zero,384(s1)
    return 0;
    800020ca:	4501                	li	a0,0
    800020cc:	bff9                	j	800020aa <sys_sigreturn+0x26>

00000000800020ce <sys_exit>:

uint64
sys_exit(void)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020d6:	fec40593          	addi	a1,s0,-20
    800020da:	4501                	li	a0,0
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	e68080e7          	jalr	-408(ra) # 80001f44 <argint>
    return -1;
    800020e4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020e6:	00054963          	bltz	a0,800020f8 <sys_exit+0x2a>
  exit(n);
    800020ea:	fec42503          	lw	a0,-20(s0)
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	686080e7          	jalr	1670(ra) # 80001774 <exit>
  return 0;  // not reached
    800020f6:	4781                	li	a5,0
}
    800020f8:	853e                	mv	a0,a5
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	6105                	addi	sp,sp,32
    80002100:	8082                	ret

0000000080002102 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002102:	1141                	addi	sp,sp,-16
    80002104:	e406                	sd	ra,8(sp)
    80002106:	e022                	sd	s0,0(sp)
    80002108:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	d3a080e7          	jalr	-710(ra) # 80000e44 <myproc>
}
    80002112:	5908                	lw	a0,48(a0)
    80002114:	60a2                	ld	ra,8(sp)
    80002116:	6402                	ld	s0,0(sp)
    80002118:	0141                	addi	sp,sp,16
    8000211a:	8082                	ret

000000008000211c <sys_fork>:

uint64
sys_fork(void)
{
    8000211c:	1141                	addi	sp,sp,-16
    8000211e:	e406                	sd	ra,8(sp)
    80002120:	e022                	sd	s0,0(sp)
    80002122:	0800                	addi	s0,sp,16
  return fork();
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	102080e7          	jalr	258(ra) # 80001226 <fork>
}
    8000212c:	60a2                	ld	ra,8(sp)
    8000212e:	6402                	ld	s0,0(sp)
    80002130:	0141                	addi	sp,sp,16
    80002132:	8082                	ret

0000000080002134 <sys_wait>:

uint64
sys_wait(void)
{
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000213c:	fe840593          	addi	a1,s0,-24
    80002140:	4501                	li	a0,0
    80002142:	00000097          	auipc	ra,0x0
    80002146:	e24080e7          	jalr	-476(ra) # 80001f66 <argaddr>
    8000214a:	87aa                	mv	a5,a0
    return -1;
    8000214c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000214e:	0007c863          	bltz	a5,8000215e <sys_wait+0x2a>
  return wait(p);
    80002152:	fe843503          	ld	a0,-24(s0)
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	426080e7          	jalr	1062(ra) # 8000157c <wait>
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret

0000000080002166 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002166:	7179                	addi	sp,sp,-48
    80002168:	f406                	sd	ra,40(sp)
    8000216a:	f022                	sd	s0,32(sp)
    8000216c:	ec26                	sd	s1,24(sp)
    8000216e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002170:	fdc40593          	addi	a1,s0,-36
    80002174:	4501                	li	a0,0
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	dce080e7          	jalr	-562(ra) # 80001f44 <argint>
    8000217e:	87aa                	mv	a5,a0
    return -1;
    80002180:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002182:	0207c063          	bltz	a5,800021a2 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	cbe080e7          	jalr	-834(ra) # 80000e44 <myproc>
    8000218e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002190:	fdc42503          	lw	a0,-36(s0)
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	01a080e7          	jalr	26(ra) # 800011ae <growproc>
    8000219c:	00054863          	bltz	a0,800021ac <sys_sbrk+0x46>
    return -1;
  return addr;
    800021a0:	8526                	mv	a0,s1
}
    800021a2:	70a2                	ld	ra,40(sp)
    800021a4:	7402                	ld	s0,32(sp)
    800021a6:	64e2                	ld	s1,24(sp)
    800021a8:	6145                	addi	sp,sp,48
    800021aa:	8082                	ret
    return -1;
    800021ac:	557d                	li	a0,-1
    800021ae:	bfd5                	j	800021a2 <sys_sbrk+0x3c>

00000000800021b0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021b0:	7139                	addi	sp,sp,-64
    800021b2:	fc06                	sd	ra,56(sp)
    800021b4:	f822                	sd	s0,48(sp)
    800021b6:	f426                	sd	s1,40(sp)
    800021b8:	f04a                	sd	s2,32(sp)
    800021ba:	ec4e                	sd	s3,24(sp)
    800021bc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021be:	fcc40593          	addi	a1,s0,-52
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	d80080e7          	jalr	-640(ra) # 80001f44 <argint>
    return -1;
    800021cc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ce:	06054963          	bltz	a0,80002240 <sys_sleep+0x90>
  acquire(&tickslock);
    800021d2:	0000d517          	auipc	a0,0xd
    800021d6:	4ae50513          	addi	a0,a0,1198 # 8000f680 <tickslock>
    800021da:	00004097          	auipc	ra,0x4
    800021de:	fa2080e7          	jalr	-94(ra) # 8000617c <acquire>
  ticks0 = ticks;
    800021e2:	00007917          	auipc	s2,0x7
    800021e6:	e3692903          	lw	s2,-458(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ea:	fcc42783          	lw	a5,-52(s0)
    800021ee:	cf85                	beqz	a5,80002226 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021f0:	0000d997          	auipc	s3,0xd
    800021f4:	49098993          	addi	s3,s3,1168 # 8000f680 <tickslock>
    800021f8:	00007497          	auipc	s1,0x7
    800021fc:	e2048493          	addi	s1,s1,-480 # 80009018 <ticks>
    if(myproc()->killed){
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	c44080e7          	jalr	-956(ra) # 80000e44 <myproc>
    80002208:	551c                	lw	a5,40(a0)
    8000220a:	e3b9                	bnez	a5,80002250 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    8000220c:	85ce                	mv	a1,s3
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	308080e7          	jalr	776(ra) # 80001518 <sleep>
  while(ticks - ticks0 < n){
    80002218:	409c                	lw	a5,0(s1)
    8000221a:	412787bb          	subw	a5,a5,s2
    8000221e:	fcc42703          	lw	a4,-52(s0)
    80002222:	fce7efe3          	bltu	a5,a4,80002200 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002226:	0000d517          	auipc	a0,0xd
    8000222a:	45a50513          	addi	a0,a0,1114 # 8000f680 <tickslock>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	002080e7          	jalr	2(ra) # 80006230 <release>
  backtrace();//lab4-2
    80002236:	00004097          	auipc	ra,0x4
    8000223a:	9dc080e7          	jalr	-1572(ra) # 80005c12 <backtrace>
  return 0;
    8000223e:	4781                	li	a5,0
}
    80002240:	853e                	mv	a0,a5
    80002242:	70e2                	ld	ra,56(sp)
    80002244:	7442                	ld	s0,48(sp)
    80002246:	74a2                	ld	s1,40(sp)
    80002248:	7902                	ld	s2,32(sp)
    8000224a:	69e2                	ld	s3,24(sp)
    8000224c:	6121                	addi	sp,sp,64
    8000224e:	8082                	ret
      release(&tickslock);
    80002250:	0000d517          	auipc	a0,0xd
    80002254:	43050513          	addi	a0,a0,1072 # 8000f680 <tickslock>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	fd8080e7          	jalr	-40(ra) # 80006230 <release>
      return -1;
    80002260:	57fd                	li	a5,-1
    80002262:	bff9                	j	80002240 <sys_sleep+0x90>

0000000080002264 <sys_kill>:

uint64
sys_kill(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000226c:	fec40593          	addi	a1,s0,-20
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	cd2080e7          	jalr	-814(ra) # 80001f44 <argint>
    8000227a:	87aa                	mv	a5,a0
    return -1;
    8000227c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000227e:	0007c863          	bltz	a5,8000228e <sys_kill+0x2a>
  return kill(pid);
    80002282:	fec42503          	lw	a0,-20(s0)
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	5c4080e7          	jalr	1476(ra) # 8000184a <kill>
}
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	6105                	addi	sp,sp,32
    80002294:	8082                	ret

0000000080002296 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002296:	1101                	addi	sp,sp,-32
    80002298:	ec06                	sd	ra,24(sp)
    8000229a:	e822                	sd	s0,16(sp)
    8000229c:	e426                	sd	s1,8(sp)
    8000229e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022a0:	0000d517          	auipc	a0,0xd
    800022a4:	3e050513          	addi	a0,a0,992 # 8000f680 <tickslock>
    800022a8:	00004097          	auipc	ra,0x4
    800022ac:	ed4080e7          	jalr	-300(ra) # 8000617c <acquire>
  xticks = ticks;
    800022b0:	00007497          	auipc	s1,0x7
    800022b4:	d684a483          	lw	s1,-664(s1) # 80009018 <ticks>
  release(&tickslock);
    800022b8:	0000d517          	auipc	a0,0xd
    800022bc:	3c850513          	addi	a0,a0,968 # 8000f680 <tickslock>
    800022c0:	00004097          	auipc	ra,0x4
    800022c4:	f70080e7          	jalr	-144(ra) # 80006230 <release>
  return xticks;
}
    800022c8:	02049513          	slli	a0,s1,0x20
    800022cc:	9101                	srli	a0,a0,0x20
    800022ce:	60e2                	ld	ra,24(sp)
    800022d0:	6442                	ld	s0,16(sp)
    800022d2:	64a2                	ld	s1,8(sp)
    800022d4:	6105                	addi	sp,sp,32
    800022d6:	8082                	ret

00000000800022d8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022d8:	7179                	addi	sp,sp,-48
    800022da:	f406                	sd	ra,40(sp)
    800022dc:	f022                	sd	s0,32(sp)
    800022de:	ec26                	sd	s1,24(sp)
    800022e0:	e84a                	sd	s2,16(sp)
    800022e2:	e44e                	sd	s3,8(sp)
    800022e4:	e052                	sd	s4,0(sp)
    800022e6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022e8:	00006597          	auipc	a1,0x6
    800022ec:	1a058593          	addi	a1,a1,416 # 80008488 <syscalls+0xc0>
    800022f0:	0000d517          	auipc	a0,0xd
    800022f4:	3a850513          	addi	a0,a0,936 # 8000f698 <bcache>
    800022f8:	00004097          	auipc	ra,0x4
    800022fc:	df4080e7          	jalr	-524(ra) # 800060ec <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002300:	00015797          	auipc	a5,0x15
    80002304:	39878793          	addi	a5,a5,920 # 80017698 <bcache+0x8000>
    80002308:	00015717          	auipc	a4,0x15
    8000230c:	5f870713          	addi	a4,a4,1528 # 80017900 <bcache+0x8268>
    80002310:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002314:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002318:	0000d497          	auipc	s1,0xd
    8000231c:	39848493          	addi	s1,s1,920 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002320:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002322:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002324:	00006a17          	auipc	s4,0x6
    80002328:	16ca0a13          	addi	s4,s4,364 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000232c:	2b893783          	ld	a5,696(s2)
    80002330:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002332:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002336:	85d2                	mv	a1,s4
    80002338:	01048513          	addi	a0,s1,16
    8000233c:	00001097          	auipc	ra,0x1
    80002340:	4c2080e7          	jalr	1218(ra) # 800037fe <initsleeplock>
    bcache.head.next->prev = b;
    80002344:	2b893783          	ld	a5,696(s2)
    80002348:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000234a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000234e:	45848493          	addi	s1,s1,1112
    80002352:	fd349de3          	bne	s1,s3,8000232c <binit+0x54>
  }
}
    80002356:	70a2                	ld	ra,40(sp)
    80002358:	7402                	ld	s0,32(sp)
    8000235a:	64e2                	ld	s1,24(sp)
    8000235c:	6942                	ld	s2,16(sp)
    8000235e:	69a2                	ld	s3,8(sp)
    80002360:	6a02                	ld	s4,0(sp)
    80002362:	6145                	addi	sp,sp,48
    80002364:	8082                	ret

0000000080002366 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002366:	7179                	addi	sp,sp,-48
    80002368:	f406                	sd	ra,40(sp)
    8000236a:	f022                	sd	s0,32(sp)
    8000236c:	ec26                	sd	s1,24(sp)
    8000236e:	e84a                	sd	s2,16(sp)
    80002370:	e44e                	sd	s3,8(sp)
    80002372:	1800                	addi	s0,sp,48
    80002374:	892a                	mv	s2,a0
    80002376:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002378:	0000d517          	auipc	a0,0xd
    8000237c:	32050513          	addi	a0,a0,800 # 8000f698 <bcache>
    80002380:	00004097          	auipc	ra,0x4
    80002384:	dfc080e7          	jalr	-516(ra) # 8000617c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002388:	00015497          	auipc	s1,0x15
    8000238c:	5c84b483          	ld	s1,1480(s1) # 80017950 <bcache+0x82b8>
    80002390:	00015797          	auipc	a5,0x15
    80002394:	57078793          	addi	a5,a5,1392 # 80017900 <bcache+0x8268>
    80002398:	02f48f63          	beq	s1,a5,800023d6 <bread+0x70>
    8000239c:	873e                	mv	a4,a5
    8000239e:	a021                	j	800023a6 <bread+0x40>
    800023a0:	68a4                	ld	s1,80(s1)
    800023a2:	02e48a63          	beq	s1,a4,800023d6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023a6:	449c                	lw	a5,8(s1)
    800023a8:	ff279ce3          	bne	a5,s2,800023a0 <bread+0x3a>
    800023ac:	44dc                	lw	a5,12(s1)
    800023ae:	ff3799e3          	bne	a5,s3,800023a0 <bread+0x3a>
      b->refcnt++;
    800023b2:	40bc                	lw	a5,64(s1)
    800023b4:	2785                	addiw	a5,a5,1
    800023b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023b8:	0000d517          	auipc	a0,0xd
    800023bc:	2e050513          	addi	a0,a0,736 # 8000f698 <bcache>
    800023c0:	00004097          	auipc	ra,0x4
    800023c4:	e70080e7          	jalr	-400(ra) # 80006230 <release>
      acquiresleep(&b->lock);
    800023c8:	01048513          	addi	a0,s1,16
    800023cc:	00001097          	auipc	ra,0x1
    800023d0:	46c080e7          	jalr	1132(ra) # 80003838 <acquiresleep>
      return b;
    800023d4:	a8b9                	j	80002432 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023d6:	00015497          	auipc	s1,0x15
    800023da:	5724b483          	ld	s1,1394(s1) # 80017948 <bcache+0x82b0>
    800023de:	00015797          	auipc	a5,0x15
    800023e2:	52278793          	addi	a5,a5,1314 # 80017900 <bcache+0x8268>
    800023e6:	00f48863          	beq	s1,a5,800023f6 <bread+0x90>
    800023ea:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023ec:	40bc                	lw	a5,64(s1)
    800023ee:	cf81                	beqz	a5,80002406 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023f0:	64a4                	ld	s1,72(s1)
    800023f2:	fee49de3          	bne	s1,a4,800023ec <bread+0x86>
  panic("bget: no buffers");
    800023f6:	00006517          	auipc	a0,0x6
    800023fa:	0a250513          	addi	a0,a0,162 # 80008498 <syscalls+0xd0>
    800023fe:	00004097          	auipc	ra,0x4
    80002402:	870080e7          	jalr	-1936(ra) # 80005c6e <panic>
      b->dev = dev;
    80002406:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000240a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000240e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002412:	4785                	li	a5,1
    80002414:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002416:	0000d517          	auipc	a0,0xd
    8000241a:	28250513          	addi	a0,a0,642 # 8000f698 <bcache>
    8000241e:	00004097          	auipc	ra,0x4
    80002422:	e12080e7          	jalr	-494(ra) # 80006230 <release>
      acquiresleep(&b->lock);
    80002426:	01048513          	addi	a0,s1,16
    8000242a:	00001097          	auipc	ra,0x1
    8000242e:	40e080e7          	jalr	1038(ra) # 80003838 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002432:	409c                	lw	a5,0(s1)
    80002434:	cb89                	beqz	a5,80002446 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002436:	8526                	mv	a0,s1
    80002438:	70a2                	ld	ra,40(sp)
    8000243a:	7402                	ld	s0,32(sp)
    8000243c:	64e2                	ld	s1,24(sp)
    8000243e:	6942                	ld	s2,16(sp)
    80002440:	69a2                	ld	s3,8(sp)
    80002442:	6145                	addi	sp,sp,48
    80002444:	8082                	ret
    virtio_disk_rw(b, 0);
    80002446:	4581                	li	a1,0
    80002448:	8526                	mv	a0,s1
    8000244a:	00003097          	auipc	ra,0x3
    8000244e:	f28080e7          	jalr	-216(ra) # 80005372 <virtio_disk_rw>
    b->valid = 1;
    80002452:	4785                	li	a5,1
    80002454:	c09c                	sw	a5,0(s1)
  return b;
    80002456:	b7c5                	j	80002436 <bread+0xd0>

0000000080002458 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002458:	1101                	addi	sp,sp,-32
    8000245a:	ec06                	sd	ra,24(sp)
    8000245c:	e822                	sd	s0,16(sp)
    8000245e:	e426                	sd	s1,8(sp)
    80002460:	1000                	addi	s0,sp,32
    80002462:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002464:	0541                	addi	a0,a0,16
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	46c080e7          	jalr	1132(ra) # 800038d2 <holdingsleep>
    8000246e:	cd01                	beqz	a0,80002486 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002470:	4585                	li	a1,1
    80002472:	8526                	mv	a0,s1
    80002474:	00003097          	auipc	ra,0x3
    80002478:	efe080e7          	jalr	-258(ra) # 80005372 <virtio_disk_rw>
}
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	64a2                	ld	s1,8(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret
    panic("bwrite");
    80002486:	00006517          	auipc	a0,0x6
    8000248a:	02a50513          	addi	a0,a0,42 # 800084b0 <syscalls+0xe8>
    8000248e:	00003097          	auipc	ra,0x3
    80002492:	7e0080e7          	jalr	2016(ra) # 80005c6e <panic>

0000000080002496 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002496:	1101                	addi	sp,sp,-32
    80002498:	ec06                	sd	ra,24(sp)
    8000249a:	e822                	sd	s0,16(sp)
    8000249c:	e426                	sd	s1,8(sp)
    8000249e:	e04a                	sd	s2,0(sp)
    800024a0:	1000                	addi	s0,sp,32
    800024a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024a4:	01050913          	addi	s2,a0,16
    800024a8:	854a                	mv	a0,s2
    800024aa:	00001097          	auipc	ra,0x1
    800024ae:	428080e7          	jalr	1064(ra) # 800038d2 <holdingsleep>
    800024b2:	c92d                	beqz	a0,80002524 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024b4:	854a                	mv	a0,s2
    800024b6:	00001097          	auipc	ra,0x1
    800024ba:	3d8080e7          	jalr	984(ra) # 8000388e <releasesleep>

  acquire(&bcache.lock);
    800024be:	0000d517          	auipc	a0,0xd
    800024c2:	1da50513          	addi	a0,a0,474 # 8000f698 <bcache>
    800024c6:	00004097          	auipc	ra,0x4
    800024ca:	cb6080e7          	jalr	-842(ra) # 8000617c <acquire>
  b->refcnt--;
    800024ce:	40bc                	lw	a5,64(s1)
    800024d0:	37fd                	addiw	a5,a5,-1
    800024d2:	0007871b          	sext.w	a4,a5
    800024d6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024d8:	eb05                	bnez	a4,80002508 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024da:	68bc                	ld	a5,80(s1)
    800024dc:	64b8                	ld	a4,72(s1)
    800024de:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024e0:	64bc                	ld	a5,72(s1)
    800024e2:	68b8                	ld	a4,80(s1)
    800024e4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024e6:	00015797          	auipc	a5,0x15
    800024ea:	1b278793          	addi	a5,a5,434 # 80017698 <bcache+0x8000>
    800024ee:	2b87b703          	ld	a4,696(a5)
    800024f2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024f4:	00015717          	auipc	a4,0x15
    800024f8:	40c70713          	addi	a4,a4,1036 # 80017900 <bcache+0x8268>
    800024fc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024fe:	2b87b703          	ld	a4,696(a5)
    80002502:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002504:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002508:	0000d517          	auipc	a0,0xd
    8000250c:	19050513          	addi	a0,a0,400 # 8000f698 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	d20080e7          	jalr	-736(ra) # 80006230 <release>
}
    80002518:	60e2                	ld	ra,24(sp)
    8000251a:	6442                	ld	s0,16(sp)
    8000251c:	64a2                	ld	s1,8(sp)
    8000251e:	6902                	ld	s2,0(sp)
    80002520:	6105                	addi	sp,sp,32
    80002522:	8082                	ret
    panic("brelse");
    80002524:	00006517          	auipc	a0,0x6
    80002528:	f9450513          	addi	a0,a0,-108 # 800084b8 <syscalls+0xf0>
    8000252c:	00003097          	auipc	ra,0x3
    80002530:	742080e7          	jalr	1858(ra) # 80005c6e <panic>

0000000080002534 <bpin>:

void
bpin(struct buf *b) {
    80002534:	1101                	addi	sp,sp,-32
    80002536:	ec06                	sd	ra,24(sp)
    80002538:	e822                	sd	s0,16(sp)
    8000253a:	e426                	sd	s1,8(sp)
    8000253c:	1000                	addi	s0,sp,32
    8000253e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	15850513          	addi	a0,a0,344 # 8000f698 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	c34080e7          	jalr	-972(ra) # 8000617c <acquire>
  b->refcnt++;
    80002550:	40bc                	lw	a5,64(s1)
    80002552:	2785                	addiw	a5,a5,1
    80002554:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002556:	0000d517          	auipc	a0,0xd
    8000255a:	14250513          	addi	a0,a0,322 # 8000f698 <bcache>
    8000255e:	00004097          	auipc	ra,0x4
    80002562:	cd2080e7          	jalr	-814(ra) # 80006230 <release>
}
    80002566:	60e2                	ld	ra,24(sp)
    80002568:	6442                	ld	s0,16(sp)
    8000256a:	64a2                	ld	s1,8(sp)
    8000256c:	6105                	addi	sp,sp,32
    8000256e:	8082                	ret

0000000080002570 <bunpin>:

void
bunpin(struct buf *b) {
    80002570:	1101                	addi	sp,sp,-32
    80002572:	ec06                	sd	ra,24(sp)
    80002574:	e822                	sd	s0,16(sp)
    80002576:	e426                	sd	s1,8(sp)
    80002578:	1000                	addi	s0,sp,32
    8000257a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	11c50513          	addi	a0,a0,284 # 8000f698 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	bf8080e7          	jalr	-1032(ra) # 8000617c <acquire>
  b->refcnt--;
    8000258c:	40bc                	lw	a5,64(s1)
    8000258e:	37fd                	addiw	a5,a5,-1
    80002590:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002592:	0000d517          	auipc	a0,0xd
    80002596:	10650513          	addi	a0,a0,262 # 8000f698 <bcache>
    8000259a:	00004097          	auipc	ra,0x4
    8000259e:	c96080e7          	jalr	-874(ra) # 80006230 <release>
}
    800025a2:	60e2                	ld	ra,24(sp)
    800025a4:	6442                	ld	s0,16(sp)
    800025a6:	64a2                	ld	s1,8(sp)
    800025a8:	6105                	addi	sp,sp,32
    800025aa:	8082                	ret

00000000800025ac <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	e04a                	sd	s2,0(sp)
    800025b6:	1000                	addi	s0,sp,32
    800025b8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025ba:	00d5d59b          	srliw	a1,a1,0xd
    800025be:	00015797          	auipc	a5,0x15
    800025c2:	7b67a783          	lw	a5,1974(a5) # 80017d74 <sb+0x1c>
    800025c6:	9dbd                	addw	a1,a1,a5
    800025c8:	00000097          	auipc	ra,0x0
    800025cc:	d9e080e7          	jalr	-610(ra) # 80002366 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025d0:	0074f713          	andi	a4,s1,7
    800025d4:	4785                	li	a5,1
    800025d6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025da:	14ce                	slli	s1,s1,0x33
    800025dc:	90d9                	srli	s1,s1,0x36
    800025de:	00950733          	add	a4,a0,s1
    800025e2:	05874703          	lbu	a4,88(a4)
    800025e6:	00e7f6b3          	and	a3,a5,a4
    800025ea:	c69d                	beqz	a3,80002618 <bfree+0x6c>
    800025ec:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025ee:	94aa                	add	s1,s1,a0
    800025f0:	fff7c793          	not	a5,a5
    800025f4:	8f7d                	and	a4,a4,a5
    800025f6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025fa:	00001097          	auipc	ra,0x1
    800025fe:	120080e7          	jalr	288(ra) # 8000371a <log_write>
  brelse(bp);
    80002602:	854a                	mv	a0,s2
    80002604:	00000097          	auipc	ra,0x0
    80002608:	e92080e7          	jalr	-366(ra) # 80002496 <brelse>
}
    8000260c:	60e2                	ld	ra,24(sp)
    8000260e:	6442                	ld	s0,16(sp)
    80002610:	64a2                	ld	s1,8(sp)
    80002612:	6902                	ld	s2,0(sp)
    80002614:	6105                	addi	sp,sp,32
    80002616:	8082                	ret
    panic("freeing free block");
    80002618:	00006517          	auipc	a0,0x6
    8000261c:	ea850513          	addi	a0,a0,-344 # 800084c0 <syscalls+0xf8>
    80002620:	00003097          	auipc	ra,0x3
    80002624:	64e080e7          	jalr	1614(ra) # 80005c6e <panic>

0000000080002628 <balloc>:
{
    80002628:	711d                	addi	sp,sp,-96
    8000262a:	ec86                	sd	ra,88(sp)
    8000262c:	e8a2                	sd	s0,80(sp)
    8000262e:	e4a6                	sd	s1,72(sp)
    80002630:	e0ca                	sd	s2,64(sp)
    80002632:	fc4e                	sd	s3,56(sp)
    80002634:	f852                	sd	s4,48(sp)
    80002636:	f456                	sd	s5,40(sp)
    80002638:	f05a                	sd	s6,32(sp)
    8000263a:	ec5e                	sd	s7,24(sp)
    8000263c:	e862                	sd	s8,16(sp)
    8000263e:	e466                	sd	s9,8(sp)
    80002640:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002642:	00015797          	auipc	a5,0x15
    80002646:	71a7a783          	lw	a5,1818(a5) # 80017d5c <sb+0x4>
    8000264a:	cbc1                	beqz	a5,800026da <balloc+0xb2>
    8000264c:	8baa                	mv	s7,a0
    8000264e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002650:	00015b17          	auipc	s6,0x15
    80002654:	708b0b13          	addi	s6,s6,1800 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002658:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000265a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000265c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000265e:	6c89                	lui	s9,0x2
    80002660:	a831                	j	8000267c <balloc+0x54>
    brelse(bp);
    80002662:	854a                	mv	a0,s2
    80002664:	00000097          	auipc	ra,0x0
    80002668:	e32080e7          	jalr	-462(ra) # 80002496 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000266c:	015c87bb          	addw	a5,s9,s5
    80002670:	00078a9b          	sext.w	s5,a5
    80002674:	004b2703          	lw	a4,4(s6)
    80002678:	06eaf163          	bgeu	s5,a4,800026da <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000267c:	41fad79b          	sraiw	a5,s5,0x1f
    80002680:	0137d79b          	srliw	a5,a5,0x13
    80002684:	015787bb          	addw	a5,a5,s5
    80002688:	40d7d79b          	sraiw	a5,a5,0xd
    8000268c:	01cb2583          	lw	a1,28(s6)
    80002690:	9dbd                	addw	a1,a1,a5
    80002692:	855e                	mv	a0,s7
    80002694:	00000097          	auipc	ra,0x0
    80002698:	cd2080e7          	jalr	-814(ra) # 80002366 <bread>
    8000269c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000269e:	004b2503          	lw	a0,4(s6)
    800026a2:	000a849b          	sext.w	s1,s5
    800026a6:	8762                	mv	a4,s8
    800026a8:	faa4fde3          	bgeu	s1,a0,80002662 <balloc+0x3a>
      m = 1 << (bi % 8);
    800026ac:	00777693          	andi	a3,a4,7
    800026b0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026b4:	41f7579b          	sraiw	a5,a4,0x1f
    800026b8:	01d7d79b          	srliw	a5,a5,0x1d
    800026bc:	9fb9                	addw	a5,a5,a4
    800026be:	4037d79b          	sraiw	a5,a5,0x3
    800026c2:	00f90633          	add	a2,s2,a5
    800026c6:	05864603          	lbu	a2,88(a2)
    800026ca:	00c6f5b3          	and	a1,a3,a2
    800026ce:	cd91                	beqz	a1,800026ea <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d0:	2705                	addiw	a4,a4,1
    800026d2:	2485                	addiw	s1,s1,1
    800026d4:	fd471ae3          	bne	a4,s4,800026a8 <balloc+0x80>
    800026d8:	b769                	j	80002662 <balloc+0x3a>
  panic("balloc: out of blocks");
    800026da:	00006517          	auipc	a0,0x6
    800026de:	dfe50513          	addi	a0,a0,-514 # 800084d8 <syscalls+0x110>
    800026e2:	00003097          	auipc	ra,0x3
    800026e6:	58c080e7          	jalr	1420(ra) # 80005c6e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026ea:	97ca                	add	a5,a5,s2
    800026ec:	8e55                	or	a2,a2,a3
    800026ee:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026f2:	854a                	mv	a0,s2
    800026f4:	00001097          	auipc	ra,0x1
    800026f8:	026080e7          	jalr	38(ra) # 8000371a <log_write>
        brelse(bp);
    800026fc:	854a                	mv	a0,s2
    800026fe:	00000097          	auipc	ra,0x0
    80002702:	d98080e7          	jalr	-616(ra) # 80002496 <brelse>
  bp = bread(dev, bno);
    80002706:	85a6                	mv	a1,s1
    80002708:	855e                	mv	a0,s7
    8000270a:	00000097          	auipc	ra,0x0
    8000270e:	c5c080e7          	jalr	-932(ra) # 80002366 <bread>
    80002712:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002714:	40000613          	li	a2,1024
    80002718:	4581                	li	a1,0
    8000271a:	05850513          	addi	a0,a0,88
    8000271e:	ffffe097          	auipc	ra,0xffffe
    80002722:	a5c080e7          	jalr	-1444(ra) # 8000017a <memset>
  log_write(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00001097          	auipc	ra,0x1
    8000272c:	ff2080e7          	jalr	-14(ra) # 8000371a <log_write>
  brelse(bp);
    80002730:	854a                	mv	a0,s2
    80002732:	00000097          	auipc	ra,0x0
    80002736:	d64080e7          	jalr	-668(ra) # 80002496 <brelse>
}
    8000273a:	8526                	mv	a0,s1
    8000273c:	60e6                	ld	ra,88(sp)
    8000273e:	6446                	ld	s0,80(sp)
    80002740:	64a6                	ld	s1,72(sp)
    80002742:	6906                	ld	s2,64(sp)
    80002744:	79e2                	ld	s3,56(sp)
    80002746:	7a42                	ld	s4,48(sp)
    80002748:	7aa2                	ld	s5,40(sp)
    8000274a:	7b02                	ld	s6,32(sp)
    8000274c:	6be2                	ld	s7,24(sp)
    8000274e:	6c42                	ld	s8,16(sp)
    80002750:	6ca2                	ld	s9,8(sp)
    80002752:	6125                	addi	sp,sp,96
    80002754:	8082                	ret

0000000080002756 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002756:	7179                	addi	sp,sp,-48
    80002758:	f406                	sd	ra,40(sp)
    8000275a:	f022                	sd	s0,32(sp)
    8000275c:	ec26                	sd	s1,24(sp)
    8000275e:	e84a                	sd	s2,16(sp)
    80002760:	e44e                	sd	s3,8(sp)
    80002762:	e052                	sd	s4,0(sp)
    80002764:	1800                	addi	s0,sp,48
    80002766:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002768:	47ad                	li	a5,11
    8000276a:	04b7fe63          	bgeu	a5,a1,800027c6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000276e:	ff45849b          	addiw	s1,a1,-12
    80002772:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002776:	0ff00793          	li	a5,255
    8000277a:	0ae7e463          	bltu	a5,a4,80002822 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000277e:	08052583          	lw	a1,128(a0)
    80002782:	c5b5                	beqz	a1,800027ee <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002784:	00092503          	lw	a0,0(s2)
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	bde080e7          	jalr	-1058(ra) # 80002366 <bread>
    80002790:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002792:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002796:	02049713          	slli	a4,s1,0x20
    8000279a:	01e75593          	srli	a1,a4,0x1e
    8000279e:	00b784b3          	add	s1,a5,a1
    800027a2:	0004a983          	lw	s3,0(s1)
    800027a6:	04098e63          	beqz	s3,80002802 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027aa:	8552                	mv	a0,s4
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	cea080e7          	jalr	-790(ra) # 80002496 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027b4:	854e                	mv	a0,s3
    800027b6:	70a2                	ld	ra,40(sp)
    800027b8:	7402                	ld	s0,32(sp)
    800027ba:	64e2                	ld	s1,24(sp)
    800027bc:	6942                	ld	s2,16(sp)
    800027be:	69a2                	ld	s3,8(sp)
    800027c0:	6a02                	ld	s4,0(sp)
    800027c2:	6145                	addi	sp,sp,48
    800027c4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027c6:	02059793          	slli	a5,a1,0x20
    800027ca:	01e7d593          	srli	a1,a5,0x1e
    800027ce:	00b504b3          	add	s1,a0,a1
    800027d2:	0504a983          	lw	s3,80(s1)
    800027d6:	fc099fe3          	bnez	s3,800027b4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027da:	4108                	lw	a0,0(a0)
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	e4c080e7          	jalr	-436(ra) # 80002628 <balloc>
    800027e4:	0005099b          	sext.w	s3,a0
    800027e8:	0534a823          	sw	s3,80(s1)
    800027ec:	b7e1                	j	800027b4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027ee:	4108                	lw	a0,0(a0)
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	e38080e7          	jalr	-456(ra) # 80002628 <balloc>
    800027f8:	0005059b          	sext.w	a1,a0
    800027fc:	08b92023          	sw	a1,128(s2)
    80002800:	b751                	j	80002784 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002802:	00092503          	lw	a0,0(s2)
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	e22080e7          	jalr	-478(ra) # 80002628 <balloc>
    8000280e:	0005099b          	sext.w	s3,a0
    80002812:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002816:	8552                	mv	a0,s4
    80002818:	00001097          	auipc	ra,0x1
    8000281c:	f02080e7          	jalr	-254(ra) # 8000371a <log_write>
    80002820:	b769                	j	800027aa <bmap+0x54>
  panic("bmap: out of range");
    80002822:	00006517          	auipc	a0,0x6
    80002826:	cce50513          	addi	a0,a0,-818 # 800084f0 <syscalls+0x128>
    8000282a:	00003097          	auipc	ra,0x3
    8000282e:	444080e7          	jalr	1092(ra) # 80005c6e <panic>

0000000080002832 <iget>:
{
    80002832:	7179                	addi	sp,sp,-48
    80002834:	f406                	sd	ra,40(sp)
    80002836:	f022                	sd	s0,32(sp)
    80002838:	ec26                	sd	s1,24(sp)
    8000283a:	e84a                	sd	s2,16(sp)
    8000283c:	e44e                	sd	s3,8(sp)
    8000283e:	e052                	sd	s4,0(sp)
    80002840:	1800                	addi	s0,sp,48
    80002842:	89aa                	mv	s3,a0
    80002844:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002846:	00015517          	auipc	a0,0x15
    8000284a:	53250513          	addi	a0,a0,1330 # 80017d78 <itable>
    8000284e:	00004097          	auipc	ra,0x4
    80002852:	92e080e7          	jalr	-1746(ra) # 8000617c <acquire>
  empty = 0;
    80002856:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002858:	00015497          	auipc	s1,0x15
    8000285c:	53848493          	addi	s1,s1,1336 # 80017d90 <itable+0x18>
    80002860:	00017697          	auipc	a3,0x17
    80002864:	fc068693          	addi	a3,a3,-64 # 80019820 <log>
    80002868:	a039                	j	80002876 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000286a:	02090b63          	beqz	s2,800028a0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000286e:	08848493          	addi	s1,s1,136
    80002872:	02d48a63          	beq	s1,a3,800028a6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002876:	449c                	lw	a5,8(s1)
    80002878:	fef059e3          	blez	a5,8000286a <iget+0x38>
    8000287c:	4098                	lw	a4,0(s1)
    8000287e:	ff3716e3          	bne	a4,s3,8000286a <iget+0x38>
    80002882:	40d8                	lw	a4,4(s1)
    80002884:	ff4713e3          	bne	a4,s4,8000286a <iget+0x38>
      ip->ref++;
    80002888:	2785                	addiw	a5,a5,1
    8000288a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000288c:	00015517          	auipc	a0,0x15
    80002890:	4ec50513          	addi	a0,a0,1260 # 80017d78 <itable>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	99c080e7          	jalr	-1636(ra) # 80006230 <release>
      return ip;
    8000289c:	8926                	mv	s2,s1
    8000289e:	a03d                	j	800028cc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a0:	f7f9                	bnez	a5,8000286e <iget+0x3c>
    800028a2:	8926                	mv	s2,s1
    800028a4:	b7e9                	j	8000286e <iget+0x3c>
  if(empty == 0)
    800028a6:	02090c63          	beqz	s2,800028de <iget+0xac>
  ip->dev = dev;
    800028aa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028ae:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028b2:	4785                	li	a5,1
    800028b4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028b8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028bc:	00015517          	auipc	a0,0x15
    800028c0:	4bc50513          	addi	a0,a0,1212 # 80017d78 <itable>
    800028c4:	00004097          	auipc	ra,0x4
    800028c8:	96c080e7          	jalr	-1684(ra) # 80006230 <release>
}
    800028cc:	854a                	mv	a0,s2
    800028ce:	70a2                	ld	ra,40(sp)
    800028d0:	7402                	ld	s0,32(sp)
    800028d2:	64e2                	ld	s1,24(sp)
    800028d4:	6942                	ld	s2,16(sp)
    800028d6:	69a2                	ld	s3,8(sp)
    800028d8:	6a02                	ld	s4,0(sp)
    800028da:	6145                	addi	sp,sp,48
    800028dc:	8082                	ret
    panic("iget: no inodes");
    800028de:	00006517          	auipc	a0,0x6
    800028e2:	c2a50513          	addi	a0,a0,-982 # 80008508 <syscalls+0x140>
    800028e6:	00003097          	auipc	ra,0x3
    800028ea:	388080e7          	jalr	904(ra) # 80005c6e <panic>

00000000800028ee <fsinit>:
fsinit(int dev) {
    800028ee:	7179                	addi	sp,sp,-48
    800028f0:	f406                	sd	ra,40(sp)
    800028f2:	f022                	sd	s0,32(sp)
    800028f4:	ec26                	sd	s1,24(sp)
    800028f6:	e84a                	sd	s2,16(sp)
    800028f8:	e44e                	sd	s3,8(sp)
    800028fa:	1800                	addi	s0,sp,48
    800028fc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028fe:	4585                	li	a1,1
    80002900:	00000097          	auipc	ra,0x0
    80002904:	a66080e7          	jalr	-1434(ra) # 80002366 <bread>
    80002908:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000290a:	00015997          	auipc	s3,0x15
    8000290e:	44e98993          	addi	s3,s3,1102 # 80017d58 <sb>
    80002912:	02000613          	li	a2,32
    80002916:	05850593          	addi	a1,a0,88
    8000291a:	854e                	mv	a0,s3
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	8ba080e7          	jalr	-1862(ra) # 800001d6 <memmove>
  brelse(bp);
    80002924:	8526                	mv	a0,s1
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	b70080e7          	jalr	-1168(ra) # 80002496 <brelse>
  if(sb.magic != FSMAGIC)
    8000292e:	0009a703          	lw	a4,0(s3)
    80002932:	102037b7          	lui	a5,0x10203
    80002936:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000293a:	02f71263          	bne	a4,a5,8000295e <fsinit+0x70>
  initlog(dev, &sb);
    8000293e:	00015597          	auipc	a1,0x15
    80002942:	41a58593          	addi	a1,a1,1050 # 80017d58 <sb>
    80002946:	854a                	mv	a0,s2
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	b56080e7          	jalr	-1194(ra) # 8000349e <initlog>
}
    80002950:	70a2                	ld	ra,40(sp)
    80002952:	7402                	ld	s0,32(sp)
    80002954:	64e2                	ld	s1,24(sp)
    80002956:	6942                	ld	s2,16(sp)
    80002958:	69a2                	ld	s3,8(sp)
    8000295a:	6145                	addi	sp,sp,48
    8000295c:	8082                	ret
    panic("invalid file system");
    8000295e:	00006517          	auipc	a0,0x6
    80002962:	bba50513          	addi	a0,a0,-1094 # 80008518 <syscalls+0x150>
    80002966:	00003097          	auipc	ra,0x3
    8000296a:	308080e7          	jalr	776(ra) # 80005c6e <panic>

000000008000296e <iinit>:
{
    8000296e:	7179                	addi	sp,sp,-48
    80002970:	f406                	sd	ra,40(sp)
    80002972:	f022                	sd	s0,32(sp)
    80002974:	ec26                	sd	s1,24(sp)
    80002976:	e84a                	sd	s2,16(sp)
    80002978:	e44e                	sd	s3,8(sp)
    8000297a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000297c:	00006597          	auipc	a1,0x6
    80002980:	bb458593          	addi	a1,a1,-1100 # 80008530 <syscalls+0x168>
    80002984:	00015517          	auipc	a0,0x15
    80002988:	3f450513          	addi	a0,a0,1012 # 80017d78 <itable>
    8000298c:	00003097          	auipc	ra,0x3
    80002990:	760080e7          	jalr	1888(ra) # 800060ec <initlock>
  for(i = 0; i < NINODE; i++) {
    80002994:	00015497          	auipc	s1,0x15
    80002998:	40c48493          	addi	s1,s1,1036 # 80017da0 <itable+0x28>
    8000299c:	00017997          	auipc	s3,0x17
    800029a0:	e9498993          	addi	s3,s3,-364 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029a4:	00006917          	auipc	s2,0x6
    800029a8:	b9490913          	addi	s2,s2,-1132 # 80008538 <syscalls+0x170>
    800029ac:	85ca                	mv	a1,s2
    800029ae:	8526                	mv	a0,s1
    800029b0:	00001097          	auipc	ra,0x1
    800029b4:	e4e080e7          	jalr	-434(ra) # 800037fe <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029b8:	08848493          	addi	s1,s1,136
    800029bc:	ff3498e3          	bne	s1,s3,800029ac <iinit+0x3e>
}
    800029c0:	70a2                	ld	ra,40(sp)
    800029c2:	7402                	ld	s0,32(sp)
    800029c4:	64e2                	ld	s1,24(sp)
    800029c6:	6942                	ld	s2,16(sp)
    800029c8:	69a2                	ld	s3,8(sp)
    800029ca:	6145                	addi	sp,sp,48
    800029cc:	8082                	ret

00000000800029ce <ialloc>:
{
    800029ce:	715d                	addi	sp,sp,-80
    800029d0:	e486                	sd	ra,72(sp)
    800029d2:	e0a2                	sd	s0,64(sp)
    800029d4:	fc26                	sd	s1,56(sp)
    800029d6:	f84a                	sd	s2,48(sp)
    800029d8:	f44e                	sd	s3,40(sp)
    800029da:	f052                	sd	s4,32(sp)
    800029dc:	ec56                	sd	s5,24(sp)
    800029de:	e85a                	sd	s6,16(sp)
    800029e0:	e45e                	sd	s7,8(sp)
    800029e2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029e4:	00015717          	auipc	a4,0x15
    800029e8:	38072703          	lw	a4,896(a4) # 80017d64 <sb+0xc>
    800029ec:	4785                	li	a5,1
    800029ee:	04e7fa63          	bgeu	a5,a4,80002a42 <ialloc+0x74>
    800029f2:	8aaa                	mv	s5,a0
    800029f4:	8bae                	mv	s7,a1
    800029f6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029f8:	00015a17          	auipc	s4,0x15
    800029fc:	360a0a13          	addi	s4,s4,864 # 80017d58 <sb>
    80002a00:	00048b1b          	sext.w	s6,s1
    80002a04:	0044d593          	srli	a1,s1,0x4
    80002a08:	018a2783          	lw	a5,24(s4)
    80002a0c:	9dbd                	addw	a1,a1,a5
    80002a0e:	8556                	mv	a0,s5
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	956080e7          	jalr	-1706(ra) # 80002366 <bread>
    80002a18:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a1a:	05850993          	addi	s3,a0,88
    80002a1e:	00f4f793          	andi	a5,s1,15
    80002a22:	079a                	slli	a5,a5,0x6
    80002a24:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a26:	00099783          	lh	a5,0(s3)
    80002a2a:	c785                	beqz	a5,80002a52 <ialloc+0x84>
    brelse(bp);
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	a6a080e7          	jalr	-1430(ra) # 80002496 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a34:	0485                	addi	s1,s1,1
    80002a36:	00ca2703          	lw	a4,12(s4)
    80002a3a:	0004879b          	sext.w	a5,s1
    80002a3e:	fce7e1e3          	bltu	a5,a4,80002a00 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a42:	00006517          	auipc	a0,0x6
    80002a46:	afe50513          	addi	a0,a0,-1282 # 80008540 <syscalls+0x178>
    80002a4a:	00003097          	auipc	ra,0x3
    80002a4e:	224080e7          	jalr	548(ra) # 80005c6e <panic>
      memset(dip, 0, sizeof(*dip));
    80002a52:	04000613          	li	a2,64
    80002a56:	4581                	li	a1,0
    80002a58:	854e                	mv	a0,s3
    80002a5a:	ffffd097          	auipc	ra,0xffffd
    80002a5e:	720080e7          	jalr	1824(ra) # 8000017a <memset>
      dip->type = type;
    80002a62:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a66:	854a                	mv	a0,s2
    80002a68:	00001097          	auipc	ra,0x1
    80002a6c:	cb2080e7          	jalr	-846(ra) # 8000371a <log_write>
      brelse(bp);
    80002a70:	854a                	mv	a0,s2
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	a24080e7          	jalr	-1500(ra) # 80002496 <brelse>
      return iget(dev, inum);
    80002a7a:	85da                	mv	a1,s6
    80002a7c:	8556                	mv	a0,s5
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	db4080e7          	jalr	-588(ra) # 80002832 <iget>
}
    80002a86:	60a6                	ld	ra,72(sp)
    80002a88:	6406                	ld	s0,64(sp)
    80002a8a:	74e2                	ld	s1,56(sp)
    80002a8c:	7942                	ld	s2,48(sp)
    80002a8e:	79a2                	ld	s3,40(sp)
    80002a90:	7a02                	ld	s4,32(sp)
    80002a92:	6ae2                	ld	s5,24(sp)
    80002a94:	6b42                	ld	s6,16(sp)
    80002a96:	6ba2                	ld	s7,8(sp)
    80002a98:	6161                	addi	sp,sp,80
    80002a9a:	8082                	ret

0000000080002a9c <iupdate>:
{
    80002a9c:	1101                	addi	sp,sp,-32
    80002a9e:	ec06                	sd	ra,24(sp)
    80002aa0:	e822                	sd	s0,16(sp)
    80002aa2:	e426                	sd	s1,8(sp)
    80002aa4:	e04a                	sd	s2,0(sp)
    80002aa6:	1000                	addi	s0,sp,32
    80002aa8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aaa:	415c                	lw	a5,4(a0)
    80002aac:	0047d79b          	srliw	a5,a5,0x4
    80002ab0:	00015597          	auipc	a1,0x15
    80002ab4:	2c05a583          	lw	a1,704(a1) # 80017d70 <sb+0x18>
    80002ab8:	9dbd                	addw	a1,a1,a5
    80002aba:	4108                	lw	a0,0(a0)
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	8aa080e7          	jalr	-1878(ra) # 80002366 <bread>
    80002ac4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ac6:	05850793          	addi	a5,a0,88
    80002aca:	40d8                	lw	a4,4(s1)
    80002acc:	8b3d                	andi	a4,a4,15
    80002ace:	071a                	slli	a4,a4,0x6
    80002ad0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ad2:	04449703          	lh	a4,68(s1)
    80002ad6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ada:	04649703          	lh	a4,70(s1)
    80002ade:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ae2:	04849703          	lh	a4,72(s1)
    80002ae6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002aea:	04a49703          	lh	a4,74(s1)
    80002aee:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002af2:	44f8                	lw	a4,76(s1)
    80002af4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002af6:	03400613          	li	a2,52
    80002afa:	05048593          	addi	a1,s1,80
    80002afe:	00c78513          	addi	a0,a5,12
    80002b02:	ffffd097          	auipc	ra,0xffffd
    80002b06:	6d4080e7          	jalr	1748(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b0a:	854a                	mv	a0,s2
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	c0e080e7          	jalr	-1010(ra) # 8000371a <log_write>
  brelse(bp);
    80002b14:	854a                	mv	a0,s2
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	980080e7          	jalr	-1664(ra) # 80002496 <brelse>
}
    80002b1e:	60e2                	ld	ra,24(sp)
    80002b20:	6442                	ld	s0,16(sp)
    80002b22:	64a2                	ld	s1,8(sp)
    80002b24:	6902                	ld	s2,0(sp)
    80002b26:	6105                	addi	sp,sp,32
    80002b28:	8082                	ret

0000000080002b2a <idup>:
{
    80002b2a:	1101                	addi	sp,sp,-32
    80002b2c:	ec06                	sd	ra,24(sp)
    80002b2e:	e822                	sd	s0,16(sp)
    80002b30:	e426                	sd	s1,8(sp)
    80002b32:	1000                	addi	s0,sp,32
    80002b34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b36:	00015517          	auipc	a0,0x15
    80002b3a:	24250513          	addi	a0,a0,578 # 80017d78 <itable>
    80002b3e:	00003097          	auipc	ra,0x3
    80002b42:	63e080e7          	jalr	1598(ra) # 8000617c <acquire>
  ip->ref++;
    80002b46:	449c                	lw	a5,8(s1)
    80002b48:	2785                	addiw	a5,a5,1
    80002b4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b4c:	00015517          	auipc	a0,0x15
    80002b50:	22c50513          	addi	a0,a0,556 # 80017d78 <itable>
    80002b54:	00003097          	auipc	ra,0x3
    80002b58:	6dc080e7          	jalr	1756(ra) # 80006230 <release>
}
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret

0000000080002b68 <ilock>:
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	e426                	sd	s1,8(sp)
    80002b70:	e04a                	sd	s2,0(sp)
    80002b72:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b74:	c115                	beqz	a0,80002b98 <ilock+0x30>
    80002b76:	84aa                	mv	s1,a0
    80002b78:	451c                	lw	a5,8(a0)
    80002b7a:	00f05f63          	blez	a5,80002b98 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b7e:	0541                	addi	a0,a0,16
    80002b80:	00001097          	auipc	ra,0x1
    80002b84:	cb8080e7          	jalr	-840(ra) # 80003838 <acquiresleep>
  if(ip->valid == 0){
    80002b88:	40bc                	lw	a5,64(s1)
    80002b8a:	cf99                	beqz	a5,80002ba8 <ilock+0x40>
}
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	64a2                	ld	s1,8(sp)
    80002b92:	6902                	ld	s2,0(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret
    panic("ilock");
    80002b98:	00006517          	auipc	a0,0x6
    80002b9c:	9c050513          	addi	a0,a0,-1600 # 80008558 <syscalls+0x190>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	0ce080e7          	jalr	206(ra) # 80005c6e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ba8:	40dc                	lw	a5,4(s1)
    80002baa:	0047d79b          	srliw	a5,a5,0x4
    80002bae:	00015597          	auipc	a1,0x15
    80002bb2:	1c25a583          	lw	a1,450(a1) # 80017d70 <sb+0x18>
    80002bb6:	9dbd                	addw	a1,a1,a5
    80002bb8:	4088                	lw	a0,0(s1)
    80002bba:	fffff097          	auipc	ra,0xfffff
    80002bbe:	7ac080e7          	jalr	1964(ra) # 80002366 <bread>
    80002bc2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc4:	05850593          	addi	a1,a0,88
    80002bc8:	40dc                	lw	a5,4(s1)
    80002bca:	8bbd                	andi	a5,a5,15
    80002bcc:	079a                	slli	a5,a5,0x6
    80002bce:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bd0:	00059783          	lh	a5,0(a1)
    80002bd4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bd8:	00259783          	lh	a5,2(a1)
    80002bdc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002be0:	00459783          	lh	a5,4(a1)
    80002be4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002be8:	00659783          	lh	a5,6(a1)
    80002bec:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bf0:	459c                	lw	a5,8(a1)
    80002bf2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bf4:	03400613          	li	a2,52
    80002bf8:	05b1                	addi	a1,a1,12
    80002bfa:	05048513          	addi	a0,s1,80
    80002bfe:	ffffd097          	auipc	ra,0xffffd
    80002c02:	5d8080e7          	jalr	1496(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c06:	854a                	mv	a0,s2
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	88e080e7          	jalr	-1906(ra) # 80002496 <brelse>
    ip->valid = 1;
    80002c10:	4785                	li	a5,1
    80002c12:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c14:	04449783          	lh	a5,68(s1)
    80002c18:	fbb5                	bnez	a5,80002b8c <ilock+0x24>
      panic("ilock: no type");
    80002c1a:	00006517          	auipc	a0,0x6
    80002c1e:	94650513          	addi	a0,a0,-1722 # 80008560 <syscalls+0x198>
    80002c22:	00003097          	auipc	ra,0x3
    80002c26:	04c080e7          	jalr	76(ra) # 80005c6e <panic>

0000000080002c2a <iunlock>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c36:	c905                	beqz	a0,80002c66 <iunlock+0x3c>
    80002c38:	84aa                	mv	s1,a0
    80002c3a:	01050913          	addi	s2,a0,16
    80002c3e:	854a                	mv	a0,s2
    80002c40:	00001097          	auipc	ra,0x1
    80002c44:	c92080e7          	jalr	-878(ra) # 800038d2 <holdingsleep>
    80002c48:	cd19                	beqz	a0,80002c66 <iunlock+0x3c>
    80002c4a:	449c                	lw	a5,8(s1)
    80002c4c:	00f05d63          	blez	a5,80002c66 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c50:	854a                	mv	a0,s2
    80002c52:	00001097          	auipc	ra,0x1
    80002c56:	c3c080e7          	jalr	-964(ra) # 8000388e <releasesleep>
}
    80002c5a:	60e2                	ld	ra,24(sp)
    80002c5c:	6442                	ld	s0,16(sp)
    80002c5e:	64a2                	ld	s1,8(sp)
    80002c60:	6902                	ld	s2,0(sp)
    80002c62:	6105                	addi	sp,sp,32
    80002c64:	8082                	ret
    panic("iunlock");
    80002c66:	00006517          	auipc	a0,0x6
    80002c6a:	90a50513          	addi	a0,a0,-1782 # 80008570 <syscalls+0x1a8>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	000080e7          	jalr	ra # 80005c6e <panic>

0000000080002c76 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c76:	7179                	addi	sp,sp,-48
    80002c78:	f406                	sd	ra,40(sp)
    80002c7a:	f022                	sd	s0,32(sp)
    80002c7c:	ec26                	sd	s1,24(sp)
    80002c7e:	e84a                	sd	s2,16(sp)
    80002c80:	e44e                	sd	s3,8(sp)
    80002c82:	e052                	sd	s4,0(sp)
    80002c84:	1800                	addi	s0,sp,48
    80002c86:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c88:	05050493          	addi	s1,a0,80
    80002c8c:	08050913          	addi	s2,a0,128
    80002c90:	a021                	j	80002c98 <itrunc+0x22>
    80002c92:	0491                	addi	s1,s1,4
    80002c94:	01248d63          	beq	s1,s2,80002cae <itrunc+0x38>
    if(ip->addrs[i]){
    80002c98:	408c                	lw	a1,0(s1)
    80002c9a:	dde5                	beqz	a1,80002c92 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c9c:	0009a503          	lw	a0,0(s3)
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	90c080e7          	jalr	-1780(ra) # 800025ac <bfree>
      ip->addrs[i] = 0;
    80002ca8:	0004a023          	sw	zero,0(s1)
    80002cac:	b7dd                	j	80002c92 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cae:	0809a583          	lw	a1,128(s3)
    80002cb2:	e185                	bnez	a1,80002cd2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cb4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cb8:	854e                	mv	a0,s3
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	de2080e7          	jalr	-542(ra) # 80002a9c <iupdate>
}
    80002cc2:	70a2                	ld	ra,40(sp)
    80002cc4:	7402                	ld	s0,32(sp)
    80002cc6:	64e2                	ld	s1,24(sp)
    80002cc8:	6942                	ld	s2,16(sp)
    80002cca:	69a2                	ld	s3,8(sp)
    80002ccc:	6a02                	ld	s4,0(sp)
    80002cce:	6145                	addi	sp,sp,48
    80002cd0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cd2:	0009a503          	lw	a0,0(s3)
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	690080e7          	jalr	1680(ra) # 80002366 <bread>
    80002cde:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ce0:	05850493          	addi	s1,a0,88
    80002ce4:	45850913          	addi	s2,a0,1112
    80002ce8:	a021                	j	80002cf0 <itrunc+0x7a>
    80002cea:	0491                	addi	s1,s1,4
    80002cec:	01248b63          	beq	s1,s2,80002d02 <itrunc+0x8c>
      if(a[j])
    80002cf0:	408c                	lw	a1,0(s1)
    80002cf2:	dde5                	beqz	a1,80002cea <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cf4:	0009a503          	lw	a0,0(s3)
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	8b4080e7          	jalr	-1868(ra) # 800025ac <bfree>
    80002d00:	b7ed                	j	80002cea <itrunc+0x74>
    brelse(bp);
    80002d02:	8552                	mv	a0,s4
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	792080e7          	jalr	1938(ra) # 80002496 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d0c:	0809a583          	lw	a1,128(s3)
    80002d10:	0009a503          	lw	a0,0(s3)
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	898080e7          	jalr	-1896(ra) # 800025ac <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d1c:	0809a023          	sw	zero,128(s3)
    80002d20:	bf51                	j	80002cb4 <itrunc+0x3e>

0000000080002d22 <iput>:
{
    80002d22:	1101                	addi	sp,sp,-32
    80002d24:	ec06                	sd	ra,24(sp)
    80002d26:	e822                	sd	s0,16(sp)
    80002d28:	e426                	sd	s1,8(sp)
    80002d2a:	e04a                	sd	s2,0(sp)
    80002d2c:	1000                	addi	s0,sp,32
    80002d2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d30:	00015517          	auipc	a0,0x15
    80002d34:	04850513          	addi	a0,a0,72 # 80017d78 <itable>
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	444080e7          	jalr	1092(ra) # 8000617c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d40:	4498                	lw	a4,8(s1)
    80002d42:	4785                	li	a5,1
    80002d44:	02f70363          	beq	a4,a5,80002d6a <iput+0x48>
  ip->ref--;
    80002d48:	449c                	lw	a5,8(s1)
    80002d4a:	37fd                	addiw	a5,a5,-1
    80002d4c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d4e:	00015517          	auipc	a0,0x15
    80002d52:	02a50513          	addi	a0,a0,42 # 80017d78 <itable>
    80002d56:	00003097          	auipc	ra,0x3
    80002d5a:	4da080e7          	jalr	1242(ra) # 80006230 <release>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6902                	ld	s2,0(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d6a:	40bc                	lw	a5,64(s1)
    80002d6c:	dff1                	beqz	a5,80002d48 <iput+0x26>
    80002d6e:	04a49783          	lh	a5,74(s1)
    80002d72:	fbf9                	bnez	a5,80002d48 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d74:	01048913          	addi	s2,s1,16
    80002d78:	854a                	mv	a0,s2
    80002d7a:	00001097          	auipc	ra,0x1
    80002d7e:	abe080e7          	jalr	-1346(ra) # 80003838 <acquiresleep>
    release(&itable.lock);
    80002d82:	00015517          	auipc	a0,0x15
    80002d86:	ff650513          	addi	a0,a0,-10 # 80017d78 <itable>
    80002d8a:	00003097          	auipc	ra,0x3
    80002d8e:	4a6080e7          	jalr	1190(ra) # 80006230 <release>
    itrunc(ip);
    80002d92:	8526                	mv	a0,s1
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	ee2080e7          	jalr	-286(ra) # 80002c76 <itrunc>
    ip->type = 0;
    80002d9c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002da0:	8526                	mv	a0,s1
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	cfa080e7          	jalr	-774(ra) # 80002a9c <iupdate>
    ip->valid = 0;
    80002daa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dae:	854a                	mv	a0,s2
    80002db0:	00001097          	auipc	ra,0x1
    80002db4:	ade080e7          	jalr	-1314(ra) # 8000388e <releasesleep>
    acquire(&itable.lock);
    80002db8:	00015517          	auipc	a0,0x15
    80002dbc:	fc050513          	addi	a0,a0,-64 # 80017d78 <itable>
    80002dc0:	00003097          	auipc	ra,0x3
    80002dc4:	3bc080e7          	jalr	956(ra) # 8000617c <acquire>
    80002dc8:	b741                	j	80002d48 <iput+0x26>

0000000080002dca <iunlockput>:
{
    80002dca:	1101                	addi	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	e426                	sd	s1,8(sp)
    80002dd2:	1000                	addi	s0,sp,32
    80002dd4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	e54080e7          	jalr	-428(ra) # 80002c2a <iunlock>
  iput(ip);
    80002dde:	8526                	mv	a0,s1
    80002de0:	00000097          	auipc	ra,0x0
    80002de4:	f42080e7          	jalr	-190(ra) # 80002d22 <iput>
}
    80002de8:	60e2                	ld	ra,24(sp)
    80002dea:	6442                	ld	s0,16(sp)
    80002dec:	64a2                	ld	s1,8(sp)
    80002dee:	6105                	addi	sp,sp,32
    80002df0:	8082                	ret

0000000080002df2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002df2:	1141                	addi	sp,sp,-16
    80002df4:	e422                	sd	s0,8(sp)
    80002df6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002df8:	411c                	lw	a5,0(a0)
    80002dfa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dfc:	415c                	lw	a5,4(a0)
    80002dfe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e00:	04451783          	lh	a5,68(a0)
    80002e04:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e08:	04a51783          	lh	a5,74(a0)
    80002e0c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e10:	04c56783          	lwu	a5,76(a0)
    80002e14:	e99c                	sd	a5,16(a1)
}
    80002e16:	6422                	ld	s0,8(sp)
    80002e18:	0141                	addi	sp,sp,16
    80002e1a:	8082                	ret

0000000080002e1c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e1c:	457c                	lw	a5,76(a0)
    80002e1e:	0ed7e963          	bltu	a5,a3,80002f10 <readi+0xf4>
{
    80002e22:	7159                	addi	sp,sp,-112
    80002e24:	f486                	sd	ra,104(sp)
    80002e26:	f0a2                	sd	s0,96(sp)
    80002e28:	eca6                	sd	s1,88(sp)
    80002e2a:	e8ca                	sd	s2,80(sp)
    80002e2c:	e4ce                	sd	s3,72(sp)
    80002e2e:	e0d2                	sd	s4,64(sp)
    80002e30:	fc56                	sd	s5,56(sp)
    80002e32:	f85a                	sd	s6,48(sp)
    80002e34:	f45e                	sd	s7,40(sp)
    80002e36:	f062                	sd	s8,32(sp)
    80002e38:	ec66                	sd	s9,24(sp)
    80002e3a:	e86a                	sd	s10,16(sp)
    80002e3c:	e46e                	sd	s11,8(sp)
    80002e3e:	1880                	addi	s0,sp,112
    80002e40:	8baa                	mv	s7,a0
    80002e42:	8c2e                	mv	s8,a1
    80002e44:	8ab2                	mv	s5,a2
    80002e46:	84b6                	mv	s1,a3
    80002e48:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e4a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e4c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e4e:	0ad76063          	bltu	a4,a3,80002eee <readi+0xd2>
  if(off + n > ip->size)
    80002e52:	00e7f463          	bgeu	a5,a4,80002e5a <readi+0x3e>
    n = ip->size - off;
    80002e56:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e5a:	0a0b0963          	beqz	s6,80002f0c <readi+0xf0>
    80002e5e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e60:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e64:	5cfd                	li	s9,-1
    80002e66:	a82d                	j	80002ea0 <readi+0x84>
    80002e68:	020a1d93          	slli	s11,s4,0x20
    80002e6c:	020ddd93          	srli	s11,s11,0x20
    80002e70:	05890613          	addi	a2,s2,88
    80002e74:	86ee                	mv	a3,s11
    80002e76:	963a                	add	a2,a2,a4
    80002e78:	85d6                	mv	a1,s5
    80002e7a:	8562                	mv	a0,s8
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	a40080e7          	jalr	-1472(ra) # 800018bc <either_copyout>
    80002e84:	05950d63          	beq	a0,s9,80002ede <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e88:	854a                	mv	a0,s2
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	60c080e7          	jalr	1548(ra) # 80002496 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e92:	013a09bb          	addw	s3,s4,s3
    80002e96:	009a04bb          	addw	s1,s4,s1
    80002e9a:	9aee                	add	s5,s5,s11
    80002e9c:	0569f763          	bgeu	s3,s6,80002eea <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ea0:	000ba903          	lw	s2,0(s7)
    80002ea4:	00a4d59b          	srliw	a1,s1,0xa
    80002ea8:	855e                	mv	a0,s7
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	8ac080e7          	jalr	-1876(ra) # 80002756 <bmap>
    80002eb2:	0005059b          	sext.w	a1,a0
    80002eb6:	854a                	mv	a0,s2
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	4ae080e7          	jalr	1198(ra) # 80002366 <bread>
    80002ec0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec2:	3ff4f713          	andi	a4,s1,1023
    80002ec6:	40ed07bb          	subw	a5,s10,a4
    80002eca:	413b06bb          	subw	a3,s6,s3
    80002ece:	8a3e                	mv	s4,a5
    80002ed0:	2781                	sext.w	a5,a5
    80002ed2:	0006861b          	sext.w	a2,a3
    80002ed6:	f8f679e3          	bgeu	a2,a5,80002e68 <readi+0x4c>
    80002eda:	8a36                	mv	s4,a3
    80002edc:	b771                	j	80002e68 <readi+0x4c>
      brelse(bp);
    80002ede:	854a                	mv	a0,s2
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	5b6080e7          	jalr	1462(ra) # 80002496 <brelse>
      tot = -1;
    80002ee8:	59fd                	li	s3,-1
  }
  return tot;
    80002eea:	0009851b          	sext.w	a0,s3
}
    80002eee:	70a6                	ld	ra,104(sp)
    80002ef0:	7406                	ld	s0,96(sp)
    80002ef2:	64e6                	ld	s1,88(sp)
    80002ef4:	6946                	ld	s2,80(sp)
    80002ef6:	69a6                	ld	s3,72(sp)
    80002ef8:	6a06                	ld	s4,64(sp)
    80002efa:	7ae2                	ld	s5,56(sp)
    80002efc:	7b42                	ld	s6,48(sp)
    80002efe:	7ba2                	ld	s7,40(sp)
    80002f00:	7c02                	ld	s8,32(sp)
    80002f02:	6ce2                	ld	s9,24(sp)
    80002f04:	6d42                	ld	s10,16(sp)
    80002f06:	6da2                	ld	s11,8(sp)
    80002f08:	6165                	addi	sp,sp,112
    80002f0a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0c:	89da                	mv	s3,s6
    80002f0e:	bff1                	j	80002eea <readi+0xce>
    return 0;
    80002f10:	4501                	li	a0,0
}
    80002f12:	8082                	ret

0000000080002f14 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f14:	457c                	lw	a5,76(a0)
    80002f16:	10d7e863          	bltu	a5,a3,80003026 <writei+0x112>
{
    80002f1a:	7159                	addi	sp,sp,-112
    80002f1c:	f486                	sd	ra,104(sp)
    80002f1e:	f0a2                	sd	s0,96(sp)
    80002f20:	eca6                	sd	s1,88(sp)
    80002f22:	e8ca                	sd	s2,80(sp)
    80002f24:	e4ce                	sd	s3,72(sp)
    80002f26:	e0d2                	sd	s4,64(sp)
    80002f28:	fc56                	sd	s5,56(sp)
    80002f2a:	f85a                	sd	s6,48(sp)
    80002f2c:	f45e                	sd	s7,40(sp)
    80002f2e:	f062                	sd	s8,32(sp)
    80002f30:	ec66                	sd	s9,24(sp)
    80002f32:	e86a                	sd	s10,16(sp)
    80002f34:	e46e                	sd	s11,8(sp)
    80002f36:	1880                	addi	s0,sp,112
    80002f38:	8b2a                	mv	s6,a0
    80002f3a:	8c2e                	mv	s8,a1
    80002f3c:	8ab2                	mv	s5,a2
    80002f3e:	8936                	mv	s2,a3
    80002f40:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f42:	00e687bb          	addw	a5,a3,a4
    80002f46:	0ed7e263          	bltu	a5,a3,8000302a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f4a:	00043737          	lui	a4,0x43
    80002f4e:	0ef76063          	bltu	a4,a5,8000302e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f52:	0c0b8863          	beqz	s7,80003022 <writei+0x10e>
    80002f56:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f58:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f5c:	5cfd                	li	s9,-1
    80002f5e:	a091                	j	80002fa2 <writei+0x8e>
    80002f60:	02099d93          	slli	s11,s3,0x20
    80002f64:	020ddd93          	srli	s11,s11,0x20
    80002f68:	05848513          	addi	a0,s1,88
    80002f6c:	86ee                	mv	a3,s11
    80002f6e:	8656                	mv	a2,s5
    80002f70:	85e2                	mv	a1,s8
    80002f72:	953a                	add	a0,a0,a4
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	99e080e7          	jalr	-1634(ra) # 80001912 <either_copyin>
    80002f7c:	07950263          	beq	a0,s9,80002fe0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f80:	8526                	mv	a0,s1
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	798080e7          	jalr	1944(ra) # 8000371a <log_write>
    brelse(bp);
    80002f8a:	8526                	mv	a0,s1
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	50a080e7          	jalr	1290(ra) # 80002496 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f94:	01498a3b          	addw	s4,s3,s4
    80002f98:	0129893b          	addw	s2,s3,s2
    80002f9c:	9aee                	add	s5,s5,s11
    80002f9e:	057a7663          	bgeu	s4,s7,80002fea <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fa2:	000b2483          	lw	s1,0(s6)
    80002fa6:	00a9559b          	srliw	a1,s2,0xa
    80002faa:	855a                	mv	a0,s6
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	7aa080e7          	jalr	1962(ra) # 80002756 <bmap>
    80002fb4:	0005059b          	sext.w	a1,a0
    80002fb8:	8526                	mv	a0,s1
    80002fba:	fffff097          	auipc	ra,0xfffff
    80002fbe:	3ac080e7          	jalr	940(ra) # 80002366 <bread>
    80002fc2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc4:	3ff97713          	andi	a4,s2,1023
    80002fc8:	40ed07bb          	subw	a5,s10,a4
    80002fcc:	414b86bb          	subw	a3,s7,s4
    80002fd0:	89be                	mv	s3,a5
    80002fd2:	2781                	sext.w	a5,a5
    80002fd4:	0006861b          	sext.w	a2,a3
    80002fd8:	f8f674e3          	bgeu	a2,a5,80002f60 <writei+0x4c>
    80002fdc:	89b6                	mv	s3,a3
    80002fde:	b749                	j	80002f60 <writei+0x4c>
      brelse(bp);
    80002fe0:	8526                	mv	a0,s1
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	4b4080e7          	jalr	1204(ra) # 80002496 <brelse>
  }

  if(off > ip->size)
    80002fea:	04cb2783          	lw	a5,76(s6)
    80002fee:	0127f463          	bgeu	a5,s2,80002ff6 <writei+0xe2>
    ip->size = off;
    80002ff2:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ff6:	855a                	mv	a0,s6
    80002ff8:	00000097          	auipc	ra,0x0
    80002ffc:	aa4080e7          	jalr	-1372(ra) # 80002a9c <iupdate>

  return tot;
    80003000:	000a051b          	sext.w	a0,s4
}
    80003004:	70a6                	ld	ra,104(sp)
    80003006:	7406                	ld	s0,96(sp)
    80003008:	64e6                	ld	s1,88(sp)
    8000300a:	6946                	ld	s2,80(sp)
    8000300c:	69a6                	ld	s3,72(sp)
    8000300e:	6a06                	ld	s4,64(sp)
    80003010:	7ae2                	ld	s5,56(sp)
    80003012:	7b42                	ld	s6,48(sp)
    80003014:	7ba2                	ld	s7,40(sp)
    80003016:	7c02                	ld	s8,32(sp)
    80003018:	6ce2                	ld	s9,24(sp)
    8000301a:	6d42                	ld	s10,16(sp)
    8000301c:	6da2                	ld	s11,8(sp)
    8000301e:	6165                	addi	sp,sp,112
    80003020:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003022:	8a5e                	mv	s4,s7
    80003024:	bfc9                	j	80002ff6 <writei+0xe2>
    return -1;
    80003026:	557d                	li	a0,-1
}
    80003028:	8082                	ret
    return -1;
    8000302a:	557d                	li	a0,-1
    8000302c:	bfe1                	j	80003004 <writei+0xf0>
    return -1;
    8000302e:	557d                	li	a0,-1
    80003030:	bfd1                	j	80003004 <writei+0xf0>

0000000080003032 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003032:	1141                	addi	sp,sp,-16
    80003034:	e406                	sd	ra,8(sp)
    80003036:	e022                	sd	s0,0(sp)
    80003038:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000303a:	4639                	li	a2,14
    8000303c:	ffffd097          	auipc	ra,0xffffd
    80003040:	20e080e7          	jalr	526(ra) # 8000024a <strncmp>
}
    80003044:	60a2                	ld	ra,8(sp)
    80003046:	6402                	ld	s0,0(sp)
    80003048:	0141                	addi	sp,sp,16
    8000304a:	8082                	ret

000000008000304c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000304c:	7139                	addi	sp,sp,-64
    8000304e:	fc06                	sd	ra,56(sp)
    80003050:	f822                	sd	s0,48(sp)
    80003052:	f426                	sd	s1,40(sp)
    80003054:	f04a                	sd	s2,32(sp)
    80003056:	ec4e                	sd	s3,24(sp)
    80003058:	e852                	sd	s4,16(sp)
    8000305a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000305c:	04451703          	lh	a4,68(a0)
    80003060:	4785                	li	a5,1
    80003062:	00f71a63          	bne	a4,a5,80003076 <dirlookup+0x2a>
    80003066:	892a                	mv	s2,a0
    80003068:	89ae                	mv	s3,a1
    8000306a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306c:	457c                	lw	a5,76(a0)
    8000306e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003070:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003072:	e79d                	bnez	a5,800030a0 <dirlookup+0x54>
    80003074:	a8a5                	j	800030ec <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003076:	00005517          	auipc	a0,0x5
    8000307a:	50250513          	addi	a0,a0,1282 # 80008578 <syscalls+0x1b0>
    8000307e:	00003097          	auipc	ra,0x3
    80003082:	bf0080e7          	jalr	-1040(ra) # 80005c6e <panic>
      panic("dirlookup read");
    80003086:	00005517          	auipc	a0,0x5
    8000308a:	50a50513          	addi	a0,a0,1290 # 80008590 <syscalls+0x1c8>
    8000308e:	00003097          	auipc	ra,0x3
    80003092:	be0080e7          	jalr	-1056(ra) # 80005c6e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003096:	24c1                	addiw	s1,s1,16
    80003098:	04c92783          	lw	a5,76(s2)
    8000309c:	04f4f763          	bgeu	s1,a5,800030ea <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030a0:	4741                	li	a4,16
    800030a2:	86a6                	mv	a3,s1
    800030a4:	fc040613          	addi	a2,s0,-64
    800030a8:	4581                	li	a1,0
    800030aa:	854a                	mv	a0,s2
    800030ac:	00000097          	auipc	ra,0x0
    800030b0:	d70080e7          	jalr	-656(ra) # 80002e1c <readi>
    800030b4:	47c1                	li	a5,16
    800030b6:	fcf518e3          	bne	a0,a5,80003086 <dirlookup+0x3a>
    if(de.inum == 0)
    800030ba:	fc045783          	lhu	a5,-64(s0)
    800030be:	dfe1                	beqz	a5,80003096 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030c0:	fc240593          	addi	a1,s0,-62
    800030c4:	854e                	mv	a0,s3
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	f6c080e7          	jalr	-148(ra) # 80003032 <namecmp>
    800030ce:	f561                	bnez	a0,80003096 <dirlookup+0x4a>
      if(poff)
    800030d0:	000a0463          	beqz	s4,800030d8 <dirlookup+0x8c>
        *poff = off;
    800030d4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030d8:	fc045583          	lhu	a1,-64(s0)
    800030dc:	00092503          	lw	a0,0(s2)
    800030e0:	fffff097          	auipc	ra,0xfffff
    800030e4:	752080e7          	jalr	1874(ra) # 80002832 <iget>
    800030e8:	a011                	j	800030ec <dirlookup+0xa0>
  return 0;
    800030ea:	4501                	li	a0,0
}
    800030ec:	70e2                	ld	ra,56(sp)
    800030ee:	7442                	ld	s0,48(sp)
    800030f0:	74a2                	ld	s1,40(sp)
    800030f2:	7902                	ld	s2,32(sp)
    800030f4:	69e2                	ld	s3,24(sp)
    800030f6:	6a42                	ld	s4,16(sp)
    800030f8:	6121                	addi	sp,sp,64
    800030fa:	8082                	ret

00000000800030fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030fc:	711d                	addi	sp,sp,-96
    800030fe:	ec86                	sd	ra,88(sp)
    80003100:	e8a2                	sd	s0,80(sp)
    80003102:	e4a6                	sd	s1,72(sp)
    80003104:	e0ca                	sd	s2,64(sp)
    80003106:	fc4e                	sd	s3,56(sp)
    80003108:	f852                	sd	s4,48(sp)
    8000310a:	f456                	sd	s5,40(sp)
    8000310c:	f05a                	sd	s6,32(sp)
    8000310e:	ec5e                	sd	s7,24(sp)
    80003110:	e862                	sd	s8,16(sp)
    80003112:	e466                	sd	s9,8(sp)
    80003114:	e06a                	sd	s10,0(sp)
    80003116:	1080                	addi	s0,sp,96
    80003118:	84aa                	mv	s1,a0
    8000311a:	8b2e                	mv	s6,a1
    8000311c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000311e:	00054703          	lbu	a4,0(a0)
    80003122:	02f00793          	li	a5,47
    80003126:	02f70363          	beq	a4,a5,8000314c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	d1a080e7          	jalr	-742(ra) # 80000e44 <myproc>
    80003132:	15053503          	ld	a0,336(a0)
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	9f4080e7          	jalr	-1548(ra) # 80002b2a <idup>
    8000313e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003140:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003144:	4cb5                	li	s9,13
  len = path - s;
    80003146:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003148:	4c05                	li	s8,1
    8000314a:	a87d                	j	80003208 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000314c:	4585                	li	a1,1
    8000314e:	4505                	li	a0,1
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	6e2080e7          	jalr	1762(ra) # 80002832 <iget>
    80003158:	8a2a                	mv	s4,a0
    8000315a:	b7dd                	j	80003140 <namex+0x44>
      iunlockput(ip);
    8000315c:	8552                	mv	a0,s4
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	c6c080e7          	jalr	-916(ra) # 80002dca <iunlockput>
      return 0;
    80003166:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003168:	8552                	mv	a0,s4
    8000316a:	60e6                	ld	ra,88(sp)
    8000316c:	6446                	ld	s0,80(sp)
    8000316e:	64a6                	ld	s1,72(sp)
    80003170:	6906                	ld	s2,64(sp)
    80003172:	79e2                	ld	s3,56(sp)
    80003174:	7a42                	ld	s4,48(sp)
    80003176:	7aa2                	ld	s5,40(sp)
    80003178:	7b02                	ld	s6,32(sp)
    8000317a:	6be2                	ld	s7,24(sp)
    8000317c:	6c42                	ld	s8,16(sp)
    8000317e:	6ca2                	ld	s9,8(sp)
    80003180:	6d02                	ld	s10,0(sp)
    80003182:	6125                	addi	sp,sp,96
    80003184:	8082                	ret
      iunlock(ip);
    80003186:	8552                	mv	a0,s4
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	aa2080e7          	jalr	-1374(ra) # 80002c2a <iunlock>
      return ip;
    80003190:	bfe1                	j	80003168 <namex+0x6c>
      iunlockput(ip);
    80003192:	8552                	mv	a0,s4
    80003194:	00000097          	auipc	ra,0x0
    80003198:	c36080e7          	jalr	-970(ra) # 80002dca <iunlockput>
      return 0;
    8000319c:	8a4e                	mv	s4,s3
    8000319e:	b7e9                	j	80003168 <namex+0x6c>
  len = path - s;
    800031a0:	40998633          	sub	a2,s3,s1
    800031a4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800031a8:	09acd863          	bge	s9,s10,80003238 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800031ac:	4639                	li	a2,14
    800031ae:	85a6                	mv	a1,s1
    800031b0:	8556                	mv	a0,s5
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	024080e7          	jalr	36(ra) # 800001d6 <memmove>
    800031ba:	84ce                	mv	s1,s3
  while(*path == '/')
    800031bc:	0004c783          	lbu	a5,0(s1)
    800031c0:	01279763          	bne	a5,s2,800031ce <namex+0xd2>
    path++;
    800031c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031c6:	0004c783          	lbu	a5,0(s1)
    800031ca:	ff278de3          	beq	a5,s2,800031c4 <namex+0xc8>
    ilock(ip);
    800031ce:	8552                	mv	a0,s4
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	998080e7          	jalr	-1640(ra) # 80002b68 <ilock>
    if(ip->type != T_DIR){
    800031d8:	044a1783          	lh	a5,68(s4)
    800031dc:	f98790e3          	bne	a5,s8,8000315c <namex+0x60>
    if(nameiparent && *path == '\0'){
    800031e0:	000b0563          	beqz	s6,800031ea <namex+0xee>
    800031e4:	0004c783          	lbu	a5,0(s1)
    800031e8:	dfd9                	beqz	a5,80003186 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031ea:	865e                	mv	a2,s7
    800031ec:	85d6                	mv	a1,s5
    800031ee:	8552                	mv	a0,s4
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	e5c080e7          	jalr	-420(ra) # 8000304c <dirlookup>
    800031f8:	89aa                	mv	s3,a0
    800031fa:	dd41                	beqz	a0,80003192 <namex+0x96>
    iunlockput(ip);
    800031fc:	8552                	mv	a0,s4
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	bcc080e7          	jalr	-1076(ra) # 80002dca <iunlockput>
    ip = next;
    80003206:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003208:	0004c783          	lbu	a5,0(s1)
    8000320c:	01279763          	bne	a5,s2,8000321a <namex+0x11e>
    path++;
    80003210:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	ff278de3          	beq	a5,s2,80003210 <namex+0x114>
  if(*path == 0)
    8000321a:	cb9d                	beqz	a5,80003250 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	89a6                	mv	s3,s1
  len = path - s;
    80003222:	8d5e                	mv	s10,s7
    80003224:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003226:	01278963          	beq	a5,s2,80003238 <namex+0x13c>
    8000322a:	dbbd                	beqz	a5,800031a0 <namex+0xa4>
    path++;
    8000322c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000322e:	0009c783          	lbu	a5,0(s3)
    80003232:	ff279ce3          	bne	a5,s2,8000322a <namex+0x12e>
    80003236:	b7ad                	j	800031a0 <namex+0xa4>
    memmove(name, s, len);
    80003238:	2601                	sext.w	a2,a2
    8000323a:	85a6                	mv	a1,s1
    8000323c:	8556                	mv	a0,s5
    8000323e:	ffffd097          	auipc	ra,0xffffd
    80003242:	f98080e7          	jalr	-104(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003246:	9d56                	add	s10,s10,s5
    80003248:	000d0023          	sb	zero,0(s10)
    8000324c:	84ce                	mv	s1,s3
    8000324e:	b7bd                	j	800031bc <namex+0xc0>
  if(nameiparent){
    80003250:	f00b0ce3          	beqz	s6,80003168 <namex+0x6c>
    iput(ip);
    80003254:	8552                	mv	a0,s4
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	acc080e7          	jalr	-1332(ra) # 80002d22 <iput>
    return 0;
    8000325e:	4a01                	li	s4,0
    80003260:	b721                	j	80003168 <namex+0x6c>

0000000080003262 <dirlink>:
{
    80003262:	7139                	addi	sp,sp,-64
    80003264:	fc06                	sd	ra,56(sp)
    80003266:	f822                	sd	s0,48(sp)
    80003268:	f426                	sd	s1,40(sp)
    8000326a:	f04a                	sd	s2,32(sp)
    8000326c:	ec4e                	sd	s3,24(sp)
    8000326e:	e852                	sd	s4,16(sp)
    80003270:	0080                	addi	s0,sp,64
    80003272:	892a                	mv	s2,a0
    80003274:	8a2e                	mv	s4,a1
    80003276:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003278:	4601                	li	a2,0
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	dd2080e7          	jalr	-558(ra) # 8000304c <dirlookup>
    80003282:	e93d                	bnez	a0,800032f8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	04c92483          	lw	s1,76(s2)
    80003288:	c49d                	beqz	s1,800032b6 <dirlink+0x54>
    8000328a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328c:	4741                	li	a4,16
    8000328e:	86a6                	mv	a3,s1
    80003290:	fc040613          	addi	a2,s0,-64
    80003294:	4581                	li	a1,0
    80003296:	854a                	mv	a0,s2
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	b84080e7          	jalr	-1148(ra) # 80002e1c <readi>
    800032a0:	47c1                	li	a5,16
    800032a2:	06f51163          	bne	a0,a5,80003304 <dirlink+0xa2>
    if(de.inum == 0)
    800032a6:	fc045783          	lhu	a5,-64(s0)
    800032aa:	c791                	beqz	a5,800032b6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ac:	24c1                	addiw	s1,s1,16
    800032ae:	04c92783          	lw	a5,76(s2)
    800032b2:	fcf4ede3          	bltu	s1,a5,8000328c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032b6:	4639                	li	a2,14
    800032b8:	85d2                	mv	a1,s4
    800032ba:	fc240513          	addi	a0,s0,-62
    800032be:	ffffd097          	auipc	ra,0xffffd
    800032c2:	fc8080e7          	jalr	-56(ra) # 80000286 <strncpy>
  de.inum = inum;
    800032c6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ca:	4741                	li	a4,16
    800032cc:	86a6                	mv	a3,s1
    800032ce:	fc040613          	addi	a2,s0,-64
    800032d2:	4581                	li	a1,0
    800032d4:	854a                	mv	a0,s2
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	c3e080e7          	jalr	-962(ra) # 80002f14 <writei>
    800032de:	872a                	mv	a4,a0
    800032e0:	47c1                	li	a5,16
  return 0;
    800032e2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e4:	02f71863          	bne	a4,a5,80003314 <dirlink+0xb2>
}
    800032e8:	70e2                	ld	ra,56(sp)
    800032ea:	7442                	ld	s0,48(sp)
    800032ec:	74a2                	ld	s1,40(sp)
    800032ee:	7902                	ld	s2,32(sp)
    800032f0:	69e2                	ld	s3,24(sp)
    800032f2:	6a42                	ld	s4,16(sp)
    800032f4:	6121                	addi	sp,sp,64
    800032f6:	8082                	ret
    iput(ip);
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	a2a080e7          	jalr	-1494(ra) # 80002d22 <iput>
    return -1;
    80003300:	557d                	li	a0,-1
    80003302:	b7dd                	j	800032e8 <dirlink+0x86>
      panic("dirlink read");
    80003304:	00005517          	auipc	a0,0x5
    80003308:	29c50513          	addi	a0,a0,668 # 800085a0 <syscalls+0x1d8>
    8000330c:	00003097          	auipc	ra,0x3
    80003310:	962080e7          	jalr	-1694(ra) # 80005c6e <panic>
    panic("dirlink");
    80003314:	00005517          	auipc	a0,0x5
    80003318:	39c50513          	addi	a0,a0,924 # 800086b0 <syscalls+0x2e8>
    8000331c:	00003097          	auipc	ra,0x3
    80003320:	952080e7          	jalr	-1710(ra) # 80005c6e <panic>

0000000080003324 <namei>:

struct inode*
namei(char *path)
{
    80003324:	1101                	addi	sp,sp,-32
    80003326:	ec06                	sd	ra,24(sp)
    80003328:	e822                	sd	s0,16(sp)
    8000332a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000332c:	fe040613          	addi	a2,s0,-32
    80003330:	4581                	li	a1,0
    80003332:	00000097          	auipc	ra,0x0
    80003336:	dca080e7          	jalr	-566(ra) # 800030fc <namex>
}
    8000333a:	60e2                	ld	ra,24(sp)
    8000333c:	6442                	ld	s0,16(sp)
    8000333e:	6105                	addi	sp,sp,32
    80003340:	8082                	ret

0000000080003342 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003342:	1141                	addi	sp,sp,-16
    80003344:	e406                	sd	ra,8(sp)
    80003346:	e022                	sd	s0,0(sp)
    80003348:	0800                	addi	s0,sp,16
    8000334a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000334c:	4585                	li	a1,1
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	dae080e7          	jalr	-594(ra) # 800030fc <namex>
}
    80003356:	60a2                	ld	ra,8(sp)
    80003358:	6402                	ld	s0,0(sp)
    8000335a:	0141                	addi	sp,sp,16
    8000335c:	8082                	ret

000000008000335e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	e426                	sd	s1,8(sp)
    80003366:	e04a                	sd	s2,0(sp)
    80003368:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000336a:	00016917          	auipc	s2,0x16
    8000336e:	4b690913          	addi	s2,s2,1206 # 80019820 <log>
    80003372:	01892583          	lw	a1,24(s2)
    80003376:	02892503          	lw	a0,40(s2)
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	fec080e7          	jalr	-20(ra) # 80002366 <bread>
    80003382:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003384:	02c92683          	lw	a3,44(s2)
    80003388:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000338a:	02d05863          	blez	a3,800033ba <write_head+0x5c>
    8000338e:	00016797          	auipc	a5,0x16
    80003392:	4c278793          	addi	a5,a5,1218 # 80019850 <log+0x30>
    80003396:	05c50713          	addi	a4,a0,92
    8000339a:	36fd                	addiw	a3,a3,-1
    8000339c:	02069613          	slli	a2,a3,0x20
    800033a0:	01e65693          	srli	a3,a2,0x1e
    800033a4:	00016617          	auipc	a2,0x16
    800033a8:	4b060613          	addi	a2,a2,1200 # 80019854 <log+0x34>
    800033ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033ae:	4390                	lw	a2,0(a5)
    800033b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033b2:	0791                	addi	a5,a5,4
    800033b4:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800033b6:	fed79ce3          	bne	a5,a3,800033ae <write_head+0x50>
  }
  bwrite(buf);
    800033ba:	8526                	mv	a0,s1
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	09c080e7          	jalr	156(ra) # 80002458 <bwrite>
  brelse(buf);
    800033c4:	8526                	mv	a0,s1
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	0d0080e7          	jalr	208(ra) # 80002496 <brelse>
}
    800033ce:	60e2                	ld	ra,24(sp)
    800033d0:	6442                	ld	s0,16(sp)
    800033d2:	64a2                	ld	s1,8(sp)
    800033d4:	6902                	ld	s2,0(sp)
    800033d6:	6105                	addi	sp,sp,32
    800033d8:	8082                	ret

00000000800033da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033da:	00016797          	auipc	a5,0x16
    800033de:	4727a783          	lw	a5,1138(a5) # 8001984c <log+0x2c>
    800033e2:	0af05d63          	blez	a5,8000349c <install_trans+0xc2>
{
    800033e6:	7139                	addi	sp,sp,-64
    800033e8:	fc06                	sd	ra,56(sp)
    800033ea:	f822                	sd	s0,48(sp)
    800033ec:	f426                	sd	s1,40(sp)
    800033ee:	f04a                	sd	s2,32(sp)
    800033f0:	ec4e                	sd	s3,24(sp)
    800033f2:	e852                	sd	s4,16(sp)
    800033f4:	e456                	sd	s5,8(sp)
    800033f6:	e05a                	sd	s6,0(sp)
    800033f8:	0080                	addi	s0,sp,64
    800033fa:	8b2a                	mv	s6,a0
    800033fc:	00016a97          	auipc	s5,0x16
    80003400:	454a8a93          	addi	s5,s5,1108 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003404:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003406:	00016997          	auipc	s3,0x16
    8000340a:	41a98993          	addi	s3,s3,1050 # 80019820 <log>
    8000340e:	a00d                	j	80003430 <install_trans+0x56>
    brelse(lbuf);
    80003410:	854a                	mv	a0,s2
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	084080e7          	jalr	132(ra) # 80002496 <brelse>
    brelse(dbuf);
    8000341a:	8526                	mv	a0,s1
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	07a080e7          	jalr	122(ra) # 80002496 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003424:	2a05                	addiw	s4,s4,1
    80003426:	0a91                	addi	s5,s5,4
    80003428:	02c9a783          	lw	a5,44(s3)
    8000342c:	04fa5e63          	bge	s4,a5,80003488 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003430:	0189a583          	lw	a1,24(s3)
    80003434:	014585bb          	addw	a1,a1,s4
    80003438:	2585                	addiw	a1,a1,1
    8000343a:	0289a503          	lw	a0,40(s3)
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	f28080e7          	jalr	-216(ra) # 80002366 <bread>
    80003446:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003448:	000aa583          	lw	a1,0(s5)
    8000344c:	0289a503          	lw	a0,40(s3)
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	f16080e7          	jalr	-234(ra) # 80002366 <bread>
    80003458:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000345a:	40000613          	li	a2,1024
    8000345e:	05890593          	addi	a1,s2,88
    80003462:	05850513          	addi	a0,a0,88
    80003466:	ffffd097          	auipc	ra,0xffffd
    8000346a:	d70080e7          	jalr	-656(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000346e:	8526                	mv	a0,s1
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	fe8080e7          	jalr	-24(ra) # 80002458 <bwrite>
    if(recovering == 0)
    80003478:	f80b1ce3          	bnez	s6,80003410 <install_trans+0x36>
      bunpin(dbuf);
    8000347c:	8526                	mv	a0,s1
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	0f2080e7          	jalr	242(ra) # 80002570 <bunpin>
    80003486:	b769                	j	80003410 <install_trans+0x36>
}
    80003488:	70e2                	ld	ra,56(sp)
    8000348a:	7442                	ld	s0,48(sp)
    8000348c:	74a2                	ld	s1,40(sp)
    8000348e:	7902                	ld	s2,32(sp)
    80003490:	69e2                	ld	s3,24(sp)
    80003492:	6a42                	ld	s4,16(sp)
    80003494:	6aa2                	ld	s5,8(sp)
    80003496:	6b02                	ld	s6,0(sp)
    80003498:	6121                	addi	sp,sp,64
    8000349a:	8082                	ret
    8000349c:	8082                	ret

000000008000349e <initlog>:
{
    8000349e:	7179                	addi	sp,sp,-48
    800034a0:	f406                	sd	ra,40(sp)
    800034a2:	f022                	sd	s0,32(sp)
    800034a4:	ec26                	sd	s1,24(sp)
    800034a6:	e84a                	sd	s2,16(sp)
    800034a8:	e44e                	sd	s3,8(sp)
    800034aa:	1800                	addi	s0,sp,48
    800034ac:	892a                	mv	s2,a0
    800034ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034b0:	00016497          	auipc	s1,0x16
    800034b4:	37048493          	addi	s1,s1,880 # 80019820 <log>
    800034b8:	00005597          	auipc	a1,0x5
    800034bc:	0f858593          	addi	a1,a1,248 # 800085b0 <syscalls+0x1e8>
    800034c0:	8526                	mv	a0,s1
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	c2a080e7          	jalr	-982(ra) # 800060ec <initlock>
  log.start = sb->logstart;
    800034ca:	0149a583          	lw	a1,20(s3)
    800034ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034d0:	0109a783          	lw	a5,16(s3)
    800034d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034da:	854a                	mv	a0,s2
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	e8a080e7          	jalr	-374(ra) # 80002366 <bread>
  log.lh.n = lh->n;
    800034e4:	4d34                	lw	a3,88(a0)
    800034e6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034e8:	02d05663          	blez	a3,80003514 <initlog+0x76>
    800034ec:	05c50793          	addi	a5,a0,92
    800034f0:	00016717          	auipc	a4,0x16
    800034f4:	36070713          	addi	a4,a4,864 # 80019850 <log+0x30>
    800034f8:	36fd                	addiw	a3,a3,-1
    800034fa:	02069613          	slli	a2,a3,0x20
    800034fe:	01e65693          	srli	a3,a2,0x1e
    80003502:	06050613          	addi	a2,a0,96
    80003506:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003508:	4390                	lw	a2,0(a5)
    8000350a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000350c:	0791                	addi	a5,a5,4
    8000350e:	0711                	addi	a4,a4,4
    80003510:	fed79ce3          	bne	a5,a3,80003508 <initlog+0x6a>
  brelse(buf);
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	f82080e7          	jalr	-126(ra) # 80002496 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000351c:	4505                	li	a0,1
    8000351e:	00000097          	auipc	ra,0x0
    80003522:	ebc080e7          	jalr	-324(ra) # 800033da <install_trans>
  log.lh.n = 0;
    80003526:	00016797          	auipc	a5,0x16
    8000352a:	3207a323          	sw	zero,806(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	e30080e7          	jalr	-464(ra) # 8000335e <write_head>
}
    80003536:	70a2                	ld	ra,40(sp)
    80003538:	7402                	ld	s0,32(sp)
    8000353a:	64e2                	ld	s1,24(sp)
    8000353c:	6942                	ld	s2,16(sp)
    8000353e:	69a2                	ld	s3,8(sp)
    80003540:	6145                	addi	sp,sp,48
    80003542:	8082                	ret

0000000080003544 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003544:	1101                	addi	sp,sp,-32
    80003546:	ec06                	sd	ra,24(sp)
    80003548:	e822                	sd	s0,16(sp)
    8000354a:	e426                	sd	s1,8(sp)
    8000354c:	e04a                	sd	s2,0(sp)
    8000354e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003550:	00016517          	auipc	a0,0x16
    80003554:	2d050513          	addi	a0,a0,720 # 80019820 <log>
    80003558:	00003097          	auipc	ra,0x3
    8000355c:	c24080e7          	jalr	-988(ra) # 8000617c <acquire>
  while(1){
    if(log.committing){
    80003560:	00016497          	auipc	s1,0x16
    80003564:	2c048493          	addi	s1,s1,704 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003568:	4979                	li	s2,30
    8000356a:	a039                	j	80003578 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000356c:	85a6                	mv	a1,s1
    8000356e:	8526                	mv	a0,s1
    80003570:	ffffe097          	auipc	ra,0xffffe
    80003574:	fa8080e7          	jalr	-88(ra) # 80001518 <sleep>
    if(log.committing){
    80003578:	50dc                	lw	a5,36(s1)
    8000357a:	fbed                	bnez	a5,8000356c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000357c:	5098                	lw	a4,32(s1)
    8000357e:	2705                	addiw	a4,a4,1
    80003580:	0007069b          	sext.w	a3,a4
    80003584:	0027179b          	slliw	a5,a4,0x2
    80003588:	9fb9                	addw	a5,a5,a4
    8000358a:	0017979b          	slliw	a5,a5,0x1
    8000358e:	54d8                	lw	a4,44(s1)
    80003590:	9fb9                	addw	a5,a5,a4
    80003592:	00f95963          	bge	s2,a5,800035a4 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003596:	85a6                	mv	a1,s1
    80003598:	8526                	mv	a0,s1
    8000359a:	ffffe097          	auipc	ra,0xffffe
    8000359e:	f7e080e7          	jalr	-130(ra) # 80001518 <sleep>
    800035a2:	bfd9                	j	80003578 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035a4:	00016517          	auipc	a0,0x16
    800035a8:	27c50513          	addi	a0,a0,636 # 80019820 <log>
    800035ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035ae:	00003097          	auipc	ra,0x3
    800035b2:	c82080e7          	jalr	-894(ra) # 80006230 <release>
      break;
    }
  }
}
    800035b6:	60e2                	ld	ra,24(sp)
    800035b8:	6442                	ld	s0,16(sp)
    800035ba:	64a2                	ld	s1,8(sp)
    800035bc:	6902                	ld	s2,0(sp)
    800035be:	6105                	addi	sp,sp,32
    800035c0:	8082                	ret

00000000800035c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035c2:	7139                	addi	sp,sp,-64
    800035c4:	fc06                	sd	ra,56(sp)
    800035c6:	f822                	sd	s0,48(sp)
    800035c8:	f426                	sd	s1,40(sp)
    800035ca:	f04a                	sd	s2,32(sp)
    800035cc:	ec4e                	sd	s3,24(sp)
    800035ce:	e852                	sd	s4,16(sp)
    800035d0:	e456                	sd	s5,8(sp)
    800035d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035d4:	00016497          	auipc	s1,0x16
    800035d8:	24c48493          	addi	s1,s1,588 # 80019820 <log>
    800035dc:	8526                	mv	a0,s1
    800035de:	00003097          	auipc	ra,0x3
    800035e2:	b9e080e7          	jalr	-1122(ra) # 8000617c <acquire>
  log.outstanding -= 1;
    800035e6:	509c                	lw	a5,32(s1)
    800035e8:	37fd                	addiw	a5,a5,-1
    800035ea:	0007891b          	sext.w	s2,a5
    800035ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035f0:	50dc                	lw	a5,36(s1)
    800035f2:	e7b9                	bnez	a5,80003640 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035f4:	04091e63          	bnez	s2,80003650 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035f8:	00016497          	auipc	s1,0x16
    800035fc:	22848493          	addi	s1,s1,552 # 80019820 <log>
    80003600:	4785                	li	a5,1
    80003602:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003604:	8526                	mv	a0,s1
    80003606:	00003097          	auipc	ra,0x3
    8000360a:	c2a080e7          	jalr	-982(ra) # 80006230 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000360e:	54dc                	lw	a5,44(s1)
    80003610:	06f04763          	bgtz	a5,8000367e <end_op+0xbc>
    acquire(&log.lock);
    80003614:	00016497          	auipc	s1,0x16
    80003618:	20c48493          	addi	s1,s1,524 # 80019820 <log>
    8000361c:	8526                	mv	a0,s1
    8000361e:	00003097          	auipc	ra,0x3
    80003622:	b5e080e7          	jalr	-1186(ra) # 8000617c <acquire>
    log.committing = 0;
    80003626:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000362a:	8526                	mv	a0,s1
    8000362c:	ffffe097          	auipc	ra,0xffffe
    80003630:	078080e7          	jalr	120(ra) # 800016a4 <wakeup>
    release(&log.lock);
    80003634:	8526                	mv	a0,s1
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	bfa080e7          	jalr	-1030(ra) # 80006230 <release>
}
    8000363e:	a03d                	j	8000366c <end_op+0xaa>
    panic("log.committing");
    80003640:	00005517          	auipc	a0,0x5
    80003644:	f7850513          	addi	a0,a0,-136 # 800085b8 <syscalls+0x1f0>
    80003648:	00002097          	auipc	ra,0x2
    8000364c:	626080e7          	jalr	1574(ra) # 80005c6e <panic>
    wakeup(&log);
    80003650:	00016497          	auipc	s1,0x16
    80003654:	1d048493          	addi	s1,s1,464 # 80019820 <log>
    80003658:	8526                	mv	a0,s1
    8000365a:	ffffe097          	auipc	ra,0xffffe
    8000365e:	04a080e7          	jalr	74(ra) # 800016a4 <wakeup>
  release(&log.lock);
    80003662:	8526                	mv	a0,s1
    80003664:	00003097          	auipc	ra,0x3
    80003668:	bcc080e7          	jalr	-1076(ra) # 80006230 <release>
}
    8000366c:	70e2                	ld	ra,56(sp)
    8000366e:	7442                	ld	s0,48(sp)
    80003670:	74a2                	ld	s1,40(sp)
    80003672:	7902                	ld	s2,32(sp)
    80003674:	69e2                	ld	s3,24(sp)
    80003676:	6a42                	ld	s4,16(sp)
    80003678:	6aa2                	ld	s5,8(sp)
    8000367a:	6121                	addi	sp,sp,64
    8000367c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000367e:	00016a97          	auipc	s5,0x16
    80003682:	1d2a8a93          	addi	s5,s5,466 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003686:	00016a17          	auipc	s4,0x16
    8000368a:	19aa0a13          	addi	s4,s4,410 # 80019820 <log>
    8000368e:	018a2583          	lw	a1,24(s4)
    80003692:	012585bb          	addw	a1,a1,s2
    80003696:	2585                	addiw	a1,a1,1
    80003698:	028a2503          	lw	a0,40(s4)
    8000369c:	fffff097          	auipc	ra,0xfffff
    800036a0:	cca080e7          	jalr	-822(ra) # 80002366 <bread>
    800036a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036a6:	000aa583          	lw	a1,0(s5)
    800036aa:	028a2503          	lw	a0,40(s4)
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	cb8080e7          	jalr	-840(ra) # 80002366 <bread>
    800036b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036b8:	40000613          	li	a2,1024
    800036bc:	05850593          	addi	a1,a0,88
    800036c0:	05848513          	addi	a0,s1,88
    800036c4:	ffffd097          	auipc	ra,0xffffd
    800036c8:	b12080e7          	jalr	-1262(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036cc:	8526                	mv	a0,s1
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	d8a080e7          	jalr	-630(ra) # 80002458 <bwrite>
    brelse(from);
    800036d6:	854e                	mv	a0,s3
    800036d8:	fffff097          	auipc	ra,0xfffff
    800036dc:	dbe080e7          	jalr	-578(ra) # 80002496 <brelse>
    brelse(to);
    800036e0:	8526                	mv	a0,s1
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	db4080e7          	jalr	-588(ra) # 80002496 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ea:	2905                	addiw	s2,s2,1
    800036ec:	0a91                	addi	s5,s5,4
    800036ee:	02ca2783          	lw	a5,44(s4)
    800036f2:	f8f94ee3          	blt	s2,a5,8000368e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036f6:	00000097          	auipc	ra,0x0
    800036fa:	c68080e7          	jalr	-920(ra) # 8000335e <write_head>
    install_trans(0); // Now install writes to home locations
    800036fe:	4501                	li	a0,0
    80003700:	00000097          	auipc	ra,0x0
    80003704:	cda080e7          	jalr	-806(ra) # 800033da <install_trans>
    log.lh.n = 0;
    80003708:	00016797          	auipc	a5,0x16
    8000370c:	1407a223          	sw	zero,324(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003710:	00000097          	auipc	ra,0x0
    80003714:	c4e080e7          	jalr	-946(ra) # 8000335e <write_head>
    80003718:	bdf5                	j	80003614 <end_op+0x52>

000000008000371a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	e426                	sd	s1,8(sp)
    80003722:	e04a                	sd	s2,0(sp)
    80003724:	1000                	addi	s0,sp,32
    80003726:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003728:	00016917          	auipc	s2,0x16
    8000372c:	0f890913          	addi	s2,s2,248 # 80019820 <log>
    80003730:	854a                	mv	a0,s2
    80003732:	00003097          	auipc	ra,0x3
    80003736:	a4a080e7          	jalr	-1462(ra) # 8000617c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000373a:	02c92603          	lw	a2,44(s2)
    8000373e:	47f5                	li	a5,29
    80003740:	06c7c563          	blt	a5,a2,800037aa <log_write+0x90>
    80003744:	00016797          	auipc	a5,0x16
    80003748:	0f87a783          	lw	a5,248(a5) # 8001983c <log+0x1c>
    8000374c:	37fd                	addiw	a5,a5,-1
    8000374e:	04f65e63          	bge	a2,a5,800037aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003752:	00016797          	auipc	a5,0x16
    80003756:	0ee7a783          	lw	a5,238(a5) # 80019840 <log+0x20>
    8000375a:	06f05063          	blez	a5,800037ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000375e:	4781                	li	a5,0
    80003760:	06c05563          	blez	a2,800037ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003764:	44cc                	lw	a1,12(s1)
    80003766:	00016717          	auipc	a4,0x16
    8000376a:	0ea70713          	addi	a4,a4,234 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000376e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003770:	4314                	lw	a3,0(a4)
    80003772:	04b68c63          	beq	a3,a1,800037ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003776:	2785                	addiw	a5,a5,1
    80003778:	0711                	addi	a4,a4,4
    8000377a:	fef61be3          	bne	a2,a5,80003770 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000377e:	0621                	addi	a2,a2,8
    80003780:	060a                	slli	a2,a2,0x2
    80003782:	00016797          	auipc	a5,0x16
    80003786:	09e78793          	addi	a5,a5,158 # 80019820 <log>
    8000378a:	97b2                	add	a5,a5,a2
    8000378c:	44d8                	lw	a4,12(s1)
    8000378e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003790:	8526                	mv	a0,s1
    80003792:	fffff097          	auipc	ra,0xfffff
    80003796:	da2080e7          	jalr	-606(ra) # 80002534 <bpin>
    log.lh.n++;
    8000379a:	00016717          	auipc	a4,0x16
    8000379e:	08670713          	addi	a4,a4,134 # 80019820 <log>
    800037a2:	575c                	lw	a5,44(a4)
    800037a4:	2785                	addiw	a5,a5,1
    800037a6:	d75c                	sw	a5,44(a4)
    800037a8:	a82d                	j	800037e2 <log_write+0xc8>
    panic("too big a transaction");
    800037aa:	00005517          	auipc	a0,0x5
    800037ae:	e1e50513          	addi	a0,a0,-482 # 800085c8 <syscalls+0x200>
    800037b2:	00002097          	auipc	ra,0x2
    800037b6:	4bc080e7          	jalr	1212(ra) # 80005c6e <panic>
    panic("log_write outside of trans");
    800037ba:	00005517          	auipc	a0,0x5
    800037be:	e2650513          	addi	a0,a0,-474 # 800085e0 <syscalls+0x218>
    800037c2:	00002097          	auipc	ra,0x2
    800037c6:	4ac080e7          	jalr	1196(ra) # 80005c6e <panic>
  log.lh.block[i] = b->blockno;
    800037ca:	00878693          	addi	a3,a5,8
    800037ce:	068a                	slli	a3,a3,0x2
    800037d0:	00016717          	auipc	a4,0x16
    800037d4:	05070713          	addi	a4,a4,80 # 80019820 <log>
    800037d8:	9736                	add	a4,a4,a3
    800037da:	44d4                	lw	a3,12(s1)
    800037dc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037de:	faf609e3          	beq	a2,a5,80003790 <log_write+0x76>
  }
  release(&log.lock);
    800037e2:	00016517          	auipc	a0,0x16
    800037e6:	03e50513          	addi	a0,a0,62 # 80019820 <log>
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	a46080e7          	jalr	-1466(ra) # 80006230 <release>
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6902                	ld	s2,0(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	e426                	sd	s1,8(sp)
    80003806:	e04a                	sd	s2,0(sp)
    80003808:	1000                	addi	s0,sp,32
    8000380a:	84aa                	mv	s1,a0
    8000380c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000380e:	00005597          	auipc	a1,0x5
    80003812:	df258593          	addi	a1,a1,-526 # 80008600 <syscalls+0x238>
    80003816:	0521                	addi	a0,a0,8
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	8d4080e7          	jalr	-1836(ra) # 800060ec <initlock>
  lk->name = name;
    80003820:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003824:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003828:	0204a423          	sw	zero,40(s1)
}
    8000382c:	60e2                	ld	ra,24(sp)
    8000382e:	6442                	ld	s0,16(sp)
    80003830:	64a2                	ld	s1,8(sp)
    80003832:	6902                	ld	s2,0(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003838:	1101                	addi	sp,sp,-32
    8000383a:	ec06                	sd	ra,24(sp)
    8000383c:	e822                	sd	s0,16(sp)
    8000383e:	e426                	sd	s1,8(sp)
    80003840:	e04a                	sd	s2,0(sp)
    80003842:	1000                	addi	s0,sp,32
    80003844:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003846:	00850913          	addi	s2,a0,8
    8000384a:	854a                	mv	a0,s2
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	930080e7          	jalr	-1744(ra) # 8000617c <acquire>
  while (lk->locked) {
    80003854:	409c                	lw	a5,0(s1)
    80003856:	cb89                	beqz	a5,80003868 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003858:	85ca                	mv	a1,s2
    8000385a:	8526                	mv	a0,s1
    8000385c:	ffffe097          	auipc	ra,0xffffe
    80003860:	cbc080e7          	jalr	-836(ra) # 80001518 <sleep>
  while (lk->locked) {
    80003864:	409c                	lw	a5,0(s1)
    80003866:	fbed                	bnez	a5,80003858 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003868:	4785                	li	a5,1
    8000386a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000386c:	ffffd097          	auipc	ra,0xffffd
    80003870:	5d8080e7          	jalr	1496(ra) # 80000e44 <myproc>
    80003874:	591c                	lw	a5,48(a0)
    80003876:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003878:	854a                	mv	a0,s2
    8000387a:	00003097          	auipc	ra,0x3
    8000387e:	9b6080e7          	jalr	-1610(ra) # 80006230 <release>
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389c:	00850913          	addi	s2,a0,8
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	8da080e7          	jalr	-1830(ra) # 8000617c <acquire>
  lk->locked = 0;
    800038aa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038b2:	8526                	mv	a0,s1
    800038b4:	ffffe097          	auipc	ra,0xffffe
    800038b8:	df0080e7          	jalr	-528(ra) # 800016a4 <wakeup>
  release(&lk->lk);
    800038bc:	854a                	mv	a0,s2
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	972080e7          	jalr	-1678(ra) # 80006230 <release>
}
    800038c6:	60e2                	ld	ra,24(sp)
    800038c8:	6442                	ld	s0,16(sp)
    800038ca:	64a2                	ld	s1,8(sp)
    800038cc:	6902                	ld	s2,0(sp)
    800038ce:	6105                	addi	sp,sp,32
    800038d0:	8082                	ret

00000000800038d2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038d2:	7179                	addi	sp,sp,-48
    800038d4:	f406                	sd	ra,40(sp)
    800038d6:	f022                	sd	s0,32(sp)
    800038d8:	ec26                	sd	s1,24(sp)
    800038da:	e84a                	sd	s2,16(sp)
    800038dc:	e44e                	sd	s3,8(sp)
    800038de:	1800                	addi	s0,sp,48
    800038e0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038e2:	00850913          	addi	s2,a0,8
    800038e6:	854a                	mv	a0,s2
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	894080e7          	jalr	-1900(ra) # 8000617c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038f0:	409c                	lw	a5,0(s1)
    800038f2:	ef99                	bnez	a5,80003910 <holdingsleep+0x3e>
    800038f4:	4481                	li	s1,0
  release(&lk->lk);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	938080e7          	jalr	-1736(ra) # 80006230 <release>
  return r;
}
    80003900:	8526                	mv	a0,s1
    80003902:	70a2                	ld	ra,40(sp)
    80003904:	7402                	ld	s0,32(sp)
    80003906:	64e2                	ld	s1,24(sp)
    80003908:	6942                	ld	s2,16(sp)
    8000390a:	69a2                	ld	s3,8(sp)
    8000390c:	6145                	addi	sp,sp,48
    8000390e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003910:	0284a983          	lw	s3,40(s1)
    80003914:	ffffd097          	auipc	ra,0xffffd
    80003918:	530080e7          	jalr	1328(ra) # 80000e44 <myproc>
    8000391c:	5904                	lw	s1,48(a0)
    8000391e:	413484b3          	sub	s1,s1,s3
    80003922:	0014b493          	seqz	s1,s1
    80003926:	bfc1                	j	800038f6 <holdingsleep+0x24>

0000000080003928 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003928:	1141                	addi	sp,sp,-16
    8000392a:	e406                	sd	ra,8(sp)
    8000392c:	e022                	sd	s0,0(sp)
    8000392e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003930:	00005597          	auipc	a1,0x5
    80003934:	ce058593          	addi	a1,a1,-800 # 80008610 <syscalls+0x248>
    80003938:	00016517          	auipc	a0,0x16
    8000393c:	03050513          	addi	a0,a0,48 # 80019968 <ftable>
    80003940:	00002097          	auipc	ra,0x2
    80003944:	7ac080e7          	jalr	1964(ra) # 800060ec <initlock>
}
    80003948:	60a2                	ld	ra,8(sp)
    8000394a:	6402                	ld	s0,0(sp)
    8000394c:	0141                	addi	sp,sp,16
    8000394e:	8082                	ret

0000000080003950 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000395a:	00016517          	auipc	a0,0x16
    8000395e:	00e50513          	addi	a0,a0,14 # 80019968 <ftable>
    80003962:	00003097          	auipc	ra,0x3
    80003966:	81a080e7          	jalr	-2022(ra) # 8000617c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000396a:	00016497          	auipc	s1,0x16
    8000396e:	01648493          	addi	s1,s1,22 # 80019980 <ftable+0x18>
    80003972:	00017717          	auipc	a4,0x17
    80003976:	fae70713          	addi	a4,a4,-82 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    8000397a:	40dc                	lw	a5,4(s1)
    8000397c:	cf99                	beqz	a5,8000399a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000397e:	02848493          	addi	s1,s1,40
    80003982:	fee49ce3          	bne	s1,a4,8000397a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003986:	00016517          	auipc	a0,0x16
    8000398a:	fe250513          	addi	a0,a0,-30 # 80019968 <ftable>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	8a2080e7          	jalr	-1886(ra) # 80006230 <release>
  return 0;
    80003996:	4481                	li	s1,0
    80003998:	a819                	j	800039ae <filealloc+0x5e>
      f->ref = 1;
    8000399a:	4785                	li	a5,1
    8000399c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000399e:	00016517          	auipc	a0,0x16
    800039a2:	fca50513          	addi	a0,a0,-54 # 80019968 <ftable>
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	88a080e7          	jalr	-1910(ra) # 80006230 <release>
}
    800039ae:	8526                	mv	a0,s1
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	64a2                	ld	s1,8(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret

00000000800039ba <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039ba:	1101                	addi	sp,sp,-32
    800039bc:	ec06                	sd	ra,24(sp)
    800039be:	e822                	sd	s0,16(sp)
    800039c0:	e426                	sd	s1,8(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039c6:	00016517          	auipc	a0,0x16
    800039ca:	fa250513          	addi	a0,a0,-94 # 80019968 <ftable>
    800039ce:	00002097          	auipc	ra,0x2
    800039d2:	7ae080e7          	jalr	1966(ra) # 8000617c <acquire>
  if(f->ref < 1)
    800039d6:	40dc                	lw	a5,4(s1)
    800039d8:	02f05263          	blez	a5,800039fc <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039dc:	2785                	addiw	a5,a5,1
    800039de:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039e0:	00016517          	auipc	a0,0x16
    800039e4:	f8850513          	addi	a0,a0,-120 # 80019968 <ftable>
    800039e8:	00003097          	auipc	ra,0x3
    800039ec:	848080e7          	jalr	-1976(ra) # 80006230 <release>
  return f;
}
    800039f0:	8526                	mv	a0,s1
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	64a2                	ld	s1,8(sp)
    800039f8:	6105                	addi	sp,sp,32
    800039fa:	8082                	ret
    panic("filedup");
    800039fc:	00005517          	auipc	a0,0x5
    80003a00:	c1c50513          	addi	a0,a0,-996 # 80008618 <syscalls+0x250>
    80003a04:	00002097          	auipc	ra,0x2
    80003a08:	26a080e7          	jalr	618(ra) # 80005c6e <panic>

0000000080003a0c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a0c:	7139                	addi	sp,sp,-64
    80003a0e:	fc06                	sd	ra,56(sp)
    80003a10:	f822                	sd	s0,48(sp)
    80003a12:	f426                	sd	s1,40(sp)
    80003a14:	f04a                	sd	s2,32(sp)
    80003a16:	ec4e                	sd	s3,24(sp)
    80003a18:	e852                	sd	s4,16(sp)
    80003a1a:	e456                	sd	s5,8(sp)
    80003a1c:	0080                	addi	s0,sp,64
    80003a1e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a20:	00016517          	auipc	a0,0x16
    80003a24:	f4850513          	addi	a0,a0,-184 # 80019968 <ftable>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	754080e7          	jalr	1876(ra) # 8000617c <acquire>
  if(f->ref < 1)
    80003a30:	40dc                	lw	a5,4(s1)
    80003a32:	06f05163          	blez	a5,80003a94 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a36:	37fd                	addiw	a5,a5,-1
    80003a38:	0007871b          	sext.w	a4,a5
    80003a3c:	c0dc                	sw	a5,4(s1)
    80003a3e:	06e04363          	bgtz	a4,80003aa4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a42:	0004a903          	lw	s2,0(s1)
    80003a46:	0094ca83          	lbu	s5,9(s1)
    80003a4a:	0104ba03          	ld	s4,16(s1)
    80003a4e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a52:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a56:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a5a:	00016517          	auipc	a0,0x16
    80003a5e:	f0e50513          	addi	a0,a0,-242 # 80019968 <ftable>
    80003a62:	00002097          	auipc	ra,0x2
    80003a66:	7ce080e7          	jalr	1998(ra) # 80006230 <release>

  if(ff.type == FD_PIPE){
    80003a6a:	4785                	li	a5,1
    80003a6c:	04f90d63          	beq	s2,a5,80003ac6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a70:	3979                	addiw	s2,s2,-2
    80003a72:	4785                	li	a5,1
    80003a74:	0527e063          	bltu	a5,s2,80003ab4 <fileclose+0xa8>
    begin_op();
    80003a78:	00000097          	auipc	ra,0x0
    80003a7c:	acc080e7          	jalr	-1332(ra) # 80003544 <begin_op>
    iput(ff.ip);
    80003a80:	854e                	mv	a0,s3
    80003a82:	fffff097          	auipc	ra,0xfffff
    80003a86:	2a0080e7          	jalr	672(ra) # 80002d22 <iput>
    end_op();
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	b38080e7          	jalr	-1224(ra) # 800035c2 <end_op>
    80003a92:	a00d                	j	80003ab4 <fileclose+0xa8>
    panic("fileclose");
    80003a94:	00005517          	auipc	a0,0x5
    80003a98:	b8c50513          	addi	a0,a0,-1140 # 80008620 <syscalls+0x258>
    80003a9c:	00002097          	auipc	ra,0x2
    80003aa0:	1d2080e7          	jalr	466(ra) # 80005c6e <panic>
    release(&ftable.lock);
    80003aa4:	00016517          	auipc	a0,0x16
    80003aa8:	ec450513          	addi	a0,a0,-316 # 80019968 <ftable>
    80003aac:	00002097          	auipc	ra,0x2
    80003ab0:	784080e7          	jalr	1924(ra) # 80006230 <release>
  }
}
    80003ab4:	70e2                	ld	ra,56(sp)
    80003ab6:	7442                	ld	s0,48(sp)
    80003ab8:	74a2                	ld	s1,40(sp)
    80003aba:	7902                	ld	s2,32(sp)
    80003abc:	69e2                	ld	s3,24(sp)
    80003abe:	6a42                	ld	s4,16(sp)
    80003ac0:	6aa2                	ld	s5,8(sp)
    80003ac2:	6121                	addi	sp,sp,64
    80003ac4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ac6:	85d6                	mv	a1,s5
    80003ac8:	8552                	mv	a0,s4
    80003aca:	00000097          	auipc	ra,0x0
    80003ace:	34c080e7          	jalr	844(ra) # 80003e16 <pipeclose>
    80003ad2:	b7cd                	j	80003ab4 <fileclose+0xa8>

0000000080003ad4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ad4:	715d                	addi	sp,sp,-80
    80003ad6:	e486                	sd	ra,72(sp)
    80003ad8:	e0a2                	sd	s0,64(sp)
    80003ada:	fc26                	sd	s1,56(sp)
    80003adc:	f84a                	sd	s2,48(sp)
    80003ade:	f44e                	sd	s3,40(sp)
    80003ae0:	0880                	addi	s0,sp,80
    80003ae2:	84aa                	mv	s1,a0
    80003ae4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	35e080e7          	jalr	862(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aee:	409c                	lw	a5,0(s1)
    80003af0:	37f9                	addiw	a5,a5,-2
    80003af2:	4705                	li	a4,1
    80003af4:	04f76763          	bltu	a4,a5,80003b42 <filestat+0x6e>
    80003af8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003afa:	6c88                	ld	a0,24(s1)
    80003afc:	fffff097          	auipc	ra,0xfffff
    80003b00:	06c080e7          	jalr	108(ra) # 80002b68 <ilock>
    stati(f->ip, &st);
    80003b04:	fb840593          	addi	a1,s0,-72
    80003b08:	6c88                	ld	a0,24(s1)
    80003b0a:	fffff097          	auipc	ra,0xfffff
    80003b0e:	2e8080e7          	jalr	744(ra) # 80002df2 <stati>
    iunlock(f->ip);
    80003b12:	6c88                	ld	a0,24(s1)
    80003b14:	fffff097          	auipc	ra,0xfffff
    80003b18:	116080e7          	jalr	278(ra) # 80002c2a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b1c:	46e1                	li	a3,24
    80003b1e:	fb840613          	addi	a2,s0,-72
    80003b22:	85ce                	mv	a1,s3
    80003b24:	05093503          	ld	a0,80(s2)
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	fe0080e7          	jalr	-32(ra) # 80000b08 <copyout>
    80003b30:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b34:	60a6                	ld	ra,72(sp)
    80003b36:	6406                	ld	s0,64(sp)
    80003b38:	74e2                	ld	s1,56(sp)
    80003b3a:	7942                	ld	s2,48(sp)
    80003b3c:	79a2                	ld	s3,40(sp)
    80003b3e:	6161                	addi	sp,sp,80
    80003b40:	8082                	ret
  return -1;
    80003b42:	557d                	li	a0,-1
    80003b44:	bfc5                	j	80003b34 <filestat+0x60>

0000000080003b46 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b46:	7179                	addi	sp,sp,-48
    80003b48:	f406                	sd	ra,40(sp)
    80003b4a:	f022                	sd	s0,32(sp)
    80003b4c:	ec26                	sd	s1,24(sp)
    80003b4e:	e84a                	sd	s2,16(sp)
    80003b50:	e44e                	sd	s3,8(sp)
    80003b52:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b54:	00854783          	lbu	a5,8(a0)
    80003b58:	c3d5                	beqz	a5,80003bfc <fileread+0xb6>
    80003b5a:	84aa                	mv	s1,a0
    80003b5c:	89ae                	mv	s3,a1
    80003b5e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b60:	411c                	lw	a5,0(a0)
    80003b62:	4705                	li	a4,1
    80003b64:	04e78963          	beq	a5,a4,80003bb6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b68:	470d                	li	a4,3
    80003b6a:	04e78d63          	beq	a5,a4,80003bc4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b6e:	4709                	li	a4,2
    80003b70:	06e79e63          	bne	a5,a4,80003bec <fileread+0xa6>
    ilock(f->ip);
    80003b74:	6d08                	ld	a0,24(a0)
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	ff2080e7          	jalr	-14(ra) # 80002b68 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b7e:	874a                	mv	a4,s2
    80003b80:	5094                	lw	a3,32(s1)
    80003b82:	864e                	mv	a2,s3
    80003b84:	4585                	li	a1,1
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	294080e7          	jalr	660(ra) # 80002e1c <readi>
    80003b90:	892a                	mv	s2,a0
    80003b92:	00a05563          	blez	a0,80003b9c <fileread+0x56>
      f->off += r;
    80003b96:	509c                	lw	a5,32(s1)
    80003b98:	9fa9                	addw	a5,a5,a0
    80003b9a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	08c080e7          	jalr	140(ra) # 80002c2a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	70a2                	ld	ra,40(sp)
    80003baa:	7402                	ld	s0,32(sp)
    80003bac:	64e2                	ld	s1,24(sp)
    80003bae:	6942                	ld	s2,16(sp)
    80003bb0:	69a2                	ld	s3,8(sp)
    80003bb2:	6145                	addi	sp,sp,48
    80003bb4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bb6:	6908                	ld	a0,16(a0)
    80003bb8:	00000097          	auipc	ra,0x0
    80003bbc:	3c0080e7          	jalr	960(ra) # 80003f78 <piperead>
    80003bc0:	892a                	mv	s2,a0
    80003bc2:	b7d5                	j	80003ba6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bc4:	02451783          	lh	a5,36(a0)
    80003bc8:	03079693          	slli	a3,a5,0x30
    80003bcc:	92c1                	srli	a3,a3,0x30
    80003bce:	4725                	li	a4,9
    80003bd0:	02d76863          	bltu	a4,a3,80003c00 <fileread+0xba>
    80003bd4:	0792                	slli	a5,a5,0x4
    80003bd6:	00016717          	auipc	a4,0x16
    80003bda:	cf270713          	addi	a4,a4,-782 # 800198c8 <devsw>
    80003bde:	97ba                	add	a5,a5,a4
    80003be0:	639c                	ld	a5,0(a5)
    80003be2:	c38d                	beqz	a5,80003c04 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003be4:	4505                	li	a0,1
    80003be6:	9782                	jalr	a5
    80003be8:	892a                	mv	s2,a0
    80003bea:	bf75                	j	80003ba6 <fileread+0x60>
    panic("fileread");
    80003bec:	00005517          	auipc	a0,0x5
    80003bf0:	a4450513          	addi	a0,a0,-1468 # 80008630 <syscalls+0x268>
    80003bf4:	00002097          	auipc	ra,0x2
    80003bf8:	07a080e7          	jalr	122(ra) # 80005c6e <panic>
    return -1;
    80003bfc:	597d                	li	s2,-1
    80003bfe:	b765                	j	80003ba6 <fileread+0x60>
      return -1;
    80003c00:	597d                	li	s2,-1
    80003c02:	b755                	j	80003ba6 <fileread+0x60>
    80003c04:	597d                	li	s2,-1
    80003c06:	b745                	j	80003ba6 <fileread+0x60>

0000000080003c08 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c08:	715d                	addi	sp,sp,-80
    80003c0a:	e486                	sd	ra,72(sp)
    80003c0c:	e0a2                	sd	s0,64(sp)
    80003c0e:	fc26                	sd	s1,56(sp)
    80003c10:	f84a                	sd	s2,48(sp)
    80003c12:	f44e                	sd	s3,40(sp)
    80003c14:	f052                	sd	s4,32(sp)
    80003c16:	ec56                	sd	s5,24(sp)
    80003c18:	e85a                	sd	s6,16(sp)
    80003c1a:	e45e                	sd	s7,8(sp)
    80003c1c:	e062                	sd	s8,0(sp)
    80003c1e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c20:	00954783          	lbu	a5,9(a0)
    80003c24:	10078663          	beqz	a5,80003d30 <filewrite+0x128>
    80003c28:	892a                	mv	s2,a0
    80003c2a:	8b2e                	mv	s6,a1
    80003c2c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c2e:	411c                	lw	a5,0(a0)
    80003c30:	4705                	li	a4,1
    80003c32:	02e78263          	beq	a5,a4,80003c56 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c36:	470d                	li	a4,3
    80003c38:	02e78663          	beq	a5,a4,80003c64 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c3c:	4709                	li	a4,2
    80003c3e:	0ee79163          	bne	a5,a4,80003d20 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c42:	0ac05d63          	blez	a2,80003cfc <filewrite+0xf4>
    int i = 0;
    80003c46:	4981                	li	s3,0
    80003c48:	6b85                	lui	s7,0x1
    80003c4a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c4e:	6c05                	lui	s8,0x1
    80003c50:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c54:	a861                	j	80003cec <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c56:	6908                	ld	a0,16(a0)
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	22e080e7          	jalr	558(ra) # 80003e86 <pipewrite>
    80003c60:	8a2a                	mv	s4,a0
    80003c62:	a045                	j	80003d02 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c64:	02451783          	lh	a5,36(a0)
    80003c68:	03079693          	slli	a3,a5,0x30
    80003c6c:	92c1                	srli	a3,a3,0x30
    80003c6e:	4725                	li	a4,9
    80003c70:	0cd76263          	bltu	a4,a3,80003d34 <filewrite+0x12c>
    80003c74:	0792                	slli	a5,a5,0x4
    80003c76:	00016717          	auipc	a4,0x16
    80003c7a:	c5270713          	addi	a4,a4,-942 # 800198c8 <devsw>
    80003c7e:	97ba                	add	a5,a5,a4
    80003c80:	679c                	ld	a5,8(a5)
    80003c82:	cbdd                	beqz	a5,80003d38 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c84:	4505                	li	a0,1
    80003c86:	9782                	jalr	a5
    80003c88:	8a2a                	mv	s4,a0
    80003c8a:	a8a5                	j	80003d02 <filewrite+0xfa>
    80003c8c:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	8b4080e7          	jalr	-1868(ra) # 80003544 <begin_op>
      ilock(f->ip);
    80003c98:	01893503          	ld	a0,24(s2)
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	ecc080e7          	jalr	-308(ra) # 80002b68 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ca4:	8756                	mv	a4,s5
    80003ca6:	02092683          	lw	a3,32(s2)
    80003caa:	01698633          	add	a2,s3,s6
    80003cae:	4585                	li	a1,1
    80003cb0:	01893503          	ld	a0,24(s2)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	260080e7          	jalr	608(ra) # 80002f14 <writei>
    80003cbc:	84aa                	mv	s1,a0
    80003cbe:	00a05763          	blez	a0,80003ccc <filewrite+0xc4>
        f->off += r;
    80003cc2:	02092783          	lw	a5,32(s2)
    80003cc6:	9fa9                	addw	a5,a5,a0
    80003cc8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ccc:	01893503          	ld	a0,24(s2)
    80003cd0:	fffff097          	auipc	ra,0xfffff
    80003cd4:	f5a080e7          	jalr	-166(ra) # 80002c2a <iunlock>
      end_op();
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	8ea080e7          	jalr	-1814(ra) # 800035c2 <end_op>

      if(r != n1){
    80003ce0:	009a9f63          	bne	s5,s1,80003cfe <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ce4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ce8:	0149db63          	bge	s3,s4,80003cfe <filewrite+0xf6>
      int n1 = n - i;
    80003cec:	413a04bb          	subw	s1,s4,s3
    80003cf0:	0004879b          	sext.w	a5,s1
    80003cf4:	f8fbdce3          	bge	s7,a5,80003c8c <filewrite+0x84>
    80003cf8:	84e2                	mv	s1,s8
    80003cfa:	bf49                	j	80003c8c <filewrite+0x84>
    int i = 0;
    80003cfc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cfe:	013a1f63          	bne	s4,s3,80003d1c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d02:	8552                	mv	a0,s4
    80003d04:	60a6                	ld	ra,72(sp)
    80003d06:	6406                	ld	s0,64(sp)
    80003d08:	74e2                	ld	s1,56(sp)
    80003d0a:	7942                	ld	s2,48(sp)
    80003d0c:	79a2                	ld	s3,40(sp)
    80003d0e:	7a02                	ld	s4,32(sp)
    80003d10:	6ae2                	ld	s5,24(sp)
    80003d12:	6b42                	ld	s6,16(sp)
    80003d14:	6ba2                	ld	s7,8(sp)
    80003d16:	6c02                	ld	s8,0(sp)
    80003d18:	6161                	addi	sp,sp,80
    80003d1a:	8082                	ret
    ret = (i == n ? n : -1);
    80003d1c:	5a7d                	li	s4,-1
    80003d1e:	b7d5                	j	80003d02 <filewrite+0xfa>
    panic("filewrite");
    80003d20:	00005517          	auipc	a0,0x5
    80003d24:	92050513          	addi	a0,a0,-1760 # 80008640 <syscalls+0x278>
    80003d28:	00002097          	auipc	ra,0x2
    80003d2c:	f46080e7          	jalr	-186(ra) # 80005c6e <panic>
    return -1;
    80003d30:	5a7d                	li	s4,-1
    80003d32:	bfc1                	j	80003d02 <filewrite+0xfa>
      return -1;
    80003d34:	5a7d                	li	s4,-1
    80003d36:	b7f1                	j	80003d02 <filewrite+0xfa>
    80003d38:	5a7d                	li	s4,-1
    80003d3a:	b7e1                	j	80003d02 <filewrite+0xfa>

0000000080003d3c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d3c:	7179                	addi	sp,sp,-48
    80003d3e:	f406                	sd	ra,40(sp)
    80003d40:	f022                	sd	s0,32(sp)
    80003d42:	ec26                	sd	s1,24(sp)
    80003d44:	e84a                	sd	s2,16(sp)
    80003d46:	e44e                	sd	s3,8(sp)
    80003d48:	e052                	sd	s4,0(sp)
    80003d4a:	1800                	addi	s0,sp,48
    80003d4c:	84aa                	mv	s1,a0
    80003d4e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d50:	0005b023          	sd	zero,0(a1)
    80003d54:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	bf8080e7          	jalr	-1032(ra) # 80003950 <filealloc>
    80003d60:	e088                	sd	a0,0(s1)
    80003d62:	c551                	beqz	a0,80003dee <pipealloc+0xb2>
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	bec080e7          	jalr	-1044(ra) # 80003950 <filealloc>
    80003d6c:	00aa3023          	sd	a0,0(s4)
    80003d70:	c92d                	beqz	a0,80003de2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d72:	ffffc097          	auipc	ra,0xffffc
    80003d76:	3a8080e7          	jalr	936(ra) # 8000011a <kalloc>
    80003d7a:	892a                	mv	s2,a0
    80003d7c:	c125                	beqz	a0,80003ddc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d7e:	4985                	li	s3,1
    80003d80:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d84:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d88:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d8c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d90:	00005597          	auipc	a1,0x5
    80003d94:	8c058593          	addi	a1,a1,-1856 # 80008650 <syscalls+0x288>
    80003d98:	00002097          	auipc	ra,0x2
    80003d9c:	354080e7          	jalr	852(ra) # 800060ec <initlock>
  (*f0)->type = FD_PIPE;
    80003da0:	609c                	ld	a5,0(s1)
    80003da2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003da6:	609c                	ld	a5,0(s1)
    80003da8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dac:	609c                	ld	a5,0(s1)
    80003dae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003db2:	609c                	ld	a5,0(s1)
    80003db4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003db8:	000a3783          	ld	a5,0(s4)
    80003dbc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dc0:	000a3783          	ld	a5,0(s4)
    80003dc4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dc8:	000a3783          	ld	a5,0(s4)
    80003dcc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dd0:	000a3783          	ld	a5,0(s4)
    80003dd4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dd8:	4501                	li	a0,0
    80003dda:	a025                	j	80003e02 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ddc:	6088                	ld	a0,0(s1)
    80003dde:	e501                	bnez	a0,80003de6 <pipealloc+0xaa>
    80003de0:	a039                	j	80003dee <pipealloc+0xb2>
    80003de2:	6088                	ld	a0,0(s1)
    80003de4:	c51d                	beqz	a0,80003e12 <pipealloc+0xd6>
    fileclose(*f0);
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	c26080e7          	jalr	-986(ra) # 80003a0c <fileclose>
  if(*f1)
    80003dee:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003df2:	557d                	li	a0,-1
  if(*f1)
    80003df4:	c799                	beqz	a5,80003e02 <pipealloc+0xc6>
    fileclose(*f1);
    80003df6:	853e                	mv	a0,a5
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	c14080e7          	jalr	-1004(ra) # 80003a0c <fileclose>
  return -1;
    80003e00:	557d                	li	a0,-1
}
    80003e02:	70a2                	ld	ra,40(sp)
    80003e04:	7402                	ld	s0,32(sp)
    80003e06:	64e2                	ld	s1,24(sp)
    80003e08:	6942                	ld	s2,16(sp)
    80003e0a:	69a2                	ld	s3,8(sp)
    80003e0c:	6a02                	ld	s4,0(sp)
    80003e0e:	6145                	addi	sp,sp,48
    80003e10:	8082                	ret
  return -1;
    80003e12:	557d                	li	a0,-1
    80003e14:	b7fd                	j	80003e02 <pipealloc+0xc6>

0000000080003e16 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e16:	1101                	addi	sp,sp,-32
    80003e18:	ec06                	sd	ra,24(sp)
    80003e1a:	e822                	sd	s0,16(sp)
    80003e1c:	e426                	sd	s1,8(sp)
    80003e1e:	e04a                	sd	s2,0(sp)
    80003e20:	1000                	addi	s0,sp,32
    80003e22:	84aa                	mv	s1,a0
    80003e24:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	356080e7          	jalr	854(ra) # 8000617c <acquire>
  if(writable){
    80003e2e:	02090d63          	beqz	s2,80003e68 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e32:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e36:	21848513          	addi	a0,s1,536
    80003e3a:	ffffe097          	auipc	ra,0xffffe
    80003e3e:	86a080e7          	jalr	-1942(ra) # 800016a4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e42:	2204b783          	ld	a5,544(s1)
    80003e46:	eb95                	bnez	a5,80003e7a <pipeclose+0x64>
    release(&pi->lock);
    80003e48:	8526                	mv	a0,s1
    80003e4a:	00002097          	auipc	ra,0x2
    80003e4e:	3e6080e7          	jalr	998(ra) # 80006230 <release>
    kfree((char*)pi);
    80003e52:	8526                	mv	a0,s1
    80003e54:	ffffc097          	auipc	ra,0xffffc
    80003e58:	1c8080e7          	jalr	456(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e5c:	60e2                	ld	ra,24(sp)
    80003e5e:	6442                	ld	s0,16(sp)
    80003e60:	64a2                	ld	s1,8(sp)
    80003e62:	6902                	ld	s2,0(sp)
    80003e64:	6105                	addi	sp,sp,32
    80003e66:	8082                	ret
    pi->readopen = 0;
    80003e68:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e6c:	21c48513          	addi	a0,s1,540
    80003e70:	ffffe097          	auipc	ra,0xffffe
    80003e74:	834080e7          	jalr	-1996(ra) # 800016a4 <wakeup>
    80003e78:	b7e9                	j	80003e42 <pipeclose+0x2c>
    release(&pi->lock);
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	3b4080e7          	jalr	948(ra) # 80006230 <release>
}
    80003e84:	bfe1                	j	80003e5c <pipeclose+0x46>

0000000080003e86 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e86:	711d                	addi	sp,sp,-96
    80003e88:	ec86                	sd	ra,88(sp)
    80003e8a:	e8a2                	sd	s0,80(sp)
    80003e8c:	e4a6                	sd	s1,72(sp)
    80003e8e:	e0ca                	sd	s2,64(sp)
    80003e90:	fc4e                	sd	s3,56(sp)
    80003e92:	f852                	sd	s4,48(sp)
    80003e94:	f456                	sd	s5,40(sp)
    80003e96:	f05a                	sd	s6,32(sp)
    80003e98:	ec5e                	sd	s7,24(sp)
    80003e9a:	e862                	sd	s8,16(sp)
    80003e9c:	1080                	addi	s0,sp,96
    80003e9e:	84aa                	mv	s1,a0
    80003ea0:	8aae                	mv	s5,a1
    80003ea2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ea4:	ffffd097          	auipc	ra,0xffffd
    80003ea8:	fa0080e7          	jalr	-96(ra) # 80000e44 <myproc>
    80003eac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eae:	8526                	mv	a0,s1
    80003eb0:	00002097          	auipc	ra,0x2
    80003eb4:	2cc080e7          	jalr	716(ra) # 8000617c <acquire>
  while(i < n){
    80003eb8:	0b405363          	blez	s4,80003f5e <pipewrite+0xd8>
  int i = 0;
    80003ebc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ebe:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ec0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ec4:	21c48b93          	addi	s7,s1,540
    80003ec8:	a089                	j	80003f0a <pipewrite+0x84>
      release(&pi->lock);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	364080e7          	jalr	868(ra) # 80006230 <release>
      return -1;
    80003ed4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ed6:	854a                	mv	a0,s2
    80003ed8:	60e6                	ld	ra,88(sp)
    80003eda:	6446                	ld	s0,80(sp)
    80003edc:	64a6                	ld	s1,72(sp)
    80003ede:	6906                	ld	s2,64(sp)
    80003ee0:	79e2                	ld	s3,56(sp)
    80003ee2:	7a42                	ld	s4,48(sp)
    80003ee4:	7aa2                	ld	s5,40(sp)
    80003ee6:	7b02                	ld	s6,32(sp)
    80003ee8:	6be2                	ld	s7,24(sp)
    80003eea:	6c42                	ld	s8,16(sp)
    80003eec:	6125                	addi	sp,sp,96
    80003eee:	8082                	ret
      wakeup(&pi->nread);
    80003ef0:	8562                	mv	a0,s8
    80003ef2:	ffffd097          	auipc	ra,0xffffd
    80003ef6:	7b2080e7          	jalr	1970(ra) # 800016a4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003efa:	85a6                	mv	a1,s1
    80003efc:	855e                	mv	a0,s7
    80003efe:	ffffd097          	auipc	ra,0xffffd
    80003f02:	61a080e7          	jalr	1562(ra) # 80001518 <sleep>
  while(i < n){
    80003f06:	05495d63          	bge	s2,s4,80003f60 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f0a:	2204a783          	lw	a5,544(s1)
    80003f0e:	dfd5                	beqz	a5,80003eca <pipewrite+0x44>
    80003f10:	0289a783          	lw	a5,40(s3)
    80003f14:	fbdd                	bnez	a5,80003eca <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f16:	2184a783          	lw	a5,536(s1)
    80003f1a:	21c4a703          	lw	a4,540(s1)
    80003f1e:	2007879b          	addiw	a5,a5,512
    80003f22:	fcf707e3          	beq	a4,a5,80003ef0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f26:	4685                	li	a3,1
    80003f28:	01590633          	add	a2,s2,s5
    80003f2c:	faf40593          	addi	a1,s0,-81
    80003f30:	0509b503          	ld	a0,80(s3)
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	c60080e7          	jalr	-928(ra) # 80000b94 <copyin>
    80003f3c:	03650263          	beq	a0,s6,80003f60 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f40:	21c4a783          	lw	a5,540(s1)
    80003f44:	0017871b          	addiw	a4,a5,1
    80003f48:	20e4ae23          	sw	a4,540(s1)
    80003f4c:	1ff7f793          	andi	a5,a5,511
    80003f50:	97a6                	add	a5,a5,s1
    80003f52:	faf44703          	lbu	a4,-81(s0)
    80003f56:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f5a:	2905                	addiw	s2,s2,1
    80003f5c:	b76d                	j	80003f06 <pipewrite+0x80>
  int i = 0;
    80003f5e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f60:	21848513          	addi	a0,s1,536
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	740080e7          	jalr	1856(ra) # 800016a4 <wakeup>
  release(&pi->lock);
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	00002097          	auipc	ra,0x2
    80003f72:	2c2080e7          	jalr	706(ra) # 80006230 <release>
  return i;
    80003f76:	b785                	j	80003ed6 <pipewrite+0x50>

0000000080003f78 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f78:	715d                	addi	sp,sp,-80
    80003f7a:	e486                	sd	ra,72(sp)
    80003f7c:	e0a2                	sd	s0,64(sp)
    80003f7e:	fc26                	sd	s1,56(sp)
    80003f80:	f84a                	sd	s2,48(sp)
    80003f82:	f44e                	sd	s3,40(sp)
    80003f84:	f052                	sd	s4,32(sp)
    80003f86:	ec56                	sd	s5,24(sp)
    80003f88:	e85a                	sd	s6,16(sp)
    80003f8a:	0880                	addi	s0,sp,80
    80003f8c:	84aa                	mv	s1,a0
    80003f8e:	892e                	mv	s2,a1
    80003f90:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	eb2080e7          	jalr	-334(ra) # 80000e44 <myproc>
    80003f9a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	1de080e7          	jalr	478(ra) # 8000617c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa6:	2184a703          	lw	a4,536(s1)
    80003faa:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fae:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fb2:	02f71463          	bne	a4,a5,80003fda <piperead+0x62>
    80003fb6:	2244a783          	lw	a5,548(s1)
    80003fba:	c385                	beqz	a5,80003fda <piperead+0x62>
    if(pr->killed){
    80003fbc:	028a2783          	lw	a5,40(s4)
    80003fc0:	ebc9                	bnez	a5,80004052 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fc2:	85a6                	mv	a1,s1
    80003fc4:	854e                	mv	a0,s3
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	552080e7          	jalr	1362(ra) # 80001518 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fce:	2184a703          	lw	a4,536(s1)
    80003fd2:	21c4a783          	lw	a5,540(s1)
    80003fd6:	fef700e3          	beq	a4,a5,80003fb6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fda:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fdc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fde:	05505463          	blez	s5,80004026 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003fe2:	2184a783          	lw	a5,536(s1)
    80003fe6:	21c4a703          	lw	a4,540(s1)
    80003fea:	02f70e63          	beq	a4,a5,80004026 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fee:	0017871b          	addiw	a4,a5,1
    80003ff2:	20e4ac23          	sw	a4,536(s1)
    80003ff6:	1ff7f793          	andi	a5,a5,511
    80003ffa:	97a6                	add	a5,a5,s1
    80003ffc:	0187c783          	lbu	a5,24(a5)
    80004000:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004004:	4685                	li	a3,1
    80004006:	fbf40613          	addi	a2,s0,-65
    8000400a:	85ca                	mv	a1,s2
    8000400c:	050a3503          	ld	a0,80(s4)
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	af8080e7          	jalr	-1288(ra) # 80000b08 <copyout>
    80004018:	01650763          	beq	a0,s6,80004026 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401c:	2985                	addiw	s3,s3,1
    8000401e:	0905                	addi	s2,s2,1
    80004020:	fd3a91e3          	bne	s5,s3,80003fe2 <piperead+0x6a>
    80004024:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004026:	21c48513          	addi	a0,s1,540
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	67a080e7          	jalr	1658(ra) # 800016a4 <wakeup>
  release(&pi->lock);
    80004032:	8526                	mv	a0,s1
    80004034:	00002097          	auipc	ra,0x2
    80004038:	1fc080e7          	jalr	508(ra) # 80006230 <release>
  return i;
}
    8000403c:	854e                	mv	a0,s3
    8000403e:	60a6                	ld	ra,72(sp)
    80004040:	6406                	ld	s0,64(sp)
    80004042:	74e2                	ld	s1,56(sp)
    80004044:	7942                	ld	s2,48(sp)
    80004046:	79a2                	ld	s3,40(sp)
    80004048:	7a02                	ld	s4,32(sp)
    8000404a:	6ae2                	ld	s5,24(sp)
    8000404c:	6b42                	ld	s6,16(sp)
    8000404e:	6161                	addi	sp,sp,80
    80004050:	8082                	ret
      release(&pi->lock);
    80004052:	8526                	mv	a0,s1
    80004054:	00002097          	auipc	ra,0x2
    80004058:	1dc080e7          	jalr	476(ra) # 80006230 <release>
      return -1;
    8000405c:	59fd                	li	s3,-1
    8000405e:	bff9                	j	8000403c <piperead+0xc4>

0000000080004060 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004060:	de010113          	addi	sp,sp,-544
    80004064:	20113c23          	sd	ra,536(sp)
    80004068:	20813823          	sd	s0,528(sp)
    8000406c:	20913423          	sd	s1,520(sp)
    80004070:	21213023          	sd	s2,512(sp)
    80004074:	ffce                	sd	s3,504(sp)
    80004076:	fbd2                	sd	s4,496(sp)
    80004078:	f7d6                	sd	s5,488(sp)
    8000407a:	f3da                	sd	s6,480(sp)
    8000407c:	efde                	sd	s7,472(sp)
    8000407e:	ebe2                	sd	s8,464(sp)
    80004080:	e7e6                	sd	s9,456(sp)
    80004082:	e3ea                	sd	s10,448(sp)
    80004084:	ff6e                	sd	s11,440(sp)
    80004086:	1400                	addi	s0,sp,544
    80004088:	892a                	mv	s2,a0
    8000408a:	dea43423          	sd	a0,-536(s0)
    8000408e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	db2080e7          	jalr	-590(ra) # 80000e44 <myproc>
    8000409a:	84aa                	mv	s1,a0

  begin_op();
    8000409c:	fffff097          	auipc	ra,0xfffff
    800040a0:	4a8080e7          	jalr	1192(ra) # 80003544 <begin_op>

  if((ip = namei(path)) == 0){
    800040a4:	854a                	mv	a0,s2
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	27e080e7          	jalr	638(ra) # 80003324 <namei>
    800040ae:	c93d                	beqz	a0,80004124 <exec+0xc4>
    800040b0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	ab6080e7          	jalr	-1354(ra) # 80002b68 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ba:	04000713          	li	a4,64
    800040be:	4681                	li	a3,0
    800040c0:	e5040613          	addi	a2,s0,-432
    800040c4:	4581                	li	a1,0
    800040c6:	8556                	mv	a0,s5
    800040c8:	fffff097          	auipc	ra,0xfffff
    800040cc:	d54080e7          	jalr	-684(ra) # 80002e1c <readi>
    800040d0:	04000793          	li	a5,64
    800040d4:	00f51a63          	bne	a0,a5,800040e8 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040d8:	e5042703          	lw	a4,-432(s0)
    800040dc:	464c47b7          	lui	a5,0x464c4
    800040e0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040e4:	04f70663          	beq	a4,a5,80004130 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040e8:	8556                	mv	a0,s5
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	ce0080e7          	jalr	-800(ra) # 80002dca <iunlockput>
    end_op();
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	4d0080e7          	jalr	1232(ra) # 800035c2 <end_op>
  }
  return -1;
    800040fa:	557d                	li	a0,-1
}
    800040fc:	21813083          	ld	ra,536(sp)
    80004100:	21013403          	ld	s0,528(sp)
    80004104:	20813483          	ld	s1,520(sp)
    80004108:	20013903          	ld	s2,512(sp)
    8000410c:	79fe                	ld	s3,504(sp)
    8000410e:	7a5e                	ld	s4,496(sp)
    80004110:	7abe                	ld	s5,488(sp)
    80004112:	7b1e                	ld	s6,480(sp)
    80004114:	6bfe                	ld	s7,472(sp)
    80004116:	6c5e                	ld	s8,464(sp)
    80004118:	6cbe                	ld	s9,456(sp)
    8000411a:	6d1e                	ld	s10,448(sp)
    8000411c:	7dfa                	ld	s11,440(sp)
    8000411e:	22010113          	addi	sp,sp,544
    80004122:	8082                	ret
    end_op();
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	49e080e7          	jalr	1182(ra) # 800035c2 <end_op>
    return -1;
    8000412c:	557d                	li	a0,-1
    8000412e:	b7f9                	j	800040fc <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004130:	8526                	mv	a0,s1
    80004132:	ffffd097          	auipc	ra,0xffffd
    80004136:	dd6080e7          	jalr	-554(ra) # 80000f08 <proc_pagetable>
    8000413a:	8b2a                	mv	s6,a0
    8000413c:	d555                	beqz	a0,800040e8 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000413e:	e7042783          	lw	a5,-400(s0)
    80004142:	e8845703          	lhu	a4,-376(s0)
    80004146:	c735                	beqz	a4,800041b2 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004148:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000414a:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000414e:	6a05                	lui	s4,0x1
    80004150:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004154:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004158:	6d85                	lui	s11,0x1
    8000415a:	7d7d                	lui	s10,0xfffff
    8000415c:	ac1d                	j	80004392 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000415e:	00004517          	auipc	a0,0x4
    80004162:	4fa50513          	addi	a0,a0,1274 # 80008658 <syscalls+0x290>
    80004166:	00002097          	auipc	ra,0x2
    8000416a:	b08080e7          	jalr	-1272(ra) # 80005c6e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000416e:	874a                	mv	a4,s2
    80004170:	009c86bb          	addw	a3,s9,s1
    80004174:	4581                	li	a1,0
    80004176:	8556                	mv	a0,s5
    80004178:	fffff097          	auipc	ra,0xfffff
    8000417c:	ca4080e7          	jalr	-860(ra) # 80002e1c <readi>
    80004180:	2501                	sext.w	a0,a0
    80004182:	1aa91863          	bne	s2,a0,80004332 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004186:	009d84bb          	addw	s1,s11,s1
    8000418a:	013d09bb          	addw	s3,s10,s3
    8000418e:	1f74f263          	bgeu	s1,s7,80004372 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004192:	02049593          	slli	a1,s1,0x20
    80004196:	9181                	srli	a1,a1,0x20
    80004198:	95e2                	add	a1,a1,s8
    8000419a:	855a                	mv	a0,s6
    8000419c:	ffffc097          	auipc	ra,0xffffc
    800041a0:	364080e7          	jalr	868(ra) # 80000500 <walkaddr>
    800041a4:	862a                	mv	a2,a0
    if(pa == 0)
    800041a6:	dd45                	beqz	a0,8000415e <exec+0xfe>
      n = PGSIZE;
    800041a8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041aa:	fd49f2e3          	bgeu	s3,s4,8000416e <exec+0x10e>
      n = sz - i;
    800041ae:	894e                	mv	s2,s3
    800041b0:	bf7d                	j	8000416e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b2:	4481                	li	s1,0
  iunlockput(ip);
    800041b4:	8556                	mv	a0,s5
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	c14080e7          	jalr	-1004(ra) # 80002dca <iunlockput>
  end_op();
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	404080e7          	jalr	1028(ra) # 800035c2 <end_op>
  p = myproc();
    800041c6:	ffffd097          	auipc	ra,0xffffd
    800041ca:	c7e080e7          	jalr	-898(ra) # 80000e44 <myproc>
    800041ce:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041d0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041d4:	6785                	lui	a5,0x1
    800041d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800041d8:	97a6                	add	a5,a5,s1
    800041da:	777d                	lui	a4,0xfffff
    800041dc:	8ff9                	and	a5,a5,a4
    800041de:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041e2:	6609                	lui	a2,0x2
    800041e4:	963e                	add	a2,a2,a5
    800041e6:	85be                	mv	a1,a5
    800041e8:	855a                	mv	a0,s6
    800041ea:	ffffc097          	auipc	ra,0xffffc
    800041ee:	6ca080e7          	jalr	1738(ra) # 800008b4 <uvmalloc>
    800041f2:	8c2a                	mv	s8,a0
  ip = 0;
    800041f4:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041f6:	12050e63          	beqz	a0,80004332 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041fa:	75f9                	lui	a1,0xffffe
    800041fc:	95aa                	add	a1,a1,a0
    800041fe:	855a                	mv	a0,s6
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	8d6080e7          	jalr	-1834(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004208:	7afd                	lui	s5,0xfffff
    8000420a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000420c:	df043783          	ld	a5,-528(s0)
    80004210:	6388                	ld	a0,0(a5)
    80004212:	c925                	beqz	a0,80004282 <exec+0x222>
    80004214:	e9040993          	addi	s3,s0,-368
    80004218:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000421c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000421e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004220:	ffffc097          	auipc	ra,0xffffc
    80004224:	0d6080e7          	jalr	214(ra) # 800002f6 <strlen>
    80004228:	0015079b          	addiw	a5,a0,1
    8000422c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004230:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004234:	13596363          	bltu	s2,s5,8000435a <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004238:	df043d83          	ld	s11,-528(s0)
    8000423c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004240:	8552                	mv	a0,s4
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	0b4080e7          	jalr	180(ra) # 800002f6 <strlen>
    8000424a:	0015069b          	addiw	a3,a0,1
    8000424e:	8652                	mv	a2,s4
    80004250:	85ca                	mv	a1,s2
    80004252:	855a                	mv	a0,s6
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	8b4080e7          	jalr	-1868(ra) # 80000b08 <copyout>
    8000425c:	10054363          	bltz	a0,80004362 <exec+0x302>
    ustack[argc] = sp;
    80004260:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004264:	0485                	addi	s1,s1,1
    80004266:	008d8793          	addi	a5,s11,8
    8000426a:	def43823          	sd	a5,-528(s0)
    8000426e:	008db503          	ld	a0,8(s11)
    80004272:	c911                	beqz	a0,80004286 <exec+0x226>
    if(argc >= MAXARG)
    80004274:	09a1                	addi	s3,s3,8
    80004276:	fb3c95e3          	bne	s9,s3,80004220 <exec+0x1c0>
  sz = sz1;
    8000427a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000427e:	4a81                	li	s5,0
    80004280:	a84d                	j	80004332 <exec+0x2d2>
  sp = sz;
    80004282:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004284:	4481                	li	s1,0
  ustack[argc] = 0;
    80004286:	00349793          	slli	a5,s1,0x3
    8000428a:	f9078793          	addi	a5,a5,-112
    8000428e:	97a2                	add	a5,a5,s0
    80004290:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004294:	00148693          	addi	a3,s1,1
    80004298:	068e                	slli	a3,a3,0x3
    8000429a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000429e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042a2:	01597663          	bgeu	s2,s5,800042ae <exec+0x24e>
  sz = sz1;
    800042a6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042aa:	4a81                	li	s5,0
    800042ac:	a059                	j	80004332 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042ae:	e9040613          	addi	a2,s0,-368
    800042b2:	85ca                	mv	a1,s2
    800042b4:	855a                	mv	a0,s6
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	852080e7          	jalr	-1966(ra) # 80000b08 <copyout>
    800042be:	0a054663          	bltz	a0,8000436a <exec+0x30a>
  p->trapframe->a1 = sp;
    800042c2:	058bb783          	ld	a5,88(s7)
    800042c6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042ca:	de843783          	ld	a5,-536(s0)
    800042ce:	0007c703          	lbu	a4,0(a5)
    800042d2:	cf11                	beqz	a4,800042ee <exec+0x28e>
    800042d4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042d6:	02f00693          	li	a3,47
    800042da:	a039                	j	800042e8 <exec+0x288>
      last = s+1;
    800042dc:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800042e0:	0785                	addi	a5,a5,1
    800042e2:	fff7c703          	lbu	a4,-1(a5)
    800042e6:	c701                	beqz	a4,800042ee <exec+0x28e>
    if(*s == '/')
    800042e8:	fed71ce3          	bne	a4,a3,800042e0 <exec+0x280>
    800042ec:	bfc5                	j	800042dc <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800042ee:	4641                	li	a2,16
    800042f0:	de843583          	ld	a1,-536(s0)
    800042f4:	158b8513          	addi	a0,s7,344
    800042f8:	ffffc097          	auipc	ra,0xffffc
    800042fc:	fcc080e7          	jalr	-52(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004300:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004304:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004308:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000430c:	058bb783          	ld	a5,88(s7)
    80004310:	e6843703          	ld	a4,-408(s0)
    80004314:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004316:	058bb783          	ld	a5,88(s7)
    8000431a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000431e:	85ea                	mv	a1,s10
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	c84080e7          	jalr	-892(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004328:	0004851b          	sext.w	a0,s1
    8000432c:	bbc1                	j	800040fc <exec+0x9c>
    8000432e:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004332:	df843583          	ld	a1,-520(s0)
    80004336:	855a                	mv	a0,s6
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	c6c080e7          	jalr	-916(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    80004340:	da0a94e3          	bnez	s5,800040e8 <exec+0x88>
  return -1;
    80004344:	557d                	li	a0,-1
    80004346:	bb5d                	j	800040fc <exec+0x9c>
    80004348:	de943c23          	sd	s1,-520(s0)
    8000434c:	b7dd                	j	80004332 <exec+0x2d2>
    8000434e:	de943c23          	sd	s1,-520(s0)
    80004352:	b7c5                	j	80004332 <exec+0x2d2>
    80004354:	de943c23          	sd	s1,-520(s0)
    80004358:	bfe9                	j	80004332 <exec+0x2d2>
  sz = sz1;
    8000435a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000435e:	4a81                	li	s5,0
    80004360:	bfc9                	j	80004332 <exec+0x2d2>
  sz = sz1;
    80004362:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004366:	4a81                	li	s5,0
    80004368:	b7e9                	j	80004332 <exec+0x2d2>
  sz = sz1;
    8000436a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000436e:	4a81                	li	s5,0
    80004370:	b7c9                	j	80004332 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004372:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004376:	e0843783          	ld	a5,-504(s0)
    8000437a:	0017869b          	addiw	a3,a5,1
    8000437e:	e0d43423          	sd	a3,-504(s0)
    80004382:	e0043783          	ld	a5,-512(s0)
    80004386:	0387879b          	addiw	a5,a5,56
    8000438a:	e8845703          	lhu	a4,-376(s0)
    8000438e:	e2e6d3e3          	bge	a3,a4,800041b4 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004392:	2781                	sext.w	a5,a5
    80004394:	e0f43023          	sd	a5,-512(s0)
    80004398:	03800713          	li	a4,56
    8000439c:	86be                	mv	a3,a5
    8000439e:	e1840613          	addi	a2,s0,-488
    800043a2:	4581                	li	a1,0
    800043a4:	8556                	mv	a0,s5
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	a76080e7          	jalr	-1418(ra) # 80002e1c <readi>
    800043ae:	03800793          	li	a5,56
    800043b2:	f6f51ee3          	bne	a0,a5,8000432e <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800043b6:	e1842783          	lw	a5,-488(s0)
    800043ba:	4705                	li	a4,1
    800043bc:	fae79de3          	bne	a5,a4,80004376 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800043c0:	e4043603          	ld	a2,-448(s0)
    800043c4:	e3843783          	ld	a5,-456(s0)
    800043c8:	f8f660e3          	bltu	a2,a5,80004348 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043cc:	e2843783          	ld	a5,-472(s0)
    800043d0:	963e                	add	a2,a2,a5
    800043d2:	f6f66ee3          	bltu	a2,a5,8000434e <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043d6:	85a6                	mv	a1,s1
    800043d8:	855a                	mv	a0,s6
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	4da080e7          	jalr	1242(ra) # 800008b4 <uvmalloc>
    800043e2:	dea43c23          	sd	a0,-520(s0)
    800043e6:	d53d                	beqz	a0,80004354 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800043e8:	e2843c03          	ld	s8,-472(s0)
    800043ec:	de043783          	ld	a5,-544(s0)
    800043f0:	00fc77b3          	and	a5,s8,a5
    800043f4:	ff9d                	bnez	a5,80004332 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043f6:	e2042c83          	lw	s9,-480(s0)
    800043fa:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043fe:	f60b8ae3          	beqz	s7,80004372 <exec+0x312>
    80004402:	89de                	mv	s3,s7
    80004404:	4481                	li	s1,0
    80004406:	b371                	j	80004192 <exec+0x132>

0000000080004408 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004408:	7179                	addi	sp,sp,-48
    8000440a:	f406                	sd	ra,40(sp)
    8000440c:	f022                	sd	s0,32(sp)
    8000440e:	ec26                	sd	s1,24(sp)
    80004410:	e84a                	sd	s2,16(sp)
    80004412:	1800                	addi	s0,sp,48
    80004414:	892e                	mv	s2,a1
    80004416:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004418:	fdc40593          	addi	a1,s0,-36
    8000441c:	ffffe097          	auipc	ra,0xffffe
    80004420:	b28080e7          	jalr	-1240(ra) # 80001f44 <argint>
    80004424:	04054063          	bltz	a0,80004464 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004428:	fdc42703          	lw	a4,-36(s0)
    8000442c:	47bd                	li	a5,15
    8000442e:	02e7ed63          	bltu	a5,a4,80004468 <argfd+0x60>
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	a12080e7          	jalr	-1518(ra) # 80000e44 <myproc>
    8000443a:	fdc42703          	lw	a4,-36(s0)
    8000443e:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    80004442:	078e                	slli	a5,a5,0x3
    80004444:	953e                	add	a0,a0,a5
    80004446:	611c                	ld	a5,0(a0)
    80004448:	c395                	beqz	a5,8000446c <argfd+0x64>
    return -1;
  if(pfd)
    8000444a:	00090463          	beqz	s2,80004452 <argfd+0x4a>
    *pfd = fd;
    8000444e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004452:	4501                	li	a0,0
  if(pf)
    80004454:	c091                	beqz	s1,80004458 <argfd+0x50>
    *pf = f;
    80004456:	e09c                	sd	a5,0(s1)
}
    80004458:	70a2                	ld	ra,40(sp)
    8000445a:	7402                	ld	s0,32(sp)
    8000445c:	64e2                	ld	s1,24(sp)
    8000445e:	6942                	ld	s2,16(sp)
    80004460:	6145                	addi	sp,sp,48
    80004462:	8082                	ret
    return -1;
    80004464:	557d                	li	a0,-1
    80004466:	bfcd                	j	80004458 <argfd+0x50>
    return -1;
    80004468:	557d                	li	a0,-1
    8000446a:	b7fd                	j	80004458 <argfd+0x50>
    8000446c:	557d                	li	a0,-1
    8000446e:	b7ed                	j	80004458 <argfd+0x50>

0000000080004470 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004470:	1101                	addi	sp,sp,-32
    80004472:	ec06                	sd	ra,24(sp)
    80004474:	e822                	sd	s0,16(sp)
    80004476:	e426                	sd	s1,8(sp)
    80004478:	1000                	addi	s0,sp,32
    8000447a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000447c:	ffffd097          	auipc	ra,0xffffd
    80004480:	9c8080e7          	jalr	-1592(ra) # 80000e44 <myproc>
    80004484:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004486:	0d050793          	addi	a5,a0,208
    8000448a:	4501                	li	a0,0
    8000448c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000448e:	6398                	ld	a4,0(a5)
    80004490:	cb19                	beqz	a4,800044a6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004492:	2505                	addiw	a0,a0,1
    80004494:	07a1                	addi	a5,a5,8
    80004496:	fed51ce3          	bne	a0,a3,8000448e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000449a:	557d                	li	a0,-1
}
    8000449c:	60e2                	ld	ra,24(sp)
    8000449e:	6442                	ld	s0,16(sp)
    800044a0:	64a2                	ld	s1,8(sp)
    800044a2:	6105                	addi	sp,sp,32
    800044a4:	8082                	ret
      p->ofile[fd] = f;
    800044a6:	01a50793          	addi	a5,a0,26
    800044aa:	078e                	slli	a5,a5,0x3
    800044ac:	963e                	add	a2,a2,a5
    800044ae:	e204                	sd	s1,0(a2)
      return fd;
    800044b0:	b7f5                	j	8000449c <fdalloc+0x2c>

00000000800044b2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044b2:	715d                	addi	sp,sp,-80
    800044b4:	e486                	sd	ra,72(sp)
    800044b6:	e0a2                	sd	s0,64(sp)
    800044b8:	fc26                	sd	s1,56(sp)
    800044ba:	f84a                	sd	s2,48(sp)
    800044bc:	f44e                	sd	s3,40(sp)
    800044be:	f052                	sd	s4,32(sp)
    800044c0:	ec56                	sd	s5,24(sp)
    800044c2:	0880                	addi	s0,sp,80
    800044c4:	89ae                	mv	s3,a1
    800044c6:	8ab2                	mv	s5,a2
    800044c8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044ca:	fb040593          	addi	a1,s0,-80
    800044ce:	fffff097          	auipc	ra,0xfffff
    800044d2:	e74080e7          	jalr	-396(ra) # 80003342 <nameiparent>
    800044d6:	892a                	mv	s2,a0
    800044d8:	12050e63          	beqz	a0,80004614 <create+0x162>
    return 0;

  ilock(dp);
    800044dc:	ffffe097          	auipc	ra,0xffffe
    800044e0:	68c080e7          	jalr	1676(ra) # 80002b68 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044e4:	4601                	li	a2,0
    800044e6:	fb040593          	addi	a1,s0,-80
    800044ea:	854a                	mv	a0,s2
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	b60080e7          	jalr	-1184(ra) # 8000304c <dirlookup>
    800044f4:	84aa                	mv	s1,a0
    800044f6:	c921                	beqz	a0,80004546 <create+0x94>
    iunlockput(dp);
    800044f8:	854a                	mv	a0,s2
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	8d0080e7          	jalr	-1840(ra) # 80002dca <iunlockput>
    ilock(ip);
    80004502:	8526                	mv	a0,s1
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	664080e7          	jalr	1636(ra) # 80002b68 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000450c:	2981                	sext.w	s3,s3
    8000450e:	4789                	li	a5,2
    80004510:	02f99463          	bne	s3,a5,80004538 <create+0x86>
    80004514:	0444d783          	lhu	a5,68(s1)
    80004518:	37f9                	addiw	a5,a5,-2
    8000451a:	17c2                	slli	a5,a5,0x30
    8000451c:	93c1                	srli	a5,a5,0x30
    8000451e:	4705                	li	a4,1
    80004520:	00f76c63          	bltu	a4,a5,80004538 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004524:	8526                	mv	a0,s1
    80004526:	60a6                	ld	ra,72(sp)
    80004528:	6406                	ld	s0,64(sp)
    8000452a:	74e2                	ld	s1,56(sp)
    8000452c:	7942                	ld	s2,48(sp)
    8000452e:	79a2                	ld	s3,40(sp)
    80004530:	7a02                	ld	s4,32(sp)
    80004532:	6ae2                	ld	s5,24(sp)
    80004534:	6161                	addi	sp,sp,80
    80004536:	8082                	ret
    iunlockput(ip);
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	890080e7          	jalr	-1904(ra) # 80002dca <iunlockput>
    return 0;
    80004542:	4481                	li	s1,0
    80004544:	b7c5                	j	80004524 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004546:	85ce                	mv	a1,s3
    80004548:	00092503          	lw	a0,0(s2)
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	482080e7          	jalr	1154(ra) # 800029ce <ialloc>
    80004554:	84aa                	mv	s1,a0
    80004556:	c521                	beqz	a0,8000459e <create+0xec>
  ilock(ip);
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	610080e7          	jalr	1552(ra) # 80002b68 <ilock>
  ip->major = major;
    80004560:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004564:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004568:	4a05                	li	s4,1
    8000456a:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000456e:	8526                	mv	a0,s1
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	52c080e7          	jalr	1324(ra) # 80002a9c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004578:	2981                	sext.w	s3,s3
    8000457a:	03498a63          	beq	s3,s4,800045ae <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000457e:	40d0                	lw	a2,4(s1)
    80004580:	fb040593          	addi	a1,s0,-80
    80004584:	854a                	mv	a0,s2
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	cdc080e7          	jalr	-804(ra) # 80003262 <dirlink>
    8000458e:	06054b63          	bltz	a0,80004604 <create+0x152>
  iunlockput(dp);
    80004592:	854a                	mv	a0,s2
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	836080e7          	jalr	-1994(ra) # 80002dca <iunlockput>
  return ip;
    8000459c:	b761                	j	80004524 <create+0x72>
    panic("create: ialloc");
    8000459e:	00004517          	auipc	a0,0x4
    800045a2:	0da50513          	addi	a0,a0,218 # 80008678 <syscalls+0x2b0>
    800045a6:	00001097          	auipc	ra,0x1
    800045aa:	6c8080e7          	jalr	1736(ra) # 80005c6e <panic>
    dp->nlink++;  // for ".."
    800045ae:	04a95783          	lhu	a5,74(s2)
    800045b2:	2785                	addiw	a5,a5,1
    800045b4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045b8:	854a                	mv	a0,s2
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	4e2080e7          	jalr	1250(ra) # 80002a9c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045c2:	40d0                	lw	a2,4(s1)
    800045c4:	00004597          	auipc	a1,0x4
    800045c8:	0c458593          	addi	a1,a1,196 # 80008688 <syscalls+0x2c0>
    800045cc:	8526                	mv	a0,s1
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	c94080e7          	jalr	-876(ra) # 80003262 <dirlink>
    800045d6:	00054f63          	bltz	a0,800045f4 <create+0x142>
    800045da:	00492603          	lw	a2,4(s2)
    800045de:	00004597          	auipc	a1,0x4
    800045e2:	0b258593          	addi	a1,a1,178 # 80008690 <syscalls+0x2c8>
    800045e6:	8526                	mv	a0,s1
    800045e8:	fffff097          	auipc	ra,0xfffff
    800045ec:	c7a080e7          	jalr	-902(ra) # 80003262 <dirlink>
    800045f0:	f80557e3          	bgez	a0,8000457e <create+0xcc>
      panic("create dots");
    800045f4:	00004517          	auipc	a0,0x4
    800045f8:	0a450513          	addi	a0,a0,164 # 80008698 <syscalls+0x2d0>
    800045fc:	00001097          	auipc	ra,0x1
    80004600:	672080e7          	jalr	1650(ra) # 80005c6e <panic>
    panic("create: dirlink");
    80004604:	00004517          	auipc	a0,0x4
    80004608:	0a450513          	addi	a0,a0,164 # 800086a8 <syscalls+0x2e0>
    8000460c:	00001097          	auipc	ra,0x1
    80004610:	662080e7          	jalr	1634(ra) # 80005c6e <panic>
    return 0;
    80004614:	84aa                	mv	s1,a0
    80004616:	b739                	j	80004524 <create+0x72>

0000000080004618 <sys_dup>:
{
    80004618:	7179                	addi	sp,sp,-48
    8000461a:	f406                	sd	ra,40(sp)
    8000461c:	f022                	sd	s0,32(sp)
    8000461e:	ec26                	sd	s1,24(sp)
    80004620:	e84a                	sd	s2,16(sp)
    80004622:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004624:	fd840613          	addi	a2,s0,-40
    80004628:	4581                	li	a1,0
    8000462a:	4501                	li	a0,0
    8000462c:	00000097          	auipc	ra,0x0
    80004630:	ddc080e7          	jalr	-548(ra) # 80004408 <argfd>
    return -1;
    80004634:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004636:	02054363          	bltz	a0,8000465c <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000463a:	fd843903          	ld	s2,-40(s0)
    8000463e:	854a                	mv	a0,s2
    80004640:	00000097          	auipc	ra,0x0
    80004644:	e30080e7          	jalr	-464(ra) # 80004470 <fdalloc>
    80004648:	84aa                	mv	s1,a0
    return -1;
    8000464a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000464c:	00054863          	bltz	a0,8000465c <sys_dup+0x44>
  filedup(f);
    80004650:	854a                	mv	a0,s2
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	368080e7          	jalr	872(ra) # 800039ba <filedup>
  return fd;
    8000465a:	87a6                	mv	a5,s1
}
    8000465c:	853e                	mv	a0,a5
    8000465e:	70a2                	ld	ra,40(sp)
    80004660:	7402                	ld	s0,32(sp)
    80004662:	64e2                	ld	s1,24(sp)
    80004664:	6942                	ld	s2,16(sp)
    80004666:	6145                	addi	sp,sp,48
    80004668:	8082                	ret

000000008000466a <sys_read>:
{
    8000466a:	7179                	addi	sp,sp,-48
    8000466c:	f406                	sd	ra,40(sp)
    8000466e:	f022                	sd	s0,32(sp)
    80004670:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004672:	fe840613          	addi	a2,s0,-24
    80004676:	4581                	li	a1,0
    80004678:	4501                	li	a0,0
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	d8e080e7          	jalr	-626(ra) # 80004408 <argfd>
    return -1;
    80004682:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004684:	04054163          	bltz	a0,800046c6 <sys_read+0x5c>
    80004688:	fe440593          	addi	a1,s0,-28
    8000468c:	4509                	li	a0,2
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	8b6080e7          	jalr	-1866(ra) # 80001f44 <argint>
    return -1;
    80004696:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004698:	02054763          	bltz	a0,800046c6 <sys_read+0x5c>
    8000469c:	fd840593          	addi	a1,s0,-40
    800046a0:	4505                	li	a0,1
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	8c4080e7          	jalr	-1852(ra) # 80001f66 <argaddr>
    return -1;
    800046aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ac:	00054d63          	bltz	a0,800046c6 <sys_read+0x5c>
  return fileread(f, p, n);
    800046b0:	fe442603          	lw	a2,-28(s0)
    800046b4:	fd843583          	ld	a1,-40(s0)
    800046b8:	fe843503          	ld	a0,-24(s0)
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	48a080e7          	jalr	1162(ra) # 80003b46 <fileread>
    800046c4:	87aa                	mv	a5,a0
}
    800046c6:	853e                	mv	a0,a5
    800046c8:	70a2                	ld	ra,40(sp)
    800046ca:	7402                	ld	s0,32(sp)
    800046cc:	6145                	addi	sp,sp,48
    800046ce:	8082                	ret

00000000800046d0 <sys_write>:
{
    800046d0:	7179                	addi	sp,sp,-48
    800046d2:	f406                	sd	ra,40(sp)
    800046d4:	f022                	sd	s0,32(sp)
    800046d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d8:	fe840613          	addi	a2,s0,-24
    800046dc:	4581                	li	a1,0
    800046de:	4501                	li	a0,0
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	d28080e7          	jalr	-728(ra) # 80004408 <argfd>
    return -1;
    800046e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ea:	04054163          	bltz	a0,8000472c <sys_write+0x5c>
    800046ee:	fe440593          	addi	a1,s0,-28
    800046f2:	4509                	li	a0,2
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	850080e7          	jalr	-1968(ra) # 80001f44 <argint>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	02054763          	bltz	a0,8000472c <sys_write+0x5c>
    80004702:	fd840593          	addi	a1,s0,-40
    80004706:	4505                	li	a0,1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	85e080e7          	jalr	-1954(ra) # 80001f66 <argaddr>
    return -1;
    80004710:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004712:	00054d63          	bltz	a0,8000472c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004716:	fe442603          	lw	a2,-28(s0)
    8000471a:	fd843583          	ld	a1,-40(s0)
    8000471e:	fe843503          	ld	a0,-24(s0)
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	4e6080e7          	jalr	1254(ra) # 80003c08 <filewrite>
    8000472a:	87aa                	mv	a5,a0
}
    8000472c:	853e                	mv	a0,a5
    8000472e:	70a2                	ld	ra,40(sp)
    80004730:	7402                	ld	s0,32(sp)
    80004732:	6145                	addi	sp,sp,48
    80004734:	8082                	ret

0000000080004736 <sys_close>:
{
    80004736:	1101                	addi	sp,sp,-32
    80004738:	ec06                	sd	ra,24(sp)
    8000473a:	e822                	sd	s0,16(sp)
    8000473c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000473e:	fe040613          	addi	a2,s0,-32
    80004742:	fec40593          	addi	a1,s0,-20
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	cc0080e7          	jalr	-832(ra) # 80004408 <argfd>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004752:	02054463          	bltz	a0,8000477a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004756:	ffffc097          	auipc	ra,0xffffc
    8000475a:	6ee080e7          	jalr	1774(ra) # 80000e44 <myproc>
    8000475e:	fec42783          	lw	a5,-20(s0)
    80004762:	07e9                	addi	a5,a5,26
    80004764:	078e                	slli	a5,a5,0x3
    80004766:	953e                	add	a0,a0,a5
    80004768:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000476c:	fe043503          	ld	a0,-32(s0)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	29c080e7          	jalr	668(ra) # 80003a0c <fileclose>
  return 0;
    80004778:	4781                	li	a5,0
}
    8000477a:	853e                	mv	a0,a5
    8000477c:	60e2                	ld	ra,24(sp)
    8000477e:	6442                	ld	s0,16(sp)
    80004780:	6105                	addi	sp,sp,32
    80004782:	8082                	ret

0000000080004784 <sys_fstat>:
{
    80004784:	1101                	addi	sp,sp,-32
    80004786:	ec06                	sd	ra,24(sp)
    80004788:	e822                	sd	s0,16(sp)
    8000478a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000478c:	fe840613          	addi	a2,s0,-24
    80004790:	4581                	li	a1,0
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	c74080e7          	jalr	-908(ra) # 80004408 <argfd>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000479e:	02054563          	bltz	a0,800047c8 <sys_fstat+0x44>
    800047a2:	fe040593          	addi	a1,s0,-32
    800047a6:	4505                	li	a0,1
    800047a8:	ffffd097          	auipc	ra,0xffffd
    800047ac:	7be080e7          	jalr	1982(ra) # 80001f66 <argaddr>
    return -1;
    800047b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b2:	00054b63          	bltz	a0,800047c8 <sys_fstat+0x44>
  return filestat(f, st);
    800047b6:	fe043583          	ld	a1,-32(s0)
    800047ba:	fe843503          	ld	a0,-24(s0)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	316080e7          	jalr	790(ra) # 80003ad4 <filestat>
    800047c6:	87aa                	mv	a5,a0
}
    800047c8:	853e                	mv	a0,a5
    800047ca:	60e2                	ld	ra,24(sp)
    800047cc:	6442                	ld	s0,16(sp)
    800047ce:	6105                	addi	sp,sp,32
    800047d0:	8082                	ret

00000000800047d2 <sys_link>:
{
    800047d2:	7169                	addi	sp,sp,-304
    800047d4:	f606                	sd	ra,296(sp)
    800047d6:	f222                	sd	s0,288(sp)
    800047d8:	ee26                	sd	s1,280(sp)
    800047da:	ea4a                	sd	s2,272(sp)
    800047dc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047de:	08000613          	li	a2,128
    800047e2:	ed040593          	addi	a1,s0,-304
    800047e6:	4501                	li	a0,0
    800047e8:	ffffd097          	auipc	ra,0xffffd
    800047ec:	7a0080e7          	jalr	1952(ra) # 80001f88 <argstr>
    return -1;
    800047f0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f2:	10054e63          	bltz	a0,8000490e <sys_link+0x13c>
    800047f6:	08000613          	li	a2,128
    800047fa:	f5040593          	addi	a1,s0,-176
    800047fe:	4505                	li	a0,1
    80004800:	ffffd097          	auipc	ra,0xffffd
    80004804:	788080e7          	jalr	1928(ra) # 80001f88 <argstr>
    return -1;
    80004808:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000480a:	10054263          	bltz	a0,8000490e <sys_link+0x13c>
  begin_op();
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	d36080e7          	jalr	-714(ra) # 80003544 <begin_op>
  if((ip = namei(old)) == 0){
    80004816:	ed040513          	addi	a0,s0,-304
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	b0a080e7          	jalr	-1270(ra) # 80003324 <namei>
    80004822:	84aa                	mv	s1,a0
    80004824:	c551                	beqz	a0,800048b0 <sys_link+0xde>
  ilock(ip);
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	342080e7          	jalr	834(ra) # 80002b68 <ilock>
  if(ip->type == T_DIR){
    8000482e:	04449703          	lh	a4,68(s1)
    80004832:	4785                	li	a5,1
    80004834:	08f70463          	beq	a4,a5,800048bc <sys_link+0xea>
  ip->nlink++;
    80004838:	04a4d783          	lhu	a5,74(s1)
    8000483c:	2785                	addiw	a5,a5,1
    8000483e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004842:	8526                	mv	a0,s1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	258080e7          	jalr	600(ra) # 80002a9c <iupdate>
  iunlock(ip);
    8000484c:	8526                	mv	a0,s1
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	3dc080e7          	jalr	988(ra) # 80002c2a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004856:	fd040593          	addi	a1,s0,-48
    8000485a:	f5040513          	addi	a0,s0,-176
    8000485e:	fffff097          	auipc	ra,0xfffff
    80004862:	ae4080e7          	jalr	-1308(ra) # 80003342 <nameiparent>
    80004866:	892a                	mv	s2,a0
    80004868:	c935                	beqz	a0,800048dc <sys_link+0x10a>
  ilock(dp);
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	2fe080e7          	jalr	766(ra) # 80002b68 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004872:	00092703          	lw	a4,0(s2)
    80004876:	409c                	lw	a5,0(s1)
    80004878:	04f71d63          	bne	a4,a5,800048d2 <sys_link+0x100>
    8000487c:	40d0                	lw	a2,4(s1)
    8000487e:	fd040593          	addi	a1,s0,-48
    80004882:	854a                	mv	a0,s2
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	9de080e7          	jalr	-1570(ra) # 80003262 <dirlink>
    8000488c:	04054363          	bltz	a0,800048d2 <sys_link+0x100>
  iunlockput(dp);
    80004890:	854a                	mv	a0,s2
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	538080e7          	jalr	1336(ra) # 80002dca <iunlockput>
  iput(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	486080e7          	jalr	1158(ra) # 80002d22 <iput>
  end_op();
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	d1e080e7          	jalr	-738(ra) # 800035c2 <end_op>
  return 0;
    800048ac:	4781                	li	a5,0
    800048ae:	a085                	j	8000490e <sys_link+0x13c>
    end_op();
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	d12080e7          	jalr	-750(ra) # 800035c2 <end_op>
    return -1;
    800048b8:	57fd                	li	a5,-1
    800048ba:	a891                	j	8000490e <sys_link+0x13c>
    iunlockput(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	50c080e7          	jalr	1292(ra) # 80002dca <iunlockput>
    end_op();
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	cfc080e7          	jalr	-772(ra) # 800035c2 <end_op>
    return -1;
    800048ce:	57fd                	li	a5,-1
    800048d0:	a83d                	j	8000490e <sys_link+0x13c>
    iunlockput(dp);
    800048d2:	854a                	mv	a0,s2
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	4f6080e7          	jalr	1270(ra) # 80002dca <iunlockput>
  ilock(ip);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	28a080e7          	jalr	650(ra) # 80002b68 <ilock>
  ip->nlink--;
    800048e6:	04a4d783          	lhu	a5,74(s1)
    800048ea:	37fd                	addiw	a5,a5,-1
    800048ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	1aa080e7          	jalr	426(ra) # 80002a9c <iupdate>
  iunlockput(ip);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	4ce080e7          	jalr	1230(ra) # 80002dca <iunlockput>
  end_op();
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	cbe080e7          	jalr	-834(ra) # 800035c2 <end_op>
  return -1;
    8000490c:	57fd                	li	a5,-1
}
    8000490e:	853e                	mv	a0,a5
    80004910:	70b2                	ld	ra,296(sp)
    80004912:	7412                	ld	s0,288(sp)
    80004914:	64f2                	ld	s1,280(sp)
    80004916:	6952                	ld	s2,272(sp)
    80004918:	6155                	addi	sp,sp,304
    8000491a:	8082                	ret

000000008000491c <sys_unlink>:
{
    8000491c:	7151                	addi	sp,sp,-240
    8000491e:	f586                	sd	ra,232(sp)
    80004920:	f1a2                	sd	s0,224(sp)
    80004922:	eda6                	sd	s1,216(sp)
    80004924:	e9ca                	sd	s2,208(sp)
    80004926:	e5ce                	sd	s3,200(sp)
    80004928:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000492a:	08000613          	li	a2,128
    8000492e:	f3040593          	addi	a1,s0,-208
    80004932:	4501                	li	a0,0
    80004934:	ffffd097          	auipc	ra,0xffffd
    80004938:	654080e7          	jalr	1620(ra) # 80001f88 <argstr>
    8000493c:	18054163          	bltz	a0,80004abe <sys_unlink+0x1a2>
  begin_op();
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	c04080e7          	jalr	-1020(ra) # 80003544 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004948:	fb040593          	addi	a1,s0,-80
    8000494c:	f3040513          	addi	a0,s0,-208
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	9f2080e7          	jalr	-1550(ra) # 80003342 <nameiparent>
    80004958:	84aa                	mv	s1,a0
    8000495a:	c979                	beqz	a0,80004a30 <sys_unlink+0x114>
  ilock(dp);
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	20c080e7          	jalr	524(ra) # 80002b68 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004964:	00004597          	auipc	a1,0x4
    80004968:	d2458593          	addi	a1,a1,-732 # 80008688 <syscalls+0x2c0>
    8000496c:	fb040513          	addi	a0,s0,-80
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	6c2080e7          	jalr	1730(ra) # 80003032 <namecmp>
    80004978:	14050a63          	beqz	a0,80004acc <sys_unlink+0x1b0>
    8000497c:	00004597          	auipc	a1,0x4
    80004980:	d1458593          	addi	a1,a1,-748 # 80008690 <syscalls+0x2c8>
    80004984:	fb040513          	addi	a0,s0,-80
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	6aa080e7          	jalr	1706(ra) # 80003032 <namecmp>
    80004990:	12050e63          	beqz	a0,80004acc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004994:	f2c40613          	addi	a2,s0,-212
    80004998:	fb040593          	addi	a1,s0,-80
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	6ae080e7          	jalr	1710(ra) # 8000304c <dirlookup>
    800049a6:	892a                	mv	s2,a0
    800049a8:	12050263          	beqz	a0,80004acc <sys_unlink+0x1b0>
  ilock(ip);
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	1bc080e7          	jalr	444(ra) # 80002b68 <ilock>
  if(ip->nlink < 1)
    800049b4:	04a91783          	lh	a5,74(s2)
    800049b8:	08f05263          	blez	a5,80004a3c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049bc:	04491703          	lh	a4,68(s2)
    800049c0:	4785                	li	a5,1
    800049c2:	08f70563          	beq	a4,a5,80004a4c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049c6:	4641                	li	a2,16
    800049c8:	4581                	li	a1,0
    800049ca:	fc040513          	addi	a0,s0,-64
    800049ce:	ffffb097          	auipc	ra,0xffffb
    800049d2:	7ac080e7          	jalr	1964(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049d6:	4741                	li	a4,16
    800049d8:	f2c42683          	lw	a3,-212(s0)
    800049dc:	fc040613          	addi	a2,s0,-64
    800049e0:	4581                	li	a1,0
    800049e2:	8526                	mv	a0,s1
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	530080e7          	jalr	1328(ra) # 80002f14 <writei>
    800049ec:	47c1                	li	a5,16
    800049ee:	0af51563          	bne	a0,a5,80004a98 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049f2:	04491703          	lh	a4,68(s2)
    800049f6:	4785                	li	a5,1
    800049f8:	0af70863          	beq	a4,a5,80004aa8 <sys_unlink+0x18c>
  iunlockput(dp);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	3cc080e7          	jalr	972(ra) # 80002dca <iunlockput>
  ip->nlink--;
    80004a06:	04a95783          	lhu	a5,74(s2)
    80004a0a:	37fd                	addiw	a5,a5,-1
    80004a0c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a10:	854a                	mv	a0,s2
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	08a080e7          	jalr	138(ra) # 80002a9c <iupdate>
  iunlockput(ip);
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	3ae080e7          	jalr	942(ra) # 80002dca <iunlockput>
  end_op();
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	b9e080e7          	jalr	-1122(ra) # 800035c2 <end_op>
  return 0;
    80004a2c:	4501                	li	a0,0
    80004a2e:	a84d                	j	80004ae0 <sys_unlink+0x1c4>
    end_op();
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	b92080e7          	jalr	-1134(ra) # 800035c2 <end_op>
    return -1;
    80004a38:	557d                	li	a0,-1
    80004a3a:	a05d                	j	80004ae0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a3c:	00004517          	auipc	a0,0x4
    80004a40:	c7c50513          	addi	a0,a0,-900 # 800086b8 <syscalls+0x2f0>
    80004a44:	00001097          	auipc	ra,0x1
    80004a48:	22a080e7          	jalr	554(ra) # 80005c6e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a4c:	04c92703          	lw	a4,76(s2)
    80004a50:	02000793          	li	a5,32
    80004a54:	f6e7f9e3          	bgeu	a5,a4,800049c6 <sys_unlink+0xaa>
    80004a58:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a5c:	4741                	li	a4,16
    80004a5e:	86ce                	mv	a3,s3
    80004a60:	f1840613          	addi	a2,s0,-232
    80004a64:	4581                	li	a1,0
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	3b4080e7          	jalr	948(ra) # 80002e1c <readi>
    80004a70:	47c1                	li	a5,16
    80004a72:	00f51b63          	bne	a0,a5,80004a88 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a76:	f1845783          	lhu	a5,-232(s0)
    80004a7a:	e7a1                	bnez	a5,80004ac2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a7c:	29c1                	addiw	s3,s3,16
    80004a7e:	04c92783          	lw	a5,76(s2)
    80004a82:	fcf9ede3          	bltu	s3,a5,80004a5c <sys_unlink+0x140>
    80004a86:	b781                	j	800049c6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a88:	00004517          	auipc	a0,0x4
    80004a8c:	c4850513          	addi	a0,a0,-952 # 800086d0 <syscalls+0x308>
    80004a90:	00001097          	auipc	ra,0x1
    80004a94:	1de080e7          	jalr	478(ra) # 80005c6e <panic>
    panic("unlink: writei");
    80004a98:	00004517          	auipc	a0,0x4
    80004a9c:	c5050513          	addi	a0,a0,-944 # 800086e8 <syscalls+0x320>
    80004aa0:	00001097          	auipc	ra,0x1
    80004aa4:	1ce080e7          	jalr	462(ra) # 80005c6e <panic>
    dp->nlink--;
    80004aa8:	04a4d783          	lhu	a5,74(s1)
    80004aac:	37fd                	addiw	a5,a5,-1
    80004aae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	fe8080e7          	jalr	-24(ra) # 80002a9c <iupdate>
    80004abc:	b781                	j	800049fc <sys_unlink+0xe0>
    return -1;
    80004abe:	557d                	li	a0,-1
    80004ac0:	a005                	j	80004ae0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	306080e7          	jalr	774(ra) # 80002dca <iunlockput>
  iunlockput(dp);
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	2fc080e7          	jalr	764(ra) # 80002dca <iunlockput>
  end_op();
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	aec080e7          	jalr	-1300(ra) # 800035c2 <end_op>
  return -1;
    80004ade:	557d                	li	a0,-1
}
    80004ae0:	70ae                	ld	ra,232(sp)
    80004ae2:	740e                	ld	s0,224(sp)
    80004ae4:	64ee                	ld	s1,216(sp)
    80004ae6:	694e                	ld	s2,208(sp)
    80004ae8:	69ae                	ld	s3,200(sp)
    80004aea:	616d                	addi	sp,sp,240
    80004aec:	8082                	ret

0000000080004aee <sys_open>:

uint64
sys_open(void)
{
    80004aee:	7131                	addi	sp,sp,-192
    80004af0:	fd06                	sd	ra,184(sp)
    80004af2:	f922                	sd	s0,176(sp)
    80004af4:	f526                	sd	s1,168(sp)
    80004af6:	f14a                	sd	s2,160(sp)
    80004af8:	ed4e                	sd	s3,152(sp)
    80004afa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004afc:	08000613          	li	a2,128
    80004b00:	f5040593          	addi	a1,s0,-176
    80004b04:	4501                	li	a0,0
    80004b06:	ffffd097          	auipc	ra,0xffffd
    80004b0a:	482080e7          	jalr	1154(ra) # 80001f88 <argstr>
    return -1;
    80004b0e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b10:	0c054163          	bltz	a0,80004bd2 <sys_open+0xe4>
    80004b14:	f4c40593          	addi	a1,s0,-180
    80004b18:	4505                	li	a0,1
    80004b1a:	ffffd097          	auipc	ra,0xffffd
    80004b1e:	42a080e7          	jalr	1066(ra) # 80001f44 <argint>
    80004b22:	0a054863          	bltz	a0,80004bd2 <sys_open+0xe4>

  begin_op();
    80004b26:	fffff097          	auipc	ra,0xfffff
    80004b2a:	a1e080e7          	jalr	-1506(ra) # 80003544 <begin_op>

  if(omode & O_CREATE){
    80004b2e:	f4c42783          	lw	a5,-180(s0)
    80004b32:	2007f793          	andi	a5,a5,512
    80004b36:	cbdd                	beqz	a5,80004bec <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b38:	4681                	li	a3,0
    80004b3a:	4601                	li	a2,0
    80004b3c:	4589                	li	a1,2
    80004b3e:	f5040513          	addi	a0,s0,-176
    80004b42:	00000097          	auipc	ra,0x0
    80004b46:	970080e7          	jalr	-1680(ra) # 800044b2 <create>
    80004b4a:	892a                	mv	s2,a0
    if(ip == 0){
    80004b4c:	c959                	beqz	a0,80004be2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	478d                	li	a5,3
    80004b54:	00f71763          	bne	a4,a5,80004b62 <sys_open+0x74>
    80004b58:	04695703          	lhu	a4,70(s2)
    80004b5c:	47a5                	li	a5,9
    80004b5e:	0ce7ec63          	bltu	a5,a4,80004c36 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	dee080e7          	jalr	-530(ra) # 80003950 <filealloc>
    80004b6a:	89aa                	mv	s3,a0
    80004b6c:	10050263          	beqz	a0,80004c70 <sys_open+0x182>
    80004b70:	00000097          	auipc	ra,0x0
    80004b74:	900080e7          	jalr	-1792(ra) # 80004470 <fdalloc>
    80004b78:	84aa                	mv	s1,a0
    80004b7a:	0e054663          	bltz	a0,80004c66 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b7e:	04491703          	lh	a4,68(s2)
    80004b82:	478d                	li	a5,3
    80004b84:	0cf70463          	beq	a4,a5,80004c4c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b88:	4789                	li	a5,2
    80004b8a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b8e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b92:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b96:	f4c42783          	lw	a5,-180(s0)
    80004b9a:	0017c713          	xori	a4,a5,1
    80004b9e:	8b05                	andi	a4,a4,1
    80004ba0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ba4:	0037f713          	andi	a4,a5,3
    80004ba8:	00e03733          	snez	a4,a4
    80004bac:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bb0:	4007f793          	andi	a5,a5,1024
    80004bb4:	c791                	beqz	a5,80004bc0 <sys_open+0xd2>
    80004bb6:	04491703          	lh	a4,68(s2)
    80004bba:	4789                	li	a5,2
    80004bbc:	08f70f63          	beq	a4,a5,80004c5a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bc0:	854a                	mv	a0,s2
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	068080e7          	jalr	104(ra) # 80002c2a <iunlock>
  end_op();
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	9f8080e7          	jalr	-1544(ra) # 800035c2 <end_op>

  return fd;
}
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	70ea                	ld	ra,184(sp)
    80004bd6:	744a                	ld	s0,176(sp)
    80004bd8:	74aa                	ld	s1,168(sp)
    80004bda:	790a                	ld	s2,160(sp)
    80004bdc:	69ea                	ld	s3,152(sp)
    80004bde:	6129                	addi	sp,sp,192
    80004be0:	8082                	ret
      end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	9e0080e7          	jalr	-1568(ra) # 800035c2 <end_op>
      return -1;
    80004bea:	b7e5                	j	80004bd2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bec:	f5040513          	addi	a0,s0,-176
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	734080e7          	jalr	1844(ra) # 80003324 <namei>
    80004bf8:	892a                	mv	s2,a0
    80004bfa:	c905                	beqz	a0,80004c2a <sys_open+0x13c>
    ilock(ip);
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	f6c080e7          	jalr	-148(ra) # 80002b68 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c04:	04491703          	lh	a4,68(s2)
    80004c08:	4785                	li	a5,1
    80004c0a:	f4f712e3          	bne	a4,a5,80004b4e <sys_open+0x60>
    80004c0e:	f4c42783          	lw	a5,-180(s0)
    80004c12:	dba1                	beqz	a5,80004b62 <sys_open+0x74>
      iunlockput(ip);
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	1b4080e7          	jalr	436(ra) # 80002dca <iunlockput>
      end_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	9a4080e7          	jalr	-1628(ra) # 800035c2 <end_op>
      return -1;
    80004c26:	54fd                	li	s1,-1
    80004c28:	b76d                	j	80004bd2 <sys_open+0xe4>
      end_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	998080e7          	jalr	-1640(ra) # 800035c2 <end_op>
      return -1;
    80004c32:	54fd                	li	s1,-1
    80004c34:	bf79                	j	80004bd2 <sys_open+0xe4>
    iunlockput(ip);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	192080e7          	jalr	402(ra) # 80002dca <iunlockput>
    end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	982080e7          	jalr	-1662(ra) # 800035c2 <end_op>
    return -1;
    80004c48:	54fd                	li	s1,-1
    80004c4a:	b761                	j	80004bd2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c4c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c50:	04691783          	lh	a5,70(s2)
    80004c54:	02f99223          	sh	a5,36(s3)
    80004c58:	bf2d                	j	80004b92 <sys_open+0xa4>
    itrunc(ip);
    80004c5a:	854a                	mv	a0,s2
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	01a080e7          	jalr	26(ra) # 80002c76 <itrunc>
    80004c64:	bfb1                	j	80004bc0 <sys_open+0xd2>
      fileclose(f);
    80004c66:	854e                	mv	a0,s3
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	da4080e7          	jalr	-604(ra) # 80003a0c <fileclose>
    iunlockput(ip);
    80004c70:	854a                	mv	a0,s2
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	158080e7          	jalr	344(ra) # 80002dca <iunlockput>
    end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	948080e7          	jalr	-1720(ra) # 800035c2 <end_op>
    return -1;
    80004c82:	54fd                	li	s1,-1
    80004c84:	b7b9                	j	80004bd2 <sys_open+0xe4>

0000000080004c86 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c86:	7175                	addi	sp,sp,-144
    80004c88:	e506                	sd	ra,136(sp)
    80004c8a:	e122                	sd	s0,128(sp)
    80004c8c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	8b6080e7          	jalr	-1866(ra) # 80003544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c96:	08000613          	li	a2,128
    80004c9a:	f7040593          	addi	a1,s0,-144
    80004c9e:	4501                	li	a0,0
    80004ca0:	ffffd097          	auipc	ra,0xffffd
    80004ca4:	2e8080e7          	jalr	744(ra) # 80001f88 <argstr>
    80004ca8:	02054963          	bltz	a0,80004cda <sys_mkdir+0x54>
    80004cac:	4681                	li	a3,0
    80004cae:	4601                	li	a2,0
    80004cb0:	4585                	li	a1,1
    80004cb2:	f7040513          	addi	a0,s0,-144
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	7fc080e7          	jalr	2044(ra) # 800044b2 <create>
    80004cbe:	cd11                	beqz	a0,80004cda <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	10a080e7          	jalr	266(ra) # 80002dca <iunlockput>
  end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	8fa080e7          	jalr	-1798(ra) # 800035c2 <end_op>
  return 0;
    80004cd0:	4501                	li	a0,0
}
    80004cd2:	60aa                	ld	ra,136(sp)
    80004cd4:	640a                	ld	s0,128(sp)
    80004cd6:	6149                	addi	sp,sp,144
    80004cd8:	8082                	ret
    end_op();
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	8e8080e7          	jalr	-1816(ra) # 800035c2 <end_op>
    return -1;
    80004ce2:	557d                	li	a0,-1
    80004ce4:	b7fd                	j	80004cd2 <sys_mkdir+0x4c>

0000000080004ce6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ce6:	7135                	addi	sp,sp,-160
    80004ce8:	ed06                	sd	ra,152(sp)
    80004cea:	e922                	sd	s0,144(sp)
    80004cec:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	856080e7          	jalr	-1962(ra) # 80003544 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cf6:	08000613          	li	a2,128
    80004cfa:	f7040593          	addi	a1,s0,-144
    80004cfe:	4501                	li	a0,0
    80004d00:	ffffd097          	auipc	ra,0xffffd
    80004d04:	288080e7          	jalr	648(ra) # 80001f88 <argstr>
    80004d08:	04054a63          	bltz	a0,80004d5c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d0c:	f6c40593          	addi	a1,s0,-148
    80004d10:	4505                	li	a0,1
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	232080e7          	jalr	562(ra) # 80001f44 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d1a:	04054163          	bltz	a0,80004d5c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d1e:	f6840593          	addi	a1,s0,-152
    80004d22:	4509                	li	a0,2
    80004d24:	ffffd097          	auipc	ra,0xffffd
    80004d28:	220080e7          	jalr	544(ra) # 80001f44 <argint>
     argint(1, &major) < 0 ||
    80004d2c:	02054863          	bltz	a0,80004d5c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d30:	f6841683          	lh	a3,-152(s0)
    80004d34:	f6c41603          	lh	a2,-148(s0)
    80004d38:	458d                	li	a1,3
    80004d3a:	f7040513          	addi	a0,s0,-144
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	774080e7          	jalr	1908(ra) # 800044b2 <create>
     argint(2, &minor) < 0 ||
    80004d46:	c919                	beqz	a0,80004d5c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	082080e7          	jalr	130(ra) # 80002dca <iunlockput>
  end_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	872080e7          	jalr	-1934(ra) # 800035c2 <end_op>
  return 0;
    80004d58:	4501                	li	a0,0
    80004d5a:	a031                	j	80004d66 <sys_mknod+0x80>
    end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	866080e7          	jalr	-1946(ra) # 800035c2 <end_op>
    return -1;
    80004d64:	557d                	li	a0,-1
}
    80004d66:	60ea                	ld	ra,152(sp)
    80004d68:	644a                	ld	s0,144(sp)
    80004d6a:	610d                	addi	sp,sp,160
    80004d6c:	8082                	ret

0000000080004d6e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d6e:	7135                	addi	sp,sp,-160
    80004d70:	ed06                	sd	ra,152(sp)
    80004d72:	e922                	sd	s0,144(sp)
    80004d74:	e526                	sd	s1,136(sp)
    80004d76:	e14a                	sd	s2,128(sp)
    80004d78:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d7a:	ffffc097          	auipc	ra,0xffffc
    80004d7e:	0ca080e7          	jalr	202(ra) # 80000e44 <myproc>
    80004d82:	892a                	mv	s2,a0
  
  begin_op();
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	7c0080e7          	jalr	1984(ra) # 80003544 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d8c:	08000613          	li	a2,128
    80004d90:	f6040593          	addi	a1,s0,-160
    80004d94:	4501                	li	a0,0
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	1f2080e7          	jalr	498(ra) # 80001f88 <argstr>
    80004d9e:	04054b63          	bltz	a0,80004df4 <sys_chdir+0x86>
    80004da2:	f6040513          	addi	a0,s0,-160
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	57e080e7          	jalr	1406(ra) # 80003324 <namei>
    80004dae:	84aa                	mv	s1,a0
    80004db0:	c131                	beqz	a0,80004df4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	db6080e7          	jalr	-586(ra) # 80002b68 <ilock>
  if(ip->type != T_DIR){
    80004dba:	04449703          	lh	a4,68(s1)
    80004dbe:	4785                	li	a5,1
    80004dc0:	04f71063          	bne	a4,a5,80004e00 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	e64080e7          	jalr	-412(ra) # 80002c2a <iunlock>
  iput(p->cwd);
    80004dce:	15093503          	ld	a0,336(s2)
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	f50080e7          	jalr	-176(ra) # 80002d22 <iput>
  end_op();
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	7e8080e7          	jalr	2024(ra) # 800035c2 <end_op>
  p->cwd = ip;
    80004de2:	14993823          	sd	s1,336(s2)
  return 0;
    80004de6:	4501                	li	a0,0
}
    80004de8:	60ea                	ld	ra,152(sp)
    80004dea:	644a                	ld	s0,144(sp)
    80004dec:	64aa                	ld	s1,136(sp)
    80004dee:	690a                	ld	s2,128(sp)
    80004df0:	610d                	addi	sp,sp,160
    80004df2:	8082                	ret
    end_op();
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	7ce080e7          	jalr	1998(ra) # 800035c2 <end_op>
    return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	b7ed                	j	80004de8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e00:	8526                	mv	a0,s1
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	fc8080e7          	jalr	-56(ra) # 80002dca <iunlockput>
    end_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	7b8080e7          	jalr	1976(ra) # 800035c2 <end_op>
    return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	bfd1                	j	80004de8 <sys_chdir+0x7a>

0000000080004e16 <sys_exec>:

uint64
sys_exec(void)
{
    80004e16:	7145                	addi	sp,sp,-464
    80004e18:	e786                	sd	ra,456(sp)
    80004e1a:	e3a2                	sd	s0,448(sp)
    80004e1c:	ff26                	sd	s1,440(sp)
    80004e1e:	fb4a                	sd	s2,432(sp)
    80004e20:	f74e                	sd	s3,424(sp)
    80004e22:	f352                	sd	s4,416(sp)
    80004e24:	ef56                	sd	s5,408(sp)
    80004e26:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e28:	08000613          	li	a2,128
    80004e2c:	f4040593          	addi	a1,s0,-192
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	156080e7          	jalr	342(ra) # 80001f88 <argstr>
    return -1;
    80004e3a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e3c:	0c054b63          	bltz	a0,80004f12 <sys_exec+0xfc>
    80004e40:	e3840593          	addi	a1,s0,-456
    80004e44:	4505                	li	a0,1
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	120080e7          	jalr	288(ra) # 80001f66 <argaddr>
    80004e4e:	0c054263          	bltz	a0,80004f12 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e52:	10000613          	li	a2,256
    80004e56:	4581                	li	a1,0
    80004e58:	e4040513          	addi	a0,s0,-448
    80004e5c:	ffffb097          	auipc	ra,0xffffb
    80004e60:	31e080e7          	jalr	798(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e64:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e68:	89a6                	mv	s3,s1
    80004e6a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e6c:	02000a13          	li	s4,32
    80004e70:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e74:	00391513          	slli	a0,s2,0x3
    80004e78:	e3040593          	addi	a1,s0,-464
    80004e7c:	e3843783          	ld	a5,-456(s0)
    80004e80:	953e                	add	a0,a0,a5
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	028080e7          	jalr	40(ra) # 80001eaa <fetchaddr>
    80004e8a:	02054a63          	bltz	a0,80004ebe <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e8e:	e3043783          	ld	a5,-464(s0)
    80004e92:	c3b9                	beqz	a5,80004ed8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e94:	ffffb097          	auipc	ra,0xffffb
    80004e98:	286080e7          	jalr	646(ra) # 8000011a <kalloc>
    80004e9c:	85aa                	mv	a1,a0
    80004e9e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ea2:	cd11                	beqz	a0,80004ebe <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ea4:	6605                	lui	a2,0x1
    80004ea6:	e3043503          	ld	a0,-464(s0)
    80004eaa:	ffffd097          	auipc	ra,0xffffd
    80004eae:	052080e7          	jalr	82(ra) # 80001efc <fetchstr>
    80004eb2:	00054663          	bltz	a0,80004ebe <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004eb6:	0905                	addi	s2,s2,1
    80004eb8:	09a1                	addi	s3,s3,8
    80004eba:	fb491be3          	bne	s2,s4,80004e70 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ebe:	f4040913          	addi	s2,s0,-192
    80004ec2:	6088                	ld	a0,0(s1)
    80004ec4:	c531                	beqz	a0,80004f10 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ec6:	ffffb097          	auipc	ra,0xffffb
    80004eca:	156080e7          	jalr	342(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ece:	04a1                	addi	s1,s1,8
    80004ed0:	ff2499e3          	bne	s1,s2,80004ec2 <sys_exec+0xac>
  return -1;
    80004ed4:	597d                	li	s2,-1
    80004ed6:	a835                	j	80004f12 <sys_exec+0xfc>
      argv[i] = 0;
    80004ed8:	0a8e                	slli	s5,s5,0x3
    80004eda:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004ede:	00878ab3          	add	s5,a5,s0
    80004ee2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ee6:	e4040593          	addi	a1,s0,-448
    80004eea:	f4040513          	addi	a0,s0,-192
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	172080e7          	jalr	370(ra) # 80004060 <exec>
    80004ef6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef8:	f4040993          	addi	s3,s0,-192
    80004efc:	6088                	ld	a0,0(s1)
    80004efe:	c911                	beqz	a0,80004f12 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f00:	ffffb097          	auipc	ra,0xffffb
    80004f04:	11c080e7          	jalr	284(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f08:	04a1                	addi	s1,s1,8
    80004f0a:	ff3499e3          	bne	s1,s3,80004efc <sys_exec+0xe6>
    80004f0e:	a011                	j	80004f12 <sys_exec+0xfc>
  return -1;
    80004f10:	597d                	li	s2,-1
}
    80004f12:	854a                	mv	a0,s2
    80004f14:	60be                	ld	ra,456(sp)
    80004f16:	641e                	ld	s0,448(sp)
    80004f18:	74fa                	ld	s1,440(sp)
    80004f1a:	795a                	ld	s2,432(sp)
    80004f1c:	79ba                	ld	s3,424(sp)
    80004f1e:	7a1a                	ld	s4,416(sp)
    80004f20:	6afa                	ld	s5,408(sp)
    80004f22:	6179                	addi	sp,sp,464
    80004f24:	8082                	ret

0000000080004f26 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f26:	7139                	addi	sp,sp,-64
    80004f28:	fc06                	sd	ra,56(sp)
    80004f2a:	f822                	sd	s0,48(sp)
    80004f2c:	f426                	sd	s1,40(sp)
    80004f2e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f30:	ffffc097          	auipc	ra,0xffffc
    80004f34:	f14080e7          	jalr	-236(ra) # 80000e44 <myproc>
    80004f38:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f3a:	fd840593          	addi	a1,s0,-40
    80004f3e:	4501                	li	a0,0
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	026080e7          	jalr	38(ra) # 80001f66 <argaddr>
    return -1;
    80004f48:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f4a:	0e054063          	bltz	a0,8000502a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f4e:	fc840593          	addi	a1,s0,-56
    80004f52:	fd040513          	addi	a0,s0,-48
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	de6080e7          	jalr	-538(ra) # 80003d3c <pipealloc>
    return -1;
    80004f5e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f60:	0c054563          	bltz	a0,8000502a <sys_pipe+0x104>
  fd0 = -1;
    80004f64:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f68:	fd043503          	ld	a0,-48(s0)
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	504080e7          	jalr	1284(ra) # 80004470 <fdalloc>
    80004f74:	fca42223          	sw	a0,-60(s0)
    80004f78:	08054c63          	bltz	a0,80005010 <sys_pipe+0xea>
    80004f7c:	fc843503          	ld	a0,-56(s0)
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	4f0080e7          	jalr	1264(ra) # 80004470 <fdalloc>
    80004f88:	fca42023          	sw	a0,-64(s0)
    80004f8c:	06054963          	bltz	a0,80004ffe <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f90:	4691                	li	a3,4
    80004f92:	fc440613          	addi	a2,s0,-60
    80004f96:	fd843583          	ld	a1,-40(s0)
    80004f9a:	68a8                	ld	a0,80(s1)
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	b6c080e7          	jalr	-1172(ra) # 80000b08 <copyout>
    80004fa4:	02054063          	bltz	a0,80004fc4 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fa8:	4691                	li	a3,4
    80004faa:	fc040613          	addi	a2,s0,-64
    80004fae:	fd843583          	ld	a1,-40(s0)
    80004fb2:	0591                	addi	a1,a1,4
    80004fb4:	68a8                	ld	a0,80(s1)
    80004fb6:	ffffc097          	auipc	ra,0xffffc
    80004fba:	b52080e7          	jalr	-1198(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fbe:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fc0:	06055563          	bgez	a0,8000502a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fc4:	fc442783          	lw	a5,-60(s0)
    80004fc8:	07e9                	addi	a5,a5,26
    80004fca:	078e                	slli	a5,a5,0x3
    80004fcc:	97a6                	add	a5,a5,s1
    80004fce:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fd2:	fc042783          	lw	a5,-64(s0)
    80004fd6:	07e9                	addi	a5,a5,26
    80004fd8:	078e                	slli	a5,a5,0x3
    80004fda:	00f48533          	add	a0,s1,a5
    80004fde:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fe2:	fd043503          	ld	a0,-48(s0)
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	a26080e7          	jalr	-1498(ra) # 80003a0c <fileclose>
    fileclose(wf);
    80004fee:	fc843503          	ld	a0,-56(s0)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	a1a080e7          	jalr	-1510(ra) # 80003a0c <fileclose>
    return -1;
    80004ffa:	57fd                	li	a5,-1
    80004ffc:	a03d                	j	8000502a <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ffe:	fc442783          	lw	a5,-60(s0)
    80005002:	0007c763          	bltz	a5,80005010 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005006:	07e9                	addi	a5,a5,26
    80005008:	078e                	slli	a5,a5,0x3
    8000500a:	97a6                	add	a5,a5,s1
    8000500c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005010:	fd043503          	ld	a0,-48(s0)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	9f8080e7          	jalr	-1544(ra) # 80003a0c <fileclose>
    fileclose(wf);
    8000501c:	fc843503          	ld	a0,-56(s0)
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	9ec080e7          	jalr	-1556(ra) # 80003a0c <fileclose>
    return -1;
    80005028:	57fd                	li	a5,-1
}
    8000502a:	853e                	mv	a0,a5
    8000502c:	70e2                	ld	ra,56(sp)
    8000502e:	7442                	ld	s0,48(sp)
    80005030:	74a2                	ld	s1,40(sp)
    80005032:	6121                	addi	sp,sp,64
    80005034:	8082                	ret
	...

0000000080005040 <kernelvec>:
    80005040:	7111                	addi	sp,sp,-256
    80005042:	e006                	sd	ra,0(sp)
    80005044:	e40a                	sd	sp,8(sp)
    80005046:	e80e                	sd	gp,16(sp)
    80005048:	ec12                	sd	tp,24(sp)
    8000504a:	f016                	sd	t0,32(sp)
    8000504c:	f41a                	sd	t1,40(sp)
    8000504e:	f81e                	sd	t2,48(sp)
    80005050:	fc22                	sd	s0,56(sp)
    80005052:	e0a6                	sd	s1,64(sp)
    80005054:	e4aa                	sd	a0,72(sp)
    80005056:	e8ae                	sd	a1,80(sp)
    80005058:	ecb2                	sd	a2,88(sp)
    8000505a:	f0b6                	sd	a3,96(sp)
    8000505c:	f4ba                	sd	a4,104(sp)
    8000505e:	f8be                	sd	a5,112(sp)
    80005060:	fcc2                	sd	a6,120(sp)
    80005062:	e146                	sd	a7,128(sp)
    80005064:	e54a                	sd	s2,136(sp)
    80005066:	e94e                	sd	s3,144(sp)
    80005068:	ed52                	sd	s4,152(sp)
    8000506a:	f156                	sd	s5,160(sp)
    8000506c:	f55a                	sd	s6,168(sp)
    8000506e:	f95e                	sd	s7,176(sp)
    80005070:	fd62                	sd	s8,184(sp)
    80005072:	e1e6                	sd	s9,192(sp)
    80005074:	e5ea                	sd	s10,200(sp)
    80005076:	e9ee                	sd	s11,208(sp)
    80005078:	edf2                	sd	t3,216(sp)
    8000507a:	f1f6                	sd	t4,224(sp)
    8000507c:	f5fa                	sd	t5,232(sp)
    8000507e:	f9fe                	sd	t6,240(sp)
    80005080:	cf7fc0ef          	jal	ra,80001d76 <kerneltrap>
    80005084:	6082                	ld	ra,0(sp)
    80005086:	6122                	ld	sp,8(sp)
    80005088:	61c2                	ld	gp,16(sp)
    8000508a:	7282                	ld	t0,32(sp)
    8000508c:	7322                	ld	t1,40(sp)
    8000508e:	73c2                	ld	t2,48(sp)
    80005090:	7462                	ld	s0,56(sp)
    80005092:	6486                	ld	s1,64(sp)
    80005094:	6526                	ld	a0,72(sp)
    80005096:	65c6                	ld	a1,80(sp)
    80005098:	6666                	ld	a2,88(sp)
    8000509a:	7686                	ld	a3,96(sp)
    8000509c:	7726                	ld	a4,104(sp)
    8000509e:	77c6                	ld	a5,112(sp)
    800050a0:	7866                	ld	a6,120(sp)
    800050a2:	688a                	ld	a7,128(sp)
    800050a4:	692a                	ld	s2,136(sp)
    800050a6:	69ca                	ld	s3,144(sp)
    800050a8:	6a6a                	ld	s4,152(sp)
    800050aa:	7a8a                	ld	s5,160(sp)
    800050ac:	7b2a                	ld	s6,168(sp)
    800050ae:	7bca                	ld	s7,176(sp)
    800050b0:	7c6a                	ld	s8,184(sp)
    800050b2:	6c8e                	ld	s9,192(sp)
    800050b4:	6d2e                	ld	s10,200(sp)
    800050b6:	6dce                	ld	s11,208(sp)
    800050b8:	6e6e                	ld	t3,216(sp)
    800050ba:	7e8e                	ld	t4,224(sp)
    800050bc:	7f2e                	ld	t5,232(sp)
    800050be:	7fce                	ld	t6,240(sp)
    800050c0:	6111                	addi	sp,sp,256
    800050c2:	10200073          	sret
    800050c6:	00000013          	nop
    800050ca:	00000013          	nop
    800050ce:	0001                	nop

00000000800050d0 <timervec>:
    800050d0:	34051573          	csrrw	a0,mscratch,a0
    800050d4:	e10c                	sd	a1,0(a0)
    800050d6:	e510                	sd	a2,8(a0)
    800050d8:	e914                	sd	a3,16(a0)
    800050da:	6d0c                	ld	a1,24(a0)
    800050dc:	7110                	ld	a2,32(a0)
    800050de:	6194                	ld	a3,0(a1)
    800050e0:	96b2                	add	a3,a3,a2
    800050e2:	e194                	sd	a3,0(a1)
    800050e4:	4589                	li	a1,2
    800050e6:	14459073          	csrw	sip,a1
    800050ea:	6914                	ld	a3,16(a0)
    800050ec:	6510                	ld	a2,8(a0)
    800050ee:	610c                	ld	a1,0(a0)
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	30200073          	mret
	...

00000000800050fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050fa:	1141                	addi	sp,sp,-16
    800050fc:	e422                	sd	s0,8(sp)
    800050fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005100:	0c0007b7          	lui	a5,0xc000
    80005104:	4705                	li	a4,1
    80005106:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005108:	c3d8                	sw	a4,4(a5)
}
    8000510a:	6422                	ld	s0,8(sp)
    8000510c:	0141                	addi	sp,sp,16
    8000510e:	8082                	ret

0000000080005110 <plicinithart>:

void
plicinithart(void)
{
    80005110:	1141                	addi	sp,sp,-16
    80005112:	e406                	sd	ra,8(sp)
    80005114:	e022                	sd	s0,0(sp)
    80005116:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	d00080e7          	jalr	-768(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005120:	0085171b          	slliw	a4,a0,0x8
    80005124:	0c0027b7          	lui	a5,0xc002
    80005128:	97ba                	add	a5,a5,a4
    8000512a:	40200713          	li	a4,1026
    8000512e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005132:	00d5151b          	slliw	a0,a0,0xd
    80005136:	0c2017b7          	lui	a5,0xc201
    8000513a:	97aa                	add	a5,a5,a0
    8000513c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005140:	60a2                	ld	ra,8(sp)
    80005142:	6402                	ld	s0,0(sp)
    80005144:	0141                	addi	sp,sp,16
    80005146:	8082                	ret

0000000080005148 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005148:	1141                	addi	sp,sp,-16
    8000514a:	e406                	sd	ra,8(sp)
    8000514c:	e022                	sd	s0,0(sp)
    8000514e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	cc8080e7          	jalr	-824(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005158:	00d5151b          	slliw	a0,a0,0xd
    8000515c:	0c2017b7          	lui	a5,0xc201
    80005160:	97aa                	add	a5,a5,a0
  return irq;
}
    80005162:	43c8                	lw	a0,4(a5)
    80005164:	60a2                	ld	ra,8(sp)
    80005166:	6402                	ld	s0,0(sp)
    80005168:	0141                	addi	sp,sp,16
    8000516a:	8082                	ret

000000008000516c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000516c:	1101                	addi	sp,sp,-32
    8000516e:	ec06                	sd	ra,24(sp)
    80005170:	e822                	sd	s0,16(sp)
    80005172:	e426                	sd	s1,8(sp)
    80005174:	1000                	addi	s0,sp,32
    80005176:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	ca0080e7          	jalr	-864(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005180:	00d5151b          	slliw	a0,a0,0xd
    80005184:	0c2017b7          	lui	a5,0xc201
    80005188:	97aa                	add	a5,a5,a0
    8000518a:	c3c4                	sw	s1,4(a5)
}
    8000518c:	60e2                	ld	ra,24(sp)
    8000518e:	6442                	ld	s0,16(sp)
    80005190:	64a2                	ld	s1,8(sp)
    80005192:	6105                	addi	sp,sp,32
    80005194:	8082                	ret

0000000080005196 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005196:	1141                	addi	sp,sp,-16
    80005198:	e406                	sd	ra,8(sp)
    8000519a:	e022                	sd	s0,0(sp)
    8000519c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000519e:	479d                	li	a5,7
    800051a0:	06a7c863          	blt	a5,a0,80005210 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051a4:	00016717          	auipc	a4,0x16
    800051a8:	e5c70713          	addi	a4,a4,-420 # 8001b000 <disk>
    800051ac:	972a                	add	a4,a4,a0
    800051ae:	6789                	lui	a5,0x2
    800051b0:	97ba                	add	a5,a5,a4
    800051b2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051b6:	e7ad                	bnez	a5,80005220 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051b8:	00451793          	slli	a5,a0,0x4
    800051bc:	00018717          	auipc	a4,0x18
    800051c0:	e4470713          	addi	a4,a4,-444 # 8001d000 <disk+0x2000>
    800051c4:	6314                	ld	a3,0(a4)
    800051c6:	96be                	add	a3,a3,a5
    800051c8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051cc:	6314                	ld	a3,0(a4)
    800051ce:	96be                	add	a3,a3,a5
    800051d0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051d4:	6314                	ld	a3,0(a4)
    800051d6:	96be                	add	a3,a3,a5
    800051d8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051dc:	6318                	ld	a4,0(a4)
    800051de:	97ba                	add	a5,a5,a4
    800051e0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051e4:	00016717          	auipc	a4,0x16
    800051e8:	e1c70713          	addi	a4,a4,-484 # 8001b000 <disk>
    800051ec:	972a                	add	a4,a4,a0
    800051ee:	6789                	lui	a5,0x2
    800051f0:	97ba                	add	a5,a5,a4
    800051f2:	4705                	li	a4,1
    800051f4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051f8:	00018517          	auipc	a0,0x18
    800051fc:	e2050513          	addi	a0,a0,-480 # 8001d018 <disk+0x2018>
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	4a4080e7          	jalr	1188(ra) # 800016a4 <wakeup>
}
    80005208:	60a2                	ld	ra,8(sp)
    8000520a:	6402                	ld	s0,0(sp)
    8000520c:	0141                	addi	sp,sp,16
    8000520e:	8082                	ret
    panic("free_desc 1");
    80005210:	00003517          	auipc	a0,0x3
    80005214:	4e850513          	addi	a0,a0,1256 # 800086f8 <syscalls+0x330>
    80005218:	00001097          	auipc	ra,0x1
    8000521c:	a56080e7          	jalr	-1450(ra) # 80005c6e <panic>
    panic("free_desc 2");
    80005220:	00003517          	auipc	a0,0x3
    80005224:	4e850513          	addi	a0,a0,1256 # 80008708 <syscalls+0x340>
    80005228:	00001097          	auipc	ra,0x1
    8000522c:	a46080e7          	jalr	-1466(ra) # 80005c6e <panic>

0000000080005230 <virtio_disk_init>:
{
    80005230:	1101                	addi	sp,sp,-32
    80005232:	ec06                	sd	ra,24(sp)
    80005234:	e822                	sd	s0,16(sp)
    80005236:	e426                	sd	s1,8(sp)
    80005238:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000523a:	00003597          	auipc	a1,0x3
    8000523e:	4de58593          	addi	a1,a1,1246 # 80008718 <syscalls+0x350>
    80005242:	00018517          	auipc	a0,0x18
    80005246:	ee650513          	addi	a0,a0,-282 # 8001d128 <disk+0x2128>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	ea2080e7          	jalr	-350(ra) # 800060ec <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005252:	100017b7          	lui	a5,0x10001
    80005256:	4398                	lw	a4,0(a5)
    80005258:	2701                	sext.w	a4,a4
    8000525a:	747277b7          	lui	a5,0x74727
    8000525e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005262:	0ef71063          	bne	a4,a5,80005342 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005266:	100017b7          	lui	a5,0x10001
    8000526a:	43dc                	lw	a5,4(a5)
    8000526c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000526e:	4705                	li	a4,1
    80005270:	0ce79963          	bne	a5,a4,80005342 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	479c                	lw	a5,8(a5)
    8000527a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000527c:	4709                	li	a4,2
    8000527e:	0ce79263          	bne	a5,a4,80005342 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005282:	100017b7          	lui	a5,0x10001
    80005286:	47d8                	lw	a4,12(a5)
    80005288:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000528a:	554d47b7          	lui	a5,0x554d4
    8000528e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005292:	0af71863          	bne	a4,a5,80005342 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	4705                	li	a4,1
    8000529c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000529e:	470d                	li	a4,3
    800052a0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052a2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052a4:	c7ffe6b7          	lui	a3,0xc7ffe
    800052a8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ac:	8f75                	and	a4,a4,a3
    800052ae:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b0:	472d                	li	a4,11
    800052b2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b4:	473d                	li	a4,15
    800052b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052b8:	6705                	lui	a4,0x1
    800052ba:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052bc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c0:	5bdc                	lw	a5,52(a5)
    800052c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052c4:	c7d9                	beqz	a5,80005352 <virtio_disk_init+0x122>
  if(max < NUM)
    800052c6:	471d                	li	a4,7
    800052c8:	08f77d63          	bgeu	a4,a5,80005362 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052cc:	100014b7          	lui	s1,0x10001
    800052d0:	47a1                	li	a5,8
    800052d2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052d4:	6609                	lui	a2,0x2
    800052d6:	4581                	li	a1,0
    800052d8:	00016517          	auipc	a0,0x16
    800052dc:	d2850513          	addi	a0,a0,-728 # 8001b000 <disk>
    800052e0:	ffffb097          	auipc	ra,0xffffb
    800052e4:	e9a080e7          	jalr	-358(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052e8:	00016717          	auipc	a4,0x16
    800052ec:	d1870713          	addi	a4,a4,-744 # 8001b000 <disk>
    800052f0:	00c75793          	srli	a5,a4,0xc
    800052f4:	2781                	sext.w	a5,a5
    800052f6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800052f8:	00018797          	auipc	a5,0x18
    800052fc:	d0878793          	addi	a5,a5,-760 # 8001d000 <disk+0x2000>
    80005300:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005302:	00016717          	auipc	a4,0x16
    80005306:	d7e70713          	addi	a4,a4,-642 # 8001b080 <disk+0x80>
    8000530a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000530c:	00017717          	auipc	a4,0x17
    80005310:	cf470713          	addi	a4,a4,-780 # 8001c000 <disk+0x1000>
    80005314:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005316:	4705                	li	a4,1
    80005318:	00e78c23          	sb	a4,24(a5)
    8000531c:	00e78ca3          	sb	a4,25(a5)
    80005320:	00e78d23          	sb	a4,26(a5)
    80005324:	00e78da3          	sb	a4,27(a5)
    80005328:	00e78e23          	sb	a4,28(a5)
    8000532c:	00e78ea3          	sb	a4,29(a5)
    80005330:	00e78f23          	sb	a4,30(a5)
    80005334:	00e78fa3          	sb	a4,31(a5)
}
    80005338:	60e2                	ld	ra,24(sp)
    8000533a:	6442                	ld	s0,16(sp)
    8000533c:	64a2                	ld	s1,8(sp)
    8000533e:	6105                	addi	sp,sp,32
    80005340:	8082                	ret
    panic("could not find virtio disk");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	3e650513          	addi	a0,a0,998 # 80008728 <syscalls+0x360>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	924080e7          	jalr	-1756(ra) # 80005c6e <panic>
    panic("virtio disk has no queue 0");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	3f650513          	addi	a0,a0,1014 # 80008748 <syscalls+0x380>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	914080e7          	jalr	-1772(ra) # 80005c6e <panic>
    panic("virtio disk max queue too short");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	40650513          	addi	a0,a0,1030 # 80008768 <syscalls+0x3a0>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	904080e7          	jalr	-1788(ra) # 80005c6e <panic>

0000000080005372 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005372:	7119                	addi	sp,sp,-128
    80005374:	fc86                	sd	ra,120(sp)
    80005376:	f8a2                	sd	s0,112(sp)
    80005378:	f4a6                	sd	s1,104(sp)
    8000537a:	f0ca                	sd	s2,96(sp)
    8000537c:	ecce                	sd	s3,88(sp)
    8000537e:	e8d2                	sd	s4,80(sp)
    80005380:	e4d6                	sd	s5,72(sp)
    80005382:	e0da                	sd	s6,64(sp)
    80005384:	fc5e                	sd	s7,56(sp)
    80005386:	f862                	sd	s8,48(sp)
    80005388:	f466                	sd	s9,40(sp)
    8000538a:	f06a                	sd	s10,32(sp)
    8000538c:	ec6e                	sd	s11,24(sp)
    8000538e:	0100                	addi	s0,sp,128
    80005390:	8aaa                	mv	s5,a0
    80005392:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005394:	00c52c83          	lw	s9,12(a0)
    80005398:	001c9c9b          	slliw	s9,s9,0x1
    8000539c:	1c82                	slli	s9,s9,0x20
    8000539e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053a2:	00018517          	auipc	a0,0x18
    800053a6:	d8650513          	addi	a0,a0,-634 # 8001d128 <disk+0x2128>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	dd2080e7          	jalr	-558(ra) # 8000617c <acquire>
  for(int i = 0; i < 3; i++){
    800053b2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053b4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053b6:	00016c17          	auipc	s8,0x16
    800053ba:	c4ac0c13          	addi	s8,s8,-950 # 8001b000 <disk>
    800053be:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800053c0:	4b0d                	li	s6,3
    800053c2:	a0ad                	j	8000542c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800053c4:	00fc0733          	add	a4,s8,a5
    800053c8:	975e                	add	a4,a4,s7
    800053ca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053ce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053d0:	0207c563          	bltz	a5,800053fa <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053d4:	2905                	addiw	s2,s2,1
    800053d6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053d8:	19690c63          	beq	s2,s6,80005570 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800053dc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053de:	00018717          	auipc	a4,0x18
    800053e2:	c3a70713          	addi	a4,a4,-966 # 8001d018 <disk+0x2018>
    800053e6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053e8:	00074683          	lbu	a3,0(a4)
    800053ec:	fee1                	bnez	a3,800053c4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800053ee:	2785                	addiw	a5,a5,1
    800053f0:	0705                	addi	a4,a4,1
    800053f2:	fe979be3          	bne	a5,s1,800053e8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053f6:	57fd                	li	a5,-1
    800053f8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800053fa:	01205d63          	blez	s2,80005414 <virtio_disk_rw+0xa2>
    800053fe:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005400:	000a2503          	lw	a0,0(s4)
    80005404:	00000097          	auipc	ra,0x0
    80005408:	d92080e7          	jalr	-622(ra) # 80005196 <free_desc>
      for(int j = 0; j < i; j++)
    8000540c:	2d85                	addiw	s11,s11,1
    8000540e:	0a11                	addi	s4,s4,4
    80005410:	ff2d98e3          	bne	s11,s2,80005400 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005414:	00018597          	auipc	a1,0x18
    80005418:	d1458593          	addi	a1,a1,-748 # 8001d128 <disk+0x2128>
    8000541c:	00018517          	auipc	a0,0x18
    80005420:	bfc50513          	addi	a0,a0,-1028 # 8001d018 <disk+0x2018>
    80005424:	ffffc097          	auipc	ra,0xffffc
    80005428:	0f4080e7          	jalr	244(ra) # 80001518 <sleep>
  for(int i = 0; i < 3; i++){
    8000542c:	f8040a13          	addi	s4,s0,-128
{
    80005430:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005432:	894e                	mv	s2,s3
    80005434:	b765                	j	800053dc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005436:	00018697          	auipc	a3,0x18
    8000543a:	bca6b683          	ld	a3,-1078(a3) # 8001d000 <disk+0x2000>
    8000543e:	96ba                	add	a3,a3,a4
    80005440:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005444:	00016817          	auipc	a6,0x16
    80005448:	bbc80813          	addi	a6,a6,-1092 # 8001b000 <disk>
    8000544c:	00018697          	auipc	a3,0x18
    80005450:	bb468693          	addi	a3,a3,-1100 # 8001d000 <disk+0x2000>
    80005454:	6290                	ld	a2,0(a3)
    80005456:	963a                	add	a2,a2,a4
    80005458:	00c65583          	lhu	a1,12(a2)
    8000545c:	0015e593          	ori	a1,a1,1
    80005460:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005464:	f8842603          	lw	a2,-120(s0)
    80005468:	628c                	ld	a1,0(a3)
    8000546a:	972e                	add	a4,a4,a1
    8000546c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005470:	20050593          	addi	a1,a0,512
    80005474:	0592                	slli	a1,a1,0x4
    80005476:	95c2                	add	a1,a1,a6
    80005478:	577d                	li	a4,-1
    8000547a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000547e:	00461713          	slli	a4,a2,0x4
    80005482:	6290                	ld	a2,0(a3)
    80005484:	963a                	add	a2,a2,a4
    80005486:	03078793          	addi	a5,a5,48
    8000548a:	97c2                	add	a5,a5,a6
    8000548c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000548e:	629c                	ld	a5,0(a3)
    80005490:	97ba                	add	a5,a5,a4
    80005492:	4605                	li	a2,1
    80005494:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005496:	629c                	ld	a5,0(a3)
    80005498:	97ba                	add	a5,a5,a4
    8000549a:	4809                	li	a6,2
    8000549c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800054a0:	629c                	ld	a5,0(a3)
    800054a2:	97ba                	add	a5,a5,a4
    800054a4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054a8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054ac:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054b0:	6698                	ld	a4,8(a3)
    800054b2:	00275783          	lhu	a5,2(a4)
    800054b6:	8b9d                	andi	a5,a5,7
    800054b8:	0786                	slli	a5,a5,0x1
    800054ba:	973e                	add	a4,a4,a5
    800054bc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800054c0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054c4:	6698                	ld	a4,8(a3)
    800054c6:	00275783          	lhu	a5,2(a4)
    800054ca:	2785                	addiw	a5,a5,1
    800054cc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054d0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054dc:	004aa783          	lw	a5,4(s5)
    800054e0:	02c79163          	bne	a5,a2,80005502 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800054e4:	00018917          	auipc	s2,0x18
    800054e8:	c4490913          	addi	s2,s2,-956 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800054ec:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800054ee:	85ca                	mv	a1,s2
    800054f0:	8556                	mv	a0,s5
    800054f2:	ffffc097          	auipc	ra,0xffffc
    800054f6:	026080e7          	jalr	38(ra) # 80001518 <sleep>
  while(b->disk == 1) {
    800054fa:	004aa783          	lw	a5,4(s5)
    800054fe:	fe9788e3          	beq	a5,s1,800054ee <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005502:	f8042903          	lw	s2,-128(s0)
    80005506:	20090713          	addi	a4,s2,512
    8000550a:	0712                	slli	a4,a4,0x4
    8000550c:	00016797          	auipc	a5,0x16
    80005510:	af478793          	addi	a5,a5,-1292 # 8001b000 <disk>
    80005514:	97ba                	add	a5,a5,a4
    80005516:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000551a:	00018997          	auipc	s3,0x18
    8000551e:	ae698993          	addi	s3,s3,-1306 # 8001d000 <disk+0x2000>
    80005522:	00491713          	slli	a4,s2,0x4
    80005526:	0009b783          	ld	a5,0(s3)
    8000552a:	97ba                	add	a5,a5,a4
    8000552c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005530:	854a                	mv	a0,s2
    80005532:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005536:	00000097          	auipc	ra,0x0
    8000553a:	c60080e7          	jalr	-928(ra) # 80005196 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000553e:	8885                	andi	s1,s1,1
    80005540:	f0ed                	bnez	s1,80005522 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005542:	00018517          	auipc	a0,0x18
    80005546:	be650513          	addi	a0,a0,-1050 # 8001d128 <disk+0x2128>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	ce6080e7          	jalr	-794(ra) # 80006230 <release>
}
    80005552:	70e6                	ld	ra,120(sp)
    80005554:	7446                	ld	s0,112(sp)
    80005556:	74a6                	ld	s1,104(sp)
    80005558:	7906                	ld	s2,96(sp)
    8000555a:	69e6                	ld	s3,88(sp)
    8000555c:	6a46                	ld	s4,80(sp)
    8000555e:	6aa6                	ld	s5,72(sp)
    80005560:	6b06                	ld	s6,64(sp)
    80005562:	7be2                	ld	s7,56(sp)
    80005564:	7c42                	ld	s8,48(sp)
    80005566:	7ca2                	ld	s9,40(sp)
    80005568:	7d02                	ld	s10,32(sp)
    8000556a:	6de2                	ld	s11,24(sp)
    8000556c:	6109                	addi	sp,sp,128
    8000556e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005570:	f8042503          	lw	a0,-128(s0)
    80005574:	20050793          	addi	a5,a0,512
    80005578:	0792                	slli	a5,a5,0x4
  if(write)
    8000557a:	00016817          	auipc	a6,0x16
    8000557e:	a8680813          	addi	a6,a6,-1402 # 8001b000 <disk>
    80005582:	00f80733          	add	a4,a6,a5
    80005586:	01a036b3          	snez	a3,s10
    8000558a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000558e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005592:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005596:	7679                	lui	a2,0xffffe
    80005598:	963e                	add	a2,a2,a5
    8000559a:	00018697          	auipc	a3,0x18
    8000559e:	a6668693          	addi	a3,a3,-1434 # 8001d000 <disk+0x2000>
    800055a2:	6298                	ld	a4,0(a3)
    800055a4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055a6:	0a878593          	addi	a1,a5,168
    800055aa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ac:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055ae:	6298                	ld	a4,0(a3)
    800055b0:	9732                	add	a4,a4,a2
    800055b2:	45c1                	li	a1,16
    800055b4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055b6:	6298                	ld	a4,0(a3)
    800055b8:	9732                	add	a4,a4,a2
    800055ba:	4585                	li	a1,1
    800055bc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055c0:	f8442703          	lw	a4,-124(s0)
    800055c4:	628c                	ld	a1,0(a3)
    800055c6:	962e                	add	a2,a2,a1
    800055c8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055cc:	0712                	slli	a4,a4,0x4
    800055ce:	6290                	ld	a2,0(a3)
    800055d0:	963a                	add	a2,a2,a4
    800055d2:	058a8593          	addi	a1,s5,88
    800055d6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055d8:	6294                	ld	a3,0(a3)
    800055da:	96ba                	add	a3,a3,a4
    800055dc:	40000613          	li	a2,1024
    800055e0:	c690                	sw	a2,8(a3)
  if(write)
    800055e2:	e40d1ae3          	bnez	s10,80005436 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055e6:	00018697          	auipc	a3,0x18
    800055ea:	a1a6b683          	ld	a3,-1510(a3) # 8001d000 <disk+0x2000>
    800055ee:	96ba                	add	a3,a3,a4
    800055f0:	4609                	li	a2,2
    800055f2:	00c69623          	sh	a2,12(a3)
    800055f6:	b5b9                	j	80005444 <virtio_disk_rw+0xd2>

00000000800055f8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055f8:	1101                	addi	sp,sp,-32
    800055fa:	ec06                	sd	ra,24(sp)
    800055fc:	e822                	sd	s0,16(sp)
    800055fe:	e426                	sd	s1,8(sp)
    80005600:	e04a                	sd	s2,0(sp)
    80005602:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005604:	00018517          	auipc	a0,0x18
    80005608:	b2450513          	addi	a0,a0,-1244 # 8001d128 <disk+0x2128>
    8000560c:	00001097          	auipc	ra,0x1
    80005610:	b70080e7          	jalr	-1168(ra) # 8000617c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005614:	10001737          	lui	a4,0x10001
    80005618:	533c                	lw	a5,96(a4)
    8000561a:	8b8d                	andi	a5,a5,3
    8000561c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000561e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005622:	00018797          	auipc	a5,0x18
    80005626:	9de78793          	addi	a5,a5,-1570 # 8001d000 <disk+0x2000>
    8000562a:	6b94                	ld	a3,16(a5)
    8000562c:	0207d703          	lhu	a4,32(a5)
    80005630:	0026d783          	lhu	a5,2(a3)
    80005634:	06f70163          	beq	a4,a5,80005696 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005638:	00016917          	auipc	s2,0x16
    8000563c:	9c890913          	addi	s2,s2,-1592 # 8001b000 <disk>
    80005640:	00018497          	auipc	s1,0x18
    80005644:	9c048493          	addi	s1,s1,-1600 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005648:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000564c:	6898                	ld	a4,16(s1)
    8000564e:	0204d783          	lhu	a5,32(s1)
    80005652:	8b9d                	andi	a5,a5,7
    80005654:	078e                	slli	a5,a5,0x3
    80005656:	97ba                	add	a5,a5,a4
    80005658:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000565a:	20078713          	addi	a4,a5,512
    8000565e:	0712                	slli	a4,a4,0x4
    80005660:	974a                	add	a4,a4,s2
    80005662:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005666:	e731                	bnez	a4,800056b2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005668:	20078793          	addi	a5,a5,512
    8000566c:	0792                	slli	a5,a5,0x4
    8000566e:	97ca                	add	a5,a5,s2
    80005670:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005672:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005676:	ffffc097          	auipc	ra,0xffffc
    8000567a:	02e080e7          	jalr	46(ra) # 800016a4 <wakeup>

    disk.used_idx += 1;
    8000567e:	0204d783          	lhu	a5,32(s1)
    80005682:	2785                	addiw	a5,a5,1
    80005684:	17c2                	slli	a5,a5,0x30
    80005686:	93c1                	srli	a5,a5,0x30
    80005688:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000568c:	6898                	ld	a4,16(s1)
    8000568e:	00275703          	lhu	a4,2(a4)
    80005692:	faf71be3          	bne	a4,a5,80005648 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005696:	00018517          	auipc	a0,0x18
    8000569a:	a9250513          	addi	a0,a0,-1390 # 8001d128 <disk+0x2128>
    8000569e:	00001097          	auipc	ra,0x1
    800056a2:	b92080e7          	jalr	-1134(ra) # 80006230 <release>
}
    800056a6:	60e2                	ld	ra,24(sp)
    800056a8:	6442                	ld	s0,16(sp)
    800056aa:	64a2                	ld	s1,8(sp)
    800056ac:	6902                	ld	s2,0(sp)
    800056ae:	6105                	addi	sp,sp,32
    800056b0:	8082                	ret
      panic("virtio_disk_intr status");
    800056b2:	00003517          	auipc	a0,0x3
    800056b6:	0d650513          	addi	a0,a0,214 # 80008788 <syscalls+0x3c0>
    800056ba:	00000097          	auipc	ra,0x0
    800056be:	5b4080e7          	jalr	1460(ra) # 80005c6e <panic>

00000000800056c2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056c2:	1141                	addi	sp,sp,-16
    800056c4:	e422                	sd	s0,8(sp)
    800056c6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056c8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056cc:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056d0:	0037979b          	slliw	a5,a5,0x3
    800056d4:	02004737          	lui	a4,0x2004
    800056d8:	97ba                	add	a5,a5,a4
    800056da:	0200c737          	lui	a4,0x200c
    800056de:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056e2:	000f4637          	lui	a2,0xf4
    800056e6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056ea:	9732                	add	a4,a4,a2
    800056ec:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056ee:	00259693          	slli	a3,a1,0x2
    800056f2:	96ae                	add	a3,a3,a1
    800056f4:	068e                	slli	a3,a3,0x3
    800056f6:	00019717          	auipc	a4,0x19
    800056fa:	90a70713          	addi	a4,a4,-1782 # 8001e000 <timer_scratch>
    800056fe:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005700:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005702:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005704:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005708:	00000797          	auipc	a5,0x0
    8000570c:	9c878793          	addi	a5,a5,-1592 # 800050d0 <timervec>
    80005710:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005714:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005718:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000571c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005720:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005724:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005728:	30479073          	csrw	mie,a5
}
    8000572c:	6422                	ld	s0,8(sp)
    8000572e:	0141                	addi	sp,sp,16
    80005730:	8082                	ret

0000000080005732 <start>:
{
    80005732:	1141                	addi	sp,sp,-16
    80005734:	e406                	sd	ra,8(sp)
    80005736:	e022                	sd	s0,0(sp)
    80005738:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000573a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000573e:	7779                	lui	a4,0xffffe
    80005740:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005744:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005746:	6705                	lui	a4,0x1
    80005748:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000574c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000574e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005752:	ffffb797          	auipc	a5,0xffffb
    80005756:	bce78793          	addi	a5,a5,-1074 # 80000320 <main>
    8000575a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000575e:	4781                	li	a5,0
    80005760:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005764:	67c1                	lui	a5,0x10
    80005766:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005768:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000576c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005770:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005774:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005778:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000577c:	57fd                	li	a5,-1
    8000577e:	83a9                	srli	a5,a5,0xa
    80005780:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005784:	47bd                	li	a5,15
    80005786:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000578a:	00000097          	auipc	ra,0x0
    8000578e:	f38080e7          	jalr	-200(ra) # 800056c2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005792:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005796:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005798:	823e                	mv	tp,a5
  asm volatile("mret");
    8000579a:	30200073          	mret
}
    8000579e:	60a2                	ld	ra,8(sp)
    800057a0:	6402                	ld	s0,0(sp)
    800057a2:	0141                	addi	sp,sp,16
    800057a4:	8082                	ret

00000000800057a6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057a6:	715d                	addi	sp,sp,-80
    800057a8:	e486                	sd	ra,72(sp)
    800057aa:	e0a2                	sd	s0,64(sp)
    800057ac:	fc26                	sd	s1,56(sp)
    800057ae:	f84a                	sd	s2,48(sp)
    800057b0:	f44e                	sd	s3,40(sp)
    800057b2:	f052                	sd	s4,32(sp)
    800057b4:	ec56                	sd	s5,24(sp)
    800057b6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057b8:	04c05763          	blez	a2,80005806 <consolewrite+0x60>
    800057bc:	8a2a                	mv	s4,a0
    800057be:	84ae                	mv	s1,a1
    800057c0:	89b2                	mv	s3,a2
    800057c2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057c4:	5afd                	li	s5,-1
    800057c6:	4685                	li	a3,1
    800057c8:	8626                	mv	a2,s1
    800057ca:	85d2                	mv	a1,s4
    800057cc:	fbf40513          	addi	a0,s0,-65
    800057d0:	ffffc097          	auipc	ra,0xffffc
    800057d4:	142080e7          	jalr	322(ra) # 80001912 <either_copyin>
    800057d8:	01550d63          	beq	a0,s5,800057f2 <consolewrite+0x4c>
      break;
    uartputc(c);
    800057dc:	fbf44503          	lbu	a0,-65(s0)
    800057e0:	00000097          	auipc	ra,0x0
    800057e4:	7e2080e7          	jalr	2018(ra) # 80005fc2 <uartputc>
  for(i = 0; i < n; i++){
    800057e8:	2905                	addiw	s2,s2,1
    800057ea:	0485                	addi	s1,s1,1
    800057ec:	fd299de3          	bne	s3,s2,800057c6 <consolewrite+0x20>
    800057f0:	894e                	mv	s2,s3
  }

  return i;
}
    800057f2:	854a                	mv	a0,s2
    800057f4:	60a6                	ld	ra,72(sp)
    800057f6:	6406                	ld	s0,64(sp)
    800057f8:	74e2                	ld	s1,56(sp)
    800057fa:	7942                	ld	s2,48(sp)
    800057fc:	79a2                	ld	s3,40(sp)
    800057fe:	7a02                	ld	s4,32(sp)
    80005800:	6ae2                	ld	s5,24(sp)
    80005802:	6161                	addi	sp,sp,80
    80005804:	8082                	ret
  for(i = 0; i < n; i++){
    80005806:	4901                	li	s2,0
    80005808:	b7ed                	j	800057f2 <consolewrite+0x4c>

000000008000580a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000580a:	7159                	addi	sp,sp,-112
    8000580c:	f486                	sd	ra,104(sp)
    8000580e:	f0a2                	sd	s0,96(sp)
    80005810:	eca6                	sd	s1,88(sp)
    80005812:	e8ca                	sd	s2,80(sp)
    80005814:	e4ce                	sd	s3,72(sp)
    80005816:	e0d2                	sd	s4,64(sp)
    80005818:	fc56                	sd	s5,56(sp)
    8000581a:	f85a                	sd	s6,48(sp)
    8000581c:	f45e                	sd	s7,40(sp)
    8000581e:	f062                	sd	s8,32(sp)
    80005820:	ec66                	sd	s9,24(sp)
    80005822:	e86a                	sd	s10,16(sp)
    80005824:	1880                	addi	s0,sp,112
    80005826:	8aaa                	mv	s5,a0
    80005828:	8a2e                	mv	s4,a1
    8000582a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000582c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005830:	00021517          	auipc	a0,0x21
    80005834:	91050513          	addi	a0,a0,-1776 # 80026140 <cons>
    80005838:	00001097          	auipc	ra,0x1
    8000583c:	944080e7          	jalr	-1724(ra) # 8000617c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005840:	00021497          	auipc	s1,0x21
    80005844:	90048493          	addi	s1,s1,-1792 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005848:	00021917          	auipc	s2,0x21
    8000584c:	99090913          	addi	s2,s2,-1648 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005850:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005852:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005854:	4ca9                	li	s9,10
  while(n > 0){
    80005856:	07305863          	blez	s3,800058c6 <consoleread+0xbc>
    while(cons.r == cons.w){
    8000585a:	0984a783          	lw	a5,152(s1)
    8000585e:	09c4a703          	lw	a4,156(s1)
    80005862:	02f71463          	bne	a4,a5,8000588a <consoleread+0x80>
      if(myproc()->killed){
    80005866:	ffffb097          	auipc	ra,0xffffb
    8000586a:	5de080e7          	jalr	1502(ra) # 80000e44 <myproc>
    8000586e:	551c                	lw	a5,40(a0)
    80005870:	e7b5                	bnez	a5,800058dc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005872:	85a6                	mv	a1,s1
    80005874:	854a                	mv	a0,s2
    80005876:	ffffc097          	auipc	ra,0xffffc
    8000587a:	ca2080e7          	jalr	-862(ra) # 80001518 <sleep>
    while(cons.r == cons.w){
    8000587e:	0984a783          	lw	a5,152(s1)
    80005882:	09c4a703          	lw	a4,156(s1)
    80005886:	fef700e3          	beq	a4,a5,80005866 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000588a:	0017871b          	addiw	a4,a5,1
    8000588e:	08e4ac23          	sw	a4,152(s1)
    80005892:	07f7f713          	andi	a4,a5,127
    80005896:	9726                	add	a4,a4,s1
    80005898:	01874703          	lbu	a4,24(a4)
    8000589c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058a0:	077d0563          	beq	s10,s7,8000590a <consoleread+0x100>
    cbuf = c;
    800058a4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058a8:	4685                	li	a3,1
    800058aa:	f9f40613          	addi	a2,s0,-97
    800058ae:	85d2                	mv	a1,s4
    800058b0:	8556                	mv	a0,s5
    800058b2:	ffffc097          	auipc	ra,0xffffc
    800058b6:	00a080e7          	jalr	10(ra) # 800018bc <either_copyout>
    800058ba:	01850663          	beq	a0,s8,800058c6 <consoleread+0xbc>
    dst++;
    800058be:	0a05                	addi	s4,s4,1
    --n;
    800058c0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058c2:	f99d1ae3          	bne	s10,s9,80005856 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058c6:	00021517          	auipc	a0,0x21
    800058ca:	87a50513          	addi	a0,a0,-1926 # 80026140 <cons>
    800058ce:	00001097          	auipc	ra,0x1
    800058d2:	962080e7          	jalr	-1694(ra) # 80006230 <release>

  return target - n;
    800058d6:	413b053b          	subw	a0,s6,s3
    800058da:	a811                	j	800058ee <consoleread+0xe4>
        release(&cons.lock);
    800058dc:	00021517          	auipc	a0,0x21
    800058e0:	86450513          	addi	a0,a0,-1948 # 80026140 <cons>
    800058e4:	00001097          	auipc	ra,0x1
    800058e8:	94c080e7          	jalr	-1716(ra) # 80006230 <release>
        return -1;
    800058ec:	557d                	li	a0,-1
}
    800058ee:	70a6                	ld	ra,104(sp)
    800058f0:	7406                	ld	s0,96(sp)
    800058f2:	64e6                	ld	s1,88(sp)
    800058f4:	6946                	ld	s2,80(sp)
    800058f6:	69a6                	ld	s3,72(sp)
    800058f8:	6a06                	ld	s4,64(sp)
    800058fa:	7ae2                	ld	s5,56(sp)
    800058fc:	7b42                	ld	s6,48(sp)
    800058fe:	7ba2                	ld	s7,40(sp)
    80005900:	7c02                	ld	s8,32(sp)
    80005902:	6ce2                	ld	s9,24(sp)
    80005904:	6d42                	ld	s10,16(sp)
    80005906:	6165                	addi	sp,sp,112
    80005908:	8082                	ret
      if(n < target){
    8000590a:	0009871b          	sext.w	a4,s3
    8000590e:	fb677ce3          	bgeu	a4,s6,800058c6 <consoleread+0xbc>
        cons.r--;
    80005912:	00021717          	auipc	a4,0x21
    80005916:	8cf72323          	sw	a5,-1850(a4) # 800261d8 <cons+0x98>
    8000591a:	b775                	j	800058c6 <consoleread+0xbc>

000000008000591c <consputc>:
{
    8000591c:	1141                	addi	sp,sp,-16
    8000591e:	e406                	sd	ra,8(sp)
    80005920:	e022                	sd	s0,0(sp)
    80005922:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005924:	10000793          	li	a5,256
    80005928:	00f50a63          	beq	a0,a5,8000593c <consputc+0x20>
    uartputc_sync(c);
    8000592c:	00000097          	auipc	ra,0x0
    80005930:	5c4080e7          	jalr	1476(ra) # 80005ef0 <uartputc_sync>
}
    80005934:	60a2                	ld	ra,8(sp)
    80005936:	6402                	ld	s0,0(sp)
    80005938:	0141                	addi	sp,sp,16
    8000593a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000593c:	4521                	li	a0,8
    8000593e:	00000097          	auipc	ra,0x0
    80005942:	5b2080e7          	jalr	1458(ra) # 80005ef0 <uartputc_sync>
    80005946:	02000513          	li	a0,32
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	5a6080e7          	jalr	1446(ra) # 80005ef0 <uartputc_sync>
    80005952:	4521                	li	a0,8
    80005954:	00000097          	auipc	ra,0x0
    80005958:	59c080e7          	jalr	1436(ra) # 80005ef0 <uartputc_sync>
    8000595c:	bfe1                	j	80005934 <consputc+0x18>

000000008000595e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000595e:	1101                	addi	sp,sp,-32
    80005960:	ec06                	sd	ra,24(sp)
    80005962:	e822                	sd	s0,16(sp)
    80005964:	e426                	sd	s1,8(sp)
    80005966:	e04a                	sd	s2,0(sp)
    80005968:	1000                	addi	s0,sp,32
    8000596a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000596c:	00020517          	auipc	a0,0x20
    80005970:	7d450513          	addi	a0,a0,2004 # 80026140 <cons>
    80005974:	00001097          	auipc	ra,0x1
    80005978:	808080e7          	jalr	-2040(ra) # 8000617c <acquire>

  switch(c){
    8000597c:	47d5                	li	a5,21
    8000597e:	0af48663          	beq	s1,a5,80005a2a <consoleintr+0xcc>
    80005982:	0297ca63          	blt	a5,s1,800059b6 <consoleintr+0x58>
    80005986:	47a1                	li	a5,8
    80005988:	0ef48763          	beq	s1,a5,80005a76 <consoleintr+0x118>
    8000598c:	47c1                	li	a5,16
    8000598e:	10f49a63          	bne	s1,a5,80005aa2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005992:	ffffc097          	auipc	ra,0xffffc
    80005996:	fd6080e7          	jalr	-42(ra) # 80001968 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000599a:	00020517          	auipc	a0,0x20
    8000599e:	7a650513          	addi	a0,a0,1958 # 80026140 <cons>
    800059a2:	00001097          	auipc	ra,0x1
    800059a6:	88e080e7          	jalr	-1906(ra) # 80006230 <release>
}
    800059aa:	60e2                	ld	ra,24(sp)
    800059ac:	6442                	ld	s0,16(sp)
    800059ae:	64a2                	ld	s1,8(sp)
    800059b0:	6902                	ld	s2,0(sp)
    800059b2:	6105                	addi	sp,sp,32
    800059b4:	8082                	ret
  switch(c){
    800059b6:	07f00793          	li	a5,127
    800059ba:	0af48e63          	beq	s1,a5,80005a76 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059be:	00020717          	auipc	a4,0x20
    800059c2:	78270713          	addi	a4,a4,1922 # 80026140 <cons>
    800059c6:	0a072783          	lw	a5,160(a4)
    800059ca:	09872703          	lw	a4,152(a4)
    800059ce:	9f99                	subw	a5,a5,a4
    800059d0:	07f00713          	li	a4,127
    800059d4:	fcf763e3          	bltu	a4,a5,8000599a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059d8:	47b5                	li	a5,13
    800059da:	0cf48763          	beq	s1,a5,80005aa8 <consoleintr+0x14a>
      consputc(c);
    800059de:	8526                	mv	a0,s1
    800059e0:	00000097          	auipc	ra,0x0
    800059e4:	f3c080e7          	jalr	-196(ra) # 8000591c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059e8:	00020797          	auipc	a5,0x20
    800059ec:	75878793          	addi	a5,a5,1880 # 80026140 <cons>
    800059f0:	0a07a703          	lw	a4,160(a5)
    800059f4:	0017069b          	addiw	a3,a4,1
    800059f8:	0006861b          	sext.w	a2,a3
    800059fc:	0ad7a023          	sw	a3,160(a5)
    80005a00:	07f77713          	andi	a4,a4,127
    80005a04:	97ba                	add	a5,a5,a4
    80005a06:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a0a:	47a9                	li	a5,10
    80005a0c:	0cf48563          	beq	s1,a5,80005ad6 <consoleintr+0x178>
    80005a10:	4791                	li	a5,4
    80005a12:	0cf48263          	beq	s1,a5,80005ad6 <consoleintr+0x178>
    80005a16:	00020797          	auipc	a5,0x20
    80005a1a:	7c27a783          	lw	a5,1986(a5) # 800261d8 <cons+0x98>
    80005a1e:	0807879b          	addiw	a5,a5,128
    80005a22:	f6f61ce3          	bne	a2,a5,8000599a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a26:	863e                	mv	a2,a5
    80005a28:	a07d                	j	80005ad6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a2a:	00020717          	auipc	a4,0x20
    80005a2e:	71670713          	addi	a4,a4,1814 # 80026140 <cons>
    80005a32:	0a072783          	lw	a5,160(a4)
    80005a36:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a3a:	00020497          	auipc	s1,0x20
    80005a3e:	70648493          	addi	s1,s1,1798 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a42:	4929                	li	s2,10
    80005a44:	f4f70be3          	beq	a4,a5,8000599a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a48:	37fd                	addiw	a5,a5,-1
    80005a4a:	07f7f713          	andi	a4,a5,127
    80005a4e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a50:	01874703          	lbu	a4,24(a4)
    80005a54:	f52703e3          	beq	a4,s2,8000599a <consoleintr+0x3c>
      cons.e--;
    80005a58:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a5c:	10000513          	li	a0,256
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	ebc080e7          	jalr	-324(ra) # 8000591c <consputc>
    while(cons.e != cons.w &&
    80005a68:	0a04a783          	lw	a5,160(s1)
    80005a6c:	09c4a703          	lw	a4,156(s1)
    80005a70:	fcf71ce3          	bne	a4,a5,80005a48 <consoleintr+0xea>
    80005a74:	b71d                	j	8000599a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a76:	00020717          	auipc	a4,0x20
    80005a7a:	6ca70713          	addi	a4,a4,1738 # 80026140 <cons>
    80005a7e:	0a072783          	lw	a5,160(a4)
    80005a82:	09c72703          	lw	a4,156(a4)
    80005a86:	f0f70ae3          	beq	a4,a5,8000599a <consoleintr+0x3c>
      cons.e--;
    80005a8a:	37fd                	addiw	a5,a5,-1
    80005a8c:	00020717          	auipc	a4,0x20
    80005a90:	74f72a23          	sw	a5,1876(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a94:	10000513          	li	a0,256
    80005a98:	00000097          	auipc	ra,0x0
    80005a9c:	e84080e7          	jalr	-380(ra) # 8000591c <consputc>
    80005aa0:	bded                	j	8000599a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005aa2:	ee048ce3          	beqz	s1,8000599a <consoleintr+0x3c>
    80005aa6:	bf21                	j	800059be <consoleintr+0x60>
      consputc(c);
    80005aa8:	4529                	li	a0,10
    80005aaa:	00000097          	auipc	ra,0x0
    80005aae:	e72080e7          	jalr	-398(ra) # 8000591c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab2:	00020797          	auipc	a5,0x20
    80005ab6:	68e78793          	addi	a5,a5,1678 # 80026140 <cons>
    80005aba:	0a07a703          	lw	a4,160(a5)
    80005abe:	0017069b          	addiw	a3,a4,1
    80005ac2:	0006861b          	sext.w	a2,a3
    80005ac6:	0ad7a023          	sw	a3,160(a5)
    80005aca:	07f77713          	andi	a4,a4,127
    80005ace:	97ba                	add	a5,a5,a4
    80005ad0:	4729                	li	a4,10
    80005ad2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ad6:	00020797          	auipc	a5,0x20
    80005ada:	70c7a323          	sw	a2,1798(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005ade:	00020517          	auipc	a0,0x20
    80005ae2:	6fa50513          	addi	a0,a0,1786 # 800261d8 <cons+0x98>
    80005ae6:	ffffc097          	auipc	ra,0xffffc
    80005aea:	bbe080e7          	jalr	-1090(ra) # 800016a4 <wakeup>
    80005aee:	b575                	j	8000599a <consoleintr+0x3c>

0000000080005af0 <consoleinit>:

void
consoleinit(void)
{
    80005af0:	1141                	addi	sp,sp,-16
    80005af2:	e406                	sd	ra,8(sp)
    80005af4:	e022                	sd	s0,0(sp)
    80005af6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005af8:	00003597          	auipc	a1,0x3
    80005afc:	ca858593          	addi	a1,a1,-856 # 800087a0 <syscalls+0x3d8>
    80005b00:	00020517          	auipc	a0,0x20
    80005b04:	64050513          	addi	a0,a0,1600 # 80026140 <cons>
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	5e4080e7          	jalr	1508(ra) # 800060ec <initlock>

  uartinit();
    80005b10:	00000097          	auipc	ra,0x0
    80005b14:	390080e7          	jalr	912(ra) # 80005ea0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b18:	00014797          	auipc	a5,0x14
    80005b1c:	db078793          	addi	a5,a5,-592 # 800198c8 <devsw>
    80005b20:	00000717          	auipc	a4,0x0
    80005b24:	cea70713          	addi	a4,a4,-790 # 8000580a <consoleread>
    80005b28:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b2a:	00000717          	auipc	a4,0x0
    80005b2e:	c7c70713          	addi	a4,a4,-900 # 800057a6 <consolewrite>
    80005b32:	ef98                	sd	a4,24(a5)
}
    80005b34:	60a2                	ld	ra,8(sp)
    80005b36:	6402                	ld	s0,0(sp)
    80005b38:	0141                	addi	sp,sp,16
    80005b3a:	8082                	ret

0000000080005b3c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b3c:	7179                	addi	sp,sp,-48
    80005b3e:	f406                	sd	ra,40(sp)
    80005b40:	f022                	sd	s0,32(sp)
    80005b42:	ec26                	sd	s1,24(sp)
    80005b44:	e84a                	sd	s2,16(sp)
    80005b46:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b48:	c219                	beqz	a2,80005b4e <printint+0x12>
    80005b4a:	08054763          	bltz	a0,80005bd8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b4e:	2501                	sext.w	a0,a0
    80005b50:	4881                	li	a7,0
    80005b52:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b56:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b58:	2581                	sext.w	a1,a1
    80005b5a:	00003617          	auipc	a2,0x3
    80005b5e:	c7e60613          	addi	a2,a2,-898 # 800087d8 <digits>
    80005b62:	883a                	mv	a6,a4
    80005b64:	2705                	addiw	a4,a4,1
    80005b66:	02b577bb          	remuw	a5,a0,a1
    80005b6a:	1782                	slli	a5,a5,0x20
    80005b6c:	9381                	srli	a5,a5,0x20
    80005b6e:	97b2                	add	a5,a5,a2
    80005b70:	0007c783          	lbu	a5,0(a5)
    80005b74:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b78:	0005079b          	sext.w	a5,a0
    80005b7c:	02b5553b          	divuw	a0,a0,a1
    80005b80:	0685                	addi	a3,a3,1
    80005b82:	feb7f0e3          	bgeu	a5,a1,80005b62 <printint+0x26>

  if(sign)
    80005b86:	00088c63          	beqz	a7,80005b9e <printint+0x62>
    buf[i++] = '-';
    80005b8a:	fe070793          	addi	a5,a4,-32
    80005b8e:	00878733          	add	a4,a5,s0
    80005b92:	02d00793          	li	a5,45
    80005b96:	fef70823          	sb	a5,-16(a4)
    80005b9a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b9e:	02e05763          	blez	a4,80005bcc <printint+0x90>
    80005ba2:	fd040793          	addi	a5,s0,-48
    80005ba6:	00e784b3          	add	s1,a5,a4
    80005baa:	fff78913          	addi	s2,a5,-1
    80005bae:	993a                	add	s2,s2,a4
    80005bb0:	377d                	addiw	a4,a4,-1
    80005bb2:	1702                	slli	a4,a4,0x20
    80005bb4:	9301                	srli	a4,a4,0x20
    80005bb6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bba:	fff4c503          	lbu	a0,-1(s1)
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	d5e080e7          	jalr	-674(ra) # 8000591c <consputc>
  while(--i >= 0)
    80005bc6:	14fd                	addi	s1,s1,-1
    80005bc8:	ff2499e3          	bne	s1,s2,80005bba <printint+0x7e>
}
    80005bcc:	70a2                	ld	ra,40(sp)
    80005bce:	7402                	ld	s0,32(sp)
    80005bd0:	64e2                	ld	s1,24(sp)
    80005bd2:	6942                	ld	s2,16(sp)
    80005bd4:	6145                	addi	sp,sp,48
    80005bd6:	8082                	ret
    x = -xx;
    80005bd8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bdc:	4885                	li	a7,1
    x = -xx;
    80005bde:	bf95                	j	80005b52 <printint+0x16>

0000000080005be0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005be0:	1101                	addi	sp,sp,-32
    80005be2:	ec06                	sd	ra,24(sp)
    80005be4:	e822                	sd	s0,16(sp)
    80005be6:	e426                	sd	s1,8(sp)
    80005be8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005bea:	00020497          	auipc	s1,0x20
    80005bee:	5fe48493          	addi	s1,s1,1534 # 800261e8 <pr>
    80005bf2:	00003597          	auipc	a1,0x3
    80005bf6:	bb658593          	addi	a1,a1,-1098 # 800087a8 <syscalls+0x3e0>
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	4f0080e7          	jalr	1264(ra) # 800060ec <initlock>
  pr.locking = 1;
    80005c04:	4785                	li	a5,1
    80005c06:	cc9c                	sw	a5,24(s1)
}
    80005c08:	60e2                	ld	ra,24(sp)
    80005c0a:	6442                	ld	s0,16(sp)
    80005c0c:	64a2                	ld	s1,8(sp)
    80005c0e:	6105                	addi	sp,sp,32
    80005c10:	8082                	ret

0000000080005c12 <backtrace>:

void backtrace() {
    80005c12:	7179                	addi	sp,sp,-48
    80005c14:	f406                	sd	ra,40(sp)
    80005c16:	f022                	sd	s0,32(sp)
    80005c18:	ec26                	sd	s1,24(sp)
    80005c1a:	e84a                	sd	s2,16(sp)
    80005c1c:	e44e                	sd	s3,8(sp)
    80005c1e:	e052                	sd	s4,0(sp)
    80005c20:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    80005c22:	84a2                	mv	s1,s0
    uint64 fp = r_fp();    // 获取当前栈帧
    uint64 top = PGROUNDUP(fp);    // 获取用户栈最高地址
    80005c24:	6905                	lui	s2,0x1
    80005c26:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005c28:	9926                	add	s2,s2,s1
    80005c2a:	79fd                	lui	s3,0xfffff
    80005c2c:	01397933          	and	s2,s2,s3
    uint64 bottom = PGROUNDDOWN(fp);    // 获取用户栈最低地址
    80005c30:	0134f9b3          	and	s3,s1,s3
    for (; 
        fp >= bottom && fp < top;     // 终止条件
    80005c34:	0334e563          	bltu	s1,s3,80005c5e <backtrace+0x4c>
    80005c38:	0324f363          	bgeu	s1,s2,80005c5e <backtrace+0x4c>
        fp = *((uint64 *) (fp - 16))    // 获取下一栈帧
        ) {
        printf("%p\n", *((uint64 *) (fp - 8)));    // 输出当前栈中返回地址
    80005c3c:	00003a17          	auipc	s4,0x3
    80005c40:	b74a0a13          	addi	s4,s4,-1164 # 800087b0 <syscalls+0x3e8>
    80005c44:	ff84b583          	ld	a1,-8(s1)
    80005c48:	8552                	mv	a0,s4
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	076080e7          	jalr	118(ra) # 80005cc0 <printf>
        fp = *((uint64 *) (fp - 16))    // 获取下一栈帧
    80005c52:	ff04b483          	ld	s1,-16(s1)
        fp >= bottom && fp < top;     // 终止条件
    80005c56:	0134e463          	bltu	s1,s3,80005c5e <backtrace+0x4c>
    80005c5a:	ff24e5e3          	bltu	s1,s2,80005c44 <backtrace+0x32>
    }
}
    80005c5e:	70a2                	ld	ra,40(sp)
    80005c60:	7402                	ld	s0,32(sp)
    80005c62:	64e2                	ld	s1,24(sp)
    80005c64:	6942                	ld	s2,16(sp)
    80005c66:	69a2                	ld	s3,8(sp)
    80005c68:	6a02                	ld	s4,0(sp)
    80005c6a:	6145                	addi	sp,sp,48
    80005c6c:	8082                	ret

0000000080005c6e <panic>:
{
    80005c6e:	1101                	addi	sp,sp,-32
    80005c70:	ec06                	sd	ra,24(sp)
    80005c72:	e822                	sd	s0,16(sp)
    80005c74:	e426                	sd	s1,8(sp)
    80005c76:	1000                	addi	s0,sp,32
    80005c78:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c7a:	00020797          	auipc	a5,0x20
    80005c7e:	5807a323          	sw	zero,1414(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c82:	00003517          	auipc	a0,0x3
    80005c86:	b3650513          	addi	a0,a0,-1226 # 800087b8 <syscalls+0x3f0>
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	036080e7          	jalr	54(ra) # 80005cc0 <printf>
  printf(s);
    80005c92:	8526                	mv	a0,s1
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	02c080e7          	jalr	44(ra) # 80005cc0 <printf>
  printf("\n");
    80005c9c:	00002517          	auipc	a0,0x2
    80005ca0:	3ac50513          	addi	a0,a0,940 # 80008048 <etext+0x48>
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	01c080e7          	jalr	28(ra) # 80005cc0 <printf>
  backtrace();
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	f66080e7          	jalr	-154(ra) # 80005c12 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005cb4:	4785                	li	a5,1
    80005cb6:	00003717          	auipc	a4,0x3
    80005cba:	36f72323          	sw	a5,870(a4) # 8000901c <panicked>
  for(;;)
    80005cbe:	a001                	j	80005cbe <panic+0x50>

0000000080005cc0 <printf>:
{
    80005cc0:	7131                	addi	sp,sp,-192
    80005cc2:	fc86                	sd	ra,120(sp)
    80005cc4:	f8a2                	sd	s0,112(sp)
    80005cc6:	f4a6                	sd	s1,104(sp)
    80005cc8:	f0ca                	sd	s2,96(sp)
    80005cca:	ecce                	sd	s3,88(sp)
    80005ccc:	e8d2                	sd	s4,80(sp)
    80005cce:	e4d6                	sd	s5,72(sp)
    80005cd0:	e0da                	sd	s6,64(sp)
    80005cd2:	fc5e                	sd	s7,56(sp)
    80005cd4:	f862                	sd	s8,48(sp)
    80005cd6:	f466                	sd	s9,40(sp)
    80005cd8:	f06a                	sd	s10,32(sp)
    80005cda:	ec6e                	sd	s11,24(sp)
    80005cdc:	0100                	addi	s0,sp,128
    80005cde:	8a2a                	mv	s4,a0
    80005ce0:	e40c                	sd	a1,8(s0)
    80005ce2:	e810                	sd	a2,16(s0)
    80005ce4:	ec14                	sd	a3,24(s0)
    80005ce6:	f018                	sd	a4,32(s0)
    80005ce8:	f41c                	sd	a5,40(s0)
    80005cea:	03043823          	sd	a6,48(s0)
    80005cee:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cf2:	00020d97          	auipc	s11,0x20
    80005cf6:	50edad83          	lw	s11,1294(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cfa:	020d9b63          	bnez	s11,80005d30 <printf+0x70>
  if (fmt == 0)
    80005cfe:	040a0263          	beqz	s4,80005d42 <printf+0x82>
  va_start(ap, fmt);
    80005d02:	00840793          	addi	a5,s0,8
    80005d06:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d0a:	000a4503          	lbu	a0,0(s4)
    80005d0e:	14050f63          	beqz	a0,80005e6c <printf+0x1ac>
    80005d12:	4981                	li	s3,0
    if(c != '%'){
    80005d14:	02500a93          	li	s5,37
    switch(c){
    80005d18:	07000b93          	li	s7,112
  consputc('x');
    80005d1c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d1e:	00003b17          	auipc	s6,0x3
    80005d22:	abab0b13          	addi	s6,s6,-1350 # 800087d8 <digits>
    switch(c){
    80005d26:	07300c93          	li	s9,115
    80005d2a:	06400c13          	li	s8,100
    80005d2e:	a82d                	j	80005d68 <printf+0xa8>
    acquire(&pr.lock);
    80005d30:	00020517          	auipc	a0,0x20
    80005d34:	4b850513          	addi	a0,a0,1208 # 800261e8 <pr>
    80005d38:	00000097          	auipc	ra,0x0
    80005d3c:	444080e7          	jalr	1092(ra) # 8000617c <acquire>
    80005d40:	bf7d                	j	80005cfe <printf+0x3e>
    panic("null fmt");
    80005d42:	00003517          	auipc	a0,0x3
    80005d46:	a8650513          	addi	a0,a0,-1402 # 800087c8 <syscalls+0x400>
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	f24080e7          	jalr	-220(ra) # 80005c6e <panic>
      consputc(c);
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	bca080e7          	jalr	-1078(ra) # 8000591c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d5a:	2985                	addiw	s3,s3,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80005d5c:	013a07b3          	add	a5,s4,s3
    80005d60:	0007c503          	lbu	a0,0(a5)
    80005d64:	10050463          	beqz	a0,80005e6c <printf+0x1ac>
    if(c != '%'){
    80005d68:	ff5515e3          	bne	a0,s5,80005d52 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d6c:	2985                	addiw	s3,s3,1
    80005d6e:	013a07b3          	add	a5,s4,s3
    80005d72:	0007c783          	lbu	a5,0(a5)
    80005d76:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d7a:	cbed                	beqz	a5,80005e6c <printf+0x1ac>
    switch(c){
    80005d7c:	05778a63          	beq	a5,s7,80005dd0 <printf+0x110>
    80005d80:	02fbf663          	bgeu	s7,a5,80005dac <printf+0xec>
    80005d84:	09978863          	beq	a5,s9,80005e14 <printf+0x154>
    80005d88:	07800713          	li	a4,120
    80005d8c:	0ce79563          	bne	a5,a4,80005e56 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d90:	f8843783          	ld	a5,-120(s0)
    80005d94:	00878713          	addi	a4,a5,8
    80005d98:	f8e43423          	sd	a4,-120(s0)
    80005d9c:	4605                	li	a2,1
    80005d9e:	85ea                	mv	a1,s10
    80005da0:	4388                	lw	a0,0(a5)
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	d9a080e7          	jalr	-614(ra) # 80005b3c <printint>
      break;
    80005daa:	bf45                	j	80005d5a <printf+0x9a>
    switch(c){
    80005dac:	09578f63          	beq	a5,s5,80005e4a <printf+0x18a>
    80005db0:	0b879363          	bne	a5,s8,80005e56 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005db4:	f8843783          	ld	a5,-120(s0)
    80005db8:	00878713          	addi	a4,a5,8
    80005dbc:	f8e43423          	sd	a4,-120(s0)
    80005dc0:	4605                	li	a2,1
    80005dc2:	45a9                	li	a1,10
    80005dc4:	4388                	lw	a0,0(a5)
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	d76080e7          	jalr	-650(ra) # 80005b3c <printint>
      break;
    80005dce:	b771                	j	80005d5a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dd0:	f8843783          	ld	a5,-120(s0)
    80005dd4:	00878713          	addi	a4,a5,8
    80005dd8:	f8e43423          	sd	a4,-120(s0)
    80005ddc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005de0:	03000513          	li	a0,48
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	b38080e7          	jalr	-1224(ra) # 8000591c <consputc>
  consputc('x');
    80005dec:	07800513          	li	a0,120
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	b2c080e7          	jalr	-1236(ra) # 8000591c <consputc>
    80005df8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dfa:	03c95793          	srli	a5,s2,0x3c
    80005dfe:	97da                	add	a5,a5,s6
    80005e00:	0007c503          	lbu	a0,0(a5)
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	b18080e7          	jalr	-1256(ra) # 8000591c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e0c:	0912                	slli	s2,s2,0x4
    80005e0e:	34fd                	addiw	s1,s1,-1
    80005e10:	f4ed                	bnez	s1,80005dfa <printf+0x13a>
    80005e12:	b7a1                	j	80005d5a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e14:	f8843783          	ld	a5,-120(s0)
    80005e18:	00878713          	addi	a4,a5,8
    80005e1c:	f8e43423          	sd	a4,-120(s0)
    80005e20:	6384                	ld	s1,0(a5)
    80005e22:	cc89                	beqz	s1,80005e3c <printf+0x17c>
      for(; *s; s++)
    80005e24:	0004c503          	lbu	a0,0(s1)
    80005e28:	d90d                	beqz	a0,80005d5a <printf+0x9a>
        consputc(*s);
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	af2080e7          	jalr	-1294(ra) # 8000591c <consputc>
      for(; *s; s++)
    80005e32:	0485                	addi	s1,s1,1
    80005e34:	0004c503          	lbu	a0,0(s1)
    80005e38:	f96d                	bnez	a0,80005e2a <printf+0x16a>
    80005e3a:	b705                	j	80005d5a <printf+0x9a>
        s = "(null)";
    80005e3c:	00003497          	auipc	s1,0x3
    80005e40:	98448493          	addi	s1,s1,-1660 # 800087c0 <syscalls+0x3f8>
      for(; *s; s++)
    80005e44:	02800513          	li	a0,40
    80005e48:	b7cd                	j	80005e2a <printf+0x16a>
      consputc('%');
    80005e4a:	8556                	mv	a0,s5
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	ad0080e7          	jalr	-1328(ra) # 8000591c <consputc>
      break;
    80005e54:	b719                	j	80005d5a <printf+0x9a>
      consputc('%');
    80005e56:	8556                	mv	a0,s5
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	ac4080e7          	jalr	-1340(ra) # 8000591c <consputc>
      consputc(c);
    80005e60:	8526                	mv	a0,s1
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	aba080e7          	jalr	-1350(ra) # 8000591c <consputc>
      break;
    80005e6a:	bdc5                	j	80005d5a <printf+0x9a>
  if(locking)
    80005e6c:	020d9163          	bnez	s11,80005e8e <printf+0x1ce>
}
    80005e70:	70e6                	ld	ra,120(sp)
    80005e72:	7446                	ld	s0,112(sp)
    80005e74:	74a6                	ld	s1,104(sp)
    80005e76:	7906                	ld	s2,96(sp)
    80005e78:	69e6                	ld	s3,88(sp)
    80005e7a:	6a46                	ld	s4,80(sp)
    80005e7c:	6aa6                	ld	s5,72(sp)
    80005e7e:	6b06                	ld	s6,64(sp)
    80005e80:	7be2                	ld	s7,56(sp)
    80005e82:	7c42                	ld	s8,48(sp)
    80005e84:	7ca2                	ld	s9,40(sp)
    80005e86:	7d02                	ld	s10,32(sp)
    80005e88:	6de2                	ld	s11,24(sp)
    80005e8a:	6129                	addi	sp,sp,192
    80005e8c:	8082                	ret
    release(&pr.lock);
    80005e8e:	00020517          	auipc	a0,0x20
    80005e92:	35a50513          	addi	a0,a0,858 # 800261e8 <pr>
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	39a080e7          	jalr	922(ra) # 80006230 <release>
}
    80005e9e:	bfc9                	j	80005e70 <printf+0x1b0>

0000000080005ea0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ea0:	1141                	addi	sp,sp,-16
    80005ea2:	e406                	sd	ra,8(sp)
    80005ea4:	e022                	sd	s0,0(sp)
    80005ea6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ea8:	100007b7          	lui	a5,0x10000
    80005eac:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eb0:	f8000713          	li	a4,-128
    80005eb4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005eb8:	470d                	li	a4,3
    80005eba:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ebe:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ec2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ec6:	469d                	li	a3,7
    80005ec8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ecc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ed0:	00003597          	auipc	a1,0x3
    80005ed4:	92058593          	addi	a1,a1,-1760 # 800087f0 <digits+0x18>
    80005ed8:	00020517          	auipc	a0,0x20
    80005edc:	33050513          	addi	a0,a0,816 # 80026208 <uart_tx_lock>
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	20c080e7          	jalr	524(ra) # 800060ec <initlock>
}
    80005ee8:	60a2                	ld	ra,8(sp)
    80005eea:	6402                	ld	s0,0(sp)
    80005eec:	0141                	addi	sp,sp,16
    80005eee:	8082                	ret

0000000080005ef0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ef0:	1101                	addi	sp,sp,-32
    80005ef2:	ec06                	sd	ra,24(sp)
    80005ef4:	e822                	sd	s0,16(sp)
    80005ef6:	e426                	sd	s1,8(sp)
    80005ef8:	1000                	addi	s0,sp,32
    80005efa:	84aa                	mv	s1,a0
  push_off();
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	234080e7          	jalr	564(ra) # 80006130 <push_off>

  if(panicked){
    80005f04:	00003797          	auipc	a5,0x3
    80005f08:	1187a783          	lw	a5,280(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f0c:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f10:	c391                	beqz	a5,80005f14 <uartputc_sync+0x24>
    for(;;)
    80005f12:	a001                	j	80005f12 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f14:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f18:	0207f793          	andi	a5,a5,32
    80005f1c:	dfe5                	beqz	a5,80005f14 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f1e:	0ff4f513          	zext.b	a0,s1
    80005f22:	100007b7          	lui	a5,0x10000
    80005f26:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	2a6080e7          	jalr	678(ra) # 800061d0 <pop_off>
}
    80005f32:	60e2                	ld	ra,24(sp)
    80005f34:	6442                	ld	s0,16(sp)
    80005f36:	64a2                	ld	s1,8(sp)
    80005f38:	6105                	addi	sp,sp,32
    80005f3a:	8082                	ret

0000000080005f3c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f3c:	00003797          	auipc	a5,0x3
    80005f40:	0e47b783          	ld	a5,228(a5) # 80009020 <uart_tx_r>
    80005f44:	00003717          	auipc	a4,0x3
    80005f48:	0e473703          	ld	a4,228(a4) # 80009028 <uart_tx_w>
    80005f4c:	06f70a63          	beq	a4,a5,80005fc0 <uartstart+0x84>
{
    80005f50:	7139                	addi	sp,sp,-64
    80005f52:	fc06                	sd	ra,56(sp)
    80005f54:	f822                	sd	s0,48(sp)
    80005f56:	f426                	sd	s1,40(sp)
    80005f58:	f04a                	sd	s2,32(sp)
    80005f5a:	ec4e                	sd	s3,24(sp)
    80005f5c:	e852                	sd	s4,16(sp)
    80005f5e:	e456                	sd	s5,8(sp)
    80005f60:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f62:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f66:	00020a17          	auipc	s4,0x20
    80005f6a:	2a2a0a13          	addi	s4,s4,674 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f6e:	00003497          	auipc	s1,0x3
    80005f72:	0b248493          	addi	s1,s1,178 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f76:	00003997          	auipc	s3,0x3
    80005f7a:	0b298993          	addi	s3,s3,178 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f82:	02077713          	andi	a4,a4,32
    80005f86:	c705                	beqz	a4,80005fae <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f88:	01f7f713          	andi	a4,a5,31
    80005f8c:	9752                	add	a4,a4,s4
    80005f8e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f92:	0785                	addi	a5,a5,1
    80005f94:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f96:	8526                	mv	a0,s1
    80005f98:	ffffb097          	auipc	ra,0xffffb
    80005f9c:	70c080e7          	jalr	1804(ra) # 800016a4 <wakeup>
    
    WriteReg(THR, c);
    80005fa0:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fa4:	609c                	ld	a5,0(s1)
    80005fa6:	0009b703          	ld	a4,0(s3)
    80005faa:	fcf71ae3          	bne	a4,a5,80005f7e <uartstart+0x42>
  }
}
    80005fae:	70e2                	ld	ra,56(sp)
    80005fb0:	7442                	ld	s0,48(sp)
    80005fb2:	74a2                	ld	s1,40(sp)
    80005fb4:	7902                	ld	s2,32(sp)
    80005fb6:	69e2                	ld	s3,24(sp)
    80005fb8:	6a42                	ld	s4,16(sp)
    80005fba:	6aa2                	ld	s5,8(sp)
    80005fbc:	6121                	addi	sp,sp,64
    80005fbe:	8082                	ret
    80005fc0:	8082                	ret

0000000080005fc2 <uartputc>:
{
    80005fc2:	7179                	addi	sp,sp,-48
    80005fc4:	f406                	sd	ra,40(sp)
    80005fc6:	f022                	sd	s0,32(sp)
    80005fc8:	ec26                	sd	s1,24(sp)
    80005fca:	e84a                	sd	s2,16(sp)
    80005fcc:	e44e                	sd	s3,8(sp)
    80005fce:	e052                	sd	s4,0(sp)
    80005fd0:	1800                	addi	s0,sp,48
    80005fd2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fd4:	00020517          	auipc	a0,0x20
    80005fd8:	23450513          	addi	a0,a0,564 # 80026208 <uart_tx_lock>
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	1a0080e7          	jalr	416(ra) # 8000617c <acquire>
  if(panicked){
    80005fe4:	00003797          	auipc	a5,0x3
    80005fe8:	0387a783          	lw	a5,56(a5) # 8000901c <panicked>
    80005fec:	c391                	beqz	a5,80005ff0 <uartputc+0x2e>
    for(;;)
    80005fee:	a001                	j	80005fee <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ff0:	00003717          	auipc	a4,0x3
    80005ff4:	03873703          	ld	a4,56(a4) # 80009028 <uart_tx_w>
    80005ff8:	00003797          	auipc	a5,0x3
    80005ffc:	0287b783          	ld	a5,40(a5) # 80009020 <uart_tx_r>
    80006000:	02078793          	addi	a5,a5,32
    80006004:	02e79b63          	bne	a5,a4,8000603a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006008:	00020997          	auipc	s3,0x20
    8000600c:	20098993          	addi	s3,s3,512 # 80026208 <uart_tx_lock>
    80006010:	00003497          	auipc	s1,0x3
    80006014:	01048493          	addi	s1,s1,16 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006018:	00003917          	auipc	s2,0x3
    8000601c:	01090913          	addi	s2,s2,16 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006020:	85ce                	mv	a1,s3
    80006022:	8526                	mv	a0,s1
    80006024:	ffffb097          	auipc	ra,0xffffb
    80006028:	4f4080e7          	jalr	1268(ra) # 80001518 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000602c:	00093703          	ld	a4,0(s2)
    80006030:	609c                	ld	a5,0(s1)
    80006032:	02078793          	addi	a5,a5,32
    80006036:	fee785e3          	beq	a5,a4,80006020 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000603a:	00020497          	auipc	s1,0x20
    8000603e:	1ce48493          	addi	s1,s1,462 # 80026208 <uart_tx_lock>
    80006042:	01f77793          	andi	a5,a4,31
    80006046:	97a6                	add	a5,a5,s1
    80006048:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000604c:	0705                	addi	a4,a4,1
    8000604e:	00003797          	auipc	a5,0x3
    80006052:	fce7bd23          	sd	a4,-38(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	ee6080e7          	jalr	-282(ra) # 80005f3c <uartstart>
      release(&uart_tx_lock);
    8000605e:	8526                	mv	a0,s1
    80006060:	00000097          	auipc	ra,0x0
    80006064:	1d0080e7          	jalr	464(ra) # 80006230 <release>
}
    80006068:	70a2                	ld	ra,40(sp)
    8000606a:	7402                	ld	s0,32(sp)
    8000606c:	64e2                	ld	s1,24(sp)
    8000606e:	6942                	ld	s2,16(sp)
    80006070:	69a2                	ld	s3,8(sp)
    80006072:	6a02                	ld	s4,0(sp)
    80006074:	6145                	addi	sp,sp,48
    80006076:	8082                	ret

0000000080006078 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006078:	1141                	addi	sp,sp,-16
    8000607a:	e422                	sd	s0,8(sp)
    8000607c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006086:	8b85                	andi	a5,a5,1
    80006088:	cb81                	beqz	a5,80006098 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000608a:	100007b7          	lui	a5,0x10000
    8000608e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006092:	6422                	ld	s0,8(sp)
    80006094:	0141                	addi	sp,sp,16
    80006096:	8082                	ret
    return -1;
    80006098:	557d                	li	a0,-1
    8000609a:	bfe5                	j	80006092 <uartgetc+0x1a>

000000008000609c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000609c:	1101                	addi	sp,sp,-32
    8000609e:	ec06                	sd	ra,24(sp)
    800060a0:	e822                	sd	s0,16(sp)
    800060a2:	e426                	sd	s1,8(sp)
    800060a4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060a6:	54fd                	li	s1,-1
    800060a8:	a029                	j	800060b2 <uartintr+0x16>
      break;
    consoleintr(c);
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	8b4080e7          	jalr	-1868(ra) # 8000595e <consoleintr>
    int c = uartgetc();
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	fc6080e7          	jalr	-58(ra) # 80006078 <uartgetc>
    if(c == -1)
    800060ba:	fe9518e3          	bne	a0,s1,800060aa <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060be:	00020497          	auipc	s1,0x20
    800060c2:	14a48493          	addi	s1,s1,330 # 80026208 <uart_tx_lock>
    800060c6:	8526                	mv	a0,s1
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	0b4080e7          	jalr	180(ra) # 8000617c <acquire>
  uartstart();
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	e6c080e7          	jalr	-404(ra) # 80005f3c <uartstart>
  release(&uart_tx_lock);
    800060d8:	8526                	mv	a0,s1
    800060da:	00000097          	auipc	ra,0x0
    800060de:	156080e7          	jalr	342(ra) # 80006230 <release>
}
    800060e2:	60e2                	ld	ra,24(sp)
    800060e4:	6442                	ld	s0,16(sp)
    800060e6:	64a2                	ld	s1,8(sp)
    800060e8:	6105                	addi	sp,sp,32
    800060ea:	8082                	ret

00000000800060ec <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060ec:	1141                	addi	sp,sp,-16
    800060ee:	e422                	sd	s0,8(sp)
    800060f0:	0800                	addi	s0,sp,16
  lk->name = name;
    800060f2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060f4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060f8:	00053823          	sd	zero,16(a0)
}
    800060fc:	6422                	ld	s0,8(sp)
    800060fe:	0141                	addi	sp,sp,16
    80006100:	8082                	ret

0000000080006102 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006102:	411c                	lw	a5,0(a0)
    80006104:	e399                	bnez	a5,8000610a <holding+0x8>
    80006106:	4501                	li	a0,0
  return r;
}
    80006108:	8082                	ret
{
    8000610a:	1101                	addi	sp,sp,-32
    8000610c:	ec06                	sd	ra,24(sp)
    8000610e:	e822                	sd	s0,16(sp)
    80006110:	e426                	sd	s1,8(sp)
    80006112:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006114:	6904                	ld	s1,16(a0)
    80006116:	ffffb097          	auipc	ra,0xffffb
    8000611a:	d12080e7          	jalr	-750(ra) # 80000e28 <mycpu>
    8000611e:	40a48533          	sub	a0,s1,a0
    80006122:	00153513          	seqz	a0,a0
}
    80006126:	60e2                	ld	ra,24(sp)
    80006128:	6442                	ld	s0,16(sp)
    8000612a:	64a2                	ld	s1,8(sp)
    8000612c:	6105                	addi	sp,sp,32
    8000612e:	8082                	ret

0000000080006130 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006130:	1101                	addi	sp,sp,-32
    80006132:	ec06                	sd	ra,24(sp)
    80006134:	e822                	sd	s0,16(sp)
    80006136:	e426                	sd	s1,8(sp)
    80006138:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000613a:	100024f3          	csrr	s1,sstatus
    8000613e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006142:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006144:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006148:	ffffb097          	auipc	ra,0xffffb
    8000614c:	ce0080e7          	jalr	-800(ra) # 80000e28 <mycpu>
    80006150:	5d3c                	lw	a5,120(a0)
    80006152:	cf89                	beqz	a5,8000616c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006154:	ffffb097          	auipc	ra,0xffffb
    80006158:	cd4080e7          	jalr	-812(ra) # 80000e28 <mycpu>
    8000615c:	5d3c                	lw	a5,120(a0)
    8000615e:	2785                	addiw	a5,a5,1
    80006160:	dd3c                	sw	a5,120(a0)
}
    80006162:	60e2                	ld	ra,24(sp)
    80006164:	6442                	ld	s0,16(sp)
    80006166:	64a2                	ld	s1,8(sp)
    80006168:	6105                	addi	sp,sp,32
    8000616a:	8082                	ret
    mycpu()->intena = old;
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	cbc080e7          	jalr	-836(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006174:	8085                	srli	s1,s1,0x1
    80006176:	8885                	andi	s1,s1,1
    80006178:	dd64                	sw	s1,124(a0)
    8000617a:	bfe9                	j	80006154 <push_off+0x24>

000000008000617c <acquire>:
{
    8000617c:	1101                	addi	sp,sp,-32
    8000617e:	ec06                	sd	ra,24(sp)
    80006180:	e822                	sd	s0,16(sp)
    80006182:	e426                	sd	s1,8(sp)
    80006184:	1000                	addi	s0,sp,32
    80006186:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	fa8080e7          	jalr	-88(ra) # 80006130 <push_off>
  if(holding(lk))
    80006190:	8526                	mv	a0,s1
    80006192:	00000097          	auipc	ra,0x0
    80006196:	f70080e7          	jalr	-144(ra) # 80006102 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000619a:	4705                	li	a4,1
  if(holding(lk))
    8000619c:	e115                	bnez	a0,800061c0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000619e:	87ba                	mv	a5,a4
    800061a0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061a4:	2781                	sext.w	a5,a5
    800061a6:	ffe5                	bnez	a5,8000619e <acquire+0x22>
  __sync_synchronize();
    800061a8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	c7c080e7          	jalr	-900(ra) # 80000e28 <mycpu>
    800061b4:	e888                	sd	a0,16(s1)
}
    800061b6:	60e2                	ld	ra,24(sp)
    800061b8:	6442                	ld	s0,16(sp)
    800061ba:	64a2                	ld	s1,8(sp)
    800061bc:	6105                	addi	sp,sp,32
    800061be:	8082                	ret
    panic("acquire");
    800061c0:	00002517          	auipc	a0,0x2
    800061c4:	63850513          	addi	a0,a0,1592 # 800087f8 <digits+0x20>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	aa6080e7          	jalr	-1370(ra) # 80005c6e <panic>

00000000800061d0 <pop_off>:

void
pop_off(void)
{
    800061d0:	1141                	addi	sp,sp,-16
    800061d2:	e406                	sd	ra,8(sp)
    800061d4:	e022                	sd	s0,0(sp)
    800061d6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061d8:	ffffb097          	auipc	ra,0xffffb
    800061dc:	c50080e7          	jalr	-944(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061e6:	e78d                	bnez	a5,80006210 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061e8:	5d3c                	lw	a5,120(a0)
    800061ea:	02f05b63          	blez	a5,80006220 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061ee:	37fd                	addiw	a5,a5,-1
    800061f0:	0007871b          	sext.w	a4,a5
    800061f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061f6:	eb09                	bnez	a4,80006208 <pop_off+0x38>
    800061f8:	5d7c                	lw	a5,124(a0)
    800061fa:	c799                	beqz	a5,80006208 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006200:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006204:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006208:	60a2                	ld	ra,8(sp)
    8000620a:	6402                	ld	s0,0(sp)
    8000620c:	0141                	addi	sp,sp,16
    8000620e:	8082                	ret
    panic("pop_off - interruptible");
    80006210:	00002517          	auipc	a0,0x2
    80006214:	5f050513          	addi	a0,a0,1520 # 80008800 <digits+0x28>
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	a56080e7          	jalr	-1450(ra) # 80005c6e <panic>
    panic("pop_off");
    80006220:	00002517          	auipc	a0,0x2
    80006224:	5f850513          	addi	a0,a0,1528 # 80008818 <digits+0x40>
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	a46080e7          	jalr	-1466(ra) # 80005c6e <panic>

0000000080006230 <release>:
{
    80006230:	1101                	addi	sp,sp,-32
    80006232:	ec06                	sd	ra,24(sp)
    80006234:	e822                	sd	s0,16(sp)
    80006236:	e426                	sd	s1,8(sp)
    80006238:	1000                	addi	s0,sp,32
    8000623a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	ec6080e7          	jalr	-314(ra) # 80006102 <holding>
    80006244:	c115                	beqz	a0,80006268 <release+0x38>
  lk->cpu = 0;
    80006246:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000624a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000624e:	0f50000f          	fence	iorw,ow
    80006252:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	f7a080e7          	jalr	-134(ra) # 800061d0 <pop_off>
}
    8000625e:	60e2                	ld	ra,24(sp)
    80006260:	6442                	ld	s0,16(sp)
    80006262:	64a2                	ld	s1,8(sp)
    80006264:	6105                	addi	sp,sp,32
    80006266:	8082                	ret
    panic("release");
    80006268:	00002517          	auipc	a0,0x2
    8000626c:	5b850513          	addi	a0,a0,1464 # 80008820 <digits+0x48>
    80006270:	00000097          	auipc	ra,0x0
    80006274:	9fe080e7          	jalr	-1538(ra) # 80005c6e <panic>
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
