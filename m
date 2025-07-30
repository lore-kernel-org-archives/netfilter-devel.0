Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D70255F4C
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896417; cv=none; b=PUuQ6ZYsRzmXbW0LSzisK6uMdEV1pJZ6jABoGyawhYzbnPXUDlk37uJyKsowwZ02sPAyRdJZxJx38WEFbXRqwXQIOyZCAtLwoFRa+Lutmhor3mXrH64Ylhh75qiswV9wlSvJUTwPfZT4MP/Q4phqPAjl2eZDKfHf9WdnClZUIsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896417; c=relaxed/simple;
	bh=9QptPPCdeFGrEQCMlqx47eGilZrnF8B4CnsvEdidmOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWK5rYxB1ifBbrd1P2YUM3YMAz9TIDXzoBsI3ZCNcReZuJau5qcbBv4gMVNqWFQ0tk6rTPTUMJmqZSqDEQg34FINOdh/kS31LYTl8U9vFvxMdCAe3mvgXJLPTuFBzRK0D3e2uIAW6uQu40VKMvD8u3wNgEOPLB/9/bcPnTKEhN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v+OVvxFp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wSDgt5uq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v+OVvxFp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wSDgt5uq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4071E6027E; Wed, 30 Jul 2025 19:26:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753896412;
	bh=/Rn9PA+BsOPimvN75kQzRuHSaytSSe/XnOkirbYcMa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v+OVvxFpRKAoZ0t7HSNjW9VRaSBmhe55X2LXFh5Mof0MP2MIQyFxC69bSD5Fw6Yxt
	 hGgTyz7G24HUl2dQqb+W3+M6jyH2DU1f85S0oYrwT94rpq+ot5iZXJa483f8/NGdTd
	 954Yit4I/oJ6gkbGO/kcOEobq5kd1bcAjm2PT8obNH/0/+tVoFKCqFnhAFSwjLDbLO
	 3L0GlJj3h0wdjU8gUVvaem8QJG7TG4zrdWtPotNgAaHDGQz79x4rH7rinzgecrCM+F
	 tj17oxjrfLR1OqTRobJ61hITrsP+5lCtc9UObT3ep+fLOuh+RKBEpeXMY33MyQ4RlF
	 ku/8etr0cqDzQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7449860251;
	Wed, 30 Jul 2025 19:26:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753896411;
	bh=/Rn9PA+BsOPimvN75kQzRuHSaytSSe/XnOkirbYcMa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wSDgt5uqlIXQRxZXYr3hc0Qmv+UlzvnEcts2cX46oux1SPFfk4wZ1kuv7IGKyxAUt
	 gwE2mJH0Xw1sIT3vXbFa0zsJcC2FAqH7vDJf/IG9J3QpBL63TgApgxP5YeadXPqEct
	 Mzq5AZJV8AsN4V1/cvgruLE+P7sYWpS5g0WCj8Yd5hPq57yWwPDPqZ0IgSJAtrludv
	 A/jhU49fg1RCMKDwHWlVs4JR0bQ9X4ZL+84XUoVj5TJKzQJZg9lZxMgekK21v+EZsk
	 nBD8A0guQANnnkAJrWftwHLd5mJBoVHa+AVSZ6rY7lfjWSDT+hvZUtDdIejtxwr5LO
	 tFsEVCYcvASvQ==
Date: Wed, 30 Jul 2025 19:26:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 3/3] evaluate: Fix for 'meta hour' ranges spanning
 date boundaries
Message-ID: <aIpVIcrZCy30I_sF@calendula>
References: <20250729161832.6450-1-phil@nwl.cc>
 <20250729161832.6450-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250729161832.6450-4-phil@nwl.cc>

Hi Phil,

On Tue, Jul 29, 2025 at 06:18:32PM +0200, Phil Sutter wrote:
> @@ -2772,12 +2780,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
>  
>  	pctx = eval_proto_ctx(ctx);
>  
> -	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
> -		ret = __expr_evaluate_range(ctx, &rel->right);
> +	if (lhs_is_meta_hour(rel->left) &&
> +	    rel->right->etype == EXPR_RANGE_SYMBOL) {

I just realised that we cannot just replace one expression type by
another.

For relational, this needs to handle EXPR_RANGE too, because this
generates a range expression, for instance:

define end="14:00"

table ip x {
        chain y {
                meta hour "13:00"-$end
        }
}

this code is a bit special, it happens before the range evaluation.
For relational expressions, this is translated to EXPR_RANGE. Only
sets are using EXPR_RANGE_VALUE, relational expressions still use
EXPR_RANGE.

So this special case can see either EXPR_RANGE and EXPR_RANGE_SYMBOL.

> +		range = symbol_range_expand(rel->right);

Then, this conversion above only need to happen for EXPR_RANGE_SYMBOL.

> +		ret = __expr_evaluate_range(ctx, &range);
>  		if (ret)
>  			return ret;
>  
> -		range = rel->right;
> +		expr_free(rel->right);
> +		rel->right = range;
>  
>  		/*
>  		 * We may need to do this for proper cross-day ranges,

