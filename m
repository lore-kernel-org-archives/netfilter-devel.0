From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_ct: fix expiration getter
Date: Wed,  6 Jul 2016 14:53:06 +0200
Message-ID: <1467809586-15950-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58364 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbcGFMy3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 08:54:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to compute timeout.expires - jiffies, not the other way around.
Add a helper, another patch can then later change more places in
conntrack code where we currently open-code this.

Will allow us to only change one place later when we remove per-ct timer.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 8 ++++++++
 net/netfilter/nft_ct.c               | 6 +-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index dd78bea..b6083c3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -284,6 +284,14 @@ static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 	return skb->dev && skb->skb_iif && skb->dev->flags & IFF_LOOPBACK;
 }
 
+/* jiffies until ct expires, 0 if already expired */
+static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
+{
+	long timeout = (long)ct->timeout.expires - (long)jiffies;
+
+	return timeout > 0 ? timeout : 0;
+}
+
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 137e308..81fbb45 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -54,7 +54,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	const struct nf_conn_help *help;
 	const struct nf_conntrack_tuple *tuple;
 	const struct nf_conntrack_helper *helper;
-	long diff;
 	unsigned int state;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
@@ -94,10 +93,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 #endif
 	case NFT_CT_EXPIRATION:
-		diff = (long)jiffies - (long)ct->timeout.expires;
-		if (diff < 0)
-			diff = 0;
-		*dest = jiffies_to_msecs(diff);
+		*dest = jiffies_to_msecs(nf_ct_expires(ct));
 		return;
 	case NFT_CT_HELPER:
 		if (ct->master == NULL)
-- 
2.7.3

