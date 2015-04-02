From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH arptables 1/2] src: cache in tree and use x_tables.h
Date: Thu,  2 Apr 2015 10:51:16 +0200
Message-ID: <1427964677-5887-1-git-send-email-pablo@netfilter.org>
Cc: zhangcy@cn.fujitsu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbbDBIrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 04:47:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libarptc/libarptc.h              |    1 +
 include/linux/netfilter/x_tables.h       |  185 +++++++++++++++++++++++++
 include/linux/netfilter_arp/arp_tables.h |  222 ++++++------------------------
 libarptc/libarptc_incl.c                 |   17 +--
 4 files changed, 233 insertions(+), 192 deletions(-)
 create mode 100644 include/linux/netfilter/x_tables.h

diff --git a/include/libarptc/libarptc.h b/include/libarptc/libarptc.h
index e4f1175..ff4606f 100644
--- a/include/libarptc/libarptc.h
+++ b/include/libarptc/libarptc.h
@@ -3,6 +3,7 @@
 /* Library which manipulates filtering rules. */
 
 #include <libarptc/arpt_kernel_headers.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 
 #ifndef ARPT_MIN_ALIGN
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
new file mode 100644
index 0000000..4120970
--- /dev/null
+++ b/include/linux/netfilter/x_tables.h
@@ -0,0 +1,185 @@
+#ifndef _X_TABLES_H
+#define _X_TABLES_H
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#define XT_FUNCTION_MAXNAMELEN 30
+#define XT_EXTENSION_MAXNAMELEN 29
+#define XT_TABLE_MAXNAMELEN 32
+
+struct xt_entry_match {
+	union {
+		struct {
+			__u16 match_size;
+
+			/* Used by userspace */
+			char name[XT_EXTENSION_MAXNAMELEN];
+			__u8 revision;
+		} user;
+		struct {
+			__u16 match_size;
+
+			/* Used inside the kernel */
+			struct xt_match *match;
+		} kernel;
+
+		/* Total length */
+		__u16 match_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+struct xt_entry_target {
+	union {
+		struct {
+			__u16 target_size;
+
+			/* Used by userspace */
+			char name[XT_EXTENSION_MAXNAMELEN];
+			__u8 revision;
+		} user;
+		struct {
+			__u16 target_size;
+
+			/* Used inside the kernel */
+			struct xt_target *target;
+		} kernel;
+
+		/* Total length */
+		__u16 target_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+#define XT_TARGET_INIT(__name, __size)					       \
+{									       \
+	.target.u.user = {						       \
+		.target_size	= XT_ALIGN(__size),			       \
+		.name		= __name,				       \
+	},								       \
+}
+
+struct xt_standard_target {
+	struct xt_entry_target target;
+	int verdict;
+};
+
+struct xt_error_target {
+	struct xt_entry_target target;
+	char errorname[XT_FUNCTION_MAXNAMELEN];
+};
+
+/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >= revision. */
+struct xt_get_revision {
+	char name[XT_EXTENSION_MAXNAMELEN];
+	__u8 revision;
+};
+
+/* CONTINUE verdict for targets */
+#define XT_CONTINUE 0xFFFFFFFF
+
+/* For standard target */
+#define XT_RETURN (-NF_REPEAT - 1)
+
+/* this is a dummy structure to find out the alignment requirement for a struct
+ * containing all the fundamental data types that are used in ipt_entry,
+ * ip6t_entry and arpt_entry.  This sucks, and it is a hack.  It will be my
+ * personal pleasure to remove it -HW
+ */
+struct _xt_align {
+	__u8 u8;
+	__u16 u16;
+	__u32 u32;
+	__u64 u64;
+};
+
+#define XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _xt_align))
+
+/* Standard return verdict, or do jump. */
+#define XT_STANDARD_TARGET ""
+/* Error verdict. */
+#define XT_ERROR_TARGET "ERROR"
+
+#define SET_COUNTER(c,b,p) do { (c).bcnt = (b); (c).pcnt = (p); } while(0)
+#define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
+
+struct xt_counters {
+	__u64 pcnt, bcnt;			/* Packet and byte counters */
+};
+
+/* The argument to IPT_SO_ADD_COUNTERS. */
+struct xt_counters_info {
+	/* Which table. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	unsigned int num_counters;
+
+	/* The counters (actually `number' of these). */
+	struct xt_counters counters[0];
+};
+
+#define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
+
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
+
+/* pos is normally a struct ipt_entry/ip6t_entry/etc. */
+#define xt_entry_foreach(pos, ehead, esize) \
+	for ((pos) = (typeof(pos))(ehead); \
+	     (pos) < (typeof(pos))((char *)(ehead) + (esize)); \
+	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
+
+/* can only be xt_entry_match, so no use of typeof here */
+#define xt_ematch_foreach(pos, entry) \
+	for ((pos) = (struct xt_entry_match *)entry->elems; \
+	     (pos) < (struct xt_entry_match *)((char *)(entry) + \
+	             (entry)->target_offset); \
+	     (pos) = (struct xt_entry_match *)((char *)(pos) + \
+	             (pos)->u.match_size))
+
+
+#endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 0acda66..bb1ec64 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -9,18 +9,25 @@
 #ifndef _ARPTABLES_H
 #define _ARPTABLES_H
 
-#ifdef __KERNEL__
-#include <linux/if.h>
 #include <linux/types.h>
-#include <linux/in.h>
-#include <linux/if_arp.h>
-#include <linux/skbuff.h>
-#endif
 
 #include <linux/netfilter_arp.h>
 
-#define ARPT_FUNCTION_MAXNAMELEN 30
-#define ARPT_TABLE_MAXNAMELEN 32
+#include <linux/netfilter/x_tables.h>
+
+#define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+#define arpt_entry_target xt_entry_target
+#define arpt_standard_target xt_standard_target
+#define arpt_error_target xt_error_target
+#define ARPT_CONTINUE XT_CONTINUE
+#define ARPT_RETURN XT_RETURN
+#define arpt_counters_info xt_counters_info
+#define arpt_counters xt_counters
+#define ARPT_STANDARD_TARGET XT_STANDARD_TARGET
+#define ARPT_ERROR_TARGET XT_ERROR_TARGET
+#define ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct arpt_entry, entries, size, fn, ## args)
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
 
@@ -37,16 +44,16 @@ struct arpt_arp {
 	struct in_addr smsk, tmsk;
 
 	/* Device hw address length, src+target device addresses */
-	u_int8_t arhln, arhln_mask;
+	__u8 arhln, arhln_mask;
 	struct arpt_devaddr_info src_devaddr;
 	struct arpt_devaddr_info tgt_devaddr;
 
 	/* ARP operation code. */
-	u_int16_t arpop, arpop_mask;
+	__be16 arpop, arpop_mask;
 
 	/* ARP hardware address and protocol address format. */
-	u_int16_t arhrd, arhrd_mask;
-	u_int16_t arpro, arpro_mask;
+	__be16 arhrd, arhrd_mask;
+	__be16 arpro, arpro_mask;
 
 	/* The protocol address length is only accepted if it is 4
 	 * so there is no use in offering a way to do filtering on it.
@@ -56,43 +63,9 @@ struct arpt_arp {
 	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
 
 	/* Flags word */
-	u_int8_t flags;
+	__u8 flags;
 	/* Inverse flags */
-	u_int16_t invflags;
-};
-
-struct arpt_entry_target
-{
-	union {
-		struct {
-			u_int16_t target_size;
-
-			/* Used by userspace */
-			char name[ARPT_FUNCTION_MAXNAMELEN];
-		} user;
-		struct {
-			u_int16_t target_size;
-
-			/* Used inside the kernel */
-			struct arpt_target *target;
-		} kernel;
-
-		/* Total length */
-		u_int16_t target_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct arpt_standard_target
-{
-	struct arpt_entry_target target;
-	int verdict;
-};
-
-struct arpt_counters
-{
-	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
+	__u16 invflags;
 };
 
 /* Values for "flag" field in struct arpt_ip (general arp structure).
@@ -121,15 +94,15 @@ struct arpt_entry
 	struct arpt_arp arp;
 
 	/* Size of arpt_entry + matches */
-	u_int16_t target_offset;
+	__u16 target_offset;
 	/* Size of arpt_entry + matches + target */
-	u_int16_t next_offset;
+	__u16 next_offset;
 
 	/* Back pointer */
 	unsigned int comefrom;
 
 	/* Packet and byte counters. */
-	struct arpt_counters counters;
+	struct xt_counters counters;
 
 	/* The matches (if any), then the target. */
 	unsigned char elems[0];
@@ -139,8 +112,10 @@ struct arpt_entry
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use a raw
  * socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in.h before adding new number here.
  */
-#define ARPT_BASE_CTL		96	/* base for firewall socket options */
+#define ARPT_BASE_CTL		96
 
 #define ARPT_SO_SET_REPLACE		(ARPT_BASE_CTL)
 #define ARPT_SO_SET_ADD_COUNTERS	(ARPT_BASE_CTL + 1)
@@ -148,29 +123,24 @@ struct arpt_entry
 
 #define ARPT_SO_GET_INFO		(ARPT_BASE_CTL)
 #define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
-#define ARPT_SO_GET_MAX			ARPT_SO_GET_ENTRIES
-
-/* CONTINUE verdict for targets */
-#define ARPT_CONTINUE 0xFFFFFFFF
-
-/* For standard target */
-#define ARPT_RETURN (-NF_REPEAT - 1)
+/* #define ARPT_SO_GET_REVISION_MATCH	(APRT_BASE_CTL + 2) */
+#define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
+#define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
 
 /* The argument to ARPT_SO_GET_INFO */
-struct arpt_getinfo
-{
+struct arpt_getinfo {
 	/* Which table: caller fills this in. */
-	char name[ARPT_TABLE_MAXNAMELEN];
+	char name[XT_TABLE_MAXNAMELEN];
 
 	/* Kernel fills these in. */
 	/* Which hook entry points are valid: bitmask */
 	unsigned int valid_hooks;
 
 	/* Hook entry points: one per netfilter hook. */
-	unsigned int hook_entry[3];
+	unsigned int hook_entry[NF_ARP_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[3];
+	unsigned int underflow[NF_ARP_NUMHOOKS];
 
 	/* Number of entries */
 	unsigned int num_entries;
@@ -180,10 +150,9 @@ struct arpt_getinfo
 };
 
 /* The argument to ARPT_SO_SET_REPLACE. */
-struct arpt_replace
-{
+struct arpt_replace {
 	/* Which table. */
-	char name[ARPT_TABLE_MAXNAMELEN];
+	char name[XT_TABLE_MAXNAMELEN];
 
 	/* Which hook entry points are valid: bitmask.  You can't
            change this. */
@@ -196,38 +165,25 @@ struct arpt_replace
 	unsigned int size;
 
 	/* Hook entry points. */
-	unsigned int hook_entry[3];
+	unsigned int hook_entry[NF_ARP_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[3];
+	unsigned int underflow[NF_ARP_NUMHOOKS];
 
 	/* Information about old entries: */
 	/* Number of counters (must be equal to current number of entries). */
 	unsigned int num_counters;
 	/* The old entries' counters. */
-	struct arpt_counters *counters;
+	struct xt_counters *counters;
 
 	/* The entries (hang off end: not really an array). */
 	struct arpt_entry entries[0];
 };
 
-/* The argument to ARPT_SO_ADD_COUNTERS. */
-struct arpt_counters_info
-{
-	/* Which table. */
-	char name[ARPT_TABLE_MAXNAMELEN];
-
-	unsigned int num_counters;
-
-	/* The counters (actually `number' of these). */
-	struct arpt_counters counters[0];
-};
-
 /* The argument to ARPT_SO_GET_ENTRIES. */
-struct arpt_get_entries
-{
+struct arpt_get_entries {
 	/* Which table: user fills this in. */
-	char name[ARPT_TABLE_MAXNAMELEN];
+	char name[XT_TABLE_MAXNAMELEN];
 
 	/* User fills this in: total entry size. */
 	unsigned int size;
@@ -236,107 +192,13 @@ struct arpt_get_entries
 	struct arpt_entry entrytable[0];
 };
 
-/* Standard return verdict, or do jump. */
-#define ARPT_STANDARD_TARGET ""
-/* Error verdict. */
-#define ARPT_ERROR_TARGET "ERROR"
-
 /* Helper functions */
-static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e)
+static __inline__ struct xt_entry_target *arpt_get_target(struct arpt_entry *e)
 {
 	return (void *)e + e->target_offset;
 }
 
-/* fn returns 0 to continue iteration */
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
-
 /*
  *	Main firewall chains definitions and global var's definitions.
  */
-#ifdef __KERNEL__
-
-/* Registration hooks for targets. */
-struct arpt_target
-{
-	struct list_head list;
-
-	const char name[ARPT_FUNCTION_MAXNAMELEN];
-
-	/* Returns verdict. */
-	unsigned int (*target)(struct sk_buff **pskb,
-			       unsigned int hooknum,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       const void *targinfo,
-			       void *userdata);
-
-	/* Called when user tries to insert an entry of this type:
-           hook_mask is a bitmask of hooks from which it can be
-           called. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct arpt_entry *e,
-			  void *targinfo,
-			  unsigned int targinfosize,
-			  unsigned int hook_mask);
-
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
-
-extern int arpt_register_target(struct arpt_target *target);
-extern void arpt_unregister_target(struct arpt_target *target);
-
-/* Furniture shopping... */
-struct arpt_table
-{
-	struct list_head list;
-
-	/* A unique name... */
-	char name[ARPT_TABLE_MAXNAMELEN];
-
-	/* Seed table: copied in register_table */
-	struct arpt_replace *table;
-
-	/* What hooks you will enter on */
-	unsigned int valid_hooks;
-
-	/* Lock for the curtain */
-	rwlock_t lock;
-
-	/* Man behind the curtain... */
-	struct arpt_table_info *private;
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
-
-extern int arpt_register_table(struct arpt_table *table);
-extern void arpt_unregister_table(struct arpt_table *table);
-extern unsigned int arpt_do_table(struct sk_buff **pskb,
-				  unsigned int hook,
-				  const struct net_device *in,
-				  const struct net_device *out,
-				  struct arpt_table *table,
-				  void *userdata);
-
-#define ARPT_ALIGN(s) (((s) + (__alignof__(struct arpt_entry)-1)) & ~(__alignof__(struct arpt_entry)-1))
-#endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
index 1d2e8b7..a034930 100644
--- a/libarptc/libarptc_incl.c
+++ b/libarptc/libarptc_incl.c
@@ -40,13 +40,6 @@ struct counter_map
 	unsigned int mappos;
 };
 
-/* Convenience structures */
-struct arpt_error_target
-{
-	STRUCT_ENTRY_TARGET t;
-	char error[TABLE_MAXNAMELEN];
-};
-
 struct chain_cache
 {
 	char name[TABLE_MAXNAMELEN];
@@ -1342,9 +1335,9 @@ TC_CREATE_CHAIN(const ARPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 	newc.head.next_offset
 		= sizeof(STRUCT_ENTRY)
 		+ ALIGN(sizeof(struct arpt_error_target));
-	strcpy(newc.name.t.u.user.name, ERROR_TARGET);
-	newc.name.t.u.target_size = ALIGN(sizeof(struct arpt_error_target));
-	strcpy(newc.name.error, chain);
+	strcpy(newc.name.target.u.user.name, ERROR_TARGET);
+	newc.name.target.u.target_size = ALIGN(sizeof(struct arpt_error_target));
+	strcpy(newc.name.errorname, chain);
 
 	newc.ret.target_offset = sizeof(STRUCT_ENTRY);
 	newc.ret.next_offset
@@ -1482,8 +1475,8 @@ int TC_RENAME_CHAIN(const ARPT_CHAINLABEL oldname,
 	t = (struct arpt_error_target *)
 		GET_TARGET(get_entry(*handle, labeloff));
 
-	memset(t->error, 0, sizeof(t->error));
-	strcpy(t->error, newname);
+	memset(t->errorname, 0, sizeof(t->errorname));
+	strcpy(t->errorname, newname);
 	set_changed(*handle);
 
 	return 1;
-- 
1.7.10.4

