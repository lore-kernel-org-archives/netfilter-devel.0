Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE276604DD
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2024 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707954055; cv=none; b=pmqeIr8LwBSW+K7ND7AWZagOlMa5UxNeWtmsoHOOiezIdQznnYMLYQpmgTuOyyQboQS1mtVoGJMKqot5qOobvHBr2/n1hJzFxl2nFLjuZ/iyOxMWUAfjUMACpKOkQ4GwfVNLkMG6xVZwSuG57ucszepb42UqZQrulPBByv5rwNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707954055; c=relaxed/simple;
	bh=wvBUSkZk9Lajn8UR9GN3NeJKg9lnTRa1HnoxAhm+95w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5NAWoSTlK+ejl+s7IRia7haGSYq0nB9IvdXkNPI92gLokjWkmGkkL/IXJGHiOTxr1JZd8TNpjPQc7WuUgcIyxQYowTvPu9nhDsuqCEA5kc/tgBomPeMfLWBVibAUfBxIVw44yJ91JuGr2N7B3eBmKO8GeZXQ2jEqzKlqI//34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=55310 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1raOru-001mYK-Nx; Thu, 15 Feb 2024 00:40:48 +0100
Date: Thu, 15 Feb 2024 00:40:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kernel-team@cloudflare.com,
	jgriege@cloudflare.com
Subject: Re: [PATCH] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
Message-ID: <Zc1PfoWN38UuFJRI@calendula>
References: <20240209121954.81223-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240209121954.81223-1-ignat@cloudflare.com>
X-Spam-Score: -1.9 (-)

Hi Ignat,

On Fri, Feb 09, 2024 at 12:19:54PM +0000, Ignat Korchagin wrote:
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 1f9474fefe84..beea8c447e7a 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -359,6 +359,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
>  
>  	if (ctx->family != NFPROTO_IPV4 &&
>  	    ctx->family != NFPROTO_IPV6 &&
> +	    ctx->family != NFPROTO_INET &&

Please send a v2 restricting this to hooks prerouting, input, forward,
output and postrouting which are the classic hooks, so ingress is not
allowed, both for matches and targets.

Thanks
