Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC9C17BB21
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747310740; cv=none; b=W/ToBGtqdNuU5KLKEAWG5U31PHdOaTyh8OxERw2QTpcH4VyB2miIQ/oooq/D8VPDiOCUwZMBUCrB9mO4HcUb6T1I27ASjJkjre4ENdk4qaIwEY7cpVLn9W3EZhg5wrWg5r4PQCyTvblIVD8W7OYAg0nTdbosIbY2tHz8qayfpCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747310740; c=relaxed/simple;
	bh=gHoNgLm5CiTn2kcUofJA6RAiDHmheGnGyovn8bipgSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtvRIogzMgoQqGfUTL9AjtFQ155L+hdAVKTOGVFzSMek2oOqPEJTHUQ2XI2+ZJPTkd1sc8YT7B7nkfOqV+m/y6w2sJrCR5y3Ro1KbhE5K2LxiEQwSOuurpJLqiNLQ2dN0fvRlQBi0jmnpKHE/QIq9n9edYMmX4jVDfuy6TO7S7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=o1N3XTOl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="o1N3XTOl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pQJPzTIT7RU5I3vbJroWgOY2DhC2uWsirkPnHUhkpvQ=; b=o1N3XTOlIvdm2IGEWlY8AWwDXL
	6QkuxnfR6BL8UyUf3lB4w7tl1uXnyiwEN1keU8FNaXXov892W7m7COsJZfwi/FXciRGNv1UZMQaXy
	zMvHBWXFwlgNW88BjwtJsepcmHqpBDgmucNiFvyOv8zLc76DaXQQw65YX6Him2pix9aJJnB2F08Iu
	492Z8o26tObnLE7K56j/78/8sCHV3KOCyD3eSpBT6QQ4k92q1um0xcTAgGEnS3/WZDr7DSjuPltyB
	nQaOLnmelhGy3jMIBp/K5pLa7+t2ULPxAaLe3pB/Wid5d6aor40O2Bnr7oIFmS187nB1AtuQBy2po
	dhq+UM8Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFXLC-000000007I5-3YxA;
	Thu, 15 May 2025 14:05:34 +0200
Date: Thu, 15 May 2025 14:05:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 6/6] netfilter: nf_tables: add support for
 validating incremental ruleset updates
Message-ID: <aCXYjttDxXj_d2EH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250514214216.828862-1-pablo@netfilter.org>
 <20250514214216.828862-7-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514214216.828862-7-pablo@netfilter.org>

On Wed, May 14, 2025 at 11:42:16PM +0200, Pablo Neira Ayuso wrote:
> Use the new binding graph to validate incremental ruleset updates.
> 
> Perform full validation if the table is new, which is the case of the
> initial ruleset reload. Subsequent incremental ruleset updates use the
> validation list which contains chains with new rules or chains that can
> be now reached via jump/goto from another rule/set element.
> 
> When validating a chain from commit/abort phase, backtrack to collect
> the basechains that can reach this chain, then perform the validation of
> rules in this chain. If no basechains can be reached, then skip
> validation for this chain. However, if basechains are off the jump stack
> limit, then resort to full ruleset validation. This is to prevent
> inconsistent validation between the preparation and commit/abort phase
> validations.
> 
> As for loop checking, stick to the existing approach which uses the jump
> stack limit to detect cycles.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 188 +++++++++++++++++++++++++++++++++-
>  1 file changed, 183 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index e92cccc834d9..0f183abbc94f 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10397,6 +10397,160 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
>  	},
>  };
>  
> +struct basechain_array {
> +	const struct nft_chain	**basechain;
> +	uint32_t		num_basechains;
> +	uint32_t		max_basechains;
> +	int			max_level;
> +};
> +
> +static int basechain_array_add(struct basechain_array *array,
> +			       const struct nft_chain *chain, int level)
> +{
> +	const struct nft_chain **new_basechain;
> +	uint32_t new_max_basechains;
> +
> +	if (array->num_basechains == array->max_basechains) {
> +		new_max_basechains = array->max_basechains + 16;
> +		new_basechain = krealloc_array(array->basechain, new_max_basechains, sizeof(struct nft_chain *), GFP_KERNEL);
> +		if (!new_basechain)
> +			return -ENOMEM;
> +
> +		array->basechain = new_basechain;
> +		array->max_basechains = new_max_basechains;
> +	}
> +	array->basechain[array->num_basechains++] = chain;
> +
> +	if (level > array->max_level)
> +		array->max_level = level;
> +
> +	return 0;
> +}
> +
> +static int nft_chain_validate_backtrack(struct basechain_array *array,
> +					const struct list_head *backbinding_list,
> +					int *level)
> +{
> +	struct nft_binding *binding;
> +	int err;
> +
> +	/* Basechain is unreachable, fall back to slow path validation. */
> +	if (*level >= NFT_JUMP_STACK_SIZE)
> +		return -ENOENT;
> +
> +	list_for_each_entry(binding, backbinding_list, backlist) {
> +		if (binding->from.type == NFT_BIND_CHAIN &&
> +		    binding->from.chain->flags & NFT_CHAIN_BASE &&
> +		    binding->use > 0) {
> +			if (basechain_array_add(array, binding->from.chain, *level) < 0)
> +				return -ENOMEM;
> +
> +			continue;
> +		}
> +
> +		switch (binding->from.type) {
> +		case NFT_BIND_CHAIN:
> +			if (binding->use == 0)
> +				break;
> +
> +			(*level)++;
> +			err = nft_chain_validate_backtrack(array,
> +							   &binding->from.chain->backbinding_list,
> +							   level);
> +			if (err < 0)
> +				return err;
> +
> +			(*level)--;

It looks like you're trying to record the max level value for error
path, but I don't see it used in callers. Is this a leftover from before
introduction of basechain_array::max_level? If so, one may just pass
'level + 1' by value to the recursive call, right?

> +			break;
> +		case NFT_BIND_SET:
> +			if (binding->use == 0)
> +				break;
> +
> +			/* no level update for sets. */
> +			err = nft_chain_validate_backtrack(array,
> +							   &binding->from.set->backbinding_list,
> +							   level);
> +			if (err < 0)
> +				return err;
> +
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int nft_chain_validate_incremental(struct net *net,
> +					  const struct nft_chain *chain)
> +{
> +	struct basechain_array array = {};
> +	uint32_t i, level = 1;
> +	int err;
> +
> +	array.max_basechains = 16;
> +	array.basechain = kcalloc(16, sizeof(struct nft_chain *), GFP_KERNEL);
> +	if (!array.basechain)
> +		return -ENOMEM;
> +
> +	if (nft_is_base_chain(chain)) {
> +		err = basechain_array_add(&array, chain, 0);
> +		if (err < 0) {
> +			kfree(array.basechain);
> +			return -ENOMEM;
> +		}
> +	} else {
> +		err = nft_chain_validate_backtrack(&array,
> +						   &chain->backbinding_list,
> +						   &level);
> +		if (err < 0) {
> +			kfree(array.basechain);
> +			return err;
> +		}
> +	}
> +
> +	for (i = 0; i < array.num_basechains; i++) {
> +		struct nft_ctx ctx = {
> +			.net	= net,
> +			.family	= chain->table->family,
> +			.table	= chain->table,
> +			.chain	= (struct nft_chain *)array.basechain[i],
> +			.level	= array.max_level,
> +		};
> +
> +		if (WARN_ON_ONCE(!nft_is_base_chain(array.basechain[i])))
> +			continue;
> +
> +		err = nft_chain_validate(&ctx, chain);
> +		if (err < 0)
> +			break;
> +	}
> +
> +	kfree(array.basechain);
> +
> +	return err;
> +}
> +
> +static int nft_validate_incremental(struct net *net, struct nft_table *table)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +	struct nft_chain *chain, *next;
> +	int err;
> +
> +	err = 0;
> +	list_for_each_entry_safe(chain, next, &nft_net->validate_list, validate_list) {
> +		if (chain->table != table)
> +			continue;
> +
> +		if (err >= 0)
> +			err = nft_chain_validate_incremental(net, chain);

Is there a future use-case for err > 0? I don't see where that function
would return a positive value. If this is not to change, I guess just
checking err || !err would simplify things a bit and also avoid the
EINTR != !EINTR pitfall (see below).

> +
> +		list_del(&chain->validate_list);
> +		chain->validate = 0;
> +	}
> +
> +	return err;
> +}
> +
>  static void nft_validate_chain_release(struct net *net)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
> @@ -10422,12 +10576,36 @@ static int nf_tables_validate(struct net *net)
>  			nft_validate_state_update(table, NFT_VALIDATE_DO);
>  			fallthrough;
>  		case NFT_VALIDATE_DO:
> -			err = nft_table_validate(net, table);
> -			if (err < 0) {
> -				if (err == EINTR)

This should be -EINTR, right?

> -					goto err_eintr;
> +			/* If this table is new, then this is the initial
> +			 * ruleset restore, perform full table validation,
> +			 * otherwise, perform incremental validation.
> +			 */
> +			if (!nft_is_active(net, table)) {
> +				err = nft_table_validate(net, table);
> +				if (err < 0) {
> +					if (err == EINTR)

Same here?

> +						goto err_eintr;
>  
> -				return -EAGAIN;
> +					return -EAGAIN;
> +				}
> +			} else {
> +				err = nft_validate_incremental(net, table);
> +				if (err < 0) {
> +					if (err != -ENOMEM && err != -ENOENT)
> +						return -EAGAIN;
> +
> +					/* Either no memory or it cannot reach
> +					 * basechain, then fallback to full
> +					 * validation.
> +					 */
> +					err = nft_table_validate(net, table);
> +					if (err < 0) {
> +						if (err == EINTR)

And here as well?

Cheers, Phil

> +							goto err_eintr;
> +
> +						return -EAGAIN;
> +					}
> +				}
>  			}
>  			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
>  			break;
> -- 
> 2.30.2
> 
> 
> 
