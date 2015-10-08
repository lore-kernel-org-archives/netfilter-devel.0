From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/7] evaluate: check if set exists before listing it
Date: Thu,  8 Oct 2015 22:49:27 +0200
Message-ID: <1444337370-8269-5-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47759 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbbJHUmk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:40 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After this patch, we obtain:

 # nft list set ip6 test pepe
 <cmdline>:1:1-22: Error: Could not process rule: Set 'foo' does not exist
 list set ip6 test foo
 ^^^^^^^^^^^^^^^^^^^^^

So we get things aligned with table and chain listing commands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9762586..4f9299e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2091,10 +2091,20 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_TABLE:
 		if (cmd->handle.table == NULL)
 			return 0;
+
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		return 0;
 	case CMD_OBJ_SET:
-		if (table_lookup(&cmd->handle) == NULL)
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
+		if (set_lookup(table, cmd->handle.set) == NULL)
+			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
+					 cmd->handle.set);
 		return 0;
 	case CMD_OBJ_CHAIN:
 		table = table_lookup(&cmd->handle);
-- 
2.1.4

