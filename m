Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0042E719B;
	Sun, 18 Oct 2026 00:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285040; cv=none; b=QKt3VL/pvfsUWZunfs62xU5tjKzkEMhvAqwMSFsfoZawu2xXHZPw+3ifLt8Yx7DzavIHXqkAeoMvQfYoQ0omu0HRAWm2xExlEJrrXyAZO7ikfEO7aSMTiyL4ekCN7HCeC1rz+bdnsxVcFJ/rtBdzWdOBmD7iRcCdvqHgV/cc9rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285040; c=relaxed/simple;
	bh=5/7Dx/hiwZ+5V1267GhaWws5YmXNZ/8tXZTQcnN6N0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZE8SYoU55jczJ8FTrNF6ipraT+9tNggP1ESA/jRXGKRwWmO6dbjth3v55POOgWU9BAWYAV5aenvqL5HV1W0Hg8rnEEU/aMyZfIPSgVPggZMMbjjIKXeIBxS+Bl1yAqNjVxDXB3qVIpoaBn64QKPwcrpVo4wlgldbc7alef0YBjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TbjTVnno; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TbjTVnno"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285026;
	bh=/sYBkgwPG1DG9it/LvFFKxBQfEBGeOFTyvSJZr5okkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbjTVnnoa/1Q5nYX+wuiwWdoBYPE4wmxGnVeiFEgIBsO6e4xuCj6JQwqBk+tHwJYx
	 dB6dqpwFAyYFgqiCjWEoa6ISqmeVj0HuH5/RCh45Qv4vlR17EqcZzJjsPXzSJE+tKC
	 VERQouZ54ak5uWh/Bc3PEMA1HGmQQZb3KSSONdKqzF1aFQz30v/wqlWfEgNT39525r
	 BiEa4HO392ZeB/Ep6FbotUYx58iwRAFijvlSOV9o9BemW6XDV9kec9dAelBnrEeh8+
	 Kf6Akn3NHlKSVrlpZJdHZyB22wRaEoCSINfu6bSVVRMhiI/Q9xOahL0RJ1dHx8ar58
	 U0EhG78Vb3xPQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 136B560078;
	Sun, 18 Oct 2026 02:57:06 +0200 (CEST)
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
Subject: [PATCH net-next 15/15] netfilter: flowtable: unify tunnel push for IPv4 and IPv6
Date: Sun, 18 Oct 2026 02:56:38 +0200
Message-ID: <20261018005638.1776148-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
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
index 29a769736dbf..e13f9397e8cb 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -587,23 +587,44 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id,
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
@@ -614,11 +635,12 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
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
@@ -628,81 +650,91 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
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
@@ -809,10 +841,10 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
@@ -825,10 +857,10 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
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
@@ -839,7 +871,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_daddr));
+		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
@@ -1137,7 +1169,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	struct flow_offload_tuple *other_tuple;
 	enum flow_offload_tuple_dir dir;
 	struct nf_flow_xmit xmit = {};
-	struct in6_addr *ip6_daddr;
+	union nf_inet_addr *ip_addr;
 	struct flow_offload *flow;
 	struct neighbour *neigh;
 	struct rt6_info *rt;
@@ -1153,11 +1185,10 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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
@@ -1168,7 +1199,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
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

