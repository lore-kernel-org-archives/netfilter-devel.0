From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH 2/3] netfilter: bridge: re-order br_nf_pre_routing_finish_ipv6()
Date: Sat, 30 May 2015 15:26:57 +0200
Message-ID: <1432992417-4016-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.132]:57699 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbbE3N1g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 May 2015 09:27:36 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id E87531107E20
	for <netfilter-devel@vger.kernel.org>; Sat, 30 May 2015 15:27:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Put br_nf_pre_routing_finish_ipv6() after daddr_was_changed() and
br_nf_pre_routing_finish_bridge() to prepare calling these functions
from there.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
Patch revision history:

v1
* was originally a part of "netfilter: bridge: detect NAT66 correctly and
  change MAC address"

 net/bridge/br_netfilter.c |   63 +++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 2651876..6cb642c 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -278,37 +278,6 @@ static void nf_bridge_update_protocol(struct sk_buff *skb)
 	}
 }
 
-/* PF_BRIDGE/PRE_ROUTING *********************************************/
-/* Undo the changes made for ip6tables PREROUTING and continue the
- * bridge PRE_ROUTING hook. */
-static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
-{
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
-	struct rtable *rt;
-
-	if (nf_bridge->pkt_otherhost) {
-		skb->pkt_type = PACKET_OTHERHOST;
-		nf_bridge->pkt_otherhost = false;
-	}
-	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
-
-	rt = bridge_parent_rtable(nf_bridge->physindev);
-	if (!rt) {
-		kfree_skb(skb);
-		return 0;
-	}
-	skb_dst_set_noref(skb, &rt->dst);
-
-	skb->dev = nf_bridge->physindev;
-	nf_bridge_update_protocol(skb);
-	nf_bridge_push_encap_header(skb);
-	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, sk, skb,
-		       skb->dev, NULL,
-		       br_handle_frame_finish, 1);
-
-	return 0;
-}
-
 /* Obtain the correct destination MAC address, while preserving the original
  * source MAC address. If we already know this address, we just copy it. If we
  * don't, we use the neighbour framework to find out. In both cases, we make
@@ -360,6 +329,38 @@ static bool daddr_was_changed(const struct sk_buff *skb,
 	return ip_hdr(skb)->daddr != nf_bridge->ipv4_daddr;
 }
 
+/* PF_BRIDGE/PRE_ROUTING *********************************************/
+/* Undo the changes made for ip6tables PREROUTING and continue the
+ * bridge PRE_ROUTING hook.
+ */
+static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
+{
+	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	struct rtable *rt;
+
+	if (nf_bridge->pkt_otherhost) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->pkt_otherhost = false;
+	}
+	nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING;
+
+	rt = bridge_parent_rtable(nf_bridge->physindev);
+	if (!rt) {
+		kfree_skb(skb);
+		return 0;
+	}
+	skb_dst_set_noref(skb, &rt->dst);
+
+	skb->dev = nf_bridge->physindev;
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, sk, skb,
+		       skb->dev, NULL,
+		       br_handle_frame_finish, 1);
+
+	return 0;
+}
+
 /* This requires some explaining. If DNAT has taken place,
  * we will need to fix up the destination Ethernet address.
  * This is also true when SNAT takes place (for the reply direction).
-- 
1.7.10.4

