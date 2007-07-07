From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/50]: nf_conntrack: round up hashsize to next multiple
	of PAGE_SIZE
Date: Sat,  7 Jul 2007 14:23:35 +0200 (MEST)
Message-ID: <20070707122250.1589.95254.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: round up hashsize to next multiple of PAGE_SIZE

Don't let the rest of the page go to waste.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 04d9c6af6b57ed9f97ffd4f56198b6be329a8be8
tree 35e3baae1ccd0cf6f0223f4240a7bed6e6dae30b
parent baa1fb29b43978190d2c3338d4fd558325f955ab
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:38 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:38 +0200

 net/netfilter/nf_conntrack_core.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 035eb9f..54acac5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -965,12 +965,14 @@ void nf_conntrack_cleanup(void)
 	nf_conntrack_helper_fini();
 }
 
-static struct list_head *alloc_hashtable(int size, int *vmalloced)
+static struct list_head *alloc_hashtable(int *sizep, int *vmalloced)
 {
 	struct list_head *hash;
-	unsigned int i;
+	unsigned int size, i;
 
 	*vmalloced = 0;
+
+	size = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct list_head));
 	hash = (void*)__get_free_pages(GFP_KERNEL,
 				       get_order(sizeof(struct list_head)
 						 * size));
@@ -1003,7 +1005,7 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 	if (!hashsize)
 		return -EINVAL;
 
-	hash = alloc_hashtable(hashsize, &vmalloced);
+	hash = alloc_hashtable(&hashsize, &vmalloced);
 	if (!hash)
 		return -ENOMEM;
 
@@ -1053,19 +1055,19 @@ int __init nf_conntrack_init(void)
 		if (nf_conntrack_htable_size < 16)
 			nf_conntrack_htable_size = 16;
 	}
-	nf_conntrack_max = 8 * nf_conntrack_htable_size;
-
-	printk("nf_conntrack version %s (%u buckets, %d max)\n",
-	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
-	       nf_conntrack_max);
-
-	nf_conntrack_hash = alloc_hashtable(nf_conntrack_htable_size,
+	nf_conntrack_hash = alloc_hashtable(&nf_conntrack_htable_size,
 					    &nf_conntrack_vmalloc);
 	if (!nf_conntrack_hash) {
 		printk(KERN_ERR "Unable to create nf_conntrack_hash\n");
 		goto err_out;
 	}
 
+	nf_conntrack_max = 8 * nf_conntrack_htable_size;
+
+	printk("nf_conntrack version %s (%u buckets, %d max)\n",
+	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
+	       nf_conntrack_max);
+
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn),
 						0, 0, NULL, NULL);
