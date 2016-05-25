From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 25 May 2016 18:28:29 +0200
Message-ID: <20160525162829.GX3193@twins.programming.kicks-ass.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <waiman.long@hpe.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, will.deacon@arm.com, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160525155747.GE3789@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 25, 2016 at 08:57:47AM -0700, Paul E. McKenney wrote:
> For your example, but keeping the compiler in check:
> 
> 	if (READ_ONCE(a))
> 		WRITE_ONCE(b, 1);
> 	smp_rmb();
> 	WRITE_ONCE(c, 2);
> 
> On x86, the smp_rmb() is as you say nothing but barrier().  However,
> x86's TSO prohibits reordering reads with subsequent writes.  So the
> read from "a" is ordered before the write to "c".
> 
> On powerpc, the smp_rmb() will be the lwsync instruction plus a compiler
> barrier.  This orders prior reads against subsequent reads and writes, so
> again the read from "a" will be ordered befoer the write to "c".  But the
> ordering against subsequent writes is an accident of implementation.
> The real guarantee comes from powerpc's guarantee that stores won't be
> speculated, so that the read from "a" is guaranteed to be ordered before
> the write to "c" even without the smp_rmb().
> 
> On arm, the smp_rmb() is a full memory barrier, so you are good
> there.  On arm64, it is the "dmb ishld" instruction, which only orders
> reads. 

IIRC dmb ishld orders more than load vs load (like the manual states),
but I forgot the details; we'll have to wait for Will to clarify. But
yes, it also orders loads vs loads so it sufficient here.
 
> But in both arm and arm64, speculative stores are forbidden,
> just as in powerpc.  So in both cases, the load from "a" is ordered
> before the store to "c".
> 
> Other CPUs are required to behave similarly, but hopefully those
> examples help.

I would consider any architecture that allows speculative stores as
broken. They are values out of thin air and would make any kind of
concurrency extremely 'interesting'.
