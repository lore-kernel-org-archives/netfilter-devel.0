From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: add nft_set_is_anonymous() helper
Date: Sun, 10 Dec 2017 21:29:33 +0100
Message-ID: <20171210202933.11327-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbdLJU3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:29:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CFE22DA73F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:29:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1567DA7F1
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:29:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 901FEDA7F1
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:29:36 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6E9614265A4E
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:29:36 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add helper function to test for the NFT_SET_ANONYMOUS flag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_dynset.c        | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5d4055fecc6d..debed94ad997 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -416,6 +416,11 @@ struct nft_set {
 		__attribute__((aligned(__alignof__(u64))));
 };
 
+static inline bool nft_set_is_anonymous(const struct nft_set *set)
+{
+	return set->flags & NFT_SET_ANONYMOUS;
+}
+
 static inline void *nft_set_priv(const struct nft_set *set)
 {
 	return (void *)set->data;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67bda0629bda..4c632c36daea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -774,7 +774,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 
-		if (set->flags & NFT_SET_ANONYMOUS &&
+		if (nft_set_is_anonymous(set) &&
 		    !list_empty(&set->bindings))
 			continue;
 
@@ -3284,7 +3284,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *i;
 	struct nft_set_iter iter;
 
-	if (!list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
 
 	if (binding->flags & NFT_SET_MAP) {
@@ -3319,7 +3319,7 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	list_del_rcu(&binding->list);
 
-	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
 	    nft_is_active(ctx->net, set))
 		nf_tables_set_destroy(ctx, set);
 }
@@ -5157,7 +5157,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			/* This avoids hitting -EBUSY when deleting the table
 			 * from the transaction.
 			 */
-			if (nft_trans_set(trans)->flags & NFT_SET_ANONYMOUS &&
+			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
 			    !list_empty(&nft_trans_set(trans)->bindings))
 				trans->ctx.table->use--;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 66221ad891a9..ec0fd78231d8 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -184,7 +184,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_EXPR] != NULL) {
 		if (!(set->flags & NFT_SET_EVAL))
 			return -EINVAL;
-		if (!(set->flags & NFT_SET_ANONYMOUS))
+		if (!nft_set_is_anonymous(set))
 			return -EOPNOTSUPP;
 
 		priv->expr = nft_expr_init(ctx, tb[NFTA_DYNSET_EXPR]);
-- 
2.11.0

