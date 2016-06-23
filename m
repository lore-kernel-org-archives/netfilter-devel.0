From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v4] netfilter: nf_tables: add support for
 inverted logic in nft_lookup
Date: Thu, 23 Jun 2016 12:08:37 +0200
Message-ID: <20160623100837.GA2521@salvia>
References: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38779 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbcFWKIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:08:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B964DE7DB0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:08:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A7F5D9EBBD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:08:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8A9DF9EBB5
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:08:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 05:23:02PM +0200, Arturo Borrero Gonzalez wrote:
> @@ -32,14 +33,19 @@ static void nft_lookup_eval(const struct nft_expr *expr,
>  	const struct nft_lookup *priv = nft_expr_priv(expr);
>  	const struct nft_set *set = priv->set;
>  	const struct nft_set_ext *ext;
> +	bool found;
>  
> -	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
> -		if (set->flags & NFT_SET_MAP)
> -			nft_data_copy(&regs->data[priv->dreg],
> -				      nft_set_ext_data(ext), set->dlen);
> +	found = set->ops->lookup(set, &regs->data[priv->sreg], &ext);
> +
> +	if (!(found ^ priv->invert)) {
> +		regs->verdict.code = NFT_BREAK;
>  		return;
>  	}
> -	regs->verdict.code = NFT_BREAK;
> +
> +	if (set->flags & NFT_SET_MAP && found && !priv->invert)

I think this is a bit defensive: if set->flags & NFT_SET_MAP evaluates
true, then we can assume priv->invert is always false. We can just add
a comment on top of this.

Note that, from the _init() path, we reject inversions with maps.

So probably something like:

        /* nft_lookup_init() already rejects maps with inverted lookups.
         * We assume that inversion is always false with maps.
         */
	found = set->ops->lookup(set, &regs->data[priv->sreg], &ext) ^
                priv->invert;
        if (found && set->flags & NFT_SET_MAP)
                nft_data_copy(...);

would be a bit more simple.

> +		nft_data_copy(&regs->data[priv->dreg],
> +			      nft_set_ext_data(ext), set->dlen);
> +
>  }
>  
>  static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
