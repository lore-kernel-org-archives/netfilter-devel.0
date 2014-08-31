From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: get rid of cached copies of x_tables.h and xt_LOG.h
Date: Sun, 31 Aug 2014 21:58:17 +0200
Message-ID: <1409515098-11953-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39595 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaHaT5j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:57:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Keeping the full cached copy of x_tables.h file in tree is too much for
just the XT_EXTENSION_MAXNAMELEN constant. Simimarly, xt_LOG.h is not
actually required by the tests, we can use any random data to make sure
the setter and getter provide similar data. So, let's get rid of these
headers from the library tree.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/Makefile.am |    2 +-
 include/linux/netfilter/x_tables.h  |  185 -----------------------------------
 include/linux/netfilter/xt_LOG.h    |   19 ----
 src/expr/match.c                    |    4 +-
 src/expr/target.c                   |    4 +-
 tests/nft-expr_match-test.c         |   15 +--
 tests/nft-expr_target-test.c        |   16 +--
 7 files changed, 12 insertions(+), 233 deletions(-)
 delete mode 100644 include/linux/netfilter/x_tables.h
 delete mode 100644 include/linux/netfilter/xt_LOG.h

diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
index a349b91..442463c 100644
--- a/include/linux/netfilter/Makefile.am
+++ b/include/linux/netfilter/Makefile.am
@@ -1 +1 @@
-noinst_HEADERS = nfnetlink.h nf_tables.h nf_tables_compat.h xt_LOG.h
+noinst_HEADERS = nfnetlink.h nf_tables.h nf_tables_compat.h
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
deleted file mode 100644
index 4120970..0000000
--- a/include/linux/netfilter/x_tables.h
+++ /dev/null
@@ -1,185 +0,0 @@
-#ifndef _X_TABLES_H
-#define _X_TABLES_H
-#include <linux/kernel.h>
-#include <linux/types.h>
-
-#define XT_FUNCTION_MAXNAMELEN 30
-#define XT_EXTENSION_MAXNAMELEN 29
-#define XT_TABLE_MAXNAMELEN 32
-
-struct xt_entry_match {
-	union {
-		struct {
-			__u16 match_size;
-
-			/* Used by userspace */
-			char name[XT_EXTENSION_MAXNAMELEN];
-			__u8 revision;
-		} user;
-		struct {
-			__u16 match_size;
-
-			/* Used inside the kernel */
-			struct xt_match *match;
-		} kernel;
-
-		/* Total length */
-		__u16 match_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-struct xt_entry_target {
-	union {
-		struct {
-			__u16 target_size;
-
-			/* Used by userspace */
-			char name[XT_EXTENSION_MAXNAMELEN];
-			__u8 revision;
-		} user;
-		struct {
-			__u16 target_size;
-
-			/* Used inside the kernel */
-			struct xt_target *target;
-		} kernel;
-
-		/* Total length */
-		__u16 target_size;
-	} u;
-
-	unsigned char data[0];
-};
-
-#define XT_TARGET_INIT(__name, __size)					       \
-{									       \
-	.target.u.user = {						       \
-		.target_size	= XT_ALIGN(__size),			       \
-		.name		= __name,				       \
-	},								       \
-}
-
-struct xt_standard_target {
-	struct xt_entry_target target;
-	int verdict;
-};
-
-struct xt_error_target {
-	struct xt_entry_target target;
-	char errorname[XT_FUNCTION_MAXNAMELEN];
-};
-
-/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
- * kernel supports, if >= revision. */
-struct xt_get_revision {
-	char name[XT_EXTENSION_MAXNAMELEN];
-	__u8 revision;
-};
-
-/* CONTINUE verdict for targets */
-#define XT_CONTINUE 0xFFFFFFFF
-
-/* For standard target */
-#define XT_RETURN (-NF_REPEAT - 1)
-
-/* this is a dummy structure to find out the alignment requirement for a struct
- * containing all the fundamental data types that are used in ipt_entry,
- * ip6t_entry and arpt_entry.  This sucks, and it is a hack.  It will be my
- * personal pleasure to remove it -HW
- */
-struct _xt_align {
-	__u8 u8;
-	__u16 u16;
-	__u32 u32;
-	__u64 u64;
-};
-
-#define XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _xt_align))
-
-/* Standard return verdict, or do jump. */
-#define XT_STANDARD_TARGET ""
-/* Error verdict. */
-#define XT_ERROR_TARGET "ERROR"
-
-#define SET_COUNTER(c,b,p) do { (c).bcnt = (b); (c).pcnt = (p); } while(0)
-#define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
-
-struct xt_counters {
-	__u64 pcnt, bcnt;			/* Packet and byte counters */
-};
-
-/* The argument to IPT_SO_ADD_COUNTERS. */
-struct xt_counters_info {
-	/* Which table. */
-	char name[XT_TABLE_MAXNAMELEN];
-
-	unsigned int num_counters;
-
-	/* The counters (actually `number' of these). */
-	struct xt_counters counters[0];
-};
-
-#define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
-
-/* fn returns 0 to continue iteration */
-#define XT_MATCH_ITERATE(type, e, fn, args...)			\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct xt_entry_match *__m;				\
-								\
-	for (__i = sizeof(type);				\
-	     __i < (e)->target_offset;				\
-	     __i += __m->u.match_size) {			\
-		__m = (void *)e + __i;				\
-								\
-		__ret = fn(__m , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
-
-/* fn returns 0 to continue iteration */
-#define XT_ENTRY_ITERATE_CONTINUE(type, entries, size, n, fn, args...) \
-({								\
-	unsigned int __i, __n;					\
-	int __ret = 0;						\
-	type *__entry;						\
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
-
-/* fn returns 0 to continue iteration */
-#define XT_ENTRY_ITERATE(type, entries, size, fn, args...) \
-	XT_ENTRY_ITERATE_CONTINUE(type, entries, size, 0, fn, args)
-
-
-/* pos is normally a struct ipt_entry/ip6t_entry/etc. */
-#define xt_entry_foreach(pos, ehead, esize) \
-	for ((pos) = (typeof(pos))(ehead); \
-	     (pos) < (typeof(pos))((char *)(ehead) + (esize)); \
-	     (pos) = (typeof(pos))((char *)(pos) + (pos)->next_offset))
-
-/* can only be xt_entry_match, so no use of typeof here */
-#define xt_ematch_foreach(pos, entry) \
-	for ((pos) = (struct xt_entry_match *)entry->elems; \
-	     (pos) < (struct xt_entry_match *)((char *)(entry) + \
-	             (entry)->target_offset); \
-	     (pos) = (struct xt_entry_match *)((char *)(pos) + \
-	             (pos)->u.match_size))
-
-
-#endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
deleted file mode 100644
index cac0790..0000000
--- a/include/linux/netfilter/xt_LOG.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _XT_LOG_H
-#define _XT_LOG_H
-
-/* make sure not to change this without changing nf_log.h:NF_LOG_* (!) */
-#define XT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define XT_LOG_TCPOPT		0x02	/* Log TCP options */
-#define XT_LOG_IPOPT		0x04	/* Log IP options */
-#define XT_LOG_UID		0x08	/* Log UID owning local socket */
-#define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
-#define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
-#define XT_LOG_MASK		0x2f
-
-struct xt_log_info {
-	unsigned char level;
-	unsigned char logflags;
-	char prefix[30];
-};
-
-#endif /* _XT_LOG_H */
diff --git a/src/expr/match.c b/src/expr/match.c
index 378d5dd..dc66585 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -20,13 +20,15 @@
 
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
-#include <linux/netfilter/x_tables.h>
 
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
 
 #include "expr_ops.h"
 
+/* From include/linux/netfilter/x_tables.h */
+#define XT_EXTENSION_MAXNAMELEN 29
+
 struct nft_expr_match {
 	char		name[XT_EXTENSION_MAXNAMELEN];
 	uint32_t	rev;
diff --git a/src/expr/target.c b/src/expr/target.c
index b3966a6..094f02a 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -20,7 +20,9 @@
 
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
-#include <linux/netfilter/x_tables.h>
+
+/* From include/linux/netfilter/x_tables.h */
+#define XT_EXTENSION_MAXNAMELEN 29
 
 #include <libnftnl/expr.h>
 #include <libnftnl/rule.h>
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 96b063a..dc5735a 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -16,7 +16,6 @@
 #include <netinet/in.h>
 #include <netinet/ip.h>
 #include <linux/netfilter/nf_tables.h>
-#include <linux/netfilter/xt_iprange.h>
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
@@ -60,7 +59,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nft_rule_expr_iter *iter_a, *iter_b;
 	struct nft_rule_expr *rule_a, *rule_b;
-	struct xt_iprange_mtinfo *info;
+	char data[16] = "0123456789abcdef";
 
 	a = nft_rule_alloc();
 	b = nft_rule_alloc();
@@ -72,17 +71,7 @@ int main(int argc, char *argv[])
 
 	nft_rule_expr_set_str(ex, NFT_EXPR_MT_NAME, "Tests");
 	nft_rule_expr_set_u32(ex, NFT_EXPR_MT_REV, 0x12345678);
-
-        info = calloc(1, sizeof(struct xt_iprange_mtinfo));
-        if (info == NULL)
-                print_err("OOM");
-
-        info->src_min.ip = info->dst_min.ip = inet_addr("127.0.0.1");
-        info->src_max.ip = info->dst_max.ip = inet_addr("127.0.0.1");
-        info->flags = IPRANGE_SRC;
-
-        nft_rule_expr_set(ex, NFT_EXPR_MT_INFO, info, sizeof(info));
-
+        nft_rule_expr_set(ex, NFT_EXPR_MT_INFO, strdup(data), sizeof(data));
 	nft_rule_add_expr(a, ex);
 
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 9387779..838b3fd 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -15,8 +15,6 @@
 #include <netinet/in.h>
 #include <netinet/ip.h>
 #include <linux/netfilter/nf_tables.h>
-#include <linux/netfilter/xt_iprange.h>
-#include <linux/netfilter/xt_LOG.h>
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
@@ -57,10 +55,10 @@ int main(int argc, char *argv[])
 	struct nft_rule *a, *b;
 	struct nft_rule_expr *ex;
 	struct nlmsghdr *nlh;
-	struct xt_log_info *info;
 	char buf[4096];
 	struct nft_rule_expr_iter *iter_a, *iter_b;
 	struct nft_rule_expr *rule_a, *rule_b;
+	char data[16] = "0123456789abcdef";
 
 	a = nft_rule_alloc();
 	b = nft_rule_alloc();
@@ -70,18 +68,10 @@ int main(int argc, char *argv[])
 	ex = nft_rule_expr_alloc("target");
 	if (ex == NULL)
 		print_err("OOM");
+
 	nft_rule_expr_set(ex, NFT_EXPR_TG_NAME, "test", strlen("test"));
 	nft_rule_expr_set_u32(ex, NFT_EXPR_TG_REV, 0x12345678);
-
-	info = calloc(1, sizeof(struct xt_log_info));
-	if (info == NULL)
-		print_err("OOM");
-	sprintf(info->prefix, "test: ");
-	info->prefix[sizeof(info->prefix)-1] = '\0';
-	info->logflags = 0x0f;
-	info->level = 5;
-	nft_rule_expr_set(ex, NFT_EXPR_TG_INFO, info, sizeof(*info));
-
+	nft_rule_expr_set(ex, NFT_EXPR_TG_INFO, strdup(data), sizeof(data));
 	nft_rule_add_expr(a, ex);
 
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
-- 
1.7.10.4

