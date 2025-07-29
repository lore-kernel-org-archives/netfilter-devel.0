Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C981758B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 13:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753794299; cv=none; b=nofydYspUzoAJqVFAqaWIhLL/ADdevBVotF4nmS1Sgrv+hthHBp+Socb7R5uSj9y5Y++VdjTKt4EQUbFtmsIoxQ00K45bKK3FzXrBOh5UUCTCWwNYK7fnjqbXVr7mIkssJ5dssvzi4IHOYYTppu4aFfQL1DBrzYax/e7LCrt5Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753794299; c=relaxed/simple;
	bh=RJR9vMX4OPQGe8I0/V9mpUSiGAP94l0MKhZU2hfnCHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTjf+59uHqrR6Kg52fzpGXOeTZkf2qZjQcRq7Q8mWn3NvN0dCH2wiUGaY1zunj7IPDdU/e9j6gusfFoNgDdywLApXkObtmfwuzBEwcqnvmnv4gmLS3/qx1hlN8Oh8gdDgcfRi9OsyV7L89QyAFT/Sz5ZxcyUceLYNjF50Y72a0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aZCV/xja; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aZCV/xja"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GDWVs0cAN065VICiB/h/oRMKzoHNGD7erTvrD8mjAvs=; b=aZCV/xja7hBUgvZjd/tq/rk/HU
	jV9HQmtwIRws3jXx4Zen/dz26N0jxRUw/dbUR0JF6JGKnZs6teWRtwH60z6j5ZqqfUDn34cA5Q/1Q
	pnA+Mlet3bSjL4wi+C7QtctaZ0M1zlCcU72zl95X6XByJiXftmlyOjqs/Yr4RVHwhNciS6Z8wUjGw
	ayfeLLDYQobqkWoGKdC2iD+jqevR70w/jT4hh1VRXS0O7CJlYPfN8JqVaqhXILLCfkP9DXOfqSVT8
	x02hP5lKUWwzMiUQ6+jn+XvQHTIJ+4aBb9AMFCCX1arfqzdGICOWWVuqHYO9sulu2SqDbmx2Jrj+h
	bMz/zfVQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ugk0f-000000007vE-1qJ8;
	Tue, 29 Jul 2025 15:04:49 +0200
Date: Tue, 29 Jul 2025 15:04:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Fix for 'meta hour' ranges spanning date
 boundaries
Message-ID: <aIjG8SAreSnvpXAF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250725212640.26537-1-phil@nwl.cc>
 <aIgJUFPS2z6F_sCn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIgJUFPS2z6F_sCn@calendula>

On Tue, Jul 29, 2025 at 01:36:08AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 25, 2025 at 11:26:40PM +0200, Phil Sutter wrote:
> > Introduction of EXPR_RANGE_SYMBOL type inadvertently disabled sanitizing
> > of meta hour ranges where the lower boundary has a higher value than the
> > upper boundary. This may happen outside of user control due to the fact
> > that given ranges are converted to UTC which is the kernel's native
> > timezone.
> > 
> > Restore the conditional match and op inversion by matching on the new
> > RHS expression type and also expand it so values are comparable. Since
> > this replaces the whole range expression, make it replace the
> > relational's RHS entirely.
> 
> Thanks, I suspect this bug is related to this recent ticket:
> 
> https://bugzilla.netfilter.org/show_bug.cgi?id=1805

Ah yes, I forgot the "Closes:" tag, sorry!

> > While at it extend testsuites to cover these corner-cases.
> 
> Thanks for improving coverage for this.

Above ticket also mentions how "23:59:60" is accepted when "24:00" is
not. I'll send a v2 which describes the expected values in nft.8 to
cover for this oddity in strptime() implementation.

> > Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> > @@ -2772,12 +2780,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
> >  
> >  	pctx = eval_proto_ctx(ctx);
> >  
> > -	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
> > -		ret = __expr_evaluate_range(ctx, &rel->right);
> > +	if (lhs_is_meta_hour(rel->left) &&
> > +	    rel->right->etype == EXPR_RANGE_SYMBOL) {
> 
> Side note, thanks for reversing this check.

I did it merely because consecutive lines being longer than the former
ones seem more readable to me. What do you like about it? :)

Thanks, Phil
