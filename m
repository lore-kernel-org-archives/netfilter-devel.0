From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: bridge: fix NULL deref in physin/out ifindex helpers
Date: Mon, 20 Apr 2015 12:35:47 +0200
Message-ID: <1429526147-4058-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47047 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbbDTKfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2015 06:35:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Might not have an outdev yet. We'll oops when iface goes down while skbs
are still nfqueue'd:

RIP: 0010:[<ffffffff81422a2f>]  [<ffffffff81422a2f>] dev_cmp+0x4f/0x80
nfqnl_rcv_dev_event+0xe2/0x150
notifier_call_chain+0x53/0xa0

Fixes: c737b7c4510026 ("netfilter: bridge: add helpers for fetching physin/outdev")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index ab8f76d..f2fdb5a 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -39,12 +39,24 @@ static inline void br_drop_fake_rtable(struct sk_buff *skb)
 
 static inline int nf_bridge_get_physinif(const struct sk_buff *skb)
 {
-	return skb->nf_bridge ? skb->nf_bridge->physindev->ifindex : 0;
+	struct nf_bridge_info *nf_bridge;
+
+	if (skb->nf_bridge == NULL)
+		return 0;
+
+	nf_bridge = skb->nf_bridge;
+	return nf_bridge->physindev ? nf_bridge->physindev->ifindex : 0;
 }
 
 static inline int nf_bridge_get_physoutif(const struct sk_buff *skb)
 {
-	return skb->nf_bridge ? skb->nf_bridge->physoutdev->ifindex : 0;
+	struct nf_bridge_info *nf_bridge;
+
+	if (skb->nf_bridge == NULL)
+		return 0;
+
+	nf_bridge = skb->nf_bridge;
+	return nf_bridge->physoutdev ? nf_bridge->physoutdev->ifindex : 0;
 }
 
 static inline struct net_device *
-- 
2.0.5

