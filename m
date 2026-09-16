Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0B4AA579;
	Wed, 16 Sep 2026 22:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596861; cv=none; b=auRQ03Rf2YNMPTHSNUt46GqMx8knw0aH/wyhIXZ7ezLOJ+29P3gIymPOZpL5+SRSbrrscwlfhj3FIUQSeIMAwo8p0PIxKZpvMnq9DQ6sBXyicbappZ+DeknhlDyWemLDOzeQRrNDY1zo8Uz/aSR4u9vjmin1edsi84IAEDCQvrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596861; c=relaxed/simple;
	bh=0/89w+hpUAdYNIscya1JnjUmmRI7m6iMzi9YBV/SRn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9dO+u0xnU98O1wAYyZEN3M/905OKEIRtVz2oeJoB2Ue0kL6uiq/FexEH0mdQOcpDkOe740lmgn0dDfbF12sitdUnRxvF5WlRlt6Nc+9clo4wovZYU4erAOpUc7/ykwP/hIDiH/sgiaSZpxbIjBSvAOf0w9upG3QhGQyNdj2vCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Kp5I1kMl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Kp5I1kMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789596847;
	bh=BzNAd2Y3QEoV2oEgaToE5/+BQyQxwNQ5zKB6OTq3AW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kp5I1kMlCazgcZkh7gSR9zqU1v592eV77IVVQQ3Ed2hAis0MBVBB6RO2m8lGudnS4
	 5X9Rm8acr/+RvIdtWt5Rxai7GZnf7DzzhVB1r3/tePjIBPkb9eF1byElW7zX6Qontf
	 +ARRKEhqxiwkljajKausdvA6DwztsdmW/aijlY1EQxxnOuCC1peV/oDpBTPI0bEMuB
	 hkwhdVPu856sVsFl9DclWvm/BieB070hEHEG1ponRx8YHabgQSaIQfydDLfyVRXur9
	 C2rI+QbkbOhSXZ7tQBNQa8Xi+JKLjkXroSQKQSoW+NJDoR3bur4BDSFBaPyTsRXYJ0
	 DDO4hikZ5m4eA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AB0656009B;
	Thu, 17 Sep 2026 00:14:07 +0200 (CEST)
Date: Thu, 17 Sep 2026 00:14:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 6/6] net: netfilter: nf_flow_table: unify
 tunnel push for IPv4 and IPv6
Message-ID: <aqsUrDjTeQBzW6gy@chamomile>
References: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
 <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-6-7c6ac1750725@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-6-7c6ac1750725@oss.qualcomm.com>

On Mon, Sep 07, 2026 at 09:33:41AM +0200, Lorenzo Bianconi wrote:
> Refactor nf_flow_tunnel_ipip_push() and nf_flow_tunnel_ip6ip6_push()
> into nf_flow_tunnel_ip_push() and nf_flow_tunnel_ip6_push(), keying the
> inner header handling off tuple->tun.inner_proto so both IP-in-IP and
> IPv6-in-IPv6 inner protocols are supported regardless of the outer
> address family. Replace nf_flow_tunnel_v4_push() and
> nf_flow_tunnel_v6_push() with a single nf_flow_tunnel_push() that
> dispatches on tuple->tun.encap_proto, and set skb->protocol explicitly
> after pushing the outer header.
> This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
> flowtable offload.
> Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
> enabled yet.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 129 ++++++++++++++++++++++++---------------
>  1 file changed, 81 insertions(+), 48 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 96dbdadba4e7..25875cc97bda 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -608,23 +608,41 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
>  	return 0;
>  }
>  
> -static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
> -				    struct flow_offload_tuple *tuple,
> -				    struct dst_entry *dst, __be32 *ip_daddr)
> +static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
> +				  struct flow_offload_tuple *tuple,
> +				  struct dst_entry *dst, __be32 *ip_daddr)
>  {
> -	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
> -	struct rtable *rt = dst_rtable(dst);
> -	u8 tos = iph->tos, ttl = iph->ttl;
> -	__be16 frag_off = iph->frag_off;
> -	u32 headroom = sizeof(*iph);
> +	__be16 frag_off = 0;
> +	struct iphdr *iph;
> +	u8 tos = 0, ttl;
> +	u32 headroom;
>  	int err;
>  
> +	switch (tuple->tun.inner_proto) {
> +	case IPPROTO_IPV6: {
> +		struct ipv6hdr *ip6h;
> +
> +		ip6h = (struct ipv6hdr *)skb_network_header(skb);
> +		tos = ipv6_get_dsfield(ip6h);
> +		ttl = ip6h->hop_limit;
> +		frag_off = htons(IP_DF);
> +		break;
> +	}
> +	default:

Please add an explicit case to check for IPv4 here, ie. no default:

> +		iph = (struct iphdr *)skb_network_header(skb);
> +		frag_off = iph->frag_off;
> +		tos = iph->tos;
> +		ttl = iph->ttl;
> +		break;
> +	}
> +
>  	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
>  	if (err)
>  		return err;
>  
> -	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
> -	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
> +	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
> +	headroom = sizeof(*iph) + LL_RESERVED_SPACE(dst->dev) +
> +		   dst->header_len;
>  	err = skb_cow_head(skb, headroom);
>  	if (err)
>  		return err;
> @@ -635,11 +653,12 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
>  	/* Push down and install the IP header. */
>  	skb_push(skb, sizeof(*iph));
>  	skb_reset_network_header(skb);
> +	skb->protocol = htons(ETH_P_IP);
>  
>  	iph = ip_hdr(skb);
>  	iph->version	= 4;
>  	iph->ihl	= sizeof(*iph) >> 2;
> -	iph->frag_off	= ip_mtu_locked(&rt->dst) ? 0 : frag_off;
> +	iph->frag_off	= ip_mtu_locked(dst) ? 0 : frag_off;
>  	iph->protocol	= tuple->tun.inner_proto;
>  	iph->tos	= tos;
>  	iph->daddr	= tuple->tun.src_v4.s_addr;
> @@ -654,57 +673,61 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
>  	return 0;
>  }
>  
> -static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
> -				  struct flow_offload_tuple *tuple,
> -				  struct dst_entry *dst,  __be32 *ip_daddr)
> +static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
> +				   struct flow_offload_tuple *tuple,
> +				   struct dst_entry *dst,
> +				   struct in6_addr **ip6_daddr)
>  {
> -	if (tuple->tun_num)
> -		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
> -
> -	return 0;
> -}
> -
> -static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
> -				      struct flow_offload_tuple *tuple,
> -				      struct dst_entry *dst,
> -				      struct in6_addr **ip6_daddr)
> -{
> -	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
> -	__u8 dsfield = ipv6_get_dsfield(ip6h);
> -	struct rtable *rt = dst_rtable(dst);
>  	struct flowi6 fl6 = {
>  		.daddr = tuple->tun.src_v6,
>  		.saddr = tuple->tun.dst_v6,
> -		.flowi6_proto = IPPROTO_IPV6,
> +		.flowi6_proto = tuple->tun.inner_proto,
>  	};
> -	u8 hop_limit = ip6h->hop_limit;
> +	u8 hop_limit, dsfield;
> +	struct ipv6hdr *ip6h;
>  	int err, mtu;
>  	u32 headroom;
>  
> +	switch (tuple->tun.inner_proto) {
> +	case IPPROTO_IPIP: {
> +		struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
> +
> +		dsfield = ipv4_get_dsfield(iph);
> +		hop_limit = iph->ttl;
> +		break;
> +	}
> +	default:

Same here.

> +		ip6h = (struct ipv6hdr *)skb_network_header(skb);
> +		dsfield = ipv6_get_dsfield(ip6h);
> +		hop_limit = ip6h->hop_limit;
> +		break;
> +	}
> +
>  	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
>  	if (err)
>  		return err;
>  
> -	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
> -	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
> -		   rt->dst.header_len;
> +	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
> +	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(dst->dev) +
> +		   dst->header_len;
>  	err = skb_cow_head(skb, headroom);
>  	if (err)
>  		return err;
>  
>  	skb_scrub_packet(skb, true);
> -	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
> +	mtu = dst_mtu(dst) - sizeof(*ip6h);
>  	mtu = max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
>  
>  	skb_push(skb, sizeof(*ip6h));
>  	skb_reset_network_header(skb);
> +	skb->protocol = htons(ETH_P_IPV6);
>  
>  	ip6h = ipv6_hdr(skb);
>  	ip6_flow_hdr(ip6h, dsfield,
>  		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
>  	ip6h->hop_limit = hop_limit;
> -	ip6h->nexthdr = IPPROTO_IPV6;
> +	ip6h->nexthdr = tuple->tun.inner_proto;
>  	ip6h->daddr = tuple->tun.src_v6;
>  	ip6h->saddr = tuple->tun.dst_v6;
>  	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
> @@ -715,15 +738,20 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  	return 0;
>  }
>  
> -static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
> -				  struct flow_offload_tuple *tuple,
> -				  struct dst_entry *dst,
> -				  struct in6_addr **ip6_daddr)
> +static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
> +			       struct flow_offload_tuple *tuple,
> +			       struct dst_entry *dst, __be32 *ip_daddr,
> +			       struct in6_addr **ip6_daddr)
>  {
> -	if (tuple->tun_num)
> -		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
> -
> -	return 0;
> +	switch (tuple->tun.encap_proto) {
> +	case AF_INET:
> +		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_daddr);
> +	case AF_INET6:
> +		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst,
> +					       ip6_daddr);
> +	default:
> +		return 0;
> +	}
>  }
>  
>  static int nf_flow_encap_push(struct sk_buff *skb,
> @@ -830,6 +858,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
>  	struct flow_offload_tuple *other_tuple;
>  	enum flow_offload_tuple_dir dir;
>  	struct nf_flow_xmit xmit = {};
> +	struct in6_addr *ip6_daddr;
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rtable *rt;
> @@ -847,9 +876,11 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	other_tuple = &flow->tuplehash[!dir].tuple;
>  	ip_daddr = other_tuple->src_v4.s_addr;
> +	ip6_daddr = &other_tuple->src_v6;
>  
> -	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
> -				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
> +	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
> +				tuplehash->tuple.dst_cache,
> +				&ip_daddr, &ip6_daddr) < 0)

See comment below regarding this.

>  		return NF_DROP;
>  
>  	switch (tuplehash->tuple.xmit_type) {
> @@ -1158,6 +1189,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
>  	struct flow_offload *flow;
>  	struct neighbour *neigh;
>  	struct rt6_info *rt;
> +	__be32 ip_daddr;
>  
>  	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
>  		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
> @@ -1170,11 +1202,12 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
>  	dir = tuplehash->tuple.dir;
>  	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>  	other_tuple = &flow->tuplehash[!dir].tuple;
> +	ip_daddr = other_tuple->src_v4.s_addr;
>  	ip6_daddr = &other_tuple->src_v6;

IIRC this is pointing to the same address, it is a double fetch of the
same pointer? See below:

>  
> -	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
> -				   tuplehash->tuple.dst_cache,
> -				   &ip6_daddr) < 0)
> +	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
> +				tuplehash->tuple.dst_cache,
> +				&ip_daddr, &ip6_daddr) < 0)

... time to use union nf_inet_addr here instead of these two ip_daddr
and ip6_daddr?

>  		return NF_DROP;
>  
>  	switch (tuplehash->tuple.xmit_type) {
> 
> -- 
> 2.55.0
> 
> 
