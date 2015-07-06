From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] rule: missing family when listing of tables
Date: Mon,  6 Jul 2015 19:06:44 +0200
Message-ID: <1436202406-14059-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58994 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbbGFRBT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 13:01:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft list tables
 table ip nat

instead of:

 # nft list tables
 table nat

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index b2090dd..39b4d9a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -928,7 +928,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 				return -1;
 
 			list_for_each_entry(table, &ctx->list, list) {
-				printf("table %s\n", table->handle.table);
+				printf("table %s %s\n",
+				       family2str(table->handle.family),
+				       table->handle.table);
 			}
 			return 0;
 		}
-- 
1.7.10.4

