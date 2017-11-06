From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: get set elements via netlink
Date: Mon,  6 Nov 2017 16:41:07 +0100
Message-ID: <20171106154107.15722-2-pablo@netfilter.org>
References: <20171106154107.15722-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdKFPlW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 10:41:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD5EA1BFA81
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA0D1DA843
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B9D1DA843
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:18 +0100 (CET)
Received: from salvia.here (unknown [27.1.3.195])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AA1F7403DF98
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2017 16:41:16 +0100 (CET)
In-Reply-To: <20171106154107.15722-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new get operation for sets to look up for an elements
from userspace via netlink interface.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   5 ++
 net/netfilter/nf_tables_api.c     | 184 ++++++++++++++++++++++++++------------
 net/netfilter/nft_set_bitmap.c    |  18 ++++
 net/netfilter/nft_set_hash.c      |  39 ++++++++
 net/netfilter/nft_set_rbtree.c    |  73 +++++++++++++++
 5 files changed, 264 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0f5b12a4ad09..d011e56cc7a9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -311,6 +311,7 @@ struct nft_expr;
  *	@flush: deactivate element in the next generation
  *	@remove: remove element from set
  *	@walk: iterate over all set elemeennts
+ *	@get: get set elements
  *	@privsize: function to return size of set private data
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
@@ -350,6 +351,10 @@ struct nft_set_ops {
 	void				(*walk)(const struct nft_ctx *ctx,
 						struct nft_set *set,
 						struct nft_set_iter *iter);
+	void *				(*get)(const struct net *net,
+					       const struct nft_set *set,
+					       const struct nft_set_elem *elem,
+					       unsigned int flags);
 
 	unsigned int			(*privsize)(const struct nlattr * const nla[],
 						    const struct nft_set_desc *desc);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3b4a0739ee39..1d66be0d8ef7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3586,45 +3586,6 @@ static int nf_tables_dump_set_done(struct netlink_callback *cb)
 	return 0;
 }
 
-static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const nla[],
-				struct netlink_ext_ack *extack)
-{
-	u8 genmask = nft_genmask_cur(net);
-	const struct nft_set *set;
-	struct nft_ctx ctx;
-	int err;
-
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
-	if (err < 0)
-		return err;
-
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
-				   genmask);
-	if (IS_ERR(set))
-		return PTR_ERR(set);
-
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.dump = nf_tables_dump_set,
-			.done = nf_tables_dump_set_done,
-		};
-		struct nft_set_dump_ctx *dump_ctx;
-
-		dump_ctx = kmalloc(sizeof(*dump_ctx), GFP_KERNEL);
-		if (!dump_ctx)
-			return -ENOMEM;
-
-		dump_ctx->set = set;
-		dump_ctx->ctx = ctx;
-
-		c.data = dump_ctx;
-		return netlink_dump_start(nlsk, skb, nlh, &c);
-	}
-	return -EOPNOTSUPP;
-}
-
 static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 				       const struct nft_ctx *ctx, u32 seq,
 				       u32 portid, int event, u16 flags,
@@ -3670,6 +3631,135 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_setelem_parse_flags(const struct nft_set *set,
+				   const struct nlattr *attr, u32 *flags)
+{
+	if (attr == NULL)
+		return 0;
+
+	*flags = ntohl(nla_get_be32(attr));
+	if (*flags & ~NFT_SET_ELEM_INTERVAL_END)
+		return -EINVAL;
+	if (!(set->flags & NFT_SET_INTERVAL) &&
+	    *flags & NFT_SET_ELEM_INTERVAL_END)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
+			    const struct nlattr *attr)
+{
+	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
+	const struct nft_set_ext *ext;
+	struct nft_data_desc desc;
+	struct nft_set_elem elem;
+	struct sk_buff *skb;
+	uint32_t flags = 0;
+	void *priv;
+	int err;
+
+	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
+			       nft_set_elem_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!nla[NFTA_SET_ELEM_KEY])
+		return -EINVAL;
+
+	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
+	if (err < 0)
+		return err;
+
+	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
+			    nla[NFTA_SET_ELEM_KEY]);
+	if (err < 0)
+		return err;
+
+	err = -EINVAL;
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
+		return err;
+
+	priv = set->ops->get(ctx->net, set, &elem, flags);
+	if (IS_ERR(priv))
+		return PTR_ERR(priv);
+
+	elem.priv = priv;
+	ext = nft_set_elem_ext(set, &elem);
+
+	err = -ENOMEM;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err1;
+
+	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
+					  NFT_MSG_NEWSETELEM, 0, set, &elem);
+	if (err < 0)
+		goto err2;
+
+	err = nfnetlink_unicast(skb, ctx->net, ctx->portid, MSG_DONTWAIT);
+	/* This avoids a loop in nfnetlink. */
+	if (err < 0)
+		goto err1;
+
+	return 0;
+err2:
+	kfree_skb(skb);
+err1:
+	/* this avoids a loop in nfnetlink. */
+	return err == -EAGAIN ? -ENOBUFS : err;
+}
+
+static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
+				struct sk_buff *skb, const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[],
+				struct netlink_ext_ack *extack)
+{
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set *set;
+	struct nlattr *attr;
+	struct nft_ctx ctx;
+	int rem, err = 0;
+
+	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
+	if (err < 0)
+		return err;
+
+	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
+				   genmask);
+	if (IS_ERR(set))
+		return PTR_ERR(set);
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.dump = nf_tables_dump_set,
+			.done = nf_tables_dump_set_done,
+		};
+		struct nft_set_dump_ctx *dump_ctx;
+
+		dump_ctx = kmalloc(sizeof(*dump_ctx), GFP_KERNEL);
+		if (!dump_ctx)
+			return -ENOMEM;
+
+		dump_ctx->set = set;
+		dump_ctx->ctx = ctx;
+
+		c.data = dump_ctx;
+		return netlink_dump_start(nlsk, skb, nlh, &c);
+	}
+
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return -EINVAL;
+
+	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
+		err = nft_get_set_elem(&ctx, set, attr);
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
 static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 				     const struct nft_set *set,
 				     const struct nft_set_elem *elem,
@@ -3770,22 +3860,6 @@ static void nf_tables_set_elem_destroy(const struct nft_set *set, void *elem)
 	kfree(elem);
 }
 
-static int nft_setelem_parse_flags(const struct nft_set *set,
-				   const struct nlattr *attr, u32 *flags)
-{
-	if (attr == NULL)
-		return 0;
-
-	*flags = ntohl(nla_get_be32(attr));
-	if (*flags & ~NFT_SET_ELEM_INTERVAL_END)
-		return -EINVAL;
-	if (!(set->flags & NFT_SET_INTERVAL) &&
-	    *flags & NFT_SET_ELEM_INTERVAL_END)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 734989c40579..45fb2752fb63 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -106,6 +106,23 @@ nft_bitmap_elem_find(const struct nft_set *set, struct nft_bitmap_elem *this,
 	return NULL;
 }
 
+static void *nft_bitmap_get(const struct net *net, const struct nft_set *set,
+			    const struct nft_set_elem *elem, unsigned int flags)
+{
+	const struct nft_bitmap *priv = nft_set_priv(set);
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_bitmap_elem *be;
+
+	list_for_each_entry_rcu(be, &priv->list, head) {
+		if (memcmp(nft_set_ext_key(&be->ext), elem->key.val.data, set->klen) ||
+		    !nft_set_elem_active(&be->ext, genmask))
+			continue;
+
+		return be;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static int nft_bitmap_insert(const struct net *net, const struct nft_set *set,
 			     const struct nft_set_elem *elem,
 			     struct nft_set_ext **ext)
@@ -294,6 +311,7 @@ static struct nft_set_ops nft_bitmap_ops __read_mostly = {
 	.activate	= nft_bitmap_activate,
 	.lookup		= nft_bitmap_lookup,
 	.walk		= nft_bitmap_walk,
+	.get		= nft_bitmap_get,
 };
 
 static struct nft_set_type nft_bitmap_type __read_mostly = {
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 0fa01d772c5e..155783ee4baa 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -95,6 +95,24 @@ static bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 	return !!he;
 }
 
+static void *nft_rhash_get(const struct net *net, const struct nft_set *set,
+			   const struct nft_set_elem *elem, unsigned int flags)
+{
+	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_elem *he;
+	struct nft_rhash_cmp_arg arg = {
+		.genmask = nft_genmask_cur(net),
+		.set	 = set,
+		.key	 = elem->key.val.data,
+	};
+
+	he = rhashtable_lookup_fast(&priv->ht, &arg, nft_rhash_params);
+	if (he != NULL)
+		return he;
+
+	return ERR_PTR(-ENOENT);
+}
+
 static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 			     void *(*new)(struct nft_set *,
 					  const struct nft_expr *,
@@ -409,6 +427,24 @@ static bool nft_hash_lookup(const struct net *net, const struct nft_set *set,
 	return false;
 }
 
+static void *nft_hash_get(const struct net *net, const struct nft_set *set,
+			  const struct nft_set_elem *elem, unsigned int flags)
+{
+	struct nft_hash *priv = nft_set_priv(set);
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_hash_elem *he;
+	u32 hash;
+
+	hash = jhash(elem->key.val.data, set->klen, priv->seed);
+	hash = reciprocal_scale(hash, priv->buckets);
+	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
+		if (!memcmp(nft_set_ext_key(&he->ext), elem->key.val.data, set->klen) &&
+		    nft_set_elem_active(&he->ext, genmask))
+			return he;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 /* nft_hash_select_ops() makes sure key size can be either 2 or 4 bytes . */
 static inline u32 nft_hash_key(const u32 *key, u32 klen)
 {
@@ -600,6 +636,7 @@ static struct nft_set_ops nft_rhash_ops __read_mostly = {
 	.lookup		= nft_rhash_lookup,
 	.update		= nft_rhash_update,
 	.walk		= nft_rhash_walk,
+	.get		= nft_rhash_get,
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 };
 
@@ -617,6 +654,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
 	.remove		= nft_hash_remove,
 	.lookup		= nft_hash_lookup,
 	.walk		= nft_hash_walk,
+	.get		= nft_hash_get,
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 };
 
@@ -634,6 +672,7 @@ static struct nft_set_ops nft_hash_fast_ops __read_mostly = {
 	.remove		= nft_hash_remove,
 	.lookup		= nft_hash_lookup_fast,
 	.walk		= nft_hash_walk,
+	.get		= nft_hash_get,
 	.features	= NFT_SET_MAP | NFT_SET_OBJECT,
 };
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index d83a4ec5900d..e6f08bc5f359 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -113,6 +113,78 @@ static bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
 	return ret;
 }
 
+static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
+			     const u32 *key, struct nft_rbtree_elem **elem,
+			     unsigned int seq, unsigned int flags, u8 genmask)
+{
+	struct nft_rbtree_elem *rbe, *interval = NULL;
+	struct nft_rbtree *priv = nft_set_priv(set);
+	const struct rb_node *parent;
+	const void *this;
+	int d;
+
+	parent = rcu_dereference_raw(priv->root.rb_node);
+	while (parent != NULL) {
+		if (read_seqcount_retry(&priv->count, seq))
+			return false;
+
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+
+		this = nft_set_ext_key(&rbe->ext);
+		d = memcmp(this, key, set->klen);
+		if (d < 0) {
+			parent = rcu_dereference_raw(parent->rb_left);
+			interval = rbe;
+		} else if (d > 0) {
+			parent = rcu_dereference_raw(parent->rb_right);
+		} else {
+			if (!nft_set_elem_active(&rbe->ext, genmask))
+				parent = rcu_dereference_raw(parent->rb_left);
+
+			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
+			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
+			    (flags & NFT_SET_ELEM_INTERVAL_END)) {
+				*elem = rbe;
+				return true;
+			}
+			return false;
+		}
+	}
+
+	if (set->flags & NFT_SET_INTERVAL && interval != NULL &&
+	    nft_set_elem_active(&interval->ext, genmask) &&
+	    !nft_rbtree_interval_end(interval)) {
+		*elem = interval;
+		return true;
+	}
+
+	return false;
+}
+
+static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
+			    const struct nft_set_elem *elem, unsigned int flags)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	unsigned int seq = read_seqcount_begin(&priv->count);
+	struct nft_rbtree_elem *rbe = ERR_PTR(-ENOENT);
+	const u32 *key = (const u32 *)&elem->key.val;
+	u8 genmask = nft_genmask_cur(net);
+	bool ret;
+
+	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
+	if (ret || !read_seqcount_retry(&priv->count, seq))
+		return rbe;
+
+	read_lock_bh(&priv->lock);
+	seq = read_seqcount_begin(&priv->count);
+	ret = __nft_rbtree_get(net, set, key, &rbe, seq, flags, genmask);
+	if (!ret)
+		rbe = ERR_PTR(-ENOENT);
+	read_unlock_bh(&priv->lock);
+
+	return rbe;
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
@@ -336,6 +408,7 @@ static struct nft_set_ops nft_rbtree_ops __read_mostly = {
 	.activate	= nft_rbtree_activate,
 	.lookup		= nft_rbtree_lookup,
 	.walk		= nft_rbtree_walk,
+	.get		= nft_rbtree_get,
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT,
 };
 
-- 
2.11.0

