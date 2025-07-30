Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D232D9491
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753892203; cv=none; b=RCccG4HDrBVj0dhB/NyQHI5Qn4wASGIEGFz/3BZP2OPpm1x0i+UrBg/RqvGAra4hRY0zZjKutbMt+odQKyNpqGo/544n5MWIxb7MA937aq4C/ra+0dQEH/eir1J+df1mvQ2jGlpAidvmBwX/3JMQDZNqOJBFRD4rY+KZ/XnK604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753892203; c=relaxed/simple;
	bh=kFwDbuRnNGTdM4smispM7H+pwJo2vW9jsH7tOtWEJAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmZagXNfKiXYMMjvRQMCmrgnDNzB/DdkFvk04g3lqzzeUxKn3vshSyC4YBJYrokMoQ9LZVkza490YAabEmapUlHD2yuR0yGElz4rJo6Hh3Vw02VyvQO4zpSOlQrYoy9Dq1ZcmlnAH2jZYX/oFFPIaw/LoOELXLq4wHFbt9L/F+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UtoSf+BB; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z8R7/VO6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UtoSf+BB";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z8R7/VO6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2BD356027B; Wed, 30 Jul 2025 18:16:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753892191;
	bh=Lzq6EBg+OeK/kU9SkIuABvcEdHxIF/pd4NX4znM8GsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UtoSf+BBVJhxbhxTvwQGDo2FRqzj9QZDDuElCwwfK4X8O0Mjpl23nhlMD+50sJvYc
	 qhAcNONE8yn4F5q1SV7b6dULaxIJtGJVi7pjZNKLLfS6vVrJpxadXlXJ0Lq2OS1iuv
	 yldQEy+UDDMNDHXY9gUblERKPWyP1q49kgz3NvNTaMuK7+qnZ8WLqwKcDTdTWmEieq
	 ptgEa0adWlVZZRtNEqeHuVau8yheG/ksXq3YlfX9sDk2sdh626lXPUqEX6SFv30c7l
	 o5EcRuFP7FnH9srN+bEvaQhFoHjpXn15GUNmag885Q11bRELLhLU2oHZbylAk9ynet
	 rI72TWWhkCxDw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 646806027B;
	Wed, 30 Jul 2025 18:16:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753892189;
	bh=Lzq6EBg+OeK/kU9SkIuABvcEdHxIF/pd4NX4znM8GsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z8R7/VO6cD+T2VcRUArsx5E/9A8vzJ+5KYK+iRdaEhAyDcGb0Q/vWoTi6RjWNUl1J
	 xVDa5FiaelJwv3rc75QEY/UenRi4k7tmaktMrCEh5XBY6Z9VwVeUrArfil38F6qihR
	 P8h3LylU9Re0R0hus9Gi+BCXJEOY5KIHdsEZ2p1P8L7j9xCoygtDFpdUMHo+rvZJDx
	 hcoBekzg8tL6BbngavlNk+FkuWi9fDjqK1o/OStLL1eH5NuEBdkZoozK3oQobRe8EX
	 8j7B1h9rOdGSyx30xfQntyvTTfUksLIvYm6QYVjztVhfNVwlsxNSyKSseA6ybi53cg
	 eBRkMTg1DES3Q==
Date: Wed, 30 Jul 2025 18:16:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIpFWePr6BfCuKgo@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <aIikwxU686KFto35@calendula>
 <aIiyVnDlbDTMRqB-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIiyVnDlbDTMRqB-@strlen.de>

On Tue, Jul 29, 2025 at 01:37:19PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > DELSETELEM does not unlink elements from set in the preparation phase,
> > instead elements are marked as inactive in the next generation but
> > they still remain linked to the set. These elements are removed from
> > the set from either the commit/abort phase.
> > 
> > - flush should skip elements that are already inactive
> > - flush should not work on deleted sets.
> > - flush command (elements are marked as inactive) then delete set
> >   skips those elements that are inactive. So abort path can unwind
> >   accordingly using the transaction id marker what I am proposing.
> 
> Yes, that part works, but we still need to kfree the elements after unlink.
> 
> When commit phase does the unlink, the element becomes unreachable from
> the set.  At this time, the DELSETELEM object keeps a pointer to the
> unlinked elements, and that allows us to kfree after synchronize_rcu
> from the worker.  If we don't want DELSETELEM for flush, we need to
> provide the address to free by other means, e.g. stick a pointer into
> struct nft_set_ext.

For the commit phase, I suggest to add a list of dying elements to the
transaction object. After unlinking the element from the (internal)
set data structure, add it to this transaction dying list so it
remains reachable to be released after the rcu grace period.
