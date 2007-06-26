From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack: round up hashsize to next multiple of
 PAGE_SIZE
Date: Tue, 26 Jun 2007 15:59:39 +0200
Message-ID: <46811BCB.7080502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040401040800060802060506"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------040401040800060802060506
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I've added these four patches to my tree to improve
the conntrack hashing behaviour and use a hash for
expectations instead of the global list.



--------------040401040800060802060506
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_conntrack: round up hashsize to next multiple of PAGE_SIZE

Besides letting the rest of the page go to waste, this has the nice
side-effect that it assures that the hash size is a power of two,
so we can replace the modulo operation during hashing by a binary and.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1b54b00d69fd371821949bf429642dfc98153bcb
tree 83853e7e8d280c88ffbb7eab0a794d1ac0624045
parent 07d16ab092ef4fb4b29037573a28bbfd9e2a6e4b
author Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:28 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:28 +0200

 net/netfilter/nf_conntrack_core.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 035eb9f..ee9f825 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -87,7 +87,7 @@ static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
 	b = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
 		   (tuple->src.u.all << 16) | tuple->dst.u.all);
 
-	return jhash_2words(a, b, rnd) % size;
+	return jhash_2words(a, b, rnd) & size;
 }
 
 static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
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

--------------040401040800060802060506--
