Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D933C3314DC
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755541507; cv=none; b=ZwOkCZvo/h7xdUHWNQan+wxvKty0hnM5PkKHFFN0EOSthfeyu3JvDkdqWrGy9CQI1RVVu1I5vy4Iof2SDFXIynWnigMgoU3RD1iY5HbnTvQ2Pj/6+aLtNRVIhQYAZDo7DvJyHI/0WRevjZ91KfJPGzQzCq73D/nTvpIDBKcLGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755541507; c=relaxed/simple;
	bh=yxykGDJ0enTXpIl+lRTbfG6uh+s65SkyMmFnGcfd69Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2cITvV5w+y8VqtDvKjVOmI2YYp3Eg6IwKDk0qVbYYCh+tl/AJp8r6AesL3mwqk5RF5c3Juu42ogo3rz30fEcC2jQaY2nOrvuEk0cJ7QkSS7xiqI2/OGM2+qaZfMwTOvm1Ims+uCd8f5NDDAd40LGQT3nWnJNpNTfLJgHETm/mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 46BF260329; Mon, 18 Aug 2025 20:25:03 +0200 (CEST)
Date: Mon, 18 Aug 2025 20:25:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: use avx2
 algorithm for insertions too
Message-ID: <aKNv_lcbE6kMtqws@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
 <20250815143702.17272-3-fw@strlen.de>
 <20250818183227.28dfa525@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818183227.28dfa525@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> > +static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
> > +					  const u8 *data, u8 genmask,
> > +					  u64 tstamp)
> > +{
> > +	struct nft_pipapo_elem *e;
> > +
> > +	local_bh_disable();
> > +
> > +#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
> > +	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
> 
> I don't have any straightforward idea on how to avoid introducing AVX2
> stuff (even if compiled out) in the generic function, which we had
> managed to avoid so far. I don't think it's a big deal, though.

It could be hidden away in a static inline helper if that makes it more
acceptable.
