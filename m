From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/7] rule: display table when listing one set
Date: Thu,  8 Oct 2015 22:49:26 +0200
Message-ID: <1444337370-8269-4-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbbJHUmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:39 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After:

 # nft list set ip6 test foo
 table ip6 test {
        set foo {
                type ipv4_addr
        }
 }

Before:

  # nft list set ip6 test foo
        set foo {
                type ipv4_addr
        }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 4e4126d..58bac76 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1042,6 +1042,13 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static void table_print_declaration(struct table *table)
+{
+	printf("table %s %s {\n",
+		family2str(table->handle.family),
+		table->handle.table);
+}
+
 static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
@@ -1052,9 +1059,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		printf("table %s %s {\n",
-		       family2str(table->handle.family),
-		       table->handle.table);
+		table_print_declaration(table);
 
 		list_for_each_entry(chain, &table->chains, list) {
 			chain_print_declaration(chain);
@@ -1075,7 +1080,10 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
+	table_print_declaration(table);
 	set_print(set);
+	printf("}\n");
+
 	return 0;
 }
 
-- 
2.1.4

