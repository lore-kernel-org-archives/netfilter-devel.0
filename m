From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/34] netfilter: ipset: send nonzero skbinfo extensions only
Date: Mon, 29 Sep 2014 14:39:00 +0200
Message-ID: <1411994363-8451-12-git-send-email-pablo@netfilter.org>
References: <1411994363-8451-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34104 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbaI2Mi3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:38:29 -0400
In-Reply-To: <1411994363-8451-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Do not send zero valued skbinfo extensions to userspace at listing.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h |   18 +++++++++++-------
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
1.7.10.4

