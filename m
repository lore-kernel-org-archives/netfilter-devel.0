Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9173EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 16:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiCUQQG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350998AbiCUQQB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 12:16:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE12187B8B
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2022 09:14:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nWKfe-0006No-4q; Mon, 21 Mar 2022 17:14:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: copy field_count for anonymous object maps as well
Date:   Mon, 21 Mar 2022 17:14:07 +0100
Message-Id: <20220321161407.17690-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

test fails without this:
W: [FAILED]     tests/shell/testcases/maps/anon_objmap_concat: got 134
BUG: invalid range expression type concat
nft: expression.c:1452: range_expr_value_low: Assertion `0' failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 28 +++++++++++--------
 tests/shell/testcases/maps/anon_objmap_concat |  6 ++++
 .../maps/dumps/anon_objmap_concat.nft         | 16 +++++++++++
 3 files changed, 39 insertions(+), 11 deletions(-)
 create mode 100755 tests/shell/testcases/maps/anon_objmap_concat
 create mode 100644 tests/shell/testcases/maps/dumps/anon_objmap_concat.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 07a4b0ad19b0..04d42b800103 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1513,6 +1513,20 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 }
 
 static int binop_transfer(struct eval_ctx *ctx, struct expr **expr);
+
+static void map_set_concat_info(struct expr *map)
+{
+	map->mappings->set->flags |= map->mappings->set->init->set_flags;
+
+	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
+	    map->map->etype == EXPR_CONCAT) {
+		memcpy(&map->mappings->set->desc.field_len, &map->map->field_len,
+		       sizeof(map->mappings->set->desc.field_len));
+		map->mappings->set->desc.field_count = map->map->field_count;
+		map->mappings->flags |= NFT_SET_CONCAT;
+	}
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr_ctx ectx = ctx->ectx;
@@ -1580,15 +1594,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		ctx->set->key->len = ctx->ectx.len;
 		ctx->set = NULL;
 		map = *expr;
-		map->mappings->set->flags |= map->mappings->set->init->set_flags;
-
-		if (map->mappings->set->flags & NFT_SET_INTERVAL &&
-		    map->map->etype == EXPR_CONCAT) {
-			memcpy(&map->mappings->set->desc.field_len, &map->map->field_len,
-			       sizeof(map->mappings->set->desc.field_len));
-			map->mappings->set->desc.field_count = map->map->field_count;
-			map->mappings->flags |= NFT_SET_CONCAT;
-		}
+
+		map_set_concat_info(map);
 		break;
 	case EXPR_SYMBOL:
 		if (expr_evaluate(ctx, &map->mappings) < 0)
@@ -3751,8 +3758,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 			return -1;
 		ctx->set = NULL;
 
-		map->mappings->set->flags |=
-			map->mappings->set->init->set_flags;
+		map_set_concat_info(map);
 		/* fall through */
 	case EXPR_SYMBOL:
 		if (expr_evaluate(ctx, &map->mappings) < 0)
diff --git a/tests/shell/testcases/maps/anon_objmap_concat b/tests/shell/testcases/maps/anon_objmap_concat
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/maps/anon_objmap_concat
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft b/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft
new file mode 100644
index 000000000000..23aca0a2d988
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/anon_objmap_concat.nft
@@ -0,0 +1,16 @@
+table inet filter {
+	ct helper sip-5060u {
+		type "sip" protocol udp
+		l3proto ip
+	}
+
+	ct helper sip-5060t {
+		type "sip" protocol tcp
+		l3proto ip
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		ct helper set ip protocol . th dport map { udp . 10000-20000 : "sip-5060u", tcp . 10000-20000 : "sip-5060t" }
+	}
+}
-- 
2.34.1

