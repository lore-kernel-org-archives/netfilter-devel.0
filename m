Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82E14F9D6
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 00:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763512057; cv=none; b=WsEunBOc/ErkOOCAvhUlBf+8Qk2DbXuvr45gxyWoHYKOKLNbgdJ0Ohrx7a/mtJbU0uqmecJdKoSmqvi9pGD19IWAME04KIdLX7Tr7LywPNKAids3wKaiOk+dlrvPit1Ddhh+wtWPmiXens6X5qHKbvQxQreRKuilXkSvxQf/uJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763512057; c=relaxed/simple;
	bh=woNNHahaDx6I8cLeQgEwizLoba8ZhxrreZN4jGmKI2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkwcLvT17RrUQ4x6MCCIE2/1x9R87MGquqZl1dzdzWNWS4yxKHZFsPnqpcArYRz5kT1sFjJaisc8HLU3Qg8aWSP1ldD2uklR1cTBp92otnZbfV+Xr+AYdc1JRL+c4dsvWHyncAuY3mL/SEFFWr4GwZE6gjNdgjcPjkI2yYU1BJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uIkxSS8r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uIkxSS8r"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 74F906026B;
	Wed, 19 Nov 2025 01:27:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763512053;
	bh=2ZpAYYuKiWSPa6veoOTtQ43fCO2piS+ozv9H/shdfbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uIkxSS8rCYVshn+cZH0ov9ZR5KQzDLUB5bY0MWd/zdNcKzjVTGJY+UlSVF2sJr1fF
	 Vvx/piGgFAqdQksfdQ+l7/zRqslJ8inE/xS9owZUQfYv7E/2i4VlZYU6eqXZ+j8A7w
	 uxVSjGNAwR9+Uprefsj8AJIdeQSNmHVao3VjRJ+/1Cu1G7cOfoZC0s1ADhqW6BRq3q
	 KS9p+mRnkG1fBMb6OiaS/XYkwhsIHkiNv6okHRRaIX4A3LIk232jBb7rw1w5juiRzb
	 eXIwmmwgldHSNE7GtHGD6MBAHLAe/NYfvk0FBRgRZmg3KKDIkZiQ0QRuNhVPMrfKb4
	 QQbPoiyKcIWtw==
Date: Wed, 19 Nov 2025 01:27:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: skip register
 jump/goto validation for non-base chain
Message-ID: <aR0O8y55ceCmrIHf@calendula>
References: <20251118235009.149562-1-pablo@netfilter.org>
 <aR0Jh0XH3FyqGr2k@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aR0Jh0XH3FyqGr2k@strlen.de>

On Wed, Nov 19, 2025 at 01:04:23AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Validating a non-base chain for each register store slows down
> > validation unnecessarily, remove it.
> > 
> > Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 6f35f0b7a33c..bef95cede7b5 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -11846,6 +11846,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
> >  		if (data != NULL &&
> >  		    (data->verdict.code == NFT_GOTO ||
> >  		     data->verdict.code == NFT_JUMP)) {
> > +			if (!nft_is_base_chain(ctx->chain))
> > +				break;
> > +
> 
> This is confusing.  ctx->chain? data->verdict.chain?

ctx->chain is the current chain for this new rule.

data->verdict.chain is the destination chain.

> Wouldn't it make more sense to elide the check if we have
> ctx->table->validate_state != NFT_VALIDATE_DO ?

I am sure we have to skip non-basechains in this case, it makes us
walk the graph for no reason, even with NFT_VALIDATE_DO.

Let me have a second look, thanks for reviewing.
