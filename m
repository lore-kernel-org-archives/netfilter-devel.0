Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FA21D6DA9
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 20:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791145799; cv=none; b=DG/eHthrqYKIsAqeKChEwF4YNviBFRmF9lmUqLrC2uoS7wTTnogdFFfV4i/KTNVI9dDeBrlnt+0qo8hr+JtlGxqxeLjPG2MvwY6yUugO6PFVOAWGmZCfmmrXqsh6bY1jN0PTkvznobgbpnBnvc+yVOggtDQ5tZXNoGWvHisuraI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791145799; c=relaxed/simple;
	bh=yoeuuPTXBEc5K9I3AhSI4JDHqm1QKnJ4NWlbUPFzul8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEmPxCXtfvZ5HCcWjhUtxzt7KzV/18gojlseeDDE9qiY0hc4cuUmoIYEjhgyw16gOzr7IwaFVZrZW38OdNI7ljKm2QFgiNMH+RKzKEJZ3QCOT11lJFR5Bej2HoU2tj+nJqW670y6gyVyaQ/wshzxEU2sW8H7UJcYE0b+69njtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cIQBJCdd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cIQBJCdd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791145794;
	bh=DBrwC5Mnsw6cGJRmH3cGt9RiGTGq29oXCaLC++isySg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIQBJCddpvmZCu/RP3mzDcooFt28Qm+LLJSlEcLCP3OE9DQnwXMmDegRv8UoBCNAT
	 we71f/Xni01bEwNcg6FGFKe2eygwLKgMrcVJviJW8LFIPRjyVrWQBDED+dYM5Zfd2M
	 53vGi6ps9QJTXEupG4yA8AyJbfex2aFGtF0+L89ZViqp9enPL7z+mQRHO7j6UWizV9
	 HqBgv6fh6pYLXeTNW9xDSSj8jx+JRPqGjYNN+syqIhtNeMM8aX3hYnRybssBFbL6gX
	 zcKlyAhLWn9yHnqZJGEAhI7mY6s1bjR4liypBbT/Zz0g2qIgyZL+FcruFZ7eNdjgeM
	 NKLE2kEHz3k9A==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E970160074;
	Sun,  4 Oct 2026 22:29:53 +0200 (CEST)
Date: Sun, 4 Oct 2026 22:29:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] Fix for warnings when compiling for 32bit arch
Message-ID: <asK3PzqW4orq3BmH@chamomile>
References: <20261002144547.2293527-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002144547.2293527-1-phil@nwl.cc>

On Fri, Oct 02, 2026 at 04:45:38PM +0200, Phil Sutter wrote:
> This eliminates several, probably harmless warnings when e.g. compiling
> with '-m32' for x86_64:
> 
> - Printing code assumes NFT_MAX_EXPR_LEN_BITS is unsigned long, when on
>   32bit it is unsigned int - cast to uint32_t and print using '%d'.
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

Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Phil.

> ---
> Changes since v1:
> - Prefer 32bit type for NFT_MAX_EXPR_LEN_B{IT,YTE}S
> ---
>  include/expression.h    | 2 +-
>  src/evaluate.c          | 4 ++--
>  src/netlink_linearize.c | 4 ++--
>  src/parser_bison.y      | 2 +-
>  src/parser_json.c       | 4 ++--
>  src/scanner.l           | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index e6a05603552b5..844f16b8a04b0 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -11,7 +11,7 @@
>  #include <json.h>
>  #include <libnftnl/udata.h>
>  
> -#define NFT_MAX_EXPR_LEN_BYTES (NFT_REG32_COUNT * sizeof(uint32_t))
> +#define NFT_MAX_EXPR_LEN_BYTES ((uint32_t)(NFT_REG32_COUNT * sizeof(uint32_t)))
>  #define NFT_MAX_EXPR_LEN_BITS  (NFT_MAX_EXPR_LEN_BYTES * BITS_PER_BYTE)
>  #define NFT_MAX_EXPR_RECURSION 16
>  
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 4f5f2694e7ed4..01b4afbbb10d8 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1828,7 +1828,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  		ctx->inner_desc = NULL;
>  
>  		if (size > NFT_MAX_EXPR_LEN_BITS)
> -			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %lu",
> +			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
>  					  size, NFT_MAX_EXPR_LEN_BITS);
>  	}
>  
> @@ -5191,7 +5191,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  		size += netlink_padded_len(i->len);
>  
>  		if (size > NFT_MAX_EXPR_LEN_BITS)
> -			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %lu",
> +			return expr_error(ctx->msgs, i, "Concatenation of size %u exceeds maximum size of %u",
>  					  size, NFT_MAX_EXPR_LEN_BITS);
>  	}
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
> index 6e1c1cc205331..bf2a136796619 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -5887,7 +5887,7 @@ payload_expr		:	payload_raw_expr
>  payload_raw_len		:	NUM
>  			{
>  				if ($1 > NFT_MAX_EXPR_LEN_BITS) {
> -					erec_queue(error(&@1, "raw payload length %lu exceeds upper limit of %lu",
> +					erec_queue(error(&@1, "raw payload length %" PRIu64 " exceeds upper limit of %u",
>  							 $1, NFT_MAX_EXPR_LEN_BITS),
>  						 state->msgs);
>  					YYERROR;
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 0522b2cd80b96..14259ea39777b 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -673,7 +673,7 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
>  		}
>  
>  		if (len <= 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
> -			json_error(ctx, "Payload length must be between 0 and %lu, got %d",
> +			json_error(ctx, "Payload length must be between 0 and %u, got %d",
>  				   NFT_MAX_EXPR_LEN_BITS, len);
>  			return NULL;
>  		}
> @@ -750,7 +750,7 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
>  			return NULL;
>  
>  		if (len < 0 || len > (int)NFT_MAX_EXPR_LEN_BITS) {
> -			json_error(ctx, "option length must be between 0 and %lu, got %d",
> +			json_error(ctx, "option length must be between 0 and %u, got %d",
>  				   NFT_MAX_EXPR_LEN_BITS, len);
>  			return NULL;
>  		}
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
