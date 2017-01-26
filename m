From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 3/6] evaluate: Evaluate table name before reset
 stateful objects in a table
Date: Thu, 26 Jan 2017 15:14:30 -0200
Message-ID: <20170126171430.GA7941@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34286 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbdAZRPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:15:12 -0500
Received: by mail-yb0-f196.google.com with SMTP id w194so20159134ybe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:14:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reseting stateful objects in a single table is already implemented and
cmd_evaluate_reset() now tests for the table name.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v3: Created on v3.

 src/evaluate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index dab7cfc..ed41bd8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2974,13 +2974,14 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_COUNTERS:
+	case CMD_OBJ_QUOTAS:
+		if (cmd->handle.table == NULL)
+			return 0;
 		if (table_lookup(&cmd->handle) == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		return 0;
-	case CMD_OBJ_COUNTERS:
-	case CMD_OBJ_QUOTAS:
-		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.7.4

