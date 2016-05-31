From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: add support for
 inverted login in nft_lookup
Date: Tue, 31 May 2016 14:08:19 +0200
Message-ID: <20160531120819.GA6491@salvia>
References: <146469577386.17442.8631583064566384839.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35392 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbcEaMIZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 08:08:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1D4771D92D5
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 14:08:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 08C4616E3EB
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 14:08:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D924C165CDF
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 14:08:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146469577386.17442.8631583064566384839.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 01:57:16PM +0200, Arturo Borrero Gonzalez wrote:
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

I missed this one before:

                if (flags & ~NFT_LOOKUP_F_INV)
                        return -EINVAL;

> +		if (flags & NFT_LOOKUP_F_INV)
> +			priv->invert = true;
> +	}
> +
>  	priv->binding.flags = set->flags & NFT_SET_MAP;
>  
>  	err = nf_tables_bind_set(ctx, set, &priv->binding);
> @@ -112,6 +122,7 @@ static void nft_lookup_destroy(const struct nft_ctx *ctx,
