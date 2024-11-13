Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594891FB88B
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731492966; cv=none; b=WDfSYiiX+4M5sWwCTRR/oPPIm+tM+PEGD30Ie8v0xX/02PwMvWbFV8x347zmnGuPmbizHk8xX+rHwT10StoA3AqHhITZd32wdO5fxmimtJ7dHb7ANuokJOupooOWpdf2irqhipGoaX+qKxpUyWTDPISLddXb+iGIBu1dDMLLjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731492966; c=relaxed/simple;
	bh=5nBOfWAHT5blzkXPP4GJbPxziTJfu8QGh3PyLLUQp04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPWV2bQIuf/YXSnLgNAnpg2clghUq8sdnO9JvZAs/wrwWxEa3wvXoGLFYHnw9q+gVM5/Hg2is35pRMd9kPfT6MXbHUegz/7oHmhaALb5VlOCsVmS33p8Om/UM566cls+0HbvSwyEANg4gdx4Q/QJSrakx4kOGMtRJ09k2Y4lbGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37596 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBAPl-00Dd4n-8U; Wed, 13 Nov 2024 11:15:59 +0100
Date: Wed, 13 Nov 2024 11:15:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 4/5] netfilter: nf_tables: switch trans_elem
 to real flex array
Message-ID: <ZzR8W7oQ_3wD-osu@calendula>
References: <20241107174415.4690-1-fw@strlen.de>
 <20241107174415.4690-5-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241107174415.4690-5-fw@strlen.de>
X-Spam-Score: -1.8 (-)

Hi Florian,

I'm making another pass on this series, a few thing I would like to
ask, see below.

On Thu, Nov 07, 2024 at 06:44:08PM +0100, Florian Westphal wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index bdf5ba21c76d..e96e538fe2eb 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -25,6 +25,7 @@
>  
>  #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
>  #define NFT_SET_MAX_ANONLEN 16
> +#define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))

This NFT_MAX_SET_NELEMS is to stay in a specific kmalloc-X?

What is the logic behind this NFT_MAX_SET_NELEMS?

>  unsigned int nf_tables_net_id __read_mostly;
>  
> @@ -391,6 +392,69 @@ static void nf_tables_unregister_hook(struct net *net,
>  	return __nf_tables_unregister_hook(net, table, chain, false);
>  }
>  
> +static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
> +{
> +	return a->set == b->set && a->bound == b->bound && a->nelems < NFT_MAX_SET_NELEMS;

I think this a->bound == b->bound check defensive.

This code is collapsing only two consecutive transactions, the one at
the tail (where nelems > 1) and the new transaction (where nelems ==
1).

bound state should only change in case there is a NEWRULE transaction
in between.

I am trying to find a error scenario where a->bound == b->bound
evaluates false. I considered the following:

   newelem -> newrule -> newelem

where newrule has these expressions:

   lookup -> error

in this case, newrule error path is exercised:

   nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);

this calls nf_tables_deactivate_set() that calls
nft_set_trans_unbind(), then a->bound is restored to false. Rule is
released and no transaction is added.

Because if this succeeds:

   newelem -> newrule -> newelem

then no element collapsing can happen, because we only collapse what
is at the tail.

TLDR; Check does not harm, but it looks unlikely to happen to me.

one more comment below.

> +}
> +
> +static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
> +					struct nft_trans_elem *tail,
> +					struct nft_trans_elem *trans,
> +					gfp_t gfp)
> +{
> +	unsigned int nelems, old_nelems = tail->nelems;
> +	struct nft_trans_elem *new_trans;
> +
> +	if (!nft_trans_collapse_set_elem_allowed(tail, trans))
> +		return false;
> +
> +	if (WARN_ON_ONCE(trans->nelems != 1))
> +		return false;
> +
> +	if (check_add_overflow(old_nelems, trans->nelems, &nelems))
> +		return false;
> +
> +	/* krealloc might free tail which invalidates list pointers */
> +	list_del_init(&tail->nft_trans.list);
> +
> +	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
> +	if (!new_trans) {
> +		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
> +		return false;
> +	}
> +
> +	INIT_LIST_HEAD(&new_trans->nft_trans.list);

This initialization is also defensive, this element is added via
list_add_tail().

> +	new_trans->nelems = nelems;
> +	new_trans->elems[old_nelems] = trans->elems[0];
> +	list_add_tail(&new_trans->nft_trans.list, &nft_net->commit_list);
> +
> +	return true;
> +}
