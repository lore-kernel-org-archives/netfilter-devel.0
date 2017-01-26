From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 4/6] src: Allow list stateful objects in a table
Date: Thu, 26 Jan 2017 15:15:44 -0200
Message-ID: <20170126171544.GA7962@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35645 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbdAZRY7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:24:59 -0500
Received: by mail-qt0-f196.google.com with SMTP id f4so39902202qte.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:24:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, stateful objects can be listed by: listing all objects in
all tables; listing a single object in a table. Now it's allowed to
list all objects in a table.

$ nft list counters table filter
table ip filter {
	counter https-traffic {
		packets 14825 bytes 950063
	}
	counter http-traffic {
		packets 117 bytes 9340
	}
}

$ nft list quotas table filter
table ip filter {
	quota https-quota {
		25 mbytes used 2 mbytes
	}
	quota http-quota {
		25 mbytes used 10 kbytes
	}
}

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v3: Created in v3.

 src/evaluate.c     | 10 ++++++++--
 src/parser_bison.y |  8 ++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ed41bd8..379f9d7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2950,10 +2950,16 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Object '%s' does not exist",
 					 cmd->handle.obj);
 		return 0;
-	case CMD_OBJ_CHAINS:
-	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
+		if (cmd->handle.table == NULL)
+			return 0;
+		if (table_lookup(&cmd->handle) == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		return 0;
+	case CMD_OBJ_CHAINS:
+	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_MAPS:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a1b8b08..d543e3e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -932,6 +932,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$2, &@$, NULL);
 			}
+			|	COUNTERS	TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTERS, &$3, &@$, NULL);
+			}
 			|	COUNTER		obj_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_COUNTER, &$2, &@$, NULL);
@@ -940,6 +944,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$2, &@$, NULL);
 			}
+			|	QUOTAS		TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTAS, &$3, &@$, NULL);
+			}
 			|	QUOTA		obj_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTA, &$2, &@$, NULL);
-- 
2.7.4

