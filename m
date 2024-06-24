Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A1F21A0C
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2024 19:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719256605; cv=none; b=SGNxiZE6SxDRb+V+xTUrsGbT7mLA5sVCY9HJ5fV2VQdoU4h6141qu8koPa2xmKcWZtnFvsI5Pkj2s3GLDv7pALeglfBWWk648ZpF59zf+CnA6xAiAamk5gppCxoSb6HfJMh0jzVR64/Fvq9W0oMPAiou0e2zZVHg1jx1x3vhkRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719256605; c=relaxed/simple;
	bh=n1wqCdMfKkoMSdX2BkV5Q05D6YuBSsyyRbh4YNC1bQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5bZfFA05xEpYxasKrUFRu1cgKA0ABuAY6enn79wbkLE3jyqdywVOxm1vhpKyh+jkrUVpYQH828+FDlOXiCcLM55fP+jJiPgwbmXNussjoh9Gqqx6xt+Vthj720vu6UEk3wMFdHAfTbXSJboo7bBlF7v4UVJT0c8Vork1z05vMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50230 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sLpB7-005Fcd-Co; Mon, 24 Jun 2024 21:16:39 +0200
Date: Mon, 24 Jun 2024 21:16:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <ZnnGFCF_BTe4YN-V@calendula>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240513130057.11014-3-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

One more question:

On Mon, May 13, 2024 at 03:00:42PM +0200, Florian Westphal wrote:
[...]
> @@ -1621,12 +1620,23 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
>   */
>  struct nft_trans {
>  	struct list_head		list;
> -	struct list_head		binding_list;
>  	int				msg_type;
>  	bool				put_net;
>  	struct nft_ctx			ctx;
>  };
>  
> +/**
> + * struct nft_trans_binding - nf_tables object with binding support in transaction
> + * @nft_trans:    base structure, MUST be first member

This comment says nft_trans MUST be first.

I can add BUILD_BUG_ON for all nft_trans_* objects to check that
nft_trans always comes first (ie. this comes at offset 0 in this
structure).

Thanks.
