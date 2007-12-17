From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 52/64]: nfnetlink_log: use endianness-aware attribute functions
Date: Tue, 18 Dec 2007 00:47:24 +0100 (MET)
Message-ID: <20071217234723.23601.73519.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39043 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbXLQXrZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:25 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: use endianness-aware attribute functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 46b6c5e9e3b9e78d9a2a0d73429d269d7f82c26a
tree 14269c8a3dc1c64a4969f6e54e35538b747b7945
parent 686a5513787ed3d89766bb4d8634bbbd43d519dd
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:44 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 net/netfilter/nfnetlink_log.c |   87 ++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 52 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index ac58dc9..950b1f0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -389,32 +389,27 @@ __build_packet_message(struct nfulnl_instance *inst,
 		NLA_PUT(inst->skb, NFULA_PREFIX, plen, prefix);
 
 	if (indev) {
-		tmp_uint = htonl(indev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV, sizeof(tmp_uint),
-			&tmp_uint);
+		NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_INDEV,
+			     htonl(indev->ifindex));
 #else
 		if (pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical input device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
-				sizeof(tmp_uint), &tmp_uint);
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_PHYSINDEV,
+				     htonl(indev->ifindex));
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(indev->br_port->br->dev->ifindex);
-			NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
-				sizeof(tmp_uint), &tmp_uint);
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_INDEV,
+				     htonl(indev->br_port->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
-			NLA_PUT(inst->skb, NFULA_IFINDEX_INDEV,
-				sizeof(tmp_uint), &tmp_uint);
-			if (skb->nf_bridge && skb->nf_bridge->physindev) {
-				tmp_uint =
-				    htonl(skb->nf_bridge->physindev->ifindex);
-				NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSINDEV,
-					sizeof(tmp_uint), &tmp_uint);
-			}
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_INDEV,
+				     htonl(indev->ifindex));
+			if (skb->nf_bridge && skb->nf_bridge->physindev)
+				NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_PHYSINDEV,
+					     htonl(skb->nf_bridge->physindev->ifindex));
 		}
 #endif
 	}
@@ -422,38 +417,32 @@ __build_packet_message(struct nfulnl_instance *inst,
 	if (outdev) {
 		tmp_uint = htonl(outdev->ifindex);
 #ifndef CONFIG_BRIDGE_NETFILTER
-		NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV, sizeof(tmp_uint),
-			&tmp_uint);
+		NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_OUTDEV,
+			     htonl(outdev->ifindex));
 #else
 		if (pf == PF_BRIDGE) {
 			/* Case 1: outdev is physical output device, we need to
 			 * look for bridge group (when called from
 			 * netfilter_bridge) */
-			NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
-				sizeof(tmp_uint), &tmp_uint);
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
+				     htonl(outdev->ifindex));
 			/* this is the bridge group "brX" */
-			tmp_uint = htonl(outdev->br_port->br->dev->ifindex);
-			NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
-				sizeof(tmp_uint), &tmp_uint);
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_OUTDEV,
+				     htonl(outdev->br_port->br->dev->ifindex));
 		} else {
 			/* Case 2: indev is a bridge group, we need to look
 			 * for physical device (when called from ipv4) */
-			NLA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
-				sizeof(tmp_uint), &tmp_uint);
-			if (skb->nf_bridge && skb->nf_bridge->physoutdev) {
-				tmp_uint =
-				    htonl(skb->nf_bridge->physoutdev->ifindex);
-				NLA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
-					sizeof(tmp_uint), &tmp_uint);
-			}
+			NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_OUTDEV,
+				     htonl(outdev->ifindex));
+			if (skb->nf_bridge && skb->nf_bridge->physoutdev)
+				NLA_PUT_BE32(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,
+					     htonl(skb->nf_bridge->physoutdev->ifindex));
 		}
 #endif
 	}
 
-	if (skb->mark) {
-		tmp_uint = htonl(skb->mark);
-		NLA_PUT(inst->skb, NFULA_MARK, sizeof(tmp_uint), &tmp_uint);
-	}
+	if (skb->mark)
+		NLA_PUT_BE32(inst->skb, NFULA_MARK, htonl(skb->mark));
 
 	if (indev && skb->dev) {
 		struct nfulnl_msg_packet_hw phw;
@@ -480,21 +469,19 @@ __build_packet_message(struct nfulnl_instance *inst,
 			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
 			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
-			NLA_PUT(inst->skb, NFULA_UID, sizeof(uid), &uid);
+			NLA_PUT_BE32(inst->skb, NFULA_UID, uid);
 		} else
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
 	/* local sequence number */
-	if (inst->flags & NFULNL_CFG_F_SEQ) {
-		tmp_uint = htonl(inst->seq++);
-		NLA_PUT(inst->skb, NFULA_SEQ, sizeof(tmp_uint), &tmp_uint);
-	}
+	if (inst->flags & NFULNL_CFG_F_SEQ)
+		NLA_PUT_BE32(inst->skb, NFULA_SEQ, htonl(inst->seq++));
+
 	/* global sequence number */
-	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL) {
-		tmp_uint = htonl(atomic_inc_return(&global_seq));
-		NLA_PUT(inst->skb, NFULA_SEQ_GLOBAL, sizeof(tmp_uint), &tmp_uint);
-	}
+	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
+		NLA_PUT_BE32(inst->skb, NFULA_SEQ_GLOBAL,
+			     htonl(atomic_inc_return(&global_seq)));
 
 	if (data_len) {
 		struct nlattr *nla;
@@ -775,8 +762,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (nfula[NFULA_CFG_TIMEOUT]) {
-		__be32 timeout =
-			*(__be32 *)nla_data(nfula[NFULA_CFG_TIMEOUT]);
+		__be32 timeout = nla_get_be32(nfula[NFULA_CFG_TIMEOUT]);
 
 		if (!inst) {
 			ret = -ENODEV;
@@ -786,8 +772,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (nfula[NFULA_CFG_NLBUFSIZ]) {
-		__be32 nlbufsiz =
-			*(__be32 *)nla_data(nfula[NFULA_CFG_NLBUFSIZ]);
+		__be32 nlbufsiz = nla_get_be32(nfula[NFULA_CFG_NLBUFSIZ]);
 
 		if (!inst) {
 			ret = -ENODEV;
@@ -797,8 +782,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (nfula[NFULA_CFG_QTHRESH]) {
-		__be32 qthresh =
-			*(__be32 *)nla_data(nfula[NFULA_CFG_QTHRESH]);
+		__be32 qthresh = nla_get_be32(nfula[NFULA_CFG_QTHRESH]);
 
 		if (!inst) {
 			ret = -ENODEV;
@@ -808,8 +792,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	}
 
 	if (nfula[NFULA_CFG_FLAGS]) {
-		__be16 flags =
-			*(__be16 *)nla_data(nfula[NFULA_CFG_FLAGS]);
+		__be16 flags = nla_get_be16(nfula[NFULA_CFG_FLAGS]);
 
 		if (!inst) {
 			ret = -ENODEV;
