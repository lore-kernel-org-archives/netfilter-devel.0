Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB7509F19
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792067501; cv=none; b=ktj9tZlv6/OfbmiJvKOgPtzgt7m6DqMIVpOlbPCJOaup/xL4GnmJn8etGGO494p9eS7Cpx5KeicWgcuRwLfaIozXVjsLiAKgcBDGtkoT3ZQtuMrghjCy1OXA380uMCnjP3H4X3Eg2Z+sFjXxHy4Xv/vAGByGaR6ESQWE+GfLvEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792067501; c=relaxed/simple;
	bh=eCKclns6UWmjJOm7lmZeaRr15DKrgzgSTveotaE6zyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ib7wfg3GmhggxF9ouLcCoaBjBgSY4p98fHGmTjilnU3US4cthaQ0PAHG/LJNxJapCVJThPxTbLsFMhYUuiGI40dJHp2eHjVeYEORlv/e7MsfSyaQw51V1jMzlrb2gySgK4B3A4ZAEYU/1gG9EmPrHgLnmnopqKtiCNNdIzR6o0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C27D4606E2; Thu, 15 Oct 2026 14:31:30 +0200 (CEST)
Date: Thu, 15 Oct 2026 14:31:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_ct: validate hook and priority
 for ct zone set
Message-ID: <atDHof0kFWIWIf6-@strlen.de>
References: <20261006231216.5570-1-fw@strlen.de>
 <as7EIFKyAqGTqRhC@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as7EIFKyAqGTqRhC@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
> > Assisted-by: LLM
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  This isn't nice/ideal, because this causes a test failure in
> >  tests/py (already resolved in master branch now).
> >  So, there is a risk of breakage.
> >  However, attaching the zone template after conntrack
> >  makes no sense at all and is actually harmful.
> 
> Would you consider simply turning this into noop if called used from
> the wrong hook if that is possible? Maybe that is a small patch?

Don't think its a smaller patch.  Unless I' missing something.
nf_hook_state only carries the hook location, not the priority.

AFAICS it would be a larger change. I'd have to:

> >  #ifdef CONFIG_NF_CONNTRACK_ZONES
> > +static int nft_ct_set_zone_validate(const struct nft_ctx *ctx,
> > +				    const struct nft_expr *expr)
> > +{
> > +	unsigned int hooks;
> > +	int err;
> > +
> > +	/* Setting the zone template only makes sense before conntrack has
> > +	 * assigned a zone to the packet, i.e. in prerouting and output,
> > +	 * and only if this rule runs before the conntrack hook itself.
> > +	 * Locally originated bridge traffic is conntrack'd by the IP stack,
> > +	 * not on the bridge, so only prerouting applies there.
> > +	 */
> > +	switch (ctx->family) {
> > +	case NFPROTO_IPV4:
> > +	case NFPROTO_IPV6:
> > +	case NFPROTO_INET:
> > +		hooks = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT);
> > +		break;
> > +	case NFPROTO_BRIDGE:
> > +		hooks = (1 << NF_INET_PRE_ROUTING);
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	err = nft_chain_validate_hooks(ctx->chain, hooks);
> > +	if (err)
> > +		return err;
> > +
> > +	if (nft_is_base_chain(ctx->chain)) {
> > +		const struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
> > +
> > +		if (basechain->type->type == NFT_CHAIN_T_NAT ||
> > +		    basechain->ops.priority >= NF_IP_PRI_CONNTRACK)
> > +			return -EOPNOTSUPP;

Change all the errs here to remove the 'const', then toggle expr->priv
to say 'do not do anything'.

I'd also have to alter nf_tables_api.c so that it treats the validation
as soft-fail and not cache the successful result if the hook or prio
was bad.

At that point I wonder if it would make more sense to explore a
'ditch this expression, pretend it never happened'...
