From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Fri, 3 Jun 2016 11:38:34 +0200
Message-ID: <20160603093834.GI3190@twins.programming.kicks-ass.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <57514B6E.6010001@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: paulmck@linux.vnet.ibm.com, Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, will.deacon@arm.com,
	boqun.feng@gmail.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57514B6E.6010001@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 03, 2016 at 02:48:38PM +0530, Vineet Gupta wrote:
> On Wednesday 25 May 2016 09:27 PM, Paul E. McKenney wrote:
> > For your example, but keeping the compiler in check:
> > 
> > 	if (READ_ONCE(a))
> > 		WRITE_ONCE(b, 1);
> > 	smp_rmb();
> > 	WRITE_ONCE(c, 2);

So I think it example is broken. The store to @c is not in fact
dependent on the condition of @a.

Something that would match the text below would be:

	while (READ_ONCE(a))
		cpu_relax();
	smp_rmb();
	WRITE_ONCE(c, 2);
	t = READ_ONCE(d);

Where the smp_rmb() then ensures the load of "d" happens after the load
of "a".

> > On x86, the smp_rmb() is as you say nothing but barrier().  However,
> > x86's TSO prohibits reordering reads with subsequent writes.  So the
> > read from "a" is ordered before the write to "c".
> > 
> > On powerpc, the smp_rmb() will be the lwsync instruction plus a compiler
> > barrier.  This orders prior reads against subsequent reads and writes, so
> > again the read from "a" will be ordered befoer the write to "c".  But the
> > ordering against subsequent writes is an accident of implementation.
> > The real guarantee comes from powerpc's guarantee that stores won't be
> > speculated, so that the read from "a" is guaranteed to be ordered before
> > the write to "c" even without the smp_rmb().
> > 
> > On arm, the smp_rmb() is a full memory barrier, so you are good
> > there.  On arm64, it is the "dmb ishld" instruction, which only orders
> > reads.  But in both arm and arm64, speculative stores are forbidden,
> > just as in powerpc.  So in both cases, the load from "a" is ordered
> > before the store to "c".
> > 
> > Other CPUs are required to behave similarly, but hopefully those
> > examples help.

> Sorry for being late to the party - and apologies in advance for naive sounding
> questions below: just trying to put this into perspective for ARC.
> 
> Is speculative store same as reordering of stores or is it different/more/less ?

Different, speculative stores are making stores visible that might not
happen. For example, the branch the store is in will not be taken after
all.

Take Paul's example, if !a but we see b==1 at any point, something is
busted.

So while a core can speculate on the write in so far as that it might
pull the line into exclusive mode, the actual modification must never be
visible until such time that the branch is decided.
