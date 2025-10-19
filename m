Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF66148832
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907454; cv=none; b=ppIG9XgT9EuTK3SuagND17ESLBlNEvXten+AHeZxk2bozBCLD4gi+yKoW1lt2nrKu01OMasgZSoKZqnhBYKq7RJevqH3SHPI4m66yds1TExlGWAvAo7bsQ/oNobCwjR3Or6HnSRBiUxa+96/pihM+V2e02ohjTvjNWMYwQsy0x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907454; c=relaxed/simple;
	bh=fW3TVKpBgDICg2B14nzLfiS0TaqDXkNMilGZA/S9ikQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFGV8yh0jc/Cn2Jaehgiqk/OYjAIYJR+Odn2Wvr50V3polIO9qZELEUXSQEORBkE5PsVvQg7NUozcBhu4GLzNvGDT5e5qM13dLPoaT0cpjvgmCMzx3WWi1SeFXLC4O6249+vVlSqBI5Hwd+jtNcd2Fgd0hXNgDXg6w/8ZzHPhuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D3BF1605E0; Sun, 19 Oct 2025 22:57:29 +0200 (CEST)
Date: Sun, 19 Oct 2025 22:57:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add refcount asserts
Message-ID: <aPVQqfithTx_FMyY@strlen.de>
References: <20251017081355.23152-1-fw@strlen.de>
 <aPVMzW-DOPo9JISv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPVMzW-DOPo9JISv@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > @@ -343,11 +352,14 @@ static void variable_expr_clone(struct expr *new, const struct expr *expr)
> >  	new->scope      = expr->scope;
> >  	new->sym	= expr->sym;
> >  
> > +	assert(expr->sym->refcnt > 0);
> > +	assert(expr->sym->refcnt < UINT_MAX);
> 
> Would it be possible to consolidate all this with a macro, eg.
> 
>         assert_refcount_safe(expr->sym->refcnt);

Sure, makes sense to me, I'll spin a v2.
