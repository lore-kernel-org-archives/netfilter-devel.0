Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E123314B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 08:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750924927; cv=none; b=ftTmSd7Gm1+Ar94B7gLQ9Klm/PaFw2Ri7ZbVhTNGpHcCk02WdNNnwRtfLtHIRCYLts8zXG85QZNerUnZweZ5odZslsMTdICofmPCohWbg14LTDhfuuwuaSlyYbaIrBEBhDLkzoZs9f8Y0nyAR1yeFVIQH/a0SuX+pXaJP1OTYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750924927; c=relaxed/simple;
	bh=dOgBC5E+YDoKF8jxvW13qbbJ9to7QKvf9yoafYoAy+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGkqkUKgZA7WnFKOyuDm7ktcpjP4PnSVuPxGkxLr44L0Z5RoAWuw78hWSus0uDc6NjxXcgODnBVdqkcmOGAXOQm06txkkz6rr0ckP1Drxwd23EIJPjAq2I38DfU6ZEqJVw4DxGCCzou41rnsk6LmDTk9DBtSM7boFmqY78S+D10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CYRcEHWv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XO8K6mfe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CYRcEHWv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XO8K6mfe"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2749B60263; Thu, 26 Jun 2025 10:02:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750924920;
	bh=fKVzI5ljM/u0/uuiUAJ+dU0WKT3vHEKyaZ6YPpQy674=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CYRcEHWvHAC0EOaZT6wCsy7SJOn8BTA1FeUNOWUYLQkgF1dtz984rnrMwtIP+KBgI
	 ycn3sNzBFGdCrDkEI6hPuPm8BiRMkclrUlMKAylZwJEopgxpd+5ZpVeOOl53zZco8H
	 TNma4Kti646BGFZj5nKT8j1NEjBz6F9cIuxxTZpmZGA4tal+jHxnQH/9Qi5EVran5U
	 E00CXbkTjZLDa2ADLCiIE9NR/XMhhWRY5g3vB4yNKIjVw94L2MMB9InqFGSb8ScEJ3
	 1A1GVobBL9SvQLSpz8IGs0OpkI61wLB5vTnfoQFVNbRZSx7kaC/o1WdpHDK4mEl8TC
	 /OgrT5c+eQ1Gw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4F98960263;
	Thu, 26 Jun 2025 10:01:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750924919;
	bh=fKVzI5ljM/u0/uuiUAJ+dU0WKT3vHEKyaZ6YPpQy674=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XO8K6mfe6/83e4I3lvSfdWPMyAeB6Ozp9qInOmfK7vsTz56W8tj+wF/g9++vyE2S5
	 4JRy8kEXAJbZSwDuARLRzDl1HuJRS9EQvb/8KlBZjW5fcD1Fpxgf31veB00yUDn/vF
	 2oImE9/35/d9TfB2dHpQs0joxu4MQAsEuOWMIZWyUI6LS1tIQ/co263PVKdXOjuZlo
	 roswlgGj90aUIRwghAIlyIHnojBoF7P36oVuCrQydyjUtUE5KPlqYxoNkoLOqIn0+C
	 uWBFIrKbT0bIyRSH3AmAMDNmm3CMeU8Y4CRYm9WtlConsTyboCo0+XoVQgc59ogyQ7
	 KUZwnlqxGMcyA==
Date: Thu, 26 Jun 2025 10:01:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: prevent merge of sets with incompatible
 keys
Message-ID: <aFz-dO866jo634yM@calendula>
References: <20250626005250.11833-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250626005250.11833-1-fw@strlen.de>

On Thu, Jun 26, 2025 at 02:52:48AM +0200, Florian Westphal wrote:
> Its not enough to check for interval flag, this would assert in interval
> code due to concat being passed to the interval code:
> BUG: unhandled key type 13
> 
> After fix:
> same_set_name_but_different_keys_assert:8:6-7: Error: set already exists with
> different datatype (concatenation of (IPv4 address, network interface index) vs
> network interface index)
>         set s4 {
>             ^^
> 
> This also improves error verbosity when mixing datamap and objref maps:
> 
> invalid_transcation_merge_map_and_objref_map:9:13-13:
> Error: map already exists with different datatype (IPv4 address vs string)
> 
> .. instead of 'Cannot merge map with incompatible existing map of same name'.
> The 'Cannot merge map with incompatible existing map of same name' check
> is kept in place to catch when ruleset contains a set and map with same name
> and same key definition.

LGTM, thanks.

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  Followup to previous
>  '[nft,v2] evaluate: check that set type is identical before merging',
>   it has the welcome side effect to improve error reporting as well.
> 
>  src/evaluate.c                                      | 12 ++++++++++++
>  src/intervals.c                                     |  2 +-
>  .../nft-f/same_set_name_but_different_keys_assert   | 13 +++++++++++++
>  3 files changed, 26 insertions(+), 1 deletion(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index fc9d82f73b68..a2d5d7c29514 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5304,6 +5304,18 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  		if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
>  			return set_error(ctx, set,
>  					 "existing %s lacks interval flag", type);
> +		if (set->data && existing_set->data &&
> +		    !datatype_equal(existing_set->data->dtype, set->data->dtype))
> +			return set_error(ctx, set,
> +					 "%s already exists with different datatype (%s vs %s)",
> +					 type, existing_set->data->dtype->desc,
> +					 set->data->dtype->desc);
> +		if (!datatype_equal(existing_set->key->dtype, set->key->dtype))
> +			return set_error(ctx, set,
> +					 "%s already exists with different datatype (%s vs %s)",
> +					 type, existing_set->key->dtype->desc,
> +					 set->key->dtype->desc);
> +		/* Catch attempt to merge set and map */
>  		if (!set_type_compatible(set, existing_set))
>  			return set_error(ctx, set, "Cannot merge %s with incompatible existing %s of same name",
>  					type,
> diff --git a/src/intervals.c b/src/intervals.c
> index bf125a0c59d3..e5bbb0384964 100644
> --- a/src/intervals.c
> +++ b/src/intervals.c
> @@ -70,7 +70,7 @@ static void setelem_expr_to_range(struct expr *expr)
>  		expr->key = key;
>  		break;
>  	default:
> -		BUG("unhandled key type %d\n", expr->key->etype);
> +		BUG("unhandled key type %s\n", expr_name(expr->key));
>  	}
>  }
>  
> diff --git a/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert b/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert
> new file mode 100644
> index 000000000000..8fcfdf5cba03
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert
> @@ -0,0 +1,13 @@
> +table ip t {
> +	set s4 {
> +		type ipv4_addr . iface_index
> +		flags interval
> +		elements = { 127.0.0.1 . "lo" }
> +	}
> +
> +	set s4 {
> +		type iface_index
> +		flags interval
> +		elements = { "lo" }
> +	}
> +}
> -- 
> 2.49.0
> 
> 
