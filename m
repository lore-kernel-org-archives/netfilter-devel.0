From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Fri, 3 Jun 2016 14:48:38 +0530
Message-ID: <57514B6E.6010001@synopsys.com>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org> <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com> <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <peterz@infradead.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<manfred@colorfullife.com>, <dave@stgolabs.net>,
	<will.deacon@arm.com>, <boqun.feng@gmail.com>, <tj@kernel.org>,
	<pablo@netfilter.org>, <kaber@trash.net>, <davem@davemloft.net>,
	<oleg@redhat.com>, <netfilter-devel@vger.kernel.org>,
	<sasha.levin@oracle.com>, <hofrat@osadl.org>
To: <paulmck@linux.vnet.ibm.com>, Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160525155747.GE3789@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 25 May 2016 09:27 PM, Paul E. McKenney wrote:
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
> reads.  But in both arm and arm64, speculative stores are forbidden,
> just as in powerpc.  So in both cases, the load from "a" is ordered
> before the store to "c".
> 
> Other CPUs are required to behave similarly, but hopefully those
> examples help.

Sorry for being late to the party - and apologies in advance for naive sounding
questions below: just trying to put this into perspective for ARC.

Is speculative store same as reordering of stores or is it different/more/less ?

So with some form of MOESI, Core0 stores to line0 in Shared state (requiring a
MOESI transactions to Core1) which could be deferred to the very next store to
line1 in exclusive state. So the update of Core0 cache could be reorder and that
in itself is fine (and probably happens all the time). Are we saying that the
issue is if Core1 observes line1 write before line0, then arch is broken.

Ofcourse this specific example is too simple and impossible anyways. For Core1 to
observe the line1 write will itself require another MOESI transaction which will
naturally get behind the first one...

Am I on the right track !

-Vineet
