From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Thu, 1 Sep 2016 16:30:39 +0100
Message-ID: <20160901153039.GN6721@arm.com>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 01, 2016 at 05:27:52PM +0200, Manfred Spraul wrote:
> Since spin_unlock_wait() is defined as equivalent to spin_lock();
> spin_unlock(), the memory barrier before spin_unlock_wait() is
> also not required.
> 
> Not for stable!
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: netfilter-devel@vger.kernel.org
> ---
>  net/netfilter/nf_conntrack_core.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 7a3b5e6..0591a25 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -139,13 +139,7 @@ static void nf_conntrack_all_lock(void)
>  
>  	spin_lock(&nf_conntrack_locks_all_lock);
>  
> -	/*
> -	 * Order the store of 'nf_conntrack_locks_all' against
> -	 * the spin_unlock_wait() loads below, such that if
> -	 * nf_conntrack_lock() observes 'nf_conntrack_locks_all'
> -	 * we must observe nf_conntrack_locks[] held:
> -	 */
> -	smp_store_mb(nf_conntrack_locks_all, true);
> +	nf_conntrack_locks_all = true;

Don't you at least need WRITE_ONCE if you're going to do this?

Will
