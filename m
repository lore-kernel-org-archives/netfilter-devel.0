Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A7946C
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 05:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717566741; cv=none; b=hd7aEO197Y83EyVU8dk+D/gQLQNG06EhQE1dG2Ofg1dPJ4pSvMqFcJuFMHZSm8iMsr9tarEL+nrcRxJySCA4mg/JZu0ti6ehgRCbJI1MQ/llauEJQjx4jRbWi6guhkX9DVuWVCZw+bkP9nh/QhsYTgi2pRHJu+dlzf6PY7BOdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717566741; c=relaxed/simple;
	bh=7QfuTFmIvOt1VUhc5FeIscPZl52KY6EThgDk4dv8nQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpo+8u8Lsuh7rR/IeFWYJ1bd1h0oF/pJqyc9ZykoaOIDCnSxfDNhRH47sllweAwWABY4nONkkN2TyGTEcxM7QeyakoSRM73NHgKRg3gdO8pgqWuURCoipbgsapaPUtWShd99YDVmSejmH5efUhAlXsB0ZsFi1OkT/oQotZsRpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.218.95] (port=2834 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEjZ8-00A2mZ-CV; Wed, 05 Jun 2024 07:52:08 +0200
Date: Wed, 5 Jun 2024 07:52:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Davide Ornaghi <d.ornaghi97@gmail.com>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH nft] Check for NULL netlink attributes
Message-ID: <Zl_9BPZ8sKK9PzR9@calendula>
References: <CAHH-0UdpvNzWOD9Ef1KHF=hYsoyYGi0K=okkyJormxv=-deNbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHH-0UdpvNzWOD9Ef1KHF=hYsoyYGi0K=okkyJormxv=-deNbQ@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Hi Davide,

I suggest this patch subject:

        nf_tables: nft_inner: validate mandatory meta and payload netlink attributes

On Tue, Jun 04, 2024 at 11:36:21PM +0200, Davide Ornaghi wrote:
> Payload and meta nftables exprs can be embedded into inner exprs via
> nft_expr_inner_parse, which doesn't check for NULL netlink attributes,
> unlike other exprs passing through select_ops.
> Add the missing checks to nft_meta_inner_init and nft_payload_inner_init
> to prevent dereferencing NULL pointers and eventually causing UAF reads on commit_mutex.

I'd suggest this patch description:

"Check for mandatory netlink attributes in payload and meta expression
when used embedded from the inner expression, otherwise NULL pointer
dereference is possible if userspace."

And please add:

Fixes: a150d122b6bd ("netfilter: nft_meta: add inner match support")
Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")

Thanks a lot for submitting your fix.

> Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
> ---
>  net/netfilter/nft_meta.c    | 2 ++
>  net/netfilter/nft_payload.c | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index ba0d3683a..e2893077b 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -839,6 +839,8 @@ static int nft_meta_inner_init(const struct nft_ctx
> *ctx,
>         struct nft_meta *priv = nft_expr_priv(expr);
>         unsigned int len;
> 
> +       if (!tb[NFTA_META_KEY] || !tb[NFTA_META_DREG])
> +               return -EINVAL;
>         priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
>         switch (priv->key) {
>         case NFT_META_PROTOCOL:
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index 0c43d748e..4c6f15ad0 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -650,6 +650,9 @@ static int nft_payload_inner_init(const struct nft_ctx
> *ctx,
>         struct nft_payload *priv = nft_expr_priv(expr);
>         u32 base;
> 
> +       if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
> +           !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
> +               return -EINVAL;
>         base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
>         switch (base) {
>         case NFT_PAYLOAD_TUN_HEADER:
> --
> 2.34.1
