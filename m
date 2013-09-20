From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 2/7] netfilter: ipset: Support comments in hash-type ipsets.
Date: Fri, 20 Sep 2013 10:30:20 +0200
Message-ID: <1379665825-42563-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:45081 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3ITIbn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:31:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 3074CA3415
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:31:42 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Mj0L2z61WXvl for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:31:01 +0100 (BST)
In-Reply-To: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This provides kernel support for creating ipsets with comment support.

This does incur a penalty to flushing/destroying an ipset since all
entries are walked in order to free the allocated strings, this penalty
is of course less expensive than the operation of listing an ipset to
userspace, so for general-purpose usage the overall impact is expected
to be little to none.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 18 ++++++++++++++----
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  3 ++-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  3 ++-
 8 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 59ae854..eb5b71c 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -701,6 +701,8 @@ reuse_slot:
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
+	if (SET_WITH_COMMENT(set))
+		ip_set_init_comment(ext_comment(data, set), ext);
 
 out:
 	rcu_read_unlock_bh();
@@ -891,6 +893,7 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	const struct htable *t;
 	struct nlattr *nested;
 	size_t memsize;
+	u32 cadt_flags = 0;
 
 	t = rcu_dereference_bh_nfnl(h->table);
 	memsize = mtype_ahash_memsize(h, t, NLEN(set->family), set->dsize);
@@ -910,10 +913,14 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
 	    ((set->extensions & IPSET_EXT_TIMEOUT) &&
-	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
-	    ((set->extensions & IPSET_EXT_COUNTER) &&
-	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))))
+		goto nla_put_failure;
+	if (set->extensions & IPSET_EXT_COUNTER)
+		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
+	if (set->extensions & IPSET_EXT_COMMENT)
+		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
+	if (cadt_flags && nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
+					htonl(cadt_flags)))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -970,6 +977,9 @@ mtype_list(const struct ip_set *set,
 			if (SET_WITH_COUNTER(set) &&
 			    ip_set_put_counter(skb, ext_counter(e, set)))
 				goto nla_put_failure;
+			if (SET_WITH_COMMENT(set) &&
+			    ip_set_put_comment(skb, ext_comment(e, set)))
+				goto nla_put_failure;
 			ipset_nest_end(skb, nested);
 		}
 	}
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index a111ffe..da2433d 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* Counters support */
+/*				1	   Counters support */
+#define IPSET_TYPE_REV_MAX	2	/* Comments support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 5dc735c..c7a9083 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counters support added */
+#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 8c43dc7..cb17d9a 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -26,7 +26,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
-#define IPSET_TYPE_REV_MAX	2 /* Counters support added */
+/*				2    Counters support added */
+#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 3489045..071aed7 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -28,7 +28,8 @@
 /*				1    SCTP and UDPLITE support added */
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				4    Counters support added */
+#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index d559855..7ff21b9 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -25,7 +25,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    Range as input support for IPv4 added */
 /*				2    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				3    Counters support added */
+#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 26703e9..fb49cb5 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -26,7 +26,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    nomatch flag support added */
 /*				2    /0 support added */
-#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
+/*				3    Counters support added */
+#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 45b6e91..e3e6fd8 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -27,7 +27,8 @@
 /*				1    SCTP and UDPLITE support added */
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
-#define IPSET_TYPE_REV_MAX	4 /* Counters support added */
+/*				4    Counters support added */
+#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-- 
1.8.3.2

