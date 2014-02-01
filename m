From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/2] ipset: add forceadd kernel support for hash set types
Date: Sat,  1 Feb 2014 05:30:51 -0800
Message-ID: <1391261452-11266-2-git-send-email-johunt@akamai.com>
References: <1391261452-11266-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:51601 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbaBANkF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Feb 2014 08:40:05 -0500
In-Reply-To: <1391261452-11266-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds a new property for hash set types, where if a set is created
with the 'forceadd' option and the set becomes full the next addition
to the set may succeed and evict a random entry from the set.

To keep overhead low eviction is done very simply. It checks to see
which bucket the new entry would be added. If the bucket's pos value
is non-zero (meaning there's at least one entry in the bucket) it
replaces the first entry in the bucket. If pos is zero, then it continues
down the normal add process.

This property is useful if you have a set for 'ban' lists where it may
not matter if you release some entries from the set early.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    1 +
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   26 ++++++++++++++++++-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |    4 ++-
 kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |    3 +-
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |    4 ++-
 .../net/netfilter/ipset/ip_set_hash_netportnet.c   |    4 ++-
 12 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index c2bae85..0e1478e 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -95,6 +95,7 @@ enum {
 	IPSET_ATTR_PROBES,
 	IPSET_ATTR_RESIZE,
 	IPSET_ATTR_SIZE,
+	IPSET_ATTR_FORCEADD,
 	/* Kernel-only */
 	IPSET_ATTR_ELEMENTS,
 	IPSET_ATTR_REFERENCES,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index fa259db..b4ca130 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -263,6 +263,7 @@ struct htype {
 	u32 maxelem;		/* max elements in the hash */
 	u32 elements;		/* current element (vs timeout) */
 	u32 initval;		/* random jhash init value */
+	u8 forceadd;            /* if hash full, attempt to evict one on add */
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
@@ -633,6 +634,19 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	u32 key, multi = 0;
 
+        if (h->elements >= h->maxelem && h->forceadd) {
+                rcu_read_lock_bh();
+                t = rcu_dereference_bh(h->table);
+                key = HKEY(value, h->initval, t->htable_bits);
+                n = hbucket(t,key);
+                if (n->pos) {
+                        /* Choosing the first entry in the array to replace */
+                        j = 0;
+                        goto reuse_slot;
+                }
+                rcu_read_unlock_bh();
+        }
+
 	if (SET_WITH_TIMEOUT(set) && h->elements >= h->maxelem)
 		/* FIXME: when set is full, we slow down here */
 		mtype_expire(set, h, NLEN(set->family), set->dsize);
@@ -923,6 +937,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
+        if ((h->forceadd) && nla_put_u8(skb, IPSET_ATTR_FORCEADD, htonl(h->forceadd)))
+                goto nla_put_failure;
+
 	ipset_nest_end(skb, nested);
 
 	return 0;
@@ -1139,9 +1156,14 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 				IPSET_TOKEN(HTYPE, 6_gc));
 	}
 
-	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
+        if (tb[IPSET_ATTR_FORCEADD])
+                h->forceadd = 1;
+        else
+                h->forceadd = 0;
+
+	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p) forceadd %d\n",
 		 set->name, jhash_size(t->htable_bits),
-		 t->htable_bits, h->maxelem, set->data, t);
+		 t->htable_bits, h->maxelem, set->data, t, h->forceadd);
 
 	return 0;
 }
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index e65fc24..6b97b91 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -25,7 +25,8 @@
 
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Counters support */
-#define IPSET_TYPE_REV_MAX	2	/* Comments support */
+/*				2	   Comments support */
+#define IPSET_TYPE_REV_MAX	3	/* Forceadd support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -284,6 +285,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
index 1bf8e85..19304e3 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -25,7 +25,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1	/* Forceadd support */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
@@ -290,6 +290,7 @@ static struct ip_set_type hash_ipmark_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 525a595..b543b4e 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -27,7 +27,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
 /*				2    Counters support added */
-#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
+/*				3    Comments support added */
+#define IPSET_TYPE_REV_MAX	4 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -356,6 +357,7 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index f563663..3379389 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -27,7 +27,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1    SCTP and UDPLITE support added */
 /*				2    Counters support added */
-#define IPSET_TYPE_REV_MAX	3 /* Comments support added */
+/*				3    Comments support added */
+#define IPSET_TYPE_REV_MAX	4 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -367,6 +368,7 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 5d87fe8..86d91ef 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -29,7 +29,8 @@
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
 /*				4    Counters support added */
-#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
+/*				5    Comments support added */
+#define IPSET_TYPE_REV_MAX	6 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -523,6 +524,7 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 8295cf4..e96530a 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -26,7 +26,8 @@
 /*				1    Range as input support for IPv4 added */
 /*				2    nomatch flag support added */
 /*				3    Counters support added */
-#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
+/*				4    Comments support added */
+#define IPSET_TYPE_REV_MAX	5 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -366,6 +367,7 @@ static struct ip_set_type hash_net_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 788825b..e318e09 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -27,7 +27,8 @@
 /*				1    nomatch flag support added */
 /*				2    /0 support added */
 /*				3    Counters support added */
-#define IPSET_TYPE_REV_MAX	4 /* Comments support added */
+/*				4    Comments support added */
+#define IPSET_TYPE_REV_MAX	5 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -604,6 +605,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
index 4e7261d..333ad77 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -24,7 +24,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1 	/* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -448,6 +448,7 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index 7097fb0..9aff329 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -28,7 +28,8 @@
 /*				2    Range as input support for IPv4 added */
 /*				3    nomatch flag support added */
 /*				4    Counters support added */
-#define IPSET_TYPE_REV_MAX	5 /* Comments support added */
+/*				5    Comments support added */
+#define IPSET_TYPE_REV_MAX	6 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -474,6 +475,7 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
index 703d119..bdffc9e 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -25,7 +25,8 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
 
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0 /* Comments support added */
+/*				0    Comments support added */
+#define IPSET_TYPE_REV_MAX	1 /* Forceadd support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -549,6 +550,7 @@ static struct ip_set_type hash_netportnet_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_FORCEADD]   = { .type = NLA_U8 },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
-- 
1.7.0.4

