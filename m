From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/9] netfilter: nf_tables: fix memory leaks on chain rename
Date: Tue, 24 Jul 2018 18:31:30 +0200
Message-ID: <20180724163133.14586-7-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The new name is stored in the transaction metadata, on commit,
the pointers to the old and new names are swapped.

Therefore in abort and commit case we have to free the
pointer in the chain_trans container.

In commit case, the pointer can be used by another cpu that
is currently dumping the renamed chain, thus kfree needs to
happen after waiting for rcu readers to complete.

Fixes: b7263e071a ("netfilter: nf_tables: Allow chain name of up to 255 chars")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 200da08524ae..91230d713190 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6087,6 +6087,9 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELTABLE:
 		nf_tables_table_destroy(&trans->ctx);
 		break;
+	case NFT_MSG_NEWCHAIN:
+		kfree(nft_trans_chain_name(trans));
+		break;
 	case NFT_MSG_DELCHAIN:
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
@@ -6316,13 +6319,15 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_DELTABLE);
 			break;
 		case NFT_MSG_NEWCHAIN:
-			if (nft_trans_chain_update(trans))
+			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(trans);
-			else
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				/* trans destroyed after rcu grace period */
+			} else {
 				nft_clear(net, trans->ctx.chain);
-
-			nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
-			nft_trans_destroy(trans);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				nft_trans_destroy(trans);
+			}
 			break;
 		case NFT_MSG_DELCHAIN:
 			nft_chain_del(trans->ctx.chain);
@@ -6472,7 +6477,7 @@ static int __nf_tables_abort(struct net *net)
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				free_percpu(nft_trans_chain_stats(trans));
-
+				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;
-- 
2.11.0
