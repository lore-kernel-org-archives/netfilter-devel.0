From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Thu, 2 Jun 2016 16:44:24 +0200
Message-ID: <20160602144424.GV3193@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbcFBOpC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 10:45:02 -0400
Content-Disposition: inline
In-Reply-To: <20160602142440.GE30064@insomnia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 10:24:40PM +0800, Boqun Feng wrote:
> On Thu, Jun 02, 2016 at 01:52:02PM +0200, Peter Zijlstra wrote:
> About spin_unlock_wait() on ppc, I actually have a fix pending review:
> 
> http://lkml.kernel.org/r/1461130033-70898-1-git-send-email-boqun.feng@gmail.com

Please use the normal commit quoting style:

  d86b8da04dfa ("arm64: spinlock: serialise spin_unlock_wait against concurrent lockers")

> that patch fixed a different problem when people want to pair a
> spin_unlock_wait() with a spin_lock().

Argh, indeed, and I think qspinlock is still broken there :/ But my poor
brain is about to give in for the day.

Let me go ponder that some :/

> I think we still need that fix, and there are two conflicts with this
> series:
> 
> 1.	arch_spin_unlock_wait() code for PPC32 was deleted, and
> 	consolidated into one.

Nice.

> 2.	I actually downgraded spin_unlock_wait() to !ACQUIRE ;-)

Fail ;-)

> I can think of two ways to solve thoes conflicts:
> 
> 1.	Modify my patch to make spin_unlock_wait() an ACQUIRE, and it
> 	can be merged in powerpc tree, and possible go into to mainline
> 	before 4.7. Then there is no need for this series to have code
> 	for ppc, therefore no conflict.

Hardly any other unlock_wait is an acquire, everyone is 'broken' :-/

> or
> 
> 2.	I can rebase my patch on this series, and it can be added in
> 	this series, and will go into mainline at 4.8.
> 
> 
> Michael and Peter, any thought?

I'm fine with it going in early, I can rebase, no problem.
