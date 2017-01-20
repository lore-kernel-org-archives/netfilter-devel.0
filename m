From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf] netfilter: nf_tables: deconstify walk callback function
Date: Fri, 20 Jan 2017 14:22:02 +0100
Message-ID: <1484918523-9198-1-git-send-email-pablo@netfilter.org>
Cc: elise.lennion@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752213AbdATNWS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 08:22:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B85163EBA80
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91EE9961E5
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E4529D697
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 14:22:06 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flush operation needs to modify set and element objects, so let's
deconstify this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 +++---
 net/netfilter/nf_tables_api.c     | 24 ++++++++++++------------
 net/netfilter/nft_set_hash.c      |  2 +-
 net/netfilter/nft_set_rbtree.c    |  2 +-
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 924325c46aab..7dfdb517f0be 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -207,9 +207,9 @@ struct nft_set_iter {
 	unsigned int	skip;
 	int		err;
 	int		(*fn)(const struct nft_ctx *ctx,
-			      const struct nft_set *set,
+			      struct nft_set *set,
 			      const struct nft_set_iter *iter,
-			      const struct nft_set_elem *elem);
+			      struct nft_set_elem *elem);
 };
 
 /**
@@ -301,7 +301,7 @@ struct nft_set_ops {
 	void				(*remove)(const struct nft_set *set,
 						  const struct nft_set_elem *elem);
 	void				(*walk)(const struct nft_ctx *ctx,
-						const struct nft_set *set,
+						struct nft_set *set,
 						struct nft_set_iter *iter);
 
 	unsigned int			(*privsize)(const struct nlattr * const nla[]);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a4619cbf2fe2..9bac76e48eb6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3084,9 +3084,9 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 }
 
 static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
-					const struct nft_set *set,
+					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					const struct nft_set_elem *elem)
+					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	enum nft_registers dreg;
@@ -3303,9 +3303,9 @@ struct nft_set_dump_args {
 };
 
 static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
-				  const struct nft_set *set,
+				  struct nft_set *set,
 				  const struct nft_set_iter *iter,
-				  const struct nft_set_elem *elem)
+				  struct nft_set_elem *elem)
 {
 	struct nft_set_dump_args *args;
 
@@ -3317,7 +3317,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
 	u8 genmask = nft_genmask_cur(net);
-	const struct nft_set *set;
+	struct nft_set *set;
 	struct nft_set_dump_args args;
 	struct nft_ctx ctx;
 	struct nlattr *nla[NFTA_SET_ELEM_LIST_MAX + 1];
@@ -3885,9 +3885,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 }
 
 static int nft_flush_set(const struct nft_ctx *ctx,
-			 const struct nft_set *set,
+			 struct nft_set *set,
 			 const struct nft_set_iter *iter,
-			 const struct nft_set_elem *elem)
+			 struct nft_set_elem *elem)
 {
 	struct nft_trans *trans;
 	int err;
@@ -3902,8 +3902,8 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 		goto err1;
 	}
 
-	nft_trans_elem_set(trans) = (struct nft_set *)set;
-	nft_trans_elem(trans) = *((struct nft_set_elem *)elem);
+	nft_trans_elem_set(trans) = set;
+	nft_trans_elem(trans) = *elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
@@ -5012,9 +5012,9 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				 const struct nft_chain *chain);
 
 static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
-					const struct nft_set *set,
+					struct nft_set *set,
 					const struct nft_set_iter *iter,
-					const struct nft_set_elem *elem)
+					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	const struct nft_data *data;
@@ -5038,7 +5038,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 {
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
-	const struct nft_set *set;
+	struct nft_set *set;
 	struct nft_set_binding *binding;
 	struct nft_set_iter iter;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 1e20e2bbb6d9..e36069fb76ae 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -212,7 +212,7 @@ static void nft_hash_remove(const struct nft_set *set,
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_hash_params);
 }
 
-static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
+static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_iter *iter)
 {
 	struct nft_hash *priv = nft_set_priv(set);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 08376e50f6cd..f06f55ee516d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -221,7 +221,7 @@ static void *nft_rbtree_deactivate(const struct net *net,
 }
 
 static void nft_rbtree_walk(const struct nft_ctx *ctx,
-			    const struct nft_set *set,
+			    struct nft_set *set,
 			    struct nft_set_iter *iter)
 {
 	const struct nft_rbtree *priv = nft_set_priv(set);
-- 
2.1.4

