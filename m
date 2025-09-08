Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BCA18872A
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757346891; cv=none; b=kOXU9rtAy5blhQRveD2iNOHEZmy73B8ZeScVmN2mfPWAKJwEEHujDy87M9D0PnT6UAHgjxxhS8XPNiXizUPtyzLD9+OtzzhaX3JaO890ly6GS0tckkfo4BQNSCi4ciUlxsUukwJkJF9vivPV1H2AVyRXtn7C5UNTkxlpJon+zAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757346891; c=relaxed/simple;
	bh=2IrvGZxzSUVkTlcWteMV/DZkyyNMjlIoarQKOcAtAmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VO4LfsoRHikNSOe7hpUobj82NP4AcD47dShtZ/yPk/h71KyGnv+fmlAuIZp9LjeLXkxZciKx3ylkJ9kdPdfviw5QaXO1RA6XbFtoRH/jqx+qdD6kbT3+F+g0sBZoFZ30coEWfD/TpGTu/QtPJaKjX/c2dUNtanyG5vyZdyt0XTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UfBX231g; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KQ9n+lJH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UfBX231g";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KQ9n+lJH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D48916063A; Mon,  8 Sep 2025 17:54:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757346885;
	bh=cXS81F+Ee4zxmyRH53RPTxkOT4L2zAT3C/J8AmQjq/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UfBX231g9EflVWLT970rQQOKyToe8pczWM43GuGw4LufsOXClatL5qSinbgo10UUp
	 PqreE8hH82O2DYsNOSB6Xd0WkPpDqdF6KS0OdRsgPntq+OMjNZUx7IHFc7q7Fh4M8P
	 o4FcCaXLuVXpjTC0I9nd4ZqIWqNBPJoHgReF0oK37gbYXLV9af3KAOxGXMTegmFhlM
	 kWwn5NkXsv0gRtUy/W11GPhnhJwMhIB2qPtdLNKJCm3pu/mAg7gqrPHlMkp461u2oO
	 rSy4q3kQ5fuwDMQ2YNlMpdePBLX57h90wYQeqzloHV6acQVGx8G4xZJ34Ys9D7UJ7o
	 CqXKm+lbwt9iA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9F5EF6063A;
	Mon,  8 Sep 2025 17:54:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757346884;
	bh=cXS81F+Ee4zxmyRH53RPTxkOT4L2zAT3C/J8AmQjq/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KQ9n+lJHOuHwPvecbIL1UIjvNCoL8rtjDIr3nQCw9UAhUKiTNPHLoH0k0Bm0stAY8
	 Ndqp/+80pFWMCJKuMYGHNA27GZfZRKeLQyFwiAriYP9i2f5aCBfaSgHz1lKdeuCLnP
	 p7l6vmQPjT5USUI2mI1ZE3UZ9m9EFuhegYOGIndOtvzLeeY9eL6ibAwg1N5oBHaV2+
	 W7V9m4zZDIMEIcRKZGpatsToDZW+a7ivKicA7Tfvlaiw+4ysUwjItuUmgd3moS/n9x
	 oqfkt2t291wTOXFHmoDy8wvOMjZxOasNGwbOwYPTTRRmgVv6Stg7y2V0+qLHJkTuq2
	 45uvhLcPb5u4Q==
Date: Mon, 8 Sep 2025 17:54:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Set expressions out of range in
 nft_add_set_elem()
Message-ID: <aL78QYUaW68Vz6KJ@calendula>
References: <20250908140844.1197-1-chenyufeng@iie.ac.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250908140844.1197-1-chenyufeng@iie.ac.cn>

On Mon, Sep 08, 2025 at 10:08:44PM +0800, Chen Yufeng wrote:
> The number of `expr` expressions provided by userspace may exceed the 
> declared set expressions, potentially leading to errors or undefined behavior. 
> This patch addresses the issue by validating whether i exceeds 
> set->num_exprs.

        } else if (nla[NFTA_SET_ELEM_EXPRESSIONS]) {
                struct nft_expr *expr;
                struct nlattr *tmp;
                int left;

                i = 0;
                nla_for_each_nested(tmp, nla[NFTA_SET_ELEM_EXPRESSIONS], left) {
                        if (i == NFT_SET_EXPR_MAX ||
                            (set->num_exprs && set->num_exprs == i)) {

There is this a upfront check to validate what you describe.

Are you reporting a different issue?

> This patch is inspired by commit 3701cd390fd7("netfilter: nf_tables: 
>  bail out on mismatching dynset and set expressions").
>
> Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
> ---
>  net/netfilter/nf_tables_api.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 58c5425d61c2..958a7c8b0b4c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7338,9 +7338,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  			expr_array[i] = expr;
>  			num_exprs++;
>  
> -			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
> -				err = -EOPNOTSUPP;
> -				goto err_set_elem_expr;
> +			if (set->num_exprs) {
> +				if (i >= set->num_exprs) {
> +					err = -EINVAL;
> +					goto err_set_elem_expr;
> +				}
> +				if (expr->ops != set->exprs[i]->ops) {
> +					err = -EOPNOTSUPP;
> +					goto err_set_elem_expr;
> +				}
>  			}
>  			i++;
>  		}
> -- 
> 2.34.1
> 
