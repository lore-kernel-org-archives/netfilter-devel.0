From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 2/2] netfilter: nf_tables: split nft_log in
 AF-specific modules
Date: Mon, 2 Jun 2014 13:36:53 +0200
Message-ID: <20140602113653.GA17123@localhost>
References: <20140602112614.2928.43293.stgit@nfdev.cica.es>
 <20140602112620.2928.42032.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbaFBLhE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:37:04 -0400
Content-Disposition: inline
In-Reply-To: <20140602112620.2928.42032.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 02, 2014 at 01:26:20PM +0200, Arturo Borrero Gonzalez wrote:
> This patch split the nft_log module in AF-specific modules.
> For NFPROTO_INET, it does nothing but dispatch to the AF-specific modules.
>
> Some new symbols are added to Kconfig: NFT_LOG_IPV4, NFT_LOG_IPV6 and
> NFT_LOG_INET.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/net/netfilter/ipv4/nft_log_ipv4.h |    8 +++
>  include/net/netfilter/ipv6/nft_log_ipv6.h |    8 +++
>  include/net/netfilter/nft_log.h           |   16 +++++++
>  net/ipv4/netfilter/Kconfig                |    5 ++
>  net/ipv4/netfilter/Makefile               |    1
>  net/ipv4/netfilter/nft_log_ipv4.c         |   67 ++++++++++++++++++++++++++++
>  net/ipv6/netfilter/Kconfig                |    5 ++
>  net/ipv6/netfilter/Makefile               |    1
>  net/ipv6/netfilter/nft_log_ipv6.c         |   67 ++++++++++++++++++++++++++++
>  net/netfilter/Kconfig                     |    5 ++
>  net/netfilter/Makefile                    |    1
>  net/netfilter/nft_log.c                   |   65 ++++-----------------------
>  net/netfilter/nft_log_inet.c              |   70 +++++++++++++++++++++++++++++
>  13 files changed, 264 insertions(+), 55 deletions(-)
>  create mode 100644 include/net/netfilter/ipv4/nft_log_ipv4.h
>  create mode 100644 include/net/netfilter/ipv6/nft_log_ipv6.h
>  create mode 100644 include/net/netfilter/nft_log.h
>  create mode 100644 net/ipv4/netfilter/nft_log_ipv4.c
>  create mode 100644 net/ipv6/netfilter/nft_log_ipv6.c
>  create mode 100644 net/netfilter/nft_log_inet.c
>
> diff --git a/include/net/netfilter/ipv4/nft_log_ipv4.h b/include/net/netfilter/ipv4/nft_log_ipv4.h
> new file mode 100644
> index 0000000..031eabb
> --- /dev/null
> +++ b/include/net/netfilter/ipv4/nft_log_ipv4.h
> @@ -0,0 +1,8 @@
> +#ifndef _NFT_LOG_IPV4_H_
> +#define _NFT_LOG_IPV4_H_
> +
> +void nft_log_ipv4_eval(const struct nft_expr *expr,
> +		       struct nft_data data[NFT_REG_MAX + 1],
> +		       const struct nft_pktinfo *pkt);
> +
> +#endif /* _NFT_LOG_IPV4_H_ */
> diff --git a/include/net/netfilter/ipv6/nft_log_ipv6.h b/include/net/netfilter/ipv6/nft_log_ipv6.h
> new file mode 100644
> index 0000000..8ed9cd7
> --- /dev/null
> +++ b/include/net/netfilter/ipv6/nft_log_ipv6.h
> @@ -0,0 +1,8 @@
> +#ifndef _NFT_LOG_IPV6_H_
> +#define _NFT_LOG_IPV6_H_
> +
> +void nft_log_ipv6_eval(const struct nft_expr *expr,
> +		       struct nft_data data[NFT_REG_MAX + 1],
> +		       const struct nft_pktinfo *pkt);
> +
> +#endif /* _NFT_LOG_IPV6_H_ */
> diff --git a/include/net/netfilter/nft_log.h b/include/net/netfilter/nft_log.h
> new file mode 100644
> index 0000000..818c289
> --- /dev/null
> +++ b/include/net/netfilter/nft_log.h
> @@ -0,0 +1,16 @@
> +#ifndef _NFT_LOG_H_
> +#define _NFT_LOG_H_
> +
> +struct nft_log {
> +	struct nf_loginfo	loginfo;
> +	char			*prefix;
> +};
> +
> +extern const struct nla_policy nft_log_policy[];
> +
> +int nft_log_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> +		 const struct nlattr * const tb[]);
> +void nft_log_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr);
> +int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr);
> +
> +#endif /* _NFT_LOG_H_ */
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index e09f364..db32b73 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -66,6 +66,11 @@ config NFT_REJECT_IPV4
>  	default NFT_REJECT
>  	tristate
>
> +config NFT_LOG_IPV4
> +	depends on NF_TABLES_IPV4
> +	default NFT_LOG
> +	tristate
> +
>  config NF_TABLES_ARP
>  	depends on NF_TABLES
>  	tristate "ARP nf_tables support"
> diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
> index d2f4b29..1f153e5 100644
> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -31,6 +31,7 @@ obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
>  obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
>  obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
>  obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
> +obj-$(CONFIG_NFT_LOG_IPV4) += nft_log_ipv4.o
>  obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
>
>  # generic IP tables
> diff --git a/net/ipv4/netfilter/nft_log_ipv4.c b/net/ipv4/netfilter/nft_log_ipv4.c
> new file mode 100644
> index 0000000..3b797a3
> --- /dev/null
> +++ b/net/ipv4/netfilter/nft_log_ipv4.c
> @@ -0,0 +1,67 @@
> +/*
> + * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
> + * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/ipv4/nf_log_ipv4.h>
> +#include <linux/netdevice.h>
> +#include <net/netfilter/nft_log.h>
> +
> +void nft_log_ipv4_eval(const struct nft_expr *expr,
> +		       struct nft_data data[NFT_REG_MAX + 1],
> +		       const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_log *priv = nft_expr_priv(expr);
> +	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
> +
> +	nf_log_ip_packet(net, pkt->ops->pf, pkt->ops->hooknum, pkt->skb,
> +			 pkt->in, pkt->out, &priv->loginfo, priv->prefix);
> +}
> +EXPORT_SYMBOL_GPL(nft_log_ipv4_eval);
> +
> +static struct nft_expr_type nft_log_ipv4_type;
> +static const struct nft_expr_ops nft_log_ipv4_ops = {
> +	.type		= &nft_log_ipv4_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_log)),
> +	.eval		= nft_log_ipv4_eval,
> +	.init		= nft_log_init,
> +	.destroy	= nft_log_destroy,
> +	.dump		= nft_log_dump,
> +};
> +
> +static struct nft_expr_type nft_log_ipv4_type __read_mostly = {
> +	.family		= NFPROTO_IPV4,
> +	.name		= "log",
> +	.ops		= &nft_log_ipv4_ops,
> +	.policy		= nft_log_policy,
> +	.maxattr	= NFTA_LOG_MAX,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int __init nft_log_ipv4_module_init(void)
> +{
> +	return nft_register_expr(&nft_log_ipv4_type);
> +}

I think there's some important code missing here:

        nf_log_set(net, NFPROTO_IPV4, &ipt_log_logger);

Otherwise, we still need to modprobe ipt_LOG to enable logging after a
rule that uses the 'log' expression is added.

And this patchset is all about that ;-)
