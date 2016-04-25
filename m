From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 11:35:22 +0100
Message-ID: <20160425103522.GB29560@macbook.localdomain>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54980 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbcDYKf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 06:35:27 -0400
Content-Disposition: inline
In-Reply-To: <1461249284-12114-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.04, Florian Westphal wrote:
> Instead of taking the value to set from a source register, userspace
> passes the bit that we should set as an immediate netlink value.
> 
> This follows a similar approach that xtables 'connlabel'
> match uses, so when user inputs
> 
>     ct label set bar
> 
> then we will set the bit used by the 'bar' label and leave the rest alone.
> Pablo suggested to re-use the immediate attributes already used by
> nft_immediate, nft_bitwise and nft_cmp to re-use as much code as
> possible.
> 
> Just add new NFTA_CT_IMM that contains nested data attributes.
> We can then use nft_data_init and nft_data_dump for this as well.

What's the argument against using immediate and a register?

> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 4f66cb9..a461c3e 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -31,6 +31,15 @@ struct nft_ct_reg {
>  	};
>  };
>  
> +struct nft_ct_imm {
> +	enum nft_ct_keys	key:8;
> +	union {
> +		u8		set_bit;
> +	} imm;
> +	unsigned int		imm_len:8;
> +	struct nft_data		immediate;

Is this really needed? It should be possible to reconstruct from the bit, no? 

> +static void nft_ct_imm_eval(const struct nft_expr *expr,
> +			    struct nft_regs *regs,
> +			    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct_imm *priv = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct)
> +		return;
> +
> +	switch (priv->key) {
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS:
> +		if (nf_connlabel_set(ct, priv->imm.set_bit))
> +			goto err;
> +		break;
> +#endif
> +	default:
> +		break;
> +	}
> +	return;
> +err:
> +	regs->verdict.code = NFT_BREAK;
> +}
> +
>  static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
>  	[NFTA_CT_DREG]		= { .type = NLA_U32 },
>  	[NFTA_CT_KEY]		= { .type = NLA_U32 },
>  	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
>  	[NFTA_CT_SREG]		= { .type = NLA_U32 },
> +	[NFTA_CT_IMM]		= { .type = NLA_NESTED },
>  };
>  
>  static int nft_ct_l3proto_try_module_get(uint8_t family)
> @@ -381,12 +419,78 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
>  	return 0;
>  }
>  
> +static int nft_ct_imm_init(const struct nft_ctx *ctx,
> +			   const struct nft_expr *expr,
> +			   const struct nlattr * const tb[])
> +{
> +	struct nft_ct_imm *priv = nft_expr_priv(expr);
> +	struct nft_data_desc imm_desc = {};
> +	int err;
> +
> +	err = nft_data_init(NULL, &priv->immediate, sizeof(priv->immediate),
> +			    &imm_desc, tb[NFTA_CT_IMM]);
> +	if (err < 0)
> +		return err;
> +
> +	if (imm_desc.type != NFT_DATA_VALUE)
> +		return -EINVAL;
> +
> +	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
> +	if (err < 0)
> +		return err;

What about the inet table?

> +
> +	priv->imm_len = imm_desc.len;
> +	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
> +	switch (priv->key) {
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS:
> +		err = -EINVAL;
> +		if (tb[NFTA_CT_DIRECTION] || priv->imm_len != sizeof(u32))

Why do we need to store imm_len if the size is fixed?

> +			goto err;
> +
> +		err = nf_connlabels_get(ctx->net,
> +					htonl(priv->immediate.data[0]));
> +		if (err < 0)
> +			goto err;
> +
> +		priv->imm.set_bit = htonl(priv->immediate.data[0]);
> +		break;
> +#endif
> +	default:
> +		err = -EOPNOTSUPP;
> +		goto err;
> +	}
> +
> +	return 0;
> + err:
> +	nft_ct_l3proto_module_put(ctx->afi->family);
> +	return err;
> +}
> +
>  static void nft_ct_reg_destroy(const struct nft_ctx *ctx,
>  			       const struct nft_expr *expr)
>  {
>  	nft_ct_l3proto_module_put(ctx->afi->family);
>  }
>  
> +static void nft_ct_imm_destroy(const struct nft_ctx *ctx,
> +			       const struct nft_expr *expr)
> +{
> +	struct nft_ct_imm *priv = nft_expr_priv(expr);
> +
> +	switch (priv->key) {
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS:
> +		nf_connlabels_put(ctx->net);
> +		break;
> +#endif
> +	default:
> +		break;
> +	}
> +
> +	nft_ct_l3proto_module_put(ctx->afi->family);
> +}
> +
>  static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  {
>  	const struct nft_ct_reg *priv = nft_expr_priv(expr);
> @@ -436,6 +540,18 @@ nla_put_failure:
>  	return -1;
>  }
>  
> +static int nft_ct_imm_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_ct_imm *priv = nft_expr_priv(expr);
> +
> +	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
> +		return -1;
> +	if (nft_data_dump(skb, NFTA_CT_IMM, &priv->immediate,
> +			  NFT_DATA_VALUE, priv->imm_len) < 0)
> +		return -1;
> +	return 0;
> +}
> +
>  static struct nft_expr_type nft_ct_type;
>  static const struct nft_expr_ops nft_ct_get_ops = {
>  	.type		= &nft_ct_type,
> @@ -455,6 +571,15 @@ static const struct nft_expr_ops nft_ct_set_ops = {
>  	.dump		= nft_ct_set_dump,
>  };
>  
> +static const struct nft_expr_ops nft_ct_imm_ops = {
> +	.type		= &nft_ct_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct_imm)),
> +	.eval		= nft_ct_imm_eval,
> +	.init		= nft_ct_imm_init,
> +	.destroy	= nft_ct_imm_destroy,
> +	.dump		= nft_ct_imm_dump,
> +};
> +
>  static const struct nft_expr_ops *
>  nft_ct_select_ops(const struct nft_ctx *ctx,
>  		    const struct nlattr * const tb[])
> @@ -465,12 +590,18 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
>  	if (tb[NFTA_CT_DREG] && tb[NFTA_CT_SREG])
>  		return ERR_PTR(-EINVAL);
>  
> +	if (tb[NFTA_CT_SREG] && tb[NFTA_CT_IMM])
> +		return ERR_PTR(-EINVAL);
> +
>  	if (tb[NFTA_CT_DREG])
>  		return &nft_ct_get_ops;
>  
>  	if (tb[NFTA_CT_SREG])
>  		return &nft_ct_set_ops;
>  
> +	if (tb[NFTA_CT_IMM])
> +		return &nft_ct_imm_ops;
> +
>  	return ERR_PTR(-EINVAL);
>  }
>  
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
