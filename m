From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v5 3/3] src: add xt compat support
Date: Tue, 12 Jul 2016 22:04:17 +0200
Message-ID: <20160712200417.21890-3-pablombg@gmail.com>
References: <20160712200417.21890-1-pablombg@gmail.com>
Cc: pablo@netfilter.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	"Pablo M . Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36132 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbcGLUF6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 16:05:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id x83so3192523wma.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 13:05:57 -0700 (PDT)
In-Reply-To: <20160712200417.21890-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira <pablo@netfilter.org>

At compilation time, you have to pass this option.

  # ./configure --with-xtables

And libxtables needs to be installed in your system.

This patch allows to list a ruleset containing xt extensions loaded
through iptables-compat-restore tool.

Example:

$ iptables-save > ruleset

$ cat ruleset
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p tcp -m multiport --dports 80,81 -j REJECT
COMMIT

$ sudo iptables-compat-restore ruleset

$ sudo nft list rulseset
table ip filter {
    chain INPUT {
        type filter hook input priority 0; policy accept;
        ip protocol tcp tcp dport { 80,81} counter packets 0 bytes 0 reject
    }

    chain FORWARD {
        type filter hook forward priority 0; policy drop;
    }

    chain OUTPUT {
        type filter hook output priority 0; policy accept;
    }
}

A translation of the extension is shown if this is available. In other
case, match or target definition is preceded by a hash. For example,
classify target has not translation:

$ sudo nft list chain mangle POSTROUTING
table ip mangle {
    chain POSTROUTING {
        type filter hook postrouting priority -150; policy accept;
        ip protocol tcp tcp dport 80 counter packets 0 bytes 0 # CLASSIFY set 20:10
                                                              ^^^
    }
}

If the whole ruleset is translatable, the users can (re)load it using
"nft -f" and get nft native support for all their rules.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---

New version of the original work made by Arturo and Pablo.

Changes in v4:
  - Remove unused code.

Changes in v5:
  - Improve commit message.

Related work:
  - Fix extra space between matches. DONE 
  - Fix escaped quotation marks issue. WIP
  - Mark rules using xt compat support. WIP

 configure.ac                               |  13 +-
 include/linux/netfilter/nf_tables_compat.h |  38 ++++
 include/statement.h                        |  34 +++
 include/xt.h                               |  39 ++++
 src/Makefile.am                            |   8 +
 src/evaluate.c                             |   1 +
 src/netlink_delinearize.c                  |   6 +
 src/statement.c                            |  25 +++
 src/xt.c                                   | 348 +++++++++++++++++++++++++++++
 9 files changed, 511 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/netfilter/nf_tables_compat.h
 create mode 100644 include/xt.h
 create mode 100644 src/xt.c

diff --git a/configure.ac b/configure.ac
index a1d7723..f281f21 100644
--- a/configure.ac
+++ b/configure.ac
@@ -98,6 +98,16 @@ AC_DEFINE([HAVE_LIBREADLINE], [1], [])
 AC_SUBST(with_cli)
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
+AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
+            [Use libxtables for iptables interaction)])],
+	    [with_libxtables=yes], [with_libxtables=no])
+AS_IF([test "x$with_libxtables" != xno], [
+PKG_CHECK_MODULES([XTABLES], [xtables >= 1.4.21])
+AC_DEFINE([HAVE_LIBXTABLES], [1], [0])
+])
+AC_SUBST(with_libxtables)
+AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_libxtables" == xyes])
+
 # Checks for header files.
 AC_HEADER_STDC
 AC_HEADER_ASSERT
@@ -147,4 +157,5 @@ nft configuration:
   cli support:			${with_cli}
   enable debugging:		${with_debug}
   use mini-gmp:			${with_mini_gmp}
-  enable pdf documentation:	${enable_pdf_doc}"
+  enable pdf documentation:	${enable_pdf_doc}
+  libxtables support:		${with_libxtables}"
diff --git a/include/linux/netfilter/nf_tables_compat.h b/include/linux/netfilter/nf_tables_compat.h
new file mode 100644
index 0000000..8310f5f
--- /dev/null
+++ b/include/linux/netfilter/nf_tables_compat.h
@@ -0,0 +1,38 @@
+#ifndef _NFT_COMPAT_NFNETLINK_H_
+#define _NFT_COMPAT_NFNETLINK_H_
+
+enum nft_target_attributes {
+	NFTA_TARGET_UNSPEC,
+	NFTA_TARGET_NAME,
+	NFTA_TARGET_REV,
+	NFTA_TARGET_INFO,
+	__NFTA_TARGET_MAX
+};
+#define NFTA_TARGET_MAX		(__NFTA_TARGET_MAX - 1)
+
+enum nft_match_attributes {
+	NFTA_MATCH_UNSPEC,
+	NFTA_MATCH_NAME,
+	NFTA_MATCH_REV,
+	NFTA_MATCH_INFO,
+	__NFTA_MATCH_MAX
+};
+#define NFTA_MATCH_MAX		(__NFTA_MATCH_MAX - 1)
+
+#define NFT_COMPAT_NAME_MAX	32
+
+enum {
+	NFNL_MSG_COMPAT_GET,
+	NFNL_MSG_COMPAT_MAX
+};
+
+enum {
+	NFTA_COMPAT_UNSPEC = 0,
+	NFTA_COMPAT_NAME,
+	NFTA_COMPAT_REV,
+	NFTA_COMPAT_TYPE,
+	__NFTA_COMPAT_MAX,
+};
+#define NFTA_COMPAT_MAX (__NFTA_COMPAT_MAX - 1)
+
+#endif
diff --git a/include/statement.h b/include/statement.h
index e9313ca..1b21551 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -148,6 +148,37 @@ struct flow_stmt {
 extern struct stmt *flow_stmt_alloc(const struct location *loc);
 
 /**
+ * enum nft_xt_type - xtables statement types
+ *
+ * @NFT_XT_MATCH:	match
+ * @NFT_XT_TARGET:	target
+ * @NFT_XT_WATCHER:	watcher (only for the bridge family)
+ */
+enum nft_xt_type {
+	NFT_XT_MATCH = 0,
+	NFT_XT_TARGET,
+	NFT_XT_WATCHER,
+	NFT_XT_MAX
+};
+
+struct xtables_match;
+struct xtables_target;
+
+struct xt_stmt {
+	const char			*name;
+	enum nft_xt_type		type;
+	uint32_t			proto;
+	union {
+		struct xtables_match	*match;
+		struct xtables_target	*target;
+	};
+	const char			*opts;
+	void				*entry;
+};
+
+extern struct stmt *xt_stmt_alloc(const struct location *loc);
+
+/**
  * enum stmt_types - statement types
  *
  * @STMT_INVALID:	uninitialised
@@ -168,6 +199,7 @@ extern struct stmt *flow_stmt_alloc(const struct location *loc);
  * @STMT_SET:		set statement
  * @STMT_DUP:		dup statement
  * @STMT_FWD:		forward statement
+ * @STMT_XT:		XT statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -188,6 +220,7 @@ enum stmt_types {
 	STMT_SET,
 	STMT_DUP,
 	STMT_FWD,
+	STMT_XT,
 };
 
 /**
@@ -243,6 +276,7 @@ struct stmt {
 		struct set_stmt		set;
 		struct dup_stmt		dup;
 		struct fwd_stmt		fwd;
+		struct xt_stmt		xt;
 	};
 };
 
diff --git a/include/xt.h b/include/xt.h
new file mode 100644
index 0000000..753511e
--- /dev/null
+++ b/include/xt.h
@@ -0,0 +1,39 @@
+#ifndef _NFT_XT_H_
+#define _NFT_XT_H_
+
+struct netlink_linearize_ctx;
+struct netlink_parse_ctx;
+struct nftnl_expr;
+struct rule_pp_ctx;
+struct rule;
+
+#ifdef HAVE_LIBXTABLES
+void xt_stmt_xlate(const struct stmt *stmt);
+void xt_stmt_release(const struct stmt *stmt);
+
+void netlink_parse_target(struct netlink_parse_ctx *ctx,
+			  const struct location *loc,
+			  const struct nftnl_expr *nle);
+void netlink_parse_match(struct netlink_parse_ctx *ctx,
+			 const struct location *loc,
+			 const struct nftnl_expr *nle);
+void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
+			 struct rule *rule);
+#else
+static inline void xt_stmt_xlate(const struct stmt *stmt) {}
+static inline void xt_stmt_release(const struct stmt *stmt) {}
+
+#include <erec.h>
+
+static inline void netlink_parse_target(struct netlink_parse_ctx *ctx,
+					const struct location *loc,
+					const struct nftnl_expr *nle) {}
+static inline void netlink_parse_match(struct netlink_parse_ctx *ctx,
+				       const struct location *loc,
+				       const struct nftnl_expr *nle) {}
+static inline void stmt_xt_postprocess(struct rule_pp_ctx *rctx,
+				       struct stmt *stmt, struct rule *rule) {}
+
+#endif
+
+#endif /* _NFT_XT_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index fd63219..8c59449 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,6 +8,9 @@ AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" \
 if BUILD_DEBUG
 AM_CPPFLAGS += -g -DDEBUG
 endif
+if BUILD_XTABLES
+AM_CPPFLAGS += ${XTABLES_CFLAGS}
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
@@ -59,3 +62,8 @@ nft_SOURCES +=	mini-gmp.c
 endif
 
 nft_LDADD	= ${LIBMNL_LIBS} ${LIBNFTNL_LIBS}
+
+if BUILD_XTABLES
+nft_SOURCES +=	xt.c
+nft_LDADD   +=  ${XTABLES_LIBS}
+endif
diff --git a/src/evaluate.c b/src/evaluate.c
index 27deb15..8116735 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -28,6 +28,7 @@
 #include <erec.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <xt.h>
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fffbe26..257473a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -26,6 +26,7 @@
 #include <erec.h>
 #include <sys/socket.h>
 #include <libnftnl/udata.h>
+#include <xt.h>
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx);
@@ -986,6 +987,8 @@ static const struct {
 	{ .name = "queue",	.parse = netlink_parse_queue },
 	{ .name = "dynset",	.parse = netlink_parse_dynset },
 	{ .name = "fwd",	.parse = netlink_parse_fwd },
+	{ .name = "target",	.parse = netlink_parse_target },
+	{ .name = "match",	.parse = netlink_parse_match },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -1798,6 +1801,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->fwd.to != NULL)
 				expr_postprocess(&rctx, &stmt->fwd.to);
 			break;
+		case STMT_XT:
+			stmt_xt_postprocess(&rctx, stmt, rule);
+			break;
 		default:
 			break;
 		}
diff --git a/src/statement.c b/src/statement.c
index 76f528b..7778a95 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -23,6 +23,7 @@
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
+#include <xt.h>
 
 #include <netinet/in.h>
 #include <linux/netfilter/nf_nat.h>
@@ -567,3 +568,27 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
+
+static void xt_stmt_print(const struct stmt *stmt)
+{
+	xt_stmt_xlate(stmt);
+}
+
+static void xt_stmt_destroy(struct stmt *stmt)
+{
+	xfree(stmt->xt.name);
+	xfree(stmt->xt.opts);
+	xt_stmt_release(stmt);
+}
+
+static const struct stmt_ops xt_stmt_ops = {
+	.type		= STMT_XT,
+	.name		= "xt",
+	.print		= xt_stmt_print,
+	.destroy	= xt_stmt_destroy,
+};
+
+struct stmt *xt_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &xt_stmt_ops);
+}
diff --git a/src/xt.c b/src/xt.c
new file mode 100644
index 0000000..afcc836
--- /dev/null
+++ b/src/xt.c
@@ -0,0 +1,348 @@
+/*
+ * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2015 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modifyi
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <xtables.h>
+#include <getopt.h>
+#include <ctype.h>	/* for isspace */
+#include <statement.h>
+#include <netlink.h>
+#include <xt.h>
+#include <erec.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables_compat.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_arp/arp_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+
+void xt_stmt_xlate(const struct stmt *stmt)
+{
+	struct xt_xlate *xl = xt_xlate_alloc(10240);
+
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (stmt->xt.match == NULL && stmt->xt.opts) {
+			printf("%s", stmt->xt.opts);
+		} else if (stmt->xt.match->xlate) {
+			stmt->xt.match->xlate(stmt->xt.entry,
+					      stmt->xt.match->m, xl, 0);
+				printf("%s", xt_xlate_get(xl));
+		} else if (stmt->xt.match->print) {
+			printf("#");
+			stmt->xt.match->print(&stmt->xt.entry,
+					      stmt->xt.match->m, 0);
+		}
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		if (stmt->xt.target == NULL && stmt->xt.opts) {
+			printf("%s", stmt->xt.opts);
+		} else if (stmt->xt.target->xlate) {
+			stmt->xt.target->xlate(stmt->xt.entry,
+					       stmt->xt.target->t, xl, 0);
+			printf("%s", xt_xlate_get(xl));
+		} else if (stmt->xt.target->print) {
+			printf("#");
+			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
+		}
+		break;
+	default:
+		break;
+	}
+
+	xt_xlate_free(xl);
+}
+
+void xt_stmt_release(const struct stmt *stmt)
+{
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (!stmt->xt.match)
+			break;
+		if (stmt->xt.match->m)
+			xfree(stmt->xt.match->m);
+		xfree(stmt->xt.match);
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		if (!stmt->xt.target)
+			break;
+		if (stmt->xt.target->t)
+			xfree(stmt->xt.target->t);
+		xfree(stmt->xt.target);
+		break;
+	default:
+		break;
+	}
+	xfree(stmt->xt.entry);
+}
+
+static void *xt_entry_alloc(struct xt_stmt *xt, uint32_t af)
+{
+	union nft_entry {
+		struct ipt_entry ipt;
+		struct ip6t_entry ip6t;
+		struct arpt_entry arpt;
+		struct ebt_entry ebt;
+	} *entry;
+
+	entry = xmalloc(sizeof(union nft_entry));
+
+	switch (af) {
+	case NFPROTO_IPV4:
+		entry->ipt.ip.proto = xt->proto;
+		break;
+	case NFPROTO_IPV6:
+		entry->ip6t.ipv6.proto = xt->proto;
+		break;
+	case NFPROTO_BRIDGE:
+		entry->ebt.ethproto = xt->proto;
+		break;
+	case NFPROTO_ARP:
+		entry->arpt.arp.arhln_mask = 0xff;
+		entry->arpt.arp.arhln = 6;
+		break;
+	default:
+		break;
+	}
+
+	return entry;
+}
+
+static uint32_t xt_proto(const struct proto_ctx *pctx)
+{
+	const struct proto_desc *desc = NULL;
+
+	if (pctx->family == NFPROTO_BRIDGE) {
+		desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc == NULL)
+			return 0;
+		if (strcmp(desc->name, "ip") == 0)
+			return __constant_htons(ETH_P_IP);
+		if (strcmp(desc->name, "ip6") == 0)
+			return __constant_htons(ETH_P_IPV6);
+		return 0;
+	}
+
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	if (desc == NULL)
+		return 0;
+	if (strcmp(desc->name, "tcp") == 0)
+		return IPPROTO_TCP;
+	else if (strcmp(desc->name, "udp") == 0)
+		return IPPROTO_UDP;
+	else if (strcmp(desc->name, "udplite") == 0)
+		return IPPROTO_UDPLITE;
+	else if (strcmp(desc->name, "sctp") == 0)
+		return IPPROTO_SCTP;
+	else if (strcmp(desc->name, "dccp") == 0)
+		return IPPROTO_DCCP;
+	else if (strcmp(desc->name, "esp") == 0)
+		return IPPROTO_ESP;
+	else if (strcmp(desc->name, "ah") == 0)
+		return IPPROTO_AH;
+
+	return 0;
+}
+
+static struct xtables_target *xt_target_clone(struct xtables_target *t)
+{
+	struct xtables_target *clone;
+
+	clone = xzalloc(sizeof(struct xtables_target));
+	memcpy(clone, t, sizeof(struct xtables_target));
+	return clone;
+}
+
+static struct xtables_match *xt_match_clone(struct xtables_match *m)
+{
+	struct xtables_match *clone;
+
+	clone = xzalloc(sizeof(struct xtables_match));
+	memcpy(clone, m, sizeof(struct xtables_match));
+	return clone;
+}
+
+/*
+ * Delinearization
+ */
+
+void netlink_parse_match(struct netlink_parse_ctx *ctx,
+			 const struct location *loc,
+			 const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+	const char *name;
+	struct xtables_match *mt;
+	const char *mtinfo;
+	struct xt_entry_match *m;
+	uint32_t mt_len;
+
+	xtables_set_nfproto(ctx->table->handle.family);
+
+	name = nftnl_expr_get_str(nle, NFT_EXPR_MT_NAME);
+
+	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
+	if (!mt)
+		BUG("XT match %s not found\n", name);
+
+	mtinfo = nftnl_expr_get(nle, NFT_EXPR_MT_INFO, &mt_len);
+
+	m = xzalloc(sizeof(struct xt_entry_match) + mt_len);
+	memcpy(&m->data, mtinfo, mt_len);
+
+	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
+	m->u.user.revision = nftnl_expr_get_u32(nle, NFT_EXPR_MT_REV);
+
+	stmt = xt_stmt_alloc(loc);
+	stmt->xt.name = strdup(name);
+	stmt->xt.type = NFT_XT_MATCH;
+	stmt->xt.match = xt_match_clone(mt);
+	stmt->xt.match->m = m;
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+void netlink_parse_target(struct netlink_parse_ctx *ctx,
+			  const struct location *loc,
+			  const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+	const char *name;
+	struct xtables_target *tg;
+	const void *tginfo;
+	struct xt_entry_target *t;
+	size_t size;
+	uint32_t tg_len;
+
+	xtables_set_nfproto(ctx->table->handle.family);
+
+	name = nftnl_expr_get_str(nle, NFT_EXPR_TG_NAME);
+	tg = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!tg)
+		BUG("XT target %s not found\n", name);
+
+	tginfo = nftnl_expr_get(nle, NFT_EXPR_TG_INFO, &tg_len);
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
+	t = xzalloc(size);
+	memcpy(&t->data, tginfo, tg_len);
+	t->u.target_size = size;
+	t->u.user.revision = nftnl_expr_get_u32(nle, NFT_EXPR_TG_REV);
+	strcpy(t->u.user.name, tg->name);
+
+	stmt = xt_stmt_alloc(loc);
+	stmt->xt.name = strdup(name);
+	stmt->xt.type = NFT_XT_TARGET;
+	stmt->xt.target = xt_target_clone(tg);
+	stmt->xt.target->t = t;
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+static bool is_watcher(uint32_t family, struct stmt *stmt)
+{
+	if (family != NFPROTO_BRIDGE ||
+	    stmt->xt.type != NFT_XT_TARGET)
+		return false;
+
+	/* this has to be hardcoded :-( */
+	if (strcmp(stmt->xt.name, "log") == 0)
+		return true;
+	else if (strcmp(stmt->xt.name, "nflog") == 0)
+		return true;
+
+	return false;
+}
+
+void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
+			 struct rule *rule)
+{
+	if (is_watcher(rctx->pctx.family, stmt))
+		stmt->xt.type = NFT_XT_WATCHER;
+
+	stmt->xt.proto = xt_proto(&rctx->pctx);
+	stmt->xt.entry = xt_entry_alloc(&stmt->xt, rctx->pctx.family);
+}
+
+static int nft_xt_compatible_revision(const char *name, uint8_t rev, int opt)
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, type;
+	struct nfgenmsg *nfg;
+	int ret = 0;
+
+	if (opt == IPT_SO_GET_REVISION_MATCH)
+		type = 0;
+	else
+		type = 1;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFT_COMPAT << 8) | NFNL_MSG_COMPAT_GET;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_INET;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = 0;
+
+	mnl_attr_put_strz(nlh, NFTA_COMPAT_NAME, name);
+	mnl_attr_put_u32(nlh, NFTA_COMPAT_REV, htonl(rev));
+	mnl_attr_put_u32(nlh, NFTA_COMPAT_TYPE, htonl(type));
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL)
+		return 0;
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		goto err;
+
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		goto err;
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	if (ret == -1)
+		goto err;
+
+	ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+	if (ret == -1)
+		goto err;
+
+err:
+	mnl_socket_close(nl);
+
+	return ret < 0 ? 0 : 1;
+}
+
+static struct option original_opts[] = {
+	{ NULL },
+};
+
+static struct xtables_globals xt_nft_globals = {
+	.program_name		= "nft",
+	.program_version	= PACKAGE_VERSION,
+	.orig_opts		= original_opts,
+	.compat_rev		= nft_xt_compatible_revision,
+};
+
+static void __init xt_init(void)
+{
+	/* Default to IPv4, but this changes in runtime */
+	xtables_init_all(&xt_nft_globals, NFPROTO_IPV4);
+}
-- 
2.9.0

