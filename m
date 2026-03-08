Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75592254B03
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 11:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772969148; cv=none; b=jikrgPvcqdn6IUAYWS4vFdMMOMTpxignQkwMTxmCsW9AT/ZfEqDQTke56+Yo64mpw9xeYdLQ6j1T9QdKh/wI2VgXs9ducfFeQ/fQbT9BsK7j4NLJWROp5seuvi5lOI98gYztyTtDX7ntNiPY77BpOA11HHlAShDQS09Y+QcR42g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772969148; c=relaxed/simple;
	bh=22JAIeRCoRCZtenzApm7dXx/eKe+pjbhsXIoBI5YKY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K27nAvh0jU0VC69SZkO7XPy4tH8JseaO77uv7G/Mp63IYnPKGw5PclcMDuhddTT0Z3VOCXgO1Ag6/Q6xJBQ3H+VSN5MPffAkBmFsZ5QaU5VM6M+tV2DYWuWAiNVfS6wSUeUNVKQ0eSRC0RsN/d3EkRaaSzrLsXiHyVrJENGZtBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XYEVcPSX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XYEVcPSX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B59F0603AD;
	Sun,  8 Mar 2026 12:25:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772969145;
	bh=xd5cFaMvNqTo/nJzwJKPCAOtMD5tGS89HURFKzdBR7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYEVcPSXbFWPyqUokF/T7JDSSL0vUUUDbcHDZeNJY+qsWffmr5tlNiyu206g+7DrQ
	 Hk1LiEn9XWY7L2552aZEQ2X0Q5AiW4Gl/4kh9qobc34VztWcrZu82T3oCJHwDkxkXW
	 QMfIq85EbuM8gewAEohmVtKmUJSK+QC5AR2X99PEnI6khUZXVX7RTVTJJeem9CaI0k
	 nlrEYyxgYaP9CXP5FTlS2Jy9WA5AOn3SEax9CCKtaCZPnC0C8Xbudn2Zq/IXY3V3UK
	 5ug8pUDEBS8cCk98tb1x5oVtJxCGdxx6U4Ow/C5a2P0PkSZ4ihq+9Jbzo4Nlqyg9WU
	 1AlBHDJ50pTJQ==
Date: Sun, 8 Mar 2026 12:25:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, moderador@gmail.com
Subject: Re: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array
 size on updates
Message-ID: <aa1ctjhqwsib1Lh6@chamomile>
References: <20260308112341.2945020-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260308112341.2945020-1-pablo@netfilter.org>

This is an incorrect resend, apologies.

On Sun, Mar 08, 2026 at 12:23:41PM +0100, Pablo Neira Ayuso wrote:
> The array resize function increments the size of the array in
> NFT_ARRAY_EXTRA_SIZE slots for each update, this is unnecesarily
> increasing the array size.
> 
> To determine the number of array slots:
> 
> - Use NFT_ARRAY_EXTRA_SIZE for new sets.
> - Use the current maximum number of intervals in the live array.
> 
> Reported-by: Chris Arges <carges@cloudflare.com>
> Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix crash with new sets, reported by Florian.
> 
>  net/netfilter/nft_set_rbtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 853ff30a208c..bdcea649467f 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -646,7 +646,12 @@ static int nft_array_may_resize(const struct nft_set *set)
>  	struct nft_array *array;
>  
>  	if (!priv->array_next) {
> -		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
> +		if (priv->array)
> +			new_max_intervals = priv->array->max_intervals;
> +		else
> +			new_max_intervals = NFT_ARRAY_EXTRA_SIZE;
> +
> +		array = nft_array_alloc(new_max_intervals);
>  		if (!array)
>  			return -ENOMEM;
>  
> -- 
> 2.47.3
> 
> 
