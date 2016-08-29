From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/8] src: add numgen expression
Date: Mon, 29 Aug 2016 20:21:14 +0200
Message-ID: <1472494879-16442-3-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbcH2SVc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E05ED1324E4
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA05D100A57
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34DDE100A6C
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:28 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new expression allows us to generate incremental and random numbers
bound to a specified modulus value.

The following rule sets the conntrack mark of 0 to the first packet seen,
then 1 to second packet, then 0 again to the third packet and so on:

 # nft add rule x y ct mark set numgen inc mod 2

A more useful example is a simple load balancing scenario, where you can
also use maps to set the destination NAT address based on this new numgen
expression:

 # nft add rule nat prerouting \
	dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }

So this is distributing new connections in a round-robin fashion between
192.168.10.100 and 192.168.20.200. Don't forget the special NAT chain
semantics: Only the first packet evaluates the rule, follow up packets
rely on conntrack to apply the NAT information.

You can also emulate flow distribution with different backend weights
using intervals:

 # nft add rule nat prerouting \
	dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200 }

So 192.168.10.100 gets 60% of the workload, while 192.168.20.200 gets 40%.

We can also be mixed with dynamic sets, thus weight can be updated in
runtime.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am          |  1 +
 include/expression.h         |  8 ++++++
 include/numgen.h             |  7 +++++
 src/Makefile.am              |  1 +
 src/evaluate.c               | 27 ++++++++++++++++++
 src/netlink_delinearize.c    | 18 ++++++++++++
 src/netlink_linearize.c      | 15 ++++++++++
 src/numgen.c                 | 68 ++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y           | 21 ++++++++++++--
 src/scanner.l                |  4 +++
 tests/py/ip/numgen.t         |  6 ++++
 tests/py/ip/numgen.t.payload | 24 ++++++++++++++++
 12 files changed, 197 insertions(+), 3 deletions(-)
 create mode 100644 include/numgen.h
 create mode 100644 src/numgen.c
 create mode 100644 tests/py/ip/numgen.t
 create mode 100644 tests/py/ip/numgen.t.payload

diff --git a/include/Makefile.am b/include/Makefile.am
index 58c58cb..940f2e5 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -17,6 +17,7 @@ noinst_HEADERS = 	cli.h		\
 			headers.h	\
 			list.h		\
 			meta.h		\
+			numgen.h	\
 			netlink.h	\
 			parser.h	\
 			proto.h		\
diff --git a/include/expression.h b/include/expression.h
index 6e5e835..b6005ec 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -33,6 +33,7 @@
  * @EXPR_UNARY:		byteorder conversion, generated during evaluation
  * @EXPR_BINOP:		binary operations (bitwise, shifts)
  * @EXPR_RELATIONAL:	equality and relational expressions
+ * @EXPR_NUMGEN:	number generation expression
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -55,6 +56,7 @@ enum expr_types {
 	EXPR_UNARY,
 	EXPR_BINOP,
 	EXPR_RELATIONAL,
+	EXPR_NUMGEN,
 };
 
 enum ops {
@@ -170,6 +172,7 @@ enum expr_flags {
 
 #include <payload.h>
 #include <exthdr.h>
+#include <numgen.h>
 #include <meta.h>
 #include <ct.h>
 
@@ -277,6 +280,11 @@ struct expr {
 			enum nft_ct_keys	key;
 			int8_t			direction;
 		} ct;
+		struct {
+			/* EXPR_NUMGEN */
+			enum nft_ng_types	type;
+			uint32_t		mod;
+		} numgen;
 	};
 };
 
diff --git a/include/numgen.h b/include/numgen.h
new file mode 100644
index 0000000..bec18e5
--- /dev/null
+++ b/include/numgen.h
@@ -0,0 +1,7 @@
+#ifndef NFTABLES_NUMGEN_H
+#define NFTABLES_NUMGEN_H
+
+extern struct expr *numgen_expr_alloc(const struct location *loc,
+				      enum nft_ng_types type, uint32_t until);
+
+#endif /* NFTABLES_NUMGEN_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 8c59449..241a078 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -37,6 +37,7 @@ nft_SOURCES =	main.c				\
 		payload.c			\
 		exthdr.c			\
 		meta.c				\
+		numgen.c			\
 		ct.c				\
 		netlink.c			\
 		netlink_linearize.c		\
diff --git a/src/evaluate.c b/src/evaluate.c
index d669b85..ed722df 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1158,6 +1158,31 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+/* We got datatype context via statement. If the basetype is compatible, set
+ * this expression datatype to the one of the statement to make it datatype
+ * compatible. This is a more conservative approach than enabling datatype
+ * compatibility between two different datatypes whose basetype is the same,
+ * let's revisit this later once users come with valid usecases to generalize
+ * this.
+ */
+static void expr_dtype_integer_compatible(struct eval_ctx *ctx,
+					  struct expr *expr)
+{
+	if (ctx->ectx.dtype &&
+	    ctx->ectx.dtype->basetype == &integer_type &&
+	    ctx->ectx.len == 4 * BITS_PER_BYTE) {
+		expr->dtype = ctx->ectx.dtype;
+		expr->len   = ctx->ectx.len;
+	}
+}
+
+static int expr_evaluate_numgen(struct eval_ctx *ctx, struct expr **exprp)
+{
+	expr_dtype_integer_compatible(ctx, *exprp);
+
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 /*
  * Transfer the invertible binops to the constant side of an equality
  * expression. A left shift is only invertible if the low n bits are
@@ -1560,6 +1585,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_mapping(ctx, expr);
 	case EXPR_RELATIONAL:
 		return expr_evaluate_relational(ctx, expr);
+	case EXPR_NUMGEN:
+		return expr_evaluate_numgen(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", (*expr)->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9e0a82..adcce67 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -507,6 +507,22 @@ static void netlink_parse_meta(struct netlink_parse_ctx *ctx,
 		netlink_parse_meta_stmt(ctx, loc, nle);
 }
 
+static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nftnl_expr *nle)
+{
+	enum nft_registers dreg;
+	uint32_t type, until;
+	struct expr *expr;
+
+	type  = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_TYPE);
+	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_UNTIL);
+
+	expr = numgen_expr_alloc(loc, type, until);
+	dreg = netlink_parse_register(nle, NFTNL_EXPR_NG_DREG);
+	netlink_set_register(ctx, dreg, expr);
+}
+
 static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nftnl_expr *nle)
@@ -1003,6 +1019,7 @@ static const struct {
 	{ .name = "target",	.parse = netlink_parse_target },
 	{ .name = "match",	.parse = netlink_parse_match },
 	{ .name = "quota",	.parse = netlink_parse_quota },
+	{ .name = "numgen",	.parse = netlink_parse_numgen },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -1622,6 +1639,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_SET_REF:
 	case EXPR_META:
 	case EXPR_VERDICT:
+	case EXPR_NUMGEN:
 		break;
 	case EXPR_CT:
 		ct_expr_update_type(&ctx->pctx, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index a14d0ff..2c6848c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -151,6 +151,19 @@ static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
+			    const struct expr *expr,
+			    enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("numgen");
+	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, dreg);
+	netlink_put_register(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_UNTIL, expr->numgen.mod);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 			   const struct expr *expr,
 			   enum nft_registers dreg)
@@ -614,6 +627,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_ct(ctx, expr, dreg);
 	case EXPR_SET_ELEM:
 		return netlink_gen_expr(ctx, expr->key, dreg);
+	case EXPR_NUMGEN:
+		return netlink_gen_numgen(ctx, expr, dreg);
 	default:
 		BUG("unknown expression type %s\n", expr->ops->name);
 	}
diff --git a/src/numgen.c b/src/numgen.c
new file mode 100644
index 0000000..d9a43aa
--- /dev/null
+++ b/src/numgen.c
@@ -0,0 +1,68 @@
+/*
+ * Number generator expression definitions.
+ *
+ * Copyright (c) 2016 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <nftables.h>
+#include <expression.h>
+#include <datatype.h>
+#include <gmputil.h>
+#include <numgen.h>
+#include <utils.h>
+
+static const char *numgen_type[NFT_NG_RANDOM + 1] = {
+	[NFT_NG_INCREMENTAL]	= "inc",
+	[NFT_NG_RANDOM]		= "random",
+};
+
+static const char *numgen_type_str(enum nft_ng_types type)
+{
+	if (type > NFT_NG_RANDOM)
+		return "[unknown numgen]";
+
+	return numgen_type[type];
+}
+
+static void numgen_expr_print(const struct expr *expr)
+{
+	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
+	       expr->numgen.mod);
+}
+
+static bool numgen_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->numgen.type == e2->numgen.type &&
+	       e1->numgen.mod == e2->numgen.mod;
+}
+
+static void numgen_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->numgen.type = expr->numgen.type;
+	new->numgen.mod = expr->numgen.mod;
+}
+
+static const struct expr_ops numgen_expr_ops = {
+	.type		= EXPR_NUMGEN,
+	.name		= "numgen",
+	.print		= numgen_expr_print,
+	.cmp		= numgen_expr_cmp,
+	.clone		= numgen_expr_clone,
+};
+
+struct expr *numgen_expr_alloc(const struct location *loc,
+			       enum nft_ng_types type, uint32_t mod)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, &numgen_expr_ops, &integer_type,
+			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
+	expr->numgen.type  = type;
+	expr->numgen.mod   = mod;
+
+	return expr;
+}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6b58fe7..23e8b27 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -407,6 +407,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DUP			"dup"
 %token FWD			"fwd"
 
+%token NUMGEN			"numgen"
+%token INC			"inc"
+%token MOD			"mod"
+
 %token POSITION			"position"
 %token COMMENT			"comment"
 
@@ -552,8 +556,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			arp_hdr_expr
 %destructor { expr_free($$); }	arp_hdr_expr
 %type <val>			arp_hdr_field
-%type <expr>			ip_hdr_expr	icmp_hdr_expr
-%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr
+%type <expr>			ip_hdr_expr	icmp_hdr_expr		numgen_expr
+%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		numgen_expr
 %type <val>			ip_hdr_field	icmp_hdr_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
@@ -582,7 +586,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			meta_expr
 %destructor { expr_free($$); }	meta_expr
-%type <val>			meta_key	meta_key_qualified	meta_key_unqualified
+%type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
@@ -1967,6 +1971,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	exthdr_expr			{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
+			|	numgen_expr			{ $$ = $1; }
 			|	'('	basic_expr	')'	{ $$ = $2; }
 			;
 
@@ -2454,6 +2459,16 @@ meta_stmt		:	META	meta_key	SET	expr
 			}
 			;
 
+numgen_type		:	INC		{ $$ = NFT_NG_INCREMENTAL; }
+			|	RANDOM		{ $$ = NFT_NG_RANDOM; }
+			;
+
+numgen_expr		:	NUMGEN	numgen_type	MOD	NUM
+			{
+				$$ = numgen_expr_alloc(&@$, $2, $4);
+			}
+			;
+
 ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
diff --git a/src/scanner.l b/src/scanner.l
index 53b79aa..cff375f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -467,6 +467,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-dst"		{ return PROTO_DST; }
 "label"			{ return LABEL; }
 
+"numgen"		{ return NUMGEN; }
+"inc"			{ return INC; }
+"mod"			{ return MOD; }
+
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
diff --git a/tests/py/ip/numgen.t b/tests/py/ip/numgen.t
new file mode 100644
index 0000000..9ce0c71
--- /dev/null
+++ b/tests/py/ip/numgen.t
@@ -0,0 +1,6 @@
+:pre;type nat hook prerouting priority 0
+*ip;test-ip4;pre
+
+ct mark set numgen inc mod 2;ok
+dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 };ok
+dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200};ok
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
new file mode 100644
index 0000000..cc07485
--- /dev/null
+++ b/tests/py/ip/numgen.t.payload
@@ -0,0 +1,24 @@
+# ct mark set numgen inc mod 2
+ip test-ip4 pre
+  [ numgen reg 1 = inc(2)]
+  [ ct set mark with reg 1 ]
+
+# dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
+__map%d x b
+__map%d x 0
+        element 00000000  : 640aa8c0 0 [end]    element 01000000  : c814a8c0 0 [end]
+ip test-ip4 pre 
+  [ numgen reg 1 = inc(2)]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
+# dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}
+__map%d test-ip4 f
+__map%d test-ip4 0
+        element 00000000  : 640aa8c0 0 [end]    element 06000000  : c814a8c0 0 [end]    element 0a000000  : 1 [end]
+ip test-ip4 pre
+  [ numgen reg 1 = inc(10)]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
-- 
2.1.4

