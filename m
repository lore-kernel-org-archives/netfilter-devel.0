From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] includes: sync header files from Linux 2.6.35-rc1
Date: Thu, 24 Jun 2010 10:14:02 +0200
Message-ID: <1277367245-14961-2-git-send-email-jengelh@medozas.de>
References: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37889 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0FXIOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:14:12 -0400
In-Reply-To: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/kernel.h                |   62 +++++++++++++++++++++++++++++++++
 include/linux/netfilter/x_tables.h    |   30 +++++++++++-----
 include/linux/netfilter/xt_CONNMARK.h |   22 +-----------
 include/linux/netfilter/xt_MARK.h     |    6 +---
 include/linux/netfilter/xt_TEE.h      |    3 ++
 include/linux/netfilter/xt_connmark.h |   11 ++++++
 include/linux/netfilter/xt_mark.h     |    4 ++
 include/linux/netfilter/xt_recent.h   |    7 ++++
 include/linux/netfilter_ipv6.h        |    1 +
 9 files changed, 111 insertions(+), 35 deletions(-)
 create mode 100644 include/linux/kernel.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
new file mode 100644
index 0000000..d1671a0
--- /dev/null
+++ b/include/linux/kernel.h
@@ -0,0 +1,62 @@
+#ifndef _LINUX_KERNEL_H
+#define _LINUX_KERNEL_H
+
+/*
+ * 'kernel.h' contains some often-used function prototypes etc
+ */
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	long uptime;			/* Seconds since boot */
+	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
+	unsigned long totalram;		/* Total usable main memory size */
+	unsigned long freeram;		/* Available memory size */
+	unsigned long sharedram;	/* Amount of shared memory */
+	unsigned long bufferram;	/* Memory used by buffers */
+	unsigned long totalswap;	/* Total swap space size */
+	unsigned long freeswap;		/* swap space still available */
+	unsigned short procs;		/* Number of current processes */
+	unsigned short pad;		/* explicit padding for m68k */
+	unsigned long totalhigh;	/* Total high memory size */
+	unsigned long freehigh;		/* Available high memory size */
+	unsigned int mem_unit;		/* Memory unit size in bytes */
+	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
+};
+
+/* Force a compilation error if condition is true */
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+
+/* Force a compilation error if condition is constant and true */
+#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+
+/* Trap pasters of __FUNCTION__ at compile-time */
+#define __FUNCTION__ (__func__)
+
+/* This helps us to avoid #ifdef CONFIG_NUMA */
+#ifdef CONFIG_NUMA
+#define NUMA_BUILD 1
+#else
+#define NUMA_BUILD 0
+#endif
+
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
+
+#endif
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index ccb5641..fa2d957 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,9 +1,10 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
-
+#include <linux/kernel.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
+#define XT_EXTENSION_MAXNAMELEN 29
 #define XT_TABLE_MAXNAMELEN 32
 
 struct xt_entry_match {
@@ -12,8 +13,7 @@ struct xt_entry_match {
 			__u16 match_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_EXTENSION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -36,8 +36,7 @@ struct xt_entry_target {
 			__u16 target_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_EXTENSION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -70,8 +69,7 @@ struct xt_standard_target {
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision {
-	char name[XT_FUNCTION_MAXNAMELEN-1];
-
+	char name[XT_EXTENSION_MAXNAMELEN];
 	__u8 revision;
 };
 
@@ -93,8 +91,7 @@ struct _xt_align {
 	__u64 u64;
 };
 
-#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) 	\
-			& ~(__alignof__(struct _xt_align)-1))
+#define XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _xt_align))
 
 /* Standard return verdict, or do jump. */
 #define XT_STANDARD_TARGET ""
@@ -165,4 +162,19 @@ struct xt_counters_info {
 	XT_ENTRY_ITERATE_CONTINUE(type, entries, size, 0, fn, args)
 
 
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
 #endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 0a85458..2f2e48e 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -1,26 +1,6 @@
 #ifndef _XT_CONNMARK_H_target
 #define _XT_CONNMARK_H_target
 
-#include <linux/types.h>
-
-/* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
- * by Henrik Nordstrom <hno@marasystems.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-enum {
-	XT_CONNMARK_SET = 0,
-	XT_CONNMARK_SAVE,
-	XT_CONNMARK_RESTORE
-};
-
-struct xt_connmark_tginfo1 {
-	__u32 ctmark, ctmask, nfmask;
-	__u8 mode;
-};
+#include <linux/netfilter/xt_connmark.h>
 
 #endif /*_XT_CONNMARK_H_target*/
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
index bc9561b..41c456d 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -1,10 +1,6 @@
 #ifndef _XT_MARK_H_target
 #define _XT_MARK_H_target
 
-#include <linux/types.h>
-
-struct xt_mark_tginfo2 {
-	__u32 mark, mask;
-};
+#include <linux/netfilter/xt_mark.h>
 
 #endif /*_XT_MARK_H_target */
diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
index 55d4a50..5c21d5c 100644
--- a/include/linux/netfilter/xt_TEE.h
+++ b/include/linux/netfilter/xt_TEE.h
@@ -4,6 +4,9 @@
 struct xt_tee_tginfo {
 	union nf_inet_addr gw;
 	char oif[16];
+
+	/* used internally by the kernel */
+	struct xt_tee_priv *priv __attribute__((aligned(8)));
 };
 
 #endif /* _XT_TEE_TARGET_H */
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index 619e47c..efc17a8 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -12,6 +12,17 @@
  * (at your option) any later version.
  */
 
+enum {
+	XT_CONNMARK_SET = 0,
+	XT_CONNMARK_SAVE,
+	XT_CONNMARK_RESTORE
+};
+
+struct xt_connmark_tginfo1 {
+	__u32 ctmark, ctmask, nfmask;
+	__u8 mode;
+};
+
 struct xt_connmark_mtinfo1 {
 	__u32 mark, mask;
 	__u8 invert;
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
index 6607c8f..ecadc40 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -3,6 +3,10 @@
 
 #include <linux/types.h>
 
+struct xt_mark_tginfo2 {
+	__u32 mark, mask;
+};
+
 struct xt_mark_mtinfo1 {
 	__u32 mark, mask;
 	__u8 invert;
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index d2c2766..83318e0 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -9,6 +9,7 @@ enum {
 	XT_RECENT_UPDATE   = 1 << 2,
 	XT_RECENT_REMOVE   = 1 << 3,
 	XT_RECENT_TTL      = 1 << 4,
+	XT_RECENT_REAP     = 1 << 5,
 
 	XT_RECENT_SOURCE   = 0,
 	XT_RECENT_DEST     = 1,
@@ -16,6 +17,12 @@ enum {
 	XT_RECENT_NAME_LEN = 200,
 };
 
+/* Only allowed with --rcheck and --update */
+#define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
+
+#define XT_RECENT_VALID_FLAGS (XT_RECENT_CHECK|XT_RECENT_SET|XT_RECENT_UPDATE|\
+			       XT_RECENT_REMOVE|XT_RECENT_TTL|XT_RECENT_REAP)
+
 struct xt_recent_mtinfo {
 	__u32 seconds;
 	__u32 hit_count;
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 7430b39..f155b9d 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -57,6 +57,7 @@
 enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_FIRST = INT_MIN,
 	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP6_PRI_RAW = -300,
 	NF_IP6_PRI_SELINUX_FIRST = -225,
 	NF_IP6_PRI_CONNTRACK = -200,
 	NF_IP6_PRI_MANGLE = -150,
-- 
1.7.1

