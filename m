From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 16:50:56 +1000
Message-ID: <4816C550.6080602@snapgear.com>
References: <4816A89B.7050300@snapgear.com>	<20080428.224400.193700589.davem@davemloft.net>	<4816B983.4030906@snapgear.com> <20080428.231414.193695218.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:45351 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbYD2Gu7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:50:59 -0400
In-Reply-To: <20080428.231414.193695218.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
>> eg what does it do for this:
>> 	struct t {
>> 		struct s {
>> 			u16 a;
>> 			u16 b;
>> 		} __attribute__(packed);
>> 	};
> 
> 'a' and 'b' cannot be assumed to be aligned in any particular way,
> and thus byte-at-a-time accesses will be made to them.

Does it ever do anything besides byte access for words on sparc?

Here's my results on ARM, which show that including the packed
struct in another struct allows gcc to assume alignment.
I'm not saying this results in pretty code though :-)


typedef unsigned short u16;
typedef unsigned long u32;

static struct a {
	struct {
		u32 w;
		u16 x;
	} m;
	u16 y;
	u32 z;
} a;

static struct b {
	struct {
		u32 w;
		u16 x;
	} __attribute__ ((packed)) m;
	u16 y;
	u32 z;
} b;

static struct c {
	struct {
		u32 w;
		u16 x;
	} __attribute__ ((packed)) m;
	u16 y;
	u32 z;
} __attribute__ ((packed)) c;

u32 aw(struct a *p)
{
	return p->m.w;
}

u16 ax(struct a *p)
{
	return p->m.x;
}

u16 ay(struct a *p)
{
	return p->y;
}

u32 az(struct a *p)
{
	return p->z;
}

u32 bw(struct b *p)
{
	return p->m.w;
}

u16 bx(struct b *p)
{
	return p->m.x;
}

u16 by(struct b *p)
{
	return p->y;
}

u32 bz(struct b *p)
{
	return p->z;
}

u32 cw(struct c *p)
{
	return p->m.w;
}

u16 cx(struct c *p)
{
	return p->m.x;
}

u16 cy(struct c *p)
{
	return p->y;
}

u32 cz(struct c *p)
{
	return p->z;
}



00000000 <aw>:
   0:	e5900000 	ldr	r0, [r0]
   4:	e1a0f00e 	mov	pc, lr

00000008 <ax>:
   8:	e5d03005 	ldrb	r3, [r0, #5]
   c:	e5d00004 	ldrb	r0, [r0, #4]
  10:	e1800403 	orr	r0, r0, r3, lsl #8
  14:	e1a0f00e 	mov	pc, lr

00000018 <ay>:
  18:	e5d03009 	ldrb	r3, [r0, #9]
  1c:	e5d00008 	ldrb	r0, [r0, #8]
  20:	e1800403 	orr	r0, r0, r3, lsl #8
  24:	e1a0f00e 	mov	pc, lr

00000028 <az>:
  28:	e590000c 	ldr	r0, [r0, #12]
  2c:	e1a0f00e 	mov	pc, lr

00000030 <bw>:
  30:	e5900000 	ldr	r0, [r0]
  34:	e1a0f00e 	mov	pc, lr

00000038 <bx>:
  38:	e5d03005 	ldrb	r3, [r0, #5]
  3c:	e5d00004 	ldrb	r0, [r0, #4]
  40:	e1800403 	orr	r0, r0, r3, lsl #8
  44:	e1a0f00e 	mov	pc, lr

00000048 <by>:
  48:	e5d03007 	ldrb	r3, [r0, #7]
  4c:	e5d00006 	ldrb	r0, [r0, #6]
  50:	e1800403 	orr	r0, r0, r3, lsl #8
  54:	e1a0f00e 	mov	pc, lr

00000058 <bz>:
  58:	e5900008 	ldr	r0, [r0, #8]
  5c:	e1a0f00e 	mov	pc, lr

00000060 <cw>:
  60:	e5d03000 	ldrb	r3, [r0]
  64:	e5d02001 	ldrb	r2, [r0, #1]
  68:	e5d01002 	ldrb	r1, [r0, #2]
  6c:	e1833402 	orr	r3, r3, r2, lsl #8
  70:	e5d00003 	ldrb	r0, [r0, #3]
  74:	e1833801 	orr	r3, r3, r1, lsl #16
  78:	e1830c00 	orr	r0, r3, r0, lsl #24
  7c:	e1a0f00e 	mov	pc, lr

00000080 <cx>:
  80:	e5d03005 	ldrb	r3, [r0, #5]
  84:	e5d00004 	ldrb	r0, [r0, #4]
  88:	e1800403 	orr	r0, r0, r3, lsl #8
  8c:	e1a0f00e 	mov	pc, lr

00000090 <cy>:
  90:	e5d03007 	ldrb	r3, [r0, #7]
  94:	e5d00006 	ldrb	r0, [r0, #6]
  98:	e1800403 	orr	r0, r0, r3, lsl #8
  9c:	e1a0f00e 	mov	pc, lr

000000a0 <cz>:
  a0:	e5d03008 	ldrb	r3, [r0, #8]
  a4:	e5d02009 	ldrb	r2, [r0, #9]
  a8:	e5d0100a 	ldrb	r1, [r0, #10]
  ac:	e1833402 	orr	r3, r3, r2, lsl #8
  b0:	e5d0000b 	ldrb	r0, [r0, #11]
  b4:	e1833801 	orr	r3, r3, r1, lsl #16
  b8:	e1830c00 	orr	r0, r3, r0, lsl #24
  bc:	e1a0f00e 	mov	pc, lr
