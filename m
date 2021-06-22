Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEBFC49EA5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 19:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D946137D
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 19:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhFVToN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 15:44:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59002 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhFVToN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 15:44:13 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 42C916423C
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jun 2021 21:36:58 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: fix maps with key and data concatenations
Date:   Tue, 22 Jun 2021 21:38:18 +0200
Message-Id: <20210622193818.138030-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

expr_evaluate_concat() is overloaded, it deals with two cases:

 #1 set key and data definitions, this case uses the special
    dynamically created concatenation datatype which is taken
    from the context.
 #2 set elements, this case iterates over the set key and data
    expressions that are components of the concatenation tuple,
    to fetch the corresponding datatype.

Add a new function to deal with case #1 specifically.

This patch is implicitly fixing up map that include arbitrary
concatenations. This is failing with a spurious error report such as:

 # cat bug.nft
 table x {
        map test {
                type ipv4_addr . inet_proto . inet_service : ipv4_addr . inet_service
        }
 }

 # nft -f bug.nft
 bug.nft:3:48-71: Error: datatype mismatch, expected concatenation of (IPv4 address, Internet protocol, internet network service), expression has type concatenation of (IPv4 address, internet network service)
                type ipv4_addr . inet_proto . inet_service : ipv4_addr . inet_service
                                                             ^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 50 ++++++++++++++++---
 tests/shell/testcases/maps/0010concat_map_0   | 19 +++++++
 .../testcases/maps/dumps/0010concat_map_0.nft | 11 ++++
 3 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0010concat_map_0
 create mode 100644 tests/shell/testcases/maps/dumps/0010concat_map_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 35ef8a376170..ffb6b3a6af1a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1241,8 +1241,7 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return err;
 }
 
-static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
-				bool eval)
+static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
 	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
@@ -1271,7 +1270,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
 			tmp = concat_subtype_lookup(type, --off);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
-		if (eval && list_member_evaluate(ctx, &i) < 0)
+		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 		flags &= i->flags;
 
@@ -2237,7 +2236,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_BINOP:
 		return expr_evaluate_binop(ctx, expr);
 	case EXPR_CONCAT:
-		return expr_evaluate_concat(ctx, expr, true);
+		return expr_evaluate_concat(ctx, expr);
 	case EXPR_LIST:
 		return expr_evaluate_list(ctx, expr);
 	case EXPR_SET:
@@ -3792,6 +3791,45 @@ static int set_key_data_error(struct eval_ctx *ctx, const struct set *set,
 			 dtype->name, name, hint);
 }
 
+static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
+{
+	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+	struct expr *i, *next;
+	uint32_t ntype = 0;
+
+	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+		unsigned dsize_bytes;
+
+		if (i->etype == EXPR_CT &&
+		    (i->ct.key == NFT_CT_SRC ||
+		     i->ct.key == NFT_CT_DST))
+			return expr_error(ctx->msgs, i,
+					  "specify either ip or ip6 for address matching");
+
+		if (i->dtype->size == 0)
+			return expr_binary_error(ctx->msgs, i, *expr,
+						 "can not use variable sized "
+						 "data types (%s) in concat "
+						 "expressions",
+						 i->dtype->name);
+
+		flags &= i->flags;
+
+		ntype = concat_subtype_add(ntype, i->dtype->type);
+
+		dsize_bytes = div_round_up(i->dtype->size, BITS_PER_BYTE);
+		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
+	}
+
+	(*expr)->flags |= flags;
+	datatype_set(*expr, concat_type_alloc(ntype));
+	(*expr)->len   = (*expr)->dtype->size;
+
+	expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->len);
+
+	return 0;
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	unsigned int num_stmts = 0;
@@ -3821,7 +3859,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	if (set->key->len == 0) {
 		if (set->key->etype == EXPR_CONCAT &&
-		    expr_evaluate_concat(ctx, &set->key, false) < 0)
+		    set_expr_evaluate_concat(ctx, &set->key) < 0)
 			return -1;
 
 		if (set->key->len == 0)
@@ -3845,7 +3883,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			set->data->len *= 2;
 
 		if (set->data->etype == EXPR_CONCAT &&
-		    expr_evaluate_concat(ctx, &set->data, false) < 0)
+		    set_expr_evaluate_concat(ctx, &set->data) < 0)
 			return -1;
 
 		if (set->data->len == 0 && set->data->dtype->type != TYPE_VERDICT)
diff --git a/tests/shell/testcases/maps/0010concat_map_0 b/tests/shell/testcases/maps/0010concat_map_0
new file mode 100755
index 000000000000..4848d97212fd
--- /dev/null
+++ b/tests/shell/testcases/maps/0010concat_map_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table inet x {
+	map z {
+		type ipv4_addr . inet_proto . inet_service : ipv4_addr . inet_service
+		elements = {
+			1.1.1.1 . tcp . 20 : 2.2.2.2 . 30
+		}
+	}
+
+	chain y {
+		type nat hook prerouting priority dstnat;
+		dnat ip addr . port to ip saddr . ip protocol . tcp dport map @z
+	}
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
new file mode 100644
index 000000000000..328c653c9913
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
@@ -0,0 +1,11 @@
+table inet x {
+	map z {
+		type ipv4_addr . inet_proto . inet_service : ipv4_addr . inet_service
+		elements = { 1.1.1.1 . tcp . 20 : 2.2.2.2 . 30 }
+	}
+
+	chain y {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta nfproto ipv4 dnat ip addr . port to ip saddr . ip protocol . tcp dport map @z
+	}
+}
-- 
2.30.2

