Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7D119CC02
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552516; cv=none; b=W6o0GpQ9oUAVkzL1x1F5bygjtOA41Lb/8yN4j6PAEy5JNP0DPsGaMGkh8LNb+Kzmf5x70DjMhiqDEVo7jMyHzJWEF2cVbAAZ3QvtTIMifEsNKXAifARwDTjXjeJA9cOvQpyunYhBIi16wSzqpLrSr41woeRJSZGABafQZqKRKzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552516; c=relaxed/simple;
	bh=gN1yaOsaK/RLOi46fEOKX2By8IENw1HH9Q5yBJ0t/fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhyERDQ+BDMtxnU2/M3u9uk+L6J5uyp+ROOuc7m+oyriHckVzO6GuZSysVamNj/N/gSg6bAIOB/OzfIIe5s8pkhWDVKp1wvr8bJGxev6g9adXcTO27fMGWAFp86KhcLYO0gnwcs3Q0W1f83zi8+gtOMgVllW6V2/9tEUf+bfI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7041E604A5; Thu,  3 Jul 2025 16:21:51 +0200 (CEST)
Date: Thu, 3 Jul 2025 16:21:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aGaR_xFIrY6pwY2b@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGaLwPfOwyEFmh7w@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Thanks for the description, this scenario is esoteric.
> 
> Is this bug fully reproducible?

No.  Unicorn.  Only happened once.
Everything is based off reading the backtrace and vmcore.

> > +	/* IPS_CONFIRMED unset means 'ct not (yet) in hash', conntrack lookups
> > +	 * skip entries that lack this bit.  This happens when a CPU is looking
> > +	 * at a stale entry that is being recycled due to SLAB_TYPESAFE_BY_RCU
> > +	 * or when another CPU encounters this entry right after the insertion
> > +	 * but before the set-confirm-bit below.
> > +	 */
> > +	ct->status |= IPS_CONFIRMED;
> 
> My understanding is that this bit setting can still be reordered.

You mean it could be moved before hlist_add? So this is needed?

- ct->status |= IPS_CONFIRMED;
+ smp_mb__before_atomic();
+ set_bit(IPS_CONFIRMED_BIT, &ct->status) ?

I can send a v2 with this change.
