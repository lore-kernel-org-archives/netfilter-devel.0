Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9718082D7A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801217; cv=none; b=U0m4ch8lI4hzdDAyxX0iJCHyPqyQ3shFU8lFqpVW3PE6kwZ+gJu+9a3JSZEwW69jfIDbUCbHP0k6Q4i2G3es/rKEknNDD39rZa7s1GSHFsisrWx0nu4F7O3oqsbV+zdXFqy+jyAcqZ7tYjMJc7ViARKlcmF4wMwCERwVRlQz+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801217; c=relaxed/simple;
	bh=YmsMTE5Xn8lBYoe4nEM0bZH3Piqy2+41Vudy4UqprHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR9AUTCEJb+u01iVJG4Q+fU/cXpESQIJIrllCsjjKvfZxUS45wrmdLfE74GEQMnXRIGe3GW51fO8xr+YdkrBd4fECBHCTAT5PmELLJQ4MfAeAcjLfACa0RkHCjkohA581k9aM9Sr5S9qVzF+wzVs4BhqGvE5OBCJOLgtx3f3D5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9Ow-0005MD-4f; Thu, 07 Mar 2024 09:46:54 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/9] netfilter: nf_tables: prepare for key-based deletion from workqueue
Date: Thu,  7 Mar 2024 09:40:11 +0100
Message-ID: <20240307084018.2219-8-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment async gc stores pointers to the to-be-removed
elements, async workqueue removes and them.

This works but has a few drawbacks:
Care must be taken so no pointers is posted twice, else we get
double-free.

This makes it necessary to skip a gc cycle if the work queue
is still scheduled, even though the given set has no pending
gc deletions.

Because pointers are used, we also have to consider userspace
transactions flushing/altering the set while gc is pending,
for this reason we have to back out if userspace made some changes,
even though the set might not have been affected at all and all
queued element pointers are still valid.

Now that rhashtable backend is the only remaining async gc
worker, lets simplify this.

Instead of storing pointers, store a copy of the element keys
that have expired.

Then, from work queue with transaction mutex held, query
the set for the given key.

If its found and expired, remove it.

IOW, the idea is to collect *candidates* to examine
for expiration, not element pointers.

If the element got removed, element lookup will return
no match and key is skipped, same if the key isn't expired
(i.e. userspace flushed and repopulated the set with
 identical, active key).

This is an intermediate step:
We still store pointers and use them, but also store the keys.
We then validate that lookup does returns the expected pointer.

Use WARN()s, they are not expected to trigger because the
gc sequence checks are still in place.

Next patch can remove the gc sequence counter and only rely
on the key lookup.

The batchcount is lowered so that the nft_trans_gc allocations are
taken from kmalloc-2k cache.

"struct nft_trans_gc_key" could be "union nft_trans_gc_key", but
this only provides space for 4 more keyslots per nft_trans_gc
object, so this is probably not worth the extra risk from aliasing
key and to_free stash pointer.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 10 ++++--
 net/netfilter/nf_tables_api.c     | 58 +++++++++++++++++++++++++++----
 net/netfilter/nft_set_hash.c      |  2 +-
 3 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 12a1ded88182..6896279edb92 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1733,7 +1733,12 @@ struct nft_trans_flowtable {
 #define nft_trans_flowtable_flags(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->flags)
 
-#define NFT_TRANS_GC_BATCHCOUNT	256
+#define NFT_TRANS_GC_BATCHCOUNT	27
+
+struct nft_trans_gc_key {
+	u32 key[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
+	struct nft_elem_priv	*priv;
+};
 
 struct nft_trans_gc {
 	struct list_head	list;
@@ -1741,7 +1746,7 @@ struct nft_trans_gc {
 	struct nft_set		*set;
 	u32			seq;
 	u16			count;
-	struct nft_elem_priv	*priv[NFT_TRANS_GC_BATCHCOUNT];
+	struct nft_trans_gc_key keys[NFT_TRANS_GC_BATCHCOUNT];
 	struct rcu_head		rcu;
 };
 
@@ -1756,6 +1761,7 @@ void nft_trans_gc_queue_async_done(struct nft_trans_gc *gc);
 struct nft_trans_gc *nft_trans_gc_queue_sync(struct nft_trans_gc *gc, gfp_t gfp);
 void nft_trans_gc_queue_sync_done(struct nft_trans_gc *trans);
 
+void nft_async_gc_key_add(struct nft_trans_gc *gc, struct nft_elem_priv *priv);
 void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv);
 
 void nft_trans_gc_catchall_sync(const struct nft_trans_gc *gc);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c390ffec9b7b..f1edbff734f6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1647,6 +1647,13 @@ static bool lockdep_commit_lock_is_held(const struct net *net)
 #endif
 }
 
+static void nft_commit_lock_not_held(const struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	lockdep_assert_not_held(&nft_net->commit_mutex);
+}
+
 static struct nft_chain *nft_chain_lookup(struct net *net,
 					  struct nft_table *table,
 					  const struct nlattr *nla, u8 genmask)
@@ -9663,13 +9670,34 @@ void nft_chain_del(struct nft_chain *chain)
 static void nft_trans_gc_setelem_remove(struct nft_ctx *ctx,
 					struct nft_trans_gc *trans)
 {
-	struct nft_elem_priv **priv = trans->priv;
 	unsigned int i;
 
+	rcu_read_lock();
+
 	for (i = 0; i < trans->count; i++) {
-		nft_setelem_data_deactivate(ctx->net, trans->set, priv[i]);
-		nft_setelem_remove(ctx->net, trans->set, priv[i]);
+		struct nft_trans_gc_key *key = &trans->keys[i];
+		const struct nft_set_ext *ext;
+		struct nft_set_elem elem;
+		int err;
+
+		memset(&elem, 0, sizeof(elem));
+
+		BUILD_BUG_ON(sizeof(elem.key) != sizeof(key->key));
+		memcpy(&elem.key, key->key, sizeof(elem.key));
+
+		err = nft_setelem_get(ctx, trans->set, &elem, NFT_SET_ELEM_GET_DEAD);
+		WARN_ON(err < 0);
+		WARN_ON(key->priv != elem.priv);
+
+		ext = nft_set_elem_ext(trans->set, elem.priv);
+		/* nft_dynset can mark non-expired as DEAD, remove those too */
+		if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext)) {
+			nft_setelem_data_deactivate(ctx->net, trans->set, elem.priv);
+			nft_setelem_remove(ctx->net, trans->set, elem.priv);
+		}
 	}
+
+	rcu_read_unlock();
 }
 
 void nft_trans_gc_destroy(struct nft_trans_gc *trans)
@@ -9690,7 +9718,7 @@ static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 	ctx.net	= read_pnet(&trans->set->net);
 
 	for (i = 0; i < trans->count; i++) {
-		elem_priv = trans->priv[i];
+		elem_priv = trans->keys[i].priv;
 		if (!nft_setelem_is_catchall(trans->set, elem_priv))
 			atomic_dec(&trans->set->nelems);
 
@@ -9818,9 +9846,27 @@ struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 	return trans;
 }
 
-void nft_trans_gc_elem_add(struct nft_trans_gc *trans, void *priv)
+void nft_trans_gc_elem_add(struct nft_trans_gc *gc, void *priv)
+{
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(gc->net));
+	gc->keys[gc->count].to_free = priv;
+	gc->count++;
+}
+
+void nft_async_gc_key_add(struct nft_trans_gc *gc, struct nft_elem_priv *priv)
 {
-	trans->priv[trans->count++] = priv;
+	const struct nft_set *set = gc->set;
+	const struct nft_set_ext *ext;
+
+	nft_commit_lock_not_held(gc->net);
+
+	memset(&gc->keys[gc->count], 0, sizeof(gc->keys[0]));
+
+	ext = nft_set_elem_ext(set, priv);
+	memcpy(gc->keys[gc->count].key, nft_set_ext_key(ext), set->klen);
+
+	gc->keys[gc->count].priv = priv;
+	gc->count++;
 }
 
 static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 6bf53c7eb8cf..4b3cc2e17784 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -378,7 +378,7 @@ static void nft_rhash_gc(struct work_struct *work)
 		if (!gc)
 			goto try_later;
 
-		nft_trans_gc_elem_add(gc, he);
+		nft_async_gc_key_add(gc, &he->priv);
 	}
 
 try_later:
-- 
2.43.0

