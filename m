From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_pkttype: IPv6 has no broadcast
Date: Mon, 15 Jul 2013 13:16:34 +0200
Message-ID: <20130715111634.GA20907@localhost>
References: <20130711190343.GA25293@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3GOLQi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:16:38 -0400
Content-Disposition: inline
In-Reply-To: <20130711190343.GA25293@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Thu, Jul 11, 2013 at 12:03:43PM -0700, Phil Oester wrote:
> As stated in RFC 4291:
> 
>    There are no broadcast addresses in IPv6, their function being
>    superseded by multicast addresses.
> 
> As such, the pkttype match should not allow IPv6 rules to be added
> which attempt to match broadcast packets.  The addrtype match already
> rejects such attempts.
> 
> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> 
> 
> diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
> index 5b645cb..4c0b0e1 100644
> --- a/net/netfilter/xt_pkttype.c
> +++ b/net/netfilter/xt_pkttype.c
> @@ -42,13 +42,29 @@ pkttype_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	return (type == info->pkttype) ^ info->invert;
>  }
>  
> +static int pkttype_mt_checkentry(const struct xt_mtchk_param *par)
> +{
> +	const struct xt_pkttype_info *info = par->matchinfo;
> +
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +	if (par->family == NFPROTO_IPV6) {
> +		if (info->pkttype == PACKET_BROADCAST) {
> +			pr_err("IPv6 does not support BROADCAST packets\n");
> +			return -EINVAL;
> +		}
> +	}

pkttype is set from the ethernet layer, so it's still possible to
forge a packet using the ethernet broadcast address on IPv6 (even if
it's ilegal), we should allow our users to drop that from ip6tables.

> +#endif
> +	return 0;
> +}
> +
>  static struct xt_match pkttype_mt_reg __read_mostly = {
> -	.name      = "pkttype",
> -	.revision  = 0,
> -	.family    = NFPROTO_UNSPEC,
> -	.match     = pkttype_mt,
> -	.matchsize = sizeof(struct xt_pkttype_info),
> -	.me        = THIS_MODULE,
> +	.name		= "pkttype",
> +	.revision	= 0,
> +	.family		= NFPROTO_UNSPEC,
> +	.checkentry	= pkttype_mt_checkentry,
> +	.match		= pkttype_mt,
> +	.matchsize	= sizeof(struct xt_pkttype_info),
> +	.me		= THIS_MODULE,
>  };
>  
>  static int __init pkttype_mt_init(void)

