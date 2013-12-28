From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft kernel PATCH v3] netfilter: nf_tables: nft_meta module
 get/set ops
Date: Sat, 28 Dec 2013 14:05:50 +0100
Message-ID: <20131228130550.GA6411@localhost>
References: <20131226153533.25423.80213.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44404 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab3L1NFz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:05:55 -0500
Content-Disposition: inline
In-Reply-To: <20131226153533.25423.80213.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 26, 2013 at 04:38:01PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds kernel support for the meta expression in get/set flavour.
> The set operation indicates that a given packet has to be set with a property,
> currently one of mark, priority, nftrace.
> The get op is what was currently working: evaluate the given packet property.
> 
> In case of nftrace, the value is always 1. Such behaviour is copied
> from net/netfilter/xt_TRACE.c
> 
> NFTA_META_DREG and NFTA_META_SREG attributes are mutually exclusives.

Applied with minor comestic changes, thanks Arturo!

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v1: initial release of the patch
> v2: address comments from Tomasz in the kernel side: respect the order of the
>     enums. Also, other cleanups.
> v3: use a nftables register to set the given packet value. Drop secmark.
> 
>  include/uapi/linux/netfilter/nf_tables.h |    2 
>  net/netfilter/nft_meta.c                 |  149 +++++++++++++++++++++++++-----
>  2 files changed, 125 insertions(+), 26 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 256d36b..2c38a54 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -553,11 +553,13 @@ enum nft_meta_keys {
>   *
>   * @NFTA_META_DREG: destination register (NLA_U32)
>   * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
> + * @NFTA_META_SREG: source register (NLA_U32)
>   */
>  enum nft_meta_attributes {
>  	NFTA_META_UNSPEC,
>  	NFTA_META_DREG,
>  	NFTA_META_KEY,
> +	NFTA_META_SREG,
>  	__NFTA_META_MAX
>  };
>  #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 8c28220..7008247 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -21,12 +21,15 @@
>  
>  struct nft_meta {
>  	enum nft_meta_keys	key:8;
> -	enum nft_registers	dreg:8;
> +	union {
> +		enum nft_registers	dreg:8;
> +		enum nft_registers	sreg:8;
> +	};
>  };
>  
> -static void nft_meta_eval(const struct nft_expr *expr,
> -			  struct nft_data data[NFT_REG_MAX + 1],
> -			  const struct nft_pktinfo *pkt)
> +static void nft_meta_get_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
>  {
>  	const struct nft_meta *priv = nft_expr_priv(expr);
>  	const struct sk_buff *skb = pkt->skb;
> @@ -132,23 +135,50 @@ err:
>  	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
>  }
>  
> +static void nft_meta_set_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_meta *meta = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +	u32 value = data[meta->sreg].data[0];
> +
> +	switch (meta->key) {
> +	case NFT_META_MARK:
> +		skb->mark = value;
> +		break;
> +	case NFT_META_PRIORITY:
> +		skb->priority = value;
> +		break;
> +	case NFT_META_NFTRACE:
> +		skb->nf_trace = 1;
> +		break;
> +	default:
> +		WARN_ON(1);
> +	}
> +}
> +
>  static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
>  	[NFTA_META_DREG]	= { .type = NLA_U32 },
>  	[NFTA_META_KEY]		= { .type = NLA_U32 },
> +	[NFTA_META_SREG]	= { .type = NLA_U32 },
>  };
>  
> -static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> -			 const struct nlattr * const tb[])
> +static int nft_meta_init_validate_set(uint32_t key)
>  {
> -	struct nft_meta *priv = nft_expr_priv(expr);
> -	int err;
> -
> -	if (tb[NFTA_META_DREG] == NULL ||
> -	    tb[NFTA_META_KEY] == NULL)
> -		return -EINVAL;
> +	switch (key) {
> +	case NFT_META_MARK:
> +	case NFT_META_PRIORITY:
> +	case NFT_META_NFTRACE:
> +		return 0;
> +	default:
> +		return -1;

return -EOPNOTSUPP here instead.

> +	}
> +}
>  
> -	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> -	switch (priv->key) {
> +static int nft_meta_init_validate_get(uint32_t key)
> +{
> +	switch (key) {
>  	case NFT_META_LEN:
>  	case NFT_META_PROTOCOL:
>  	case NFT_META_PRIORITY:
> @@ -167,26 +197,66 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  #ifdef CONFIG_NETWORK_SECMARK
>  	case NFT_META_SECMARK:
>  #endif
> -		break;
> +		return 0;
>  	default:
> -		return -EOPNOTSUPP;
> +		return -1;
>  	}
>  
> -	priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
> -	err = nft_validate_output_register(priv->dreg);
> -	if (err < 0)
> -		return err;
> -	return nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
>  }
>  
> -static int nft_meta_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> +			 const struct nlattr * const tb[])
> +{
> +	struct nft_meta *priv = nft_expr_priv(expr);
> +	int err;
> +
> +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> +
> +	if (tb[NFTA_META_DREG]) {
> +		if (nft_meta_init_validate_get(priv->key) != 0)
> +			return -EOPNOTSUPP;

Just for consistency with similar code in this function.

                err = nft_meta_init_validate_get(...);
                if (err < 0)
                        return err;

> +
> +		priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
> +		err = nft_validate_output_register(priv->dreg);
> +		if (err < 0)
> +			return err;
> +		return nft_validate_data_load(ctx, priv->dreg, NULL,
> +					      NFT_DATA_VALUE);
> +	}
> +
> +	if (nft_meta_init_validate_set(priv->key) != 0)
> +		return -EOPNOTSUPP;
> +
> +	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
> +
> +	return 0;
> +}
> +
> +static int nft_meta_get_dump(struct sk_buff *skb,
> +			     const struct nft_expr *expr)
>  {
>  	const struct nft_meta *priv = nft_expr_priv(expr);
>  
> +	if (nla_put_be32(skb, NFTA_META_KEY, htonl(priv->key)))
> +		goto nla_put_failure;
>  	if (nla_put_be32(skb, NFTA_META_DREG, htonl(priv->dreg)))
>  		goto nla_put_failure;
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
> +
> +static int nft_meta_set_dump(struct sk_buff *skb,
> +			     const struct nft_expr *expr)
> +{
> +	const struct nft_meta *priv = nft_expr_priv(expr);
> +
>  	if (nla_put_be32(skb, NFTA_META_KEY, htonl(priv->key)))
>  		goto nla_put_failure;
> +	if (nla_put_be32(skb, NFTA_META_SREG, htonl(priv->sreg)))
> +		goto nla_put_failure;
> +
>  	return 0;
>  
>  nla_put_failure:
> @@ -194,17 +264,44 @@ nla_put_failure:
>  }
>  
>  static struct nft_expr_type nft_meta_type;
> -static const struct nft_expr_ops nft_meta_ops = {
> +static const struct nft_expr_ops nft_meta_get_ops = {
>  	.type		= &nft_meta_type,
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
> -	.eval		= nft_meta_eval,
> +	.eval		= nft_meta_get_eval,
>  	.init		= nft_meta_init,
> -	.dump		= nft_meta_dump,
> +	.dump		= nft_meta_get_dump,
>  };
>  
> +static const struct nft_expr_ops nft_meta_set_ops = {
> +	.type		= &nft_meta_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
> +	.eval		= nft_meta_set_eval,
> +	.init		= nft_meta_init,
> +	.dump		= nft_meta_set_dump,
> +};
> +
> +static const struct nft_expr_ops *
> +nft_meta_select_ops(const struct nft_ctx *ctx,
> +		    const struct nlattr * const tb[])
> +{
> +	if (!tb[NFTA_META_KEY])
> +		return ERR_PTR(-EINVAL);
> +
> +	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
> +		return ERR_PTR(-EINVAL);
> +
> +	if (tb[NFTA_META_DREG])
> +		return &nft_meta_get_ops;
> +
> +	if (tb[NFTA_META_SREG])
> +		return &nft_meta_set_ops;
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +
>  static struct nft_expr_type nft_meta_type __read_mostly = {
>  	.name		= "meta",
> -	.ops		= &nft_meta_ops,
> +	.select_ops	= &nft_meta_select_ops,
>  	.policy		= nft_meta_policy,
>  	.maxattr	= NFTA_META_MAX,
>  	.owner		= THIS_MODULE,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
