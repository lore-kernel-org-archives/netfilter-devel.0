From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 14:15:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <m37jqmeby9.fsf@averell.firstfloor.org>
References: <2GFBZ-61e-11@gated-at.bofh.it> <2GSfS-6eW-5@gated-at.bofh.it>
	<2H0ZO-49v-13@gated-at.bofh.it> <2HdDL-48z-53@gated-at.bofh.it>
	<2HdNp-4eJ-27@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Marc Ballarin <Ballarin.Marc@gmx.de>,
	Linus Torvalds <torvalds@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S264980AbUIVMTp@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <2HdNp-4eJ-27@gated-at.bofh.it> (Martin Josefsson's message of
 "Wed, 22 Sep 2004 13:50:11 +0200")
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson <gandalf@wlug.westbo.se> writes:

> On Wed, 22 Sep 2004, Richard B. Johnson wrote:
>
>> > Sure, but you have to start somewhere.  Next step will be #error.  Then
>> > finally remove the whole thing (I don't want to remove the whole thing
>> > to start with, since that would create a silent failure).
>> >
>> > Cheers,
>> > Rusty.
>> > --
>>
>> What replaces the firewall stuff? It can't just "go away"!
>
> Ever heard of iptables?

Except that it doesn't have usable 32bit emulation on x86-64.
32bit userland on x86-64 kernel cannot use iptables, they have
to use ipchains.

I would ask for to not drop ipchains until this is fixed.

-Andi
