From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2] src: add list ruleset command
Date: Wed, 24 Sep 2014 11:13:57 +0200
Message-ID: <20140924091357.13585.3487.stgit@nfdev.cica.es>
References: <20140924091351.13585.92650.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52009 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752827AbaIXJOD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:14:03 -0400
In-Reply-To: <20140924091351.13585.92650.stgit@nfdev.cica.es>
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
 src/parser.y |    4 ++++
 src/rule.c   |   29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

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
index ac72f12..9c13474 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -782,6 +782,33 @@ err:
 	return -1;
 }
 
+static int do_command_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table, *nt;
+	struct netlink_ctx inner_ctx;
+	LIST_HEAD(msgs);
+
+	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+		return -1;
+
+	memset(&inner_ctx, 0, sizeof(inner_ctx));
+	init_list_head(&inner_ctx.list);
+	init_list_head(&msgs);
+	inner_ctx.msgs = &msgs;
+
+	list_for_each_entry_safe(table, nt, &ctx->list, list) {
+		table_add_hash(table);
+
+		cmd->handle.family = table->handle.family;
+		cmd->handle.table = table->handle.table;
+
+		if (do_command_list_table_content(&inner_ctx, cmd, table) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
@@ -837,6 +864,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			set_print(set);
 		}
 		return 0;
+	case CMD_OBJ_RULESET:
+		return do_command_list_ruleset(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}

