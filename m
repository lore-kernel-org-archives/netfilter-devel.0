From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 2/2] evaluate: Update cache on flush ruleset
Date: Thu,  1 Dec 2016 11:50:17 +0100
Message-ID: <8cb247352dd4b9eaf587c1ff89f618061042edff.1480587885.git.anatole@rezel.net>
References: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:58546 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756959AbcLAKvM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 05:51:12 -0500
In-Reply-To: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
In-Reply-To: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
References: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After a flush, the cache should be empty, otherwise the cache and the expected
state are desynced, causing unwarranted errors. See
tests/shell/testcases/cache/0002_interval_0.

`flush table` and `flush chain` don't empty sets or destroy chains, so the cache
does not need an update in those cases, since only chain names and set contents
are held in cache for commands other than "list"

Reported-by: Leon Merten Lohse <leon@green-side.de>
Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 src/evaluate.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c841aaf..c75c140 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2854,6 +2854,29 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	int ret;
+	ret = cache_update(cmd->op, ctx->msgs);
+	if (ret < 0)
+		return ret;
+	switch (cmd->obj) {
+	case CMD_OBJ_RULESET:
+		cache_flush();
+		break;
+	case CMD_OBJ_TABLE:
+		/* Flushing a table does not empty the sets in the table nor remove
+		 * any chains.
+		 */
+	case CMD_OBJ_CHAIN:
+		/* Chains don't hold sets */
+		break;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+	return 0;
+}
+
 static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
@@ -3021,7 +3044,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_LIST:
 		return cmd_evaluate_list(ctx, cmd);
 	case CMD_FLUSH:
-		return 0;
+		return cmd_evaluate_flush(ctx, cmd);
 	case CMD_RENAME:
 		return cmd_evaluate_rename(ctx, cmd);
 	case CMD_EXPORT:
-- 
2.11.0

