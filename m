From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/64]: {ip,ip6,arp}_tables: consolidate iterator macros
Date: Tue, 18 Dec 2007 00:46:18 +0100 (MET)
Message-ID: <20071217234617.23601.2783.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38890 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXLQXqT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:19 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6,arp}_tables: consolidate iterator macros

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ab9bc844e8aa064500496a0de876e1afe4466d9c
tree eec689e3f3bffcd8f8e33b03142994eb26a595bf
parent 38d8a2e416379a76ad9feb3757b1c60e9573f675
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:38 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:38 +0100

 include/linux/netfilter/x_tables.h        |   43 +++++++++++++++++++++++
 include/linux/netfilter_arp/arp_tables.h  |   17 +--------
 include/linux/netfilter_ipv4/ip_tables.h  |   55 +++--------------------------
 include/linux/netfilter_ipv6/ip6_tables.h |   36 ++-----------------
 4 files changed, 55 insertions(+), 96 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 616e6f4..8ab754e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -126,6 +126,49 @@ struct xt_counters_info
 
 #define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
 
+/* fn returns 0 to continue iteration */
+#define XT_MATCH_ITERATE(type, e, fn, args...)			\
+({								\
+	unsigned int __i;					\
+	int __ret = 0;						\
+	struct xt_entry_match *__m;				\
+								\
+	for (__i = sizeof(type);				\
+	     __i < (e)->target_offset;				\
+	     __i += __m->u.match_size) {			\
+		__m = (void *)e + __i;				\
+								\
+		__ret = fn(__m , ## args);			\
+		if (__ret != 0)					\
+			break;					\
+	}							\
+	__ret;							\
+})
+
+/* fn returns 0 to continue iteration */
+#define XT_ENTRY_ITERATE_CONTINUE(type, entries, size, n, fn, args...) \
+({								\
+	unsigned int __i, __n;					\
+	int __ret = 0;						\
+	type *__entry;						\
+								\
+	for (__i = 0, __n = 0; __i < (size);			\
+	     __i += __entry->next_offset, __n++) { 		\
+		__entry = (void *)(entries) + __i;		\
+		if (__n < n)					\
+			continue;				\
+								\
+		__ret = fn(__entry , ## args);			\
+		if (__ret != 0)					\
+			break;					\
+	}							\
+	__ret;							\
+})
+
+/* fn returns 0 to continue iteration */
+#define XT_ENTRY_ITERATE(type, entries, size, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(type, entries, size, 0, fn, args)
+
 #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 2fc73fa..e44811b 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -217,21 +217,8 @@ static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e
 }
 
 /* fn returns 0 to continue iteration */
-#define ARPT_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct arpt_entry *__entry;				\
-								\
-	for (__i = 0; __i < (size); __i += __entry->next_offset) { \
-		__entry = (void *)(entries) + __i;		\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct arpt_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 54da616..1e0cfca 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -229,60 +229,17 @@ ipt_get_target(struct ipt_entry *e)
 }
 
 /* fn returns 0 to continue iteration */
-#define IPT_MATCH_ITERATE(e, fn, args...)	\
-({						\
-	unsigned int __i;			\
-	int __ret = 0;				\
-	struct ipt_entry_match *__match;	\
-						\
-	for (__i = sizeof(struct ipt_entry);	\
-	     __i < (e)->target_offset;		\
-	     __i += __match->u.match_size) {	\
-		__match = (void *)(e) + __i;	\
-						\
-		__ret = fn(__match , ## args);	\
-		if (__ret != 0)			\
-			break;			\
-	}					\
-	__ret;					\
-})
+#define IPT_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ipt_entry, e, fn, ## args)
 
 /* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct ipt_entry *__entry;				\
-								\
-	for (__i = 0; __i < (size); __i += __entry->next_offset) { \
-		__entry = (void *)(entries) + __i;		\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
 
 /* fn returns 0 to continue iteration */
 #define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-({								\
-	unsigned int __i, __n;					\
-	int __ret = 0;						\
-	struct ipt_entry *__entry;				\
-								\
-	for (__i = 0, __n = 0; __i < (size);			\
-	     __i += __entry->next_offset, __n++) { 		\
-		__entry = (void *)(entries) + __i;		\
-		if (__n < n)					\
-			continue;				\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+	XT_ENTRY_ITERATE_CONTINUE(struct ipt_entry, entries, size, n, fn, \
+				  ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 2e98654..8257b52 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -289,40 +289,12 @@ ip6t_get_target(struct ip6t_entry *e)
 }
 
 /* fn returns 0 to continue iteration */
-#define IP6T_MATCH_ITERATE(e, fn, args...)	\
-({						\
-	unsigned int __i;			\
-	int __ret = 0;				\
-	struct ip6t_entry_match *__m;		\
-						\
-	for (__i = sizeof(struct ip6t_entry);	\
-	     __i < (e)->target_offset;		\
-	     __i += __m->u.match_size) {	\
-		__m = (void *)(e) + __i;	\
-						\
-		__ret = fn(__m , ## args);	\
-		if (__ret != 0)			\
-			break;			\
-	}					\
-	__ret;					\
-})
+#define IP6T_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ip6t_entry, e, fn, ## args)
 
 /* fn returns 0 to continue iteration */
-#define IP6T_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct ip6t_entry *__e;					\
-								\
-	for (__i = 0; __i < (size); __i += __e->next_offset) {	\
-		__e = (void *)(entries) + __i;			\
-								\
-		__ret = fn(__e , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ip6t_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
