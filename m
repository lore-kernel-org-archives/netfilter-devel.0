From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 5/6] netfilter: bridge: start splitting mask into public/private chunks
Date: Thu,  2 Apr 2015 14:31:44 +0200
Message-ID: <1427977905-9927-6-git-send-email-fw@strlen.de>
References: <1427977905-9927-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44237 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbbDBMb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 08:31:57 -0400
In-Reply-To: <1427977905-9927-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

->mask is a bit info field that mixes various use cases.

In particular, we have flags that are mutually exlusive, and flags that
are only used within br_netfilter while others need to be exposed to
other parts of the kernel.

Remove BRNF_8021Q/PPPoE flags.  They're mutually exclusive and only
needed within br_netfilter context.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
 - rebase without (deferred) ip_fragment patch.
  this means nf_bridge_mtu_reduction() cannot be moved
  to br_netfilter.c for now.

 include/linux/netfilter_bridge.h |  4 +---
 include/linux/skbuff.h           |  5 +++++
 net/bridge/br_netfilter.c        | 15 +++++++++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index e1d96bc..d47a32d 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -20,12 +20,10 @@ enum nf_br_hook_priorities {
 #define BRNF_PKT_TYPE			0x01
 #define BRNF_BRIDGED_DNAT		0x02
 #define BRNF_NF_BRIDGE_PREROUTING	0x08
-#define BRNF_8021Q			0x10
-#define BRNF_PPPoE			0x20
 
 static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
 {
-	if (unlikely(skb->nf_bridge->mask & BRNF_PPPoE))
+	if (skb->nf_bridge->orig_proto == BRNF_PROTO_PPPOE)
 		return PPPOE_SES_HLEN;
 	return 0;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f66a089..6f75fb5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -166,6 +166,11 @@ struct nf_conntrack {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
 	atomic_t		use;
+	enum {
+		BRNF_PROTO_UNCHANGED,
+		BRNF_PROTO_8021Q,
+		BRNF_PROTO_PPPOE
+	} orig_proto;
 	unsigned int		mask;
 	struct net_device	*physindev;
 	struct net_device	*physoutdev;
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 301f12b..ab1e988 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -262,10 +262,16 @@ drop:
 
 static void nf_bridge_update_protocol(struct sk_buff *skb)
 {
-	if (skb->nf_bridge->mask & BRNF_8021Q)
+	switch (skb->nf_bridge->orig_proto) {
+	case BRNF_PROTO_8021Q:
 		skb->protocol = htons(ETH_P_8021Q);
-	else if (skb->nf_bridge->mask & BRNF_PPPoE)
+		break;
+	case BRNF_PROTO_PPPOE:
 		skb->protocol = htons(ETH_P_PPP_SES);
+		break;
+	case BRNF_PROTO_UNCHANGED:
+		break;
+	}
 }
 
 /* PF_BRIDGE/PRE_ROUTING *********************************************/
@@ -503,10 +509,11 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
 	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
 	nf_bridge->physindev = skb->dev;
 	skb->dev = brnf_get_logical_dev(skb, skb->dev);
+
 	if (skb->protocol == htons(ETH_P_8021Q))
-		nf_bridge->mask |= BRNF_8021Q;
+		nf_bridge->orig_proto = BRNF_PROTO_8021Q;
 	else if (skb->protocol == htons(ETH_P_PPP_SES))
-		nf_bridge->mask |= BRNF_PPPoE;
+		nf_bridge->orig_proto = BRNF_PROTO_PPPOE;
 
 	/* Must drop socket now because of tproxy. */
 	skb_orphan(skb);
-- 
2.0.5

