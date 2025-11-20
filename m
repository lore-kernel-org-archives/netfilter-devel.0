Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334653207;
	Thu, 20 Nov 2025 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763671600; cv=none; b=OwMnKH44rygue4njsggfWPAlumDiA/rWMAjackYhDmBUtKynaXZDMlduJSRMu2V8WD12bzFMQjAVcFz5qilpScQhSMJTFkcRX7RMn9FI8+yKNSattZquU1ozewpZApiEMFwU7PN/0fh7cs26962NZ+PGP9SQAPVZCPebu0Y/DMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763671600; c=relaxed/simple;
	bh=izBrAjlVgZRf0Us0phgTwSLHliWZV0lMl2ZYQ9Stblw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5E6Vq0b4m/7dnxUWwN0TLAA5R4VkjmmZTN2+qtgysLhzmuNBrfhC3QNLcKC5C6evSDSEdZJslW9VS9z31dVHLpbD79UjEI1ZvMeTxkYvIgzDXJtwN54mH8UqgOQ54badxdjLCG/WMrQxzjdAg6r/RQsvRIHxXQszmkJ7zGzDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1B15660321; Thu, 20 Nov 2025 21:46:29 +0100 (CET)
Date: Thu, 20 Nov 2025 21:46:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR9-JDXdelaf0tGU@strlen.de>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
 <aR5ObjGO4SaD3GkX@calendula>
 <aR7grVC-kLg76kvE@strlen.de>
 <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> On Thu, Nov 20, 2025 at 10:34:46AM +0100, Florian Westphal wrote:
> > netfilter: nf_tables: avoid chain re-validation if possible
> > 
> > Consider:
> > 
> >       input -> j2 -> j3
> >       input -> j2 -> j3
> >       input -> j1 -> j2 -> j3
> > 
> > Then the second rule does not need to revalidate j2, and, by extension j3.
> > 
> > We need to validate it only for rule 3.
> > 
> > This is needed because chain loop detection also ensures we do not
> > exceed the jump stack: Just because we know that j2 is cycle free, its
> > last jump might now exceed the allowed stack.  We also need to update
> > the new largest call depth for all the reachable nodes.
> > 
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -1109,6 +1109,7 @@ struct nft_rule_blob {
> >   *	@udlen: user data length
> >   *	@udata: user data in the chain
> >   *	@blob_next: rule blob pointer to the next in the chain
> > + *	@depth: chain was validated for call level <= depth
> >   */
> >  struct nft_chain {
> >  	struct nft_rule_blob		__rcu *blob_gen_0;
> > @@ -1128,9 +1129,10 @@ struct nft_chain {
> >  
> >  	/* Only used during control plane commit phase: */
> >  	struct nft_rule_blob		*blob_next;
> > +	u8				depth;
> >  };
> >  
> > -int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
> > +int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
> >  int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
> >  			 const struct nft_set_iter *iter,
> >  			 struct nft_elem_priv *elem_priv);
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -4088,15 +4088,26 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
> >   * and set lookups until either the jump limit is hit or all reachable
> >   * chains have been validated.
> >   */
> > -int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
> > +int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
> >  {
> >  	struct nft_expr *expr, *last;
> >  	struct nft_rule *rule;
> >  	int err;
> >  
> > +	BUILD_BUG_ON(NFT_JUMP_STACK_SIZE > 255);
> >  	if (ctx->level == NFT_JUMP_STACK_SIZE)
> >  		return -EMLINK;
> >  
> > +	/* jumps to base chains are not allowed, this is already
> > +	 * validated by nft_verdict_init().
> > +	 *
> > +	 * Chain must be re-validated if we are entering for first
> > +	 * time or if the current jumpstack usage is higher than on
> > +	 * previous check.
> > +	 */
> > +	if (ctx->level && chain->depth >= ctx->level)
> > +		return 0;
> > +
> >  	list_for_each_entry(rule, &chain->rules, list) {
> >  		if (fatal_signal_pending(current))
> >  			return -EINTR;
> > @@ -4117,6 +4128,10 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
> >  		}
> >  	}
> >  
> > +	/* Chain needs no re-validation if called again
> > +	 * from a path that doesn't exceed level.
> > +	 */
> > +	chain->depth = ctx->level;
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(nft_chain_validate);
> > @@ -4128,7 +4143,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
> >  		.net	= net,
> >  		.family	= table->family,
> >  	};
> > -	int err;
> > +	int err = 0;
> >  
> >  	list_for_each_entry(chain, &table->chains, list) {
> >  		if (!nft_is_base_chain(chain))
> > @@ -4137,12 +4152,16 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
> >  		ctx.chain = chain;
> >  		err = nft_chain_validate(&ctx, chain);
> >  		if (err < 0)
> > -			return err;
> > +			goto err;
> >  
> >  		cond_resched();
> >  	}
> >  
> > -	return 0;
> > +err:
> > +	list_for_each_entry(chain, &table->chains, list)
> > +		chain->depth = 0;
> > +
> > +	return err;
> >  }
> >  
> >  int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
> 
> FWIW This patch seems to resolve the issue, assuming you intended to
> include the following:

Thanks for testing.  I will try to make this work universally next week
(this needs more work to keep a bitmask of base hook types for
 which we already validated this).  And we likely need to improve
existing test coverage, the above patch should fail the tests we have.
