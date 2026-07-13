Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE340BCD2;
	Mon, 13 Jul 2026 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946814; cv=none; b=qIKXZA4kFP+6xlnFJEKzeKRwQ8y4KT+dlC++yv6kzpiY5TTZs2UG7r5zPvPZFYxoWVqU3ainBBRTLaEFipUseDul8jL/3TsxjgZ5tz7rLajpMJAaFuXmW6J6v3oD+g7TMGZALKK6gE7N54eer9WdK6/UkzSEADnAuekQ3HWxxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946814; c=relaxed/simple;
	bh=DKaTG7dbkd3ZuyFPOYbwkL8Oyl39PjypDWXeB1qygI8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RdifnAaLOZKkG86zN36vITs7G3i98H9uLU90JzT3irdNzcQLtLZ0N16KqjVG+gHF6ujGLLKdOwMw6J4CO7Lq52gaTvuxWTsrfVUIkOXyE5ojRel+D9WPASpl3z8rFGWWOWLx6etdFp9oBk8iZo27FC7wy3Y39wCw5E1KFqsM+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAS+C+UP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAS+C+UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A061F00A3A;
	Mon, 13 Jul 2026 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783946809;
	bh=xebD0VVBwKZwe6kIEDuIaNaMRyWSz1pAGSy5/btEbuw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eAS+C+UPPugtdtzdsQehdZFXck+LZsEoToPlDJ4FqPLJ12cfhqsxgXyOiGDXlXV+/
	 +fEFggIiY+L/j2n7Pfa957cpVdtTefIIMdszZMac0fVFkns23RzzZpyEj9EiBy+zxn
	 yOwQIMaAG8rQEBAf0qodQIeApNkTvnKezq9gB1zgx0V1vr+dz6X27obVFxJHPX3oqE
	 hrn25fs+JuxJMQWfUyXRqWE4cewpIwDK+zreIu0RqpIk2uku9g8sYfLYwQiAvM+hxw
	 ck9jkBd8T00NjuzfuYUh6Yy34+WxZ5X2EGBlRW5ATCcma5sIq/+UoWkRXNNtD+rcNO
	 xx2X964CWxCUA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 13 Jul 2026 14:46:20 +0200
Subject: [PATCH nf-next v6 3/6] net: netfilter: add IPv4 over IPv6 tunnel
 flowtable acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-flowtable-sw-accel-ip6ip-v6-3-33f0155fc658@kernel.org>
References: <20260713-b4-flowtable-sw-accel-ip6ip-v6-0-33f0155fc658@kernel.org>
In-Reply-To: <20260713-b4-flowtable-sw-accel-ip6ip-v6-0-33f0155fc658@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

Introduce sw flowtable acceleration for the TX/RX paths of
IPv4 over IPv6 tunnels, relying on the netfilter flowtable
infrastructure.
The feature can be tested with a forwarding scenario between two
NICs (eth0 and eth1), where an IPv4 over IPv6 tunnel is used to
reach a remote site via eth1 as the underlay device:

    ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (2001:db8:2::2)

[IP configuration]

6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 scope global eth0
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:2::1/64 scope global nodad
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr ce9c:2940:7dcc::
    inet 192.168.100.1/24 scope global tun0
       valid_lft forever preferred_lft forever

$ ip route show
default via 192.168.100.2 dev tun0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1

$ ip -6 route show
2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium

$ nft list ruleset
table inet filter {
    flowtable ft {
        hook ingress priority filter
        devices = { eth0, eth1 }
    }

    chain forward {
        type filter hook forward priority filter; policy accept;
        meta l4proto { tcp, udp } flow add @ft
    }
}

When reproducing this scenario using veth interfaces, the following
results were observed:

- TCP stream received from IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~126 Gbps
  - net-next + IP6IP flowtable support: ~138 Gbps

- TCP stream transmitted to IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~127 Gbps
  - net-next + IP6IP flowtable support: ~140 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_core.c |  19 +++-
 net/netfilter/nf_flow_table_ip.c   | 190 +++++++++++++++++++++++++------------
 net/netfilter/nf_flow_table_path.c |  10 +-
 3 files changed, 147 insertions(+), 72 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2a829b5e8240..56e58926fd31 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -76,9 +76,14 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
+static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple,
+				   u8 tun_encap_proto)
 {
-	if (flow_tuple->l3proto == NFPROTO_IPV6)
+	bool dst_v6;
+
+	dst_v6 = tun_encap_proto ? tun_encap_proto == NFPROTO_IPV6
+				 : flow_tuple->l3proto == NFPROTO_IPV6;
+	if (dst_v6)
 		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
 
 	return 0;
@@ -99,10 +104,12 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
+	u8 l3proto, encap_proto = route->tuple[!dir].in.tun.encap_proto;
 	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
 	int i, j = 0;
 
-	switch (flow_tuple->l3proto) {
+	l3proto = encap_proto ? encap_proto : flow_tuple->l3proto;
+	switch (l3proto) {
 	case NFPROTO_IPV4:
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
@@ -130,7 +137,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		if (flow_tuple->tun_num) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
-				flow_offload_dst_cookie(flow_tuple);
+				flow_offload_dst_cookie(flow_tuple,
+							encap_proto);
 		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
@@ -144,7 +152,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
-		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
+		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple,
+								 encap_proto);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index f29c69c362f5..9432aa140657 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -191,27 +191,27 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 		break;
 	}
 
-	switch (inner_proto) {
-	case htons(ETH_P_IP):
-		iph = (struct iphdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.proto == IPPROTO_IPIP) {
+	if (ctx->tun.proto == IPPROTO_IPIP || ctx->tun.proto == IPPROTO_IPV6) {
+		switch (inner_proto) {
+		case htons(ETH_P_IP):
+			iph = (struct iphdr *)(skb_network_header(skb) +
+					       offset);
 			tuple->tun.dst_v4.s_addr = iph->daddr;
 			tuple->tun.src_v4.s_addr = iph->saddr;
-			tuple->tun.l3_proto = IPPROTO_IPIP;
+			tuple->tun.l3_proto = ctx->tun.proto;
 			tuple->tun.encap_proto = AF_INET;
-		}
-		break;
-	case htons(ETH_P_IPV6):
-		ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-		if (ctx->tun.proto == IPPROTO_IPV6) {
+			break;
+		case htons(ETH_P_IPV6):
+			ip6h = (struct ipv6hdr *)(skb_network_header(skb) +
+						  offset);
 			tuple->tun.dst_v6 = ip6h->daddr;
 			tuple->tun.src_v6 = ip6h->saddr;
-			tuple->tun.l3_proto = IPPROTO_IPV6;
+			tuple->tun.l3_proto = ctx->tun.proto;
 			tuple->tun.encap_proto = AF_INET6;
+			break;
+		default:
+			break;
 		}
-		break;
-	default:
-		break;
 	}
 }
 
@@ -362,7 +362,7 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (ipv6_ext_hdr(ip6h->nexthdr))
 		return false;
 
-	if (ip6h->nexthdr == IPPROTO_IPV6) {
+	if (ip6h->nexthdr == IPPROTO_IPIP || ip6h->nexthdr == IPPROTO_IPV6) {
 		ctx->tun.proto = ip6h->nexthdr;
 		ctx->tun.hdr_size = sizeof(*ip6h);
 		ctx->offset += ctx->tun.hdr_size;
@@ -383,6 +383,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+	if (ctx->tun.proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
@@ -488,8 +492,16 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num)
+	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
+	case AF_INET:
 		mtu -= sizeof(*iph);
+		break;
+	case AF_INET6:
+		mtu -= sizeof(struct ipv6hdr);
+		break;
+	default:
+		break;
+	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
@@ -616,6 +628,7 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	/* Push down and install the IP header. */
 	skb_push(skb, sizeof(*iph));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IP);
 
 	iph = ip_hdr(skb);
 	iph->version	= 4;
@@ -635,57 +648,57 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,  __be32 *ip_daddr)
+static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
+				   struct flow_offload_tuple *tuple,
+				   struct dst_entry *dst,
+				   struct in6_addr **ip6_daddr)
 {
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
-
-	return 0;
-}
-
-static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
-				      struct flow_offload_tuple *tuple,
-				      struct dst_entry *dst,
-				      struct in6_addr **ip6_daddr)
-{
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	__u8 dsfield = ipv6_get_dsfield(ip6h);
-	struct rtable *rt = dst_rtable(dst);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
-		.flowi6_proto = IPPROTO_IPV6,
+		.flowi6_proto = tuple->tun.l3_proto,
 	};
-	u8 hop_limit = ip6h->hop_limit;
+	u8 hop_limit, dsfield;
+	struct ipv6hdr *ip6h;
 	int err, mtu;
 	u32 headroom;
 
+	if (tuple->tun.l3_proto == IPPROTO_IPIP) {
+		struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+		dsfield = ipv4_get_dsfield(iph);
+		hop_limit = iph->ttl;
+	} else {
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		dsfield = ipv6_get_dsfield(ip6h);
+		hop_limit = ip6h->hop_limit;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
-	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
-		   rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.l3_proto);
+	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(dst->dev) +
+		   dst->header_len;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
 
 	skb_scrub_packet(skb, true);
-	mtu = dst_mtu(&rt->dst) - sizeof(*ip6h);
+	mtu = dst_mtu(dst) - sizeof(*ip6h);
 	mtu = max(mtu, IPV6_MIN_MTU);
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IPV6);
 
 	ip6h = ipv6_hdr(skb);
 	ip6_flow_hdr(ip6h, dsfield,
 		     ip6_make_flowlabel(net, skb, fl6.flowlabel, true, &fl6));
 	ip6h->hop_limit = hop_limit;
-	ip6h->nexthdr = IPPROTO_IPV6;
+	ip6h->nexthdr = tuple->tun.l3_proto;
 	ip6h->daddr = tuple->tun.src_v6;
 	ip6h->saddr = tuple->tun.dst_v6;
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
@@ -696,15 +709,21 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,
-				  struct in6_addr **ip6_daddr)
+static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
+			       struct flow_offload_tuple *tuple,
+			       struct dst_entry *dst, __be32 *ip_daddr,
+			       struct in6_addr **ip6_daddr)
 {
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
-
-	return 0;
+	switch (tuple->tun.encap_proto) {
+	case AF_INET:
+		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst,
+						ip_daddr);
+	case AF_INET6:
+		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst,
+					       ip6_daddr);
+	default:
+		return 0;
+	}
 }
 
 static int nf_flow_encap_push(struct sk_buff *skb,
@@ -816,6 +835,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		.in	= state->in,
 	};
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
@@ -844,27 +864,45 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
+	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache,
+				&ip_daddr, &ip6_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rtable(tuplehash->tuple.dst_cache);
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		struct dst_entry *dst;
+
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
+		if (other_tuple->tun.encap_proto ?
+		    other_tuple->tun.encap_proto == AF_INET6 :
+		    ctx.tun.proto == IPPROTO_IPV6) {
+			struct rt6_info *rt6;
+
+			rt6 = dst_rt6_info(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw6(rt6->dst.dev,
+					     rt6_nexthop(rt6, ip6_daddr));
+			dst = &rt6->dst;
+		} else {
+			rt = dst_rtable(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw4(rt->dst.dev,
+					     rt_nexthop(rt, ip_daddr));
+			dst = &rt->dst;
+		}
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set_noref(skb, dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
@@ -1114,8 +1152,12 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IPV6)))
 		return NULL;
 
-	if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
+	if (ctx->tun.proto == IPPROTO_IPIP) {
+		if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
+			return NULL;
+	} else if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0) {
 		return NULL;
+	}
 
 	return flow_offload_lookup(flow_table, &tuple);
 }
@@ -1136,13 +1178,18 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
+	__be32 ip_daddr;
 	int ret;
 
 	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb);
+	if (ctx.tun.proto == IPPROTO_IPIP)
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	else
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -1159,29 +1206,46 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip_daddr = other_tuple->src_v4.s_addr;
 	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache,
-				   &ip6_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache,
+				&ip_daddr, &ip6_daddr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH:
-		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		struct dst_entry *dst;
+
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
+		if (other_tuple->tun.encap_proto ?
+		    other_tuple->tun.encap_proto == AF_INET :
+		    ctx.tun.proto == IPPROTO_IPIP) {
+			struct rtable *rt4;
+
+			rt4 = dst_rtable(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw4(rt4->dst.dev,
+					     rt_nexthop(rt4, ip_daddr));
+			dst = &rt4->dst;
+		} else {
+			rt = dst_rt6_info(tuplehash->tuple.dst_cache);
+			neigh = ip_neigh_gw6(rt->dst.dev,
+					     rt6_nexthop(rt, ip6_daddr));
+			dst = &rt->dst;
+		}
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set_noref(skb, dst);
 		break;
+	}
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index caaf48c5fd2a..5e84b7f18a26 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -216,12 +216,13 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 	struct dst_entry *tun_dst = NULL;
 	struct flowi fl = {};
 
-	switch (nft_pf(pkt)) {
+	switch (tun->encap_proto) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = tun->dst_v4.s_addr;
 		fl.u.ip4.saddr = tun->src_v4.s_addr;
 		fl.u.ip4.flowi4_iif = nft_in(pkt)->ifindex;
-		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
+		if (nft_pf(pkt) == NFPROTO_IPV4)
+			fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
 		fl.u.ip4.flowi4_mark = pkt->skb->mark;
 		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 		break;
@@ -229,13 +230,14 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 		fl.u.ip6.daddr = tun->dst_v6;
 		fl.u.ip6.saddr = tun->src_v6;
 		fl.u.ip6.flowi6_iif = nft_in(pkt)->ifindex;
-		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		if (nft_pf(pkt) == NFPROTO_IPV6)
+			fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
 		fl.u.ip6.flowi6_mark = pkt->skb->mark;
 		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 		break;
 	}
 
-	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
+	nf_route(nft_net(pkt), &tun_dst, &fl, false, tun->encap_proto);
 	if (!tun_dst)
 		return -ENOENT;
 

-- 
2.55.0

