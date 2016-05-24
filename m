From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/3] locking,netfilter: Fix nf_conntrack_lock()
Date: Tue, 24 May 2016 16:42:28 +0200
Message-ID: <20160524144228.GA15189@worktop.bitpit.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.673861121@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160524143649.673861121@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 24, 2016 at 04:27:26PM +0200, Peter Zijlstra wrote:
> nf_conntrack_lock{,_all}() is borken as it misses a bunch of memory
> barriers to order the whole global vs local locks scheme.
> 
> Even x86 (and other TSO archs) are affected.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  net/netfilter/nf_conntrack_core.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -74,7 +74,18 @@ void nf_conntrack_lock(spinlock_t *lock)
>  	spin_lock(lock);
>  	while (unlikely(nf_conntrack_locks_all)) {

And note that we can replace nf_conntrack_locks_all with
spin_is_locked(nf_conntrack_locks_all_lock), since that is the exact
same state.

But I didn't want to do too much in one go.

>  		spin_unlock(lock);
> +		/*
> +		 * Order the nf_contrack_locks_all load vs the spin_unlock_wait()
> +		 * loads below, to ensure locks_all is indeed held.
> +		 */
> +		smp_rmb(); /* spin_lock(locks_all) */
>  		spin_unlock_wait(&nf_conntrack_locks_all_lock);
> +		/*
> +		 * The control dependency's LOAD->STORE order is enough to
> +		 * guarantee the spin_lock() is ordered after the above
> +		 * unlock_wait(). And the ACQUIRE of the lock ensures we are
> +		 * fully ordered against the spin_unlock() of locks_all.
> +		 */
>  		spin_lock(lock);
>  	}
>  }
