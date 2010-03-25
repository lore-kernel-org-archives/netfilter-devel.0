From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/12] netfilter: decnet: use NFPROTO values for NF_HOOK invocation
Date: Thu, 25 Mar 2010 17:04:16 +0100
Message-ID: <1269533065-22318-5-git-send-email-jengelh@medozas.de>
References: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41687 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab0CYQEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:04:35 -0400
In-Reply-To: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The semantic patch used was:
// <smpl>
@@
@@
 NF_HOOK(
-PF_DECnet,
+NFPROTO_DECNET,
 ...)
// </smpl>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/decnet/dn_neigh.c  |    9 ++++++---
 net/decnet/dn_nsp_in.c |    3 ++-
 net/decnet/dn_route.c  |   28 ++++++++++++++++++++--------
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 794b5bf..76622c0 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -265,7 +265,8 @@ static int dn_long_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+		       neigh->dev, dn_neigh_output_packet);
 }
 
 static int dn_short_output(struct sk_buff *skb)
@@ -304,7 +305,8 @@ static int dn_short_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+		       neigh->dev, dn_neigh_output_packet);
 }
 
 /*
@@ -346,7 +348,8 @@ static int dn_phase3_output(struct sk_buff *skb)
 
 	skb_reset_network_header(skb);
 
-	return NF_HOOK(PF_DECnet, NF_DN_POST_ROUTING, skb, NULL, neigh->dev, dn_neigh_output_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_POST_ROUTING, skb, NULL,
+		       neigh->dev, dn_neigh_output_packet);
 }
 
 /*
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 932408d..65531ad 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -809,7 +809,8 @@ free_out:
 
 int dn_nsp_rx(struct sk_buff *skb)
 {
-	return NF_HOOK(PF_DECnet, NF_DN_LOCAL_IN, skb, skb->dev, NULL, dn_nsp_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_IN, skb, skb->dev, NULL,
+		       dn_nsp_rx_packet);
 }
 
 /*
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index a7bf03c..86eca5f 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -517,7 +517,8 @@ static int dn_route_rx_long(struct sk_buff *skb)
 	ptr++;
 	cb->hops = *ptr++; /* Visit Count */
 
-	return NF_HOOK(PF_DECnet, NF_DN_PRE_ROUTING, skb, skb->dev, NULL, dn_route_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING, skb, skb->dev, NULL,
+		       dn_route_rx_packet);
 
 drop_it:
 	kfree_skb(skb);
@@ -543,7 +544,8 @@ static int dn_route_rx_short(struct sk_buff *skb)
 	ptr += 2;
 	cb->hops = *ptr & 0x3f;
 
-	return NF_HOOK(PF_DECnet, NF_DN_PRE_ROUTING, skb, skb->dev, NULL, dn_route_rx_packet);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_PRE_ROUTING, skb, skb->dev, NULL,
+		       dn_route_rx_packet);
 
 drop_it:
 	kfree_skb(skb);
@@ -645,16 +647,24 @@ int dn_route_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type
 
 		switch(flags & DN_RT_CNTL_MSK) {
 			case DN_RT_PKT_HELO:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_route_ptp_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+					       skb, skb->dev, NULL,
+					       dn_route_ptp_hello);
 
 			case DN_RT_PKT_L1RT:
 			case DN_RT_PKT_L2RT:
-				return NF_HOOK(PF_DECnet, NF_DN_ROUTE, skb, skb->dev, NULL, dn_route_discard);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_ROUTE,
+					       skb, skb->dev, NULL,
+					       dn_route_discard);
 			case DN_RT_PKT_ERTH:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_neigh_router_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+					       skb, skb->dev, NULL,
+					       dn_neigh_router_hello);
 
 			case DN_RT_PKT_EEDH:
-				return NF_HOOK(PF_DECnet, NF_DN_HELLO, skb, skb->dev, NULL, dn_neigh_endnode_hello);
+				return NF_HOOK(NFPROTO_DECNET, NF_DN_HELLO,
+					       skb, skb->dev, NULL,
+					       dn_neigh_endnode_hello);
 		}
 	} else {
 		if (dn->parms.state != DN_DEV_S_RU)
@@ -703,7 +713,8 @@ static int dn_output(struct sk_buff *skb)
 	cb->rt_flags |= DN_RT_F_IE;
 	cb->hops = 0;
 
-	return NF_HOOK(PF_DECnet, NF_DN_LOCAL_OUT, skb, NULL, dev, neigh->output);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_LOCAL_OUT, skb, NULL, dev,
+		       neigh->output);
 
 error:
 	if (net_ratelimit())
@@ -752,7 +763,8 @@ static int dn_forward(struct sk_buff *skb)
 	if (rt->rt_flags & RTCF_DOREDIRECT)
 		cb->rt_flags |= DN_RT_F_IE;
 
-	return NF_HOOK(PF_DECnet, NF_DN_FORWARD, skb, dev, skb->dev, neigh->output);
+	return NF_HOOK(NFPROTO_DECNET, NF_DN_FORWARD, skb, dev, skb->dev,
+		       neigh->output);
 
 drop:
 	kfree_skb(skb);
-- 
1.7.0.2

