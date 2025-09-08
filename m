Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB021C07C3
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 10:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327352; cv=none; b=AMqxpE0UcY6238HM9VCc8UKVa2peUK08uvLfnNu2SyvsuFHxEHG0ka/MeULsm/7C/cmhVol3r9tASaDsAixMcy2KEIxLUNuT0qZAd66d8FvK1KQ/TbJ7Xx3f2QGd9WAqQgi2M0KxI9cfAOahPYN3OyP9DhQBnVz0o7XHsFLp24k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327352; c=relaxed/simple;
	bh=slKPW8/vIni/H4EdOp8gAzpEkkDBH+sgcvuPrgoge5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atMv0VwuxhpUNu4Y17BHFIMbYF1JovO9baoCsumclYuBwzYnf0e52fzuBP0+QdeGvTa0/c6jKle2JvmUDiSjJ98obU+T/WimbYF6vJIi6pMkvvRLajjohbuwAXsKGi3yXSboTXtTltTfCVSQll4sEwjQcq4m6hNEvhD7nIwdqWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kNUwiMc3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NR1voKfn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kNUwiMc3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NR1voKfn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6E27860684; Mon,  8 Sep 2025 12:29:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327347;
	bh=5sSP5u4gQwwI8LCHuf4pM6EiIGmlnF//zyRoN/ONp+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNUwiMc3EoThjzBXk8JS/zsMxTZZBL0G6HI1jK7HkCz9eDbfbyThHiRa9yAnNlnyJ
	 WsC6e14sVUFjK+sPkw2qBuytgsXQxJ34y6FWrzQp9kDrOCz6wUsguZcCfnBbihEuXL
	 2q1e/wfSzn02F6NfW+bMS5Od6j73E8vPZlD5V4CAbRCDeyyHjk4ogcz5Iq12zIpNPj
	 22icql8IheyijcrQnCLaoZ7d9BQfSVWOYJxZsLZU49rwnqn7QW6kYvYzPlWUxiiJds
	 rSpbyYCxB8V5Ag6L0O+k/KHft9ij7kMc+Ht6QkHtp7V0AWO+E6iDRtTg9crpIGNkm+
	 jwwKm2YRa87mw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8FF3460279;
	Mon,  8 Sep 2025 12:29:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757327346;
	bh=5sSP5u4gQwwI8LCHuf4pM6EiIGmlnF//zyRoN/ONp+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NR1voKfna+1xSM1L+qXOAxYv68HloCHXcDZSXkXPQqTUE1ZZv2lsEkHPuHJOY+93/
	 Vm0t/0N0kkbMbM6PI3FXHsSdN6p73jgOMJfJscO+ptlPvRpoomubo4KqrW2rHxro/p
	 xaoI6JsHL6LisfJ7LojPtWcTpNjXPQuXcb9q5ck1d2qTu4IIbI7AmLqPgnLtA80nDq
	 /4cRUfvW7u8B/D5U9UV8ErBEWMcVbrnMjc/8iOh1i+OGRKPxvqZU+38F+w1NlffP6A
	 jYLXQXJ+PzkiimwJwR0mkK+b4cIBPZRSrrIOb6ldxK4l+YhpYFEDdE+tiViB4tiWTK
	 IgBptA1LhdzkQ==
Date: Mon, 8 Sep 2025 12:29:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/5] mnl: Allow for updating devices on existing inet
 ingress hook chains
Message-ID: <aL6v70HMECk3feny@calendula>
References: <20250829142513.4608-1-phil@nwl.cc>
 <20250829142513.4608-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829142513.4608-4-phil@nwl.cc>

On Fri, Aug 29, 2025 at 04:25:11PM +0200, Phil Sutter wrote:
> Complete commit a66b5ad9540dd ("src: allow for updating devices on
> existing netdev chain") in supporting inet family ingress hook chains as
> well. The kernel does already but nft has to add a proper hooknum
> attribute to pass the checks.
> 
> The hook.num field has to be initialized from hook.name using
> str2hooknum(), which is part of chain evaluation. Calling
> chain_evaluate() just for that purpose is a bit over the top, but the
> hook name lookup may fail and performing chain evaluation for delete
> command as well fits more into the code layout than duplicating parts of
> it in mnl_nft_chain_del() or elsewhere. Just avoid the
> chain_cache_find() call as its assert() triggers when deleting by
> handle and also don't add to be deleted chains to cache.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/evaluate.c | 6 ++++--
>  src/mnl.c      | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b7e4f71fdfbc9..db4ac18f1dc9f 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5758,7 +5758,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>  		return table_not_found(ctx);
>  
>  	if (chain == NULL) {
> -		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
> +		if (ctx->cmd->op != CMD_DELETE &&
> +		    ctx->cmd->op != CMD_DESTROY &&
> +		    !chain_cache_find(table, ctx->cmd->handle.chain.name)) {
>  			chain = chain_alloc();
>  			handle_merge(&chain->handle, &ctx->cmd->handle);
>  			chain_cache_add(chain, table);
> @@ -6070,7 +6072,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
>  		return 0;
>  	case CMD_OBJ_CHAIN:
>  		chain_del_cache(ctx, cmd);
> -		return 0;
> +		return chain_evaluate(ctx, cmd->chain);

Maybe fix this to perform chain_del_cache() after chain_evaluate()?
ie.

                if (chain_evaluate(ctx, cmd->chain) < 0)
                        return -1;

                chain_del_cache(ctx, cmd);
                return 0;

>  	case CMD_OBJ_TABLE:
>  		table_del_cache(ctx, cmd);
>  		return 0;
> diff --git a/src/mnl.c b/src/mnl.c
> index 984dcac27b1cf..d1402c0fcb9f4 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -994,6 +994,8 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
>  		struct nlattr *nest;
>  
>  		nest = mnl_attr_nest_start(nlh, NFTA_CHAIN_HOOK);
> +		mnl_attr_put_u32(nlh, NFTA_HOOK_HOOKNUM,
> +				 htonl(cmd->chain->hook.num));
>  		mnl_nft_chain_devs_build(nlh, cmd);
>  		mnl_attr_nest_end(nlh, nest);
>  	}
> -- 
> 2.51.0
> 
