From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Tue, 22 Aug 2006 13:35:27 +0900 (JST)
Message-ID: <200608220435.k7M4ZS33024247@toshiba.co.jp>
References: <44E97335.1080105@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <44E97335.1080105@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 21 Aug 2006 10:47:49 +0200

> [CONNTRACK] Fix race condition in early drop
> 
> On SMP environments the maximum number of conntracks can be overpassed
> under heavy stress situations due to an existing race condition.
> 
>        CPU A                   CPU B
>     atomic_read()               ...
>     early_drop()                ...
>        ...                  atomic_read()
>   allocate conntrack      allocate conntrack
>     atomic_inc()             atomic_inc()
> 
> This patch uses an optimistic approach to solve the concurrency problem.

Good catch!



> Index: net-2.6/net/netfilter/nf_conntrack_core.c
> ===================================================================
> --- net-2.6.orig/net/netfilter/nf_conntrack_core.c	2006-08-18 19:23:19.000000000 +0200
> +++ net-2.6/net/netfilter/nf_conntrack_core.c	2006-08-18 20:20:08.000000000 +0200
> @@ -868,16 +868,26 @@ __nf_conntrack_alloc(const struct nf_con
>  	}
>  
>  	if (nf_conntrack_max
> -	    && atomic_read(&nf_conntrack_count) >= nf_conntrack_max) {
> +	    && !atomic_add_unless(&nf_conntrack_count, 1, nf_conntrack_max)) {
>  		unsigned int hash = hash_conntrack(orig);
>  		/* Try dropping from this hash chain. */
> -		if (!early_drop(&nf_conntrack_hash[hash])) {
> -			if (net_ratelimit())
> -				printk(KERN_WARNING
> -				       "nf_conntrack: table full, dropping"
> -				       " packet.\n");
> -			return ERR_PTR(-ENOMEM);
> -		}
> +		do {
> +			if (!early_drop(&nf_conntrack_hash[hash])) {
> +				if (net_ratelimit())
> +					printk(KERN_WARNING
> +					       "ip_conntrack: table full, "
> +					       "dropping packet.\n");
> +				return ERR_PTR(-ENOMEM);
> +			}
> +			/*
> +			 * On SMP environments, if the table is full and we
> +			 * early drop a conntrack to make some place for this
> +			 * new one then we have to ensure that no other
> +			 * conntrack slips through.
> +			 */
> +		} while (!atomic_add_unless(&nf_conntrack_count, 
> +					    1, 
> +					    nf_conntrack_max));
>  	}

I think there is unfair case like following.

       CPU A                   CPU B
    atomic_add_unless() == 0
    early_drop()                  ...
       ...                     atomic_add_unless() == 1
    atomic_add_unless() == 0
    early_drop()

The right to allocate conntrack is stolen by CPU B in this case.
And there is no assurance that CPU A can exits this loop in short time.

How about incrementing {ip,nf}_conntrack_count at first ?

    1. atomic_add()
    2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
       then early_drop()
    3. if early_drop() failed, atomic_dec()

-- Yasuyuki Kozakai
