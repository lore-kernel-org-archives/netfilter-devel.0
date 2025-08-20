Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742C12DCF43;
	Wed, 20 Aug 2025 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695788; cv=none; b=H71iHQU+nqTo+k6eCstu0IAurwyfsbKzAEWGhVR0Wy8kqwDptbR1doiTe8u5s4Ilpa72ES0YYFE4S5gYGtTWJPYiT8073nU1b6LLQbSjhyGSJge9n3lDhf68RUM0sKOL9aI59qe3fD16n/pOU/1PxFRsUCsthxMyS/YrVXJ4K2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695788; c=relaxed/simple;
	bh=M/Gtj4VuJhvC6tefAI+uwGSKVz5f8FOt6CqDTJyKPEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsMQas/8fgsyXLJ3kckl/gLB3os2Wl4PhBXZ3D2uhaZuY3qvNgeTdM9sWTUr2lDjIm78ApN3QgyOZvYixI4cpdOxafsUnxaK2DUQ+OIqSRs9AVu1KSbll1v7djlNtepRsB8B078DkQhKoeSLCgIdK1ckaX6Uf5QnZf66lHqJMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vF2VAAi2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YWWG5zgn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vF2VAAi2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YWWG5zgn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EE8D360288; Wed, 20 Aug 2025 15:16:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755695784;
	bh=+KEtSIUuEFrD7q4Ur30nggZ6MOG/WgMr0KGtuNEpA8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vF2VAAi2EDH6dbKLM+a/P0HRRUbIpqf0sbD3FKQnO4mRFADfUqINufZP6A1JLZ0zX
	 5fSVtRSnKzwR7fGzsUfDgEfb8+NEpdjloERFq4vrtYBd78Fb8ADEHKM82P0NfzREMe
	 3GQA/Zjm+ahza2mNqMbuGdv63Vojt+jIYb1eoGufovrjrmcvZq1bbjQdPFapZ8WKSb
	 H/KiDgUI5O4WX8fJD3jqgZSCscm8U2AaFQFOQod4l2aYN7PZzNSsAeD8LDcBUaDL3F
	 D5IT508T4ny50xvHNpByGei0khMVrDOagDUz3B5qgeVYxkK4gQ+ovf3Po9rzkjLN9V
	 BZ0hwiHNjz0Og==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD2D460280;
	Wed, 20 Aug 2025 15:16:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755695783;
	bh=+KEtSIUuEFrD7q4Ur30nggZ6MOG/WgMr0KGtuNEpA8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWWG5zgnxXyQXYRnXrXciE9z5177YcCpH8uPQ8c/cKsW57WMFr6RzLDAdqi0YElW0
	 WnXSqDcN25GA3jak4GXfdng4yECloCEND/l7vYVr259BMrDYOrgZl3etwhVmiGVNM9
	 FtAwrBS7a13NmDE8eNCzvUR0pvrwEMZ57G88WN8xzxMKDnredEJ0Q9/dVDHdKAyIOo
	 YR6Av/ddkidgzMqF55g1r5NSTVa/qEqUkURIycZI6j1D8dYMZl3Y+gZH2bIj4Wotz8
	 f9o0aKNxVeauqapb125hSyyoujAI4BSIBktT08wpI48C3LukGLvgEBXxwxMmEvp9m2
	 xugNIfzjwwgbg==
Date: Wed, 20 Aug 2025 15:16:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
Message-ID: <aKXKpE35H7KBzdBa@calendula>
References: <20250820123707.10671-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250820123707.10671-1-fw@strlen.de>

Hi Florian,

On Wed, Aug 20, 2025 at 02:37:07PM +0200, Florian Westphal wrote:
> recent patches to add a WARN() when replacing skb dst entry found an
> old bug:
> 
> WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
> WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
> WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
> [..]
> Call Trace:
>  nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
>  nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
>  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
>  ..
> 
> This is because blamed commit forgot about loopback packets.
> Such packets already have a dst_entry attached, even at PRE_ROUTING stage.
> 
> Instead of checking hook just check if the skb already has a route
> attached to it.

Quick question: does inconditional route lookup work for br_netfilter?

> Fixes: f53b9b0bdc59 ("netfilter: introduce support for reject at prerouting stage")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Sending this instead of a pull request. the only other two
>  candidates for -net are still under review.
> 
>  Let me know if you prefer a normal pull request even in this case.
>  Thanks!
> 
>  net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++----
>  net/ipv6/netfilter/nf_reject_ipv6.c | 5 ++---
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 87fd945a0d27..0d3cb2ba6fc8 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -247,8 +247,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  	if (!oth)
>  		return;
>  
> -	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
> -	    nf_reject_fill_skb_dst(oldskb) < 0)
> +	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
>  		return;
>  
>  	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
> @@ -321,8 +320,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
>  	if (iph->frag_off & htons(IP_OFFSET))
>  		return;
>  
> -	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
> -	    nf_reject_fill_skb_dst(skb_in) < 0)
> +	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
>  		return;
>  
>  	if (skb_csum_unnecessary(skb_in) ||
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index 838295fa32e3..cb2d38e80de9 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -293,7 +293,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  	fl6.fl6_sport = otcph->dest;
>  	fl6.fl6_dport = otcph->source;
>  
> -	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
> +	if (!skb_dst(oldskb)) {
>  		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
>  		if (!dst)
>  			return;
> @@ -397,8 +397,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>  	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
>  		skb_in->dev = net->loopback_dev;
>  
> -	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
> -	    nf_reject6_fill_skb_dst(skb_in) < 0)
> +	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
>  		return;
>  
>  	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
> -- 
> 2.49.1
> 
