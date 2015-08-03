From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: restore nft list tables
Date: Mon,  3 Aug 2015 18:06:50 +0200
Message-ID: <1438618010-4337-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45085 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbbHCQBC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Aug 2015 12:01:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Iterate over the ctx->list which is where the table objects are after
calling netlink_list_tables().

Fixes: e4d21958c835 ("rule: add do_list_tables()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 1e712a5..09d1ffd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -907,7 +907,7 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
 		return -1;
 
-	list_for_each_entry(table, &table_list, list)
+	list_for_each_entry(table, &ctx->list, list)
 		printf("table %s %s\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
-- 
1.7.10.4

