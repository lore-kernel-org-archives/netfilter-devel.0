From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: fix wrong transaction ordering in set elements
Date: Fri, 23 May 2014 11:03:19 +0200
Message-ID: <1400835799-4195-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaEWJDa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2014 05:03:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The transaction needs to be placed at the end of the commit list,
otherwise event notifications are reordered and we may crash when
releasing object via call_rcu.

This problem was introduced in 60319eb ("netfilter: nf_tables: use new
transaction infrastructure to handle elements").

Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e171c63..ca38725 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3076,7 +3076,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err4;
 
 	nft_trans_elem(trans) = elem;
-	list_add(&trans->list, &ctx->net->nft.commit_list);
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
 err4:
@@ -3160,7 +3160,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err2;
 
 	nft_trans_elem(trans) = elem;
-	list_add(&trans->list, &ctx->net->nft.commit_list);
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
-- 
1.7.10.4

