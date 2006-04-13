From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/2] nf_conntrack: kill nf_ct_cache_mutex
Date: Thu, 13 Apr 2006 21:19:35 +0900 (JST)
Message-ID: <200604131219.k3DCJZTO026135@toshiba.co.jp>
References: <200604131201.k3DC1ZME006314@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <200604131201.k3DC1ZME006314@toshiba.co.jp>
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


Sorry, I cannot do this becase kmem_cache_create() with same name
brings oops instead returning error. Please ignore this.

-- Yasuyuki Kozakai

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 13 Apr 2006 21:01:34 +0900 (JST)

> [NETFILTER] nf_conntrack: kill nf_ct_cache_mutex
> 
> This kills the mutex 'nf_ct_cache_mutex' which prevents creating
> slab caches simultaneously. Instead, the spinlock 'nf_ct_cache_lock' can
> prevent registering them simultaneously.
> 
> The loser to get spinlock have to free slab cache, but it isn't so bad
> because it's rare case that multiple helper are loaded simultaneously.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> 
> ---
> commit 9fdf8935c0caf14b90cd1061ec15e35fcdb85c3d
> tree da3bb945b9704f9843dea2c3d313a7867d43aedc
> parent 4d28baa8a1bdf97cb19dc633624d1a2715ef5d3e
> author <kozakai@camellia.isl.rdc.toshiba.co.jp> Thu, 13 Apr 2006 20:24:27 +0900
> committer <kozakai@camellia.isl.rdc.toshiba.co.jp> Thu, 13 Apr 2006 20:24:27 +0900
> 
>  net/netfilter/nf_conntrack_core.c |   60 +++++++++++++++----------------------
>  1 files changed, 24 insertions(+), 36 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -186,9 +186,6 @@ static struct {
>  /* protect members of nf_ct_cache except of "use" */
>  DEFINE_RWLOCK(nf_ct_cache_lock);
>  
> -/* This avoids calling kmem_cache_create() with same name simultaneously */
> -static DEFINE_MUTEX(nf_ct_cache_mutex);
> -
>  extern struct nf_conntrack_protocol nf_conntrack_generic_protocol;
>  struct nf_conntrack_protocol *
>  __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
> @@ -305,27 +302,6 @@ int nf_conntrack_register_cache(u_int32_
>  		return -EINVAL;
>  	}
>  
> -	mutex_lock(&nf_ct_cache_mutex);
> -
> -	write_lock_bh(&nf_ct_cache_lock);
> -	/* e.g: multiple helpers are loaded */
> -	if (nf_ct_cache[features].use > 0) {
> -		DEBUGP("nf_conntrack_register_cache: already resisterd.\n");
> -		if ((!strncmp(nf_ct_cache[features].name, name,
> -			      NF_CT_FEATURES_NAMELEN))
> -		    && nf_ct_cache[features].size == size) {
> -			DEBUGP("nf_conntrack_register_cache: reusing.\n");
> -			nf_ct_cache[features].use++;
> -			ret = 0;
> -		} else
> -			ret = -EBUSY;
> -
> -		write_unlock_bh(&nf_ct_cache_lock);
> -		mutex_unlock(&nf_ct_cache_mutex);
> -		return ret;
> -	}
> -	write_unlock_bh(&nf_ct_cache_lock);
> -
>  	/*
>  	 * The memory space for name of slab cache must be alive until
>  	 * cache is destroyed.
> @@ -333,8 +309,7 @@ int nf_conntrack_register_cache(u_int32_
>  	cache_name = kmalloc(sizeof(char)*NF_CT_FEATURES_NAMELEN, GFP_ATOMIC);
>  	if (cache_name == NULL) {
>  		DEBUGP("nf_conntrack_register_cache: can't alloc cache_name\n");
> -		ret = -ENOMEM;
> -		goto out_up_mutex;
> +		return -ENOMEM;
>  	}
>  
>  	if (strlcpy(cache_name, name, NF_CT_FEATURES_NAMELEN)
> @@ -344,8 +319,7 @@ int nf_conntrack_register_cache(u_int32_
>  		goto out_free_name;
>  	}
>  
> -	cachep = kmem_cache_create(cache_name, size, 0, 0,
> -				   NULL, NULL);
> +	cachep = kmem_cache_create(cache_name, size, 0, 0, NULL, NULL);
>  	if (!cachep) {
>  		printk("nf_conntrack_register_cache: Can't create slab cache "
