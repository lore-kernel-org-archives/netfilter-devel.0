Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7384CC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 00:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840F64F64
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 00:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhBDAAy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:00:54 -0500
Received: from correo.us.es ([193.147.175.20]:59258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhBDAAy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 19:00:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5822BDFE45
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Feb 2021 01:00:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43E15DA730
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Feb 2021 01:00:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38E06DA722; Thu,  4 Feb 2021 01:00:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8C85DA730
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Feb 2021 01:00:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Feb 2021 01:00:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C4550426CC84
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Feb 2021 01:00:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: add negation match on singleton bitmask value
Date:   Thu,  4 Feb 2021 01:00:06 +0100
Message-Id: <20210204000006.21912-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch provides a shortcut for:

	ct status and dnat == 0

which allows to check for the packet whose dnat bit is unset:

  # nft add rule x y ct status ! dnat counter packets

This operation is only available for expression with a bitmask basetype, eg.

  # nft describe ct status
  ct expression, datatype ct_status (conntrack status) (basetype bitmask, integer), 32 bits

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add a tests/py unit.

 include/expression.h      |  1 +
 src/evaluate.c            |  8 ++++++++
 src/expression.c          |  1 +
 src/netlink_delinearize.c | 14 +++++++++++---
 src/netlink_linearize.c   |  9 +++++++--
 src/parser_bison.y        |  1 +
 tests/py/any/ct.t         |  1 +
 tests/py/any/ct.t.payload |  6 ++++++
 8 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 718dac5a122d..2d07f3d96beb 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -93,6 +93,7 @@ enum ops {
 	OP_GT,
 	OP_LTE,
 	OP_GTE,
+	OP_NEG,
 	__OP_MAX
 };
 #define OP_MAX		(__OP_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 1d5db4dacd82..2f6c9d68f0d9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1956,6 +1956,14 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
 		/* fall through */
 	case OP_NEQ:
+	case OP_NEG:
+		if (rel->op == OP_NEG &&
+		    (right->etype != EXPR_VALUE ||
+		     right->dtype->basetype == NULL ||
+		     right->dtype->basetype->type != TYPE_BITMASK))
+			return expr_binary_error(ctx->msgs, left, right,
+						 "negation can only be used with singleton bitmask values");
+
 		switch (right->etype) {
 		case EXPR_RANGE:
 			if (byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
diff --git a/src/expression.c b/src/expression.c
index 58d73e9509b0..a90a89ca9f74 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -560,6 +560,7 @@ const char *expr_op_symbols[] = {
 	[OP_GT]		= ">",
 	[OP_LTE]	= "<=",
 	[OP_GTE]	= ">=",
+	[OP_NEG]	= "!",
 };
 
 static void unary_expr_print(const struct expr *expr, struct output_ctx *octx)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 04560b976974..7cd7d403a038 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2167,7 +2167,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 {
 	struct expr *binop = expr->left, *value = expr->right;
 
-	if (binop->op == OP_AND && expr->op == OP_NEQ &&
+	if (binop->op == OP_AND && (expr->op == OP_NEQ || expr->op == OP_EQ) &&
 	    value->dtype->basetype &&
 	    value->dtype->basetype->type == TYPE_BITMASK &&
 	    !mpz_cmp_ui(value->value, 0)) {
@@ -2180,8 +2180,16 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 
 		expr->left  = expr_get(binop->left);
 		expr->right = binop_tree_to_list(NULL, binop->right);
-		expr->op    = OP_IMPLICIT;
-
+		switch (expr->op) {
+		case OP_NEQ:
+			expr->op = OP_IMPLICIT;
+			break;
+		case OP_EQ:
+			expr->op = OP_NEG;
+			break;
+		default:
+			BUG("unknown operation type %d\n", expr->op);
+		}
 		expr_free(binop);
 	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
 		   binop->op == OP_AND && expr->right->etype == EXPR_VALUE &&
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index f1b3ff6940ea..21bc492e85f4 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -490,7 +490,11 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("cmp");
 	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
+	if (expr->op == OP_NEG)
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
+	else
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
+
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 
@@ -518,6 +522,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	case OP_GT:
 	case OP_LTE:
 	case OP_GTE:
+	case OP_NEG:
 		break;
 	default:
 		BUG("invalid relational operation %u\n", expr->op);
@@ -547,7 +552,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 		}
 		break;
 	default:
-		if (expr->op == OP_IMPLICIT &&
+		if ((expr->op == OP_IMPLICIT || expr->op == OP_NEG) &&
 		    expr->right->dtype->basetype != NULL &&
 		    expr->right->dtype->basetype->type == TYPE_BITMASK)
 			return netlink_gen_flagcmp(ctx, expr, dreg);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 519e8efe5ab7..11e899ff2f20 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4639,6 +4639,7 @@ relational_op		:	EQ		{ $$ = OP_EQ; }
 			|	GT		{ $$ = OP_GT; }
 			|	GTE		{ $$ = OP_GTE; }
 			|	LTE		{ $$ = OP_LTE; }
+			|	NOT		{ $$ = OP_NEG; }
 			;
 
 verdict_expr		:	ACCEPT
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index cc09aebcbc44..07583fdf33f8 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -29,6 +29,7 @@ ct status {expected, seen-reply, assured, confirmed, dying};ok
 ct status expected,seen-reply,assured,confirmed,snat,dnat,dying;ok
 ct status snat;ok
 ct status dnat;ok
+ct status ! dnat;ok
 ct status xxx;fail
 
 ct mark 0;ok;ct mark 0x00000000
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 51a825034901..2c9648f5b825 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -511,3 +511,9 @@ ip test-ip4 output
   [ ct load unknown => reg 1 ]
   [ cmp eq reg 1 0x39300000 ]
 
+# ct status ! dnat
+ip6
+  [ ct load status => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
-- 
2.20.1

