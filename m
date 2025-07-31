Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07AC2907;
	Thu, 31 Jul 2025 23:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754003796; cv=none; b=GNjTXHfe26x7EozSYFe1diK8VpsDEXdLjBhke8C1WHgi7cWH/cwLQAtxz21waxiEHdYzIcNW9bZWkVkXaVdo/Kzv+PUPrQrQI+gXfKvC7fQK/vNylTVT8w0CwrfUZyIt16g65VuKYoZwHAoDhZyswsDVu8YDlHmoTlBPoLOQNyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754003796; c=relaxed/simple;
	bh=OZjtIxJzwLS8eVHfDEPQ5JMu/j3Yi34YtkloLo95LE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCi5XAK3HAT3eD5VEeKdS8IeiYIO6wpAaqGmJTxi7e7Y7tuZ/dqMRYVbPUtcurNhTtL7yfMlP4R+nRMy8lezJCHdb3lcMMnyeMJ0OXyM07s6gF9OQ/uWGjpfTXPtAIaroUj3wyESxAfd5er+lnUejSYDFTfYJXancgXu1rlMHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E4VVwf8B; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=injUDuGR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E4VVwf8B";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="injUDuGR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0052F6026B; Fri,  1 Aug 2025 01:16:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754003785;
	bh=9FBV9J8jsn5V8EAdQjjAkkhqaFNKGRAtm3BqWnb/tM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E4VVwf8BcP7YqL8Pzn7Bpg0Sx4D0MP2u2NZk9hacBTiIjlKoW9mXCVHLCHer/BE+b
	 y/BOtJBaHsjjulaRE+3BZxBVjQJrwrA3fkcuJel6WxOkgok28FQHy/ykXkHU76Ptxm
	 6Eryc4B5YhstbwE1xFKHqx4TdPA+uW5rk+UJSBCXWM3T5tRMFgl3IXorzSs1BOJwfz
	 mbSXdJNEJw2G4NZ+A8VfHXCB7JL+uy60NtWY/LdiOftHJwCLOpH4XfT6408KXoB/AP
	 rxP+0ndk/njCz7lW1oIqFQeZy/JeebzBuLRAtd/qp+jk3NeTD7FzL2bid7nksbo8m/
	 jkynKZ4XGPztQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D4A060265;
	Fri,  1 Aug 2025 01:16:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754003784;
	bh=9FBV9J8jsn5V8EAdQjjAkkhqaFNKGRAtm3BqWnb/tM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=injUDuGRnQVYqVo3mR5AgLmxdzk18vKAPKlfTYNd+t2XKUxJ1cWpntDLbSp45BBC1
	 Chs1tzjyZ7kgnCqS44zswjahUNm4ZjvPbEEgTPhv5hQHbCxA1JnVWjS5D2lCopx/L0
	 aLM7W5Che0mMVZwWLYVecYDhCwzdiz1M5yxpbiTCu+HP4n/QgwAWuPBIedx2Y9f76l
	 EGtYQDT6/VcL4EdGWo4esdleTAOSvZcrC80xkloBApoQGE9OxyLCMSQuED5AHRrktc
	 53MoUyoV5t+7WYHMdwEtkSmxj6GdVajfPjf5eDFvXqaRD3II7yZ+tF5awzYP9g9klG
	 qfHt8pAkUFjJA==
Date: Fri, 1 Aug 2025 01:16:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org
Subject: nftables 1.0.6.y stable branch updates (strike 2)
Message-ID: <aIv5RcJY6RycFRFc@calendula>
References: <Z5J7Vh5OPORkmmXC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5J7Vh5OPORkmmXC@calendula>

Hi,

I have updated the 1.0.6.y -stable branch:

https://git.netfilter.org/nftables/log/?h=1.0.6.y

This branch contains 334 selected commits out of the 887 commits
available between v1.0.6 and git HEAD.

I have backported tests/shell and tests/py based on git HEAD on this
branch, so this stable branch is self-contained.

- tests/shell displays:
  I: results: [OK] 428 [SKIPPED] 23 [FAILED] 0 [TOTAL] 451

- tests/py: No errors. This includes -j for json testing.

I have tested with libnftnl 1.2.4 and Linux kernel 6.1-stable.

I might still collect a few more recent fixes in git HEAD from the
last two months.

Proposed plan is to release this -stable 1.0.6.y after nftables 1.1.4
comes out, in the first two weeks of Aug 2025.
