Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87F395DAA
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786893296; cv=none; b=DydLfIVkMGLo6Td91Hb7ThKvIHC4CmqxCOZVH+qw+ppnhZ/21t/c4jN/WDYJl23pasUpq5rSqnOPkiDqng3rNuE7uyOBRHBBtsk+0D1dqcni5Cjlje233nVsQoem9AIn4NuU/ze0YrcVfj5VD8+I9HBuAK0z4lReR8tPo3JpQX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786893296; c=relaxed/simple;
	bh=oHad1wyox8qdDpY81HM8XfWbSH7UCwe0GLxzkyCErM4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZ2DxnzHoC+GOc2OiZm5oporWfV6pky4Rhwy4eYjzkFK/QF8YRmMaNeq1O5efL2YczPQaDaHr5EF2M8lnPVMyWtZwzUNbu2cpZ7WkUkKYPvK1RTX/ZIx8gR6ktPE+8BYVpqH/vwFKR4tShXkjPZ4IhLDN/NrJTrnvXMoX1w6nAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfv+1QI4; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfv+1QI4"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso1156550f8f.0
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786893292; x=1787498092; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oDn1zkAJTAhRzfQXoiRfUNpmt/wvhx4bAoFeaZmIx14=;
        b=bfv+1QI4UV37TIKxa1TGhmFpcxlnBRLXA3kdutOATbmkmxGlaVPInNN7+AJ/aywRBQ
         h9zunZb2XN2eK5jSWcZMZHo+tM0A+Yw5gYyjr8hCuzt9kWLFxsz2ATY7un6PO4sJz23t
         d2wFNByaLUh9s7W+1mi3dLFSnBjbwvrElqjBnA8V06L/SrfPaujtc10tRlb/F4Fkr9F2
         de3HaQM1KhFuBk6SxL8tgAK1zbxOaRb8Apqu8xo28DVJpHVHPE7F/+d9m+wKMhhbsFYq
         05Lh0y89uoNWSLMI+tv9hquMOn6QEJp4+fqoo00S+gb5yrTY7+nx1JNnYYM3CCAoJXem
         /Nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786893292; x=1787498092;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oDn1zkAJTAhRzfQXoiRfUNpmt/wvhx4bAoFeaZmIx14=;
        b=KATGrS0Ki9ZkL4fO4WW0H8pLQVPyzJDtQzG4lmX/2T45fifl+yonniG9ncCxn8x2Bl
         oFNTDzMM2sXSKJE8crbs02NVODpkJrJvkniSuIfXjA0hXdU8AANEwskbhYAKgeVx3EAL
         yfHDnFrs4WS3ukTni5ky4d6/OuCUFiO7BD9F72mN4UQwUOnoucvAZcUaroQvR8bJVBRq
         PAUI2XfaxuSehpb8X63+32j09bQxEUaPa3TfXgwc6YTjgVUPwNpCiJ2fwiIbXJZ9mE4u
         +hvauwGXrwIU1VZkT23XblQU0F33IIT2jWahymT4JeoKc9McG43k728YMmd5tTlYS/+u
         pYig==
X-Forwarded-Encrypted: i=1; AHgh+Rqvlc/AH4kMeCLof24kbAw/Ju99GvIFjagUFBHBi4UobN+jFz8nBwNjpso/wYVWwVnXJYDaL3Pho2AsDfqb8sE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEO7UHpExcnk01c7xCcJG5hZQXHH7Ebczy87FMqAGgwDgmaZEP
	cWHdJOCmP1HLO/M01+znHA4SXXEsJ4ODCCswhl4pPDe/ZRKDem8GWEtcbuPY9xS3
X-Gm-Gg: AR+sD13q3esEC9th6PR0a+YfUQJuUEnPZVuYQFEOQ9R/0L2Bll6+9U/5KKeqDql6Xdq
	whIbG3Wf6dqyOp7ufTPHz+5ehgtWeqsFhY4Uu4mPP5NnjPUT4PiY15PXJK6IqrStBE2FKMoz46W
	x5BLkesg2MoaL8kk25vzwVicaR7cxr+o1ghC2XruGGBxroEVbyxb/IfRHS0m8X/tjNZFMLbhbk3
	CA18s+LdzgsEmygrbEoxGOn99Y/rZB+1BpZGboKw05BfompjZ8hwhEUzDbwBStlLdV3oR9WawyO
	GgT0R4RswYlenOBGZlh0oG1k7ES4LlQ+SlJXrAyaYKgEwEYdjc+8QwtLMrUbAiCqh/ueXRPF8Wz
	+zL/5kQfOIBFLx+wT3eX+evO8JsJp+8EXBVe9do03tp2qRdpHW3oGu7MxuhMpIkc7wfBg9Q/uQF
	ECJMCQZ1SZUjwfLLWLKp8xlGCQe2bMVEpsLL4PjycXSZEdaJ6HF++abuDP8gqeoPQyPWrk4E4Zk
	mRtzIC47m5dXZSlQA0Os9pocw==
X-Received: by 2002:a05:600c:6a10:b0:499:79ba:a754 with SMTP id 5b1f17b1804b1-49987973094mr241171505e9.11.1786893292329;
        Sun, 16 Aug 2026 08:14:52 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b2a176sm223938615e9.4.2026.08.16.08.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 08:14:52 -0700 (PDT)
Date: Sun, 16 Aug 2026 16:14:50 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260816161450.05fd24f2@pumpkin>
In-Reply-To: <20260815205750.169336-1-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Aug 2026 13:57:44 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Assembly code using YMM or ZMM registers is supposed to end with the
> vzeroupper instruction in order to avoid degrading the performance of
> any later SSE code.  Since this only affects performance and not
> correctness, it is sometimes overlooked.  Most kernel code does it
> correctly, but a few cases were missed.  This series fixes them.
> 
> It should be easiest to take the full series through the x86 tree.

Would it be better to an an unconditional vzeroupper in kernel_fpu_end()?
It could go in kernel_fpu_start() but that might have a bigger effect
on latency.
(I assume there is one in kernel_fpu_start() if it actually saves
the user registers?)

Looking the latency/uops seems reasonably on everything 'recent' except
zen-1 and knights-landing.
Although the microcode patch for zen-2 might make that a lot worse.

	David  


> 
> Eric Biggers (6):
>   xor: add missing vzeroupper to AVX code
>   raid6: add missing vzeroupper to AVX2 code
>   raid6: add missing vzeroupper to AVX-512 code
>   crypto: x86/aria - add missing vzeroupper in AVX2 code
>   crypto: x86/aria - add missing vzeroupper in AVX-512 code
>   netfilter: nft_set_pipapo_avx2: add missing vzeroupper
> 
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S  |  6 ++++++
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S |  3 +++
>  lib/raid/raid6/x86/avx2.c                 |  6 ++++++
>  lib/raid/raid6/x86/avx512.c               |  6 ++++++
>  lib/raid/raid6/x86/recov_avx2.c           |  2 ++
>  lib/raid/raid6/x86/recov_avx512.c         |  2 ++
>  lib/raid/xor/x86/xor-avx.c                |  1 +
>  net/netfilter/nft_set_pipapo_avx2.c       | 17 ++++++++---------
>  8 files changed, 34 insertions(+), 9 deletions(-)
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

