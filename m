From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 1/2] ipset: add forceadd kernel support for hash set
 types
Date: Fri, 28 Feb 2014 22:29:45 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402282200310.5807@blackhole.kfki.hu>
References: <1393542286-20955-1-git-send-email-johunt@akamai.com> <1393542286-20955-2-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54879 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaB1V3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:29:50 -0500
In-Reply-To: <1393542286-20955-2-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Josh,

Just a few small things (besides the library version).

On Thu, 27 Feb 2014, Josh Hunt wrote:

> Adds a new property for hash set types, where if a set is created
> with the 'forceadd' option and the set becomes full the next addition
> to the set may succeed and evict a random entry from the set.
> 
> To keep overhead low eviction is done very simply. It checks to see
> which bucket the new entry would be added. If the bucket's pos value
> is non-zero (meaning there's at least one entry in the bucket) it
> replaces the first entry in the bucket. If pos is zero, then it continues
> down the normal add process.
> 
> This property is useful if you have a set for 'ban' lists where it may
> not matter if you release some entries from the set early.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  kernel/include/linux/netfilter/ipset/ip_set.h      |    3 +++
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    3 +++
>  kernel/net/netfilter/ipset/ip_set_core.c           |    4 ++++
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   14 ++++++++++++++
>  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    2 +-
>  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_net.c       |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |    3 ++-
>  kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |    2 +-
>  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |    3 ++-
>  .../net/netfilter/ipset/ip_set_hash_netportnet.c   |    3 ++-
>  14 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
> index 79b13d0..7bb488e 100644
> --- a/kernel/include/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/linux/netfilter/ipset/ip_set.h
> @@ -66,6 +66,7 @@ enum ip_set_extension {
>  #define SET_WITH_TIMEOUT(s)	((s)->extensions & IPSET_EXT_TIMEOUT)
>  #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
>  #define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
> +#define SET_WITH_FORCEADD(s)	((s)->flags & IPSET_CREATE_FLAG_FORCEADD)
>  
>  /* Extension id, in size order */
>  enum ip_set_ext_id {
> @@ -256,6 +257,8 @@ ip_set_put_flags(struct sk_buff *skb, struct ip_set *set)
>  		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
>  	if (SET_WITH_COMMENT(set))
>  		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
> +	if (SET_WITH_FORCEADD(set))
> +		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
>  
>  	if (!cadt_flags)
>  		return 0;
> diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> index b8cc493..10934ca 100644
> --- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -186,12 +186,15 @@ enum ipset_cadt_flags {
>  	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
>  	IPSET_FLAG_BIT_WITH_COMMENT = 4,
>  	IPSET_FLAG_WITH_COMMENT = (1 << IPSET_FLAG_BIT_WITH_COMMENT),
> +	IPSET_FLAG_BIT_WITH_FORCEADD = 5,
> +	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
>  	IPSET_FLAG_CADT_MAX	= 15,
>  };
>  
>  /* The flag bits which correspond to the non-extension create flags */
>  enum ipset_create_flags {
>  	IPSET_CREATE_FLAG_NONE = 0,
> +	IPSET_CREATE_FLAG_FORCEADD = 1,
>  	IPSET_CREATE_FLAG_MAX = 7,
>  };

You should start with the first bit, i.e. replace NONE, and define both 
the bit and the flag:

enum ipset_create_flags {
	IPSET_CREATE_FLAG_BIT_FORCEADD = 0,
	IPSET_CREATE_FLAG_FORCEADD = (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
	IPSET_CREATE_FLAG_BIT_MAX = 7,
};
  
> diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
> index f67350b..22ac236 100644
> --- a/kernel/net/netfilter/ipset/ip_set_core.c
> +++ b/kernel/net/netfilter/ipset/ip_set_core.c
> @@ -374,6 +374,10 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
>  
>  	if (tb[IPSET_ATTR_CADT_FLAGS])
>  		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> +
> +        if (cadt_flags & IPSET_FLAG_WITH_FORCEADD)
> +                set->flags = IPSET_CREATE_FLAG_FORCEADD;
> +

It looks like as if there were unnecessary leading whitespaces here. 
Please check the patches with scripts/checkpatch.pl from the kernel 
source. Also, better use '|=' instead of '=', in order to prevent a bug 
later when an additional flag is introduced.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
