Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2464611E4;
	Thu, 26 Feb 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772123295; cv=none; b=MFuuITmqrp9Uem1byMOMBNoTxtvgCtMPfNgXI6VBgBxBHfmvGymXrfoxUZKvpkEQfiOxcEC3cAfj1v2t43KUKq4mQhsIMjIJk/50mqVrYv8CQwZHb8W+alulmOf2UBSeYrFcTJ7/yNSos5WGlvJGv0ujo0u3R6dG7QVrBj4gEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772123295; c=relaxed/simple;
	bh=t0YhMQcTRqqz7VAWaqeXrGRbRRGHThL5IzxxFl0ro+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i56mwesxqwpq2oW1//IY4R2zrgL8E6IbxoX6G986htVfdICWrd8LQmd1fMXp2Nuk/VByWmVdxPamg4OoN/g6y+7FWJzbhn0H8f0UOLmBLDNr+c2JbDVosEhNwDleyp1NH5jZkZy3rCDba8RoxsfggC2b6ILWSgoQLt8zGn+O8H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d6h8Xq5Z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d6h8Xq5Z"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3E3B36017D;
	Thu, 26 Feb 2026 17:28:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772123284;
	bh=jlOcR6Y3a6C/KGArtUcehSOzJcCDI6qSxwukm5/E1to=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6h8Xq5ZwNSqK3JfAjZ9GcLpnJ05bQRSvNb0RjWhvA0szllq3b4AIhtFNwkwwCNJS
	 4gHB5bHfB8LXheYT2edYtQPJdEWb2jMLHXFK2w74KZzKJFYh/nboUEb7ttwh4NpurG
	 45iD4RkEx6r/zlnRHaob3BIGczzwr9PfNatyOiEH7j/CyYiYZoSU/1pM7JEEuWoiDL
	 FKytiE2QwcuJxkPS8cYd6m4zs9DKTedFKv2NXJevkXn4hovCcvrnJfbnidrnOuuR+i
	 +WHQSff+XhPoZ/fjsymKkHdPnHsySegHZYXpUvuTxn7s9Btyu3Hbo0V+ily2Nt4gCN
	 4rRc1wS+/OTew==
Date: Thu, 26 Feb 2026 17:28:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [net,2/2] netfilter: nf_tables: unconditionally bump set->nelems
 before insertion
Message-ID: <aaB0kaSgbnSgVFBE@chamomile>
References: <20260225130619.1248-3-fw@strlen.de>
 <20260226035628.1827287-1-kuba@kernel.org>
 <aaACGbUnAyQiV3ut@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaACGbUnAyQiV3ut@strlen.de>

On Thu, Feb 26, 2026 at 09:19:37AM +0100, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email says "Is this legit?"
> 
> Looks legit to me.
> 
> > For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> > ---
> > netfilter: nf_tables: unconditionally bump set->nelems before insertion
> > 
> > This commit addresses a race condition where a new element gets published
> > then removed without waiting for the RCU grace period when the set is full.
> > The fix moves the nelems increment before insertion and adds cleanup logic
> > using the abort path to safely unwind the set.
> > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 0c5a4855b97d..834736237b09 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> > >  	struct nft_data_desc desc;
> > >  	enum nft_registers dreg;
> > >  	struct nft_trans *trans;
> > > +	bool set_full = false;
> > >  	u64 expiration;
> > >  	u64 timeout;
> > >  	int err, i;
> > > @@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> > >  	if (err < 0)
> > >  		goto err_elem_free;
> > >
> > > +	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> > > +		unsigned int max = nft_set_maxsize(set), nelems;
> > > +
> > > +		nelems = atomic_inc_return(&set->nelems);
> > > +		if (nelems > max)
> > > +			set_full = true;
> > > +	}
> > > +
> > >  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
> > >  	if (trans == NULL) {
> > >  		err = -ENOMEM;
> > > -		goto err_elem_free;
> > > +		goto err_set_size;
> > >  	}
> > >
> > >  	ext->genmask = nft_genmask_cur(ctx->net);
> > > @@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> > >
> > >  					ue->priv = elem_priv;
> > >  					nft_trans_commit_list_add_elem(ctx->net, trans);
> > > -					goto err_elem_free;
> > > +					goto err_set_size;
> > >  				}
> > >  			}
> > >  		}
> > > @@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> > >  		goto err_element_clash;
> > >  	}
> > >
> > > -	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> > > -		unsigned int max = nft_set_maxsize(set);
> > > -
> > > -		if (!atomic_add_unless(&set->nelems, 1, max)) {
> > > -			err = -ENFILE;
> > > -			goto err_set_full;
> > > -		}
> > > -	}
> > > -
> > >  	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
> > >  	nft_trans_commit_list_add_elem(ctx->net, trans);
> > > -	return 0;
> > >
> > > -err_set_full:
> > > -	nft_setelem_remove(ctx->net, set, elem.priv);
> > > +	return set_full ? -ENFILE : 0;
> > > +
> > >  err_element_clash:
> > >  	kfree(trans);
> > > +err_set_size:
> > > +	if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
> > > +		atomic_dec(&set->nelems);
> > 
> > Does this properly handle the element update path when the set is full?
> 
> Pablo, why does that check !set_full?  The increment is unconditional,
> so why is the decrement asymmetric?
> 
> err_set_size:
>         if (!(flags & NFT_SET_ELEM_CATCHALL))
>                 atomic_dec(&set->nelems);
> 
> ?

I think so, this is a leftover from initial patches that where still
using conditional atomic_add_unless().

I'm preparing a re-spin.
