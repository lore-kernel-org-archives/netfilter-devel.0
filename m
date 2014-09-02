From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 2/6 v5] netfilter: nf_tables: add helper to unregister chain hooks
Date: Tue,  2 Sep 2014 16:42:23 +0200
Message-ID: <1409668946-8168-3-git-send-email-arturo.borrero.glez@gmail.com>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:49434 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753525AbaIBOmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:42:52 -0400
In-Reply-To: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a helper function to unregister chain hooks in the chain
deletion path. Basically, a code factorization.

The new function is useful in follow-up patches.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: rebased
v3: no changes, resending the series.
v4: no changes, resending the series because v3 series is invalid.
v5: no changes, resending the series.

 net/netfilter/nf_tables_api.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3664bab..90e3496 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -127,6 +127,15 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void nf_tables_unregister_hooks(const struct nft_table *table,
+				       const struct nft_chain *chain,
+				       unsigned int hook_nops)
+{
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    chain->flags & NFT_BASE_CHAIN)
+		nf_unregister_hooks(nft_base_chain(chain)->ops, hook_nops);
+}
+
 /*
  * Tables
  */
@@ -1157,11 +1166,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	list_add_tail_rcu(&chain->list, &table->chains);
 	return 0;
 err2:
-	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
-	    chain->flags & NFT_BASE_CHAIN) {
-		nf_unregister_hooks(nft_base_chain(chain)->ops,
-				    afi->nops);
-	}
+	nf_tables_unregister_hooks(table, chain, afi->nops);
 err1:
 	nf_tables_chain_destroy(chain);
 	return err;
@@ -3368,11 +3373,9 @@ static int nf_tables_commit(struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELCHAIN:
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
-			if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT) &&
-			    trans->ctx.chain->flags & NFT_BASE_CHAIN) {
-				nf_unregister_hooks(nft_base_chain(trans->ctx.chain)->ops,
-						    trans->ctx.afi->nops);
-			}
+			nf_tables_unregister_hooks(trans->ctx.table,
+						   trans->ctx.chain,
+						   trans->ctx.afi->nops);
 			break;
 		case NFT_MSG_NEWRULE:
 			nft_rule_clear(trans->ctx.net, nft_trans_rule(trans));
@@ -3495,11 +3498,9 @@ static int nf_tables_abort(struct sk_buff *skb)
 			} else {
 				trans->ctx.table->use--;
 				list_del_rcu(&trans->ctx.chain->list);
-				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT) &&
-				    trans->ctx.chain->flags & NFT_BASE_CHAIN) {
-					nf_unregister_hooks(nft_base_chain(trans->ctx.chain)->ops,
-							    trans->ctx.afi->nops);
-				}
+				nf_tables_unregister_hooks(trans->ctx.table,
+							   trans->ctx.chain,
+							   trans->ctx.afi->nops);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
-- 
1.7.10.4

