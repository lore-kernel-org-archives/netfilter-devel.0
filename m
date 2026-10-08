Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A253806D7
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456759; cv=none; b=G3KdWWrUfW+CV4peAw32CWEh9PS/JFINFlXH50vF51iMIAWfsA+eqzQn6XEbG+9g7hsM/OICZ2lET4VEJxxHcBkIi7oRlhxpLur0HrbfRSI1ks72sAJ5L5lXKJvOG5vhYqYusnXncS+EJXKL/RaeZ9CIp5pOzt4FGm0UYM6guDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456759; c=relaxed/simple;
	bh=hEcOpmWHHGUC4AQS0TaZsXNCXRX5TakbDYXD78qWZDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaBXksP9UWkDdoBtL/yVx8qRdonr1gtHxXSa7lKdhR5RlwaOL4fh7fnAuNvUURQJbnjWDa248/OuLEzIV0CRtxEwW9elNG19aq9amuHaBFmFEoLbS1wgFMsBeRFPlVDHGaXMYPkIglTCF+RO2s0WvuVbXDWuIKbfVa2ZKRKDeIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mm/q+hVz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mm/q+hVz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791456755;
	bh=slcunxJVKlvQnLMkuH5szuV4WaPnZTaCj8Q/mQ2Z62o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mm/q+hVz74C6P281DC2YWg9J52rQAlWNU7b3qPzOHVlGqE9uMUvDJRgkgLMKQOqHF
	 R771P/9/EjMv7sbxQpStvbuLriTLb89OU40WNmBdKn5Vx/6WVtV5cxz3SWeMV8U5eX
	 sptok0E0LW/UcuHN5qpfgTGyDjhAU/EK+tuh1lW5jLaU1dW2mjL4eAukKbqWpia6kK
	 XXm9Uxw5gf4okpdW6y88LvHtgbYVLWVcmusqrb1hHdJrlypY43DO9tDQTjwKdItqbC
	 T7GuTM13eE1Wx05IAm1EGCnMuKv5tMGlgEE4zZXQkdRFlcu1wC6OA1O4FwqW/aED3h
	 64dCkMaG1mflA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0E2F660074;
	Thu,  8 Oct 2026 12:52:35 +0200 (CEST)
Date: Thu, 8 Oct 2026 12:52:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Jeremy.Jean@oss.cyber.gouv.fr
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: narrow down range
 completion to anonymous sets
Message-ID: <asd18Ow3-mYwVQMS@chamomile>
References: <20261007220358.1140284-1-pablo@netfilter.org>
 <asc5Bsrgv_w7lVOq@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asc5Bsrgv_w7lVOq@strlen.de>

On Thu, Oct 08, 2026 at 08:32:54AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > For anonymous sets, when adjacent ranges are found, the end element is
> > not added to the set to pack the set representation. Use next start
> > element to complete this interval.
> > 
> > Jérémy Jean says:
> > 
> > Consider two ranges in a netfilter verdict map:
> > * keys 10-19 accept packets, and
> > * keys 30-39 jump to chain 'victim'.
> > Now, delete the end marker at 20. The lookup array now uses element 30
> > as the first range's end, so an INTERVAL_END query for key 15 returns
> > element 30, including its jump verdict and chain pointer. This can make
> > KASAN reports a UAF after the GC releases reference chain for 30 that
> > has expired:
> 
> Dumb question: How is it possible to remove an element if the map is
> anonymous?

I suspect this is a strange combination which cannot be reached from
userspace.
