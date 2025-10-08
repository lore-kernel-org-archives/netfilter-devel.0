Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78D92F6168
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 11:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759921899; cv=none; b=tptQ5CF42+Y0blOaTYAQj5SfUJiAepPnYawG9FBUGqYXfNw1pEIVNPHXMygeCJtAl9QGDyPXv7CxS4iCCfZcXRKBAqDSR8v/YDV7G3Jf0f7tgcaIPeapBpdOOcIFu+0CuduckRH3cLaSD1+plPBOWxvAKCRUeEkfF7eaZpnLWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759921899; c=relaxed/simple;
	bh=HpejdlKSzzsCBsa+jDJxbMoGxbVbScuWE1f+zgq1g+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqIo0kSaYXhLEyq4+9nj6PYOWMV1tc8WFrB2uyCQBNNUrXptA5ydAhlmDlnE+DMR83vvVIWGPgErl6JyoEqssamOPypOd6FLWnXaTXmNPhSCS9eh2HvN44ByMqDoENtanLVvCXDkmT88yg/1YtgYQZsLwsVZ1WFe9yNY6WHwVhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QO6S8lsM; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LdFFFc0t; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QO6S8lsM";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LdFFFc0t"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 269366026E; Wed,  8 Oct 2025 13:11:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759921894;
	bh=na6GIwEMpyonhw+vZGG0HzNF61v1qk5iQA3Ux/bODhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QO6S8lsM8vm9zZH2dg64MvIUK/slbTf8m2nqeX8n97KqmHNsLl2qdEQyLv3AWq1Sk
	 gmXvuf1ulgVZRMm8dUjZjjB/luYTrevzRuPMx2FWiF+3e+XhA2h/sGGpeaz3WeoH47
	 bqnEUwydLZnYH/J+MykbUT1CMC7HDYqGFTFOPxMn76hBzMuRj7I9rHOsuvZnDN9gP5
	 B4dEONAGwcep2fsVvA5bPugE4TZPM22xMN0Vc+z3ej9lY3US/dx8I2GYO/6ExMpeUn
	 KdIJ7MKX16Xi8xPFLzXh8rRQR/vqZ8asDy/r/P1ezsUeC1cOqQ7/HXTKzEFKpYT7p0
	 eVQP/EiLqSDTA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5A70460262;
	Wed,  8 Oct 2025 13:11:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759921891;
	bh=na6GIwEMpyonhw+vZGG0HzNF61v1qk5iQA3Ux/bODhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LdFFFc0tqd1O3e7Y/J+vM6MoXVe1fDxN+ZaqFcho2QFhCNqeuwAYdDVvrSiVcK5LN
	 cGSsJXtE9MzHWMUUNIgplE0gkgwQ8n/lDkAi6lXUwuer3c0qDUiUkzGdLXThRmUtJd
	 lS2aC3/3e2VBArk1PY/jNG+lHOA4V4vug4lnirdYYMCvRxrkrAWuALddkXesF4ctDv
	 Ex5ABdbsejHXglGwzau9kyS4lKfkl6fpIiZFdGiSNWuqAHiS5CoVmKF5dCW7IigcsJ
	 IlMz8rboyCxjYInKBpNXnoE0NXg+MzJuYRHgzqMncqztHKOzYc9UGowJKcRDVsOZuT
	 xgV6BwwqawtTA==
Date: Wed, 8 Oct 2025 13:11:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: Re: [PATCH nf v2] netfilter: nft_objref: validate objref and
 objrefmap expressions
Message-ID: <aOZG4TEch18WK7mQ@calendula>
References: <20251008100816.8526-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251008100816.8526-1-fmancera@suse.de>

On Wed, Oct 08, 2025 at 12:08:16PM +0200, Fernando Fernandez Mancera wrote:
> Referencing a synproxy stateful object from OUTPUT hook causes kernel
> crash due to infinite recursive calls:
> 
> BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
> [...]
> Call Trace:
>  __find_rr_leaf+0x99/0x230
>  fib6_table_lookup+0x13b/0x2d0
>  ip6_pol_route+0xa4/0x400
>  fib6_rule_lookup+0x156/0x240
>  ip6_route_output_flags+0xc6/0x150
>  __nf_ip6_route+0x23/0x50
>  synproxy_send_tcp_ipv6+0x106/0x200
>  synproxy_send_client_synack_ipv6+0x1aa/0x1f0
>  nft_synproxy_do_eval+0x263/0x310
>  nft_do_chain+0x5a8/0x5f0 [nf_tables
>  nft_do_chain_inet+0x98/0x110
>  nf_hook_slow+0x43/0xc0
>  __ip6_local_out+0xf0/0x170
>  ip6_local_out+0x17/0x70
>  synproxy_send_tcp_ipv6+0x1a2/0x200
>  synproxy_send_client_synack_ipv6+0x1aa/0x1f0
> [...]
> 
> Implement objref and objrefmap expression validate functions.
> 
> Currently, only NFT_OBJECT_SYNPROXY object type requires validation.
> This will also handle a jump to a chain using a synproxy object from the
> OUTPUT hook.
> 
> Now when trying to reference a synproxy object in the OUTPUT hook, nft
> will produce the following error:
> 
> synproxy_crash.nft: Error: Could not process rule: Operation not supported
>   synproxy name mysynproxy
>   ^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
> Reported-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
> Closes: https://bugzilla.suse.com/1250237
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks Fernando, this looks simpler.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

One day, if there are more objects that need validation, it should be
possible to add a .validate interface to objects, but I prefer this
approach because it will be easier to backport.

> ---
>  net/netfilter/nft_objref.c | 39 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
> index 8ee66a86c3bc..1a62e384766a 100644
> --- a/net/netfilter/nft_objref.c
> +++ b/net/netfilter/nft_objref.c
> @@ -22,6 +22,35 @@ void nft_objref_eval(const struct nft_expr *expr,
>  	obj->ops->eval(obj, regs, pkt);
>  }
>  
> +static int nft_objref_validate_obj_type(const struct nft_ctx *ctx, u32 type)
> +{
> +	unsigned int hooks;
> +
> +	switch (type) {
> +	case NFT_OBJECT_SYNPROXY:
> +		if (ctx->family != NFPROTO_IPV4 &&
> +		    ctx->family != NFPROTO_IPV6 &&
> +		    ctx->family != NFPROTO_INET)
> +			return -EOPNOTSUPP;
> +
> +		hooks = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD);
> +
> +		return nft_chain_validate_hooks(ctx->chain, hooks);
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nft_objref_validate(const struct nft_ctx *ctx,
> +			       const struct nft_expr *expr)
> +{
> +	struct nft_object *obj = nft_objref_priv(expr);
> +
> +	return nft_objref_validate_obj_type(ctx, obj->ops->type->type);
> +}
> +
>  static int nft_objref_init(const struct nft_ctx *ctx,
>  			   const struct nft_expr *expr,
>  			   const struct nlattr * const tb[])
> @@ -93,6 +122,7 @@ static const struct nft_expr_ops nft_objref_ops = {
>  	.activate	= nft_objref_activate,
>  	.deactivate	= nft_objref_deactivate,
>  	.dump		= nft_objref_dump,
> +	.validate	= nft_objref_validate,
>  	.reduce		= NFT_REDUCE_READONLY,
>  };
>  
> @@ -197,6 +227,14 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
>  	nf_tables_destroy_set(ctx, priv->set);
>  }
>  
> +static int nft_objref_map_validate(const struct nft_ctx *ctx,
> +				   const struct nft_expr *expr)
> +{
> +	const struct nft_objref_map *priv = nft_expr_priv(expr);
> +
> +	return nft_objref_validate_obj_type(ctx, priv->set->objtype);
> +}
> +
>  static const struct nft_expr_ops nft_objref_map_ops = {
>  	.type		= &nft_objref_type,
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
> @@ -206,6 +244,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
>  	.deactivate	= nft_objref_map_deactivate,
>  	.destroy	= nft_objref_map_destroy,
>  	.dump		= nft_objref_map_dump,
> +	.validate	= nft_objref_map_validate,
>  	.reduce		= NFT_REDUCE_READONLY,
>  };
>  
> -- 
> 2.51.0
> 
