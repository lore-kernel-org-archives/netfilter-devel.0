From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 4/4] netfilter: bridge: refactor frag_max_size
Date: Thu, 28 May 2015 10:25:44 +0200
Message-ID: <1432801544-11936-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.134]:31246 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbE1I0P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 04:26:15 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id DC8F41073609
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 10:26:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently frag_max_size is member of br_input_skb_cb and copied back and
forth using IPCB(skb) and BR_INPUT_SKB_CB(skb) each time it is changed or
used.

Attach frag_max_size to nf_bridge_info and set value in pre_routing and
forward functions and use its value in forward and xmit functions.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
 include/linux/skbuff.h    |    1 +
 net/bridge/br_netfilter.c |   28 +++++++++++-----------------
 net/bridge/br_private.h   |    1 -
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 369643b..1def030 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -175,6 +175,7 @@ struct nf_bridge_info {
 		BRNF_PROTO_PPPOE
 	} orig_proto:8;
 	bool			pkt_otherhost;
+	__u16			frag_max_size;
 	unsigned int		mask;
 	struct net_device	*physindev;
 	union {
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index f34edb6..048f5cb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -455,10 +455,8 @@ static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	struct net_device *dev = skb->dev;
 	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
-	int frag_max_size;
 
-	frag_max_size = IP6CB(skb)->frag_max_size;
-	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+	nf_bridge->frag_max_size = IP6CB(skb)->frag_max_size;
 
 	if (nf_bridge->pkt_otherhost) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -551,10 +549,8 @@ static int br_nf_pre_routing_finish(struct sock *sk, struct sk_buff *skb)
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct rtable *rt;
 	int err;
-	int frag_max_size;
 
-	frag_max_size = IPCB(skb)->frag_max_size;
-	BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+	nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
 
 	if (nf_bridge->pkt_otherhost) {
 		skb->pkt_type = PACKET_OTHERHOST;
@@ -775,15 +771,12 @@ static int br_nf_forward_finish(struct sock *sk, struct sk_buff *skb)
 	struct net_device *in;
 
 	if (!IS_ARP(skb) && !IS_VLAN_ARP(skb)) {
-		int frag_max_size;
 
 		if (skb->protocol == htons(ETH_P_IP)) {
-			frag_max_size = IPCB(skb)->frag_max_size;
-			BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+			nf_bridge->frag_max_size = IPCB(skb)->frag_max_size;
 		}
 		if (skb->protocol == htons(ETH_P_IPV6)) {
-			frag_max_size = IP6CB(skb)->frag_max_size;
-			BR_INPUT_SKB_CB(skb)->frag_max_size = frag_max_size;
+			nf_bridge->frag_max_size = IP6CB(skb)->frag_max_size;
 		}
 
 		in = nf_bridge->physindev;
@@ -846,18 +839,16 @@ static unsigned int br_nf_forward_ip(const struct nf_hook_ops *ops,
 		nf_bridge->pkt_otherhost = true;
 	}
 
-	int frag_max = BR_INPUT_SKB_CB(skb)->frag_max_size;
-
 	if (pf == NFPROTO_IPV4) {
 		if (br_validate_ipv4(skb))
 			return NF_DROP;
-		IPCB(skb)->frag_max_size = frag_max;
+		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 	}
 
 	if (pf == NFPROTO_IPV6) {
 		if (br_validate_ipv6(skb))
 			return NF_DROP;
-		IP6CB(skb)->frag_max_size = frag_max;
+		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 	}
 
 	nf_bridge->physoutdev = skb->dev;
@@ -950,8 +941,11 @@ static int br_nf_ip_fragment(struct sock *sk, struct sk_buff *skb,
 
 static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 {
+	struct nf_bridge_info *nf_bridge;
 	unsigned int mtu_reserved;
 
+	nf_bridge = nf_bridge_info_get(skb);
+
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
 	if (skb_is_gso(skb) || skb->len + mtu_reserved <= skb->dev->mtu) {
 		nf_bridge_info_free(skb);
@@ -969,7 +963,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 			/* Drop invalid packet */
 			return NF_DROP;
 
-		IPCB(skb)->frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
 		nf_bridge_update_protocol(skb);
 
@@ -992,7 +986,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 			/* Drop invalid packet */
 			return NF_DROP;
 
-		IP6CB(skb)->frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
 		nf_bridge_update_protocol(skb);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index fc71894..5dccced 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -308,7 +308,6 @@ struct br_input_skb_cb {
 	int mrouters_only;
 #endif
 
-	u16 frag_max_size;
 	bool proxyarp_replied;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-- 
1.7.10.4

