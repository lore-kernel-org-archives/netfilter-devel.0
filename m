From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/3 v3] src: add list ruleset command
Date: Fri, 26 Sep 2014 18:30:08 +0200
Message-ID: <1411749008-924-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:38275 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196AbaIZQaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:30:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new command to nft:
	% nft list ruleset [family]

Which list the entire ruleset.
If no family is specified, all tables of all families are listed.

Users can now make several operations at ruleset level:

 % nft list ruleset > ruleset.nft
 % nft -f ruleset.nft
 % nft flush ruleset

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: rename function to do_list_ruleset() and use list_splice_tail_init().
v3: fixed clash with static list "table_list", and double free() of a handle.

 src/parser.y |    4 ++++
 src/rule.c   |   28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/src/parser.y b/src/parser.y
index e35eede..8f58e3a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -753,6 +753,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	RULESET		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index 336c159..43355ee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -782,6 +782,32 @@ err:
 	return -1;
 }
 
+static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table, *next;
+	LIST_HEAD(tables);
+
+	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+		return -1;
+
+	list_splice_tail_init(&ctx->list, &tables);
+
+	list_for_each_entry_safe(table, next, &tables, list) {
+		table_add_hash(table);
+
+		cmd->handle.family = table->handle.family;
+		cmd->handle.table = xstrdup(table->handle.table);
+
+		if (do_list_table(ctx, cmd, table) < 0)
+			return -1;
+
+		list_del(&table->list);
+		table_free(table);
+	}
+
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -837,6 +863,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			set_print(set);
 		}
 		return 0;
+	case CMD_OBJ_RULESET:
+		return do_list_ruleset(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
1.7.10.4

