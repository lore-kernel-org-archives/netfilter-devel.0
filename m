From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: allow listing sets in one table
Date: Thu,  4 May 2017 18:09:31 +0200
Message-ID: <20170504160931.15400-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57638 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754522AbdEDQJS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 12:09:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently nft can lists sets:
nft list sets

but unlike e.g. 'quotas' or 'counters' we didn't support
restricting it to a table.  Now its possible to restrict set
definition listing to one table:

nft list sets table inet filter

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c     | 2 +-
 src/parser_bison.y | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 49c5953ae168..1cfe7675162e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3037,6 +3037,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
+	case CMD_OBJ_SETS:
 		if (cmd->handle.table == NULL)
 			return 0;
 		if (table_lookup(&cmd->handle) == NULL)
@@ -3044,7 +3045,6 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					 cmd->handle.table);
 		return 0;
 	case CMD_OBJ_CHAINS:
-	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_MAPS:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8db887a47d3e..6be94a9b873f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1007,6 +1007,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
 			}
+			|	SETS		TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$3, &@$, NULL);
+			}
 			|	SET		set_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SET, &$2, &@$, NULL);
-- 
2.10.2

