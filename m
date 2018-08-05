From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/21] netfilter: use kvmalloc_array to allocate memory for hashtable
Date: Sun,  5 Aug 2018 23:21:28 +0200
Message-ID: <20180805212141.3033-9-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

nf_ct_alloc_hashtable is used to allocate memory for conntrack,
NAT bysrc and expectation hashtable. Assuming 64k bucket size,
which means 7th order page allocation, __get_free_pages, called
by nf_ct_alloc_hashtable, will trigger the direct memory reclaim
and stall for a long time, when system has lots of memory stress

so replace combination of __get_free_pages and vzalloc with
kvmalloc_array, which provides a overflow check and a fallback
if no high order memory is available, and do not retry to reclaim
memory, reduce stall

and remove nf_ct_free_hashtable, since it is just a kvfree

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Wang Li <wangli39@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  2 --
 net/netfilter/nf_conntrack_core.c    | 29 ++++++-----------------------
 net/netfilter/nf_conntrack_expect.c  |  2 +-
 net/netfilter/nf_conntrack_helper.c  |  4 ++--
 net/netfilter/nf_nat_core.c          |  4 ++--
 5 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a2b0ed025908..7e012312cd61 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -176,8 +176,6 @@ void nf_ct_netns_put(struct net *net, u8 nfproto);
  */
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls);
 
-void nf_ct_free_hashtable(void *hash, unsigned int size);
-
 int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8a113ca1eea2..a676d5f76bdc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2022,16 +2022,6 @@ static int kill_all(struct nf_conn *i, void *data)
 	return net_eq(nf_ct_net(i), data);
 }
 
-void nf_ct_free_hashtable(void *hash, unsigned int size)
-{
-	if (is_vmalloc_addr(hash))
-		vfree(hash);
-	else
-		free_pages((unsigned long)hash,
-			   get_order(sizeof(struct hlist_head) * size));
-}
-EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
-
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
@@ -2042,7 +2032,7 @@ void nf_conntrack_cleanup_end(void)
 {
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
-	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
+	kvfree(nf_conntrack_hash);
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_seqadj_fini();
@@ -2108,7 +2098,6 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 {
 	struct hlist_nulls_head *hash;
 	unsigned int nr_slots, i;
-	size_t sz;
 
 	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
 		return NULL;
@@ -2116,14 +2105,8 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
-	if (nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
-		return NULL;
-
-	sz = nr_slots * sizeof(struct hlist_nulls_head);
-	hash = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
-					get_order(sz));
-	if (!hash)
-		hash = vzalloc(sz);
+	hash = kvmalloc_array(nr_slots, sizeof(struct hlist_nulls_head),
+			      GFP_KERNEL | __GFP_ZERO);
 
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)
@@ -2150,7 +2133,7 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 
 	old_size = nf_conntrack_htable_size;
 	if (old_size == hashsize) {
-		nf_ct_free_hashtable(hash, hashsize);
+		kvfree(hash);
 		return 0;
 	}
 
@@ -2186,7 +2169,7 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	local_bh_enable();
 
 	synchronize_net();
-	nf_ct_free_hashtable(old_hash, old_size);
+	kvfree(old_hash);
 	return 0;
 }
 
@@ -2350,7 +2333,7 @@ int nf_conntrack_init_start(void)
 err_expect:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_cachep:
-	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
+	kvfree(nf_conntrack_hash);
 	return ret;
 }
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 3f586ba23d92..27b84231db10 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -712,5 +712,5 @@ void nf_conntrack_expect_fini(void)
 {
 	rcu_barrier(); /* Wait for call_rcu() before destroy */
 	kmem_cache_destroy(nf_ct_expect_cachep);
-	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_hsize);
+	kvfree(nf_ct_expect_hash);
 }
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index d557a425289d..e24b762ffa1d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -562,12 +562,12 @@ int nf_conntrack_helper_init(void)
 
 	return 0;
 out_extend:
-	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
+	kvfree(nf_ct_helper_hash);
 	return ret;
 }
 
 void nf_conntrack_helper_fini(void)
 {
 	nf_ct_extend_unregister(&helper_extend);
-	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
+	kvfree(nf_ct_helper_hash);
 }
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 6366f0c0b8c1..e2b196054dfc 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1056,7 +1056,7 @@ static int __init nf_nat_init(void)
 
 	ret = nf_ct_extend_register(&nat_extend);
 	if (ret < 0) {
-		nf_ct_free_hashtable(nf_nat_bysource, nf_nat_htable_size);
+		kvfree(nf_nat_bysource);
 		pr_err("Unable to register extension\n");
 		return ret;
 	}
@@ -1094,7 +1094,7 @@ static void __exit nf_nat_cleanup(void)
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
 		kfree(nf_nat_l4protos[i]);
 	synchronize_net();
-	nf_ct_free_hashtable(nf_nat_bysource, nf_nat_htable_size);
+	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
 }
 
-- 
2.11.0
