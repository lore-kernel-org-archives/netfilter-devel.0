Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564471;
	b=0MC/kQcvB8GoP8n6JvMaNkm5EpCfB4+psk8ZM0duT1A8idi/V94iqy+ICcsl9XI1FTfv
	 rIgPtc9R/eEEse/ICYmBIQ8ReD7URnXEhe/ynAn4mAwi/+W0baRKEOJ6jJ0Y52En8vTOX
	 uxZQHWGRPgUPuDs4M6ejyWi4Uson35Eu9VSDkh58ah1R8ABRZRUAWZ6zUrmk6sHrLVhpy
	 /T5zITUC2jc1MsWiC8oDSPXaJ+qgB0dswf7KwEks999Bv52yxdFHnwf3F7F/m/6Hb9w0q
	 wb8yklPgoxrm57bkwTLXbcX9YfusvcA4jFwOZmUqDh4aWTehA0lqGMSImRTaZ1DDXyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564471;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=GlGwbehiy9ttRfbymlSIFT7D5jNMm//6mExYM/5QhfA=;
	b=FEYREXDrFoWqNK7Bb/8xWaduTZ4V+1KtAU0Dy7IdZoCo14XGL6Mn11l5UVAq8r9W66Pk
	 LosZEY4gXM1zpbewt0UEVHRz3LCNwLEU7qflqp2GPkOyBw5BUmjGyw73TluvJVJLRX97C
	 KIaw15FSgII7Df82PclFPiGiIND6uFnQVpUQmmpT5VSqjHAJLM2ZG0m0A3b3FeNNuVZ6i
	 n9Wt7sJyPNsi+lVHaJbYvgY5gQenzpO7ExajQQotPQMdHJrX3UCO51xciIz7QZZJjMRl0
	 f/OxFrHPDpz3oY2OTjyUTjd1ZQlCFV4J6IDFSoRaMfG6MOum5x3mwECVM87rp9+Hh1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rB2qfUxC;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 038B7606A32D
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:07:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 038B7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rB2qfUxC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794564469;
	bh=GlGwbehiy9ttRfbymlSIFT7D5jNMm//6mExYM/5QhfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rB2qfUxC9YNztSSBy4P+StI7ZnZ6OoaNHEiCn4rXu5XrL9tGzBf7BdgVVU38vIHNK
	 0K4I3X7bIqd+O/4Lav6ZFigAmEXS/lSbw3wWbU/lVkw0v4iTQ7W9iXi3uLwRxuVfiv
	 P4JvXexjT8yqfh2rfYUKVlDXKjKrSa6Ck0VyRUw/yisnzKk63qqYVxAlk+2CX/Hyfp
	 nkhBcH6pqJubfSp7E/bn7BndGPdzwOzL2CjpzHbuT6LsDiqfLfl6TEHru2QcN0gS3T
	 Y/J7912VIMjoqL9RrKbv8bIVZIeDpgdRLoxMB0C9QMicsUgeX6B9EwA5tBKNBiaRNU
	 paadxX9oiED3w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D6E8D60055;
	Fri, 13 Nov 2026 11:07:48 +0100 (CET)
Date: Fri, 13 Nov 2026 11:07:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH nf-next RFC] netfilter: nft_exthdr: add inner option type
 search for MPTCP
Message-ID: <avbhcvVfMptkFUyV@chamomile>
References: <20261008174030.6536-1-fmancera@suse.de>
 <3424732e-6dec-4bb8-8f33-6f4b8a430de0@kernel.org>
 <31dae787-d58e-4b45-815d-e79670906767@suse.de>
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
In-Reply-To: <31dae787-d58e-4b45-815d-e79670906767@suse.de>

One more comment.

On Fri, Oct 09, 2026 at 03:05:34PM +0200, Fernando Fernandez Mancera wrote:
> On 10/9/26 12:22 PM, Matthieu Baerts wrote:
[...]
> > 
> > > +			if (!(optl >= 3 && (opt[i + 2] >> 4) == priv->inner_type))
> > 
> > Can you not use priv->offset and priv->len not to have something
> > specific to MPTCP?
> > 
> > But then, you need to keep the safety check around them before this. And
> > you probably need to check that the length is <= 8 at parsing time.
> > 
> 
> We could allow that but I do not have an usecase right now. If we do have
> one, please let me know. This new _INNER_TYPE option can be also used for
> SCTP for example, but that would need to be implemented later.

Would it be easier to add the SCTP support later if this is all
generic? Or generalizing it as Matthieu suggest is too much work?

This will require a new kernel patch in the future. Allowing for
userspace updates to support new feature is convenient.

This is not a deal breaker, let me know.
