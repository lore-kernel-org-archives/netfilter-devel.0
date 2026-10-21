Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571440;
	b=QysuK3THiiu8/EC4CePbRIBD4/r/+KIid/RQbaOTPOvVIBc7qpARjJYaO0sXawDaQk+z
	 G2CbHY6Na/ZPxpSmMAsK0nKDUXsYQ1FMIKskqhqFux2yTUv4GvS4FAE6s0sM5DWKd4ftn
	 MO/27OhSAuqk10ZfRJief9yjfM90pA1FDfBunsE4u/eiYFC2vJQCxoacjNz+I8RuXg/LO
	 Qi9pqcQaPTwcZtfNksx7HAVfCnQwQU9RNbCsQDIx+KOIohDu2JwsijxmxOZyLXzIZtN5t
	 7SUIG51K/U+dILyWhywWAiua1DJJeT39pvEWHNaY/Prc7jn0d2cKckeyqOLj7GlKqPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571440;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=I21KXYksiFcu0HU/9GrDZ7zGI2vEVIt9EwGGx3C0e+k=;
	b=5iXKP3KilkLnYUqLMX3Btc1VMY2ALNoA1cS1wLZr4Gq4Bc1EFu9CJyZkrMwNfmDmqJzT
	 xWWOkfqQeczYjmbyqFh//P5NFxWB0Y4Mxim5CdslyNezpE9g8/KSA0WoC1LPayB11u9qt
	 Lbcf7qDN3XBE9sa/0lMKDYaTBrghejYrWQnzLC9sVQUVd/ZZLZnIkbTbUU4/nfMxDtbiy
	 80Z307bgH4TmUqSgm5OeVavelXBOVBEgMn3tw8zOFimV+SKJjUqMlxV4SK3rRicMCvSTH
	 J3goQjf5mVYGCTunZXQpGID+g4EgkyNcF72YQP2X4/GI0W1mOmSV4JE2koDXAomSwow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="mrH/J4Zr";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DF935606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 08:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF935606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mrH/J4Zr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792571436;
	bh=I21KXYksiFcu0HU/9GrDZ7zGI2vEVIt9EwGGx3C0e+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrH/J4Zrcscq7MSxdpMcbBfk6Ub/hvx/sxMrqdr4v2wcjcj5oyv8LMkpBgep8x/xX
	 oU/cT2/AY8G11QjJVkXf6fBYWwb0OooXsONAt8OTmHclrZ1cyR35lJGysRCyAcvk8t
	 57bynqlDPy5s9OH0xCG885mHoVjkyiaHRAHmz6GX/aUVZJYPF9YO4n7BCp80aD13IP
	 hSq23fBcKpZHYAngGyJlY7bAQFT0fnpknwROJlef/k2shP0S04qFJ6NkzBvqghUitd
	 bb37iD8bwmyHZV2XyuBL1CMFtmSKlyml1kgsNk3a42XBTcv/qa9Gl7Bt6YIkA/kmBo
	 v4607F3RjS4rw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 55D4060055;
	Wed, 21 Oct 2026 10:30:36 +0200 (CEST)
Date: Wed, 21 Oct 2026 10:30:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Pulse Zy <zypulsecore@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: apply the receive buffer size
 to the event socket
Message-ID: <ath4KREFLT3z0cR9@chamomile>
References: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
 <atf2bRP7z2j8gogm@chamomile>
 <atf25JhLxwTY8kha@chamomile>
 <CAC9WPdzTfkn+-XyJ+_9n8Y03KHhaATQYnegt6nPQ5rcFHx=+qA@mail.gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC9WPdzTfkn+-XyJ+_9n8Y03KHhaATQYnegt6nPQ5rcFHx=+qA@mail.gmail.com>

On Tue, Oct 20, 2026 at 07:55:43PM -0400, Pulse Zy wrote:
> Thanks for applying the patch!
> 
> I checked the commit and noticed that both the author and committer
> are set to you. Would it be possible to correct the author to Yuen Su
> <zypulsecore@gmail.com>?

Too late, sorry :-)

> I also noticed an unexpected "Signed-off-by: LLM" line that wasn't in
> my original patch.
> 
> Sorry about the formatting issues. I'll use git send-email for future
> submissions.

Those were my mistakes, next time I will request a new (ungarbled)
patch instead.

