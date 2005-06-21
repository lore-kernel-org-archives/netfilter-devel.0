From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] Fix kernel BUG() with iptree IP set on 2.4
Date: Tue, 21 Jun 2005 18:04:40 +0200
Message-ID: <42B83A98.4070909@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

Hi,

The slab cache in 2.4(.31) uses a fixed length array for slab cache
names, causing a BUG() in mm/slab.c:kmem_cache_create() to be
triggered when attempting to create a cache who's name is longer
than 18 characters. The patch below makes iptree work on 2.4 kernels
as well:

//Marcus

--- net/ipv4/netfilter/ip_set_iptree.c	2005/06/21 15:06:15	1.1
+++ net/ipv4/netfilter/ip_set_iptree.c	2005/06/21 15:08:00
@@ -472,19 +472,19 @@
 {
 	int ret;
 	
-	branch_cachep = kmem_cache_create("ip_set_iptree_branches",
+	branch_cachep = kmem_cache_create("iptree_branches",
 				sizeof(struct ip_set_iptreeb),
 				0, 0, NULL, NULL);
 	if (!branch_cachep) {
-		printk(KERN_ERR "Unable to create ip_set_iptree_branches slab cache\n");
+		printk(KERN_ERR "Unable to create iptree_branches slab cache\n");
 		ret = -ENOMEM;
 		goto out;
 	}
-	leaf_cachep = kmem_cache_create("ip_set_iptree_leaves",
+	leaf_cachep = kmem_cache_create("iptree_leaves",
 				sizeof(struct ip_set_iptreed),
 				0, 0, NULL, NULL);
 	if (!leaf_cachep) {
-		printk(KERN_ERR "Unable to create ip_set_iptree_leaves slab cache\n");
+		printk(KERN_ERR "Unable to create iptree_leaves slab cache\n");
 		ret = -ENOMEM;
 		goto free_branch;
 	}


-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
