Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7613C480352;
	Tue,  5 May 2026 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777992605; cv=none; b=LIQddahmPVceIOsL0h2N3YVmYCsZvxBOZiiocpTeJitI0Mw1M0Y6DcP/0+Zoh7TxyzXHy/F8H+ykRCp7tyN1oaRXox+I0eedid0Pz/ymI764McHkCjTZ7mirA70tiajMTzli04SpC6nBpT+VeXz1PEokB2QTlIDs2himNeBr5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777992605; c=relaxed/simple;
	bh=NufIRfFbDQZaRSGyfG2ymdDJTGmsa8tSnXmoazf14x8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YSA9pkecC5GFvYAHgNugqncZAPWT1ZU/mQg+iJTf+Cdys0MtsGX438AD2rE/y3vuTwsBxbKZhl2A08d/Kgh0PmxeM59dSKvSF7QMEr+AhDNIZ/zp5lJtAWgGn3JSZj0VF+FzhwrZFkgymgS/A4Fnaxe9tpYrDDID0IuqY5dDa+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHPKThhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHPKThhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D64C2BCF6;
	Tue,  5 May 2026 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777992605;
	bh=NufIRfFbDQZaRSGyfG2ymdDJTGmsa8tSnXmoazf14x8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZHPKThhl4P0SAjIdwJbYusFoEEqKrpOm4XtbWJMwOqG2TWtZzORnGx0zy3zLilWrV
	 xwx/rroBJf4y2q9wRX8vaPyZS+XHJZ9ACdJCZjFOzrMSsyvmOC2QTHb4sRa+cjAIL1
	 t7Z9wjKUFoHU+gcAQAfbjgCSTIgDeK79SY8M8roQ2knHGwdsA/Ccsm4PRiu5/jgqvZ
	 bpjUJfplEtvM/HahhEBAfdixr+1jCRsgixdCB65Au5JIaAHEtIwsw7TNdtxIccVHfq
	 yjz+EBPrbFdGRdD2eOBPn2ghnf0ecVXW/kRc0lIcgLduMl76L/EVymI3oyeH/Adjc9
	 aDIkVZOWXCKlg==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 05 May 2026 16:49:25 +0200
Subject: [PATCH nf-next 3/4] net: netfilter: Add IPv4 over IPv6 tunnel
 flowtable acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-b4-flowtable-sw-accel-ip6ip-v1-3-9ac39ccc9ea9@kernel.org>
References: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
In-Reply-To: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, netdev@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kselftest@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Introduce sw flowtable acceleration for the TX/RX paths of
IPv4 over IPv6 tunnels, relying on the netfilter flowtable
infrastructure.
The feature can be tested with a forwarding scenario between two
NICs (eth0 and eth1), where an IPv4 over IPv6 tunnel is used to
reach a remote site via eth1 as the underlay device:

    ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (192.168.100.2)

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
default via 2002:db8:1::2 dev tun0 metric 1024 pref medium

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
  - net-next + IP6IP flowtable support: ~140 Gbps

- TCP stream transmitted to IPv4 over IPv6 tunnel:
  - net-next (baseline):                ~127 Gbps
  - net-next + IP6IP flowtable support: ~141 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_core.c |  14 ++--
 net/netfilter/nf_flow_table_ip.c   | 127 +++++++++++++++++++++++++++----------
 net/netfilter/nf_flow_table_path.c |   6 +-
 3 files changed, 107 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2c4140e6f53c..53fea3da0747 100644
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
@@ -134,10 +136,14 @@ static int flow_offload_fill_route(struct flow_offload *flow,
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
index 9efd76b57847..70d7b5a200e2 100644
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
@@ -650,18 +654,29 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
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
@@ -697,12 +712,13 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
 
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
@@ -767,6 +783,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		.in	= state->in,
 	};
 	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
@@ -796,28 +813,50 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
+	if (other_tuple->tun.encap_proto == AF_INET6) {
+		if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
+					   &ip6_daddr,
+					   IPV6_DEFAULT_TNL_ENCAP_LIMIT) < 0)
+			return NF_DROP;
+	} else if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
+					  &ip_daddr) < 0) {
 		return NF_DROP;
+	}
 
 	if (nf_flow_encap_push(skb, other_tuple) < 0)
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
@@ -1068,8 +1107,12 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
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
@@ -1097,8 +1140,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
-	ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash, skb,
-					   encap_limit);
+	if (ctx.tun.proto == IPPROTO_IPIP)
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	else
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb, encap_limit);
 	if (ret < 0)
 		return NF_DROP;
 	else if (ret == 0)
@@ -1125,21 +1171,38 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
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
index 5a5774d9b6f5..74b6f5ea35f9 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -209,12 +209,11 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
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
@@ -222,13 +221,12 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
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

