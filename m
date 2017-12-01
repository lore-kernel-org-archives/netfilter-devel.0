From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset nf-next] netfilter: ipset: add resched points during
 set listing
Date: Fri, 1 Dec 2017 20:25:55 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1712012018190.26668@blackhole.kfki.hu>
References: <20171130200805.2895-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:49200 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbdLATZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 14:25:59 -0500
In-Reply-To: <20171130200805.2895-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, 30 Nov 2017, Florian Westphal wrote:

> When sets are extremely large we can get softlockup during ipset -L. We 
> could fix this by adding cond_resched_rcu() at the right location during 
> iteration, but this only works if RCU nesting depth is 1.
> 
> At this time entire variant->list() is called under under 
> rcu_read_lock_bh. This used to be a read_lock_bh() but as rcu doesn't 
> really lock anything, it does not appear to be needed, so remove it 
> (ipset increments set reference count before this, so a set deletion 
> should not be possible).

Yes, the call of rcu_read_lock_bh() seems to be unnecessary, the
set->variant->list() functions protect the sensitive parts with 
rcu_read_lock() anyway. Thanks!

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
 
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipset/ip_set_bitmap_gen.h | 1 +
>  net/netfilter/ipset/ip_set_core.c       | 2 --
>  net/netfilter/ipset/ip_set_hash_gen.h   | 1 +
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
> index 5ca18f07683b5..8afe882f846d5 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@ -227,6 +227,7 @@ mtype_list(const struct ip_set *set,
>  	rcu_read_lock();
>  	for (; cb->args[IPSET_CB_ARG0] < map->elements;
>  	     cb->args[IPSET_CB_ARG0]++) {
> +		cond_resched_rcu();
>  		id = cb->args[IPSET_CB_ARG0];
>  		x = get_ext(set, map, id);
>  		if (!test_bit(id, map->members) ||
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 1f3c03b3bebf2..89b44458a7613 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1388,9 +1388,7 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
>  				set->variant->uref(set, cb, true);
>  			/* fall through */
>  		default:
> -			rcu_read_lock_bh();
>  			ret = set->variant->list(set, skb, cb);
> -			rcu_read_unlock_bh();
>  			if (!cb->args[IPSET_CB_ARG0])
>  				/* Set is done, proceed with next one */
>  				goto next_set;
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index efffc8eabafea..8ef079db7d347 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1143,6 +1143,7 @@ mtype_list(const struct ip_set *set,
>  	rcu_read_lock();
>  	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
>  	     cb->args[IPSET_CB_ARG0]++) {
> +		cond_resched_rcu();
>  		incomplete = skb_tail_pointer(skb);
>  		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
>  		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
