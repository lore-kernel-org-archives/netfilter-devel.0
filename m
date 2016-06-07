From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Tue, 7 Jun 2016 14:00:16 +0200
Message-ID: <20160607120016.GG30154@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160606160836.GC30154@twins.programming.kicks-ass.net>
 <20160607114315.GF23133@insomnia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, Waiman.Long@hpe.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbcFGMBX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 08:01:23 -0400
Content-Disposition: inline
In-Reply-To: <20160607114315.GF23133@insomnia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 07, 2016 at 07:43:15PM +0800, Boqun Feng wrote:
> On Mon, Jun 06, 2016 at 06:08:36PM +0200, Peter Zijlstra wrote:
> > diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> > index ce2f75e32ae1..e1c29d352e0e 100644
> > --- a/kernel/locking/qspinlock.c
> > +++ b/kernel/locking/qspinlock.c
> > @@ -395,6 +395,8 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> >  	 * pending stuff.
> >  	 *
> >  	 * p,*,* -> n,*,*
> > +	 *
> > +	 * RELEASE, such that the stores to @node must be complete.
> >  	 */
> >  	old = xchg_tail(lock, tail);
> >  	next = NULL;
> > @@ -405,6 +407,15 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> >  	 */
> >  	if (old & _Q_TAIL_MASK) {
> >  		prev = decode_tail(old);
> > +		/*
> > +		 * The above xchg_tail() is also load of @lock which generates,
> > +		 * through decode_tail(), a pointer.
> > +		 *
> > +		 * The address dependency matches the RELEASE of xchg_tail()
> > +		 * such that the access to @prev must happen after.
> > +		 */
> > +		smp_read_barrier_depends();
> 
> Should this barrier be put before decode_tail()? Because it's the
> dependency old -> prev that we want to protect here.

I don't think it matters one way or the other. The old->prev
transformation is pure; it doesn't depend on any state other than old.

I put it between prev and dereferences of prev, because that's what made
most sense to me; but really anywhere between the load of @old and the
first dereference of @prev is fine I suspect.
