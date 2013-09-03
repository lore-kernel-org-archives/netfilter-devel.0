From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 1/2 v2] netfilter: ipset: rework hash ext. handling to be more manageable.
Date: Tue,  3 Sep 2013 13:03:24 +0200
Message-ID: <1378206205-19591-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:32789 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3ICLD7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:03:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 39E15A2D35
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2013 12:03:58 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id F2nOCLSkdm63 for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Sep 2013 12:03:27 +0100 (BST)
In-Reply-To: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

The previous code that handled all the various combinations of ipset
extensions in the hash family consisted of trees of if/else statements
that check all the possible extension combinations. This patch
simplifies that code down to a couple of switch statements and a
preprocessor macro to facilite appropriate setup.

This should significantly reduce the new lines of code that would have
to be introduced to add more extensions in the future.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/include/linux/netfilter/ipset/ip_set.h      |   4 +
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 102 ++++++---------------
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  36 +-------
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  54 +----------
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  58 +-----------
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  66 +------------
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |  54 +----------
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  67 +-------------
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  60 +-----------
 10 files changed, 52 insertions(+), 457 deletions(-)

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index f974f35..82f32e0 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -184,6 +184,10 @@ struct ip_set {
 	void *data;
 };
 
+struct ip_set_timeout {
+	unsigned long timeout;
+};
+
 struct ip_set_counter {
 	atomic64_t bytes;
 	atomic64_t packets;
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 8024cdf..17779ca 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -166,7 +166,11 @@ enum ipset_cmd_flags {
 	IPSET_FLAG_CMD_MAX = 15,
 };
 
-/* Flags at CADT attribute level, upper half of cmdattrs */
+/* Flags at CADT attribute level, upper half of cmdattrs
+ *
+ * We recycle NOMATCH for TIMEOUT since it is only used for
+ * ipset creation.
+ */
 enum ipset_cadt_flags {
 	IPSET_FLAG_BIT_BEFORE	= 0,
 	IPSET_FLAG_BEFORE	= (1 << IPSET_FLAG_BIT_BEFORE),
@@ -174,6 +178,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_PHYSDEV	= (1 << IPSET_FLAG_BIT_PHYSDEV),
 	IPSET_FLAG_BIT_NOMATCH	= 2,
 	IPSET_FLAG_NOMATCH	= (1 << IPSET_FLAG_BIT_NOMATCH),
+	IPSET_FLAG_EXT_BEGIN = 2,
+	IPSET_FLAG_WITH_TIMEOUTS = (1 << IPSET_FLAG_EXT_BEGIN),
 	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
 	IPSET_FLAG_CADT_MAX	= 15,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index c694079..cb6bba2 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -965,6 +965,7 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	u32 cadt_flags = 0;
 	u8 hbits;
+	int i = IPSET_FLAG_EXT_BEGIN;
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;
 #endif
@@ -1043,82 +1044,35 @@ IPSET_TOKEN(HTYPE, _create)(struct ip_set *set, struct nlattr *tb[], u32 flags)
 		set->variant = &IPSET_TOKEN(HTYPE, 6_variant);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS])
-		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-	if (cadt_flags & IPSET_FLAG_WITH_COUNTERS) {
-		set->extensions |= IPSET_EXT_COUNTER;
-		if (tb[IPSET_ATTR_TIMEOUT]) {
-			h->timeout =
-				ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-			set->extensions |= IPSET_EXT_TIMEOUT;
-			if (set->family == NFPROTO_IPV4) {
-				h->dsize = sizeof(struct
-					IPSET_TOKEN(HTYPE, 4ct_elem));
-				h->offset[IPSET_OFFSET_TIMEOUT] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4ct_elem),
-						timeout);
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4ct_elem),
-						counter);
-				IPSET_TOKEN(HTYPE, 4_gc_init)(set,
-					IPSET_TOKEN(HTYPE, 4_gc));
-			} else {
-				h->dsize = sizeof(struct
-					IPSET_TOKEN(HTYPE, 6ct_elem));
-				h->offset[IPSET_OFFSET_TIMEOUT] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6ct_elem),
-						timeout);
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6ct_elem),
-						counter);
-				IPSET_TOKEN(HTYPE, 6_gc_init)(set,
-					IPSET_TOKEN(HTYPE, 6_gc));
-			}
-		} else {
-			if (set->family == NFPROTO_IPV4) {
-				h->dsize =
-					sizeof(struct
-						IPSET_TOKEN(HTYPE, 4c_elem));
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 4c_elem),
-						counter);
-			} else {
-				h->dsize =
-					sizeof(struct
-						IPSET_TOKEN(HTYPE, 6c_elem));
-				h->offset[IPSET_OFFSET_COUNTER] =
-					offsetof(struct
-						IPSET_TOKEN(HTYPE, 6c_elem),
-						counter);
+		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]) & ~IPSET_FLAG_EXT_BEGIN;
+	if (tb[IPSET_ATTR_TIMEOUT])
+		cadt_flags |= IPSET_FLAG_WITH_TIMEOUTS;
+
+	if (set->family == NFPROTO_IPV4)
+		h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 4_elem));
+	else
+		h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 6_elem));
+
+	if (cadt_flags) {
+		for(; i < (1 << IPSET_FLAG_CADT_MAX); i = (i << 1)) {
+			switch (cadt_flags & i) {
+				case IPSET_FLAG_WITH_COUNTERS:
+					set->extensions |= IPSET_EXT_COUNTER;
+					h->offset[IPSET_OFFSET_COUNTER] = h->dsize;
+					h->dsize += sizeof(struct ip_set_counter);
+					break;
+				case IPSET_FLAG_WITH_TIMEOUTS:
+					set->extensions |= IPSET_EXT_TIMEOUT;
+					h->offset[IPSET_OFFSET_TIMEOUT] = h->dsize;
+					h->dsize += sizeof(struct ip_set_timeout);
+					h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
+					if(set->family == NFPROTO_IPV4)
+						IPSET_TOKEN(HTYPE, 4_gc_init)(set, IPSET_TOKEN(HTYPE, 4_gc));
+					else
+						IPSET_TOKEN(HTYPE, 6_gc_init)(set, IPSET_TOKEN(HTYPE, 6_gc));
+					break;
 			}
 		}
-	} else if (tb[IPSET_ATTR_TIMEOUT]) {
-		h->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-		set->extensions |= IPSET_EXT_TIMEOUT;
-		if (set->family == NFPROTO_IPV4) {
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 4t_elem));
-			h->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct IPSET_TOKEN(HTYPE, 4t_elem),
-					 timeout);
-			IPSET_TOKEN(HTYPE, 4_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 4_gc));
-		} else {
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 6t_elem));
-			h->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct IPSET_TOKEN(HTYPE, 6t_elem),
-					 timeout);
-			IPSET_TOKEN(HTYPE, 6_gc_init)(set,
-				IPSET_TOKEN(HTYPE, 6_gc));
-		}
-	} else {
-		if (set->family == NFPROTO_IPV4)
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 4_elem));
-		else
-			h->dsize = sizeof(struct IPSET_TOKEN(HTYPE, 6_elem));
 	}
 
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)\n",
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ip.c b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
index 260c9a8..6825754 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ip.c
@@ -41,23 +41,7 @@ MODULE_ALIAS("ip_set_hash:ip");
 struct hash_ip4_elem {
 	/* Zero valued IP addresses cannot be stored */
 	__be32 ip;
-};
-
-struct hash_ip4t_elem {
-	__be32 ip;
-	unsigned long timeout;
-};
-
-struct hash_ip4c_elem {
-	__be32 ip;
-	struct ip_set_counter counter;
-};
-
-struct hash_ip4ct_elem {
-	__be32 ip;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -183,23 +167,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 /* Member elements */
 struct hash_ip6_elem {
 	union nf_inet_addr ip;
-};
-
-struct hash_ip6t_elem {
-	union nf_inet_addr ip;
-	unsigned long timeout;
-};
-
-struct hash_ip6c_elem {
-	union nf_inet_addr ip;
-	struct ip_set_counter counter;
-};
-
-struct hash_ip6ct_elem {
-	union nf_inet_addr ip;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
index 64caad3..55690b2 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -44,32 +44,7 @@ struct hash_ipport4_elem {
 	__be16 port;
 	u8 proto;
 	u8 padding;
-};
-
-struct hash_ipport4t_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	unsigned long timeout;
-};
-
-struct hash_ipport4c_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipport4ct_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -229,32 +204,7 @@ struct hash_ipport6_elem {
 	__be16 port;
 	u8 proto;
 	u8 padding;
-};
-
-struct hash_ipport6t_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	unsigned long timeout;
-};
-
-struct hash_ipport6c_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipport6ct_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
index 2873bbc..67b4c24 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -45,35 +45,7 @@ struct hash_ipportip4_elem {
 	__be16 port;
 	u8 proto;
 	u8 padding;
-};
-
-struct hash_ipportip4t_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	unsigned long timeout;
-};
-
-struct hash_ipportip4c_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipportip4ct_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 static inline bool
 hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
@@ -241,34 +213,6 @@ struct hash_ipportip6_elem {
 	u8 padding;
 };
 
-struct hash_ipportip6t_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	unsigned long timeout;
-};
-
-struct hash_ipportip6c_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipportip6ct_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 proto;
-	u8 padding;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
-
 /* Common functions */
 
 static inline bool
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
index f111558..02ed91e 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -56,38 +56,7 @@ struct hash_ipportnet4_elem {
 	u8 cidr:7;
 	u8 nomatch:1;
 	u8 proto;
-};
-
-struct hash_ipportnet4t_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	unsigned long timeout;
-};
-
-struct hash_ipportnet4c_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipportnet4ct_elem {
-	__be32 ip;
-	__be32 ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -337,38 +306,7 @@ struct hash_ipportnet6_elem {
 	u8 cidr:7;
 	u8 nomatch:1;
 	u8 proto;
-};
-
-struct hash_ipportnet6t_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	unsigned long timeout;
-};
-
-struct hash_ipportnet6c_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	struct ip_set_counter counter;
-};
-
-struct hash_ipportnet6ct_elem {
-	union nf_inet_addr ip;
-	union nf_inet_addr ip2;
-	__be16 port;
-	u8 cidr:7;
-	u8 nomatch:1;
-	u8 proto;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_net.c b/kernel/net/netfilter/ipset/ip_set_hash_net.c
index 0a64dad..3d2ea5d 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_net.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_net.c
@@ -44,32 +44,7 @@ struct hash_net4_elem {
 	u16 padding0;
 	u8 nomatch;
 	u8 cidr;
-};
-
-struct hash_net4t_elem {
-	__be32 ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	unsigned long timeout;
-};
-
-struct hash_net4c_elem {
-	__be32 ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	struct ip_set_counter counter;
-};
-
-struct hash_net4ct_elem {
-	__be32 ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -235,32 +210,7 @@ struct hash_net6_elem {
 	u16 padding0;
 	u8 nomatch;
 	u8 cidr;
-};
-
-struct hash_net6t_elem {
-	union nf_inet_addr ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	unsigned long timeout;
-};
-
-struct hash_net6c_elem {
-	union nf_inet_addr ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	struct ip_set_counter counter;
-};
-
-struct hash_net6ct_elem {
-	union nf_inet_addr ip;
-	u16 padding0;
-	u8 nomatch;
-	u8 cidr;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 846371b..06cc27b 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -144,7 +144,6 @@ struct hash_netiface4_elem_hashed {
 	u8 elem;
 };
 
-/* Member elements without timeout */
 struct hash_netiface4_elem {
 	__be32 ip;
 	u8 physdev;
@@ -152,38 +151,7 @@ struct hash_netiface4_elem {
 	u8 nomatch;
 	u8 elem;
 	const char *iface;
-};
-
-struct hash_netiface4t_elem {
-	__be32 ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	unsigned long timeout;
-};
-
-struct hash_netiface4c_elem {
-	__be32 ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	struct ip_set_counter counter;
-};
-
-struct hash_netiface4ct_elem {
-	__be32 ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -416,38 +384,7 @@ struct hash_netiface6_elem {
 	u8 nomatch;
 	u8 elem;
 	const char *iface;
-};
-
-struct hash_netiface6t_elem {
-	union nf_inet_addr ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	unsigned long timeout;
-};
-
-struct hash_netiface6c_elem {
-	union nf_inet_addr ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	struct ip_set_counter counter;
-};
-
-struct hash_netiface6ct_elem {
-	union nf_inet_addr ip;
-	u8 physdev;
-	u8 cidr;
-	u8 nomatch;
-	u8 elem;
-	const char *iface;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+}  __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netport.c b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
index d98a685..570e6b5 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netport.c
@@ -54,35 +54,7 @@ struct hash_netport4_elem {
 	u8 proto;
 	u8 cidr:7;
 	u8 nomatch:1;
-};
-
-struct hash_netport4t_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	unsigned long timeout;
-};
-
-struct hash_netport4c_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	struct ip_set_counter counter;
-};
-
-struct hash_netport4ct_elem {
-	__be32 ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
@@ -295,35 +267,7 @@ struct hash_netport6_elem {
 	u8 proto;
 	u8 cidr:7;
 	u8 nomatch:1;
-};
-
-struct hash_netport6t_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	unsigned long timeout;
-};
-
-struct hash_netport6c_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	struct ip_set_counter counter;
-};
-
-struct hash_netport6ct_elem {
-	union nf_inet_addr ip;
-	__be16 port;
-	u8 proto;
-	u8 cidr:7;
-	u8 nomatch:1;
-	struct ip_set_counter counter;
-	unsigned long timeout;
-};
+} __attribute__((aligned(sizeof(void*))));
 
 /* Common functions */
 
-- 
1.8.3.2

