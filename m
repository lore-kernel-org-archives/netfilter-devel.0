From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 2/7] netfilter: ipset: Support comments in hash-type ipsets.
Date: Sun, 22 Sep 2013 20:56:31 +0200
Message-ID: <1379876196-46929-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55765 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVS5q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:57:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id E91C3A0D37
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 19:57:44 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id MF7PMXUKjk18 for <netfilter-devel@vger.kernel.org>;
	Sun, 22 Sep 2013 19:56:38 +0100 (BST)
In-Reply-To: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
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
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 14 ++++++++------
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  4 +++-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |  1 +
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  4 +++-
 9 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 59ae854..324de2f 100644
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
@@ -908,12 +910,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
-	    ((set->extensions & IPSET_EXT_TIMEOUT) &&
-	     nla_put_net32(skb, IPSET_ATTR_TIMEOUT, htonl(set->timeout))) ||
-	    ((set->extensions & IPSET_EXT_COUNTER) &&
-	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS,
-			   htonl(IPSET_FLAG_WITH_COUNTERS))))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+		goto nla_put_failure;
+	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
 	ipset_nest_end(skb, nested);
 
@@ -970,6 +969,9 @@ mtype_list(const struct ip_set *set,
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
index a111ffe..10db2ff 100644
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
@@ -292,6 +293,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 5dc735c..51f1977 100644
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
@@ -367,6 +368,7 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 8c43dc7..be374e0 100644
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
@@ -379,6 +380,7 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 3489045..8074ef9 100644
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
@@ -538,6 +539,7 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index d559855..d07e06c 100644
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
@@ -374,6 +375,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 26703e9..fcb5b5b 100644
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
@@ -606,6 +607,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
index 771ce2b..28560a1 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -462,6 +462,7 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 45b6e91..43d5703 100644
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
@@ -486,6 +487,7 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_STRING },
 	},
 	.me		= THIS_MODULE,
 };
-- 
1.8.3.2

