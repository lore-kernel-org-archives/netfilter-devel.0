From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] rule: add do_list_tables()
Date: Mon,  6 Jul 2015 19:06:46 +0200
Message-ID: <1436202406-14059-3-git-send-email-pablo@netfilter.org>
References: <1436202406-14059-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58987 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbGFRBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 13:01:18 -0400
In-Reply-To: <1436202406-14059-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Wrap code to list existing tables in a function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 993f970..c7a4ef8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -900,6 +900,18 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_list_tables(void)
+{
+	struct table *table;
+
+	list_for_each_entry(table, &table_list, list)
+		printf("table %s %s\n",
+		       family2str(table->handle.family),
+		       table->handle.table);
+
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -917,21 +929,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
-		if (!cmd->handle.table) {
-			/* List all existing tables */
-			struct table *table;
-
-			if (netlink_list_tables(ctx, &cmd->handle,
-						&cmd->location) < 0)
-				return -1;
-
-			list_for_each_entry(table, &ctx->list, list) {
-				printf("table %s %s\n",
-				       family2str(table->handle.family),
-				       table->handle.table);
-			}
-			return 0;
-		}
+		if (!cmd->handle.table)
+			return do_list_tables();
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
 		return do_list_table(ctx, cmd, table);
-- 
1.7.10.4

