Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B224B351C34;
	Fri, 11 Sep 2026 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136534; cv=none; b=PFC7ZfzYYNb8pa/qOOtuD25CFHo6EONM2rR5ihz08MLOscuoxde6xBwaUXmB1OvpDr2c9Sdawgum/gVwJxAOGk9Acoy2y0yy65k7HjWsgCvop5L8IVzeyiZFHZ36SABwIeQgju1kDcDIZj5wqYEAFK2gb/BauBHopUXGqalvw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136534; c=relaxed/simple;
	bh=jmNvfqXjweVniseb8oBYU2SlAr/cTHg9c4d+ZJ85pK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1rllgNy80WjzN+qY91STWPJa9Jh9ScpQxxOHeoFm18IAI7yfEe9fpBTfW81yo0/Fztlu5rO2fzd3tsTM4HZAnKA7h6FTqKA5CTeppyoidISc9vFP42m/5xbY7viWY25RNDGBlOlNjpMDrzE2Cz0xlfxHJW6PPRRra4WFK2Z/ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dRmx73Q/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dRmx73Q/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789136530;
	bh=Ox7YSacdV7h2InVZd1Iw3kxrYUsfnmdCyCbV+t17m9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dRmx73Q/BqINvAznK12hHcya8HwHtUWWApvOp3949LNn7lbg00QuvV+XbJvOBjmqk
	 qnEwahN+MXSnHfEuFfB1jR68KSJV6kbVjaVJ/xb+0CiEn0uE2i1XBtRydooWhtihAe
	 ebUrtLoLjFoZWeD/L0U8JIzqTghuuQ/82VVra4VnwvUiGoKv/7Bzf/6sGEmuU0u2m7
	 B9XRVOFTG34sHFOjTeXMsKvEYcAF8eNJasho/uhyMrptFRXMDjNDfnCUrPAURY3wGk
	 ZT57vPYEODsmxnxI3PBQQnPCs+Bk0eIDIuYS8daqFCGitNr6DorRDxTwpAZhvEU6Pg
	 +/tE0aGrVoVdQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 06475603E1;
	Fri, 11 Sep 2026 16:22:10 +0200 (CEST)
Date: Fri, 11 Sep 2026 16:22:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	falemi@asu.edu, Simon Horman <horms@kernel.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: reject a forward path that loops back to the
 tunnel
Message-ID: <aqQOj8EHUb6ZzWjR@chamomile>
References: <CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com>

Hi,

On Fri, Sep 11, 2026 at 12:17:08AM +0000, Farhad Alemi wrote:
> ipip_fill_forward_path() and ip6_tnl_fill_forward_path() assign the outer
> route's device to ctx->dev without checking that it differs from the tunnel
> device itself.  When a tunnel's outer route resolves back to that same
> tunnel, the walk in dev_fill_forward_path() makes no progress and trips its
> loop check WARN_ON_ONCE(last_dev == ctx->dev). Release the route and
> return -EOPNOTSUPP when the resolved dst device equals ctx->dev, so the
> path walk either advances to a different device or fails cleanly.

I think we can remove this WARN_ON_ONCE() from dev_fill_forward_path(), ie.

diff --git a/net/core/dev.c b/net/core/dev.c
index ecfbd72d5d1a..c67900354fa6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
                        goto err_out;
 
                stack->num_paths++;
-               if (WARN_ON_ONCE(last_dev == ctx->dev))
+               if (last_dev == ctx->dev)
                        goto err_out;
        }
 
> Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> ---
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -375,6 +375,12 @@ static int ipip_fill_forward_path(struct
> net_device_path_ctx *ctx,
>  	if (IS_ERR(rt))
>  		return PTR_ERR(rt);
> 
> +	/* The path walk must advance: a route back into the tunnel is a loop. */
> +	if (rt->dst.dev == ctx->dev) {
> +		ip_rt_put(rt);
> +		return -EOPNOTSUPP;
> +	}
> +
>  	path->type = DEV_PATH_TUN;
>  	path->tun.src_v4.s_addr = tiph->saddr;
>  	path->tun.dst_v4.s_addr = tiph->daddr;
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1863,7 +1863,12 @@ static int ip6_tnl_fill_forward_path(struct
> net_device_path_ctx *ctx,
>  	fl6.flowi6_proto = 0;
> 
>  	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
> -	if (!dst->error) {
> +	err = dst->error;
> +	/* The path walk must advance: a route back into the tunnel is a loop. */
> +	if (!err && dst->dev == ctx->dev)
> +		err = -EOPNOTSUPP;
> +
> +	if (!err) {
>  		path->type = DEV_PATH_TUN;
>  		path->tun.src_v6 = fl6.saddr;
>  		path->tun.dst_v6 = fl6.daddr;
> @@ -1873,7 +1878,6 @@ static int ip6_tnl_fill_forward_path(struct
> net_device_path_ctx *ctx,
>  		ctx->dev = dst->dev;
>  	}
> 
> -	err = dst->error;
>  	if (err)
>  		dst_release(dst);
