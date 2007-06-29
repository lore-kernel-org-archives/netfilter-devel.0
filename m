From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/20]: nf_conntrack: export hash allocation/destruction
	functions
Date: Fri, 29 Jun 2007 02:45:00 +0200 (MEST)
Message-ID: <20070629004359.25566.20818.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: export hash allocation/destruction functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d5335110471f0a0b025c92ac283a740a25705c67
tree 45e49fad51051b1a9f6978ee356b46edfc8bfcb5
parent e79667cf7dae1b8c3ef7169855127cdad4198c1e
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200

 include/net/netfilter/nf_conntrack.h |    4 ++++
 net/netfilter/nf_conntrack_core.c    |   23 ++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index ef4a403..8f2cbb9 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -172,6 +172,10 @@ static inline void nf_ct_put(struct nf_conn *ct)
 extern int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 extern void nf_ct_l3proto_module_put(unsigned short l3proto);
 
+extern struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced);
+extern void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced,
+				 int size);
+
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8ed761c..f4c3039 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -920,8 +920,7 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
-static void free_conntrack_hash(struct hlist_head *hash, int vmalloced,
-				int size)
+void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced, int size)
 {
 	if (vmalloced)
 		vfree(hash);
@@ -929,6 +928,7 @@ static void free_conntrack_hash(struct hlist_head *hash, int vmalloced,
 		free_pages((unsigned long)hash,
 			   get_order(sizeof(struct hlist_head) * size));
 }
+EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
 void nf_conntrack_flush(void)
 {
@@ -962,14 +962,14 @@ void nf_conntrack_cleanup(void)
 
 	kmem_cache_destroy(nf_conntrack_cachep);
 	kmem_cache_destroy(nf_conntrack_expect_cachep);
-	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
-			    nf_conntrack_htable_size);
+	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
+			     nf_conntrack_htable_size);
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
 }
 
-static struct hlist_head *alloc_hashtable(int *sizep, int *vmalloced)
+struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced)
 {
 	struct hlist_head *hash;
 	unsigned int size, i;
@@ -992,6 +992,7 @@ static struct hlist_head *alloc_hashtable(int *sizep, int *vmalloced)
 
 	return hash;
 }
+EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable);
 
 int set_hashsize(const char *val, struct kernel_param *kp)
 {
@@ -1009,7 +1010,7 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 	if (!hashsize)
 		return -EINVAL;
 
-	hash = alloc_hashtable(&hashsize, &vmalloced);
+	hash = nf_ct_alloc_hashtable(&hashsize, &vmalloced);
 	if (!hash)
 		return -ENOMEM;
 
@@ -1037,7 +1038,7 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 	nf_conntrack_hash_rnd = rnd;
 	write_unlock_bh(&nf_conntrack_lock);
 
-	free_conntrack_hash(old_hash, old_vmalloced, old_size);
+	nf_ct_free_hashtable(old_hash, old_vmalloced, old_size);
 	return 0;
 }
 
@@ -1066,8 +1067,8 @@ int __init nf_conntrack_init(void)
 		 * entries. */
 		max_factor = 4;
 	}
-	nf_conntrack_hash = alloc_hashtable(&nf_conntrack_htable_size,
-					    &nf_conntrack_vmalloc);
+	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size,
+						  &nf_conntrack_vmalloc);
 	if (!nf_conntrack_hash) {
 		printk(KERN_ERR "Unable to create nf_conntrack_hash\n");
 		goto err_out;
@@ -1122,8 +1123,8 @@ out_free_expect_slab:
 err_free_conntrack_slab:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_free_hash:
-	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
-			    nf_conntrack_htable_size);
+	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
+			     nf_conntrack_htable_size);
 err_out:
 	return -ENOMEM;
 }
