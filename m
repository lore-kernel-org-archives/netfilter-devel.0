Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62701CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbjJSOUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346021AbjJSOUL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:20:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54F82131
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:20:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 6/8] netfilter: nf_tables: use timestamp to check for set element timeout
Date:   Thu, 19 Oct 2023 16:19:56 +0200
Message-Id: <20231019141958.653727-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231019141958.653727-1-pablo@netfilter.org>
References: <20231019141958.653727-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a timestamp field at the beginning of the transaction, store it
in the nftables per-netns area.

Update set backend .insert, .deactivate and sync gc path to use the
timestamp, this avoids that an element expires while control plane
transaction is still unfinished.

.lookup and .update, which are used from packet path, still use the
current time to check if the element has expired. And .get path also
since this runs lockless.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 16 ++++++++++++++--
 net/netfilter/nf_tables_api.c     | 10 ++++++----
 net/netfilter/nft_set_hash.c      |  6 ++++++
 net/netfilter/nft_set_pipapo.c    | 17 ++++++++++-------
 net/netfilter/nft_set_rbtree.c    |  6 ++++--
 5 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c97c63400d95..0243ed6c36c5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -798,10 +798,16 @@ static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ex
 	return nft_set_ext(ext, NFT_SET_EXT_EXPRESSIONS);
 }
 
-static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
+static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
+					  u64 tstamp)
 {
 	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_is_before_eq_jiffies64(*nft_set_ext_expiration(ext));
+	       time_after_eq64(tstamp, *nft_set_ext_expiration(ext));
+}
+
+static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
+{
+	return __nft_set_elem_expired(ext, get_jiffies_64());
 }
 
 static inline struct nft_set_ext *nft_set_elem_ext(const struct nft_set *set,
@@ -1745,6 +1751,7 @@ struct nftables_pernet {
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
 	u64			table_handle;
+	u64			tstamp;
 	unsigned int		base_seq;
 	unsigned int		gc_seq;
 	u8			validate_state;
@@ -1757,6 +1764,11 @@ static inline struct nftables_pernet *nft_pernet(const struct net *net)
 	return net_generic(net, nf_tables_net_id);
 }
 
+static inline u64 nft_net_tstamp(const struct net *net)
+{
+	return nft_pernet(net)->tstamp;
+}
+
 #define __NFT_REDUCE_READONLY	1UL
 #define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 568c54e0d314..8c821135a5a0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9617,7 +9617,7 @@ void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans)
 
 static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 						  unsigned int gc_seq,
-						  bool sync)
+						  bool sync, u64 tstamp)
 {
 	struct nft_set_elem_catchall *catchall;
 	const struct nft_set *set = gc->set;
@@ -9626,7 +9626,7 @@ static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 
-		if (!nft_set_elem_expired(ext))
+		if (!__nft_set_elem_expired(ext, tstamp))
 			continue;
 		if (nft_set_elem_is_dead(ext))
 			goto dead_elem;
@@ -9650,12 +9650,12 @@ static struct nft_trans_gc *nft_trans_gc_catchall(struct nft_trans_gc *gc,
 struct nft_trans_gc *nft_trans_gc_catchall_async(struct nft_trans_gc *gc,
 						 unsigned int gc_seq)
 {
-	return nft_trans_gc_catchall(gc, gc_seq, false);
+	return nft_trans_gc_catchall(gc, gc_seq, false, get_jiffies_64());
 }
 
 struct nft_trans_gc *nft_trans_gc_catchall_sync(struct nft_trans_gc *gc)
 {
-	return nft_trans_gc_catchall(gc, 0, true);
+	return nft_trans_gc_catchall(gc, 0, true, nft_net_tstamp(gc->net));
 }
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
@@ -10435,6 +10435,8 @@ static bool nf_tables_valid_genid(struct net *net, u32 genid)
 	if (!genid_ok)
 		mutex_unlock(&nft_net->commit_mutex);
 
+	nft_net->tstamp = get_jiffies_64();
+
 	/* else, commit mutex has to be released by commit or abort function */
 	return genid_ok;
 }
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 0c5aca6100db..dd58a7c8847c 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -36,6 +36,7 @@ struct nft_rhash_cmp_arg {
 	const struct nft_set		*set;
 	const u32			*key;
 	u8				genmask;
+	u64				tstamp;
 };
 
 static inline u32 nft_rhash_key(const void *data, u32 len, u32 seed)
@@ -87,6 +88,7 @@ bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 		.genmask = nft_genmask_cur(net),
 		.set	 = set,
 		.key	 = key,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -106,6 +108,7 @@ nft_rhash_get(const struct net *net, const struct nft_set *set,
 		.genmask = nft_genmask_cur(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -131,6 +134,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 		.genmask = NFT_GENMASK_ANY,
 		.set	 = set,
 		.key	 = key,
+		.tstamp  = get_jiffies_64(),
 	};
 
 	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
@@ -175,6 +179,7 @@ static int nft_rhash_insert(const struct net *net, const struct nft_set *set,
 		.genmask = nft_genmask_next(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp	 = nft_net_tstamp(net),
 	};
 	struct nft_rhash_elem *prev;
 
@@ -216,6 +221,7 @@ nft_rhash_deactivate(const struct net *net, const struct nft_set *set,
 		.genmask = nft_genmask_next(net),
 		.set	 = set,
 		.key	 = elem->key.val.data,
+		.tstamp	 = nft_net_tstamp(net),
 	};
 
 	rcu_read_lock();
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c62a5a941a17..33920c7f1cfa 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -513,7 +513,8 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  */
 static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 					  const struct nft_set *set,
-					  const u8 *data, u8 genmask)
+					  const u8 *data, u8 genmask,
+					  u64 tstamp)
 {
 	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
 	struct nft_pipapo *priv = nft_set_priv(set);
@@ -566,7 +567,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 			goto out;
 
 		if (last) {
-			if (nft_set_elem_expired(&f->mt[b].e->ext))
+			if (__nft_set_elem_expired(&f->mt[b].e->ext, tstamp))
 				goto next_match;
 			if ((genmask &&
 			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
@@ -606,7 +607,7 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	static struct nft_pipapo_elem *e;
 
 	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
-		       nft_genmask_cur(net));
+		       nft_genmask_cur(net), get_jiffies_64());
 	if (IS_ERR(e))
 		return ERR_CAST(e);
 
@@ -1173,6 +1174,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_elem *e, *dup;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_pipapo_field *f;
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
@@ -1182,7 +1184,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, start, genmask);
+	dup = pipapo_get(net, set, start, genmask, tstamp);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1204,7 +1206,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, end, nft_genmask_next(net));
+		dup = pipapo_get(net, set, end, nft_genmask_next(net), tstamp);
 	}
 
 	if (PTR_ERR(dup) != -ENOENT) {
@@ -1561,6 +1563,7 @@ static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
 	struct nft_set *set = (struct nft_set *) _set;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
+	u64 tstamp = nft_net_tstamp(net);
 	int rules_f0, first_rule = 0;
 	struct nft_pipapo_elem *e;
 	struct nft_trans_gc *gc;
@@ -1595,7 +1598,7 @@ static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
 		/* synchronous gc never fails, there is no need to set on
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
-		if (nft_set_elem_expired(&e->ext)) {
+		if (__nft_set_elem_expired(&e->ext, tstamp)) {
 			priv->dirty = true;
 
 			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
@@ -1770,7 +1773,7 @@ static void *pipapo_deactivate(const struct net *net, const struct nft_set *set,
 {
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, data, nft_genmask_next(net));
+	e = pipapo_get(net, set, data, nft_genmask_next(net), nft_net_tstamp(net));
 	if (IS_ERR(e))
 		return NULL;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index f11b210e6cff..258e11b3aeca 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -313,6 +313,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -360,7 +361,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		/* perform garbage collection to avoid bogus overlap reports
 		 * but skip new elements in this transaction.
 		 */
-		if (nft_set_elem_expired(&rbe->ext) &&
+		if (__nft_set_elem_expired(&rbe->ext, tstamp) &&
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			const struct nft_rbtree_elem *removed_end;
 
@@ -546,6 +547,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	int d;
 
 	while (parent != NULL) {
@@ -566,7 +568,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
-			} else if (nft_set_elem_expired(&rbe->ext)) {
+			} else if (__nft_set_elem_expired(&rbe->ext, tstamp)) {
 				break;
 			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;
-- 
2.30.2

