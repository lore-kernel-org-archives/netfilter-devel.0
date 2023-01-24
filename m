Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EFCC25B4E
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 13:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbjAXNxJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 08:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbjAXNwz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 08:52:55 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C58F234C4
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2023 05:50:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pKJg2-0007eP-4g; Tue, 24 Jan 2023 14:49:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>,
        Eric Garver <eric@garver.life>
Subject: [PATCH nft] evaluate: set eval ctx for add/update statements with integer constants
Date:   Tue, 24 Jan 2023 14:49:23 +0100
Message-Id: <20230124134923.12344-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric reports that nft asserts when using integer basetype constants with
'typeof' sets.  Example:
table netdev t {
	set s {
		typeof ether saddr . vlan id
		flags dynamic,timeout
	}

	chain c { }
}

loads fine.  But adding a rule with add/update statement fails:
nft 'add rule netdev t c set update ether saddr . 0 @s'
nft: netlink_linearize.c:867: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.

When the 'ether saddr . 0' concat expression is processed, there is
no set definition available anymore to deduce the required size of the
integer constant.

nft eval step then derives the required length using the data types.
'0' has integer basetype, so the deduced length is 0.

The assertion triggers because serialization step finds that it
needs one more register.

2 are needed to store the ethernet address, another register is
needed for the vlan id.

Update eval step to make the expression context store the set key
information when processing the preceeding set reference, then
let stmt_evaluate_set() preserve the  existing context instead of
zeroing it again via stmt_evaluate_arg().

This makes concat expression evaluation compute the total size
needed based on the sets key definition.

Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 32 +++++++++++++++++--
 .../maps/dumps/typeof_maps_concat.nft         | 11 +++++++
 tests/shell/testcases/maps/typeof_maps_concat |  6 ++++
 .../sets/dumps/typeof_sets_concat.nft         | 12 +++++++
 tests/shell/testcases/sets/typeof_sets_concat |  6 ++++
 5 files changed, 65 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_concat
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_concat

diff --git a/src/evaluate.c b/src/evaluate.c
index 61ebcbfc81cf..2182d8f1d732 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1690,6 +1690,14 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 	return ret;
 }
 
+static void expr_evaluate_set_ref(struct eval_ctx *ctx, struct expr *expr)
+{
+	struct set *set = expr->set;
+
+	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
+	ctx->ectx.key = set->key;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
@@ -2557,6 +2565,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_VARIABLE:
 		return expr_evaluate_variable(ctx, expr);
 	case EXPR_SET_REF:
+		expr_evaluate_set_ref(ctx, *expr);
 		return 0;
 	case EXPR_VALUE:
 		return expr_evaluate_value(ctx, expr);
@@ -2719,6 +2728,25 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 	return __stmt_evaluate_arg(ctx, stmt, dtype, len, byteorder, expr);
 }
 
+/* like stmt_evaluate_arg, but keep existing context created
+ * by previous expr_evaluate().
+ *
+ * This is needed for add/update statements:
+ * ctx->ectx.key has the set key, which may be needed for 'typeof'
+ * sets: the 'add/update' expression might contain integer data types.
+ *
+ * Without the key we cannot derive the element size.
+ */
+static int stmt_evaluate_key(struct eval_ctx *ctx, struct stmt *stmt,
+			     const struct datatype *dtype, unsigned int len,
+			     enum byteorder byteorder, struct expr **expr)
+{
+	if (expr_evaluate(ctx, expr) < 0)
+		return -1;
+
+	return __stmt_evaluate_arg(ctx, stmt, dtype, len, byteorder, expr);
+}
+
 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, 0, &stmt->expr) < 0)
@@ -3952,7 +3980,7 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->set.set,
 				  "Expression does not refer to a set");
 
-	if (stmt_evaluate_arg(ctx, stmt,
+	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->set.set->set->key->dtype,
 			      stmt->set.set->set->key->len,
 			      stmt->set.set->set->key->byteorder,
@@ -3995,7 +4023,7 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->map.set,
 				  "Expression does not refer to a set");
 
-	if (stmt_evaluate_arg(ctx, stmt,
+	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->map.set->set->key->dtype,
 			      stmt->map.set->set->key->len,
 			      stmt->map.set->set->key->byteorder,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft b/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
new file mode 100644
index 000000000000..1ca98d811f7d
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_concat.nft
@@ -0,0 +1,11 @@
+table netdev t {
+	map m {
+		typeof ether saddr . vlan id : meta mark
+		size 1234
+		flags dynamic,timeout
+	}
+
+	chain c {
+		ether type != 8021q update @m { ether daddr . 123 timeout 1m : 0x0000002a } counter packets 0 bytes 0 return
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_concat b/tests/shell/testcases/maps/typeof_maps_concat
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_concat
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
new file mode 100644
index 000000000000..dbaf7cdc2d7d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
@@ -0,0 +1,12 @@
+table netdev t {
+	set s {
+		typeof ether saddr . vlan id
+		size 2048
+		flags dynamic,timeout
+	}
+
+	chain c {
+		ether type != 8021q add @s { ether saddr . 0 timeout 5s } counter packets 0 bytes 0 return
+		ether type != 8021q update @s { ether daddr . 123 timeout 1m } counter packets 0 bytes 0 return
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_concat b/tests/shell/testcases/sets/typeof_sets_concat
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_concat
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
-- 
2.39.1

