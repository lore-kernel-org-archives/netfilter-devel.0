From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: resolve compile error involving XT_EXTENSION_MAXNAMELEN
Date: Tue, 21 Jan 2014 00:52:02 +0100
Message-ID: <1390261922-13182-3-git-send-email-jengelh@inai.de>
References: <1390261922-13182-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43513 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaATXwE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:52:04 -0500
In-Reply-To: <1390261922-13182-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.32 headers in /usr/include/linux again.
Ship a copy of x_tables.h from Linux 3.11.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/linux/netfilter/x_tables.h | 185 +++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)
 create mode 100644 include/linux/netfilter/x_tables.h

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
-- 
1.8.4

