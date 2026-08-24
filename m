Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDA53F0AA7;
	Mon, 24 Aug 2026 12:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574002; cv=none; b=FOhmV9+3xDWquxC6lUDJYxESx3h1CjDjrC6dOVyHyDfEJ4otVUO1LiFcnjVMvKZbooJsplcgt0d1EH8Wzy+ZcjUBvtrNETfeyXFeSbVCSQ7LakCAuZezLq48tobXiwdyYNngwTYrLHyJSMLwqH0yNQeHF+7U8HT/G8NgTgbbmYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574002; c=relaxed/simple;
	bh=opTZ7lVEH+jzvnLB1aiyVzlVVVT5tVhVSbTAsRWRjOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JmVMC9Ny0pOWc6EIL4hU3sUKBP0vTIPiWByWfUvhgLwcaAZdqNXy+7xXAxUuWMnh6wKCt57Zx25O5qLJEc520Bs+/odVmNpPeqZwROHrPa3VXyKxiYGME4tD11R6YJv3/lYDbyvQ8FH8aY4vmZFBYPa+YxfFHCkhQ2MMoP4sXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z5fYJL54; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z5fYJL54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787573997;
	bh=Z9Z9GH+NdlFtTu/QhjEgtWWtmqLQNfpxyiAgkg/Ek2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z5fYJL54mxuI+tikpOMcNyNzFEgDubju5MQHDJqwSNDSxemi9XFetmILDrzASBSB8
	 g0UzqTYWnxeuh1k7QZI3HrPJHXYdx6Zh47nJRQd0mOeXLQN/V43zvSTFLLCEputKQ0
	 cs29Nvx/6gTtXvvCA8Eo6ebGbYnrGyeruNdFXB344rMUXwDH9IQ75yGPiOpLwSWcmI
	 yrikjXceAp5/WAREdI1LG1aMDymfwxLCFrLfMRMQhk2spGygYE0RMAu3NuRHTThYX6
	 yE59YkDLe8ggpYPWaFelQWHgcexvDHNbEPWT5VIFvZCSSc5sTlJsUwd3C1pSLH14sK
	 /cDfRBm2EOmGw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7CA82601C4;
	Mon, 24 Aug 2026 14:19:57 +0200 (CEST)
Date: Mon, 24 Aug 2026 14:19:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 07/10] netfilter: nf_tables: skip double clone set
 expressions on element insert
Message-ID: <aow26yHSKQONZTt-@chamomile>
References: <20260821153833.245589-8-pablo@netfilter.org>
 <20260822195228.2202729-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260822195228.2202729-1-kuba@kernel.org>

On Sat, Aug 22, 2026 at 12:52:28PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: nf_tables: skip double clone set expressions on element insert
> 
> This adds an override_exprs flag so that the dynset and newsetelem paths
> borrow the set's expressions instead of cloning them when userspace does
> not supply an override, and releases the expression array only when it
> really is an override.  The same flag is now used to decide whether the
> dynset expression override is dumped back to userspace.
> 
> > diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> > index ee9d3e7b1ecf1..fa4da694e92d8 100644
> > --- a/net/netfilter/nft_dynset.c
> > +++ b/net/netfilter/nft_dynset.c
> > @@ -19,7 +19,8 @@ struct nft_dynset {
> >  	u8				sreg_key;
> >  	u8				sreg_data;
> >  	bool				invert;
> > -	bool				expr;
> > +	bool				expr:1,
> > +					override_exprs:1;
> >  	u8				num_exprs;
> >  	u64				timeout;
> >  	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
> 
> [ ... ]
> 
> > @@ -393,7 +398,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
> >  			 nf_jiffies64_to_msecs(priv->timeout),
> >  			 NFTA_DYNSET_PAD))
> >  		goto nla_put_failure;
> > -	if (priv->set->num_exprs == 0) {
> > +	if (priv->set->num_exprs == 0 || priv->override_exprs) {
> >  		if (priv->num_exprs == 1) {
> >  			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
> >  					  priv->expr_array[0], reset))
> 
> [Severity: Medium]
> Can the message emitted by nft_dynset_dump() after this change be rejected
> by nft_dynset_init() when it is replayed?
> 
> With the widened condition, a dynset attached to a set that owns
> expressions (set->num_exprs > 0) now dumps its override.  For
> priv->num_exprs > 1 that override is emitted as an NFTA_DYNSET_EXPRESSIONS
> nest:
> 
> net/netfilter/nft_dynset.c:nft_dynset_dump() {
> 	...
> 	u32 flags = priv->invert ? NFT_DYNSET_F_INV : 0;
> 	...
> 	} else if (priv->num_exprs > 1) {
> 		struct nlattr *nest;
> 
> 		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
> 	...
> 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
> 	...
> }
> 
> The dumped NFTA_DYNSET_FLAGS is computed only from priv->invert, so
> NFT_DYNSET_F_EXPR is never set, even though priv->expr records that
> userspace passed it at creation time.  On the parse side the
> NFTA_DYNSET_EXPRESSIONS branch requires that flag:
> 
> net/netfilter/nft_dynset.c:nft_dynset_init() {
> 	...
> 	} else if (tb[NFTA_DYNSET_EXPRESSIONS]) {
> 		...
> 		if (!priv->expr)
> 			return -EINVAL;
> 	...
> }
> 
> So a rule with two override expressions on an NFT_SET_EVAL set that also
> has two set expressions (for example counter plus quota) appears to be
> dumped in a form that the kernel's own parser refuses with -EINVAL when the
> netlink message is sent back (raw netlink echo, or libnftnl parse-then-build
> restore paths).  Before this patch that configuration emitted no expression
> attributes at all, so the replay was accepted and silently fell back to the
> set's expressions.
> 
> The missing NFT_DYNSET_F_EXPR in the dump path predates this patch (it is
> already reachable for priv->set->num_exprs == 0 with more than one
> expression), but the new condition extends the asymmetry to
> override-on-eval-set rules that used to round-trip.  Should
> nft_dynset_dump() also report NFT_DYNSET_F_EXPR when priv->expr is set?

This sounds like a theotical issue:

1) Example with one single expression.

table ip x {
        set y {
                typeof ip saddr
                flags dynamic
                ct count over 2
        }
 
        chain z {
                update @y { ip saddr ct count over 3 }
        }
}

2) Example with two expressions

table ip x {
        set y {
                typeof ip saddr
                flags dynamic
                counter ct count over 2
        }
 
        chain z {
                update @y { ip saddr counter ct count over 3 }
        }
}

It works fine with userspace 'nft'.

It might be a correctness API issue to guarantee this symmetry, but we
can follow up.
