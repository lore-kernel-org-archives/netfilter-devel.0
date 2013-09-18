From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/6] netfilter: ipset: Support comments in hash-type
 ipsets.
Date: Wed, 18 Sep 2013 20:03:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309181956470.21599@blackhole.kfki.hu>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379423605-22777-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:43720 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3IRSDo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:03:44 -0400
In-Reply-To: <1379423605-22777-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This provides kernel support for creating ipsets with comment support.
> 
> This does incur a penalty to flushing/destroying an ipset since all
> entries are walked in order to free the allocated strings, this penalty
> is of course less expensive than the operation of listing an ipset to
> userspace, so for general-purpose usage the overall impact is expected
> to be little to none.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 10 +++++++++-
>  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_net.c       |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  3 ++-
>  8 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 4098edc..193aac9 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -710,6 +710,8 @@ reuse_slot:
>  		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
>  	if (SET_WITH_COUNTER(set))
>  		ip_set_init_counter(ext_counter(data, set), ext);
> +	if(SET_WITH_COMMENT(set))
> +		ip_set_init_comment(ext_comment(data, set), ext);
>  
>  out:
>  	rcu_read_unlock_bh();
> @@ -929,7 +931,10 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
>  	    ((set->extensions & IPSET_EXT_COUNTER) &&
>  	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
> -			   htonl(IPSET_FLAG_WITH_COUNTERS))))
> +			   htonl(IPSET_FLAG_WITH_COUNTERS))) ||
> +	    ((set->extensions & IPSET_EXT_COMMENT) &&
> +	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
> +			   htonl(IPSET_FLAG_WITH_COMMENTS))))
>  		goto nla_put_failure;
>  	ipset_nest_end(skb, nested);

The protocol doesn't support returning the IPSET_ATTR_CADT_FLAGS attribute 
multiple times. Initialize the flag and send if not zero, like in the 
*_data_list functions of the hash:*net* types.

The same applies to the bitmap types.

As I see, the extension is missing for the list:set type, please add it 
there too.
  
> @@ -986,6 +991,9 @@ mtype_list(const struct ip_set *set,
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
> index a111ffe..da2433d 100644
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
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
> index 5dc735c..c7a9083 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
> @@ -26,7 +26,8 @@
>  
>  #define IPSET_TYPE_REV_MIN	0
>  /*				1    SCTP and UDPLITE support added */
> -#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
> +/*				2    Counters support added */
> +#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
> index 8c43dc7..cb17d9a 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
> @@ -26,7 +26,8 @@
>  
>  #define IPSET_TYPE_REV_MIN	0
>  /*				1    SCTP and UDPLITE support added */
> -#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
> +/*				2    Counters support added */
> +#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
> index 3489045..071aed7 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
> @@ -28,7 +28,8 @@
>  /*				1    SCTP and UDPLITE support added */
>  /*				2    Range as input support for IPv4 added */
>  /*				3    nomatch flag support added */
> -#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
> +/*				4    Counters support added */
> +#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
> index d559855..7ff21b9 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
> @@ -25,7 +25,8 @@
>  #define IPSET_TYPE_REV_MIN	0
>  /*				1    Range as input support for IPv4 added */
>  /*				2    nomatch flag support added */
> -#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
> +/*				3    Counters support added */
> +#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
> index 26703e9..fb49cb5 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
> @@ -26,7 +26,8 @@
>  #define IPSET_TYPE_REV_MIN	0
>  /*				1    nomatch flag support added */
>  /*				2    /0 support added */
> -#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
> +/*				3    Counters support added */
> +#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
> index 45b6e91..e3e6fd8 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
> @@ -27,7 +27,8 @@
>  /*				1    SCTP and UDPLITE support added */
>  /*				2    Range as input support for IPv4 added */
>  /*				3    nomatch flag support added */
> -#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
> +/*				4    Counters support added */
> +#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> -- 
> 1.8.3.2

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
