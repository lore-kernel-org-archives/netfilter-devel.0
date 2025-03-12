Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE71E4929
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741806918; cv=none; b=aXugK9MZYNQHvxCntGe0X5/ad4zToj0xi2xDAkFg3v1bM2cmWiwUcX34zbIPEjhkjt+77ZoB6cGg0aHryUylcywua07HOw4ZZkIoUP7bz6shScGpnhI1S8ZcPHoDN563s07QfGGLqIR3ckTrXfQTAbxCZgLkeWcMJ0Lbbx7EvzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741806918; c=relaxed/simple;
	bh=ZbgVDTITSJRO8C5jN26WxAgwTErYLfWW3bSRT6Qkq3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7zCN1DW7r6/mubuaDMKhHemMmJyMwDK+fQLNz65FoZROaaUWDPJwj34rxYdpn3Nl0ANHkA/d8Nh32Z4w7t+5IgS+2mLebQ1mvoI0+p2uqJ89Qm25DPQyOXFwNsWx95hPO5DuBJk1q0ScnCRuDGuaiLfY+OOqqCxE9sG1u8Ietc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TsQxFZao; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wKYeM44C; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TsQxFZao";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wKYeM44C"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 03094602A8; Wed, 12 Mar 2025 20:15:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741806911;
	bh=cE8BTBUnvzmsX/+EZUvdlZ1JMX7YXe1Fg7G2JjvC3P0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TsQxFZaoYmnu5YDqVR/JO78Xo+kHZGXFNUfOpAHB3DZUaYf5I+/uMVL1ORsm0Hn5f
	 LmO8vtXQi8Wi7hQRukIuKYh+OWhITsOf82QJHT4p19/wG4yZosiPL823l2TR5fno4/
	 eEFpAgfF2CwCyLUFOgGB9J6U1q8eiTDabF+hLwv4OA687j1lZXfj8HNaZVEKCSkcQA
	 moGFtAZdi2dKIHyUDpLV7NIbrY4LNkePv30RX4VE4B7hCPCh3t5A7AOqNngJBcg6yL
	 7E3QT3qihcBFmBcOKTLng+WEYpPLVayqWZ43HM0LZ7CrDc5ocb3ZR5HD+/AGfGNB46
	 Iu0+9hfrSB+WQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2BBAD6029C;
	Wed, 12 Mar 2025 20:15:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741806910;
	bh=cE8BTBUnvzmsX/+EZUvdlZ1JMX7YXe1Fg7G2JjvC3P0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wKYeM44CwcMwWOJpxi8aQ/a2nwWFKHLRUgMHnFd7O/p6+VlTrHIbuiawJxu9OoUkj
	 DJqLz65RHzQsTctGylBVCtI3JNMjtn9KErZuPZcgblM4eyTtZ+6w5tJqNuPXFGpNUK
	 VRWF6nxFAiGfF1jnNI47BD3ZPPhwcsfRTlTbS4ffwv4bblORjQFMYNs8NLZMiUxkFk
	 HM4ERG/FpWEIkt1PTIiXztO6zS5K6wx11WTJsRL+I3mLz2GFirlw0dhXGenU2vtzjo
	 C+ODCO+wNlr4cbm+MNK65g8CZXGLUVdZjMg3tQM8Sewrd1raNaRNdKD5orRTN7JjTu
	 LC7BL+yaCLNwQ==
Date: Wed, 12 Mar 2025 20:15:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: fib: avoid lookup if socket is
 available
Message-ID: <Z9HdO_7XgQBbxcg1@calendula>
References: <20250220130703.2043-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250220130703.2043-1-fw@strlen.de>

On Thu, Feb 20, 2025 at 02:07:01PM +0100, Florian Westphal wrote:
> In case the fib match is used from the input hook we can avoid the fib
> lookup if early demux assigned a socket for us: check that the input
> interface matches sk-cached one.
> 
> Rework the existing 'lo bypass' logic to first check sk, then
> for loopback interface type to elide the fib lookup.
> 
> This speeds up fib matching a little, before:
> 93.08 GBit/s (no rules at all)
> 75.1  GBit/s ("fib saddr . iif oif missing drop" in prerouting)
> 75.62 GBit/s ("fib saddr . iif oif missing drop" in input)
> 
> After:
> 92.48 GBit/s (no rules at all)
> 75.62 GBit/s (fib rule in prerouting)
> 90.37 GBit/s (fib rule in input).
> 
> Numbers for the 'no rules' and 'prerouting' are expected to
> closely match in-between runs, the 3rd/input test case exercises the
> the 'avoid lookup if cached ifindex in sk matches' case.
> 
> Test used iperf3 via veth interface, lo can't be used due to existing
> loopback test.

A few questions below.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nft_fib.h   | 21 +++++++++++++++++++++
>  net/ipv4/netfilter/nft_fib_ipv4.c | 11 +++++------
>  net/ipv6/netfilter/nft_fib_ipv6.c | 19 ++++++++++---------
>  3 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
> index 38cae7113de4..6e202ed5e63f 100644
> --- a/include/net/netfilter/nft_fib.h
> +++ b/include/net/netfilter/nft_fib.h
> @@ -18,6 +18,27 @@ nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
>  	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
>  }
>  
> +static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
> +{
> +	const struct net_device *indev = nft_in(pkt);
> +	const struct sock *sk;
> +
> +	switch (nft_hook(pkt)) {
> +	case NF_INET_PRE_ROUTING:
> +	case NF_INET_INGRESS:

Not an issue in your patch itself, it seems nft_fib_validate() was
never updated to support NF_INET_INGRESS.

> +	case NF_INET_LOCAL_IN:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	sk = pkt->skb->sk;
> +	if (sk && sk_fullsock(sk))
> +	       return sk->sk_rx_dst_ifindex == indev->ifindex;
> +
> +	return nft_fib_is_loopback(pkt->skb, indev);
> +}
> +
>  int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
>  int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  		 const struct nlattr * const tb[]);
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index 625adbc42037..9082ca17e845 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -71,6 +71,11 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	const struct net_device *oif;
>  	const struct net_device *found;
>  
> +	if (nft_fib_can_skip(pkt)) {
> +		nft_fib_store_result(dest, priv, nft_in(pkt));
> +		return;
> +	}

Silly question: Does this optimization work for all cases?
NFTA_FIB_F_MARK and NFTA_FIB_F_DADDR.

>  	/*
>  	 * Do not set flowi4_oif, it restricts results (for example, asking
>  	 * for oif 3 will get RTN_UNICAST result even if the daddr exits
> @@ -85,12 +90,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else
>  		oif = NULL;
>  
> -	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
> -	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
> -		nft_fib_store_result(dest, priv, nft_in(pkt));
> -		return;
> -	}
> -
>  	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
>  	if (!iph) {
>  		regs->verdict.code = NFT_BREAK;
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index c9f1634b3838..7fd9d7b21cd4 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -170,6 +170,11 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	struct rt6_info *rt;
>  	int lookup_flags;
>  
> +	if (nft_fib_can_skip(pkt)) {
> +		nft_fib_store_result(dest, priv, nft_in(pkt));
> +		return;
> +	}
> +
>  	if (priv->flags & NFTA_FIB_F_IIF)
>  		oif = nft_in(pkt);
>  	else if (priv->flags & NFTA_FIB_F_OIF)
> @@ -181,17 +186,13 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  		return;
>  	}
>  
> -	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
> -
> -	if (nft_hook(pkt) == NF_INET_PRE_ROUTING ||
> -	    nft_hook(pkt) == NF_INET_INGRESS) {
> -		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
> -		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
> -			nft_fib_store_result(dest, priv, nft_in(pkt));
> -			return;
> -		}
> +	if (nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
> +		nft_fib_store_result(dest, priv, nft_in(pkt));
> +		return;
>  	}
>  
> +	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
> +
>  	*dest = 0;
>  	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
>  				      lookup_flags);
> -- 
> 2.45.3
> 
> 
