From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] ipset: add forceadd kernel support for hash set
 types
Date: Fri, 14 Feb 2014 11:06:38 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402140955370.19460@blackhole.kfki.hu>
References: <1391261452-11266-1-git-send-email-johunt@akamai.com> <1391261452-11266-2-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:52191 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaBNKGn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:06:43 -0500
In-Reply-To: <1391261452-11266-2-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Josh,

On Sat, 1 Feb 2014, Josh Hunt wrote:

> Adds a new property for hash set types, where if a set is created
> with the 'forceadd' option and the set becomes full the next addition
> to the set may succeed and evict a random entry from the set.
> 
> To keep overhead low eviction is done very simply. It checks to see
> which bucket the new entry would be added. If the bucket's pos value
> is non-zero (meaning there's at least one entry in the bucket) it
> replaces the first entry in the bucket. If pos is zero, then it continues
> down the normal add process.

I think it's a great feature and the overhead is really low - I'm happy 
to apply it. I have problem only with the implementation on how the single 
flag is handled and passed between userspace and kernel. Please see my 
comments below.
 
> This property is useful if you have a set for 'ban' lists where it may
> not matter if you release some entries from the set early.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    1 +
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   26 ++++++++++++++++++-
>  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    3 +-
>  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_net.c       |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |    4 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |    3 +-
>  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |    4 ++-
>  .../net/netfilter/ipset/ip_set_hash_netportnet.c   |    4 ++-
>  12 files changed, 53 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> index c2bae85..0e1478e 100644
> --- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -95,6 +95,7 @@ enum {
>  	IPSET_ATTR_PROBES,
>  	IPSET_ATTR_RESIZE,
>  	IPSET_ATTR_SIZE,
> +	IPSET_ATTR_FORCEADD,
>  	/* Kernel-only */
>  	IPSET_ATTR_ELEMENTS,
>  	IPSET_ATTR_REFERENCES,

Do not introduce a new attribute just for a flag: there is the 
IPSET_ATTR_CADT_FLAGS attribute for this with a lot of unused bits. So 
please add a new flag to "enum ipset_cadt_flags" instead which is for 
transferring the flag. In order to store it, I added the new "flags" 
member to struct ip_set in a hole in the structure. The corresponding in 
kernel flag should be added to "enum ipset_create_flags" by replacing 
IPSET_CREATE_FLAG_NONE with IPSET_CREATE_FLAG_FORCEADD or something like 
that.

> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index fa259db..b4ca130 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -263,6 +263,7 @@ struct htype {
>  	u32 maxelem;		/* max elements in the hash */
>  	u32 elements;		/* current element (vs timeout) */
>  	u32 initval;		/* random jhash init value */
> +	u8 forceadd;            /* if hash full, attempt to evict one on add */

With the modifications above this is not needed anymore.

>  #ifdef IP_SET_HASH_WITH_MARKMASK
>  	u32 markmask;		/* markmask value for mark mask to store */
>  #endif
> @@ -633,6 +634,19 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	bool flag_exist = flags & IPSET_FLAG_EXIST;
>  	u32 key, multi = 0;
>  
> +        if (h->elements >= h->maxelem && h->forceadd) {

Here you can check whether the in-kernel flag is set in set->flags.

> +                rcu_read_lock_bh();
> +                t = rcu_dereference_bh(h->table);
> +                key = HKEY(value, h->initval, t->htable_bits);
> +                n = hbucket(t,key);
> +                if (n->pos) {
> +                        /* Choosing the first entry in the array to replace */
> +                        j = 0;
> +                        goto reuse_slot;
> +                }
> +                rcu_read_unlock_bh();
> +        }
> +
>  	if (SET_WITH_TIMEOUT(set) && h->elements >= h->maxelem)
>  		/* FIXME: when set is full, we slow down here */
>  		mtype_expire(set, h, NLEN(set->family), set->dsize);
> @@ -923,6 +937,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  		goto nla_put_failure;
>  	if (unlikely(ip_set_put_flags(skb, set)))
>  		goto nla_put_failure;
> +        if ((h->forceadd) && nla_put_u8(skb, IPSET_ATTR_FORCEADD, htonl(h->forceadd)))
> +                goto nla_put_failure;
> +

As it's a flag, please remove this and extend the ip_set_put_flags
function: when the in-kernel flag is set, set the appropriate
new flag from enum ipset_cadt_flags in the IPSET_ATTR_CADT_FLAGS
attribute.

>  	ipset_nest_end(skb, nested);
>  
>  	return 0;
> @@ -1139,9 +1156,14 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>  				IPSET_TOKEN(HTYPE, 6_gc));
>  	}
>  
> -	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
> +        if (tb[IPSET_ATTR_FORCEADD])
> +                h->forceadd = 1;
> +        else
> +                h->forceadd = 0;
> +
> +	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p) forceadd %d\n",
>  		 set->name, jhash_size(t->htable_bits),
> -		 t->htable_bits, h->maxelem, set->data, t);
> +		 t->htable_bits, h->maxelem, set->data, t, h->forceadd);

Remove these too and move the code into ip_set_elem_len (the function
should be better named, I know): if the transport flag is set in
the IPSET_ATTR_CADT_FLAGS attribute, set the corresponding in-kernel flag 
in set->flags.

That way the core handles all the flag handling and converting.

>  
>  	return 0;
>  }
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> index e65fc24..6b97b91 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> @@ -25,7 +25,8 @@
>  
>  #define IPSET_TYPE_REV_MIN	0
>  /*				1	   Counters support */
> -#define IPSET_TYPE_REV_MAX	2	/* Comments support */
> +/*				2	   Comments support */
> +#define IPSET_TYPE_REV_MAX	3	/* Forceadd support */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> @@ -284,6 +285,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
>  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
>  		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
>  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },

The attribute can thus be removed from all hash types.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
