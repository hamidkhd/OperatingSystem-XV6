
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 7d 10 80       	push   $0x80107da0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 95 4c 00 00       	call   80104cf0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7d 10 80       	push   $0x80107da7
80100097:	50                   	push   %eax
80100098:	e8 23 4b 00 00       	call   80104bc0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 47 4d 00 00       	call   80104e30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 89 4d 00 00       	call   80104ef0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 4a 00 00       	call   80104c00 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 21 00 00       	call   801022f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 7d 10 80       	push   $0x80107dae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 4a 00 00       	call   80104ca0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 7d 10 80       	push   $0x80107dbf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 4a 00 00       	call   80104ca0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 4a 00 00       	call   80104c60 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 20 4c 00 00       	call   80104e30 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 4c 00 00       	jmp    80104ef0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 7d 10 80       	push   $0x80107dc6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 ab 16 00 00       	call   80101930 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 4b 00 00       	call   80104e30 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 06 3f 00 00       	call   801041d0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 36 00 00       	call   801039b0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 fc 4b 00 00       	call   80104ef0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 54 15 00 00       	call   80101850 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 9e 4b 00 00       	call   80104ef0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 f6 14 00 00       	call   80101850 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 52 25 00 00       	call   80102900 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 7d 10 80       	push   $0x80107dcd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 93 89 10 80 	movl   $0x80108993,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 49 00 00       	call   80104d10 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 7d 10 80       	push   $0x80107de1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 61 65 00 00       	call   801069a0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 af 64 00 00       	call   801069a0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 a3 64 00 00       	call   801069a0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 97 64 00 00       	call   801069a0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 c7 4a 00 00       	call   80104ff0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 fa 49 00 00       	call   80104f40 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 7d 10 80       	push   $0x80107de5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 7e 10 80 	movzbl -0x7fef81f0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 1c 13 00 00       	call   80101930 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 10 48 00 00       	call   80104e30 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 a4 48 00 00       	call   80104ef0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 fb 11 00 00       	call   80101850 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 cc 47 00 00       	call   80104ef0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 7d 10 80       	mov    $0x80107df8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 3b 46 00 00       	call   80104e30 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 7d 10 80       	push   $0x80107dff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	83 ec 28             	sub    $0x28,%esp
80100819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081c:	68 20 b5 10 80       	push   $0x8010b520
80100821:	e8 0a 46 00 00       	call   80104e30 <acquire>
  while((c = getc()) >= 0){
80100826:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100829:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c6                	mov    %eax,%esi
80100836:	0f 88 8c 00 00 00    	js     801008c8 <consoleintr+0xb8>
    switch(c){ 
8010083c:	83 fe 10             	cmp    $0x10,%esi
8010083f:	0f 84 cb 01 00 00    	je     80100a10 <consoleintr+0x200>
80100845:	0f 8e a5 00 00 00    	jle    801008f0 <consoleintr+0xe0>
8010084b:	83 fe 16             	cmp    $0x16,%esi
8010084e:	0f 84 ec 01 00 00    	je     80100a40 <consoleintr+0x230>
80100854:	0f 8e 56 01 00 00    	jle    801009b0 <consoleintr+0x1a0>
8010085a:	83 fe 18             	cmp    $0x18,%esi
8010085d:	0f 85 3d 02 00 00    	jne    80100aa0 <consoleintr+0x290>
      while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100863:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100868:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
      temp_input = input;
8010086e:	bf c0 0f 11 80       	mov    $0x80110fc0,%edi
80100873:	be 20 0f 11 80       	mov    $0x80110f20,%esi
80100878:	b9 23 00 00 00       	mov    $0x23,%ecx
8010087d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n')
8010087f:	74 af                	je     80100830 <consoleintr+0x20>
80100881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100888:	83 e8 01             	sub    $0x1,%eax
8010088b:	89 c2                	mov    %eax,%edx
8010088d:	83 e2 7f             	and    $0x7f,%edx
80100890:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100897:	74 97                	je     80100830 <consoleintr+0x20>
        input.e--;
80100899:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
8010089e:	b8 00 01 00 00       	mov    $0x100,%eax
801008a3:	e8 68 fb ff ff       	call   80100410 <consputc>
      while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n')
801008a8:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ad:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801008b3:	75 d3                	jne    80100888 <consoleintr+0x78>
  while((c = getc()) >= 0){
801008b5:	ff d3                	call   *%ebx
801008b7:	85 c0                	test   %eax,%eax
801008b9:	89 c6                	mov    %eax,%esi
801008bb:	0f 89 7b ff ff ff    	jns    8010083c <consoleintr+0x2c>
801008c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801008c8:	83 ec 0c             	sub    $0xc,%esp
801008cb:	68 20 b5 10 80       	push   $0x8010b520
801008d0:	e8 1b 46 00 00       	call   80104ef0 <release>
  if(doprocdump) {
801008d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	85 c0                	test   %eax,%eax
801008dd:	0f 85 7d 02 00 00    	jne    80100b60 <consoleintr+0x350>
}
801008e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008e6:	5b                   	pop    %ebx
801008e7:	5e                   	pop    %esi
801008e8:	5f                   	pop    %edi
801008e9:	5d                   	pop    %ebp
801008ea:	c3                   	ret    
801008eb:	90                   	nop
801008ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){ 
801008f0:	83 fe 03             	cmp    $0x3,%esi
801008f3:	0f 84 27 01 00 00    	je     80100a20 <consoleintr+0x210>
801008f9:	83 fe 08             	cmp    $0x8,%esi
801008fc:	0f 84 2e 02 00 00    	je     80100b30 <consoleintr+0x320>
80100902:	83 fe 02             	cmp    $0x2,%esi
80100905:	0f 85 a5 01 00 00    	jne    80100ab0 <consoleintr+0x2a0>
      while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n')
8010090b:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80100911:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
80100917:	75 24                	jne    8010093d <consoleintr+0x12d>
80100919:	eb 33                	jmp    8010094e <consoleintr+0x13e>
8010091b:	90                   	nop
8010091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 e1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n')
8010092f:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80100935:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
8010093b:	74 11                	je     8010094e <consoleintr+0x13e>
8010093d:	8d 42 ff             	lea    -0x1(%edx),%eax
80100940:	89 c1                	mov    %eax,%ecx
80100942:	83 e1 7f             	and    $0x7f,%ecx
80100945:	80 b9 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%ecx)
8010094c:	75 d2                	jne    80100920 <consoleintr+0x110>
      counter = temp_input.w;
8010094e:	8b 35 44 10 11 80    	mov    0x80111044,%esi
      while(counter < temp_input.e)
80100954:	3b 35 48 10 11 80    	cmp    0x80111048,%esi
8010095a:	72 12                	jb     8010096e <consoleintr+0x15e>
8010095c:	e9 cf fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100968:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
        input.buf[input.e++ % INPUT_BUF] = temp_input.buf[counter % INPUT_BUF];
8010096e:	89 f1                	mov    %esi,%ecx
80100970:	8d 42 01             	lea    0x1(%edx),%eax
80100973:	83 e2 7f             	and    $0x7f,%edx
80100976:	c1 f9 1f             	sar    $0x1f,%ecx
80100979:	c1 e9 19             	shr    $0x19,%ecx
8010097c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
80100981:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
        counter++;
80100984:	83 c6 01             	add    $0x1,%esi
        input.buf[input.e++ % INPUT_BUF] = temp_input.buf[counter % INPUT_BUF];
80100987:	83 e0 7f             	and    $0x7f,%eax
8010098a:	29 c8                	sub    %ecx,%eax
8010098c:	0f be 80 c0 0f 11 80 	movsbl -0x7feef040(%eax),%eax
80100993:	88 82 20 0f 11 80    	mov    %al,-0x7feef0e0(%edx)
        consputc(temp_input.buf[counter % INPUT_BUF]);
80100999:	e8 72 fa ff ff       	call   80100410 <consputc>
      while(counter < temp_input.e)
8010099e:	39 35 48 10 11 80    	cmp    %esi,0x80111048
801009a4:	77 c2                	ja     80100968 <consoleintr+0x158>
801009a6:	e9 85 fe ff ff       	jmp    80100830 <consoleintr+0x20>
801009ab:	90                   	nop
801009ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){ 
801009b0:	83 fe 15             	cmp    $0x15,%esi
801009b3:	0f 85 f7 00 00 00    	jne    80100ab0 <consoleintr+0x2a0>
      while(input.e != input.w &&
801009b9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009be:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
801009c4:	75 2a                	jne    801009f0 <consoleintr+0x1e0>
801009c6:	e9 65 fe ff ff       	jmp    80100830 <consoleintr+0x20>
801009cb:	90                   	nop
801009cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.e--;
801009d0:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
801009d5:	b8 00 01 00 00       	mov    $0x100,%eax
801009da:	e8 31 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
801009df:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009e4:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801009ea:	0f 84 40 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009f0:	83 e8 01             	sub    $0x1,%eax
801009f3:	89 c2                	mov    %eax,%edx
801009f5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009f8:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
801009ff:	75 cf                	jne    801009d0 <consoleintr+0x1c0>
80100a01:	e9 2a fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100a06:	8d 76 00             	lea    0x0(%esi),%esi
80100a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      doprocdump = 1;
80100a10:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80100a17:	e9 14 fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      temp_input = input;
80100a20:	bf c0 0f 11 80       	mov    $0x80110fc0,%edi
80100a25:	be 20 0f 11 80       	mov    $0x80110f20,%esi
80100a2a:	b9 23 00 00 00       	mov    $0x23,%ecx
80100a2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      break; 
80100a31:	e9 fa fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100a36:	8d 76 00             	lea    0x0(%esi),%esi
80100a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      counter = temp_input.w;
80100a40:	8b 35 44 10 11 80    	mov    0x80111044,%esi
      while(counter < temp_input.e)
80100a46:	3b 35 48 10 11 80    	cmp    0x80111048,%esi
80100a4c:	0f 83 de fd ff ff    	jae    80100830 <consoleintr+0x20>
80100a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.buf[input.e++ % INPUT_BUF] = temp_input.buf[counter % INPUT_BUF];
80100a58:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80100a5e:	89 f1                	mov    %esi,%ecx
80100a60:	c1 f9 1f             	sar    $0x1f,%ecx
80100a63:	c1 e9 19             	shr    $0x19,%ecx
80100a66:	8d 42 01             	lea    0x1(%edx),%eax
80100a69:	83 e2 7f             	and    $0x7f,%edx
80100a6c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
80100a71:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
        counter++;
80100a74:	83 c6 01             	add    $0x1,%esi
        input.buf[input.e++ % INPUT_BUF] = temp_input.buf[counter % INPUT_BUF];
80100a77:	83 e0 7f             	and    $0x7f,%eax
80100a7a:	29 c8                	sub    %ecx,%eax
80100a7c:	0f be 80 c0 0f 11 80 	movsbl -0x7feef040(%eax),%eax
80100a83:	88 82 20 0f 11 80    	mov    %al,-0x7feef0e0(%edx)
        consputc(temp_input.buf[counter % INPUT_BUF]);
80100a89:	e8 82 f9 ff ff       	call   80100410 <consputc>
      while(counter < temp_input.e)
80100a8e:	39 35 48 10 11 80    	cmp    %esi,0x80111048
80100a94:	77 c2                	ja     80100a58 <consoleintr+0x248>
80100a96:	e9 95 fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100a9b:	90                   	nop
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){ 
80100aa0:	83 fe 7f             	cmp    $0x7f,%esi
80100aa3:	0f 84 87 00 00 00    	je     80100b30 <consoleintr+0x320>
80100aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100ab0:	85 f6                	test   %esi,%esi
80100ab2:	0f 84 78 fd ff ff    	je     80100830 <consoleintr+0x20>
80100ab8:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100abd:	89 c2                	mov    %eax,%edx
80100abf:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100ac5:	83 fa 7f             	cmp    $0x7f,%edx
80100ac8:	0f 87 62 fd ff ff    	ja     80100830 <consoleintr+0x20>
80100ace:	8d 50 01             	lea    0x1(%eax),%edx
80100ad1:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100ad4:	83 fe 0d             	cmp    $0xd,%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ad7:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
80100add:	0f 84 89 00 00 00    	je     80100b6c <consoleintr+0x35c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100ae3:	89 f1                	mov    %esi,%ecx
80100ae5:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
80100aeb:	89 f0                	mov    %esi,%eax
80100aed:	e8 1e f9 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100af2:	83 fe 0a             	cmp    $0xa,%esi
80100af5:	0f 84 82 00 00 00    	je     80100b7d <consoleintr+0x36d>
80100afb:	83 fe 04             	cmp    $0x4,%esi
80100afe:	74 7d                	je     80100b7d <consoleintr+0x36d>
80100b00:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100b05:	83 e8 80             	sub    $0xffffff80,%eax
80100b08:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100b0e:	0f 85 1c fd ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100b14:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b17:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100b1c:	68 a0 0f 11 80       	push   $0x80110fa0
80100b21:	e8 6a 38 00 00       	call   80104390 <wakeup>
80100b26:	83 c4 10             	add    $0x10,%esp
80100b29:	e9 02 fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100b2e:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
80100b30:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100b35:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100b3b:	0f 84 ef fc ff ff    	je     80100830 <consoleintr+0x20>
        input.e--;
80100b41:	83 e8 01             	sub    $0x1,%eax
80100b44:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100b49:	b8 00 01 00 00       	mov    $0x100,%eax
80100b4e:	e8 bd f8 ff ff       	call   80100410 <consputc>
80100b53:	e9 d8 fc ff ff       	jmp    80100830 <consoleintr+0x20>
80100b58:	90                   	nop
80100b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80100b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b63:	5b                   	pop    %ebx
80100b64:	5e                   	pop    %esi
80100b65:	5f                   	pop    %edi
80100b66:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b67:	e9 04 39 00 00       	jmp    80104470 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b6c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100b73:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b78:	e8 93 f8 ff ff       	call   80100410 <consputc>
80100b7d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100b82:	eb 90                	jmp    80100b14 <consoleintr+0x304>
80100b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100b90 <consoleinit>:

void
consoleinit(void)
{
80100b90:	55                   	push   %ebp
80100b91:	89 e5                	mov    %esp,%ebp
80100b93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b96:	68 08 7e 10 80       	push   $0x80107e08
80100b9b:	68 20 b5 10 80       	push   $0x8010b520
80100ba0:	e8 4b 41 00 00       	call   80104cf0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ba5:	58                   	pop    %eax
80100ba6:	5a                   	pop    %edx
80100ba7:	6a 00                	push   $0x0
80100ba9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100bab:	c7 05 0c 1a 11 80 00 	movl   $0x80100600,0x80111a0c
80100bb2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100bb5:	c7 05 08 1a 11 80 70 	movl   $0x80100270,0x80111a08
80100bbc:	02 10 80 
  cons.locking = 1;
80100bbf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100bc6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bc9:	e8 d2 18 00 00       	call   801024a0 <ioapicenable>
}
80100bce:	83 c4 10             	add    $0x10,%esp
80100bd1:	c9                   	leave  
80100bd2:	c3                   	ret    
80100bd3:	66 90                	xchg   %ax,%ax
80100bd5:	66 90                	xchg   %ax,%ax
80100bd7:	66 90                	xchg   %ax,%ax
80100bd9:	66 90                	xchg   %ax,%ax
80100bdb:	66 90                	xchg   %ax,%ax
80100bdd:	66 90                	xchg   %ax,%ax
80100bdf:	90                   	nop

80100be0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	57                   	push   %edi
80100be4:	56                   	push   %esi
80100be5:	53                   	push   %ebx
80100be6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bec:	e8 bf 2d 00 00       	call   801039b0 <myproc>
80100bf1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100bf7:	e8 74 21 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100bfc:	83 ec 0c             	sub    $0xc,%esp
80100bff:	ff 75 08             	pushl  0x8(%ebp)
80100c02:	e8 a9 14 00 00       	call   801020b0 <namei>
80100c07:	83 c4 10             	add    $0x10,%esp
80100c0a:	85 c0                	test   %eax,%eax
80100c0c:	0f 84 91 01 00 00    	je     80100da3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	89 c3                	mov    %eax,%ebx
80100c17:	50                   	push   %eax
80100c18:	e8 33 0c 00 00       	call   80101850 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c23:	6a 34                	push   $0x34
80100c25:	6a 00                	push   $0x0
80100c27:	50                   	push   %eax
80100c28:	53                   	push   %ebx
80100c29:	e8 02 0f 00 00       	call   80101b30 <readi>
80100c2e:	83 c4 20             	add    $0x20,%esp
80100c31:	83 f8 34             	cmp    $0x34,%eax
80100c34:	74 22                	je     80100c58 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c36:	83 ec 0c             	sub    $0xc,%esp
80100c39:	53                   	push   %ebx
80100c3a:	e8 a1 0e 00 00       	call   80101ae0 <iunlockput>
    end_op();
80100c3f:	e8 9c 21 00 00       	call   80102de0 <end_op>
80100c44:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c4f:	5b                   	pop    %ebx
80100c50:	5e                   	pop    %esi
80100c51:	5f                   	pop    %edi
80100c52:	5d                   	pop    %ebp
80100c53:	c3                   	ret    
80100c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c58:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c5f:	45 4c 46 
80100c62:	75 d2                	jne    80100c36 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c64:	e8 87 6e 00 00       	call   80107af0 <setupkvm>
80100c69:	85 c0                	test   %eax,%eax
80100c6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c71:	74 c3                	je     80100c36 <exec+0x56>
  sz = 0;
80100c73:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c75:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c7c:	00 
80100c7d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100c83:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100c89:	0f 84 8c 02 00 00    	je     80100f1b <exec+0x33b>
80100c8f:	31 f6                	xor    %esi,%esi
80100c91:	eb 7f                	jmp    80100d12 <exec+0x132>
80100c93:	90                   	nop
80100c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100c98:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c9f:	75 63                	jne    80100d04 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ca1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ca7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100cad:	0f 82 86 00 00 00    	jb     80100d39 <exec+0x159>
80100cb3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cb9:	72 7e                	jb     80100d39 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cbb:	83 ec 04             	sub    $0x4,%esp
80100cbe:	50                   	push   %eax
80100cbf:	57                   	push   %edi
80100cc0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc6:	e8 45 6c 00 00       	call   80107910 <allocuvm>
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	85 c0                	test   %eax,%eax
80100cd0:	89 c7                	mov    %eax,%edi
80100cd2:	74 65                	je     80100d39 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100cd4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cda:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cdf:	75 58                	jne    80100d39 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce1:	83 ec 0c             	sub    $0xc,%esp
80100ce4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100cea:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cf0:	53                   	push   %ebx
80100cf1:	50                   	push   %eax
80100cf2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cf8:	e8 53 6b 00 00       	call   80107850 <loaduvm>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	78 35                	js     80100d39 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d04:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d0b:	83 c6 01             	add    $0x1,%esi
80100d0e:	39 f0                	cmp    %esi,%eax
80100d10:	7e 3d                	jle    80100d4f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d12:	89 f0                	mov    %esi,%eax
80100d14:	6a 20                	push   $0x20
80100d16:	c1 e0 05             	shl    $0x5,%eax
80100d19:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100d1f:	50                   	push   %eax
80100d20:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d26:	50                   	push   %eax
80100d27:	53                   	push   %ebx
80100d28:	e8 03 0e 00 00       	call   80101b30 <readi>
80100d2d:	83 c4 10             	add    $0x10,%esp
80100d30:	83 f8 20             	cmp    $0x20,%eax
80100d33:	0f 84 5f ff ff ff    	je     80100c98 <exec+0xb8>
    freevm(pgdir);
80100d39:	83 ec 0c             	sub    $0xc,%esp
80100d3c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d42:	e8 29 6d 00 00       	call   80107a70 <freevm>
80100d47:	83 c4 10             	add    $0x10,%esp
80100d4a:	e9 e7 fe ff ff       	jmp    80100c36 <exec+0x56>
80100d4f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d55:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100d5b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d61:	83 ec 0c             	sub    $0xc,%esp
80100d64:	53                   	push   %ebx
80100d65:	e8 76 0d 00 00       	call   80101ae0 <iunlockput>
  end_op();
80100d6a:	e8 71 20 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d6f:	83 c4 0c             	add    $0xc,%esp
80100d72:	56                   	push   %esi
80100d73:	57                   	push   %edi
80100d74:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d7a:	e8 91 6b 00 00       	call   80107910 <allocuvm>
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	85 c0                	test   %eax,%eax
80100d84:	89 c6                	mov    %eax,%esi
80100d86:	75 3a                	jne    80100dc2 <exec+0x1e2>
    freevm(pgdir);
80100d88:	83 ec 0c             	sub    $0xc,%esp
80100d8b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d91:	e8 da 6c 00 00       	call   80107a70 <freevm>
80100d96:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d9e:	e9 a9 fe ff ff       	jmp    80100c4c <exec+0x6c>
    end_op();
80100da3:	e8 38 20 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100da8:	83 ec 0c             	sub    $0xc,%esp
80100dab:	68 21 7e 10 80       	push   $0x80107e21
80100db0:	e8 ab f8 ff ff       	call   80100660 <cprintf>
    return -1;
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dbd:	e9 8a fe ff ff       	jmp    80100c4c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100dc8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100dcb:	31 ff                	xor    %edi,%edi
80100dcd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dcf:	50                   	push   %eax
80100dd0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100dd6:	e8 b5 6d 00 00       	call   80107b90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dde:	83 c4 10             	add    $0x10,%esp
80100de1:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100de7:	8b 00                	mov    (%eax),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	74 70                	je     80100e5d <exec+0x27d>
80100ded:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100df3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100df9:	eb 0a                	jmp    80100e05 <exec+0x225>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100e00:	83 ff 20             	cmp    $0x20,%edi
80100e03:	74 83                	je     80100d88 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e05:	83 ec 0c             	sub    $0xc,%esp
80100e08:	50                   	push   %eax
80100e09:	e8 52 43 00 00       	call   80105160 <strlen>
80100e0e:	f7 d0                	not    %eax
80100e10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e15:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e1c:	e8 3f 43 00 00       	call   80105160 <strlen>
80100e21:	83 c0 01             	add    $0x1,%eax
80100e24:	50                   	push   %eax
80100e25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e2b:	53                   	push   %ebx
80100e2c:	56                   	push   %esi
80100e2d:	e8 be 6e 00 00       	call   80107cf0 <copyout>
80100e32:	83 c4 20             	add    $0x20,%esp
80100e35:	85 c0                	test   %eax,%eax
80100e37:	0f 88 4b ff ff ff    	js     80100d88 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e47:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100e50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e53:	85 c0                	test   %eax,%eax
80100e55:	75 a9                	jne    80100e00 <exec+0x220>
80100e57:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e64:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e6d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100e71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e78:	ff ff ff 
  ustack[1] = argc;
80100e7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e81:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e83:	83 c0 0c             	add    $0xc,%eax
80100e86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e88:	50                   	push   %eax
80100e89:	52                   	push   %edx
80100e8a:	53                   	push   %ebx
80100e8b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e97:	e8 54 6e 00 00       	call   80107cf0 <copyout>
80100e9c:	83 c4 10             	add    $0x10,%esp
80100e9f:	85 c0                	test   %eax,%eax
80100ea1:	0f 88 e1 fe ff ff    	js     80100d88 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80100eaa:	0f b6 00             	movzbl (%eax),%eax
80100ead:	84 c0                	test   %al,%al
80100eaf:	74 17                	je     80100ec8 <exec+0x2e8>
80100eb1:	8b 55 08             	mov    0x8(%ebp),%edx
80100eb4:	89 d1                	mov    %edx,%ecx
80100eb6:	83 c1 01             	add    $0x1,%ecx
80100eb9:	3c 2f                	cmp    $0x2f,%al
80100ebb:	0f b6 01             	movzbl (%ecx),%eax
80100ebe:	0f 44 d1             	cmove  %ecx,%edx
80100ec1:	84 c0                	test   %al,%al
80100ec3:	75 f1                	jne    80100eb6 <exec+0x2d6>
80100ec5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ec8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ece:	50                   	push   %eax
80100ecf:	6a 10                	push   $0x10
80100ed1:	ff 75 08             	pushl  0x8(%ebp)
80100ed4:	89 f8                	mov    %edi,%eax
80100ed6:	83 c0 6c             	add    $0x6c,%eax
80100ed9:	50                   	push   %eax
80100eda:	e8 41 42 00 00       	call   80105120 <safestrcpy>
  curproc->pgdir = pgdir;
80100edf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100ee5:	89 f9                	mov    %edi,%ecx
80100ee7:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100eea:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100eed:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100eef:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100ef2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ef8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100efb:	8b 41 18             	mov    0x18(%ecx),%eax
80100efe:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100f01:	89 0c 24             	mov    %ecx,(%esp)
80100f04:	e8 b7 67 00 00       	call   801076c0 <switchuvm>
  freevm(oldpgdir);
80100f09:	89 3c 24             	mov    %edi,(%esp)
80100f0c:	e8 5f 6b 00 00       	call   80107a70 <freevm>
  return 0;
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	31 c0                	xor    %eax,%eax
80100f16:	e9 31 fd ff ff       	jmp    80100c4c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f1b:	be 00 20 00 00       	mov    $0x2000,%esi
80100f20:	e9 3c fe ff ff       	jmp    80100d61 <exec+0x181>
80100f25:	66 90                	xchg   %ax,%ax
80100f27:	66 90                	xchg   %ax,%ax
80100f29:	66 90                	xchg   %ax,%ax
80100f2b:	66 90                	xchg   %ax,%ax
80100f2d:	66 90                	xchg   %ax,%ax
80100f2f:	90                   	nop

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	68 2d 7e 10 80       	push   $0x80107e2d
80100f3b:	68 60 10 11 80       	push   $0x80111060
80100f40:	e8 ab 3d 00 00       	call   80104cf0 <initlock>
}
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f54:	bb 94 10 11 80       	mov    $0x80111094,%ebx
{
80100f59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f5c:	68 60 10 11 80       	push   $0x80111060
80100f61:	e8 ca 3e 00 00       	call   80104e30 <acquire>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb 10                	jmp    80100f7b <filealloc+0x2b>
80100f6b:	90                   	nop
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f70:	83 c3 18             	add    $0x18,%ebx
80100f73:	81 fb f4 19 11 80    	cmp    $0x801119f4,%ebx
80100f79:	73 25                	jae    80100fa0 <filealloc+0x50>
    if(f->ref == 0){
80100f7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	75 ee                	jne    80100f70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f8c:	68 60 10 11 80       	push   $0x80111060
80100f91:	e8 5a 3f 00 00       	call   80104ef0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f96:	89 d8                	mov    %ebx,%eax
      return f;
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f9e:	c9                   	leave  
80100f9f:	c3                   	ret    
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fa3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fa5:	68 60 10 11 80       	push   $0x80111060
80100faa:	e8 41 3f 00 00       	call   80104ef0 <release>
}
80100faf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fb1:	83 c4 10             	add    $0x10,%esp
}
80100fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb7:	c9                   	leave  
80100fb8:	c3                   	ret    
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fca:	68 60 10 11 80       	push   $0x80111060
80100fcf:	e8 5c 3e 00 00       	call   80104e30 <acquire>
  if(f->ref < 1)
80100fd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	7e 1a                	jle    80100ff8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fe1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fe4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fe7:	68 60 10 11 80       	push   $0x80111060
80100fec:	e8 ff 3e 00 00       	call   80104ef0 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 34 7e 10 80       	push   $0x80107e34
80101000:	e8 8b f3 ff ff       	call   80100390 <panic>
80101005:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 28             	sub    $0x28,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010101c:	68 60 10 11 80       	push   $0x80111060
80101021:	e8 0a 3e 00 00       	call   80104e30 <acquire>
  if(f->ref < 1)
80101026:	8b 43 04             	mov    0x4(%ebx),%eax
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	85 c0                	test   %eax,%eax
8010102e:	0f 8e 9b 00 00 00    	jle    801010cf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101034:	83 e8 01             	sub    $0x1,%eax
80101037:	85 c0                	test   %eax,%eax
80101039:	89 43 04             	mov    %eax,0x4(%ebx)
8010103c:	74 1a                	je     80101058 <fileclose+0x48>
    release(&ftable.lock);
8010103e:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101045:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101048:	5b                   	pop    %ebx
80101049:	5e                   	pop    %esi
8010104a:	5f                   	pop    %edi
8010104b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010104c:	e9 9f 3e 00 00       	jmp    80104ef0 <release>
80101051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101058:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010105c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010105e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101061:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101064:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010106a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010106d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101070:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101078:	e8 73 3e 00 00       	call   80104ef0 <release>
  if(ff.type == FD_PIPE)
8010107d:	83 c4 10             	add    $0x10,%esp
80101080:	83 ff 01             	cmp    $0x1,%edi
80101083:	74 13                	je     80101098 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101085:	83 ff 02             	cmp    $0x2,%edi
80101088:	74 26                	je     801010b0 <fileclose+0xa0>
}
8010108a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108d:	5b                   	pop    %ebx
8010108e:	5e                   	pop    %esi
8010108f:	5f                   	pop    %edi
80101090:	5d                   	pop    %ebp
80101091:	c3                   	ret    
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101098:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010109c:	83 ec 08             	sub    $0x8,%esp
8010109f:	53                   	push   %ebx
801010a0:	56                   	push   %esi
801010a1:	e8 7a 24 00 00       	call   80103520 <pipeclose>
801010a6:	83 c4 10             	add    $0x10,%esp
801010a9:	eb df                	jmp    8010108a <fileclose+0x7a>
801010ab:	90                   	nop
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801010b0:	e8 bb 1c 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
801010b5:	83 ec 0c             	sub    $0xc,%esp
801010b8:	ff 75 e0             	pushl  -0x20(%ebp)
801010bb:	e8 c0 08 00 00       	call   80101980 <iput>
    end_op();
801010c0:	83 c4 10             	add    $0x10,%esp
}
801010c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
    end_op();
801010ca:	e9 11 1d 00 00       	jmp    80102de0 <end_op>
    panic("fileclose");
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	68 3c 7e 10 80       	push   $0x80107e3c
801010d7:	e8 b4 f2 ff ff       	call   80100390 <panic>
801010dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	53                   	push   %ebx
801010e4:	83 ec 04             	sub    $0x4,%esp
801010e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801010ed:	75 31                	jne    80101120 <filestat+0x40>
    ilock(f->ip);
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	ff 73 10             	pushl  0x10(%ebx)
801010f5:	e8 56 07 00 00       	call   80101850 <ilock>
    stati(f->ip, st);
801010fa:	58                   	pop    %eax
801010fb:	5a                   	pop    %edx
801010fc:	ff 75 0c             	pushl  0xc(%ebp)
801010ff:	ff 73 10             	pushl  0x10(%ebx)
80101102:	e8 f9 09 00 00       	call   80101b00 <stati>
    iunlock(f->ip);
80101107:	59                   	pop    %ecx
80101108:	ff 73 10             	pushl  0x10(%ebx)
8010110b:	e8 20 08 00 00       	call   80101930 <iunlock>
    return 0;
80101110:	83 c4 10             	add    $0x10,%esp
80101113:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101118:	c9                   	leave  
80101119:	c3                   	ret    
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101125:	eb ee                	jmp    80101115 <filestat+0x35>
80101127:	89 f6                	mov    %esi,%esi
80101129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101130 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 0c             	sub    $0xc,%esp
80101139:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010113c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010113f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101142:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101146:	74 60                	je     801011a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101148:	8b 03                	mov    (%ebx),%eax
8010114a:	83 f8 01             	cmp    $0x1,%eax
8010114d:	74 41                	je     80101190 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114f:	83 f8 02             	cmp    $0x2,%eax
80101152:	75 5b                	jne    801011af <fileread+0x7f>
    ilock(f->ip);
80101154:	83 ec 0c             	sub    $0xc,%esp
80101157:	ff 73 10             	pushl  0x10(%ebx)
8010115a:	e8 f1 06 00 00       	call   80101850 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115f:	57                   	push   %edi
80101160:	ff 73 14             	pushl  0x14(%ebx)
80101163:	56                   	push   %esi
80101164:	ff 73 10             	pushl  0x10(%ebx)
80101167:	e8 c4 09 00 00       	call   80101b30 <readi>
8010116c:	83 c4 20             	add    $0x20,%esp
8010116f:	85 c0                	test   %eax,%eax
80101171:	89 c6                	mov    %eax,%esi
80101173:	7e 03                	jle    80101178 <fileread+0x48>
      f->off += r;
80101175:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101178:	83 ec 0c             	sub    $0xc,%esp
8010117b:	ff 73 10             	pushl  0x10(%ebx)
8010117e:	e8 ad 07 00 00       	call   80101930 <iunlock>
    return r;
80101183:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101189:	89 f0                	mov    %esi,%eax
8010118b:	5b                   	pop    %ebx
8010118c:	5e                   	pop    %esi
8010118d:	5f                   	pop    %edi
8010118e:	5d                   	pop    %ebp
8010118f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101190:	8b 43 0c             	mov    0xc(%ebx),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010119d:	e9 2e 25 00 00       	jmp    801036d0 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 46 7e 10 80       	push   $0x80107e46
801011b7:	e8 d4 f1 ff ff       	call   80100390 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
801011c9:	8b 75 08             	mov    0x8(%ebp),%esi
801011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801011cf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011d6:	8b 45 10             	mov    0x10(%ebp),%eax
801011d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011dc:	0f 84 aa 00 00 00    	je     8010128c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801011e2:	8b 06                	mov    (%esi),%eax
801011e4:	83 f8 01             	cmp    $0x1,%eax
801011e7:	0f 84 c3 00 00 00    	je     801012b0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011ed:	83 f8 02             	cmp    $0x2,%eax
801011f0:	0f 85 d9 00 00 00    	jne    801012cf <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011f9:	31 ff                	xor    %edi,%edi
    while(i < n){
801011fb:	85 c0                	test   %eax,%eax
801011fd:	7f 34                	jg     80101233 <filewrite+0x73>
801011ff:	e9 9c 00 00 00       	jmp    801012a0 <filewrite+0xe0>
80101204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101208:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010120b:	83 ec 0c             	sub    $0xc,%esp
8010120e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101211:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101214:	e8 17 07 00 00       	call   80101930 <iunlock>
      end_op();
80101219:	e8 c2 1b 00 00       	call   80102de0 <end_op>
8010121e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101221:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101224:	39 c3                	cmp    %eax,%ebx
80101226:	0f 85 96 00 00 00    	jne    801012c2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010122c:	01 df                	add    %ebx,%edi
    while(i < n){
8010122e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101231:	7e 6d                	jle    801012a0 <filewrite+0xe0>
      int n1 = n - i;
80101233:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101236:	b8 00 06 00 00       	mov    $0x600,%eax
8010123b:	29 fb                	sub    %edi,%ebx
8010123d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101243:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101246:	e8 25 1b 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
8010124b:	83 ec 0c             	sub    $0xc,%esp
8010124e:	ff 76 10             	pushl  0x10(%esi)
80101251:	e8 fa 05 00 00       	call   80101850 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	53                   	push   %ebx
8010125a:	ff 76 14             	pushl  0x14(%esi)
8010125d:	01 f8                	add    %edi,%eax
8010125f:	50                   	push   %eax
80101260:	ff 76 10             	pushl  0x10(%esi)
80101263:	e8 c8 09 00 00       	call   80101c30 <writei>
80101268:	83 c4 20             	add    $0x20,%esp
8010126b:	85 c0                	test   %eax,%eax
8010126d:	7f 99                	jg     80101208 <filewrite+0x48>
      iunlock(f->ip);
8010126f:	83 ec 0c             	sub    $0xc,%esp
80101272:	ff 76 10             	pushl  0x10(%esi)
80101275:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101278:	e8 b3 06 00 00       	call   80101930 <iunlock>
      end_op();
8010127d:	e8 5e 1b 00 00       	call   80102de0 <end_op>
      if(r < 0)
80101282:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	85 c0                	test   %eax,%eax
8010128a:	74 98                	je     80101224 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010128c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010128f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101294:	89 f8                	mov    %edi,%eax
80101296:	5b                   	pop    %ebx
80101297:	5e                   	pop    %esi
80101298:	5f                   	pop    %edi
80101299:	5d                   	pop    %ebp
8010129a:	c3                   	ret    
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801012a0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012a3:	75 e7                	jne    8010128c <filewrite+0xcc>
}
801012a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a8:	89 f8                	mov    %edi,%eax
801012aa:	5b                   	pop    %ebx
801012ab:	5e                   	pop    %esi
801012ac:	5f                   	pop    %edi
801012ad:	5d                   	pop    %ebp
801012ae:	c3                   	ret    
801012af:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801012b0:	8b 46 0c             	mov    0xc(%esi),%eax
801012b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b9:	5b                   	pop    %ebx
801012ba:	5e                   	pop    %esi
801012bb:	5f                   	pop    %edi
801012bc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012bd:	e9 fe 22 00 00       	jmp    801035c0 <pipewrite>
        panic("short filewrite");
801012c2:	83 ec 0c             	sub    $0xc,%esp
801012c5:	68 4f 7e 10 80       	push   $0x80107e4f
801012ca:	e8 c1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	68 55 7e 10 80       	push   $0x80107e55
801012d7:	e8 b4 f0 ff ff       	call   80100390 <panic>
801012dc:	66 90                	xchg   %ax,%ax
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	56                   	push   %esi
801012e4:	53                   	push   %ebx
801012e5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012e7:	c1 ea 0c             	shr    $0xc,%edx
801012ea:	03 15 78 1a 11 80    	add    0x80111a78,%edx
801012f0:	83 ec 08             	sub    $0x8,%esp
801012f3:	52                   	push   %edx
801012f4:	50                   	push   %eax
801012f5:	e8 d6 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012fa:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801012fc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801012ff:	ba 01 00 00 00       	mov    $0x1,%edx
80101304:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101307:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010130d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101310:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101312:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101317:	85 d1                	test   %edx,%ecx
80101319:	74 25                	je     80101340 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010131b:	f7 d2                	not    %edx
8010131d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010131f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101322:	21 ca                	and    %ecx,%edx
80101324:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101328:	56                   	push   %esi
80101329:	e8 12 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010132e:	89 34 24             	mov    %esi,(%esp)
80101331:	e8 aa ee ff ff       	call   801001e0 <brelse>
}
80101336:	83 c4 10             	add    $0x10,%esp
80101339:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5d                   	pop    %ebp
8010133f:	c3                   	ret    
    panic("freeing free block");
80101340:	83 ec 0c             	sub    $0xc,%esp
80101343:	68 5f 7e 10 80       	push   $0x80107e5f
80101348:	e8 43 f0 ff ff       	call   80100390 <panic>
8010134d:	8d 76 00             	lea    0x0(%esi),%esi

80101350 <balloc>:
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101359:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
{
8010135f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101362:	85 c9                	test   %ecx,%ecx
80101364:	0f 84 87 00 00 00    	je     801013f1 <balloc+0xa1>
8010136a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101371:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101374:	83 ec 08             	sub    $0x8,%esp
80101377:	89 f0                	mov    %esi,%eax
80101379:	c1 f8 0c             	sar    $0xc,%eax
8010137c:	03 05 78 1a 11 80    	add    0x80111a78,%eax
80101382:	50                   	push   %eax
80101383:	ff 75 d8             	pushl  -0x28(%ebp)
80101386:	e8 45 ed ff ff       	call   801000d0 <bread>
8010138b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010138e:	a1 60 1a 11 80       	mov    0x80111a60,%eax
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101399:	31 c0                	xor    %eax,%eax
8010139b:	eb 2f                	jmp    801013cc <balloc+0x7c>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013a0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013aa:	83 e1 07             	and    $0x7,%ecx
801013ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013af:	89 c1                	mov    %eax,%ecx
801013b1:	c1 f9 03             	sar    $0x3,%ecx
801013b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013b9:	85 df                	test   %ebx,%edi
801013bb:	89 fa                	mov    %edi,%edx
801013bd:	74 41                	je     80101400 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013bf:	83 c0 01             	add    $0x1,%eax
801013c2:	83 c6 01             	add    $0x1,%esi
801013c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ca:	74 05                	je     801013d1 <balloc+0x81>
801013cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013cf:	77 cf                	ja     801013a0 <balloc+0x50>
    brelse(bp);
801013d1:	83 ec 0c             	sub    $0xc,%esp
801013d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013d7:	e8 04 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013e3:	83 c4 10             	add    $0x10,%esp
801013e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013e9:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
801013ef:	77 80                	ja     80101371 <balloc+0x21>
  panic("balloc: out of blocks");
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	68 72 7e 10 80       	push   $0x80107e72
801013f9:	e8 92 ef ff ff       	call   80100390 <panic>
801013fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101403:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101406:	09 da                	or     %ebx,%edx
80101408:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010140c:	57                   	push   %edi
8010140d:	e8 2e 1b 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101412:	89 3c 24             	mov    %edi,(%esp)
80101415:	e8 c6 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010141a:	58                   	pop    %eax
8010141b:	5a                   	pop    %edx
8010141c:	56                   	push   %esi
8010141d:	ff 75 d8             	pushl  -0x28(%ebp)
80101420:	e8 ab ec ff ff       	call   801000d0 <bread>
80101425:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101427:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142a:	83 c4 0c             	add    $0xc,%esp
8010142d:	68 00 02 00 00       	push   $0x200
80101432:	6a 00                	push   $0x0
80101434:	50                   	push   %eax
80101435:	e8 06 3b 00 00       	call   80104f40 <memset>
  log_write(bp);
8010143a:	89 1c 24             	mov    %ebx,(%esp)
8010143d:	e8 fe 1a 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101442:	89 1c 24             	mov    %ebx,(%esp)
80101445:	e8 96 ed ff ff       	call   801001e0 <brelse>
}
8010144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144d:	89 f0                	mov    %esi,%eax
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
80101454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010145a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101460 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	53                   	push   %ebx
80101466:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101468:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010146a:	bb b4 1a 11 80       	mov    $0x80111ab4,%ebx
{
8010146f:	83 ec 28             	sub    $0x28,%esp
80101472:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101475:	68 80 1a 11 80       	push   $0x80111a80
8010147a:	e8 b1 39 00 00       	call   80104e30 <acquire>
8010147f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101485:	eb 17                	jmp    8010149e <iget+0x3e>
80101487:	89 f6                	mov    %esi,%esi
80101489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101490:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101496:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
8010149c:	73 22                	jae    801014c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010149e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014a1:	85 c9                	test   %ecx,%ecx
801014a3:	7e 04                	jle    801014a9 <iget+0x49>
801014a5:	39 3b                	cmp    %edi,(%ebx)
801014a7:	74 4f                	je     801014f8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014a9:	85 f6                	test   %esi,%esi
801014ab:	75 e3                	jne    80101490 <iget+0x30>
801014ad:	85 c9                	test   %ecx,%ecx
801014af:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014b8:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
801014be:	72 de                	jb     8010149e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014c0:	85 f6                	test   %esi,%esi
801014c2:	74 5b                	je     8010151f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014c4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014da:	68 80 1a 11 80       	push   $0x80111a80
801014df:	e8 0c 3a 00 00       	call   80104ef0 <release>

  return ip;
801014e4:	83 c4 10             	add    $0x10,%esp
}
801014e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ea:	89 f0                	mov    %esi,%eax
801014ec:	5b                   	pop    %ebx
801014ed:	5e                   	pop    %esi
801014ee:	5f                   	pop    %edi
801014ef:	5d                   	pop    %ebp
801014f0:	c3                   	ret    
801014f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014f8:	39 53 04             	cmp    %edx,0x4(%ebx)
801014fb:	75 ac                	jne    801014a9 <iget+0x49>
      release(&icache.lock);
801014fd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101500:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101503:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101505:	68 80 1a 11 80       	push   $0x80111a80
      ip->ref++;
8010150a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010150d:	e8 de 39 00 00       	call   80104ef0 <release>
      return ip;
80101512:	83 c4 10             	add    $0x10,%esp
}
80101515:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101518:	89 f0                	mov    %esi,%eax
8010151a:	5b                   	pop    %ebx
8010151b:	5e                   	pop    %esi
8010151c:	5f                   	pop    %edi
8010151d:	5d                   	pop    %ebp
8010151e:	c3                   	ret    
    panic("iget: no inodes");
8010151f:	83 ec 0c             	sub    $0xc,%esp
80101522:	68 88 7e 10 80       	push   $0x80107e88
80101527:	e8 64 ee ff ff       	call   80100390 <panic>
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	89 c6                	mov    %eax,%esi
80101538:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010153b:	83 fa 0b             	cmp    $0xb,%edx
8010153e:	77 18                	ja     80101558 <bmap+0x28>
80101540:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101543:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101546:	85 db                	test   %ebx,%ebx
80101548:	74 76                	je     801015c0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154d:	89 d8                	mov    %ebx,%eax
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5f                   	pop    %edi
80101552:	5d                   	pop    %ebp
80101553:	c3                   	ret    
80101554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101558:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010155b:	83 fb 7f             	cmp    $0x7f,%ebx
8010155e:	0f 87 90 00 00 00    	ja     801015f4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101564:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010156a:	8b 00                	mov    (%eax),%eax
8010156c:	85 d2                	test   %edx,%edx
8010156e:	74 70                	je     801015e0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101570:	83 ec 08             	sub    $0x8,%esp
80101573:	52                   	push   %edx
80101574:	50                   	push   %eax
80101575:	e8 56 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010157a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010157e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101581:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101583:	8b 1a                	mov    (%edx),%ebx
80101585:	85 db                	test   %ebx,%ebx
80101587:	75 1d                	jne    801015a6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101589:	8b 06                	mov    (%esi),%eax
8010158b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010158e:	e8 bd fd ff ff       	call   80101350 <balloc>
80101593:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101596:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101599:	89 c3                	mov    %eax,%ebx
8010159b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010159d:	57                   	push   %edi
8010159e:	e8 9d 19 00 00       	call   80102f40 <log_write>
801015a3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801015a6:	83 ec 0c             	sub    $0xc,%esp
801015a9:	57                   	push   %edi
801015aa:	e8 31 ec ff ff       	call   801001e0 <brelse>
801015af:	83 c4 10             	add    $0x10,%esp
}
801015b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b5:	89 d8                	mov    %ebx,%eax
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
801015bb:	c3                   	ret    
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801015c0:	8b 00                	mov    (%eax),%eax
801015c2:	e8 89 fd ff ff       	call   80101350 <balloc>
801015c7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801015ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801015cd:	89 c3                	mov    %eax,%ebx
}
801015cf:	89 d8                	mov    %ebx,%eax
801015d1:	5b                   	pop    %ebx
801015d2:	5e                   	pop    %esi
801015d3:	5f                   	pop    %edi
801015d4:	5d                   	pop    %ebp
801015d5:	c3                   	ret    
801015d6:	8d 76 00             	lea    0x0(%esi),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015e0:	e8 6b fd ff ff       	call   80101350 <balloc>
801015e5:	89 c2                	mov    %eax,%edx
801015e7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015ed:	8b 06                	mov    (%esi),%eax
801015ef:	e9 7c ff ff ff       	jmp    80101570 <bmap+0x40>
  panic("bmap: out of range");
801015f4:	83 ec 0c             	sub    $0xc,%esp
801015f7:	68 98 7e 10 80       	push   $0x80107e98
801015fc:	e8 8f ed ff ff       	call   80100390 <panic>
80101601:	eb 0d                	jmp    80101610 <readsb>
80101603:	90                   	nop
80101604:	90                   	nop
80101605:	90                   	nop
80101606:	90                   	nop
80101607:	90                   	nop
80101608:	90                   	nop
80101609:	90                   	nop
8010160a:	90                   	nop
8010160b:	90                   	nop
8010160c:	90                   	nop
8010160d:	90                   	nop
8010160e:	90                   	nop
8010160f:	90                   	nop

80101610 <readsb>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	6a 01                	push   $0x1
8010161d:	ff 75 08             	pushl  0x8(%ebp)
80101620:	e8 ab ea ff ff       	call   801000d0 <bread>
80101625:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101627:	8d 40 5c             	lea    0x5c(%eax),%eax
8010162a:	83 c4 0c             	add    $0xc,%esp
8010162d:	6a 1c                	push   $0x1c
8010162f:	50                   	push   %eax
80101630:	56                   	push   %esi
80101631:	e8 ba 39 00 00       	call   80104ff0 <memmove>
  brelse(bp);
80101636:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101639:	83 c4 10             	add    $0x10,%esp
}
8010163c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5d                   	pop    %ebp
  brelse(bp);
80101642:	e9 99 eb ff ff       	jmp    801001e0 <brelse>
80101647:	89 f6                	mov    %esi,%esi
80101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101650 <iinit>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	bb c0 1a 11 80       	mov    $0x80111ac0,%ebx
80101659:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010165c:	68 ab 7e 10 80       	push   $0x80107eab
80101661:	68 80 1a 11 80       	push   $0x80111a80
80101666:	e8 85 36 00 00       	call   80104cf0 <initlock>
8010166b:	83 c4 10             	add    $0x10,%esp
8010166e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101670:	83 ec 08             	sub    $0x8,%esp
80101673:	68 b2 7e 10 80       	push   $0x80107eb2
80101678:	53                   	push   %ebx
80101679:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010167f:	e8 3c 35 00 00       	call   80104bc0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101684:	83 c4 10             	add    $0x10,%esp
80101687:	81 fb e0 36 11 80    	cmp    $0x801136e0,%ebx
8010168d:	75 e1                	jne    80101670 <iinit+0x20>
  readsb(dev, &sb);
8010168f:	83 ec 08             	sub    $0x8,%esp
80101692:	68 60 1a 11 80       	push   $0x80111a60
80101697:	ff 75 08             	pushl  0x8(%ebp)
8010169a:	e8 71 ff ff ff       	call   80101610 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010169f:	ff 35 78 1a 11 80    	pushl  0x80111a78
801016a5:	ff 35 74 1a 11 80    	pushl  0x80111a74
801016ab:	ff 35 70 1a 11 80    	pushl  0x80111a70
801016b1:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
801016b7:	ff 35 68 1a 11 80    	pushl  0x80111a68
801016bd:	ff 35 64 1a 11 80    	pushl  0x80111a64
801016c3:	ff 35 60 1a 11 80    	pushl  0x80111a60
801016c9:	68 18 7f 10 80       	push   $0x80107f18
801016ce:	e8 8d ef ff ff       	call   80100660 <cprintf>
}
801016d3:	83 c4 30             	add    $0x30,%esp
801016d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016d9:	c9                   	leave  
801016da:	c3                   	ret    
801016db:	90                   	nop
801016dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016e0 <ialloc>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	57                   	push   %edi
801016e4:	56                   	push   %esi
801016e5:	53                   	push   %ebx
801016e6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016e9:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
{
801016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016f3:	8b 75 08             	mov    0x8(%ebp),%esi
801016f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016f9:	0f 86 91 00 00 00    	jbe    80101790 <ialloc+0xb0>
801016ff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101704:	eb 21                	jmp    80101727 <ialloc+0x47>
80101706:	8d 76 00             	lea    0x0(%esi),%esi
80101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101710:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101713:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101716:	57                   	push   %edi
80101717:	e8 c4 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010171c:	83 c4 10             	add    $0x10,%esp
8010171f:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
80101725:	76 69                	jbe    80101790 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101727:	89 d8                	mov    %ebx,%eax
80101729:	83 ec 08             	sub    $0x8,%esp
8010172c:	c1 e8 03             	shr    $0x3,%eax
8010172f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101735:	50                   	push   %eax
80101736:	56                   	push   %esi
80101737:	e8 94 e9 ff ff       	call   801000d0 <bread>
8010173c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010173e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101740:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101743:	83 e0 07             	and    $0x7,%eax
80101746:	c1 e0 06             	shl    $0x6,%eax
80101749:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010174d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101751:	75 bd                	jne    80101710 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101753:	83 ec 04             	sub    $0x4,%esp
80101756:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101759:	6a 40                	push   $0x40
8010175b:	6a 00                	push   $0x0
8010175d:	51                   	push   %ecx
8010175e:	e8 dd 37 00 00       	call   80104f40 <memset>
      dip->type = type;
80101763:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101767:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010176a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010176d:	89 3c 24             	mov    %edi,(%esp)
80101770:	e8 cb 17 00 00       	call   80102f40 <log_write>
      brelse(bp);
80101775:	89 3c 24             	mov    %edi,(%esp)
80101778:	e8 63 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010177d:	83 c4 10             	add    $0x10,%esp
}
80101780:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101783:	89 da                	mov    %ebx,%edx
80101785:	89 f0                	mov    %esi,%eax
}
80101787:	5b                   	pop    %ebx
80101788:	5e                   	pop    %esi
80101789:	5f                   	pop    %edi
8010178a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010178b:	e9 d0 fc ff ff       	jmp    80101460 <iget>
  panic("ialloc: no inodes");
80101790:	83 ec 0c             	sub    $0xc,%esp
80101793:	68 b8 7e 10 80       	push   $0x80107eb8
80101798:	e8 f3 eb ff ff       	call   80100390 <panic>
8010179d:	8d 76 00             	lea    0x0(%esi),%esi

801017a0 <iupdate>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a8:	83 ec 08             	sub    $0x8,%esp
801017ab:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ae:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b1:	c1 e8 03             	shr    $0x3,%eax
801017b4:	03 05 74 1a 11 80    	add    0x80111a74,%eax
801017ba:	50                   	push   %eax
801017bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801017be:	e8 0d e9 ff ff       	call   801000d0 <bread>
801017c3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017c8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017e0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017fd:	6a 34                	push   $0x34
801017ff:	53                   	push   %ebx
80101800:	50                   	push   %eax
80101801:	e8 ea 37 00 00       	call   80104ff0 <memmove>
  log_write(bp);
80101806:	89 34 24             	mov    %esi,(%esp)
80101809:	e8 32 17 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010180e:	89 75 08             	mov    %esi,0x8(%ebp)
80101811:	83 c4 10             	add    $0x10,%esp
}
80101814:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5d                   	pop    %ebp
  brelse(bp);
8010181a:	e9 c1 e9 ff ff       	jmp    801001e0 <brelse>
8010181f:	90                   	nop

80101820 <idup>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	83 ec 10             	sub    $0x10,%esp
80101827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010182a:	68 80 1a 11 80       	push   $0x80111a80
8010182f:	e8 fc 35 00 00       	call   80104e30 <acquire>
  ip->ref++;
80101834:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101838:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010183f:	e8 ac 36 00 00       	call   80104ef0 <release>
}
80101844:	89 d8                	mov    %ebx,%eax
80101846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101849:	c9                   	leave  
8010184a:	c3                   	ret    
8010184b:	90                   	nop
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101850 <ilock>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101858:	85 db                	test   %ebx,%ebx
8010185a:	0f 84 b7 00 00 00    	je     80101917 <ilock+0xc7>
80101860:	8b 53 08             	mov    0x8(%ebx),%edx
80101863:	85 d2                	test   %edx,%edx
80101865:	0f 8e ac 00 00 00    	jle    80101917 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010186b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010186e:	83 ec 0c             	sub    $0xc,%esp
80101871:	50                   	push   %eax
80101872:	e8 89 33 00 00       	call   80104c00 <acquiresleep>
  if(ip->valid == 0){
80101877:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	85 c0                	test   %eax,%eax
8010187f:	74 0f                	je     80101890 <ilock+0x40>
}
80101881:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101884:	5b                   	pop    %ebx
80101885:	5e                   	pop    %esi
80101886:	5d                   	pop    %ebp
80101887:	c3                   	ret    
80101888:	90                   	nop
80101889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101890:	8b 43 04             	mov    0x4(%ebx),%eax
80101893:	83 ec 08             	sub    $0x8,%esp
80101896:	c1 e8 03             	shr    $0x3,%eax
80101899:	03 05 74 1a 11 80    	add    0x80111a74,%eax
8010189f:	50                   	push   %eax
801018a0:	ff 33                	pushl  (%ebx)
801018a2:	e8 29 e8 ff ff       	call   801000d0 <bread>
801018a7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018a9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018ac:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018af:	83 e0 07             	and    $0x7,%eax
801018b2:	c1 e0 06             	shl    $0x6,%eax
801018b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018b9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018bc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018db:	8b 50 fc             	mov    -0x4(%eax),%edx
801018de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e1:	6a 34                	push   $0x34
801018e3:	50                   	push   %eax
801018e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018e7:	50                   	push   %eax
801018e8:	e8 03 37 00 00       	call   80104ff0 <memmove>
    brelse(bp);
801018ed:	89 34 24             	mov    %esi,(%esp)
801018f0:	e8 eb e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801018f5:	83 c4 10             	add    $0x10,%esp
801018f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101904:	0f 85 77 ff ff ff    	jne    80101881 <ilock+0x31>
      panic("ilock: no type");
8010190a:	83 ec 0c             	sub    $0xc,%esp
8010190d:	68 d0 7e 10 80       	push   $0x80107ed0
80101912:	e8 79 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101917:	83 ec 0c             	sub    $0xc,%esp
8010191a:	68 ca 7e 10 80       	push   $0x80107eca
8010191f:	e8 6c ea ff ff       	call   80100390 <panic>
80101924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010192a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101930 <iunlock>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	56                   	push   %esi
80101934:	53                   	push   %ebx
80101935:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101938:	85 db                	test   %ebx,%ebx
8010193a:	74 28                	je     80101964 <iunlock+0x34>
8010193c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010193f:	83 ec 0c             	sub    $0xc,%esp
80101942:	56                   	push   %esi
80101943:	e8 58 33 00 00       	call   80104ca0 <holdingsleep>
80101948:	83 c4 10             	add    $0x10,%esp
8010194b:	85 c0                	test   %eax,%eax
8010194d:	74 15                	je     80101964 <iunlock+0x34>
8010194f:	8b 43 08             	mov    0x8(%ebx),%eax
80101952:	85 c0                	test   %eax,%eax
80101954:	7e 0e                	jle    80101964 <iunlock+0x34>
  releasesleep(&ip->lock);
80101956:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101959:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010195c:	5b                   	pop    %ebx
8010195d:	5e                   	pop    %esi
8010195e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010195f:	e9 fc 32 00 00       	jmp    80104c60 <releasesleep>
    panic("iunlock");
80101964:	83 ec 0c             	sub    $0xc,%esp
80101967:	68 df 7e 10 80       	push   $0x80107edf
8010196c:	e8 1f ea ff ff       	call   80100390 <panic>
80101971:	eb 0d                	jmp    80101980 <iput>
80101973:	90                   	nop
80101974:	90                   	nop
80101975:	90                   	nop
80101976:	90                   	nop
80101977:	90                   	nop
80101978:	90                   	nop
80101979:	90                   	nop
8010197a:	90                   	nop
8010197b:	90                   	nop
8010197c:	90                   	nop
8010197d:	90                   	nop
8010197e:	90                   	nop
8010197f:	90                   	nop

80101980 <iput>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 28             	sub    $0x28,%esp
80101989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010198c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010198f:	57                   	push   %edi
80101990:	e8 6b 32 00 00       	call   80104c00 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101995:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101998:	83 c4 10             	add    $0x10,%esp
8010199b:	85 d2                	test   %edx,%edx
8010199d:	74 07                	je     801019a6 <iput+0x26>
8010199f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019a4:	74 32                	je     801019d8 <iput+0x58>
  releasesleep(&ip->lock);
801019a6:	83 ec 0c             	sub    $0xc,%esp
801019a9:	57                   	push   %edi
801019aa:	e8 b1 32 00 00       	call   80104c60 <releasesleep>
  acquire(&icache.lock);
801019af:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801019b6:	e8 75 34 00 00       	call   80104e30 <acquire>
  ip->ref--;
801019bb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019bf:	83 c4 10             	add    $0x10,%esp
801019c2:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
801019c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5f                   	pop    %edi
801019cf:	5d                   	pop    %ebp
  release(&icache.lock);
801019d0:	e9 1b 35 00 00       	jmp    80104ef0 <release>
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019d8:	83 ec 0c             	sub    $0xc,%esp
801019db:	68 80 1a 11 80       	push   $0x80111a80
801019e0:	e8 4b 34 00 00       	call   80104e30 <acquire>
    int r = ip->ref;
801019e5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019e8:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801019ef:	e8 fc 34 00 00       	call   80104ef0 <release>
    if(r == 1){
801019f4:	83 c4 10             	add    $0x10,%esp
801019f7:	83 fe 01             	cmp    $0x1,%esi
801019fa:	75 aa                	jne    801019a6 <iput+0x26>
801019fc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a05:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a08:	89 cf                	mov    %ecx,%edi
80101a0a:	eb 0b                	jmp    80101a17 <iput+0x97>
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a13:	39 fe                	cmp    %edi,%esi
80101a15:	74 19                	je     80101a30 <iput+0xb0>
    if(ip->addrs[i]){
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 bc f8 ff ff       	call   801012e0 <bfree>
      ip->addrs[i] = 0;
80101a24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a2a:	eb e4                	jmp    80101a10 <iput+0x90>
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a30:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a39:	85 c0                	test   %eax,%eax
80101a3b:	75 33                	jne    80101a70 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a3d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a40:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a47:	53                   	push   %ebx
80101a48:	e8 53 fd ff ff       	call   801017a0 <iupdate>
      ip->type = 0;
80101a4d:	31 c0                	xor    %eax,%eax
80101a4f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a53:	89 1c 24             	mov    %ebx,(%esp)
80101a56:	e8 45 fd ff ff       	call   801017a0 <iupdate>
      ip->valid = 0;
80101a5b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	e9 3c ff ff ff       	jmp    801019a6 <iput+0x26>
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a70:	83 ec 08             	sub    $0x8,%esp
80101a73:	50                   	push   %eax
80101a74:	ff 33                	pushl  (%ebx)
80101a76:	e8 55 e6 ff ff       	call   801000d0 <bread>
80101a7b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a81:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a87:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a8a:	83 c4 10             	add    $0x10,%esp
80101a8d:	89 cf                	mov    %ecx,%edi
80101a8f:	eb 0e                	jmp    80101a9f <iput+0x11f>
80101a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a98:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a9b:	39 fe                	cmp    %edi,%esi
80101a9d:	74 0f                	je     80101aae <iput+0x12e>
      if(a[j])
80101a9f:	8b 16                	mov    (%esi),%edx
80101aa1:	85 d2                	test   %edx,%edx
80101aa3:	74 f3                	je     80101a98 <iput+0x118>
        bfree(ip->dev, a[j]);
80101aa5:	8b 03                	mov    (%ebx),%eax
80101aa7:	e8 34 f8 ff ff       	call   801012e0 <bfree>
80101aac:	eb ea                	jmp    80101a98 <iput+0x118>
    brelse(bp);
80101aae:	83 ec 0c             	sub    $0xc,%esp
80101ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ab4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab7:	e8 24 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101abc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ac2:	8b 03                	mov    (%ebx),%eax
80101ac4:	e8 17 f8 ff ff       	call   801012e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ac9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ad0:	00 00 00 
80101ad3:	83 c4 10             	add    $0x10,%esp
80101ad6:	e9 62 ff ff ff       	jmp    80101a3d <iput+0xbd>
80101adb:	90                   	nop
80101adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ae0 <iunlockput>:
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	53                   	push   %ebx
80101ae4:	83 ec 10             	sub    $0x10,%esp
80101ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aea:	53                   	push   %ebx
80101aeb:	e8 40 fe ff ff       	call   80101930 <iunlock>
  iput(ip);
80101af0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101af3:	83 c4 10             	add    $0x10,%esp
}
80101af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101af9:	c9                   	leave  
  iput(ip);
80101afa:	e9 81 fe ff ff       	jmp    80101980 <iput>
80101aff:	90                   	nop

80101b00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	8b 55 08             	mov    0x8(%ebp),%edx
80101b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b09:	8b 0a                	mov    (%edx),%ecx
80101b0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b23:	8b 52 58             	mov    0x58(%edx),%edx
80101b26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b29:	5d                   	pop    %ebp
80101b2a:	c3                   	ret    
80101b2b:	90                   	nop
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b47:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b53:	0f 84 a7 00 00 00    	je     80101c00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	8b 40 58             	mov    0x58(%eax),%eax
80101b5f:	39 c6                	cmp    %eax,%esi
80101b61:	0f 87 ba 00 00 00    	ja     80101c21 <readi+0xf1>
80101b67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b6a:	89 f9                	mov    %edi,%ecx
80101b6c:	01 f1                	add    %esi,%ecx
80101b6e:	0f 82 ad 00 00 00    	jb     80101c21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b74:	89 c2                	mov    %eax,%edx
80101b76:	29 f2                	sub    %esi,%edx
80101b78:	39 c8                	cmp    %ecx,%eax
80101b7a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7d:	31 ff                	xor    %edi,%edi
80101b7f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b81:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b84:	74 6c                	je     80101bf2 <readi+0xc2>
80101b86:	8d 76 00             	lea    0x0(%esi),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b93:	89 f2                	mov    %esi,%edx
80101b95:	c1 ea 09             	shr    $0x9,%edx
80101b98:	89 d8                	mov    %ebx,%eax
80101b9a:	e8 91 f9 ff ff       	call   80101530 <bmap>
80101b9f:	83 ec 08             	sub    $0x8,%esp
80101ba2:	50                   	push   %eax
80101ba3:	ff 33                	pushl  (%ebx)
80101ba5:	e8 26 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101baa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bad:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101baf:	89 f0                	mov    %esi,%eax
80101bb1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bb6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bbb:	83 c4 0c             	add    $0xc,%esp
80101bbe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bc0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101bc4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc7:	29 fb                	sub    %edi,%ebx
80101bc9:	39 d9                	cmp    %ebx,%ecx
80101bcb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bce:	53                   	push   %ebx
80101bcf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bd2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bd7:	e8 14 34 00 00       	call   80104ff0 <memmove>
    brelse(bp);
80101bdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bdf:	89 14 24             	mov    %edx,(%esp)
80101be2:	e8 f9 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101be7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bf0:	77 9e                	ja     80101b90 <readi+0x60>
  }
  return n;
80101bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf8:	5b                   	pop    %ebx
80101bf9:	5e                   	pop    %esi
80101bfa:	5f                   	pop    %edi
80101bfb:	5d                   	pop    %ebp
80101bfc:	c3                   	ret    
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 17                	ja     80101c21 <readi+0xf1>
80101c0a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 0c                	je     80101c21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c1f:	ff e0                	jmp    *%eax
      return -1;
80101c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c26:	eb cd                	jmp    80101bf5 <readi+0xc5>
80101c28:	90                   	nop
80101c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c53:	0f 84 b7 00 00 00    	je     80101d10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c5f:	0f 82 eb 00 00 00    	jb     80101d50 <writei+0x120>
80101c65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c68:	31 d2                	xor    %edx,%edx
80101c6a:	89 f8                	mov    %edi,%eax
80101c6c:	01 f0                	add    %esi,%eax
80101c6e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c71:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c76:	0f 87 d4 00 00 00    	ja     80101d50 <writei+0x120>
80101c7c:	85 d2                	test   %edx,%edx
80101c7e:	0f 85 cc 00 00 00    	jne    80101d50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c84:	85 ff                	test   %edi,%edi
80101c86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c8d:	74 72                	je     80101d01 <writei+0xd1>
80101c8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c93:	89 f2                	mov    %esi,%edx
80101c95:	c1 ea 09             	shr    $0x9,%edx
80101c98:	89 f8                	mov    %edi,%eax
80101c9a:	e8 91 f8 ff ff       	call   80101530 <bmap>
80101c9f:	83 ec 08             	sub    $0x8,%esp
80101ca2:	50                   	push   %eax
80101ca3:	ff 37                	pushl  (%edi)
80101ca5:	e8 26 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101caa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cad:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb2:	89 f0                	mov    %esi,%eax
80101cb4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cb9:	83 c4 0c             	add    $0xc,%esp
80101cbc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cc1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cc3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc7:	39 d9                	cmp    %ebx,%ecx
80101cc9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ccc:	53                   	push   %ebx
80101ccd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cd2:	50                   	push   %eax
80101cd3:	e8 18 33 00 00       	call   80104ff0 <memmove>
    log_write(bp);
80101cd8:	89 3c 24             	mov    %edi,(%esp)
80101cdb:	e8 60 12 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101ce0:	89 3c 24             	mov    %edi,(%esp)
80101ce3:	e8 f8 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ce8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ceb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cee:	83 c4 10             	add    $0x10,%esp
80101cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cf4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cf7:	77 97                	ja     80101c90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cfc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cff:	77 37                	ja     80101d38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d07:	5b                   	pop    %ebx
80101d08:	5e                   	pop    %esi
80101d09:	5f                   	pop    %edi
80101d0a:	5d                   	pop    %ebp
80101d0b:	c3                   	ret    
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d14:	66 83 f8 09          	cmp    $0x9,%ax
80101d18:	77 36                	ja     80101d50 <writei+0x120>
80101d1a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101d21:	85 c0                	test   %eax,%eax
80101d23:	74 2b                	je     80101d50 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2b:	5b                   	pop    %ebx
80101d2c:	5e                   	pop    %esi
80101d2d:	5f                   	pop    %edi
80101d2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d2f:	ff e0                	jmp    *%eax
80101d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d3b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d3e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d41:	50                   	push   %eax
80101d42:	e8 59 fa ff ff       	call   801017a0 <iupdate>
80101d47:	83 c4 10             	add    $0x10,%esp
80101d4a:	eb b5                	jmp    80101d01 <writei+0xd1>
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d55:	eb ad                	jmp    80101d04 <writei+0xd4>
80101d57:	89 f6                	mov    %esi,%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d66:	6a 0e                	push   $0xe
80101d68:	ff 75 0c             	pushl  0xc(%ebp)
80101d6b:	ff 75 08             	pushl  0x8(%ebp)
80101d6e:	e8 ed 32 00 00       	call   80105060 <strncmp>
}
80101d73:	c9                   	leave  
80101d74:	c3                   	ret    
80101d75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	83 ec 1c             	sub    $0x1c,%esp
80101d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d91:	0f 85 85 00 00 00    	jne    80101e1c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d97:	8b 53 58             	mov    0x58(%ebx),%edx
80101d9a:	31 ff                	xor    %edi,%edi
80101d9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d9f:	85 d2                	test   %edx,%edx
80101da1:	74 3e                	je     80101de1 <dirlookup+0x61>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101da8:	6a 10                	push   $0x10
80101daa:	57                   	push   %edi
80101dab:	56                   	push   %esi
80101dac:	53                   	push   %ebx
80101dad:	e8 7e fd ff ff       	call   80101b30 <readi>
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	83 f8 10             	cmp    $0x10,%eax
80101db8:	75 55                	jne    80101e0f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101dbf:	74 18                	je     80101dd9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101dc1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101dc4:	83 ec 04             	sub    $0x4,%esp
80101dc7:	6a 0e                	push   $0xe
80101dc9:	50                   	push   %eax
80101dca:	ff 75 0c             	pushl  0xc(%ebp)
80101dcd:	e8 8e 32 00 00       	call   80105060 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	85 c0                	test   %eax,%eax
80101dd7:	74 17                	je     80101df0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dd9:	83 c7 10             	add    $0x10,%edi
80101ddc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ddf:	72 c7                	jb     80101da8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101de4:	31 c0                	xor    %eax,%eax
}
80101de6:	5b                   	pop    %ebx
80101de7:	5e                   	pop    %esi
80101de8:	5f                   	pop    %edi
80101de9:	5d                   	pop    %ebp
80101dea:	c3                   	ret    
80101deb:	90                   	nop
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101df0:	8b 45 10             	mov    0x10(%ebp),%eax
80101df3:	85 c0                	test   %eax,%eax
80101df5:	74 05                	je     80101dfc <dirlookup+0x7c>
        *poff = off;
80101df7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dfa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dfc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e00:	8b 03                	mov    (%ebx),%eax
80101e02:	e8 59 f6 ff ff       	call   80101460 <iget>
}
80101e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e0a:	5b                   	pop    %ebx
80101e0b:	5e                   	pop    %esi
80101e0c:	5f                   	pop    %edi
80101e0d:	5d                   	pop    %ebp
80101e0e:	c3                   	ret    
      panic("dirlookup read");
80101e0f:	83 ec 0c             	sub    $0xc,%esp
80101e12:	68 f9 7e 10 80       	push   $0x80107ef9
80101e17:	e8 74 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	68 e7 7e 10 80       	push   $0x80107ee7
80101e24:	e8 67 e5 ff ff       	call   80100390 <panic>
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	89 cf                	mov    %ecx,%edi
80101e38:	89 c3                	mov    %eax,%ebx
80101e3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e3d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e43:	0f 84 67 01 00 00    	je     80101fb0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e49:	e8 62 1b 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101e4e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e51:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e54:	68 80 1a 11 80       	push   $0x80111a80
80101e59:	e8 d2 2f 00 00       	call   80104e30 <acquire>
  ip->ref++;
80101e5e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e62:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101e69:	e8 82 30 00 00       	call   80104ef0 <release>
80101e6e:	83 c4 10             	add    $0x10,%esp
80101e71:	eb 08                	jmp    80101e7b <namex+0x4b>
80101e73:	90                   	nop
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e7b:	0f b6 03             	movzbl (%ebx),%eax
80101e7e:	3c 2f                	cmp    $0x2f,%al
80101e80:	74 f6                	je     80101e78 <namex+0x48>
  if(*path == 0)
80101e82:	84 c0                	test   %al,%al
80101e84:	0f 84 ee 00 00 00    	je     80101f78 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e8a:	0f b6 03             	movzbl (%ebx),%eax
80101e8d:	3c 2f                	cmp    $0x2f,%al
80101e8f:	0f 84 b3 00 00 00    	je     80101f48 <namex+0x118>
80101e95:	84 c0                	test   %al,%al
80101e97:	89 da                	mov    %ebx,%edx
80101e99:	75 09                	jne    80101ea4 <namex+0x74>
80101e9b:	e9 a8 00 00 00       	jmp    80101f48 <namex+0x118>
80101ea0:	84 c0                	test   %al,%al
80101ea2:	74 0a                	je     80101eae <namex+0x7e>
    path++;
80101ea4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ea7:	0f b6 02             	movzbl (%edx),%eax
80101eaa:	3c 2f                	cmp    $0x2f,%al
80101eac:	75 f2                	jne    80101ea0 <namex+0x70>
80101eae:	89 d1                	mov    %edx,%ecx
80101eb0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101eb2:	83 f9 0d             	cmp    $0xd,%ecx
80101eb5:	0f 8e 91 00 00 00    	jle    80101f4c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ebb:	83 ec 04             	sub    $0x4,%esp
80101ebe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ec1:	6a 0e                	push   $0xe
80101ec3:	53                   	push   %ebx
80101ec4:	57                   	push   %edi
80101ec5:	e8 26 31 00 00       	call   80104ff0 <memmove>
    path++;
80101eca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ecd:	83 c4 10             	add    $0x10,%esp
    path++;
80101ed0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101ed2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ed5:	75 11                	jne    80101ee8 <namex+0xb8>
80101ed7:	89 f6                	mov    %esi,%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ee0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ee3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ee6:	74 f8                	je     80101ee0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 5f f9 ff ff       	call   80101850 <ilock>
    if(ip->type != T_DIR){
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ef9:	0f 85 91 00 00 00    	jne    80101f90 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f02:	85 d2                	test   %edx,%edx
80101f04:	74 09                	je     80101f0f <namex+0xdf>
80101f06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f09:	0f 84 b7 00 00 00    	je     80101fc6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f0f:	83 ec 04             	sub    $0x4,%esp
80101f12:	6a 00                	push   $0x0
80101f14:	57                   	push   %edi
80101f15:	56                   	push   %esi
80101f16:	e8 65 fe ff ff       	call   80101d80 <dirlookup>
80101f1b:	83 c4 10             	add    $0x10,%esp
80101f1e:	85 c0                	test   %eax,%eax
80101f20:	74 6e                	je     80101f90 <namex+0x160>
  iunlock(ip);
80101f22:	83 ec 0c             	sub    $0xc,%esp
80101f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f28:	56                   	push   %esi
80101f29:	e8 02 fa ff ff       	call   80101930 <iunlock>
  iput(ip);
80101f2e:	89 34 24             	mov    %esi,(%esp)
80101f31:	e8 4a fa ff ff       	call   80101980 <iput>
80101f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f39:	83 c4 10             	add    $0x10,%esp
80101f3c:	89 c6                	mov    %eax,%esi
80101f3e:	e9 38 ff ff ff       	jmp    80101e7b <namex+0x4b>
80101f43:	90                   	nop
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f48:	89 da                	mov    %ebx,%edx
80101f4a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f4c:	83 ec 04             	sub    $0x4,%esp
80101f4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f55:	51                   	push   %ecx
80101f56:	53                   	push   %ebx
80101f57:	57                   	push   %edi
80101f58:	e8 93 30 00 00       	call   80104ff0 <memmove>
    name[len] = 0;
80101f5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f6a:	89 d3                	mov    %edx,%ebx
80101f6c:	e9 61 ff ff ff       	jmp    80101ed2 <namex+0xa2>
80101f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f7b:	85 c0                	test   %eax,%eax
80101f7d:	75 5d                	jne    80101fdc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f82:	89 f0                	mov    %esi,%eax
80101f84:	5b                   	pop    %ebx
80101f85:	5e                   	pop    %esi
80101f86:	5f                   	pop    %edi
80101f87:	5d                   	pop    %ebp
80101f88:	c3                   	ret    
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	56                   	push   %esi
80101f94:	e8 97 f9 ff ff       	call   80101930 <iunlock>
  iput(ip);
80101f99:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f9c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f9e:	e8 dd f9 ff ff       	call   80101980 <iput>
      return 0;
80101fa3:	83 c4 10             	add    $0x10,%esp
}
80101fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa9:	89 f0                	mov    %esi,%eax
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5f                   	pop    %edi
80101fae:	5d                   	pop    %ebp
80101faf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101fb0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fb5:	b8 01 00 00 00       	mov    $0x1,%eax
80101fba:	e8 a1 f4 ff ff       	call   80101460 <iget>
80101fbf:	89 c6                	mov    %eax,%esi
80101fc1:	e9 b5 fe ff ff       	jmp    80101e7b <namex+0x4b>
      iunlock(ip);
80101fc6:	83 ec 0c             	sub    $0xc,%esp
80101fc9:	56                   	push   %esi
80101fca:	e8 61 f9 ff ff       	call   80101930 <iunlock>
      return ip;
80101fcf:	83 c4 10             	add    $0x10,%esp
}
80101fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd5:	89 f0                	mov    %esi,%eax
80101fd7:	5b                   	pop    %ebx
80101fd8:	5e                   	pop    %esi
80101fd9:	5f                   	pop    %edi
80101fda:	5d                   	pop    %ebp
80101fdb:	c3                   	ret    
    iput(ip);
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	56                   	push   %esi
    return 0;
80101fe0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fe2:	e8 99 f9 ff ff       	call   80101980 <iput>
    return 0;
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	eb 93                	jmp    80101f7f <namex+0x14f>
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	pushl  0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 79 fd ff ff       	call   80101d80 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 fe fa ff ff       	call   80101b30 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	8d 45 da             	lea    -0x26(%ebp),%eax
80102044:	83 ec 04             	sub    $0x4,%esp
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	pushl  0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 6e 30 00 00       	call   801050c0 <strncpy>
  de.inum = inum;
80102052:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102055:	6a 10                	push   $0x10
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 cd fb ff ff       	call   80101c30 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 02 f9 ff ff       	call   80101980 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 08 7f 10 80       	push   $0x80107f08
80102090:	e8 fb e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 7e 87 10 80       	push   $0x8010877e
8010209d:	e8 ee e2 ff ff       	call   80100390 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 6d fd ff ff       	call   80101e30 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 4c fd ff ff       	jmp    80101e30 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 58 08             	mov    0x8(%eax),%ebx
80102104:	89 c6                	mov    %eax,%esi
80102106:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	89 f6                	mov    %esi,%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 d8                	mov    %ebx,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 d8                	mov    %ebx,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 06 04             	testb  $0x4,(%esi)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	83 c6 5c             	add    $0x5c,%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 74 7f 10 80       	push   $0x80107f74
801021b0:	e8 db e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 6b 7f 10 80       	push   $0x80107f6b
801021bd:	e8 ce e1 ff ff       	call   80100390 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 86 7f 10 80       	push   $0x80107f86
801021db:	68 80 b5 10 80       	push   $0x8010b580
801021e0:	e8 0b 2b 00 00       	call   80104cf0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 a9 02 00 00       	call   801024a0 <ioapicenable>
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	eb 0d                	jmp    80102250 <ideintr>
80102243:	90                   	nop
80102244:	90                   	nop
80102245:	90                   	nop
80102246:	90                   	nop
80102247:	90                   	nop
80102248:	90                   	nop
80102249:	90                   	nop
8010224a:	90                   	nop
8010224b:	90                   	nop
8010224c:	90                   	nop
8010224d:	90                   	nop
8010224e:	90                   	nop
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 80 b5 10 80       	push   $0x8010b580
8010225e:	e8 cd 2b 00 00       	call   80104e30 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 67                	je     801022d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 3b                	mov    (%ebx),%edi
8010227a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102280:	75 31                	jne    801022b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c6                	mov    %eax,%esi
80102293:	83 e6 c0             	and    $0xffffffc0,%esi
80102296:	89 f1                	mov    %esi,%ecx
80102298:	80 f9 40             	cmp    $0x40,%cl
8010229b:	75 f3                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229d:	a8 21                	test   $0x21,%al
8010229f:	75 12                	jne    801022b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801022a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ae:	fc                   	cld    
801022af:	f3 6d                	rep insl (%dx),%es:(%edi)
801022b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801022b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b9:	89 f9                	mov    %edi,%ecx
801022bb:	83 c9 02             	or     $0x2,%ecx
801022be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022c0:	53                   	push   %ebx
801022c1:	e8 ca 20 00 00       	call   80104390 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022cb:	83 c4 10             	add    $0x10,%esp
801022ce:	85 c0                	test   %eax,%eax
801022d0:	74 05                	je     801022d7 <ideintr+0x87>
    idestart(idequeue);
801022d2:	e8 19 fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 80 b5 10 80       	push   $0x8010b580
801022df:	e8 0c 2c 00 00       	call   80104ef0 <release>

  release(&idelock);
}
801022e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e7:	5b                   	pop    %ebx
801022e8:	5e                   	pop    %esi
801022e9:	5f                   	pop    %edi
801022ea:	5d                   	pop    %ebp
801022eb:	c3                   	ret    
801022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 9d 29 00 00       	call   80104ca0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c6 00 00 00    	je     801023d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 ab 00 00 00    	je     801023c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 b1 00 00 00    	je     801023e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 80 b5 10 80       	push   $0x8010b580
80102338:	e8 f3 2a 00 00       	call   80104e30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102343:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102346:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	85 d2                	test   %edx,%edx
8010234f:	75 09                	jne    8010235a <iderw+0x6a>
80102351:	eb 6d                	jmp    801023c0 <iderw+0xd0>
80102353:	90                   	nop
80102354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102358:	89 c2                	mov    %eax,%edx
8010235a:	8b 42 58             	mov    0x58(%edx),%eax
8010235d:	85 c0                	test   %eax,%eax
8010235f:	75 f7                	jne    80102358 <iderw+0x68>
80102361:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102364:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102366:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010236c:	74 42                	je     801023b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	74 23                	je     8010239b <iderw+0xab>
80102378:	90                   	nop
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 80 b5 10 80       	push   $0x8010b580
80102388:	53                   	push   %ebx
80102389:	e8 42 1e 00 00       	call   801041d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x90>
  }


  release(&idelock);
8010239b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 45 2b 00 00       	jmp    80104ef0 <release>
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 39 fd ff ff       	call   801020f0 <idestart>
801023b7:	eb b5                	jmp    8010236e <iderw+0x7e>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023c5:	eb 9d                	jmp    80102364 <iderw+0x74>
    panic("iderw: nothing to do");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 a0 7f 10 80       	push   $0x80107fa0
801023cf:	e8 bc df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 8a 7f 10 80       	push   $0x80107f8a
801023dc:	e8 af df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 b5 7f 10 80       	push   $0x80107fb5
801023e9:	e8 a2 df ff ff       	call   80100390 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010240e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102417:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241d:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102424:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102427:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010242a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010242d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102430:	39 c2                	cmp    %eax,%edx
80102432:	74 16                	je     8010244a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	68 d4 7f 10 80       	push   $0x80107fd4
8010243c:	e8 1f e2 ff ff       	call   80100660 <cprintf>
80102441:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	83 c3 21             	add    $0x21,%ebx
{
8010244d:	ba 10 00 00 00       	mov    $0x10,%edx
80102452:	b8 20 00 00 00       	mov    $0x20,%eax
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102462:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102468:	89 c6                	mov    %eax,%esi
8010246a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102470:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102473:	89 71 10             	mov    %esi,0x10(%ecx)
80102476:	8d 72 01             	lea    0x1(%edx),%esi
80102479:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010247c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010247e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102480:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102486:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d 76 00             	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 d4 36 11 80       	mov    0x801136d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 70                	jne    80102562 <kfree+0x82>
801024f2:	81 fb 48 8f 11 80    	cmp    $0x80118f48,%ebx
801024f8:	72 68                	jb     80102562 <kfree+0x82>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 5b                	ja     80102562 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 29 2a 00 00       	call   80104f40 <memset>

  if(kmem.use_lock)
80102517:	8b 15 14 37 11 80    	mov    0x80113714,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 2c                	jne    80102550 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 18 37 11 80       	mov    0x80113718,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 14 37 11 80       	mov    0x80113714,%eax
  kmem.freelist = r;
80102530:	89 1d 18 37 11 80    	mov    %ebx,0x80113718
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 06                	jne    80102540 <kfree+0x60>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    release(&kmem.lock);
80102540:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254a:	c9                   	leave  
    release(&kmem.lock);
8010254b:	e9 a0 29 00 00       	jmp    80104ef0 <release>
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 e0 36 11 80       	push   $0x801136e0
80102558:	e8 d3 28 00 00       	call   80104e30 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb c2                	jmp    80102524 <kfree+0x44>
    panic("kfree");
80102562:	83 ec 0c             	sub    $0xc,%esp
80102565:	68 06 80 10 80       	push   $0x80108006
8010256a:	e8 21 de ff ff       	call   80100390 <panic>
8010256f:	90                   	nop

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102575:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102578:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010259e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 33 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <kinit1>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
801025c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025c8:	83 ec 08             	sub    $0x8,%esp
801025cb:	68 0c 80 10 80       	push   $0x8010800c
801025d0:	68 e0 36 11 80       	push   $0x801136e0
801025d5:	e8 16 27 00 00       	call   80104cf0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025e0:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
801025e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fc:	39 de                	cmp    %ebx,%esi
801025fe:	72 1c                	jb     8010261c <kinit1+0x5c>
    kfree(p);
80102600:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102606:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102609:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010260f:	50                   	push   %eax
80102610:	e8 cb fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102615:	83 c4 10             	add    $0x10,%esp
80102618:	39 de                	cmp    %ebx,%esi
8010261a:	73 e4                	jae    80102600 <kinit1+0x40>
}
8010261c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010261f:	5b                   	pop    %ebx
80102620:	5e                   	pop    %esi
80102621:	5d                   	pop    %ebp
80102622:	c3                   	ret    
80102623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010265e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 73 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret    
80102685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 14 37 11 80       	mov    0x80113714,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 18 37 11 80    	mov    %edx,0x80113718
801026aa:	c3                   	ret    
801026ab:	90                   	nop
801026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	f3 c3                	repz ret 
801026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 e0 36 11 80       	push   $0x801136e0
801026c3:	e8 68 27 00 00       	call   80104e30 <acquire>
  r = kmem.freelist;
801026c8:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	8b 15 14 37 11 80    	mov    0x80113714,%edx
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 18 37 11 80    	mov    %ecx,0x80113718
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 e0 36 11 80       	push   $0x801136e0
801026f1:	e8 fa 27 00 00       	call   80104ef0 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
8010270e:	ba 60 00 00 00       	mov    $0x60,%edx
80102713:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102714:	0f b6 d0             	movzbl %al,%edx
80102717:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010271d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102723:	0f 84 7f 00 00 00    	je     801027a8 <kbdgetc+0xa8>
{
80102729:	55                   	push   %ebp
8010272a:	89 e5                	mov    %esp,%ebp
8010272c:	53                   	push   %ebx
8010272d:	89 cb                	mov    %ecx,%ebx
8010272f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102732:	84 c0                	test   %al,%al
80102734:	78 4a                	js     80102780 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102736:	85 db                	test   %ebx,%ebx
80102738:	74 09                	je     80102743 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010273a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010273d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102740:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102743:	0f b6 82 40 81 10 80 	movzbl -0x7fef7ec0(%edx),%eax
8010274a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010274c:	0f b6 82 40 80 10 80 	movzbl -0x7fef7fc0(%edx),%eax
80102753:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102757:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102760:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102763:	8b 04 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%eax
8010276a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010276e:	74 31                	je     801027a1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102770:	8d 50 9f             	lea    -0x61(%eax),%edx
80102773:	83 fa 19             	cmp    $0x19,%edx
80102776:	77 40                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102778:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010277b:	5b                   	pop    %ebx
8010277c:	5d                   	pop    %ebp
8010277d:	c3                   	ret    
8010277e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 db                	test   %ebx,%ebx
80102785:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 82 40 81 10 80 	movzbl -0x7fef7ec0(%edx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 c1                	and    %eax,%ecx
    return 0;
80102799:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010279b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027a1:	5b                   	pop    %ebx
801027a2:	5d                   	pop    %ebp
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801027a8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801027ab:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027ad:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801027b3:	c3                   	ret    
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	5b                   	pop    %ebx
      c += 'a' - 'A';
801027bf:	83 f9 1a             	cmp    $0x1a,%ecx
801027c2:	0f 42 c2             	cmovb  %edx,%eax
}
801027c5:	5d                   	pop    %ebp
801027c6:	c3                   	ret    
801027c7:	89 f6                	mov    %esi,%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d 76 00             	lea    0x0(%esi),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 20 e0 ff ff       	call   80100810 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 1c 37 11 80       	mov    0x8011371c,%eax
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102808:	85 c0                	test   %eax,%eax
8010280a:	0f 84 c8 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
80102810:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102817:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102831:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010284b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285e:	8b 50 30             	mov    0x30(%eax),%edx
80102861:	c1 ea 10             	shr    $0x10,%edx
80102864:	80 fa 03             	cmp    $0x3,%dl
80102867:	77 77                	ja     801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	89 f6                	mov    %esi,%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	5d                   	pop    %ebp
801028d9:	c3                   	ret    
801028da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	8b 15 1c 37 11 80    	mov    0x8011371c,%edx
{
80102906:	55                   	push   %ebp
80102907:	31 c0                	xor    %eax,%eax
80102909:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010290b:	85 d2                	test   %edx,%edx
8010290d:	74 06                	je     80102915 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010290f:	8b 42 20             	mov    0x20(%edx),%eax
80102912:	c1 e8 18             	shr    $0x18,%eax
}
80102915:	5d                   	pop    %ebp
80102916:	c3                   	ret    
80102917:	89 f6                	mov    %esi,%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 1c 37 11 80       	mov    0x8011371c,%eax
{
80102925:	55                   	push   %ebp
80102926:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102928:	85 c0                	test   %eax,%eax
8010292a:	74 0d                	je     80102939 <lapiceoi+0x19>
  lapic[index] = value;
8010292c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102933:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102936:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102939:	5d                   	pop    %ebp
8010293a:	c3                   	ret    
8010293b:	90                   	nop
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102940 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
}
80102943:	5d                   	pop    %ebp
80102944:	c3                   	ret    
80102945:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102980:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102983:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	5b                   	pop    %ebx
801029db:	5d                   	pop    %ebp
801029dc:	c3                   	ret    
801029dd:	8d 76 00             	lea    0x0(%esi),%esi

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	0f b6 f2             	movzbl %dl,%esi
80102a79:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a81:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a84:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a88:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a8b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 84 24 00 00       	call   80104f90 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
80102be2:	56                   	push   %esi
80102be3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102be4:	31 db                	xor    %ebx,%ebx
{
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 54 37 11 80       	mov    0x80113754,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 d8                	add    %ebx,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 64 37 11 80    	pushl  0x80113764
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102c14:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
80102c22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c27:	83 c4 0c             	add    $0xc,%esp
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 b7 23 00 00       	call   80104ff0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 34 24             	mov    %esi,(%esp)
80102c3c:	e8 5f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c41:	89 3c 24             	mov    %edi,(%esp)
80102c44:	e8 97 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c49:	89 34 24             	mov    %esi,(%esp)
80102c4c:	e8 8f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 1d 68 37 11 80    	cmp    %ebx,0x80113768
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	f3 c3                	repz ret 
80102c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c75:	83 ec 08             	sub    $0x8,%esp
80102c78:	ff 35 54 37 11 80    	pushl  0x80113754
80102c7e:	ff 35 64 37 11 80    	pushl  0x80113764
80102c84:	e8 47 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c89:	8b 1d 68 37 11 80    	mov    0x80113768,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c8f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c92:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c94:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c96:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c99:	7e 16                	jle    80102cb1 <write_head+0x41>
80102c9b:	c1 e3 02             	shl    $0x2,%ebx
80102c9e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 8a 6c 37 11 80    	mov    -0x7feec894(%edx),%ecx
80102ca6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102caa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102cad:	39 da                	cmp    %ebx,%edx
80102caf:	75 ef                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	56                   	push   %esi
80102cb5:	e8 e6 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102cba:	89 34 24             	mov    %esi,(%esp)
80102cbd:	e8 1e d5 ff ff       	call   801001e0 <brelse>
}
80102cc2:	83 c4 10             	add    $0x10,%esp
80102cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cc8:	5b                   	pop    %ebx
80102cc9:	5e                   	pop    %esi
80102cca:	5d                   	pop    %ebp
80102ccb:	c3                   	ret    
80102ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 40 82 10 80       	push   $0x80108240
80102cdf:	68 20 37 11 80       	push   $0x80113720
80102ce4:	e8 07 20 00 00       	call   80104cf0 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 1b e9 ff ff       	call   80101610 <readsb>
  log.size = sb.nlog;
80102cf5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cfb:	59                   	pop    %ecx
  log.dev = dev;
80102cfc:	89 1d 64 37 11 80    	mov    %ebx,0x80113764
  log.size = sb.nlog;
80102d02:	89 15 58 37 11 80    	mov    %edx,0x80113758
  log.start = sb.logstart;
80102d08:	a3 54 37 11 80       	mov    %eax,0x80113754
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d15:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d18:	83 c4 10             	add    $0x10,%esp
80102d1b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d1d:	89 1d 68 37 11 80    	mov    %ebx,0x80113768
  for (i = 0; i < log.lh.n; i++) {
80102d23:	7e 1c                	jle    80102d41 <initlog+0x71>
80102d25:	c1 e3 02             	shl    $0x2,%ebx
80102d28:	31 d2                	xor    %edx,%edx
80102d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d34:	83 c2 04             	add    $0x4,%edx
80102d37:	89 8a 68 37 11 80    	mov    %ecx,-0x7feec898(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d3d:	39 d3                	cmp    %edx,%ebx
80102d3f:	75 ef                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d41:	83 ec 0c             	sub    $0xc,%esp
80102d44:	50                   	push   %eax
80102d45:	e8 96 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4a:	e8 81 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d4f:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80102d56:	00 00 00 
  write_head(); // clear the log
80102d59:	e8 12 ff ff ff       	call   80102c70 <write_head>
}
80102d5e:	83 c4 10             	add    $0x10,%esp
80102d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d64:	c9                   	leave  
80102d65:	c3                   	ret    
80102d66:	8d 76 00             	lea    0x0(%esi),%esi
80102d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 20 37 11 80       	push   $0x80113720
80102d7b:	e8 b0 20 00 00       	call   80104e30 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 20 37 11 80       	push   $0x80113720
80102d90:	68 20 37 11 80       	push   $0x80113720
80102d95:	e8 36 14 00 00       	call   801041d0 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 60 37 11 80       	mov    0x80113760,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102dab:	8b 15 68 37 11 80    	mov    0x80113768,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
80102dc7:	68 20 37 11 80       	push   $0x80113720
80102dcc:	e8 1f 21 00 00       	call   80104ef0 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d 76 00             	lea    0x0(%esi),%esi
80102dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 20 37 11 80       	push   $0x80113720
80102dee:	e8 3d 20 00 00       	call   80104e30 <acquire>
  log.outstanding -= 1;
80102df3:	a1 5c 37 11 80       	mov    0x8011375c,%eax
  if(log.committing)
80102df8:	8b 35 60 37 11 80    	mov    0x80113760,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e04:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e06:	89 1d 5c 37 11 80    	mov    %ebx,0x8011375c
  if(log.committing)
80102e0c:	0f 85 1a 01 00 00    	jne    80102f2c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 ee 00 00 00    	jne    80102f08 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e1a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e1d:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
80102e24:	00 00 00 
  release(&log.lock);
80102e27:	68 20 37 11 80       	push   $0x80113720
80102e2c:	e8 bf 20 00 00       	call   80104ef0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	0f 8e 85 00 00 00    	jle    80102ec7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e42:	a1 54 37 11 80       	mov    0x80113754,%eax
80102e47:	83 ec 08             	sub    $0x8,%esp
80102e4a:	01 d8                	add    %ebx,%eax
80102e4c:	83 c0 01             	add    $0x1,%eax
80102e4f:	50                   	push   %eax
80102e50:	ff 35 64 37 11 80    	pushl  0x80113764
80102e56:	e8 75 d2 ff ff       	call   801000d0 <bread>
80102e5b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5d:	58                   	pop    %eax
80102e5e:	5a                   	pop    %edx
80102e5f:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102e66:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6f:	e8 5c d2 ff ff       	call   801000d0 <bread>
80102e74:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e76:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e79:	83 c4 0c             	add    $0xc,%esp
80102e7c:	68 00 02 00 00       	push   $0x200
80102e81:	50                   	push   %eax
80102e82:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e85:	50                   	push   %eax
80102e86:	e8 65 21 00 00       	call   80104ff0 <memmove>
    bwrite(to);  // write the log
80102e8b:	89 34 24             	mov    %esi,(%esp)
80102e8e:	e8 0d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e93:	89 3c 24             	mov    %edi,(%esp)
80102e96:	e8 45 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e9b:	89 34 24             	mov    %esi,(%esp)
80102e9e:	e8 3d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea3:	83 c4 10             	add    $0x10,%esp
80102ea6:	3b 1d 68 37 11 80    	cmp    0x80113768,%ebx
80102eac:	7c 94                	jl     80102e42 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eae:	e8 bd fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102eb3:	e8 18 fd ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102eb8:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80102ebf:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec2:	e8 a9 fd ff ff       	call   80102c70 <write_head>
    acquire(&log.lock);
80102ec7:	83 ec 0c             	sub    $0xc,%esp
80102eca:	68 20 37 11 80       	push   $0x80113720
80102ecf:	e8 5c 1f 00 00       	call   80104e30 <acquire>
    wakeup(&log);
80102ed4:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
80102edb:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80102ee2:	00 00 00 
    wakeup(&log);
80102ee5:	e8 a6 14 00 00       	call   80104390 <wakeup>
    release(&log.lock);
80102eea:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102ef1:	e8 fa 1f 00 00       	call   80104ef0 <release>
80102ef6:	83 c4 10             	add    $0x10,%esp
}
80102ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102efc:	5b                   	pop    %ebx
80102efd:	5e                   	pop    %esi
80102efe:	5f                   	pop    %edi
80102eff:	5d                   	pop    %ebp
80102f00:	c3                   	ret    
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f08:	83 ec 0c             	sub    $0xc,%esp
80102f0b:	68 20 37 11 80       	push   $0x80113720
80102f10:	e8 7b 14 00 00       	call   80104390 <wakeup>
  release(&log.lock);
80102f15:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102f1c:	e8 cf 1f 00 00       	call   80104ef0 <release>
80102f21:	83 c4 10             	add    $0x10,%esp
}
80102f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f27:	5b                   	pop    %ebx
80102f28:	5e                   	pop    %esi
80102f29:	5f                   	pop    %edi
80102f2a:	5d                   	pop    %ebp
80102f2b:	c3                   	ret    
    panic("log.committing");
80102f2c:	83 ec 0c             	sub    $0xc,%esp
80102f2f:	68 44 82 10 80       	push   $0x80108244
80102f34:	e8 57 d4 ff ff       	call   80100390 <panic>
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 68 37 11 80    	mov    0x80113768,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 9d 00 00 00    	jg     80102ff6 <log_write+0xb6>
80102f59:	a1 58 37 11 80       	mov    0x80113758,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	0f 8d 8d 00 00 00    	jge    80102ff6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f69:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102f6e:	85 c0                	test   %eax,%eax
80102f70:	0f 8e 8d 00 00 00    	jle    80103003 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f76:	83 ec 0c             	sub    $0xc,%esp
80102f79:	68 20 37 11 80       	push   $0x80113720
80102f7e:	e8 ad 1e 00 00       	call   80104e30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f83:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102f89:	83 c4 10             	add    $0x10,%esp
80102f8c:	83 f9 00             	cmp    $0x0,%ecx
80102f8f:	7e 57                	jle    80102fe8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f91:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f94:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f96:	3b 15 6c 37 11 80    	cmp    0x8011376c,%edx
80102f9c:	75 0b                	jne    80102fa9 <log_write+0x69>
80102f9e:	eb 38                	jmp    80102fd8 <log_write+0x98>
80102fa0:	39 14 85 6c 37 11 80 	cmp    %edx,-0x7feec894(,%eax,4)
80102fa7:	74 2f                	je     80102fd8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102fa9:	83 c0 01             	add    $0x1,%eax
80102fac:	39 c1                	cmp    %eax,%ecx
80102fae:	75 f0                	jne    80102fa0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102fb7:	83 c0 01             	add    $0x1,%eax
80102fba:	a3 68 37 11 80       	mov    %eax,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
80102fbf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102fc2:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
80102fc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fcc:	c9                   	leave  
  release(&log.lock);
80102fcd:	e9 1e 1f 00 00       	jmp    80104ef0 <release>
80102fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd8:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
80102fdf:	eb de                	jmp    80102fbf <log_write+0x7f>
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	8b 43 08             	mov    0x8(%ebx),%eax
80102feb:	a3 6c 37 11 80       	mov    %eax,0x8011376c
  if (i == log.lh.n)
80102ff0:	75 cd                	jne    80102fbf <log_write+0x7f>
80102ff2:	31 c0                	xor    %eax,%eax
80102ff4:	eb c1                	jmp    80102fb7 <log_write+0x77>
    panic("too big a transaction");
80102ff6:	83 ec 0c             	sub    $0xc,%esp
80102ff9:	68 53 82 10 80       	push   $0x80108253
80102ffe:	e8 8d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103003:	83 ec 0c             	sub    $0xc,%esp
80103006:	68 69 82 10 80       	push   $0x80108269
8010300b:	e8 80 d3 ff ff       	call   80100390 <panic>

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 74 09 00 00       	call   80103990 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 6d 09 00 00       	call   80103990 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 84 82 10 80       	push   $0x80108284
8010302d:	e8 2e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103032:	e8 79 35 00 00       	call   801065b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 d4 08 00 00       	call   80103910 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 71 0e 00 00       	call   80103ec0 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 45 46 00 00       	call   801076a0 <switchkvm>
  seginit();
8010305b:	e8 b0 45 00 00       	call   80107610 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	pushl  -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 48 8f 11 80       	push   $0x80118f48
8010308c:	e8 2f f5 ff ff       	call   801025c0 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 da 4a 00 00       	call   80107b70 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 75 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 6b 45 00 00       	call   80107610 <seginit>
  picinit();       // disable pic
801030a5:	e8 46 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 41 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 dc da ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 27 38 00 00       	call   801068e0 <uartinit>
  pinit();         // process table
801030b9:	e8 32 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 6d 34 00 00       	call   80106530 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 63 de ff ff       	call   80100f30 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c b4 10 80       	push   $0x8010b48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 07 1f 00 00       	call   80104ff0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
801030f0:	00 00 00 
801030f3:	83 c4 10             	add    $0x10,%esp
801030f6:	05 20 38 11 80       	add    $0x80113820,%eax
801030fb:	3d 20 38 11 80       	cmp    $0x80113820,%eax
80103100:	76 71                	jbe    80103173 <main+0x103>
80103102:	bb 20 38 11 80       	mov    $0x80113820,%ebx
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103110:	e8 fb 07 00 00       	call   80103910 <mycpu>
80103115:	39 d8                	cmp    %ebx,%eax
80103117:	74 41                	je     8010315a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103119:	e8 72 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103123:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
8010312a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010312d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103134:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103137:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010313c:	0f b6 03             	movzbl (%ebx),%eax
8010313f:	83 ec 08             	sub    $0x8,%esp
80103142:	68 00 70 00 00       	push   $0x7000
80103147:	50                   	push   %eax
80103148:	e8 03 f8 ff ff       	call   80102950 <lapicstartap>
8010314d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010315a:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
80103161:	00 00 00 
80103164:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010316a:	05 20 38 11 80       	add    $0x80113820,%eax
8010316f:	39 c3                	cmp    %eax,%ebx
80103171:	72 9d                	jb     80103110 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103173:	83 ec 08             	sub    $0x8,%esp
80103176:	68 00 00 00 8e       	push   $0x8e000000
8010317b:	68 00 00 40 80       	push   $0x80400000
80103180:	e8 ab f4 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103185:	e8 56 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
8010318a:	e8 81 fe ff ff       	call   80103010 <mpmain>
8010318f:	90                   	nop

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	90                   	nop
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b0:	39 fb                	cmp    %edi,%ebx
801031b2:	89 fe                	mov    %edi,%esi
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 82 10 80       	push   $0x80108298
801031c3:	56                   	push   %esi
801031c4:	e8 c7 1d 00 00       	call   80104f90 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f1                	mov    %esi,%ecx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 11             	movzbl (%ecx),%edx
801031db:	83 c1 01             	add    $0x1,%ecx
801031de:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031e0:	39 f9                	cmp    %edi,%ecx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	89 f0                	mov    %esi,%eax
801031ff:	5b                   	pop    %ebx
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010320a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	85 c0                	test   %eax,%eax
80103231:	75 1b                	jne    8010324e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103233:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010323a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103241:	c1 e0 08             	shl    $0x8,%eax
80103244:	09 d0                	or     %edx,%eax
80103246:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103249:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324e:	ba 00 04 00 00       	mov    $0x400,%edx
80103253:	e8 38 ff ff ff       	call   80103190 <mpsearch1>
80103258:	85 c0                	test   %eax,%eax
8010325a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010325d:	0f 84 3d 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103266:	8b 58 04             	mov    0x4(%eax),%ebx
80103269:	85 db                	test   %ebx,%ebx
8010326b:	0f 84 4f 01 00 00    	je     801033c0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103271:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103277:	83 ec 04             	sub    $0x4,%esp
8010327a:	6a 04                	push   $0x4
8010327c:	68 b5 82 10 80       	push   $0x801082b5
80103281:	56                   	push   %esi
80103282:	e8 09 1d 00 00       	call   80104f90 <memcmp>
80103287:	83 c4 10             	add    $0x10,%esp
8010328a:	85 c0                	test   %eax,%eax
8010328c:	0f 85 2e 01 00 00    	jne    801033c0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103292:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103299:	3c 01                	cmp    $0x1,%al
8010329b:	0f 95 c2             	setne  %dl
8010329e:	3c 04                	cmp    $0x4,%al
801032a0:	0f 95 c0             	setne  %al
801032a3:	20 c2                	and    %al,%dl
801032a5:	0f 85 15 01 00 00    	jne    801033c0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801032ab:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801032b2:	66 85 ff             	test   %di,%di
801032b5:	74 1a                	je     801032d1 <mpinit+0xc1>
801032b7:	89 f0                	mov    %esi,%eax
801032b9:	01 f7                	add    %esi,%edi
  sum = 0;
801032bb:	31 d2                	xor    %edx,%edx
801032bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c0:	0f b6 08             	movzbl (%eax),%ecx
801032c3:	83 c0 01             	add    $0x1,%eax
801032c6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c8:	39 c7                	cmp    %eax,%edi
801032ca:	75 f4                	jne    801032c0 <mpinit+0xb0>
801032cc:	84 d2                	test   %dl,%dl
801032ce:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032d1:	85 f6                	test   %esi,%esi
801032d3:	0f 84 e7 00 00 00    	je     801033c0 <mpinit+0x1b0>
801032d9:	84 d2                	test   %dl,%dl
801032db:	0f 85 df 00 00 00    	jne    801033c0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032e7:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ec:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032f9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fe:	01 d6                	add    %edx,%esi
80103300:	39 c6                	cmp    %eax,%esi
80103302:	76 23                	jbe    80103327 <mpinit+0x117>
    switch(*p){
80103304:	0f b6 10             	movzbl (%eax),%edx
80103307:	80 fa 04             	cmp    $0x4,%dl
8010330a:	0f 87 ca 00 00 00    	ja     801033da <mpinit+0x1ca>
80103310:	ff 24 95 dc 82 10 80 	jmp    *-0x7fef7d24(,%edx,4)
80103317:	89 f6                	mov    %esi,%esi
80103319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103320:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103323:	39 c6                	cmp    %eax,%esi
80103325:	77 dd                	ja     80103304 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103327:	85 db                	test   %ebx,%ebx
80103329:	0f 84 9e 00 00 00    	je     801033cd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103332:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103336:	74 15                	je     8010334d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103338:	b8 70 00 00 00       	mov    $0x70,%eax
8010333d:	ba 22 00 00 00       	mov    $0x22,%edx
80103342:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103343:	ba 23 00 00 00       	mov    $0x23,%edx
80103348:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103349:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334c:	ee                   	out    %al,(%dx)
  }
}
8010334d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103358:	8b 0d a0 3d 11 80    	mov    0x80113da0,%ecx
8010335e:	83 f9 07             	cmp    $0x7,%ecx
80103361:	7f 19                	jg     8010337c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103363:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103367:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010336d:	83 c1 01             	add    $0x1,%ecx
80103370:	89 0d a0 3d 11 80    	mov    %ecx,0x80113da0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103376:	88 97 20 38 11 80    	mov    %dl,-0x7feec7e0(%edi)
      p += sizeof(struct mpproc);
8010337c:	83 c0 14             	add    $0x14,%eax
      continue;
8010337f:	e9 7c ff ff ff       	jmp    80103300 <mpinit+0xf0>
80103384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103388:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010338c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010338f:	88 15 00 38 11 80    	mov    %dl,0x80113800
      continue;
80103395:	e9 66 ff ff ff       	jmp    80103300 <mpinit+0xf0>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 e1 fd ff ff       	call   80103190 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033af:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801033b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b4:	0f 85 a9 fe ff ff    	jne    80103263 <mpinit+0x53>
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 9d 82 10 80       	push   $0x8010829d
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 bc 82 10 80       	push   $0x801082bc
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033da:	31 db                	xor    %ebx,%ebx
801033dc:	e9 26 ff ff ff       	jmp    80103307 <mpinit+0xf7>
801033e1:	66 90                	xchg   %ax,%ax
801033e3:	66 90                	xchg   %ax,%ax
801033e5:	66 90                	xchg   %ax,%ax
801033e7:	66 90                	xchg   %ax,%ax
801033e9:	66 90                	xchg   %ax,%ax
801033eb:	66 90                	xchg   %ax,%ax
801033ed:	66 90                	xchg   %ax,%ax
801033ef:	90                   	nop

801033f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033f0:	55                   	push   %ebp
801033f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f6:	ba 21 00 00 00       	mov    $0x21,%edx
801033fb:	89 e5                	mov    %esp,%ebp
801033fd:	ee                   	out    %al,(%dx)
801033fe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103403:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103404:	5d                   	pop    %ebp
80103405:	c3                   	ret    
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010341c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010341f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103425:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342b:	e8 20 db ff ff       	call   80100f50 <filealloc>
80103430:	85 c0                	test   %eax,%eax
80103432:	89 03                	mov    %eax,(%ebx)
80103434:	74 22                	je     80103458 <pipealloc+0x48>
80103436:	e8 15 db ff ff       	call   80100f50 <filealloc>
8010343b:	85 c0                	test   %eax,%eax
8010343d:	89 06                	mov    %eax,(%esi)
8010343f:	74 3f                	je     80103480 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103441:	e8 4a f2 ff ff       	call   80102690 <kalloc>
80103446:	85 c0                	test   %eax,%eax
80103448:	89 c7                	mov    %eax,%edi
8010344a:	75 54                	jne    801034a0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010344c:	8b 03                	mov    (%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	75 34                	jne    80103486 <pipealloc+0x76>
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103458:	8b 06                	mov    (%esi),%eax
8010345a:	85 c0                	test   %eax,%eax
8010345c:	74 0c                	je     8010346a <pipealloc+0x5a>
    fileclose(*f1);
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	50                   	push   %eax
80103462:	e8 a9 db ff ff       	call   80101010 <fileclose>
80103467:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010346a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010346d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103472:	5b                   	pop    %ebx
80103473:	5e                   	pop    %esi
80103474:	5f                   	pop    %edi
80103475:	5d                   	pop    %ebp
80103476:	c3                   	ret    
80103477:	89 f6                	mov    %esi,%esi
80103479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103480:	8b 03                	mov    (%ebx),%eax
80103482:	85 c0                	test   %eax,%eax
80103484:	74 e4                	je     8010346a <pipealloc+0x5a>
    fileclose(*f0);
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	50                   	push   %eax
8010348a:	e8 81 db ff ff       	call   80101010 <fileclose>
  if(*f1)
8010348f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103491:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103494:	85 c0                	test   %eax,%eax
80103496:	75 c6                	jne    8010345e <pipealloc+0x4e>
80103498:	eb d0                	jmp    8010346a <pipealloc+0x5a>
8010349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801034a0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801034a3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034aa:	00 00 00 
  p->writeopen = 1;
801034ad:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034b4:	00 00 00 
  p->nwrite = 0;
801034b7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034be:	00 00 00 
  p->nread = 0;
801034c1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c8:	00 00 00 
  initlock(&p->lock, "pipe");
801034cb:	68 f0 82 10 80       	push   $0x801082f0
801034d0:	50                   	push   %eax
801034d1:	e8 1a 18 00 00       	call   80104cf0 <initlock>
  (*f0)->type = FD_PIPE;
801034d6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034d8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e1:	8b 03                	mov    (%ebx),%eax
801034e3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034e7:	8b 03                	mov    (%ebx),%eax
801034e9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034ed:	8b 03                	mov    (%ebx),%eax
801034ef:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034fa:	8b 06                	mov    (%esi),%eax
801034fc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103500:	8b 06                	mov    (%esi),%eax
80103502:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103506:	8b 06                	mov    (%esi),%eax
80103508:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010350b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010350e:	31 c0                	xor    %eax,%eax
}
80103510:	5b                   	pop    %ebx
80103511:	5e                   	pop    %esi
80103512:	5f                   	pop    %edi
80103513:	5d                   	pop    %ebp
80103514:	c3                   	ret    
80103515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103520 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	56                   	push   %esi
80103524:	53                   	push   %ebx
80103525:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103528:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010352b:	83 ec 0c             	sub    $0xc,%esp
8010352e:	53                   	push   %ebx
8010352f:	e8 fc 18 00 00       	call   80104e30 <acquire>
  if(writable){
80103534:	83 c4 10             	add    $0x10,%esp
80103537:	85 f6                	test   %esi,%esi
80103539:	74 45                	je     80103580 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010353b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103541:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103544:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010354b:	00 00 00 
    wakeup(&p->nread);
8010354e:	50                   	push   %eax
8010354f:	e8 3c 0e 00 00       	call   80104390 <wakeup>
80103554:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103557:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010355d:	85 d2                	test   %edx,%edx
8010355f:	75 0a                	jne    8010356b <pipeclose+0x4b>
80103561:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103567:	85 c0                	test   %eax,%eax
80103569:	74 35                	je     801035a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010356b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010356e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103571:	5b                   	pop    %ebx
80103572:	5e                   	pop    %esi
80103573:	5d                   	pop    %ebp
    release(&p->lock);
80103574:	e9 77 19 00 00       	jmp    80104ef0 <release>
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103580:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103586:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 f7 0d 00 00       	call   80104390 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb b9                	jmp    80103557 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 47 19 00 00       	call   80104ef0 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 26 ef ff ff       	jmp    801024e0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 28             	sub    $0x28,%esp
801035c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035cc:	53                   	push   %ebx
801035cd:	e8 5e 18 00 00       	call   80104e30 <acquire>
  for(i = 0; i < n; i++){
801035d2:	8b 45 10             	mov    0x10(%ebp),%eax
801035d5:	83 c4 10             	add    $0x10,%esp
801035d8:	85 c0                	test   %eax,%eax
801035da:	0f 8e c9 00 00 00    	jle    801036a9 <pipewrite+0xe9>
801035e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035e3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035f2:	03 4d 10             	add    0x10(%ebp),%ecx
801035f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035fe:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103604:	39 d0                	cmp    %edx,%eax
80103606:	75 71                	jne    80103679 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103608:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	74 4e                	je     80103660 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103612:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103618:	eb 3a                	jmp    80103654 <pipewrite+0x94>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	57                   	push   %edi
80103624:	e8 67 0d 00 00       	call   80104390 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103629:	5a                   	pop    %edx
8010362a:	59                   	pop    %ecx
8010362b:	53                   	push   %ebx
8010362c:	56                   	push   %esi
8010362d:	e8 9e 0b 00 00       	call   801041d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103632:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103638:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010363e:	83 c4 10             	add    $0x10,%esp
80103641:	05 00 02 00 00       	add    $0x200,%eax
80103646:	39 c2                	cmp    %eax,%edx
80103648:	75 36                	jne    80103680 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010364a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103650:	85 c0                	test   %eax,%eax
80103652:	74 0c                	je     80103660 <pipewrite+0xa0>
80103654:	e8 57 03 00 00       	call   801039b0 <myproc>
80103659:	8b 40 24             	mov    0x24(%eax),%eax
8010365c:	85 c0                	test   %eax,%eax
8010365e:	74 c0                	je     80103620 <pipewrite+0x60>
        release(&p->lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	53                   	push   %ebx
80103664:	e8 87 18 00 00       	call   80104ef0 <release>
        return -1;
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103674:	5b                   	pop    %ebx
80103675:	5e                   	pop    %esi
80103676:	5f                   	pop    %edi
80103677:	5d                   	pop    %ebp
80103678:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103679:	89 c2                	mov    %eax,%edx
8010367b:	90                   	nop
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103680:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103683:	8d 42 01             	lea    0x1(%edx),%eax
80103686:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010368c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103692:	83 c6 01             	add    $0x1,%esi
80103695:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103699:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010369c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010369f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a3:	0f 85 4f ff ff ff    	jne    801035f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036a9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036af:	83 ec 0c             	sub    $0xc,%esp
801036b2:	50                   	push   %eax
801036b3:	e8 d8 0c 00 00       	call   80104390 <wakeup>
  release(&p->lock);
801036b8:	89 1c 24             	mov    %ebx,(%esp)
801036bb:	e8 30 18 00 00       	call   80104ef0 <release>
  return n;
801036c0:	83 c4 10             	add    $0x10,%esp
801036c3:	8b 45 10             	mov    0x10(%ebp),%eax
801036c6:	eb a9                	jmp    80103671 <pipewrite+0xb1>
801036c8:	90                   	nop
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	e8 4b 17 00 00       	call   80104e30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036ee:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036f4:	75 6a                	jne    80103760 <piperead+0x90>
801036f6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036fc:	85 db                	test   %ebx,%ebx
801036fe:	0f 84 c4 00 00 00    	je     801037c8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103704:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010370a:	eb 2d                	jmp    80103739 <piperead+0x69>
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 b6 0a 00 00       	call   801041d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103723:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103729:	75 35                	jne    80103760 <piperead+0x90>
8010372b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103731:	85 d2                	test   %edx,%edx
80103733:	0f 84 8f 00 00 00    	je     801037c8 <piperead+0xf8>
    if(myproc()->killed){
80103739:	e8 72 02 00 00       	call   801039b0 <myproc>
8010373e:	8b 48 24             	mov    0x24(%eax),%ecx
80103741:	85 c9                	test   %ecx,%ecx
80103743:	74 cb                	je     80103710 <piperead+0x40>
      release(&p->lock);
80103745:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103748:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010374d:	56                   	push   %esi
8010374e:	e8 9d 17 00 00       	call   80104ef0 <release>
      return -1;
80103753:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103759:	89 d8                	mov    %ebx,%eax
8010375b:	5b                   	pop    %ebx
8010375c:	5e                   	pop    %esi
8010375d:	5f                   	pop    %edi
8010375e:	5d                   	pop    %ebp
8010375f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103760:	8b 45 10             	mov    0x10(%ebp),%eax
80103763:	85 c0                	test   %eax,%eax
80103765:	7e 61                	jle    801037c8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103767:	31 db                	xor    %ebx,%ebx
80103769:	eb 13                	jmp    8010377e <piperead+0xae>
8010376b:	90                   	nop
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103770:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103776:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010377c:	74 1f                	je     8010379d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010377e:	8d 41 01             	lea    0x1(%ecx),%eax
80103781:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103787:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010378d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103792:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	83 c3 01             	add    $0x1,%ebx
80103798:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010379b:	75 d3                	jne    80103770 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010379d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037a3:	83 ec 0c             	sub    $0xc,%esp
801037a6:	50                   	push   %eax
801037a7:	e8 e4 0b 00 00       	call   80104390 <wakeup>
  release(&p->lock);
801037ac:	89 34 24             	mov    %esi,(%esp)
801037af:	e8 3c 17 00 00       	call   80104ef0 <release>
  return i;
801037b4:	83 c4 10             	add    $0x10,%esp
}
801037b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ba:	89 d8                	mov    %ebx,%eax
801037bc:	5b                   	pop    %ebx
801037bd:	5e                   	pop    %esi
801037be:	5f                   	pop    %edi
801037bf:	5d                   	pop    %ebp
801037c0:	c3                   	ret    
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c8:	31 db                	xor    %ebx,%ebx
801037ca:	eb d1                	jmp    8010379d <piperead+0xcd>
801037cc:	66 90                	xchg   %ax,%ax
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
801037d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037dc:	68 c0 3d 11 80       	push   $0x80113dc0
801037e1:	e8 4a 16 00 00       	call   80104e30 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 13                	jmp    801037fe <allocproc+0x2e>
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	81 c3 24 01 00 00    	add    $0x124,%ebx
801037f6:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
801037fc:	73 7a                	jae    80103878 <allocproc+0xa8>
    if(p->state == UNUSED)
801037fe:	8b 43 0c             	mov    0xc(%ebx),%eax
80103801:	85 c0                	test   %eax,%eax
80103803:	75 eb                	jne    801037f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103805:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010380a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010380d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103814:	8d 50 01             	lea    0x1(%eax),%edx
80103817:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010381a:	68 c0 3d 11 80       	push   $0x80113dc0
  p->pid = nextpid++;
8010381f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103825:	e8 c6 16 00 00       	call   80104ef0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010382a:	e8 61 ee ff ff       	call   80102690 <kalloc>
8010382f:	83 c4 10             	add    $0x10,%esp
80103832:	85 c0                	test   %eax,%eax
80103834:	89 43 08             	mov    %eax,0x8(%ebx)
80103837:	74 58                	je     80103891 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103839:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103842:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103847:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010384a:	c7 40 14 23 65 10 80 	movl   $0x80106523,0x14(%eax)
  p->context = (struct context*)sp;
80103851:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103854:	6a 14                	push   $0x14
80103856:	6a 00                	push   $0x0
80103858:	50                   	push   %eax
80103859:	e8 e2 16 00 00       	call   80104f40 <memset>
  p->context->eip = (uint)forkret;
8010385e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103861:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103864:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
8010386b:	89 d8                	mov    %ebx,%eax
8010386d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103870:	c9                   	leave  
80103871:	c3                   	ret    
80103872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103878:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010387b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010387d:	68 c0 3d 11 80       	push   $0x80113dc0
80103882:	e8 69 16 00 00       	call   80104ef0 <release>
}
80103887:	89 d8                	mov    %ebx,%eax
  return 0;
80103889:	83 c4 10             	add    $0x10,%esp
}
8010388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388f:	c9                   	leave  
80103890:	c3                   	ret    
    p->state = UNUSED;
80103891:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103898:	31 db                	xor    %ebx,%ebx
8010389a:	eb cf                	jmp    8010386b <allocproc+0x9b>
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 c0 3d 11 80       	push   $0x80113dc0
801038ab:	e8 40 16 00 00       	call   80104ef0 <release>

  if (first) {
801038b0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038c0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038c3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038ca:	00 00 00 
    iinit(ROOTDEV);
801038cd:	6a 01                	push   $0x1
801038cf:	e8 7c dd ff ff       	call   80101650 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 f0 f3 ff ff       	call   80102cd0 <initlog>
801038e0:	83 c4 10             	add    $0x10,%esp
}
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 f5 82 10 80       	push   $0x801082f5
801038fb:	68 c0 3d 11 80       	push   $0x80113dc0
80103900:	e8 eb 13 00 00       	call   80104cf0 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 5e                	jne    8010397a <mycpu+0x6a>
  apicid = lapicid();
8010391c:	e8 df ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 a0 3d 11 80    	mov    0x80113da0,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 42                	jle    8010396d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010392b:	0f b6 15 20 38 11 80 	movzbl 0x80113820,%edx
80103932:	39 d0                	cmp    %edx,%eax
80103934:	74 30                	je     80103966 <mycpu+0x56>
80103936:	b9 d0 38 11 80       	mov    $0x801138d0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 26                	je     8010396d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103947:	0f b6 19             	movzbl (%ecx),%ebx
8010394a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103950:	39 c3                	cmp    %eax,%ebx
80103952:	75 ec                	jne    80103940 <mycpu+0x30>
80103954:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010395a:	05 20 38 11 80       	add    $0x80113820,%eax
}
8010395f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103962:	5b                   	pop    %ebx
80103963:	5e                   	pop    %esi
80103964:	5d                   	pop    %ebp
80103965:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103966:	b8 20 38 11 80       	mov    $0x80113820,%eax
      return &cpus[i];
8010396b:	eb f2                	jmp    8010395f <mycpu+0x4f>
  panic("unknown apicid\n");
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 fc 82 10 80       	push   $0x801082fc
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 b4 84 10 80       	push   $0x801084b4
80103982:	e8 09 ca ff ff       	call   80100390 <panic>
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <cpuid>:
cpuid() {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103996:	e8 75 ff ff ff       	call   80103910 <mycpu>
8010399b:	2d 20 38 11 80       	sub    $0x80113820,%eax
}
801039a0:	c9                   	leave  
  return mycpu()-cpus;
801039a1:	c1 f8 04             	sar    $0x4,%eax
801039a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039aa:	c3                   	ret    
801039ab:	90                   	nop
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039b0 <myproc>:
myproc(void) {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039b7:	e8 a4 13 00 00       	call   80104d60 <pushcli>
  c = mycpu();
801039bc:	e8 4f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c7:	e8 d4 13 00 00       	call   80104da0 <popcli>
}
801039cc:	83 c4 04             	add    $0x4,%esp
801039cf:	89 d8                	mov    %ebx,%eax
801039d1:	5b                   	pop    %ebx
801039d2:	5d                   	pop    %ebp
801039d3:	c3                   	ret    
801039d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039e0 <userinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039e7:	e8 e4 fd ff ff       	call   801037d0 <allocproc>
801039ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ee:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039f3:	e8 f8 40 00 00       	call   80107af0 <setupkvm>
801039f8:	85 c0                	test   %eax,%eax
801039fa:	89 43 04             	mov    %eax,0x4(%ebx)
801039fd:	0f 84 bd 00 00 00    	je     80103ac0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a03:	83 ec 04             	sub    $0x4,%esp
80103a06:	68 2c 00 00 00       	push   $0x2c
80103a0b:	68 60 b4 10 80       	push   $0x8010b460
80103a10:	50                   	push   %eax
80103a11:	e8 ba 3d 00 00       	call   801077d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1f:	6a 4c                	push   $0x4c
80103a21:	6a 00                	push   $0x0
80103a23:	ff 73 18             	pushl  0x18(%ebx)
80103a26:	e8 15 15 00 00       	call   80104f40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a33:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a38:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a51:	8b 43 18             	mov    0x18(%ebx),%eax
80103a54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a70:	8b 43 18             	mov    0x18(%ebx),%eax
80103a73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a7d:	6a 10                	push   $0x10
80103a7f:	68 25 83 10 80       	push   $0x80108325
80103a84:	50                   	push   %eax
80103a85:	e8 96 16 00 00       	call   80105120 <safestrcpy>
  p->cwd = namei("/");
80103a8a:	c7 04 24 2e 83 10 80 	movl   $0x8010832e,(%esp)
80103a91:	e8 1a e6 ff ff       	call   801020b0 <namei>
80103a96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a99:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103aa0:	e8 8b 13 00 00       	call   80104e30 <acquire>
  p->state = RUNNABLE;
80103aa5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aac:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103ab3:	e8 38 14 00 00       	call   80104ef0 <release>
}
80103ab8:	83 c4 10             	add    $0x10,%esp
80103abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abe:	c9                   	leave  
80103abf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 0c 83 10 80       	push   $0x8010830c
80103ac8:	e8 c3 c8 ff ff       	call   80100390 <panic>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ad8:	e8 83 12 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103add:	e8 2e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 b3 12 00 00       	call   80104da0 <popcli>
  if(n > 0){
80103aed:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103af0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103af2:	7f 1c                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af4:	75 3a                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103af9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afb:	53                   	push   %ebx
80103afc:	e8 bf 3b 00 00       	call   801076c0 <switchuvm>
  return 0;
80103b01:	83 c4 10             	add    $0x10,%esp
80103b04:	31 c0                	xor    %eax,%eax
}
80103b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b09:	5b                   	pop    %ebx
80103b0a:	5e                   	pop    %esi
80103b0b:	5d                   	pop    %ebp
80103b0c:	c3                   	ret    
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 f1 3d 00 00       	call   80107910 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 d0                	jne    80103af6 <growproc+0x26>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb d9                	jmp    80103b06 <growproc+0x36>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	pushl  0x4(%ebx)
80103b3a:	e8 01 3f 00 00       	call   80107a40 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 b0                	jne    80103af6 <growproc+0x26>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b50 <fork>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b59:	e8 02 12 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103b5e:	e8 ad fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b69:	e8 32 12 00 00       	call   80104da0 <popcli>
  if((np = allocproc()) == 0){
80103b6e:	e8 5d fc ff ff       	call   801037d0 <allocproc>
80103b73:	85 c0                	test   %eax,%eax
80103b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b78:	0f 84 b7 00 00 00    	je     80103c35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b7e:	83 ec 08             	sub    $0x8,%esp
80103b81:	ff 33                	pushl  (%ebx)
80103b83:	ff 73 04             	pushl  0x4(%ebx)
80103b86:	89 c7                	mov    %eax,%edi
80103b88:	e8 33 40 00 00       	call   80107bc0 <copyuvm>
80103b8d:	83 c4 10             	add    $0x10,%esp
80103b90:	85 c0                	test   %eax,%eax
80103b92:	89 47 04             	mov    %eax,0x4(%edi)
80103b95:	0f 84 a1 00 00 00    	je     80103c3c <fork+0xec>
  np->sz = curproc->sz;
80103b9b:	8b 03                	mov    (%ebx),%eax
80103b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ba0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ba2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ba5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103ba7:	8b 79 18             	mov    0x18(%ecx),%edi
80103baa:	8b 73 18             	mov    0x18(%ebx),%esi
80103bad:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bb6:	8b 40 18             	mov    0x18(%eax),%eax
80103bb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 13                	je     80103bdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	50                   	push   %eax
80103bcc:	e8 ef d3 ff ff       	call   80100fc0 <filedup>
80103bd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bd4:	83 c4 10             	add    $0x10,%esp
80103bd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bdb:	83 c6 01             	add    $0x1,%esi
80103bde:	83 fe 10             	cmp    $0x10,%esi
80103be1:	75 dd                	jne    80103bc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103be3:	83 ec 0c             	sub    $0xc,%esp
80103be6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bec:	e8 2f dc ff ff       	call   80101820 <idup>
80103bf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	53                   	push   %ebx
80103c00:	50                   	push   %eax
80103c01:	e8 1a 15 00 00       	call   80105120 <safestrcpy>
  pid = np->pid;
80103c06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c09:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c10:	e8 1b 12 00 00       	call   80104e30 <acquire>
  np->state = RUNNABLE;
80103c15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c1c:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c23:	e8 c8 12 00 00       	call   80104ef0 <release>
  return pid;
80103c28:	83 c4 10             	add    $0x10,%esp
}
80103c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c2e:	89 d8                	mov    %ebx,%eax
80103c30:	5b                   	pop    %ebx
80103c31:	5e                   	pop    %esi
80103c32:	5f                   	pop    %edi
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    
    return -1;
80103c35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c3a:	eb ef                	jmp    80103c2b <fork+0xdb>
    kfree(np->kstack);
80103c3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c3f:	83 ec 0c             	sub    $0xc,%esp
80103c42:	ff 73 08             	pushl  0x8(%ebx)
80103c45:	e8 96 e8 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103c4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c51:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c58:	83 c4 10             	add    $0x10,%esp
80103c5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c60:	eb c9                	jmp    80103c2b <fork+0xdb>
80103c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c70 <BJF>:
struct proc * BJF(struct proc** list, int size){
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 04             	sub    $0x4,%esp
80103c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i=0; i < size; i++){
80103c7f:	85 c9                	test   %ecx,%ecx
  struct proc* chosen = list[0];
80103c81:	8b 03                	mov    (%ebx),%eax
  for (int i=0; i < size; i++){
80103c83:	0f 8e 94 00 00 00    	jle    80103d1d <BJF+0xad>
    if (list[i] -> state == RUNNABLE){
80103c89:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c8d:	0f 84 d5 00 00 00    	je     80103d68 <BJF+0xf8>
  for (int i=0; i < size; i++){
80103c93:	31 f6                	xor    %esi,%esi
80103c95:	eb 14                	jmp    80103cab <BJF+0x3b>
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (list[i] -> state == RUNNABLE){
80103ca0:	8b 3c 93             	mov    (%ebx,%edx,4),%edi
80103ca3:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103ca7:	74 7f                	je     80103d28 <BJF+0xb8>
80103ca9:	89 d6                	mov    %edx,%esi
  for (int i=0; i < size; i++){
80103cab:	8d 56 01             	lea    0x1(%esi),%edx
80103cae:	39 d1                	cmp    %edx,%ecx
80103cb0:	75 ee                	jne    80103ca0 <BJF+0x30>
80103cb2:	be 01 00 00 00       	mov    $0x1,%esi
  int rank = 0, ind = 0;
80103cb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (int i=ind + 1; i < size; i++){
80103cbe:	39 f1                	cmp    %esi,%ecx
80103cc0:	7e 5b                	jle    80103d1d <BJF+0xad>
80103cc2:	8d 34 b3             	lea    (%ebx,%esi,4),%esi
80103cc5:	8d 3c 8b             	lea    (%ebx,%ecx,4),%edi
80103cc8:	eb 0d                	jmp    80103cd7 <BJF+0x67>
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cd0:	83 c6 04             	add    $0x4,%esi
80103cd3:	39 f7                	cmp    %esi,%edi
80103cd5:	74 46                	je     80103d1d <BJF+0xad>
    if (list[i]->state == RUNNABLE){
80103cd7:	8b 16                	mov    (%esi),%edx
80103cd9:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103cdd:	75 f1                	jne    80103cd0 <BJF+0x60>
      int cur_rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103cdf:	8b 8a f8 00 00 00    	mov    0xf8(%edx),%ecx
80103ce5:	8b 9a fc 00 00 00    	mov    0xfc(%edx),%ebx
80103ceb:	0f af d9             	imul   %ecx,%ebx
80103cee:	8b 8a 00 01 00 00    	mov    0x100(%edx),%ecx
80103cf4:	0f af 8a 04 01 00 00 	imul   0x104(%edx),%ecx
80103cfb:	01 d9                	add    %ebx,%ecx
80103cfd:	8b 9a 08 01 00 00    	mov    0x108(%edx),%ebx
80103d03:	0f af 9a 0c 01 00 00 	imul   0x10c(%edx),%ebx
80103d0a:	01 d9                	add    %ebx,%ecx
      if (cur_rank < rank){
80103d0c:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
80103d0f:	7d bf                	jge    80103cd0 <BJF+0x60>
80103d11:	83 c6 04             	add    $0x4,%esi
80103d14:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80103d17:	89 d0                	mov    %edx,%eax
  for (int i=ind + 1; i < size; i++){
80103d19:	39 f7                	cmp    %esi,%edi
80103d1b:	75 ba                	jne    80103cd7 <BJF+0x67>
}
80103d1d:	83 c4 04             	add    $0x4,%esp
80103d20:	5b                   	pop    %ebx
80103d21:	5e                   	pop    %esi
80103d22:	5f                   	pop    %edi
80103d23:	5d                   	pop    %ebp
80103d24:	c3                   	ret    
80103d25:	8d 76 00             	lea    0x0(%esi),%esi
80103d28:	83 c6 02             	add    $0x2,%esi
    if (list[i] -> state == RUNNABLE){
80103d2b:	89 f8                	mov    %edi,%eax
      rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103d2d:	8b 90 f8 00 00 00    	mov    0xf8(%eax),%edx
80103d33:	8b b8 fc 00 00 00    	mov    0xfc(%eax),%edi
80103d39:	0f af fa             	imul   %edx,%edi
80103d3c:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
80103d42:	0f af 90 04 01 00 00 	imul   0x104(%eax),%edx
80103d49:	01 fa                	add    %edi,%edx
80103d4b:	8b b8 08 01 00 00    	mov    0x108(%eax),%edi
80103d51:	0f af b8 0c 01 00 00 	imul   0x10c(%eax),%edi
80103d58:	01 d7                	add    %edx,%edi
80103d5a:	89 7d f0             	mov    %edi,-0x10(%ebp)
      break;
80103d5d:	e9 5c ff ff ff       	jmp    80103cbe <BJF+0x4e>
80103d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (list[i] -> state == RUNNABLE){
80103d68:	be 01 00 00 00       	mov    $0x1,%esi
80103d6d:	eb be                	jmp    80103d2d <BJF+0xbd>
80103d6f:	90                   	nop

80103d70 <RR>:
struct proc* RR(struct proc ** list, int size){
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d78:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i=0; i < size; i++){
80103d7b:	85 c9                	test   %ecx,%ecx
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103d7d:	8b 02                	mov    (%edx),%eax
  for (int i=0; i < size; i++){
80103d7f:	7e 10                	jle    80103d91 <RR+0x21>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103d81:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d85:	74 0a                	je     80103d91 <RR+0x21>
80103d87:	8b 98 14 01 00 00    	mov    0x114(%eax),%ebx
80103d8d:	85 db                	test   %ebx,%ebx
80103d8f:	75 07                	jne    80103d98 <RR+0x28>
}
80103d91:	5b                   	pop    %ebx
80103d92:	5e                   	pop    %esi
80103d93:	5d                   	pop    %ebp
80103d94:	c3                   	ret    
80103d95:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i=0; i < size; i++){
80103d98:	31 db                	xor    %ebx,%ebx
80103d9a:	83 c3 01             	add    $0x1,%ebx
80103d9d:	39 d9                	cmp    %ebx,%ecx
80103d9f:	74 1f                	je     80103dc0 <RR+0x50>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103da1:	8b 34 9a             	mov    (%edx,%ebx,4),%esi
80103da4:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103da8:	74 09                	je     80103db3 <RR+0x43>
80103daa:	83 be 14 01 00 00 00 	cmpl   $0x0,0x114(%esi)
80103db1:	75 e7                	jne    80103d9a <RR+0x2a>
80103db3:	89 f0                	mov    %esi,%eax
}
80103db5:	5b                   	pop    %ebx
80103db6:	5e                   	pop    %esi
80103db7:	5d                   	pop    %ebp
80103db8:	c3                   	ret    
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dc0:	8d 72 04             	lea    0x4(%edx),%esi
80103dc3:	8d 1c 8a             	lea    (%edx,%ecx,4),%ebx
  for (int i=0; i < size; i++){
80103dc6:	89 f1                	mov    %esi,%ecx
80103dc8:	eb 0b                	jmp    80103dd5 <RR+0x65>
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dd0:	8b 01                	mov    (%ecx),%eax
80103dd2:	83 c1 04             	add    $0x4,%ecx
  for (int i=0; i < size; i++)
80103dd5:	39 d9                	cmp    %ebx,%ecx
    list[i]->visit = 0;
80103dd7:	c7 80 14 01 00 00 00 	movl   $0x0,0x114(%eax)
80103dde:	00 00 00 
  for (int i=0; i < size; i++)
80103de1:	75 ed                	jne    80103dd0 <RR+0x60>
    if(list[i]->state != RUNNABLE)
80103de3:	8b 02                	mov    (%edx),%eax
80103de5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103de9:	74 a6                	je     80103d91 <RR+0x21>
  for (int i=0; i < size; i++){
80103deb:	39 f1                	cmp    %esi,%ecx
80103ded:	74 a2                	je     80103d91 <RR+0x21>
    if(list[i]->state != RUNNABLE)
80103def:	8b 16                	mov    (%esi),%edx
80103df1:	83 c6 04             	add    $0x4,%esi
80103df4:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103df8:	75 f1                	jne    80103deb <RR+0x7b>
80103dfa:	89 d0                	mov    %edx,%eax
80103dfc:	eb 93                	jmp    80103d91 <RR+0x21>
80103dfe:	66 90                	xchg   %ax,%ax

80103e00 <generate_random>:
int generate_random(int m){
80103e00:	55                   	push   %ebp
 int a = ticks % m;
80103e01:	a1 40 8f 11 80       	mov    0x80118f40,%eax
80103e06:	31 d2                	xor    %edx,%edx
int generate_random(int m){
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	53                   	push   %ebx
80103e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
80103e0e:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103e10:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103e12:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80103e14:	0f af c2             	imul   %edx,%eax
80103e17:	99                   	cltd   
80103e18:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103e1a:	89 d0                	mov    %edx,%eax
80103e1c:	0f af c3             	imul   %ebx,%eax
}
80103e1f:	5b                   	pop    %ebx
80103e20:	5d                   	pop    %ebp
 random = (a * random )% m;
80103e21:	99                   	cltd   
80103e22:	f7 f9                	idiv   %ecx
}
80103e24:	89 d0                	mov    %edx,%eax
80103e26:	c3                   	ret    
80103e27:	89 f6                	mov    %esi,%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <lotteryScheduling>:
struct proc* lotteryScheduling(struct proc ** list,int size){
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	8b 75 0c             	mov    0xc(%ebp),%esi
80103e38:	53                   	push   %ebx
80103e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int p = 0; p < size;p++){
80103e3c:	85 f6                	test   %esi,%esi
80103e3e:	7e 70                	jle    80103eb0 <lotteryScheduling+0x80>
80103e40:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103e43:	89 d8                	mov    %ebx,%eax
  int sum_lotteries = 0;
80103e45:	31 c9                	xor    %ecx,%ecx
80103e47:	89 f6                	mov    %esi,%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(list[p]->state == RUNNABLE)
80103e50:	8b 10                	mov    (%eax),%edx
80103e52:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103e56:	75 06                	jne    80103e5e <lotteryScheduling+0x2e>
       sum_lotteries += list[p]->lottery_ticket;
80103e58:	03 8a 10 01 00 00    	add    0x110(%edx),%ecx
80103e5e:	83 c0 04             	add    $0x4,%eax
  for(int p = 0; p < size;p++){
80103e61:	39 f8                	cmp    %edi,%eax
80103e63:	75 eb                	jne    80103e50 <lotteryScheduling+0x20>
  if(sum_lotteries == 0)
80103e65:	85 c9                	test   %ecx,%ecx
80103e67:	74 47                	je     80103eb0 <lotteryScheduling+0x80>
 int a = ticks % m;
80103e69:	a1 40 8f 11 80       	mov    0x80118f40,%eax
80103e6e:	31 d2                	xor    %edx,%edx
80103e70:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103e72:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103e74:	89 d7                	mov    %edx,%edi
 random = (a * seed )% m;
80103e76:	0f af c2             	imul   %edx,%eax
80103e79:	99                   	cltd   
80103e7a:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103e7c:	89 d0                	mov    %edx,%eax
80103e7e:	0f af c7             	imul   %edi,%eax
  int curr_sum = 0;
80103e81:	31 ff                	xor    %edi,%edi
 random = (a * random )% m;
80103e83:	99                   	cltd   
80103e84:	f7 f9                	idiv   %ecx
  for(int p = 0; p < size ;p++){
80103e86:	31 c9                	xor    %ecx,%ecx
80103e88:	eb 0d                	jmp    80103e97 <lotteryScheduling+0x67>
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e90:	83 c1 01             	add    $0x1,%ecx
80103e93:	39 ce                	cmp    %ecx,%esi
80103e95:	74 19                	je     80103eb0 <lotteryScheduling+0x80>
    if(list[p]->state == RUNNABLE){
80103e97:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
80103e9a:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e9e:	75 f0                	jne    80103e90 <lotteryScheduling+0x60>
      curr_sum += list[p]->lottery_ticket;
80103ea0:	03 b8 10 01 00 00    	add    0x110(%eax),%edi
      if(curr_sum > random_ticket) {
80103ea6:	39 d7                	cmp    %edx,%edi
80103ea8:	7e e6                	jle    80103e90 <lotteryScheduling+0x60>
}
80103eaa:	5b                   	pop    %ebx
80103eab:	5e                   	pop    %esi
80103eac:	5f                   	pop    %edi
80103ead:	5d                   	pop    %ebp
80103eae:	c3                   	ret    
80103eaf:	90                   	nop
80103eb0:	5b                   	pop    %ebx
      return 0;
80103eb1:	31 c0                	xor    %eax,%eax
}
80103eb3:	5e                   	pop    %esi
80103eb4:	5f                   	pop    %edi
80103eb5:	5d                   	pop    %ebp
80103eb6:	c3                   	ret    
80103eb7:	89 f6                	mov    %esi,%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <scheduler>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
  int cycle = 0;
80103ec6:	31 db                	xor    %ebx,%ebx
{
80103ec8:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103ecb:	e8 40 fa ff ff       	call   80103910 <mycpu>
80103ed0:	8d 78 04             	lea    0x4(%eax),%edi
80103ed3:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ed5:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103edc:	00 00 00 
80103edf:	90                   	nop
  asm volatile("sti");
80103ee0:	fb                   	sti    
    acquire(&ptable.lock);
80103ee1:	83 ec 0c             	sub    $0xc,%esp
80103ee4:	68 c0 3d 11 80       	push   $0x80113dc0
80103ee9:	e8 42 0f 00 00       	call   80104e30 <acquire>
    release(&ptable.lock);
80103eee:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103ef5:	e8 f6 0f 00 00       	call   80104ef0 <release>
    p->waiting_time = 0;
80103efa:	c7 05 0c 3f 11 80 00 	movl   $0x0,0x80113f0c
80103f01:	00 00 00 
    p->last_cycle = cycle;
80103f04:	89 1d 10 3f 11 80    	mov    %ebx,0x80113f10
    c->proc = p;
80103f0a:	c7 86 ac 00 00 00 f4 	movl   $0x80113df4,0xac(%esi)
80103f11:	3d 11 80 
    switchuvm(p);
80103f14:	c7 04 24 f4 3d 11 80 	movl   $0x80113df4,(%esp)
80103f1b:	e8 a0 37 00 00       	call   801076c0 <switchuvm>
    if (p -> level == 3)
80103f20:	83 c4 10             	add    $0x10,%esp
80103f23:	83 3d e8 3e 11 80 03 	cmpl   $0x3,0x80113ee8
    p->state = RUNNING;
80103f2a:	c7 05 00 3e 11 80 04 	movl   $0x4,0x80113e00
80103f31:	00 00 00 
    if (p -> level == 3)
80103f34:	75 26                	jne    80103f5c <scheduler+0x9c>
      p -> exect += 0.1;
80103f36:	db 05 fc 3e 11 80    	fildl  0x80113efc
80103f3c:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f3f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f43:	dc 05 80 86 10 80    	faddl  0x80108680
80103f49:	80 cc 0c             	or     $0xc,%ah
80103f4c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f50:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f53:	db 1d fc 3e 11 80    	fistpl 0x80113efc
80103f59:	d9 6d e6             	fldcw  -0x1a(%ebp)
    swtch(&(c->scheduler), p->context);
80103f5c:	83 ec 08             	sub    $0x8,%esp
80103f5f:	ff 35 10 3e 11 80    	pushl  0x80113e10
    cycle += 1;
80103f65:	83 c3 01             	add    $0x1,%ebx
    swtch(&(c->scheduler), p->context);
80103f68:	57                   	push   %edi
80103f69:	e8 0d 12 00 00       	call   8010517b <swtch>
    switchkvm();
80103f6e:	e8 2d 37 00 00       	call   801076a0 <switchkvm>
    c->proc = 0;
80103f73:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f7a:	00 00 00 
  for(;;){
80103f7d:	83 c4 10             	add    $0x10,%esp
80103f80:	e9 5b ff ff ff       	jmp    80103ee0 <scheduler+0x20>
80103f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <sched>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli();
80103f95:	e8 c6 0d 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103f9a:	e8 71 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa5:	e8 f6 0d 00 00       	call   80104da0 <popcli>
  if(!holding(&ptable.lock))
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 c0 3d 11 80       	push   $0x80113dc0
80103fb2:	e8 49 0e 00 00       	call   80104e00 <holding>
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 4f                	je     8010400d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fbe:	e8 4d f9 ff ff       	call   80103910 <mycpu>
80103fc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fca:	75 68                	jne    80104034 <sched+0xa4>
  if(p->state == RUNNING)
80103fcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fd0:	74 55                	je     80104027 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fd2:	9c                   	pushf  
80103fd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fd4:	f6 c4 02             	test   $0x2,%ah
80103fd7:	75 41                	jne    8010401a <sched+0x8a>
  intena = mycpu()->intena;
80103fd9:	e8 32 f9 ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fe1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fe7:	e8 24 f9 ff ff       	call   80103910 <mycpu>
80103fec:	83 ec 08             	sub    $0x8,%esp
80103fef:	ff 70 04             	pushl  0x4(%eax)
80103ff2:	53                   	push   %ebx
80103ff3:	e8 83 11 00 00       	call   8010517b <swtch>
  mycpu()->intena = intena;
80103ff8:	e8 13 f9 ff ff       	call   80103910 <mycpu>
}
80103ffd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104000:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
8010400c:	c3                   	ret    
    panic("sched ptable.lock");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 30 83 10 80       	push   $0x80108330
80104015:	e8 76 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 5c 83 10 80       	push   $0x8010835c
80104022:	e8 69 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 4e 83 10 80       	push   $0x8010834e
8010402f:	e8 5c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104034:	83 ec 0c             	sub    $0xc,%esp
80104037:	68 42 83 10 80       	push   $0x80108342
8010403c:	e8 4f c3 ff ff       	call   80100390 <panic>
80104041:	eb 0d                	jmp    80104050 <exit>
80104043:	90                   	nop
80104044:	90                   	nop
80104045:	90                   	nop
80104046:	90                   	nop
80104047:	90                   	nop
80104048:	90                   	nop
80104049:	90                   	nop
8010404a:	90                   	nop
8010404b:	90                   	nop
8010404c:	90                   	nop
8010404d:	90                   	nop
8010404e:	90                   	nop
8010404f:	90                   	nop

80104050 <exit>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104059:	e8 02 0d 00 00       	call   80104d60 <pushcli>
  c = mycpu();
8010405e:	e8 ad f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104063:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104069:	e8 32 0d 00 00       	call   80104da0 <popcli>
  if(curproc == initproc)
8010406e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104074:	8d 5e 28             	lea    0x28(%esi),%ebx
80104077:	8d 7e 68             	lea    0x68(%esi),%edi
8010407a:	0f 84 f1 00 00 00    	je     80104171 <exit+0x121>
    if(curproc->ofile[fd]){
80104080:	8b 03                	mov    (%ebx),%eax
80104082:	85 c0                	test   %eax,%eax
80104084:	74 12                	je     80104098 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104086:	83 ec 0c             	sub    $0xc,%esp
80104089:	50                   	push   %eax
8010408a:	e8 81 cf ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
8010408f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104095:	83 c4 10             	add    $0x10,%esp
80104098:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010409b:	39 fb                	cmp    %edi,%ebx
8010409d:	75 e1                	jne    80104080 <exit+0x30>
  begin_op();
8010409f:	e8 cc ec ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
801040a4:	83 ec 0c             	sub    $0xc,%esp
801040a7:	ff 76 68             	pushl  0x68(%esi)
801040aa:	e8 d1 d8 ff ff       	call   80101980 <iput>
  end_op();
801040af:	e8 2c ed ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
801040b4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801040bb:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801040c2:	e8 69 0d 00 00       	call   80104e30 <acquire>
  wakeup1(curproc->parent);
801040c7:	8b 56 14             	mov    0x14(%esi),%edx
801040ca:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040cd:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801040d2:	eb 10                	jmp    801040e4 <exit+0x94>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d8:	05 24 01 00 00       	add    $0x124,%eax
801040dd:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
801040e2:	73 1e                	jae    80104102 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801040e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040e8:	75 ee                	jne    801040d8 <exit+0x88>
801040ea:	3b 50 20             	cmp    0x20(%eax),%edx
801040ed:	75 e9                	jne    801040d8 <exit+0x88>
      p->state = RUNNABLE;
801040ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040f6:	05 24 01 00 00       	add    $0x124,%eax
801040fb:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104100:	72 e2                	jb     801040e4 <exit+0x94>
      p->parent = initproc;
80104102:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104108:	ba f4 3d 11 80       	mov    $0x80113df4,%edx
8010410d:	eb 0f                	jmp    8010411e <exit+0xce>
8010410f:	90                   	nop
80104110:	81 c2 24 01 00 00    	add    $0x124,%edx
80104116:	81 fa f4 86 11 80    	cmp    $0x801186f4,%edx
8010411c:	73 3a                	jae    80104158 <exit+0x108>
    if(p->parent == curproc){
8010411e:	39 72 14             	cmp    %esi,0x14(%edx)
80104121:	75 ed                	jne    80104110 <exit+0xc0>
      if(p->state == ZOMBIE)
80104123:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104127:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010412a:	75 e4                	jne    80104110 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412c:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104131:	eb 11                	jmp    80104144 <exit+0xf4>
80104133:	90                   	nop
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104138:	05 24 01 00 00       	add    $0x124,%eax
8010413d:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104142:	73 cc                	jae    80104110 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104144:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104148:	75 ee                	jne    80104138 <exit+0xe8>
8010414a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010414d:	75 e9                	jne    80104138 <exit+0xe8>
      p->state = RUNNABLE;
8010414f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104156:	eb e0                	jmp    80104138 <exit+0xe8>
  curproc->state = ZOMBIE;
80104158:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010415f:	e8 2c fe ff ff       	call   80103f90 <sched>
  panic("zombie exit");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 7d 83 10 80       	push   $0x8010837d
8010416c:	e8 1f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	68 70 83 10 80       	push   $0x80108370
80104179:	e8 12 c2 ff ff       	call   80100390 <panic>
8010417e:	66 90                	xchg   %ax,%ax

80104180 <yield>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104187:	68 c0 3d 11 80       	push   $0x80113dc0
8010418c:	e8 9f 0c 00 00       	call   80104e30 <acquire>
  pushcli();
80104191:	e8 ca 0b 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80104196:	e8 75 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010419b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a1:	e8 fa 0b 00 00       	call   80104da0 <popcli>
  myproc()->state = RUNNABLE;
801041a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041ad:	e8 de fd ff ff       	call   80103f90 <sched>
  release(&ptable.lock);
801041b2:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801041b9:	e8 32 0d 00 00       	call   80104ef0 <release>
}
801041be:	83 c4 10             	add    $0x10,%esp
801041c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <sleep>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041df:	e8 7c 0b 00 00       	call   80104d60 <pushcli>
  c = mycpu();
801041e4:	e8 27 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801041e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041ef:	e8 ac 0b 00 00       	call   80104da0 <popcli>
  if(p == 0)
801041f4:	85 db                	test   %ebx,%ebx
801041f6:	0f 84 87 00 00 00    	je     80104283 <sleep+0xb3>
  if(lk == 0)
801041fc:	85 f6                	test   %esi,%esi
801041fe:	74 76                	je     80104276 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104200:	81 fe c0 3d 11 80    	cmp    $0x80113dc0,%esi
80104206:	74 50                	je     80104258 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 c0 3d 11 80       	push   $0x80113dc0
80104210:	e8 1b 0c 00 00       	call   80104e30 <acquire>
    release(lk);
80104215:	89 34 24             	mov    %esi,(%esp)
80104218:	e8 d3 0c 00 00       	call   80104ef0 <release>
  p->chan = chan;
8010421d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104220:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104227:	e8 64 fd ff ff       	call   80103f90 <sched>
  p->chan = 0;
8010422c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104233:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010423a:	e8 b1 0c 00 00       	call   80104ef0 <release>
    acquire(lk);
8010423f:	89 75 08             	mov    %esi,0x8(%ebp)
80104242:	83 c4 10             	add    $0x10,%esp
}
80104245:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104248:	5b                   	pop    %ebx
80104249:	5e                   	pop    %esi
8010424a:	5f                   	pop    %edi
8010424b:	5d                   	pop    %ebp
    acquire(lk);
8010424c:	e9 df 0b 00 00       	jmp    80104e30 <acquire>
80104251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104258:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010425b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104262:	e8 29 fd ff ff       	call   80103f90 <sched>
  p->chan = 0;
80104267:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010426e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104271:	5b                   	pop    %ebx
80104272:	5e                   	pop    %esi
80104273:	5f                   	pop    %edi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
    panic("sleep without lk");
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	68 8f 83 10 80       	push   $0x8010838f
8010427e:	e8 0d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104283:	83 ec 0c             	sub    $0xc,%esp
80104286:	68 89 83 10 80       	push   $0x80108389
8010428b:	e8 00 c1 ff ff       	call   80100390 <panic>

80104290 <wait>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
  pushcli();
80104295:	e8 c6 0a 00 00       	call   80104d60 <pushcli>
  c = mycpu();
8010429a:	e8 71 f6 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010429f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042a5:	e8 f6 0a 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 c0 3d 11 80       	push   $0x80113dc0
801042b2:	e8 79 0b 00 00       	call   80104e30 <acquire>
801042b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042bc:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
801042c1:	eb 13                	jmp    801042d6 <wait+0x46>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	81 c3 24 01 00 00    	add    $0x124,%ebx
801042ce:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
801042d4:	73 1e                	jae    801042f4 <wait+0x64>
      if(p->parent != curproc)
801042d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042d9:	75 ed                	jne    801042c8 <wait+0x38>
      if(p->state == ZOMBIE){
801042db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042df:	74 37                	je     80104318 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e1:	81 c3 24 01 00 00    	add    $0x124,%ebx
      havekids = 1;
801042e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ec:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
801042f2:	72 e2                	jb     801042d6 <wait+0x46>
    if(!havekids || curproc->killed){
801042f4:	85 c0                	test   %eax,%eax
801042f6:	74 76                	je     8010436e <wait+0xde>
801042f8:	8b 46 24             	mov    0x24(%esi),%eax
801042fb:	85 c0                	test   %eax,%eax
801042fd:	75 6f                	jne    8010436e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042ff:	83 ec 08             	sub    $0x8,%esp
80104302:	68 c0 3d 11 80       	push   $0x80113dc0
80104307:	56                   	push   %esi
80104308:	e8 c3 fe ff ff       	call   801041d0 <sleep>
    havekids = 0;
8010430d:	83 c4 10             	add    $0x10,%esp
80104310:	eb a8                	jmp    801042ba <wait+0x2a>
80104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010431e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104321:	e8 ba e1 ff ff       	call   801024e0 <kfree>
        freevm(p->pgdir);
80104326:	5a                   	pop    %edx
80104327:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010432a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104331:	e8 3a 37 00 00       	call   80107a70 <freevm>
        release(&ptable.lock);
80104336:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
        p->pid = 0;
8010433d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104344:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010434b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010434f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104356:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010435d:	e8 8e 0b 00 00       	call   80104ef0 <release>
        return pid;
80104362:	83 c4 10             	add    $0x10,%esp
}
80104365:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104368:	89 f0                	mov    %esi,%eax
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5d                   	pop    %ebp
8010436d:	c3                   	ret    
      release(&ptable.lock);
8010436e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104371:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104376:	68 c0 3d 11 80       	push   $0x80113dc0
8010437b:	e8 70 0b 00 00       	call   80104ef0 <release>
      return -1;
80104380:	83 c4 10             	add    $0x10,%esp
80104383:	eb e0                	jmp    80104365 <wait+0xd5>
80104385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010439a:	68 c0 3d 11 80       	push   $0x80113dc0
8010439f:	e8 8c 0a 00 00       	call   80104e30 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a7:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801043ac:	eb 0e                	jmp    801043bc <wakeup+0x2c>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	05 24 01 00 00       	add    $0x124,%eax
801043b5:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
801043ba:	73 1e                	jae    801043da <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801043bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043c0:	75 ee                	jne    801043b0 <wakeup+0x20>
801043c2:	3b 58 20             	cmp    0x20(%eax),%ebx
801043c5:	75 e9                	jne    801043b0 <wakeup+0x20>
      p->state = RUNNABLE;
801043c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ce:	05 24 01 00 00       	add    $0x124,%eax
801043d3:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
801043d8:	72 e2                	jb     801043bc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801043da:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
801043e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e4:	c9                   	leave  
  release(&ptable.lock);
801043e5:	e9 06 0b 00 00       	jmp    80104ef0 <release>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 10             	sub    $0x10,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043fa:	68 c0 3d 11 80       	push   $0x80113dc0
801043ff:	e8 2c 0a 00 00       	call   80104e30 <acquire>
80104404:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104407:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
8010440c:	eb 0e                	jmp    8010441c <kill+0x2c>
8010440e:	66 90                	xchg   %ax,%ax
80104410:	05 24 01 00 00       	add    $0x124,%eax
80104415:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
8010441a:	73 34                	jae    80104450 <kill+0x60>
    if(p->pid == pid){
8010441c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010441f:	75 ef                	jne    80104410 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104421:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104425:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010442c:	75 07                	jne    80104435 <kill+0x45>
        p->state = RUNNABLE;
8010442e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104435:	83 ec 0c             	sub    $0xc,%esp
80104438:	68 c0 3d 11 80       	push   $0x80113dc0
8010443d:	e8 ae 0a 00 00       	call   80104ef0 <release>
      return 0;
80104442:	83 c4 10             	add    $0x10,%esp
80104445:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010444a:	c9                   	leave  
8010444b:	c3                   	ret    
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 c0 3d 11 80       	push   $0x80113dc0
80104458:	e8 93 0a 00 00       	call   80104ef0 <release>
  return -1;
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104468:	c9                   	leave  
80104469:	c3                   	ret    
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104479:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
8010447e:	83 ec 3c             	sub    $0x3c,%esp
80104481:	eb 27                	jmp    801044aa <procdump+0x3a>
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	68 93 89 10 80       	push   $0x80108993
80104490:	e8 cb c1 ff ff       	call   80100660 <cprintf>
80104495:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104498:	81 c3 24 01 00 00    	add    $0x124,%ebx
8010449e:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
801044a4:	0f 83 86 00 00 00    	jae    80104530 <procdump+0xc0>
    if(p->state == UNUSED)
801044aa:	8b 43 0c             	mov    0xc(%ebx),%eax
801044ad:	85 c0                	test   %eax,%eax
801044af:	74 e7                	je     80104498 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044b1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801044b4:	ba a0 83 10 80       	mov    $0x801083a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044b9:	77 11                	ja     801044cc <procdump+0x5c>
801044bb:	8b 14 85 68 86 10 80 	mov    -0x7fef7998(,%eax,4),%edx
      state = "???";
801044c2:	b8 a0 83 10 80       	mov    $0x801083a0,%eax
801044c7:	85 d2                	test   %edx,%edx
801044c9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044cc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044cf:	50                   	push   %eax
801044d0:	52                   	push   %edx
801044d1:	ff 73 10             	pushl  0x10(%ebx)
801044d4:	68 a4 83 10 80       	push   $0x801083a4
801044d9:	e8 82 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044de:	83 c4 10             	add    $0x10,%esp
801044e1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044e5:	75 a1                	jne    80104488 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044e7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044ea:	83 ec 08             	sub    $0x8,%esp
801044ed:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044f0:	50                   	push   %eax
801044f1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044f4:	8b 40 0c             	mov    0xc(%eax),%eax
801044f7:	83 c0 08             	add    $0x8,%eax
801044fa:	50                   	push   %eax
801044fb:	e8 10 08 00 00       	call   80104d10 <getcallerpcs>
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	90                   	nop
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104508:	8b 17                	mov    (%edi),%edx
8010450a:	85 d2                	test   %edx,%edx
8010450c:	0f 84 76 ff ff ff    	je     80104488 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104512:	83 ec 08             	sub    $0x8,%esp
80104515:	83 c7 04             	add    $0x4,%edi
80104518:	52                   	push   %edx
80104519:	68 e1 7d 10 80       	push   $0x80107de1
8010451e:	e8 3d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104523:	83 c4 10             	add    $0x10,%esp
80104526:	39 fe                	cmp    %edi,%esi
80104528:	75 de                	jne    80104508 <procdump+0x98>
8010452a:	e9 59 ff ff ff       	jmp    80104488 <procdump+0x18>
8010452f:	90                   	nop
  }
}
80104530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104533:	5b                   	pop    %ebx
80104534:	5e                   	pop    %esi
80104535:	5f                   	pop    %edi
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	90                   	nop
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104540 <print_name>:

void print_name(int num)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	8b 45 08             	mov    0x8(%ebp),%eax
  switch(num)
80104546:	83 f8 18             	cmp    $0x18,%eax
80104549:	0f 87 91 01 00 00    	ja     801046e0 <print_name+0x1a0>
8010454f:	ff 24 85 ec 85 10 80 	jmp    *-0x7fef7a14(,%eax,4)
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      break;
    case 23:
      cprintf("Reverse_number");
      break;
    case 24:
      cprintf("Get_children");
80104560:	c7 45 08 40 84 10 80 	movl   $0x80108440,0x8(%ebp)
      break;
  }

}
80104567:	5d                   	pop    %ebp
      cprintf("Get_children");
80104568:	e9 f3 c0 ff ff       	jmp    80100660 <cprintf>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Reverse_number");
80104570:	c7 45 08 31 84 10 80 	movl   $0x80108431,0x8(%ebp)
}
80104577:	5d                   	pop    %ebp
      cprintf("Reverse_number");
80104578:	e9 e3 c0 ff ff       	jmp    80100660 <cprintf>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Trace_syscalls");
80104580:	c7 45 08 22 84 10 80 	movl   $0x80108422,0x8(%ebp)
}
80104587:	5d                   	pop    %ebp
      cprintf("Trace_syscalls");
80104588:	e9 d3 c0 ff ff       	jmp    80100660 <cprintf>
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Close");
80104590:	c7 45 08 1c 84 10 80 	movl   $0x8010841c,0x8(%ebp)
}
80104597:	5d                   	pop    %ebp
      cprintf("Close");
80104598:	e9 c3 c0 ff ff       	jmp    80100660 <cprintf>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mkdir");
801045a0:	c7 45 08 16 84 10 80 	movl   $0x80108416,0x8(%ebp)
}
801045a7:	5d                   	pop    %ebp
      cprintf("Mkdir");
801045a8:	e9 b3 c0 ff ff       	jmp    80100660 <cprintf>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Link");
801045b0:	c7 45 08 11 84 10 80 	movl   $0x80108411,0x8(%ebp)
}
801045b7:	5d                   	pop    %ebp
      cprintf("Link");
801045b8:	e9 a3 c0 ff ff       	jmp    80100660 <cprintf>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Unlink");
801045c0:	c7 45 08 0a 84 10 80 	movl   $0x8010840a,0x8(%ebp)
}
801045c7:	5d                   	pop    %ebp
      cprintf("Unlink");
801045c8:	e9 93 c0 ff ff       	jmp    80100660 <cprintf>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mknod");
801045d0:	c7 45 08 04 84 10 80 	movl   $0x80108404,0x8(%ebp)
}
801045d7:	5d                   	pop    %ebp
      cprintf("Mknod");
801045d8:	e9 83 c0 ff ff       	jmp    80100660 <cprintf>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Write");
801045e0:	c7 45 08 fe 83 10 80 	movl   $0x801083fe,0x8(%ebp)
}
801045e7:	5d                   	pop    %ebp
      cprintf("Write");
801045e8:	e9 73 c0 ff ff       	jmp    80100660 <cprintf>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Open");
801045f0:	c7 45 08 f9 83 10 80 	movl   $0x801083f9,0x8(%ebp)
}
801045f7:	5d                   	pop    %ebp
      cprintf("Open");
801045f8:	e9 63 c0 ff ff       	jmp    80100660 <cprintf>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Uptime");
80104600:	c7 45 08 f2 83 10 80 	movl   $0x801083f2,0x8(%ebp)
}
80104607:	5d                   	pop    %ebp
      cprintf("Uptime");
80104608:	e9 53 c0 ff ff       	jmp    80100660 <cprintf>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sleep");
80104610:	c7 45 08 ec 83 10 80 	movl   $0x801083ec,0x8(%ebp)
}
80104617:	5d                   	pop    %ebp
      cprintf("Sleep");
80104618:	e9 43 c0 ff ff       	jmp    80100660 <cprintf>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sbrk");
80104620:	c7 45 08 e7 83 10 80 	movl   $0x801083e7,0x8(%ebp)
}
80104627:	5d                   	pop    %ebp
      cprintf("Sbrk");
80104628:	e9 33 c0 ff ff       	jmp    80100660 <cprintf>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Getpid");
80104630:	c7 45 08 e0 83 10 80 	movl   $0x801083e0,0x8(%ebp)
}
80104637:	5d                   	pop    %ebp
      cprintf("Getpid");
80104638:	e9 23 c0 ff ff       	jmp    80100660 <cprintf>
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Dup");
80104640:	c7 45 08 dc 83 10 80 	movl   $0x801083dc,0x8(%ebp)
}
80104647:	5d                   	pop    %ebp
      cprintf("Dup");
80104648:	e9 13 c0 ff ff       	jmp    80100660 <cprintf>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Chdir");
80104650:	c7 45 08 d6 83 10 80 	movl   $0x801083d6,0x8(%ebp)
}
80104657:	5d                   	pop    %ebp
      cprintf("Chdir");
80104658:	e9 03 c0 ff ff       	jmp    80100660 <cprintf>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fstat");
80104660:	c7 45 08 d0 83 10 80 	movl   $0x801083d0,0x8(%ebp)
}
80104667:	5d                   	pop    %ebp
      cprintf("Fstat");
80104668:	e9 f3 bf ff ff       	jmp    80100660 <cprintf>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exec");
80104670:	c7 45 08 cb 83 10 80 	movl   $0x801083cb,0x8(%ebp)
}
80104677:	5d                   	pop    %ebp
      cprintf("Exec");
80104678:	e9 e3 bf ff ff       	jmp    80100660 <cprintf>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Kill");
80104680:	c7 45 08 c6 83 10 80 	movl   $0x801083c6,0x8(%ebp)
}
80104687:	5d                   	pop    %ebp
      cprintf("Kill");
80104688:	e9 d3 bf ff ff       	jmp    80100660 <cprintf>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Read");
80104690:	c7 45 08 c1 83 10 80 	movl   $0x801083c1,0x8(%ebp)
}
80104697:	5d                   	pop    %ebp
      cprintf("Read");
80104698:	e9 c3 bf ff ff       	jmp    80100660 <cprintf>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Pipe");
801046a0:	c7 45 08 bc 83 10 80 	movl   $0x801083bc,0x8(%ebp)
}
801046a7:	5d                   	pop    %ebp
      cprintf("Pipe");
801046a8:	e9 b3 bf ff ff       	jmp    80100660 <cprintf>
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Wait");
801046b0:	c7 45 08 b7 83 10 80 	movl   $0x801083b7,0x8(%ebp)
}
801046b7:	5d                   	pop    %ebp
      cprintf("Wait");
801046b8:	e9 a3 bf ff ff       	jmp    80100660 <cprintf>
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exit");
801046c0:	c7 45 08 b2 83 10 80 	movl   $0x801083b2,0x8(%ebp)
}
801046c7:	5d                   	pop    %ebp
      cprintf("Exit");
801046c8:	e9 93 bf ff ff       	jmp    80100660 <cprintf>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fork");
801046d0:	c7 45 08 ad 83 10 80 	movl   $0x801083ad,0x8(%ebp)
}
801046d7:	5d                   	pop    %ebp
      cprintf("Fork");
801046d8:	e9 83 bf ff ff       	jmp    80100660 <cprintf>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
}
801046e0:	5d                   	pop    %ebp
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <allone>:
void allone(void){
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046f4:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
void allone(void){
801046f9:	83 ec 04             	sub    $0x4,%esp
801046fc:	eb 1a                	jmp    80104718 <allone+0x28>
801046fe:	66 90                	xchg   %ax,%ax
  {

    if(strlen(p->name) == 0)
      break;
    p->print_state = 1;
80104700:	c7 83 f0 00 00 00 01 	movl   $0x1,0xf0(%ebx)
80104707:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010470a:	81 c3 24 01 00 00    	add    $0x124,%ebx
80104710:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
80104716:	73 13                	jae    8010472b <allone+0x3b>
    if(strlen(p->name) == 0)
80104718:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010471b:	83 ec 0c             	sub    $0xc,%esp
8010471e:	50                   	push   %eax
8010471f:	e8 3c 0a 00 00       	call   80105160 <strlen>
80104724:	83 c4 10             	add    $0x10,%esp
80104727:	85 c0                	test   %eax,%eax
80104729:	75 d5                	jne    80104700 <allone+0x10>
    
  }
  

}
8010472b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010472e:	c9                   	leave  
8010472f:	c3                   	ret    

80104730 <all_zero>:
void all_zero(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
  struct proc *p;
  int i;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104734:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
80104739:	83 ec 04             	sub    $0x4,%esp
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(strlen(p->name) == 0)
80104740:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	50                   	push   %eax
80104747:	e8 14 0a 00 00       	call   80105160 <strlen>
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	85 c0                	test   %eax,%eax
80104751:	74 38                	je     8010478b <all_zero+0x5b>
80104753:	8d 43 7c             	lea    0x7c(%ebx),%eax
80104756:	8d 93 f0 00 00 00    	lea    0xf0(%ebx),%edx
      break;
    p->print_state = 0;
8010475c:	c7 83 f0 00 00 00 00 	movl   $0x0,0xf0(%ebx)
80104763:	00 00 00 
80104766:	8d 76 00             	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (i =0; i < SYSNUM; i++){
        
       p->call_nums[i] = 0;
80104770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104776:	83 c0 04             	add    $0x4,%eax
    for (i =0; i < SYSNUM; i++){
80104779:	39 d0                	cmp    %edx,%eax
8010477b:	75 f3                	jne    80104770 <all_zero+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477d:	81 c3 24 01 00 00    	add    $0x124,%ebx
80104783:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
80104789:	72 b5                	jb     80104740 <all_zero+0x10>
    }
  }

}
8010478b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010478e:	c9                   	leave  
8010478f:	c3                   	ret    

80104790 <trace_syscalls>:

int trace_syscalls(int state)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 45 08             	mov    0x8(%ebp),%eax
  
  struct proc *p;
  int i;
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
80104798:	83 f8 01             	cmp    $0x1,%eax
8010479b:	74 2a                	je     801047c7 <trace_syscalls+0x37>
8010479d:	83 f8 02             	cmp    $0x2,%eax
801047a0:	74 16                	je     801047b8 <trace_syscalls+0x28>

    }
    return 0;
  }

  if(state == 0)
801047a2:	85 c0                	test   %eax,%eax
801047a4:	0f 85 99 00 00 00    	jne    80104843 <trace_syscalls+0xb3>
  {
    all_zero();
801047aa:	e8 81 ff ff ff       	call   80104730 <all_zero>
    return 0;
801047af:	31 c0                	xor    %eax,%eax
  }
  return -1;
 
}
801047b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b4:	5b                   	pop    %ebx
801047b5:	5e                   	pop    %esi
801047b6:	5d                   	pop    %ebp
801047b7:	c3                   	ret    
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
801047b8:	8b 0d e4 3e 11 80    	mov    0x80113ee4,%ecx
  return -1;
801047be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
801047c3:	85 c9                	test   %ecx,%ecx
801047c5:	74 ea                	je     801047b1 <trace_syscalls+0x21>
801047c7:	be f4 3d 11 80       	mov    $0x80113df4,%esi
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d0:	8d 5e 6c             	lea    0x6c(%esi),%ebx
      if(strlen(p->name) == 0)
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	53                   	push   %ebx
801047d7:	e8 84 09 00 00       	call   80105160 <strlen>
801047dc:	83 c4 10             	add    $0x10,%esp
801047df:	85 c0                	test   %eax,%eax
801047e1:	74 cc                	je     801047af <trace_syscalls+0x1f>
      cprintf("%s:\n",p->name);
801047e3:	83 ec 08             	sub    $0x8,%esp
      p->print_state = 1;
801047e6:	c7 86 f0 00 00 00 01 	movl   $0x1,0xf0(%esi)
801047ed:	00 00 00 
      cprintf("%s:\n",p->name);
801047f0:	53                   	push   %ebx
801047f1:	68 4d 84 10 80       	push   $0x8010844d
      for (i =0; i < SYSNUM; i++)
801047f6:	31 db                	xor    %ebx,%ebx
      cprintf("%s:\n",p->name);
801047f8:	e8 63 be ff ff       	call   80100660 <cprintf>
801047fd:	83 c4 10             	add    $0x10,%esp
        cprintf("   ");
80104800:	83 ec 0c             	sub    $0xc,%esp
        print_name(i + 1);
80104803:	83 c3 01             	add    $0x1,%ebx
        cprintf("   ");
80104806:	68 a9 84 10 80       	push   $0x801084a9
8010480b:	e8 50 be ff ff       	call   80100660 <cprintf>
        print_name(i + 1);
80104810:	89 1c 24             	mov    %ebx,(%esp)
80104813:	e8 28 fd ff ff       	call   80104540 <print_name>
        cprintf(": %d\n", p->call_nums[i]);
80104818:	58                   	pop    %eax
80104819:	5a                   	pop    %edx
8010481a:	ff 74 9e 78          	pushl  0x78(%esi,%ebx,4)
8010481e:	68 52 84 10 80       	push   $0x80108452
80104823:	e8 38 be ff ff       	call   80100660 <cprintf>
      for (i =0; i < SYSNUM; i++)
80104828:	83 c4 10             	add    $0x10,%esp
8010482b:	83 fb 1d             	cmp    $0x1d,%ebx
8010482e:	75 d0                	jne    80104800 <trace_syscalls+0x70>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104830:	81 c6 24 01 00 00    	add    $0x124,%esi
80104836:	81 fe f4 86 11 80    	cmp    $0x801186f4,%esi
8010483c:	72 92                	jb     801047d0 <trace_syscalls+0x40>
8010483e:	e9 6c ff ff ff       	jmp    801047af <trace_syscalls+0x1f>
  return -1;
80104843:	83 c8 ff             	or     $0xffffffff,%eax
80104846:	e9 66 ff ff ff       	jmp    801047b1 <trace_syscalls+0x21>
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <reverse_number>:

int reverse_number(int n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	81 ec 2c 03 00 00    	sub    $0x32c,%esp
8010485c:	8b 75 08             	mov    0x8(%ebp),%esi

  int digit = 0;
  int temp = n;

  while (temp)
8010485f:	85 f6                	test   %esi,%esi
80104861:	74 7e                	je     801048e1 <reverse_number+0x91>
80104863:	89 f3                	mov    %esi,%ebx
  int digit = 0;
80104865:	31 ff                	xor    %edi,%edi
  {
    ++digit;
    temp /= 10;
80104867:	b9 67 66 66 66       	mov    $0x66666667,%ecx
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104870:	89 d8                	mov    %ebx,%eax
80104872:	c1 fb 1f             	sar    $0x1f,%ebx
    ++digit;
80104875:	83 c7 01             	add    $0x1,%edi
    temp /= 10;
80104878:	f7 e9                	imul   %ecx
8010487a:	c1 fa 02             	sar    $0x2,%edx
  while (temp)
8010487d:	29 da                	sub    %ebx,%edx
8010487f:	89 d3                	mov    %edx,%ebx
80104881:	75 ed                	jne    80104870 <reverse_number+0x20>
80104883:	89 fa                	mov    %edi,%edx
  }

  int array[200] = {0};
80104885:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
8010488b:	89 d8                	mov    %ebx,%eax
8010488d:	b9 c8 00 00 00       	mov    $0xc8,%ecx
80104892:	f3 ab                	rep stos %eax,%es:(%edi)
80104894:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
8010489a:	8d 0c 97             	lea    (%edi,%edx,4),%ecx
8010489d:	89 fb                	mov    %edi,%ebx
8010489f:	90                   	nop
  
  for (int i = 0; i < digit; i++) 
    {
      array[i] = n % 10;
801048a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
801048a5:	83 c3 04             	add    $0x4,%ebx
801048a8:	f7 ee                	imul   %esi
801048aa:	89 f0                	mov    %esi,%eax
801048ac:	c1 f8 1f             	sar    $0x1f,%eax
801048af:	c1 fa 02             	sar    $0x2,%edx
801048b2:	29 c2                	sub    %eax,%edx
801048b4:	8d 04 92             	lea    (%edx,%edx,4),%eax
801048b7:	01 c0                	add    %eax,%eax
801048b9:	29 c6                	sub    %eax,%esi
801048bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
  for (int i = 0; i < digit; i++) 
801048be:	39 cb                	cmp    %ecx,%ebx
      n /= 10;
801048c0:	89 d6                	mov    %edx,%esi
  for (int i = 0; i < digit; i++) 
801048c2:	75 dc                	jne    801048a0 <reverse_number+0x50>
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  
  for(int j = 0; j < digit; j++)
    cprintf("%d", array[j]);
801048c8:	83 ec 08             	sub    $0x8,%esp
801048cb:	ff 37                	pushl  (%edi)
801048cd:	83 c7 04             	add    $0x4,%edi
801048d0:	68 58 84 10 80       	push   $0x80108458
801048d5:	e8 86 bd ff ff       	call   80100660 <cprintf>
  for(int j = 0; j < digit; j++)
801048da:	83 c4 10             	add    $0x10,%esp
801048dd:	39 df                	cmp    %ebx,%edi
801048df:	75 e7                	jne    801048c8 <reverse_number+0x78>
  cprintf("\n");
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	68 93 89 10 80       	push   $0x80108993
801048e9:	e8 72 bd ff ff       	call   80100660 <cprintf>

  return 0;

}
801048ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f1:	31 c0                	xor    %eax,%eax
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5f                   	pop    %edi
801048f6:	5d                   	pop    %ebp
801048f7:	c3                   	ret    
801048f8:	90                   	nop
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104900 <children>:
int
children(int pid)
{
80104900:	55                   	push   %ebp
  struct proc *p;
  
  int childs[NPROC] = {-1};
80104901:	31 c0                	xor    %eax,%eax
80104903:	b9 3f 00 00 00       	mov    $0x3f,%ecx
{
80104908:	89 e5                	mov    %esp,%ebp
8010490a:	57                   	push   %edi
8010490b:	56                   	push   %esi
  int childs[NPROC] = {-1};
8010490c:	8d bd ec fe ff ff    	lea    -0x114(%ebp),%edi
{
80104912:	53                   	push   %ebx
  int curr_index = 0;
  int index = 0;
80104913:	31 db                	xor    %ebx,%ebx
{
80104915:	81 ec 28 01 00 00    	sub    $0x128,%esp
8010491b:	8b 75 08             	mov    0x8(%ebp),%esi
  int childs[NPROC] = {-1};
8010491e:	f3 ab                	rep stos %eax,%es:(%edi)
  //int parent_pid = pid ; 

  acquire(&ptable.lock);
80104920:	68 c0 3d 11 80       	push   $0x80113dc0
  int childs[NPROC] = {-1};
80104925:	c7 85 e8 fe ff ff ff 	movl   $0xffffffff,-0x118(%ebp)
8010492c:	ff ff ff 
8010492f:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
  acquire(&ptable.lock);
80104935:	e8 f6 04 00 00       	call   80104e30 <acquire>
8010493a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	89 f9                	mov    %edi,%ecx
80104942:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
80104948:	90                   	nop
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(int i = 0 ; i < NPROC ; i++){

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104950:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104955:	8d 76 00             	lea    0x0(%esi),%esi

      //cprintf("proc pid: %d  parent pid: %d \n",  p->pid, p->parent->pid);

        if(p->parent->pid == pid){
80104958:	8b 50 14             	mov    0x14(%eax),%edx
8010495b:	39 72 10             	cmp    %esi,0x10(%edx)
8010495e:	75 0d                	jne    8010496d <children+0x6d>
           childs[index] = p->pid ;
80104960:	8b 50 10             	mov    0x10(%eax),%edx
80104963:	89 94 9d e8 fe ff ff 	mov    %edx,-0x118(%ebp,%ebx,4)
           index++;
8010496a:	83 c3 01             	add    $0x1,%ebx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010496d:	05 24 01 00 00       	add    $0x124,%eax
80104972:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104977:	72 df                	jb     80104958 <children+0x58>
       //  cprintf(" parent pid ,%d", pid , " child pid: %d \n",  p->pid);
        }
    }
     if(childs[curr_index] == -1)
80104979:	8b 31                	mov    (%ecx),%esi
8010497b:	83 fe ff             	cmp    $0xffffffff,%esi
8010497e:	74 0b                	je     8010498b <children+0x8b>
80104980:	83 c1 04             	add    $0x4,%ecx
  for(int i = 0 ; i < NPROC ; i++){
80104983:	3b 8d e4 fe ff ff    	cmp    -0x11c(%ebp),%ecx
80104989:	75 c5                	jne    80104950 <children+0x50>
     else{
       pid = childs[curr_index];
       curr_index++;
      } 
  }
  release(&ptable.lock);
8010498b:	83 ec 0c             	sub    $0xc,%esp
8010498e:	68 c0 3d 11 80       	push   $0x80113dc0
80104993:	e8 58 05 00 00       	call   80104ef0 <release>
  
  int pid_list = 0;
  int cpy ; 

  for(int i = 0 ; i < index ;i++){
80104998:	83 c4 10             	add    $0x10,%esp
8010499b:	85 db                	test   %ebx,%ebx
8010499d:	74 3e                	je     801049dd <children+0xdd>
8010499f:	8d 04 9f             	lea    (%edi,%ebx,4),%eax

  cpy = childs[i];
  while(cpy > 0){
        pid_list *= 10;
        cpy /= 10 ;
801049a2:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
  int pid_list = 0;
801049a7:	31 db                	xor    %ebx,%ebx
801049a9:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  cpy = childs[i];
801049af:	8b 37                	mov    (%edi),%esi
  while(cpy > 0){
801049b1:	85 f6                	test   %esi,%esi
801049b3:	7e 1b                	jle    801049d0 <children+0xd0>
801049b5:	89 f2                	mov    %esi,%edx
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cpy /= 10 ;
801049c0:	89 d0                	mov    %edx,%eax
        pid_list *= 10;
801049c2:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
        cpy /= 10 ;
801049c5:	f7 e1                	mul    %ecx
        pid_list *= 10;
801049c7:	01 db                	add    %ebx,%ebx
        cpy /= 10 ;
801049c9:	c1 ea 03             	shr    $0x3,%edx
  while(cpy > 0){
801049cc:	85 d2                	test   %edx,%edx
801049ce:	75 f0                	jne    801049c0 <children+0xc0>
     }
  pid_list += childs[i];
801049d0:	01 f3                	add    %esi,%ebx
801049d2:	83 c7 04             	add    $0x4,%edi
  for(int i = 0 ; i < index ;i++){
801049d5:	3b bd e4 fe ff ff    	cmp    -0x11c(%ebp),%edi
801049db:	75 d2                	jne    801049af <children+0xaf>
}


  return pid_list;
}
801049dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049e0:	89 d8                	mov    %ebx,%eax
801049e2:	5b                   	pop    %ebx
801049e3:	5e                   	pop    %esi
801049e4:	5f                   	pop    %edi
801049e5:	5d                   	pop    %ebp
801049e6:	c3                   	ret    
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <change_process_queue>:

void change_process_queue(int pid, int dest_queue)
{
801049f0:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
801049f1:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
801049f6:	89 e5                	mov    %esp,%ebp
801049f8:	8b 55 08             	mov    0x8(%ebp),%edx
801049fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049fe:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104a00:	39 50 10             	cmp    %edx,0x10(%eax)
80104a03:	75 06                	jne    80104a0b <change_process_queue+0x1b>
    {
      p->level = dest_queue;
80104a05:	89 88 f4 00 00 00    	mov    %ecx,0xf4(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a0b:	05 24 01 00 00       	add    $0x124,%eax
80104a10:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104a15:	72 e9                	jb     80104a00 <change_process_queue+0x10>
    }
  }
}
80104a17:	5d                   	pop    %ebp
80104a18:	c3                   	ret    
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a20 <quantify_lottery_tickets>:

void quantify_lottery_tickets(int pid, int ticket)
{
80104a20:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a21:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104a26:	89 e5                	mov    %esp,%ebp
80104a28:	8b 55 08             	mov    0x8(%ebp),%edx
80104a2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a2e:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104a30:	39 50 10             	cmp    %edx,0x10(%eax)
80104a33:	75 06                	jne    80104a3b <quantify_lottery_tickets+0x1b>
    {
      p->lottery_ticket = ticket;
80104a35:	89 88 10 01 00 00    	mov    %ecx,0x110(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a3b:	05 24 01 00 00       	add    $0x124,%eax
80104a40:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104a45:	72 e9                	jb     80104a30 <quantify_lottery_tickets+0x10>
    }
  }
}
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <quantify_BJF_parameters_process_level>:

void quantify_BJF_parameters_process_level(int pid, int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104a50:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a51:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104a56:	89 e5                	mov    %esp,%ebp
80104a58:	56                   	push   %esi
80104a59:	53                   	push   %ebx
80104a5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5d:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a60:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a63:	8b 4d 14             	mov    0x14(%ebp),%ecx
80104a66:	8d 76 00             	lea    0x0(%esi),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  {
    if(p->pid == pid)
80104a70:	39 50 10             	cmp    %edx,0x10(%eax)
80104a73:	75 12                	jne    80104a87 <quantify_BJF_parameters_process_level+0x37>
    {
      p->priority_ratio = priority_ratio;
80104a75:	89 b0 fc 00 00 00    	mov    %esi,0xfc(%eax)
      p->arrivt_ratio = arrivt_ratio;
80104a7b:	89 98 04 01 00 00    	mov    %ebx,0x104(%eax)
      p->exect_ratio = exect_ratio;
80104a81:	89 88 0c 01 00 00    	mov    %ecx,0x10c(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a87:	05 24 01 00 00       	add    $0x124,%eax
80104a8c:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104a91:	72 dd                	jb     80104a70 <quantify_BJF_parameters_process_level+0x20>
    }
  }
}
80104a93:	5b                   	pop    %ebx
80104a94:	5e                   	pop    %esi
80104a95:	5d                   	pop    %ebp
80104a96:	c3                   	ret    
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <quantify_BJF_parameters_kernel_level>:

void quantify_BJF_parameters_kernel_level(int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104aa0:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104aa1:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104aa6:	89 e5                	mov    %esp,%ebp
80104aa8:	53                   	push   %ebx
80104aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104aac:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104aaf:	8b 55 10             	mov    0x10(%ebp),%edx
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    p->priority_ratio = priority_ratio;
80104ab8:	89 98 fc 00 00 00    	mov    %ebx,0xfc(%eax)
    p->arrivt_ratio = arrivt_ratio;
80104abe:	89 88 04 01 00 00    	mov    %ecx,0x104(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104ac4:	05 24 01 00 00       	add    $0x124,%eax
    p->exect_ratio = exect_ratio;
80104ac9:	89 50 e8             	mov    %edx,-0x18(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104acc:	3d f4 86 11 80       	cmp    $0x801186f4,%eax
80104ad1:	72 e5                	jb     80104ab8 <quantify_BJF_parameters_kernel_level+0x18>
  }
}
80104ad3:	5b                   	pop    %ebx
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
80104ad6:	8d 76 00             	lea    0x0(%esi),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <state_to_string>:

const char* state_to_string(enum procstate const state)
{
80104ae0:	55                   	push   %ebp
80104ae1:	31 c0                	xor    %eax,%eax
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ae8:	83 fa 05             	cmp    $0x5,%edx
80104aeb:	77 07                	ja     80104af4 <state_to_string+0x14>
80104aed:	8b 04 95 50 86 10 80 	mov    -0x7fef79b0(,%edx,4),%eax
    case ZOMBIE:  
      return "ZOMBIE";
      break;
  }
  return 0;
}
80104af4:	5d                   	pop    %ebp
80104af5:	c3                   	ret    
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <print_information>:

void print_information()
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
  struct proc* p;
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
  cprintf("...............................................................................................................\n");
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104b06:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
80104b0b:	83 ec 28             	sub    $0x28,%esp
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
80104b0e:	68 dc 84 10 80       	push   $0x801084dc
80104b13:	e8 48 bb ff ff       	call   80100660 <cprintf>
  cprintf("...............................................................................................................\n");
80104b18:	c7 04 24 44 85 10 80 	movl   $0x80108544,(%esp)
80104b1f:	e8 3c bb ff ff       	call   80100660 <cprintf>
80104b24:	83 c4 10             	add    $0x10,%esp
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  {
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104b30:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
80104b36:	8b 53 0c             	mov    0xc(%ebx),%edx
80104b39:	8b bb 1c 01 00 00    	mov    0x11c(%ebx),%edi
80104b3f:	8b b3 20 01 00 00    	mov    0x120(%ebx),%esi
80104b45:	8b 8b f4 00 00 00    	mov    0xf4(%ebx),%ecx
80104b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104b4e:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
80104b54:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104b57:	8b 83 fc 00 00 00    	mov    0xfc(%ebx),%eax
80104b5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104b60:	8b 83 10 01 00 00    	mov    0x110(%ebx),%eax
80104b66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104b69:	31 c0                	xor    %eax,%eax
80104b6b:	83 fa 05             	cmp    $0x5,%edx
80104b6e:	77 07                	ja     80104b77 <print_information+0x77>
80104b70:	8b 04 95 50 86 10 80 	mov    -0x7fef79b0(,%edx,4),%eax
80104b77:	83 ec 04             	sub    $0x4,%esp
80104b7a:	57                   	push   %edi
80104b7b:	56                   	push   %esi
80104b7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80104b7f:	ff 75 e0             	pushl  -0x20(%ebp)
80104b82:	ff 75 dc             	pushl  -0x24(%ebp)
80104b85:	ff 75 d8             	pushl  -0x28(%ebp)
80104b88:	51                   	push   %ecx
80104b89:	50                   	push   %eax
80104b8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b8d:	ff 73 10             	pushl  0x10(%ebx)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104b90:	81 c3 24 01 00 00    	add    $0x124,%ebx
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104b96:	50                   	push   %eax
80104b97:	68 b8 85 10 80       	push   $0x801085b8
80104b9c:	e8 bf ba ff ff       	call   80100660 <cprintf>
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104ba1:	83 c4 30             	add    $0x30,%esp
80104ba4:	81 fb f4 86 11 80    	cmp    $0x801186f4,%ebx
80104baa:	72 84                	jb     80104b30 <print_information+0x30>
    p->name, p->pid, state_to_string(p->state), p->level, p->lottery_ticket, p->priority_ratio, p->arrivt_ratio, p->exect_ratio, p->rank, p->last_cycle);
  }
80104bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5f                   	pop    %edi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
80104bb4:	66 90                	xchg   %ax,%ax
80104bb6:	66 90                	xchg   %ax,%ax
80104bb8:	66 90                	xchg   %ax,%ax
80104bba:	66 90                	xchg   %ax,%ax
80104bbc:	66 90                	xchg   %ax,%ax
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bca:	68 88 86 10 80       	push   $0x80108688
80104bcf:	8d 43 04             	lea    0x4(%ebx),%eax
80104bd2:	50                   	push   %eax
80104bd3:	e8 18 01 00 00       	call   80104cf0 <initlock>
  lk->name = name;
80104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104bdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104be1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104be4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104beb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf1:	c9                   	leave  
80104bf2:	c3                   	ret    
80104bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c08:	83 ec 0c             	sub    $0xc,%esp
80104c0b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c0e:	56                   	push   %esi
80104c0f:	e8 1c 02 00 00       	call   80104e30 <acquire>
  while (lk->locked) {
80104c14:	8b 13                	mov    (%ebx),%edx
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	85 d2                	test   %edx,%edx
80104c1b:	74 16                	je     80104c33 <acquiresleep+0x33>
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c20:	83 ec 08             	sub    $0x8,%esp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	e8 a6 f5 ff ff       	call   801041d0 <sleep>
  while (lk->locked) {
80104c2a:	8b 03                	mov    (%ebx),%eax
80104c2c:	83 c4 10             	add    $0x10,%esp
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	75 ed                	jne    80104c20 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c33:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c39:	e8 72 ed ff ff       	call   801039b0 <myproc>
80104c3e:	8b 40 10             	mov    0x10(%eax),%eax
80104c41:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c44:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c4a:	5b                   	pop    %ebx
80104c4b:	5e                   	pop    %esi
80104c4c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c4d:	e9 9e 02 00 00       	jmp    80104ef0 <release>
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c6e:	56                   	push   %esi
80104c6f:	e8 bc 01 00 00       	call   80104e30 <acquire>
  lk->locked = 0;
80104c74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c7a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c81:	89 1c 24             	mov    %ebx,(%esp)
80104c84:	e8 07 f7 ff ff       	call   80104390 <wakeup>
  release(&lk->lk);
80104c89:	89 75 08             	mov    %esi,0x8(%ebp)
80104c8c:	83 c4 10             	add    $0x10,%esp
}
80104c8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c92:	5b                   	pop    %ebx
80104c93:	5e                   	pop    %esi
80104c94:	5d                   	pop    %ebp
  release(&lk->lk);
80104c95:	e9 56 02 00 00       	jmp    80104ef0 <release>
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
80104ca5:	53                   	push   %ebx
80104ca6:	31 ff                	xor    %edi,%edi
80104ca8:	83 ec 18             	sub    $0x18,%esp
80104cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104cae:	8d 73 04             	lea    0x4(%ebx),%esi
80104cb1:	56                   	push   %esi
80104cb2:	e8 79 01 00 00       	call   80104e30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104cb7:	8b 03                	mov    (%ebx),%eax
80104cb9:	83 c4 10             	add    $0x10,%esp
80104cbc:	85 c0                	test   %eax,%eax
80104cbe:	74 13                	je     80104cd3 <holdingsleep+0x33>
80104cc0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cc3:	e8 e8 ec ff ff       	call   801039b0 <myproc>
80104cc8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ccb:	0f 94 c0             	sete   %al
80104cce:	0f b6 c0             	movzbl %al,%eax
80104cd1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104cd3:	83 ec 0c             	sub    $0xc,%esp
80104cd6:	56                   	push   %esi
80104cd7:	e8 14 02 00 00       	call   80104ef0 <release>
  return r;
}
80104cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cdf:	89 f8                	mov    %edi,%eax
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5f                   	pop    %edi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    
80104ce6:	66 90                	xchg   %ax,%ax
80104ce8:	66 90                	xchg   %ax,%ax
80104cea:	66 90                	xchg   %ax,%ax
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	90                   	nop
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d10:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d11:	31 d2                	xor    %edx,%edx
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d16:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d1c:	83 e8 08             	sub    $0x8,%eax
80104d1f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d20:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d26:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d2c:	77 1a                	ja     80104d48 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d2e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d31:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d34:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d37:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d39:	83 fa 0a             	cmp    $0xa,%edx
80104d3c:	75 e2                	jne    80104d20 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5d                   	pop    %ebp
80104d40:	c3                   	ret    
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d4b:	83 c1 28             	add    $0x28,%ecx
80104d4e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d56:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d59:	39 c1                	cmp    %eax,%ecx
80104d5b:	75 f3                	jne    80104d50 <getcallerpcs+0x40>
}
80104d5d:	5b                   	pop    %ebx
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    

80104d60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
80104d67:	9c                   	pushf  
80104d68:	5b                   	pop    %ebx
  asm volatile("cli");
80104d69:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d6a:	e8 a1 eb ff ff       	call   80103910 <mycpu>
80104d6f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d75:	85 c0                	test   %eax,%eax
80104d77:	75 11                	jne    80104d8a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104d79:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d7f:	e8 8c eb ff ff       	call   80103910 <mycpu>
80104d84:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104d8a:	e8 81 eb ff ff       	call   80103910 <mycpu>
80104d8f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d96:	83 c4 04             	add    $0x4,%esp
80104d99:	5b                   	pop    %ebx
80104d9a:	5d                   	pop    %ebp
80104d9b:	c3                   	ret    
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <popcli>:

void
popcli(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104da6:	9c                   	pushf  
80104da7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104da8:	f6 c4 02             	test   $0x2,%ah
80104dab:	75 35                	jne    80104de2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104dad:	e8 5e eb ff ff       	call   80103910 <mycpu>
80104db2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104db9:	78 34                	js     80104def <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dbb:	e8 50 eb ff ff       	call   80103910 <mycpu>
80104dc0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dc6:	85 d2                	test   %edx,%edx
80104dc8:	74 06                	je     80104dd0 <popcli+0x30>
    sti();
}
80104dca:	c9                   	leave  
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dd0:	e8 3b eb ff ff       	call   80103910 <mycpu>
80104dd5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	74 eb                	je     80104dca <popcli+0x2a>
  asm volatile("sti");
80104ddf:	fb                   	sti    
}
80104de0:	c9                   	leave  
80104de1:	c3                   	ret    
    panic("popcli - interruptible");
80104de2:	83 ec 0c             	sub    $0xc,%esp
80104de5:	68 93 86 10 80       	push   $0x80108693
80104dea:	e8 a1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	68 aa 86 10 80       	push   $0x801086aa
80104df7:	e8 94 b5 ff ff       	call   80100390 <panic>
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <holding>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 75 08             	mov    0x8(%ebp),%esi
80104e08:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e0a:	e8 51 ff ff ff       	call   80104d60 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e0f:	8b 06                	mov    (%esi),%eax
80104e11:	85 c0                	test   %eax,%eax
80104e13:	74 10                	je     80104e25 <holding+0x25>
80104e15:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e18:	e8 f3 ea ff ff       	call   80103910 <mycpu>
80104e1d:	39 c3                	cmp    %eax,%ebx
80104e1f:	0f 94 c3             	sete   %bl
80104e22:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e25:	e8 76 ff ff ff       	call   80104da0 <popcli>
}
80104e2a:	89 d8                	mov    %ebx,%eax
80104e2c:	5b                   	pop    %ebx
80104e2d:	5e                   	pop    %esi
80104e2e:	5d                   	pop    %ebp
80104e2f:	c3                   	ret    

80104e30 <acquire>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e35:	e8 26 ff ff ff       	call   80104d60 <pushcli>
  if(holding(lk))
80104e3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e3d:	83 ec 0c             	sub    $0xc,%esp
80104e40:	53                   	push   %ebx
80104e41:	e8 ba ff ff ff       	call   80104e00 <holding>
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	0f 85 83 00 00 00    	jne    80104ed4 <acquire+0xa4>
80104e51:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e53:	ba 01 00 00 00       	mov    $0x1,%edx
80104e58:	eb 09                	jmp    80104e63 <acquire+0x33>
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e63:	89 d0                	mov    %edx,%eax
80104e65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e68:	85 c0                	test   %eax,%eax
80104e6a:	75 f4                	jne    80104e60 <acquire+0x30>
  __sync_synchronize();
80104e6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e74:	e8 97 ea ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e79:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104e7c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e7f:	89 e8                	mov    %ebp,%eax
80104e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e88:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104e8e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104e94:	77 1a                	ja     80104eb0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e96:	8b 48 04             	mov    0x4(%eax),%ecx
80104e99:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104e9c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e9f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ea1:	83 fe 0a             	cmp    $0xa,%esi
80104ea4:	75 e2                	jne    80104e88 <acquire+0x58>
}
80104ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea9:	5b                   	pop    %ebx
80104eaa:	5e                   	pop    %esi
80104eab:	5d                   	pop    %ebp
80104eac:	c3                   	ret    
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
80104eb0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104eb3:	83 c2 28             	add    $0x28,%edx
80104eb6:	8d 76 00             	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ec0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ec6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ec9:	39 d0                	cmp    %edx,%eax
80104ecb:	75 f3                	jne    80104ec0 <acquire+0x90>
}
80104ecd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed0:	5b                   	pop    %ebx
80104ed1:	5e                   	pop    %esi
80104ed2:	5d                   	pop    %ebp
80104ed3:	c3                   	ret    
    panic("acquire");
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	68 b1 86 10 80       	push   $0x801086b1
80104edc:	e8 af b4 ff ff       	call   80100390 <panic>
80104ee1:	eb 0d                	jmp    80104ef0 <release>
80104ee3:	90                   	nop
80104ee4:	90                   	nop
80104ee5:	90                   	nop
80104ee6:	90                   	nop
80104ee7:	90                   	nop
80104ee8:	90                   	nop
80104ee9:	90                   	nop
80104eea:	90                   	nop
80104eeb:	90                   	nop
80104eec:	90                   	nop
80104eed:	90                   	nop
80104eee:	90                   	nop
80104eef:	90                   	nop

80104ef0 <release>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 10             	sub    $0x10,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104efa:	53                   	push   %ebx
80104efb:	e8 00 ff ff ff       	call   80104e00 <holding>
80104f00:	83 c4 10             	add    $0x10,%esp
80104f03:	85 c0                	test   %eax,%eax
80104f05:	74 22                	je     80104f29 <release+0x39>
  lk->pcs[0] = 0;
80104f07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f23:	c9                   	leave  
  popcli();
80104f24:	e9 77 fe ff ff       	jmp    80104da0 <popcli>
    panic("release");
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	68 b9 86 10 80       	push   $0x801086b9
80104f31:	e8 5a b4 ff ff       	call   80100390 <panic>
80104f36:	66 90                	xchg   %ax,%ax
80104f38:	66 90                	xchg   %ax,%ax
80104f3a:	66 90                	xchg   %ax,%ax
80104f3c:	66 90                	xchg   %ax,%ax
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	53                   	push   %ebx
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
80104f48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f4b:	f6 c2 03             	test   $0x3,%dl
80104f4e:	75 05                	jne    80104f55 <memset+0x15>
80104f50:	f6 c1 03             	test   $0x3,%cl
80104f53:	74 13                	je     80104f68 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f55:	89 d7                	mov    %edx,%edi
80104f57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5a:	fc                   	cld    
80104f5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f5d:	5b                   	pop    %ebx
80104f5e:	89 d0                	mov    %edx,%eax
80104f60:	5f                   	pop    %edi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret    
80104f63:	90                   	nop
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f6c:	c1 e9 02             	shr    $0x2,%ecx
80104f6f:	89 f8                	mov    %edi,%eax
80104f71:	89 fb                	mov    %edi,%ebx
80104f73:	c1 e0 18             	shl    $0x18,%eax
80104f76:	c1 e3 10             	shl    $0x10,%ebx
80104f79:	09 d8                	or     %ebx,%eax
80104f7b:	09 f8                	or     %edi,%eax
80104f7d:	c1 e7 08             	shl    $0x8,%edi
80104f80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f82:	89 d7                	mov    %edx,%edi
80104f84:	fc                   	cld    
80104f85:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f87:	5b                   	pop    %ebx
80104f88:	89 d0                	mov    %edx,%eax
80104f8a:	5f                   	pop    %edi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
80104f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f99:	8b 75 08             	mov    0x8(%ebp),%esi
80104f9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f9f:	85 db                	test   %ebx,%ebx
80104fa1:	74 29                	je     80104fcc <memcmp+0x3c>
    if(*s1 != *s2)
80104fa3:	0f b6 16             	movzbl (%esi),%edx
80104fa6:	0f b6 0f             	movzbl (%edi),%ecx
80104fa9:	38 d1                	cmp    %dl,%cl
80104fab:	75 2b                	jne    80104fd8 <memcmp+0x48>
80104fad:	b8 01 00 00 00       	mov    $0x1,%eax
80104fb2:	eb 14                	jmp    80104fc8 <memcmp+0x38>
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104fbc:	83 c0 01             	add    $0x1,%eax
80104fbf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104fc4:	38 ca                	cmp    %cl,%dl
80104fc6:	75 10                	jne    80104fd8 <memcmp+0x48>
  while(n-- > 0){
80104fc8:	39 d8                	cmp    %ebx,%eax
80104fca:	75 ec                	jne    80104fb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104fcc:	5b                   	pop    %ebx
  return 0;
80104fcd:	31 c0                	xor    %eax,%eax
}
80104fcf:	5e                   	pop    %esi
80104fd0:	5f                   	pop    %edi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret    
80104fd3:	90                   	nop
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104fd8:	0f b6 c2             	movzbl %dl,%eax
}
80104fdb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104fdc:	29 c8                	sub    %ecx,%eax
}
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret    
80104fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ffb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ffe:	39 c3                	cmp    %eax,%ebx
80105000:	73 26                	jae    80105028 <memmove+0x38>
80105002:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105005:	39 c8                	cmp    %ecx,%eax
80105007:	73 1f                	jae    80105028 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105009:	85 f6                	test   %esi,%esi
8010500b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010500e:	74 0f                	je     8010501f <memmove+0x2f>
      *--d = *--s;
80105010:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105014:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105017:	83 ea 01             	sub    $0x1,%edx
8010501a:	83 fa ff             	cmp    $0xffffffff,%edx
8010501d:	75 f1                	jne    80105010 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	90                   	nop
80105024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105028:	31 d2                	xor    %edx,%edx
8010502a:	85 f6                	test   %esi,%esi
8010502c:	74 f1                	je     8010501f <memmove+0x2f>
8010502e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105030:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105034:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105037:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010503a:	39 d6                	cmp    %edx,%esi
8010503c:	75 f2                	jne    80105030 <memmove+0x40>
}
8010503e:	5b                   	pop    %ebx
8010503f:	5e                   	pop    %esi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105053:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105054:	eb 9a                	jmp    80104ff0 <memmove>
80105056:	8d 76 00             	lea    0x0(%esi),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	8b 7d 10             	mov    0x10(%ebp),%edi
80105068:	53                   	push   %ebx
80105069:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010506c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010506f:	85 ff                	test   %edi,%edi
80105071:	74 2f                	je     801050a2 <strncmp+0x42>
80105073:	0f b6 01             	movzbl (%ecx),%eax
80105076:	0f b6 1e             	movzbl (%esi),%ebx
80105079:	84 c0                	test   %al,%al
8010507b:	74 37                	je     801050b4 <strncmp+0x54>
8010507d:	38 c3                	cmp    %al,%bl
8010507f:	75 33                	jne    801050b4 <strncmp+0x54>
80105081:	01 f7                	add    %esi,%edi
80105083:	eb 13                	jmp    80105098 <strncmp+0x38>
80105085:	8d 76 00             	lea    0x0(%esi),%esi
80105088:	0f b6 01             	movzbl (%ecx),%eax
8010508b:	84 c0                	test   %al,%al
8010508d:	74 21                	je     801050b0 <strncmp+0x50>
8010508f:	0f b6 1a             	movzbl (%edx),%ebx
80105092:	89 d6                	mov    %edx,%esi
80105094:	38 d8                	cmp    %bl,%al
80105096:	75 1c                	jne    801050b4 <strncmp+0x54>
    n--, p++, q++;
80105098:	8d 56 01             	lea    0x1(%esi),%edx
8010509b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010509e:	39 fa                	cmp    %edi,%edx
801050a0:	75 e6                	jne    80105088 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801050a2:	5b                   	pop    %ebx
    return 0;
801050a3:	31 c0                	xor    %eax,%eax
}
801050a5:	5e                   	pop    %esi
801050a6:	5f                   	pop    %edi
801050a7:	5d                   	pop    %ebp
801050a8:	c3                   	ret    
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801050b4:	29 d8                	sub    %ebx,%eax
}
801050b6:	5b                   	pop    %ebx
801050b7:	5e                   	pop    %esi
801050b8:	5f                   	pop    %edi
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    
801050bb:	90                   	nop
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	8b 45 08             	mov    0x8(%ebp),%eax
801050c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050ce:	89 c2                	mov    %eax,%edx
801050d0:	eb 19                	jmp    801050eb <strncpy+0x2b>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801050df:	83 c2 01             	add    $0x1,%edx
801050e2:	84 c9                	test   %cl,%cl
801050e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050e7:	74 09                	je     801050f2 <strncpy+0x32>
801050e9:	89 f1                	mov    %esi,%ecx
801050eb:	85 c9                	test   %ecx,%ecx
801050ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050f0:	7f e6                	jg     801050d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050f2:	31 c9                	xor    %ecx,%ecx
801050f4:	85 f6                	test   %esi,%esi
801050f6:	7e 17                	jle    8010510f <strncpy+0x4f>
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105100:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105104:	89 f3                	mov    %esi,%ebx
80105106:	83 c1 01             	add    $0x1,%ecx
80105109:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010510b:	85 db                	test   %ebx,%ebx
8010510d:	7f f1                	jg     80105100 <strncpy+0x40>
  return os;
}
8010510f:	5b                   	pop    %ebx
80105110:	5e                   	pop    %esi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105128:	8b 45 08             	mov    0x8(%ebp),%eax
8010512b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010512e:	85 c9                	test   %ecx,%ecx
80105130:	7e 26                	jle    80105158 <safestrcpy+0x38>
80105132:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105136:	89 c1                	mov    %eax,%ecx
80105138:	eb 17                	jmp    80105151 <safestrcpy+0x31>
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105140:	83 c2 01             	add    $0x1,%edx
80105143:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105147:	83 c1 01             	add    $0x1,%ecx
8010514a:	84 db                	test   %bl,%bl
8010514c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010514f:	74 04                	je     80105155 <safestrcpy+0x35>
80105151:	39 f2                	cmp    %esi,%edx
80105153:	75 eb                	jne    80105140 <safestrcpy+0x20>
    ;
  *s = 0;
80105155:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105158:	5b                   	pop    %ebx
80105159:	5e                   	pop    %esi
8010515a:	5d                   	pop    %ebp
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <strlen>:

int
strlen(const char *s)
{
80105160:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105168:	80 3a 00             	cmpb   $0x0,(%edx)
8010516b:	74 0c                	je     80105179 <strlen+0x19>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c0 01             	add    $0x1,%eax
80105173:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105177:	75 f7                	jne    80105170 <strlen+0x10>
    ;
  return n;
}
80105179:	5d                   	pop    %ebp
8010517a:	c3                   	ret    

8010517b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010517b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010517f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105183:	55                   	push   %ebp
  pushl %ebx
80105184:	53                   	push   %ebx
  pushl %esi
80105185:	56                   	push   %esi
  pushl %edi
80105186:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105187:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105189:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010518b:	5f                   	pop    %edi
  popl %esi
8010518c:	5e                   	pop    %esi
  popl %ebx
8010518d:	5b                   	pop    %ebx
  popl %ebp
8010518e:	5d                   	pop    %ebp
  ret
8010518f:	c3                   	ret    

80105190 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 04             	sub    $0x4,%esp
80105197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010519a:	e8 11 e8 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010519f:	8b 00                	mov    (%eax),%eax
801051a1:	39 d8                	cmp    %ebx,%eax
801051a3:	76 1b                	jbe    801051c0 <fetchint+0x30>
801051a5:	8d 53 04             	lea    0x4(%ebx),%edx
801051a8:	39 d0                	cmp    %edx,%eax
801051aa:	72 14                	jb     801051c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801051af:	8b 13                	mov    (%ebx),%edx
801051b1:	89 10                	mov    %edx,(%eax)
  return 0;
801051b3:	31 c0                	xor    %eax,%eax
}
801051b5:	83 c4 04             	add    $0x4,%esp
801051b8:	5b                   	pop    %ebx
801051b9:	5d                   	pop    %ebp
801051ba:	c3                   	ret    
801051bb:	90                   	nop
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb ee                	jmp    801051b5 <fetchint+0x25>
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	53                   	push   %ebx
801051d4:	83 ec 04             	sub    $0x4,%esp
801051d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051da:	e8 d1 e7 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
801051df:	39 18                	cmp    %ebx,(%eax)
801051e1:	76 29                	jbe    8010520c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801051e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051e6:	89 da                	mov    %ebx,%edx
801051e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801051ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801051ec:	39 c3                	cmp    %eax,%ebx
801051ee:	73 1c                	jae    8010520c <fetchstr+0x3c>
    if(*s == 0)
801051f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801051f3:	75 10                	jne    80105205 <fetchstr+0x35>
801051f5:	eb 39                	jmp    80105230 <fetchstr+0x60>
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105200:	80 3a 00             	cmpb   $0x0,(%edx)
80105203:	74 1b                	je     80105220 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105205:	83 c2 01             	add    $0x1,%edx
80105208:	39 d0                	cmp    %edx,%eax
8010520a:	77 f4                	ja     80105200 <fetchstr+0x30>
    return -1;
8010520c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105211:	83 c4 04             	add    $0x4,%esp
80105214:	5b                   	pop    %ebx
80105215:	5d                   	pop    %ebp
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105220:	83 c4 04             	add    $0x4,%esp
80105223:	89 d0                	mov    %edx,%eax
80105225:	29 d8                	sub    %ebx,%eax
80105227:	5b                   	pop    %ebx
80105228:	5d                   	pop    %ebp
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105230:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105232:	eb dd                	jmp    80105211 <fetchstr+0x41>
80105234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010523a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105240 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	56                   	push   %esi
80105244:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105245:	e8 66 e7 ff ff       	call   801039b0 <myproc>
8010524a:	8b 40 18             	mov    0x18(%eax),%eax
8010524d:	8b 55 08             	mov    0x8(%ebp),%edx
80105250:	8b 40 44             	mov    0x44(%eax),%eax
80105253:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105256:	e8 55 e7 ff ff       	call   801039b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010525b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010525d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105260:	39 c6                	cmp    %eax,%esi
80105262:	73 1c                	jae    80105280 <argint+0x40>
80105264:	8d 53 08             	lea    0x8(%ebx),%edx
80105267:	39 d0                	cmp    %edx,%eax
80105269:	72 15                	jb     80105280 <argint+0x40>
  *ip = *(int*)(addr);
8010526b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526e:	8b 53 04             	mov    0x4(%ebx),%edx
80105271:	89 10                	mov    %edx,(%eax)
  return 0;
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	5b                   	pop    %ebx
80105276:	5e                   	pop    %esi
80105277:	5d                   	pop    %ebp
80105278:	c3                   	ret    
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105285:	eb ee                	jmp    80105275 <argint+0x35>
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
80105295:	83 ec 10             	sub    $0x10,%esp
80105298:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010529b:	e8 10 e7 ff ff       	call   801039b0 <myproc>
801052a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801052a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a5:	83 ec 08             	sub    $0x8,%esp
801052a8:	50                   	push   %eax
801052a9:	ff 75 08             	pushl  0x8(%ebp)
801052ac:	e8 8f ff ff ff       	call   80105240 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	85 c0                	test   %eax,%eax
801052b6:	78 28                	js     801052e0 <argptr+0x50>
801052b8:	85 db                	test   %ebx,%ebx
801052ba:	78 24                	js     801052e0 <argptr+0x50>
801052bc:	8b 16                	mov    (%esi),%edx
801052be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c1:	39 c2                	cmp    %eax,%edx
801052c3:	76 1b                	jbe    801052e0 <argptr+0x50>
801052c5:	01 c3                	add    %eax,%ebx
801052c7:	39 da                	cmp    %ebx,%edx
801052c9:	72 15                	jb     801052e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801052ce:	89 02                	mov    %eax,(%edx)
  return 0;
801052d0:	31 c0                	xor    %eax,%eax
}
801052d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e5:	eb eb                	jmp    801052d2 <argptr+0x42>
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f9:	50                   	push   %eax
801052fa:	ff 75 08             	pushl  0x8(%ebp)
801052fd:	e8 3e ff ff ff       	call   80105240 <argint>
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	85 c0                	test   %eax,%eax
80105307:	78 17                	js     80105320 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105309:	83 ec 08             	sub    $0x8,%esp
8010530c:	ff 75 0c             	pushl  0xc(%ebp)
8010530f:	ff 75 f4             	pushl  -0xc(%ebp)
80105312:	e8 b9 fe ff ff       	call   801051d0 <fetchstr>
80105317:	83 c4 10             	add    $0x10,%esp
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <syscall>:
[SYS_print_information]     sys_print_information,
};

void
syscall(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105337:	e8 74 e6 ff ff       	call   801039b0 <myproc>
8010533c:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
8010533e:	8b 40 18             	mov    0x18(%eax),%eax
80105341:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105344:	8d 50 ff             	lea    -0x1(%eax),%edx
80105347:	83 fa 1c             	cmp    $0x1c,%edx
8010534a:	77 1c                	ja     80105368 <syscall+0x38>
8010534c:	8b 14 85 e0 86 10 80 	mov    -0x7fef7920(,%eax,4),%edx
80105353:	85 d2                	test   %edx,%edx
80105355:	74 11                	je     80105368 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105357:	ff d2                	call   *%edx
80105359:	8b 53 18             	mov    0x18(%ebx),%edx
8010535c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010535f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105362:	c9                   	leave  
80105363:	c3                   	ret    
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105368:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105369:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010536c:	50                   	push   %eax
8010536d:	ff 73 10             	pushl  0x10(%ebx)
80105370:	68 c1 86 10 80       	push   $0x801086c1
80105375:	e8 e6 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010537a:	8b 43 18             	mov    0x18(%ebx),%eax
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	66 90                	xchg   %ax,%ax
8010538e:	66 90                	xchg   %ax,%ax

80105390 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105396:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105399:	83 ec 34             	sub    $0x34,%esp
8010539c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010539f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053a2:	56                   	push   %esi
801053a3:	50                   	push   %eax
{
801053a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053aa:	e8 21 cd ff ff       	call   801020d0 <nameiparent>
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	85 c0                	test   %eax,%eax
801053b4:	0f 84 46 01 00 00    	je     80105500 <create+0x170>
    return 0;
  ilock(dp);
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	89 c3                	mov    %eax,%ebx
801053bf:	50                   	push   %eax
801053c0:	e8 8b c4 ff ff       	call   80101850 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053c5:	83 c4 0c             	add    $0xc,%esp
801053c8:	6a 00                	push   $0x0
801053ca:	56                   	push   %esi
801053cb:	53                   	push   %ebx
801053cc:	e8 af c9 ff ff       	call   80101d80 <dirlookup>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	85 c0                	test   %eax,%eax
801053d6:	89 c7                	mov    %eax,%edi
801053d8:	74 36                	je     80105410 <create+0x80>
    iunlockput(dp);
801053da:	83 ec 0c             	sub    $0xc,%esp
801053dd:	53                   	push   %ebx
801053de:	e8 fd c6 ff ff       	call   80101ae0 <iunlockput>
    ilock(ip);
801053e3:	89 3c 24             	mov    %edi,(%esp)
801053e6:	e8 65 c4 ff ff       	call   80101850 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053eb:	83 c4 10             	add    $0x10,%esp
801053ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053f3:	0f 85 97 00 00 00    	jne    80105490 <create+0x100>
801053f9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801053fe:	0f 85 8c 00 00 00    	jne    80105490 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105404:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105407:	89 f8                	mov    %edi,%eax
80105409:	5b                   	pop    %ebx
8010540a:	5e                   	pop    %esi
8010540b:	5f                   	pop    %edi
8010540c:	5d                   	pop    %ebp
8010540d:	c3                   	ret    
8010540e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105410:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	50                   	push   %eax
80105418:	ff 33                	pushl  (%ebx)
8010541a:	e8 c1 c2 ff ff       	call   801016e0 <ialloc>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	89 c7                	mov    %eax,%edi
80105426:	0f 84 e8 00 00 00    	je     80105514 <create+0x184>
  ilock(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	50                   	push   %eax
80105430:	e8 1b c4 ff ff       	call   80101850 <ilock>
  ip->major = major;
80105435:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105439:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010543d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105441:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105445:	b8 01 00 00 00       	mov    $0x1,%eax
8010544a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010544e:	89 3c 24             	mov    %edi,(%esp)
80105451:	e8 4a c3 ff ff       	call   801017a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010545e:	74 50                	je     801054b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105460:	83 ec 04             	sub    $0x4,%esp
80105463:	ff 77 04             	pushl  0x4(%edi)
80105466:	56                   	push   %esi
80105467:	53                   	push   %ebx
80105468:	e8 83 cb ff ff       	call   80101ff0 <dirlink>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	0f 88 8f 00 00 00    	js     80105507 <create+0x177>
  iunlockput(dp);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	53                   	push   %ebx
8010547c:	e8 5f c6 ff ff       	call   80101ae0 <iunlockput>
  return ip;
80105481:	83 c4 10             	add    $0x10,%esp
}
80105484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105487:	89 f8                	mov    %edi,%eax
80105489:	5b                   	pop    %ebx
8010548a:	5e                   	pop    %esi
8010548b:	5f                   	pop    %edi
8010548c:	5d                   	pop    %ebp
8010548d:	c3                   	ret    
8010548e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	57                   	push   %edi
    return 0;
80105494:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105496:	e8 45 c6 ff ff       	call   80101ae0 <iunlockput>
    return 0;
8010549b:	83 c4 10             	add    $0x10,%esp
}
8010549e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a1:	89 f8                	mov    %edi,%eax
801054a3:	5b                   	pop    %ebx
801054a4:	5e                   	pop    %esi
801054a5:	5f                   	pop    %edi
801054a6:	5d                   	pop    %ebp
801054a7:	c3                   	ret    
801054a8:	90                   	nop
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801054b0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	53                   	push   %ebx
801054b9:	e8 e2 c2 ff ff       	call   801017a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054be:	83 c4 0c             	add    $0xc,%esp
801054c1:	ff 77 04             	pushl  0x4(%edi)
801054c4:	68 74 87 10 80       	push   $0x80108774
801054c9:	57                   	push   %edi
801054ca:	e8 21 cb ff ff       	call   80101ff0 <dirlink>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	85 c0                	test   %eax,%eax
801054d4:	78 1c                	js     801054f2 <create+0x162>
801054d6:	83 ec 04             	sub    $0x4,%esp
801054d9:	ff 73 04             	pushl  0x4(%ebx)
801054dc:	68 73 87 10 80       	push   $0x80108773
801054e1:	57                   	push   %edi
801054e2:	e8 09 cb ff ff       	call   80101ff0 <dirlink>
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	85 c0                	test   %eax,%eax
801054ec:	0f 89 6e ff ff ff    	jns    80105460 <create+0xd0>
      panic("create dots");
801054f2:	83 ec 0c             	sub    $0xc,%esp
801054f5:	68 67 87 10 80       	push   $0x80108767
801054fa:	e8 91 ae ff ff       	call   80100390 <panic>
801054ff:	90                   	nop
    return 0;
80105500:	31 ff                	xor    %edi,%edi
80105502:	e9 fd fe ff ff       	jmp    80105404 <create+0x74>
    panic("create: dirlink");
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	68 76 87 10 80       	push   $0x80108776
8010550f:	e8 7c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105514:	83 ec 0c             	sub    $0xc,%esp
80105517:	68 58 87 10 80       	push   $0x80108758
8010551c:	e8 6f ae ff ff       	call   80100390 <panic>
80105521:	eb 0d                	jmp    80105530 <argfd.constprop.0>
80105523:	90                   	nop
80105524:	90                   	nop
80105525:	90                   	nop
80105526:	90                   	nop
80105527:	90                   	nop
80105528:	90                   	nop
80105529:	90                   	nop
8010552a:	90                   	nop
8010552b:	90                   	nop
8010552c:	90                   	nop
8010552d:	90                   	nop
8010552e:	90                   	nop
8010552f:	90                   	nop

80105530 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
80105535:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105537:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010553a:	89 d6                	mov    %edx,%esi
8010553c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553f:	50                   	push   %eax
80105540:	6a 00                	push   $0x0
80105542:	e8 f9 fc ff ff       	call   80105240 <argint>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	78 2a                	js     80105578 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105552:	77 24                	ja     80105578 <argfd.constprop.0+0x48>
80105554:	e8 57 e4 ff ff       	call   801039b0 <myproc>
80105559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105560:	85 c0                	test   %eax,%eax
80105562:	74 14                	je     80105578 <argfd.constprop.0+0x48>
  if(pfd)
80105564:	85 db                	test   %ebx,%ebx
80105566:	74 02                	je     8010556a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105568:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010556a:	89 06                	mov    %eax,(%esi)
  return 0;
8010556c:	31 c0                	xor    %eax,%eax
}
8010556e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105571:	5b                   	pop    %ebx
80105572:	5e                   	pop    %esi
80105573:	5d                   	pop    %ebp
80105574:	c3                   	ret    
80105575:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb ef                	jmp    8010556e <argfd.constprop.0+0x3e>
8010557f:	90                   	nop

80105580 <sys_dup>:
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	56                   	push   %esi
80105584:	53                   	push   %ebx
80105585:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[9] ++;
80105588:	e8 23 e4 ff ff       	call   801039b0 <myproc>
8010558d:	83 80 a0 00 00 00 01 	addl   $0x1,0xa0(%eax)
  if(argfd(0, 0, &f) < 0)
80105594:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105597:	31 c0                	xor    %eax,%eax
80105599:	e8 92 ff ff ff       	call   80105530 <argfd.constprop.0>
8010559e:	85 c0                	test   %eax,%eax
801055a0:	78 3e                	js     801055e0 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
801055a2:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055a5:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055a7:	e8 04 e4 ff ff       	call   801039b0 <myproc>
801055ac:	eb 0a                	jmp    801055b8 <sys_dup+0x38>
801055ae:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
801055b0:	83 c3 01             	add    $0x1,%ebx
801055b3:	83 fb 10             	cmp    $0x10,%ebx
801055b6:	74 28                	je     801055e0 <sys_dup+0x60>
    if(curproc->ofile[fd] == 0){
801055b8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055bc:	85 d2                	test   %edx,%edx
801055be:	75 f0                	jne    801055b0 <sys_dup+0x30>
      curproc->ofile[fd] = f;
801055c0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ca:	e8 f1 b9 ff ff       	call   80100fc0 <filedup>
  return fd;
801055cf:	83 c4 10             	add    $0x10,%esp
}
801055d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d5:	89 d8                	mov    %ebx,%eax
801055d7:	5b                   	pop    %ebx
801055d8:	5e                   	pop    %esi
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	90                   	nop
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055e8:	89 d8                	mov    %ebx,%eax
801055ea:	5b                   	pop    %ebx
801055eb:	5e                   	pop    %esi
801055ec:	5d                   	pop    %ebp
801055ed:	c3                   	ret    
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <sys_read>:
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[4] ++;
801055f6:	e8 b5 e3 ff ff       	call   801039b0 <myproc>
801055fb:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105602:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105605:	31 c0                	xor    %eax,%eax
80105607:	e8 24 ff ff ff       	call   80105530 <argfd.constprop.0>
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 48                	js     80105658 <sys_read+0x68>
80105610:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105613:	83 ec 08             	sub    $0x8,%esp
80105616:	50                   	push   %eax
80105617:	6a 02                	push   $0x2
80105619:	e8 22 fc ff ff       	call   80105240 <argint>
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	78 33                	js     80105658 <sys_read+0x68>
80105625:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105628:	83 ec 04             	sub    $0x4,%esp
8010562b:	ff 75 f0             	pushl  -0x10(%ebp)
8010562e:	50                   	push   %eax
8010562f:	6a 01                	push   $0x1
80105631:	e8 5a fc ff ff       	call   80105290 <argptr>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 1b                	js     80105658 <sys_read+0x68>
  return fileread(f, p, n);
8010563d:	83 ec 04             	sub    $0x4,%esp
80105640:	ff 75 f0             	pushl  -0x10(%ebp)
80105643:	ff 75 f4             	pushl  -0xc(%ebp)
80105646:	ff 75 ec             	pushl  -0x14(%ebp)
80105649:	e8 e2 ba ff ff       	call   80101130 <fileread>
8010564e:	83 c4 10             	add    $0x10,%esp
}
80105651:	c9                   	leave  
80105652:	c3                   	ret    
80105653:	90                   	nop
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565d:	c9                   	leave  
8010565e:	c3                   	ret    
8010565f:	90                   	nop

80105660 <sys_write>:
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[15] ++;
80105666:	e8 45 e3 ff ff       	call   801039b0 <myproc>
8010566b:	83 80 b8 00 00 00 01 	addl   $0x1,0xb8(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105672:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105675:	31 c0                	xor    %eax,%eax
80105677:	e8 b4 fe ff ff       	call   80105530 <argfd.constprop.0>
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 48                	js     801056c8 <sys_write+0x68>
80105680:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	50                   	push   %eax
80105687:	6a 02                	push   $0x2
80105689:	e8 b2 fb ff ff       	call   80105240 <argint>
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	85 c0                	test   %eax,%eax
80105693:	78 33                	js     801056c8 <sys_write+0x68>
80105695:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105698:	83 ec 04             	sub    $0x4,%esp
8010569b:	ff 75 f0             	pushl  -0x10(%ebp)
8010569e:	50                   	push   %eax
8010569f:	6a 01                	push   $0x1
801056a1:	e8 ea fb ff ff       	call   80105290 <argptr>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	78 1b                	js     801056c8 <sys_write+0x68>
  return filewrite(f, p, n);
801056ad:	83 ec 04             	sub    $0x4,%esp
801056b0:	ff 75 f0             	pushl  -0x10(%ebp)
801056b3:	ff 75 f4             	pushl  -0xc(%ebp)
801056b6:	ff 75 ec             	pushl  -0x14(%ebp)
801056b9:	e8 02 bb ff ff       	call   801011c0 <filewrite>
801056be:	83 c4 10             	add    $0x10,%esp
}
801056c1:	c9                   	leave  
801056c2:	c3                   	ret    
801056c3:	90                   	nop
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056cd:	c9                   	leave  
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_close>:
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[20] ++;
801056d6:	e8 d5 e2 ff ff       	call   801039b0 <myproc>
801056db:	83 80 cc 00 00 00 01 	addl   $0x1,0xcc(%eax)
  if(argfd(0, &fd, &f) < 0)
801056e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056e8:	e8 43 fe ff ff       	call   80105530 <argfd.constprop.0>
801056ed:	85 c0                	test   %eax,%eax
801056ef:	78 27                	js     80105718 <sys_close+0x48>
  myproc()->ofile[fd] = 0;
801056f1:	e8 ba e2 ff ff       	call   801039b0 <myproc>
801056f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056f9:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056fc:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105703:	00 
  fileclose(f);
80105704:	ff 75 f4             	pushl  -0xc(%ebp)
80105707:	e8 04 b9 ff ff       	call   80101010 <fileclose>
  return 0;
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	31 c0                	xor    %eax,%eax
}
80105711:	c9                   	leave  
80105712:	c3                   	ret    
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571d:	c9                   	leave  
8010571e:	c3                   	ret    
8010571f:	90                   	nop

80105720 <sys_fstat>:
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[7] ++;
80105726:	e8 85 e2 ff ff       	call   801039b0 <myproc>
8010572b:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105732:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105735:	31 c0                	xor    %eax,%eax
80105737:	e8 f4 fd ff ff       	call   80105530 <argfd.constprop.0>
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 30                	js     80105770 <sys_fstat+0x50>
80105740:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105743:	83 ec 04             	sub    $0x4,%esp
80105746:	6a 14                	push   $0x14
80105748:	50                   	push   %eax
80105749:	6a 01                	push   $0x1
8010574b:	e8 40 fb ff ff       	call   80105290 <argptr>
80105750:	83 c4 10             	add    $0x10,%esp
80105753:	85 c0                	test   %eax,%eax
80105755:	78 19                	js     80105770 <sys_fstat+0x50>
  return filestat(f, st);
80105757:	83 ec 08             	sub    $0x8,%esp
8010575a:	ff 75 f4             	pushl  -0xc(%ebp)
8010575d:	ff 75 f0             	pushl  -0x10(%ebp)
80105760:	e8 7b b9 ff ff       	call   801010e0 <filestat>
80105765:	83 c4 10             	add    $0x10,%esp
}
80105768:	c9                   	leave  
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_link>:
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
80105786:	83 ec 2c             	sub    $0x2c,%esp
  myproc()->call_nums[18] ++;
80105789:	e8 22 e2 ff ff       	call   801039b0 <myproc>
8010578e:	83 80 c4 00 00 00 01 	addl   $0x1,0xc4(%eax)
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105795:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105798:	83 ec 08             	sub    $0x8,%esp
8010579b:	50                   	push   %eax
8010579c:	6a 00                	push   $0x0
8010579e:	e8 4d fb ff ff       	call   801052f0 <argstr>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	0f 88 fc 00 00 00    	js     801058aa <sys_link+0x12a>
801057ae:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057b1:	83 ec 08             	sub    $0x8,%esp
801057b4:	50                   	push   %eax
801057b5:	6a 01                	push   $0x1
801057b7:	e8 34 fb ff ff       	call   801052f0 <argstr>
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	85 c0                	test   %eax,%eax
801057c1:	0f 88 e3 00 00 00    	js     801058aa <sys_link+0x12a>
  begin_op();
801057c7:	e8 a4 d5 ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	ff 75 d4             	pushl  -0x2c(%ebp)
801057d2:	e8 d9 c8 ff ff       	call   801020b0 <namei>
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	85 c0                	test   %eax,%eax
801057dc:	89 c3                	mov    %eax,%ebx
801057de:	0f 84 eb 00 00 00    	je     801058cf <sys_link+0x14f>
  ilock(ip);
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	50                   	push   %eax
801057e8:	e8 63 c0 ff ff       	call   80101850 <ilock>
  if(ip->type == T_DIR){
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057f5:	0f 84 bc 00 00 00    	je     801058b7 <sys_link+0x137>
  ip->nlink++;
801057fb:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105800:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105803:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105806:	53                   	push   %ebx
80105807:	e8 94 bf ff ff       	call   801017a0 <iupdate>
  iunlock(ip);
8010580c:	89 1c 24             	mov    %ebx,(%esp)
8010580f:	e8 1c c1 ff ff       	call   80101930 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105814:	58                   	pop    %eax
80105815:	5a                   	pop    %edx
80105816:	57                   	push   %edi
80105817:	ff 75 d0             	pushl  -0x30(%ebp)
8010581a:	e8 b1 c8 ff ff       	call   801020d0 <nameiparent>
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	85 c0                	test   %eax,%eax
80105824:	89 c6                	mov    %eax,%esi
80105826:	74 5c                	je     80105884 <sys_link+0x104>
  ilock(dp);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	50                   	push   %eax
8010582c:	e8 1f c0 ff ff       	call   80101850 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	8b 03                	mov    (%ebx),%eax
80105836:	39 06                	cmp    %eax,(%esi)
80105838:	75 3e                	jne    80105878 <sys_link+0xf8>
8010583a:	83 ec 04             	sub    $0x4,%esp
8010583d:	ff 73 04             	pushl  0x4(%ebx)
80105840:	57                   	push   %edi
80105841:	56                   	push   %esi
80105842:	e8 a9 c7 ff ff       	call   80101ff0 <dirlink>
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	85 c0                	test   %eax,%eax
8010584c:	78 2a                	js     80105878 <sys_link+0xf8>
  iunlockput(dp);
8010584e:	83 ec 0c             	sub    $0xc,%esp
80105851:	56                   	push   %esi
80105852:	e8 89 c2 ff ff       	call   80101ae0 <iunlockput>
  iput(ip);
80105857:	89 1c 24             	mov    %ebx,(%esp)
8010585a:	e8 21 c1 ff ff       	call   80101980 <iput>
  end_op();
8010585f:	e8 7c d5 ff ff       	call   80102de0 <end_op>
  return 0;
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	31 c0                	xor    %eax,%eax
}
80105869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586c:	5b                   	pop    %ebx
8010586d:	5e                   	pop    %esi
8010586e:	5f                   	pop    %edi
8010586f:	5d                   	pop    %ebp
80105870:	c3                   	ret    
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	56                   	push   %esi
8010587c:	e8 5f c2 ff ff       	call   80101ae0 <iunlockput>
    goto bad;
80105881:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105884:	83 ec 0c             	sub    $0xc,%esp
80105887:	53                   	push   %ebx
80105888:	e8 c3 bf ff ff       	call   80101850 <ilock>
  ip->nlink--;
8010588d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105892:	89 1c 24             	mov    %ebx,(%esp)
80105895:	e8 06 bf ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
8010589a:	89 1c 24             	mov    %ebx,(%esp)
8010589d:	e8 3e c2 ff ff       	call   80101ae0 <iunlockput>
  end_op();
801058a2:	e8 39 d5 ff ff       	call   80102de0 <end_op>
  return -1;
801058a7:	83 c4 10             	add    $0x10,%esp
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801058ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b2:	5b                   	pop    %ebx
801058b3:	5e                   	pop    %esi
801058b4:	5f                   	pop    %edi
801058b5:	5d                   	pop    %ebp
801058b6:	c3                   	ret    
    iunlockput(ip);
801058b7:	83 ec 0c             	sub    $0xc,%esp
801058ba:	53                   	push   %ebx
801058bb:	e8 20 c2 ff ff       	call   80101ae0 <iunlockput>
    end_op();
801058c0:	e8 1b d5 ff ff       	call   80102de0 <end_op>
    return -1;
801058c5:	83 c4 10             	add    $0x10,%esp
801058c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cd:	eb 9a                	jmp    80105869 <sys_link+0xe9>
    end_op();
801058cf:	e8 0c d5 ff ff       	call   80102de0 <end_op>
    return -1;
801058d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d9:	eb 8e                	jmp    80105869 <sys_link+0xe9>
801058db:	90                   	nop
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_unlink>:
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
801058e5:	53                   	push   %ebx
801058e6:	83 ec 3c             	sub    $0x3c,%esp
  myproc()->call_nums[17] ++;
801058e9:	e8 c2 e0 ff ff       	call   801039b0 <myproc>
801058ee:	83 80 c0 00 00 00 01 	addl   $0x1,0xc0(%eax)
  if(argstr(0, &path) < 0)
801058f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
801058f8:	83 ec 08             	sub    $0x8,%esp
801058fb:	50                   	push   %eax
801058fc:	6a 00                	push   $0x0
801058fe:	e8 ed f9 ff ff       	call   801052f0 <argstr>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	0f 88 78 01 00 00    	js     80105a86 <sys_unlink+0x1a6>
  if((dp = nameiparent(path, name)) == 0){
8010590e:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105911:	e8 5a d4 ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105916:	83 ec 08             	sub    $0x8,%esp
80105919:	53                   	push   %ebx
8010591a:	ff 75 c0             	pushl  -0x40(%ebp)
8010591d:	e8 ae c7 ff ff       	call   801020d0 <nameiparent>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	89 c6                	mov    %eax,%esi
80105929:	0f 84 61 01 00 00    	je     80105a90 <sys_unlink+0x1b0>
  ilock(dp);
8010592f:	83 ec 0c             	sub    $0xc,%esp
80105932:	50                   	push   %eax
80105933:	e8 18 bf ff ff       	call   80101850 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105938:	58                   	pop    %eax
80105939:	5a                   	pop    %edx
8010593a:	68 74 87 10 80       	push   $0x80108774
8010593f:	53                   	push   %ebx
80105940:	e8 1b c4 ff ff       	call   80101d60 <namecmp>
80105945:	83 c4 10             	add    $0x10,%esp
80105948:	85 c0                	test   %eax,%eax
8010594a:	0f 84 04 01 00 00    	je     80105a54 <sys_unlink+0x174>
80105950:	83 ec 08             	sub    $0x8,%esp
80105953:	68 73 87 10 80       	push   $0x80108773
80105958:	53                   	push   %ebx
80105959:	e8 02 c4 ff ff       	call   80101d60 <namecmp>
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	85 c0                	test   %eax,%eax
80105963:	0f 84 eb 00 00 00    	je     80105a54 <sys_unlink+0x174>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105969:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010596c:	83 ec 04             	sub    $0x4,%esp
8010596f:	50                   	push   %eax
80105970:	53                   	push   %ebx
80105971:	56                   	push   %esi
80105972:	e8 09 c4 ff ff       	call   80101d80 <dirlookup>
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	85 c0                	test   %eax,%eax
8010597c:	89 c3                	mov    %eax,%ebx
8010597e:	0f 84 d0 00 00 00    	je     80105a54 <sys_unlink+0x174>
  ilock(ip);
80105984:	83 ec 0c             	sub    $0xc,%esp
80105987:	50                   	push   %eax
80105988:	e8 c3 be ff ff       	call   80101850 <ilock>
  if(ip->nlink < 1)
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105995:	0f 8e 11 01 00 00    	jle    80105aac <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010599b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059a0:	74 6e                	je     80105a10 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801059a2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059a5:	83 ec 04             	sub    $0x4,%esp
801059a8:	6a 10                	push   $0x10
801059aa:	6a 00                	push   $0x0
801059ac:	50                   	push   %eax
801059ad:	e8 8e f5 ff ff       	call   80104f40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059b2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059b5:	6a 10                	push   $0x10
801059b7:	ff 75 c4             	pushl  -0x3c(%ebp)
801059ba:	50                   	push   %eax
801059bb:	56                   	push   %esi
801059bc:	e8 6f c2 ff ff       	call   80101c30 <writei>
801059c1:	83 c4 20             	add    $0x20,%esp
801059c4:	83 f8 10             	cmp    $0x10,%eax
801059c7:	0f 85 ec 00 00 00    	jne    80105ab9 <sys_unlink+0x1d9>
  if(ip->type == T_DIR){
801059cd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059d2:	0f 84 98 00 00 00    	je     80105a70 <sys_unlink+0x190>
  iunlockput(dp);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	56                   	push   %esi
801059dc:	e8 ff c0 ff ff       	call   80101ae0 <iunlockput>
  ip->nlink--;
801059e1:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059e6:	89 1c 24             	mov    %ebx,(%esp)
801059e9:	e8 b2 bd ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
801059ee:	89 1c 24             	mov    %ebx,(%esp)
801059f1:	e8 ea c0 ff ff       	call   80101ae0 <iunlockput>
  end_op();
801059f6:	e8 e5 d3 ff ff       	call   80102de0 <end_op>
  return 0;
801059fb:	83 c4 10             	add    $0x10,%esp
801059fe:	31 c0                	xor    %eax,%eax
}
80105a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a03:	5b                   	pop    %ebx
80105a04:	5e                   	pop    %esi
80105a05:	5f                   	pop    %edi
80105a06:	5d                   	pop    %ebp
80105a07:	c3                   	ret    
80105a08:	90                   	nop
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a14:	76 8c                	jbe    801059a2 <sys_unlink+0xc2>
80105a16:	bf 20 00 00 00       	mov    $0x20,%edi
80105a1b:	eb 0f                	jmp    80105a2c <sys_unlink+0x14c>
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
80105a20:	83 c7 10             	add    $0x10,%edi
80105a23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105a26:	0f 83 76 ff ff ff    	jae    801059a2 <sys_unlink+0xc2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a2c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a2f:	6a 10                	push   $0x10
80105a31:	57                   	push   %edi
80105a32:	50                   	push   %eax
80105a33:	53                   	push   %ebx
80105a34:	e8 f7 c0 ff ff       	call   80101b30 <readi>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	83 f8 10             	cmp    $0x10,%eax
80105a3f:	75 5e                	jne    80105a9f <sys_unlink+0x1bf>
    if(de.inum != 0)
80105a41:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a46:	74 d8                	je     80105a20 <sys_unlink+0x140>
    iunlockput(ip);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	53                   	push   %ebx
80105a4c:	e8 8f c0 ff ff       	call   80101ae0 <iunlockput>
    goto bad;
80105a51:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105a54:	83 ec 0c             	sub    $0xc,%esp
80105a57:	56                   	push   %esi
80105a58:	e8 83 c0 ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105a5d:	e8 7e d3 ff ff       	call   80102de0 <end_op>
  return -1;
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6a:	eb 94                	jmp    80105a00 <sys_unlink+0x120>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105a70:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a75:	83 ec 0c             	sub    $0xc,%esp
80105a78:	56                   	push   %esi
80105a79:	e8 22 bd ff ff       	call   801017a0 <iupdate>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	e9 52 ff ff ff       	jmp    801059d8 <sys_unlink+0xf8>
    return -1;
80105a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8b:	e9 70 ff ff ff       	jmp    80105a00 <sys_unlink+0x120>
    end_op();
80105a90:	e8 4b d3 ff ff       	call   80102de0 <end_op>
    return -1;
80105a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9a:	e9 61 ff ff ff       	jmp    80105a00 <sys_unlink+0x120>
      panic("isdirempty: readi");
80105a9f:	83 ec 0c             	sub    $0xc,%esp
80105aa2:	68 98 87 10 80       	push   $0x80108798
80105aa7:	e8 e4 a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105aac:	83 ec 0c             	sub    $0xc,%esp
80105aaf:	68 86 87 10 80       	push   $0x80108786
80105ab4:	e8 d7 a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105ab9:	83 ec 0c             	sub    $0xc,%esp
80105abc:	68 aa 87 10 80       	push   $0x801087aa
80105ac1:	e8 ca a8 ff ff       	call   80100390 <panic>
80105ac6:	8d 76 00             	lea    0x0(%esi),%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ad0 <sys_open>:

int
sys_open(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
80105ad6:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[14] ++;
80105ad9:	e8 d2 de ff ff       	call   801039b0 <myproc>
80105ade:	83 80 b4 00 00 00 01 	addl   $0x1,0xb4(%eax)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ae5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae8:	83 ec 08             	sub    $0x8,%esp
80105aeb:	50                   	push   %eax
80105aec:	6a 00                	push   $0x0
80105aee:	e8 fd f7 ff ff       	call   801052f0 <argstr>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	0f 88 1e 01 00 00    	js     80105c1c <sys_open+0x14c>
80105afe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b01:	83 ec 08             	sub    $0x8,%esp
80105b04:	50                   	push   %eax
80105b05:	6a 01                	push   $0x1
80105b07:	e8 34 f7 ff ff       	call   80105240 <argint>
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	85 c0                	test   %eax,%eax
80105b11:	0f 88 05 01 00 00    	js     80105c1c <sys_open+0x14c>
    return -1;

  begin_op();
80105b17:	e8 54 d2 ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105b1c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b20:	0f 85 aa 00 00 00    	jne    80105bd0 <sys_open+0x100>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b26:	83 ec 0c             	sub    $0xc,%esp
80105b29:	ff 75 e0             	pushl  -0x20(%ebp)
80105b2c:	e8 7f c5 ff ff       	call   801020b0 <namei>
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	85 c0                	test   %eax,%eax
80105b36:	89 c6                	mov    %eax,%esi
80105b38:	0f 84 b3 00 00 00    	je     80105bf1 <sys_open+0x121>
      end_op();
      return -1;
    }
    ilock(ip);
80105b3e:	83 ec 0c             	sub    $0xc,%esp
80105b41:	50                   	push   %eax
80105b42:	e8 09 bd ff ff       	call   80101850 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b4f:	0f 84 ab 00 00 00    	je     80105c00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b55:	e8 f6 b3 ff ff       	call   80100f50 <filealloc>
80105b5a:	85 c0                	test   %eax,%eax
80105b5c:	89 c7                	mov    %eax,%edi
80105b5e:	0f 84 a7 00 00 00    	je     80105c0b <sys_open+0x13b>
  struct proc *curproc = myproc();
80105b64:	e8 47 de ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b69:	31 db                	xor    %ebx,%ebx
80105b6b:	eb 0f                	jmp    80105b7c <sys_open+0xac>
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi
80105b70:	83 c3 01             	add    $0x1,%ebx
80105b73:	83 fb 10             	cmp    $0x10,%ebx
80105b76:	0f 84 ac 00 00 00    	je     80105c28 <sys_open+0x158>
    if(curproc->ofile[fd] == 0){
80105b7c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b80:	85 d2                	test   %edx,%edx
80105b82:	75 ec                	jne    80105b70 <sys_open+0xa0>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b87:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b8b:	56                   	push   %esi
80105b8c:	e8 9f bd ff ff       	call   80101930 <iunlock>
  end_op();
80105b91:	e8 4a d2 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
80105b96:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b9f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ba2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105ba5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bac:	89 d0                	mov    %edx,%eax
80105bae:	f7 d0                	not    %eax
80105bb0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bb3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bb6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bb9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc0:	89 d8                	mov    %ebx,%eax
80105bc2:	5b                   	pop    %ebx
80105bc3:	5e                   	pop    %esi
80105bc4:	5f                   	pop    %edi
80105bc5:	5d                   	pop    %ebp
80105bc6:	c3                   	ret    
80105bc7:	89 f6                	mov    %esi,%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bd6:	31 c9                	xor    %ecx,%ecx
80105bd8:	6a 00                	push   $0x0
80105bda:	ba 02 00 00 00       	mov    $0x2,%edx
80105bdf:	e8 ac f7 ff ff       	call   80105390 <create>
    if(ip == 0){
80105be4:	83 c4 10             	add    $0x10,%esp
80105be7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105be9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105beb:	0f 85 64 ff ff ff    	jne    80105b55 <sys_open+0x85>
      end_op();
80105bf1:	e8 ea d1 ff ff       	call   80102de0 <end_op>
      return -1;
80105bf6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bfb:	eb c0                	jmp    80105bbd <sys_open+0xed>
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c03:	85 c9                	test   %ecx,%ecx
80105c05:	0f 84 4a ff ff ff    	je     80105b55 <sys_open+0x85>
    iunlockput(ip);
80105c0b:	83 ec 0c             	sub    $0xc,%esp
80105c0e:	56                   	push   %esi
80105c0f:	e8 cc be ff ff       	call   80101ae0 <iunlockput>
    end_op();
80105c14:	e8 c7 d1 ff ff       	call   80102de0 <end_op>
    return -1;
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c21:	eb 9a                	jmp    80105bbd <sys_open+0xed>
80105c23:	90                   	nop
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	57                   	push   %edi
80105c2c:	e8 df b3 ff ff       	call   80101010 <fileclose>
80105c31:	83 c4 10             	add    $0x10,%esp
80105c34:	eb d5                	jmp    80105c0b <sys_open+0x13b>
80105c36:	8d 76 00             	lea    0x0(%esi),%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[19] ++;
80105c46:	e8 65 dd ff ff       	call   801039b0 <myproc>
80105c4b:	83 80 c8 00 00 00 01 	addl   $0x1,0xc8(%eax)
  char *path;
  struct inode *ip;

  begin_op();
80105c52:	e8 19 d1 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5a:	83 ec 08             	sub    $0x8,%esp
80105c5d:	50                   	push   %eax
80105c5e:	6a 00                	push   $0x0
80105c60:	e8 8b f6 ff ff       	call   801052f0 <argstr>
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	78 34                	js     80105ca0 <sys_mkdir+0x60>
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c72:	31 c9                	xor    %ecx,%ecx
80105c74:	6a 00                	push   $0x0
80105c76:	ba 01 00 00 00       	mov    $0x1,%edx
80105c7b:	e8 10 f7 ff ff       	call   80105390 <create>
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	85 c0                	test   %eax,%eax
80105c85:	74 19                	je     80105ca0 <sys_mkdir+0x60>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c87:	83 ec 0c             	sub    $0xc,%esp
80105c8a:	50                   	push   %eax
80105c8b:	e8 50 be ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105c90:	e8 4b d1 ff ff       	call   80102de0 <end_op>
  return 0;
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	31 c0                	xor    %eax,%eax
}
80105c9a:	c9                   	leave  
80105c9b:	c3                   	ret    
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ca0:	e8 3b d1 ff ff       	call   80102de0 <end_op>
    return -1;
80105ca5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105caa:	c9                   	leave  
80105cab:	c3                   	ret    
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_mknod>:

int
sys_mknod(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[16] ++;
80105cb6:	e8 f5 dc ff ff       	call   801039b0 <myproc>
80105cbb:	83 80 bc 00 00 00 01 	addl   $0x1,0xbc(%eax)
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cc2:	e8 a9 d0 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105cc7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cca:	83 ec 08             	sub    $0x8,%esp
80105ccd:	50                   	push   %eax
80105cce:	6a 00                	push   $0x0
80105cd0:	e8 1b f6 ff ff       	call   801052f0 <argstr>
80105cd5:	83 c4 10             	add    $0x10,%esp
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	78 64                	js     80105d40 <sys_mknod+0x90>
     argint(1, &major) < 0 ||
80105cdc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cdf:	83 ec 08             	sub    $0x8,%esp
80105ce2:	50                   	push   %eax
80105ce3:	6a 01                	push   $0x1
80105ce5:	e8 56 f5 ff ff       	call   80105240 <argint>
  if((argstr(0, &path)) < 0 ||
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	85 c0                	test   %eax,%eax
80105cef:	78 4f                	js     80105d40 <sys_mknod+0x90>
     argint(2, &minor) < 0 ||
80105cf1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf4:	83 ec 08             	sub    $0x8,%esp
80105cf7:	50                   	push   %eax
80105cf8:	6a 02                	push   $0x2
80105cfa:	e8 41 f5 ff ff       	call   80105240 <argint>
     argint(1, &major) < 0 ||
80105cff:	83 c4 10             	add    $0x10,%esp
80105d02:	85 c0                	test   %eax,%eax
80105d04:	78 3a                	js     80105d40 <sys_mknod+0x90>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d06:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d0a:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d0d:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105d11:	ba 03 00 00 00       	mov    $0x3,%edx
80105d16:	50                   	push   %eax
80105d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d1a:	e8 71 f6 ff ff       	call   80105390 <create>
80105d1f:	83 c4 10             	add    $0x10,%esp
80105d22:	85 c0                	test   %eax,%eax
80105d24:	74 1a                	je     80105d40 <sys_mknod+0x90>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d26:	83 ec 0c             	sub    $0xc,%esp
80105d29:	50                   	push   %eax
80105d2a:	e8 b1 bd ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105d2f:	e8 ac d0 ff ff       	call   80102de0 <end_op>
  return 0;
80105d34:	83 c4 10             	add    $0x10,%esp
80105d37:	31 c0                	xor    %eax,%eax
}
80105d39:	c9                   	leave  
80105d3a:	c3                   	ret    
80105d3b:	90                   	nop
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d40:	e8 9b d0 ff ff       	call   80102de0 <end_op>
    return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_chdir>:

int
sys_chdir(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	56                   	push   %esi
80105d54:	53                   	push   %ebx
80105d55:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[8] ++;
80105d58:	e8 53 dc ff ff       	call   801039b0 <myproc>
80105d5d:	83 80 9c 00 00 00 01 	addl   $0x1,0x9c(%eax)
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d64:	e8 47 dc ff ff       	call   801039b0 <myproc>
80105d69:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d6b:	e8 00 d0 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d73:	83 ec 08             	sub    $0x8,%esp
80105d76:	50                   	push   %eax
80105d77:	6a 00                	push   $0x0
80105d79:	e8 72 f5 ff ff       	call   801052f0 <argstr>
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	85 c0                	test   %eax,%eax
80105d83:	78 6b                	js     80105df0 <sys_chdir+0xa0>
80105d85:	83 ec 0c             	sub    $0xc,%esp
80105d88:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8b:	e8 20 c3 ff ff       	call   801020b0 <namei>
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	85 c0                	test   %eax,%eax
80105d95:	89 c3                	mov    %eax,%ebx
80105d97:	74 57                	je     80105df0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d99:	83 ec 0c             	sub    $0xc,%esp
80105d9c:	50                   	push   %eax
80105d9d:	e8 ae ba ff ff       	call   80101850 <ilock>
  if(ip->type != T_DIR){
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105daa:	75 2c                	jne    80105dd8 <sys_chdir+0x88>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	53                   	push   %ebx
80105db0:	e8 7b bb ff ff       	call   80101930 <iunlock>
  iput(curproc->cwd);
80105db5:	58                   	pop    %eax
80105db6:	ff 76 68             	pushl  0x68(%esi)
80105db9:	e8 c2 bb ff ff       	call   80101980 <iput>
  end_op();
80105dbe:	e8 1d d0 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
80105dc3:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	31 c0                	xor    %eax,%eax
}
80105dcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dce:	5b                   	pop    %ebx
80105dcf:	5e                   	pop    %esi
80105dd0:	5d                   	pop    %ebp
80105dd1:	c3                   	ret    
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105dd8:	83 ec 0c             	sub    $0xc,%esp
80105ddb:	53                   	push   %ebx
80105ddc:	e8 ff bc ff ff       	call   80101ae0 <iunlockput>
    end_op();
80105de1:	e8 fa cf ff ff       	call   80102de0 <end_op>
    return -1;
80105de6:	83 c4 10             	add    $0x10,%esp
80105de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dee:	eb db                	jmp    80105dcb <sys_chdir+0x7b>
    end_op();
80105df0:	e8 eb cf ff ff       	call   80102de0 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfa:	eb cf                	jmp    80105dcb <sys_chdir+0x7b>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_exec>:

int
sys_exec(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  myproc()->call_nums[6] ++;
80105e0c:	e8 9f db ff ff       	call   801039b0 <myproc>
80105e11:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e18:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105e1e:	83 ec 08             	sub    $0x8,%esp
80105e21:	50                   	push   %eax
80105e22:	6a 00                	push   $0x0
80105e24:	e8 c7 f4 ff ff       	call   801052f0 <argstr>
80105e29:	83 c4 10             	add    $0x10,%esp
80105e2c:	85 c0                	test   %eax,%eax
80105e2e:	0f 88 88 00 00 00    	js     80105ebc <sys_exec+0xbc>
80105e34:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e3a:	83 ec 08             	sub    $0x8,%esp
80105e3d:	50                   	push   %eax
80105e3e:	6a 01                	push   $0x1
80105e40:	e8 fb f3 ff ff       	call   80105240 <argint>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	78 70                	js     80105ebc <sys_exec+0xbc>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e4c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e52:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105e55:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e57:	68 80 00 00 00       	push   $0x80
80105e5c:	6a 00                	push   $0x0
80105e5e:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e64:	50                   	push   %eax
80105e65:	e8 d6 f0 ff ff       	call   80104f40 <memset>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	eb 2d                	jmp    80105e9c <sys_exec+0x9c>
80105e6f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e70:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e76:	85 c0                	test   %eax,%eax
80105e78:	74 56                	je     80105ed0 <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e7a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e80:	83 ec 08             	sub    $0x8,%esp
80105e83:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e86:	52                   	push   %edx
80105e87:	50                   	push   %eax
80105e88:	e8 43 f3 ff ff       	call   801051d0 <fetchstr>
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	85 c0                	test   %eax,%eax
80105e92:	78 28                	js     80105ebc <sys_exec+0xbc>
  for(i=0;; i++){
80105e94:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e97:	83 fb 20             	cmp    $0x20,%ebx
80105e9a:	74 20                	je     80105ebc <sys_exec+0xbc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e9c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ea2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ea9:	83 ec 08             	sub    $0x8,%esp
80105eac:	57                   	push   %edi
80105ead:	01 f0                	add    %esi,%eax
80105eaf:	50                   	push   %eax
80105eb0:	e8 db f2 ff ff       	call   80105190 <fetchint>
80105eb5:	83 c4 10             	add    $0x10,%esp
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	79 b4                	jns    80105e70 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
80105ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ed0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ed6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ed9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ee0:	00 00 00 00 
  return exec(path, argv);
80105ee4:	50                   	push   %eax
80105ee5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105eeb:	e8 f0 ac ff ff       	call   80100be0 <exec>
80105ef0:	83 c4 10             	add    $0x10,%esp
}
80105ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef6:	5b                   	pop    %ebx
80105ef7:	5e                   	pop    %esi
80105ef8:	5f                   	pop    %edi
80105ef9:	5d                   	pop    %ebp
80105efa:	c3                   	ret    
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_pipe>:

int
sys_pipe(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[3] ++;
80105f09:	e8 a2 da ff ff       	call   801039b0 <myproc>
80105f0e:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f15:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f18:	83 ec 04             	sub    $0x4,%esp
80105f1b:	6a 08                	push   $0x8
80105f1d:	50                   	push   %eax
80105f1e:	6a 00                	push   $0x0
80105f20:	e8 6b f3 ff ff       	call   80105290 <argptr>
80105f25:	83 c4 10             	add    $0x10,%esp
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	0f 88 af 00 00 00    	js     80105fdf <sys_pipe+0xdf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f33:	83 ec 08             	sub    $0x8,%esp
80105f36:	50                   	push   %eax
80105f37:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f3a:	50                   	push   %eax
80105f3b:	e8 d0 d4 ff ff       	call   80103410 <pipealloc>
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	85 c0                	test   %eax,%eax
80105f45:	0f 88 94 00 00 00    	js     80105fdf <sys_pipe+0xdf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f4b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f4e:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f50:	e8 5b da ff ff       	call   801039b0 <myproc>
80105f55:	eb 11                	jmp    80105f68 <sys_pipe+0x68>
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f60:	83 c3 01             	add    $0x1,%ebx
80105f63:	83 fb 10             	cmp    $0x10,%ebx
80105f66:	74 60                	je     80105fc8 <sys_pipe+0xc8>
    if(curproc->ofile[fd] == 0){
80105f68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f6c:	85 f6                	test   %esi,%esi
80105f6e:	75 f0                	jne    80105f60 <sys_pipe+0x60>
      curproc->ofile[fd] = f;
80105f70:	8d 73 08             	lea    0x8(%ebx),%esi
80105f73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f7a:	e8 31 da ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f7f:	31 d2                	xor    %edx,%edx
80105f81:	eb 0d                	jmp    80105f90 <sys_pipe+0x90>
80105f83:	90                   	nop
80105f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f88:	83 c2 01             	add    $0x1,%edx
80105f8b:	83 fa 10             	cmp    $0x10,%edx
80105f8e:	74 28                	je     80105fb8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105f90:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f94:	85 c9                	test   %ecx,%ecx
80105f96:	75 f0                	jne    80105f88 <sys_pipe+0x88>
      curproc->ofile[fd] = f;
80105f98:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f9f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fa4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105fa7:	31 c0                	xor    %eax,%eax
}
80105fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fac:	5b                   	pop    %ebx
80105fad:	5e                   	pop    %esi
80105fae:	5f                   	pop    %edi
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105fb8:	e8 f3 d9 ff ff       	call   801039b0 <myproc>
80105fbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fc4:	00 
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	ff 75 e0             	pushl  -0x20(%ebp)
80105fce:	e8 3d b0 ff ff       	call   80101010 <fileclose>
    fileclose(wf);
80105fd3:	58                   	pop    %eax
80105fd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fd7:	e8 34 b0 ff ff       	call   80101010 <fileclose>
    return -1;
80105fdc:	83 c4 10             	add    $0x10,%esp
80105fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe4:	eb c3                	jmp    80105fa9 <sys_pipe+0xa9>
80105fe6:	66 90                	xchg   %ax,%ax
80105fe8:	66 90                	xchg   %ax,%ax
80105fea:	66 90                	xchg   %ax,%ax
80105fec:	66 90                	xchg   %ax,%ax
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[0] ++;
80105ff6:	e8 b5 d9 ff ff       	call   801039b0 <myproc>
80105ffb:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
  return fork();
}
80105fff:	c9                   	leave  
  return fork();
80106000:	e9 4b db ff ff       	jmp    80103b50 <fork>
80106005:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106010 <sys_exit>:

int
sys_exit(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[1] ++;
80106016:	e8 95 d9 ff ff       	call   801039b0 <myproc>
8010601b:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
  exit();
80106022:	e8 29 e0 ff ff       	call   80104050 <exit>
  return 0;  // not reached
}
80106027:	31 c0                	xor    %eax,%eax
80106029:	c9                   	leave  
8010602a:	c3                   	ret    
8010602b:	90                   	nop
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <sys_wait>:

int
sys_wait(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[2] ++;
80106036:	e8 75 d9 ff ff       	call   801039b0 <myproc>
8010603b:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  return wait();
}
80106042:	c9                   	leave  
  return wait();
80106043:	e9 48 e2 ff ff       	jmp    80104290 <wait>
80106048:	90                   	nop
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_kill>:

int
sys_kill(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 18             	sub    $0x18,%esp
  int pid;
  myproc()->call_nums[5] ++;
80106056:	e8 55 d9 ff ff       	call   801039b0 <myproc>
8010605b:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)

  if(argint(0, &pid) < 0)
80106062:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	50                   	push   %eax
80106069:	6a 00                	push   $0x0
8010606b:	e8 d0 f1 ff ff       	call   80105240 <argint>
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	85 c0                	test   %eax,%eax
80106075:	78 19                	js     80106090 <sys_kill+0x40>
    return -1;
  return kill(pid);
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	ff 75 f4             	pushl  -0xc(%ebp)
8010607d:	e8 6e e3 ff ff       	call   801043f0 <kill>
80106082:	83 c4 10             	add    $0x10,%esp
}
80106085:	c9                   	leave  
80106086:	c3                   	ret    
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <sys_getpid>:

int
sys_getpid(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 08             	sub    $0x8,%esp
  
  myproc()->call_nums[10] ++;
801060a6:	e8 05 d9 ff ff       	call   801039b0 <myproc>
801060ab:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
  return myproc()->pid;
801060b2:	e8 f9 d8 ff ff       	call   801039b0 <myproc>
801060b7:	8b 40 10             	mov    0x10(%eax),%eax
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	53                   	push   %ebx
801060c4:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[11] ++;
801060c7:	e8 e4 d8 ff ff       	call   801039b0 <myproc>
801060cc:	83 80 a8 00 00 00 01 	addl   $0x1,0xa8(%eax)
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d6:	83 ec 08             	sub    $0x8,%esp
801060d9:	50                   	push   %eax
801060da:	6a 00                	push   $0x0
801060dc:	e8 5f f1 ff ff       	call   80105240 <argint>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	85 c0                	test   %eax,%eax
801060e6:	78 28                	js     80106110 <sys_sbrk+0x50>
    return -1;
  addr = myproc()->sz;
801060e8:	e8 c3 d8 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
801060ed:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801060f0:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801060f2:	ff 75 f4             	pushl  -0xc(%ebp)
801060f5:	e8 d6 d9 ff ff       	call   80103ad0 <growproc>
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	85 c0                	test   %eax,%eax
801060ff:	78 0f                	js     80106110 <sys_sbrk+0x50>
    return -1;
  return addr;
}
80106101:	89 d8                	mov    %ebx,%eax
80106103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106106:	c9                   	leave  
80106107:	c3                   	ret    
80106108:	90                   	nop
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106110:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106115:	eb ea                	jmp    80106101 <sys_sbrk+0x41>
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106120 <sys_sleep>:

int
sys_sleep(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	53                   	push   %ebx
80106124:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[12] ++;
80106127:	e8 84 d8 ff ff       	call   801039b0 <myproc>
8010612c:	83 80 ac 00 00 00 01 	addl   $0x1,0xac(%eax)
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106133:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106136:	83 ec 08             	sub    $0x8,%esp
80106139:	50                   	push   %eax
8010613a:	6a 00                	push   $0x0
8010613c:	e8 ff f0 ff ff       	call   80105240 <argint>
80106141:	83 c4 10             	add    $0x10,%esp
80106144:	85 c0                	test   %eax,%eax
80106146:	0f 88 8b 00 00 00    	js     801061d7 <sys_sleep+0xb7>
    return -1;
  acquire(&tickslock);
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	68 00 87 11 80       	push   $0x80118700
80106154:	e8 d7 ec ff ff       	call   80104e30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010615c:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010615f:	8b 1d 40 8f 11 80    	mov    0x80118f40,%ebx
  while(ticks - ticks0 < n){
80106165:	85 d2                	test   %edx,%edx
80106167:	75 28                	jne    80106191 <sys_sleep+0x71>
80106169:	eb 55                	jmp    801061c0 <sys_sleep+0xa0>
8010616b:	90                   	nop
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106170:	83 ec 08             	sub    $0x8,%esp
80106173:	68 00 87 11 80       	push   $0x80118700
80106178:	68 40 8f 11 80       	push   $0x80118f40
8010617d:	e8 4e e0 ff ff       	call   801041d0 <sleep>
  while(ticks - ticks0 < n){
80106182:	a1 40 8f 11 80       	mov    0x80118f40,%eax
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	29 d8                	sub    %ebx,%eax
8010618c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010618f:	73 2f                	jae    801061c0 <sys_sleep+0xa0>
    if(myproc()->killed){
80106191:	e8 1a d8 ff ff       	call   801039b0 <myproc>
80106196:	8b 40 24             	mov    0x24(%eax),%eax
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 d3                	je     80106170 <sys_sleep+0x50>
      release(&tickslock);
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	68 00 87 11 80       	push   $0x80118700
801061a5:	e8 46 ed ff ff       	call   80104ef0 <release>
      return -1;
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801061b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061b5:	c9                   	leave  
801061b6:	c3                   	ret    
801061b7:	89 f6                	mov    %esi,%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	68 00 87 11 80       	push   $0x80118700
801061c8:	e8 23 ed ff ff       	call   80104ef0 <release>
  return 0;
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	31 c0                	xor    %eax,%eax
}
801061d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
    return -1;
801061d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061dc:	eb f4                	jmp    801061d2 <sys_sleep+0xb2>
801061de:	66 90                	xchg   %ax,%ax

801061e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	53                   	push   %ebx
801061e4:	83 ec 04             	sub    $0x4,%esp
  myproc()->call_nums[13] ++;
801061e7:	e8 c4 d7 ff ff       	call   801039b0 <myproc>
801061ec:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
  uint xticks;

  acquire(&tickslock);
801061f3:	83 ec 0c             	sub    $0xc,%esp
801061f6:	68 00 87 11 80       	push   $0x80118700
801061fb:	e8 30 ec ff ff       	call   80104e30 <acquire>
  xticks = ticks;
80106200:	8b 1d 40 8f 11 80    	mov    0x80118f40,%ebx
  release(&tickslock);
80106206:	c7 04 24 00 87 11 80 	movl   $0x80118700,(%esp)
8010620d:	e8 de ec ff ff       	call   80104ef0 <release>
  return xticks;
}
80106212:	89 d8                	mov    %ebx,%eax
80106214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106217:	c9                   	leave  
80106218:	c3                   	ret    
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_trace_syscalls>:

int sys_trace_syscalls(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	53                   	push   %ebx
80106224:	83 ec 14             	sub    $0x14,%esp
  int n;
  myproc()->call_nums[21] ++;
80106227:	e8 84 d7 ff ff       	call   801039b0 <myproc>
8010622c:	83 80 d0 00 00 00 01 	addl   $0x1,0xd0(%eax)
  if(argint(0, &n) == 0){
80106233:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106236:	83 ec 08             	sub    $0x8,%esp
80106239:	50                   	push   %eax
8010623a:	6a 00                	push   $0x0
8010623c:	e8 ff ef ff ff       	call   80105240 <argint>
80106241:	83 c4 10             	add    $0x10,%esp
80106244:	85 c0                	test   %eax,%eax
80106246:	75 50                	jne    80106298 <sys_trace_syscalls+0x78>
80106248:	89 c3                	mov    %eax,%ebx
    if(myproc()->pid == 2){
8010624a:	e8 61 d7 ff ff       	call   801039b0 <myproc>
8010624f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106253:	74 2b                	je     80106280 <sys_trace_syscalls+0x60>
      trace_syscalls(2);
      return 0;
    }
    else if (n==1 || n== 0) {
80106255:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80106259:	77 3d                	ja     80106298 <sys_trace_syscalls+0x78>
      myproc()-> print_state = n;
8010625b:	e8 50 d7 ff ff       	call   801039b0 <myproc>
80106260:	8b 55 f4             	mov    -0xc(%ebp),%edx
      trace_syscalls(n);
80106263:	83 ec 0c             	sub    $0xc,%esp
      myproc()-> print_state = n;
80106266:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
      trace_syscalls(n);
8010626c:	52                   	push   %edx
8010626d:	e8 1e e5 ff ff       	call   80104790 <trace_syscalls>
      return 0;
80106272:	83 c4 10             	add    $0x10,%esp
    else
      return -1;
  }
  else
    return -1;
}
80106275:	89 d8                	mov    %ebx,%eax
80106277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010627a:	c9                   	leave  
8010627b:	c3                   	ret    
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      trace_syscalls(2);
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	6a 02                	push   $0x2
80106285:	e8 06 e5 ff ff       	call   80104790 <trace_syscalls>
}
8010628a:	89 d8                	mov    %ebx,%eax
      return 0;
8010628c:	83 c4 10             	add    $0x10,%esp
}
8010628f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106292:	c9                   	leave  
80106293:	c3                   	ret    
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106298:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010629d:	eb d6                	jmp    80106275 <sys_trace_syscalls+0x55>
8010629f:	90                   	nop

801062a0 <sys_reverse_number>:

int sys_reverse_number(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[22] ++;
801062a6:	e8 05 d7 ff ff       	call   801039b0 <myproc>
801062ab:	83 80 d4 00 00 00 01 	addl   $0x1,0xd4(%eax)
  int n;
  asm("movl %%edi, %0;" : "=r"(n)); 
  reverse_number(n);
801062b2:	83 ec 0c             	sub    $0xc,%esp
  asm("movl %%edi, %0;" : "=r"(n)); 
801062b5:	89 f8                	mov    %edi,%eax
  reverse_number(n);
801062b7:	50                   	push   %eax
801062b8:	e8 93 e5 ff ff       	call   80104850 <reverse_number>

  return 0;
}
801062bd:	31 c0                	xor    %eax,%eax
801062bf:	c9                   	leave  
801062c0:	c3                   	ret    
801062c1:	eb 0d                	jmp    801062d0 <sys_get_children>
801062c3:	90                   	nop
801062c4:	90                   	nop
801062c5:	90                   	nop
801062c6:	90                   	nop
801062c7:	90                   	nop
801062c8:	90                   	nop
801062c9:	90                   	nop
801062ca:	90                   	nop
801062cb:	90                   	nop
801062cc:	90                   	nop
801062cd:	90                   	nop
801062ce:	90                   	nop
801062cf:	90                   	nop

801062d0 <sys_get_children>:

int
sys_get_children(void){
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[23] ++;
801062d6:	e8 d5 d6 ff ff       	call   801039b0 <myproc>
801062db:	83 80 d8 00 00 00 01 	addl   $0x1,0xd8(%eax)
  int pid;
  if(argint(0, &pid) < 0)
801062e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062e5:	83 ec 08             	sub    $0x8,%esp
801062e8:	50                   	push   %eax
801062e9:	6a 00                	push   $0x0
801062eb:	e8 50 ef ff ff       	call   80105240 <argint>
801062f0:	83 c4 10             	add    $0x10,%esp
801062f3:	85 c0                	test   %eax,%eax
801062f5:	78 19                	js     80106310 <sys_get_children+0x40>
    return -1;
  return children(pid);
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	ff 75 f4             	pushl  -0xc(%ebp)
801062fd:	e8 fe e5 ff ff       	call   80104900 <children>
80106302:	83 c4 10             	add    $0x10,%esp
}
80106305:	c9                   	leave  
80106306:	c3                   	ret    
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106315:	c9                   	leave  
80106316:	c3                   	ret    
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106320 <sys_change_process_queue>:

int sys_change_process_queue(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[24] ++;
80106326:	e8 85 d6 ff ff       	call   801039b0 <myproc>
8010632b:	83 80 dc 00 00 00 01 	addl   $0x1,0xdc(%eax)
  int pid, dest_queue;

  if(argint(0, &pid) < 0)
80106332:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106335:	83 ec 08             	sub    $0x8,%esp
80106338:	50                   	push   %eax
80106339:	6a 00                	push   $0x0
8010633b:	e8 00 ef ff ff       	call   80105240 <argint>
80106340:	83 c4 10             	add    $0x10,%esp
80106343:	85 c0                	test   %eax,%eax
80106345:	78 31                	js     80106378 <sys_change_process_queue+0x58>
    return -1;
  if(argint(1, &dest_queue) < 0)
80106347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010634a:	83 ec 08             	sub    $0x8,%esp
8010634d:	50                   	push   %eax
8010634e:	6a 01                	push   $0x1
80106350:	e8 eb ee ff ff       	call   80105240 <argint>
80106355:	83 c4 10             	add    $0x10,%esp
80106358:	85 c0                	test   %eax,%eax
8010635a:	78 1c                	js     80106378 <sys_change_process_queue+0x58>
    return -1;

  change_process_queue(pid, dest_queue);
8010635c:	83 ec 08             	sub    $0x8,%esp
8010635f:	ff 75 f4             	pushl  -0xc(%ebp)
80106362:	ff 75 f0             	pushl  -0x10(%ebp)
80106365:	e8 86 e6 ff ff       	call   801049f0 <change_process_queue>
  return 0;
8010636a:	83 c4 10             	add    $0x10,%esp
8010636d:	31 c0                	xor    %eax,%eax
}
8010636f:	c9                   	leave  
80106370:	c3                   	ret    
80106371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637d:	c9                   	leave  
8010637e:	c3                   	ret    
8010637f:	90                   	nop

80106380 <sys_quantify_lottery_tickets>:

int sys_quantify_lottery_tickets(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[25] ++;
80106386:	e8 25 d6 ff ff       	call   801039b0 <myproc>
8010638b:	83 80 e0 00 00 00 01 	addl   $0x1,0xe0(%eax)
  int pid, ticket;

  if(argint(0, &pid) < 0)
80106392:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106395:	83 ec 08             	sub    $0x8,%esp
80106398:	50                   	push   %eax
80106399:	6a 00                	push   $0x0
8010639b:	e8 a0 ee ff ff       	call   80105240 <argint>
801063a0:	83 c4 10             	add    $0x10,%esp
801063a3:	85 c0                	test   %eax,%eax
801063a5:	78 31                	js     801063d8 <sys_quantify_lottery_tickets+0x58>
    return -1;
  if(argint(1, &ticket) < 0)
801063a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063aa:	83 ec 08             	sub    $0x8,%esp
801063ad:	50                   	push   %eax
801063ae:	6a 01                	push   $0x1
801063b0:	e8 8b ee ff ff       	call   80105240 <argint>
801063b5:	83 c4 10             	add    $0x10,%esp
801063b8:	85 c0                	test   %eax,%eax
801063ba:	78 1c                	js     801063d8 <sys_quantify_lottery_tickets+0x58>
    return -1;

  quantify_lottery_tickets(pid, ticket);
801063bc:	83 ec 08             	sub    $0x8,%esp
801063bf:	ff 75 f4             	pushl  -0xc(%ebp)
801063c2:	ff 75 f0             	pushl  -0x10(%ebp)
801063c5:	e8 56 e6 ff ff       	call   80104a20 <quantify_lottery_tickets>
  return 0;
801063ca:	83 c4 10             	add    $0x10,%esp
801063cd:	31 c0                	xor    %eax,%eax
}
801063cf:	c9                   	leave  
801063d0:	c3                   	ret    
801063d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063dd:	c9                   	leave  
801063de:	c3                   	ret    
801063df:	90                   	nop

801063e0 <sys_quantify_BJF_parameters_process_level>:

int sys_quantify_BJF_parameters_process_level(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[26] ++;
801063e6:	e8 c5 d5 ff ff       	call   801039b0 <myproc>
801063eb:	83 80 e4 00 00 00 01 	addl   $0x1,0xe4(%eax)
  int pid, priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &pid) < 0)
801063f2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063f5:	83 ec 08             	sub    $0x8,%esp
801063f8:	50                   	push   %eax
801063f9:	6a 00                	push   $0x0
801063fb:	e8 40 ee ff ff       	call   80105240 <argint>
80106400:	83 c4 10             	add    $0x10,%esp
80106403:	85 c0                	test   %eax,%eax
80106405:	78 59                	js     80106460 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(0, &priority_ratio) < 0)
80106407:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010640a:	83 ec 08             	sub    $0x8,%esp
8010640d:	50                   	push   %eax
8010640e:	6a 00                	push   $0x0
80106410:	e8 2b ee ff ff       	call   80105240 <argint>
80106415:	83 c4 10             	add    $0x10,%esp
80106418:	85 c0                	test   %eax,%eax
8010641a:	78 44                	js     80106460 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
8010641c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010641f:	83 ec 08             	sub    $0x8,%esp
80106422:	50                   	push   %eax
80106423:	6a 01                	push   $0x1
80106425:	e8 16 ee ff ff       	call   80105240 <argint>
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	85 c0                	test   %eax,%eax
8010642f:	78 2f                	js     80106460 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &exect_ratio) < 0)
80106431:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106434:	83 ec 08             	sub    $0x8,%esp
80106437:	50                   	push   %eax
80106438:	6a 01                	push   $0x1
8010643a:	e8 01 ee ff ff       	call   80105240 <argint>
8010643f:	83 c4 10             	add    $0x10,%esp
80106442:	85 c0                	test   %eax,%eax
80106444:	78 1a                	js     80106460 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;

  quantify_BJF_parameters_process_level(pid, priority_ratio, arrivt_ratio, exect_ratio);
80106446:	ff 75 f4             	pushl  -0xc(%ebp)
80106449:	ff 75 f0             	pushl  -0x10(%ebp)
8010644c:	ff 75 ec             	pushl  -0x14(%ebp)
8010644f:	ff 75 e8             	pushl  -0x18(%ebp)
80106452:	e8 f9 e5 ff ff       	call   80104a50 <quantify_BJF_parameters_process_level>
  return 0;
80106457:	83 c4 10             	add    $0x10,%esp
8010645a:	31 c0                	xor    %eax,%eax
}
8010645c:	c9                   	leave  
8010645d:	c3                   	ret    
8010645e:	66 90                	xchg   %ax,%ax
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	c9                   	leave  
80106466:	c3                   	ret    
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106470 <sys_quantify_BJF_parameters_kernel_level>:

int sys_quantify_BJF_parameters_kernel_level(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[27] ++;
80106476:	e8 35 d5 ff ff       	call   801039b0 <myproc>
8010647b:	83 80 e8 00 00 00 01 	addl   $0x1,0xe8(%eax)
  int priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &priority_ratio) < 0)
80106482:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106485:	83 ec 08             	sub    $0x8,%esp
80106488:	50                   	push   %eax
80106489:	6a 00                	push   $0x0
8010648b:	e8 b0 ed ff ff       	call   80105240 <argint>
80106490:	83 c4 10             	add    $0x10,%esp
80106493:	85 c0                	test   %eax,%eax
80106495:	78 49                	js     801064e0 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
80106497:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010649a:	83 ec 08             	sub    $0x8,%esp
8010649d:	50                   	push   %eax
8010649e:	6a 01                	push   $0x1
801064a0:	e8 9b ed ff ff       	call   80105240 <argint>
801064a5:	83 c4 10             	add    $0x10,%esp
801064a8:	85 c0                	test   %eax,%eax
801064aa:	78 34                	js     801064e0 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &exect_ratio) < 0)
801064ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064af:	83 ec 08             	sub    $0x8,%esp
801064b2:	50                   	push   %eax
801064b3:	6a 01                	push   $0x1
801064b5:	e8 86 ed ff ff       	call   80105240 <argint>
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	85 c0                	test   %eax,%eax
801064bf:	78 1f                	js     801064e0 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;

  quantify_BJF_parameters_kernel_level(priority_ratio, arrivt_ratio, exect_ratio);
801064c1:	83 ec 04             	sub    $0x4,%esp
801064c4:	ff 75 f4             	pushl  -0xc(%ebp)
801064c7:	ff 75 f0             	pushl  -0x10(%ebp)
801064ca:	ff 75 ec             	pushl  -0x14(%ebp)
801064cd:	e8 ce e5 ff ff       	call   80104aa0 <quantify_BJF_parameters_kernel_level>
  return 0;
801064d2:	83 c4 10             	add    $0x10,%esp
801064d5:	31 c0                	xor    %eax,%eax
}
801064d7:	c9                   	leave  
801064d8:	c3                   	ret    
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064f0 <sys_print_information>:

int sys_print_information(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[28] ++;
801064f6:	e8 b5 d4 ff ff       	call   801039b0 <myproc>
801064fb:	83 80 ec 00 00 00 01 	addl   $0x1,0xec(%eax)
  print_information();
80106502:	e8 f9 e5 ff ff       	call   80104b00 <print_information>
  return 0;
80106507:	31 c0                	xor    %eax,%eax
80106509:	c9                   	leave  
8010650a:	c3                   	ret    

8010650b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010650b:	1e                   	push   %ds
  pushl %es
8010650c:	06                   	push   %es
  pushl %fs
8010650d:	0f a0                	push   %fs
  pushl %gs
8010650f:	0f a8                	push   %gs
  pushal
80106511:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106512:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106516:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106518:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010651a:	54                   	push   %esp
  call trap
8010651b:	e8 c0 00 00 00       	call   801065e0 <trap>
  addl $4, %esp
80106520:	83 c4 04             	add    $0x4,%esp

80106523 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106523:	61                   	popa   
  popl %gs
80106524:	0f a9                	pop    %gs
  popl %fs
80106526:	0f a1                	pop    %fs
  popl %es
80106528:	07                   	pop    %es
  popl %ds
80106529:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010652a:	83 c4 08             	add    $0x8,%esp
  iret
8010652d:	cf                   	iret   
8010652e:	66 90                	xchg   %ax,%ax

80106530 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106530:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106531:	31 c0                	xor    %eax,%eax
{
80106533:	89 e5                	mov    %esp,%ebp
80106535:	83 ec 08             	sub    $0x8,%esp
80106538:	90                   	nop
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106540:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106547:	c7 04 c5 42 87 11 80 	movl   $0x8e000008,-0x7fee78be(,%eax,8)
8010654e:	08 00 00 8e 
80106552:	66 89 14 c5 40 87 11 	mov    %dx,-0x7fee78c0(,%eax,8)
80106559:	80 
8010655a:	c1 ea 10             	shr    $0x10,%edx
8010655d:	66 89 14 c5 46 87 11 	mov    %dx,-0x7fee78ba(,%eax,8)
80106564:	80 
  for(i = 0; i < 256; i++)
80106565:	83 c0 01             	add    $0x1,%eax
80106568:	3d 00 01 00 00       	cmp    $0x100,%eax
8010656d:	75 d1                	jne    80106540 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010656f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106574:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106577:	c7 05 42 89 11 80 08 	movl   $0xef000008,0x80118942
8010657e:	00 00 ef 
  initlock(&tickslock, "time");
80106581:	68 f4 83 10 80       	push   $0x801083f4
80106586:	68 00 87 11 80       	push   $0x80118700
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010658b:	66 a3 40 89 11 80    	mov    %ax,0x80118940
80106591:	c1 e8 10             	shr    $0x10,%eax
80106594:	66 a3 46 89 11 80    	mov    %ax,0x80118946
  initlock(&tickslock, "time");
8010659a:	e8 51 e7 ff ff       	call   80104cf0 <initlock>
}
8010659f:	83 c4 10             	add    $0x10,%esp
801065a2:	c9                   	leave  
801065a3:	c3                   	ret    
801065a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801065b0 <idtinit>:

void
idtinit(void)
{
801065b0:	55                   	push   %ebp
  pd[0] = size-1;
801065b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065b6:	89 e5                	mov    %esp,%ebp
801065b8:	83 ec 10             	sub    $0x10,%esp
801065bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065bf:	b8 40 87 11 80       	mov    $0x80118740,%eax
801065c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065c8:	c1 e8 10             	shr    $0x10,%eax
801065cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065d5:	c9                   	leave  
801065d6:	c3                   	ret    
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
801065e6:	83 ec 1c             	sub    $0x1c,%esp
801065e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801065ec:	8b 47 30             	mov    0x30(%edi),%eax
801065ef:	83 f8 40             	cmp    $0x40,%eax
801065f2:	0f 84 f0 00 00 00    	je     801066e8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801065f8:	83 e8 20             	sub    $0x20,%eax
801065fb:	83 f8 1f             	cmp    $0x1f,%eax
801065fe:	77 10                	ja     80106610 <trap+0x30>
80106600:	ff 24 85 5c 88 10 80 	jmp    *-0x7fef77a4(,%eax,4)
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106610:	e8 9b d3 ff ff       	call   801039b0 <myproc>
80106615:	85 c0                	test   %eax,%eax
80106617:	8b 5f 38             	mov    0x38(%edi),%ebx
8010661a:	0f 84 14 02 00 00    	je     80106834 <trap+0x254>
80106620:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106624:	0f 84 0a 02 00 00    	je     80106834 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010662a:	0f 20 d1             	mov    %cr2,%ecx
8010662d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106630:	e8 5b d3 ff ff       	call   80103990 <cpuid>
80106635:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106638:	8b 47 34             	mov    0x34(%edi),%eax
8010663b:	8b 77 30             	mov    0x30(%edi),%esi
8010663e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106641:	e8 6a d3 ff ff       	call   801039b0 <myproc>
80106646:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106649:	e8 62 d3 ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010664e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106651:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106654:	51                   	push   %ecx
80106655:	53                   	push   %ebx
80106656:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106657:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010665a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010665d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010665e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106661:	52                   	push   %edx
80106662:	ff 70 10             	pushl  0x10(%eax)
80106665:	68 18 88 10 80       	push   $0x80108818
8010666a:	e8 f1 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010666f:	83 c4 20             	add    $0x20,%esp
80106672:	e8 39 d3 ff ff       	call   801039b0 <myproc>
80106677:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010667e:	e8 2d d3 ff ff       	call   801039b0 <myproc>
80106683:	85 c0                	test   %eax,%eax
80106685:	74 1d                	je     801066a4 <trap+0xc4>
80106687:	e8 24 d3 ff ff       	call   801039b0 <myproc>
8010668c:	8b 50 24             	mov    0x24(%eax),%edx
8010668f:	85 d2                	test   %edx,%edx
80106691:	74 11                	je     801066a4 <trap+0xc4>
80106693:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106697:	83 e0 03             	and    $0x3,%eax
8010669a:	66 83 f8 03          	cmp    $0x3,%ax
8010669e:	0f 84 4c 01 00 00    	je     801067f0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066a4:	e8 07 d3 ff ff       	call   801039b0 <myproc>
801066a9:	85 c0                	test   %eax,%eax
801066ab:	74 0b                	je     801066b8 <trap+0xd8>
801066ad:	e8 fe d2 ff ff       	call   801039b0 <myproc>
801066b2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801066b6:	74 68                	je     80106720 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066b8:	e8 f3 d2 ff ff       	call   801039b0 <myproc>
801066bd:	85 c0                	test   %eax,%eax
801066bf:	74 19                	je     801066da <trap+0xfa>
801066c1:	e8 ea d2 ff ff       	call   801039b0 <myproc>
801066c6:	8b 40 24             	mov    0x24(%eax),%eax
801066c9:	85 c0                	test   %eax,%eax
801066cb:	74 0d                	je     801066da <trap+0xfa>
801066cd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066d1:	83 e0 03             	and    $0x3,%eax
801066d4:	66 83 f8 03          	cmp    $0x3,%ax
801066d8:	74 37                	je     80106711 <trap+0x131>
    exit();
}
801066da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066dd:	5b                   	pop    %ebx
801066de:	5e                   	pop    %esi
801066df:	5f                   	pop    %edi
801066e0:	5d                   	pop    %ebp
801066e1:	c3                   	ret    
801066e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801066e8:	e8 c3 d2 ff ff       	call   801039b0 <myproc>
801066ed:	8b 58 24             	mov    0x24(%eax),%ebx
801066f0:	85 db                	test   %ebx,%ebx
801066f2:	0f 85 e8 00 00 00    	jne    801067e0 <trap+0x200>
    myproc()->tf = tf;
801066f8:	e8 b3 d2 ff ff       	call   801039b0 <myproc>
801066fd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106700:	e8 2b ec ff ff       	call   80105330 <syscall>
    if(myproc()->killed)
80106705:	e8 a6 d2 ff ff       	call   801039b0 <myproc>
8010670a:	8b 48 24             	mov    0x24(%eax),%ecx
8010670d:	85 c9                	test   %ecx,%ecx
8010670f:	74 c9                	je     801066da <trap+0xfa>
}
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	5b                   	pop    %ebx
80106715:	5e                   	pop    %esi
80106716:	5f                   	pop    %edi
80106717:	5d                   	pop    %ebp
      exit();
80106718:	e9 33 d9 ff ff       	jmp    80104050 <exit>
8010671d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106720:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106724:	75 92                	jne    801066b8 <trap+0xd8>
    yield();
80106726:	e8 55 da ff ff       	call   80104180 <yield>
8010672b:	eb 8b                	jmp    801066b8 <trap+0xd8>
8010672d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106730:	e8 5b d2 ff ff       	call   80103990 <cpuid>
80106735:	85 c0                	test   %eax,%eax
80106737:	0f 84 c3 00 00 00    	je     80106800 <trap+0x220>
    lapiceoi();
8010673d:	e8 de c1 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106742:	e8 69 d2 ff ff       	call   801039b0 <myproc>
80106747:	85 c0                	test   %eax,%eax
80106749:	0f 85 38 ff ff ff    	jne    80106687 <trap+0xa7>
8010674f:	e9 50 ff ff ff       	jmp    801066a4 <trap+0xc4>
80106754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106758:	e8 83 c0 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
8010675d:	e8 be c1 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106762:	e8 49 d2 ff ff       	call   801039b0 <myproc>
80106767:	85 c0                	test   %eax,%eax
80106769:	0f 85 18 ff ff ff    	jne    80106687 <trap+0xa7>
8010676f:	e9 30 ff ff ff       	jmp    801066a4 <trap+0xc4>
80106774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106778:	e8 53 02 00 00       	call   801069d0 <uartintr>
    lapiceoi();
8010677d:	e8 9e c1 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106782:	e8 29 d2 ff ff       	call   801039b0 <myproc>
80106787:	85 c0                	test   %eax,%eax
80106789:	0f 85 f8 fe ff ff    	jne    80106687 <trap+0xa7>
8010678f:	e9 10 ff ff ff       	jmp    801066a4 <trap+0xc4>
80106794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106798:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010679c:	8b 77 38             	mov    0x38(%edi),%esi
8010679f:	e8 ec d1 ff ff       	call   80103990 <cpuid>
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	50                   	push   %eax
801067a7:	68 c0 87 10 80       	push   $0x801087c0
801067ac:	e8 af 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
801067b1:	e8 6a c1 ff ff       	call   80102920 <lapiceoi>
    break;
801067b6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067b9:	e8 f2 d1 ff ff       	call   801039b0 <myproc>
801067be:	85 c0                	test   %eax,%eax
801067c0:	0f 85 c1 fe ff ff    	jne    80106687 <trap+0xa7>
801067c6:	e9 d9 fe ff ff       	jmp    801066a4 <trap+0xc4>
801067cb:	90                   	nop
801067cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801067d0:	e8 7b ba ff ff       	call   80102250 <ideintr>
801067d5:	e9 63 ff ff ff       	jmp    8010673d <trap+0x15d>
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801067e0:	e8 6b d8 ff ff       	call   80104050 <exit>
801067e5:	e9 0e ff ff ff       	jmp    801066f8 <trap+0x118>
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801067f0:	e8 5b d8 ff ff       	call   80104050 <exit>
801067f5:	e9 aa fe ff ff       	jmp    801066a4 <trap+0xc4>
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106800:	83 ec 0c             	sub    $0xc,%esp
80106803:	68 00 87 11 80       	push   $0x80118700
80106808:	e8 23 e6 ff ff       	call   80104e30 <acquire>
      wakeup(&ticks);
8010680d:	c7 04 24 40 8f 11 80 	movl   $0x80118f40,(%esp)
      ticks++;
80106814:	83 05 40 8f 11 80 01 	addl   $0x1,0x80118f40
      wakeup(&ticks);
8010681b:	e8 70 db ff ff       	call   80104390 <wakeup>
      release(&tickslock);
80106820:	c7 04 24 00 87 11 80 	movl   $0x80118700,(%esp)
80106827:	e8 c4 e6 ff ff       	call   80104ef0 <release>
8010682c:	83 c4 10             	add    $0x10,%esp
8010682f:	e9 09 ff ff ff       	jmp    8010673d <trap+0x15d>
80106834:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106837:	e8 54 d1 ff ff       	call   80103990 <cpuid>
8010683c:	83 ec 0c             	sub    $0xc,%esp
8010683f:	56                   	push   %esi
80106840:	53                   	push   %ebx
80106841:	50                   	push   %eax
80106842:	ff 77 30             	pushl  0x30(%edi)
80106845:	68 e4 87 10 80       	push   $0x801087e4
8010684a:	e8 11 9e ff ff       	call   80100660 <cprintf>
      panic("trap");
8010684f:	83 c4 14             	add    $0x14,%esp
80106852:	68 b9 87 10 80       	push   $0x801087b9
80106857:	e8 34 9b ff ff       	call   80100390 <panic>
8010685c:	66 90                	xchg   %ax,%ax
8010685e:	66 90                	xchg   %ax,%ax

80106860 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106860:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106865:	55                   	push   %ebp
80106866:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106868:	85 c0                	test   %eax,%eax
8010686a:	74 1c                	je     80106888 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010686c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106871:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106872:	a8 01                	test   $0x1,%al
80106874:	74 12                	je     80106888 <uartgetc+0x28>
80106876:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010687b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010687c:	0f b6 c0             	movzbl %al,%eax
}
8010687f:	5d                   	pop    %ebp
80106880:	c3                   	ret    
80106881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010688d:	5d                   	pop    %ebp
8010688e:	c3                   	ret    
8010688f:	90                   	nop

80106890 <uartputc.part.0>:
uartputc(int c)
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	89 c7                	mov    %eax,%edi
80106898:	bb 80 00 00 00       	mov    $0x80,%ebx
8010689d:	be fd 03 00 00       	mov    $0x3fd,%esi
801068a2:	83 ec 0c             	sub    $0xc,%esp
801068a5:	eb 1b                	jmp    801068c2 <uartputc.part.0+0x32>
801068a7:	89 f6                	mov    %esi,%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801068b0:	83 ec 0c             	sub    $0xc,%esp
801068b3:	6a 0a                	push   $0xa
801068b5:	e8 86 c0 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068ba:	83 c4 10             	add    $0x10,%esp
801068bd:	83 eb 01             	sub    $0x1,%ebx
801068c0:	74 07                	je     801068c9 <uartputc.part.0+0x39>
801068c2:	89 f2                	mov    %esi,%edx
801068c4:	ec                   	in     (%dx),%al
801068c5:	a8 20                	test   $0x20,%al
801068c7:	74 e7                	je     801068b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068ce:	89 f8                	mov    %edi,%eax
801068d0:	ee                   	out    %al,(%dx)
}
801068d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068d4:	5b                   	pop    %ebx
801068d5:	5e                   	pop    %esi
801068d6:	5f                   	pop    %edi
801068d7:	5d                   	pop    %ebp
801068d8:	c3                   	ret    
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068e0 <uartinit>:
{
801068e0:	55                   	push   %ebp
801068e1:	31 c9                	xor    %ecx,%ecx
801068e3:	89 c8                	mov    %ecx,%eax
801068e5:	89 e5                	mov    %esp,%ebp
801068e7:	57                   	push   %edi
801068e8:	56                   	push   %esi
801068e9:	53                   	push   %ebx
801068ea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801068ef:	89 da                	mov    %ebx,%edx
801068f1:	83 ec 0c             	sub    $0xc,%esp
801068f4:	ee                   	out    %al,(%dx)
801068f5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801068fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801068ff:	89 fa                	mov    %edi,%edx
80106901:	ee                   	out    %al,(%dx)
80106902:	b8 0c 00 00 00       	mov    $0xc,%eax
80106907:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010690c:	ee                   	out    %al,(%dx)
8010690d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106912:	89 c8                	mov    %ecx,%eax
80106914:	89 f2                	mov    %esi,%edx
80106916:	ee                   	out    %al,(%dx)
80106917:	b8 03 00 00 00       	mov    $0x3,%eax
8010691c:	89 fa                	mov    %edi,%edx
8010691e:	ee                   	out    %al,(%dx)
8010691f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106924:	89 c8                	mov    %ecx,%eax
80106926:	ee                   	out    %al,(%dx)
80106927:	b8 01 00 00 00       	mov    $0x1,%eax
8010692c:	89 f2                	mov    %esi,%edx
8010692e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010692f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106934:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106935:	3c ff                	cmp    $0xff,%al
80106937:	74 5a                	je     80106993 <uartinit+0xb3>
  uart = 1;
80106939:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106940:	00 00 00 
80106943:	89 da                	mov    %ebx,%edx
80106945:	ec                   	in     (%dx),%al
80106946:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010694b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010694c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010694f:	bb dc 88 10 80       	mov    $0x801088dc,%ebx
  ioapicenable(IRQ_COM1, 0);
80106954:	6a 00                	push   $0x0
80106956:	6a 04                	push   $0x4
80106958:	e8 43 bb ff ff       	call   801024a0 <ioapicenable>
8010695d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106960:	b8 78 00 00 00       	mov    $0x78,%eax
80106965:	eb 13                	jmp    8010697a <uartinit+0x9a>
80106967:	89 f6                	mov    %esi,%esi
80106969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106970:	83 c3 01             	add    $0x1,%ebx
80106973:	0f be 03             	movsbl (%ebx),%eax
80106976:	84 c0                	test   %al,%al
80106978:	74 19                	je     80106993 <uartinit+0xb3>
  if(!uart)
8010697a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106980:	85 d2                	test   %edx,%edx
80106982:	74 ec                	je     80106970 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106984:	83 c3 01             	add    $0x1,%ebx
80106987:	e8 04 ff ff ff       	call   80106890 <uartputc.part.0>
8010698c:	0f be 03             	movsbl (%ebx),%eax
8010698f:	84 c0                	test   %al,%al
80106991:	75 e7                	jne    8010697a <uartinit+0x9a>
}
80106993:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106996:	5b                   	pop    %ebx
80106997:	5e                   	pop    %esi
80106998:	5f                   	pop    %edi
80106999:	5d                   	pop    %ebp
8010699a:	c3                   	ret    
8010699b:	90                   	nop
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069a0 <uartputc>:
  if(!uart)
801069a0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801069a6:	55                   	push   %ebp
801069a7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069a9:	85 d2                	test   %edx,%edx
{
801069ab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069ae:	74 10                	je     801069c0 <uartputc+0x20>
}
801069b0:	5d                   	pop    %ebp
801069b1:	e9 da fe ff ff       	jmp    80106890 <uartputc.part.0>
801069b6:	8d 76 00             	lea    0x0(%esi),%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069c0:	5d                   	pop    %ebp
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <uartintr>:

void
uartintr(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801069d6:	68 60 68 10 80       	push   $0x80106860
801069db:	e8 30 9e ff ff       	call   80100810 <consoleintr>
}
801069e0:	83 c4 10             	add    $0x10,%esp
801069e3:	c9                   	leave  
801069e4:	c3                   	ret    

801069e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $0
801069e7:	6a 00                	push   $0x0
  jmp alltraps
801069e9:	e9 1d fb ff ff       	jmp    8010650b <alltraps>

801069ee <vector1>:
.globl vector1
vector1:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $1
801069f0:	6a 01                	push   $0x1
  jmp alltraps
801069f2:	e9 14 fb ff ff       	jmp    8010650b <alltraps>

801069f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $2
801069f9:	6a 02                	push   $0x2
  jmp alltraps
801069fb:	e9 0b fb ff ff       	jmp    8010650b <alltraps>

80106a00 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $3
80106a02:	6a 03                	push   $0x3
  jmp alltraps
80106a04:	e9 02 fb ff ff       	jmp    8010650b <alltraps>

80106a09 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $4
80106a0b:	6a 04                	push   $0x4
  jmp alltraps
80106a0d:	e9 f9 fa ff ff       	jmp    8010650b <alltraps>

80106a12 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $5
80106a14:	6a 05                	push   $0x5
  jmp alltraps
80106a16:	e9 f0 fa ff ff       	jmp    8010650b <alltraps>

80106a1b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $6
80106a1d:	6a 06                	push   $0x6
  jmp alltraps
80106a1f:	e9 e7 fa ff ff       	jmp    8010650b <alltraps>

80106a24 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $7
80106a26:	6a 07                	push   $0x7
  jmp alltraps
80106a28:	e9 de fa ff ff       	jmp    8010650b <alltraps>

80106a2d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a2d:	6a 08                	push   $0x8
  jmp alltraps
80106a2f:	e9 d7 fa ff ff       	jmp    8010650b <alltraps>

80106a34 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $9
80106a36:	6a 09                	push   $0x9
  jmp alltraps
80106a38:	e9 ce fa ff ff       	jmp    8010650b <alltraps>

80106a3d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a3d:	6a 0a                	push   $0xa
  jmp alltraps
80106a3f:	e9 c7 fa ff ff       	jmp    8010650b <alltraps>

80106a44 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a44:	6a 0b                	push   $0xb
  jmp alltraps
80106a46:	e9 c0 fa ff ff       	jmp    8010650b <alltraps>

80106a4b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a4b:	6a 0c                	push   $0xc
  jmp alltraps
80106a4d:	e9 b9 fa ff ff       	jmp    8010650b <alltraps>

80106a52 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a52:	6a 0d                	push   $0xd
  jmp alltraps
80106a54:	e9 b2 fa ff ff       	jmp    8010650b <alltraps>

80106a59 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a59:	6a 0e                	push   $0xe
  jmp alltraps
80106a5b:	e9 ab fa ff ff       	jmp    8010650b <alltraps>

80106a60 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $15
80106a62:	6a 0f                	push   $0xf
  jmp alltraps
80106a64:	e9 a2 fa ff ff       	jmp    8010650b <alltraps>

80106a69 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $16
80106a6b:	6a 10                	push   $0x10
  jmp alltraps
80106a6d:	e9 99 fa ff ff       	jmp    8010650b <alltraps>

80106a72 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a72:	6a 11                	push   $0x11
  jmp alltraps
80106a74:	e9 92 fa ff ff       	jmp    8010650b <alltraps>

80106a79 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $18
80106a7b:	6a 12                	push   $0x12
  jmp alltraps
80106a7d:	e9 89 fa ff ff       	jmp    8010650b <alltraps>

80106a82 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $19
80106a84:	6a 13                	push   $0x13
  jmp alltraps
80106a86:	e9 80 fa ff ff       	jmp    8010650b <alltraps>

80106a8b <vector20>:
.globl vector20
vector20:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $20
80106a8d:	6a 14                	push   $0x14
  jmp alltraps
80106a8f:	e9 77 fa ff ff       	jmp    8010650b <alltraps>

80106a94 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $21
80106a96:	6a 15                	push   $0x15
  jmp alltraps
80106a98:	e9 6e fa ff ff       	jmp    8010650b <alltraps>

80106a9d <vector22>:
.globl vector22
vector22:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $22
80106a9f:	6a 16                	push   $0x16
  jmp alltraps
80106aa1:	e9 65 fa ff ff       	jmp    8010650b <alltraps>

80106aa6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $23
80106aa8:	6a 17                	push   $0x17
  jmp alltraps
80106aaa:	e9 5c fa ff ff       	jmp    8010650b <alltraps>

80106aaf <vector24>:
.globl vector24
vector24:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $24
80106ab1:	6a 18                	push   $0x18
  jmp alltraps
80106ab3:	e9 53 fa ff ff       	jmp    8010650b <alltraps>

80106ab8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $25
80106aba:	6a 19                	push   $0x19
  jmp alltraps
80106abc:	e9 4a fa ff ff       	jmp    8010650b <alltraps>

80106ac1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $26
80106ac3:	6a 1a                	push   $0x1a
  jmp alltraps
80106ac5:	e9 41 fa ff ff       	jmp    8010650b <alltraps>

80106aca <vector27>:
.globl vector27
vector27:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $27
80106acc:	6a 1b                	push   $0x1b
  jmp alltraps
80106ace:	e9 38 fa ff ff       	jmp    8010650b <alltraps>

80106ad3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $28
80106ad5:	6a 1c                	push   $0x1c
  jmp alltraps
80106ad7:	e9 2f fa ff ff       	jmp    8010650b <alltraps>

80106adc <vector29>:
.globl vector29
vector29:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $29
80106ade:	6a 1d                	push   $0x1d
  jmp alltraps
80106ae0:	e9 26 fa ff ff       	jmp    8010650b <alltraps>

80106ae5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $30
80106ae7:	6a 1e                	push   $0x1e
  jmp alltraps
80106ae9:	e9 1d fa ff ff       	jmp    8010650b <alltraps>

80106aee <vector31>:
.globl vector31
vector31:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $31
80106af0:	6a 1f                	push   $0x1f
  jmp alltraps
80106af2:	e9 14 fa ff ff       	jmp    8010650b <alltraps>

80106af7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $32
80106af9:	6a 20                	push   $0x20
  jmp alltraps
80106afb:	e9 0b fa ff ff       	jmp    8010650b <alltraps>

80106b00 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $33
80106b02:	6a 21                	push   $0x21
  jmp alltraps
80106b04:	e9 02 fa ff ff       	jmp    8010650b <alltraps>

80106b09 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $34
80106b0b:	6a 22                	push   $0x22
  jmp alltraps
80106b0d:	e9 f9 f9 ff ff       	jmp    8010650b <alltraps>

80106b12 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $35
80106b14:	6a 23                	push   $0x23
  jmp alltraps
80106b16:	e9 f0 f9 ff ff       	jmp    8010650b <alltraps>

80106b1b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $36
80106b1d:	6a 24                	push   $0x24
  jmp alltraps
80106b1f:	e9 e7 f9 ff ff       	jmp    8010650b <alltraps>

80106b24 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $37
80106b26:	6a 25                	push   $0x25
  jmp alltraps
80106b28:	e9 de f9 ff ff       	jmp    8010650b <alltraps>

80106b2d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $38
80106b2f:	6a 26                	push   $0x26
  jmp alltraps
80106b31:	e9 d5 f9 ff ff       	jmp    8010650b <alltraps>

80106b36 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $39
80106b38:	6a 27                	push   $0x27
  jmp alltraps
80106b3a:	e9 cc f9 ff ff       	jmp    8010650b <alltraps>

80106b3f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $40
80106b41:	6a 28                	push   $0x28
  jmp alltraps
80106b43:	e9 c3 f9 ff ff       	jmp    8010650b <alltraps>

80106b48 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $41
80106b4a:	6a 29                	push   $0x29
  jmp alltraps
80106b4c:	e9 ba f9 ff ff       	jmp    8010650b <alltraps>

80106b51 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $42
80106b53:	6a 2a                	push   $0x2a
  jmp alltraps
80106b55:	e9 b1 f9 ff ff       	jmp    8010650b <alltraps>

80106b5a <vector43>:
.globl vector43
vector43:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $43
80106b5c:	6a 2b                	push   $0x2b
  jmp alltraps
80106b5e:	e9 a8 f9 ff ff       	jmp    8010650b <alltraps>

80106b63 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $44
80106b65:	6a 2c                	push   $0x2c
  jmp alltraps
80106b67:	e9 9f f9 ff ff       	jmp    8010650b <alltraps>

80106b6c <vector45>:
.globl vector45
vector45:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $45
80106b6e:	6a 2d                	push   $0x2d
  jmp alltraps
80106b70:	e9 96 f9 ff ff       	jmp    8010650b <alltraps>

80106b75 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $46
80106b77:	6a 2e                	push   $0x2e
  jmp alltraps
80106b79:	e9 8d f9 ff ff       	jmp    8010650b <alltraps>

80106b7e <vector47>:
.globl vector47
vector47:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $47
80106b80:	6a 2f                	push   $0x2f
  jmp alltraps
80106b82:	e9 84 f9 ff ff       	jmp    8010650b <alltraps>

80106b87 <vector48>:
.globl vector48
vector48:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $48
80106b89:	6a 30                	push   $0x30
  jmp alltraps
80106b8b:	e9 7b f9 ff ff       	jmp    8010650b <alltraps>

80106b90 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $49
80106b92:	6a 31                	push   $0x31
  jmp alltraps
80106b94:	e9 72 f9 ff ff       	jmp    8010650b <alltraps>

80106b99 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $50
80106b9b:	6a 32                	push   $0x32
  jmp alltraps
80106b9d:	e9 69 f9 ff ff       	jmp    8010650b <alltraps>

80106ba2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $51
80106ba4:	6a 33                	push   $0x33
  jmp alltraps
80106ba6:	e9 60 f9 ff ff       	jmp    8010650b <alltraps>

80106bab <vector52>:
.globl vector52
vector52:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $52
80106bad:	6a 34                	push   $0x34
  jmp alltraps
80106baf:	e9 57 f9 ff ff       	jmp    8010650b <alltraps>

80106bb4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $53
80106bb6:	6a 35                	push   $0x35
  jmp alltraps
80106bb8:	e9 4e f9 ff ff       	jmp    8010650b <alltraps>

80106bbd <vector54>:
.globl vector54
vector54:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $54
80106bbf:	6a 36                	push   $0x36
  jmp alltraps
80106bc1:	e9 45 f9 ff ff       	jmp    8010650b <alltraps>

80106bc6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $55
80106bc8:	6a 37                	push   $0x37
  jmp alltraps
80106bca:	e9 3c f9 ff ff       	jmp    8010650b <alltraps>

80106bcf <vector56>:
.globl vector56
vector56:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $56
80106bd1:	6a 38                	push   $0x38
  jmp alltraps
80106bd3:	e9 33 f9 ff ff       	jmp    8010650b <alltraps>

80106bd8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $57
80106bda:	6a 39                	push   $0x39
  jmp alltraps
80106bdc:	e9 2a f9 ff ff       	jmp    8010650b <alltraps>

80106be1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $58
80106be3:	6a 3a                	push   $0x3a
  jmp alltraps
80106be5:	e9 21 f9 ff ff       	jmp    8010650b <alltraps>

80106bea <vector59>:
.globl vector59
vector59:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $59
80106bec:	6a 3b                	push   $0x3b
  jmp alltraps
80106bee:	e9 18 f9 ff ff       	jmp    8010650b <alltraps>

80106bf3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $60
80106bf5:	6a 3c                	push   $0x3c
  jmp alltraps
80106bf7:	e9 0f f9 ff ff       	jmp    8010650b <alltraps>

80106bfc <vector61>:
.globl vector61
vector61:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $61
80106bfe:	6a 3d                	push   $0x3d
  jmp alltraps
80106c00:	e9 06 f9 ff ff       	jmp    8010650b <alltraps>

80106c05 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $62
80106c07:	6a 3e                	push   $0x3e
  jmp alltraps
80106c09:	e9 fd f8 ff ff       	jmp    8010650b <alltraps>

80106c0e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $63
80106c10:	6a 3f                	push   $0x3f
  jmp alltraps
80106c12:	e9 f4 f8 ff ff       	jmp    8010650b <alltraps>

80106c17 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $64
80106c19:	6a 40                	push   $0x40
  jmp alltraps
80106c1b:	e9 eb f8 ff ff       	jmp    8010650b <alltraps>

80106c20 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $65
80106c22:	6a 41                	push   $0x41
  jmp alltraps
80106c24:	e9 e2 f8 ff ff       	jmp    8010650b <alltraps>

80106c29 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $66
80106c2b:	6a 42                	push   $0x42
  jmp alltraps
80106c2d:	e9 d9 f8 ff ff       	jmp    8010650b <alltraps>

80106c32 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $67
80106c34:	6a 43                	push   $0x43
  jmp alltraps
80106c36:	e9 d0 f8 ff ff       	jmp    8010650b <alltraps>

80106c3b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $68
80106c3d:	6a 44                	push   $0x44
  jmp alltraps
80106c3f:	e9 c7 f8 ff ff       	jmp    8010650b <alltraps>

80106c44 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $69
80106c46:	6a 45                	push   $0x45
  jmp alltraps
80106c48:	e9 be f8 ff ff       	jmp    8010650b <alltraps>

80106c4d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $70
80106c4f:	6a 46                	push   $0x46
  jmp alltraps
80106c51:	e9 b5 f8 ff ff       	jmp    8010650b <alltraps>

80106c56 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $71
80106c58:	6a 47                	push   $0x47
  jmp alltraps
80106c5a:	e9 ac f8 ff ff       	jmp    8010650b <alltraps>

80106c5f <vector72>:
.globl vector72
vector72:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $72
80106c61:	6a 48                	push   $0x48
  jmp alltraps
80106c63:	e9 a3 f8 ff ff       	jmp    8010650b <alltraps>

80106c68 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $73
80106c6a:	6a 49                	push   $0x49
  jmp alltraps
80106c6c:	e9 9a f8 ff ff       	jmp    8010650b <alltraps>

80106c71 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $74
80106c73:	6a 4a                	push   $0x4a
  jmp alltraps
80106c75:	e9 91 f8 ff ff       	jmp    8010650b <alltraps>

80106c7a <vector75>:
.globl vector75
vector75:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $75
80106c7c:	6a 4b                	push   $0x4b
  jmp alltraps
80106c7e:	e9 88 f8 ff ff       	jmp    8010650b <alltraps>

80106c83 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $76
80106c85:	6a 4c                	push   $0x4c
  jmp alltraps
80106c87:	e9 7f f8 ff ff       	jmp    8010650b <alltraps>

80106c8c <vector77>:
.globl vector77
vector77:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $77
80106c8e:	6a 4d                	push   $0x4d
  jmp alltraps
80106c90:	e9 76 f8 ff ff       	jmp    8010650b <alltraps>

80106c95 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $78
80106c97:	6a 4e                	push   $0x4e
  jmp alltraps
80106c99:	e9 6d f8 ff ff       	jmp    8010650b <alltraps>

80106c9e <vector79>:
.globl vector79
vector79:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $79
80106ca0:	6a 4f                	push   $0x4f
  jmp alltraps
80106ca2:	e9 64 f8 ff ff       	jmp    8010650b <alltraps>

80106ca7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $80
80106ca9:	6a 50                	push   $0x50
  jmp alltraps
80106cab:	e9 5b f8 ff ff       	jmp    8010650b <alltraps>

80106cb0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $81
80106cb2:	6a 51                	push   $0x51
  jmp alltraps
80106cb4:	e9 52 f8 ff ff       	jmp    8010650b <alltraps>

80106cb9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $82
80106cbb:	6a 52                	push   $0x52
  jmp alltraps
80106cbd:	e9 49 f8 ff ff       	jmp    8010650b <alltraps>

80106cc2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $83
80106cc4:	6a 53                	push   $0x53
  jmp alltraps
80106cc6:	e9 40 f8 ff ff       	jmp    8010650b <alltraps>

80106ccb <vector84>:
.globl vector84
vector84:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $84
80106ccd:	6a 54                	push   $0x54
  jmp alltraps
80106ccf:	e9 37 f8 ff ff       	jmp    8010650b <alltraps>

80106cd4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $85
80106cd6:	6a 55                	push   $0x55
  jmp alltraps
80106cd8:	e9 2e f8 ff ff       	jmp    8010650b <alltraps>

80106cdd <vector86>:
.globl vector86
vector86:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $86
80106cdf:	6a 56                	push   $0x56
  jmp alltraps
80106ce1:	e9 25 f8 ff ff       	jmp    8010650b <alltraps>

80106ce6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $87
80106ce8:	6a 57                	push   $0x57
  jmp alltraps
80106cea:	e9 1c f8 ff ff       	jmp    8010650b <alltraps>

80106cef <vector88>:
.globl vector88
vector88:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $88
80106cf1:	6a 58                	push   $0x58
  jmp alltraps
80106cf3:	e9 13 f8 ff ff       	jmp    8010650b <alltraps>

80106cf8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $89
80106cfa:	6a 59                	push   $0x59
  jmp alltraps
80106cfc:	e9 0a f8 ff ff       	jmp    8010650b <alltraps>

80106d01 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $90
80106d03:	6a 5a                	push   $0x5a
  jmp alltraps
80106d05:	e9 01 f8 ff ff       	jmp    8010650b <alltraps>

80106d0a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $91
80106d0c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d0e:	e9 f8 f7 ff ff       	jmp    8010650b <alltraps>

80106d13 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $92
80106d15:	6a 5c                	push   $0x5c
  jmp alltraps
80106d17:	e9 ef f7 ff ff       	jmp    8010650b <alltraps>

80106d1c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $93
80106d1e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d20:	e9 e6 f7 ff ff       	jmp    8010650b <alltraps>

80106d25 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $94
80106d27:	6a 5e                	push   $0x5e
  jmp alltraps
80106d29:	e9 dd f7 ff ff       	jmp    8010650b <alltraps>

80106d2e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $95
80106d30:	6a 5f                	push   $0x5f
  jmp alltraps
80106d32:	e9 d4 f7 ff ff       	jmp    8010650b <alltraps>

80106d37 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $96
80106d39:	6a 60                	push   $0x60
  jmp alltraps
80106d3b:	e9 cb f7 ff ff       	jmp    8010650b <alltraps>

80106d40 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $97
80106d42:	6a 61                	push   $0x61
  jmp alltraps
80106d44:	e9 c2 f7 ff ff       	jmp    8010650b <alltraps>

80106d49 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $98
80106d4b:	6a 62                	push   $0x62
  jmp alltraps
80106d4d:	e9 b9 f7 ff ff       	jmp    8010650b <alltraps>

80106d52 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $99
80106d54:	6a 63                	push   $0x63
  jmp alltraps
80106d56:	e9 b0 f7 ff ff       	jmp    8010650b <alltraps>

80106d5b <vector100>:
.globl vector100
vector100:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $100
80106d5d:	6a 64                	push   $0x64
  jmp alltraps
80106d5f:	e9 a7 f7 ff ff       	jmp    8010650b <alltraps>

80106d64 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $101
80106d66:	6a 65                	push   $0x65
  jmp alltraps
80106d68:	e9 9e f7 ff ff       	jmp    8010650b <alltraps>

80106d6d <vector102>:
.globl vector102
vector102:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $102
80106d6f:	6a 66                	push   $0x66
  jmp alltraps
80106d71:	e9 95 f7 ff ff       	jmp    8010650b <alltraps>

80106d76 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $103
80106d78:	6a 67                	push   $0x67
  jmp alltraps
80106d7a:	e9 8c f7 ff ff       	jmp    8010650b <alltraps>

80106d7f <vector104>:
.globl vector104
vector104:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $104
80106d81:	6a 68                	push   $0x68
  jmp alltraps
80106d83:	e9 83 f7 ff ff       	jmp    8010650b <alltraps>

80106d88 <vector105>:
.globl vector105
vector105:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $105
80106d8a:	6a 69                	push   $0x69
  jmp alltraps
80106d8c:	e9 7a f7 ff ff       	jmp    8010650b <alltraps>

80106d91 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $106
80106d93:	6a 6a                	push   $0x6a
  jmp alltraps
80106d95:	e9 71 f7 ff ff       	jmp    8010650b <alltraps>

80106d9a <vector107>:
.globl vector107
vector107:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $107
80106d9c:	6a 6b                	push   $0x6b
  jmp alltraps
80106d9e:	e9 68 f7 ff ff       	jmp    8010650b <alltraps>

80106da3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $108
80106da5:	6a 6c                	push   $0x6c
  jmp alltraps
80106da7:	e9 5f f7 ff ff       	jmp    8010650b <alltraps>

80106dac <vector109>:
.globl vector109
vector109:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $109
80106dae:	6a 6d                	push   $0x6d
  jmp alltraps
80106db0:	e9 56 f7 ff ff       	jmp    8010650b <alltraps>

80106db5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $110
80106db7:	6a 6e                	push   $0x6e
  jmp alltraps
80106db9:	e9 4d f7 ff ff       	jmp    8010650b <alltraps>

80106dbe <vector111>:
.globl vector111
vector111:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $111
80106dc0:	6a 6f                	push   $0x6f
  jmp alltraps
80106dc2:	e9 44 f7 ff ff       	jmp    8010650b <alltraps>

80106dc7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $112
80106dc9:	6a 70                	push   $0x70
  jmp alltraps
80106dcb:	e9 3b f7 ff ff       	jmp    8010650b <alltraps>

80106dd0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $113
80106dd2:	6a 71                	push   $0x71
  jmp alltraps
80106dd4:	e9 32 f7 ff ff       	jmp    8010650b <alltraps>

80106dd9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $114
80106ddb:	6a 72                	push   $0x72
  jmp alltraps
80106ddd:	e9 29 f7 ff ff       	jmp    8010650b <alltraps>

80106de2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $115
80106de4:	6a 73                	push   $0x73
  jmp alltraps
80106de6:	e9 20 f7 ff ff       	jmp    8010650b <alltraps>

80106deb <vector116>:
.globl vector116
vector116:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $116
80106ded:	6a 74                	push   $0x74
  jmp alltraps
80106def:	e9 17 f7 ff ff       	jmp    8010650b <alltraps>

80106df4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $117
80106df6:	6a 75                	push   $0x75
  jmp alltraps
80106df8:	e9 0e f7 ff ff       	jmp    8010650b <alltraps>

80106dfd <vector118>:
.globl vector118
vector118:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $118
80106dff:	6a 76                	push   $0x76
  jmp alltraps
80106e01:	e9 05 f7 ff ff       	jmp    8010650b <alltraps>

80106e06 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $119
80106e08:	6a 77                	push   $0x77
  jmp alltraps
80106e0a:	e9 fc f6 ff ff       	jmp    8010650b <alltraps>

80106e0f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $120
80106e11:	6a 78                	push   $0x78
  jmp alltraps
80106e13:	e9 f3 f6 ff ff       	jmp    8010650b <alltraps>

80106e18 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $121
80106e1a:	6a 79                	push   $0x79
  jmp alltraps
80106e1c:	e9 ea f6 ff ff       	jmp    8010650b <alltraps>

80106e21 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $122
80106e23:	6a 7a                	push   $0x7a
  jmp alltraps
80106e25:	e9 e1 f6 ff ff       	jmp    8010650b <alltraps>

80106e2a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $123
80106e2c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e2e:	e9 d8 f6 ff ff       	jmp    8010650b <alltraps>

80106e33 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $124
80106e35:	6a 7c                	push   $0x7c
  jmp alltraps
80106e37:	e9 cf f6 ff ff       	jmp    8010650b <alltraps>

80106e3c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $125
80106e3e:	6a 7d                	push   $0x7d
  jmp alltraps
80106e40:	e9 c6 f6 ff ff       	jmp    8010650b <alltraps>

80106e45 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $126
80106e47:	6a 7e                	push   $0x7e
  jmp alltraps
80106e49:	e9 bd f6 ff ff       	jmp    8010650b <alltraps>

80106e4e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $127
80106e50:	6a 7f                	push   $0x7f
  jmp alltraps
80106e52:	e9 b4 f6 ff ff       	jmp    8010650b <alltraps>

80106e57 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $128
80106e59:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e5e:	e9 a8 f6 ff ff       	jmp    8010650b <alltraps>

80106e63 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $129
80106e65:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e6a:	e9 9c f6 ff ff       	jmp    8010650b <alltraps>

80106e6f <vector130>:
.globl vector130
vector130:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $130
80106e71:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e76:	e9 90 f6 ff ff       	jmp    8010650b <alltraps>

80106e7b <vector131>:
.globl vector131
vector131:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $131
80106e7d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e82:	e9 84 f6 ff ff       	jmp    8010650b <alltraps>

80106e87 <vector132>:
.globl vector132
vector132:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $132
80106e89:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e8e:	e9 78 f6 ff ff       	jmp    8010650b <alltraps>

80106e93 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $133
80106e95:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e9a:	e9 6c f6 ff ff       	jmp    8010650b <alltraps>

80106e9f <vector134>:
.globl vector134
vector134:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $134
80106ea1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ea6:	e9 60 f6 ff ff       	jmp    8010650b <alltraps>

80106eab <vector135>:
.globl vector135
vector135:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $135
80106ead:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106eb2:	e9 54 f6 ff ff       	jmp    8010650b <alltraps>

80106eb7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $136
80106eb9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ebe:	e9 48 f6 ff ff       	jmp    8010650b <alltraps>

80106ec3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $137
80106ec5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106eca:	e9 3c f6 ff ff       	jmp    8010650b <alltraps>

80106ecf <vector138>:
.globl vector138
vector138:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $138
80106ed1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ed6:	e9 30 f6 ff ff       	jmp    8010650b <alltraps>

80106edb <vector139>:
.globl vector139
vector139:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $139
80106edd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ee2:	e9 24 f6 ff ff       	jmp    8010650b <alltraps>

80106ee7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $140
80106ee9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106eee:	e9 18 f6 ff ff       	jmp    8010650b <alltraps>

80106ef3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $141
80106ef5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106efa:	e9 0c f6 ff ff       	jmp    8010650b <alltraps>

80106eff <vector142>:
.globl vector142
vector142:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $142
80106f01:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f06:	e9 00 f6 ff ff       	jmp    8010650b <alltraps>

80106f0b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $143
80106f0d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f12:	e9 f4 f5 ff ff       	jmp    8010650b <alltraps>

80106f17 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $144
80106f19:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f1e:	e9 e8 f5 ff ff       	jmp    8010650b <alltraps>

80106f23 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $145
80106f25:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f2a:	e9 dc f5 ff ff       	jmp    8010650b <alltraps>

80106f2f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $146
80106f31:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f36:	e9 d0 f5 ff ff       	jmp    8010650b <alltraps>

80106f3b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $147
80106f3d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f42:	e9 c4 f5 ff ff       	jmp    8010650b <alltraps>

80106f47 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $148
80106f49:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f4e:	e9 b8 f5 ff ff       	jmp    8010650b <alltraps>

80106f53 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $149
80106f55:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f5a:	e9 ac f5 ff ff       	jmp    8010650b <alltraps>

80106f5f <vector150>:
.globl vector150
vector150:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $150
80106f61:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f66:	e9 a0 f5 ff ff       	jmp    8010650b <alltraps>

80106f6b <vector151>:
.globl vector151
vector151:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $151
80106f6d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f72:	e9 94 f5 ff ff       	jmp    8010650b <alltraps>

80106f77 <vector152>:
.globl vector152
vector152:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $152
80106f79:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f7e:	e9 88 f5 ff ff       	jmp    8010650b <alltraps>

80106f83 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $153
80106f85:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f8a:	e9 7c f5 ff ff       	jmp    8010650b <alltraps>

80106f8f <vector154>:
.globl vector154
vector154:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $154
80106f91:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f96:	e9 70 f5 ff ff       	jmp    8010650b <alltraps>

80106f9b <vector155>:
.globl vector155
vector155:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $155
80106f9d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fa2:	e9 64 f5 ff ff       	jmp    8010650b <alltraps>

80106fa7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $156
80106fa9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fae:	e9 58 f5 ff ff       	jmp    8010650b <alltraps>

80106fb3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $157
80106fb5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fba:	e9 4c f5 ff ff       	jmp    8010650b <alltraps>

80106fbf <vector158>:
.globl vector158
vector158:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $158
80106fc1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106fc6:	e9 40 f5 ff ff       	jmp    8010650b <alltraps>

80106fcb <vector159>:
.globl vector159
vector159:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $159
80106fcd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106fd2:	e9 34 f5 ff ff       	jmp    8010650b <alltraps>

80106fd7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $160
80106fd9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106fde:	e9 28 f5 ff ff       	jmp    8010650b <alltraps>

80106fe3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $161
80106fe5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106fea:	e9 1c f5 ff ff       	jmp    8010650b <alltraps>

80106fef <vector162>:
.globl vector162
vector162:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $162
80106ff1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ff6:	e9 10 f5 ff ff       	jmp    8010650b <alltraps>

80106ffb <vector163>:
.globl vector163
vector163:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $163
80106ffd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107002:	e9 04 f5 ff ff       	jmp    8010650b <alltraps>

80107007 <vector164>:
.globl vector164
vector164:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $164
80107009:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010700e:	e9 f8 f4 ff ff       	jmp    8010650b <alltraps>

80107013 <vector165>:
.globl vector165
vector165:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $165
80107015:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010701a:	e9 ec f4 ff ff       	jmp    8010650b <alltraps>

8010701f <vector166>:
.globl vector166
vector166:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $166
80107021:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107026:	e9 e0 f4 ff ff       	jmp    8010650b <alltraps>

8010702b <vector167>:
.globl vector167
vector167:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $167
8010702d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107032:	e9 d4 f4 ff ff       	jmp    8010650b <alltraps>

80107037 <vector168>:
.globl vector168
vector168:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $168
80107039:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010703e:	e9 c8 f4 ff ff       	jmp    8010650b <alltraps>

80107043 <vector169>:
.globl vector169
vector169:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $169
80107045:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010704a:	e9 bc f4 ff ff       	jmp    8010650b <alltraps>

8010704f <vector170>:
.globl vector170
vector170:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $170
80107051:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107056:	e9 b0 f4 ff ff       	jmp    8010650b <alltraps>

8010705b <vector171>:
.globl vector171
vector171:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $171
8010705d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107062:	e9 a4 f4 ff ff       	jmp    8010650b <alltraps>

80107067 <vector172>:
.globl vector172
vector172:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $172
80107069:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010706e:	e9 98 f4 ff ff       	jmp    8010650b <alltraps>

80107073 <vector173>:
.globl vector173
vector173:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $173
80107075:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010707a:	e9 8c f4 ff ff       	jmp    8010650b <alltraps>

8010707f <vector174>:
.globl vector174
vector174:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $174
80107081:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107086:	e9 80 f4 ff ff       	jmp    8010650b <alltraps>

8010708b <vector175>:
.globl vector175
vector175:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $175
8010708d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107092:	e9 74 f4 ff ff       	jmp    8010650b <alltraps>

80107097 <vector176>:
.globl vector176
vector176:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $176
80107099:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010709e:	e9 68 f4 ff ff       	jmp    8010650b <alltraps>

801070a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $177
801070a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070aa:	e9 5c f4 ff ff       	jmp    8010650b <alltraps>

801070af <vector178>:
.globl vector178
vector178:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $178
801070b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070b6:	e9 50 f4 ff ff       	jmp    8010650b <alltraps>

801070bb <vector179>:
.globl vector179
vector179:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $179
801070bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070c2:	e9 44 f4 ff ff       	jmp    8010650b <alltraps>

801070c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $180
801070c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070ce:	e9 38 f4 ff ff       	jmp    8010650b <alltraps>

801070d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $181
801070d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801070da:	e9 2c f4 ff ff       	jmp    8010650b <alltraps>

801070df <vector182>:
.globl vector182
vector182:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $182
801070e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801070e6:	e9 20 f4 ff ff       	jmp    8010650b <alltraps>

801070eb <vector183>:
.globl vector183
vector183:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $183
801070ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801070f2:	e9 14 f4 ff ff       	jmp    8010650b <alltraps>

801070f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $184
801070f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070fe:	e9 08 f4 ff ff       	jmp    8010650b <alltraps>

80107103 <vector185>:
.globl vector185
vector185:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $185
80107105:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010710a:	e9 fc f3 ff ff       	jmp    8010650b <alltraps>

8010710f <vector186>:
.globl vector186
vector186:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $186
80107111:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107116:	e9 f0 f3 ff ff       	jmp    8010650b <alltraps>

8010711b <vector187>:
.globl vector187
vector187:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $187
8010711d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107122:	e9 e4 f3 ff ff       	jmp    8010650b <alltraps>

80107127 <vector188>:
.globl vector188
vector188:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $188
80107129:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010712e:	e9 d8 f3 ff ff       	jmp    8010650b <alltraps>

80107133 <vector189>:
.globl vector189
vector189:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $189
80107135:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010713a:	e9 cc f3 ff ff       	jmp    8010650b <alltraps>

8010713f <vector190>:
.globl vector190
vector190:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $190
80107141:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107146:	e9 c0 f3 ff ff       	jmp    8010650b <alltraps>

8010714b <vector191>:
.globl vector191
vector191:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $191
8010714d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107152:	e9 b4 f3 ff ff       	jmp    8010650b <alltraps>

80107157 <vector192>:
.globl vector192
vector192:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $192
80107159:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010715e:	e9 a8 f3 ff ff       	jmp    8010650b <alltraps>

80107163 <vector193>:
.globl vector193
vector193:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $193
80107165:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010716a:	e9 9c f3 ff ff       	jmp    8010650b <alltraps>

8010716f <vector194>:
.globl vector194
vector194:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $194
80107171:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107176:	e9 90 f3 ff ff       	jmp    8010650b <alltraps>

8010717b <vector195>:
.globl vector195
vector195:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $195
8010717d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107182:	e9 84 f3 ff ff       	jmp    8010650b <alltraps>

80107187 <vector196>:
.globl vector196
vector196:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $196
80107189:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010718e:	e9 78 f3 ff ff       	jmp    8010650b <alltraps>

80107193 <vector197>:
.globl vector197
vector197:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $197
80107195:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010719a:	e9 6c f3 ff ff       	jmp    8010650b <alltraps>

8010719f <vector198>:
.globl vector198
vector198:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $198
801071a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071a6:	e9 60 f3 ff ff       	jmp    8010650b <alltraps>

801071ab <vector199>:
.globl vector199
vector199:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $199
801071ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071b2:	e9 54 f3 ff ff       	jmp    8010650b <alltraps>

801071b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $200
801071b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071be:	e9 48 f3 ff ff       	jmp    8010650b <alltraps>

801071c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $201
801071c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071ca:	e9 3c f3 ff ff       	jmp    8010650b <alltraps>

801071cf <vector202>:
.globl vector202
vector202:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $202
801071d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801071d6:	e9 30 f3 ff ff       	jmp    8010650b <alltraps>

801071db <vector203>:
.globl vector203
vector203:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $203
801071dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801071e2:	e9 24 f3 ff ff       	jmp    8010650b <alltraps>

801071e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $204
801071e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801071ee:	e9 18 f3 ff ff       	jmp    8010650b <alltraps>

801071f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $205
801071f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071fa:	e9 0c f3 ff ff       	jmp    8010650b <alltraps>

801071ff <vector206>:
.globl vector206
vector206:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $206
80107201:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107206:	e9 00 f3 ff ff       	jmp    8010650b <alltraps>

8010720b <vector207>:
.globl vector207
vector207:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $207
8010720d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107212:	e9 f4 f2 ff ff       	jmp    8010650b <alltraps>

80107217 <vector208>:
.globl vector208
vector208:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $208
80107219:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010721e:	e9 e8 f2 ff ff       	jmp    8010650b <alltraps>

80107223 <vector209>:
.globl vector209
vector209:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $209
80107225:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010722a:	e9 dc f2 ff ff       	jmp    8010650b <alltraps>

8010722f <vector210>:
.globl vector210
vector210:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $210
80107231:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107236:	e9 d0 f2 ff ff       	jmp    8010650b <alltraps>

8010723b <vector211>:
.globl vector211
vector211:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $211
8010723d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107242:	e9 c4 f2 ff ff       	jmp    8010650b <alltraps>

80107247 <vector212>:
.globl vector212
vector212:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $212
80107249:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010724e:	e9 b8 f2 ff ff       	jmp    8010650b <alltraps>

80107253 <vector213>:
.globl vector213
vector213:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $213
80107255:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010725a:	e9 ac f2 ff ff       	jmp    8010650b <alltraps>

8010725f <vector214>:
.globl vector214
vector214:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $214
80107261:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107266:	e9 a0 f2 ff ff       	jmp    8010650b <alltraps>

8010726b <vector215>:
.globl vector215
vector215:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $215
8010726d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107272:	e9 94 f2 ff ff       	jmp    8010650b <alltraps>

80107277 <vector216>:
.globl vector216
vector216:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $216
80107279:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010727e:	e9 88 f2 ff ff       	jmp    8010650b <alltraps>

80107283 <vector217>:
.globl vector217
vector217:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $217
80107285:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010728a:	e9 7c f2 ff ff       	jmp    8010650b <alltraps>

8010728f <vector218>:
.globl vector218
vector218:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $218
80107291:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107296:	e9 70 f2 ff ff       	jmp    8010650b <alltraps>

8010729b <vector219>:
.globl vector219
vector219:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $219
8010729d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072a2:	e9 64 f2 ff ff       	jmp    8010650b <alltraps>

801072a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $220
801072a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072ae:	e9 58 f2 ff ff       	jmp    8010650b <alltraps>

801072b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $221
801072b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072ba:	e9 4c f2 ff ff       	jmp    8010650b <alltraps>

801072bf <vector222>:
.globl vector222
vector222:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $222
801072c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072c6:	e9 40 f2 ff ff       	jmp    8010650b <alltraps>

801072cb <vector223>:
.globl vector223
vector223:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $223
801072cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801072d2:	e9 34 f2 ff ff       	jmp    8010650b <alltraps>

801072d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $224
801072d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801072de:	e9 28 f2 ff ff       	jmp    8010650b <alltraps>

801072e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $225
801072e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801072ea:	e9 1c f2 ff ff       	jmp    8010650b <alltraps>

801072ef <vector226>:
.globl vector226
vector226:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $226
801072f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801072f6:	e9 10 f2 ff ff       	jmp    8010650b <alltraps>

801072fb <vector227>:
.globl vector227
vector227:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $227
801072fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107302:	e9 04 f2 ff ff       	jmp    8010650b <alltraps>

80107307 <vector228>:
.globl vector228
vector228:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $228
80107309:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010730e:	e9 f8 f1 ff ff       	jmp    8010650b <alltraps>

80107313 <vector229>:
.globl vector229
vector229:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $229
80107315:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010731a:	e9 ec f1 ff ff       	jmp    8010650b <alltraps>

8010731f <vector230>:
.globl vector230
vector230:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $230
80107321:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107326:	e9 e0 f1 ff ff       	jmp    8010650b <alltraps>

8010732b <vector231>:
.globl vector231
vector231:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $231
8010732d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107332:	e9 d4 f1 ff ff       	jmp    8010650b <alltraps>

80107337 <vector232>:
.globl vector232
vector232:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $232
80107339:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010733e:	e9 c8 f1 ff ff       	jmp    8010650b <alltraps>

80107343 <vector233>:
.globl vector233
vector233:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $233
80107345:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010734a:	e9 bc f1 ff ff       	jmp    8010650b <alltraps>

8010734f <vector234>:
.globl vector234
vector234:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $234
80107351:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107356:	e9 b0 f1 ff ff       	jmp    8010650b <alltraps>

8010735b <vector235>:
.globl vector235
vector235:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $235
8010735d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107362:	e9 a4 f1 ff ff       	jmp    8010650b <alltraps>

80107367 <vector236>:
.globl vector236
vector236:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $236
80107369:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010736e:	e9 98 f1 ff ff       	jmp    8010650b <alltraps>

80107373 <vector237>:
.globl vector237
vector237:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $237
80107375:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010737a:	e9 8c f1 ff ff       	jmp    8010650b <alltraps>

8010737f <vector238>:
.globl vector238
vector238:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $238
80107381:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107386:	e9 80 f1 ff ff       	jmp    8010650b <alltraps>

8010738b <vector239>:
.globl vector239
vector239:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $239
8010738d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107392:	e9 74 f1 ff ff       	jmp    8010650b <alltraps>

80107397 <vector240>:
.globl vector240
vector240:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $240
80107399:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010739e:	e9 68 f1 ff ff       	jmp    8010650b <alltraps>

801073a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $241
801073a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073aa:	e9 5c f1 ff ff       	jmp    8010650b <alltraps>

801073af <vector242>:
.globl vector242
vector242:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $242
801073b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073b6:	e9 50 f1 ff ff       	jmp    8010650b <alltraps>

801073bb <vector243>:
.globl vector243
vector243:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $243
801073bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073c2:	e9 44 f1 ff ff       	jmp    8010650b <alltraps>

801073c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $244
801073c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073ce:	e9 38 f1 ff ff       	jmp    8010650b <alltraps>

801073d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $245
801073d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801073da:	e9 2c f1 ff ff       	jmp    8010650b <alltraps>

801073df <vector246>:
.globl vector246
vector246:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $246
801073e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801073e6:	e9 20 f1 ff ff       	jmp    8010650b <alltraps>

801073eb <vector247>:
.globl vector247
vector247:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $247
801073ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801073f2:	e9 14 f1 ff ff       	jmp    8010650b <alltraps>

801073f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $248
801073f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073fe:	e9 08 f1 ff ff       	jmp    8010650b <alltraps>

80107403 <vector249>:
.globl vector249
vector249:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $249
80107405:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010740a:	e9 fc f0 ff ff       	jmp    8010650b <alltraps>

8010740f <vector250>:
.globl vector250
vector250:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $250
80107411:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107416:	e9 f0 f0 ff ff       	jmp    8010650b <alltraps>

8010741b <vector251>:
.globl vector251
vector251:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $251
8010741d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107422:	e9 e4 f0 ff ff       	jmp    8010650b <alltraps>

80107427 <vector252>:
.globl vector252
vector252:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $252
80107429:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010742e:	e9 d8 f0 ff ff       	jmp    8010650b <alltraps>

80107433 <vector253>:
.globl vector253
vector253:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $253
80107435:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010743a:	e9 cc f0 ff ff       	jmp    8010650b <alltraps>

8010743f <vector254>:
.globl vector254
vector254:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $254
80107441:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107446:	e9 c0 f0 ff ff       	jmp    8010650b <alltraps>

8010744b <vector255>:
.globl vector255
vector255:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $255
8010744d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107452:	e9 b4 f0 ff ff       	jmp    8010650b <alltraps>
80107457:	66 90                	xchg   %ax,%ax
80107459:	66 90                	xchg   %ax,%ax
8010745b:	66 90                	xchg   %ax,%ax
8010745d:	66 90                	xchg   %ax,%ax
8010745f:	90                   	nop

80107460 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107466:	89 d3                	mov    %edx,%ebx
{
80107468:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010746a:	c1 eb 16             	shr    $0x16,%ebx
8010746d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107470:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107473:	8b 06                	mov    (%esi),%eax
80107475:	a8 01                	test   $0x1,%al
80107477:	74 27                	je     801074a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010747e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107484:	c1 ef 0a             	shr    $0xa,%edi
}
80107487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010748a:	89 fa                	mov    %edi,%edx
8010748c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107492:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret    
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074a0:	85 c9                	test   %ecx,%ecx
801074a2:	74 2c                	je     801074d0 <walkpgdir+0x70>
801074a4:	e8 e7 b1 ff ff       	call   80102690 <kalloc>
801074a9:	85 c0                	test   %eax,%eax
801074ab:	89 c3                	mov    %eax,%ebx
801074ad:	74 21                	je     801074d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074af:	83 ec 04             	sub    $0x4,%esp
801074b2:	68 00 10 00 00       	push   $0x1000
801074b7:	6a 00                	push   $0x0
801074b9:	50                   	push   %eax
801074ba:	e8 81 da ff ff       	call   80104f40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074c5:	83 c4 10             	add    $0x10,%esp
801074c8:	83 c8 07             	or     $0x7,%eax
801074cb:	89 06                	mov    %eax,(%esi)
801074cd:	eb b5                	jmp    80107484 <walkpgdir+0x24>
801074cf:	90                   	nop
}
801074d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801074d3:	31 c0                	xor    %eax,%eax
}
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801074e6:	89 d3                	mov    %edx,%ebx
801074e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801074ee:	83 ec 1c             	sub    $0x1c,%esp
801074f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801074f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801074f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801074fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107500:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107503:	8b 45 0c             	mov    0xc(%ebp),%eax
80107506:	29 df                	sub    %ebx,%edi
80107508:	83 c8 01             	or     $0x1,%eax
8010750b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010750e:	eb 15                	jmp    80107525 <mappages+0x45>
    if(*pte & PTE_P)
80107510:	f6 00 01             	testb  $0x1,(%eax)
80107513:	75 45                	jne    8010755a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107515:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107518:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010751b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010751d:	74 31                	je     80107550 <mappages+0x70>
      break;
    a += PGSIZE;
8010751f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107528:	b9 01 00 00 00       	mov    $0x1,%ecx
8010752d:	89 da                	mov    %ebx,%edx
8010752f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107532:	e8 29 ff ff ff       	call   80107460 <walkpgdir>
80107537:	85 c0                	test   %eax,%eax
80107539:	75 d5                	jne    80107510 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010753b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010753e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107543:	5b                   	pop    %ebx
80107544:	5e                   	pop    %esi
80107545:	5f                   	pop    %edi
80107546:	5d                   	pop    %ebp
80107547:	c3                   	ret    
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
      panic("remap");
8010755a:	83 ec 0c             	sub    $0xc,%esp
8010755d:	68 e4 88 10 80       	push   $0x801088e4
80107562:	e8 29 8e ff ff       	call   80100390 <panic>
80107567:	89 f6                	mov    %esi,%esi
80107569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107570 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107576:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010757c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010757e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107584:	83 ec 1c             	sub    $0x1c,%esp
80107587:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010758a:	39 d3                	cmp    %edx,%ebx
8010758c:	73 66                	jae    801075f4 <deallocuvm.part.0+0x84>
8010758e:	89 d6                	mov    %edx,%esi
80107590:	eb 3d                	jmp    801075cf <deallocuvm.part.0+0x5f>
80107592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107598:	8b 10                	mov    (%eax),%edx
8010759a:	f6 c2 01             	test   $0x1,%dl
8010759d:	74 26                	je     801075c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010759f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801075a5:	74 58                	je     801075ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801075a7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801075aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801075b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801075b3:	52                   	push   %edx
801075b4:	e8 27 af ff ff       	call   801024e0 <kfree>
      *pte = 0;
801075b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075bc:	83 c4 10             	add    $0x10,%esp
801075bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801075c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075cb:	39 f3                	cmp    %esi,%ebx
801075cd:	73 25                	jae    801075f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801075cf:	31 c9                	xor    %ecx,%ecx
801075d1:	89 da                	mov    %ebx,%edx
801075d3:	89 f8                	mov    %edi,%eax
801075d5:	e8 86 fe ff ff       	call   80107460 <walkpgdir>
    if(!pte)
801075da:	85 c0                	test   %eax,%eax
801075dc:	75 ba                	jne    80107598 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801075de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801075e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801075ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075f0:	39 f3                	cmp    %esi,%ebx
801075f2:	72 db                	jb     801075cf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801075f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075fa:	5b                   	pop    %ebx
801075fb:	5e                   	pop    %esi
801075fc:	5f                   	pop    %edi
801075fd:	5d                   	pop    %ebp
801075fe:	c3                   	ret    
        panic("kfree");
801075ff:	83 ec 0c             	sub    $0xc,%esp
80107602:	68 06 80 10 80       	push   $0x80108006
80107607:	e8 84 8d ff ff       	call   80100390 <panic>
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107610 <seginit>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107616:	e8 75 c3 ff ff       	call   80103990 <cpuid>
8010761b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107621:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107626:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010762a:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
80107631:	ff 00 00 
80107634:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
8010763b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010763e:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
80107645:	ff 00 00 
80107648:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
8010764f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107652:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
80107659:	ff 00 00 
8010765c:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
80107663:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107666:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
8010766d:	ff 00 00 
80107670:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
80107677:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010767a:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
8010767f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107683:	c1 e8 10             	shr    $0x10,%eax
80107686:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010768a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010768d:	0f 01 10             	lgdtl  (%eax)
}
80107690:	c9                   	leave  
80107691:	c3                   	ret    
80107692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076a0:	a1 44 8f 11 80       	mov    0x80118f44,%eax
{
801076a5:	55                   	push   %ebp
801076a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076ad:	0f 22 d8             	mov    %eax,%cr3
}
801076b0:	5d                   	pop    %ebp
801076b1:	c3                   	ret    
801076b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076c0 <switchuvm>:
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	57                   	push   %edi
801076c4:	56                   	push   %esi
801076c5:	53                   	push   %ebx
801076c6:	83 ec 1c             	sub    $0x1c,%esp
801076c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801076cc:	85 db                	test   %ebx,%ebx
801076ce:	0f 84 cb 00 00 00    	je     8010779f <switchuvm+0xdf>
  if(p->kstack == 0)
801076d4:	8b 43 08             	mov    0x8(%ebx),%eax
801076d7:	85 c0                	test   %eax,%eax
801076d9:	0f 84 da 00 00 00    	je     801077b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801076df:	8b 43 04             	mov    0x4(%ebx),%eax
801076e2:	85 c0                	test   %eax,%eax
801076e4:	0f 84 c2 00 00 00    	je     801077ac <switchuvm+0xec>
  pushcli();
801076ea:	e8 71 d6 ff ff       	call   80104d60 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076ef:	e8 1c c2 ff ff       	call   80103910 <mycpu>
801076f4:	89 c6                	mov    %eax,%esi
801076f6:	e8 15 c2 ff ff       	call   80103910 <mycpu>
801076fb:	89 c7                	mov    %eax,%edi
801076fd:	e8 0e c2 ff ff       	call   80103910 <mycpu>
80107702:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107705:	83 c7 08             	add    $0x8,%edi
80107708:	e8 03 c2 ff ff       	call   80103910 <mycpu>
8010770d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107710:	83 c0 08             	add    $0x8,%eax
80107713:	ba 67 00 00 00       	mov    $0x67,%edx
80107718:	c1 e8 18             	shr    $0x18,%eax
8010771b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107722:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107729:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010772f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107734:	83 c1 08             	add    $0x8,%ecx
80107737:	c1 e9 10             	shr    $0x10,%ecx
8010773a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107740:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107745:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010774c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107751:	e8 ba c1 ff ff       	call   80103910 <mycpu>
80107756:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010775d:	e8 ae c1 ff ff       	call   80103910 <mycpu>
80107762:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107766:	8b 73 08             	mov    0x8(%ebx),%esi
80107769:	e8 a2 c1 ff ff       	call   80103910 <mycpu>
8010776e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107774:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107777:	e8 94 c1 ff ff       	call   80103910 <mycpu>
8010777c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107780:	b8 28 00 00 00       	mov    $0x28,%eax
80107785:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107788:	8b 43 04             	mov    0x4(%ebx),%eax
8010778b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107790:	0f 22 d8             	mov    %eax,%cr3
}
80107793:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107796:	5b                   	pop    %ebx
80107797:	5e                   	pop    %esi
80107798:	5f                   	pop    %edi
80107799:	5d                   	pop    %ebp
  popcli();
8010779a:	e9 01 d6 ff ff       	jmp    80104da0 <popcli>
    panic("switchuvm: no process");
8010779f:	83 ec 0c             	sub    $0xc,%esp
801077a2:	68 ea 88 10 80       	push   $0x801088ea
801077a7:	e8 e4 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801077ac:	83 ec 0c             	sub    $0xc,%esp
801077af:	68 15 89 10 80       	push   $0x80108915
801077b4:	e8 d7 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801077b9:	83 ec 0c             	sub    $0xc,%esp
801077bc:	68 00 89 10 80       	push   $0x80108900
801077c1:	e8 ca 8b ff ff       	call   80100390 <panic>
801077c6:	8d 76 00             	lea    0x0(%esi),%esi
801077c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077d0 <inituvm>:
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	57                   	push   %edi
801077d4:	56                   	push   %esi
801077d5:	53                   	push   %ebx
801077d6:	83 ec 1c             	sub    $0x1c,%esp
801077d9:	8b 75 10             	mov    0x10(%ebp),%esi
801077dc:	8b 45 08             	mov    0x8(%ebp),%eax
801077df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801077e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801077e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801077eb:	77 49                	ja     80107836 <inituvm+0x66>
  mem = kalloc();
801077ed:	e8 9e ae ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
801077f2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801077f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801077f7:	68 00 10 00 00       	push   $0x1000
801077fc:	6a 00                	push   $0x0
801077fe:	50                   	push   %eax
801077ff:	e8 3c d7 ff ff       	call   80104f40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107804:	58                   	pop    %eax
80107805:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010780b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107810:	5a                   	pop    %edx
80107811:	6a 06                	push   $0x6
80107813:	50                   	push   %eax
80107814:	31 d2                	xor    %edx,%edx
80107816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107819:	e8 c2 fc ff ff       	call   801074e0 <mappages>
  memmove(mem, init, sz);
8010781e:	89 75 10             	mov    %esi,0x10(%ebp)
80107821:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107824:	83 c4 10             	add    $0x10,%esp
80107827:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010782a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010782d:	5b                   	pop    %ebx
8010782e:	5e                   	pop    %esi
8010782f:	5f                   	pop    %edi
80107830:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107831:	e9 ba d7 ff ff       	jmp    80104ff0 <memmove>
    panic("inituvm: more than a page");
80107836:	83 ec 0c             	sub    $0xc,%esp
80107839:	68 29 89 10 80       	push   $0x80108929
8010783e:	e8 4d 8b ff ff       	call   80100390 <panic>
80107843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107850 <loaduvm>:
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107859:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107860:	0f 85 91 00 00 00    	jne    801078f7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107866:	8b 75 18             	mov    0x18(%ebp),%esi
80107869:	31 db                	xor    %ebx,%ebx
8010786b:	85 f6                	test   %esi,%esi
8010786d:	75 1a                	jne    80107889 <loaduvm+0x39>
8010786f:	eb 6f                	jmp    801078e0 <loaduvm+0x90>
80107871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107878:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010787e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107884:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107887:	76 57                	jbe    801078e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107889:	8b 55 0c             	mov    0xc(%ebp),%edx
8010788c:	8b 45 08             	mov    0x8(%ebp),%eax
8010788f:	31 c9                	xor    %ecx,%ecx
80107891:	01 da                	add    %ebx,%edx
80107893:	e8 c8 fb ff ff       	call   80107460 <walkpgdir>
80107898:	85 c0                	test   %eax,%eax
8010789a:	74 4e                	je     801078ea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010789c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010789e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801078a1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801078a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801078ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801078b1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078b4:	01 d9                	add    %ebx,%ecx
801078b6:	05 00 00 00 80       	add    $0x80000000,%eax
801078bb:	57                   	push   %edi
801078bc:	51                   	push   %ecx
801078bd:	50                   	push   %eax
801078be:	ff 75 10             	pushl  0x10(%ebp)
801078c1:	e8 6a a2 ff ff       	call   80101b30 <readi>
801078c6:	83 c4 10             	add    $0x10,%esp
801078c9:	39 f8                	cmp    %edi,%eax
801078cb:	74 ab                	je     80107878 <loaduvm+0x28>
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078d5:	5b                   	pop    %ebx
801078d6:	5e                   	pop    %esi
801078d7:	5f                   	pop    %edi
801078d8:	5d                   	pop    %ebp
801078d9:	c3                   	ret    
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078e3:	31 c0                	xor    %eax,%eax
}
801078e5:	5b                   	pop    %ebx
801078e6:	5e                   	pop    %esi
801078e7:	5f                   	pop    %edi
801078e8:	5d                   	pop    %ebp
801078e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801078ea:	83 ec 0c             	sub    $0xc,%esp
801078ed:	68 43 89 10 80       	push   $0x80108943
801078f2:	e8 99 8a ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801078f7:	83 ec 0c             	sub    $0xc,%esp
801078fa:	68 e4 89 10 80       	push   $0x801089e4
801078ff:	e8 8c 8a ff ff       	call   80100390 <panic>
80107904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010790a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107910 <allocuvm>:
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
80107915:	53                   	push   %ebx
80107916:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107919:	8b 7d 10             	mov    0x10(%ebp),%edi
8010791c:	85 ff                	test   %edi,%edi
8010791e:	0f 88 8e 00 00 00    	js     801079b2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107924:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107927:	0f 82 93 00 00 00    	jb     801079c0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010792d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107930:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107936:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010793c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010793f:	0f 86 7e 00 00 00    	jbe    801079c3 <allocuvm+0xb3>
80107945:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107948:	8b 7d 08             	mov    0x8(%ebp),%edi
8010794b:	eb 42                	jmp    8010798f <allocuvm+0x7f>
8010794d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107950:	83 ec 04             	sub    $0x4,%esp
80107953:	68 00 10 00 00       	push   $0x1000
80107958:	6a 00                	push   $0x0
8010795a:	50                   	push   %eax
8010795b:	e8 e0 d5 ff ff       	call   80104f40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107960:	58                   	pop    %eax
80107961:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107967:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010796c:	5a                   	pop    %edx
8010796d:	6a 06                	push   $0x6
8010796f:	50                   	push   %eax
80107970:	89 da                	mov    %ebx,%edx
80107972:	89 f8                	mov    %edi,%eax
80107974:	e8 67 fb ff ff       	call   801074e0 <mappages>
80107979:	83 c4 10             	add    $0x10,%esp
8010797c:	85 c0                	test   %eax,%eax
8010797e:	78 50                	js     801079d0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107980:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107986:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107989:	0f 86 81 00 00 00    	jbe    80107a10 <allocuvm+0x100>
    mem = kalloc();
8010798f:	e8 fc ac ff ff       	call   80102690 <kalloc>
    if(mem == 0){
80107994:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107996:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107998:	75 b6                	jne    80107950 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010799a:	83 ec 0c             	sub    $0xc,%esp
8010799d:	68 61 89 10 80       	push   $0x80108961
801079a2:	e8 b9 8c ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801079a7:	83 c4 10             	add    $0x10,%esp
801079aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801079ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801079b0:	77 6e                	ja     80107a20 <allocuvm+0x110>
}
801079b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801079b5:	31 ff                	xor    %edi,%edi
}
801079b7:	89 f8                	mov    %edi,%eax
801079b9:	5b                   	pop    %ebx
801079ba:	5e                   	pop    %esi
801079bb:	5f                   	pop    %edi
801079bc:	5d                   	pop    %ebp
801079bd:	c3                   	ret    
801079be:	66 90                	xchg   %ax,%ax
    return oldsz;
801079c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801079c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079c6:	89 f8                	mov    %edi,%eax
801079c8:	5b                   	pop    %ebx
801079c9:	5e                   	pop    %esi
801079ca:	5f                   	pop    %edi
801079cb:	5d                   	pop    %ebp
801079cc:	c3                   	ret    
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801079d0:	83 ec 0c             	sub    $0xc,%esp
801079d3:	68 79 89 10 80       	push   $0x80108979
801079d8:	e8 83 8c ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801079dd:	83 c4 10             	add    $0x10,%esp
801079e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e3:	39 45 10             	cmp    %eax,0x10(%ebp)
801079e6:	76 0d                	jbe    801079f5 <allocuvm+0xe5>
801079e8:	89 c1                	mov    %eax,%ecx
801079ea:	8b 55 10             	mov    0x10(%ebp),%edx
801079ed:	8b 45 08             	mov    0x8(%ebp),%eax
801079f0:	e8 7b fb ff ff       	call   80107570 <deallocuvm.part.0>
      kfree(mem);
801079f5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801079f8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801079fa:	56                   	push   %esi
801079fb:	e8 e0 aa ff ff       	call   801024e0 <kfree>
      return 0;
80107a00:	83 c4 10             	add    $0x10,%esp
}
80107a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a06:	89 f8                	mov    %edi,%eax
80107a08:	5b                   	pop    %ebx
80107a09:	5e                   	pop    %esi
80107a0a:	5f                   	pop    %edi
80107a0b:	5d                   	pop    %ebp
80107a0c:	c3                   	ret    
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi
80107a10:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a16:	5b                   	pop    %ebx
80107a17:	89 f8                	mov    %edi,%eax
80107a19:	5e                   	pop    %esi
80107a1a:	5f                   	pop    %edi
80107a1b:	5d                   	pop    %ebp
80107a1c:	c3                   	ret    
80107a1d:	8d 76 00             	lea    0x0(%esi),%esi
80107a20:	89 c1                	mov    %eax,%ecx
80107a22:	8b 55 10             	mov    0x10(%ebp),%edx
80107a25:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107a28:	31 ff                	xor    %edi,%edi
80107a2a:	e8 41 fb ff ff       	call   80107570 <deallocuvm.part.0>
80107a2f:	eb 92                	jmp    801079c3 <allocuvm+0xb3>
80107a31:	eb 0d                	jmp    80107a40 <deallocuvm>
80107a33:	90                   	nop
80107a34:	90                   	nop
80107a35:	90                   	nop
80107a36:	90                   	nop
80107a37:	90                   	nop
80107a38:	90                   	nop
80107a39:	90                   	nop
80107a3a:	90                   	nop
80107a3b:	90                   	nop
80107a3c:	90                   	nop
80107a3d:	90                   	nop
80107a3e:	90                   	nop
80107a3f:	90                   	nop

80107a40 <deallocuvm>:
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107a49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107a4c:	39 d1                	cmp    %edx,%ecx
80107a4e:	73 10                	jae    80107a60 <deallocuvm+0x20>
}
80107a50:	5d                   	pop    %ebp
80107a51:	e9 1a fb ff ff       	jmp    80107570 <deallocuvm.part.0>
80107a56:	8d 76 00             	lea    0x0(%esi),%esi
80107a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107a60:	89 d0                	mov    %edx,%eax
80107a62:	5d                   	pop    %ebp
80107a63:	c3                   	ret    
80107a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	57                   	push   %edi
80107a74:	56                   	push   %esi
80107a75:	53                   	push   %ebx
80107a76:	83 ec 0c             	sub    $0xc,%esp
80107a79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107a7c:	85 f6                	test   %esi,%esi
80107a7e:	74 59                	je     80107ad9 <freevm+0x69>
80107a80:	31 c9                	xor    %ecx,%ecx
80107a82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107a87:	89 f0                	mov    %esi,%eax
80107a89:	e8 e2 fa ff ff       	call   80107570 <deallocuvm.part.0>
80107a8e:	89 f3                	mov    %esi,%ebx
80107a90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a96:	eb 0f                	jmp    80107aa7 <freevm+0x37>
80107a98:	90                   	nop
80107a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aa0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107aa3:	39 fb                	cmp    %edi,%ebx
80107aa5:	74 23                	je     80107aca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107aa7:	8b 03                	mov    (%ebx),%eax
80107aa9:	a8 01                	test   $0x1,%al
80107aab:	74 f3                	je     80107aa0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107aad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ab2:	83 ec 0c             	sub    $0xc,%esp
80107ab5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ab8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107abd:	50                   	push   %eax
80107abe:	e8 1d aa ff ff       	call   801024e0 <kfree>
80107ac3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ac6:	39 fb                	cmp    %edi,%ebx
80107ac8:	75 dd                	jne    80107aa7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107aca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad0:	5b                   	pop    %ebx
80107ad1:	5e                   	pop    %esi
80107ad2:	5f                   	pop    %edi
80107ad3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107ad4:	e9 07 aa ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107ad9:	83 ec 0c             	sub    $0xc,%esp
80107adc:	68 95 89 10 80       	push   $0x80108995
80107ae1:	e8 aa 88 ff ff       	call   80100390 <panic>
80107ae6:	8d 76 00             	lea    0x0(%esi),%esi
80107ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107af0 <setupkvm>:
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	56                   	push   %esi
80107af4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107af5:	e8 96 ab ff ff       	call   80102690 <kalloc>
80107afa:	85 c0                	test   %eax,%eax
80107afc:	89 c6                	mov    %eax,%esi
80107afe:	74 42                	je     80107b42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107b00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b03:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107b08:	68 00 10 00 00       	push   $0x1000
80107b0d:	6a 00                	push   $0x0
80107b0f:	50                   	push   %eax
80107b10:	e8 2b d4 ff ff       	call   80104f40 <memset>
80107b15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107b18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107b1e:	83 ec 08             	sub    $0x8,%esp
80107b21:	8b 13                	mov    (%ebx),%edx
80107b23:	ff 73 0c             	pushl  0xc(%ebx)
80107b26:	50                   	push   %eax
80107b27:	29 c1                	sub    %eax,%ecx
80107b29:	89 f0                	mov    %esi,%eax
80107b2b:	e8 b0 f9 ff ff       	call   801074e0 <mappages>
80107b30:	83 c4 10             	add    $0x10,%esp
80107b33:	85 c0                	test   %eax,%eax
80107b35:	78 19                	js     80107b50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b37:	83 c3 10             	add    $0x10,%ebx
80107b3a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107b40:	75 d6                	jne    80107b18 <setupkvm+0x28>
}
80107b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b45:	89 f0                	mov    %esi,%eax
80107b47:	5b                   	pop    %ebx
80107b48:	5e                   	pop    %esi
80107b49:	5d                   	pop    %ebp
80107b4a:	c3                   	ret    
80107b4b:	90                   	nop
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107b50:	83 ec 0c             	sub    $0xc,%esp
80107b53:	56                   	push   %esi
      return 0;
80107b54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b56:	e8 15 ff ff ff       	call   80107a70 <freevm>
      return 0;
80107b5b:	83 c4 10             	add    $0x10,%esp
}
80107b5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b61:	89 f0                	mov    %esi,%eax
80107b63:	5b                   	pop    %ebx
80107b64:	5e                   	pop    %esi
80107b65:	5d                   	pop    %ebp
80107b66:	c3                   	ret    
80107b67:	89 f6                	mov    %esi,%esi
80107b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b70 <kvmalloc>:
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b76:	e8 75 ff ff ff       	call   80107af0 <setupkvm>
80107b7b:	a3 44 8f 11 80       	mov    %eax,0x80118f44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b80:	05 00 00 00 80       	add    $0x80000000,%eax
80107b85:	0f 22 d8             	mov    %eax,%cr3
}
80107b88:	c9                   	leave  
80107b89:	c3                   	ret    
80107b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b91:	31 c9                	xor    %ecx,%ecx
{
80107b93:	89 e5                	mov    %esp,%ebp
80107b95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b98:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b9e:	e8 bd f8 ff ff       	call   80107460 <walkpgdir>
  if(pte == 0)
80107ba3:	85 c0                	test   %eax,%eax
80107ba5:	74 05                	je     80107bac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ba7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107baa:	c9                   	leave  
80107bab:	c3                   	ret    
    panic("clearpteu");
80107bac:	83 ec 0c             	sub    $0xc,%esp
80107baf:	68 a6 89 10 80       	push   $0x801089a6
80107bb4:	e8 d7 87 ff ff       	call   80100390 <panic>
80107bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bc0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	57                   	push   %edi
80107bc4:	56                   	push   %esi
80107bc5:	53                   	push   %ebx
80107bc6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107bc9:	e8 22 ff ff ff       	call   80107af0 <setupkvm>
80107bce:	85 c0                	test   %eax,%eax
80107bd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107bd3:	0f 84 9f 00 00 00    	je     80107c78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107bdc:	85 c9                	test   %ecx,%ecx
80107bde:	0f 84 94 00 00 00    	je     80107c78 <copyuvm+0xb8>
80107be4:	31 ff                	xor    %edi,%edi
80107be6:	eb 4a                	jmp    80107c32 <copyuvm+0x72>
80107be8:	90                   	nop
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107bf0:	83 ec 04             	sub    $0x4,%esp
80107bf3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107bf9:	68 00 10 00 00       	push   $0x1000
80107bfe:	53                   	push   %ebx
80107bff:	50                   	push   %eax
80107c00:	e8 eb d3 ff ff       	call   80104ff0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107c05:	58                   	pop    %eax
80107c06:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c11:	5a                   	pop    %edx
80107c12:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c15:	50                   	push   %eax
80107c16:	89 fa                	mov    %edi,%edx
80107c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c1b:	e8 c0 f8 ff ff       	call   801074e0 <mappages>
80107c20:	83 c4 10             	add    $0x10,%esp
80107c23:	85 c0                	test   %eax,%eax
80107c25:	78 61                	js     80107c88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107c27:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107c2d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107c30:	76 46                	jbe    80107c78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c32:	8b 45 08             	mov    0x8(%ebp),%eax
80107c35:	31 c9                	xor    %ecx,%ecx
80107c37:	89 fa                	mov    %edi,%edx
80107c39:	e8 22 f8 ff ff       	call   80107460 <walkpgdir>
80107c3e:	85 c0                	test   %eax,%eax
80107c40:	74 61                	je     80107ca3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107c42:	8b 00                	mov    (%eax),%eax
80107c44:	a8 01                	test   $0x1,%al
80107c46:	74 4e                	je     80107c96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107c48:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107c4a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107c4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107c58:	e8 33 aa ff ff       	call   80102690 <kalloc>
80107c5d:	85 c0                	test   %eax,%eax
80107c5f:	89 c6                	mov    %eax,%esi
80107c61:	75 8d                	jne    80107bf0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107c63:	83 ec 0c             	sub    $0xc,%esp
80107c66:	ff 75 e0             	pushl  -0x20(%ebp)
80107c69:	e8 02 fe ff ff       	call   80107a70 <freevm>
  return 0;
80107c6e:	83 c4 10             	add    $0x10,%esp
80107c71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c7e:	5b                   	pop    %ebx
80107c7f:	5e                   	pop    %esi
80107c80:	5f                   	pop    %edi
80107c81:	5d                   	pop    %ebp
80107c82:	c3                   	ret    
80107c83:	90                   	nop
80107c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107c88:	83 ec 0c             	sub    $0xc,%esp
80107c8b:	56                   	push   %esi
80107c8c:	e8 4f a8 ff ff       	call   801024e0 <kfree>
      goto bad;
80107c91:	83 c4 10             	add    $0x10,%esp
80107c94:	eb cd                	jmp    80107c63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107c96:	83 ec 0c             	sub    $0xc,%esp
80107c99:	68 ca 89 10 80       	push   $0x801089ca
80107c9e:	e8 ed 86 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107ca3:	83 ec 0c             	sub    $0xc,%esp
80107ca6:	68 b0 89 10 80       	push   $0x801089b0
80107cab:	e8 e0 86 ff ff       	call   80100390 <panic>

80107cb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107cb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cb1:	31 c9                	xor    %ecx,%ecx
{
80107cb3:	89 e5                	mov    %esp,%ebp
80107cb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cbe:	e8 9d f7 ff ff       	call   80107460 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107cc3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107cc5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107cc6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ccd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cd0:	05 00 00 00 80       	add    $0x80000000,%eax
80107cd5:	83 fa 05             	cmp    $0x5,%edx
80107cd8:	ba 00 00 00 00       	mov    $0x0,%edx
80107cdd:	0f 45 c2             	cmovne %edx,%eax
}
80107ce0:	c3                   	ret    
80107ce1:	eb 0d                	jmp    80107cf0 <copyout>
80107ce3:	90                   	nop
80107ce4:	90                   	nop
80107ce5:	90                   	nop
80107ce6:	90                   	nop
80107ce7:	90                   	nop
80107ce8:	90                   	nop
80107ce9:	90                   	nop
80107cea:	90                   	nop
80107ceb:	90                   	nop
80107cec:	90                   	nop
80107ced:	90                   	nop
80107cee:	90                   	nop
80107cef:	90                   	nop

80107cf0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	57                   	push   %edi
80107cf4:	56                   	push   %esi
80107cf5:	53                   	push   %ebx
80107cf6:	83 ec 1c             	sub    $0x1c,%esp
80107cf9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107d02:	85 db                	test   %ebx,%ebx
80107d04:	75 40                	jne    80107d46 <copyout+0x56>
80107d06:	eb 70                	jmp    80107d78 <copyout+0x88>
80107d08:	90                   	nop
80107d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d13:	89 f1                	mov    %esi,%ecx
80107d15:	29 d1                	sub    %edx,%ecx
80107d17:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107d1d:	39 d9                	cmp    %ebx,%ecx
80107d1f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107d22:	29 f2                	sub    %esi,%edx
80107d24:	83 ec 04             	sub    $0x4,%esp
80107d27:	01 d0                	add    %edx,%eax
80107d29:	51                   	push   %ecx
80107d2a:	57                   	push   %edi
80107d2b:	50                   	push   %eax
80107d2c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107d2f:	e8 bc d2 ff ff       	call   80104ff0 <memmove>
    len -= n;
    buf += n;
80107d34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107d37:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107d3a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107d40:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107d42:	29 cb                	sub    %ecx,%ebx
80107d44:	74 32                	je     80107d78 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107d46:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d48:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107d4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107d4e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d54:	56                   	push   %esi
80107d55:	ff 75 08             	pushl  0x8(%ebp)
80107d58:	e8 53 ff ff ff       	call   80107cb0 <uva2ka>
    if(pa0 == 0)
80107d5d:	83 c4 10             	add    $0x10,%esp
80107d60:	85 c0                	test   %eax,%eax
80107d62:	75 ac                	jne    80107d10 <copyout+0x20>
  }
  return 0;
}
80107d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d6c:	5b                   	pop    %ebx
80107d6d:	5e                   	pop    %esi
80107d6e:	5f                   	pop    %edi
80107d6f:	5d                   	pop    %ebp
80107d70:	c3                   	ret    
80107d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d7b:	31 c0                	xor    %eax,%eax
}
80107d7d:	5b                   	pop    %ebx
80107d7e:	5e                   	pop    %esi
80107d7f:	5f                   	pop    %edi
80107d80:	5d                   	pop    %ebp
80107d81:	c3                   	ret    
