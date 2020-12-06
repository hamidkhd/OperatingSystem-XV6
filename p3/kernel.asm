
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
8010002d:	b8 90 30 10 80       	mov    $0x80103090,%eax
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
8010004c:	68 20 81 10 80       	push   $0x80108120
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 b5 4f 00 00       	call   80105010 <initlock>
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
80100092:	68 27 81 10 80       	push   $0x80108127
80100097:	50                   	push   %eax
80100098:	e8 43 4e 00 00       	call   80104ee0 <initsleeplock>
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
801000e4:	e8 67 50 00 00       	call   80105150 <acquire>
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
80100162:	e8 a9 50 00 00       	call   80105210 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4d 00 00       	call   80104f20 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 8d 21 00 00       	call   80102310 <iderw>
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
80100193:	68 2e 81 10 80       	push   $0x8010812e
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
801001ae:	e8 0d 4e 00 00       	call   80104fc0 <holdingsleep>
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
801001c4:	e9 47 21 00 00       	jmp    80102310 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 81 10 80       	push   $0x8010813f
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
801001ef:	e8 cc 4d 00 00       	call   80104fc0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 4d 00 00       	call   80104f80 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 4f 00 00       	call   80105150 <acquire>
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
8010025c:	e9 af 4f 00 00       	jmp    80105210 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 81 10 80       	push   $0x80108146
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
80100280:	e8 cb 16 00 00       	call   80101950 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 4e 00 00       	call   80105150 <acquire>
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
801002c5:	e8 26 42 00 00       	call   801044f0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 37 00 00       	call   80103ac0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 1c 4f 00 00       	call   80105210 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 74 15 00 00       	call   80101870 <ilock>
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
8010034d:	e8 be 4e 00 00       	call   80105210 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 16 15 00 00       	call   80101870 <ilock>
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
801003a9:	e8 72 25 00 00       	call   80102920 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 81 10 80       	push   $0x8010814d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 e8 87 10 80 	movl   $0x801087e8,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 4c 00 00       	call   80105030 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 81 10 80       	push   $0x80108161
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
8010043a:	e8 e1 68 00 00       	call   80106d20 <uartputc>
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
801004ec:	e8 2f 68 00 00       	call   80106d20 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 68 00 00       	call   80106d20 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 68 00 00       	call   80106d20 <uartputc>
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
80100524:	e8 e7 4d 00 00       	call   80105310 <memmove>
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
80100541:	e8 1a 4d 00 00       	call   80105260 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 81 10 80       	push   $0x80108165
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
801005b1:	0f b6 92 90 81 10 80 	movzbl -0x7fef7e70(%edx),%edx
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
8010060f:	e8 3c 13 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 4b 00 00       	call   80105150 <acquire>
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
80100647:	e8 c4 4b 00 00       	call   80105210 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 12 00 00       	call   80101870 <ilock>

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
8010071f:	e8 ec 4a 00 00       	call   80105210 <release>
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
801007d0:	ba 78 81 10 80       	mov    $0x80108178,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 5b 49 00 00       	call   80105150 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 81 10 80       	push   $0x8010817f
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
80100821:	e8 2a 49 00 00       	call   80105150 <acquire>
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
801008d0:	e8 3b 49 00 00       	call   80105210 <release>
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
80100b21:	e8 8a 3b 00 00       	call   801046b0 <wakeup>
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
80100b67:	e9 24 3c 00 00       	jmp    80104790 <procdump>
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
80100b96:	68 88 81 10 80       	push   $0x80108188
80100b9b:	68 20 b5 10 80       	push   $0x8010b520
80100ba0:	e8 6b 44 00 00       	call   80105010 <initlock>

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
80100bc9:	e8 f2 18 00 00       	call   801024c0 <ioapicenable>
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
80100bec:	e8 cf 2e 00 00       	call   80103ac0 <myproc>
80100bf1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100bf7:	e8 94 21 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100bfc:	83 ec 0c             	sub    $0xc,%esp
80100bff:	ff 75 08             	pushl  0x8(%ebp)
80100c02:	e8 c9 14 00 00       	call   801020d0 <namei>
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
80100c18:	e8 53 0c 00 00       	call   80101870 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c23:	6a 34                	push   $0x34
80100c25:	6a 00                	push   $0x0
80100c27:	50                   	push   %eax
80100c28:	53                   	push   %ebx
80100c29:	e8 22 0f 00 00       	call   80101b50 <readi>
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
80100c3a:	e8 c1 0e 00 00       	call   80101b00 <iunlockput>
    end_op();
80100c3f:	e8 bc 21 00 00       	call   80102e00 <end_op>
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
80100c64:	e8 07 72 00 00       	call   80107e70 <setupkvm>
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
80100c89:	0f 84 b2 02 00 00    	je     80100f41 <exec+0x361>
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
80100cc6:	e8 c5 6f 00 00       	call   80107c90 <allocuvm>
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
80100cf8:	e8 d3 6e 00 00       	call   80107bd0 <loaduvm>
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
80100d28:	e8 23 0e 00 00       	call   80101b50 <readi>
80100d2d:	83 c4 10             	add    $0x10,%esp
80100d30:	83 f8 20             	cmp    $0x20,%eax
80100d33:	0f 84 5f ff ff ff    	je     80100c98 <exec+0xb8>
    freevm(pgdir);
80100d39:	83 ec 0c             	sub    $0xc,%esp
80100d3c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d42:	e8 a9 70 00 00       	call   80107df0 <freevm>
80100d47:	83 c4 10             	add    $0x10,%esp
80100d4a:	e9 e7 fe ff ff       	jmp    80100c36 <exec+0x56>
80100d4f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d55:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100d5b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d61:	83 ec 0c             	sub    $0xc,%esp
80100d64:	53                   	push   %ebx
80100d65:	e8 96 0d 00 00       	call   80101b00 <iunlockput>
  end_op();
80100d6a:	e8 91 20 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d6f:	83 c4 0c             	add    $0xc,%esp
80100d72:	56                   	push   %esi
80100d73:	57                   	push   %edi
80100d74:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d7a:	e8 11 6f 00 00       	call   80107c90 <allocuvm>
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	85 c0                	test   %eax,%eax
80100d84:	89 c6                	mov    %eax,%esi
80100d86:	75 3a                	jne    80100dc2 <exec+0x1e2>
    freevm(pgdir);
80100d88:	83 ec 0c             	sub    $0xc,%esp
80100d8b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d91:	e8 5a 70 00 00       	call   80107df0 <freevm>
80100d96:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d9e:	e9 a9 fe ff ff       	jmp    80100c4c <exec+0x6c>
    end_op();
80100da3:	e8 58 20 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100da8:	83 ec 0c             	sub    $0xc,%esp
80100dab:	68 a1 81 10 80       	push   $0x801081a1
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
80100dd6:	e8 35 71 00 00       	call   80107f10 <clearpteu>
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
80100e09:	e8 72 46 00 00       	call   80105480 <strlen>
80100e0e:	f7 d0                	not    %eax
80100e10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e15:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e1c:	e8 5f 46 00 00       	call   80105480 <strlen>
80100e21:	83 c0 01             	add    $0x1,%eax
80100e24:	50                   	push   %eax
80100e25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e2b:	53                   	push   %ebx
80100e2c:	56                   	push   %esi
80100e2d:	e8 3e 72 00 00       	call   80108070 <copyout>
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
80100e97:	e8 d4 71 00 00       	call   80108070 <copyout>
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
80100eda:	e8 61 45 00 00       	call   80105440 <safestrcpy>
  curproc->pgdir = pgdir;
80100edf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100ee5:	89 f9                	mov    %edi,%ecx
80100ee7:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100eea:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100eed:	89 31                	mov    %esi,(%ecx)
  curproc->priority /= 1000;
80100eef:	d9 05 b0 81 10 80    	flds   0x801081b0
  curproc->pgdir = pgdir;
80100ef5:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100ef8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100efe:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f01:	8b 41 18             	mov    0x18(%ecx),%eax
80100f04:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->lottery_ticket += 1000;
80100f07:	81 81 0c 01 00 00 e8 	addl   $0x3e8,0x10c(%ecx)
80100f0e:	03 00 00 
  curproc->priority /= 1000;
80100f11:	d8 b9 f8 00 00 00    	fdivrs 0xf8(%ecx)
  curproc->arrivt_ratio = 0.001;
80100f17:	c7 81 00 01 00 00 6f 	movl   $0x3a83126f,0x100(%ecx)
80100f1e:	12 83 3a 
  curproc->priority /= 1000;
80100f21:	d9 99 f8 00 00 00    	fstps  0xf8(%ecx)
  switchuvm(curproc);
80100f27:	89 0c 24             	mov    %ecx,(%esp)
80100f2a:	e8 11 6b 00 00       	call   80107a40 <switchuvm>
  freevm(oldpgdir);
80100f2f:	89 3c 24             	mov    %edi,(%esp)
80100f32:	e8 b9 6e 00 00       	call   80107df0 <freevm>
  return 0;
80100f37:	83 c4 10             	add    $0x10,%esp
80100f3a:	31 c0                	xor    %eax,%eax
80100f3c:	e9 0b fd ff ff       	jmp    80100c4c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f41:	be 00 20 00 00       	mov    $0x2000,%esi
80100f46:	e9 16 fe ff ff       	jmp    80100d61 <exec+0x181>
80100f4b:	66 90                	xchg   %ax,%ax
80100f4d:	66 90                	xchg   %ax,%ax
80100f4f:	90                   	nop

80100f50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f56:	68 b4 81 10 80       	push   $0x801081b4
80100f5b:	68 60 10 11 80       	push   $0x80111060
80100f60:	e8 ab 40 00 00       	call   80105010 <initlock>
}
80100f65:	83 c4 10             	add    $0x10,%esp
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f74:	bb 94 10 11 80       	mov    $0x80111094,%ebx
{
80100f79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f7c:	68 60 10 11 80       	push   $0x80111060
80100f81:	e8 ca 41 00 00       	call   80105150 <acquire>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb 10                	jmp    80100f9b <filealloc+0x2b>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f90:	83 c3 18             	add    $0x18,%ebx
80100f93:	81 fb f4 19 11 80    	cmp    $0x801119f4,%ebx
80100f99:	73 25                	jae    80100fc0 <filealloc+0x50>
    if(f->ref == 0){
80100f9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f9e:	85 c0                	test   %eax,%eax
80100fa0:	75 ee                	jne    80100f90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100fa2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100fa5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100fac:	68 60 10 11 80       	push   $0x80111060
80100fb1:	e8 5a 42 00 00       	call   80105210 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fb6:	89 d8                	mov    %ebx,%eax
      return f;
80100fb8:	83 c4 10             	add    $0x10,%esp
}
80100fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fbe:	c9                   	leave  
80100fbf:	c3                   	ret    
  release(&ftable.lock);
80100fc0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fc3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fc5:	68 60 10 11 80       	push   $0x80111060
80100fca:	e8 41 42 00 00       	call   80105210 <release>
}
80100fcf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fd1:	83 c4 10             	add    $0x10,%esp
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd7:	c9                   	leave  
80100fd8:	c3                   	ret    
80100fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 10             	sub    $0x10,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fea:	68 60 10 11 80       	push   $0x80111060
80100fef:	e8 5c 41 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80100ff4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ff7:	83 c4 10             	add    $0x10,%esp
80100ffa:	85 c0                	test   %eax,%eax
80100ffc:	7e 1a                	jle    80101018 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ffe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101001:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101004:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101007:	68 60 10 11 80       	push   $0x80111060
8010100c:	e8 ff 41 00 00       	call   80105210 <release>
  return f;
}
80101011:	89 d8                	mov    %ebx,%eax
80101013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101016:	c9                   	leave  
80101017:	c3                   	ret    
    panic("filedup");
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	68 bb 81 10 80       	push   $0x801081bb
80101020:	e8 6b f3 ff ff       	call   80100390 <panic>
80101025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101030 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 28             	sub    $0x28,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010103c:	68 60 10 11 80       	push   $0x80111060
80101041:	e8 0a 41 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80101046:	8b 43 04             	mov    0x4(%ebx),%eax
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	85 c0                	test   %eax,%eax
8010104e:	0f 8e 9b 00 00 00    	jle    801010ef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101054:	83 e8 01             	sub    $0x1,%eax
80101057:	85 c0                	test   %eax,%eax
80101059:	89 43 04             	mov    %eax,0x4(%ebx)
8010105c:	74 1a                	je     80101078 <fileclose+0x48>
    release(&ftable.lock);
8010105e:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101065:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101068:	5b                   	pop    %ebx
80101069:	5e                   	pop    %esi
8010106a:	5f                   	pop    %edi
8010106b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010106c:	e9 9f 41 00 00       	jmp    80105210 <release>
80101071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101078:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010107c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010107e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101081:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101084:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010108a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010108d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101090:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101098:	e8 73 41 00 00       	call   80105210 <release>
  if(ff.type == FD_PIPE)
8010109d:	83 c4 10             	add    $0x10,%esp
801010a0:	83 ff 01             	cmp    $0x1,%edi
801010a3:	74 13                	je     801010b8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801010a5:	83 ff 02             	cmp    $0x2,%edi
801010a8:	74 26                	je     801010d0 <fileclose+0xa0>
}
801010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ad:	5b                   	pop    %ebx
801010ae:	5e                   	pop    %esi
801010af:	5f                   	pop    %edi
801010b0:	5d                   	pop    %ebp
801010b1:	c3                   	ret    
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801010b8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010bc:	83 ec 08             	sub    $0x8,%esp
801010bf:	53                   	push   %ebx
801010c0:	56                   	push   %esi
801010c1:	e8 7a 24 00 00       	call   80103540 <pipeclose>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	eb df                	jmp    801010aa <fileclose+0x7a>
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801010d0:	e8 bb 1c 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
801010d5:	83 ec 0c             	sub    $0xc,%esp
801010d8:	ff 75 e0             	pushl  -0x20(%ebp)
801010db:	e8 c0 08 00 00       	call   801019a0 <iput>
    end_op();
801010e0:	83 c4 10             	add    $0x10,%esp
}
801010e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
    end_op();
801010ea:	e9 11 1d 00 00       	jmp    80102e00 <end_op>
    panic("fileclose");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 c3 81 10 80       	push   $0x801081c3
801010f7:	e8 94 f2 ff ff       	call   80100390 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	53                   	push   %ebx
80101104:	83 ec 04             	sub    $0x4,%esp
80101107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010110a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010110d:	75 31                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 73 10             	pushl  0x10(%ebx)
80101115:	e8 56 07 00 00       	call   80101870 <ilock>
    stati(f->ip, st);
8010111a:	58                   	pop    %eax
8010111b:	5a                   	pop    %edx
8010111c:	ff 75 0c             	pushl  0xc(%ebp)
8010111f:	ff 73 10             	pushl  0x10(%ebx)
80101122:	e8 f9 09 00 00       	call   80101b20 <stati>
    iunlock(f->ip);
80101127:	59                   	pop    %ecx
80101128:	ff 73 10             	pushl  0x10(%ebx)
8010112b:	e8 20 08 00 00       	call   80101950 <iunlock>
    return 0;
80101130:	83 c4 10             	add    $0x10,%esp
80101133:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101145:	eb ee                	jmp    80101135 <filestat+0x35>
80101147:	89 f6                	mov    %esi,%esi
80101149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101150 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010115c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010115f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101162:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101166:	74 60                	je     801011c8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101168:	8b 03                	mov    (%ebx),%eax
8010116a:	83 f8 01             	cmp    $0x1,%eax
8010116d:	74 41                	je     801011b0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116f:	83 f8 02             	cmp    $0x2,%eax
80101172:	75 5b                	jne    801011cf <fileread+0x7f>
    ilock(f->ip);
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	ff 73 10             	pushl  0x10(%ebx)
8010117a:	e8 f1 06 00 00       	call   80101870 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010117f:	57                   	push   %edi
80101180:	ff 73 14             	pushl  0x14(%ebx)
80101183:	56                   	push   %esi
80101184:	ff 73 10             	pushl  0x10(%ebx)
80101187:	e8 c4 09 00 00       	call   80101b50 <readi>
8010118c:	83 c4 20             	add    $0x20,%esp
8010118f:	85 c0                	test   %eax,%eax
80101191:	89 c6                	mov    %eax,%esi
80101193:	7e 03                	jle    80101198 <fileread+0x48>
      f->off += r;
80101195:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	ff 73 10             	pushl  0x10(%ebx)
8010119e:	e8 ad 07 00 00       	call   80101950 <iunlock>
    return r;
801011a3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	89 f0                	mov    %esi,%eax
801011ab:	5b                   	pop    %ebx
801011ac:	5e                   	pop    %esi
801011ad:	5f                   	pop    %edi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b9:	5b                   	pop    %ebx
801011ba:	5e                   	pop    %esi
801011bb:	5f                   	pop    %edi
801011bc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011bd:	e9 2e 25 00 00       	jmp    801036f0 <piperead>
801011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011cd:	eb d7                	jmp    801011a6 <fileread+0x56>
  panic("fileread");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 cd 81 10 80       	push   $0x801081cd
801011d7:	e8 b4 f1 ff ff       	call   80100390 <panic>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
801011e9:	8b 75 08             	mov    0x8(%ebp),%esi
801011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801011ef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011f6:	8b 45 10             	mov    0x10(%ebp),%eax
801011f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011fc:	0f 84 aa 00 00 00    	je     801012ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101202:	8b 06                	mov    (%esi),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	0f 84 c3 00 00 00    	je     801012d0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010120d:	83 f8 02             	cmp    $0x2,%eax
80101210:	0f 85 d9 00 00 00    	jne    801012ef <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101219:	31 ff                	xor    %edi,%edi
    while(i < n){
8010121b:	85 c0                	test   %eax,%eax
8010121d:	7f 34                	jg     80101253 <filewrite+0x73>
8010121f:	e9 9c 00 00 00       	jmp    801012c0 <filewrite+0xe0>
80101224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101228:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010122b:	83 ec 0c             	sub    $0xc,%esp
8010122e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101231:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101234:	e8 17 07 00 00       	call   80101950 <iunlock>
      end_op();
80101239:	e8 c2 1b 00 00       	call   80102e00 <end_op>
8010123e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101241:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101244:	39 c3                	cmp    %eax,%ebx
80101246:	0f 85 96 00 00 00    	jne    801012e2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010124c:	01 df                	add    %ebx,%edi
    while(i < n){
8010124e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101251:	7e 6d                	jle    801012c0 <filewrite+0xe0>
      int n1 = n - i;
80101253:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101256:	b8 00 06 00 00       	mov    $0x600,%eax
8010125b:	29 fb                	sub    %edi,%ebx
8010125d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101263:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101266:	e8 25 1b 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
8010126b:	83 ec 0c             	sub    $0xc,%esp
8010126e:	ff 76 10             	pushl  0x10(%esi)
80101271:	e8 fa 05 00 00       	call   80101870 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101276:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101279:	53                   	push   %ebx
8010127a:	ff 76 14             	pushl  0x14(%esi)
8010127d:	01 f8                	add    %edi,%eax
8010127f:	50                   	push   %eax
80101280:	ff 76 10             	pushl  0x10(%esi)
80101283:	e8 c8 09 00 00       	call   80101c50 <writei>
80101288:	83 c4 20             	add    $0x20,%esp
8010128b:	85 c0                	test   %eax,%eax
8010128d:	7f 99                	jg     80101228 <filewrite+0x48>
      iunlock(f->ip);
8010128f:	83 ec 0c             	sub    $0xc,%esp
80101292:	ff 76 10             	pushl  0x10(%esi)
80101295:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101298:	e8 b3 06 00 00       	call   80101950 <iunlock>
      end_op();
8010129d:	e8 5e 1b 00 00       	call   80102e00 <end_op>
      if(r < 0)
801012a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012a5:	83 c4 10             	add    $0x10,%esp
801012a8:	85 c0                	test   %eax,%eax
801012aa:	74 98                	je     80101244 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801012ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801012af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801012b4:	89 f8                	mov    %edi,%eax
801012b6:	5b                   	pop    %ebx
801012b7:	5e                   	pop    %esi
801012b8:	5f                   	pop    %edi
801012b9:	5d                   	pop    %ebp
801012ba:	c3                   	ret    
801012bb:	90                   	nop
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801012c0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012c3:	75 e7                	jne    801012ac <filewrite+0xcc>
}
801012c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c8:	89 f8                	mov    %edi,%eax
801012ca:	5b                   	pop    %ebx
801012cb:	5e                   	pop    %esi
801012cc:	5f                   	pop    %edi
801012cd:	5d                   	pop    %ebp
801012ce:	c3                   	ret    
801012cf:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801012d0:	8b 46 0c             	mov    0xc(%esi),%eax
801012d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d9:	5b                   	pop    %ebx
801012da:	5e                   	pop    %esi
801012db:	5f                   	pop    %edi
801012dc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012dd:	e9 fe 22 00 00       	jmp    801035e0 <pipewrite>
        panic("short filewrite");
801012e2:	83 ec 0c             	sub    $0xc,%esp
801012e5:	68 d6 81 10 80       	push   $0x801081d6
801012ea:	e8 a1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	68 dc 81 10 80       	push   $0x801081dc
801012f7:	e8 94 f0 ff ff       	call   80100390 <panic>
801012fc:	66 90                	xchg   %ax,%ax
801012fe:	66 90                	xchg   %ax,%ax

80101300 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	56                   	push   %esi
80101304:	53                   	push   %ebx
80101305:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101307:	c1 ea 0c             	shr    $0xc,%edx
8010130a:	03 15 78 1a 11 80    	add    0x80111a78,%edx
80101310:	83 ec 08             	sub    $0x8,%esp
80101313:	52                   	push   %edx
80101314:	50                   	push   %eax
80101315:	e8 b6 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010131a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010131c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010131f:	ba 01 00 00 00       	mov    $0x1,%edx
80101324:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101327:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010132d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101330:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101332:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101337:	85 d1                	test   %edx,%ecx
80101339:	74 25                	je     80101360 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010133b:	f7 d2                	not    %edx
8010133d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010133f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101342:	21 ca                	and    %ecx,%edx
80101344:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101348:	56                   	push   %esi
80101349:	e8 12 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010134e:	89 34 24             	mov    %esi,(%esp)
80101351:	e8 8a ee ff ff       	call   801001e0 <brelse>
}
80101356:	83 c4 10             	add    $0x10,%esp
80101359:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5d                   	pop    %ebp
8010135f:	c3                   	ret    
    panic("freeing free block");
80101360:	83 ec 0c             	sub    $0xc,%esp
80101363:	68 e6 81 10 80       	push   $0x801081e6
80101368:	e8 23 f0 ff ff       	call   80100390 <panic>
8010136d:	8d 76 00             	lea    0x0(%esi),%esi

80101370 <balloc>:
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101379:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
{
8010137f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101382:	85 c9                	test   %ecx,%ecx
80101384:	0f 84 87 00 00 00    	je     80101411 <balloc+0xa1>
8010138a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101391:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101394:	83 ec 08             	sub    $0x8,%esp
80101397:	89 f0                	mov    %esi,%eax
80101399:	c1 f8 0c             	sar    $0xc,%eax
8010139c:	03 05 78 1a 11 80    	add    0x80111a78,%eax
801013a2:	50                   	push   %eax
801013a3:	ff 75 d8             	pushl  -0x28(%ebp)
801013a6:	e8 25 ed ff ff       	call   801000d0 <bread>
801013ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013ae:	a1 60 1a 11 80       	mov    0x80111a60,%eax
801013b3:	83 c4 10             	add    $0x10,%esp
801013b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013b9:	31 c0                	xor    %eax,%eax
801013bb:	eb 2f                	jmp    801013ec <balloc+0x7c>
801013bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013c0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013c5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013ca:	83 e1 07             	and    $0x7,%ecx
801013cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013cf:	89 c1                	mov    %eax,%ecx
801013d1:	c1 f9 03             	sar    $0x3,%ecx
801013d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013d9:	85 df                	test   %ebx,%edi
801013db:	89 fa                	mov    %edi,%edx
801013dd:	74 41                	je     80101420 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013df:	83 c0 01             	add    $0x1,%eax
801013e2:	83 c6 01             	add    $0x1,%esi
801013e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ea:	74 05                	je     801013f1 <balloc+0x81>
801013ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013ef:	77 cf                	ja     801013c0 <balloc+0x50>
    brelse(bp);
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013f7:	e8 e4 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101409:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
8010140f:	77 80                	ja     80101391 <balloc+0x21>
  panic("balloc: out of blocks");
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	68 f9 81 10 80       	push   $0x801081f9
80101419:	e8 72 ef ff ff       	call   80100390 <panic>
8010141e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101423:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101426:	09 da                	or     %ebx,%edx
80101428:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010142c:	57                   	push   %edi
8010142d:	e8 2e 1b 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101432:	89 3c 24             	mov    %edi,(%esp)
80101435:	e8 a6 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010143a:	58                   	pop    %eax
8010143b:	5a                   	pop    %edx
8010143c:	56                   	push   %esi
8010143d:	ff 75 d8             	pushl  -0x28(%ebp)
80101440:	e8 8b ec ff ff       	call   801000d0 <bread>
80101445:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101447:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144a:	83 c4 0c             	add    $0xc,%esp
8010144d:	68 00 02 00 00       	push   $0x200
80101452:	6a 00                	push   $0x0
80101454:	50                   	push   %eax
80101455:	e8 06 3e 00 00       	call   80105260 <memset>
  log_write(bp);
8010145a:	89 1c 24             	mov    %ebx,(%esp)
8010145d:	e8 fe 1a 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101462:	89 1c 24             	mov    %ebx,(%esp)
80101465:	e8 76 ed ff ff       	call   801001e0 <brelse>
}
8010146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146d:	89 f0                	mov    %esi,%eax
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5f                   	pop    %edi
80101472:	5d                   	pop    %ebp
80101473:	c3                   	ret    
80101474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010147a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101480 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	57                   	push   %edi
80101484:	56                   	push   %esi
80101485:	53                   	push   %ebx
80101486:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101488:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010148a:	bb b4 1a 11 80       	mov    $0x80111ab4,%ebx
{
8010148f:	83 ec 28             	sub    $0x28,%esp
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101495:	68 80 1a 11 80       	push   $0x80111a80
8010149a:	e8 b1 3c 00 00       	call   80105150 <acquire>
8010149f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014a5:	eb 17                	jmp    801014be <iget+0x3e>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801014b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014b6:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
801014bc:	73 22                	jae    801014e0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014c1:	85 c9                	test   %ecx,%ecx
801014c3:	7e 04                	jle    801014c9 <iget+0x49>
801014c5:	39 3b                	cmp    %edi,(%ebx)
801014c7:	74 4f                	je     80101518 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014c9:	85 f6                	test   %esi,%esi
801014cb:	75 e3                	jne    801014b0 <iget+0x30>
801014cd:	85 c9                	test   %ecx,%ecx
801014cf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014d8:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
801014de:	72 de                	jb     801014be <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014e0:	85 f6                	test   %esi,%esi
801014e2:	74 5b                	je     8010153f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014e4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014e7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014e9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014ec:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014f3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014fa:	68 80 1a 11 80       	push   $0x80111a80
801014ff:	e8 0c 3d 00 00       	call   80105210 <release>

  return ip;
80101504:	83 c4 10             	add    $0x10,%esp
}
80101507:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150a:	89 f0                	mov    %esi,%eax
8010150c:	5b                   	pop    %ebx
8010150d:	5e                   	pop    %esi
8010150e:	5f                   	pop    %edi
8010150f:	5d                   	pop    %ebp
80101510:	c3                   	ret    
80101511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101518:	39 53 04             	cmp    %edx,0x4(%ebx)
8010151b:	75 ac                	jne    801014c9 <iget+0x49>
      release(&icache.lock);
8010151d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101520:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101523:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101525:	68 80 1a 11 80       	push   $0x80111a80
      ip->ref++;
8010152a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010152d:	e8 de 3c 00 00       	call   80105210 <release>
      return ip;
80101532:	83 c4 10             	add    $0x10,%esp
}
80101535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101538:	89 f0                	mov    %esi,%eax
8010153a:	5b                   	pop    %ebx
8010153b:	5e                   	pop    %esi
8010153c:	5f                   	pop    %edi
8010153d:	5d                   	pop    %ebp
8010153e:	c3                   	ret    
    panic("iget: no inodes");
8010153f:	83 ec 0c             	sub    $0xc,%esp
80101542:	68 0f 82 10 80       	push   $0x8010820f
80101547:	e8 44 ee ff ff       	call   80100390 <panic>
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	89 c6                	mov    %eax,%esi
80101558:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010155b:	83 fa 0b             	cmp    $0xb,%edx
8010155e:	77 18                	ja     80101578 <bmap+0x28>
80101560:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101563:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101566:	85 db                	test   %ebx,%ebx
80101568:	74 76                	je     801015e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156d:	89 d8                	mov    %ebx,%eax
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5f                   	pop    %edi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101578:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010157b:	83 fb 7f             	cmp    $0x7f,%ebx
8010157e:	0f 87 90 00 00 00    	ja     80101614 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101584:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010158a:	8b 00                	mov    (%eax),%eax
8010158c:	85 d2                	test   %edx,%edx
8010158e:	74 70                	je     80101600 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	52                   	push   %edx
80101594:	50                   	push   %eax
80101595:	e8 36 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010159a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010159e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801015a1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801015a3:	8b 1a                	mov    (%edx),%ebx
801015a5:	85 db                	test   %ebx,%ebx
801015a7:	75 1d                	jne    801015c6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801015a9:	8b 06                	mov    (%esi),%eax
801015ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801015ae:	e8 bd fd ff ff       	call   80101370 <balloc>
801015b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801015b6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015b9:	89 c3                	mov    %eax,%ebx
801015bb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801015bd:	57                   	push   %edi
801015be:	e8 9d 19 00 00       	call   80102f60 <log_write>
801015c3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801015c6:	83 ec 0c             	sub    $0xc,%esp
801015c9:	57                   	push   %edi
801015ca:	e8 11 ec ff ff       	call   801001e0 <brelse>
801015cf:	83 c4 10             	add    $0x10,%esp
}
801015d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d5:	89 d8                	mov    %ebx,%eax
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5f                   	pop    %edi
801015da:	5d                   	pop    %ebp
801015db:	c3                   	ret    
801015dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801015e0:	8b 00                	mov    (%eax),%eax
801015e2:	e8 89 fd ff ff       	call   80101370 <balloc>
801015e7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801015ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801015ed:	89 c3                	mov    %eax,%ebx
}
801015ef:	89 d8                	mov    %ebx,%eax
801015f1:	5b                   	pop    %ebx
801015f2:	5e                   	pop    %esi
801015f3:	5f                   	pop    %edi
801015f4:	5d                   	pop    %ebp
801015f5:	c3                   	ret    
801015f6:	8d 76 00             	lea    0x0(%esi),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101600:	e8 6b fd ff ff       	call   80101370 <balloc>
80101605:	89 c2                	mov    %eax,%edx
80101607:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010160d:	8b 06                	mov    (%esi),%eax
8010160f:	e9 7c ff ff ff       	jmp    80101590 <bmap+0x40>
  panic("bmap: out of range");
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	68 1f 82 10 80       	push   $0x8010821f
8010161c:	e8 6f ed ff ff       	call   80100390 <panic>
80101621:	eb 0d                	jmp    80101630 <readsb>
80101623:	90                   	nop
80101624:	90                   	nop
80101625:	90                   	nop
80101626:	90                   	nop
80101627:	90                   	nop
80101628:	90                   	nop
80101629:	90                   	nop
8010162a:	90                   	nop
8010162b:	90                   	nop
8010162c:	90                   	nop
8010162d:	90                   	nop
8010162e:	90                   	nop
8010162f:	90                   	nop

80101630 <readsb>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	6a 01                	push   $0x1
8010163d:	ff 75 08             	pushl  0x8(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
80101645:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101647:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164a:	83 c4 0c             	add    $0xc,%esp
8010164d:	6a 1c                	push   $0x1c
8010164f:	50                   	push   %eax
80101650:	56                   	push   %esi
80101651:	e8 ba 3c 00 00       	call   80105310 <memmove>
  brelse(bp);
80101656:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101659:	83 c4 10             	add    $0x10,%esp
}
8010165c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5d                   	pop    %ebp
  brelse(bp);
80101662:	e9 79 eb ff ff       	jmp    801001e0 <brelse>
80101667:	89 f6                	mov    %esi,%esi
80101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101670 <iinit>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	bb c0 1a 11 80       	mov    $0x80111ac0,%ebx
80101679:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010167c:	68 32 82 10 80       	push   $0x80108232
80101681:	68 80 1a 11 80       	push   $0x80111a80
80101686:	e8 85 39 00 00       	call   80105010 <initlock>
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 39 82 10 80       	push   $0x80108239
80101698:	53                   	push   %ebx
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010169f:	e8 3c 38 00 00       	call   80104ee0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	81 fb e0 36 11 80    	cmp    $0x801136e0,%ebx
801016ad:	75 e1                	jne    80101690 <iinit+0x20>
  readsb(dev, &sb);
801016af:	83 ec 08             	sub    $0x8,%esp
801016b2:	68 60 1a 11 80       	push   $0x80111a60
801016b7:	ff 75 08             	pushl  0x8(%ebp)
801016ba:	e8 71 ff ff ff       	call   80101630 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016bf:	ff 35 78 1a 11 80    	pushl  0x80111a78
801016c5:	ff 35 74 1a 11 80    	pushl  0x80111a74
801016cb:	ff 35 70 1a 11 80    	pushl  0x80111a70
801016d1:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
801016d7:	ff 35 68 1a 11 80    	pushl  0x80111a68
801016dd:	ff 35 64 1a 11 80    	pushl  0x80111a64
801016e3:	ff 35 60 1a 11 80    	pushl  0x80111a60
801016e9:	68 9c 82 10 80       	push   $0x8010829c
801016ee:	e8 6d ef ff ff       	call   80100660 <cprintf>
}
801016f3:	83 c4 30             	add    $0x30,%esp
801016f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f9:	c9                   	leave  
801016fa:	c3                   	ret    
801016fb:	90                   	nop
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <ialloc>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101709:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
{
80101710:	8b 45 0c             	mov    0xc(%ebp),%eax
80101713:	8b 75 08             	mov    0x8(%ebp),%esi
80101716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101719:	0f 86 91 00 00 00    	jbe    801017b0 <ialloc+0xb0>
8010171f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101724:	eb 21                	jmp    80101747 <ialloc+0x47>
80101726:	8d 76 00             	lea    0x0(%esi),%esi
80101729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101730:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101733:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101736:	57                   	push   %edi
80101737:	e8 a4 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010173c:	83 c4 10             	add    $0x10,%esp
8010173f:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
80101745:	76 69                	jbe    801017b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101747:	89 d8                	mov    %ebx,%eax
80101749:	83 ec 08             	sub    $0x8,%esp
8010174c:	c1 e8 03             	shr    $0x3,%eax
8010174f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101755:	50                   	push   %eax
80101756:	56                   	push   %esi
80101757:	e8 74 e9 ff ff       	call   801000d0 <bread>
8010175c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010175e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101760:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101763:	83 e0 07             	and    $0x7,%eax
80101766:	c1 e0 06             	shl    $0x6,%eax
80101769:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010176d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101771:	75 bd                	jne    80101730 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101773:	83 ec 04             	sub    $0x4,%esp
80101776:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101779:	6a 40                	push   $0x40
8010177b:	6a 00                	push   $0x0
8010177d:	51                   	push   %ecx
8010177e:	e8 dd 3a 00 00       	call   80105260 <memset>
      dip->type = type;
80101783:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101787:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010178a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010178d:	89 3c 24             	mov    %edi,(%esp)
80101790:	e8 cb 17 00 00       	call   80102f60 <log_write>
      brelse(bp);
80101795:	89 3c 24             	mov    %edi,(%esp)
80101798:	e8 43 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010179d:	83 c4 10             	add    $0x10,%esp
}
801017a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017a3:	89 da                	mov    %ebx,%edx
801017a5:	89 f0                	mov    %esi,%eax
}
801017a7:	5b                   	pop    %ebx
801017a8:	5e                   	pop    %esi
801017a9:	5f                   	pop    %edi
801017aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801017ab:	e9 d0 fc ff ff       	jmp    80101480 <iget>
  panic("ialloc: no inodes");
801017b0:	83 ec 0c             	sub    $0xc,%esp
801017b3:	68 3f 82 10 80       	push   $0x8010823f
801017b8:	e8 d3 eb ff ff       	call   80100390 <panic>
801017bd:	8d 76 00             	lea    0x0(%esi),%esi

801017c0 <iupdate>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c8:	83 ec 08             	sub    $0x8,%esp
801017cb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ce:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d1:	c1 e8 03             	shr    $0x3,%eax
801017d4:	03 05 74 1a 11 80    	add    0x80111a74,%eax
801017da:	50                   	push   %eax
801017db:	ff 73 a4             	pushl  -0x5c(%ebx)
801017de:	e8 ed e8 ff ff       	call   801000d0 <bread>
801017e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ec:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101800:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101803:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101807:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010180b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010180f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101813:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101817:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010181a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181d:	6a 34                	push   $0x34
8010181f:	53                   	push   %ebx
80101820:	50                   	push   %eax
80101821:	e8 ea 3a 00 00       	call   80105310 <memmove>
  log_write(bp);
80101826:	89 34 24             	mov    %esi,(%esp)
80101829:	e8 32 17 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010182e:	89 75 08             	mov    %esi,0x8(%ebp)
80101831:	83 c4 10             	add    $0x10,%esp
}
80101834:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5d                   	pop    %ebp
  brelse(bp);
8010183a:	e9 a1 e9 ff ff       	jmp    801001e0 <brelse>
8010183f:	90                   	nop

80101840 <idup>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	83 ec 10             	sub    $0x10,%esp
80101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184a:	68 80 1a 11 80       	push   $0x80111a80
8010184f:	e8 fc 38 00 00       	call   80105150 <acquire>
  ip->ref++;
80101854:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101858:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010185f:	e8 ac 39 00 00       	call   80105210 <release>
}
80101864:	89 d8                	mov    %ebx,%eax
80101866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101869:	c9                   	leave  
8010186a:	c3                   	ret    
8010186b:	90                   	nop
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101870 <ilock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	0f 84 b7 00 00 00    	je     80101937 <ilock+0xc7>
80101880:	8b 53 08             	mov    0x8(%ebx),%edx
80101883:	85 d2                	test   %edx,%edx
80101885:	0f 8e ac 00 00 00    	jle    80101937 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010188b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010188e:	83 ec 0c             	sub    $0xc,%esp
80101891:	50                   	push   %eax
80101892:	e8 89 36 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid == 0){
80101897:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	85 c0                	test   %eax,%eax
8010189f:	74 0f                	je     801018b0 <ilock+0x40>
}
801018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5d                   	pop    %ebp
801018a7:	c3                   	ret    
801018a8:	90                   	nop
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b0:	8b 43 04             	mov    0x4(%ebx),%eax
801018b3:	83 ec 08             	sub    $0x8,%esp
801018b6:	c1 e8 03             	shr    $0x3,%eax
801018b9:	03 05 74 1a 11 80    	add    0x80111a74,%eax
801018bf:	50                   	push   %eax
801018c0:	ff 33                	pushl  (%ebx)
801018c2:	e8 09 e8 ff ff       	call   801000d0 <bread>
801018c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018c9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018cc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cf:	83 e0 07             	and    $0x7,%eax
801018d2:	c1 e0 06             	shl    $0x6,%eax
801018d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101901:	6a 34                	push   $0x34
80101903:	50                   	push   %eax
80101904:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101907:	50                   	push   %eax
80101908:	e8 03 3a 00 00       	call   80105310 <memmove>
    brelse(bp);
8010190d:	89 34 24             	mov    %esi,(%esp)
80101910:	e8 cb e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101915:	83 c4 10             	add    $0x10,%esp
80101918:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010191d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101924:	0f 85 77 ff ff ff    	jne    801018a1 <ilock+0x31>
      panic("ilock: no type");
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	68 57 82 10 80       	push   $0x80108257
80101932:	e8 59 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101937:	83 ec 0c             	sub    $0xc,%esp
8010193a:	68 51 82 10 80       	push   $0x80108251
8010193f:	e8 4c ea ff ff       	call   80100390 <panic>
80101944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010194a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101950 <iunlock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	74 28                	je     80101984 <iunlock+0x34>
8010195c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010195f:	83 ec 0c             	sub    $0xc,%esp
80101962:	56                   	push   %esi
80101963:	e8 58 36 00 00       	call   80104fc0 <holdingsleep>
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 c0                	test   %eax,%eax
8010196d:	74 15                	je     80101984 <iunlock+0x34>
8010196f:	8b 43 08             	mov    0x8(%ebx),%eax
80101972:	85 c0                	test   %eax,%eax
80101974:	7e 0e                	jle    80101984 <iunlock+0x34>
  releasesleep(&ip->lock);
80101976:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101979:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010197f:	e9 fc 35 00 00       	jmp    80104f80 <releasesleep>
    panic("iunlock");
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 66 82 10 80       	push   $0x80108266
8010198c:	e8 ff e9 ff ff       	call   80100390 <panic>
80101991:	eb 0d                	jmp    801019a0 <iput>
80101993:	90                   	nop
80101994:	90                   	nop
80101995:	90                   	nop
80101996:	90                   	nop
80101997:	90                   	nop
80101998:	90                   	nop
80101999:	90                   	nop
8010199a:	90                   	nop
8010199b:	90                   	nop
8010199c:	90                   	nop
8010199d:	90                   	nop
8010199e:	90                   	nop
8010199f:	90                   	nop

801019a0 <iput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 28             	sub    $0x28,%esp
801019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ac:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019af:	57                   	push   %edi
801019b0:	e8 6b 35 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 d2                	test   %edx,%edx
801019bd:	74 07                	je     801019c6 <iput+0x26>
801019bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019c4:	74 32                	je     801019f8 <iput+0x58>
  releasesleep(&ip->lock);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	57                   	push   %edi
801019ca:	e8 b1 35 00 00       	call   80104f80 <releasesleep>
  acquire(&icache.lock);
801019cf:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801019d6:	e8 75 37 00 00       	call   80105150 <acquire>
  ip->ref--;
801019db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
801019e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5f                   	pop    %edi
801019ef:	5d                   	pop    %ebp
  release(&icache.lock);
801019f0:	e9 1b 38 00 00       	jmp    80105210 <release>
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 80 1a 11 80       	push   $0x80111a80
80101a00:	e8 4b 37 00 00       	call   80105150 <acquire>
    int r = ip->ref;
80101a05:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a08:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101a0f:	e8 fc 37 00 00       	call   80105210 <release>
    if(r == 1){
80101a14:	83 c4 10             	add    $0x10,%esp
80101a17:	83 fe 01             	cmp    $0x1,%esi
80101a1a:	75 aa                	jne    801019c6 <iput+0x26>
80101a1c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a22:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a25:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a28:	89 cf                	mov    %ecx,%edi
80101a2a:	eb 0b                	jmp    80101a37 <iput+0x97>
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 19                	je     80101a50 <iput+0xb0>
    if(ip->addrs[i]){
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 bc f8 ff ff       	call   80101300 <bfree>
      ip->addrs[i] = 0;
80101a44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a4a:	eb e4                	jmp    80101a30 <iput+0x90>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a50:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a59:	85 c0                	test   %eax,%eax
80101a5b:	75 33                	jne    80101a90 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a5d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a60:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a67:	53                   	push   %ebx
80101a68:	e8 53 fd ff ff       	call   801017c0 <iupdate>
      ip->type = 0;
80101a6d:	31 c0                	xor    %eax,%eax
80101a6f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a73:	89 1c 24             	mov    %ebx,(%esp)
80101a76:	e8 45 fd ff ff       	call   801017c0 <iupdate>
      ip->valid = 0;
80101a7b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a82:	83 c4 10             	add    $0x10,%esp
80101a85:	e9 3c ff ff ff       	jmp    801019c6 <iput+0x26>
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a90:	83 ec 08             	sub    $0x8,%esp
80101a93:	50                   	push   %eax
80101a94:	ff 33                	pushl  (%ebx)
80101a96:	e8 35 e6 ff ff       	call   801000d0 <bread>
80101a9b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101aa1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101aa7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	89 cf                	mov    %ecx,%edi
80101aaf:	eb 0e                	jmp    80101abf <iput+0x11f>
80101ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ab8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101abb:	39 fe                	cmp    %edi,%esi
80101abd:	74 0f                	je     80101ace <iput+0x12e>
      if(a[j])
80101abf:	8b 16                	mov    (%esi),%edx
80101ac1:	85 d2                	test   %edx,%edx
80101ac3:	74 f3                	je     80101ab8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101ac5:	8b 03                	mov    (%ebx),%eax
80101ac7:	e8 34 f8 ff ff       	call   80101300 <bfree>
80101acc:	eb ea                	jmp    80101ab8 <iput+0x118>
    brelse(bp);
80101ace:	83 ec 0c             	sub    $0xc,%esp
80101ad1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ad4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad7:	e8 04 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101adc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ae2:	8b 03                	mov    (%ebx),%eax
80101ae4:	e8 17 f8 ff ff       	call   80101300 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ae9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101af0:	00 00 00 
80101af3:	83 c4 10             	add    $0x10,%esp
80101af6:	e9 62 ff ff ff       	jmp    80101a5d <iput+0xbd>
80101afb:	90                   	nop
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b00 <iunlockput>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	53                   	push   %ebx
80101b04:	83 ec 10             	sub    $0x10,%esp
80101b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b0a:	53                   	push   %ebx
80101b0b:	e8 40 fe ff ff       	call   80101950 <iunlock>
  iput(ip);
80101b10:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b13:	83 c4 10             	add    $0x10,%esp
}
80101b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b19:	c9                   	leave  
  iput(ip);
80101b1a:	e9 81 fe ff ff       	jmp    801019a0 <iput>
80101b1f:	90                   	nop

80101b20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	8b 55 08             	mov    0x8(%ebp),%edx
80101b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b29:	8b 0a                	mov    (%edx),%ecx
80101b2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b43:	8b 52 58             	mov    0x58(%edx),%edx
80101b46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b49:	5d                   	pop    %ebp
80101b4a:	c3                   	ret    
80101b4b:	90                   	nop
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 1c             	sub    $0x1c,%esp
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b67:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b73:	0f 84 a7 00 00 00    	je     80101c20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7c:	8b 40 58             	mov    0x58(%eax),%eax
80101b7f:	39 c6                	cmp    %eax,%esi
80101b81:	0f 87 ba 00 00 00    	ja     80101c41 <readi+0xf1>
80101b87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b8a:	89 f9                	mov    %edi,%ecx
80101b8c:	01 f1                	add    %esi,%ecx
80101b8e:	0f 82 ad 00 00 00    	jb     80101c41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b94:	89 c2                	mov    %eax,%edx
80101b96:	29 f2                	sub    %esi,%edx
80101b98:	39 c8                	cmp    %ecx,%eax
80101b9a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9d:	31 ff                	xor    %edi,%edi
80101b9f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101ba1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba4:	74 6c                	je     80101c12 <readi+0xc2>
80101ba6:	8d 76 00             	lea    0x0(%esi),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bb0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bb3:	89 f2                	mov    %esi,%edx
80101bb5:	c1 ea 09             	shr    $0x9,%edx
80101bb8:	89 d8                	mov    %ebx,%eax
80101bba:	e8 91 f9 ff ff       	call   80101550 <bmap>
80101bbf:	83 ec 08             	sub    $0x8,%esp
80101bc2:	50                   	push   %eax
80101bc3:	ff 33                	pushl  (%ebx)
80101bc5:	e8 06 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bcd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bcf:	89 f0                	mov    %esi,%eax
80101bd1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bd6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdb:	83 c4 0c             	add    $0xc,%esp
80101bde:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101be0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101be4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	29 fb                	sub    %edi,%ebx
80101be9:	39 d9                	cmp    %ebx,%ecx
80101beb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bee:	53                   	push   %ebx
80101bef:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bf2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bf7:	e8 14 37 00 00       	call   80105310 <memmove>
    brelse(bp);
80101bfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bff:	89 14 24             	mov    %edx,(%esp)
80101c02:	e8 d9 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c0a:	83 c4 10             	add    $0x10,%esp
80101c0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c10:	77 9e                	ja     80101bb0 <readi+0x60>
  }
  return n;
80101c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c18:	5b                   	pop    %ebx
80101c19:	5e                   	pop    %esi
80101c1a:	5f                   	pop    %edi
80101c1b:	5d                   	pop    %ebp
80101c1c:	c3                   	ret    
80101c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c24:	66 83 f8 09          	cmp    $0x9,%ax
80101c28:	77 17                	ja     80101c41 <readi+0xf1>
80101c2a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101c31:	85 c0                	test   %eax,%eax
80101c33:	74 0c                	je     80101c41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5f                   	pop    %edi
80101c3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c3f:	ff e0                	jmp    *%eax
      return -1;
80101c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c46:	eb cd                	jmp    80101c15 <readi+0xc5>
80101c48:	90                   	nop
80101c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c73:	0f 84 b7 00 00 00    	je     80101d30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c7f:	0f 82 eb 00 00 00    	jb     80101d70 <writei+0x120>
80101c85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c88:	31 d2                	xor    %edx,%edx
80101c8a:	89 f8                	mov    %edi,%eax
80101c8c:	01 f0                	add    %esi,%eax
80101c8e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c91:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c96:	0f 87 d4 00 00 00    	ja     80101d70 <writei+0x120>
80101c9c:	85 d2                	test   %edx,%edx
80101c9e:	0f 85 cc 00 00 00    	jne    80101d70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca4:	85 ff                	test   %edi,%edi
80101ca6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cad:	74 72                	je     80101d21 <writei+0xd1>
80101caf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101cb3:	89 f2                	mov    %esi,%edx
80101cb5:	c1 ea 09             	shr    $0x9,%edx
80101cb8:	89 f8                	mov    %edi,%eax
80101cba:	e8 91 f8 ff ff       	call   80101550 <bmap>
80101cbf:	83 ec 08             	sub    $0x8,%esp
80101cc2:	50                   	push   %eax
80101cc3:	ff 37                	pushl  (%edi)
80101cc5:	e8 06 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ccd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cd0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd2:	89 f0                	mov    %esi,%eax
80101cd4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cd9:	83 c4 0c             	add    $0xc,%esp
80101cdc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ce1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ce3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce7:	39 d9                	cmp    %ebx,%ecx
80101ce9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cec:	53                   	push   %ebx
80101ced:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cf2:	50                   	push   %eax
80101cf3:	e8 18 36 00 00       	call   80105310 <memmove>
    log_write(bp);
80101cf8:	89 3c 24             	mov    %edi,(%esp)
80101cfb:	e8 60 12 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101d00:	89 3c 24             	mov    %edi,(%esp)
80101d03:	e8 d8 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d0b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d14:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d17:	77 97                	ja     80101cb0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d1f:	77 37                	ja     80101d58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d27:	5b                   	pop    %ebx
80101d28:	5e                   	pop    %esi
80101d29:	5f                   	pop    %edi
80101d2a:	5d                   	pop    %ebp
80101d2b:	c3                   	ret    
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d34:	66 83 f8 09          	cmp    $0x9,%ax
80101d38:	77 36                	ja     80101d70 <writei+0x120>
80101d3a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101d41:	85 c0                	test   %eax,%eax
80101d43:	74 2b                	je     80101d70 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4b:	5b                   	pop    %ebx
80101d4c:	5e                   	pop    %esi
80101d4d:	5f                   	pop    %edi
80101d4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d4f:	ff e0                	jmp    *%eax
80101d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d61:	50                   	push   %eax
80101d62:	e8 59 fa ff ff       	call   801017c0 <iupdate>
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	eb b5                	jmp    80101d21 <writei+0xd1>
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d75:	eb ad                	jmp    80101d24 <writei+0xd4>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d86:	6a 0e                	push   $0xe
80101d88:	ff 75 0c             	pushl  0xc(%ebp)
80101d8b:	ff 75 08             	pushl  0x8(%ebp)
80101d8e:	e8 ed 35 00 00       	call   80105380 <strncmp>
}
80101d93:	c9                   	leave  
80101d94:	c3                   	ret    
80101d95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101da0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	83 ec 1c             	sub    $0x1c,%esp
80101da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101db1:	0f 85 85 00 00 00    	jne    80101e3c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101db7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dba:	31 ff                	xor    %edi,%edi
80101dbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dbf:	85 d2                	test   %edx,%edx
80101dc1:	74 3e                	je     80101e01 <dirlookup+0x61>
80101dc3:	90                   	nop
80101dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dc8:	6a 10                	push   $0x10
80101dca:	57                   	push   %edi
80101dcb:	56                   	push   %esi
80101dcc:	53                   	push   %ebx
80101dcd:	e8 7e fd ff ff       	call   80101b50 <readi>
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	83 f8 10             	cmp    $0x10,%eax
80101dd8:	75 55                	jne    80101e2f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ddf:	74 18                	je     80101df9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101de1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101de4:	83 ec 04             	sub    $0x4,%esp
80101de7:	6a 0e                	push   $0xe
80101de9:	50                   	push   %eax
80101dea:	ff 75 0c             	pushl  0xc(%ebp)
80101ded:	e8 8e 35 00 00       	call   80105380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101df2:	83 c4 10             	add    $0x10,%esp
80101df5:	85 c0                	test   %eax,%eax
80101df7:	74 17                	je     80101e10 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101df9:	83 c7 10             	add    $0x10,%edi
80101dfc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dff:	72 c7                	jb     80101dc8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e04:	31 c0                	xor    %eax,%eax
}
80101e06:	5b                   	pop    %ebx
80101e07:	5e                   	pop    %esi
80101e08:	5f                   	pop    %edi
80101e09:	5d                   	pop    %ebp
80101e0a:	c3                   	ret    
80101e0b:	90                   	nop
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e10:	8b 45 10             	mov    0x10(%ebp),%eax
80101e13:	85 c0                	test   %eax,%eax
80101e15:	74 05                	je     80101e1c <dirlookup+0x7c>
        *poff = off;
80101e17:	8b 45 10             	mov    0x10(%ebp),%eax
80101e1a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e1c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e20:	8b 03                	mov    (%ebx),%eax
80101e22:	e8 59 f6 ff ff       	call   80101480 <iget>
}
80101e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2a:	5b                   	pop    %ebx
80101e2b:	5e                   	pop    %esi
80101e2c:	5f                   	pop    %edi
80101e2d:	5d                   	pop    %ebp
80101e2e:	c3                   	ret    
      panic("dirlookup read");
80101e2f:	83 ec 0c             	sub    $0xc,%esp
80101e32:	68 80 82 10 80       	push   $0x80108280
80101e37:	e8 54 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	68 6e 82 10 80       	push   $0x8010826e
80101e44:	e8 47 e5 ff ff       	call   80100390 <panic>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	89 cf                	mov    %ecx,%edi
80101e58:	89 c3                	mov    %eax,%ebx
80101e5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e63:	0f 84 67 01 00 00    	je     80101fd0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e69:	e8 52 1c 00 00       	call   80103ac0 <myproc>
  acquire(&icache.lock);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e71:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e74:	68 80 1a 11 80       	push   $0x80111a80
80101e79:	e8 d2 32 00 00       	call   80105150 <acquire>
  ip->ref++;
80101e7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e82:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101e89:	e8 82 33 00 00       	call   80105210 <release>
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	eb 08                	jmp    80101e9b <namex+0x4b>
80101e93:	90                   	nop
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e9b:	0f b6 03             	movzbl (%ebx),%eax
80101e9e:	3c 2f                	cmp    $0x2f,%al
80101ea0:	74 f6                	je     80101e98 <namex+0x48>
  if(*path == 0)
80101ea2:	84 c0                	test   %al,%al
80101ea4:	0f 84 ee 00 00 00    	je     80101f98 <namex+0x148>
  while(*path != '/' && *path != 0)
80101eaa:	0f b6 03             	movzbl (%ebx),%eax
80101ead:	3c 2f                	cmp    $0x2f,%al
80101eaf:	0f 84 b3 00 00 00    	je     80101f68 <namex+0x118>
80101eb5:	84 c0                	test   %al,%al
80101eb7:	89 da                	mov    %ebx,%edx
80101eb9:	75 09                	jne    80101ec4 <namex+0x74>
80101ebb:	e9 a8 00 00 00       	jmp    80101f68 <namex+0x118>
80101ec0:	84 c0                	test   %al,%al
80101ec2:	74 0a                	je     80101ece <namex+0x7e>
    path++;
80101ec4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ec7:	0f b6 02             	movzbl (%edx),%eax
80101eca:	3c 2f                	cmp    $0x2f,%al
80101ecc:	75 f2                	jne    80101ec0 <namex+0x70>
80101ece:	89 d1                	mov    %edx,%ecx
80101ed0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ed2:	83 f9 0d             	cmp    $0xd,%ecx
80101ed5:	0f 8e 91 00 00 00    	jle    80101f6c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101edb:	83 ec 04             	sub    $0x4,%esp
80101ede:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ee1:	6a 0e                	push   $0xe
80101ee3:	53                   	push   %ebx
80101ee4:	57                   	push   %edi
80101ee5:	e8 26 34 00 00       	call   80105310 <memmove>
    path++;
80101eea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101eed:	83 c4 10             	add    $0x10,%esp
    path++;
80101ef0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101ef2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ef5:	75 11                	jne    80101f08 <namex+0xb8>
80101ef7:	89 f6                	mov    %esi,%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f00:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f06:	74 f8                	je     80101f00 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f08:	83 ec 0c             	sub    $0xc,%esp
80101f0b:	56                   	push   %esi
80101f0c:	e8 5f f9 ff ff       	call   80101870 <ilock>
    if(ip->type != T_DIR){
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f19:	0f 85 91 00 00 00    	jne    80101fb0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f22:	85 d2                	test   %edx,%edx
80101f24:	74 09                	je     80101f2f <namex+0xdf>
80101f26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f29:	0f 84 b7 00 00 00    	je     80101fe6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f2f:	83 ec 04             	sub    $0x4,%esp
80101f32:	6a 00                	push   $0x0
80101f34:	57                   	push   %edi
80101f35:	56                   	push   %esi
80101f36:	e8 65 fe ff ff       	call   80101da0 <dirlookup>
80101f3b:	83 c4 10             	add    $0x10,%esp
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	74 6e                	je     80101fb0 <namex+0x160>
  iunlock(ip);
80101f42:	83 ec 0c             	sub    $0xc,%esp
80101f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f48:	56                   	push   %esi
80101f49:	e8 02 fa ff ff       	call   80101950 <iunlock>
  iput(ip);
80101f4e:	89 34 24             	mov    %esi,(%esp)
80101f51:	e8 4a fa ff ff       	call   801019a0 <iput>
80101f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	89 c6                	mov    %eax,%esi
80101f5e:	e9 38 ff ff ff       	jmp    80101e9b <namex+0x4b>
80101f63:	90                   	nop
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f68:	89 da                	mov    %ebx,%edx
80101f6a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f6c:	83 ec 04             	sub    $0x4,%esp
80101f6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f72:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f75:	51                   	push   %ecx
80101f76:	53                   	push   %ebx
80101f77:	57                   	push   %edi
80101f78:	e8 93 33 00 00       	call   80105310 <memmove>
    name[len] = 0;
80101f7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f80:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f83:	83 c4 10             	add    $0x10,%esp
80101f86:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f8a:	89 d3                	mov    %edx,%ebx
80101f8c:	e9 61 ff ff ff       	jmp    80101ef2 <namex+0xa2>
80101f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f9b:	85 c0                	test   %eax,%eax
80101f9d:	75 5d                	jne    80101ffc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa2:	89 f0                	mov    %esi,%eax
80101fa4:	5b                   	pop    %ebx
80101fa5:	5e                   	pop    %esi
80101fa6:	5f                   	pop    %edi
80101fa7:	5d                   	pop    %ebp
80101fa8:	c3                   	ret    
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101fb0:	83 ec 0c             	sub    $0xc,%esp
80101fb3:	56                   	push   %esi
80101fb4:	e8 97 f9 ff ff       	call   80101950 <iunlock>
  iput(ip);
80101fb9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fbc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fbe:	e8 dd f9 ff ff       	call   801019a0 <iput>
      return 0;
80101fc3:	83 c4 10             	add    $0x10,%esp
}
80101fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc9:	89 f0                	mov    %esi,%eax
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5f                   	pop    %edi
80101fce:	5d                   	pop    %ebp
80101fcf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101fd0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fd5:	b8 01 00 00 00       	mov    $0x1,%eax
80101fda:	e8 a1 f4 ff ff       	call   80101480 <iget>
80101fdf:	89 c6                	mov    %eax,%esi
80101fe1:	e9 b5 fe ff ff       	jmp    80101e9b <namex+0x4b>
      iunlock(ip);
80101fe6:	83 ec 0c             	sub    $0xc,%esp
80101fe9:	56                   	push   %esi
80101fea:	e8 61 f9 ff ff       	call   80101950 <iunlock>
      return ip;
80101fef:	83 c4 10             	add    $0x10,%esp
}
80101ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff5:	89 f0                	mov    %esi,%eax
80101ff7:	5b                   	pop    %ebx
80101ff8:	5e                   	pop    %esi
80101ff9:	5f                   	pop    %edi
80101ffa:	5d                   	pop    %ebp
80101ffb:	c3                   	ret    
    iput(ip);
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	56                   	push   %esi
    return 0;
80102000:	31 f6                	xor    %esi,%esi
    iput(ip);
80102002:	e8 99 f9 ff ff       	call   801019a0 <iput>
    return 0;
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	eb 93                	jmp    80101f9f <namex+0x14f>
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102010 <dirlink>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 20             	sub    $0x20,%esp
80102019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010201c:	6a 00                	push   $0x0
8010201e:	ff 75 0c             	pushl  0xc(%ebp)
80102021:	53                   	push   %ebx
80102022:	e8 79 fd ff ff       	call   80101da0 <dirlookup>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	85 c0                	test   %eax,%eax
8010202c:	75 67                	jne    80102095 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010202e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102031:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102034:	85 ff                	test   %edi,%edi
80102036:	74 29                	je     80102061 <dirlink+0x51>
80102038:	31 ff                	xor    %edi,%edi
8010203a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010203d:	eb 09                	jmp    80102048 <dirlink+0x38>
8010203f:	90                   	nop
80102040:	83 c7 10             	add    $0x10,%edi
80102043:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102046:	73 19                	jae    80102061 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102048:	6a 10                	push   $0x10
8010204a:	57                   	push   %edi
8010204b:	56                   	push   %esi
8010204c:	53                   	push   %ebx
8010204d:	e8 fe fa ff ff       	call   80101b50 <readi>
80102052:	83 c4 10             	add    $0x10,%esp
80102055:	83 f8 10             	cmp    $0x10,%eax
80102058:	75 4e                	jne    801020a8 <dirlink+0x98>
    if(de.inum == 0)
8010205a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010205f:	75 df                	jne    80102040 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102061:	8d 45 da             	lea    -0x26(%ebp),%eax
80102064:	83 ec 04             	sub    $0x4,%esp
80102067:	6a 0e                	push   $0xe
80102069:	ff 75 0c             	pushl  0xc(%ebp)
8010206c:	50                   	push   %eax
8010206d:	e8 6e 33 00 00       	call   801053e0 <strncpy>
  de.inum = inum;
80102072:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102075:	6a 10                	push   $0x10
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
  de.inum = inum;
8010207a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010207e:	e8 cd fb ff ff       	call   80101c50 <writei>
80102083:	83 c4 20             	add    $0x20,%esp
80102086:	83 f8 10             	cmp    $0x10,%eax
80102089:	75 2a                	jne    801020b5 <dirlink+0xa5>
  return 0;
8010208b:	31 c0                	xor    %eax,%eax
}
8010208d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102090:	5b                   	pop    %ebx
80102091:	5e                   	pop    %esi
80102092:	5f                   	pop    %edi
80102093:	5d                   	pop    %ebp
80102094:	c3                   	ret    
    iput(ip);
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	50                   	push   %eax
80102099:	e8 02 f9 ff ff       	call   801019a0 <iput>
    return -1;
8010209e:	83 c4 10             	add    $0x10,%esp
801020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a6:	eb e5                	jmp    8010208d <dirlink+0x7d>
      panic("dirlink read");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 8f 82 10 80       	push   $0x8010828f
801020b0:	e8 db e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 fe 8a 10 80       	push   $0x80108afe
801020bd:	e8 ce e2 ff ff       	call   80100390 <panic>
801020c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020d0 <namei>:

struct inode*
namei(char *path)
{
801020d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020d1:	31 d2                	xor    %edx,%edx
{
801020d3:	89 e5                	mov    %esp,%ebp
801020d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020d8:	8b 45 08             	mov    0x8(%ebp),%eax
801020db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020de:	e8 6d fd ff ff       	call   80101e50 <namex>
}
801020e3:	c9                   	leave  
801020e4:	c3                   	ret    
801020e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020f0:	55                   	push   %ebp
  return namex(path, 1, name);
801020f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ff:	e9 4c fd ff ff       	jmp    80101e50 <namex>
80102104:	66 90                	xchg   %ax,%ax
80102106:	66 90                	xchg   %ax,%ax
80102108:	66 90                	xchg   %ax,%ax
8010210a:	66 90                	xchg   %ax,%ax
8010210c:	66 90                	xchg   %ax,%ax
8010210e:	66 90                	xchg   %ax,%ax

80102110 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102119:	85 c0                	test   %eax,%eax
8010211b:	0f 84 b4 00 00 00    	je     801021d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102121:	8b 58 08             	mov    0x8(%eax),%ebx
80102124:	89 c6                	mov    %eax,%esi
80102126:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010212c:	0f 87 96 00 00 00    	ja     801021c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102132:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102137:	89 f6                	mov    %esi,%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102140:	89 ca                	mov    %ecx,%edx
80102142:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102143:	83 e0 c0             	and    $0xffffffc0,%eax
80102146:	3c 40                	cmp    $0x40,%al
80102148:	75 f6                	jne    80102140 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010214a:	31 ff                	xor    %edi,%edi
8010214c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102151:	89 f8                	mov    %edi,%eax
80102153:	ee                   	out    %al,(%dx)
80102154:	b8 01 00 00 00       	mov    $0x1,%eax
80102159:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010215e:	ee                   	out    %al,(%dx)
8010215f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102164:	89 d8                	mov    %ebx,%eax
80102166:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102167:	89 d8                	mov    %ebx,%eax
80102169:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010216e:	c1 f8 08             	sar    $0x8,%eax
80102171:	ee                   	out    %al,(%dx)
80102172:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102177:	89 f8                	mov    %edi,%eax
80102179:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010217a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010217e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102183:	c1 e0 04             	shl    $0x4,%eax
80102186:	83 e0 10             	and    $0x10,%eax
80102189:	83 c8 e0             	or     $0xffffffe0,%eax
8010218c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010218d:	f6 06 04             	testb  $0x4,(%esi)
80102190:	75 16                	jne    801021a8 <idestart+0x98>
80102192:	b8 20 00 00 00       	mov    $0x20,%eax
80102197:	89 ca                	mov    %ecx,%edx
80102199:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010219a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010219d:	5b                   	pop    %ebx
8010219e:	5e                   	pop    %esi
8010219f:	5f                   	pop    %edi
801021a0:	5d                   	pop    %ebp
801021a1:	c3                   	ret    
801021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021a8:	b8 30 00 00 00       	mov    $0x30,%eax
801021ad:	89 ca                	mov    %ecx,%edx
801021af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021b5:	83 c6 5c             	add    $0x5c,%esi
801021b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bd:	fc                   	cld    
801021be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c3:	5b                   	pop    %ebx
801021c4:	5e                   	pop    %esi
801021c5:	5f                   	pop    %edi
801021c6:	5d                   	pop    %ebp
801021c7:	c3                   	ret    
    panic("incorrect blockno");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 f8 82 10 80       	push   $0x801082f8
801021d0:	e8 bb e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 ef 82 10 80       	push   $0x801082ef
801021dd:	e8 ae e1 ff ff       	call   80100390 <panic>
801021e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <ideinit>:
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021f6:	68 0a 83 10 80       	push   $0x8010830a
801021fb:	68 80 b5 10 80       	push   $0x8010b580
80102200:	e8 0b 2e 00 00       	call   80105010 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102205:	58                   	pop    %eax
80102206:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
8010220b:	5a                   	pop    %edx
8010220c:	83 e8 01             	sub    $0x1,%eax
8010220f:	50                   	push   %eax
80102210:	6a 0e                	push   $0xe
80102212:	e8 a9 02 00 00       	call   801024c0 <ioapicenable>
80102217:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010221a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	83 e0 c0             	and    $0xffffffc0,%eax
80102224:	3c 40                	cmp    $0x40,%al
80102226:	75 f8                	jne    80102220 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102228:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010222d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102232:	ee                   	out    %al,(%dx)
80102233:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102238:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010223d:	eb 06                	jmp    80102245 <ideinit+0x55>
8010223f:	90                   	nop
  for(i=0; i<1000; i++){
80102240:	83 e9 01             	sub    $0x1,%ecx
80102243:	74 0f                	je     80102254 <ideinit+0x64>
80102245:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102246:	84 c0                	test   %al,%al
80102248:	74 f6                	je     80102240 <ideinit+0x50>
      havedisk1 = 1;
8010224a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102251:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102254:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102259:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010225e:	ee                   	out    %al,(%dx)
}
8010225f:	c9                   	leave  
80102260:	c3                   	ret    
80102261:	eb 0d                	jmp    80102270 <ideintr>
80102263:	90                   	nop
80102264:	90                   	nop
80102265:	90                   	nop
80102266:	90                   	nop
80102267:	90                   	nop
80102268:	90                   	nop
80102269:	90                   	nop
8010226a:	90                   	nop
8010226b:	90                   	nop
8010226c:	90                   	nop
8010226d:	90                   	nop
8010226e:	90                   	nop
8010226f:	90                   	nop

80102270 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	57                   	push   %edi
80102274:	56                   	push   %esi
80102275:	53                   	push   %ebx
80102276:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102279:	68 80 b5 10 80       	push   $0x8010b580
8010227e:	e8 cd 2e 00 00       	call   80105150 <acquire>

  if((b = idequeue) == 0){
80102283:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102289:	83 c4 10             	add    $0x10,%esp
8010228c:	85 db                	test   %ebx,%ebx
8010228e:	74 67                	je     801022f7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102290:	8b 43 58             	mov    0x58(%ebx),%eax
80102293:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102298:	8b 3b                	mov    (%ebx),%edi
8010229a:	f7 c7 04 00 00 00    	test   $0x4,%edi
801022a0:	75 31                	jne    801022d3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022b1:	89 c6                	mov    %eax,%esi
801022b3:	83 e6 c0             	and    $0xffffffc0,%esi
801022b6:	89 f1                	mov    %esi,%ecx
801022b8:	80 f9 40             	cmp    $0x40,%cl
801022bb:	75 f3                	jne    801022b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022bd:	a8 21                	test   $0x21,%al
801022bf:	75 12                	jne    801022d3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801022c1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022c4:	b9 80 00 00 00       	mov    $0x80,%ecx
801022c9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ce:	fc                   	cld    
801022cf:	f3 6d                	rep insl (%dx),%es:(%edi)
801022d1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801022d6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022d9:	89 f9                	mov    %edi,%ecx
801022db:	83 c9 02             	or     $0x2,%ecx
801022de:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022e0:	53                   	push   %ebx
801022e1:	e8 ca 23 00 00       	call   801046b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022e6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022eb:	83 c4 10             	add    $0x10,%esp
801022ee:	85 c0                	test   %eax,%eax
801022f0:	74 05                	je     801022f7 <ideintr+0x87>
    idestart(idequeue);
801022f2:	e8 19 fe ff ff       	call   80102110 <idestart>
    release(&idelock);
801022f7:	83 ec 0c             	sub    $0xc,%esp
801022fa:	68 80 b5 10 80       	push   $0x8010b580
801022ff:	e8 0c 2f 00 00       	call   80105210 <release>

  release(&idelock);
}
80102304:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102307:	5b                   	pop    %ebx
80102308:	5e                   	pop    %esi
80102309:	5f                   	pop    %edi
8010230a:	5d                   	pop    %ebp
8010230b:	c3                   	ret    
8010230c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102310 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 10             	sub    $0x10,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010231a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010231d:	50                   	push   %eax
8010231e:	e8 9d 2c 00 00       	call   80104fc0 <holdingsleep>
80102323:	83 c4 10             	add    $0x10,%esp
80102326:	85 c0                	test   %eax,%eax
80102328:	0f 84 c6 00 00 00    	je     801023f4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 e0 06             	and    $0x6,%eax
80102333:	83 f8 02             	cmp    $0x2,%eax
80102336:	0f 84 ab 00 00 00    	je     801023e7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010233c:	8b 53 04             	mov    0x4(%ebx),%edx
8010233f:	85 d2                	test   %edx,%edx
80102341:	74 0d                	je     80102350 <iderw+0x40>
80102343:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102348:	85 c0                	test   %eax,%eax
8010234a:	0f 84 b1 00 00 00    	je     80102401 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 80 b5 10 80       	push   $0x8010b580
80102358:	e8 f3 2d 00 00       	call   80105150 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010235d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102363:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102366:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236d:	85 d2                	test   %edx,%edx
8010236f:	75 09                	jne    8010237a <iderw+0x6a>
80102371:	eb 6d                	jmp    801023e0 <iderw+0xd0>
80102373:	90                   	nop
80102374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102378:	89 c2                	mov    %eax,%edx
8010237a:	8b 42 58             	mov    0x58(%edx),%eax
8010237d:	85 c0                	test   %eax,%eax
8010237f:	75 f7                	jne    80102378 <iderw+0x68>
80102381:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102384:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102386:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010238c:	74 42                	je     801023d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 e0 06             	and    $0x6,%eax
80102393:	83 f8 02             	cmp    $0x2,%eax
80102396:	74 23                	je     801023bb <iderw+0xab>
80102398:	90                   	nop
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023a0:	83 ec 08             	sub    $0x8,%esp
801023a3:	68 80 b5 10 80       	push   $0x8010b580
801023a8:	53                   	push   %ebx
801023a9:	e8 42 21 00 00       	call   801044f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	83 e0 06             	and    $0x6,%eax
801023b6:	83 f8 02             	cmp    $0x2,%eax
801023b9:	75 e5                	jne    801023a0 <iderw+0x90>
  }


  release(&idelock);
801023bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023c5:	c9                   	leave  
  release(&idelock);
801023c6:	e9 45 2e 00 00       	jmp    80105210 <release>
801023cb:	90                   	nop
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801023d0:	89 d8                	mov    %ebx,%eax
801023d2:	e8 39 fd ff ff       	call   80102110 <idestart>
801023d7:	eb b5                	jmp    8010238e <iderw+0x7e>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023e5:	eb 9d                	jmp    80102384 <iderw+0x74>
    panic("iderw: nothing to do");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 24 83 10 80       	push   $0x80108324
801023ef:	e8 9c df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 0e 83 10 80       	push   $0x8010830e
801023fc:	e8 8f df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	68 39 83 10 80       	push   $0x80108339
80102409:	e8 82 df ff ff       	call   80100390 <panic>
8010240e:	66 90                	xchg   %ax,%ax

80102410 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102410:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102411:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
80102418:	00 c0 fe 
{
8010241b:	89 e5                	mov    %esp,%ebp
8010241d:	56                   	push   %esi
8010241e:	53                   	push   %ebx
  ioapic->reg = reg;
8010241f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102426:	00 00 00 
  return ioapic->data;
80102429:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010242e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102437:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010243d:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102444:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102447:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010244a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010244d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102450:	39 c2                	cmp    %eax,%edx
80102452:	74 16                	je     8010246a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	68 58 83 10 80       	push   $0x80108358
8010245c:	e8 ff e1 ff ff       	call   80100660 <cprintf>
80102461:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	83 c3 21             	add    $0x21,%ebx
{
8010246d:	ba 10 00 00 00       	mov    $0x10,%edx
80102472:	b8 20 00 00 00       	mov    $0x20,%eax
80102477:	89 f6                	mov    %esi,%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102480:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102482:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102488:	89 c6                	mov    %eax,%esi
8010248a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102490:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102493:	89 71 10             	mov    %esi,0x10(%ecx)
80102496:	8d 72 01             	lea    0x1(%edx),%esi
80102499:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010249c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010249e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801024a0:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
801024a6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024ad:	75 d1                	jne    80102480 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b2:	5b                   	pop    %ebx
801024b3:	5e                   	pop    %esi
801024b4:	5d                   	pop    %ebp
801024b5:	c3                   	ret    
801024b6:	8d 76 00             	lea    0x0(%esi),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024c0:	55                   	push   %ebp
  ioapic->reg = reg;
801024c1:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
{
801024c7:	89 e5                	mov    %esp,%ebp
801024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024cc:	8d 50 20             	lea    0x20(%eax),%edx
801024cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024d5:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024de:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e6:	a1 d4 36 11 80       	mov    0x801136d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801024f1:	5d                   	pop    %ebp
801024f2:	c3                   	ret    
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 04             	sub    $0x4,%esp
80102507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010250a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102510:	75 70                	jne    80102582 <kfree+0x82>
80102512:	81 fb 48 8e 11 80    	cmp    $0x80118e48,%ebx
80102518:	72 68                	jb     80102582 <kfree+0x82>
8010251a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102520:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102525:	77 5b                	ja     80102582 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102527:	83 ec 04             	sub    $0x4,%esp
8010252a:	68 00 10 00 00       	push   $0x1000
8010252f:	6a 01                	push   $0x1
80102531:	53                   	push   %ebx
80102532:	e8 29 2d 00 00       	call   80105260 <memset>

  if(kmem.use_lock)
80102537:	8b 15 14 37 11 80    	mov    0x80113714,%edx
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	85 d2                	test   %edx,%edx
80102542:	75 2c                	jne    80102570 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102544:	a1 18 37 11 80       	mov    0x80113718,%eax
80102549:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010254b:	a1 14 37 11 80       	mov    0x80113714,%eax
  kmem.freelist = r;
80102550:	89 1d 18 37 11 80    	mov    %ebx,0x80113718
  if(kmem.use_lock)
80102556:	85 c0                	test   %eax,%eax
80102558:	75 06                	jne    80102560 <kfree+0x60>
    release(&kmem.lock);
}
8010255a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010255d:	c9                   	leave  
8010255e:	c3                   	ret    
8010255f:	90                   	nop
    release(&kmem.lock);
80102560:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256a:	c9                   	leave  
    release(&kmem.lock);
8010256b:	e9 a0 2c 00 00       	jmp    80105210 <release>
    acquire(&kmem.lock);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	68 e0 36 11 80       	push   $0x801136e0
80102578:	e8 d3 2b 00 00       	call   80105150 <acquire>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	eb c2                	jmp    80102544 <kfree+0x44>
    panic("kfree");
80102582:	83 ec 0c             	sub    $0xc,%esp
80102585:	68 8a 83 10 80       	push   $0x8010838a
8010258a:	e8 01 de ff ff       	call   80100390 <panic>
8010258f:	90                   	nop

80102590 <freerange>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <freerange+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 33 ff ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 f3                	cmp    %esi,%ebx
801025d2:	76 e4                	jbe    801025b8 <freerange+0x28>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	90                   	nop
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <kinit1>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
801025e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025e8:	83 ec 08             	sub    $0x8,%esp
801025eb:	68 90 83 10 80       	push   $0x80108390
801025f0:	68 e0 36 11 80       	push   $0x801136e0
801025f5:	e8 16 2a 00 00       	call   80105010 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102600:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
80102607:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102610:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102616:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261c:	39 de                	cmp    %ebx,%esi
8010261e:	72 1c                	jb     8010263c <kinit1+0x5c>
    kfree(p);
80102620:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102626:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102629:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010262f:	50                   	push   %eax
80102630:	e8 cb fe ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102635:	83 c4 10             	add    $0x10,%esp
80102638:	39 de                	cmp    %ebx,%esi
8010263a:	73 e4                	jae    80102620 <kinit1+0x40>
}
8010263c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010263f:	5b                   	pop    %ebx
80102640:	5e                   	pop    %esi
80102641:	5d                   	pop    %ebp
80102642:	c3                   	ret    
80102643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kinit2>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	56                   	push   %esi
80102654:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102655:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102658:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010265b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102661:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102667:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266d:	39 de                	cmp    %ebx,%esi
8010266f:	72 23                	jb     80102694 <kinit2+0x44>
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102678:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010267e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102681:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102687:	50                   	push   %eax
80102688:	e8 73 fe ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
80102690:	39 de                	cmp    %ebx,%esi
80102692:	73 e4                	jae    80102678 <kinit2+0x28>
  kmem.use_lock = 1;
80102694:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
8010269b:	00 00 00 
}
8010269e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a1:	5b                   	pop    %ebx
801026a2:	5e                   	pop    %esi
801026a3:	5d                   	pop    %ebp
801026a4:	c3                   	ret    
801026a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026b0:	a1 14 37 11 80       	mov    0x80113714,%eax
801026b5:	85 c0                	test   %eax,%eax
801026b7:	75 1f                	jne    801026d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026b9:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
801026be:	85 c0                	test   %eax,%eax
801026c0:	74 0e                	je     801026d0 <kalloc+0x20>
    kmem.freelist = r->next;
801026c2:	8b 10                	mov    (%eax),%edx
801026c4:	89 15 18 37 11 80    	mov    %edx,0x80113718
801026ca:	c3                   	ret    
801026cb:	90                   	nop
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026d0:	f3 c3                	repz ret 
801026d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801026d8:	55                   	push   %ebp
801026d9:	89 e5                	mov    %esp,%ebp
801026db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026de:	68 e0 36 11 80       	push   $0x801136e0
801026e3:	e8 68 2a 00 00       	call   80105150 <acquire>
  r = kmem.freelist;
801026e8:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	8b 15 14 37 11 80    	mov    0x80113714,%edx
801026f6:	85 c0                	test   %eax,%eax
801026f8:	74 08                	je     80102702 <kalloc+0x52>
    kmem.freelist = r->next;
801026fa:	8b 08                	mov    (%eax),%ecx
801026fc:	89 0d 18 37 11 80    	mov    %ecx,0x80113718
  if(kmem.use_lock)
80102702:	85 d2                	test   %edx,%edx
80102704:	74 16                	je     8010271c <kalloc+0x6c>
    release(&kmem.lock);
80102706:	83 ec 0c             	sub    $0xc,%esp
80102709:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270c:	68 e0 36 11 80       	push   $0x801136e0
80102711:	e8 fa 2a 00 00       	call   80105210 <release>
  return (char*)r;
80102716:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102719:	83 c4 10             	add    $0x10,%esp
}
8010271c:	c9                   	leave  
8010271d:	c3                   	ret    
8010271e:	66 90                	xchg   %ax,%ax

80102720 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102720:	ba 64 00 00 00       	mov    $0x64,%edx
80102725:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102726:	a8 01                	test   $0x1,%al
80102728:	0f 84 c2 00 00 00    	je     801027f0 <kbdgetc+0xd0>
8010272e:	ba 60 00 00 00       	mov    $0x60,%edx
80102733:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102734:	0f b6 d0             	movzbl %al,%edx
80102737:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010273d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102743:	0f 84 7f 00 00 00    	je     801027c8 <kbdgetc+0xa8>
{
80102749:	55                   	push   %ebp
8010274a:	89 e5                	mov    %esp,%ebp
8010274c:	53                   	push   %ebx
8010274d:	89 cb                	mov    %ecx,%ebx
8010274f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102752:	84 c0                	test   %al,%al
80102754:	78 4a                	js     801027a0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102756:	85 db                	test   %ebx,%ebx
80102758:	74 09                	je     80102763 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010275a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010275d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102760:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102763:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
8010276a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010276c:	0f b6 82 c0 83 10 80 	movzbl -0x7fef7c40(%edx),%eax
80102773:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102775:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102777:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010277d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102780:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102783:	8b 04 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%eax
8010278a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010278e:	74 31                	je     801027c1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102790:	8d 50 9f             	lea    -0x61(%eax),%edx
80102793:	83 fa 19             	cmp    $0x19,%edx
80102796:	77 40                	ja     801027d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102798:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010279b:	5b                   	pop    %ebx
8010279c:	5d                   	pop    %ebp
8010279d:	c3                   	ret    
8010279e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 db                	test   %ebx,%ebx
801027a5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 c1                	and    %eax,%ecx
    return 0;
801027b9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027bb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027c1:	5b                   	pop    %ebx
801027c2:	5d                   	pop    %ebp
801027c3:	c3                   	ret    
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801027c8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801027cb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027cd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027db:	8d 50 20             	lea    0x20(%eax),%edx
}
801027de:	5b                   	pop    %ebx
      c += 'a' - 'A';
801027df:	83 f9 1a             	cmp    $0x1a,%ecx
801027e2:	0f 42 c2             	cmovb  %edx,%eax
}
801027e5:	5d                   	pop    %ebp
801027e6:	c3                   	ret    
801027e7:	89 f6                	mov    %esi,%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027f5:	c3                   	ret    
801027f6:	8d 76 00             	lea    0x0(%esi),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kbdintr>:

void
kbdintr(void)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102806:	68 20 27 10 80       	push   $0x80102720
8010280b:	e8 00 e0 ff ff       	call   80100810 <consoleintr>
}
80102810:	83 c4 10             	add    $0x10,%esp
80102813:	c9                   	leave  
80102814:	c3                   	ret    
80102815:	66 90                	xchg   %ax,%ax
80102817:	66 90                	xchg   %ax,%ax
80102819:	66 90                	xchg   %ax,%ax
8010281b:	66 90                	xchg   %ax,%ax
8010281d:	66 90                	xchg   %ax,%ax
8010281f:	90                   	nop

80102820 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102820:	a1 1c 37 11 80       	mov    0x8011371c,%eax
{
80102825:	55                   	push   %ebp
80102826:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102828:	85 c0                	test   %eax,%eax
8010282a:	0f 84 c8 00 00 00    	je     801028f8 <lapicinit+0xd8>
  lapic[index] = value;
80102830:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102837:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102844:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102851:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102857:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010285e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102864:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010286b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102878:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010287e:	8b 50 30             	mov    0x30(%eax),%edx
80102881:	c1 ea 10             	shr    $0x10,%edx
80102884:	80 fa 03             	cmp    $0x3,%dl
80102887:	77 77                	ja     80102900 <lapicinit+0xe0>
  lapic[index] = value;
80102889:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102890:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102893:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102896:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
801028d7:	89 f6                	mov    %esi,%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028e6:	80 e6 10             	and    $0x10,%dh
801028e9:	75 f5                	jne    801028e0 <lapicinit+0xc0>
  lapic[index] = value;
801028eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028f8:	5d                   	pop    %ebp
801028f9:	c3                   	ret    
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102900:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102907:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 50 20             	mov    0x20(%eax),%edx
8010290d:	e9 77 ff ff ff       	jmp    80102889 <lapicinit+0x69>
80102912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102920:	8b 15 1c 37 11 80    	mov    0x8011371c,%edx
{
80102926:	55                   	push   %ebp
80102927:	31 c0                	xor    %eax,%eax
80102929:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010292b:	85 d2                	test   %edx,%edx
8010292d:	74 06                	je     80102935 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010292f:	8b 42 20             	mov    0x20(%edx),%eax
80102932:	c1 e8 18             	shr    $0x18,%eax
}
80102935:	5d                   	pop    %ebp
80102936:	c3                   	ret    
80102937:	89 f6                	mov    %esi,%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102940:	a1 1c 37 11 80       	mov    0x8011371c,%eax
{
80102945:	55                   	push   %ebp
80102946:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102948:	85 c0                	test   %eax,%eax
8010294a:	74 0d                	je     80102959 <lapiceoi+0x19>
  lapic[index] = value;
8010294c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102953:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102956:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102959:	5d                   	pop    %ebp
8010295a:	c3                   	ret    
8010295b:	90                   	nop
8010295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102960 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
}
80102963:	5d                   	pop    %ebp
80102964:	c3                   	ret    
80102965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102970:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102971:	b8 0f 00 00 00       	mov    $0xf,%eax
80102976:	ba 70 00 00 00       	mov    $0x70,%edx
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	53                   	push   %ebx
8010297e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102984:	ee                   	out    %al,(%dx)
80102985:	b8 0a 00 00 00       	mov    $0xa,%eax
8010298a:	ba 71 00 00 00       	mov    $0x71,%edx
8010298f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102990:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102992:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102995:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010299b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010299d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801029a0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801029a3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ae:	a1 1c 37 11 80       	mov    0x8011371c,%eax
801029b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029fa:	5b                   	pop    %ebx
801029fb:	5d                   	pop    %ebp
801029fc:	c3                   	ret    
801029fd:	8d 76 00             	lea    0x0(%esi),%esi

80102a00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a00:	55                   	push   %ebp
80102a01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a06:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	57                   	push   %edi
80102a0e:	56                   	push   %esi
80102a0f:	53                   	push   %ebx
80102a10:	83 ec 4c             	sub    $0x4c,%esp
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	ba 71 00 00 00       	mov    $0x71,%edx
80102a19:	ec                   	in     (%dx),%al
80102a1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
80102a28:	31 c0                	xor    %eax,%eax
80102a2a:	89 da                	mov    %ebx,%edx
80102a2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a32:	89 ca                	mov    %ecx,%edx
80102a34:	ec                   	in     (%dx),%al
80102a35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	89 ca                	mov    %ecx,%edx
80102a42:	ec                   	in     (%dx),%al
80102a43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a46:	89 da                	mov    %ebx,%edx
80102a48:	b8 04 00 00 00       	mov    $0x4,%eax
80102a4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4e:	89 ca                	mov    %ecx,%edx
80102a50:	ec                   	in     (%dx),%al
80102a51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 da                	mov    %ebx,%edx
80102a56:	b8 07 00 00 00       	mov    $0x7,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al
80102a5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a62:	89 da                	mov    %ebx,%edx
80102a64:	b8 08 00 00 00       	mov    $0x8,%eax
80102a69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6a:	89 ca                	mov    %ecx,%edx
80102a6c:	ec                   	in     (%dx),%al
80102a6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6f:	89 da                	mov    %ebx,%edx
80102a71:	b8 09 00 00 00       	mov    $0x9,%eax
80102a76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a77:	89 ca                	mov    %ecx,%edx
80102a79:	ec                   	in     (%dx),%al
80102a7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	89 ca                	mov    %ecx,%edx
80102a86:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a87:	84 c0                	test   %al,%al
80102a89:	78 9d                	js     80102a28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a8f:	89 fa                	mov    %edi,%edx
80102a91:	0f b6 fa             	movzbl %dl,%edi
80102a94:	89 f2                	mov    %esi,%edx
80102a96:	0f b6 f2             	movzbl %dl,%esi
80102a99:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9c:	89 da                	mov    %ebx,%edx
80102a9e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aa1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102aa4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102aa8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aab:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aaf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ab2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab9:	31 c0                	xor    %eax,%eax
80102abb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abc:	89 ca                	mov    %ecx,%edx
80102abe:	ec                   	in     (%dx),%al
80102abf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	89 da                	mov    %ebx,%edx
80102ac4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ac7:	b8 02 00 00 00       	mov    $0x2,%eax
80102acc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acd:	89 ca                	mov    %ecx,%edx
80102acf:	ec                   	in     (%dx),%al
80102ad0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad3:	89 da                	mov    %ebx,%edx
80102ad5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad8:	b8 04 00 00 00       	mov    $0x4,%eax
80102add:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ade:	89 ca                	mov    %ecx,%edx
80102ae0:	ec                   	in     (%dx),%al
80102ae1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae4:	89 da                	mov    %ebx,%edx
80102ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae9:	b8 07 00 00 00       	mov    $0x7,%eax
80102aee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aef:	89 ca                	mov    %ecx,%edx
80102af1:	ec                   	in     (%dx),%al
80102af2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af5:	89 da                	mov    %ebx,%edx
80102af7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102afa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b00:	89 ca                	mov    %ecx,%edx
80102b02:	ec                   	in     (%dx),%al
80102b03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b11:	89 ca                	mov    %ecx,%edx
80102b13:	ec                   	in     (%dx),%al
80102b14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b20:	6a 18                	push   $0x18
80102b22:	50                   	push   %eax
80102b23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b26:	50                   	push   %eax
80102b27:	e8 84 27 00 00       	call   801052b0 <memcmp>
80102b2c:	83 c4 10             	add    $0x10,%esp
80102b2f:	85 c0                	test   %eax,%eax
80102b31:	0f 85 f1 fe ff ff    	jne    80102a28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b3b:	75 78                	jne    80102bb5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	83 e0 0f             	and    $0xf,%eax
80102b6d:	c1 ea 04             	shr    $0x4,%edx
80102b70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 c2                	mov    %eax,%edx
80102b7e:	83 e0 0f             	and    $0xf,%eax
80102b81:	c1 ea 04             	shr    $0x4,%edx
80102b84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b90:	89 c2                	mov    %eax,%edx
80102b92:	83 e0 0f             	and    $0xf,%eax
80102b95:	c1 ea 04             	shr    $0x4,%edx
80102b98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ba1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	83 e0 0f             	and    $0xf,%eax
80102ba9:	c1 ea 04             	shr    $0x4,%edx
80102bac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bb5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bbb:	89 06                	mov    %eax,(%esi)
80102bbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc0:	89 46 04             	mov    %eax,0x4(%esi)
80102bc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bc6:	89 46 08             	mov    %eax,0x8(%esi)
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd2:	89 46 10             	mov    %eax,0x10(%esi)
80102bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bdb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be5:	5b                   	pop    %ebx
80102be6:	5e                   	pop    %esi
80102be7:	5f                   	pop    %edi
80102be8:	5d                   	pop    %ebp
80102be9:	c3                   	ret    
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
80102c02:	56                   	push   %esi
80102c03:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c04:	31 db                	xor    %ebx,%ebx
{
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 54 37 11 80       	mov    0x80113754,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 d8                	add    %ebx,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 64 37 11 80    	pushl  0x80113764
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102c34:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
80102c42:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c44:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c47:	83 c4 0c             	add    $0xc,%esp
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 b7 26 00 00       	call   80105310 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 34 24             	mov    %esi,(%esp)
80102c5c:	e8 3f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c61:	89 3c 24             	mov    %edi,(%esp)
80102c64:	e8 77 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c69:	89 34 24             	mov    %esi,(%esp)
80102c6c:	e8 6f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 1d 68 37 11 80    	cmp    %ebx,0x80113768
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	f3 c3                	repz ret 
80102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	56                   	push   %esi
80102c94:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c95:	83 ec 08             	sub    $0x8,%esp
80102c98:	ff 35 54 37 11 80    	pushl  0x80113754
80102c9e:	ff 35 64 37 11 80    	pushl  0x80113764
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ca9:	8b 1d 68 37 11 80    	mov    0x80113768,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102caf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102cb4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102cb6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102cb9:	7e 16                	jle    80102cd1 <write_head+0x41>
80102cbb:	c1 e3 02             	shl    $0x2,%ebx
80102cbe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 8a 6c 37 11 80    	mov    -0x7feec894(%edx),%ecx
80102cc6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102cca:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102ccd:	39 da                	cmp    %ebx,%edx
80102ccf:	75 ef                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd1:	83 ec 0c             	sub    $0xc,%esp
80102cd4:	56                   	push   %esi
80102cd5:	e8 c6 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102cda:	89 34 24             	mov    %esi,(%esp)
80102cdd:	e8 fe d4 ff ff       	call   801001e0 <brelse>
}
80102ce2:	83 c4 10             	add    $0x10,%esp
80102ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ce8:	5b                   	pop    %ebx
80102ce9:	5e                   	pop    %esi
80102cea:	5d                   	pop    %ebp
80102ceb:	c3                   	ret    
80102cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <initlog>:
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 2c             	sub    $0x2c,%esp
80102cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfa:	68 c0 85 10 80       	push   $0x801085c0
80102cff:	68 20 37 11 80       	push   $0x80113720
80102d04:	e8 07 23 00 00       	call   80105010 <initlock>
  readsb(dev, &sb);
80102d09:	58                   	pop    %eax
80102d0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 1b e9 ff ff       	call   80101630 <readsb>
  log.size = sb.nlog;
80102d15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d1b:	59                   	pop    %ecx
  log.dev = dev;
80102d1c:	89 1d 64 37 11 80    	mov    %ebx,0x80113764
  log.size = sb.nlog;
80102d22:	89 15 58 37 11 80    	mov    %edx,0x80113758
  log.start = sb.logstart;
80102d28:	a3 54 37 11 80       	mov    %eax,0x80113754
  struct buf *buf = bread(log.dev, log.start);
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 9b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d35:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d38:	83 c4 10             	add    $0x10,%esp
80102d3b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d3d:	89 1d 68 37 11 80    	mov    %ebx,0x80113768
  for (i = 0; i < log.lh.n; i++) {
80102d43:	7e 1c                	jle    80102d61 <initlog+0x71>
80102d45:	c1 e3 02             	shl    $0x2,%ebx
80102d48:	31 d2                	xor    %edx,%edx
80102d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d50:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d54:	83 c2 04             	add    $0x4,%edx
80102d57:	89 8a 68 37 11 80    	mov    %ecx,-0x7feec898(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d5d:	39 d3                	cmp    %edx,%ebx
80102d5f:	75 ef                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d61:	83 ec 0c             	sub    $0xc,%esp
80102d64:	50                   	push   %eax
80102d65:	e8 76 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6a:	e8 81 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d6f:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80102d76:	00 00 00 
  write_head(); // clear the log
80102d79:	e8 12 ff ff ff       	call   80102c90 <write_head>
}
80102d7e:	83 c4 10             	add    $0x10,%esp
80102d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d84:	c9                   	leave  
80102d85:	c3                   	ret    
80102d86:	8d 76 00             	lea    0x0(%esi),%esi
80102d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d96:	68 20 37 11 80       	push   $0x80113720
80102d9b:	e8 b0 23 00 00       	call   80105150 <acquire>
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	eb 18                	jmp    80102dbd <begin_op+0x2d>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da8:	83 ec 08             	sub    $0x8,%esp
80102dab:	68 20 37 11 80       	push   $0x80113720
80102db0:	68 20 37 11 80       	push   $0x80113720
80102db5:	e8 36 17 00 00       	call   801044f0 <sleep>
80102dba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dbd:	a1 60 37 11 80       	mov    0x80113760,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 e2                	jne    80102da8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dc6:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102dcb:	8b 15 68 37 11 80    	mov    0x80113768,%edx
80102dd1:	83 c0 01             	add    $0x1,%eax
80102dd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dda:	83 fa 1e             	cmp    $0x1e,%edx
80102ddd:	7f c9                	jg     80102da8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ddf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102de2:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
80102de7:	68 20 37 11 80       	push   $0x80113720
80102dec:	e8 1f 24 00 00       	call   80105210 <release>
      break;
    }
  }
}
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	c9                   	leave  
80102df5:	c3                   	ret    
80102df6:	8d 76 00             	lea    0x0(%esi),%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	57                   	push   %edi
80102e04:	56                   	push   %esi
80102e05:	53                   	push   %ebx
80102e06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e09:	68 20 37 11 80       	push   $0x80113720
80102e0e:	e8 3d 23 00 00       	call   80105150 <acquire>
  log.outstanding -= 1;
80102e13:	a1 5c 37 11 80       	mov    0x8011375c,%eax
  if(log.committing)
80102e18:	8b 35 60 37 11 80    	mov    0x80113760,%esi
80102e1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e21:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e24:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e26:	89 1d 5c 37 11 80    	mov    %ebx,0x8011375c
  if(log.committing)
80102e2c:	0f 85 1a 01 00 00    	jne    80102f4c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e32:	85 db                	test   %ebx,%ebx
80102e34:	0f 85 ee 00 00 00    	jne    80102f28 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e3a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e3d:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
80102e44:	00 00 00 
  release(&log.lock);
80102e47:	68 20 37 11 80       	push   $0x80113720
80102e4c:	e8 bf 23 00 00       	call   80105210 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e51:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102e57:	83 c4 10             	add    $0x10,%esp
80102e5a:	85 c9                	test   %ecx,%ecx
80102e5c:	0f 8e 85 00 00 00    	jle    80102ee7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e62:	a1 54 37 11 80       	mov    0x80113754,%eax
80102e67:	83 ec 08             	sub    $0x8,%esp
80102e6a:	01 d8                	add    %ebx,%eax
80102e6c:	83 c0 01             	add    $0x1,%eax
80102e6f:	50                   	push   %eax
80102e70:	ff 35 64 37 11 80    	pushl  0x80113764
80102e76:	e8 55 d2 ff ff       	call   801000d0 <bread>
80102e7b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	58                   	pop    %eax
80102e7e:	5a                   	pop    %edx
80102e7f:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102e86:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
80102e8c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8f:	e8 3c d2 ff ff       	call   801000d0 <bread>
80102e94:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e96:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e99:	83 c4 0c             	add    $0xc,%esp
80102e9c:	68 00 02 00 00       	push   $0x200
80102ea1:	50                   	push   %eax
80102ea2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ea5:	50                   	push   %eax
80102ea6:	e8 65 24 00 00       	call   80105310 <memmove>
    bwrite(to);  // write the log
80102eab:	89 34 24             	mov    %esi,(%esp)
80102eae:	e8 ed d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102eb3:	89 3c 24             	mov    %edi,(%esp)
80102eb6:	e8 25 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ebb:	89 34 24             	mov    %esi,(%esp)
80102ebe:	e8 1d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec3:	83 c4 10             	add    $0x10,%esp
80102ec6:	3b 1d 68 37 11 80    	cmp    0x80113768,%ebx
80102ecc:	7c 94                	jl     80102e62 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ece:	e8 bd fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102ed3:	e8 18 fd ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102ed8:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80102edf:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ee2:	e8 a9 fd ff ff       	call   80102c90 <write_head>
    acquire(&log.lock);
80102ee7:	83 ec 0c             	sub    $0xc,%esp
80102eea:	68 20 37 11 80       	push   $0x80113720
80102eef:	e8 5c 22 00 00       	call   80105150 <acquire>
    wakeup(&log);
80102ef4:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
80102efb:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80102f02:	00 00 00 
    wakeup(&log);
80102f05:	e8 a6 17 00 00       	call   801046b0 <wakeup>
    release(&log.lock);
80102f0a:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102f11:	e8 fa 22 00 00       	call   80105210 <release>
80102f16:	83 c4 10             	add    $0x10,%esp
}
80102f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1c:	5b                   	pop    %ebx
80102f1d:	5e                   	pop    %esi
80102f1e:	5f                   	pop    %edi
80102f1f:	5d                   	pop    %ebp
80102f20:	c3                   	ret    
80102f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f28:	83 ec 0c             	sub    $0xc,%esp
80102f2b:	68 20 37 11 80       	push   $0x80113720
80102f30:	e8 7b 17 00 00       	call   801046b0 <wakeup>
  release(&log.lock);
80102f35:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102f3c:	e8 cf 22 00 00       	call   80105210 <release>
80102f41:	83 c4 10             	add    $0x10,%esp
}
80102f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f47:	5b                   	pop    %ebx
80102f48:	5e                   	pop    %esi
80102f49:	5f                   	pop    %edi
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    
    panic("log.committing");
80102f4c:	83 ec 0c             	sub    $0xc,%esp
80102f4f:	68 c4 85 10 80       	push   $0x801085c4
80102f54:	e8 37 d4 ff ff       	call   80100390 <panic>
80102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f67:	8b 15 68 37 11 80    	mov    0x80113768,%edx
{
80102f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f70:	83 fa 1d             	cmp    $0x1d,%edx
80102f73:	0f 8f 9d 00 00 00    	jg     80103016 <log_write+0xb6>
80102f79:	a1 58 37 11 80       	mov    0x80113758,%eax
80102f7e:	83 e8 01             	sub    $0x1,%eax
80102f81:	39 c2                	cmp    %eax,%edx
80102f83:	0f 8d 8d 00 00 00    	jge    80103016 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f89:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102f8e:	85 c0                	test   %eax,%eax
80102f90:	0f 8e 8d 00 00 00    	jle    80103023 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f96:	83 ec 0c             	sub    $0xc,%esp
80102f99:	68 20 37 11 80       	push   $0x80113720
80102f9e:	e8 ad 21 00 00       	call   80105150 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fa3:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102fa9:	83 c4 10             	add    $0x10,%esp
80102fac:	83 f9 00             	cmp    $0x0,%ecx
80102faf:	7e 57                	jle    80103008 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102fb4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb6:	3b 15 6c 37 11 80    	cmp    0x8011376c,%edx
80102fbc:	75 0b                	jne    80102fc9 <log_write+0x69>
80102fbe:	eb 38                	jmp    80102ff8 <log_write+0x98>
80102fc0:	39 14 85 6c 37 11 80 	cmp    %edx,-0x7feec894(,%eax,4)
80102fc7:	74 2f                	je     80102ff8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102fc9:	83 c0 01             	add    $0x1,%eax
80102fcc:	39 c1                	cmp    %eax,%ecx
80102fce:	75 f0                	jne    80102fc0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102fd7:	83 c0 01             	add    $0x1,%eax
80102fda:	a3 68 37 11 80       	mov    %eax,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
80102fdf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102fe2:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
80102fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fec:	c9                   	leave  
  release(&log.lock);
80102fed:	e9 1e 22 00 00       	jmp    80105210 <release>
80102ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ff8:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
80102fff:	eb de                	jmp    80102fdf <log_write+0x7f>
80103001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103008:	8b 43 08             	mov    0x8(%ebx),%eax
8010300b:	a3 6c 37 11 80       	mov    %eax,0x8011376c
  if (i == log.lh.n)
80103010:	75 cd                	jne    80102fdf <log_write+0x7f>
80103012:	31 c0                	xor    %eax,%eax
80103014:	eb c1                	jmp    80102fd7 <log_write+0x77>
    panic("too big a transaction");
80103016:	83 ec 0c             	sub    $0xc,%esp
80103019:	68 d3 85 10 80       	push   $0x801085d3
8010301e:	e8 6d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103023:	83 ec 0c             	sub    $0xc,%esp
80103026:	68 e9 85 10 80       	push   $0x801085e9
8010302b:	e8 60 d3 ff ff       	call   80100390 <panic>

80103030 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	53                   	push   %ebx
80103034:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103037:	e8 f4 09 00 00       	call   80103a30 <cpuid>
8010303c:	89 c3                	mov    %eax,%ebx
8010303e:	e8 ed 09 00 00       	call   80103a30 <cpuid>
80103043:	83 ec 04             	sub    $0x4,%esp
80103046:	53                   	push   %ebx
80103047:	50                   	push   %eax
80103048:	68 04 86 10 80       	push   $0x80108604
8010304d:	e8 0e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103052:	e8 d9 38 00 00       	call   80106930 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103057:	e8 54 09 00 00       	call   801039b0 <mycpu>
8010305c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010305e:	b8 01 00 00 00       	mov    $0x1,%eax
80103063:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010306a:	e8 91 0f 00 00       	call   80104000 <scheduler>
8010306f:	90                   	nop

80103070 <mpenter>:
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103076:	e8 a5 49 00 00       	call   80107a20 <switchkvm>
  seginit();
8010307b:	e8 10 49 00 00       	call   80107990 <seginit>
  lapicinit();
80103080:	e8 9b f7 ff ff       	call   80102820 <lapicinit>
  mpmain();
80103085:	e8 a6 ff ff ff       	call   80103030 <mpmain>
8010308a:	66 90                	xchg   %ax,%ax
8010308c:	66 90                	xchg   %ax,%ax
8010308e:	66 90                	xchg   %ax,%ax

80103090 <main>:
{
80103090:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103094:	83 e4 f0             	and    $0xfffffff0,%esp
80103097:	ff 71 fc             	pushl  -0x4(%ecx)
8010309a:	55                   	push   %ebp
8010309b:	89 e5                	mov    %esp,%ebp
8010309d:	53                   	push   %ebx
8010309e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010309f:	83 ec 08             	sub    $0x8,%esp
801030a2:	68 00 00 40 80       	push   $0x80400000
801030a7:	68 48 8e 11 80       	push   $0x80118e48
801030ac:	e8 2f f5 ff ff       	call   801025e0 <kinit1>
  kvmalloc();      // kernel page table
801030b1:	e8 3a 4e 00 00       	call   80107ef0 <kvmalloc>
  mpinit();        // detect other processors
801030b6:	e8 75 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030bb:	e8 60 f7 ff ff       	call   80102820 <lapicinit>
  seginit();       // segment descriptors
801030c0:	e8 cb 48 00 00       	call   80107990 <seginit>
  picinit();       // disable pic
801030c5:	e8 46 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
801030ca:	e8 41 f3 ff ff       	call   80102410 <ioapicinit>
  consoleinit();   // console hardware
801030cf:	e8 bc da ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
801030d4:	e8 87 3b 00 00       	call   80106c60 <uartinit>
  pinit();         // process table
801030d9:	e8 b2 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
801030de:	e8 cd 37 00 00       	call   801068b0 <tvinit>
  binit();         // buffer cache
801030e3:	e8 58 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030e8:	e8 63 de ff ff       	call   80100f50 <fileinit>
  ideinit();       // disk 
801030ed:	e8 fe f0 ff ff       	call   801021f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030f2:	83 c4 0c             	add    $0xc,%esp
801030f5:	68 8a 00 00 00       	push   $0x8a
801030fa:	68 8c b4 10 80       	push   $0x8010b48c
801030ff:	68 00 70 00 80       	push   $0x80007000
80103104:	e8 07 22 00 00       	call   80105310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103109:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
80103110:	00 00 00 
80103113:	83 c4 10             	add    $0x10,%esp
80103116:	05 20 38 11 80       	add    $0x80113820,%eax
8010311b:	3d 20 38 11 80       	cmp    $0x80113820,%eax
80103120:	76 71                	jbe    80103193 <main+0x103>
80103122:	bb 20 38 11 80       	mov    $0x80113820,%ebx
80103127:	89 f6                	mov    %esi,%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103130:	e8 7b 08 00 00       	call   801039b0 <mycpu>
80103135:	39 d8                	cmp    %ebx,%eax
80103137:	74 41                	je     8010317a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103139:	e8 72 f5 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103143:	c7 05 f8 6f 00 80 70 	movl   $0x80103070,0x80006ff8
8010314a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010314d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103154:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103157:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010315c:	0f b6 03             	movzbl (%ebx),%eax
8010315f:	83 ec 08             	sub    $0x8,%esp
80103162:	68 00 70 00 00       	push   $0x7000
80103167:	50                   	push   %eax
80103168:	e8 03 f8 ff ff       	call   80102970 <lapicstartap>
8010316d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010317a:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
80103181:	00 00 00 
80103184:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010318a:	05 20 38 11 80       	add    $0x80113820,%eax
8010318f:	39 c3                	cmp    %eax,%ebx
80103191:	72 9d                	jb     80103130 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103193:	83 ec 08             	sub    $0x8,%esp
80103196:	68 00 00 00 8e       	push   $0x8e000000
8010319b:	68 00 00 40 80       	push   $0x80400000
801031a0:	e8 ab f4 ff ff       	call   80102650 <kinit2>
  userinit();      // first user process
801031a5:	e8 46 09 00 00       	call   80103af0 <userinit>
  mpmain();        // finish this processor's setup
801031aa:	e8 81 fe ff ff       	call   80103030 <mpmain>
801031af:	90                   	nop

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	90                   	nop
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	39 fb                	cmp    %edi,%ebx
801031d2:	89 fe                	mov    %edi,%esi
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 18 86 10 80       	push   $0x80108618
801031e3:	56                   	push   %esi
801031e4:	e8 c7 20 00 00       	call   801052b0 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f1                	mov    %esi,%ecx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 11             	movzbl (%ecx),%edx
801031fb:	83 c1 01             	add    $0x1,%ecx
801031fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103200:	39 f9                	cmp    %edi,%ecx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	89 f0                	mov    %esi,%eax
8010321f:	5b                   	pop    %ebx
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010322a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	85 c0                	test   %eax,%eax
80103251:	75 1b                	jne    8010326e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103253:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010325a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103261:	c1 e0 08             	shl    $0x8,%eax
80103264:	09 d0                	or     %edx,%eax
80103266:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103269:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326e:	ba 00 04 00 00       	mov    $0x400,%edx
80103273:	e8 38 ff ff ff       	call   801031b0 <mpsearch1>
80103278:	85 c0                	test   %eax,%eax
8010327a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010327d:	0f 84 3d 01 00 00    	je     801033c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103286:	8b 58 04             	mov    0x4(%eax),%ebx
80103289:	85 db                	test   %ebx,%ebx
8010328b:	0f 84 4f 01 00 00    	je     801033e0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103291:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103297:	83 ec 04             	sub    $0x4,%esp
8010329a:	6a 04                	push   $0x4
8010329c:	68 35 86 10 80       	push   $0x80108635
801032a1:	56                   	push   %esi
801032a2:	e8 09 20 00 00       	call   801052b0 <memcmp>
801032a7:	83 c4 10             	add    $0x10,%esp
801032aa:	85 c0                	test   %eax,%eax
801032ac:	0f 85 2e 01 00 00    	jne    801033e0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801032b2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032b9:	3c 01                	cmp    $0x1,%al
801032bb:	0f 95 c2             	setne  %dl
801032be:	3c 04                	cmp    $0x4,%al
801032c0:	0f 95 c0             	setne  %al
801032c3:	20 c2                	and    %al,%dl
801032c5:	0f 85 15 01 00 00    	jne    801033e0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801032cb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801032d2:	66 85 ff             	test   %di,%di
801032d5:	74 1a                	je     801032f1 <mpinit+0xc1>
801032d7:	89 f0                	mov    %esi,%eax
801032d9:	01 f7                	add    %esi,%edi
  sum = 0;
801032db:	31 d2                	xor    %edx,%edx
801032dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032e0:	0f b6 08             	movzbl (%eax),%ecx
801032e3:	83 c0 01             	add    $0x1,%eax
801032e6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e8:	39 c7                	cmp    %eax,%edi
801032ea:	75 f4                	jne    801032e0 <mpinit+0xb0>
801032ec:	84 d2                	test   %dl,%dl
801032ee:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032f1:	85 f6                	test   %esi,%esi
801032f3:	0f 84 e7 00 00 00    	je     801033e0 <mpinit+0x1b0>
801032f9:	84 d2                	test   %dl,%dl
801032fb:	0f 85 df 00 00 00    	jne    801033e0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103301:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103307:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103313:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103319:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331e:	01 d6                	add    %edx,%esi
80103320:	39 c6                	cmp    %eax,%esi
80103322:	76 23                	jbe    80103347 <mpinit+0x117>
    switch(*p){
80103324:	0f b6 10             	movzbl (%eax),%edx
80103327:	80 fa 04             	cmp    $0x4,%dl
8010332a:	0f 87 ca 00 00 00    	ja     801033fa <mpinit+0x1ca>
80103330:	ff 24 95 5c 86 10 80 	jmp    *-0x7fef79a4(,%edx,4)
80103337:	89 f6                	mov    %esi,%esi
80103339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103340:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103343:	39 c6                	cmp    %eax,%esi
80103345:	77 dd                	ja     80103324 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103347:	85 db                	test   %ebx,%ebx
80103349:	0f 84 9e 00 00 00    	je     801033ed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103352:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103356:	74 15                	je     8010336d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103358:	b8 70 00 00 00       	mov    $0x70,%eax
8010335d:	ba 22 00 00 00       	mov    $0x22,%edx
80103362:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103363:	ba 23 00 00 00       	mov    $0x23,%edx
80103368:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103369:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336c:	ee                   	out    %al,(%dx)
  }
}
8010336d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103370:	5b                   	pop    %ebx
80103371:	5e                   	pop    %esi
80103372:	5f                   	pop    %edi
80103373:	5d                   	pop    %ebp
80103374:	c3                   	ret    
80103375:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103378:	8b 0d a0 3d 11 80    	mov    0x80113da0,%ecx
8010337e:	83 f9 07             	cmp    $0x7,%ecx
80103381:	7f 19                	jg     8010339c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103383:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103387:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010338d:	83 c1 01             	add    $0x1,%ecx
80103390:	89 0d a0 3d 11 80    	mov    %ecx,0x80113da0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103396:	88 97 20 38 11 80    	mov    %dl,-0x7feec7e0(%edi)
      p += sizeof(struct mpproc);
8010339c:	83 c0 14             	add    $0x14,%eax
      continue;
8010339f:	e9 7c ff ff ff       	jmp    80103320 <mpinit+0xf0>
801033a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033af:	88 15 00 38 11 80    	mov    %dl,0x80113800
      continue;
801033b5:	e9 66 ff ff ff       	jmp    80103320 <mpinit+0xf0>
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801033c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ca:	e8 e1 fd ff ff       	call   801031b0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033cf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801033d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033d4:	0f 85 a9 fe ff ff    	jne    80103283 <mpinit+0x53>
801033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	68 1d 86 10 80       	push   $0x8010861d
801033e8:	e8 a3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	68 3c 86 10 80       	push   $0x8010863c
801033f5:	e8 96 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033fa:	31 db                	xor    %ebx,%ebx
801033fc:	e9 26 ff ff ff       	jmp    80103327 <mpinit+0xf7>
80103401:	66 90                	xchg   %ax,%ax
80103403:	66 90                	xchg   %ax,%ax
80103405:	66 90                	xchg   %ax,%ax
80103407:	66 90                	xchg   %ax,%ax
80103409:	66 90                	xchg   %ax,%ax
8010340b:	66 90                	xchg   %ax,%ax
8010340d:	66 90                	xchg   %ax,%ax
8010340f:	90                   	nop

80103410 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103410:	55                   	push   %ebp
80103411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103416:	ba 21 00 00 00       	mov    $0x21,%edx
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	ee                   	out    %al,(%dx)
8010341e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103423:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103424:	5d                   	pop    %ebp
80103425:	c3                   	ret    
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 20 db ff ff       	call   80100f70 <filealloc>
80103450:	85 c0                	test   %eax,%eax
80103452:	89 03                	mov    %eax,(%ebx)
80103454:	74 22                	je     80103478 <pipealloc+0x48>
80103456:	e8 15 db ff ff       	call   80100f70 <filealloc>
8010345b:	85 c0                	test   %eax,%eax
8010345d:	89 06                	mov    %eax,(%esi)
8010345f:	74 3f                	je     801034a0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103461:	e8 4a f2 ff ff       	call   801026b0 <kalloc>
80103466:	85 c0                	test   %eax,%eax
80103468:	89 c7                	mov    %eax,%edi
8010346a:	75 54                	jne    801034c0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010346c:	8b 03                	mov    (%ebx),%eax
8010346e:	85 c0                	test   %eax,%eax
80103470:	75 34                	jne    801034a6 <pipealloc+0x76>
80103472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103478:	8b 06                	mov    (%esi),%eax
8010347a:	85 c0                	test   %eax,%eax
8010347c:	74 0c                	je     8010348a <pipealloc+0x5a>
    fileclose(*f1);
8010347e:	83 ec 0c             	sub    $0xc,%esp
80103481:	50                   	push   %eax
80103482:	e8 a9 db ff ff       	call   80101030 <fileclose>
80103487:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010348a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010348d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103492:	5b                   	pop    %ebx
80103493:	5e                   	pop    %esi
80103494:	5f                   	pop    %edi
80103495:	5d                   	pop    %ebp
80103496:	c3                   	ret    
80103497:	89 f6                	mov    %esi,%esi
80103499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801034a0:	8b 03                	mov    (%ebx),%eax
801034a2:	85 c0                	test   %eax,%eax
801034a4:	74 e4                	je     8010348a <pipealloc+0x5a>
    fileclose(*f0);
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	50                   	push   %eax
801034aa:	e8 81 db ff ff       	call   80101030 <fileclose>
  if(*f1)
801034af:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801034b1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034b4:	85 c0                	test   %eax,%eax
801034b6:	75 c6                	jne    8010347e <pipealloc+0x4e>
801034b8:	eb d0                	jmp    8010348a <pipealloc+0x5a>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801034c0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801034c3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ca:	00 00 00 
  p->writeopen = 1;
801034cd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034d4:	00 00 00 
  p->nwrite = 0;
801034d7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034de:	00 00 00 
  p->nread = 0;
801034e1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034e8:	00 00 00 
  initlock(&p->lock, "pipe");
801034eb:	68 70 86 10 80       	push   $0x80108670
801034f0:	50                   	push   %eax
801034f1:	e8 1a 1b 00 00       	call   80105010 <initlock>
  (*f0)->type = FD_PIPE;
801034f6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034f8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103501:	8b 03                	mov    (%ebx),%eax
80103503:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103507:	8b 03                	mov    (%ebx),%eax
80103509:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010350d:	8b 03                	mov    (%ebx),%eax
8010350f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103512:	8b 06                	mov    (%esi),%eax
80103514:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010351a:	8b 06                	mov    (%esi),%eax
8010351c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103520:	8b 06                	mov    (%esi),%eax
80103522:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103526:	8b 06                	mov    (%esi),%eax
80103528:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010352b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010352e:	31 c0                	xor    %eax,%eax
}
80103530:	5b                   	pop    %ebx
80103531:	5e                   	pop    %esi
80103532:	5f                   	pop    %edi
80103533:	5d                   	pop    %ebp
80103534:	c3                   	ret    
80103535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 fc 1b 00 00       	call   80105150 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 45                	je     801035a0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103561:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 3c 11 00 00       	call   801046b0 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 35                	je     801035c0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 77 1c 00 00       	jmp    80105210 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035a0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035a6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801035a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035b0:	00 00 00 
    wakeup(&p->nwrite);
801035b3:	50                   	push   %eax
801035b4:	e8 f7 10 00 00       	call   801046b0 <wakeup>
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	eb b9                	jmp    80103577 <pipeclose+0x37>
801035be:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 47 1c 00 00       	call   80105210 <release>
    kfree((char*)p);
801035c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035cc:	83 c4 10             	add    $0x10,%esp
}
801035cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d2:	5b                   	pop    %ebx
801035d3:	5e                   	pop    %esi
801035d4:	5d                   	pop    %ebp
    kfree((char*)p);
801035d5:	e9 26 ef ff ff       	jmp    80102500 <kfree>
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 5e 1b 00 00       	call   80105150 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c9 00 00 00    	jle    801036c9 <pipewrite+0xe9>
80103600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103603:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103612:	03 4d 10             	add    0x10(%ebp),%ecx
80103615:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010361e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103624:	39 d0                	cmp    %edx,%eax
80103626:	75 71                	jne    80103699 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103628:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010362e:	85 c0                	test   %eax,%eax
80103630:	74 4e                	je     80103680 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103632:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103638:	eb 3a                	jmp    80103674 <pipewrite+0x94>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	57                   	push   %edi
80103644:	e8 67 10 00 00       	call   801046b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103649:	5a                   	pop    %edx
8010364a:	59                   	pop    %ecx
8010364b:	53                   	push   %ebx
8010364c:	56                   	push   %esi
8010364d:	e8 9e 0e 00 00       	call   801044f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103652:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103658:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010365e:	83 c4 10             	add    $0x10,%esp
80103661:	05 00 02 00 00       	add    $0x200,%eax
80103666:	39 c2                	cmp    %eax,%edx
80103668:	75 36                	jne    801036a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010366a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103670:	85 c0                	test   %eax,%eax
80103672:	74 0c                	je     80103680 <pipewrite+0xa0>
80103674:	e8 47 04 00 00       	call   80103ac0 <myproc>
80103679:	8b 40 24             	mov    0x24(%eax),%eax
8010367c:	85 c0                	test   %eax,%eax
8010367e:	74 c0                	je     80103640 <pipewrite+0x60>
        release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	53                   	push   %ebx
80103684:	e8 87 1b 00 00       	call   80105210 <release>
        return -1;
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103691:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103694:	5b                   	pop    %ebx
80103695:	5e                   	pop    %esi
80103696:	5f                   	pop    %edi
80103697:	5d                   	pop    %ebp
80103698:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103699:	89 c2                	mov    %eax,%edx
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036a3:	8d 42 01             	lea    0x1(%edx),%eax
801036a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036ac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036b2:	83 c6 01             	add    $0x1,%esi
801036b5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801036b9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036bc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036bf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c3:	0f 85 4f ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036cf:	83 ec 0c             	sub    $0xc,%esp
801036d2:	50                   	push   %eax
801036d3:	e8 d8 0f 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
801036d8:	89 1c 24             	mov    %ebx,(%esp)
801036db:	e8 30 1b 00 00       	call   80105210 <release>
  return n;
801036e0:	83 c4 10             	add    $0x10,%esp
801036e3:	8b 45 10             	mov    0x10(%ebp),%eax
801036e6:	eb a9                	jmp    80103691 <pipewrite+0xb1>
801036e8:	90                   	nop
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	e8 4b 1a 00 00       	call   80105150 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010370e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103714:	75 6a                	jne    80103780 <piperead+0x90>
80103716:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010371c:	85 db                	test   %ebx,%ebx
8010371e:	0f 84 c4 00 00 00    	je     801037e8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103724:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010372a:	eb 2d                	jmp    80103759 <piperead+0x69>
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 b6 0d 00 00       	call   801044f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	83 c4 10             	add    $0x10,%esp
8010373d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103743:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103749:	75 35                	jne    80103780 <piperead+0x90>
8010374b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103751:	85 d2                	test   %edx,%edx
80103753:	0f 84 8f 00 00 00    	je     801037e8 <piperead+0xf8>
    if(myproc()->killed){
80103759:	e8 62 03 00 00       	call   80103ac0 <myproc>
8010375e:	8b 48 24             	mov    0x24(%eax),%ecx
80103761:	85 c9                	test   %ecx,%ecx
80103763:	74 cb                	je     80103730 <piperead+0x40>
      release(&p->lock);
80103765:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103768:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010376d:	56                   	push   %esi
8010376e:	e8 9d 1a 00 00       	call   80105210 <release>
      return -1;
80103773:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103780:	8b 45 10             	mov    0x10(%ebp),%eax
80103783:	85 c0                	test   %eax,%eax
80103785:	7e 61                	jle    801037e8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103787:	31 db                	xor    %ebx,%ebx
80103789:	eb 13                	jmp    8010379e <piperead+0xae>
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103790:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103796:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010379c:	74 1f                	je     801037bd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010379e:	8d 41 01             	lea    0x1(%ecx),%eax
801037a1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801037a7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801037ad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801037b2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b5:	83 c3 01             	add    $0x1,%ebx
801037b8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bb:	75 d3                	jne    80103790 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037bd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037c3:	83 ec 0c             	sub    $0xc,%esp
801037c6:	50                   	push   %eax
801037c7:	e8 e4 0e 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
801037cc:	89 34 24             	mov    %esi,(%esp)
801037cf:	e8 3c 1a 00 00       	call   80105210 <release>
  return i;
801037d4:	83 c4 10             	add    $0x10,%esp
}
801037d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037da:	89 d8                	mov    %ebx,%eax
801037dc:	5b                   	pop    %ebx
801037dd:	5e                   	pop    %esi
801037de:	5f                   	pop    %edi
801037df:	5d                   	pop    %ebp
801037e0:	c3                   	ret    
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037e8:	31 db                	xor    %ebx,%ebx
801037ea:	eb d1                	jmp    801037bd <piperead+0xcd>
801037ec:	66 90                	xchg   %ax,%ax
801037ee:	66 90                	xchg   %ax,%ax

801037f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f6:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
801037fb:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
801037fe:	68 c0 3d 11 80       	push   $0x80113dc0
80103803:	e8 48 19 00 00       	call   80105150 <acquire>
80103808:	83 c4 10             	add    $0x10,%esp
8010380b:	eb 15                	jmp    80103822 <allocproc+0x32>
8010380d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103810:	81 c3 20 01 00 00    	add    $0x120,%ebx
80103816:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
8010381c:	0f 83 3e 01 00 00    	jae    80103960 <allocproc+0x170>
    if(p->state == UNUSED)
80103822:	8b 43 0c             	mov    0xc(%ebx),%eax
80103825:	85 c0                	test   %eax,%eax
80103827:	75 e7                	jne    80103810 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103829:	a1 04 b0 10 80       	mov    0x8010b004,%eax

}

int generate_random(int m){
 int random;
 int a = ticks % m;
8010382e:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
  acquire(&tickslock);
80103833:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103836:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->visit = 0;
8010383d:	c7 83 10 01 00 00 00 	movl   $0x0,0x110(%ebx)
80103844:	00 00 00 
  p->level = 2;
80103847:	c7 83 f4 00 00 00 02 	movl   $0x2,0xf4(%ebx)
8010384e:	00 00 00 
  p->waiting_time = 0;
80103851:	c7 83 14 01 00 00 00 	movl   $0x0,0x114(%ebx)
80103858:	00 00 00 
  p->pid = nextpid++;
8010385b:	8d 50 01             	lea    0x1(%eax),%edx
8010385e:	89 43 10             	mov    %eax,0x10(%ebx)
 int a = ticks % m;
80103861:	89 f0                	mov    %esi,%eax
  p->cycle=0;
80103863:	c7 83 18 01 00 00 00 	movl   $0x0,0x118(%ebx)
8010386a:	00 00 00 
  p->pid = nextpid++;
8010386d:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
 int a = ticks % m;
80103873:	f7 25 40 8e 11 80    	mull   0x80118e40
80103879:	89 d7                	mov    %edx,%edi
8010387b:	c1 ef 05             	shr    $0x5,%edi
8010387e:	6b cf 64             	imul   $0x64,%edi,%ecx
80103881:	8b 3d 40 8e 11 80    	mov    0x80118e40,%edi
80103887:	29 cf                	sub    %ecx,%edi
 int seed = ticks % m;
 random = (a * seed )% m;
80103889:	89 f9                	mov    %edi,%ecx
8010388b:	0f af cf             	imul   %edi,%ecx
8010388e:	89 c8                	mov    %ecx,%eax
80103890:	f7 e6                	mul    %esi
80103892:	c1 ea 05             	shr    $0x5,%edx
80103895:	6b d2 64             	imul   $0x64,%edx,%edx
80103898:	29 d1                	sub    %edx,%ecx
 random = (a * random )% m;
8010389a:	0f af cf             	imul   %edi,%ecx
8010389d:	89 c8                	mov    %ecx,%eax
8010389f:	f7 e6                	mul    %esi
801038a1:	c1 ea 05             	shr    $0x5,%edx
801038a4:	6b d2 64             	imul   $0x64,%edx,%edx
801038a7:	29 d1                	sub    %edx,%ecx
  p->lottery_ticket = generate_random(100) + 1;
801038a9:	83 c1 01             	add    $0x1,%ecx
  p->priority = 1 / (float) p->lottery_ticket;
801038ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  p->lottery_ticket = generate_random(100) + 1;
801038af:	89 8b 0c 01 00 00    	mov    %ecx,0x10c(%ebx)
  p->priority = 1 / (float) p->lottery_ticket;
801038b5:	db 45 e4             	fildl  -0x1c(%ebp)
801038b8:	d8 3d dc 89 10 80    	fdivrs 0x801089dc
801038be:	d9 9b f8 00 00 00    	fstps  0xf8(%ebx)
  acquire(&tickslock);
801038c4:	68 00 86 11 80       	push   $0x80118600
801038c9:	e8 82 18 00 00       	call   80105150 <acquire>
  p->arrivt = ticks;
801038ce:	a1 40 8e 11 80       	mov    0x80118e40,%eax
801038d3:	89 83 1c 01 00 00    	mov    %eax,0x11c(%ebx)
  release(&tickslock);
801038d9:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
801038e0:	e8 2b 19 00 00       	call   80105210 <release>
  p->priority_ratio = 0.1;
801038e5:	d9 05 e0 89 10 80    	flds   0x801089e0
  p->exect = 0;
801038eb:	c7 83 04 01 00 00 00 	movl   $0x0,0x104(%ebx)
801038f2:	00 00 00 
  p->priority_ratio = 0.1;
801038f5:	d9 93 fc 00 00 00    	fsts   0xfc(%ebx)
  p->arrivt_ratio = 0.1;
801038fb:	d9 93 00 01 00 00    	fsts   0x100(%ebx)
  p->exect_ratio = 0.1;
80103901:	d9 9b 08 01 00 00    	fstps  0x108(%ebx)
  release(&ptable.lock);
80103907:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010390e:	e8 fd 18 00 00       	call   80105210 <release>
  if((p->kstack = kalloc()) == 0){
80103913:	e8 98 ed ff ff       	call   801026b0 <kalloc>
80103918:	83 c4 10             	add    $0x10,%esp
8010391b:	85 c0                	test   %eax,%eax
8010391d:	89 43 08             	mov    %eax,0x8(%ebx)
80103920:	74 5a                	je     8010397c <allocproc+0x18c>
  sp -= sizeof *p->tf;
80103922:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103928:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010392b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103930:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103933:	c7 40 14 97 68 10 80 	movl   $0x80106897,0x14(%eax)
  p->context = (struct context*)sp;
8010393a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010393d:	6a 14                	push   $0x14
8010393f:	6a 00                	push   $0x0
80103941:	50                   	push   %eax
80103942:	e8 19 19 00 00       	call   80105260 <memset>
  p->context->eip = (uint)forkret;
80103947:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
8010394a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010394d:	c7 40 10 50 3a 10 80 	movl   $0x80103a50,0x10(%eax)
}
80103954:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103957:	89 d8                	mov    %ebx,%eax
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5f                   	pop    %edi
8010395c:	5d                   	pop    %ebp
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103963:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103965:	68 c0 3d 11 80       	push   $0x80113dc0
8010396a:	e8 a1 18 00 00       	call   80105210 <release>
  return 0;
8010396f:	83 c4 10             	add    $0x10,%esp
}
80103972:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103975:	89 d8                	mov    %ebx,%eax
80103977:	5b                   	pop    %ebx
80103978:	5e                   	pop    %esi
80103979:	5f                   	pop    %edi
8010397a:	5d                   	pop    %ebp
8010397b:	c3                   	ret    
    p->state = UNUSED;
8010397c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103983:	31 db                	xor    %ebx,%ebx
80103985:	eb cd                	jmp    80103954 <allocproc+0x164>
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 75 86 10 80       	push   $0x80108675
8010399b:	68 c0 3d 11 80       	push   $0x80113dc0
801039a0:	e8 6b 16 00 00       	call   80105010 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave  
801039a9:	c3                   	ret    
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf  
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 5e                	jne    80103a1a <mycpu+0x6a>
  apicid = lapicid();
801039bc:	e8 5f ef ff ff       	call   80102920 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 a0 3d 11 80    	mov    0x80113da0,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 42                	jle    80103a0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039cb:	0f b6 15 20 38 11 80 	movzbl 0x80113820,%edx
801039d2:	39 d0                	cmp    %edx,%eax
801039d4:	74 30                	je     80103a06 <mycpu+0x56>
801039d6:	b9 d0 38 11 80       	mov    $0x801138d0,%ecx
  for (i = 0; i < ncpu; ++i) {
801039db:	31 d2                	xor    %edx,%edx
801039dd:	8d 76 00             	lea    0x0(%esi),%esi
801039e0:	83 c2 01             	add    $0x1,%edx
801039e3:	39 f2                	cmp    %esi,%edx
801039e5:	74 26                	je     80103a0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039e7:	0f b6 19             	movzbl (%ecx),%ebx
801039ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039f0:	39 c3                	cmp    %eax,%ebx
801039f2:	75 ec                	jne    801039e0 <mycpu+0x30>
801039f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801039fa:	05 20 38 11 80       	add    $0x80113820,%eax
}
801039ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a02:	5b                   	pop    %ebx
80103a03:	5e                   	pop    %esi
80103a04:	5d                   	pop    %ebp
80103a05:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a06:	b8 20 38 11 80       	mov    $0x80113820,%eax
      return &cpus[i];
80103a0b:	eb f2                	jmp    801039ff <mycpu+0x4f>
  panic("unknown apicid\n");
80103a0d:	83 ec 0c             	sub    $0xc,%esp
80103a10:	68 7c 86 10 80       	push   $0x8010867c
80103a15:	e8 76 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	68 44 88 10 80       	push   $0x80108844
80103a22:	e8 69 c9 ff ff       	call   80100390 <panic>
80103a27:	89 f6                	mov    %esi,%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <cpuid>:
cpuid() {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a36:	e8 75 ff ff ff       	call   801039b0 <mycpu>
80103a3b:	2d 20 38 11 80       	sub    $0x80113820,%eax
}
80103a40:	c9                   	leave  
  return mycpu()-cpus;
80103a41:	c1 f8 04             	sar    $0x4,%eax
80103a44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a4a:	c3                   	ret    
80103a4b:	90                   	nop
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a57:	e8 24 16 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103a5c:	e8 4f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a67:	e8 54 16 00 00       	call   801050c0 <popcli>
  //myproc()->exect = 0.1;
  //myproc()->exect_ratio = gen_rand(50) / 100;
 
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a6c:	83 ec 0c             	sub    $0xc,%esp
  myproc()->call_nums[0] ++;
80103a6f:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
  release(&ptable.lock);
80103a73:	68 c0 3d 11 80       	push   $0x80113dc0
80103a78:	e8 93 17 00 00       	call   80105210 <release>

  if (first) {
80103a7d:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a82:	83 c4 10             	add    $0x10,%esp
80103a85:	85 c0                	test   %eax,%eax
80103a87:	74 23                	je     80103aac <forkret+0x5c>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103a89:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a8c:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a93:	00 00 00 
    iinit(ROOTDEV);
80103a96:	6a 01                	push   $0x1
80103a98:	e8 d3 db ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103a9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aa4:	e8 47 f2 ff ff       	call   80102cf0 <initlog>
80103aa9:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aaf:	c9                   	leave  
80103ab0:	c3                   	ret    
80103ab1:	eb 0d                	jmp    80103ac0 <myproc>
80103ab3:	90                   	nop
80103ab4:	90                   	nop
80103ab5:	90                   	nop
80103ab6:	90                   	nop
80103ab7:	90                   	nop
80103ab8:	90                   	nop
80103ab9:	90                   	nop
80103aba:	90                   	nop
80103abb:	90                   	nop
80103abc:	90                   	nop
80103abd:	90                   	nop
80103abe:	90                   	nop
80103abf:	90                   	nop

80103ac0 <myproc>:
myproc(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ac7:	e8 b4 15 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103acc:	e8 df fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103ad1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad7:	e8 e4 15 00 00       	call   801050c0 <popcli>
}
80103adc:	83 c4 04             	add    $0x4,%esp
80103adf:	89 d8                	mov    %ebx,%eax
80103ae1:	5b                   	pop    %ebx
80103ae2:	5d                   	pop    %ebp
80103ae3:	c3                   	ret    
80103ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103af0 <userinit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103af7:	e8 f4 fc ff ff       	call   801037f0 <allocproc>
80103afc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103afe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b03:	e8 68 43 00 00       	call   80107e70 <setupkvm>
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b0d:	0f 84 bd 00 00 00    	je     80103bd0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b13:	83 ec 04             	sub    $0x4,%esp
80103b16:	68 2c 00 00 00       	push   $0x2c
80103b1b:	68 60 b4 10 80       	push   $0x8010b460
80103b20:	50                   	push   %eax
80103b21:	e8 2a 40 00 00       	call   80107b50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b2f:	6a 4c                	push   $0x4c
80103b31:	6a 00                	push   $0x0
80103b33:	ff 73 18             	pushl  0x18(%ebx)
80103b36:	e8 25 17 00 00       	call   80105260 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b61:	8b 43 18             	mov    0x18(%ebx),%eax
80103b64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b80:	8b 43 18             	mov    0x18(%ebx),%eax
80103b83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8d:	6a 10                	push   $0x10
80103b8f:	68 a5 86 10 80       	push   $0x801086a5
80103b94:	50                   	push   %eax
80103b95:	e8 a6 18 00 00       	call   80105440 <safestrcpy>
  p->cwd = namei("/");
80103b9a:	c7 04 24 ae 86 10 80 	movl   $0x801086ae,(%esp)
80103ba1:	e8 2a e5 ff ff       	call   801020d0 <namei>
80103ba6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ba9:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103bb0:	e8 9b 15 00 00       	call   80105150 <acquire>
  p->state = RUNNABLE;
80103bb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bbc:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103bc3:	e8 48 16 00 00       	call   80105210 <release>
}
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bce:	c9                   	leave  
80103bcf:	c3                   	ret    
    panic("userinit: out of memory?");
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	68 8c 86 10 80       	push   $0x8010868c
80103bd8:	e8 b3 c7 ff ff       	call   80100390 <panic>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi

80103be0 <growproc>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103be8:	e8 93 14 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103bed:	e8 be fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103bf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf8:	e8 c3 14 00 00       	call   801050c0 <popcli>
  if(n > 0){
80103bfd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c02:	7f 1c                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c04:	75 3a                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0b:	53                   	push   %ebx
80103c0c:	e8 2f 3e 00 00       	call   80107a40 <switchuvm>
  return 0;
80103c11:	83 c4 10             	add    $0x10,%esp
80103c14:	31 c0                	xor    %eax,%eax
}
80103c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c19:	5b                   	pop    %ebx
80103c1a:	5e                   	pop    %esi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	pushl  0x4(%ebx)
80103c2a:	e8 61 40 00 00       	call   80107c90 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 d0                	jne    80103c06 <growproc+0x26>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb d9                	jmp    80103c16 <growproc+0x36>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 71 41 00 00       	call   80107dc0 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 b0                	jne    80103c06 <growproc+0x26>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <fork>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c69:	e8 12 14 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103c6e:	e8 3d fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103c73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c79:	e8 42 14 00 00       	call   801050c0 <popcli>
  if((np = allocproc()) == 0){
80103c7e:	e8 6d fb ff ff       	call   801037f0 <allocproc>
80103c83:	85 c0                	test   %eax,%eax
80103c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c88:	0f 84 b7 00 00 00    	je     80103d45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c8e:	83 ec 08             	sub    $0x8,%esp
80103c91:	ff 33                	pushl  (%ebx)
80103c93:	ff 73 04             	pushl  0x4(%ebx)
80103c96:	89 c7                	mov    %eax,%edi
80103c98:	e8 a3 42 00 00       	call   80107f40 <copyuvm>
80103c9d:	83 c4 10             	add    $0x10,%esp
80103ca0:	85 c0                	test   %eax,%eax
80103ca2:	89 47 04             	mov    %eax,0x4(%edi)
80103ca5:	0f 84 a1 00 00 00    	je     80103d4c <fork+0xec>
  np->sz = curproc->sz;
80103cab:	8b 03                	mov    (%ebx),%eax
80103cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cb0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103cb2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103cb5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103cb7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cba:	8b 73 18             	mov    0x18(%ebx),%esi
80103cbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cc6:	8b 40 18             	mov    0x18(%eax),%eax
80103cc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	74 13                	je     80103ceb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	50                   	push   %eax
80103cdc:	e8 ff d2 ff ff       	call   80100fe0 <filedup>
80103ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ceb:	83 c6 01             	add    $0x1,%esi
80103cee:	83 fe 10             	cmp    $0x10,%esi
80103cf1:	75 dd                	jne    80103cd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cfc:	e8 3f db ff ff       	call   80101840 <idup>
80103d01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	53                   	push   %ebx
80103d10:	50                   	push   %eax
80103d11:	e8 2a 17 00 00       	call   80105440 <safestrcpy>
  pid = np->pid;
80103d16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d19:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103d20:	e8 2b 14 00 00       	call   80105150 <acquire>
  np->state = RUNNABLE;
80103d25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d2c:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103d33:	e8 d8 14 00 00       	call   80105210 <release>
  return pid;
80103d38:	83 c4 10             	add    $0x10,%esp
}
80103d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3e:	89 d8                	mov    %ebx,%eax
80103d40:	5b                   	pop    %ebx
80103d41:	5e                   	pop    %esi
80103d42:	5f                   	pop    %edi
80103d43:	5d                   	pop    %ebp
80103d44:	c3                   	ret    
    return -1;
80103d45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d4a:	eb ef                	jmp    80103d3b <fork+0xdb>
    kfree(np->kstack);
80103d4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d4f:	83 ec 0c             	sub    $0xc,%esp
80103d52:	ff 73 08             	pushl  0x8(%ebx)
80103d55:	e8 a6 e7 ff ff       	call   80102500 <kfree>
    np->kstack = 0;
80103d5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d61:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d70:	eb c9                	jmp    80103d3b <fork+0xdb>
80103d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <BJF>:
struct proc * BJF(struct proc** list, int size){
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 08             	sub    $0x8,%esp
80103d89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103d8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for (int i=0; i < size; i++){
80103d8f:	85 db                	test   %ebx,%ebx
  struct proc* chosen = list[0];
80103d91:	8b 07                	mov    (%edi),%eax
  for (int i=0; i < size; i++){
80103d93:	0f 8e a7 00 00 00    	jle    80103e40 <BJF+0xc0>
    if (list[i] -> state == RUNNABLE){
80103d99:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d9d:	0f 84 fd 00 00 00    	je     80103ea0 <BJF+0x120>
  for (int i=0; i < size; i++){
80103da3:	31 c9                	xor    %ecx,%ecx
80103da5:	eb 18                	jmp    80103dbf <BJF+0x3f>
80103da7:	89 f6                	mov    %esi,%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (list[i] -> state == RUNNABLE){
80103db0:	8b 34 97             	mov    (%edi,%edx,4),%esi
80103db3:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103db7:	0f 84 93 00 00 00    	je     80103e50 <BJF+0xd0>
80103dbd:	89 d1                	mov    %edx,%ecx
  for (int i=0; i < size; i++){
80103dbf:	8d 51 01             	lea    0x1(%ecx),%edx
80103dc2:	39 d3                	cmp    %edx,%ebx
80103dc4:	75 ea                	jne    80103db0 <BJF+0x30>
80103dc6:	b9 01 00 00 00       	mov    $0x1,%ecx
  int rank = 0, ind = 0;
80103dcb:	31 f6                	xor    %esi,%esi
  for (int i=ind + 1; i < size; i++){
80103dcd:	39 cb                	cmp    %ecx,%ebx
80103dcf:	7e 6f                	jle    80103e40 <BJF+0xc0>
80103dd1:	8d 0c 8f             	lea    (%edi,%ecx,4),%ecx
80103dd4:	8d 3c 9f             	lea    (%edi,%ebx,4),%edi
80103dd7:	eb 0e                	jmp    80103de7 <BJF+0x67>
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de0:	83 c1 04             	add    $0x4,%ecx
80103de3:	39 cf                	cmp    %ecx,%edi
80103de5:	74 59                	je     80103e40 <BJF+0xc0>
    if (list[i]->state == RUNNABLE){
80103de7:	8b 11                	mov    (%ecx),%edx
80103de9:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103ded:	75 f1                	jne    80103de0 <BJF+0x60>
      int cur_rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103def:	db 82 1c 01 00 00    	fildl  0x11c(%edx)
80103df5:	d8 8a 00 01 00 00    	fmuls  0x100(%edx)
80103dfb:	d9 82 f8 00 00 00    	flds   0xf8(%edx)
80103e01:	d8 8a fc 00 00 00    	fmuls  0xfc(%edx)
80103e07:	de c1                	faddp  %st,%st(1)
80103e09:	d9 82 04 01 00 00    	flds   0x104(%edx)
80103e0f:	d8 8a 08 01 00 00    	fmuls  0x108(%edx)
80103e15:	d9 7d f2             	fnstcw -0xe(%ebp)
80103e18:	0f b7 5d f2          	movzwl -0xe(%ebp),%ebx
80103e1c:	80 cf 0c             	or     $0xc,%bh
80103e1f:	66 89 5d f0          	mov    %bx,-0x10(%ebp)
80103e23:	de c1                	faddp  %st,%st(1)
80103e25:	d9 6d f0             	fldcw  -0x10(%ebp)
80103e28:	db 5d ec             	fistpl -0x14(%ebp)
80103e2b:	d9 6d f2             	fldcw  -0xe(%ebp)
80103e2e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
      if (cur_rank < rank){
80103e31:	39 f3                	cmp    %esi,%ebx
80103e33:	7d ab                	jge    80103de0 <BJF+0x60>
80103e35:	83 c1 04             	add    $0x4,%ecx
80103e38:	89 de                	mov    %ebx,%esi
80103e3a:	89 d0                	mov    %edx,%eax
  for (int i=ind + 1; i < size; i++){
80103e3c:	39 cf                	cmp    %ecx,%edi
80103e3e:	75 a7                	jne    80103de7 <BJF+0x67>
}
80103e40:	83 c4 08             	add    $0x8,%esp
80103e43:	5b                   	pop    %ebx
80103e44:	5e                   	pop    %esi
80103e45:	5f                   	pop    %edi
80103e46:	5d                   	pop    %ebp
80103e47:	c3                   	ret    
80103e48:	90                   	nop
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e50:	83 c1 02             	add    $0x2,%ecx
    if (list[i] -> state == RUNNABLE){
80103e53:	89 f0                	mov    %esi,%eax
      rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103e55:	db 80 1c 01 00 00    	fildl  0x11c(%eax)
80103e5b:	d8 88 00 01 00 00    	fmuls  0x100(%eax)
80103e61:	d9 80 f8 00 00 00    	flds   0xf8(%eax)
80103e67:	d8 88 fc 00 00 00    	fmuls  0xfc(%eax)
80103e6d:	de c1                	faddp  %st,%st(1)
80103e6f:	d9 80 04 01 00 00    	flds   0x104(%eax)
80103e75:	d8 88 08 01 00 00    	fmuls  0x108(%eax)
80103e7b:	d9 7d f2             	fnstcw -0xe(%ebp)
80103e7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
80103e82:	80 ce 0c             	or     $0xc,%dh
80103e85:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
80103e89:	de c1                	faddp  %st,%st(1)
80103e8b:	d9 6d f0             	fldcw  -0x10(%ebp)
80103e8e:	db 5d ec             	fistpl -0x14(%ebp)
80103e91:	d9 6d f2             	fldcw  -0xe(%ebp)
80103e94:	8b 75 ec             	mov    -0x14(%ebp),%esi
      break;
80103e97:	e9 31 ff ff ff       	jmp    80103dcd <BJF+0x4d>
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (list[i] -> state == RUNNABLE){
80103ea0:	b9 01 00 00 00       	mov    $0x1,%ecx
80103ea5:	eb ae                	jmp    80103e55 <BJF+0xd5>
80103ea7:	89 f6                	mov    %esi,%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <RR>:
struct proc* RR(struct proc ** list, int size){
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
80103eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i=0; i < size; i++){
80103ebb:	85 c9                	test   %ecx,%ecx
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103ebd:	8b 02                	mov    (%edx),%eax
  for (int i=0; i < size; i++){
80103ebf:	7e 10                	jle    80103ed1 <RR+0x21>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103ec1:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ec5:	74 0a                	je     80103ed1 <RR+0x21>
80103ec7:	8b 98 10 01 00 00    	mov    0x110(%eax),%ebx
80103ecd:	85 db                	test   %ebx,%ebx
80103ecf:	75 07                	jne    80103ed8 <RR+0x28>
}
80103ed1:	5b                   	pop    %ebx
80103ed2:	5e                   	pop    %esi
80103ed3:	5d                   	pop    %ebp
80103ed4:	c3                   	ret    
80103ed5:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i=0; i < size; i++){
80103ed8:	31 db                	xor    %ebx,%ebx
80103eda:	83 c3 01             	add    $0x1,%ebx
80103edd:	39 d9                	cmp    %ebx,%ecx
80103edf:	74 1f                	je     80103f00 <RR+0x50>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103ee1:	8b 34 9a             	mov    (%edx,%ebx,4),%esi
80103ee4:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103ee8:	74 09                	je     80103ef3 <RR+0x43>
80103eea:	83 be 10 01 00 00 00 	cmpl   $0x0,0x110(%esi)
80103ef1:	75 e7                	jne    80103eda <RR+0x2a>
80103ef3:	89 f0                	mov    %esi,%eax
}
80103ef5:	5b                   	pop    %ebx
80103ef6:	5e                   	pop    %esi
80103ef7:	5d                   	pop    %ebp
80103ef8:	c3                   	ret    
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f00:	8d 72 04             	lea    0x4(%edx),%esi
80103f03:	8d 1c 8a             	lea    (%edx,%ecx,4),%ebx
  for (int i=0; i < size; i++){
80103f06:	89 f1                	mov    %esi,%ecx
80103f08:	eb 0b                	jmp    80103f15 <RR+0x65>
80103f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f10:	8b 01                	mov    (%ecx),%eax
80103f12:	83 c1 04             	add    $0x4,%ecx
  for (int i=0; i < size; i++)
80103f15:	39 d9                	cmp    %ebx,%ecx
    list[i]->visit = 0;
80103f17:	c7 80 10 01 00 00 00 	movl   $0x0,0x110(%eax)
80103f1e:	00 00 00 
  for (int i=0; i < size; i++)
80103f21:	75 ed                	jne    80103f10 <RR+0x60>
    if(list[i]->state != RUNNABLE)
80103f23:	8b 02                	mov    (%edx),%eax
80103f25:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f29:	74 a6                	je     80103ed1 <RR+0x21>
  for (int i=0; i < size; i++){
80103f2b:	39 f1                	cmp    %esi,%ecx
80103f2d:	74 a2                	je     80103ed1 <RR+0x21>
    if(list[i]->state != RUNNABLE)
80103f2f:	8b 16                	mov    (%esi),%edx
80103f31:	83 c6 04             	add    $0x4,%esi
80103f34:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103f38:	75 f1                	jne    80103f2b <RR+0x7b>
80103f3a:	89 d0                	mov    %edx,%eax
80103f3c:	eb 93                	jmp    80103ed1 <RR+0x21>
80103f3e:	66 90                	xchg   %ax,%ax

80103f40 <generate_random>:
int generate_random(int m){
80103f40:	55                   	push   %ebp
 int a = ticks % m;
80103f41:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80103f46:	31 d2                	xor    %edx,%edx
int generate_random(int m){
80103f48:	89 e5                	mov    %esp,%ebp
80103f4a:	53                   	push   %ebx
80103f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
80103f4e:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103f50:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103f52:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80103f54:	0f af c2             	imul   %edx,%eax
80103f57:	99                   	cltd   
80103f58:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103f5a:	89 d0                	mov    %edx,%eax
80103f5c:	0f af c3             	imul   %ebx,%eax
}
80103f5f:	5b                   	pop    %ebx
80103f60:	5d                   	pop    %ebp
 random = (a * random )% m;
80103f61:	99                   	cltd   
80103f62:	f7 f9                	idiv   %ecx
}
80103f64:	89 d0                	mov    %edx,%eax
80103f66:	c3                   	ret    
80103f67:	89 f6                	mov    %esi,%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <lotteryScheduling>:
struct proc* lotteryScheduling(struct proc ** list,int size){
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	8b 75 0c             	mov    0xc(%ebp),%esi
80103f78:	53                   	push   %ebx
80103f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int p = 0; p < size;p++){
80103f7c:	85 f6                	test   %esi,%esi
80103f7e:	7e 70                	jle    80103ff0 <lotteryScheduling+0x80>
80103f80:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103f83:	89 d8                	mov    %ebx,%eax
  int sum_lotteries = 0;
80103f85:	31 c9                	xor    %ecx,%ecx
80103f87:	89 f6                	mov    %esi,%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(list[p]->state == RUNNABLE)
80103f90:	8b 10                	mov    (%eax),%edx
80103f92:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103f96:	75 06                	jne    80103f9e <lotteryScheduling+0x2e>
       sum_lotteries += list[p]->lottery_ticket;
80103f98:	03 8a 0c 01 00 00    	add    0x10c(%edx),%ecx
80103f9e:	83 c0 04             	add    $0x4,%eax
  for(int p = 0; p < size;p++){
80103fa1:	39 f8                	cmp    %edi,%eax
80103fa3:	75 eb                	jne    80103f90 <lotteryScheduling+0x20>
  if(sum_lotteries == 0)
80103fa5:	85 c9                	test   %ecx,%ecx
80103fa7:	74 47                	je     80103ff0 <lotteryScheduling+0x80>
 int a = ticks % m;
80103fa9:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80103fae:	31 d2                	xor    %edx,%edx
80103fb0:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103fb2:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103fb4:	89 d7                	mov    %edx,%edi
 random = (a * seed )% m;
80103fb6:	0f af c2             	imul   %edx,%eax
80103fb9:	99                   	cltd   
80103fba:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103fbc:	89 d0                	mov    %edx,%eax
80103fbe:	0f af c7             	imul   %edi,%eax
  int curr_sum = 0;
80103fc1:	31 ff                	xor    %edi,%edi
 random = (a * random )% m;
80103fc3:	99                   	cltd   
80103fc4:	f7 f9                	idiv   %ecx
  for(int p = 0; p < size ;p++){
80103fc6:	31 c9                	xor    %ecx,%ecx
80103fc8:	eb 0d                	jmp    80103fd7 <lotteryScheduling+0x67>
80103fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fd0:	83 c1 01             	add    $0x1,%ecx
80103fd3:	39 ce                	cmp    %ecx,%esi
80103fd5:	74 19                	je     80103ff0 <lotteryScheduling+0x80>
    if(list[p]->state == RUNNABLE){
80103fd7:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
80103fda:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fde:	75 f0                	jne    80103fd0 <lotteryScheduling+0x60>
      curr_sum += list[p]->lottery_ticket;
80103fe0:	03 b8 0c 01 00 00    	add    0x10c(%eax),%edi
      if(curr_sum > random_ticket) {
80103fe6:	39 d7                	cmp    %edx,%edi
80103fe8:	7e e6                	jle    80103fd0 <lotteryScheduling+0x60>
}
80103fea:	5b                   	pop    %ebx
80103feb:	5e                   	pop    %esi
80103fec:	5f                   	pop    %edi
80103fed:	5d                   	pop    %ebp
80103fee:	c3                   	ret    
80103fef:	90                   	nop
80103ff0:	5b                   	pop    %ebx
      return 0;
80103ff1:	31 c0                	xor    %eax,%eax
}
80103ff3:	5e                   	pop    %esi
80103ff4:	5f                   	pop    %edi
80103ff5:	5d                   	pop    %ebp
80103ff6:	c3                   	ret    
80103ff7:	89 f6                	mov    %esi,%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <scheduler>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	81 ec 2c 03 00 00    	sub    $0x32c,%esp
  struct cpu *c = mycpu();
8010400c:	e8 9f f9 ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
80104011:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104018:	00 00 00 
  struct cpu *c = mycpu();
8010401b:	89 85 d0 fc ff ff    	mov    %eax,-0x330(%ebp)
80104021:	83 c0 04             	add    $0x4,%eax
80104024:	89 85 cc fc ff ff    	mov    %eax,-0x334(%ebp)
8010402a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  asm volatile("sti");
80104030:	fb                   	sti    
    acquire(&ptable.lock);
80104031:	83 ec 0c             	sub    $0xc,%esp
    int index3 = 0;
80104034:	31 db                	xor    %ebx,%ebx
    int index1 = 0;
80104036:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
80104038:	68 c0 3d 11 80       	push   $0x80113dc0
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403d:	bf f4 3d 11 80       	mov    $0x80113df4,%edi
    acquire(&ptable.lock);
80104042:	e8 09 11 00 00       	call   80105150 <acquire>
80104047:	83 c4 10             	add    $0x10,%esp
    int run1 = 0, run2 =0, run3 = 0;
8010404a:	c7 85 dc fc ff ff 00 	movl   $0x0,-0x324(%ebp)
80104051:	00 00 00 
80104054:	c7 85 d4 fc ff ff 00 	movl   $0x0,-0x32c(%ebp)
8010405b:	00 00 00 
8010405e:	c7 85 d8 fc ff ff 00 	movl   $0x0,-0x328(%ebp)
80104065:	00 00 00 
    int index2 = 0;
80104068:	c7 85 e0 fc ff ff 00 	movl   $0x0,-0x320(%ebp)
8010406f:	00 00 00 
80104072:	eb 33                	jmp    801040a7 <scheduler+0xa7>
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      else if (p->level == 2){
80104078:	83 f8 02             	cmp    $0x2,%eax
8010407b:	0f 84 87 01 00 00    	je     80104208 <scheduler+0x208>
          run3 ++;
80104081:	31 c0                	xor    %eax,%eax
        level3[index3] = p;
80104083:	89 bc 9d e8 fe ff ff 	mov    %edi,-0x118(%ebp,%ebx,4)
        index3 ++;
8010408a:	83 c3 01             	add    $0x1,%ebx
          run3 ++;
8010408d:	83 f9 03             	cmp    $0x3,%ecx
80104090:	0f 94 c0             	sete   %al
80104093:	01 85 dc fc ff ff    	add    %eax,-0x324(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104099:	81 c7 20 01 00 00    	add    $0x120,%edi
8010409f:	81 ff f4 85 11 80    	cmp    $0x801185f4,%edi
801040a5:	73 47                	jae    801040ee <scheduler+0xee>
      if (strlen(p->name) == 0)
801040a7:	8d 47 6c             	lea    0x6c(%edi),%eax
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	50                   	push   %eax
801040ae:	e8 cd 13 00 00       	call   80105480 <strlen>
801040b3:	83 c4 10             	add    $0x10,%esp
801040b6:	85 c0                	test   %eax,%eax
801040b8:	74 df                	je     80104099 <scheduler+0x99>
      if (p->level == 1){
801040ba:	8b 87 f4 00 00 00    	mov    0xf4(%edi),%eax
801040c0:	8b 4f 0c             	mov    0xc(%edi),%ecx
801040c3:	83 f8 01             	cmp    $0x1,%eax
801040c6:	75 b0                	jne    80104078 <scheduler+0x78>
        level1 [index1] = p;
801040c8:	89 bc b5 e8 fc ff ff 	mov    %edi,-0x318(%ebp,%esi,4)
          run1 ++;
801040cf:	31 c0                	xor    %eax,%eax
        index1 ++;
801040d1:	83 c6 01             	add    $0x1,%esi
          run1 ++;
801040d4:	83 f9 03             	cmp    $0x3,%ecx
801040d7:	0f 94 c0             	sete   %al
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040da:	81 c7 20 01 00 00    	add    $0x120,%edi
          run1 ++;
801040e0:	01 85 d8 fc ff ff    	add    %eax,-0x328(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e6:	81 ff f4 85 11 80    	cmp    $0x801185f4,%edi
801040ec:	72 b9                	jb     801040a7 <scheduler+0xa7>
    if(index1 && run1){
801040ee:	85 f6                	test   %esi,%esi
801040f0:	0f 84 42 01 00 00    	je     80104238 <scheduler+0x238>
801040f6:	8b 8d d8 fc ff ff    	mov    -0x328(%ebp),%ecx
801040fc:	85 c9                	test   %ecx,%ecx
801040fe:	0f 84 34 01 00 00    	je     80104238 <scheduler+0x238>
      p =  RR(level1, index1);
80104104:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
8010410a:	83 ec 08             	sub    $0x8,%esp
8010410d:	56                   	push   %esi
8010410e:	50                   	push   %eax
8010410f:	e8 9c fd ff ff       	call   80103eb0 <RR>
80104114:	83 c4 10             	add    $0x10,%esp
80104117:	89 c7                	mov    %eax,%edi
      p->visit = 1;
80104119:	c7 80 10 01 00 00 01 	movl   $0x1,0x110(%eax)
80104120:	00 00 00 
      c->proc = p;
80104123:	8b 85 d0 fc ff ff    	mov    -0x330(%ebp),%eax
      p->cycle++;
80104129:	83 87 18 01 00 00 01 	addl   $0x1,0x118(%edi)
      switchuvm(p);
80104130:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104133:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
      switchuvm(p);
80104139:	57                   	push   %edi
8010413a:	e8 01 39 00 00       	call   80107a40 <switchuvm>
      if (p -> level == 3)
8010413f:	83 c4 10             	add    $0x10,%esp
80104142:	83 bf f4 00 00 00 03 	cmpl   $0x3,0xf4(%edi)
      p->state = RUNNING;
80104149:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      if (p -> level == 3)
80104150:	75 12                	jne    80104164 <scheduler+0x164>
        p -> exect += 0.1;
80104152:	dd 05 e8 89 10 80    	fldl   0x801089e8
80104158:	d8 87 04 01 00 00    	fadds  0x104(%edi)
8010415e:	d9 9f 04 01 00 00    	fstps  0x104(%edi)
      swtch(&(c->scheduler), p->context);
80104164:	83 ec 08             	sub    $0x8,%esp
80104167:	ff 77 1c             	pushl  0x1c(%edi)
8010416a:	ff b5 cc fc ff ff    	pushl  -0x334(%ebp)
      for(prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++){
80104170:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
      swtch(&(c->scheduler), p->context);
80104175:	e8 21 13 00 00       	call   8010549b <swtch>
      switchkvm();
8010417a:	e8 a1 38 00 00       	call   80107a20 <switchkvm>
      c->proc = 0;
8010417f:	8b 85 d0 fc ff ff    	mov    -0x330(%ebp),%eax
80104185:	83 c4 10             	add    $0x10,%esp
80104188:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010418f:	00 00 00 
80104192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (strlen(prc->name) == 0)
80104198:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010419b:	83 ec 0c             	sub    $0xc,%esp
8010419e:	50                   	push   %eax
8010419f:	e8 dc 12 00 00       	call   80105480 <strlen>
801041a4:	83 c4 10             	add    $0x10,%esp
801041a7:	85 c0                	test   %eax,%eax
801041a9:	74 2a                	je     801041d5 <scheduler+0x1d5>
        prc->waiting_time++;
801041ab:	8b 83 14 01 00 00    	mov    0x114(%ebx),%eax
801041b1:	83 c0 01             	add    $0x1,%eax
        if(prc->waiting_time >= 3000){
801041b4:	3d b7 0b 00 00       	cmp    $0xbb7,%eax
        prc->waiting_time++;
801041b9:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
        if(prc->waiting_time >= 3000){
801041bf:	7e 14                	jle    801041d5 <scheduler+0x1d5>
          prc->level = 1;
801041c1:	c7 83 f4 00 00 00 01 	movl   $0x1,0xf4(%ebx)
801041c8:	00 00 00 
          prc->waiting_time = 0;
801041cb:	c7 83 14 01 00 00 00 	movl   $0x0,0x114(%ebx)
801041d2:	00 00 00 
      for(prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++){
801041d5:	81 c3 20 01 00 00    	add    $0x120,%ebx
801041db:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801041e1:	72 b5                	jb     80104198 <scheduler+0x198>
      p->waiting_time = 0;
801041e3:	c7 87 14 01 00 00 00 	movl   $0x0,0x114(%edi)
801041ea:	00 00 00 
  release(&ptable.lock);
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 c0 3d 11 80       	push   $0x80113dc0
801041f5:	e8 16 10 00 00       	call   80105210 <release>
  for(;;){
801041fa:	83 c4 10             	add    $0x10,%esp
801041fd:	e9 2e fe ff ff       	jmp    80104030 <scheduler+0x30>
80104202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        level2[index2] = p;
80104208:	8b 85 e0 fc ff ff    	mov    -0x320(%ebp),%eax
8010420e:	89 bc 85 e8 fd ff ff 	mov    %edi,-0x218(%ebp,%eax,4)
        index2 ++;
80104215:	83 c0 01             	add    $0x1,%eax
80104218:	89 85 e0 fc ff ff    	mov    %eax,-0x320(%ebp)
          run2 ++;
8010421e:	31 c0                	xor    %eax,%eax
80104220:	83 f9 03             	cmp    $0x3,%ecx
80104223:	0f 94 c0             	sete   %al
80104226:	01 85 d4 fc ff ff    	add    %eax,-0x32c(%ebp)
8010422c:	e9 68 fe ff ff       	jmp    80104099 <scheduler+0x99>
80104231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if (index2 && run2)
80104238:	8b 85 e0 fc ff ff    	mov    -0x320(%ebp),%eax
8010423e:	85 c0                	test   %eax,%eax
80104240:	74 24                	je     80104266 <scheduler+0x266>
80104242:	8b 95 d4 fc ff ff    	mov    -0x32c(%ebp),%edx
80104248:	85 d2                	test   %edx,%edx
8010424a:	74 1a                	je     80104266 <scheduler+0x266>
      p = lotteryScheduling(level2, index2);
8010424c:	83 ec 08             	sub    $0x8,%esp
8010424f:	50                   	push   %eax
80104250:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80104256:	50                   	push   %eax
80104257:	e8 14 fd ff ff       	call   80103f70 <lotteryScheduling>
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	89 c7                	mov    %eax,%edi
80104261:	e9 bd fe ff ff       	jmp    80104123 <scheduler+0x123>
    else if (index3  && run3)
80104266:	85 db                	test   %ebx,%ebx
80104268:	74 24                	je     8010428e <scheduler+0x28e>
8010426a:	8b 85 dc fc ff ff    	mov    -0x324(%ebp),%eax
80104270:	85 c0                	test   %eax,%eax
80104272:	74 1a                	je     8010428e <scheduler+0x28e>
      p = BJF(level3, index3);
80104274:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
8010427a:	83 ec 08             	sub    $0x8,%esp
8010427d:	53                   	push   %ebx
8010427e:	50                   	push   %eax
8010427f:	e8 fc fa ff ff       	call   80103d80 <BJF>
80104284:	83 c4 10             	add    $0x10,%esp
80104287:	89 c7                	mov    %eax,%edi
80104289:	e9 95 fe ff ff       	jmp    80104123 <scheduler+0x123>
    if (run1 || run2 || run3){
8010428e:	8b 85 d4 fc ff ff    	mov    -0x32c(%ebp),%eax
80104294:	0b 85 dc fc ff ff    	or     -0x324(%ebp),%eax
8010429a:	8b b5 d8 fc ff ff    	mov    -0x328(%ebp),%esi
801042a0:	09 c6                	or     %eax,%esi
801042a2:	0f 84 45 ff ff ff    	je     801041ed <scheduler+0x1ed>
801042a8:	e9 76 fe ff ff       	jmp    80104123 <scheduler+0x123>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

801042b0 <sched>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
  pushcli();
801042b5:	e8 c6 0d 00 00       	call   80105080 <pushcli>
  c = mycpu();
801042ba:	e8 f1 f6 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801042bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c5:	e8 f6 0d 00 00       	call   801050c0 <popcli>
  if(!holding(&ptable.lock))
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 c0 3d 11 80       	push   $0x80113dc0
801042d2:	e8 49 0e 00 00       	call   80105120 <holding>
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	85 c0                	test   %eax,%eax
801042dc:	74 4f                	je     8010432d <sched+0x7d>
  if(mycpu()->ncli != 1)
801042de:	e8 cd f6 ff ff       	call   801039b0 <mycpu>
801042e3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042ea:	75 68                	jne    80104354 <sched+0xa4>
  if(p->state == RUNNING)
801042ec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042f0:	74 55                	je     80104347 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042f2:	9c                   	pushf  
801042f3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042f4:	f6 c4 02             	test   $0x2,%ah
801042f7:	75 41                	jne    8010433a <sched+0x8a>
  intena = mycpu()->intena;
801042f9:	e8 b2 f6 ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042fe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104301:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104307:	e8 a4 f6 ff ff       	call   801039b0 <mycpu>
8010430c:	83 ec 08             	sub    $0x8,%esp
8010430f:	ff 70 04             	pushl  0x4(%eax)
80104312:	53                   	push   %ebx
80104313:	e8 83 11 00 00       	call   8010549b <swtch>
  mycpu()->intena = intena;
80104318:	e8 93 f6 ff ff       	call   801039b0 <mycpu>
}
8010431d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104320:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104326:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104329:	5b                   	pop    %ebx
8010432a:	5e                   	pop    %esi
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
    panic("sched ptable.lock");
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	68 b0 86 10 80       	push   $0x801086b0
80104335:	e8 56 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010433a:	83 ec 0c             	sub    $0xc,%esp
8010433d:	68 dc 86 10 80       	push   $0x801086dc
80104342:	e8 49 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
80104347:	83 ec 0c             	sub    $0xc,%esp
8010434a:	68 ce 86 10 80       	push   $0x801086ce
8010434f:	e8 3c c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	68 c2 86 10 80       	push   $0x801086c2
8010435c:	e8 2f c0 ff ff       	call   80100390 <panic>
80104361:	eb 0d                	jmp    80104370 <exit>
80104363:	90                   	nop
80104364:	90                   	nop
80104365:	90                   	nop
80104366:	90                   	nop
80104367:	90                   	nop
80104368:	90                   	nop
80104369:	90                   	nop
8010436a:	90                   	nop
8010436b:	90                   	nop
8010436c:	90                   	nop
8010436d:	90                   	nop
8010436e:	90                   	nop
8010436f:	90                   	nop

80104370 <exit>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	56                   	push   %esi
80104375:	53                   	push   %ebx
80104376:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104379:	e8 02 0d 00 00       	call   80105080 <pushcli>
  c = mycpu();
8010437e:	e8 2d f6 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104383:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104389:	e8 32 0d 00 00       	call   801050c0 <popcli>
  if(curproc == initproc)
8010438e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104394:	8d 5e 28             	lea    0x28(%esi),%ebx
80104397:	8d 7e 68             	lea    0x68(%esi),%edi
8010439a:	0f 84 f1 00 00 00    	je     80104491 <exit+0x121>
    if(curproc->ofile[fd]){
801043a0:	8b 03                	mov    (%ebx),%eax
801043a2:	85 c0                	test   %eax,%eax
801043a4:	74 12                	je     801043b8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	50                   	push   %eax
801043aa:	e8 81 cc ff ff       	call   80101030 <fileclose>
      curproc->ofile[fd] = 0;
801043af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801043b5:	83 c4 10             	add    $0x10,%esp
801043b8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801043bb:	39 fb                	cmp    %edi,%ebx
801043bd:	75 e1                	jne    801043a0 <exit+0x30>
  begin_op();
801043bf:	e8 cc e9 ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	ff 76 68             	pushl  0x68(%esi)
801043ca:	e8 d1 d5 ff ff       	call   801019a0 <iput>
  end_op();
801043cf:	e8 2c ea ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
801043d4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801043db:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801043e2:	e8 69 0d 00 00       	call   80105150 <acquire>
  wakeup1(curproc->parent);
801043e7:	8b 56 14             	mov    0x14(%esi),%edx
801043ea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ed:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801043f2:	eb 10                	jmp    80104404 <exit+0x94>
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f8:	05 20 01 00 00       	add    $0x120,%eax
801043fd:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104402:	73 1e                	jae    80104422 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104404:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104408:	75 ee                	jne    801043f8 <exit+0x88>
8010440a:	3b 50 20             	cmp    0x20(%eax),%edx
8010440d:	75 e9                	jne    801043f8 <exit+0x88>
      p->state = RUNNABLE;
8010440f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104416:	05 20 01 00 00       	add    $0x120,%eax
8010441b:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104420:	72 e2                	jb     80104404 <exit+0x94>
      p->parent = initproc;
80104422:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104428:	ba f4 3d 11 80       	mov    $0x80113df4,%edx
8010442d:	eb 0f                	jmp    8010443e <exit+0xce>
8010442f:	90                   	nop
80104430:	81 c2 20 01 00 00    	add    $0x120,%edx
80104436:	81 fa f4 85 11 80    	cmp    $0x801185f4,%edx
8010443c:	73 3a                	jae    80104478 <exit+0x108>
    if(p->parent == curproc){
8010443e:	39 72 14             	cmp    %esi,0x14(%edx)
80104441:	75 ed                	jne    80104430 <exit+0xc0>
      if(p->state == ZOMBIE)
80104443:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104447:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010444a:	75 e4                	jne    80104430 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444c:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104451:	eb 11                	jmp    80104464 <exit+0xf4>
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104458:	05 20 01 00 00       	add    $0x120,%eax
8010445d:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104462:	73 cc                	jae    80104430 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104464:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104468:	75 ee                	jne    80104458 <exit+0xe8>
8010446a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010446d:	75 e9                	jne    80104458 <exit+0xe8>
      p->state = RUNNABLE;
8010446f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104476:	eb e0                	jmp    80104458 <exit+0xe8>
  curproc->state = ZOMBIE;
80104478:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010447f:	e8 2c fe ff ff       	call   801042b0 <sched>
  panic("zombie exit");
80104484:	83 ec 0c             	sub    $0xc,%esp
80104487:	68 fd 86 10 80       	push   $0x801086fd
8010448c:	e8 ff be ff ff       	call   80100390 <panic>
    panic("init exiting");
80104491:	83 ec 0c             	sub    $0xc,%esp
80104494:	68 f0 86 10 80       	push   $0x801086f0
80104499:	e8 f2 be ff ff       	call   80100390 <panic>
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <yield>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044a7:	68 c0 3d 11 80       	push   $0x80113dc0
801044ac:	e8 9f 0c 00 00       	call   80105150 <acquire>
  pushcli();
801044b1:	e8 ca 0b 00 00       	call   80105080 <pushcli>
  c = mycpu();
801044b6:	e8 f5 f4 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801044bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044c1:	e8 fa 0b 00 00       	call   801050c0 <popcli>
  myproc()->state = RUNNABLE;
801044c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044cd:	e8 de fd ff ff       	call   801042b0 <sched>
  release(&ptable.lock);
801044d2:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801044d9:	e8 32 0d 00 00       	call   80105210 <release>
}
801044de:	83 c4 10             	add    $0x10,%esp
801044e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e4:	c9                   	leave  
801044e5:	c3                   	ret    
801044e6:	8d 76 00             	lea    0x0(%esi),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <sleep>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	83 ec 0c             	sub    $0xc,%esp
801044f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044ff:	e8 7c 0b 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104504:	e8 a7 f4 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104509:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010450f:	e8 ac 0b 00 00       	call   801050c0 <popcli>
  if(p == 0)
80104514:	85 db                	test   %ebx,%ebx
80104516:	0f 84 87 00 00 00    	je     801045a3 <sleep+0xb3>
  if(lk == 0)
8010451c:	85 f6                	test   %esi,%esi
8010451e:	74 76                	je     80104596 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104520:	81 fe c0 3d 11 80    	cmp    $0x80113dc0,%esi
80104526:	74 50                	je     80104578 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 c0 3d 11 80       	push   $0x80113dc0
80104530:	e8 1b 0c 00 00       	call   80105150 <acquire>
    release(lk);
80104535:	89 34 24             	mov    %esi,(%esp)
80104538:	e8 d3 0c 00 00       	call   80105210 <release>
  p->chan = chan;
8010453d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104540:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104547:	e8 64 fd ff ff       	call   801042b0 <sched>
  p->chan = 0;
8010454c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104553:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010455a:	e8 b1 0c 00 00       	call   80105210 <release>
    acquire(lk);
8010455f:	89 75 08             	mov    %esi,0x8(%ebp)
80104562:	83 c4 10             	add    $0x10,%esp
}
80104565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5f                   	pop    %edi
8010456b:	5d                   	pop    %ebp
    acquire(lk);
8010456c:	e9 df 0b 00 00       	jmp    80105150 <acquire>
80104571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104578:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010457b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104582:	e8 29 fd ff ff       	call   801042b0 <sched>
  p->chan = 0;
80104587:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010458e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104591:	5b                   	pop    %ebx
80104592:	5e                   	pop    %esi
80104593:	5f                   	pop    %edi
80104594:	5d                   	pop    %ebp
80104595:	c3                   	ret    
    panic("sleep without lk");
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	68 0f 87 10 80       	push   $0x8010870f
8010459e:	e8 ed bd ff ff       	call   80100390 <panic>
    panic("sleep");
801045a3:	83 ec 0c             	sub    $0xc,%esp
801045a6:	68 09 87 10 80       	push   $0x80108709
801045ab:	e8 e0 bd ff ff       	call   80100390 <panic>

801045b0 <wait>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
  pushcli();
801045b5:	e8 c6 0a 00 00       	call   80105080 <pushcli>
  c = mycpu();
801045ba:	e8 f1 f3 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801045bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045c5:	e8 f6 0a 00 00       	call   801050c0 <popcli>
  acquire(&ptable.lock);
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	68 c0 3d 11 80       	push   $0x80113dc0
801045d2:	e8 79 0b 00 00       	call   80105150 <acquire>
801045d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801045da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045dc:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
801045e1:	eb 13                	jmp    801045f6 <wait+0x46>
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e8:	81 c3 20 01 00 00    	add    $0x120,%ebx
801045ee:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801045f4:	73 1e                	jae    80104614 <wait+0x64>
      if(p->parent != curproc)
801045f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801045f9:	75 ed                	jne    801045e8 <wait+0x38>
      if(p->state == ZOMBIE){
801045fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045ff:	74 37                	je     80104638 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104601:	81 c3 20 01 00 00    	add    $0x120,%ebx
      havekids = 1;
80104607:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010460c:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104612:	72 e2                	jb     801045f6 <wait+0x46>
    if(!havekids || curproc->killed){
80104614:	85 c0                	test   %eax,%eax
80104616:	74 76                	je     8010468e <wait+0xde>
80104618:	8b 46 24             	mov    0x24(%esi),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	75 6f                	jne    8010468e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010461f:	83 ec 08             	sub    $0x8,%esp
80104622:	68 c0 3d 11 80       	push   $0x80113dc0
80104627:	56                   	push   %esi
80104628:	e8 c3 fe ff ff       	call   801044f0 <sleep>
    havekids = 0;
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	eb a8                	jmp    801045da <wait+0x2a>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010463e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104641:	e8 ba de ff ff       	call   80102500 <kfree>
        freevm(p->pgdir);
80104646:	5a                   	pop    %edx
80104647:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010464a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104651:	e8 9a 37 00 00       	call   80107df0 <freevm>
        release(&ptable.lock);
80104656:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
        p->pid = 0;
8010465d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104664:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010466b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010466f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104676:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010467d:	e8 8e 0b 00 00       	call   80105210 <release>
        return pid;
80104682:	83 c4 10             	add    $0x10,%esp
}
80104685:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104688:	89 f0                	mov    %esi,%eax
8010468a:	5b                   	pop    %ebx
8010468b:	5e                   	pop    %esi
8010468c:	5d                   	pop    %ebp
8010468d:	c3                   	ret    
      release(&ptable.lock);
8010468e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104691:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104696:	68 c0 3d 11 80       	push   $0x80113dc0
8010469b:	e8 70 0b 00 00       	call   80105210 <release>
      return -1;
801046a0:	83 c4 10             	add    $0x10,%esp
801046a3:	eb e0                	jmp    80104685 <wait+0xd5>
801046a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046ba:	68 c0 3d 11 80       	push   $0x80113dc0
801046bf:	e8 8c 0a 00 00       	call   80105150 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c7:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801046cc:	eb 0e                	jmp    801046dc <wakeup+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 20 01 00 00       	add    $0x120,%eax
801046d5:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
801046da:	73 1e                	jae    801046fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801046dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046e0:	75 ee                	jne    801046d0 <wakeup+0x20>
801046e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801046e5:	75 e9                	jne    801046d0 <wakeup+0x20>
      p->state = RUNNABLE;
801046e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ee:	05 20 01 00 00       	add    $0x120,%eax
801046f3:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
801046f8:	72 e2                	jb     801046dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801046fa:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
80104701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104704:	c9                   	leave  
  release(&ptable.lock);
80104705:	e9 06 0b 00 00       	jmp    80105210 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010471a:	68 c0 3d 11 80       	push   $0x80113dc0
8010471f:	e8 2c 0a 00 00       	call   80105150 <acquire>
80104724:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104727:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
8010472c:	eb 0e                	jmp    8010473c <kill+0x2c>
8010472e:	66 90                	xchg   %ax,%ax
80104730:	05 20 01 00 00       	add    $0x120,%eax
80104735:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
8010473a:	73 34                	jae    80104770 <kill+0x60>
    if(p->pid == pid){
8010473c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010473f:	75 ef                	jne    80104730 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104741:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104745:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010474c:	75 07                	jne    80104755 <kill+0x45>
        p->state = RUNNABLE;
8010474e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104755:	83 ec 0c             	sub    $0xc,%esp
80104758:	68 c0 3d 11 80       	push   $0x80113dc0
8010475d:	e8 ae 0a 00 00       	call   80105210 <release>
      return 0;
80104762:	83 c4 10             	add    $0x10,%esp
80104765:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010476a:	c9                   	leave  
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104770:	83 ec 0c             	sub    $0xc,%esp
80104773:	68 c0 3d 11 80       	push   $0x80113dc0
80104778:	e8 93 0a 00 00       	call   80105210 <release>
  return -1;
8010477d:	83 c4 10             	add    $0x10,%esp
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104788:	c9                   	leave  
80104789:	c3                   	ret    
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	53                   	push   %ebx
80104796:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104799:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
8010479e:	83 ec 3c             	sub    $0x3c,%esp
801047a1:	eb 27                	jmp    801047ca <procdump+0x3a>
801047a3:	90                   	nop
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 e8 87 10 80       	push   $0x801087e8
801047b0:	e8 ab be ff ff       	call   80100660 <cprintf>
801047b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b8:	81 c3 20 01 00 00    	add    $0x120,%ebx
801047be:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801047c4:	0f 83 86 00 00 00    	jae    80104850 <procdump+0xc0>
    if(p->state == UNUSED)
801047ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801047cd:	85 c0                	test   %eax,%eax
801047cf:	74 e7                	je     801047b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047d1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801047d4:	ba 20 87 10 80       	mov    $0x80108720,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047d9:	77 11                	ja     801047ec <procdump+0x5c>
801047db:	8b 14 85 c4 89 10 80 	mov    -0x7fef763c(,%eax,4),%edx
      state = "???";
801047e2:	b8 20 87 10 80       	mov    $0x80108720,%eax
801047e7:	85 d2                	test   %edx,%edx
801047e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047ef:	50                   	push   %eax
801047f0:	52                   	push   %edx
801047f1:	ff 73 10             	pushl  0x10(%ebx)
801047f4:	68 24 87 10 80       	push   $0x80108724
801047f9:	e8 62 be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801047fe:	83 c4 10             	add    $0x10,%esp
80104801:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104805:	75 a1                	jne    801047a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104807:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010480a:	83 ec 08             	sub    $0x8,%esp
8010480d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104810:	50                   	push   %eax
80104811:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104814:	8b 40 0c             	mov    0xc(%eax),%eax
80104817:	83 c0 08             	add    $0x8,%eax
8010481a:	50                   	push   %eax
8010481b:	e8 10 08 00 00       	call   80105030 <getcallerpcs>
80104820:	83 c4 10             	add    $0x10,%esp
80104823:	90                   	nop
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104828:	8b 17                	mov    (%edi),%edx
8010482a:	85 d2                	test   %edx,%edx
8010482c:	0f 84 76 ff ff ff    	je     801047a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104832:	83 ec 08             	sub    $0x8,%esp
80104835:	83 c7 04             	add    $0x4,%edi
80104838:	52                   	push   %edx
80104839:	68 61 81 10 80       	push   $0x80108161
8010483e:	e8 1d be ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104843:	83 c4 10             	add    $0x10,%esp
80104846:	39 fe                	cmp    %edi,%esi
80104848:	75 de                	jne    80104828 <procdump+0x98>
8010484a:	e9 59 ff ff ff       	jmp    801047a8 <procdump+0x18>
8010484f:	90                   	nop
  }
}
80104850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104853:	5b                   	pop    %ebx
80104854:	5e                   	pop    %esi
80104855:	5f                   	pop    %edi
80104856:	5d                   	pop    %ebp
80104857:	c3                   	ret    
80104858:	90                   	nop
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104860 <print_name>:

void print_name(int num)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	8b 45 08             	mov    0x8(%ebp),%eax
  switch(num)
80104866:	83 f8 18             	cmp    $0x18,%eax
80104869:	0f 87 91 01 00 00    	ja     80104a00 <print_name+0x1a0>
8010486f:	ff 24 85 48 89 10 80 	jmp    *-0x7fef76b8(,%eax,4)
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      break;
    case 23:
      cprintf("Reverse_number");
      break;
    case 24:
      cprintf("Get_children");
80104880:	c7 45 08 c0 87 10 80 	movl   $0x801087c0,0x8(%ebp)
      break;
  }

}
80104887:	5d                   	pop    %ebp
      cprintf("Get_children");
80104888:	e9 d3 bd ff ff       	jmp    80100660 <cprintf>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Reverse_number");
80104890:	c7 45 08 b1 87 10 80 	movl   $0x801087b1,0x8(%ebp)
}
80104897:	5d                   	pop    %ebp
      cprintf("Reverse_number");
80104898:	e9 c3 bd ff ff       	jmp    80100660 <cprintf>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Trace_syscalls");
801048a0:	c7 45 08 a2 87 10 80 	movl   $0x801087a2,0x8(%ebp)
}
801048a7:	5d                   	pop    %ebp
      cprintf("Trace_syscalls");
801048a8:	e9 b3 bd ff ff       	jmp    80100660 <cprintf>
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Close");
801048b0:	c7 45 08 9c 87 10 80 	movl   $0x8010879c,0x8(%ebp)
}
801048b7:	5d                   	pop    %ebp
      cprintf("Close");
801048b8:	e9 a3 bd ff ff       	jmp    80100660 <cprintf>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mkdir");
801048c0:	c7 45 08 96 87 10 80 	movl   $0x80108796,0x8(%ebp)
}
801048c7:	5d                   	pop    %ebp
      cprintf("Mkdir");
801048c8:	e9 93 bd ff ff       	jmp    80100660 <cprintf>
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Link");
801048d0:	c7 45 08 91 87 10 80 	movl   $0x80108791,0x8(%ebp)
}
801048d7:	5d                   	pop    %ebp
      cprintf("Link");
801048d8:	e9 83 bd ff ff       	jmp    80100660 <cprintf>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Unlink");
801048e0:	c7 45 08 8a 87 10 80 	movl   $0x8010878a,0x8(%ebp)
}
801048e7:	5d                   	pop    %ebp
      cprintf("Unlink");
801048e8:	e9 73 bd ff ff       	jmp    80100660 <cprintf>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mknod");
801048f0:	c7 45 08 84 87 10 80 	movl   $0x80108784,0x8(%ebp)
}
801048f7:	5d                   	pop    %ebp
      cprintf("Mknod");
801048f8:	e9 63 bd ff ff       	jmp    80100660 <cprintf>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Write");
80104900:	c7 45 08 7e 87 10 80 	movl   $0x8010877e,0x8(%ebp)
}
80104907:	5d                   	pop    %ebp
      cprintf("Write");
80104908:	e9 53 bd ff ff       	jmp    80100660 <cprintf>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Open");
80104910:	c7 45 08 79 87 10 80 	movl   $0x80108779,0x8(%ebp)
}
80104917:	5d                   	pop    %ebp
      cprintf("Open");
80104918:	e9 43 bd ff ff       	jmp    80100660 <cprintf>
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Uptime");
80104920:	c7 45 08 72 87 10 80 	movl   $0x80108772,0x8(%ebp)
}
80104927:	5d                   	pop    %ebp
      cprintf("Uptime");
80104928:	e9 33 bd ff ff       	jmp    80100660 <cprintf>
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sleep");
80104930:	c7 45 08 6c 87 10 80 	movl   $0x8010876c,0x8(%ebp)
}
80104937:	5d                   	pop    %ebp
      cprintf("Sleep");
80104938:	e9 23 bd ff ff       	jmp    80100660 <cprintf>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sbrk");
80104940:	c7 45 08 67 87 10 80 	movl   $0x80108767,0x8(%ebp)
}
80104947:	5d                   	pop    %ebp
      cprintf("Sbrk");
80104948:	e9 13 bd ff ff       	jmp    80100660 <cprintf>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Getpid");
80104950:	c7 45 08 60 87 10 80 	movl   $0x80108760,0x8(%ebp)
}
80104957:	5d                   	pop    %ebp
      cprintf("Getpid");
80104958:	e9 03 bd ff ff       	jmp    80100660 <cprintf>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Dup");
80104960:	c7 45 08 5c 87 10 80 	movl   $0x8010875c,0x8(%ebp)
}
80104967:	5d                   	pop    %ebp
      cprintf("Dup");
80104968:	e9 f3 bc ff ff       	jmp    80100660 <cprintf>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Chdir");
80104970:	c7 45 08 56 87 10 80 	movl   $0x80108756,0x8(%ebp)
}
80104977:	5d                   	pop    %ebp
      cprintf("Chdir");
80104978:	e9 e3 bc ff ff       	jmp    80100660 <cprintf>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fstat");
80104980:	c7 45 08 50 87 10 80 	movl   $0x80108750,0x8(%ebp)
}
80104987:	5d                   	pop    %ebp
      cprintf("Fstat");
80104988:	e9 d3 bc ff ff       	jmp    80100660 <cprintf>
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exec");
80104990:	c7 45 08 4b 87 10 80 	movl   $0x8010874b,0x8(%ebp)
}
80104997:	5d                   	pop    %ebp
      cprintf("Exec");
80104998:	e9 c3 bc ff ff       	jmp    80100660 <cprintf>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Kill");
801049a0:	c7 45 08 46 87 10 80 	movl   $0x80108746,0x8(%ebp)
}
801049a7:	5d                   	pop    %ebp
      cprintf("Kill");
801049a8:	e9 b3 bc ff ff       	jmp    80100660 <cprintf>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Read");
801049b0:	c7 45 08 41 87 10 80 	movl   $0x80108741,0x8(%ebp)
}
801049b7:	5d                   	pop    %ebp
      cprintf("Read");
801049b8:	e9 a3 bc ff ff       	jmp    80100660 <cprintf>
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Pipe");
801049c0:	c7 45 08 3c 87 10 80 	movl   $0x8010873c,0x8(%ebp)
}
801049c7:	5d                   	pop    %ebp
      cprintf("Pipe");
801049c8:	e9 93 bc ff ff       	jmp    80100660 <cprintf>
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Wait");
801049d0:	c7 45 08 37 87 10 80 	movl   $0x80108737,0x8(%ebp)
}
801049d7:	5d                   	pop    %ebp
      cprintf("Wait");
801049d8:	e9 83 bc ff ff       	jmp    80100660 <cprintf>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exit");
801049e0:	c7 45 08 32 87 10 80 	movl   $0x80108732,0x8(%ebp)
}
801049e7:	5d                   	pop    %ebp
      cprintf("Exit");
801049e8:	e9 73 bc ff ff       	jmp    80100660 <cprintf>
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fork");
801049f0:	c7 45 08 2d 87 10 80 	movl   $0x8010872d,0x8(%ebp)
}
801049f7:	5d                   	pop    %ebp
      cprintf("Fork");
801049f8:	e9 63 bc ff ff       	jmp    80100660 <cprintf>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
}
80104a00:	5d                   	pop    %ebp
80104a01:	c3                   	ret    
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <allone>:
void allone(void){
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a14:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
void allone(void){
80104a19:	83 ec 04             	sub    $0x4,%esp
80104a1c:	eb 1a                	jmp    80104a38 <allone+0x28>
80104a1e:	66 90                	xchg   %ax,%ax
  {

    if(strlen(p->name) == 0)
      break;
    p->print_state = 1;
80104a20:	c7 83 f0 00 00 00 01 	movl   $0x1,0xf0(%ebx)
80104a27:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a2a:	81 c3 20 01 00 00    	add    $0x120,%ebx
80104a30:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104a36:	73 13                	jae    80104a4b <allone+0x3b>
    if(strlen(p->name) == 0)
80104a38:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a3b:	83 ec 0c             	sub    $0xc,%esp
80104a3e:	50                   	push   %eax
80104a3f:	e8 3c 0a 00 00       	call   80105480 <strlen>
80104a44:	83 c4 10             	add    $0x10,%esp
80104a47:	85 c0                	test   %eax,%eax
80104a49:	75 d5                	jne    80104a20 <allone+0x10>
    
  }
  

}
80104a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a4e:	c9                   	leave  
80104a4f:	c3                   	ret    

80104a50 <all_zero>:
void all_zero(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
  struct proc *p;
  int i;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a54:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
80104a59:	83 ec 04             	sub    $0x4,%esp
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(strlen(p->name) == 0)
80104a60:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a63:	83 ec 0c             	sub    $0xc,%esp
80104a66:	50                   	push   %eax
80104a67:	e8 14 0a 00 00       	call   80105480 <strlen>
80104a6c:	83 c4 10             	add    $0x10,%esp
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	74 38                	je     80104aab <all_zero+0x5b>
80104a73:	8d 43 7c             	lea    0x7c(%ebx),%eax
80104a76:	8d 93 f0 00 00 00    	lea    0xf0(%ebx),%edx
      break;
    p->print_state = 0;
80104a7c:	c7 83 f0 00 00 00 00 	movl   $0x0,0xf0(%ebx)
80104a83:	00 00 00 
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (i =0; i < SYSNUM; i++){
        
       p->call_nums[i] = 0;
80104a90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a96:	83 c0 04             	add    $0x4,%eax
    for (i =0; i < SYSNUM; i++){
80104a99:	39 d0                	cmp    %edx,%eax
80104a9b:	75 f3                	jne    80104a90 <all_zero+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a9d:	81 c3 20 01 00 00    	add    $0x120,%ebx
80104aa3:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104aa9:	72 b5                	jb     80104a60 <all_zero+0x10>
    }
  }

}
80104aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aae:	c9                   	leave  
80104aaf:	c3                   	ret    

80104ab0 <trace_syscalls>:

int trace_syscalls(int state)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  
  struct proc *p;
  int i;
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
80104ab8:	83 f8 01             	cmp    $0x1,%eax
80104abb:	74 2a                	je     80104ae7 <trace_syscalls+0x37>
80104abd:	83 f8 02             	cmp    $0x2,%eax
80104ac0:	74 16                	je     80104ad8 <trace_syscalls+0x28>

    }
    return 0;
  }

  if(state == 0)
80104ac2:	85 c0                	test   %eax,%eax
80104ac4:	0f 85 99 00 00 00    	jne    80104b63 <trace_syscalls+0xb3>
  {
    all_zero();
80104aca:	e8 81 ff ff ff       	call   80104a50 <all_zero>
    return 0;
80104acf:	31 c0                	xor    %eax,%eax
  }
  return -1;
 
}
80104ad1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ad4:	5b                   	pop    %ebx
80104ad5:	5e                   	pop    %esi
80104ad6:	5d                   	pop    %ebp
80104ad7:	c3                   	ret    
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
80104ad8:	8b 0d e4 3e 11 80    	mov    0x80113ee4,%ecx
  return -1;
80104ade:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
80104ae3:	85 c9                	test   %ecx,%ecx
80104ae5:	74 ea                	je     80104ad1 <trace_syscalls+0x21>
80104ae7:	be f4 3d 11 80       	mov    $0x80113df4,%esi
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af0:	8d 5e 6c             	lea    0x6c(%esi),%ebx
      if(strlen(p->name) == 0)
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	53                   	push   %ebx
80104af7:	e8 84 09 00 00       	call   80105480 <strlen>
80104afc:	83 c4 10             	add    $0x10,%esp
80104aff:	85 c0                	test   %eax,%eax
80104b01:	74 cc                	je     80104acf <trace_syscalls+0x1f>
      cprintf("%s:\n",p->name);
80104b03:	83 ec 08             	sub    $0x8,%esp
      p->print_state = 1;
80104b06:	c7 86 f0 00 00 00 01 	movl   $0x1,0xf0(%esi)
80104b0d:	00 00 00 
      cprintf("%s:\n",p->name);
80104b10:	53                   	push   %ebx
80104b11:	68 cd 87 10 80       	push   $0x801087cd
      for (i =0; i < SYSNUM; i++)
80104b16:	31 db                	xor    %ebx,%ebx
      cprintf("%s:\n",p->name);
80104b18:	e8 43 bb ff ff       	call   80100660 <cprintf>
80104b1d:	83 c4 10             	add    $0x10,%esp
        cprintf("   ");
80104b20:	83 ec 0c             	sub    $0xc,%esp
        print_name(i + 1);
80104b23:	83 c3 01             	add    $0x1,%ebx
        cprintf("   ");
80104b26:	68 38 88 10 80       	push   $0x80108838
80104b2b:	e8 30 bb ff ff       	call   80100660 <cprintf>
        print_name(i + 1);
80104b30:	89 1c 24             	mov    %ebx,(%esp)
80104b33:	e8 28 fd ff ff       	call   80104860 <print_name>
        cprintf(": %d\n", p->call_nums[i]);
80104b38:	58                   	pop    %eax
80104b39:	5a                   	pop    %edx
80104b3a:	ff 74 9e 78          	pushl  0x78(%esi,%ebx,4)
80104b3e:	68 d2 87 10 80       	push   $0x801087d2
80104b43:	e8 18 bb ff ff       	call   80100660 <cprintf>
      for (i =0; i < SYSNUM; i++)
80104b48:	83 c4 10             	add    $0x10,%esp
80104b4b:	83 fb 1d             	cmp    $0x1d,%ebx
80104b4e:	75 d0                	jne    80104b20 <trace_syscalls+0x70>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b50:	81 c6 20 01 00 00    	add    $0x120,%esi
80104b56:	81 fe f4 85 11 80    	cmp    $0x801185f4,%esi
80104b5c:	72 92                	jb     80104af0 <trace_syscalls+0x40>
80104b5e:	e9 6c ff ff ff       	jmp    80104acf <trace_syscalls+0x1f>
  return -1;
80104b63:	83 c8 ff             	or     $0xffffffff,%eax
80104b66:	e9 66 ff ff ff       	jmp    80104ad1 <trace_syscalls+0x21>
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <reverse_number>:

int reverse_number(int n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	81 ec 2c 03 00 00    	sub    $0x32c,%esp
80104b7c:	8b 75 08             	mov    0x8(%ebp),%esi

  int digit = 0;
  int temp = n;

  while (temp)
80104b7f:	85 f6                	test   %esi,%esi
80104b81:	74 7e                	je     80104c01 <reverse_number+0x91>
80104b83:	89 f3                	mov    %esi,%ebx
  int digit = 0;
80104b85:	31 ff                	xor    %edi,%edi
  {
    ++digit;
    temp /= 10;
80104b87:	b9 67 66 66 66       	mov    $0x66666667,%ecx
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b90:	89 d8                	mov    %ebx,%eax
80104b92:	c1 fb 1f             	sar    $0x1f,%ebx
    ++digit;
80104b95:	83 c7 01             	add    $0x1,%edi
    temp /= 10;
80104b98:	f7 e9                	imul   %ecx
80104b9a:	c1 fa 02             	sar    $0x2,%edx
  while (temp)
80104b9d:	29 da                	sub    %ebx,%edx
80104b9f:	89 d3                	mov    %edx,%ebx
80104ba1:	75 ed                	jne    80104b90 <reverse_number+0x20>
80104ba3:	89 fa                	mov    %edi,%edx
  }

  int array[200] = {0};
80104ba5:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
80104bab:	89 d8                	mov    %ebx,%eax
80104bad:	b9 c8 00 00 00       	mov    $0xc8,%ecx
80104bb2:	f3 ab                	rep stos %eax,%es:(%edi)
80104bb4:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
80104bba:	8d 0c 97             	lea    (%edi,%edx,4),%ecx
80104bbd:	89 fb                	mov    %edi,%ebx
80104bbf:	90                   	nop
  
  for (int i = 0; i < digit; i++) 
    {
      array[i] = n % 10;
80104bc0:	b8 67 66 66 66       	mov    $0x66666667,%eax
80104bc5:	83 c3 04             	add    $0x4,%ebx
80104bc8:	f7 ee                	imul   %esi
80104bca:	89 f0                	mov    %esi,%eax
80104bcc:	c1 f8 1f             	sar    $0x1f,%eax
80104bcf:	c1 fa 02             	sar    $0x2,%edx
80104bd2:	29 c2                	sub    %eax,%edx
80104bd4:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104bd7:	01 c0                	add    %eax,%eax
80104bd9:	29 c6                	sub    %eax,%esi
80104bdb:	89 73 fc             	mov    %esi,-0x4(%ebx)
  for (int i = 0; i < digit; i++) 
80104bde:	39 cb                	cmp    %ecx,%ebx
      n /= 10;
80104be0:	89 d6                	mov    %edx,%esi
  for (int i = 0; i < digit; i++) 
80104be2:	75 dc                	jne    80104bc0 <reverse_number+0x50>
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  
  for(int j = 0; j < digit; j++)
    cprintf("%d", array[j]);
80104be8:	83 ec 08             	sub    $0x8,%esp
80104beb:	ff 37                	pushl  (%edi)
80104bed:	83 c7 04             	add    $0x4,%edi
80104bf0:	68 d8 87 10 80       	push   $0x801087d8
80104bf5:	e8 66 ba ff ff       	call   80100660 <cprintf>
  for(int j = 0; j < digit; j++)
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	39 df                	cmp    %ebx,%edi
80104bff:	75 e7                	jne    80104be8 <reverse_number+0x78>
  cprintf("\n");
80104c01:	83 ec 0c             	sub    $0xc,%esp
80104c04:	68 e8 87 10 80       	push   $0x801087e8
80104c09:	e8 52 ba ff ff       	call   80100660 <cprintf>

  return 0;

}
80104c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c11:	31 c0                	xor    %eax,%eax
80104c13:	5b                   	pop    %ebx
80104c14:	5e                   	pop    %esi
80104c15:	5f                   	pop    %edi
80104c16:	5d                   	pop    %ebp
80104c17:	c3                   	ret    
80104c18:	90                   	nop
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c20 <children>:
int
children(int pid)
{
80104c20:	55                   	push   %ebp
  struct proc *p;
  
  int childs[NPROC] = {-1};
80104c21:	31 c0                	xor    %eax,%eax
80104c23:	b9 3f 00 00 00       	mov    $0x3f,%ecx
{
80104c28:	89 e5                	mov    %esp,%ebp
80104c2a:	57                   	push   %edi
80104c2b:	56                   	push   %esi
  int childs[NPROC] = {-1};
80104c2c:	8d bd ec fe ff ff    	lea    -0x114(%ebp),%edi
{
80104c32:	53                   	push   %ebx
  int curr_index = 0;
  int index = 0;
80104c33:	31 db                	xor    %ebx,%ebx
{
80104c35:	81 ec 28 01 00 00    	sub    $0x128,%esp
80104c3b:	8b 75 08             	mov    0x8(%ebp),%esi
  int childs[NPROC] = {-1};
80104c3e:	f3 ab                	rep stos %eax,%es:(%edi)
  //int parent_pid = pid ; 

  acquire(&ptable.lock);
80104c40:	68 c0 3d 11 80       	push   $0x80113dc0
  int childs[NPROC] = {-1};
80104c45:	c7 85 e8 fe ff ff ff 	movl   $0xffffffff,-0x118(%ebp)
80104c4c:	ff ff ff 
80104c4f:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
  acquire(&ptable.lock);
80104c55:	e8 f6 04 00 00       	call   80105150 <acquire>
80104c5a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	89 f9                	mov    %edi,%ecx
80104c62:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
80104c68:	90                   	nop
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(int i = 0 ; i < NPROC ; i++){

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c70:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104c75:	8d 76 00             	lea    0x0(%esi),%esi

      //cprintf("proc pid: %d  parent pid: %d \n",  p->pid, p->parent->pid);

        if(p->parent->pid == pid){
80104c78:	8b 50 14             	mov    0x14(%eax),%edx
80104c7b:	39 72 10             	cmp    %esi,0x10(%edx)
80104c7e:	75 0d                	jne    80104c8d <children+0x6d>
           childs[index] = p->pid ;
80104c80:	8b 50 10             	mov    0x10(%eax),%edx
80104c83:	89 94 9d e8 fe ff ff 	mov    %edx,-0x118(%ebp,%ebx,4)
           index++;
80104c8a:	83 c3 01             	add    $0x1,%ebx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c8d:	05 20 01 00 00       	add    $0x120,%eax
80104c92:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104c97:	72 df                	jb     80104c78 <children+0x58>
       //  cprintf(" parent pid ,%d", pid , " child pid: %d \n",  p->pid);
        }
    }
     if(childs[curr_index] == -1)
80104c99:	8b 31                	mov    (%ecx),%esi
80104c9b:	83 fe ff             	cmp    $0xffffffff,%esi
80104c9e:	74 0b                	je     80104cab <children+0x8b>
80104ca0:	83 c1 04             	add    $0x4,%ecx
  for(int i = 0 ; i < NPROC ; i++){
80104ca3:	3b 8d e4 fe ff ff    	cmp    -0x11c(%ebp),%ecx
80104ca9:	75 c5                	jne    80104c70 <children+0x50>
     else{
       pid = childs[curr_index];
       curr_index++;
      } 
  }
  release(&ptable.lock);
80104cab:	83 ec 0c             	sub    $0xc,%esp
80104cae:	68 c0 3d 11 80       	push   $0x80113dc0
80104cb3:	e8 58 05 00 00       	call   80105210 <release>
  
  int pid_list = 0;
  int cpy ; 

  for(int i = 0 ; i < index ;i++){
80104cb8:	83 c4 10             	add    $0x10,%esp
80104cbb:	85 db                	test   %ebx,%ebx
80104cbd:	74 3e                	je     80104cfd <children+0xdd>
80104cbf:	8d 04 9f             	lea    (%edi,%ebx,4),%eax

  cpy = childs[i];
  while(cpy > 0){
        pid_list *= 10;
        cpy /= 10 ;
80104cc2:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
  int pid_list = 0;
80104cc7:	31 db                	xor    %ebx,%ebx
80104cc9:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  cpy = childs[i];
80104ccf:	8b 37                	mov    (%edi),%esi
  while(cpy > 0){
80104cd1:	85 f6                	test   %esi,%esi
80104cd3:	7e 1b                	jle    80104cf0 <children+0xd0>
80104cd5:	89 f2                	mov    %esi,%edx
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cpy /= 10 ;
80104ce0:	89 d0                	mov    %edx,%eax
        pid_list *= 10;
80104ce2:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
        cpy /= 10 ;
80104ce5:	f7 e1                	mul    %ecx
        pid_list *= 10;
80104ce7:	01 db                	add    %ebx,%ebx
        cpy /= 10 ;
80104ce9:	c1 ea 03             	shr    $0x3,%edx
  while(cpy > 0){
80104cec:	85 d2                	test   %edx,%edx
80104cee:	75 f0                	jne    80104ce0 <children+0xc0>
     }
  pid_list += childs[i];
80104cf0:	01 f3                	add    %esi,%ebx
80104cf2:	83 c7 04             	add    $0x4,%edi
  for(int i = 0 ; i < index ;i++){
80104cf5:	3b bd e4 fe ff ff    	cmp    -0x11c(%ebp),%edi
80104cfb:	75 d2                	jne    80104ccf <children+0xaf>
}


  return pid_list;
}
80104cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d00:	89 d8                	mov    %ebx,%eax
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5f                   	pop    %edi
80104d05:	5d                   	pop    %ebp
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <change_process_queue>:

void change_process_queue(int pid, int dest_queue)
{
80104d10:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104d11:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104d16:	89 e5                	mov    %esp,%ebp
80104d18:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d1e:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104d20:	39 50 10             	cmp    %edx,0x10(%eax)
80104d23:	75 06                	jne    80104d2b <change_process_queue+0x1b>
    {
      p->level = dest_queue;
80104d25:	89 88 f4 00 00 00    	mov    %ecx,0xf4(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104d2b:	05 20 01 00 00       	add    $0x120,%eax
80104d30:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104d35:	72 e9                	jb     80104d20 <change_process_queue+0x10>
    }
  }
}
80104d37:	5d                   	pop    %ebp
80104d38:	c3                   	ret    
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d40 <quantify_lottery_tickets>:

void quantify_lottery_tickets(int pid, int ticket)
{
80104d40:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104d41:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104d46:	89 e5                	mov    %esp,%ebp
80104d48:	8b 55 08             	mov    0x8(%ebp),%edx
80104d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d4e:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104d50:	39 50 10             	cmp    %edx,0x10(%eax)
80104d53:	75 06                	jne    80104d5b <quantify_lottery_tickets+0x1b>
    {
      p->lottery_ticket = ticket;
80104d55:	89 88 0c 01 00 00    	mov    %ecx,0x10c(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104d5b:	05 20 01 00 00       	add    $0x120,%eax
80104d60:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104d65:	72 e9                	jb     80104d50 <quantify_lottery_tickets+0x10>
    }
  }
}
80104d67:	5d                   	pop    %ebp
80104d68:	c3                   	ret    
80104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d70 <quantify_BJF_parameters_process_level>:

void quantify_BJF_parameters_process_level(int pid, int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104d70:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104d71:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104d76:	89 e5                	mov    %esp,%ebp
80104d78:	8b 55 08             	mov    0x8(%ebp),%edx
80104d7b:	90                   	nop
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->pid == pid)
80104d80:	39 50 10             	cmp    %edx,0x10(%eax)
80104d83:	75 1b                	jne    80104da0 <quantify_BJF_parameters_process_level+0x30>
    {
      p->priority_ratio = priority_ratio;
80104d85:	db 45 0c             	fildl  0xc(%ebp)
80104d88:	d9 98 fc 00 00 00    	fstps  0xfc(%eax)
      p->arrivt_ratio = arrivt_ratio;
80104d8e:	db 45 10             	fildl  0x10(%ebp)
80104d91:	d9 98 00 01 00 00    	fstps  0x100(%eax)
      p->exect_ratio = exect_ratio;
80104d97:	db 45 14             	fildl  0x14(%ebp)
80104d9a:	d9 98 08 01 00 00    	fstps  0x108(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104da0:	05 20 01 00 00       	add    $0x120,%eax
80104da5:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104daa:	72 d4                	jb     80104d80 <quantify_BJF_parameters_process_level+0x10>
    }
  }
}
80104dac:	5d                   	pop    %ebp
80104dad:	c3                   	ret    
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <quantify_BJF_parameters_kernel_level>:

void quantify_BJF_parameters_kernel_level(int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104db0:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104db1:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104db6:	89 e5                	mov    %esp,%ebp
80104db8:	db 45 08             	fildl  0x8(%ebp)
80104dbb:	db 45 0c             	fildl  0xc(%ebp)
80104dbe:	db 45 10             	fildl  0x10(%ebp)
80104dc1:	d9 ca                	fxch   %st(2)
80104dc3:	eb 07                	jmp    80104dcc <quantify_BJF_parameters_kernel_level+0x1c>
80104dc5:	8d 76 00             	lea    0x0(%esi),%esi
80104dc8:	d9 ca                	fxch   %st(2)
80104dca:	d9 c9                	fxch   %st(1)
  {
    p->priority_ratio = priority_ratio;
80104dcc:	d9 90 fc 00 00 00    	fsts   0xfc(%eax)
80104dd2:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104dd4:	05 20 01 00 00       	add    $0x120,%eax
    p->arrivt_ratio = arrivt_ratio;
80104dd9:	d9 50 e0             	fsts   -0x20(%eax)
80104ddc:	d9 ca                	fxch   %st(2)
    p->exect_ratio = exect_ratio;
80104dde:	d9 50 e8             	fsts   -0x18(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104de1:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104de6:	72 e0                	jb     80104dc8 <quantify_BJF_parameters_kernel_level+0x18>
80104de8:	dd d8                	fstp   %st(0)
80104dea:	dd d8                	fstp   %st(0)
80104dec:	dd d8                	fstp   %st(0)
  }
}
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    

80104df0 <state_to_string>:

const char* state_to_string(enum procstate const state)
{
80104df0:	55                   	push   %ebp
80104df1:	31 c0                	xor    %eax,%eax
80104df3:	89 e5                	mov    %esp,%ebp
80104df5:	8b 55 08             	mov    0x8(%ebp),%edx
80104df8:	83 fa 05             	cmp    $0x5,%edx
80104dfb:	77 07                	ja     80104e04 <state_to_string+0x14>
80104dfd:	8b 04 95 ac 89 10 80 	mov    -0x7fef7654(,%edx,4),%eax
    case ZOMBIE:  
      return "ZOMBIE";
      break;
  }
  return 0;
}
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d 76 00             	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <print_information>:

void print_information()
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
  struct proc* p;
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
  cprintf("...............................................................................................................\n");
  //acquire(&ptable.lock);
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104e15:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	68 6c 88 10 80       	push   $0x8010886c
80104e22:	e8 39 b8 ff ff       	call   80100660 <cprintf>
  cprintf("...............................................................................................................\n");
80104e27:	c7 04 24 d4 88 10 80 	movl   $0x801088d4,(%esp)
80104e2e:	e8 2d b8 ff ff       	call   80100660 <cprintf>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	8d 76 00             	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e40:	8d 73 6c             	lea    0x6c(%ebx),%esi
  {
    if(strlen(p->name) == 0)
80104e43:	83 ec 0c             	sub    $0xc,%esp
80104e46:	56                   	push   %esi
80104e47:	e8 34 06 00 00       	call   80105480 <strlen>
80104e4c:	83 c4 10             	add    $0x10,%esp
80104e4f:	85 c0                	test   %eax,%eax
80104e51:	74 66                	je     80104eb9 <print_information+0xa9>
      continue;
   
    cprintf("%s \t", p->name);
80104e53:	83 ec 08             	sub    $0x8,%esp
80104e56:	56                   	push   %esi
80104e57:	68 db 87 10 80       	push   $0x801087db
80104e5c:	e8 ff b7 ff ff       	call   80100660 <cprintf>
    cprintf("%d \t", p->pid);
80104e61:	58                   	pop    %eax
80104e62:	5a                   	pop    %edx
80104e63:	ff 73 10             	pushl  0x10(%ebx)
80104e66:	68 e0 87 10 80       	push   $0x801087e0
80104e6b:	e8 f0 b7 ff ff       	call   80100660 <cprintf>
    cprintf("%s \t", state_to_string(p->state));
80104e70:	8b 53 0c             	mov    0xc(%ebx),%edx
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	31 c0                	xor    %eax,%eax
80104e78:	83 fa 05             	cmp    $0x5,%edx
80104e7b:	77 07                	ja     80104e84 <print_information+0x74>
80104e7d:	8b 04 95 ac 89 10 80 	mov    -0x7fef7654(,%edx,4),%eax
80104e84:	83 ec 08             	sub    $0x8,%esp
80104e87:	50                   	push   %eax
80104e88:	68 db 87 10 80       	push   $0x801087db
80104e8d:	e8 ce b7 ff ff       	call   80100660 <cprintf>
    cprintf("%d \t", p->level);
80104e92:	58                   	pop    %eax
80104e93:	5a                   	pop    %edx
80104e94:	ff b3 f4 00 00 00    	pushl  0xf4(%ebx)
80104e9a:	68 e0 87 10 80       	push   $0x801087e0
80104e9f:	e8 bc b7 ff ff       	call   80100660 <cprintf>
    cprintf("%d \n", p->cycle);
80104ea4:	59                   	pop    %ecx
80104ea5:	5e                   	pop    %esi
80104ea6:	ff b3 18 01 00 00    	pushl  0x118(%ebx)
80104eac:	68 e5 87 10 80       	push   $0x801087e5
80104eb1:	e8 aa b7 ff ff       	call   80100660 <cprintf>
80104eb6:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104eb9:	81 c3 20 01 00 00    	add    $0x120,%ebx
80104ebf:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104ec5:	0f 82 75 ff ff ff    	jb     80104e40 <print_information+0x30>

    // cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
    // p->name, p->pid, state_to_string(p->state), p->level, p->lottery_ticket, p->priority_ratio, p->arrivt_ratio, p->exect_ratio, p->cycle, rank);
  }
  //release(&ptable.lock);
80104ecb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ece:	5b                   	pop    %ebx
80104ecf:	5e                   	pop    %esi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	66 90                	xchg   %ax,%ax
80104ed4:	66 90                	xchg   %ax,%ax
80104ed6:	66 90                	xchg   %ax,%ax
80104ed8:	66 90                	xchg   %ax,%ax
80104eda:	66 90                	xchg   %ax,%ax
80104edc:	66 90                	xchg   %ax,%ax
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eea:	68 f0 89 10 80       	push   $0x801089f0
80104eef:	8d 43 04             	lea    0x4(%ebx),%eax
80104ef2:	50                   	push   %eax
80104ef3:	e8 18 01 00 00       	call   80105010 <initlock>
  lk->name = name;
80104ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104efb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f11:	c9                   	leave  
80104f12:	c3                   	ret    
80104f13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f2e:	56                   	push   %esi
80104f2f:	e8 1c 02 00 00       	call   80105150 <acquire>
  while (lk->locked) {
80104f34:	8b 13                	mov    (%ebx),%edx
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	85 d2                	test   %edx,%edx
80104f3b:	74 16                	je     80104f53 <acquiresleep+0x33>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f40:	83 ec 08             	sub    $0x8,%esp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	e8 a6 f5 ff ff       	call   801044f0 <sleep>
  while (lk->locked) {
80104f4a:	8b 03                	mov    (%ebx),%eax
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	75 ed                	jne    80104f40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f59:	e8 62 eb ff ff       	call   80103ac0 <myproc>
80104f5e:	8b 40 10             	mov    0x10(%eax),%eax
80104f61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6a:	5b                   	pop    %ebx
80104f6b:	5e                   	pop    %esi
80104f6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f6d:	e9 9e 02 00 00       	jmp    80105210 <release>
80104f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f8e:	56                   	push   %esi
80104f8f:	e8 bc 01 00 00       	call   80105150 <acquire>
  lk->locked = 0;
80104f94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104fa1:	89 1c 24             	mov    %ebx,(%esp)
80104fa4:	e8 07 f7 ff ff       	call   801046b0 <wakeup>
  release(&lk->lk);
80104fa9:	89 75 08             	mov    %esi,0x8(%ebp)
80104fac:	83 c4 10             	add    $0x10,%esp
}
80104faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104fb5:	e9 56 02 00 00       	jmp    80105210 <release>
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	31 ff                	xor    %edi,%edi
80104fc8:	83 ec 18             	sub    $0x18,%esp
80104fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104fce:	8d 73 04             	lea    0x4(%ebx),%esi
80104fd1:	56                   	push   %esi
80104fd2:	e8 79 01 00 00       	call   80105150 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fd7:	8b 03                	mov    (%ebx),%eax
80104fd9:	83 c4 10             	add    $0x10,%esp
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	74 13                	je     80104ff3 <holdingsleep+0x33>
80104fe0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fe3:	e8 d8 ea ff ff       	call   80103ac0 <myproc>
80104fe8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104feb:	0f 94 c0             	sete   %al
80104fee:	0f b6 c0             	movzbl %al,%eax
80104ff1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ff3:	83 ec 0c             	sub    $0xc,%esp
80104ff6:	56                   	push   %esi
80104ff7:	e8 14 02 00 00       	call   80105210 <release>
  return r;
}
80104ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fff:	89 f8                	mov    %edi,%eax
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5f                   	pop    %edi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	66 90                	xchg   %ax,%ax
80105008:	66 90                	xchg   %ax,%ax
8010500a:	66 90                	xchg   %ax,%ax
8010500c:	66 90                	xchg   %ax,%ax
8010500e:	66 90                	xchg   %ax,%ax

80105010 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105016:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010501f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	90                   	nop
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105030 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105030:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105031:	31 d2                	xor    %edx,%edx
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010503c:	83 e8 08             	sub    $0x8,%eax
8010503f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105040:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105046:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010504c:	77 1a                	ja     80105068 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010504e:	8b 58 04             	mov    0x4(%eax),%ebx
80105051:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105054:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105057:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105059:	83 fa 0a             	cmp    $0xa,%edx
8010505c:	75 e2                	jne    80105040 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010505e:	5b                   	pop    %ebx
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105068:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010506b:	83 c1 28             	add    $0x28,%ecx
8010506e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105076:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105079:	39 c1                	cmp    %eax,%ecx
8010507b:	75 f3                	jne    80105070 <getcallerpcs+0x40>
}
8010507d:	5b                   	pop    %ebx
8010507e:	5d                   	pop    %ebp
8010507f:	c3                   	ret    

80105080 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
80105087:	9c                   	pushf  
80105088:	5b                   	pop    %ebx
  asm volatile("cli");
80105089:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010508a:	e8 21 e9 ff ff       	call   801039b0 <mycpu>
8010508f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105095:	85 c0                	test   %eax,%eax
80105097:	75 11                	jne    801050aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105099:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010509f:	e8 0c e9 ff ff       	call   801039b0 <mycpu>
801050a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801050aa:	e8 01 e9 ff ff       	call   801039b0 <mycpu>
801050af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801050b6:	83 c4 04             	add    $0x4,%esp
801050b9:	5b                   	pop    %ebx
801050ba:	5d                   	pop    %ebp
801050bb:	c3                   	ret    
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050c0 <popcli>:

void
popcli(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050c6:	9c                   	pushf  
801050c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050c8:	f6 c4 02             	test   $0x2,%ah
801050cb:	75 35                	jne    80105102 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801050cd:	e8 de e8 ff ff       	call   801039b0 <mycpu>
801050d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050d9:	78 34                	js     8010510f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050db:	e8 d0 e8 ff ff       	call   801039b0 <mycpu>
801050e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050e6:	85 d2                	test   %edx,%edx
801050e8:	74 06                	je     801050f0 <popcli+0x30>
    sti();
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050f0:	e8 bb e8 ff ff       	call   801039b0 <mycpu>
801050f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	74 eb                	je     801050ea <popcli+0x2a>
  asm volatile("sti");
801050ff:	fb                   	sti    
}
80105100:	c9                   	leave  
80105101:	c3                   	ret    
    panic("popcli - interruptible");
80105102:	83 ec 0c             	sub    $0xc,%esp
80105105:	68 fb 89 10 80       	push   $0x801089fb
8010510a:	e8 81 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	68 12 8a 10 80       	push   $0x80108a12
80105117:	e8 74 b2 ff ff       	call   80100390 <panic>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <holding>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 75 08             	mov    0x8(%ebp),%esi
80105128:	31 db                	xor    %ebx,%ebx
  pushcli();
8010512a:	e8 51 ff ff ff       	call   80105080 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010512f:	8b 06                	mov    (%esi),%eax
80105131:	85 c0                	test   %eax,%eax
80105133:	74 10                	je     80105145 <holding+0x25>
80105135:	8b 5e 08             	mov    0x8(%esi),%ebx
80105138:	e8 73 e8 ff ff       	call   801039b0 <mycpu>
8010513d:	39 c3                	cmp    %eax,%ebx
8010513f:	0f 94 c3             	sete   %bl
80105142:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105145:	e8 76 ff ff ff       	call   801050c0 <popcli>
}
8010514a:	89 d8                	mov    %ebx,%eax
8010514c:	5b                   	pop    %ebx
8010514d:	5e                   	pop    %esi
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret    

80105150 <acquire>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105155:	e8 26 ff ff ff       	call   80105080 <pushcli>
  if(holding(lk))
8010515a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	53                   	push   %ebx
80105161:	e8 ba ff ff ff       	call   80105120 <holding>
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	85 c0                	test   %eax,%eax
8010516b:	0f 85 83 00 00 00    	jne    801051f4 <acquire+0xa4>
80105171:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105173:	ba 01 00 00 00       	mov    $0x1,%edx
80105178:	eb 09                	jmp    80105183 <acquire+0x33>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105180:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105183:	89 d0                	mov    %edx,%eax
80105185:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105188:	85 c0                	test   %eax,%eax
8010518a:	75 f4                	jne    80105180 <acquire+0x30>
  __sync_synchronize();
8010518c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105191:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105194:	e8 17 e8 ff ff       	call   801039b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105199:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010519c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010519f:	89 e8                	mov    %ebp,%eax
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801051ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801051b4:	77 1a                	ja     801051d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801051b6:	8b 48 04             	mov    0x4(%eax),%ecx
801051b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801051bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801051bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801051c1:	83 fe 0a             	cmp    $0xa,%esi
801051c4:	75 e2                	jne    801051a8 <acquire+0x58>
}
801051c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801051d3:	83 c2 28             	add    $0x28,%edx
801051d6:	8d 76 00             	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801051e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801051e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801051e9:	39 d0                	cmp    %edx,%eax
801051eb:	75 f3                	jne    801051e0 <acquire+0x90>
}
801051ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f0:	5b                   	pop    %ebx
801051f1:	5e                   	pop    %esi
801051f2:	5d                   	pop    %ebp
801051f3:	c3                   	ret    
    panic("acquire");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 19 8a 10 80       	push   $0x80108a19
801051fc:	e8 8f b1 ff ff       	call   80100390 <panic>
80105201:	eb 0d                	jmp    80105210 <release>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <release>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 10             	sub    $0x10,%esp
80105217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010521a:	53                   	push   %ebx
8010521b:	e8 00 ff ff ff       	call   80105120 <holding>
80105220:	83 c4 10             	add    $0x10,%esp
80105223:	85 c0                	test   %eax,%eax
80105225:	74 22                	je     80105249 <release+0x39>
  lk->pcs[0] = 0;
80105227:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010522e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105235:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010523a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105243:	c9                   	leave  
  popcli();
80105244:	e9 77 fe ff ff       	jmp    801050c0 <popcli>
    panic("release");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 21 8a 10 80       	push   $0x80108a21
80105251:	e8 3a b1 ff ff       	call   80100390 <panic>
80105256:	66 90                	xchg   %ax,%ax
80105258:	66 90                	xchg   %ax,%ax
8010525a:	66 90                	xchg   %ax,%ax
8010525c:	66 90                	xchg   %ax,%ax
8010525e:	66 90                	xchg   %ax,%ax

80105260 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	53                   	push   %ebx
80105265:	8b 55 08             	mov    0x8(%ebp),%edx
80105268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010526b:	f6 c2 03             	test   $0x3,%dl
8010526e:	75 05                	jne    80105275 <memset+0x15>
80105270:	f6 c1 03             	test   $0x3,%cl
80105273:	74 13                	je     80105288 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105275:	89 d7                	mov    %edx,%edi
80105277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527a:	fc                   	cld    
8010527b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010527d:	5b                   	pop    %ebx
8010527e:	89 d0                	mov    %edx,%eax
80105280:	5f                   	pop    %edi
80105281:	5d                   	pop    %ebp
80105282:	c3                   	ret    
80105283:	90                   	nop
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105288:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010528c:	c1 e9 02             	shr    $0x2,%ecx
8010528f:	89 f8                	mov    %edi,%eax
80105291:	89 fb                	mov    %edi,%ebx
80105293:	c1 e0 18             	shl    $0x18,%eax
80105296:	c1 e3 10             	shl    $0x10,%ebx
80105299:	09 d8                	or     %ebx,%eax
8010529b:	09 f8                	or     %edi,%eax
8010529d:	c1 e7 08             	shl    $0x8,%edi
801052a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801052a2:	89 d7                	mov    %edx,%edi
801052a4:	fc                   	cld    
801052a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801052a7:	5b                   	pop    %ebx
801052a8:	89 d0                	mov    %edx,%eax
801052aa:	5f                   	pop    %edi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
801052b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801052b9:	8b 75 08             	mov    0x8(%ebp),%esi
801052bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052bf:	85 db                	test   %ebx,%ebx
801052c1:	74 29                	je     801052ec <memcmp+0x3c>
    if(*s1 != *s2)
801052c3:	0f b6 16             	movzbl (%esi),%edx
801052c6:	0f b6 0f             	movzbl (%edi),%ecx
801052c9:	38 d1                	cmp    %dl,%cl
801052cb:	75 2b                	jne    801052f8 <memcmp+0x48>
801052cd:	b8 01 00 00 00       	mov    $0x1,%eax
801052d2:	eb 14                	jmp    801052e8 <memcmp+0x38>
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801052dc:	83 c0 01             	add    $0x1,%eax
801052df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801052e4:	38 ca                	cmp    %cl,%dl
801052e6:	75 10                	jne    801052f8 <memcmp+0x48>
  while(n-- > 0){
801052e8:	39 d8                	cmp    %ebx,%eax
801052ea:	75 ec                	jne    801052d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801052ec:	5b                   	pop    %ebx
  return 0;
801052ed:	31 c0                	xor    %eax,%eax
}
801052ef:	5e                   	pop    %esi
801052f0:	5f                   	pop    %edi
801052f1:	5d                   	pop    %ebp
801052f2:	c3                   	ret    
801052f3:	90                   	nop
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801052f8:	0f b6 c2             	movzbl %dl,%eax
}
801052fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801052fc:	29 c8                	sub    %ecx,%eax
}
801052fe:	5e                   	pop    %esi
801052ff:	5f                   	pop    %edi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	8b 45 08             	mov    0x8(%ebp),%eax
80105318:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010531b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010531e:	39 c3                	cmp    %eax,%ebx
80105320:	73 26                	jae    80105348 <memmove+0x38>
80105322:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105325:	39 c8                	cmp    %ecx,%eax
80105327:	73 1f                	jae    80105348 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105329:	85 f6                	test   %esi,%esi
8010532b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010532e:	74 0f                	je     8010533f <memmove+0x2f>
      *--d = *--s;
80105330:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105334:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105337:	83 ea 01             	sub    $0x1,%edx
8010533a:	83 fa ff             	cmp    $0xffffffff,%edx
8010533d:	75 f1                	jne    80105330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010533f:	5b                   	pop    %ebx
80105340:	5e                   	pop    %esi
80105341:	5d                   	pop    %ebp
80105342:	c3                   	ret    
80105343:	90                   	nop
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105348:	31 d2                	xor    %edx,%edx
8010534a:	85 f6                	test   %esi,%esi
8010534c:	74 f1                	je     8010533f <memmove+0x2f>
8010534e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105350:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105354:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105357:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010535a:	39 d6                	cmp    %edx,%esi
8010535c:	75 f2                	jne    80105350 <memmove+0x40>
}
8010535e:	5b                   	pop    %ebx
8010535f:	5e                   	pop    %esi
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret    
80105362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105373:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105374:	eb 9a                	jmp    80105310 <memmove>
80105376:	8d 76 00             	lea    0x0(%esi),%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	8b 7d 10             	mov    0x10(%ebp),%edi
80105388:	53                   	push   %ebx
80105389:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010538c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010538f:	85 ff                	test   %edi,%edi
80105391:	74 2f                	je     801053c2 <strncmp+0x42>
80105393:	0f b6 01             	movzbl (%ecx),%eax
80105396:	0f b6 1e             	movzbl (%esi),%ebx
80105399:	84 c0                	test   %al,%al
8010539b:	74 37                	je     801053d4 <strncmp+0x54>
8010539d:	38 c3                	cmp    %al,%bl
8010539f:	75 33                	jne    801053d4 <strncmp+0x54>
801053a1:	01 f7                	add    %esi,%edi
801053a3:	eb 13                	jmp    801053b8 <strncmp+0x38>
801053a5:	8d 76 00             	lea    0x0(%esi),%esi
801053a8:	0f b6 01             	movzbl (%ecx),%eax
801053ab:	84 c0                	test   %al,%al
801053ad:	74 21                	je     801053d0 <strncmp+0x50>
801053af:	0f b6 1a             	movzbl (%edx),%ebx
801053b2:	89 d6                	mov    %edx,%esi
801053b4:	38 d8                	cmp    %bl,%al
801053b6:	75 1c                	jne    801053d4 <strncmp+0x54>
    n--, p++, q++;
801053b8:	8d 56 01             	lea    0x1(%esi),%edx
801053bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053be:	39 fa                	cmp    %edi,%edx
801053c0:	75 e6                	jne    801053a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801053c2:	5b                   	pop    %ebx
    return 0;
801053c3:	31 c0                	xor    %eax,%eax
}
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801053d4:	29 d8                	sub    %ebx,%eax
}
801053d6:	5b                   	pop    %ebx
801053d7:	5e                   	pop    %esi
801053d8:	5f                   	pop    %edi
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 45 08             	mov    0x8(%ebp),%eax
801053e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053ee:	89 c2                	mov    %eax,%edx
801053f0:	eb 19                	jmp    8010540b <strncpy+0x2b>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801053ff:	83 c2 01             	add    $0x1,%edx
80105402:	84 c9                	test   %cl,%cl
80105404:	88 4a ff             	mov    %cl,-0x1(%edx)
80105407:	74 09                	je     80105412 <strncpy+0x32>
80105409:	89 f1                	mov    %esi,%ecx
8010540b:	85 c9                	test   %ecx,%ecx
8010540d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105410:	7f e6                	jg     801053f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105412:	31 c9                	xor    %ecx,%ecx
80105414:	85 f6                	test   %esi,%esi
80105416:	7e 17                	jle    8010542f <strncpy+0x4f>
80105418:	90                   	nop
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105420:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105424:	89 f3                	mov    %esi,%ebx
80105426:	83 c1 01             	add    $0x1,%ecx
80105429:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010542b:	85 db                	test   %ebx,%ebx
8010542d:	7f f1                	jg     80105420 <strncpy+0x40>
  return os;
}
8010542f:	5b                   	pop    %ebx
80105430:	5e                   	pop    %esi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010544e:	85 c9                	test   %ecx,%ecx
80105450:	7e 26                	jle    80105478 <safestrcpy+0x38>
80105452:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105456:	89 c1                	mov    %eax,%ecx
80105458:	eb 17                	jmp    80105471 <safestrcpy+0x31>
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105460:	83 c2 01             	add    $0x1,%edx
80105463:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105467:	83 c1 01             	add    $0x1,%ecx
8010546a:	84 db                	test   %bl,%bl
8010546c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010546f:	74 04                	je     80105475 <safestrcpy+0x35>
80105471:	39 f2                	cmp    %esi,%edx
80105473:	75 eb                	jne    80105460 <safestrcpy+0x20>
    ;
  *s = 0;
80105475:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105478:	5b                   	pop    %ebx
80105479:	5e                   	pop    %esi
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <strlen>:

int
strlen(const char *s)
{
80105480:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105481:	31 c0                	xor    %eax,%eax
{
80105483:	89 e5                	mov    %esp,%ebp
80105485:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105488:	80 3a 00             	cmpb   $0x0,(%edx)
8010548b:	74 0c                	je     80105499 <strlen+0x19>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c0 01             	add    $0x1,%eax
80105493:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105497:	75 f7                	jne    80105490 <strlen+0x10>
    ;
  return n;
}
80105499:	5d                   	pop    %ebp
8010549a:	c3                   	ret    

8010549b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010549b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010549f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054a3:	55                   	push   %ebp
  pushl %ebx
801054a4:	53                   	push   %ebx
  pushl %esi
801054a5:	56                   	push   %esi
  pushl %edi
801054a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054ab:	5f                   	pop    %edi
  popl %esi
801054ac:	5e                   	pop    %esi
  popl %ebx
801054ad:	5b                   	pop    %ebx
  popl %ebp
801054ae:	5d                   	pop    %ebp
  ret
801054af:	c3                   	ret    

801054b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 04             	sub    $0x4,%esp
801054b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054ba:	e8 01 e6 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054bf:	8b 00                	mov    (%eax),%eax
801054c1:	39 d8                	cmp    %ebx,%eax
801054c3:	76 1b                	jbe    801054e0 <fetchint+0x30>
801054c5:	8d 53 04             	lea    0x4(%ebx),%edx
801054c8:	39 d0                	cmp    %edx,%eax
801054ca:	72 14                	jb     801054e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cf:	8b 13                	mov    (%ebx),%edx
801054d1:	89 10                	mov    %edx,(%eax)
  return 0;
801054d3:	31 c0                	xor    %eax,%eax
}
801054d5:	83 c4 04             	add    $0x4,%esp
801054d8:	5b                   	pop    %ebx
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e5:	eb ee                	jmp    801054d5 <fetchint+0x25>
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
801054f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054fa:	e8 c1 e5 ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz)
801054ff:	39 18                	cmp    %ebx,(%eax)
80105501:	76 29                	jbe    8010552c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105506:	89 da                	mov    %ebx,%edx
80105508:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010550a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010550c:	39 c3                	cmp    %eax,%ebx
8010550e:	73 1c                	jae    8010552c <fetchstr+0x3c>
    if(*s == 0)
80105510:	80 3b 00             	cmpb   $0x0,(%ebx)
80105513:	75 10                	jne    80105525 <fetchstr+0x35>
80105515:	eb 39                	jmp    80105550 <fetchstr+0x60>
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105520:	80 3a 00             	cmpb   $0x0,(%edx)
80105523:	74 1b                	je     80105540 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105525:	83 c2 01             	add    $0x1,%edx
80105528:	39 d0                	cmp    %edx,%eax
8010552a:	77 f4                	ja     80105520 <fetchstr+0x30>
    return -1;
8010552c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105531:	83 c4 04             	add    $0x4,%esp
80105534:	5b                   	pop    %ebx
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105540:	83 c4 04             	add    $0x4,%esp
80105543:	89 d0                	mov    %edx,%eax
80105545:	29 d8                	sub    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5d                   	pop    %ebp
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105550:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105552:	eb dd                	jmp    80105531 <fetchstr+0x41>
80105554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010555a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105560 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105565:	e8 56 e5 ff ff       	call   80103ac0 <myproc>
8010556a:	8b 40 18             	mov    0x18(%eax),%eax
8010556d:	8b 55 08             	mov    0x8(%ebp),%edx
80105570:	8b 40 44             	mov    0x44(%eax),%eax
80105573:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105576:	e8 45 e5 ff ff       	call   80103ac0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010557b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010557d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105580:	39 c6                	cmp    %eax,%esi
80105582:	73 1c                	jae    801055a0 <argint+0x40>
80105584:	8d 53 08             	lea    0x8(%ebx),%edx
80105587:	39 d0                	cmp    %edx,%eax
80105589:	72 15                	jb     801055a0 <argint+0x40>
  *ip = *(int*)(addr);
8010558b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558e:	8b 53 04             	mov    0x4(%ebx),%edx
80105591:	89 10                	mov    %edx,(%eax)
  return 0;
80105593:	31 c0                	xor    %eax,%eax
}
80105595:	5b                   	pop    %ebx
80105596:	5e                   	pop    %esi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055a5:	eb ee                	jmp    80105595 <argint+0x35>
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	83 ec 10             	sub    $0x10,%esp
801055b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801055bb:	e8 00 e5 ff ff       	call   80103ac0 <myproc>
801055c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801055c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	50                   	push   %eax
801055c9:	ff 75 08             	pushl  0x8(%ebp)
801055cc:	e8 8f ff ff ff       	call   80105560 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 28                	js     80105600 <argptr+0x50>
801055d8:	85 db                	test   %ebx,%ebx
801055da:	78 24                	js     80105600 <argptr+0x50>
801055dc:	8b 16                	mov    (%esi),%edx
801055de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e1:	39 c2                	cmp    %eax,%edx
801055e3:	76 1b                	jbe    80105600 <argptr+0x50>
801055e5:	01 c3                	add    %eax,%ebx
801055e7:	39 da                	cmp    %ebx,%edx
801055e9:	72 15                	jb     80105600 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801055eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801055ee:	89 02                	mov    %eax,(%edx)
  return 0;
801055f0:	31 c0                	xor    %eax,%eax
}
801055f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105605:	eb eb                	jmp    801055f2 <argptr+0x42>
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	50                   	push   %eax
8010561a:	ff 75 08             	pushl  0x8(%ebp)
8010561d:	e8 3e ff ff ff       	call   80105560 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 17                	js     80105640 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105629:	83 ec 08             	sub    $0x8,%esp
8010562c:	ff 75 0c             	pushl  0xc(%ebp)
8010562f:	ff 75 f4             	pushl  -0xc(%ebp)
80105632:	e8 b9 fe ff ff       	call   801054f0 <fetchstr>
80105637:	83 c4 10             	add    $0x10,%esp
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <syscall>:
[SYS_print_information]     sys_print_information,
};

void
syscall(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	53                   	push   %ebx
80105654:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105657:	e8 64 e4 ff ff       	call   80103ac0 <myproc>
8010565c:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
8010565e:	8b 40 18             	mov    0x18(%eax),%eax
80105661:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105664:	8d 50 ff             	lea    -0x1(%eax),%edx
80105667:	83 fa 1c             	cmp    $0x1c,%edx
8010566a:	77 1c                	ja     80105688 <syscall+0x38>
8010566c:	8b 14 85 60 8a 10 80 	mov    -0x7fef75a0(,%eax,4),%edx
80105673:	85 d2                	test   %edx,%edx
80105675:	74 11                	je     80105688 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105677:	ff d2                	call   *%edx
80105679:	8b 53 18             	mov    0x18(%ebx),%edx
8010567c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010567f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105682:	c9                   	leave  
80105683:	c3                   	ret    
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105688:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105689:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010568c:	50                   	push   %eax
8010568d:	ff 73 10             	pushl  0x10(%ebx)
80105690:	68 29 8a 10 80       	push   $0x80108a29
80105695:	e8 c6 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010569a:	8b 43 18             	mov    0x18(%ebx),%eax
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056aa:	c9                   	leave  
801056ab:	c3                   	ret    
801056ac:	66 90                	xchg   %ax,%ax
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056b6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056b9:	83 ec 34             	sub    $0x34,%esp
801056bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801056bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056c2:	56                   	push   %esi
801056c3:	50                   	push   %eax
{
801056c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056ca:	e8 21 ca ff ff       	call   801020f0 <nameiparent>
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	85 c0                	test   %eax,%eax
801056d4:	0f 84 46 01 00 00    	je     80105820 <create+0x170>
    return 0;
  ilock(dp);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	89 c3                	mov    %eax,%ebx
801056df:	50                   	push   %eax
801056e0:	e8 8b c1 ff ff       	call   80101870 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801056e5:	83 c4 0c             	add    $0xc,%esp
801056e8:	6a 00                	push   $0x0
801056ea:	56                   	push   %esi
801056eb:	53                   	push   %ebx
801056ec:	e8 af c6 ff ff       	call   80101da0 <dirlookup>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	89 c7                	mov    %eax,%edi
801056f8:	74 36                	je     80105730 <create+0x80>
    iunlockput(dp);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	53                   	push   %ebx
801056fe:	e8 fd c3 ff ff       	call   80101b00 <iunlockput>
    ilock(ip);
80105703:	89 3c 24             	mov    %edi,(%esp)
80105706:	e8 65 c1 ff ff       	call   80101870 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010570b:	83 c4 10             	add    $0x10,%esp
8010570e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105713:	0f 85 97 00 00 00    	jne    801057b0 <create+0x100>
80105719:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010571e:	0f 85 8c 00 00 00    	jne    801057b0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105727:	89 f8                	mov    %edi,%eax
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5f                   	pop    %edi
8010572c:	5d                   	pop    %ebp
8010572d:	c3                   	ret    
8010572e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105730:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	50                   	push   %eax
80105738:	ff 33                	pushl  (%ebx)
8010573a:	e8 c1 bf ff ff       	call   80101700 <ialloc>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	89 c7                	mov    %eax,%edi
80105746:	0f 84 e8 00 00 00    	je     80105834 <create+0x184>
  ilock(ip);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	50                   	push   %eax
80105750:	e8 1b c1 ff ff       	call   80101870 <ilock>
  ip->major = major;
80105755:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105759:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010575d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105761:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105765:	b8 01 00 00 00       	mov    $0x1,%eax
8010576a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010576e:	89 3c 24             	mov    %edi,(%esp)
80105771:	e8 4a c0 ff ff       	call   801017c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010577e:	74 50                	je     801057d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105780:	83 ec 04             	sub    $0x4,%esp
80105783:	ff 77 04             	pushl  0x4(%edi)
80105786:	56                   	push   %esi
80105787:	53                   	push   %ebx
80105788:	e8 83 c8 ff ff       	call   80102010 <dirlink>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	0f 88 8f 00 00 00    	js     80105827 <create+0x177>
  iunlockput(dp);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	53                   	push   %ebx
8010579c:	e8 5f c3 ff ff       	call   80101b00 <iunlockput>
  return ip;
801057a1:	83 c4 10             	add    $0x10,%esp
}
801057a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a7:	89 f8                	mov    %edi,%eax
801057a9:	5b                   	pop    %ebx
801057aa:	5e                   	pop    %esi
801057ab:	5f                   	pop    %edi
801057ac:	5d                   	pop    %ebp
801057ad:	c3                   	ret    
801057ae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	57                   	push   %edi
    return 0;
801057b4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057b6:	e8 45 c3 ff ff       	call   80101b00 <iunlockput>
    return 0;
801057bb:	83 c4 10             	add    $0x10,%esp
}
801057be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c1:	89 f8                	mov    %edi,%eax
801057c3:	5b                   	pop    %ebx
801057c4:	5e                   	pop    %esi
801057c5:	5f                   	pop    %edi
801057c6:	5d                   	pop    %ebp
801057c7:	c3                   	ret    
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057d0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057d5:	83 ec 0c             	sub    $0xc,%esp
801057d8:	53                   	push   %ebx
801057d9:	e8 e2 bf ff ff       	call   801017c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057de:	83 c4 0c             	add    $0xc,%esp
801057e1:	ff 77 04             	pushl  0x4(%edi)
801057e4:	68 f4 8a 10 80       	push   $0x80108af4
801057e9:	57                   	push   %edi
801057ea:	e8 21 c8 ff ff       	call   80102010 <dirlink>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 1c                	js     80105812 <create+0x162>
801057f6:	83 ec 04             	sub    $0x4,%esp
801057f9:	ff 73 04             	pushl  0x4(%ebx)
801057fc:	68 f3 8a 10 80       	push   $0x80108af3
80105801:	57                   	push   %edi
80105802:	e8 09 c8 ff ff       	call   80102010 <dirlink>
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	85 c0                	test   %eax,%eax
8010580c:	0f 89 6e ff ff ff    	jns    80105780 <create+0xd0>
      panic("create dots");
80105812:	83 ec 0c             	sub    $0xc,%esp
80105815:	68 e7 8a 10 80       	push   $0x80108ae7
8010581a:	e8 71 ab ff ff       	call   80100390 <panic>
8010581f:	90                   	nop
    return 0;
80105820:	31 ff                	xor    %edi,%edi
80105822:	e9 fd fe ff ff       	jmp    80105724 <create+0x74>
    panic("create: dirlink");
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	68 f6 8a 10 80       	push   $0x80108af6
8010582f:	e8 5c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	68 d8 8a 10 80       	push   $0x80108ad8
8010583c:	e8 4f ab ff ff       	call   80100390 <panic>
80105841:	eb 0d                	jmp    80105850 <argfd.constprop.0>
80105843:	90                   	nop
80105844:	90                   	nop
80105845:	90                   	nop
80105846:	90                   	nop
80105847:	90                   	nop
80105848:	90                   	nop
80105849:	90                   	nop
8010584a:	90                   	nop
8010584b:	90                   	nop
8010584c:	90                   	nop
8010584d:	90                   	nop
8010584e:	90                   	nop
8010584f:	90                   	nop

80105850 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	56                   	push   %esi
80105854:	53                   	push   %ebx
80105855:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105857:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010585a:	89 d6                	mov    %edx,%esi
8010585c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010585f:	50                   	push   %eax
80105860:	6a 00                	push   $0x0
80105862:	e8 f9 fc ff ff       	call   80105560 <argint>
80105867:	83 c4 10             	add    $0x10,%esp
8010586a:	85 c0                	test   %eax,%eax
8010586c:	78 2a                	js     80105898 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010586e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105872:	77 24                	ja     80105898 <argfd.constprop.0+0x48>
80105874:	e8 47 e2 ff ff       	call   80103ac0 <myproc>
80105879:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010587c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105880:	85 c0                	test   %eax,%eax
80105882:	74 14                	je     80105898 <argfd.constprop.0+0x48>
  if(pfd)
80105884:	85 db                	test   %ebx,%ebx
80105886:	74 02                	je     8010588a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105888:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010588a:	89 06                	mov    %eax,(%esi)
  return 0;
8010588c:	31 c0                	xor    %eax,%eax
}
8010588e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105891:	5b                   	pop    %ebx
80105892:	5e                   	pop    %esi
80105893:	5d                   	pop    %ebp
80105894:	c3                   	ret    
80105895:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589d:	eb ef                	jmp    8010588e <argfd.constprop.0+0x3e>
8010589f:	90                   	nop

801058a0 <sys_dup>:
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
801058a5:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[9] ++;
801058a8:	e8 13 e2 ff ff       	call   80103ac0 <myproc>
801058ad:	83 80 a0 00 00 00 01 	addl   $0x1,0xa0(%eax)
  if(argfd(0, 0, &f) < 0)
801058b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
801058b7:	31 c0                	xor    %eax,%eax
801058b9:	e8 92 ff ff ff       	call   80105850 <argfd.constprop.0>
801058be:	85 c0                	test   %eax,%eax
801058c0:	78 3e                	js     80105900 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
801058c2:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058c5:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058c7:	e8 f4 e1 ff ff       	call   80103ac0 <myproc>
801058cc:	eb 0a                	jmp    801058d8 <sys_dup+0x38>
801058ce:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c3 01             	add    $0x1,%ebx
801058d3:	83 fb 10             	cmp    $0x10,%ebx
801058d6:	74 28                	je     80105900 <sys_dup+0x60>
    if(curproc->ofile[fd] == 0){
801058d8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058dc:	85 d2                	test   %edx,%edx
801058de:	75 f0                	jne    801058d0 <sys_dup+0x30>
      curproc->ofile[fd] = f;
801058e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801058e4:	83 ec 0c             	sub    $0xc,%esp
801058e7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ea:	e8 f1 b6 ff ff       	call   80100fe0 <filedup>
  return fd;
801058ef:	83 c4 10             	add    $0x10,%esp
}
801058f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f5:	89 d8                	mov    %ebx,%eax
801058f7:	5b                   	pop    %ebx
801058f8:	5e                   	pop    %esi
801058f9:	5d                   	pop    %ebp
801058fa:	c3                   	ret    
801058fb:	90                   	nop
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105900:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105903:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105908:	89 d8                	mov    %ebx,%eax
8010590a:	5b                   	pop    %ebx
8010590b:	5e                   	pop    %esi
8010590c:	5d                   	pop    %ebp
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_read>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[4] ++;
80105916:	e8 a5 e1 ff ff       	call   80103ac0 <myproc>
8010591b:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105922:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105925:	31 c0                	xor    %eax,%eax
80105927:	e8 24 ff ff ff       	call   80105850 <argfd.constprop.0>
8010592c:	85 c0                	test   %eax,%eax
8010592e:	78 48                	js     80105978 <sys_read+0x68>
80105930:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105933:	83 ec 08             	sub    $0x8,%esp
80105936:	50                   	push   %eax
80105937:	6a 02                	push   $0x2
80105939:	e8 22 fc ff ff       	call   80105560 <argint>
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	85 c0                	test   %eax,%eax
80105943:	78 33                	js     80105978 <sys_read+0x68>
80105945:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105948:	83 ec 04             	sub    $0x4,%esp
8010594b:	ff 75 f0             	pushl  -0x10(%ebp)
8010594e:	50                   	push   %eax
8010594f:	6a 01                	push   $0x1
80105951:	e8 5a fc ff ff       	call   801055b0 <argptr>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 1b                	js     80105978 <sys_read+0x68>
  return fileread(f, p, n);
8010595d:	83 ec 04             	sub    $0x4,%esp
80105960:	ff 75 f0             	pushl  -0x10(%ebp)
80105963:	ff 75 f4             	pushl  -0xc(%ebp)
80105966:	ff 75 ec             	pushl  -0x14(%ebp)
80105969:	e8 e2 b7 ff ff       	call   80101150 <fileread>
8010596e:	83 c4 10             	add    $0x10,%esp
}
80105971:	c9                   	leave  
80105972:	c3                   	ret    
80105973:	90                   	nop
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    
8010597f:	90                   	nop

80105980 <sys_write>:
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[15] ++;
80105986:	e8 35 e1 ff ff       	call   80103ac0 <myproc>
8010598b:	83 80 b8 00 00 00 01 	addl   $0x1,0xb8(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105992:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105995:	31 c0                	xor    %eax,%eax
80105997:	e8 b4 fe ff ff       	call   80105850 <argfd.constprop.0>
8010599c:	85 c0                	test   %eax,%eax
8010599e:	78 48                	js     801059e8 <sys_write+0x68>
801059a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a3:	83 ec 08             	sub    $0x8,%esp
801059a6:	50                   	push   %eax
801059a7:	6a 02                	push   $0x2
801059a9:	e8 b2 fb ff ff       	call   80105560 <argint>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	85 c0                	test   %eax,%eax
801059b3:	78 33                	js     801059e8 <sys_write+0x68>
801059b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b8:	83 ec 04             	sub    $0x4,%esp
801059bb:	ff 75 f0             	pushl  -0x10(%ebp)
801059be:	50                   	push   %eax
801059bf:	6a 01                	push   $0x1
801059c1:	e8 ea fb ff ff       	call   801055b0 <argptr>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	78 1b                	js     801059e8 <sys_write+0x68>
  return filewrite(f, p, n);
801059cd:	83 ec 04             	sub    $0x4,%esp
801059d0:	ff 75 f0             	pushl  -0x10(%ebp)
801059d3:	ff 75 f4             	pushl  -0xc(%ebp)
801059d6:	ff 75 ec             	pushl  -0x14(%ebp)
801059d9:	e8 02 b8 ff ff       	call   801011e0 <filewrite>
801059de:	83 c4 10             	add    $0x10,%esp
}
801059e1:	c9                   	leave  
801059e2:	c3                   	ret    
801059e3:	90                   	nop
801059e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ed:	c9                   	leave  
801059ee:	c3                   	ret    
801059ef:	90                   	nop

801059f0 <sys_close>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[20] ++;
801059f6:	e8 c5 e0 ff ff       	call   80103ac0 <myproc>
801059fb:	83 80 cc 00 00 00 01 	addl   $0x1,0xcc(%eax)
  if(argfd(0, &fd, &f) < 0)
80105a02:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105a05:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a08:	e8 43 fe ff ff       	call   80105850 <argfd.constprop.0>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	78 27                	js     80105a38 <sys_close+0x48>
  myproc()->ofile[fd] = 0;
80105a11:	e8 aa e0 ff ff       	call   80103ac0 <myproc>
80105a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105a19:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a1c:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105a23:	00 
  fileclose(f);
80105a24:	ff 75 f4             	pushl  -0xc(%ebp)
80105a27:	e8 04 b6 ff ff       	call   80101030 <fileclose>
  return 0;
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	31 c0                	xor    %eax,%eax
}
80105a31:	c9                   	leave  
80105a32:	c3                   	ret    
80105a33:	90                   	nop
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3d:	c9                   	leave  
80105a3e:	c3                   	ret    
80105a3f:	90                   	nop

80105a40 <sys_fstat>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[7] ++;
80105a46:	e8 75 e0 ff ff       	call   80103ac0 <myproc>
80105a4b:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a52:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a55:	31 c0                	xor    %eax,%eax
80105a57:	e8 f4 fd ff ff       	call   80105850 <argfd.constprop.0>
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	78 30                	js     80105a90 <sys_fstat+0x50>
80105a60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a63:	83 ec 04             	sub    $0x4,%esp
80105a66:	6a 14                	push   $0x14
80105a68:	50                   	push   %eax
80105a69:	6a 01                	push   $0x1
80105a6b:	e8 40 fb ff ff       	call   801055b0 <argptr>
80105a70:	83 c4 10             	add    $0x10,%esp
80105a73:	85 c0                	test   %eax,%eax
80105a75:	78 19                	js     80105a90 <sys_fstat+0x50>
  return filestat(f, st);
80105a77:	83 ec 08             	sub    $0x8,%esp
80105a7a:	ff 75 f4             	pushl  -0xc(%ebp)
80105a7d:	ff 75 f0             	pushl  -0x10(%ebp)
80105a80:	e8 7b b6 ff ff       	call   80101100 <filestat>
80105a85:	83 c4 10             	add    $0x10,%esp
}
80105a88:	c9                   	leave  
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_link>:
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	83 ec 2c             	sub    $0x2c,%esp
  myproc()->call_nums[18] ++;
80105aa9:	e8 12 e0 ff ff       	call   80103ac0 <myproc>
80105aae:	83 80 c4 00 00 00 01 	addl   $0x1,0xc4(%eax)
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ab5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105ab8:	83 ec 08             	sub    $0x8,%esp
80105abb:	50                   	push   %eax
80105abc:	6a 00                	push   $0x0
80105abe:	e8 4d fb ff ff       	call   80105610 <argstr>
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	85 c0                	test   %eax,%eax
80105ac8:	0f 88 fc 00 00 00    	js     80105bca <sys_link+0x12a>
80105ace:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ad1:	83 ec 08             	sub    $0x8,%esp
80105ad4:	50                   	push   %eax
80105ad5:	6a 01                	push   $0x1
80105ad7:	e8 34 fb ff ff       	call   80105610 <argstr>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	0f 88 e3 00 00 00    	js     80105bca <sys_link+0x12a>
  begin_op();
80105ae7:	e8 a4 d2 ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	ff 75 d4             	pushl  -0x2c(%ebp)
80105af2:	e8 d9 c5 ff ff       	call   801020d0 <namei>
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	89 c3                	mov    %eax,%ebx
80105afe:	0f 84 eb 00 00 00    	je     80105bef <sys_link+0x14f>
  ilock(ip);
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	50                   	push   %eax
80105b08:	e8 63 bd ff ff       	call   80101870 <ilock>
  if(ip->type == T_DIR){
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b15:	0f 84 bc 00 00 00    	je     80105bd7 <sys_link+0x137>
  ip->nlink++;
80105b1b:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b20:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105b23:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b26:	53                   	push   %ebx
80105b27:	e8 94 bc ff ff       	call   801017c0 <iupdate>
  iunlock(ip);
80105b2c:	89 1c 24             	mov    %ebx,(%esp)
80105b2f:	e8 1c be ff ff       	call   80101950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b34:	58                   	pop    %eax
80105b35:	5a                   	pop    %edx
80105b36:	57                   	push   %edi
80105b37:	ff 75 d0             	pushl  -0x30(%ebp)
80105b3a:	e8 b1 c5 ff ff       	call   801020f0 <nameiparent>
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	85 c0                	test   %eax,%eax
80105b44:	89 c6                	mov    %eax,%esi
80105b46:	74 5c                	je     80105ba4 <sys_link+0x104>
  ilock(dp);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	50                   	push   %eax
80105b4c:	e8 1f bd ff ff       	call   80101870 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	8b 03                	mov    (%ebx),%eax
80105b56:	39 06                	cmp    %eax,(%esi)
80105b58:	75 3e                	jne    80105b98 <sys_link+0xf8>
80105b5a:	83 ec 04             	sub    $0x4,%esp
80105b5d:	ff 73 04             	pushl  0x4(%ebx)
80105b60:	57                   	push   %edi
80105b61:	56                   	push   %esi
80105b62:	e8 a9 c4 ff ff       	call   80102010 <dirlink>
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	85 c0                	test   %eax,%eax
80105b6c:	78 2a                	js     80105b98 <sys_link+0xf8>
  iunlockput(dp);
80105b6e:	83 ec 0c             	sub    $0xc,%esp
80105b71:	56                   	push   %esi
80105b72:	e8 89 bf ff ff       	call   80101b00 <iunlockput>
  iput(ip);
80105b77:	89 1c 24             	mov    %ebx,(%esp)
80105b7a:	e8 21 be ff ff       	call   801019a0 <iput>
  end_op();
80105b7f:	e8 7c d2 ff ff       	call   80102e00 <end_op>
  return 0;
80105b84:	83 c4 10             	add    $0x10,%esp
80105b87:	31 c0                	xor    %eax,%eax
}
80105b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b8c:	5b                   	pop    %ebx
80105b8d:	5e                   	pop    %esi
80105b8e:	5f                   	pop    %edi
80105b8f:	5d                   	pop    %ebp
80105b90:	c3                   	ret    
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	56                   	push   %esi
80105b9c:	e8 5f bf ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	53                   	push   %ebx
80105ba8:	e8 c3 bc ff ff       	call   80101870 <ilock>
  ip->nlink--;
80105bad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bb2:	89 1c 24             	mov    %ebx,(%esp)
80105bb5:	e8 06 bc ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
80105bba:	89 1c 24             	mov    %ebx,(%esp)
80105bbd:	e8 3e bf ff ff       	call   80101b00 <iunlockput>
  end_op();
80105bc2:	e8 39 d2 ff ff       	call   80102e00 <end_op>
  return -1;
80105bc7:	83 c4 10             	add    $0x10,%esp
}
80105bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bd2:	5b                   	pop    %ebx
80105bd3:	5e                   	pop    %esi
80105bd4:	5f                   	pop    %edi
80105bd5:	5d                   	pop    %ebp
80105bd6:	c3                   	ret    
    iunlockput(ip);
80105bd7:	83 ec 0c             	sub    $0xc,%esp
80105bda:	53                   	push   %ebx
80105bdb:	e8 20 bf ff ff       	call   80101b00 <iunlockput>
    end_op();
80105be0:	e8 1b d2 ff ff       	call   80102e00 <end_op>
    return -1;
80105be5:	83 c4 10             	add    $0x10,%esp
80105be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bed:	eb 9a                	jmp    80105b89 <sys_link+0xe9>
    end_op();
80105bef:	e8 0c d2 ff ff       	call   80102e00 <end_op>
    return -1;
80105bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf9:	eb 8e                	jmp    80105b89 <sys_link+0xe9>
80105bfb:	90                   	nop
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_unlink>:
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
80105c05:	53                   	push   %ebx
80105c06:	83 ec 3c             	sub    $0x3c,%esp
  myproc()->call_nums[17] ++;
80105c09:	e8 b2 de ff ff       	call   80103ac0 <myproc>
80105c0e:	83 80 c0 00 00 00 01 	addl   $0x1,0xc0(%eax)
  if(argstr(0, &path) < 0)
80105c15:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105c18:	83 ec 08             	sub    $0x8,%esp
80105c1b:	50                   	push   %eax
80105c1c:	6a 00                	push   $0x0
80105c1e:	e8 ed f9 ff ff       	call   80105610 <argstr>
80105c23:	83 c4 10             	add    $0x10,%esp
80105c26:	85 c0                	test   %eax,%eax
80105c28:	0f 88 78 01 00 00    	js     80105da6 <sys_unlink+0x1a6>
  if((dp = nameiparent(path, name)) == 0){
80105c2e:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105c31:	e8 5a d1 ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c36:	83 ec 08             	sub    $0x8,%esp
80105c39:	53                   	push   %ebx
80105c3a:	ff 75 c0             	pushl  -0x40(%ebp)
80105c3d:	e8 ae c4 ff ff       	call   801020f0 <nameiparent>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	89 c6                	mov    %eax,%esi
80105c49:	0f 84 61 01 00 00    	je     80105db0 <sys_unlink+0x1b0>
  ilock(dp);
80105c4f:	83 ec 0c             	sub    $0xc,%esp
80105c52:	50                   	push   %eax
80105c53:	e8 18 bc ff ff       	call   80101870 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c58:	58                   	pop    %eax
80105c59:	5a                   	pop    %edx
80105c5a:	68 f4 8a 10 80       	push   $0x80108af4
80105c5f:	53                   	push   %ebx
80105c60:	e8 1b c1 ff ff       	call   80101d80 <namecmp>
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	0f 84 04 01 00 00    	je     80105d74 <sys_unlink+0x174>
80105c70:	83 ec 08             	sub    $0x8,%esp
80105c73:	68 f3 8a 10 80       	push   $0x80108af3
80105c78:	53                   	push   %ebx
80105c79:	e8 02 c1 ff ff       	call   80101d80 <namecmp>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	85 c0                	test   %eax,%eax
80105c83:	0f 84 eb 00 00 00    	je     80105d74 <sys_unlink+0x174>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c89:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c8c:	83 ec 04             	sub    $0x4,%esp
80105c8f:	50                   	push   %eax
80105c90:	53                   	push   %ebx
80105c91:	56                   	push   %esi
80105c92:	e8 09 c1 ff ff       	call   80101da0 <dirlookup>
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	85 c0                	test   %eax,%eax
80105c9c:	89 c3                	mov    %eax,%ebx
80105c9e:	0f 84 d0 00 00 00    	je     80105d74 <sys_unlink+0x174>
  ilock(ip);
80105ca4:	83 ec 0c             	sub    $0xc,%esp
80105ca7:	50                   	push   %eax
80105ca8:	e8 c3 bb ff ff       	call   80101870 <ilock>
  if(ip->nlink < 1)
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105cb5:	0f 8e 11 01 00 00    	jle    80105dcc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105cbb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc0:	74 6e                	je     80105d30 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
80105cc2:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cc5:	83 ec 04             	sub    $0x4,%esp
80105cc8:	6a 10                	push   $0x10
80105cca:	6a 00                	push   $0x0
80105ccc:	50                   	push   %eax
80105ccd:	e8 8e f5 ff ff       	call   80105260 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cd2:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cd5:	6a 10                	push   $0x10
80105cd7:	ff 75 c4             	pushl  -0x3c(%ebp)
80105cda:	50                   	push   %eax
80105cdb:	56                   	push   %esi
80105cdc:	e8 6f bf ff ff       	call   80101c50 <writei>
80105ce1:	83 c4 20             	add    $0x20,%esp
80105ce4:	83 f8 10             	cmp    $0x10,%eax
80105ce7:	0f 85 ec 00 00 00    	jne    80105dd9 <sys_unlink+0x1d9>
  if(ip->type == T_DIR){
80105ced:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cf2:	0f 84 98 00 00 00    	je     80105d90 <sys_unlink+0x190>
  iunlockput(dp);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	56                   	push   %esi
80105cfc:	e8 ff bd ff ff       	call   80101b00 <iunlockput>
  ip->nlink--;
80105d01:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d06:	89 1c 24             	mov    %ebx,(%esp)
80105d09:	e8 b2 ba ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
80105d0e:	89 1c 24             	mov    %ebx,(%esp)
80105d11:	e8 ea bd ff ff       	call   80101b00 <iunlockput>
  end_op();
80105d16:	e8 e5 d0 ff ff       	call   80102e00 <end_op>
  return 0;
80105d1b:	83 c4 10             	add    $0x10,%esp
80105d1e:	31 c0                	xor    %eax,%eax
}
80105d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d23:	5b                   	pop    %ebx
80105d24:	5e                   	pop    %esi
80105d25:	5f                   	pop    %edi
80105d26:	5d                   	pop    %ebp
80105d27:	c3                   	ret    
80105d28:	90                   	nop
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d34:	76 8c                	jbe    80105cc2 <sys_unlink+0xc2>
80105d36:	bf 20 00 00 00       	mov    $0x20,%edi
80105d3b:	eb 0f                	jmp    80105d4c <sys_unlink+0x14c>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
80105d40:	83 c7 10             	add    $0x10,%edi
80105d43:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105d46:	0f 83 76 ff ff ff    	jae    80105cc2 <sys_unlink+0xc2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d4c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d4f:	6a 10                	push   $0x10
80105d51:	57                   	push   %edi
80105d52:	50                   	push   %eax
80105d53:	53                   	push   %ebx
80105d54:	e8 f7 bd ff ff       	call   80101b50 <readi>
80105d59:	83 c4 10             	add    $0x10,%esp
80105d5c:	83 f8 10             	cmp    $0x10,%eax
80105d5f:	75 5e                	jne    80105dbf <sys_unlink+0x1bf>
    if(de.inum != 0)
80105d61:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d66:	74 d8                	je     80105d40 <sys_unlink+0x140>
    iunlockput(ip);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	53                   	push   %ebx
80105d6c:	e8 8f bd ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105d71:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105d74:	83 ec 0c             	sub    $0xc,%esp
80105d77:	56                   	push   %esi
80105d78:	e8 83 bd ff ff       	call   80101b00 <iunlockput>
  end_op();
80105d7d:	e8 7e d0 ff ff       	call   80102e00 <end_op>
  return -1;
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8a:	eb 94                	jmp    80105d20 <sys_unlink+0x120>
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105d90:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105d95:	83 ec 0c             	sub    $0xc,%esp
80105d98:	56                   	push   %esi
80105d99:	e8 22 ba ff ff       	call   801017c0 <iupdate>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	e9 52 ff ff ff       	jmp    80105cf8 <sys_unlink+0xf8>
    return -1;
80105da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dab:	e9 70 ff ff ff       	jmp    80105d20 <sys_unlink+0x120>
    end_op();
80105db0:	e8 4b d0 ff ff       	call   80102e00 <end_op>
    return -1;
80105db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dba:	e9 61 ff ff ff       	jmp    80105d20 <sys_unlink+0x120>
      panic("isdirempty: readi");
80105dbf:	83 ec 0c             	sub    $0xc,%esp
80105dc2:	68 18 8b 10 80       	push   $0x80108b18
80105dc7:	e8 c4 a5 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105dcc:	83 ec 0c             	sub    $0xc,%esp
80105dcf:	68 06 8b 10 80       	push   $0x80108b06
80105dd4:	e8 b7 a5 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	68 2a 8b 10 80       	push   $0x80108b2a
80105de1:	e8 aa a5 ff ff       	call   80100390 <panic>
80105de6:	8d 76 00             	lea    0x0(%esi),%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105df0 <sys_open>:

int
sys_open(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[14] ++;
80105df9:	e8 c2 dc ff ff       	call   80103ac0 <myproc>
80105dfe:	83 80 b4 00 00 00 01 	addl   $0x1,0xb4(%eax)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e05:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e08:	83 ec 08             	sub    $0x8,%esp
80105e0b:	50                   	push   %eax
80105e0c:	6a 00                	push   $0x0
80105e0e:	e8 fd f7 ff ff       	call   80105610 <argstr>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	0f 88 1e 01 00 00    	js     80105f3c <sys_open+0x14c>
80105e1e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e21:	83 ec 08             	sub    $0x8,%esp
80105e24:	50                   	push   %eax
80105e25:	6a 01                	push   $0x1
80105e27:	e8 34 f7 ff ff       	call   80105560 <argint>
80105e2c:	83 c4 10             	add    $0x10,%esp
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	0f 88 05 01 00 00    	js     80105f3c <sys_open+0x14c>
    return -1;

  begin_op();
80105e37:	e8 54 cf ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
80105e3c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e40:	0f 85 aa 00 00 00    	jne    80105ef0 <sys_open+0x100>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e46:	83 ec 0c             	sub    $0xc,%esp
80105e49:	ff 75 e0             	pushl  -0x20(%ebp)
80105e4c:	e8 7f c2 ff ff       	call   801020d0 <namei>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	85 c0                	test   %eax,%eax
80105e56:	89 c6                	mov    %eax,%esi
80105e58:	0f 84 b3 00 00 00    	je     80105f11 <sys_open+0x121>
      end_op();
      return -1;
    }
    ilock(ip);
80105e5e:	83 ec 0c             	sub    $0xc,%esp
80105e61:	50                   	push   %eax
80105e62:	e8 09 ba ff ff       	call   80101870 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e6f:	0f 84 ab 00 00 00    	je     80105f20 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e75:	e8 f6 b0 ff ff       	call   80100f70 <filealloc>
80105e7a:	85 c0                	test   %eax,%eax
80105e7c:	89 c7                	mov    %eax,%edi
80105e7e:	0f 84 a7 00 00 00    	je     80105f2b <sys_open+0x13b>
  struct proc *curproc = myproc();
80105e84:	e8 37 dc ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e89:	31 db                	xor    %ebx,%ebx
80105e8b:	eb 0f                	jmp    80105e9c <sys_open+0xac>
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi
80105e90:	83 c3 01             	add    $0x1,%ebx
80105e93:	83 fb 10             	cmp    $0x10,%ebx
80105e96:	0f 84 ac 00 00 00    	je     80105f48 <sys_open+0x158>
    if(curproc->ofile[fd] == 0){
80105e9c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ea0:	85 d2                	test   %edx,%edx
80105ea2:	75 ec                	jne    80105e90 <sys_open+0xa0>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ea4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ea7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105eab:	56                   	push   %esi
80105eac:	e8 9f ba ff ff       	call   80101950 <iunlock>
  end_op();
80105eb1:	e8 4a cf ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
80105eb6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ebc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ebf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ec2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105ec5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ecc:	89 d0                	mov    %edx,%eax
80105ece:	f7 d0                	not    %eax
80105ed0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ed3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ed6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ed9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee0:	89 d8                	mov    %ebx,%eax
80105ee2:	5b                   	pop    %ebx
80105ee3:	5e                   	pop    %esi
80105ee4:	5f                   	pop    %edi
80105ee5:	5d                   	pop    %ebp
80105ee6:	c3                   	ret    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ef6:	31 c9                	xor    %ecx,%ecx
80105ef8:	6a 00                	push   $0x0
80105efa:	ba 02 00 00 00       	mov    $0x2,%edx
80105eff:	e8 ac f7 ff ff       	call   801056b0 <create>
    if(ip == 0){
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105f09:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105f0b:	0f 85 64 ff ff ff    	jne    80105e75 <sys_open+0x85>
      end_op();
80105f11:	e8 ea ce ff ff       	call   80102e00 <end_op>
      return -1;
80105f16:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f1b:	eb c0                	jmp    80105edd <sys_open+0xed>
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105f23:	85 c9                	test   %ecx,%ecx
80105f25:	0f 84 4a ff ff ff    	je     80105e75 <sys_open+0x85>
    iunlockput(ip);
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	56                   	push   %esi
80105f2f:	e8 cc bb ff ff       	call   80101b00 <iunlockput>
    end_op();
80105f34:	e8 c7 ce ff ff       	call   80102e00 <end_op>
    return -1;
80105f39:	83 c4 10             	add    $0x10,%esp
80105f3c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f41:	eb 9a                	jmp    80105edd <sys_open+0xed>
80105f43:	90                   	nop
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	57                   	push   %edi
80105f4c:	e8 df b0 ff ff       	call   80101030 <fileclose>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	eb d5                	jmp    80105f2b <sys_open+0x13b>
80105f56:	8d 76 00             	lea    0x0(%esi),%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[19] ++;
80105f66:	e8 55 db ff ff       	call   80103ac0 <myproc>
80105f6b:	83 80 c8 00 00 00 01 	addl   $0x1,0xc8(%eax)
  char *path;
  struct inode *ip;

  begin_op();
80105f72:	e8 19 ce ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7a:	83 ec 08             	sub    $0x8,%esp
80105f7d:	50                   	push   %eax
80105f7e:	6a 00                	push   $0x0
80105f80:	e8 8b f6 ff ff       	call   80105610 <argstr>
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	78 34                	js     80105fc0 <sys_mkdir+0x60>
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f92:	31 c9                	xor    %ecx,%ecx
80105f94:	6a 00                	push   $0x0
80105f96:	ba 01 00 00 00       	mov    $0x1,%edx
80105f9b:	e8 10 f7 ff ff       	call   801056b0 <create>
80105fa0:	83 c4 10             	add    $0x10,%esp
80105fa3:	85 c0                	test   %eax,%eax
80105fa5:	74 19                	je     80105fc0 <sys_mkdir+0x60>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105fa7:	83 ec 0c             	sub    $0xc,%esp
80105faa:	50                   	push   %eax
80105fab:	e8 50 bb ff ff       	call   80101b00 <iunlockput>
  end_op();
80105fb0:	e8 4b ce ff ff       	call   80102e00 <end_op>
  return 0;
80105fb5:	83 c4 10             	add    $0x10,%esp
80105fb8:	31 c0                	xor    %eax,%eax
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105fc0:	e8 3b ce ff ff       	call   80102e00 <end_op>
    return -1;
80105fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fca:	c9                   	leave  
80105fcb:	c3                   	ret    
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_mknod>:

int
sys_mknod(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[16] ++;
80105fd6:	e8 e5 da ff ff       	call   80103ac0 <myproc>
80105fdb:	83 80 bc 00 00 00 01 	addl   $0x1,0xbc(%eax)
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105fe2:	e8 a9 cd ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105fe7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fea:	83 ec 08             	sub    $0x8,%esp
80105fed:	50                   	push   %eax
80105fee:	6a 00                	push   $0x0
80105ff0:	e8 1b f6 ff ff       	call   80105610 <argstr>
80105ff5:	83 c4 10             	add    $0x10,%esp
80105ff8:	85 c0                	test   %eax,%eax
80105ffa:	78 64                	js     80106060 <sys_mknod+0x90>
     argint(1, &major) < 0 ||
80105ffc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fff:	83 ec 08             	sub    $0x8,%esp
80106002:	50                   	push   %eax
80106003:	6a 01                	push   $0x1
80106005:	e8 56 f5 ff ff       	call   80105560 <argint>
  if((argstr(0, &path)) < 0 ||
8010600a:	83 c4 10             	add    $0x10,%esp
8010600d:	85 c0                	test   %eax,%eax
8010600f:	78 4f                	js     80106060 <sys_mknod+0x90>
     argint(2, &minor) < 0 ||
80106011:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106014:	83 ec 08             	sub    $0x8,%esp
80106017:	50                   	push   %eax
80106018:	6a 02                	push   $0x2
8010601a:	e8 41 f5 ff ff       	call   80105560 <argint>
     argint(1, &major) < 0 ||
8010601f:	83 c4 10             	add    $0x10,%esp
80106022:	85 c0                	test   %eax,%eax
80106024:	78 3a                	js     80106060 <sys_mknod+0x90>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106026:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010602a:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
8010602d:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106031:	ba 03 00 00 00       	mov    $0x3,%edx
80106036:	50                   	push   %eax
80106037:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010603a:	e8 71 f6 ff ff       	call   801056b0 <create>
8010603f:	83 c4 10             	add    $0x10,%esp
80106042:	85 c0                	test   %eax,%eax
80106044:	74 1a                	je     80106060 <sys_mknod+0x90>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106046:	83 ec 0c             	sub    $0xc,%esp
80106049:	50                   	push   %eax
8010604a:	e8 b1 ba ff ff       	call   80101b00 <iunlockput>
  end_op();
8010604f:	e8 ac cd ff ff       	call   80102e00 <end_op>
  return 0;
80106054:	83 c4 10             	add    $0x10,%esp
80106057:	31 c0                	xor    %eax,%eax
}
80106059:	c9                   	leave  
8010605a:	c3                   	ret    
8010605b:	90                   	nop
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106060:	e8 9b cd ff ff       	call   80102e00 <end_op>
    return -1;
80106065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010606a:	c9                   	leave  
8010606b:	c3                   	ret    
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_chdir>:

int
sys_chdir(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	56                   	push   %esi
80106074:	53                   	push   %ebx
80106075:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[8] ++;
80106078:	e8 43 da ff ff       	call   80103ac0 <myproc>
8010607d:	83 80 9c 00 00 00 01 	addl   $0x1,0x9c(%eax)
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106084:	e8 37 da ff ff       	call   80103ac0 <myproc>
80106089:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010608b:	e8 00 cd ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106090:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106093:	83 ec 08             	sub    $0x8,%esp
80106096:	50                   	push   %eax
80106097:	6a 00                	push   $0x0
80106099:	e8 72 f5 ff ff       	call   80105610 <argstr>
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	85 c0                	test   %eax,%eax
801060a3:	78 6b                	js     80106110 <sys_chdir+0xa0>
801060a5:	83 ec 0c             	sub    $0xc,%esp
801060a8:	ff 75 f4             	pushl  -0xc(%ebp)
801060ab:	e8 20 c0 ff ff       	call   801020d0 <namei>
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	85 c0                	test   %eax,%eax
801060b5:	89 c3                	mov    %eax,%ebx
801060b7:	74 57                	je     80106110 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801060b9:	83 ec 0c             	sub    $0xc,%esp
801060bc:	50                   	push   %eax
801060bd:	e8 ae b7 ff ff       	call   80101870 <ilock>
  if(ip->type != T_DIR){
801060c2:	83 c4 10             	add    $0x10,%esp
801060c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060ca:	75 2c                	jne    801060f8 <sys_chdir+0x88>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801060cc:	83 ec 0c             	sub    $0xc,%esp
801060cf:	53                   	push   %ebx
801060d0:	e8 7b b8 ff ff       	call   80101950 <iunlock>
  iput(curproc->cwd);
801060d5:	58                   	pop    %eax
801060d6:	ff 76 68             	pushl  0x68(%esi)
801060d9:	e8 c2 b8 ff ff       	call   801019a0 <iput>
  end_op();
801060de:	e8 1d cd ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
801060e3:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801060e6:	83 c4 10             	add    $0x10,%esp
801060e9:	31 c0                	xor    %eax,%eax
}
801060eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060ee:	5b                   	pop    %ebx
801060ef:	5e                   	pop    %esi
801060f0:	5d                   	pop    %ebp
801060f1:	c3                   	ret    
801060f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801060f8:	83 ec 0c             	sub    $0xc,%esp
801060fb:	53                   	push   %ebx
801060fc:	e8 ff b9 ff ff       	call   80101b00 <iunlockput>
    end_op();
80106101:	e8 fa cc ff ff       	call   80102e00 <end_op>
    return -1;
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610e:	eb db                	jmp    801060eb <sys_chdir+0x7b>
    end_op();
80106110:	e8 eb cc ff ff       	call   80102e00 <end_op>
    return -1;
80106115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611a:	eb cf                	jmp    801060eb <sys_chdir+0x7b>
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106120 <rand>:
int rand(int m){
80106120:	55                   	push   %ebp
 int random;
 int a = ticks % m;
80106121:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80106126:	31 d2                	xor    %edx,%edx
int rand(int m){
80106128:	89 e5                	mov    %esp,%ebp
8010612a:	53                   	push   %ebx
8010612b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
8010612e:	f7 f1                	div    %ecx
 int seed = ticks % m;
 random = (a * seed )% m;
80106130:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80106132:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80106134:	0f af c2             	imul   %edx,%eax
80106137:	99                   	cltd   
80106138:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
8010613a:	89 d0                	mov    %edx,%eax
8010613c:	0f af c3             	imul   %ebx,%eax
 return random; 
}
8010613f:	5b                   	pop    %ebx
80106140:	5d                   	pop    %ebp
 random = (a * random )% m;
80106141:	99                   	cltd   
80106142:	f7 f9                	idiv   %ecx
}
80106144:	89 d0                	mov    %edx,%eax
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106150 <sys_exec>:
int
sys_exec(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	57                   	push   %edi
80106154:	56                   	push   %esi
80106155:	53                   	push   %ebx
80106156:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  myproc()->call_nums[6] ++;
8010615c:	e8 5f d9 ff ff       	call   80103ac0 <myproc>
80106161:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
  // myproc()->exect_ratio = rand(50) / 1000;
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106168:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
8010616e:	83 ec 08             	sub    $0x8,%esp
80106171:	50                   	push   %eax
80106172:	6a 00                	push   $0x0
80106174:	e8 97 f4 ff ff       	call   80105610 <argstr>
80106179:	83 c4 10             	add    $0x10,%esp
8010617c:	85 c0                	test   %eax,%eax
8010617e:	0f 88 88 00 00 00    	js     8010620c <sys_exec+0xbc>
80106184:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010618a:	83 ec 08             	sub    $0x8,%esp
8010618d:	50                   	push   %eax
8010618e:	6a 01                	push   $0x1
80106190:	e8 cb f3 ff ff       	call   80105560 <argint>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	85 c0                	test   %eax,%eax
8010619a:	78 70                	js     8010620c <sys_exec+0xbc>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010619c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061a2:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801061a5:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061a7:	68 80 00 00 00       	push   $0x80
801061ac:	6a 00                	push   $0x0
801061ae:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801061b4:	50                   	push   %eax
801061b5:	e8 a6 f0 ff ff       	call   80105260 <memset>
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	eb 2d                	jmp    801061ec <sys_exec+0x9c>
801061bf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801061c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801061c6:	85 c0                	test   %eax,%eax
801061c8:	74 56                	je     80106220 <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801061ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801061d6:	52                   	push   %edx
801061d7:	50                   	push   %eax
801061d8:	e8 13 f3 ff ff       	call   801054f0 <fetchstr>
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	85 c0                	test   %eax,%eax
801061e2:	78 28                	js     8010620c <sys_exec+0xbc>
  for(i=0;; i++){
801061e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801061e7:	83 fb 20             	cmp    $0x20,%ebx
801061ea:	74 20                	je     8010620c <sys_exec+0xbc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801061ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801061f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801061f9:	83 ec 08             	sub    $0x8,%esp
801061fc:	57                   	push   %edi
801061fd:	01 f0                	add    %esi,%eax
801061ff:	50                   	push   %eax
80106200:	e8 ab f2 ff ff       	call   801054b0 <fetchint>
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	85 c0                	test   %eax,%eax
8010620a:	79 b4                	jns    801061c0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010620c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010620f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106214:	5b                   	pop    %ebx
80106215:	5e                   	pop    %esi
80106216:	5f                   	pop    %edi
80106217:	5d                   	pop    %ebp
80106218:	c3                   	ret    
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106220:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106226:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106229:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106230:	00 00 00 00 
  return exec(path, argv);
80106234:	50                   	push   %eax
80106235:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010623b:	e8 a0 a9 ff ff       	call   80100be0 <exec>
80106240:	83 c4 10             	add    $0x10,%esp
}
80106243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106246:	5b                   	pop    %ebx
80106247:	5e                   	pop    %esi
80106248:	5f                   	pop    %edi
80106249:	5d                   	pop    %ebp
8010624a:	c3                   	ret    
8010624b:	90                   	nop
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106250 <sys_pipe>:

int
sys_pipe(void)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
80106255:	53                   	push   %ebx
80106256:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[3] ++;
80106259:	e8 62 d8 ff ff       	call   80103ac0 <myproc>
8010625e:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106265:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106268:	83 ec 04             	sub    $0x4,%esp
8010626b:	6a 08                	push   $0x8
8010626d:	50                   	push   %eax
8010626e:	6a 00                	push   $0x0
80106270:	e8 3b f3 ff ff       	call   801055b0 <argptr>
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	85 c0                	test   %eax,%eax
8010627a:	0f 88 af 00 00 00    	js     8010632f <sys_pipe+0xdf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106280:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106283:	83 ec 08             	sub    $0x8,%esp
80106286:	50                   	push   %eax
80106287:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010628a:	50                   	push   %eax
8010628b:	e8 a0 d1 ff ff       	call   80103430 <pipealloc>
80106290:	83 c4 10             	add    $0x10,%esp
80106293:	85 c0                	test   %eax,%eax
80106295:	0f 88 94 00 00 00    	js     8010632f <sys_pipe+0xdf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010629b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010629e:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801062a0:	e8 1b d8 ff ff       	call   80103ac0 <myproc>
801062a5:	eb 11                	jmp    801062b8 <sys_pipe+0x68>
801062a7:	89 f6                	mov    %esi,%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(fd = 0; fd < NOFILE; fd++){
801062b0:	83 c3 01             	add    $0x1,%ebx
801062b3:	83 fb 10             	cmp    $0x10,%ebx
801062b6:	74 60                	je     80106318 <sys_pipe+0xc8>
    if(curproc->ofile[fd] == 0){
801062b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801062bc:	85 f6                	test   %esi,%esi
801062be:	75 f0                	jne    801062b0 <sys_pipe+0x60>
      curproc->ofile[fd] = f;
801062c0:	8d 73 08             	lea    0x8(%ebx),%esi
801062c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801062ca:	e8 f1 d7 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801062cf:	31 d2                	xor    %edx,%edx
801062d1:	eb 0d                	jmp    801062e0 <sys_pipe+0x90>
801062d3:	90                   	nop
801062d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062d8:	83 c2 01             	add    $0x1,%edx
801062db:	83 fa 10             	cmp    $0x10,%edx
801062de:	74 28                	je     80106308 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801062e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801062e4:	85 c9                	test   %ecx,%ecx
801062e6:	75 f0                	jne    801062d8 <sys_pipe+0x88>
      curproc->ofile[fd] = f;
801062e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801062ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801062f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801062f7:	31 c0                	xor    %eax,%eax
}
801062f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062fc:	5b                   	pop    %ebx
801062fd:	5e                   	pop    %esi
801062fe:	5f                   	pop    %edi
801062ff:	5d                   	pop    %ebp
80106300:	c3                   	ret    
80106301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106308:	e8 b3 d7 ff ff       	call   80103ac0 <myproc>
8010630d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106314:	00 
80106315:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106318:	83 ec 0c             	sub    $0xc,%esp
8010631b:	ff 75 e0             	pushl  -0x20(%ebp)
8010631e:	e8 0d ad ff ff       	call   80101030 <fileclose>
    fileclose(wf);
80106323:	58                   	pop    %eax
80106324:	ff 75 e4             	pushl  -0x1c(%ebp)
80106327:	e8 04 ad ff ff       	call   80101030 <fileclose>
    return -1;
8010632c:	83 c4 10             	add    $0x10,%esp
8010632f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106334:	eb c3                	jmp    801062f9 <sys_pipe+0xa9>
80106336:	66 90                	xchg   %ax,%ax
80106338:	66 90                	xchg   %ax,%ax
8010633a:	66 90                	xchg   %ax,%ax
8010633c:	66 90                	xchg   %ax,%ax
8010633e:	66 90                	xchg   %ax,%ax

80106340 <gen_rand>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int gen_rand(int m){
80106340:	55                   	push   %ebp
 int random;
 int a = ticks % m;
80106341:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80106346:	31 d2                	xor    %edx,%edx
int gen_rand(int m){
80106348:	89 e5                	mov    %esp,%ebp
8010634a:	53                   	push   %ebx
8010634b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
8010634e:	f7 f1                	div    %ecx
 int seed = ticks % m;
 random = (a * seed )% m;
80106350:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80106352:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80106354:	0f af c2             	imul   %edx,%eax
80106357:	99                   	cltd   
80106358:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
8010635a:	89 d0                	mov    %edx,%eax
8010635c:	0f af c3             	imul   %ebx,%eax
 return random; 
}
8010635f:	5b                   	pop    %ebx
80106360:	5d                   	pop    %ebp
 random = (a * random )% m;
80106361:	99                   	cltd   
80106362:	f7 f9                	idiv   %ecx
}
80106364:	89 d0                	mov    %edx,%eax
80106366:	c3                   	ret    
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <sys_fork>:

int
sys_fork(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[0] ++;
80106376:	e8 45 d7 ff ff       	call   80103ac0 <myproc>
8010637b:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
  // myproc()->exect_ratio = gen_rand(50) / 100;
 


  return fork();
}
8010637f:	c9                   	leave  
  return fork();
80106380:	e9 db d8 ff ff       	jmp    80103c60 <fork>
80106385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106390 <sys_exit>:

int
sys_exit(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[1] ++;
80106396:	e8 25 d7 ff ff       	call   80103ac0 <myproc>
8010639b:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
  exit();
801063a2:	e8 c9 df ff ff       	call   80104370 <exit>
  return 0;  // not reached
}
801063a7:	31 c0                	xor    %eax,%eax
801063a9:	c9                   	leave  
801063aa:	c3                   	ret    
801063ab:	90                   	nop
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063b0 <sys_wait>:

int
sys_wait(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[2] ++;
801063b6:	e8 05 d7 ff ff       	call   80103ac0 <myproc>
801063bb:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  return wait();
}
801063c2:	c9                   	leave  
  return wait();
801063c3:	e9 e8 e1 ff ff       	jmp    801045b0 <wait>
801063c8:	90                   	nop
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063d0 <sys_kill>:

int
sys_kill(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  myproc()->call_nums[5] ++;
801063d6:	e8 e5 d6 ff ff       	call   80103ac0 <myproc>
801063db:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)

  if(argint(0, &pid) < 0)
801063e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063e5:	83 ec 08             	sub    $0x8,%esp
801063e8:	50                   	push   %eax
801063e9:	6a 00                	push   $0x0
801063eb:	e8 70 f1 ff ff       	call   80105560 <argint>
801063f0:	83 c4 10             	add    $0x10,%esp
801063f3:	85 c0                	test   %eax,%eax
801063f5:	78 19                	js     80106410 <sys_kill+0x40>
    return -1;
  return kill(pid);
801063f7:	83 ec 0c             	sub    $0xc,%esp
801063fa:	ff 75 f4             	pushl  -0xc(%ebp)
801063fd:	e8 0e e3 ff ff       	call   80104710 <kill>
80106402:	83 c4 10             	add    $0x10,%esp
}
80106405:	c9                   	leave  
80106406:	c3                   	ret    
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106415:	c9                   	leave  
80106416:	c3                   	ret    
80106417:	89 f6                	mov    %esi,%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106420 <sys_getpid>:

int
sys_getpid(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 08             	sub    $0x8,%esp
  
  myproc()->call_nums[10] ++;
80106426:	e8 95 d6 ff ff       	call   80103ac0 <myproc>
8010642b:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
  return myproc()->pid;
80106432:	e8 89 d6 ff ff       	call   80103ac0 <myproc>
80106437:	8b 40 10             	mov    0x10(%eax),%eax
}
8010643a:	c9                   	leave  
8010643b:	c3                   	ret    
8010643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106440 <sys_sbrk>:

int
sys_sbrk(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	53                   	push   %ebx
80106444:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[11] ++;
80106447:	e8 74 d6 ff ff       	call   80103ac0 <myproc>
8010644c:	83 80 a8 00 00 00 01 	addl   $0x1,0xa8(%eax)
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106453:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106456:	83 ec 08             	sub    $0x8,%esp
80106459:	50                   	push   %eax
8010645a:	6a 00                	push   $0x0
8010645c:	e8 ff f0 ff ff       	call   80105560 <argint>
80106461:	83 c4 10             	add    $0x10,%esp
80106464:	85 c0                	test   %eax,%eax
80106466:	78 28                	js     80106490 <sys_sbrk+0x50>
    return -1;
  addr = myproc()->sz;
80106468:	e8 53 d6 ff ff       	call   80103ac0 <myproc>
  if(growproc(n) < 0)
8010646d:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106470:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106472:	ff 75 f4             	pushl  -0xc(%ebp)
80106475:	e8 66 d7 ff ff       	call   80103be0 <growproc>
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	85 c0                	test   %eax,%eax
8010647f:	78 0f                	js     80106490 <sys_sbrk+0x50>
    return -1;
  return addr;
}
80106481:	89 d8                	mov    %ebx,%eax
80106483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106486:	c9                   	leave  
80106487:	c3                   	ret    
80106488:	90                   	nop
80106489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106490:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106495:	eb ea                	jmp    80106481 <sys_sbrk+0x41>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <sys_sleep>:

int
sys_sleep(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	53                   	push   %ebx
801064a4:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[12] ++;
801064a7:	e8 14 d6 ff ff       	call   80103ac0 <myproc>
801064ac:	83 80 ac 00 00 00 01 	addl   $0x1,0xac(%eax)
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801064b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064b6:	83 ec 08             	sub    $0x8,%esp
801064b9:	50                   	push   %eax
801064ba:	6a 00                	push   $0x0
801064bc:	e8 9f f0 ff ff       	call   80105560 <argint>
801064c1:	83 c4 10             	add    $0x10,%esp
801064c4:	85 c0                	test   %eax,%eax
801064c6:	0f 88 8b 00 00 00    	js     80106557 <sys_sleep+0xb7>
    return -1;
  acquire(&tickslock);
801064cc:	83 ec 0c             	sub    $0xc,%esp
801064cf:	68 00 86 11 80       	push   $0x80118600
801064d4:	e8 77 ec ff ff       	call   80105150 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064dc:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064df:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  while(ticks - ticks0 < n){
801064e5:	85 d2                	test   %edx,%edx
801064e7:	75 28                	jne    80106511 <sys_sleep+0x71>
801064e9:	eb 55                	jmp    80106540 <sys_sleep+0xa0>
801064eb:	90                   	nop
801064ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064f0:	83 ec 08             	sub    $0x8,%esp
801064f3:	68 00 86 11 80       	push   $0x80118600
801064f8:	68 40 8e 11 80       	push   $0x80118e40
801064fd:	e8 ee df ff ff       	call   801044f0 <sleep>
  while(ticks - ticks0 < n){
80106502:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80106507:	83 c4 10             	add    $0x10,%esp
8010650a:	29 d8                	sub    %ebx,%eax
8010650c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010650f:	73 2f                	jae    80106540 <sys_sleep+0xa0>
    if(myproc()->killed){
80106511:	e8 aa d5 ff ff       	call   80103ac0 <myproc>
80106516:	8b 40 24             	mov    0x24(%eax),%eax
80106519:	85 c0                	test   %eax,%eax
8010651b:	74 d3                	je     801064f0 <sys_sleep+0x50>
      release(&tickslock);
8010651d:	83 ec 0c             	sub    $0xc,%esp
80106520:	68 00 86 11 80       	push   $0x80118600
80106525:	e8 e6 ec ff ff       	call   80105210 <release>
      return -1;
8010652a:	83 c4 10             	add    $0x10,%esp
8010652d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106535:	c9                   	leave  
80106536:	c3                   	ret    
80106537:	89 f6                	mov    %esi,%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	68 00 86 11 80       	push   $0x80118600
80106548:	e8 c3 ec ff ff       	call   80105210 <release>
  return 0;
8010654d:	83 c4 10             	add    $0x10,%esp
80106550:	31 c0                	xor    %eax,%eax
}
80106552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106555:	c9                   	leave  
80106556:	c3                   	ret    
    return -1;
80106557:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655c:	eb f4                	jmp    80106552 <sys_sleep+0xb2>
8010655e:	66 90                	xchg   %ax,%ax

80106560 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	53                   	push   %ebx
80106564:	83 ec 04             	sub    $0x4,%esp
  myproc()->call_nums[13] ++;
80106567:	e8 54 d5 ff ff       	call   80103ac0 <myproc>
8010656c:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
  uint xticks;

  acquire(&tickslock);
80106573:	83 ec 0c             	sub    $0xc,%esp
80106576:	68 00 86 11 80       	push   $0x80118600
8010657b:	e8 d0 eb ff ff       	call   80105150 <acquire>
  xticks = ticks;
80106580:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  release(&tickslock);
80106586:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
8010658d:	e8 7e ec ff ff       	call   80105210 <release>
  return xticks;
}
80106592:	89 d8                	mov    %ebx,%eax
80106594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106597:	c9                   	leave  
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_trace_syscalls>:

int sys_trace_syscalls(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	53                   	push   %ebx
801065a4:	83 ec 14             	sub    $0x14,%esp
  int n;
  myproc()->call_nums[21] ++;
801065a7:	e8 14 d5 ff ff       	call   80103ac0 <myproc>
801065ac:	83 80 d0 00 00 00 01 	addl   $0x1,0xd0(%eax)
  if(argint(0, &n) == 0){
801065b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b6:	83 ec 08             	sub    $0x8,%esp
801065b9:	50                   	push   %eax
801065ba:	6a 00                	push   $0x0
801065bc:	e8 9f ef ff ff       	call   80105560 <argint>
801065c1:	83 c4 10             	add    $0x10,%esp
801065c4:	85 c0                	test   %eax,%eax
801065c6:	75 50                	jne    80106618 <sys_trace_syscalls+0x78>
801065c8:	89 c3                	mov    %eax,%ebx
    if(myproc()->pid == 2){
801065ca:	e8 f1 d4 ff ff       	call   80103ac0 <myproc>
801065cf:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801065d3:	74 2b                	je     80106600 <sys_trace_syscalls+0x60>
      trace_syscalls(2);
      return 0;
    }
    else if (n==1 || n== 0) {
801065d5:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801065d9:	77 3d                	ja     80106618 <sys_trace_syscalls+0x78>
      myproc()-> print_state = n;
801065db:	e8 e0 d4 ff ff       	call   80103ac0 <myproc>
801065e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
      trace_syscalls(n);
801065e3:	83 ec 0c             	sub    $0xc,%esp
      myproc()-> print_state = n;
801065e6:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
      trace_syscalls(n);
801065ec:	52                   	push   %edx
801065ed:	e8 be e4 ff ff       	call   80104ab0 <trace_syscalls>
      return 0;
801065f2:	83 c4 10             	add    $0x10,%esp
    else
      return -1;
  }
  else
    return -1;
}
801065f5:	89 d8                	mov    %ebx,%eax
801065f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065fa:	c9                   	leave  
801065fb:	c3                   	ret    
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      trace_syscalls(2);
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	6a 02                	push   $0x2
80106605:	e8 a6 e4 ff ff       	call   80104ab0 <trace_syscalls>
}
8010660a:	89 d8                	mov    %ebx,%eax
      return 0;
8010660c:	83 c4 10             	add    $0x10,%esp
}
8010660f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106612:	c9                   	leave  
80106613:	c3                   	ret    
80106614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106618:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010661d:	eb d6                	jmp    801065f5 <sys_trace_syscalls+0x55>
8010661f:	90                   	nop

80106620 <sys_reverse_number>:

int sys_reverse_number(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[22] ++;
80106626:	e8 95 d4 ff ff       	call   80103ac0 <myproc>
8010662b:	83 80 d4 00 00 00 01 	addl   $0x1,0xd4(%eax)
  int n;
  asm("movl %%edi, %0;" : "=r"(n)); 
  reverse_number(n);
80106632:	83 ec 0c             	sub    $0xc,%esp
  asm("movl %%edi, %0;" : "=r"(n)); 
80106635:	89 f8                	mov    %edi,%eax
  reverse_number(n);
80106637:	50                   	push   %eax
80106638:	e8 33 e5 ff ff       	call   80104b70 <reverse_number>

  return 0;
}
8010663d:	31 c0                	xor    %eax,%eax
8010663f:	c9                   	leave  
80106640:	c3                   	ret    
80106641:	eb 0d                	jmp    80106650 <sys_get_children>
80106643:	90                   	nop
80106644:	90                   	nop
80106645:	90                   	nop
80106646:	90                   	nop
80106647:	90                   	nop
80106648:	90                   	nop
80106649:	90                   	nop
8010664a:	90                   	nop
8010664b:	90                   	nop
8010664c:	90                   	nop
8010664d:	90                   	nop
8010664e:	90                   	nop
8010664f:	90                   	nop

80106650 <sys_get_children>:

int
sys_get_children(void){
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[23] ++;
80106656:	e8 65 d4 ff ff       	call   80103ac0 <myproc>
8010665b:	83 80 d8 00 00 00 01 	addl   $0x1,0xd8(%eax)
  int pid;
  if(argint(0, &pid) < 0)
80106662:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106665:	83 ec 08             	sub    $0x8,%esp
80106668:	50                   	push   %eax
80106669:	6a 00                	push   $0x0
8010666b:	e8 f0 ee ff ff       	call   80105560 <argint>
80106670:	83 c4 10             	add    $0x10,%esp
80106673:	85 c0                	test   %eax,%eax
80106675:	78 19                	js     80106690 <sys_get_children+0x40>
    return -1;
  return children(pid);
80106677:	83 ec 0c             	sub    $0xc,%esp
8010667a:	ff 75 f4             	pushl  -0xc(%ebp)
8010667d:	e8 9e e5 ff ff       	call   80104c20 <children>
80106682:	83 c4 10             	add    $0x10,%esp
}
80106685:	c9                   	leave  
80106686:	c3                   	ret    
80106687:	89 f6                	mov    %esi,%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106695:	c9                   	leave  
80106696:	c3                   	ret    
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <sys_change_process_queue>:

int sys_change_process_queue(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[24] ++;
801066a6:	e8 15 d4 ff ff       	call   80103ac0 <myproc>
801066ab:	83 80 dc 00 00 00 01 	addl   $0x1,0xdc(%eax)
  int pid, dest_queue;

  if(argint(0, &pid) < 0)
801066b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066b5:	83 ec 08             	sub    $0x8,%esp
801066b8:	50                   	push   %eax
801066b9:	6a 00                	push   $0x0
801066bb:	e8 a0 ee ff ff       	call   80105560 <argint>
801066c0:	83 c4 10             	add    $0x10,%esp
801066c3:	85 c0                	test   %eax,%eax
801066c5:	78 31                	js     801066f8 <sys_change_process_queue+0x58>
    return -1;
  if(argint(1, &dest_queue) < 0)
801066c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066ca:	83 ec 08             	sub    $0x8,%esp
801066cd:	50                   	push   %eax
801066ce:	6a 01                	push   $0x1
801066d0:	e8 8b ee ff ff       	call   80105560 <argint>
801066d5:	83 c4 10             	add    $0x10,%esp
801066d8:	85 c0                	test   %eax,%eax
801066da:	78 1c                	js     801066f8 <sys_change_process_queue+0x58>
    return -1;

  change_process_queue(pid, dest_queue);
801066dc:	83 ec 08             	sub    $0x8,%esp
801066df:	ff 75 f4             	pushl  -0xc(%ebp)
801066e2:	ff 75 f0             	pushl  -0x10(%ebp)
801066e5:	e8 26 e6 ff ff       	call   80104d10 <change_process_queue>
  return 0;
801066ea:	83 c4 10             	add    $0x10,%esp
801066ed:	31 c0                	xor    %eax,%eax
}
801066ef:	c9                   	leave  
801066f0:	c3                   	ret    
801066f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066fd:	c9                   	leave  
801066fe:	c3                   	ret    
801066ff:	90                   	nop

80106700 <sys_quantify_lottery_tickets>:

int sys_quantify_lottery_tickets(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[25] ++;
80106706:	e8 b5 d3 ff ff       	call   80103ac0 <myproc>
8010670b:	83 80 e0 00 00 00 01 	addl   $0x1,0xe0(%eax)
  int pid, ticket;

  if(argint(0, &pid) < 0)
80106712:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106715:	83 ec 08             	sub    $0x8,%esp
80106718:	50                   	push   %eax
80106719:	6a 00                	push   $0x0
8010671b:	e8 40 ee ff ff       	call   80105560 <argint>
80106720:	83 c4 10             	add    $0x10,%esp
80106723:	85 c0                	test   %eax,%eax
80106725:	78 31                	js     80106758 <sys_quantify_lottery_tickets+0x58>
    return -1;
  if(argint(1, &ticket) < 0)
80106727:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010672a:	83 ec 08             	sub    $0x8,%esp
8010672d:	50                   	push   %eax
8010672e:	6a 01                	push   $0x1
80106730:	e8 2b ee ff ff       	call   80105560 <argint>
80106735:	83 c4 10             	add    $0x10,%esp
80106738:	85 c0                	test   %eax,%eax
8010673a:	78 1c                	js     80106758 <sys_quantify_lottery_tickets+0x58>
    return -1;

  quantify_lottery_tickets(pid, ticket);
8010673c:	83 ec 08             	sub    $0x8,%esp
8010673f:	ff 75 f4             	pushl  -0xc(%ebp)
80106742:	ff 75 f0             	pushl  -0x10(%ebp)
80106745:	e8 f6 e5 ff ff       	call   80104d40 <quantify_lottery_tickets>
  return 0;
8010674a:	83 c4 10             	add    $0x10,%esp
8010674d:	31 c0                	xor    %eax,%eax
}
8010674f:	c9                   	leave  
80106750:	c3                   	ret    
80106751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010675d:	c9                   	leave  
8010675e:	c3                   	ret    
8010675f:	90                   	nop

80106760 <sys_quantify_BJF_parameters_process_level>:

int sys_quantify_BJF_parameters_process_level(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[26] ++;
80106766:	e8 55 d3 ff ff       	call   80103ac0 <myproc>
8010676b:	83 80 e4 00 00 00 01 	addl   $0x1,0xe4(%eax)
  int pid, priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &pid) < 0)
80106772:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106775:	83 ec 08             	sub    $0x8,%esp
80106778:	50                   	push   %eax
80106779:	6a 00                	push   $0x0
8010677b:	e8 e0 ed ff ff       	call   80105560 <argint>
80106780:	83 c4 10             	add    $0x10,%esp
80106783:	85 c0                	test   %eax,%eax
80106785:	78 59                	js     801067e0 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(0, &priority_ratio) < 0)
80106787:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010678a:	83 ec 08             	sub    $0x8,%esp
8010678d:	50                   	push   %eax
8010678e:	6a 00                	push   $0x0
80106790:	e8 cb ed ff ff       	call   80105560 <argint>
80106795:	83 c4 10             	add    $0x10,%esp
80106798:	85 c0                	test   %eax,%eax
8010679a:	78 44                	js     801067e0 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
8010679c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010679f:	83 ec 08             	sub    $0x8,%esp
801067a2:	50                   	push   %eax
801067a3:	6a 01                	push   $0x1
801067a5:	e8 b6 ed ff ff       	call   80105560 <argint>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	85 c0                	test   %eax,%eax
801067af:	78 2f                	js     801067e0 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &exect_ratio) < 0)
801067b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067b4:	83 ec 08             	sub    $0x8,%esp
801067b7:	50                   	push   %eax
801067b8:	6a 01                	push   $0x1
801067ba:	e8 a1 ed ff ff       	call   80105560 <argint>
801067bf:	83 c4 10             	add    $0x10,%esp
801067c2:	85 c0                	test   %eax,%eax
801067c4:	78 1a                	js     801067e0 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;

  quantify_BJF_parameters_process_level(pid, priority_ratio, arrivt_ratio, exect_ratio);
801067c6:	ff 75 f4             	pushl  -0xc(%ebp)
801067c9:	ff 75 f0             	pushl  -0x10(%ebp)
801067cc:	ff 75 ec             	pushl  -0x14(%ebp)
801067cf:	ff 75 e8             	pushl  -0x18(%ebp)
801067d2:	e8 99 e5 ff ff       	call   80104d70 <quantify_BJF_parameters_process_level>
  return 0;
801067d7:	83 c4 10             	add    $0x10,%esp
801067da:	31 c0                	xor    %eax,%eax
}
801067dc:	c9                   	leave  
801067dd:	c3                   	ret    
801067de:	66 90                	xchg   %ax,%ax
    return -1;
801067e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067e5:	c9                   	leave  
801067e6:	c3                   	ret    
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067f0 <sys_quantify_BJF_parameters_kernel_level>:

int sys_quantify_BJF_parameters_kernel_level(void)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[27] ++;
801067f6:	e8 c5 d2 ff ff       	call   80103ac0 <myproc>
801067fb:	83 80 e8 00 00 00 01 	addl   $0x1,0xe8(%eax)
  int priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &priority_ratio) < 0)
80106802:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106805:	83 ec 08             	sub    $0x8,%esp
80106808:	50                   	push   %eax
80106809:	6a 00                	push   $0x0
8010680b:	e8 50 ed ff ff       	call   80105560 <argint>
80106810:	83 c4 10             	add    $0x10,%esp
80106813:	85 c0                	test   %eax,%eax
80106815:	78 49                	js     80106860 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
80106817:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010681a:	83 ec 08             	sub    $0x8,%esp
8010681d:	50                   	push   %eax
8010681e:	6a 01                	push   $0x1
80106820:	e8 3b ed ff ff       	call   80105560 <argint>
80106825:	83 c4 10             	add    $0x10,%esp
80106828:	85 c0                	test   %eax,%eax
8010682a:	78 34                	js     80106860 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &exect_ratio) < 0)
8010682c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010682f:	83 ec 08             	sub    $0x8,%esp
80106832:	50                   	push   %eax
80106833:	6a 01                	push   $0x1
80106835:	e8 26 ed ff ff       	call   80105560 <argint>
8010683a:	83 c4 10             	add    $0x10,%esp
8010683d:	85 c0                	test   %eax,%eax
8010683f:	78 1f                	js     80106860 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;

  quantify_BJF_parameters_kernel_level(priority_ratio, arrivt_ratio, exect_ratio);
80106841:	83 ec 04             	sub    $0x4,%esp
80106844:	ff 75 f4             	pushl  -0xc(%ebp)
80106847:	ff 75 f0             	pushl  -0x10(%ebp)
8010684a:	ff 75 ec             	pushl  -0x14(%ebp)
8010684d:	e8 5e e5 ff ff       	call   80104db0 <quantify_BJF_parameters_kernel_level>
  return 0;
80106852:	83 c4 10             	add    $0x10,%esp
80106855:	31 c0                	xor    %eax,%eax
}
80106857:	c9                   	leave  
80106858:	c3                   	ret    
80106859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106865:	c9                   	leave  
80106866:	c3                   	ret    
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106870 <sys_print_information>:

int sys_print_information(void)
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 08             	sub    $0x8,%esp
  //myproc()->call_nums[28] ++;
  print_information();
80106876:	e8 95 e5 ff ff       	call   80104e10 <print_information>
  return 0;
8010687b:	31 c0                	xor    %eax,%eax
8010687d:	c9                   	leave  
8010687e:	c3                   	ret    

8010687f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010687f:	1e                   	push   %ds
  pushl %es
80106880:	06                   	push   %es
  pushl %fs
80106881:	0f a0                	push   %fs
  pushl %gs
80106883:	0f a8                	push   %gs
  pushal
80106885:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106886:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010688a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010688c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010688e:	54                   	push   %esp
  call trap
8010688f:	e8 cc 00 00 00       	call   80106960 <trap>
  addl $4, %esp
80106894:	83 c4 04             	add    $0x4,%esp

80106897 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106897:	61                   	popa   
  popl %gs
80106898:	0f a9                	pop    %gs
  popl %fs
8010689a:	0f a1                	pop    %fs
  popl %es
8010689c:	07                   	pop    %es
  popl %ds
8010689d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010689e:	83 c4 08             	add    $0x8,%esp
  iret
801068a1:	cf                   	iret   
801068a2:	66 90                	xchg   %ax,%ax
801068a4:	66 90                	xchg   %ax,%ax
801068a6:	66 90                	xchg   %ax,%ax
801068a8:	66 90                	xchg   %ax,%ax
801068aa:	66 90                	xchg   %ax,%ax
801068ac:	66 90                	xchg   %ax,%ax
801068ae:	66 90                	xchg   %ax,%ax

801068b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801068b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801068b1:	31 c0                	xor    %eax,%eax
{
801068b3:	89 e5                	mov    %esp,%ebp
801068b5:	83 ec 08             	sub    $0x8,%esp
801068b8:	90                   	nop
801068b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068c0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801068c7:	c7 04 c5 42 86 11 80 	movl   $0x8e000008,-0x7fee79be(,%eax,8)
801068ce:	08 00 00 8e 
801068d2:	66 89 14 c5 40 86 11 	mov    %dx,-0x7fee79c0(,%eax,8)
801068d9:	80 
801068da:	c1 ea 10             	shr    $0x10,%edx
801068dd:	66 89 14 c5 46 86 11 	mov    %dx,-0x7fee79ba(,%eax,8)
801068e4:	80 
  for(i = 0; i < 256; i++)
801068e5:	83 c0 01             	add    $0x1,%eax
801068e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801068ed:	75 d1                	jne    801068c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801068ef:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801068f4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801068f7:	c7 05 42 88 11 80 08 	movl   $0xef000008,0x80118842
801068fe:	00 00 ef 
  initlock(&tickslock, "time");
80106901:	68 74 87 10 80       	push   $0x80108774
80106906:	68 00 86 11 80       	push   $0x80118600
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010690b:	66 a3 40 88 11 80    	mov    %ax,0x80118840
80106911:	c1 e8 10             	shr    $0x10,%eax
80106914:	66 a3 46 88 11 80    	mov    %ax,0x80118846
  initlock(&tickslock, "time");
8010691a:	e8 f1 e6 ff ff       	call   80105010 <initlock>
}
8010691f:	83 c4 10             	add    $0x10,%esp
80106922:	c9                   	leave  
80106923:	c3                   	ret    
80106924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010692a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106930 <idtinit>:

void
idtinit(void)
{
80106930:	55                   	push   %ebp
  pd[0] = size-1;
80106931:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106936:	89 e5                	mov    %esp,%ebp
80106938:	83 ec 10             	sub    $0x10,%esp
8010693b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010693f:	b8 40 86 11 80       	mov    $0x80118640,%eax
80106944:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106948:	c1 e8 10             	shr    $0x10,%eax
8010694b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010694f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106952:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106955:	c9                   	leave  
80106956:	c3                   	ret    
80106957:	89 f6                	mov    %esi,%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106960 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	57                   	push   %edi
80106964:	56                   	push   %esi
80106965:	53                   	push   %ebx
80106966:	83 ec 1c             	sub    $0x1c,%esp
80106969:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010696c:	8b 47 30             	mov    0x30(%edi),%eax
8010696f:	83 f8 40             	cmp    $0x40,%eax
80106972:	0f 84 f0 00 00 00    	je     80106a68 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106978:	83 e8 20             	sub    $0x20,%eax
8010697b:	83 f8 1f             	cmp    $0x1f,%eax
8010697e:	77 10                	ja     80106990 <trap+0x30>
80106980:	ff 24 85 dc 8b 10 80 	jmp    *-0x7fef7424(,%eax,4)
80106987:	89 f6                	mov    %esi,%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106990:	e8 2b d1 ff ff       	call   80103ac0 <myproc>
80106995:	85 c0                	test   %eax,%eax
80106997:	8b 5f 38             	mov    0x38(%edi),%ebx
8010699a:	0f 84 14 02 00 00    	je     80106bb4 <trap+0x254>
801069a0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801069a4:	0f 84 0a 02 00 00    	je     80106bb4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801069aa:	0f 20 d1             	mov    %cr2,%ecx
801069ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069b0:	e8 7b d0 ff ff       	call   80103a30 <cpuid>
801069b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069b8:	8b 47 34             	mov    0x34(%edi),%eax
801069bb:	8b 77 30             	mov    0x30(%edi),%esi
801069be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801069c1:	e8 fa d0 ff ff       	call   80103ac0 <myproc>
801069c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069c9:	e8 f2 d0 ff ff       	call   80103ac0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801069d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801069d4:	51                   	push   %ecx
801069d5:	53                   	push   %ebx
801069d6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801069d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069da:	ff 75 e4             	pushl  -0x1c(%ebp)
801069dd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801069de:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069e1:	52                   	push   %edx
801069e2:	ff 70 10             	pushl  0x10(%eax)
801069e5:	68 98 8b 10 80       	push   $0x80108b98
801069ea:	e8 71 9c ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801069ef:	83 c4 20             	add    $0x20,%esp
801069f2:	e8 c9 d0 ff ff       	call   80103ac0 <myproc>
801069f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069fe:	e8 bd d0 ff ff       	call   80103ac0 <myproc>
80106a03:	85 c0                	test   %eax,%eax
80106a05:	74 1d                	je     80106a24 <trap+0xc4>
80106a07:	e8 b4 d0 ff ff       	call   80103ac0 <myproc>
80106a0c:	8b 50 24             	mov    0x24(%eax),%edx
80106a0f:	85 d2                	test   %edx,%edx
80106a11:	74 11                	je     80106a24 <trap+0xc4>
80106a13:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106a17:	83 e0 03             	and    $0x3,%eax
80106a1a:	66 83 f8 03          	cmp    $0x3,%ax
80106a1e:	0f 84 4c 01 00 00    	je     80106b70 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a24:	e8 97 d0 ff ff       	call   80103ac0 <myproc>
80106a29:	85 c0                	test   %eax,%eax
80106a2b:	74 0b                	je     80106a38 <trap+0xd8>
80106a2d:	e8 8e d0 ff ff       	call   80103ac0 <myproc>
80106a32:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a36:	74 68                	je     80106aa0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a38:	e8 83 d0 ff ff       	call   80103ac0 <myproc>
80106a3d:	85 c0                	test   %eax,%eax
80106a3f:	74 19                	je     80106a5a <trap+0xfa>
80106a41:	e8 7a d0 ff ff       	call   80103ac0 <myproc>
80106a46:	8b 40 24             	mov    0x24(%eax),%eax
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	74 0d                	je     80106a5a <trap+0xfa>
80106a4d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106a51:	83 e0 03             	and    $0x3,%eax
80106a54:	66 83 f8 03          	cmp    $0x3,%ax
80106a58:	74 37                	je     80106a91 <trap+0x131>
    exit();
}
80106a5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a5d:	5b                   	pop    %ebx
80106a5e:	5e                   	pop    %esi
80106a5f:	5f                   	pop    %edi
80106a60:	5d                   	pop    %ebp
80106a61:	c3                   	ret    
80106a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106a68:	e8 53 d0 ff ff       	call   80103ac0 <myproc>
80106a6d:	8b 58 24             	mov    0x24(%eax),%ebx
80106a70:	85 db                	test   %ebx,%ebx
80106a72:	0f 85 e8 00 00 00    	jne    80106b60 <trap+0x200>
    myproc()->tf = tf;
80106a78:	e8 43 d0 ff ff       	call   80103ac0 <myproc>
80106a7d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106a80:	e8 cb eb ff ff       	call   80105650 <syscall>
    if(myproc()->killed)
80106a85:	e8 36 d0 ff ff       	call   80103ac0 <myproc>
80106a8a:	8b 48 24             	mov    0x24(%eax),%ecx
80106a8d:	85 c9                	test   %ecx,%ecx
80106a8f:	74 c9                	je     80106a5a <trap+0xfa>
}
80106a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a94:	5b                   	pop    %ebx
80106a95:	5e                   	pop    %esi
80106a96:	5f                   	pop    %edi
80106a97:	5d                   	pop    %ebp
      exit();
80106a98:	e9 d3 d8 ff ff       	jmp    80104370 <exit>
80106a9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106aa0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106aa4:	75 92                	jne    80106a38 <trap+0xd8>
    yield();
80106aa6:	e8 f5 d9 ff ff       	call   801044a0 <yield>
80106aab:	eb 8b                	jmp    80106a38 <trap+0xd8>
80106aad:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106ab0:	e8 7b cf ff ff       	call   80103a30 <cpuid>
80106ab5:	85 c0                	test   %eax,%eax
80106ab7:	0f 84 c3 00 00 00    	je     80106b80 <trap+0x220>
    lapiceoi();
80106abd:	e8 7e be ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ac2:	e8 f9 cf ff ff       	call   80103ac0 <myproc>
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	0f 85 38 ff ff ff    	jne    80106a07 <trap+0xa7>
80106acf:	e9 50 ff ff ff       	jmp    80106a24 <trap+0xc4>
80106ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106ad8:	e8 23 bd ff ff       	call   80102800 <kbdintr>
    lapiceoi();
80106add:	e8 5e be ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ae2:	e8 d9 cf ff ff       	call   80103ac0 <myproc>
80106ae7:	85 c0                	test   %eax,%eax
80106ae9:	0f 85 18 ff ff ff    	jne    80106a07 <trap+0xa7>
80106aef:	e9 30 ff ff ff       	jmp    80106a24 <trap+0xc4>
80106af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106af8:	e8 53 02 00 00       	call   80106d50 <uartintr>
    lapiceoi();
80106afd:	e8 3e be ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b02:	e8 b9 cf ff ff       	call   80103ac0 <myproc>
80106b07:	85 c0                	test   %eax,%eax
80106b09:	0f 85 f8 fe ff ff    	jne    80106a07 <trap+0xa7>
80106b0f:	e9 10 ff ff ff       	jmp    80106a24 <trap+0xc4>
80106b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b18:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106b1c:	8b 77 38             	mov    0x38(%edi),%esi
80106b1f:	e8 0c cf ff ff       	call   80103a30 <cpuid>
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	50                   	push   %eax
80106b27:	68 40 8b 10 80       	push   $0x80108b40
80106b2c:	e8 2f 9b ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106b31:	e8 0a be ff ff       	call   80102940 <lapiceoi>
    break;
80106b36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b39:	e8 82 cf ff ff       	call   80103ac0 <myproc>
80106b3e:	85 c0                	test   %eax,%eax
80106b40:	0f 85 c1 fe ff ff    	jne    80106a07 <trap+0xa7>
80106b46:	e9 d9 fe ff ff       	jmp    80106a24 <trap+0xc4>
80106b4b:	90                   	nop
80106b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106b50:	e8 1b b7 ff ff       	call   80102270 <ideintr>
80106b55:	e9 63 ff ff ff       	jmp    80106abd <trap+0x15d>
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106b60:	e8 0b d8 ff ff       	call   80104370 <exit>
80106b65:	e9 0e ff ff ff       	jmp    80106a78 <trap+0x118>
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106b70:	e8 fb d7 ff ff       	call   80104370 <exit>
80106b75:	e9 aa fe ff ff       	jmp    80106a24 <trap+0xc4>
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	68 00 86 11 80       	push   $0x80118600
80106b88:	e8 c3 e5 ff ff       	call   80105150 <acquire>
      wakeup(&ticks);
80106b8d:	c7 04 24 40 8e 11 80 	movl   $0x80118e40,(%esp)
      ticks++;
80106b94:	83 05 40 8e 11 80 01 	addl   $0x1,0x80118e40
      wakeup(&ticks);
80106b9b:	e8 10 db ff ff       	call   801046b0 <wakeup>
      release(&tickslock);
80106ba0:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
80106ba7:	e8 64 e6 ff ff       	call   80105210 <release>
80106bac:	83 c4 10             	add    $0x10,%esp
80106baf:	e9 09 ff ff ff       	jmp    80106abd <trap+0x15d>
80106bb4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106bb7:	e8 74 ce ff ff       	call   80103a30 <cpuid>
80106bbc:	83 ec 0c             	sub    $0xc,%esp
80106bbf:	56                   	push   %esi
80106bc0:	53                   	push   %ebx
80106bc1:	50                   	push   %eax
80106bc2:	ff 77 30             	pushl  0x30(%edi)
80106bc5:	68 64 8b 10 80       	push   $0x80108b64
80106bca:	e8 91 9a ff ff       	call   80100660 <cprintf>
      panic("trap");
80106bcf:	83 c4 14             	add    $0x14,%esp
80106bd2:	68 39 8b 10 80       	push   $0x80108b39
80106bd7:	e8 b4 97 ff ff       	call   80100390 <panic>
80106bdc:	66 90                	xchg   %ax,%ax
80106bde:	66 90                	xchg   %ax,%ax

80106be0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106be0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106be5:	55                   	push   %ebp
80106be6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106be8:	85 c0                	test   %eax,%eax
80106bea:	74 1c                	je     80106c08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106bf1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106bf2:	a8 01                	test   $0x1,%al
80106bf4:	74 12                	je     80106c08 <uartgetc+0x28>
80106bf6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bfb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106bfc:	0f b6 c0             	movzbl %al,%eax
}
80106bff:	5d                   	pop    %ebp
80106c00:	c3                   	ret    
80106c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c0d:	5d                   	pop    %ebp
80106c0e:	c3                   	ret    
80106c0f:	90                   	nop

80106c10 <uartputc.part.0>:
uartputc(int c)
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	89 c7                	mov    %eax,%edi
80106c18:	bb 80 00 00 00       	mov    $0x80,%ebx
80106c1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106c22:	83 ec 0c             	sub    $0xc,%esp
80106c25:	eb 1b                	jmp    80106c42 <uartputc.part.0+0x32>
80106c27:	89 f6                	mov    %esi,%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	6a 0a                	push   $0xa
80106c35:	e8 26 bd ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c3a:	83 c4 10             	add    $0x10,%esp
80106c3d:	83 eb 01             	sub    $0x1,%ebx
80106c40:	74 07                	je     80106c49 <uartputc.part.0+0x39>
80106c42:	89 f2                	mov    %esi,%edx
80106c44:	ec                   	in     (%dx),%al
80106c45:	a8 20                	test   $0x20,%al
80106c47:	74 e7                	je     80106c30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c4e:	89 f8                	mov    %edi,%eax
80106c50:	ee                   	out    %al,(%dx)
}
80106c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c54:	5b                   	pop    %ebx
80106c55:	5e                   	pop    %esi
80106c56:	5f                   	pop    %edi
80106c57:	5d                   	pop    %ebp
80106c58:	c3                   	ret    
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c60 <uartinit>:
{
80106c60:	55                   	push   %ebp
80106c61:	31 c9                	xor    %ecx,%ecx
80106c63:	89 c8                	mov    %ecx,%eax
80106c65:	89 e5                	mov    %esp,%ebp
80106c67:	57                   	push   %edi
80106c68:	56                   	push   %esi
80106c69:	53                   	push   %ebx
80106c6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106c6f:	89 da                	mov    %ebx,%edx
80106c71:	83 ec 0c             	sub    $0xc,%esp
80106c74:	ee                   	out    %al,(%dx)
80106c75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106c7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c7f:	89 fa                	mov    %edi,%edx
80106c81:	ee                   	out    %al,(%dx)
80106c82:	b8 0c 00 00 00       	mov    $0xc,%eax
80106c87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c8c:	ee                   	out    %al,(%dx)
80106c8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106c92:	89 c8                	mov    %ecx,%eax
80106c94:	89 f2                	mov    %esi,%edx
80106c96:	ee                   	out    %al,(%dx)
80106c97:	b8 03 00 00 00       	mov    $0x3,%eax
80106c9c:	89 fa                	mov    %edi,%edx
80106c9e:	ee                   	out    %al,(%dx)
80106c9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ca4:	89 c8                	mov    %ecx,%eax
80106ca6:	ee                   	out    %al,(%dx)
80106ca7:	b8 01 00 00 00       	mov    $0x1,%eax
80106cac:	89 f2                	mov    %esi,%edx
80106cae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106caf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106cb5:	3c ff                	cmp    $0xff,%al
80106cb7:	74 5a                	je     80106d13 <uartinit+0xb3>
  uart = 1;
80106cb9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106cc0:	00 00 00 
80106cc3:	89 da                	mov    %ebx,%edx
80106cc5:	ec                   	in     (%dx),%al
80106cc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ccb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106ccc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106ccf:	bb 5c 8c 10 80       	mov    $0x80108c5c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106cd4:	6a 00                	push   $0x0
80106cd6:	6a 04                	push   $0x4
80106cd8:	e8 e3 b7 ff ff       	call   801024c0 <ioapicenable>
80106cdd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106ce0:	b8 78 00 00 00       	mov    $0x78,%eax
80106ce5:	eb 13                	jmp    80106cfa <uartinit+0x9a>
80106ce7:	89 f6                	mov    %esi,%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106cf0:	83 c3 01             	add    $0x1,%ebx
80106cf3:	0f be 03             	movsbl (%ebx),%eax
80106cf6:	84 c0                	test   %al,%al
80106cf8:	74 19                	je     80106d13 <uartinit+0xb3>
  if(!uart)
80106cfa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106d00:	85 d2                	test   %edx,%edx
80106d02:	74 ec                	je     80106cf0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106d04:	83 c3 01             	add    $0x1,%ebx
80106d07:	e8 04 ff ff ff       	call   80106c10 <uartputc.part.0>
80106d0c:	0f be 03             	movsbl (%ebx),%eax
80106d0f:	84 c0                	test   %al,%al
80106d11:	75 e7                	jne    80106cfa <uartinit+0x9a>
}
80106d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d16:	5b                   	pop    %ebx
80106d17:	5e                   	pop    %esi
80106d18:	5f                   	pop    %edi
80106d19:	5d                   	pop    %ebp
80106d1a:	c3                   	ret    
80106d1b:	90                   	nop
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d20 <uartputc>:
  if(!uart)
80106d20:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106d26:	55                   	push   %ebp
80106d27:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d29:	85 d2                	test   %edx,%edx
{
80106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106d2e:	74 10                	je     80106d40 <uartputc+0x20>
}
80106d30:	5d                   	pop    %ebp
80106d31:	e9 da fe ff ff       	jmp    80106c10 <uartputc.part.0>
80106d36:	8d 76 00             	lea    0x0(%esi),%esi
80106d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d40:	5d                   	pop    %ebp
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <uartintr>:

void
uartintr(void)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106d56:	68 e0 6b 10 80       	push   $0x80106be0
80106d5b:	e8 b0 9a ff ff       	call   80100810 <consoleintr>
}
80106d60:	83 c4 10             	add    $0x10,%esp
80106d63:	c9                   	leave  
80106d64:	c3                   	ret    

80106d65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $0
80106d67:	6a 00                	push   $0x0
  jmp alltraps
80106d69:	e9 11 fb ff ff       	jmp    8010687f <alltraps>

80106d6e <vector1>:
.globl vector1
vector1:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $1
80106d70:	6a 01                	push   $0x1
  jmp alltraps
80106d72:	e9 08 fb ff ff       	jmp    8010687f <alltraps>

80106d77 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $2
80106d79:	6a 02                	push   $0x2
  jmp alltraps
80106d7b:	e9 ff fa ff ff       	jmp    8010687f <alltraps>

80106d80 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $3
80106d82:	6a 03                	push   $0x3
  jmp alltraps
80106d84:	e9 f6 fa ff ff       	jmp    8010687f <alltraps>

80106d89 <vector4>:
.globl vector4
vector4:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $4
80106d8b:	6a 04                	push   $0x4
  jmp alltraps
80106d8d:	e9 ed fa ff ff       	jmp    8010687f <alltraps>

80106d92 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $5
80106d94:	6a 05                	push   $0x5
  jmp alltraps
80106d96:	e9 e4 fa ff ff       	jmp    8010687f <alltraps>

80106d9b <vector6>:
.globl vector6
vector6:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $6
80106d9d:	6a 06                	push   $0x6
  jmp alltraps
80106d9f:	e9 db fa ff ff       	jmp    8010687f <alltraps>

80106da4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $7
80106da6:	6a 07                	push   $0x7
  jmp alltraps
80106da8:	e9 d2 fa ff ff       	jmp    8010687f <alltraps>

80106dad <vector8>:
.globl vector8
vector8:
  pushl $8
80106dad:	6a 08                	push   $0x8
  jmp alltraps
80106daf:	e9 cb fa ff ff       	jmp    8010687f <alltraps>

80106db4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $9
80106db6:	6a 09                	push   $0x9
  jmp alltraps
80106db8:	e9 c2 fa ff ff       	jmp    8010687f <alltraps>

80106dbd <vector10>:
.globl vector10
vector10:
  pushl $10
80106dbd:	6a 0a                	push   $0xa
  jmp alltraps
80106dbf:	e9 bb fa ff ff       	jmp    8010687f <alltraps>

80106dc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106dc4:	6a 0b                	push   $0xb
  jmp alltraps
80106dc6:	e9 b4 fa ff ff       	jmp    8010687f <alltraps>

80106dcb <vector12>:
.globl vector12
vector12:
  pushl $12
80106dcb:	6a 0c                	push   $0xc
  jmp alltraps
80106dcd:	e9 ad fa ff ff       	jmp    8010687f <alltraps>

80106dd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106dd2:	6a 0d                	push   $0xd
  jmp alltraps
80106dd4:	e9 a6 fa ff ff       	jmp    8010687f <alltraps>

80106dd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106dd9:	6a 0e                	push   $0xe
  jmp alltraps
80106ddb:	e9 9f fa ff ff       	jmp    8010687f <alltraps>

80106de0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $15
80106de2:	6a 0f                	push   $0xf
  jmp alltraps
80106de4:	e9 96 fa ff ff       	jmp    8010687f <alltraps>

80106de9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $16
80106deb:	6a 10                	push   $0x10
  jmp alltraps
80106ded:	e9 8d fa ff ff       	jmp    8010687f <alltraps>

80106df2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106df2:	6a 11                	push   $0x11
  jmp alltraps
80106df4:	e9 86 fa ff ff       	jmp    8010687f <alltraps>

80106df9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $18
80106dfb:	6a 12                	push   $0x12
  jmp alltraps
80106dfd:	e9 7d fa ff ff       	jmp    8010687f <alltraps>

80106e02 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $19
80106e04:	6a 13                	push   $0x13
  jmp alltraps
80106e06:	e9 74 fa ff ff       	jmp    8010687f <alltraps>

80106e0b <vector20>:
.globl vector20
vector20:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $20
80106e0d:	6a 14                	push   $0x14
  jmp alltraps
80106e0f:	e9 6b fa ff ff       	jmp    8010687f <alltraps>

80106e14 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $21
80106e16:	6a 15                	push   $0x15
  jmp alltraps
80106e18:	e9 62 fa ff ff       	jmp    8010687f <alltraps>

80106e1d <vector22>:
.globl vector22
vector22:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $22
80106e1f:	6a 16                	push   $0x16
  jmp alltraps
80106e21:	e9 59 fa ff ff       	jmp    8010687f <alltraps>

80106e26 <vector23>:
.globl vector23
vector23:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $23
80106e28:	6a 17                	push   $0x17
  jmp alltraps
80106e2a:	e9 50 fa ff ff       	jmp    8010687f <alltraps>

80106e2f <vector24>:
.globl vector24
vector24:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $24
80106e31:	6a 18                	push   $0x18
  jmp alltraps
80106e33:	e9 47 fa ff ff       	jmp    8010687f <alltraps>

80106e38 <vector25>:
.globl vector25
vector25:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $25
80106e3a:	6a 19                	push   $0x19
  jmp alltraps
80106e3c:	e9 3e fa ff ff       	jmp    8010687f <alltraps>

80106e41 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $26
80106e43:	6a 1a                	push   $0x1a
  jmp alltraps
80106e45:	e9 35 fa ff ff       	jmp    8010687f <alltraps>

80106e4a <vector27>:
.globl vector27
vector27:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $27
80106e4c:	6a 1b                	push   $0x1b
  jmp alltraps
80106e4e:	e9 2c fa ff ff       	jmp    8010687f <alltraps>

80106e53 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $28
80106e55:	6a 1c                	push   $0x1c
  jmp alltraps
80106e57:	e9 23 fa ff ff       	jmp    8010687f <alltraps>

80106e5c <vector29>:
.globl vector29
vector29:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $29
80106e5e:	6a 1d                	push   $0x1d
  jmp alltraps
80106e60:	e9 1a fa ff ff       	jmp    8010687f <alltraps>

80106e65 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $30
80106e67:	6a 1e                	push   $0x1e
  jmp alltraps
80106e69:	e9 11 fa ff ff       	jmp    8010687f <alltraps>

80106e6e <vector31>:
.globl vector31
vector31:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $31
80106e70:	6a 1f                	push   $0x1f
  jmp alltraps
80106e72:	e9 08 fa ff ff       	jmp    8010687f <alltraps>

80106e77 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $32
80106e79:	6a 20                	push   $0x20
  jmp alltraps
80106e7b:	e9 ff f9 ff ff       	jmp    8010687f <alltraps>

80106e80 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $33
80106e82:	6a 21                	push   $0x21
  jmp alltraps
80106e84:	e9 f6 f9 ff ff       	jmp    8010687f <alltraps>

80106e89 <vector34>:
.globl vector34
vector34:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $34
80106e8b:	6a 22                	push   $0x22
  jmp alltraps
80106e8d:	e9 ed f9 ff ff       	jmp    8010687f <alltraps>

80106e92 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $35
80106e94:	6a 23                	push   $0x23
  jmp alltraps
80106e96:	e9 e4 f9 ff ff       	jmp    8010687f <alltraps>

80106e9b <vector36>:
.globl vector36
vector36:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $36
80106e9d:	6a 24                	push   $0x24
  jmp alltraps
80106e9f:	e9 db f9 ff ff       	jmp    8010687f <alltraps>

80106ea4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $37
80106ea6:	6a 25                	push   $0x25
  jmp alltraps
80106ea8:	e9 d2 f9 ff ff       	jmp    8010687f <alltraps>

80106ead <vector38>:
.globl vector38
vector38:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $38
80106eaf:	6a 26                	push   $0x26
  jmp alltraps
80106eb1:	e9 c9 f9 ff ff       	jmp    8010687f <alltraps>

80106eb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $39
80106eb8:	6a 27                	push   $0x27
  jmp alltraps
80106eba:	e9 c0 f9 ff ff       	jmp    8010687f <alltraps>

80106ebf <vector40>:
.globl vector40
vector40:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $40
80106ec1:	6a 28                	push   $0x28
  jmp alltraps
80106ec3:	e9 b7 f9 ff ff       	jmp    8010687f <alltraps>

80106ec8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $41
80106eca:	6a 29                	push   $0x29
  jmp alltraps
80106ecc:	e9 ae f9 ff ff       	jmp    8010687f <alltraps>

80106ed1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $42
80106ed3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ed5:	e9 a5 f9 ff ff       	jmp    8010687f <alltraps>

80106eda <vector43>:
.globl vector43
vector43:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $43
80106edc:	6a 2b                	push   $0x2b
  jmp alltraps
80106ede:	e9 9c f9 ff ff       	jmp    8010687f <alltraps>

80106ee3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $44
80106ee5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ee7:	e9 93 f9 ff ff       	jmp    8010687f <alltraps>

80106eec <vector45>:
.globl vector45
vector45:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $45
80106eee:	6a 2d                	push   $0x2d
  jmp alltraps
80106ef0:	e9 8a f9 ff ff       	jmp    8010687f <alltraps>

80106ef5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $46
80106ef7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ef9:	e9 81 f9 ff ff       	jmp    8010687f <alltraps>

80106efe <vector47>:
.globl vector47
vector47:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $47
80106f00:	6a 2f                	push   $0x2f
  jmp alltraps
80106f02:	e9 78 f9 ff ff       	jmp    8010687f <alltraps>

80106f07 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $48
80106f09:	6a 30                	push   $0x30
  jmp alltraps
80106f0b:	e9 6f f9 ff ff       	jmp    8010687f <alltraps>

80106f10 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $49
80106f12:	6a 31                	push   $0x31
  jmp alltraps
80106f14:	e9 66 f9 ff ff       	jmp    8010687f <alltraps>

80106f19 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $50
80106f1b:	6a 32                	push   $0x32
  jmp alltraps
80106f1d:	e9 5d f9 ff ff       	jmp    8010687f <alltraps>

80106f22 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $51
80106f24:	6a 33                	push   $0x33
  jmp alltraps
80106f26:	e9 54 f9 ff ff       	jmp    8010687f <alltraps>

80106f2b <vector52>:
.globl vector52
vector52:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $52
80106f2d:	6a 34                	push   $0x34
  jmp alltraps
80106f2f:	e9 4b f9 ff ff       	jmp    8010687f <alltraps>

80106f34 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $53
80106f36:	6a 35                	push   $0x35
  jmp alltraps
80106f38:	e9 42 f9 ff ff       	jmp    8010687f <alltraps>

80106f3d <vector54>:
.globl vector54
vector54:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $54
80106f3f:	6a 36                	push   $0x36
  jmp alltraps
80106f41:	e9 39 f9 ff ff       	jmp    8010687f <alltraps>

80106f46 <vector55>:
.globl vector55
vector55:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $55
80106f48:	6a 37                	push   $0x37
  jmp alltraps
80106f4a:	e9 30 f9 ff ff       	jmp    8010687f <alltraps>

80106f4f <vector56>:
.globl vector56
vector56:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $56
80106f51:	6a 38                	push   $0x38
  jmp alltraps
80106f53:	e9 27 f9 ff ff       	jmp    8010687f <alltraps>

80106f58 <vector57>:
.globl vector57
vector57:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $57
80106f5a:	6a 39                	push   $0x39
  jmp alltraps
80106f5c:	e9 1e f9 ff ff       	jmp    8010687f <alltraps>

80106f61 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $58
80106f63:	6a 3a                	push   $0x3a
  jmp alltraps
80106f65:	e9 15 f9 ff ff       	jmp    8010687f <alltraps>

80106f6a <vector59>:
.globl vector59
vector59:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $59
80106f6c:	6a 3b                	push   $0x3b
  jmp alltraps
80106f6e:	e9 0c f9 ff ff       	jmp    8010687f <alltraps>

80106f73 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $60
80106f75:	6a 3c                	push   $0x3c
  jmp alltraps
80106f77:	e9 03 f9 ff ff       	jmp    8010687f <alltraps>

80106f7c <vector61>:
.globl vector61
vector61:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $61
80106f7e:	6a 3d                	push   $0x3d
  jmp alltraps
80106f80:	e9 fa f8 ff ff       	jmp    8010687f <alltraps>

80106f85 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $62
80106f87:	6a 3e                	push   $0x3e
  jmp alltraps
80106f89:	e9 f1 f8 ff ff       	jmp    8010687f <alltraps>

80106f8e <vector63>:
.globl vector63
vector63:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $63
80106f90:	6a 3f                	push   $0x3f
  jmp alltraps
80106f92:	e9 e8 f8 ff ff       	jmp    8010687f <alltraps>

80106f97 <vector64>:
.globl vector64
vector64:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $64
80106f99:	6a 40                	push   $0x40
  jmp alltraps
80106f9b:	e9 df f8 ff ff       	jmp    8010687f <alltraps>

80106fa0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $65
80106fa2:	6a 41                	push   $0x41
  jmp alltraps
80106fa4:	e9 d6 f8 ff ff       	jmp    8010687f <alltraps>

80106fa9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $66
80106fab:	6a 42                	push   $0x42
  jmp alltraps
80106fad:	e9 cd f8 ff ff       	jmp    8010687f <alltraps>

80106fb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $67
80106fb4:	6a 43                	push   $0x43
  jmp alltraps
80106fb6:	e9 c4 f8 ff ff       	jmp    8010687f <alltraps>

80106fbb <vector68>:
.globl vector68
vector68:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $68
80106fbd:	6a 44                	push   $0x44
  jmp alltraps
80106fbf:	e9 bb f8 ff ff       	jmp    8010687f <alltraps>

80106fc4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $69
80106fc6:	6a 45                	push   $0x45
  jmp alltraps
80106fc8:	e9 b2 f8 ff ff       	jmp    8010687f <alltraps>

80106fcd <vector70>:
.globl vector70
vector70:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $70
80106fcf:	6a 46                	push   $0x46
  jmp alltraps
80106fd1:	e9 a9 f8 ff ff       	jmp    8010687f <alltraps>

80106fd6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $71
80106fd8:	6a 47                	push   $0x47
  jmp alltraps
80106fda:	e9 a0 f8 ff ff       	jmp    8010687f <alltraps>

80106fdf <vector72>:
.globl vector72
vector72:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $72
80106fe1:	6a 48                	push   $0x48
  jmp alltraps
80106fe3:	e9 97 f8 ff ff       	jmp    8010687f <alltraps>

80106fe8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $73
80106fea:	6a 49                	push   $0x49
  jmp alltraps
80106fec:	e9 8e f8 ff ff       	jmp    8010687f <alltraps>

80106ff1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $74
80106ff3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ff5:	e9 85 f8 ff ff       	jmp    8010687f <alltraps>

80106ffa <vector75>:
.globl vector75
vector75:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $75
80106ffc:	6a 4b                	push   $0x4b
  jmp alltraps
80106ffe:	e9 7c f8 ff ff       	jmp    8010687f <alltraps>

80107003 <vector76>:
.globl vector76
vector76:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $76
80107005:	6a 4c                	push   $0x4c
  jmp alltraps
80107007:	e9 73 f8 ff ff       	jmp    8010687f <alltraps>

8010700c <vector77>:
.globl vector77
vector77:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $77
8010700e:	6a 4d                	push   $0x4d
  jmp alltraps
80107010:	e9 6a f8 ff ff       	jmp    8010687f <alltraps>

80107015 <vector78>:
.globl vector78
vector78:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $78
80107017:	6a 4e                	push   $0x4e
  jmp alltraps
80107019:	e9 61 f8 ff ff       	jmp    8010687f <alltraps>

8010701e <vector79>:
.globl vector79
vector79:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $79
80107020:	6a 4f                	push   $0x4f
  jmp alltraps
80107022:	e9 58 f8 ff ff       	jmp    8010687f <alltraps>

80107027 <vector80>:
.globl vector80
vector80:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $80
80107029:	6a 50                	push   $0x50
  jmp alltraps
8010702b:	e9 4f f8 ff ff       	jmp    8010687f <alltraps>

80107030 <vector81>:
.globl vector81
vector81:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $81
80107032:	6a 51                	push   $0x51
  jmp alltraps
80107034:	e9 46 f8 ff ff       	jmp    8010687f <alltraps>

80107039 <vector82>:
.globl vector82
vector82:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $82
8010703b:	6a 52                	push   $0x52
  jmp alltraps
8010703d:	e9 3d f8 ff ff       	jmp    8010687f <alltraps>

80107042 <vector83>:
.globl vector83
vector83:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $83
80107044:	6a 53                	push   $0x53
  jmp alltraps
80107046:	e9 34 f8 ff ff       	jmp    8010687f <alltraps>

8010704b <vector84>:
.globl vector84
vector84:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $84
8010704d:	6a 54                	push   $0x54
  jmp alltraps
8010704f:	e9 2b f8 ff ff       	jmp    8010687f <alltraps>

80107054 <vector85>:
.globl vector85
vector85:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $85
80107056:	6a 55                	push   $0x55
  jmp alltraps
80107058:	e9 22 f8 ff ff       	jmp    8010687f <alltraps>

8010705d <vector86>:
.globl vector86
vector86:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $86
8010705f:	6a 56                	push   $0x56
  jmp alltraps
80107061:	e9 19 f8 ff ff       	jmp    8010687f <alltraps>

80107066 <vector87>:
.globl vector87
vector87:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $87
80107068:	6a 57                	push   $0x57
  jmp alltraps
8010706a:	e9 10 f8 ff ff       	jmp    8010687f <alltraps>

8010706f <vector88>:
.globl vector88
vector88:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $88
80107071:	6a 58                	push   $0x58
  jmp alltraps
80107073:	e9 07 f8 ff ff       	jmp    8010687f <alltraps>

80107078 <vector89>:
.globl vector89
vector89:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $89
8010707a:	6a 59                	push   $0x59
  jmp alltraps
8010707c:	e9 fe f7 ff ff       	jmp    8010687f <alltraps>

80107081 <vector90>:
.globl vector90
vector90:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $90
80107083:	6a 5a                	push   $0x5a
  jmp alltraps
80107085:	e9 f5 f7 ff ff       	jmp    8010687f <alltraps>

8010708a <vector91>:
.globl vector91
vector91:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $91
8010708c:	6a 5b                	push   $0x5b
  jmp alltraps
8010708e:	e9 ec f7 ff ff       	jmp    8010687f <alltraps>

80107093 <vector92>:
.globl vector92
vector92:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $92
80107095:	6a 5c                	push   $0x5c
  jmp alltraps
80107097:	e9 e3 f7 ff ff       	jmp    8010687f <alltraps>

8010709c <vector93>:
.globl vector93
vector93:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $93
8010709e:	6a 5d                	push   $0x5d
  jmp alltraps
801070a0:	e9 da f7 ff ff       	jmp    8010687f <alltraps>

801070a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $94
801070a7:	6a 5e                	push   $0x5e
  jmp alltraps
801070a9:	e9 d1 f7 ff ff       	jmp    8010687f <alltraps>

801070ae <vector95>:
.globl vector95
vector95:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $95
801070b0:	6a 5f                	push   $0x5f
  jmp alltraps
801070b2:	e9 c8 f7 ff ff       	jmp    8010687f <alltraps>

801070b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $96
801070b9:	6a 60                	push   $0x60
  jmp alltraps
801070bb:	e9 bf f7 ff ff       	jmp    8010687f <alltraps>

801070c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $97
801070c2:	6a 61                	push   $0x61
  jmp alltraps
801070c4:	e9 b6 f7 ff ff       	jmp    8010687f <alltraps>

801070c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $98
801070cb:	6a 62                	push   $0x62
  jmp alltraps
801070cd:	e9 ad f7 ff ff       	jmp    8010687f <alltraps>

801070d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $99
801070d4:	6a 63                	push   $0x63
  jmp alltraps
801070d6:	e9 a4 f7 ff ff       	jmp    8010687f <alltraps>

801070db <vector100>:
.globl vector100
vector100:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $100
801070dd:	6a 64                	push   $0x64
  jmp alltraps
801070df:	e9 9b f7 ff ff       	jmp    8010687f <alltraps>

801070e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $101
801070e6:	6a 65                	push   $0x65
  jmp alltraps
801070e8:	e9 92 f7 ff ff       	jmp    8010687f <alltraps>

801070ed <vector102>:
.globl vector102
vector102:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $102
801070ef:	6a 66                	push   $0x66
  jmp alltraps
801070f1:	e9 89 f7 ff ff       	jmp    8010687f <alltraps>

801070f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $103
801070f8:	6a 67                	push   $0x67
  jmp alltraps
801070fa:	e9 80 f7 ff ff       	jmp    8010687f <alltraps>

801070ff <vector104>:
.globl vector104
vector104:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $104
80107101:	6a 68                	push   $0x68
  jmp alltraps
80107103:	e9 77 f7 ff ff       	jmp    8010687f <alltraps>

80107108 <vector105>:
.globl vector105
vector105:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $105
8010710a:	6a 69                	push   $0x69
  jmp alltraps
8010710c:	e9 6e f7 ff ff       	jmp    8010687f <alltraps>

80107111 <vector106>:
.globl vector106
vector106:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $106
80107113:	6a 6a                	push   $0x6a
  jmp alltraps
80107115:	e9 65 f7 ff ff       	jmp    8010687f <alltraps>

8010711a <vector107>:
.globl vector107
vector107:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $107
8010711c:	6a 6b                	push   $0x6b
  jmp alltraps
8010711e:	e9 5c f7 ff ff       	jmp    8010687f <alltraps>

80107123 <vector108>:
.globl vector108
vector108:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $108
80107125:	6a 6c                	push   $0x6c
  jmp alltraps
80107127:	e9 53 f7 ff ff       	jmp    8010687f <alltraps>

8010712c <vector109>:
.globl vector109
vector109:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $109
8010712e:	6a 6d                	push   $0x6d
  jmp alltraps
80107130:	e9 4a f7 ff ff       	jmp    8010687f <alltraps>

80107135 <vector110>:
.globl vector110
vector110:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $110
80107137:	6a 6e                	push   $0x6e
  jmp alltraps
80107139:	e9 41 f7 ff ff       	jmp    8010687f <alltraps>

8010713e <vector111>:
.globl vector111
vector111:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $111
80107140:	6a 6f                	push   $0x6f
  jmp alltraps
80107142:	e9 38 f7 ff ff       	jmp    8010687f <alltraps>

80107147 <vector112>:
.globl vector112
vector112:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $112
80107149:	6a 70                	push   $0x70
  jmp alltraps
8010714b:	e9 2f f7 ff ff       	jmp    8010687f <alltraps>

80107150 <vector113>:
.globl vector113
vector113:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $113
80107152:	6a 71                	push   $0x71
  jmp alltraps
80107154:	e9 26 f7 ff ff       	jmp    8010687f <alltraps>

80107159 <vector114>:
.globl vector114
vector114:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $114
8010715b:	6a 72                	push   $0x72
  jmp alltraps
8010715d:	e9 1d f7 ff ff       	jmp    8010687f <alltraps>

80107162 <vector115>:
.globl vector115
vector115:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $115
80107164:	6a 73                	push   $0x73
  jmp alltraps
80107166:	e9 14 f7 ff ff       	jmp    8010687f <alltraps>

8010716b <vector116>:
.globl vector116
vector116:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $116
8010716d:	6a 74                	push   $0x74
  jmp alltraps
8010716f:	e9 0b f7 ff ff       	jmp    8010687f <alltraps>

80107174 <vector117>:
.globl vector117
vector117:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $117
80107176:	6a 75                	push   $0x75
  jmp alltraps
80107178:	e9 02 f7 ff ff       	jmp    8010687f <alltraps>

8010717d <vector118>:
.globl vector118
vector118:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $118
8010717f:	6a 76                	push   $0x76
  jmp alltraps
80107181:	e9 f9 f6 ff ff       	jmp    8010687f <alltraps>

80107186 <vector119>:
.globl vector119
vector119:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $119
80107188:	6a 77                	push   $0x77
  jmp alltraps
8010718a:	e9 f0 f6 ff ff       	jmp    8010687f <alltraps>

8010718f <vector120>:
.globl vector120
vector120:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $120
80107191:	6a 78                	push   $0x78
  jmp alltraps
80107193:	e9 e7 f6 ff ff       	jmp    8010687f <alltraps>

80107198 <vector121>:
.globl vector121
vector121:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $121
8010719a:	6a 79                	push   $0x79
  jmp alltraps
8010719c:	e9 de f6 ff ff       	jmp    8010687f <alltraps>

801071a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $122
801071a3:	6a 7a                	push   $0x7a
  jmp alltraps
801071a5:	e9 d5 f6 ff ff       	jmp    8010687f <alltraps>

801071aa <vector123>:
.globl vector123
vector123:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $123
801071ac:	6a 7b                	push   $0x7b
  jmp alltraps
801071ae:	e9 cc f6 ff ff       	jmp    8010687f <alltraps>

801071b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $124
801071b5:	6a 7c                	push   $0x7c
  jmp alltraps
801071b7:	e9 c3 f6 ff ff       	jmp    8010687f <alltraps>

801071bc <vector125>:
.globl vector125
vector125:
  pushl $0
801071bc:	6a 00                	push   $0x0
  pushl $125
801071be:	6a 7d                	push   $0x7d
  jmp alltraps
801071c0:	e9 ba f6 ff ff       	jmp    8010687f <alltraps>

801071c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $126
801071c7:	6a 7e                	push   $0x7e
  jmp alltraps
801071c9:	e9 b1 f6 ff ff       	jmp    8010687f <alltraps>

801071ce <vector127>:
.globl vector127
vector127:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $127
801071d0:	6a 7f                	push   $0x7f
  jmp alltraps
801071d2:	e9 a8 f6 ff ff       	jmp    8010687f <alltraps>

801071d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $128
801071d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071de:	e9 9c f6 ff ff       	jmp    8010687f <alltraps>

801071e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $129
801071e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801071ea:	e9 90 f6 ff ff       	jmp    8010687f <alltraps>

801071ef <vector130>:
.globl vector130
vector130:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $130
801071f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071f6:	e9 84 f6 ff ff       	jmp    8010687f <alltraps>

801071fb <vector131>:
.globl vector131
vector131:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $131
801071fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107202:	e9 78 f6 ff ff       	jmp    8010687f <alltraps>

80107207 <vector132>:
.globl vector132
vector132:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $132
80107209:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010720e:	e9 6c f6 ff ff       	jmp    8010687f <alltraps>

80107213 <vector133>:
.globl vector133
vector133:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $133
80107215:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010721a:	e9 60 f6 ff ff       	jmp    8010687f <alltraps>

8010721f <vector134>:
.globl vector134
vector134:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $134
80107221:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107226:	e9 54 f6 ff ff       	jmp    8010687f <alltraps>

8010722b <vector135>:
.globl vector135
vector135:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $135
8010722d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107232:	e9 48 f6 ff ff       	jmp    8010687f <alltraps>

80107237 <vector136>:
.globl vector136
vector136:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $136
80107239:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010723e:	e9 3c f6 ff ff       	jmp    8010687f <alltraps>

80107243 <vector137>:
.globl vector137
vector137:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $137
80107245:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010724a:	e9 30 f6 ff ff       	jmp    8010687f <alltraps>

8010724f <vector138>:
.globl vector138
vector138:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $138
80107251:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107256:	e9 24 f6 ff ff       	jmp    8010687f <alltraps>

8010725b <vector139>:
.globl vector139
vector139:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $139
8010725d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107262:	e9 18 f6 ff ff       	jmp    8010687f <alltraps>

80107267 <vector140>:
.globl vector140
vector140:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $140
80107269:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010726e:	e9 0c f6 ff ff       	jmp    8010687f <alltraps>

80107273 <vector141>:
.globl vector141
vector141:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $141
80107275:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010727a:	e9 00 f6 ff ff       	jmp    8010687f <alltraps>

8010727f <vector142>:
.globl vector142
vector142:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $142
80107281:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107286:	e9 f4 f5 ff ff       	jmp    8010687f <alltraps>

8010728b <vector143>:
.globl vector143
vector143:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $143
8010728d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107292:	e9 e8 f5 ff ff       	jmp    8010687f <alltraps>

80107297 <vector144>:
.globl vector144
vector144:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $144
80107299:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010729e:	e9 dc f5 ff ff       	jmp    8010687f <alltraps>

801072a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $145
801072a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801072aa:	e9 d0 f5 ff ff       	jmp    8010687f <alltraps>

801072af <vector146>:
.globl vector146
vector146:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $146
801072b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801072b6:	e9 c4 f5 ff ff       	jmp    8010687f <alltraps>

801072bb <vector147>:
.globl vector147
vector147:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $147
801072bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801072c2:	e9 b8 f5 ff ff       	jmp    8010687f <alltraps>

801072c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $148
801072c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072ce:	e9 ac f5 ff ff       	jmp    8010687f <alltraps>

801072d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $149
801072d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072da:	e9 a0 f5 ff ff       	jmp    8010687f <alltraps>

801072df <vector150>:
.globl vector150
vector150:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $150
801072e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801072e6:	e9 94 f5 ff ff       	jmp    8010687f <alltraps>

801072eb <vector151>:
.globl vector151
vector151:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $151
801072ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801072f2:	e9 88 f5 ff ff       	jmp    8010687f <alltraps>

801072f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $152
801072f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072fe:	e9 7c f5 ff ff       	jmp    8010687f <alltraps>

80107303 <vector153>:
.globl vector153
vector153:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $153
80107305:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010730a:	e9 70 f5 ff ff       	jmp    8010687f <alltraps>

8010730f <vector154>:
.globl vector154
vector154:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $154
80107311:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107316:	e9 64 f5 ff ff       	jmp    8010687f <alltraps>

8010731b <vector155>:
.globl vector155
vector155:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $155
8010731d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107322:	e9 58 f5 ff ff       	jmp    8010687f <alltraps>

80107327 <vector156>:
.globl vector156
vector156:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $156
80107329:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010732e:	e9 4c f5 ff ff       	jmp    8010687f <alltraps>

80107333 <vector157>:
.globl vector157
vector157:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $157
80107335:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010733a:	e9 40 f5 ff ff       	jmp    8010687f <alltraps>

8010733f <vector158>:
.globl vector158
vector158:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $158
80107341:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107346:	e9 34 f5 ff ff       	jmp    8010687f <alltraps>

8010734b <vector159>:
.globl vector159
vector159:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $159
8010734d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107352:	e9 28 f5 ff ff       	jmp    8010687f <alltraps>

80107357 <vector160>:
.globl vector160
vector160:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $160
80107359:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010735e:	e9 1c f5 ff ff       	jmp    8010687f <alltraps>

80107363 <vector161>:
.globl vector161
vector161:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $161
80107365:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010736a:	e9 10 f5 ff ff       	jmp    8010687f <alltraps>

8010736f <vector162>:
.globl vector162
vector162:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $162
80107371:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107376:	e9 04 f5 ff ff       	jmp    8010687f <alltraps>

8010737b <vector163>:
.globl vector163
vector163:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $163
8010737d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107382:	e9 f8 f4 ff ff       	jmp    8010687f <alltraps>

80107387 <vector164>:
.globl vector164
vector164:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $164
80107389:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010738e:	e9 ec f4 ff ff       	jmp    8010687f <alltraps>

80107393 <vector165>:
.globl vector165
vector165:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $165
80107395:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010739a:	e9 e0 f4 ff ff       	jmp    8010687f <alltraps>

8010739f <vector166>:
.globl vector166
vector166:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $166
801073a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801073a6:	e9 d4 f4 ff ff       	jmp    8010687f <alltraps>

801073ab <vector167>:
.globl vector167
vector167:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $167
801073ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801073b2:	e9 c8 f4 ff ff       	jmp    8010687f <alltraps>

801073b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $168
801073b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801073be:	e9 bc f4 ff ff       	jmp    8010687f <alltraps>

801073c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $169
801073c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801073ca:	e9 b0 f4 ff ff       	jmp    8010687f <alltraps>

801073cf <vector170>:
.globl vector170
vector170:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $170
801073d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073d6:	e9 a4 f4 ff ff       	jmp    8010687f <alltraps>

801073db <vector171>:
.globl vector171
vector171:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $171
801073dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801073e2:	e9 98 f4 ff ff       	jmp    8010687f <alltraps>

801073e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $172
801073e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801073ee:	e9 8c f4 ff ff       	jmp    8010687f <alltraps>

801073f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $173
801073f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073fa:	e9 80 f4 ff ff       	jmp    8010687f <alltraps>

801073ff <vector174>:
.globl vector174
vector174:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $174
80107401:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107406:	e9 74 f4 ff ff       	jmp    8010687f <alltraps>

8010740b <vector175>:
.globl vector175
vector175:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $175
8010740d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107412:	e9 68 f4 ff ff       	jmp    8010687f <alltraps>

80107417 <vector176>:
.globl vector176
vector176:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $176
80107419:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010741e:	e9 5c f4 ff ff       	jmp    8010687f <alltraps>

80107423 <vector177>:
.globl vector177
vector177:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $177
80107425:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010742a:	e9 50 f4 ff ff       	jmp    8010687f <alltraps>

8010742f <vector178>:
.globl vector178
vector178:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $178
80107431:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107436:	e9 44 f4 ff ff       	jmp    8010687f <alltraps>

8010743b <vector179>:
.globl vector179
vector179:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $179
8010743d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107442:	e9 38 f4 ff ff       	jmp    8010687f <alltraps>

80107447 <vector180>:
.globl vector180
vector180:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $180
80107449:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010744e:	e9 2c f4 ff ff       	jmp    8010687f <alltraps>

80107453 <vector181>:
.globl vector181
vector181:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $181
80107455:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010745a:	e9 20 f4 ff ff       	jmp    8010687f <alltraps>

8010745f <vector182>:
.globl vector182
vector182:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $182
80107461:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107466:	e9 14 f4 ff ff       	jmp    8010687f <alltraps>

8010746b <vector183>:
.globl vector183
vector183:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $183
8010746d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107472:	e9 08 f4 ff ff       	jmp    8010687f <alltraps>

80107477 <vector184>:
.globl vector184
vector184:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $184
80107479:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010747e:	e9 fc f3 ff ff       	jmp    8010687f <alltraps>

80107483 <vector185>:
.globl vector185
vector185:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $185
80107485:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010748a:	e9 f0 f3 ff ff       	jmp    8010687f <alltraps>

8010748f <vector186>:
.globl vector186
vector186:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $186
80107491:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107496:	e9 e4 f3 ff ff       	jmp    8010687f <alltraps>

8010749b <vector187>:
.globl vector187
vector187:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $187
8010749d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801074a2:	e9 d8 f3 ff ff       	jmp    8010687f <alltraps>

801074a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $188
801074a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801074ae:	e9 cc f3 ff ff       	jmp    8010687f <alltraps>

801074b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $189
801074b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801074ba:	e9 c0 f3 ff ff       	jmp    8010687f <alltraps>

801074bf <vector190>:
.globl vector190
vector190:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $190
801074c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801074c6:	e9 b4 f3 ff ff       	jmp    8010687f <alltraps>

801074cb <vector191>:
.globl vector191
vector191:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $191
801074cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074d2:	e9 a8 f3 ff ff       	jmp    8010687f <alltraps>

801074d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $192
801074d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074de:	e9 9c f3 ff ff       	jmp    8010687f <alltraps>

801074e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $193
801074e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801074ea:	e9 90 f3 ff ff       	jmp    8010687f <alltraps>

801074ef <vector194>:
.globl vector194
vector194:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $194
801074f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074f6:	e9 84 f3 ff ff       	jmp    8010687f <alltraps>

801074fb <vector195>:
.globl vector195
vector195:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $195
801074fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107502:	e9 78 f3 ff ff       	jmp    8010687f <alltraps>

80107507 <vector196>:
.globl vector196
vector196:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $196
80107509:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010750e:	e9 6c f3 ff ff       	jmp    8010687f <alltraps>

80107513 <vector197>:
.globl vector197
vector197:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $197
80107515:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010751a:	e9 60 f3 ff ff       	jmp    8010687f <alltraps>

8010751f <vector198>:
.globl vector198
vector198:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $198
80107521:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107526:	e9 54 f3 ff ff       	jmp    8010687f <alltraps>

8010752b <vector199>:
.globl vector199
vector199:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $199
8010752d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107532:	e9 48 f3 ff ff       	jmp    8010687f <alltraps>

80107537 <vector200>:
.globl vector200
vector200:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $200
80107539:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010753e:	e9 3c f3 ff ff       	jmp    8010687f <alltraps>

80107543 <vector201>:
.globl vector201
vector201:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $201
80107545:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010754a:	e9 30 f3 ff ff       	jmp    8010687f <alltraps>

8010754f <vector202>:
.globl vector202
vector202:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $202
80107551:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107556:	e9 24 f3 ff ff       	jmp    8010687f <alltraps>

8010755b <vector203>:
.globl vector203
vector203:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $203
8010755d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107562:	e9 18 f3 ff ff       	jmp    8010687f <alltraps>

80107567 <vector204>:
.globl vector204
vector204:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $204
80107569:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010756e:	e9 0c f3 ff ff       	jmp    8010687f <alltraps>

80107573 <vector205>:
.globl vector205
vector205:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $205
80107575:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010757a:	e9 00 f3 ff ff       	jmp    8010687f <alltraps>

8010757f <vector206>:
.globl vector206
vector206:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $206
80107581:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107586:	e9 f4 f2 ff ff       	jmp    8010687f <alltraps>

8010758b <vector207>:
.globl vector207
vector207:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $207
8010758d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107592:	e9 e8 f2 ff ff       	jmp    8010687f <alltraps>

80107597 <vector208>:
.globl vector208
vector208:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $208
80107599:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010759e:	e9 dc f2 ff ff       	jmp    8010687f <alltraps>

801075a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $209
801075a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801075aa:	e9 d0 f2 ff ff       	jmp    8010687f <alltraps>

801075af <vector210>:
.globl vector210
vector210:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $210
801075b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801075b6:	e9 c4 f2 ff ff       	jmp    8010687f <alltraps>

801075bb <vector211>:
.globl vector211
vector211:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $211
801075bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801075c2:	e9 b8 f2 ff ff       	jmp    8010687f <alltraps>

801075c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $212
801075c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075ce:	e9 ac f2 ff ff       	jmp    8010687f <alltraps>

801075d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $213
801075d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075da:	e9 a0 f2 ff ff       	jmp    8010687f <alltraps>

801075df <vector214>:
.globl vector214
vector214:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $214
801075e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801075e6:	e9 94 f2 ff ff       	jmp    8010687f <alltraps>

801075eb <vector215>:
.globl vector215
vector215:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $215
801075ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801075f2:	e9 88 f2 ff ff       	jmp    8010687f <alltraps>

801075f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $216
801075f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075fe:	e9 7c f2 ff ff       	jmp    8010687f <alltraps>

80107603 <vector217>:
.globl vector217
vector217:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $217
80107605:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010760a:	e9 70 f2 ff ff       	jmp    8010687f <alltraps>

8010760f <vector218>:
.globl vector218
vector218:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $218
80107611:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107616:	e9 64 f2 ff ff       	jmp    8010687f <alltraps>

8010761b <vector219>:
.globl vector219
vector219:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $219
8010761d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107622:	e9 58 f2 ff ff       	jmp    8010687f <alltraps>

80107627 <vector220>:
.globl vector220
vector220:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $220
80107629:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010762e:	e9 4c f2 ff ff       	jmp    8010687f <alltraps>

80107633 <vector221>:
.globl vector221
vector221:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $221
80107635:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010763a:	e9 40 f2 ff ff       	jmp    8010687f <alltraps>

8010763f <vector222>:
.globl vector222
vector222:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $222
80107641:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107646:	e9 34 f2 ff ff       	jmp    8010687f <alltraps>

8010764b <vector223>:
.globl vector223
vector223:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $223
8010764d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107652:	e9 28 f2 ff ff       	jmp    8010687f <alltraps>

80107657 <vector224>:
.globl vector224
vector224:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $224
80107659:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010765e:	e9 1c f2 ff ff       	jmp    8010687f <alltraps>

80107663 <vector225>:
.globl vector225
vector225:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $225
80107665:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010766a:	e9 10 f2 ff ff       	jmp    8010687f <alltraps>

8010766f <vector226>:
.globl vector226
vector226:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $226
80107671:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107676:	e9 04 f2 ff ff       	jmp    8010687f <alltraps>

8010767b <vector227>:
.globl vector227
vector227:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $227
8010767d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107682:	e9 f8 f1 ff ff       	jmp    8010687f <alltraps>

80107687 <vector228>:
.globl vector228
vector228:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $228
80107689:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010768e:	e9 ec f1 ff ff       	jmp    8010687f <alltraps>

80107693 <vector229>:
.globl vector229
vector229:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $229
80107695:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010769a:	e9 e0 f1 ff ff       	jmp    8010687f <alltraps>

8010769f <vector230>:
.globl vector230
vector230:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $230
801076a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801076a6:	e9 d4 f1 ff ff       	jmp    8010687f <alltraps>

801076ab <vector231>:
.globl vector231
vector231:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $231
801076ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801076b2:	e9 c8 f1 ff ff       	jmp    8010687f <alltraps>

801076b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $232
801076b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801076be:	e9 bc f1 ff ff       	jmp    8010687f <alltraps>

801076c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $233
801076c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801076ca:	e9 b0 f1 ff ff       	jmp    8010687f <alltraps>

801076cf <vector234>:
.globl vector234
vector234:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $234
801076d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076d6:	e9 a4 f1 ff ff       	jmp    8010687f <alltraps>

801076db <vector235>:
.globl vector235
vector235:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $235
801076dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801076e2:	e9 98 f1 ff ff       	jmp    8010687f <alltraps>

801076e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $236
801076e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801076ee:	e9 8c f1 ff ff       	jmp    8010687f <alltraps>

801076f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $237
801076f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076fa:	e9 80 f1 ff ff       	jmp    8010687f <alltraps>

801076ff <vector238>:
.globl vector238
vector238:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $238
80107701:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107706:	e9 74 f1 ff ff       	jmp    8010687f <alltraps>

8010770b <vector239>:
.globl vector239
vector239:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $239
8010770d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107712:	e9 68 f1 ff ff       	jmp    8010687f <alltraps>

80107717 <vector240>:
.globl vector240
vector240:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $240
80107719:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010771e:	e9 5c f1 ff ff       	jmp    8010687f <alltraps>

80107723 <vector241>:
.globl vector241
vector241:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $241
80107725:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010772a:	e9 50 f1 ff ff       	jmp    8010687f <alltraps>

8010772f <vector242>:
.globl vector242
vector242:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $242
80107731:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107736:	e9 44 f1 ff ff       	jmp    8010687f <alltraps>

8010773b <vector243>:
.globl vector243
vector243:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $243
8010773d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107742:	e9 38 f1 ff ff       	jmp    8010687f <alltraps>

80107747 <vector244>:
.globl vector244
vector244:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $244
80107749:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010774e:	e9 2c f1 ff ff       	jmp    8010687f <alltraps>

80107753 <vector245>:
.globl vector245
vector245:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $245
80107755:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010775a:	e9 20 f1 ff ff       	jmp    8010687f <alltraps>

8010775f <vector246>:
.globl vector246
vector246:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $246
80107761:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107766:	e9 14 f1 ff ff       	jmp    8010687f <alltraps>

8010776b <vector247>:
.globl vector247
vector247:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $247
8010776d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107772:	e9 08 f1 ff ff       	jmp    8010687f <alltraps>

80107777 <vector248>:
.globl vector248
vector248:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $248
80107779:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010777e:	e9 fc f0 ff ff       	jmp    8010687f <alltraps>

80107783 <vector249>:
.globl vector249
vector249:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $249
80107785:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010778a:	e9 f0 f0 ff ff       	jmp    8010687f <alltraps>

8010778f <vector250>:
.globl vector250
vector250:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $250
80107791:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107796:	e9 e4 f0 ff ff       	jmp    8010687f <alltraps>

8010779b <vector251>:
.globl vector251
vector251:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $251
8010779d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801077a2:	e9 d8 f0 ff ff       	jmp    8010687f <alltraps>

801077a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $252
801077a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801077ae:	e9 cc f0 ff ff       	jmp    8010687f <alltraps>

801077b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $253
801077b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801077ba:	e9 c0 f0 ff ff       	jmp    8010687f <alltraps>

801077bf <vector254>:
.globl vector254
vector254:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $254
801077c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801077c6:	e9 b4 f0 ff ff       	jmp    8010687f <alltraps>

801077cb <vector255>:
.globl vector255
vector255:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $255
801077cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077d2:	e9 a8 f0 ff ff       	jmp    8010687f <alltraps>
801077d7:	66 90                	xchg   %ax,%ax
801077d9:	66 90                	xchg   %ax,%ax
801077db:	66 90                	xchg   %ax,%ax
801077dd:	66 90                	xchg   %ax,%ax
801077df:	90                   	nop

801077e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077e6:	89 d3                	mov    %edx,%ebx
{
801077e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801077ea:	c1 eb 16             	shr    $0x16,%ebx
801077ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801077f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801077f3:	8b 06                	mov    (%esi),%eax
801077f5:	a8 01                	test   $0x1,%al
801077f7:	74 27                	je     80107820 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107804:	c1 ef 0a             	shr    $0xa,%edi
}
80107807:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010780a:	89 fa                	mov    %edi,%edx
8010780c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107812:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107815:	5b                   	pop    %ebx
80107816:	5e                   	pop    %esi
80107817:	5f                   	pop    %edi
80107818:	5d                   	pop    %ebp
80107819:	c3                   	ret    
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107820:	85 c9                	test   %ecx,%ecx
80107822:	74 2c                	je     80107850 <walkpgdir+0x70>
80107824:	e8 87 ae ff ff       	call   801026b0 <kalloc>
80107829:	85 c0                	test   %eax,%eax
8010782b:	89 c3                	mov    %eax,%ebx
8010782d:	74 21                	je     80107850 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010782f:	83 ec 04             	sub    $0x4,%esp
80107832:	68 00 10 00 00       	push   $0x1000
80107837:	6a 00                	push   $0x0
80107839:	50                   	push   %eax
8010783a:	e8 21 da ff ff       	call   80105260 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010783f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107845:	83 c4 10             	add    $0x10,%esp
80107848:	83 c8 07             	or     $0x7,%eax
8010784b:	89 06                	mov    %eax,(%esi)
8010784d:	eb b5                	jmp    80107804 <walkpgdir+0x24>
8010784f:	90                   	nop
}
80107850:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107853:	31 c0                	xor    %eax,%eax
}
80107855:	5b                   	pop    %ebx
80107856:	5e                   	pop    %esi
80107857:	5f                   	pop    %edi
80107858:	5d                   	pop    %ebp
80107859:	c3                   	ret    
8010785a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107860 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	57                   	push   %edi
80107864:	56                   	push   %esi
80107865:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107866:	89 d3                	mov    %edx,%ebx
80107868:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010786e:	83 ec 1c             	sub    $0x1c,%esp
80107871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107874:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107878:	8b 7d 08             	mov    0x8(%ebp),%edi
8010787b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107880:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107883:	8b 45 0c             	mov    0xc(%ebp),%eax
80107886:	29 df                	sub    %ebx,%edi
80107888:	83 c8 01             	or     $0x1,%eax
8010788b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010788e:	eb 15                	jmp    801078a5 <mappages+0x45>
    if(*pte & PTE_P)
80107890:	f6 00 01             	testb  $0x1,(%eax)
80107893:	75 45                	jne    801078da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107895:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107898:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010789b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010789d:	74 31                	je     801078d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010789f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801078a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801078ad:	89 da                	mov    %ebx,%edx
801078af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801078b2:	e8 29 ff ff ff       	call   801077e0 <walkpgdir>
801078b7:	85 c0                	test   %eax,%eax
801078b9:	75 d5                	jne    80107890 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801078bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078c3:	5b                   	pop    %ebx
801078c4:	5e                   	pop    %esi
801078c5:	5f                   	pop    %edi
801078c6:	5d                   	pop    %ebp
801078c7:	c3                   	ret    
801078c8:	90                   	nop
801078c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078d3:	31 c0                	xor    %eax,%eax
}
801078d5:	5b                   	pop    %ebx
801078d6:	5e                   	pop    %esi
801078d7:	5f                   	pop    %edi
801078d8:	5d                   	pop    %ebp
801078d9:	c3                   	ret    
      panic("remap");
801078da:	83 ec 0c             	sub    $0xc,%esp
801078dd:	68 64 8c 10 80       	push   $0x80108c64
801078e2:	e8 a9 8a ff ff       	call   80100390 <panic>
801078e7:	89 f6                	mov    %esi,%esi
801078e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078fc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801078fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107904:	83 ec 1c             	sub    $0x1c,%esp
80107907:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010790a:	39 d3                	cmp    %edx,%ebx
8010790c:	73 66                	jae    80107974 <deallocuvm.part.0+0x84>
8010790e:	89 d6                	mov    %edx,%esi
80107910:	eb 3d                	jmp    8010794f <deallocuvm.part.0+0x5f>
80107912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107918:	8b 10                	mov    (%eax),%edx
8010791a:	f6 c2 01             	test   $0x1,%dl
8010791d:	74 26                	je     80107945 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010791f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107925:	74 58                	je     8010797f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107927:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010792a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107930:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107933:	52                   	push   %edx
80107934:	e8 c7 ab ff ff       	call   80102500 <kfree>
      *pte = 0;
80107939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010793c:	83 c4 10             	add    $0x10,%esp
8010793f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107945:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010794b:	39 f3                	cmp    %esi,%ebx
8010794d:	73 25                	jae    80107974 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010794f:	31 c9                	xor    %ecx,%ecx
80107951:	89 da                	mov    %ebx,%edx
80107953:	89 f8                	mov    %edi,%eax
80107955:	e8 86 fe ff ff       	call   801077e0 <walkpgdir>
    if(!pte)
8010795a:	85 c0                	test   %eax,%eax
8010795c:	75 ba                	jne    80107918 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010795e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107964:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010796a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107970:	39 f3                	cmp    %esi,%ebx
80107972:	72 db                	jb     8010794f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107974:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107977:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010797a:	5b                   	pop    %ebx
8010797b:	5e                   	pop    %esi
8010797c:	5f                   	pop    %edi
8010797d:	5d                   	pop    %ebp
8010797e:	c3                   	ret    
        panic("kfree");
8010797f:	83 ec 0c             	sub    $0xc,%esp
80107982:	68 8a 83 10 80       	push   $0x8010838a
80107987:	e8 04 8a ff ff       	call   80100390 <panic>
8010798c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107990 <seginit>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107996:	e8 95 c0 ff ff       	call   80103a30 <cpuid>
8010799b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801079a1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801079a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801079aa:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
801079b1:	ff 00 00 
801079b4:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
801079bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801079be:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
801079c5:	ff 00 00 
801079c8:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
801079cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801079d2:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
801079d9:	ff 00 00 
801079dc:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
801079e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079e6:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
801079ed:	ff 00 00 
801079f0:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
801079f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801079fa:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
801079ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107a03:	c1 e8 10             	shr    $0x10,%eax
80107a06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107a0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107a0d:	0f 01 10             	lgdtl  (%eax)
}
80107a10:	c9                   	leave  
80107a11:	c3                   	ret    
80107a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a20:	a1 44 8e 11 80       	mov    0x80118e44,%eax
{
80107a25:	55                   	push   %ebp
80107a26:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a28:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a2d:	0f 22 d8             	mov    %eax,%cr3
}
80107a30:	5d                   	pop    %ebp
80107a31:	c3                   	ret    
80107a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a40 <switchuvm>:
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 1c             	sub    $0x1c,%esp
80107a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107a4c:	85 db                	test   %ebx,%ebx
80107a4e:	0f 84 cb 00 00 00    	je     80107b1f <switchuvm+0xdf>
  if(p->kstack == 0)
80107a54:	8b 43 08             	mov    0x8(%ebx),%eax
80107a57:	85 c0                	test   %eax,%eax
80107a59:	0f 84 da 00 00 00    	je     80107b39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107a5f:	8b 43 04             	mov    0x4(%ebx),%eax
80107a62:	85 c0                	test   %eax,%eax
80107a64:	0f 84 c2 00 00 00    	je     80107b2c <switchuvm+0xec>
  pushcli();
80107a6a:	e8 11 d6 ff ff       	call   80105080 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a6f:	e8 3c bf ff ff       	call   801039b0 <mycpu>
80107a74:	89 c6                	mov    %eax,%esi
80107a76:	e8 35 bf ff ff       	call   801039b0 <mycpu>
80107a7b:	89 c7                	mov    %eax,%edi
80107a7d:	e8 2e bf ff ff       	call   801039b0 <mycpu>
80107a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a85:	83 c7 08             	add    $0x8,%edi
80107a88:	e8 23 bf ff ff       	call   801039b0 <mycpu>
80107a8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a90:	83 c0 08             	add    $0x8,%eax
80107a93:	ba 67 00 00 00       	mov    $0x67,%edx
80107a98:	c1 e8 18             	shr    $0x18,%eax
80107a9b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107aa2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107aa9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107aaf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107ab4:	83 c1 08             	add    $0x8,%ecx
80107ab7:	c1 e9 10             	shr    $0x10,%ecx
80107aba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107ac0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107ac5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107acc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107ad1:	e8 da be ff ff       	call   801039b0 <mycpu>
80107ad6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107add:	e8 ce be ff ff       	call   801039b0 <mycpu>
80107ae2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107ae6:	8b 73 08             	mov    0x8(%ebx),%esi
80107ae9:	e8 c2 be ff ff       	call   801039b0 <mycpu>
80107aee:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107af4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107af7:	e8 b4 be ff ff       	call   801039b0 <mycpu>
80107afc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107b00:	b8 28 00 00 00       	mov    $0x28,%eax
80107b05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107b08:	8b 43 04             	mov    0x4(%ebx),%eax
80107b0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b10:	0f 22 d8             	mov    %eax,%cr3
}
80107b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b16:	5b                   	pop    %ebx
80107b17:	5e                   	pop    %esi
80107b18:	5f                   	pop    %edi
80107b19:	5d                   	pop    %ebp
  popcli();
80107b1a:	e9 a1 d5 ff ff       	jmp    801050c0 <popcli>
    panic("switchuvm: no process");
80107b1f:	83 ec 0c             	sub    $0xc,%esp
80107b22:	68 6a 8c 10 80       	push   $0x80108c6a
80107b27:	e8 64 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107b2c:	83 ec 0c             	sub    $0xc,%esp
80107b2f:	68 95 8c 10 80       	push   $0x80108c95
80107b34:	e8 57 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107b39:	83 ec 0c             	sub    $0xc,%esp
80107b3c:	68 80 8c 10 80       	push   $0x80108c80
80107b41:	e8 4a 88 ff ff       	call   80100390 <panic>
80107b46:	8d 76 00             	lea    0x0(%esi),%esi
80107b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b50 <inituvm>:
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	53                   	push   %ebx
80107b56:	83 ec 1c             	sub    $0x1c,%esp
80107b59:	8b 75 10             	mov    0x10(%ebp),%esi
80107b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107b62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107b68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107b6b:	77 49                	ja     80107bb6 <inituvm+0x66>
  mem = kalloc();
80107b6d:	e8 3e ab ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107b72:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107b75:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107b77:	68 00 10 00 00       	push   $0x1000
80107b7c:	6a 00                	push   $0x0
80107b7e:	50                   	push   %eax
80107b7f:	e8 dc d6 ff ff       	call   80105260 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b84:	58                   	pop    %eax
80107b85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b8b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b90:	5a                   	pop    %edx
80107b91:	6a 06                	push   $0x6
80107b93:	50                   	push   %eax
80107b94:	31 d2                	xor    %edx,%edx
80107b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b99:	e8 c2 fc ff ff       	call   80107860 <mappages>
  memmove(mem, init, sz);
80107b9e:	89 75 10             	mov    %esi,0x10(%ebp)
80107ba1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107ba4:	83 c4 10             	add    $0x10,%esp
80107ba7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bad:	5b                   	pop    %ebx
80107bae:	5e                   	pop    %esi
80107baf:	5f                   	pop    %edi
80107bb0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107bb1:	e9 5a d7 ff ff       	jmp    80105310 <memmove>
    panic("inituvm: more than a page");
80107bb6:	83 ec 0c             	sub    $0xc,%esp
80107bb9:	68 a9 8c 10 80       	push   $0x80108ca9
80107bbe:	e8 cd 87 ff ff       	call   80100390 <panic>
80107bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107bd0 <loaduvm>:
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107bd9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107be0:	0f 85 91 00 00 00    	jne    80107c77 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107be6:	8b 75 18             	mov    0x18(%ebp),%esi
80107be9:	31 db                	xor    %ebx,%ebx
80107beb:	85 f6                	test   %esi,%esi
80107bed:	75 1a                	jne    80107c09 <loaduvm+0x39>
80107bef:	eb 6f                	jmp    80107c60 <loaduvm+0x90>
80107bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bf8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bfe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107c04:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107c07:	76 57                	jbe    80107c60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c09:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c0f:	31 c9                	xor    %ecx,%ecx
80107c11:	01 da                	add    %ebx,%edx
80107c13:	e8 c8 fb ff ff       	call   801077e0 <walkpgdir>
80107c18:	85 c0                	test   %eax,%eax
80107c1a:	74 4e                	je     80107c6a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107c1c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107c21:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107c26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107c2b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107c31:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c34:	01 d9                	add    %ebx,%ecx
80107c36:	05 00 00 00 80       	add    $0x80000000,%eax
80107c3b:	57                   	push   %edi
80107c3c:	51                   	push   %ecx
80107c3d:	50                   	push   %eax
80107c3e:	ff 75 10             	pushl  0x10(%ebp)
80107c41:	e8 0a 9f ff ff       	call   80101b50 <readi>
80107c46:	83 c4 10             	add    $0x10,%esp
80107c49:	39 f8                	cmp    %edi,%eax
80107c4b:	74 ab                	je     80107bf8 <loaduvm+0x28>
}
80107c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c55:	5b                   	pop    %ebx
80107c56:	5e                   	pop    %esi
80107c57:	5f                   	pop    %edi
80107c58:	5d                   	pop    %ebp
80107c59:	c3                   	ret    
80107c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c63:	31 c0                	xor    %eax,%eax
}
80107c65:	5b                   	pop    %ebx
80107c66:	5e                   	pop    %esi
80107c67:	5f                   	pop    %edi
80107c68:	5d                   	pop    %ebp
80107c69:	c3                   	ret    
      panic("loaduvm: address should exist");
80107c6a:	83 ec 0c             	sub    $0xc,%esp
80107c6d:	68 c3 8c 10 80       	push   $0x80108cc3
80107c72:	e8 19 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c77:	83 ec 0c             	sub    $0xc,%esp
80107c7a:	68 64 8d 10 80       	push   $0x80108d64
80107c7f:	e8 0c 87 ff ff       	call   80100390 <panic>
80107c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c90 <allocuvm>:
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
80107c96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107c99:	8b 7d 10             	mov    0x10(%ebp),%edi
80107c9c:	85 ff                	test   %edi,%edi
80107c9e:	0f 88 8e 00 00 00    	js     80107d32 <allocuvm+0xa2>
  if(newsz < oldsz)
80107ca4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107ca7:	0f 82 93 00 00 00    	jb     80107d40 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cb0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107cb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107cbc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107cbf:	0f 86 7e 00 00 00    	jbe    80107d43 <allocuvm+0xb3>
80107cc5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107cc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ccb:	eb 42                	jmp    80107d0f <allocuvm+0x7f>
80107ccd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107cd0:	83 ec 04             	sub    $0x4,%esp
80107cd3:	68 00 10 00 00       	push   $0x1000
80107cd8:	6a 00                	push   $0x0
80107cda:	50                   	push   %eax
80107cdb:	e8 80 d5 ff ff       	call   80105260 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ce0:	58                   	pop    %eax
80107ce1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ce7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cec:	5a                   	pop    %edx
80107ced:	6a 06                	push   $0x6
80107cef:	50                   	push   %eax
80107cf0:	89 da                	mov    %ebx,%edx
80107cf2:	89 f8                	mov    %edi,%eax
80107cf4:	e8 67 fb ff ff       	call   80107860 <mappages>
80107cf9:	83 c4 10             	add    $0x10,%esp
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	78 50                	js     80107d50 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107d00:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d06:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107d09:	0f 86 81 00 00 00    	jbe    80107d90 <allocuvm+0x100>
    mem = kalloc();
80107d0f:	e8 9c a9 ff ff       	call   801026b0 <kalloc>
    if(mem == 0){
80107d14:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107d16:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107d18:	75 b6                	jne    80107cd0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107d1a:	83 ec 0c             	sub    $0xc,%esp
80107d1d:	68 e1 8c 10 80       	push   $0x80108ce1
80107d22:	e8 39 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107d27:	83 c4 10             	add    $0x10,%esp
80107d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d2d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d30:	77 6e                	ja     80107da0 <allocuvm+0x110>
}
80107d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107d35:	31 ff                	xor    %edi,%edi
}
80107d37:	89 f8                	mov    %edi,%eax
80107d39:	5b                   	pop    %ebx
80107d3a:	5e                   	pop    %esi
80107d3b:	5f                   	pop    %edi
80107d3c:	5d                   	pop    %ebp
80107d3d:	c3                   	ret    
80107d3e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107d40:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d46:	89 f8                	mov    %edi,%eax
80107d48:	5b                   	pop    %ebx
80107d49:	5e                   	pop    %esi
80107d4a:	5f                   	pop    %edi
80107d4b:	5d                   	pop    %ebp
80107d4c:	c3                   	ret    
80107d4d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107d50:	83 ec 0c             	sub    $0xc,%esp
80107d53:	68 f9 8c 10 80       	push   $0x80108cf9
80107d58:	e8 03 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107d5d:	83 c4 10             	add    $0x10,%esp
80107d60:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d63:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d66:	76 0d                	jbe    80107d75 <allocuvm+0xe5>
80107d68:	89 c1                	mov    %eax,%ecx
80107d6a:	8b 55 10             	mov    0x10(%ebp),%edx
80107d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d70:	e8 7b fb ff ff       	call   801078f0 <deallocuvm.part.0>
      kfree(mem);
80107d75:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107d78:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107d7a:	56                   	push   %esi
80107d7b:	e8 80 a7 ff ff       	call   80102500 <kfree>
      return 0;
80107d80:	83 c4 10             	add    $0x10,%esp
}
80107d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d86:	89 f8                	mov    %edi,%eax
80107d88:	5b                   	pop    %ebx
80107d89:	5e                   	pop    %esi
80107d8a:	5f                   	pop    %edi
80107d8b:	5d                   	pop    %ebp
80107d8c:	c3                   	ret    
80107d8d:	8d 76 00             	lea    0x0(%esi),%esi
80107d90:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d96:	5b                   	pop    %ebx
80107d97:	89 f8                	mov    %edi,%eax
80107d99:	5e                   	pop    %esi
80107d9a:	5f                   	pop    %edi
80107d9b:	5d                   	pop    %ebp
80107d9c:	c3                   	ret    
80107d9d:	8d 76 00             	lea    0x0(%esi),%esi
80107da0:	89 c1                	mov    %eax,%ecx
80107da2:	8b 55 10             	mov    0x10(%ebp),%edx
80107da5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107da8:	31 ff                	xor    %edi,%edi
80107daa:	e8 41 fb ff ff       	call   801078f0 <deallocuvm.part.0>
80107daf:	eb 92                	jmp    80107d43 <allocuvm+0xb3>
80107db1:	eb 0d                	jmp    80107dc0 <deallocuvm>
80107db3:	90                   	nop
80107db4:	90                   	nop
80107db5:	90                   	nop
80107db6:	90                   	nop
80107db7:	90                   	nop
80107db8:	90                   	nop
80107db9:	90                   	nop
80107dba:	90                   	nop
80107dbb:	90                   	nop
80107dbc:	90                   	nop
80107dbd:	90                   	nop
80107dbe:	90                   	nop
80107dbf:	90                   	nop

80107dc0 <deallocuvm>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107dcc:	39 d1                	cmp    %edx,%ecx
80107dce:	73 10                	jae    80107de0 <deallocuvm+0x20>
}
80107dd0:	5d                   	pop    %ebp
80107dd1:	e9 1a fb ff ff       	jmp    801078f0 <deallocuvm.part.0>
80107dd6:	8d 76 00             	lea    0x0(%esi),%esi
80107dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107de0:	89 d0                	mov    %edx,%eax
80107de2:	5d                   	pop    %ebp
80107de3:	c3                   	ret    
80107de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107df0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	57                   	push   %edi
80107df4:	56                   	push   %esi
80107df5:	53                   	push   %ebx
80107df6:	83 ec 0c             	sub    $0xc,%esp
80107df9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107dfc:	85 f6                	test   %esi,%esi
80107dfe:	74 59                	je     80107e59 <freevm+0x69>
80107e00:	31 c9                	xor    %ecx,%ecx
80107e02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107e07:	89 f0                	mov    %esi,%eax
80107e09:	e8 e2 fa ff ff       	call   801078f0 <deallocuvm.part.0>
80107e0e:	89 f3                	mov    %esi,%ebx
80107e10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107e16:	eb 0f                	jmp    80107e27 <freevm+0x37>
80107e18:	90                   	nop
80107e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e20:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107e23:	39 fb                	cmp    %edi,%ebx
80107e25:	74 23                	je     80107e4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107e27:	8b 03                	mov    (%ebx),%eax
80107e29:	a8 01                	test   $0x1,%al
80107e2b:	74 f3                	je     80107e20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107e32:	83 ec 0c             	sub    $0xc,%esp
80107e35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107e3d:	50                   	push   %eax
80107e3e:	e8 bd a6 ff ff       	call   80102500 <kfree>
80107e43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107e46:	39 fb                	cmp    %edi,%ebx
80107e48:	75 dd                	jne    80107e27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107e4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e50:	5b                   	pop    %ebx
80107e51:	5e                   	pop    %esi
80107e52:	5f                   	pop    %edi
80107e53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107e54:	e9 a7 a6 ff ff       	jmp    80102500 <kfree>
    panic("freevm: no pgdir");
80107e59:	83 ec 0c             	sub    $0xc,%esp
80107e5c:	68 15 8d 10 80       	push   $0x80108d15
80107e61:	e8 2a 85 ff ff       	call   80100390 <panic>
80107e66:	8d 76 00             	lea    0x0(%esi),%esi
80107e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e70 <setupkvm>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	56                   	push   %esi
80107e74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107e75:	e8 36 a8 ff ff       	call   801026b0 <kalloc>
80107e7a:	85 c0                	test   %eax,%eax
80107e7c:	89 c6                	mov    %eax,%esi
80107e7e:	74 42                	je     80107ec2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107e80:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e83:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107e88:	68 00 10 00 00       	push   $0x1000
80107e8d:	6a 00                	push   $0x0
80107e8f:	50                   	push   %eax
80107e90:	e8 cb d3 ff ff       	call   80105260 <memset>
80107e95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107e98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e9b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e9e:	83 ec 08             	sub    $0x8,%esp
80107ea1:	8b 13                	mov    (%ebx),%edx
80107ea3:	ff 73 0c             	pushl  0xc(%ebx)
80107ea6:	50                   	push   %eax
80107ea7:	29 c1                	sub    %eax,%ecx
80107ea9:	89 f0                	mov    %esi,%eax
80107eab:	e8 b0 f9 ff ff       	call   80107860 <mappages>
80107eb0:	83 c4 10             	add    $0x10,%esp
80107eb3:	85 c0                	test   %eax,%eax
80107eb5:	78 19                	js     80107ed0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107eb7:	83 c3 10             	add    $0x10,%ebx
80107eba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ec0:	75 d6                	jne    80107e98 <setupkvm+0x28>
}
80107ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ec5:	89 f0                	mov    %esi,%eax
80107ec7:	5b                   	pop    %ebx
80107ec8:	5e                   	pop    %esi
80107ec9:	5d                   	pop    %ebp
80107eca:	c3                   	ret    
80107ecb:	90                   	nop
80107ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107ed0:	83 ec 0c             	sub    $0xc,%esp
80107ed3:	56                   	push   %esi
      return 0;
80107ed4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ed6:	e8 15 ff ff ff       	call   80107df0 <freevm>
      return 0;
80107edb:	83 c4 10             	add    $0x10,%esp
}
80107ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ee1:	89 f0                	mov    %esi,%eax
80107ee3:	5b                   	pop    %ebx
80107ee4:	5e                   	pop    %esi
80107ee5:	5d                   	pop    %ebp
80107ee6:	c3                   	ret    
80107ee7:	89 f6                	mov    %esi,%esi
80107ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ef0 <kvmalloc>:
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ef6:	e8 75 ff ff ff       	call   80107e70 <setupkvm>
80107efb:	a3 44 8e 11 80       	mov    %eax,0x80118e44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f00:	05 00 00 00 80       	add    $0x80000000,%eax
80107f05:	0f 22 d8             	mov    %eax,%cr3
}
80107f08:	c9                   	leave  
80107f09:	c3                   	ret    
80107f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f11:	31 c9                	xor    %ecx,%ecx
{
80107f13:	89 e5                	mov    %esp,%ebp
80107f15:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f18:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1e:	e8 bd f8 ff ff       	call   801077e0 <walkpgdir>
  if(pte == 0)
80107f23:	85 c0                	test   %eax,%eax
80107f25:	74 05                	je     80107f2c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107f27:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107f2a:	c9                   	leave  
80107f2b:	c3                   	ret    
    panic("clearpteu");
80107f2c:	83 ec 0c             	sub    $0xc,%esp
80107f2f:	68 26 8d 10 80       	push   $0x80108d26
80107f34:	e8 57 84 ff ff       	call   80100390 <panic>
80107f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107f40:	55                   	push   %ebp
80107f41:	89 e5                	mov    %esp,%ebp
80107f43:	57                   	push   %edi
80107f44:	56                   	push   %esi
80107f45:	53                   	push   %ebx
80107f46:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f49:	e8 22 ff ff ff       	call   80107e70 <setupkvm>
80107f4e:	85 c0                	test   %eax,%eax
80107f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f53:	0f 84 9f 00 00 00    	je     80107ff8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f5c:	85 c9                	test   %ecx,%ecx
80107f5e:	0f 84 94 00 00 00    	je     80107ff8 <copyuvm+0xb8>
80107f64:	31 ff                	xor    %edi,%edi
80107f66:	eb 4a                	jmp    80107fb2 <copyuvm+0x72>
80107f68:	90                   	nop
80107f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f70:	83 ec 04             	sub    $0x4,%esp
80107f73:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107f79:	68 00 10 00 00       	push   $0x1000
80107f7e:	53                   	push   %ebx
80107f7f:	50                   	push   %eax
80107f80:	e8 8b d3 ff ff       	call   80105310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f85:	58                   	pop    %eax
80107f86:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f8c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f91:	5a                   	pop    %edx
80107f92:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f95:	50                   	push   %eax
80107f96:	89 fa                	mov    %edi,%edx
80107f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f9b:	e8 c0 f8 ff ff       	call   80107860 <mappages>
80107fa0:	83 c4 10             	add    $0x10,%esp
80107fa3:	85 c0                	test   %eax,%eax
80107fa5:	78 61                	js     80108008 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107fa7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107fad:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107fb0:	76 46                	jbe    80107ff8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb5:	31 c9                	xor    %ecx,%ecx
80107fb7:	89 fa                	mov    %edi,%edx
80107fb9:	e8 22 f8 ff ff       	call   801077e0 <walkpgdir>
80107fbe:	85 c0                	test   %eax,%eax
80107fc0:	74 61                	je     80108023 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107fc2:	8b 00                	mov    (%eax),%eax
80107fc4:	a8 01                	test   $0x1,%al
80107fc6:	74 4e                	je     80108016 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107fc8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107fca:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107fcf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107fd8:	e8 d3 a6 ff ff       	call   801026b0 <kalloc>
80107fdd:	85 c0                	test   %eax,%eax
80107fdf:	89 c6                	mov    %eax,%esi
80107fe1:	75 8d                	jne    80107f70 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107fe3:	83 ec 0c             	sub    $0xc,%esp
80107fe6:	ff 75 e0             	pushl  -0x20(%ebp)
80107fe9:	e8 02 fe ff ff       	call   80107df0 <freevm>
  return 0;
80107fee:	83 c4 10             	add    $0x10,%esp
80107ff1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ffe:	5b                   	pop    %ebx
80107fff:	5e                   	pop    %esi
80108000:	5f                   	pop    %edi
80108001:	5d                   	pop    %ebp
80108002:	c3                   	ret    
80108003:	90                   	nop
80108004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108008:	83 ec 0c             	sub    $0xc,%esp
8010800b:	56                   	push   %esi
8010800c:	e8 ef a4 ff ff       	call   80102500 <kfree>
      goto bad;
80108011:	83 c4 10             	add    $0x10,%esp
80108014:	eb cd                	jmp    80107fe3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108016:	83 ec 0c             	sub    $0xc,%esp
80108019:	68 4a 8d 10 80       	push   $0x80108d4a
8010801e:	e8 6d 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108023:	83 ec 0c             	sub    $0xc,%esp
80108026:	68 30 8d 10 80       	push   $0x80108d30
8010802b:	e8 60 83 ff ff       	call   80100390 <panic>

80108030 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108030:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108031:	31 c9                	xor    %ecx,%ecx
{
80108033:	89 e5                	mov    %esp,%ebp
80108035:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108038:	8b 55 0c             	mov    0xc(%ebp),%edx
8010803b:	8b 45 08             	mov    0x8(%ebp),%eax
8010803e:	e8 9d f7 ff ff       	call   801077e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108043:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108045:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108046:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108048:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010804d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108050:	05 00 00 00 80       	add    $0x80000000,%eax
80108055:	83 fa 05             	cmp    $0x5,%edx
80108058:	ba 00 00 00 00       	mov    $0x0,%edx
8010805d:	0f 45 c2             	cmovne %edx,%eax
}
80108060:	c3                   	ret    
80108061:	eb 0d                	jmp    80108070 <copyout>
80108063:	90                   	nop
80108064:	90                   	nop
80108065:	90                   	nop
80108066:	90                   	nop
80108067:	90                   	nop
80108068:	90                   	nop
80108069:	90                   	nop
8010806a:	90                   	nop
8010806b:	90                   	nop
8010806c:	90                   	nop
8010806d:	90                   	nop
8010806e:	90                   	nop
8010806f:	90                   	nop

80108070 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	57                   	push   %edi
80108074:	56                   	push   %esi
80108075:	53                   	push   %ebx
80108076:	83 ec 1c             	sub    $0x1c,%esp
80108079:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010807c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010807f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108082:	85 db                	test   %ebx,%ebx
80108084:	75 40                	jne    801080c6 <copyout+0x56>
80108086:	eb 70                	jmp    801080f8 <copyout+0x88>
80108088:	90                   	nop
80108089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108093:	89 f1                	mov    %esi,%ecx
80108095:	29 d1                	sub    %edx,%ecx
80108097:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010809d:	39 d9                	cmp    %ebx,%ecx
8010809f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801080a2:	29 f2                	sub    %esi,%edx
801080a4:	83 ec 04             	sub    $0x4,%esp
801080a7:	01 d0                	add    %edx,%eax
801080a9:	51                   	push   %ecx
801080aa:	57                   	push   %edi
801080ab:	50                   	push   %eax
801080ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801080af:	e8 5c d2 ff ff       	call   80105310 <memmove>
    len -= n;
    buf += n;
801080b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801080b7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801080ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801080c0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801080c2:	29 cb                	sub    %ecx,%ebx
801080c4:	74 32                	je     801080f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801080c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801080c8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801080cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801080ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801080d4:	56                   	push   %esi
801080d5:	ff 75 08             	pushl  0x8(%ebp)
801080d8:	e8 53 ff ff ff       	call   80108030 <uva2ka>
    if(pa0 == 0)
801080dd:	83 c4 10             	add    $0x10,%esp
801080e0:	85 c0                	test   %eax,%eax
801080e2:	75 ac                	jne    80108090 <copyout+0x20>
  }
  return 0;
}
801080e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080ec:	5b                   	pop    %ebx
801080ed:	5e                   	pop    %esi
801080ee:	5f                   	pop    %edi
801080ef:	5d                   	pop    %ebp
801080f0:	c3                   	ret    
801080f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080fb:	31 c0                	xor    %eax,%eax
}
801080fd:	5b                   	pop    %ebx
801080fe:	5e                   	pop    %esi
801080ff:	5f                   	pop    %edi
80108100:	5d                   	pop    %ebp
80108101:	c3                   	ret    
