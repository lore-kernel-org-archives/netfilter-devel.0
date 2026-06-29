Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A240628A
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736411; cv=none; b=StCx6wger9E7z5eHDYfGGoEMZmU+EpVlQ7eRjIFt12KDiOvsoNwI64YidcGDjM4sVhZF9w7s5ZzJh/1ciVB7Y5f9AKziWoP6JUcTJtu5VYefVxGoz7/zWXQ2manWuHGRMBSXeM47AmWrRY/Gn5kupL+eXUn7S8L3WiKCUzr7JQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736411; c=relaxed/simple;
	bh=uFlsWrhJwtQf9yt8auqKp+aP7EpEMnGUWhzv1INgKXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6fDga3DdNI80eDNcCU7Vx8MydwWqDy5xpNDHVO2z+7nFDBTtbnBlhp7DJFFWjL2SL/Ud8X3xixgxfvfEt9EyWA4MIGEB1oMD/CamUhK3TPMEQ5c6CWrHY10KhQCRW7MOwcl8XSjhGhuND+rgLlkJxDaL71/dL4ZsDyYORp6wWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CVVQzhBg; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CVVQzhBg"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69532288224so6437595a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736407; x=1783341207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZkMfYGbmmBFNVQavhfnwkj1f6U3WSLYvJuEXnZXuTc=;
        b=CVVQzhBg49eB4j7A7psihJsf6tvncRS3TukHErnyrHCN1EZuBa9sJg4hUSTrB+oL7P
         74XZyAbvSZ5XvbZ6ws6zllCQXyisPUgJdRvLGVUsvex5ldHyfX+ftFrA3MrWr96AqpDF
         4BGdZq/Hd75LSV8UENq8iEP8yUc9ddw/i9h6HrUbP/gEQnozC4dy/WrY18Ykj065loXr
         lS8rEEDGzJB+kMKBxQ8sOru/5FiqgmuNRGTkWjT8W8E0/XdTgwyMDG2zW2IMqUDc/PLw
         ZUjlG/7vEJVNpvBziLuXpfZmsQQqbaLS2ttA9XEjLfmea0xqTjja23UWitQrtwLfcV7F
         80+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736407; x=1783341207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ZkMfYGbmmBFNVQavhfnwkj1f6U3WSLYvJuEXnZXuTc=;
        b=S8hK9924luwHC28hPevDkzUFLtCUcgGs2GAKAcJGDbqZdAqdrkVAomS2ih/tkWtrU7
         4/ek55c0ayDGpUjmQHGNeEmDI1JLp08BCzJwGELHBA0TIZemZhLiArnNmH1k2E/HohRz
         mPJdwhH95BgXlOzMDTdpaJmyfH86y4C6s1tRisgnew8dDQ/qzlV+di6D+q/bj/eJr9zJ
         p1Libkxw74uFSmqg8ylQockSH+MBLBTquwDIyxjz2jnCMeCejhfRDm3B/GYcFLh3FAK4
         FGAnbh7SV4Us6UO5TJvIOms94j9NQ8BYcsTuZZZ95Qi6FpGT/Q6zJLyGFuPXIIlTaDZz
         SQnA==
X-Gm-Message-State: AOJu0YwwZg9sVKyxobpOvugs/Ey7jyrIquCcJ3y6O7j8d7hzsAQj62QN
	xGjMe0z0fDLDgSg8cXzeJacWbGY0LGxSTrVqKMm5/TWm6G7/YVY5WJqLFFPspbeQ
X-Gm-Gg: AfdE7cmdMA35OIF1xinhvR4y9TivFYy06BrsikAwK/D0EnoetF0HkgiGnh5cyYYPYa6
	x0L5TRPM0DxFlSOZyJdTvtjzp50DoKoU74tBv2ob77DbL3cB3bSLfumYaEY9Xz9mi6DbrwAlZ63
	fKfeiXHDyd2Lrv0+6B+DnZ/Ho2W1LAIz/rh81JDE0q/HtJJtRoGX2I6fkT4q6eiDW1jaGQcCMF2
	Uv18UGoHIwF/7NeKuxlViw2FdL7JsC+ahK6Ba+JF9BaFcLsPsb8cTnQApv7jnadXG6YhP74RvOH
	GFOgYq2/p2VNKcUGXlF9lG2WI6e/6wUNwirBlHj82UZgqehZUsVj/y4eL9cbvQqFmyhFoO6IR/m
	/KJs1DrillqtZ0PFhOE1vwyXDY1S42Uwzp3GYyPGu0Edn839YHCKZp4vPrDa6YdLPXMdsJllcey
	IbVDMNxQ4=
X-Received: by 2002:a17:906:4fc4:b0:c07:fcdd:7043 with SMTP id a640c23a62f3a-c12813bb075mr20833366b.16.1782736407037;
        Mon, 29 Jun 2026 05:33:27 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:25 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH 3/5] netfilter: nf_flow_table_path: add L2 bridge offload
Date: Mon, 29 Jun 2026 14:32:51 +0200
Message-ID: <20260629123253.1912621-4-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Chen <rchen14b@gmail.com>

Allow nft_flow_offload to accelerate traffic forwarded at layer 2 through
Linux bridge ports.

Detection: nft_flow_offload_is_bridging() identifies bridged flows by
checking that the ingress device is a bridge port and that the destination
MAC appears in the bridge FDB with a forwarding destination port (non-local
entry). VLAN resolution and FDB lookup are combined in a single
br_port_get_rcu() call via br_fdb_has_forwarding_entry_rcu().

Routing: nft_flow_route_bridging() allocates minimal dst entries anchored
to the bridge master device via rt_dst_alloc()/ip6_dst_alloc(). A full
routing table lookup via nf_route() is intentionally avoided: it fails for
prefixes that are only bridged, not routed, through the bridge interface
(e.g. when the bridge has no IP address or the bridged subnet is not in
the routing table).

MAC addresses: for bridged flows, nft_dev_forward_path() copies Ethernet
addresses directly from the packet header instead of going through the
neighbour table. Direction (original vs reply) is resolved against the
conntrack direction so both flow directions receive the correct MAC pair.

VLAN context: nft_br_vlan_dev_fill_forward_path() pre-populates the
net_device_path_ctx with the port VLAN id and protocol before the forward
path walk, enabling VLAN-aware hardware offload entries.

Also:
- info->indev is updated for every path type in nft_dev_path_info() so
  the bridge ingress device is correctly tracked regardless of path type.
- nft_flow_route() is now a thin dispatcher that delegates to
  nft_flow_route_routing() (routed traffic) or nft_flow_route_bridging()
  (bridged traffic); the exported API is unchanged.

Path discovery infrastructure was moved to nf_flow_table_path.c in
commit 93d7a7ed0734 ("netfilter: flowtable: move path discovery
infrastructure to its own file"), so all changes land in that file.

Based on a MediaTek SDK patch by Bo-Cun Chen <bc-bocun.chen@mediatek.com>.
Co-developed-by: Daniel Pawlik <pawlik.dan@gmail.com>
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
Signed-off-by: Ryan Chen <rchen14b@gmail.com>
---
 net/netfilter/nf_flow_table_path.c | 167 +++++++++++++++++++++++++++--
 1 file changed, 157 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..6c470854127f 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -15,6 +15,10 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <linux/if_bridge.h>
+#include <linux/if_ether.h>
+#include <net/route.h>
+#include <net/ip6_route.h>
 
 static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
 {
@@ -42,7 +46,25 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 	return true;
 }
 
-static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
+static bool nft_flow_offload_is_bridging(struct sk_buff *skb)
+{
+	bool ret;
+
+	if (!netif_is_bridge_port(skb->dev))
+		return false;
+	if (!skb_mac_header_was_set(skb))
+		return false;
+
+	rcu_read_lock();
+	ret = br_fdb_has_forwarding_entry_rcu(skb->dev, skb,
+					      eth_hdr(skb)->h_dest);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int nft_dev_fill_forward_path(struct net_device_path_ctx *ctx,
+				     const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
 				     enum ip_conntrack_dir dir, u8 *ha,
@@ -58,6 +80,12 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 		goto out;
 	}
 
+	/* Bridging fastpath copies Ethernet addresses into ha; do not replace
+	 * them via neighbour lookup on the routed destination device.
+	 */
+	if (!is_zero_ether_addr(ha))
+		goto out;
+
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
 		return -1;
@@ -72,7 +100,23 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 		return -1;
 
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	return __dev_fill_forward_path(ctx, ha, stack);
+}
+
+static void nft_br_vlan_dev_fill_forward_path(const struct nft_pktinfo *pkt,
+					      struct net_device_path_ctx *ctx)
+{
+	__be16 proto = 0;
+	u16 vlan_id;
+
+	rcu_read_lock();
+	vlan_id = br_vlan_get_offload_info_rcu(pkt->skb->dev, pkt->skb, &proto);
+	if (vlan_id) {
+		ctx->num_vlans = 1;
+		ctx->vlan[0].id = vlan_id;
+		ctx->vlan[0].proto = proto;
+	}
+	rcu_read_unlock();
 }
 
 struct nft_forward_info {
@@ -103,13 +147,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 
 	for (i = 0; i < stack->num_paths; i++) {
 		path = &stack->path[i];
+		info->indev = path->dev;
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 		case DEV_PATH_TUN:
-			info->indev = path->dev;
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
@@ -244,6 +288,7 @@ static int nft_flow_tunnel_update_route(const struct nft_pktinfo *pkt,
 }
 
 static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
+				bool is_bridging,
 				struct nf_flow_route *route,
 				const struct nf_conn *ct,
 				enum ip_conntrack_dir dir,
@@ -251,11 +296,33 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 {
 	const struct dst_entry *dst = route->tuple[dir].dst;
 	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {
+		.dev	= dst->dev,
+	};
 	struct nft_forward_info info = {};
+	enum ip_conntrack_info pkt_ctinfo;
+	enum ip_conntrack_dir skb_dir;
+	struct ethhdr *eth;
 	unsigned char ha[ETH_ALEN];
 	int i;
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) < 0 ||
+	memset(ha, 0, sizeof(ha));
+
+	if (is_bridging) {
+		nf_ct_get(pkt->skb, &pkt_ctinfo);
+		eth = eth_hdr(pkt->skb);
+		skb_dir = CTINFO2DIR(pkt_ctinfo);
+		if (skb_dir != dir) {
+			memcpy(ha, eth->h_source, ETH_ALEN);
+			memcpy(info.h_source, eth->h_dest, ETH_ALEN);
+		} else {
+			memcpy(ha, eth->h_dest, ETH_ALEN);
+			memcpy(info.h_source, eth->h_source, ETH_ALEN);
+		}
+		nft_br_vlan_dev_fill_forward_path(pkt, &ctx);
+	}
+
+	if (nft_dev_fill_forward_path(&ctx, route, dst, ct, dir, ha, &stack) < 0 ||
 	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
 		return -ENOENT;
 
@@ -292,9 +359,11 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
-int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
-		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
-		   struct nft_flowtable *ft)
+static int nft_flow_route_routing(const struct nft_pktinfo *pkt,
+				  const struct nf_conn *ct,
+				  struct nf_flow_route *route,
+				  enum ip_conntrack_dir dir,
+				  struct nft_flowtable *ft)
 {
 	struct dst_entry *this_dst = skb_dst(pkt->skb);
 	struct dst_entry *other_dst = NULL;
@@ -334,12 +403,12 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
 
-	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
-	    nft_dev_forward_path(pkt, route, ct, dir, ft) < 0)
+	if (route->tuple[dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH &&
+	    nft_dev_forward_path(pkt, false, route, ct, dir, ft) < 0)
 		goto err_dst_release;
 
 	if (route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH &&
-	    nft_dev_forward_path(pkt, route, ct, !dir, ft) < 0)
+	    nft_dev_forward_path(pkt, false, route, ct, !dir, ft) < 0)
 		goto err_dst_release;
 
 	return 0;
@@ -349,4 +418,82 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
 	dst_release(route->tuple[!dir].dst);
 	return -ENOENT;
 }
+
+static int nft_flow_route_bridging(const struct nft_pktinfo *pkt,
+				   const struct nf_conn *ct,
+				   struct nf_flow_route *route,
+				   enum ip_conntrack_dir dir,
+				   struct nft_flowtable *ft)
+{
+	struct dst_entry *dsts[IP_CT_DIR_MAX] = {};
+	struct net_device *br_dev;
+	int i;
+
+	/* Allocate minimal dsts anchored to the bridge master device to supply
+	 * xmit_type and MTU. A full routing lookup via nf_route() is avoided
+	 * because it fails for prefixes that are bridged but not routed.
+	 */
+	rcu_read_lock();
+	br_dev = netdev_master_upper_dev_get_rcu(pkt->skb->dev);
+	if (!br_dev || !netif_is_bridge_master(br_dev)) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+
+	for (i = 0; i < IP_CT_DIR_MAX; i++) {
+		switch (nft_pf(pkt)) {
+		case NFPROTO_IPV4: {
+			struct rtable *rt;
+
+			rt = rt_dst_alloc(br_dev, 0, RTN_UNICAST, true);
+			if (rt)
+				dsts[i] = &rt->dst;
+			break;
+		}
+		case NFPROTO_IPV6: {
+			struct rt6_info *rt;
+
+			rt = ip6_dst_alloc(nft_net(pkt), br_dev, 0);
+			if (rt)
+				dsts[i] = &rt->dst;
+			break;
+		}
+		}
+	}
+	rcu_read_unlock();
+
+	if (!dsts[dir] || !dsts[!dir]) {
+		dst_release(dsts[dir]);
+		dst_release(dsts[!dir]);
+		return -ENOENT;
+	}
+
+	nft_default_forward_path(route, dsts[dir], dir);
+	nft_default_forward_path(route, dsts[!dir], !dir);
+	/* Drop allocation references; route->tuple[*].dst holds the clones. */
+	dst_release(dsts[dir]);
+	dst_release(dsts[!dir]);
+
+	if (route->tuple[dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH &&
+	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+		if (nft_dev_forward_path(pkt, true, route, ct, dir, ft) ||
+		    nft_dev_forward_path(pkt, true, route, ct, !dir, ft)) {
+			dst_release(route->tuple[dir].dst);
+			dst_release(route->tuple[!dir].dst);
+			return -ENOENT;
+		}
+	}
+
+	return 0;
+}
+
+int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
+		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
+		   struct nft_flowtable *ft)
+{
+	if (nft_flow_offload_is_bridging(pkt->skb))
+		return nft_flow_route_bridging(pkt, ct, route, dir, ft);
+
+	return nft_flow_route_routing(pkt, ct, route, dir, ft);
+}
 EXPORT_SYMBOL_GPL(nft_flow_route);
-- 
2.54.0

