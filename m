Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C174973B1;
	Mon, 19 Oct 2026 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401185; cv=none; b=hPXm/pC7ptQ2T3XkIrtbw+J4epMbmvpNrDcmr0pfHCe2JMWNSlXOxMelodyPWfMpWTami8DTxbJnuRqm39FhiOPWCvFEzeAmoF9zk2w6/ICFA7aloz8vxpYz4FyRfLy+nTw71ELhylro8sX+hnHjjcCCcSRBDjwl52m3aXl+EBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401185; c=relaxed/simple;
	bh=JWRTXQL8/7H74DBLEueoM00W9qFRrWE/TcTomi2Nd+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoNba3ht7zrSfhdrZRC5FF9qRmiRbu+J3nTM1RQmtKwU42fjojKBGYP+0vGA3i+3AtgK3b+bsarGDcG7VMgYCPnSTiYkPkp5gHjfzayAsph6inN2nyb0Vl20JT791HAqwJW+l9AZo81ynA1NTZVELgehjs4dLKpQHNXfkSZv9fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rsHUBcGC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rsHUBcGC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792401181;
	bh=8vASRzbOHV4/8J6y2ioPV8ekfmQv6+fBqYtDp4Mpf4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rsHUBcGC047hxCOTiwU268TMzQ5UmQD/tFgHxFETu7QGpDftuzHCgI+DILV+4Opkg
	 +gX2AjIMqIgHM+1MpE58kvv7Iyhlse329qxut7PdY2iwsadUTEUYIwavZP2WC/L+RX
	 WYnDPrcLkSbZFByNt5pwcPSvk1g2UYqhqTFTV3sqdYL1u5upA4pvIf5F1g6ave+yaS
	 Ah2FJB5bO+LP2aQ4l6mjziDoob8EPeGV1EL4Gb4TsHGewXW78tTwYGThqcEji00EhP
	 Eq7whCshB9lfjJP+YMWzM5P9qzpsh6iKRnhRrWPlAyhmkNL8P4GEQddPFjckKy44fc
	 jYwrvl/OxINIg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 841B760057;
	Mon, 19 Oct 2026 11:13:01 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:12:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 02/15] selftests: netfilter: nft_queue.sh: only
 queue icmp echo request/reply
Message-ID: <atXfG5EVbX7kcPim@chamomile>
References: <20261018005638.1776148-3-pablo@netfilter.org>
 <179237288160.3135.9206589655813468272@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288160.3135.9206589655813468272@kernel.org>

On Mon, Oct 19, 2026 at 01:21:21AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit fixes a reproducible flake in the bridge NFQUEUE
>   selftest (about one failure a day in NIPA), but its message has no…
> 
> --
> 
> selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
> 
> The patch changes the ipv4 nfq rule in load_ruleset() so it only queues
> icmp echo request/reply, which the icmpv6 rule already does. ICMP time
> exceeded messages left over after the stress test no longer inflate the
> bridge queue packet counts.
> 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [Severity: Low]
> This isn't a bug, but should this have a Fixes: tag?

This is nf-next material, no.
