Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAE6214A8B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 20:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537886; cv=none; b=E4P6zuIY111vDr4sqg67gs4dc34NsROSmJLjc7CKK5c71gCN2bAZskUmsNYWFxwHqoXF6xpbecdUlE8aqtsA0XGvyjoaCXD21xdKDnRI2S3nN5gW0kGtJVwtiCTRYf300/1PXoxPfSVpXU5MvDDeEYllMYrAn8RSsh4lqFOlbJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537886; c=relaxed/simple;
	bh=xIxo0mwDim3LLBHqzOAzvnkbTNhwez/O7YlU4SEA6Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgwVuKO6pGZ2iB26eD5c7nmi4gAfVwGIh+radQO/0jP33IbrPxyFzYO1/GuSMZmBQLkMiaIuiYdIzCkPEtSm3mpsOGY2yXnHyKrmtxojCGp80BOs+ZXgbSf9WQJZFH+BICceF0imWW0Ho8GuabDGqnbI1HYGKQsfZeZqwLOzDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q86v0dV1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p60eA4p/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q86v0dV1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p60eA4p/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 27A71605BD; Tue,  1 Apr 2025 22:04:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743537882;
	bh=7dFiUvg4vNPSVbAvFWpiL7JLzmSR8HyCHpvXjpJPNfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q86v0dV1TebC6d323+FPPQEX9EKTKoBi871eOYk/42XxlVSOS6kAOtOmgVTgqDK77
	 FtlUOFBzUt8UntzPUS+ddTYEFpv/nOMTtwk3Lp83enB7xHy+bc2kJtw9ow3FtjAEUl
	 tnl3nHcCd3VjOf1Fb0lBMajN/XelW8er3bHz3geOEO/1qDZfC44mhriFBCaH+Xyqrx
	 uy6GTvbt0STg3u8Cs8KyiWCUYv9h/Be1C5mLJdNx69cMtc8BC4AuKeMZp5cczgs9zv
	 gkY6cxIIqWy7KVt//tJMUdYrllrHWr3lu0Z1msAoO2MYY0pbBEPJ0b8DHF0OiqXEx2
	 +LhazYBajH/0A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 71D0E605B3;
	Tue,  1 Apr 2025 22:04:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743537881;
	bh=7dFiUvg4vNPSVbAvFWpiL7JLzmSR8HyCHpvXjpJPNfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p60eA4p/9MHP8OUm2sIWqdKaQYMACA/TlYLWxKqYML1xel9DOwvvwWkdwiSv6N2gF
	 NdfxbAjOt+eDSm7uPGSu5RNGSxoaI7QQ9VBEExw0xpYhYnkIBHPnIQO+6eQBcNM3Xn
	 4GVgRkNUvKJmYivBhxkeeg8Jaripw6nlheTxd6loaOrpf4IKZVkGFTLZGbdVh/51hr
	 3Us6Czj1JfTku3RZGJEMMy/ye6h69S5xq0aFEU8fyhF69LtQv7p6ULgXgc41nT3Awj
	 OBTuusYpUKg+JLDhGbaVTSyzpVIM2ByUl/SK8QEHG/3PR+VkIGTUZTwSvQv5sWNhc8
	 UTb8GYaMHn3SQ==
Date: Tue, 1 Apr 2025 22:04:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: fix crash when generating reject
 statement error
Message-ID: <Z-xG13jqxy6SOuQE@calendula>
References: <20250331124341.12151-1-fw@strlen.de>
 <20250331124341.12151-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250331124341.12151-2-fw@strlen.de>

On Mon, Mar 31, 2025 at 02:43:34PM +0200, Florian Westphal wrote:
> After patch, this gets rejected with:
> internal:0:0-0: Error: conflicting protocols specified: ip vs ip6
> 
> Without patch, we crash with a NULL dereference: we cannot use
> reject.expr->location unconditionally.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!

> ---
>  src/evaluate.c                                | 16 ++++++++--
>  .../reject_stmt_with_no_expression_crash      | 32 +++++++++++++++++++
>  2 files changed, 46 insertions(+), 2 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 507b1c86cafc..e4a7b5ceaafa 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3791,6 +3791,18 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt)
>  	return 0;
>  }
>  
> +static int stmt_reject_error(struct eval_ctx *ctx,
> +			     const struct stmt *stmt,
> +			     const char *msg)
> +{
> +	struct expr *e = stmt->reject.expr;
> +
> +	if (e)
> +		return stmt_binary_error(ctx, e, stmt, "%s", msg);
> +
> +	return stmt_error(ctx, stmt, "%s", msg);
> +}
> +
>  static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	struct proto_ctx *pctx = eval_proto_ctx(ctx);
> @@ -3806,12 +3818,12 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt)
>  				return -1;
>  			break;
>  		case NFT_REJECT_ICMPX_UNREACH:
> -			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
> +			return stmt_reject_error(ctx, stmt,
>  				   "abstracted ICMP unreachable not supported");
>  		case NFT_REJECT_ICMP_UNREACH:
>  			if (stmt->reject.family == pctx->family)
>  				break;
> -			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
> +			return stmt_reject_error(ctx, stmt,
>  				  "conflicting protocols specified: ip vs ip6");
>  		}
>  		break;
> diff --git a/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash b/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash
> new file mode 100644
> index 000000000000..04c01aa77a29
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-j-f/reject_stmt_with_no_expression_crash
> @@ -0,0 +1,32 @@
> +{
> +  "nftables": [
> +    {
> +      "table": { "family": "ip", "name": "x",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "chain": {
> +        "family": "ip",
> +        "table": "x",
> +        "name": "c",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "rule": {
> +        "family": "ip",
> +        "table": "x",
> +        "chain": "c",
> +             "expr": [
> +          {
> +            "reject": {
> +              "type": "icmpv6",
> +              "exprlimit": "port-unreachable"
> +            }
> +          }
> +        ]
> +      }
> +    }
> +  ]
> +}
> -- 
> 2.49.0
> 
> 
