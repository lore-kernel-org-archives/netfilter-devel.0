Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FD3126A9
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757341881; cv=none; b=IvwGihyyvlyyPeqPGN9vw16A17U5RTgxZgwfkxaiFiUDhH69e28XoKbiCqg67KcuWskrSJr+mTWFrEXFztVnB670oqELlIVZPphN7vB3onbGVg24yVALP/zpUkHP36R7GPJaf8cIni9m0lbo2axzZz/8CMhPRdRfJfUn3Xp7HtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757341881; c=relaxed/simple;
	bh=5b+Q0SGEShav4kQ1Iq97xNpngPFFOPbudERKCH8BM4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uvvke8xuKxjqGcL07PvCslY2O0eof/iOe7xpfVohUV4FxQPeCWtFy2yvULNzndToJx6EeAauZ0MzzOsv9dWe0yHpNzdAQWshLEISLfjSrmkzXlrKeFxvmHXnagI9ZSWWgx5nPal2gYRJiLLzSATDMf2S0ogIvMrKpHMfJyuhzU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 318BF601EB; Mon,  8 Sep 2025 16:31:10 +0200 (CEST)
Date: Mon, 8 Sep 2025 16:31:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Set expressions out of range in
 nft_add_set_elem()
Message-ID: <aL7orb8efT7px8NB@strlen.de>
References: <20250908140844.1197-1-chenyufeng@iie.ac.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908140844.1197-1-chenyufeng@iie.ac.cn>

Chen Yufeng <chenyufeng@iie.ac.cn> wrote:
> The number of `expr` expressions provided by userspace may exceed the 
> declared set expressions, potentially leading to errors or undefined behavior. 
> This patch addresses the issue by validating whether i exceeds 
> set->num_exprs.

Its already tested?
Please explain why this isn't enough and/or provide splat/backtrace.


                nla_for_each_nested(tmp, nla[NFTA_SET_ELEM_EXPRESSIONS], left) {
                        if (i == NFT_SET_EXPR_MAX ||
                            (set->num_exprs && set->num_exprs == i)) {
                                err = -E2BIG;
                                goto err_set_elem_expr;
                        }
                        if (nla_type(tmp) != NFTA_LIST_ELEM) {
                                err = -EINVAL;

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

I don't see how we can hit the if (set->num_exprs && conditional with
i == set->num_exprs.
