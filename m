Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBF633C538;
	Tue, 25 Nov 2025 22:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110012; cv=none; b=cUe2rx38n0p1UvckpF6m++UHuJfAkPzH8eqZWqfMfubDzZNjACd6NzuoIRYeJnrAM5mcpZNUH0DrRGDNUvm1w4CSD+5TnQwJMIkrEwpztlPUpF/HlqrSRgGLKViVieX/7CCvgR88HeqZvMyLlmEB/f5rCle3gg2W7Xb2FRROdrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110012; c=relaxed/simple;
	bh=93yZLklrC7hYm9id2DWB3Sw9mV9Y2eLGJAT4JbDcNkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtwVGbl15rq6R1TuGcevmw7khXWILy7QD7Mixf3JvO3hzZuqUBMdKHG1U8M9fK/s5Xa5ckyjBtKJmNZCV0ZKjd/o8VEtCQDqRHuCfRfTV5oR2eS+eCmC1PD9mNri1GdmFrw1AjZkNpIx9k7zFH3b14b/0RQjpX9L7Fjx7/m95Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VtYjpRpu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VtYjpRpu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D13FB602B2;
	Tue, 25 Nov 2025 23:33:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110009;
	bh=b+9mVVpCcc6j61h8Zrd1Ffg8E4QFhQBDHaNvQATfW7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtYjpRpuFQh5ZSBj2WAHIj3U+26jOa1KScFq5MvXdBZ2p8Po6GkHaATQk0YBXo4ux
	 V6A25uQXKSIo4E8usIyUdF15bISSUYxuSZAq1aNh693aORVJD8L9xIqHy6wjJUOmB5
	 iJaTB8GW0CIS77iwpX19zIne8j6eMraFMYjLcWwZ05ae+p9D113lXAIfcehRnp9fvR
	 7DM/7xfUGxA3L6jfseT5YlhBMZniPOxUWgTSjVbTjjZ92nZx/hiSgnYJGfipLceKev
	 JK7tcai470sizmAJUynlZ5dmW70hsllQwgiDY2G0ztrgi4XhNSdS3YGH1fdGlT2EPM
	 At8+e0Y/ffR+w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 08/16] netfilter: flowtable: Add IPIP tx sw acceleration
Date: Tue, 25 Nov 2025 22:33:04 +0000
Message-ID: <20251125223312.1246891-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce sw acceleration for tx path of IPIP tunnels relying on the
netfilter flowtable infrastructure.
This patch introduces basic infrastructure to accelerate other tunnel
types (e.g. IP6IP6).
IPIP sw tx acceleration can be tested running the following scenario where
the traffic is forwarded between two NICs (eth0 and eth1) and an IPIP
tunnel is used to access a remote site (using eth1 as the underlay device):

ETH0 -- TUN0 <==> ETH1 -- [IP network] -- TUN1 (192.168.100.2)

$ip addr show
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:00:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 scope global eth0
       valid_lft forever preferred_lft forever
7: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:11:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.1/24 scope global eth1
       valid_lft forever preferred_lft forever
8: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1480 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ipip 192.168.1.1 peer 192.168.1.2
    inet 192.168.100.1/24 scope global tun0
       valid_lft forever preferred_lft forever

$ip route show
default via 192.168.100.2 dev tun0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.2
192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.1
192.168.100.0/24 dev tun0 proto kernel scope link src 192.168.100.1

$nft list ruleset
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

Reproducing the scenario described above using veths I got the following
results:
- TCP stream trasmitted into the IPIP tunnel:
  - net-next: (baseline)                ~ 85Gbps
  - net-next + IPIP flowtable support:  ~102Gbps

Co-developed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c   | 62 ++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c | 48 +++++++++++++++++++++--
 2 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2214e858e096..e128b0fe9a7b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -437,6 +437,9 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
+	if (flow->tuplehash[!dir].tuple.tun_num)
+		mtu -= sizeof(*iph);
+
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
 		return 0;
 
@@ -508,6 +511,62 @@ static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 	return 0;
 }
 
+static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
+				    struct flow_offload_tuple *tuple,
+				    __be32 *ip_daddr)
+{
+	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+	struct rtable *rt = dst_rtable(tuple->dst_cache);
+	u8 tos = iph->tos, ttl = iph->ttl;
+	__be16 frag_off = iph->frag_off;
+	u32 headroom = sizeof(*iph);
+	int err;
+
+	err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP4);
+	if (err)
+		return err;
+
+	skb_set_inner_ipproto(skb, IPPROTO_IPIP);
+	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
+	err = skb_cow_head(skb, headroom);
+	if (err)
+		return err;
+
+	skb_scrub_packet(skb, true);
+	skb_clear_hash_if_not_l4(skb);
+
+	/* Push down and install the IP header. */
+	skb_push(skb, sizeof(*iph));
+	skb_reset_network_header(skb);
+
+	iph = ip_hdr(skb);
+	iph->version	= 4;
+	iph->ihl	= sizeof(*iph) >> 2;
+	iph->frag_off	= ip_mtu_locked(&rt->dst) ? 0 : frag_off;
+	iph->protocol	= tuple->tun.l3_proto;
+	iph->tos	= tos;
+	iph->daddr	= tuple->tun.src_v4.s_addr;
+	iph->saddr	= tuple->tun.dst_v4.s_addr;
+	iph->ttl	= ttl;
+	iph->tot_len	= htons(skb->len);
+	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
+	ip_send_check(iph);
+
+	*ip_daddr = tuple->tun.src_v4.s_addr;
+
+	return 0;
+}
+
+static int nf_flow_tunnel_v4_push(struct net *net, struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple,
+				  __be32 *ip_daddr)
+{
+	if (tuple->tun_num)
+		return nf_flow_tunnel_ipip_push(net, skb, tuple, ip_daddr);
+
+	return 0;
+}
+
 static int nf_flow_encap_push(struct sk_buff *skb,
 			      struct flow_offload_tuple *tuple)
 {
@@ -572,6 +631,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	ip_daddr = other_tuple->src_v4.s_addr;
 
+	if (nf_flow_tunnel_v4_push(state->net, skb, other_tuple, &ip_daddr) < 0)
+		return NF_DROP;
+
 	if (nf_flow_encap_push(skb, other_tuple) < 0)
 		return NF_DROP;
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 64e2672a3c33..7d6668e4d424 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -190,7 +190,46 @@ static bool nft_flowtable_find_dev(const struct net_device *dev,
 	return found;
 }
 
-static void nft_dev_forward_path(struct nf_flow_route *route,
+static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
+					struct flow_offload_tunnel *tun,
+					struct nf_flow_route *route,
+					enum ip_conntrack_dir dir)
+{
+	struct dst_entry *cur_dst = route->tuple[dir].dst;
+	struct dst_entry *tun_dst = NULL;
+	struct flowi fl = {};
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		fl.u.ip4.daddr = tun->dst_v4.s_addr;
+		fl.u.ip4.saddr = tun->src_v4.s_addr;
+		fl.u.ip4.flowi4_iif = nft_in(pkt)->ifindex;
+		fl.u.ip4.flowi4_dscp = ip4h_dscp(ip_hdr(pkt->skb));
+		fl.u.ip4.flowi4_mark = pkt->skb->mark;
+		fl.u.ip4.flowi4_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	case NFPROTO_IPV6:
+		fl.u.ip6.daddr = tun->dst_v6;
+		fl.u.ip6.saddr = tun->src_v6;
+		fl.u.ip6.flowi6_iif = nft_in(pkt)->ifindex;
+		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
+		fl.u.ip6.flowi6_mark = pkt->skb->mark;
+		fl.u.ip6.flowi6_flags = FLOWI_FLAG_ANYSRC;
+		break;
+	}
+
+	nf_route(nft_net(pkt), &tun_dst, &fl, false, nft_pf(pkt));
+	if (!tun_dst)
+		return -ENOENT;
+
+	route->tuple[dir].dst = tun_dst;
+	dst_release(cur_dst);
+
+	return 0;
+}
+
+static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
+				 struct nf_flow_route *route,
 				 const struct nf_conn *ct,
 				 enum ip_conntrack_dir dir,
 				 struct nft_flowtable *ft)
@@ -213,7 +252,8 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
 	}
 
-	if (info.num_tuns) {
+	if (info.num_tuns &&
+	    !nft_flow_tunnel_update_route(pkt, &info.tun, route, dir)) {
 		route->tuple[!dir].in.tun.src_v6 = info.tun.dst_v6;
 		route->tuple[!dir].in.tun.dst_v6 = info.tun.src_v6;
 		route->tuple[!dir].in.tun.l3_proto = info.tun.l3_proto;
@@ -274,9 +314,9 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	nft_default_forward_path(route, other_dst, !dir);
 
 	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH)
-		nft_dev_forward_path(route, ct, dir, ft);
+		nft_dev_forward_path(pkt, route, ct, dir, ft);
 	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
-		nft_dev_forward_path(route, ct, !dir, ft);
+		nft_dev_forward_path(pkt, route, ct, !dir, ft);
 
 	return 0;
 }
-- 
2.47.3

