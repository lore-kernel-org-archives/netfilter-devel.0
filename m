Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CCF82C8E
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801196; cv=none; b=tMNLyAAFwDfx0BG9j7/5hxI3JoazJN0fnHvIMJmKimDdvXkH6GgvAWwH67JPASZvgCJjMoCcOhL5a2cEfsTJSEUBIYHKUVnqK8xAhQdgYc4Y9upwXttapiHv4SBSQpWBVJQj81nBt/MQfuYoEi6RCTzv/YDtml6xI9b5NZEzmKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801196; c=relaxed/simple;
	bh=r75j19X4+1UwW/N/AAdUn8EEBrmjVDCAnbKvFWldbS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD58vsc6w1ee7x158t0132McXBDE2p84rHEfUtaNOBsl2aVo2YTbLtCK6+cU6iBoUm6Bbo5hsbGjzG/0i/UXtiXX6Qdnq89Ez10k7do73hlSkMkjbeA8mXLGa48mkh7vDJA/xXqUM793gRLDfFaU6eDg4ZXCIl2e3uqJ2G1NEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9Oa-0005KO-Mj; Thu, 07 Mar 2024 09:46:32 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/9] netfilter: nf_tables: decrement element counters on set removal/flush
Date: Thu,  7 Mar 2024 09:40:06 +0100
Message-ID: <20240307084018.2219-3-fw@strlen.de>
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

Not a bug fix, idea is that this allows us to add runtime assertions,
when set is free'd counter should be 0 as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c  | 5 +++++
 net/netfilter/nft_set_bitmap.c | 5 ++++-
 net/netfilter/nft_set_hash.c   | 6 ++++++
 net/netfilter/nft_set_pipapo.c | 2 ++
 net/netfilter/nft_set_rbtree.c | 2 ++
 5 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be8254d31988..bac5847a5499 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5261,6 +5261,10 @@ static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 static void nft_set_put(struct nft_set *set)
 {
 	if (refcount_dec_and_test(&set->refs)) {
+		unsigned int nelems = atomic_read(&set->nelems);
+
+		WARN(nelems, "set %s (%ps) has element count of %u\n",
+		     set->name, set->ops->lookup, nelems);
 		kfree(set->name);
 		kvfree(set);
 	}
@@ -9663,6 +9667,7 @@ static void nft_trans_gc_trans_free(struct rcu_head *rcu)
 		if (!nft_setelem_is_catchall(trans->set, elem_priv))
 			atomic_dec(&trans->set->nelems);
 
+		WARN_ON_ONCE(atomic_read(&trans->set->nelems) < 0);
 		nf_tables_set_elem_destroy(&ctx, trans->set, elem_priv);
 	}
 
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 32df7a16835d..5999415467ef 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -275,9 +275,12 @@ static void nft_bitmap_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be, *n;
+	struct nft_set *mset = (void *)set;
 
-	list_for_each_entry_safe(be, n, &priv->list, head)
+	list_for_each_entry_safe(be, n, &priv->list, head) {
 		nf_tables_set_elem_destroy(ctx, set, &be->priv);
+		atomic_dec(&mset->nelems);
+	}
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 06337a089c34..6b0f84ef4e5f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -438,8 +438,12 @@ static void nft_rhash_elem_destroy(void *ptr, void *arg)
 {
 	struct nft_rhash_ctx *rhash_ctx = arg;
 	struct nft_rhash_elem *he = ptr;
+	struct nft_set *set;
 
 	nf_tables_set_elem_destroy(&rhash_ctx->ctx, rhash_ctx->set, &he->priv);
+
+	set = (struct nft_set *)rhash_ctx->set;
+	atomic_dec(&set->nelems);
 }
 
 static void nft_rhash_destroy(const struct nft_ctx *ctx,
@@ -688,6 +692,7 @@ static int nft_hash_init(const struct nft_set *set,
 static void nft_hash_destroy(const struct nft_ctx *ctx,
 			     const struct nft_set *set)
 {
+	struct nft_set *mset = (struct nft_set *)set;
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
 	struct hlist_node *next;
@@ -697,6 +702,7 @@ static void nft_hash_destroy(const struct nft_ctx *ctx,
 		hlist_for_each_entry_safe(he, next, &priv->table[i], node) {
 			hlist_del_rcu(&he->node);
 			nf_tables_set_elem_destroy(ctx, set, &he->priv);
+			atomic_dec(&mset->nelems);
 		}
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c0ceea068936..4797f1aa3c11 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2295,6 +2295,7 @@ static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
 					 const struct nft_set *set,
 					 struct nft_pipapo_match *m)
 {
+	struct nft_set *mset = (void *)set;
 	struct nft_pipapo_field *f;
 	unsigned int i, r;
 
@@ -2310,6 +2311,7 @@ static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
 		e = f->mt[r].e;
 
 		nf_tables_set_elem_destroy(ctx, set, &e->priv);
+		atomic_dec(&mset->nelems);
 	}
 }
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9944fe479e53..0da94e9378ca 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -709,6 +709,7 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 			       const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_set *mset = (void *)set;
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *node;
 
@@ -716,6 +717,7 @@ static void nft_rbtree_destroy(const struct nft_ctx *ctx,
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 		nf_tables_set_elem_destroy(ctx, set, &rbe->priv);
+		atomic_dec(&mset->nelems);
 	}
 }
 
-- 
2.43.0

