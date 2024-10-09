Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7D617C22B
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728464919; cv=none; b=ACPsyifjhhW52NgSM+U2Ya6bA6JJVzFj9JJiS60/1ay/HPoXSyUV0QZxpPgERXNvrJH0v9YaNavrKleu506m8HXPvTTAMfJJ9P7OnQ8sEl3Yobbdvn0WwvITsqPKMTjyN3GWDR6iIuRiF2Ou6NKiqGerIyrlfetP+sieXz6dENg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728464919; c=relaxed/simple;
	bh=PgICnpzSTlZ73tA+WYwOy5rxNGi7sMSkhykV7TB3lY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Op+5V+4S2iLnzVmBSgsVlqA/7ZfC85lio7GevlpgMqO8Qh21wU01mueKFzzRC9/Jxw+LjDlkiYG6vMjuS/YcZLrxgAvK2txjezkbXpLoiVoPLkG2CODnz6mXaUfGzr+YsyATSvCQkg572ZPDGRzXshUoGk6zU5fGmlsIX5M/V+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41190 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sySgI-00AbrP-Ja; Wed, 09 Oct 2024 11:08:32 +0200
Date: Wed, 9 Oct 2024 11:08:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: fib: check correct rtable in vrf setups
Message-ID: <ZwZIDe3n0bxYXqt_@calendula>
References: <20241009071908.17644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241009071908.17644-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

On Wed, Oct 09, 2024 at 09:19:02AM +0200, Florian Westphal wrote:
> We need to init l3mdev unconditionally, else main routing table is searched
> and incorrect result is returned unless strict (iif keyword) matching is
> requested.
> 
> Next patch adds a selftest for this.

Fixes: 2a8a7c0eaa87 ("netfilter: nft_fib: Fix for rpath check with VRF devices")

> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1761
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
>  net/ipv6/netfilter/nft_fib_ipv6.c | 5 +++--
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index 00da1332bbf1..09fff5d424ef 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -65,6 +65,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  		.flowi4_scope = RT_SCOPE_UNIVERSE,
>  		.flowi4_iif = LOOPBACK_IFINDEX,
>  		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
> +		.flowi4_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
>  	};
>  	const struct net_device *oif;
>  	const struct net_device *found;
> @@ -83,9 +84,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else
>  		oif = NULL;
>  
> -	if (priv->flags & NFTA_FIB_F_IIF)
> -		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
> -
>  	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
>  	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
>  		nft_fib_store_result(dest, priv, nft_in(pkt));
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 36dc14b34388..c9f1634b3838 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -41,8 +41,6 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> -	} else if (priv->flags & NFTA_FIB_F_IIF) {
> -		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
>  	}
>  
>  	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
> @@ -75,6 +73,8 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
>  	else if (priv->flags & NFTA_FIB_F_OIF)
>  		dev = nft_out(pkt);
>  
> +	fl6.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
> +
>  	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
>  
>  	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
> @@ -165,6 +165,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  		.flowi6_iif = LOOPBACK_IFINDEX,
>  		.flowi6_proto = pkt->tprot,
>  		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
> +		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
>  	};
>  	struct rt6_info *rt;
>  	int lookup_flags;
> -- 
> 2.46.2
> 
> 
