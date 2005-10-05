From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Thu, 06 Oct 2005 04:23:03 +1000
Message-ID: <1128536584.9868.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Status: Tested on 2.6.14-rc3-git3
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (authored)

It's fairly simple to resize the hash table, but currently you need to
remove and reinsert the module.  That's bad (we lose connection
state).  Harald has even offered to write a daemon which sets this
based on load.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal linux-2.6.14-rc3-git3/net/ipv4/netfilter/ip_conntrack_core.c working-2.6.14-rc3-git3/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.14-rc3-git3/net/ipv4/netfilter/ip_conntrack_core.c	2005-10-04 19:25:00.000000000 +1000
+++ working-2.6.14-rc3-git3/net/ipv4/netfilter/ip_conntrack_core.c	2005-10-06 04:11:35.000000000 +1000
@@ -148,16 +148,19 @@ DEFINE_PER_CPU(struct ip_conntrack_stat,
 static int ip_conntrack_hash_rnd_initted;
 static unsigned int ip_conntrack_hash_rnd;
 
-static u_int32_t
-hash_conntrack(const struct ip_conntrack_tuple *tuple)
+static u32 __hash_conntrack(const struct ip_conntrack_tuple *tuple,
+			    unsigned int size)
 {
-#if 0
-	dump_tuple(tuple);
-#endif
 	return (jhash_3words(tuple->src.ip,
 	                     (tuple->dst.ip ^ tuple->dst.protonum),
 	                     (tuple->src.u.all | (tuple->dst.u.all << 16)),
-	                     ip_conntrack_hash_rnd) % ip_conntrack_htable_size);
+	                     ip_conntrack_hash_rnd) % size);
+}
+
+static u_int32_t
+hash_conntrack(const struct ip_conntrack_tuple *tuple)
+{
+	return __hash_conntrack(tuple, ip_conntrack_htable_size);
 }
 
 int
@@ -1338,14 +1341,13 @@ static int kill_all(struct ip_conntrack 
 	return 1;
 }
 
-static void free_conntrack_hash(void)
+static void free_conntrack_hash(struct list_head *hash, int vmalloced,int size)
 {
-	if (ip_conntrack_vmalloc)
-		vfree(ip_conntrack_hash);
+	if (vmalloced)
+		vfree(hash);
 	else
-		free_pages((unsigned long)ip_conntrack_hash, 
-			   get_order(sizeof(struct list_head)
-				     * ip_conntrack_htable_size));
+		free_pages((unsigned long)hash, 
+			   get_order(sizeof(struct list_head) * size));
 }
 
 void ip_conntrack_flush()
@@ -1375,12 +1377,77 @@ void ip_conntrack_cleanup(void)
 	ip_conntrack_flush();
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
-	free_conntrack_hash();
+	free_conntrack_hash(ip_conntrack_hash, ip_conntrack_vmalloc,
+			    ip_conntrack_htable_size);
 	nf_unregister_sockopt(&so_getorigdst);
 }
 
-static int hashsize;
-module_param(hashsize, int, 0400);
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
+		printk(KERN_WARNING"ip_conntrack: falling back to vmalloc.\n");
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
+	struct ip_conntrack_tuple_hash *h;
+
+	/* On boot, we can set this without any fancy locking. */
+	if (!ip_conntrack_htable_size)
+		return param_set_int(val, kp);
+
+	hashsize = simple_strtol(val, NULL, 0);
+	if (!hashsize)
+		return -EINVAL;
+
+	hash = alloc_hashtable(hashsize, &vmalloced);
+	if (!hash)
+		return -ENOMEM;
+
+	write_lock_bh(&ip_conntrack_lock);
+	for (i = 0; i < ip_conntrack_htable_size; i++) {
+		while (!list_empty(&ip_conntrack_hash[i])) {
+			h = list_entry(ip_conntrack_hash[i].next,
+				       struct ip_conntrack_tuple_hash, list);
+			list_del(&h->list);
+			bucket = __hash_conntrack(&h->tuple, hashsize);
+			list_add_tail(&h->list, &hash[bucket]);
+		}
+	}
+	old_size = ip_conntrack_htable_size;
+	old_vmalloced = ip_conntrack_vmalloc;
+	old_hash = ip_conntrack_hash;
+
+	ip_conntrack_htable_size = hashsize;
+	ip_conntrack_vmalloc = vmalloced;
+	ip_conntrack_hash = hash;
+	write_unlock_bh(&ip_conntrack_lock);
+
+	free_conntrack_hash(old_hash, old_vmalloced, old_size);
+	return 0;
+}
+
+module_param_call(hashsize, set_hashsize, param_get_uint,
+		  &ip_conntrack_htable_size, 0600);
 
 int __init ip_conntrack_init(void)
 {
@@ -1389,9 +1456,7 @@ int __init ip_conntrack_init(void)
 
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
 	 * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */
- 	if (hashsize) {
- 		ip_conntrack_htable_size = hashsize;
- 	} else {
+ 	if (!ip_conntrack_htable_size) {
 		ip_conntrack_htable_size
 			= (((num_physpages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct list_head));
@@ -1413,20 +1478,8 @@ int __init ip_conntrack_init(void)
 		return ret;
 	}
 
-	/* AK: the hash table is twice as big than needed because it
-	   uses list_head.  it would be much nicer to caches to use a
-	   single pointer list head here. */
-	ip_conntrack_vmalloc = 0; 
-	ip_conntrack_hash 
-		=(void*)__get_free_pages(GFP_KERNEL, 
-					 get_order(sizeof(struct list_head)
-						   *ip_conntrack_htable_size));
-	if (!ip_conntrack_hash) { 
-		ip_conntrack_vmalloc = 1;
-		printk(KERN_WARNING "ip_conntrack: falling back to vmalloc.\n");
-		ip_conntrack_hash = vmalloc(sizeof(struct list_head)
-					    * ip_conntrack_htable_size);
-	}
+	ip_conntrack_hash = alloc_hashtable(ip_conntrack_htable_size,
+					    &ip_conntrack_vmalloc);
 	if (!ip_conntrack_hash) {
 		printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
 		goto err_unreg_sockopt;
@@ -1458,9 +1511,6 @@ int __init ip_conntrack_init(void)
 	ip_ct_protos[IPPROTO_ICMP] = &ip_conntrack_protocol_icmp;
 	write_unlock_bh(&ip_conntrack_lock);
 
-	for (i = 0; i < ip_conntrack_htable_size; i++)
-		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
-
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
 
@@ -1475,7 +1525,8 @@ int __init ip_conntrack_init(void)
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
 err_free_hash:
-	free_conntrack_hash();
+	free_conntrack_hash(ip_conntrack_hash, ip_conntrack_vmalloc,
+			    ip_conntrack_htable_size);
 err_unreg_sockopt:
 	nf_unregister_sockopt(&so_getorigdst);
 

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
