From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 14/18] Netfilter:  Conntrack Hash Allocation using
	__get_free_pages
Date: Wed, 05 Jan 2005 14:36:22 +1100
Message-ID: <1104896182.20582.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Conntrack Hash Allocation using __get_free_pages
Author: Andi Kleen
Status: Tested under nfsim

Here is a patch for 2.4 that just makes it use get_free_pages to
test the TLB theory. Another obvious improvement would be to not
use list_heads for the hash table buckets - a single pointer would
likely suffice and it would cut the hash table in half, saving
cache, TLB and memory.

Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-04 22:11:53.614947576 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-04 22:25:56.082872984 +1100
@@ -75,6 +75,7 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
+static int ip_conntrack_vmalloc;
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
@@ -1309,6 +1310,16 @@
 	return 1;
 }
 
+static void free_conntrack_hash(void)
+{
+	if (ip_conntrack_vmalloc)
+		vfree(ip_conntrack_hash);
+	else
+		free_pages((unsigned long)ip_conntrack_hash, 
+			   get_order(sizeof(struct list_head)
+				     * ip_conntrack_htable_size));
+}
+
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
@@ -1328,7 +1339,7 @@
 
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
-	vfree(ip_conntrack_hash);
+	free_conntrack_hash();
 	nf_unregister_sockopt(&so_getorigdst);
 }
 
@@ -1366,8 +1377,20 @@
 		return ret;
 	}
 
-	ip_conntrack_hash = vmalloc(sizeof(struct list_head)
-				    * ip_conntrack_htable_size);
+	/* AK: the hash table is twice as big than needed because it
+	   uses list_head.  it would be much nicer to caches to use a
+	   single pointer list head here. */
+	ip_conntrack_vmalloc = 0; 
+	ip_conntrack_hash 
+		=(void*)__get_free_pages(GFP_KERNEL, 
+					 get_order(sizeof(struct list_head)
+						   *ip_conntrack_htable_size));
+	if (!ip_conntrack_hash) { 
+		ip_conntrack_vmalloc = 1;
+		printk(KERN_WARNING "ip_conntrack: falling back to vmalloc.\n");
+		ip_conntrack_hash = vmalloc(sizeof(struct list_head)
+					    * ip_conntrack_htable_size);
+	}
 	if (!ip_conntrack_hash) {
 		printk(KERN_ERR "Unable to create ip_conntrack_hash\n");
 		goto err_unreg_sockopt;
@@ -1375,7 +1398,7 @@
 
 	ip_conntrack_cachep = kmem_cache_create("ip_conntrack",
 	                                        sizeof(struct ip_conntrack), 0,
-	                                        SLAB_HWCACHE_ALIGN, NULL, NULL);
+	                                        SLAB_HWCACHE_ALIGN, NULL,NULL);
 	if (!ip_conntrack_cachep) {
 		printk(KERN_ERR "Unable to create ip_conntrack slab cache\n");
 		goto err_free_hash;
@@ -1416,7 +1439,7 @@
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
 err_free_hash:
-	vfree(ip_conntrack_hash);
+	free_conntrack_hash();
 err_unreg_sockopt:
 	nf_unregister_sockopt(&so_getorigdst);
 
