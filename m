Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACE7202C34
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518027; cv=none; b=XvGNcD9Mp8Kj9BZ2i+HoThi0IEGOM0ssqkgBxAfKxWM+d4bWHeapRwwjbHLD4c7UeIxHSNIUIRCStE46ZeMHvUgfZlRZD+Zb1TJZBNrTNLRSPHnX5HjyTzLLRN/M7nj5M4MfCwWh2z39/qZSDHUbDI5nvcBqJ3/KblfIONRaWMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518027; c=relaxed/simple;
	bh=L1wxMrGxJIlwq8oeLfb1BougICYTfOoNfVdmIfwiqTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTcn1Ic2Po/LMMwBOmQcaNDzLYnZt9C4zVT3pjvTpXCienG4/GgBvD5CaIZjZTojrjIdGGoce4QiBIjHnXl6mud4qyH3kXEI4gkiWePXHwNVuIOTglWepiF0V37wuTLeKR+LvoSMti3X0Lkdp44mWY/kuTQc/a0n13p5aj9rjlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uq5tTCdN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uq5tTCdN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uq5tTCdN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uq5tTCdN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DD691603B6; Tue,  1 Apr 2025 16:33:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518022;
	bh=3O7+Q7jbVtS3ql3xlDKiKUIo2CzJAc/35DN57AfRlHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uq5tTCdNtchAAcTwIRDjHnoQ0J6YbZ7vb9ldijYDXan0q8jxwklOicGFGPpvoXgMb
	 A3IWlBqpjzGlF0AEdehXdcAygiKK1ka5uPWkxH+BRbdevuD8+mCz35nz4DSIhXvidO
	 ZMklS32AjeAHGiBrDEGrv+QVbVCH7sD7U1b8VS/1TiLV+G/+CqEEdHEYHQxL0xJ9t7
	 4TRW9lHB00cML92x+X8iv55WV9qrRWoXX4dtS/uUdPJBumXuxbnG3xSNGrJwQfQaoF
	 pGX8qm9V+HEEFa/tieEF/YUTjZ+uJCcWyjdPHYX+hW6rxH8qOWkAyUfWAK7qIOmaH0
	 GrzvogG4MI/aA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 432246039E;
	Tue,  1 Apr 2025 16:33:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518022;
	bh=3O7+Q7jbVtS3ql3xlDKiKUIo2CzJAc/35DN57AfRlHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uq5tTCdNtchAAcTwIRDjHnoQ0J6YbZ7vb9ldijYDXan0q8jxwklOicGFGPpvoXgMb
	 A3IWlBqpjzGlF0AEdehXdcAygiKK1ka5uPWkxH+BRbdevuD8+mCz35nz4DSIhXvidO
	 ZMklS32AjeAHGiBrDEGrv+QVbVCH7sD7U1b8VS/1TiLV+G/+CqEEdHEYHQxL0xJ9t7
	 4TRW9lHB00cML92x+X8iv55WV9qrRWoXX4dtS/uUdPJBumXuxbnG3xSNGrJwQfQaoF
	 pGX8qm9V+HEEFa/tieEF/YUTjZ+uJCcWyjdPHYX+hW6rxH8qOWkAyUfWAK7qIOmaH0
	 GrzvogG4MI/aA==
Date: Tue, 1 Apr 2025 16:33:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] cache: don't crash when filter is NULL
Message-ID: <Z-v5Q5H7_am0OMOg@calendula>
References: <20250401142917.11171-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250401142917.11171-1-fw@strlen.de>

On Tue, Apr 01, 2025 at 04:29:14PM +0200, Florian Westphal wrote:
> a delete request will cause a crash in obj_cache_dump, move the deref
> into the filter block.
> 
> Fixes: dbff26bfba83 ("cache: consolidate reset command")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/cache.c                                                 | 6 ++++--
>  .../testcases/bogons/nft-f/delete_nonexistant_object_crash  | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash
> 
> diff --git a/src/cache.c b/src/cache.c
> index b75a5bf3283c..c0d96bd14a80 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -902,6 +902,7 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
>  	int family = NFPROTO_UNSPEC;
>  	const char *table = NULL;
>  	const char *obj = NULL;
> +	bool reset = false;
>  	bool dump = true;
>  
>  	if (filter) {
> @@ -914,9 +915,10 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
>  		}
>  		if (filter->list.obj_type)
>  			type = filter->list.obj_type;
> +
> +		reset = filter->reset.obj;
>  	}
> -	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump,
> -				    filter->reset.obj);
> +	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump, reset);
>  	if (!obj_list) {
>                  if (errno == EINTR)
>  			return NULL;
> diff --git a/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash b/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash
> new file mode 100644
> index 000000000000..c369dec8c07d
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/delete_nonexistant_object_crash
> @@ -0,0 +1 @@
> +delete quota a b
> -- 
> 2.49.0
> 
> 
