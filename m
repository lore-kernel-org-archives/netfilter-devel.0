From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 2/6] src: Allow list single stateful object
Date: Thu, 26 Jan 2017 15:12:54 -0200
Message-ID: <20170126171254.GA7913@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34736 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdAZRNB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:13:01 -0500
Received: by mail-qt0-f196.google.com with SMTP id w20so6483435qtb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:13:01 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the stateful objects can only be listed in groups. With this
patch listing a single object is allowed:

$ nft list counter filter https-traffic
table ip filter {
	counter https-traffic {
		packets 4014 bytes 228948
	}
}

$ nft list quota filter https-quota
table ip filter {
	quota https-quota {
		25 mbytes used 278 kbytes
	}
}

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: No changes.
 v3: Fixed a bug, which counters with the same name in different tables
 were listed. Also, removed some code duplication in evaluate.c.

 src/evaluate.c | 14 ++++++++++++++
 src/rule.c     | 12 +++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1d2f925..dab7cfc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2882,6 +2882,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 	int ret;
+	uint32_t obj_type = NFT_OBJECT_UNSPEC;
 
 	ret = cache_update(cmd->op, ctx->msgs);
 	if (ret < 0)
@@ -2936,6 +2937,19 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
 					 cmd->handle.chain);
 		return 0;
+	case CMD_OBJ_QUOTA:
+		obj_type = NFT_OBJECT_QUOTA;
+	case CMD_OBJ_COUNTER:
+		if (obj_type == NFT_OBJECT_UNSPEC)
+			obj_type = NFT_OBJECT_COUNTER;
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		if (obj_lookup(table, cmd->handle.obj, obj_type) == NULL)
+			return cmd_error(ctx, "Could not process rule: Object '%s' does not exist",
+					 cmd->handle.obj);
+		return 0;
 	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
diff --git a/src/rule.c b/src/rule.c
index a9f3a49..0d58073 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1276,8 +1276,16 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		       family2str(table->handle.family),
 		       table->handle.table);
 
+		if (cmd->handle.table != NULL &&
+		    strcmp(cmd->handle.table, table->handle.table)) {
+			printf("}\n");
+			continue;
+		}
+
 		list_for_each_entry(obj, &table->objs, list) {
-			if (obj->type != type)
+			if (obj->type != type ||
+			    (cmd->handle.obj != NULL &&
+			     strcmp(cmd->handle.obj, obj->handle.obj)))
 				continue;
 
 			obj_print_declaration(obj, &opts);
@@ -1420,8 +1428,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_MAP:
 		return do_list_set(ctx, cmd, table);
+	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_COUNTERS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
+	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_QUOTAS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
 	default:
-- 
2.7.4

