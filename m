From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 1/2] src: add 'list maps' support
Date: Tue, 31 May 2016 12:37:06 +0200
Message-ID: <20160531103707.20058-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34828 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcEaKiI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:38:08 -0400
Received: by mail-wm0-f68.google.com with SMTP id e3so31163439wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 03:38:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit adds a new command that lists maps:

  # nft list maps [family]

Only the declaration is displayed. If no family is specified, all maps
of all families are listed.

Example:

  # nft list maps

  table ip filter {
          map test {
                  type ipv4_addr : inet_service
          }
  }
  table ip6 filter {
          map test {
                  type ipv6_addr : inet_service
          }
  }

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/rule.h     | 1 +
 src/evaluate.c     | 1 +
 src/parser_bison.y | 5 +++++
 src/rule.c         | 8 +++++++-
 src/scanner.l      | 1 +
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index bd24648..11d8618 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -318,6 +318,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPORT,
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
+	CMD_OBJ_MAPS,
 };
 
 struct export {
diff --git a/src/evaluate.c b/src/evaluate.c
index cb4d2a5..ea1a63d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2701,6 +2701,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
 	case CMD_OBJ_FLOWTABLES:
+	case CMD_OBJ_MAPS:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0452b8f..c689585 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -178,6 +178,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SET			"set"
 %token ELEMENT			"element"
 %token MAP			"map"
+%token MAPS			"maps"
 %token HANDLE			"handle"
 %token RULESET			"ruleset"
 
@@ -844,6 +845,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLE, &$3, &@$, NULL);
 			}
+			|	MAPS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAPS, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index 5613f96..38fd664 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1074,11 +1074,15 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		list_for_each_entry(set, &table->sets, list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
-			    set->flags & SET_F_ANONYMOUS)
+			    (set->flags & SET_F_ANONYMOUS ||
+			    set->flags & SET_F_MAP))
 				continue;
 			if (cmd->obj == CMD_OBJ_FLOWTABLES &&
 			    !(set->flags & SET_F_EVAL))
 				continue;
+			if (cmd->obj == CMD_OBJ_MAPS &&
+			    !(set->flags & SET_F_MAP))
+				continue;
 			set_print_declaration(set, &opts);
 			printf("%s}%s", opts.tab, opts.nl);
 		}
@@ -1216,6 +1220,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_FLOWTABLE:
 		return do_list_set(ctx, cmd, table);
+	case CMD_OBJ_MAPS:
+		return do_list_sets(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index b022114..88669d0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -245,6 +245,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "set"			{ return SET; }
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
+"maps"			{ return MAPS; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
 
-- 
2.8.3

