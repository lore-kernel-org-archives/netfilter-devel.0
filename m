From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/8] src: add hash expression
Date: Mon, 29 Aug 2016 20:21:15 +0200
Message-ID: <1472494879-16442-4-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753566AbcH2SVe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5CFC1324E2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF93B100A6A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C4A0100A76
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:29 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is special expression that transforms an input expression into a
32-bit unsigned integer. This expression takes a modulus parameter to
scale the result and the random seed so the hash result becomes harder
to predict.

You can use it to set the packet mark, eg.

 # nft add rule x y meta mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef

You can combine this with maps too, eg.

 # nft add rule x y dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { \
	0 : 192.168.20.100, \
	1 : 192.168.30.100 \
   }

Currently, this expression implements the jenkins hash implementation
available in the Linux kernel:

 http://lxr.free-electrons.com/source/include/linux/jhash.h

But it should be possible to extend it to support any other hash
function type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h       |  9 +++++++
 include/hash.h             |  7 ++++++
 src/Makefile.am            |  1 +
 src/evaluate.c             | 21 ++++++++++++++++
 src/hash.c                 | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c  | 32 +++++++++++++++++++++++++
 src/netlink_linearize.c    | 23 ++++++++++++++++++
 src/parser_bison.y         | 15 ++++++++++--
 src/scanner.l              |  3 +++
 tests/py/ip/hash.t         |  5 ++++
 tests/py/ip/hash.t.payload | 17 +++++++++++++
 11 files changed, 191 insertions(+), 2 deletions(-)
 create mode 100644 include/hash.h
 create mode 100644 src/hash.c
 create mode 100644 tests/py/ip/hash.t
 create mode 100644 tests/py/ip/hash.t.payload

diff --git a/include/expression.h b/include/expression.h
index b6005ec..6a509b3 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -34,6 +34,7 @@
  * @EXPR_BINOP:		binary operations (bitwise, shifts)
  * @EXPR_RELATIONAL:	equality and relational expressions
  * @EXPR_NUMGEN:	number generation expression
+ * @EXPR_HASH:		hash expression
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -57,6 +58,7 @@ enum expr_types {
 	EXPR_BINOP,
 	EXPR_RELATIONAL,
 	EXPR_NUMGEN,
+	EXPR_HASH,
 };
 
 enum ops {
@@ -174,6 +176,7 @@ enum expr_flags {
 #include <exthdr.h>
 #include <numgen.h>
 #include <meta.h>
+#include <hash.h>
 #include <ct.h>
 
 /**
@@ -285,6 +288,12 @@ struct expr {
 			enum nft_ng_types	type;
 			uint32_t		mod;
 		} numgen;
+		struct {
+			/* EXPR_HASH */
+			struct expr		*expr;
+			uint32_t		mod;
+			uint32_t		seed;
+		} hash;
 	};
 };
 
diff --git a/include/hash.h b/include/hash.h
new file mode 100644
index 0000000..bc8c86a
--- /dev/null
+++ b/include/hash.h
@@ -0,0 +1,7 @@
+#ifndef NFTABLES_HASH_H
+#define NFTABLES_HASH_H
+
+extern struct expr *hash_expr_alloc(const struct location *loc,
+				    uint32_t modulus, uint32_t seed);
+
+#endif /* NFTABLES_HASH_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index 241a078..63bbef2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -36,6 +36,7 @@ nft_SOURCES =	main.c				\
 		proto.c				\
 		payload.c			\
 		exthdr.c			\
+		hash.c				\
 		meta.c				\
 		numgen.c			\
 		ct.c				\
diff --git a/src/evaluate.c b/src/evaluate.c
index ed722df..8f7824b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1183,6 +1183,25 @@ static int expr_evaluate_numgen(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate_primary(ctx, exprp);
 }
 
+static int expr_evaluate_hash(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	expr_dtype_integer_compatible(ctx, expr);
+
+	expr_set_context(&ctx->ectx, NULL, 0);
+	if (expr_evaluate(ctx, &expr->hash.expr) < 0)
+		return -1;
+
+	/* expr_evaluate_primary() sets the context to what to the input
+         * expression to be hashed. Since this input is transformed to a 4 bytes
+	 * integer, restore context to the datatype that results from hashing.
+	 */
+	expr_set_context(&ctx->ectx, expr->dtype, expr->len);
+
+	return 0;
+}
+
 /*
  * Transfer the invertible binops to the constant side of an equality
  * expression. A left shift is only invertible if the low n bits are
@@ -1587,6 +1606,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_relational(ctx, expr);
 	case EXPR_NUMGEN:
 		return expr_evaluate_numgen(ctx, expr);
+	case EXPR_HASH:
+		return expr_evaluate_hash(ctx, expr);
 	default:
 		BUG("unknown expression type %s\n", (*expr)->ops->name);
 	}
diff --git a/src/hash.c b/src/hash.c
new file mode 100644
index 0000000..125b320
--- /dev/null
+++ b/src/hash.c
@@ -0,0 +1,60 @@
+/*
+ * Hash expression definitions.
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
+#include <hash.h>
+#include <utils.h>
+
+static void hash_expr_print(const struct expr *expr)
+{
+	printf("jhash ");
+	expr_print(expr->hash.expr);
+	printf(" mod %u", expr->hash.mod);
+	if (expr->hash.seed)
+		printf(" seed 0x%x", expr->hash.seed);
+}
+
+static bool hash_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return expr_cmp(e1->hash.expr, e2->hash.expr) &&
+	       e1->hash.mod == e2->hash.mod &&
+	       e1->hash.seed == e2->hash.seed;
+}
+
+static void hash_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->hash.expr = expr_clone(expr->hash.expr);
+	new->hash.mod = expr->hash.mod;
+	new->hash.seed = expr->hash.seed;
+}
+
+static const struct expr_ops hash_expr_ops = {
+	.type		= EXPR_HASH,
+	.name		= "hash",
+	.print		= hash_expr_print,
+	.cmp		= hash_expr_cmp,
+	.clone		= hash_expr_clone,
+};
+
+struct expr *hash_expr_alloc(const struct location *loc, uint32_t mod,
+			     uint32_t seed)
+{
+	struct expr *expr;
+
+	expr = expr_alloc(loc, &hash_expr_ops, &integer_type,
+			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
+	expr->hash.mod  = mod;
+	expr->hash.seed = seed;
+
+	return expr;
+}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index adcce67..1a1cfbd 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -463,6 +463,34 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle)
+{
+	enum nft_registers sreg, dreg;
+	struct expr *expr, *hexpr;
+	uint32_t mod, seed, len;
+
+	sreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_SREG);
+	hexpr = netlink_get_register(ctx, loc, sreg);
+
+	seed = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_SEED);
+	mod  = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_MODULUS);
+	len = nftnl_expr_get_u32(nle, NFTNL_EXPR_HASH_LEN) * BITS_PER_BYTE;
+
+	if (hexpr->len < len) {
+		hexpr = netlink_parse_concat_expr(ctx, loc, sreg, len);
+		if (hexpr == NULL)
+			return;
+	}
+
+	expr = hash_expr_alloc(loc, mod, seed);
+	expr->hash.expr = hexpr;
+
+	dreg = netlink_parse_register(nle, NFTNL_EXPR_HASH_DREG);
+	netlink_set_register(ctx, dreg, expr);
+}
+
 static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
@@ -1020,6 +1048,7 @@ static const struct {
 	{ .name = "match",	.parse = netlink_parse_match },
 	{ .name = "quota",	.parse = netlink_parse_quota },
 	{ .name = "numgen",	.parse = netlink_parse_numgen },
+	{ .name = "hash",	.parse = netlink_parse_hash },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -1641,6 +1670,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_VERDICT:
 	case EXPR_NUMGEN:
 		break;
+	case EXPR_HASH:
+		expr_postprocess(ctx, &expr->hash.expr);
+		break;
 	case EXPR_CT:
 		ct_expr_update_type(&ctx->pctx, expr);
 		break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 2c6848c..5204154 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -104,6 +104,27 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
+			     const struct expr *expr,
+			     enum nft_registers dreg)
+{
+	enum nft_registers sreg;
+	struct nftnl_expr *nle;
+
+	sreg = get_register(ctx, expr->hash.expr);
+	netlink_gen_expr(ctx, expr->hash.expr, sreg);
+	release_register(ctx, expr->hash.expr);
+
+	nle = alloc_nft_expr("hash");
+	netlink_put_register(nle, NFTNL_EXPR_HASH_SREG, sreg);
+	netlink_put_register(nle, NFTNL_EXPR_HASH_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_LEN,
+			   div_round_up(expr->hash.expr->len, BITS_PER_BYTE));
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_MODULUS, expr->hash.mod);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 				const struct expr *expr,
 				enum nft_registers dreg)
@@ -629,6 +650,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_expr(ctx, expr->key, dreg);
 	case EXPR_NUMGEN:
 		return netlink_gen_numgen(ctx, expr, dreg);
+	case EXPR_HASH:
+		return netlink_gen_hash(ctx, expr, dreg);
 	default:
 		BUG("unknown expression type %s\n", expr->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 23e8b27..dc79465 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -411,6 +411,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token INC			"inc"
 %token MOD			"mod"
 
+%token JHASH			"jhash"
+%token SEED			"seed"
+
 %token POSITION			"position"
 %token COMMENT			"comment"
 
@@ -556,8 +559,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			arp_hdr_expr
 %destructor { expr_free($$); }	arp_hdr_expr
 %type <val>			arp_hdr_field
-%type <expr>			ip_hdr_expr	icmp_hdr_expr		numgen_expr
-%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		numgen_expr
+%type <expr>			ip_hdr_expr	icmp_hdr_expr		numgen_expr	hash_expr
+%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr		numgen_expr	hash_expr
 %type <val>			ip_hdr_field	icmp_hdr_field
 %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
 %destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
@@ -1972,6 +1975,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
 			|	numgen_expr			{ $$ = $1; }
+			|	hash_expr			{ $$ = $1; }
 			|	'('	basic_expr	')'	{ $$ = $2; }
 			;
 
@@ -2469,6 +2473,13 @@ numgen_expr		:	NUMGEN	numgen_type	MOD	NUM
 			}
 			;
 
+hash_expr		:	JHASH	expr	MOD	NUM	SEED	NUM
+			{
+				$$ = hash_expr_alloc(&@$, $4, $6);
+				$$->hash.expr = $2;
+			}
+			;
+
 ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
diff --git a/src/scanner.l b/src/scanner.l
index cff375f..8b5a383 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -471,6 +471,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "inc"			{ return INC; }
 "mod"			{ return MOD; }
 
+"jhash"			{ return JHASH; }
+"seed"			{ return SEED; }
+
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
diff --git a/tests/py/ip/hash.t b/tests/py/ip/hash.t
new file mode 100644
index 0000000..6dfa965
--- /dev/null
+++ b/tests/py/ip/hash.t
@@ -0,0 +1,5 @@
+:pre;type nat hook prerouting priority 0
+*ip;test-ip4;pre
+
+ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef;ok
+dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 };ok
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
new file mode 100644
index 0000000..429e2b7
--- /dev/null
+++ b/tests/py/ip/hash.t.payload
@@ -0,0 +1,17 @@
+# ct mark set jhash ip saddr . ip daddr mod 2 seed 0xdeadbeef
+ip test-ip4 pre 
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 3735928559) % modulus 2]
+  [ ct set mark with reg 1 ]
+
+# dnat to jhash ip saddr mod 2 seed 0xdeadbeef map { 0 : 192.168.20.100, 1 : 192.168.30.100 }
+__map%d test-ip4 b
+__map%d test-ip4 0
+	element 00000000  : 6414a8c0 0 [end]	element 01000000  : 641ea8c0 0 [end]
+ip test-ip4 pre 
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ hash reg 1 = jhash(reg 2, 4, 3735928559) % modulus 2]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+
-- 
2.1.4

