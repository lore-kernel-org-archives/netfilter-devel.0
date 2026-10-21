Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571935;
	b=GdkBDXLSB6yJX4XTSrq0brmNQkTRhvCyg/7B5VLHVClYTLD+swAiKwXIkK6+vq48DuFU
	 FxjgyoI0br5BpKZxWhjWbhBPdKDO1bu6nn98rrb5q3RN0WUnNh5a6KVwcFYsrS1rD+2WG
	 hGz5Wo2stEoshsfChoV24R3EP3VfW0cpmtuaXx2Ywx2iRwH/VYoK48KVODR/DnypI35sV
	 /vQawhUncaGLTXEb+6txEseojCzSKfmyfqiSDp0bkR3XdQawWnnMWL6BZFBWpyerq31Vp
	 M0nFXFRXr+CwaJHhGHe3KpgLKRaYEqLDZYCnWwBKMu+AtndnZGH4irRpNVFKnyCwApA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571935;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=PJuMRO516eBfz4203ApPGfE69pf7gqI+uOYeoyYH0Zw=;
	b=LxA5C1wdrnb69B3agRoUv9ssBV6a9AkZhRHFvkta6L/Fho049gj31U/ee3Qxk2jgSPlh
	 V6i8UYh8mPNlKBjoBiXRHeJfBQNE/6ch7uadCSaBB8oO57yW/Cs+U2uZFl5bKDvWIkYBP
	 hLTHCB695WDxabEv+Zyko8Kfm9+zEMOnUABOE89htp+MunCDZQpzCJXJmoRxlPCtaUTcJ
	 8oO80UPvbchXIQG0naFAz8Jw6m7M+Of/JUjsR1r2KNmj2OhQpwl9YEnGMGNsbD8kOROUc
	 72ckeRr62ZAJ4pu8fxfioqvESiirGuwpEAqqZILpBRTD+oD6VFf5IobTMIqfe7+8TKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XBgSWeE8;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B5643606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 08:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5643606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XBgSWeE8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792571932;
	bh=PJuMRO516eBfz4203ApPGfE69pf7gqI+uOYeoyYH0Zw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBgSWeE8+roVs6d/Ey9j51zb0nWXqeXXxsFdljCtiLyvRAAP5QZFY/A1cdmtAXllJ
	 VwbQf9MI0zQtnpYxu9FMkkWOXUl8X82DKAZhG4sxUvogl3oFYBfMj5TC4L4nqL5Uno
	 c5xuwx7UEEu40vnu49FWgl0XjKYKmjWDOV/qBlNhdGtO25n9nxYPIotLI1MG69uhsf
	 4bmSMU21UGwSYrrrpddVFpbkD2n8zuNQhf8pEwjeYYx1z9heahabkKmAupmvhz1AQK
	 aicbUNMhOmv6h4cQaVz4o3/P3k2vTYFvNhDA/4iiDLGAnuhDwoEDLH32Zsd0q4BzyE
	 caak8EfwRWHOQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8A34C6005B;
	Wed, 21 Oct 2026 10:38:52 +0200 (CEST)
Date: Wed, 21 Oct 2026 10:38:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_payload: restrict checksum offsets to
 known values
Message-ID: <ath6GRzpTiUBUS1B@chamomile>
References: <20260904095723.18368-1-fw@strlen.de>
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
In-Reply-To: <20260904095723.18368-1-fw@strlen.de>

Hi Florian,

On Fri, Sep 04, 2026 at 11:57:23AM +0200, Florian Westphal wrote:
> We need to prevent userspace from corrupting e.g. tcp->doff, because
> many locations in conntrack and conntrack helpers rely on
> nf_conntrack_in() having validated the packet headers.
> nft_payload allows to alter headers later which invalidates this
> assumption.
> 
> The 'Fixes' commit restricts writes to safe fields, but there is
> another side channel: the checksum location.
> 
> Restrict this too.  Reported via sashiko/gemini.
> 
> v2: add missing IPPROTO_ICMP handling, else 'icmp code set 42' won't
> update icmp checksum.

This patch is now upstream.

Would it be possible to fully/partially revert this patch?

commit 968cc2c96390f06e56ed6a43f935bfebdefed28f
Author: Florian Westphal <fw@strlen.de>
Date:   Sat May 16 23:23:21 2026 +0800
 
    netfilter: disable payload mangling in userns

Thanks!
