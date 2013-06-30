From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add xt compat support
Date: Sun, 30 Jun 2013 18:02:05 +0200
Message-ID: <1372608125-28734-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58632 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3F3QCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:02:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 configure.ac                               |    3 +
 include/expression.h                       |   10 ++
 include/linux/netfilter/nf_tables_compat.h |   20 +++
 include/statement.h                        |   14 ++
 include/xt.h                               |   23 ++++
 src/Makefile.in                            |    1 +
 src/evaluate.c                             |    1 +
 src/expression.c                           |   24 ++++
 src/netlink_delinearize.c                  |   71 ++++++++++
 src/netlink_linearize.c                    |   97 +++++++++++++
 src/parser.y                               |   56 +++++++-
 src/scanner.l                              |    8 ++
 src/statement.c                            |   67 +++++++++
 src/xt.c                                   |  206 ++++++++++++++++++++++++++++
 14 files changed, 600 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/netfilter/nf_tables_compat.h
 create mode 100644 include/xt.h
 create mode 100644 src/xt.c

diff --git a/configure.ac b/configure.ac
index 811d7e2..fe5eb96 100644
--- a/configure.ac
+++ b/configure.ac
@@ -55,6 +55,9 @@ AC_CHECK_LIB([mnl], [mnl_socket_open], ,
 AC_CHECK_LIB([nftables], [nft_rule_alloc], ,
 	     AC_MSG_ERROR([No suitable version of libnftables found]))
 
+AC_CHECK_LIB([xtables], [xtables_find_target], ,
+	     AC_MSG_ERROR([No suitable version of libxtables found]))
+
 AC_CHECK_LIB([gmp], [__gmpz_init], ,
 	     AC_MSG_ERROR([No suitable version of libgmp found]))
 
diff --git a/include/expression.h b/include/expression.h
index f0eb799..63e764b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -32,6 +32,7 @@
  * @EXPR_UNARY:		byteorder conversion, generated during evaluation
  * @EXPR_BINOP:		binary operations (bitwise, shifts)
  * @EXPR_RELATIONAL:	equality and relational expressions
+ * @EXPR_OPTION:	--option value expression
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -53,6 +54,7 @@ enum expr_types {
 	EXPR_UNARY,
 	EXPR_BINOP,
 	EXPR_RELATIONAL,
+	EXPR_OPTION,
 };
 
 enum ops {
@@ -242,6 +244,11 @@ struct expr {
 			/* EXPR_CT */
 			enum nft_ct_keys	key;
 		} ct;
+		struct {
+			/* EXPR_OPTION */
+			const char		*id;
+			struct expr		*val;
+		};
 	};
 };
 
@@ -333,4 +340,7 @@ extern struct expr *map_expr_alloc(const struct location *loc,
 extern struct expr *set_ref_expr_alloc(const struct location *loc,
 				       struct set *set);
 
+struct expr *option_expr_alloc(const struct location *loc, const char *id,
+			       struct expr *value);
+
 #endif /* NFTABLES_EXPRESSION_H */
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
index 20b6f9a..87f9811 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -3,6 +3,7 @@
 
 #include <list.h>
 #include <expression.h>
+#include <xt.h>
 
 extern struct stmt *expr_stmt_alloc(const struct location *loc,
 				    struct expr *expr);
@@ -60,6 +61,16 @@ struct nat_stmt {
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc);
 
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
@@ -72,6 +83,7 @@ extern struct stmt *nat_stmt_alloc(const struct location *loc);
  * @STMT_LOG:		log statement
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
+ * @STMT_XT:		XT statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -83,6 +95,7 @@ enum stmt_types {
 	STMT_LOG,
 	STMT_REJECT,
 	STMT_NAT,
+	STMT_XT,
 };
 
 /**
@@ -128,6 +141,7 @@ struct stmt {
 		struct limit_stmt	limit;
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
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
diff --git a/src/Makefile.in b/src/Makefile.in
index 658e9b3..e86d5d5 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -22,6 +22,7 @@ nft-obj			+= gmputil.o
 nft-obj			+= utils.o
 nft-obj			+= erec.o
 nft-obj			+= mnl.o
+nft-obj			+= xt.o
 
 nft-obj			+= parser.o
 nft-extra-clean-files	+= parser.c parser.h
diff --git a/src/evaluate.c b/src/evaluate.c
index 85c647e..4f4b1ce 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1155,6 +1155,7 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 	case STMT_LOG:
+	case STMT_XT:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/expression.c b/src/expression.c
index 8cf3f62..230cfbd 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -753,3 +753,27 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
 }
+
+static void option_expr_destroy(struct expr *expr)
+{
+	xfree(expr->id);
+	expr_free(expr->val);
+}
+
+static const struct expr_ops option_expr_ops = {
+	.type		= EXPR_OPTION,
+	.name		= "option",
+	.destroy	= option_expr_destroy,
+};
+
+struct expr *option_expr_alloc(const struct location *loc, const char *id,
+			       struct expr *value)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, &option_expr_ops, &invalid_type,
+			  BYTEORDER_INVALID, 0);
+	expr->id = id;
+	expr->val = value;
+	return expr;
+}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9348913..167edff 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -21,6 +21,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <xtables.h>
 
 struct netlink_parse_ctx {
 	struct list_head	*msgs;
@@ -465,6 +466,74 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
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
+	size_t len;
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
+	size_t len;
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
@@ -485,6 +554,8 @@ static const struct {
 	{ .name = "limit",	.parse = netlink_parse_limit },
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
+	{ .name = "target",	.parse = netlink_parse_target },
+	{ .name = "match",	.parse = netlink_parse_match },
 };
 
 static const struct input_descriptor indesc_netlink = {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e507f91..1961278 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -18,6 +18,7 @@
 #include <netlink.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <xt.h>
 
 struct netlink_linearize_ctx {
 	struct nft_rule		*nlr;
@@ -627,6 +628,100 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+#define MAX_ARG		128	/* Should be sufficient */
+
+static void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+				const struct stmt *stmt)
+{
+	struct nft_xt_ext ext;
+	struct nft_rule_expr *nle;
+	const struct expr *expr;
+	char *argv[MAX_ARG];
+	uint8_t family;
+	int i = 3, k, ret;
+
+	/* Makes getopt_long happy */
+	argv[0] = strdup("nft");
+	argv[1] = strdup("add");
+	argv[2] = strdup("rule");
+
+	list_for_each_entry(expr, &stmt->xt.list->expressions, list) {
+		if (i >= MAX_ARG)
+			return;
+
+		switch (expr->ops->type) {
+		case EXPR_OPTION:
+			argv[i++] = strdup(expr->id);
+
+			/* This is an option with no value */
+			if (expr->val == NULL)
+				continue;
+
+			switch(expr->val->ops->type) {
+			case EXPR_SYMBOL:
+				argv[i++] = strdup(expr->val->identifier);
+				break;
+			case EXPR_RANGE: {
+				int len = strlen(expr->val->left->identifier) +
+					  strlen(expr->val->right->identifier) + 3;
+				char buf[len];
+
+				snprintf(buf, len, "%s-%s",
+					 expr->val->left->identifier,
+					 expr->val->right->identifier);
+				buf[len-1] = '\0';
+				argv[i++] = strdup(buf);
+				break;
+			}
+			default:
+				BUG("unknown statement type %s\n",
+				    expr->val->ops->name);
+			}
+			break;
+		default:
+			BUG("unknown statement type %s\n", expr->ops->name);
+		}
+	}
+
+	family = nft_rule_attr_get_u8(ctx->nlr, NFT_RULE_ATTR_FAMILY);
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
+				  ext.mt->userspacesize);
+		nft_rule_add_expr(ctx->nlr, nle);
+		break;
+	case NFT_XT_TARGET:
+		nle = nft_rule_expr_alloc("target");
+		if (nle == NULL)
+			return;
+
+		nft_rule_expr_set_str(nle, NFT_EXPR_TG_NAME, ext.tg->name);
+		nft_rule_expr_set_u32(nle, NFT_EXPR_TG_REV, ext.tg->revision);
+		nft_rule_expr_set(nle, NFT_EXPR_TG_INFO, ext.info,
+				  ext.tg->userspacesize);
+		nft_rule_add_expr(ctx->nlr, nle);
+		break;
+	default:
+		return;
+	}
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -647,6 +742,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_reject_stmt(ctx, stmt);
 	case STMT_NAT:
 		return netlink_gen_nat_stmt(ctx, stmt);
+	case STMT_XT:
+		return netlink_gen_xt_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser.y b/src/parser.y
index 2923b59..abbeb29 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -183,9 +183,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token QUEUE			"queue"
 
 %token <val> NUM		"number"
+%token <string> OPTION		"option"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
-%destructor { xfree($$); }	STRING QUOTED_STRING
+%destructor { xfree($$); }	STRING QUOTED_STRING OPTION
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -326,6 +327,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SNAT			"snat"
 %token DNAT			"dnat"
 
+%token XT			"xt"
+
 %type <string>			identifier string
 %destructor { xfree($$); }	identifier string
 
@@ -371,7 +374,14 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
+%type <stmt>			xt_stmt
+%destructor { stmt_free($$); }	xt_stmt
+
+%type <expr>			xt_list_expr xt_list_member_expr
+%destructor { expr_free($$); }	xt_list_expr xt_list_member_expr
 
+%type <expr>			xt_stmt_args
+%destructor { expr_free($$); }	xt_stmt_args
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
 %type <expr>			primary_expr shift_expr and_expr
@@ -882,6 +892,7 @@ stmt			:	verdict_stmt
 			|	limit_stmt
 			|	reject_stmt
 			|	nat_stmt
+			|	xt_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1009,6 +1020,49 @@ nat_stmt_args		:	expr
 			}
 			;
 
+xt_stmt			:	XT string xt_stmt_args
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.name = $2;
+				$$->xt.list = $3;
+			}
+
+xt_stmt_args		:	'['	xt_list_expr	']'
+			{
+				$2->location = @$;
+				$$ = $2;
+			}
+			;
+
+xt_list_expr		:	xt_list_member_expr
+			{
+				$$ = list_expr_alloc(&@$);
+				compound_expr_add($$, $1);
+			}
+			|	xt_list_expr OPTION expr
+			{
+				$$ = option_expr_alloc(&@$, $2, $3);
+				compound_expr_add($1, $$);
+				$$ = $1;
+			}
+			|	xt_list_expr OPTION
+			{
+				$$ = option_expr_alloc(&@$, $2, NULL);
+				compound_expr_add($1, $$);
+				$$ = $1;
+			}
+			;
+
+xt_list_member_expr	:	OPTION expr
+			{
+				$$ = option_expr_alloc(&@$, $1, $2);
+			}
+			|	OPTION
+			{
+				$$ = option_expr_alloc(&@$, $1, NULL);
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/src/scanner.l b/src/scanner.l
index fe7b86c..9dc76cf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -112,6 +112,7 @@ hexstring	0[xX]{hexdigit}+
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
+option		\-\-({letter}|{digit}|\-)*
 quotedstring	\"[^"]*\"
 comment		#.*$
 slash		\/
@@ -276,6 +277,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
 
+"xt"			{ return XT; }
+
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
@@ -418,6 +421,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{option}		{
+				yylval->string = xstrdup(yytext);
+				return OPTION;
+			}
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
diff --git a/src/statement.c b/src/statement.c
index 1a3ea3c..3fd105f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -208,3 +208,70 @@ struct stmt *nat_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &nat_stmt_ops);
 }
+
+static void xt_stmt_print(const struct stmt *stmt)
+{
+	struct expr *expr;
+
+	/* The XT statement is special since we obtain a binary layout from
+	 * the kernel that we cannot interpret. So we have two different
+	 * representations, one for the delinearize path (in binary layout)
+	 * and one for the linearize path (as a list of option expressions).
+	 */
+	printf("xt %s [", stmt->xt.name);
+
+	if (stmt->xt.match && stmt->xt.match->save)
+		stmt->xt.match->save(NULL, stmt->xt.entry);
+	else if (stmt->xt.target && stmt->xt.target->save)
+		stmt->xt.target->save(NULL, stmt->xt.entry);
+
+	if (stmt->xt.list == NULL)
+		goto out;
+
+        list_for_each_entry(expr, &stmt->xt.list->expressions, list) {
+		switch (expr->ops->type) {
+                case EXPR_OPTION:
+			printf("%s ", strdup(expr->id));
+
+			/* This is an option with no value */
+			if (expr->val == NULL)
+				continue;
+
+                        switch(expr->val->ops->type) {
+                        case EXPR_SYMBOL:
+				printf("%s ", expr->val->identifier);
+				break;
+			case EXPR_RANGE:
+				printf("%s-%s", expr->val->left->identifier,
+				       expr->val->right->identifier);
+				break;
+			default:
+				BUG("unknown statement type %s\n",
+				    expr->val->ops->name);
+			break;
+			}
+		default:
+			BUG("unknown statement type %s\n", expr->ops->name);
+		}
+	}
+out:
+	printf(" ]");
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
index 0000000..0a40512
--- /dev/null
+++ b/src/xt.c
@@ -0,0 +1,206 @@
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
+
+	tg = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!tg) {
+		printf("target not found\n");
+		return -1;
+	}
+
+	/* No leak, this is attached to the nft_rule_expr object */
+	entry = xzalloc(sizeof(struct xt_entry_target) + tg->size);
+	if (entry == NULL)
+		memory_allocation_error();
+
+	tg->t = (void *)entry;
+
+	/* TODO: support non x6_options */
+	opt = xtables_options_xfrm(original_opts, NULL, tg->x6_options,
+				   &offset);
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
+	ext->info = entry + sizeof(struct xt_entry_target);
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
+
+	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
+	if (!mt) {
+		printf("match not found\n");
+		return -1;
+	}
+
+	/* No leak, this is attached to the nft_rule_expr object */
+	entry = xzalloc(sizeof(struct xt_entry_match) + mt->size);
+	if (entry == NULL)
+		memory_allocation_error();
+
+	mt->m = (void *)entry;
+
+	/* TODO: support non x6_options */
+	opt = xtables_options_xfrm(original_opts, NULL, mt->x6_options,
+				   &offset);
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
+	ext->info = entry + sizeof(struct xt_entry_match);
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
1.7.10.4

