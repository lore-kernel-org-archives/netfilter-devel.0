Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B74C76
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740447474; cv=none; b=Dy5axQqULXS7Ml/f8RiuK3A6bz/0akW0ShiCMeYWfsXE6mKeoPo9rePRTngFCsxPOa4bRrZ4IRHbkb0H5efiM9WpjriiiCkeewscJJcjVBCcdXua1mKCLIYr9EUMv+bBqK31ZE52NTEuI7lzkMt/ugFpIJZ6W9vbERqeKLQClMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740447474; c=relaxed/simple;
	bh=M82j1kDMZfmSmlA2N6rf79dYaR3aaotsHbNVjwProQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULjdYrSomSS6yol2VCo3hwJIGEF9RElfMfj2A62L6rzOtWMAm/CoZKaZgnhPc5QR23+bp98A/dRH0Z0LTjv2twqy20/X9C06ArJtIFhhNKHBF+qmV9MxhyiCLtASd1JBrxwAp4+A9QZvktCqVXEErqwj9cXKXJxftM5KYvI6cBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gdtuVXYj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HxSf1HdN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gdtuVXYj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HxSf1HdN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6680A60291; Tue, 25 Feb 2025 02:28:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740446915;
	bh=qnhPyH4Az5DioBUUqFFsXrEangfFS6bkRodZ0AAO6Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdtuVXYjLuOjBpwEk63M04mxFQI2GZQ+mj9Rr9+9nhYNHMv8B2t52zIFM0zfP8fKn
	 1jPkd+uFY/LalRlFAIrRIHpYCR2vJXv9C6QSqcCKg7Cw78KQEWj+YapOmORoGFkZGE
	 LzH4MT/lTybmxNVNEl4++OX1M1i2Pry3NBozdQH0ri5CqwQvJxb5/yBxkZWv0MwEWC
	 vWrpS1y6E99khlPpMUCqHW0elCnXcrBzahgIJS45EO9gZe0njQdB0wQyjfbQkuHd2b
	 ntQ1b3jDYe7KplzNMYBEt1e2SWTt7sxTBLbzSsvT02LYffggYvq3IiB2KPyDo72Y1L
	 iw4zECfS/7aVg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1F406028B;
	Tue, 25 Feb 2025 02:28:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740446914;
	bh=qnhPyH4Az5DioBUUqFFsXrEangfFS6bkRodZ0AAO6Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HxSf1HdN1xs85jlNqYDgyw3QUuMgXSrSsmxqF91mGZh+R/HsSfle3pn9RMJwcDnpW
	 OuOmnH/vvCW84AQZmVLAkjeidGrEjVXHVzVyO4J+np+JYI6vOWXhM8KpkDIXhfKpLH
	 RLNI/ZOKn3bacs+uH5oaH/xit3UEZKPooJjHXjwYh+7Kr/jH1oBDrtfFbuW0PqDVie
	 02EuRNexYJIC2y/XdSPnmT2tWmuiQlLjVNtD0BuPVZWbQ9zW7CsJUfhbdn97XdGO9i
	 85qCJ1L6wCEKzzeDi1MSqbXSoPePTk8Ump+br2ATCtZ08gdhTXy2RKdaVKhItpJdvu
	 bwTaWjWjP6jhg==
Date: Tue, 25 Feb 2025 02:28:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: get rid of unneeded statement
Message-ID: <Z70cwLsPxpKSKjvJ@calendula>
References: <20250224175214.19053-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250224175214.19053-1-fw@strlen.de>

On Mon, Feb 24, 2025 at 06:52:11PM +0100, Florian Westphal wrote:
> Was used for the legacy flow statement, but that was removed in
> 2ee93ca27ddc ("parser_bison: remove deprecated flow statement")
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/parser_bison.y | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index f55127839a9b..e494079d6373 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -811,8 +811,8 @@ int nft_lex(void *, void *, void *);
>  %type <val>			set_stmt_op
>  %type <stmt>			map_stmt
>  %destructor { stmt_free($$); }	map_stmt
> -%type <stmt>			meter_stmt meter_stmt_alloc
> -%destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
> +%type <stmt>			meter_stmt
> +%destructor { stmt_free($$); }	meter_stmt
>  
>  %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
>  %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
> @@ -4192,10 +4192,7 @@ map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_
>  			}
>  			;
>  
> -meter_stmt		:	meter_stmt_alloc		{ $$ = $1; }
> -			;
> -
> -meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
> +meter_stmt 		:	METER	identifier		'{' meter_key_expr stmt '}'
>  			{
>  				$$ = meter_stmt_alloc(&@$);
>  				$$->meter.name = $2;
> -- 
> 2.45.3
> 
> 
