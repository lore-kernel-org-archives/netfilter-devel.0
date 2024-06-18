Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1FB13A41A
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 08:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718699070; cv=none; b=Chamh4cMn4d7LsmXSJ/Qbk+0o9jeonH+C6AIpIYmsxVI0meyElg64SiTTIcpvx9s7bML7LinkZs8DTL74JIv/4zVXWyRK2rLI7Kj+lIKDmPmXTw9gnRoA45whXI11Jf1j4IO8UvJX21e+V+spoAPDPZM5kiN+ZwjAFzM7MFHaiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718699070; c=relaxed/simple;
	bh=PmJG4sH4ASq9JlksPdgwEbAgKmxE5DpNk+62Rn7l30Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqqGI5HL08FaT7/CyxSguXApBTAbooqFuESYxBlcS+Xj1ECjYMeAFZ0uFo2sXbMQhy2mazJg3SdbOlpggu2xYVdyXygYGW5FXACA2a8/XFRdSkYC4DPEUifzQ4sgPFrAdgPU2rDXnXiMU+olyJ/m2T62P1s6W5ayYJzbRrHh80E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56738 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJU8b-00D9Ih-5w; Tue, 18 Jun 2024 10:24:23 +0200
Date: Tue, 18 Jun 2024 10:24:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <ZnFENEs7ESGSM2Ub@calendula>
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

I like this series, just a comestic glitch.

On Mon, May 13, 2024 at 03:00:42PM +0200, Florian Westphal wrote:
> @@ -416,11 +436,26 @@ static int nft_deltable(struct nft_ctx *ctx)
>  	return err;
>  }
>  
> -static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
> +static struct nft_trans *
> +nft_trans_alloc_chain(const struct nft_ctx *ctx, int msg_type)
>  {
>  	struct nft_trans *trans;
>  
>  	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
> +	if (trans) {

May I mangle this to do here:

        if (!trans)
                return NULL;

...

> +		struct nft_trans_chain *chain = nft_trans_container_chain(trans);
> +
> +		INIT_LIST_HEAD(&chain->nft_trans_binding.binding_list);
> +	}
> +
> +	return trans;
> +}
> +
> +static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
> +{
> +	struct nft_trans *trans;
> +
> +	trans = nft_trans_alloc_chain(ctx, msg_type);
>  	if (trans == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -560,12 +595,16 @@ static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
>  			       struct nft_set *set,
>  			       const struct nft_set_desc *desc)
>  {
> +	struct nft_trans_set *trans_set;
>  	struct nft_trans *trans;
>  
>  	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_set));
>  	if (trans == NULL)
>  		return -ENOMEM;

As it is done here?

>  
> +	trans_set = nft_trans_container_set(trans);
> +	INIT_LIST_HEAD(&trans_set->nft_trans_binding.binding_list);
> +
>  	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
>  		nft_trans_set_id(trans) =
>  			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
