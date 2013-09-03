From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 2/2 v2] netfilter: ipset: rework bitmap ext. handling to be more manageable.
Date: Tue,  3 Sep 2013 13:03:25 +0200
Message-ID: <1378206205-19591-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:32794 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3ICLEO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:04:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id E19C4A2E09
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2013 12:04:13 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Up4OHGdbGBGq for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Sep 2013 12:03:52 +0100 (BST)
In-Reply-To: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

The previous code that handled all the various combinations of ipset
extensions in the bitmap family was largely duplicated across the
various types. Additionally, it also had trees of if/else statements
that check the possible extension combinations. This patch simplifies
and deduplicates most of that code using the same means as the
preceeding patch to simplify extension handling within the hash family.

This should significantly reduce the new lines of code that would have
to be introduced to add more extensions in the future.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h   | 34 +++++++++
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c    | 87 ++-------------------
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c | 96 ++----------------------
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c  | 76 ++-----------------
 4 files changed, 54 insertions(+), 239 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
index d39905e..69416ac 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -15,6 +15,7 @@
 #define mtype_do_del		IPSET_TOKEN(MTYPE, _do_del)
 #define mtype_do_list		IPSET_TOKEN(MTYPE, _do_list)
 #define mtype_do_head		IPSET_TOKEN(MTYPE, _do_head)
+#define mtype_do_create		IPSET_TOKEN(MTYPE, _do_create)
 #define mtype_adt_elem		IPSET_TOKEN(MTYPE, _adt_elem)
 #define mtype_add_timeout	IPSET_TOKEN(MTYPE, _add_timeout)
 #define mtype_gc_init		IPSET_TOKEN(MTYPE, _gc_init)
@@ -256,6 +257,39 @@ mtype_gc(unsigned long ul_set)
 	add_timer(&map->gc);
 }
 
+static inline int
+mtype_do_create(struct mtype *map, struct nlattr *tb[], struct ip_set *set, create_args)
+{
+	unsigned int cadt_flags = 0, i = IPSET_FLAG_EXT_BEGIN;
+
+	if(tb[IPSET_ATTR_CADT_FLAGS])
+		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]) & ~IPSET_FLAG_EXT_BEGIN;
+	if(tb[IPSET_ATTR_TIMEOUT])
+		cadt_flags |= IPSET_FLAG_WITH_TIMEOUTS;
+
+	map->dsize = 0;
+	if (cadt_flags) {
+		for(; i < (1 << IPSET_FLAG_CADT_MAX) ; i = (i << 1)) {
+			switch (cadt_flags & i) {
+				case IPSET_FLAG_WITH_COUNTERS:
+					map->offset[IPSET_OFFSET_COUNTER] = map->dsize;
+					map->dsize += sizeof(struct ip_set_counter);
+					set->extensions |= IPSET_EXT_COUNTER;
+					break;
+				case IPSET_FLAG_WITH_TIMEOUTS:
+					map->offset[IPSET_OFFSET_TIMEOUT] = map->dsize;
+					map->dsize += sizeof(struct ip_set_timeout);
+					set->extensions |= IPSET_EXT_TIMEOUT;
+					map->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
+					IPSET_TOKEN(mtype, _gc_init)(set, IPSET_TOKEN(mtype, _gc));
+					break;
+			}
+		}
+	}
+	INIT_MAP();
+	return 0;
+}
+
 static const struct ip_set_type_variant mtype = {
 	.kadt	= mtype_kadt,
 	.uadt	= mtype_uadt,
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
index ce99d26..6cfeb1f 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -209,27 +209,6 @@ bitmap_ip_same_set(const struct ip_set *a, const struct ip_set *b)
 struct bitmap_ip_elem {
 };
 
-/* Timeout variant */
-
-struct bitmap_ipt_elem {
-	unsigned long timeout;
-};
-
-/* Plain variant with counter */
-
-struct bitmap_ipc_elem {
-	struct ip_set_counter counter;
-};
-
-/* Timeout variant with counter */
-
-struct bitmap_ipct_elem {
-	unsigned long timeout;
-	struct ip_set_counter counter;
-};
-
-#include "ip_set_bitmap_gen.h"
-
 /* Create bitmap:ip type of sets */
 
 static bool
@@ -260,11 +239,17 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	return true;
 }
 
+#define create_args	u32 first_ip, u32 last_ip, u32 hosts, 		\
+			u64 elements, u8 netmask
+#define INIT_MAP()	init_map_ip(set, map, first_ip, last_ip,	\
+				    elements, hosts, netmask)
+#include "ip_set_bitmap_gen.h"
+
 static int
 bitmap_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 {
 	struct bitmap_ip *map;
-	u32 first_ip = 0, last_ip = 0, hosts, cadt_flags = 0;
+	u32 first_ip = 0, last_ip = 0, hosts;
 	u64 elements;
 	u8 netmask = 32;
 	int ret;
@@ -336,63 +321,7 @@ bitmap_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 	map->memsize = bitmap_bytes(0, elements - 1);
 	set->variant = &bitmap_ip;
-	if (tb[IPSET_ATTR_CADT_FLAGS])
-		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-	if (cadt_flags & IPSET_FLAG_WITH_COUNTERS) {
-		set->extensions |= IPSET_EXT_COUNTER;
-		if (tb[IPSET_ATTR_TIMEOUT]) {
-			map->dsize = sizeof(struct bitmap_ipct_elem);
-			map->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct bitmap_ipct_elem, timeout);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_ipct_elem, counter);
-
-			if (!init_map_ip(set, map, first_ip, last_ip,
-					 elements, hosts, netmask)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-
-			map->timeout = ip_set_timeout_uget(
-				tb[IPSET_ATTR_TIMEOUT]);
-			set->extensions |= IPSET_EXT_TIMEOUT;
-
-			bitmap_ip_gc_init(set, bitmap_ip_gc);
-		} else {
-			map->dsize = sizeof(struct bitmap_ipc_elem);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_ipc_elem, counter);
-
-			if (!init_map_ip(set, map, first_ip, last_ip,
-					 elements, hosts, netmask)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-		}
-	} else if (tb[IPSET_ATTR_TIMEOUT]) {
-		map->dsize = sizeof(struct bitmap_ipt_elem);
-		map->offset[IPSET_OFFSET_TIMEOUT] =
-			offsetof(struct bitmap_ipt_elem, timeout);
-
-		if (!init_map_ip(set, map, first_ip, last_ip,
-				 elements, hosts, netmask)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-
-		map->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-		set->extensions |= IPSET_EXT_TIMEOUT;
-
-		bitmap_ip_gc_init(set, bitmap_ip_gc);
-	} else {
-		map->dsize = 0;
-		if (!init_map_ip(set, map, first_ip, last_ip,
-				 elements, hosts, netmask)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-	}
-	return 0;
+	return mtype_do_create(map, tb, set, first_ip, last_ip, hosts, elements, netmask);
 }
 
 static struct ip_set_type bitmap_ip_type __read_mostly = {
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 6d5bad9..e6a718c 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -289,41 +289,6 @@ bitmap_ipmac_same_set(const struct ip_set *a, const struct ip_set *b)
 	       a->extensions == b->extensions;
 }
 
-/* Plain variant */
-
-/* Timeout variant */
-
-struct bitmap_ipmact_elem {
-	struct {
-		unsigned char ether[ETH_ALEN];
-		unsigned char filled;
-	} __attribute__ ((aligned));
-	unsigned long timeout;
-};
-
-/* Plain variant with counter */
-
-struct bitmap_ipmacc_elem {
-	struct {
-		unsigned char ether[ETH_ALEN];
-		unsigned char filled;
-	} __attribute__ ((aligned));
-	struct ip_set_counter counter;
-};
-
-/* Timeout variant with counter */
-
-struct bitmap_ipmacct_elem {
-	struct {
-		unsigned char ether[ETH_ALEN];
-		unsigned char filled;
-	} __attribute__ ((aligned));
-	unsigned long timeout;
-	struct ip_set_counter counter;
-};
-
-#include "ip_set_bitmap_gen.h"
-
 /* Create bitmap:ip,mac type of sets */
 
 static bool
@@ -351,11 +316,16 @@ init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	return true;
 }
 
+#define create_args	u32 first_ip, u32 last_ip, u64 elements
+#define INIT_MAP()	init_map_ipmac(set, map, first_ip, last_ip, elements)
+
+#include "ip_set_bitmap_gen.h"
+
 static int
 bitmap_ipmac_create(struct ip_set *set, struct nlattr *tb[],
 		    u32 flags)
 {
-	u32 first_ip = 0, last_ip = 0, cadt_flags = 0;
+	u32 first_ip = 0, last_ip = 0;
 	u64 elements;
 	struct bitmap_ipmac *map;
 	int ret;
@@ -399,59 +369,7 @@ bitmap_ipmac_create(struct ip_set *set, struct nlattr *tb[],
 
 	map->memsize = bitmap_bytes(0, elements - 1);
 	set->variant = &bitmap_ipmac;
-	if (tb[IPSET_ATTR_CADT_FLAGS])
-		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-	if (cadt_flags & IPSET_FLAG_WITH_COUNTERS) {
-		set->extensions |= IPSET_EXT_COUNTER;
-		if (tb[IPSET_ATTR_TIMEOUT]) {
-			map->dsize = sizeof(struct bitmap_ipmacct_elem);
-			map->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct bitmap_ipmacct_elem, timeout);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_ipmacct_elem, counter);
-
-			if (!init_map_ipmac(set, map, first_ip, last_ip,
-					    elements)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-			map->timeout = ip_set_timeout_uget(
-				tb[IPSET_ATTR_TIMEOUT]);
-			set->extensions |= IPSET_EXT_TIMEOUT;
-			bitmap_ipmac_gc_init(set, bitmap_ipmac_gc);
-		} else {
-			map->dsize = sizeof(struct bitmap_ipmacc_elem);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_ipmacc_elem, counter);
-
-			if (!init_map_ipmac(set, map, first_ip, last_ip,
-					    elements)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-		}
-	} else if (tb[IPSET_ATTR_TIMEOUT]) {
-		map->dsize = sizeof(struct bitmap_ipmact_elem);
-		map->offset[IPSET_OFFSET_TIMEOUT] =
-			offsetof(struct bitmap_ipmact_elem, timeout);
-
-		if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-		map->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-		set->extensions |= IPSET_EXT_TIMEOUT;
-		bitmap_ipmac_gc_init(set, bitmap_ipmac_gc);
-	} else {
-		map->dsize = sizeof(struct bitmap_ipmac_elem);
-
-		if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-		set->variant = &bitmap_ipmac;
-	}
-	return 0;
+	return mtype_do_create(map, tb, set, first_ip, last_ip, elements);
 }
 
 static struct ip_set_type bitmap_ipmac_type = {
diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index b220489..66c0c52 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -200,27 +200,6 @@ bitmap_port_same_set(const struct ip_set *a, const struct ip_set *b)
 struct bitmap_port_elem {
 };
 
-/* Timeout variant */
-
-struct bitmap_portt_elem {
-	unsigned long timeout;
-};
-
-/* Plain variant with counter */
-
-struct bitmap_portc_elem {
-	struct ip_set_counter counter;
-};
-
-/* Timeout variant with counter */
-
-struct bitmap_portct_elem {
-	unsigned long timeout;
-	struct ip_set_counter counter;
-};
-
-#include "ip_set_bitmap_gen.h"
-
 /* Create bitmap:ip type of sets */
 
 static bool
@@ -247,12 +226,15 @@ init_map_port(struct ip_set *set, struct bitmap_port *map,
 	return true;
 }
 
+#define create_args	u32 first_port, u32 last_port
+#define INIT_MAP()	init_map_port(set, map, first_port, last_port)
+#include "ip_set_bitmap_gen.h"
+
 static int
 bitmap_port_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 {
 	struct bitmap_port *map;
 	u16 first_port, last_port;
-	u32 cadt_flags = 0;
 
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT_TO) ||
@@ -276,55 +258,7 @@ bitmap_port_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 	map->elements = last_port - first_port + 1;
 	map->memsize = map->elements * sizeof(unsigned long);
 	set->variant = &bitmap_port;
-	if (tb[IPSET_ATTR_CADT_FLAGS])
-		cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-	if (cadt_flags & IPSET_FLAG_WITH_COUNTERS) {
-		set->extensions |= IPSET_EXT_COUNTER;
-		if (tb[IPSET_ATTR_TIMEOUT]) {
-			map->dsize = sizeof(struct bitmap_portct_elem);
-			map->offset[IPSET_OFFSET_TIMEOUT] =
-				offsetof(struct bitmap_portct_elem, timeout);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_portct_elem, counter);
-			if (!init_map_port(set, map, first_port, last_port)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-
-			map->timeout =
-				ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-			set->extensions |= IPSET_EXT_TIMEOUT;
-			bitmap_port_gc_init(set, bitmap_port_gc);
-		} else {
-			map->dsize = sizeof(struct bitmap_portc_elem);
-			map->offset[IPSET_OFFSET_COUNTER] =
-				offsetof(struct bitmap_portc_elem, counter);
-			if (!init_map_port(set, map, first_port, last_port)) {
-				kfree(map);
-				return -ENOMEM;
-			}
-		}
-	} else if (tb[IPSET_ATTR_TIMEOUT]) {
-		map->dsize = sizeof(struct bitmap_portt_elem);
-		map->offset[IPSET_OFFSET_TIMEOUT] =
-			offsetof(struct bitmap_portt_elem, timeout);
-		if (!init_map_port(set, map, first_port, last_port)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-
-		map->timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
-		set->extensions |= IPSET_EXT_TIMEOUT;
-		bitmap_port_gc_init(set, bitmap_port_gc);
-	} else {
-		map->dsize = 0;
-		if (!init_map_port(set, map, first_port, last_port)) {
-			kfree(map);
-			return -ENOMEM;
-		}
-
-	}
-	return 0;
+	return mtype_do_create(map, tb, set, first_port, last_port);
 }
 
 static struct ip_set_type bitmap_port_type = {
-- 
1.8.3.2

