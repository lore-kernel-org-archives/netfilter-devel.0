Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516B126AEC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731495850; cv=none; b=dsXqfZuRiFSPq7QQxs0BrhNcF2o0gwtZyyy0QtjyIt+umR/VdB1LDC3kq761inaMsnTqeyA2zoDll30Xz0D9muL441d6KEc3M8AlBSpivB5HhNau4yzKkt4Vx/toyusUi40oqfwrFqhs4Mx2kbjVY+iIuK2TRuSSyoCyVeSSOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731495850; c=relaxed/simple;
	bh=t275FfR2CrHSuDBgQFiewPSWXuvaSwA0ku0pUFTMYkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GaAjOCM3OFx5y87Lcpw580OZ1vY0+iBEGH3JWTkjk2tNdpKMe2O2MhG0KNl1ljPiQAKPIHFdE6mZ/qjtOVMC41OzdrLVYGKSRbS7JaEb7xmFHd/HuzbejWHTlxdYqiismZg1ki/ViRjiDCAWpEjHFuKvoK/6DuHS3z1DNUeQDKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tBBAL-00059m-5E; Wed, 13 Nov 2024 12:04:05 +0100
Date: Wed, 13 Nov 2024 12:04:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 4/5] netfilter: nf_tables: switch trans_elem
 to real flex array
Message-ID: <20241113110405.GA19651@breakpoint.cc>
References: <20241107174415.4690-1-fw@strlen.de>
 <20241107174415.4690-5-fw@strlen.de>
 <ZzR8W7oQ_3wD-osu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzR8W7oQ_3wD-osu@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'm making another pass on this series, a few thing I would like to
> ask, see below.
> 
> On Thu, Nov 07, 2024 at 06:44:08PM +0100, Florian Westphal wrote:
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index bdf5ba21c76d..e96e538fe2eb 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -25,6 +25,7 @@
> >  
> >  #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
> >  #define NFT_SET_MAX_ANONLEN 16
> > +#define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
> 
> This NFT_MAX_SET_NELEMS is to stay in a specific kmalloc-X?
> 
> What is the logic behind this NFT_MAX_SET_NELEMS?

I want to avoid making huge kmalloc requests, plus avoid huge krealloc
overhead.

I think that kmalloc-2048 slab is a good fit.
I can add a comment, or increase to kmalloc-4096 but I'd prefer to
not go over that, since kmalloc allocations > 1 page are more prone
to allocation failure.

> >  unsigned int nf_tables_net_id __read_mostly;
> >  
> > @@ -391,6 +392,69 @@ static void nf_tables_unregister_hook(struct net *net,
> >  	return __nf_tables_unregister_hook(net, table, chain, false);
> >  }
> >  
> > +static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
> > +{
> > +	return a->set == b->set && a->bound == b->bound && a->nelems < NFT_MAX_SET_NELEMS;
> 
> I think this a->bound == b->bound check defensive.
> 
> This code is collapsing only two consecutive transactions, the one at
> the tail (where nelems > 1) and the new transaction (where nelems ==
> 1).

Yes.

> bound state should only change in case there is a NEWRULE transaction
> in between.

Yes.

> I am trying to find a error scenario where a->bound == b->bound
> evaluates false. I considered the following:
> 
>    newelem -> newrule -> newelem
> 
> where newrule has these expressions:
> 
>    lookup -> error
> 
> in this case, newrule error path is exercised:
> 
>    nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
> 
> this calls nf_tables_deactivate_set() that calls
> nft_set_trans_unbind(), then a->bound is restored to false. Rule is
> released and no transaction is added.
> 
> Because if this succeeds:
> 
>    newelem -> newrule -> newelem
> 
> then no element collapsing can happen, because we only collapse what
> is at the tail.
> 
> TLDR; Check does not harm, but it looks unlikely to happen to me.

Yes, its defensive check.  I could add a comment.
The WARN_ON_ONCE for trans->nelems != 1 exists for same reason.

> > +}
> > +
> > +static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
> > +					struct nft_trans_elem *tail,
> > +					struct nft_trans_elem *trans,
> > +					gfp_t gfp)
> > +{
> > +	unsigned int nelems, old_nelems = tail->nelems;
> > +	struct nft_trans_elem *new_trans;
> > +
> > +	if (!nft_trans_collapse_set_elem_allowed(tail, trans))
> > +		return false;
> > +
> > +	if (WARN_ON_ONCE(trans->nelems != 1))
> > +		return false;
> > +
> > +	if (check_add_overflow(old_nelems, trans->nelems, &nelems))
> > +		return false;
> > +
> > +	/* krealloc might free tail which invalidates list pointers */
> > +	list_del_init(&tail->nft_trans.list);
> > +
> > +	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
> > +	if (!new_trans) {
> > +		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
> > +		return false;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&new_trans->nft_trans.list);
> 
> This initialization is also defensive, this element is added via
> list_add_tail().

Yes, the first arg to list_add(_tail) can live without initialisation.
