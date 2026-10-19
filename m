Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3FC44AB9D;
	Mon, 19 Oct 2026 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383826; cv=none; b=PDSFriKTfCHizzeLHqIyWbsAzDj8bNHBXAhiVdCuSw4SX70CIfp47nyvP7Rpd2HCCWVXiszLPsFAmZMVa/t3yQz71QD2myzKKG3TIhn6BN2JUNUmiUxXzH2GYjqi6bsHDj7Z3BIAwAuRERhigpb+ZwO/FUR8euxULKST+45cdB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383826; c=relaxed/simple;
	bh=GCf69xTabV2HwT0HyegTs2srBMbNfXig8WeDb+mrLYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzB2C9Jc7U84OPwYdn7pfD5NbA8tbDxTrCuH/YKLZyshKcs+Xh2AMm9mDcPBe19dDKTMinQtUkjxulBJGYNsBsa4MY7efCM61jfKHU3JCftaX+d5/5IsfxGi5FzmbRH71e/retZVe3Kw1DuqRBCCGNHT2UQ+FZSF10mDreA+2mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 58ADB60272; Mon, 19 Oct 2026 06:23:40 +0200 (CEST)
Date: Mon, 19 Oct 2026 06:23:35 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 02/15] selftests: netfilter: nft_queue.sh: only
 queue icmp echo request/reply
Message-ID: <atWbR8bVksGgCcSZ@strlen.de>
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

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
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

Not really.  Was only ever caught by netdev CI which already
carries this fix locally.

> The flake looks like it started with:
> 
> commit 8a2cfe7951f6 ("selftests: nft_queue.sh: add a bridge queue test")

Yes.

> Would something like this be worth adding?
> 
> Fixes: 8a2cfe7951f6 ("selftests: nft_queue.sh: add a bridge queue test")

I'm not sure its worth doing.
