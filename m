From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/4] enable to resize the hash size
Date: Sat, 08 Oct 2005 20:07:22 +0900 (JST)
Message-ID: <200510081107.j98B7NJ7013754@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct__8_20_07_22_2005_793)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Sat_Oct__8_20_07_22_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

[NETFILTER] enable to resize the hash size of nf_conntrack

This synchronizes nf_conntrack with ip_conntrack and enables to resize
the hash size of conntrack without reloading nf_conntrack module.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Oct__8_20_07_22_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-resize-buckets.patch"

[NETFILTER] enable to resize the hash size of nf_conntrack

This synchronizes nf_conntrack with ip_conntrack and enables to resize
the hash size of conntrack without reloading nf_conntrack module.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit c1928ab8b9055013bf7e90fca007525bd58a876c
tree 7a3882310ff22d283f8b717f56d17d591f0863d5
parent dc72f654e3a13984782b156ebb946ec72b3fa9f1
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:22:55 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:22:55 +0900

 net/netfilter/nf_conntrack_core.c |  124 ++++++++++++++++++++++++++-----------
 1 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -202,8 +202,8 @@ nf_ct_put(struct nf_conn *ct)
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
-static u_int32_t
-hash_conntrack(const struct nf_conntrack_tuple *tuple)
+static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
+				  unsigned int size)
 {
 	unsigned int a, b;
 	a = jhash((void *)tuple->src.u3.all, sizeof(tuple->src.u3.all),
@@ -211,8 +211,12 @@ hash_conntrack(const struct nf_conntrack
 	b = jhash((void *)tuple->dst.u3.all, sizeof(tuple->dst.u3.all),
 			(tuple->src.u.all << 16) | tuple->dst.u.all);
 
-	return jhash_2words(a, b, nf_conntrack_hash_rnd)
-	       % nf_conntrack_htable_size;
+	return jhash_2words(a, b, nf_conntrack_hash_rnd) % size;
+}
+
+static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
+{
+	return __hash_conntrack(tuple, nf_conntrack_htable_size);
 }
 
 /* Initialize "struct nf_conn" which has spaces for helper */
@@ -1356,14 +1360,13 @@ static int kill_all(struct nf_conn *i, v
 	return 1;
 }
 
-static void free_conntrack_hash(void)
+static void free_conntrack_hash(struct list_head *hash, int vmalloced, int size)
 {
-	if (nf_conntrack_vmalloc)
-		vfree(nf_conntrack_hash);
+	if (vmalloced)
+		vfree(hash);
 	else
-		free_pages((unsigned long)nf_conntrack_hash, 
-			   get_order(sizeof(struct list_head)
-				     * nf_conntrack_htable_size));
+		free_pages((unsigned long)hash, 
+			   get_order(sizeof(struct list_head) * size));
 }
 
 /* Mishearing the voices in his head, our hero wonders how he's
@@ -1394,11 +1397,76 @@ void nf_conntrack_cleanup(void)
 		nf_conntrack_unregister_cache(i);
 	}
 	kmem_cache_destroy(nf_conntrack_expect_cachep);
-	free_conntrack_hash();
+	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
+			    nf_conntrack_htable_size);
+}
+
+static struct list_head *alloc_hashtable(int size, int *vmalloced)
+{
+	struct list_head *hash;
+	unsigned int i;
+
+	*vmalloced = 0; 
+	hash = (void*)__get_free_pages(GFP_KERNEL, 
+				       get_order(sizeof(struct list_head)
+						 * size));
+	if (!hash) { 
+		*vmalloced = 1;
+		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
+		hash = vmalloc(sizeof(struct list_head) * size);
+	}
+
+	if (hash)
+		for (i = 0; i < size; i++) 
+			INIT_LIST_HEAD(&hash[i]);
+
+	return hash;
+}
+
+int set_hashsize(const char *val, struct kernel_param *kp)
+{
+	int i, bucket, hashsize, vmalloced;
+	int old_vmalloced, old_size;
+	struct list_head *hash, *old_hash;
+	struct nf_conntrack_tuple_hash *h;
+
+	/* On boot, we can set this without any fancy locking. */
+	if (!nf_conntrack_htable_size)
+		return param_set_uint(val, kp);
+
+	hashsize = simple_strtol(val, NULL, 0);
+	if (!hashsize)
+		return -EINVAL;
+
+	hash = alloc_hashtable(hashsize, &vmalloced);
+	if (!hash)
+		return -ENOMEM;
+
+	write_lock_bh(&nf_conntrack_lock);
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		while (!list_empty(&nf_conntrack_hash[i])) {
+			h = list_entry(nf_conntrack_hash[i].next,
+				       struct nf_conntrack_tuple_hash, list);
+			list_del(&h->list);
+			bucket = __hash_conntrack(&h->tuple, hashsize);
+			list_add_tail(&h->list, &hash[bucket]);
+		}
+	}
+	old_size = nf_conntrack_htable_size;
+	old_vmalloced = nf_conntrack_vmalloc;
+	old_hash = nf_conntrack_hash;
+
+	nf_conntrack_htable_size = hashsize;
+	nf_conntrack_vmalloc = vmalloced;
+	nf_conntrack_hash = hash;
+	write_unlock_bh(&nf_conntrack_lock);
+
+	free_conntrack_hash(old_hash, old_vmalloced, old_size);
+	return 0;
 }
 
-static int hashsize;
-module_param(hashsize, int, 0400);
+module_param_call(hashsize, set_hashsize, param_get_uint,
+		  &nf_conntrack_htable_size, 0600);
 
 int __init nf_conntrack_init(void)
 {
@@ -1407,9 +1475,7 @@ int __init nf_conntrack_init(void)
 
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
 	 * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */
-	if (hashsize) {
-		nf_conntrack_htable_size = hashsize;
-	} else {
+	if (!nf_conntrack_htable_size) {
 		nf_conntrack_htable_size
 			= (((num_physpages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct list_head));
@@ -1424,23 +1490,11 @@ int __init nf_conntrack_init(void)
 	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
 	       nf_conntrack_max);
 
-	/* AK: the hash table is twice as big than needed because it
-	   uses list_head.  it would be much nicer to caches to use a
-	   single pointer list head here. */
-	nf_conntrack_vmalloc = 0; 
-	nf_conntrack_hash 
-		=(void*)__get_free_pages(GFP_KERNEL, 
-					 get_order(sizeof(struct list_head)
-						   *nf_conntrack_htable_size));
-	if (!nf_conntrack_hash) { 
-		nf_conntrack_vmalloc = 1;
-		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		nf_conntrack_hash = vmalloc(sizeof(struct list_head)
-					    * nf_conntrack_htable_size);
-	}
+	nf_conntrack_hash = alloc_hashtable(nf_conntrack_htable_size,
+					    &nf_conntrack_vmalloc);
 	if (!nf_conntrack_hash) {
 		printk(KERN_ERR "Unable to create nf_conntrack_hash\n");
-		goto err_unreg_sockopt;
+		goto err_out;
 	}
 
 	ret = nf_conntrack_register_cache(NF_CT_F_BASIC, "nf_conntrack:basic",
@@ -1464,9 +1518,6 @@ int __init nf_conntrack_init(void)
 		nf_ct_l3protos[i] = &nf_conntrack_generic_l3proto;
         write_unlock_bh(&nf_conntrack_lock);
 
-	for (i = 0; i < nf_conntrack_htable_size; i++)
-		INIT_LIST_HEAD(&nf_conntrack_hash[i]);
-
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
 	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
@@ -1478,7 +1529,8 @@ int __init nf_conntrack_init(void)
 err_free_conntrack_slab:
 	nf_conntrack_unregister_cache(NF_CT_F_BASIC);
 err_free_hash:
-	vfree(nf_conntrack_hash);
-err_unreg_sockopt:
+	free_conntrack_hash(nf_conntrack_hash, nf_conntrack_vmalloc,
+			    nf_conntrack_htable_size);
+err_out:
 	return -ENOMEM;
 }

----Next_Part(Sat_Oct__8_20_07_22_2005_793)----
