From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: review requested - spec for proposed match module
Date: Wed, 25 Dec 2002 00:23:34 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212250823.gBP8NYp05377@isis.cs3-inc.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


This is what I think I'd like.
If it works it might subsume a lot of the current match modules.
Before I try to implement it I submit it for your review.
Please tell me what's wrong with it, how to improve it, etc.
Thanks.
====

U32 tests whether quantities of up to 4 bytes extracted from a packet 
have specified values.  The specification of what to extract is general 
enough to find data at given offsets from tcp headers or payloads.

 --comment string
   This is ignored, used for commenting commands
 --match contents=value
 value := range | range,value
 range := number | number:number
  a single number, n, is interpreted the same as n:n
  n:m is interpreted as the range of numbers >=n and <=m
 contents is a sequence of instructions used to compute another number,
  and the match succeeds iff that number is in any of the value ranges.
 Multiple match arguments are allowed.  All must succeed for the u32 
  match to succeed.
 Numbers are all unsigned decimal or hex (preceded by 0x).

 The machine that interprets contents uses three registers:
  A is of type char*, initially the address of the IP header
  B and C are unsigned 32 bit integers, initially zero

  The instructions are:
   number - B = number;
            C = *(A+B)<<24+*(A+B+1)<<16+*(A+B+2)<<8+*(A+B+3)
   &number - C = C&number
   <<number - C = C<<number
   >>number - C = C>>number
   @ - A = A+C; then do the instruction 0
  Any access of memory outside the packet causes the match to fail.
  Otherwise the result of the computation is the final value of C.

 Note that no whitespace occurs in a --match argument.
 However the characters that do occur there are likely to require
 shell quoting, so it's a good idea to enclose the arguments in quotes.

Example:
 match IP packets with total length >= 256
 The IP header contains a total length field in bytes 2-3.
 --match "0&0xFFFF=0x100:0xFFFF" --comment "ip total length >=256"
 read bytes 0-3
 AND that with FFFF (giving bytes 2-3),
 and test whether that's in the range [100:FFFF] (in hex)

Example: (more realistic, hence more complicated)
 match icmp packets with icmp type 0
 First test that it's an icmp packet, true iff byte 9 (protocol) = 1
 --match "6&0xFF=1" --comment "ip proto = 1 (icmp)"
 read bytes 6-9, use & to throw away bytes 6-8 and compare the result to 1
 Next test that it's not a fragment.
  (If so it might be part of such a packet but we can't always tell.)
  n.b. This test is generally needed if you want to match anything
  beyond the IP header.
 bytes 6-7 are 0 iff this is a complete packet (not a fragment)
 --match "4&0xFFFF=0" --comment "not a fragment"
 Last test: the first byte past the IP header (the type) is 0
 This is where we have to use the @syntax.  The length of the IP header
 (IHL) in 32 bit words is stored in the right half of byte 0 of the
 IP header itself.
 --match "0>>22&0x3C@>>24=0" --comment "icmp type (byte 0) = 0"
 The first 0 means read bytes 0-3,
 >>22 means shift that 22 bits to the right.  Shifting 24 bits would give
   the first byte, so only 22 bits is four times that plus a few more bits.
 &3C then eliminates the two extra bits on the right and the first four 
 bits of the first byte.
 For instance, if IHL=5 then the IP header is 20 (4 x 5) bytes long.
 In this case bytes 0-1 are (in binary) xxxx0101 yyzzzzzz, 
 >>22 gives the 10 bit value xxxx0101yy and &3C gives 010100.
 @ means to use this number as a new offset into the packet, and read
 four bytes starting from there.  This is the first 4 bytes of the icmp
 payload, of which byte 0 is the icmp type.  Therefore we simply shift
 the value 24 to the right to throw out all but the first byte and compare
 the result with 0.

Example: 
 tcp payload bytes 8-12 is any of 1, 2, 5 or 8
 First we test that the packet is a tcp packet (similar to icmp).
 --match "6&0xFF=6" --comment "ip proto = 6 (tcp)"
 Next, test that it's not a fragment (same as above).
 --match "0>>22&0x3C@12>>26&0x3C@8=1,2,5,8"
 0>>22&3C as above computes the number of bytes in the IP header.
 @ makes this the new offset into the packet, which is the start of the
 tcp header.  The length of the tcp header (again in 32 bit words) is
 the left half of byte 12 of the tcp header.  The 12>>26&3C
 computes this length in bytes (similar to the IP header before).
 @ makes this the new offset, which is the start of the tcp payload.
 Finally 8 reads bytes 8-12 of the payload and = checks whether the
 result is any of 1, 2, 5 or 8
