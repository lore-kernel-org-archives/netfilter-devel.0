Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C874468E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 09:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716197802; cv=none; b=biPuqy5ygODLJZF7pBO5OMeFnldmKWSNotvN1fTrTWO3fApC/mFocVHNGEtMBF+Q4TUzv9qoYu2SmlfsVL5iW8bmYakfu5NZxvydFcs2qQW47Ugg7SFkW8GE/6KLjkVKcamoQTVgDoN3sylb7mjzImNlZDN7nGPJrtkXHTPNglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716197802; c=relaxed/simple;
	bh=aqIGGNopsKQTSeaOgeT3M+lU2KbNgWaS6cqcw7UNW8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHFEO0Fj4mbcMRg7Hg/fVIIXYoMo/TG98HEVnsRKcav3MJjMDT4PzmnxxZ/NL+8SvtLRYopZsqy9Q6K3zHyvjDKQHxur0bwFqf9A4aGTBWephk7A2PkATD360Dk+Kmhg/HCjkOzg26UYmA/XXM+rUMm5bGsdaATh1qyxTil9xDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 20 May 2024 11:36:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netfilter: nft_fib: allow from forward/input
 without iif selector
Message-ID: <ZksZo2vYHEmxMZZN@calendula>
References: <20240517153807.90267-1-eric@garver.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240517153807.90267-1-eric@garver.life>

BTW, one more comment below.

On Fri, May 17, 2024 at 11:38:06AM -0400, Eric Garver wrote:
> This removes the restriction of needing iif selector in the
> forward/input hooks for fib lookups when requested result is
> oif/oifname.
> 
> Removing this restriction allows "loose" lookups from the forward hooks.
> 
> Signed-off-by: Eric Garver <eric@garver.life>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +--
>  net/ipv6/netfilter/nft_fib_ipv6.c | 3 +--
>  net/netfilter/nft_fib.c           | 8 +++-----
>  3 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index 9eee535c64dd..975a4a809058 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -116,8 +116,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  		fl4.daddr = iph->daddr;
>  		fl4.saddr = get_saddr(iph->saddr);
>  	} else {
> -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> -		    priv->flags & NFTA_FIB_F_IIF)
> +		if (nft_hook(pkt) == NF_INET_FORWARD)
>  			fl4.flowi4_iif = nft_out(pkt)->ifindex;

is it intentional to remove for the priv->flags & NFTA_FIB_F_IIF here?

Maybe only the last chunk below is required?

>  		fl4.daddr = iph->saddr;
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 36dc14b34388..f95e39e235d3 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -30,8 +30,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  		fl6->daddr = iph->daddr;
>  		fl6->saddr = iph->saddr;
>  	} else {
> -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> -		    priv->flags & NFTA_FIB_F_IIF)
> +		if (nft_hook(pkt) == NF_INET_FORWARD)
>  			fl6->flowi6_iif = nft_out(pkt)->ifindex;
>  
>  		fl6->daddr = iph->saddr;
> diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> index 37cfe6dd712d..b58f62195ff3 100644
> --- a/net/netfilter/nft_fib.c
> +++ b/net/netfilter/nft_fib.c
> @@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	switch (priv->result) {
>  	case NFT_FIB_RESULT_OIF:
>  	case NFT_FIB_RESULT_OIFNAME:
> -		hooks = (1 << NF_INET_PRE_ROUTING);
> -		if (priv->flags & NFTA_FIB_F_IIF) {
> -			hooks |= (1 << NF_INET_LOCAL_IN) |
> -				 (1 << NF_INET_FORWARD);
> -		}
> +		hooks = (1 << NF_INET_PRE_ROUTING) |
> +			(1 << NF_INET_LOCAL_IN) |
> +			(1 << NF_INET_FORWARD);

I mean: This chunk alone to remove the hook restriction should be good?

Thanks.

>  		break;
>  	case NFT_FIB_RESULT_ADDRTYPE:
>  		if (priv->flags & NFTA_FIB_F_IIF)
> -- 
> 2.43.0
> 
