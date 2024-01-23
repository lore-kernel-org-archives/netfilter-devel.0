Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6667F7F0
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706029825; cv=none; b=G2s3vqIQiJELAbMJyAu61c7nT1Ok2T1W9Rznkpxhj5dLhqCXSRouyYCFYjZWywstFb78Jh3Cr9M7eLjTt6IfcIi/+j2GDmv3y4KIU/00XNUjoyBNApOMugoXYipbzUPhz3LP9u8anIW+vasPLrkRRDX1UVmp/8m9UMh6FLit84c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706029825; c=relaxed/simple;
	bh=uoXk9a4YSw2Mof6UGbmt5i+C6dr81hrrg8AvR531GNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6TvtGAy7rj59puoNmhpWkuBeGV2VBJs8fuF+1ieBz+woVb+jORO0RPuR+jmc7LguxxjAQp6YZp1jD9FosntskAcymeqB6gOg3rzfpkmLPlOzKKtGDSA9cnONxWqWONYm4PgDy8H8Q7xVD+e4AplJTVddEJQyaKocYvyg9iidoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rSKI1-0002Id-Qv; Tue, 23 Jan 2024 18:10:21 +0100
Date: Tue, 23 Jan 2024 18:10:21 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: validate
 NFPROTO_{IPV4,IPV6,INET} family
Message-ID: <20240123171021.GA31645@breakpoint.cc>
References: <20240123161333.39189-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123161333.39189-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Several expressions explicitly refer to NF_INET_* hook definitions
> from expr->ops->validate, however, family is not validated.
> 
> Bail out with EOPNOTSUPP in case they are used from unsupported
> families.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This is v1:
> 
> NF_INET_* and NF_NETDEV_* hook definitions overlap, and .validate refers to
> hooks only in several expressions, not families.
> 
> - synproxy refers to NFPROTO_BRIDGE from eval path, however, .validate does
>   not refer to bridge hooks.

Probably those NFPROTO_BRIDGE should be removed then.

> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 5284cd2ad532..61f5498b73ef 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -350,6 +350,11 @@ static int nft_target_validate(const struct nft_ctx *ctx,
>  	unsigned int hook_mask = 0;
>  	int ret;
>  
> +	if (ctx->family != NFPROTO_IPV4 &&
> +	    ctx->family != NFPROTO_IPV6 &&
> +	    ctx->family != NFPROTO_BRIDGE)
> +		return -EOPNOTSUPP;
> +
>  	if (nft_is_base_chain(ctx->chain)) {
>  		const struct nft_base_chain *basechain =
>  						nft_base_chain(ctx->chain);
> @@ -595,6 +600,11 @@ static int nft_match_validate(const struct nft_ctx *ctx,
>  	unsigned int hook_mask = 0;
>  	int ret;
>  
> +	if (ctx->family != NFPROTO_IPV4 &&
> +	    ctx->family != NFPROTO_IPV6 &&
> +	    ctx->family != NFPROTO_BRIDGE)
> +		return -EOPNOTSUPP;
> +

Both need to permit NFPROTO_ARP too.

LGTM otherwise.
