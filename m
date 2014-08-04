From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: uninitialize element key/data from the commit path
Date: Mon,  4 Aug 2014 23:04:14 +0200
Message-ID: <1407186254-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tgraf@suug.ch
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45493 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaHDVEX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:04:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This should happen once the element has been effectively released in
the commit path, not before. This fixes a possible chain refcount leak
if the transaction is aborted.

Reported-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b35ba83..f95dc95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3213,11 +3213,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-
-	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
-	if (set->flags & NFT_SET_MAP)
-		nft_data_uninit(&elem.data, set->dtype);
-
 	return 0;
 err2:
 	nft_data_uninit(&elem.key, desc.type);
@@ -3381,7 +3376,7 @@ static int nf_tables_commit(struct sk_buff *skb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct nft_trans *trans, *next;
-	struct nft_set *set;
+	struct nft_trans_elem *te;
 
 	/* Bump generation counter, invalidate any dump in progress */
 	while (++net->nft.base_seq == 0);
@@ -3467,13 +3462,17 @@ static int nf_tables_commit(struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
-			nf_tables_setelem_notify(&trans->ctx,
-						 nft_trans_elem_set(trans),
-						 &nft_trans_elem(trans),
+			te = (struct nft_trans_elem *)trans->data;
+			nf_tables_setelem_notify(&trans->ctx, te->set,
+						 &te->elem,
 						 NFT_MSG_DELSETELEM, 0);
-			set = nft_trans_elem_set(trans);
-			set->ops->get(set, &nft_trans_elem(trans));
-			set->ops->remove(set, &nft_trans_elem(trans));
+			te->set->ops->get(te->set, &te->elem);
+			te->set->ops->remove(te->set, &te->elem);
+			nft_data_uninit(&te->elem.key, NFT_DATA_VALUE);
+			if (te->elem.flags & NFT_SET_MAP) {
+				nft_data_uninit(&te->elem.data,
+						te->set->dtype);
+			}
 			nft_trans_destroy(trans);
 			break;
 		}
-- 
1.7.10.4

