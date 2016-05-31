From: Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Tue, 31 May 2016 16:44:01 +0200
Message-ID: <20160531144401.GB11135@breakpoint.cc>
References: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40697 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbcEaOoI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 10:44:08 -0400
Content-Disposition: inline
In-Reply-To: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> -	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
> +	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext) ^
> +	    priv->invert) {
>  		if (set->flags & NFT_SET_MAP)
>  			nft_data_copy(&regs->data[priv->dreg],
>  				      nft_set_ext_data(ext), set->dlen);

Whats the plan for SET_MAP here?
You enter 'lookup found a result' branch here in case we did not find
anything and invert is set.

I think its better to use a

} else if (priv->invert) {
	return;
}

here.

> @@ -47,6 +49,7 @@ static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
>  	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
>  	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
>  	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
> +	[NFTA_LOOKUP_FLAGS]	= { .type = NLA_U32 },
>  };
>  
>  static int nft_lookup_init(const struct nft_ctx *ctx,
> @@ -55,6 +58,7 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
>  {
>  	struct nft_lookup *priv = nft_expr_priv(expr);
>  	struct nft_set *set;
> +	u32 flags;
>  	int err;
>  
>  	if (tb[NFTA_LOOKUP_SET] == NULL ||
> @@ -91,6 +95,12 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
>  	} else if (set->flags & NFT_SET_MAP)
>  		return -EINVAL;
>  
> +	if (tb[NFTA_LOOKUP_FLAGS]) {
> +		flags = ntohl(nla_get_be32(tb[NFTA_LOOKUP_FLAGS]));
> +		if (flags & NFT_LOOKUP_F_INV)
> +			priv->invert = true;
> +	}
> +

I think we should EINVAL if NFT_LOOKUP_F_INV is given with dreg/map.
