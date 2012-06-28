From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/3] ipset: Handle properly an IPSET_CMD_NONE
Date: Thu, 28 Jun 2012 16:40:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1206281639040.14774@blackhole.kfki.hu>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1340888269-4926-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44447 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab2F1Okc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:40:32 -0400
In-Reply-To: <1340888269-4926-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 28 Jun 2012, Tomasz Bursztyka wrote:

> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Never occured to me to send IPSET_CMD_NONE :-).

Best regards,
Jozsef
> ---
>  net/netfilter/ipset/ip_set_core.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 819c342..9730882 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -640,6 +640,14 @@ find_free_id(const char *name, ip_set_id_t *index, struct ip_set **set)
>  }
>  
>  static int
> +ip_set_none(struct sock *ctnl, struct sk_buff *skb,
> +	    const struct nlmsghdr *nlh,
> +	    const struct nlattr * const attr[])
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int
>  ip_set_create(struct sock *ctnl, struct sk_buff *skb,
>  	      const struct nlmsghdr *nlh,
>  	      const struct nlattr * const attr[])
> @@ -1539,6 +1547,10 @@ nlmsg_failure:
>  }
>  
>  static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
> +	[IPSET_CMD_NONE]	= {
> +		.call		= ip_set_none,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +	},
>  	[IPSET_CMD_CREATE]	= {
>  		.call		= ip_set_create,
>  		.attr_count	= IPSET_ATTR_CMD_MAX,
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
