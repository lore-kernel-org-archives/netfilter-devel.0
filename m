From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 16/16] src: consolidate set element cache
Date: Mon,  6 Jul 2015 20:17:08 +0200
Message-ID: <1436206628-23894-17-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40474 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbbGFSLq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:46 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 4a207e2..cc927b3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -64,6 +64,7 @@ int cache_init(struct list_head *msgs)
 	struct netlink_ctx ctx;
 	struct table *table;
 	struct chain *chain;
+	struct set *set;
 	int ret;
 
 	memset(&ctx, 0, sizeof(ctx));
@@ -84,6 +85,13 @@ int cache_init(struct list_head *msgs)
 		if (ret < 0)
 			return -1;
 
+		list_for_each_entry(set, &table->sets, list) {
+			ret = netlink_get_setelems(&ctx, &set->handle,
+						   &internal_location, set);
+			if (ret < 0)
+				return -1;
+		}
+
 		ret = netlink_list_chains(&ctx, &table->handle,
 					  &internal_location);
 		list_splice_tail_init(&ctx.list, &table->chains);
@@ -894,18 +902,6 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 }
 
-static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
-			struct table *table)
-{
-	struct set *set;
-
-	list_for_each_entry(set, &table->sets, list) {
-		if (netlink_get_setelems(ctx, &set->handle, loc, set) < 0)
-			return -1;
-	}
-	return 0;
-}
-
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nft_ruleset *rs = netlink_dump_ruleset(ctx, &cmd->handle,
@@ -924,25 +920,18 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
-	if (do_list_sets(ctx, &cmd->location, table) < 0)
-		return -1;
 	table_print(table);
 	return 0;
 }
 
-static int do_list_sets_global(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
 
 	list_for_each_entry(table, &table_list, list) {
-		list_for_each_entry(set, &table->sets, list) {
-			if (netlink_get_setelems(ctx, &set->handle,
-						 &cmd->location, set) < 0)
-				return -1;
-
+		list_for_each_entry(set, &table->sets, list)
 			set_print(set);
-		}
 	}
 	return 0;
 }
@@ -988,9 +977,6 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	if (netlink_get_setelems(ctx, &cmd->handle, &cmd->location, set) < 0)
-		return -1;
-
 	set_print(set);
 	return 0;
 }
@@ -1010,7 +996,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_SETS:
-		return do_list_sets_global(ctx, cmd);
+		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_SET:
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
-- 
1.7.10.4

