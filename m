Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792734828;
	b=bALM3J4v8KcnrA1xSLcFq9Fu0t9BUu62IWCy9q7RC8pcRoLeKwBrKv7UTHTxmZ78w2IY
	 2InlOYktmNVYSUmCwMut7hJp+sY6o3WLc04b+nHf4E3W3djzf4rrY/HUPTqlt4NHtPAFu
	 95ujzWZzVZIbxq+9AyHPIdVo00yDDbko/zuZHjqSPPGTIjaqN1J7VzoQVQRBee9R/XQfv
	 tnCz84K6Mj6uwRWrlPnPloJjECq3sJFtkwjWKZ0pgE56I1YMc1XlM0kSFWZ2y6sImriL/
	 /C3yB/ieqT5IHW2ACVYOBPtJzXaIwkNX1b1/h1dnC1kpy+LO6XG5nkRAzB3rHQHg26w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792734828;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=DI4NJjCxNCbqet7/1M1WL8k+lqaJKwsiSrHPjX1IoYQ=;
	b=Lt7t+Bu1Zcl6wpTSkdirT6kyzRpZTZ3t7xsTyqDzXyQomy8RFDZL3G7P/0nHdec0gcF0
	 BtnXliZ061kJaW8yDKS12ZB+QphBjdixIZjOu3pUCFZz9OKKaZ10yhmj71VJSXj0nfN+j
	 wdJBqhLuPNCTLbcybGSTFHaTrglm8its36se2gHGULE0ZEjFHCfq9wfuSWxc7+VtD6J3Z
	 2r0KamrddJJM8P8kStPwKioODod162YLPUEuzt779dIbfyZTrVonD1xZj/IRm1HF+BYtT
	 6RPMjjoM7YinuGA1kn1riewOlVCMoeFE6SD6k+as+zbUpu11r7jZ30WHBFJuIPEgncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=Th8A8gmd;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92257606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 05:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92257606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=Th8A8gmd
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id BE82C225BB;
	Fri, 23 Oct 2026 08:53:36 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=DI4NJjCxNCbqet7/1M1WL8k+lqaJKwsiSrHPjX1IoYQ=; b=Th8A8gmdaXa7
	vlQT9+wJfLdBHwxAkgQftWER+yQtIto69PQbNp7vqZs8kS79z2E2Wx1adVHCpuA6
	hP4rya0+4A/zF9nhr2WQRAcHkaGkM9gcgg0onlhzKvjzclHfi/ad7DxMMpMRYujj
	BjTMuiBI91LZFrAi+39OGjlYaKFXMjUyQa8WdkoxsBG+O9CVhDZiJJVHkQ/sU8vE
	/NgPiny2Al7CLbKqELBqtD2FewFLINStS4c8s1byFiJqFwMElL5xpjJE9o6jdNDI
	Lwmc2RyAsY6M4CUkIIHTG5hMYGYKmSUk+tjYRcuoY8GWgE1GbHoBcY3n3fwglIgz
	h8RITOSqYB/Wfp7Ulgp7LzIoccZoxeLJq+aDI4knNF2FILzU6zPsBfR+fgMrc24f
	G70YXKCnNBXZ+fhhN8C+Lsyimx0e5KpLlP0LrU8s3+Qh1C556/DpZD5VJltnHiyC
	iXsiZ2K1du3crZjrzqsXiYPh7YdwRuR44nu9dtGCkeYs07M+nBJgpivZ3Depulko
	kb1LnNw9HTHMVGZTg0nBl7yab8fS9OjHW4YM8BR+ugR4S1zWSWMgXy1MNrakWSYi
	Z34/orp9rdJzSG8wg0GG0xP+2ff7s65LVEcnxQqlQR7VfplhZpd2iL4Paru27Gy7
	UQjwWnl4DZFecJS0qbCaTl12QrhCZwE=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 23 Oct 2026 08:53:36 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 6E3E661BDA;
	Fri, 23 Oct 2026 08:53:37 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 69N5rTR0021954;
	Fri, 23 Oct 2026 08:53:29 +0300
Date: Fri, 23 Oct 2026 08:53:29 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ipvs: avoid passing skb->sk to
 route_me_harder
In-Reply-To: <20261015131116.1314-1-fw@strlen.de>
Message-ID: <3be1f747-d1fd-7c4b-8077-a3436456dd44@ssi.bg>
References: <20261015131116.1314-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Thu, 15 Oct 2026, Florian Westphal wrote:

> skb->sk refers to the original socket and in most cases state->sk and
> skb->sk are the same address.
> 
> However, when a packet moves through a tunnel, then skb->sk can be the
> wrong socket type (e.g. ipv4 instead of ipv6).
> 
> Pass the state pointer to IPVS output and ICMP-response helpers in place
> of the bare hook number.  This fixes an alleged NULL deref when handling
> ipv4 -> ipv6 encap, ip6_route_me_harder calls into ip6 routing code
> which assume sk is an ipv6 socket.
> 
> Link: https://sashiko.dev/#/patchset/20261011215953.1334630-1-pablo%40netfilter.org
> Assisted-by: LLM
> Signed-off-by: Florian Westphal <fw@strlen.de>

	Patch looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	I have additional patch to deal with passing sk for
IPVS tunneling, will post it when -next opens again.

> ---
>  Better solution than
>  https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261001120625.29659-3-fw@strlen.de/
> 
>  On could argue that we should still do stronger checks in
>  route_me_harder APIs too (but then it should stricly check that its ipv4
>  resp. ipv6 sk, not 'inet').  It would also be good to review other
>  skb->sk use in netfilter/ipvs, there might be other cases where we
>  potentially pass AF_PACKET (or whatever) sk down into ip/ip6 output engine.
> 
>  net/netfilter/ipvs/ip_vs_core.c | 36 +++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index ba0957798bad..dd741df38fec 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -895,24 +895,25 @@ static inline int ip_vs_gather_frags(struct netns_ipvs *ipvs,
>  }
>  
>  static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
> -				 struct sk_buff *skb, unsigned int hooknum)
> +				 struct sk_buff *skb,
> +				 const struct nf_hook_state *state)
>  {
>  	if (!sysctl_snat_reroute(ipvs))
>  		return 0;
>  	/* Reroute replies only to remote clients (FORWARD and LOCAL_OUT) */
> -	if (NF_INET_LOCAL_IN == hooknum)
> +	if (NF_INET_LOCAL_IN == state->hook)
>  		return 0;
>  #ifdef CONFIG_IP_VS_IPV6
>  	if (af == AF_INET6) {
>  		struct dst_entry *dst = skb_dst(skb);
>  
>  		if (dst->dev && !(dst->dev->flags & IFF_LOOPBACK) &&
> -		    ip6_route_me_harder(ipvs->net, skb->sk, skb) != 0)
> +		    ip6_route_me_harder(ipvs->net, state->sk, skb) != 0)
>  			return 1;
>  	} else
>  #endif
>  		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL) &&
> -		    ip_route_me_harder(ipvs->net, skb->sk, skb, RTN_LOCAL) != 0)
> +		    ip_route_me_harder(ipvs->net, state->sk, skb, RTN_LOCAL) != 0)
>  			return 1;
>  
>  	return 0;
> @@ -1029,7 +1030,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
>  				struct ip_vs_conn *cp,
>  				struct ip_vs_protocol *pp,
>  				struct ip_vs_iphdr *ciph,
> -				unsigned int toff, unsigned int hooknum)
> +				unsigned int toff,
> +				const struct nf_hook_state *state)
>  {
>  	int iproto = af == AF_INET6 ? IPPROTO_ICMPV6 : IPPROTO_ICMP;
>  	unsigned int verdict = NF_DROP;
> @@ -1063,7 +1065,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
>  		if (!ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph))
>  			goto out;
>  
> -	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
> +	if (ip_vs_route_me_harder(cp->ipvs, af, skb, state))
>  		goto out;
>  
>  after_nat:
> @@ -1089,7 +1091,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
>   *	Currently handles error types - unreachable, quench, ttl exceeded.
>   */
>  static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
> -			  int *related, unsigned int hooknum,
> +			  int *related, const struct nf_hook_state *state,
>  			  struct ip_vs_iphdr *ipvsh)
>  {
>  	struct icmphdr	_icmph, *ic;
> @@ -1104,7 +1106,7 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  
>  	/* reassemble IP fragments */
>  	if (ip_is_fragment(ip_hdr(skb))) {
> -		if (ip_vs_gather_frags(ipvs, skb, ip_vs_defrag_user(hooknum)))
> +		if (ip_vs_gather_frags(ipvs, skb, ip_vs_defrag_user(state->hook)))
>  			return NF_STOLEN;
>  		if (!ip_vs_fill_iph_skb(AF_INET, skb, false, ipvsh))
>  			return NF_ACCEPT;
> @@ -1162,12 +1164,12 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  
>  	snet.ip = ipvsh->saddr.ip;
>  	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph,
> -				    ipvsh->len, hooknum);
> +				    ipvsh->len, state);
>  }
>  
>  #ifdef CONFIG_IP_VS_IPV6
>  static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
> -			     int *related,  unsigned int hooknum,
> +			     int *related, const struct nf_hook_state *state,
>  			     struct ip_vs_iphdr *ipvsh)
>  {
>  	struct icmp6hdr	_icmph, *ic;
> @@ -1222,7 +1224,7 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  
>  	snet.in6 = ciph.saddr.in6;
>  	return handle_response_icmp(AF_INET6, skb, &snet, cp, pp, &ciph,
> -				    ipvsh->len, hooknum);
> +				    ipvsh->len, state);
>  }
>  #endif
>  
> @@ -1437,7 +1439,7 @@ static struct ip_vs_conn *__ip_vs_rs_conn_out(unsigned int hooknum,
>  static unsigned int
>  handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
>  		struct ip_vs_conn *cp, struct ip_vs_iphdr *iph,
> -		unsigned int hooknum)
> +		const struct nf_hook_state *state)
>  {
>  	struct ip_vs_protocol *pp = pd->pp;
>  
> @@ -1479,7 +1481,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
>  	 * if it came from this machine itself.  So re-compute
>  	 * the routing information.
>  	 */
> -	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
> +	if (ip_vs_route_me_harder(cp->ipvs, af, skb, state))
>  		goto drop;
>  
>  	IP_VS_DBG_PKT(10, af, pp, skb, iph->off, "After SNAT");
> @@ -1539,7 +1541,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
>  		if (unlikely(iph.protocol == IPPROTO_ICMPV6)) {
>  			int related;
>  			int verdict = ip_vs_out_icmp_v6(ipvs, skb, &related,
> -							hooknum, &iph);
> +							state, &iph);
>  
>  			if (related)
>  				return verdict;
> @@ -1549,7 +1551,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
>  		if (unlikely(iph.protocol == IPPROTO_ICMP)) {
>  			int related;
>  			int verdict = ip_vs_out_icmp(ipvs, skb, &related,
> -						     hooknum, &iph);
> +						     state, &iph);
>  
>  			if (related)
>  				return verdict;
> @@ -1579,7 +1581,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
>  			     ipvs, af, skb, &iph);
>  
>  	if (likely(cp))
> -		return handle_response(af, skb, pd, cp, &iph, hooknum);
> +		return handle_response(af, skb, pd, cp, &iph, state);
>  
>  	/* Check for real-server-started requests */
>  	if (atomic_read(&ipvs->conn_out_counter[ip_vs_af_index(af)])) {
> @@ -1592,7 +1594,7 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
>  			cp = __ip_vs_rs_conn_out(hooknum, ipvs, af, skb, &iph);
>  			if (likely(cp))
>  				return handle_response(af, skb, pd, cp, &iph,
> -						       hooknum);
> +						       state);
>  		}
>  	}
>  
> -- 
> 2.55.0

Regards

--
Julian Anastasov <ja@ssi.bg>

