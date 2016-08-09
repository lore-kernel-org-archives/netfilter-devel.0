From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_hash: generate Jenkins Hash per source
 register
Date: Tue, 9 Aug 2016 16:22:37 +0200
Message-ID: <20160809142237.GA1652@salvia>
References: <20160809140313.GA6592@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbcHIOWx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 10:22:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4DD471878A7
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:22:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BCC8DA7F9
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:22:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 98DF2FAB50
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 16:22:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160809140313.GA6592@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'd rename the patch title to:

        netfilter: nf_tables: add hash expression

While it is true that we support jenkins initially, we can potentially
extend this to support anything, so let's keep this patch title a bit
more generic.

On Tue, Aug 09, 2016 at 04:03:16PM +0200, Laura Garcia Liebana wrote:
> This patch adds a new hash expression, this provides jhash support but
> this can be extended to support for other hash functions.
> 
> The modulus and seed comes already come embedded into this new
> expression.
> 
> Use case example:
> meta mark set hash ip saddr mod 10
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  20 +++++
>  net/netfilter/Kconfig                    |   6 ++
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_hash.c                 | 134 +++++++++++++++++++++++++++++++
>  4 files changed, 161 insertions(+)
>  create mode 100644 net/netfilter/nft_hash.c
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 0e7928e..5e74c05 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1097,4 +1097,24 @@ enum nft_nth_attributes {
>  };
>  #define NFTA_NTH_MAX	(__NFTA_NTH_MAX - 1)
>  
> +/**
> + * enum nft_hash_attributes - nf_tables hash expression netlink attributes
> + * @NFTA_HASH_UNSPEC: unspecified attribute

We don't document the unspec attribute in other spots, so no need to
include this.

> + * @NFTA_HASH_SREG: source register (NLA_U32)
> + * @NFTA_HASH_DREG: destination register (NLA_U32)
> + * @NFTA_HASH_LEN: source data length (NLA_U32)
> + * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
> + * @NFTA_HASH_SEED: seed value (NLA_U32)
> + */
> +enum nft_hash_attributes {
> +	NFTA_HASH_UNSPEC,
> +	NFTA_HASH_SREG,
> +	NFTA_HASH_DREG,
> +	NFTA_HASH_LEN,
> +	NFTA_HASH_MODULUS,
> +	NFTA_HASH_SEED,
> +	__NFTA_HASH_MAX,
> +};
> +#define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
> +
>  #endif /* _LINUX_NF_TABLES_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index a2e4cf6..f821902 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -480,6 +480,12 @@ config NFT_NTH
>  	  This option adds the "nth" expression that you can use to match a
>  	  packet every a specific given value.

This seems to apply on top of your previous nth patch so it will not
apply in my tree because of this dependency, better place this
description in Kconfig in alphabetical order in Kconfig.

> +config NFT_HASH
> +	tristate "Netfilter nf_tables hash module"
> +	help
> +	  This option adds the "hash" expression that you can use to perform
> +	  a hash operation on registers.
> +
>  config NFT_CT
>  	depends on NF_CONNTRACK
>  	tristate "Netfilter nf_tables conntrack module"
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 441a3c0..fd11c6d 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -81,6 +81,7 @@ obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
>  obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
>  obj-$(CONFIG_NFT_META)		+= nft_meta.o
>  obj-$(CONFIG_NFT_NTH)		+= nft_nth.o
> +obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
>  obj-$(CONFIG_NFT_CT)		+= nft_ct.o
>  obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
>  obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> new file mode 100644
> index 0000000..bb124aa
> --- /dev/null
> +++ b/net/netfilter/nft_hash.c
> @@ -0,0 +1,134 @@
> +/*
> + * Copyright (c) 2016 Laura Garcia <nevola@gmail.com>
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
> +#include <linux/in.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/static_key.h>

I think we don't need these include files above, probably you got them
there from your copy and paste ;-)

> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +#include <linux/jhash.h>
> +
> +struct nft_hash {
> +	enum nft_registers      sreg:8;
> +	enum nft_registers      dreg:8;
> +	u32			len:8;

Better:

        u8                      len;

> +	u32			modulus;
> +	u32			seed;
> +};
> +
> +static void nft_hash_eval(const struct nft_expr *expr,
> +			  struct nft_regs *regs,
> +			  const struct nft_pktinfo *pkt)
> +{
> +	struct nft_hash *priv = nft_expr_priv(expr);
> +	const void *data = &regs->data[priv->sreg];
> +	u32 h;
> +
> +	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
> +
> +	regs->data[priv->dreg] = h;
> +}
> +
> +const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
> +	[NFTA_HASH_SREG]		= { .type = NLA_U32 },
> +	[NFTA_HASH_DREG]		= { .type = NLA_U32 },
> +	[NFTA_HASH_LEN]			= { .type = NLA_U32 },
> +	[NFTA_HASH_MODULUS]		= { .type = NLA_U32 },
> +	[NFTA_HASH_SEED]		= { .type = NLA_U32 },
> +};
> +
> +static int nft_hash_init(const struct nft_ctx *ctx,
> +			 const struct nft_expr *expr,
> +			 const struct nlattr * const tb[])
> +{
> +	struct nft_hash *priv = nft_expr_priv(expr);

        u32 len;

> +
> +	if (!tb[NFTA_HASH_SREG] ||
> +	    !tb[NFTA_HASH_DREG] ||
> +	    !tb[NFTA_HASH_LEN])
> +		return -EINVAL;
> +
> +	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> +	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
> +
> +	priv->len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));

        len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
        if (len == 0 || len > U8_MAX)
                return -EINVAL;

Just to make sure we don't go over the u8 size. I remember we have
this bug in nft_exthdr.c btw, so it would be to add something similar
there too, in case you want to follow up with a patch to address that
thing.
