From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: fix dumping with large number of sets
Date: Thu, 26 Dec 2013 13:23:38 +0100
Message-ID: <1388060618-3744-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3LZMXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Dec 2013 07:23:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If not table name is specified, the dumping of the existing sets
may be incomplete with a sufficiently large number of sets spread
in several tables that belong to the same family.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 604512d..1058db4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2079,17 +2079,21 @@ static int nf_tables_dump_sets_all(struct nft_ctx *ctx, struct sk_buff *skb,
 				   struct netlink_callback *cb)
 {
 	const struct nft_set *set;
-	unsigned int idx = 0, s_idx = cb->args[0];
+	unsigned int idx, s_idx = cb->args[0];
 	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
 
 	if (cb->args[1])
 		return skb->len;
 
 	list_for_each_entry(table, &ctx->afi->tables, list) {
-		if (cur_table && cur_table != table)
-			continue;
+		if (cur_table) {
+			if (cur_table != table)
+				continue;
 
+			cur_table = NULL;
+		}
 		ctx->table = table;
+		idx = 0;
 		list_for_each_entry(set, &ctx->table->sets, list) {
 			if (idx < s_idx)
 				goto cont;
@@ -2102,6 +2106,8 @@ static int nf_tables_dump_sets_all(struct nft_ctx *ctx, struct sk_buff *skb,
 cont:
 			idx++;
 		}
+		if (s_idx)
+			s_idx = 0;
 	}
 	cb->args[1] = 1;
 done:
-- 
1.7.10.4

