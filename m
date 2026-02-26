Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344E21257F;
	Thu, 26 Feb 2026 08:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772093987; cv=none; b=hTRFSRtA6zrk9K7JzZwFzVm3TbAk210f6pM4cCnwBo2fsg9hLEc15Hru/aLOVFK6D3F6SE3zezbEm13LHX0FIBXlb61TRG9XEd8robqPrX/yytlKUn3PjGzUaqZo+4fzStaWLiaT6d8uGZjCOHV5g99o5tI78dWb5qSUorph/k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772093987; c=relaxed/simple;
	bh=UOdr0YdySebAL3nUGKP+jYMkmSYHSLg1dq+rJa8mkI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3P5DNwZ1lqAfo60A8SG9gkL+eb3+fW/BDsGYpy4Gac2invLfs+swwTRmKsBXumok3GB4BppsMhgMdQXOjFZAMKl6c0dK96jQo3L9yGXSR3MX4B1ZjPGCTnY2pL4wtx66+PDL1sjRI295BEmAKb41//VXdKiqzEkbz6l7b8BcyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3579160516; Thu, 26 Feb 2026 09:19:38 +0100 (CET)
Date: Thu, 26 Feb 2026 09:19:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [net,2/2] netfilter: nf_tables: unconditionally bump set->nelems
 before insertion
Message-ID: <aaACGbUnAyQiV3ut@strlen.de>
References: <20260225130619.1248-3-fw@strlen.de>
 <20260226035628.1827287-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226035628.1827287-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email says "Is this legit?"

Looks legit to me.

> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> ---
> netfilter: nf_tables: unconditionally bump set->nelems before insertion
> 
> This commit addresses a race condition where a new element gets published
> then removed without waiting for the RCU grace period when the set is full.
> The fix moves the nelems increment before insertion and adds cleanup logic
> using the abort path to safely unwind the set.
> 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 0c5a4855b97d..834736237b09 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  	struct nft_data_desc desc;
> >  	enum nft_registers dreg;
> >  	struct nft_trans *trans;
> > +	bool set_full = false;
> >  	u64 expiration;
> >  	u64 timeout;
> >  	int err, i;
> > @@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  	if (err < 0)
> >  		goto err_elem_free;
> >
> > +	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> > +		unsigned int max = nft_set_maxsize(set), nelems;
> > +
> > +		nelems = atomic_inc_return(&set->nelems);
> > +		if (nelems > max)
> > +			set_full = true;
> > +	}
> > +
> >  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
> >  	if (trans == NULL) {
> >  		err = -ENOMEM;
> > -		goto err_elem_free;
> > +		goto err_set_size;
> >  	}
> >
> >  	ext->genmask = nft_genmask_cur(ctx->net);
> > @@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >
> >  					ue->priv = elem_priv;
> >  					nft_trans_commit_list_add_elem(ctx->net, trans);
> > -					goto err_elem_free;
> > +					goto err_set_size;
> >  				}
> >  			}
> >  		}
> > @@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  		goto err_element_clash;
> >  	}
> >
> > -	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> > -		unsigned int max = nft_set_maxsize(set);
> > -
> > -		if (!atomic_add_unless(&set->nelems, 1, max)) {
> > -			err = -ENFILE;
> > -			goto err_set_full;
> > -		}
> > -	}
> > -
> >  	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
> >  	nft_trans_commit_list_add_elem(ctx->net, trans);
> > -	return 0;
> >
> > -err_set_full:
> > -	nft_setelem_remove(ctx->net, set, elem.priv);
> > +	return set_full ? -ENFILE : 0;
> > +
> >  err_element_clash:
> >  	kfree(trans);
> > +err_set_size:
> > +	if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
> > +		atomic_dec(&set->nelems);
> 
> Does this properly handle the element update path when the set is full?

Pablo, why does that check !set_full?  The increment is unconditional,
so why is the decrement asymmetric?

err_set_size:
        if (!(flags & NFT_SET_ELEM_CATCHALL))
                atomic_dec(&set->nelems);

?
