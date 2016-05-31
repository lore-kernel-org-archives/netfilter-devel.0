From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/2] src: add support for display maps content
Date: Tue, 31 May 2016 12:37:07 +0200
Message-ID: <20160531103707.20058-2-pablombg@gmail.com>
References: <20160531103707.20058-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36666 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcEaKiO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:38:14 -0400
Received: by mail-wm0-f67.google.com with SMTP id q62so31303050wmg.3
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 03:38:13 -0700 (PDT)
In-Reply-To: <20160531103707.20058-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit adds a new command that displays the definition of a single
map:

  # nft list map [family] <table> <map>

If no family is specified, ip is assumed.

Example:

  # nft list map ip6 filter test

  table ip6 filter {
          map test {
                  type ipv6_addr : inet_service
                  elements = { 2001:db8::ff00:42:8329 : http}
          }
  }

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/rule.h     |  1 +
 src/evaluate.c     | 10 ++++++++++
 src/parser_bison.y |  4 ++++
 src/rule.c         |  2 ++
 4 files changed, 17 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 11d8618..523aaa3 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -318,6 +318,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPORT,
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
+	CMD_OBJ_MAP,
 	CMD_OBJ_MAPS,
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index ea1a63d..423523f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2688,6 +2688,16 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Flow table '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
+	case CMD_OBJ_MAP:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || !(set->flags & SET_F_MAP))
+			return cmd_error(ctx, "Could not process rule: Map '%s' does not exist",
+					 cmd->handle.set);
+		return 0;
 	case CMD_OBJ_CHAIN:
 		table = table_lookup(&cmd->handle);
 		if (table == NULL)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c689585..1a45a6f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -849,6 +849,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAPS, &$2, &@$, NULL);
 			}
+			|	MAP		set_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index 38fd664..14e57f2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1222,6 +1222,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_MAPS:
 		return do_list_sets(ctx, cmd);
+	case CMD_OBJ_MAP:
+		return do_list_set(ctx, cmd, table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.8.3

