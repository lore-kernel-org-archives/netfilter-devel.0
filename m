Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795215167;
	b=J1QTwlnRmTfNmiLX2+6FWcnQGFGAyftLioMTaMlc1AhonpjuuFx4Ik0tlIw6uYcZtFRL
	 nXIatpw//0C2RCRD/ZsPFlOSis2Fc9FEQ2E9zP/rwrVdppcxpXVqmxoafyKZdbLh270q4
	 28Da3Q5h/lDM1eoNl1sVHd5XabgMi9aCBl3vM1fqRIl363rSaOlaj4eNJfJXzxyKUccvz
	 UwTzqwVMNzsyOTwUUezX+lQPsa8Ree0MjmCty2MHcEO58ysuXlLTKPfd7NC8b1gsdEVZ1
	 yfWc4E+KpKKbXrfxb7a0qPMLLBkDPa/RsZR1PM+BtEjnHCnNzNe+uMNmMrq8xeQCHvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795215167;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=RK8rur+ytPjvEQTIpdjGecsEdK4gEmzIDdTXDAc+OZU=;
	b=zz4Bh8yQqlrge7zJqoiNygb7w+mowSuh6PA2E2qiErdt03tpTW6df8HR8CboQPyA2ZLM
	 ctHaQPIO1+Ljvhn+JSBQ63pQKH6NS4r6dZcKPNFYvo6mwt9cJAL40teWM9cVEcNcZU3Lw
	 c3AWSn4YvPTmvFnJmESk0cYSRQHe7yv+F+vtizrX3AwrvC4xIS+At1DrXNU02x3KvNq2d
	 HINcNlXCAuTknA+2EtykNKEEOPjlX3/jNycgmgr80BUuiRUZSffXtg0KmZKpsKT4UEJ3N
	 Qe3OGgz3VOwUtFvfMs6r2Z0XHStQ6OktF1EQXcycbcZL1CDAzswyLRu1wuaXcrE7ehQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AbPWaWQp;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7EB606A33E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 22:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E7EB606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AbPWaWQp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795215152;
	bh=RK8rur+ytPjvEQTIpdjGecsEdK4gEmzIDdTXDAc+OZU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AbPWaWQpsMWRt9gJ/nRuB+GXL3wNg7DYoK1hOJitWPj1UyCMHIFMQONZ6VncaWxnp
	 bDZUdGJiDWfK7s1e7Fr5vKyabqPLdYxWK1Uh9KtcGV7XfnLYj6+ozdokn/6naWhQ0k
	 jDgd37wpfMG/lZxQjX5r/at6ouqUqcxLknxaZAByeiCbLmpBhW34MOZ38IKqC+DQJJ
	 wFNGlLN67wnqrDHNrr/YPpXfj0Zg1psWyLQ53f3a8JiOEVOBFQosHaMdNOUSOFiqjL
	 kOnQkYngVU7fzwZnRJweDy8A0UUuAyfr3h9p/g+vv+za744JDbtGfFTgjy9WIB9akO
	 /Mr2B3dhn4/+w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0C7076007C
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 23:52:32 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw address for XMIT_NEIGH type
Date: Fri, 20 Nov 2026 23:52:26 +0100
Message-ID: <20261120225227.3565643-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120225227.3565643-1-pablo@netfilter.org>
References: <20261120225227.3565643-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit b5964aac51e0 ("netfilter: flowtable: consolidate xmit
path"), a flow offloaded with FLOW_OFFLOAD_XMIT_NEIGH keeps being
forwarded with destination MAC 00:00:00:00:00:00 after the next hop's
neighbour entry has been removed. Nothing resolves the next hop again,
so the flow stays black-holed for as long as it keeps sending.

Cache the destination hw address in the flow entry, just like
XMIT_DIRECT does. Use the flowtable GC to validate that there is a
neighbour entry that is still valid. Otherwise, if the neighbour entry
is stale, trigger a probe.

Skip check the stale neighbour check for non-Ethernet devices such as
WireGuard or GRE by checking for all zero destination hw address,
otherwise the flow entries are incorrectly torn down.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: skip check for stale neighbout entries in case non-ethernet device
    is use in the flowtable tx path.

 net/ipv4/ipip.c                    | 18 ++++++++
 net/ipv6/ip6_tunnel.c              | 41 +++++++++++++-----
 net/netfilter/nf_flow_table_core.c | 67 ++++++++++++++++++++++++++++--
 net/netfilter/nf_flow_table_ip.c   | 41 ++++--------------
 net/netfilter/nf_flow_table_path.c | 11 ++++-
 5 files changed, 130 insertions(+), 48 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 15189e1fa068..4079aa385fea 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -358,6 +358,8 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 {
 	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
 	const struct iphdr *tiph = &tunnel->parms.iph;
+	unsigned char ha[ETH_ALEN];
+	struct neighbour *n;
 	struct rtable *rt;
 
 	if (ctx->ether_type != cpu_to_be16(ETH_P_IP))
@@ -375,6 +377,21 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
+	n = dst_neigh_lookup(&rt->dst, &tiph->daddr);
+	if (!n) {
+		ip_rt_put(rt);
+		return -ENOENT;
+	}
+
+	if (n->dev->addr_len != ETH_ALEN ||
+	    !(READ_ONCE(n->nud_state) & NUD_VALID)) {
+		ip_rt_put(rt);
+		neigh_release(n);
+		return -EINVAL;
+	}
+	neigh_ha_snapshot(ha, n, n->dev);
+	neigh_release(n);
+
 	path->type = DEV_PATH_TUN;
 	path->tun.src_v4.s_addr = tiph->saddr;
 	path->tun.dst_v4.s_addr = tiph->daddr;
@@ -383,6 +400,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->tun.dst = &rt->dst;
 	path->dev = ctx->dev;
 
+	memcpy(ctx->daddr, ha, ETH_ALEN);
 	ctx->dev = rt->dst.dev;
 
 	return 0;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 64a184bca467..84d26d9454a9 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1840,7 +1840,9 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 				     struct net_device_path *path)
 {
 	struct ip6_tnl *t = netdev_priv(ctx->dev);
+	unsigned char ha[ETH_ALEN];
 	struct dst_entry *dst;
+	struct neighbour *n;
 	struct flowi6 fl6;
 	int err;
 
@@ -1863,20 +1865,37 @@ static int ip6_tnl_fill_forward_path(struct net_device_path_ctx *ctx,
 	fl6.flowi6_proto = 0;
 
 	dst = ip6_route_output(dev_net(ctx->dev), NULL, &fl6);
-	if (!dst->error) {
-		path->type = DEV_PATH_TUN;
-		path->tun.src_v6 = fl6.saddr;
-		path->tun.dst_v6 = fl6.daddr;
-		path->tun.inner_proto = IPPROTO_IPV6;
-		path->tun.encap_proto = AF_INET6;
-		path->tun.dst = dst;
-		path->dev = ctx->dev;
-		ctx->dev = dst->dev;
+	err = dst->error;
+	if (err) {
+		dst_release(dst);
+		return err;
 	}
 
-	err = dst->error;
-	if (err)
+	n = dst_neigh_lookup(dst, &fl6.daddr);
+	if (!n) {
 		dst_release(dst);
+		return -ENOENT;
+	}
+
+	if (n->dev->addr_len != ETH_ALEN ||
+	    !(READ_ONCE(n->nud_state) & NUD_VALID)) {
+		dst_release(dst);
+		neigh_release(n);
+		return -EINVAL;
+	}
+	neigh_ha_snapshot(ha, n, n->dev);
+	neigh_release(n);
+
+	path->type = DEV_PATH_TUN;
+	path->tun.src_v6 = fl6.saddr;
+	path->tun.dst_v6 = fl6.daddr;
+	path->tun.inner_proto = IPPROTO_IPV6;
+	path->tun.encap_proto = AF_INET6;
+	path->tun.dst = dst;
+	path->dev = ctx->dev;
+
+	memcpy(ctx->daddr, ha, ETH_ALEN);
+	ctx->dev = dst->dev;
 
 	return err;
 }
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a7b4fc5766a9..80c5784140db 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -5,6 +5,7 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
@@ -140,8 +141,11 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		break;
-	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
+		       ETH_ALEN);
+		fallthrough;
+	case FLOW_OFFLOAD_XMIT_XFRM:
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
@@ -573,6 +577,63 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
+{
+	struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct flow_offload_tuple *other_tuple;
+	unsigned char ha[ETH_ALEN];
+	struct neighbour *n;
+	const void *daddr;
+	u8 state;
+	bool ret;
+
+	if (!tuple->dst_cache)
+		return true;
+
+	if (!dst_check(tuple->dst_cache, tuple->dst_cookie))
+		return false;
+
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH)
+		return true;
+
+	/* non-Ethernet device, skip check. */
+	if (is_zero_ether_addr(tuple->out.h_dest))
+		return true;
+
+	other_tuple = &flow->tuplehash[!dir].tuple;
+	if (other_tuple->tun_num)
+		daddr = &other_tuple->tun.src_v6;
+	else
+		daddr = &other_tuple->src_v6;
+
+	n = dst_neigh_lookup(tuple->dst_cache, daddr);
+	if (!n)
+		return false;
+
+	if (n->dev->addr_len != ETH_ALEN) {
+		neigh_release(n);
+		return false;
+	}
+	neigh_ha_snapshot(ha, n, n->dev);
+
+	state = READ_ONCE(n->nud_state);
+	if (state & NUD_VALID) {
+		if (ether_addr_equal(ha, tuple->out.h_dest))
+			ret = true;
+		else
+			ret = false;
+
+		if (state & NUD_STALE)
+			neigh_event_send(n, NULL);
+	} else {
+		ret = false;
+	}
+
+	neigh_release(n);
+
+	return ret;
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -585,8 +646,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
+	    !nf_flow_dst_check_gc(flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
+	    !nf_flow_dst_check_gc(flow, FLOW_OFFLOAD_DIR_REPLY) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 115c54ad4633..5971d2584c5c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -590,8 +590,7 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
 
 static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,
-				  union nf_inet_addr **ip_addr)
+				  struct dst_entry *dst)
 {
 	__be16 frag_off = 0;
 	struct iphdr *iph;
@@ -651,15 +650,12 @@ static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
 	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
 	ip_send_check(iph);
 
-	*ip_addr = (union nf_inet_addr *)&tuple->tun.src_v4;
-
 	return 0;
 }
 
 static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 				   struct flow_offload_tuple *tuple,
-				   struct dst_entry *dst,
-				   union nf_inet_addr **ip_addr)
+				   struct dst_entry *dst)
 {
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
@@ -718,21 +714,18 @@ static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
 
-	*ip_addr = (union nf_inet_addr *)&tuple->tun.src_v6;
-
 	return 0;
 }
 
 static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
 			       struct flow_offload_tuple *tuple,
-			       struct dst_entry *dst,
-			       union nf_inet_addr **ip_addr)
+			       struct dst_entry *dst)
 {
 	switch (tuple->tun.encap_proto) {
 	case AF_INET:
-		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_addr);
+		return nf_flow_tunnel_ip_push(net, skb, tuple, dst);
 	case AF_INET6:
-		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst, ip_addr);
+		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst);
 	default:
 		return 0;
 	}
@@ -842,9 +835,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
-	union nf_inet_addr *ip_addr;
 	struct flow_offload *flow;
-	struct neighbour *neigh;
 	struct rtable *rt;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
@@ -858,10 +849,9 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
-	ip_addr = (union nf_inet_addr *)&other_tuple->src_v4;
 
 	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
-				tuplehash->tuple.dst_cache, &ip_addr) < 0)
+				tuplehash->tuple.dst_cache) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -872,12 +862,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
-		if (IS_ERR(neigh)) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = neigh->ha;
+		xmit.dest = tuplehash->tuple.out.h_dest;
 		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
@@ -1171,9 +1156,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
-	union nf_inet_addr *ip_addr;
 	struct flow_offload *flow;
-	struct neighbour *neigh;
 	struct rt6_info *rt;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
@@ -1187,10 +1170,9 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
-	ip_addr = (union nf_inet_addr *)&other_tuple->src_v6;
 
 	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
-				tuplehash->tuple.dst_cache, &ip_addr) < 0)
+				tuplehash->tuple.dst_cache) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -1201,12 +1183,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &ip_addr->in6));
-		if (IS_ERR(neigh)) {
-			flow_offload_teardown(flow);
-			return NF_DROP;
-		}
-		xmit.dest = neigh->ha;
+		xmit.dest = tuplehash->tuple.out.h_dest;
 		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 841f099434d9..5923ef9cdaef 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -57,6 +57,7 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 	};
 	struct neighbour *n;
 	u8 nud_state;
+	int ret;
 
 	if (!nft_is_valid_ether_device(dev)) {
 		eth_zero_addr(ha);
@@ -79,7 +80,12 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 out:
 	ether_addr_copy(ctx.daddr, ha);
 
-	return dev_fill_forward_path(&ctx, stack);
+	ret = dev_fill_forward_path(&ctx, stack);
+
+	if (memcmp(ctx.daddr, ha, ETH_ALEN))
+		ether_addr_copy(ha, ctx.daddr);
+
+	return ret;
 }
 
 struct nft_forward_info {
@@ -259,9 +265,10 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
 
+	memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.47.3

