From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v3 4/8] locking, arch: Update spin_unlock_wait()
Date: Wed, 1 Jun 2016 13:37:33 +0200
Message-ID: <20160601113733.GQ3190@twins.programming.kicks-ass.net>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.099477353@infradead.org>
 <20160601112432.GA355@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, boqun.feng@gmail.com,
	Waiman.Long@hpe.com, tj@kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, rth@twiddle.net,
	chris@zankel.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	linux@armlinux.org.uk, ralf@linux-mips.org, mpe@ellerman.id.au,
	vgupta@synopsys.com, rkuo@codeaurora.org, james.hogan@imgtec.com,
	realmz6@gmail.com, tony.luck@intel.com, ysato@users.sourceforge.jp,
	cmetcalf@mellanox.com
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160601112432.GA355@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 01, 2016 at 12:24:32PM +0100, Will Deacon wrote:
> > --- a/arch/arm/include/asm/spinlock.h
> > +++ b/arch/arm/include/asm/spinlock.h
> > @@ -50,8 +50,22 @@ static inline void dsb_sev(void)
> >   * memory.
> >   */
> >  
> > -#define arch_spin_unlock_wait(lock) \
> > -	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
> > +static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
> > +{
> > +	u16 owner = READ_ONCE(lock->tickets.owner);
> > +
> > +	smp_rmb();
> 
> (so you can remove this barrier)

*poof* in a cloud of bit smoke it goes..

> > +	for (;;) {
> > +		arch_spinlock_t tmp = READ_ONCE(*lock);
> > +
> > +		if (tmp.tickets.owner == tmp.tickets.next ||
> > +		    tmp.tickets.owner != owner)
> 
> This is interesting... on arm64, I actually wait until I observe the
> lock being free, but here you also break if the owner has changed, on
> the assumption that an unlock happened and we just didn't explicitly
> see the lock in a free state. Now, what stops the initial read of
> owner being speculated by the CPU at the dawn of time, and this loop
> consequently returning early because at some point (before we called
> arch_spin_unlock_wait) the lock was unlocked?

The user needs to be aware; take for instance the scenario explained
here:

  lkml.kernel.org/r/20160526135406.GK3192@twins.programming.kicks-ass.net

or the PF_EXITING spin_unlock_wait in do_exit.

In both cases we only need to wait for any in-flight critical section
that might not have observed our recent change. Any further critical
sections are guaranteed to have observed our change and will behave
accordingly.

Note that other architectures already had the wait for one ticket
completion (notably x86) semantics.
