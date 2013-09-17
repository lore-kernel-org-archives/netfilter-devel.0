From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 3/6] netfilter: ipset: Support comments in bitmap-type ipsets.
Date: Tue, 17 Sep 2013 15:13:22 +0200
Message-ID: <1379423605-22777-4-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60535 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQNOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:14:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id CC309A32B7
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 14:14:52 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Gp1fpVL_mwf3 for <netfilter-devel@vger.kernel.org>;
	Tue, 17 Sep 2013 14:14:20 +0100 (BST)
In-Reply-To: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
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
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h   | 10 +++++++++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c    |  3 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c |  3 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c  |  3 ++-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
index 4515fe8..99d7683 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -106,7 +106,10 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
 	    (SET_WITH_COUNTER(set) &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+			   htonl(IPSET_FLAG_WITH_COUNTERS))) ||
+	    (SET_WITH_COMMENT(set) &&
+	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
+			   htonl(IPSET_FLAG_WITH_COMMENTS))))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -162,6 +165,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(x, set), ext);
+	if (SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(x, set), ext);
 	return 0;
 }
 
@@ -233,6 +238,9 @@ mtype_list(const struct ip_set *set,
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

