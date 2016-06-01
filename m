From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH -v3 4/8] locking, arch: Update spin_unlock_wait()
Date: Wed, 1 Jun 2016 12:24:32 +0100
Message-ID: <20160601112432.GA355@arm.com>
References: <20160531094134.606249808@infradead.org>
 <20160531094844.099477353@infradead.org>
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160531094844.099477353@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Peter,

On Tue, May 31, 2016 at 11:41:38AM +0200, Peter Zijlstra wrote:
> This patch updates/fixes all spin_unlock_wait() implementations.
> 
> The update is in semantics; where it previously was only a control
> dependency, we now upgrade to a full load-acquire to match the
> store-release from the spin_unlock() we waited on. This ensures that
> when spin_unlock_wait() returns, we're guaranteed to observe the full
> critical section we waited on.
> 
> This fixes a number of spin_unlock_wait() users that (not
> unreasonably) rely on this.
> 
> I also fixed a number of ticket lock versions to only wait on the
> current lock holder, instead of for a full unlock, as this is
> sufficient.
> 
> Furthermore; again for ticket locks; I added an smp_rmb() in between
> the initial ticket load and the spin loop testing the current value
> because I could not convince myself the address dependency is
> sufficient, esp. if the loads are of different sizes.
> 
> I'm more than happy to remove this smp_rmb() again if people are
> certain the address dependency does indeed work as expected.

You can remove it for arm, since both the accesses are single-copy
atomic so the read-after-read rules apply.

> --- a/arch/arm/include/asm/spinlock.h
> +++ b/arch/arm/include/asm/spinlock.h
> @@ -50,8 +50,22 @@ static inline void dsb_sev(void)
>   * memory.
>   */
>  
> -#define arch_spin_unlock_wait(lock) \
> -	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
> +static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
> +{
> +	u16 owner = READ_ONCE(lock->tickets.owner);
> +
> +	smp_rmb();

(so you can remove this barrier)

> +	for (;;) {
> +		arch_spinlock_t tmp = READ_ONCE(*lock);
> +
> +		if (tmp.tickets.owner == tmp.tickets.next ||
> +		    tmp.tickets.owner != owner)

This is interesting... on arm64, I actually wait until I observe the
lock being free, but here you also break if the owner has changed, on
the assumption that an unlock happened and we just didn't explicitly
see the lock in a free state. Now, what stops the initial read of
owner being speculated by the CPU at the dawn of time, and this loop
consequently returning early because at some point (before we called
arch_spin_unlock_wait) the lock was unlocked?

Will
