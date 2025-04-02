Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC58234989
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743583485; cv=none; b=DDxEgtPOS82Fy6ZNMedlMrQ/un4UORM/u3TguVXPQsYyVJQyO/TAslSinKRtbPz+e4sMbnsZ41K4UIMGbTQZu+JQQmLkWmFuto6fH5PSQB9vozo4CURg7tmkQVRo8ugNhtRLU+mYpfWWGg143AP4G3OJSqMOrFhIGN7ofCZvwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743583485; c=relaxed/simple;
	bh=ZRAxATqCuYdG0AGRfAOn2y1iSb9dXYZZht7ntxYgj7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iB6q4WMarq82MjVphURmm4nAB3O8iEDm0JT2tl9qEuW+iCCo0gMK1K08gbdjEKniaYR+ATd1EVMTL/CaJnVhHYdLGXeJBcWy941bgSTwOM7HkAjTXkCLAHpttAVWIRoVH7v3uWG5jcuAYZY3bqKVt4KzHE3w+klcR8UOjVpvKX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XYHBCajf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XYHBCajf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XYHBCajf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XYHBCajf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E689B60578; Wed,  2 Apr 2025 10:44:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743583479;
	bh=DlHyEk3KXxr7rKoAazQkU/qiFlBMMIC9FC3Oz9qxug4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYHBCajfxeImexZP7GpR0qktrxsCeqAVQOxlv/xScAVd+GipYWwE7Fc3BmepNQcFI
	 mrd4+Kpm/9HB0v9ziYUb2Srigq4ERevQwui6NNip7HkSEMJy4smzvRzhccB24UHIBD
	 TIPqDU6FxQj1nQREDqVcSTW6Mrdpk2f++tnPEUwtRsEA1SjXw+UOg4FQrWpYkYQDlG
	 8zy98+GjEvuGIut/Levj6Xh16j7r+30RgGrhAfSX/qpdifxjMARkpkLk8gbXc2QwIE
	 0N5NaaU6fB2SsPCQcsBeaZuW34KG+wylDoOG6vbnxwnvKcTsgK121OL8SQqmbl49Ee
	 lqVataT8YhyVw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 17CE76054C;
	Wed,  2 Apr 2025 10:44:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743583479;
	bh=DlHyEk3KXxr7rKoAazQkU/qiFlBMMIC9FC3Oz9qxug4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYHBCajfxeImexZP7GpR0qktrxsCeqAVQOxlv/xScAVd+GipYWwE7Fc3BmepNQcFI
	 mrd4+Kpm/9HB0v9ziYUb2Srigq4ERevQwui6NNip7HkSEMJy4smzvRzhccB24UHIBD
	 TIPqDU6FxQj1nQREDqVcSTW6Mrdpk2f++tnPEUwtRsEA1SjXw+UOg4FQrWpYkYQDlG
	 8zy98+GjEvuGIut/Levj6Xh16j7r+30RgGrhAfSX/qpdifxjMARkpkLk8gbXc2QwIE
	 0N5NaaU6fB2SsPCQcsBeaZuW34KG+wylDoOG6vbnxwnvKcTsgK121OL8SQqmbl49Ee
	 lqVataT8YhyVw==
Date: Wed, 2 Apr 2025 10:44:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_json: only allow concatenations with 2 or
 more expressions
Message-ID: <Z-z49Pv9YzdP8zsK@calendula>
References: <20250402051820.9653-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250402051820.9653-1-fw@strlen.de>

On Wed, Apr 02, 2025 at 07:18:18AM +0200, Florian Westphal wrote:
> The bison grammar enforces this implicitly by grammar rules, e.g.
> "mark . ip saddr" or similar, i.e., ALL concatenation expressions
> consist of at least two elements.
> 
> But this doesn't apply to the json frontend which just uses an
> array: it can be empty or only contain one element.
> 
> The included reproducer makes the eval stage set the "concatenation" flag
> on the interval set.  This prevents the needed conversion code to turn the
> element values into ranges from getting run.
> 
> The reproducer asserts with:
> nft: src/intervals.c:786: setelem_to_interval: Assertion `key->etype == EXPR_RANGE_VALUE' failed.
> 
> Convert the assertion to BUG() so we can see what element type got passed
> to the set interval code in case we have further issues in this area.
> 
> Reject 0-or-1-element concatenations from the json parser.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  src/intervals.c                               |  4 ++-
>  src/parser_json.c                             | 20 ++++++++------
>  .../set_with_single_value_concat_assert       | 26 +++++++++++++++++++
>  3 files changed, 41 insertions(+), 9 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert
> 
> diff --git a/src/intervals.c b/src/intervals.c
> index 71ad210bf759..1ab443bcde87 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -783,7 +783,9 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
>  			next_key = NULL;
>  	}
>  
> -	assert(key->etype == EXPR_RANGE_VALUE);
> +	if (key->etype != EXPR_RANGE_VALUE)
> +		BUG("key must be RANGE_VALUE, not %s\n", expr_name(key));
> +
>  	assert(!next_key || next_key->etype == EXPR_RANGE_VALUE);
>  
>  	/* skip end element for adjacents intervals in anonymous sets. */
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 94d09212314f..724cba881623 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -1251,6 +1251,16 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
>  	return binop_expr_alloc(int_loc, thisop, left, right);
>  }
>  
> +static struct expr *json_check_concat_expr(struct json_ctx *ctx, struct expr *e)
> +{
> +	if (e->size >= 2)
> +		return e;
> +
> +	json_error(ctx, "Concatenation with %d elements is illegal", e->size);
> +	expr_free(e);
> +	return NULL;
> +}
> +
>  static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
>  					   const char *type, json_t *root)
>  {
> @@ -1284,7 +1294,7 @@ static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
>  		}
>  		compound_expr_add(expr, tmp);
>  	}
> -	return expr;
> +	return expr ? json_check_concat_expr(ctx, expr) : NULL;
>  }
>  
>  static struct expr *json_parse_prefix_expr(struct json_ctx *ctx,
> @@ -1748,13 +1758,7 @@ static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
>  			compound_expr_add(expr, i);
>  		}
>  
> -		if (list_empty(&expr->expressions)) {
> -			json_error(ctx, "Empty concatenation");
> -			expr_free(expr);
> -			return NULL;
> -		}
> -
> -		return expr;
> +		return json_check_concat_expr(ctx, expr);
>  	} else if (json_is_object(root)) {
>  		const char *key;
>  		json_t *val;
> diff --git a/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert b/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert
> new file mode 100644
> index 000000000000..c99a26683470
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert
> @@ -0,0 +1,26 @@
> +{
> +  "nftables": [
> +    {
> +  "metainfo": {
> +   "version": "nftables", "json_schema_version": 1
> +      }
> +    },
> +    {
> +      "table": {
> +	"family": "ip",
> +	"name": "t",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "set": {
> +        "family": "ip",
> +        "name": "s",
> +        "table": "t",
> +	"type": [ "ifname" ],
> +        "flags": [ "interval" ],
> +        "elem": [ [] ]
> +      }
> +    }
> +  ]
> +}
> -- 
> 2.49.0
> 
> 
