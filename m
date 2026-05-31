Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574123546D0;
	Sun, 31 May 2026 15:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780242683; cv=none; b=l4GZ6htMNU6JvaahOdgYHTwxHejqc2sDAP//YDoeagOESU2AE6xl/lDlmzSUE21VbcisPhEvi6Q3GAsZAsFxN1n2cFSTWcYRThUPCS2QkGX+WDhQJQM9E5AQe0k9P74biFoEnsUeAZTmWg2gW1gufNBYo2rE+lbMmzVD+Iev0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780242683; c=relaxed/simple;
	bh=jpmue2uXa9jQlz+i0YFOF+j/WaV6DMapMduGSSwjJ+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mR1DLxrCXsf/8tvbQtsEBvA4PYaQsK10C36A10Is2fA6z4Zyrrt6ZVqf+XrJUucUWWxBUwB+6Ntpiz7224KPZsnIwsp2U5xuwzf4cmhqQll4akh4NVeGb6DBEplQs5oKzrDRp8p32WBL21OHNJWt6ael9LZ+GUT0aDt6bjR+Z04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VccZgqsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VccZgqsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5FB1F00893;
	Sun, 31 May 2026 15:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780242682;
	bh=vE7tdrNUJ9Q96Po+86piw36K0VaJ+Lk6SQdiScyWO80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VccZgqsIytX/i3XB6lF15840tT1ar/C2hGiqSRlVgihO6rWmiVUbzFaFKS7jBwFad
	 8iCWlYeJGzefnt+yT1cTIj9V1fzNTbmw9tpVl5caDyAsSLMCtpICvFdJRzC7IIcbOy
	 OiJb4ZcxBLwNdQFvaVQ0d1VKbPF+Elz6N6KTf+Vj0l0XJhPPskA7mJ7fjxxIpVnwAD
	 WCeZ/d1tuXquLLdnLMNWuDrwLZ+cfhftPEhalpoY1NQPAXp7LGYaCqyNcVezaMYWbM
	 W4VVsku3JKui9LEwL3fRzEOhhRCOLDXhbesRzxxF+y0Y5MZtf4lA82LbMmrsKTcYAj
	 PHzJGg1eCc75A==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 31 May 2026 17:50:35 +0200
Subject: [PATCH nf-next v3 3/6] net: netfilter: Add IPv4 over IPv6 tunnel
 flowtable acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-b4-flowtable-sw-accel-ip6ip-v3-3-56a2826f3279@kernel.org>
References: <20260531-b4-flowtable-sw-accel-ip6ip-v3-0-56a2826f3279@kernel.org>
In-Reply-To: <20260531-b4-flowtable-sw-accel-ip6ip-v3-0-56a2826f3279@kernel.org>
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
 net/netfilter/nf_flow_table_core.c |  14 +++-
 net/netfilter/nf_flow_table_ip.c   | 166 +++++++++++++++++++++++++++----------
 net/netfilter/nf_flow_table_path.c |   6 +-
 3 files changed, 133 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..5580d28d4bcb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -76,9 +76,11 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
-static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
+static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple,
+				   u8 tun_encap_proto)
 {
-	if (flow_tuple->l3proto == NFPROTO_IPV6)
+	if (flow_tuple->l3proto == NFPROTO_IPV6 ||
+	    tun_encap_proto == NFPROTO_IPV6)
 		return rt6_get_cookie(dst_rt6_info(flow_tuple->dst_cache));
 
 	return 0;
@@ -135,10 +137,14 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
-	case FLOW_OFFLOAD_XMIT_NEIGH:
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		u8 encap_proto = route->tuple[!dir].in.tun.encap_proto;
+
 		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
-		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
+		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple,
+								 encap_proto);
+		}
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 49e9b0308763..a2c62f6455c8 100644
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
 
@@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (hdrlen < 0)
 		return false;
 
-	if (nexthdr == IPPROTO_IPV6) {
+	if (nexthdr == IPPROTO_IPIP || nexthdr == IPPROTO_IPV6) {
 		ctx->tun.hdr_size = hdrlen;
-		ctx->tun.proto = IPPROTO_IPV6;
+		ctx->tun.proto = nexthdr;
 	}
 	ctx->offset += ctx->tun.hdr_size;
 
@@ -388,6 +388,10 @@ static void nf_flow_ip_tunnel_pop(struct nf_flowtable_ctx *ctx,
 
 	skb_pull(skb, ctx->tun.hdr_size);
 	skb_reset_network_header(skb);
+	if (ctx->tun.proto == IPPROTO_IPIP)
+		skb->protocol = htons(ETH_P_IP);
+	else
+		skb->protocol = htons(ETH_P_IPV6);
 }
 
 static bool nf_flow_skb_encap_protocol(struct nf_flowtable_ctx *ctx,
@@ -482,7 +486,7 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct nf_flowtable *flow_table,
 				   struct flow_offload_tuple_rhash *tuplehash,
-				   struct sk_buff *skb)
+				   struct sk_buff *skb, int encap_limit)
 {
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -493,8 +497,18 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num)
+	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
+	case AF_INET:
 		mtu -= sizeof(*iph);
+		break;
+	case AF_INET6:
+		mtu -= sizeof(struct ipv6hdr);
+		if (encap_limit > 0)
+			mtu -= 8; /* encap limit option */
+		break;
+	default:
+		break;
+	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
@@ -640,16 +654,6 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  __be32 *ip_daddr)
-{
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
-
-	return 0;
-}
-
 struct ipv6_tel_txoption {
 	struct ipv6_txoptions ops;
 	__u8 dst_opt[8];
@@ -660,18 +664,29 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 				      struct in6_addr **ip6_daddr,
 				      int encap_limit)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
 	struct rtable *rt = dst_rtable(tuple->dst_cache);
-	__u8 dsfield = ipv6_get_dsfield(ip6h);
+	u8 hop_limit, proto = tuple->tun.l3_proto;
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
 		.flowi6_proto = proto,
 	};
+	struct ipv6hdr *ip6h;
+	__u8 dsfield;
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
@@ -707,12 +722,13 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 
 		hopt = skb_push(skb, ipv6_optlen(opt.ops.dst1opt));
 		memcpy(hopt, opt.ops.dst1opt, ipv6_optlen(opt.ops.dst1opt));
-		hopt->nexthdr = IPPROTO_IPV6;
+		hopt->nexthdr = proto;
 		proto = NEXTHDR_DEST;
 	}
 
 	skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IPV6);
 
 	ip6h = ipv6_hdr(skb);
 	ip6_flow_hdr(ip6h, dsfield,
@@ -729,6 +745,22 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
+static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
+			       struct flow_offload_tuple *tuple,
+			       __be32 *ip_daddr, struct in6_addr **ip6_daddr,
+			       int encap_limit)
+{
+	switch (tuple->tun.encap_proto) {
+	case AF_INET:
+		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
+	case AF_INET6:
+		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, ip6_daddr,
+						  encap_limit);
+	default:
+		return 0;
+	}
+}
+
 static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
 				  struct in6_addr **ip6_daddr,
@@ -842,6 +874,7 @@ unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
 {
+	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple *other_tuple;
@@ -850,6 +883,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		.in	= state->in,
 	};
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
@@ -860,7 +894,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (!tuplehash)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb,
+				      encap_limit);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -879,25 +914,41 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple, &ip_daddr,
+				&ip6_daddr, encap_limit) < 0)
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
+		if (other_tuple->tun.encap_proto == AF_INET6 ||
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
@@ -1150,8 +1201,12 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
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
@@ -1179,8 +1234,12 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
-					   encap_limit);
+	if (ctx.tun.proto == IPPROTO_IPIP)
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb,
+					      encap_limit);
+	else
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb, encap_limit);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -1204,21 +1263,38 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
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
+		if (other_tuple->tun.encap_proto == AF_INET ||
+		    ctx.tun.proto == IPPROTO_IPIP) {
+			__be32 ip_daddr = other_tuple->src_v4.s_addr;
+			struct rtable *rt4;
+
+			skb->protocol = htons(ETH_P_IP);
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
index 4d01212d6614..ac9741f5793b 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -213,12 +213,11 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 	struct dst_entry *tun_dst = NULL;
 	struct flowi fl = {};
 
-	switch (nft_pf(pkt)) {
+	switch (tun->encap_proto) {
 	case NFPROTO_IPV4:
 		fl.u.ip4.daddr = tun->dst_v4.s_addr;
 		fl.u.ip4.saddr = tun->src_v4.s_addr;
 		fl.u.ip4.flowi4_iif = nft_in(pkt)->ifindex;
-		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
 		fl.u.ip4.flowi4_mark = pkt->skb->mark;
 		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
 		break;
@@ -226,13 +225,12 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 		fl.u.ip6.daddr = tun->dst_v6;
 		fl.u.ip6.saddr = tun->src_v6;
 		fl.u.ip6.flowi6_iif = nft_in(pkt)->ifindex;
-		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
 		fl.u.ip6.flowi6_mark = pkt->skb->mark;
 		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 		break;
 	}
 
-	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
+	nf_route(nft_net(pkt), &tun_dst, &fl, false, tun->encap_proto);
 	if (!tun_dst)
 		return -ENOENT;
 

-- 
2.54.0

