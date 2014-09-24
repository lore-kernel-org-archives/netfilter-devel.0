From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/3 v2] src: add list ruleset command
Date: Wed, 24 Sep 2014 12:32:20 +0200
Message-ID: <1411554740-16660-3-git-send-email-arturo.borrero.glez@gmail.com>
References: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49252 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbaIXKdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:33:09 -0400
In-Reply-To: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
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
v3: rename function to do_list_ruleset() and use list_splice_tail_init()

 src/parser.y |    4 ++++
 src/rule.c   |   25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
index 336c159..c5a117d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -782,6 +782,29 @@ err:
 	return -1;
 }
 
+static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table, *next;
+	LIST_HEAD(table_list);
+
+	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+		return -1;
+
+	list_splice_tail_init(&ctx->list, &table_list);
+
+	list_for_each_entry_safe(table, next, &table_list, list) {
+		table_add_hash(table);
+
+		cmd->handle.family = table->handle.family;
+		cmd->handle.table = table->handle.table;
+
+		if (do_list_table(ctx, cmd, table) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -837,6 +860,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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

