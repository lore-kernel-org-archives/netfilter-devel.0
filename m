From: Kevin Locke <kevin@kevinlocke.name>
Subject: [xtables-addons][PATCH 1/2] Rename skb->iif to skb->skb_iif for after 2.6.32
Date: Sat, 19 Dec 2009 13:50:46 -0700
Message-ID: <1261255847-16395-2-git-send-email-kevin@kevinlocke.name>
References: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Cc: Kevin Locke <kevin@kevinlocke.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cluster2.bresnan.net ([69.145.248.57]:33003 "EHLO
	blnmtfh2svavs.cluster1.bresnan.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753514AbZLSVGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:06:10 -0500
In-Reply-To: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The rename occurred in 8964be4a9a5ca8cab1219bb046db2f6d1936227c,
which will hit mainline in 2.6.33.

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---
 extensions/compat_skbuff.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/extensions/compat_skbuff.h b/extensions/compat_skbuff.h
index 2778fb4..df210f5 100644
--- a/extensions/compat_skbuff.h
+++ b/extensions/compat_skbuff.h
@@ -25,9 +25,12 @@ static inline struct rtable *skb_rtable(const struct sk_buff *skb)
 #	define skb_ifindex(skb) \
 		(((skb)->input_dev != NULL) ? (skb)->input_dev->ifindex : 0)
 #	define skb_nfmark(skb) (((struct sk_buff *)(skb))->nfmark)
-#else
+#elif LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 32)
 #	define skb_ifindex(skb) (skb)->iif
 #	define skb_nfmark(skb) (((struct sk_buff *)(skb))->mark)
+#else
+#	define skb_ifindex(skb) (skb)->skb_iif
+#	define skb_nfmark(skb) (((struct sk_buff *)(skb))->mark)
 #endif
 
 #ifdef CONFIG_NETWORK_SECMARK
-- 
1.6.5

