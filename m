From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 nft] src: fix do_list_tables() with family filtering
Date: Wed,  8 Jul 2015 11:18:07 +0200
Message-ID: <1436347088-9687-2-git-send-email-pablo@netfilter.org>
References: <1436347088-9687-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42260 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933714AbbGHJMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 05:12:35 -0400
In-Reply-To: <1436347088-9687-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the ruleset_spec production so default is NFPROTO_UNSPEC as in 'list
ruleset'.

 # nft list tables
 table ip nat
 table ip test
 table inet filter

 # nft list tables ip
 table ip nat
 table ip test

 # nft list tables inet
 table inet filter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y |    2 +-
 src/rule.c         |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5c4e272..772cd65 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -764,7 +764,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
-			|	TABLES		tables_spec
+			|	TABLES		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
diff --git a/src/rule.c b/src/rule.c
index f806db6..65b31e7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -953,14 +953,19 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static int do_list_tables(void)
+static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &table_list, list)
+	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    table->handle.family != cmd->handle.family)
+			continue;
+
 		printf("table %s %s\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
+	}
 
 	return 0;
 }
@@ -988,7 +993,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table)
-			return do_list_tables();
+			return do_list_tables(ctx, cmd);
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
 		return do_list_table(ctx, cmd, table);
-- 
1.7.10.4

