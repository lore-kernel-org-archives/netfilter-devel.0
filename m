Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7D5477E;
	Sun, 16 Aug 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786901645; cv=none; b=iwQzboP+MGkgvkbrl21/+huLpLKkt0YhlY7ghzjDq085/pwCUbED63/OrVWGMY4b+iQx52WmB+S6c6dTVkuqf3aYO7Aaty8i3Yq+ckaA2WHBgKFbz2jNVrEe1kViGzgH5SGok8jGuDt9dKw/ZEPlDeYLY4wi0kJLzrjaR/2cfrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786901645; c=relaxed/simple;
	bh=nVwzp/1L+BnIf9Gr6BigDwQRJ+GnUmF33kxQazyRf10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/gw58c5LqfAw8HcWLrwqLBoR5VVMBUXvXwFI1FMPD84jdNEd4FvdypwsuH5uLzsDt4eZH4V0qKGRWySWShxhWEBaX4j7mb08gHupNQ6cMeYE1x73miZ98Lvr5dNl1yUnMj23EZ1MqpJvGFkPy806NrjY3+XjSsxMCHe84B6/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Unj90kM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Unj90kM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010991F000E9;
	Sun, 16 Aug 2026 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786901643;
	bh=kjlqu9up5uQZpRU8C7p51dp1WnvNc0D2KpPx1Z5uwok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Unj90kM1bXxY+ZxSteM7PT9J3GmvbJGlpU/LCGVThdEi2VwuNDHgPNdCnyApef5l1
	 hwTAaI1WUcp0zy1PIUmq7S3HGgF/7ktKeQ3BriWQjHvQzOsX5GeqOnfp8L3Ddvmbka
	 W8w8teP55s2pGU+soxBEIDvuB/XAp72xdwVhESR9B9z5843w3VrEytkaPjrJWe54w4
	 qVHWRP/P35pQj0b6j/C+2T/jCQgprFl7NagSAhyhS5Adtd3dmCgx5Bvt8DwFRYyMmF
	 p0rybvHTizJsG59c6kif3xc06mwvohw0J+WRZHwiYyiSg8d6FupCxdYE5Epbh2X4fb
	 jxbFLMpjnbtsQ==
Date: Sun, 16 Aug 2026 10:31:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260816173159.GB2013@sol>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260816161450.05fd24f2@pumpkin>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816161450.05fd24f2@pumpkin>

On Sun, Aug 16, 2026 at 04:14:50PM +0100, David Laight wrote:
> On Sat, 15 Aug 2026 13:57:44 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Assembly code using YMM or ZMM registers is supposed to end with the
> > vzeroupper instruction in order to avoid degrading the performance of
> > any later SSE code.  Since this only affects performance and not
> > correctness, it is sometimes overlooked.  Most kernel code does it
> > correctly, but a few cases were missed.  This series fixes them.
> > 
> > It should be easiest to take the full series through the x86 tree.
> 
> Would it be better to an an unconditional vzeroupper in kernel_fpu_end()?
> It could go in kernel_fpu_start() but that might have a bigger effect
> on latency.
> (I assume there is one in kernel_fpu_start() if it actually saves
> the user registers?)
> 
> Looking the latency/uops seems reasonably on everything 'recent' except
> zen-1 and knights-landing.
> Although the microcode patch for zen-2 might make that a lot worse.
> 
> 	David  

I would like to do that, but there are some issues:

- In some cases, within a single kernel-mode FPU section the kernel
  executes AVX instructions, then SSE instructions afterwards.
  It typically occurs when large input lengths are optimized specially
  with AVX and then shorter lengths fall back to SSE code.
  chacha_dosimd() in lib/crypto/x86/chacha.h is an example of this.

  In these cases the internal vzeroupper is definitely needed.

- Unnecessary overhead if only SSE instructions are used, which is still
  frequent since we don't provide both SSE and AVX versions of the same
  code when the AVX doesn't provide a notable performance benefit.
  lib/crypto/x86/sha256-ni-asm.S is an example of this.

- Further divergence from the userspace ABI, which can be annoying when
  importing assembly code to or from userspace projects, or developing
  or testing the assembly files in userspace.

As for kernel_fpu_begin(), no, it doesn't do vzeroupper.

I do think that some years down the line, we'll drop the use of SSE in
the kernel entirely.  At that point, vzeroupper in kernel_fpu_end()
would make sense.

But until then, I think we should stick with the existing, standard
convention of having the vzeroupper at the end of the assembly routines.

- Eric
