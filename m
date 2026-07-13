Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89840F8C3;
	Mon, 13 Jul 2026 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946817; cv=none; b=GpylW08ARc4GfkATJVwwhYpLFYMJsRi5mkco1Dezrm6LpS4xXb2mfooF1KQFXQRVvt/2885vizRkRzuMmmwgkyl1ss/VjvsNqtqIGFs2rQOEfRTV8tarlwNw3GxxWGqTCziXVhrU0aufd+TvAXeOoRwBTvZy8nzqnTS9Tb1TyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946817; c=relaxed/simple;
	bh=lWUx4kQjq/1uq9cooUAUulnJPahhrNQp02x9JXNB/bE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=An3QxAJjudp0utXSP1J2v3QmNp0H4SCmdaIYnTMK04IuQovI3qOF/8iENpxHpAfJRO3SNASUup4ko1vYIgBAzrJMHv4mRv/7at1NhRg0b7PkRR2vVfM+ElvDomf67AqBodYoIi5CNOD4H2Ue9+e5o8BDP72D3r0cdrlcNWahr2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjAsFa3x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjAsFa3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1710E1F00A3E;
	Mon, 13 Jul 2026 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783946814;
	bh=AY/yH8RHRDPrTErnxGASLd6a5our4Veu7wy/X8E0G+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hjAsFa3xWaA+6sudXHG6cdfJ4rbgN5ouHjP9yCJMTQnRG34lQEmYrxlwcivZ8gOqc
	 ALd68/h+pWtmdSkuoV12hgLP9WkHKQYZcTkpLQBUqXjsgwmro1UWX3lToi+y70WFLD
	 +Jf6N1eESgVx/u+tCS8v5SP7cboPKcBkv1ryXpqObQsQHOiQhZKAcuJhqnn6OHRb2l
	 bQ4YXxKHKCaMFcnvNVhRZALyKMDvun5ZI/aLEEQxSMVX3YUxEsa5wvwgRCcb1Xcmup
	 fq8ouJGvWHho+0ddvww6M27i5EI72ynmHRZ9LlGgmWKtdITXP+4Vh6+mtNP5kZuM+6
	 k3yrCDEoTdzhw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 13 Jul 2026 14:46:22 +0200
Subject: [PATCH nf-next v6 5/6] net: netfilter: add SIT tunnel flowtable
 acceleration
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-flowtable-sw-accel-ip6ip-v6-5-33f0155fc658@kernel.org>
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
 net/ipv6/sit.c                   |  60 ++++++++
 net/netfilter/nf_flow_table_ip.c | 286 +++++++++++++++++++++------------------
 2 files changed, 218 insertions(+), 128 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index a38b24fb8384..47150df789e7 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -29,6 +29,7 @@
 #include <linux/icmp.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/if_ether.h>
@@ -1365,6 +1366,64 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm_kern *p,
 	}
 }
 
+static int ipip6_tunnel_fill_forward_path(struct net_device_path_ctx *ctx,
+					  struct net_device_path *path)
+{
+	struct ip_tunnel *tunnel = netdev_priv(ctx->dev);
+	const struct iphdr *tiph = &tunnel->parms.iph;
+	struct rtable *rt;
+
+	/* NBMA tunnels (ISATAP, 6to4, 6rd) resolve the outer destination
+	 * per-packet from the inner IPv6 address; not offloadable.
+	 */
+	if (ctx->dev->priv_flags & IFF_ISATAP)
+		return -EOPNOTSUPP;
+
+	if (!tiph->daddr)
+		return -EOPNOTSUPP;
+
+	/* FOU/GUE encapsulation is handled in the slow path by
+	 * ip_tunnel_encap(); the fast path only pushes a plain
+	 * IPv4 header and would skip the UDP encapsulation.
+	 */
+	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
+		return -EOPNOTSUPP;
+
+	rt = ip_route_output(dev_net(ctx->dev), tiph->daddr, tiph->saddr,
+			     inet_dsfield_to_dscp(tiph->tos),
+			     tunnel->parms.link, RT_SCOPE_UNIVERSE);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	path->type = DEV_PATH_TUN;
+	if (tiph->saddr)
+		path->tun.src_v4.s_addr = tiph->saddr;
+	else
+		path->tun.src_v4.s_addr = inet_select_addr(rt->dst.dev,
+							   tiph->daddr,
+							   RT_SCOPE_UNIVERSE);
+	path->tun.dst_v4.s_addr = tiph->daddr;
+	path->tun.encap_proto = AF_INET;
+	path->dev = ctx->dev;
+
+	switch (ctx->ether_type) {
+	case cpu_to_be16(ETH_P_IP):
+		path->tun.l3_proto = IPPROTO_IPIP;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		path->tun.l3_proto = IPPROTO_IPV6;
+		break;
+	default:
+		ip_rt_put(rt);
+		return -EOPNOTSUPP;
+	}
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
@@ -1401,6 +1460,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
+	.ndo_fill_forward_path = ipip6_tunnel_fill_forward_path,
 };
 
 static void ipip6_dev_free(struct net_device *dev)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9432aa140657..03e399380937 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -337,7 +337,7 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (iph->protocol == IPPROTO_IPIP) {
+	if (iph->protocol == IPPROTO_IPIP || iph->protocol == IPPROTO_IPV6) {
 		ctx->tun.proto = iph->protocol;
 		ctx->tun.hdr_size = size;
 		ctx->offset += ctx->tun.hdr_size;
@@ -463,21 +463,6 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
 		nf_flow_ip_tunnel_pop(ctx, skb);
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
@@ -601,23 +586,38 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
 	return 0;
 }
 
-static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
-				    struct flow_offload_tuple *tuple,
-				    struct dst_entry *dst, __be32 *ip_daddr)
+static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple,
+				  struct dst_entry *dst, __be32 *ip_daddr)
 {
-	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
 	struct rtable *rt = dst_rtable(dst);
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
+		frag_off = htons(IP_DF);
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
@@ -716,8 +716,7 @@ static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
 {
 	switch (tuple->tun.encap_proto) {
 	case AF_INET:
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst,
-						ip_daddr);
+		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_daddr);
 	case AF_INET6:
 		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst,
 					       ip6_daddr);
@@ -823,106 +822,6 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-unsigned int
-nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
-{
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
-	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
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
-	ip6_daddr = &other_tuple->src_v6;
-
-	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
-				tuplehash->tuple.dst_cache,
-				&ip_daddr, &ip6_daddr) < 0)
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
-		if (other_tuple->tun.encap_proto ?
-		    other_tuple->tun.encap_proto == AF_INET6 :
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
-	xmit.tuple = other_tuple;
-	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
-
-	return nf_flow_queue_xmit(state->net, skb, &xmit);
-}
-EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
-
 static void nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
 				 struct in6_addr *addr,
 				 struct in6_addr *new_addr,
@@ -1107,8 +1006,16 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (flow->tuplehash[!dir].tuple.tun_num)
+	switch (flow->tuplehash[!dir].tuple.tun.encap_proto) {
+	case AF_INET:
+		mtu -= sizeof(struct iphdr);
+		break;
+	case AF_INET6:
 		mtu -= sizeof(*ip6h);
+		break;
+	default:
+		break;
+	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
@@ -1142,6 +1049,25 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
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
@@ -1162,6 +1088,110 @@ nf_flow_offload_ipv6_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+unsigned int
+nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
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
+						   skb);
+	else
+		ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
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
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache,
+				&ip_daddr, &ip6_daddr) < 0)
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
+	xmit.tuple = other_tuple;
+	xmit.needs_gso_segment = tuplehash->tuple.needs_gso_segment;
+
+	return nf_flow_queue_xmit(state->net, skb, &xmit);
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
+
 unsigned int
 nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			  const struct nf_hook_state *state)

-- 
2.55.0

