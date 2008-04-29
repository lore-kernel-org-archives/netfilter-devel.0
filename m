From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Mon, 28 Apr 2008 23:14:14 -0700 (PDT)
Message-ID: <20080428.231414.193695218.davem@davemloft.net>
References: <4816A89B.7050300@snapgear.com>
	<20080428.224400.193700589.davem@davemloft.net>
	<4816B983.4030906@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: philipc@snapgear.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57010
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbYD2GOP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:14:15 -0400
In-Reply-To: <4816B983.4030906@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Philip Craig <philipc@snapgear.com>
Date: Tue, 29 Apr 2008 16:00:35 +1000

> David Miller wrote:
> > Now these elements cannot be assumed to have any particular
> > alignment, so gcc will emit byte-at-a-time accesses to these
> > elements.
> 
> Ah, so the problem is the __attribute__(packed) removes align
> restrictions for the whole structure, in addition to removing
> padding.
> 
> Is there any way to tell gcc to pack but still align the whole
> thing?

Is there any way to tell ARM not to layout structures in such a silly
way by default? :-)))

> eg what does it do for this:
> 	struct t {
> 		struct s {
> 			u16 a;
> 			u16 b;
> 		} __attribute__(packed);
> 	};

'a' and 'b' cannot be assumed to be aligned in any particular way,
and thus byte-at-a-time accesses will be made to them.

This program:
--------------------
typedef unsigned short u16;
struct t {
	struct s {
		u16 a;
		u16 b;
	} __attribute__((packed)) x;
};
u16 a(struct t *p)
{
	return p->x.a;
}
u16 b(struct t *p)
{
	return p->x.b;
}
--------------------

results in the following on sparc64:

a:
	ldub	[%o0], %g1
	ldub	[%o0+1], %o0
	sllx	%g1, 8, %g1
	jmp	%o7+8
	 or	%o0, %g1, %o0
	.size	a, .-a
	.align 4
	.align 32
	.global b
	.type	b, #function
	.proc	04
b:
	ldub	[%o0+2], %g1
	ldub	[%o0+3], %o0
	sllx	%g1, 8, %g1
	jmp	%o7+8
	 or	%o0, %g1, %o0
	.size	b, .-b
