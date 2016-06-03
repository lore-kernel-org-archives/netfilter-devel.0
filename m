From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Fri, 3 Jun 2016 13:47:34 +0100
Message-ID: <20160603124734.GK9915@arm.com>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160602215119.GF3190@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602215119.GF3190@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Peter,

On Thu, Jun 02, 2016 at 11:51:19PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 02, 2016 at 06:57:00PM +0100, Will Deacon wrote:
> > > +++ b/include/asm-generic/qspinlock.h
> > > @@ -28,30 +28,13 @@
> > >   */
> > >  static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
> > >  {
> > > +	/* 
> > > +	 * See queued_spin_unlock_wait().
> > >  	 *
> > > +	 * Any !0 state indicates it is locked, even if _Q_LOCKED_VAL
> > > +	 * isn't immediately observable.
> > >  	 */
> > > -	smp_mb();
> > > +	return !!atomic_read(&lock->val);
> > >  }
> > 
> > I'm failing to keep up here :(
> > 
> > The fast-path code in queued_spin_lock is just an atomic_cmpxchg_acquire.
> > If that's built out of LL/SC instructions, then why don't we need a barrier
> > here in queued_spin_is_locked?
> > 
> > Or is the decision now that only spin_unlock_wait is required to enforce
> > this ordering?
> 
> (warning: long, somewhat rambling, email)

Thanks for taking the time to write this up. Comments inline.

> You're talking about the smp_mb() that went missing?

Right -- I think you still need it.

> So that wasn't the reason that smp_mb() existed..... but that makes the
> atomic_foo_acquire() things somewhat hard to use, because I don't think
> we want to unconditionally put the smp_mb() in there just in case.
> 
> Now, the normal atomic_foo_acquire() stuff uses smp_mb() as per
> smp_mb__after_atomic(), its just ARM64 and PPC that go all 'funny' and
> need this extra barrier. Blergh. So lets shelf this issue for a bit.

Hmm... I certainly plan to get qspinlock up and running for arm64 in the
near future, so I'm not keen on shelving it for very long.

> Let me write some text to hopefully explain where it did come from and
> why I now removed it.
> 
> 
> So the spin_is_locked() correctness issue comes from something like:
> 
> CPU0					CPU1
> 
> global_lock();				local_lock(i)
>   spin_lock(&G)				  spin_lock(&L[i])
>   for (i)				  if (!spin_is_locked(&G)) {
>     spin_unlock_wait(&L[i]);		    smp_acquire__after_ctrl_dep();
> 					    return;
> 					  }
> 					  /* deal with fail */
> 
> Where it is important CPU1 sees G locked or CPU0 sees L[i] locked such
> that there is exclusion between the two critical sections.

Yes, and there's also a version of this where CPU0 is using spin_is_locked
(see 51d7d5205d338 "powerpc: Add smp_mb() to arch_spin_is_locked()").

> The load from spin_is_locked(&G) is constrained by the ACQUIRE from
> spin_lock(&L[i]), and similarly the load(s) from spin_unlock_wait(&L[i])
> are constrained by the ACQUIRE from spin_lock(&G).
> 
> Similarly, later stuff is constrained by the ACQUIRE from CTRL+RMB.
> 
> Given a simple (SC) test-and-set spinlock the above is fairly straight
> forward and 'correct', right?

Well, the same issue that you want to shelve can manifest here with
test-and-set locks too, allowing the spin_is_locked(&G) to be speculated
before the spin_lock(&L[i]) has finished taking the lock on CPU1.

Even ignoring that, I'm not convinced this would work for test-and-set
locks without barriers in unlock_wait and is_locked. For example, a
cut-down version of your test looks like:

CPU0:		CPU1:
LOCK x		LOCK y
Read y		Read x

and you don't want the reads to both return "unlocked".

Even on x86, I think you need a fence here:

X86 lock
{
}
 P0                | P1                ;
 MOV EAX,$1        | MOV EAX,$1        ;
 LOCK XCHG [x],EAX | LOCK XCHG [y],EAX ;
 MOV EBX,[y]       | MOV EBX,[x]       ;
exists
(0:EAX=0 /\ 0:EBX=0 /\ 1:EAX=0 /\ 1:EBX=0)

is permitted by herd.

> Now, the 'problem' with qspinlock is that one possible acquire path goes
> like (there are more, but this is the easiest):
> 
> 	smp_cond_acquire(!(atomic_read(&lock->val) & _Q_LOCKED_MASK));
> 	clear_pending_set_locked(lock);
> 
> And one possible implementation of clear_pending_set_locked() is:
> 
> 	WRITE_ONCE(l->locked_pending, _Q_LOCKED_VAL);
> 
> IOW, we load-acquire the locked byte until its cleared, at which point
> we know the pending byte to be 1. Then we consider the lock owned by us
> and issue a regular unordered store to flip the pending and locked
> bytes.
> 
> Normal mutual exclusion is fine with this, no new pending can happen
> until this store becomes visible at which time the locked byte is
> visibly taken.
> 
> This unordered store however, can be delayed (store buffer) such that
> the loads from spin_unlock_wait/spin_is_locked can pass up before it
> (even on TSO arches).

Right, and this is surprisingly similar to the LL/SC problem imo.

> _IF_ spin_unlock_wait/spin_is_locked only look at the locked byte, this
> is a problem because at that point the crossed store-load pattern
> becomes uncrossed and we loose our guarantee. That is, what used to be:
> 
> 	[S] G.locked = 1	[S] L[i].locked = 1
> 	[MB]			[MB]
> 	[L] L[i].locked		[L] G.locked
> 
> becomes:
> 
> 	[S] G.locked = 1	[S] L[i].locked = 1
> 	[L] L[i].locked		[L] G.locked
> 
> Which we can reorder at will and bad things follow.
> 
> The previous fix for this was to include an smp_mb() in both
> spin_is_locked() and spin_unlock_wait() to restore that ordering.
> 
> 
> So at this point spin_is_locked() looks like:
> 
> 	smp_mb();
> 	while (atomic_read(&lock->val) & _Q_LOCKED_MASK)
> 		cpu_relax();

I have something similar queued for arm64's ticket locks.

> But for spin_unlock_wait() there is a second correctness issue, namely:
> 
> CPU0				CPU1
> 
> flag = set;
> smp_mb();			spin_lock(&l)
> spin_unlock_wait(&l);		if (flag)
> 				  /* bail */
> 
> 				/* add to lockless list */
> 				spin_unlock(&l);
> 
> /* iterate lockless list */
> 
> 
> Which ensures that CPU1 will stop adding bits to the list and CPU0 will
> observe the last entry on the list (if spin_unlock_wait() had ACQUIRE
> semantics etc..)
> 
> This however, is still broken.. nothing ensures CPU0 sees l.locked
> before CPU1 tests flag.

Yup.

> So while we fixed the first correctness case (global / local locking as
> employed by ipc/sem and nf_conntrack) this is still very much broken.
> 
> My patch today rewrites spin_unlock_wait() and spin_is_locked() to rely
> on more information to (hopefully -- I really need sleep) fix both.
> 
> The primary observation is that even though the l.locked store is
> delayed, there has been a prior atomic operation on the lock word to
> register the contending lock (in the above scenario, set the pending
> byte, in the other paths, queue onto the tail word).
> 
> This means that any load passing the .locked byte store, must at least
> observe that state.

That's what I'm not sure about. Just because there was an atomic operation
writing that state, I don't think it means that it's visible to a normal
load.

Will
