From: kaber@trash.net
Subject: [PATCH 2/3] netfilter: ipt_ecn: fix inversion for IP header ECN match
Date: Thu,  9 Jun 2011 14:12:33 +0200
Message-ID: <1307621554-19108-3-git-send-email-kaber@trash.net>
References: <1307621554-19108-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: eric.dumazet@gmail.com, dave.taht@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37832 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab1FIMMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:12:39 -0400
In-Reply-To: <1307621554-19108-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Userspace allows to specify inversion for IP header ECN matches, the kernel
silently accepts it, but doesn't invert the match result.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ipt_ecn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index aaa85be..2b57e52 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -25,7 +25,8 @@ MODULE_LICENSE("GPL");
 static inline bool match_ip(const struct sk_buff *skb,
 			    const struct ipt_ecn_info *einfo)
 {
-	return (ip_hdr(skb)->tos & IPT_ECN_IP_MASK) == einfo->ip_ect;
+	return ((ip_hdr(skb)->tos & IPT_ECN_IP_MASK) == einfo->ip_ect) ^
+	       !!(einfo->invert & IPT_ECN_OP_MATCH_IP);
 }
 
 static inline bool match_tcp(const struct sk_buff *skb,
-- 
1.7.4.1

