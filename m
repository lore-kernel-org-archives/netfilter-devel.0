From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/39] netfilter: ipset: Headers file cleanup
Date: Sun, 13 Nov 2016 23:25:12 +0100
Message-ID: <1479075933-4491-19-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964955AbcKMW0Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Nov 2016 17:26:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B786EB498A
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5102DA86C
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8724DA851
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Nov 2016 23:26:12 +0100 (CET)
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Group counter helper functions together.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h | 42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 524467f933bf..1ea28e30a6dd 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -334,6 +334,27 @@ ip_set_update_counter(struct ip_set_counter *counter,
 	}
 }
 
+static inline bool
+ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
+{
+	return nla_put_net64(skb, IPSET_ATTR_BYTES,
+			     cpu_to_be64(ip_set_get_bytes(counter)),
+			     IPSET_ATTR_PAD) ||
+	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
+			     cpu_to_be64(ip_set_get_packets(counter)),
+			     IPSET_ATTR_PAD);
+}
+
+static inline void
+ip_set_init_counter(struct ip_set_counter *counter,
+		    const struct ip_set_ext *ext)
+{
+	if (ext->bytes != ULLONG_MAX)
+		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
+	if (ext->packets != ULLONG_MAX)
+		atomic64_set(&(counter)->packets, (long long)(ext->packets));
+}
+
 static inline void
 ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
 		   const struct ip_set_ext *ext,
@@ -372,27 +393,6 @@ ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 	skbinfo->skbqueue = ext->skbqueue;
 }
 
-static inline bool
-ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
-{
-	return nla_put_net64(skb, IPSET_ATTR_BYTES,
-			     cpu_to_be64(ip_set_get_bytes(counter)),
-			     IPSET_ATTR_PAD) ||
-	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
-			     cpu_to_be64(ip_set_get_packets(counter)),
-			     IPSET_ATTR_PAD);
-}
-
-static inline void
-ip_set_init_counter(struct ip_set_counter *counter,
-		    const struct ip_set_ext *ext)
-{
-	if (ext->bytes != ULLONG_MAX)
-		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
-	if (ext->packets != ULLONG_MAX)
-		atomic64_set(&(counter)->packets, (long long)(ext->packets));
-}
-
 /* Netlink CB args */
 enum {
 	IPSET_CB_NET = 0,	/* net namespace */
-- 
2.1.4

