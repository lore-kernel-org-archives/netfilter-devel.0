From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/7] rule: display table when listing sets
Date: Thu,  8 Oct 2015 22:49:24 +0200
Message-ID: <1444337370-8269-2-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbbJHUmh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:37 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After this patch:

 # nft list sets ip
 table ip test {
        set pepe {
                type ipv4_addr
        }
 }

Before:

 # nft list sets ip
        set pepe {
                type ipv4_addr
        }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 92b83f0..71b26e3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -983,8 +983,18 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 
 	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    cmd->handle.family != table->handle.family)
+			continue;
+
+		printf("table %s %s {\n",
+		       family2str(table->handle.family),
+		       table->handle.table);
+
 		list_for_each_entry(set, &table->sets, list)
 			set_print(set);
+
+		printf("}\n");
 	}
 	return 0;
 }
-- 
2.1.4

