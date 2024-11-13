Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230451AC427
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 11:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731496289; cv=none; b=IwLhk71AMVzyj3pQMazjhULCaHsfPPq7mgrMJr0UK4Mzn7fxgQLYHLQqs3352VAkmk09nhabTrZcat/0GagA0Ks2NPzp34AE8eJ5Be/unOS9Xrt2zdMZCPWj+UdXH0E2l/UZcDYqwiCH/r0ovBn6HBtijcWTmIOYik7yapBYfTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731496289; c=relaxed/simple;
	bh=wF2fzFPSRkc1ekaBzwQ3yFkHSYoUbQ2BF14xy3Zw+ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxsGP5lLZUMkyPhn6P8osRGGrx+1md9Zqy5uBU+NHiCzrLnb3qg2JuuGV+ECP5rx9LU92gM7teS+GGw8lrN7dtwJVEcr+cs9ekZy0QxOziu+zccHSWgpLsV+GkcNlgHBA0YIt5kB/3YQCGBxf3yKjCoRI9voJ4G5YVbCQLaMlMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60100 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBBHO-00DrB9-Dk; Wed, 13 Nov 2024 12:11:24 +0100
Date: Wed, 13 Nov 2024 12:11:21 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 4/5] netfilter: nf_tables: switch trans_elem
 to real flex array
Message-ID: <ZzSJWQQkuS4T4AOn@calendula>
References: <20241107174415.4690-1-fw@strlen.de>
 <20241107174415.4690-5-fw@strlen.de>
 <ZzR8W7oQ_3wD-osu@calendula>
 <20241113110405.GA19651@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241113110405.GA19651@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Wed, Nov 13, 2024 at 12:04:05PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I'm making another pass on this series, a few thing I would like to
> > ask, see below.
> > 
> > On Thu, Nov 07, 2024 at 06:44:08PM +0100, Florian Westphal wrote:
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index bdf5ba21c76d..e96e538fe2eb 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -25,6 +25,7 @@
> > >  
> > >  #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
> > >  #define NFT_SET_MAX_ANONLEN 16
> > > +#define NFT_MAX_SET_NELEMS ((2048 - sizeof(struct nft_trans_elem)) / sizeof(struct nft_trans_one_elem))
> > 
> > This NFT_MAX_SET_NELEMS is to stay in a specific kmalloc-X?
> > 
> > What is the logic behind this NFT_MAX_SET_NELEMS?
> 
> I want to avoid making huge kmalloc requests, plus avoid huge krealloc
> overhead.
> 
> I think that kmalloc-2048 slab is a good fit.
> I can add a comment, or increase to kmalloc-4096 but I'd prefer to
> not go over that, since kmalloc allocations > 1 page are more prone
> to allocation failure.

Makes sense as it is now, thanks for explaining.

> > >  unsigned int nf_tables_net_id __read_mostly;
> > >  
> > > @@ -391,6 +392,69 @@ static void nf_tables_unregister_hook(struct net *net,
> > >  	return __nf_tables_unregister_hook(net, table, chain, false);
> > >  }
> > >  
> > > +static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a, const struct nft_trans_elem *b)
> > > +{
> > > +	return a->set == b->set && a->bound == b->bound && a->nelems < NFT_MAX_SET_NELEMS;
> > 
> > I think this a->bound == b->bound check defensive.
> > 
> > This code is collapsing only two consecutive transactions, the one at
> > the tail (where nelems > 1) and the new transaction (where nelems ==
> > 1).
> 
> Yes.
> 
> > bound state should only change in case there is a NEWRULE transaction
> > in between.
> 
> Yes.
> 
> > I am trying to find a error scenario where a->bound == b->bound
> > evaluates false. I considered the following:
> > 
> >    newelem -> newrule -> newelem
> > 
> > where newrule has these expressions:
> > 
> >    lookup -> error
> > 
> > in this case, newrule error path is exercised:
> > 
> >    nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
> > 
> > this calls nf_tables_deactivate_set() that calls
> > nft_set_trans_unbind(), then a->bound is restored to false. Rule is
> > released and no transaction is added.
> > 
> > Because if this succeeds:
> > 
> >    newelem -> newrule -> newelem
> > 
> > then no element collapsing can happen, because we only collapse what
> > is at the tail.
> > 
> > TLDR; Check does not harm, but it looks unlikely to happen to me.
> 
> Yes, its defensive check.  I could add a comment.

Please, do it so we don't forget about this subtle detail.

> The WARN_ON_ONCE for trans->nelems != 1 exists for same reason.

Right.

> > > +}
> > > +
> > > +static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
> > > +					struct nft_trans_elem *tail,
> > > +					struct nft_trans_elem *trans,
> > > +					gfp_t gfp)
> > > +{
> > > +	unsigned int nelems, old_nelems = tail->nelems;
> > > +	struct nft_trans_elem *new_trans;
> > > +
> > > +	if (!nft_trans_collapse_set_elem_allowed(tail, trans))
> > > +		return false;
> > > +
> > > +	if (WARN_ON_ONCE(trans->nelems != 1))
> > > +		return false;
> > > +
> > > +	if (check_add_overflow(old_nelems, trans->nelems, &nelems))
> > > +		return false;
> > > +
> > > +	/* krealloc might free tail which invalidates list pointers */
> > > +	list_del_init(&tail->nft_trans.list);
> > > +
> > > +	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
> > > +	if (!new_trans) {
> > > +		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
> > > +		return false;
> > > +	}
> > > +
> > > +	INIT_LIST_HEAD(&new_trans->nft_trans.list);
> > 
> > This initialization is also defensive, this element is added via
> > list_add_tail().
> 
> Yes, the first arg to list_add(_tail) can live without initialisation.

Let's remove it then.

Would you submit a new revision with all these little nitpicks?

Then you also have a chance to edit your explaination on the audit
aspect of this series.

If you are busy with other stuff I can take a look here, just let me know.

Thanks.
