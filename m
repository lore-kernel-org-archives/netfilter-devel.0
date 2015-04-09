From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v2 3/3] src: add xt compat support
Date: Thu,  9 Apr 2015 18:55:14 +0200
Message-ID: <1428598514-1915-3-git-send-email-pablo@netfilter.org>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbbDIQvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 12:51:11 -0400
In-Reply-To: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

At compilation time, you have to pass this option.

  # ./configure --with-xtables

And libxtables needs to be installed in your system.

This patch allows you to use xt extensions from nft, eg.

  # nft add rule filter output \
        tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]

This feature requires that libxtables is installed in your system.

This provides access to all existing xt modules from nft. Users can
meanwhile use xt extension until we can provide native expressions.

You can build this optionally, if disabled it displays an error:

  # nft add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
  <cmdline>:1:38-77: Error: this build does not support xtables
  add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

so you know your build doesn't support this.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: revisit #include headers dependencies and don't define dummy union
    nft_entry from headers.

 configure.ac                               |   13 +-
 include/linux/netfilter/nf_tables_compat.h |   38 ++
 include/statement.h                        |   34 ++
 include/xt.h                               |   57 +++
 src/Makefile.am                            |    8 +
 src/evaluate.c                             |    3 +
 src/main.c                                 |   12 +-
 src/netlink_delinearize.c                  |    6 +
 src/netlink_linearize.c                    |    3 +
 src/parser_bison.y                         |   57 +++
 src/scanner.l                              |   15 +
 src/statement.c                            |   41 ++
 src/xt.c                                   |  682 ++++++++++++++++++++++++++++
 13 files changed, 966 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/netfilter/nf_tables_compat.h
 create mode 100644 include/xt.h
 create mode 100644 src/xt.c

diff --git a/configure.ac b/configure.ac
index 1c46b76..04c9748 100644
--- a/configure.ac
+++ b/configure.ac
@@ -92,6 +92,16 @@ AC_DEFINE([HAVE_LIBREADLINE], [1], [])
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
@@ -140,4 +150,5 @@ echo "
 nft configuration:
   cli support:			${with_cli}
   enable debugging:		${with_debug}
-  use mini-gmp:			${with_mini_gmp}"
+  use mini-gmp:			${with_mini_gmp}
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
index d143121..3b63e3a 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -105,6 +105,37 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
 				  struct expr *expr);
 
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
@@ -120,6 +151,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
  * @STMT_REDIR:		redirect statement
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
+ * @STMT_XT:		XT statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -135,6 +167,7 @@ enum stmt_types {
 	STMT_REDIR,
 	STMT_QUEUE,
 	STMT_CT,
+	STMT_XT,
 };
 
 /**
@@ -184,6 +217,7 @@ struct stmt {
 		struct redir_stmt	redir;
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
+		struct xt_stmt		xt;
 	};
 };
 
diff --git a/include/xt.h b/include/xt.h
new file mode 100644
index 0000000..5feed75
--- /dev/null
+++ b/include/xt.h
@@ -0,0 +1,57 @@
+#ifndef _NFT_XT_H_
+#define _NFT_XT_H_
+
+struct netlink_linearize_ctx;
+struct netlink_parse_ctx;
+struct nft_rule_expr;
+struct rule_pp_ctx;
+struct rule;
+
+#ifdef HAVE_LIBXTABLES
+const char *xt_stmt_name(const struct stmt *stmt);
+void xt_stmt_save(const struct stmt *stmt);
+void xt_stmt_release(const struct stmt *stmt);
+
+int stmt_evaluate_xt(struct eval_ctx *ctx, struct stmt *stmt);
+
+void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+			 const struct stmt *stmt);
+
+void netlink_parse_target(struct netlink_parse_ctx *ctx,
+			  const struct location *loc,
+			  const struct nft_rule_expr *nle);
+void netlink_parse_match(struct netlink_parse_ctx *ctx,
+			 const struct location *loc,
+			 const struct nft_rule_expr *nle);
+void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
+			 struct rule *rule);
+#else
+static inline const char *xt_stmt_name(const struct stmt *stmt)
+{
+	return "unknown";
+}
+static inline void xt_stmt_save(const struct stmt *stmt) {}
+static inline void xt_stmt_release(const struct stmt *stmt) {}
+
+#include <erec.h>
+
+static inline int stmt_evaluate_xt(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	return stmt_error(ctx, stmt, "this build does not support xtables");
+}
+
+static inline void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+				       const struct stmt *stmt) {}
+
+static inline void netlink_parse_target(struct netlink_parse_ctx *ctx,
+                                 const struct location *loc,
+                                 const struct nft_rule_expr *nle) {}
+static inline void netlink_parse_match(struct netlink_parse_ctx *ctx,
+                                 const struct location *loc,
+                                 const struct nft_rule_expr *nle) {}
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
index b216fb1..f5154e6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -27,6 +27,7 @@
 #include <erec.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <xt.h>
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
@@ -1658,6 +1659,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
+	case STMT_XT:
+		return stmt_evaluate_xt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/main.c b/src/main.c
index 384fb34..8825949 100644
--- a/src/main.c
+++ b/src/main.c
@@ -260,10 +260,18 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	int i, val, rc = NFT_EXIT_SUCCESS;
+	int i, val, rc = NFT_EXIT_SUCCESS, fake_argc = argc;
+
+	/* This avoids a clash with libxtables getopt_long parser */
+	for (i = 0; i < argc; i++) {
+		if (argv[i][0] == '[') {
+			fake_argc = i;
+			break;
+		}
+	}
 
 	while (1) {
-		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
+		val = getopt_long(fake_argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
 			break;
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e0bb726..6794a2d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -25,6 +25,7 @@
 #include <utils.h>
 #include <erec.h>
 #include <sys/socket.h>
+#include <xt.h>
 
 static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 					    const struct location *loc,
@@ -710,6 +711,8 @@ static const struct {
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "queue",	.parse = netlink_parse_queue },
+	{ .name = "target",	.parse = netlink_parse_target },
+	{ .name = "match",	.parse = netlink_parse_match },
 };
 
 static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
@@ -1124,6 +1127,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_REJECT:
 			stmt_reject_postprocess(rctx, stmt);
 			break;
+		case STMT_XT:
+			stmt_xt_postprocess(&rctx, stmt, rule);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 6a637a4..0c84d54 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -18,6 +18,7 @@
 #include <netlink.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <xt.h>
 
 static void netlink_put_register(struct nft_rule_expr *nle,
 				 uint32_t attr, uint32_t reg)
@@ -821,6 +822,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
 		return netlink_gen_ct_stmt(ctx, stmt);
+	case STMT_XT:
+		return netlink_gen_xt_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b86381d..6311832 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -382,6 +382,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FULLY_RANDOM		"fully-random"
 %token PERSISTENT		"persistent"
 
+%token XT			"xt"
+%token MATCH			"match"
+%token TARGET			"target"
+%token WATCHER			"watcher"
+%token <string> XTOPTS		"xtoptions"
+%destructor { xfree($$); }	XTOPTS
+
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
 %token BYPASS			"bypass"
@@ -449,6 +456,12 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %type <val>			nf_nat_flags nf_nat_flag
+
+%type <stmt>			xt_stmt
+%destructor { stmt_free($$); }	xt_stmt
+%type <string>			xt_name xt_opts
+%destructor { xfree($$); }	xt_name xt_opts
+
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -1236,6 +1249,7 @@ stmt			:	verdict_stmt
 			|	ct_stmt
 			|	masq_stmt
 			|	redir_stmt
+			|	xt_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1499,6 +1513,49 @@ redir_stmt_arg		:	TO	expr
 			}
 			;
 
+xt_stmt			:       XT	MATCH	xt_name xt_opts
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.name = $3;
+				$$->xt.type = NFT_XT_MATCH;
+				$$->xt.opts = $4;
+			}
+			|	XT	TARGET	xt_name	xt_opts
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.name = $3;
+				$$->xt.type = NFT_XT_TARGET;
+				$$->xt.opts = $4;
+			}
+			|	XT	WATCHER	xt_name	xt_opts
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.name = $3;
+				$$->xt.type = NFT_XT_WATCHER;
+				$$->xt.opts = $4;
+			}
+			;
+
+xt_opts			:	/* empty */	{ $$ = NULL; }
+			|	XTOPTS		{ $$ = $1; }
+			;
+
+xt_name			:	STRING		{ $$ = $1; }
+			|	STATE		{ $$ = xstrdup("state"); }
+			|	COMMENT		{ $$ = xstrdup("comment"); }
+			|	AH		{ $$ = xstrdup("ah"); }
+			|	ESP		{ $$ = xstrdup("esp"); }
+			|	TCP		{ $$ = xstrdup("tcp"); }
+			|	UDP		{ $$ = xstrdup("udp"); }
+			|	UDPLITE		{ $$ = xstrdup("udplite"); }
+			|	SCTP		{ $$ = xstrdup("sctp"); }
+			|	ICMP		{ $$ = xstrdup("icmp"); }
+			|	IP		{ $$ = xstrdup("ip"); }
+			|	VLAN		{ $$ = xstrdup("vlan"); }
+			|	LOG		{ $$ = xstrdup("log"); }
+			|	MARK		{ $$ = xstrdup("mark"); }
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..f89d27f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -113,6 +113,7 @@ hexstring	0[xX]{hexdigit}+
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
+xtopts		\[({letter}|{digit}|[!/\-_\.\"\:\, ])*\]
 quotedstring	\"[^"]*\"
 comment		#.*$
 slash		\/
@@ -449,6 +450,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-dst"		{ return PROTO_DST; }
 "label"			{ return LABEL; }
 
+"xt"			{ return XT; }
+"match"			{ return MATCH; }
+"target"		{ return TARGET; }
+"watcher"		{ return WATCHER; }
+"802_3"			{
+				yylval->string = xstrdup("802_3");
+				return STRING;
+			}
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
@@ -488,6 +498,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{xtopts}		{
+				yylval->string = xstrdup(yytext);
+				return XTOPTS;
+			}
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
diff --git a/src/statement.c b/src/statement.c
index d72c6e9..cec7039 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -23,6 +23,7 @@
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
+#include <xt.h>
 
 #include <netinet/in.h>
 #include <linux/netfilter/nf_nat.h>
@@ -377,3 +378,43 @@ struct stmt *redir_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &redir_stmt_ops);
 }
+
+static const char *xt_type_name[NFT_XT_MAX] = {
+	[NFT_XT_MATCH]	= "match",
+	[NFT_XT_TARGET]	= "target",
+	[NFT_XT_WATCHER]= "watcher",
+};
+
+static const char *xt_stmt_to_type(enum nft_xt_type type)
+{
+	if (type > NFT_XT_MAX)
+		return "unknown";
+
+	return xt_type_name[type];
+}
+
+static void xt_stmt_print(const struct stmt *stmt)
+{
+	printf("xt %s %s ", xt_stmt_to_type(stmt->xt.type),
+			    xt_stmt_name(stmt));
+	xt_stmt_save(stmt);
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
index 0000000..a6c7977
--- /dev/null
+++ b/src/xt.c
@@ -0,0 +1,682 @@
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
+#include <utils.h>
+#include <getopt.h>
+#include <ctype.h>	/* for isspace */
+#include <statement.h>
+#include <rule.h>
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
+#include <libnftnl/rule.h>
+#include <libnftnl/expr.h>
+
+const char *xt_stmt_name(const struct stmt *stmt)
+{
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (stmt->xt.match == NULL)
+			break;
+		if (stmt->xt.match->alias)
+			return stmt->xt.match->alias(stmt->xt.match->m);
+		break;
+	case NFT_XT_TARGET:
+	case NFT_XT_WATCHER:
+		if (stmt->xt.target == NULL)
+			break;
+		if (stmt->xt.target->alias)
+			return stmt->xt.target->alias(stmt->xt.target->t);
+		break;
+	default:
+		return "unknown";
+	}
+
+	return stmt->xt.name;
+}
+
+void xt_stmt_save(const struct stmt *stmt)
+{
+	printf("[");
+
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (stmt->xt.match == NULL && stmt->xt.opts)
+			fprintf(stdout, "%s", stmt->xt.opts);
+		else if (stmt->xt.match->save)
+			stmt->xt.match->save(&stmt->xt.entry,
+					     stmt->xt.match->m);
+		else if (stmt->xt.match->print)
+			stmt->xt.match->print(&stmt->xt.entry,
+					      stmt->xt.match->m, 0);
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		if (stmt->xt.target == NULL && stmt->xt.opts)
+			fprintf(stdout, "%s", stmt->xt.opts);
+		else if (stmt->xt.target->save)
+			stmt->xt.target->save(NULL, stmt->xt.target->t);
+		else if (stmt->xt.target->print)
+			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
+		break;
+	default:
+		break;
+	}
+
+	printf(" ]");
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
+static void *xt_data_alloc(struct xt_stmt *xt)
+{
+
+	uint32_t size = 0;
+
+	switch (xt->type) {
+	case NFT_XT_MATCH:
+		size = XT_ALIGN(sizeof(struct xt_entry_match)) +
+		       xt->match->size;
+		break;
+	case NFT_XT_WATCHER:
+	case NFT_XT_TARGET:
+		size = XT_ALIGN(sizeof(struct xt_entry_target)) +
+		       xt->target->size;
+		break;
+	default:
+		break;
+	}
+
+	return xzalloc(size);
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
+ * Evaluation
+ */
+
+static struct option original_opts[] = {
+	{ NULL },
+};
+
+static int xt_target_to_binary(struct xt_stmt *xt, int argc, char *argv[],
+			       uint32_t af)
+{
+	struct option *opt;
+	unsigned int offset;
+	int c;
+
+	xt->target->t = xt_data_alloc(xt);
+	xt->entry = xt_entry_alloc(xt, af);
+
+	if (xt->target->x6_options != NULL)
+		opt = xtables_options_xfrm(original_opts, NULL,
+					   xt->target->x6_options,
+					   &offset);
+	else
+		opt = xtables_merge_options(original_opts, NULL,
+					    xt->target->extra_opts,
+					    &offset);
+
+	if (xt->target->init != NULL)
+		xt->target->init(xt->target->t);
+
+	/* Reset internal state of getopt_long. */
+	optind = 0;
+	/* Suppress error messages. */
+	opterr = 0;
+
+	while ((c = getopt_long(argc, argv, "-:", opt, NULL)) != -1) {
+
+		c -= offset;
+		xtables_option_tpcall(xt->target->option_offset + c,
+				      argv, 0, xt->target, xt->entry);
+	}
+
+	/* Reset parsing flags */
+	xt->target->tflags = 0;
+	xfree(opt);
+
+	return 0;
+}
+
+static int xt_match_to_binary(struct xt_stmt *xt, int argc, char *argv[],
+			      uint32_t af)
+{
+	struct option *opt;
+	unsigned int offset;
+	bool invert = false;
+	int c;
+
+	xt->match->m = xt_data_alloc(xt);
+	xt->entry = xt_entry_alloc(xt, af);
+
+	if (xt->match->x6_options != NULL)
+		opt = xtables_options_xfrm(original_opts, NULL,
+					   xt->match->x6_options,
+					   &offset);
+	else
+		opt = xtables_merge_options(original_opts, NULL,
+					    xt->match->extra_opts,
+					    &offset);
+
+	if (xt->match->init != NULL)
+		xt->match->init(xt->match->m);
+
+	/* Reset internal state of getopt_long. */
+	optind = 0;
+	/* Suppress error messages. */
+	opterr = 0;
+
+	while ((c = getopt_long(argc, argv, "-:", opt, NULL)) != -1) {
+		switch (c) {
+		case 1:
+			invert = true;
+			continue;
+		default:
+			break;
+		}
+
+		if (optarg != NULL && optarg[0] == '!' && optarg[1] == '\0') {
+			invert = true;
+			optarg = argv[optind];
+		}
+
+		c -= offset;
+		xtables_option_mpcall(xt->match->option_offset + c,
+				      argv, invert, xt->match,
+				      xt->entry);
+		if (invert)
+			invert = false;
+	}
+
+	/* Reset parsing flags */
+	xt->match->mflags = 0;
+	xfree(opt);
+
+	return 0;
+}
+
+/* An xt extension doesn't have more than arguments. */
+#define MAX_ARG			64
+
+static int string_to_argv(const char *str, char *argv[], uint32_t argc_max)
+{
+	uint32_t i, k = 1, len = 0;
+	bool atquote = false, dupquote = false;
+
+	if (str == NULL)
+		return 0;
+
+	/* skip first/last char, are '[' and ']' */
+	for (i = 1; i < strlen(str) - 1; i++) {
+		if (k == argc_max)
+			goto err;
+
+		if (str[i] == '"') {
+			if (!atquote)
+				dupquote = true;
+			atquote = !atquote;
+		}
+
+		if (isspace(str[i]) && !atquote) {
+			if (len <= 0)
+				continue;
+
+			if (dupquote) {
+				argv[k] = strndup(&str[i - len + 1], len - 2);
+				dupquote = false;
+			} else {
+				argv[k] = strndup(&str[i - len], len);
+			}
+
+			k++;
+			len = 0;
+		} else {
+			len++;
+		}
+	}
+	return k;
+err:
+	for (i = 0; i < k; i++)
+		free(argv[i]);
+	return -1;
+}
+
+int stmt_evaluate_xt(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	char *argv[MAX_ARG] = { "iptables" };
+	struct xtables_match *mt;
+	struct xtables_target *tg;
+	int argc, i, err;
+
+	argc = string_to_argv(stmt->xt.opts, argv, MAX_ARG);
+	if (argc < 0)
+		return stmt_error(ctx, stmt, "too many xt options");
+
+	xtables_set_nfproto(ctx->pctx.family);
+	stmt->xt.proto = xt_proto(&ctx->pctx);
+
+	if (stmt->xt.type == NFT_XT_WATCHER &&
+	    ctx->pctx.family != NFPROTO_BRIDGE)
+		return stmt_error(ctx, stmt,
+				  "watcher only available in bridge family");
+
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
+		if (!mt)
+			return stmt_error(ctx, stmt, "unknown match %s",
+					  stmt->xt.name);
+
+		stmt->xt.match = xt_match_clone(mt);
+		err = xt_match_to_binary(&stmt->xt, argc, argv,
+					 ctx->pctx.family);
+		break;
+	case NFT_XT_TARGET:
+	case NFT_XT_WATCHER:
+		tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
+		if (!tg)
+			return stmt_error(ctx, stmt, "unknown target %s",
+					  stmt->xt.name);
+
+		stmt->xt.target = xt_target_clone(tg);
+		err = xt_target_to_binary(&stmt->xt, argc, argv,
+					  ctx->pctx.family);
+		break;
+	default:
+		BUG("Unknown xt type %d\n", stmt->xt.type);
+	}
+
+	if (stmt->xt.type == NFT_XT_TARGET)
+		stmt->flags |= STMT_F_TERMINAL;
+
+	for (i = 1; i < argc; i++)
+		xfree(argv[i]);
+
+	if (err < 0)
+		return stmt_error(ctx, stmt, "failed to parse");
+
+	return 0;
+}
+
+/*
+ * Delinearization
+ */
+
+void netlink_parse_match(struct netlink_parse_ctx *ctx,
+			 const struct location *loc,
+			 const struct nft_rule_expr *nle)
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
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_MT_NAME);
+
+	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
+	if (!mt)
+		BUG("XT match %s not found\n", name);
+
+	mtinfo = nft_rule_expr_get(nle, NFT_EXPR_MT_INFO, &mt_len);
+
+	m = xzalloc(sizeof(struct xt_entry_match) + mt_len);
+	memcpy(&m->data, mtinfo, mt_len);
+
+	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
+	m->u.user.revision = nft_rule_expr_get_u32(nle, NFT_EXPR_MT_REV);
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
+			  const struct nft_rule_expr *nle)
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
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_TG_NAME);
+	tg = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!tg)
+		BUG("XT target %s not found\n", name);
+
+	tginfo = nft_rule_expr_get(nle, NFT_EXPR_TG_INFO, &tg_len);
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
+	t = xzalloc(size);
+	memcpy(&t->data, tginfo, tg_len);
+	t->u.target_size = size;
+	t->u.user.revision = nft_rule_expr_get_u32(nle, NFT_EXPR_TG_REV);
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
+/*
+ * Linearization
+ */
+
+static const char *xt_stmt_real_name(const struct stmt *stmt)
+{
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		if (stmt->xt.match->real_name)
+			return stmt->xt.match->real_name;
+		break;
+	case NFT_XT_TARGET:
+	case NFT_XT_WATCHER:
+		if (stmt->xt.target->real_name)
+			return stmt->xt.target->real_name;
+		break;
+	default:
+		return "unknown";
+	}
+
+	return stmt->xt.name;
+}
+
+static void *xt_match_info(const void *entry)
+{
+	return (char *)entry + XT_ALIGN(sizeof(struct xt_entry_match));
+}
+
+static void *xt_target_info(const void *entry)
+{
+	return (char *)entry + XT_ALIGN(sizeof(struct xt_entry_target));
+}
+
+void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+			 const struct stmt *stmt)
+{
+	struct nft_rule_expr *nle;
+	void *info;
+
+	switch (stmt->xt.type) {
+	case NFT_XT_MATCH:
+		info = xzalloc(stmt->xt.match->size);
+		memcpy(info, xt_match_info(stmt->xt.match->m),
+		       stmt->xt.match->size);
+
+		nle = nft_rule_expr_alloc("match");
+		if (nle == NULL)
+			memory_allocation_error();
+
+		nft_rule_expr_set_str(nle, NFT_EXPR_MT_NAME,
+				      xt_stmt_real_name(stmt));
+		nft_rule_expr_set_u32(nle, NFT_EXPR_MT_REV,
+				      stmt->xt.match->revision);
+		nft_rule_expr_set(nle, NFT_EXPR_MT_INFO, info,
+				  stmt->xt.match->userspacesize);
+		nft_rule_add_expr(ctx->nlr, nle);
+		break;
+	case NFT_XT_TARGET:
+	case NFT_XT_WATCHER:
+		info = xzalloc(stmt->xt.target->size);
+		memcpy(info, xt_target_info(stmt->xt.target->t),
+		       stmt->xt.target->size);
+
+		nle = nft_rule_expr_alloc("target");
+		if (nle == NULL)
+			memory_allocation_error();
+
+		nft_rule_expr_set_str(nle, NFT_EXPR_TG_NAME,
+				      xt_stmt_real_name(stmt));
+		nft_rule_expr_set_u32(nle, NFT_EXPR_TG_REV,
+				      stmt->xt.target->revision);
+		nft_rule_expr_set(nle, NFT_EXPR_TG_INFO, info,
+				  stmt->xt.target->userspacesize);
+		nft_rule_add_expr(ctx->nlr, nle);
+		break;
+	default:
+		BUG("Unknown xt type %d\n", stmt->xt.type);
+	}
+
+	if (stmt->xt.proto) {
+		nft_rule_attr_set_u32(ctx->nlr, NFT_RULE_ATTR_COMPAT_PROTO,
+				      stmt->xt.proto);
+		nft_rule_attr_set_u32(ctx->nlr, NFT_RULE_ATTR_COMPAT_FLAGS, 0);
+	}
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
1.7.10.4

