From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 7/8] netfilter: ipset: send nonzero skbinfo extensions only
Date: Mon, 15 Sep 2014 23:02:53 +0200
Message-ID: <1410814974-9918-8-git-send-email-kadlec@blackhole.kfki.hu>
References: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39094 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637AbaIOVCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:02:37 -0400
In-Reply-To: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not send zero valued skbinfo extensions to userspace at listing.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index b97aac5..f1606fa 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -335,13 +335,17 @@ ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
 static inline bool
 ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
 {
-	return nla_put_net64(skb, IPSET_ATTR_SKBMARK,
-			     cpu_to_be64((u64)skbinfo->skbmark << 32 |
-					 skbinfo->skbmarkmask)) ||
-	       nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
-			     cpu_to_be32(skbinfo->skbprio)) ||
-	       nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
-			     cpu_to_be16(skbinfo->skbqueue));
+	/* Send nonzero parameters only */
+	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
+		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
+			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
+					  skbinfo->skbmarkmask))) ||
+	       (skbinfo->skbprio &&
+	        nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
+			      cpu_to_be32(skbinfo->skbprio))) ||
+	       (skbinfo->skbqueue &&
+	        nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
+			     cpu_to_be16(skbinfo->skbqueue)));
 
 }
 
-- 
1.8.5.1

