Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804C3468E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716197500; cv=none; b=fqaHAhrGRG1EyVQM4L4gEoqPsFLrBOZ2SKueTRV/lKkonyJdnSBYtIiny6Vkhur2mRDbLosvAKi55BUypJCwbCoiayddsTkwKS+7SgbTS62Bztog+NSSyhFPYzwQHd/HRzexjGIQj+uGHkDN4l2aAqqxfkK2UPFGAE9dxqZdkfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716197500; c=relaxed/simple;
	bh=KM/T4oCmKBqH/vmYh5IDQYiwL1HFsfxRptxsvqJr5dQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KYdH+Z56vx9gPaIkXhHIn5fgo2jnmSOJWJzDFD43aUkSe64Wjmfj7g+MUrpUlyg9g/sGc/hViYYEDBnX1jW2ugTmmwT5br8QbQEQx7fKGYS18sTJwyiEzI33gInCK66UBbggBSoc7NO4+15zArXn/77uxfGOHhAUNZC8oEG1jto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 20 May 2024 11:31:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netfilter: nft_fib: allow from forward/input
 without iif selector
Message-ID: <ZksYbtxMGS1UUqev@calendula>
References: <20240517153807.90267-1-eric@garver.life>
 <Zkd7VaibVl_KGLMq@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zkd7VaibVl_KGLMq@egarver-mac>

Hi Eric,

On Fri, May 17, 2024 at 11:44:21AM -0400, Eric Garver wrote:
> This is of course for nf-next, not net-next. I failed to update the
> subject after sending it to the wrong list.

Thanks for your patch. Alternatively, I can place this in nf.git instead:

  Fixes: be8be04e5ddb ("netfilter: nft_fib: reverse path filter for policy-based routing on iif")

> On Fri, May 17, 2024 at 11:38:06AM -0400, Eric Garver wrote:
> > This removes the restriction of needing iif selector in the
> > forward/input hooks for fib lookups when requested result is
> > oif/oifname.
> > 
> > Removing this restriction allows "loose" lookups from the forward hooks.
> > 
> > Signed-off-by: Eric Garver <eric@garver.life>
> > ---
> >  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +--
> >  net/ipv6/netfilter/nft_fib_ipv6.c | 3 +--
> >  net/netfilter/nft_fib.c           | 8 +++-----
> >  3 files changed, 5 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> > index 9eee535c64dd..975a4a809058 100644
> > --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> > +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> > @@ -116,8 +116,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  		fl4.daddr = iph->daddr;
> >  		fl4.saddr = get_saddr(iph->saddr);
> >  	} else {
> > -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> > -		    priv->flags & NFTA_FIB_F_IIF)
> > +		if (nft_hook(pkt) == NF_INET_FORWARD)
> >  			fl4.flowi4_iif = nft_out(pkt)->ifindex;
> >  
> >  		fl4.daddr = iph->saddr;
> > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> > index 36dc14b34388..f95e39e235d3 100644
> > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > @@ -30,8 +30,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
> >  		fl6->daddr = iph->daddr;
> >  		fl6->saddr = iph->saddr;
> >  	} else {
> > -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> > -		    priv->flags & NFTA_FIB_F_IIF)
> > +		if (nft_hook(pkt) == NF_INET_FORWARD)
> >  			fl6->flowi6_iif = nft_out(pkt)->ifindex;
> >  
> >  		fl6->daddr = iph->saddr;
> > diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> > index 37cfe6dd712d..b58f62195ff3 100644
> > --- a/net/netfilter/nft_fib.c
> > +++ b/net/netfilter/nft_fib.c
> > @@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
> >  	switch (priv->result) {
> >  	case NFT_FIB_RESULT_OIF:
> >  	case NFT_FIB_RESULT_OIFNAME:
> > -		hooks = (1 << NF_INET_PRE_ROUTING);
> > -		if (priv->flags & NFTA_FIB_F_IIF) {
> > -			hooks |= (1 << NF_INET_LOCAL_IN) |
> > -				 (1 << NF_INET_FORWARD);
> > -		}
> > +		hooks = (1 << NF_INET_PRE_ROUTING) |
> > +			(1 << NF_INET_LOCAL_IN) |
> > +			(1 << NF_INET_FORWARD);
> >  		break;
> >  	case NFT_FIB_RESULT_ADDRTYPE:
> >  		if (priv->flags & NFTA_FIB_F_IIF)
> > -- 
> > 2.43.0
> > 
> > 
> 
