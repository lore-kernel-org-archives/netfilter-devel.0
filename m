Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A94B3101B6
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781036336; cv=none; b=gwVyEBhz8MJUwv+ANgARZNXHGMGaThSpcYjnMnpu9xmnoArADlMtADb+WXgtOv9F7rz56RpT330Xx1QReKJk8Lo3FrBphyIuOxH3g7bB1NAjdLWt/qp1XsQ1Ji9IgF0NFjTfrgSEg7o3JpHnOE/JunGMjQ/55l8k5Ac+4G3Qg9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781036336; c=relaxed/simple;
	bh=5nLg38TKicTWKWzLXWRD9Wq6oAYrNczBg1efgcBxhZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ha+EIO0kIClrGOkLOK4AoHngDGdbEcc+2rw4sZQJ3fppyhusPj8fAZ9P/u5vAEdgY4+K1bG06OFMkNbGOooPr5KmTgm0j3eOmR5maRAKxSSeZmbq0BYl0NTvkgYjco8uzMJ9E6bUVN0Wx/XBnfs/vMQsY9asroBJsDmRuumkIgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CFF5360C94; Tue, 09 Jun 2026 22:18:52 +0200 (CEST)
Date: Tue, 9 Jun 2026 22:18:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Davide Ornaghi <d.ornaghi97@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org
Subject: Re: [PATCH 1/2] netfilter: nft_fib: fix stale stack leak via the
 OIFNAME register
Message-ID: <aih1JpA0iAD84GNb@strlen.de>
References: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
 <20260609163215.1102215-2-d.ornaghi97@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609163215.1102215-2-d.ornaghi97@gmail.com>

Davide Ornaghi <d.ornaghi97@gmail.com> wrote:
> diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> index 327a5f3365..6df811b8d5 100644
> --- a/net/netfilter/nft_fib.c
> +++ b/net/netfilter/nft_fib.c
> @@ -107,6 +107,9 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  		return -EINVAL;
>  	}
>  
> +	if (priv->flags & NFTA_FIB_F_PRESENT)
> +		len = sizeof(u8);
> +

Would you mind sending a v2 that also rejects NFTA_FIB_F_PRESENT for all
cases except NFT_FIB_RESULT_OIF ?

Its not strictly required but its better to be explicit, I think.

Rest looks good.
