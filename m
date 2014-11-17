From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RESEND] netfilter: bridge: unshare bridge info before change it
Date: Mon, 17 Nov 2014 13:48:43 +0800
Message-ID: <1416203323-22745-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5542 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbaKQFsy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:48:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many packets may share the same bridge information,
we should unshare the bridge info before we change it,
otherwise other packets will go to PF_INET(6)/PRE_ROUTING
second time or the pkt_type of other packets will be
incorrect.

The problem occurs in below case.

Firstly setup NFQUEUE rule on ipv4 PREROUTING chain.

When gso packet came in from bridge, br_nf_pre_routing will
allocate nf_bridge_info for this gso packet. and call setup_pre_routing
to setup nf_bridge_info.(such as nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING)

Then this packet goes to ipv4 prerouting chain, nfqnl_enqueue_packet
will call skb_segment to segment this gso packet. in skb_segment, the new
packets will copy gso packet's header(__copy_skb_header), so there will
be many packets share the same nf_bridge_info.

When these segmented packets being reinjected into kernel, they will continue
going through bridge netfilter, br_nf_pre_routing_finish will clean the
BRNF_NF_BRIDGE_PREROUTING for the first packet, setup it for the secondary
packet, clean it for the third packet...

If the dest of these packets is local machine, they will come into br_pass_frame_up.
then go to ipv4 prerouting chain again through netif_receive_skb. so ip_sabotage_in
will not stop half of these packets.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/netfilter_bridge.h | 54 +++++++++++++++++++++-
 net/bridge/br_netfilter.c        | 98 ++++++++++++++++++----------------------
 2 files changed, 97 insertions(+), 55 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index c755e49..dca7337 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
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
+nf_bridge_unset_mask(struct sk_buff *skb, unsigned int mask)
+{
+	if (!nf_bridge_unshare(skb))
+		return NULL;
+
+	skb->nf_bridge->mask &= ~mask;
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
+	nf_bridge = nf_bridge_unset_mask(skb, BRNF_BRIDGED_DNAT);
+	if (nf_bridge == NULL) {
+		kfree_skb(skb);
+		return 0;
+	}
 	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
 				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 1a4f32c..b4612b9 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -127,32 +127,6 @@ static inline struct net_device *bridge_parent(const struct net_device *dev)
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
@@ -243,20 +217,25 @@ drop:
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
+		nf_bridge = nf_bridge_unset_mask(skb,
+				(BRNF_PKT_TYPE | BRNF_NF_BRIDGE_PREROUTING));
+	} else {
+		nf_bridge = nf_bridge_unset_mask(skb,
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
@@ -264,8 +243,11 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
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
@@ -285,7 +267,7 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	dst = skb_dst(skb);
 	neigh = dst_neigh_lookup_skb(dst, skb);
 	if (neigh) {
-		int ret;
+		int ret = 0;
 
 		if (neigh->hh.hh_len) {
 			neigh_hh_bridge(&neigh->hh, skb);
@@ -302,8 +284,12 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 							 ETH_HLEN-ETH_ALEN);
 			/* tell br_dev_xmit to continue with forwarding */
 			nf_bridge->mask |= BRNF_BRIDGED_DNAT;
-			/* FIXME Need to refragment */
-			ret = neigh->output(neigh, skb);
+			if (!nf_bridge_set_mask(skb, BRNF_BRIDGED_DNAT)) {
+				kfree_skb(skb);
+			} else {
+				/* FIXME Need to refragment */
+				ret = neigh->output(neigh, skb);
+			}
 		}
 		neigh_release(neigh);
 		return ret;
@@ -355,7 +341,7 @@ static int br_nf_pre_routing_finish(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	struct iphdr *iph = ip_hdr(skb);
-	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	struct nf_bridge_info *nf_bridge;
 	struct rtable *rt;
 	int err;
 	int frag_max_size;
@@ -363,11 +349,15 @@ static int br_nf_pre_routing_finish(struct sk_buff *skb)
 	frag_max_size = IPCB(skb)->frag_max_size;
 	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
 
-	if (nf_bridge->mask & BRNF_PKT_TYPE) {
+	if (skb->nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->mask ^= BRNF_PKT_TYPE;
+		nf_bridge = nf_bridge_unset_mask(skb,
+				(BRNF_PKT_TYPE | BRNF_NF_BRIDGE_PREROUTING));
+	} else {
+		nf_bridge = nf_bridge_unset_mask(skb,
+				BRNF_NF_BRIDGE_PREROUTING);
 	}
-	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
+
 	if (dnat_took_place(skb)) {
 		if ((err = ip_route_input(skb, iph->daddr, iph->saddr, iph->tos, dev))) {
 			struct in_device *in_dev = __in_dev_get_rcu(dev);
@@ -653,7 +643,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
 		in = nf_bridge->physindev;
 		if (nf_bridge->mask & BRNF_PKT_TYPE) {
 			skb->pkt_type = PACKET_OTHERHOST;
-			nf_bridge->mask ^= BRNF_PKT_TYPE;
+
+			if (!nf_bridge_unset_mask(skb, BRNF_PKT_TYPE)) {
+				kfree_skb(skb);
+				return 0;
+			}
 		}
 		nf_bridge_update_protocol(skb);
 	} else {
@@ -685,11 +679,6 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
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
@@ -706,14 +695,16 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 	nf_bridge = skb->nf_bridge;
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
-		nf_bridge->mask |= BRNF_PKT_TYPE;
+		nf_bridge = nf_bridge_set_mask(skb,
+				(BRNF_PKT_TYPE | BRNF_BRIDGED));
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
@@ -820,7 +811,8 @@ static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
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

