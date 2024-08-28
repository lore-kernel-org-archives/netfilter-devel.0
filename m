Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C352868B;
	Wed, 28 Aug 2024 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856819; cv=none; b=BkEa8pqcr4F5ngzEVGt/yqil1fUFBSVNa96feN35G9i9bwsxyw+O2cg9u5lHOOzLsl3KqQcW1JbiDF7/0FJh1FN3NTy7cfFktv2DfIuM5ZHvxZaeQqsVweHiBdqdJ1ISJHirbQren7Va8KiS9yD5XpClO1AJL1Zgt+4rDKr+yxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856819; c=relaxed/simple;
	bh=g3oKDAMDwUwbWBZWpSEiKfl56BXIfpiGoVDTOcj7Ao4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FaQ0W9dLJ524w8Hz2xH5w6L81dj5EMnPUN75TIm4BsASFDeWEfkGrH0N15hEmaVsXRrdcsmUOwQ3qcjHdTO56srRqnikfe14hjtChsNipnNaI6nbLxd1uar0w1rpUtVIQtMxtO7Gl3UwY3MBOJj70J/tN0CJ8O4z4fKY7SlDto8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33720 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjK3A-001cPl-Im; Wed, 28 Aug 2024 16:53:34 +0200
Date: Wed, 28 Aug 2024 16:53:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] netfilter: nf_tables: Add __percpu annotation to *stats
 pointer in nf_tables_updchain()
Message-ID: <Zs8564GQ2c486JVR@calendula>
References: <20240806102808.804619-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240806102808.804619-1-ubizjak@gmail.com>
X-Spam-Score: -1.8 (-)

On Tue, Aug 06, 2024 at 12:26:58PM +0200, Uros Bizjak wrote:
> Compiling nf_tables_api.c results in several sparse warnings:
> 
> nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)
> 
> Add __percpu annotation to *stats pointer to fix these warnings.
> 
> Found by GCC's named address space checks.
> 
> There were no changes in the resulting object files.

I never replied to this.

I can see this is getting things better, but still more sparse
warnings show up related tho nft_stats. I'd prefer those are fixed at
ones, would you give it a look?

> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 481ee78e77bc..805227131f10 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2642,7 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  	struct nft_table *table = ctx->table;
>  	struct nft_chain *chain = ctx->chain;
>  	struct nft_chain_hook hook = {};
> -	struct nft_stats *stats = NULL;
> +	struct nft_stats __percpu *stats = NULL;
>  	struct nft_hook *h, *next;
>  	struct nf_hook_ops *ops;
>  	struct nft_trans *trans;
> -- 
> 2.45.2
> 
