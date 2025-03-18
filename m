Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D495120AF64
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742299066; cv=none; b=tlkGP2xDiP9ShIc8LRVVtsWrnuWryH2BZk5+wVMcVKK9fv/uZswpGExpvLfEXYx59QgwkCK1ZpJ6cQOk9xKgStctPLflH3cBCn+KmqLjUTRje+DKoPSNsJo4OJ0nDtbhzjPHeS3O/w3L7FzVQe7EEqd3XdrP++ewsJumbHE80ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742299066; c=relaxed/simple;
	bh=hzsMZJgVElwd66V0tqIBvkqxf09MTKKb00TNyfauj44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dw339ePybB9qkerlt+A9GXH2Q/EubfWPlWM5MhQT8VN+aX7nDMhYhRXFRf4tn1/M4I1SgU8L4A17FxLJNEys/wpmfwk53HdAxtvSv9CSx4CgnuykpgbTeD4sgKCfQ4hvN2eTdyBOLB9ODDrwoesCXe/bImG5MIjnDxCbrxb02WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H99TQqPc; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H99TQqPc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H99TQqPc";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H99TQqPc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B93C9605B9; Tue, 18 Mar 2025 12:57:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742299055;
	bh=7fB5hvmnsqjZMJ5haqNI9SQe9hc2R4GFD2ph/1A05o4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H99TQqPcEaqb3e/Qycuxf6gvq84vBVmcFm2x+bKX4PUdBILhcvurZueSPbBFBwIgc
	 AgDHNpW0mAokA86RFhx7bEelZq97EWman6fsewWfSGjpGxSoFV6A/yYRzo/m9T+cg3
	 zb5NMCAYWQTz6cnpfS3kF79P5G2C8jn0uNOQEn+ry/cDfqFM3VNGcDMOqJvND2zycW
	 vfOmNVYj+mRhdYrqWuNmzvEwjMT7YWOE/JTNZ8l5bX091uLMyos2PXb34zB90vqZgg
	 N6a9nywBiS+/kJCEISQnZW1XAj8zxbOxGCih3Nhj56G4cwUpxJBgBhDp/r9VSQbMEa
	 CPNjG82oLbYHQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE3F0605B4;
	Tue, 18 Mar 2025 12:57:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742299055;
	bh=7fB5hvmnsqjZMJ5haqNI9SQe9hc2R4GFD2ph/1A05o4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H99TQqPcEaqb3e/Qycuxf6gvq84vBVmcFm2x+bKX4PUdBILhcvurZueSPbBFBwIgc
	 AgDHNpW0mAokA86RFhx7bEelZq97EWman6fsewWfSGjpGxSoFV6A/yYRzo/m9T+cg3
	 zb5NMCAYWQTz6cnpfS3kF79P5G2C8jn0uNOQEn+ry/cDfqFM3VNGcDMOqJvND2zycW
	 vfOmNVYj+mRhdYrqWuNmzvEwjMT7YWOE/JTNZ8l5bX091uLMyos2PXb34zB90vqZgg
	 N6a9nywBiS+/kJCEISQnZW1XAj8zxbOxGCih3Nhj56G4cwUpxJBgBhDp/r9VSQbMEa
	 CPNjG82oLbYHQ==
Date: Tue, 18 Mar 2025 12:57:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: move interval flag compat check after set
 key evaluation
Message-ID: <Z9lfq6L2OQ-ByUzm@calendula>
References: <20250317115639.19393-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250317115639.19393-1-fw@strlen.de>

On Mon, Mar 17, 2025 at 12:56:36PM +0100, Florian Westphal wrote:
> Without this, included bogon asserts with:
> BUG: unhandled key type 13
> nft: src/intervals.c:73: setelem_expr_to_range: Assertion `0' failed.
> 
> ... because we no longer evaluate set->key/data.
> 
> Move the check to the tail of the function, right before assiging
> set->existing_set, so that set->key has been evaluated.
> 
> Fixes: ceab53cee499 ("evaluate: don't allow merging interval set/map with non-interval one")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  src/evaluate.c                                      |  6 +++---
>  .../invalid_data_expr_type_range_value_2_assert     | 13 +++++++++++++
>  2 files changed, 16 insertions(+), 3 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d59993dcdd4e..f1f7ddaab991 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5088,9 +5088,6 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  				if (existing_flags == new_flags)
>  					set->flags |= NFT_SET_EVAL;
>  			}
> -
> -			if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
> -				return set_error(ctx, set, "existing %s lacks interval flag", type);
>  		} else {
>  			set_cache_add(set_get(set), table);
>  		}
> @@ -5181,6 +5178,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  		return 0;
>  	}
>  
> +	if (existing_set && set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
> +		return set_error(ctx, set, "existing %s lacks interval flag", type);
> +
>  	set->existing_set = existing_set;
>  
>  	return 0;
> diff --git a/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert
> new file mode 100644
> index 000000000000..56f541a61e45
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/invalid_data_expr_type_range_value_2_assert
> @@ -0,0 +1,13 @@
> +table inet t {
> +        map m2 {
> +                typeof udp length . @ih,32,32 : verdict
> +                elements = {
> +                             1-10 . 0xa : drop }
> +        }
> +
> +	map m2 {
> +                typeof udp length . @ih,32,32 : verdict
> +                flags interval
> +                elements = { 20-80 . 0x14 : accept }
> +        }
> +}
> -- 
> 2.48.1
> 
> 
