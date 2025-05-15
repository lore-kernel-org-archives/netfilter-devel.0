Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA42298CB2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747312487; cv=none; b=VuATaMYZfUxCfvV6hs200IKp2cVFQbn3sKiKg/zje1RMi6tFcYBjx+BkqWVXAppPf+GdpBglENl0RGZVkhGN6OrZq4PW+HYb743l54+Bi3m38HVSzYCABu1VKqQ0RQPM3Rp7qVgjJIaqY4WMzyZ8/Jkms7EmcLVL9WR0XuufEiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747312487; c=relaxed/simple;
	bh=xCBx/k+kxYsd7DffCEfqHK1Oy+xowftbobIYBbnsfQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PW+zZUrJ3ScHhk5QqScQ88YlaKqOjODgFHcULDWrmvGbrxqtw2N1JJxXwKJOF/jzl1TTxrOgoAfhn4E0E5BCgKfv97o+Jsu548A3OEP+n1CEiifW+WbWK7/inWd+8k8TVFfdnuJ/8KNQkMVrR++q5edqoJZFW3XteuU/SNZ3sZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dro/N8I0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dro/N8I0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9UjQZNOQ7v4vVWhqk1oDeE70LJPk+a69L3o3rTDvyOs=; b=Dro/N8I0xiPv7AFEPjYh6yxi0U
	L/1+m5837f2+Mcar+bVN5hvOMHGXiwmg3NYmGyDRi7a659wumnvKiIHL/gI4TIV1BDHK9B3oK5mik
	+EYHz1Q948+5Fi/W8xT+2JejWuyJAsCysQuKrmEbWS5uAbkE1rUUEcJ/9Z51vWQE6G0oef3hE41D5
	nTZ9Wl1exLQsouDbxmrZ97+hvvLhwKyVt8nE3zjMx4Eg9e+5C2VBfhAeXujM4qU51oXzEoxSn4CYd
	8U0opwOTMwfv25QOaYHziaGgEIzDZ4aHX1a4u9ISLBiDQ3FMtWXcutV1mchcL29jj57Y0PzXPC9XK
	ZHvFDu5A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFXnP-000000007c2-07Kj;
	Thu, 15 May 2025 14:34:43 +0200
Date: Thu, 15 May 2025 14:34:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 5/6] netfilter: nf_tables: use new binding
 infrastructure
Message-ID: <aCXfYsIdc73YZY_8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250514214216.828862-1-pablo@netfilter.org>
 <20250514214216.828862-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514214216.828862-6-pablo@netfilter.org>

On Wed, May 14, 2025 at 11:42:15PM +0200, Pablo Neira Ayuso wrote:
> This patch uses the new binding infrastructure to link chains and sets:
> 
> - Chain-to-chain and chain-to-set bindings already exists, so it is
>   relatively trivial to add the code to add, deactivate, activate and
>   delete the bindings.
> 
> - Set-to-chain is a new binding required by verdict maps, this requires
>   to release this new type of binding from the commit/abort path.
>   Special cases are the deletion of sets with elements and netns/netlink
>   release path, that require the removal of all set-to-chain bindings.
>   Another special case is anonymous sets, that also require to delete
>   all set-to-chain bindings when unbound.
> 
> The binding graph is not yet used to validate rulesets, this is enabled
> in the follow up patch.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |   2 +-
>  net/netfilter/nf_tables_api.c     | 149 ++++++++++++++++++++++++++++--
>  net/netfilter/nft_immediate.c     |  25 ++++-
>  3 files changed, 164 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 807097746d24..c33820fc1abd 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1929,7 +1929,7 @@ struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
>  struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc);
>  
>  void nft_setelem_data_deactivate(const struct net *net,
> -				 const struct nft_set *set,
> +				 struct nft_set *set,
>  				 struct nft_elem_priv *elem_priv);
>  
>  int __init nft_chain_filter_init(void);
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 463ee7b4ec19..e92cccc834d9 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6077,6 +6077,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
>  {
>  	struct nft_set_binding *i;
>  	struct nft_set_iter iter;
> +	int err;
>  
>  	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
>  		return -EBUSY;
> @@ -6109,6 +6110,12 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
>  	if (!nft_use_inc(&set->use))
>  		return -EMFILE;
>  
> +	err = nft_add_chain_set_binding(ctx->chain, set);
> +	if (err < 0) {
> +		nft_use_dec_restore(&set->use);
> +		return err;
> +	}
> +
>  	binding->chain = ctx->chain;
>  	list_add_tail_rcu(&binding->list, &set->bindings);
>  	nft_set_trans_bind(ctx, set);
> @@ -6117,14 +6124,27 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
>  }
>  EXPORT_SYMBOL_GPL(nf_tables_bind_set);
>  
> +static void nft_del_set_chain_binding_all(struct nft_set *set)
> +{
> +	struct nft_binding *binding, *next;
> +	struct nft_chain *chain;
> +
> +	list_for_each_entry_safe(binding, next, &set->binding_list, list) {
> +		chain = (struct nft_chain *)binding->to.chain;
> +		nft_del_set_chain_binding(set, chain);
> +	}
> +}
> +
>  static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
>  				 struct nft_set_binding *binding, bool event)
>  {
>  	list_del_rcu(&binding->list);
> +	nft_del_chain_set_binding(ctx->chain, set);
>  
>  	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
>  		list_del_rcu(&set->list);
>  		set->dead = 1;
> +		nft_del_set_chain_binding_all(set);
>  		if (event)
>  			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
>  					     GFP_KERNEL);
> @@ -6132,7 +6152,7 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
>  }
>  
>  static void nft_setelem_data_activate(const struct net *net,
> -				      const struct nft_set *set,
> +				      struct nft_set *set,
>  				      struct nft_elem_priv *elem_priv);
>  
>  static int nft_mapelem_activate(const struct nft_ctx *ctx,
> @@ -6193,6 +6213,7 @@ void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
>  		nft_clear(ctx->net, set);
>  	}
>  
> +	nft_activate_chain_set_binding(ctx->chain, set);
>  	nft_use_inc_restore(&set->use);
>  }
>  EXPORT_SYMBOL_GPL(nf_tables_activate_set);
> @@ -6211,6 +6232,8 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  		else
>  			list_del_rcu(&binding->list);
>  
> +		nft_deactivate_chain_set_binding(ctx->chain, set);
> +		nft_del_chain_set_binding(ctx->chain, set);
>  		nft_use_dec(&set->use);
>  		break;
>  	case NFT_TRANS_PREPARE:
> @@ -6220,6 +6243,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  
>  			nft_deactivate_next(ctx->net, set);
>  		}
> +		nft_deactivate_chain_set_binding(ctx->chain, set);
>  		nft_use_dec(&set->use);
>  		return;
>  	case NFT_TRANS_ABORT:
> @@ -6228,6 +6252,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  		    set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
>  			nft_map_deactivate(ctx, set);
>  
> +		nft_deactivate_chain_set_binding(ctx->chain, set);
>  		nft_use_dec(&set->use);
>  		fallthrough;
>  	default:
> @@ -7124,6 +7149,7 @@ static void __nft_set_elem_destroy(const struct nft_ctx *ctx,
>  	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
>  		nft_data_release(nft_set_ext_data(ext), set->dtype);
> +		// XXX gc

Leftover?

Cheers, Phil

>  	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
>  		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
> @@ -7454,6 +7480,27 @@ static void nft_setelem_remove(const struct net *net,
>  		set->ops->remove(net, set, elem_priv);
>  }
>  
> +static void nft_setelem_data_binding_remove(struct nft_set *set,
> +					    struct nft_elem_priv *elem_priv)
> +{
> +	struct nft_set_ext *ext;
> +
> +	ext = nft_set_elem_ext(set, elem_priv);
> +	if (set->dtype == NFT_DATA_VERDICT &&
> +	    nft_set_ext_exists(ext, NFT_SET_EXT_DATA)) {
> +		struct nft_data *data = nft_set_ext_data(ext);
> +		struct nft_chain *chain;
> +
> +		switch (data->verdict.code) {
> +		case NFT_JUMP:
> +		case NFT_GOTO:
> +			chain = data->verdict.chain;
> +			nft_del_set_chain_binding(set, chain);
> +			break;
> +		}
> +	}
> +}
> +
>  static void nft_trans_elems_remove(const struct nft_ctx *ctx,
>  				   const struct nft_trans_elem *te)
>  {
> @@ -7471,6 +7518,8 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
>  			atomic_dec(&te->set->nelems);
>  			te->set->ndeact--;
>  		}
> +
> +		nft_setelem_data_binding_remove(te->set, te->elems[i].priv);
>  	}
>  }
>  
> @@ -7768,9 +7817,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  				nft_validate_chain_need(ctx, elem.data.val.verdict.chain);
>  		}
>  
> +		if (desc.type == NFT_DATA_VERDICT &&
> +		    (elem.data.val.verdict.code == NFT_GOTO ||
> +		     elem.data.val.verdict.code == NFT_JUMP)) {
> +			err = nft_add_set_chain_binding(set, elem.data.val.verdict.chain);
> +			if (err < 0)
> +				goto err_parse_data;
> +		}
> +
>  		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
>  		if (err < 0)
> -			goto err_parse_data;
> +			goto err_binding;
>  	}
>  
>  	/* The full maximum length of userdata can exceed the maximum
> @@ -7784,7 +7841,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  			err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
>  						     ulen);
>  			if (err < 0)
> -				goto err_parse_data;
> +				goto err_binding;
>  		}
>  	}
>  
> @@ -7793,7 +7850,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  				      timeout, expiration, GFP_KERNEL_ACCOUNT);
>  	if (IS_ERR(elem.priv)) {
>  		err = PTR_ERR(elem.priv);
> -		goto err_parse_data;
> +		goto err_binding;
>  	}
>  
>  	ext = nft_set_elem_ext(set, elem.priv);
> @@ -7903,6 +7960,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	kfree(trans);
>  err_elem_free:
>  	nf_tables_set_elem_destroy(ctx, set, elem.priv);
> +err_binding:
> +	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
> +		if (desc.type == NFT_DATA_VERDICT &&
> +		    (elem.data.val.verdict.code == NFT_GOTO ||
> +		     elem.data.val.verdict.code == NFT_JUMP)) {
> +			nft_deactivate_set_chain_binding(set, elem.data.val.verdict.chain);
> +			nft_del_set_chain_binding(set, elem.data.val.verdict.chain);
> +		}
> +	}
>  err_parse_data:
>  	if (nla[NFTA_SET_ELEM_DATA] != NULL)
>  		nft_data_release(&elem.data.val, desc.type);
> @@ -8007,30 +8073,90 @@ static int nft_setelem_active_next(const struct net *net,
>  	return nft_set_elem_active(ext, genmask);
>  }
>  
> +static void nft_setelem_data_hold(const struct net *net,
> +				  const struct nft_set *set,
> +				  const struct nft_set_ext *ext)
> +{
> +	if (set->dtype == NFT_DATA_VERDICT) {
> +		struct nft_data *data = nft_set_ext_data(ext);
> +		struct nft_chain *chain;
> +
> +		switch (data->verdict.code) {
> +		case NFT_JUMP:
> +		case NFT_GOTO:
> +			chain = data->verdict.chain;
> +			nft_activate_set_chain_binding((struct nft_set *)set, chain);
> +			nft_use_inc_restore(&chain->use);
> +			break;
> +		}
> +	}
> +}
> +
>  static void nft_setelem_data_activate(const struct net *net,
> -				      const struct nft_set *set,
> +				      struct nft_set *set,
>  				      struct nft_elem_priv *elem_priv)
>  {
>  	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
>  
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
> -		nft_data_hold(nft_set_ext_data(ext), set->dtype);
> +		nft_setelem_data_hold(net, set, ext);
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
>  		nft_use_inc_restore(&(*nft_set_ext_obj(ext))->use);
>  }
>  
> +static void nft_setelem_data_release(struct nft_set *set,
> +				     const struct nft_set_ext *ext)
> +{
> +	struct nft_data *data = nft_set_ext_data(ext);
> +
> +	if (set->dtype == NFT_DATA_VERDICT) {
> +		struct nft_chain *chain;
> +
> +		switch (data->verdict.code) {
> +		case NFT_JUMP:
> +		case NFT_GOTO:
> +			chain = data->verdict.chain;
> +			nft_deactivate_set_chain_binding(set, chain);
> +			nft_use_dec(&chain->use);
> +			break;
> +		}
> +	}
> +}
> +
>  void nft_setelem_data_deactivate(const struct net *net,
> -				 const struct nft_set *set,
> +				 struct nft_set *set,
>  				 struct nft_elem_priv *elem_priv)
>  {
>  	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
>  
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
> -		nft_data_release(nft_set_ext_data(ext), set->dtype);
> +		nft_setelem_data_release(set, ext);
>  	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
>  		nft_use_dec(&(*nft_set_ext_obj(ext))->use);
>  }
>  
> +static void nft_setelem_data_abort(struct nft_set *set,
> +				   struct nft_elem_priv *elem_priv)
> +{
> +	struct nft_set_ext *ext;
> +
> +	ext = nft_set_elem_ext(set, elem_priv);
> +	if (set->dtype == NFT_DATA_VERDICT &&
> +	    nft_set_ext_exists(ext, NFT_SET_EXT_DATA)) {
> +		struct nft_data *data = nft_set_ext_data(ext);
> +		struct nft_chain *chain;
> +
> +		switch (data->verdict.code) {
> +		case NFT_JUMP:
> +		case NFT_GOTO:
> +			chain = data->verdict.chain;
> +			nft_deactivate_set_chain_binding(set, chain);
> +			nft_del_set_chain_binding(set, chain);
> +			break;
> +		}
> +	}
> +}
> +
>  /* similar to nft_trans_elems_remove, but called from abort path to undo newsetelem.
>   * No notifications and no ndeact changes.
>   *
> @@ -8057,6 +8183,7 @@ static bool nft_trans_elems_new_abort(const struct nft_ctx *ctx,
>  		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv))
>  			atomic_dec(&te->set->nelems);
>  
> +		nft_setelem_data_abort(te->set, te->elems[i].priv);
>  		removed = true;
>  	}
>  
> @@ -11290,6 +11417,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  		case NFT_MSG_DESTROYSET:
>  			nft_trans_set(trans)->dead = 1;
>  			list_del_rcu(&nft_trans_set(trans)->list);
> +			nft_del_set_chain_binding_all(nft_trans_set(trans));
>  			nf_tables_set_notify(&ctx, nft_trans_set(trans),
>  					     trans->msg_type, GFP_KERNEL);
>  			break;
> @@ -12258,9 +12386,10 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
>  	list_for_each_entry_safe(set, ns, &table->sets, list) {
>  		list_del(&set->list);
>  		nft_use_dec(&table->use);
> -		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
> +		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT)) {
>  			nft_map_deactivate(&ctx, set);
> -
> +			nft_del_set_chain_binding_all(set);
> +		}
>  		nft_set_destroy(&ctx, set);
>  	}
>  	list_for_each_entry_safe(obj, ne, &table->objects, list) {
> diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
> index 02ee5fb69871..0b886725ed37 100644
> --- a/net/netfilter/nft_immediate.c
> +++ b/net/netfilter/nft_immediate.c
> @@ -76,9 +76,16 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
>  		switch (priv->data.verdict.code) {
>  		case NFT_JUMP:
>  		case NFT_GOTO:
> -			err = nf_tables_bind_chain(ctx, chain);
> +			err = nft_add_chain_binding(ctx->chain, chain);
>  			if (err < 0)
>  				goto err1;
> +
> +			err = nf_tables_bind_chain(ctx, chain);
> +			if (err < 0) {
> +				nft_deactivate_chain_binding(ctx->chain, chain);
> +				nft_del_chain_binding(ctx->chain, chain);
> +				goto err1;
> +			}
>  			break;
>  		default:
>  			break;
> @@ -106,6 +113,8 @@ static void nft_immediate_activate(const struct nft_ctx *ctx,
>  		case NFT_JUMP:
>  		case NFT_GOTO:
>  			chain = data->verdict.chain;
> +			nft_activate_chain_binding(ctx->chain, chain);
> +
>  			if (!nft_chain_binding(chain))
>  				break;
>  
> @@ -152,6 +161,20 @@ static void nft_immediate_deactivate(const struct nft_ctx *ctx,
>  		case NFT_JUMP:
>  		case NFT_GOTO:
>  			chain = data->verdict.chain;
> +			switch (phase) {
> +			case NFT_TRANS_PREPARE_ERROR:
> +			case NFT_TRANS_PREPARE:
> +				nft_deactivate_chain_binding(ctx->chain, chain);
> +				break;
> +			case NFT_TRANS_ABORT:
> +			case NFT_TRANS_RELEASE:
> +				nft_deactivate_chain_binding(ctx->chain, chain);
> +				fallthrough;
> +			case NFT_TRANS_COMMIT:
> +				nft_del_chain_binding(ctx->chain, chain);
> +				break;
> +			}
> +
>  			if (!nft_chain_binding(chain))
>  				break;
>  
> -- 
> 2.30.2
> 
> 
> 
