From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: nft_numgen: add number generator expression
Date: Thu, 18 Aug 2016 01:07:38 +0200
Message-ID: <20160817230738.GA5980@salvia>
References: <20160817164445.GA29679@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52740 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbcHQXHn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 19:07:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 01507E8E86
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 01:07:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E09A5FF2FE
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 01:07:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7BCCBFF12D
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 01:07:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160817164445.GA29679@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mostly comestic changes, see below.

On Wed, Aug 17, 2016 at 06:44:48PM +0200, Laura Garcia Liebana wrote:
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 6913454..81f22c3 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
>  obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
>  obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
>  obj-$(CONFIG_NFT_META)		+= nft_meta.o
> +obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
>  obj-$(CONFIG_NFT_CT)		+= nft_ct.o
>  obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
>  obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
> diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
> new file mode 100644
> index 0000000..0b44c6a
> --- /dev/null
> +++ b/net/netfilter/nft_numgen.c
> @@ -0,0 +1,193 @@
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
> +#include <linux/static_key.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +
> +static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
> +
> +struct nft_ng_inc {
> +	enum nft_registers      dreg:8;
> +	u32			until;
> +	atomic_t		counter;
> +};
> +
> +struct nft_ng_random {
> +	enum nft_registers      dreg:8;
> +	u32			until;
> +};

It is strange that you mix the code of both methods. I mean, I would
be expecting to see:

struct nft_ng_inc {
        ...
};

static void nft_ng_inc_eval(const struct nft_expr *expr,
			    struct nft_regs *regs,
			    const struct nft_pktinfo *pkt)
{
        ...
}

static int nft_ng_inc_init(const struct nft_ctx *ctx,
			   const struct nft_expr *expr,
			   const struct nlattr * const tb[])
{
        ...
}

And so on, I mean, everything that relates to _inc_ all together.

This makes the code more readable as I don't need to scroll up and
down to see all what refers to the _inc_ mode.

More comments below.

> +static void nft_ng_inc_eval(const struct nft_expr *expr,
> +			    struct nft_regs *regs,
> +			    const struct nft_pktinfo *pkt)
> +{
> +	struct nft_ng_inc *priv = nft_expr_priv(expr);
> +	u32 nval, oval;
> +
> +	do {
> +		oval = atomic_read(&priv->counter);
> +		nval = (oval + 1 < priv->until) ? oval + 1 : 0;
> +	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
> +
> +	memcpy(&regs->data[priv->dreg], &priv->counter, sizeof(u32));
> +}
> +
> +static void nft_ng_random_eval(const struct nft_expr *expr,
> +			       struct nft_regs *regs,
> +			       const struct nft_pktinfo *pkt)
> +{
> +	struct nft_ng_random *priv = nft_expr_priv(expr);
> +	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
> +	u32 p;
> +
> +	p = reciprocal_scale(prandom_u32_state(state), priv->until);
> +
> +	regs->data[priv->dreg] = p;

You can place this in one single line and get rid of p:

        regs->data[priv->dreg] =
                reciprocal_scale(prandom_u32_state(state), priv->until);

> +}
> +
> +const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
> +	[NFTA_NG_DREG]		= { .type = NLA_U32 },
> +	[NFTA_NG_UNTIL]		= { .type = NLA_U32 },
> +	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
> +};
> +
> +static int nft_ng_inc_init(const struct nft_ctx *ctx,
> +			   const struct nft_expr *expr,
> +			   const struct nlattr * const tb[])
> +{
> +	struct nft_ng_inc *priv = nft_expr_priv(expr);
> +
> +	priv->until = ntohl(nla_get_be32(tb[NFTA_NG_UNTIL]));
> +	if (priv->until == 0)
> +		return -EINVAL;
> +
> +	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
> +	atomic_set(&priv->counter, 0);
> +
> +	return nft_validate_register_store(ctx, priv->dreg, NULL,
> +					   NFT_DATA_VALUE, sizeof(u32));
> +}
> +
> +static int nft_ng_random_init(const struct nft_ctx *ctx,
> +			      const struct nft_expr *expr,
> +			      const struct nlattr * const tb[])
> +{
> +	struct nft_ng_random *priv = nft_expr_priv(expr);
> +	u32 len;
> +
> +	priv->until = ntohl(nla_get_be32(tb[NFTA_NG_UNTIL]));

No check for priv->until == 0 here?

> +	prandom_init_once(&nft_numgen_prandom_state);
> +	len = sizeof(u32);

We don't need len here.

> +	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
> +
> +	return nft_validate_register_store(ctx, priv->dreg, NULL,
> +					   NFT_DATA_VALUE, len);
> +}
> +
> +static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
> +		       u32 until, enum nft_ng_types type)
> +{
> +	if (nft_dump_register(skb, NFTA_NG_DREG, dreg))
> +		goto nla_put_failure;
> +	if (nft_dump_register(skb, NFTA_NG_UNTIL, until))
> +		goto nla_put_failure;
> +	if (nft_dump_register(skb, NFTA_NG_TYPE, type))
> +		goto nla_put_failure;
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
> +
> +static int nft_ng_inc_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_ng_inc *priv = nft_expr_priv(expr);
> +
> +	return nft_ng_dump(skb, priv->dreg, priv->until, NFT_NG_INCREMENTAL);
> +}
> +
> +static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_ng_random *priv = nft_expr_priv(expr);
> +
> +	return nft_ng_dump(skb, priv->dreg, priv->until, NFT_NG_RANDOM);
> +}
> +
> +static struct nft_expr_type nft_ng_type;
> +static const struct nft_expr_ops nft_ng_inc_ops = {
> +	.type		= &nft_ng_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ng_inc)),
> +	.eval		= nft_ng_inc_eval,
> +	.init		= nft_ng_inc_init,
> +	.dump		= nft_ng_inc_dump,
> +};
> +
> +static const struct nft_expr_ops nft_ng_random_ops = {
> +	.type		= &nft_ng_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ng_random)),
> +	.eval		= nft_ng_random_eval,
> +	.init		= nft_ng_random_init,
> +	.dump		= nft_ng_random_dump,
> +};
> +
> +static const struct nft_expr_ops *
> +nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
> +{
> +	u32 type;
> +
> +	if (!tb[NFTA_NG_DREG]	||
> +	    !tb[NFTA_NG_UNTIL]	||
> +	    !tb[NFTA_NG_TYPE])
> +		return ERR_PTR(-EINVAL);
> +
> +	type = ntohl(nla_get_be32(tb[NFTA_NG_TYPE]));
> +
> +	if (type == NFT_NG_INCREMENTAL)
> +		return &nft_ng_inc_ops;
> +
> +	if (type == NFT_NG_RANDOM)
> +		return &nft_ng_random_ops;

Better a switch for this?

        switch (type) {
        case NFT_NG_INCREMENTAL:
		return &nft_ng_inc_ops;
        case NFT_NG_RANDOM:
		return &nft_ng_random_ops;
        }

	return ERR_PTR(-EINVAL);

> +
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static struct nft_expr_type nft_ng_type __read_mostly = {
> +	.name		= "numgen",
> +	.select_ops	= &nft_ng_select_ops,
> +	.policy		= nft_ng_policy,
> +	.maxattr	= NFTA_NG_MAX,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int __init nft_ng_module_init(void)
> +{
> +	return nft_register_expr(&nft_ng_type);
> +}
> +
> +static void __exit nft_ng_module_exit(void)
> +{
> +	nft_unregister_expr(&nft_ng_type);
> +}
> +
> +module_init(nft_ng_module_init);
> +module_exit(nft_ng_module_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
> +MODULE_ALIAS_NFT_EXPR("numgen");
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
