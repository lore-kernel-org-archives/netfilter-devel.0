From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 3/7] netfilter: ipset: Support comments in bitmap-type ipsets.
Date: Fri, 20 Sep 2013 10:30:21 +0200
Message-ID: <1379665825-42563-4-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:45079 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3ITIbm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:31:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id A908CA3409
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:31:41 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id LHG64_Wil1-l for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:31:01 +0100 (BST)
In-Reply-To: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This provides kernel support for creating bitmap ipsets with comment
support.

As is the case for hashes, this incurs a penalty when flushing or
destroying the entire ipset as the entries must first be walked in order
to free the comment strings. This penalty is of course far less than the
cost of listing an ipset to userspace. Any set created without support
for comments will be flushed/destroyed as before.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h   | 18 ++++++++++++++----
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c    |  3 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c |  3 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c  |  3 ++-
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
index 4515fe8..cbc6487 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -92,6 +92,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
+	u32 cadt_flags = 0;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
@@ -103,10 +104,14 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 				map->memsize +
 				set->dsize * map->elements)) ||
 	    (SET_WITH_TIMEOUT(set) &&
-	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
-	    (SET_WITH_COUNTER(set) &&
-	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))))
+		goto nla_put_failure;
+	if (SET_WITH_COUNTER(set))
+		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
+	if (SET_WITH_COMMENT(set))
+		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
+	if (cadt_flags && nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
+	    htonl(cadt_flags)))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -162,6 +167,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
+	if (SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(x, set), ext);
 	return 0;
 }
 
@@ -233,6 +240,9 @@ mtype_list(const struct ip_set *set,
 		if (SET_WITH_COUNTER(set) &&
 		    ip_set_put_counter(skb, ext_counter(x, set)))
 			goto nla_put_failure;
+		if (SET_WITH_COMMENT(set) &&
+		    ip_set_put_comment(skb, ext_comment(x, set)))
+			goto nla_put_failure;
 		ipset_nest_end(skb, nested);
 	}
 	ipset_nest_end(skb, adt);
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index 94d9854..4d49b1c 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -26,7 +26,8 @@
 #include <linux/netfilter/ipset/ip_set_bitmap.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 654a97b..1d81f02 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -26,7 +26,8 @@
 #include <linux/netfilter/ipset/ip_set_bitmap.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index 1ef2f31..3cff821 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -21,7 +21,8 @@
 #include <linux/netfilter/ipset/ip_set_getport.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counter support added */
+/*				1	   Counter support added */
+#define IPSET_TYPE_REV_MAX	2	/* Comment support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-- 
1.8.3.2

