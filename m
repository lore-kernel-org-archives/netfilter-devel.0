Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CD21D00A;
	Wed,  8 Jul 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525368; cv=none; b=d0QZbf2WNFsoutV0xups5Hg/Pv6IxHV7+ltNvAvg6+sOOC6MRBPc1L5upPjUWrGXIVffsblEUw97ExZjsGzi/rSWbWoDdivvzqRCif6KJIJfoGltx5OdWVLyoGCWTN+G5bInjc9nZHjxkudGbN95R+wIwWdkz1YFM7TVTl0BoBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525368; c=relaxed/simple;
	bh=3Rgz5aSdLjcn9P9NJ5ycATjcGC4fqPlnAnuRQ6mZ7lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImGuOkcZCIjloDfisArzKECcWlUd21Az1goOMPV2fvt83H5wnGW5hmpabFySqYcnaR9Y7GCc0bm5AmLMhIX6csMJ+uI7hrFUwQ6fZeBGGOeNA2s/FWmp3XdEl9YhMdNlLn4MziR8C64HLuFvGS1Keq9Fgnt6DmZ+DPmOPviIOeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gn6rvqAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gn6rvqAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B081F000E9;
	Wed,  8 Jul 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783525367;
	bh=z8G4ySDxrBxiw7vE5zCZNQMuZH1PKOgcqPuxK0wO9ho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gn6rvqALBpAAHyIFjjhkCZJJgwTDtO+5mSmMjp5t1xA8vxr64X++w7zdYpti6YHDw
	 i0SwL5wsReAjwxx5pFUu4cJh26y7dS5iNYLf/JarbugsXHrDhIuqr/TAMkQXF2gOwE
	 0g4Qmi0SIdmbTmTXbuyHWoVWleP7JARWwi5mhHsa8dLQtwUeKnns9kllpOrxZ9uF24
	 ryP9fPyRMdJ+tkHpLCPMmZyX88JdkzB1WLm9rpm3aCmQRB0w/x9jSzPU5Rwr9THPYd
	 l8isRZ89brdHuXySb3udACcYtlqjEbHFbXp6W3Q2GBgmulX41eYvXugjzaPVH57Jtd
	 Brgwd2e8YBniQ==
Message-ID: <7ced7e02-ab6e-4ba9-bb7c-ab158895780e@kernel.org>
Date: Wed, 8 Jul 2026 09:42:46 -0600
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: ip6_tunnel: use tunnel parameters for
 fill_forward_path route lookup
Content-Language: en-US
To: Lorenzo Bianconi <lorenzo@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20260708-ip6ip6-route-lookup-fill_forward_path-v1-1-863b9647102e@kernel.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260708-ip6ip6-route-lookup-fill_forward_path-v1-1-863b9647102e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/26 6:48 AM, Lorenzo Bianconi wrote:
> Pass source address, output interface and flowlabel (carrying TClass
> and flow label) from the tunnel configuration to the flowi6 struct in
> ip6_tnl_fill_forward_path(), aligning the route lookup with the slow
> path in ipxip6_tnl_xmit().
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/ipv6/ip6_tunnel.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index bf8e40af60b0..557d8637ac57 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1847,6 +1847,10 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
>  	struct ip6_tnl *t = netdev_priv(ctx->dev);
>  	struct flowi6 fl6 = {
>  		.daddr = t->parms.raddr,
> +		.saddr = t->parms.laddr,
> +		.flowi6_oif = t->parms.link,
> +		.flowlabel = t->parms.flowinfo &
> +			     (IPV6_TCLASS_MASK | IPV6_FLOWLABEL_MASK),
>  	};
>  	struct dst_entry *dst;
>  	int err;
> 
> ---
> base-commit: 08030ddb87b4c6c6a2c03c82731b5e188f02f5b9
> change-id: 20260708-ip6ip6-route-lookup-fill_forward_path-9fc45a9118e9
> 
> Best regards,

Reviewed-by: David Ahern <dsahern@kernel.org>

