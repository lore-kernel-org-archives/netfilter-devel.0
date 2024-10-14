Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F7D1A4F34;
	Mon, 14 Oct 2024 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904474; cv=none; b=WiK7R6s5RBGL8YzBP0QGA5Slkc1bMP79tyhihQa3bRtTG4OhtbDYzsLtOr1FKHP0Ns7uw9EFXvLaK/W2YzX346SJBi3uZB2yKPfGk1rk5jilmAh06/6WTFtiEJzcsZstpDtXdr4ev+nNBXho33f711mnxXztsyjW0sMthjhsLMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904474; c=relaxed/simple;
	bh=1GrudrhIV6eBfIdpQvWB6IvF86UzOLzBrncdKE0RLbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oNib9YNvVoL2LuMvPFieUlLisRSIR+Pfs+mimoeS4sMZxAfqRs0YL3S7cdy5U0qP6PnN8H7w1tP0KokO0iLAmfEYfvzbUanzipNXrMQETQwYvYZ9EHEjsDQum/OqiybMfi8THsC1acmDqtSITpsd6vhRo/1P2HDpp0efmgVrxi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 9/9] netfilter: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Mon, 14 Oct 2024 13:14:20 +0200
Message-Id: <20241014111420.29127-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241014111420.29127-1-pablo@netfilter.org>
References: <20241014111420.29127-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julia Lawall <Julia.Lawall@inria.fr>

Since SLOB was removed and since
commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
it is not necessary to use call_rcu when the callback only performs
kmem_cache_free. Use kfree_rcu() directly.

The changes were made using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c        | 10 +---------
 net/netfilter/nf_conntrack_expect.c | 10 +---------
 net/netfilter/xt_hashlimit.c        |  9 +--------
 3 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4890af4dc263..6a7a6c2d6ebc 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -275,14 +275,6 @@ bool nf_conncount_gc_list(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_gc_list);
 
-static void __tree_nodes_free(struct rcu_head *h)
-{
-	struct nf_conncount_rb *rbconn;
-
-	rbconn = container_of(h, struct nf_conncount_rb, rcu_head);
-	kmem_cache_free(conncount_rb_cachep, rbconn);
-}
-
 /* caller must hold tree nf_conncount_locks[] lock */
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
@@ -295,7 +287,7 @@ static void tree_nodes_free(struct rb_root *root,
 		spin_lock(&rbconn->list.list_lock);
 		if (!rbconn->list.count) {
 			rb_erase(&rbconn->node, root);
-			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
+			kfree_rcu(rbconn, rcu_head);
 		}
 		spin_unlock(&rbconn->list.list_lock);
 	}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 21fa550966f0..9dcaef6f3663 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -367,18 +367,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
-static void nf_ct_expect_free_rcu(struct rcu_head *head)
-{
-	struct nf_conntrack_expect *exp;
-
-	exp = container_of(head, struct nf_conntrack_expect, rcu);
-	kmem_cache_free(nf_ct_expect_cachep, exp);
-}
-
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (refcount_dec_and_test(&exp->use))
-		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
+		kfree_rcu(exp, rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 0859b8f76764..c2b9b954eb53 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -256,18 +256,11 @@ dsthash_alloc_init(struct xt_hashlimit_htable *ht,
 	return ent;
 }
 
-static void dsthash_free_rcu(struct rcu_head *head)
-{
-	struct dsthash_ent *ent = container_of(head, struct dsthash_ent, rcu);
-
-	kmem_cache_free(hashlimit_cachep, ent);
-}
-
 static inline void
 dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
 {
 	hlist_del_rcu(&ent->node);
-	call_rcu(&ent->rcu, dsthash_free_rcu);
+	kfree_rcu(ent, rcu);
 	ht->count--;
 }
 static void htable_gc(struct work_struct *work);
-- 
2.30.2

