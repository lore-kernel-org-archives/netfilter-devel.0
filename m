Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE54F2260C
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 23:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753745785; cv=none; b=R9Uuf1SyZ83gkvMemdEj289AAeJaIEYvfdA4TFHPD1ywGyb10YbwxZlJ0ll3pCLpgA4ZGCIG70rZM2nRt52Y0emAGTWgT/QNAkerlUZt2YaSumr9CFUdbI6hlOGuq7OmvanlF7hVxjssAOYMaWj1gLAUp3q2ijS49cf8NOt3duE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753745785; c=relaxed/simple;
	bh=oOo1Lm+D2hmbVuGHAHZ2SDeyUOaAADVcdcUDgYsBK2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWMnijaw7O7moIcWtlrpadU+Y+r+aQ7P6WWOq58zfChYlJv3DdWfGUGChAYg2jo7l9eFWW/WW8I+FFaYEL2aiQOrlu8ioTn7hiSTzXDf/LpVLqdPWQSooNGFJvSKoZAdjQ7+3LZ5HGF74M05EJy55HvOOODdoMy5Yf40b6zDA+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lt3/U8S4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lt3/U8S4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lt3/U8S4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lt3/U8S4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D08FD602E2; Tue, 29 Jul 2025 01:36:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753745773;
	bh=lzpktPnJ+d5glNyO1IDLYxQvvRnrnVCp1wkAXLI4w7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lt3/U8S4mbjSptd1rHbnPzK/B/fDFrukcHUba8h4U3Jb0PsPzNxoLf/sLs2T+50lF
	 JyM7ntAvdIR68i4+wxlJ4QKJ9Hr+IYut5og3uD82C+uIcpRzy1CX6VUifOTagQ5SQ1
	 qsSUtFRTgzGB9yQWLRX8R/rN+c86sxX5Ol9NVQ1tIXyG0/Ofp+3nyMB5+1pfeauGcn
	 PcI3NEOjAoabVJkxxlooDrnlNK4yzLUqYZ2vZZ6yVMdmQXeEONyfQONAtlYxfnzw/c
	 3M0u4Z2/gTsXs1urS4SB+lbrXQMm6F/ANdS0RO4ZJTW9I3enbLcCGFy3rT2JOZm1Ja
	 cMdfEV8ufCwTw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0055C602E2;
	Tue, 29 Jul 2025 01:36:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753745773;
	bh=lzpktPnJ+d5glNyO1IDLYxQvvRnrnVCp1wkAXLI4w7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lt3/U8S4mbjSptd1rHbnPzK/B/fDFrukcHUba8h4U3Jb0PsPzNxoLf/sLs2T+50lF
	 JyM7ntAvdIR68i4+wxlJ4QKJ9Hr+IYut5og3uD82C+uIcpRzy1CX6VUifOTagQ5SQ1
	 qsSUtFRTgzGB9yQWLRX8R/rN+c86sxX5Ol9NVQ1tIXyG0/Ofp+3nyMB5+1pfeauGcn
	 PcI3NEOjAoabVJkxxlooDrnlNK4yzLUqYZ2vZZ6yVMdmQXeEONyfQONAtlYxfnzw/c
	 3M0u4Z2/gTsXs1urS4SB+lbrXQMm6F/ANdS0RO4ZJTW9I3enbLcCGFy3rT2JOZm1Ja
	 cMdfEV8ufCwTw==
Date: Tue, 29 Jul 2025 01:36:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Fix for 'meta hour' ranges spanning date
 boundaries
Message-ID: <aIgJUFPS2z6F_sCn@calendula>
References: <20250725212640.26537-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725212640.26537-1-phil@nwl.cc>

On Fri, Jul 25, 2025 at 11:26:40PM +0200, Phil Sutter wrote:
> Introduction of EXPR_RANGE_SYMBOL type inadvertently disabled sanitizing
> of meta hour ranges where the lower boundary has a higher value than the
> upper boundary. This may happen outside of user control due to the fact
> that given ranges are converted to UTC which is the kernel's native
> timezone.
> 
> Restore the conditional match and op inversion by matching on the new
> RHS expression type and also expand it so values are comparable. Since
> this replaces the whole range expression, make it replace the
> relational's RHS entirely.

Thanks, I suspect this bug is related to this recent ticket:

https://bugzilla.netfilter.org/show_bug.cgi?id=1805

> While at it extend testsuites to cover these corner-cases.

Thanks for improving coverage for this.

> Fixes: 347039f64509e ("src: add symbol range expression to further compact intervals")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> @@ -2772,12 +2780,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
>  
>  	pctx = eval_proto_ctx(ctx);
>  
> -	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
> -		ret = __expr_evaluate_range(ctx, &rel->right);
> +	if (lhs_is_meta_hour(rel->left) &&
> +	    rel->right->etype == EXPR_RANGE_SYMBOL) {

Side note, thanks for reversing this check.
