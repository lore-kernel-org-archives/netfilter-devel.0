Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC917BA6
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510667; cv=none; b=gI6G6Mu+EJBsVEbW3ZV+R9zFF3DqqYj1t4/hqgIQUXjNRBFLFJvTXPuparjxtHWmr+VYynJ9zURLr9a560oY9w9VUz/NmC4bIYuqG57RYv2DcVEO6+BR00KeBCKDsHojUj894ppTUGDwaQssKteyh+gVfLsEgdE4VWoJfQGi5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510667; c=relaxed/simple;
	bh=IFrKjUWYOJGli+yD9rCJ07MBbOOjI8jLlWfpqSyyipA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIdxm7ljeLdcL8nTmlPmPGZ8d03XKB4U3sm6D+o3LmTxWZWMogZF8RTTNdXtznHYQy/2JFOSymqWYCbeRDjk/r8EaI4TOKOKnSJl8+47AAm5GgchFKa7eWC4of2liZ832/ptc0Kb/hJAUBzkpXTWNYazr4nWTQ0YcqgmXnMOaTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9AF4E604EF; Wed, 19 Nov 2025 01:04:22 +0100 (CET)
Date: Wed, 19 Nov 2025 01:04:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: skip register
 jump/goto validation for non-base chain
Message-ID: <aR0Jh0XH3FyqGr2k@strlen.de>
References: <20251118235009.149562-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118235009.149562-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Validating a non-base chain for each register store slows down
> validation unnecessarily, remove it.
> 
> Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 6f35f0b7a33c..bef95cede7b5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -11846,6 +11846,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
>  		if (data != NULL &&
>  		    (data->verdict.code == NFT_GOTO ||
>  		     data->verdict.code == NFT_JUMP)) {
> +			if (!nft_is_base_chain(ctx->chain))
> +				break;
> +

This is confusing.  ctx->chain? data->verdict.chain?

Wouldn't it make more sense to elide the check if we have
ctx->table->validate_state != NFT_VALIDATE_DO ?
