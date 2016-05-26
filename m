From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH -v2 4/6] locking, arch: Update spin_unlock_wait()
Date: Thu, 26 May 2016 17:10:36 -0400
Message-ID: <bff5e0b4-c572-cf4c-82fe-a672b8b5fb14@mellanox.com>
References: <20160526141922.163198062@infradead.org>
 <20160526142354.293350777@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <boqun.feng@gmail.com>, <Waiman.Long@hpe.com>, <tj@kernel.org>,
	<pablo@netfilter.org>, <kaber@trash.net>, <davem@davemloft.net>,
	<oleg@redhat.com>, <netfilter-devel@vger.kernel.org>,
	<sasha.levin@oracle.com>, <hofrat@osadl.org>, <rth@twiddle.net>,
	<vgupta@synopsys.com>, <linux@armlinux.org.uk>,
	<realmz6@gmail.com>, <rkuo@codeaurora.org>, <tony.luck@intel.com>,
	<james.hogan@imgtec.com>, <ralf@linux-mips.org>,
	<dhowells@redhat.com>, <jejb@parisc-linux.org>,
	<mpe@ellerman.id.au>, <schwidefsky@de.ibm.com>,
	<ysato@users.sourceforge.jp>, <chris@zankel.net>
To: Peter Zijlstra <peterz@infradead.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<manfred@colorfullife.com>, <dave@stgolabs.net>,
	<paulmck@linux.vnet.ibm.com>, <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160526142354.293350777@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 5/26/2016 10:19 AM, Peter Zijlstra wrote:
> --- a/arch/tile/lib/spinlock_32.c
> +++ b/arch/tile/lib/spinlock_32.c
> @@ -72,10 +72,14 @@ void arch_spin_unlock_wait(arch_spinlock
>   	if (next == curr)
>   		return;
>   
> +	smp_rmb();
> +
>   	/* Wait until the current locker has released the lock. */
>   	do {
>   		delay_backoff(iterations++);
>   	} while (READ_ONCE(lock->current_ticket) == curr);
> +
> +	smp_acquire__after_ctrl_dep();
>   }
>   EXPORT_SYMBOL(arch_spin_unlock_wait);
>   
> --- a/arch/tile/lib/spinlock_64.c
> +++ b/arch/tile/lib/spinlock_64.c
> @@ -72,10 +72,14 @@ void arch_spin_unlock_wait(arch_spinlock
>   	if (arch_spin_next(val) == curr)
>   		return;
>   
> +	smp_rmb();
> +
>   	/* Wait until the current locker has released the lock. */
>   	do {
>   		delay_backoff(iterations++);
>   	} while (arch_spin_current(READ_ONCE(lock->lock)) == curr);
> +
> +	smp_acquire__after_ctrl_dep();
>   }
>   EXPORT_SYMBOL(arch_spin_unlock_wait);

The smp_rmb() are unnecessary for tile.  We READ_ONCE next/curr from the
lock and compare them, so we know the load(s) are complete.  There's no
microarchitectural speculation going on so that's that.  Then we READ_ONCE
the next load on the lock from within the wait loop, so our load/load
ordering is guaranteed.

With that change,

Acked-by: Chris Metcalf <cmetcalf@mellanox.com> [for tile]

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
