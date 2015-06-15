From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 13/15] netfilter: nf_tables: adapt it to pernet hooks
Date: Mon, 15 Jun 2015 17:46:55 +0200
Message-ID: <1434383217-13732-14-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36920 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbbFOPl5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:57 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since pernet hooks, we need to register the hook for each netnamespace space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8d4044..48c4844 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -556,7 +556,7 @@ err:
 	return err;
 }
 
-static int nf_tables_table_enable(const struct nft_af_info *afi,
+static int nf_tables_table_enable(const struct nft_ctx *ctx,
 				  struct nft_table *table)
 {
 	struct nft_chain *chain;
@@ -566,8 +566,8 @@ static int nf_tables_table_enable(const struct nft_af_info *afi,
 		if (!(chain->flags & NFT_BASE_CHAIN))
 			continue;
 
-		err = nf_register_hooks(&init_net, nft_base_chain(chain)->ops,
-					afi->nops);
+		err = nf_register_hooks(ctx->net, nft_base_chain(chain)->ops,
+					ctx->afi->nops);
 		if (err < 0)
 			goto err;
 
@@ -582,7 +582,7 @@ err:
 		if (i-- <= 0)
 			break;
 
-		nf_unregister_hooks(nft_base_chain(chain)->ops, afi->nops);
+		nf_unregister_hooks(nft_base_chain(chain)->ops, ctx->afi->nops);
 	}
 	return err;
 }
@@ -630,7 +630,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		nft_trans_table_enable(trans) = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-		ret = nf_tables_table_enable(ctx->afi, ctx->table);
+		ret = nf_tables_table_enable(ctx, ctx->table);
 		if (ret >= 0) {
 			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 			nft_trans_table_enable(trans) = true;
@@ -1419,7 +1419,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    chain->flags & NFT_BASE_CHAIN) {
-		err = nf_register_hooks(&init_net, nft_base_chain(chain)->ops,
+		err = nf_register_hooks(net, nft_base_chain(chain)->ops,
 					afi->nops);
 		if (err < 0)
 			goto err1;
-- 
1.7.10.4

