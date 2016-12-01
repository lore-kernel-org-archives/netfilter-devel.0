From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: return ctx->table from table_lookup_global()
Date: Thu,  1 Dec 2016 12:23:19 +0100
Message-ID: <1480591399-7704-1-git-send-email-pablo@netfilter.org>
Cc: martin@serafean.cz
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756063AbcLALXf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 06:23:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F2DC38CD67
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:23:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6E4B53863
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:23:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1019B5386A
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:23:27 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of returning ctx->cmd->table. Note that ctx->cmd->table and
ctx->table points to the same object when all commands are embedded into
the table definition. But this is not true if we mix table definitions
with linear list commands in one file that we load via nft -f.

Reported-by: Martin Bednar <martin@serafean.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c841aafd98a0..cf7ecb96e3b2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -140,7 +140,7 @@ static struct table *table_lookup_global(struct eval_ctx *ctx)
 	struct table *table;
 
 	if (ctx->table != NULL)
-		return ctx->cmd->table;
+		return ctx->table;
 
 	table = table_lookup(&ctx->cmd->handle);
 	if (table == NULL)
-- 
2.1.4

