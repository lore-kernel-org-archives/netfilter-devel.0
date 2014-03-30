From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] netfilter: nf_tables: disabling table hooks always succeeds
Date: Sun, 30 Mar 2014 14:04:52 +0200
Message-ID: <1396181094-8140-7-git-send-email-pablo@netfilter.org>
References: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45435 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaC3MFR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:17 -0400
In-Reply-To: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_tables_table_disable() always succeeds, make this function void.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20265d6..5d42e89 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -380,7 +380,7 @@ err:
 	return err;
 }
 
-static int nf_tables_table_disable(const struct nft_af_info *afi,
+static void nf_tables_table_disable(const struct nft_af_info *afi,
 				   struct nft_table *table)
 {
 	struct nft_chain *chain;
@@ -390,8 +390,6 @@ static int nf_tables_table_disable(const struct nft_af_info *afi,
 			nf_unregister_hooks(nft_base_chain(chain)->ops,
 					    afi->nops);
 	}
-
-	return 0;
 }
 
 static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
@@ -411,9 +409,8 @@ static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
 
 		if ((flags & NFT_TABLE_F_DORMANT) &&
 		    !(table->flags & NFT_TABLE_F_DORMANT)) {
-			ret = nf_tables_table_disable(afi, table);
-			if (ret >= 0)
-				table->flags |= NFT_TABLE_F_DORMANT;
+			nf_tables_table_disable(afi, table);
+			table->flags |= NFT_TABLE_F_DORMANT;
 		} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 			   table->flags & NFT_TABLE_F_DORMANT) {
 			ret = nf_tables_table_enable(afi, table);
-- 
1.7.10.4

