Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D514812B143;
	Sun, 16 Aug 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786900643; cv=none; b=YCM7IKkfXhEawn/DYD0NjdwzvY+067IqCe2OzhHPdE+JhqOQUMzam4OoNlBWfFPCVxH9WejBVm2ivWxXW4VUTKQI7RKrhvhgSn7wDucWDdgmcNDKfa/7Pr1RmtmfMlpXSA7nS3fJlMW3ZKZEYqnBFxMFCiipR2fUnleOoBzfmUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786900643; c=relaxed/simple;
	bh=qQs895llp3+NBaTBB/u4BZEsjzJQPb7wbXSDRx49l4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIcCetddN2lSLUFj1KALdK65L/GpTIfLF/eCS/PY98A+lcGZxvhu6lZ4rVw0jO2yqzQ0PVou9hC5CP+mQHPEEHevgvFX4tmMY1t+GCmn5E+bEFXejJFgZ6mzRojm6DmjbULTcw1vCJFrR/rV6NsqCQAOwdYQmYe5ZstxDrvTafc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzxGdgvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzxGdgvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B381F000E9;
	Sun, 16 Aug 2026 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786900642;
	bh=M/h/VKraDmVMZA+gi8h7rskdhp64x8VBXTi34IssNSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NzxGdgvMoWIUi8JEzLty141E5YT820oPFYOo2EmD4Gp6LFXnvb3kpwBPBuk4z4tLD
	 kqBHMr5FPVenm33jh3XVxLy6Crz44/RsPZVdVK/FHpugTwT6aW5i26pnBNrJ32qN6H
	 190VAjdFGTPcotF4SqetMzLNEsN17x8k3JxS/b6tC3opCNiCvcGrCgmY2so2mmUF4c
	 5p2RU+VV9k8VlluR7fQB7ZXjgaZCpbUBrQy18eX06heOINKpuaM8s2Ae7JFBDDzWDa
	 XCOkBSGOfry165CNdTazu0iBL2Zm5yQmLmEOieyg+3+2IApz/UCRhNn9a5NQZVxRu2
	 0m/mRJ49SWxWA==
Date: Sun, 16 Aug 2026 10:15:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	stable@vger.kernel.org
Subject: Re: [PATCH 6/6] netfilter: nft_set_pipapo_avx2: add missing
 vzeroupper
Message-ID: <20260816171518.GA2013@sol>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260815205750.169336-7-ebiggers@kernel.org>
 <20260816123839.3670e5c3@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816123839.3670e5c3@elisabeth>

On Sun, Aug 16, 2026 at 12:38:41PM +0200, Stefano Brivio wrote:
> Eric, thanks for taking care of this.
> 
> The patch looks good to me, I just have two questions:
> 
> On Sat, 15 Aug 2026 13:57:50 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
> > returning from it.  This is needed to avoid degrading the performance of
> > any later SSE code that may happen to be executed.
> 
> Out of curiosity: was this prompted by some observed latency spike in
> execution of SSE code, or it's just meant to satisfy the recommendation
> from AMD and Intel to use it while transitioning from AVX to SSE modes?

This one was found by code review.  But the latency spike has been
observed in other cases with missing vzeroupper, so it's definitely a
real effect at least on some CPUs.

> > Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
> > Cc: stable@vger.kernel.org
> 
> Is this really stable material? Skipping vzeroupper might have a
> performance impact, but it's not an issue for correctness.
> 
> The main reason why I'm asking is that, while vzeroupper might look
> harmless and obviously safe, it actually caused CVE-2023-20593
> ("ZenBleed") on AMD Zen 2.
> 
> I expect systems receiving stable kernel updates to also run the
> patched microcode by now, so I'm not overly concerned in any case.

It's awkward to mark something as a fix, then not actually want it to be
fixed everywhere.  The stable maintainers know this, and they often
apply fixes anyway regardless of 'Cc stable'.

And if vzeroupper is really not safe due to ZenBleed, then why is it
used everywhere else in the kernel?  This is just one of the few
exceptions that doesn't have it.  If it's not safe then they should all
be alternatives that patch them out to no-ops on affected CPUs.

But since that was never implemented, and userspace almost always uses
vzeroupper too, it seems the only real solution is the microcode.  I
don't think it makes sense to have a middle ground where almost all of
userspace uses vzeroupper, ~97% of the kernel uses vzeroupper, and a
random 3% of the kernel doesn't use it.

- Eric
