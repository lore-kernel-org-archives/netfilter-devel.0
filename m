From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/12] netfilter: bridge: move nf_bridge_update_protocol to where its used
Date: Mon,  9 Mar 2015 18:14:33 +0100
Message-ID: <1425921275-9171-11-git-send-email-pablo@netfilter.org>
References: <1425921275-9171-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47251 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbbCIRLO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2015 13:11:14 -0400
In-Reply-To: <1425921275-9171-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

no need to keep it in a header file.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge.h |    8 --------
 net/bridge/br_netfilter.c        |    8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 332ef8a..dd580a9 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -36,14 +36,6 @@ static inline unsigned int nf_bridge_encap_header_len(const struct sk_buff *skb)
 	}
 }
 
-static inline void nf_bridge_update_protocol(struct sk_buff *skb)
-{
-	if (skb->nf_bridge->mask & BRNF_8021Q)
-		skb->protocol = htons(ETH_P_8021Q);
-	else if (skb->nf_bridge->mask & BRNF_PPPoE)
-		skb->protocol = htons(ETH_P_PPP_SES);
-}
-
 static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
 {
 	if (unlikely(skb->nf_bridge->mask & BRNF_PPPoE))
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index e547911..5b3bceb 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -239,6 +239,14 @@ drop:
 	return -1;
 }
 
+static void nf_bridge_update_protocol(struct sk_buff *skb)
+{
+	if (skb->nf_bridge->mask & BRNF_8021Q)
+		skb->protocol = htons(ETH_P_8021Q);
+	else if (skb->nf_bridge->mask & BRNF_PPPoE)
+		skb->protocol = htons(ETH_P_PPP_SES);
+}
+
 /* PF_BRIDGE/PRE_ROUTING *********************************************/
 /* Undo the changes made for ip6tables PREROUTING and continue the
  * bridge PRE_ROUTING hook. */
-- 
1.7.10.4

