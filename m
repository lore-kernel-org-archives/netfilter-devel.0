From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 13/14] src: use cache infrastructure for set element objects
Date: Mon, 10 Aug 2015 13:50:47 +0200
Message-ID: <1439207448-22485-14-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbbHJLpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:08 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Populate the cache iff the user requests a ruleset listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index cd18ca8..310ff95 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -72,6 +72,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	struct table *table;
 	struct chain *chain;
 	struct rule *rule, *nrule;
+	struct set *set;
 	int ret;
 
 	list_for_each_entry(table, &table_list, list) {
@@ -94,6 +95,13 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 			continue;
 		}
 
+		list_for_each_entry(set, &table->sets, list) {
+			ret = netlink_get_setelems(ctx, &set->handle,
+						   &internal_location, set);
+			if (ret < 0)
+				return -1;
+		}
+
 		ret = netlink_list_chains(ctx, &table->handle,
 					  &internal_location);
 		if (ret < 0)
@@ -932,18 +940,6 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -962,25 +958,18 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1029,9 +1018,6 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	if (netlink_get_setelems(ctx, &cmd->handle, &cmd->location, set) < 0)
-		return -1;
-
 	set_print(set);
 	return 0;
 }
@@ -1051,7 +1037,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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

