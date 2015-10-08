From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/7] rule: rework list chain
Date: Thu,  8 Oct 2015 22:49:29 +0200
Message-ID: <1444337370-8269-7-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbbJHUml (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:41 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After this patch:

 # nft list chain inet filter forward
 table inet filter {
        chain forward {
                type filter hook forward priority 0; policy drop;
                ct state established,related counter packets 39546074 bytes 11566126287 accept
        }
 }

Before this patch, this was showing the full table definition, including
all chains, which is not what the user is asking for.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 08db38b..6d617d2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1062,6 +1062,26 @@ static void table_print_declaration(struct table *table)
 		table->handle.table);
 }
 
+static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
+			 struct table *table)
+{
+	struct chain *chain;
+
+	table_print_declaration(table);
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (chain->handle.family != cmd->handle.family ||
+		    strcmp(cmd->handle.chain, chain->handle.chain) != 0)
+			continue;
+
+		chain_print(chain);
+	}
+
+	printf("}\n");
+
+	return 0;
+}
+
 static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
@@ -1113,7 +1133,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			return do_list_tables(ctx, cmd);
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
-		return do_list_table(ctx, cmd, table);
+		return do_list_chain(ctx, cmd, table);
 	case CMD_OBJ_CHAINS:
 		return do_list_chains(ctx, cmd);
 	case CMD_OBJ_SETS:
-- 
2.1.4

