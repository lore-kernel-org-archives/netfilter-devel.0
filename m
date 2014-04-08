From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC 2/3] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Tue, 8 Apr 2014 10:06:42 +0200
Message-ID: <20140408080642.GA3904@localhost>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1395911972-17259-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52145 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbaDHIGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:06:50 -0400
Content-Disposition: inline
In-Reply-To: <1395911972-17259-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Thu, Mar 27, 2014 at 11:19:31AM +0200, Tomasz Bursztyka wrote:
> NFT_META_IBRIFNAME to get packet input bridge interface name
> NFT_META_OBRIFNAME to get packet output bridge interface name
> 
> Such meta key are accessible only through NFPROTO_BRIDGE family, on a
> dedicated nft meta module: nft_meta_bridge.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |   4 +
>  net/bridge/Makefile                      |   1 +
>  net/bridge/netfilter/Kconfig             |  12 ++-
>  net/bridge/netfilter/Makefile            |   1 +
>  net/bridge/netfilter/nft_meta_bridge.c   | 162 +++++++++++++++++++++++++++++++
>  5 files changed, 179 insertions(+), 1 deletion(-)
>  create mode 100644 net/bridge/netfilter/nft_meta_bridge.c
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 83c985a..6b84a2e 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -533,6 +533,8 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECMARK: packet secmark (skb->secmark)
>   * @NFT_META_NFPROTO: netfilter protocol
>   * @NFT_META_L4PROTO: layer 4 protocol number
> + * @NFT_META_BRI_IIFNAME: packet input bridge interface name
> + * @NFT_META_BRI_OIFNAME: packet output bridge interface name
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -552,6 +554,8 @@ enum nft_meta_keys {
>  	NFT_META_SECMARK,
>  	NFT_META_NFPROTO,
>  	NFT_META_L4PROTO,
> +	NFT_META_BRI_IIFNAME,
> +	NFT_META_BRI_OIFNAME,
>  };
>  
>  /**
> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> index e85498b2f..58acd82 100644
> --- a/net/bridge/Makefile
> +++ b/net/bridge/Makefile
> @@ -16,4 +16,5 @@ bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
>  
>  bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o
>  
> +obj-$(CONFIG_NF_TABLES_BRIDGE) += netfilter/
>  obj-$(CONFIG_BRIDGE_NF_EBTABLES) += netfilter/
> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index 5ca74a0..906783d 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -2,10 +2,20 @@
>  # Bridge netfilter configuration
>  #
>  #
> -config NF_TABLES_BRIDGE
> +menuconfig NF_TABLES_BRIDGE
>  	depends on NF_TABLES
>  	tristate "Ethernet Bridge nf_tables support"
>  
> +if NF_TABLES_BRIDGE
> +
> +config NFT_BRIDGE_META
> +	tristate "Netfilter nf_table bridge meta support"
> +	depends on NFT_META
> +	help
> +	  Add support for bridge dedicated meta key.

... like the bridge port name.

> +
> +endif # NF_TABLES_BRIDGE
> +
>  menuconfig BRIDGE_NF_EBTABLES
>  	tristate "Ethernet Bridge tables (ebtables) support"
>  	depends on BRIDGE && NETFILTER
> diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
> index ea7629f..6f2f394 100644
> --- a/net/bridge/netfilter/Makefile
> +++ b/net/bridge/netfilter/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_NF_TABLES_BRIDGE) += nf_tables_bridge.o
> +obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
>  
>  obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
>  
> diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
> new file mode 100644
> index 0000000..411a6b5
> --- /dev/null
> +++ b/net/bridge/netfilter/nft_meta_bridge.c
> @@ -0,0 +1,162 @@
> +/*
> + * Copyright (c) 2012 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nft_meta.h>
> +
> +#include "../br_private.h"
> +
> +static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
> +				     struct nft_data data[NFT_REG_MAX + 1],
> +				     const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_meta *priv = nft_expr_priv(expr);
> +	const struct net_device *in = pkt->in, *out = pkt->out;
> +	struct nft_data *dest = &data[priv->dreg];
> +	const struct net_bridge_port *p;
> +
> +	if (pkt->ops->pf != NFPROTO_BRIDGE)
> +		goto out;

Is this possible or just defensive? I think we only allow the
selection of this expression flavour when the bridge family is used.

> +	switch (priv->key) {
> +	case NFT_META_BRI_IIFNAME:
> +		if (in == NULL || (p = br_port_get_rcu(in)) == NULL)
> +			goto err;
> +		break;
> +	case NFT_META_BRI_OIFNAME:
> +		if (out == NULL || (p = br_port_get_rcu(out)) == NULL)
> +			goto err;
> +		break;
> +	default:
> +		goto out;
> +	}
> +
> +	strncpy((char *)dest->data, p->br->dev->name, sizeof(dest->data));
> +	return;
> +out:
> +	return nft_meta_get_eval(expr, data, pkt);
> +err:
> +	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
> +}
> +
> +static int nft_meta_bridge_init_validate_get(uint32_t key)
> +{
> +	switch (key) {
> +	case NFT_META_BRI_IIFNAME:
> +	case NFT_META_BRI_OIFNAME:
> +		return 0;
> +	default:
> +		break;
> +	}
> +
> +	return nft_meta_init_validate_get(key);
> +}
> +
> +static int nft_meta_bridge_init(const struct nft_ctx *ctx,
> +				const struct nft_expr *expr,
> +				const struct nlattr * const tb[])
> +{
> +	struct nft_meta *priv = nft_expr_priv(expr);
> +	int err;
> +
> +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> +
> +	if (tb[NFTA_META_DREG]) {
> +		err = nft_meta_bridge_init_validate_get(priv->key);
> +		if (err < 0)
> +			return err;
> +
> +		priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
> +		err = nft_validate_output_register(priv->dreg);
> +		if (err < 0)
> +			return err;
> +
> +		return nft_validate_data_load(ctx, priv->dreg, NULL,
> +					      NFT_DATA_VALUE);
> +	}
> +
> +	err = nft_meta_init_validate_set(priv->key);
> +	if (err < 0)
> +		return err;
> +
> +	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
> +	err = nft_validate_input_register(priv->sreg);
> +	if (err < 0)
> +		return err;

Please, also rework this so we have one _init function for the get and
the set variants, ie. nft_meta_bridge_get_init and
nft_meta_bridge_set_init, I'd suggest.

Apart from that, this patch looks fine to me. Thanks.
