Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC32144BC
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743444130; cv=none; b=apDd99d/sGbD7hR0huVUtiNAkGUSMCya6rZimMDCEM+E0JlktdDd22MzNtUme3iiopbPllsrduSaN/6gfboJY7Z4SnL/yXoEfBHNCIeFh2YfF9JUqszzxCCGwbGMHzdozk9IJzUF0GFbH73DNv6Ndip7lA5FdISCCrS0cPJ7zoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743444130; c=relaxed/simple;
	bh=eNbGSeevLqDJnvzUTxuooDK4j+4toLTDztsyZfB5SSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7n/Vdu/Zb9lWX1cNalw2IlEkI8FPzY2AZ7HirIyshV7VcLDRdlU4v5DH3M1j4ap/KudukYd8JLF7DS//Z5CeJz2aiLvNoWiv6u4RehLNuNUDgsH0ztGBXOrM8FshUPwZ5KZUexzR4kW8uL7GCgBInshBfzPV7Oe94BsISFUsmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bnwCuGPY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tPZuF5aa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bnwCuGPY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tPZuF5aa"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0235F6039E; Mon, 31 Mar 2025 20:02:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743444126;
	bh=T5kT5HyFTbyyOwMVOHNhjQj8gaNyAeFXMrkWHNsOgpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bnwCuGPY406gWz8w9XtP6fjMKZNnrZqnzWapRtGT9hz0mNAXITZ02GbXGedrtllI6
	 Ab+8dqcYZtqFDNzgy2xoTtUGYfAJdA25qK7dExzGWCbszWkMTg7llDBhPrTq3MWyDD
	 JalqOYC2vHh0t18KH2GJs9TpaDqldRang9HcebPBotHV5qxST/xmf4rCGz8PjiNMuX
	 +iTX3lypjVP4p55b19RcRJPkAep86dNVLn81UVWNiuG9pTau9/o9VyKsyGaPC7KfHg
	 HmpUCew/MNmDMBw9BBalzAdQlAR/+XxL+sK/tf12pIyD+wYLPRsZV02K6YEWg/7HGp
	 zxKoOE2yVL6aw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 44C5C6039E;
	Mon, 31 Mar 2025 20:02:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743444125;
	bh=T5kT5HyFTbyyOwMVOHNhjQj8gaNyAeFXMrkWHNsOgpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tPZuF5aamm2gp55XP1QB/TXh57mtePMQ3bzdjiAgPad4Xwy2Nhf4ofInIcF4JpULA
	 bOLYcPBnMXRceosEwjJHk+5KZOOB4Rb+uueFiM2tqwA4bF3BhafEinquPiIDzRdiWw
	 FrPyKArH/o7SmMvEYwLxIvTXgcN5V0pUa8lvKevaTOajJq66R2qC7fKzwoXryzpzRy
	 d3io0f+juXSqfcLv2x2oKJWHP02LcMvYG2Ii3OfTfOqabCSKyMppbgvnqLUlIdBF4i
	 B2P/1JlxR3gazM80xb12TgXROWe8amvA8h7s9K7LtOHMfOUOFvE83NpBdWuWnlGXrt
	 TGV6tUumqESdA==
Date: Mon, 31 Mar 2025 20:02:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: compact STMT_F_STATEFUL checks
Message-ID: <Z-rYmg3U7CgQu3_f@calendula>
References: <20250331152323.31093-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250331152323.31093-1-fw@strlen.de>

On Mon, Mar 31, 2025 at 05:23:19PM +0200, Florian Westphal wrote:
> We'll gain another F_STATEFUL check in a followup patch,
> so lets condense the pattern into a helper to reduce copypaste.

This series LGTM, thanks Florian.

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/evaluate.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index e4a7b5ceaafa..e9ab829b6bbb 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3453,6 +3453,17 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>  	return expr_evaluate(ctx, &stmt->payload.val);
>  }
>  
> +static int stmt_evaluate_stateful(struct eval_ctx *ctx, struct stmt *stmt, const char *name)
> +{
> +	if (stmt_evaluate(ctx, stmt) < 0)
> +		return -1;
> +
> +	if (!(stmt->flags & STMT_F_STATEFUL))
> +		return stmt_error(ctx, stmt, "%s statement must be stateful", name);
> +
> +	return 0;
> +}
> +
>  static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	struct expr *key, *setref;
> @@ -3526,11 +3537,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
>  
>  	stmt->meter.set = setref;
>  
> -	if (stmt_evaluate(ctx, stmt->meter.stmt) < 0)
> +	if (stmt_evaluate_stateful(ctx, stmt->meter.stmt, "meter") < 0)
>  		return -1;
> -	if (!(stmt->meter.stmt->flags & STMT_F_STATEFUL))
> -		return stmt_binary_error(ctx, stmt->meter.stmt, stmt,
> -					 "meter statement must be stateful");
>  
>  	return 0;
>  }
> @@ -4662,11 +4670,8 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
>  		return expr_error(ctx->msgs, stmt->set.key,
>  				  "Key expression comments are not supported");
>  	list_for_each_entry(this, &stmt->set.stmt_list, list) {
> -		if (stmt_evaluate(ctx, this) < 0)
> +		if (stmt_evaluate_stateful(ctx, this, "set") < 0)
>  			return -1;
> -		if (!(this->flags & STMT_F_STATEFUL))
> -			return stmt_error(ctx, this,
> -					  "statement must be stateful");
>  	}
>  
>  	this_set = stmt->set.set->set;
> @@ -4726,11 +4731,8 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
>  				  "Data expression timeouts are not supported");
>  
>  	list_for_each_entry(this, &stmt->map.stmt_list, list) {
> -		if (stmt_evaluate(ctx, this) < 0)
> +		if (stmt_evaluate_stateful(ctx, this, "map") < 0)
>  			return -1;
> -		if (!(this->flags & STMT_F_STATEFUL))
> -			return stmt_error(ctx, this,
> -					  "statement must be stateful");
>  	}
>  
>  	return 0;
> -- 
> 2.49.0
> 
> 
