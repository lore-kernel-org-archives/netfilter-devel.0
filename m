Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E01EB64DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjFSUn2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFSUnY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1460A91
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLiZ-0003r2-Lp; Mon, 19 Jun 2023 22:43:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] evaluate: do not abort when prefix map has non-map element
Date:   Mon, 19 Jun 2023 22:43:02 +0200
Message-Id: <20230619204306.11785-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230619204306.11785-1-fw@strlen.de>
References: <20230619204306.11785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before:
nft: evaluate.c:1849: __mapping_expr_expand: Assertion `i->etype == EXPR_MAPPING' failed.

after:
Error: expected mapping, not set element
   snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24, 10.141.12.1 }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                  | 17 +++++++++++++----
 tests/shell/testcases/bogons/assert_failures    | 12 ++++++++++++
 .../nat_prefix_map_with_set_element_assert      |  7 +++++++
 3 files changed, 32 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/bogons/assert_failures
 create mode 100644 tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 00bb8988bd4c..efab28952e32 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1869,12 +1869,21 @@ static void __mapping_expr_expand(struct expr *i)
 	}
 }
 
-static void mapping_expr_expand(struct expr *init)
+static int mapping_expr_expand(struct eval_ctx *ctx)
 {
 	struct expr *i;
 
-	list_for_each_entry(i, &init->expressions, list)
+	if (!set_is_anonymous(ctx->set->flags))
+		return 0;
+
+	list_for_each_entry(i, &ctx->set->init->expressions, list) {
+		if (i->etype != EXPR_MAPPING)
+			return expr_error(ctx->msgs, i,
+					  "expected mapping, not %s", expr_name(i));
 		__mapping_expr_expand(i);
+	}
+
+	return 0;
 }
 
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
@@ -1955,8 +1964,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
 			ctx->set->data->len *= 2;
 
-			if (set_is_anonymous(ctx->set->flags))
-				mapping_expr_expand(ctx->set->init);
+			if (mapping_expr_expand(ctx))
+				return -1;
 		}
 
 		ctx->set->key->len = ctx->ectx.len;
diff --git a/tests/shell/testcases/bogons/assert_failures b/tests/shell/testcases/bogons/assert_failures
new file mode 100755
index 000000000000..79099427c98a
--- /dev/null
+++ b/tests/shell/testcases/bogons/assert_failures
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+dir=$(dirname $0)/nft-f/
+
+for f in $dir/*; do
+	$NFT --check -f "$f"
+
+	if [ $? -ne 1 ]; then
+		echo "Bogus input file $f did not cause expected error code" 1>&2
+		exit 111
+	fi
+done
diff --git a/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert b/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert
new file mode 100644
index 000000000000..18c7edd14c5d
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert
@@ -0,0 +1,7 @@
+table ip x {
+	chain y {
+	type nat hook postrouting priority srcnat; policy accept;
+		snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24, 10.141.12.1 }
+	}
+}
+
-- 
2.39.3

