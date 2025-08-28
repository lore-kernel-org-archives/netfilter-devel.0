Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F30B665
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 14:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391419; cv=none; b=oSKG9yTsj4b4T2rYbrJcmKQ0sy2lWBECGvFgyzpV7fVf04Mz8HfP5f1xxQYNiTOO6yJfFO7DIxZpgz/Dr3KPCrVwNKejZCh50uvNvBS30QjmgJ58uzFLPE7FPN7VGtVKAp3eXBSPbgcLNLQ8qlLcE9MJ16R9Z2fOYmkSnwaougo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391419; c=relaxed/simple;
	bh=o5Z/DMA/tQlfncpXbw/j2Dzm15rSWKGXnx83J+ahsjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csUJu6Fsrdw/EcU/AOiPQYqGO+Mf4NEnFphKVYE5oy0lZLpwlRjTtHxRNpgLvJmuTCY44g2Moc+G1XkmdbG4wD/fhw8Xa8CYW5XBKr8h+SXIX5+Bu+82ubTm1fDdS7fkv1pjVw2m8XoAdN2ZrvSzHqlCeJGq3aCajTbJmafaiPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ew2zuJ04; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v7YR5MEn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ew2zuJ04";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v7YR5MEn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DE45960709; Thu, 28 Aug 2025 16:30:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756391412;
	bh=kolglAKW/neY2iCspjU0r07Qs8F3T65wnD9u5iFmY3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ew2zuJ0480PwswDAf6x+yj0ePIs5QdM0DmTwUE1sAlB/oMNvIx3bYS2Ws14OGLKlJ
	 c0VClcfoz8AuKI72Jv5bZg6lWrowXKTTYQZt3VQFQl97xbnY3KwstmiYzNRGZStlxn
	 982E+2F+l1yXFoqK/+ZgLepPm5K9nEJlqIA53HBt0xn46GfBoBHpHKpx3wdhT9yi9o
	 n1UAn8WgIfy2tWNsqN79tsMRy3lZXEIvR7IPYSQSTuBWqwMZzx4I5kyfvJuDvbSvqk
	 gxGHNzRm+y/1eTwUVmdfKjn+M7yyOxqiZllncpr+pcLs5dZifspV7PZJKfDpbDR37X
	 MkJXQZphiENwA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B452B60702;
	Thu, 28 Aug 2025 16:30:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756391411;
	bh=kolglAKW/neY2iCspjU0r07Qs8F3T65wnD9u5iFmY3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v7YR5MEnN/HFIk82+S01wcPULA7h8kQbMOs28O2eQSgLcLXiWd6K8MNo/IHGsnPHw
	 SuBRWevcXiW4T39SAuF/TsuNvRvcQC+CBhaWrqo6BjGvXBdHFxhY7eE7ePfkiMZDe1
	 L2ssLmrebMvnl95VLMDXQHj6y2IxO63SVy9kM0Mk1R7GvPLrIQsAkzfJRFZ6aU8rX+
	 /z53eKp5GanHknjGB+sa+QBkv+2y5K2Y6i6Ea64KGJvZBwp40qaNijb6TRN2thTvdr
	 oipl1pfnFoYgmfqLuBoO2aOxOGnm7tQ/Aq/6as9qTgqH1n0uCsTRc9lplMUrXGyGxK
	 BGVBB8VrtRvSA==
Date: Thu, 28 Aug 2025 16:30:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Sven Auhagen <Sven.Auhagen@belden.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_tables: allow iter
 callbacks to sleep
Message-ID: <aLBn8Q3hgcqCvk4D@calendula>
References: <20250822081542.27261-1-fw@strlen.de>
 <20250822081542.27261-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250822081542.27261-2-fw@strlen.de>

Hi Florian,

On Fri, Aug 22, 2025 at 10:15:37AM +0200, Florian Westphal wrote:
[...] 
> diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
> index 266d0c637225..cc302543c2e4 100644
> --- a/net/netfilter/nft_set_hash.c
> +++ b/net/netfilter/nft_set_hash.c
> @@ -30,6 +30,7 @@ struct nft_rhash {
>  struct nft_rhash_elem {
>  	struct nft_elem_priv		priv;
>  	struct rhash_head		node;
> +	struct llist_node		walk_node;
>  	u32				wq_gc_seq;
>  	struct nft_set_ext		ext;
>  };
> @@ -144,6 +145,7 @@ nft_rhash_update(struct nft_set *set, const u32 *key,
>  		goto err1;
>  
>  	he = nft_elem_priv_cast(elem_priv);
> +	init_llist_node(&he->walk_node);
>  	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
>  						nft_rhash_params);
>  	if (IS_ERR(prev))
> @@ -180,6 +182,7 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
>  	};
>  	struct nft_rhash_elem *prev;
>  
> +	init_llist_node(&he->walk_node);
>  	prev = rhashtable_lookup_get_insert_key(&priv->ht, &arg, &he->node,
>  						nft_rhash_params);
>  	if (IS_ERR(prev))
> @@ -261,12 +264,12 @@ static bool nft_rhash_delete(const struct nft_set *set,
>  	return true;
>  }
>  
> -static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
> -			   struct nft_set_iter *iter)
> +static void nft_rhash_walk_ro(const struct nft_ctx *ctx, struct nft_set *set,
> +			      struct nft_set_iter *iter)
>  {
>  	struct nft_rhash *priv = nft_set_priv(set);
> -	struct nft_rhash_elem *he;
>  	struct rhashtable_iter hti;
> +	struct nft_rhash_elem *he;
>  
>  	rhashtable_walk_enter(&priv->ht, &hti);
>  	rhashtable_walk_start(&hti);
> @@ -295,6 +298,99 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
>  	rhashtable_walk_exit(&hti);
>  }
>  
> +static void nft_rhash_walk_update(const struct nft_ctx *ctx,
> +				  struct nft_set *set,
> +				  struct nft_set_iter *iter)
> +{
> +	struct nft_rhash *priv = nft_set_priv(set);
> +	struct nft_rhash_elem *he, *tmp;
> +	struct llist_node *first_node;
> +	struct rhashtable_iter hti;
> +	LLIST_HEAD(walk_list);
> +
> +	lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
> +
> +	if (set->in_update_walk) {
> +		/* This can happen with bogus rulesets during ruleset validation
> +		 * when a verdict map causes a jump back to the same map.
> +		 *
> +		 * Without this extra check the walk_next loop below will see
> +		 * elems on the callers walk_list and skip (not validate) them.
> +		 */
> +		iter->err = -EMLINK;
> +		return;
> +	}
> +
> +	/* walk happens under RCU.
> +	 *
> +	 * We create a snapshot list so ->iter callback can sleep.
> +	 * commit_mutex is held, elements can ...
> +	 * .. be added in parallel from dataplane (dynset)
> +	 * .. be marked as dead in parallel from dataplane (dynset).
> +	 * .. be queued for removal in parallel (gc timeout).
> +	 * .. not be freed: transaction mutex is held.
> +	 */
> +	rhashtable_walk_enter(&priv->ht, &hti);
> +	rhashtable_walk_start(&hti);
> +
> +	while ((he = rhashtable_walk_next(&hti))) {
> +		if (IS_ERR(he)) {
> +			if (PTR_ERR(he) != -EAGAIN) {
> +				iter->err = PTR_ERR(he);
> +				break;
> +			}
> +
> +			continue;
> +		}
> +
> +		/* rhashtable resized during walk, skip */
> +		if (llist_on_list(&he->walk_node))
> +			continue;
> +
> +		if (iter->count < iter->skip) {
> +			iter->count++;
> +			continue;
> +		}

Not causing any harm, but is iter->count useful for this
NFT_ITER_UPDATE variant?

I think iter->count is only used for netlink dumps, to resume from the
last netlink message.

> +		llist_add(&he->walk_node, &walk_list);
> +	}
> +	rhashtable_walk_stop(&hti);
> +	rhashtable_walk_exit(&hti);
> +
> +	first_node = __llist_del_all(&walk_list);
> +	set->in_update_walk = true;
> +	llist_for_each_entry_safe(he, tmp, first_node, walk_node) {
> +		if (iter->err == 0) {
> +			iter->err = iter->fn(ctx, set, iter, &he->priv);
> +			if (iter->err == 0)
> +				iter->count++;
> +		}
> +
> +		/* all entries must be cleared again, else next ->walk iteration
> +		 * will skip entries.
> +		 */
> +		init_llist_node(&he->walk_node);
> +	}
> +	set->in_update_walk = false;
> +}
> +
> +static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
> +			   struct nft_set_iter *iter)
> +{
> +	switch (iter->type) {
> +	case NFT_ITER_UPDATE:
> +		nft_rhash_walk_update(ctx, set, iter);
> +		break;
> +	case NFT_ITER_READ:
> +		nft_rhash_walk_ro(ctx, set, iter);
> +		break;
> +	default:
> +		iter->err = -EINVAL;
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +}
> +
>  static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
>  					struct nft_set_ext *ext)
>  {
