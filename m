From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Netfilter: Don't cachline align slab allocs
Date: Mon, 17 Jan 2005 18:40:49 +1100
Message-ID: <1105947649.3954.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Anton Blanchard <anton@samba.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

Name: Don't cachline align slab allocs
Status: Trivial
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Anton points out that cacheline aligning conntrack entries is a wank.
He's right: there's lots of them, and they're currently ~200 bytes.
Same with the cargo-cult programming in ipt_hashlimit.

Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ipt_hashlimit.c	2005-01-17 15:37:53.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c	2005-01-17 18:37:58.294915536 +1100
@@ -668,11 +668,9 @@
 		goto cleanup_nothing;
 	}
 
-	/* FIXME: do we really want HWCACHE_ALIGN since our objects are
-	 * quite small ? */
 	hashlimit_cachep = kmem_cache_create("ipt_hashlimit",
 					    sizeof(struct dsthash_ent), 0,
-					    SLAB_HWCACHE_ALIGN, NULL, NULL);
+					    0, NULL, NULL);
 	if (!hashlimit_cachep) {
 		printk(KERN_ERR "Unable to create ipt_hashlimit slab cache\n");
 		ret = -ENOMEM;
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-17 16:14:12.000000000 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-17 18:37:42.738280504 +1100
@@ -1205,7 +1205,7 @@
 
 	ip_conntrack_cachep = kmem_cache_create("ip_conntrack",
 	                                        sizeof(struct ip_conntrack), 0,
-	                                        SLAB_HWCACHE_ALIGN, NULL,NULL);
+	                                        0, NULL, NULL);
 	if (!ip_conntrack_cachep) {
 		printk(KERN_ERR "Unable to create ip_conntrack slab cache\n");
 		goto err_free_hash;
@@ -1213,7 +1213,7 @@
 
 	ip_conntrack_expect_cachep = kmem_cache_create("ip_conntrack_expect",
 					sizeof(struct ip_conntrack_expect),
-					0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+					0, 0, NULL, NULL);
 	if (!ip_conntrack_expect_cachep) {
 		printk(KERN_ERR "Unable to create ip_expect slab cache\n");
 		goto err_free_conntrack_slab;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
