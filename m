From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 25 May 2016 07:29:35 -0700
Message-ID: <20160525142935.GA3789@linux.vnet.ibm.com>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <20160525053930.GC21433@insomnia>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Waiman Long <waiman.long@hpe.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net, will.deacon@arm.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org
To: Boqun Feng <boqun.feng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:40126 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcEYO3j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 10:29:39 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Wed, 25 May 2016 10:29:37 -0400
Content-Disposition: inline
In-Reply-To: <20160525053930.GC21433@insomnia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 25, 2016 at 01:39:30PM +0800, Boqun Feng wrote:
> On Tue, May 24, 2016 at 09:53:29PM -0700, Paul E. McKenney wrote:
> > On Tue, May 24, 2016 at 11:01:21PM -0400, Waiman Long wrote:
> > > On 05/24/2016 10:27 AM, Peter Zijlstra wrote:
> > > >Introduce smp_acquire__after_ctrl_dep(), this construct is not
> > > >uncommen, but the lack of this barrier is.
> > > >
> > > >Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>
> > > >---
> > > >  include/linux/compiler.h |   14 ++++++++++----
> > > >  ipc/sem.c                |   14 ++------------
> > > >  2 files changed, 12 insertions(+), 16 deletions(-)
> > > >
> > > >--- a/include/linux/compiler.h
> > > >+++ b/include/linux/compiler.h
> > > >@@ -305,20 +305,26 @@ static __always_inline void __write_once
> > > >  })
> > > >
> > > >  /**
> > > >+ * smp_acquire__after_ctrl_dep() - Provide ACQUIRE ordering after a control dependency
> > > >+ *
> > > >+ * A control dependency provides a LOAD->STORE order, the additional RMB
> > > >+ * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
> > > >+ * aka. ACQUIRE.
> > > >+ */
> > > >+#define smp_acquire__after_ctrl_dep()		smp_rmb()
> > > >+
> > > >+/**
> > > >   * smp_cond_acquire() - Spin wait for cond with ACQUIRE ordering
> > > >   * @cond: boolean expression to wait for
> > > >   *
> > > >   * Equivalent to using smp_load_acquire() on the condition variable but employs
> > > >   * the control dependency of the wait to reduce the barrier on many platforms.
> > > >   *
> > > >- * The control dependency provides a LOAD->STORE order, the additional RMB
> > > >- * provides LOAD->LOAD order, together they provide LOAD->{LOAD,STORE} order,
> > > >- * aka. ACQUIRE.
> > > >   */
> > > >  #define smp_cond_acquire(cond)	do {		\
> > > >  	while (!(cond))				\
> > > >  		cpu_relax();			\
> > > >-	smp_rmb(); /* ctrl + rmb := acquire */	\
> > > >+	smp_acquire__after_ctrl_dep();		\
> > > >  } while (0)
> > > >
> > > >
> > > 
> > > I have a question about the claim that control dependence + rmb is
> > > equivalent to an acquire memory barrier. For example,
> > > 
> > > S1:    if (a)
> > > S2:       b = 1;
> > >        smp_rmb()
> > > S3:    c = 2;
> > > 
> > > Since c is independent of both a and b, is it possible that the cpu
> > > may reorder to execute store statement S3 first before S1 and S2?
> > 
> > The CPUs I know of won't do, nor should the compiler, at least assuming
> > "a" (AKA "cond") includes READ_ONCE().  Ditto "b" and WRITE_ONCE().
> > Otherwise, the compiler could do quite a few "interesting" things,
> > especially if it knows the value of "b".  For example, if the compiler
> > knows that b==1, without the volatile casts, the compiler could just
> > throw away both S1 and S2, eliminating any ordering.  This can get
> > quite tricky -- see memory-barriers.txt for more mischief.
> > 
> > The smp_rmb() is not needed in this example because S3 is a write, not
> 
> but S3 needs to be an WRITE_ONCE(), right? IOW, the following code can
> result in reordering:
> 
> S1:	if (READ_ONCE(a))
> S2:		WRITE_ONCE(b, 1);
> 	
> S3:	c = 2; // this can be reordered before READ_ONCE(a)
> 
> but if we change S3 to WRITE_ONCE(c, 2), the reordering can not happen
> for the CPUs you are aware of, right?

Yes, if you remove the smp_rmb(), you also need a WRITE_ONCE() for S3.

Even with the smp_rmb(), you have to be careful.

In general, if you don't tell the compiler otherwise, it is within its
rights to assume that nothing else is reading from or writing to the
variables in question.  That means that it can split and fuse loads
and stores.  Or keep some of the variables in registers, so that it
never loads and stores them.  ;-)

							Thanx, Paul

> Regards,
> Boqun
> 
> > a read.  Perhaps you meant something more like this:
> > 
> > 	if (READ_ONCE(a))
> > 		WRITE_ONCE(b, 1);
> > 	smp_rmb();
> > 	r1 = READ_ONCE(c);
> > 
> > This sequence would guarantee that "a" was read before "c".
> > 
> > 							Thanx, Paul
> > 


