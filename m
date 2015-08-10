From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 12/14] src: use cache infrastructure for rule objects
Date: Mon, 10 Aug 2015 13:50:46 +0200
Message-ID: <1439207448-22485-13-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56025 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbbHJLpH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:07 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Populate the cache iff the user requests a ruleset listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index b7c834f..cd18ca8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -70,6 +70,8 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h)
 static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 {
 	struct table *table;
+	struct chain *chain;
+	struct rule *rule, *nrule;
 	int ret;
 
 	list_for_each_entry(table, &table_list, list) {
@@ -97,6 +99,16 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 		if (ret < 0)
 			return -1;
 		list_splice_tail_init(&ctx->list, &table->chains);
+
+		ret = netlink_list_table(ctx, &table->handle,
+					 &internal_location);
+		list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+			chain = chain_lookup(table, &rule->handle);
+			list_move_tail(&rule->list, &chain->rules);
+		}
+
+		if (ret < 0)
+			return -1;
 	}
 	return 0;
 }
@@ -950,18 +962,8 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
-	struct rule *rule, *nrule;
-	struct chain *chain;
-
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		return -1;
-	if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-		return -1;
-
-	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-		chain = chain_lookup(table, &rule->handle);
-		list_move_tail(&rule->list, &chain->rules);
-	}
 	table_print(table);
 	return 0;
 }
-- 
1.7.10.4

