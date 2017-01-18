From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/7] netfilter: nf_tables: rename deactivate_one() to flush()
Date: Wed, 18 Jan 2017 18:30:09 +0100
Message-ID: <1484760613-17236-4-git-send-email-pablo@netfilter.org>
References: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752551AbdARRaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10ED01392AD
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E46B0A7DB4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2820FFEFB3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:20 +0100 (CET)
In-Reply-To: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Although semantics are similar to deactivate() with no implicit element
lookup, this is only called from the set flush path, so better rename
this to flush.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 8 ++++----
 net/netfilter/nf_tables_api.c     | 2 +-
 net/netfilter/nft_set_hash.c      | 8 ++++----
 net/netfilter/nft_set_rbtree.c    | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1b6fd97d268c..1c3bf162cef8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -260,7 +260,7 @@ struct nft_expr;
  *	@insert: insert new element into set
  *	@activate: activate new element in the next generation
  *	@deactivate: lookup for element and deactivate it in the next generation
- *	@deactivate_one: deactivate element in the next generation
+ *	@flush: deactivate element in the next generation
  *	@remove: remove element from set
  *	@walk: iterate over all set elemeennts
  *	@privsize: function to return size of set private data
@@ -295,9 +295,9 @@ struct nft_set_ops {
 	void *				(*deactivate)(const struct net *net,
 						      const struct nft_set *set,
 						      const struct nft_set_elem *elem);
-	bool				(*deactivate_one)(const struct net *net,
-							  const struct nft_set *set,
-							  void *priv);
+	bool				(*flush)(const struct net *net,
+						 const struct nft_set *set,
+						 void *priv);
 	void				(*remove)(const struct net *net,
 						  const struct nft_set *set,
 						  const struct nft_set_elem *elem);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 494b49420149..26238dba6314 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3897,7 +3897,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	if (!trans)
 		return -ENOMEM;
 
-	if (!set->ops->deactivate_one(ctx->net, set, elem->priv)) {
+	if (!set->ops->flush(ctx->net, set, elem->priv)) {
 		err = -ENOENT;
 		goto err1;
 	}
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 12df560edee1..f9e69e8a8dc3 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -167,8 +167,8 @@ static void nft_hash_activate(const struct net *net, const struct nft_set *set,
 	nft_set_elem_clear_busy(&he->ext);
 }
 
-static bool nft_hash_deactivate_one(const struct net *net,
-				    const struct nft_set *set, void *priv)
+static bool nft_hash_flush(const struct net *net,
+			   const struct nft_set *set, void *priv)
 {
 	struct nft_hash_elem *he = priv;
 
@@ -195,7 +195,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	rcu_read_lock();
 	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
 	if (he != NULL &&
-	    !nft_hash_deactivate_one(net, set, he))
+	    !nft_hash_flush(net, set, he))
 		he = NULL;
 
 	rcu_read_unlock();
@@ -398,7 +398,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
 	.insert		= nft_hash_insert,
 	.activate	= nft_hash_activate,
 	.deactivate	= nft_hash_deactivate,
-	.deactivate_one	= nft_hash_deactivate_one,
+	.flush		= nft_hash_flush,
 	.remove		= nft_hash_remove,
 	.lookup		= nft_hash_lookup,
 	.update		= nft_hash_update,
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index afccbd2aee31..46504c2c65d7 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -172,8 +172,8 @@ static void nft_rbtree_activate(const struct net *net,
 	nft_set_elem_change_active(net, set, &rbe->ext);
 }
 
-static bool nft_rbtree_deactivate_one(const struct net *net,
-				      const struct nft_set *set, void *priv)
+static bool nft_rbtree_flush(const struct net *net,
+			     const struct nft_set *set, void *priv)
 {
 	struct nft_rbtree_elem *rbe = priv;
 
@@ -214,7 +214,7 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				parent = parent->rb_right;
 				continue;
 			}
-			nft_rbtree_deactivate_one(net, set, rbe);
+			nft_rbtree_flush(net, set, rbe);
 			return rbe;
 		}
 	}
@@ -305,7 +305,7 @@ static struct nft_set_ops nft_rbtree_ops __read_mostly = {
 	.insert		= nft_rbtree_insert,
 	.remove		= nft_rbtree_remove,
 	.deactivate	= nft_rbtree_deactivate,
-	.deactivate_one	= nft_rbtree_deactivate_one,
+	.flush		= nft_rbtree_flush,
 	.activate	= nft_rbtree_activate,
 	.lookup		= nft_rbtree_lookup,
 	.walk		= nft_rbtree_walk,
-- 
2.1.4

