From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH V3 nf-next] netfilter: conntrack: simplify the code by using nf_conntrack_get_ht
Date: Sat, 13 Aug 2016 22:35:36 +0800
Message-ID: <1471098936-2970-1-git-send-email-zlpnobody@163.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:36424 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbcHMOgm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 10:36:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
nf_conntrack proc read and hash resize") introdue the
nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
again and again to get the hash table and hash size. And convert
nf_conntrack_get_ht to inline function here.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V3: Convert all possible place to use nf_conntrack_get_ht and make it inline.
     Based on patch http://patchwork.ozlabs.org/patch/658952/.

 include/net/netfilter/nf_conntrack.h      | 20 ++++++++++++++
 include/net/netfilter/nf_conntrack_core.h |  3 --
 net/netfilter/nf_conntrack_core.c         | 46 +++++++------------------------
 3 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 445b019..2a12748 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -303,9 +303,29 @@ struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
 int nf_conntrack_hash_resize(unsigned int hashsize);
+
+extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
+extern seqcount_t nf_conntrack_generation;
 extern unsigned int nf_conntrack_max;
 
+/* must be called with rcu read lock held */
+static inline void
+nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
+{
+	struct hlist_nulls_head *hptr;
+	unsigned int sequence, hsz;
+
+	do {
+		sequence = read_seqcount_begin(&nf_conntrack_generation);
+		hsz = nf_conntrack_htable_size;
+		hptr = nf_conntrack_hash;
+	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+
+	*hash = hptr;
+	*hsize = hsz;
+}
+
 struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 const struct nf_conntrack_zone *zone,
 				 gfp_t flags);
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 79d7ac5..62e17d1 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -51,8 +51,6 @@ bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 			const struct nf_conntrack_l3proto *l3proto,
 			const struct nf_conntrack_l4proto *l4proto);
 
-void nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize);
-
 /* Find a connection corresponding to a tuple. */
 struct nf_conntrack_tuple_hash *
 nf_conntrack_find_get(struct net *net,
@@ -83,7 +81,6 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 
 #define CONNTRACK_LOCKS 1024
 
-extern struct hlist_nulls_head *nf_conntrack_hash;
 extern spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 void nf_conntrack_lock(spinlock_t *lock);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index dccac2c..7d90a5d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -74,7 +74,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
-static __read_mostly seqcount_t nf_conntrack_generation;
 static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
@@ -164,6 +163,7 @@ unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
 unsigned int nf_conntrack_max __read_mostly;
+seqcount_t nf_conntrack_generation __read_mostly;
 
 DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
@@ -480,23 +480,6 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 	       net_eq(net, nf_ct_net(ct));
 }
 
-/* must be called with rcu read lock held */
-void nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
-{
-	struct hlist_nulls_head *hptr;
-	unsigned int sequence, hsz;
-
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		hsz = nf_conntrack_htable_size;
-		hptr = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
-
-	*hash = hptr;
-	*hsize = hsz;
-}
-EXPORT_SYMBOL_GPL(nf_conntrack_get_ht);
-
 /*
  * Warning :
  * - Caller must take a reference on returned object
@@ -509,14 +492,11 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_head *ct_hash;
 	struct hlist_nulls_node *n;
-	unsigned int bucket, sequence;
+	unsigned int bucket, hsize;
 
 begin:
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		bucket = scale_hash(hash);
-		ct_hash = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+	nf_conntrack_get_ht(&ct_hash, &hsize);
+	bucket = reciprocal_scale(hash, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
 		if (nf_ct_key_equal(h, tuple, zone, net)) {
@@ -822,18 +802,15 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	const struct nf_conntrack_zone *zone;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_head *ct_hash;
-	unsigned int hash, sequence;
+	unsigned int hash, hsize;
 	struct hlist_nulls_node *n;
 	struct nf_conn *ct;
 
 	zone = nf_ct_zone(ignored_conntrack);
 
 	rcu_read_lock();
-	do {
-		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		hash = hash_conntrack(net, tuple);
-		ct_hash = nf_conntrack_hash;
-	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+	nf_conntrack_get_ht(&ct_hash, &hsize);
+	hash = __hash_conntrack(net, tuple, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[hash], hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
@@ -899,14 +876,11 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 
 	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
 		struct hlist_nulls_head *ct_hash;
-		unsigned hash, sequence, drops;
+		unsigned int hash, hsize, drops;
 
 		rcu_read_lock();
-		do {
-			sequence = read_seqcount_begin(&nf_conntrack_generation);
-			hash = scale_hash(_hash++);
-			ct_hash = nf_conntrack_hash;
-		} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+		nf_conntrack_get_ht(&ct_hash, &hsize);
+		hash = reciprocal_scale(_hash++, hsize);
 
 		drops = early_drop_list(net, &ct_hash[hash]);
 		rcu_read_unlock();
-- 
2.5.5


