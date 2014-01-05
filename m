From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: nf_tables: fix suboptimal set selection
Date: Sun,  5 Jan 2014 22:18:46 +0100
Message-ID: <1388956728-6754-2-git-send-email-pablo@netfilter.org>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaAEVTI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:19:08 -0500
In-Reply-To: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The rb-tree is currently used for simple sets and maps with no
intervals which is suboptimal. Fix it by adding the weight field
to each existing set implementation, this value allows to select
the best candidate in case that several set types can be used.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   13 +++++++++++++
 net/netfilter/nf_tables_api.c     |   10 +++++-----
 net/netfilter/nft_hash.c          |    1 +
 net/netfilter/nft_rbtree.c        |    1 +
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a91abf..82920e8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -143,6 +143,17 @@ struct nft_set_iter {
 };
 
 /**
+ *	enum nft_set_prio - nf_tables set priority
+ *
+ *	This is used to set preference in case that all set types provide the
+ *	same features.
+ */
+enum nft_set_prio {
+	NFT_SET_PRIO_HASH	= 0,
+	NFT_SET_PRIO_RBTREE,
+};
+
+/**
  *	struct nft_set_ops - nf_tables set operations
  *
  *	@lookup: look up an element within the set
@@ -155,6 +166,7 @@ struct nft_set_iter {
  *	@list: nf_tables_set_ops list node
  *	@owner: module reference
  *	@features: features supported by the implementation
+ *	@priority: priority of this set type
  */
 struct nft_set_ops {
 	bool				(*lookup)(const struct nft_set *set,
@@ -178,6 +190,7 @@ struct nft_set_ops {
 	struct list_head		list;
 	struct module			*owner;
 	u32				features;
+	u32				priority;
 };
 
 int nft_register_set(struct nft_set_ops *ops);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0d4b42d..60efb61 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1857,7 +1857,7 @@ EXPORT_SYMBOL_GPL(nft_unregister_set);
 
 static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const nla[])
 {
-	const struct nft_set_ops *ops;
+	const struct nft_set_ops *ops, *cand = NULL;
 	u32 features;
 
 #ifdef CONFIG_MODULES
@@ -1875,14 +1875,14 @@ static const struct nft_set_ops *nft_select_set_ops(const struct nlattr * const
 		features &= NFT_SET_INTERVAL | NFT_SET_MAP;
 	}
 
-	// FIXME: implement selection properly
 	list_for_each_entry(ops, &nf_tables_set_ops, list) {
 		if ((ops->features & features) != features)
 			continue;
-		if (!try_module_get(ops->owner))
-			continue;
-		return ops;
+		if (!cand || cand->priority > ops->priority)
+			cand = ops;
 	}
+	if (cand && try_module_get(cand->owner))
+		return 0;
 
 	return ERR_PTR(-EOPNOTSUPP);
 }
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 3d3f8fc..f640c1c 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -210,6 +210,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
 	.lookup		= nft_hash_lookup,
 	.walk		= nft_hash_walk,
 	.features	= NFT_SET_MAP,
+	.priority	= NFT_SET_PRIO_HASH,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index ca0c1b2..acddc64 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -226,6 +226,7 @@ static struct nft_set_ops nft_rbtree_ops __read_mostly = {
 	.lookup		= nft_rbtree_lookup,
 	.walk		= nft_rbtree_walk,
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP,
+	.priority	= NFT_SET_PRIO_RBTREE,
 	.owner		= THIS_MODULE,
 };
 
-- 
1.7.10.4

