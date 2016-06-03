From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Fri, 3 Jun 2016 05:08:27 -0700
Message-ID: <20160603120827.GT5231@linux.vnet.ibm.com>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, will.deacon@arm.com,
	boqun.feng@gmail.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:58811 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbcFCMI0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2016 08:08:26 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Fri, 3 Jun 2016 08:08:25 -0400
Content-Disposition: inline
In-Reply-To: <20160603093834.GI3190@twins.programming.kicks-ass.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 03, 2016 at 11:38:34AM +0200, Peter Zijlstra wrote:
> On Fri, Jun 03, 2016 at 02:48:38PM +0530, Vineet Gupta wrote:
> > On Wednesday 25 May 2016 09:27 PM, Paul E. McKenney wrote:
> > > For your example, but keeping the compiler in check:
> > > 
> > > 	if (READ_ONCE(a))
> > > 		WRITE_ONCE(b, 1);
> > > 	smp_rmb();
> > > 	WRITE_ONCE(c, 2);
> 
> So I think it example is broken. The store to @c is not in fact
> dependent on the condition of @a.

At first glance, the compiler could pull the write to "c" above the
conditional, but the "memory" constraint in smp_rmb() prevents this.
>From a hardware viewpoint, the write to "c" does depend on the "if",
as the conditional branch does precede that write in execution order.

But yes, this is using smp_rmb() in a very strange way, if that is
what you are getting at.

> Something that would match the text below would be:
> 
> 	while (READ_ONCE(a))
> 		cpu_relax();
> 	smp_rmb();
> 	WRITE_ONCE(c, 2);
> 	t = READ_ONCE(d);
> 
> Where the smp_rmb() then ensures the load of "d" happens after the load
> of "a".

I agree that this is a more natural example.

> > > On x86, the smp_rmb() is as you say nothing but barrier().  However,
> > > x86's TSO prohibits reordering reads with subsequent writes.  So the
> > > read from "a" is ordered before the write to "c".
> > > 
> > > On powerpc, the smp_rmb() will be the lwsync instruction plus a compiler
> > > barrier.  This orders prior reads against subsequent reads and writes, so
> > > again the read from "a" will be ordered befoer the write to "c".  But the
> > > ordering against subsequent writes is an accident of implementation.
> > > The real guarantee comes from powerpc's guarantee that stores won't be
> > > speculated, so that the read from "a" is guaranteed to be ordered before
> > > the write to "c" even without the smp_rmb().
> > > 
> > > On arm, the smp_rmb() is a full memory barrier, so you are good
> > > there.  On arm64, it is the "dmb ishld" instruction, which only orders
> > > reads.  But in both arm and arm64, speculative stores are forbidden,
> > > just as in powerpc.  So in both cases, the load from "a" is ordered
> > > before the store to "c".
> > > 
> > > Other CPUs are required to behave similarly, but hopefully those
> > > examples help.
> 
> > Sorry for being late to the party - and apologies in advance for naive sounding
> > questions below: just trying to put this into perspective for ARC.
> > 
> > Is speculative store same as reordering of stores or is it different/more/less ?
> 
> Different, speculative stores are making stores visible that might not
> happen. For example, the branch the store is in will not be taken after
> all.
> 
> Take Paul's example, if !a but we see b==1 at any point, something is
> busted.
> 
> So while a core can speculate on the write in so far as that it might
> pull the line into exclusive mode, the actual modification must never be
> visible until such time that the branch is decided.

It could even modify the cacheline ahead of time, but if it does do so,
it needs to be prepared to undo that modification if its speculation is
wrong, and it needs to carefully avoid letting any other CPU see the
modification unless/until the speculation proves correct.  And "any
other CPU" includes other hardware threads within that same core!

Some implementations of hardware transactional memory do this sort of
tentative speculative store into their own cache.

							Thanx, Paul

