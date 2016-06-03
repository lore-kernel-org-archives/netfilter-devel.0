From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Fri, 3 Jun 2016 14:27:52 +0200
Message-ID: <20160603122752.GX3205@twins.programming.kicks-ass.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <57514B6E.6010001@synopsys.com>
 <20160603093834.GI3190@twins.programming.kicks-ass.net>
 <20160603120827.GT5231@linux.vnet.ibm.com>
 <20160603122310.GM3190@twins.programming.kicks-ass.net>
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
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160603122310.GM3190@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 03, 2016 at 02:23:10PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 03, 2016 at 05:08:27AM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 03, 2016 at 11:38:34AM +0200, Peter Zijlstra wrote:
> > > On Fri, Jun 03, 2016 at 02:48:38PM +0530, Vineet Gupta wrote:
> > > > On Wednesday 25 May 2016 09:27 PM, Paul E. McKenney wrote:
> > > > > For your example, but keeping the compiler in check:
> > > > > 
> > > > > 	if (READ_ONCE(a))
> > > > > 		WRITE_ONCE(b, 1);
> > > > > 	smp_rmb();
> > > > > 	WRITE_ONCE(c, 2);
> > > 
> > > So I think it example is broken. The store to @c is not in fact
> > > dependent on the condition of @a.
> > 
> > At first glance, the compiler could pull the write to "c" above the
> > conditional, but the "memory" constraint in smp_rmb() prevents this.
> > From a hardware viewpoint, the write to "c" does depend on the "if",
> > as the conditional branch does precede that write in execution order.
> > 
> > But yes, this is using smp_rmb() in a very strange way, if that is
> > what you are getting at.
> 
> Well, the CPU could decide that the store to C happens either way around
> the branch. I'm not sure I'd rely on CPUs not being _that_ clever.
> 
> 	test	%a, $0
> 	jnz	1f
> 	mov	$1, %b
> 1:	mov	$2, %c
> 
> Its not too much to ask the CPU to look ahead 2 instructions to figure
> out the store into c is going to happen unconditionally.
> 
> I would really only rely on stores immediately dependent on the
> conditional.

Ah, interrupts could observe the difference, which is your execution
order constraint. So yes, maybe.

I'm still rather hesitant on this.
