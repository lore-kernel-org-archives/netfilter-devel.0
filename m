From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH 2/2] Add IPv6 match debug print code
Date: Wed, 26 Jan 2011 18:22:51 +0100
Message-ID: <1296062571-2644-2-git-send-email-jacob@internet24.de>
References: <1296062571-2644-1-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:36914 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1AZRW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:22:57 -0500
Received: from [192.168.1.112] (helo=mailin03.ims-firmen.de)
	by mailout02.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1Pi954-000774-N9
	for netfilter-devel@vger.kernel.org; Wed, 26 Jan 2011 18:22:54 +0100
In-Reply-To: <1296062571-2644-1-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 net/netfilter/xt_iprange.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 5c14308..cd6e263 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -76,15 +76,27 @@ iprange_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		m  = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
 		m |= iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
 		m ^= !!(info->flags & IPRANGE_SRC_INV);
-		if (m)
+		if (m) {
+			pr_debug("src IP %pI6 NOT in range %s%pI6-%pI6\n",
+			         &iph->saddr,
+			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
+			         &info->src_min.in6,
+			         &info->src_max.in6);
 			return false;
+		}
 	}
 	if (info->flags & IPRANGE_DST) {
 		m  = iprange_ipv6_lt(&iph->daddr, &info->dst_min.in6);
 		m |= iprange_ipv6_lt(&info->dst_max.in6, &iph->daddr);
 		m ^= !!(info->flags & IPRANGE_DST_INV);
-		if (m)
+		if (m) {
+			pr_debug("dst IP %pI6 NOT in range %s%pI6-%pI6\n",
+			         &iph->daddr,
+			         (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
+			         &info->dst_min.in6,
+			         &info->dst_max.in6);
 			return false;
+		}
 	}
 	return true;
 }
-- 
1.5.6.5

