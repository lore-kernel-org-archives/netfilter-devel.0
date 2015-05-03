From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: bridge: neigh_head and physoutdev can't be used at same time
Date: Sun,  3 May 2015 22:05:28 +0200
Message-ID: <1430683528-29050-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44687 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbbECUFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2015 16:05:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The neigh_header is only needed when we detect DNAT after prerouting
and neigh cache didn't have a mac address for us.

The output port has not been chosen yet so we can re-use the storage
area, bringing struct size down to 32 bytes on x86_64.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h    | 8 +++++---
 net/bridge/br_netfilter.c | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 66e374d..2cea360 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -170,12 +170,14 @@ struct nf_bridge_info {
 		BRNF_PROTO_UNCHANGED,
 		BRNF_PROTO_8021Q,
 		BRNF_PROTO_PPPOE
-	} orig_proto;
+	} orig_proto:8;
 	bool			pkt_otherhost;
 	unsigned int		mask;
 	struct net_device	*physindev;
-	struct net_device	*physoutdev;
-	char			neigh_header[8];
+	union {
+		struct net_device *physoutdev;
+		char neigh_header[8];
+	};
 };
 #endif
 
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ab55e24..13973da 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -973,6 +973,8 @@ static void br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
 				       nf_bridge->neigh_header,
 				       ETH_HLEN - ETH_ALEN);
 	skb->dev = nf_bridge->physindev;
+
+	nf_bridge->physoutdev = NULL;
 	br_handle_frame_finish(NULL, skb);
 }
 
-- 
2.0.5

