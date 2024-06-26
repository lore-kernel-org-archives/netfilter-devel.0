Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8E178387
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719401509; cv=none; b=u8Ke7LwowdYJ2yOUeHj9OqjFfAeBp733zdx3p7qOYkaqttbGVMQewYUjxxJDr4xRWn4IDxzWDkEN7JG+D93/gwpdpG49MaMRJoocOI7nwVH5AjiyiKmGaFTzFQNA2HXyjEf0JOuQiRFJvrGN3hZ8t9/zC4r1nKr24glz1QCXZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719401509; c=relaxed/simple;
	bh=99aIyH4Mv8YVzQ1pgB9M4mVcz/K5y/QIuO2ziAG4OzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V78azkLWXaX2SrAhVhdZW6kzTkWt8soRvo2QpjPSse5EYYykQ9swicQrqYzyuLHo8g8m33E8geCgEqf15+9RMzeVwryKYlzr+q+u8k4M1m9xwlXz94V9nWDBGIwJWBNWxiBa4L626mxR5MjCxI0AP++xoRRZyDSOHKg3mNnI6KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55718 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMQsH-007s7s-Ps; Wed, 26 Jun 2024 13:31:44 +0200
Date: Wed, 26 Jun 2024 13:31:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: rgb@redhat.com, paul@paul-moore.com
Subject: Re: [PATCH nf-next] netfilter: nf_tables: rise cap on SELinux
 secmark context
Message-ID: <Znv8HMKbgSCwdPp-@calendula>
References: <20240603181659.5998-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240603181659.5998-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

Enqueued to nf-next to address:

https://bugzilla.netfilter.org/show_bug.cgi?id=1749

On Mon, Jun 03, 2024 at 08:16:59PM +0200, Pablo Neira Ayuso wrote:
> secmark context is artificially limited 256 bytes, rise it to 4Kbytes.
> 
> Fixes: fb961945457f ("netfilter: nf_tables: add SECMARK support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index aa4094ca2444..639894ed1b97 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1376,7 +1376,7 @@ enum nft_secmark_attributes {
>  #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
>  
>  /* Max security context length */
> -#define NFT_SECMARK_CTX_MAXLEN		256
> +#define NFT_SECMARK_CTX_MAXLEN		4096
>  
>  /**
>   * enum nft_reject_types - nf_tables reject expression reject types
> -- 
> 2.30.2
> 
> 
