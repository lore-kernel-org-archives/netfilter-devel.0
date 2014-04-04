From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/10] netfilter: nf_tables: disabling table hooks always succeeds
Date: Fri,  4 Apr 2014 15:48:11 +0200
Message-ID: <1396619294-26212-8-git-send-email-pablo@netfilter.org>
References: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48521 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaDDNsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:48:32 -0400
In-Reply-To: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_tables_table_disable() always succeeds, make this function void.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2345259..0fa9671 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -381,7 +381,7 @@ err:
 	return err;
 }
 
-static int nf_tables_table_disable(const struct nft_af_info *afi,
+static void nf_tables_table_disable(const struct nft_af_info *afi,
 				   struct nft_table *table)
 {
 	struct nft_chain *chain;
@@ -391,8 +391,6 @@ static int nf_tables_table_disable(const struct nft_af_info *afi,
 			nf_unregister_hooks(nft_base_chain(chain)->ops,
 					    afi->nops);
 	}
-
-	return 0;
 }
 
 static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
@@ -412,9 +410,8 @@ static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
 
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
@@ -963,7 +960,8 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		}
 
 		nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
-		trans = nft_trans_alloc(&ctx, NFT_MSG_NEWCHAIN);
+		trans = nft_trans_alloc(&ctx, NFT_MSG_NEWCHAIN,
+					sizeof(struct nft_trans_chain));
 		if (trans == NULL)
 			return -ENOMEM;
 
-- 
1.7.10.4

