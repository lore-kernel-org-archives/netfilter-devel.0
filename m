From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 15/16] rule: consolidate rule cache
Date: Mon,  6 Jul 2015 20:17:07 +0200
Message-ID: <1436206628-23894-16-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40468 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbbGFSLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:45 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index e005ce7..4a207e2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -60,8 +60,10 @@ int cache_init(struct list_head *msgs)
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
 	};
+	struct rule *rule, *nrule;
 	struct netlink_ctx ctx;
 	struct table *table;
+	struct chain *chain;
 	int ret;
 
 	memset(&ctx, 0, sizeof(ctx));
@@ -88,6 +90,16 @@ int cache_init(struct list_head *msgs)
 
 		if (ret < 0)
 			return -1;
+
+		ret = netlink_list_table(&ctx, &table->handle,
+					 &internal_location);
+		list_for_each_entry_safe(rule, nrule, &ctx.list, list) {
+			chain = chain_lookup(table, &rule->handle);
+			list_move_tail(&rule->list, &chain->rules);
+		}
+
+		if (ret < 0)
+			return -1;
 	}
 
 	return 0;
@@ -912,18 +924,8 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
-	struct rule *rule, *nrule;
-	struct chain *chain;
-
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		return -1;
-	if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-		return -1;
-
-	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-		chain = chain_lookup(table, &rule->handle);
-		list_move_tail(&rule->list, &chain->rules);
-	}
 	table_print(table);
 	return 0;
 }
-- 
1.7.10.4

