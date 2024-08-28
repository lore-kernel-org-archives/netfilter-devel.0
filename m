Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F0158557;
	Wed, 28 Aug 2024 08:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724834540; cv=none; b=nbek24mHsQvFD+mqFs30DrAQWyL6WjRzImz1gAkSDrrO0RPVjOPsfL4SvFToX8ppYDOoYDQ6eoeF8NFaZvFQJ6Cgi0FpN3S4+IT4osJoySC1k46PmJY4GusqKq2nJscRAP3zK/yVL4aeaJzAOadQcrwEIZKQ46DpRJE2bECUwzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724834540; c=relaxed/simple;
	bh=Jqji/OU5zPaYLK49qv5dPpFnqUYmnoNDuMYCKoFeFi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJyqEyN0QPI+DJTPqgDhlurg1rxurBppTC1PmaS39O3Jynx2JgNbWlieclMnRLvbinyvnYAfUoPQ1zWCuLdrnxDHI+t8TaszrSAJEEQNyiaXF28IoRhJyTpJwTdkywz82ZJ7eIQxW52GWUD8u0GPjHt31R0B4HmpSY5I3gkYuTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38628 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjEFm-001ERJ-IS; Wed, 28 Aug 2024 10:42:12 +0200
Date: Wed, 28 Aug 2024 10:42:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: kadlec@netfilter.org, roopa@nvidia.com, razor@blackwall.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, dsahern@kernel.org, krzk@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 4/5] netfilter: iptables: Use kmemdup_array()
 instead of kmemdup() for multiple allocation
Message-ID: <Zs7i4PSQQEI0tHN6@calendula>
References: <20240828071004.1245213-1-ruanjinjie@huawei.com>
 <20240828071004.1245213-5-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240828071004.1245213-5-ruanjinjie@huawei.com>
X-Spam-Score: -1.9 (-)

On Wed, Aug 28, 2024 at 03:10:03PM +0800, Jinjie Ruan wrote:
> Let the kmemdup_array() take care about multiplication and possible
> overflows.

No patch for net/ipv6/netfilter/ip6_tables.c?

We have yet another code copy & paste there.

BTW, could you collapse all these patches for netfilter in one single
patch?

Thanks.

> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  net/ipv4/netfilter/ip_tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index fe89a056eb06..096bfef472b1 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -1767,7 +1767,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
>  		goto out_free;
>  	}
>  
> -	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
> +	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
>  	if (!ops) {
>  		ret = -ENOMEM;
>  		goto out_free;
> -- 
> 2.34.1
> 
> 
