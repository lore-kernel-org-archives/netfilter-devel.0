From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [linux PATCH v2 4/5] netfilter: nft_nat: split code in AF parts
Date: Tue, 1 Jul 2014 13:25:27 +0200
Message-ID: <20140701112527.GA2951@localhost>
References: <20140701104524.6831.83230.stgit@nfdev.cica.es>
 <20140701104653.6831.44100.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaGALZf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:25:35 -0400
Content-Disposition: inline
In-Reply-To: <20140701104653.6831.44100.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 01, 2014 at 12:47:05PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactorices the nft_nat code into AF specific parts,
> allowing further work in the AF specific zones, like adding masquerade support.
> 
> While at it, code style is fixed in several places.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: no changes. Resending.
> 
>  include/net/netfilter/nft_nat.h   |   20 ++++
>  net/ipv4/netfilter/Kconfig        |    7 ++
>  net/ipv4/netfilter/Makefile       |    1 
>  net/ipv4/netfilter/nft_nat_ipv4.c |  140 +++++++++++++++++++++++++++++++
>  net/ipv6/netfilter/Kconfig        |    7 ++
>  net/ipv6/netfilter/Makefile       |    1 
>  net/ipv6/netfilter/nft_nat_ipv6.c |  140 +++++++++++++++++++++++++++++++
>  net/netfilter/nft_nat.c           |  166 ++++---------------------------------
>  8 files changed, 336 insertions(+), 146 deletions(-)
>  create mode 100644 include/net/netfilter/nft_nat.h
>  create mode 100644 net/ipv4/netfilter/nft_nat_ipv4.c
>  create mode 100644 net/ipv6/netfilter/nft_nat_ipv6.c
> 
> diff --git a/include/net/netfilter/nft_nat.h b/include/net/netfilter/nft_nat.h
> new file mode 100644
> index 0000000..d809156
> --- /dev/null
> +++ b/include/net/netfilter/nft_nat.h
> @@ -0,0 +1,20 @@
> +#ifndef _NFT_NAT_H_
> +#define _NFT_NAT_H_
> +
> +struct nft_nat {
> +	enum nft_registers      sreg_addr_min:8;
> +	enum nft_registers      sreg_addr_max:8;
> +	enum nft_registers      sreg_proto_min:8;
> +	enum nft_registers      sreg_proto_max:8;
> +	enum nf_nat_manip_type  type:8;
> +	u8			family;
> +	u32			flags;

You can use u16 flags here, so the priv nft_nat area is just 8 bytes
both in 32 and 64 bits arch.

> +};
> +
> +extern const struct nla_policy nft_nat_policy[];
> +
> +int nft_nat_init(const struct nft_ctx *ctx,
> +		 const struct nft_expr *expr,
> +		 const struct nlattr * const tb[]);
> +
> +#endif /* _NFT_NAT_H_ */
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index f2d2202..6d7355c 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -199,6 +199,13 @@ config NF_NAT_MASQUERADE_IPV4
>  	This is the kernel functionality to provide NAT in the masquerade
>  	flavour (automatic source address selection).
>  
> +config NFT_NAT_IPV4
> +	tristate "nft_nat IPv4 support"
> +	depends on NFT_NAT
> +	select NF_NAT_MASQUERADE_IPV4
> +	help
> +	  This is the nftables expression that handles NAT in IPv4.
> +
>  config IP_NF_TARGET_MASQUERADE
>  	tristate "MASQUERADE target support"
>  	select NF_NAT_MASQUERADE_IPV4
> diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
> index a7bfa0a..1c76c34 100644
> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -32,6 +32,7 @@ obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
>  obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
>  obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
>  obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
> +obj-$(CONFIG_NFT_NAT_IPV4) += nft_nat_ipv4.o
>  obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
>  
>  # generic IP tables 
> diff --git a/net/ipv4/netfilter/nft_nat_ipv4.c b/net/ipv4/netfilter/nft_nat_ipv4.c
> new file mode 100644
> index 0000000..cfbd8ae
> --- /dev/null
> +++ b/net/ipv4/netfilter/nft_nat_ipv4.c
> @@ -0,0 +1,140 @@
> +/*
> + * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
> + * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
> + * Copyright (c) 2012 Intel Corporation
> + * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/skbuff.h>
> +#include <linux/ip.h>
> +#include <linux/string.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter_ipv4.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_nat.h>
> +#include <net/netfilter/nf_nat_core.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_nat_l3proto.h>
> +#include <net/ip.h>
> +#include <net/netfilter/nft_nat.h>
> +#include <net/netfilter/ipv4/nf_nat_masquerade_ipv4.h>
> +
> +static void nft_nat_ipv4_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_nat *priv = nft_expr_priv(expr);
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct = nf_ct_get(pkt->skb, &ctinfo);
> +	struct nf_nat_range range;
> +
> +	memset(&range, 0, sizeof(range));
> +	if (priv->sreg_addr_min) {
> +		range.min_addr.ip =
> +			(__force __be32)data[priv->sreg_addr_min].data[0];
> +		range.max_addr.ip =
> +			(__force __be32)data[priv->sreg_addr_max].data[0];
> +
> +		range.flags |= NF_NAT_RANGE_MAP_IPS;
> +	}
> +
> +	if (priv->sreg_proto_min) {
> +		range.min_proto.all =
> +			(__force __be16)data[priv->sreg_proto_min].data[0];
> +		range.max_proto.all =
> +			(__force __be16)data[priv->sreg_proto_max].data[0];
> +
> +		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> +	}
> +
> +	range.flags |= priv->flags;
> +
> +	data[NFT_REG_VERDICT].verdict =
> +				nf_nat_setup_info(ct, &range, priv->type);
> +}
> +
> +static int nft_nat_ipv4_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{

This function looks exactly the same like in IPv6.

You can save some code by having one single dump function in
net/netfilter/nft_nat.c

> +	const struct nft_nat *priv = nft_expr_priv(expr);
> +
> +	switch (priv->type) {
> +	case NF_NAT_MANIP_SRC:
> +		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_SNAT)))
> +			goto nla_put_failure;
> +		break;
> +	case NF_NAT_MANIP_DST:
> +		if (nla_put_be32(skb, NFTA_NAT_TYPE, htonl(NFT_NAT_DNAT)))
> +			goto nla_put_failure;
> +		break;
> +	}
> +
> +	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(NFPROTO_IPV4)))
> +		goto nla_put_failure;
> +	if (nla_put_be32(skb,
> +			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
> +		goto nla_put_failure;
> +	if (nla_put_be32(skb,
> +			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
> +		goto nla_put_failure;
> +	if (nla_put_be32(skb,
> +			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
> +		goto nla_put_failure;
> +	if (nla_put_be32(skb,
> +			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
> +		goto nla_put_failure;
> +
> +	if (priv->flags != 0) {
> +		if (nla_put_be32(skb, NFTA_NAT_FLAGS, htonl(priv->flags)))
> +			goto nla_put_failure;
> +	}
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
