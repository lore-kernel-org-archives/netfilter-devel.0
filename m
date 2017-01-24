From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v2 2/2] src: Allow list single stateful object
Date: Tue, 24 Jan 2017 11:42:26 -0200
Message-ID: <20170124134226.GA1740@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34106 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdAXNme (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 08:42:34 -0500
Received: by mail-qt0-f194.google.com with SMTP id a29so25242574qtb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 05:42:33 -0800 (PST)
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

 v2: No change on this one.

 src/evaluate.c | 18 ++++++++++++++++++
 src/rule.c     |  6 +++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9a9927b..3cf5075 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2936,6 +2936,24 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
 					 cmd->handle.chain);
 		return 0;
+	case CMD_OBJ_COUNTER:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		if (obj_lookup(table, cmd->handle.obj, NFT_OBJECT_COUNTER) == NULL)
+			return cmd_error(ctx, "Could not process rule: Counter '%s' does not exist",
+					 cmd->handle.obj);
+		return 0;
+	case CMD_OBJ_QUOTA:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		if (obj_lookup(table, cmd->handle.obj, NFT_OBJECT_QUOTA) == NULL)
+			return cmd_error(ctx, "Could not process rule: Quota '%s' does not exist",
+					 cmd->handle.obj);
+		return 0;
 	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
diff --git a/src/rule.c b/src/rule.c
index cd76983..665b1d9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1276,7 +1276,9 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		print_table = false;
 
 		list_for_each_entry(obj, &table->objs, list) {
-			if (obj->type != type)
+			if (obj->type != type ||
+			    (cmd->handle.obj != NULL &&
+			     strcmp(cmd->handle.obj, obj->handle.obj)))
 				continue;
 
 			if (!print_table) {
@@ -1426,8 +1428,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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

