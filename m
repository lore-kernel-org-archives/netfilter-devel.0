From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nft compat layer
Date: Mon, 18 Jan 2016 09:59:20 +0100
Message-ID: <569CA968.9010702@tpip.net>
References: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010806090308020803010608"
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:56184 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbcARJF2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2016 04:05:28 -0500
In-Reply-To: <CAOkSjBhpqYQ01xOehhG7zFAzStOcTttQTk1JcLaP_UnAWSzmPw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010806090308020803010608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arturo,

On 01/15/2016 09:06 PM, Arturo Borrero Gonzalez wrote:
> Hi,
>
> I'm giving a spin to the nft compat layer, since it can be of certain
> importance for distributions.
>
> I just want to be clear on what I recommends to end users about
> migrating from iptables (and friends) to nftables.
>
> Could you please remind me in which state was the discussion about
> that patch to show x_tables extensions in nftables rulesets [0]?
> I remember Patrick mentioned several concerns back then about this approach.

I have an updated version of this patch and also fixed some of
the problems I encountered along the way (see attached patches).
The nft patch is based on nftables-0.5 and the kernel change
should apply cleanly to linux-4.4.

With the update patch I can load a fairly complex iptables
firewall with iptables-compat, dump it with nft and reload
the dump with nft.

The resulting ruleset appears to be working. YMMV.

Regards
Andreas

> Currently, with a basic ruleset errors are shown [1]. Also, if you try
> to see what's happening, segfaults [2].
>
> I'm aware of the translations efforts being made by Shivani.
>
> [0] http://patchwork.ozlabs.org/patch/459398/
> [1] http://paste.debian.net/366059
> [2] http://paste.debian.net/366060/
>
> best regards.
>

--------------010806090308020803010608
Content-Type: text/x-patch;
 name="0001-nft-src-add-xt-compat-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-nft-src-add-xt-compat-support.patch"

>From 9a9d3fe52056d1e6395396e2ef185ea67c0c34b2 Mon Sep 17 00:00:00 2001
From: Andreas Schultz <aschultz@tpip.net>
Date: Mon, 1 Jun 2015 10:21:23 +0200
Subject: [PATCH] [nft] src: add xt compat support

With this patch, you can use iptables (over nftables compat
layer) and nft at the same time.

% libnftables/examples/./nft-rule-add ip test test

The output looks like:

% nft list table test > ruleset
% cat ruleset
table test {
        chain test {
                 xt iprange [ --src-range 127.0.0.1-127.0.0.4 ] xt LOG [ --log-level 5 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid ]
        }
}

You can also reload the rule-set that uses xt extension via:

nft -f ruleset

This adds a new dependency with libxtables. You have to be careful
to make sure nft uses the libxtables 7 (the one used by
iptables-nftables), otherwise you'll hit problems. This should be
resolved by:

1) forward porting iptables-nftables to current head (libxtables 10).
2) freezing binary interface of libxtables to ensure stability.

Benefits:

1) Automatic iptables to nft rule-set translation: We are planning
   to provide native translations of xt modules to nftables. That
   should really help to users to migrate from iptables to the new
   utility.

2) Access to all existing xt modules from nft. As we still lack of
   native replacements for several xt modules, users can use xt
   modules.

Limitations:

1) Works via -f and -i, but not from command line yet, as getopt_long
   in nft considers that xt extension parameters are not known.

2) No xt->parse support yet, this uses xt->x6_parse.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac                               |   3 +
 include/linux/netfilter/nf_tables_compat.h |  20 ++
 include/statement.h                        |  14 ++
 include/xt.h                               |  23 +++
 src/Makefile.am                            |   1 +
 src/evaluate.c                             |   1 +
 src/netlink_delinearize.c                  |  74 +++++++-
 src/netlink_linearize.c                    |  77 ++++++++
 src/parser_bison.y                         |  24 +++
 src/scanner.l                              |   2 +
 src/statement.c                            |  35 ++++
 src/xt.c                                   | 286 +++++++++++++++++++++++++++++
 12 files changed, 559 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/netfilter/nf_tables_compat.h
 create mode 100644 include/xt.h
 create mode 100644 src/xt.c

diff --git a/configure.ac b/configure.ac
index d8f949a..e7c5971 100644
--- a/configure.ac
+++ b/configure.ac
@@ -73,6 +73,9 @@ AM_CONDITIONAL([BUILD_PDF], [test "$DBLATEX" == "found"])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.2])
 
+AC_CHECK_LIB([xtables], [xtables_find_target], ,
+	     AC_MSG_ERROR([No suitable version of libxtables found]))
+
 AC_ARG_WITH([mini-gmp], [AS_HELP_STRING([--with-mini-gmp],
             [Use builtin mini-gmp (for embedded builds)])], [],
             [with_mini_gmp=no])
diff --git a/include/linux/netfilter/nf_tables_compat.h b/include/linux/netfilter/nf_tables_compat.h
new file mode 100644
index 0000000..36fb81d
--- /dev/null
+++ b/include/linux/netfilter/nf_tables_compat.h
@@ -0,0 +1,20 @@
+#ifndef _NFT_COMPAT_NFNETLINK_H_
+#define _NFT_COMPAT_NFNETLINK_H_
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
index 48e6130..30b63c6 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -3,6 +3,7 @@
 
 #include <list.h>
 #include <expression.h>
+#include <xt.h>
 
 extern struct stmt *expr_stmt_alloc(const struct location *loc,
 				    struct expr *expr);
@@ -112,6 +113,16 @@ struct set_stmt {
 
 extern struct stmt *set_stmt_alloc(const struct location *loc);
 
+struct xt_stmt {
+	const char		*name;
+	struct xtables_target	*target;
+	struct xtables_match	*match;
+	void			*entry;
+	struct expr		*list;
+};
+
+extern struct stmt *xt_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
@@ -129,6 +140,7 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
  * @STMT_SET:		set statement
+ * @STMT_XT:		XT statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -145,6 +157,7 @@ enum stmt_types {
 	STMT_QUEUE,
 	STMT_CT,
 	STMT_SET,
+	STMT_XT,
 };
 
 /**
@@ -195,6 +208,7 @@ struct stmt {
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
 		struct set_stmt		set;
+		struct xt_stmt		xt;
 	};
 };
 
diff --git a/include/xt.h b/include/xt.h
new file mode 100644
index 0000000..3a7eaef
--- /dev/null
+++ b/include/xt.h
@@ -0,0 +1,23 @@
+#ifndef _NFT_XT_H_
+#define _NFT_XT_H_
+
+#include <xtables.h>
+
+enum nft_xt_ext_type {
+	NFT_XT_MATCH = 0,
+	NFT_XT_TARGET,
+};
+
+struct nft_xt_ext {
+	enum nft_xt_ext_type	type;
+	union {
+		struct xtables_target *tg;
+		struct xtables_match *mt;
+	};
+	void			*info;
+};
+
+int xt_argv_to_binary(const char *name, int argc, char *argv[],
+		      struct nft_xt_ext *ext);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index fd63219..1b08843 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -45,6 +45,7 @@ nft_SOURCES =	main.c				\
 		erec.c				\
 		mnl.c				\
 		iface.c				\
+		xt.c				\
 		scanner.l			\
 		parser_bison.y
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 0bf4fec..b077fd2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1705,6 +1705,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	switch (stmt->ops->type) {
 	case STMT_COUNTER:
 	case STMT_LIMIT:
+	case STMT_XT:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6d60be3..615f96a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -24,6 +24,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <xtables.h>
 #include <sys/socket.h>
 
 struct netlink_parse_ctx {
@@ -232,7 +233,8 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	nld.value = nft_rule_expr_get(nle, NFT_EXPR_CMP_DATA, &nld.len);
 	right = netlink_alloc_value(loc, &nld);
 
-	if (left->len != right->len) {
+	if (left->len && left->dtype && left->dtype->type != TYPE_STRING &&
+	    left->len != right->len) {
 		if (left->len > right->len)
 			return netlink_error(ctx, loc,
 					     "Relational expression size "
@@ -813,6 +815,74 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_match(struct netlink_parse_ctx *ctx,
+				const struct location *loc,
+				const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	const char *name;
+	struct xtables_match *mt;
+	const void *tginfo;
+	struct xt_entry_target *entry;
+	uint32_t len;
+
+	xtables_set_nfproto(ctx->table->handle.family);
+
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_MT_NAME);
+	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
+	if (!mt)
+		BUG("XT match %s not found\n", name);
+
+	tginfo = nft_rule_expr_get(nle, NFT_EXPR_MT_INFO, &len);
+
+	entry = xzalloc(sizeof(struct xt_entry_match) + len);
+	if (!entry)
+		return;
+
+	memcpy(entry->data, tginfo, len);
+
+	stmt = xt_stmt_alloc(loc);
+	stmt->xt.name = strdup(name);
+	stmt->xt.match = mt;
+	stmt->xt.entry = entry;
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
+static void netlink_parse_target(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+	const char *name;
+	struct xtables_target *tg;
+	const void *tginfo;
+	struct xt_entry_target *entry;
+	uint32_t len;
+
+	xtables_set_nfproto(ctx->table->handle.family);
+
+	name = nft_rule_expr_get_str(nle, NFT_EXPR_TG_NAME);
+	tg = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!tg)
+		BUG("XT target %s not found\n", name);
+
+	tginfo = nft_rule_expr_get(nle, NFT_EXPR_TG_INFO, &len);
+
+	entry = xzalloc(sizeof(struct xt_entry_match) + len);
+	if (!entry)
+		return;
+
+	memcpy(entry->data, tginfo, len);
+
+	stmt = xt_stmt_alloc(loc);
+	stmt->xt.name = strdup(name);
+	stmt->xt.target = tg;
+	stmt->xt.entry = entry;
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -837,6 +907,8 @@ static const struct {
 	{ .name = "redir",	.parse = netlink_parse_redir },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 	{ .name = "dynset",	.parse = netlink_parse_dynset },
+	{ .name = "target",	.parse = netlink_parse_target },
+	{ .name = "match",	.parse = netlink_parse_match },
 };
 
 static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bf1e56b..fad6582 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -18,6 +18,7 @@
 #include <netlink.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <xt.h>
 
 struct netlink_linearize_ctx {
 	struct nft_rule		*nlr;
@@ -868,6 +869,80 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+#define MAX_ARG		128	/* Should be sufficient */
+
+static void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+				const struct stmt *stmt)
+{
+	struct nft_xt_ext ext;
+	struct nft_rule_expr *nle;
+	const struct expr *expr = stmt->xt.list;
+	char *argv[MAX_ARG];
+	int family;
+	int i = 3, k, ret;
+
+	/* Makes getopt_long happy */
+	argv[0] = strdup("nft");
+	argv[1] = strdup("add");
+	argv[2] = strdup("rule");
+
+	/* This is an option with no value */
+	if (expr->identifier != NULL) {
+		char *token;
+
+		if (expr->ops->type != EXPR_SYMBOL)
+			BUG("unknown statement type %s\n", expr->ops->name);
+
+		token = strtok((char *)expr->identifier, " ");
+		while (token != NULL) {
+			argv[i++] = strdup(token);
+			token = strtok(NULL, " ");
+		}
+	}
+
+	family = nft_rule_attr_get_u32(ctx->nlr, NFT_RULE_ATTR_FAMILY);
+	xtables_set_nfproto(family);
+
+	ret = xt_argv_to_binary(stmt->xt.name, i, argv, &ext);
+
+	for (k=0; k<i; k++)
+		xfree(argv[k]);
+
+	if (ret < 0)
+		return;
+
+	switch(ext.type) {
+	case NFT_XT_MATCH:
+		nle = nft_rule_expr_alloc("match");
+		if (nle == NULL)
+			return;
+
+		nft_rule_expr_set_str(nle, NFT_EXPR_MT_NAME, ext.mt->name);
+		nft_rule_expr_set_u32(nle, NFT_EXPR_MT_REV, ext.mt->revision);
+		nft_rule_expr_set(nle, NFT_EXPR_MT_INFO, ext.info,
+				  ext.mt->m->u.match_size - sizeof(*ext.mt->m));
+		nft_rule_add_expr(ctx->nlr, nle);
+
+		xfree(ext.mt->m);
+		break;
+	case NFT_XT_TARGET:
+		nle = nft_rule_expr_alloc("target");
+		if (nle == NULL)
+			return;
+
+		nft_rule_expr_set_str(nle, NFT_EXPR_TG_NAME, ext.tg->name);
+		nft_rule_expr_set_u32(nle, NFT_EXPR_TG_REV, ext.tg->revision);
+		nft_rule_expr_set(nle, NFT_EXPR_TG_INFO, ext.info,
+				  ext.tg->t->u.target_size - sizeof(*ext.tg->t));
+		nft_rule_add_expr(ctx->nlr, nle);
+
+		xfree(ext.tg->t);
+		break;
+	default:
+		return;
+	}
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -898,6 +973,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_ct_stmt(ctx, stmt);
 	case STMT_SET:
 		return netlink_gen_set_stmt(ctx, stmt);
+	case STMT_XT:
+		return netlink_gen_xt_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fab4c52..2b206e4 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -386,6 +386,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RANDOM			"random"
 %token FULLY_RANDOM		"fully-random"
 %token PERSISTENT		"persistent"
+%token XT			"xt"
 
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
@@ -463,6 +464,12 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
 
+%type <stmt>			xt_stmt
+%destructor { stmt_free($$); }	xt_stmt
+
+%type <expr>			xt_stmt_expr
+%destructor { expr_free($$); }	xt_stmt_expr
+
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
 %type <expr>			primary_expr shift_expr and_expr
@@ -1306,6 +1313,7 @@ stmt			:	verdict_stmt
 			|	masq_stmt
 			|	redir_stmt
 			|	set_stmt
+			|	xt_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1631,6 +1639,22 @@ set_stmt_op		:	ADD	{ $$ = NFT_DYNSET_OP_ADD; }
 			|	UPDATE	{ $$ = NFT_DYNSET_OP_UPDATE; }
 			;
 
+xt_stmt			:	XT string xt_stmt_expr
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.name = $2;
+				$$->xt.list = $3;
+			}
+
+xt_stmt_expr		:	'['	string		']'
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       $2);
+				xfree($2);
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/src/scanner.l b/src/scanner.l
index 2d9871d..97a0f8f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -332,6 +332,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "fully-random"		{ return FULLY_RANDOM; }
 "persistent"		{ return PERSISTENT; }
 
+"xt"			{ return XT; }
+
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
diff --git a/src/statement.c b/src/statement.c
index 9ebc593..14ab715 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -408,3 +408,38 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &set_stmt_ops);
 }
+
+static void xt_stmt_print(const struct stmt *stmt)
+{
+	/* The XT statement is special since we obtain a binary layout from
+	 * the kernel that we cannot interpret. So we have two different
+	 * representations, one for the delinearize path (in binary layout)
+	 * and one for the linearize path (as a list of string expressions).
+	 */
+	printf("xt \"%s\" [ \"", stmt->xt.name);
+
+	if (stmt->xt.match && stmt->xt.match->save)
+		stmt->xt.match->save(NULL, stmt->xt.entry);
+	else if (stmt->xt.target && stmt->xt.target->save)
+		stmt->xt.target->save(NULL, stmt->xt.entry);
+
+	printf("\" ]");
+}
+
+static void xt_stmt_destroy(struct stmt *stmt)
+{
+	if (stmt->xt.list)
+		expr_free(stmt->xt.list);
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
index 0000000..0d92d66
--- /dev/null
+++ b/src/xt.c
@@ -0,0 +1,286 @@
+/*
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Development of this code funded by Astaro AG (http://www.astaro.com/)
+ */
+
+#include <config.h>
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <xtables.h>
+#include <utils.h>
+#include <getopt.h>
+#include <statement.h>
+#include <ctype.h> /* isupper */
+#include <xt.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables_compat.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+// #define XT_DEBUG
+
+static struct option original_opts[] = {
+	{ NULL },
+};
+
+static int xt_target_to_binary(const char *name, int argc, char *argv[],
+			       struct nft_xt_ext *ext)
+{
+	struct option *opt;
+	unsigned int offset;
+	uint8_t *entry;
+	int c;
+	struct xtables_target *tg;
+	size_t size;
+
+#if defined(XT_DEBUG)
+	struct option *o;
+
+	printf("xt table target: %s\n", name);
+	for (c = 0; c < argc; c++)
+		printf("argv[%d]: '%s'\n", c, argv[c]);
+#endif
+
+	tg = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!tg) {
+		printf("target not found\n");
+		return -1;
+	}
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target))
+                + tg->size;
+
+	/* No leak, this is attached to the nft_rule_expr object */
+	entry = xzalloc(size);
+	if (entry == NULL)
+		memory_allocation_error();
+
+	tg->t = (void *)entry;
+	tg->t->u.target_size = size;
+        tg->t->u.user.revision = tg->revision;
+
+        if (tg->udata_size != 0) {
+                free(tg->udata);
+                tg->udata = xzalloc(tg->udata_size);
+                if (tg->udata == NULL)
+			memory_allocation_error();
+        }
+        if (tg->init != NULL)
+                tg->init(tg->t);
+
+#if defined(XT_DEBUG)
+	printf("tg: extra_opts: %p, x6_opts: %p\n", tg->extra_opts, tg->x6_options);
+#endif
+
+        if (tg->x6_options != NULL)
+                opt = xtables_options_xfrm(original_opts, NULL,
+					   tg->x6_options,
+					   &offset);
+        else
+                opt = xtables_merge_options(original_opts, NULL,
+					    tg->extra_opts,
+					    &offset);
+
+#if defined(XT_DEBUG)
+	printf("Target Opt:\n");
+	for (o = opt; o && o->name; o++)
+		printf("'%s', %d, %p, %d\n", o->name, o->has_arg, o->flag, o->val);
+#endif
+
+	/* Reset internal state of getopt_long */
+	optind = 0;
+	while ((c = getopt_long(argc, argv, "j:", opt, NULL)) != -1) {
+		c -= offset;
+
+		/* TODO: invert */
+		xtables_option_tpcall(tg->option_offset + c, argv,
+				      false, tg, entry);
+	}
+
+	/* Reset parsing flags */
+	tg->tflags = 0;
+	xfree(opt);
+
+	ext->type = NFT_XT_TARGET;
+	ext->tg = tg;
+	size =  tg->t->u.target_size - sizeof(*tg->t);
+	ext->info = xmalloc(size);
+	memcpy(ext->info, tg->t->data, size);
+
+	return 0;
+}
+
+static int xt_match_to_binary(const char *name, int argc, char *argv[],
+			      struct nft_xt_ext *ext)
+{
+	struct option *opt;
+	unsigned int offset;
+	uint8_t *entry;
+	int c;
+	struct xtables_match *mt;
+        size_t size;
+
+#if defined(XT_DEBUG)
+	struct option *o;
+
+	printf("xt table match: %s\n", name);
+	for (c = 0; c < argc; c++)
+		printf("argv[%d]: '%s'\n", c, argv[c]);
+#endif
+
+	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
+	if (!mt) {
+		printf("match not found\n");
+		return -1;
+	}
+
+        size = XT_ALIGN(sizeof(struct xt_entry_match)) + mt->size;
+
+	/* No leak, this is attached to the nft_rule_expr object */
+	entry = xzalloc(size);
+	if (entry == NULL)
+		memory_allocation_error();
+
+	mt->m = (void *)entry;
+        mt->m->u.match_size = size;
+        mt->m->u.user.revision = mt->revision;
+
+        if (mt->udata_size != 0) {
+                free(mt->udata);
+                mt->udata = xzalloc(mt->udata_size);
+                if (mt->udata == NULL)
+			memory_allocation_error();
+        }
+        if (mt->init != NULL)
+                mt->init(mt->m);
+
+#if defined(XT_DEBUG)
+	printf("mt: extra_opts: %p, x6_opts: %p\n", mt->extra_opts, mt->x6_options);
+#endif
+
+        if (mt->x6_options != NULL)
+                opt = xtables_options_xfrm(original_opts, NULL,
+					   mt->x6_options, &offset);
+        else
+                opt = xtables_merge_options(original_opts, NULL,
+					    mt->extra_opts, &offset);
+
+#if defined(XT_DEBUG)
+	printf("Match Opt:\n");
+	for (o = opt; o && o->name; o++)
+		printf("'%s', %d, %p, %d\n", o->name, o->has_arg, o->flag, o->val);
+#endif
+
+	/* Reset internal state of getopt_long */
+	optind = 0;
+	while ((c = getopt_long(argc, argv, "m:", opt, NULL)) != -1) {
+		c -= offset;
+
+		/* TODO: invert */
+		xtables_option_mpcall(mt->option_offset + c, argv,
+				      false, mt, entry);
+	}
+
+	/* Reset parsing flags */
+	mt->mflags = 0;
+	xfree(opt);
+
+	ext->type = NFT_XT_MATCH;
+	ext->mt = mt;
+	size = mt->m->u.match_size - sizeof(*mt->m);
+	ext->info = xmalloc(size);
+	memcpy(ext->info, mt->m->data, size);
+
+	return 0;
+}
+
+int xt_argv_to_binary(const char *name, int argc, char *argv[],
+		      struct nft_xt_ext *ext)
+{
+	int ret;
+
+	/* Assume upper case is a target, fine for {ip,ip6}tables. */
+	if (isupper(name[0]))
+		ret = xt_target_to_binary(name, argc, argv, ext);
+	else
+		ret = xt_match_to_binary(name, argc, argv, ext);
+
+	return ret;
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
+	pr_debug("requesting `%s' rev=%d type=%d via nft_compat\n",
+		 name, rev, type);
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
2.1.4


--------------010806090308020803010608
Content-Type: text/x-patch;
 name="0001-netfilter-x_tables-add-context-to-ipt_REJECT-xt_TPRO.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-x_tables-add-context-to-ipt_REJECT-xt_TPRO.pa";
 filename*1="tch"

>From b52f4de91f4eace20e01524cb487bad0a9e35dc4 Mon Sep 17 00:00:00 2001
From: Andreas Schultz <aschultz@tpip.net>
Date: Mon, 1 Jun 2015 15:49:12 +0200
Subject: [PATCH 1/3] netfilter: x_tables: add context to ipt_REJECT, xt_TPROXY
 and generix x_tables know if extension runs from nft_compat

---
 net/ipv4/netfilter/ipt_REJECT.c | 2 ++
 net/netfilter/x_tables.c        | 4 ++--
 net/netfilter/xt_TPROXY.c       | 6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 87907d4..2f8f76c 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -76,6 +76,8 @@ static int reject_tg_check(const struct xt_tgchk_param *par)
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		pr_info("ECHOREPLY no longer supported.\n");
 		return -EINVAL;
+	} else if (par->nft_compat) {
+		return 0;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP ||
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 51a459c..fd9b421 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -400,7 +400,7 @@ int xt_check_match(struct xt_mtchk_param *par,
 		                     par->family));
 		return -EINVAL;
 	}
-	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
+	if (!par->nft_compat && par->match->proto && (par->match->proto != proto || inv_proto)) {
 		pr_err("%s_tables: %s match: only valid for protocol %u\n",
 		       xt_prefix[par->family], par->match->name,
 		       par->match->proto);
@@ -575,7 +575,7 @@ int xt_check_target(struct xt_tgchk_param *par,
 		                     par->family));
 		return -EINVAL;
 	}
-	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
+	if (!par->nft_compat && par->target->proto && (par->target->proto != proto || inv_proto)) {
 		pr_err("%s_tables: %s target: only valid for protocol %u\n",
 		       xt_prefix[par->family], par->target->name,
 		       par->target->proto);
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index cca96ce..90da66c 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -519,6 +519,9 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_ip6 *i = par->entryinfo;
 
+	if (par->nft_compat)
+		return 0;
+
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
 	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
@@ -533,6 +536,9 @@ static int tproxy_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_ip *i = par->entryinfo;
 
+	if (par->nft_compat)
+		return 0;
+
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
 	    && !(i->invflags & IPT_INV_PROTO))
 		return 0;
-- 
2.1.4


--------------010806090308020803010608
Content-Type: text/x-patch;
 name="disable-nft-compat-validation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="disable-nft-compat-validation.patch"

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 66def31..6b5d95c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -287,14 +287,18 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	return 0;
+
 	if (ctx->chain->flags & NFT_BASE_CHAIN) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		hook_mask = 1 << ops->hooknum;
-		if (!(hook_mask & target->hooks))
+		if (!(hook_mask & target->hooks)) {
+			printk(KERN_ERR "nft_target_validate: hook validation failed\n");
 			return -EINVAL;
+		}
 
 		ret = nft_compat_chain_validate_dependency(target->table,
 							   ctx->chain);
@@ -469,14 +473,18 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 	unsigned int hook_mask = 0;
 	int ret;
 
+	return 0;
+
 	if (ctx->chain->flags & NFT_BASE_CHAIN) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
 		const struct nf_hook_ops *ops = &basechain->ops[0];
 
 		hook_mask = 1 << ops->hooknum;
-		if (!(hook_mask & match->hooks))
+		if (!(hook_mask & match->hooks)) {
+			printk(KERN_ERR "nft_match_validate: hook validation failed\n");
 			return -EINVAL;
+		}
 
 		ret = nft_compat_chain_validate_dependency(match->table,
 							   ctx->chain);

--------------010806090308020803010608--
