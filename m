From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Sat, 4 Jun 2016 08:29:29 -0700
Message-ID: <20160604152929.GZ5231@linux.vnet.ibm.com>
References: <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
 <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
 <20160603133238.GV5231@linux.vnet.ibm.com>
 <20160603134552.GL9915@arm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Waiman Long <waiman.long@hpe.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, boqun.feng@gmail.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160603134552.GL9915@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 03, 2016 at 02:45:53PM +0100, Will Deacon wrote:
> On Fri, Jun 03, 2016 at 06:32:38AM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 03, 2016 at 02:23:10PM +0200, Peter Zijlstra wrote:
> > > On Fri, Jun 03, 2016 at 05:08:27AM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jun 03, 2016 at 11:38:34AM +0200, Peter Zijlstra wrote:
> > > > > On Fri, Jun 03, 2016 at 02:48:38PM +0530, Vineet Gupta wrote:
> > > > > > On Wednesday 25 May 2016 09:27 PM, Paul E. McKenney wrote:
> > > > > > > For your example, but keeping the compiler in check:
> > > > > > > 
> > > > > > > 	if (READ_ONCE(a))
> > > > > > > 		WRITE_ONCE(b, 1);
> > > > > > > 	smp_rmb();
> > > > > > > 	WRITE_ONCE(c, 2);
> > > > > 
> > > > > So I think it example is broken. The store to @c is not in fact
> > > > > dependent on the condition of @a.
> > > > 
> > > > At first glance, the compiler could pull the write to "c" above the
> > > > conditional, but the "memory" constraint in smp_rmb() prevents this.
> > > > From a hardware viewpoint, the write to "c" does depend on the "if",
> > > > as the conditional branch does precede that write in execution order.
> > > > 
> > > > But yes, this is using smp_rmb() in a very strange way, if that is
> > > > what you are getting at.
> > > 
> > > Well, the CPU could decide that the store to C happens either way around
> > > the branch. I'm not sure I'd rely on CPUs not being _that_ clever.
> > 
> > If I remember correctly, both Power and ARM guarantee that the CPU won't
> > be that clever.  Not sure about Itanium.
> 
> I wouldn't be so sure about ARM. On 32-bit, at least, we have conditional
> store instructions so if the compiler could somehow use one of those for
> the first WRITE_ONCE then there's very obviously no control dependency
> on the second WRITE_ONCE and they could be observed out of order.

OK, good to know...

> I note that smp_rmb() on ARM and arm64 actually orders against subsequent
> (in program order) writes, so this is still pretty theoretical for us.

So the combined control-dependency/smp_rmb() still works, but I should
re-examine the straight control dependency stuff.

								Thanx, Paul
