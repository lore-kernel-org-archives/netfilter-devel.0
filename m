From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: display expression, statement and command name on debug
Date: Wed, 31 Aug 2016 18:27:13 +0200
Message-ID: <1472660833-20447-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965016AbcHaQ1Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2016 12:27:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5611DC0B43
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 18:27:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44F25114D65
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 18:27:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 047A3114D65
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 18:27:18 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extend debugging knob for evaluation to display the command, the
expression and statement names.

 # nft --debug=eval add rule x y ip saddr 1.1.1.1 counter
 <cmdline>:1:1-37: Evaluate add
 add rule x y ip saddr 1.1.1.1 counter
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 <cmdline>:1:14-29: Evaluate expression
 add rule x y ip saddr 1.1.1.1 counter
              ^^^^^^^^^^^^^^^^
 ip saddr $1.1.1.1

 <cmdline>:1:14-29: Evaluate relational
 add rule x y ip saddr 1.1.1.1 counter
              ^^^^^^^^^^^^^^^^
 ip saddr $1.1.1.1

 <cmdline>:1:14-21: Evaluate payload
 add rule x y ip saddr 1.1.1.1 counter
              ^^^^^^^^
 ip saddr

 <cmdline>:1:23-29: Evaluate symbol
 add rule x y ip saddr 1.1.1.1 counter
                       ^^^^^^^

 <cmdline>:1:23-29: Evaluate value
 add rule x y ip saddr 1.1.1.1 counter
                       ^^^^^^^
 1.1.1.1

 <cmdline>:1:31-37: Evaluate counter
 add rule x y ip saddr 1.1.1.1 counter
                               ^^^^^^^
 counter packets 0 bytes 0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7eb28f2..89e40ca 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1585,7 +1585,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
-		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location, "Evaluate");
+		erec = erec_create(EREC_INFORMATIONAL, &(*expr)->location,
+				   "Evaluate %s", (*expr)->ops->name);
 		erec_print(stdout, erec); expr_print(*expr); printf("\n\n");
 	}
 #endif
@@ -2430,7 +2431,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
-		erec = erec_create(EREC_INFORMATIONAL, &stmt->location, "Evaluate");
+		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
+				   "Evaluate %s", stmt->ops->name);
 		erec_print(stdout, erec); stmt_print(stmt); printf("\n\n");
 	}
 #endif
@@ -2932,12 +2934,38 @@ static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 	return cache_update(cmd->op, ctx->msgs);
 }
 
+#ifdef DEBUG
+static const char *cmd_op_name[] = {
+	[CMD_INVALID]	= "invalid",
+	[CMD_ADD]	= "add",
+	[CMD_REPLACE]	= "replace",
+	[CMD_CREATE]	= "create",
+	[CMD_INSERT]	= "insert",
+	[CMD_DELETE]	= "delete",
+	[CMD_LIST]	= "list",
+	[CMD_FLUSH]	= "flush",
+	[CMD_RENAME]	= "rename",
+	[CMD_EXPORT]	= "export",
+	[CMD_MONITOR]	= "monitor",
+	[CMD_DESCRIBE]	= "describe",
+};
+
+static const char *cmd_op_to_name(enum cmd_ops op)
+{
+	if (op > CMD_DESCRIBE)
+		return "unknown";
+
+	return cmd_op_name[op];
+}
+#endif
+
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
-		erec = erec_create(EREC_INFORMATIONAL, &cmd->location, "Evaluate");
+		erec = erec_create(EREC_INFORMATIONAL, &cmd->location,
+				   "Evaluate %s", cmd_op_to_name(cmd->op));
 		erec_print(stdout, erec); printf("\n\n");
 	}
 #endif
-- 
2.1.4

