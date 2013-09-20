From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/7] netfilter: ipset: Support comments in hash-type
 ipsets.
Date: Fri, 20 Sep 2013 23:27:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309202319250.28758@blackhole.kfki.hu>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379665825-42563-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:35652 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3ITV1T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:27:19 -0400
In-Reply-To: <1379665825-42563-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This provides kernel support for creating ipsets with comment support.
> 
> This does incur a penalty to flushing/destroying an ipset since all
> entries are walked in order to free the allocated strings, this penalty
> is of course less expensive than the operation of listing an ipset to
> userspace, so for general-purpose usage the overall impact is expected
> to be little to none.

This patch and the one for the bitmap type look all right. However both 
(and the list type) beg for a little simplification:
 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 18 ++++++++++++++----
>  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_net.c       |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  3 ++-
>  8 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 59ae854..eb5b71c 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -701,6 +701,8 @@ reuse_slot:
>  		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
>  	if (SET_WITH_COUNTER(set))
>  		ip_set_init_counter(ext_counter(data, set), ext);
> +	if (SET_WITH_COMMENT(set))
> +		ip_set_init_comment(ext_comment(data, set), ext);
>  
>  out:
>  	rcu_read_unlock_bh();
> @@ -891,6 +893,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  	const struct htable *t;
>  	struct nlattr *nested;
>  	size_t memsize;
> +	u32 cadt_flags = 0;
>  
>  	t = rcu_dereference_bh_nfnl(h->table);
>  	memsize = mtype_ahash_memsize(h, t, NLEN(set->family), set->dsize);
> @@ -910,10 +913,14 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
>  	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
>  	    ((set->extensions & IPSET_EXT_TIMEOUT) &&
> -	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
> -	    ((set->extensions & IPSET_EXT_COUNTER) &&
> -	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
> -			   htonl(IPSET_FLAG_WITH_COUNTERS))))
> +	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))))
> +		goto nla_put_failure;
> +	if (set->extensions & IPSET_EXT_COUNTER)
> +		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
> +	if (set->extensions & IPSET_EXT_COMMENT)
> +		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
> +	if (cadt_flags && nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
> +					htonl(cadt_flags)))

These three lines (and the definition of cadt_flags) should be moved into 
a little inline function in ip_set.h and then that simply called like 
this

	if (ip_set_put_flags(skb, set))
		goto nla_put_failure;

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
