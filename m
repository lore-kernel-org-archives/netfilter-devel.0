Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A221CD37BC
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Sep 2023 14:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbjIPOjL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Sep 2023 10:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238134AbjIPOjK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Sep 2023 10:39:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F348114
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Sep 2023 07:39:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: expand sets and maps before evaluation
Date:   Sat, 16 Sep 2023 16:35:49 +0200
Message-Id: <20230916143549.57646-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

3975430b12d9 ("src: expand table command before evaluation") moved
ruleset expansion before evaluation, except for sets and maps. For
sets and maps there is still a post_expand() phase.

This patch moves sets and map expansion to allocate an independent
CMD_OBJ_SETELEMS command to add elements to named set and maps which is
evaluated, this consolidates the ruleset expansion to happen always
before the evaluation step for all objects, except for anonymous sets
and maps.

This approach avoids an interference with the set interval code which
detects overlaps and merges of adjacents ranges. This set interval
routine uses set->init to maintain a cache of existing elements. Then,
the post_expand() phase incorrectly expands set->init cache and it
triggers a bogus ENOENT errors due to incorrect bytecode (placing
element addition before set creation) in combination with user declared
sets using the flat syntax notation.

Since the evaluation step (coming after the expansion) creates
implicit/anonymous sets and maps, those are not expanded anymore. These
anonymous sets still need to be evaluated from set_evaluate() path and
the netlink bytecode generation path, ie. do_add_set(), needs to deal
with anonymous sets.

Fixes: 3975430b12d9 ("src: expand table command before evaluation")
Reported-by: Jann Haber <jannh@selfnet.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c                                     | 15 ------
 src/evaluate.c                                | 53 ++++++++++---------
 src/libnftables.c                             |  7 ---
 src/rule.c                                    |  8 ++-
 .../testcases/sets/0073flat_interval_set      | 11 ++++
 .../testcases/sets/0074nested_interval_set    |  6 +++
 .../sets/dumps/0073flat_interval_set.nft      | 11 ++++
 .../sets/dumps/0074nested_interval_set.nft    | 11 ++++
 8 files changed, 74 insertions(+), 48 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0073flat_interval_set
 create mode 100755 tests/shell/testcases/sets/0074nested_interval_set
 create mode 100644 tests/shell/testcases/sets/dumps/0073flat_interval_set.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0074nested_interval_set.nft

diff --git a/src/cmd.c b/src/cmd.c
index 5e90fdcbd99a..358dd1f9364e 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -402,21 +402,6 @@ void nft_cmd_expand(struct cmd *cmd)
 		nft_cmd_expand_chain(chain, &new_cmds);
 		list_splice(&new_cmds, &cmd->list);
 		break;
-	default:
-		break;
-	}
-}
-
-void nft_cmd_post_expand(struct cmd *cmd)
-{
-	struct list_head new_cmds;
-	struct set *set;
-	struct cmd *new;
-	struct handle h;
-
-	init_list_head(&new_cmds);
-
-	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
diff --git a/src/evaluate.c b/src/evaluate.c
index 90e7bff62cce..2f00ab259c66 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4595,6 +4595,29 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
+{
+	ctx->set = set;
+	if (set->init != NULL) {
+		__expr_set_context(&ctx->ectx, set->key->dtype,
+				   set->key->byteorder, set->key->len, 0);
+		if (expr_evaluate(ctx, &set->init) < 0)
+			return -1;
+		if (set->init->etype != EXPR_SET)
+			return expr_error(ctx->msgs, set->init, "Set %s: Unexpected initial type %s, missing { }?",
+					  set->handle.set.name, expr_name(set->init));
+	}
+
+	if (set_is_interval(ctx->set->flags) &&
+	    !(ctx->set->flags & NFT_SET_CONCAT) &&
+	    interval_set_eval(ctx, ctx->set, set->init) < 0)
+		return -1;
+
+	ctx->set = NULL;
+
+	return 0;
+}
+
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	struct set *existing_set = NULL;
@@ -4683,33 +4706,11 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (num_stmts > 1)
 		set->flags |= NFT_SET_EXPR;
 
-	if (set_is_anonymous(set->flags)) {
-		if (set_is_interval(set->init->set_flags) &&
-		    !(set->init->set_flags & NFT_SET_CONCAT) &&
-		    interval_set_eval(ctx, set, set->init) < 0)
-			return -1;
-
-		return 0;
-	}
-
-	set->existing_set = existing_set;
-	ctx->set = set;
-	if (set->init != NULL) {
-		__expr_set_context(&ctx->ectx, set->key->dtype,
-				   set->key->byteorder, set->key->len, 0);
-		if (expr_evaluate(ctx, &set->init) < 0)
-			return -1;
-		if (set->init->etype != EXPR_SET)
-			return expr_error(ctx->msgs, set->init, "Set %s: Unexpected initial type %s, missing { }?",
-					  set->handle.set.name, expr_name(set->init));
-	}
-
-	if (set_is_interval(ctx->set->flags) &&
-	    !(ctx->set->flags & NFT_SET_CONCAT) &&
-	    interval_set_eval(ctx, ctx->set, set->init) < 0)
+	if (set_is_anonymous(set->flags) &&
+	    elems_evaluate(ctx, set) < 0)
 		return -1;
 
-	ctx->set = NULL;
+	set->existing_set = existing_set;
 
 	return 0;
 }
@@ -5182,6 +5183,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
+	case CMD_OBJ_SETELEMS:
+		return elems_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule, cmd->op);
diff --git a/src/libnftables.c b/src/libnftables.c
index c5f5729409d1..7d36577dbf5f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -562,13 +562,6 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (err < 0 || nft->state->nerrs)
 		return -1;
 
-	list_for_each_entry(cmd, cmds, list) {
-		if (cmd->op != CMD_ADD)
-			continue;
-
-		nft_cmd_post_expand(cmd);
-	}
-
 	return 0;
 }
 
diff --git a/src/rule.c b/src/rule.c
index 1e9e6c1a92c2..87d51c4723b8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1458,7 +1458,13 @@ static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
 			return -1;
 	}
 
-	return mnl_nft_set_add(ctx, cmd, flags);
+	if (mnl_nft_set_add(ctx, cmd, flags) < 0)
+		return -1;
+
+	if (set_is_anonymous(set->flags) && set->init)
+		return __do_add_elements(ctx, cmd, set, set->init, flags);
+
+	return 0;
 }
 
 static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
diff --git a/tests/shell/testcases/sets/0073flat_interval_set b/tests/shell/testcases/sets/0073flat_interval_set
new file mode 100755
index 000000000000..0630595f1599
--- /dev/null
+++ b/tests/shell/testcases/sets/0073flat_interval_set
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="flush ruleset
+add table inet filter
+add map inet filter testmap { type ipv4_addr : counter; flags interval;}
+add counter inet filter TEST
+add element inet filter testmap { 192.168.0.0/24 : \"TEST\" }"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/0074nested_interval_set b/tests/shell/testcases/sets/0074nested_interval_set
new file mode 100755
index 000000000000..e7f65fc56eef
--- /dev/null
+++ b/tests/shell/testcases/sets/0074nested_interval_set
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+$NFT -f "$dumpfile"
diff --git a/tests/shell/testcases/sets/dumps/0073flat_interval_set.nft b/tests/shell/testcases/sets/dumps/0073flat_interval_set.nft
new file mode 100644
index 000000000000..20f537411c68
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0073flat_interval_set.nft
@@ -0,0 +1,11 @@
+table inet filter {
+	counter TEST {
+		packets 0 bytes 0
+	}
+
+	map testmap {
+		type ipv4_addr : counter
+		flags interval
+		elements = { 192.168.0.0/24 : "TEST" }
+	}
+}
diff --git a/tests/shell/testcases/sets/dumps/0074nested_interval_set.nft b/tests/shell/testcases/sets/dumps/0074nested_interval_set.nft
new file mode 100644
index 000000000000..20f537411c68
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0074nested_interval_set.nft
@@ -0,0 +1,11 @@
+table inet filter {
+	counter TEST {
+		packets 0 bytes 0
+	}
+
+	map testmap {
+		type ipv4_addr : counter
+		flags interval
+		elements = { 192.168.0.0/24 : "TEST" }
+	}
+}
-- 
2.30.2

