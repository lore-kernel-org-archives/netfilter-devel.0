From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/9] netfilter: xtables: clean up xt_mac match routine
Date: Wed, 17 Mar 2010 14:18:59 +0100
Message-ID: <1268831945-6041-5-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59355 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CQNTU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:20 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_mac.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index c200711..2039d07 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -26,14 +26,16 @@ MODULE_ALIAS("ip6t_mac");
 
 static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-    const struct xt_mac_info *info = par->matchinfo;
-
-    /* Is mac pointer valid? */
-    return skb_mac_header(skb) >= skb->head &&
-	   skb_mac_header(skb) + ETH_HLEN <= skb->data
-	   /* If so, compare... */
-	   && ((!compare_ether_addr(eth_hdr(skb)->h_source, info->srcaddr))
-		^ info->invert);
+	const struct xt_mac_info *info = par->matchinfo;
+	bool ret;
+
+	if (skb_mac_header(skb) < skb->head)
+		return false;
+	if (skb_mac_header(skb) + ETH_HLEN > skb->data)
+		return false;
+	ret  = compare_ether_addr(eth_hdr(skb)->h_source, info->srcaddr) == 0;
+	ret ^= info->invert;
+	return ret;
 }
 
 static struct xt_match mac_mt_reg __read_mostly = {
-- 
1.7.0.2

