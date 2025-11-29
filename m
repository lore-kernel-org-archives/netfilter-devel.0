Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E311A0BE0
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Nov 2025 01:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764379939; cv=none; b=dULJVQfG6D2EOnjHGAo30EGsVfZ6VXTj76UatvG2PEB43RLkhDqpT0AmrnOO0usD3FQ9ag97/nIwZrCly7Bp6zkbrqznnHpCDsS91E/vC6SBpPa0sgIoISxAWTx8A26BtVtGQQFFHgPsgQs8/+ApRDi60o1y0c5Ud9Wzq2nhuzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764379939; c=relaxed/simple;
	bh=vBFtaPY51hQ0OGmuksqeNS8xMy9KYnj16CAU4JjRB5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSRF5loNY1RC4Xs1uPOQYZ7ae1U31ndDsQeMlCLela9WXCa9Hx7DsjfVmZDlWV7h9EmDUTv6y/BomQdqgA/bcbHl8jMJlG/6HuS+vU4nZLPrJjInFBEJZ84h2RLnn3hZHoxJNTl9+rYFzQcPln/zY6Xa1Bd0tNwQpG6KljRHCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 80496604D4; Sat, 29 Nov 2025 02:32:14 +0100 (CET)
Date: Sat, 29 Nov 2025 02:32:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: avoid chain re-validation
 if possible
Message-ID: <aSpNHzxDh-nN7GRX@strlen.de>
References: <20251126114703.8826-1-fw@strlen.de>
 <20251129012211.GA29847@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129012211.GA29847@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> The issue is reproducible with this version of the patch applied, unless
> I make the following change:
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 1cf9f0aa1f49..a7b415c53df6 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4145,14 +4145,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
>  	if (ctx->level == NFT_JUMP_STACK_SIZE)
>  		return -EMLINK;
>  
> -	if (ctx->level > 0) {
> -		/* jumps to base chains are not allowed. */
> -		if (nft_is_base_chain(chain))
> -			return -ELOOP;
> -
> -		if (nft_chain_vstate_valid(ctx, chain))
> -			return 0;
> -	}
> +	if (ctx->level && nft_chain_vstate_valid(ctx, chain))
> +		return 0;

Looks like a placebo change to me?
Also, the nft_is_base_chain(chain) check is required.

> It is also worth noting that I'm still seeing the cpu usage spike up to
> 100% for a couple of seconds (attributed to an iptables process) with
> this version of the patch (even with the above change), while the
> previous rendition seemd to have resolved that.

The previous version makes illegal shortcuts (as in, not validating
when it has to), it cannot be applied.

That said, I have flagged this patch as deferred anyway, there are too
many conflicting changes flying around.

I'll resubmit in a few weeks when -next opens up again.
