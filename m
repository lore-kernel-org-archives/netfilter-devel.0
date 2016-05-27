From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH -v2 4/6] locking, arch: Update spin_unlock_wait()
Date: Fri, 27 May 2016 08:46:49 +0200
Message-ID: <20160527084649.065c7609@mschwide>
References: <20160526141922.163198062@infradead.org>
	<20160526142354.293350777@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com,
	boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, rth@twiddle.net,
	vgupta@synopsys.com, linux@armlinux.org.uk, realmz6@gmail.com,
	rkuo@codeaurora.org, tony.luck@intel.com, james.hogan@imgtec.com,
	ralf@linux-mips.org, dhowells@redhat.com, jejb@parisc-linux.org,
	mpe@ellerman.id.au, ysato@users.sourceforge.jp,
	cmetcalf@mellanox.com, chris@zankel.net,
	Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160526142354.293350777@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 May 2016 16:19:26 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

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

All that is missing is an smp_rmb(), no? 

> --- a/arch/s390/include/asm/spinlock.h
> +++ b/arch/s390/include/asm/spinlock.h
> @@ -95,8 +95,7 @@ static inline void arch_spin_unlock(arch
> 
>  static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
>  {
> -	while (arch_spin_is_locked(lock))
> -		arch_spin_relax(lock);
> +	smp_cond_load_acquire(&lock->lock, !VAL);
>  }
> 
>  /*

This change adds the smp_rmb() at the end of the waiting loop, but
it also replaces arch_spin_relax() alias arch_lock_relax() with a
cpu_relax(). This is not good, these two functions do *very* different
things. cpu_relax() does an undirected yield with diagnose 0x44 but
only if the system is non-SMT. arch_lock_relax() does an additional
cpu_is_preempted() to test if the target cpu is running and does a
directed yield with diagnose 0x9c. 

Why can't we just add the smp_rmb() to the arch_spin_unlock_wait()?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
