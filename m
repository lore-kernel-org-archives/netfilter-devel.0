From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 06/16] src: add set declaration to cache
Date: Mon,  6 Jul 2015 20:16:58 +0200
Message-ID: <1436206628-23894-7-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbbGFSLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:43 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds set objects to the cache if they don't exist in the kernel, so
they can be referenced from this batch. This occurs from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 963622f..91c4989 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1736,8 +1736,17 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
+	struct table *table;
 	const char *type;
 
+	table = table_lookup(&ctx->cmd->handle);
+	if (table == NULL)
+		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+				 ctx->cmd->handle.table);
+
+	if (set_lookup(table, set->handle.set) == NULL)
+		set_add_hash(set_get(set), table);
+
 	type = set->flags & SET_F_MAP ? "map" : "set";
 
 	if (set->keytype == NULL)
-- 
1.7.10.4

