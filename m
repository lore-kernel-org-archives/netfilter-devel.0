From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Tue, 15 Mar 2016 18:08:13 +0100
Message-ID: <20160315170813.GA25284@salvia>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150AbcCORIZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 13:08:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AEE8F114F54
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:08:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 862FADA392
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:08:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0FB65DA3B2
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 18:08:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458058211-11147-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 05:10:09PM +0100, Florian Westphal wrote:
> Instead of taking the value to set from a source register, userspace
> passes the bit that we should set as a netlink attribute.
> 
> This follows a similar approach that xtables 'connlabel'
> match uses, so when user inputs
> 
>     ct label set bar

I think we can introduce:

        ct label bitset bar

so this is clear to the user this is just setting the bit at that
position.

This is just more infrastructure for this single case, and we've been
trying to avoid adding more complexity for only one single use-case
at this stage.

> then we will set the bit used by the 'bar' label and leave the rest alone.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo, I know its too late for -next, I'm resending this now while
>  this stuff is fresh on my plate -- its unlikely that this will cause
>  merge issues.
> 
>  So if everything is fine I can resubmit once -next opens up again.
> 
>  This takes the different approach you suggested -- pass in the bit we want
>  to set via an extra attribute (no sreg).
> 
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_ct.c                   | 53 ++++++++++++++++++++++++++++++--
>  2 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index eeffde1..12bc116 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -770,6 +770,7 @@ enum nft_ct_keys {
>   * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
>   * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
>   * @NFTA_CT_SREG: source register (NLA_U32)
> + * @NFTA_CT_LABEL: label bit number to set (NLA_U32)
>   */
>  enum nft_ct_attributes {
>  	NFTA_CT_UNSPEC,
> @@ -777,6 +778,7 @@ enum nft_ct_attributes {
>  	NFTA_CT_KEY,
>  	NFTA_CT_DIRECTION,
>  	NFTA_CT_SREG,
> +	NFTA_CT_LABEL,

We can probably add:

        NFTA_CT_IMM

This would be a nested attribute, then inside there we can define the:

        NFTA_CT_LABEL

We'll have NFTA_CT_HELPER soon, we can place this attribute in the
imm nest, or any other one following up.

>  	__NFTA_CT_MAX
>  };
>  #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index d4a4619..76da69d 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -29,6 +29,7 @@ struct nft_ct {
>  		enum nft_registers	dreg:8;
>  		enum nft_registers	sreg:8;
>  	};
> +	u8			set_label_bit;

I understand a specific nft_ct_label is too much at this stage, so:

        union {
                u8                      set_label_bit;
        } imm;

or use something like imm_label_bit for readability.

>  };
>  
>  static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
> @@ -198,6 +199,11 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
>  		}
>  		break;
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS:
> +		nf_connlabel_set(ct, priv->set_label_bit);
> +		break;
> +#endif
>  	default:
>  		break;
>  	}
> @@ -276,6 +282,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
>  		if (tb[NFTA_CT_DIRECTION] != NULL)
>  			return -EINVAL;
>  		len = NF_CT_LABELS_MAX_SIZE;
> +		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
> +		if (err)
> +			return err;
>  		break;
>  #endif
>  	case NFT_CT_HELPER:
> @@ -355,16 +364,39 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
>  			   const struct nlattr * const tb[])
>  {
>  	struct nft_ct *priv = nft_expr_priv(expr);
> -	unsigned int len;
> +	unsigned int len = 0;
>  	int err;
>  
>  	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
>  	switch (priv->key) {
>  #ifdef CONFIG_NF_CONNTRACK_MARK
>  	case NFT_CT_MARK:
> +		if (tb[NFTA_CT_DIRECTION])
> +			return -EINVAL;
>  		len = FIELD_SIZEOF(struct nf_conn, mark);
>  		break;
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	case NFT_CT_LABELS: {
> +		u32 bit;
> +
> +		if (tb[NFTA_CT_DIRECTION] || tb[NFTA_CT_SREG] ||
> +		    tb[NFTA_CT_LABEL] == NULL)
> +			return -EINVAL;
> +
> +		bit = ntohl(nla_get_be32(tb[NFTA_CT_LABEL]));
> +		priv->set_label_bit = (u8)bit;
> +
> +		if (bit > priv->set_label_bit)
> +			return -ERANGE;
> +
> +		err = nf_connlabels_get(ctx->net, bit + 1);
> +		if (err < 0)
> +			return err;
> +
> +		return nft_ct_l3proto_try_module_get(ctx->afi->family);
> +	}
> +#endif
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -384,6 +416,18 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
>  static void nft_ct_destroy(const struct nft_ctx *ctx,
>  			   const struct nft_expr *expr)
>  {
> +	struct nft_ct *priv = nft_expr_priv(expr);
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
>  	nft_ct_l3proto_module_put(ctx->afi->family);
>  }
>  
> @@ -430,6 +474,11 @@ static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  		goto nla_put_failure;
>  	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
>  		goto nla_put_failure;
> +
> +	if (priv->key == NFT_CT_LABELS &&
> +	    nla_put_be32(skb, NFTA_CT_LABEL, htonl(priv->set_label_bit)))
> +		goto nla_put_failure;
> +
>  	return 0;
>  
>  nla_put_failure:
> @@ -468,7 +517,7 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
>  	if (tb[NFTA_CT_DREG])
>  		return &nft_ct_get_ops;
>  
> -	if (tb[NFTA_CT_SREG])
> +	if (tb[NFTA_CT_SREG] || tb[NFTA_CT_LABEL])
>  		return &nft_ct_set_ops;
>  
>  	return ERR_PTR(-EINVAL);
> -- 
> 2.4.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
