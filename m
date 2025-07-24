Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718542D4B71
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361277; cv=none; b=VKC5b+4uW/GDpzY5PrVxlyBUb3m/JgSi0XtTc6UXURXMuODMYF3rI0REcq0ENexU0Y+5wrmA3yCGJaH4pQfbNyUfUa/BFbWVzYwC5g3dMVpNBKvZ8F6eM3FUe33+SzwFoyvN2Zp0AqMT9Gx9467LI0t/GWdnfa8It9Z99sC63RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361277; c=relaxed/simple;
	bh=Q65jpNemx1aPbyIJLEsFF9Mk8sT5+Rq8h9lKHZzKpKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uahN4LUgpVG6metsrLLe9QpLHeoHRE9xNaI71Gsb1N9qpD4LMaHiry+U/OiXaWLKUy5WnK1YE7YZxQGNHG9hg28dalKpcZlzAY4m+wZCbS3CzfCtCMN59SgBdjF2v+QtGe2Mn98Bn0yf/E3FkjKWcErlgCMp9m+2mXvsxrxOXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=feOO13FK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=feOO13FK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="feOO13FK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="feOO13FK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C79496026D; Thu, 24 Jul 2025 14:47:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753361273;
	bh=/aDU1A0ZcnA3HhDWcE2E7hBZwwJ3ashTEJmSPnu91g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=feOO13FKFpKluXgPQumISpnunh1AWCaA9sk5JW/oE5JGMT2oTyMOerJfnGmUwuUsp
	 6iqKeKxFjdymqpzj2YMCPfaC1KKwrjJD5doPZpKjPJlz5NzvBNjBlm7R26AFeTzqYd
	 f+7hJYqYZQmX2JYiiK9zmBU0pHKcZUYnzsbN3nnD9O0Hx9OK1sNJrJbUX3T6aOSmhn
	 270oBpeSwHpXPXFGL2EUgIPgmwoBkLggupzwahhYTtvUzWcgUojQw81i4VjrQIuFqG
	 2eJSXn01+UkV0bHU+Q53yJZmYDJxKB9ui9H87XcGUVBb9caZAerYlYTu7E6tirhdVe
	 qPdr3PADH3s2g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D48FC60265;
	Thu, 24 Jul 2025 14:47:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753361273;
	bh=/aDU1A0ZcnA3HhDWcE2E7hBZwwJ3ashTEJmSPnu91g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=feOO13FKFpKluXgPQumISpnunh1AWCaA9sk5JW/oE5JGMT2oTyMOerJfnGmUwuUsp
	 6iqKeKxFjdymqpzj2YMCPfaC1KKwrjJD5doPZpKjPJlz5NzvBNjBlm7R26AFeTzqYd
	 f+7hJYqYZQmX2JYiiK9zmBU0pHKcZUYnzsbN3nnD9O0Hx9OK1sNJrJbUX3T6aOSmhn
	 270oBpeSwHpXPXFGL2EUgIPgmwoBkLggupzwahhYTtvUzWcgUojQw81i4VjrQIuFqG
	 2eJSXn01+UkV0bHU+Q53yJZmYDJxKB9ui9H87XcGUVBb9caZAerYlYTu7E6tirhdVe
	 qPdr3PADH3s2g==
Date: Thu, 24 Jul 2025 14:47:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] netfilter: nft_set updates
Message-ID: <aIIrdYpnZtyRQOtU@calendula>
References: <20250709170521.11778-1-fw@strlen.de>
 <aIA3Y3OjzhZ_hQVD@calendula>
 <aIDTnU0QY0QdWzio@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIDTnU0QY0QdWzio@strlen.de>

On Wed, Jul 23, 2025 at 02:20:45PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > The fourth patch is the main change, it removes the control-plane
> > > only C implementation of the pipapo lookup algorithm.
> > > 
> > > The last patch allows the scratch maps to be backed by vmalloc.
> > 
> > This clashes with:
> > 
> >   netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=463248
> >
> > It seems you and Sebastian have been working on the same area at the
> > same time.
> > 
> > Do you have a preference on how to proceed with this clash?
> 
> If the clash is only in last patch, then how about this:
> You apply the first few patches plus Sebastians work, push this out
> (main or testing branch is fine too) and I will rebase + resend?

Testing branch:

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/log/?h=testing

I still have to make another pass on patchwork, regarding your work,
there is one series of you to avoid the GFP_KERNEL allocation I would
like to review.

> Or, we can defer to 6.18, your call.
