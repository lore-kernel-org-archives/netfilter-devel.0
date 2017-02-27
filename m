From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/7] evaluate: refactor CMD_OBJ_QUOTA/COUNTER handling
Date: Mon, 27 Feb 2017 16:02:53 +0100
Message-ID: <20170227150255.12624-6-fw@strlen.de>
References: <20170227150255.12624-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56062 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751518AbdB0PfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:35:13 -0500
In-Reply-To: <20170227150255.12624-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... to make adding CMD_OBJ_CT_HELPER support easier.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 87da2fd83597..4ac55e177d54 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2916,12 +2916,29 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
+				 uint32_t obj_type)
+{
+	const struct table *table;
+
+	if (obj_type == NFT_OBJECT_UNSPEC)
+		obj_type = NFT_OBJECT_COUNTER;
+
+	table = table_lookup(&cmd->handle);
+	if (table == NULL)
+		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+				 cmd->handle.table);
+	if (obj_lookup(table, cmd->handle.obj, obj_type) == NULL)
+		return cmd_error(ctx, "Could not process rule: Object '%s' does not exist",
+					 cmd->handle.obj);
+	return 0;
+}
+
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
 	int ret;
-	uint32_t obj_type = NFT_OBJECT_UNSPEC;
 
 	ret = cache_update(cmd->op, ctx->msgs);
 	if (ret < 0)
@@ -2977,18 +2994,9 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.chain);
 		return 0;
 	case CMD_OBJ_QUOTA:
-		obj_type = NFT_OBJECT_QUOTA;
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
 	case CMD_OBJ_COUNTER:
-		if (obj_type == NFT_OBJECT_UNSPEC)
-			obj_type = NFT_OBJECT_COUNTER;
-		table = table_lookup(&cmd->handle);
-		if (table == NULL)
-			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
-					 cmd->handle.table);
-		if (obj_lookup(table, cmd->handle.obj, obj_type) == NULL)
-			return cmd_error(ctx, "Could not process rule: Object '%s' does not exist",
-					 cmd->handle.obj);
-		return 0;
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 		if (cmd->handle.table == NULL)
-- 
2.10.2

