From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH 1/1] Add IPv6 match debug print code
Date: Thu, 27 Jan 2011 18:37:17 +0100
Message-ID: <1296149837-2574-1-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:46356 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1A0RhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:37:21 -0500
Received: from [192.168.1.110] (helo=mailin01.ims-firmen.de)
	by mailout01.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PiVmZ-00036a-5j
	for netfilter-devel@vger.kernel.org; Thu, 27 Jan 2011 18:37:19 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 net/netfilter/xt_iprange.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 77b9ebc..d3eb5ed 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -78,15 +78,27 @@ iprange_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		m  = iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
-		if (m)
+		if (m) {
+			pr_debug("src IP %pI6 NOT in range %s%pI6-%pI6\n",
+				 &iph->saddr,
+				 (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
+				 &info->src_min.in6,
+				 &info->src_max.in6);
 			return false;
+		}
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
 		m |= iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
 		m ^= !!(info->flags & IPRANGE_DST_INV);
-		if (m)
+		if (m) {
+			pr_debug("dst IP %pI6 NOT in range %s%pI6-%pI6\n",
+				 &iph->daddr,
+				 (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
+				 &info->dst_min.in6,
+				 &info->dst_max.in6);
 			return false;
+		}
 	}
 	return true;
 }
-- 
1.5.6.5

