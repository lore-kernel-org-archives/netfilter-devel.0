From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] netfilter: bridge: unshare bridge info before change it
Date: Mon, 29 Sep 2014 15:35:14 +0800
Message-ID: <1411976114-16812-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23889 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbaI2HfV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:35:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many packets may share the same bridge information,
we should unshare the bridge info before we change it,
otherwise other packets will go to PF_INET(6)/PRE_ROUTING
second time or the pkt_type of other packets will be
incorrect.

The problem occurs when we do nfqueue after br_nf_pre_routing
and before bf_nf_pre_routing_finish, if the packet is gso,
the new segs will share the same bridge info. and netfilter
may use skb_clone, this will cause many packets share the
same bridge info too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/netfilter_bridge.h |  54 ++++++++++++++++++++-
 net/bridge/br_netfilter.c        | 101 +++++++++++++++++++--------------------
 2 files changed, 100 insertions(+), 55 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 8ab1c27..25cfeab 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -53,14 +53,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
 	return 0;
 }
 
+static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
+{
+	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (likely(skb->nf_bridge))
+		atomic_set(&(skb->nf_bridge->use), 1);
+
+	return skb->nf_bridge;
+}
+
+static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+
+	if (atomic_read(&nf_bridge->use) > 1) {
+		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
+
+		if (tmp) {
+			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
+			atomic_set(&tmp->use, 1);
+		}
+		nf_bridge_put(nf_bridge);
+		nf_bridge = tmp;
+	}
+	return nf_bridge;
+}
+
+static inline struct nf_bridge_info *
+nf_bridge_set_mask(struct sk_buff *skb, unsigned int mask)
+{
+	if (!nf_bridge_unshare(skb))
+		return NULL;
+
+	skb->nf_bridge->mask |= mask;
+	return skb->nf_bridge;
+}
+
+static inline struct nf_bridge_info *
+nf_bridge_change_mask(struct sk_buff *skb, unsigned int mask)
+{
+	if (!nf_bridge_unshare(skb))
+		return NULL;
+
+	skb->nf_bridge->mask ^= mask;
+	return skb->nf_bridge;
+}
+
 int br_handle_frame_finish(struct sk_buff *skb);
 /* Only used in br_device.c */
 static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 
 	skb_pull(skb, ETH_HLEN);
-	nf_bridge->mask ^= BRNF_BRIDGED_DNAT;
+	nf_bridge = nf_bridge_change_mask(skb, BRNF_BRIDGED_DNAT);
+	if (nf_bridge == NULL) {
+		kfree_skb(skb);
+		return 0;
+	}
 	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
 				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a615264..eeca74e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -187,32 +187,6 @@ static inline struct net_device *bridge_parent(const struct net_device *dev)
 	return port ? port->br->dev : NULL;
 }
 
-static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
-{
-	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
-	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
-
-	return skb->nf_bridge;
-}
-
-static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
-{
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-
-	if (atomic_read(&nf_bridge->use) > 1) {
-		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
-
-		if (tmp) {
-			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
-			atomic_set(&tmp->use, 1);
-		}
-		nf_bridge_put(nf_bridge);
-		nf_bridge = tmp;
-	}
-	return nf_bridge;
-}
-
 static inline void nf_bridge_push_encap_header(struct sk_buff *skb)
 {
 	unsigned int len = nf_bridge_encap_header_len(skb);
@@ -345,20 +319,25 @@ int nf_bridge_copy_header(struct sk_buff *skb)
  * bridge PRE_ROUTING hook. */
 static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 {
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 	struct rtable *rt;
 
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+	if (skb->nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
+		nf_bridge = nf_bridge_change_mask(skb,
+				BRNF_PKT_TYPE | BRNF_NF_BRIDGE_PREROUTING);
+	} else {
+		nf_bridge = nf_bridge_change_mask(skb,
+				BRNF_NF_BRIDGE_PREROUTING);
 	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+
+	if (nf_bridge == NULL)
+		goto drop;
 
 	rt = bridge_parent_rtable(nf_bridge->physindev);
-	if (!rt) {
-		kfree_skb(skb);
-		return 0;
-	}
+	if (!rt)
+		goto drop;
+
 	skb_dst_set_noref(skb, &rt->dst);
 
 	skb->dev = nf_bridge->physindev;
@@ -366,8 +345,11 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
 	nf_bridge_push_encap_header(skb);
 	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, skb, skb->dev, NULL,
 		       br_handle_frame_finish, 1);
-
+out:
 	return 0;
+drop:
+	kfree_skb(skb);
+	goto out;
 }
 
 /* Obtain the correct destination MAC address, while preserving the original
@@ -387,7 +369,7 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	dst = skb_dst(skb);
 	neigh = dst_neigh_lookup_skb(dst, skb);
 	if (neigh) {
-		int ret;
+		int ret = 0;
 
 		if (neigh->hh.hh_len) {
 			neigh_hh_bridge(&neigh->hh, skb);
@@ -403,8 +385,10 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 							 skb->nf_bridge->data,
 							 ETH_HLEN-ETH_ALEN);
 			/* tell br_dev_xmit to continue with forwarding */
-			nf_bridge->mask |= BRNF_BRIDGED_DNAT;
-			ret = neigh->output(neigh, skb);
+			if (nf_bridge_set_mask(skb, BRNF_BRIDGED_DNAT) == NULL)
+				kfree_skb(skb);
+			else
+				ret = neigh->output(neigh, skb);
 		}
 		neigh_release(neigh);
 		return ret;
@@ -456,15 +440,24 @@ static int br_nf_pre_routing_finish(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	struct iphdr *iph = ip_hdr(skb);
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 	struct rtable *rt;
 	int err;
 
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+	if (skb->nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
+		nf_bridge = nf_bridge_change_mask(skb,
+				BRNF_PKT_TYPE | BRNF_NF_BRIDGE_PREROUTING);
+	} else {
+		nf_bridge = nf_bridge_change_mask(skb,
+				BRNF_NF_BRIDGE_PREROUTING);
+	}
+
+	if (nf_bridge == NULL) {
+		kfree_skb(skb);
+		return 0;
 	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+
 	if (dnat_took_place(skb)) {
 		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
@@ -750,7 +743,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 		in = nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
 			skb->pkt_type = PACKET_OTHERHOST;
-			nf_bridge->mask ^= BRNF_PKT_TYPE;
+
+			if (!nf_bridge_change_mask(skb, BRNF_PKT_TYPE)) {
+				kfree_skb(skb);
+				return 0;
+			}
 		}
 		nf_bridge_update_protocol(skb);
 	} else {
@@ -782,11 +779,6 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	if (!skb->nf_bridge)
 		return NF_ACCEPT;
 
-	/* Need exclusive nf_bridge_info since we might have multiple
-	 * different physoutdevs. */
-	if (!nf_bridge_unshare(skb))
-		return NF_DROP;
-
 	parent = bridge_parent(out);
 	if (!parent)
 		return NF_DROP;
@@ -803,14 +795,16 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	nf_bridge = skb->nf_bridge;
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
+		nf_bridge = nf_bridge_set_mask(skb,
+				BRNF_PKT_TYPE | BRNF_BRIDGED);
+	} else {
+		/* The physdev module checks on this */
+		nf_bridge = nf_bridge_set_mask(skb, BRNF_BRIDGED);
 	}
 
-	if (pf == NFPROTO_IPV4 && br_parse_ip_options(skb))
+	if (!nf_bridge || (pf == NFPROTO_IPV4 && br_parse_ip_options(skb)))
 		return NF_DROP;
 
-	/* The physdev module checks on this */
-	nf_bridge->mask |= BRNF_BRIDGED;
 	nf_bridge->physoutdev = skb->dev;
 	if (pf == NFPROTO_IPV4)
 		skb->protocol = htons(ETH_P_IP);
@@ -911,7 +905,8 @@ static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
 	 * about the value of skb->pkt_type. */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
+		if (!nf_bridge_set_mask(skb, BRNF_PKT_TYPE))
+			return NF_DROP;
 	}
 
 	nf_bridge_pull_encap_header(skb);
-- 
1.9.3

