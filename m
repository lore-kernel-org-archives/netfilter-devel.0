Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46B53E556D
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 10:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786964132; cv=none; b=Ba9gUNCsqiZg/N8mMkMl3kZUf/oIduq38FKGfVmZQVTD7CRNz0jEhIU0GUDOMlpd2FL/+VaL9qVpXyZqmMV1PnZoIOHqJdRftSWFe62t6Y7io4RH/I3G0cXRjCMHx6dJEPuX+kZYYTK62nqk9NckU48aGcEEGwUt2RAFXEwVyfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786964132; c=relaxed/simple;
	bh=oY/WPxJ7Hk/heY3LL7xfbLbJFoxIPUpFgoVBsoCjkik=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4S3u86GjT1e7hvaHNcZDR5IC3Gz40/tudJnkcvRL8bJSrtHFAlFA38KA/ykiOdCQqsyydbGGqnRpfCxNCP/ISMtIFdyavCoMjqNdd9VNT3dWuEBZM6/IDo+VFvC12X63Kh1n/24uKEfMv62j0azbHriOUUCkfwXiJSD7nqjKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+ae67ja; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+ae67ja"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so30182745e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 03:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786964126; x=1787568926; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9LRBFBAtx27EuSLkwrHlog8l1cdy3L7iJ6s4HbjypDE=;
        b=X+ae67jaemIqlvGRxEXGRjtoWXSQ14jiNnDwYE9NAPWNFQDKhzZa2BvbxmmHswmKMQ
         EEhiTg8IcAqu0H0skHDlhh7gRdn3eXL+PxTiO9vdVr/zI9901TSD73BmT3Hxz7Nd3gcu
         LOdhzz2ez3OMG/YDdRoioMNVEsa7lSWvaLNGxL9yUbXQX9CJDZ58kf82zqsqtZ3z5sbP
         1k1LvLPD885bjZTCRom1hc4vmnEMUw9/5iPmni17EVSJ64vPIT0uYCKXvJuhCOpiIri2
         xiOx0hutDe50dbC0tB5/VH9k1rFyFXkc/L05viA5lU32Dq8cr/uXP9jgVaduSXb/5bUT
         f0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786964126; x=1787568926;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LRBFBAtx27EuSLkwrHlog8l1cdy3L7iJ6s4HbjypDE=;
        b=p/AoZFmVS0F+G/ojHmrs3wLlntOBs6u6YYdJsyi37SX2bs9EWiizLb9ivJbmYXdSEi
         tBzrCIhkQ8RxAHsUAeJzeaJd7V1MsBd91WrH33k2OJePQsq3AHnRGZb+oZWEZ0Hzyqgb
         Pr94gUpgPvtBAfP2QnqMwT4fpqC+PkW1Tiw5ywIrU9yd+4XcQmKx2tvtdt5NHkj2f4sJ
         IViK/ltmUaRnPjVgWNIjifqoZZY8j5t3TUVtCkKt94mxs2y5jQrXJmRivZCUTmeH4bJc
         O28vJG4OmddTwHFdfz9bz47g6n2ojfx6Gd/rgyvkdA8KItQTdcXfNKewrmzFYyfKV/CK
         l4yg==
X-Forwarded-Encrypted: i=1; AHgh+RolDzyeeHTxz4DyEHudKTDKD++bAECHw4BDReIW6QRgYUtILcvUE9CE1NR3AF4IkQXsFkKOiiBDz6XjySjLq18=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8WgNuM0rydFRoCENCzK/Jw0IPibzjne0TYRTFwQ8Tbkm1gRNY
	Q0dAWl/KsxHlCy+HS8yERGoW2ZnzLTQ+nXuLXMqZdqKWuJug8ZWh9xGv
X-Gm-Gg: AR+sD12B8kX4ypk9blXbBGKqy47j2DKlgU35zzC2hhXfy8NujXNih36jqD8z7wUxStT
	ZRos0/ar+Q/WlsiBhIABtqE8Vsg2m82+TZpMHCm9576dNZs8nAP6+ibL0ON/scLWQCk+YBI+Bjg
	wOAPlK8NsYjY1w+oMjB2ckrVN2O+Fyj/u6A8NdCqG1m3v0LyN8+rj9IVljLVdhwXgdgpeELVufR
	n0dpbd6c+3aLDq7NuC3I/xw4StWNcwzSoKEysnIdrQOpAmr30P8+qBwCv3J/7edbcKddPGHHVsw
	HqWYGP5b10EPdJlLHKssUvrB1rPrWUmVLT3nxFP+rMYwtyMca6IlFpWBwSTa5o9edxdAD5rVpru
	VGAX4pIUpEXP8xgm5dSAeKG8uY4JQYURAIsO0msC+8QJ1O3USZo85G0b3ipF5MmtAmiqMtFIUgI
	Y2S7n5t6jv6a6cJzr6ahX4ioD3rKEP/nD5yAXg/0m/kgPUMqnlLpKne0Sa0eA7zmANdqdY7KemN
	PjSwce7wlJDVI7M59gzLBgOGQ==
X-Received: by 2002:a05:600c:628c:b0:499:87f3:a2a3 with SMTP id 5b1f17b1804b1-49987f3a33emr415143305e9.15.1786964125514;
        Mon, 17 Aug 2026 03:55:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm157881145e9.6.2026.08.17.03.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:55:25 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:55:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Taehee Yoo <ap420073@gmail.com>, netfilter-devel@vger.kernel.org, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>
Subject: Re: [PATCH 0/6] x86: add missing vzeroupper instructions
Message-ID: <20260817115523.7c6c646a@pumpkin>
In-Reply-To: <aoLRJ7igR5GTMfuO@infradead.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
	<20260816161450.05fd24f2@pumpkin>
	<20260816173159.GB2013@sol>
	<aoLRJ7igR5GTMfuO@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Aug 2026 02:15:19 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Aug 16, 2026 at 10:31:59AM -0700, Eric Biggers wrote:
> > As for kernel_fpu_begin(), no, it doesn't do vzeroupper.
> > 
> > I do think that some years down the line, we'll drop the use of SSE in
> > the kernel entirely.  At that point, vzeroupper in kernel_fpu_end()
> > would make sense.  
> 
> Or add kernel_avx_{begin,end} wrappers that include the vzeroupper
> in kernel_avx_end.  That would be a lot easier to use than the manual
> vzeroupper in every modern user of in-kernel AVX.
> 

You might want one in the start as well.
I have a theory that the avx512 logic was added as a completely separate block.
This meant it could be included in cpu for testing but disabled in any
released to customers.
(Or maybe the it is the original avx logic that used latches not in the
normal register file.)
A side effect is that different latches are used for the low bits of the
registers - so when you change to/from avx512 the register contents have to
be transferred between the blocks - adding latency.
So if the wrong registers are live for the code you are going to execute
the data has to be transferred across.

There are also other effects as well.
I found this link: https://travisdowns.github.io/blog/2020/01/17/avxfreq1.html
It is a few years old now (2020) but probably still relevant.
A quick summary is that the first 256 or 512 bit instruction starts a 9us
window where the cpu runs at 1/4 speed, for 512 bit that is followed by 11us
where nothing happens at all. 

	David
