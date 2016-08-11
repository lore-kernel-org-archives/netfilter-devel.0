From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: nf_tables: add hash expression
Date: Thu, 11 Aug 2016 14:37:21 +0200
Message-ID: <20160811123721.GA2467@salvia>
References: <20160811072311.GA12493@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbcHKMhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 08:37:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D4FD0E976E
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2016 14:37:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C4C20A5B0
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2016 14:37:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC001CE155
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2016 14:37:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160811072311.GA12493@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 11, 2016 at 09:23:14AM +0200, Laura Garcia Liebana wrote:
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> new file mode 100644
> index 0000000..eb05527
> --- /dev/null
> +++ b/net/netfilter/nft_hash.c
> @@ -0,0 +1,136 @@
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
> +
> +	if (!tb[NFTA_HASH_SREG] ||
> +	    !tb[NFTA_HASH_DREG] ||
> +	    !tb[NFTA_HASH_LEN]  ||
> +	    !tb[NFTA_HASH_SEED] ||
> +	    !tb[NFTA_HASH_MODULUS])
> +		return -EINVAL;
> +
> +	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> +	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
> +
> +	len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
> +	if (len == 0 || len > U8_MAX)
> +		return -ERANGE;
> +
> +	priv->len = len;
> +
> +	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
> +	if (priv->modulus <= 1)
> +		return -ERANGE;
> +
> +	priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
> +
> +	return nft_validate_register_load(priv->sreg, len) &&

>From sreg, we load, good.

> +	       nft_validate_register_load(priv->dreg, sizeof(u32));

But to dreg we store. This should validate a store.
