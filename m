From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/5] netfilter: nft_hash: add support for timeouts
Date: Thu, 26 Mar 2015 12:39:40 +0000
Message-ID: <1427373580-19310-6-git-send-email-kaber@trash.net>
References: <1427373580-19310-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58133 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbCZMjr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 08:39:47 -0400
In-Reply-To: <1427373580-19310-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for element timeouts to nft_hash. The lookup and walking
functions are changed to ignore timed out elements, a periodic garbage
collection task cleans out expired entries.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  5 +++
 net/netfilter/nft_hash.c          | 80 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1ea13fc..a785699 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -294,6 +294,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
+static inline struct nft_set *nft_set_container_of(const void *priv)
+{
+	return (void *)priv - offsetof(struct nft_set, data);
+}
+
 struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 				     const struct nlattr *nla);
 struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index c7e1a9d..2a00da9 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -15,6 +15,7 @@
 #include <linux/log2.h>
 #include <linux/jhash.h>
 #include <linux/netlink.h>
+#include <linux/workqueue.h>
 #include <linux/rhashtable.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -25,6 +26,7 @@
 
 struct nft_hash {
 	struct rhashtable		ht;
+	struct delayed_work		gc_work;
 };
 
 struct nft_hash_elem {
@@ -62,6 +64,8 @@ static inline int nft_hash_cmp(struct rhashtable_compare_arg *arg,
 
 	if (nft_data_cmp(nft_set_ext_key(&he->ext), x->key, x->set->klen))
 		return 1;
+	if (nft_set_elem_expired(&he->ext))
+		return 1;
 	if (!nft_set_elem_active(&he->ext, x->genmask))
 		return 1;
 	return 0;
@@ -107,6 +111,7 @@ static void nft_hash_activate(const struct nft_set *set,
 	struct nft_hash_elem *he = elem->priv;
 
 	nft_set_elem_change_active(set, &he->ext);
+	nft_set_elem_clear_busy(&he->ext);
 }
 
 static void *nft_hash_deactivate(const struct nft_set *set,
@@ -120,9 +125,15 @@ static void *nft_hash_deactivate(const struct nft_set *set,
 		.key	 = &elem->key,
 	};
 
+	rcu_read_lock();
 	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_hash_params);
-	if (he != NULL)
-		nft_set_elem_change_active(set, &he->ext);
+	if (he != NULL) {
+		if (!nft_set_elem_mark_busy(&he->ext))
+			nft_set_elem_change_active(set, &he->ext);
+		else
+			he = NULL;
+	}
+	rcu_read_unlock();
 
 	return he;
 }
@@ -170,6 +181,8 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 
 		if (iter->count < iter->skip)
 			goto cont;
+		if (nft_set_elem_expired(&he->ext))
+			goto cont;
 		if (!nft_set_elem_active(&he->ext, genmask))
 			goto cont;
 
@@ -188,6 +201,54 @@ out:
 	rhashtable_walk_exit(&hti);
 }
 
+static void nft_hash_gc(struct work_struct *work)
+{
+	const struct nft_set *set;
+	struct nft_hash_elem *he;
+	struct nft_hash *priv;
+	struct nft_set_gc_batch *gcb = NULL;
+	struct rhashtable_iter hti;
+	int err;
+
+	priv = container_of(work, struct nft_hash, gc_work.work);
+	set  = nft_set_container_of(priv);
+
+	err = rhashtable_walk_init(&priv->ht, &hti);
+	if (err)
+		goto schedule;
+
+	err = rhashtable_walk_start(&hti);
+	if (err && err != -EAGAIN)
+		goto out;
+
+	while ((he = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(he)) {
+			if (PTR_ERR(he) != -EAGAIN)
+				goto out;
+			continue;
+		}
+
+		if (!nft_set_elem_expired(&he->ext))
+			continue;
+		if (nft_set_elem_mark_busy(&he->ext))
+			continue;
+
+		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+		if (gcb == NULL)
+			goto out;
+		rhashtable_remove_fast(&priv->ht, &he->node, nft_hash_params);
+		nft_set_gc_batch_add(gcb, he);
+	}
+out:
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+
+	nft_set_gc_batch_complete(gcb);
+schedule:
+	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
+			   nft_set_gc_interval(set));
+}
+
 static unsigned int nft_hash_privsize(const struct nlattr * const nla[])
 {
 	return sizeof(struct nft_hash);
@@ -207,11 +268,20 @@ static int nft_hash_init(const struct nft_set *set,
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct rhashtable_params params = nft_hash_params;
+	int err;
 
 	params.nelem_hint = desc->size ?: NFT_HASH_ELEMENT_HINT;
 	params.key_len	  = set->klen;
 
-	return rhashtable_init(&priv->ht, &params);
+	err = rhashtable_init(&priv->ht, &params);
+	if (err < 0)
+		return err;
+
+	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_hash_gc);
+	if (set->flags & NFT_SET_TIMEOUT)
+		queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
+				   nft_set_gc_interval(set));
+	return 0;
 }
 
 static void nft_hash_elem_destroy(void *ptr, void *arg)
@@ -223,6 +293,7 @@ static void nft_hash_destroy(const struct nft_set *set)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 
+	cancel_delayed_work_sync(&priv->gc_work);
 	rhashtable_free_and_destroy(&priv->ht, nft_hash_elem_destroy,
 				    (void *)set);
 }
@@ -264,7 +335,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
 	.remove		= nft_hash_remove,
 	.lookup		= nft_hash_lookup,
 	.walk		= nft_hash_walk,
-	.features	= NFT_SET_MAP,
+	.features	= NFT_SET_MAP | NFT_SET_TIMEOUT,
 	.owner		= THIS_MODULE,
 };
 
@@ -284,3 +355,4 @@ module_exit(nft_hash_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_SET();
+
-- 
2.1.0

