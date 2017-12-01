From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset nf-next] netfilter: ipset: use
 nfnl_mutex_is_locked
Date: Fri, 1 Dec 2017 20:14:48 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1712012013530.26668@blackhole.kfki.hu>
References: <20171130200732.2814-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:52946 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdLATOv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 14:14:51 -0500
In-Reply-To: <20171130200732.2814-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, 30 Nov 2017, Florian Westphal wrote:

> Check that we really hold nfnl mutex here instead of relying on correct
> usage alone.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Yes, it's better this way :-)

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

> ---
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index d5a43cad90f04..1f3c03b3bebf2 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -57,7 +57,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
>  
>  /* When the nfnl mutex is held: */
>  #define ip_set_dereference(p)		\
> -	rcu_dereference_protected(p, 1)
> +	rcu_dereference_protected(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
>  #define ip_set(inst, id)		\
>  	ip_set_dereference((inst)->ip_set_list)[id]
>  
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
