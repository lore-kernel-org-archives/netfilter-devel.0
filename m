From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 2/2] src: Allow list single stateful object
Date: Mon, 23 Jan 2017 17:17:37 -0200
Message-ID: <20170123191737.GA14838@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35373 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAWTRp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 14:17:45 -0500
Received: by mail-qt0-f194.google.com with SMTP id f4so19450372qte.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 11:17:44 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the stateful objects can only be listed in groups. With this
patch listing a single object is allowed:

$ nft list counter x https-traffic
table ip x {
	counter https-traffic {
		packets 4014 bytes 228948
	}
}

$ nft list quota x https-quota
table ip x {
	quota https-quota {
		25 mbytes used 278 kbytes
	}
}

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
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
index a9f3a49..6fc6570 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1277,7 +1277,9 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		       table->handle.table);
 
 		list_for_each_entry(obj, &table->objs, list) {
-			if (obj->type != type)
+			if (obj->type != type ||
+			    (cmd->handle.obj != NULL &&
+			     strcmp(cmd->handle.obj, obj->handle.obj)))
 				continue;
 
 			obj_print_declaration(obj, &opts);
@@ -1420,8 +1422,10 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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

