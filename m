Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261F2D77F7;
	Fri, 18 Sep 2026 08:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720782; cv=none; b=QZwiiocCW5Lix3qYyVm9nOJD1ciCXrxzKankG2Xs5yM5zdm3xJ2ui057l2ySU7nvIKzbsBg2TLhspszK1jR7p9tSjh3tVYPdSLqaeMysKIPVosYTzfXYqmIGKTBrLrTyGf/x2cM1lzLo8FhKLvpbwO5hrrRP/z//jOJVIVKCfQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720782; c=relaxed/simple;
	bh=/enAIZSBnlX142TokEScnZDa0HFhd01Kf4q2bxPCU5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsvMBq/0n4O9w8J8PcEoTjM8I/fHUSN0vS68oOAn0dMI9DF0PswpZRm1hhQzbnyl56aaFOEoKxmuPAvXaSLtjGhuKtzr5jnWgKn2eRTCQ4bh+R6VNhfYu08EMMidIbkaAD4uQ1nqRVj9S8vtyh9Ud1wjXw1jFfD/ciiq1jqN0nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UfuPwiFZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UfuPwiFZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789720779;
	bh=kRhxF2Wuo4DRkTtstH2i5BePR3mP1GrPguVSj6gkjns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UfuPwiFZ1kfTiprhfRBy4Si4ZP3naqKcOw9/K7HuzMNHB2bUkEaZm/KHoaklNTFGx
	 QckHnLt6cyBkOhj8TIZHpXhWg8XOwN2KWu/1BqbxOWE7n4fxPOD5FJSXXW6kTlOrml
	 Q7UhPz13dm2CoDRZQv7nipAd47vWnFnefrS7pU6gNyTztoL0BRIP4YkMGYL4zhgScA
	 zQdsuMTnFEmCKloHAeMOiAzeKmOFchv+KoDmFcOIpFVcfsQ4hWeuu6IZWF3o8onRLR
	 Sjt7WgwNWOgwBvIjY/CRAgVg67nxQtP3GC+rHwIy4T/paHfTJ1Bt2G1rNY+mutFB0Z
	 JSoIurKQiwG+w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E3E6660052;
	Fri, 18 Sep 2026 10:39:38 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:39:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 03/10] netfilter: ip6t_rpfilter: reject routes
 without inet6_dev
Message-ID: <aqz4yMLaZD7w838m@chamomile>
References: <20260916231652.127456-4-pablo@netfilter.org>
 <20260918020410.3513378-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918020410.3513378-1-kuba@kernel.org>

On Thu, Sep 17, 2026 at 07:04:10PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: ip6t_rpfilter: reject routes without inet6_dev
> 
> This adds a NULL check on rt6i_idev right after the ip6_route_lookup()
> call in rpfilter_lookup_reverse6(), so routes that survived in the FIB
> after their nexthop device lost its inet6_dev are skipped. It protects
> the later rt6i_idev->dev dereferences in the same function.
> 
> Closes: https://lore.kernel.org/all/VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh/
> 
> > diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> > index 67c87a88cde4f..b5def30c3127e 100644
> > --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> > +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> > @@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
> >  		fl6.flowi6_oif = dev->ifindex;
> >  
> >  	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
> > -	if (rt->dst.error)
> > +	if (rt->dst.error || !rt->rt6i_idev)
> >  		goto out;
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but if rt6i_idev can be NULL on
> an error-free route, does the same dereference remain unguarded in
> validate_ipv6_net_dev() in drivers/infiniband/core/cma.c?
> 
> drivers/infiniband/core/cma.c:validate_ipv6_net_dev() {

Not Netfilter related.
