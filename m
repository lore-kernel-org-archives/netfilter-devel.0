Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EFF4399C4;
	Mon, 17 Aug 2026 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987115; cv=none; b=XB0NuF2TiHdua1n2geRrLCAzuf/noOHicM0+iJTnIdRVrsPMHbKIPZeHDUUG6Lj0Df1hAqJsnF/SwaDy7BFi1A7zZQDR8qGYHPHrM+aw2CrsJg5FIgFxUP1DrMEtch9CCzuMZdp7kvMsEiBjwNm5SW15HEDgKfgKkZzmtMgfPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987115; c=relaxed/simple;
	bh=75z5q3lZ1shKUcnVwuxR1BTMrHkKbEQ/GFVG+kHgnwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4CMqLbHGFjH8oT6LGZwuvEhVVpNIq/u7DpCKpcmizG00uMjn7d8LtaEQTOHkcpFxutoO81hsjGQXxzZEE1+5HQZi4fzJuNRk81KddnGga1azWsmHu9iILZpPfVY9jR8KRPga74awIdFwl+ja8nekSZa/TyKu6JuyD8VUJQIhwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYGrnuNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYGrnuNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB381F00A3A;
	Mon, 17 Aug 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786987114;
	bh=cqEALtTdwDfe70tQT8Qbqwqn8D+Vx33cN/J1LRfH9Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IYGrnuNpsE4ty78aLZFp2z93MlBewFcwHHKAm1h9dihA+Noq6KfkuxM78CyLq6Pte
	 HUq8tN2lHzGLJX4fM0ZhNI9eHA2lfm1Cu8P37JqjcXkLxAFVl/P3GQMkltWLr8x24m
	 wF7KOAdqrLLGvZ57JOeERubHe1if6tCduzKw7DLEFaSzG68flAI38AHTBZz+eW9Moq
	 gKGEJ+8wAYf1P1aKgCkTqK3ALmDHIQRC6Wl1EwAIlChDbuqbHKyQL0/IibeYhPPNhv
	 /mqdIrt2CaSNALRThFiGDQH5nLPkPtmHVcdEeEBzYPlSwqtm9Ki6wiwSqSrFP5fN+n
	 0WekyPaT5Duyg==
Date: Mon, 17 Aug 2026 10:18:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260817171834.GA8327@quark>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260816161450.05fd24f2@pumpkin>
 <20260816173159.GB2013@sol>
 <aoLRJ7igR5GTMfuO@infradead.org>
 <20260817115523.7c6c646a@pumpkin>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817115523.7c6c646a@pumpkin>

On Mon, Aug 17, 2026 at 11:55:23AM +0100, David Laight wrote:
> On Mon, 17 Aug 2026 02:15:19 -0700
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Sun, Aug 16, 2026 at 10:31:59AM -0700, Eric Biggers wrote:
> > > As for kernel_fpu_begin(), no, it doesn't do vzeroupper.
> > > 
> > > I do think that some years down the line, we'll drop the use of SSE in
> > > the kernel entirely.  At that point, vzeroupper in kernel_fpu_end()
> > > would make sense.  
> > 
> > Or add kernel_avx_{begin,end} wrappers that include the vzeroupper
> > in kernel_avx_end.  That would be a lot easier to use than the manual
> > vzeroupper in every modern user of in-kernel AVX.
> > 
> 
> You might want one in the start as well.
> I have a theory that the avx512 logic was added as a completely separate block.
> This meant it could be included in cpu for testing but disabled in any
> released to customers.
> (Or maybe the it is the original avx logic that used latches not in the
> normal register file.)
> A side effect is that different latches are used for the low bits of the
> registers - so when you change to/from avx512 the register contents have to
> be transferred between the blocks - adding latency.
> So if the wrong registers are live for the code you are going to execute
> the data has to be transferred across.
> 
> There are also other effects as well.
> I found this link: https://travisdowns.github.io/blog/2020/01/17/avxfreq1.html
> It is a few years old now (2020) but probably still relevant.
> A quick summary is that the first 256 or 512 bit instruction starts a 9us
> window where the cpu runs at 1/4 speed, for 512 bit that is followed by 11us
> where nothing happens at all. 

The linked article is about Skylake, which is an older Intel CPU that
has a bad AVX-512 implementation with overly-eager downclocking.  Later
Intel CPUs improved the implementation.  And of course, AMD just
implemented it properly from the start without the downclocking issues.
Information about AMD Zen 5's AVX-512 implementation can be found here:
https://www.numberworld.org/blogs/2024_8_7_zen5_avx512_teardown/

Most of the AVX-512 optimized code in the kernel already requires
!X86_FEATURE_PREFER_YMM, excluding Skylake as well as Ice Lake.

That being said, if I recall correctly, even with Intel's improved
implementation on Sapphire Rapids and Emerald Rapids, Intel does still
have some start-up latency for accessing ZMM registers.  AMD doesn't.  I
don't believe vzeroupper helps, unfortunately.

I've considered setting X86_FEATURE_PREFER_YMM on all Intel CPUs, but
then even workloads that would benefit from ZMM registers wouldn't use
them.  And I suspect the Intel folks wouldn't agree with that either.

- Eric
