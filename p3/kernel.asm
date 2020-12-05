
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
8010004c:	68 40 80 10 80       	push   $0x80108040
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 c5 4c 00 00       	call   80104d20 <initlock>
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
80100092:	68 47 80 10 80       	push   $0x80108047
80100097:	50                   	push   %eax
80100098:	e8 53 4b 00 00       	call   80104bf0 <initsleeplock>
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
801000e4:	e8 77 4d 00 00       	call   80104e60 <acquire>
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
80100162:	e8 b9 4d 00 00       	call   80104f20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 4a 00 00       	call   80104c30 <acquiresleep>
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
80100193:	68 4e 80 10 80       	push   $0x8010804e
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
801001ae:	e8 1d 4b 00 00       	call   80104cd0 <holdingsleep>
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
801001cc:	68 5f 80 10 80       	push   $0x8010805f
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
801001ef:	e8 dc 4a 00 00       	call   80104cd0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 4a 00 00       	call   80104c90 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 50 4c 00 00       	call   80104e60 <acquire>
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
8010025c:	e9 bf 4c 00 00       	jmp    80104f20 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 80 10 80       	push   $0x80108066
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
8010028c:	e8 cf 4b 00 00       	call   80104e60 <acquire>
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
801002c5:	e8 26 3f 00 00       	call   801041f0 <sleep>
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
801002ef:	e8 2c 4c 00 00       	call   80104f20 <release>
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
8010034d:	e8 ce 4b 00 00       	call   80104f20 <release>
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
801003b2:	68 6d 80 10 80       	push   $0x8010806d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 33 8c 10 80 	movl   $0x80108c33,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 49 00 00       	call   80104d40 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 80 10 80       	push   $0x80108081
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
8010043a:	e8 11 68 00 00       	call   80106c50 <uartputc>
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
801004ec:	e8 5f 67 00 00       	call   80106c50 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 67 00 00       	call   80106c50 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 67 00 00       	call   80106c50 <uartputc>
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
80100524:	e8 f7 4a 00 00       	call   80105020 <memmove>
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
80100541:	e8 2a 4a 00 00       	call   80104f70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 80 10 80       	push   $0x80108085
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
801005b1:	0f b6 92 b0 80 10 80 	movzbl -0x7fef7f50(%edx),%edx
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
8010061b:	e8 40 48 00 00       	call   80104e60 <acquire>
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
80100647:	e8 d4 48 00 00       	call   80104f20 <release>
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
8010071f:	e8 fc 47 00 00       	call   80104f20 <release>
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
801007d0:	ba 98 80 10 80       	mov    $0x80108098,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 6b 46 00 00       	call   80104e60 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 80 10 80       	push   $0x8010809f
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
80100821:	e8 3a 46 00 00       	call   80104e60 <acquire>
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
801008d0:	e8 4b 46 00 00       	call   80104f20 <release>
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
80100b21:	e8 8a 38 00 00       	call   801043b0 <wakeup>
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
80100b67:	e9 24 39 00 00       	jmp    80104490 <procdump>
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
80100b96:	68 a8 80 10 80       	push   $0x801080a8
80100b9b:	68 20 b5 10 80       	push   $0x8010b520
80100ba0:	e8 7b 41 00 00       	call   80104d20 <initlock>

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
80100c64:	e8 37 71 00 00       	call   80107da0 <setupkvm>
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
80100cc6:	e8 f5 6e 00 00       	call   80107bc0 <allocuvm>
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
80100cf8:	e8 03 6e 00 00       	call   80107b00 <loaduvm>
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
80100d42:	e8 d9 6f 00 00       	call   80107d20 <freevm>
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
80100d7a:	e8 41 6e 00 00       	call   80107bc0 <allocuvm>
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	85 c0                	test   %eax,%eax
80100d84:	89 c6                	mov    %eax,%esi
80100d86:	75 3a                	jne    80100dc2 <exec+0x1e2>
    freevm(pgdir);
80100d88:	83 ec 0c             	sub    $0xc,%esp
80100d8b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d91:	e8 8a 6f 00 00       	call   80107d20 <freevm>
80100d96:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d9e:	e9 a9 fe ff ff       	jmp    80100c4c <exec+0x6c>
    end_op();
80100da3:	e8 38 20 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100da8:	83 ec 0c             	sub    $0xc,%esp
80100dab:	68 c1 80 10 80       	push   $0x801080c1
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
80100dd6:	e8 65 70 00 00       	call   80107e40 <clearpteu>
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
80100e09:	e8 82 43 00 00       	call   80105190 <strlen>
80100e0e:	f7 d0                	not    %eax
80100e10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e15:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e1c:	e8 6f 43 00 00       	call   80105190 <strlen>
80100e21:	83 c0 01             	add    $0x1,%eax
80100e24:	50                   	push   %eax
80100e25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e2b:	53                   	push   %ebx
80100e2c:	56                   	push   %esi
80100e2d:	e8 6e 71 00 00       	call   80107fa0 <copyout>
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
80100e97:	e8 04 71 00 00       	call   80107fa0 <copyout>
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
80100eda:	e8 71 42 00 00       	call   80105150 <safestrcpy>
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
80100f04:	e8 67 6a 00 00       	call   80107970 <switchuvm>
  freevm(oldpgdir);
80100f09:	89 3c 24             	mov    %edi,(%esp)
80100f0c:	e8 0f 6e 00 00       	call   80107d20 <freevm>
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
80100f36:	68 cd 80 10 80       	push   $0x801080cd
80100f3b:	68 60 10 11 80       	push   $0x80111060
80100f40:	e8 db 3d 00 00       	call   80104d20 <initlock>
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
80100f61:	e8 fa 3e 00 00       	call   80104e60 <acquire>
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
80100f91:	e8 8a 3f 00 00       	call   80104f20 <release>
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
80100faa:	e8 71 3f 00 00       	call   80104f20 <release>
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
80100fcf:	e8 8c 3e 00 00       	call   80104e60 <acquire>
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
80100fec:	e8 2f 3f 00 00       	call   80104f20 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 d4 80 10 80       	push   $0x801080d4
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
80101021:	e8 3a 3e 00 00       	call   80104e60 <acquire>
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
8010104c:	e9 cf 3e 00 00       	jmp    80104f20 <release>
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
80101078:	e8 a3 3e 00 00       	call   80104f20 <release>
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
801010d2:	68 dc 80 10 80       	push   $0x801080dc
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
801011b2:	68 e6 80 10 80       	push   $0x801080e6
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
801012c5:	68 ef 80 10 80       	push   $0x801080ef
801012ca:	e8 c1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	68 f5 80 10 80       	push   $0x801080f5
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
80101343:	68 ff 80 10 80       	push   $0x801080ff
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
801013f4:	68 12 81 10 80       	push   $0x80108112
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
80101435:	e8 36 3b 00 00       	call   80104f70 <memset>
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
8010147a:	e8 e1 39 00 00       	call   80104e60 <acquire>
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
801014df:	e8 3c 3a 00 00       	call   80104f20 <release>

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
8010150d:	e8 0e 3a 00 00       	call   80104f20 <release>
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
80101522:	68 28 81 10 80       	push   $0x80108128
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
801015f7:	68 38 81 10 80       	push   $0x80108138
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
80101631:	e8 ea 39 00 00       	call   80105020 <memmove>
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
8010165c:	68 4b 81 10 80       	push   $0x8010814b
80101661:	68 80 1a 11 80       	push   $0x80111a80
80101666:	e8 b5 36 00 00       	call   80104d20 <initlock>
8010166b:	83 c4 10             	add    $0x10,%esp
8010166e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101670:	83 ec 08             	sub    $0x8,%esp
80101673:	68 52 81 10 80       	push   $0x80108152
80101678:	53                   	push   %ebx
80101679:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010167f:	e8 6c 35 00 00       	call   80104bf0 <initsleeplock>
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
801016c9:	68 b8 81 10 80       	push   $0x801081b8
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
8010175e:	e8 0d 38 00 00       	call   80104f70 <memset>
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
80101793:	68 58 81 10 80       	push   $0x80108158
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
80101801:	e8 1a 38 00 00       	call   80105020 <memmove>
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
8010182f:	e8 2c 36 00 00       	call   80104e60 <acquire>
  ip->ref++;
80101834:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101838:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010183f:	e8 dc 36 00 00       	call   80104f20 <release>
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
80101872:	e8 b9 33 00 00       	call   80104c30 <acquiresleep>
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
801018e8:	e8 33 37 00 00       	call   80105020 <memmove>
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
8010190d:	68 70 81 10 80       	push   $0x80108170
80101912:	e8 79 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101917:	83 ec 0c             	sub    $0xc,%esp
8010191a:	68 6a 81 10 80       	push   $0x8010816a
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
80101943:	e8 88 33 00 00       	call   80104cd0 <holdingsleep>
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
8010195f:	e9 2c 33 00 00       	jmp    80104c90 <releasesleep>
    panic("iunlock");
80101964:	83 ec 0c             	sub    $0xc,%esp
80101967:	68 7f 81 10 80       	push   $0x8010817f
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
80101990:	e8 9b 32 00 00       	call   80104c30 <acquiresleep>
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
801019aa:	e8 e1 32 00 00       	call   80104c90 <releasesleep>
  acquire(&icache.lock);
801019af:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801019b6:	e8 a5 34 00 00       	call   80104e60 <acquire>
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
801019d0:	e9 4b 35 00 00       	jmp    80104f20 <release>
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019d8:	83 ec 0c             	sub    $0xc,%esp
801019db:	68 80 1a 11 80       	push   $0x80111a80
801019e0:	e8 7b 34 00 00       	call   80104e60 <acquire>
    int r = ip->ref;
801019e5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019e8:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801019ef:	e8 2c 35 00 00       	call   80104f20 <release>
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
80101bd7:	e8 44 34 00 00       	call   80105020 <memmove>
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
80101cd3:	e8 48 33 00 00       	call   80105020 <memmove>
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
80101d6e:	e8 1d 33 00 00       	call   80105090 <strncmp>
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
80101dcd:	e8 be 32 00 00       	call   80105090 <strncmp>
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
80101e12:	68 99 81 10 80       	push   $0x80108199
80101e17:	e8 74 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	68 87 81 10 80       	push   $0x80108187
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
80101e59:	e8 02 30 00 00       	call   80104e60 <acquire>
  ip->ref++;
80101e5e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e62:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101e69:	e8 b2 30 00 00       	call   80104f20 <release>
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
80101ec5:	e8 56 31 00 00       	call   80105020 <memmove>
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
80101f58:	e8 c3 30 00 00       	call   80105020 <memmove>
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
8010204d:	e8 9e 30 00 00       	call   801050f0 <strncpy>
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
8010208b:	68 a8 81 10 80       	push   $0x801081a8
80102090:	e8 fb e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 1e 8a 10 80       	push   $0x80108a1e
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
801021ab:	68 14 82 10 80       	push   $0x80108214
801021b0:	e8 db e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 0b 82 10 80       	push   $0x8010820b
801021bd:	e8 ce e1 ff ff       	call   80100390 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 26 82 10 80       	push   $0x80108226
801021db:	68 80 b5 10 80       	push   $0x8010b580
801021e0:	e8 3b 2b 00 00       	call   80104d20 <initlock>
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
8010225e:	e8 fd 2b 00 00       	call   80104e60 <acquire>

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
801022c1:	e8 ea 20 00 00       	call   801043b0 <wakeup>

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
801022df:	e8 3c 2c 00 00       	call   80104f20 <release>

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
801022fe:	e8 cd 29 00 00       	call   80104cd0 <holdingsleep>
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
80102338:	e8 23 2b 00 00       	call   80104e60 <acquire>

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
80102389:	e8 62 1e 00 00       	call   801041f0 <sleep>
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
801023a6:	e9 75 2b 00 00       	jmp    80104f20 <release>
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
801023ca:	68 40 82 10 80       	push   $0x80108240
801023cf:	e8 bc df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 2a 82 10 80       	push   $0x8010822a
801023dc:	e8 af df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 55 82 10 80       	push   $0x80108255
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
80102437:	68 74 82 10 80       	push   $0x80108274
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
801024f2:	81 fb 48 8e 11 80    	cmp    $0x80118e48,%ebx
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
80102512:	e8 59 2a 00 00       	call   80104f70 <memset>

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
8010254b:	e9 d0 29 00 00       	jmp    80104f20 <release>
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 e0 36 11 80       	push   $0x801136e0
80102558:	e8 03 29 00 00       	call   80104e60 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb c2                	jmp    80102524 <kfree+0x44>
    panic("kfree");
80102562:	83 ec 0c             	sub    $0xc,%esp
80102565:	68 a6 82 10 80       	push   $0x801082a6
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
801025cb:	68 ac 82 10 80       	push   $0x801082ac
801025d0:	68 e0 36 11 80       	push   $0x801136e0
801025d5:	e8 46 27 00 00       	call   80104d20 <initlock>
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
801026c3:	e8 98 27 00 00       	call   80104e60 <acquire>
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
801026f1:	e8 2a 28 00 00       	call   80104f20 <release>
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
80102743:	0f b6 82 e0 83 10 80 	movzbl -0x7fef7c20(%edx),%eax
8010274a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010274c:	0f b6 82 e0 82 10 80 	movzbl -0x7fef7d20(%edx),%eax
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
80102763:	8b 04 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%eax
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
80102788:	0f b6 82 e0 83 10 80 	movzbl -0x7fef7c20(%edx),%eax
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
80102b07:	e8 b4 24 00 00       	call   80104fc0 <memcmp>
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
80102c34:	e8 e7 23 00 00       	call   80105020 <memmove>
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
80102cda:	68 e0 84 10 80       	push   $0x801084e0
80102cdf:	68 20 37 11 80       	push   $0x80113720
80102ce4:	e8 37 20 00 00       	call   80104d20 <initlock>
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
80102d7b:	e8 e0 20 00 00       	call   80104e60 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 20 37 11 80       	push   $0x80113720
80102d90:	68 20 37 11 80       	push   $0x80113720
80102d95:	e8 56 14 00 00       	call   801041f0 <sleep>
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
80102dcc:	e8 4f 21 00 00       	call   80104f20 <release>
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
80102dee:	e8 6d 20 00 00       	call   80104e60 <acquire>
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
80102e2c:	e8 ef 20 00 00       	call   80104f20 <release>
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
80102e86:	e8 95 21 00 00       	call   80105020 <memmove>
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
80102ecf:	e8 8c 1f 00 00       	call   80104e60 <acquire>
    wakeup(&log);
80102ed4:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
80102edb:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80102ee2:	00 00 00 
    wakeup(&log);
80102ee5:	e8 c6 14 00 00       	call   801043b0 <wakeup>
    release(&log.lock);
80102eea:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102ef1:	e8 2a 20 00 00       	call   80104f20 <release>
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
80102f10:	e8 9b 14 00 00       	call   801043b0 <wakeup>
  release(&log.lock);
80102f15:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102f1c:	e8 ff 1f 00 00       	call   80104f20 <release>
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
80102f2f:	68 e4 84 10 80       	push   $0x801084e4
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
80102f7e:	e8 dd 1e 00 00       	call   80104e60 <acquire>
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
80102fcd:	e9 4e 1f 00 00       	jmp    80104f20 <release>
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
80102ff9:	68 f3 84 10 80       	push   $0x801084f3
80102ffe:	e8 8d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103003:	83 ec 0c             	sub    $0xc,%esp
80103006:	68 09 85 10 80       	push   $0x80108509
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
80103028:	68 24 85 10 80       	push   $0x80108524
8010302d:	e8 2e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103032:	e8 19 38 00 00       	call   80106850 <idtinit>
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
8010304a:	e8 a1 0e 00 00       	call   80103ef0 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 f5 48 00 00       	call   80107950 <switchkvm>
  seginit();
8010305b:	e8 60 48 00 00       	call   801078c0 <seginit>
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
80103087:	68 48 8e 11 80       	push   $0x80118e48
8010308c:	e8 2f f5 ff ff       	call   801025c0 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 8a 4d 00 00       	call   80107e20 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 75 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 1b 48 00 00       	call   801078c0 <seginit>
  picinit();       // disable pic
801030a5:	e8 46 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 41 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 dc da ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 d7 3a 00 00       	call   80106b90 <uartinit>
  pinit();         // process table
801030b9:	e8 32 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 0d 37 00 00       	call   801067d0 <tvinit>
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
801030e4:	e8 37 1f 00 00       	call   80105020 <memmove>

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
801031be:	68 38 85 10 80       	push   $0x80108538
801031c3:	56                   	push   %esi
801031c4:	e8 f7 1d 00 00       	call   80104fc0 <memcmp>
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
8010327c:	68 55 85 10 80       	push   $0x80108555
80103281:	56                   	push   %esi
80103282:	e8 39 1d 00 00       	call   80104fc0 <memcmp>
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
80103310:	ff 24 95 7c 85 10 80 	jmp    *-0x7fef7a84(,%edx,4)
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
801033c3:	68 3d 85 10 80       	push   $0x8010853d
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 5c 85 10 80       	push   $0x8010855c
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
801034cb:	68 90 85 10 80       	push   $0x80108590
801034d0:	50                   	push   %eax
801034d1:	e8 4a 18 00 00       	call   80104d20 <initlock>
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
8010352f:	e8 2c 19 00 00       	call   80104e60 <acquire>
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
8010354f:	e8 5c 0e 00 00       	call   801043b0 <wakeup>
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
80103574:	e9 a7 19 00 00       	jmp    80104f20 <release>
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103580:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103586:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 17 0e 00 00       	call   801043b0 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb b9                	jmp    80103557 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 77 19 00 00       	call   80104f20 <release>
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
801035cd:	e8 8e 18 00 00       	call   80104e60 <acquire>
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
80103624:	e8 87 0d 00 00       	call   801043b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103629:	5a                   	pop    %edx
8010362a:	59                   	pop    %ecx
8010362b:	53                   	push   %ebx
8010362c:	56                   	push   %esi
8010362d:	e8 be 0b 00 00       	call   801041f0 <sleep>
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
80103664:	e8 b7 18 00 00       	call   80104f20 <release>
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
801036b3:	e8 f8 0c 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
801036b8:	89 1c 24             	mov    %ebx,(%esp)
801036bb:	e8 60 18 00 00       	call   80104f20 <release>
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
801036e0:	e8 7b 17 00 00       	call   80104e60 <acquire>
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
80103715:	e8 d6 0a 00 00       	call   801041f0 <sleep>
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
8010374e:	e8 cd 17 00 00       	call   80104f20 <release>
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
801037a7:	e8 04 0c 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
801037ac:	89 34 24             	mov    %esi,(%esp)
801037af:	e8 6c 17 00 00       	call   80104f20 <release>
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
801037e1:	e8 7a 16 00 00       	call   80104e60 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 13                	jmp    801037fe <allocproc+0x2e>
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	81 c3 20 01 00 00    	add    $0x120,%ebx
801037f6:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
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
80103825:	e8 f6 16 00 00       	call   80104f20 <release>

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
8010384a:	c7 40 14 c3 67 10 80 	movl   $0x801067c3,0x14(%eax)
  p->context = (struct context*)sp;
80103851:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103854:	6a 14                	push   $0x14
80103856:	6a 00                	push   $0x0
80103858:	50                   	push   %eax
80103859:	e8 12 17 00 00       	call   80104f70 <memset>
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
80103882:	e8 99 16 00 00       	call   80104f20 <release>
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
801038ab:	e8 70 16 00 00       	call   80104f20 <release>

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
801038f6:	68 95 85 10 80       	push   $0x80108595
801038fb:	68 c0 3d 11 80       	push   $0x80113dc0
80103900:	e8 1b 14 00 00       	call   80104d20 <initlock>
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
80103970:	68 9c 85 10 80       	push   $0x8010859c
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 54 87 10 80       	push   $0x80108754
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
801039b7:	e8 d4 13 00 00       	call   80104d90 <pushcli>
  c = mycpu();
801039bc:	e8 4f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c7:	e8 04 14 00 00       	call   80104dd0 <popcli>
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
801039f3:	e8 a8 43 00 00       	call   80107da0 <setupkvm>
801039f8:	85 c0                	test   %eax,%eax
801039fa:	89 43 04             	mov    %eax,0x4(%ebx)
801039fd:	0f 84 bd 00 00 00    	je     80103ac0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a03:	83 ec 04             	sub    $0x4,%esp
80103a06:	68 2c 00 00 00       	push   $0x2c
80103a0b:	68 60 b4 10 80       	push   $0x8010b460
80103a10:	50                   	push   %eax
80103a11:	e8 6a 40 00 00       	call   80107a80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1f:	6a 4c                	push   $0x4c
80103a21:	6a 00                	push   $0x0
80103a23:	ff 73 18             	pushl  0x18(%ebx)
80103a26:	e8 45 15 00 00       	call   80104f70 <memset>
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
80103a7f:	68 c5 85 10 80       	push   $0x801085c5
80103a84:	50                   	push   %eax
80103a85:	e8 c6 16 00 00       	call   80105150 <safestrcpy>
  p->cwd = namei("/");
80103a8a:	c7 04 24 ce 85 10 80 	movl   $0x801085ce,(%esp)
80103a91:	e8 1a e6 ff ff       	call   801020b0 <namei>
80103a96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a99:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103aa0:	e8 bb 13 00 00       	call   80104e60 <acquire>
  p->state = RUNNABLE;
80103aa5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aac:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103ab3:	e8 68 14 00 00       	call   80104f20 <release>
}
80103ab8:	83 c4 10             	add    $0x10,%esp
80103abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abe:	c9                   	leave  
80103abf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 ac 85 10 80       	push   $0x801085ac
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
80103ad8:	e8 b3 12 00 00       	call   80104d90 <pushcli>
  c = mycpu();
80103add:	e8 2e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 e3 12 00 00       	call   80104dd0 <popcli>
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
80103afc:	e8 6f 3e 00 00       	call   80107970 <switchuvm>
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
80103b1a:	e8 a1 40 00 00       	call   80107bc0 <allocuvm>
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
80103b3a:	e8 b1 41 00 00       	call   80107cf0 <deallocuvm>
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
80103b59:	e8 32 12 00 00       	call   80104d90 <pushcli>
  c = mycpu();
80103b5e:	e8 ad fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b69:	e8 62 12 00 00       	call   80104dd0 <popcli>
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
80103b88:	e8 e3 42 00 00       	call   80107e70 <copyuvm>
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
80103c01:	e8 4a 15 00 00       	call   80105150 <safestrcpy>
  pid = np->pid;
80103c06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c09:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c10:	e8 4b 12 00 00       	call   80104e60 <acquire>
  np->state = RUNNABLE;
80103c15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c1c:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c23:	e8 f8 12 00 00       	call   80104f20 <release>
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
80103c76:	83 ec 08             	sub    $0x8,%esp
80103c79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103c7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for (int i=0; i < size; i++){
80103c7f:	85 db                	test   %ebx,%ebx
  struct proc* chosen = list[0];
80103c81:	8b 07                	mov    (%edi),%eax
  for (int i=0; i < size; i++){
80103c83:	0f 8e a7 00 00 00    	jle    80103d30 <BJF+0xc0>
    if (list[i] -> state == RUNNABLE){
80103c89:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c8d:	0f 84 fd 00 00 00    	je     80103d90 <BJF+0x120>
  for (int i=0; i < size; i++){
80103c93:	31 c9                	xor    %ecx,%ecx
80103c95:	eb 18                	jmp    80103caf <BJF+0x3f>
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (list[i] -> state == RUNNABLE){
80103ca0:	8b 34 97             	mov    (%edi,%edx,4),%esi
80103ca3:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103ca7:	0f 84 93 00 00 00    	je     80103d40 <BJF+0xd0>
80103cad:	89 d1                	mov    %edx,%ecx
  for (int i=0; i < size; i++){
80103caf:	8d 51 01             	lea    0x1(%ecx),%edx
80103cb2:	39 d3                	cmp    %edx,%ebx
80103cb4:	75 ea                	jne    80103ca0 <BJF+0x30>
80103cb6:	b9 01 00 00 00       	mov    $0x1,%ecx
  int rank = 0, ind = 0;
80103cbb:	31 f6                	xor    %esi,%esi
  for (int i=ind + 1; i < size; i++){
80103cbd:	39 cb                	cmp    %ecx,%ebx
80103cbf:	7e 6f                	jle    80103d30 <BJF+0xc0>
80103cc1:	8d 0c 8f             	lea    (%edi,%ecx,4),%ecx
80103cc4:	8d 3c 9f             	lea    (%edi,%ebx,4),%edi
80103cc7:	eb 0e                	jmp    80103cd7 <BJF+0x67>
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cd0:	83 c1 04             	add    $0x4,%ecx
80103cd3:	39 cf                	cmp    %ecx,%edi
80103cd5:	74 59                	je     80103d30 <BJF+0xc0>
    if (list[i]->state == RUNNABLE){
80103cd7:	8b 11                	mov    (%ecx),%edx
80103cd9:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103cdd:	75 f1                	jne    80103cd0 <BJF+0x60>
      int cur_rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103cdf:	d9 82 f8 00 00 00    	flds   0xf8(%edx)
80103ce5:	d8 8a fc 00 00 00    	fmuls  0xfc(%edx)
80103ceb:	d9 82 00 01 00 00    	flds   0x100(%edx)
80103cf1:	d8 8a 04 01 00 00    	fmuls  0x104(%edx)
80103cf7:	de c1                	faddp  %st,%st(1)
80103cf9:	d9 82 08 01 00 00    	flds   0x108(%edx)
80103cff:	d8 8a 0c 01 00 00    	fmuls  0x10c(%edx)
80103d05:	d9 7d f2             	fnstcw -0xe(%ebp)
80103d08:	0f b7 5d f2          	movzwl -0xe(%ebp),%ebx
80103d0c:	80 cf 0c             	or     $0xc,%bh
80103d0f:	66 89 5d f0          	mov    %bx,-0x10(%ebp)
80103d13:	de c1                	faddp  %st,%st(1)
80103d15:	d9 6d f0             	fldcw  -0x10(%ebp)
80103d18:	db 5d ec             	fistpl -0x14(%ebp)
80103d1b:	d9 6d f2             	fldcw  -0xe(%ebp)
80103d1e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
      if (cur_rank < rank){
80103d21:	39 f3                	cmp    %esi,%ebx
80103d23:	7d ab                	jge    80103cd0 <BJF+0x60>
80103d25:	83 c1 04             	add    $0x4,%ecx
80103d28:	89 de                	mov    %ebx,%esi
80103d2a:	89 d0                	mov    %edx,%eax
  for (int i=ind + 1; i < size; i++){
80103d2c:	39 cf                	cmp    %ecx,%edi
80103d2e:	75 a7                	jne    80103cd7 <BJF+0x67>
}
80103d30:	83 c4 08             	add    $0x8,%esp
80103d33:	5b                   	pop    %ebx
80103d34:	5e                   	pop    %esi
80103d35:	5f                   	pop    %edi
80103d36:	5d                   	pop    %ebp
80103d37:	c3                   	ret    
80103d38:	90                   	nop
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d40:	83 c1 02             	add    $0x2,%ecx
    if (list[i] -> state == RUNNABLE){
80103d43:	89 f0                	mov    %esi,%eax
      rank =  list[i]->priority * list[i]->priority_ratio + list[i]->arrivt * list[i]->arrivt_ratio + list[i]->exect * list[i]->exect_ratio;
80103d45:	d9 80 f8 00 00 00    	flds   0xf8(%eax)
80103d4b:	d8 88 fc 00 00 00    	fmuls  0xfc(%eax)
80103d51:	d9 80 00 01 00 00    	flds   0x100(%eax)
80103d57:	d8 88 04 01 00 00    	fmuls  0x104(%eax)
80103d5d:	de c1                	faddp  %st,%st(1)
80103d5f:	d9 80 08 01 00 00    	flds   0x108(%eax)
80103d65:	d8 88 0c 01 00 00    	fmuls  0x10c(%eax)
80103d6b:	d9 7d f2             	fnstcw -0xe(%ebp)
80103d6e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
80103d72:	80 ce 0c             	or     $0xc,%dh
80103d75:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
80103d79:	de c1                	faddp  %st,%st(1)
80103d7b:	d9 6d f0             	fldcw  -0x10(%ebp)
80103d7e:	db 5d ec             	fistpl -0x14(%ebp)
80103d81:	d9 6d f2             	fldcw  -0xe(%ebp)
80103d84:	8b 75 ec             	mov    -0x14(%ebp),%esi
      break;
80103d87:	e9 31 ff ff ff       	jmp    80103cbd <BJF+0x4d>
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (list[i] -> state == RUNNABLE){
80103d90:	b9 01 00 00 00       	mov    $0x1,%ecx
80103d95:	eb ae                	jmp    80103d45 <BJF+0xd5>
80103d97:	89 f6                	mov    %esi,%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <RR>:
struct proc* RR(struct proc ** list, int size){
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
80103da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103da8:	8b 55 08             	mov    0x8(%ebp),%edx
  for (int i=0; i < size; i++){
80103dab:	85 c9                	test   %ecx,%ecx
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103dad:	8b 02                	mov    (%edx),%eax
  for (int i=0; i < size; i++){
80103daf:	7e 10                	jle    80103dc1 <RR+0x21>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103db1:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103db5:	74 0a                	je     80103dc1 <RR+0x21>
80103db7:	8b 98 14 01 00 00    	mov    0x114(%eax),%ebx
80103dbd:	85 db                	test   %ebx,%ebx
80103dbf:	75 07                	jne    80103dc8 <RR+0x28>
}
80103dc1:	5b                   	pop    %ebx
80103dc2:	5e                   	pop    %esi
80103dc3:	5d                   	pop    %ebp
80103dc4:	c3                   	ret    
80103dc5:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i=0; i < size; i++){
80103dc8:	31 db                	xor    %ebx,%ebx
80103dca:	83 c3 01             	add    $0x1,%ebx
80103dcd:	39 d9                	cmp    %ebx,%ecx
80103dcf:	74 1f                	je     80103df0 <RR+0x50>
    if(list[i]->state != RUNNABLE && list[i]->visit)
80103dd1:	8b 34 9a             	mov    (%edx,%ebx,4),%esi
80103dd4:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103dd8:	74 09                	je     80103de3 <RR+0x43>
80103dda:	83 be 14 01 00 00 00 	cmpl   $0x0,0x114(%esi)
80103de1:	75 e7                	jne    80103dca <RR+0x2a>
80103de3:	89 f0                	mov    %esi,%eax
}
80103de5:	5b                   	pop    %ebx
80103de6:	5e                   	pop    %esi
80103de7:	5d                   	pop    %ebp
80103de8:	c3                   	ret    
80103de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df0:	8d 72 04             	lea    0x4(%edx),%esi
80103df3:	8d 1c 8a             	lea    (%edx,%ecx,4),%ebx
  for (int i=0; i < size; i++){
80103df6:	89 f1                	mov    %esi,%ecx
80103df8:	eb 0b                	jmp    80103e05 <RR+0x65>
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e00:	8b 01                	mov    (%ecx),%eax
80103e02:	83 c1 04             	add    $0x4,%ecx
  for (int i=0; i < size; i++)
80103e05:	39 d9                	cmp    %ebx,%ecx
    list[i]->visit = 0;
80103e07:	c7 80 14 01 00 00 00 	movl   $0x0,0x114(%eax)
80103e0e:	00 00 00 
  for (int i=0; i < size; i++)
80103e11:	75 ed                	jne    80103e00 <RR+0x60>
    if(list[i]->state != RUNNABLE)
80103e13:	8b 02                	mov    (%edx),%eax
80103e15:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e19:	74 a6                	je     80103dc1 <RR+0x21>
  for (int i=0; i < size; i++){
80103e1b:	39 f1                	cmp    %esi,%ecx
80103e1d:	74 a2                	je     80103dc1 <RR+0x21>
    if(list[i]->state != RUNNABLE)
80103e1f:	8b 16                	mov    (%esi),%edx
80103e21:	83 c6 04             	add    $0x4,%esi
80103e24:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103e28:	75 f1                	jne    80103e1b <RR+0x7b>
80103e2a:	89 d0                	mov    %edx,%eax
80103e2c:	eb 93                	jmp    80103dc1 <RR+0x21>
80103e2e:	66 90                	xchg   %ax,%ax

80103e30 <generate_random>:
int generate_random(int m){
80103e30:	55                   	push   %ebp
 int a = ticks % m;
80103e31:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80103e36:	31 d2                	xor    %edx,%edx
int generate_random(int m){
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	53                   	push   %ebx
80103e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
80103e3e:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103e40:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103e42:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80103e44:	0f af c2             	imul   %edx,%eax
80103e47:	99                   	cltd   
80103e48:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103e4a:	89 d0                	mov    %edx,%eax
80103e4c:	0f af c3             	imul   %ebx,%eax
}
80103e4f:	5b                   	pop    %ebx
80103e50:	5d                   	pop    %ebp
 random = (a * random )% m;
80103e51:	99                   	cltd   
80103e52:	f7 f9                	idiv   %ecx
}
80103e54:	89 d0                	mov    %edx,%eax
80103e56:	c3                   	ret    
80103e57:	89 f6                	mov    %esi,%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <lotteryScheduling>:
struct proc* lotteryScheduling(struct proc ** list,int size){
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	8b 75 0c             	mov    0xc(%ebp),%esi
80103e68:	53                   	push   %ebx
80103e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int p = 0; p < size;p++){
80103e6c:	85 f6                	test   %esi,%esi
80103e6e:	7e 70                	jle    80103ee0 <lotteryScheduling+0x80>
80103e70:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103e73:	89 d8                	mov    %ebx,%eax
  int sum_lotteries = 0;
80103e75:	31 c9                	xor    %ecx,%ecx
80103e77:	89 f6                	mov    %esi,%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(list[p]->state == RUNNABLE)
80103e80:	8b 10                	mov    (%eax),%edx
80103e82:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103e86:	75 06                	jne    80103e8e <lotteryScheduling+0x2e>
       sum_lotteries += list[p]->lottery_ticket;
80103e88:	03 8a 10 01 00 00    	add    0x110(%edx),%ecx
80103e8e:	83 c0 04             	add    $0x4,%eax
  for(int p = 0; p < size;p++){
80103e91:	39 f8                	cmp    %edi,%eax
80103e93:	75 eb                	jne    80103e80 <lotteryScheduling+0x20>
  if(sum_lotteries == 0)
80103e95:	85 c9                	test   %ecx,%ecx
80103e97:	74 47                	je     80103ee0 <lotteryScheduling+0x80>
 int a = ticks % m;
80103e99:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80103e9e:	31 d2                	xor    %edx,%edx
80103ea0:	f7 f1                	div    %ecx
 random = (a * seed )% m;
80103ea2:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80103ea4:	89 d7                	mov    %edx,%edi
 random = (a * seed )% m;
80103ea6:	0f af c2             	imul   %edx,%eax
80103ea9:	99                   	cltd   
80103eaa:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80103eac:	89 d0                	mov    %edx,%eax
80103eae:	0f af c7             	imul   %edi,%eax
  int curr_sum = 0;
80103eb1:	31 ff                	xor    %edi,%edi
 random = (a * random )% m;
80103eb3:	99                   	cltd   
80103eb4:	f7 f9                	idiv   %ecx
  for(int p = 0; p < size ;p++){
80103eb6:	31 c9                	xor    %ecx,%ecx
80103eb8:	eb 0d                	jmp    80103ec7 <lotteryScheduling+0x67>
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ec0:	83 c1 01             	add    $0x1,%ecx
80103ec3:	39 ce                	cmp    %ecx,%esi
80103ec5:	74 19                	je     80103ee0 <lotteryScheduling+0x80>
    if(list[p]->state == RUNNABLE){
80103ec7:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
80103eca:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <lotteryScheduling+0x60>
      curr_sum += list[p]->lottery_ticket;
80103ed0:	03 b8 10 01 00 00    	add    0x110(%eax),%edi
      if(curr_sum > random_ticket) {
80103ed6:	39 d7                	cmp    %edx,%edi
80103ed8:	7e e6                	jle    80103ec0 <lotteryScheduling+0x60>
}
80103eda:	5b                   	pop    %ebx
80103edb:	5e                   	pop    %esi
80103edc:	5f                   	pop    %edi
80103edd:	5d                   	pop    %ebp
80103ede:	c3                   	ret    
80103edf:	90                   	nop
80103ee0:	5b                   	pop    %ebx
      return 0;
80103ee1:	31 c0                	xor    %eax,%eax
}
80103ee3:	5e                   	pop    %esi
80103ee4:	5f                   	pop    %edi
80103ee5:	5d                   	pop    %ebp
80103ee6:	c3                   	ret    
80103ee7:	89 f6                	mov    %esi,%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <scheduler>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
  int cycle = 0;
80103ef6:	31 db                	xor    %ebx,%ebx
{
80103ef8:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103efb:	e8 10 fa ff ff       	call   80103910 <mycpu>
80103f00:	8d 78 04             	lea    0x4(%eax),%edi
80103f03:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f05:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f0c:	00 00 00 
80103f0f:	90                   	nop
  asm volatile("sti");
80103f10:	fb                   	sti    
    acquire(&ptable.lock);
80103f11:	83 ec 0c             	sub    $0xc,%esp
80103f14:	68 c0 3d 11 80       	push   $0x80113dc0
80103f19:	e8 42 0f 00 00       	call   80104e60 <acquire>
    release(&ptable.lock);
80103f1e:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103f25:	e8 f6 0f 00 00       	call   80104f20 <release>
    p->waiting_time = 0;
80103f2a:	c7 05 0c 3f 11 80 00 	movl   $0x0,0x80113f0c
80103f31:	00 00 00 
    p->last_cycle = cycle;
80103f34:	89 1d 10 3f 11 80    	mov    %ebx,0x80113f10
    c->proc = p;
80103f3a:	c7 86 ac 00 00 00 f4 	movl   $0x80113df4,0xac(%esi)
80103f41:	3d 11 80 
    switchuvm(p);
80103f44:	c7 04 24 f4 3d 11 80 	movl   $0x80113df4,(%esp)
80103f4b:	e8 20 3a 00 00       	call   80107970 <switchuvm>
    if (p -> level == 3)
80103f50:	83 c4 10             	add    $0x10,%esp
80103f53:	83 3d e8 3e 11 80 03 	cmpl   $0x3,0x80113ee8
    p->state = RUNNING;
80103f5a:	c7 05 00 3e 11 80 04 	movl   $0x4,0x80113e00
80103f61:	00 00 00 
    if (p -> level == 3)
80103f64:	75 12                	jne    80103f78 <scheduler+0x88>
      p -> exect += 0.1;
80103f66:	dd 05 20 89 10 80    	fldl   0x80108920
80103f6c:	d8 05 fc 3e 11 80    	fadds  0x80113efc
80103f72:	d9 1d fc 3e 11 80    	fstps  0x80113efc
    swtch(&(c->scheduler), p->context);
80103f78:	83 ec 08             	sub    $0x8,%esp
80103f7b:	ff 35 10 3e 11 80    	pushl  0x80113e10
    cycle += 1;
80103f81:	83 c3 01             	add    $0x1,%ebx
    swtch(&(c->scheduler), p->context);
80103f84:	57                   	push   %edi
80103f85:	e8 21 12 00 00       	call   801051ab <swtch>
    switchkvm();
80103f8a:	e8 c1 39 00 00       	call   80107950 <switchkvm>
    c->proc = 0;
80103f8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f96:	00 00 00 
  for(;;){
80103f99:	83 c4 10             	add    $0x10,%esp
80103f9c:	e9 6f ff ff ff       	jmp    80103f10 <scheduler+0x20>
80103fa1:	eb 0d                	jmp    80103fb0 <sched>
80103fa3:	90                   	nop
80103fa4:	90                   	nop
80103fa5:	90                   	nop
80103fa6:	90                   	nop
80103fa7:	90                   	nop
80103fa8:	90                   	nop
80103fa9:	90                   	nop
80103faa:	90                   	nop
80103fab:	90                   	nop
80103fac:	90                   	nop
80103fad:	90                   	nop
80103fae:	90                   	nop
80103faf:	90                   	nop

80103fb0 <sched>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
  pushcli();
80103fb5:	e8 d6 0d 00 00       	call   80104d90 <pushcli>
  c = mycpu();
80103fba:	e8 51 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103fbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fc5:	e8 06 0e 00 00       	call   80104dd0 <popcli>
  if(!holding(&ptable.lock))
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 c0 3d 11 80       	push   $0x80113dc0
80103fd2:	e8 59 0e 00 00       	call   80104e30 <holding>
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 4f                	je     8010402d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fde:	e8 2d f9 ff ff       	call   80103910 <mycpu>
80103fe3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fea:	75 68                	jne    80104054 <sched+0xa4>
  if(p->state == RUNNING)
80103fec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ff0:	74 55                	je     80104047 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff2:	9c                   	pushf  
80103ff3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ff4:	f6 c4 02             	test   $0x2,%ah
80103ff7:	75 41                	jne    8010403a <sched+0x8a>
  intena = mycpu()->intena;
80103ff9:	e8 12 f9 ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ffe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104001:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104007:	e8 04 f9 ff ff       	call   80103910 <mycpu>
8010400c:	83 ec 08             	sub    $0x8,%esp
8010400f:	ff 70 04             	pushl  0x4(%eax)
80104012:	53                   	push   %ebx
80104013:	e8 93 11 00 00       	call   801051ab <swtch>
  mycpu()->intena = intena;
80104018:	e8 f3 f8 ff ff       	call   80103910 <mycpu>
}
8010401d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104020:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
8010402c:	c3                   	ret    
    panic("sched ptable.lock");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 d0 85 10 80       	push   $0x801085d0
80104035:	e8 56 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 fc 85 10 80       	push   $0x801085fc
80104042:	e8 49 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104047:	83 ec 0c             	sub    $0xc,%esp
8010404a:	68 ee 85 10 80       	push   $0x801085ee
8010404f:	e8 3c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	68 e2 85 10 80       	push   $0x801085e2
8010405c:	e8 2f c3 ff ff       	call   80100390 <panic>
80104061:	eb 0d                	jmp    80104070 <exit>
80104063:	90                   	nop
80104064:	90                   	nop
80104065:	90                   	nop
80104066:	90                   	nop
80104067:	90                   	nop
80104068:	90                   	nop
80104069:	90                   	nop
8010406a:	90                   	nop
8010406b:	90                   	nop
8010406c:	90                   	nop
8010406d:	90                   	nop
8010406e:	90                   	nop
8010406f:	90                   	nop

80104070 <exit>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104079:	e8 12 0d 00 00       	call   80104d90 <pushcli>
  c = mycpu();
8010407e:	e8 8d f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104083:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104089:	e8 42 0d 00 00       	call   80104dd0 <popcli>
  if(curproc == initproc)
8010408e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104094:	8d 5e 28             	lea    0x28(%esi),%ebx
80104097:	8d 7e 68             	lea    0x68(%esi),%edi
8010409a:	0f 84 f1 00 00 00    	je     80104191 <exit+0x121>
    if(curproc->ofile[fd]){
801040a0:	8b 03                	mov    (%ebx),%eax
801040a2:	85 c0                	test   %eax,%eax
801040a4:	74 12                	je     801040b8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	50                   	push   %eax
801040aa:	e8 61 cf ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
801040af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801040bb:	39 fb                	cmp    %edi,%ebx
801040bd:	75 e1                	jne    801040a0 <exit+0x30>
  begin_op();
801040bf:	e8 ac ec ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	ff 76 68             	pushl  0x68(%esi)
801040ca:	e8 b1 d8 ff ff       	call   80101980 <iput>
  end_op();
801040cf:	e8 0c ed ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
801040d4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801040db:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801040e2:	e8 79 0d 00 00       	call   80104e60 <acquire>
  wakeup1(curproc->parent);
801040e7:	8b 56 14             	mov    0x14(%esi),%edx
801040ea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ed:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801040f2:	eb 10                	jmp    80104104 <exit+0x94>
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040f8:	05 20 01 00 00       	add    $0x120,%eax
801040fd:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104102:	73 1e                	jae    80104122 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104104:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104108:	75 ee                	jne    801040f8 <exit+0x88>
8010410a:	3b 50 20             	cmp    0x20(%eax),%edx
8010410d:	75 e9                	jne    801040f8 <exit+0x88>
      p->state = RUNNABLE;
8010410f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104116:	05 20 01 00 00       	add    $0x120,%eax
8010411b:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104120:	72 e2                	jb     80104104 <exit+0x94>
      p->parent = initproc;
80104122:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104128:	ba f4 3d 11 80       	mov    $0x80113df4,%edx
8010412d:	eb 0f                	jmp    8010413e <exit+0xce>
8010412f:	90                   	nop
80104130:	81 c2 20 01 00 00    	add    $0x120,%edx
80104136:	81 fa f4 85 11 80    	cmp    $0x801185f4,%edx
8010413c:	73 3a                	jae    80104178 <exit+0x108>
    if(p->parent == curproc){
8010413e:	39 72 14             	cmp    %esi,0x14(%edx)
80104141:	75 ed                	jne    80104130 <exit+0xc0>
      if(p->state == ZOMBIE)
80104143:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104147:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010414a:	75 e4                	jne    80104130 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104151:	eb 11                	jmp    80104164 <exit+0xf4>
80104153:	90                   	nop
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104158:	05 20 01 00 00       	add    $0x120,%eax
8010415d:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104162:	73 cc                	jae    80104130 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104164:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104168:	75 ee                	jne    80104158 <exit+0xe8>
8010416a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010416d:	75 e9                	jne    80104158 <exit+0xe8>
      p->state = RUNNABLE;
8010416f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104176:	eb e0                	jmp    80104158 <exit+0xe8>
  curproc->state = ZOMBIE;
80104178:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010417f:	e8 2c fe ff ff       	call   80103fb0 <sched>
  panic("zombie exit");
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	68 1d 86 10 80       	push   $0x8010861d
8010418c:	e8 ff c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104191:	83 ec 0c             	sub    $0xc,%esp
80104194:	68 10 86 10 80       	push   $0x80108610
80104199:	e8 f2 c1 ff ff       	call   80100390 <panic>
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <yield>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041a7:	68 c0 3d 11 80       	push   $0x80113dc0
801041ac:	e8 af 0c 00 00       	call   80104e60 <acquire>
  pushcli();
801041b1:	e8 da 0b 00 00       	call   80104d90 <pushcli>
  c = mycpu();
801041b6:	e8 55 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801041bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c1:	e8 0a 0c 00 00       	call   80104dd0 <popcli>
  myproc()->state = RUNNABLE;
801041c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041cd:	e8 de fd ff ff       	call   80103fb0 <sched>
  release(&ptable.lock);
801041d2:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801041d9:	e8 42 0d 00 00       	call   80104f20 <release>
}
801041de:	83 c4 10             	add    $0x10,%esp
801041e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e4:	c9                   	leave  
801041e5:	c3                   	ret    
801041e6:	8d 76 00             	lea    0x0(%esi),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <sleep>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	83 ec 0c             	sub    $0xc,%esp
801041f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041ff:	e8 8c 0b 00 00       	call   80104d90 <pushcli>
  c = mycpu();
80104204:	e8 07 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104209:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010420f:	e8 bc 0b 00 00       	call   80104dd0 <popcli>
  if(p == 0)
80104214:	85 db                	test   %ebx,%ebx
80104216:	0f 84 87 00 00 00    	je     801042a3 <sleep+0xb3>
  if(lk == 0)
8010421c:	85 f6                	test   %esi,%esi
8010421e:	74 76                	je     80104296 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104220:	81 fe c0 3d 11 80    	cmp    $0x80113dc0,%esi
80104226:	74 50                	je     80104278 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 c0 3d 11 80       	push   $0x80113dc0
80104230:	e8 2b 0c 00 00       	call   80104e60 <acquire>
    release(lk);
80104235:	89 34 24             	mov    %esi,(%esp)
80104238:	e8 e3 0c 00 00       	call   80104f20 <release>
  p->chan = chan;
8010423d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104240:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104247:	e8 64 fd ff ff       	call   80103fb0 <sched>
  p->chan = 0;
8010424c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104253:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010425a:	e8 c1 0c 00 00       	call   80104f20 <release>
    acquire(lk);
8010425f:	89 75 08             	mov    %esi,0x8(%ebp)
80104262:	83 c4 10             	add    $0x10,%esp
}
80104265:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104268:	5b                   	pop    %ebx
80104269:	5e                   	pop    %esi
8010426a:	5f                   	pop    %edi
8010426b:	5d                   	pop    %ebp
    acquire(lk);
8010426c:	e9 ef 0b 00 00       	jmp    80104e60 <acquire>
80104271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104278:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010427b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104282:	e8 29 fd ff ff       	call   80103fb0 <sched>
  p->chan = 0;
80104287:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010428e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104291:	5b                   	pop    %ebx
80104292:	5e                   	pop    %esi
80104293:	5f                   	pop    %edi
80104294:	5d                   	pop    %ebp
80104295:	c3                   	ret    
    panic("sleep without lk");
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	68 2f 86 10 80       	push   $0x8010862f
8010429e:	e8 ed c0 ff ff       	call   80100390 <panic>
    panic("sleep");
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	68 29 86 10 80       	push   $0x80108629
801042ab:	e8 e0 c0 ff ff       	call   80100390 <panic>

801042b0 <wait>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
  pushcli();
801042b5:	e8 d6 0a 00 00       	call   80104d90 <pushcli>
  c = mycpu();
801042ba:	e8 51 f6 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801042bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042c5:	e8 06 0b 00 00       	call   80104dd0 <popcli>
  acquire(&ptable.lock);
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 c0 3d 11 80       	push   $0x80113dc0
801042d2:	e8 89 0b 00 00       	call   80104e60 <acquire>
801042d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042dc:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
801042e1:	eb 13                	jmp    801042f6 <wait+0x46>
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	81 c3 20 01 00 00    	add    $0x120,%ebx
801042ee:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801042f4:	73 1e                	jae    80104314 <wait+0x64>
      if(p->parent != curproc)
801042f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042f9:	75 ed                	jne    801042e8 <wait+0x38>
      if(p->state == ZOMBIE){
801042fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042ff:	74 37                	je     80104338 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104301:	81 c3 20 01 00 00    	add    $0x120,%ebx
      havekids = 1;
80104307:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010430c:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104312:	72 e2                	jb     801042f6 <wait+0x46>
    if(!havekids || curproc->killed){
80104314:	85 c0                	test   %eax,%eax
80104316:	74 76                	je     8010438e <wait+0xde>
80104318:	8b 46 24             	mov    0x24(%esi),%eax
8010431b:	85 c0                	test   %eax,%eax
8010431d:	75 6f                	jne    8010438e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010431f:	83 ec 08             	sub    $0x8,%esp
80104322:	68 c0 3d 11 80       	push   $0x80113dc0
80104327:	56                   	push   %esi
80104328:	e8 c3 fe ff ff       	call   801041f0 <sleep>
    havekids = 0;
8010432d:	83 c4 10             	add    $0x10,%esp
80104330:	eb a8                	jmp    801042da <wait+0x2a>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010433e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104341:	e8 9a e1 ff ff       	call   801024e0 <kfree>
        freevm(p->pgdir);
80104346:	5a                   	pop    %edx
80104347:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010434a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104351:	e8 ca 39 00 00       	call   80107d20 <freevm>
        release(&ptable.lock);
80104356:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
        p->pid = 0;
8010435d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104364:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010436b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010436f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104376:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010437d:	e8 9e 0b 00 00       	call   80104f20 <release>
        return pid;
80104382:	83 c4 10             	add    $0x10,%esp
}
80104385:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104388:	89 f0                	mov    %esi,%eax
8010438a:	5b                   	pop    %ebx
8010438b:	5e                   	pop    %esi
8010438c:	5d                   	pop    %ebp
8010438d:	c3                   	ret    
      release(&ptable.lock);
8010438e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104391:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104396:	68 c0 3d 11 80       	push   $0x80113dc0
8010439b:	e8 80 0b 00 00       	call   80104f20 <release>
      return -1;
801043a0:	83 c4 10             	add    $0x10,%esp
801043a3:	eb e0                	jmp    80104385 <wait+0xd5>
801043a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ba:	68 c0 3d 11 80       	push   $0x80113dc0
801043bf:	e8 9c 0a 00 00       	call   80104e60 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c7:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801043cc:	eb 0e                	jmp    801043dc <wakeup+0x2c>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	05 20 01 00 00       	add    $0x120,%eax
801043d5:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
801043da:	73 1e                	jae    801043fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801043dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043e0:	75 ee                	jne    801043d0 <wakeup+0x20>
801043e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801043e5:	75 e9                	jne    801043d0 <wakeup+0x20>
      p->state = RUNNABLE;
801043e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ee:	05 20 01 00 00       	add    $0x120,%eax
801043f3:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
801043f8:	72 e2                	jb     801043dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801043fa:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
80104401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104404:	c9                   	leave  
  release(&ptable.lock);
80104405:	e9 16 0b 00 00       	jmp    80104f20 <release>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 10             	sub    $0x10,%esp
80104417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010441a:	68 c0 3d 11 80       	push   $0x80113dc0
8010441f:	e8 3c 0a 00 00       	call   80104e60 <acquire>
80104424:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104427:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
8010442c:	eb 0e                	jmp    8010443c <kill+0x2c>
8010442e:	66 90                	xchg   %ax,%ax
80104430:	05 20 01 00 00       	add    $0x120,%eax
80104435:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
8010443a:	73 34                	jae    80104470 <kill+0x60>
    if(p->pid == pid){
8010443c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010443f:	75 ef                	jne    80104430 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104441:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104445:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010444c:	75 07                	jne    80104455 <kill+0x45>
        p->state = RUNNABLE;
8010444e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104455:	83 ec 0c             	sub    $0xc,%esp
80104458:	68 c0 3d 11 80       	push   $0x80113dc0
8010445d:	e8 be 0a 00 00       	call   80104f20 <release>
      return 0;
80104462:	83 c4 10             	add    $0x10,%esp
80104465:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	68 c0 3d 11 80       	push   $0x80113dc0
80104478:	e8 a3 0a 00 00       	call   80104f20 <release>
  return -1;
8010447d:	83 c4 10             	add    $0x10,%esp
80104480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104488:	c9                   	leave  
80104489:	c3                   	ret    
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104499:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
8010449e:	83 ec 3c             	sub    $0x3c,%esp
801044a1:	eb 27                	jmp    801044ca <procdump+0x3a>
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 33 8c 10 80       	push   $0x80108c33
801044b0:	e8 ab c1 ff ff       	call   80100660 <cprintf>
801044b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b8:	81 c3 20 01 00 00    	add    $0x120,%ebx
801044be:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801044c4:	0f 83 86 00 00 00    	jae    80104550 <procdump+0xc0>
    if(p->state == UNUSED)
801044ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801044cd:	85 c0                	test   %eax,%eax
801044cf:	74 e7                	je     801044b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044d1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801044d4:	ba 40 86 10 80       	mov    $0x80108640,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044d9:	77 11                	ja     801044ec <procdump+0x5c>
801044db:	8b 14 85 08 89 10 80 	mov    -0x7fef76f8(,%eax,4),%edx
      state = "???";
801044e2:	b8 40 86 10 80       	mov    $0x80108640,%eax
801044e7:	85 d2                	test   %edx,%edx
801044e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044ef:	50                   	push   %eax
801044f0:	52                   	push   %edx
801044f1:	ff 73 10             	pushl  0x10(%ebx)
801044f4:	68 44 86 10 80       	push   $0x80108644
801044f9:	e8 62 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044fe:	83 c4 10             	add    $0x10,%esp
80104501:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104505:	75 a1                	jne    801044a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104507:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010450a:	83 ec 08             	sub    $0x8,%esp
8010450d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104510:	50                   	push   %eax
80104511:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104514:	8b 40 0c             	mov    0xc(%eax),%eax
80104517:	83 c0 08             	add    $0x8,%eax
8010451a:	50                   	push   %eax
8010451b:	e8 20 08 00 00       	call   80104d40 <getcallerpcs>
80104520:	83 c4 10             	add    $0x10,%esp
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104528:	8b 17                	mov    (%edi),%edx
8010452a:	85 d2                	test   %edx,%edx
8010452c:	0f 84 76 ff ff ff    	je     801044a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104532:	83 ec 08             	sub    $0x8,%esp
80104535:	83 c7 04             	add    $0x4,%edi
80104538:	52                   	push   %edx
80104539:	68 81 80 10 80       	push   $0x80108081
8010453e:	e8 1d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104543:	83 c4 10             	add    $0x10,%esp
80104546:	39 fe                	cmp    %edi,%esi
80104548:	75 de                	jne    80104528 <procdump+0x98>
8010454a:	e9 59 ff ff ff       	jmp    801044a8 <procdump+0x18>
8010454f:	90                   	nop
  }
}
80104550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104553:	5b                   	pop    %ebx
80104554:	5e                   	pop    %esi
80104555:	5f                   	pop    %edi
80104556:	5d                   	pop    %ebp
80104557:	c3                   	ret    
80104558:	90                   	nop
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <print_name>:

void print_name(int num)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	8b 45 08             	mov    0x8(%ebp),%eax
  switch(num)
80104566:	83 f8 18             	cmp    $0x18,%eax
80104569:	0f 87 91 01 00 00    	ja     80104700 <print_name+0x1a0>
8010456f:	ff 24 85 8c 88 10 80 	jmp    *-0x7fef7774(,%eax,4)
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      break;
    case 23:
      cprintf("Reverse_number");
      break;
    case 24:
      cprintf("Get_children");
80104580:	c7 45 08 e0 86 10 80 	movl   $0x801086e0,0x8(%ebp)
      break;
  }

}
80104587:	5d                   	pop    %ebp
      cprintf("Get_children");
80104588:	e9 d3 c0 ff ff       	jmp    80100660 <cprintf>
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Reverse_number");
80104590:	c7 45 08 d1 86 10 80 	movl   $0x801086d1,0x8(%ebp)
}
80104597:	5d                   	pop    %ebp
      cprintf("Reverse_number");
80104598:	e9 c3 c0 ff ff       	jmp    80100660 <cprintf>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Trace_syscalls");
801045a0:	c7 45 08 c2 86 10 80 	movl   $0x801086c2,0x8(%ebp)
}
801045a7:	5d                   	pop    %ebp
      cprintf("Trace_syscalls");
801045a8:	e9 b3 c0 ff ff       	jmp    80100660 <cprintf>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Close");
801045b0:	c7 45 08 bc 86 10 80 	movl   $0x801086bc,0x8(%ebp)
}
801045b7:	5d                   	pop    %ebp
      cprintf("Close");
801045b8:	e9 a3 c0 ff ff       	jmp    80100660 <cprintf>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mkdir");
801045c0:	c7 45 08 b6 86 10 80 	movl   $0x801086b6,0x8(%ebp)
}
801045c7:	5d                   	pop    %ebp
      cprintf("Mkdir");
801045c8:	e9 93 c0 ff ff       	jmp    80100660 <cprintf>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Link");
801045d0:	c7 45 08 b1 86 10 80 	movl   $0x801086b1,0x8(%ebp)
}
801045d7:	5d                   	pop    %ebp
      cprintf("Link");
801045d8:	e9 83 c0 ff ff       	jmp    80100660 <cprintf>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Unlink");
801045e0:	c7 45 08 aa 86 10 80 	movl   $0x801086aa,0x8(%ebp)
}
801045e7:	5d                   	pop    %ebp
      cprintf("Unlink");
801045e8:	e9 73 c0 ff ff       	jmp    80100660 <cprintf>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Mknod");
801045f0:	c7 45 08 a4 86 10 80 	movl   $0x801086a4,0x8(%ebp)
}
801045f7:	5d                   	pop    %ebp
      cprintf("Mknod");
801045f8:	e9 63 c0 ff ff       	jmp    80100660 <cprintf>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Write");
80104600:	c7 45 08 9e 86 10 80 	movl   $0x8010869e,0x8(%ebp)
}
80104607:	5d                   	pop    %ebp
      cprintf("Write");
80104608:	e9 53 c0 ff ff       	jmp    80100660 <cprintf>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Open");
80104610:	c7 45 08 99 86 10 80 	movl   $0x80108699,0x8(%ebp)
}
80104617:	5d                   	pop    %ebp
      cprintf("Open");
80104618:	e9 43 c0 ff ff       	jmp    80100660 <cprintf>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Uptime");
80104620:	c7 45 08 92 86 10 80 	movl   $0x80108692,0x8(%ebp)
}
80104627:	5d                   	pop    %ebp
      cprintf("Uptime");
80104628:	e9 33 c0 ff ff       	jmp    80100660 <cprintf>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sleep");
80104630:	c7 45 08 8c 86 10 80 	movl   $0x8010868c,0x8(%ebp)
}
80104637:	5d                   	pop    %ebp
      cprintf("Sleep");
80104638:	e9 23 c0 ff ff       	jmp    80100660 <cprintf>
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Sbrk");
80104640:	c7 45 08 87 86 10 80 	movl   $0x80108687,0x8(%ebp)
}
80104647:	5d                   	pop    %ebp
      cprintf("Sbrk");
80104648:	e9 13 c0 ff ff       	jmp    80100660 <cprintf>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Getpid");
80104650:	c7 45 08 80 86 10 80 	movl   $0x80108680,0x8(%ebp)
}
80104657:	5d                   	pop    %ebp
      cprintf("Getpid");
80104658:	e9 03 c0 ff ff       	jmp    80100660 <cprintf>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Dup");
80104660:	c7 45 08 7c 86 10 80 	movl   $0x8010867c,0x8(%ebp)
}
80104667:	5d                   	pop    %ebp
      cprintf("Dup");
80104668:	e9 f3 bf ff ff       	jmp    80100660 <cprintf>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Chdir");
80104670:	c7 45 08 76 86 10 80 	movl   $0x80108676,0x8(%ebp)
}
80104677:	5d                   	pop    %ebp
      cprintf("Chdir");
80104678:	e9 e3 bf ff ff       	jmp    80100660 <cprintf>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fstat");
80104680:	c7 45 08 70 86 10 80 	movl   $0x80108670,0x8(%ebp)
}
80104687:	5d                   	pop    %ebp
      cprintf("Fstat");
80104688:	e9 d3 bf ff ff       	jmp    80100660 <cprintf>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exec");
80104690:	c7 45 08 6b 86 10 80 	movl   $0x8010866b,0x8(%ebp)
}
80104697:	5d                   	pop    %ebp
      cprintf("Exec");
80104698:	e9 c3 bf ff ff       	jmp    80100660 <cprintf>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Kill");
801046a0:	c7 45 08 66 86 10 80 	movl   $0x80108666,0x8(%ebp)
}
801046a7:	5d                   	pop    %ebp
      cprintf("Kill");
801046a8:	e9 b3 bf ff ff       	jmp    80100660 <cprintf>
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Read");
801046b0:	c7 45 08 61 86 10 80 	movl   $0x80108661,0x8(%ebp)
}
801046b7:	5d                   	pop    %ebp
      cprintf("Read");
801046b8:	e9 a3 bf ff ff       	jmp    80100660 <cprintf>
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Pipe");
801046c0:	c7 45 08 5c 86 10 80 	movl   $0x8010865c,0x8(%ebp)
}
801046c7:	5d                   	pop    %ebp
      cprintf("Pipe");
801046c8:	e9 93 bf ff ff       	jmp    80100660 <cprintf>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Wait");
801046d0:	c7 45 08 57 86 10 80 	movl   $0x80108657,0x8(%ebp)
}
801046d7:	5d                   	pop    %ebp
      cprintf("Wait");
801046d8:	e9 83 bf ff ff       	jmp    80100660 <cprintf>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Exit");
801046e0:	c7 45 08 52 86 10 80 	movl   $0x80108652,0x8(%ebp)
}
801046e7:	5d                   	pop    %ebp
      cprintf("Exit");
801046e8:	e9 73 bf ff ff       	jmp    80100660 <cprintf>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Fork");
801046f0:	c7 45 08 4d 86 10 80 	movl   $0x8010864d,0x8(%ebp)
}
801046f7:	5d                   	pop    %ebp
      cprintf("Fork");
801046f8:	e9 63 bf ff ff       	jmp    80100660 <cprintf>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
}
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <allone>:
void allone(void){
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104714:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
void allone(void){
80104719:	83 ec 04             	sub    $0x4,%esp
8010471c:	eb 1a                	jmp    80104738 <allone+0x28>
8010471e:	66 90                	xchg   %ax,%ax
  {

    if(strlen(p->name) == 0)
      break;
    p->print_state = 1;
80104720:	c7 83 f0 00 00 00 01 	movl   $0x1,0xf0(%ebx)
80104727:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472a:	81 c3 20 01 00 00    	add    $0x120,%ebx
80104730:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104736:	73 13                	jae    8010474b <allone+0x3b>
    if(strlen(p->name) == 0)
80104738:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	50                   	push   %eax
8010473f:	e8 4c 0a 00 00       	call   80105190 <strlen>
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	85 c0                	test   %eax,%eax
80104749:	75 d5                	jne    80104720 <allone+0x10>
    
  }
  

}
8010474b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010474e:	c9                   	leave  
8010474f:	c3                   	ret    

80104750 <all_zero>:
void all_zero(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
  struct proc *p;
  int i;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104754:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
80104759:	83 ec 04             	sub    $0x4,%esp
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(strlen(p->name) == 0)
80104760:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104763:	83 ec 0c             	sub    $0xc,%esp
80104766:	50                   	push   %eax
80104767:	e8 24 0a 00 00       	call   80105190 <strlen>
8010476c:	83 c4 10             	add    $0x10,%esp
8010476f:	85 c0                	test   %eax,%eax
80104771:	74 38                	je     801047ab <all_zero+0x5b>
80104773:	8d 43 7c             	lea    0x7c(%ebx),%eax
80104776:	8d 93 f0 00 00 00    	lea    0xf0(%ebx),%edx
      break;
    p->print_state = 0;
8010477c:	c7 83 f0 00 00 00 00 	movl   $0x0,0xf0(%ebx)
80104783:	00 00 00 
80104786:	8d 76 00             	lea    0x0(%esi),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (i =0; i < SYSNUM; i++){
        
       p->call_nums[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104796:	83 c0 04             	add    $0x4,%eax
    for (i =0; i < SYSNUM; i++){
80104799:	39 d0                	cmp    %edx,%eax
8010479b:	75 f3                	jne    80104790 <all_zero+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010479d:	81 c3 20 01 00 00    	add    $0x120,%ebx
801047a3:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
801047a9:	72 b5                	jb     80104760 <all_zero+0x10>
    }
  }

}
801047ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ae:	c9                   	leave  
801047af:	c3                   	ret    

801047b0 <trace_syscalls>:

int trace_syscalls(int state)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 45 08             	mov    0x8(%ebp),%eax
  
  struct proc *p;
  int i;
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
801047b8:	83 f8 01             	cmp    $0x1,%eax
801047bb:	74 2a                	je     801047e7 <trace_syscalls+0x37>
801047bd:	83 f8 02             	cmp    $0x2,%eax
801047c0:	74 16                	je     801047d8 <trace_syscalls+0x28>

    }
    return 0;
  }

  if(state == 0)
801047c2:	85 c0                	test   %eax,%eax
801047c4:	0f 85 99 00 00 00    	jne    80104863 <trace_syscalls+0xb3>
  {
    all_zero();
801047ca:	e8 81 ff ff ff       	call   80104750 <all_zero>
    return 0;
801047cf:	31 c0                	xor    %eax,%eax
  }
  return -1;
 
}
801047d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d4:	5b                   	pop    %ebx
801047d5:	5e                   	pop    %esi
801047d6:	5d                   	pop    %ebp
801047d7:	c3                   	ret    
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
801047d8:	8b 0d e4 3e 11 80    	mov    0x80113ee4,%ecx
  return -1;
801047de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if( state == 1 || (state == 2 && ptable.proc -> print_state))
801047e3:	85 c9                	test   %ecx,%ecx
801047e5:	74 ea                	je     801047d1 <trace_syscalls+0x21>
801047e7:	be f4 3d 11 80       	mov    $0x80113df4,%esi
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f0:	8d 5e 6c             	lea    0x6c(%esi),%ebx
      if(strlen(p->name) == 0)
801047f3:	83 ec 0c             	sub    $0xc,%esp
801047f6:	53                   	push   %ebx
801047f7:	e8 94 09 00 00       	call   80105190 <strlen>
801047fc:	83 c4 10             	add    $0x10,%esp
801047ff:	85 c0                	test   %eax,%eax
80104801:	74 cc                	je     801047cf <trace_syscalls+0x1f>
      cprintf("%s:\n",p->name);
80104803:	83 ec 08             	sub    $0x8,%esp
      p->print_state = 1;
80104806:	c7 86 f0 00 00 00 01 	movl   $0x1,0xf0(%esi)
8010480d:	00 00 00 
      cprintf("%s:\n",p->name);
80104810:	53                   	push   %ebx
80104811:	68 ed 86 10 80       	push   $0x801086ed
      for (i =0; i < SYSNUM; i++)
80104816:	31 db                	xor    %ebx,%ebx
      cprintf("%s:\n",p->name);
80104818:	e8 43 be ff ff       	call   80100660 <cprintf>
8010481d:	83 c4 10             	add    $0x10,%esp
        cprintf("   ");
80104820:	83 ec 0c             	sub    $0xc,%esp
        print_name(i + 1);
80104823:	83 c3 01             	add    $0x1,%ebx
        cprintf("   ");
80104826:	68 49 87 10 80       	push   $0x80108749
8010482b:	e8 30 be ff ff       	call   80100660 <cprintf>
        print_name(i + 1);
80104830:	89 1c 24             	mov    %ebx,(%esp)
80104833:	e8 28 fd ff ff       	call   80104560 <print_name>
        cprintf(": %d\n", p->call_nums[i]);
80104838:	58                   	pop    %eax
80104839:	5a                   	pop    %edx
8010483a:	ff 74 9e 78          	pushl  0x78(%esi,%ebx,4)
8010483e:	68 f2 86 10 80       	push   $0x801086f2
80104843:	e8 18 be ff ff       	call   80100660 <cprintf>
      for (i =0; i < SYSNUM; i++)
80104848:	83 c4 10             	add    $0x10,%esp
8010484b:	83 fb 1d             	cmp    $0x1d,%ebx
8010484e:	75 d0                	jne    80104820 <trace_syscalls+0x70>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104850:	81 c6 20 01 00 00    	add    $0x120,%esi
80104856:	81 fe f4 85 11 80    	cmp    $0x801185f4,%esi
8010485c:	72 92                	jb     801047f0 <trace_syscalls+0x40>
8010485e:	e9 6c ff ff ff       	jmp    801047cf <trace_syscalls+0x1f>
  return -1;
80104863:	83 c8 ff             	or     $0xffffffff,%eax
80104866:	e9 66 ff ff ff       	jmp    801047d1 <trace_syscalls+0x21>
8010486b:	90                   	nop
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <reverse_number>:

int reverse_number(int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	56                   	push   %esi
80104875:	53                   	push   %ebx
80104876:	81 ec 2c 03 00 00    	sub    $0x32c,%esp
8010487c:	8b 75 08             	mov    0x8(%ebp),%esi

  int digit = 0;
  int temp = n;

  while (temp)
8010487f:	85 f6                	test   %esi,%esi
80104881:	74 7e                	je     80104901 <reverse_number+0x91>
80104883:	89 f3                	mov    %esi,%ebx
  int digit = 0;
80104885:	31 ff                	xor    %edi,%edi
  {
    ++digit;
    temp /= 10;
80104887:	b9 67 66 66 66       	mov    $0x66666667,%ecx
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104890:	89 d8                	mov    %ebx,%eax
80104892:	c1 fb 1f             	sar    $0x1f,%ebx
    ++digit;
80104895:	83 c7 01             	add    $0x1,%edi
    temp /= 10;
80104898:	f7 e9                	imul   %ecx
8010489a:	c1 fa 02             	sar    $0x2,%edx
  while (temp)
8010489d:	29 da                	sub    %ebx,%edx
8010489f:	89 d3                	mov    %edx,%ebx
801048a1:	75 ed                	jne    80104890 <reverse_number+0x20>
801048a3:	89 fa                	mov    %edi,%edx
  }

  int array[200] = {0};
801048a5:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
801048ab:	89 d8                	mov    %ebx,%eax
801048ad:	b9 c8 00 00 00       	mov    $0xc8,%ecx
801048b2:	f3 ab                	rep stos %eax,%es:(%edi)
801048b4:	8d bd c8 fc ff ff    	lea    -0x338(%ebp),%edi
801048ba:	8d 0c 97             	lea    (%edi,%edx,4),%ecx
801048bd:	89 fb                	mov    %edi,%ebx
801048bf:	90                   	nop
  
  for (int i = 0; i < digit; i++) 
    {
      array[i] = n % 10;
801048c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
801048c5:	83 c3 04             	add    $0x4,%ebx
801048c8:	f7 ee                	imul   %esi
801048ca:	89 f0                	mov    %esi,%eax
801048cc:	c1 f8 1f             	sar    $0x1f,%eax
801048cf:	c1 fa 02             	sar    $0x2,%edx
801048d2:	29 c2                	sub    %eax,%edx
801048d4:	8d 04 92             	lea    (%edx,%edx,4),%eax
801048d7:	01 c0                	add    %eax,%eax
801048d9:	29 c6                	sub    %eax,%esi
801048db:	89 73 fc             	mov    %esi,-0x4(%ebx)
  for (int i = 0; i < digit; i++) 
801048de:	39 cb                	cmp    %ecx,%ebx
      n /= 10;
801048e0:	89 d6                	mov    %edx,%esi
  for (int i = 0; i < digit; i++) 
801048e2:	75 dc                	jne    801048c0 <reverse_number+0x50>
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  
  for(int j = 0; j < digit; j++)
    cprintf("%d", array[j]);
801048e8:	83 ec 08             	sub    $0x8,%esp
801048eb:	ff 37                	pushl  (%edi)
801048ed:	83 c7 04             	add    $0x4,%edi
801048f0:	68 f8 86 10 80       	push   $0x801086f8
801048f5:	e8 66 bd ff ff       	call   80100660 <cprintf>
  for(int j = 0; j < digit; j++)
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	39 df                	cmp    %ebx,%edi
801048ff:	75 e7                	jne    801048e8 <reverse_number+0x78>
  cprintf("\n");
80104901:	83 ec 0c             	sub    $0xc,%esp
80104904:	68 33 8c 10 80       	push   $0x80108c33
80104909:	e8 52 bd ff ff       	call   80100660 <cprintf>

  return 0;

}
8010490e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104911:	31 c0                	xor    %eax,%eax
80104913:	5b                   	pop    %ebx
80104914:	5e                   	pop    %esi
80104915:	5f                   	pop    %edi
80104916:	5d                   	pop    %ebp
80104917:	c3                   	ret    
80104918:	90                   	nop
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104920 <children>:
int
children(int pid)
{
80104920:	55                   	push   %ebp
  struct proc *p;
  
  int childs[NPROC] = {-1};
80104921:	31 c0                	xor    %eax,%eax
80104923:	b9 3f 00 00 00       	mov    $0x3f,%ecx
{
80104928:	89 e5                	mov    %esp,%ebp
8010492a:	57                   	push   %edi
8010492b:	56                   	push   %esi
  int childs[NPROC] = {-1};
8010492c:	8d bd ec fe ff ff    	lea    -0x114(%ebp),%edi
{
80104932:	53                   	push   %ebx
  int curr_index = 0;
  int index = 0;
80104933:	31 db                	xor    %ebx,%ebx
{
80104935:	81 ec 28 01 00 00    	sub    $0x128,%esp
8010493b:	8b 75 08             	mov    0x8(%ebp),%esi
  int childs[NPROC] = {-1};
8010493e:	f3 ab                	rep stos %eax,%es:(%edi)
  //int parent_pid = pid ; 

  acquire(&ptable.lock);
80104940:	68 c0 3d 11 80       	push   $0x80113dc0
  int childs[NPROC] = {-1};
80104945:	c7 85 e8 fe ff ff ff 	movl   $0xffffffff,-0x118(%ebp)
8010494c:	ff ff ff 
8010494f:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
  acquire(&ptable.lock);
80104955:	e8 06 05 00 00       	call   80104e60 <acquire>
8010495a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010495d:	83 c4 10             	add    $0x10,%esp
80104960:	89 f9                	mov    %edi,%ecx
80104962:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
80104968:	90                   	nop
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(int i = 0 ; i < NPROC ; i++){

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104970:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80104975:	8d 76 00             	lea    0x0(%esi),%esi

      //cprintf("proc pid: %d  parent pid: %d \n",  p->pid, p->parent->pid);

        if(p->parent->pid == pid){
80104978:	8b 50 14             	mov    0x14(%eax),%edx
8010497b:	39 72 10             	cmp    %esi,0x10(%edx)
8010497e:	75 0d                	jne    8010498d <children+0x6d>
           childs[index] = p->pid ;
80104980:	8b 50 10             	mov    0x10(%eax),%edx
80104983:	89 94 9d e8 fe ff ff 	mov    %edx,-0x118(%ebp,%ebx,4)
           index++;
8010498a:	83 c3 01             	add    $0x1,%ebx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010498d:	05 20 01 00 00       	add    $0x120,%eax
80104992:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104997:	72 df                	jb     80104978 <children+0x58>
       //  cprintf(" parent pid ,%d", pid , " child pid: %d \n",  p->pid);
        }
    }
     if(childs[curr_index] == -1)
80104999:	8b 31                	mov    (%ecx),%esi
8010499b:	83 fe ff             	cmp    $0xffffffff,%esi
8010499e:	74 0b                	je     801049ab <children+0x8b>
801049a0:	83 c1 04             	add    $0x4,%ecx
  for(int i = 0 ; i < NPROC ; i++){
801049a3:	3b 8d e4 fe ff ff    	cmp    -0x11c(%ebp),%ecx
801049a9:	75 c5                	jne    80104970 <children+0x50>
     else{
       pid = childs[curr_index];
       curr_index++;
      } 
  }
  release(&ptable.lock);
801049ab:	83 ec 0c             	sub    $0xc,%esp
801049ae:	68 c0 3d 11 80       	push   $0x80113dc0
801049b3:	e8 68 05 00 00       	call   80104f20 <release>
  
  int pid_list = 0;
  int cpy ; 

  for(int i = 0 ; i < index ;i++){
801049b8:	83 c4 10             	add    $0x10,%esp
801049bb:	85 db                	test   %ebx,%ebx
801049bd:	74 3e                	je     801049fd <children+0xdd>
801049bf:	8d 04 9f             	lea    (%edi,%ebx,4),%eax

  cpy = childs[i];
  while(cpy > 0){
        pid_list *= 10;
        cpy /= 10 ;
801049c2:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
  int pid_list = 0;
801049c7:	31 db                	xor    %ebx,%ebx
801049c9:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  cpy = childs[i];
801049cf:	8b 37                	mov    (%edi),%esi
  while(cpy > 0){
801049d1:	85 f6                	test   %esi,%esi
801049d3:	7e 1b                	jle    801049f0 <children+0xd0>
801049d5:	89 f2                	mov    %esi,%edx
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        cpy /= 10 ;
801049e0:	89 d0                	mov    %edx,%eax
        pid_list *= 10;
801049e2:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
        cpy /= 10 ;
801049e5:	f7 e1                	mul    %ecx
        pid_list *= 10;
801049e7:	01 db                	add    %ebx,%ebx
        cpy /= 10 ;
801049e9:	c1 ea 03             	shr    $0x3,%edx
  while(cpy > 0){
801049ec:	85 d2                	test   %edx,%edx
801049ee:	75 f0                	jne    801049e0 <children+0xc0>
     }
  pid_list += childs[i];
801049f0:	01 f3                	add    %esi,%ebx
801049f2:	83 c7 04             	add    $0x4,%edi
  for(int i = 0 ; i < index ;i++){
801049f5:	3b bd e4 fe ff ff    	cmp    -0x11c(%ebp),%edi
801049fb:	75 d2                	jne    801049cf <children+0xaf>
}


  return pid_list;
}
801049fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a00:	89 d8                	mov    %ebx,%eax
80104a02:	5b                   	pop    %ebx
80104a03:	5e                   	pop    %esi
80104a04:	5f                   	pop    %edi
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <change_process_queue>:

void change_process_queue(int pid, int dest_queue)
{
80104a10:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a11:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104a16:	89 e5                	mov    %esp,%ebp
80104a18:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a1e:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104a20:	39 50 10             	cmp    %edx,0x10(%eax)
80104a23:	75 06                	jne    80104a2b <change_process_queue+0x1b>
    {
      p->level = dest_queue;
80104a25:	89 88 f4 00 00 00    	mov    %ecx,0xf4(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a2b:	05 20 01 00 00       	add    $0x120,%eax
80104a30:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104a35:	72 e9                	jb     80104a20 <change_process_queue+0x10>
    }
  }
}
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a40 <quantify_lottery_tickets>:

void quantify_lottery_tickets(int pid, int ticket)
{
80104a40:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a41:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104a46:	89 e5                	mov    %esp,%ebp
80104a48:	8b 55 08             	mov    0x8(%ebp),%edx
80104a4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a4e:	66 90                	xchg   %ax,%ax
  {
    if(p->pid == pid)
80104a50:	39 50 10             	cmp    %edx,0x10(%eax)
80104a53:	75 06                	jne    80104a5b <quantify_lottery_tickets+0x1b>
    {
      p->lottery_ticket = ticket;
80104a55:	89 88 10 01 00 00    	mov    %ecx,0x110(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a5b:	05 20 01 00 00       	add    $0x120,%eax
80104a60:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104a65:	72 e9                	jb     80104a50 <quantify_lottery_tickets+0x10>
    }
  }
}
80104a67:	5d                   	pop    %ebp
80104a68:	c3                   	ret    
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a70 <quantify_BJF_parameters_process_level>:

void quantify_BJF_parameters_process_level(int pid, int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104a70:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104a71:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104a76:	89 e5                	mov    %esp,%ebp
80104a78:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7b:	90                   	nop
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->pid == pid)
80104a80:	39 50 10             	cmp    %edx,0x10(%eax)
80104a83:	75 1b                	jne    80104aa0 <quantify_BJF_parameters_process_level+0x30>
    {
      p->priority_ratio = priority_ratio;
80104a85:	db 45 0c             	fildl  0xc(%ebp)
80104a88:	d9 98 fc 00 00 00    	fstps  0xfc(%eax)
      p->arrivt_ratio = arrivt_ratio;
80104a8e:	db 45 10             	fildl  0x10(%ebp)
80104a91:	d9 98 04 01 00 00    	fstps  0x104(%eax)
      p->exect_ratio = exect_ratio;
80104a97:	db 45 14             	fildl  0x14(%ebp)
80104a9a:	d9 98 0c 01 00 00    	fstps  0x10c(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104aa0:	05 20 01 00 00       	add    $0x120,%eax
80104aa5:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104aaa:	72 d4                	jb     80104a80 <quantify_BJF_parameters_process_level+0x10>
    }
  }
}
80104aac:	5d                   	pop    %ebp
80104aad:	c3                   	ret    
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <quantify_BJF_parameters_kernel_level>:

void quantify_BJF_parameters_kernel_level(int priority_ratio, int arrivt_ratio, int exect_ratio)
{
80104ab0:	55                   	push   %ebp
  struct proc* p;
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104ab1:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
{
80104ab6:	89 e5                	mov    %esp,%ebp
80104ab8:	db 45 08             	fildl  0x8(%ebp)
80104abb:	db 45 0c             	fildl  0xc(%ebp)
80104abe:	db 45 10             	fildl  0x10(%ebp)
80104ac1:	d9 ca                	fxch   %st(2)
80104ac3:	eb 07                	jmp    80104acc <quantify_BJF_parameters_kernel_level+0x1c>
80104ac5:	8d 76 00             	lea    0x0(%esi),%esi
80104ac8:	d9 ca                	fxch   %st(2)
80104aca:	d9 c9                	fxch   %st(1)
  {
    p->priority_ratio = priority_ratio;
80104acc:	d9 90 fc 00 00 00    	fsts   0xfc(%eax)
80104ad2:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104ad4:	05 20 01 00 00       	add    $0x120,%eax
    p->arrivt_ratio = arrivt_ratio;
80104ad9:	d9 50 e4             	fsts   -0x1c(%eax)
80104adc:	d9 ca                	fxch   %st(2)
    p->exect_ratio = exect_ratio;
80104ade:	d9 50 ec             	fsts   -0x14(%eax)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104ae1:	3d f4 85 11 80       	cmp    $0x801185f4,%eax
80104ae6:	72 e0                	jb     80104ac8 <quantify_BJF_parameters_kernel_level+0x18>
80104ae8:	dd d8                	fstp   %st(0)
80104aea:	dd d8                	fstp   %st(0)
80104aec:	dd d8                	fstp   %st(0)
  }
}
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <state_to_string>:

const char* state_to_string(enum procstate const state)
{
80104af0:	55                   	push   %ebp
80104af1:	31 c0                	xor    %eax,%eax
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	8b 55 08             	mov    0x8(%ebp),%edx
80104af8:	83 fa 05             	cmp    $0x5,%edx
80104afb:	77 07                	ja     80104b04 <state_to_string+0x14>
80104afd:	8b 04 95 f0 88 10 80 	mov    -0x7fef7710(,%edx,4),%eax
    case ZOMBIE:  
      return "ZOMBIE";
      break;
  }
  return 0;
}
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <print_information>:

void print_information()
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
  struct proc* p;
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
  cprintf("...............................................................................................................\n");
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104b16:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
80104b1b:	83 ec 28             	sub    $0x28,%esp
  cprintf("name \t pid \t state \t queue level\t ticket \t priority_ratio \t arrivt_ratio \t exect_ratio \t rank \t cycle \n");
80104b1e:	68 7c 87 10 80       	push   $0x8010877c
80104b23:	e8 38 bb ff ff       	call   80100660 <cprintf>
  cprintf("...............................................................................................................\n");
80104b28:	c7 04 24 e4 87 10 80 	movl   $0x801087e4,(%esp)
80104b2f:	e8 2c bb ff ff       	call   80100660 <cprintf>
80104b34:	83 c4 10             	add    $0x10,%esp
80104b37:	89 f6                	mov    %esi,%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  {
    int rank = p->priority * p->priority_ratio + p->arrivt * p->arrivt_ratio + p->exect * p->exect_ratio;
80104b40:	d9 83 fc 00 00 00    	flds   0xfc(%ebx)
80104b46:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104b49:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax

    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104b4d:	8b 53 0c             	mov    0xc(%ebx),%edx
80104b50:	8b bb 1c 01 00 00    	mov    0x11c(%ebx),%edi
    int rank = p->priority * p->priority_ratio + p->arrivt * p->arrivt_ratio + p->exect * p->exect_ratio;
80104b56:	d9 83 04 01 00 00    	flds   0x104(%ebx)
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104b5c:	8b b3 10 01 00 00    	mov    0x110(%ebx),%esi
80104b62:	8b 8b f4 00 00 00    	mov    0xf4(%ebx),%ecx
    int rank = p->priority * p->priority_ratio + p->arrivt * p->arrivt_ratio + p->exect * p->exect_ratio;
80104b68:	d9 83 0c 01 00 00    	flds   0x10c(%ebx)
80104b6e:	80 cc 0c             	or     $0xc,%ah
80104b71:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104b75:	31 c0                	xor    %eax,%eax
80104b77:	83 fa 05             	cmp    $0x5,%edx
    int rank = p->priority * p->priority_ratio + p->arrivt * p->arrivt_ratio + p->exect * p->exect_ratio;
80104b7a:	d9 83 f8 00 00 00    	flds   0xf8(%ebx)
80104b80:	d8 cb                	fmul   %st(3),%st
80104b82:	d9 83 00 01 00 00    	flds   0x100(%ebx)
80104b88:	d8 cb                	fmul   %st(3),%st
80104b8a:	de c1                	faddp  %st,%st(1)
80104b8c:	d9 83 08 01 00 00    	flds   0x108(%ebx)
80104b92:	d8 ca                	fmul   %st(2),%st
80104b94:	de c1                	faddp  %st,%st(1)
80104b96:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104b99:	db 5d dc             	fistpl -0x24(%ebp)
80104b9c:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104b9f:	77 07                	ja     80104ba8 <print_information+0x98>
80104ba1:	8b 04 95 f0 88 10 80 	mov    -0x7fef7710(,%edx,4),%eax
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104ba8:	83 ec 08             	sub    $0x8,%esp
80104bab:	57                   	push   %edi
80104bac:	ff 75 dc             	pushl  -0x24(%ebp)
80104baf:	83 ec 18             	sub    $0x18,%esp
80104bb2:	dd 5c 24 10          	fstpl  0x10(%esp)
80104bb6:	dd 5c 24 08          	fstpl  0x8(%esp)
80104bba:	dd 1c 24             	fstpl  (%esp)
80104bbd:	56                   	push   %esi
80104bbe:	51                   	push   %ecx
80104bbf:	50                   	push   %eax
80104bc0:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104bc3:	ff 73 10             	pushl  0x10(%ebx)
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104bc6:	81 c3 20 01 00 00    	add    $0x120,%ebx
    cprintf("%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", 
80104bcc:	50                   	push   %eax
80104bcd:	68 58 88 10 80       	push   $0x80108858
80104bd2:	e8 89 ba ff ff       	call   80100660 <cprintf>
  for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104bd7:	83 c4 40             	add    $0x40,%esp
80104bda:	81 fb f4 85 11 80    	cmp    $0x801185f4,%ebx
80104be0:	0f 82 5a ff ff ff    	jb     80104b40 <print_information+0x30>
    p->name, p->pid, state_to_string(p->state), p->level, p->lottery_ticket, p->priority_ratio, p->arrivt_ratio, p->exect_ratio, rank, p->last_cycle);
  }
80104be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be9:	5b                   	pop    %ebx
80104bea:	5e                   	pop    %esi
80104beb:	5f                   	pop    %edi
80104bec:	5d                   	pop    %ebp
80104bed:	c3                   	ret    
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 0c             	sub    $0xc,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bfa:	68 28 89 10 80       	push   $0x80108928
80104bff:	8d 43 04             	lea    0x4(%ebx),%eax
80104c02:	50                   	push   %eax
80104c03:	e8 18 01 00 00       	call   80104d20 <initlock>
  lk->name = name;
80104c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c11:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c14:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c1b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c21:	c9                   	leave  
80104c22:	c3                   	ret    
80104c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c38:	83 ec 0c             	sub    $0xc,%esp
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c3e:	56                   	push   %esi
80104c3f:	e8 1c 02 00 00       	call   80104e60 <acquire>
  while (lk->locked) {
80104c44:	8b 13                	mov    (%ebx),%edx
80104c46:	83 c4 10             	add    $0x10,%esp
80104c49:	85 d2                	test   %edx,%edx
80104c4b:	74 16                	je     80104c63 <acquiresleep+0x33>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c50:	83 ec 08             	sub    $0x8,%esp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	e8 96 f5 ff ff       	call   801041f0 <sleep>
  while (lk->locked) {
80104c5a:	8b 03                	mov    (%ebx),%eax
80104c5c:	83 c4 10             	add    $0x10,%esp
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	75 ed                	jne    80104c50 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c63:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c69:	e8 42 ed ff ff       	call   801039b0 <myproc>
80104c6e:	8b 40 10             	mov    0x10(%eax),%eax
80104c71:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c74:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c7a:	5b                   	pop    %ebx
80104c7b:	5e                   	pop    %esi
80104c7c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c7d:	e9 9e 02 00 00       	jmp    80104f20 <release>
80104c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c9e:	56                   	push   %esi
80104c9f:	e8 bc 01 00 00       	call   80104e60 <acquire>
  lk->locked = 0;
80104ca4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104caa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104cb1:	89 1c 24             	mov    %ebx,(%esp)
80104cb4:	e8 f7 f6 ff ff       	call   801043b0 <wakeup>
  release(&lk->lk);
80104cb9:	89 75 08             	mov    %esi,0x8(%ebp)
80104cbc:	83 c4 10             	add    $0x10,%esp
}
80104cbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc2:	5b                   	pop    %ebx
80104cc3:	5e                   	pop    %esi
80104cc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cc5:	e9 56 02 00 00       	jmp    80104f20 <release>
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	31 ff                	xor    %edi,%edi
80104cd8:	83 ec 18             	sub    $0x18,%esp
80104cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104cde:	8d 73 04             	lea    0x4(%ebx),%esi
80104ce1:	56                   	push   %esi
80104ce2:	e8 79 01 00 00       	call   80104e60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ce7:	8b 03                	mov    (%ebx),%eax
80104ce9:	83 c4 10             	add    $0x10,%esp
80104cec:	85 c0                	test   %eax,%eax
80104cee:	74 13                	je     80104d03 <holdingsleep+0x33>
80104cf0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cf3:	e8 b8 ec ff ff       	call   801039b0 <myproc>
80104cf8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cfb:	0f 94 c0             	sete   %al
80104cfe:	0f b6 c0             	movzbl %al,%eax
80104d01:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104d03:	83 ec 0c             	sub    $0xc,%esp
80104d06:	56                   	push   %esi
80104d07:	e8 14 02 00 00       	call   80104f20 <release>
  return r;
}
80104d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d0f:	89 f8                	mov    %edi,%eax
80104d11:	5b                   	pop    %ebx
80104d12:	5e                   	pop    %esi
80104d13:	5f                   	pop    %edi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
80104d16:	66 90                	xchg   %ax,%ax
80104d18:	66 90                	xchg   %ax,%ax
80104d1a:	66 90                	xchg   %ax,%ax
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret    
80104d3b:	90                   	nop
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d40:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d41:	31 d2                	xor    %edx,%edx
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d46:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d4c:	83 e8 08             	sub    $0x8,%eax
80104d4f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d50:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d5c:	77 1a                	ja     80104d78 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d5e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d61:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d64:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d67:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d69:	83 fa 0a             	cmp    $0xa,%edx
80104d6c:	75 e2                	jne    80104d50 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d6e:	5b                   	pop    %ebx
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret    
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d78:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d7b:	83 c1 28             	add    $0x28,%ecx
80104d7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d89:	39 c1                	cmp    %eax,%ecx
80104d8b:	75 f3                	jne    80104d80 <getcallerpcs+0x40>
}
80104d8d:	5b                   	pop    %ebx
80104d8e:	5d                   	pop    %ebp
80104d8f:	c3                   	ret    

80104d90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	9c                   	pushf  
80104d98:	5b                   	pop    %ebx
  asm volatile("cli");
80104d99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d9a:	e8 71 eb ff ff       	call   80103910 <mycpu>
80104d9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104da5:	85 c0                	test   %eax,%eax
80104da7:	75 11                	jne    80104dba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104da9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104daf:	e8 5c eb ff ff       	call   80103910 <mycpu>
80104db4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104dba:	e8 51 eb ff ff       	call   80103910 <mycpu>
80104dbf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104dc6:	83 c4 04             	add    $0x4,%esp
80104dc9:	5b                   	pop    %ebx
80104dca:	5d                   	pop    %ebp
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <popcli>:

void
popcli(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104dd6:	9c                   	pushf  
80104dd7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104dd8:	f6 c4 02             	test   $0x2,%ah
80104ddb:	75 35                	jne    80104e12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ddd:	e8 2e eb ff ff       	call   80103910 <mycpu>
80104de2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104de9:	78 34                	js     80104e1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104deb:	e8 20 eb ff ff       	call   80103910 <mycpu>
80104df0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104df6:	85 d2                	test   %edx,%edx
80104df8:	74 06                	je     80104e00 <popcli+0x30>
    sti();
}
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e00:	e8 0b eb ff ff       	call   80103910 <mycpu>
80104e05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e0b:	85 c0                	test   %eax,%eax
80104e0d:	74 eb                	je     80104dfa <popcli+0x2a>
  asm volatile("sti");
80104e0f:	fb                   	sti    
}
80104e10:	c9                   	leave  
80104e11:	c3                   	ret    
    panic("popcli - interruptible");
80104e12:	83 ec 0c             	sub    $0xc,%esp
80104e15:	68 33 89 10 80       	push   $0x80108933
80104e1a:	e8 71 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	68 4a 89 10 80       	push   $0x8010894a
80104e27:	e8 64 b5 ff ff       	call   80100390 <panic>
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e30 <holding>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	8b 75 08             	mov    0x8(%ebp),%esi
80104e38:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e3a:	e8 51 ff ff ff       	call   80104d90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e3f:	8b 06                	mov    (%esi),%eax
80104e41:	85 c0                	test   %eax,%eax
80104e43:	74 10                	je     80104e55 <holding+0x25>
80104e45:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e48:	e8 c3 ea ff ff       	call   80103910 <mycpu>
80104e4d:	39 c3                	cmp    %eax,%ebx
80104e4f:	0f 94 c3             	sete   %bl
80104e52:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e55:	e8 76 ff ff ff       	call   80104dd0 <popcli>
}
80104e5a:	89 d8                	mov    %ebx,%eax
80104e5c:	5b                   	pop    %ebx
80104e5d:	5e                   	pop    %esi
80104e5e:	5d                   	pop    %ebp
80104e5f:	c3                   	ret    

80104e60 <acquire>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e65:	e8 26 ff ff ff       	call   80104d90 <pushcli>
  if(holding(lk))
80104e6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	53                   	push   %ebx
80104e71:	e8 ba ff ff ff       	call   80104e30 <holding>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	0f 85 83 00 00 00    	jne    80104f04 <acquire+0xa4>
80104e81:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e83:	ba 01 00 00 00       	mov    $0x1,%edx
80104e88:	eb 09                	jmp    80104e93 <acquire+0x33>
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e93:	89 d0                	mov    %edx,%eax
80104e95:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e98:	85 c0                	test   %eax,%eax
80104e9a:	75 f4                	jne    80104e90 <acquire+0x30>
  __sync_synchronize();
80104e9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ea1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ea4:	e8 67 ea ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ea9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104eac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104eaf:	89 e8                	mov    %ebp,%eax
80104eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104eb8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104ebe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ec4:	77 1a                	ja     80104ee0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ec6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ec9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104ecc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ecf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ed1:	83 fe 0a             	cmp    $0xa,%esi
80104ed4:	75 e2                	jne    80104eb8 <acquire+0x58>
}
80104ed6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed9:	5b                   	pop    %ebx
80104eda:	5e                   	pop    %esi
80104edb:	5d                   	pop    %ebp
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
80104ee0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ee3:	83 c2 28             	add    $0x28,%edx
80104ee6:	8d 76 00             	lea    0x0(%esi),%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ef6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ef9:	39 d0                	cmp    %edx,%eax
80104efb:	75 f3                	jne    80104ef0 <acquire+0x90>
}
80104efd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f00:	5b                   	pop    %ebx
80104f01:	5e                   	pop    %esi
80104f02:	5d                   	pop    %ebp
80104f03:	c3                   	ret    
    panic("acquire");
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	68 51 89 10 80       	push   $0x80108951
80104f0c:	e8 7f b4 ff ff       	call   80100390 <panic>
80104f11:	eb 0d                	jmp    80104f20 <release>
80104f13:	90                   	nop
80104f14:	90                   	nop
80104f15:	90                   	nop
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	90                   	nop
80104f19:	90                   	nop
80104f1a:	90                   	nop
80104f1b:	90                   	nop
80104f1c:	90                   	nop
80104f1d:	90                   	nop
80104f1e:	90                   	nop
80104f1f:	90                   	nop

80104f20 <release>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 10             	sub    $0x10,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f2a:	53                   	push   %ebx
80104f2b:	e8 00 ff ff ff       	call   80104e30 <holding>
80104f30:	83 c4 10             	add    $0x10,%esp
80104f33:	85 c0                	test   %eax,%eax
80104f35:	74 22                	je     80104f59 <release+0x39>
  lk->pcs[0] = 0;
80104f37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f53:	c9                   	leave  
  popcli();
80104f54:	e9 77 fe ff ff       	jmp    80104dd0 <popcli>
    panic("release");
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	68 59 89 10 80       	push   $0x80108959
80104f61:	e8 2a b4 ff ff       	call   80100390 <panic>
80104f66:	66 90                	xchg   %ax,%ax
80104f68:	66 90                	xchg   %ax,%ax
80104f6a:	66 90                	xchg   %ax,%ax
80104f6c:	66 90                	xchg   %ax,%ax
80104f6e:	66 90                	xchg   %ax,%ax

80104f70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	53                   	push   %ebx
80104f75:	8b 55 08             	mov    0x8(%ebp),%edx
80104f78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f7b:	f6 c2 03             	test   $0x3,%dl
80104f7e:	75 05                	jne    80104f85 <memset+0x15>
80104f80:	f6 c1 03             	test   $0x3,%cl
80104f83:	74 13                	je     80104f98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f85:	89 d7                	mov    %edx,%edi
80104f87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8a:	fc                   	cld    
80104f8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f8d:	5b                   	pop    %ebx
80104f8e:	89 d0                	mov    %edx,%eax
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	90                   	nop
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f9c:	c1 e9 02             	shr    $0x2,%ecx
80104f9f:	89 f8                	mov    %edi,%eax
80104fa1:	89 fb                	mov    %edi,%ebx
80104fa3:	c1 e0 18             	shl    $0x18,%eax
80104fa6:	c1 e3 10             	shl    $0x10,%ebx
80104fa9:	09 d8                	or     %ebx,%eax
80104fab:	09 f8                	or     %edi,%eax
80104fad:	c1 e7 08             	shl    $0x8,%edi
80104fb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104fb2:	89 d7                	mov    %edx,%edi
80104fb4:	fc                   	cld    
80104fb5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104fb7:	5b                   	pop    %ebx
80104fb8:	89 d0                	mov    %edx,%eax
80104fba:	5f                   	pop    %edi
80104fbb:	5d                   	pop    %ebp
80104fbc:	c3                   	ret    
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi

80104fc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fcf:	85 db                	test   %ebx,%ebx
80104fd1:	74 29                	je     80104ffc <memcmp+0x3c>
    if(*s1 != *s2)
80104fd3:	0f b6 16             	movzbl (%esi),%edx
80104fd6:	0f b6 0f             	movzbl (%edi),%ecx
80104fd9:	38 d1                	cmp    %dl,%cl
80104fdb:	75 2b                	jne    80105008 <memcmp+0x48>
80104fdd:	b8 01 00 00 00       	mov    $0x1,%eax
80104fe2:	eb 14                	jmp    80104ff8 <memcmp+0x38>
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104fec:	83 c0 01             	add    $0x1,%eax
80104fef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ff4:	38 ca                	cmp    %cl,%dl
80104ff6:	75 10                	jne    80105008 <memcmp+0x48>
  while(n-- > 0){
80104ff8:	39 d8                	cmp    %ebx,%eax
80104ffa:	75 ec                	jne    80104fe8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104ffc:	5b                   	pop    %ebx
  return 0;
80104ffd:	31 c0                	xor    %eax,%eax
}
80104fff:	5e                   	pop    %esi
80105000:	5f                   	pop    %edi
80105001:	5d                   	pop    %ebp
80105002:	c3                   	ret    
80105003:	90                   	nop
80105004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105008:	0f b6 c2             	movzbl %dl,%eax
}
8010500b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010500c:	29 c8                	sub    %ecx,%eax
}
8010500e:	5e                   	pop    %esi
8010500f:	5f                   	pop    %edi
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	8b 45 08             	mov    0x8(%ebp),%eax
80105028:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010502b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010502e:	39 c3                	cmp    %eax,%ebx
80105030:	73 26                	jae    80105058 <memmove+0x38>
80105032:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105035:	39 c8                	cmp    %ecx,%eax
80105037:	73 1f                	jae    80105058 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105039:	85 f6                	test   %esi,%esi
8010503b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010503e:	74 0f                	je     8010504f <memmove+0x2f>
      *--d = *--s;
80105040:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105044:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105047:	83 ea 01             	sub    $0x1,%edx
8010504a:	83 fa ff             	cmp    $0xffffffff,%edx
8010504d:	75 f1                	jne    80105040 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5d                   	pop    %ebp
80105052:	c3                   	ret    
80105053:	90                   	nop
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105058:	31 d2                	xor    %edx,%edx
8010505a:	85 f6                	test   %esi,%esi
8010505c:	74 f1                	je     8010504f <memmove+0x2f>
8010505e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105060:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105064:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105067:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010506a:	39 d6                	cmp    %edx,%esi
8010506c:	75 f2                	jne    80105060 <memmove+0x40>
}
8010506e:	5b                   	pop    %ebx
8010506f:	5e                   	pop    %esi
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    
80105072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105083:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105084:	eb 9a                	jmp    80105020 <memmove>
80105086:	8d 76 00             	lea    0x0(%esi),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	8b 7d 10             	mov    0x10(%ebp),%edi
80105098:	53                   	push   %ebx
80105099:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010509c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010509f:	85 ff                	test   %edi,%edi
801050a1:	74 2f                	je     801050d2 <strncmp+0x42>
801050a3:	0f b6 01             	movzbl (%ecx),%eax
801050a6:	0f b6 1e             	movzbl (%esi),%ebx
801050a9:	84 c0                	test   %al,%al
801050ab:	74 37                	je     801050e4 <strncmp+0x54>
801050ad:	38 c3                	cmp    %al,%bl
801050af:	75 33                	jne    801050e4 <strncmp+0x54>
801050b1:	01 f7                	add    %esi,%edi
801050b3:	eb 13                	jmp    801050c8 <strncmp+0x38>
801050b5:	8d 76 00             	lea    0x0(%esi),%esi
801050b8:	0f b6 01             	movzbl (%ecx),%eax
801050bb:	84 c0                	test   %al,%al
801050bd:	74 21                	je     801050e0 <strncmp+0x50>
801050bf:	0f b6 1a             	movzbl (%edx),%ebx
801050c2:	89 d6                	mov    %edx,%esi
801050c4:	38 d8                	cmp    %bl,%al
801050c6:	75 1c                	jne    801050e4 <strncmp+0x54>
    n--, p++, q++;
801050c8:	8d 56 01             	lea    0x1(%esi),%edx
801050cb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050ce:	39 fa                	cmp    %edi,%edx
801050d0:	75 e6                	jne    801050b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801050d2:	5b                   	pop    %ebx
    return 0;
801050d3:	31 c0                	xor    %eax,%eax
}
801050d5:	5e                   	pop    %esi
801050d6:	5f                   	pop    %edi
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801050e4:	29 d8                	sub    %ebx,%eax
}
801050e6:	5b                   	pop    %ebx
801050e7:	5e                   	pop    %esi
801050e8:	5f                   	pop    %edi
801050e9:	5d                   	pop    %ebp
801050ea:	c3                   	ret    
801050eb:	90                   	nop
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
801050f5:	8b 45 08             	mov    0x8(%ebp),%eax
801050f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050fe:	89 c2                	mov    %eax,%edx
80105100:	eb 19                	jmp    8010511b <strncpy+0x2b>
80105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105108:	83 c3 01             	add    $0x1,%ebx
8010510b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010510f:	83 c2 01             	add    $0x1,%edx
80105112:	84 c9                	test   %cl,%cl
80105114:	88 4a ff             	mov    %cl,-0x1(%edx)
80105117:	74 09                	je     80105122 <strncpy+0x32>
80105119:	89 f1                	mov    %esi,%ecx
8010511b:	85 c9                	test   %ecx,%ecx
8010511d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105120:	7f e6                	jg     80105108 <strncpy+0x18>
    ;
  while(n-- > 0)
80105122:	31 c9                	xor    %ecx,%ecx
80105124:	85 f6                	test   %esi,%esi
80105126:	7e 17                	jle    8010513f <strncpy+0x4f>
80105128:	90                   	nop
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105130:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105134:	89 f3                	mov    %esi,%ebx
80105136:	83 c1 01             	add    $0x1,%ecx
80105139:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010513b:	85 db                	test   %ebx,%ebx
8010513d:	7f f1                	jg     80105130 <strncpy+0x40>
  return os;
}
8010513f:	5b                   	pop    %ebx
80105140:	5e                   	pop    %esi
80105141:	5d                   	pop    %ebp
80105142:	c3                   	ret    
80105143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
80105155:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105158:	8b 45 08             	mov    0x8(%ebp),%eax
8010515b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010515e:	85 c9                	test   %ecx,%ecx
80105160:	7e 26                	jle    80105188 <safestrcpy+0x38>
80105162:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105166:	89 c1                	mov    %eax,%ecx
80105168:	eb 17                	jmp    80105181 <safestrcpy+0x31>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105170:	83 c2 01             	add    $0x1,%edx
80105173:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105177:	83 c1 01             	add    $0x1,%ecx
8010517a:	84 db                	test   %bl,%bl
8010517c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010517f:	74 04                	je     80105185 <safestrcpy+0x35>
80105181:	39 f2                	cmp    %esi,%edx
80105183:	75 eb                	jne    80105170 <safestrcpy+0x20>
    ;
  *s = 0;
80105185:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105188:	5b                   	pop    %ebx
80105189:	5e                   	pop    %esi
8010518a:	5d                   	pop    %ebp
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <strlen>:

int
strlen(const char *s)
{
80105190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105198:	80 3a 00             	cmpb   $0x0,(%edx)
8010519b:	74 0c                	je     801051a9 <strlen+0x19>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c0 01             	add    $0x1,%eax
801051a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051a7:	75 f7                	jne    801051a0 <strlen+0x10>
    ;
  return n;
}
801051a9:	5d                   	pop    %ebp
801051aa:	c3                   	ret    

801051ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051b3:	55                   	push   %ebp
  pushl %ebx
801051b4:	53                   	push   %ebx
  pushl %esi
801051b5:	56                   	push   %esi
  pushl %edi
801051b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051bb:	5f                   	pop    %edi
  popl %esi
801051bc:	5e                   	pop    %esi
  popl %ebx
801051bd:	5b                   	pop    %ebx
  popl %ebp
801051be:	5d                   	pop    %ebp
  ret
801051bf:	c3                   	ret    

801051c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 04             	sub    $0x4,%esp
801051c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051ca:	e8 e1 e7 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051cf:	8b 00                	mov    (%eax),%eax
801051d1:	39 d8                	cmp    %ebx,%eax
801051d3:	76 1b                	jbe    801051f0 <fetchint+0x30>
801051d5:	8d 53 04             	lea    0x4(%ebx),%edx
801051d8:	39 d0                	cmp    %edx,%eax
801051da:	72 14                	jb     801051f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801051df:	8b 13                	mov    (%ebx),%edx
801051e1:	89 10                	mov    %edx,(%eax)
  return 0;
801051e3:	31 c0                	xor    %eax,%eax
}
801051e5:	83 c4 04             	add    $0x4,%esp
801051e8:	5b                   	pop    %ebx
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	eb ee                	jmp    801051e5 <fetchint+0x25>
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	53                   	push   %ebx
80105204:	83 ec 04             	sub    $0x4,%esp
80105207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010520a:	e8 a1 e7 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
8010520f:	39 18                	cmp    %ebx,(%eax)
80105211:	76 29                	jbe    8010523c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105216:	89 da                	mov    %ebx,%edx
80105218:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010521a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010521c:	39 c3                	cmp    %eax,%ebx
8010521e:	73 1c                	jae    8010523c <fetchstr+0x3c>
    if(*s == 0)
80105220:	80 3b 00             	cmpb   $0x0,(%ebx)
80105223:	75 10                	jne    80105235 <fetchstr+0x35>
80105225:	eb 39                	jmp    80105260 <fetchstr+0x60>
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105230:	80 3a 00             	cmpb   $0x0,(%edx)
80105233:	74 1b                	je     80105250 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105235:	83 c2 01             	add    $0x1,%edx
80105238:	39 d0                	cmp    %edx,%eax
8010523a:	77 f4                	ja     80105230 <fetchstr+0x30>
    return -1;
8010523c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105241:	83 c4 04             	add    $0x4,%esp
80105244:	5b                   	pop    %ebx
80105245:	5d                   	pop    %ebp
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105250:	83 c4 04             	add    $0x4,%esp
80105253:	89 d0                	mov    %edx,%eax
80105255:	29 d8                	sub    %ebx,%eax
80105257:	5b                   	pop    %ebx
80105258:	5d                   	pop    %ebp
80105259:	c3                   	ret    
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105260:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105262:	eb dd                	jmp    80105241 <fetchstr+0x41>
80105264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010526a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105270 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105275:	e8 36 e7 ff ff       	call   801039b0 <myproc>
8010527a:	8b 40 18             	mov    0x18(%eax),%eax
8010527d:	8b 55 08             	mov    0x8(%ebp),%edx
80105280:	8b 40 44             	mov    0x44(%eax),%eax
80105283:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105286:	e8 25 e7 ff ff       	call   801039b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010528b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010528d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105290:	39 c6                	cmp    %eax,%esi
80105292:	73 1c                	jae    801052b0 <argint+0x40>
80105294:	8d 53 08             	lea    0x8(%ebx),%edx
80105297:	39 d0                	cmp    %edx,%eax
80105299:	72 15                	jb     801052b0 <argint+0x40>
  *ip = *(int*)(addr);
8010529b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010529e:	8b 53 04             	mov    0x4(%ebx),%edx
801052a1:	89 10                	mov    %edx,(%eax)
  return 0;
801052a3:	31 c0                	xor    %eax,%eax
}
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5d                   	pop    %ebp
801052a8:	c3                   	ret    
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052b5:	eb ee                	jmp    801052a5 <argint+0x35>
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
801052c5:	83 ec 10             	sub    $0x10,%esp
801052c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801052cb:	e8 e0 e6 ff ff       	call   801039b0 <myproc>
801052d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801052d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d5:	83 ec 08             	sub    $0x8,%esp
801052d8:	50                   	push   %eax
801052d9:	ff 75 08             	pushl  0x8(%ebp)
801052dc:	e8 8f ff ff ff       	call   80105270 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	85 c0                	test   %eax,%eax
801052e6:	78 28                	js     80105310 <argptr+0x50>
801052e8:	85 db                	test   %ebx,%ebx
801052ea:	78 24                	js     80105310 <argptr+0x50>
801052ec:	8b 16                	mov    (%esi),%edx
801052ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f1:	39 c2                	cmp    %eax,%edx
801052f3:	76 1b                	jbe    80105310 <argptr+0x50>
801052f5:	01 c3                	add    %eax,%ebx
801052f7:	39 da                	cmp    %ebx,%edx
801052f9:	72 15                	jb     80105310 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801052fe:	89 02                	mov    %eax,(%edx)
  return 0;
80105300:	31 c0                	xor    %eax,%eax
}
80105302:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105305:	5b                   	pop    %ebx
80105306:	5e                   	pop    %esi
80105307:	5d                   	pop    %ebp
80105308:	c3                   	ret    
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105315:	eb eb                	jmp    80105302 <argptr+0x42>
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105326:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105329:	50                   	push   %eax
8010532a:	ff 75 08             	pushl  0x8(%ebp)
8010532d:	e8 3e ff ff ff       	call   80105270 <argint>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	85 c0                	test   %eax,%eax
80105337:	78 17                	js     80105350 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105339:	83 ec 08             	sub    $0x8,%esp
8010533c:	ff 75 0c             	pushl  0xc(%ebp)
8010533f:	ff 75 f4             	pushl  -0xc(%ebp)
80105342:	e8 b9 fe ff ff       	call   80105200 <fetchstr>
80105347:	83 c4 10             	add    $0x10,%esp
}
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <syscall>:
[SYS_print_information]     sys_print_information,
};

void
syscall(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	53                   	push   %ebx
80105364:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105367:	e8 44 e6 ff ff       	call   801039b0 <myproc>
8010536c:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
8010536e:	8b 40 18             	mov    0x18(%eax),%eax
80105371:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105374:	8d 50 ff             	lea    -0x1(%eax),%edx
80105377:	83 fa 1c             	cmp    $0x1c,%edx
8010537a:	77 1c                	ja     80105398 <syscall+0x38>
8010537c:	8b 14 85 80 89 10 80 	mov    -0x7fef7680(,%eax,4),%edx
80105383:	85 d2                	test   %edx,%edx
80105385:	74 11                	je     80105398 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105387:	ff d2                	call   *%edx
80105389:	8b 53 18             	mov    0x18(%ebx),%edx
8010538c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010538f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105392:	c9                   	leave  
80105393:	c3                   	ret    
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105398:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105399:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010539c:	50                   	push   %eax
8010539d:	ff 73 10             	pushl  0x10(%ebx)
801053a0:	68 61 89 10 80       	push   $0x80108961
801053a5:	e8 b6 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801053aa:	8b 43 18             	mov    0x18(%ebx),%eax
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ba:	c9                   	leave  
801053bb:	c3                   	ret    
801053bc:	66 90                	xchg   %ax,%ax
801053be:	66 90                	xchg   %ax,%ax

801053c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801053c9:	83 ec 34             	sub    $0x34,%esp
801053cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053d2:	56                   	push   %esi
801053d3:	50                   	push   %eax
{
801053d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053da:	e8 f1 cc ff ff       	call   801020d0 <nameiparent>
801053df:	83 c4 10             	add    $0x10,%esp
801053e2:	85 c0                	test   %eax,%eax
801053e4:	0f 84 46 01 00 00    	je     80105530 <create+0x170>
    return 0;
  ilock(dp);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	89 c3                	mov    %eax,%ebx
801053ef:	50                   	push   %eax
801053f0:	e8 5b c4 ff ff       	call   80101850 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053f5:	83 c4 0c             	add    $0xc,%esp
801053f8:	6a 00                	push   $0x0
801053fa:	56                   	push   %esi
801053fb:	53                   	push   %ebx
801053fc:	e8 7f c9 ff ff       	call   80101d80 <dirlookup>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	85 c0                	test   %eax,%eax
80105406:	89 c7                	mov    %eax,%edi
80105408:	74 36                	je     80105440 <create+0x80>
    iunlockput(dp);
8010540a:	83 ec 0c             	sub    $0xc,%esp
8010540d:	53                   	push   %ebx
8010540e:	e8 cd c6 ff ff       	call   80101ae0 <iunlockput>
    ilock(ip);
80105413:	89 3c 24             	mov    %edi,(%esp)
80105416:	e8 35 c4 ff ff       	call   80101850 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010541b:	83 c4 10             	add    $0x10,%esp
8010541e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105423:	0f 85 97 00 00 00    	jne    801054c0 <create+0x100>
80105429:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010542e:	0f 85 8c 00 00 00    	jne    801054c0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105434:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105437:	89 f8                	mov    %edi,%eax
80105439:	5b                   	pop    %ebx
8010543a:	5e                   	pop    %esi
8010543b:	5f                   	pop    %edi
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105440:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	50                   	push   %eax
80105448:	ff 33                	pushl  (%ebx)
8010544a:	e8 91 c2 ff ff       	call   801016e0 <ialloc>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	89 c7                	mov    %eax,%edi
80105456:	0f 84 e8 00 00 00    	je     80105544 <create+0x184>
  ilock(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	50                   	push   %eax
80105460:	e8 eb c3 ff ff       	call   80101850 <ilock>
  ip->major = major;
80105465:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105469:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010546d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105471:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105475:	b8 01 00 00 00       	mov    $0x1,%eax
8010547a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010547e:	89 3c 24             	mov    %edi,(%esp)
80105481:	e8 1a c3 ff ff       	call   801017a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010548e:	74 50                	je     801054e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105490:	83 ec 04             	sub    $0x4,%esp
80105493:	ff 77 04             	pushl  0x4(%edi)
80105496:	56                   	push   %esi
80105497:	53                   	push   %ebx
80105498:	e8 53 cb ff ff       	call   80101ff0 <dirlink>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 88 8f 00 00 00    	js     80105537 <create+0x177>
  iunlockput(dp);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	53                   	push   %ebx
801054ac:	e8 2f c6 ff ff       	call   80101ae0 <iunlockput>
  return ip;
801054b1:	83 c4 10             	add    $0x10,%esp
}
801054b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b7:	89 f8                	mov    %edi,%eax
801054b9:	5b                   	pop    %ebx
801054ba:	5e                   	pop    %esi
801054bb:	5f                   	pop    %edi
801054bc:	5d                   	pop    %ebp
801054bd:	c3                   	ret    
801054be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	57                   	push   %edi
    return 0;
801054c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801054c6:	e8 15 c6 ff ff       	call   80101ae0 <iunlockput>
    return 0;
801054cb:	83 c4 10             	add    $0x10,%esp
}
801054ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d1:	89 f8                	mov    %edi,%eax
801054d3:	5b                   	pop    %ebx
801054d4:	5e                   	pop    %esi
801054d5:	5f                   	pop    %edi
801054d6:	5d                   	pop    %ebp
801054d7:	c3                   	ret    
801054d8:	90                   	nop
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801054e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	53                   	push   %ebx
801054e9:	e8 b2 c2 ff ff       	call   801017a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054ee:	83 c4 0c             	add    $0xc,%esp
801054f1:	ff 77 04             	pushl  0x4(%edi)
801054f4:	68 14 8a 10 80       	push   $0x80108a14
801054f9:	57                   	push   %edi
801054fa:	e8 f1 ca ff ff       	call   80101ff0 <dirlink>
801054ff:	83 c4 10             	add    $0x10,%esp
80105502:	85 c0                	test   %eax,%eax
80105504:	78 1c                	js     80105522 <create+0x162>
80105506:	83 ec 04             	sub    $0x4,%esp
80105509:	ff 73 04             	pushl  0x4(%ebx)
8010550c:	68 13 8a 10 80       	push   $0x80108a13
80105511:	57                   	push   %edi
80105512:	e8 d9 ca ff ff       	call   80101ff0 <dirlink>
80105517:	83 c4 10             	add    $0x10,%esp
8010551a:	85 c0                	test   %eax,%eax
8010551c:	0f 89 6e ff ff ff    	jns    80105490 <create+0xd0>
      panic("create dots");
80105522:	83 ec 0c             	sub    $0xc,%esp
80105525:	68 07 8a 10 80       	push   $0x80108a07
8010552a:	e8 61 ae ff ff       	call   80100390 <panic>
8010552f:	90                   	nop
    return 0;
80105530:	31 ff                	xor    %edi,%edi
80105532:	e9 fd fe ff ff       	jmp    80105434 <create+0x74>
    panic("create: dirlink");
80105537:	83 ec 0c             	sub    $0xc,%esp
8010553a:	68 16 8a 10 80       	push   $0x80108a16
8010553f:	e8 4c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	68 f8 89 10 80       	push   $0x801089f8
8010554c:	e8 3f ae ff ff       	call   80100390 <panic>
80105551:	eb 0d                	jmp    80105560 <argfd.constprop.0>
80105553:	90                   	nop
80105554:	90                   	nop
80105555:	90                   	nop
80105556:	90                   	nop
80105557:	90                   	nop
80105558:	90                   	nop
80105559:	90                   	nop
8010555a:	90                   	nop
8010555b:	90                   	nop
8010555c:	90                   	nop
8010555d:	90                   	nop
8010555e:	90                   	nop
8010555f:	90                   	nop

80105560 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
80105565:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105567:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010556a:	89 d6                	mov    %edx,%esi
8010556c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010556f:	50                   	push   %eax
80105570:	6a 00                	push   $0x0
80105572:	e8 f9 fc ff ff       	call   80105270 <argint>
80105577:	83 c4 10             	add    $0x10,%esp
8010557a:	85 c0                	test   %eax,%eax
8010557c:	78 2a                	js     801055a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010557e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105582:	77 24                	ja     801055a8 <argfd.constprop.0+0x48>
80105584:	e8 27 e4 ff ff       	call   801039b0 <myproc>
80105589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010558c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105590:	85 c0                	test   %eax,%eax
80105592:	74 14                	je     801055a8 <argfd.constprop.0+0x48>
  if(pfd)
80105594:	85 db                	test   %ebx,%ebx
80105596:	74 02                	je     8010559a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105598:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010559a:	89 06                	mov    %eax,(%esi)
  return 0;
8010559c:	31 c0                	xor    %eax,%eax
}
8010559e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055a1:	5b                   	pop    %ebx
801055a2:	5e                   	pop    %esi
801055a3:	5d                   	pop    %ebp
801055a4:	c3                   	ret    
801055a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb ef                	jmp    8010559e <argfd.constprop.0+0x3e>
801055af:	90                   	nop

801055b0 <sys_dup>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[9] ++;
801055b8:	e8 f3 e3 ff ff       	call   801039b0 <myproc>
801055bd:	83 80 a0 00 00 00 01 	addl   $0x1,0xa0(%eax)
  if(argfd(0, 0, &f) < 0)
801055c4:	8d 55 f4             	lea    -0xc(%ebp),%edx
801055c7:	31 c0                	xor    %eax,%eax
801055c9:	e8 92 ff ff ff       	call   80105560 <argfd.constprop.0>
801055ce:	85 c0                	test   %eax,%eax
801055d0:	78 3e                	js     80105610 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
801055d2:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055d5:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055d7:	e8 d4 e3 ff ff       	call   801039b0 <myproc>
801055dc:	eb 0a                	jmp    801055e8 <sys_dup+0x38>
801055de:	66 90                	xchg   %ax,%ax
  for(fd = 0; fd < NOFILE; fd++){
801055e0:	83 c3 01             	add    $0x1,%ebx
801055e3:	83 fb 10             	cmp    $0x10,%ebx
801055e6:	74 28                	je     80105610 <sys_dup+0x60>
    if(curproc->ofile[fd] == 0){
801055e8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055ec:	85 d2                	test   %edx,%edx
801055ee:	75 f0                	jne    801055e0 <sys_dup+0x30>
      curproc->ofile[fd] = f;
801055f0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055f4:	83 ec 0c             	sub    $0xc,%esp
801055f7:	ff 75 f4             	pushl  -0xc(%ebp)
801055fa:	e8 c1 b9 ff ff       	call   80100fc0 <filedup>
  return fd;
801055ff:	83 c4 10             	add    $0x10,%esp
}
80105602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105605:	89 d8                	mov    %ebx,%eax
80105607:	5b                   	pop    %ebx
80105608:	5e                   	pop    %esi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    
8010560b:	90                   	nop
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105610:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105613:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105618:	89 d8                	mov    %ebx,%eax
8010561a:	5b                   	pop    %ebx
8010561b:	5e                   	pop    %esi
8010561c:	5d                   	pop    %ebp
8010561d:	c3                   	ret    
8010561e:	66 90                	xchg   %ax,%ax

80105620 <sys_read>:
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[4] ++;
80105626:	e8 85 e3 ff ff       	call   801039b0 <myproc>
8010562b:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105632:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105635:	31 c0                	xor    %eax,%eax
80105637:	e8 24 ff ff ff       	call   80105560 <argfd.constprop.0>
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 48                	js     80105688 <sys_read+0x68>
80105640:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105643:	83 ec 08             	sub    $0x8,%esp
80105646:	50                   	push   %eax
80105647:	6a 02                	push   $0x2
80105649:	e8 22 fc ff ff       	call   80105270 <argint>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	78 33                	js     80105688 <sys_read+0x68>
80105655:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105658:	83 ec 04             	sub    $0x4,%esp
8010565b:	ff 75 f0             	pushl  -0x10(%ebp)
8010565e:	50                   	push   %eax
8010565f:	6a 01                	push   $0x1
80105661:	e8 5a fc ff ff       	call   801052c0 <argptr>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	78 1b                	js     80105688 <sys_read+0x68>
  return fileread(f, p, n);
8010566d:	83 ec 04             	sub    $0x4,%esp
80105670:	ff 75 f0             	pushl  -0x10(%ebp)
80105673:	ff 75 f4             	pushl  -0xc(%ebp)
80105676:	ff 75 ec             	pushl  -0x14(%ebp)
80105679:	e8 b2 ba ff ff       	call   80101130 <fileread>
8010567e:	83 c4 10             	add    $0x10,%esp
}
80105681:	c9                   	leave  
80105682:	c3                   	ret    
80105683:	90                   	nop
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop

80105690 <sys_write>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[15] ++;
80105696:	e8 15 e3 ff ff       	call   801039b0 <myproc>
8010569b:	83 80 b8 00 00 00 01 	addl   $0x1,0xb8(%eax)
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056a2:	8d 55 ec             	lea    -0x14(%ebp),%edx
801056a5:	31 c0                	xor    %eax,%eax
801056a7:	e8 b4 fe ff ff       	call   80105560 <argfd.constprop.0>
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 48                	js     801056f8 <sys_write+0x68>
801056b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b3:	83 ec 08             	sub    $0x8,%esp
801056b6:	50                   	push   %eax
801056b7:	6a 02                	push   $0x2
801056b9:	e8 b2 fb ff ff       	call   80105270 <argint>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 33                	js     801056f8 <sys_write+0x68>
801056c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c8:	83 ec 04             	sub    $0x4,%esp
801056cb:	ff 75 f0             	pushl  -0x10(%ebp)
801056ce:	50                   	push   %eax
801056cf:	6a 01                	push   $0x1
801056d1:	e8 ea fb ff ff       	call   801052c0 <argptr>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	78 1b                	js     801056f8 <sys_write+0x68>
  return filewrite(f, p, n);
801056dd:	83 ec 04             	sub    $0x4,%esp
801056e0:	ff 75 f0             	pushl  -0x10(%ebp)
801056e3:	ff 75 f4             	pushl  -0xc(%ebp)
801056e6:	ff 75 ec             	pushl  -0x14(%ebp)
801056e9:	e8 d2 ba ff ff       	call   801011c0 <filewrite>
801056ee:	83 c4 10             	add    $0x10,%esp
}
801056f1:	c9                   	leave  
801056f2:	c3                   	ret    
801056f3:	90                   	nop
801056f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056fd:	c9                   	leave  
801056fe:	c3                   	ret    
801056ff:	90                   	nop

80105700 <sys_close>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[20] ++;
80105706:	e8 a5 e2 ff ff       	call   801039b0 <myproc>
8010570b:	83 80 cc 00 00 00 01 	addl   $0x1,0xcc(%eax)
  if(argfd(0, &fd, &f) < 0)
80105712:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105715:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105718:	e8 43 fe ff ff       	call   80105560 <argfd.constprop.0>
8010571d:	85 c0                	test   %eax,%eax
8010571f:	78 27                	js     80105748 <sys_close+0x48>
  myproc()->ofile[fd] = 0;
80105721:	e8 8a e2 ff ff       	call   801039b0 <myproc>
80105726:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105729:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010572c:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105733:	00 
  fileclose(f);
80105734:	ff 75 f4             	pushl  -0xc(%ebp)
80105737:	e8 d4 b8 ff ff       	call   80101010 <fileclose>
  return 0;
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	31 c0                	xor    %eax,%eax
}
80105741:	c9                   	leave  
80105742:	c3                   	ret    
80105743:	90                   	nop
80105744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010574d:	c9                   	leave  
8010574e:	c3                   	ret    
8010574f:	90                   	nop

80105750 <sys_fstat>:
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[7] ++;
80105756:	e8 55 e2 ff ff       	call   801039b0 <myproc>
8010575b:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105762:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105765:	31 c0                	xor    %eax,%eax
80105767:	e8 f4 fd ff ff       	call   80105560 <argfd.constprop.0>
8010576c:	85 c0                	test   %eax,%eax
8010576e:	78 30                	js     801057a0 <sys_fstat+0x50>
80105770:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105773:	83 ec 04             	sub    $0x4,%esp
80105776:	6a 14                	push   $0x14
80105778:	50                   	push   %eax
80105779:	6a 01                	push   $0x1
8010577b:	e8 40 fb ff ff       	call   801052c0 <argptr>
80105780:	83 c4 10             	add    $0x10,%esp
80105783:	85 c0                	test   %eax,%eax
80105785:	78 19                	js     801057a0 <sys_fstat+0x50>
  return filestat(f, st);
80105787:	83 ec 08             	sub    $0x8,%esp
8010578a:	ff 75 f4             	pushl  -0xc(%ebp)
8010578d:	ff 75 f0             	pushl  -0x10(%ebp)
80105790:	e8 4b b9 ff ff       	call   801010e0 <filestat>
80105795:	83 c4 10             	add    $0x10,%esp
}
80105798:	c9                   	leave  
80105799:	c3                   	ret    
8010579a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <sys_link>:
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	57                   	push   %edi
801057b4:	56                   	push   %esi
801057b5:	53                   	push   %ebx
801057b6:	83 ec 2c             	sub    $0x2c,%esp
  myproc()->call_nums[18] ++;
801057b9:	e8 f2 e1 ff ff       	call   801039b0 <myproc>
801057be:	83 80 c4 00 00 00 01 	addl   $0x1,0xc4(%eax)
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	50                   	push   %eax
801057cc:	6a 00                	push   $0x0
801057ce:	e8 4d fb ff ff       	call   80105320 <argstr>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	0f 88 fc 00 00 00    	js     801058da <sys_link+0x12a>
801057de:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	50                   	push   %eax
801057e5:	6a 01                	push   $0x1
801057e7:	e8 34 fb ff ff       	call   80105320 <argstr>
801057ec:	83 c4 10             	add    $0x10,%esp
801057ef:	85 c0                	test   %eax,%eax
801057f1:	0f 88 e3 00 00 00    	js     801058da <sys_link+0x12a>
  begin_op();
801057f7:	e8 74 d5 ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	ff 75 d4             	pushl  -0x2c(%ebp)
80105802:	e8 a9 c8 ff ff       	call   801020b0 <namei>
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	85 c0                	test   %eax,%eax
8010580c:	89 c3                	mov    %eax,%ebx
8010580e:	0f 84 eb 00 00 00    	je     801058ff <sys_link+0x14f>
  ilock(ip);
80105814:	83 ec 0c             	sub    $0xc,%esp
80105817:	50                   	push   %eax
80105818:	e8 33 c0 ff ff       	call   80101850 <ilock>
  if(ip->type == T_DIR){
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105825:	0f 84 bc 00 00 00    	je     801058e7 <sys_link+0x137>
  ip->nlink++;
8010582b:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105830:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105833:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105836:	53                   	push   %ebx
80105837:	e8 64 bf ff ff       	call   801017a0 <iupdate>
  iunlock(ip);
8010583c:	89 1c 24             	mov    %ebx,(%esp)
8010583f:	e8 ec c0 ff ff       	call   80101930 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105844:	58                   	pop    %eax
80105845:	5a                   	pop    %edx
80105846:	57                   	push   %edi
80105847:	ff 75 d0             	pushl  -0x30(%ebp)
8010584a:	e8 81 c8 ff ff       	call   801020d0 <nameiparent>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	85 c0                	test   %eax,%eax
80105854:	89 c6                	mov    %eax,%esi
80105856:	74 5c                	je     801058b4 <sys_link+0x104>
  ilock(dp);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	50                   	push   %eax
8010585c:	e8 ef bf ff ff       	call   80101850 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	8b 03                	mov    (%ebx),%eax
80105866:	39 06                	cmp    %eax,(%esi)
80105868:	75 3e                	jne    801058a8 <sys_link+0xf8>
8010586a:	83 ec 04             	sub    $0x4,%esp
8010586d:	ff 73 04             	pushl  0x4(%ebx)
80105870:	57                   	push   %edi
80105871:	56                   	push   %esi
80105872:	e8 79 c7 ff ff       	call   80101ff0 <dirlink>
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	85 c0                	test   %eax,%eax
8010587c:	78 2a                	js     801058a8 <sys_link+0xf8>
  iunlockput(dp);
8010587e:	83 ec 0c             	sub    $0xc,%esp
80105881:	56                   	push   %esi
80105882:	e8 59 c2 ff ff       	call   80101ae0 <iunlockput>
  iput(ip);
80105887:	89 1c 24             	mov    %ebx,(%esp)
8010588a:	e8 f1 c0 ff ff       	call   80101980 <iput>
  end_op();
8010588f:	e8 4c d5 ff ff       	call   80102de0 <end_op>
  return 0;
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	31 c0                	xor    %eax,%eax
}
80105899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010589c:	5b                   	pop    %ebx
8010589d:	5e                   	pop    %esi
8010589e:	5f                   	pop    %edi
8010589f:	5d                   	pop    %ebp
801058a0:	c3                   	ret    
801058a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
801058a8:	83 ec 0c             	sub    $0xc,%esp
801058ab:	56                   	push   %esi
801058ac:	e8 2f c2 ff ff       	call   80101ae0 <iunlockput>
    goto bad;
801058b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801058b4:	83 ec 0c             	sub    $0xc,%esp
801058b7:	53                   	push   %ebx
801058b8:	e8 93 bf ff ff       	call   80101850 <ilock>
  ip->nlink--;
801058bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058c2:	89 1c 24             	mov    %ebx,(%esp)
801058c5:	e8 d6 be ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
801058ca:	89 1c 24             	mov    %ebx,(%esp)
801058cd:	e8 0e c2 ff ff       	call   80101ae0 <iunlockput>
  end_op();
801058d2:	e8 09 d5 ff ff       	call   80102de0 <end_op>
  return -1;
801058d7:	83 c4 10             	add    $0x10,%esp
}
801058da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e2:	5b                   	pop    %ebx
801058e3:	5e                   	pop    %esi
801058e4:	5f                   	pop    %edi
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
    iunlockput(ip);
801058e7:	83 ec 0c             	sub    $0xc,%esp
801058ea:	53                   	push   %ebx
801058eb:	e8 f0 c1 ff ff       	call   80101ae0 <iunlockput>
    end_op();
801058f0:	e8 eb d4 ff ff       	call   80102de0 <end_op>
    return -1;
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fd:	eb 9a                	jmp    80105899 <sys_link+0xe9>
    end_op();
801058ff:	e8 dc d4 ff ff       	call   80102de0 <end_op>
    return -1;
80105904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105909:	eb 8e                	jmp    80105899 <sys_link+0xe9>
8010590b:	90                   	nop
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_unlink>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
80105916:	83 ec 3c             	sub    $0x3c,%esp
  myproc()->call_nums[17] ++;
80105919:	e8 92 e0 ff ff       	call   801039b0 <myproc>
8010591e:	83 80 c0 00 00 00 01 	addl   $0x1,0xc0(%eax)
  if(argstr(0, &path) < 0)
80105925:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105928:	83 ec 08             	sub    $0x8,%esp
8010592b:	50                   	push   %eax
8010592c:	6a 00                	push   $0x0
8010592e:	e8 ed f9 ff ff       	call   80105320 <argstr>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	0f 88 78 01 00 00    	js     80105ab6 <sys_unlink+0x1a6>
  if((dp = nameiparent(path, name)) == 0){
8010593e:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105941:	e8 2a d4 ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105946:	83 ec 08             	sub    $0x8,%esp
80105949:	53                   	push   %ebx
8010594a:	ff 75 c0             	pushl  -0x40(%ebp)
8010594d:	e8 7e c7 ff ff       	call   801020d0 <nameiparent>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	89 c6                	mov    %eax,%esi
80105959:	0f 84 61 01 00 00    	je     80105ac0 <sys_unlink+0x1b0>
  ilock(dp);
8010595f:	83 ec 0c             	sub    $0xc,%esp
80105962:	50                   	push   %eax
80105963:	e8 e8 be ff ff       	call   80101850 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105968:	58                   	pop    %eax
80105969:	5a                   	pop    %edx
8010596a:	68 14 8a 10 80       	push   $0x80108a14
8010596f:	53                   	push   %ebx
80105970:	e8 eb c3 ff ff       	call   80101d60 <namecmp>
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	85 c0                	test   %eax,%eax
8010597a:	0f 84 04 01 00 00    	je     80105a84 <sys_unlink+0x174>
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	68 13 8a 10 80       	push   $0x80108a13
80105988:	53                   	push   %ebx
80105989:	e8 d2 c3 ff ff       	call   80101d60 <namecmp>
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	85 c0                	test   %eax,%eax
80105993:	0f 84 eb 00 00 00    	je     80105a84 <sys_unlink+0x174>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105999:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010599c:	83 ec 04             	sub    $0x4,%esp
8010599f:	50                   	push   %eax
801059a0:	53                   	push   %ebx
801059a1:	56                   	push   %esi
801059a2:	e8 d9 c3 ff ff       	call   80101d80 <dirlookup>
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	85 c0                	test   %eax,%eax
801059ac:	89 c3                	mov    %eax,%ebx
801059ae:	0f 84 d0 00 00 00    	je     80105a84 <sys_unlink+0x174>
  ilock(ip);
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	50                   	push   %eax
801059b8:	e8 93 be ff ff       	call   80101850 <ilock>
  if(ip->nlink < 1)
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059c5:	0f 8e 11 01 00 00    	jle    80105adc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801059cb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059d0:	74 6e                	je     80105a40 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801059d2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059d5:	83 ec 04             	sub    $0x4,%esp
801059d8:	6a 10                	push   $0x10
801059da:	6a 00                	push   $0x0
801059dc:	50                   	push   %eax
801059dd:	e8 8e f5 ff ff       	call   80104f70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059e5:	6a 10                	push   $0x10
801059e7:	ff 75 c4             	pushl  -0x3c(%ebp)
801059ea:	50                   	push   %eax
801059eb:	56                   	push   %esi
801059ec:	e8 3f c2 ff ff       	call   80101c30 <writei>
801059f1:	83 c4 20             	add    $0x20,%esp
801059f4:	83 f8 10             	cmp    $0x10,%eax
801059f7:	0f 85 ec 00 00 00    	jne    80105ae9 <sys_unlink+0x1d9>
  if(ip->type == T_DIR){
801059fd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a02:	0f 84 98 00 00 00    	je     80105aa0 <sys_unlink+0x190>
  iunlockput(dp);
80105a08:	83 ec 0c             	sub    $0xc,%esp
80105a0b:	56                   	push   %esi
80105a0c:	e8 cf c0 ff ff       	call   80101ae0 <iunlockput>
  ip->nlink--;
80105a11:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a16:	89 1c 24             	mov    %ebx,(%esp)
80105a19:	e8 82 bd ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
80105a1e:	89 1c 24             	mov    %ebx,(%esp)
80105a21:	e8 ba c0 ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105a26:	e8 b5 d3 ff ff       	call   80102de0 <end_op>
  return 0;
80105a2b:	83 c4 10             	add    $0x10,%esp
80105a2e:	31 c0                	xor    %eax,%eax
}
80105a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a33:	5b                   	pop    %ebx
80105a34:	5e                   	pop    %esi
80105a35:	5f                   	pop    %edi
80105a36:	5d                   	pop    %ebp
80105a37:	c3                   	ret    
80105a38:	90                   	nop
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a44:	76 8c                	jbe    801059d2 <sys_unlink+0xc2>
80105a46:	bf 20 00 00 00       	mov    $0x20,%edi
80105a4b:	eb 0f                	jmp    80105a5c <sys_unlink+0x14c>
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
80105a50:	83 c7 10             	add    $0x10,%edi
80105a53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105a56:	0f 83 76 ff ff ff    	jae    801059d2 <sys_unlink+0xc2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a5c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a5f:	6a 10                	push   $0x10
80105a61:	57                   	push   %edi
80105a62:	50                   	push   %eax
80105a63:	53                   	push   %ebx
80105a64:	e8 c7 c0 ff ff       	call   80101b30 <readi>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	83 f8 10             	cmp    $0x10,%eax
80105a6f:	75 5e                	jne    80105acf <sys_unlink+0x1bf>
    if(de.inum != 0)
80105a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a76:	74 d8                	je     80105a50 <sys_unlink+0x140>
    iunlockput(ip);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	53                   	push   %ebx
80105a7c:	e8 5f c0 ff ff       	call   80101ae0 <iunlockput>
    goto bad;
80105a81:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	56                   	push   %esi
80105a88:	e8 53 c0 ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105a8d:	e8 4e d3 ff ff       	call   80102de0 <end_op>
  return -1;
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9a:	eb 94                	jmp    80105a30 <sys_unlink+0x120>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105aa0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105aa5:	83 ec 0c             	sub    $0xc,%esp
80105aa8:	56                   	push   %esi
80105aa9:	e8 f2 bc ff ff       	call   801017a0 <iupdate>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	e9 52 ff ff ff       	jmp    80105a08 <sys_unlink+0xf8>
    return -1;
80105ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abb:	e9 70 ff ff ff       	jmp    80105a30 <sys_unlink+0x120>
    end_op();
80105ac0:	e8 1b d3 ff ff       	call   80102de0 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aca:	e9 61 ff ff ff       	jmp    80105a30 <sys_unlink+0x120>
      panic("isdirempty: readi");
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	68 38 8a 10 80       	push   $0x80108a38
80105ad7:	e8 b4 a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105adc:	83 ec 0c             	sub    $0xc,%esp
80105adf:	68 26 8a 10 80       	push   $0x80108a26
80105ae4:	e8 a7 a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	68 4a 8a 10 80       	push   $0x80108a4a
80105af1:	e8 9a a8 ff ff       	call   80100390 <panic>
80105af6:	8d 76 00             	lea    0x0(%esi),%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_open>:

int
sys_open(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
80105b06:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[14] ++;
80105b09:	e8 a2 de ff ff       	call   801039b0 <myproc>
80105b0e:	83 80 b4 00 00 00 01 	addl   $0x1,0xb4(%eax)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b15:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b18:	83 ec 08             	sub    $0x8,%esp
80105b1b:	50                   	push   %eax
80105b1c:	6a 00                	push   $0x0
80105b1e:	e8 fd f7 ff ff       	call   80105320 <argstr>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	0f 88 1e 01 00 00    	js     80105c4c <sys_open+0x14c>
80105b2e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b31:	83 ec 08             	sub    $0x8,%esp
80105b34:	50                   	push   %eax
80105b35:	6a 01                	push   $0x1
80105b37:	e8 34 f7 ff ff       	call   80105270 <argint>
80105b3c:	83 c4 10             	add    $0x10,%esp
80105b3f:	85 c0                	test   %eax,%eax
80105b41:	0f 88 05 01 00 00    	js     80105c4c <sys_open+0x14c>
    return -1;

  begin_op();
80105b47:	e8 24 d2 ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105b4c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b50:	0f 85 aa 00 00 00    	jne    80105c00 <sys_open+0x100>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b56:	83 ec 0c             	sub    $0xc,%esp
80105b59:	ff 75 e0             	pushl  -0x20(%ebp)
80105b5c:	e8 4f c5 ff ff       	call   801020b0 <namei>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	89 c6                	mov    %eax,%esi
80105b68:	0f 84 b3 00 00 00    	je     80105c21 <sys_open+0x121>
      end_op();
      return -1;
    }
    ilock(ip);
80105b6e:	83 ec 0c             	sub    $0xc,%esp
80105b71:	50                   	push   %eax
80105b72:	e8 d9 bc ff ff       	call   80101850 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b77:	83 c4 10             	add    $0x10,%esp
80105b7a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b7f:	0f 84 ab 00 00 00    	je     80105c30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b85:	e8 c6 b3 ff ff       	call   80100f50 <filealloc>
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	89 c7                	mov    %eax,%edi
80105b8e:	0f 84 a7 00 00 00    	je     80105c3b <sys_open+0x13b>
  struct proc *curproc = myproc();
80105b94:	e8 17 de ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b99:	31 db                	xor    %ebx,%ebx
80105b9b:	eb 0f                	jmp    80105bac <sys_open+0xac>
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi
80105ba0:	83 c3 01             	add    $0x1,%ebx
80105ba3:	83 fb 10             	cmp    $0x10,%ebx
80105ba6:	0f 84 ac 00 00 00    	je     80105c58 <sys_open+0x158>
    if(curproc->ofile[fd] == 0){
80105bac:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bb0:	85 d2                	test   %edx,%edx
80105bb2:	75 ec                	jne    80105ba0 <sys_open+0xa0>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105bb4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105bb7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bbb:	56                   	push   %esi
80105bbc:	e8 6f bd ff ff       	call   80101930 <iunlock>
  end_op();
80105bc1:	e8 1a d2 ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
80105bc6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bcf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bd2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105bd5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bdc:	89 d0                	mov    %edx,%eax
80105bde:	f7 d0                	not    %eax
80105be0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105be3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105be6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105be9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf0:	89 d8                	mov    %ebx,%eax
80105bf2:	5b                   	pop    %ebx
80105bf3:	5e                   	pop    %esi
80105bf4:	5f                   	pop    %edi
80105bf5:	5d                   	pop    %ebp
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c06:	31 c9                	xor    %ecx,%ecx
80105c08:	6a 00                	push   $0x0
80105c0a:	ba 02 00 00 00       	mov    $0x2,%edx
80105c0f:	e8 ac f7 ff ff       	call   801053c0 <create>
    if(ip == 0){
80105c14:	83 c4 10             	add    $0x10,%esp
80105c17:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105c19:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c1b:	0f 85 64 ff ff ff    	jne    80105b85 <sys_open+0x85>
      end_op();
80105c21:	e8 ba d1 ff ff       	call   80102de0 <end_op>
      return -1;
80105c26:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c2b:	eb c0                	jmp    80105bed <sys_open+0xed>
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c33:	85 c9                	test   %ecx,%ecx
80105c35:	0f 84 4a ff ff ff    	je     80105b85 <sys_open+0x85>
    iunlockput(ip);
80105c3b:	83 ec 0c             	sub    $0xc,%esp
80105c3e:	56                   	push   %esi
80105c3f:	e8 9c be ff ff       	call   80101ae0 <iunlockput>
    end_op();
80105c44:	e8 97 d1 ff ff       	call   80102de0 <end_op>
    return -1;
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c51:	eb 9a                	jmp    80105bed <sys_open+0xed>
80105c53:	90                   	nop
80105c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	57                   	push   %edi
80105c5c:	e8 af b3 ff ff       	call   80101010 <fileclose>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	eb d5                	jmp    80105c3b <sys_open+0x13b>
80105c66:	8d 76 00             	lea    0x0(%esi),%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[19] ++;
80105c76:	e8 35 dd ff ff       	call   801039b0 <myproc>
80105c7b:	83 80 c8 00 00 00 01 	addl   $0x1,0xc8(%eax)
  char *path;
  struct inode *ip;

  begin_op();
80105c82:	e8 e9 d0 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8a:	83 ec 08             	sub    $0x8,%esp
80105c8d:	50                   	push   %eax
80105c8e:	6a 00                	push   $0x0
80105c90:	e8 8b f6 ff ff       	call   80105320 <argstr>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	78 34                	js     80105cd0 <sys_mkdir+0x60>
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca2:	31 c9                	xor    %ecx,%ecx
80105ca4:	6a 00                	push   $0x0
80105ca6:	ba 01 00 00 00       	mov    $0x1,%edx
80105cab:	e8 10 f7 ff ff       	call   801053c0 <create>
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	85 c0                	test   %eax,%eax
80105cb5:	74 19                	je     80105cd0 <sys_mkdir+0x60>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cb7:	83 ec 0c             	sub    $0xc,%esp
80105cba:	50                   	push   %eax
80105cbb:	e8 20 be ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105cc0:	e8 1b d1 ff ff       	call   80102de0 <end_op>
  return 0;
80105cc5:	83 c4 10             	add    $0x10,%esp
80105cc8:	31 c0                	xor    %eax,%eax
}
80105cca:	c9                   	leave  
80105ccb:	c3                   	ret    
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105cd0:	e8 0b d1 ff ff       	call   80102de0 <end_op>
    return -1;
80105cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cda:	c9                   	leave  
80105cdb:	c3                   	ret    
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_mknod>:

int
sys_mknod(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[16] ++;
80105ce6:	e8 c5 dc ff ff       	call   801039b0 <myproc>
80105ceb:	83 80 bc 00 00 00 01 	addl   $0x1,0xbc(%eax)
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cf2:	e8 79 d0 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105cf7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cfa:	83 ec 08             	sub    $0x8,%esp
80105cfd:	50                   	push   %eax
80105cfe:	6a 00                	push   $0x0
80105d00:	e8 1b f6 ff ff       	call   80105320 <argstr>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	85 c0                	test   %eax,%eax
80105d0a:	78 64                	js     80105d70 <sys_mknod+0x90>
     argint(1, &major) < 0 ||
80105d0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d0f:	83 ec 08             	sub    $0x8,%esp
80105d12:	50                   	push   %eax
80105d13:	6a 01                	push   $0x1
80105d15:	e8 56 f5 ff ff       	call   80105270 <argint>
  if((argstr(0, &path)) < 0 ||
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	85 c0                	test   %eax,%eax
80105d1f:	78 4f                	js     80105d70 <sys_mknod+0x90>
     argint(2, &minor) < 0 ||
80105d21:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d24:	83 ec 08             	sub    $0x8,%esp
80105d27:	50                   	push   %eax
80105d28:	6a 02                	push   $0x2
80105d2a:	e8 41 f5 ff ff       	call   80105270 <argint>
     argint(1, &major) < 0 ||
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	78 3a                	js     80105d70 <sys_mknod+0x90>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d36:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d3a:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d3d:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105d41:	ba 03 00 00 00       	mov    $0x3,%edx
80105d46:	50                   	push   %eax
80105d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d4a:	e8 71 f6 ff ff       	call   801053c0 <create>
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	85 c0                	test   %eax,%eax
80105d54:	74 1a                	je     80105d70 <sys_mknod+0x90>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d56:	83 ec 0c             	sub    $0xc,%esp
80105d59:	50                   	push   %eax
80105d5a:	e8 81 bd ff ff       	call   80101ae0 <iunlockput>
  end_op();
80105d5f:	e8 7c d0 ff ff       	call   80102de0 <end_op>
  return 0;
80105d64:	83 c4 10             	add    $0x10,%esp
80105d67:	31 c0                	xor    %eax,%eax
}
80105d69:	c9                   	leave  
80105d6a:	c3                   	ret    
80105d6b:	90                   	nop
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d70:	e8 6b d0 ff ff       	call   80102de0 <end_op>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7a:	c9                   	leave  
80105d7b:	c3                   	ret    
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_chdir>:

int
sys_chdir(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	56                   	push   %esi
80105d84:	53                   	push   %ebx
80105d85:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[8] ++;
80105d88:	e8 23 dc ff ff       	call   801039b0 <myproc>
80105d8d:	83 80 9c 00 00 00 01 	addl   $0x1,0x9c(%eax)
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d94:	e8 17 dc ff ff       	call   801039b0 <myproc>
80105d99:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d9b:	e8 d0 cf ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da3:	83 ec 08             	sub    $0x8,%esp
80105da6:	50                   	push   %eax
80105da7:	6a 00                	push   $0x0
80105da9:	e8 72 f5 ff ff       	call   80105320 <argstr>
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	85 c0                	test   %eax,%eax
80105db3:	78 6b                	js     80105e20 <sys_chdir+0xa0>
80105db5:	83 ec 0c             	sub    $0xc,%esp
80105db8:	ff 75 f4             	pushl  -0xc(%ebp)
80105dbb:	e8 f0 c2 ff ff       	call   801020b0 <namei>
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	85 c0                	test   %eax,%eax
80105dc5:	89 c3                	mov    %eax,%ebx
80105dc7:	74 57                	je     80105e20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105dc9:	83 ec 0c             	sub    $0xc,%esp
80105dcc:	50                   	push   %eax
80105dcd:	e8 7e ba ff ff       	call   80101850 <ilock>
  if(ip->type != T_DIR){
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dda:	75 2c                	jne    80105e08 <sys_chdir+0x88>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	53                   	push   %ebx
80105de0:	e8 4b bb ff ff       	call   80101930 <iunlock>
  iput(curproc->cwd);
80105de5:	58                   	pop    %eax
80105de6:	ff 76 68             	pushl  0x68(%esi)
80105de9:	e8 92 bb ff ff       	call   80101980 <iput>
  end_op();
80105dee:	e8 ed cf ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
80105df3:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	31 c0                	xor    %eax,%eax
}
80105dfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dfe:	5b                   	pop    %ebx
80105dff:	5e                   	pop    %esi
80105e00:	5d                   	pop    %ebp
80105e01:	c3                   	ret    
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e08:	83 ec 0c             	sub    $0xc,%esp
80105e0b:	53                   	push   %ebx
80105e0c:	e8 cf bc ff ff       	call   80101ae0 <iunlockput>
    end_op();
80105e11:	e8 ca cf ff ff       	call   80102de0 <end_op>
    return -1;
80105e16:	83 c4 10             	add    $0x10,%esp
80105e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1e:	eb db                	jmp    80105dfb <sys_chdir+0x7b>
    end_op();
80105e20:	e8 bb cf ff ff       	call   80102de0 <end_op>
    return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2a:	eb cf                	jmp    80105dfb <sys_chdir+0x7b>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <rand>:
int rand(int m){
80105e30:	55                   	push   %ebp
 int random;
 int a = ticks % m;
80105e31:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80105e36:	31 d2                	xor    %edx,%edx
int rand(int m){
80105e38:	89 e5                	mov    %esp,%ebp
80105e3a:	53                   	push   %ebx
80105e3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
80105e3e:	f7 f1                	div    %ecx
 int seed = ticks % m;
 random = (a * seed )% m;
80105e40:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80105e42:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80105e44:	0f af c2             	imul   %edx,%eax
80105e47:	99                   	cltd   
80105e48:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
80105e4a:	89 d0                	mov    %edx,%eax
80105e4c:	0f af c3             	imul   %ebx,%eax
 return random; 
}
80105e4f:	5b                   	pop    %ebx
80105e50:	5d                   	pop    %ebp
 random = (a * random )% m;
80105e51:	99                   	cltd   
80105e52:	f7 f9                	idiv   %ecx
}
80105e54:	89 d0                	mov    %edx,%eax
80105e56:	c3                   	ret    
80105e57:	89 f6                	mov    %esi,%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <sys_exec>:
int
sys_exec(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	56                   	push   %esi
80105e65:	53                   	push   %ebx
 int a = ticks % m;
80105e66:	bb d3 4d 62 10       	mov    $0x10624dd3,%ebx
{
80105e6b:	81 ec ac 00 00 00    	sub    $0xac,%esp
  myproc()->call_nums[6] ++;
80105e71:	e8 3a db ff ff       	call   801039b0 <myproc>
80105e76:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
  myproc()->level = 2;
80105e7d:	e8 2e db ff ff       	call   801039b0 <myproc>
80105e82:	c7 80 f4 00 00 00 02 	movl   $0x2,0xf4(%eax)
80105e89:	00 00 00 
  myproc()->visit = 0;
80105e8c:	e8 1f db ff ff       	call   801039b0 <myproc>
80105e91:	c7 80 14 01 00 00 00 	movl   $0x0,0x114(%eax)
80105e98:	00 00 00 
  myproc()->waiting_time = 0;
80105e9b:	e8 10 db ff ff       	call   801039b0 <myproc>
80105ea0:	c7 80 18 01 00 00 00 	movl   $0x0,0x118(%eax)
80105ea7:	00 00 00 
  myproc()->last_cycle = 0;
80105eaa:	e8 01 db ff ff       	call   801039b0 <myproc>
 int a = ticks % m;
80105eaf:	8b 35 40 8e 11 80    	mov    0x80118e40,%esi
  myproc()->last_cycle = 0;
80105eb5:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80105ebc:	00 00 00 
 int a = ticks % m;
80105ebf:	89 f0                	mov    %esi,%eax
80105ec1:	f7 e3                	mul    %ebx
80105ec3:	c1 ea 06             	shr    $0x6,%edx
80105ec6:	69 ca e8 03 00 00    	imul   $0x3e8,%edx,%ecx
80105ecc:	29 ce                	sub    %ecx,%esi
80105ece:	89 f1                	mov    %esi,%ecx
 random = (a * seed )% m;
80105ed0:	0f af f6             	imul   %esi,%esi
80105ed3:	89 f0                	mov    %esi,%eax
80105ed5:	f7 e3                	mul    %ebx
80105ed7:	c1 ea 06             	shr    $0x6,%edx
80105eda:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
80105ee0:	29 d6                	sub    %edx,%esi
 random = (a * random )% m;
80105ee2:	0f af ce             	imul   %esi,%ecx
80105ee5:	89 c8                	mov    %ecx,%eax
80105ee7:	f7 e3                	mul    %ebx
80105ee9:	89 d3                	mov    %edx,%ebx
80105eeb:	c1 eb 06             	shr    $0x6,%ebx
80105eee:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
80105ef4:	29 d9                	sub    %ebx,%ecx
80105ef6:	89 cb                	mov    %ecx,%ebx
  int random = rand(1000);
  myproc()->lottery_ticket = random;
80105ef8:	e8 b3 da ff ff       	call   801039b0 <myproc>
80105efd:	89 98 10 01 00 00    	mov    %ebx,0x110(%eax)
  myproc()->priority = 1/random;
80105f03:	e8 a8 da ff ff       	call   801039b0 <myproc>
80105f08:	89 c1                	mov    %eax,%ecx
80105f0a:	b8 01 00 00 00       	mov    $0x1,%eax
80105f0f:	99                   	cltd   
80105f10:	f7 fb                	idiv   %ebx
80105f12:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
80105f18:	db 85 48 ff ff ff    	fildl  -0xb8(%ebp)
80105f1e:	d9 99 f8 00 00 00    	fstps  0xf8(%ecx)
  myproc()->priority_ratio = rand(50) / 1000;
80105f24:	e8 87 da ff ff       	call   801039b0 <myproc>
  myproc()->arrivt = ticks;
80105f29:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  myproc()->priority_ratio = rand(50) / 1000;
80105f2f:	c7 80 fc 00 00 00 00 	movl   $0x0,0xfc(%eax)
80105f36:	00 00 00 
  myproc()->arrivt = ticks;
80105f39:	e8 72 da ff ff       	call   801039b0 <myproc>
80105f3e:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%ebp)
80105f45:	00 00 00 
80105f48:	89 9d 48 ff ff ff    	mov    %ebx,-0xb8(%ebp)
80105f4e:	df ad 48 ff ff ff    	fildll -0xb8(%ebp)
80105f54:	d9 98 00 01 00 00    	fstps  0x100(%eax)
  myproc()->arrivt_ratio = rand(50) / 1000;
80105f5a:	e8 51 da ff ff       	call   801039b0 <myproc>
80105f5f:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
80105f66:	00 00 00 
  myproc()->exect = 0.1;
80105f69:	e8 42 da ff ff       	call   801039b0 <myproc>
80105f6e:	c7 80 08 01 00 00 cd 	movl   $0x3dcccccd,0x108(%eax)
80105f75:	cc cc 3d 
  myproc()->exect_ratio = rand(50) / 1000;
80105f78:	e8 33 da ff ff       	call   801039b0 <myproc>
80105f7d:	c7 80 0c 01 00 00 00 	movl   $0x0,0x10c(%eax)
80105f84:	00 00 00 
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f87:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105f8d:	83 ec 08             	sub    $0x8,%esp
80105f90:	50                   	push   %eax
80105f91:	6a 00                	push   $0x0
80105f93:	e8 88 f3 ff ff       	call   80105320 <argstr>
80105f98:	83 c4 10             	add    $0x10,%esp
80105f9b:	85 c0                	test   %eax,%eax
80105f9d:	0f 88 89 00 00 00    	js     8010602c <sys_exec+0x1cc>
80105fa3:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105fa9:	83 ec 08             	sub    $0x8,%esp
80105fac:	50                   	push   %eax
80105fad:	6a 01                	push   $0x1
80105faf:	e8 bc f2 ff ff       	call   80105270 <argint>
80105fb4:	83 c4 10             	add    $0x10,%esp
80105fb7:	85 c0                	test   %eax,%eax
80105fb9:	78 71                	js     8010602c <sys_exec+0x1cc>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105fbb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105fc1:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105fc4:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fc6:	68 80 00 00 00       	push   $0x80
80105fcb:	6a 00                	push   $0x0
80105fcd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105fd3:	50                   	push   %eax
80105fd4:	e8 97 ef ff ff       	call   80104f70 <memset>
80105fd9:	83 c4 10             	add    $0x10,%esp
80105fdc:	eb 2e                	jmp    8010600c <sys_exec+0x1ac>
80105fde:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105fe0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105fe6:	85 c0                	test   %eax,%eax
80105fe8:	74 56                	je     80106040 <sys_exec+0x1e0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105fea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105ff6:	52                   	push   %edx
80105ff7:	50                   	push   %eax
80105ff8:	e8 03 f2 ff ff       	call   80105200 <fetchstr>
80105ffd:	83 c4 10             	add    $0x10,%esp
80106000:	85 c0                	test   %eax,%eax
80106002:	78 28                	js     8010602c <sys_exec+0x1cc>
  for(i=0;; i++){
80106004:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106007:	83 fb 20             	cmp    $0x20,%ebx
8010600a:	74 20                	je     8010602c <sys_exec+0x1cc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010600c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106012:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106019:	83 ec 08             	sub    $0x8,%esp
8010601c:	57                   	push   %edi
8010601d:	01 f0                	add    %esi,%eax
8010601f:	50                   	push   %eax
80106020:	e8 9b f1 ff ff       	call   801051c0 <fetchint>
80106025:	83 c4 10             	add    $0x10,%esp
80106028:	85 c0                	test   %eax,%eax
8010602a:	79 b4                	jns    80105fe0 <sys_exec+0x180>
      return -1;
  }
  return exec(path, argv);
}
8010602c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010602f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
80106038:	c3                   	ret    
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106040:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106046:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106049:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106050:	00 00 00 00 
  return exec(path, argv);
80106054:	50                   	push   %eax
80106055:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010605b:	e8 80 ab ff ff       	call   80100be0 <exec>
80106060:	83 c4 10             	add    $0x10,%esp
}
80106063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106066:	5b                   	pop    %ebx
80106067:	5e                   	pop    %esi
80106068:	5f                   	pop    %edi
80106069:	5d                   	pop    %ebp
8010606a:	c3                   	ret    
8010606b:	90                   	nop
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_pipe>:

int
sys_pipe(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
80106076:	83 ec 1c             	sub    $0x1c,%esp
  myproc()->call_nums[3] ++;
80106079:	e8 32 d9 ff ff       	call   801039b0 <myproc>
8010607e:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106085:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106088:	83 ec 04             	sub    $0x4,%esp
8010608b:	6a 08                	push   $0x8
8010608d:	50                   	push   %eax
8010608e:	6a 00                	push   $0x0
80106090:	e8 2b f2 ff ff       	call   801052c0 <argptr>
80106095:	83 c4 10             	add    $0x10,%esp
80106098:	85 c0                	test   %eax,%eax
8010609a:	0f 88 af 00 00 00    	js     8010614f <sys_pipe+0xdf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801060a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060a3:	83 ec 08             	sub    $0x8,%esp
801060a6:	50                   	push   %eax
801060a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060aa:	50                   	push   %eax
801060ab:	e8 60 d3 ff ff       	call   80103410 <pipealloc>
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	85 c0                	test   %eax,%eax
801060b5:	0f 88 94 00 00 00    	js     8010614f <sys_pipe+0xdf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060bb:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801060be:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801060c0:	e8 eb d8 ff ff       	call   801039b0 <myproc>
801060c5:	eb 11                	jmp    801060d8 <sys_pipe+0x68>
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(fd = 0; fd < NOFILE; fd++){
801060d0:	83 c3 01             	add    $0x1,%ebx
801060d3:	83 fb 10             	cmp    $0x10,%ebx
801060d6:	74 60                	je     80106138 <sys_pipe+0xc8>
    if(curproc->ofile[fd] == 0){
801060d8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801060dc:	85 f6                	test   %esi,%esi
801060de:	75 f0                	jne    801060d0 <sys_pipe+0x60>
      curproc->ofile[fd] = f;
801060e0:	8d 73 08             	lea    0x8(%ebx),%esi
801060e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801060ea:	e8 c1 d8 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ef:	31 d2                	xor    %edx,%edx
801060f1:	eb 0d                	jmp    80106100 <sys_pipe+0x90>
801060f3:	90                   	nop
801060f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060f8:	83 c2 01             	add    $0x1,%edx
801060fb:	83 fa 10             	cmp    $0x10,%edx
801060fe:	74 28                	je     80106128 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106100:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106104:	85 c9                	test   %ecx,%ecx
80106106:	75 f0                	jne    801060f8 <sys_pipe+0x88>
      curproc->ofile[fd] = f;
80106108:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010610c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010610f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106111:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106114:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106117:	31 c0                	xor    %eax,%eax
}
80106119:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010611c:	5b                   	pop    %ebx
8010611d:	5e                   	pop    %esi
8010611e:	5f                   	pop    %edi
8010611f:	5d                   	pop    %ebp
80106120:	c3                   	ret    
80106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106128:	e8 83 d8 ff ff       	call   801039b0 <myproc>
8010612d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106134:	00 
80106135:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	ff 75 e0             	pushl  -0x20(%ebp)
8010613e:	e8 cd ae ff ff       	call   80101010 <fileclose>
    fileclose(wf);
80106143:	58                   	pop    %eax
80106144:	ff 75 e4             	pushl  -0x1c(%ebp)
80106147:	e8 c4 ae ff ff       	call   80101010 <fileclose>
    return -1;
8010614c:	83 c4 10             	add    $0x10,%esp
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106154:	eb c3                	jmp    80106119 <sys_pipe+0xa9>
80106156:	66 90                	xchg   %ax,%ax
80106158:	66 90                	xchg   %ax,%ax
8010615a:	66 90                	xchg   %ax,%ax
8010615c:	66 90                	xchg   %ax,%ax
8010615e:	66 90                	xchg   %ax,%ax

80106160 <gen_rand>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int gen_rand(int m){
80106160:	55                   	push   %ebp
 int random;
 int a = ticks % m;
80106161:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80106166:	31 d2                	xor    %edx,%edx
int gen_rand(int m){
80106168:	89 e5                	mov    %esp,%ebp
8010616a:	53                   	push   %ebx
8010616b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 int a = ticks % m;
8010616e:	f7 f1                	div    %ecx
 int seed = ticks % m;
 random = (a * seed )% m;
80106170:	89 d0                	mov    %edx,%eax
 int a = ticks % m;
80106172:	89 d3                	mov    %edx,%ebx
 random = (a * seed )% m;
80106174:	0f af c2             	imul   %edx,%eax
80106177:	99                   	cltd   
80106178:	f7 f9                	idiv   %ecx
 random = (a * random )% m;
8010617a:	89 d0                	mov    %edx,%eax
8010617c:	0f af c3             	imul   %ebx,%eax
 return random; 
}
8010617f:	5b                   	pop    %ebx
80106180:	5d                   	pop    %ebp
 random = (a * random )% m;
80106181:	99                   	cltd   
80106182:	f7 f9                	idiv   %ecx
}
80106184:	89 d0                	mov    %edx,%eax
80106186:	c3                   	ret    
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106190 <sys_fork>:

int
sys_fork(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	56                   	push   %esi
80106194:	53                   	push   %ebx
 int a = ticks % m;
80106195:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
{
8010619a:	83 ec 10             	sub    $0x10,%esp
  myproc()->call_nums[0] ++;
8010619d:	e8 0e d8 ff ff       	call   801039b0 <myproc>
801061a2:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
  myproc()->level = 2;
801061a6:	e8 05 d8 ff ff       	call   801039b0 <myproc>
801061ab:	c7 80 f4 00 00 00 02 	movl   $0x2,0xf4(%eax)
801061b2:	00 00 00 
  myproc()->visit = 0;
801061b5:	e8 f6 d7 ff ff       	call   801039b0 <myproc>
801061ba:	c7 80 14 01 00 00 00 	movl   $0x0,0x114(%eax)
801061c1:	00 00 00 
  myproc()->waiting_time = 0;
801061c4:	e8 e7 d7 ff ff       	call   801039b0 <myproc>
801061c9:	c7 80 18 01 00 00 00 	movl   $0x0,0x118(%eax)
801061d0:	00 00 00 
  myproc()->last_cycle = 0;
801061d3:	e8 d8 d7 ff ff       	call   801039b0 <myproc>
 int a = ticks % m;
801061d8:	8b 35 40 8e 11 80    	mov    0x80118e40,%esi
  myproc()->last_cycle = 0;
801061de:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
801061e5:	00 00 00 
 int a = ticks % m;
801061e8:	89 f0                	mov    %esi,%eax
801061ea:	f7 e3                	mul    %ebx
801061ec:	c1 ea 05             	shr    $0x5,%edx
801061ef:	6b ca 64             	imul   $0x64,%edx,%ecx
801061f2:	29 ce                	sub    %ecx,%esi
801061f4:	89 f1                	mov    %esi,%ecx
 random = (a * seed )% m;
801061f6:	0f af f6             	imul   %esi,%esi
801061f9:	89 f0                	mov    %esi,%eax
801061fb:	f7 e3                	mul    %ebx
801061fd:	c1 ea 05             	shr    $0x5,%edx
80106200:	6b d2 64             	imul   $0x64,%edx,%edx
80106203:	29 d6                	sub    %edx,%esi
 random = (a * random )% m;
80106205:	0f af ce             	imul   %esi,%ecx
80106208:	89 c8                	mov    %ecx,%eax
8010620a:	f7 e3                	mul    %ebx
8010620c:	89 d3                	mov    %edx,%ebx
8010620e:	c1 eb 05             	shr    $0x5,%ebx
80106211:	6b db 64             	imul   $0x64,%ebx,%ebx
80106214:	29 d9                	sub    %ebx,%ecx
80106216:	89 cb                	mov    %ecx,%ebx
  int random = gen_rand(100);
  myproc()->lottery_ticket = random;
80106218:	e8 93 d7 ff ff       	call   801039b0 <myproc>
8010621d:	89 98 10 01 00 00    	mov    %ebx,0x110(%eax)
  myproc()->priority = 1/random;
80106223:	e8 88 d7 ff ff       	call   801039b0 <myproc>
80106228:	89 c1                	mov    %eax,%ecx
8010622a:	b8 01 00 00 00       	mov    $0x1,%eax
8010622f:	99                   	cltd   
80106230:	f7 fb                	idiv   %ebx
80106232:	89 45 e8             	mov    %eax,-0x18(%ebp)
80106235:	db 45 e8             	fildl  -0x18(%ebp)
80106238:	d9 99 f8 00 00 00    	fstps  0xf8(%ecx)
  myproc()->priority_ratio = gen_rand(50) / 100;
8010623e:	e8 6d d7 ff ff       	call   801039b0 <myproc>
  myproc()->arrivt = ticks;
80106243:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  myproc()->priority_ratio = gen_rand(50) / 100;
80106249:	c7 80 fc 00 00 00 00 	movl   $0x0,0xfc(%eax)
80106250:	00 00 00 
  myproc()->arrivt = ticks;
80106253:	e8 58 d7 ff ff       	call   801039b0 <myproc>
80106258:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010625f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
80106262:	df 6d e8             	fildll -0x18(%ebp)
80106265:	d9 98 00 01 00 00    	fstps  0x100(%eax)
  myproc()->arrivt_ratio = gen_rand(50) / 100;
8010626b:	e8 40 d7 ff ff       	call   801039b0 <myproc>
80106270:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
80106277:	00 00 00 
  myproc()->exect = 0.1;
8010627a:	e8 31 d7 ff ff       	call   801039b0 <myproc>
8010627f:	c7 80 08 01 00 00 cd 	movl   $0x3dcccccd,0x108(%eax)
80106286:	cc cc 3d 
  myproc()->exect_ratio = gen_rand(50) / 100;
80106289:	e8 22 d7 ff ff       	call   801039b0 <myproc>
8010628e:	c7 80 0c 01 00 00 00 	movl   $0x0,0x10c(%eax)
80106295:	00 00 00 
 


  return fork();
}
80106298:	83 c4 10             	add    $0x10,%esp
8010629b:	5b                   	pop    %ebx
8010629c:	5e                   	pop    %esi
8010629d:	5d                   	pop    %ebp
  return fork();
8010629e:	e9 ad d8 ff ff       	jmp    80103b50 <fork>
801062a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062b0 <sys_exit>:

int
sys_exit(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[1] ++;
801062b6:	e8 f5 d6 ff ff       	call   801039b0 <myproc>
801062bb:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
  exit();
801062c2:	e8 a9 dd ff ff       	call   80104070 <exit>
  return 0;  // not reached
}
801062c7:	31 c0                	xor    %eax,%eax
801062c9:	c9                   	leave  
801062ca:	c3                   	ret    
801062cb:	90                   	nop
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_wait>:

int
sys_wait(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[2] ++;
801062d6:	e8 d5 d6 ff ff       	call   801039b0 <myproc>
801062db:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  return wait();
}
801062e2:	c9                   	leave  
  return wait();
801062e3:	e9 c8 df ff ff       	jmp    801042b0 <wait>
801062e8:	90                   	nop
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062f0 <sys_kill>:

int
sys_kill(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  myproc()->call_nums[5] ++;
801062f6:	e8 b5 d6 ff ff       	call   801039b0 <myproc>
801062fb:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)

  if(argint(0, &pid) < 0)
80106302:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106305:	83 ec 08             	sub    $0x8,%esp
80106308:	50                   	push   %eax
80106309:	6a 00                	push   $0x0
8010630b:	e8 60 ef ff ff       	call   80105270 <argint>
80106310:	83 c4 10             	add    $0x10,%esp
80106313:	85 c0                	test   %eax,%eax
80106315:	78 19                	js     80106330 <sys_kill+0x40>
    return -1;
  return kill(pid);
80106317:	83 ec 0c             	sub    $0xc,%esp
8010631a:	ff 75 f4             	pushl  -0xc(%ebp)
8010631d:	e8 ee e0 ff ff       	call   80104410 <kill>
80106322:	83 c4 10             	add    $0x10,%esp
}
80106325:	c9                   	leave  
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106335:	c9                   	leave  
80106336:	c3                   	ret    
80106337:	89 f6                	mov    %esi,%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106340 <sys_getpid>:

int
sys_getpid(void)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	83 ec 08             	sub    $0x8,%esp
  
  myproc()->call_nums[10] ++;
80106346:	e8 65 d6 ff ff       	call   801039b0 <myproc>
8010634b:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
  return myproc()->pid;
80106352:	e8 59 d6 ff ff       	call   801039b0 <myproc>
80106357:	8b 40 10             	mov    0x10(%eax),%eax
}
8010635a:	c9                   	leave  
8010635b:	c3                   	ret    
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_sbrk>:

int
sys_sbrk(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	53                   	push   %ebx
80106364:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[11] ++;
80106367:	e8 44 d6 ff ff       	call   801039b0 <myproc>
8010636c:	83 80 a8 00 00 00 01 	addl   $0x1,0xa8(%eax)
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106373:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106376:	83 ec 08             	sub    $0x8,%esp
80106379:	50                   	push   %eax
8010637a:	6a 00                	push   $0x0
8010637c:	e8 ef ee ff ff       	call   80105270 <argint>
80106381:	83 c4 10             	add    $0x10,%esp
80106384:	85 c0                	test   %eax,%eax
80106386:	78 28                	js     801063b0 <sys_sbrk+0x50>
    return -1;
  addr = myproc()->sz;
80106388:	e8 23 d6 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
8010638d:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106390:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106392:	ff 75 f4             	pushl  -0xc(%ebp)
80106395:	e8 36 d7 ff ff       	call   80103ad0 <growproc>
8010639a:	83 c4 10             	add    $0x10,%esp
8010639d:	85 c0                	test   %eax,%eax
8010639f:	78 0f                	js     801063b0 <sys_sbrk+0x50>
    return -1;
  return addr;
}
801063a1:	89 d8                	mov    %ebx,%eax
801063a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063a6:	c9                   	leave  
801063a7:	c3                   	ret    
801063a8:	90                   	nop
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063b5:	eb ea                	jmp    801063a1 <sys_sbrk+0x41>
801063b7:	89 f6                	mov    %esi,%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <sys_sleep>:

int
sys_sleep(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	53                   	push   %ebx
801063c4:	83 ec 14             	sub    $0x14,%esp
  myproc()->call_nums[12] ++;
801063c7:	e8 e4 d5 ff ff       	call   801039b0 <myproc>
801063cc:	83 80 ac 00 00 00 01 	addl   $0x1,0xac(%eax)
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063d6:	83 ec 08             	sub    $0x8,%esp
801063d9:	50                   	push   %eax
801063da:	6a 00                	push   $0x0
801063dc:	e8 8f ee ff ff       	call   80105270 <argint>
801063e1:	83 c4 10             	add    $0x10,%esp
801063e4:	85 c0                	test   %eax,%eax
801063e6:	0f 88 8b 00 00 00    	js     80106477 <sys_sleep+0xb7>
    return -1;
  acquire(&tickslock);
801063ec:	83 ec 0c             	sub    $0xc,%esp
801063ef:	68 00 86 11 80       	push   $0x80118600
801063f4:	e8 67 ea ff ff       	call   80104e60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801063f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063fc:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801063ff:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  while(ticks - ticks0 < n){
80106405:	85 d2                	test   %edx,%edx
80106407:	75 28                	jne    80106431 <sys_sleep+0x71>
80106409:	eb 55                	jmp    80106460 <sys_sleep+0xa0>
8010640b:	90                   	nop
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106410:	83 ec 08             	sub    $0x8,%esp
80106413:	68 00 86 11 80       	push   $0x80118600
80106418:	68 40 8e 11 80       	push   $0x80118e40
8010641d:	e8 ce dd ff ff       	call   801041f0 <sleep>
  while(ticks - ticks0 < n){
80106422:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80106427:	83 c4 10             	add    $0x10,%esp
8010642a:	29 d8                	sub    %ebx,%eax
8010642c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010642f:	73 2f                	jae    80106460 <sys_sleep+0xa0>
    if(myproc()->killed){
80106431:	e8 7a d5 ff ff       	call   801039b0 <myproc>
80106436:	8b 40 24             	mov    0x24(%eax),%eax
80106439:	85 c0                	test   %eax,%eax
8010643b:	74 d3                	je     80106410 <sys_sleep+0x50>
      release(&tickslock);
8010643d:	83 ec 0c             	sub    $0xc,%esp
80106440:	68 00 86 11 80       	push   $0x80118600
80106445:	e8 d6 ea ff ff       	call   80104f20 <release>
      return -1;
8010644a:	83 c4 10             	add    $0x10,%esp
8010644d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106455:	c9                   	leave  
80106456:	c3                   	ret    
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106460:	83 ec 0c             	sub    $0xc,%esp
80106463:	68 00 86 11 80       	push   $0x80118600
80106468:	e8 b3 ea ff ff       	call   80104f20 <release>
  return 0;
8010646d:	83 c4 10             	add    $0x10,%esp
80106470:	31 c0                	xor    %eax,%eax
}
80106472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106475:	c9                   	leave  
80106476:	c3                   	ret    
    return -1;
80106477:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647c:	eb f4                	jmp    80106472 <sys_sleep+0xb2>
8010647e:	66 90                	xchg   %ax,%ax

80106480 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	53                   	push   %ebx
80106484:	83 ec 04             	sub    $0x4,%esp
  myproc()->call_nums[13] ++;
80106487:	e8 24 d5 ff ff       	call   801039b0 <myproc>
8010648c:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
  uint xticks;

  acquire(&tickslock);
80106493:	83 ec 0c             	sub    $0xc,%esp
80106496:	68 00 86 11 80       	push   $0x80118600
8010649b:	e8 c0 e9 ff ff       	call   80104e60 <acquire>
  xticks = ticks;
801064a0:	8b 1d 40 8e 11 80    	mov    0x80118e40,%ebx
  release(&tickslock);
801064a6:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
801064ad:	e8 6e ea ff ff       	call   80104f20 <release>
  return xticks;
}
801064b2:	89 d8                	mov    %ebx,%eax
801064b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064b7:	c9                   	leave  
801064b8:	c3                   	ret    
801064b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064c0 <sys_trace_syscalls>:

int sys_trace_syscalls(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	53                   	push   %ebx
801064c4:	83 ec 14             	sub    $0x14,%esp
  int n;
  myproc()->call_nums[21] ++;
801064c7:	e8 e4 d4 ff ff       	call   801039b0 <myproc>
801064cc:	83 80 d0 00 00 00 01 	addl   $0x1,0xd0(%eax)
  if(argint(0, &n) == 0){
801064d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d6:	83 ec 08             	sub    $0x8,%esp
801064d9:	50                   	push   %eax
801064da:	6a 00                	push   $0x0
801064dc:	e8 8f ed ff ff       	call   80105270 <argint>
801064e1:	83 c4 10             	add    $0x10,%esp
801064e4:	85 c0                	test   %eax,%eax
801064e6:	75 50                	jne    80106538 <sys_trace_syscalls+0x78>
801064e8:	89 c3                	mov    %eax,%ebx
    if(myproc()->pid == 2){
801064ea:	e8 c1 d4 ff ff       	call   801039b0 <myproc>
801064ef:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801064f3:	74 2b                	je     80106520 <sys_trace_syscalls+0x60>
      trace_syscalls(2);
      return 0;
    }
    else if (n==1 || n== 0) {
801064f5:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
801064f9:	77 3d                	ja     80106538 <sys_trace_syscalls+0x78>
      myproc()-> print_state = n;
801064fb:	e8 b0 d4 ff ff       	call   801039b0 <myproc>
80106500:	8b 55 f4             	mov    -0xc(%ebp),%edx
      trace_syscalls(n);
80106503:	83 ec 0c             	sub    $0xc,%esp
      myproc()-> print_state = n;
80106506:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
      trace_syscalls(n);
8010650c:	52                   	push   %edx
8010650d:	e8 9e e2 ff ff       	call   801047b0 <trace_syscalls>
      return 0;
80106512:	83 c4 10             	add    $0x10,%esp
    else
      return -1;
  }
  else
    return -1;
}
80106515:	89 d8                	mov    %ebx,%eax
80106517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010651a:	c9                   	leave  
8010651b:	c3                   	ret    
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      trace_syscalls(2);
80106520:	83 ec 0c             	sub    $0xc,%esp
80106523:	6a 02                	push   $0x2
80106525:	e8 86 e2 ff ff       	call   801047b0 <trace_syscalls>
}
8010652a:	89 d8                	mov    %ebx,%eax
      return 0;
8010652c:	83 c4 10             	add    $0x10,%esp
}
8010652f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106532:	c9                   	leave  
80106533:	c3                   	ret    
80106534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106538:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010653d:	eb d6                	jmp    80106515 <sys_trace_syscalls+0x55>
8010653f:	90                   	nop

80106540 <sys_reverse_number>:

int sys_reverse_number(void)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[22] ++;
80106546:	e8 65 d4 ff ff       	call   801039b0 <myproc>
8010654b:	83 80 d4 00 00 00 01 	addl   $0x1,0xd4(%eax)
  int n;
  asm("movl %%edi, %0;" : "=r"(n)); 
  reverse_number(n);
80106552:	83 ec 0c             	sub    $0xc,%esp
  asm("movl %%edi, %0;" : "=r"(n)); 
80106555:	89 f8                	mov    %edi,%eax
  reverse_number(n);
80106557:	50                   	push   %eax
80106558:	e8 13 e3 ff ff       	call   80104870 <reverse_number>

  return 0;
}
8010655d:	31 c0                	xor    %eax,%eax
8010655f:	c9                   	leave  
80106560:	c3                   	ret    
80106561:	eb 0d                	jmp    80106570 <sys_get_children>
80106563:	90                   	nop
80106564:	90                   	nop
80106565:	90                   	nop
80106566:	90                   	nop
80106567:	90                   	nop
80106568:	90                   	nop
80106569:	90                   	nop
8010656a:	90                   	nop
8010656b:	90                   	nop
8010656c:	90                   	nop
8010656d:	90                   	nop
8010656e:	90                   	nop
8010656f:	90                   	nop

80106570 <sys_get_children>:

int
sys_get_children(void){
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[23] ++;
80106576:	e8 35 d4 ff ff       	call   801039b0 <myproc>
8010657b:	83 80 d8 00 00 00 01 	addl   $0x1,0xd8(%eax)
  int pid;
  if(argint(0, &pid) < 0)
80106582:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106585:	83 ec 08             	sub    $0x8,%esp
80106588:	50                   	push   %eax
80106589:	6a 00                	push   $0x0
8010658b:	e8 e0 ec ff ff       	call   80105270 <argint>
80106590:	83 c4 10             	add    $0x10,%esp
80106593:	85 c0                	test   %eax,%eax
80106595:	78 19                	js     801065b0 <sys_get_children+0x40>
    return -1;
  return children(pid);
80106597:	83 ec 0c             	sub    $0xc,%esp
8010659a:	ff 75 f4             	pushl  -0xc(%ebp)
8010659d:	e8 7e e3 ff ff       	call   80104920 <children>
801065a2:	83 c4 10             	add    $0x10,%esp
}
801065a5:	c9                   	leave  
801065a6:	c3                   	ret    
801065a7:	89 f6                	mov    %esi,%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801065b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    
801065b7:	89 f6                	mov    %esi,%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <sys_change_process_queue>:

int sys_change_process_queue(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[24] ++;
801065c6:	e8 e5 d3 ff ff       	call   801039b0 <myproc>
801065cb:	83 80 dc 00 00 00 01 	addl   $0x1,0xdc(%eax)
  int pid, dest_queue;

  if(argint(0, &pid) < 0)
801065d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065d5:	83 ec 08             	sub    $0x8,%esp
801065d8:	50                   	push   %eax
801065d9:	6a 00                	push   $0x0
801065db:	e8 90 ec ff ff       	call   80105270 <argint>
801065e0:	83 c4 10             	add    $0x10,%esp
801065e3:	85 c0                	test   %eax,%eax
801065e5:	78 31                	js     80106618 <sys_change_process_queue+0x58>
    return -1;
  if(argint(1, &dest_queue) < 0)
801065e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ea:	83 ec 08             	sub    $0x8,%esp
801065ed:	50                   	push   %eax
801065ee:	6a 01                	push   $0x1
801065f0:	e8 7b ec ff ff       	call   80105270 <argint>
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	85 c0                	test   %eax,%eax
801065fa:	78 1c                	js     80106618 <sys_change_process_queue+0x58>
    return -1;

  change_process_queue(pid, dest_queue);
801065fc:	83 ec 08             	sub    $0x8,%esp
801065ff:	ff 75 f4             	pushl  -0xc(%ebp)
80106602:	ff 75 f0             	pushl  -0x10(%ebp)
80106605:	e8 06 e4 ff ff       	call   80104a10 <change_process_queue>
  return 0;
8010660a:	83 c4 10             	add    $0x10,%esp
8010660d:	31 c0                	xor    %eax,%eax
}
8010660f:	c9                   	leave  
80106610:	c3                   	ret    
80106611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010661d:	c9                   	leave  
8010661e:	c3                   	ret    
8010661f:	90                   	nop

80106620 <sys_quantify_lottery_tickets>:

int sys_quantify_lottery_tickets(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[25] ++;
80106626:	e8 85 d3 ff ff       	call   801039b0 <myproc>
8010662b:	83 80 e0 00 00 00 01 	addl   $0x1,0xe0(%eax)
  int pid, ticket;

  if(argint(0, &pid) < 0)
80106632:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	50                   	push   %eax
80106639:	6a 00                	push   $0x0
8010663b:	e8 30 ec ff ff       	call   80105270 <argint>
80106640:	83 c4 10             	add    $0x10,%esp
80106643:	85 c0                	test   %eax,%eax
80106645:	78 31                	js     80106678 <sys_quantify_lottery_tickets+0x58>
    return -1;
  if(argint(1, &ticket) < 0)
80106647:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010664a:	83 ec 08             	sub    $0x8,%esp
8010664d:	50                   	push   %eax
8010664e:	6a 01                	push   $0x1
80106650:	e8 1b ec ff ff       	call   80105270 <argint>
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	85 c0                	test   %eax,%eax
8010665a:	78 1c                	js     80106678 <sys_quantify_lottery_tickets+0x58>
    return -1;

  quantify_lottery_tickets(pid, ticket);
8010665c:	83 ec 08             	sub    $0x8,%esp
8010665f:	ff 75 f4             	pushl  -0xc(%ebp)
80106662:	ff 75 f0             	pushl  -0x10(%ebp)
80106665:	e8 d6 e3 ff ff       	call   80104a40 <quantify_lottery_tickets>
  return 0;
8010666a:	83 c4 10             	add    $0x10,%esp
8010666d:	31 c0                	xor    %eax,%eax
}
8010666f:	c9                   	leave  
80106670:	c3                   	ret    
80106671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010667d:	c9                   	leave  
8010667e:	c3                   	ret    
8010667f:	90                   	nop

80106680 <sys_quantify_BJF_parameters_process_level>:

int sys_quantify_BJF_parameters_process_level(void)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[26] ++;
80106686:	e8 25 d3 ff ff       	call   801039b0 <myproc>
8010668b:	83 80 e4 00 00 00 01 	addl   $0x1,0xe4(%eax)
  int pid, priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &pid) < 0)
80106692:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106695:	83 ec 08             	sub    $0x8,%esp
80106698:	50                   	push   %eax
80106699:	6a 00                	push   $0x0
8010669b:	e8 d0 eb ff ff       	call   80105270 <argint>
801066a0:	83 c4 10             	add    $0x10,%esp
801066a3:	85 c0                	test   %eax,%eax
801066a5:	78 59                	js     80106700 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(0, &priority_ratio) < 0)
801066a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066aa:	83 ec 08             	sub    $0x8,%esp
801066ad:	50                   	push   %eax
801066ae:	6a 00                	push   $0x0
801066b0:	e8 bb eb ff ff       	call   80105270 <argint>
801066b5:	83 c4 10             	add    $0x10,%esp
801066b8:	85 c0                	test   %eax,%eax
801066ba:	78 44                	js     80106700 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
801066bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066bf:	83 ec 08             	sub    $0x8,%esp
801066c2:	50                   	push   %eax
801066c3:	6a 01                	push   $0x1
801066c5:	e8 a6 eb ff ff       	call   80105270 <argint>
801066ca:	83 c4 10             	add    $0x10,%esp
801066cd:	85 c0                	test   %eax,%eax
801066cf:	78 2f                	js     80106700 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;
  if(argint(1, &exect_ratio) < 0)
801066d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d4:	83 ec 08             	sub    $0x8,%esp
801066d7:	50                   	push   %eax
801066d8:	6a 01                	push   $0x1
801066da:	e8 91 eb ff ff       	call   80105270 <argint>
801066df:	83 c4 10             	add    $0x10,%esp
801066e2:	85 c0                	test   %eax,%eax
801066e4:	78 1a                	js     80106700 <sys_quantify_BJF_parameters_process_level+0x80>
    return -1;

  quantify_BJF_parameters_process_level(pid, priority_ratio, arrivt_ratio, exect_ratio);
801066e6:	ff 75 f4             	pushl  -0xc(%ebp)
801066e9:	ff 75 f0             	pushl  -0x10(%ebp)
801066ec:	ff 75 ec             	pushl  -0x14(%ebp)
801066ef:	ff 75 e8             	pushl  -0x18(%ebp)
801066f2:	e8 79 e3 ff ff       	call   80104a70 <quantify_BJF_parameters_process_level>
  return 0;
801066f7:	83 c4 10             	add    $0x10,%esp
801066fa:	31 c0                	xor    %eax,%eax
}
801066fc:	c9                   	leave  
801066fd:	c3                   	ret    
801066fe:	66 90                	xchg   %ax,%ax
    return -1;
80106700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106705:	c9                   	leave  
80106706:	c3                   	ret    
80106707:	89 f6                	mov    %esi,%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <sys_quantify_BJF_parameters_kernel_level>:

int sys_quantify_BJF_parameters_kernel_level(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 18             	sub    $0x18,%esp
  myproc()->call_nums[27] ++;
80106716:	e8 95 d2 ff ff       	call   801039b0 <myproc>
8010671b:	83 80 e8 00 00 00 01 	addl   $0x1,0xe8(%eax)
  int priority_ratio, arrivt_ratio, exect_ratio;

  if(argint(0, &priority_ratio) < 0)
80106722:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106725:	83 ec 08             	sub    $0x8,%esp
80106728:	50                   	push   %eax
80106729:	6a 00                	push   $0x0
8010672b:	e8 40 eb ff ff       	call   80105270 <argint>
80106730:	83 c4 10             	add    $0x10,%esp
80106733:	85 c0                	test   %eax,%eax
80106735:	78 49                	js     80106780 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &arrivt_ratio) < 0)
80106737:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010673a:	83 ec 08             	sub    $0x8,%esp
8010673d:	50                   	push   %eax
8010673e:	6a 01                	push   $0x1
80106740:	e8 2b eb ff ff       	call   80105270 <argint>
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	85 c0                	test   %eax,%eax
8010674a:	78 34                	js     80106780 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;
  if(argint(1, &exect_ratio) < 0)
8010674c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010674f:	83 ec 08             	sub    $0x8,%esp
80106752:	50                   	push   %eax
80106753:	6a 01                	push   $0x1
80106755:	e8 16 eb ff ff       	call   80105270 <argint>
8010675a:	83 c4 10             	add    $0x10,%esp
8010675d:	85 c0                	test   %eax,%eax
8010675f:	78 1f                	js     80106780 <sys_quantify_BJF_parameters_kernel_level+0x70>
    return -1;

  quantify_BJF_parameters_kernel_level(priority_ratio, arrivt_ratio, exect_ratio);
80106761:	83 ec 04             	sub    $0x4,%esp
80106764:	ff 75 f4             	pushl  -0xc(%ebp)
80106767:	ff 75 f0             	pushl  -0x10(%ebp)
8010676a:	ff 75 ec             	pushl  -0x14(%ebp)
8010676d:	e8 3e e3 ff ff       	call   80104ab0 <quantify_BJF_parameters_kernel_level>
  return 0;
80106772:	83 c4 10             	add    $0x10,%esp
80106775:	31 c0                	xor    %eax,%eax
}
80106777:	c9                   	leave  
80106778:	c3                   	ret    
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106785:	c9                   	leave  
80106786:	c3                   	ret    
80106787:	89 f6                	mov    %esi,%esi
80106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106790 <sys_print_information>:

int sys_print_information(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 08             	sub    $0x8,%esp
  myproc()->call_nums[28] ++;
80106796:	e8 15 d2 ff ff       	call   801039b0 <myproc>
8010679b:	83 80 ec 00 00 00 01 	addl   $0x1,0xec(%eax)
  print_information();
801067a2:	e8 69 e3 ff ff       	call   80104b10 <print_information>
  return 0;
801067a7:	31 c0                	xor    %eax,%eax
801067a9:	c9                   	leave  
801067aa:	c3                   	ret    

801067ab <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067ab:	1e                   	push   %ds
  pushl %es
801067ac:	06                   	push   %es
  pushl %fs
801067ad:	0f a0                	push   %fs
  pushl %gs
801067af:	0f a8                	push   %gs
  pushal
801067b1:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067b2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067b6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067b8:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067ba:	54                   	push   %esp
  call trap
801067bb:	e8 c0 00 00 00       	call   80106880 <trap>
  addl $4, %esp
801067c0:	83 c4 04             	add    $0x4,%esp

801067c3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067c3:	61                   	popa   
  popl %gs
801067c4:	0f a9                	pop    %gs
  popl %fs
801067c6:	0f a1                	pop    %fs
  popl %es
801067c8:	07                   	pop    %es
  popl %ds
801067c9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067ca:	83 c4 08             	add    $0x8,%esp
  iret
801067cd:	cf                   	iret   
801067ce:	66 90                	xchg   %ax,%ax

801067d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801067d0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801067d1:	31 c0                	xor    %eax,%eax
{
801067d3:	89 e5                	mov    %esp,%ebp
801067d5:	83 ec 08             	sub    $0x8,%esp
801067d8:	90                   	nop
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801067e0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801067e7:	c7 04 c5 42 86 11 80 	movl   $0x8e000008,-0x7fee79be(,%eax,8)
801067ee:	08 00 00 8e 
801067f2:	66 89 14 c5 40 86 11 	mov    %dx,-0x7fee79c0(,%eax,8)
801067f9:	80 
801067fa:	c1 ea 10             	shr    $0x10,%edx
801067fd:	66 89 14 c5 46 86 11 	mov    %dx,-0x7fee79ba(,%eax,8)
80106804:	80 
  for(i = 0; i < 256; i++)
80106805:	83 c0 01             	add    $0x1,%eax
80106808:	3d 00 01 00 00       	cmp    $0x100,%eax
8010680d:	75 d1                	jne    801067e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010680f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106814:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106817:	c7 05 42 88 11 80 08 	movl   $0xef000008,0x80118842
8010681e:	00 00 ef 
  initlock(&tickslock, "time");
80106821:	68 94 86 10 80       	push   $0x80108694
80106826:	68 00 86 11 80       	push   $0x80118600
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010682b:	66 a3 40 88 11 80    	mov    %ax,0x80118840
80106831:	c1 e8 10             	shr    $0x10,%eax
80106834:	66 a3 46 88 11 80    	mov    %ax,0x80118846
  initlock(&tickslock, "time");
8010683a:	e8 e1 e4 ff ff       	call   80104d20 <initlock>
}
8010683f:	83 c4 10             	add    $0x10,%esp
80106842:	c9                   	leave  
80106843:	c3                   	ret    
80106844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010684a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106850 <idtinit>:

void
idtinit(void)
{
80106850:	55                   	push   %ebp
  pd[0] = size-1;
80106851:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106856:	89 e5                	mov    %esp,%ebp
80106858:	83 ec 10             	sub    $0x10,%esp
8010685b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010685f:	b8 40 86 11 80       	mov    $0x80118640,%eax
80106864:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106868:	c1 e8 10             	shr    $0x10,%eax
8010686b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010686f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106872:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106875:	c9                   	leave  
80106876:	c3                   	ret    
80106877:	89 f6                	mov    %esi,%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106880 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 1c             	sub    $0x1c,%esp
80106889:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010688c:	8b 47 30             	mov    0x30(%edi),%eax
8010688f:	83 f8 40             	cmp    $0x40,%eax
80106892:	0f 84 f0 00 00 00    	je     80106988 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106898:	83 e8 20             	sub    $0x20,%eax
8010689b:	83 f8 1f             	cmp    $0x1f,%eax
8010689e:	77 10                	ja     801068b0 <trap+0x30>
801068a0:	ff 24 85 fc 8a 10 80 	jmp    *-0x7fef7504(,%eax,4)
801068a7:	89 f6                	mov    %esi,%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801068b0:	e8 fb d0 ff ff       	call   801039b0 <myproc>
801068b5:	85 c0                	test   %eax,%eax
801068b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801068ba:	0f 84 24 02 00 00    	je     80106ae4 <trap+0x264>
801068c0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801068c4:	0f 84 1a 02 00 00    	je     80106ae4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068ca:	0f 20 d1             	mov    %cr2,%ecx
801068cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d0:	e8 bb d0 ff ff       	call   80103990 <cpuid>
801068d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068d8:	8b 47 34             	mov    0x34(%edi),%eax
801068db:	8b 77 30             	mov    0x30(%edi),%esi
801068de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068e1:	e8 ca d0 ff ff       	call   801039b0 <myproc>
801068e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068e9:	e8 c2 d0 ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801068f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801068f4:	51                   	push   %ecx
801068f5:	53                   	push   %ebx
801068f6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801068f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068fa:	ff 75 e4             	pushl  -0x1c(%ebp)
801068fd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801068fe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106901:	52                   	push   %edx
80106902:	ff 70 10             	pushl  0x10(%eax)
80106905:	68 b8 8a 10 80       	push   $0x80108ab8
8010690a:	e8 51 9d ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010690f:	83 c4 20             	add    $0x20,%esp
80106912:	e8 99 d0 ff ff       	call   801039b0 <myproc>
80106917:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010691e:	e8 8d d0 ff ff       	call   801039b0 <myproc>
80106923:	85 c0                	test   %eax,%eax
80106925:	74 1d                	je     80106944 <trap+0xc4>
80106927:	e8 84 d0 ff ff       	call   801039b0 <myproc>
8010692c:	8b 50 24             	mov    0x24(%eax),%edx
8010692f:	85 d2                	test   %edx,%edx
80106931:	74 11                	je     80106944 <trap+0xc4>
80106933:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106937:	83 e0 03             	and    $0x3,%eax
8010693a:	66 83 f8 03          	cmp    $0x3,%ax
8010693e:	0f 84 5c 01 00 00    	je     80106aa0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106944:	e8 67 d0 ff ff       	call   801039b0 <myproc>
80106949:	85 c0                	test   %eax,%eax
8010694b:	74 0b                	je     80106958 <trap+0xd8>
8010694d:	e8 5e d0 ff ff       	call   801039b0 <myproc>
80106952:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106956:	74 68                	je     801069c0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER && myproc()->level == 1)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106958:	e8 53 d0 ff ff       	call   801039b0 <myproc>
8010695d:	85 c0                	test   %eax,%eax
8010695f:	74 19                	je     8010697a <trap+0xfa>
80106961:	e8 4a d0 ff ff       	call   801039b0 <myproc>
80106966:	8b 40 24             	mov    0x24(%eax),%eax
80106969:	85 c0                	test   %eax,%eax
8010696b:	74 0d                	je     8010697a <trap+0xfa>
8010696d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106971:	83 e0 03             	and    $0x3,%eax
80106974:	66 83 f8 03          	cmp    $0x3,%ax
80106978:	74 37                	je     801069b1 <trap+0x131>
    exit();
}
8010697a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010697d:	5b                   	pop    %ebx
8010697e:	5e                   	pop    %esi
8010697f:	5f                   	pop    %edi
80106980:	5d                   	pop    %ebp
80106981:	c3                   	ret    
80106982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106988:	e8 23 d0 ff ff       	call   801039b0 <myproc>
8010698d:	8b 58 24             	mov    0x24(%eax),%ebx
80106990:	85 db                	test   %ebx,%ebx
80106992:	0f 85 f8 00 00 00    	jne    80106a90 <trap+0x210>
    myproc()->tf = tf;
80106998:	e8 13 d0 ff ff       	call   801039b0 <myproc>
8010699d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801069a0:	e8 bb e9 ff ff       	call   80105360 <syscall>
    if(myproc()->killed)
801069a5:	e8 06 d0 ff ff       	call   801039b0 <myproc>
801069aa:	8b 48 24             	mov    0x24(%eax),%ecx
801069ad:	85 c9                	test   %ecx,%ecx
801069af:	74 c9                	je     8010697a <trap+0xfa>
}
801069b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b4:	5b                   	pop    %ebx
801069b5:	5e                   	pop    %esi
801069b6:	5f                   	pop    %edi
801069b7:	5d                   	pop    %ebp
      exit();
801069b8:	e9 b3 d6 ff ff       	jmp    80104070 <exit>
801069bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801069c0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801069c4:	75 92                	jne    80106958 <trap+0xd8>
     tf->trapno == T_IRQ0+IRQ_TIMER && myproc()->level == 1)
801069c6:	e8 e5 cf ff ff       	call   801039b0 <myproc>
801069cb:	83 b8 f4 00 00 00 01 	cmpl   $0x1,0xf4(%eax)
801069d2:	75 84                	jne    80106958 <trap+0xd8>
    yield();
801069d4:	e8 c7 d7 ff ff       	call   801041a0 <yield>
801069d9:	e9 7a ff ff ff       	jmp    80106958 <trap+0xd8>
801069de:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
801069e0:	e8 ab cf ff ff       	call   80103990 <cpuid>
801069e5:	85 c0                	test   %eax,%eax
801069e7:	0f 84 c3 00 00 00    	je     80106ab0 <trap+0x230>
    lapiceoi();
801069ed:	e8 2e bf ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069f2:	e8 b9 cf ff ff       	call   801039b0 <myproc>
801069f7:	85 c0                	test   %eax,%eax
801069f9:	0f 85 28 ff ff ff    	jne    80106927 <trap+0xa7>
801069ff:	e9 40 ff ff ff       	jmp    80106944 <trap+0xc4>
80106a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106a08:	e8 d3 bd ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80106a0d:	e8 0e bf ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a12:	e8 99 cf ff ff       	call   801039b0 <myproc>
80106a17:	85 c0                	test   %eax,%eax
80106a19:	0f 85 08 ff ff ff    	jne    80106927 <trap+0xa7>
80106a1f:	e9 20 ff ff ff       	jmp    80106944 <trap+0xc4>
80106a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106a28:	e8 53 02 00 00       	call   80106c80 <uartintr>
    lapiceoi();
80106a2d:	e8 ee be ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a32:	e8 79 cf ff ff       	call   801039b0 <myproc>
80106a37:	85 c0                	test   %eax,%eax
80106a39:	0f 85 e8 fe ff ff    	jne    80106927 <trap+0xa7>
80106a3f:	e9 00 ff ff ff       	jmp    80106944 <trap+0xc4>
80106a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a48:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106a4c:	8b 77 38             	mov    0x38(%edi),%esi
80106a4f:	e8 3c cf ff ff       	call   80103990 <cpuid>
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	50                   	push   %eax
80106a57:	68 60 8a 10 80       	push   $0x80108a60
80106a5c:	e8 ff 9b ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106a61:	e8 ba be ff ff       	call   80102920 <lapiceoi>
    break;
80106a66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a69:	e8 42 cf ff ff       	call   801039b0 <myproc>
80106a6e:	85 c0                	test   %eax,%eax
80106a70:	0f 85 b1 fe ff ff    	jne    80106927 <trap+0xa7>
80106a76:	e9 c9 fe ff ff       	jmp    80106944 <trap+0xc4>
80106a7b:	90                   	nop
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106a80:	e8 cb b7 ff ff       	call   80102250 <ideintr>
80106a85:	e9 63 ff ff ff       	jmp    801069ed <trap+0x16d>
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106a90:	e8 db d5 ff ff       	call   80104070 <exit>
80106a95:	e9 fe fe ff ff       	jmp    80106998 <trap+0x118>
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106aa0:	e8 cb d5 ff ff       	call   80104070 <exit>
80106aa5:	e9 9a fe ff ff       	jmp    80106944 <trap+0xc4>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106ab0:	83 ec 0c             	sub    $0xc,%esp
80106ab3:	68 00 86 11 80       	push   $0x80118600
80106ab8:	e8 a3 e3 ff ff       	call   80104e60 <acquire>
      wakeup(&ticks);
80106abd:	c7 04 24 40 8e 11 80 	movl   $0x80118e40,(%esp)
      ticks++;
80106ac4:	83 05 40 8e 11 80 01 	addl   $0x1,0x80118e40
      wakeup(&ticks);
80106acb:	e8 e0 d8 ff ff       	call   801043b0 <wakeup>
      release(&tickslock);
80106ad0:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
80106ad7:	e8 44 e4 ff ff       	call   80104f20 <release>
80106adc:	83 c4 10             	add    $0x10,%esp
80106adf:	e9 09 ff ff ff       	jmp    801069ed <trap+0x16d>
80106ae4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ae7:	e8 a4 ce ff ff       	call   80103990 <cpuid>
80106aec:	83 ec 0c             	sub    $0xc,%esp
80106aef:	56                   	push   %esi
80106af0:	53                   	push   %ebx
80106af1:	50                   	push   %eax
80106af2:	ff 77 30             	pushl  0x30(%edi)
80106af5:	68 84 8a 10 80       	push   $0x80108a84
80106afa:	e8 61 9b ff ff       	call   80100660 <cprintf>
      panic("trap");
80106aff:	83 c4 14             	add    $0x14,%esp
80106b02:	68 59 8a 10 80       	push   $0x80108a59
80106b07:	e8 84 98 ff ff       	call   80100390 <panic>
80106b0c:	66 90                	xchg   %ax,%ax
80106b0e:	66 90                	xchg   %ax,%ax

80106b10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106b10:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106b15:	55                   	push   %ebp
80106b16:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b18:	85 c0                	test   %eax,%eax
80106b1a:	74 1c                	je     80106b38 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b1c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b21:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b22:	a8 01                	test   $0x1,%al
80106b24:	74 12                	je     80106b38 <uartgetc+0x28>
80106b26:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b2b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b2c:	0f b6 c0             	movzbl %al,%eax
}
80106b2f:	5d                   	pop    %ebp
80106b30:	c3                   	ret    
80106b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b3d:	5d                   	pop    %ebp
80106b3e:	c3                   	ret    
80106b3f:	90                   	nop

80106b40 <uartputc.part.0>:
uartputc(int c)
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	89 c7                	mov    %eax,%edi
80106b48:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b52:	83 ec 0c             	sub    $0xc,%esp
80106b55:	eb 1b                	jmp    80106b72 <uartputc.part.0+0x32>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106b60:	83 ec 0c             	sub    $0xc,%esp
80106b63:	6a 0a                	push   $0xa
80106b65:	e8 d6 bd ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b6a:	83 c4 10             	add    $0x10,%esp
80106b6d:	83 eb 01             	sub    $0x1,%ebx
80106b70:	74 07                	je     80106b79 <uartputc.part.0+0x39>
80106b72:	89 f2                	mov    %esi,%edx
80106b74:	ec                   	in     (%dx),%al
80106b75:	a8 20                	test   $0x20,%al
80106b77:	74 e7                	je     80106b60 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b79:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b7e:	89 f8                	mov    %edi,%eax
80106b80:	ee                   	out    %al,(%dx)
}
80106b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b84:	5b                   	pop    %ebx
80106b85:	5e                   	pop    %esi
80106b86:	5f                   	pop    %edi
80106b87:	5d                   	pop    %ebp
80106b88:	c3                   	ret    
80106b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b90 <uartinit>:
{
80106b90:	55                   	push   %ebp
80106b91:	31 c9                	xor    %ecx,%ecx
80106b93:	89 c8                	mov    %ecx,%eax
80106b95:	89 e5                	mov    %esp,%ebp
80106b97:	57                   	push   %edi
80106b98:	56                   	push   %esi
80106b99:	53                   	push   %ebx
80106b9a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b9f:	89 da                	mov    %ebx,%edx
80106ba1:	83 ec 0c             	sub    $0xc,%esp
80106ba4:	ee                   	out    %al,(%dx)
80106ba5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106baa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106baf:	89 fa                	mov    %edi,%edx
80106bb1:	ee                   	out    %al,(%dx)
80106bb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106bb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bbc:	ee                   	out    %al,(%dx)
80106bbd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106bc2:	89 c8                	mov    %ecx,%eax
80106bc4:	89 f2                	mov    %esi,%edx
80106bc6:	ee                   	out    %al,(%dx)
80106bc7:	b8 03 00 00 00       	mov    $0x3,%eax
80106bcc:	89 fa                	mov    %edi,%edx
80106bce:	ee                   	out    %al,(%dx)
80106bcf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106bd4:	89 c8                	mov    %ecx,%eax
80106bd6:	ee                   	out    %al,(%dx)
80106bd7:	b8 01 00 00 00       	mov    $0x1,%eax
80106bdc:	89 f2                	mov    %esi,%edx
80106bde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bdf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106be4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106be5:	3c ff                	cmp    $0xff,%al
80106be7:	74 5a                	je     80106c43 <uartinit+0xb3>
  uart = 1;
80106be9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106bf0:	00 00 00 
80106bf3:	89 da                	mov    %ebx,%edx
80106bf5:	ec                   	in     (%dx),%al
80106bf6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bfb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106bfc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106bff:	bb 7c 8b 10 80       	mov    $0x80108b7c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106c04:	6a 00                	push   $0x0
80106c06:	6a 04                	push   $0x4
80106c08:	e8 93 b8 ff ff       	call   801024a0 <ioapicenable>
80106c0d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c10:	b8 78 00 00 00       	mov    $0x78,%eax
80106c15:	eb 13                	jmp    80106c2a <uartinit+0x9a>
80106c17:	89 f6                	mov    %esi,%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c20:	83 c3 01             	add    $0x1,%ebx
80106c23:	0f be 03             	movsbl (%ebx),%eax
80106c26:	84 c0                	test   %al,%al
80106c28:	74 19                	je     80106c43 <uartinit+0xb3>
  if(!uart)
80106c2a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106c30:	85 d2                	test   %edx,%edx
80106c32:	74 ec                	je     80106c20 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106c34:	83 c3 01             	add    $0x1,%ebx
80106c37:	e8 04 ff ff ff       	call   80106b40 <uartputc.part.0>
80106c3c:	0f be 03             	movsbl (%ebx),%eax
80106c3f:	84 c0                	test   %al,%al
80106c41:	75 e7                	jne    80106c2a <uartinit+0x9a>
}
80106c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c46:	5b                   	pop    %ebx
80106c47:	5e                   	pop    %esi
80106c48:	5f                   	pop    %edi
80106c49:	5d                   	pop    %ebp
80106c4a:	c3                   	ret    
80106c4b:	90                   	nop
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c50 <uartputc>:
  if(!uart)
80106c50:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106c56:	55                   	push   %ebp
80106c57:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c59:	85 d2                	test   %edx,%edx
{
80106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c5e:	74 10                	je     80106c70 <uartputc+0x20>
}
80106c60:	5d                   	pop    %ebp
80106c61:	e9 da fe ff ff       	jmp    80106b40 <uartputc.part.0>
80106c66:	8d 76 00             	lea    0x0(%esi),%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c70:	5d                   	pop    %ebp
80106c71:	c3                   	ret    
80106c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <uartintr>:

void
uartintr(void)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c86:	68 10 6b 10 80       	push   $0x80106b10
80106c8b:	e8 80 9b ff ff       	call   80100810 <consoleintr>
}
80106c90:	83 c4 10             	add    $0x10,%esp
80106c93:	c9                   	leave  
80106c94:	c3                   	ret    

80106c95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $0
80106c97:	6a 00                	push   $0x0
  jmp alltraps
80106c99:	e9 0d fb ff ff       	jmp    801067ab <alltraps>

80106c9e <vector1>:
.globl vector1
vector1:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $1
80106ca0:	6a 01                	push   $0x1
  jmp alltraps
80106ca2:	e9 04 fb ff ff       	jmp    801067ab <alltraps>

80106ca7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $2
80106ca9:	6a 02                	push   $0x2
  jmp alltraps
80106cab:	e9 fb fa ff ff       	jmp    801067ab <alltraps>

80106cb0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $3
80106cb2:	6a 03                	push   $0x3
  jmp alltraps
80106cb4:	e9 f2 fa ff ff       	jmp    801067ab <alltraps>

80106cb9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $4
80106cbb:	6a 04                	push   $0x4
  jmp alltraps
80106cbd:	e9 e9 fa ff ff       	jmp    801067ab <alltraps>

80106cc2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $5
80106cc4:	6a 05                	push   $0x5
  jmp alltraps
80106cc6:	e9 e0 fa ff ff       	jmp    801067ab <alltraps>

80106ccb <vector6>:
.globl vector6
vector6:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $6
80106ccd:	6a 06                	push   $0x6
  jmp alltraps
80106ccf:	e9 d7 fa ff ff       	jmp    801067ab <alltraps>

80106cd4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $7
80106cd6:	6a 07                	push   $0x7
  jmp alltraps
80106cd8:	e9 ce fa ff ff       	jmp    801067ab <alltraps>

80106cdd <vector8>:
.globl vector8
vector8:
  pushl $8
80106cdd:	6a 08                	push   $0x8
  jmp alltraps
80106cdf:	e9 c7 fa ff ff       	jmp    801067ab <alltraps>

80106ce4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $9
80106ce6:	6a 09                	push   $0x9
  jmp alltraps
80106ce8:	e9 be fa ff ff       	jmp    801067ab <alltraps>

80106ced <vector10>:
.globl vector10
vector10:
  pushl $10
80106ced:	6a 0a                	push   $0xa
  jmp alltraps
80106cef:	e9 b7 fa ff ff       	jmp    801067ab <alltraps>

80106cf4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cf4:	6a 0b                	push   $0xb
  jmp alltraps
80106cf6:	e9 b0 fa ff ff       	jmp    801067ab <alltraps>

80106cfb <vector12>:
.globl vector12
vector12:
  pushl $12
80106cfb:	6a 0c                	push   $0xc
  jmp alltraps
80106cfd:	e9 a9 fa ff ff       	jmp    801067ab <alltraps>

80106d02 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d02:	6a 0d                	push   $0xd
  jmp alltraps
80106d04:	e9 a2 fa ff ff       	jmp    801067ab <alltraps>

80106d09 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d09:	6a 0e                	push   $0xe
  jmp alltraps
80106d0b:	e9 9b fa ff ff       	jmp    801067ab <alltraps>

80106d10 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $15
80106d12:	6a 0f                	push   $0xf
  jmp alltraps
80106d14:	e9 92 fa ff ff       	jmp    801067ab <alltraps>

80106d19 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $16
80106d1b:	6a 10                	push   $0x10
  jmp alltraps
80106d1d:	e9 89 fa ff ff       	jmp    801067ab <alltraps>

80106d22 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d22:	6a 11                	push   $0x11
  jmp alltraps
80106d24:	e9 82 fa ff ff       	jmp    801067ab <alltraps>

80106d29 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d29:	6a 00                	push   $0x0
  pushl $18
80106d2b:	6a 12                	push   $0x12
  jmp alltraps
80106d2d:	e9 79 fa ff ff       	jmp    801067ab <alltraps>

80106d32 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $19
80106d34:	6a 13                	push   $0x13
  jmp alltraps
80106d36:	e9 70 fa ff ff       	jmp    801067ab <alltraps>

80106d3b <vector20>:
.globl vector20
vector20:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $20
80106d3d:	6a 14                	push   $0x14
  jmp alltraps
80106d3f:	e9 67 fa ff ff       	jmp    801067ab <alltraps>

80106d44 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d44:	6a 00                	push   $0x0
  pushl $21
80106d46:	6a 15                	push   $0x15
  jmp alltraps
80106d48:	e9 5e fa ff ff       	jmp    801067ab <alltraps>

80106d4d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d4d:	6a 00                	push   $0x0
  pushl $22
80106d4f:	6a 16                	push   $0x16
  jmp alltraps
80106d51:	e9 55 fa ff ff       	jmp    801067ab <alltraps>

80106d56 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $23
80106d58:	6a 17                	push   $0x17
  jmp alltraps
80106d5a:	e9 4c fa ff ff       	jmp    801067ab <alltraps>

80106d5f <vector24>:
.globl vector24
vector24:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $24
80106d61:	6a 18                	push   $0x18
  jmp alltraps
80106d63:	e9 43 fa ff ff       	jmp    801067ab <alltraps>

80106d68 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d68:	6a 00                	push   $0x0
  pushl $25
80106d6a:	6a 19                	push   $0x19
  jmp alltraps
80106d6c:	e9 3a fa ff ff       	jmp    801067ab <alltraps>

80106d71 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d71:	6a 00                	push   $0x0
  pushl $26
80106d73:	6a 1a                	push   $0x1a
  jmp alltraps
80106d75:	e9 31 fa ff ff       	jmp    801067ab <alltraps>

80106d7a <vector27>:
.globl vector27
vector27:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $27
80106d7c:	6a 1b                	push   $0x1b
  jmp alltraps
80106d7e:	e9 28 fa ff ff       	jmp    801067ab <alltraps>

80106d83 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $28
80106d85:	6a 1c                	push   $0x1c
  jmp alltraps
80106d87:	e9 1f fa ff ff       	jmp    801067ab <alltraps>

80106d8c <vector29>:
.globl vector29
vector29:
  pushl $0
80106d8c:	6a 00                	push   $0x0
  pushl $29
80106d8e:	6a 1d                	push   $0x1d
  jmp alltraps
80106d90:	e9 16 fa ff ff       	jmp    801067ab <alltraps>

80106d95 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d95:	6a 00                	push   $0x0
  pushl $30
80106d97:	6a 1e                	push   $0x1e
  jmp alltraps
80106d99:	e9 0d fa ff ff       	jmp    801067ab <alltraps>

80106d9e <vector31>:
.globl vector31
vector31:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $31
80106da0:	6a 1f                	push   $0x1f
  jmp alltraps
80106da2:	e9 04 fa ff ff       	jmp    801067ab <alltraps>

80106da7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $32
80106da9:	6a 20                	push   $0x20
  jmp alltraps
80106dab:	e9 fb f9 ff ff       	jmp    801067ab <alltraps>

80106db0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $33
80106db2:	6a 21                	push   $0x21
  jmp alltraps
80106db4:	e9 f2 f9 ff ff       	jmp    801067ab <alltraps>

80106db9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $34
80106dbb:	6a 22                	push   $0x22
  jmp alltraps
80106dbd:	e9 e9 f9 ff ff       	jmp    801067ab <alltraps>

80106dc2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $35
80106dc4:	6a 23                	push   $0x23
  jmp alltraps
80106dc6:	e9 e0 f9 ff ff       	jmp    801067ab <alltraps>

80106dcb <vector36>:
.globl vector36
vector36:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $36
80106dcd:	6a 24                	push   $0x24
  jmp alltraps
80106dcf:	e9 d7 f9 ff ff       	jmp    801067ab <alltraps>

80106dd4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $37
80106dd6:	6a 25                	push   $0x25
  jmp alltraps
80106dd8:	e9 ce f9 ff ff       	jmp    801067ab <alltraps>

80106ddd <vector38>:
.globl vector38
vector38:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $38
80106ddf:	6a 26                	push   $0x26
  jmp alltraps
80106de1:	e9 c5 f9 ff ff       	jmp    801067ab <alltraps>

80106de6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $39
80106de8:	6a 27                	push   $0x27
  jmp alltraps
80106dea:	e9 bc f9 ff ff       	jmp    801067ab <alltraps>

80106def <vector40>:
.globl vector40
vector40:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $40
80106df1:	6a 28                	push   $0x28
  jmp alltraps
80106df3:	e9 b3 f9 ff ff       	jmp    801067ab <alltraps>

80106df8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $41
80106dfa:	6a 29                	push   $0x29
  jmp alltraps
80106dfc:	e9 aa f9 ff ff       	jmp    801067ab <alltraps>

80106e01 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $42
80106e03:	6a 2a                	push   $0x2a
  jmp alltraps
80106e05:	e9 a1 f9 ff ff       	jmp    801067ab <alltraps>

80106e0a <vector43>:
.globl vector43
vector43:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $43
80106e0c:	6a 2b                	push   $0x2b
  jmp alltraps
80106e0e:	e9 98 f9 ff ff       	jmp    801067ab <alltraps>

80106e13 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $44
80106e15:	6a 2c                	push   $0x2c
  jmp alltraps
80106e17:	e9 8f f9 ff ff       	jmp    801067ab <alltraps>

80106e1c <vector45>:
.globl vector45
vector45:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $45
80106e1e:	6a 2d                	push   $0x2d
  jmp alltraps
80106e20:	e9 86 f9 ff ff       	jmp    801067ab <alltraps>

80106e25 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $46
80106e27:	6a 2e                	push   $0x2e
  jmp alltraps
80106e29:	e9 7d f9 ff ff       	jmp    801067ab <alltraps>

80106e2e <vector47>:
.globl vector47
vector47:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $47
80106e30:	6a 2f                	push   $0x2f
  jmp alltraps
80106e32:	e9 74 f9 ff ff       	jmp    801067ab <alltraps>

80106e37 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $48
80106e39:	6a 30                	push   $0x30
  jmp alltraps
80106e3b:	e9 6b f9 ff ff       	jmp    801067ab <alltraps>

80106e40 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $49
80106e42:	6a 31                	push   $0x31
  jmp alltraps
80106e44:	e9 62 f9 ff ff       	jmp    801067ab <alltraps>

80106e49 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $50
80106e4b:	6a 32                	push   $0x32
  jmp alltraps
80106e4d:	e9 59 f9 ff ff       	jmp    801067ab <alltraps>

80106e52 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $51
80106e54:	6a 33                	push   $0x33
  jmp alltraps
80106e56:	e9 50 f9 ff ff       	jmp    801067ab <alltraps>

80106e5b <vector52>:
.globl vector52
vector52:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $52
80106e5d:	6a 34                	push   $0x34
  jmp alltraps
80106e5f:	e9 47 f9 ff ff       	jmp    801067ab <alltraps>

80106e64 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $53
80106e66:	6a 35                	push   $0x35
  jmp alltraps
80106e68:	e9 3e f9 ff ff       	jmp    801067ab <alltraps>

80106e6d <vector54>:
.globl vector54
vector54:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $54
80106e6f:	6a 36                	push   $0x36
  jmp alltraps
80106e71:	e9 35 f9 ff ff       	jmp    801067ab <alltraps>

80106e76 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $55
80106e78:	6a 37                	push   $0x37
  jmp alltraps
80106e7a:	e9 2c f9 ff ff       	jmp    801067ab <alltraps>

80106e7f <vector56>:
.globl vector56
vector56:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $56
80106e81:	6a 38                	push   $0x38
  jmp alltraps
80106e83:	e9 23 f9 ff ff       	jmp    801067ab <alltraps>

80106e88 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $57
80106e8a:	6a 39                	push   $0x39
  jmp alltraps
80106e8c:	e9 1a f9 ff ff       	jmp    801067ab <alltraps>

80106e91 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $58
80106e93:	6a 3a                	push   $0x3a
  jmp alltraps
80106e95:	e9 11 f9 ff ff       	jmp    801067ab <alltraps>

80106e9a <vector59>:
.globl vector59
vector59:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $59
80106e9c:	6a 3b                	push   $0x3b
  jmp alltraps
80106e9e:	e9 08 f9 ff ff       	jmp    801067ab <alltraps>

80106ea3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $60
80106ea5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ea7:	e9 ff f8 ff ff       	jmp    801067ab <alltraps>

80106eac <vector61>:
.globl vector61
vector61:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $61
80106eae:	6a 3d                	push   $0x3d
  jmp alltraps
80106eb0:	e9 f6 f8 ff ff       	jmp    801067ab <alltraps>

80106eb5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $62
80106eb7:	6a 3e                	push   $0x3e
  jmp alltraps
80106eb9:	e9 ed f8 ff ff       	jmp    801067ab <alltraps>

80106ebe <vector63>:
.globl vector63
vector63:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $63
80106ec0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ec2:	e9 e4 f8 ff ff       	jmp    801067ab <alltraps>

80106ec7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $64
80106ec9:	6a 40                	push   $0x40
  jmp alltraps
80106ecb:	e9 db f8 ff ff       	jmp    801067ab <alltraps>

80106ed0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $65
80106ed2:	6a 41                	push   $0x41
  jmp alltraps
80106ed4:	e9 d2 f8 ff ff       	jmp    801067ab <alltraps>

80106ed9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $66
80106edb:	6a 42                	push   $0x42
  jmp alltraps
80106edd:	e9 c9 f8 ff ff       	jmp    801067ab <alltraps>

80106ee2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $67
80106ee4:	6a 43                	push   $0x43
  jmp alltraps
80106ee6:	e9 c0 f8 ff ff       	jmp    801067ab <alltraps>

80106eeb <vector68>:
.globl vector68
vector68:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $68
80106eed:	6a 44                	push   $0x44
  jmp alltraps
80106eef:	e9 b7 f8 ff ff       	jmp    801067ab <alltraps>

80106ef4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $69
80106ef6:	6a 45                	push   $0x45
  jmp alltraps
80106ef8:	e9 ae f8 ff ff       	jmp    801067ab <alltraps>

80106efd <vector70>:
.globl vector70
vector70:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $70
80106eff:	6a 46                	push   $0x46
  jmp alltraps
80106f01:	e9 a5 f8 ff ff       	jmp    801067ab <alltraps>

80106f06 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $71
80106f08:	6a 47                	push   $0x47
  jmp alltraps
80106f0a:	e9 9c f8 ff ff       	jmp    801067ab <alltraps>

80106f0f <vector72>:
.globl vector72
vector72:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $72
80106f11:	6a 48                	push   $0x48
  jmp alltraps
80106f13:	e9 93 f8 ff ff       	jmp    801067ab <alltraps>

80106f18 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $73
80106f1a:	6a 49                	push   $0x49
  jmp alltraps
80106f1c:	e9 8a f8 ff ff       	jmp    801067ab <alltraps>

80106f21 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $74
80106f23:	6a 4a                	push   $0x4a
  jmp alltraps
80106f25:	e9 81 f8 ff ff       	jmp    801067ab <alltraps>

80106f2a <vector75>:
.globl vector75
vector75:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $75
80106f2c:	6a 4b                	push   $0x4b
  jmp alltraps
80106f2e:	e9 78 f8 ff ff       	jmp    801067ab <alltraps>

80106f33 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $76
80106f35:	6a 4c                	push   $0x4c
  jmp alltraps
80106f37:	e9 6f f8 ff ff       	jmp    801067ab <alltraps>

80106f3c <vector77>:
.globl vector77
vector77:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $77
80106f3e:	6a 4d                	push   $0x4d
  jmp alltraps
80106f40:	e9 66 f8 ff ff       	jmp    801067ab <alltraps>

80106f45 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $78
80106f47:	6a 4e                	push   $0x4e
  jmp alltraps
80106f49:	e9 5d f8 ff ff       	jmp    801067ab <alltraps>

80106f4e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $79
80106f50:	6a 4f                	push   $0x4f
  jmp alltraps
80106f52:	e9 54 f8 ff ff       	jmp    801067ab <alltraps>

80106f57 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $80
80106f59:	6a 50                	push   $0x50
  jmp alltraps
80106f5b:	e9 4b f8 ff ff       	jmp    801067ab <alltraps>

80106f60 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $81
80106f62:	6a 51                	push   $0x51
  jmp alltraps
80106f64:	e9 42 f8 ff ff       	jmp    801067ab <alltraps>

80106f69 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $82
80106f6b:	6a 52                	push   $0x52
  jmp alltraps
80106f6d:	e9 39 f8 ff ff       	jmp    801067ab <alltraps>

80106f72 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $83
80106f74:	6a 53                	push   $0x53
  jmp alltraps
80106f76:	e9 30 f8 ff ff       	jmp    801067ab <alltraps>

80106f7b <vector84>:
.globl vector84
vector84:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $84
80106f7d:	6a 54                	push   $0x54
  jmp alltraps
80106f7f:	e9 27 f8 ff ff       	jmp    801067ab <alltraps>

80106f84 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $85
80106f86:	6a 55                	push   $0x55
  jmp alltraps
80106f88:	e9 1e f8 ff ff       	jmp    801067ab <alltraps>

80106f8d <vector86>:
.globl vector86
vector86:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $86
80106f8f:	6a 56                	push   $0x56
  jmp alltraps
80106f91:	e9 15 f8 ff ff       	jmp    801067ab <alltraps>

80106f96 <vector87>:
.globl vector87
vector87:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $87
80106f98:	6a 57                	push   $0x57
  jmp alltraps
80106f9a:	e9 0c f8 ff ff       	jmp    801067ab <alltraps>

80106f9f <vector88>:
.globl vector88
vector88:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $88
80106fa1:	6a 58                	push   $0x58
  jmp alltraps
80106fa3:	e9 03 f8 ff ff       	jmp    801067ab <alltraps>

80106fa8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $89
80106faa:	6a 59                	push   $0x59
  jmp alltraps
80106fac:	e9 fa f7 ff ff       	jmp    801067ab <alltraps>

80106fb1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $90
80106fb3:	6a 5a                	push   $0x5a
  jmp alltraps
80106fb5:	e9 f1 f7 ff ff       	jmp    801067ab <alltraps>

80106fba <vector91>:
.globl vector91
vector91:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $91
80106fbc:	6a 5b                	push   $0x5b
  jmp alltraps
80106fbe:	e9 e8 f7 ff ff       	jmp    801067ab <alltraps>

80106fc3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $92
80106fc5:	6a 5c                	push   $0x5c
  jmp alltraps
80106fc7:	e9 df f7 ff ff       	jmp    801067ab <alltraps>

80106fcc <vector93>:
.globl vector93
vector93:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $93
80106fce:	6a 5d                	push   $0x5d
  jmp alltraps
80106fd0:	e9 d6 f7 ff ff       	jmp    801067ab <alltraps>

80106fd5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $94
80106fd7:	6a 5e                	push   $0x5e
  jmp alltraps
80106fd9:	e9 cd f7 ff ff       	jmp    801067ab <alltraps>

80106fde <vector95>:
.globl vector95
vector95:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $95
80106fe0:	6a 5f                	push   $0x5f
  jmp alltraps
80106fe2:	e9 c4 f7 ff ff       	jmp    801067ab <alltraps>

80106fe7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $96
80106fe9:	6a 60                	push   $0x60
  jmp alltraps
80106feb:	e9 bb f7 ff ff       	jmp    801067ab <alltraps>

80106ff0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $97
80106ff2:	6a 61                	push   $0x61
  jmp alltraps
80106ff4:	e9 b2 f7 ff ff       	jmp    801067ab <alltraps>

80106ff9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $98
80106ffb:	6a 62                	push   $0x62
  jmp alltraps
80106ffd:	e9 a9 f7 ff ff       	jmp    801067ab <alltraps>

80107002 <vector99>:
.globl vector99
vector99:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $99
80107004:	6a 63                	push   $0x63
  jmp alltraps
80107006:	e9 a0 f7 ff ff       	jmp    801067ab <alltraps>

8010700b <vector100>:
.globl vector100
vector100:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $100
8010700d:	6a 64                	push   $0x64
  jmp alltraps
8010700f:	e9 97 f7 ff ff       	jmp    801067ab <alltraps>

80107014 <vector101>:
.globl vector101
vector101:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $101
80107016:	6a 65                	push   $0x65
  jmp alltraps
80107018:	e9 8e f7 ff ff       	jmp    801067ab <alltraps>

8010701d <vector102>:
.globl vector102
vector102:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $102
8010701f:	6a 66                	push   $0x66
  jmp alltraps
80107021:	e9 85 f7 ff ff       	jmp    801067ab <alltraps>

80107026 <vector103>:
.globl vector103
vector103:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $103
80107028:	6a 67                	push   $0x67
  jmp alltraps
8010702a:	e9 7c f7 ff ff       	jmp    801067ab <alltraps>

8010702f <vector104>:
.globl vector104
vector104:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $104
80107031:	6a 68                	push   $0x68
  jmp alltraps
80107033:	e9 73 f7 ff ff       	jmp    801067ab <alltraps>

80107038 <vector105>:
.globl vector105
vector105:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $105
8010703a:	6a 69                	push   $0x69
  jmp alltraps
8010703c:	e9 6a f7 ff ff       	jmp    801067ab <alltraps>

80107041 <vector106>:
.globl vector106
vector106:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $106
80107043:	6a 6a                	push   $0x6a
  jmp alltraps
80107045:	e9 61 f7 ff ff       	jmp    801067ab <alltraps>

8010704a <vector107>:
.globl vector107
vector107:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $107
8010704c:	6a 6b                	push   $0x6b
  jmp alltraps
8010704e:	e9 58 f7 ff ff       	jmp    801067ab <alltraps>

80107053 <vector108>:
.globl vector108
vector108:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $108
80107055:	6a 6c                	push   $0x6c
  jmp alltraps
80107057:	e9 4f f7 ff ff       	jmp    801067ab <alltraps>

8010705c <vector109>:
.globl vector109
vector109:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $109
8010705e:	6a 6d                	push   $0x6d
  jmp alltraps
80107060:	e9 46 f7 ff ff       	jmp    801067ab <alltraps>

80107065 <vector110>:
.globl vector110
vector110:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $110
80107067:	6a 6e                	push   $0x6e
  jmp alltraps
80107069:	e9 3d f7 ff ff       	jmp    801067ab <alltraps>

8010706e <vector111>:
.globl vector111
vector111:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $111
80107070:	6a 6f                	push   $0x6f
  jmp alltraps
80107072:	e9 34 f7 ff ff       	jmp    801067ab <alltraps>

80107077 <vector112>:
.globl vector112
vector112:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $112
80107079:	6a 70                	push   $0x70
  jmp alltraps
8010707b:	e9 2b f7 ff ff       	jmp    801067ab <alltraps>

80107080 <vector113>:
.globl vector113
vector113:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $113
80107082:	6a 71                	push   $0x71
  jmp alltraps
80107084:	e9 22 f7 ff ff       	jmp    801067ab <alltraps>

80107089 <vector114>:
.globl vector114
vector114:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $114
8010708b:	6a 72                	push   $0x72
  jmp alltraps
8010708d:	e9 19 f7 ff ff       	jmp    801067ab <alltraps>

80107092 <vector115>:
.globl vector115
vector115:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $115
80107094:	6a 73                	push   $0x73
  jmp alltraps
80107096:	e9 10 f7 ff ff       	jmp    801067ab <alltraps>

8010709b <vector116>:
.globl vector116
vector116:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $116
8010709d:	6a 74                	push   $0x74
  jmp alltraps
8010709f:	e9 07 f7 ff ff       	jmp    801067ab <alltraps>

801070a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $117
801070a6:	6a 75                	push   $0x75
  jmp alltraps
801070a8:	e9 fe f6 ff ff       	jmp    801067ab <alltraps>

801070ad <vector118>:
.globl vector118
vector118:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $118
801070af:	6a 76                	push   $0x76
  jmp alltraps
801070b1:	e9 f5 f6 ff ff       	jmp    801067ab <alltraps>

801070b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $119
801070b8:	6a 77                	push   $0x77
  jmp alltraps
801070ba:	e9 ec f6 ff ff       	jmp    801067ab <alltraps>

801070bf <vector120>:
.globl vector120
vector120:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $120
801070c1:	6a 78                	push   $0x78
  jmp alltraps
801070c3:	e9 e3 f6 ff ff       	jmp    801067ab <alltraps>

801070c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $121
801070ca:	6a 79                	push   $0x79
  jmp alltraps
801070cc:	e9 da f6 ff ff       	jmp    801067ab <alltraps>

801070d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $122
801070d3:	6a 7a                	push   $0x7a
  jmp alltraps
801070d5:	e9 d1 f6 ff ff       	jmp    801067ab <alltraps>

801070da <vector123>:
.globl vector123
vector123:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $123
801070dc:	6a 7b                	push   $0x7b
  jmp alltraps
801070de:	e9 c8 f6 ff ff       	jmp    801067ab <alltraps>

801070e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $124
801070e5:	6a 7c                	push   $0x7c
  jmp alltraps
801070e7:	e9 bf f6 ff ff       	jmp    801067ab <alltraps>

801070ec <vector125>:
.globl vector125
vector125:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $125
801070ee:	6a 7d                	push   $0x7d
  jmp alltraps
801070f0:	e9 b6 f6 ff ff       	jmp    801067ab <alltraps>

801070f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $126
801070f7:	6a 7e                	push   $0x7e
  jmp alltraps
801070f9:	e9 ad f6 ff ff       	jmp    801067ab <alltraps>

801070fe <vector127>:
.globl vector127
vector127:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $127
80107100:	6a 7f                	push   $0x7f
  jmp alltraps
80107102:	e9 a4 f6 ff ff       	jmp    801067ab <alltraps>

80107107 <vector128>:
.globl vector128
vector128:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $128
80107109:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010710e:	e9 98 f6 ff ff       	jmp    801067ab <alltraps>

80107113 <vector129>:
.globl vector129
vector129:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $129
80107115:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010711a:	e9 8c f6 ff ff       	jmp    801067ab <alltraps>

8010711f <vector130>:
.globl vector130
vector130:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $130
80107121:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107126:	e9 80 f6 ff ff       	jmp    801067ab <alltraps>

8010712b <vector131>:
.globl vector131
vector131:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $131
8010712d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107132:	e9 74 f6 ff ff       	jmp    801067ab <alltraps>

80107137 <vector132>:
.globl vector132
vector132:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $132
80107139:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010713e:	e9 68 f6 ff ff       	jmp    801067ab <alltraps>

80107143 <vector133>:
.globl vector133
vector133:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $133
80107145:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010714a:	e9 5c f6 ff ff       	jmp    801067ab <alltraps>

8010714f <vector134>:
.globl vector134
vector134:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $134
80107151:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107156:	e9 50 f6 ff ff       	jmp    801067ab <alltraps>

8010715b <vector135>:
.globl vector135
vector135:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $135
8010715d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107162:	e9 44 f6 ff ff       	jmp    801067ab <alltraps>

80107167 <vector136>:
.globl vector136
vector136:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $136
80107169:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010716e:	e9 38 f6 ff ff       	jmp    801067ab <alltraps>

80107173 <vector137>:
.globl vector137
vector137:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $137
80107175:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010717a:	e9 2c f6 ff ff       	jmp    801067ab <alltraps>

8010717f <vector138>:
.globl vector138
vector138:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $138
80107181:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107186:	e9 20 f6 ff ff       	jmp    801067ab <alltraps>

8010718b <vector139>:
.globl vector139
vector139:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $139
8010718d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107192:	e9 14 f6 ff ff       	jmp    801067ab <alltraps>

80107197 <vector140>:
.globl vector140
vector140:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $140
80107199:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010719e:	e9 08 f6 ff ff       	jmp    801067ab <alltraps>

801071a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $141
801071a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071aa:	e9 fc f5 ff ff       	jmp    801067ab <alltraps>

801071af <vector142>:
.globl vector142
vector142:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $142
801071b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071b6:	e9 f0 f5 ff ff       	jmp    801067ab <alltraps>

801071bb <vector143>:
.globl vector143
vector143:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $143
801071bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071c2:	e9 e4 f5 ff ff       	jmp    801067ab <alltraps>

801071c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $144
801071c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071ce:	e9 d8 f5 ff ff       	jmp    801067ab <alltraps>

801071d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $145
801071d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071da:	e9 cc f5 ff ff       	jmp    801067ab <alltraps>

801071df <vector146>:
.globl vector146
vector146:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $146
801071e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071e6:	e9 c0 f5 ff ff       	jmp    801067ab <alltraps>

801071eb <vector147>:
.globl vector147
vector147:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $147
801071ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071f2:	e9 b4 f5 ff ff       	jmp    801067ab <alltraps>

801071f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $148
801071f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071fe:	e9 a8 f5 ff ff       	jmp    801067ab <alltraps>

80107203 <vector149>:
.globl vector149
vector149:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $149
80107205:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010720a:	e9 9c f5 ff ff       	jmp    801067ab <alltraps>

8010720f <vector150>:
.globl vector150
vector150:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $150
80107211:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107216:	e9 90 f5 ff ff       	jmp    801067ab <alltraps>

8010721b <vector151>:
.globl vector151
vector151:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $151
8010721d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107222:	e9 84 f5 ff ff       	jmp    801067ab <alltraps>

80107227 <vector152>:
.globl vector152
vector152:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $152
80107229:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010722e:	e9 78 f5 ff ff       	jmp    801067ab <alltraps>

80107233 <vector153>:
.globl vector153
vector153:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $153
80107235:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010723a:	e9 6c f5 ff ff       	jmp    801067ab <alltraps>

8010723f <vector154>:
.globl vector154
vector154:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $154
80107241:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107246:	e9 60 f5 ff ff       	jmp    801067ab <alltraps>

8010724b <vector155>:
.globl vector155
vector155:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $155
8010724d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107252:	e9 54 f5 ff ff       	jmp    801067ab <alltraps>

80107257 <vector156>:
.globl vector156
vector156:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $156
80107259:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010725e:	e9 48 f5 ff ff       	jmp    801067ab <alltraps>

80107263 <vector157>:
.globl vector157
vector157:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $157
80107265:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010726a:	e9 3c f5 ff ff       	jmp    801067ab <alltraps>

8010726f <vector158>:
.globl vector158
vector158:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $158
80107271:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107276:	e9 30 f5 ff ff       	jmp    801067ab <alltraps>

8010727b <vector159>:
.globl vector159
vector159:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $159
8010727d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107282:	e9 24 f5 ff ff       	jmp    801067ab <alltraps>

80107287 <vector160>:
.globl vector160
vector160:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $160
80107289:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010728e:	e9 18 f5 ff ff       	jmp    801067ab <alltraps>

80107293 <vector161>:
.globl vector161
vector161:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $161
80107295:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010729a:	e9 0c f5 ff ff       	jmp    801067ab <alltraps>

8010729f <vector162>:
.globl vector162
vector162:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $162
801072a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072a6:	e9 00 f5 ff ff       	jmp    801067ab <alltraps>

801072ab <vector163>:
.globl vector163
vector163:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $163
801072ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072b2:	e9 f4 f4 ff ff       	jmp    801067ab <alltraps>

801072b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $164
801072b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072be:	e9 e8 f4 ff ff       	jmp    801067ab <alltraps>

801072c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $165
801072c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072ca:	e9 dc f4 ff ff       	jmp    801067ab <alltraps>

801072cf <vector166>:
.globl vector166
vector166:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $166
801072d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072d6:	e9 d0 f4 ff ff       	jmp    801067ab <alltraps>

801072db <vector167>:
.globl vector167
vector167:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $167
801072dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072e2:	e9 c4 f4 ff ff       	jmp    801067ab <alltraps>

801072e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $168
801072e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072ee:	e9 b8 f4 ff ff       	jmp    801067ab <alltraps>

801072f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $169
801072f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072fa:	e9 ac f4 ff ff       	jmp    801067ab <alltraps>

801072ff <vector170>:
.globl vector170
vector170:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $170
80107301:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107306:	e9 a0 f4 ff ff       	jmp    801067ab <alltraps>

8010730b <vector171>:
.globl vector171
vector171:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $171
8010730d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107312:	e9 94 f4 ff ff       	jmp    801067ab <alltraps>

80107317 <vector172>:
.globl vector172
vector172:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $172
80107319:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010731e:	e9 88 f4 ff ff       	jmp    801067ab <alltraps>

80107323 <vector173>:
.globl vector173
vector173:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $173
80107325:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010732a:	e9 7c f4 ff ff       	jmp    801067ab <alltraps>

8010732f <vector174>:
.globl vector174
vector174:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $174
80107331:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107336:	e9 70 f4 ff ff       	jmp    801067ab <alltraps>

8010733b <vector175>:
.globl vector175
vector175:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $175
8010733d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107342:	e9 64 f4 ff ff       	jmp    801067ab <alltraps>

80107347 <vector176>:
.globl vector176
vector176:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $176
80107349:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010734e:	e9 58 f4 ff ff       	jmp    801067ab <alltraps>

80107353 <vector177>:
.globl vector177
vector177:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $177
80107355:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010735a:	e9 4c f4 ff ff       	jmp    801067ab <alltraps>

8010735f <vector178>:
.globl vector178
vector178:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $178
80107361:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107366:	e9 40 f4 ff ff       	jmp    801067ab <alltraps>

8010736b <vector179>:
.globl vector179
vector179:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $179
8010736d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107372:	e9 34 f4 ff ff       	jmp    801067ab <alltraps>

80107377 <vector180>:
.globl vector180
vector180:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $180
80107379:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010737e:	e9 28 f4 ff ff       	jmp    801067ab <alltraps>

80107383 <vector181>:
.globl vector181
vector181:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $181
80107385:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010738a:	e9 1c f4 ff ff       	jmp    801067ab <alltraps>

8010738f <vector182>:
.globl vector182
vector182:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $182
80107391:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107396:	e9 10 f4 ff ff       	jmp    801067ab <alltraps>

8010739b <vector183>:
.globl vector183
vector183:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $183
8010739d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073a2:	e9 04 f4 ff ff       	jmp    801067ab <alltraps>

801073a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $184
801073a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073ae:	e9 f8 f3 ff ff       	jmp    801067ab <alltraps>

801073b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $185
801073b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073ba:	e9 ec f3 ff ff       	jmp    801067ab <alltraps>

801073bf <vector186>:
.globl vector186
vector186:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $186
801073c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073c6:	e9 e0 f3 ff ff       	jmp    801067ab <alltraps>

801073cb <vector187>:
.globl vector187
vector187:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $187
801073cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073d2:	e9 d4 f3 ff ff       	jmp    801067ab <alltraps>

801073d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $188
801073d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073de:	e9 c8 f3 ff ff       	jmp    801067ab <alltraps>

801073e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $189
801073e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073ea:	e9 bc f3 ff ff       	jmp    801067ab <alltraps>

801073ef <vector190>:
.globl vector190
vector190:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $190
801073f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073f6:	e9 b0 f3 ff ff       	jmp    801067ab <alltraps>

801073fb <vector191>:
.globl vector191
vector191:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $191
801073fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107402:	e9 a4 f3 ff ff       	jmp    801067ab <alltraps>

80107407 <vector192>:
.globl vector192
vector192:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $192
80107409:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010740e:	e9 98 f3 ff ff       	jmp    801067ab <alltraps>

80107413 <vector193>:
.globl vector193
vector193:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $193
80107415:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010741a:	e9 8c f3 ff ff       	jmp    801067ab <alltraps>

8010741f <vector194>:
.globl vector194
vector194:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $194
80107421:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107426:	e9 80 f3 ff ff       	jmp    801067ab <alltraps>

8010742b <vector195>:
.globl vector195
vector195:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $195
8010742d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107432:	e9 74 f3 ff ff       	jmp    801067ab <alltraps>

80107437 <vector196>:
.globl vector196
vector196:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $196
80107439:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010743e:	e9 68 f3 ff ff       	jmp    801067ab <alltraps>

80107443 <vector197>:
.globl vector197
vector197:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $197
80107445:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010744a:	e9 5c f3 ff ff       	jmp    801067ab <alltraps>

8010744f <vector198>:
.globl vector198
vector198:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $198
80107451:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107456:	e9 50 f3 ff ff       	jmp    801067ab <alltraps>

8010745b <vector199>:
.globl vector199
vector199:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $199
8010745d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107462:	e9 44 f3 ff ff       	jmp    801067ab <alltraps>

80107467 <vector200>:
.globl vector200
vector200:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $200
80107469:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010746e:	e9 38 f3 ff ff       	jmp    801067ab <alltraps>

80107473 <vector201>:
.globl vector201
vector201:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $201
80107475:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010747a:	e9 2c f3 ff ff       	jmp    801067ab <alltraps>

8010747f <vector202>:
.globl vector202
vector202:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $202
80107481:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107486:	e9 20 f3 ff ff       	jmp    801067ab <alltraps>

8010748b <vector203>:
.globl vector203
vector203:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $203
8010748d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107492:	e9 14 f3 ff ff       	jmp    801067ab <alltraps>

80107497 <vector204>:
.globl vector204
vector204:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $204
80107499:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010749e:	e9 08 f3 ff ff       	jmp    801067ab <alltraps>

801074a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $205
801074a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074aa:	e9 fc f2 ff ff       	jmp    801067ab <alltraps>

801074af <vector206>:
.globl vector206
vector206:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $206
801074b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074b6:	e9 f0 f2 ff ff       	jmp    801067ab <alltraps>

801074bb <vector207>:
.globl vector207
vector207:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $207
801074bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074c2:	e9 e4 f2 ff ff       	jmp    801067ab <alltraps>

801074c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $208
801074c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074ce:	e9 d8 f2 ff ff       	jmp    801067ab <alltraps>

801074d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $209
801074d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074da:	e9 cc f2 ff ff       	jmp    801067ab <alltraps>

801074df <vector210>:
.globl vector210
vector210:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $210
801074e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074e6:	e9 c0 f2 ff ff       	jmp    801067ab <alltraps>

801074eb <vector211>:
.globl vector211
vector211:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $211
801074ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074f2:	e9 b4 f2 ff ff       	jmp    801067ab <alltraps>

801074f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $212
801074f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074fe:	e9 a8 f2 ff ff       	jmp    801067ab <alltraps>

80107503 <vector213>:
.globl vector213
vector213:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $213
80107505:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010750a:	e9 9c f2 ff ff       	jmp    801067ab <alltraps>

8010750f <vector214>:
.globl vector214
vector214:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $214
80107511:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107516:	e9 90 f2 ff ff       	jmp    801067ab <alltraps>

8010751b <vector215>:
.globl vector215
vector215:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $215
8010751d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107522:	e9 84 f2 ff ff       	jmp    801067ab <alltraps>

80107527 <vector216>:
.globl vector216
vector216:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $216
80107529:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010752e:	e9 78 f2 ff ff       	jmp    801067ab <alltraps>

80107533 <vector217>:
.globl vector217
vector217:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $217
80107535:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010753a:	e9 6c f2 ff ff       	jmp    801067ab <alltraps>

8010753f <vector218>:
.globl vector218
vector218:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $218
80107541:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107546:	e9 60 f2 ff ff       	jmp    801067ab <alltraps>

8010754b <vector219>:
.globl vector219
vector219:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $219
8010754d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107552:	e9 54 f2 ff ff       	jmp    801067ab <alltraps>

80107557 <vector220>:
.globl vector220
vector220:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $220
80107559:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010755e:	e9 48 f2 ff ff       	jmp    801067ab <alltraps>

80107563 <vector221>:
.globl vector221
vector221:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $221
80107565:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010756a:	e9 3c f2 ff ff       	jmp    801067ab <alltraps>

8010756f <vector222>:
.globl vector222
vector222:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $222
80107571:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107576:	e9 30 f2 ff ff       	jmp    801067ab <alltraps>

8010757b <vector223>:
.globl vector223
vector223:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $223
8010757d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107582:	e9 24 f2 ff ff       	jmp    801067ab <alltraps>

80107587 <vector224>:
.globl vector224
vector224:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $224
80107589:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010758e:	e9 18 f2 ff ff       	jmp    801067ab <alltraps>

80107593 <vector225>:
.globl vector225
vector225:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $225
80107595:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010759a:	e9 0c f2 ff ff       	jmp    801067ab <alltraps>

8010759f <vector226>:
.globl vector226
vector226:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $226
801075a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075a6:	e9 00 f2 ff ff       	jmp    801067ab <alltraps>

801075ab <vector227>:
.globl vector227
vector227:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $227
801075ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075b2:	e9 f4 f1 ff ff       	jmp    801067ab <alltraps>

801075b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $228
801075b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075be:	e9 e8 f1 ff ff       	jmp    801067ab <alltraps>

801075c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $229
801075c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075ca:	e9 dc f1 ff ff       	jmp    801067ab <alltraps>

801075cf <vector230>:
.globl vector230
vector230:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $230
801075d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075d6:	e9 d0 f1 ff ff       	jmp    801067ab <alltraps>

801075db <vector231>:
.globl vector231
vector231:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $231
801075dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075e2:	e9 c4 f1 ff ff       	jmp    801067ab <alltraps>

801075e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $232
801075e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075ee:	e9 b8 f1 ff ff       	jmp    801067ab <alltraps>

801075f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $233
801075f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075fa:	e9 ac f1 ff ff       	jmp    801067ab <alltraps>

801075ff <vector234>:
.globl vector234
vector234:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $234
80107601:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107606:	e9 a0 f1 ff ff       	jmp    801067ab <alltraps>

8010760b <vector235>:
.globl vector235
vector235:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $235
8010760d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107612:	e9 94 f1 ff ff       	jmp    801067ab <alltraps>

80107617 <vector236>:
.globl vector236
vector236:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $236
80107619:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010761e:	e9 88 f1 ff ff       	jmp    801067ab <alltraps>

80107623 <vector237>:
.globl vector237
vector237:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $237
80107625:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010762a:	e9 7c f1 ff ff       	jmp    801067ab <alltraps>

8010762f <vector238>:
.globl vector238
vector238:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $238
80107631:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107636:	e9 70 f1 ff ff       	jmp    801067ab <alltraps>

8010763b <vector239>:
.globl vector239
vector239:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $239
8010763d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107642:	e9 64 f1 ff ff       	jmp    801067ab <alltraps>

80107647 <vector240>:
.globl vector240
vector240:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $240
80107649:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010764e:	e9 58 f1 ff ff       	jmp    801067ab <alltraps>

80107653 <vector241>:
.globl vector241
vector241:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $241
80107655:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010765a:	e9 4c f1 ff ff       	jmp    801067ab <alltraps>

8010765f <vector242>:
.globl vector242
vector242:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $242
80107661:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107666:	e9 40 f1 ff ff       	jmp    801067ab <alltraps>

8010766b <vector243>:
.globl vector243
vector243:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $243
8010766d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107672:	e9 34 f1 ff ff       	jmp    801067ab <alltraps>

80107677 <vector244>:
.globl vector244
vector244:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $244
80107679:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010767e:	e9 28 f1 ff ff       	jmp    801067ab <alltraps>

80107683 <vector245>:
.globl vector245
vector245:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $245
80107685:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010768a:	e9 1c f1 ff ff       	jmp    801067ab <alltraps>

8010768f <vector246>:
.globl vector246
vector246:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $246
80107691:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107696:	e9 10 f1 ff ff       	jmp    801067ab <alltraps>

8010769b <vector247>:
.globl vector247
vector247:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $247
8010769d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076a2:	e9 04 f1 ff ff       	jmp    801067ab <alltraps>

801076a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $248
801076a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076ae:	e9 f8 f0 ff ff       	jmp    801067ab <alltraps>

801076b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $249
801076b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076ba:	e9 ec f0 ff ff       	jmp    801067ab <alltraps>

801076bf <vector250>:
.globl vector250
vector250:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $250
801076c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076c6:	e9 e0 f0 ff ff       	jmp    801067ab <alltraps>

801076cb <vector251>:
.globl vector251
vector251:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $251
801076cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076d2:	e9 d4 f0 ff ff       	jmp    801067ab <alltraps>

801076d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $252
801076d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076de:	e9 c8 f0 ff ff       	jmp    801067ab <alltraps>

801076e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $253
801076e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076ea:	e9 bc f0 ff ff       	jmp    801067ab <alltraps>

801076ef <vector254>:
.globl vector254
vector254:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $254
801076f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076f6:	e9 b0 f0 ff ff       	jmp    801067ab <alltraps>

801076fb <vector255>:
.globl vector255
vector255:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $255
801076fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107702:	e9 a4 f0 ff ff       	jmp    801067ab <alltraps>
80107707:	66 90                	xchg   %ax,%ax
80107709:	66 90                	xchg   %ax,%ax
8010770b:	66 90                	xchg   %ax,%ax
8010770d:	66 90                	xchg   %ax,%ax
8010770f:	90                   	nop

80107710 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107716:	89 d3                	mov    %edx,%ebx
{
80107718:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010771a:	c1 eb 16             	shr    $0x16,%ebx
8010771d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107720:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107723:	8b 06                	mov    (%esi),%eax
80107725:	a8 01                	test   $0x1,%al
80107727:	74 27                	je     80107750 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107729:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010772e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107734:	c1 ef 0a             	shr    $0xa,%edi
}
80107737:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010773a:	89 fa                	mov    %edi,%edx
8010773c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107742:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107750:	85 c9                	test   %ecx,%ecx
80107752:	74 2c                	je     80107780 <walkpgdir+0x70>
80107754:	e8 37 af ff ff       	call   80102690 <kalloc>
80107759:	85 c0                	test   %eax,%eax
8010775b:	89 c3                	mov    %eax,%ebx
8010775d:	74 21                	je     80107780 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010775f:	83 ec 04             	sub    $0x4,%esp
80107762:	68 00 10 00 00       	push   $0x1000
80107767:	6a 00                	push   $0x0
80107769:	50                   	push   %eax
8010776a:	e8 01 d8 ff ff       	call   80104f70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010776f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107775:	83 c4 10             	add    $0x10,%esp
80107778:	83 c8 07             	or     $0x7,%eax
8010777b:	89 06                	mov    %eax,(%esi)
8010777d:	eb b5                	jmp    80107734 <walkpgdir+0x24>
8010777f:	90                   	nop
}
80107780:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107783:	31 c0                	xor    %eax,%eax
}
80107785:	5b                   	pop    %ebx
80107786:	5e                   	pop    %esi
80107787:	5f                   	pop    %edi
80107788:	5d                   	pop    %ebp
80107789:	c3                   	ret    
8010778a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107790 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107796:	89 d3                	mov    %edx,%ebx
80107798:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010779e:	83 ec 1c             	sub    $0x1c,%esp
801077a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801077a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801077a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801077ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801077b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077b6:	29 df                	sub    %ebx,%edi
801077b8:	83 c8 01             	or     $0x1,%eax
801077bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801077be:	eb 15                	jmp    801077d5 <mappages+0x45>
    if(*pte & PTE_P)
801077c0:	f6 00 01             	testb  $0x1,(%eax)
801077c3:	75 45                	jne    8010780a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801077c5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801077c8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801077cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801077cd:	74 31                	je     80107800 <mappages+0x70>
      break;
    a += PGSIZE;
801077cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801077d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801077dd:	89 da                	mov    %ebx,%edx
801077df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801077e2:	e8 29 ff ff ff       	call   80107710 <walkpgdir>
801077e7:	85 c0                	test   %eax,%eax
801077e9:	75 d5                	jne    801077c0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801077eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077f3:	5b                   	pop    %ebx
801077f4:	5e                   	pop    %esi
801077f5:	5f                   	pop    %edi
801077f6:	5d                   	pop    %ebp
801077f7:	c3                   	ret    
801077f8:	90                   	nop
801077f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107800:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107803:	31 c0                	xor    %eax,%eax
}
80107805:	5b                   	pop    %ebx
80107806:	5e                   	pop    %esi
80107807:	5f                   	pop    %edi
80107808:	5d                   	pop    %ebp
80107809:	c3                   	ret    
      panic("remap");
8010780a:	83 ec 0c             	sub    $0xc,%esp
8010780d:	68 84 8b 10 80       	push   $0x80108b84
80107812:	e8 79 8b ff ff       	call   80100390 <panic>
80107817:	89 f6                	mov    %esi,%esi
80107819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107820 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107826:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010782c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010782e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107834:	83 ec 1c             	sub    $0x1c,%esp
80107837:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010783a:	39 d3                	cmp    %edx,%ebx
8010783c:	73 66                	jae    801078a4 <deallocuvm.part.0+0x84>
8010783e:	89 d6                	mov    %edx,%esi
80107840:	eb 3d                	jmp    8010787f <deallocuvm.part.0+0x5f>
80107842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107848:	8b 10                	mov    (%eax),%edx
8010784a:	f6 c2 01             	test   $0x1,%dl
8010784d:	74 26                	je     80107875 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010784f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107855:	74 58                	je     801078af <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107857:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010785a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107863:	52                   	push   %edx
80107864:	e8 77 ac ff ff       	call   801024e0 <kfree>
      *pte = 0;
80107869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010786c:	83 c4 10             	add    $0x10,%esp
8010786f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107875:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010787b:	39 f3                	cmp    %esi,%ebx
8010787d:	73 25                	jae    801078a4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010787f:	31 c9                	xor    %ecx,%ecx
80107881:	89 da                	mov    %ebx,%edx
80107883:	89 f8                	mov    %edi,%eax
80107885:	e8 86 fe ff ff       	call   80107710 <walkpgdir>
    if(!pte)
8010788a:	85 c0                	test   %eax,%eax
8010788c:	75 ba                	jne    80107848 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010788e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107894:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010789a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078a0:	39 f3                	cmp    %esi,%ebx
801078a2:	72 db                	jb     8010787f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801078a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078aa:	5b                   	pop    %ebx
801078ab:	5e                   	pop    %esi
801078ac:	5f                   	pop    %edi
801078ad:	5d                   	pop    %ebp
801078ae:	c3                   	ret    
        panic("kfree");
801078af:	83 ec 0c             	sub    $0xc,%esp
801078b2:	68 a6 82 10 80       	push   $0x801082a6
801078b7:	e8 d4 8a ff ff       	call   80100390 <panic>
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078c0 <seginit>:
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801078c6:	e8 c5 c0 ff ff       	call   80103990 <cpuid>
801078cb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801078d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801078d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078da:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
801078e1:	ff 00 00 
801078e4:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
801078eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078ee:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
801078f5:	ff 00 00 
801078f8:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
801078ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107902:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
80107909:	ff 00 00 
8010790c:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
80107913:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107916:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
8010791d:	ff 00 00 
80107920:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
80107927:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010792a:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
8010792f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107933:	c1 e8 10             	shr    $0x10,%eax
80107936:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010793a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010793d:	0f 01 10             	lgdtl  (%eax)
}
80107940:	c9                   	leave  
80107941:	c3                   	ret    
80107942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107950 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107950:	a1 44 8e 11 80       	mov    0x80118e44,%eax
{
80107955:	55                   	push   %ebp
80107956:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107958:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010795d:	0f 22 d8             	mov    %eax,%cr3
}
80107960:	5d                   	pop    %ebp
80107961:	c3                   	ret    
80107962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107970 <switchuvm>:
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
80107976:	83 ec 1c             	sub    $0x1c,%esp
80107979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010797c:	85 db                	test   %ebx,%ebx
8010797e:	0f 84 cb 00 00 00    	je     80107a4f <switchuvm+0xdf>
  if(p->kstack == 0)
80107984:	8b 43 08             	mov    0x8(%ebx),%eax
80107987:	85 c0                	test   %eax,%eax
80107989:	0f 84 da 00 00 00    	je     80107a69 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010798f:	8b 43 04             	mov    0x4(%ebx),%eax
80107992:	85 c0                	test   %eax,%eax
80107994:	0f 84 c2 00 00 00    	je     80107a5c <switchuvm+0xec>
  pushcli();
8010799a:	e8 f1 d3 ff ff       	call   80104d90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010799f:	e8 6c bf ff ff       	call   80103910 <mycpu>
801079a4:	89 c6                	mov    %eax,%esi
801079a6:	e8 65 bf ff ff       	call   80103910 <mycpu>
801079ab:	89 c7                	mov    %eax,%edi
801079ad:	e8 5e bf ff ff       	call   80103910 <mycpu>
801079b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079b5:	83 c7 08             	add    $0x8,%edi
801079b8:	e8 53 bf ff ff       	call   80103910 <mycpu>
801079bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079c0:	83 c0 08             	add    $0x8,%eax
801079c3:	ba 67 00 00 00       	mov    $0x67,%edx
801079c8:	c1 e8 18             	shr    $0x18,%eax
801079cb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801079d2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801079d9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079e4:	83 c1 08             	add    $0x8,%ecx
801079e7:	c1 e9 10             	shr    $0x10,%ecx
801079ea:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801079f0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801079f5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801079fc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107a01:	e8 0a bf ff ff       	call   80103910 <mycpu>
80107a06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a0d:	e8 fe be ff ff       	call   80103910 <mycpu>
80107a12:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a16:	8b 73 08             	mov    0x8(%ebx),%esi
80107a19:	e8 f2 be ff ff       	call   80103910 <mycpu>
80107a1e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a24:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a27:	e8 e4 be ff ff       	call   80103910 <mycpu>
80107a2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a30:	b8 28 00 00 00       	mov    $0x28,%eax
80107a35:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107a38:	8b 43 04             	mov    0x4(%ebx),%eax
80107a3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a40:	0f 22 d8             	mov    %eax,%cr3
}
80107a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a46:	5b                   	pop    %ebx
80107a47:	5e                   	pop    %esi
80107a48:	5f                   	pop    %edi
80107a49:	5d                   	pop    %ebp
  popcli();
80107a4a:	e9 81 d3 ff ff       	jmp    80104dd0 <popcli>
    panic("switchuvm: no process");
80107a4f:	83 ec 0c             	sub    $0xc,%esp
80107a52:	68 8a 8b 10 80       	push   $0x80108b8a
80107a57:	e8 34 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107a5c:	83 ec 0c             	sub    $0xc,%esp
80107a5f:	68 b5 8b 10 80       	push   $0x80108bb5
80107a64:	e8 27 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107a69:	83 ec 0c             	sub    $0xc,%esp
80107a6c:	68 a0 8b 10 80       	push   $0x80108ba0
80107a71:	e8 1a 89 ff ff       	call   80100390 <panic>
80107a76:	8d 76 00             	lea    0x0(%esi),%esi
80107a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a80 <inituvm>:
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
80107a86:	83 ec 1c             	sub    $0x1c,%esp
80107a89:	8b 75 10             	mov    0x10(%ebp),%esi
80107a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107a92:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107a9b:	77 49                	ja     80107ae6 <inituvm+0x66>
  mem = kalloc();
80107a9d:	e8 ee ab ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80107aa2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107aa5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107aa7:	68 00 10 00 00       	push   $0x1000
80107aac:	6a 00                	push   $0x0
80107aae:	50                   	push   %eax
80107aaf:	e8 bc d4 ff ff       	call   80104f70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107ab4:	58                   	pop    %eax
80107ab5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107abb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ac0:	5a                   	pop    %edx
80107ac1:	6a 06                	push   $0x6
80107ac3:	50                   	push   %eax
80107ac4:	31 d2                	xor    %edx,%edx
80107ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ac9:	e8 c2 fc ff ff       	call   80107790 <mappages>
  memmove(mem, init, sz);
80107ace:	89 75 10             	mov    %esi,0x10(%ebp)
80107ad1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107ad4:	83 c4 10             	add    $0x10,%esp
80107ad7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107add:	5b                   	pop    %ebx
80107ade:	5e                   	pop    %esi
80107adf:	5f                   	pop    %edi
80107ae0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107ae1:	e9 3a d5 ff ff       	jmp    80105020 <memmove>
    panic("inituvm: more than a page");
80107ae6:	83 ec 0c             	sub    $0xc,%esp
80107ae9:	68 c9 8b 10 80       	push   $0x80108bc9
80107aee:	e8 9d 88 ff ff       	call   80100390 <panic>
80107af3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b00 <loaduvm>:
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	57                   	push   %edi
80107b04:	56                   	push   %esi
80107b05:	53                   	push   %ebx
80107b06:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107b09:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b10:	0f 85 91 00 00 00    	jne    80107ba7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107b16:	8b 75 18             	mov    0x18(%ebp),%esi
80107b19:	31 db                	xor    %ebx,%ebx
80107b1b:	85 f6                	test   %esi,%esi
80107b1d:	75 1a                	jne    80107b39 <loaduvm+0x39>
80107b1f:	eb 6f                	jmp    80107b90 <loaduvm+0x90>
80107b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b2e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107b34:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107b37:	76 57                	jbe    80107b90 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b39:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b3f:	31 c9                	xor    %ecx,%ecx
80107b41:	01 da                	add    %ebx,%edx
80107b43:	e8 c8 fb ff ff       	call   80107710 <walkpgdir>
80107b48:	85 c0                	test   %eax,%eax
80107b4a:	74 4e                	je     80107b9a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107b4c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107b51:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107b56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b5b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b61:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b64:	01 d9                	add    %ebx,%ecx
80107b66:	05 00 00 00 80       	add    $0x80000000,%eax
80107b6b:	57                   	push   %edi
80107b6c:	51                   	push   %ecx
80107b6d:	50                   	push   %eax
80107b6e:	ff 75 10             	pushl  0x10(%ebp)
80107b71:	e8 ba 9f ff ff       	call   80101b30 <readi>
80107b76:	83 c4 10             	add    $0x10,%esp
80107b79:	39 f8                	cmp    %edi,%eax
80107b7b:	74 ab                	je     80107b28 <loaduvm+0x28>
}
80107b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b85:	5b                   	pop    %ebx
80107b86:	5e                   	pop    %esi
80107b87:	5f                   	pop    %edi
80107b88:	5d                   	pop    %ebp
80107b89:	c3                   	ret    
80107b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b93:	31 c0                	xor    %eax,%eax
}
80107b95:	5b                   	pop    %ebx
80107b96:	5e                   	pop    %esi
80107b97:	5f                   	pop    %edi
80107b98:	5d                   	pop    %ebp
80107b99:	c3                   	ret    
      panic("loaduvm: address should exist");
80107b9a:	83 ec 0c             	sub    $0xc,%esp
80107b9d:	68 e3 8b 10 80       	push   $0x80108be3
80107ba2:	e8 e9 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107ba7:	83 ec 0c             	sub    $0xc,%esp
80107baa:	68 84 8c 10 80       	push   $0x80108c84
80107baf:	e8 dc 87 ff ff       	call   80100390 <panic>
80107bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107bc0 <allocuvm>:
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	57                   	push   %edi
80107bc4:	56                   	push   %esi
80107bc5:	53                   	push   %ebx
80107bc6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107bc9:	8b 7d 10             	mov    0x10(%ebp),%edi
80107bcc:	85 ff                	test   %edi,%edi
80107bce:	0f 88 8e 00 00 00    	js     80107c62 <allocuvm+0xa2>
  if(newsz < oldsz)
80107bd4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107bd7:	0f 82 93 00 00 00    	jb     80107c70 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107be0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107be6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107bec:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107bef:	0f 86 7e 00 00 00    	jbe    80107c73 <allocuvm+0xb3>
80107bf5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107bf8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107bfb:	eb 42                	jmp    80107c3f <allocuvm+0x7f>
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107c00:	83 ec 04             	sub    $0x4,%esp
80107c03:	68 00 10 00 00       	push   $0x1000
80107c08:	6a 00                	push   $0x0
80107c0a:	50                   	push   %eax
80107c0b:	e8 60 d3 ff ff       	call   80104f70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c10:	58                   	pop    %eax
80107c11:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c17:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c1c:	5a                   	pop    %edx
80107c1d:	6a 06                	push   $0x6
80107c1f:	50                   	push   %eax
80107c20:	89 da                	mov    %ebx,%edx
80107c22:	89 f8                	mov    %edi,%eax
80107c24:	e8 67 fb ff ff       	call   80107790 <mappages>
80107c29:	83 c4 10             	add    $0x10,%esp
80107c2c:	85 c0                	test   %eax,%eax
80107c2e:	78 50                	js     80107c80 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107c30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c36:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c39:	0f 86 81 00 00 00    	jbe    80107cc0 <allocuvm+0x100>
    mem = kalloc();
80107c3f:	e8 4c aa ff ff       	call   80102690 <kalloc>
    if(mem == 0){
80107c44:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107c46:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107c48:	75 b6                	jne    80107c00 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107c4a:	83 ec 0c             	sub    $0xc,%esp
80107c4d:	68 01 8c 10 80       	push   $0x80108c01
80107c52:	e8 09 8a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107c57:	83 c4 10             	add    $0x10,%esp
80107c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c5d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c60:	77 6e                	ja     80107cd0 <allocuvm+0x110>
}
80107c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107c65:	31 ff                	xor    %edi,%edi
}
80107c67:	89 f8                	mov    %edi,%eax
80107c69:	5b                   	pop    %ebx
80107c6a:	5e                   	pop    %esi
80107c6b:	5f                   	pop    %edi
80107c6c:	5d                   	pop    %ebp
80107c6d:	c3                   	ret    
80107c6e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107c70:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c76:	89 f8                	mov    %edi,%eax
80107c78:	5b                   	pop    %ebx
80107c79:	5e                   	pop    %esi
80107c7a:	5f                   	pop    %edi
80107c7b:	5d                   	pop    %ebp
80107c7c:	c3                   	ret    
80107c7d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107c80:	83 ec 0c             	sub    $0xc,%esp
80107c83:	68 19 8c 10 80       	push   $0x80108c19
80107c88:	e8 d3 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107c8d:	83 c4 10             	add    $0x10,%esp
80107c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c93:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c96:	76 0d                	jbe    80107ca5 <allocuvm+0xe5>
80107c98:	89 c1                	mov    %eax,%ecx
80107c9a:	8b 55 10             	mov    0x10(%ebp),%edx
80107c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca0:	e8 7b fb ff ff       	call   80107820 <deallocuvm.part.0>
      kfree(mem);
80107ca5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107ca8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107caa:	56                   	push   %esi
80107cab:	e8 30 a8 ff ff       	call   801024e0 <kfree>
      return 0;
80107cb0:	83 c4 10             	add    $0x10,%esp
}
80107cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb6:	89 f8                	mov    %edi,%eax
80107cb8:	5b                   	pop    %ebx
80107cb9:	5e                   	pop    %esi
80107cba:	5f                   	pop    %edi
80107cbb:	5d                   	pop    %ebp
80107cbc:	c3                   	ret    
80107cbd:	8d 76 00             	lea    0x0(%esi),%esi
80107cc0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc6:	5b                   	pop    %ebx
80107cc7:	89 f8                	mov    %edi,%eax
80107cc9:	5e                   	pop    %esi
80107cca:	5f                   	pop    %edi
80107ccb:	5d                   	pop    %ebp
80107ccc:	c3                   	ret    
80107ccd:	8d 76 00             	lea    0x0(%esi),%esi
80107cd0:	89 c1                	mov    %eax,%ecx
80107cd2:	8b 55 10             	mov    0x10(%ebp),%edx
80107cd5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107cd8:	31 ff                	xor    %edi,%edi
80107cda:	e8 41 fb ff ff       	call   80107820 <deallocuvm.part.0>
80107cdf:	eb 92                	jmp    80107c73 <allocuvm+0xb3>
80107ce1:	eb 0d                	jmp    80107cf0 <deallocuvm>
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

80107cf0 <deallocuvm>:
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107cfc:	39 d1                	cmp    %edx,%ecx
80107cfe:	73 10                	jae    80107d10 <deallocuvm+0x20>
}
80107d00:	5d                   	pop    %ebp
80107d01:	e9 1a fb ff ff       	jmp    80107820 <deallocuvm.part.0>
80107d06:	8d 76 00             	lea    0x0(%esi),%esi
80107d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d10:	89 d0                	mov    %edx,%eax
80107d12:	5d                   	pop    %ebp
80107d13:	c3                   	ret    
80107d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	57                   	push   %edi
80107d24:	56                   	push   %esi
80107d25:	53                   	push   %ebx
80107d26:	83 ec 0c             	sub    $0xc,%esp
80107d29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d2c:	85 f6                	test   %esi,%esi
80107d2e:	74 59                	je     80107d89 <freevm+0x69>
80107d30:	31 c9                	xor    %ecx,%ecx
80107d32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107d37:	89 f0                	mov    %esi,%eax
80107d39:	e8 e2 fa ff ff       	call   80107820 <deallocuvm.part.0>
80107d3e:	89 f3                	mov    %esi,%ebx
80107d40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d46:	eb 0f                	jmp    80107d57 <freevm+0x37>
80107d48:	90                   	nop
80107d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d50:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d53:	39 fb                	cmp    %edi,%ebx
80107d55:	74 23                	je     80107d7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d57:	8b 03                	mov    (%ebx),%eax
80107d59:	a8 01                	test   $0x1,%al
80107d5b:	74 f3                	je     80107d50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d62:	83 ec 0c             	sub    $0xc,%esp
80107d65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d6d:	50                   	push   %eax
80107d6e:	e8 6d a7 ff ff       	call   801024e0 <kfree>
80107d73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d76:	39 fb                	cmp    %edi,%ebx
80107d78:	75 dd                	jne    80107d57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d80:	5b                   	pop    %ebx
80107d81:	5e                   	pop    %esi
80107d82:	5f                   	pop    %edi
80107d83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d84:	e9 57 a7 ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107d89:	83 ec 0c             	sub    $0xc,%esp
80107d8c:	68 35 8c 10 80       	push   $0x80108c35
80107d91:	e8 fa 85 ff ff       	call   80100390 <panic>
80107d96:	8d 76 00             	lea    0x0(%esi),%esi
80107d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107da0 <setupkvm>:
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	56                   	push   %esi
80107da4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107da5:	e8 e6 a8 ff ff       	call   80102690 <kalloc>
80107daa:	85 c0                	test   %eax,%eax
80107dac:	89 c6                	mov    %eax,%esi
80107dae:	74 42                	je     80107df2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107db0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107db3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107db8:	68 00 10 00 00       	push   $0x1000
80107dbd:	6a 00                	push   $0x0
80107dbf:	50                   	push   %eax
80107dc0:	e8 ab d1 ff ff       	call   80104f70 <memset>
80107dc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107dc8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107dcb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107dce:	83 ec 08             	sub    $0x8,%esp
80107dd1:	8b 13                	mov    (%ebx),%edx
80107dd3:	ff 73 0c             	pushl  0xc(%ebx)
80107dd6:	50                   	push   %eax
80107dd7:	29 c1                	sub    %eax,%ecx
80107dd9:	89 f0                	mov    %esi,%eax
80107ddb:	e8 b0 f9 ff ff       	call   80107790 <mappages>
80107de0:	83 c4 10             	add    $0x10,%esp
80107de3:	85 c0                	test   %eax,%eax
80107de5:	78 19                	js     80107e00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107de7:	83 c3 10             	add    $0x10,%ebx
80107dea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107df0:	75 d6                	jne    80107dc8 <setupkvm+0x28>
}
80107df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107df5:	89 f0                	mov    %esi,%eax
80107df7:	5b                   	pop    %ebx
80107df8:	5e                   	pop    %esi
80107df9:	5d                   	pop    %ebp
80107dfa:	c3                   	ret    
80107dfb:	90                   	nop
80107dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107e00:	83 ec 0c             	sub    $0xc,%esp
80107e03:	56                   	push   %esi
      return 0;
80107e04:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e06:	e8 15 ff ff ff       	call   80107d20 <freevm>
      return 0;
80107e0b:	83 c4 10             	add    $0x10,%esp
}
80107e0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e11:	89 f0                	mov    %esi,%eax
80107e13:	5b                   	pop    %ebx
80107e14:	5e                   	pop    %esi
80107e15:	5d                   	pop    %ebp
80107e16:	c3                   	ret    
80107e17:	89 f6                	mov    %esi,%esi
80107e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e20 <kvmalloc>:
{
80107e20:	55                   	push   %ebp
80107e21:	89 e5                	mov    %esp,%ebp
80107e23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e26:	e8 75 ff ff ff       	call   80107da0 <setupkvm>
80107e2b:	a3 44 8e 11 80       	mov    %eax,0x80118e44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e30:	05 00 00 00 80       	add    $0x80000000,%eax
80107e35:	0f 22 d8             	mov    %eax,%cr3
}
80107e38:	c9                   	leave  
80107e39:	c3                   	ret    
80107e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e41:	31 c9                	xor    %ecx,%ecx
{
80107e43:	89 e5                	mov    %esp,%ebp
80107e45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e4e:	e8 bd f8 ff ff       	call   80107710 <walkpgdir>
  if(pte == 0)
80107e53:	85 c0                	test   %eax,%eax
80107e55:	74 05                	je     80107e5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e5a:	c9                   	leave  
80107e5b:	c3                   	ret    
    panic("clearpteu");
80107e5c:	83 ec 0c             	sub    $0xc,%esp
80107e5f:	68 46 8c 10 80       	push   $0x80108c46
80107e64:	e8 27 85 ff ff       	call   80100390 <panic>
80107e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	57                   	push   %edi
80107e74:	56                   	push   %esi
80107e75:	53                   	push   %ebx
80107e76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e79:	e8 22 ff ff ff       	call   80107da0 <setupkvm>
80107e7e:	85 c0                	test   %eax,%eax
80107e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e83:	0f 84 9f 00 00 00    	je     80107f28 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107e8c:	85 c9                	test   %ecx,%ecx
80107e8e:	0f 84 94 00 00 00    	je     80107f28 <copyuvm+0xb8>
80107e94:	31 ff                	xor    %edi,%edi
80107e96:	eb 4a                	jmp    80107ee2 <copyuvm+0x72>
80107e98:	90                   	nop
80107e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ea0:	83 ec 04             	sub    $0x4,%esp
80107ea3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107ea9:	68 00 10 00 00       	push   $0x1000
80107eae:	53                   	push   %ebx
80107eaf:	50                   	push   %eax
80107eb0:	e8 6b d1 ff ff       	call   80105020 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107eb5:	58                   	pop    %eax
80107eb6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ebc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ec1:	5a                   	pop    %edx
80107ec2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ec5:	50                   	push   %eax
80107ec6:	89 fa                	mov    %edi,%edx
80107ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ecb:	e8 c0 f8 ff ff       	call   80107790 <mappages>
80107ed0:	83 c4 10             	add    $0x10,%esp
80107ed3:	85 c0                	test   %eax,%eax
80107ed5:	78 61                	js     80107f38 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107ed7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107edd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107ee0:	76 46                	jbe    80107f28 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee5:	31 c9                	xor    %ecx,%ecx
80107ee7:	89 fa                	mov    %edi,%edx
80107ee9:	e8 22 f8 ff ff       	call   80107710 <walkpgdir>
80107eee:	85 c0                	test   %eax,%eax
80107ef0:	74 61                	je     80107f53 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107ef2:	8b 00                	mov    (%eax),%eax
80107ef4:	a8 01                	test   $0x1,%al
80107ef6:	74 4e                	je     80107f46 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107ef8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107efa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107eff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f08:	e8 83 a7 ff ff       	call   80102690 <kalloc>
80107f0d:	85 c0                	test   %eax,%eax
80107f0f:	89 c6                	mov    %eax,%esi
80107f11:	75 8d                	jne    80107ea0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107f13:	83 ec 0c             	sub    $0xc,%esp
80107f16:	ff 75 e0             	pushl  -0x20(%ebp)
80107f19:	e8 02 fe ff ff       	call   80107d20 <freevm>
  return 0;
80107f1e:	83 c4 10             	add    $0x10,%esp
80107f21:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f2e:	5b                   	pop    %ebx
80107f2f:	5e                   	pop    %esi
80107f30:	5f                   	pop    %edi
80107f31:	5d                   	pop    %ebp
80107f32:	c3                   	ret    
80107f33:	90                   	nop
80107f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107f38:	83 ec 0c             	sub    $0xc,%esp
80107f3b:	56                   	push   %esi
80107f3c:	e8 9f a5 ff ff       	call   801024e0 <kfree>
      goto bad;
80107f41:	83 c4 10             	add    $0x10,%esp
80107f44:	eb cd                	jmp    80107f13 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107f46:	83 ec 0c             	sub    $0xc,%esp
80107f49:	68 6a 8c 10 80       	push   $0x80108c6a
80107f4e:	e8 3d 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f53:	83 ec 0c             	sub    $0xc,%esp
80107f56:	68 50 8c 10 80       	push   $0x80108c50
80107f5b:	e8 30 84 ff ff       	call   80100390 <panic>

80107f60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f61:	31 c9                	xor    %ecx,%ecx
{
80107f63:	89 e5                	mov    %esp,%ebp
80107f65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f68:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6e:	e8 9d f7 ff ff       	call   80107710 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107f73:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f75:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107f76:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f7d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f80:	05 00 00 00 80       	add    $0x80000000,%eax
80107f85:	83 fa 05             	cmp    $0x5,%edx
80107f88:	ba 00 00 00 00       	mov    $0x0,%edx
80107f8d:	0f 45 c2             	cmovne %edx,%eax
}
80107f90:	c3                   	ret    
80107f91:	eb 0d                	jmp    80107fa0 <copyout>
80107f93:	90                   	nop
80107f94:	90                   	nop
80107f95:	90                   	nop
80107f96:	90                   	nop
80107f97:	90                   	nop
80107f98:	90                   	nop
80107f99:	90                   	nop
80107f9a:	90                   	nop
80107f9b:	90                   	nop
80107f9c:	90                   	nop
80107f9d:	90                   	nop
80107f9e:	90                   	nop
80107f9f:	90                   	nop

80107fa0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107fa0:	55                   	push   %ebp
80107fa1:	89 e5                	mov    %esp,%ebp
80107fa3:	57                   	push   %edi
80107fa4:	56                   	push   %esi
80107fa5:	53                   	push   %ebx
80107fa6:	83 ec 1c             	sub    $0x1c,%esp
80107fa9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107fac:	8b 55 0c             	mov    0xc(%ebp),%edx
80107faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fb2:	85 db                	test   %ebx,%ebx
80107fb4:	75 40                	jne    80107ff6 <copyout+0x56>
80107fb6:	eb 70                	jmp    80108028 <copyout+0x88>
80107fb8:	90                   	nop
80107fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107fc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fc3:	89 f1                	mov    %esi,%ecx
80107fc5:	29 d1                	sub    %edx,%ecx
80107fc7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107fcd:	39 d9                	cmp    %ebx,%ecx
80107fcf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107fd2:	29 f2                	sub    %esi,%edx
80107fd4:	83 ec 04             	sub    $0x4,%esp
80107fd7:	01 d0                	add    %edx,%eax
80107fd9:	51                   	push   %ecx
80107fda:	57                   	push   %edi
80107fdb:	50                   	push   %eax
80107fdc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107fdf:	e8 3c d0 ff ff       	call   80105020 <memmove>
    len -= n;
    buf += n;
80107fe4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107fe7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107fea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107ff0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107ff2:	29 cb                	sub    %ecx,%ebx
80107ff4:	74 32                	je     80108028 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107ff6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ff8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ffb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107ffe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108004:	56                   	push   %esi
80108005:	ff 75 08             	pushl  0x8(%ebp)
80108008:	e8 53 ff ff ff       	call   80107f60 <uva2ka>
    if(pa0 == 0)
8010800d:	83 c4 10             	add    $0x10,%esp
80108010:	85 c0                	test   %eax,%eax
80108012:	75 ac                	jne    80107fc0 <copyout+0x20>
  }
  return 0;
}
80108014:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010801c:	5b                   	pop    %ebx
8010801d:	5e                   	pop    %esi
8010801e:	5f                   	pop    %edi
8010801f:	5d                   	pop    %ebp
80108020:	c3                   	ret    
80108021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010802b:	31 c0                	xor    %eax,%eax
}
8010802d:	5b                   	pop    %ebx
8010802e:	5e                   	pop    %esi
8010802f:	5f                   	pop    %edi
80108030:	5d                   	pop    %ebp
80108031:	c3                   	ret    
