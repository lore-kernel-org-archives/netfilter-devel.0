Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CFF3515DA
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 19:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790537631; cv=none; b=PyD+WySOgIlPTsA+W6GEJHEHzG+Mz9TFTI9pWFJNkPo6ZbXwf3hbn5oRPTzJNt/l9dv0Y+buDTCwL8/lo+e/vSUiT0/f+6dqwdoevvpyoxcL2oIdfRZ7SHgZpbw8U6I9Hm5uBf4Gx+09E9gccxRSBz7q7VY345e750w9EOgTnj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790537631; c=relaxed/simple;
	bh=EjzSJunLLeoGstI6kOmwHhdiNtq/ia7dzmipbix7YrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5t/BeeelZ+KggdyhWzkSrxM8UDtqCPmafDPFGYnpV54qJr0kp+gl8sLBmqTkq3Y/y6Uo2Ys0W5UeLg6O/Xn3qH3hrsTT3Up69OB29cbEhjYhg+eOhc6r/ia+phB3sTXbW+sb+88xIkA5JPN7v7p8i6oQFbnfjUyg9CyXMMkJpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=czwRORem; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="czwRORem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790537620;
	bh=RzCtTKup7VycvW6S3qi1G1TlpXMk6LIz9HfgAlKJhhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=czwRORemVi9xa7RwVDFxDkQBbtEnTjmT6Vf78U6TngVcOiTLdN8Iukj6V0LxL8qpD
	 Q4AHbCPFdixPgUQatkBkoOz3WESL7AjiWDN3FrLecxnnHYf4zp0sMsqZwLJ+egWrZ+
	 cyJ53+/xvn1f3byTMjaONSPY70ZycyNvC5Z5TGgd4m/zKAI5QtQ33+GpHA2HiR+NPc
	 eM6hGngW+cDXdPjSvxJFda57hCd53dJEMd7qLd3st5bWhdWl02pcmd8SQE2K6c28Qm
	 qZYmRLg5KsYrCvc5zsnowDHW8ruiDnmpVeRuNWIiw+mGA8GIOH4Fto+800NiB4niWV
	 3bsPNdQJyiWqQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 14EC160288;
	Sun, 27 Sep 2026 21:33:40 +0200 (CEST)
Date: Sun, 27 Sep 2026 21:33:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Fix for warnings when compiling for 32bit arch
Message-ID: <arlvkVx3c6_TvrWU@chamomile>
References: <20260917173707.2080891-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917173707.2080891-1-phil@nwl.cc>

Hi Phil,

On Thu, Sep 17, 2026 at 07:37:07PM +0200, Phil Sutter wrote:
> This eliminates several, probably harmless warnings when e.g. compiling
> with '-m32' for x86_64:
> 
> - Printing code assumes NFT_MAX_EXPR_LEN_BITS is unsigned long, when on
>   32bit it is unsigned int - multiply by 1UL to force the implicit type
> 
> - Pointers are unsigned long, casting to uint64_t yields a warning on
>   32bit due to the different size
> 
> - Bison tokens of type 'val' are uint64_t, print their values using
>   PRIu64 macro
> 
> - On 32bit, UINT32_MAX is of type unsigned int - cast to off_t when
>   comparing against state->indesc->line_offset to avoid different
>   signedness warning
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expression.h    | 2 +-
>  src/netlink_linearize.c | 4 ++--
>  src/parser_bison.y      | 2 +-
>  src/scanner.l           | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index e6a05603552b5..b3ba4ad8d297e 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -11,7 +11,7 @@
>  #include <json.h>
>  #include <libnftnl/udata.h>
>  
> -#define NFT_MAX_EXPR_LEN_BYTES (NFT_REG32_COUNT * sizeof(uint32_t))
> +#define NFT_MAX_EXPR_LEN_BYTES (1UL * NFT_REG32_COUNT * sizeof(uint32_t))

I would suggest to stick to unsigned 32-bit for this.

Related, I checked that NFT_MAX_EXPR_LEN_BITS is used with uint32_t
vars after quickly browsing code here.

Then, this is used to allocate a small buffer.

  unsigned char data[NFT_MAX_EXPR_LEN_BYTES];

Thanks.

>  #define NFT_MAX_EXPR_LEN_BITS  (NFT_MAX_EXPR_LEN_BYTES * BITS_PER_BYTE)
>  #define NFT_MAX_EXPR_RECURSION 16
>  
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index dfa841c6a407f..8de507059fe59 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -31,7 +31,7 @@ struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
>  	struct nft_expr_loc *eloc;
>  	uint32_t hash;
>  
> -	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
> +	hash = (unsigned long)nle % NFT_EXPR_LOC_HSIZE;
>  	list_for_each_entry(eloc, &ctx->expr_loc_htable[hash], hlist) {
>  		if (eloc->nle == nle)
>  			return eloc;
> @@ -50,7 +50,7 @@ static void nft_expr_loc_add(const struct nftnl_expr *nle,
>  	eloc = xmalloc(sizeof(*eloc));
>  	eloc->nle = nle;
>  	eloc->loc = loc;
> -	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
> +	hash = (unsigned long)nle % NFT_EXPR_LOC_HSIZE;
>  	list_add_tail(&eloc->hlist, &ctx->expr_loc_htable[hash]);
>  }
>  
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 6e1c1cc205331..138dbfa3b70de 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -5887,7 +5887,7 @@ payload_expr		:	payload_raw_expr
>  payload_raw_len		:	NUM
>  			{
>  				if ($1 > NFT_MAX_EXPR_LEN_BITS) {
> -					erec_queue(error(&@1, "raw payload length %lu exceeds upper limit of %lu",
> +					erec_queue(error(&@1, "raw payload length %" PRIu64 " exceeds upper limit of %lu",
>  							 $1, NFT_MAX_EXPR_LEN_BITS),
>  						 state->msgs);
>  					YYERROR;
> diff --git a/src/scanner.l b/src/scanner.l
> index 61fcc4fa3bad3..37729ebc3cc55 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -91,7 +91,7 @@ static void update_offset(struct parser_state *state, struct location *loc,
>  	uint32_t line_offset;
>  
>  	state->indesc->token_offset	+= len;
> -	if (state->indesc->line_offset > UINT32_MAX)
> +	if (state->indesc->line_offset > (off_t)UINT32_MAX)
>  		line_offset = UINT32_MAX;
>  	else
>  		line_offset = state->indesc->line_offset;
> -- 
> 2.54.0
> 
