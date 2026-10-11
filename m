Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02E5404BE3;
	Sun, 11 Oct 2026 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756015; cv=none; b=ADa+6s+9TgESg2PCnr27IGzLTB+N8pf2K7IVUrUEaXilTkQ2PoDB4CrMiyUi3AI4fereyJXRm38f/ocrusV+KFGYlBBLa9NCTe9YTe2SvAGk0KWK7tV9LvNxI/807hoB384jFq3UZceLDlSJc3sfj7U7mfQ7HpAe4eelQp9SrlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756015; c=relaxed/simple;
	bh=tnkmU/HcCpe82ZDqliIX7WDs2VRN5K+C2z5GntG+yLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twuEeje6HIfiO0tTTymYpbmx8IogArXobIZmIN6P86VaJHVYxl4NBS6FsCR5SOmAzfwUjakuwoSi/Sh6i1O0U1u1HrhX+leKNFnohuDwyMAzpYecj1gCmwhuIklb40kVI+Yw+5wuZCoDmDOyn8Wg5TpZhdl8RGBtjwN5xVPM0Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h2OvBytQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h2OvBytQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756011;
	bh=YvGhI2eGJZsHV+Cyk/lLsjkig2nyzGQVieYVNbsp4os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2OvBytQD0f/tpOCMkJGm9KuqpNK/sk8/L/ToG8JxROD+dMNDmJrNUf+pYAmcB4qi
	 LrVh7NkH88jsXIl+mQInbPpdCfb7wVtnYWkHyvmDJTkzKgfIF4PfLjs7l+yVVwRuzb
	 cNcwYp5D8HWMfpnL9aR0Jp4cpbfqQ8H5SvtbMvR1WMVn1ofp2ez8ID3LKxRbhrvNYR
	 GuCNcx5C+cDeBSVNjp58CX/exUyXHjurnAg4Al4gs085gfaZpIhrSnjpCBtOQuioDw
	 ao0jBOKJGjKZAGy4rkBc1eMkuckCQrrOLCW9kRNFI4OQmNLGdKDJKorLnph+INCRFn
	 iT3KAASCJSJSw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0BFE160078;
	Mon, 12 Oct 2026 00:00:11 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/15] netfilter: flowtable: unify tunnel push for IPv4 and IPv6
Date: Sun, 11 Oct 2026 23:59:45 +0200
Message-ID: <20261011215953.1334630-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Refactor nf_flow_tunnel_ipip_push() and nf_flow_tunnel_ip6ip6_push()
into nf_flow_tunnel_ip_push() and nf_flow_tunnel_ip6_push(), keying the
inner header handling off tuple->tun.inner_proto so both IP-in-IP and
IPv6-in-IPv6 inner protocols are supported regardless of the outer
address family. Replace nf_flow_tunnel_v4_push() and
nf_flow_tunnel_v6_push() with a single nf_flow_tunnel_push() that
dispatches on tuple->tun.encap_proto, and set skb->protocol explicitly
after pushing the outer header.
This is a preliminary patch to support IPv4 over IPv6 and SIT tunnel
flowtable offload.
Please note IPv4 over IPv6 and SIT tunnel flowtable offloading is not
enabled yet.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 143 +++++++++++++++++++------------
 1 file changed, 87 insertions(+), 56 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 96dbdadba4e7..7a62a70593ed 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -608,23 +608,44 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
 	return 0;
 }
 
-static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
-				    struct flow_offload_tuple *tuple,
-				    struct dst_entry *dst, __be32 *ip_daddr)
+static int nf_flow_tunnel_ip_push(struct net *net, struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple,
+				  struct dst_entry *dst,
+				  union nf_inet_addr **ip_addr)
 {
-	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
-	struct rtable *rt = dst_rtable(dst);
-	u8 tos = iph->tos, ttl = iph->ttl;
-	__be16 frag_off = iph->frag_off;
-	u32 headroom = sizeof(*iph);
+	__be16 frag_off = 0;
+	struct iphdr *iph;
+	u8 tos = 0, ttl;
+	u32 headroom;
 	int err;
 
+	switch (tuple->tun.inner_proto) {
+	case IPPROTO_IPV6: {
+		struct ipv6hdr *ip6h;
+
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		tos = ipv6_get_dsfield(ip6h);
+		ttl = ip6h->hop_limit;
+		frag_off = htons(IP_DF);
+		break;
+	}
+	case IPPROTO_IPIP:
+		iph = (struct iphdr *)skb_network_header(skb);
+		frag_off = iph->frag_off;
+		tos = iph->tos;
+		ttl = iph->ttl;
+		break;
+	default:
+		return 0;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
-	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
+	headroom = sizeof(*iph) + LL_RESERVED_SPACE(dst->dev) +
+		   dst->header_len;
 	err = skb_cow_head(skb, headroom);
 	if (err)
 		return err;
@@ -635,11 +656,12 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	/* Push down and install the IP header. */
 	skb_push(skb, sizeof(*iph));
 	skb_reset_network_header(skb);
+	skb->protocol = htons(ETH_P_IP);
 
 	iph = ip_hdr(skb);
 	iph->version	= 4;
 	iph->ihl	= sizeof(*iph) >> 2;
-	iph->frag_off	= ip_mtu_locked(&rt->dst) ? 0 : frag_off;
+	iph->frag_off	= ip_mtu_locked(dst) ? 0 : frag_off;
 	iph->protocol	= tuple->tun.inner_proto;
 	iph->tos	= tos;
 	iph->daddr	= tuple->tun.src_v4.s_addr;
@@ -649,81 +671,91 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
 	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
 	ip_send_check(iph);
 
-	*ip_daddr = tuple->tun.src_v4.s_addr;
-
-	return 0;
-}
-
-static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,  __be32 *ip_daddr)
-{
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ipip_push(net, skb, tuple, dst, ip_daddr);
+	*ip_addr = (union nf_inet_addr *)&tuple->tun.src_v4;
 
 	return 0;
 }
 
-static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
-				      struct flow_offload_tuple *tuple,
-				      struct dst_entry *dst,
-				      struct in6_addr **ip6_daddr)
+static int nf_flow_tunnel_ip6_push(struct net *net, struct sk_buff *skb,
+				   struct flow_offload_tuple *tuple,
+				   struct dst_entry *dst,
+				   union nf_inet_addr **ip_addr)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
-	__u8 dsfield = ipv6_get_dsfield(ip6h);
-	struct rtable *rt = dst_rtable(dst);
 	struct flowi6 fl6 = {
 		.daddr = tuple->tun.src_v6,
 		.saddr = tuple->tun.dst_v6,
-		.flowi6_proto = IPPROTO_IPV6,
+		.flowi6_proto = tuple->tun.inner_proto,
 	};
-	u8 hop_limit = ip6h->hop_limit;
+	u8 hop_limit, dsfield;
+	struct ipv6hdr *ip6h;
 	int err, mtu;
 	u32 headroom;
 
+	switch (tuple->tun.inner_proto) {
+	case IPPROTO_IPIP: {
+		struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+		dsfield = ipv4_get_dsfield(iph);
+		hop_limit = iph->ttl;
+		break;
+	}
+	case IPPROTO_IPV6:
+		ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		dsfield = ipv6_get_dsfield(ip6h);
+		hop_limit = ip6h->hop_limit;
+		break;
+	default:
+		return 0;
+	}
+
 	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 	if (err)
 		return err;
 
-	skb_set_inner_ipproto(skb, IPPROTO_IPV6);
-	headroom = sizeof(*ip6h) + LL_RESERVED_SPACE(rt->dst.dev) +
-		   rt->dst.header_len;
+	skb_set_inner_ipproto(skb, tuple->tun.inner_proto);
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
+	ip6h->nexthdr = tuple->tun.inner_proto;
 	ip6h->daddr = tuple->tun.src_v6;
 	ip6h->saddr = tuple->tun.dst_v6;
 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(*ip6h));
 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
 
-	*ip6_daddr = &tuple->tun.src_v6;
+	*ip_addr = (union nf_inet_addr *)&tuple->tun.src_v6;
 
 	return 0;
 }
 
-static int nf_flow_tunnel_v6_push(struct net *net, struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple,
-				  struct dst_entry *dst,
-				  struct in6_addr **ip6_daddr)
+static int nf_flow_tunnel_push(struct net *net, struct sk_buff *skb,
+			       struct flow_offload_tuple *tuple,
+			       struct dst_entry *dst,
+			       union nf_inet_addr **ip_addr)
 {
-	if (tuple->tun_num)
-		return nf_flow_tunnel_ip6ip6_push(net, skb, tuple, dst, ip6_daddr);
-
-	return 0;
+	switch (tuple->tun.encap_proto) {
+	case AF_INET:
+		return nf_flow_tunnel_ip_push(net, skb, tuple, dst, ip_addr);
+	case AF_INET6:
+		return nf_flow_tunnel_ip6_push(net, skb, tuple, dst, ip_addr);
+	default:
+		return 0;
+	}
 }
 
 static int nf_flow_encap_push(struct sk_buff *skb,
@@ -830,10 +862,10 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
+	union nf_inet_addr *ip_addr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rtable *rt;
-	__be32 ip_daddr;
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -846,10 +878,10 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
-	ip_daddr = other_tuple->src_v4.s_addr;
+	ip_addr = (union nf_inet_addr *)&other_tuple->src_v4;
 
-	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache, &ip_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache, &ip_addr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -860,7 +892,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
@@ -1154,7 +1186,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
-	struct in6_addr *ip6_daddr;
+	union nf_inet_addr *ip_addr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
@@ -1170,11 +1202,10 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	other_tuple = &flow->tuplehash[!dir].tuple;
-	ip6_daddr = &other_tuple->src_v6;
+	ip_addr = (union nf_inet_addr *)&other_tuple->src_v6;
 
-	if (nf_flow_tunnel_v6_push(state->net, skb, other_tuple,
-				   tuplehash->tuple.dst_cache,
-				   &ip6_daddr) < 0)
+	if (nf_flow_tunnel_push(state->net, skb, other_tuple,
+				tuplehash->tuple.dst_cache, &ip_addr) < 0)
 		return NF_DROP;
 
 	switch (tuplehash->tuple.xmit_type) {
@@ -1185,7 +1216,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, ip6_daddr));
+		neigh = ip_neigh_gw6(rt->dst.dev, rt6_nexthop(rt, &ip_addr->in6));
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
-- 
2.47.3

