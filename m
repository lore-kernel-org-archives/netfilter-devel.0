From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] netfilter: ipset: fix netiface set name overflow
Date: Thu, 22 Nov 2012 21:42:44 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211222129510.1514@blackhole.kfki.hu>
References: <1353583966-12402-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39505 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab2KVUmq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:42:46 -0500
In-Reply-To: <1353583966-12402-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, 22 Nov 2012, Florian Westphal wrote:

> attribute is copied to IFNAMSIZ-size stack variable,
> but IFNAMSIZ is smaller than IPSET_MAXNAMELEN.
> 
> Fortunately nfnetlink needs CAP_NET_ADMIN.

Good catch! Pablo, the patch should be applied to the -stable tree down to 
3.2.x.

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef 

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipset/ip_set_hash_netiface.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
> index b9a6338..45a1014 100644
> --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> @@ -793,7 +793,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
>  		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
>  		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
>  		[IPSET_ATTR_IFACE]	= { .type = NLA_NUL_STRING,
> -					    .len = IPSET_MAXNAMELEN - 1 },
> +					    .len  = IFNAMSIZ - 1 },
>  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
>  		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
>  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
> -- 
> 1.7.8.6
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
