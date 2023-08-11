
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4d1050ef          	jal	ra,80005ce6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	22e080e7          	jalr	558(ra) # 8000027c <memset>

  r = (struct run*)pa;
  
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	614080e7          	jalr	1556(ra) # 8000666a <push_off>
  int cpuID = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	ecc080e7          	jalr	-308(ra) # 80000f2a <cpuid>
  acquire(&(KemArray[cpuID].lock));
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 80009030 <KemArray>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	63a080e7          	jalr	1594(ra) # 800066b6 <acquire>
  r->next = KemArray[cpuID].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  KemArray[cpuID].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&(KemArray[cpuID].lock));
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	6f6080e7          	jalr	1782(ra) # 80006786 <release>
  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	68e080e7          	jalr	1678(ra) # 80006726 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	0da080e7          	jalr	218(ra) # 80006194 <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	00e504b3          	add	s1,a0,a4
    800000dc:	777d                	lui	a4,0xfffff
    800000de:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3c>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x2a>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7179                	addi	sp,sp,-48
    80000110:	f406                	sd	ra,40(sp)
    80000112:	f022                	sd	s0,32(sp)
    80000114:	ec26                	sd	s1,24(sp)
    80000116:	e84a                	sd	s2,16(sp)
    80000118:	e44e                	sd	s3,8(sp)
    8000011a:	1800                	addi	s0,sp,48
 for(int i=0;i<NCPU;i++){
    8000011c:	00009497          	auipc	s1,0x9
    80000120:	f1448493          	addi	s1,s1,-236 # 80009030 <KemArray>
    80000124:	00009997          	auipc	s3,0x9
    80000128:	04c98993          	addi	s3,s3,76 # 80009170 <pid_lock>
  initlock(&(KemArray[i].lock), "kmem");
    8000012c:	00008917          	auipc	s2,0x8
    80000130:	eec90913          	addi	s2,s2,-276 # 80008018 <etext+0x18>
    80000134:	85ca                	mv	a1,s2
    80000136:	8526                	mv	a0,s1
    80000138:	00006097          	auipc	ra,0x6
    8000013c:	6fa080e7          	jalr	1786(ra) # 80006832 <initlock>
 for(int i=0;i<NCPU;i++){
    80000140:	02848493          	addi	s1,s1,40
    80000144:	ff3498e3          	bne	s1,s3,80000134 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    80000148:	45c5                	li	a1,17
    8000014a:	05ee                	slli	a1,a1,0x1b
    8000014c:	0002b517          	auipc	a0,0x2b
    80000150:	0fc50513          	addi	a0,a0,252 # 8002b248 <end>
    80000154:	00000097          	auipc	ra,0x0
    80000158:	f6e080e7          	jalr	-146(ra) # 800000c2 <freerange>
}
    8000015c:	70a2                	ld	ra,40(sp)
    8000015e:	7402                	ld	s0,32(sp)
    80000160:	64e2                	ld	s1,24(sp)
    80000162:	6942                	ld	s2,16(sp)
    80000164:	69a2                	ld	s3,8(sp)
    80000166:	6145                	addi	sp,sp,48
    80000168:	8082                	ret

000000008000016a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016a:	7139                	addi	sp,sp,-64
    8000016c:	fc06                	sd	ra,56(sp)
    8000016e:	f822                	sd	s0,48(sp)
    80000170:	f426                	sd	s1,40(sp)
    80000172:	f04a                	sd	s2,32(sp)
    80000174:	ec4e                	sd	s3,24(sp)
    80000176:	e852                	sd	s4,16(sp)
    80000178:	e456                	sd	s5,8(sp)
    8000017a:	e05a                	sd	s6,0(sp)
    8000017c:	0080                	addi	s0,sp,64
  struct run *r;
  
  push_off();
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	4ec080e7          	jalr	1260(ra) # 8000666a <push_off>
  int cpuID = cpuid();
    80000186:	00001097          	auipc	ra,0x1
    8000018a:	da4080e7          	jalr	-604(ra) # 80000f2a <cpuid>
    8000018e:	84aa                	mv	s1,a0
  acquire(&(KemArray[cpuID].lock));
    80000190:	00251793          	slli	a5,a0,0x2
    80000194:	97aa                	add	a5,a5,a0
    80000196:	078e                	slli	a5,a5,0x3
    80000198:	00009917          	auipc	s2,0x9
    8000019c:	e9890913          	addi	s2,s2,-360 # 80009030 <KemArray>
    800001a0:	993e                	add	s2,s2,a5
    800001a2:	854a                	mv	a0,s2
    800001a4:	00006097          	auipc	ra,0x6
    800001a8:	512080e7          	jalr	1298(ra) # 800066b6 <acquire>
  r = KemArray[cpuID].freelist;
    800001ac:	02093983          	ld	s3,32(s2)
  if(r){
    800001b0:	04098163          	beqz	s3,800001f2 <kalloc+0x88>
    KemArray[cpuID].freelist = r->next;
    800001b4:	0009b683          	ld	a3,0(s3)
    800001b8:	02d93023          	sd	a3,32(s2)
      break;
      }
     }
    }
      
  release(&(KemArray[cpuID].lock));
    800001bc:	854a                	mv	a0,s2
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	5c8080e7          	jalr	1480(ra) # 80006786 <release>
  pop_off();
    800001c6:	00006097          	auipc	ra,0x6
    800001ca:	560080e7          	jalr	1376(ra) # 80006726 <pop_off>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001ce:	6605                	lui	a2,0x1
    800001d0:	4595                	li	a1,5
    800001d2:	854e                	mv	a0,s3
    800001d4:	00000097          	auipc	ra,0x0
    800001d8:	0a8080e7          	jalr	168(ra) # 8000027c <memset>
  return (void*)r;
}
    800001dc:	854e                	mv	a0,s3
    800001de:	70e2                	ld	ra,56(sp)
    800001e0:	7442                	ld	s0,48(sp)
    800001e2:	74a2                	ld	s1,40(sp)
    800001e4:	7902                	ld	s2,32(sp)
    800001e6:	69e2                	ld	s3,24(sp)
    800001e8:	6a42                	ld	s4,16(sp)
    800001ea:	6aa2                	ld	s5,8(sp)
    800001ec:	6b02                	ld	s6,0(sp)
    800001ee:	6121                	addi	sp,sp,64
    800001f0:	8082                	ret
    for (int i = (cpuID+1)%NCPU,j=0;j<NCPU-1;i=(i+1)%NCPU,j++){
    800001f2:	2485                	addiw	s1,s1,1
    800001f4:	41f4d79b          	sraiw	a5,s1,0x1f
    800001f8:	01d7d79b          	srliw	a5,a5,0x1d
    800001fc:	9cbd                	addw	s1,s1,a5
    800001fe:	889d                	andi	s1,s1,7
    80000200:	9c9d                	subw	s1,s1,a5
    80000202:	471d                	li	a4,7
     if(KemArray[i].freelist){
    80000204:	00009697          	auipc	a3,0x9
    80000208:	e2c68693          	addi	a3,a3,-468 # 80009030 <KemArray>
    8000020c:	00249793          	slli	a5,s1,0x2
    80000210:	97a6                	add	a5,a5,s1
    80000212:	078e                	slli	a5,a5,0x3
    80000214:	97b6                	add	a5,a5,a3
    80000216:	0207b983          	ld	s3,32(a5)
    8000021a:	02099663          	bnez	s3,80000246 <kalloc+0xdc>
    for (int i = (cpuID+1)%NCPU,j=0;j<NCPU-1;i=(i+1)%NCPU,j++){
    8000021e:	2485                	addiw	s1,s1,1
    80000220:	41f4d79b          	sraiw	a5,s1,0x1f
    80000224:	01d7d79b          	srliw	a5,a5,0x1d
    80000228:	9cbd                	addw	s1,s1,a5
    8000022a:	889d                	andi	s1,s1,7
    8000022c:	9c9d                	subw	s1,s1,a5
    8000022e:	377d                	addiw	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd3db7>
    80000230:	ff71                	bnez	a4,8000020c <kalloc+0xa2>
  release(&(KemArray[cpuID].lock));
    80000232:	854a                	mv	a0,s2
    80000234:	00006097          	auipc	ra,0x6
    80000238:	552080e7          	jalr	1362(ra) # 80006786 <release>
  pop_off();
    8000023c:	00006097          	auipc	ra,0x6
    80000240:	4ea080e7          	jalr	1258(ra) # 80006726 <pop_off>
  if(r)
    80000244:	bf61                	j	800001dc <kalloc+0x72>
      acquire(&(KemArray[i].lock));
    80000246:	00009b17          	auipc	s6,0x9
    8000024a:	deab0b13          	addi	s6,s6,-534 # 80009030 <KemArray>
    8000024e:	00249a93          	slli	s5,s1,0x2
    80000252:	009a8a33          	add	s4,s5,s1
    80000256:	0a0e                	slli	s4,s4,0x3
    80000258:	9a5a                	add	s4,s4,s6
    8000025a:	8552                	mv	a0,s4
    8000025c:	00006097          	auipc	ra,0x6
    80000260:	45a080e7          	jalr	1114(ra) # 800066b6 <acquire>
      r = KemArray[i].freelist;
    80000264:	020a3983          	ld	s3,32(s4) # fffffffffffff020 <end+0xffffffff7ffd3dd8>
      KemArray[i].freelist=r->next;
    80000268:	0009b783          	ld	a5,0(s3)
    8000026c:	02fa3023          	sd	a5,32(s4)
      release(&(KemArray[i].lock));
    80000270:	8552                	mv	a0,s4
    80000272:	00006097          	auipc	ra,0x6
    80000276:	514080e7          	jalr	1300(ra) # 80006786 <release>
      break;
    8000027a:	b789                	j	800001bc <kalloc+0x52>

000000008000027c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e422                	sd	s0,8(sp)
    80000280:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000282:	ca19                	beqz	a2,80000298 <memset+0x1c>
    80000284:	87aa                	mv	a5,a0
    80000286:	1602                	slli	a2,a2,0x20
    80000288:	9201                	srli	a2,a2,0x20
    8000028a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000028e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000292:	0785                	addi	a5,a5,1
    80000294:	fee79de3          	bne	a5,a4,8000028e <memset+0x12>
  }
  return dst;
}
    80000298:	6422                	ld	s0,8(sp)
    8000029a:	0141                	addi	sp,sp,16
    8000029c:	8082                	ret

000000008000029e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000029e:	1141                	addi	sp,sp,-16
    800002a0:	e422                	sd	s0,8(sp)
    800002a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002a4:	ca05                	beqz	a2,800002d4 <memcmp+0x36>
    800002a6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002aa:	1682                	slli	a3,a3,0x20
    800002ac:	9281                	srli	a3,a3,0x20
    800002ae:	0685                	addi	a3,a3,1
    800002b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002b2:	00054783          	lbu	a5,0(a0)
    800002b6:	0005c703          	lbu	a4,0(a1)
    800002ba:	00e79863          	bne	a5,a4,800002ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002be:	0505                	addi	a0,a0,1
    800002c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002c2:	fed518e3          	bne	a0,a3,800002b2 <memcmp+0x14>
  }

  return 0;
    800002c6:	4501                	li	a0,0
    800002c8:	a019                	j	800002ce <memcmp+0x30>
      return *s1 - *s2;
    800002ca:	40e7853b          	subw	a0,a5,a4
}
    800002ce:	6422                	ld	s0,8(sp)
    800002d0:	0141                	addi	sp,sp,16
    800002d2:	8082                	ret
  return 0;
    800002d4:	4501                	li	a0,0
    800002d6:	bfe5                	j	800002ce <memcmp+0x30>

00000000800002d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002d8:	1141                	addi	sp,sp,-16
    800002da:	e422                	sd	s0,8(sp)
    800002dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002de:	c205                	beqz	a2,800002fe <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002e0:	02a5e263          	bltu	a1,a0,80000304 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002e4:	1602                	slli	a2,a2,0x20
    800002e6:	9201                	srli	a2,a2,0x20
    800002e8:	00c587b3          	add	a5,a1,a2
{
    800002ec:	872a                	mv	a4,a0
      *d++ = *s++;
    800002ee:	0585                	addi	a1,a1,1
    800002f0:	0705                	addi	a4,a4,1
    800002f2:	fff5c683          	lbu	a3,-1(a1)
    800002f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002fa:	fef59ae3          	bne	a1,a5,800002ee <memmove+0x16>

  return dst;
}
    800002fe:	6422                	ld	s0,8(sp)
    80000300:	0141                	addi	sp,sp,16
    80000302:	8082                	ret
  if(s < d && s + n > d){
    80000304:	02061693          	slli	a3,a2,0x20
    80000308:	9281                	srli	a3,a3,0x20
    8000030a:	00d58733          	add	a4,a1,a3
    8000030e:	fce57be3          	bgeu	a0,a4,800002e4 <memmove+0xc>
    d += n;
    80000312:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000314:	fff6079b          	addiw	a5,a2,-1
    80000318:	1782                	slli	a5,a5,0x20
    8000031a:	9381                	srli	a5,a5,0x20
    8000031c:	fff7c793          	not	a5,a5
    80000320:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000322:	177d                	addi	a4,a4,-1
    80000324:	16fd                	addi	a3,a3,-1
    80000326:	00074603          	lbu	a2,0(a4)
    8000032a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000032e:	fee79ae3          	bne	a5,a4,80000322 <memmove+0x4a>
    80000332:	b7f1                	j	800002fe <memmove+0x26>

0000000080000334 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000334:	1141                	addi	sp,sp,-16
    80000336:	e406                	sd	ra,8(sp)
    80000338:	e022                	sd	s0,0(sp)
    8000033a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f9c080e7          	jalr	-100(ra) # 800002d8 <memmove>
}
    80000344:	60a2                	ld	ra,8(sp)
    80000346:	6402                	ld	s0,0(sp)
    80000348:	0141                	addi	sp,sp,16
    8000034a:	8082                	ret

000000008000034c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e422                	sd	s0,8(sp)
    80000350:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000352:	ce11                	beqz	a2,8000036e <strncmp+0x22>
    80000354:	00054783          	lbu	a5,0(a0)
    80000358:	cf89                	beqz	a5,80000372 <strncmp+0x26>
    8000035a:	0005c703          	lbu	a4,0(a1)
    8000035e:	00f71a63          	bne	a4,a5,80000372 <strncmp+0x26>
    n--, p++, q++;
    80000362:	367d                	addiw	a2,a2,-1
    80000364:	0505                	addi	a0,a0,1
    80000366:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000368:	f675                	bnez	a2,80000354 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000036a:	4501                	li	a0,0
    8000036c:	a809                	j	8000037e <strncmp+0x32>
    8000036e:	4501                	li	a0,0
    80000370:	a039                	j	8000037e <strncmp+0x32>
  if(n == 0)
    80000372:	ca09                	beqz	a2,80000384 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000374:	00054503          	lbu	a0,0(a0)
    80000378:	0005c783          	lbu	a5,0(a1)
    8000037c:	9d1d                	subw	a0,a0,a5
}
    8000037e:	6422                	ld	s0,8(sp)
    80000380:	0141                	addi	sp,sp,16
    80000382:	8082                	ret
    return 0;
    80000384:	4501                	li	a0,0
    80000386:	bfe5                	j	8000037e <strncmp+0x32>

0000000080000388 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000388:	1141                	addi	sp,sp,-16
    8000038a:	e422                	sd	s0,8(sp)
    8000038c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000038e:	872a                	mv	a4,a0
    80000390:	8832                	mv	a6,a2
    80000392:	367d                	addiw	a2,a2,-1
    80000394:	01005963          	blez	a6,800003a6 <strncpy+0x1e>
    80000398:	0705                	addi	a4,a4,1
    8000039a:	0005c783          	lbu	a5,0(a1)
    8000039e:	fef70fa3          	sb	a5,-1(a4)
    800003a2:	0585                	addi	a1,a1,1
    800003a4:	f7f5                	bnez	a5,80000390 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003a6:	86ba                	mv	a3,a4
    800003a8:	00c05c63          	blez	a2,800003c0 <strncpy+0x38>
    *s++ = 0;
    800003ac:	0685                	addi	a3,a3,1
    800003ae:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003b2:	40d707bb          	subw	a5,a4,a3
    800003b6:	37fd                	addiw	a5,a5,-1
    800003b8:	010787bb          	addw	a5,a5,a6
    800003bc:	fef048e3          	bgtz	a5,800003ac <strncpy+0x24>
  return os;
}
    800003c0:	6422                	ld	s0,8(sp)
    800003c2:	0141                	addi	sp,sp,16
    800003c4:	8082                	ret

00000000800003c6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003c6:	1141                	addi	sp,sp,-16
    800003c8:	e422                	sd	s0,8(sp)
    800003ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003cc:	02c05363          	blez	a2,800003f2 <safestrcpy+0x2c>
    800003d0:	fff6069b          	addiw	a3,a2,-1
    800003d4:	1682                	slli	a3,a3,0x20
    800003d6:	9281                	srli	a3,a3,0x20
    800003d8:	96ae                	add	a3,a3,a1
    800003da:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003dc:	00d58963          	beq	a1,a3,800003ee <safestrcpy+0x28>
    800003e0:	0585                	addi	a1,a1,1
    800003e2:	0785                	addi	a5,a5,1
    800003e4:	fff5c703          	lbu	a4,-1(a1)
    800003e8:	fee78fa3          	sb	a4,-1(a5)
    800003ec:	fb65                	bnez	a4,800003dc <safestrcpy+0x16>
    ;
  *s = 0;
    800003ee:	00078023          	sb	zero,0(a5)
  return os;
}
    800003f2:	6422                	ld	s0,8(sp)
    800003f4:	0141                	addi	sp,sp,16
    800003f6:	8082                	ret

00000000800003f8 <strlen>:

int
strlen(const char *s)
{
    800003f8:	1141                	addi	sp,sp,-16
    800003fa:	e422                	sd	s0,8(sp)
    800003fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003fe:	00054783          	lbu	a5,0(a0)
    80000402:	cf91                	beqz	a5,8000041e <strlen+0x26>
    80000404:	0505                	addi	a0,a0,1
    80000406:	87aa                	mv	a5,a0
    80000408:	4685                	li	a3,1
    8000040a:	9e89                	subw	a3,a3,a0
    8000040c:	00f6853b          	addw	a0,a3,a5
    80000410:	0785                	addi	a5,a5,1
    80000412:	fff7c703          	lbu	a4,-1(a5)
    80000416:	fb7d                	bnez	a4,8000040c <strlen+0x14>
    ;
  return n;
}
    80000418:	6422                	ld	s0,8(sp)
    8000041a:	0141                	addi	sp,sp,16
    8000041c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000041e:	4501                	li	a0,0
    80000420:	bfe5                	j	80000418 <strlen+0x20>

0000000080000422 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000422:	1101                	addi	sp,sp,-32
    80000424:	ec06                	sd	ra,24(sp)
    80000426:	e822                	sd	s0,16(sp)
    80000428:	e426                	sd	s1,8(sp)
    8000042a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000042c:	00001097          	auipc	ra,0x1
    80000430:	afe080e7          	jalr	-1282(ra) # 80000f2a <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000434:	00009497          	auipc	s1,0x9
    80000438:	bcc48493          	addi	s1,s1,-1076 # 80009000 <started>
  if(cpuid() == 0){
    8000043c:	c531                	beqz	a0,80000488 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000043e:	8526                	mv	a0,s1
    80000440:	00006097          	auipc	ra,0x6
    80000444:	488080e7          	jalr	1160(ra) # 800068c8 <lockfree_read4>
    80000448:	d97d                	beqz	a0,8000043e <main+0x1c>
      ;
    __sync_synchronize();
    8000044a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000044e:	00001097          	auipc	ra,0x1
    80000452:	adc080e7          	jalr	-1316(ra) # 80000f2a <cpuid>
    80000456:	85aa                	mv	a1,a0
    80000458:	00008517          	auipc	a0,0x8
    8000045c:	be050513          	addi	a0,a0,-1056 # 80008038 <etext+0x38>
    80000460:	00006097          	auipc	ra,0x6
    80000464:	d7e080e7          	jalr	-642(ra) # 800061de <printf>
    kvminithart();    // turn on paging
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	0e0080e7          	jalr	224(ra) # 80000548 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000470:	00001097          	auipc	ra,0x1
    80000474:	73c080e7          	jalr	1852(ra) # 80001bac <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000478:	00005097          	auipc	ra,0x5
    8000047c:	f18080e7          	jalr	-232(ra) # 80005390 <plicinithart>
  }

  scheduler();        
    80000480:	00001097          	auipc	ra,0x1
    80000484:	fe8080e7          	jalr	-24(ra) # 80001468 <scheduler>
    consoleinit();
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	c1c080e7          	jalr	-996(ra) # 800060a4 <consoleinit>
    statsinit();
    80000490:	00005097          	auipc	ra,0x5
    80000494:	592080e7          	jalr	1426(ra) # 80005a22 <statsinit>
    printfinit();
    80000498:	00006097          	auipc	ra,0x6
    8000049c:	f26080e7          	jalr	-218(ra) # 800063be <printfinit>
    printf("\n");
    800004a0:	00008517          	auipc	a0,0x8
    800004a4:	3d850513          	addi	a0,a0,984 # 80008878 <digits+0x88>
    800004a8:	00006097          	auipc	ra,0x6
    800004ac:	d36080e7          	jalr	-714(ra) # 800061de <printf>
    printf("xv6 kernel is booting\n");
    800004b0:	00008517          	auipc	a0,0x8
    800004b4:	b7050513          	addi	a0,a0,-1168 # 80008020 <etext+0x20>
    800004b8:	00006097          	auipc	ra,0x6
    800004bc:	d26080e7          	jalr	-730(ra) # 800061de <printf>
    printf("\n");
    800004c0:	00008517          	auipc	a0,0x8
    800004c4:	3b850513          	addi	a0,a0,952 # 80008878 <digits+0x88>
    800004c8:	00006097          	auipc	ra,0x6
    800004cc:	d16080e7          	jalr	-746(ra) # 800061de <printf>
    kinit();         // physical page allocator
    800004d0:	00000097          	auipc	ra,0x0
    800004d4:	c3e080e7          	jalr	-962(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    800004d8:	00000097          	auipc	ra,0x0
    800004dc:	322080e7          	jalr	802(ra) # 800007fa <kvminit>
    kvminithart();   // turn on paging
    800004e0:	00000097          	auipc	ra,0x0
    800004e4:	068080e7          	jalr	104(ra) # 80000548 <kvminithart>
    procinit();      // process table
    800004e8:	00001097          	auipc	ra,0x1
    800004ec:	992080e7          	jalr	-1646(ra) # 80000e7a <procinit>
    trapinit();      // trap vectors
    800004f0:	00001097          	auipc	ra,0x1
    800004f4:	694080e7          	jalr	1684(ra) # 80001b84 <trapinit>
    trapinithart();  // install kernel trap vector
    800004f8:	00001097          	auipc	ra,0x1
    800004fc:	6b4080e7          	jalr	1716(ra) # 80001bac <trapinithart>
    plicinit();      // set up interrupt controller
    80000500:	00005097          	auipc	ra,0x5
    80000504:	e7a080e7          	jalr	-390(ra) # 8000537a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000508:	00005097          	auipc	ra,0x5
    8000050c:	e88080e7          	jalr	-376(ra) # 80005390 <plicinithart>
    binit();         // buffer cache
    80000510:	00002097          	auipc	ra,0x2
    80000514:	dde080e7          	jalr	-546(ra) # 800022ee <binit>
    iinit();         // inode table
    80000518:	00002097          	auipc	ra,0x2
    8000051c:	6cc080e7          	jalr	1740(ra) # 80002be4 <iinit>
    fileinit();      // file table
    80000520:	00003097          	auipc	ra,0x3
    80000524:	67e080e7          	jalr	1662(ra) # 80003b9e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000528:	00005097          	auipc	ra,0x5
    8000052c:	f88080e7          	jalr	-120(ra) # 800054b0 <virtio_disk_init>
    userinit();      // first user process
    80000530:	00001097          	auipc	ra,0x1
    80000534:	cfe080e7          	jalr	-770(ra) # 8000122e <userinit>
    __sync_synchronize();
    80000538:	0ff0000f          	fence
    started = 1;
    8000053c:	4785                	li	a5,1
    8000053e:	00009717          	auipc	a4,0x9
    80000542:	acf72123          	sw	a5,-1342(a4) # 80009000 <started>
    80000546:	bf2d                	j	80000480 <main+0x5e>

0000000080000548 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000548:	1141                	addi	sp,sp,-16
    8000054a:	e422                	sd	s0,8(sp)
    8000054c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000054e:	00009797          	auipc	a5,0x9
    80000552:	aba7b783          	ld	a5,-1350(a5) # 80009008 <kernel_pagetable>
    80000556:	83b1                	srli	a5,a5,0xc
    80000558:	577d                	li	a4,-1
    8000055a:	177e                	slli	a4,a4,0x3f
    8000055c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000055e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000562:	12000073          	sfence.vma
  sfence_vma();
}
    80000566:	6422                	ld	s0,8(sp)
    80000568:	0141                	addi	sp,sp,16
    8000056a:	8082                	ret

000000008000056c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000056c:	7139                	addi	sp,sp,-64
    8000056e:	fc06                	sd	ra,56(sp)
    80000570:	f822                	sd	s0,48(sp)
    80000572:	f426                	sd	s1,40(sp)
    80000574:	f04a                	sd	s2,32(sp)
    80000576:	ec4e                	sd	s3,24(sp)
    80000578:	e852                	sd	s4,16(sp)
    8000057a:	e456                	sd	s5,8(sp)
    8000057c:	e05a                	sd	s6,0(sp)
    8000057e:	0080                	addi	s0,sp,64
    80000580:	84aa                	mv	s1,a0
    80000582:	89ae                	mv	s3,a1
    80000584:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000586:	57fd                	li	a5,-1
    80000588:	83e9                	srli	a5,a5,0x1a
    8000058a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000058c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000058e:	04b7f263          	bgeu	a5,a1,800005d2 <walk+0x66>
    panic("walk");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	abe50513          	addi	a0,a0,-1346 # 80008050 <etext+0x50>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	bfa080e7          	jalr	-1030(ra) # 80006194 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005a2:	060a8663          	beqz	s5,8000060e <walk+0xa2>
    800005a6:	00000097          	auipc	ra,0x0
    800005aa:	bc4080e7          	jalr	-1084(ra) # 8000016a <kalloc>
    800005ae:	84aa                	mv	s1,a0
    800005b0:	c529                	beqz	a0,800005fa <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005b2:	6605                	lui	a2,0x1
    800005b4:	4581                	li	a1,0
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	cc6080e7          	jalr	-826(ra) # 8000027c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005be:	00c4d793          	srli	a5,s1,0xc
    800005c2:	07aa                	slli	a5,a5,0xa
    800005c4:	0017e793          	ori	a5,a5,1
    800005c8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005cc:	3a5d                	addiw	s4,s4,-9
    800005ce:	036a0063          	beq	s4,s6,800005ee <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005d2:	0149d933          	srl	s2,s3,s4
    800005d6:	1ff97913          	andi	s2,s2,511
    800005da:	090e                	slli	s2,s2,0x3
    800005dc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005de:	00093483          	ld	s1,0(s2)
    800005e2:	0014f793          	andi	a5,s1,1
    800005e6:	dfd5                	beqz	a5,800005a2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005e8:	80a9                	srli	s1,s1,0xa
    800005ea:	04b2                	slli	s1,s1,0xc
    800005ec:	b7c5                	j	800005cc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005ee:	00c9d513          	srli	a0,s3,0xc
    800005f2:	1ff57513          	andi	a0,a0,511
    800005f6:	050e                	slli	a0,a0,0x3
    800005f8:	9526                	add	a0,a0,s1
}
    800005fa:	70e2                	ld	ra,56(sp)
    800005fc:	7442                	ld	s0,48(sp)
    800005fe:	74a2                	ld	s1,40(sp)
    80000600:	7902                	ld	s2,32(sp)
    80000602:	69e2                	ld	s3,24(sp)
    80000604:	6a42                	ld	s4,16(sp)
    80000606:	6aa2                	ld	s5,8(sp)
    80000608:	6b02                	ld	s6,0(sp)
    8000060a:	6121                	addi	sp,sp,64
    8000060c:	8082                	ret
        return 0;
    8000060e:	4501                	li	a0,0
    80000610:	b7ed                	j	800005fa <walk+0x8e>

0000000080000612 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000612:	57fd                	li	a5,-1
    80000614:	83e9                	srli	a5,a5,0x1a
    80000616:	00b7f463          	bgeu	a5,a1,8000061e <walkaddr+0xc>
    return 0;
    8000061a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000061c:	8082                	ret
{
    8000061e:	1141                	addi	sp,sp,-16
    80000620:	e406                	sd	ra,8(sp)
    80000622:	e022                	sd	s0,0(sp)
    80000624:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000626:	4601                	li	a2,0
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	f44080e7          	jalr	-188(ra) # 8000056c <walk>
  if(pte == 0)
    80000630:	c105                	beqz	a0,80000650 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000632:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000634:	0117f693          	andi	a3,a5,17
    80000638:	4745                	li	a4,17
    return 0;
    8000063a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000063c:	00e68663          	beq	a3,a4,80000648 <walkaddr+0x36>
}
    80000640:	60a2                	ld	ra,8(sp)
    80000642:	6402                	ld	s0,0(sp)
    80000644:	0141                	addi	sp,sp,16
    80000646:	8082                	ret
  pa = PTE2PA(*pte);
    80000648:	83a9                	srli	a5,a5,0xa
    8000064a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000064e:	bfcd                	j	80000640 <walkaddr+0x2e>
    return 0;
    80000650:	4501                	li	a0,0
    80000652:	b7fd                	j	80000640 <walkaddr+0x2e>

0000000080000654 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000654:	715d                	addi	sp,sp,-80
    80000656:	e486                	sd	ra,72(sp)
    80000658:	e0a2                	sd	s0,64(sp)
    8000065a:	fc26                	sd	s1,56(sp)
    8000065c:	f84a                	sd	s2,48(sp)
    8000065e:	f44e                	sd	s3,40(sp)
    80000660:	f052                	sd	s4,32(sp)
    80000662:	ec56                	sd	s5,24(sp)
    80000664:	e85a                	sd	s6,16(sp)
    80000666:	e45e                	sd	s7,8(sp)
    80000668:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000066a:	c639                	beqz	a2,800006b8 <mappages+0x64>
    8000066c:	8aaa                	mv	s5,a0
    8000066e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000670:	777d                	lui	a4,0xfffff
    80000672:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000676:	fff58993          	addi	s3,a1,-1
    8000067a:	99b2                	add	s3,s3,a2
    8000067c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000680:	893e                	mv	s2,a5
    80000682:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000686:	6b85                	lui	s7,0x1
    80000688:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000068c:	4605                	li	a2,1
    8000068e:	85ca                	mv	a1,s2
    80000690:	8556                	mv	a0,s5
    80000692:	00000097          	auipc	ra,0x0
    80000696:	eda080e7          	jalr	-294(ra) # 8000056c <walk>
    8000069a:	cd1d                	beqz	a0,800006d8 <mappages+0x84>
    if(*pte & PTE_V)
    8000069c:	611c                	ld	a5,0(a0)
    8000069e:	8b85                	andi	a5,a5,1
    800006a0:	e785                	bnez	a5,800006c8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006a2:	80b1                	srli	s1,s1,0xc
    800006a4:	04aa                	slli	s1,s1,0xa
    800006a6:	0164e4b3          	or	s1,s1,s6
    800006aa:	0014e493          	ori	s1,s1,1
    800006ae:	e104                	sd	s1,0(a0)
    if(a == last)
    800006b0:	05390063          	beq	s2,s3,800006f0 <mappages+0x9c>
    a += PGSIZE;
    800006b4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006b6:	bfc9                	j	80000688 <mappages+0x34>
    panic("mappages: size");
    800006b8:	00008517          	auipc	a0,0x8
    800006bc:	9a050513          	addi	a0,a0,-1632 # 80008058 <etext+0x58>
    800006c0:	00006097          	auipc	ra,0x6
    800006c4:	ad4080e7          	jalr	-1324(ra) # 80006194 <panic>
      panic("mappages: remap");
    800006c8:	00008517          	auipc	a0,0x8
    800006cc:	9a050513          	addi	a0,a0,-1632 # 80008068 <etext+0x68>
    800006d0:	00006097          	auipc	ra,0x6
    800006d4:	ac4080e7          	jalr	-1340(ra) # 80006194 <panic>
      return -1;
    800006d8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006da:	60a6                	ld	ra,72(sp)
    800006dc:	6406                	ld	s0,64(sp)
    800006de:	74e2                	ld	s1,56(sp)
    800006e0:	7942                	ld	s2,48(sp)
    800006e2:	79a2                	ld	s3,40(sp)
    800006e4:	7a02                	ld	s4,32(sp)
    800006e6:	6ae2                	ld	s5,24(sp)
    800006e8:	6b42                	ld	s6,16(sp)
    800006ea:	6ba2                	ld	s7,8(sp)
    800006ec:	6161                	addi	sp,sp,80
    800006ee:	8082                	ret
  return 0;
    800006f0:	4501                	li	a0,0
    800006f2:	b7e5                	j	800006da <mappages+0x86>

00000000800006f4 <kvmmap>:
{
    800006f4:	1141                	addi	sp,sp,-16
    800006f6:	e406                	sd	ra,8(sp)
    800006f8:	e022                	sd	s0,0(sp)
    800006fa:	0800                	addi	s0,sp,16
    800006fc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006fe:	86b2                	mv	a3,a2
    80000700:	863e                	mv	a2,a5
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f52080e7          	jalr	-174(ra) # 80000654 <mappages>
    8000070a:	e509                	bnez	a0,80000714 <kvmmap+0x20>
}
    8000070c:	60a2                	ld	ra,8(sp)
    8000070e:	6402                	ld	s0,0(sp)
    80000710:	0141                	addi	sp,sp,16
    80000712:	8082                	ret
    panic("kvmmap");
    80000714:	00008517          	auipc	a0,0x8
    80000718:	96450513          	addi	a0,a0,-1692 # 80008078 <etext+0x78>
    8000071c:	00006097          	auipc	ra,0x6
    80000720:	a78080e7          	jalr	-1416(ra) # 80006194 <panic>

0000000080000724 <kvmmake>:
{
    80000724:	1101                	addi	sp,sp,-32
    80000726:	ec06                	sd	ra,24(sp)
    80000728:	e822                	sd	s0,16(sp)
    8000072a:	e426                	sd	s1,8(sp)
    8000072c:	e04a                	sd	s2,0(sp)
    8000072e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000730:	00000097          	auipc	ra,0x0
    80000734:	a3a080e7          	jalr	-1478(ra) # 8000016a <kalloc>
    80000738:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	00000097          	auipc	ra,0x0
    80000742:	b3e080e7          	jalr	-1218(ra) # 8000027c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000746:	4719                	li	a4,6
    80000748:	6685                	lui	a3,0x1
    8000074a:	10000637          	lui	a2,0x10000
    8000074e:	100005b7          	lui	a1,0x10000
    80000752:	8526                	mv	a0,s1
    80000754:	00000097          	auipc	ra,0x0
    80000758:	fa0080e7          	jalr	-96(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000075c:	4719                	li	a4,6
    8000075e:	6685                	lui	a3,0x1
    80000760:	10001637          	lui	a2,0x10001
    80000764:	100015b7          	lui	a1,0x10001
    80000768:	8526                	mv	a0,s1
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	f8a080e7          	jalr	-118(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000772:	4719                	li	a4,6
    80000774:	004006b7          	lui	a3,0x400
    80000778:	0c000637          	lui	a2,0xc000
    8000077c:	0c0005b7          	lui	a1,0xc000
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	f72080e7          	jalr	-142(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000078a:	00008917          	auipc	s2,0x8
    8000078e:	87690913          	addi	s2,s2,-1930 # 80008000 <etext>
    80000792:	4729                	li	a4,10
    80000794:	80008697          	auipc	a3,0x80008
    80000798:	86c68693          	addi	a3,a3,-1940 # 8000 <_entry-0x7fff8000>
    8000079c:	4605                	li	a2,1
    8000079e:	067e                	slli	a2,a2,0x1f
    800007a0:	85b2                	mv	a1,a2
    800007a2:	8526                	mv	a0,s1
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	f50080e7          	jalr	-176(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007ac:	4719                	li	a4,6
    800007ae:	46c5                	li	a3,17
    800007b0:	06ee                	slli	a3,a3,0x1b
    800007b2:	412686b3          	sub	a3,a3,s2
    800007b6:	864a                	mv	a2,s2
    800007b8:	85ca                	mv	a1,s2
    800007ba:	8526                	mv	a0,s1
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	f38080e7          	jalr	-200(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007c4:	4729                	li	a4,10
    800007c6:	6685                	lui	a3,0x1
    800007c8:	00007617          	auipc	a2,0x7
    800007cc:	83860613          	addi	a2,a2,-1992 # 80007000 <_trampoline>
    800007d0:	040005b7          	lui	a1,0x4000
    800007d4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007d6:	05b2                	slli	a1,a1,0xc
    800007d8:	8526                	mv	a0,s1
    800007da:	00000097          	auipc	ra,0x0
    800007de:	f1a080e7          	jalr	-230(ra) # 800006f4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007e2:	8526                	mv	a0,s1
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	600080e7          	jalr	1536(ra) # 80000de4 <proc_mapstacks>
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6902                	ld	s2,0(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <kvminit>:
{
    800007fa:	1141                	addi	sp,sp,-16
    800007fc:	e406                	sd	ra,8(sp)
    800007fe:	e022                	sd	s0,0(sp)
    80000800:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	f22080e7          	jalr	-222(ra) # 80000724 <kvmmake>
    8000080a:	00008797          	auipc	a5,0x8
    8000080e:	7ea7bf23          	sd	a0,2046(a5) # 80009008 <kernel_pagetable>
}
    80000812:	60a2                	ld	ra,8(sp)
    80000814:	6402                	ld	s0,0(sp)
    80000816:	0141                	addi	sp,sp,16
    80000818:	8082                	ret

000000008000081a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000081a:	715d                	addi	sp,sp,-80
    8000081c:	e486                	sd	ra,72(sp)
    8000081e:	e0a2                	sd	s0,64(sp)
    80000820:	fc26                	sd	s1,56(sp)
    80000822:	f84a                	sd	s2,48(sp)
    80000824:	f44e                	sd	s3,40(sp)
    80000826:	f052                	sd	s4,32(sp)
    80000828:	ec56                	sd	s5,24(sp)
    8000082a:	e85a                	sd	s6,16(sp)
    8000082c:	e45e                	sd	s7,8(sp)
    8000082e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000830:	03459793          	slli	a5,a1,0x34
    80000834:	e795                	bnez	a5,80000860 <uvmunmap+0x46>
    80000836:	8a2a                	mv	s4,a0
    80000838:	892e                	mv	s2,a1
    8000083a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000083c:	0632                	slli	a2,a2,0xc
    8000083e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000842:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000844:	6b05                	lui	s6,0x1
    80000846:	0735e263          	bltu	a1,s3,800008aa <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000084a:	60a6                	ld	ra,72(sp)
    8000084c:	6406                	ld	s0,64(sp)
    8000084e:	74e2                	ld	s1,56(sp)
    80000850:	7942                	ld	s2,48(sp)
    80000852:	79a2                	ld	s3,40(sp)
    80000854:	7a02                	ld	s4,32(sp)
    80000856:	6ae2                	ld	s5,24(sp)
    80000858:	6b42                	ld	s6,16(sp)
    8000085a:	6ba2                	ld	s7,8(sp)
    8000085c:	6161                	addi	sp,sp,80
    8000085e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	82050513          	addi	a0,a0,-2016 # 80008080 <etext+0x80>
    80000868:	00006097          	auipc	ra,0x6
    8000086c:	92c080e7          	jalr	-1748(ra) # 80006194 <panic>
      panic("uvmunmap: walk");
    80000870:	00008517          	auipc	a0,0x8
    80000874:	82850513          	addi	a0,a0,-2008 # 80008098 <etext+0x98>
    80000878:	00006097          	auipc	ra,0x6
    8000087c:	91c080e7          	jalr	-1764(ra) # 80006194 <panic>
      panic("uvmunmap: not mapped");
    80000880:	00008517          	auipc	a0,0x8
    80000884:	82850513          	addi	a0,a0,-2008 # 800080a8 <etext+0xa8>
    80000888:	00006097          	auipc	ra,0x6
    8000088c:	90c080e7          	jalr	-1780(ra) # 80006194 <panic>
      panic("uvmunmap: not a leaf");
    80000890:	00008517          	auipc	a0,0x8
    80000894:	83050513          	addi	a0,a0,-2000 # 800080c0 <etext+0xc0>
    80000898:	00006097          	auipc	ra,0x6
    8000089c:	8fc080e7          	jalr	-1796(ra) # 80006194 <panic>
    *pte = 0;
    800008a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a4:	995a                	add	s2,s2,s6
    800008a6:	fb3972e3          	bgeu	s2,s3,8000084a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008aa:	4601                	li	a2,0
    800008ac:	85ca                	mv	a1,s2
    800008ae:	8552                	mv	a0,s4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	cbc080e7          	jalr	-836(ra) # 8000056c <walk>
    800008b8:	84aa                	mv	s1,a0
    800008ba:	d95d                	beqz	a0,80000870 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008bc:	6108                	ld	a0,0(a0)
    800008be:	00157793          	andi	a5,a0,1
    800008c2:	dfdd                	beqz	a5,80000880 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c4:	3ff57793          	andi	a5,a0,1023
    800008c8:	fd7784e3          	beq	a5,s7,80000890 <uvmunmap+0x76>
    if(do_free){
    800008cc:	fc0a8ae3          	beqz	s5,800008a0 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008d0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008d2:	0532                	slli	a0,a0,0xc
    800008d4:	fffff097          	auipc	ra,0xfffff
    800008d8:	748080e7          	jalr	1864(ra) # 8000001c <kfree>
    800008dc:	b7d1                	j	800008a0 <uvmunmap+0x86>

00000000800008de <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008de:	1101                	addi	sp,sp,-32
    800008e0:	ec06                	sd	ra,24(sp)
    800008e2:	e822                	sd	s0,16(sp)
    800008e4:	e426                	sd	s1,8(sp)
    800008e6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	882080e7          	jalr	-1918(ra) # 8000016a <kalloc>
    800008f0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008f2:	c519                	beqz	a0,80000900 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	984080e7          	jalr	-1660(ra) # 8000027c <memset>
  return pagetable;
}
    80000900:	8526                	mv	a0,s1
    80000902:	60e2                	ld	ra,24(sp)
    80000904:	6442                	ld	s0,16(sp)
    80000906:	64a2                	ld	s1,8(sp)
    80000908:	6105                	addi	sp,sp,32
    8000090a:	8082                	ret

000000008000090c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000090c:	7179                	addi	sp,sp,-48
    8000090e:	f406                	sd	ra,40(sp)
    80000910:	f022                	sd	s0,32(sp)
    80000912:	ec26                	sd	s1,24(sp)
    80000914:	e84a                	sd	s2,16(sp)
    80000916:	e44e                	sd	s3,8(sp)
    80000918:	e052                	sd	s4,0(sp)
    8000091a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000091c:	6785                	lui	a5,0x1
    8000091e:	04f67863          	bgeu	a2,a5,8000096e <uvminit+0x62>
    80000922:	8a2a                	mv	s4,a0
    80000924:	89ae                	mv	s3,a1
    80000926:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	842080e7          	jalr	-1982(ra) # 8000016a <kalloc>
    80000930:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	4581                	li	a1,0
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	946080e7          	jalr	-1722(ra) # 8000027c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000093e:	4779                	li	a4,30
    80000940:	86ca                	mv	a3,s2
    80000942:	6605                	lui	a2,0x1
    80000944:	4581                	li	a1,0
    80000946:	8552                	mv	a0,s4
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	d0c080e7          	jalr	-756(ra) # 80000654 <mappages>
  memmove(mem, src, sz);
    80000950:	8626                	mv	a2,s1
    80000952:	85ce                	mv	a1,s3
    80000954:	854a                	mv	a0,s2
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	982080e7          	jalr	-1662(ra) # 800002d8 <memmove>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret
    panic("inituvm: more than a page");
    8000096e:	00007517          	auipc	a0,0x7
    80000972:	76a50513          	addi	a0,a0,1898 # 800080d8 <etext+0xd8>
    80000976:	00006097          	auipc	ra,0x6
    8000097a:	81e080e7          	jalr	-2018(ra) # 80006194 <panic>

000000008000097e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000097e:	1101                	addi	sp,sp,-32
    80000980:	ec06                	sd	ra,24(sp)
    80000982:	e822                	sd	s0,16(sp)
    80000984:	e426                	sd	s1,8(sp)
    80000986:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000988:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000098a:	00b67d63          	bgeu	a2,a1,800009a4 <uvmdealloc+0x26>
    8000098e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000990:	6785                	lui	a5,0x1
    80000992:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000994:	00f60733          	add	a4,a2,a5
    80000998:	76fd                	lui	a3,0xfffff
    8000099a:	8f75                	and	a4,a4,a3
    8000099c:	97ae                	add	a5,a5,a1
    8000099e:	8ff5                	and	a5,a5,a3
    800009a0:	00f76863          	bltu	a4,a5,800009b0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009a4:	8526                	mv	a0,s1
    800009a6:	60e2                	ld	ra,24(sp)
    800009a8:	6442                	ld	s0,16(sp)
    800009aa:	64a2                	ld	s1,8(sp)
    800009ac:	6105                	addi	sp,sp,32
    800009ae:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009b0:	8f99                	sub	a5,a5,a4
    800009b2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009b4:	4685                	li	a3,1
    800009b6:	0007861b          	sext.w	a2,a5
    800009ba:	85ba                	mv	a1,a4
    800009bc:	00000097          	auipc	ra,0x0
    800009c0:	e5e080e7          	jalr	-418(ra) # 8000081a <uvmunmap>
    800009c4:	b7c5                	j	800009a4 <uvmdealloc+0x26>

00000000800009c6 <uvmalloc>:
  if(newsz < oldsz)
    800009c6:	0ab66163          	bltu	a2,a1,80000a68 <uvmalloc+0xa2>
{
    800009ca:	7139                	addi	sp,sp,-64
    800009cc:	fc06                	sd	ra,56(sp)
    800009ce:	f822                	sd	s0,48(sp)
    800009d0:	f426                	sd	s1,40(sp)
    800009d2:	f04a                	sd	s2,32(sp)
    800009d4:	ec4e                	sd	s3,24(sp)
    800009d6:	e852                	sd	s4,16(sp)
    800009d8:	e456                	sd	s5,8(sp)
    800009da:	0080                	addi	s0,sp,64
    800009dc:	8aaa                	mv	s5,a0
    800009de:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009e0:	6785                	lui	a5,0x1
    800009e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e4:	95be                	add	a1,a1,a5
    800009e6:	77fd                	lui	a5,0xfffff
    800009e8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009ec:	08c9f063          	bgeu	s3,a2,80000a6c <uvmalloc+0xa6>
    800009f0:	894e                	mv	s2,s3
    mem = kalloc();
    800009f2:	fffff097          	auipc	ra,0xfffff
    800009f6:	778080e7          	jalr	1912(ra) # 8000016a <kalloc>
    800009fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800009fc:	c51d                	beqz	a0,80000a2a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4581                	li	a1,0
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	87a080e7          	jalr	-1926(ra) # 8000027c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a0a:	4779                	li	a4,30
    80000a0c:	86a6                	mv	a3,s1
    80000a0e:	6605                	lui	a2,0x1
    80000a10:	85ca                	mv	a1,s2
    80000a12:	8556                	mv	a0,s5
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	c40080e7          	jalr	-960(ra) # 80000654 <mappages>
    80000a1c:	e905                	bnez	a0,80000a4c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a1e:	6785                	lui	a5,0x1
    80000a20:	993e                	add	s2,s2,a5
    80000a22:	fd4968e3          	bltu	s2,s4,800009f2 <uvmalloc+0x2c>
  return newsz;
    80000a26:	8552                	mv	a0,s4
    80000a28:	a809                	j	80000a3a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a2a:	864e                	mv	a2,s3
    80000a2c:	85ca                	mv	a1,s2
    80000a2e:	8556                	mv	a0,s5
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	f4e080e7          	jalr	-178(ra) # 8000097e <uvmdealloc>
      return 0;
    80000a38:	4501                	li	a0,0
}
    80000a3a:	70e2                	ld	ra,56(sp)
    80000a3c:	7442                	ld	s0,48(sp)
    80000a3e:	74a2                	ld	s1,40(sp)
    80000a40:	7902                	ld	s2,32(sp)
    80000a42:	69e2                	ld	s3,24(sp)
    80000a44:	6a42                	ld	s4,16(sp)
    80000a46:	6aa2                	ld	s5,8(sp)
    80000a48:	6121                	addi	sp,sp,64
    80000a4a:	8082                	ret
      kfree(mem);
    80000a4c:	8526                	mv	a0,s1
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	5ce080e7          	jalr	1486(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a56:	864e                	mv	a2,s3
    80000a58:	85ca                	mv	a1,s2
    80000a5a:	8556                	mv	a0,s5
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	f22080e7          	jalr	-222(ra) # 8000097e <uvmdealloc>
      return 0;
    80000a64:	4501                	li	a0,0
    80000a66:	bfd1                	j	80000a3a <uvmalloc+0x74>
    return oldsz;
    80000a68:	852e                	mv	a0,a1
}
    80000a6a:	8082                	ret
  return newsz;
    80000a6c:	8532                	mv	a0,a2
    80000a6e:	b7f1                	j	80000a3a <uvmalloc+0x74>

0000000080000a70 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a70:	7179                	addi	sp,sp,-48
    80000a72:	f406                	sd	ra,40(sp)
    80000a74:	f022                	sd	s0,32(sp)
    80000a76:	ec26                	sd	s1,24(sp)
    80000a78:	e84a                	sd	s2,16(sp)
    80000a7a:	e44e                	sd	s3,8(sp)
    80000a7c:	e052                	sd	s4,0(sp)
    80000a7e:	1800                	addi	s0,sp,48
    80000a80:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a82:	84aa                	mv	s1,a0
    80000a84:	6905                	lui	s2,0x1
    80000a86:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a88:	4985                	li	s3,1
    80000a8a:	a829                	j	80000aa4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a8c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a8e:	00c79513          	slli	a0,a5,0xc
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	fde080e7          	jalr	-34(ra) # 80000a70 <freewalk>
      pagetable[i] = 0;
    80000a9a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a9e:	04a1                	addi	s1,s1,8
    80000aa0:	03248163          	beq	s1,s2,80000ac2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aa4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa6:	00f7f713          	andi	a4,a5,15
    80000aaa:	ff3701e3          	beq	a4,s3,80000a8c <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000aae:	8b85                	andi	a5,a5,1
    80000ab0:	d7fd                	beqz	a5,80000a9e <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	64650513          	addi	a0,a0,1606 # 800080f8 <etext+0xf8>
    80000aba:	00005097          	auipc	ra,0x5
    80000abe:	6da080e7          	jalr	1754(ra) # 80006194 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ac2:	8552                	mv	a0,s4
    80000ac4:	fffff097          	auipc	ra,0xfffff
    80000ac8:	558080e7          	jalr	1368(ra) # 8000001c <kfree>
}
    80000acc:	70a2                	ld	ra,40(sp)
    80000ace:	7402                	ld	s0,32(sp)
    80000ad0:	64e2                	ld	s1,24(sp)
    80000ad2:	6942                	ld	s2,16(sp)
    80000ad4:	69a2                	ld	s3,8(sp)
    80000ad6:	6a02                	ld	s4,0(sp)
    80000ad8:	6145                	addi	sp,sp,48
    80000ada:	8082                	ret

0000000080000adc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000adc:	1101                	addi	sp,sp,-32
    80000ade:	ec06                	sd	ra,24(sp)
    80000ae0:	e822                	sd	s0,16(sp)
    80000ae2:	e426                	sd	s1,8(sp)
    80000ae4:	1000                	addi	s0,sp,32
    80000ae6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ae8:	e999                	bnez	a1,80000afe <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000aea:	8526                	mv	a0,s1
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	f84080e7          	jalr	-124(ra) # 80000a70 <freewalk>
}
    80000af4:	60e2                	ld	ra,24(sp)
    80000af6:	6442                	ld	s0,16(sp)
    80000af8:	64a2                	ld	s1,8(sp)
    80000afa:	6105                	addi	sp,sp,32
    80000afc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000afe:	6785                	lui	a5,0x1
    80000b00:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b02:	95be                	add	a1,a1,a5
    80000b04:	4685                	li	a3,1
    80000b06:	00c5d613          	srli	a2,a1,0xc
    80000b0a:	4581                	li	a1,0
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	d0e080e7          	jalr	-754(ra) # 8000081a <uvmunmap>
    80000b14:	bfd9                	j	80000aea <uvmfree+0xe>

0000000080000b16 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b16:	c679                	beqz	a2,80000be4 <uvmcopy+0xce>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8aae                	mv	s5,a1
    80000b32:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b34:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b36:	4601                	li	a2,0
    80000b38:	85ce                	mv	a1,s3
    80000b3a:	855a                	mv	a0,s6
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	a30080e7          	jalr	-1488(ra) # 8000056c <walk>
    80000b44:	c531                	beqz	a0,80000b90 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b46:	6118                	ld	a4,0(a0)
    80000b48:	00177793          	andi	a5,a4,1
    80000b4c:	cbb1                	beqz	a5,80000ba0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b4e:	00a75593          	srli	a1,a4,0xa
    80000b52:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b56:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	610080e7          	jalr	1552(ra) # 8000016a <kalloc>
    80000b62:	892a                	mv	s2,a0
    80000b64:	c939                	beqz	a0,80000bba <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b66:	6605                	lui	a2,0x1
    80000b68:	85de                	mv	a1,s7
    80000b6a:	fffff097          	auipc	ra,0xfffff
    80000b6e:	76e080e7          	jalr	1902(ra) # 800002d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b72:	8726                	mv	a4,s1
    80000b74:	86ca                	mv	a3,s2
    80000b76:	6605                	lui	a2,0x1
    80000b78:	85ce                	mv	a1,s3
    80000b7a:	8556                	mv	a0,s5
    80000b7c:	00000097          	auipc	ra,0x0
    80000b80:	ad8080e7          	jalr	-1320(ra) # 80000654 <mappages>
    80000b84:	e515                	bnez	a0,80000bb0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b86:	6785                	lui	a5,0x1
    80000b88:	99be                	add	s3,s3,a5
    80000b8a:	fb49e6e3          	bltu	s3,s4,80000b36 <uvmcopy+0x20>
    80000b8e:	a081                	j	80000bce <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b90:	00007517          	auipc	a0,0x7
    80000b94:	57850513          	addi	a0,a0,1400 # 80008108 <etext+0x108>
    80000b98:	00005097          	auipc	ra,0x5
    80000b9c:	5fc080e7          	jalr	1532(ra) # 80006194 <panic>
      panic("uvmcopy: page not present");
    80000ba0:	00007517          	auipc	a0,0x7
    80000ba4:	58850513          	addi	a0,a0,1416 # 80008128 <etext+0x128>
    80000ba8:	00005097          	auipc	ra,0x5
    80000bac:	5ec080e7          	jalr	1516(ra) # 80006194 <panic>
      kfree(mem);
    80000bb0:	854a                	mv	a0,s2
    80000bb2:	fffff097          	auipc	ra,0xfffff
    80000bb6:	46a080e7          	jalr	1130(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bba:	4685                	li	a3,1
    80000bbc:	00c9d613          	srli	a2,s3,0xc
    80000bc0:	4581                	li	a1,0
    80000bc2:	8556                	mv	a0,s5
    80000bc4:	00000097          	auipc	ra,0x0
    80000bc8:	c56080e7          	jalr	-938(ra) # 8000081a <uvmunmap>
  return -1;
    80000bcc:	557d                	li	a0,-1
}
    80000bce:	60a6                	ld	ra,72(sp)
    80000bd0:	6406                	ld	s0,64(sp)
    80000bd2:	74e2                	ld	s1,56(sp)
    80000bd4:	7942                	ld	s2,48(sp)
    80000bd6:	79a2                	ld	s3,40(sp)
    80000bd8:	7a02                	ld	s4,32(sp)
    80000bda:	6ae2                	ld	s5,24(sp)
    80000bdc:	6b42                	ld	s6,16(sp)
    80000bde:	6ba2                	ld	s7,8(sp)
    80000be0:	6161                	addi	sp,sp,80
    80000be2:	8082                	ret
  return 0;
    80000be4:	4501                	li	a0,0
}
    80000be6:	8082                	ret

0000000080000be8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000be8:	1141                	addi	sp,sp,-16
    80000bea:	e406                	sd	ra,8(sp)
    80000bec:	e022                	sd	s0,0(sp)
    80000bee:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bf0:	4601                	li	a2,0
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	97a080e7          	jalr	-1670(ra) # 8000056c <walk>
  if(pte == 0)
    80000bfa:	c901                	beqz	a0,80000c0a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bfc:	611c                	ld	a5,0(a0)
    80000bfe:	9bbd                	andi	a5,a5,-17
    80000c00:	e11c                	sd	a5,0(a0)
}
    80000c02:	60a2                	ld	ra,8(sp)
    80000c04:	6402                	ld	s0,0(sp)
    80000c06:	0141                	addi	sp,sp,16
    80000c08:	8082                	ret
    panic("uvmclear");
    80000c0a:	00007517          	auipc	a0,0x7
    80000c0e:	53e50513          	addi	a0,a0,1342 # 80008148 <etext+0x148>
    80000c12:	00005097          	auipc	ra,0x5
    80000c16:	582080e7          	jalr	1410(ra) # 80006194 <panic>

0000000080000c1a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c1a:	c6bd                	beqz	a3,80000c88 <copyout+0x6e>
{
    80000c1c:	715d                	addi	sp,sp,-80
    80000c1e:	e486                	sd	ra,72(sp)
    80000c20:	e0a2                	sd	s0,64(sp)
    80000c22:	fc26                	sd	s1,56(sp)
    80000c24:	f84a                	sd	s2,48(sp)
    80000c26:	f44e                	sd	s3,40(sp)
    80000c28:	f052                	sd	s4,32(sp)
    80000c2a:	ec56                	sd	s5,24(sp)
    80000c2c:	e85a                	sd	s6,16(sp)
    80000c2e:	e45e                	sd	s7,8(sp)
    80000c30:	e062                	sd	s8,0(sp)
    80000c32:	0880                	addi	s0,sp,80
    80000c34:	8b2a                	mv	s6,a0
    80000c36:	8c2e                	mv	s8,a1
    80000c38:	8a32                	mv	s4,a2
    80000c3a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c3c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c3e:	6a85                	lui	s5,0x1
    80000c40:	a015                	j	80000c64 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c42:	9562                	add	a0,a0,s8
    80000c44:	0004861b          	sext.w	a2,s1
    80000c48:	85d2                	mv	a1,s4
    80000c4a:	41250533          	sub	a0,a0,s2
    80000c4e:	fffff097          	auipc	ra,0xfffff
    80000c52:	68a080e7          	jalr	1674(ra) # 800002d8 <memmove>

    len -= n;
    80000c56:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c5a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c5c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c60:	02098263          	beqz	s3,80000c84 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c64:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c68:	85ca                	mv	a1,s2
    80000c6a:	855a                	mv	a0,s6
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	9a6080e7          	jalr	-1626(ra) # 80000612 <walkaddr>
    if(pa0 == 0)
    80000c74:	cd01                	beqz	a0,80000c8c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c76:	418904b3          	sub	s1,s2,s8
    80000c7a:	94d6                	add	s1,s1,s5
    80000c7c:	fc99f3e3          	bgeu	s3,s1,80000c42 <copyout+0x28>
    80000c80:	84ce                	mv	s1,s3
    80000c82:	b7c1                	j	80000c42 <copyout+0x28>
  }
  return 0;
    80000c84:	4501                	li	a0,0
    80000c86:	a021                	j	80000c8e <copyout+0x74>
    80000c88:	4501                	li	a0,0
}
    80000c8a:	8082                	ret
      return -1;
    80000c8c:	557d                	li	a0,-1
}
    80000c8e:	60a6                	ld	ra,72(sp)
    80000c90:	6406                	ld	s0,64(sp)
    80000c92:	74e2                	ld	s1,56(sp)
    80000c94:	7942                	ld	s2,48(sp)
    80000c96:	79a2                	ld	s3,40(sp)
    80000c98:	7a02                	ld	s4,32(sp)
    80000c9a:	6ae2                	ld	s5,24(sp)
    80000c9c:	6b42                	ld	s6,16(sp)
    80000c9e:	6ba2                	ld	s7,8(sp)
    80000ca0:	6c02                	ld	s8,0(sp)
    80000ca2:	6161                	addi	sp,sp,80
    80000ca4:	8082                	ret

0000000080000ca6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ca6:	caa5                	beqz	a3,80000d16 <copyin+0x70>
{
    80000ca8:	715d                	addi	sp,sp,-80
    80000caa:	e486                	sd	ra,72(sp)
    80000cac:	e0a2                	sd	s0,64(sp)
    80000cae:	fc26                	sd	s1,56(sp)
    80000cb0:	f84a                	sd	s2,48(sp)
    80000cb2:	f44e                	sd	s3,40(sp)
    80000cb4:	f052                	sd	s4,32(sp)
    80000cb6:	ec56                	sd	s5,24(sp)
    80000cb8:	e85a                	sd	s6,16(sp)
    80000cba:	e45e                	sd	s7,8(sp)
    80000cbc:	e062                	sd	s8,0(sp)
    80000cbe:	0880                	addi	s0,sp,80
    80000cc0:	8b2a                	mv	s6,a0
    80000cc2:	8a2e                	mv	s4,a1
    80000cc4:	8c32                	mv	s8,a2
    80000cc6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cc8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cca:	6a85                	lui	s5,0x1
    80000ccc:	a01d                	j	80000cf2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cce:	018505b3          	add	a1,a0,s8
    80000cd2:	0004861b          	sext.w	a2,s1
    80000cd6:	412585b3          	sub	a1,a1,s2
    80000cda:	8552                	mv	a0,s4
    80000cdc:	fffff097          	auipc	ra,0xfffff
    80000ce0:	5fc080e7          	jalr	1532(ra) # 800002d8 <memmove>

    len -= n;
    80000ce4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ce8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cea:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cee:	02098263          	beqz	s3,80000d12 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cf2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cf6:	85ca                	mv	a1,s2
    80000cf8:	855a                	mv	a0,s6
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	918080e7          	jalr	-1768(ra) # 80000612 <walkaddr>
    if(pa0 == 0)
    80000d02:	cd01                	beqz	a0,80000d1a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d04:	418904b3          	sub	s1,s2,s8
    80000d08:	94d6                	add	s1,s1,s5
    80000d0a:	fc99f2e3          	bgeu	s3,s1,80000cce <copyin+0x28>
    80000d0e:	84ce                	mv	s1,s3
    80000d10:	bf7d                	j	80000cce <copyin+0x28>
  }
  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a021                	j	80000d1c <copyin+0x76>
    80000d16:	4501                	li	a0,0
}
    80000d18:	8082                	ret
      return -1;
    80000d1a:	557d                	li	a0,-1
}
    80000d1c:	60a6                	ld	ra,72(sp)
    80000d1e:	6406                	ld	s0,64(sp)
    80000d20:	74e2                	ld	s1,56(sp)
    80000d22:	7942                	ld	s2,48(sp)
    80000d24:	79a2                	ld	s3,40(sp)
    80000d26:	7a02                	ld	s4,32(sp)
    80000d28:	6ae2                	ld	s5,24(sp)
    80000d2a:	6b42                	ld	s6,16(sp)
    80000d2c:	6ba2                	ld	s7,8(sp)
    80000d2e:	6c02                	ld	s8,0(sp)
    80000d30:	6161                	addi	sp,sp,80
    80000d32:	8082                	ret

0000000080000d34 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d34:	c2dd                	beqz	a3,80000dda <copyinstr+0xa6>
{
    80000d36:	715d                	addi	sp,sp,-80
    80000d38:	e486                	sd	ra,72(sp)
    80000d3a:	e0a2                	sd	s0,64(sp)
    80000d3c:	fc26                	sd	s1,56(sp)
    80000d3e:	f84a                	sd	s2,48(sp)
    80000d40:	f44e                	sd	s3,40(sp)
    80000d42:	f052                	sd	s4,32(sp)
    80000d44:	ec56                	sd	s5,24(sp)
    80000d46:	e85a                	sd	s6,16(sp)
    80000d48:	e45e                	sd	s7,8(sp)
    80000d4a:	0880                	addi	s0,sp,80
    80000d4c:	8a2a                	mv	s4,a0
    80000d4e:	8b2e                	mv	s6,a1
    80000d50:	8bb2                	mv	s7,a2
    80000d52:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d54:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d56:	6985                	lui	s3,0x1
    80000d58:	a02d                	j	80000d82 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d5a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d5e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d60:	37fd                	addiw	a5,a5,-1
    80000d62:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d66:	60a6                	ld	ra,72(sp)
    80000d68:	6406                	ld	s0,64(sp)
    80000d6a:	74e2                	ld	s1,56(sp)
    80000d6c:	7942                	ld	s2,48(sp)
    80000d6e:	79a2                	ld	s3,40(sp)
    80000d70:	7a02                	ld	s4,32(sp)
    80000d72:	6ae2                	ld	s5,24(sp)
    80000d74:	6b42                	ld	s6,16(sp)
    80000d76:	6ba2                	ld	s7,8(sp)
    80000d78:	6161                	addi	sp,sp,80
    80000d7a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d7c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d80:	c8a9                	beqz	s1,80000dd2 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d82:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d86:	85ca                	mv	a1,s2
    80000d88:	8552                	mv	a0,s4
    80000d8a:	00000097          	auipc	ra,0x0
    80000d8e:	888080e7          	jalr	-1912(ra) # 80000612 <walkaddr>
    if(pa0 == 0)
    80000d92:	c131                	beqz	a0,80000dd6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d94:	417906b3          	sub	a3,s2,s7
    80000d98:	96ce                	add	a3,a3,s3
    80000d9a:	00d4f363          	bgeu	s1,a3,80000da0 <copyinstr+0x6c>
    80000d9e:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000da0:	955e                	add	a0,a0,s7
    80000da2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000da6:	daf9                	beqz	a3,80000d7c <copyinstr+0x48>
    80000da8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000daa:	41650633          	sub	a2,a0,s6
    80000dae:	fff48593          	addi	a1,s1,-1
    80000db2:	95da                	add	a1,a1,s6
    while(n > 0){
    80000db4:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000db6:	00f60733          	add	a4,a2,a5
    80000dba:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd3db8>
    80000dbe:	df51                	beqz	a4,80000d5a <copyinstr+0x26>
        *dst = *p;
    80000dc0:	00e78023          	sb	a4,0(a5)
      --max;
    80000dc4:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000dc8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dca:	fed796e3          	bne	a5,a3,80000db6 <copyinstr+0x82>
      dst++;
    80000dce:	8b3e                	mv	s6,a5
    80000dd0:	b775                	j	80000d7c <copyinstr+0x48>
    80000dd2:	4781                	li	a5,0
    80000dd4:	b771                	j	80000d60 <copyinstr+0x2c>
      return -1;
    80000dd6:	557d                	li	a0,-1
    80000dd8:	b779                	j	80000d66 <copyinstr+0x32>
  int got_null = 0;
    80000dda:	4781                	li	a5,0
  if(got_null){
    80000ddc:	37fd                	addiw	a5,a5,-1
    80000dde:	0007851b          	sext.w	a0,a5
}
    80000de2:	8082                	ret

0000000080000de4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000de4:	7139                	addi	sp,sp,-64
    80000de6:	fc06                	sd	ra,56(sp)
    80000de8:	f822                	sd	s0,48(sp)
    80000dea:	f426                	sd	s1,40(sp)
    80000dec:	f04a                	sd	s2,32(sp)
    80000dee:	ec4e                	sd	s3,24(sp)
    80000df0:	e852                	sd	s4,16(sp)
    80000df2:	e456                	sd	s5,8(sp)
    80000df4:	e05a                	sd	s6,0(sp)
    80000df6:	0080                	addi	s0,sp,64
    80000df8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	7b648493          	addi	s1,s1,1974 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e02:	8b26                	mv	s6,s1
    80000e04:	00007a97          	auipc	s5,0x7
    80000e08:	1fca8a93          	addi	s5,s5,508 # 80008000 <etext>
    80000e0c:	04000937          	lui	s2,0x4000
    80000e10:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e12:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e14:	0000ea17          	auipc	s4,0xe
    80000e18:	39ca0a13          	addi	s4,s4,924 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e1c:	fffff097          	auipc	ra,0xfffff
    80000e20:	34e080e7          	jalr	846(ra) # 8000016a <kalloc>
    80000e24:	862a                	mv	a2,a0
    if(pa == 0)
    80000e26:	c131                	beqz	a0,80000e6a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e28:	416485b3          	sub	a1,s1,s6
    80000e2c:	8591                	srai	a1,a1,0x4
    80000e2e:	000ab783          	ld	a5,0(s5)
    80000e32:	02f585b3          	mul	a1,a1,a5
    80000e36:	2585                	addiw	a1,a1,1
    80000e38:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e3c:	4719                	li	a4,6
    80000e3e:	6685                	lui	a3,0x1
    80000e40:	40b905b3          	sub	a1,s2,a1
    80000e44:	854e                	mv	a0,s3
    80000e46:	00000097          	auipc	ra,0x0
    80000e4a:	8ae080e7          	jalr	-1874(ra) # 800006f4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4e:	17048493          	addi	s1,s1,368
    80000e52:	fd4495e3          	bne	s1,s4,80000e1c <proc_mapstacks+0x38>
  }
}
    80000e56:	70e2                	ld	ra,56(sp)
    80000e58:	7442                	ld	s0,48(sp)
    80000e5a:	74a2                	ld	s1,40(sp)
    80000e5c:	7902                	ld	s2,32(sp)
    80000e5e:	69e2                	ld	s3,24(sp)
    80000e60:	6a42                	ld	s4,16(sp)
    80000e62:	6aa2                	ld	s5,8(sp)
    80000e64:	6b02                	ld	s6,0(sp)
    80000e66:	6121                	addi	sp,sp,64
    80000e68:	8082                	ret
      panic("kalloc");
    80000e6a:	00007517          	auipc	a0,0x7
    80000e6e:	2ee50513          	addi	a0,a0,750 # 80008158 <etext+0x158>
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	322080e7          	jalr	802(ra) # 80006194 <panic>

0000000080000e7a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e7a:	7139                	addi	sp,sp,-64
    80000e7c:	fc06                	sd	ra,56(sp)
    80000e7e:	f822                	sd	s0,48(sp)
    80000e80:	f426                	sd	s1,40(sp)
    80000e82:	f04a                	sd	s2,32(sp)
    80000e84:	ec4e                	sd	s3,24(sp)
    80000e86:	e852                	sd	s4,16(sp)
    80000e88:	e456                	sd	s5,8(sp)
    80000e8a:	e05a                	sd	s6,0(sp)
    80000e8c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e8e:	00007597          	auipc	a1,0x7
    80000e92:	2d258593          	addi	a1,a1,722 # 80008160 <etext+0x160>
    80000e96:	00008517          	auipc	a0,0x8
    80000e9a:	2da50513          	addi	a0,a0,730 # 80009170 <pid_lock>
    80000e9e:	00006097          	auipc	ra,0x6
    80000ea2:	994080e7          	jalr	-1644(ra) # 80006832 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ea6:	00007597          	auipc	a1,0x7
    80000eaa:	2c258593          	addi	a1,a1,706 # 80008168 <etext+0x168>
    80000eae:	00008517          	auipc	a0,0x8
    80000eb2:	2e250513          	addi	a0,a0,738 # 80009190 <wait_lock>
    80000eb6:	00006097          	auipc	ra,0x6
    80000eba:	97c080e7          	jalr	-1668(ra) # 80006832 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebe:	00008497          	auipc	s1,0x8
    80000ec2:	6f248493          	addi	s1,s1,1778 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ec6:	00007b17          	auipc	s6,0x7
    80000eca:	2b2b0b13          	addi	s6,s6,690 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ece:	8aa6                	mv	s5,s1
    80000ed0:	00007a17          	auipc	s4,0x7
    80000ed4:	130a0a13          	addi	s4,s4,304 # 80008000 <etext>
    80000ed8:	04000937          	lui	s2,0x4000
    80000edc:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ede:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee0:	0000e997          	auipc	s3,0xe
    80000ee4:	2d098993          	addi	s3,s3,720 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000ee8:	85da                	mv	a1,s6
    80000eea:	8526                	mv	a0,s1
    80000eec:	00006097          	auipc	ra,0x6
    80000ef0:	946080e7          	jalr	-1722(ra) # 80006832 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ef4:	415487b3          	sub	a5,s1,s5
    80000ef8:	8791                	srai	a5,a5,0x4
    80000efa:	000a3703          	ld	a4,0(s4)
    80000efe:	02e787b3          	mul	a5,a5,a4
    80000f02:	2785                	addiw	a5,a5,1
    80000f04:	00d7979b          	slliw	a5,a5,0xd
    80000f08:	40f907b3          	sub	a5,s2,a5
    80000f0c:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0e:	17048493          	addi	s1,s1,368
    80000f12:	fd349be3          	bne	s1,s3,80000ee8 <procinit+0x6e>
  }
}
    80000f16:	70e2                	ld	ra,56(sp)
    80000f18:	7442                	ld	s0,48(sp)
    80000f1a:	74a2                	ld	s1,40(sp)
    80000f1c:	7902                	ld	s2,32(sp)
    80000f1e:	69e2                	ld	s3,24(sp)
    80000f20:	6a42                	ld	s4,16(sp)
    80000f22:	6aa2                	ld	s5,8(sp)
    80000f24:	6b02                	ld	s6,0(sp)
    80000f26:	6121                	addi	sp,sp,64
    80000f28:	8082                	ret

0000000080000f2a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f2a:	1141                	addi	sp,sp,-16
    80000f2c:	e422                	sd	s0,8(sp)
    80000f2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f32:	2501                	sext.w	a0,a0
    80000f34:	6422                	ld	s0,8(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret

0000000080000f3a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f3a:	1141                	addi	sp,sp,-16
    80000f3c:	e422                	sd	s0,8(sp)
    80000f3e:	0800                	addi	s0,sp,16
    80000f40:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f42:	2781                	sext.w	a5,a5
    80000f44:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f46:	00008517          	auipc	a0,0x8
    80000f4a:	26a50513          	addi	a0,a0,618 # 800091b0 <cpus>
    80000f4e:	953e                	add	a0,a0,a5
    80000f50:	6422                	ld	s0,8(sp)
    80000f52:	0141                	addi	sp,sp,16
    80000f54:	8082                	ret

0000000080000f56 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	1000                	addi	s0,sp,32
  push_off();
    80000f60:	00005097          	auipc	ra,0x5
    80000f64:	70a080e7          	jalr	1802(ra) # 8000666a <push_off>
    80000f68:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f6a:	2781                	sext.w	a5,a5
    80000f6c:	079e                	slli	a5,a5,0x7
    80000f6e:	00008717          	auipc	a4,0x8
    80000f72:	20270713          	addi	a4,a4,514 # 80009170 <pid_lock>
    80000f76:	97ba                	add	a5,a5,a4
    80000f78:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	7ac080e7          	jalr	1964(ra) # 80006726 <pop_off>
  return p;
}
    80000f82:	8526                	mv	a0,s1
    80000f84:	60e2                	ld	ra,24(sp)
    80000f86:	6442                	ld	s0,16(sp)
    80000f88:	64a2                	ld	s1,8(sp)
    80000f8a:	6105                	addi	sp,sp,32
    80000f8c:	8082                	ret

0000000080000f8e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e406                	sd	ra,8(sp)
    80000f92:	e022                	sd	s0,0(sp)
    80000f94:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	fc0080e7          	jalr	-64(ra) # 80000f56 <myproc>
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	7e8080e7          	jalr	2024(ra) # 80006786 <release>

  if (first) {
    80000fa6:	00008797          	auipc	a5,0x8
    80000faa:	92a7a783          	lw	a5,-1750(a5) # 800088d0 <first.1>
    80000fae:	eb89                	bnez	a5,80000fc0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fb0:	00001097          	auipc	ra,0x1
    80000fb4:	c14080e7          	jalr	-1004(ra) # 80001bc4 <usertrapret>
}
    80000fb8:	60a2                	ld	ra,8(sp)
    80000fba:	6402                	ld	s0,0(sp)
    80000fbc:	0141                	addi	sp,sp,16
    80000fbe:	8082                	ret
    first = 0;
    80000fc0:	00008797          	auipc	a5,0x8
    80000fc4:	9007a823          	sw	zero,-1776(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80000fc8:	4505                	li	a0,1
    80000fca:	00002097          	auipc	ra,0x2
    80000fce:	b9a080e7          	jalr	-1126(ra) # 80002b64 <fsinit>
    80000fd2:	bff9                	j	80000fb0 <forkret+0x22>

0000000080000fd4 <allocpid>:
allocpid() {
    80000fd4:	1101                	addi	sp,sp,-32
    80000fd6:	ec06                	sd	ra,24(sp)
    80000fd8:	e822                	sd	s0,16(sp)
    80000fda:	e426                	sd	s1,8(sp)
    80000fdc:	e04a                	sd	s2,0(sp)
    80000fde:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fe0:	00008917          	auipc	s2,0x8
    80000fe4:	19090913          	addi	s2,s2,400 # 80009170 <pid_lock>
    80000fe8:	854a                	mv	a0,s2
    80000fea:	00005097          	auipc	ra,0x5
    80000fee:	6cc080e7          	jalr	1740(ra) # 800066b6 <acquire>
  pid = nextpid;
    80000ff2:	00008797          	auipc	a5,0x8
    80000ff6:	8e278793          	addi	a5,a5,-1822 # 800088d4 <nextpid>
    80000ffa:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ffc:	0014871b          	addiw	a4,s1,1
    80001000:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001002:	854a                	mv	a0,s2
    80001004:	00005097          	auipc	ra,0x5
    80001008:	782080e7          	jalr	1922(ra) # 80006786 <release>
}
    8000100c:	8526                	mv	a0,s1
    8000100e:	60e2                	ld	ra,24(sp)
    80001010:	6442                	ld	s0,16(sp)
    80001012:	64a2                	ld	s1,8(sp)
    80001014:	6902                	ld	s2,0(sp)
    80001016:	6105                	addi	sp,sp,32
    80001018:	8082                	ret

000000008000101a <proc_pagetable>:
{
    8000101a:	1101                	addi	sp,sp,-32
    8000101c:	ec06                	sd	ra,24(sp)
    8000101e:	e822                	sd	s0,16(sp)
    80001020:	e426                	sd	s1,8(sp)
    80001022:	e04a                	sd	s2,0(sp)
    80001024:	1000                	addi	s0,sp,32
    80001026:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	8b6080e7          	jalr	-1866(ra) # 800008de <uvmcreate>
    80001030:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001032:	c121                	beqz	a0,80001072 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001034:	4729                	li	a4,10
    80001036:	00006697          	auipc	a3,0x6
    8000103a:	fca68693          	addi	a3,a3,-54 # 80007000 <_trampoline>
    8000103e:	6605                	lui	a2,0x1
    80001040:	040005b7          	lui	a1,0x4000
    80001044:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001046:	05b2                	slli	a1,a1,0xc
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	60c080e7          	jalr	1548(ra) # 80000654 <mappages>
    80001050:	02054863          	bltz	a0,80001080 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001054:	4719                	li	a4,6
    80001056:	06093683          	ld	a3,96(s2)
    8000105a:	6605                	lui	a2,0x1
    8000105c:	020005b7          	lui	a1,0x2000
    80001060:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001062:	05b6                	slli	a1,a1,0xd
    80001064:	8526                	mv	a0,s1
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	5ee080e7          	jalr	1518(ra) # 80000654 <mappages>
    8000106e:	02054163          	bltz	a0,80001090 <proc_pagetable+0x76>
}
    80001072:	8526                	mv	a0,s1
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6902                	ld	s2,0(sp)
    8000107c:	6105                	addi	sp,sp,32
    8000107e:	8082                	ret
    uvmfree(pagetable, 0);
    80001080:	4581                	li	a1,0
    80001082:	8526                	mv	a0,s1
    80001084:	00000097          	auipc	ra,0x0
    80001088:	a58080e7          	jalr	-1448(ra) # 80000adc <uvmfree>
    return 0;
    8000108c:	4481                	li	s1,0
    8000108e:	b7d5                	j	80001072 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001090:	4681                	li	a3,0
    80001092:	4605                	li	a2,1
    80001094:	040005b7          	lui	a1,0x4000
    80001098:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109a:	05b2                	slli	a1,a1,0xc
    8000109c:	8526                	mv	a0,s1
    8000109e:	fffff097          	auipc	ra,0xfffff
    800010a2:	77c080e7          	jalr	1916(ra) # 8000081a <uvmunmap>
    uvmfree(pagetable, 0);
    800010a6:	4581                	li	a1,0
    800010a8:	8526                	mv	a0,s1
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	a32080e7          	jalr	-1486(ra) # 80000adc <uvmfree>
    return 0;
    800010b2:	4481                	li	s1,0
    800010b4:	bf7d                	j	80001072 <proc_pagetable+0x58>

00000000800010b6 <proc_freepagetable>:
{
    800010b6:	1101                	addi	sp,sp,-32
    800010b8:	ec06                	sd	ra,24(sp)
    800010ba:	e822                	sd	s0,16(sp)
    800010bc:	e426                	sd	s1,8(sp)
    800010be:	e04a                	sd	s2,0(sp)
    800010c0:	1000                	addi	s0,sp,32
    800010c2:	84aa                	mv	s1,a0
    800010c4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c6:	4681                	li	a3,0
    800010c8:	4605                	li	a2,1
    800010ca:	040005b7          	lui	a1,0x4000
    800010ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010d0:	05b2                	slli	a1,a1,0xc
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	748080e7          	jalr	1864(ra) # 8000081a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010da:	4681                	li	a3,0
    800010dc:	4605                	li	a2,1
    800010de:	020005b7          	lui	a1,0x2000
    800010e2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e4:	05b6                	slli	a1,a1,0xd
    800010e6:	8526                	mv	a0,s1
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	732080e7          	jalr	1842(ra) # 8000081a <uvmunmap>
  uvmfree(pagetable, sz);
    800010f0:	85ca                	mv	a1,s2
    800010f2:	8526                	mv	a0,s1
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	9e8080e7          	jalr	-1560(ra) # 80000adc <uvmfree>
}
    800010fc:	60e2                	ld	ra,24(sp)
    800010fe:	6442                	ld	s0,16(sp)
    80001100:	64a2                	ld	s1,8(sp)
    80001102:	6902                	ld	s2,0(sp)
    80001104:	6105                	addi	sp,sp,32
    80001106:	8082                	ret

0000000080001108 <freeproc>:
{
    80001108:	1101                	addi	sp,sp,-32
    8000110a:	ec06                	sd	ra,24(sp)
    8000110c:	e822                	sd	s0,16(sp)
    8000110e:	e426                	sd	s1,8(sp)
    80001110:	1000                	addi	s0,sp,32
    80001112:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001114:	7128                	ld	a0,96(a0)
    80001116:	c509                	beqz	a0,80001120 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001118:	fffff097          	auipc	ra,0xfffff
    8000111c:	f04080e7          	jalr	-252(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001120:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001124:	6ca8                	ld	a0,88(s1)
    80001126:	c511                	beqz	a0,80001132 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001128:	68ac                	ld	a1,80(s1)
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f8c080e7          	jalr	-116(ra) # 800010b6 <proc_freepagetable>
  p->pagetable = 0;
    80001132:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001136:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000113a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000113e:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001142:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001146:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000114a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000114e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001152:	0204a023          	sw	zero,32(s1)
}
    80001156:	60e2                	ld	ra,24(sp)
    80001158:	6442                	ld	s0,16(sp)
    8000115a:	64a2                	ld	s1,8(sp)
    8000115c:	6105                	addi	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <allocproc>:
{
    80001160:	1101                	addi	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	e04a                	sd	s2,0(sp)
    8000116a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116c:	00008497          	auipc	s1,0x8
    80001170:	44448493          	addi	s1,s1,1092 # 800095b0 <proc>
    80001174:	0000e917          	auipc	s2,0xe
    80001178:	03c90913          	addi	s2,s2,60 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000117c:	8526                	mv	a0,s1
    8000117e:	00005097          	auipc	ra,0x5
    80001182:	538080e7          	jalr	1336(ra) # 800066b6 <acquire>
    if(p->state == UNUSED) {
    80001186:	509c                	lw	a5,32(s1)
    80001188:	cf81                	beqz	a5,800011a0 <allocproc+0x40>
      release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	5fa080e7          	jalr	1530(ra) # 80006786 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001194:	17048493          	addi	s1,s1,368
    80001198:	ff2492e3          	bne	s1,s2,8000117c <allocproc+0x1c>
  return 0;
    8000119c:	4481                	li	s1,0
    8000119e:	a889                	j	800011f0 <allocproc+0x90>
  p->pid = allocpid();
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	e34080e7          	jalr	-460(ra) # 80000fd4 <allocpid>
    800011a8:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011aa:	4785                	li	a5,1
    800011ac:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	fbc080e7          	jalr	-68(ra) # 8000016a <kalloc>
    800011b6:	892a                	mv	s2,a0
    800011b8:	f0a8                	sd	a0,96(s1)
    800011ba:	c131                	beqz	a0,800011fe <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	e5c080e7          	jalr	-420(ra) # 8000101a <proc_pagetable>
    800011c6:	892a                	mv	s2,a0
    800011c8:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011ca:	c531                	beqz	a0,80001216 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011cc:	07000613          	li	a2,112
    800011d0:	4581                	li	a1,0
    800011d2:	06848513          	addi	a0,s1,104
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	0a6080e7          	jalr	166(ra) # 8000027c <memset>
  p->context.ra = (uint64)forkret;
    800011de:	00000797          	auipc	a5,0x0
    800011e2:	db078793          	addi	a5,a5,-592 # 80000f8e <forkret>
    800011e6:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011e8:	64bc                	ld	a5,72(s1)
    800011ea:	6705                	lui	a4,0x1
    800011ec:	97ba                	add	a5,a5,a4
    800011ee:	f8bc                	sd	a5,112(s1)
}
    800011f0:	8526                	mv	a0,s1
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6902                	ld	s2,0(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret
    freeproc(p);
    800011fe:	8526                	mv	a0,s1
    80001200:	00000097          	auipc	ra,0x0
    80001204:	f08080e7          	jalr	-248(ra) # 80001108 <freeproc>
    release(&p->lock);
    80001208:	8526                	mv	a0,s1
    8000120a:	00005097          	auipc	ra,0x5
    8000120e:	57c080e7          	jalr	1404(ra) # 80006786 <release>
    return 0;
    80001212:	84ca                	mv	s1,s2
    80001214:	bff1                	j	800011f0 <allocproc+0x90>
    freeproc(p);
    80001216:	8526                	mv	a0,s1
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	ef0080e7          	jalr	-272(ra) # 80001108 <freeproc>
    release(&p->lock);
    80001220:	8526                	mv	a0,s1
    80001222:	00005097          	auipc	ra,0x5
    80001226:	564080e7          	jalr	1380(ra) # 80006786 <release>
    return 0;
    8000122a:	84ca                	mv	s1,s2
    8000122c:	b7d1                	j	800011f0 <allocproc+0x90>

000000008000122e <userinit>:
{
    8000122e:	1101                	addi	sp,sp,-32
    80001230:	ec06                	sd	ra,24(sp)
    80001232:	e822                	sd	s0,16(sp)
    80001234:	e426                	sd	s1,8(sp)
    80001236:	1000                	addi	s0,sp,32
  p = allocproc();
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	f28080e7          	jalr	-216(ra) # 80001160 <allocproc>
    80001240:	84aa                	mv	s1,a0
  initproc = p;
    80001242:	00008797          	auipc	a5,0x8
    80001246:	dca7b723          	sd	a0,-562(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000124a:	03400613          	li	a2,52
    8000124e:	00007597          	auipc	a1,0x7
    80001252:	69258593          	addi	a1,a1,1682 # 800088e0 <initcode>
    80001256:	6d28                	ld	a0,88(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	6b4080e7          	jalr	1716(ra) # 8000090c <uvminit>
  p->sz = PGSIZE;
    80001260:	6785                	lui	a5,0x1
    80001262:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001264:	70b8                	ld	a4,96(s1)
    80001266:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000126a:	70b8                	ld	a4,96(s1)
    8000126c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000126e:	4641                	li	a2,16
    80001270:	00007597          	auipc	a1,0x7
    80001274:	f1058593          	addi	a1,a1,-240 # 80008180 <etext+0x180>
    80001278:	16048513          	addi	a0,s1,352
    8000127c:	fffff097          	auipc	ra,0xfffff
    80001280:	14a080e7          	jalr	330(ra) # 800003c6 <safestrcpy>
  p->cwd = namei("/");
    80001284:	00007517          	auipc	a0,0x7
    80001288:	f0c50513          	addi	a0,a0,-244 # 80008190 <etext+0x190>
    8000128c:	00002097          	auipc	ra,0x2
    80001290:	30e080e7          	jalr	782(ra) # 8000359a <namei>
    80001294:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001298:	478d                	li	a5,3
    8000129a:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00005097          	auipc	ra,0x5
    800012a2:	4e8080e7          	jalr	1256(ra) # 80006786 <release>
}
    800012a6:	60e2                	ld	ra,24(sp)
    800012a8:	6442                	ld	s0,16(sp)
    800012aa:	64a2                	ld	s1,8(sp)
    800012ac:	6105                	addi	sp,sp,32
    800012ae:	8082                	ret

00000000800012b0 <growproc>:
{
    800012b0:	1101                	addi	sp,sp,-32
    800012b2:	ec06                	sd	ra,24(sp)
    800012b4:	e822                	sd	s0,16(sp)
    800012b6:	e426                	sd	s1,8(sp)
    800012b8:	e04a                	sd	s2,0(sp)
    800012ba:	1000                	addi	s0,sp,32
    800012bc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	c98080e7          	jalr	-872(ra) # 80000f56 <myproc>
    800012c6:	892a                	mv	s2,a0
  sz = p->sz;
    800012c8:	692c                	ld	a1,80(a0)
    800012ca:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800012ce:	00904f63          	bgtz	s1,800012ec <growproc+0x3c>
  } else if(n < 0){
    800012d2:	0204cd63          	bltz	s1,8000130c <growproc+0x5c>
  p->sz = sz;
    800012d6:	1782                	slli	a5,a5,0x20
    800012d8:	9381                	srli	a5,a5,0x20
    800012da:	04f93823          	sd	a5,80(s2)
  return 0;
    800012de:	4501                	li	a0,0
}
    800012e0:	60e2                	ld	ra,24(sp)
    800012e2:	6442                	ld	s0,16(sp)
    800012e4:	64a2                	ld	s1,8(sp)
    800012e6:	6902                	ld	s2,0(sp)
    800012e8:	6105                	addi	sp,sp,32
    800012ea:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800012ec:	00f4863b          	addw	a2,s1,a5
    800012f0:	1602                	slli	a2,a2,0x20
    800012f2:	9201                	srli	a2,a2,0x20
    800012f4:	1582                	slli	a1,a1,0x20
    800012f6:	9181                	srli	a1,a1,0x20
    800012f8:	6d28                	ld	a0,88(a0)
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	6cc080e7          	jalr	1740(ra) # 800009c6 <uvmalloc>
    80001302:	0005079b          	sext.w	a5,a0
    80001306:	fbe1                	bnez	a5,800012d6 <growproc+0x26>
      return -1;
    80001308:	557d                	li	a0,-1
    8000130a:	bfd9                	j	800012e0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000130c:	00f4863b          	addw	a2,s1,a5
    80001310:	1602                	slli	a2,a2,0x20
    80001312:	9201                	srli	a2,a2,0x20
    80001314:	1582                	slli	a1,a1,0x20
    80001316:	9181                	srli	a1,a1,0x20
    80001318:	6d28                	ld	a0,88(a0)
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	664080e7          	jalr	1636(ra) # 8000097e <uvmdealloc>
    80001322:	0005079b          	sext.w	a5,a0
    80001326:	bf45                	j	800012d6 <growproc+0x26>

0000000080001328 <fork>:
{
    80001328:	7139                	addi	sp,sp,-64
    8000132a:	fc06                	sd	ra,56(sp)
    8000132c:	f822                	sd	s0,48(sp)
    8000132e:	f426                	sd	s1,40(sp)
    80001330:	f04a                	sd	s2,32(sp)
    80001332:	ec4e                	sd	s3,24(sp)
    80001334:	e852                	sd	s4,16(sp)
    80001336:	e456                	sd	s5,8(sp)
    80001338:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000133a:	00000097          	auipc	ra,0x0
    8000133e:	c1c080e7          	jalr	-996(ra) # 80000f56 <myproc>
    80001342:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001344:	00000097          	auipc	ra,0x0
    80001348:	e1c080e7          	jalr	-484(ra) # 80001160 <allocproc>
    8000134c:	10050c63          	beqz	a0,80001464 <fork+0x13c>
    80001350:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001352:	050ab603          	ld	a2,80(s5)
    80001356:	6d2c                	ld	a1,88(a0)
    80001358:	058ab503          	ld	a0,88(s5)
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	7ba080e7          	jalr	1978(ra) # 80000b16 <uvmcopy>
    80001364:	04054863          	bltz	a0,800013b4 <fork+0x8c>
  np->sz = p->sz;
    80001368:	050ab783          	ld	a5,80(s5)
    8000136c:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001370:	060ab683          	ld	a3,96(s5)
    80001374:	87b6                	mv	a5,a3
    80001376:	060a3703          	ld	a4,96(s4)
    8000137a:	12068693          	addi	a3,a3,288
    8000137e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001382:	6788                	ld	a0,8(a5)
    80001384:	6b8c                	ld	a1,16(a5)
    80001386:	6f90                	ld	a2,24(a5)
    80001388:	01073023          	sd	a6,0(a4)
    8000138c:	e708                	sd	a0,8(a4)
    8000138e:	eb0c                	sd	a1,16(a4)
    80001390:	ef10                	sd	a2,24(a4)
    80001392:	02078793          	addi	a5,a5,32
    80001396:	02070713          	addi	a4,a4,32
    8000139a:	fed792e3          	bne	a5,a3,8000137e <fork+0x56>
  np->trapframe->a0 = 0;
    8000139e:	060a3783          	ld	a5,96(s4)
    800013a2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013a6:	0d8a8493          	addi	s1,s5,216
    800013aa:	0d8a0913          	addi	s2,s4,216
    800013ae:	158a8993          	addi	s3,s5,344
    800013b2:	a00d                	j	800013d4 <fork+0xac>
    freeproc(np);
    800013b4:	8552                	mv	a0,s4
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	d52080e7          	jalr	-686(ra) # 80001108 <freeproc>
    release(&np->lock);
    800013be:	8552                	mv	a0,s4
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	3c6080e7          	jalr	966(ra) # 80006786 <release>
    return -1;
    800013c8:	597d                	li	s2,-1
    800013ca:	a059                	j	80001450 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800013cc:	04a1                	addi	s1,s1,8
    800013ce:	0921                	addi	s2,s2,8
    800013d0:	01348b63          	beq	s1,s3,800013e6 <fork+0xbe>
    if(p->ofile[i])
    800013d4:	6088                	ld	a0,0(s1)
    800013d6:	d97d                	beqz	a0,800013cc <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800013d8:	00003097          	auipc	ra,0x3
    800013dc:	858080e7          	jalr	-1960(ra) # 80003c30 <filedup>
    800013e0:	00a93023          	sd	a0,0(s2)
    800013e4:	b7e5                	j	800013cc <fork+0xa4>
  np->cwd = idup(p->cwd);
    800013e6:	158ab503          	ld	a0,344(s5)
    800013ea:	00002097          	auipc	ra,0x2
    800013ee:	9b6080e7          	jalr	-1610(ra) # 80002da0 <idup>
    800013f2:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013f6:	4641                	li	a2,16
    800013f8:	160a8593          	addi	a1,s5,352
    800013fc:	160a0513          	addi	a0,s4,352
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	fc6080e7          	jalr	-58(ra) # 800003c6 <safestrcpy>
  pid = np->pid;
    80001408:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000140c:	8552                	mv	a0,s4
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	378080e7          	jalr	888(ra) # 80006786 <release>
  acquire(&wait_lock);
    80001416:	00008497          	auipc	s1,0x8
    8000141a:	d7a48493          	addi	s1,s1,-646 # 80009190 <wait_lock>
    8000141e:	8526                	mv	a0,s1
    80001420:	00005097          	auipc	ra,0x5
    80001424:	296080e7          	jalr	662(ra) # 800066b6 <acquire>
  np->parent = p;
    80001428:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000142c:	8526                	mv	a0,s1
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	358080e7          	jalr	856(ra) # 80006786 <release>
  acquire(&np->lock);
    80001436:	8552                	mv	a0,s4
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	27e080e7          	jalr	638(ra) # 800066b6 <acquire>
  np->state = RUNNABLE;
    80001440:	478d                	li	a5,3
    80001442:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001446:	8552                	mv	a0,s4
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	33e080e7          	jalr	830(ra) # 80006786 <release>
}
    80001450:	854a                	mv	a0,s2
    80001452:	70e2                	ld	ra,56(sp)
    80001454:	7442                	ld	s0,48(sp)
    80001456:	74a2                	ld	s1,40(sp)
    80001458:	7902                	ld	s2,32(sp)
    8000145a:	69e2                	ld	s3,24(sp)
    8000145c:	6a42                	ld	s4,16(sp)
    8000145e:	6aa2                	ld	s5,8(sp)
    80001460:	6121                	addi	sp,sp,64
    80001462:	8082                	ret
    return -1;
    80001464:	597d                	li	s2,-1
    80001466:	b7ed                	j	80001450 <fork+0x128>

0000000080001468 <scheduler>:
{
    80001468:	7139                	addi	sp,sp,-64
    8000146a:	fc06                	sd	ra,56(sp)
    8000146c:	f822                	sd	s0,48(sp)
    8000146e:	f426                	sd	s1,40(sp)
    80001470:	f04a                	sd	s2,32(sp)
    80001472:	ec4e                	sd	s3,24(sp)
    80001474:	e852                	sd	s4,16(sp)
    80001476:	e456                	sd	s5,8(sp)
    80001478:	e05a                	sd	s6,0(sp)
    8000147a:	0080                	addi	s0,sp,64
    8000147c:	8792                	mv	a5,tp
  int id = r_tp();
    8000147e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001480:	00779a93          	slli	s5,a5,0x7
    80001484:	00008717          	auipc	a4,0x8
    80001488:	cec70713          	addi	a4,a4,-788 # 80009170 <pid_lock>
    8000148c:	9756                	add	a4,a4,s5
    8000148e:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001492:	00008717          	auipc	a4,0x8
    80001496:	d2670713          	addi	a4,a4,-730 # 800091b8 <cpus+0x8>
    8000149a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000149c:	498d                	li	s3,3
        p->state = RUNNING;
    8000149e:	4b11                	li	s6,4
        c->proc = p;
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	00008a17          	auipc	s4,0x8
    800014a6:	ccea0a13          	addi	s4,s4,-818 # 80009170 <pid_lock>
    800014aa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ac:	0000e917          	auipc	s2,0xe
    800014b0:	d0490913          	addi	s2,s2,-764 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014bc:	10079073          	csrw	sstatus,a5
    800014c0:	00008497          	auipc	s1,0x8
    800014c4:	0f048493          	addi	s1,s1,240 # 800095b0 <proc>
    800014c8:	a811                	j	800014dc <scheduler+0x74>
      release(&p->lock);
    800014ca:	8526                	mv	a0,s1
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	2ba080e7          	jalr	698(ra) # 80006786 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014d4:	17048493          	addi	s1,s1,368
    800014d8:	fd248ee3          	beq	s1,s2,800014b4 <scheduler+0x4c>
      acquire(&p->lock);
    800014dc:	8526                	mv	a0,s1
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	1d8080e7          	jalr	472(ra) # 800066b6 <acquire>
      if(p->state == RUNNABLE) {
    800014e6:	509c                	lw	a5,32(s1)
    800014e8:	ff3791e3          	bne	a5,s3,800014ca <scheduler+0x62>
        p->state = RUNNING;
    800014ec:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014f0:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014f4:	06848593          	addi	a1,s1,104
    800014f8:	8556                	mv	a0,s5
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	620080e7          	jalr	1568(ra) # 80001b1a <swtch>
        c->proc = 0;
    80001502:	040a3023          	sd	zero,64(s4)
    80001506:	b7d1                	j	800014ca <scheduler+0x62>

0000000080001508 <sched>:
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	a40080e7          	jalr	-1472(ra) # 80000f56 <myproc>
    8000151e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001520:	00005097          	auipc	ra,0x5
    80001524:	11c080e7          	jalr	284(ra) # 8000663c <holding>
    80001528:	c93d                	beqz	a0,8000159e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000152a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000152c:	2781                	sext.w	a5,a5
    8000152e:	079e                	slli	a5,a5,0x7
    80001530:	00008717          	auipc	a4,0x8
    80001534:	c4070713          	addi	a4,a4,-960 # 80009170 <pid_lock>
    80001538:	97ba                	add	a5,a5,a4
    8000153a:	0b87a703          	lw	a4,184(a5)
    8000153e:	4785                	li	a5,1
    80001540:	06f71763          	bne	a4,a5,800015ae <sched+0xa6>
  if(p->state == RUNNING)
    80001544:	5098                	lw	a4,32(s1)
    80001546:	4791                	li	a5,4
    80001548:	06f70b63          	beq	a4,a5,800015be <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001550:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001552:	efb5                	bnez	a5,800015ce <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001554:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001556:	00008917          	auipc	s2,0x8
    8000155a:	c1a90913          	addi	s2,s2,-998 # 80009170 <pid_lock>
    8000155e:	2781                	sext.w	a5,a5
    80001560:	079e                	slli	a5,a5,0x7
    80001562:	97ca                	add	a5,a5,s2
    80001564:	0bc7a983          	lw	s3,188(a5)
    80001568:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000156a:	2781                	sext.w	a5,a5
    8000156c:	079e                	slli	a5,a5,0x7
    8000156e:	00008597          	auipc	a1,0x8
    80001572:	c4a58593          	addi	a1,a1,-950 # 800091b8 <cpus+0x8>
    80001576:	95be                	add	a1,a1,a5
    80001578:	06848513          	addi	a0,s1,104
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	59e080e7          	jalr	1438(ra) # 80001b1a <swtch>
    80001584:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001586:	2781                	sext.w	a5,a5
    80001588:	079e                	slli	a5,a5,0x7
    8000158a:	993e                	add	s2,s2,a5
    8000158c:	0b392e23          	sw	s3,188(s2)
}
    80001590:	70a2                	ld	ra,40(sp)
    80001592:	7402                	ld	s0,32(sp)
    80001594:	64e2                	ld	s1,24(sp)
    80001596:	6942                	ld	s2,16(sp)
    80001598:	69a2                	ld	s3,8(sp)
    8000159a:	6145                	addi	sp,sp,48
    8000159c:	8082                	ret
    panic("sched p->lock");
    8000159e:	00007517          	auipc	a0,0x7
    800015a2:	bfa50513          	addi	a0,a0,-1030 # 80008198 <etext+0x198>
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	bee080e7          	jalr	-1042(ra) # 80006194 <panic>
    panic("sched locks");
    800015ae:	00007517          	auipc	a0,0x7
    800015b2:	bfa50513          	addi	a0,a0,-1030 # 800081a8 <etext+0x1a8>
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	bde080e7          	jalr	-1058(ra) # 80006194 <panic>
    panic("sched running");
    800015be:	00007517          	auipc	a0,0x7
    800015c2:	bfa50513          	addi	a0,a0,-1030 # 800081b8 <etext+0x1b8>
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	bce080e7          	jalr	-1074(ra) # 80006194 <panic>
    panic("sched interruptible");
    800015ce:	00007517          	auipc	a0,0x7
    800015d2:	bfa50513          	addi	a0,a0,-1030 # 800081c8 <etext+0x1c8>
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	bbe080e7          	jalr	-1090(ra) # 80006194 <panic>

00000000800015de <yield>:
{
    800015de:	1101                	addi	sp,sp,-32
    800015e0:	ec06                	sd	ra,24(sp)
    800015e2:	e822                	sd	s0,16(sp)
    800015e4:	e426                	sd	s1,8(sp)
    800015e6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	96e080e7          	jalr	-1682(ra) # 80000f56 <myproc>
    800015f0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	0c4080e7          	jalr	196(ra) # 800066b6 <acquire>
  p->state = RUNNABLE;
    800015fa:	478d                	li	a5,3
    800015fc:	d09c                	sw	a5,32(s1)
  sched();
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	f0a080e7          	jalr	-246(ra) # 80001508 <sched>
  release(&p->lock);
    80001606:	8526                	mv	a0,s1
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	17e080e7          	jalr	382(ra) # 80006786 <release>
}
    80001610:	60e2                	ld	ra,24(sp)
    80001612:	6442                	ld	s0,16(sp)
    80001614:	64a2                	ld	s1,8(sp)
    80001616:	6105                	addi	sp,sp,32
    80001618:	8082                	ret

000000008000161a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000161a:	7179                	addi	sp,sp,-48
    8000161c:	f406                	sd	ra,40(sp)
    8000161e:	f022                	sd	s0,32(sp)
    80001620:	ec26                	sd	s1,24(sp)
    80001622:	e84a                	sd	s2,16(sp)
    80001624:	e44e                	sd	s3,8(sp)
    80001626:	1800                	addi	s0,sp,48
    80001628:	89aa                	mv	s3,a0
    8000162a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	92a080e7          	jalr	-1750(ra) # 80000f56 <myproc>
    80001634:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	080080e7          	jalr	128(ra) # 800066b6 <acquire>
  release(lk);
    8000163e:	854a                	mv	a0,s2
    80001640:	00005097          	auipc	ra,0x5
    80001644:	146080e7          	jalr	326(ra) # 80006786 <release>

  // Go to sleep.
  p->chan = chan;
    80001648:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000164c:	4789                	li	a5,2
    8000164e:	d09c                	sw	a5,32(s1)

  sched();
    80001650:	00000097          	auipc	ra,0x0
    80001654:	eb8080e7          	jalr	-328(ra) # 80001508 <sched>

  // Tidy up.
  p->chan = 0;
    80001658:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	128080e7          	jalr	296(ra) # 80006786 <release>
  acquire(lk);
    80001666:	854a                	mv	a0,s2
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	04e080e7          	jalr	78(ra) # 800066b6 <acquire>
}
    80001670:	70a2                	ld	ra,40(sp)
    80001672:	7402                	ld	s0,32(sp)
    80001674:	64e2                	ld	s1,24(sp)
    80001676:	6942                	ld	s2,16(sp)
    80001678:	69a2                	ld	s3,8(sp)
    8000167a:	6145                	addi	sp,sp,48
    8000167c:	8082                	ret

000000008000167e <wait>:
{
    8000167e:	715d                	addi	sp,sp,-80
    80001680:	e486                	sd	ra,72(sp)
    80001682:	e0a2                	sd	s0,64(sp)
    80001684:	fc26                	sd	s1,56(sp)
    80001686:	f84a                	sd	s2,48(sp)
    80001688:	f44e                	sd	s3,40(sp)
    8000168a:	f052                	sd	s4,32(sp)
    8000168c:	ec56                	sd	s5,24(sp)
    8000168e:	e85a                	sd	s6,16(sp)
    80001690:	e45e                	sd	s7,8(sp)
    80001692:	e062                	sd	s8,0(sp)
    80001694:	0880                	addi	s0,sp,80
    80001696:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	8be080e7          	jalr	-1858(ra) # 80000f56 <myproc>
    800016a0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016a2:	00008517          	auipc	a0,0x8
    800016a6:	aee50513          	addi	a0,a0,-1298 # 80009190 <wait_lock>
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	00c080e7          	jalr	12(ra) # 800066b6 <acquire>
    havekids = 0;
    800016b2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016b4:	4a15                	li	s4,5
        havekids = 1;
    800016b6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016b8:	0000e997          	auipc	s3,0xe
    800016bc:	af898993          	addi	s3,s3,-1288 # 8000f1b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c0:	00008c17          	auipc	s8,0x8
    800016c4:	ad0c0c13          	addi	s8,s8,-1328 # 80009190 <wait_lock>
    havekids = 0;
    800016c8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016ca:	00008497          	auipc	s1,0x8
    800016ce:	ee648493          	addi	s1,s1,-282 # 800095b0 <proc>
    800016d2:	a0bd                	j	80001740 <wait+0xc2>
          pid = np->pid;
    800016d4:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016d8:	000b0e63          	beqz	s6,800016f4 <wait+0x76>
    800016dc:	4691                	li	a3,4
    800016de:	03448613          	addi	a2,s1,52
    800016e2:	85da                	mv	a1,s6
    800016e4:	05893503          	ld	a0,88(s2)
    800016e8:	fffff097          	auipc	ra,0xfffff
    800016ec:	532080e7          	jalr	1330(ra) # 80000c1a <copyout>
    800016f0:	02054563          	bltz	a0,8000171a <wait+0x9c>
          freeproc(np);
    800016f4:	8526                	mv	a0,s1
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	a12080e7          	jalr	-1518(ra) # 80001108 <freeproc>
          release(&np->lock);
    800016fe:	8526                	mv	a0,s1
    80001700:	00005097          	auipc	ra,0x5
    80001704:	086080e7          	jalr	134(ra) # 80006786 <release>
          release(&wait_lock);
    80001708:	00008517          	auipc	a0,0x8
    8000170c:	a8850513          	addi	a0,a0,-1400 # 80009190 <wait_lock>
    80001710:	00005097          	auipc	ra,0x5
    80001714:	076080e7          	jalr	118(ra) # 80006786 <release>
          return pid;
    80001718:	a09d                	j	8000177e <wait+0x100>
            release(&np->lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	06a080e7          	jalr	106(ra) # 80006786 <release>
            release(&wait_lock);
    80001724:	00008517          	auipc	a0,0x8
    80001728:	a6c50513          	addi	a0,a0,-1428 # 80009190 <wait_lock>
    8000172c:	00005097          	auipc	ra,0x5
    80001730:	05a080e7          	jalr	90(ra) # 80006786 <release>
            return -1;
    80001734:	59fd                	li	s3,-1
    80001736:	a0a1                	j	8000177e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001738:	17048493          	addi	s1,s1,368
    8000173c:	03348463          	beq	s1,s3,80001764 <wait+0xe6>
      if(np->parent == p){
    80001740:	60bc                	ld	a5,64(s1)
    80001742:	ff279be3          	bne	a5,s2,80001738 <wait+0xba>
        acquire(&np->lock);
    80001746:	8526                	mv	a0,s1
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	f6e080e7          	jalr	-146(ra) # 800066b6 <acquire>
        if(np->state == ZOMBIE){
    80001750:	509c                	lw	a5,32(s1)
    80001752:	f94781e3          	beq	a5,s4,800016d4 <wait+0x56>
        release(&np->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	02e080e7          	jalr	46(ra) # 80006786 <release>
        havekids = 1;
    80001760:	8756                	mv	a4,s5
    80001762:	bfd9                	j	80001738 <wait+0xba>
    if(!havekids || p->killed){
    80001764:	c701                	beqz	a4,8000176c <wait+0xee>
    80001766:	03092783          	lw	a5,48(s2)
    8000176a:	c79d                	beqz	a5,80001798 <wait+0x11a>
      release(&wait_lock);
    8000176c:	00008517          	auipc	a0,0x8
    80001770:	a2450513          	addi	a0,a0,-1500 # 80009190 <wait_lock>
    80001774:	00005097          	auipc	ra,0x5
    80001778:	012080e7          	jalr	18(ra) # 80006786 <release>
      return -1;
    8000177c:	59fd                	li	s3,-1
}
    8000177e:	854e                	mv	a0,s3
    80001780:	60a6                	ld	ra,72(sp)
    80001782:	6406                	ld	s0,64(sp)
    80001784:	74e2                	ld	s1,56(sp)
    80001786:	7942                	ld	s2,48(sp)
    80001788:	79a2                	ld	s3,40(sp)
    8000178a:	7a02                	ld	s4,32(sp)
    8000178c:	6ae2                	ld	s5,24(sp)
    8000178e:	6b42                	ld	s6,16(sp)
    80001790:	6ba2                	ld	s7,8(sp)
    80001792:	6c02                	ld	s8,0(sp)
    80001794:	6161                	addi	sp,sp,80
    80001796:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001798:	85e2                	mv	a1,s8
    8000179a:	854a                	mv	a0,s2
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	e7e080e7          	jalr	-386(ra) # 8000161a <sleep>
    havekids = 0;
    800017a4:	b715                	j	800016c8 <wait+0x4a>

00000000800017a6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017a6:	7139                	addi	sp,sp,-64
    800017a8:	fc06                	sd	ra,56(sp)
    800017aa:	f822                	sd	s0,48(sp)
    800017ac:	f426                	sd	s1,40(sp)
    800017ae:	f04a                	sd	s2,32(sp)
    800017b0:	ec4e                	sd	s3,24(sp)
    800017b2:	e852                	sd	s4,16(sp)
    800017b4:	e456                	sd	s5,8(sp)
    800017b6:	0080                	addi	s0,sp,64
    800017b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	00008497          	auipc	s1,0x8
    800017be:	df648493          	addi	s1,s1,-522 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017c2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017c4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c6:	0000e917          	auipc	s2,0xe
    800017ca:	9ea90913          	addi	s2,s2,-1558 # 8000f1b0 <tickslock>
    800017ce:	a811                	j	800017e2 <wakeup+0x3c>
      }
      release(&p->lock);
    800017d0:	8526                	mv	a0,s1
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	fb4080e7          	jalr	-76(ra) # 80006786 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017da:	17048493          	addi	s1,s1,368
    800017de:	03248663          	beq	s1,s2,8000180a <wakeup+0x64>
    if(p != myproc()){
    800017e2:	fffff097          	auipc	ra,0xfffff
    800017e6:	774080e7          	jalr	1908(ra) # 80000f56 <myproc>
    800017ea:	fea488e3          	beq	s1,a0,800017da <wakeup+0x34>
      acquire(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	ec6080e7          	jalr	-314(ra) # 800066b6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017f8:	509c                	lw	a5,32(s1)
    800017fa:	fd379be3          	bne	a5,s3,800017d0 <wakeup+0x2a>
    800017fe:	749c                	ld	a5,40(s1)
    80001800:	fd4798e3          	bne	a5,s4,800017d0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001804:	0354a023          	sw	s5,32(s1)
    80001808:	b7e1                	j	800017d0 <wakeup+0x2a>
    }
  }
}
    8000180a:	70e2                	ld	ra,56(sp)
    8000180c:	7442                	ld	s0,48(sp)
    8000180e:	74a2                	ld	s1,40(sp)
    80001810:	7902                	ld	s2,32(sp)
    80001812:	69e2                	ld	s3,24(sp)
    80001814:	6a42                	ld	s4,16(sp)
    80001816:	6aa2                	ld	s5,8(sp)
    80001818:	6121                	addi	sp,sp,64
    8000181a:	8082                	ret

000000008000181c <reparent>:
{
    8000181c:	7179                	addi	sp,sp,-48
    8000181e:	f406                	sd	ra,40(sp)
    80001820:	f022                	sd	s0,32(sp)
    80001822:	ec26                	sd	s1,24(sp)
    80001824:	e84a                	sd	s2,16(sp)
    80001826:	e44e                	sd	s3,8(sp)
    80001828:	e052                	sd	s4,0(sp)
    8000182a:	1800                	addi	s0,sp,48
    8000182c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000182e:	00008497          	auipc	s1,0x8
    80001832:	d8248493          	addi	s1,s1,-638 # 800095b0 <proc>
      pp->parent = initproc;
    80001836:	00007a17          	auipc	s4,0x7
    8000183a:	7daa0a13          	addi	s4,s4,2010 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000183e:	0000e997          	auipc	s3,0xe
    80001842:	97298993          	addi	s3,s3,-1678 # 8000f1b0 <tickslock>
    80001846:	a029                	j	80001850 <reparent+0x34>
    80001848:	17048493          	addi	s1,s1,368
    8000184c:	01348d63          	beq	s1,s3,80001866 <reparent+0x4a>
    if(pp->parent == p){
    80001850:	60bc                	ld	a5,64(s1)
    80001852:	ff279be3          	bne	a5,s2,80001848 <reparent+0x2c>
      pp->parent = initproc;
    80001856:	000a3503          	ld	a0,0(s4)
    8000185a:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	f4a080e7          	jalr	-182(ra) # 800017a6 <wakeup>
    80001864:	b7d5                	j	80001848 <reparent+0x2c>
}
    80001866:	70a2                	ld	ra,40(sp)
    80001868:	7402                	ld	s0,32(sp)
    8000186a:	64e2                	ld	s1,24(sp)
    8000186c:	6942                	ld	s2,16(sp)
    8000186e:	69a2                	ld	s3,8(sp)
    80001870:	6a02                	ld	s4,0(sp)
    80001872:	6145                	addi	sp,sp,48
    80001874:	8082                	ret

0000000080001876 <exit>:
{
    80001876:	7179                	addi	sp,sp,-48
    80001878:	f406                	sd	ra,40(sp)
    8000187a:	f022                	sd	s0,32(sp)
    8000187c:	ec26                	sd	s1,24(sp)
    8000187e:	e84a                	sd	s2,16(sp)
    80001880:	e44e                	sd	s3,8(sp)
    80001882:	e052                	sd	s4,0(sp)
    80001884:	1800                	addi	s0,sp,48
    80001886:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001888:	fffff097          	auipc	ra,0xfffff
    8000188c:	6ce080e7          	jalr	1742(ra) # 80000f56 <myproc>
    80001890:	89aa                	mv	s3,a0
  if(p == initproc)
    80001892:	00007797          	auipc	a5,0x7
    80001896:	77e7b783          	ld	a5,1918(a5) # 80009010 <initproc>
    8000189a:	0d850493          	addi	s1,a0,216
    8000189e:	15850913          	addi	s2,a0,344
    800018a2:	02a79363          	bne	a5,a0,800018c8 <exit+0x52>
    panic("init exiting");
    800018a6:	00007517          	auipc	a0,0x7
    800018aa:	93a50513          	addi	a0,a0,-1734 # 800081e0 <etext+0x1e0>
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	8e6080e7          	jalr	-1818(ra) # 80006194 <panic>
      fileclose(f);
    800018b6:	00002097          	auipc	ra,0x2
    800018ba:	3cc080e7          	jalr	972(ra) # 80003c82 <fileclose>
      p->ofile[fd] = 0;
    800018be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c2:	04a1                	addi	s1,s1,8
    800018c4:	01248563          	beq	s1,s2,800018ce <exit+0x58>
    if(p->ofile[fd]){
    800018c8:	6088                	ld	a0,0(s1)
    800018ca:	f575                	bnez	a0,800018b6 <exit+0x40>
    800018cc:	bfdd                	j	800018c2 <exit+0x4c>
  begin_op();
    800018ce:	00002097          	auipc	ra,0x2
    800018d2:	eec080e7          	jalr	-276(ra) # 800037ba <begin_op>
  iput(p->cwd);
    800018d6:	1589b503          	ld	a0,344(s3)
    800018da:	00001097          	auipc	ra,0x1
    800018de:	6be080e7          	jalr	1726(ra) # 80002f98 <iput>
  end_op();
    800018e2:	00002097          	auipc	ra,0x2
    800018e6:	f56080e7          	jalr	-170(ra) # 80003838 <end_op>
  p->cwd = 0;
    800018ea:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800018ee:	00008497          	auipc	s1,0x8
    800018f2:	8a248493          	addi	s1,s1,-1886 # 80009190 <wait_lock>
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	dbe080e7          	jalr	-578(ra) # 800066b6 <acquire>
  reparent(p);
    80001900:	854e                	mv	a0,s3
    80001902:	00000097          	auipc	ra,0x0
    80001906:	f1a080e7          	jalr	-230(ra) # 8000181c <reparent>
  wakeup(p->parent);
    8000190a:	0409b503          	ld	a0,64(s3)
    8000190e:	00000097          	auipc	ra,0x0
    80001912:	e98080e7          	jalr	-360(ra) # 800017a6 <wakeup>
  acquire(&p->lock);
    80001916:	854e                	mv	a0,s3
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	d9e080e7          	jalr	-610(ra) # 800066b6 <acquire>
  p->xstate = status;
    80001920:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001924:	4795                	li	a5,5
    80001926:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	e5a080e7          	jalr	-422(ra) # 80006786 <release>
  sched();
    80001934:	00000097          	auipc	ra,0x0
    80001938:	bd4080e7          	jalr	-1068(ra) # 80001508 <sched>
  panic("zombie exit");
    8000193c:	00007517          	auipc	a0,0x7
    80001940:	8b450513          	addi	a0,a0,-1868 # 800081f0 <etext+0x1f0>
    80001944:	00005097          	auipc	ra,0x5
    80001948:	850080e7          	jalr	-1968(ra) # 80006194 <panic>

000000008000194c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000194c:	7179                	addi	sp,sp,-48
    8000194e:	f406                	sd	ra,40(sp)
    80001950:	f022                	sd	s0,32(sp)
    80001952:	ec26                	sd	s1,24(sp)
    80001954:	e84a                	sd	s2,16(sp)
    80001956:	e44e                	sd	s3,8(sp)
    80001958:	1800                	addi	s0,sp,48
    8000195a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000195c:	00008497          	auipc	s1,0x8
    80001960:	c5448493          	addi	s1,s1,-940 # 800095b0 <proc>
    80001964:	0000e997          	auipc	s3,0xe
    80001968:	84c98993          	addi	s3,s3,-1972 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000196c:	8526                	mv	a0,s1
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	d48080e7          	jalr	-696(ra) # 800066b6 <acquire>
    if(p->pid == pid){
    80001976:	5c9c                	lw	a5,56(s1)
    80001978:	01278d63          	beq	a5,s2,80001992 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000197c:	8526                	mv	a0,s1
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	e08080e7          	jalr	-504(ra) # 80006786 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	17048493          	addi	s1,s1,368
    8000198a:	ff3491e3          	bne	s1,s3,8000196c <kill+0x20>
  }
  return -1;
    8000198e:	557d                	li	a0,-1
    80001990:	a829                	j	800019aa <kill+0x5e>
      p->killed = 1;
    80001992:	4785                	li	a5,1
    80001994:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001996:	5098                	lw	a4,32(s1)
    80001998:	4789                	li	a5,2
    8000199a:	00f70f63          	beq	a4,a5,800019b8 <kill+0x6c>
      release(&p->lock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	de6080e7          	jalr	-538(ra) # 80006786 <release>
      return 0;
    800019a8:	4501                	li	a0,0
}
    800019aa:	70a2                	ld	ra,40(sp)
    800019ac:	7402                	ld	s0,32(sp)
    800019ae:	64e2                	ld	s1,24(sp)
    800019b0:	6942                	ld	s2,16(sp)
    800019b2:	69a2                	ld	s3,8(sp)
    800019b4:	6145                	addi	sp,sp,48
    800019b6:	8082                	ret
        p->state = RUNNABLE;
    800019b8:	478d                	li	a5,3
    800019ba:	d09c                	sw	a5,32(s1)
    800019bc:	b7cd                	j	8000199e <kill+0x52>

00000000800019be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019be:	7179                	addi	sp,sp,-48
    800019c0:	f406                	sd	ra,40(sp)
    800019c2:	f022                	sd	s0,32(sp)
    800019c4:	ec26                	sd	s1,24(sp)
    800019c6:	e84a                	sd	s2,16(sp)
    800019c8:	e44e                	sd	s3,8(sp)
    800019ca:	e052                	sd	s4,0(sp)
    800019cc:	1800                	addi	s0,sp,48
    800019ce:	84aa                	mv	s1,a0
    800019d0:	892e                	mv	s2,a1
    800019d2:	89b2                	mv	s3,a2
    800019d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	580080e7          	jalr	1408(ra) # 80000f56 <myproc>
  if(user_dst){
    800019de:	c08d                	beqz	s1,80001a00 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019e0:	86d2                	mv	a3,s4
    800019e2:	864e                	mv	a2,s3
    800019e4:	85ca                	mv	a1,s2
    800019e6:	6d28                	ld	a0,88(a0)
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	232080e7          	jalr	562(ra) # 80000c1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019f0:	70a2                	ld	ra,40(sp)
    800019f2:	7402                	ld	s0,32(sp)
    800019f4:	64e2                	ld	s1,24(sp)
    800019f6:	6942                	ld	s2,16(sp)
    800019f8:	69a2                	ld	s3,8(sp)
    800019fa:	6a02                	ld	s4,0(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret
    memmove((char *)dst, src, len);
    80001a00:	000a061b          	sext.w	a2,s4
    80001a04:	85ce                	mv	a1,s3
    80001a06:	854a                	mv	a0,s2
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	8d0080e7          	jalr	-1840(ra) # 800002d8 <memmove>
    return 0;
    80001a10:	8526                	mv	a0,s1
    80001a12:	bff9                	j	800019f0 <either_copyout+0x32>

0000000080001a14 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a14:	7179                	addi	sp,sp,-48
    80001a16:	f406                	sd	ra,40(sp)
    80001a18:	f022                	sd	s0,32(sp)
    80001a1a:	ec26                	sd	s1,24(sp)
    80001a1c:	e84a                	sd	s2,16(sp)
    80001a1e:	e44e                	sd	s3,8(sp)
    80001a20:	e052                	sd	s4,0(sp)
    80001a22:	1800                	addi	s0,sp,48
    80001a24:	892a                	mv	s2,a0
    80001a26:	84ae                	mv	s1,a1
    80001a28:	89b2                	mv	s3,a2
    80001a2a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	52a080e7          	jalr	1322(ra) # 80000f56 <myproc>
  if(user_src){
    80001a34:	c08d                	beqz	s1,80001a56 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a36:	86d2                	mv	a3,s4
    80001a38:	864e                	mv	a2,s3
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	6d28                	ld	a0,88(a0)
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	268080e7          	jalr	616(ra) # 80000ca6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a46:	70a2                	ld	ra,40(sp)
    80001a48:	7402                	ld	s0,32(sp)
    80001a4a:	64e2                	ld	s1,24(sp)
    80001a4c:	6942                	ld	s2,16(sp)
    80001a4e:	69a2                	ld	s3,8(sp)
    80001a50:	6a02                	ld	s4,0(sp)
    80001a52:	6145                	addi	sp,sp,48
    80001a54:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a56:	000a061b          	sext.w	a2,s4
    80001a5a:	85ce                	mv	a1,s3
    80001a5c:	854a                	mv	a0,s2
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	87a080e7          	jalr	-1926(ra) # 800002d8 <memmove>
    return 0;
    80001a66:	8526                	mv	a0,s1
    80001a68:	bff9                	j	80001a46 <either_copyin+0x32>

0000000080001a6a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a6a:	715d                	addi	sp,sp,-80
    80001a6c:	e486                	sd	ra,72(sp)
    80001a6e:	e0a2                	sd	s0,64(sp)
    80001a70:	fc26                	sd	s1,56(sp)
    80001a72:	f84a                	sd	s2,48(sp)
    80001a74:	f44e                	sd	s3,40(sp)
    80001a76:	f052                	sd	s4,32(sp)
    80001a78:	ec56                	sd	s5,24(sp)
    80001a7a:	e85a                	sd	s6,16(sp)
    80001a7c:	e45e                	sd	s7,8(sp)
    80001a7e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a80:	00007517          	auipc	a0,0x7
    80001a84:	df850513          	addi	a0,a0,-520 # 80008878 <digits+0x88>
    80001a88:	00004097          	auipc	ra,0x4
    80001a8c:	756080e7          	jalr	1878(ra) # 800061de <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a90:	00008497          	auipc	s1,0x8
    80001a94:	c8048493          	addi	s1,s1,-896 # 80009710 <proc+0x160>
    80001a98:	0000e917          	auipc	s2,0xe
    80001a9c:	87890913          	addi	s2,s2,-1928 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa2:	00006997          	auipc	s3,0x6
    80001aa6:	75e98993          	addi	s3,s3,1886 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001aaa:	00006a97          	auipc	s5,0x6
    80001aae:	75ea8a93          	addi	s5,s5,1886 # 80008208 <etext+0x208>
    printf("\n");
    80001ab2:	00007a17          	auipc	s4,0x7
    80001ab6:	dc6a0a13          	addi	s4,s4,-570 # 80008878 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aba:	00006b97          	auipc	s7,0x6
    80001abe:	786b8b93          	addi	s7,s7,1926 # 80008240 <states.0>
    80001ac2:	a00d                	j	80001ae4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac4:	ed86a583          	lw	a1,-296(a3)
    80001ac8:	8556                	mv	a0,s5
    80001aca:	00004097          	auipc	ra,0x4
    80001ace:	714080e7          	jalr	1812(ra) # 800061de <printf>
    printf("\n");
    80001ad2:	8552                	mv	a0,s4
    80001ad4:	00004097          	auipc	ra,0x4
    80001ad8:	70a080e7          	jalr	1802(ra) # 800061de <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001adc:	17048493          	addi	s1,s1,368
    80001ae0:	03248263          	beq	s1,s2,80001b04 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ae4:	86a6                	mv	a3,s1
    80001ae6:	ec04a783          	lw	a5,-320(s1)
    80001aea:	dbed                	beqz	a5,80001adc <procdump+0x72>
      state = "???";
    80001aec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aee:	fcfb6be3          	bltu	s6,a5,80001ac4 <procdump+0x5a>
    80001af2:	02079713          	slli	a4,a5,0x20
    80001af6:	01d75793          	srli	a5,a4,0x1d
    80001afa:	97de                	add	a5,a5,s7
    80001afc:	6390                	ld	a2,0(a5)
    80001afe:	f279                	bnez	a2,80001ac4 <procdump+0x5a>
      state = "???";
    80001b00:	864e                	mv	a2,s3
    80001b02:	b7c9                	j	80001ac4 <procdump+0x5a>
  }
}
    80001b04:	60a6                	ld	ra,72(sp)
    80001b06:	6406                	ld	s0,64(sp)
    80001b08:	74e2                	ld	s1,56(sp)
    80001b0a:	7942                	ld	s2,48(sp)
    80001b0c:	79a2                	ld	s3,40(sp)
    80001b0e:	7a02                	ld	s4,32(sp)
    80001b10:	6ae2                	ld	s5,24(sp)
    80001b12:	6b42                	ld	s6,16(sp)
    80001b14:	6ba2                	ld	s7,8(sp)
    80001b16:	6161                	addi	sp,sp,80
    80001b18:	8082                	ret

0000000080001b1a <swtch>:
    80001b1a:	00153023          	sd	ra,0(a0)
    80001b1e:	00253423          	sd	sp,8(a0)
    80001b22:	e900                	sd	s0,16(a0)
    80001b24:	ed04                	sd	s1,24(a0)
    80001b26:	03253023          	sd	s2,32(a0)
    80001b2a:	03353423          	sd	s3,40(a0)
    80001b2e:	03453823          	sd	s4,48(a0)
    80001b32:	03553c23          	sd	s5,56(a0)
    80001b36:	05653023          	sd	s6,64(a0)
    80001b3a:	05753423          	sd	s7,72(a0)
    80001b3e:	05853823          	sd	s8,80(a0)
    80001b42:	05953c23          	sd	s9,88(a0)
    80001b46:	07a53023          	sd	s10,96(a0)
    80001b4a:	07b53423          	sd	s11,104(a0)
    80001b4e:	0005b083          	ld	ra,0(a1)
    80001b52:	0085b103          	ld	sp,8(a1)
    80001b56:	6980                	ld	s0,16(a1)
    80001b58:	6d84                	ld	s1,24(a1)
    80001b5a:	0205b903          	ld	s2,32(a1)
    80001b5e:	0285b983          	ld	s3,40(a1)
    80001b62:	0305ba03          	ld	s4,48(a1)
    80001b66:	0385ba83          	ld	s5,56(a1)
    80001b6a:	0405bb03          	ld	s6,64(a1)
    80001b6e:	0485bb83          	ld	s7,72(a1)
    80001b72:	0505bc03          	ld	s8,80(a1)
    80001b76:	0585bc83          	ld	s9,88(a1)
    80001b7a:	0605bd03          	ld	s10,96(a1)
    80001b7e:	0685bd83          	ld	s11,104(a1)
    80001b82:	8082                	ret

0000000080001b84 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b84:	1141                	addi	sp,sp,-16
    80001b86:	e406                	sd	ra,8(sp)
    80001b88:	e022                	sd	s0,0(sp)
    80001b8a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b8c:	00006597          	auipc	a1,0x6
    80001b90:	6e458593          	addi	a1,a1,1764 # 80008270 <states.0+0x30>
    80001b94:	0000d517          	auipc	a0,0xd
    80001b98:	61c50513          	addi	a0,a0,1564 # 8000f1b0 <tickslock>
    80001b9c:	00005097          	auipc	ra,0x5
    80001ba0:	c96080e7          	jalr	-874(ra) # 80006832 <initlock>
}
    80001ba4:	60a2                	ld	ra,8(sp)
    80001ba6:	6402                	ld	s0,0(sp)
    80001ba8:	0141                	addi	sp,sp,16
    80001baa:	8082                	ret

0000000080001bac <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bac:	1141                	addi	sp,sp,-16
    80001bae:	e422                	sd	s0,8(sp)
    80001bb0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb2:	00003797          	auipc	a5,0x3
    80001bb6:	70e78793          	addi	a5,a5,1806 # 800052c0 <kernelvec>
    80001bba:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bbe:	6422                	ld	s0,8(sp)
    80001bc0:	0141                	addi	sp,sp,16
    80001bc2:	8082                	ret

0000000080001bc4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc4:	1141                	addi	sp,sp,-16
    80001bc6:	e406                	sd	ra,8(sp)
    80001bc8:	e022                	sd	s0,0(sp)
    80001bca:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	38a080e7          	jalr	906(ra) # 80000f56 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bda:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bde:	00005697          	auipc	a3,0x5
    80001be2:	42268693          	addi	a3,a3,1058 # 80007000 <_trampoline>
    80001be6:	00005717          	auipc	a4,0x5
    80001bea:	41a70713          	addi	a4,a4,1050 # 80007000 <_trampoline>
    80001bee:	8f15                	sub	a4,a4,a3
    80001bf0:	040007b7          	lui	a5,0x4000
    80001bf4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bf6:	07b2                	slli	a5,a5,0xc
    80001bf8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bfa:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfe:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c00:	18002673          	csrr	a2,satp
    80001c04:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c06:	7130                	ld	a2,96(a0)
    80001c08:	6538                	ld	a4,72(a0)
    80001c0a:	6585                	lui	a1,0x1
    80001c0c:	972e                	add	a4,a4,a1
    80001c0e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c10:	7138                	ld	a4,96(a0)
    80001c12:	00000617          	auipc	a2,0x0
    80001c16:	13860613          	addi	a2,a2,312 # 80001d4a <usertrap>
    80001c1a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1e:	8612                	mv	a2,tp
    80001c20:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c22:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c26:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c2a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c32:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c34:	6f18                	ld	a4,24(a4)
    80001c36:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c3a:	6d2c                	ld	a1,88(a0)
    80001c3c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c3e:	00005717          	auipc	a4,0x5
    80001c42:	45270713          	addi	a4,a4,1106 # 80007090 <userret>
    80001c46:	8f15                	sub	a4,a4,a3
    80001c48:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c4a:	577d                	li	a4,-1
    80001c4c:	177e                	slli	a4,a4,0x3f
    80001c4e:	8dd9                	or	a1,a1,a4
    80001c50:	02000537          	lui	a0,0x2000
    80001c54:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c56:	0536                	slli	a0,a0,0xd
    80001c58:	9782                	jalr	a5
}
    80001c5a:	60a2                	ld	ra,8(sp)
    80001c5c:	6402                	ld	s0,0(sp)
    80001c5e:	0141                	addi	sp,sp,16
    80001c60:	8082                	ret

0000000080001c62 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c62:	1101                	addi	sp,sp,-32
    80001c64:	ec06                	sd	ra,24(sp)
    80001c66:	e822                	sd	s0,16(sp)
    80001c68:	e426                	sd	s1,8(sp)
    80001c6a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c6c:	0000d497          	auipc	s1,0xd
    80001c70:	54448493          	addi	s1,s1,1348 # 8000f1b0 <tickslock>
    80001c74:	8526                	mv	a0,s1
    80001c76:	00005097          	auipc	ra,0x5
    80001c7a:	a40080e7          	jalr	-1472(ra) # 800066b6 <acquire>
  ticks++;
    80001c7e:	00007517          	auipc	a0,0x7
    80001c82:	39a50513          	addi	a0,a0,922 # 80009018 <ticks>
    80001c86:	411c                	lw	a5,0(a0)
    80001c88:	2785                	addiw	a5,a5,1
    80001c8a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c8c:	00000097          	auipc	ra,0x0
    80001c90:	b1a080e7          	jalr	-1254(ra) # 800017a6 <wakeup>
  release(&tickslock);
    80001c94:	8526                	mv	a0,s1
    80001c96:	00005097          	auipc	ra,0x5
    80001c9a:	af0080e7          	jalr	-1296(ra) # 80006786 <release>
}
    80001c9e:	60e2                	ld	ra,24(sp)
    80001ca0:	6442                	ld	s0,16(sp)
    80001ca2:	64a2                	ld	s1,8(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret

0000000080001ca8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cb6:	00074d63          	bltz	a4,80001cd0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cba:	57fd                	li	a5,-1
    80001cbc:	17fe                	slli	a5,a5,0x3f
    80001cbe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cc0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc2:	06f70363          	beq	a4,a5,80001d28 <devintr+0x80>
  }
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret
     (scause & 0xff) == 9){
    80001cd0:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001cd4:	46a5                	li	a3,9
    80001cd6:	fed792e3          	bne	a5,a3,80001cba <devintr+0x12>
    int irq = plic_claim();
    80001cda:	00003097          	auipc	ra,0x3
    80001cde:	6ee080e7          	jalr	1774(ra) # 800053c8 <plic_claim>
    80001ce2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ce4:	47a9                	li	a5,10
    80001ce6:	02f50763          	beq	a0,a5,80001d14 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cea:	4785                	li	a5,1
    80001cec:	02f50963          	beq	a0,a5,80001d1e <devintr+0x76>
    return 1;
    80001cf0:	4505                	li	a0,1
    } else if(irq){
    80001cf2:	d8f1                	beqz	s1,80001cc6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cf4:	85a6                	mv	a1,s1
    80001cf6:	00006517          	auipc	a0,0x6
    80001cfa:	58250513          	addi	a0,a0,1410 # 80008278 <states.0+0x38>
    80001cfe:	00004097          	auipc	ra,0x4
    80001d02:	4e0080e7          	jalr	1248(ra) # 800061de <printf>
      plic_complete(irq);
    80001d06:	8526                	mv	a0,s1
    80001d08:	00003097          	auipc	ra,0x3
    80001d0c:	6e4080e7          	jalr	1764(ra) # 800053ec <plic_complete>
    return 1;
    80001d10:	4505                	li	a0,1
    80001d12:	bf55                	j	80001cc6 <devintr+0x1e>
      uartintr();
    80001d14:	00005097          	auipc	ra,0x5
    80001d18:	8d8080e7          	jalr	-1832(ra) # 800065ec <uartintr>
    80001d1c:	b7ed                	j	80001d06 <devintr+0x5e>
      virtio_disk_intr();
    80001d1e:	00004097          	auipc	ra,0x4
    80001d22:	b5a080e7          	jalr	-1190(ra) # 80005878 <virtio_disk_intr>
    80001d26:	b7c5                	j	80001d06 <devintr+0x5e>
    if(cpuid() == 0){
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	202080e7          	jalr	514(ra) # 80000f2a <cpuid>
    80001d30:	c901                	beqz	a0,80001d40 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d32:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d36:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d38:	14479073          	csrw	sip,a5
    return 2;
    80001d3c:	4509                	li	a0,2
    80001d3e:	b761                	j	80001cc6 <devintr+0x1e>
      clockintr();
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	f22080e7          	jalr	-222(ra) # 80001c62 <clockintr>
    80001d48:	b7ed                	j	80001d32 <devintr+0x8a>

0000000080001d4a <usertrap>:
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	e04a                	sd	s2,0(sp)
    80001d54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d56:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d5a:	1007f793          	andi	a5,a5,256
    80001d5e:	e3ad                	bnez	a5,80001dc0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d60:	00003797          	auipc	a5,0x3
    80001d64:	56078793          	addi	a5,a5,1376 # 800052c0 <kernelvec>
    80001d68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	1ea080e7          	jalr	490(ra) # 80000f56 <myproc>
    80001d74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d76:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d78:	14102773          	csrr	a4,sepc
    80001d7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d82:	47a1                	li	a5,8
    80001d84:	04f71c63          	bne	a4,a5,80001ddc <usertrap+0x92>
    if(p->killed)
    80001d88:	591c                	lw	a5,48(a0)
    80001d8a:	e3b9                	bnez	a5,80001dd0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d8c:	70b8                	ld	a4,96(s1)
    80001d8e:	6f1c                	ld	a5,24(a4)
    80001d90:	0791                	addi	a5,a5,4
    80001d92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	2e0080e7          	jalr	736(ra) # 80002080 <syscall>
  if(p->killed)
    80001da8:	589c                	lw	a5,48(s1)
    80001daa:	ebc1                	bnez	a5,80001e3a <usertrap+0xf0>
  usertrapret();
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	e18080e7          	jalr	-488(ra) # 80001bc4 <usertrapret>
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	64a2                	ld	s1,8(sp)
    80001dba:	6902                	ld	s2,0(sp)
    80001dbc:	6105                	addi	sp,sp,32
    80001dbe:	8082                	ret
    panic("usertrap: not from user mode");
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4d850513          	addi	a0,a0,1240 # 80008298 <states.0+0x58>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	3cc080e7          	jalr	972(ra) # 80006194 <panic>
      exit(-1);
    80001dd0:	557d                	li	a0,-1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	aa4080e7          	jalr	-1372(ra) # 80001876 <exit>
    80001dda:	bf4d                	j	80001d8c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	ecc080e7          	jalr	-308(ra) # 80001ca8 <devintr>
    80001de4:	892a                	mv	s2,a0
    80001de6:	c501                	beqz	a0,80001dee <usertrap+0xa4>
  if(p->killed)
    80001de8:	589c                	lw	a5,48(s1)
    80001dea:	c3a1                	beqz	a5,80001e2a <usertrap+0xe0>
    80001dec:	a815                	j	80001e20 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dee:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df2:	5c90                	lw	a2,56(s1)
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	4c450513          	addi	a0,a0,1220 # 800082b8 <states.0+0x78>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	3e2080e7          	jalr	994(ra) # 800061de <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e04:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e08:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	4dc50513          	addi	a0,a0,1244 # 800082e8 <states.0+0xa8>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	3ca080e7          	jalr	970(ra) # 800061de <printf>
    p->killed = 1;
    80001e1c:	4785                	li	a5,1
    80001e1e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e20:	557d                	li	a0,-1
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	a54080e7          	jalr	-1452(ra) # 80001876 <exit>
  if(which_dev == 2)
    80001e2a:	4789                	li	a5,2
    80001e2c:	f8f910e3          	bne	s2,a5,80001dac <usertrap+0x62>
    yield();
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	7ae080e7          	jalr	1966(ra) # 800015de <yield>
    80001e38:	bf95                	j	80001dac <usertrap+0x62>
  int which_dev = 0;
    80001e3a:	4901                	li	s2,0
    80001e3c:	b7d5                	j	80001e20 <usertrap+0xd6>

0000000080001e3e <kerneltrap>:
{
    80001e3e:	7179                	addi	sp,sp,-48
    80001e40:	f406                	sd	ra,40(sp)
    80001e42:	f022                	sd	s0,32(sp)
    80001e44:	ec26                	sd	s1,24(sp)
    80001e46:	e84a                	sd	s2,16(sp)
    80001e48:	e44e                	sd	s3,8(sp)
    80001e4a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e50:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e54:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e58:	1004f793          	andi	a5,s1,256
    80001e5c:	cb85                	beqz	a5,80001e8c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e62:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e64:	ef85                	bnez	a5,80001e9c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	e42080e7          	jalr	-446(ra) # 80001ca8 <devintr>
    80001e6e:	cd1d                	beqz	a0,80001eac <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e70:	4789                	li	a5,2
    80001e72:	06f50a63          	beq	a0,a5,80001ee6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e76:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e7a:	10049073          	csrw	sstatus,s1
}
    80001e7e:	70a2                	ld	ra,40(sp)
    80001e80:	7402                	ld	s0,32(sp)
    80001e82:	64e2                	ld	s1,24(sp)
    80001e84:	6942                	ld	s2,16(sp)
    80001e86:	69a2                	ld	s3,8(sp)
    80001e88:	6145                	addi	sp,sp,48
    80001e8a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	47c50513          	addi	a0,a0,1148 # 80008308 <states.0+0xc8>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	300080e7          	jalr	768(ra) # 80006194 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	49450513          	addi	a0,a0,1172 # 80008330 <states.0+0xf0>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	2f0080e7          	jalr	752(ra) # 80006194 <panic>
    printf("scause %p\n", scause);
    80001eac:	85ce                	mv	a1,s3
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	4a250513          	addi	a0,a0,1186 # 80008350 <states.0+0x110>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	328080e7          	jalr	808(ra) # 800061de <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ebe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	49a50513          	addi	a0,a0,1178 # 80008360 <states.0+0x120>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	310080e7          	jalr	784(ra) # 800061de <printf>
    panic("kerneltrap");
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	4a250513          	addi	a0,a0,1186 # 80008378 <states.0+0x138>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	2b6080e7          	jalr	694(ra) # 80006194 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	070080e7          	jalr	112(ra) # 80000f56 <myproc>
    80001eee:	d541                	beqz	a0,80001e76 <kerneltrap+0x38>
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	066080e7          	jalr	102(ra) # 80000f56 <myproc>
    80001ef8:	5118                	lw	a4,32(a0)
    80001efa:	4791                	li	a5,4
    80001efc:	f6f71de3          	bne	a4,a5,80001e76 <kerneltrap+0x38>
    yield();
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	6de080e7          	jalr	1758(ra) # 800015de <yield>
    80001f08:	b7bd                	j	80001e76 <kerneltrap+0x38>

0000000080001f0a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f0a:	1101                	addi	sp,sp,-32
    80001f0c:	ec06                	sd	ra,24(sp)
    80001f0e:	e822                	sd	s0,16(sp)
    80001f10:	e426                	sd	s1,8(sp)
    80001f12:	1000                	addi	s0,sp,32
    80001f14:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	040080e7          	jalr	64(ra) # 80000f56 <myproc>
  switch (n) {
    80001f1e:	4795                	li	a5,5
    80001f20:	0497e163          	bltu	a5,s1,80001f62 <argraw+0x58>
    80001f24:	048a                	slli	s1,s1,0x2
    80001f26:	00006717          	auipc	a4,0x6
    80001f2a:	48a70713          	addi	a4,a4,1162 # 800083b0 <states.0+0x170>
    80001f2e:	94ba                	add	s1,s1,a4
    80001f30:	409c                	lw	a5,0(s1)
    80001f32:	97ba                	add	a5,a5,a4
    80001f34:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f36:	713c                	ld	a5,96(a0)
    80001f38:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f3a:	60e2                	ld	ra,24(sp)
    80001f3c:	6442                	ld	s0,16(sp)
    80001f3e:	64a2                	ld	s1,8(sp)
    80001f40:	6105                	addi	sp,sp,32
    80001f42:	8082                	ret
    return p->trapframe->a1;
    80001f44:	713c                	ld	a5,96(a0)
    80001f46:	7fa8                	ld	a0,120(a5)
    80001f48:	bfcd                	j	80001f3a <argraw+0x30>
    return p->trapframe->a2;
    80001f4a:	713c                	ld	a5,96(a0)
    80001f4c:	63c8                	ld	a0,128(a5)
    80001f4e:	b7f5                	j	80001f3a <argraw+0x30>
    return p->trapframe->a3;
    80001f50:	713c                	ld	a5,96(a0)
    80001f52:	67c8                	ld	a0,136(a5)
    80001f54:	b7dd                	j	80001f3a <argraw+0x30>
    return p->trapframe->a4;
    80001f56:	713c                	ld	a5,96(a0)
    80001f58:	6bc8                	ld	a0,144(a5)
    80001f5a:	b7c5                	j	80001f3a <argraw+0x30>
    return p->trapframe->a5;
    80001f5c:	713c                	ld	a5,96(a0)
    80001f5e:	6fc8                	ld	a0,152(a5)
    80001f60:	bfe9                	j	80001f3a <argraw+0x30>
  panic("argraw");
    80001f62:	00006517          	auipc	a0,0x6
    80001f66:	42650513          	addi	a0,a0,1062 # 80008388 <states.0+0x148>
    80001f6a:	00004097          	auipc	ra,0x4
    80001f6e:	22a080e7          	jalr	554(ra) # 80006194 <panic>

0000000080001f72 <fetchaddr>:
{
    80001f72:	1101                	addi	sp,sp,-32
    80001f74:	ec06                	sd	ra,24(sp)
    80001f76:	e822                	sd	s0,16(sp)
    80001f78:	e426                	sd	s1,8(sp)
    80001f7a:	e04a                	sd	s2,0(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84aa                	mv	s1,a0
    80001f80:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	fd4080e7          	jalr	-44(ra) # 80000f56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f8a:	693c                	ld	a5,80(a0)
    80001f8c:	02f4f863          	bgeu	s1,a5,80001fbc <fetchaddr+0x4a>
    80001f90:	00848713          	addi	a4,s1,8
    80001f94:	02e7e663          	bltu	a5,a4,80001fc0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f98:	46a1                	li	a3,8
    80001f9a:	8626                	mv	a2,s1
    80001f9c:	85ca                	mv	a1,s2
    80001f9e:	6d28                	ld	a0,88(a0)
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	d06080e7          	jalr	-762(ra) # 80000ca6 <copyin>
    80001fa8:	00a03533          	snez	a0,a0
    80001fac:	40a00533          	neg	a0,a0
}
    80001fb0:	60e2                	ld	ra,24(sp)
    80001fb2:	6442                	ld	s0,16(sp)
    80001fb4:	64a2                	ld	s1,8(sp)
    80001fb6:	6902                	ld	s2,0(sp)
    80001fb8:	6105                	addi	sp,sp,32
    80001fba:	8082                	ret
    return -1;
    80001fbc:	557d                	li	a0,-1
    80001fbe:	bfcd                	j	80001fb0 <fetchaddr+0x3e>
    80001fc0:	557d                	li	a0,-1
    80001fc2:	b7fd                	j	80001fb0 <fetchaddr+0x3e>

0000000080001fc4 <fetchstr>:
{
    80001fc4:	7179                	addi	sp,sp,-48
    80001fc6:	f406                	sd	ra,40(sp)
    80001fc8:	f022                	sd	s0,32(sp)
    80001fca:	ec26                	sd	s1,24(sp)
    80001fcc:	e84a                	sd	s2,16(sp)
    80001fce:	e44e                	sd	s3,8(sp)
    80001fd0:	1800                	addi	s0,sp,48
    80001fd2:	892a                	mv	s2,a0
    80001fd4:	84ae                	mv	s1,a1
    80001fd6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	f7e080e7          	jalr	-130(ra) # 80000f56 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fe0:	86ce                	mv	a3,s3
    80001fe2:	864a                	mv	a2,s2
    80001fe4:	85a6                	mv	a1,s1
    80001fe6:	6d28                	ld	a0,88(a0)
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	d4c080e7          	jalr	-692(ra) # 80000d34 <copyinstr>
  if(err < 0)
    80001ff0:	00054763          	bltz	a0,80001ffe <fetchstr+0x3a>
  return strlen(buf);
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	ffffe097          	auipc	ra,0xffffe
    80001ffa:	402080e7          	jalr	1026(ra) # 800003f8 <strlen>
}
    80001ffe:	70a2                	ld	ra,40(sp)
    80002000:	7402                	ld	s0,32(sp)
    80002002:	64e2                	ld	s1,24(sp)
    80002004:	6942                	ld	s2,16(sp)
    80002006:	69a2                	ld	s3,8(sp)
    80002008:	6145                	addi	sp,sp,48
    8000200a:	8082                	ret

000000008000200c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	ef2080e7          	jalr	-270(ra) # 80001f0a <argraw>
    80002020:	c088                	sw	a0,0(s1)
  return 0;
}
    80002022:	4501                	li	a0,0
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret

000000008000202e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	1000                	addi	s0,sp,32
    80002038:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	ed0080e7          	jalr	-304(ra) # 80001f0a <argraw>
    80002042:	e088                	sd	a0,0(s1)
  return 0;
}
    80002044:	4501                	li	a0,0
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002050:	1101                	addi	sp,sp,-32
    80002052:	ec06                	sd	ra,24(sp)
    80002054:	e822                	sd	s0,16(sp)
    80002056:	e426                	sd	s1,8(sp)
    80002058:	e04a                	sd	s2,0(sp)
    8000205a:	1000                	addi	s0,sp,32
    8000205c:	84ae                	mv	s1,a1
    8000205e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002060:	00000097          	auipc	ra,0x0
    80002064:	eaa080e7          	jalr	-342(ra) # 80001f0a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002068:	864a                	mv	a2,s2
    8000206a:	85a6                	mv	a1,s1
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	f58080e7          	jalr	-168(ra) # 80001fc4 <fetchstr>
}
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6902                	ld	s2,0(sp)
    8000207c:	6105                	addi	sp,sp,32
    8000207e:	8082                	ret

0000000080002080 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002080:	1101                	addi	sp,sp,-32
    80002082:	ec06                	sd	ra,24(sp)
    80002084:	e822                	sd	s0,16(sp)
    80002086:	e426                	sd	s1,8(sp)
    80002088:	e04a                	sd	s2,0(sp)
    8000208a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	eca080e7          	jalr	-310(ra) # 80000f56 <myproc>
    80002094:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002096:	06053903          	ld	s2,96(a0)
    8000209a:	0a893783          	ld	a5,168(s2)
    8000209e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020a2:	37fd                	addiw	a5,a5,-1
    800020a4:	4751                	li	a4,20
    800020a6:	00f76f63          	bltu	a4,a5,800020c4 <syscall+0x44>
    800020aa:	00369713          	slli	a4,a3,0x3
    800020ae:	00006797          	auipc	a5,0x6
    800020b2:	31a78793          	addi	a5,a5,794 # 800083c8 <syscalls>
    800020b6:	97ba                	add	a5,a5,a4
    800020b8:	639c                	ld	a5,0(a5)
    800020ba:	c789                	beqz	a5,800020c4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020bc:	9782                	jalr	a5
    800020be:	06a93823          	sd	a0,112(s2)
    800020c2:	a839                	j	800020e0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020c4:	16048613          	addi	a2,s1,352
    800020c8:	5c8c                	lw	a1,56(s1)
    800020ca:	00006517          	auipc	a0,0x6
    800020ce:	2c650513          	addi	a0,a0,710 # 80008390 <states.0+0x150>
    800020d2:	00004097          	auipc	ra,0x4
    800020d6:	10c080e7          	jalr	268(ra) # 800061de <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020da:	70bc                	ld	a5,96(s1)
    800020dc:	577d                	li	a4,-1
    800020de:	fbb8                	sd	a4,112(a5)
  }
}
    800020e0:	60e2                	ld	ra,24(sp)
    800020e2:	6442                	ld	s0,16(sp)
    800020e4:	64a2                	ld	s1,8(sp)
    800020e6:	6902                	ld	s2,0(sp)
    800020e8:	6105                	addi	sp,sp,32
    800020ea:	8082                	ret

00000000800020ec <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020f4:	fec40593          	addi	a1,s0,-20
    800020f8:	4501                	li	a0,0
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	f12080e7          	jalr	-238(ra) # 8000200c <argint>
    return -1;
    80002102:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002104:	00054963          	bltz	a0,80002116 <sys_exit+0x2a>
  exit(n);
    80002108:	fec42503          	lw	a0,-20(s0)
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	76a080e7          	jalr	1898(ra) # 80001876 <exit>
  return 0;  // not reached
    80002114:	4781                	li	a5,0
}
    80002116:	853e                	mv	a0,a5
    80002118:	60e2                	ld	ra,24(sp)
    8000211a:	6442                	ld	s0,16(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret

0000000080002120 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002120:	1141                	addi	sp,sp,-16
    80002122:	e406                	sd	ra,8(sp)
    80002124:	e022                	sd	s0,0(sp)
    80002126:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	e2e080e7          	jalr	-466(ra) # 80000f56 <myproc>
}
    80002130:	5d08                	lw	a0,56(a0)
    80002132:	60a2                	ld	ra,8(sp)
    80002134:	6402                	ld	s0,0(sp)
    80002136:	0141                	addi	sp,sp,16
    80002138:	8082                	ret

000000008000213a <sys_fork>:

uint64
sys_fork(void)
{
    8000213a:	1141                	addi	sp,sp,-16
    8000213c:	e406                	sd	ra,8(sp)
    8000213e:	e022                	sd	s0,0(sp)
    80002140:	0800                	addi	s0,sp,16
  return fork();
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	1e6080e7          	jalr	486(ra) # 80001328 <fork>
}
    8000214a:	60a2                	ld	ra,8(sp)
    8000214c:	6402                	ld	s0,0(sp)
    8000214e:	0141                	addi	sp,sp,16
    80002150:	8082                	ret

0000000080002152 <sys_wait>:

uint64
sys_wait(void)
{
    80002152:	1101                	addi	sp,sp,-32
    80002154:	ec06                	sd	ra,24(sp)
    80002156:	e822                	sd	s0,16(sp)
    80002158:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000215a:	fe840593          	addi	a1,s0,-24
    8000215e:	4501                	li	a0,0
    80002160:	00000097          	auipc	ra,0x0
    80002164:	ece080e7          	jalr	-306(ra) # 8000202e <argaddr>
    80002168:	87aa                	mv	a5,a0
    return -1;
    8000216a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000216c:	0007c863          	bltz	a5,8000217c <sys_wait+0x2a>
  return wait(p);
    80002170:	fe843503          	ld	a0,-24(s0)
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	50a080e7          	jalr	1290(ra) # 8000167e <wait>
}
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002184:	7179                	addi	sp,sp,-48
    80002186:	f406                	sd	ra,40(sp)
    80002188:	f022                	sd	s0,32(sp)
    8000218a:	ec26                	sd	s1,24(sp)
    8000218c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000218e:	fdc40593          	addi	a1,s0,-36
    80002192:	4501                	li	a0,0
    80002194:	00000097          	auipc	ra,0x0
    80002198:	e78080e7          	jalr	-392(ra) # 8000200c <argint>
    8000219c:	87aa                	mv	a5,a0
    return -1;
    8000219e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021a0:	0207c063          	bltz	a5,800021c0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	db2080e7          	jalr	-590(ra) # 80000f56 <myproc>
    800021ac:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021ae:	fdc42503          	lw	a0,-36(s0)
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	0fe080e7          	jalr	254(ra) # 800012b0 <growproc>
    800021ba:	00054863          	bltz	a0,800021ca <sys_sbrk+0x46>
    return -1;
  return addr;
    800021be:	8526                	mv	a0,s1
}
    800021c0:	70a2                	ld	ra,40(sp)
    800021c2:	7402                	ld	s0,32(sp)
    800021c4:	64e2                	ld	s1,24(sp)
    800021c6:	6145                	addi	sp,sp,48
    800021c8:	8082                	ret
    return -1;
    800021ca:	557d                	li	a0,-1
    800021cc:	bfd5                	j	800021c0 <sys_sbrk+0x3c>

00000000800021ce <sys_sleep>:

uint64
sys_sleep(void)
{
    800021ce:	7139                	addi	sp,sp,-64
    800021d0:	fc06                	sd	ra,56(sp)
    800021d2:	f822                	sd	s0,48(sp)
    800021d4:	f426                	sd	s1,40(sp)
    800021d6:	f04a                	sd	s2,32(sp)
    800021d8:	ec4e                	sd	s3,24(sp)
    800021da:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021dc:	fcc40593          	addi	a1,s0,-52
    800021e0:	4501                	li	a0,0
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	e2a080e7          	jalr	-470(ra) # 8000200c <argint>
    return -1;
    800021ea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ec:	06054563          	bltz	a0,80002256 <sys_sleep+0x88>
  acquire(&tickslock);
    800021f0:	0000d517          	auipc	a0,0xd
    800021f4:	fc050513          	addi	a0,a0,-64 # 8000f1b0 <tickslock>
    800021f8:	00004097          	auipc	ra,0x4
    800021fc:	4be080e7          	jalr	1214(ra) # 800066b6 <acquire>
  ticks0 = ticks;
    80002200:	00007917          	auipc	s2,0x7
    80002204:	e1892903          	lw	s2,-488(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002208:	fcc42783          	lw	a5,-52(s0)
    8000220c:	cf85                	beqz	a5,80002244 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000220e:	0000d997          	auipc	s3,0xd
    80002212:	fa298993          	addi	s3,s3,-94 # 8000f1b0 <tickslock>
    80002216:	00007497          	auipc	s1,0x7
    8000221a:	e0248493          	addi	s1,s1,-510 # 80009018 <ticks>
    if(myproc()->killed){
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	d38080e7          	jalr	-712(ra) # 80000f56 <myproc>
    80002226:	591c                	lw	a5,48(a0)
    80002228:	ef9d                	bnez	a5,80002266 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000222a:	85ce                	mv	a1,s3
    8000222c:	8526                	mv	a0,s1
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	3ec080e7          	jalr	1004(ra) # 8000161a <sleep>
  while(ticks - ticks0 < n){
    80002236:	409c                	lw	a5,0(s1)
    80002238:	412787bb          	subw	a5,a5,s2
    8000223c:	fcc42703          	lw	a4,-52(s0)
    80002240:	fce7efe3          	bltu	a5,a4,8000221e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002244:	0000d517          	auipc	a0,0xd
    80002248:	f6c50513          	addi	a0,a0,-148 # 8000f1b0 <tickslock>
    8000224c:	00004097          	auipc	ra,0x4
    80002250:	53a080e7          	jalr	1338(ra) # 80006786 <release>
  return 0;
    80002254:	4781                	li	a5,0
}
    80002256:	853e                	mv	a0,a5
    80002258:	70e2                	ld	ra,56(sp)
    8000225a:	7442                	ld	s0,48(sp)
    8000225c:	74a2                	ld	s1,40(sp)
    8000225e:	7902                	ld	s2,32(sp)
    80002260:	69e2                	ld	s3,24(sp)
    80002262:	6121                	addi	sp,sp,64
    80002264:	8082                	ret
      release(&tickslock);
    80002266:	0000d517          	auipc	a0,0xd
    8000226a:	f4a50513          	addi	a0,a0,-182 # 8000f1b0 <tickslock>
    8000226e:	00004097          	auipc	ra,0x4
    80002272:	518080e7          	jalr	1304(ra) # 80006786 <release>
      return -1;
    80002276:	57fd                	li	a5,-1
    80002278:	bff9                	j	80002256 <sys_sleep+0x88>

000000008000227a <sys_kill>:

uint64
sys_kill(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002282:	fec40593          	addi	a1,s0,-20
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	d84080e7          	jalr	-636(ra) # 8000200c <argint>
    80002290:	87aa                	mv	a5,a0
    return -1;
    80002292:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002294:	0007c863          	bltz	a5,800022a4 <sys_kill+0x2a>
  return kill(pid);
    80002298:	fec42503          	lw	a0,-20(s0)
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	6b0080e7          	jalr	1712(ra) # 8000194c <kill>
}
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	6105                	addi	sp,sp,32
    800022aa:	8082                	ret

00000000800022ac <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ac:	1101                	addi	sp,sp,-32
    800022ae:	ec06                	sd	ra,24(sp)
    800022b0:	e822                	sd	s0,16(sp)
    800022b2:	e426                	sd	s1,8(sp)
    800022b4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022b6:	0000d517          	auipc	a0,0xd
    800022ba:	efa50513          	addi	a0,a0,-262 # 8000f1b0 <tickslock>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	3f8080e7          	jalr	1016(ra) # 800066b6 <acquire>
  xticks = ticks;
    800022c6:	00007497          	auipc	s1,0x7
    800022ca:	d524a483          	lw	s1,-686(s1) # 80009018 <ticks>
  release(&tickslock);
    800022ce:	0000d517          	auipc	a0,0xd
    800022d2:	ee250513          	addi	a0,a0,-286 # 8000f1b0 <tickslock>
    800022d6:	00004097          	auipc	ra,0x4
    800022da:	4b0080e7          	jalr	1200(ra) # 80006786 <release>
  return xticks;
}
    800022de:	02049513          	slli	a0,s1,0x20
    800022e2:	9101                	srli	a0,a0,0x20
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	64a2                	ld	s1,8(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <binit>:
  // head.next is most recent, head.prev is least.
  struct buf head[NBUCKET];
} bcache;

void binit(void)
{
    800022ee:	7179                	addi	sp,sp,-48
    800022f0:	f406                	sd	ra,40(sp)
    800022f2:	f022                	sd	s0,32(sp)
    800022f4:	ec26                	sd	s1,24(sp)
    800022f6:	e84a                	sd	s2,16(sp)
    800022f8:	e44e                	sd	s3,8(sp)
    800022fa:	e052                	sd	s4,0(sp)
    800022fc:	1800                	addi	s0,sp,48
  struct buf *b;
  initlock(&bcache.biglock, "bcache_biglock");
    800022fe:	00006597          	auipc	a1,0x6
    80002302:	17a58593          	addi	a1,a1,378 # 80008478 <syscalls+0xb0>
    80002306:	0000d517          	auipc	a0,0xd
    8000230a:	eca50513          	addi	a0,a0,-310 # 8000f1d0 <bcache>
    8000230e:	00004097          	auipc	ra,0x4
    80002312:	524080e7          	jalr	1316(ra) # 80006832 <initlock>
  for (int i = 0; i < NBUCKET; i++)
    80002316:	0000d497          	auipc	s1,0xd
    8000231a:	eda48493          	addi	s1,s1,-294 # 8000f1f0 <bcache+0x20>
    8000231e:	0000d997          	auipc	s3,0xd
    80002322:	07298993          	addi	s3,s3,114 # 8000f390 <bcache+0x1c0>
    initlock(&bcache.lock[i], "bcache");
    80002326:	00006917          	auipc	s2,0x6
    8000232a:	16290913          	addi	s2,s2,354 # 80008488 <syscalls+0xc0>
    8000232e:	85ca                	mv	a1,s2
    80002330:	8526                	mv	a0,s1
    80002332:	00004097          	auipc	ra,0x4
    80002336:	500080e7          	jalr	1280(ra) # 80006832 <initlock>
  for (int i = 0; i < NBUCKET; i++)
    8000233a:	02048493          	addi	s1,s1,32
    8000233e:	ff3498e3          	bne	s1,s3,8000232e <binit+0x40>
    80002342:	00015797          	auipc	a5,0x15
    80002346:	47e78793          	addi	a5,a5,1150 # 800177c0 <bcache+0x85f0>
    8000234a:	0000d717          	auipc	a4,0xd
    8000234e:	e8670713          	addi	a4,a4,-378 # 8000f1d0 <bcache>
    80002352:	66b1                	lui	a3,0xc
    80002354:	f3868693          	addi	a3,a3,-200 # bf38 <_entry-0x7fff40c8>
    80002358:	9736                	add	a4,a4,a3
  // Create linked list of buffers
  // bcache.head.prev = &bcache.head;
  // bcache.head.next = &bcache.head;
  for (int i = 0; i < NBUCKET; i++)
  {
    bcache.head[i].next = &bcache.head[i];
    8000235a:	efbc                	sd	a5,88(a5)
    bcache.head[i].prev = &bcache.head[i];
    8000235c:	ebbc                	sd	a5,80(a5)
  for (int i = 0; i < NBUCKET; i++)
    8000235e:	46878793          	addi	a5,a5,1128
    80002362:	fee79ce3          	bne	a5,a4,8000235a <binit+0x6c>
  }
  for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    80002366:	0000d497          	auipc	s1,0xd
    8000236a:	02a48493          	addi	s1,s1,42 # 8000f390 <bcache+0x1c0>
  {
    b->next = bcache.head[0].next;
    8000236e:	00015917          	auipc	s2,0x15
    80002372:	e6290913          	addi	s2,s2,-414 # 800171d0 <bcache+0x8000>
    b->prev = &bcache.head[0];
    80002376:	00015997          	auipc	s3,0x15
    8000237a:	44a98993          	addi	s3,s3,1098 # 800177c0 <bcache+0x85f0>
    initsleeplock(&b->lock, "buffer");
    8000237e:	00006a17          	auipc	s4,0x6
    80002382:	112a0a13          	addi	s4,s4,274 # 80008490 <syscalls+0xc8>
    b->next = bcache.head[0].next;
    80002386:	64893783          	ld	a5,1608(s2)
    8000238a:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head[0];
    8000238c:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002390:	85d2                	mv	a1,s4
    80002392:	01048513          	addi	a0,s1,16
    80002396:	00001097          	auipc	ra,0x1
    8000239a:	6de080e7          	jalr	1758(ra) # 80003a74 <initsleeplock>
    bcache.head[0].next->prev = b;
    8000239e:	64893783          	ld	a5,1608(s2)
    800023a2:	eba4                	sd	s1,80(a5)
    bcache.head[0].next = b;
    800023a4:	64993423          	sd	s1,1608(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++)
    800023a8:	46848493          	addi	s1,s1,1128
    800023ac:	fd349de3          	bne	s1,s3,80002386 <binit+0x98>
  }
}
    800023b0:	70a2                	ld	ra,40(sp)
    800023b2:	7402                	ld	s0,32(sp)
    800023b4:	64e2                	ld	s1,24(sp)
    800023b6:	6942                	ld	s2,16(sp)
    800023b8:	69a2                	ld	s3,8(sp)
    800023ba:	6a02                	ld	s4,0(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret

00000000800023c0 <hash>:

int hash(int blockno)
{
    800023c0:	1141                	addi	sp,sp,-16
    800023c2:	e422                	sd	s0,8(sp)
    800023c4:	0800                	addi	s0,sp,16
  return blockno % NBUCKET;
}
    800023c6:	47b5                	li	a5,13
    800023c8:	02f5653b          	remw	a0,a0,a5
    800023cc:	6422                	ld	s0,8(sp)
    800023ce:	0141                	addi	sp,sp,16
    800023d0:	8082                	ret

00000000800023d2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    800023d2:	7119                	addi	sp,sp,-128
    800023d4:	fc86                	sd	ra,120(sp)
    800023d6:	f8a2                	sd	s0,112(sp)
    800023d8:	f4a6                	sd	s1,104(sp)
    800023da:	f0ca                	sd	s2,96(sp)
    800023dc:	ecce                	sd	s3,88(sp)
    800023de:	e8d2                	sd	s4,80(sp)
    800023e0:	e4d6                	sd	s5,72(sp)
    800023e2:	e0da                	sd	s6,64(sp)
    800023e4:	fc5e                	sd	s7,56(sp)
    800023e6:	f862                	sd	s8,48(sp)
    800023e8:	f466                	sd	s9,40(sp)
    800023ea:	f06a                	sd	s10,32(sp)
    800023ec:	ec6e                	sd	s11,24(sp)
    800023ee:	0100                	addi	s0,sp,128
    800023f0:	8b2a                	mv	s6,a0
    800023f2:	8c2e                	mv	s8,a1
  return blockno % NBUCKET;
    800023f4:	4935                	li	s2,13
    800023f6:	0325e93b          	remw	s2,a1,s2
    800023fa:	00090c9b          	sext.w	s9,s2
  acquire(&bcache.lock[i]);
    800023fe:	001c8793          	addi	a5,s9,1
    80002402:	0796                	slli	a5,a5,0x5
    80002404:	0000d997          	auipc	s3,0xd
    80002408:	dcc98993          	addi	s3,s3,-564 # 8000f1d0 <bcache>
    8000240c:	97ce                	add	a5,a5,s3
    8000240e:	f8f43423          	sd	a5,-120(s0)
    80002412:	853e                	mv	a0,a5
    80002414:	00004097          	auipc	ra,0x4
    80002418:	2a2080e7          	jalr	674(ra) # 800066b6 <acquire>
  for (b = bcache.head[i].next; b != &bcache.head[i]; b = b->next)
    8000241c:	46800a93          	li	s5,1128
    80002420:	035c8ab3          	mul	s5,s9,s5
    80002424:	01598733          	add	a4,s3,s5
    80002428:	67a1                	lui	a5,0x8
    8000242a:	973e                	add	a4,a4,a5
    8000242c:	64873483          	ld	s1,1608(a4)
    80002430:	5f078793          	addi	a5,a5,1520 # 85f0 <_entry-0x7fff7a10>
    80002434:	9abe                	add	s5,s5,a5
    80002436:	9ace                	add	s5,s5,s3
    80002438:	05549a63          	bne	s1,s5,8000248c <bread+0xba>
  release(&bcache.lock[i]);
    8000243c:	f8843483          	ld	s1,-120(s0)
    80002440:	8526                	mv	a0,s1
    80002442:	00004097          	auipc	ra,0x4
    80002446:	344080e7          	jalr	836(ra) # 80006786 <release>
  acquire(&bcache.biglock);
    8000244a:	0000d517          	auipc	a0,0xd
    8000244e:	d8650513          	addi	a0,a0,-634 # 8000f1d0 <bcache>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	264080e7          	jalr	612(ra) # 800066b6 <acquire>
  acquire(&bcache.lock[i]);
    8000245a:	8526                	mv	a0,s1
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	25a080e7          	jalr	602(ra) # 800066b6 <acquire>
  for (b = bcache.head[i].next; b != &bcache.head[i]; b = b->next)
    80002464:	46800793          	li	a5,1128
    80002468:	02fc87b3          	mul	a5,s9,a5
    8000246c:	0000d717          	auipc	a4,0xd
    80002470:	d6470713          	addi	a4,a4,-668 # 8000f1d0 <bcache>
    80002474:	973e                	add	a4,a4,a5
    80002476:	67a1                	lui	a5,0x8
    80002478:	97ba                	add	a5,a5,a4
    8000247a:	6487b783          	ld	a5,1608(a5) # 8648 <_entry-0x7fff79b8>
    8000247e:	0f578c63          	beq	a5,s5,80002576 <bread+0x1a4>
    80002482:	84be                	mv	s1,a5
    80002484:	a82d                	j	800024be <bread+0xec>
  for (b = bcache.head[i].next; b != &bcache.head[i]; b = b->next)
    80002486:	6ca4                	ld	s1,88(s1)
    80002488:	fb548ae3          	beq	s1,s5,8000243c <bread+0x6a>
    if (b->dev == dev && b->blockno == blockno)
    8000248c:	449c                	lw	a5,8(s1)
    8000248e:	ff679ce3          	bne	a5,s6,80002486 <bread+0xb4>
    80002492:	44dc                	lw	a5,12(s1)
    80002494:	ff8799e3          	bne	a5,s8,80002486 <bread+0xb4>
      b->refcnt++;
    80002498:	44bc                	lw	a5,72(s1)
    8000249a:	2785                	addiw	a5,a5,1
    8000249c:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock[i]);
    8000249e:	f8843503          	ld	a0,-120(s0)
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	2e4080e7          	jalr	740(ra) # 80006786 <release>
      acquiresleep(&b->lock);
    800024aa:	01048513          	addi	a0,s1,16
    800024ae:	00001097          	auipc	ra,0x1
    800024b2:	600080e7          	jalr	1536(ra) # 80003aae <acquiresleep>
      return b;
    800024b6:	a255                	j	8000265a <bread+0x288>
  for (b = bcache.head[i].next; b != &bcache.head[i]; b = b->next)
    800024b8:	6ca4                	ld	s1,88(s1)
    800024ba:	05548063          	beq	s1,s5,800024fa <bread+0x128>
    if (b->dev == dev && b->blockno == blockno)
    800024be:	4498                	lw	a4,8(s1)
    800024c0:	ff671ce3          	bne	a4,s6,800024b8 <bread+0xe6>
    800024c4:	44d8                	lw	a4,12(s1)
    800024c6:	ff8719e3          	bne	a4,s8,800024b8 <bread+0xe6>
      b->refcnt++;
    800024ca:	44bc                	lw	a5,72(s1)
    800024cc:	2785                	addiw	a5,a5,1
    800024ce:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock[i]);
    800024d0:	f8843503          	ld	a0,-120(s0)
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	2b2080e7          	jalr	690(ra) # 80006786 <release>
      release(&bcache.biglock);
    800024dc:	0000d517          	auipc	a0,0xd
    800024e0:	cf450513          	addi	a0,a0,-780 # 8000f1d0 <bcache>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	2a2080e7          	jalr	674(ra) # 80006786 <release>
      acquiresleep(&b->lock);
    800024ec:	01048513          	addi	a0,s1,16
    800024f0:	00001097          	auipc	ra,0x1
    800024f4:	5be080e7          	jalr	1470(ra) # 80003aae <acquiresleep>
      return b;
    800024f8:	a28d                	j	8000265a <bread+0x288>
    800024fa:	4a01                	li	s4,0
    800024fc:	4481                	li	s1,0
    800024fe:	a039                	j	8000250c <bread+0x13a>
      min_ticks = b->lastuse;
    80002500:	4607aa03          	lw	s4,1120(a5)
    80002504:	84be                	mv	s1,a5
  for (b = bcache.head[i].next; b != &bcache.head[i]; b = b->next)
    80002506:	6fbc                	ld	a5,88(a5)
    80002508:	01578a63          	beq	a5,s5,8000251c <bread+0x14a>
    if (b->refcnt == 0 && (b2 == 0 || b->lastuse < min_ticks))
    8000250c:	47b8                	lw	a4,72(a5)
    8000250e:	ff65                	bnez	a4,80002506 <bread+0x134>
    80002510:	d8e5                	beqz	s1,80002500 <bread+0x12e>
    80002512:	4607a703          	lw	a4,1120(a5)
    80002516:	ff4778e3          	bgeu	a4,s4,80002506 <bread+0x134>
    8000251a:	b7dd                	j	80002500 <bread+0x12e>
  if (b2)
    8000251c:	ec99                	bnez	s1,8000253a <bread+0x168>
  for (int j = hash(i + 1); j != i; j = hash(j + 1))
    8000251e:	2905                	addiw	s2,s2,1
  return blockno % NBUCKET;
    80002520:	47b5                	li	a5,13
    80002522:	02f9693b          	remw	s2,s2,a5
  for (int j = hash(i + 1); j != i; j = hash(j + 1))
    80002526:	152c8c63          	beq	s9,s2,8000267e <bread+0x2ac>
    acquire(&bcache.lock[j]);
    8000252a:	0000db97          	auipc	s7,0xd
    8000252e:	ca6b8b93          	addi	s7,s7,-858 # 8000f1d0 <bcache>
    for (b = bcache.head[j].next; b != &bcache.head[j]; b = b->next)
    80002532:	46800d93          	li	s11,1128
    80002536:	6d21                	lui	s10,0x8
    80002538:	a8b5                	j	800025b4 <bread+0x1e2>
    b2->dev = dev;
    8000253a:	0164a423          	sw	s6,8(s1)
    b2->blockno = blockno;
    8000253e:	0184a623          	sw	s8,12(s1)
    b2->refcnt++;
    80002542:	44bc                	lw	a5,72(s1)
    80002544:	2785                	addiw	a5,a5,1
    80002546:	c4bc                	sw	a5,72(s1)
    b2->valid = 0;
    80002548:	0004a023          	sw	zero,0(s1)
    release(&bcache.lock[i]);
    8000254c:	f8843503          	ld	a0,-120(s0)
    80002550:	00004097          	auipc	ra,0x4
    80002554:	236080e7          	jalr	566(ra) # 80006786 <release>
    release(&bcache.biglock);
    80002558:	0000d517          	auipc	a0,0xd
    8000255c:	c7850513          	addi	a0,a0,-904 # 8000f1d0 <bcache>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	226080e7          	jalr	550(ra) # 80006786 <release>
    acquiresleep(&b2->lock);
    80002568:	01048513          	addi	a0,s1,16
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	542080e7          	jalr	1346(ra) # 80003aae <acquiresleep>
    return b2;
    80002574:	a0dd                	j	8000265a <bread+0x288>
  int i = hash(blockno), min_ticks = 0;
    80002576:	4a01                	li	s4,0
    80002578:	b75d                	j	8000251e <bread+0x14c>
        min_ticks = b->lastuse;
    8000257a:	4607aa03          	lw	s4,1120(a5)
    8000257e:	84be                	mv	s1,a5
    for (b = bcache.head[j].next; b != &bcache.head[j]; b = b->next)
    80002580:	6fbc                	ld	a5,88(a5)
    80002582:	06f68263          	beq	a3,a5,800025e6 <bread+0x214>
      if (b->refcnt == 0 && (b2 == 0 || b->lastuse < min_ticks))
    80002586:	47b8                	lw	a4,72(a5)
    80002588:	e719                	bnez	a4,80002596 <bread+0x1c4>
    8000258a:	d8e5                	beqz	s1,8000257a <bread+0x1a8>
    8000258c:	4607a703          	lw	a4,1120(a5)
    80002590:	ff4778e3          	bgeu	a4,s4,80002580 <bread+0x1ae>
    80002594:	b7dd                	j	8000257a <bread+0x1a8>
    for (b = bcache.head[j].next; b != &bcache.head[j]; b = b->next)
    80002596:	6fbc                	ld	a5,88(a5)
    80002598:	fef697e3          	bne	a3,a5,80002586 <bread+0x1b4>
    if (b2)
    8000259c:	e4a9                	bnez	s1,800025e6 <bread+0x214>
    release(&bcache.lock[j]);
    8000259e:	854e                	mv	a0,s3
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	1e6080e7          	jalr	486(ra) # 80006786 <release>
  for (int j = hash(i + 1); j != i; j = hash(j + 1))
    800025a8:	2905                	addiw	s2,s2,1
  return blockno % NBUCKET;
    800025aa:	47b5                	li	a5,13
    800025ac:	02f9693b          	remw	s2,s2,a5
  for (int j = hash(i + 1); j != i; j = hash(j + 1))
    800025b0:	0d2c8763          	beq	s9,s2,8000267e <bread+0x2ac>
    acquire(&bcache.lock[j]);
    800025b4:	00190993          	addi	s3,s2,1
    800025b8:	0996                	slli	s3,s3,0x5
    800025ba:	99de                	add	s3,s3,s7
    800025bc:	854e                	mv	a0,s3
    800025be:	00004097          	auipc	ra,0x4
    800025c2:	0f8080e7          	jalr	248(ra) # 800066b6 <acquire>
    for (b = bcache.head[j].next; b != &bcache.head[j]; b = b->next)
    800025c6:	03b906b3          	mul	a3,s2,s11
    800025ca:	00db87b3          	add	a5,s7,a3
    800025ce:	97ea                	add	a5,a5,s10
    800025d0:	6487b783          	ld	a5,1608(a5)
    800025d4:	6721                	lui	a4,0x8
    800025d6:	5f070713          	addi	a4,a4,1520 # 85f0 <_entry-0x7fff7a10>
    800025da:	96ba                	add	a3,a3,a4
    800025dc:	96de                	add	a3,a3,s7
    800025de:	fcf680e3          	beq	a3,a5,8000259e <bread+0x1cc>
    800025e2:	4481                	li	s1,0
    800025e4:	b74d                	j	80002586 <bread+0x1b4>
      b2->dev = dev;
    800025e6:	0164a423          	sw	s6,8(s1)
      b2->refcnt++;
    800025ea:	44bc                	lw	a5,72(s1)
    800025ec:	2785                	addiw	a5,a5,1
    800025ee:	c4bc                	sw	a5,72(s1)
      b2->valid = 0;
    800025f0:	0004a023          	sw	zero,0(s1)
      b2->blockno = blockno;
    800025f4:	0184a623          	sw	s8,12(s1)
      b2->next->prev = b2->prev;
    800025f8:	6cbc                	ld	a5,88(s1)
    800025fa:	68b8                	ld	a4,80(s1)
    800025fc:	ebb8                	sd	a4,80(a5)
      b2->prev->next = b2->next;
    800025fe:	68bc                	ld	a5,80(s1)
    80002600:	6cb8                	ld	a4,88(s1)
    80002602:	efb8                	sd	a4,88(a5)
      release(&bcache.lock[j]);
    80002604:	854e                	mv	a0,s3
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	180080e7          	jalr	384(ra) # 80006786 <release>
      b2->next = bcache.head[i].next;
    8000260e:	0000d917          	auipc	s2,0xd
    80002612:	bc290913          	addi	s2,s2,-1086 # 8000f1d0 <bcache>
    80002616:	46800713          	li	a4,1128
    8000261a:	02ec8733          	mul	a4,s9,a4
    8000261e:	974a                	add	a4,a4,s2
    80002620:	67a1                	lui	a5,0x8
    80002622:	97ba                	add	a5,a5,a4
    80002624:	6487b703          	ld	a4,1608(a5) # 8648 <_entry-0x7fff79b8>
    80002628:	ecb8                	sd	a4,88(s1)
      b2->prev = &bcache.head[i];
    8000262a:	0554b823          	sd	s5,80(s1)
      bcache.head[i].next->prev = b2;
    8000262e:	6487b703          	ld	a4,1608(a5)
    80002632:	eb24                	sd	s1,80(a4)
      bcache.head[i].next = b2;
    80002634:	6497b423          	sd	s1,1608(a5)
      release(&bcache.lock[i]);
    80002638:	f8843503          	ld	a0,-120(s0)
    8000263c:	00004097          	auipc	ra,0x4
    80002640:	14a080e7          	jalr	330(ra) # 80006786 <release>
      release(&bcache.biglock);
    80002644:	854a                	mv	a0,s2
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	140080e7          	jalr	320(ra) # 80006786 <release>
      acquiresleep(&b2->lock);
    8000264e:	01048513          	addi	a0,s1,16
    80002652:	00001097          	auipc	ra,0x1
    80002656:	45c080e7          	jalr	1116(ra) # 80003aae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid)
    8000265a:	409c                	lw	a5,0(s1)
    8000265c:	c7b9                	beqz	a5,800026aa <bread+0x2d8>
  {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000265e:	8526                	mv	a0,s1
    80002660:	70e6                	ld	ra,120(sp)
    80002662:	7446                	ld	s0,112(sp)
    80002664:	74a6                	ld	s1,104(sp)
    80002666:	7906                	ld	s2,96(sp)
    80002668:	69e6                	ld	s3,88(sp)
    8000266a:	6a46                	ld	s4,80(sp)
    8000266c:	6aa6                	ld	s5,72(sp)
    8000266e:	6b06                	ld	s6,64(sp)
    80002670:	7be2                	ld	s7,56(sp)
    80002672:	7c42                	ld	s8,48(sp)
    80002674:	7ca2                	ld	s9,40(sp)
    80002676:	7d02                	ld	s10,32(sp)
    80002678:	6de2                	ld	s11,24(sp)
    8000267a:	6109                	addi	sp,sp,128
    8000267c:	8082                	ret
  release(&bcache.lock[i]);
    8000267e:	f8843503          	ld	a0,-120(s0)
    80002682:	00004097          	auipc	ra,0x4
    80002686:	104080e7          	jalr	260(ra) # 80006786 <release>
  release(&bcache.biglock);
    8000268a:	0000d517          	auipc	a0,0xd
    8000268e:	b4650513          	addi	a0,a0,-1210 # 8000f1d0 <bcache>
    80002692:	00004097          	auipc	ra,0x4
    80002696:	0f4080e7          	jalr	244(ra) # 80006786 <release>
  panic("bget: no buffers");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	dfe50513          	addi	a0,a0,-514 # 80008498 <syscalls+0xd0>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	af2080e7          	jalr	-1294(ra) # 80006194 <panic>
    virtio_disk_rw(b, 0);
    800026aa:	4581                	li	a1,0
    800026ac:	8526                	mv	a0,s1
    800026ae:	00003097          	auipc	ra,0x3
    800026b2:	f44080e7          	jalr	-188(ra) # 800055f2 <virtio_disk_rw>
    b->valid = 1;
    800026b6:	4785                	li	a5,1
    800026b8:	c09c                	sw	a5,0(s1)
  return b;
    800026ba:	b755                	j	8000265e <bread+0x28c>

00000000800026bc <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b)
{
    800026bc:	1101                	addi	sp,sp,-32
    800026be:	ec06                	sd	ra,24(sp)
    800026c0:	e822                	sd	s0,16(sp)
    800026c2:	e426                	sd	s1,8(sp)
    800026c4:	1000                	addi	s0,sp,32
    800026c6:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    800026c8:	0541                	addi	a0,a0,16
    800026ca:	00001097          	auipc	ra,0x1
    800026ce:	47e080e7          	jalr	1150(ra) # 80003b48 <holdingsleep>
    800026d2:	cd01                	beqz	a0,800026ea <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026d4:	4585                	li	a1,1
    800026d6:	8526                	mv	a0,s1
    800026d8:	00003097          	auipc	ra,0x3
    800026dc:	f1a080e7          	jalr	-230(ra) # 800055f2 <virtio_disk_rw>
}
    800026e0:	60e2                	ld	ra,24(sp)
    800026e2:	6442                	ld	s0,16(sp)
    800026e4:	64a2                	ld	s1,8(sp)
    800026e6:	6105                	addi	sp,sp,32
    800026e8:	8082                	ret
    panic("bwrite");
    800026ea:	00006517          	auipc	a0,0x6
    800026ee:	dc650513          	addi	a0,a0,-570 # 800084b0 <syscalls+0xe8>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	aa2080e7          	jalr	-1374(ra) # 80006194 <panic>

00000000800026fa <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    800026fa:	1101                	addi	sp,sp,-32
    800026fc:	ec06                	sd	ra,24(sp)
    800026fe:	e822                	sd	s0,16(sp)
    80002700:	e426                	sd	s1,8(sp)
    80002702:	e04a                	sd	s2,0(sp)
    80002704:	1000                	addi	s0,sp,32
    80002706:	892a                	mv	s2,a0
  if (!holdingsleep(&b->lock))
    80002708:	01050493          	addi	s1,a0,16
    8000270c:	8526                	mv	a0,s1
    8000270e:	00001097          	auipc	ra,0x1
    80002712:	43a080e7          	jalr	1082(ra) # 80003b48 <holdingsleep>
    80002716:	c125                	beqz	a0,80002776 <brelse+0x7c>
    panic("brelse");
  releasesleep(&b->lock);
    80002718:	8526                	mv	a0,s1
    8000271a:	00001097          	auipc	ra,0x1
    8000271e:	3ea080e7          	jalr	1002(ra) # 80003b04 <releasesleep>
  return blockno % NBUCKET;
    80002722:	00c92483          	lw	s1,12(s2)
    80002726:	47b5                	li	a5,13
    80002728:	02f4e4bb          	remw	s1,s1,a5
  int i = hash(b->blockno);
  acquire(&bcache.lock[i]);
    8000272c:	2485                	addiw	s1,s1,1
    8000272e:	0496                	slli	s1,s1,0x5
    80002730:	0000d797          	auipc	a5,0xd
    80002734:	aa078793          	addi	a5,a5,-1376 # 8000f1d0 <bcache>
    80002738:	94be                	add	s1,s1,a5
    8000273a:	8526                	mv	a0,s1
    8000273c:	00004097          	auipc	ra,0x4
    80002740:	f7a080e7          	jalr	-134(ra) # 800066b6 <acquire>
  b->refcnt--;
    80002744:	04892783          	lw	a5,72(s2)
    80002748:	37fd                	addiw	a5,a5,-1
    8000274a:	0007871b          	sext.w	a4,a5
    8000274e:	04f92423          	sw	a5,72(s2)
  if (b->refcnt == 0)
    80002752:	e719                	bnez	a4,80002760 <brelse+0x66>
    // b->prev->next = b->next;
    // b->next = bcache.head[i].next;
    // b->prev = &bcache.head[i];
    // bcache.head[i].next->prev = b;
    // bcache.head[i].next = b;
    b->lastuse = ticks;
    80002754:	00007797          	auipc	a5,0x7
    80002758:	8c47a783          	lw	a5,-1852(a5) # 80009018 <ticks>
    8000275c:	46f92023          	sw	a5,1120(s2)
  }
  release(&bcache.lock[i]);
    80002760:	8526                	mv	a0,s1
    80002762:	00004097          	auipc	ra,0x4
    80002766:	024080e7          	jalr	36(ra) # 80006786 <release>
}
    8000276a:	60e2                	ld	ra,24(sp)
    8000276c:	6442                	ld	s0,16(sp)
    8000276e:	64a2                	ld	s1,8(sp)
    80002770:	6902                	ld	s2,0(sp)
    80002772:	6105                	addi	sp,sp,32
    80002774:	8082                	ret
    panic("brelse");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	d4250513          	addi	a0,a0,-702 # 800084b8 <syscalls+0xf0>
    8000277e:	00004097          	auipc	ra,0x4
    80002782:	a16080e7          	jalr	-1514(ra) # 80006194 <panic>

0000000080002786 <bpin>:

void bpin(struct buf *b)
{
    80002786:	1101                	addi	sp,sp,-32
    80002788:	ec06                	sd	ra,24(sp)
    8000278a:	e822                	sd	s0,16(sp)
    8000278c:	e426                	sd	s1,8(sp)
    8000278e:	e04a                	sd	s2,0(sp)
    80002790:	1000                	addi	s0,sp,32
    80002792:	892a                	mv	s2,a0
  return blockno % NBUCKET;
    80002794:	4544                	lw	s1,12(a0)
    80002796:	47b5                	li	a5,13
    80002798:	02f4e4bb          	remw	s1,s1,a5
  int i = hash(b->blockno);
  acquire(&bcache.lock[i]);
    8000279c:	2485                	addiw	s1,s1,1
    8000279e:	0496                	slli	s1,s1,0x5
    800027a0:	0000d797          	auipc	a5,0xd
    800027a4:	a3078793          	addi	a5,a5,-1488 # 8000f1d0 <bcache>
    800027a8:	94be                	add	s1,s1,a5
    800027aa:	8526                	mv	a0,s1
    800027ac:	00004097          	auipc	ra,0x4
    800027b0:	f0a080e7          	jalr	-246(ra) # 800066b6 <acquire>
  b->refcnt++;
    800027b4:	04892783          	lw	a5,72(s2)
    800027b8:	2785                	addiw	a5,a5,1
    800027ba:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[i]);
    800027be:	8526                	mv	a0,s1
    800027c0:	00004097          	auipc	ra,0x4
    800027c4:	fc6080e7          	jalr	-58(ra) # 80006786 <release>
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6902                	ld	s2,0(sp)
    800027d0:	6105                	addi	sp,sp,32
    800027d2:	8082                	ret

00000000800027d4 <bunpin>:
void bunpin(struct buf *b)
{
    800027d4:	1101                	addi	sp,sp,-32
    800027d6:	ec06                	sd	ra,24(sp)
    800027d8:	e822                	sd	s0,16(sp)
    800027da:	e426                	sd	s1,8(sp)
    800027dc:	e04a                	sd	s2,0(sp)
    800027de:	1000                	addi	s0,sp,32
    800027e0:	892a                	mv	s2,a0
  return blockno % NBUCKET;
    800027e2:	4544                	lw	s1,12(a0)
    800027e4:	47b5                	li	a5,13
    800027e6:	02f4e4bb          	remw	s1,s1,a5
  int i = hash(b->blockno);
  acquire(&bcache.lock[i]);
    800027ea:	2485                	addiw	s1,s1,1
    800027ec:	0496                	slli	s1,s1,0x5
    800027ee:	0000d797          	auipc	a5,0xd
    800027f2:	9e278793          	addi	a5,a5,-1566 # 8000f1d0 <bcache>
    800027f6:	94be                	add	s1,s1,a5
    800027f8:	8526                	mv	a0,s1
    800027fa:	00004097          	auipc	ra,0x4
    800027fe:	ebc080e7          	jalr	-324(ra) # 800066b6 <acquire>
  b->refcnt--;
    80002802:	04892783          	lw	a5,72(s2)
    80002806:	37fd                	addiw	a5,a5,-1
    80002808:	04f92423          	sw	a5,72(s2)
  release(&bcache.lock[i]);
    8000280c:	8526                	mv	a0,s1
    8000280e:	00004097          	auipc	ra,0x4
    80002812:	f78080e7          	jalr	-136(ra) # 80006786 <release>
}
    80002816:	60e2                	ld	ra,24(sp)
    80002818:	6442                	ld	s0,16(sp)
    8000281a:	64a2                	ld	s1,8(sp)
    8000281c:	6902                	ld	s2,0(sp)
    8000281e:	6105                	addi	sp,sp,32
    80002820:	8082                	ret

0000000080002822 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002822:	1101                	addi	sp,sp,-32
    80002824:	ec06                	sd	ra,24(sp)
    80002826:	e822                	sd	s0,16(sp)
    80002828:	e426                	sd	s1,8(sp)
    8000282a:	e04a                	sd	s2,0(sp)
    8000282c:	1000                	addi	s0,sp,32
    8000282e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002830:	00d5d59b          	srliw	a1,a1,0xd
    80002834:	00019797          	auipc	a5,0x19
    80002838:	8f07a783          	lw	a5,-1808(a5) # 8001b124 <sb+0x1c>
    8000283c:	9dbd                	addw	a1,a1,a5
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	b94080e7          	jalr	-1132(ra) # 800023d2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002846:	0074f713          	andi	a4,s1,7
    8000284a:	4785                	li	a5,1
    8000284c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002850:	14ce                	slli	s1,s1,0x33
    80002852:	90d9                	srli	s1,s1,0x36
    80002854:	00950733          	add	a4,a0,s1
    80002858:	06074703          	lbu	a4,96(a4)
    8000285c:	00e7f6b3          	and	a3,a5,a4
    80002860:	c69d                	beqz	a3,8000288e <bfree+0x6c>
    80002862:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002864:	94aa                	add	s1,s1,a0
    80002866:	fff7c793          	not	a5,a5
    8000286a:	8f7d                	and	a4,a4,a5
    8000286c:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    80002870:	00001097          	auipc	ra,0x1
    80002874:	120080e7          	jalr	288(ra) # 80003990 <log_write>
  brelse(bp);
    80002878:	854a                	mv	a0,s2
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	e80080e7          	jalr	-384(ra) # 800026fa <brelse>
}
    80002882:	60e2                	ld	ra,24(sp)
    80002884:	6442                	ld	s0,16(sp)
    80002886:	64a2                	ld	s1,8(sp)
    80002888:	6902                	ld	s2,0(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret
    panic("freeing free block");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	c3250513          	addi	a0,a0,-974 # 800084c0 <syscalls+0xf8>
    80002896:	00004097          	auipc	ra,0x4
    8000289a:	8fe080e7          	jalr	-1794(ra) # 80006194 <panic>

000000008000289e <balloc>:
{
    8000289e:	711d                	addi	sp,sp,-96
    800028a0:	ec86                	sd	ra,88(sp)
    800028a2:	e8a2                	sd	s0,80(sp)
    800028a4:	e4a6                	sd	s1,72(sp)
    800028a6:	e0ca                	sd	s2,64(sp)
    800028a8:	fc4e                	sd	s3,56(sp)
    800028aa:	f852                	sd	s4,48(sp)
    800028ac:	f456                	sd	s5,40(sp)
    800028ae:	f05a                	sd	s6,32(sp)
    800028b0:	ec5e                	sd	s7,24(sp)
    800028b2:	e862                	sd	s8,16(sp)
    800028b4:	e466                	sd	s9,8(sp)
    800028b6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028b8:	00019797          	auipc	a5,0x19
    800028bc:	8547a783          	lw	a5,-1964(a5) # 8001b10c <sb+0x4>
    800028c0:	cbc1                	beqz	a5,80002950 <balloc+0xb2>
    800028c2:	8baa                	mv	s7,a0
    800028c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028c6:	00019b17          	auipc	s6,0x19
    800028ca:	842b0b13          	addi	s6,s6,-1982 # 8001b108 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ce:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028d4:	6c89                	lui	s9,0x2
    800028d6:	a831                	j	800028f2 <balloc+0x54>
    brelse(bp);
    800028d8:	854a                	mv	a0,s2
    800028da:	00000097          	auipc	ra,0x0
    800028de:	e20080e7          	jalr	-480(ra) # 800026fa <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028e2:	015c87bb          	addw	a5,s9,s5
    800028e6:	00078a9b          	sext.w	s5,a5
    800028ea:	004b2703          	lw	a4,4(s6)
    800028ee:	06eaf163          	bgeu	s5,a4,80002950 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800028f2:	41fad79b          	sraiw	a5,s5,0x1f
    800028f6:	0137d79b          	srliw	a5,a5,0x13
    800028fa:	015787bb          	addw	a5,a5,s5
    800028fe:	40d7d79b          	sraiw	a5,a5,0xd
    80002902:	01cb2583          	lw	a1,28(s6)
    80002906:	9dbd                	addw	a1,a1,a5
    80002908:	855e                	mv	a0,s7
    8000290a:	00000097          	auipc	ra,0x0
    8000290e:	ac8080e7          	jalr	-1336(ra) # 800023d2 <bread>
    80002912:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002914:	004b2503          	lw	a0,4(s6)
    80002918:	000a849b          	sext.w	s1,s5
    8000291c:	8762                	mv	a4,s8
    8000291e:	faa4fde3          	bgeu	s1,a0,800028d8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002922:	00777693          	andi	a3,a4,7
    80002926:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000292a:	41f7579b          	sraiw	a5,a4,0x1f
    8000292e:	01d7d79b          	srliw	a5,a5,0x1d
    80002932:	9fb9                	addw	a5,a5,a4
    80002934:	4037d79b          	sraiw	a5,a5,0x3
    80002938:	00f90633          	add	a2,s2,a5
    8000293c:	06064603          	lbu	a2,96(a2)
    80002940:	00c6f5b3          	and	a1,a3,a2
    80002944:	cd91                	beqz	a1,80002960 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002946:	2705                	addiw	a4,a4,1
    80002948:	2485                	addiw	s1,s1,1
    8000294a:	fd471ae3          	bne	a4,s4,8000291e <balloc+0x80>
    8000294e:	b769                	j	800028d8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002950:	00006517          	auipc	a0,0x6
    80002954:	b8850513          	addi	a0,a0,-1144 # 800084d8 <syscalls+0x110>
    80002958:	00004097          	auipc	ra,0x4
    8000295c:	83c080e7          	jalr	-1988(ra) # 80006194 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002960:	97ca                	add	a5,a5,s2
    80002962:	8e55                	or	a2,a2,a3
    80002964:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    80002968:	854a                	mv	a0,s2
    8000296a:	00001097          	auipc	ra,0x1
    8000296e:	026080e7          	jalr	38(ra) # 80003990 <log_write>
        brelse(bp);
    80002972:	854a                	mv	a0,s2
    80002974:	00000097          	auipc	ra,0x0
    80002978:	d86080e7          	jalr	-634(ra) # 800026fa <brelse>
  bp = bread(dev, bno);
    8000297c:	85a6                	mv	a1,s1
    8000297e:	855e                	mv	a0,s7
    80002980:	00000097          	auipc	ra,0x0
    80002984:	a52080e7          	jalr	-1454(ra) # 800023d2 <bread>
    80002988:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000298a:	40000613          	li	a2,1024
    8000298e:	4581                	li	a1,0
    80002990:	06050513          	addi	a0,a0,96
    80002994:	ffffe097          	auipc	ra,0xffffe
    80002998:	8e8080e7          	jalr	-1816(ra) # 8000027c <memset>
  log_write(bp);
    8000299c:	854a                	mv	a0,s2
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	ff2080e7          	jalr	-14(ra) # 80003990 <log_write>
  brelse(bp);
    800029a6:	854a                	mv	a0,s2
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	d52080e7          	jalr	-686(ra) # 800026fa <brelse>
}
    800029b0:	8526                	mv	a0,s1
    800029b2:	60e6                	ld	ra,88(sp)
    800029b4:	6446                	ld	s0,80(sp)
    800029b6:	64a6                	ld	s1,72(sp)
    800029b8:	6906                	ld	s2,64(sp)
    800029ba:	79e2                	ld	s3,56(sp)
    800029bc:	7a42                	ld	s4,48(sp)
    800029be:	7aa2                	ld	s5,40(sp)
    800029c0:	7b02                	ld	s6,32(sp)
    800029c2:	6be2                	ld	s7,24(sp)
    800029c4:	6c42                	ld	s8,16(sp)
    800029c6:	6ca2                	ld	s9,8(sp)
    800029c8:	6125                	addi	sp,sp,96
    800029ca:	8082                	ret

00000000800029cc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	e052                	sd	s4,0(sp)
    800029da:	1800                	addi	s0,sp,48
    800029dc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029de:	47ad                	li	a5,11
    800029e0:	04b7fe63          	bgeu	a5,a1,80002a3c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029e4:	ff45849b          	addiw	s1,a1,-12
    800029e8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029ec:	0ff00793          	li	a5,255
    800029f0:	0ae7e463          	bltu	a5,a4,80002a98 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029f4:	08852583          	lw	a1,136(a0)
    800029f8:	c5b5                	beqz	a1,80002a64 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029fa:	00092503          	lw	a0,0(s2)
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	9d4080e7          	jalr	-1580(ra) # 800023d2 <bread>
    80002a06:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a08:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002a0c:	02049713          	slli	a4,s1,0x20
    80002a10:	01e75593          	srli	a1,a4,0x1e
    80002a14:	00b784b3          	add	s1,a5,a1
    80002a18:	0004a983          	lw	s3,0(s1)
    80002a1c:	04098e63          	beqz	s3,80002a78 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a20:	8552                	mv	a0,s4
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	cd8080e7          	jalr	-808(ra) # 800026fa <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a2a:	854e                	mv	a0,s3
    80002a2c:	70a2                	ld	ra,40(sp)
    80002a2e:	7402                	ld	s0,32(sp)
    80002a30:	64e2                	ld	s1,24(sp)
    80002a32:	6942                	ld	s2,16(sp)
    80002a34:	69a2                	ld	s3,8(sp)
    80002a36:	6a02                	ld	s4,0(sp)
    80002a38:	6145                	addi	sp,sp,48
    80002a3a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a3c:	02059793          	slli	a5,a1,0x20
    80002a40:	01e7d593          	srli	a1,a5,0x1e
    80002a44:	00b504b3          	add	s1,a0,a1
    80002a48:	0584a983          	lw	s3,88(s1)
    80002a4c:	fc099fe3          	bnez	s3,80002a2a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a50:	4108                	lw	a0,0(a0)
    80002a52:	00000097          	auipc	ra,0x0
    80002a56:	e4c080e7          	jalr	-436(ra) # 8000289e <balloc>
    80002a5a:	0005099b          	sext.w	s3,a0
    80002a5e:	0534ac23          	sw	s3,88(s1)
    80002a62:	b7e1                	j	80002a2a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a64:	4108                	lw	a0,0(a0)
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	e38080e7          	jalr	-456(ra) # 8000289e <balloc>
    80002a6e:	0005059b          	sext.w	a1,a0
    80002a72:	08b92423          	sw	a1,136(s2)
    80002a76:	b751                	j	800029fa <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a78:	00092503          	lw	a0,0(s2)
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	e22080e7          	jalr	-478(ra) # 8000289e <balloc>
    80002a84:	0005099b          	sext.w	s3,a0
    80002a88:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a8c:	8552                	mv	a0,s4
    80002a8e:	00001097          	auipc	ra,0x1
    80002a92:	f02080e7          	jalr	-254(ra) # 80003990 <log_write>
    80002a96:	b769                	j	80002a20 <bmap+0x54>
  panic("bmap: out of range");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	a5850513          	addi	a0,a0,-1448 # 800084f0 <syscalls+0x128>
    80002aa0:	00003097          	auipc	ra,0x3
    80002aa4:	6f4080e7          	jalr	1780(ra) # 80006194 <panic>

0000000080002aa8 <iget>:
{
    80002aa8:	7179                	addi	sp,sp,-48
    80002aaa:	f406                	sd	ra,40(sp)
    80002aac:	f022                	sd	s0,32(sp)
    80002aae:	ec26                	sd	s1,24(sp)
    80002ab0:	e84a                	sd	s2,16(sp)
    80002ab2:	e44e                	sd	s3,8(sp)
    80002ab4:	e052                	sd	s4,0(sp)
    80002ab6:	1800                	addi	s0,sp,48
    80002ab8:	89aa                	mv	s3,a0
    80002aba:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002abc:	00018517          	auipc	a0,0x18
    80002ac0:	66c50513          	addi	a0,a0,1644 # 8001b128 <itable>
    80002ac4:	00004097          	auipc	ra,0x4
    80002ac8:	bf2080e7          	jalr	-1038(ra) # 800066b6 <acquire>
  empty = 0;
    80002acc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ace:	00018497          	auipc	s1,0x18
    80002ad2:	67a48493          	addi	s1,s1,1658 # 8001b148 <itable+0x20>
    80002ad6:	0001a697          	auipc	a3,0x1a
    80002ada:	29268693          	addi	a3,a3,658 # 8001cd68 <log>
    80002ade:	a039                	j	80002aec <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ae0:	02090b63          	beqz	s2,80002b16 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ae4:	09048493          	addi	s1,s1,144
    80002ae8:	02d48a63          	beq	s1,a3,80002b1c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aec:	449c                	lw	a5,8(s1)
    80002aee:	fef059e3          	blez	a5,80002ae0 <iget+0x38>
    80002af2:	4098                	lw	a4,0(s1)
    80002af4:	ff3716e3          	bne	a4,s3,80002ae0 <iget+0x38>
    80002af8:	40d8                	lw	a4,4(s1)
    80002afa:	ff4713e3          	bne	a4,s4,80002ae0 <iget+0x38>
      ip->ref++;
    80002afe:	2785                	addiw	a5,a5,1
    80002b00:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b02:	00018517          	auipc	a0,0x18
    80002b06:	62650513          	addi	a0,a0,1574 # 8001b128 <itable>
    80002b0a:	00004097          	auipc	ra,0x4
    80002b0e:	c7c080e7          	jalr	-900(ra) # 80006786 <release>
      return ip;
    80002b12:	8926                	mv	s2,s1
    80002b14:	a03d                	j	80002b42 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b16:	f7f9                	bnez	a5,80002ae4 <iget+0x3c>
    80002b18:	8926                	mv	s2,s1
    80002b1a:	b7e9                	j	80002ae4 <iget+0x3c>
  if(empty == 0)
    80002b1c:	02090c63          	beqz	s2,80002b54 <iget+0xac>
  ip->dev = dev;
    80002b20:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b24:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b28:	4785                	li	a5,1
    80002b2a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b2e:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b32:	00018517          	auipc	a0,0x18
    80002b36:	5f650513          	addi	a0,a0,1526 # 8001b128 <itable>
    80002b3a:	00004097          	auipc	ra,0x4
    80002b3e:	c4c080e7          	jalr	-948(ra) # 80006786 <release>
}
    80002b42:	854a                	mv	a0,s2
    80002b44:	70a2                	ld	ra,40(sp)
    80002b46:	7402                	ld	s0,32(sp)
    80002b48:	64e2                	ld	s1,24(sp)
    80002b4a:	6942                	ld	s2,16(sp)
    80002b4c:	69a2                	ld	s3,8(sp)
    80002b4e:	6a02                	ld	s4,0(sp)
    80002b50:	6145                	addi	sp,sp,48
    80002b52:	8082                	ret
    panic("iget: no inodes");
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	9b450513          	addi	a0,a0,-1612 # 80008508 <syscalls+0x140>
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	638080e7          	jalr	1592(ra) # 80006194 <panic>

0000000080002b64 <fsinit>:
fsinit(int dev) {
    80002b64:	7179                	addi	sp,sp,-48
    80002b66:	f406                	sd	ra,40(sp)
    80002b68:	f022                	sd	s0,32(sp)
    80002b6a:	ec26                	sd	s1,24(sp)
    80002b6c:	e84a                	sd	s2,16(sp)
    80002b6e:	e44e                	sd	s3,8(sp)
    80002b70:	1800                	addi	s0,sp,48
    80002b72:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b74:	4585                	li	a1,1
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	85c080e7          	jalr	-1956(ra) # 800023d2 <bread>
    80002b7e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b80:	00018997          	auipc	s3,0x18
    80002b84:	58898993          	addi	s3,s3,1416 # 8001b108 <sb>
    80002b88:	02000613          	li	a2,32
    80002b8c:	06050593          	addi	a1,a0,96
    80002b90:	854e                	mv	a0,s3
    80002b92:	ffffd097          	auipc	ra,0xffffd
    80002b96:	746080e7          	jalr	1862(ra) # 800002d8 <memmove>
  brelse(bp);
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	b5e080e7          	jalr	-1186(ra) # 800026fa <brelse>
  if(sb.magic != FSMAGIC)
    80002ba4:	0009a703          	lw	a4,0(s3)
    80002ba8:	102037b7          	lui	a5,0x10203
    80002bac:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bb0:	02f71263          	bne	a4,a5,80002bd4 <fsinit+0x70>
  initlog(dev, &sb);
    80002bb4:	00018597          	auipc	a1,0x18
    80002bb8:	55458593          	addi	a1,a1,1364 # 8001b108 <sb>
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	00001097          	auipc	ra,0x1
    80002bc2:	b56080e7          	jalr	-1194(ra) # 80003714 <initlog>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret
    panic("invalid file system");
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	94450513          	addi	a0,a0,-1724 # 80008518 <syscalls+0x150>
    80002bdc:	00003097          	auipc	ra,0x3
    80002be0:	5b8080e7          	jalr	1464(ra) # 80006194 <panic>

0000000080002be4 <iinit>:
{
    80002be4:	7179                	addi	sp,sp,-48
    80002be6:	f406                	sd	ra,40(sp)
    80002be8:	f022                	sd	s0,32(sp)
    80002bea:	ec26                	sd	s1,24(sp)
    80002bec:	e84a                	sd	s2,16(sp)
    80002bee:	e44e                	sd	s3,8(sp)
    80002bf0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bf2:	00006597          	auipc	a1,0x6
    80002bf6:	93e58593          	addi	a1,a1,-1730 # 80008530 <syscalls+0x168>
    80002bfa:	00018517          	auipc	a0,0x18
    80002bfe:	52e50513          	addi	a0,a0,1326 # 8001b128 <itable>
    80002c02:	00004097          	auipc	ra,0x4
    80002c06:	c30080e7          	jalr	-976(ra) # 80006832 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c0a:	00018497          	auipc	s1,0x18
    80002c0e:	54e48493          	addi	s1,s1,1358 # 8001b158 <itable+0x30>
    80002c12:	0001a997          	auipc	s3,0x1a
    80002c16:	16698993          	addi	s3,s3,358 # 8001cd78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c1a:	00006917          	auipc	s2,0x6
    80002c1e:	91e90913          	addi	s2,s2,-1762 # 80008538 <syscalls+0x170>
    80002c22:	85ca                	mv	a1,s2
    80002c24:	8526                	mv	a0,s1
    80002c26:	00001097          	auipc	ra,0x1
    80002c2a:	e4e080e7          	jalr	-434(ra) # 80003a74 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c2e:	09048493          	addi	s1,s1,144
    80002c32:	ff3498e3          	bne	s1,s3,80002c22 <iinit+0x3e>
}
    80002c36:	70a2                	ld	ra,40(sp)
    80002c38:	7402                	ld	s0,32(sp)
    80002c3a:	64e2                	ld	s1,24(sp)
    80002c3c:	6942                	ld	s2,16(sp)
    80002c3e:	69a2                	ld	s3,8(sp)
    80002c40:	6145                	addi	sp,sp,48
    80002c42:	8082                	ret

0000000080002c44 <ialloc>:
{
    80002c44:	715d                	addi	sp,sp,-80
    80002c46:	e486                	sd	ra,72(sp)
    80002c48:	e0a2                	sd	s0,64(sp)
    80002c4a:	fc26                	sd	s1,56(sp)
    80002c4c:	f84a                	sd	s2,48(sp)
    80002c4e:	f44e                	sd	s3,40(sp)
    80002c50:	f052                	sd	s4,32(sp)
    80002c52:	ec56                	sd	s5,24(sp)
    80002c54:	e85a                	sd	s6,16(sp)
    80002c56:	e45e                	sd	s7,8(sp)
    80002c58:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c5a:	00018717          	auipc	a4,0x18
    80002c5e:	4ba72703          	lw	a4,1210(a4) # 8001b114 <sb+0xc>
    80002c62:	4785                	li	a5,1
    80002c64:	04e7fa63          	bgeu	a5,a4,80002cb8 <ialloc+0x74>
    80002c68:	8aaa                	mv	s5,a0
    80002c6a:	8bae                	mv	s7,a1
    80002c6c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c6e:	00018a17          	auipc	s4,0x18
    80002c72:	49aa0a13          	addi	s4,s4,1178 # 8001b108 <sb>
    80002c76:	00048b1b          	sext.w	s6,s1
    80002c7a:	0044d593          	srli	a1,s1,0x4
    80002c7e:	018a2783          	lw	a5,24(s4)
    80002c82:	9dbd                	addw	a1,a1,a5
    80002c84:	8556                	mv	a0,s5
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	74c080e7          	jalr	1868(ra) # 800023d2 <bread>
    80002c8e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c90:	06050993          	addi	s3,a0,96
    80002c94:	00f4f793          	andi	a5,s1,15
    80002c98:	079a                	slli	a5,a5,0x6
    80002c9a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c9c:	00099783          	lh	a5,0(s3)
    80002ca0:	c785                	beqz	a5,80002cc8 <ialloc+0x84>
    brelse(bp);
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	a58080e7          	jalr	-1448(ra) # 800026fa <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002caa:	0485                	addi	s1,s1,1
    80002cac:	00ca2703          	lw	a4,12(s4)
    80002cb0:	0004879b          	sext.w	a5,s1
    80002cb4:	fce7e1e3          	bltu	a5,a4,80002c76 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cb8:	00006517          	auipc	a0,0x6
    80002cbc:	88850513          	addi	a0,a0,-1912 # 80008540 <syscalls+0x178>
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	4d4080e7          	jalr	1236(ra) # 80006194 <panic>
      memset(dip, 0, sizeof(*dip));
    80002cc8:	04000613          	li	a2,64
    80002ccc:	4581                	li	a1,0
    80002cce:	854e                	mv	a0,s3
    80002cd0:	ffffd097          	auipc	ra,0xffffd
    80002cd4:	5ac080e7          	jalr	1452(ra) # 8000027c <memset>
      dip->type = type;
    80002cd8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cdc:	854a                	mv	a0,s2
    80002cde:	00001097          	auipc	ra,0x1
    80002ce2:	cb2080e7          	jalr	-846(ra) # 80003990 <log_write>
      brelse(bp);
    80002ce6:	854a                	mv	a0,s2
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	a12080e7          	jalr	-1518(ra) # 800026fa <brelse>
      return iget(dev, inum);
    80002cf0:	85da                	mv	a1,s6
    80002cf2:	8556                	mv	a0,s5
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	db4080e7          	jalr	-588(ra) # 80002aa8 <iget>
}
    80002cfc:	60a6                	ld	ra,72(sp)
    80002cfe:	6406                	ld	s0,64(sp)
    80002d00:	74e2                	ld	s1,56(sp)
    80002d02:	7942                	ld	s2,48(sp)
    80002d04:	79a2                	ld	s3,40(sp)
    80002d06:	7a02                	ld	s4,32(sp)
    80002d08:	6ae2                	ld	s5,24(sp)
    80002d0a:	6b42                	ld	s6,16(sp)
    80002d0c:	6ba2                	ld	s7,8(sp)
    80002d0e:	6161                	addi	sp,sp,80
    80002d10:	8082                	ret

0000000080002d12 <iupdate>:
{
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	e04a                	sd	s2,0(sp)
    80002d1c:	1000                	addi	s0,sp,32
    80002d1e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d20:	415c                	lw	a5,4(a0)
    80002d22:	0047d79b          	srliw	a5,a5,0x4
    80002d26:	00018597          	auipc	a1,0x18
    80002d2a:	3fa5a583          	lw	a1,1018(a1) # 8001b120 <sb+0x18>
    80002d2e:	9dbd                	addw	a1,a1,a5
    80002d30:	4108                	lw	a0,0(a0)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	6a0080e7          	jalr	1696(ra) # 800023d2 <bread>
    80002d3a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d3c:	06050793          	addi	a5,a0,96
    80002d40:	40d8                	lw	a4,4(s1)
    80002d42:	8b3d                	andi	a4,a4,15
    80002d44:	071a                	slli	a4,a4,0x6
    80002d46:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d48:	04c49703          	lh	a4,76(s1)
    80002d4c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d50:	04e49703          	lh	a4,78(s1)
    80002d54:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d58:	05049703          	lh	a4,80(s1)
    80002d5c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d60:	05249703          	lh	a4,82(s1)
    80002d64:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d68:	48f8                	lw	a4,84(s1)
    80002d6a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d6c:	03400613          	li	a2,52
    80002d70:	05848593          	addi	a1,s1,88
    80002d74:	00c78513          	addi	a0,a5,12
    80002d78:	ffffd097          	auipc	ra,0xffffd
    80002d7c:	560080e7          	jalr	1376(ra) # 800002d8 <memmove>
  log_write(bp);
    80002d80:	854a                	mv	a0,s2
    80002d82:	00001097          	auipc	ra,0x1
    80002d86:	c0e080e7          	jalr	-1010(ra) # 80003990 <log_write>
  brelse(bp);
    80002d8a:	854a                	mv	a0,s2
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	96e080e7          	jalr	-1682(ra) # 800026fa <brelse>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <idup>:
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	1000                	addi	s0,sp,32
    80002daa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dac:	00018517          	auipc	a0,0x18
    80002db0:	37c50513          	addi	a0,a0,892 # 8001b128 <itable>
    80002db4:	00004097          	auipc	ra,0x4
    80002db8:	902080e7          	jalr	-1790(ra) # 800066b6 <acquire>
  ip->ref++;
    80002dbc:	449c                	lw	a5,8(s1)
    80002dbe:	2785                	addiw	a5,a5,1
    80002dc0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc2:	00018517          	auipc	a0,0x18
    80002dc6:	36650513          	addi	a0,a0,870 # 8001b128 <itable>
    80002dca:	00004097          	auipc	ra,0x4
    80002dce:	9bc080e7          	jalr	-1604(ra) # 80006786 <release>
}
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	60e2                	ld	ra,24(sp)
    80002dd6:	6442                	ld	s0,16(sp)
    80002dd8:	64a2                	ld	s1,8(sp)
    80002dda:	6105                	addi	sp,sp,32
    80002ddc:	8082                	ret

0000000080002dde <ilock>:
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	e04a                	sd	s2,0(sp)
    80002de8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002dea:	c115                	beqz	a0,80002e0e <ilock+0x30>
    80002dec:	84aa                	mv	s1,a0
    80002dee:	451c                	lw	a5,8(a0)
    80002df0:	00f05f63          	blez	a5,80002e0e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002df4:	0541                	addi	a0,a0,16
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	cb8080e7          	jalr	-840(ra) # 80003aae <acquiresleep>
  if(ip->valid == 0){
    80002dfe:	44bc                	lw	a5,72(s1)
    80002e00:	cf99                	beqz	a5,80002e1e <ilock+0x40>
}
    80002e02:	60e2                	ld	ra,24(sp)
    80002e04:	6442                	ld	s0,16(sp)
    80002e06:	64a2                	ld	s1,8(sp)
    80002e08:	6902                	ld	s2,0(sp)
    80002e0a:	6105                	addi	sp,sp,32
    80002e0c:	8082                	ret
    panic("ilock");
    80002e0e:	00005517          	auipc	a0,0x5
    80002e12:	74a50513          	addi	a0,a0,1866 # 80008558 <syscalls+0x190>
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	37e080e7          	jalr	894(ra) # 80006194 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e1e:	40dc                	lw	a5,4(s1)
    80002e20:	0047d79b          	srliw	a5,a5,0x4
    80002e24:	00018597          	auipc	a1,0x18
    80002e28:	2fc5a583          	lw	a1,764(a1) # 8001b120 <sb+0x18>
    80002e2c:	9dbd                	addw	a1,a1,a5
    80002e2e:	4088                	lw	a0,0(s1)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	5a2080e7          	jalr	1442(ra) # 800023d2 <bread>
    80002e38:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e3a:	06050593          	addi	a1,a0,96
    80002e3e:	40dc                	lw	a5,4(s1)
    80002e40:	8bbd                	andi	a5,a5,15
    80002e42:	079a                	slli	a5,a5,0x6
    80002e44:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e46:	00059783          	lh	a5,0(a1)
    80002e4a:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002e4e:	00259783          	lh	a5,2(a1)
    80002e52:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002e56:	00459783          	lh	a5,4(a1)
    80002e5a:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002e5e:	00659783          	lh	a5,6(a1)
    80002e62:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002e66:	459c                	lw	a5,8(a1)
    80002e68:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e6a:	03400613          	li	a2,52
    80002e6e:	05b1                	addi	a1,a1,12
    80002e70:	05848513          	addi	a0,s1,88
    80002e74:	ffffd097          	auipc	ra,0xffffd
    80002e78:	464080e7          	jalr	1124(ra) # 800002d8 <memmove>
    brelse(bp);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	87c080e7          	jalr	-1924(ra) # 800026fa <brelse>
    ip->valid = 1;
    80002e86:	4785                	li	a5,1
    80002e88:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e8a:	04c49783          	lh	a5,76(s1)
    80002e8e:	fbb5                	bnez	a5,80002e02 <ilock+0x24>
      panic("ilock: no type");
    80002e90:	00005517          	auipc	a0,0x5
    80002e94:	6d050513          	addi	a0,a0,1744 # 80008560 <syscalls+0x198>
    80002e98:	00003097          	auipc	ra,0x3
    80002e9c:	2fc080e7          	jalr	764(ra) # 80006194 <panic>

0000000080002ea0 <iunlock>:
{
    80002ea0:	1101                	addi	sp,sp,-32
    80002ea2:	ec06                	sd	ra,24(sp)
    80002ea4:	e822                	sd	s0,16(sp)
    80002ea6:	e426                	sd	s1,8(sp)
    80002ea8:	e04a                	sd	s2,0(sp)
    80002eaa:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002eac:	c905                	beqz	a0,80002edc <iunlock+0x3c>
    80002eae:	84aa                	mv	s1,a0
    80002eb0:	01050913          	addi	s2,a0,16
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	00001097          	auipc	ra,0x1
    80002eba:	c92080e7          	jalr	-878(ra) # 80003b48 <holdingsleep>
    80002ebe:	cd19                	beqz	a0,80002edc <iunlock+0x3c>
    80002ec0:	449c                	lw	a5,8(s1)
    80002ec2:	00f05d63          	blez	a5,80002edc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	00001097          	auipc	ra,0x1
    80002ecc:	c3c080e7          	jalr	-964(ra) # 80003b04 <releasesleep>
}
    80002ed0:	60e2                	ld	ra,24(sp)
    80002ed2:	6442                	ld	s0,16(sp)
    80002ed4:	64a2                	ld	s1,8(sp)
    80002ed6:	6902                	ld	s2,0(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret
    panic("iunlock");
    80002edc:	00005517          	auipc	a0,0x5
    80002ee0:	69450513          	addi	a0,a0,1684 # 80008570 <syscalls+0x1a8>
    80002ee4:	00003097          	auipc	ra,0x3
    80002ee8:	2b0080e7          	jalr	688(ra) # 80006194 <panic>

0000000080002eec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eec:	7179                	addi	sp,sp,-48
    80002eee:	f406                	sd	ra,40(sp)
    80002ef0:	f022                	sd	s0,32(sp)
    80002ef2:	ec26                	sd	s1,24(sp)
    80002ef4:	e84a                	sd	s2,16(sp)
    80002ef6:	e44e                	sd	s3,8(sp)
    80002ef8:	e052                	sd	s4,0(sp)
    80002efa:	1800                	addi	s0,sp,48
    80002efc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002efe:	05850493          	addi	s1,a0,88
    80002f02:	08850913          	addi	s2,a0,136
    80002f06:	a021                	j	80002f0e <itrunc+0x22>
    80002f08:	0491                	addi	s1,s1,4
    80002f0a:	01248d63          	beq	s1,s2,80002f24 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f0e:	408c                	lw	a1,0(s1)
    80002f10:	dde5                	beqz	a1,80002f08 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f12:	0009a503          	lw	a0,0(s3)
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	90c080e7          	jalr	-1780(ra) # 80002822 <bfree>
      ip->addrs[i] = 0;
    80002f1e:	0004a023          	sw	zero,0(s1)
    80002f22:	b7dd                	j	80002f08 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f24:	0889a583          	lw	a1,136(s3)
    80002f28:	e185                	bnez	a1,80002f48 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f2a:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f2e:	854e                	mv	a0,s3
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	de2080e7          	jalr	-542(ra) # 80002d12 <iupdate>
}
    80002f38:	70a2                	ld	ra,40(sp)
    80002f3a:	7402                	ld	s0,32(sp)
    80002f3c:	64e2                	ld	s1,24(sp)
    80002f3e:	6942                	ld	s2,16(sp)
    80002f40:	69a2                	ld	s3,8(sp)
    80002f42:	6a02                	ld	s4,0(sp)
    80002f44:	6145                	addi	sp,sp,48
    80002f46:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f48:	0009a503          	lw	a0,0(s3)
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	486080e7          	jalr	1158(ra) # 800023d2 <bread>
    80002f54:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f56:	06050493          	addi	s1,a0,96
    80002f5a:	46050913          	addi	s2,a0,1120
    80002f5e:	a021                	j	80002f66 <itrunc+0x7a>
    80002f60:	0491                	addi	s1,s1,4
    80002f62:	01248b63          	beq	s1,s2,80002f78 <itrunc+0x8c>
      if(a[j])
    80002f66:	408c                	lw	a1,0(s1)
    80002f68:	dde5                	beqz	a1,80002f60 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f6a:	0009a503          	lw	a0,0(s3)
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	8b4080e7          	jalr	-1868(ra) # 80002822 <bfree>
    80002f76:	b7ed                	j	80002f60 <itrunc+0x74>
    brelse(bp);
    80002f78:	8552                	mv	a0,s4
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	780080e7          	jalr	1920(ra) # 800026fa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f82:	0889a583          	lw	a1,136(s3)
    80002f86:	0009a503          	lw	a0,0(s3)
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	898080e7          	jalr	-1896(ra) # 80002822 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f92:	0809a423          	sw	zero,136(s3)
    80002f96:	bf51                	j	80002f2a <itrunc+0x3e>

0000000080002f98 <iput>:
{
    80002f98:	1101                	addi	sp,sp,-32
    80002f9a:	ec06                	sd	ra,24(sp)
    80002f9c:	e822                	sd	s0,16(sp)
    80002f9e:	e426                	sd	s1,8(sp)
    80002fa0:	e04a                	sd	s2,0(sp)
    80002fa2:	1000                	addi	s0,sp,32
    80002fa4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fa6:	00018517          	auipc	a0,0x18
    80002faa:	18250513          	addi	a0,a0,386 # 8001b128 <itable>
    80002fae:	00003097          	auipc	ra,0x3
    80002fb2:	708080e7          	jalr	1800(ra) # 800066b6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fb6:	4498                	lw	a4,8(s1)
    80002fb8:	4785                	li	a5,1
    80002fba:	02f70363          	beq	a4,a5,80002fe0 <iput+0x48>
  ip->ref--;
    80002fbe:	449c                	lw	a5,8(s1)
    80002fc0:	37fd                	addiw	a5,a5,-1
    80002fc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fc4:	00018517          	auipc	a0,0x18
    80002fc8:	16450513          	addi	a0,a0,356 # 8001b128 <itable>
    80002fcc:	00003097          	auipc	ra,0x3
    80002fd0:	7ba080e7          	jalr	1978(ra) # 80006786 <release>
}
    80002fd4:	60e2                	ld	ra,24(sp)
    80002fd6:	6442                	ld	s0,16(sp)
    80002fd8:	64a2                	ld	s1,8(sp)
    80002fda:	6902                	ld	s2,0(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fe0:	44bc                	lw	a5,72(s1)
    80002fe2:	dff1                	beqz	a5,80002fbe <iput+0x26>
    80002fe4:	05249783          	lh	a5,82(s1)
    80002fe8:	fbf9                	bnez	a5,80002fbe <iput+0x26>
    acquiresleep(&ip->lock);
    80002fea:	01048913          	addi	s2,s1,16
    80002fee:	854a                	mv	a0,s2
    80002ff0:	00001097          	auipc	ra,0x1
    80002ff4:	abe080e7          	jalr	-1346(ra) # 80003aae <acquiresleep>
    release(&itable.lock);
    80002ff8:	00018517          	auipc	a0,0x18
    80002ffc:	13050513          	addi	a0,a0,304 # 8001b128 <itable>
    80003000:	00003097          	auipc	ra,0x3
    80003004:	786080e7          	jalr	1926(ra) # 80006786 <release>
    itrunc(ip);
    80003008:	8526                	mv	a0,s1
    8000300a:	00000097          	auipc	ra,0x0
    8000300e:	ee2080e7          	jalr	-286(ra) # 80002eec <itrunc>
    ip->type = 0;
    80003012:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003016:	8526                	mv	a0,s1
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	cfa080e7          	jalr	-774(ra) # 80002d12 <iupdate>
    ip->valid = 0;
    80003020:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003024:	854a                	mv	a0,s2
    80003026:	00001097          	auipc	ra,0x1
    8000302a:	ade080e7          	jalr	-1314(ra) # 80003b04 <releasesleep>
    acquire(&itable.lock);
    8000302e:	00018517          	auipc	a0,0x18
    80003032:	0fa50513          	addi	a0,a0,250 # 8001b128 <itable>
    80003036:	00003097          	auipc	ra,0x3
    8000303a:	680080e7          	jalr	1664(ra) # 800066b6 <acquire>
    8000303e:	b741                	j	80002fbe <iput+0x26>

0000000080003040 <iunlockput>:
{
    80003040:	1101                	addi	sp,sp,-32
    80003042:	ec06                	sd	ra,24(sp)
    80003044:	e822                	sd	s0,16(sp)
    80003046:	e426                	sd	s1,8(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	e54080e7          	jalr	-428(ra) # 80002ea0 <iunlock>
  iput(ip);
    80003054:	8526                	mv	a0,s1
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	f42080e7          	jalr	-190(ra) # 80002f98 <iput>
}
    8000305e:	60e2                	ld	ra,24(sp)
    80003060:	6442                	ld	s0,16(sp)
    80003062:	64a2                	ld	s1,8(sp)
    80003064:	6105                	addi	sp,sp,32
    80003066:	8082                	ret

0000000080003068 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003068:	1141                	addi	sp,sp,-16
    8000306a:	e422                	sd	s0,8(sp)
    8000306c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000306e:	411c                	lw	a5,0(a0)
    80003070:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003072:	415c                	lw	a5,4(a0)
    80003074:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003076:	04c51783          	lh	a5,76(a0)
    8000307a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000307e:	05251783          	lh	a5,82(a0)
    80003082:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003086:	05456783          	lwu	a5,84(a0)
    8000308a:	e99c                	sd	a5,16(a1)
}
    8000308c:	6422                	ld	s0,8(sp)
    8000308e:	0141                	addi	sp,sp,16
    80003090:	8082                	ret

0000000080003092 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003092:	497c                	lw	a5,84(a0)
    80003094:	0ed7e963          	bltu	a5,a3,80003186 <readi+0xf4>
{
    80003098:	7159                	addi	sp,sp,-112
    8000309a:	f486                	sd	ra,104(sp)
    8000309c:	f0a2                	sd	s0,96(sp)
    8000309e:	eca6                	sd	s1,88(sp)
    800030a0:	e8ca                	sd	s2,80(sp)
    800030a2:	e4ce                	sd	s3,72(sp)
    800030a4:	e0d2                	sd	s4,64(sp)
    800030a6:	fc56                	sd	s5,56(sp)
    800030a8:	f85a                	sd	s6,48(sp)
    800030aa:	f45e                	sd	s7,40(sp)
    800030ac:	f062                	sd	s8,32(sp)
    800030ae:	ec66                	sd	s9,24(sp)
    800030b0:	e86a                	sd	s10,16(sp)
    800030b2:	e46e                	sd	s11,8(sp)
    800030b4:	1880                	addi	s0,sp,112
    800030b6:	8baa                	mv	s7,a0
    800030b8:	8c2e                	mv	s8,a1
    800030ba:	8ab2                	mv	s5,a2
    800030bc:	84b6                	mv	s1,a3
    800030be:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030c0:	9f35                	addw	a4,a4,a3
    return 0;
    800030c2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030c4:	0ad76063          	bltu	a4,a3,80003164 <readi+0xd2>
  if(off + n > ip->size)
    800030c8:	00e7f463          	bgeu	a5,a4,800030d0 <readi+0x3e>
    n = ip->size - off;
    800030cc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	0a0b0963          	beqz	s6,80003182 <readi+0xf0>
    800030d4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030da:	5cfd                	li	s9,-1
    800030dc:	a82d                	j	80003116 <readi+0x84>
    800030de:	020a1d93          	slli	s11,s4,0x20
    800030e2:	020ddd93          	srli	s11,s11,0x20
    800030e6:	06090613          	addi	a2,s2,96
    800030ea:	86ee                	mv	a3,s11
    800030ec:	963a                	add	a2,a2,a4
    800030ee:	85d6                	mv	a1,s5
    800030f0:	8562                	mv	a0,s8
    800030f2:	fffff097          	auipc	ra,0xfffff
    800030f6:	8cc080e7          	jalr	-1844(ra) # 800019be <either_copyout>
    800030fa:	05950d63          	beq	a0,s9,80003154 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030fe:	854a                	mv	a0,s2
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	5fa080e7          	jalr	1530(ra) # 800026fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003108:	013a09bb          	addw	s3,s4,s3
    8000310c:	009a04bb          	addw	s1,s4,s1
    80003110:	9aee                	add	s5,s5,s11
    80003112:	0569f763          	bgeu	s3,s6,80003160 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003116:	000ba903          	lw	s2,0(s7)
    8000311a:	00a4d59b          	srliw	a1,s1,0xa
    8000311e:	855e                	mv	a0,s7
    80003120:	00000097          	auipc	ra,0x0
    80003124:	8ac080e7          	jalr	-1876(ra) # 800029cc <bmap>
    80003128:	0005059b          	sext.w	a1,a0
    8000312c:	854a                	mv	a0,s2
    8000312e:	fffff097          	auipc	ra,0xfffff
    80003132:	2a4080e7          	jalr	676(ra) # 800023d2 <bread>
    80003136:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003138:	3ff4f713          	andi	a4,s1,1023
    8000313c:	40ed07bb          	subw	a5,s10,a4
    80003140:	413b06bb          	subw	a3,s6,s3
    80003144:	8a3e                	mv	s4,a5
    80003146:	2781                	sext.w	a5,a5
    80003148:	0006861b          	sext.w	a2,a3
    8000314c:	f8f679e3          	bgeu	a2,a5,800030de <readi+0x4c>
    80003150:	8a36                	mv	s4,a3
    80003152:	b771                	j	800030de <readi+0x4c>
      brelse(bp);
    80003154:	854a                	mv	a0,s2
    80003156:	fffff097          	auipc	ra,0xfffff
    8000315a:	5a4080e7          	jalr	1444(ra) # 800026fa <brelse>
      tot = -1;
    8000315e:	59fd                	li	s3,-1
  }
  return tot;
    80003160:	0009851b          	sext.w	a0,s3
}
    80003164:	70a6                	ld	ra,104(sp)
    80003166:	7406                	ld	s0,96(sp)
    80003168:	64e6                	ld	s1,88(sp)
    8000316a:	6946                	ld	s2,80(sp)
    8000316c:	69a6                	ld	s3,72(sp)
    8000316e:	6a06                	ld	s4,64(sp)
    80003170:	7ae2                	ld	s5,56(sp)
    80003172:	7b42                	ld	s6,48(sp)
    80003174:	7ba2                	ld	s7,40(sp)
    80003176:	7c02                	ld	s8,32(sp)
    80003178:	6ce2                	ld	s9,24(sp)
    8000317a:	6d42                	ld	s10,16(sp)
    8000317c:	6da2                	ld	s11,8(sp)
    8000317e:	6165                	addi	sp,sp,112
    80003180:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003182:	89da                	mv	s3,s6
    80003184:	bff1                	j	80003160 <readi+0xce>
    return 0;
    80003186:	4501                	li	a0,0
}
    80003188:	8082                	ret

000000008000318a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000318a:	497c                	lw	a5,84(a0)
    8000318c:	10d7e863          	bltu	a5,a3,8000329c <writei+0x112>
{
    80003190:	7159                	addi	sp,sp,-112
    80003192:	f486                	sd	ra,104(sp)
    80003194:	f0a2                	sd	s0,96(sp)
    80003196:	eca6                	sd	s1,88(sp)
    80003198:	e8ca                	sd	s2,80(sp)
    8000319a:	e4ce                	sd	s3,72(sp)
    8000319c:	e0d2                	sd	s4,64(sp)
    8000319e:	fc56                	sd	s5,56(sp)
    800031a0:	f85a                	sd	s6,48(sp)
    800031a2:	f45e                	sd	s7,40(sp)
    800031a4:	f062                	sd	s8,32(sp)
    800031a6:	ec66                	sd	s9,24(sp)
    800031a8:	e86a                	sd	s10,16(sp)
    800031aa:	e46e                	sd	s11,8(sp)
    800031ac:	1880                	addi	s0,sp,112
    800031ae:	8b2a                	mv	s6,a0
    800031b0:	8c2e                	mv	s8,a1
    800031b2:	8ab2                	mv	s5,a2
    800031b4:	8936                	mv	s2,a3
    800031b6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031b8:	00e687bb          	addw	a5,a3,a4
    800031bc:	0ed7e263          	bltu	a5,a3,800032a0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031c0:	00043737          	lui	a4,0x43
    800031c4:	0ef76063          	bltu	a4,a5,800032a4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c8:	0c0b8863          	beqz	s7,80003298 <writei+0x10e>
    800031cc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ce:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031d2:	5cfd                	li	s9,-1
    800031d4:	a091                	j	80003218 <writei+0x8e>
    800031d6:	02099d93          	slli	s11,s3,0x20
    800031da:	020ddd93          	srli	s11,s11,0x20
    800031de:	06048513          	addi	a0,s1,96
    800031e2:	86ee                	mv	a3,s11
    800031e4:	8656                	mv	a2,s5
    800031e6:	85e2                	mv	a1,s8
    800031e8:	953a                	add	a0,a0,a4
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	82a080e7          	jalr	-2006(ra) # 80001a14 <either_copyin>
    800031f2:	07950263          	beq	a0,s9,80003256 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031f6:	8526                	mv	a0,s1
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	798080e7          	jalr	1944(ra) # 80003990 <log_write>
    brelse(bp);
    80003200:	8526                	mv	a0,s1
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	4f8080e7          	jalr	1272(ra) # 800026fa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000320a:	01498a3b          	addw	s4,s3,s4
    8000320e:	0129893b          	addw	s2,s3,s2
    80003212:	9aee                	add	s5,s5,s11
    80003214:	057a7663          	bgeu	s4,s7,80003260 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003218:	000b2483          	lw	s1,0(s6)
    8000321c:	00a9559b          	srliw	a1,s2,0xa
    80003220:	855a                	mv	a0,s6
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	7aa080e7          	jalr	1962(ra) # 800029cc <bmap>
    8000322a:	0005059b          	sext.w	a1,a0
    8000322e:	8526                	mv	a0,s1
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	1a2080e7          	jalr	418(ra) # 800023d2 <bread>
    80003238:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000323a:	3ff97713          	andi	a4,s2,1023
    8000323e:	40ed07bb          	subw	a5,s10,a4
    80003242:	414b86bb          	subw	a3,s7,s4
    80003246:	89be                	mv	s3,a5
    80003248:	2781                	sext.w	a5,a5
    8000324a:	0006861b          	sext.w	a2,a3
    8000324e:	f8f674e3          	bgeu	a2,a5,800031d6 <writei+0x4c>
    80003252:	89b6                	mv	s3,a3
    80003254:	b749                	j	800031d6 <writei+0x4c>
      brelse(bp);
    80003256:	8526                	mv	a0,s1
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	4a2080e7          	jalr	1186(ra) # 800026fa <brelse>
  }

  if(off > ip->size)
    80003260:	054b2783          	lw	a5,84(s6)
    80003264:	0127f463          	bgeu	a5,s2,8000326c <writei+0xe2>
    ip->size = off;
    80003268:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000326c:	855a                	mv	a0,s6
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	aa4080e7          	jalr	-1372(ra) # 80002d12 <iupdate>

  return tot;
    80003276:	000a051b          	sext.w	a0,s4
}
    8000327a:	70a6                	ld	ra,104(sp)
    8000327c:	7406                	ld	s0,96(sp)
    8000327e:	64e6                	ld	s1,88(sp)
    80003280:	6946                	ld	s2,80(sp)
    80003282:	69a6                	ld	s3,72(sp)
    80003284:	6a06                	ld	s4,64(sp)
    80003286:	7ae2                	ld	s5,56(sp)
    80003288:	7b42                	ld	s6,48(sp)
    8000328a:	7ba2                	ld	s7,40(sp)
    8000328c:	7c02                	ld	s8,32(sp)
    8000328e:	6ce2                	ld	s9,24(sp)
    80003290:	6d42                	ld	s10,16(sp)
    80003292:	6da2                	ld	s11,8(sp)
    80003294:	6165                	addi	sp,sp,112
    80003296:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003298:	8a5e                	mv	s4,s7
    8000329a:	bfc9                	j	8000326c <writei+0xe2>
    return -1;
    8000329c:	557d                	li	a0,-1
}
    8000329e:	8082                	ret
    return -1;
    800032a0:	557d                	li	a0,-1
    800032a2:	bfe1                	j	8000327a <writei+0xf0>
    return -1;
    800032a4:	557d                	li	a0,-1
    800032a6:	bfd1                	j	8000327a <writei+0xf0>

00000000800032a8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032a8:	1141                	addi	sp,sp,-16
    800032aa:	e406                	sd	ra,8(sp)
    800032ac:	e022                	sd	s0,0(sp)
    800032ae:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032b0:	4639                	li	a2,14
    800032b2:	ffffd097          	auipc	ra,0xffffd
    800032b6:	09a080e7          	jalr	154(ra) # 8000034c <strncmp>
}
    800032ba:	60a2                	ld	ra,8(sp)
    800032bc:	6402                	ld	s0,0(sp)
    800032be:	0141                	addi	sp,sp,16
    800032c0:	8082                	ret

00000000800032c2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032c2:	7139                	addi	sp,sp,-64
    800032c4:	fc06                	sd	ra,56(sp)
    800032c6:	f822                	sd	s0,48(sp)
    800032c8:	f426                	sd	s1,40(sp)
    800032ca:	f04a                	sd	s2,32(sp)
    800032cc:	ec4e                	sd	s3,24(sp)
    800032ce:	e852                	sd	s4,16(sp)
    800032d0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032d2:	04c51703          	lh	a4,76(a0)
    800032d6:	4785                	li	a5,1
    800032d8:	00f71a63          	bne	a4,a5,800032ec <dirlookup+0x2a>
    800032dc:	892a                	mv	s2,a0
    800032de:	89ae                	mv	s3,a1
    800032e0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e2:	497c                	lw	a5,84(a0)
    800032e4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032e6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e8:	e79d                	bnez	a5,80003316 <dirlookup+0x54>
    800032ea:	a8a5                	j	80003362 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032ec:	00005517          	auipc	a0,0x5
    800032f0:	28c50513          	addi	a0,a0,652 # 80008578 <syscalls+0x1b0>
    800032f4:	00003097          	auipc	ra,0x3
    800032f8:	ea0080e7          	jalr	-352(ra) # 80006194 <panic>
      panic("dirlookup read");
    800032fc:	00005517          	auipc	a0,0x5
    80003300:	29450513          	addi	a0,a0,660 # 80008590 <syscalls+0x1c8>
    80003304:	00003097          	auipc	ra,0x3
    80003308:	e90080e7          	jalr	-368(ra) # 80006194 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330c:	24c1                	addiw	s1,s1,16
    8000330e:	05492783          	lw	a5,84(s2)
    80003312:	04f4f763          	bgeu	s1,a5,80003360 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003316:	4741                	li	a4,16
    80003318:	86a6                	mv	a3,s1
    8000331a:	fc040613          	addi	a2,s0,-64
    8000331e:	4581                	li	a1,0
    80003320:	854a                	mv	a0,s2
    80003322:	00000097          	auipc	ra,0x0
    80003326:	d70080e7          	jalr	-656(ra) # 80003092 <readi>
    8000332a:	47c1                	li	a5,16
    8000332c:	fcf518e3          	bne	a0,a5,800032fc <dirlookup+0x3a>
    if(de.inum == 0)
    80003330:	fc045783          	lhu	a5,-64(s0)
    80003334:	dfe1                	beqz	a5,8000330c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003336:	fc240593          	addi	a1,s0,-62
    8000333a:	854e                	mv	a0,s3
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	f6c080e7          	jalr	-148(ra) # 800032a8 <namecmp>
    80003344:	f561                	bnez	a0,8000330c <dirlookup+0x4a>
      if(poff)
    80003346:	000a0463          	beqz	s4,8000334e <dirlookup+0x8c>
        *poff = off;
    8000334a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000334e:	fc045583          	lhu	a1,-64(s0)
    80003352:	00092503          	lw	a0,0(s2)
    80003356:	fffff097          	auipc	ra,0xfffff
    8000335a:	752080e7          	jalr	1874(ra) # 80002aa8 <iget>
    8000335e:	a011                	j	80003362 <dirlookup+0xa0>
  return 0;
    80003360:	4501                	li	a0,0
}
    80003362:	70e2                	ld	ra,56(sp)
    80003364:	7442                	ld	s0,48(sp)
    80003366:	74a2                	ld	s1,40(sp)
    80003368:	7902                	ld	s2,32(sp)
    8000336a:	69e2                	ld	s3,24(sp)
    8000336c:	6a42                	ld	s4,16(sp)
    8000336e:	6121                	addi	sp,sp,64
    80003370:	8082                	ret

0000000080003372 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003372:	711d                	addi	sp,sp,-96
    80003374:	ec86                	sd	ra,88(sp)
    80003376:	e8a2                	sd	s0,80(sp)
    80003378:	e4a6                	sd	s1,72(sp)
    8000337a:	e0ca                	sd	s2,64(sp)
    8000337c:	fc4e                	sd	s3,56(sp)
    8000337e:	f852                	sd	s4,48(sp)
    80003380:	f456                	sd	s5,40(sp)
    80003382:	f05a                	sd	s6,32(sp)
    80003384:	ec5e                	sd	s7,24(sp)
    80003386:	e862                	sd	s8,16(sp)
    80003388:	e466                	sd	s9,8(sp)
    8000338a:	e06a                	sd	s10,0(sp)
    8000338c:	1080                	addi	s0,sp,96
    8000338e:	84aa                	mv	s1,a0
    80003390:	8b2e                	mv	s6,a1
    80003392:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003394:	00054703          	lbu	a4,0(a0)
    80003398:	02f00793          	li	a5,47
    8000339c:	02f70363          	beq	a4,a5,800033c2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033a0:	ffffe097          	auipc	ra,0xffffe
    800033a4:	bb6080e7          	jalr	-1098(ra) # 80000f56 <myproc>
    800033a8:	15853503          	ld	a0,344(a0)
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	9f4080e7          	jalr	-1548(ra) # 80002da0 <idup>
    800033b4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800033b6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800033ba:	4cb5                	li	s9,13
  len = path - s;
    800033bc:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033be:	4c05                	li	s8,1
    800033c0:	a87d                	j	8000347e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800033c2:	4585                	li	a1,1
    800033c4:	4505                	li	a0,1
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	6e2080e7          	jalr	1762(ra) # 80002aa8 <iget>
    800033ce:	8a2a                	mv	s4,a0
    800033d0:	b7dd                	j	800033b6 <namex+0x44>
      iunlockput(ip);
    800033d2:	8552                	mv	a0,s4
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	c6c080e7          	jalr	-916(ra) # 80003040 <iunlockput>
      return 0;
    800033dc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033de:	8552                	mv	a0,s4
    800033e0:	60e6                	ld	ra,88(sp)
    800033e2:	6446                	ld	s0,80(sp)
    800033e4:	64a6                	ld	s1,72(sp)
    800033e6:	6906                	ld	s2,64(sp)
    800033e8:	79e2                	ld	s3,56(sp)
    800033ea:	7a42                	ld	s4,48(sp)
    800033ec:	7aa2                	ld	s5,40(sp)
    800033ee:	7b02                	ld	s6,32(sp)
    800033f0:	6be2                	ld	s7,24(sp)
    800033f2:	6c42                	ld	s8,16(sp)
    800033f4:	6ca2                	ld	s9,8(sp)
    800033f6:	6d02                	ld	s10,0(sp)
    800033f8:	6125                	addi	sp,sp,96
    800033fa:	8082                	ret
      iunlock(ip);
    800033fc:	8552                	mv	a0,s4
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	aa2080e7          	jalr	-1374(ra) # 80002ea0 <iunlock>
      return ip;
    80003406:	bfe1                	j	800033de <namex+0x6c>
      iunlockput(ip);
    80003408:	8552                	mv	a0,s4
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	c36080e7          	jalr	-970(ra) # 80003040 <iunlockput>
      return 0;
    80003412:	8a4e                	mv	s4,s3
    80003414:	b7e9                	j	800033de <namex+0x6c>
  len = path - s;
    80003416:	40998633          	sub	a2,s3,s1
    8000341a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000341e:	09acd863          	bge	s9,s10,800034ae <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003422:	4639                	li	a2,14
    80003424:	85a6                	mv	a1,s1
    80003426:	8556                	mv	a0,s5
    80003428:	ffffd097          	auipc	ra,0xffffd
    8000342c:	eb0080e7          	jalr	-336(ra) # 800002d8 <memmove>
    80003430:	84ce                	mv	s1,s3
  while(*path == '/')
    80003432:	0004c783          	lbu	a5,0(s1)
    80003436:	01279763          	bne	a5,s2,80003444 <namex+0xd2>
    path++;
    8000343a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000343c:	0004c783          	lbu	a5,0(s1)
    80003440:	ff278de3          	beq	a5,s2,8000343a <namex+0xc8>
    ilock(ip);
    80003444:	8552                	mv	a0,s4
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	998080e7          	jalr	-1640(ra) # 80002dde <ilock>
    if(ip->type != T_DIR){
    8000344e:	04ca1783          	lh	a5,76(s4)
    80003452:	f98790e3          	bne	a5,s8,800033d2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003456:	000b0563          	beqz	s6,80003460 <namex+0xee>
    8000345a:	0004c783          	lbu	a5,0(s1)
    8000345e:	dfd9                	beqz	a5,800033fc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003460:	865e                	mv	a2,s7
    80003462:	85d6                	mv	a1,s5
    80003464:	8552                	mv	a0,s4
    80003466:	00000097          	auipc	ra,0x0
    8000346a:	e5c080e7          	jalr	-420(ra) # 800032c2 <dirlookup>
    8000346e:	89aa                	mv	s3,a0
    80003470:	dd41                	beqz	a0,80003408 <namex+0x96>
    iunlockput(ip);
    80003472:	8552                	mv	a0,s4
    80003474:	00000097          	auipc	ra,0x0
    80003478:	bcc080e7          	jalr	-1076(ra) # 80003040 <iunlockput>
    ip = next;
    8000347c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000347e:	0004c783          	lbu	a5,0(s1)
    80003482:	01279763          	bne	a5,s2,80003490 <namex+0x11e>
    path++;
    80003486:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003488:	0004c783          	lbu	a5,0(s1)
    8000348c:	ff278de3          	beq	a5,s2,80003486 <namex+0x114>
  if(*path == 0)
    80003490:	cb9d                	beqz	a5,800034c6 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003492:	0004c783          	lbu	a5,0(s1)
    80003496:	89a6                	mv	s3,s1
  len = path - s;
    80003498:	8d5e                	mv	s10,s7
    8000349a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000349c:	01278963          	beq	a5,s2,800034ae <namex+0x13c>
    800034a0:	dbbd                	beqz	a5,80003416 <namex+0xa4>
    path++;
    800034a2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800034a4:	0009c783          	lbu	a5,0(s3)
    800034a8:	ff279ce3          	bne	a5,s2,800034a0 <namex+0x12e>
    800034ac:	b7ad                	j	80003416 <namex+0xa4>
    memmove(name, s, len);
    800034ae:	2601                	sext.w	a2,a2
    800034b0:	85a6                	mv	a1,s1
    800034b2:	8556                	mv	a0,s5
    800034b4:	ffffd097          	auipc	ra,0xffffd
    800034b8:	e24080e7          	jalr	-476(ra) # 800002d8 <memmove>
    name[len] = 0;
    800034bc:	9d56                	add	s10,s10,s5
    800034be:	000d0023          	sb	zero,0(s10) # 8000 <_entry-0x7fff8000>
    800034c2:	84ce                	mv	s1,s3
    800034c4:	b7bd                	j	80003432 <namex+0xc0>
  if(nameiparent){
    800034c6:	f00b0ce3          	beqz	s6,800033de <namex+0x6c>
    iput(ip);
    800034ca:	8552                	mv	a0,s4
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	acc080e7          	jalr	-1332(ra) # 80002f98 <iput>
    return 0;
    800034d4:	4a01                	li	s4,0
    800034d6:	b721                	j	800033de <namex+0x6c>

00000000800034d8 <dirlink>:
{
    800034d8:	7139                	addi	sp,sp,-64
    800034da:	fc06                	sd	ra,56(sp)
    800034dc:	f822                	sd	s0,48(sp)
    800034de:	f426                	sd	s1,40(sp)
    800034e0:	f04a                	sd	s2,32(sp)
    800034e2:	ec4e                	sd	s3,24(sp)
    800034e4:	e852                	sd	s4,16(sp)
    800034e6:	0080                	addi	s0,sp,64
    800034e8:	892a                	mv	s2,a0
    800034ea:	8a2e                	mv	s4,a1
    800034ec:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034ee:	4601                	li	a2,0
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	dd2080e7          	jalr	-558(ra) # 800032c2 <dirlookup>
    800034f8:	e93d                	bnez	a0,8000356e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034fa:	05492483          	lw	s1,84(s2)
    800034fe:	c49d                	beqz	s1,8000352c <dirlink+0x54>
    80003500:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003502:	4741                	li	a4,16
    80003504:	86a6                	mv	a3,s1
    80003506:	fc040613          	addi	a2,s0,-64
    8000350a:	4581                	li	a1,0
    8000350c:	854a                	mv	a0,s2
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	b84080e7          	jalr	-1148(ra) # 80003092 <readi>
    80003516:	47c1                	li	a5,16
    80003518:	06f51163          	bne	a0,a5,8000357a <dirlink+0xa2>
    if(de.inum == 0)
    8000351c:	fc045783          	lhu	a5,-64(s0)
    80003520:	c791                	beqz	a5,8000352c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003522:	24c1                	addiw	s1,s1,16
    80003524:	05492783          	lw	a5,84(s2)
    80003528:	fcf4ede3          	bltu	s1,a5,80003502 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000352c:	4639                	li	a2,14
    8000352e:	85d2                	mv	a1,s4
    80003530:	fc240513          	addi	a0,s0,-62
    80003534:	ffffd097          	auipc	ra,0xffffd
    80003538:	e54080e7          	jalr	-428(ra) # 80000388 <strncpy>
  de.inum = inum;
    8000353c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003540:	4741                	li	a4,16
    80003542:	86a6                	mv	a3,s1
    80003544:	fc040613          	addi	a2,s0,-64
    80003548:	4581                	li	a1,0
    8000354a:	854a                	mv	a0,s2
    8000354c:	00000097          	auipc	ra,0x0
    80003550:	c3e080e7          	jalr	-962(ra) # 8000318a <writei>
    80003554:	872a                	mv	a4,a0
    80003556:	47c1                	li	a5,16
  return 0;
    80003558:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000355a:	02f71863          	bne	a4,a5,8000358a <dirlink+0xb2>
}
    8000355e:	70e2                	ld	ra,56(sp)
    80003560:	7442                	ld	s0,48(sp)
    80003562:	74a2                	ld	s1,40(sp)
    80003564:	7902                	ld	s2,32(sp)
    80003566:	69e2                	ld	s3,24(sp)
    80003568:	6a42                	ld	s4,16(sp)
    8000356a:	6121                	addi	sp,sp,64
    8000356c:	8082                	ret
    iput(ip);
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	a2a080e7          	jalr	-1494(ra) # 80002f98 <iput>
    return -1;
    80003576:	557d                	li	a0,-1
    80003578:	b7dd                	j	8000355e <dirlink+0x86>
      panic("dirlink read");
    8000357a:	00005517          	auipc	a0,0x5
    8000357e:	02650513          	addi	a0,a0,38 # 800085a0 <syscalls+0x1d8>
    80003582:	00003097          	auipc	ra,0x3
    80003586:	c12080e7          	jalr	-1006(ra) # 80006194 <panic>
    panic("dirlink");
    8000358a:	00005517          	auipc	a0,0x5
    8000358e:	12650513          	addi	a0,a0,294 # 800086b0 <syscalls+0x2e8>
    80003592:	00003097          	auipc	ra,0x3
    80003596:	c02080e7          	jalr	-1022(ra) # 80006194 <panic>

000000008000359a <namei>:

struct inode*
namei(char *path)
{
    8000359a:	1101                	addi	sp,sp,-32
    8000359c:	ec06                	sd	ra,24(sp)
    8000359e:	e822                	sd	s0,16(sp)
    800035a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035a2:	fe040613          	addi	a2,s0,-32
    800035a6:	4581                	li	a1,0
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	dca080e7          	jalr	-566(ra) # 80003372 <namex>
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	6105                	addi	sp,sp,32
    800035b6:	8082                	ret

00000000800035b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035b8:	1141                	addi	sp,sp,-16
    800035ba:	e406                	sd	ra,8(sp)
    800035bc:	e022                	sd	s0,0(sp)
    800035be:	0800                	addi	s0,sp,16
    800035c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035c2:	4585                	li	a1,1
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	dae080e7          	jalr	-594(ra) # 80003372 <namex>
}
    800035cc:	60a2                	ld	ra,8(sp)
    800035ce:	6402                	ld	s0,0(sp)
    800035d0:	0141                	addi	sp,sp,16
    800035d2:	8082                	ret

00000000800035d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035d4:	1101                	addi	sp,sp,-32
    800035d6:	ec06                	sd	ra,24(sp)
    800035d8:	e822                	sd	s0,16(sp)
    800035da:	e426                	sd	s1,8(sp)
    800035dc:	e04a                	sd	s2,0(sp)
    800035de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035e0:	00019917          	auipc	s2,0x19
    800035e4:	78890913          	addi	s2,s2,1928 # 8001cd68 <log>
    800035e8:	02092583          	lw	a1,32(s2)
    800035ec:	03092503          	lw	a0,48(s2)
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	de2080e7          	jalr	-542(ra) # 800023d2 <bread>
    800035f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035fa:	03492683          	lw	a3,52(s2)
    800035fe:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003600:	02d05863          	blez	a3,80003630 <write_head+0x5c>
    80003604:	00019797          	auipc	a5,0x19
    80003608:	79c78793          	addi	a5,a5,1948 # 8001cda0 <log+0x38>
    8000360c:	06450713          	addi	a4,a0,100
    80003610:	36fd                	addiw	a3,a3,-1
    80003612:	02069613          	slli	a2,a3,0x20
    80003616:	01e65693          	srli	a3,a2,0x1e
    8000361a:	00019617          	auipc	a2,0x19
    8000361e:	78a60613          	addi	a2,a2,1930 # 8001cda4 <log+0x3c>
    80003622:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003624:	4390                	lw	a2,0(a5)
    80003626:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003628:	0791                	addi	a5,a5,4
    8000362a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000362c:	fed79ce3          	bne	a5,a3,80003624 <write_head+0x50>
  }
  bwrite(buf);
    80003630:	8526                	mv	a0,s1
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	08a080e7          	jalr	138(ra) # 800026bc <bwrite>
  brelse(buf);
    8000363a:	8526                	mv	a0,s1
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	0be080e7          	jalr	190(ra) # 800026fa <brelse>
}
    80003644:	60e2                	ld	ra,24(sp)
    80003646:	6442                	ld	s0,16(sp)
    80003648:	64a2                	ld	s1,8(sp)
    8000364a:	6902                	ld	s2,0(sp)
    8000364c:	6105                	addi	sp,sp,32
    8000364e:	8082                	ret

0000000080003650 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003650:	00019797          	auipc	a5,0x19
    80003654:	74c7a783          	lw	a5,1868(a5) # 8001cd9c <log+0x34>
    80003658:	0af05d63          	blez	a5,80003712 <install_trans+0xc2>
{
    8000365c:	7139                	addi	sp,sp,-64
    8000365e:	fc06                	sd	ra,56(sp)
    80003660:	f822                	sd	s0,48(sp)
    80003662:	f426                	sd	s1,40(sp)
    80003664:	f04a                	sd	s2,32(sp)
    80003666:	ec4e                	sd	s3,24(sp)
    80003668:	e852                	sd	s4,16(sp)
    8000366a:	e456                	sd	s5,8(sp)
    8000366c:	e05a                	sd	s6,0(sp)
    8000366e:	0080                	addi	s0,sp,64
    80003670:	8b2a                	mv	s6,a0
    80003672:	00019a97          	auipc	s5,0x19
    80003676:	72ea8a93          	addi	s5,s5,1838 # 8001cda0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000367a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000367c:	00019997          	auipc	s3,0x19
    80003680:	6ec98993          	addi	s3,s3,1772 # 8001cd68 <log>
    80003684:	a00d                	j	800036a6 <install_trans+0x56>
    brelse(lbuf);
    80003686:	854a                	mv	a0,s2
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	072080e7          	jalr	114(ra) # 800026fa <brelse>
    brelse(dbuf);
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	068080e7          	jalr	104(ra) # 800026fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369a:	2a05                	addiw	s4,s4,1
    8000369c:	0a91                	addi	s5,s5,4
    8000369e:	0349a783          	lw	a5,52(s3)
    800036a2:	04fa5e63          	bge	s4,a5,800036fe <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036a6:	0209a583          	lw	a1,32(s3)
    800036aa:	014585bb          	addw	a1,a1,s4
    800036ae:	2585                	addiw	a1,a1,1
    800036b0:	0309a503          	lw	a0,48(s3)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	d1e080e7          	jalr	-738(ra) # 800023d2 <bread>
    800036bc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036be:	000aa583          	lw	a1,0(s5)
    800036c2:	0309a503          	lw	a0,48(s3)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	d0c080e7          	jalr	-756(ra) # 800023d2 <bread>
    800036ce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036d0:	40000613          	li	a2,1024
    800036d4:	06090593          	addi	a1,s2,96
    800036d8:	06050513          	addi	a0,a0,96
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	bfc080e7          	jalr	-1028(ra) # 800002d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036e4:	8526                	mv	a0,s1
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	fd6080e7          	jalr	-42(ra) # 800026bc <bwrite>
    if(recovering == 0)
    800036ee:	f80b1ce3          	bnez	s6,80003686 <install_trans+0x36>
      bunpin(dbuf);
    800036f2:	8526                	mv	a0,s1
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	0e0080e7          	jalr	224(ra) # 800027d4 <bunpin>
    800036fc:	b769                	j	80003686 <install_trans+0x36>
}
    800036fe:	70e2                	ld	ra,56(sp)
    80003700:	7442                	ld	s0,48(sp)
    80003702:	74a2                	ld	s1,40(sp)
    80003704:	7902                	ld	s2,32(sp)
    80003706:	69e2                	ld	s3,24(sp)
    80003708:	6a42                	ld	s4,16(sp)
    8000370a:	6aa2                	ld	s5,8(sp)
    8000370c:	6b02                	ld	s6,0(sp)
    8000370e:	6121                	addi	sp,sp,64
    80003710:	8082                	ret
    80003712:	8082                	ret

0000000080003714 <initlog>:
{
    80003714:	7179                	addi	sp,sp,-48
    80003716:	f406                	sd	ra,40(sp)
    80003718:	f022                	sd	s0,32(sp)
    8000371a:	ec26                	sd	s1,24(sp)
    8000371c:	e84a                	sd	s2,16(sp)
    8000371e:	e44e                	sd	s3,8(sp)
    80003720:	1800                	addi	s0,sp,48
    80003722:	892a                	mv	s2,a0
    80003724:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003726:	00019497          	auipc	s1,0x19
    8000372a:	64248493          	addi	s1,s1,1602 # 8001cd68 <log>
    8000372e:	00005597          	auipc	a1,0x5
    80003732:	e8258593          	addi	a1,a1,-382 # 800085b0 <syscalls+0x1e8>
    80003736:	8526                	mv	a0,s1
    80003738:	00003097          	auipc	ra,0x3
    8000373c:	0fa080e7          	jalr	250(ra) # 80006832 <initlock>
  log.start = sb->logstart;
    80003740:	0149a583          	lw	a1,20(s3)
    80003744:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003746:	0109a783          	lw	a5,16(s3)
    8000374a:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    8000374c:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003750:	854a                	mv	a0,s2
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	c80080e7          	jalr	-896(ra) # 800023d2 <bread>
  log.lh.n = lh->n;
    8000375a:	5134                	lw	a3,96(a0)
    8000375c:	d8d4                	sw	a3,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000375e:	02d05663          	blez	a3,8000378a <initlog+0x76>
    80003762:	06450793          	addi	a5,a0,100
    80003766:	00019717          	auipc	a4,0x19
    8000376a:	63a70713          	addi	a4,a4,1594 # 8001cda0 <log+0x38>
    8000376e:	36fd                	addiw	a3,a3,-1
    80003770:	02069613          	slli	a2,a3,0x20
    80003774:	01e65693          	srli	a3,a2,0x1e
    80003778:	06850613          	addi	a2,a0,104
    8000377c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000377e:	4390                	lw	a2,0(a5)
    80003780:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003782:	0791                	addi	a5,a5,4
    80003784:	0711                	addi	a4,a4,4
    80003786:	fed79ce3          	bne	a5,a3,8000377e <initlog+0x6a>
  brelse(buf);
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	f70080e7          	jalr	-144(ra) # 800026fa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003792:	4505                	li	a0,1
    80003794:	00000097          	auipc	ra,0x0
    80003798:	ebc080e7          	jalr	-324(ra) # 80003650 <install_trans>
  log.lh.n = 0;
    8000379c:	00019797          	auipc	a5,0x19
    800037a0:	6007a023          	sw	zero,1536(a5) # 8001cd9c <log+0x34>
  write_head(); // clear the log
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	e30080e7          	jalr	-464(ra) # 800035d4 <write_head>
}
    800037ac:	70a2                	ld	ra,40(sp)
    800037ae:	7402                	ld	s0,32(sp)
    800037b0:	64e2                	ld	s1,24(sp)
    800037b2:	6942                	ld	s2,16(sp)
    800037b4:	69a2                	ld	s3,8(sp)
    800037b6:	6145                	addi	sp,sp,48
    800037b8:	8082                	ret

00000000800037ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037c6:	00019517          	auipc	a0,0x19
    800037ca:	5a250513          	addi	a0,a0,1442 # 8001cd68 <log>
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	ee8080e7          	jalr	-280(ra) # 800066b6 <acquire>
  while(1){
    if(log.committing){
    800037d6:	00019497          	auipc	s1,0x19
    800037da:	59248493          	addi	s1,s1,1426 # 8001cd68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037de:	4979                	li	s2,30
    800037e0:	a039                	j	800037ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800037e2:	85a6                	mv	a1,s1
    800037e4:	8526                	mv	a0,s1
    800037e6:	ffffe097          	auipc	ra,0xffffe
    800037ea:	e34080e7          	jalr	-460(ra) # 8000161a <sleep>
    if(log.committing){
    800037ee:	54dc                	lw	a5,44(s1)
    800037f0:	fbed                	bnez	a5,800037e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037f2:	5498                	lw	a4,40(s1)
    800037f4:	2705                	addiw	a4,a4,1
    800037f6:	0007069b          	sext.w	a3,a4
    800037fa:	0027179b          	slliw	a5,a4,0x2
    800037fe:	9fb9                	addw	a5,a5,a4
    80003800:	0017979b          	slliw	a5,a5,0x1
    80003804:	58d8                	lw	a4,52(s1)
    80003806:	9fb9                	addw	a5,a5,a4
    80003808:	00f95963          	bge	s2,a5,8000381a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000380c:	85a6                	mv	a1,s1
    8000380e:	8526                	mv	a0,s1
    80003810:	ffffe097          	auipc	ra,0xffffe
    80003814:	e0a080e7          	jalr	-502(ra) # 8000161a <sleep>
    80003818:	bfd9                	j	800037ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000381a:	00019517          	auipc	a0,0x19
    8000381e:	54e50513          	addi	a0,a0,1358 # 8001cd68 <log>
    80003822:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003824:	00003097          	auipc	ra,0x3
    80003828:	f62080e7          	jalr	-158(ra) # 80006786 <release>
      break;
    }
  }
}
    8000382c:	60e2                	ld	ra,24(sp)
    8000382e:	6442                	ld	s0,16(sp)
    80003830:	64a2                	ld	s1,8(sp)
    80003832:	6902                	ld	s2,0(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003838:	7139                	addi	sp,sp,-64
    8000383a:	fc06                	sd	ra,56(sp)
    8000383c:	f822                	sd	s0,48(sp)
    8000383e:	f426                	sd	s1,40(sp)
    80003840:	f04a                	sd	s2,32(sp)
    80003842:	ec4e                	sd	s3,24(sp)
    80003844:	e852                	sd	s4,16(sp)
    80003846:	e456                	sd	s5,8(sp)
    80003848:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000384a:	00019497          	auipc	s1,0x19
    8000384e:	51e48493          	addi	s1,s1,1310 # 8001cd68 <log>
    80003852:	8526                	mv	a0,s1
    80003854:	00003097          	auipc	ra,0x3
    80003858:	e62080e7          	jalr	-414(ra) # 800066b6 <acquire>
  log.outstanding -= 1;
    8000385c:	549c                	lw	a5,40(s1)
    8000385e:	37fd                	addiw	a5,a5,-1
    80003860:	0007891b          	sext.w	s2,a5
    80003864:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003866:	54dc                	lw	a5,44(s1)
    80003868:	e7b9                	bnez	a5,800038b6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000386a:	04091e63          	bnez	s2,800038c6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000386e:	00019497          	auipc	s1,0x19
    80003872:	4fa48493          	addi	s1,s1,1274 # 8001cd68 <log>
    80003876:	4785                	li	a5,1
    80003878:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000387a:	8526                	mv	a0,s1
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	f0a080e7          	jalr	-246(ra) # 80006786 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003884:	58dc                	lw	a5,52(s1)
    80003886:	06f04763          	bgtz	a5,800038f4 <end_op+0xbc>
    acquire(&log.lock);
    8000388a:	00019497          	auipc	s1,0x19
    8000388e:	4de48493          	addi	s1,s1,1246 # 8001cd68 <log>
    80003892:	8526                	mv	a0,s1
    80003894:	00003097          	auipc	ra,0x3
    80003898:	e22080e7          	jalr	-478(ra) # 800066b6 <acquire>
    log.committing = 0;
    8000389c:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800038a0:	8526                	mv	a0,s1
    800038a2:	ffffe097          	auipc	ra,0xffffe
    800038a6:	f04080e7          	jalr	-252(ra) # 800017a6 <wakeup>
    release(&log.lock);
    800038aa:	8526                	mv	a0,s1
    800038ac:	00003097          	auipc	ra,0x3
    800038b0:	eda080e7          	jalr	-294(ra) # 80006786 <release>
}
    800038b4:	a03d                	j	800038e2 <end_op+0xaa>
    panic("log.committing");
    800038b6:	00005517          	auipc	a0,0x5
    800038ba:	d0250513          	addi	a0,a0,-766 # 800085b8 <syscalls+0x1f0>
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	8d6080e7          	jalr	-1834(ra) # 80006194 <panic>
    wakeup(&log);
    800038c6:	00019497          	auipc	s1,0x19
    800038ca:	4a248493          	addi	s1,s1,1186 # 8001cd68 <log>
    800038ce:	8526                	mv	a0,s1
    800038d0:	ffffe097          	auipc	ra,0xffffe
    800038d4:	ed6080e7          	jalr	-298(ra) # 800017a6 <wakeup>
  release(&log.lock);
    800038d8:	8526                	mv	a0,s1
    800038da:	00003097          	auipc	ra,0x3
    800038de:	eac080e7          	jalr	-340(ra) # 80006786 <release>
}
    800038e2:	70e2                	ld	ra,56(sp)
    800038e4:	7442                	ld	s0,48(sp)
    800038e6:	74a2                	ld	s1,40(sp)
    800038e8:	7902                	ld	s2,32(sp)
    800038ea:	69e2                	ld	s3,24(sp)
    800038ec:	6a42                	ld	s4,16(sp)
    800038ee:	6aa2                	ld	s5,8(sp)
    800038f0:	6121                	addi	sp,sp,64
    800038f2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f4:	00019a97          	auipc	s5,0x19
    800038f8:	4aca8a93          	addi	s5,s5,1196 # 8001cda0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038fc:	00019a17          	auipc	s4,0x19
    80003900:	46ca0a13          	addi	s4,s4,1132 # 8001cd68 <log>
    80003904:	020a2583          	lw	a1,32(s4)
    80003908:	012585bb          	addw	a1,a1,s2
    8000390c:	2585                	addiw	a1,a1,1
    8000390e:	030a2503          	lw	a0,48(s4)
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	ac0080e7          	jalr	-1344(ra) # 800023d2 <bread>
    8000391a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000391c:	000aa583          	lw	a1,0(s5)
    80003920:	030a2503          	lw	a0,48(s4)
    80003924:	fffff097          	auipc	ra,0xfffff
    80003928:	aae080e7          	jalr	-1362(ra) # 800023d2 <bread>
    8000392c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000392e:	40000613          	li	a2,1024
    80003932:	06050593          	addi	a1,a0,96
    80003936:	06048513          	addi	a0,s1,96
    8000393a:	ffffd097          	auipc	ra,0xffffd
    8000393e:	99e080e7          	jalr	-1634(ra) # 800002d8 <memmove>
    bwrite(to);  // write the log
    80003942:	8526                	mv	a0,s1
    80003944:	fffff097          	auipc	ra,0xfffff
    80003948:	d78080e7          	jalr	-648(ra) # 800026bc <bwrite>
    brelse(from);
    8000394c:	854e                	mv	a0,s3
    8000394e:	fffff097          	auipc	ra,0xfffff
    80003952:	dac080e7          	jalr	-596(ra) # 800026fa <brelse>
    brelse(to);
    80003956:	8526                	mv	a0,s1
    80003958:	fffff097          	auipc	ra,0xfffff
    8000395c:	da2080e7          	jalr	-606(ra) # 800026fa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003960:	2905                	addiw	s2,s2,1
    80003962:	0a91                	addi	s5,s5,4
    80003964:	034a2783          	lw	a5,52(s4)
    80003968:	f8f94ee3          	blt	s2,a5,80003904 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	c68080e7          	jalr	-920(ra) # 800035d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003974:	4501                	li	a0,0
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	cda080e7          	jalr	-806(ra) # 80003650 <install_trans>
    log.lh.n = 0;
    8000397e:	00019797          	auipc	a5,0x19
    80003982:	4007af23          	sw	zero,1054(a5) # 8001cd9c <log+0x34>
    write_head();    // Erase the transaction from the log
    80003986:	00000097          	auipc	ra,0x0
    8000398a:	c4e080e7          	jalr	-946(ra) # 800035d4 <write_head>
    8000398e:	bdf5                	j	8000388a <end_op+0x52>

0000000080003990 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003990:	1101                	addi	sp,sp,-32
    80003992:	ec06                	sd	ra,24(sp)
    80003994:	e822                	sd	s0,16(sp)
    80003996:	e426                	sd	s1,8(sp)
    80003998:	e04a                	sd	s2,0(sp)
    8000399a:	1000                	addi	s0,sp,32
    8000399c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000399e:	00019917          	auipc	s2,0x19
    800039a2:	3ca90913          	addi	s2,s2,970 # 8001cd68 <log>
    800039a6:	854a                	mv	a0,s2
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	d0e080e7          	jalr	-754(ra) # 800066b6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039b0:	03492603          	lw	a2,52(s2)
    800039b4:	47f5                	li	a5,29
    800039b6:	06c7c563          	blt	a5,a2,80003a20 <log_write+0x90>
    800039ba:	00019797          	auipc	a5,0x19
    800039be:	3d27a783          	lw	a5,978(a5) # 8001cd8c <log+0x24>
    800039c2:	37fd                	addiw	a5,a5,-1
    800039c4:	04f65e63          	bge	a2,a5,80003a20 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039c8:	00019797          	auipc	a5,0x19
    800039cc:	3c87a783          	lw	a5,968(a5) # 8001cd90 <log+0x28>
    800039d0:	06f05063          	blez	a5,80003a30 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039d4:	4781                	li	a5,0
    800039d6:	06c05563          	blez	a2,80003a40 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039da:	44cc                	lw	a1,12(s1)
    800039dc:	00019717          	auipc	a4,0x19
    800039e0:	3c470713          	addi	a4,a4,964 # 8001cda0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    800039e4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039e6:	4314                	lw	a3,0(a4)
    800039e8:	04b68c63          	beq	a3,a1,80003a40 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039ec:	2785                	addiw	a5,a5,1
    800039ee:	0711                	addi	a4,a4,4
    800039f0:	fef61be3          	bne	a2,a5,800039e6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039f4:	0631                	addi	a2,a2,12
    800039f6:	060a                	slli	a2,a2,0x2
    800039f8:	00019797          	auipc	a5,0x19
    800039fc:	37078793          	addi	a5,a5,880 # 8001cd68 <log>
    80003a00:	97b2                	add	a5,a5,a2
    80003a02:	44d8                	lw	a4,12(s1)
    80003a04:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a06:	8526                	mv	a0,s1
    80003a08:	fffff097          	auipc	ra,0xfffff
    80003a0c:	d7e080e7          	jalr	-642(ra) # 80002786 <bpin>
    log.lh.n++;
    80003a10:	00019717          	auipc	a4,0x19
    80003a14:	35870713          	addi	a4,a4,856 # 8001cd68 <log>
    80003a18:	5b5c                	lw	a5,52(a4)
    80003a1a:	2785                	addiw	a5,a5,1
    80003a1c:	db5c                	sw	a5,52(a4)
    80003a1e:	a82d                	j	80003a58 <log_write+0xc8>
    panic("too big a transaction");
    80003a20:	00005517          	auipc	a0,0x5
    80003a24:	ba850513          	addi	a0,a0,-1112 # 800085c8 <syscalls+0x200>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	76c080e7          	jalr	1900(ra) # 80006194 <panic>
    panic("log_write outside of trans");
    80003a30:	00005517          	auipc	a0,0x5
    80003a34:	bb050513          	addi	a0,a0,-1104 # 800085e0 <syscalls+0x218>
    80003a38:	00002097          	auipc	ra,0x2
    80003a3c:	75c080e7          	jalr	1884(ra) # 80006194 <panic>
  log.lh.block[i] = b->blockno;
    80003a40:	00c78693          	addi	a3,a5,12
    80003a44:	068a                	slli	a3,a3,0x2
    80003a46:	00019717          	auipc	a4,0x19
    80003a4a:	32270713          	addi	a4,a4,802 # 8001cd68 <log>
    80003a4e:	9736                	add	a4,a4,a3
    80003a50:	44d4                	lw	a3,12(s1)
    80003a52:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a54:	faf609e3          	beq	a2,a5,80003a06 <log_write+0x76>
  }
  release(&log.lock);
    80003a58:	00019517          	auipc	a0,0x19
    80003a5c:	31050513          	addi	a0,a0,784 # 8001cd68 <log>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	d26080e7          	jalr	-730(ra) # 80006786 <release>
}
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6902                	ld	s2,0(sp)
    80003a70:	6105                	addi	sp,sp,32
    80003a72:	8082                	ret

0000000080003a74 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a74:	1101                	addi	sp,sp,-32
    80003a76:	ec06                	sd	ra,24(sp)
    80003a78:	e822                	sd	s0,16(sp)
    80003a7a:	e426                	sd	s1,8(sp)
    80003a7c:	e04a                	sd	s2,0(sp)
    80003a7e:	1000                	addi	s0,sp,32
    80003a80:	84aa                	mv	s1,a0
    80003a82:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a84:	00005597          	auipc	a1,0x5
    80003a88:	b7c58593          	addi	a1,a1,-1156 # 80008600 <syscalls+0x238>
    80003a8c:	0521                	addi	a0,a0,8
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	da4080e7          	jalr	-604(ra) # 80006832 <initlock>
  lk->name = name;
    80003a96:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a9a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a9e:	0204a823          	sw	zero,48(s1)
}
    80003aa2:	60e2                	ld	ra,24(sp)
    80003aa4:	6442                	ld	s0,16(sp)
    80003aa6:	64a2                	ld	s1,8(sp)
    80003aa8:	6902                	ld	s2,0(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	e04a                	sd	s2,0(sp)
    80003ab8:	1000                	addi	s0,sp,32
    80003aba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003abc:	00850913          	addi	s2,a0,8
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	bf4080e7          	jalr	-1036(ra) # 800066b6 <acquire>
  while (lk->locked) {
    80003aca:	409c                	lw	a5,0(s1)
    80003acc:	cb89                	beqz	a5,80003ade <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ace:	85ca                	mv	a1,s2
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	ffffe097          	auipc	ra,0xffffe
    80003ad6:	b48080e7          	jalr	-1208(ra) # 8000161a <sleep>
  while (lk->locked) {
    80003ada:	409c                	lw	a5,0(s1)
    80003adc:	fbed                	bnez	a5,80003ace <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ade:	4785                	li	a5,1
    80003ae0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	474080e7          	jalr	1140(ra) # 80000f56 <myproc>
    80003aea:	5d1c                	lw	a5,56(a0)
    80003aec:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003aee:	854a                	mv	a0,s2
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	c96080e7          	jalr	-874(ra) # 80006786 <release>
}
    80003af8:	60e2                	ld	ra,24(sp)
    80003afa:	6442                	ld	s0,16(sp)
    80003afc:	64a2                	ld	s1,8(sp)
    80003afe:	6902                	ld	s2,0(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	e04a                	sd	s2,0(sp)
    80003b0e:	1000                	addi	s0,sp,32
    80003b10:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b12:	00850913          	addi	s2,a0,8
    80003b16:	854a                	mv	a0,s2
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	b9e080e7          	jalr	-1122(ra) # 800066b6 <acquire>
  lk->locked = 0;
    80003b20:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b24:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	ffffe097          	auipc	ra,0xffffe
    80003b2e:	c7c080e7          	jalr	-900(ra) # 800017a6 <wakeup>
  release(&lk->lk);
    80003b32:	854a                	mv	a0,s2
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	c52080e7          	jalr	-942(ra) # 80006786 <release>
}
    80003b3c:	60e2                	ld	ra,24(sp)
    80003b3e:	6442                	ld	s0,16(sp)
    80003b40:	64a2                	ld	s1,8(sp)
    80003b42:	6902                	ld	s2,0(sp)
    80003b44:	6105                	addi	sp,sp,32
    80003b46:	8082                	ret

0000000080003b48 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b48:	7179                	addi	sp,sp,-48
    80003b4a:	f406                	sd	ra,40(sp)
    80003b4c:	f022                	sd	s0,32(sp)
    80003b4e:	ec26                	sd	s1,24(sp)
    80003b50:	e84a                	sd	s2,16(sp)
    80003b52:	e44e                	sd	s3,8(sp)
    80003b54:	1800                	addi	s0,sp,48
    80003b56:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b58:	00850913          	addi	s2,a0,8
    80003b5c:	854a                	mv	a0,s2
    80003b5e:	00003097          	auipc	ra,0x3
    80003b62:	b58080e7          	jalr	-1192(ra) # 800066b6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b66:	409c                	lw	a5,0(s1)
    80003b68:	ef99                	bnez	a5,80003b86 <holdingsleep+0x3e>
    80003b6a:	4481                	li	s1,0
  release(&lk->lk);
    80003b6c:	854a                	mv	a0,s2
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	c18080e7          	jalr	-1000(ra) # 80006786 <release>
  return r;
}
    80003b76:	8526                	mv	a0,s1
    80003b78:	70a2                	ld	ra,40(sp)
    80003b7a:	7402                	ld	s0,32(sp)
    80003b7c:	64e2                	ld	s1,24(sp)
    80003b7e:	6942                	ld	s2,16(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	6145                	addi	sp,sp,48
    80003b84:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b86:	0304a983          	lw	s3,48(s1)
    80003b8a:	ffffd097          	auipc	ra,0xffffd
    80003b8e:	3cc080e7          	jalr	972(ra) # 80000f56 <myproc>
    80003b92:	5d04                	lw	s1,56(a0)
    80003b94:	413484b3          	sub	s1,s1,s3
    80003b98:	0014b493          	seqz	s1,s1
    80003b9c:	bfc1                	j	80003b6c <holdingsleep+0x24>

0000000080003b9e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b9e:	1141                	addi	sp,sp,-16
    80003ba0:	e406                	sd	ra,8(sp)
    80003ba2:	e022                	sd	s0,0(sp)
    80003ba4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ba6:	00005597          	auipc	a1,0x5
    80003baa:	a6a58593          	addi	a1,a1,-1430 # 80008610 <syscalls+0x248>
    80003bae:	00019517          	auipc	a0,0x19
    80003bb2:	30a50513          	addi	a0,a0,778 # 8001ceb8 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	c7c080e7          	jalr	-900(ra) # 80006832 <initlock>
}
    80003bbe:	60a2                	ld	ra,8(sp)
    80003bc0:	6402                	ld	s0,0(sp)
    80003bc2:	0141                	addi	sp,sp,16
    80003bc4:	8082                	ret

0000000080003bc6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bc6:	1101                	addi	sp,sp,-32
    80003bc8:	ec06                	sd	ra,24(sp)
    80003bca:	e822                	sd	s0,16(sp)
    80003bcc:	e426                	sd	s1,8(sp)
    80003bce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bd0:	00019517          	auipc	a0,0x19
    80003bd4:	2e850513          	addi	a0,a0,744 # 8001ceb8 <ftable>
    80003bd8:	00003097          	auipc	ra,0x3
    80003bdc:	ade080e7          	jalr	-1314(ra) # 800066b6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003be0:	00019497          	auipc	s1,0x19
    80003be4:	2f848493          	addi	s1,s1,760 # 8001ced8 <ftable+0x20>
    80003be8:	0001a717          	auipc	a4,0x1a
    80003bec:	29070713          	addi	a4,a4,656 # 8001de78 <ftable+0xfc0>
    if(f->ref == 0){
    80003bf0:	40dc                	lw	a5,4(s1)
    80003bf2:	cf99                	beqz	a5,80003c10 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bf4:	02848493          	addi	s1,s1,40
    80003bf8:	fee49ce3          	bne	s1,a4,80003bf0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bfc:	00019517          	auipc	a0,0x19
    80003c00:	2bc50513          	addi	a0,a0,700 # 8001ceb8 <ftable>
    80003c04:	00003097          	auipc	ra,0x3
    80003c08:	b82080e7          	jalr	-1150(ra) # 80006786 <release>
  return 0;
    80003c0c:	4481                	li	s1,0
    80003c0e:	a819                	j	80003c24 <filealloc+0x5e>
      f->ref = 1;
    80003c10:	4785                	li	a5,1
    80003c12:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c14:	00019517          	auipc	a0,0x19
    80003c18:	2a450513          	addi	a0,a0,676 # 8001ceb8 <ftable>
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	b6a080e7          	jalr	-1174(ra) # 80006786 <release>
}
    80003c24:	8526                	mv	a0,s1
    80003c26:	60e2                	ld	ra,24(sp)
    80003c28:	6442                	ld	s0,16(sp)
    80003c2a:	64a2                	ld	s1,8(sp)
    80003c2c:	6105                	addi	sp,sp,32
    80003c2e:	8082                	ret

0000000080003c30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c30:	1101                	addi	sp,sp,-32
    80003c32:	ec06                	sd	ra,24(sp)
    80003c34:	e822                	sd	s0,16(sp)
    80003c36:	e426                	sd	s1,8(sp)
    80003c38:	1000                	addi	s0,sp,32
    80003c3a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c3c:	00019517          	auipc	a0,0x19
    80003c40:	27c50513          	addi	a0,a0,636 # 8001ceb8 <ftable>
    80003c44:	00003097          	auipc	ra,0x3
    80003c48:	a72080e7          	jalr	-1422(ra) # 800066b6 <acquire>
  if(f->ref < 1)
    80003c4c:	40dc                	lw	a5,4(s1)
    80003c4e:	02f05263          	blez	a5,80003c72 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c52:	2785                	addiw	a5,a5,1
    80003c54:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c56:	00019517          	auipc	a0,0x19
    80003c5a:	26250513          	addi	a0,a0,610 # 8001ceb8 <ftable>
    80003c5e:	00003097          	auipc	ra,0x3
    80003c62:	b28080e7          	jalr	-1240(ra) # 80006786 <release>
  return f;
}
    80003c66:	8526                	mv	a0,s1
    80003c68:	60e2                	ld	ra,24(sp)
    80003c6a:	6442                	ld	s0,16(sp)
    80003c6c:	64a2                	ld	s1,8(sp)
    80003c6e:	6105                	addi	sp,sp,32
    80003c70:	8082                	ret
    panic("filedup");
    80003c72:	00005517          	auipc	a0,0x5
    80003c76:	9a650513          	addi	a0,a0,-1626 # 80008618 <syscalls+0x250>
    80003c7a:	00002097          	auipc	ra,0x2
    80003c7e:	51a080e7          	jalr	1306(ra) # 80006194 <panic>

0000000080003c82 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c82:	7139                	addi	sp,sp,-64
    80003c84:	fc06                	sd	ra,56(sp)
    80003c86:	f822                	sd	s0,48(sp)
    80003c88:	f426                	sd	s1,40(sp)
    80003c8a:	f04a                	sd	s2,32(sp)
    80003c8c:	ec4e                	sd	s3,24(sp)
    80003c8e:	e852                	sd	s4,16(sp)
    80003c90:	e456                	sd	s5,8(sp)
    80003c92:	0080                	addi	s0,sp,64
    80003c94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c96:	00019517          	auipc	a0,0x19
    80003c9a:	22250513          	addi	a0,a0,546 # 8001ceb8 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	a18080e7          	jalr	-1512(ra) # 800066b6 <acquire>
  if(f->ref < 1)
    80003ca6:	40dc                	lw	a5,4(s1)
    80003ca8:	06f05163          	blez	a5,80003d0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cac:	37fd                	addiw	a5,a5,-1
    80003cae:	0007871b          	sext.w	a4,a5
    80003cb2:	c0dc                	sw	a5,4(s1)
    80003cb4:	06e04363          	bgtz	a4,80003d1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cb8:	0004a903          	lw	s2,0(s1)
    80003cbc:	0094ca83          	lbu	s5,9(s1)
    80003cc0:	0104ba03          	ld	s4,16(s1)
    80003cc4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cc8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ccc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cd0:	00019517          	auipc	a0,0x19
    80003cd4:	1e850513          	addi	a0,a0,488 # 8001ceb8 <ftable>
    80003cd8:	00003097          	auipc	ra,0x3
    80003cdc:	aae080e7          	jalr	-1362(ra) # 80006786 <release>

  if(ff.type == FD_PIPE){
    80003ce0:	4785                	li	a5,1
    80003ce2:	04f90d63          	beq	s2,a5,80003d3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ce6:	3979                	addiw	s2,s2,-2
    80003ce8:	4785                	li	a5,1
    80003cea:	0527e063          	bltu	a5,s2,80003d2a <fileclose+0xa8>
    begin_op();
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	acc080e7          	jalr	-1332(ra) # 800037ba <begin_op>
    iput(ff.ip);
    80003cf6:	854e                	mv	a0,s3
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	2a0080e7          	jalr	672(ra) # 80002f98 <iput>
    end_op();
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	b38080e7          	jalr	-1224(ra) # 80003838 <end_op>
    80003d08:	a00d                	j	80003d2a <fileclose+0xa8>
    panic("fileclose");
    80003d0a:	00005517          	auipc	a0,0x5
    80003d0e:	91650513          	addi	a0,a0,-1770 # 80008620 <syscalls+0x258>
    80003d12:	00002097          	auipc	ra,0x2
    80003d16:	482080e7          	jalr	1154(ra) # 80006194 <panic>
    release(&ftable.lock);
    80003d1a:	00019517          	auipc	a0,0x19
    80003d1e:	19e50513          	addi	a0,a0,414 # 8001ceb8 <ftable>
    80003d22:	00003097          	auipc	ra,0x3
    80003d26:	a64080e7          	jalr	-1436(ra) # 80006786 <release>
  }
}
    80003d2a:	70e2                	ld	ra,56(sp)
    80003d2c:	7442                	ld	s0,48(sp)
    80003d2e:	74a2                	ld	s1,40(sp)
    80003d30:	7902                	ld	s2,32(sp)
    80003d32:	69e2                	ld	s3,24(sp)
    80003d34:	6a42                	ld	s4,16(sp)
    80003d36:	6aa2                	ld	s5,8(sp)
    80003d38:	6121                	addi	sp,sp,64
    80003d3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d3c:	85d6                	mv	a1,s5
    80003d3e:	8552                	mv	a0,s4
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	34c080e7          	jalr	844(ra) # 8000408c <pipeclose>
    80003d48:	b7cd                	j	80003d2a <fileclose+0xa8>

0000000080003d4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d4a:	715d                	addi	sp,sp,-80
    80003d4c:	e486                	sd	ra,72(sp)
    80003d4e:	e0a2                	sd	s0,64(sp)
    80003d50:	fc26                	sd	s1,56(sp)
    80003d52:	f84a                	sd	s2,48(sp)
    80003d54:	f44e                	sd	s3,40(sp)
    80003d56:	0880                	addi	s0,sp,80
    80003d58:	84aa                	mv	s1,a0
    80003d5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d5c:	ffffd097          	auipc	ra,0xffffd
    80003d60:	1fa080e7          	jalr	506(ra) # 80000f56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d64:	409c                	lw	a5,0(s1)
    80003d66:	37f9                	addiw	a5,a5,-2
    80003d68:	4705                	li	a4,1
    80003d6a:	04f76763          	bltu	a4,a5,80003db8 <filestat+0x6e>
    80003d6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d70:	6c88                	ld	a0,24(s1)
    80003d72:	fffff097          	auipc	ra,0xfffff
    80003d76:	06c080e7          	jalr	108(ra) # 80002dde <ilock>
    stati(f->ip, &st);
    80003d7a:	fb840593          	addi	a1,s0,-72
    80003d7e:	6c88                	ld	a0,24(s1)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	2e8080e7          	jalr	744(ra) # 80003068 <stati>
    iunlock(f->ip);
    80003d88:	6c88                	ld	a0,24(s1)
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	116080e7          	jalr	278(ra) # 80002ea0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d92:	46e1                	li	a3,24
    80003d94:	fb840613          	addi	a2,s0,-72
    80003d98:	85ce                	mv	a1,s3
    80003d9a:	05893503          	ld	a0,88(s2)
    80003d9e:	ffffd097          	auipc	ra,0xffffd
    80003da2:	e7c080e7          	jalr	-388(ra) # 80000c1a <copyout>
    80003da6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003daa:	60a6                	ld	ra,72(sp)
    80003dac:	6406                	ld	s0,64(sp)
    80003dae:	74e2                	ld	s1,56(sp)
    80003db0:	7942                	ld	s2,48(sp)
    80003db2:	79a2                	ld	s3,40(sp)
    80003db4:	6161                	addi	sp,sp,80
    80003db6:	8082                	ret
  return -1;
    80003db8:	557d                	li	a0,-1
    80003dba:	bfc5                	j	80003daa <filestat+0x60>

0000000080003dbc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dbc:	7179                	addi	sp,sp,-48
    80003dbe:	f406                	sd	ra,40(sp)
    80003dc0:	f022                	sd	s0,32(sp)
    80003dc2:	ec26                	sd	s1,24(sp)
    80003dc4:	e84a                	sd	s2,16(sp)
    80003dc6:	e44e                	sd	s3,8(sp)
    80003dc8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dca:	00854783          	lbu	a5,8(a0)
    80003dce:	c3d5                	beqz	a5,80003e72 <fileread+0xb6>
    80003dd0:	84aa                	mv	s1,a0
    80003dd2:	89ae                	mv	s3,a1
    80003dd4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd6:	411c                	lw	a5,0(a0)
    80003dd8:	4705                	li	a4,1
    80003dda:	04e78963          	beq	a5,a4,80003e2c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dde:	470d                	li	a4,3
    80003de0:	04e78d63          	beq	a5,a4,80003e3a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de4:	4709                	li	a4,2
    80003de6:	06e79e63          	bne	a5,a4,80003e62 <fileread+0xa6>
    ilock(f->ip);
    80003dea:	6d08                	ld	a0,24(a0)
    80003dec:	fffff097          	auipc	ra,0xfffff
    80003df0:	ff2080e7          	jalr	-14(ra) # 80002dde <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003df4:	874a                	mv	a4,s2
    80003df6:	5094                	lw	a3,32(s1)
    80003df8:	864e                	mv	a2,s3
    80003dfa:	4585                	li	a1,1
    80003dfc:	6c88                	ld	a0,24(s1)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	294080e7          	jalr	660(ra) # 80003092 <readi>
    80003e06:	892a                	mv	s2,a0
    80003e08:	00a05563          	blez	a0,80003e12 <fileread+0x56>
      f->off += r;
    80003e0c:	509c                	lw	a5,32(s1)
    80003e0e:	9fa9                	addw	a5,a5,a0
    80003e10:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e12:	6c88                	ld	a0,24(s1)
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	08c080e7          	jalr	140(ra) # 80002ea0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e1c:	854a                	mv	a0,s2
    80003e1e:	70a2                	ld	ra,40(sp)
    80003e20:	7402                	ld	s0,32(sp)
    80003e22:	64e2                	ld	s1,24(sp)
    80003e24:	6942                	ld	s2,16(sp)
    80003e26:	69a2                	ld	s3,8(sp)
    80003e28:	6145                	addi	sp,sp,48
    80003e2a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e2c:	6908                	ld	a0,16(a0)
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	3ca080e7          	jalr	970(ra) # 800041f8 <piperead>
    80003e36:	892a                	mv	s2,a0
    80003e38:	b7d5                	j	80003e1c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e3a:	02451783          	lh	a5,36(a0)
    80003e3e:	03079693          	slli	a3,a5,0x30
    80003e42:	92c1                	srli	a3,a3,0x30
    80003e44:	4725                	li	a4,9
    80003e46:	02d76863          	bltu	a4,a3,80003e76 <fileread+0xba>
    80003e4a:	0792                	slli	a5,a5,0x4
    80003e4c:	00019717          	auipc	a4,0x19
    80003e50:	fcc70713          	addi	a4,a4,-52 # 8001ce18 <devsw>
    80003e54:	97ba                	add	a5,a5,a4
    80003e56:	639c                	ld	a5,0(a5)
    80003e58:	c38d                	beqz	a5,80003e7a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e5a:	4505                	li	a0,1
    80003e5c:	9782                	jalr	a5
    80003e5e:	892a                	mv	s2,a0
    80003e60:	bf75                	j	80003e1c <fileread+0x60>
    panic("fileread");
    80003e62:	00004517          	auipc	a0,0x4
    80003e66:	7ce50513          	addi	a0,a0,1998 # 80008630 <syscalls+0x268>
    80003e6a:	00002097          	auipc	ra,0x2
    80003e6e:	32a080e7          	jalr	810(ra) # 80006194 <panic>
    return -1;
    80003e72:	597d                	li	s2,-1
    80003e74:	b765                	j	80003e1c <fileread+0x60>
      return -1;
    80003e76:	597d                	li	s2,-1
    80003e78:	b755                	j	80003e1c <fileread+0x60>
    80003e7a:	597d                	li	s2,-1
    80003e7c:	b745                	j	80003e1c <fileread+0x60>

0000000080003e7e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e7e:	715d                	addi	sp,sp,-80
    80003e80:	e486                	sd	ra,72(sp)
    80003e82:	e0a2                	sd	s0,64(sp)
    80003e84:	fc26                	sd	s1,56(sp)
    80003e86:	f84a                	sd	s2,48(sp)
    80003e88:	f44e                	sd	s3,40(sp)
    80003e8a:	f052                	sd	s4,32(sp)
    80003e8c:	ec56                	sd	s5,24(sp)
    80003e8e:	e85a                	sd	s6,16(sp)
    80003e90:	e45e                	sd	s7,8(sp)
    80003e92:	e062                	sd	s8,0(sp)
    80003e94:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e96:	00954783          	lbu	a5,9(a0)
    80003e9a:	10078663          	beqz	a5,80003fa6 <filewrite+0x128>
    80003e9e:	892a                	mv	s2,a0
    80003ea0:	8b2e                	mv	s6,a1
    80003ea2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ea4:	411c                	lw	a5,0(a0)
    80003ea6:	4705                	li	a4,1
    80003ea8:	02e78263          	beq	a5,a4,80003ecc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eac:	470d                	li	a4,3
    80003eae:	02e78663          	beq	a5,a4,80003eda <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eb2:	4709                	li	a4,2
    80003eb4:	0ee79163          	bne	a5,a4,80003f96 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003eb8:	0ac05d63          	blez	a2,80003f72 <filewrite+0xf4>
    int i = 0;
    80003ebc:	4981                	li	s3,0
    80003ebe:	6b85                	lui	s7,0x1
    80003ec0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ec4:	6c05                	lui	s8,0x1
    80003ec6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003eca:	a861                	j	80003f62 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ecc:	6908                	ld	a0,16(a0)
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	238080e7          	jalr	568(ra) # 80004106 <pipewrite>
    80003ed6:	8a2a                	mv	s4,a0
    80003ed8:	a045                	j	80003f78 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003eda:	02451783          	lh	a5,36(a0)
    80003ede:	03079693          	slli	a3,a5,0x30
    80003ee2:	92c1                	srli	a3,a3,0x30
    80003ee4:	4725                	li	a4,9
    80003ee6:	0cd76263          	bltu	a4,a3,80003faa <filewrite+0x12c>
    80003eea:	0792                	slli	a5,a5,0x4
    80003eec:	00019717          	auipc	a4,0x19
    80003ef0:	f2c70713          	addi	a4,a4,-212 # 8001ce18 <devsw>
    80003ef4:	97ba                	add	a5,a5,a4
    80003ef6:	679c                	ld	a5,8(a5)
    80003ef8:	cbdd                	beqz	a5,80003fae <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003efa:	4505                	li	a0,1
    80003efc:	9782                	jalr	a5
    80003efe:	8a2a                	mv	s4,a0
    80003f00:	a8a5                	j	80003f78 <filewrite+0xfa>
    80003f02:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f06:	00000097          	auipc	ra,0x0
    80003f0a:	8b4080e7          	jalr	-1868(ra) # 800037ba <begin_op>
      ilock(f->ip);
    80003f0e:	01893503          	ld	a0,24(s2)
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	ecc080e7          	jalr	-308(ra) # 80002dde <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f1a:	8756                	mv	a4,s5
    80003f1c:	02092683          	lw	a3,32(s2)
    80003f20:	01698633          	add	a2,s3,s6
    80003f24:	4585                	li	a1,1
    80003f26:	01893503          	ld	a0,24(s2)
    80003f2a:	fffff097          	auipc	ra,0xfffff
    80003f2e:	260080e7          	jalr	608(ra) # 8000318a <writei>
    80003f32:	84aa                	mv	s1,a0
    80003f34:	00a05763          	blez	a0,80003f42 <filewrite+0xc4>
        f->off += r;
    80003f38:	02092783          	lw	a5,32(s2)
    80003f3c:	9fa9                	addw	a5,a5,a0
    80003f3e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f42:	01893503          	ld	a0,24(s2)
    80003f46:	fffff097          	auipc	ra,0xfffff
    80003f4a:	f5a080e7          	jalr	-166(ra) # 80002ea0 <iunlock>
      end_op();
    80003f4e:	00000097          	auipc	ra,0x0
    80003f52:	8ea080e7          	jalr	-1814(ra) # 80003838 <end_op>

      if(r != n1){
    80003f56:	009a9f63          	bne	s5,s1,80003f74 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f5a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f5e:	0149db63          	bge	s3,s4,80003f74 <filewrite+0xf6>
      int n1 = n - i;
    80003f62:	413a04bb          	subw	s1,s4,s3
    80003f66:	0004879b          	sext.w	a5,s1
    80003f6a:	f8fbdce3          	bge	s7,a5,80003f02 <filewrite+0x84>
    80003f6e:	84e2                	mv	s1,s8
    80003f70:	bf49                	j	80003f02 <filewrite+0x84>
    int i = 0;
    80003f72:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f74:	013a1f63          	bne	s4,s3,80003f92 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f78:	8552                	mv	a0,s4
    80003f7a:	60a6                	ld	ra,72(sp)
    80003f7c:	6406                	ld	s0,64(sp)
    80003f7e:	74e2                	ld	s1,56(sp)
    80003f80:	7942                	ld	s2,48(sp)
    80003f82:	79a2                	ld	s3,40(sp)
    80003f84:	7a02                	ld	s4,32(sp)
    80003f86:	6ae2                	ld	s5,24(sp)
    80003f88:	6b42                	ld	s6,16(sp)
    80003f8a:	6ba2                	ld	s7,8(sp)
    80003f8c:	6c02                	ld	s8,0(sp)
    80003f8e:	6161                	addi	sp,sp,80
    80003f90:	8082                	ret
    ret = (i == n ? n : -1);
    80003f92:	5a7d                	li	s4,-1
    80003f94:	b7d5                	j	80003f78 <filewrite+0xfa>
    panic("filewrite");
    80003f96:	00004517          	auipc	a0,0x4
    80003f9a:	6aa50513          	addi	a0,a0,1706 # 80008640 <syscalls+0x278>
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	1f6080e7          	jalr	502(ra) # 80006194 <panic>
    return -1;
    80003fa6:	5a7d                	li	s4,-1
    80003fa8:	bfc1                	j	80003f78 <filewrite+0xfa>
      return -1;
    80003faa:	5a7d                	li	s4,-1
    80003fac:	b7f1                	j	80003f78 <filewrite+0xfa>
    80003fae:	5a7d                	li	s4,-1
    80003fb0:	b7e1                	j	80003f78 <filewrite+0xfa>

0000000080003fb2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb2:	7179                	addi	sp,sp,-48
    80003fb4:	f406                	sd	ra,40(sp)
    80003fb6:	f022                	sd	s0,32(sp)
    80003fb8:	ec26                	sd	s1,24(sp)
    80003fba:	e84a                	sd	s2,16(sp)
    80003fbc:	e44e                	sd	s3,8(sp)
    80003fbe:	e052                	sd	s4,0(sp)
    80003fc0:	1800                	addi	s0,sp,48
    80003fc2:	84aa                	mv	s1,a0
    80003fc4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fc6:	0005b023          	sd	zero,0(a1)
    80003fca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	bf8080e7          	jalr	-1032(ra) # 80003bc6 <filealloc>
    80003fd6:	e088                	sd	a0,0(s1)
    80003fd8:	c551                	beqz	a0,80004064 <pipealloc+0xb2>
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	bec080e7          	jalr	-1044(ra) # 80003bc6 <filealloc>
    80003fe2:	00aa3023          	sd	a0,0(s4)
    80003fe6:	c92d                	beqz	a0,80004058 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fe8:	ffffc097          	auipc	ra,0xffffc
    80003fec:	182080e7          	jalr	386(ra) # 8000016a <kalloc>
    80003ff0:	892a                	mv	s2,a0
    80003ff2:	c125                	beqz	a0,80004052 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ff4:	4985                	li	s3,1
    80003ff6:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003ffa:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003ffe:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004002:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80004006:	00004597          	auipc	a1,0x4
    8000400a:	64a58593          	addi	a1,a1,1610 # 80008650 <syscalls+0x288>
    8000400e:	00003097          	auipc	ra,0x3
    80004012:	824080e7          	jalr	-2012(ra) # 80006832 <initlock>
  (*f0)->type = FD_PIPE;
    80004016:	609c                	ld	a5,0(s1)
    80004018:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000401c:	609c                	ld	a5,0(s1)
    8000401e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004022:	609c                	ld	a5,0(s1)
    80004024:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004028:	609c                	ld	a5,0(s1)
    8000402a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000402e:	000a3783          	ld	a5,0(s4)
    80004032:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004036:	000a3783          	ld	a5,0(s4)
    8000403a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000403e:	000a3783          	ld	a5,0(s4)
    80004042:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004046:	000a3783          	ld	a5,0(s4)
    8000404a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000404e:	4501                	li	a0,0
    80004050:	a025                	j	80004078 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004052:	6088                	ld	a0,0(s1)
    80004054:	e501                	bnez	a0,8000405c <pipealloc+0xaa>
    80004056:	a039                	j	80004064 <pipealloc+0xb2>
    80004058:	6088                	ld	a0,0(s1)
    8000405a:	c51d                	beqz	a0,80004088 <pipealloc+0xd6>
    fileclose(*f0);
    8000405c:	00000097          	auipc	ra,0x0
    80004060:	c26080e7          	jalr	-986(ra) # 80003c82 <fileclose>
  if(*f1)
    80004064:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004068:	557d                	li	a0,-1
  if(*f1)
    8000406a:	c799                	beqz	a5,80004078 <pipealloc+0xc6>
    fileclose(*f1);
    8000406c:	853e                	mv	a0,a5
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	c14080e7          	jalr	-1004(ra) # 80003c82 <fileclose>
  return -1;
    80004076:	557d                	li	a0,-1
}
    80004078:	70a2                	ld	ra,40(sp)
    8000407a:	7402                	ld	s0,32(sp)
    8000407c:	64e2                	ld	s1,24(sp)
    8000407e:	6942                	ld	s2,16(sp)
    80004080:	69a2                	ld	s3,8(sp)
    80004082:	6a02                	ld	s4,0(sp)
    80004084:	6145                	addi	sp,sp,48
    80004086:	8082                	ret
  return -1;
    80004088:	557d                	li	a0,-1
    8000408a:	b7fd                	j	80004078 <pipealloc+0xc6>

000000008000408c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000408c:	1101                	addi	sp,sp,-32
    8000408e:	ec06                	sd	ra,24(sp)
    80004090:	e822                	sd	s0,16(sp)
    80004092:	e426                	sd	s1,8(sp)
    80004094:	e04a                	sd	s2,0(sp)
    80004096:	1000                	addi	s0,sp,32
    80004098:	84aa                	mv	s1,a0
    8000409a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000409c:	00002097          	auipc	ra,0x2
    800040a0:	61a080e7          	jalr	1562(ra) # 800066b6 <acquire>
  if(writable){
    800040a4:	04090263          	beqz	s2,800040e8 <pipeclose+0x5c>
    pi->writeopen = 0;
    800040a8:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    800040ac:	22048513          	addi	a0,s1,544
    800040b0:	ffffd097          	auipc	ra,0xffffd
    800040b4:	6f6080e7          	jalr	1782(ra) # 800017a6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040b8:	2284b783          	ld	a5,552(s1)
    800040bc:	ef9d                	bnez	a5,800040fa <pipeclose+0x6e>
    release(&pi->lock);
    800040be:	8526                	mv	a0,s1
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	6c6080e7          	jalr	1734(ra) # 80006786 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    800040c8:	8526                	mv	a0,s1
    800040ca:	00002097          	auipc	ra,0x2
    800040ce:	704080e7          	jalr	1796(ra) # 800067ce <freelock>
#endif    
    kfree((char*)pi);
    800040d2:	8526                	mv	a0,s1
    800040d4:	ffffc097          	auipc	ra,0xffffc
    800040d8:	f48080e7          	jalr	-184(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040dc:	60e2                	ld	ra,24(sp)
    800040de:	6442                	ld	s0,16(sp)
    800040e0:	64a2                	ld	s1,8(sp)
    800040e2:	6902                	ld	s2,0(sp)
    800040e4:	6105                	addi	sp,sp,32
    800040e6:	8082                	ret
    pi->readopen = 0;
    800040e8:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800040ec:	22448513          	addi	a0,s1,548
    800040f0:	ffffd097          	auipc	ra,0xffffd
    800040f4:	6b6080e7          	jalr	1718(ra) # 800017a6 <wakeup>
    800040f8:	b7c1                	j	800040b8 <pipeclose+0x2c>
    release(&pi->lock);
    800040fa:	8526                	mv	a0,s1
    800040fc:	00002097          	auipc	ra,0x2
    80004100:	68a080e7          	jalr	1674(ra) # 80006786 <release>
}
    80004104:	bfe1                	j	800040dc <pipeclose+0x50>

0000000080004106 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004106:	711d                	addi	sp,sp,-96
    80004108:	ec86                	sd	ra,88(sp)
    8000410a:	e8a2                	sd	s0,80(sp)
    8000410c:	e4a6                	sd	s1,72(sp)
    8000410e:	e0ca                	sd	s2,64(sp)
    80004110:	fc4e                	sd	s3,56(sp)
    80004112:	f852                	sd	s4,48(sp)
    80004114:	f456                	sd	s5,40(sp)
    80004116:	f05a                	sd	s6,32(sp)
    80004118:	ec5e                	sd	s7,24(sp)
    8000411a:	e862                	sd	s8,16(sp)
    8000411c:	1080                	addi	s0,sp,96
    8000411e:	84aa                	mv	s1,a0
    80004120:	8aae                	mv	s5,a1
    80004122:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	e32080e7          	jalr	-462(ra) # 80000f56 <myproc>
    8000412c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000412e:	8526                	mv	a0,s1
    80004130:	00002097          	auipc	ra,0x2
    80004134:	586080e7          	jalr	1414(ra) # 800066b6 <acquire>
  while(i < n){
    80004138:	0b405363          	blez	s4,800041de <pipewrite+0xd8>
  int i = 0;
    8000413c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004140:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004144:	22448b93          	addi	s7,s1,548
    80004148:	a089                	j	8000418a <pipewrite+0x84>
      release(&pi->lock);
    8000414a:	8526                	mv	a0,s1
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	63a080e7          	jalr	1594(ra) # 80006786 <release>
      return -1;
    80004154:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004156:	854a                	mv	a0,s2
    80004158:	60e6                	ld	ra,88(sp)
    8000415a:	6446                	ld	s0,80(sp)
    8000415c:	64a6                	ld	s1,72(sp)
    8000415e:	6906                	ld	s2,64(sp)
    80004160:	79e2                	ld	s3,56(sp)
    80004162:	7a42                	ld	s4,48(sp)
    80004164:	7aa2                	ld	s5,40(sp)
    80004166:	7b02                	ld	s6,32(sp)
    80004168:	6be2                	ld	s7,24(sp)
    8000416a:	6c42                	ld	s8,16(sp)
    8000416c:	6125                	addi	sp,sp,96
    8000416e:	8082                	ret
      wakeup(&pi->nread);
    80004170:	8562                	mv	a0,s8
    80004172:	ffffd097          	auipc	ra,0xffffd
    80004176:	634080e7          	jalr	1588(ra) # 800017a6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000417a:	85a6                	mv	a1,s1
    8000417c:	855e                	mv	a0,s7
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	49c080e7          	jalr	1180(ra) # 8000161a <sleep>
  while(i < n){
    80004186:	05495d63          	bge	s2,s4,800041e0 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    8000418a:	2284a783          	lw	a5,552(s1)
    8000418e:	dfd5                	beqz	a5,8000414a <pipewrite+0x44>
    80004190:	0309a783          	lw	a5,48(s3)
    80004194:	fbdd                	bnez	a5,8000414a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004196:	2204a783          	lw	a5,544(s1)
    8000419a:	2244a703          	lw	a4,548(s1)
    8000419e:	2007879b          	addiw	a5,a5,512
    800041a2:	fcf707e3          	beq	a4,a5,80004170 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041a6:	4685                	li	a3,1
    800041a8:	01590633          	add	a2,s2,s5
    800041ac:	faf40593          	addi	a1,s0,-81
    800041b0:	0589b503          	ld	a0,88(s3)
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	af2080e7          	jalr	-1294(ra) # 80000ca6 <copyin>
    800041bc:	03650263          	beq	a0,s6,800041e0 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041c0:	2244a783          	lw	a5,548(s1)
    800041c4:	0017871b          	addiw	a4,a5,1
    800041c8:	22e4a223          	sw	a4,548(s1)
    800041cc:	1ff7f793          	andi	a5,a5,511
    800041d0:	97a6                	add	a5,a5,s1
    800041d2:	faf44703          	lbu	a4,-81(s0)
    800041d6:	02e78023          	sb	a4,32(a5)
      i++;
    800041da:	2905                	addiw	s2,s2,1
    800041dc:	b76d                	j	80004186 <pipewrite+0x80>
  int i = 0;
    800041de:	4901                	li	s2,0
  wakeup(&pi->nread);
    800041e0:	22048513          	addi	a0,s1,544
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	5c2080e7          	jalr	1474(ra) # 800017a6 <wakeup>
  release(&pi->lock);
    800041ec:	8526                	mv	a0,s1
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	598080e7          	jalr	1432(ra) # 80006786 <release>
  return i;
    800041f6:	b785                	j	80004156 <pipewrite+0x50>

00000000800041f8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041f8:	715d                	addi	sp,sp,-80
    800041fa:	e486                	sd	ra,72(sp)
    800041fc:	e0a2                	sd	s0,64(sp)
    800041fe:	fc26                	sd	s1,56(sp)
    80004200:	f84a                	sd	s2,48(sp)
    80004202:	f44e                	sd	s3,40(sp)
    80004204:	f052                	sd	s4,32(sp)
    80004206:	ec56                	sd	s5,24(sp)
    80004208:	e85a                	sd	s6,16(sp)
    8000420a:	0880                	addi	s0,sp,80
    8000420c:	84aa                	mv	s1,a0
    8000420e:	892e                	mv	s2,a1
    80004210:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	d44080e7          	jalr	-700(ra) # 80000f56 <myproc>
    8000421a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000421c:	8526                	mv	a0,s1
    8000421e:	00002097          	auipc	ra,0x2
    80004222:	498080e7          	jalr	1176(ra) # 800066b6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004226:	2204a703          	lw	a4,544(s1)
    8000422a:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000422e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004232:	02f71463          	bne	a4,a5,8000425a <piperead+0x62>
    80004236:	22c4a783          	lw	a5,556(s1)
    8000423a:	c385                	beqz	a5,8000425a <piperead+0x62>
    if(pr->killed){
    8000423c:	030a2783          	lw	a5,48(s4)
    80004240:	ebc9                	bnez	a5,800042d2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004242:	85a6                	mv	a1,s1
    80004244:	854e                	mv	a0,s3
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	3d4080e7          	jalr	980(ra) # 8000161a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000424e:	2204a703          	lw	a4,544(s1)
    80004252:	2244a783          	lw	a5,548(s1)
    80004256:	fef700e3          	beq	a4,a5,80004236 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000425a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000425c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000425e:	05505463          	blez	s5,800042a6 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004262:	2204a783          	lw	a5,544(s1)
    80004266:	2244a703          	lw	a4,548(s1)
    8000426a:	02f70e63          	beq	a4,a5,800042a6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000426e:	0017871b          	addiw	a4,a5,1
    80004272:	22e4a023          	sw	a4,544(s1)
    80004276:	1ff7f793          	andi	a5,a5,511
    8000427a:	97a6                	add	a5,a5,s1
    8000427c:	0207c783          	lbu	a5,32(a5)
    80004280:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004284:	4685                	li	a3,1
    80004286:	fbf40613          	addi	a2,s0,-65
    8000428a:	85ca                	mv	a1,s2
    8000428c:	058a3503          	ld	a0,88(s4)
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	98a080e7          	jalr	-1654(ra) # 80000c1a <copyout>
    80004298:	01650763          	beq	a0,s6,800042a6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000429c:	2985                	addiw	s3,s3,1
    8000429e:	0905                	addi	s2,s2,1
    800042a0:	fd3a91e3          	bne	s5,s3,80004262 <piperead+0x6a>
    800042a4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042a6:	22448513          	addi	a0,s1,548
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	4fc080e7          	jalr	1276(ra) # 800017a6 <wakeup>
  release(&pi->lock);
    800042b2:	8526                	mv	a0,s1
    800042b4:	00002097          	auipc	ra,0x2
    800042b8:	4d2080e7          	jalr	1234(ra) # 80006786 <release>
  return i;
}
    800042bc:	854e                	mv	a0,s3
    800042be:	60a6                	ld	ra,72(sp)
    800042c0:	6406                	ld	s0,64(sp)
    800042c2:	74e2                	ld	s1,56(sp)
    800042c4:	7942                	ld	s2,48(sp)
    800042c6:	79a2                	ld	s3,40(sp)
    800042c8:	7a02                	ld	s4,32(sp)
    800042ca:	6ae2                	ld	s5,24(sp)
    800042cc:	6b42                	ld	s6,16(sp)
    800042ce:	6161                	addi	sp,sp,80
    800042d0:	8082                	ret
      release(&pi->lock);
    800042d2:	8526                	mv	a0,s1
    800042d4:	00002097          	auipc	ra,0x2
    800042d8:	4b2080e7          	jalr	1202(ra) # 80006786 <release>
      return -1;
    800042dc:	59fd                	li	s3,-1
    800042de:	bff9                	j	800042bc <piperead+0xc4>

00000000800042e0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042e0:	de010113          	addi	sp,sp,-544
    800042e4:	20113c23          	sd	ra,536(sp)
    800042e8:	20813823          	sd	s0,528(sp)
    800042ec:	20913423          	sd	s1,520(sp)
    800042f0:	21213023          	sd	s2,512(sp)
    800042f4:	ffce                	sd	s3,504(sp)
    800042f6:	fbd2                	sd	s4,496(sp)
    800042f8:	f7d6                	sd	s5,488(sp)
    800042fa:	f3da                	sd	s6,480(sp)
    800042fc:	efde                	sd	s7,472(sp)
    800042fe:	ebe2                	sd	s8,464(sp)
    80004300:	e7e6                	sd	s9,456(sp)
    80004302:	e3ea                	sd	s10,448(sp)
    80004304:	ff6e                	sd	s11,440(sp)
    80004306:	1400                	addi	s0,sp,544
    80004308:	892a                	mv	s2,a0
    8000430a:	dea43423          	sd	a0,-536(s0)
    8000430e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	c44080e7          	jalr	-956(ra) # 80000f56 <myproc>
    8000431a:	84aa                	mv	s1,a0

  begin_op();
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	49e080e7          	jalr	1182(ra) # 800037ba <begin_op>

  if((ip = namei(path)) == 0){
    80004324:	854a                	mv	a0,s2
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	274080e7          	jalr	628(ra) # 8000359a <namei>
    8000432e:	c93d                	beqz	a0,800043a4 <exec+0xc4>
    80004330:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004332:	fffff097          	auipc	ra,0xfffff
    80004336:	aac080e7          	jalr	-1364(ra) # 80002dde <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000433a:	04000713          	li	a4,64
    8000433e:	4681                	li	a3,0
    80004340:	e5040613          	addi	a2,s0,-432
    80004344:	4581                	li	a1,0
    80004346:	8556                	mv	a0,s5
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	d4a080e7          	jalr	-694(ra) # 80003092 <readi>
    80004350:	04000793          	li	a5,64
    80004354:	00f51a63          	bne	a0,a5,80004368 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004358:	e5042703          	lw	a4,-432(s0)
    8000435c:	464c47b7          	lui	a5,0x464c4
    80004360:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004364:	04f70663          	beq	a4,a5,800043b0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004368:	8556                	mv	a0,s5
    8000436a:	fffff097          	auipc	ra,0xfffff
    8000436e:	cd6080e7          	jalr	-810(ra) # 80003040 <iunlockput>
    end_op();
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	4c6080e7          	jalr	1222(ra) # 80003838 <end_op>
  }
  return -1;
    8000437a:	557d                	li	a0,-1
}
    8000437c:	21813083          	ld	ra,536(sp)
    80004380:	21013403          	ld	s0,528(sp)
    80004384:	20813483          	ld	s1,520(sp)
    80004388:	20013903          	ld	s2,512(sp)
    8000438c:	79fe                	ld	s3,504(sp)
    8000438e:	7a5e                	ld	s4,496(sp)
    80004390:	7abe                	ld	s5,488(sp)
    80004392:	7b1e                	ld	s6,480(sp)
    80004394:	6bfe                	ld	s7,472(sp)
    80004396:	6c5e                	ld	s8,464(sp)
    80004398:	6cbe                	ld	s9,456(sp)
    8000439a:	6d1e                	ld	s10,448(sp)
    8000439c:	7dfa                	ld	s11,440(sp)
    8000439e:	22010113          	addi	sp,sp,544
    800043a2:	8082                	ret
    end_op();
    800043a4:	fffff097          	auipc	ra,0xfffff
    800043a8:	494080e7          	jalr	1172(ra) # 80003838 <end_op>
    return -1;
    800043ac:	557d                	li	a0,-1
    800043ae:	b7f9                	j	8000437c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800043b0:	8526                	mv	a0,s1
    800043b2:	ffffd097          	auipc	ra,0xffffd
    800043b6:	c68080e7          	jalr	-920(ra) # 8000101a <proc_pagetable>
    800043ba:	8b2a                	mv	s6,a0
    800043bc:	d555                	beqz	a0,80004368 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043be:	e7042783          	lw	a5,-400(s0)
    800043c2:	e8845703          	lhu	a4,-376(s0)
    800043c6:	c735                	beqz	a4,80004432 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043c8:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ca:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800043ce:	6a05                	lui	s4,0x1
    800043d0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800043d4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800043d8:	6d85                	lui	s11,0x1
    800043da:	7d7d                	lui	s10,0xfffff
    800043dc:	ac1d                	j	80004612 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043de:	00004517          	auipc	a0,0x4
    800043e2:	27a50513          	addi	a0,a0,634 # 80008658 <syscalls+0x290>
    800043e6:	00002097          	auipc	ra,0x2
    800043ea:	dae080e7          	jalr	-594(ra) # 80006194 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043ee:	874a                	mv	a4,s2
    800043f0:	009c86bb          	addw	a3,s9,s1
    800043f4:	4581                	li	a1,0
    800043f6:	8556                	mv	a0,s5
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	c9a080e7          	jalr	-870(ra) # 80003092 <readi>
    80004400:	2501                	sext.w	a0,a0
    80004402:	1aa91863          	bne	s2,a0,800045b2 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004406:	009d84bb          	addw	s1,s11,s1
    8000440a:	013d09bb          	addw	s3,s10,s3
    8000440e:	1f74f263          	bgeu	s1,s7,800045f2 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004412:	02049593          	slli	a1,s1,0x20
    80004416:	9181                	srli	a1,a1,0x20
    80004418:	95e2                	add	a1,a1,s8
    8000441a:	855a                	mv	a0,s6
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	1f6080e7          	jalr	502(ra) # 80000612 <walkaddr>
    80004424:	862a                	mv	a2,a0
    if(pa == 0)
    80004426:	dd45                	beqz	a0,800043de <exec+0xfe>
      n = PGSIZE;
    80004428:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000442a:	fd49f2e3          	bgeu	s3,s4,800043ee <exec+0x10e>
      n = sz - i;
    8000442e:	894e                	mv	s2,s3
    80004430:	bf7d                	j	800043ee <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004432:	4481                	li	s1,0
  iunlockput(ip);
    80004434:	8556                	mv	a0,s5
    80004436:	fffff097          	auipc	ra,0xfffff
    8000443a:	c0a080e7          	jalr	-1014(ra) # 80003040 <iunlockput>
  end_op();
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	3fa080e7          	jalr	1018(ra) # 80003838 <end_op>
  p = myproc();
    80004446:	ffffd097          	auipc	ra,0xffffd
    8000444a:	b10080e7          	jalr	-1264(ra) # 80000f56 <myproc>
    8000444e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004450:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004454:	6785                	lui	a5,0x1
    80004456:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004458:	97a6                	add	a5,a5,s1
    8000445a:	777d                	lui	a4,0xfffff
    8000445c:	8ff9                	and	a5,a5,a4
    8000445e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004462:	6609                	lui	a2,0x2
    80004464:	963e                	add	a2,a2,a5
    80004466:	85be                	mv	a1,a5
    80004468:	855a                	mv	a0,s6
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	55c080e7          	jalr	1372(ra) # 800009c6 <uvmalloc>
    80004472:	8c2a                	mv	s8,a0
  ip = 0;
    80004474:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004476:	12050e63          	beqz	a0,800045b2 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000447a:	75f9                	lui	a1,0xffffe
    8000447c:	95aa                	add	a1,a1,a0
    8000447e:	855a                	mv	a0,s6
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	768080e7          	jalr	1896(ra) # 80000be8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004488:	7afd                	lui	s5,0xfffff
    8000448a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000448c:	df043783          	ld	a5,-528(s0)
    80004490:	6388                	ld	a0,0(a5)
    80004492:	c925                	beqz	a0,80004502 <exec+0x222>
    80004494:	e9040993          	addi	s3,s0,-368
    80004498:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000449c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000449e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	f58080e7          	jalr	-168(ra) # 800003f8 <strlen>
    800044a8:	0015079b          	addiw	a5,a0,1
    800044ac:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044b0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044b4:	13596363          	bltu	s2,s5,800045da <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044b8:	df043d83          	ld	s11,-528(s0)
    800044bc:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800044c0:	8552                	mv	a0,s4
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	f36080e7          	jalr	-202(ra) # 800003f8 <strlen>
    800044ca:	0015069b          	addiw	a3,a0,1
    800044ce:	8652                	mv	a2,s4
    800044d0:	85ca                	mv	a1,s2
    800044d2:	855a                	mv	a0,s6
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	746080e7          	jalr	1862(ra) # 80000c1a <copyout>
    800044dc:	10054363          	bltz	a0,800045e2 <exec+0x302>
    ustack[argc] = sp;
    800044e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044e4:	0485                	addi	s1,s1,1
    800044e6:	008d8793          	addi	a5,s11,8
    800044ea:	def43823          	sd	a5,-528(s0)
    800044ee:	008db503          	ld	a0,8(s11)
    800044f2:	c911                	beqz	a0,80004506 <exec+0x226>
    if(argc >= MAXARG)
    800044f4:	09a1                	addi	s3,s3,8
    800044f6:	fb3c95e3          	bne	s9,s3,800044a0 <exec+0x1c0>
  sz = sz1;
    800044fa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044fe:	4a81                	li	s5,0
    80004500:	a84d                	j	800045b2 <exec+0x2d2>
  sp = sz;
    80004502:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004504:	4481                	li	s1,0
  ustack[argc] = 0;
    80004506:	00349793          	slli	a5,s1,0x3
    8000450a:	f9078793          	addi	a5,a5,-112
    8000450e:	97a2                	add	a5,a5,s0
    80004510:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004514:	00148693          	addi	a3,s1,1
    80004518:	068e                	slli	a3,a3,0x3
    8000451a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000451e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004522:	01597663          	bgeu	s2,s5,8000452e <exec+0x24e>
  sz = sz1;
    80004526:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000452a:	4a81                	li	s5,0
    8000452c:	a059                	j	800045b2 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000452e:	e9040613          	addi	a2,s0,-368
    80004532:	85ca                	mv	a1,s2
    80004534:	855a                	mv	a0,s6
    80004536:	ffffc097          	auipc	ra,0xffffc
    8000453a:	6e4080e7          	jalr	1764(ra) # 80000c1a <copyout>
    8000453e:	0a054663          	bltz	a0,800045ea <exec+0x30a>
  p->trapframe->a1 = sp;
    80004542:	060bb783          	ld	a5,96(s7)
    80004546:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000454a:	de843783          	ld	a5,-536(s0)
    8000454e:	0007c703          	lbu	a4,0(a5)
    80004552:	cf11                	beqz	a4,8000456e <exec+0x28e>
    80004554:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004556:	02f00693          	li	a3,47
    8000455a:	a039                	j	80004568 <exec+0x288>
      last = s+1;
    8000455c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004560:	0785                	addi	a5,a5,1
    80004562:	fff7c703          	lbu	a4,-1(a5)
    80004566:	c701                	beqz	a4,8000456e <exec+0x28e>
    if(*s == '/')
    80004568:	fed71ce3          	bne	a4,a3,80004560 <exec+0x280>
    8000456c:	bfc5                	j	8000455c <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000456e:	4641                	li	a2,16
    80004570:	de843583          	ld	a1,-536(s0)
    80004574:	160b8513          	addi	a0,s7,352
    80004578:	ffffc097          	auipc	ra,0xffffc
    8000457c:	e4e080e7          	jalr	-434(ra) # 800003c6 <safestrcpy>
  oldpagetable = p->pagetable;
    80004580:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80004584:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80004588:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000458c:	060bb783          	ld	a5,96(s7)
    80004590:	e6843703          	ld	a4,-408(s0)
    80004594:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004596:	060bb783          	ld	a5,96(s7)
    8000459a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000459e:	85ea                	mv	a1,s10
    800045a0:	ffffd097          	auipc	ra,0xffffd
    800045a4:	b16080e7          	jalr	-1258(ra) # 800010b6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a8:	0004851b          	sext.w	a0,s1
    800045ac:	bbc1                	j	8000437c <exec+0x9c>
    800045ae:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800045b2:	df843583          	ld	a1,-520(s0)
    800045b6:	855a                	mv	a0,s6
    800045b8:	ffffd097          	auipc	ra,0xffffd
    800045bc:	afe080e7          	jalr	-1282(ra) # 800010b6 <proc_freepagetable>
  if(ip){
    800045c0:	da0a94e3          	bnez	s5,80004368 <exec+0x88>
  return -1;
    800045c4:	557d                	li	a0,-1
    800045c6:	bb5d                	j	8000437c <exec+0x9c>
    800045c8:	de943c23          	sd	s1,-520(s0)
    800045cc:	b7dd                	j	800045b2 <exec+0x2d2>
    800045ce:	de943c23          	sd	s1,-520(s0)
    800045d2:	b7c5                	j	800045b2 <exec+0x2d2>
    800045d4:	de943c23          	sd	s1,-520(s0)
    800045d8:	bfe9                	j	800045b2 <exec+0x2d2>
  sz = sz1;
    800045da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045de:	4a81                	li	s5,0
    800045e0:	bfc9                	j	800045b2 <exec+0x2d2>
  sz = sz1;
    800045e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045e6:	4a81                	li	s5,0
    800045e8:	b7e9                	j	800045b2 <exec+0x2d2>
  sz = sz1;
    800045ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045ee:	4a81                	li	s5,0
    800045f0:	b7c9                	j	800045b2 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045f2:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045f6:	e0843783          	ld	a5,-504(s0)
    800045fa:	0017869b          	addiw	a3,a5,1
    800045fe:	e0d43423          	sd	a3,-504(s0)
    80004602:	e0043783          	ld	a5,-512(s0)
    80004606:	0387879b          	addiw	a5,a5,56
    8000460a:	e8845703          	lhu	a4,-376(s0)
    8000460e:	e2e6d3e3          	bge	a3,a4,80004434 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004612:	2781                	sext.w	a5,a5
    80004614:	e0f43023          	sd	a5,-512(s0)
    80004618:	03800713          	li	a4,56
    8000461c:	86be                	mv	a3,a5
    8000461e:	e1840613          	addi	a2,s0,-488
    80004622:	4581                	li	a1,0
    80004624:	8556                	mv	a0,s5
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	a6c080e7          	jalr	-1428(ra) # 80003092 <readi>
    8000462e:	03800793          	li	a5,56
    80004632:	f6f51ee3          	bne	a0,a5,800045ae <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004636:	e1842783          	lw	a5,-488(s0)
    8000463a:	4705                	li	a4,1
    8000463c:	fae79de3          	bne	a5,a4,800045f6 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004640:	e4043603          	ld	a2,-448(s0)
    80004644:	e3843783          	ld	a5,-456(s0)
    80004648:	f8f660e3          	bltu	a2,a5,800045c8 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000464c:	e2843783          	ld	a5,-472(s0)
    80004650:	963e                	add	a2,a2,a5
    80004652:	f6f66ee3          	bltu	a2,a5,800045ce <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004656:	85a6                	mv	a1,s1
    80004658:	855a                	mv	a0,s6
    8000465a:	ffffc097          	auipc	ra,0xffffc
    8000465e:	36c080e7          	jalr	876(ra) # 800009c6 <uvmalloc>
    80004662:	dea43c23          	sd	a0,-520(s0)
    80004666:	d53d                	beqz	a0,800045d4 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004668:	e2843c03          	ld	s8,-472(s0)
    8000466c:	de043783          	ld	a5,-544(s0)
    80004670:	00fc77b3          	and	a5,s8,a5
    80004674:	ff9d                	bnez	a5,800045b2 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004676:	e2042c83          	lw	s9,-480(s0)
    8000467a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000467e:	f60b8ae3          	beqz	s7,800045f2 <exec+0x312>
    80004682:	89de                	mv	s3,s7
    80004684:	4481                	li	s1,0
    80004686:	b371                	j	80004412 <exec+0x132>

0000000080004688 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	ec26                	sd	s1,24(sp)
    80004690:	e84a                	sd	s2,16(sp)
    80004692:	1800                	addi	s0,sp,48
    80004694:	892e                	mv	s2,a1
    80004696:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004698:	fdc40593          	addi	a1,s0,-36
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	970080e7          	jalr	-1680(ra) # 8000200c <argint>
    800046a4:	04054063          	bltz	a0,800046e4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046a8:	fdc42703          	lw	a4,-36(s0)
    800046ac:	47bd                	li	a5,15
    800046ae:	02e7ed63          	bltu	a5,a4,800046e8 <argfd+0x60>
    800046b2:	ffffd097          	auipc	ra,0xffffd
    800046b6:	8a4080e7          	jalr	-1884(ra) # 80000f56 <myproc>
    800046ba:	fdc42703          	lw	a4,-36(s0)
    800046be:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd3dd2>
    800046c2:	078e                	slli	a5,a5,0x3
    800046c4:	953e                	add	a0,a0,a5
    800046c6:	651c                	ld	a5,8(a0)
    800046c8:	c395                	beqz	a5,800046ec <argfd+0x64>
    return -1;
  if(pfd)
    800046ca:	00090463          	beqz	s2,800046d2 <argfd+0x4a>
    *pfd = fd;
    800046ce:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046d2:	4501                	li	a0,0
  if(pf)
    800046d4:	c091                	beqz	s1,800046d8 <argfd+0x50>
    *pf = f;
    800046d6:	e09c                	sd	a5,0(s1)
}
    800046d8:	70a2                	ld	ra,40(sp)
    800046da:	7402                	ld	s0,32(sp)
    800046dc:	64e2                	ld	s1,24(sp)
    800046de:	6942                	ld	s2,16(sp)
    800046e0:	6145                	addi	sp,sp,48
    800046e2:	8082                	ret
    return -1;
    800046e4:	557d                	li	a0,-1
    800046e6:	bfcd                	j	800046d8 <argfd+0x50>
    return -1;
    800046e8:	557d                	li	a0,-1
    800046ea:	b7fd                	j	800046d8 <argfd+0x50>
    800046ec:	557d                	li	a0,-1
    800046ee:	b7ed                	j	800046d8 <argfd+0x50>

00000000800046f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046f0:	1101                	addi	sp,sp,-32
    800046f2:	ec06                	sd	ra,24(sp)
    800046f4:	e822                	sd	s0,16(sp)
    800046f6:	e426                	sd	s1,8(sp)
    800046f8:	1000                	addi	s0,sp,32
    800046fa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046fc:	ffffd097          	auipc	ra,0xffffd
    80004700:	85a080e7          	jalr	-1958(ra) # 80000f56 <myproc>
    80004704:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004706:	0d850793          	addi	a5,a0,216
    8000470a:	4501                	li	a0,0
    8000470c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000470e:	6398                	ld	a4,0(a5)
    80004710:	cb19                	beqz	a4,80004726 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004712:	2505                	addiw	a0,a0,1
    80004714:	07a1                	addi	a5,a5,8
    80004716:	fed51ce3          	bne	a0,a3,8000470e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000471a:	557d                	li	a0,-1
}
    8000471c:	60e2                	ld	ra,24(sp)
    8000471e:	6442                	ld	s0,16(sp)
    80004720:	64a2                	ld	s1,8(sp)
    80004722:	6105                	addi	sp,sp,32
    80004724:	8082                	ret
      p->ofile[fd] = f;
    80004726:	01a50793          	addi	a5,a0,26
    8000472a:	078e                	slli	a5,a5,0x3
    8000472c:	963e                	add	a2,a2,a5
    8000472e:	e604                	sd	s1,8(a2)
      return fd;
    80004730:	b7f5                	j	8000471c <fdalloc+0x2c>

0000000080004732 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004732:	715d                	addi	sp,sp,-80
    80004734:	e486                	sd	ra,72(sp)
    80004736:	e0a2                	sd	s0,64(sp)
    80004738:	fc26                	sd	s1,56(sp)
    8000473a:	f84a                	sd	s2,48(sp)
    8000473c:	f44e                	sd	s3,40(sp)
    8000473e:	f052                	sd	s4,32(sp)
    80004740:	ec56                	sd	s5,24(sp)
    80004742:	0880                	addi	s0,sp,80
    80004744:	89ae                	mv	s3,a1
    80004746:	8ab2                	mv	s5,a2
    80004748:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000474a:	fb040593          	addi	a1,s0,-80
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	e6a080e7          	jalr	-406(ra) # 800035b8 <nameiparent>
    80004756:	892a                	mv	s2,a0
    80004758:	12050e63          	beqz	a0,80004894 <create+0x162>
    return 0;

  ilock(dp);
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	682080e7          	jalr	1666(ra) # 80002dde <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004764:	4601                	li	a2,0
    80004766:	fb040593          	addi	a1,s0,-80
    8000476a:	854a                	mv	a0,s2
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	b56080e7          	jalr	-1194(ra) # 800032c2 <dirlookup>
    80004774:	84aa                	mv	s1,a0
    80004776:	c921                	beqz	a0,800047c6 <create+0x94>
    iunlockput(dp);
    80004778:	854a                	mv	a0,s2
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	8c6080e7          	jalr	-1850(ra) # 80003040 <iunlockput>
    ilock(ip);
    80004782:	8526                	mv	a0,s1
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	65a080e7          	jalr	1626(ra) # 80002dde <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000478c:	2981                	sext.w	s3,s3
    8000478e:	4789                	li	a5,2
    80004790:	02f99463          	bne	s3,a5,800047b8 <create+0x86>
    80004794:	04c4d783          	lhu	a5,76(s1)
    80004798:	37f9                	addiw	a5,a5,-2
    8000479a:	17c2                	slli	a5,a5,0x30
    8000479c:	93c1                	srli	a5,a5,0x30
    8000479e:	4705                	li	a4,1
    800047a0:	00f76c63          	bltu	a4,a5,800047b8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047a4:	8526                	mv	a0,s1
    800047a6:	60a6                	ld	ra,72(sp)
    800047a8:	6406                	ld	s0,64(sp)
    800047aa:	74e2                	ld	s1,56(sp)
    800047ac:	7942                	ld	s2,48(sp)
    800047ae:	79a2                	ld	s3,40(sp)
    800047b0:	7a02                	ld	s4,32(sp)
    800047b2:	6ae2                	ld	s5,24(sp)
    800047b4:	6161                	addi	sp,sp,80
    800047b6:	8082                	ret
    iunlockput(ip);
    800047b8:	8526                	mv	a0,s1
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	886080e7          	jalr	-1914(ra) # 80003040 <iunlockput>
    return 0;
    800047c2:	4481                	li	s1,0
    800047c4:	b7c5                	j	800047a4 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047c6:	85ce                	mv	a1,s3
    800047c8:	00092503          	lw	a0,0(s2)
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	478080e7          	jalr	1144(ra) # 80002c44 <ialloc>
    800047d4:	84aa                	mv	s1,a0
    800047d6:	c521                	beqz	a0,8000481e <create+0xec>
  ilock(ip);
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	606080e7          	jalr	1542(ra) # 80002dde <ilock>
  ip->major = major;
    800047e0:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800047e4:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800047e8:	4a05                	li	s4,1
    800047ea:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	522080e7          	jalr	1314(ra) # 80002d12 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047f8:	2981                	sext.w	s3,s3
    800047fa:	03498a63          	beq	s3,s4,8000482e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800047fe:	40d0                	lw	a2,4(s1)
    80004800:	fb040593          	addi	a1,s0,-80
    80004804:	854a                	mv	a0,s2
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	cd2080e7          	jalr	-814(ra) # 800034d8 <dirlink>
    8000480e:	06054b63          	bltz	a0,80004884 <create+0x152>
  iunlockput(dp);
    80004812:	854a                	mv	a0,s2
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	82c080e7          	jalr	-2004(ra) # 80003040 <iunlockput>
  return ip;
    8000481c:	b761                	j	800047a4 <create+0x72>
    panic("create: ialloc");
    8000481e:	00004517          	auipc	a0,0x4
    80004822:	e5a50513          	addi	a0,a0,-422 # 80008678 <syscalls+0x2b0>
    80004826:	00002097          	auipc	ra,0x2
    8000482a:	96e080e7          	jalr	-1682(ra) # 80006194 <panic>
    dp->nlink++;  // for ".."
    8000482e:	05295783          	lhu	a5,82(s2)
    80004832:	2785                	addiw	a5,a5,1
    80004834:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80004838:	854a                	mv	a0,s2
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	4d8080e7          	jalr	1240(ra) # 80002d12 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004842:	40d0                	lw	a2,4(s1)
    80004844:	00004597          	auipc	a1,0x4
    80004848:	e4458593          	addi	a1,a1,-444 # 80008688 <syscalls+0x2c0>
    8000484c:	8526                	mv	a0,s1
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	c8a080e7          	jalr	-886(ra) # 800034d8 <dirlink>
    80004856:	00054f63          	bltz	a0,80004874 <create+0x142>
    8000485a:	00492603          	lw	a2,4(s2)
    8000485e:	00004597          	auipc	a1,0x4
    80004862:	e3258593          	addi	a1,a1,-462 # 80008690 <syscalls+0x2c8>
    80004866:	8526                	mv	a0,s1
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	c70080e7          	jalr	-912(ra) # 800034d8 <dirlink>
    80004870:	f80557e3          	bgez	a0,800047fe <create+0xcc>
      panic("create dots");
    80004874:	00004517          	auipc	a0,0x4
    80004878:	e2450513          	addi	a0,a0,-476 # 80008698 <syscalls+0x2d0>
    8000487c:	00002097          	auipc	ra,0x2
    80004880:	918080e7          	jalr	-1768(ra) # 80006194 <panic>
    panic("create: dirlink");
    80004884:	00004517          	auipc	a0,0x4
    80004888:	e2450513          	addi	a0,a0,-476 # 800086a8 <syscalls+0x2e0>
    8000488c:	00002097          	auipc	ra,0x2
    80004890:	908080e7          	jalr	-1784(ra) # 80006194 <panic>
    return 0;
    80004894:	84aa                	mv	s1,a0
    80004896:	b739                	j	800047a4 <create+0x72>

0000000080004898 <sys_dup>:
{
    80004898:	7179                	addi	sp,sp,-48
    8000489a:	f406                	sd	ra,40(sp)
    8000489c:	f022                	sd	s0,32(sp)
    8000489e:	ec26                	sd	s1,24(sp)
    800048a0:	e84a                	sd	s2,16(sp)
    800048a2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048a4:	fd840613          	addi	a2,s0,-40
    800048a8:	4581                	li	a1,0
    800048aa:	4501                	li	a0,0
    800048ac:	00000097          	auipc	ra,0x0
    800048b0:	ddc080e7          	jalr	-548(ra) # 80004688 <argfd>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048b6:	02054363          	bltz	a0,800048dc <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800048ba:	fd843903          	ld	s2,-40(s0)
    800048be:	854a                	mv	a0,s2
    800048c0:	00000097          	auipc	ra,0x0
    800048c4:	e30080e7          	jalr	-464(ra) # 800046f0 <fdalloc>
    800048c8:	84aa                	mv	s1,a0
    return -1;
    800048ca:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048cc:	00054863          	bltz	a0,800048dc <sys_dup+0x44>
  filedup(f);
    800048d0:	854a                	mv	a0,s2
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	35e080e7          	jalr	862(ra) # 80003c30 <filedup>
  return fd;
    800048da:	87a6                	mv	a5,s1
}
    800048dc:	853e                	mv	a0,a5
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	64e2                	ld	s1,24(sp)
    800048e4:	6942                	ld	s2,16(sp)
    800048e6:	6145                	addi	sp,sp,48
    800048e8:	8082                	ret

00000000800048ea <sys_read>:
{
    800048ea:	7179                	addi	sp,sp,-48
    800048ec:	f406                	sd	ra,40(sp)
    800048ee:	f022                	sd	s0,32(sp)
    800048f0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f2:	fe840613          	addi	a2,s0,-24
    800048f6:	4581                	li	a1,0
    800048f8:	4501                	li	a0,0
    800048fa:	00000097          	auipc	ra,0x0
    800048fe:	d8e080e7          	jalr	-626(ra) # 80004688 <argfd>
    return -1;
    80004902:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004904:	04054163          	bltz	a0,80004946 <sys_read+0x5c>
    80004908:	fe440593          	addi	a1,s0,-28
    8000490c:	4509                	li	a0,2
    8000490e:	ffffd097          	auipc	ra,0xffffd
    80004912:	6fe080e7          	jalr	1790(ra) # 8000200c <argint>
    return -1;
    80004916:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004918:	02054763          	bltz	a0,80004946 <sys_read+0x5c>
    8000491c:	fd840593          	addi	a1,s0,-40
    80004920:	4505                	li	a0,1
    80004922:	ffffd097          	auipc	ra,0xffffd
    80004926:	70c080e7          	jalr	1804(ra) # 8000202e <argaddr>
    return -1;
    8000492a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492c:	00054d63          	bltz	a0,80004946 <sys_read+0x5c>
  return fileread(f, p, n);
    80004930:	fe442603          	lw	a2,-28(s0)
    80004934:	fd843583          	ld	a1,-40(s0)
    80004938:	fe843503          	ld	a0,-24(s0)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	480080e7          	jalr	1152(ra) # 80003dbc <fileread>
    80004944:	87aa                	mv	a5,a0
}
    80004946:	853e                	mv	a0,a5
    80004948:	70a2                	ld	ra,40(sp)
    8000494a:	7402                	ld	s0,32(sp)
    8000494c:	6145                	addi	sp,sp,48
    8000494e:	8082                	ret

0000000080004950 <sys_write>:
{
    80004950:	7179                	addi	sp,sp,-48
    80004952:	f406                	sd	ra,40(sp)
    80004954:	f022                	sd	s0,32(sp)
    80004956:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004958:	fe840613          	addi	a2,s0,-24
    8000495c:	4581                	li	a1,0
    8000495e:	4501                	li	a0,0
    80004960:	00000097          	auipc	ra,0x0
    80004964:	d28080e7          	jalr	-728(ra) # 80004688 <argfd>
    return -1;
    80004968:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496a:	04054163          	bltz	a0,800049ac <sys_write+0x5c>
    8000496e:	fe440593          	addi	a1,s0,-28
    80004972:	4509                	li	a0,2
    80004974:	ffffd097          	auipc	ra,0xffffd
    80004978:	698080e7          	jalr	1688(ra) # 8000200c <argint>
    return -1;
    8000497c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497e:	02054763          	bltz	a0,800049ac <sys_write+0x5c>
    80004982:	fd840593          	addi	a1,s0,-40
    80004986:	4505                	li	a0,1
    80004988:	ffffd097          	auipc	ra,0xffffd
    8000498c:	6a6080e7          	jalr	1702(ra) # 8000202e <argaddr>
    return -1;
    80004990:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004992:	00054d63          	bltz	a0,800049ac <sys_write+0x5c>
  return filewrite(f, p, n);
    80004996:	fe442603          	lw	a2,-28(s0)
    8000499a:	fd843583          	ld	a1,-40(s0)
    8000499e:	fe843503          	ld	a0,-24(s0)
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	4dc080e7          	jalr	1244(ra) # 80003e7e <filewrite>
    800049aa:	87aa                	mv	a5,a0
}
    800049ac:	853e                	mv	a0,a5
    800049ae:	70a2                	ld	ra,40(sp)
    800049b0:	7402                	ld	s0,32(sp)
    800049b2:	6145                	addi	sp,sp,48
    800049b4:	8082                	ret

00000000800049b6 <sys_close>:
{
    800049b6:	1101                	addi	sp,sp,-32
    800049b8:	ec06                	sd	ra,24(sp)
    800049ba:	e822                	sd	s0,16(sp)
    800049bc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049be:	fe040613          	addi	a2,s0,-32
    800049c2:	fec40593          	addi	a1,s0,-20
    800049c6:	4501                	li	a0,0
    800049c8:	00000097          	auipc	ra,0x0
    800049cc:	cc0080e7          	jalr	-832(ra) # 80004688 <argfd>
    return -1;
    800049d0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049d2:	02054463          	bltz	a0,800049fa <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049d6:	ffffc097          	auipc	ra,0xffffc
    800049da:	580080e7          	jalr	1408(ra) # 80000f56 <myproc>
    800049de:	fec42783          	lw	a5,-20(s0)
    800049e2:	07e9                	addi	a5,a5,26
    800049e4:	078e                	slli	a5,a5,0x3
    800049e6:	953e                	add	a0,a0,a5
    800049e8:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800049ec:	fe043503          	ld	a0,-32(s0)
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	292080e7          	jalr	658(ra) # 80003c82 <fileclose>
  return 0;
    800049f8:	4781                	li	a5,0
}
    800049fa:	853e                	mv	a0,a5
    800049fc:	60e2                	ld	ra,24(sp)
    800049fe:	6442                	ld	s0,16(sp)
    80004a00:	6105                	addi	sp,sp,32
    80004a02:	8082                	ret

0000000080004a04 <sys_fstat>:
{
    80004a04:	1101                	addi	sp,sp,-32
    80004a06:	ec06                	sd	ra,24(sp)
    80004a08:	e822                	sd	s0,16(sp)
    80004a0a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a0c:	fe840613          	addi	a2,s0,-24
    80004a10:	4581                	li	a1,0
    80004a12:	4501                	li	a0,0
    80004a14:	00000097          	auipc	ra,0x0
    80004a18:	c74080e7          	jalr	-908(ra) # 80004688 <argfd>
    return -1;
    80004a1c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a1e:	02054563          	bltz	a0,80004a48 <sys_fstat+0x44>
    80004a22:	fe040593          	addi	a1,s0,-32
    80004a26:	4505                	li	a0,1
    80004a28:	ffffd097          	auipc	ra,0xffffd
    80004a2c:	606080e7          	jalr	1542(ra) # 8000202e <argaddr>
    return -1;
    80004a30:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a32:	00054b63          	bltz	a0,80004a48 <sys_fstat+0x44>
  return filestat(f, st);
    80004a36:	fe043583          	ld	a1,-32(s0)
    80004a3a:	fe843503          	ld	a0,-24(s0)
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	30c080e7          	jalr	780(ra) # 80003d4a <filestat>
    80004a46:	87aa                	mv	a5,a0
}
    80004a48:	853e                	mv	a0,a5
    80004a4a:	60e2                	ld	ra,24(sp)
    80004a4c:	6442                	ld	s0,16(sp)
    80004a4e:	6105                	addi	sp,sp,32
    80004a50:	8082                	ret

0000000080004a52 <sys_link>:
{
    80004a52:	7169                	addi	sp,sp,-304
    80004a54:	f606                	sd	ra,296(sp)
    80004a56:	f222                	sd	s0,288(sp)
    80004a58:	ee26                	sd	s1,280(sp)
    80004a5a:	ea4a                	sd	s2,272(sp)
    80004a5c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a5e:	08000613          	li	a2,128
    80004a62:	ed040593          	addi	a1,s0,-304
    80004a66:	4501                	li	a0,0
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	5e8080e7          	jalr	1512(ra) # 80002050 <argstr>
    return -1;
    80004a70:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a72:	10054e63          	bltz	a0,80004b8e <sys_link+0x13c>
    80004a76:	08000613          	li	a2,128
    80004a7a:	f5040593          	addi	a1,s0,-176
    80004a7e:	4505                	li	a0,1
    80004a80:	ffffd097          	auipc	ra,0xffffd
    80004a84:	5d0080e7          	jalr	1488(ra) # 80002050 <argstr>
    return -1;
    80004a88:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a8a:	10054263          	bltz	a0,80004b8e <sys_link+0x13c>
  begin_op();
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	d2c080e7          	jalr	-724(ra) # 800037ba <begin_op>
  if((ip = namei(old)) == 0){
    80004a96:	ed040513          	addi	a0,s0,-304
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	b00080e7          	jalr	-1280(ra) # 8000359a <namei>
    80004aa2:	84aa                	mv	s1,a0
    80004aa4:	c551                	beqz	a0,80004b30 <sys_link+0xde>
  ilock(ip);
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	338080e7          	jalr	824(ra) # 80002dde <ilock>
  if(ip->type == T_DIR){
    80004aae:	04c49703          	lh	a4,76(s1)
    80004ab2:	4785                	li	a5,1
    80004ab4:	08f70463          	beq	a4,a5,80004b3c <sys_link+0xea>
  ip->nlink++;
    80004ab8:	0524d783          	lhu	a5,82(s1)
    80004abc:	2785                	addiw	a5,a5,1
    80004abe:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ac2:	8526                	mv	a0,s1
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	24e080e7          	jalr	590(ra) # 80002d12 <iupdate>
  iunlock(ip);
    80004acc:	8526                	mv	a0,s1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	3d2080e7          	jalr	978(ra) # 80002ea0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ad6:	fd040593          	addi	a1,s0,-48
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	ada080e7          	jalr	-1318(ra) # 800035b8 <nameiparent>
    80004ae6:	892a                	mv	s2,a0
    80004ae8:	c935                	beqz	a0,80004b5c <sys_link+0x10a>
  ilock(dp);
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	2f4080e7          	jalr	756(ra) # 80002dde <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004af2:	00092703          	lw	a4,0(s2)
    80004af6:	409c                	lw	a5,0(s1)
    80004af8:	04f71d63          	bne	a4,a5,80004b52 <sys_link+0x100>
    80004afc:	40d0                	lw	a2,4(s1)
    80004afe:	fd040593          	addi	a1,s0,-48
    80004b02:	854a                	mv	a0,s2
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	9d4080e7          	jalr	-1580(ra) # 800034d8 <dirlink>
    80004b0c:	04054363          	bltz	a0,80004b52 <sys_link+0x100>
  iunlockput(dp);
    80004b10:	854a                	mv	a0,s2
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	52e080e7          	jalr	1326(ra) # 80003040 <iunlockput>
  iput(ip);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	47c080e7          	jalr	1148(ra) # 80002f98 <iput>
  end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	d14080e7          	jalr	-748(ra) # 80003838 <end_op>
  return 0;
    80004b2c:	4781                	li	a5,0
    80004b2e:	a085                	j	80004b8e <sys_link+0x13c>
    end_op();
    80004b30:	fffff097          	auipc	ra,0xfffff
    80004b34:	d08080e7          	jalr	-760(ra) # 80003838 <end_op>
    return -1;
    80004b38:	57fd                	li	a5,-1
    80004b3a:	a891                	j	80004b8e <sys_link+0x13c>
    iunlockput(ip);
    80004b3c:	8526                	mv	a0,s1
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	502080e7          	jalr	1282(ra) # 80003040 <iunlockput>
    end_op();
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	cf2080e7          	jalr	-782(ra) # 80003838 <end_op>
    return -1;
    80004b4e:	57fd                	li	a5,-1
    80004b50:	a83d                	j	80004b8e <sys_link+0x13c>
    iunlockput(dp);
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	4ec080e7          	jalr	1260(ra) # 80003040 <iunlockput>
  ilock(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	280080e7          	jalr	640(ra) # 80002dde <ilock>
  ip->nlink--;
    80004b66:	0524d783          	lhu	a5,82(s1)
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	1a0080e7          	jalr	416(ra) # 80002d12 <iupdate>
  iunlockput(ip);
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	4c4080e7          	jalr	1220(ra) # 80003040 <iunlockput>
  end_op();
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	cb4080e7          	jalr	-844(ra) # 80003838 <end_op>
  return -1;
    80004b8c:	57fd                	li	a5,-1
}
    80004b8e:	853e                	mv	a0,a5
    80004b90:	70b2                	ld	ra,296(sp)
    80004b92:	7412                	ld	s0,288(sp)
    80004b94:	64f2                	ld	s1,280(sp)
    80004b96:	6952                	ld	s2,272(sp)
    80004b98:	6155                	addi	sp,sp,304
    80004b9a:	8082                	ret

0000000080004b9c <sys_unlink>:
{
    80004b9c:	7151                	addi	sp,sp,-240
    80004b9e:	f586                	sd	ra,232(sp)
    80004ba0:	f1a2                	sd	s0,224(sp)
    80004ba2:	eda6                	sd	s1,216(sp)
    80004ba4:	e9ca                	sd	s2,208(sp)
    80004ba6:	e5ce                	sd	s3,200(sp)
    80004ba8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004baa:	08000613          	li	a2,128
    80004bae:	f3040593          	addi	a1,s0,-208
    80004bb2:	4501                	li	a0,0
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	49c080e7          	jalr	1180(ra) # 80002050 <argstr>
    80004bbc:	18054163          	bltz	a0,80004d3e <sys_unlink+0x1a2>
  begin_op();
    80004bc0:	fffff097          	auipc	ra,0xfffff
    80004bc4:	bfa080e7          	jalr	-1030(ra) # 800037ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bc8:	fb040593          	addi	a1,s0,-80
    80004bcc:	f3040513          	addi	a0,s0,-208
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	9e8080e7          	jalr	-1560(ra) # 800035b8 <nameiparent>
    80004bd8:	84aa                	mv	s1,a0
    80004bda:	c979                	beqz	a0,80004cb0 <sys_unlink+0x114>
  ilock(dp);
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	202080e7          	jalr	514(ra) # 80002dde <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004be4:	00004597          	auipc	a1,0x4
    80004be8:	aa458593          	addi	a1,a1,-1372 # 80008688 <syscalls+0x2c0>
    80004bec:	fb040513          	addi	a0,s0,-80
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	6b8080e7          	jalr	1720(ra) # 800032a8 <namecmp>
    80004bf8:	14050a63          	beqz	a0,80004d4c <sys_unlink+0x1b0>
    80004bfc:	00004597          	auipc	a1,0x4
    80004c00:	a9458593          	addi	a1,a1,-1388 # 80008690 <syscalls+0x2c8>
    80004c04:	fb040513          	addi	a0,s0,-80
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	6a0080e7          	jalr	1696(ra) # 800032a8 <namecmp>
    80004c10:	12050e63          	beqz	a0,80004d4c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c14:	f2c40613          	addi	a2,s0,-212
    80004c18:	fb040593          	addi	a1,s0,-80
    80004c1c:	8526                	mv	a0,s1
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	6a4080e7          	jalr	1700(ra) # 800032c2 <dirlookup>
    80004c26:	892a                	mv	s2,a0
    80004c28:	12050263          	beqz	a0,80004d4c <sys_unlink+0x1b0>
  ilock(ip);
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	1b2080e7          	jalr	434(ra) # 80002dde <ilock>
  if(ip->nlink < 1)
    80004c34:	05291783          	lh	a5,82(s2)
    80004c38:	08f05263          	blez	a5,80004cbc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c3c:	04c91703          	lh	a4,76(s2)
    80004c40:	4785                	li	a5,1
    80004c42:	08f70563          	beq	a4,a5,80004ccc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c46:	4641                	li	a2,16
    80004c48:	4581                	li	a1,0
    80004c4a:	fc040513          	addi	a0,s0,-64
    80004c4e:	ffffb097          	auipc	ra,0xffffb
    80004c52:	62e080e7          	jalr	1582(ra) # 8000027c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c56:	4741                	li	a4,16
    80004c58:	f2c42683          	lw	a3,-212(s0)
    80004c5c:	fc040613          	addi	a2,s0,-64
    80004c60:	4581                	li	a1,0
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	526080e7          	jalr	1318(ra) # 8000318a <writei>
    80004c6c:	47c1                	li	a5,16
    80004c6e:	0af51563          	bne	a0,a5,80004d18 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c72:	04c91703          	lh	a4,76(s2)
    80004c76:	4785                	li	a5,1
    80004c78:	0af70863          	beq	a4,a5,80004d28 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	3c2080e7          	jalr	962(ra) # 80003040 <iunlockput>
  ip->nlink--;
    80004c86:	05295783          	lhu	a5,82(s2)
    80004c8a:	37fd                	addiw	a5,a5,-1
    80004c8c:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c90:	854a                	mv	a0,s2
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	080080e7          	jalr	128(ra) # 80002d12 <iupdate>
  iunlockput(ip);
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	3a4080e7          	jalr	932(ra) # 80003040 <iunlockput>
  end_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	b94080e7          	jalr	-1132(ra) # 80003838 <end_op>
  return 0;
    80004cac:	4501                	li	a0,0
    80004cae:	a84d                	j	80004d60 <sys_unlink+0x1c4>
    end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	b88080e7          	jalr	-1144(ra) # 80003838 <end_op>
    return -1;
    80004cb8:	557d                	li	a0,-1
    80004cba:	a05d                	j	80004d60 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cbc:	00004517          	auipc	a0,0x4
    80004cc0:	9fc50513          	addi	a0,a0,-1540 # 800086b8 <syscalls+0x2f0>
    80004cc4:	00001097          	auipc	ra,0x1
    80004cc8:	4d0080e7          	jalr	1232(ra) # 80006194 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ccc:	05492703          	lw	a4,84(s2)
    80004cd0:	02000793          	li	a5,32
    80004cd4:	f6e7f9e3          	bgeu	a5,a4,80004c46 <sys_unlink+0xaa>
    80004cd8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cdc:	4741                	li	a4,16
    80004cde:	86ce                	mv	a3,s3
    80004ce0:	f1840613          	addi	a2,s0,-232
    80004ce4:	4581                	li	a1,0
    80004ce6:	854a                	mv	a0,s2
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	3aa080e7          	jalr	938(ra) # 80003092 <readi>
    80004cf0:	47c1                	li	a5,16
    80004cf2:	00f51b63          	bne	a0,a5,80004d08 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cf6:	f1845783          	lhu	a5,-232(s0)
    80004cfa:	e7a1                	bnez	a5,80004d42 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cfc:	29c1                	addiw	s3,s3,16
    80004cfe:	05492783          	lw	a5,84(s2)
    80004d02:	fcf9ede3          	bltu	s3,a5,80004cdc <sys_unlink+0x140>
    80004d06:	b781                	j	80004c46 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d08:	00004517          	auipc	a0,0x4
    80004d0c:	9c850513          	addi	a0,a0,-1592 # 800086d0 <syscalls+0x308>
    80004d10:	00001097          	auipc	ra,0x1
    80004d14:	484080e7          	jalr	1156(ra) # 80006194 <panic>
    panic("unlink: writei");
    80004d18:	00004517          	auipc	a0,0x4
    80004d1c:	9d050513          	addi	a0,a0,-1584 # 800086e8 <syscalls+0x320>
    80004d20:	00001097          	auipc	ra,0x1
    80004d24:	474080e7          	jalr	1140(ra) # 80006194 <panic>
    dp->nlink--;
    80004d28:	0524d783          	lhu	a5,82(s1)
    80004d2c:	37fd                	addiw	a5,a5,-1
    80004d2e:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	fde080e7          	jalr	-34(ra) # 80002d12 <iupdate>
    80004d3c:	b781                	j	80004c7c <sys_unlink+0xe0>
    return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	a005                	j	80004d60 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d42:	854a                	mv	a0,s2
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	2fc080e7          	jalr	764(ra) # 80003040 <iunlockput>
  iunlockput(dp);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	2f2080e7          	jalr	754(ra) # 80003040 <iunlockput>
  end_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	ae2080e7          	jalr	-1310(ra) # 80003838 <end_op>
  return -1;
    80004d5e:	557d                	li	a0,-1
}
    80004d60:	70ae                	ld	ra,232(sp)
    80004d62:	740e                	ld	s0,224(sp)
    80004d64:	64ee                	ld	s1,216(sp)
    80004d66:	694e                	ld	s2,208(sp)
    80004d68:	69ae                	ld	s3,200(sp)
    80004d6a:	616d                	addi	sp,sp,240
    80004d6c:	8082                	ret

0000000080004d6e <sys_open>:

uint64
sys_open(void)
{
    80004d6e:	7131                	addi	sp,sp,-192
    80004d70:	fd06                	sd	ra,184(sp)
    80004d72:	f922                	sd	s0,176(sp)
    80004d74:	f526                	sd	s1,168(sp)
    80004d76:	f14a                	sd	s2,160(sp)
    80004d78:	ed4e                	sd	s3,152(sp)
    80004d7a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d7c:	08000613          	li	a2,128
    80004d80:	f5040593          	addi	a1,s0,-176
    80004d84:	4501                	li	a0,0
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	2ca080e7          	jalr	714(ra) # 80002050 <argstr>
    return -1;
    80004d8e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d90:	0c054163          	bltz	a0,80004e52 <sys_open+0xe4>
    80004d94:	f4c40593          	addi	a1,s0,-180
    80004d98:	4505                	li	a0,1
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	272080e7          	jalr	626(ra) # 8000200c <argint>
    80004da2:	0a054863          	bltz	a0,80004e52 <sys_open+0xe4>

  begin_op();
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	a14080e7          	jalr	-1516(ra) # 800037ba <begin_op>

  if(omode & O_CREATE){
    80004dae:	f4c42783          	lw	a5,-180(s0)
    80004db2:	2007f793          	andi	a5,a5,512
    80004db6:	cbdd                	beqz	a5,80004e6c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004db8:	4681                	li	a3,0
    80004dba:	4601                	li	a2,0
    80004dbc:	4589                	li	a1,2
    80004dbe:	f5040513          	addi	a0,s0,-176
    80004dc2:	00000097          	auipc	ra,0x0
    80004dc6:	970080e7          	jalr	-1680(ra) # 80004732 <create>
    80004dca:	892a                	mv	s2,a0
    if(ip == 0){
    80004dcc:	c959                	beqz	a0,80004e62 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dce:	04c91703          	lh	a4,76(s2)
    80004dd2:	478d                	li	a5,3
    80004dd4:	00f71763          	bne	a4,a5,80004de2 <sys_open+0x74>
    80004dd8:	04e95703          	lhu	a4,78(s2)
    80004ddc:	47a5                	li	a5,9
    80004dde:	0ce7ec63          	bltu	a5,a4,80004eb6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	de4080e7          	jalr	-540(ra) # 80003bc6 <filealloc>
    80004dea:	89aa                	mv	s3,a0
    80004dec:	10050263          	beqz	a0,80004ef0 <sys_open+0x182>
    80004df0:	00000097          	auipc	ra,0x0
    80004df4:	900080e7          	jalr	-1792(ra) # 800046f0 <fdalloc>
    80004df8:	84aa                	mv	s1,a0
    80004dfa:	0e054663          	bltz	a0,80004ee6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dfe:	04c91703          	lh	a4,76(s2)
    80004e02:	478d                	li	a5,3
    80004e04:	0cf70463          	beq	a4,a5,80004ecc <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e08:	4789                	li	a5,2
    80004e0a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e0e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e12:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e16:	f4c42783          	lw	a5,-180(s0)
    80004e1a:	0017c713          	xori	a4,a5,1
    80004e1e:	8b05                	andi	a4,a4,1
    80004e20:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e24:	0037f713          	andi	a4,a5,3
    80004e28:	00e03733          	snez	a4,a4
    80004e2c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e30:	4007f793          	andi	a5,a5,1024
    80004e34:	c791                	beqz	a5,80004e40 <sys_open+0xd2>
    80004e36:	04c91703          	lh	a4,76(s2)
    80004e3a:	4789                	li	a5,2
    80004e3c:	08f70f63          	beq	a4,a5,80004eda <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e40:	854a                	mv	a0,s2
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	05e080e7          	jalr	94(ra) # 80002ea0 <iunlock>
  end_op();
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	9ee080e7          	jalr	-1554(ra) # 80003838 <end_op>

  return fd;
}
    80004e52:	8526                	mv	a0,s1
    80004e54:	70ea                	ld	ra,184(sp)
    80004e56:	744a                	ld	s0,176(sp)
    80004e58:	74aa                	ld	s1,168(sp)
    80004e5a:	790a                	ld	s2,160(sp)
    80004e5c:	69ea                	ld	s3,152(sp)
    80004e5e:	6129                	addi	sp,sp,192
    80004e60:	8082                	ret
      end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	9d6080e7          	jalr	-1578(ra) # 80003838 <end_op>
      return -1;
    80004e6a:	b7e5                	j	80004e52 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e6c:	f5040513          	addi	a0,s0,-176
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	72a080e7          	jalr	1834(ra) # 8000359a <namei>
    80004e78:	892a                	mv	s2,a0
    80004e7a:	c905                	beqz	a0,80004eaa <sys_open+0x13c>
    ilock(ip);
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	f62080e7          	jalr	-158(ra) # 80002dde <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e84:	04c91703          	lh	a4,76(s2)
    80004e88:	4785                	li	a5,1
    80004e8a:	f4f712e3          	bne	a4,a5,80004dce <sys_open+0x60>
    80004e8e:	f4c42783          	lw	a5,-180(s0)
    80004e92:	dba1                	beqz	a5,80004de2 <sys_open+0x74>
      iunlockput(ip);
    80004e94:	854a                	mv	a0,s2
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	1aa080e7          	jalr	426(ra) # 80003040 <iunlockput>
      end_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	99a080e7          	jalr	-1638(ra) # 80003838 <end_op>
      return -1;
    80004ea6:	54fd                	li	s1,-1
    80004ea8:	b76d                	j	80004e52 <sys_open+0xe4>
      end_op();
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	98e080e7          	jalr	-1650(ra) # 80003838 <end_op>
      return -1;
    80004eb2:	54fd                	li	s1,-1
    80004eb4:	bf79                	j	80004e52 <sys_open+0xe4>
    iunlockput(ip);
    80004eb6:	854a                	mv	a0,s2
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	188080e7          	jalr	392(ra) # 80003040 <iunlockput>
    end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	978080e7          	jalr	-1672(ra) # 80003838 <end_op>
    return -1;
    80004ec8:	54fd                	li	s1,-1
    80004eca:	b761                	j	80004e52 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ecc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ed0:	04e91783          	lh	a5,78(s2)
    80004ed4:	02f99223          	sh	a5,36(s3)
    80004ed8:	bf2d                	j	80004e12 <sys_open+0xa4>
    itrunc(ip);
    80004eda:	854a                	mv	a0,s2
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	010080e7          	jalr	16(ra) # 80002eec <itrunc>
    80004ee4:	bfb1                	j	80004e40 <sys_open+0xd2>
      fileclose(f);
    80004ee6:	854e                	mv	a0,s3
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	d9a080e7          	jalr	-614(ra) # 80003c82 <fileclose>
    iunlockput(ip);
    80004ef0:	854a                	mv	a0,s2
    80004ef2:	ffffe097          	auipc	ra,0xffffe
    80004ef6:	14e080e7          	jalr	334(ra) # 80003040 <iunlockput>
    end_op();
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	93e080e7          	jalr	-1730(ra) # 80003838 <end_op>
    return -1;
    80004f02:	54fd                	li	s1,-1
    80004f04:	b7b9                	j	80004e52 <sys_open+0xe4>

0000000080004f06 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f06:	7175                	addi	sp,sp,-144
    80004f08:	e506                	sd	ra,136(sp)
    80004f0a:	e122                	sd	s0,128(sp)
    80004f0c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	8ac080e7          	jalr	-1876(ra) # 800037ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f16:	08000613          	li	a2,128
    80004f1a:	f7040593          	addi	a1,s0,-144
    80004f1e:	4501                	li	a0,0
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	130080e7          	jalr	304(ra) # 80002050 <argstr>
    80004f28:	02054963          	bltz	a0,80004f5a <sys_mkdir+0x54>
    80004f2c:	4681                	li	a3,0
    80004f2e:	4601                	li	a2,0
    80004f30:	4585                	li	a1,1
    80004f32:	f7040513          	addi	a0,s0,-144
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	7fc080e7          	jalr	2044(ra) # 80004732 <create>
    80004f3e:	cd11                	beqz	a0,80004f5a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	100080e7          	jalr	256(ra) # 80003040 <iunlockput>
  end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	8f0080e7          	jalr	-1808(ra) # 80003838 <end_op>
  return 0;
    80004f50:	4501                	li	a0,0
}
    80004f52:	60aa                	ld	ra,136(sp)
    80004f54:	640a                	ld	s0,128(sp)
    80004f56:	6149                	addi	sp,sp,144
    80004f58:	8082                	ret
    end_op();
    80004f5a:	fffff097          	auipc	ra,0xfffff
    80004f5e:	8de080e7          	jalr	-1826(ra) # 80003838 <end_op>
    return -1;
    80004f62:	557d                	li	a0,-1
    80004f64:	b7fd                	j	80004f52 <sys_mkdir+0x4c>

0000000080004f66 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f66:	7135                	addi	sp,sp,-160
    80004f68:	ed06                	sd	ra,152(sp)
    80004f6a:	e922                	sd	s0,144(sp)
    80004f6c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f6e:	fffff097          	auipc	ra,0xfffff
    80004f72:	84c080e7          	jalr	-1972(ra) # 800037ba <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f76:	08000613          	li	a2,128
    80004f7a:	f7040593          	addi	a1,s0,-144
    80004f7e:	4501                	li	a0,0
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	0d0080e7          	jalr	208(ra) # 80002050 <argstr>
    80004f88:	04054a63          	bltz	a0,80004fdc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f8c:	f6c40593          	addi	a1,s0,-148
    80004f90:	4505                	li	a0,1
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	07a080e7          	jalr	122(ra) # 8000200c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f9a:	04054163          	bltz	a0,80004fdc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f9e:	f6840593          	addi	a1,s0,-152
    80004fa2:	4509                	li	a0,2
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	068080e7          	jalr	104(ra) # 8000200c <argint>
     argint(1, &major) < 0 ||
    80004fac:	02054863          	bltz	a0,80004fdc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fb0:	f6841683          	lh	a3,-152(s0)
    80004fb4:	f6c41603          	lh	a2,-148(s0)
    80004fb8:	458d                	li	a1,3
    80004fba:	f7040513          	addi	a0,s0,-144
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	774080e7          	jalr	1908(ra) # 80004732 <create>
     argint(2, &minor) < 0 ||
    80004fc6:	c919                	beqz	a0,80004fdc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	078080e7          	jalr	120(ra) # 80003040 <iunlockput>
  end_op();
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	868080e7          	jalr	-1944(ra) # 80003838 <end_op>
  return 0;
    80004fd8:	4501                	li	a0,0
    80004fda:	a031                	j	80004fe6 <sys_mknod+0x80>
    end_op();
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	85c080e7          	jalr	-1956(ra) # 80003838 <end_op>
    return -1;
    80004fe4:	557d                	li	a0,-1
}
    80004fe6:	60ea                	ld	ra,152(sp)
    80004fe8:	644a                	ld	s0,144(sp)
    80004fea:	610d                	addi	sp,sp,160
    80004fec:	8082                	ret

0000000080004fee <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fee:	7135                	addi	sp,sp,-160
    80004ff0:	ed06                	sd	ra,152(sp)
    80004ff2:	e922                	sd	s0,144(sp)
    80004ff4:	e526                	sd	s1,136(sp)
    80004ff6:	e14a                	sd	s2,128(sp)
    80004ff8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	f5c080e7          	jalr	-164(ra) # 80000f56 <myproc>
    80005002:	892a                	mv	s2,a0
  
  begin_op();
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	7b6080e7          	jalr	1974(ra) # 800037ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000500c:	08000613          	li	a2,128
    80005010:	f6040593          	addi	a1,s0,-160
    80005014:	4501                	li	a0,0
    80005016:	ffffd097          	auipc	ra,0xffffd
    8000501a:	03a080e7          	jalr	58(ra) # 80002050 <argstr>
    8000501e:	04054b63          	bltz	a0,80005074 <sys_chdir+0x86>
    80005022:	f6040513          	addi	a0,s0,-160
    80005026:	ffffe097          	auipc	ra,0xffffe
    8000502a:	574080e7          	jalr	1396(ra) # 8000359a <namei>
    8000502e:	84aa                	mv	s1,a0
    80005030:	c131                	beqz	a0,80005074 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	dac080e7          	jalr	-596(ra) # 80002dde <ilock>
  if(ip->type != T_DIR){
    8000503a:	04c49703          	lh	a4,76(s1)
    8000503e:	4785                	li	a5,1
    80005040:	04f71063          	bne	a4,a5,80005080 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005044:	8526                	mv	a0,s1
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	e5a080e7          	jalr	-422(ra) # 80002ea0 <iunlock>
  iput(p->cwd);
    8000504e:	15893503          	ld	a0,344(s2)
    80005052:	ffffe097          	auipc	ra,0xffffe
    80005056:	f46080e7          	jalr	-186(ra) # 80002f98 <iput>
  end_op();
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	7de080e7          	jalr	2014(ra) # 80003838 <end_op>
  p->cwd = ip;
    80005062:	14993c23          	sd	s1,344(s2)
  return 0;
    80005066:	4501                	li	a0,0
}
    80005068:	60ea                	ld	ra,152(sp)
    8000506a:	644a                	ld	s0,144(sp)
    8000506c:	64aa                	ld	s1,136(sp)
    8000506e:	690a                	ld	s2,128(sp)
    80005070:	610d                	addi	sp,sp,160
    80005072:	8082                	ret
    end_op();
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	7c4080e7          	jalr	1988(ra) # 80003838 <end_op>
    return -1;
    8000507c:	557d                	li	a0,-1
    8000507e:	b7ed                	j	80005068 <sys_chdir+0x7a>
    iunlockput(ip);
    80005080:	8526                	mv	a0,s1
    80005082:	ffffe097          	auipc	ra,0xffffe
    80005086:	fbe080e7          	jalr	-66(ra) # 80003040 <iunlockput>
    end_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	7ae080e7          	jalr	1966(ra) # 80003838 <end_op>
    return -1;
    80005092:	557d                	li	a0,-1
    80005094:	bfd1                	j	80005068 <sys_chdir+0x7a>

0000000080005096 <sys_exec>:

uint64
sys_exec(void)
{
    80005096:	7145                	addi	sp,sp,-464
    80005098:	e786                	sd	ra,456(sp)
    8000509a:	e3a2                	sd	s0,448(sp)
    8000509c:	ff26                	sd	s1,440(sp)
    8000509e:	fb4a                	sd	s2,432(sp)
    800050a0:	f74e                	sd	s3,424(sp)
    800050a2:	f352                	sd	s4,416(sp)
    800050a4:	ef56                	sd	s5,408(sp)
    800050a6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a8:	08000613          	li	a2,128
    800050ac:	f4040593          	addi	a1,s0,-192
    800050b0:	4501                	li	a0,0
    800050b2:	ffffd097          	auipc	ra,0xffffd
    800050b6:	f9e080e7          	jalr	-98(ra) # 80002050 <argstr>
    return -1;
    800050ba:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050bc:	0c054b63          	bltz	a0,80005192 <sys_exec+0xfc>
    800050c0:	e3840593          	addi	a1,s0,-456
    800050c4:	4505                	li	a0,1
    800050c6:	ffffd097          	auipc	ra,0xffffd
    800050ca:	f68080e7          	jalr	-152(ra) # 8000202e <argaddr>
    800050ce:	0c054263          	bltz	a0,80005192 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    800050d2:	10000613          	li	a2,256
    800050d6:	4581                	li	a1,0
    800050d8:	e4040513          	addi	a0,s0,-448
    800050dc:	ffffb097          	auipc	ra,0xffffb
    800050e0:	1a0080e7          	jalr	416(ra) # 8000027c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050e4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050e8:	89a6                	mv	s3,s1
    800050ea:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050ec:	02000a13          	li	s4,32
    800050f0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050f4:	00391513          	slli	a0,s2,0x3
    800050f8:	e3040593          	addi	a1,s0,-464
    800050fc:	e3843783          	ld	a5,-456(s0)
    80005100:	953e                	add	a0,a0,a5
    80005102:	ffffd097          	auipc	ra,0xffffd
    80005106:	e70080e7          	jalr	-400(ra) # 80001f72 <fetchaddr>
    8000510a:	02054a63          	bltz	a0,8000513e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000510e:	e3043783          	ld	a5,-464(s0)
    80005112:	c3b9                	beqz	a5,80005158 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005114:	ffffb097          	auipc	ra,0xffffb
    80005118:	056080e7          	jalr	86(ra) # 8000016a <kalloc>
    8000511c:	85aa                	mv	a1,a0
    8000511e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005122:	cd11                	beqz	a0,8000513e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005124:	6605                	lui	a2,0x1
    80005126:	e3043503          	ld	a0,-464(s0)
    8000512a:	ffffd097          	auipc	ra,0xffffd
    8000512e:	e9a080e7          	jalr	-358(ra) # 80001fc4 <fetchstr>
    80005132:	00054663          	bltz	a0,8000513e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005136:	0905                	addi	s2,s2,1
    80005138:	09a1                	addi	s3,s3,8
    8000513a:	fb491be3          	bne	s2,s4,800050f0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000513e:	f4040913          	addi	s2,s0,-192
    80005142:	6088                	ld	a0,0(s1)
    80005144:	c531                	beqz	a0,80005190 <sys_exec+0xfa>
    kfree(argv[i]);
    80005146:	ffffb097          	auipc	ra,0xffffb
    8000514a:	ed6080e7          	jalr	-298(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514e:	04a1                	addi	s1,s1,8
    80005150:	ff2499e3          	bne	s1,s2,80005142 <sys_exec+0xac>
  return -1;
    80005154:	597d                	li	s2,-1
    80005156:	a835                	j	80005192 <sys_exec+0xfc>
      argv[i] = 0;
    80005158:	0a8e                	slli	s5,s5,0x3
    8000515a:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd3d78>
    8000515e:	00878ab3          	add	s5,a5,s0
    80005162:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005166:	e4040593          	addi	a1,s0,-448
    8000516a:	f4040513          	addi	a0,s0,-192
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	172080e7          	jalr	370(ra) # 800042e0 <exec>
    80005176:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005178:	f4040993          	addi	s3,s0,-192
    8000517c:	6088                	ld	a0,0(s1)
    8000517e:	c911                	beqz	a0,80005192 <sys_exec+0xfc>
    kfree(argv[i]);
    80005180:	ffffb097          	auipc	ra,0xffffb
    80005184:	e9c080e7          	jalr	-356(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005188:	04a1                	addi	s1,s1,8
    8000518a:	ff3499e3          	bne	s1,s3,8000517c <sys_exec+0xe6>
    8000518e:	a011                	j	80005192 <sys_exec+0xfc>
  return -1;
    80005190:	597d                	li	s2,-1
}
    80005192:	854a                	mv	a0,s2
    80005194:	60be                	ld	ra,456(sp)
    80005196:	641e                	ld	s0,448(sp)
    80005198:	74fa                	ld	s1,440(sp)
    8000519a:	795a                	ld	s2,432(sp)
    8000519c:	79ba                	ld	s3,424(sp)
    8000519e:	7a1a                	ld	s4,416(sp)
    800051a0:	6afa                	ld	s5,408(sp)
    800051a2:	6179                	addi	sp,sp,464
    800051a4:	8082                	ret

00000000800051a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051a6:	7139                	addi	sp,sp,-64
    800051a8:	fc06                	sd	ra,56(sp)
    800051aa:	f822                	sd	s0,48(sp)
    800051ac:	f426                	sd	s1,40(sp)
    800051ae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	da6080e7          	jalr	-602(ra) # 80000f56 <myproc>
    800051b8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051ba:	fd840593          	addi	a1,s0,-40
    800051be:	4501                	li	a0,0
    800051c0:	ffffd097          	auipc	ra,0xffffd
    800051c4:	e6e080e7          	jalr	-402(ra) # 8000202e <argaddr>
    return -1;
    800051c8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051ca:	0e054063          	bltz	a0,800052aa <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051ce:	fc840593          	addi	a1,s0,-56
    800051d2:	fd040513          	addi	a0,s0,-48
    800051d6:	fffff097          	auipc	ra,0xfffff
    800051da:	ddc080e7          	jalr	-548(ra) # 80003fb2 <pipealloc>
    return -1;
    800051de:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051e0:	0c054563          	bltz	a0,800052aa <sys_pipe+0x104>
  fd0 = -1;
    800051e4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051e8:	fd043503          	ld	a0,-48(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	504080e7          	jalr	1284(ra) # 800046f0 <fdalloc>
    800051f4:	fca42223          	sw	a0,-60(s0)
    800051f8:	08054c63          	bltz	a0,80005290 <sys_pipe+0xea>
    800051fc:	fc843503          	ld	a0,-56(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	4f0080e7          	jalr	1264(ra) # 800046f0 <fdalloc>
    80005208:	fca42023          	sw	a0,-64(s0)
    8000520c:	06054963          	bltz	a0,8000527e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005210:	4691                	li	a3,4
    80005212:	fc440613          	addi	a2,s0,-60
    80005216:	fd843583          	ld	a1,-40(s0)
    8000521a:	6ca8                	ld	a0,88(s1)
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	9fe080e7          	jalr	-1538(ra) # 80000c1a <copyout>
    80005224:	02054063          	bltz	a0,80005244 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005228:	4691                	li	a3,4
    8000522a:	fc040613          	addi	a2,s0,-64
    8000522e:	fd843583          	ld	a1,-40(s0)
    80005232:	0591                	addi	a1,a1,4
    80005234:	6ca8                	ld	a0,88(s1)
    80005236:	ffffc097          	auipc	ra,0xffffc
    8000523a:	9e4080e7          	jalr	-1564(ra) # 80000c1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000523e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005240:	06055563          	bgez	a0,800052aa <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005244:	fc442783          	lw	a5,-60(s0)
    80005248:	07e9                	addi	a5,a5,26
    8000524a:	078e                	slli	a5,a5,0x3
    8000524c:	97a6                	add	a5,a5,s1
    8000524e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005252:	fc042783          	lw	a5,-64(s0)
    80005256:	07e9                	addi	a5,a5,26
    80005258:	078e                	slli	a5,a5,0x3
    8000525a:	00f48533          	add	a0,s1,a5
    8000525e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005262:	fd043503          	ld	a0,-48(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	a1c080e7          	jalr	-1508(ra) # 80003c82 <fileclose>
    fileclose(wf);
    8000526e:	fc843503          	ld	a0,-56(s0)
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	a10080e7          	jalr	-1520(ra) # 80003c82 <fileclose>
    return -1;
    8000527a:	57fd                	li	a5,-1
    8000527c:	a03d                	j	800052aa <sys_pipe+0x104>
    if(fd0 >= 0)
    8000527e:	fc442783          	lw	a5,-60(s0)
    80005282:	0007c763          	bltz	a5,80005290 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005286:	07e9                	addi	a5,a5,26
    80005288:	078e                	slli	a5,a5,0x3
    8000528a:	97a6                	add	a5,a5,s1
    8000528c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005290:	fd043503          	ld	a0,-48(s0)
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	9ee080e7          	jalr	-1554(ra) # 80003c82 <fileclose>
    fileclose(wf);
    8000529c:	fc843503          	ld	a0,-56(s0)
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	9e2080e7          	jalr	-1566(ra) # 80003c82 <fileclose>
    return -1;
    800052a8:	57fd                	li	a5,-1
}
    800052aa:	853e                	mv	a0,a5
    800052ac:	70e2                	ld	ra,56(sp)
    800052ae:	7442                	ld	s0,48(sp)
    800052b0:	74a2                	ld	s1,40(sp)
    800052b2:	6121                	addi	sp,sp,64
    800052b4:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	addi	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	fc22                	sd	s0,56(sp)
    800052d2:	e0a6                	sd	s1,64(sp)
    800052d4:	e4aa                	sd	a0,72(sp)
    800052d6:	e8ae                	sd	a1,80(sp)
    800052d8:	ecb2                	sd	a2,88(sp)
    800052da:	f0b6                	sd	a3,96(sp)
    800052dc:	f4ba                	sd	a4,104(sp)
    800052de:	f8be                	sd	a5,112(sp)
    800052e0:	fcc2                	sd	a6,120(sp)
    800052e2:	e146                	sd	a7,128(sp)
    800052e4:	e54a                	sd	s2,136(sp)
    800052e6:	e94e                	sd	s3,144(sp)
    800052e8:	ed52                	sd	s4,152(sp)
    800052ea:	f156                	sd	s5,160(sp)
    800052ec:	f55a                	sd	s6,168(sp)
    800052ee:	f95e                	sd	s7,176(sp)
    800052f0:	fd62                	sd	s8,184(sp)
    800052f2:	e1e6                	sd	s9,192(sp)
    800052f4:	e5ea                	sd	s10,200(sp)
    800052f6:	e9ee                	sd	s11,208(sp)
    800052f8:	edf2                	sd	t3,216(sp)
    800052fa:	f1f6                	sd	t4,224(sp)
    800052fc:	f5fa                	sd	t5,232(sp)
    800052fe:	f9fe                	sd	t6,240(sp)
    80005300:	b3ffc0ef          	jal	ra,80001e3e <kerneltrap>
    80005304:	6082                	ld	ra,0(sp)
    80005306:	6122                	ld	sp,8(sp)
    80005308:	61c2                	ld	gp,16(sp)
    8000530a:	7282                	ld	t0,32(sp)
    8000530c:	7322                	ld	t1,40(sp)
    8000530e:	73c2                	ld	t2,48(sp)
    80005310:	7462                	ld	s0,56(sp)
    80005312:	6486                	ld	s1,64(sp)
    80005314:	6526                	ld	a0,72(sp)
    80005316:	65c6                	ld	a1,80(sp)
    80005318:	6666                	ld	a2,88(sp)
    8000531a:	7686                	ld	a3,96(sp)
    8000531c:	7726                	ld	a4,104(sp)
    8000531e:	77c6                	ld	a5,112(sp)
    80005320:	7866                	ld	a6,120(sp)
    80005322:	688a                	ld	a7,128(sp)
    80005324:	692a                	ld	s2,136(sp)
    80005326:	69ca                	ld	s3,144(sp)
    80005328:	6a6a                	ld	s4,152(sp)
    8000532a:	7a8a                	ld	s5,160(sp)
    8000532c:	7b2a                	ld	s6,168(sp)
    8000532e:	7bca                	ld	s7,176(sp)
    80005330:	7c6a                	ld	s8,184(sp)
    80005332:	6c8e                	ld	s9,192(sp)
    80005334:	6d2e                	ld	s10,200(sp)
    80005336:	6dce                	ld	s11,208(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	addi	sp,sp,256
    80005342:	10200073          	sret
    80005346:	00000013          	nop
    8000534a:	00000013          	nop
    8000534e:	0001                	nop

0000000080005350 <timervec>:
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	e10c                	sd	a1,0(a0)
    80005356:	e510                	sd	a2,8(a0)
    80005358:	e914                	sd	a3,16(a0)
    8000535a:	6d0c                	ld	a1,24(a0)
    8000535c:	7110                	ld	a2,32(a0)
    8000535e:	6194                	ld	a3,0(a1)
    80005360:	96b2                	add	a3,a3,a2
    80005362:	e194                	sd	a3,0(a1)
    80005364:	4589                	li	a1,2
    80005366:	14459073          	csrw	sip,a1
    8000536a:	6914                	ld	a3,16(a0)
    8000536c:	6510                	ld	a2,8(a0)
    8000536e:	610c                	ld	a1,0(a0)
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	30200073          	mret
	...

000000008000537a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537a:	1141                	addi	sp,sp,-16
    8000537c:	e422                	sd	s0,8(sp)
    8000537e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005380:	0c0007b7          	lui	a5,0xc000
    80005384:	4705                	li	a4,1
    80005386:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005388:	c3d8                	sw	a4,4(a5)
}
    8000538a:	6422                	ld	s0,8(sp)
    8000538c:	0141                	addi	sp,sp,16
    8000538e:	8082                	ret

0000000080005390 <plicinithart>:

void
plicinithart(void)
{
    80005390:	1141                	addi	sp,sp,-16
    80005392:	e406                	sd	ra,8(sp)
    80005394:	e022                	sd	s0,0(sp)
    80005396:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	b92080e7          	jalr	-1134(ra) # 80000f2a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a0:	0085171b          	slliw	a4,a0,0x8
    800053a4:	0c0027b7          	lui	a5,0xc002
    800053a8:	97ba                	add	a5,a5,a4
    800053aa:	40200713          	li	a4,1026
    800053ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b2:	00d5151b          	slliw	a0,a0,0xd
    800053b6:	0c2017b7          	lui	a5,0xc201
    800053ba:	97aa                	add	a5,a5,a0
    800053bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053c0:	60a2                	ld	ra,8(sp)
    800053c2:	6402                	ld	s0,0(sp)
    800053c4:	0141                	addi	sp,sp,16
    800053c6:	8082                	ret

00000000800053c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053c8:	1141                	addi	sp,sp,-16
    800053ca:	e406                	sd	ra,8(sp)
    800053cc:	e022                	sd	s0,0(sp)
    800053ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	b5a080e7          	jalr	-1190(ra) # 80000f2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053d8:	00d5151b          	slliw	a0,a0,0xd
    800053dc:	0c2017b7          	lui	a5,0xc201
    800053e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053e2:	43c8                	lw	a0,4(a5)
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	addi	sp,sp,16
    800053ea:	8082                	ret

00000000800053ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ec:	1101                	addi	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	e426                	sd	s1,8(sp)
    800053f4:	1000                	addi	s0,sp,32
    800053f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	b32080e7          	jalr	-1230(ra) # 80000f2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005400:	00d5151b          	slliw	a0,a0,0xd
    80005404:	0c2017b7          	lui	a5,0xc201
    80005408:	97aa                	add	a5,a5,a0
    8000540a:	c3c4                	sw	s1,4(a5)
}
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	64a2                	ld	s1,8(sp)
    80005412:	6105                	addi	sp,sp,32
    80005414:	8082                	ret

0000000080005416 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005416:	1141                	addi	sp,sp,-16
    80005418:	e406                	sd	ra,8(sp)
    8000541a:	e022                	sd	s0,0(sp)
    8000541c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000541e:	479d                	li	a5,7
    80005420:	06a7c863          	blt	a5,a0,80005490 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005424:	00019717          	auipc	a4,0x19
    80005428:	bdc70713          	addi	a4,a4,-1060 # 8001e000 <disk>
    8000542c:	972a                	add	a4,a4,a0
    8000542e:	6789                	lui	a5,0x2
    80005430:	97ba                	add	a5,a5,a4
    80005432:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005436:	e7ad                	bnez	a5,800054a0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005438:	00451793          	slli	a5,a0,0x4
    8000543c:	0001b717          	auipc	a4,0x1b
    80005440:	bc470713          	addi	a4,a4,-1084 # 80020000 <disk+0x2000>
    80005444:	6314                	ld	a3,0(a4)
    80005446:	96be                	add	a3,a3,a5
    80005448:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000544c:	6314                	ld	a3,0(a4)
    8000544e:	96be                	add	a3,a3,a5
    80005450:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005454:	6314                	ld	a3,0(a4)
    80005456:	96be                	add	a3,a3,a5
    80005458:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000545c:	6318                	ld	a4,0(a4)
    8000545e:	97ba                	add	a5,a5,a4
    80005460:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005464:	00019717          	auipc	a4,0x19
    80005468:	b9c70713          	addi	a4,a4,-1124 # 8001e000 <disk>
    8000546c:	972a                	add	a4,a4,a0
    8000546e:	6789                	lui	a5,0x2
    80005470:	97ba                	add	a5,a5,a4
    80005472:	4705                	li	a4,1
    80005474:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005478:	0001b517          	auipc	a0,0x1b
    8000547c:	ba050513          	addi	a0,a0,-1120 # 80020018 <disk+0x2018>
    80005480:	ffffc097          	auipc	ra,0xffffc
    80005484:	326080e7          	jalr	806(ra) # 800017a6 <wakeup>
}
    80005488:	60a2                	ld	ra,8(sp)
    8000548a:	6402                	ld	s0,0(sp)
    8000548c:	0141                	addi	sp,sp,16
    8000548e:	8082                	ret
    panic("free_desc 1");
    80005490:	00003517          	auipc	a0,0x3
    80005494:	26850513          	addi	a0,a0,616 # 800086f8 <syscalls+0x330>
    80005498:	00001097          	auipc	ra,0x1
    8000549c:	cfc080e7          	jalr	-772(ra) # 80006194 <panic>
    panic("free_desc 2");
    800054a0:	00003517          	auipc	a0,0x3
    800054a4:	26850513          	addi	a0,a0,616 # 80008708 <syscalls+0x340>
    800054a8:	00001097          	auipc	ra,0x1
    800054ac:	cec080e7          	jalr	-788(ra) # 80006194 <panic>

00000000800054b0 <virtio_disk_init>:
{
    800054b0:	1101                	addi	sp,sp,-32
    800054b2:	ec06                	sd	ra,24(sp)
    800054b4:	e822                	sd	s0,16(sp)
    800054b6:	e426                	sd	s1,8(sp)
    800054b8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054ba:	00003597          	auipc	a1,0x3
    800054be:	25e58593          	addi	a1,a1,606 # 80008718 <syscalls+0x350>
    800054c2:	0001b517          	auipc	a0,0x1b
    800054c6:	c6650513          	addi	a0,a0,-922 # 80020128 <disk+0x2128>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	368080e7          	jalr	872(ra) # 80006832 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d2:	100017b7          	lui	a5,0x10001
    800054d6:	4398                	lw	a4,0(a5)
    800054d8:	2701                	sext.w	a4,a4
    800054da:	747277b7          	lui	a5,0x74727
    800054de:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054e2:	0ef71063          	bne	a4,a5,800055c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	43dc                	lw	a5,4(a5)
    800054ec:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054ee:	4705                	li	a4,1
    800054f0:	0ce79963          	bne	a5,a4,800055c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	479c                	lw	a5,8(a5)
    800054fa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054fc:	4709                	li	a4,2
    800054fe:	0ce79263          	bne	a5,a4,800055c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005502:	100017b7          	lui	a5,0x10001
    80005506:	47d8                	lw	a4,12(a5)
    80005508:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000550a:	554d47b7          	lui	a5,0x554d4
    8000550e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005512:	0af71863          	bne	a4,a5,800055c2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005516:	100017b7          	lui	a5,0x10001
    8000551a:	4705                	li	a4,1
    8000551c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551e:	470d                	li	a4,3
    80005520:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005522:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005524:	c7ffe6b7          	lui	a3,0xc7ffe
    80005528:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    8000552c:	8f75                	and	a4,a4,a3
    8000552e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005530:	472d                	li	a4,11
    80005532:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005534:	473d                	li	a4,15
    80005536:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005538:	6705                	lui	a4,0x1
    8000553a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000553c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005540:	5bdc                	lw	a5,52(a5)
    80005542:	2781                	sext.w	a5,a5
  if(max == 0)
    80005544:	c7d9                	beqz	a5,800055d2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005546:	471d                	li	a4,7
    80005548:	08f77d63          	bgeu	a4,a5,800055e2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554c:	100014b7          	lui	s1,0x10001
    80005550:	47a1                	li	a5,8
    80005552:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005554:	6609                	lui	a2,0x2
    80005556:	4581                	li	a1,0
    80005558:	00019517          	auipc	a0,0x19
    8000555c:	aa850513          	addi	a0,a0,-1368 # 8001e000 <disk>
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	d1c080e7          	jalr	-740(ra) # 8000027c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005568:	00019717          	auipc	a4,0x19
    8000556c:	a9870713          	addi	a4,a4,-1384 # 8001e000 <disk>
    80005570:	00c75793          	srli	a5,a4,0xc
    80005574:	2781                	sext.w	a5,a5
    80005576:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005578:	0001b797          	auipc	a5,0x1b
    8000557c:	a8878793          	addi	a5,a5,-1400 # 80020000 <disk+0x2000>
    80005580:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005582:	00019717          	auipc	a4,0x19
    80005586:	afe70713          	addi	a4,a4,-1282 # 8001e080 <disk+0x80>
    8000558a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000558c:	0001a717          	auipc	a4,0x1a
    80005590:	a7470713          	addi	a4,a4,-1420 # 8001f000 <disk+0x1000>
    80005594:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005596:	4705                	li	a4,1
    80005598:	00e78c23          	sb	a4,24(a5)
    8000559c:	00e78ca3          	sb	a4,25(a5)
    800055a0:	00e78d23          	sb	a4,26(a5)
    800055a4:	00e78da3          	sb	a4,27(a5)
    800055a8:	00e78e23          	sb	a4,28(a5)
    800055ac:	00e78ea3          	sb	a4,29(a5)
    800055b0:	00e78f23          	sb	a4,30(a5)
    800055b4:	00e78fa3          	sb	a4,31(a5)
}
    800055b8:	60e2                	ld	ra,24(sp)
    800055ba:	6442                	ld	s0,16(sp)
    800055bc:	64a2                	ld	s1,8(sp)
    800055be:	6105                	addi	sp,sp,32
    800055c0:	8082                	ret
    panic("could not find virtio disk");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	16650513          	addi	a0,a0,358 # 80008728 <syscalls+0x360>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	bca080e7          	jalr	-1078(ra) # 80006194 <panic>
    panic("virtio disk has no queue 0");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	17650513          	addi	a0,a0,374 # 80008748 <syscalls+0x380>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	bba080e7          	jalr	-1094(ra) # 80006194 <panic>
    panic("virtio disk max queue too short");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	18650513          	addi	a0,a0,390 # 80008768 <syscalls+0x3a0>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	baa080e7          	jalr	-1110(ra) # 80006194 <panic>

00000000800055f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055f2:	7119                	addi	sp,sp,-128
    800055f4:	fc86                	sd	ra,120(sp)
    800055f6:	f8a2                	sd	s0,112(sp)
    800055f8:	f4a6                	sd	s1,104(sp)
    800055fa:	f0ca                	sd	s2,96(sp)
    800055fc:	ecce                	sd	s3,88(sp)
    800055fe:	e8d2                	sd	s4,80(sp)
    80005600:	e4d6                	sd	s5,72(sp)
    80005602:	e0da                	sd	s6,64(sp)
    80005604:	fc5e                	sd	s7,56(sp)
    80005606:	f862                	sd	s8,48(sp)
    80005608:	f466                	sd	s9,40(sp)
    8000560a:	f06a                	sd	s10,32(sp)
    8000560c:	ec6e                	sd	s11,24(sp)
    8000560e:	0100                	addi	s0,sp,128
    80005610:	8aaa                	mv	s5,a0
    80005612:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005614:	00c52c83          	lw	s9,12(a0)
    80005618:	001c9c9b          	slliw	s9,s9,0x1
    8000561c:	1c82                	slli	s9,s9,0x20
    8000561e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005622:	0001b517          	auipc	a0,0x1b
    80005626:	b0650513          	addi	a0,a0,-1274 # 80020128 <disk+0x2128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	08c080e7          	jalr	140(ra) # 800066b6 <acquire>
  for(int i = 0; i < 3; i++){
    80005632:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005634:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005636:	00019c17          	auipc	s8,0x19
    8000563a:	9cac0c13          	addi	s8,s8,-1590 # 8001e000 <disk>
    8000563e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005640:	4b0d                	li	s6,3
    80005642:	a0ad                	j	800056ac <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005644:	00fc0733          	add	a4,s8,a5
    80005648:	975e                	add	a4,a4,s7
    8000564a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000564e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005650:	0207c563          	bltz	a5,8000567a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005654:	2905                	addiw	s2,s2,1
    80005656:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005658:	19690c63          	beq	s2,s6,800057f0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000565c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000565e:	0001b717          	auipc	a4,0x1b
    80005662:	9ba70713          	addi	a4,a4,-1606 # 80020018 <disk+0x2018>
    80005666:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005668:	00074683          	lbu	a3,0(a4)
    8000566c:	fee1                	bnez	a3,80005644 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000566e:	2785                	addiw	a5,a5,1
    80005670:	0705                	addi	a4,a4,1
    80005672:	fe979be3          	bne	a5,s1,80005668 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005676:	57fd                	li	a5,-1
    80005678:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000567a:	01205d63          	blez	s2,80005694 <virtio_disk_rw+0xa2>
    8000567e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005680:	000a2503          	lw	a0,0(s4)
    80005684:	00000097          	auipc	ra,0x0
    80005688:	d92080e7          	jalr	-622(ra) # 80005416 <free_desc>
      for(int j = 0; j < i; j++)
    8000568c:	2d85                	addiw	s11,s11,1
    8000568e:	0a11                	addi	s4,s4,4
    80005690:	ff2d98e3          	bne	s11,s2,80005680 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005694:	0001b597          	auipc	a1,0x1b
    80005698:	a9458593          	addi	a1,a1,-1388 # 80020128 <disk+0x2128>
    8000569c:	0001b517          	auipc	a0,0x1b
    800056a0:	97c50513          	addi	a0,a0,-1668 # 80020018 <disk+0x2018>
    800056a4:	ffffc097          	auipc	ra,0xffffc
    800056a8:	f76080e7          	jalr	-138(ra) # 8000161a <sleep>
  for(int i = 0; i < 3; i++){
    800056ac:	f8040a13          	addi	s4,s0,-128
{
    800056b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056b2:	894e                	mv	s2,s3
    800056b4:	b765                	j	8000565c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056b6:	0001b697          	auipc	a3,0x1b
    800056ba:	94a6b683          	ld	a3,-1718(a3) # 80020000 <disk+0x2000>
    800056be:	96ba                	add	a3,a3,a4
    800056c0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056c4:	00019817          	auipc	a6,0x19
    800056c8:	93c80813          	addi	a6,a6,-1732 # 8001e000 <disk>
    800056cc:	0001b697          	auipc	a3,0x1b
    800056d0:	93468693          	addi	a3,a3,-1740 # 80020000 <disk+0x2000>
    800056d4:	6290                	ld	a2,0(a3)
    800056d6:	963a                	add	a2,a2,a4
    800056d8:	00c65583          	lhu	a1,12(a2)
    800056dc:	0015e593          	ori	a1,a1,1
    800056e0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800056e4:	f8842603          	lw	a2,-120(s0)
    800056e8:	628c                	ld	a1,0(a3)
    800056ea:	972e                	add	a4,a4,a1
    800056ec:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f0:	20050593          	addi	a1,a0,512
    800056f4:	0592                	slli	a1,a1,0x4
    800056f6:	95c2                	add	a1,a1,a6
    800056f8:	577d                	li	a4,-1
    800056fa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056fe:	00461713          	slli	a4,a2,0x4
    80005702:	6290                	ld	a2,0(a3)
    80005704:	963a                	add	a2,a2,a4
    80005706:	03078793          	addi	a5,a5,48
    8000570a:	97c2                	add	a5,a5,a6
    8000570c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000570e:	629c                	ld	a5,0(a3)
    80005710:	97ba                	add	a5,a5,a4
    80005712:	4605                	li	a2,1
    80005714:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005716:	629c                	ld	a5,0(a3)
    80005718:	97ba                	add	a5,a5,a4
    8000571a:	4809                	li	a6,2
    8000571c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005720:	629c                	ld	a5,0(a3)
    80005722:	97ba                	add	a5,a5,a4
    80005724:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005728:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000572c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005730:	6698                	ld	a4,8(a3)
    80005732:	00275783          	lhu	a5,2(a4)
    80005736:	8b9d                	andi	a5,a5,7
    80005738:	0786                	slli	a5,a5,0x1
    8000573a:	973e                	add	a4,a4,a5
    8000573c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005740:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005744:	6698                	ld	a4,8(a3)
    80005746:	00275783          	lhu	a5,2(a4)
    8000574a:	2785                	addiw	a5,a5,1
    8000574c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005750:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005754:	100017b7          	lui	a5,0x10001
    80005758:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000575c:	004aa783          	lw	a5,4(s5)
    80005760:	02c79163          	bne	a5,a2,80005782 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005764:	0001b917          	auipc	s2,0x1b
    80005768:	9c490913          	addi	s2,s2,-1596 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    8000576c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000576e:	85ca                	mv	a1,s2
    80005770:	8556                	mv	a0,s5
    80005772:	ffffc097          	auipc	ra,0xffffc
    80005776:	ea8080e7          	jalr	-344(ra) # 8000161a <sleep>
  while(b->disk == 1) {
    8000577a:	004aa783          	lw	a5,4(s5)
    8000577e:	fe9788e3          	beq	a5,s1,8000576e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005782:	f8042903          	lw	s2,-128(s0)
    80005786:	20090713          	addi	a4,s2,512
    8000578a:	0712                	slli	a4,a4,0x4
    8000578c:	00019797          	auipc	a5,0x19
    80005790:	87478793          	addi	a5,a5,-1932 # 8001e000 <disk>
    80005794:	97ba                	add	a5,a5,a4
    80005796:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000579a:	0001b997          	auipc	s3,0x1b
    8000579e:	86698993          	addi	s3,s3,-1946 # 80020000 <disk+0x2000>
    800057a2:	00491713          	slli	a4,s2,0x4
    800057a6:	0009b783          	ld	a5,0(s3)
    800057aa:	97ba                	add	a5,a5,a4
    800057ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057b0:	854a                	mv	a0,s2
    800057b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b6:	00000097          	auipc	ra,0x0
    800057ba:	c60080e7          	jalr	-928(ra) # 80005416 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057be:	8885                	andi	s1,s1,1
    800057c0:	f0ed                	bnez	s1,800057a2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057c2:	0001b517          	auipc	a0,0x1b
    800057c6:	96650513          	addi	a0,a0,-1690 # 80020128 <disk+0x2128>
    800057ca:	00001097          	auipc	ra,0x1
    800057ce:	fbc080e7          	jalr	-68(ra) # 80006786 <release>
}
    800057d2:	70e6                	ld	ra,120(sp)
    800057d4:	7446                	ld	s0,112(sp)
    800057d6:	74a6                	ld	s1,104(sp)
    800057d8:	7906                	ld	s2,96(sp)
    800057da:	69e6                	ld	s3,88(sp)
    800057dc:	6a46                	ld	s4,80(sp)
    800057de:	6aa6                	ld	s5,72(sp)
    800057e0:	6b06                	ld	s6,64(sp)
    800057e2:	7be2                	ld	s7,56(sp)
    800057e4:	7c42                	ld	s8,48(sp)
    800057e6:	7ca2                	ld	s9,40(sp)
    800057e8:	7d02                	ld	s10,32(sp)
    800057ea:	6de2                	ld	s11,24(sp)
    800057ec:	6109                	addi	sp,sp,128
    800057ee:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057f0:	f8042503          	lw	a0,-128(s0)
    800057f4:	20050793          	addi	a5,a0,512
    800057f8:	0792                	slli	a5,a5,0x4
  if(write)
    800057fa:	00019817          	auipc	a6,0x19
    800057fe:	80680813          	addi	a6,a6,-2042 # 8001e000 <disk>
    80005802:	00f80733          	add	a4,a6,a5
    80005806:	01a036b3          	snez	a3,s10
    8000580a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000580e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005812:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005816:	7679                	lui	a2,0xffffe
    80005818:	963e                	add	a2,a2,a5
    8000581a:	0001a697          	auipc	a3,0x1a
    8000581e:	7e668693          	addi	a3,a3,2022 # 80020000 <disk+0x2000>
    80005822:	6298                	ld	a4,0(a3)
    80005824:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005826:	0a878593          	addi	a1,a5,168
    8000582a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000582c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000582e:	6298                	ld	a4,0(a3)
    80005830:	9732                	add	a4,a4,a2
    80005832:	45c1                	li	a1,16
    80005834:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005836:	6298                	ld	a4,0(a3)
    80005838:	9732                	add	a4,a4,a2
    8000583a:	4585                	li	a1,1
    8000583c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005840:	f8442703          	lw	a4,-124(s0)
    80005844:	628c                	ld	a1,0(a3)
    80005846:	962e                	add	a2,a2,a1
    80005848:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000584c:	0712                	slli	a4,a4,0x4
    8000584e:	6290                	ld	a2,0(a3)
    80005850:	963a                	add	a2,a2,a4
    80005852:	060a8593          	addi	a1,s5,96
    80005856:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005858:	6294                	ld	a3,0(a3)
    8000585a:	96ba                	add	a3,a3,a4
    8000585c:	40000613          	li	a2,1024
    80005860:	c690                	sw	a2,8(a3)
  if(write)
    80005862:	e40d1ae3          	bnez	s10,800056b6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005866:	0001a697          	auipc	a3,0x1a
    8000586a:	79a6b683          	ld	a3,1946(a3) # 80020000 <disk+0x2000>
    8000586e:	96ba                	add	a3,a3,a4
    80005870:	4609                	li	a2,2
    80005872:	00c69623          	sh	a2,12(a3)
    80005876:	b5b9                	j	800056c4 <virtio_disk_rw+0xd2>

0000000080005878 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005878:	1101                	addi	sp,sp,-32
    8000587a:	ec06                	sd	ra,24(sp)
    8000587c:	e822                	sd	s0,16(sp)
    8000587e:	e426                	sd	s1,8(sp)
    80005880:	e04a                	sd	s2,0(sp)
    80005882:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005884:	0001b517          	auipc	a0,0x1b
    80005888:	8a450513          	addi	a0,a0,-1884 # 80020128 <disk+0x2128>
    8000588c:	00001097          	auipc	ra,0x1
    80005890:	e2a080e7          	jalr	-470(ra) # 800066b6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005894:	10001737          	lui	a4,0x10001
    80005898:	533c                	lw	a5,96(a4)
    8000589a:	8b8d                	andi	a5,a5,3
    8000589c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000589e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058a2:	0001a797          	auipc	a5,0x1a
    800058a6:	75e78793          	addi	a5,a5,1886 # 80020000 <disk+0x2000>
    800058aa:	6b94                	ld	a3,16(a5)
    800058ac:	0207d703          	lhu	a4,32(a5)
    800058b0:	0026d783          	lhu	a5,2(a3)
    800058b4:	06f70163          	beq	a4,a5,80005916 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058b8:	00018917          	auipc	s2,0x18
    800058bc:	74890913          	addi	s2,s2,1864 # 8001e000 <disk>
    800058c0:	0001a497          	auipc	s1,0x1a
    800058c4:	74048493          	addi	s1,s1,1856 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800058c8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058cc:	6898                	ld	a4,16(s1)
    800058ce:	0204d783          	lhu	a5,32(s1)
    800058d2:	8b9d                	andi	a5,a5,7
    800058d4:	078e                	slli	a5,a5,0x3
    800058d6:	97ba                	add	a5,a5,a4
    800058d8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058da:	20078713          	addi	a4,a5,512
    800058de:	0712                	slli	a4,a4,0x4
    800058e0:	974a                	add	a4,a4,s2
    800058e2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058e6:	e731                	bnez	a4,80005932 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058e8:	20078793          	addi	a5,a5,512
    800058ec:	0792                	slli	a5,a5,0x4
    800058ee:	97ca                	add	a5,a5,s2
    800058f0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058f2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058f6:	ffffc097          	auipc	ra,0xffffc
    800058fa:	eb0080e7          	jalr	-336(ra) # 800017a6 <wakeup>

    disk.used_idx += 1;
    800058fe:	0204d783          	lhu	a5,32(s1)
    80005902:	2785                	addiw	a5,a5,1
    80005904:	17c2                	slli	a5,a5,0x30
    80005906:	93c1                	srli	a5,a5,0x30
    80005908:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000590c:	6898                	ld	a4,16(s1)
    8000590e:	00275703          	lhu	a4,2(a4)
    80005912:	faf71be3          	bne	a4,a5,800058c8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005916:	0001b517          	auipc	a0,0x1b
    8000591a:	81250513          	addi	a0,a0,-2030 # 80020128 <disk+0x2128>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	e68080e7          	jalr	-408(ra) # 80006786 <release>
}
    80005926:	60e2                	ld	ra,24(sp)
    80005928:	6442                	ld	s0,16(sp)
    8000592a:	64a2                	ld	s1,8(sp)
    8000592c:	6902                	ld	s2,0(sp)
    8000592e:	6105                	addi	sp,sp,32
    80005930:	8082                	ret
      panic("virtio_disk_intr status");
    80005932:	00003517          	auipc	a0,0x3
    80005936:	e5650513          	addi	a0,a0,-426 # 80008788 <syscalls+0x3c0>
    8000593a:	00001097          	auipc	ra,0x1
    8000593e:	85a080e7          	jalr	-1958(ra) # 80006194 <panic>

0000000080005942 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005942:	1141                	addi	sp,sp,-16
    80005944:	e422                	sd	s0,8(sp)
    80005946:	0800                	addi	s0,sp,16
  return -1;
}
    80005948:	557d                	li	a0,-1
    8000594a:	6422                	ld	s0,8(sp)
    8000594c:	0141                	addi	sp,sp,16
    8000594e:	8082                	ret

0000000080005950 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005950:	7179                	addi	sp,sp,-48
    80005952:	f406                	sd	ra,40(sp)
    80005954:	f022                	sd	s0,32(sp)
    80005956:	ec26                	sd	s1,24(sp)
    80005958:	e84a                	sd	s2,16(sp)
    8000595a:	e44e                	sd	s3,8(sp)
    8000595c:	e052                	sd	s4,0(sp)
    8000595e:	1800                	addi	s0,sp,48
    80005960:	892a                	mv	s2,a0
    80005962:	89ae                	mv	s3,a1
    80005964:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80005966:	0001b517          	auipc	a0,0x1b
    8000596a:	69a50513          	addi	a0,a0,1690 # 80021000 <stats>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	d48080e7          	jalr	-696(ra) # 800066b6 <acquire>

  if(stats.sz == 0) {
    80005976:	0001c797          	auipc	a5,0x1c
    8000597a:	6aa7a783          	lw	a5,1706(a5) # 80022020 <stats+0x1020>
    8000597e:	cbb5                	beqz	a5,800059f2 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005980:	0001c797          	auipc	a5,0x1c
    80005984:	68078793          	addi	a5,a5,1664 # 80022000 <stats+0x1000>
    80005988:	53d8                	lw	a4,36(a5)
    8000598a:	539c                	lw	a5,32(a5)
    8000598c:	9f99                	subw	a5,a5,a4
    8000598e:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005992:	06d05e63          	blez	a3,80005a0e <statsread+0xbe>
    if(m > n)
    80005996:	8a3e                	mv	s4,a5
    80005998:	00d4d363          	bge	s1,a3,8000599e <statsread+0x4e>
    8000599c:	8a26                	mv	s4,s1
    8000599e:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    800059a2:	86a6                	mv	a3,s1
    800059a4:	0001b617          	auipc	a2,0x1b
    800059a8:	67c60613          	addi	a2,a2,1660 # 80021020 <stats+0x20>
    800059ac:	963a                	add	a2,a2,a4
    800059ae:	85ce                	mv	a1,s3
    800059b0:	854a                	mv	a0,s2
    800059b2:	ffffc097          	auipc	ra,0xffffc
    800059b6:	00c080e7          	jalr	12(ra) # 800019be <either_copyout>
    800059ba:	57fd                	li	a5,-1
    800059bc:	00f50a63          	beq	a0,a5,800059d0 <statsread+0x80>
      stats.off += m;
    800059c0:	0001c717          	auipc	a4,0x1c
    800059c4:	64070713          	addi	a4,a4,1600 # 80022000 <stats+0x1000>
    800059c8:	535c                	lw	a5,36(a4)
    800059ca:	00fa07bb          	addw	a5,s4,a5
    800059ce:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800059d0:	0001b517          	auipc	a0,0x1b
    800059d4:	63050513          	addi	a0,a0,1584 # 80021000 <stats>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	dae080e7          	jalr	-594(ra) # 80006786 <release>
  return m;
}
    800059e0:	8526                	mv	a0,s1
    800059e2:	70a2                	ld	ra,40(sp)
    800059e4:	7402                	ld	s0,32(sp)
    800059e6:	64e2                	ld	s1,24(sp)
    800059e8:	6942                	ld	s2,16(sp)
    800059ea:	69a2                	ld	s3,8(sp)
    800059ec:	6a02                	ld	s4,0(sp)
    800059ee:	6145                	addi	sp,sp,48
    800059f0:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    800059f2:	6585                	lui	a1,0x1
    800059f4:	0001b517          	auipc	a0,0x1b
    800059f8:	62c50513          	addi	a0,a0,1580 # 80021020 <stats+0x20>
    800059fc:	00001097          	auipc	ra,0x1
    80005a00:	f10080e7          	jalr	-240(ra) # 8000690c <statslock>
    80005a04:	0001c797          	auipc	a5,0x1c
    80005a08:	60a7ae23          	sw	a0,1564(a5) # 80022020 <stats+0x1020>
    80005a0c:	bf95                	j	80005980 <statsread+0x30>
    stats.sz = 0;
    80005a0e:	0001c797          	auipc	a5,0x1c
    80005a12:	5f278793          	addi	a5,a5,1522 # 80022000 <stats+0x1000>
    80005a16:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a1a:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a1e:	54fd                	li	s1,-1
    80005a20:	bf45                	j	800059d0 <statsread+0x80>

0000000080005a22 <statsinit>:

void
statsinit(void)
{
    80005a22:	1141                	addi	sp,sp,-16
    80005a24:	e406                	sd	ra,8(sp)
    80005a26:	e022                	sd	s0,0(sp)
    80005a28:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a2a:	00003597          	auipc	a1,0x3
    80005a2e:	d7658593          	addi	a1,a1,-650 # 800087a0 <syscalls+0x3d8>
    80005a32:	0001b517          	auipc	a0,0x1b
    80005a36:	5ce50513          	addi	a0,a0,1486 # 80021000 <stats>
    80005a3a:	00001097          	auipc	ra,0x1
    80005a3e:	df8080e7          	jalr	-520(ra) # 80006832 <initlock>

  devsw[STATS].read = statsread;
    80005a42:	00017797          	auipc	a5,0x17
    80005a46:	3d678793          	addi	a5,a5,982 # 8001ce18 <devsw>
    80005a4a:	00000717          	auipc	a4,0x0
    80005a4e:	f0670713          	addi	a4,a4,-250 # 80005950 <statsread>
    80005a52:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005a54:	00000717          	auipc	a4,0x0
    80005a58:	eee70713          	addi	a4,a4,-274 # 80005942 <statswrite>
    80005a5c:	f798                	sd	a4,40(a5)
}
    80005a5e:	60a2                	ld	ra,8(sp)
    80005a60:	6402                	ld	s0,0(sp)
    80005a62:	0141                	addi	sp,sp,16
    80005a64:	8082                	ret

0000000080005a66 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a66:	1101                	addi	sp,sp,-32
    80005a68:	ec22                	sd	s0,24(sp)
    80005a6a:	1000                	addi	s0,sp,32
    80005a6c:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a6e:	c299                	beqz	a3,80005a74 <sprintint+0xe>
    80005a70:	0805c263          	bltz	a1,80005af4 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005a74:	2581                	sext.w	a1,a1
    80005a76:	4301                	li	t1,0

  i = 0;
    80005a78:	fe040713          	addi	a4,s0,-32
    80005a7c:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005a7e:	2601                	sext.w	a2,a2
    80005a80:	00003697          	auipc	a3,0x3
    80005a84:	d4068693          	addi	a3,a3,-704 # 800087c0 <digits>
    80005a88:	88aa                	mv	a7,a0
    80005a8a:	2505                	addiw	a0,a0,1
    80005a8c:	02c5f7bb          	remuw	a5,a1,a2
    80005a90:	1782                	slli	a5,a5,0x20
    80005a92:	9381                	srli	a5,a5,0x20
    80005a94:	97b6                	add	a5,a5,a3
    80005a96:	0007c783          	lbu	a5,0(a5)
    80005a9a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a9e:	0005879b          	sext.w	a5,a1
    80005aa2:	02c5d5bb          	divuw	a1,a1,a2
    80005aa6:	0705                	addi	a4,a4,1
    80005aa8:	fec7f0e3          	bgeu	a5,a2,80005a88 <sprintint+0x22>

  if(sign)
    80005aac:	00030b63          	beqz	t1,80005ac2 <sprintint+0x5c>
    buf[i++] = '-';
    80005ab0:	ff050793          	addi	a5,a0,-16
    80005ab4:	97a2                	add	a5,a5,s0
    80005ab6:	02d00713          	li	a4,45
    80005aba:	fee78823          	sb	a4,-16(a5)
    80005abe:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005ac2:	02a05d63          	blez	a0,80005afc <sprintint+0x96>
    80005ac6:	fe040793          	addi	a5,s0,-32
    80005aca:	00a78733          	add	a4,a5,a0
    80005ace:	87c2                	mv	a5,a6
    80005ad0:	00180613          	addi	a2,a6,1
    80005ad4:	fff5069b          	addiw	a3,a0,-1
    80005ad8:	1682                	slli	a3,a3,0x20
    80005ada:	9281                	srli	a3,a3,0x20
    80005adc:	9636                	add	a2,a2,a3
  *s = c;
    80005ade:	fff74683          	lbu	a3,-1(a4)
    80005ae2:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005ae6:	177d                	addi	a4,a4,-1
    80005ae8:	0785                	addi	a5,a5,1
    80005aea:	fec79ae3          	bne	a5,a2,80005ade <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005aee:	6462                	ld	s0,24(sp)
    80005af0:	6105                	addi	sp,sp,32
    80005af2:	8082                	ret
    x = -xx;
    80005af4:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005af8:	4305                	li	t1,1
    x = -xx;
    80005afa:	bfbd                	j	80005a78 <sprintint+0x12>
  while(--i >= 0)
    80005afc:	4501                	li	a0,0
    80005afe:	bfc5                	j	80005aee <sprintint+0x88>

0000000080005b00 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b00:	7135                	addi	sp,sp,-160
    80005b02:	f486                	sd	ra,104(sp)
    80005b04:	f0a2                	sd	s0,96(sp)
    80005b06:	eca6                	sd	s1,88(sp)
    80005b08:	e8ca                	sd	s2,80(sp)
    80005b0a:	e4ce                	sd	s3,72(sp)
    80005b0c:	e0d2                	sd	s4,64(sp)
    80005b0e:	fc56                	sd	s5,56(sp)
    80005b10:	f85a                	sd	s6,48(sp)
    80005b12:	f45e                	sd	s7,40(sp)
    80005b14:	f062                	sd	s8,32(sp)
    80005b16:	ec66                	sd	s9,24(sp)
    80005b18:	e86a                	sd	s10,16(sp)
    80005b1a:	1880                	addi	s0,sp,112
    80005b1c:	e414                	sd	a3,8(s0)
    80005b1e:	e818                	sd	a4,16(s0)
    80005b20:	ec1c                	sd	a5,24(s0)
    80005b22:	03043023          	sd	a6,32(s0)
    80005b26:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b2a:	c61d                	beqz	a2,80005b58 <snprintf+0x58>
    80005b2c:	8baa                	mv	s7,a0
    80005b2e:	89ae                	mv	s3,a1
    80005b30:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005b32:	00840793          	addi	a5,s0,8
    80005b36:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005b3a:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b3c:	4901                	li	s2,0
    80005b3e:	02b05563          	blez	a1,80005b68 <snprintf+0x68>
    if(c != '%'){
    80005b42:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005b46:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005b4a:	02800d13          	li	s10,40
    switch(c){
    80005b4e:	07800c93          	li	s9,120
    80005b52:	06400c13          	li	s8,100
    80005b56:	a01d                	j	80005b7c <snprintf+0x7c>
    panic("null fmt");
    80005b58:	00003517          	auipc	a0,0x3
    80005b5c:	c5850513          	addi	a0,a0,-936 # 800087b0 <syscalls+0x3e8>
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	634080e7          	jalr	1588(ra) # 80006194 <panic>
  int off = 0;
    80005b68:	4481                	li	s1,0
    80005b6a:	a875                	j	80005c26 <snprintf+0x126>
  *s = c;
    80005b6c:	009b8733          	add	a4,s7,s1
    80005b70:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b74:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b76:	2905                	addiw	s2,s2,1
    80005b78:	0b34d763          	bge	s1,s3,80005c26 <snprintf+0x126>
    80005b7c:	012a07b3          	add	a5,s4,s2
    80005b80:	0007c783          	lbu	a5,0(a5)
    80005b84:	0007871b          	sext.w	a4,a5
    80005b88:	cfd9                	beqz	a5,80005c26 <snprintf+0x126>
    if(c != '%'){
    80005b8a:	ff5711e3          	bne	a4,s5,80005b6c <snprintf+0x6c>
    c = fmt[++i] & 0xff;
    80005b8e:	2905                	addiw	s2,s2,1
    80005b90:	012a07b3          	add	a5,s4,s2
    80005b94:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005b98:	c7d9                	beqz	a5,80005c26 <snprintf+0x126>
    switch(c){
    80005b9a:	05678c63          	beq	a5,s6,80005bf2 <snprintf+0xf2>
    80005b9e:	02fb6763          	bltu	s6,a5,80005bcc <snprintf+0xcc>
    80005ba2:	0b578763          	beq	a5,s5,80005c50 <snprintf+0x150>
    80005ba6:	0b879b63          	bne	a5,s8,80005c5c <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005baa:	f9843783          	ld	a5,-104(s0)
    80005bae:	00878713          	addi	a4,a5,8
    80005bb2:	f8e43c23          	sd	a4,-104(s0)
    80005bb6:	4685                	li	a3,1
    80005bb8:	4629                	li	a2,10
    80005bba:	438c                	lw	a1,0(a5)
    80005bbc:	009b8533          	add	a0,s7,s1
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	ea6080e7          	jalr	-346(ra) # 80005a66 <sprintint>
    80005bc8:	9ca9                	addw	s1,s1,a0
      break;
    80005bca:	b775                	j	80005b76 <snprintf+0x76>
    switch(c){
    80005bcc:	09979863          	bne	a5,s9,80005c5c <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005bd0:	f9843783          	ld	a5,-104(s0)
    80005bd4:	00878713          	addi	a4,a5,8
    80005bd8:	f8e43c23          	sd	a4,-104(s0)
    80005bdc:	4685                	li	a3,1
    80005bde:	4641                	li	a2,16
    80005be0:	438c                	lw	a1,0(a5)
    80005be2:	009b8533          	add	a0,s7,s1
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	e80080e7          	jalr	-384(ra) # 80005a66 <sprintint>
    80005bee:	9ca9                	addw	s1,s1,a0
      break;
    80005bf0:	b759                	j	80005b76 <snprintf+0x76>
      if((s = va_arg(ap, char*)) == 0)
    80005bf2:	f9843783          	ld	a5,-104(s0)
    80005bf6:	00878713          	addi	a4,a5,8
    80005bfa:	f8e43c23          	sd	a4,-104(s0)
    80005bfe:	639c                	ld	a5,0(a5)
    80005c00:	c3b1                	beqz	a5,80005c44 <snprintf+0x144>
      for(; *s && off < sz; s++)
    80005c02:	0007c703          	lbu	a4,0(a5)
    80005c06:	db25                	beqz	a4,80005b76 <snprintf+0x76>
    80005c08:	0734d563          	bge	s1,s3,80005c72 <snprintf+0x172>
    80005c0c:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005c10:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005c14:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005c16:	0785                	addi	a5,a5,1
    80005c18:	0007c703          	lbu	a4,0(a5)
    80005c1c:	df29                	beqz	a4,80005b76 <snprintf+0x76>
    80005c1e:	0685                	addi	a3,a3,1
    80005c20:	fe9998e3          	bne	s3,s1,80005c10 <snprintf+0x110>
  int off = 0;
    80005c24:	84ce                	mv	s1,s3
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005c26:	8526                	mv	a0,s1
    80005c28:	70a6                	ld	ra,104(sp)
    80005c2a:	7406                	ld	s0,96(sp)
    80005c2c:	64e6                	ld	s1,88(sp)
    80005c2e:	6946                	ld	s2,80(sp)
    80005c30:	69a6                	ld	s3,72(sp)
    80005c32:	6a06                	ld	s4,64(sp)
    80005c34:	7ae2                	ld	s5,56(sp)
    80005c36:	7b42                	ld	s6,48(sp)
    80005c38:	7ba2                	ld	s7,40(sp)
    80005c3a:	7c02                	ld	s8,32(sp)
    80005c3c:	6ce2                	ld	s9,24(sp)
    80005c3e:	6d42                	ld	s10,16(sp)
    80005c40:	610d                	addi	sp,sp,160
    80005c42:	8082                	ret
        s = "(null)";
    80005c44:	00003797          	auipc	a5,0x3
    80005c48:	b6478793          	addi	a5,a5,-1180 # 800087a8 <syscalls+0x3e0>
      for(; *s && off < sz; s++)
    80005c4c:	876a                	mv	a4,s10
    80005c4e:	bf6d                	j	80005c08 <snprintf+0x108>
  *s = c;
    80005c50:	009b87b3          	add	a5,s7,s1
    80005c54:	01578023          	sb	s5,0(a5)
      off += sputc(buf+off, '%');
    80005c58:	2485                	addiw	s1,s1,1
      break;
    80005c5a:	bf31                	j	80005b76 <snprintf+0x76>
  *s = c;
    80005c5c:	009b8733          	add	a4,s7,s1
    80005c60:	01570023          	sb	s5,0(a4)
      off += sputc(buf+off, c);
    80005c64:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c68:	975e                	add	a4,a4,s7
    80005c6a:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c6e:	2489                	addiw	s1,s1,2
      break;
    80005c70:	b719                	j	80005b76 <snprintf+0x76>
      for(; *s && off < sz; s++)
    80005c72:	89a6                	mv	s3,s1
    80005c74:	bf45                	j	80005c24 <snprintf+0x124>

0000000080005c76 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c76:	1141                	addi	sp,sp,-16
    80005c78:	e422                	sd	s0,8(sp)
    80005c7a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c7c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c80:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c84:	0037979b          	slliw	a5,a5,0x3
    80005c88:	02004737          	lui	a4,0x2004
    80005c8c:	97ba                	add	a5,a5,a4
    80005c8e:	0200c737          	lui	a4,0x200c
    80005c92:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c96:	000f4637          	lui	a2,0xf4
    80005c9a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c9e:	9732                	add	a4,a4,a2
    80005ca0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ca2:	00259693          	slli	a3,a1,0x2
    80005ca6:	96ae                	add	a3,a3,a1
    80005ca8:	068e                	slli	a3,a3,0x3
    80005caa:	0001c717          	auipc	a4,0x1c
    80005cae:	38670713          	addi	a4,a4,902 # 80022030 <timer_scratch>
    80005cb2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005cb4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005cb6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005cb8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005cbc:	fffff797          	auipc	a5,0xfffff
    80005cc0:	69478793          	addi	a5,a5,1684 # 80005350 <timervec>
    80005cc4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005cc8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ccc:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005cd0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005cd4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005cd8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005cdc:	30479073          	csrw	mie,a5
}
    80005ce0:	6422                	ld	s0,8(sp)
    80005ce2:	0141                	addi	sp,sp,16
    80005ce4:	8082                	ret

0000000080005ce6 <start>:
{
    80005ce6:	1141                	addi	sp,sp,-16
    80005ce8:	e406                	sd	ra,8(sp)
    80005cea:	e022                	sd	s0,0(sp)
    80005cec:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005cee:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005cf2:	7779                	lui	a4,0xffffe
    80005cf4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005cf8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005cfa:	6705                	lui	a4,0x1
    80005cfc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d00:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d02:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d06:	ffffa797          	auipc	a5,0xffffa
    80005d0a:	71c78793          	addi	a5,a5,1820 # 80000422 <main>
    80005d0e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005d12:	4781                	li	a5,0
    80005d14:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005d18:	67c1                	lui	a5,0x10
    80005d1a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005d1c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005d20:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005d24:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005d28:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005d2c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005d30:	57fd                	li	a5,-1
    80005d32:	83a9                	srli	a5,a5,0xa
    80005d34:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005d38:	47bd                	li	a5,15
    80005d3a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	f38080e7          	jalr	-200(ra) # 80005c76 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d46:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d4a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d4c:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d4e:	30200073          	mret
}
    80005d52:	60a2                	ld	ra,8(sp)
    80005d54:	6402                	ld	s0,0(sp)
    80005d56:	0141                	addi	sp,sp,16
    80005d58:	8082                	ret

0000000080005d5a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d5a:	715d                	addi	sp,sp,-80
    80005d5c:	e486                	sd	ra,72(sp)
    80005d5e:	e0a2                	sd	s0,64(sp)
    80005d60:	fc26                	sd	s1,56(sp)
    80005d62:	f84a                	sd	s2,48(sp)
    80005d64:	f44e                	sd	s3,40(sp)
    80005d66:	f052                	sd	s4,32(sp)
    80005d68:	ec56                	sd	s5,24(sp)
    80005d6a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d6c:	04c05763          	blez	a2,80005dba <consolewrite+0x60>
    80005d70:	8a2a                	mv	s4,a0
    80005d72:	84ae                	mv	s1,a1
    80005d74:	89b2                	mv	s3,a2
    80005d76:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d78:	5afd                	li	s5,-1
    80005d7a:	4685                	li	a3,1
    80005d7c:	8626                	mv	a2,s1
    80005d7e:	85d2                	mv	a1,s4
    80005d80:	fbf40513          	addi	a0,s0,-65
    80005d84:	ffffc097          	auipc	ra,0xffffc
    80005d88:	c90080e7          	jalr	-880(ra) # 80001a14 <either_copyin>
    80005d8c:	01550d63          	beq	a0,s5,80005da6 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005d90:	fbf44503          	lbu	a0,-65(s0)
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	77e080e7          	jalr	1918(ra) # 80006512 <uartputc>
  for(i = 0; i < n; i++){
    80005d9c:	2905                	addiw	s2,s2,1
    80005d9e:	0485                	addi	s1,s1,1
    80005da0:	fd299de3          	bne	s3,s2,80005d7a <consolewrite+0x20>
    80005da4:	894e                	mv	s2,s3
  }

  return i;
}
    80005da6:	854a                	mv	a0,s2
    80005da8:	60a6                	ld	ra,72(sp)
    80005daa:	6406                	ld	s0,64(sp)
    80005dac:	74e2                	ld	s1,56(sp)
    80005dae:	7942                	ld	s2,48(sp)
    80005db0:	79a2                	ld	s3,40(sp)
    80005db2:	7a02                	ld	s4,32(sp)
    80005db4:	6ae2                	ld	s5,24(sp)
    80005db6:	6161                	addi	sp,sp,80
    80005db8:	8082                	ret
  for(i = 0; i < n; i++){
    80005dba:	4901                	li	s2,0
    80005dbc:	b7ed                	j	80005da6 <consolewrite+0x4c>

0000000080005dbe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005dbe:	7159                	addi	sp,sp,-112
    80005dc0:	f486                	sd	ra,104(sp)
    80005dc2:	f0a2                	sd	s0,96(sp)
    80005dc4:	eca6                	sd	s1,88(sp)
    80005dc6:	e8ca                	sd	s2,80(sp)
    80005dc8:	e4ce                	sd	s3,72(sp)
    80005dca:	e0d2                	sd	s4,64(sp)
    80005dcc:	fc56                	sd	s5,56(sp)
    80005dce:	f85a                	sd	s6,48(sp)
    80005dd0:	f45e                	sd	s7,40(sp)
    80005dd2:	f062                	sd	s8,32(sp)
    80005dd4:	ec66                	sd	s9,24(sp)
    80005dd6:	e86a                	sd	s10,16(sp)
    80005dd8:	1880                	addi	s0,sp,112
    80005dda:	8aaa                	mv	s5,a0
    80005ddc:	8a2e                	mv	s4,a1
    80005dde:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005de0:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005de4:	00024517          	auipc	a0,0x24
    80005de8:	38c50513          	addi	a0,a0,908 # 8002a170 <cons>
    80005dec:	00001097          	auipc	ra,0x1
    80005df0:	8ca080e7          	jalr	-1846(ra) # 800066b6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005df4:	00024497          	auipc	s1,0x24
    80005df8:	37c48493          	addi	s1,s1,892 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005dfc:	00024917          	auipc	s2,0x24
    80005e00:	41490913          	addi	s2,s2,1044 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005e04:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e06:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005e08:	4ca9                	li	s9,10
  while(n > 0){
    80005e0a:	07305863          	blez	s3,80005e7a <consoleread+0xbc>
    while(cons.r == cons.w){
    80005e0e:	0a04a783          	lw	a5,160(s1)
    80005e12:	0a44a703          	lw	a4,164(s1)
    80005e16:	02f71463          	bne	a4,a5,80005e3e <consoleread+0x80>
      if(myproc()->killed){
    80005e1a:	ffffb097          	auipc	ra,0xffffb
    80005e1e:	13c080e7          	jalr	316(ra) # 80000f56 <myproc>
    80005e22:	591c                	lw	a5,48(a0)
    80005e24:	e7b5                	bnez	a5,80005e90 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005e26:	85a6                	mv	a1,s1
    80005e28:	854a                	mv	a0,s2
    80005e2a:	ffffb097          	auipc	ra,0xffffb
    80005e2e:	7f0080e7          	jalr	2032(ra) # 8000161a <sleep>
    while(cons.r == cons.w){
    80005e32:	0a04a783          	lw	a5,160(s1)
    80005e36:	0a44a703          	lw	a4,164(s1)
    80005e3a:	fef700e3          	beq	a4,a5,80005e1a <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005e3e:	0017871b          	addiw	a4,a5,1
    80005e42:	0ae4a023          	sw	a4,160(s1)
    80005e46:	07f7f713          	andi	a4,a5,127
    80005e4a:	9726                	add	a4,a4,s1
    80005e4c:	02074703          	lbu	a4,32(a4)
    80005e50:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005e54:	077d0563          	beq	s10,s7,80005ebe <consoleread+0x100>
    cbuf = c;
    80005e58:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e5c:	4685                	li	a3,1
    80005e5e:	f9f40613          	addi	a2,s0,-97
    80005e62:	85d2                	mv	a1,s4
    80005e64:	8556                	mv	a0,s5
    80005e66:	ffffc097          	auipc	ra,0xffffc
    80005e6a:	b58080e7          	jalr	-1192(ra) # 800019be <either_copyout>
    80005e6e:	01850663          	beq	a0,s8,80005e7a <consoleread+0xbc>
    dst++;
    80005e72:	0a05                	addi	s4,s4,1
    --n;
    80005e74:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005e76:	f99d1ae3          	bne	s10,s9,80005e0a <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005e7a:	00024517          	auipc	a0,0x24
    80005e7e:	2f650513          	addi	a0,a0,758 # 8002a170 <cons>
    80005e82:	00001097          	auipc	ra,0x1
    80005e86:	904080e7          	jalr	-1788(ra) # 80006786 <release>

  return target - n;
    80005e8a:	413b053b          	subw	a0,s6,s3
    80005e8e:	a811                	j	80005ea2 <consoleread+0xe4>
        release(&cons.lock);
    80005e90:	00024517          	auipc	a0,0x24
    80005e94:	2e050513          	addi	a0,a0,736 # 8002a170 <cons>
    80005e98:	00001097          	auipc	ra,0x1
    80005e9c:	8ee080e7          	jalr	-1810(ra) # 80006786 <release>
        return -1;
    80005ea0:	557d                	li	a0,-1
}
    80005ea2:	70a6                	ld	ra,104(sp)
    80005ea4:	7406                	ld	s0,96(sp)
    80005ea6:	64e6                	ld	s1,88(sp)
    80005ea8:	6946                	ld	s2,80(sp)
    80005eaa:	69a6                	ld	s3,72(sp)
    80005eac:	6a06                	ld	s4,64(sp)
    80005eae:	7ae2                	ld	s5,56(sp)
    80005eb0:	7b42                	ld	s6,48(sp)
    80005eb2:	7ba2                	ld	s7,40(sp)
    80005eb4:	7c02                	ld	s8,32(sp)
    80005eb6:	6ce2                	ld	s9,24(sp)
    80005eb8:	6d42                	ld	s10,16(sp)
    80005eba:	6165                	addi	sp,sp,112
    80005ebc:	8082                	ret
      if(n < target){
    80005ebe:	0009871b          	sext.w	a4,s3
    80005ec2:	fb677ce3          	bgeu	a4,s6,80005e7a <consoleread+0xbc>
        cons.r--;
    80005ec6:	00024717          	auipc	a4,0x24
    80005eca:	34f72523          	sw	a5,842(a4) # 8002a210 <cons+0xa0>
    80005ece:	b775                	j	80005e7a <consoleread+0xbc>

0000000080005ed0 <consputc>:
{
    80005ed0:	1141                	addi	sp,sp,-16
    80005ed2:	e406                	sd	ra,8(sp)
    80005ed4:	e022                	sd	s0,0(sp)
    80005ed6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ed8:	10000793          	li	a5,256
    80005edc:	00f50a63          	beq	a0,a5,80005ef0 <consputc+0x20>
    uartputc_sync(c);
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	560080e7          	jalr	1376(ra) # 80006440 <uartputc_sync>
}
    80005ee8:	60a2                	ld	ra,8(sp)
    80005eea:	6402                	ld	s0,0(sp)
    80005eec:	0141                	addi	sp,sp,16
    80005eee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ef0:	4521                	li	a0,8
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	54e080e7          	jalr	1358(ra) # 80006440 <uartputc_sync>
    80005efa:	02000513          	li	a0,32
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	542080e7          	jalr	1346(ra) # 80006440 <uartputc_sync>
    80005f06:	4521                	li	a0,8
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	538080e7          	jalr	1336(ra) # 80006440 <uartputc_sync>
    80005f10:	bfe1                	j	80005ee8 <consputc+0x18>

0000000080005f12 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005f12:	1101                	addi	sp,sp,-32
    80005f14:	ec06                	sd	ra,24(sp)
    80005f16:	e822                	sd	s0,16(sp)
    80005f18:	e426                	sd	s1,8(sp)
    80005f1a:	e04a                	sd	s2,0(sp)
    80005f1c:	1000                	addi	s0,sp,32
    80005f1e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005f20:	00024517          	auipc	a0,0x24
    80005f24:	25050513          	addi	a0,a0,592 # 8002a170 <cons>
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	78e080e7          	jalr	1934(ra) # 800066b6 <acquire>

  switch(c){
    80005f30:	47d5                	li	a5,21
    80005f32:	0af48663          	beq	s1,a5,80005fde <consoleintr+0xcc>
    80005f36:	0297ca63          	blt	a5,s1,80005f6a <consoleintr+0x58>
    80005f3a:	47a1                	li	a5,8
    80005f3c:	0ef48763          	beq	s1,a5,8000602a <consoleintr+0x118>
    80005f40:	47c1                	li	a5,16
    80005f42:	10f49a63          	bne	s1,a5,80006056 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005f46:	ffffc097          	auipc	ra,0xffffc
    80005f4a:	b24080e7          	jalr	-1244(ra) # 80001a6a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f4e:	00024517          	auipc	a0,0x24
    80005f52:	22250513          	addi	a0,a0,546 # 8002a170 <cons>
    80005f56:	00001097          	auipc	ra,0x1
    80005f5a:	830080e7          	jalr	-2000(ra) # 80006786 <release>
}
    80005f5e:	60e2                	ld	ra,24(sp)
    80005f60:	6442                	ld	s0,16(sp)
    80005f62:	64a2                	ld	s1,8(sp)
    80005f64:	6902                	ld	s2,0(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret
  switch(c){
    80005f6a:	07f00793          	li	a5,127
    80005f6e:	0af48e63          	beq	s1,a5,8000602a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f72:	00024717          	auipc	a4,0x24
    80005f76:	1fe70713          	addi	a4,a4,510 # 8002a170 <cons>
    80005f7a:	0a872783          	lw	a5,168(a4)
    80005f7e:	0a072703          	lw	a4,160(a4)
    80005f82:	9f99                	subw	a5,a5,a4
    80005f84:	07f00713          	li	a4,127
    80005f88:	fcf763e3          	bltu	a4,a5,80005f4e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f8c:	47b5                	li	a5,13
    80005f8e:	0cf48763          	beq	s1,a5,8000605c <consoleintr+0x14a>
      consputc(c);
    80005f92:	8526                	mv	a0,s1
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	f3c080e7          	jalr	-196(ra) # 80005ed0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f9c:	00024797          	auipc	a5,0x24
    80005fa0:	1d478793          	addi	a5,a5,468 # 8002a170 <cons>
    80005fa4:	0a87a703          	lw	a4,168(a5)
    80005fa8:	0017069b          	addiw	a3,a4,1
    80005fac:	0006861b          	sext.w	a2,a3
    80005fb0:	0ad7a423          	sw	a3,168(a5)
    80005fb4:	07f77713          	andi	a4,a4,127
    80005fb8:	97ba                	add	a5,a5,a4
    80005fba:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005fbe:	47a9                	li	a5,10
    80005fc0:	0cf48563          	beq	s1,a5,8000608a <consoleintr+0x178>
    80005fc4:	4791                	li	a5,4
    80005fc6:	0cf48263          	beq	s1,a5,8000608a <consoleintr+0x178>
    80005fca:	00024797          	auipc	a5,0x24
    80005fce:	2467a783          	lw	a5,582(a5) # 8002a210 <cons+0xa0>
    80005fd2:	0807879b          	addiw	a5,a5,128
    80005fd6:	f6f61ce3          	bne	a2,a5,80005f4e <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fda:	863e                	mv	a2,a5
    80005fdc:	a07d                	j	8000608a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005fde:	00024717          	auipc	a4,0x24
    80005fe2:	19270713          	addi	a4,a4,402 # 8002a170 <cons>
    80005fe6:	0a872783          	lw	a5,168(a4)
    80005fea:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fee:	00024497          	auipc	s1,0x24
    80005ff2:	18248493          	addi	s1,s1,386 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80005ff6:	4929                	li	s2,10
    80005ff8:	f4f70be3          	beq	a4,a5,80005f4e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ffc:	37fd                	addiw	a5,a5,-1
    80005ffe:	07f7f713          	andi	a4,a5,127
    80006002:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006004:	02074703          	lbu	a4,32(a4)
    80006008:	f52703e3          	beq	a4,s2,80005f4e <consoleintr+0x3c>
      cons.e--;
    8000600c:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80006010:	10000513          	li	a0,256
    80006014:	00000097          	auipc	ra,0x0
    80006018:	ebc080e7          	jalr	-324(ra) # 80005ed0 <consputc>
    while(cons.e != cons.w &&
    8000601c:	0a84a783          	lw	a5,168(s1)
    80006020:	0a44a703          	lw	a4,164(s1)
    80006024:	fcf71ce3          	bne	a4,a5,80005ffc <consoleintr+0xea>
    80006028:	b71d                	j	80005f4e <consoleintr+0x3c>
    if(cons.e != cons.w){
    8000602a:	00024717          	auipc	a4,0x24
    8000602e:	14670713          	addi	a4,a4,326 # 8002a170 <cons>
    80006032:	0a872783          	lw	a5,168(a4)
    80006036:	0a472703          	lw	a4,164(a4)
    8000603a:	f0f70ae3          	beq	a4,a5,80005f4e <consoleintr+0x3c>
      cons.e--;
    8000603e:	37fd                	addiw	a5,a5,-1
    80006040:	00024717          	auipc	a4,0x24
    80006044:	1cf72c23          	sw	a5,472(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80006048:	10000513          	li	a0,256
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	e84080e7          	jalr	-380(ra) # 80005ed0 <consputc>
    80006054:	bded                	j	80005f4e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006056:	ee048ce3          	beqz	s1,80005f4e <consoleintr+0x3c>
    8000605a:	bf21                	j	80005f72 <consoleintr+0x60>
      consputc(c);
    8000605c:	4529                	li	a0,10
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	e72080e7          	jalr	-398(ra) # 80005ed0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006066:	00024797          	auipc	a5,0x24
    8000606a:	10a78793          	addi	a5,a5,266 # 8002a170 <cons>
    8000606e:	0a87a703          	lw	a4,168(a5)
    80006072:	0017069b          	addiw	a3,a4,1
    80006076:	0006861b          	sext.w	a2,a3
    8000607a:	0ad7a423          	sw	a3,168(a5)
    8000607e:	07f77713          	andi	a4,a4,127
    80006082:	97ba                	add	a5,a5,a4
    80006084:	4729                	li	a4,10
    80006086:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000608a:	00024797          	auipc	a5,0x24
    8000608e:	18c7a523          	sw	a2,394(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80006092:	00024517          	auipc	a0,0x24
    80006096:	17e50513          	addi	a0,a0,382 # 8002a210 <cons+0xa0>
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	70c080e7          	jalr	1804(ra) # 800017a6 <wakeup>
    800060a2:	b575                	j	80005f4e <consoleintr+0x3c>

00000000800060a4 <consoleinit>:

void
consoleinit(void)
{
    800060a4:	1141                	addi	sp,sp,-16
    800060a6:	e406                	sd	ra,8(sp)
    800060a8:	e022                	sd	s0,0(sp)
    800060aa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800060ac:	00002597          	auipc	a1,0x2
    800060b0:	72c58593          	addi	a1,a1,1836 # 800087d8 <digits+0x18>
    800060b4:	00024517          	auipc	a0,0x24
    800060b8:	0bc50513          	addi	a0,a0,188 # 8002a170 <cons>
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	776080e7          	jalr	1910(ra) # 80006832 <initlock>

  uartinit();
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	32c080e7          	jalr	812(ra) # 800063f0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800060cc:	00017797          	auipc	a5,0x17
    800060d0:	d4c78793          	addi	a5,a5,-692 # 8001ce18 <devsw>
    800060d4:	00000717          	auipc	a4,0x0
    800060d8:	cea70713          	addi	a4,a4,-790 # 80005dbe <consoleread>
    800060dc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800060de:	00000717          	auipc	a4,0x0
    800060e2:	c7c70713          	addi	a4,a4,-900 # 80005d5a <consolewrite>
    800060e6:	ef98                	sd	a4,24(a5)
}
    800060e8:	60a2                	ld	ra,8(sp)
    800060ea:	6402                	ld	s0,0(sp)
    800060ec:	0141                	addi	sp,sp,16
    800060ee:	8082                	ret

00000000800060f0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800060f0:	7179                	addi	sp,sp,-48
    800060f2:	f406                	sd	ra,40(sp)
    800060f4:	f022                	sd	s0,32(sp)
    800060f6:	ec26                	sd	s1,24(sp)
    800060f8:	e84a                	sd	s2,16(sp)
    800060fa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060fc:	c219                	beqz	a2,80006102 <printint+0x12>
    800060fe:	08054763          	bltz	a0,8000618c <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006102:	2501                	sext.w	a0,a0
    80006104:	4881                	li	a7,0
    80006106:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000610a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000610c:	2581                	sext.w	a1,a1
    8000610e:	00002617          	auipc	a2,0x2
    80006112:	6e260613          	addi	a2,a2,1762 # 800087f0 <digits>
    80006116:	883a                	mv	a6,a4
    80006118:	2705                	addiw	a4,a4,1
    8000611a:	02b577bb          	remuw	a5,a0,a1
    8000611e:	1782                	slli	a5,a5,0x20
    80006120:	9381                	srli	a5,a5,0x20
    80006122:	97b2                	add	a5,a5,a2
    80006124:	0007c783          	lbu	a5,0(a5)
    80006128:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000612c:	0005079b          	sext.w	a5,a0
    80006130:	02b5553b          	divuw	a0,a0,a1
    80006134:	0685                	addi	a3,a3,1
    80006136:	feb7f0e3          	bgeu	a5,a1,80006116 <printint+0x26>

  if(sign)
    8000613a:	00088c63          	beqz	a7,80006152 <printint+0x62>
    buf[i++] = '-';
    8000613e:	fe070793          	addi	a5,a4,-32
    80006142:	00878733          	add	a4,a5,s0
    80006146:	02d00793          	li	a5,45
    8000614a:	fef70823          	sb	a5,-16(a4)
    8000614e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006152:	02e05763          	blez	a4,80006180 <printint+0x90>
    80006156:	fd040793          	addi	a5,s0,-48
    8000615a:	00e784b3          	add	s1,a5,a4
    8000615e:	fff78913          	addi	s2,a5,-1
    80006162:	993a                	add	s2,s2,a4
    80006164:	377d                	addiw	a4,a4,-1
    80006166:	1702                	slli	a4,a4,0x20
    80006168:	9301                	srli	a4,a4,0x20
    8000616a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000616e:	fff4c503          	lbu	a0,-1(s1)
    80006172:	00000097          	auipc	ra,0x0
    80006176:	d5e080e7          	jalr	-674(ra) # 80005ed0 <consputc>
  while(--i >= 0)
    8000617a:	14fd                	addi	s1,s1,-1
    8000617c:	ff2499e3          	bne	s1,s2,8000616e <printint+0x7e>
}
    80006180:	70a2                	ld	ra,40(sp)
    80006182:	7402                	ld	s0,32(sp)
    80006184:	64e2                	ld	s1,24(sp)
    80006186:	6942                	ld	s2,16(sp)
    80006188:	6145                	addi	sp,sp,48
    8000618a:	8082                	ret
    x = -xx;
    8000618c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006190:	4885                	li	a7,1
    x = -xx;
    80006192:	bf95                	j	80006106 <printint+0x16>

0000000080006194 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006194:	1101                	addi	sp,sp,-32
    80006196:	ec06                	sd	ra,24(sp)
    80006198:	e822                	sd	s0,16(sp)
    8000619a:	e426                	sd	s1,8(sp)
    8000619c:	1000                	addi	s0,sp,32
    8000619e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800061a0:	00024797          	auipc	a5,0x24
    800061a4:	0a07a023          	sw	zero,160(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    800061a8:	00002517          	auipc	a0,0x2
    800061ac:	63850513          	addi	a0,a0,1592 # 800087e0 <digits+0x20>
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	02e080e7          	jalr	46(ra) # 800061de <printf>
  printf(s);
    800061b8:	8526                	mv	a0,s1
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	024080e7          	jalr	36(ra) # 800061de <printf>
  printf("\n");
    800061c2:	00002517          	auipc	a0,0x2
    800061c6:	6b650513          	addi	a0,a0,1718 # 80008878 <digits+0x88>
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	014080e7          	jalr	20(ra) # 800061de <printf>
  panicked = 1; // freeze uart output from other CPUs
    800061d2:	4785                	li	a5,1
    800061d4:	00003717          	auipc	a4,0x3
    800061d8:	e4f72423          	sw	a5,-440(a4) # 8000901c <panicked>
  for(;;)
    800061dc:	a001                	j	800061dc <panic+0x48>

00000000800061de <printf>:
{
    800061de:	7131                	addi	sp,sp,-192
    800061e0:	fc86                	sd	ra,120(sp)
    800061e2:	f8a2                	sd	s0,112(sp)
    800061e4:	f4a6                	sd	s1,104(sp)
    800061e6:	f0ca                	sd	s2,96(sp)
    800061e8:	ecce                	sd	s3,88(sp)
    800061ea:	e8d2                	sd	s4,80(sp)
    800061ec:	e4d6                	sd	s5,72(sp)
    800061ee:	e0da                	sd	s6,64(sp)
    800061f0:	fc5e                	sd	s7,56(sp)
    800061f2:	f862                	sd	s8,48(sp)
    800061f4:	f466                	sd	s9,40(sp)
    800061f6:	f06a                	sd	s10,32(sp)
    800061f8:	ec6e                	sd	s11,24(sp)
    800061fa:	0100                	addi	s0,sp,128
    800061fc:	8a2a                	mv	s4,a0
    800061fe:	e40c                	sd	a1,8(s0)
    80006200:	e810                	sd	a2,16(s0)
    80006202:	ec14                	sd	a3,24(s0)
    80006204:	f018                	sd	a4,32(s0)
    80006206:	f41c                	sd	a5,40(s0)
    80006208:	03043823          	sd	a6,48(s0)
    8000620c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006210:	00024d97          	auipc	s11,0x24
    80006214:	030dad83          	lw	s11,48(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006218:	020d9b63          	bnez	s11,8000624e <printf+0x70>
  if (fmt == 0)
    8000621c:	040a0263          	beqz	s4,80006260 <printf+0x82>
  va_start(ap, fmt);
    80006220:	00840793          	addi	a5,s0,8
    80006224:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006228:	000a4503          	lbu	a0,0(s4)
    8000622c:	14050f63          	beqz	a0,8000638a <printf+0x1ac>
    80006230:	4981                	li	s3,0
    if(c != '%'){
    80006232:	02500a93          	li	s5,37
    switch(c){
    80006236:	07000b93          	li	s7,112
  consputc('x');
    8000623a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000623c:	00002b17          	auipc	s6,0x2
    80006240:	5b4b0b13          	addi	s6,s6,1460 # 800087f0 <digits>
    switch(c){
    80006244:	07300c93          	li	s9,115
    80006248:	06400c13          	li	s8,100
    8000624c:	a82d                	j	80006286 <printf+0xa8>
    acquire(&pr.lock);
    8000624e:	00024517          	auipc	a0,0x24
    80006252:	fd250513          	addi	a0,a0,-46 # 8002a220 <pr>
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	460080e7          	jalr	1120(ra) # 800066b6 <acquire>
    8000625e:	bf7d                	j	8000621c <printf+0x3e>
    panic("null fmt");
    80006260:	00002517          	auipc	a0,0x2
    80006264:	55050513          	addi	a0,a0,1360 # 800087b0 <syscalls+0x3e8>
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	f2c080e7          	jalr	-212(ra) # 80006194 <panic>
      consputc(c);
    80006270:	00000097          	auipc	ra,0x0
    80006274:	c60080e7          	jalr	-928(ra) # 80005ed0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006278:	2985                	addiw	s3,s3,1
    8000627a:	013a07b3          	add	a5,s4,s3
    8000627e:	0007c503          	lbu	a0,0(a5)
    80006282:	10050463          	beqz	a0,8000638a <printf+0x1ac>
    if(c != '%'){
    80006286:	ff5515e3          	bne	a0,s5,80006270 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000628a:	2985                	addiw	s3,s3,1
    8000628c:	013a07b3          	add	a5,s4,s3
    80006290:	0007c783          	lbu	a5,0(a5)
    80006294:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006298:	cbed                	beqz	a5,8000638a <printf+0x1ac>
    switch(c){
    8000629a:	05778a63          	beq	a5,s7,800062ee <printf+0x110>
    8000629e:	02fbf663          	bgeu	s7,a5,800062ca <printf+0xec>
    800062a2:	09978863          	beq	a5,s9,80006332 <printf+0x154>
    800062a6:	07800713          	li	a4,120
    800062aa:	0ce79563          	bne	a5,a4,80006374 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800062ae:	f8843783          	ld	a5,-120(s0)
    800062b2:	00878713          	addi	a4,a5,8
    800062b6:	f8e43423          	sd	a4,-120(s0)
    800062ba:	4605                	li	a2,1
    800062bc:	85ea                	mv	a1,s10
    800062be:	4388                	lw	a0,0(a5)
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	e30080e7          	jalr	-464(ra) # 800060f0 <printint>
      break;
    800062c8:	bf45                	j	80006278 <printf+0x9a>
    switch(c){
    800062ca:	09578f63          	beq	a5,s5,80006368 <printf+0x18a>
    800062ce:	0b879363          	bne	a5,s8,80006374 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800062d2:	f8843783          	ld	a5,-120(s0)
    800062d6:	00878713          	addi	a4,a5,8
    800062da:	f8e43423          	sd	a4,-120(s0)
    800062de:	4605                	li	a2,1
    800062e0:	45a9                	li	a1,10
    800062e2:	4388                	lw	a0,0(a5)
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	e0c080e7          	jalr	-500(ra) # 800060f0 <printint>
      break;
    800062ec:	b771                	j	80006278 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800062ee:	f8843783          	ld	a5,-120(s0)
    800062f2:	00878713          	addi	a4,a5,8
    800062f6:	f8e43423          	sd	a4,-120(s0)
    800062fa:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800062fe:	03000513          	li	a0,48
    80006302:	00000097          	auipc	ra,0x0
    80006306:	bce080e7          	jalr	-1074(ra) # 80005ed0 <consputc>
  consputc('x');
    8000630a:	07800513          	li	a0,120
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	bc2080e7          	jalr	-1086(ra) # 80005ed0 <consputc>
    80006316:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006318:	03c95793          	srli	a5,s2,0x3c
    8000631c:	97da                	add	a5,a5,s6
    8000631e:	0007c503          	lbu	a0,0(a5)
    80006322:	00000097          	auipc	ra,0x0
    80006326:	bae080e7          	jalr	-1106(ra) # 80005ed0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000632a:	0912                	slli	s2,s2,0x4
    8000632c:	34fd                	addiw	s1,s1,-1
    8000632e:	f4ed                	bnez	s1,80006318 <printf+0x13a>
    80006330:	b7a1                	j	80006278 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006332:	f8843783          	ld	a5,-120(s0)
    80006336:	00878713          	addi	a4,a5,8
    8000633a:	f8e43423          	sd	a4,-120(s0)
    8000633e:	6384                	ld	s1,0(a5)
    80006340:	cc89                	beqz	s1,8000635a <printf+0x17c>
      for(; *s; s++)
    80006342:	0004c503          	lbu	a0,0(s1)
    80006346:	d90d                	beqz	a0,80006278 <printf+0x9a>
        consputc(*s);
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	b88080e7          	jalr	-1144(ra) # 80005ed0 <consputc>
      for(; *s; s++)
    80006350:	0485                	addi	s1,s1,1
    80006352:	0004c503          	lbu	a0,0(s1)
    80006356:	f96d                	bnez	a0,80006348 <printf+0x16a>
    80006358:	b705                	j	80006278 <printf+0x9a>
        s = "(null)";
    8000635a:	00002497          	auipc	s1,0x2
    8000635e:	44e48493          	addi	s1,s1,1102 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80006362:	02800513          	li	a0,40
    80006366:	b7cd                	j	80006348 <printf+0x16a>
      consputc('%');
    80006368:	8556                	mv	a0,s5
    8000636a:	00000097          	auipc	ra,0x0
    8000636e:	b66080e7          	jalr	-1178(ra) # 80005ed0 <consputc>
      break;
    80006372:	b719                	j	80006278 <printf+0x9a>
      consputc('%');
    80006374:	8556                	mv	a0,s5
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	b5a080e7          	jalr	-1190(ra) # 80005ed0 <consputc>
      consputc(c);
    8000637e:	8526                	mv	a0,s1
    80006380:	00000097          	auipc	ra,0x0
    80006384:	b50080e7          	jalr	-1200(ra) # 80005ed0 <consputc>
      break;
    80006388:	bdc5                	j	80006278 <printf+0x9a>
  if(locking)
    8000638a:	020d9163          	bnez	s11,800063ac <printf+0x1ce>
}
    8000638e:	70e6                	ld	ra,120(sp)
    80006390:	7446                	ld	s0,112(sp)
    80006392:	74a6                	ld	s1,104(sp)
    80006394:	7906                	ld	s2,96(sp)
    80006396:	69e6                	ld	s3,88(sp)
    80006398:	6a46                	ld	s4,80(sp)
    8000639a:	6aa6                	ld	s5,72(sp)
    8000639c:	6b06                	ld	s6,64(sp)
    8000639e:	7be2                	ld	s7,56(sp)
    800063a0:	7c42                	ld	s8,48(sp)
    800063a2:	7ca2                	ld	s9,40(sp)
    800063a4:	7d02                	ld	s10,32(sp)
    800063a6:	6de2                	ld	s11,24(sp)
    800063a8:	6129                	addi	sp,sp,192
    800063aa:	8082                	ret
    release(&pr.lock);
    800063ac:	00024517          	auipc	a0,0x24
    800063b0:	e7450513          	addi	a0,a0,-396 # 8002a220 <pr>
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	3d2080e7          	jalr	978(ra) # 80006786 <release>
}
    800063bc:	bfc9                	j	8000638e <printf+0x1b0>

00000000800063be <printfinit>:
    ;
}

void
printfinit(void)
{
    800063be:	1101                	addi	sp,sp,-32
    800063c0:	ec06                	sd	ra,24(sp)
    800063c2:	e822                	sd	s0,16(sp)
    800063c4:	e426                	sd	s1,8(sp)
    800063c6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800063c8:	00024497          	auipc	s1,0x24
    800063cc:	e5848493          	addi	s1,s1,-424 # 8002a220 <pr>
    800063d0:	00002597          	auipc	a1,0x2
    800063d4:	41858593          	addi	a1,a1,1048 # 800087e8 <digits+0x28>
    800063d8:	8526                	mv	a0,s1
    800063da:	00000097          	auipc	ra,0x0
    800063de:	458080e7          	jalr	1112(ra) # 80006832 <initlock>
  pr.locking = 1;
    800063e2:	4785                	li	a5,1
    800063e4:	d09c                	sw	a5,32(s1)
}
    800063e6:	60e2                	ld	ra,24(sp)
    800063e8:	6442                	ld	s0,16(sp)
    800063ea:	64a2                	ld	s1,8(sp)
    800063ec:	6105                	addi	sp,sp,32
    800063ee:	8082                	ret

00000000800063f0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800063f0:	1141                	addi	sp,sp,-16
    800063f2:	e406                	sd	ra,8(sp)
    800063f4:	e022                	sd	s0,0(sp)
    800063f6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063f8:	100007b7          	lui	a5,0x10000
    800063fc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006400:	f8000713          	li	a4,-128
    80006404:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006408:	470d                	li	a4,3
    8000640a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000640e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006412:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006416:	469d                	li	a3,7
    80006418:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000641c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006420:	00002597          	auipc	a1,0x2
    80006424:	3e858593          	addi	a1,a1,1000 # 80008808 <digits+0x18>
    80006428:	00024517          	auipc	a0,0x24
    8000642c:	e2050513          	addi	a0,a0,-480 # 8002a248 <uart_tx_lock>
    80006430:	00000097          	auipc	ra,0x0
    80006434:	402080e7          	jalr	1026(ra) # 80006832 <initlock>
}
    80006438:	60a2                	ld	ra,8(sp)
    8000643a:	6402                	ld	s0,0(sp)
    8000643c:	0141                	addi	sp,sp,16
    8000643e:	8082                	ret

0000000080006440 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006440:	1101                	addi	sp,sp,-32
    80006442:	ec06                	sd	ra,24(sp)
    80006444:	e822                	sd	s0,16(sp)
    80006446:	e426                	sd	s1,8(sp)
    80006448:	1000                	addi	s0,sp,32
    8000644a:	84aa                	mv	s1,a0
  push_off();
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	21e080e7          	jalr	542(ra) # 8000666a <push_off>

  if(panicked){
    80006454:	00003797          	auipc	a5,0x3
    80006458:	bc87a783          	lw	a5,-1080(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000645c:	10000737          	lui	a4,0x10000
  if(panicked){
    80006460:	c391                	beqz	a5,80006464 <uartputc_sync+0x24>
    for(;;)
    80006462:	a001                	j	80006462 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006464:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006468:	0207f793          	andi	a5,a5,32
    8000646c:	dfe5                	beqz	a5,80006464 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000646e:	0ff4f513          	zext.b	a0,s1
    80006472:	100007b7          	lui	a5,0x10000
    80006476:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	2ac080e7          	jalr	684(ra) # 80006726 <pop_off>
}
    80006482:	60e2                	ld	ra,24(sp)
    80006484:	6442                	ld	s0,16(sp)
    80006486:	64a2                	ld	s1,8(sp)
    80006488:	6105                	addi	sp,sp,32
    8000648a:	8082                	ret

000000008000648c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000648c:	00003797          	auipc	a5,0x3
    80006490:	b947b783          	ld	a5,-1132(a5) # 80009020 <uart_tx_r>
    80006494:	00003717          	auipc	a4,0x3
    80006498:	b9473703          	ld	a4,-1132(a4) # 80009028 <uart_tx_w>
    8000649c:	06f70a63          	beq	a4,a5,80006510 <uartstart+0x84>
{
    800064a0:	7139                	addi	sp,sp,-64
    800064a2:	fc06                	sd	ra,56(sp)
    800064a4:	f822                	sd	s0,48(sp)
    800064a6:	f426                	sd	s1,40(sp)
    800064a8:	f04a                	sd	s2,32(sp)
    800064aa:	ec4e                	sd	s3,24(sp)
    800064ac:	e852                	sd	s4,16(sp)
    800064ae:	e456                	sd	s5,8(sp)
    800064b0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064b2:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064b6:	00024a17          	auipc	s4,0x24
    800064ba:	d92a0a13          	addi	s4,s4,-622 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    800064be:	00003497          	auipc	s1,0x3
    800064c2:	b6248493          	addi	s1,s1,-1182 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800064c6:	00003997          	auipc	s3,0x3
    800064ca:	b6298993          	addi	s3,s3,-1182 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064ce:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800064d2:	02077713          	andi	a4,a4,32
    800064d6:	c705                	beqz	a4,800064fe <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064d8:	01f7f713          	andi	a4,a5,31
    800064dc:	9752                	add	a4,a4,s4
    800064de:	02074a83          	lbu	s5,32(a4)
    uart_tx_r += 1;
    800064e2:	0785                	addi	a5,a5,1
    800064e4:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800064e6:	8526                	mv	a0,s1
    800064e8:	ffffb097          	auipc	ra,0xffffb
    800064ec:	2be080e7          	jalr	702(ra) # 800017a6 <wakeup>
    
    WriteReg(THR, c);
    800064f0:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800064f4:	609c                	ld	a5,0(s1)
    800064f6:	0009b703          	ld	a4,0(s3)
    800064fa:	fcf71ae3          	bne	a4,a5,800064ce <uartstart+0x42>
  }
}
    800064fe:	70e2                	ld	ra,56(sp)
    80006500:	7442                	ld	s0,48(sp)
    80006502:	74a2                	ld	s1,40(sp)
    80006504:	7902                	ld	s2,32(sp)
    80006506:	69e2                	ld	s3,24(sp)
    80006508:	6a42                	ld	s4,16(sp)
    8000650a:	6aa2                	ld	s5,8(sp)
    8000650c:	6121                	addi	sp,sp,64
    8000650e:	8082                	ret
    80006510:	8082                	ret

0000000080006512 <uartputc>:
{
    80006512:	7179                	addi	sp,sp,-48
    80006514:	f406                	sd	ra,40(sp)
    80006516:	f022                	sd	s0,32(sp)
    80006518:	ec26                	sd	s1,24(sp)
    8000651a:	e84a                	sd	s2,16(sp)
    8000651c:	e44e                	sd	s3,8(sp)
    8000651e:	e052                	sd	s4,0(sp)
    80006520:	1800                	addi	s0,sp,48
    80006522:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006524:	00024517          	auipc	a0,0x24
    80006528:	d2450513          	addi	a0,a0,-732 # 8002a248 <uart_tx_lock>
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	18a080e7          	jalr	394(ra) # 800066b6 <acquire>
  if(panicked){
    80006534:	00003797          	auipc	a5,0x3
    80006538:	ae87a783          	lw	a5,-1304(a5) # 8000901c <panicked>
    8000653c:	c391                	beqz	a5,80006540 <uartputc+0x2e>
    for(;;)
    8000653e:	a001                	j	8000653e <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006540:	00003717          	auipc	a4,0x3
    80006544:	ae873703          	ld	a4,-1304(a4) # 80009028 <uart_tx_w>
    80006548:	00003797          	auipc	a5,0x3
    8000654c:	ad87b783          	ld	a5,-1320(a5) # 80009020 <uart_tx_r>
    80006550:	02078793          	addi	a5,a5,32
    80006554:	02e79b63          	bne	a5,a4,8000658a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006558:	00024997          	auipc	s3,0x24
    8000655c:	cf098993          	addi	s3,s3,-784 # 8002a248 <uart_tx_lock>
    80006560:	00003497          	auipc	s1,0x3
    80006564:	ac048493          	addi	s1,s1,-1344 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006568:	00003917          	auipc	s2,0x3
    8000656c:	ac090913          	addi	s2,s2,-1344 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006570:	85ce                	mv	a1,s3
    80006572:	8526                	mv	a0,s1
    80006574:	ffffb097          	auipc	ra,0xffffb
    80006578:	0a6080e7          	jalr	166(ra) # 8000161a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000657c:	00093703          	ld	a4,0(s2)
    80006580:	609c                	ld	a5,0(s1)
    80006582:	02078793          	addi	a5,a5,32
    80006586:	fee785e3          	beq	a5,a4,80006570 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000658a:	00024497          	auipc	s1,0x24
    8000658e:	cbe48493          	addi	s1,s1,-834 # 8002a248 <uart_tx_lock>
    80006592:	01f77793          	andi	a5,a4,31
    80006596:	97a6                	add	a5,a5,s1
    80006598:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    8000659c:	0705                	addi	a4,a4,1
    8000659e:	00003797          	auipc	a5,0x3
    800065a2:	a8e7b523          	sd	a4,-1398(a5) # 80009028 <uart_tx_w>
      uartstart();
    800065a6:	00000097          	auipc	ra,0x0
    800065aa:	ee6080e7          	jalr	-282(ra) # 8000648c <uartstart>
      release(&uart_tx_lock);
    800065ae:	8526                	mv	a0,s1
    800065b0:	00000097          	auipc	ra,0x0
    800065b4:	1d6080e7          	jalr	470(ra) # 80006786 <release>
}
    800065b8:	70a2                	ld	ra,40(sp)
    800065ba:	7402                	ld	s0,32(sp)
    800065bc:	64e2                	ld	s1,24(sp)
    800065be:	6942                	ld	s2,16(sp)
    800065c0:	69a2                	ld	s3,8(sp)
    800065c2:	6a02                	ld	s4,0(sp)
    800065c4:	6145                	addi	sp,sp,48
    800065c6:	8082                	ret

00000000800065c8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800065c8:	1141                	addi	sp,sp,-16
    800065ca:	e422                	sd	s0,8(sp)
    800065cc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800065ce:	100007b7          	lui	a5,0x10000
    800065d2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800065d6:	8b85                	andi	a5,a5,1
    800065d8:	cb81                	beqz	a5,800065e8 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800065da:	100007b7          	lui	a5,0x10000
    800065de:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800065e2:	6422                	ld	s0,8(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret
    return -1;
    800065e8:	557d                	li	a0,-1
    800065ea:	bfe5                	j	800065e2 <uartgetc+0x1a>

00000000800065ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800065ec:	1101                	addi	sp,sp,-32
    800065ee:	ec06                	sd	ra,24(sp)
    800065f0:	e822                	sd	s0,16(sp)
    800065f2:	e426                	sd	s1,8(sp)
    800065f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800065f6:	54fd                	li	s1,-1
    800065f8:	a029                	j	80006602 <uartintr+0x16>
      break;
    consoleintr(c);
    800065fa:	00000097          	auipc	ra,0x0
    800065fe:	918080e7          	jalr	-1768(ra) # 80005f12 <consoleintr>
    int c = uartgetc();
    80006602:	00000097          	auipc	ra,0x0
    80006606:	fc6080e7          	jalr	-58(ra) # 800065c8 <uartgetc>
    if(c == -1)
    8000660a:	fe9518e3          	bne	a0,s1,800065fa <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000660e:	00024497          	auipc	s1,0x24
    80006612:	c3a48493          	addi	s1,s1,-966 # 8002a248 <uart_tx_lock>
    80006616:	8526                	mv	a0,s1
    80006618:	00000097          	auipc	ra,0x0
    8000661c:	09e080e7          	jalr	158(ra) # 800066b6 <acquire>
  uartstart();
    80006620:	00000097          	auipc	ra,0x0
    80006624:	e6c080e7          	jalr	-404(ra) # 8000648c <uartstart>
  release(&uart_tx_lock);
    80006628:	8526                	mv	a0,s1
    8000662a:	00000097          	auipc	ra,0x0
    8000662e:	15c080e7          	jalr	348(ra) # 80006786 <release>
}
    80006632:	60e2                	ld	ra,24(sp)
    80006634:	6442                	ld	s0,16(sp)
    80006636:	64a2                	ld	s1,8(sp)
    80006638:	6105                	addi	sp,sp,32
    8000663a:	8082                	ret

000000008000663c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000663c:	411c                	lw	a5,0(a0)
    8000663e:	e399                	bnez	a5,80006644 <holding+0x8>
    80006640:	4501                	li	a0,0
  return r;
}
    80006642:	8082                	ret
{
    80006644:	1101                	addi	sp,sp,-32
    80006646:	ec06                	sd	ra,24(sp)
    80006648:	e822                	sd	s0,16(sp)
    8000664a:	e426                	sd	s1,8(sp)
    8000664c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000664e:	6904                	ld	s1,16(a0)
    80006650:	ffffb097          	auipc	ra,0xffffb
    80006654:	8ea080e7          	jalr	-1814(ra) # 80000f3a <mycpu>
    80006658:	40a48533          	sub	a0,s1,a0
    8000665c:	00153513          	seqz	a0,a0
}
    80006660:	60e2                	ld	ra,24(sp)
    80006662:	6442                	ld	s0,16(sp)
    80006664:	64a2                	ld	s1,8(sp)
    80006666:	6105                	addi	sp,sp,32
    80006668:	8082                	ret

000000008000666a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000666a:	1101                	addi	sp,sp,-32
    8000666c:	ec06                	sd	ra,24(sp)
    8000666e:	e822                	sd	s0,16(sp)
    80006670:	e426                	sd	s1,8(sp)
    80006672:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006674:	100024f3          	csrr	s1,sstatus
    80006678:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000667c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000667e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006682:	ffffb097          	auipc	ra,0xffffb
    80006686:	8b8080e7          	jalr	-1864(ra) # 80000f3a <mycpu>
    8000668a:	5d3c                	lw	a5,120(a0)
    8000668c:	cf89                	beqz	a5,800066a6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000668e:	ffffb097          	auipc	ra,0xffffb
    80006692:	8ac080e7          	jalr	-1876(ra) # 80000f3a <mycpu>
    80006696:	5d3c                	lw	a5,120(a0)
    80006698:	2785                	addiw	a5,a5,1
    8000669a:	dd3c                	sw	a5,120(a0)
}
    8000669c:	60e2                	ld	ra,24(sp)
    8000669e:	6442                	ld	s0,16(sp)
    800066a0:	64a2                	ld	s1,8(sp)
    800066a2:	6105                	addi	sp,sp,32
    800066a4:	8082                	ret
    mycpu()->intena = old;
    800066a6:	ffffb097          	auipc	ra,0xffffb
    800066aa:	894080e7          	jalr	-1900(ra) # 80000f3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800066ae:	8085                	srli	s1,s1,0x1
    800066b0:	8885                	andi	s1,s1,1
    800066b2:	dd64                	sw	s1,124(a0)
    800066b4:	bfe9                	j	8000668e <push_off+0x24>

00000000800066b6 <acquire>:
{
    800066b6:	1101                	addi	sp,sp,-32
    800066b8:	ec06                	sd	ra,24(sp)
    800066ba:	e822                	sd	s0,16(sp)
    800066bc:	e426                	sd	s1,8(sp)
    800066be:	1000                	addi	s0,sp,32
    800066c0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800066c2:	00000097          	auipc	ra,0x0
    800066c6:	fa8080e7          	jalr	-88(ra) # 8000666a <push_off>
  if(holding(lk))
    800066ca:	8526                	mv	a0,s1
    800066cc:	00000097          	auipc	ra,0x0
    800066d0:	f70080e7          	jalr	-144(ra) # 8000663c <holding>
    800066d4:	e911                	bnez	a0,800066e8 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800066d6:	4785                	li	a5,1
    800066d8:	01c48713          	addi	a4,s1,28
    800066dc:	0f50000f          	fence	iorw,ow
    800066e0:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066e4:	4705                	li	a4,1
    800066e6:	a839                	j	80006704 <acquire+0x4e>
    panic("acquire");
    800066e8:	00002517          	auipc	a0,0x2
    800066ec:	12850513          	addi	a0,a0,296 # 80008810 <digits+0x20>
    800066f0:	00000097          	auipc	ra,0x0
    800066f4:	aa4080e7          	jalr	-1372(ra) # 80006194 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800066f8:	01848793          	addi	a5,s1,24
    800066fc:	0f50000f          	fence	iorw,ow
    80006700:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006704:	87ba                	mv	a5,a4
    80006706:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000670a:	2781                	sext.w	a5,a5
    8000670c:	f7f5                	bnez	a5,800066f8 <acquire+0x42>
  __sync_synchronize();
    8000670e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006712:	ffffb097          	auipc	ra,0xffffb
    80006716:	828080e7          	jalr	-2008(ra) # 80000f3a <mycpu>
    8000671a:	e888                	sd	a0,16(s1)
}
    8000671c:	60e2                	ld	ra,24(sp)
    8000671e:	6442                	ld	s0,16(sp)
    80006720:	64a2                	ld	s1,8(sp)
    80006722:	6105                	addi	sp,sp,32
    80006724:	8082                	ret

0000000080006726 <pop_off>:

void
pop_off(void)
{
    80006726:	1141                	addi	sp,sp,-16
    80006728:	e406                	sd	ra,8(sp)
    8000672a:	e022                	sd	s0,0(sp)
    8000672c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000672e:	ffffb097          	auipc	ra,0xffffb
    80006732:	80c080e7          	jalr	-2036(ra) # 80000f3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006736:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000673a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000673c:	e78d                	bnez	a5,80006766 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000673e:	5d3c                	lw	a5,120(a0)
    80006740:	02f05b63          	blez	a5,80006776 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006744:	37fd                	addiw	a5,a5,-1
    80006746:	0007871b          	sext.w	a4,a5
    8000674a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000674c:	eb09                	bnez	a4,8000675e <pop_off+0x38>
    8000674e:	5d7c                	lw	a5,124(a0)
    80006750:	c799                	beqz	a5,8000675e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006752:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006756:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000675a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000675e:	60a2                	ld	ra,8(sp)
    80006760:	6402                	ld	s0,0(sp)
    80006762:	0141                	addi	sp,sp,16
    80006764:	8082                	ret
    panic("pop_off - interruptible");
    80006766:	00002517          	auipc	a0,0x2
    8000676a:	0b250513          	addi	a0,a0,178 # 80008818 <digits+0x28>
    8000676e:	00000097          	auipc	ra,0x0
    80006772:	a26080e7          	jalr	-1498(ra) # 80006194 <panic>
    panic("pop_off");
    80006776:	00002517          	auipc	a0,0x2
    8000677a:	0ba50513          	addi	a0,a0,186 # 80008830 <digits+0x40>
    8000677e:	00000097          	auipc	ra,0x0
    80006782:	a16080e7          	jalr	-1514(ra) # 80006194 <panic>

0000000080006786 <release>:
{
    80006786:	1101                	addi	sp,sp,-32
    80006788:	ec06                	sd	ra,24(sp)
    8000678a:	e822                	sd	s0,16(sp)
    8000678c:	e426                	sd	s1,8(sp)
    8000678e:	1000                	addi	s0,sp,32
    80006790:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006792:	00000097          	auipc	ra,0x0
    80006796:	eaa080e7          	jalr	-342(ra) # 8000663c <holding>
    8000679a:	c115                	beqz	a0,800067be <release+0x38>
  lk->cpu = 0;
    8000679c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800067a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800067a4:	0f50000f          	fence	iorw,ow
    800067a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800067ac:	00000097          	auipc	ra,0x0
    800067b0:	f7a080e7          	jalr	-134(ra) # 80006726 <pop_off>
}
    800067b4:	60e2                	ld	ra,24(sp)
    800067b6:	6442                	ld	s0,16(sp)
    800067b8:	64a2                	ld	s1,8(sp)
    800067ba:	6105                	addi	sp,sp,32
    800067bc:	8082                	ret
    panic("release");
    800067be:	00002517          	auipc	a0,0x2
    800067c2:	07a50513          	addi	a0,a0,122 # 80008838 <digits+0x48>
    800067c6:	00000097          	auipc	ra,0x0
    800067ca:	9ce080e7          	jalr	-1586(ra) # 80006194 <panic>

00000000800067ce <freelock>:
{
    800067ce:	1101                	addi	sp,sp,-32
    800067d0:	ec06                	sd	ra,24(sp)
    800067d2:	e822                	sd	s0,16(sp)
    800067d4:	e426                	sd	s1,8(sp)
    800067d6:	1000                	addi	s0,sp,32
    800067d8:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800067da:	00024517          	auipc	a0,0x24
    800067de:	aae50513          	addi	a0,a0,-1362 # 8002a288 <lock_locks>
    800067e2:	00000097          	auipc	ra,0x0
    800067e6:	ed4080e7          	jalr	-300(ra) # 800066b6 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800067ea:	00024717          	auipc	a4,0x24
    800067ee:	abe70713          	addi	a4,a4,-1346 # 8002a2a8 <locks>
    800067f2:	4781                	li	a5,0
    800067f4:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800067f8:	6314                	ld	a3,0(a4)
    800067fa:	00968763          	beq	a3,s1,80006808 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800067fe:	2785                	addiw	a5,a5,1
    80006800:	0721                	addi	a4,a4,8
    80006802:	fec79be3          	bne	a5,a2,800067f8 <freelock+0x2a>
    80006806:	a809                	j	80006818 <freelock+0x4a>
      locks[i] = 0;
    80006808:	078e                	slli	a5,a5,0x3
    8000680a:	00024717          	auipc	a4,0x24
    8000680e:	a9e70713          	addi	a4,a4,-1378 # 8002a2a8 <locks>
    80006812:	97ba                	add	a5,a5,a4
    80006814:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006818:	00024517          	auipc	a0,0x24
    8000681c:	a7050513          	addi	a0,a0,-1424 # 8002a288 <lock_locks>
    80006820:	00000097          	auipc	ra,0x0
    80006824:	f66080e7          	jalr	-154(ra) # 80006786 <release>
}
    80006828:	60e2                	ld	ra,24(sp)
    8000682a:	6442                	ld	s0,16(sp)
    8000682c:	64a2                	ld	s1,8(sp)
    8000682e:	6105                	addi	sp,sp,32
    80006830:	8082                	ret

0000000080006832 <initlock>:
{
    80006832:	1101                	addi	sp,sp,-32
    80006834:	ec06                	sd	ra,24(sp)
    80006836:	e822                	sd	s0,16(sp)
    80006838:	e426                	sd	s1,8(sp)
    8000683a:	1000                	addi	s0,sp,32
    8000683c:	84aa                	mv	s1,a0
  lk->name = name;
    8000683e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006840:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006844:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006848:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    8000684c:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    80006850:	00024517          	auipc	a0,0x24
    80006854:	a3850513          	addi	a0,a0,-1480 # 8002a288 <lock_locks>
    80006858:	00000097          	auipc	ra,0x0
    8000685c:	e5e080e7          	jalr	-418(ra) # 800066b6 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006860:	00024717          	auipc	a4,0x24
    80006864:	a4870713          	addi	a4,a4,-1464 # 8002a2a8 <locks>
    80006868:	4781                	li	a5,0
    8000686a:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    8000686e:	6314                	ld	a3,0(a4)
    80006870:	ce89                	beqz	a3,8000688a <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    80006872:	2785                	addiw	a5,a5,1
    80006874:	0721                	addi	a4,a4,8
    80006876:	fec79ce3          	bne	a5,a2,8000686e <initlock+0x3c>
  panic("findslot");
    8000687a:	00002517          	auipc	a0,0x2
    8000687e:	fc650513          	addi	a0,a0,-58 # 80008840 <digits+0x50>
    80006882:	00000097          	auipc	ra,0x0
    80006886:	912080e7          	jalr	-1774(ra) # 80006194 <panic>
      locks[i] = lk;
    8000688a:	078e                	slli	a5,a5,0x3
    8000688c:	00024717          	auipc	a4,0x24
    80006890:	a1c70713          	addi	a4,a4,-1508 # 8002a2a8 <locks>
    80006894:	97ba                	add	a5,a5,a4
    80006896:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006898:	00024517          	auipc	a0,0x24
    8000689c:	9f050513          	addi	a0,a0,-1552 # 8002a288 <lock_locks>
    800068a0:	00000097          	auipc	ra,0x0
    800068a4:	ee6080e7          	jalr	-282(ra) # 80006786 <release>
}
    800068a8:	60e2                	ld	ra,24(sp)
    800068aa:	6442                	ld	s0,16(sp)
    800068ac:	64a2                	ld	s1,8(sp)
    800068ae:	6105                	addi	sp,sp,32
    800068b0:	8082                	ret

00000000800068b2 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800068b2:	1141                	addi	sp,sp,-16
    800068b4:	e422                	sd	s0,8(sp)
    800068b6:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800068b8:	0ff0000f          	fence
    800068bc:	6108                	ld	a0,0(a0)
    800068be:	0ff0000f          	fence
  return val;
}
    800068c2:	6422                	ld	s0,8(sp)
    800068c4:	0141                	addi	sp,sp,16
    800068c6:	8082                	ret

00000000800068c8 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    800068c8:	1141                	addi	sp,sp,-16
    800068ca:	e422                	sd	s0,8(sp)
    800068cc:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800068ce:	0ff0000f          	fence
    800068d2:	4108                	lw	a0,0(a0)
    800068d4:	0ff0000f          	fence
  return val;
}
    800068d8:	6422                	ld	s0,8(sp)
    800068da:	0141                	addi	sp,sp,16
    800068dc:	8082                	ret

00000000800068de <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    800068de:	4e5c                	lw	a5,28(a2)
    800068e0:	00f04463          	bgtz	a5,800068e8 <snprint_lock+0xa>
  int n = 0;
    800068e4:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800068e6:	8082                	ret
{
    800068e8:	1141                	addi	sp,sp,-16
    800068ea:	e406                	sd	ra,8(sp)
    800068ec:	e022                	sd	s0,0(sp)
    800068ee:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800068f0:	4e18                	lw	a4,24(a2)
    800068f2:	6614                	ld	a3,8(a2)
    800068f4:	00002617          	auipc	a2,0x2
    800068f8:	f5c60613          	addi	a2,a2,-164 # 80008850 <digits+0x60>
    800068fc:	fffff097          	auipc	ra,0xfffff
    80006900:	204080e7          	jalr	516(ra) # 80005b00 <snprintf>
}
    80006904:	60a2                	ld	ra,8(sp)
    80006906:	6402                	ld	s0,0(sp)
    80006908:	0141                	addi	sp,sp,16
    8000690a:	8082                	ret

000000008000690c <statslock>:

int
statslock(char *buf, int sz) {
    8000690c:	7159                	addi	sp,sp,-112
    8000690e:	f486                	sd	ra,104(sp)
    80006910:	f0a2                	sd	s0,96(sp)
    80006912:	eca6                	sd	s1,88(sp)
    80006914:	e8ca                	sd	s2,80(sp)
    80006916:	e4ce                	sd	s3,72(sp)
    80006918:	e0d2                	sd	s4,64(sp)
    8000691a:	fc56                	sd	s5,56(sp)
    8000691c:	f85a                	sd	s6,48(sp)
    8000691e:	f45e                	sd	s7,40(sp)
    80006920:	f062                	sd	s8,32(sp)
    80006922:	ec66                	sd	s9,24(sp)
    80006924:	e86a                	sd	s10,16(sp)
    80006926:	e46e                	sd	s11,8(sp)
    80006928:	1880                	addi	s0,sp,112
    8000692a:	8aaa                	mv	s5,a0
    8000692c:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000692e:	00024517          	auipc	a0,0x24
    80006932:	95a50513          	addi	a0,a0,-1702 # 8002a288 <lock_locks>
    80006936:	00000097          	auipc	ra,0x0
    8000693a:	d80080e7          	jalr	-640(ra) # 800066b6 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000693e:	00002617          	auipc	a2,0x2
    80006942:	f4260613          	addi	a2,a2,-190 # 80008880 <digits+0x90>
    80006946:	85da                	mv	a1,s6
    80006948:	8556                	mv	a0,s5
    8000694a:	fffff097          	auipc	ra,0xfffff
    8000694e:	1b6080e7          	jalr	438(ra) # 80005b00 <snprintf>
    80006952:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006954:	00024c97          	auipc	s9,0x24
    80006958:	954c8c93          	addi	s9,s9,-1708 # 8002a2a8 <locks>
    8000695c:	00025c17          	auipc	s8,0x25
    80006960:	8ecc0c13          	addi	s8,s8,-1812 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006964:	84e6                	mv	s1,s9
  int tot = 0;
    80006966:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006968:	00002b97          	auipc	s7,0x2
    8000696c:	b20b8b93          	addi	s7,s7,-1248 # 80008488 <syscalls+0xc0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006970:	00001d17          	auipc	s10,0x1
    80006974:	6a8d0d13          	addi	s10,s10,1704 # 80008018 <etext+0x18>
    80006978:	a01d                	j	8000699e <statslock+0x92>
      tot += locks[i]->nts;
    8000697a:	0009b603          	ld	a2,0(s3)
    8000697e:	4e1c                	lw	a5,24(a2)
    80006980:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006984:	412b05bb          	subw	a1,s6,s2
    80006988:	012a8533          	add	a0,s5,s2
    8000698c:	00000097          	auipc	ra,0x0
    80006990:	f52080e7          	jalr	-174(ra) # 800068de <snprint_lock>
    80006994:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006998:	04a1                	addi	s1,s1,8
    8000699a:	05848763          	beq	s1,s8,800069e8 <statslock+0xdc>
    if(locks[i] == 0)
    8000699e:	89a6                	mv	s3,s1
    800069a0:	609c                	ld	a5,0(s1)
    800069a2:	c3b9                	beqz	a5,800069e8 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069a4:	0087bd83          	ld	s11,8(a5)
    800069a8:	855e                	mv	a0,s7
    800069aa:	ffffa097          	auipc	ra,0xffffa
    800069ae:	a4e080e7          	jalr	-1458(ra) # 800003f8 <strlen>
    800069b2:	0005061b          	sext.w	a2,a0
    800069b6:	85de                	mv	a1,s7
    800069b8:	856e                	mv	a0,s11
    800069ba:	ffffa097          	auipc	ra,0xffffa
    800069be:	992080e7          	jalr	-1646(ra) # 8000034c <strncmp>
    800069c2:	dd45                	beqz	a0,8000697a <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800069c4:	609c                	ld	a5,0(s1)
    800069c6:	0087bd83          	ld	s11,8(a5)
    800069ca:	856a                	mv	a0,s10
    800069cc:	ffffa097          	auipc	ra,0xffffa
    800069d0:	a2c080e7          	jalr	-1492(ra) # 800003f8 <strlen>
    800069d4:	0005061b          	sext.w	a2,a0
    800069d8:	85ea                	mv	a1,s10
    800069da:	856e                	mv	a0,s11
    800069dc:	ffffa097          	auipc	ra,0xffffa
    800069e0:	970080e7          	jalr	-1680(ra) # 8000034c <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069e4:	f955                	bnez	a0,80006998 <statslock+0x8c>
    800069e6:	bf51                	j	8000697a <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800069e8:	00002617          	auipc	a2,0x2
    800069ec:	eb860613          	addi	a2,a2,-328 # 800088a0 <digits+0xb0>
    800069f0:	412b05bb          	subw	a1,s6,s2
    800069f4:	012a8533          	add	a0,s5,s2
    800069f8:	fffff097          	auipc	ra,0xfffff
    800069fc:	108080e7          	jalr	264(ra) # 80005b00 <snprintf>
    80006a00:	012509bb          	addw	s3,a0,s2
    80006a04:	4b95                	li	s7,5
  int last = 100000000;
    80006a06:	05f5e537          	lui	a0,0x5f5e
    80006a0a:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006a0e:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a10:	00024497          	auipc	s1,0x24
    80006a14:	89848493          	addi	s1,s1,-1896 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006a18:	1f400913          	li	s2,500
    80006a1c:	a881                	j	80006a6c <statslock+0x160>
    80006a1e:	2705                	addiw	a4,a4,1
    80006a20:	06a1                	addi	a3,a3,8
    80006a22:	03270063          	beq	a4,s2,80006a42 <statslock+0x136>
      if(locks[i] == 0)
    80006a26:	629c                	ld	a5,0(a3)
    80006a28:	cf89                	beqz	a5,80006a42 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a2a:	4f90                	lw	a2,24(a5)
    80006a2c:	00359793          	slli	a5,a1,0x3
    80006a30:	97a6                	add	a5,a5,s1
    80006a32:	639c                	ld	a5,0(a5)
    80006a34:	4f9c                	lw	a5,24(a5)
    80006a36:	fec7d4e3          	bge	a5,a2,80006a1e <statslock+0x112>
    80006a3a:	fea652e3          	bge	a2,a0,80006a1e <statslock+0x112>
    80006a3e:	85ba                	mv	a1,a4
    80006a40:	bff9                	j	80006a1e <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006a42:	058e                	slli	a1,a1,0x3
    80006a44:	00b48d33          	add	s10,s1,a1
    80006a48:	000d3603          	ld	a2,0(s10)
    80006a4c:	413b05bb          	subw	a1,s6,s3
    80006a50:	013a8533          	add	a0,s5,s3
    80006a54:	00000097          	auipc	ra,0x0
    80006a58:	e8a080e7          	jalr	-374(ra) # 800068de <snprint_lock>
    80006a5c:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006a60:	000d3783          	ld	a5,0(s10)
    80006a64:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006a66:	3bfd                	addiw	s7,s7,-1
    80006a68:	000b8663          	beqz	s7,80006a74 <statslock+0x168>
  int tot = 0;
    80006a6c:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006a6e:	8762                	mv	a4,s8
    int top = 0;
    80006a70:	85e2                	mv	a1,s8
    80006a72:	bf55                	j	80006a26 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006a74:	86d2                	mv	a3,s4
    80006a76:	00002617          	auipc	a2,0x2
    80006a7a:	e4a60613          	addi	a2,a2,-438 # 800088c0 <digits+0xd0>
    80006a7e:	413b05bb          	subw	a1,s6,s3
    80006a82:	013a8533          	add	a0,s5,s3
    80006a86:	fffff097          	auipc	ra,0xfffff
    80006a8a:	07a080e7          	jalr	122(ra) # 80005b00 <snprintf>
    80006a8e:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006a92:	00023517          	auipc	a0,0x23
    80006a96:	7f650513          	addi	a0,a0,2038 # 8002a288 <lock_locks>
    80006a9a:	00000097          	auipc	ra,0x0
    80006a9e:	cec080e7          	jalr	-788(ra) # 80006786 <release>
  return n;
}
    80006aa2:	854e                	mv	a0,s3
    80006aa4:	70a6                	ld	ra,104(sp)
    80006aa6:	7406                	ld	s0,96(sp)
    80006aa8:	64e6                	ld	s1,88(sp)
    80006aaa:	6946                	ld	s2,80(sp)
    80006aac:	69a6                	ld	s3,72(sp)
    80006aae:	6a06                	ld	s4,64(sp)
    80006ab0:	7ae2                	ld	s5,56(sp)
    80006ab2:	7b42                	ld	s6,48(sp)
    80006ab4:	7ba2                	ld	s7,40(sp)
    80006ab6:	7c02                	ld	s8,32(sp)
    80006ab8:	6ce2                	ld	s9,24(sp)
    80006aba:	6d42                	ld	s10,16(sp)
    80006abc:	6da2                	ld	s11,8(sp)
    80006abe:	6165                	addi	sp,sp,112
    80006ac0:	8082                	ret
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
