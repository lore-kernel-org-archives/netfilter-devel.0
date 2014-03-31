From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/3] netfilter: nft_meta: split nft_meta_init() into two
 functions for get/set
Date: Mon, 31 Mar 2014 15:37:43 +0300
Message-ID: <53396197.20809@linux.intel.com>
References: <1396089783-3984-1-git-send-email-kaber@trash.net> <1396089783-3984-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaCaMhr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:37:47 -0400
In-Reply-To: <1396089783-3984-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 425cf39..6d0b8cc2 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -170,21 +170,15 @@ static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
>   	[NFTA_META_SREG]	= { .type = NLA_U32 },
>   };
>   
> -static int nft_meta_init_validate_set(uint32_t key)
> +static int nft_meta_get_init(const struct nft_ctx *ctx,
> +			     const struct nft_expr *expr,
> +			     const struct nlattr * const tb[])
>   {
> -	switch (key) {
> -	case NFT_META_MARK:
> -	case NFT_META_PRIORITY:
> -	case NFT_META_NFTRACE:
> -		return 0;
> -	default:
> -		return -EOPNOTSUPP;
> -	}
> -}
> +	struct nft_meta *priv = nft_expr_priv(expr);
> +	int err;
>   
> -static int nft_meta_init_validate_get(uint32_t key)
> -{
> -	switch (key) {

With the disappearance of nft_meta_init_validate_get(), I will need to add
an #ifdef/#endif clause for bridge key support. Or I would copy and adapt
this new nft_meta_get_init() in nft_meta_bridge.c.

Don't you think nft_meta_validate_get() could be kept?

> +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> +	switch (priv->key) {
>   	case NFT_META_LEN:
>   	case NFT_META_PROTOCOL:
>   	case NFT_META_NFPROTO:
> @@ -205,39 +199,40 @@ static int nft_meta_init_validate_get(uint32_t key)
>   #ifdef CONFIG_NETWORK_SECMARK
>   	case NFT_META_SECMARK:
>   #endif
> -		return 0;
> +		break;
>   	default:
>   		return -EOPNOTSUPP;
>   	}
>   
> +	priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
> +	err = nft_validate_output_register(priv->dreg);
> +	if (err < 0)
> +		return err;
> +
> +	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
>   }
>   
> -static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> -			 const struct nlattr * const tb[])
> +static int nft_meta_set_init(const struct nft_ctx *ctx,
> +			     const struct nft_expr *expr,
> +			     const struct nlattr * const tb[])
>   {
>   	struct nft_meta *priv = nft_expr_priv(expr);
>   	int err;
>   
>   	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
> -
> -	if (tb[NFTA_META_DREG]) {
> -		err = nft_meta_init_validate_get(priv->key);
> -		if (err < 0)
> -			return err;
> -
> -		priv->dreg = ntohl(nla_get_be32(tb[NFTA_META_DREG]));
> -		err = nft_validate_output_register(priv->dreg);
> -		if (err < 0)
> -			return err;
> -
> -		return nft_validate_data_load(ctx, priv->dreg, NULL,
> -					      NFT_DATA_VALUE);
> +	switch (priv->key) {
> +	case NFT_META_MARK:
> +	case NFT_META_PRIORITY:
> +	case NFT_META_NFTRACE:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
>   	}
>   
> -	err = nft_meta_init_validate_set(priv->key);
> -	if (err < 0)
> -		return err;
> -
>   	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
>   	err = nft_validate_input_register(priv->sreg);
>   	if (err < 0)
> @@ -282,7 +277,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
>   	.type		= &nft_meta_type,
>   	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
>   	.eval		= nft_meta_get_eval,
> -	.init		= nft_meta_init,
> +	.init		= nft_meta_get_init,
>   	.dump		= nft_meta_get_dump,
>   };
>   
> @@ -290,7 +285,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
>   	.type		= &nft_meta_type,
>   	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
>   	.eval		= nft_meta_set_eval,
> -	.init		= nft_meta_init,
> +	.init		= nft_meta_set_init,
>   	.dump		= nft_meta_set_dump,
>   };
>   

Rest is fine and indeed it simplifies things on my side (no need to c/p 
the old nft_meta_init,
here I can reuse existing nft_meta_set_init)

Tomasz
