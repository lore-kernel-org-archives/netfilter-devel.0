From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: add and use nf_fwd_netdev_egress
Date: Mon, 28 Nov 2016 11:40:06 +0100
Message-ID: <1480329606-6592-3-git-send-email-fw@strlen.de>
References: <1480329606-6592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35038 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754384AbcK1Kjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 05:39:55 -0500
In-Reply-To: <1480329606-6592-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... so we can use current skb instead of working with a clone.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_dup_netdev.h |  1 +
 net/netfilter/nf_dup_netdev.c         | 33 +++++++++++++++++++++++++--------
 net/netfilter/nft_fwd_netdev.c        |  4 ++--
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 397dcae349f9..3e919356bedf 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -2,5 +2,6 @@
 #define _NF_DUP_NETDEV_H_
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
+void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
 #endif
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 44ae986c383f..49c38855f547 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -14,6 +14,29 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
+static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
+{
+	if (skb_mac_header_was_set(skb))
+		skb_push(skb, skb->mac_len);
+
+	skb->dev = dev;
+	dev_queue_xmit(skb);
+}
+
+void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif)
+{
+	struct net_device *dev;
+
+	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
+	if (!dev) {
+		kfree_skb(pkt->skb);
+		return;
+	}
+
+	nf_do_netdev_egress(pkt->skb, dev);
+}
+EXPORT_SYMBOL_GPL(nf_fwd_netdev_egress);
+
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 {
 	struct net_device *dev;
@@ -24,14 +47,8 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
-	if (skb == NULL)
-		return;
-
-	if (skb_mac_header_was_set(skb))
-		skb_push(skb, skb->mac_len);
-
-	skb->dev = dev;
-	dev_queue_xmit(skb);
+	if (skb)
+		nf_do_netdev_egress(skb, dev);
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 763ebc3e0b2b..ce13a50b9189 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -26,8 +26,8 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
-	nf_dup_netdev_egress(pkt, oif);
-	regs->verdict.code = NF_DROP;
+	nf_fwd_netdev_egress(pkt, oif);
+	regs->verdict.code = NF_STOLEN;
 }
 
 static const struct nla_policy nft_fwd_netdev_policy[NFTA_FWD_MAX + 1] = {
-- 
2.7.3

