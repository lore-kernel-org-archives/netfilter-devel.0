Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F514C0414;
	Wed,  6 May 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778088521; cv=none; b=iWunb78KrVCypNnoJYe05Ye5ToZrjXdG2rSu5Ud2s5MEMU2s27KfADklILGb1C7gPjszgbPtS2zWatcLT6pbjJcmejpK6YFcXklu/v2L+o/nnAAvXehqr+Hf9g+JrMRp491eQYEnqH9GVzaN+Cw4SQTRAv+KZQYkP/6HXQzxd3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778088521; c=relaxed/simple;
	bh=6LnUwzVgP2oflBB2J5DbKVeQkTLXTUX3uDyr9659XLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h52C+F8yNjUgeV8QFog5hkb6GU8mXNHjtLbTpfXPZjJfY7yOeRaSoYNNDYCuAPa3hytmXSuN6a9OvkzpvDgYbeC52ysD95F/JRSZkkS8LBhle4Uvud/2Hhbc+K4+cV1k3Y6W4kzRVEmpOM5F3H7ICncmZS4NZneV9t9XMW2Hhyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biJbU64A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biJbU64A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F147C2BCF6;
	Wed,  6 May 2026 17:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778088520;
	bh=6LnUwzVgP2oflBB2J5DbKVeQkTLXTUX3uDyr9659XLw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=biJbU64AOVgDUAoqAQ8VXKPvbH852BV5CRY8Xq6nqV+fiXVyKqgXqBAZYVZWvWLW+
	 uuW8SlRH+41Kxwhy48o9VPc3IsUA3s4lGvum3Lspr83w2E35xOYzsHJkIQHMuQwxm0
	 1y/glqLQ6uhKYyXQVYvzmIyuunX8/xbN5lH3gc1FyQ6laioCyqrED63r6kEHI8DJ91
	 j2T9gxBivL7/C+R/qKA23GUj8ZV1seFsJJ0Xklrv5tRhNGMgpFqBJoSdUIhQXGaPG2
	 CGbXVULnYeMdK4AChVLR56lqJRNP6N0cpVOBMQWxHeHBRbFsQhtls1Gy+4Q9A4DYOh
	 PfB62vZmphUZA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 06 May 2026 19:27:36 +0200
Subject: [PATCH nf-next v2 5/6] net: netfilter: Add SIT tunnel flowtable
 acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-b4-flowtable-sw-accel-ip6ip-v2-5-439fd427726e@kernel.org>
References: <20260506-b4-flowtable-sw-accel-ip6ip-v2-0-439fd427726e@kernel.org>
In-Reply-To: <20260506-b4-flowtable-sw-accel-ip6ip-v2-0-439fd427726e@kernel.org>
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
SIT tunnels, relying on the netfilter flowtable infrastructure.
The feature can be tested with a forwarding scenario between two
NICs (eth0 and eth1), where a SIT tunnel is used to reach a remote
site via eth1 as the underlay device:

    ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (192.168.2.2)

[IP configuration]

6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet6 2001:db8:1::2/64 scope global nodad
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.1/24 scope global eth1
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/sit 192.168.2.1 peer 192.168.2.2
    inet6 2001:db8:200::1/64 scope global nodad
       valid_lft forever preferred_lft forever

$ ip route show
192.168.2.0/24 dev eth1 proto kernel scope link src 192.168.2.1

$ ip -6 route show
2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
2001:db8:200::/64 dev tun0 proto kernel metric 256 pref medium
default via 2001:db8:200::2 dev tun0 metric 1024 pref medium

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

- TCP stream received from SIT tunnel:
  - net-next (baseline):                ~118 Gbps
  - net-next + SIT flowtable support: ~148 Gbps

- TCP stream transmitted to SIT tunnel:
  - net-next (baseline):                ~131 Gbps
  - net-next + SIT flowtable support: ~147 Gbps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/ipv6/sit.c                   |  26 ++++
 net/netfilter/nf_flow_table_ip.c | 304 ++++++++++++++++++++++-----------------
 2 files changed, 196 insertions(+), 134 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 201347b4e127..d1d5ff385d6f 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1362,6 +1362,31 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
 	}
 }
 
+static int ipip6_tunnel_fill_forward_path(struct net_device_path_ctx *ctx,
+					  struct net_device_path *path)
+{
+	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
+	const struct iphdr *tiph = &tunnel->parms.iph;
+	struct rtable *rt;
+
+	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, 0, 0, 0,
+			     RT_SCOPE_UNIVERSE);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	path->type = DEV_PATH_TUN;
+	path->tun.src_v4.s_addr = tiph->saddr;
+	path->tun.dst_v4.s_addr = tiph->daddr;
+	path->tun.l3_proto = IPPROTO_IPV6;
+	path->tun.encap_proto = AF_INET;
+	path->dev = ctx->dev;
+
+	ctx->dev = rt->dst.dev;
+	ip_rt_put(rt);
+
+	return 0;
+}
+
 static int
 ipip6_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			    void __user *data, int cmd)
@@ -1398,6 +1423,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
+	.ndo_fill_forward_path = ipip6_tunnel_fill_forward_path,
 };
 
 static void ipip6_dev_free(struct net_device *dev)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 6394f4474f43..0ad2b35d5f35 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -336,8 +336,8 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = IPPROTO_IPIP;
+	if (iph->protocol == IPPROTO_IPIP || iph->protocol == IPPROTO_IPV6) {
+		ctx->tun.proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += size;
 	}
@@ -485,21 +485,6 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static struct flow_offload_tuple_rhash *
-nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
-		       struct nf_flowtable *flow_table, struct sk_buff *skb)
-{
-	struct flow_offload_tuple tuple = {};
-
-	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
-		return NULL;
-
-	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
-		return NULL;
-
-	return flow_offload_lookup(flow_table, &tuple);
-}
-
 static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct nf_flowtable *flow_table,
 				   struct flow_offload_tuple_rhash *tuplehash,
@@ -602,19 +587,33 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 				    struct flow_offload_tuple *tuple,
 				    __be32 *ip_daddr)
 {
-	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
 	struct rtable *rt = dst_rtable(tuple->dst_cache);
-	u8 tos = iph->tos, ttl = iph->ttl;
-	__be16 frag_off = iph->frag_off;
-	u32 headroom = sizeof(*iph);
+	__be16 frag_off = 0;
+	struct iphdr *iph;
+	u8 tos = 0, ttl;
+	u32 headroom;
 	int err;
 
+	if (tuple->tun.l3_proto == IPPROTO_IPV6) {
+		struct ipv6hdr *ip6h;
+
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		tos = ipv6_get_dsfield(ip6h);
+		ttl = ip6h->hop_limit;
+	} else {
+		iph = (struct iphdr *)skb_network_header(skb);
+		frag_off = iph->frag_off;
+		tos = iph->tos;
+		ttl = iph->ttl;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
-	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.l3_proto);
+	headroom = sizeof(*iph) + LL_RESERVED_SPACE(rt->dst.dev) +
+		   rt->dst.header_len;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
@@ -625,6 +624,7 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	/* Push down and install the IP header. */
 	skb_push(skb, sizeof(*iph));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IP);
 
 	iph = ip_hdr(skb);
 	iph->version	= 4;
@@ -781,112 +781,6 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 	return 0;
 }
 
-unsigned int
-nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
-{
-	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
-	struct flow_offload_tuple *other_tuple;
-	enum flow_offload_tuple_dir dir;
-	struct nf_flowtable_ctx ctx = {
-		.in	= state->in,
-	};
-	struct nf_flow_xmit xmit = {};
-	struct in6_addr *ip6_daddr;
-	struct flow_offload *flow;
-	struct neighbour *neigh;
-	struct rtable *rt;
-	__be32 ip_daddr;
-	int ret;
-
-	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
-	if (!tuplehash)
-		return NF_ACCEPT;
-
-	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb,
-				      encap_limit);
-	if (ret < 0)
-		return NF_DROP;
-	else if (ret == 0)
-		return NF_ACCEPT;
-
-	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
-		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
-		IPCB(skb)->iif = skb->dev->ifindex;
-		IPCB(skb)->flags = IPSKB_FORWARDED;
-		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
-	}
-
-	dir = tuplehash->tuple.dir;
-	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	other_tuple = &flow->tuplehash[!dir].tuple;
-	ip_daddr = other_tuple->src_v4.s_addr;
-
-	if (other_tuple->tun.encap_proto == AF_INET6) {
-		if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-					   &ip6_daddr,
-					   IPV6_DEFAULT_TNL_ENCAP_LIMIT) < 0)
-			return NF_DROP;
-	} else if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
-					  &ip_daddr) < 0) {
-		return NF_DROP;
-	}
-
-	if (nf_flow_encap_push(skb, other_tuple) < 0)
-		return NF_DROP;
-
-	switch (tuplehash->tuple.xmit_type) {
-	case FLOW_OFFLOAD_XMIT_NEIGH: {
-		struct dst_entry *dst;
-
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		if (other_tuple->tun.encap_proto == AF_INET6 ||
-		    ctx.tun.proto == IPPROTO_IPV6) {
-			struct rt6_info *rt6;
-
-			rt6 = dst_rt6_info(tuplehash->tuple.dst_cache);
-			neigh = ip_neigh_gw6(rt6->dst.dev,
-					     rt6_nexthop(rt6, ip6_daddr));
-			dst = &rt6->dst;
-		} else {
-			rt = dst_rtable(tuplehash->tuple.dst_cache);
-			neigh = ip_neigh_gw4(rt->dst.dev,
-					     rt_nexthop(rt, ip_daddr));
-			dst = &rt->dst;
-		}
-		if (IS_ERR(neigh)) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = neigh->ha;
-		skb_dst_set_noref(skb, dst);
-		break;
-	}
-	case FLOW_OFFLOAD_XMIT_DIRECT:
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
-		if (!xmit.outdev) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = tuplehash->tuple.out.h_dest;
-		xmit.source = tuplehash->tuple.out.h_source;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return NF_DROP;
-	}
-
-	return nf_flow_queue_xmit(state->net, skb, &xmit);
-}
-EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
-
 static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
 				 struct in6_addr *addr,
 				 struct in6_addr *new_addr,
@@ -1071,10 +965,17 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num) {
+	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
+	case AF_INET:
+		mtu -= sizeof(struct iphdr);
+		break;
+	case AF_INET6:
 		mtu -= sizeof(*ip6h);
 		if (encap_limit > 0)
 			mtu -= 8; /* encap limit option */
+		break;
+	default:
+		break;
 	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
@@ -1109,6 +1010,25 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static struct flow_offload_tuple_rhash *
+nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
+		       struct nf_flowtable *flow_table, struct sk_buff *skb)
+{
+	struct flow_offload_tuple tuple = {};
+
+	if (!nf_flow_skb_encap_protocol(ctx, skb, htons(ETH_P_IP)))
+		return NULL;
+
+	if (ctx->tun.proto == IPPROTO_IPV6) {
+		if (nf_flow_tuple_ipv6(ctx, skb, &tuple) < 0)
+			return NULL;
+	} else if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0) {
+		return NULL;
+	}
+
+	return flow_offload_lookup(flow_table, &tuple);
+}
+
 static struct flow_offload_tuple_rhash *
 nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 			    struct nf_flowtable *flow_table,
@@ -1129,6 +1049,117 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+unsigned int
+nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
+	int encap_limit = IPV6_DEFAULT_TNL_ENCAP_LIMIT;
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	struct flow_offload_tuple *other_tuple;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct nf_flow_xmit xmit = {};
+	struct in6_addr *ip6_daddr;
+	struct flow_offload *flow;
+	struct neighbour *neigh;
+	struct rtable *rt;
+	__be32 ip_daddr;
+	int ret;
+
+	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	if (ctx.tun.proto == IPPROTO_IPV6)
+		ret = nf_flow_offload_ipv6_forward(&ctx, flow_table, tuplehash,
+						   skb, encap_limit);
+	else
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb,
+					      encap_limit);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
+	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		rt = dst_rtable(tuplehash->tuple.dst_cache);
+		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+		IPCB(skb)->iif = skb->dev->ifindex;
+		IPCB(skb)->flags = IPSKB_FORWARDED;
+		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+	}
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip_daddr = other_tuple->src_v4.s_addr;
+	ip6_daddr = &other_tuple->src_v6;
+
+	if (other_tuple->tun.encap_proto == AF_INET6) {
+		if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
+					   &ip6_daddr,
+					   IPV6_DEFAULT_TNL_ENCAP_LIMIT) < 0)
+			return NF_DROP;
+	} else if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
+					  &ip_daddr) < 0) {
+		return NF_DROP;
+	}
+
+	if (nf_flow_encap_push(skb, other_tuple) < 0)
+		return NF_DROP;
+
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH: {
+		struct dst_entry *dst;
+
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
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
+		if (IS_ERR(neigh)) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = neigh->ha;
+		skb_dst_set_noref(skb, dst);
+		break;
+	}
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		if (!xmit.outdev) {
+			flow_offload_teardown(flow);
+			return NF_DROP;
+		}
+		xmit.dest = tuplehash->tuple.out.h_dest;
+		xmit.source = tuplehash->tuple.out.h_source;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return NF_DROP;
+	}
+
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
+
 unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)
@@ -1146,6 +1177,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
+	__be32 ip_daddr;
 	int ret;
 
 	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
@@ -1174,11 +1206,17 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
+	ip_daddr = other_tuple->src_v4.s_addr;
 	ip6_daddr = &other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   &ip6_daddr, encap_limit) < 0)
+	if (other_tuple->tun.encap_proto == AF_INET) {
+		if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
+					   &ip_daddr) < 0)
+			return NF_DROP;
+	} else if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
+					  &ip6_daddr, encap_limit) < 0) {
 		return NF_DROP;
+	}
 
 	if (nf_flow_encap_push(skb, other_tuple) < 0)
 		return NF_DROP;
@@ -1194,10 +1232,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		}
 		if (other_tuple->tun.encap_proto == AF_INET ||
 		    ctx.tun.proto == IPPROTO_IPIP) {
-			__be32 ip_daddr = other_tuple->src_v4.s_addr;
 			struct rtable *rt4;
 
-			skb->protocol = htons(ETH_P_IP);
 			rt4 = dst_rtable(tuplehash->tuple.dst_cache);
 			neigh = ip_neigh_gw4(rt4->dst.dev,
 					     rt_nexthop(rt4, ip_daddr));

-- 
2.54.0

