From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/7] src: allow listing all ct helpers
Date: Mon, 27 Feb 2017 16:02:54 +0100
Message-ID: <20170227150255.12624-7-fw@strlen.de>
References: <20170227150255.12624-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56300 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751039AbdB0Q0X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 11:26:23 -0500
In-Reply-To: <20170227150255.12624-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this implements
nft list ct helpers table filter
table ip filter {
    ct helper ftp-standard {
..

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h     |  1 +
 src/evaluate.c     |  1 +
 src/parser_bison.y | 19 +++++++++++++++++++
 src/rule.c         |  2 ++
 4 files changed, 23 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 6a495a9a36be..882fc3350c6c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -370,6 +370,7 @@ enum cmd_obj {
 	CMD_OBJ_COUNTERS,
 	CMD_OBJ_QUOTA,
 	CMD_OBJ_QUOTAS,
+	CMD_OBJ_CT_HELPERS,
 };
 
 struct export {
diff --git a/src/evaluate.c b/src/evaluate.c
index 4ac55e177d54..4c8c1e8a4229 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2999,6 +2999,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
+	case CMD_OBJ_CT_HELPERS:
 		if (cmd->handle.table == NULL)
 			return 0;
 		if (table_lookup(&cmd->handle) == NULL)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3ff11ff18cfe..076e59ae603d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -985,6 +985,25 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
+			|       CT              STRING  TABLE   table_spec
+			{
+				int cmd;
+
+				if (strcmp($2, "helpers") == 0) {
+					cmd = CMD_OBJ_CT_HELPERS;
+				} else {
+					struct error_record *erec;
+
+					erec = error(&@$, "unknown ct class '%s', want 'helpers'", $2);
+
+					if (erec != NULL) {
+						erec_queue(erec, state->msgs);
+						YYERROR;
+					}
+				}
+
+				$$ = cmd_alloc(CMD_LIST, cmd, &$4, &@$, NULL);
+			}
 			;
 
 reset_cmd		:	COUNTERS	ruleset_spec
diff --git a/src/rule.c b/src/rule.c
index eb31f0e9ec5e..889aa719afaa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1468,6 +1468,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_QUOTAS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
+	case CMD_OBJ_CT_HELPERS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.10.2

