From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/7] netfilter: ipset: Support comments in hash-type
 ipsets.
Date: Mon, 23 Sep 2013 14:16:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309231411450.3776@blackhole.kfki.hu>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379876196-46929-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38965 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3IWMQf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:16:35 -0400
In-Reply-To: <1379876196-46929-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 22 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This provides kernel support for creating ipsets with comment support.
> 
> This does incur a penalty to flushing/destroying an ipset since all
> entries are walked in order to free the allocated strings, this penalty
> is of course less expensive than the operation of listing an ipset to
> userspace, so for general-purpose usage the overall impact is expected
> to be little to none.

The patch, together with the one for the bitmap and list types are 
applied, with a modification:
 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 14 ++++++++------
>  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_net.c       |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  4 +++-
>  kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |  1 +
>  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  4 +++-
>  9 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 59ae854..324de2f 100644
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
> @@ -908,12 +910,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  		goto nla_put_failure;
>  #endif
>  	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
> -	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
> -	    ((set->extensions & IPSET_EXT_TIMEOUT) &&
> -	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
> -	    ((set->extensions & IPSET_EXT_COUNTER) &&
> -	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
> -			   htonl(IPSET_FLAG_WITH_COUNTERS))))
> +	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
> +		goto nla_put_failure;
> +	if (unlikely(ip_set_put_flags(skb, set)))
>  		goto nla_put_failure;
>  	ipset_nest_end(skb, nested);
>  
> @@ -970,6 +969,9 @@ mtype_list(const struct ip_set *set,
>  			if (SET_WITH_COUNTER(set) &&
>  			    ip_set_put_counter(skb, ext_counter(e, set)))
>  				goto nla_put_failure;
> +			if (SET_WITH_COMMENT(set) &&
> +			    ip_set_put_comment(skb, ext_comment(e, set)))
> +				goto nla_put_failure;
>  			ipset_nest_end(skb, nested);
>  		}
>  	}
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> index a111ffe..10db2ff 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
> @@ -24,7 +24,8 @@
>  #include <linux/netfilter/ipset/ip_set_hash.h>
>  
>  #define IPSET_TYPE_REV_MIN	0
> -#define IPSET_TYPE_REV_MAX	1	/* Counters support */
> +/*				1	   Counters support */
> +#define IPSET_TYPE_REV_MAX	2	/* Comments support */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> @@ -292,6 +293,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
>  		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
>  		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
>  		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
> +		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },

NLA_STRING is changed everywhere to NLA_NUL_STRING to enforce a NULL 
terminated string in the attribute. ip_set_init_comment uses strlen, so 
better not let it be fooled with non-terminated strings.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
