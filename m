From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 25 May 2016 08:57:47 -0700
Message-ID: <20160525155747.GE3789@linux.vnet.ibm.com>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, will.deacon@arm.com,
	boqun.feng@gmail.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5745C2CA.4040003@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 25, 2016 at 11:20:42AM -0400, Waiman Long wrote:
> On 05/25/2016 12:53 AM, Paul E. McKenney wrote:
> >On Tue, May 24, 2016 at 11:01:21PM -0400, Waiman Long wrote:
> >>On 05/24/2016 10:27 AM, Peter Zijlstra wrote:
> >>>Introduce smp_acquire__after_ctrl_dep(), this construct is not
> >>>uncommen, but the lack of this barrier is.
> >>>
> >>>Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>
> >>>---
> >>>  include/linux/compiler.h |   14 ++++++++++----
> >>>  ipc/sem.c                |   14 ++------------
> >>>  2 files changed, 12 insertions(+), 16 deletions(-)
> >>>
> >>>--- a/include/linux/compiler.h
> >>>+++ b/include/linux/compiler.h
> >>>@@ -305,20 +305,26 @@ static __always_inline void __write_once
> >>>  })
> >>>
> >>>  /**
> >>>+ * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
> >>>+ *
> >>>+ * A control dependency provides a LOAD->STORE order, the additional RMB
> >>>+ * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
> >>>+ * aka. ACQUIRE.
> >>>+ */
> >>>+#define smp_acquire__after_ctrl_dep()		smp_rmb()
> >>>+
> >>>+/**
> >>>   * smp_cond_acquire() - Spin wait for cond with ACQUIRE ordering
> >>>   * @cond: boolean expression to wait for
> >>>   *
> >>>   * Equivalent to using smp_load_acquire() on the condition variable but employs
> >>>   * the control dependency of the wait to reduce the barrier on many platforms.
> >>>   *
> >>>- * The control dependency provides a LOAD->STORE order, the additional RMB
> >>>- * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
> >>>- * aka. ACQUIRE.
> >>>   */
> >>>  #define smp_cond_acquire(cond)	do {		\
> >>>  	while (!(cond))				\
> >>>  		cpu_relax();			\
> >>>-	smp_rmb(); /* ctrl + rmb := acquire */	\
> >>>+	smp_acquire__after_ctrl_dep();		\
> >>>  } while (0)
> >>>
> >>>
> >>I have a question about the claim that control dependence + rmb is
> >>equivalent to an acquire memory barrier. For example,
> >>
> >>S1:    if (a)
> >>S2:       b = 1;
> >>        smp_rmb()
> >>S3:    c = 2;
> >>
> >>Since c is independent of both a and b, is it possible that the cpu
> >>may reorder to execute store statement S3 first before S1 and S2?
> >The CPUs I know of won't do, nor should the compiler, at least assuming
> >"a" (AKA "cond") includes READ_ONCE().  Ditto "b" and WRITE_ONCE().
> >Otherwise, the compiler could do quite a few "interesting" things,
> >especially if it knows the value of "b".  For example, if the compiler
> >knows that b==1, without the volatile casts, the compiler could just
> >throw away both S1 and S2, eliminating any ordering.  This can get
> >quite tricky -- see memory-barriers.txt for more mischief.
> >
> >The smp_rmb() is not needed in this example because S3 is a write, not
> >a read.  Perhaps you meant something more like this:
> >
> >	if (READ_ONCE(a))
> >		WRITE_ONCE(b, 1);
> >	smp_rmb();
> >	r1 = READ_ONCE(c);
> >
> >This sequence would guarantee that "a" was read before "c".
> 
> The smp_rmb() in Linux should be a compiler barrier. So the compiler
> should not recorder it above smp_rmb. However, what I am wondering
> is whether a condition + rmb combination can be considered a real
> acquire memory barrier from the CPU point of view which requires
> that it cannot reorder the data store in S3 above S1 and S2. This is
> where I am not so sure about.

For your example, but keeping the compiler in check:

	if (READ_ONCE(a))
		WRITE_ONCE(b, 1);
	smp_rmb();
	WRITE_ONCE(c, 2);

On x86, the smp_rmb() is as you say nothing but barrier().  However,
x86's TSO prohibits reordering reads with subsequent writes.  So the
read from "a" is ordered before the write to "c".

On powerpc, the smp_rmb() will be the lwsync instruction plus a compiler
barrier.  This orders prior reads against subsequent reads and writes, so
again the read from "a" will be ordered befoer the write to "c".  But the
ordering against subsequent writes is an accident of implementation.
The real guarantee comes from powerpc's guarantee that stores won't be
speculated, so that the read from "a" is guaranteed to be ordered before
the write to "c" even without the smp_rmb().

On arm, the smp_rmb() is a full memory barrier, so you are good
there.  On arm64, it is the "dmb ishld" instruction, which only orders
reads.  But in both arm and arm64, speculative stores are forbidden,
just as in powerpc.  So in both cases, the load from "a" is ordered
before the store to "c".

Other CPUs are required to behave similarly, but hopefully those
examples help.

But the READ_ONCE() and WRITE_ONCE() are critically important.
The compiler is permitted to play all sorts of tricks if you have
something like this:

	if (a)
		b = 1;
	smp_rmb();
	c = 2;

Here, the compiler is permitted to assume that no other CPU is either
looking at or touching these variables.  After all, you didn't tell
it otherwise!  (Another way of telling it otherwise is through use
of atomics, as in David Howells's earlier patch.)

First, it might decide to place a, b, and c into registers for the
duration.  In that case, the compiler barrier has no effect, and
the compiler is free to rearrange.  (Yes, real compilers are probably
more strict and thus more forgiving of this sort of thing.  But they
are under no obligation to forgive.)

Second, as noted earlier, the compiler might see an earlier load from
or store to "b".  If so, it is permitted to remember the value loaded
or stored, and if that value happened to have been 1, the compiler
is within its rights to drop the "if" statement completely, thus never
loading "a" or storing to "b".

Finally, at least for this email, there is the possibility of load
or store tearing.

Does that help?

							Thanx, Paul
