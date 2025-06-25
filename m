Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A124204E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886625; cv=none; b=guytkujIoJKR1RSeOhzCjpIfpJub3vQ+p/3ZUHB2Kcj+J968oxpP2iUgxPEPy+mtB6Eqbyx+Np/AaG3RH9cz6hjDW25JmlVnbitS1L61UQ9Wmw4rmd6LmocCj5eXagXwXgKn4HNIc/ALTUZJPbC0VrmAK4j5FLL8QTX8wKuFr98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886625; c=relaxed/simple;
	bh=d2boU+sIwusp16DNGtXpJ+dsTkBPPGiwi5ZXXKHRsJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiWNXW2B3/NtzGTvnPySZI9gukm68mFgTt2XVoayo61k4gj2E/i7aLodOyXv0q1fdgDqIyrAwTw54LqMCKrl8YvNuKQJYzxg0tiIoGQtRMXcfuy/dzN6zgJtXv2U9GIdait151LKnQ0QVr3j7G/MSX9xAgrB4MHJcPfLvvM6uLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DCqJsRM2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RgJVgF4l; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DCqJsRM2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RgJVgF4l"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3C3986027C; Wed, 25 Jun 2025 23:23:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886622;
	bh=KfIEkyEV7TJfWm69qXUaFOVjLJF++K0TzrLYWo2UsNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DCqJsRM29MJ7PVxON4JZTH53SV9CoLyyjg4myZrzOM923+o3Bntd9l3xhBVwtTj6B
	 IsfYeh3Qgf3KHL/xyaCAtr1C1aH1lsNgEWqrCiX9q+Et1sUDyb/riilv+B9TK3zWdE
	 8Hb6uefxEKXf7iF1HkNj3kur1/N0foQZ0cOpikpByXs0sUhFXI3noOMo9u+POK6v1/
	 s/p5l2HbsTR8Nxikvh7AIOraKKx3gt2vYxPVNB97a8g3ohwIe9ry2cLTM/kiephaYw
	 y95KxiE23thF7SdupKC8v6iNAT9WwQkfLKe9iRqtKKYojTTaFMbvZYsiPYRwfcefVm
	 c+7kB8qzSIPaQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 81A056027C;
	Wed, 25 Jun 2025 23:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886621;
	bh=KfIEkyEV7TJfWm69qXUaFOVjLJF++K0TzrLYWo2UsNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgJVgF4lMtD30hmag6LutRzzGbBiMRGf8UqpdmLwjhl1d+UhwODGR7JICVE0tXyzx
	 QRWLj2L+UBQF3yVlRbPI9EFXmJyOGwf2VkTrpSRS7dLVa6k9/5y87RvJht1rnG+Icm
	 brJkwdF4LsE2J7JjFwhkmTxT5BwzqWo9dSN9c3o2bi1UeZZHzvf0O19fPoKAgtSFoa
	 VO3y9sDU5m6uPb0Dr6pi9pb26fSA0BVW/sS3SPZupgjPvcBp7QJ2mjZ54GRyUbQxrD
	 oNAkSoB42hqhsU2id14SzxX961ge0nh7/Ja+M24AOcQhMdR6lZX+WmbWfw5ko5VW4y
	 wvMQCkRnPmyrg==
Date: Wed, 25 Jun 2025 23:23:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] evaluate: check that set type is identical before
 merging
Message-ID: <aFxo2-Y5DcZ4YfEg@calendula>
References: <20250623193734.8404-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250623193734.8404-1-fw@strlen.de>

On Mon, Jun 23, 2025 at 09:37:31PM +0200, Florian Westphal wrote:
> Reject maps and sets of the same name:
>  BUG: invalid range expression type catch-all set element
>  nft: src/expression.c:1704: range_expr_value_low: Assertion `0' failed.
> 
> After:
> Error: Cannot merge set with existing datamap of same name
>   set z {
>       ^
> 
> v2:
> Pablo points out that we shouldn't merge datamaps (plain value) and objref
> maps either, catch this too and add another test:
> 
> nft --check -f invalid_transcation_merge_map_and_objref_map
> invalid_transcation_merge_map_and_objref_map:9:13-13: Error: Cannot merge objmap with existing datamap of same name
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                | 34 +++++++++++++++++--
>  ...pression_type_catch-all_set_element_assert | 18 ++++++++++
>  ...valid_transcation_merge_map_and_objref_map | 13 +++++++
>  3 files changed, 63 insertions(+), 2 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_range_expression_type_catch-all_set_element_assert
>  create mode 100644 tests/shell/testcases/bogons/nft-f/invalid_transcation_merge_map_and_objref_map
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 783a373b6268..3c091748f786 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5149,6 +5149,29 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
>  	return 0;
>  }
>  
> +static const char *set_type_str(const struct set *set)
> +{
> +	if (set_is_datamap(set->flags))
> +		return "datamap";
> +
> +	if (set_is_objmap(set->flags))
> +		return "objmap";
> +
> +	return "set";
> +}

"datamap" and "objmap" are internal concepts, users only see "maps"
from their side.

So I would not expose this in the error message.

Maybe you could just say map declarations are different by now. Later more
accurate error reporting on what is precisely different can be added.

Apart from the error report nitpick I don't see anything wrong with
this patch.

> +static bool set_type_compatible(const struct set *set, const struct set *existing_set)
> +{
> +	if (set_is_datamap(set->flags))
> +		return set_is_datamap(existing_set->flags);
> +
> +	if (set_is_objmap(set->flags))
> +		return set_is_objmap(existing_set->flags);
> +
> +	assert(!set_is_map(set->flags));
> +	return !set_is_map(existing_set->flags);
> +}
> +
>  static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  {
>  	struct set *existing_set = NULL;
