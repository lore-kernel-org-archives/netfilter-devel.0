From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: bridge: free nf_bridge info on xmit
Date: Sun,  3 May 2015 22:06:07 +0200
Message-ID: <1430683567-29185-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44689 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbbECUGM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2015 16:06:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_bridge information is only needed for -m physdev, so we can always free
it after POST_ROUTING.  This has the advantage that allocation and free will
typically happen on the same cpu.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
last changed line had spaces instead of tab, thats why it appears in diff.

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 13973da..2b0e8bb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -129,6 +129,14 @@ static struct nf_bridge_info *nf_bridge_info_get(const struct sk_buff *skb)
 	return skb->nf_bridge;
 }
 
+static void nf_bridge_info_free(struct sk_buff *skb)
+{
+	if (skb->nf_bridge) {
+		nf_bridge_put(skb->nf_bridge);
+		skb->nf_bridge = NULL;
+	}
+}
+
 static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
 	struct net_bridge_port *port;
@@ -841,6 +849,7 @@ static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
 	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
 	__skb_push(skb, data->encap_size);
 
+	nf_bridge_info_free(skb);
 	return br_dev_queue_push_xmit(sk, skb);
 }
 
@@ -850,8 +859,10 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 	int frag_max_size;
 	unsigned int mtu_reserved;
 
-	if (skb_is_gso(skb) || skb->protocol != htons(ETH_P_IP))
+	if (skb_is_gso(skb) || skb->protocol != htons(ETH_P_IP)) {
+		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(sk, skb);
+	}
 
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
 	/* This is wrong! We should preserve the original fragment
@@ -877,6 +888,7 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 
 		ret = ip_fragment(sk, skb, br_nf_push_frag_xmit);
 	} else {
+		nf_bridge_info_free(skb);
 		ret = br_dev_queue_push_xmit(sk, skb);
 	}
 
@@ -885,7 +897,8 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 #else
 static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
 {
-        return br_dev_queue_push_xmit(sk, skb);
+	nf_bridge_info_free(skb);
+	return br_dev_queue_push_xmit(sk, skb);
 }
 #endif
 
-- 
2.0.5

