Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E122F4309
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749756827; cv=none; b=H5XqNVL6SI0O+oys0ZILUyKgVds0VJbOCxEmrwMn9Tii+VeUFo1LCNtmC5zDTpRQO4m7v+LFkKRebQ4tbj4KtvzL8pDTlcdM6XwlS6ujirL0nkdokjT/ANH9LlZINii3vNGF3HEvAuHB5s0K3IptjU/vrQr11br90pxtk25Q720=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749756827; c=relaxed/simple;
	bh=QCg2VqgsxPYooOZWhnXKqi2n25zr5a1LcOV1cKQ+INc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvdufRvVx4xBfqnPYcg5NVI/dv/Udao2NSCd798jXJqS6x/qaeSzurN18XcZHRJ/4QVBKlGxxTI56NBJHdFfS0SFFTienAMvP0y+E56f2+l45Qui+MRz2cjN1kdKJNLgWFCpr/YrU3KTjeCms7GIou8Juz90PcnENwpyGcpg+XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pD22dSa8; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pD22dSa8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pD22dSa8";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pD22dSa8"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 79FBB60377; Thu, 12 Jun 2025 21:33:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749756822;
	bh=vMjytzqt1dzEhisZ1nonbB5gzs1waxJvscMMcryXUX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pD22dSa8EQMN4FbfDZoGZYHLaYkQ1Ygn35i0yJlVI3dSJcwnn8EMmph1khJQkQHLt
	 7XtBuFfxHArys6XoxFGGsjD3socb11OAksw3yAl9B1OdWKbrZMdXZ9hVepuEN9VNJl
	 MSvEnHcMOuvybm2wEP5YYzfMOibR0yzIWsXifMcN25A1PSXQ99fLANLtP8fzMr3Sl+
	 H2sxLeb9z/f1qOVkCHgZXTDJqGOiYhDqSFPPC5C3fUEj0aGoaLWrYpF4Y80cZTjhup
	 F+q9HLgcjBrW5mB9k2XLsgBUkLrLd3nPI+ruQ3JoCnu6rdUlhlfK/z3nW3E/THyrNn
	 vcFNzKgnDI+fg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E029E60377;
	Thu, 12 Jun 2025 21:33:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749756822;
	bh=vMjytzqt1dzEhisZ1nonbB5gzs1waxJvscMMcryXUX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pD22dSa8EQMN4FbfDZoGZYHLaYkQ1Ygn35i0yJlVI3dSJcwnn8EMmph1khJQkQHLt
	 7XtBuFfxHArys6XoxFGGsjD3socb11OAksw3yAl9B1OdWKbrZMdXZ9hVepuEN9VNJl
	 MSvEnHcMOuvybm2wEP5YYzfMOibR0yzIWsXifMcN25A1PSXQ99fLANLtP8fzMr3Sl+
	 H2sxLeb9z/f1qOVkCHgZXTDJqGOiYhDqSFPPC5C3fUEj0aGoaLWrYpF4Y80cZTjhup
	 F+q9HLgcjBrW5mB9k2XLsgBUkLrLd3nPI+ruQ3JoCnu6rdUlhlfK/z3nW3E/THyrNn
	 vcFNzKgnDI+fg==
Date: Thu, 12 Jun 2025 21:33:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/7] tests: shell: Adjust to ifname-based hooks
Message-ID: <aEsrkwSJ_sXIgOvi@calendula>
References: <20250612115218.4066-1-phil@nwl.cc>
 <20250612115218.4066-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612115218.4066-7-phil@nwl.cc>

On Thu, Jun 12, 2025 at 01:52:17PM +0200, Phil Sutter wrote:
[...]
> diff --git a/tests/shell/testcases/transactions/0050rule_1 b/tests/shell/testcases/transactions/0050rule_1
> deleted file mode 100755
> index 89e5f42fc9f4d..0000000000000
> --- a/tests/shell/testcases/transactions/0050rule_1
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -#!/bin/bash

I would prefer this test does not go away, this is catching for a old
kernel bug if you take a look at the history, ie. it is an old
bug reproducer so...

> -
> -set -e
> -
> -RULESET="table inet filter {
> -	flowtable ftable {
> -		hook ingress priority 0; devices = { eno1, eno0, x };
> -	}
> -
> -chain forward {
> -	type filter hook forward priority 0; policy drop;
> -
> -	ip protocol { tcp, udp } ct mark and 1 == 1 counter flow add @ftable
> -	ip6 nexthdr { tcp, udp } ct mark and 2 == 2 counter flow add @ftable
> -	ct mark and 30 == 30 ct state established,related log prefix \"nftables accept: \" level info accept
> -	}
> -}"
> -
> -$NFT -f - <<< "$RULESET" >/dev/null || exit 0

maybe simply add here:

$NFT flush ruleset

to get the same behaviour in old and new kernels.

I did not look at other tests.

Please have a look at the history of other tests to check if they are
also catching very old kernel bugs.
