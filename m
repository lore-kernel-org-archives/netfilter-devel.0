From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 44/49]: nfnetlink_queue: use endianness-aware attribute functions
Date: Tue,  4 Dec 2007 13:02:57 +0100 (MET)
Message-ID: <20071204120257.2442.78570.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62239 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXLDMC7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:59 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: use endianness-aware attribute functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d6607c3125212178c2b519dc6304fd38a6ed2ee9
tree a5e532424e0c8f37415f7166b7ba6cb0b17d993d
parent 0f3f456cc6f127fd14808cc03937ddca79057777
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:20 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:35 +0100

 net/netfilter/nfnetlink_queue.c |   60 +++++++++++++++------------------------
 1 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index de48fd3..436b442 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -215,7 +215,6 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	struct sk_buff *entskb = entry->skb;
 	struct net_device *indev;
 	struct net_device *outdev;
-	__be32 tmp_uint;
 
 	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -286,69 +285,57 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	indev = entry->indev;
 	if (indev) {
-		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT_BE32(skb, NFQA_IFINDEX_INDEV, htonl(indev->ifindex));
 #else
 		if (entry->pf == PF_BRIDGE) {
 			/* Case 1: indev is physical input device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NLA_PUT(skb, NFQA_IFINDEX_PHYSINDEV, sizeof(tmp_uint),
-				&tmp_uint);
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_PHYSINDEV,
+				     htonl(indev->ifindex));
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
-			NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
-				&tmp_uint);
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_INDEV,
+				     htonl(indev->br_port->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
-			NLA_PUT(skb, NFQA_IFINDEX_INDEV, sizeof(tmp_uint),
-				&tmp_uint);
-			if (entskb->nf_bridge
-			    && entskb->nf_bridge->physindev) {
-				tmp_uint = htonl(entskb->nf_bridge->physindev->ifindex);
-				NLA_PUT(skb, NFQA_IFINDEX_PHYSINDEV,
-					sizeof(tmp_uint), &tmp_uint);
-			}
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_INDEV,
+				     htonl(indev->ifindex));
+			if (entskb->nf_bridge && entskb->nf_bridge->physindev)
+				NLA_PUT_BE32(skb, NFQA_IFINDEX_PHYSINDEV,
+					     htonl(entskb->nf_bridge->physindev->ifindex));
 		}
 #endif
 	}
 
 	if (outdev) {
-		tmp_uint = htonl(outdev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint), &tmp_uint);
+		NLA_PUT_BE32(skb, NFQA_IFINDEX_OUTDEV, htonl(outdev->ifindex));
 #else
 		if (entry->pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NLA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV, sizeof(tmp_uint),
-				&tmp_uint);
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_PHYSOUTDEV,
+				     htonl(outdev->ifindex));
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(outdev->br_port->br->dev->ifindex);
-			NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
-				&tmp_uint);
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_OUTDEV,
+				     htonl(outdev->br_port->br->dev->ifindex));
 		} else {
 			/* Case 2: outdev is bridge group, we need to look for
 			 * physical output device (when called from ipv4) */
-			NLA_PUT(skb, NFQA_IFINDEX_OUTDEV, sizeof(tmp_uint),
-				&tmp_uint);
-			if (entskb->nf_bridge
-			    && entskb->nf_bridge->physoutdev) {
-				tmp_uint = htonl(entskb->nf_bridge->physoutdev->ifindex);
-				NLA_PUT(skb, NFQA_IFINDEX_PHYSOUTDEV,
-					sizeof(tmp_uint), &tmp_uint);
-			}
+			NLA_PUT_BE32(skb, NFQA_IFINDEX_OUTDEV,
+				     htonl(outdev->ifindex));
+			if (entskb->nf_bridge && entskb->nf_bridge->physoutdev)
+				NLA_PUT_BE32(skb, NFQA_IFINDEX_PHYSOUTDEV,
+					     htonl(entskb->nf_bridge->physoutdev->ifindex));
 		}
 #endif
 	}
 
-	if (entskb->mark) {
-		tmp_uint = htonl(entskb->mark);
-		NLA_PUT(skb, NFQA_MARK, sizeof(u_int32_t), &tmp_uint);
-	}
+	if (entskb->mark)
+		NLA_PUT_BE32(skb, NFQA_MARK, htonl(entskb->mark));
 
 	if (indev && entskb->dev) {
 		struct nfqnl_msg_packet_hw phw;
@@ -670,8 +657,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (nfqa[NFQA_MARK])
-		entry->skb->mark = ntohl(*(__be32 *)
-					 nla_data(nfqa[NFQA_MARK]));
+		entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
 
 	nf_reinject(entry, verdict);
 	return 0;
