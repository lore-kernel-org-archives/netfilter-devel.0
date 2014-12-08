From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] rule: fix segmentation faults on kernels without nftables support
Date: Mon,  8 Dec 2014 23:30:36 +0100
Message-ID: <1418077836-6565-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37996 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaLHW2W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:28:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft list sets
 Segmentation fault

 # nft list sets
 <cmdline>:1:1-9: Error: Could not receive sets from kernel: Protocol error
 list sets
 ^^^^^^^^^

Fix same bug in `nft list tables'.

Don't cleanup the table object for these commands since it is NULL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index a79a420..9576664 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -870,7 +870,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 
 			if (netlink_list_tables(ctx, &cmd->handle,
 						&cmd->location) < 0)
-				goto err;
+				return -1;
 
 			list_for_each_entry(table, &ctx->list, list) {
 				printf("table %s\n", table->handle.table);
@@ -882,11 +882,12 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_SETS:
 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
+			return -1;
+
 		list_for_each_entry(set, &ctx->list, list){
 			if (netlink_get_setelems(ctx, &set->handle,
 						 &cmd->location, set) < 0) {
-				goto err;
+				return -1;
 			}
 			set_print(set);
 		}
-- 
1.7.10.4

