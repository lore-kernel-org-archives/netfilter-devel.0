Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9D2C46CA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 22:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjIRWdX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjIRWdW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 18:33:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC8CF8F
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:33:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] evaluate: update mark datatype compatibility check from maps
Date:   Tue, 19 Sep 2023 00:33:09 +0200
Message-Id: <20230918223309.165687-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrap datatype compatibility check into a helper function and use it for
map evaluation, otherwise the following bogus error message is
displayed:

  Error: datatype mismatch, map expects packet mark, mapping expression has type integer

Add unit tests to improve coverage for this usecase.

Fixes: 5d8e33ddb112 ("evaluate: relax type-checking for integer arguments in mark statements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: unbreak datatype check.

 src/evaluate.c                                | 17 +++++----
 .../maps/dumps/vmap_mark_bitwise_0.nft        | 26 +++++++++++++
 .../shell/testcases/maps/vmap_mark_bitwise_0  | 38 +++++++++++++++++++
 3 files changed, 74 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.nft
 create mode 100755 tests/shell/testcases/maps/vmap_mark_bitwise_0

diff --git a/src/evaluate.c b/src/evaluate.c
index a537dcfd52b3..03586922848a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1882,6 +1882,13 @@ static int mapping_expr_expand(struct eval_ctx *ctx)
 	return 0;
 }
 
+static bool datatype_compatible(const struct datatype *a, const struct datatype *b)
+{
+	return (a->type == TYPE_MARK &&
+		datatype_equal(datatype_basetype(a), datatype_basetype(b))) ||
+		datatype_equal(a, b);
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *map = *expr, *mappings;
@@ -1989,7 +1996,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    expr_name(map->mappings));
 	}
 
-	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype))
+	if (!datatype_compatible(map->mappings->set->key->dtype, map->map->dtype))
 		return expr_binary_error(ctx->msgs, map->mappings, map->map,
 					 "datatype mismatch, map expects %s, "
 					 "mapping expression has type %s",
@@ -2823,11 +2830,7 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 dtype->desc, (*expr)->dtype->desc,
 					 (*expr)->len);
 
-	if ((dtype->type == TYPE_MARK &&
-	     !datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype))) ||
-	    (dtype->type != TYPE_MARK &&
-	     (*expr)->dtype->type != TYPE_INTEGER &&
-	     !datatype_equal((*expr)->dtype, dtype)))
+	if (!datatype_compatible(dtype, (*expr)->dtype))
 		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
@@ -4385,7 +4388,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		    expr_name(map->mappings));
 	}
 
-	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype))
+	if (!datatype_compatible(map->mappings->set->key->dtype, map->map->dtype))
 		return expr_binary_error(ctx->msgs, map->mappings, map->map,
 					 "datatype mismatch, map expects %s, "
 					 "mapping expression has type %s",
diff --git a/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.nft b/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.nft
new file mode 100644
index 000000000000..beb5ffb098f5
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.nft
@@ -0,0 +1,26 @@
+table ip x {
+	counter c_o0_0 {
+		packets 0 bytes 0
+	}
+
+	map sctm_o0 {
+		type mark : verdict
+		elements = { 0x00000000 : jump sctm_o0_0, 0x00000001 : jump sctm_o0_1 }
+	}
+
+	map sctm_o1 {
+		type mark : counter
+		elements = { 0x00000000 : "c_o0_0" }
+	}
+
+	chain sctm_o0_0 {
+	}
+
+	chain sctm_o0_1 {
+	}
+
+	chain SET_ctmark_RPLYroute {
+		meta mark >> 8 & 0xf vmap @sctm_o0
+		counter name meta mark >> 8 & 0xf map @sctm_o1
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_mark_bitwise_0 b/tests/shell/testcases/maps/vmap_mark_bitwise_0
new file mode 100755
index 000000000000..0d933553e6b8
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_mark_bitwise_0
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain sctm_o0_0 {
+	}
+
+	chain sctm_o0_1 {
+	}
+
+	map sctm_o0 {
+		type mark : verdict
+		elements = {
+			0x0 : jump sctm_o0_0,
+			0x1 : jump sctm_o0_1,
+		}
+	}
+
+	counter c_o0_0 {}
+
+	map sctm_o1 {
+		type mark : counter
+		elements = {
+			0x0 : \"c_o0_0\",
+		}
+	}
+
+	chain SET_ctmark_RPLYroute {
+		meta mark >> 8 & 0xf vmap @sctm_o0
+	}
+
+	chain SET_ctmark_RPLYroute {
+		counter name meta mark >> 8 & 0xf map @sctm_o1
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

