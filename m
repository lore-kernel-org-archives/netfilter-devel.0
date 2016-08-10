From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nf_tables: add hash expression
Date: Wed, 10 Aug 2016 20:52:44 +0200
Message-ID: <20160810185244.GA6927@salvia>
References: <20160810094333.GA28920@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbcHJSwy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:52:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 71DEE1EC2C4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:52:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6352E114D67
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:52:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32958114D67
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:52:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160810094333.GA28920@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:43:36AM +0200, Laura Garcia Liebana wrote:
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> new file mode 100644
> index 0000000..d0069eb
> --- /dev/null
> +++ b/net/netfilter/nft_hash.c
> @@ -0,0 +1,141 @@
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
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +#include <linux/jhash.h>
> +
> +struct nft_hash {
> +	enum nft_registers      sreg:8;
> +	enum nft_registers      dreg:8;
> +	u8			len;
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
> +	u32 len;
> +	u32 seed = 0;
> +
> +	if (!tb[NFTA_HASH_SREG] ||
> +	    !tb[NFTA_HASH_DREG] ||
> +	    !tb[NFTA_HASH_LEN]  ||
> +	    !tb[NFTA_HASH_MODULUS])
> +		return -EINVAL;
> +
> +	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> +	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
> +
> +	len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
> +	if (len == 0 || len > U8_MAX)
> +		return -EINVAL;

Use return -ERANGE here so we get in sync with lib/nlattr.c policy
validation, that returns this error for values out of range.

> +
> +	priv->len = len;
> +
> +	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
> +	if (priv->modulus <= 1)
> +		return -EINVAL;

Use return -ERANGE instead.

> +
> +	if (tb[NFTA_HASH_LEN])

typo here, this should be NFTA_HASH_SEED.

> +		seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));

I don't see any benefit from making this optional, worst case
userspace can pass zero to us, right?

> +
> +	priv->seed = seed;
> +
> +	return nft_validate_register_store(ctx, priv->sreg, NULL,

This should be a validate_register_load instead.

> +					   NFT_DATA_VALUE, len) &&
> +		nft_validate_register_store(ctx, priv->dreg, NULL,
               ^
Comestic: If you do this, you have to get this aligned with the line
above tabs and then spaces, ie.

	return nft_validate_register_store(ctx, priv->sreg, NULL,
					   NFT_DATA_VALUE, len) &&
	       nft_validate_register_store(ctx, priv->dreg, NULL,

Anyway, the code above needs a respin.

> +					    NFT_DATA_VALUE, sizeof(u32));
> +}

Thanks.
