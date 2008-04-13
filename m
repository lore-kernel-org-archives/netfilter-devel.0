From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/8] Add all necessary header files - compilation fix for various cases
Date: Sun, 13 Apr 2008 10:25:48 +0200
Message-ID: <e6284a55b23e8efcb568672c4e49dee2e98cbf4e.1208075035.git.jengelh@computergmbh.de>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36085 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYDMIZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:25:56 -0400
In-Reply-To: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
References: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow iptables to compile without a kernel source tree. This
implies fixing build for older kernels, such as 2.6.17 which
lack xt_SECMARK.h.
---
 Makefile.am                               |    2 +-
 configure.ac                              |   10 ++-
 include/linux/netfilter.h                 |    2 +
 include/linux/netfilter/x_tables.h        |   43 +++++++++++++
 include/linux/netfilter/xt_SECMARK.h      |   26 ++++++++
 include/linux/netfilter_ipv4/ip_tables.h  |   66 +++------------------
 include/linux/netfilter_ipv4/ipt_DSCP.h   |   18 ++++++
 include/linux/netfilter_ipv4/ipt_LOG.h    |   18 ++++++
 include/linux/netfilter_ipv4/ipt_REJECT.h |   20 ++++++
 include/linux/netfilter_ipv4/ipt_TOS.h    |   12 ++++
 include/linux/netfilter_ipv4/ipt_dscp.h   |   21 +++++++
 include/linux/netfilter_ipv4/ipt_owner.h  |   20 ++++++
 include/linux/netfilter_ipv4/ipt_tos.h    |   13 ++++
 include/linux/netfilter_ipv6/ip6_tables.h |   46 +++------------
 include/linux/netfilter_ipv6/ip6t_LOG.h   |   18 ++++++
 libipq/Makefile.am                        |    2 +-
 16 files changed, 238 insertions(+), 99 deletions(-)
 create mode 100644 include/linux/netfilter/xt_SECMARK.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_DSCP.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_LOG.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_REJECT.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_TOS.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_dscp.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_owner.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_tos.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_LOG.h

diff --git a/Makefile.am b/Makefile.am
index 0a28241..8137c93 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ AUTOMAKE_OPTIONS = foreign subdir-objects
 
 regular_CFLAGS  := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
-AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
 if ENABLE_LIBIPQ
 SUBDIRS         += libipq
diff --git a/configure.ac b/configure.ac
index 9c42681..10d4380 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,8 +8,6 @@ AM_PROG_CC_C_O
 AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
-kbuilddir="/lib/modules/$(uname -r)/build";
-ksourcedir="/lib/modules/$(uname -r)/source";
 AC_ARG_WITH([kernel],
 	AS_HELP_STRING([--with-kernel=PATH],
 	[Path to kernel source/build directory]),
@@ -45,7 +43,13 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\" -DXTABLES_INTERNAL";
-kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
+kinclude_CFLAGS="";
+if [[ -n "$kbuilddir" ]]; then
+	kinclude_CFLAGS="$kinclude_CFLAGS -I $kbuilddir/include";
+fi;
+if [[ -n "$ksourcedir" ]]; then
+	kinclude_CFLAGS="$kinclude_CFLAGS -I $ksourcedir/include";
+fi;
 
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3c5b889..6922c7f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_NETFILTER_H
 #define __LINUX_NETFILTER_H
 
+//#include <linux/compiler.h>
+
 /* Responses from hook functions. */
 #define NF_DROP 0
 #define NF_ACCEPT 1
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 95bc695..89eae5c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -126,5 +126,48 @@ struct xt_counters_info
 
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
 
 #endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
new file mode 100644
index 0000000..c53fbff
--- /dev/null
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -0,0 +1,26 @@
+#ifndef _XT_SECMARK_H_target
+#define _XT_SECMARK_H_target
+
+/*
+ * This is intended for use by various security subsystems (but not
+ * at the same time).
+ *
+ * 'mode' refers to the specific security subsystem which the
+ * packets are being marked for.
+ */
+#define SECMARK_MODE_SEL	0x01		/* SELinux */
+#define SECMARK_SELCTX_MAX	256
+
+struct xt_secmark_target_selinux_info {
+	u_int32_t selsid;
+	char selctx[SECMARK_SELCTX_MAX];
+};
+
+struct xt_secmark_target_info {
+	u_int8_t mode;
+	union {
+		struct xt_secmark_target_selinux_info sel;
+	} u;
+};
+
+#endif /*_XT_SECMARK_H_target */
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 2934cee..fc64b97 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -148,10 +148,10 @@ struct ipt_getinfo
 	unsigned int valid_hooks;
 
 	/* Hook entry points: one per netfilter hook. */
-	unsigned int hook_entry[NF_IP_NUMHOOKS];
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[NF_IP_NUMHOOKS];
+	unsigned int underflow[NF_INET_NUMHOOKS];
 
 	/* Number of entries */
 	unsigned int num_entries;
@@ -177,16 +177,16 @@ struct ipt_replace
 	unsigned int size;
 
 	/* Hook entry points. */
-	unsigned int hook_entry[NF_IP_NUMHOOKS];
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[NF_IP_NUMHOOKS];
+	unsigned int underflow[NF_INET_NUMHOOKS];
 
 	/* Information about old entries: */
 	/* Number of counters (must be equal to current number of entries). */
 	unsigned int num_counters;
 	/* The old entries' counters. */
-	struct xt_counters __user *counters;
+	struct xt_counters *counters;
 
 	/* The entries (hang off end: not really an array). */
 	struct ipt_entry entries[0];
@@ -221,60 +221,12 @@ ipt_get_target(struct ipt_entry *e)
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
-
-/* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
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
+#define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
diff --git a/include/linux/netfilter_ipv4/ipt_DSCP.h b/include/linux/netfilter_ipv4/ipt_DSCP.h
new file mode 100644
index 0000000..3491e52
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_DSCP.h
@@ -0,0 +1,18 @@
+/* iptables module for setting the IPv4 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * ipt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
+*/
+#ifndef _IPT_DSCP_TARGET_H
+#define _IPT_DSCP_TARGET_H
+#include <linux/netfilter_ipv4/ipt_dscp.h>
+#include <linux/netfilter/xt_DSCP.h>
+
+#define ipt_DSCP_info xt_DSCP_info
+
+#endif /* _IPT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
new file mode 100644
index 0000000..90fa652
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -0,0 +1,18 @@
+#ifndef _IPT_LOG_H
+#define _IPT_LOG_H
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IPT_LOG_IPOPT		0x04	/* Log IP options */
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define IPT_LOG_MASK		0x1f
+
+struct ipt_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
new file mode 100644
index 0000000..4293a1a
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_REJECT.h
@@ -0,0 +1,20 @@
+#ifndef _IPT_REJECT_H
+#define _IPT_REJECT_H
+
+enum ipt_reject_with {
+	IPT_ICMP_NET_UNREACHABLE,
+	IPT_ICMP_HOST_UNREACHABLE,
+	IPT_ICMP_PROT_UNREACHABLE,
+	IPT_ICMP_PORT_UNREACHABLE,
+	IPT_ICMP_ECHOREPLY,
+	IPT_ICMP_NET_PROHIBITED,
+	IPT_ICMP_HOST_PROHIBITED,
+	IPT_TCP_RESET,
+	IPT_ICMP_ADMIN_PROHIBITED
+};
+
+struct ipt_reject_info {
+	enum ipt_reject_with with;      /* reject type */
+};
+
+#endif /*_IPT_REJECT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_TOS.h b/include/linux/netfilter_ipv4/ipt_TOS.h
new file mode 100644
index 0000000..6bf9e1f
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_TOS.h
@@ -0,0 +1,12 @@
+#ifndef _IPT_TOS_H_target
+#define _IPT_TOS_H_target
+
+#ifndef IPTOS_NORMALSVC
+#define IPTOS_NORMALSVC 0
+#endif
+
+struct ipt_tos_target_info {
+	u_int8_t tos;
+};
+
+#endif /*_IPT_TOS_H_target*/
diff --git a/include/linux/netfilter_ipv4/ipt_dscp.h b/include/linux/netfilter_ipv4/ipt_dscp.h
new file mode 100644
index 0000000..4b82ca9
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_dscp.h
@@ -0,0 +1,21 @@
+/* iptables module for matching the IPv4 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * ipt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
+*/
+#ifndef _IPT_DSCP_H
+#define _IPT_DSCP_H
+
+#include <linux/netfilter/xt_dscp.h>
+
+#define IPT_DSCP_MASK	XT_DSCP_MASK
+#define IPT_DSCP_SHIFT	XT_DSCP_SHIFT
+#define IPT_DSCP_MAX	XT_DSCP_MAX
+
+#define ipt_dscp_info	xt_dscp_info
+
+#endif /* _IPT_DSCP_H */
diff --git a/include/linux/netfilter_ipv4/ipt_owner.h b/include/linux/netfilter_ipv4/ipt_owner.h
new file mode 100644
index 0000000..92f4bda
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_owner.h
@@ -0,0 +1,20 @@
+#ifndef _IPT_OWNER_H
+#define _IPT_OWNER_H
+
+/* match and invert flags */
+#define IPT_OWNER_UID	0x01
+#define IPT_OWNER_GID	0x02
+#define IPT_OWNER_PID	0x04
+#define IPT_OWNER_SID	0x08
+#define IPT_OWNER_COMM	0x10
+
+struct ipt_owner_info {
+    uid_t uid;
+    gid_t gid;
+    pid_t pid;
+    pid_t sid;
+    char comm[16];
+    u_int8_t match, invert;	/* flags */
+};
+
+#endif /*_IPT_OWNER_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_tos.h b/include/linux/netfilter_ipv4/ipt_tos.h
new file mode 100644
index 0000000..a21f5df
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_tos.h
@@ -0,0 +1,13 @@
+#ifndef _IPT_TOS_H
+#define _IPT_TOS_H
+
+struct ipt_tos_info {
+    u_int8_t tos;
+    u_int8_t invert;
+};
+
+#ifndef IPTOS_NORMALSVC
+#define IPTOS_NORMALSVC 0
+#endif
+
+#endif /*_IPT_TOS_H*/
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 36e3301..68b22fc 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -208,10 +208,10 @@ struct ip6t_getinfo
 	unsigned int valid_hooks;
 
 	/* Hook entry points: one per netfilter hook. */
-	unsigned int hook_entry[NF_IP6_NUMHOOKS];
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[NF_IP6_NUMHOOKS];
+	unsigned int underflow[NF_INET_NUMHOOKS];
 
 	/* Number of entries */
 	unsigned int num_entries;
@@ -237,16 +237,16 @@ struct ip6t_replace
 	unsigned int size;
 
 	/* Hook entry points. */
-	unsigned int hook_entry[NF_IP6_NUMHOOKS];
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
 
 	/* Underflow points. */
-	unsigned int underflow[NF_IP6_NUMHOOKS];
+	unsigned int underflow[NF_INET_NUMHOOKS];
 
 	/* Information about old entries: */
 	/* Number of counters (must be equal to current number of entries). */
 	unsigned int num_counters;
 	/* The old entries' counters. */
-	struct xt_counters __user *counters;
+	struct xt_counters *counters;
 
 	/* The entries (hang off end: not really an array). */
 	struct ip6t_entry entries[0];
@@ -281,40 +281,12 @@ ip6t_get_target(struct ip6t_entry *e)
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
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
new file mode 100644
index 0000000..0d0119b
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -0,0 +1,18 @@
+#ifndef _IP6T_LOG_H
+#define _IP6T_LOG_H
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IP6T_LOG_IPOPT		0x04	/* Log IP options */
+#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
+#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
+#define IP6T_LOG_MASK		0x1f
+
+struct ip6t_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /*_IPT_LOG_H*/
diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index 942a874..d4245e7 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -1,6 +1,6 @@
 # -*- Makefile -*-
 
-AM_CFLAGS = ${regular_CFLAGS} -I${top_srcdir}/include
+AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
 
 libipq_a_SOURCES = libipq.c
 lib_LIBRARIES    = libipq.a
-- 
1.5.5.rc3

