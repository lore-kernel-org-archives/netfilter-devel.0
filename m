From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack: use hash for expectations
Date: Tue, 26 Jun 2007 15:59:47 +0200
Message-ID: <46811BD3.906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020501010407020705010501"
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
--------------020501010407020705010501
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------020501010407020705010501
Content-Type: text/x-diff;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

[NETFILTER]: nf_conntrack: use hash for expectations

Use a hashtable for expectations to avoid searching a single global
list for every new connection. The default hash size is 1/256 of the
conntrack hash table size, this can be overriden using a module
parameter.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7246b74f7501fcddd2876408ee3e88f8988cf957
tree ab55cdc97f8c6049b00dc0508fbb4be8e4a92011
parent 873139d6b6e37954fd70dab4fe9362490da3f00b
author Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:57:32 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:57:32 +0200

 include/net/netfilter/nf_conntrack_expect.h |    6 +
 net/netfilter/nf_conntrack_core.c           |    9 ++
 net/netfilter/nf_conntrack_expect.c         |  119 +++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c     |   11 --
 4 files changed, 132 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 337ab71..b20f0ff 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -8,7 +8,6 @@
 
 extern struct list_head nf_conntrack_expect_list;
 extern struct kmem_cache *nf_conntrack_expect_cachep;
-extern const struct file_operations exp_file_ops;
 
 struct nf_conntrack_expect_mask
 {
@@ -21,6 +20,9 @@ struct nf_conntrack_expect
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
 
+	/* Hash member */
+	struct hlist_node hlist;
+
 	/* We expect this tuple, with the following mask */
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect_mask mask;
@@ -59,6 +61,8 @@ struct nf_conntrack_expect
 
 #define NF_CT_EXPECT_PERMANENT 0x1
 
+int nf_ct_expect_init(void);
+void nf_ct_expect_fini(void);
 
 struct nf_conntrack_expect *
 __nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ee9f825..3c109cd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -963,6 +963,7 @@ void nf_conntrack_cleanup(void)
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
+	nf_ct_expect_fini();
 }
 
 static struct list_head *alloc_hashtable(int *sizep, int *vmalloced)
@@ -1088,10 +1089,14 @@ int __init nf_conntrack_init(void)
 	if (ret < 0)
 		goto out_free_expect_slab;
 
-	ret = nf_conntrack_helper_init();
+	ret = nf_ct_expect_init();
 	if (ret < 0)
 		goto out_fini_proto;
 
+	ret = nf_conntrack_helper_init();
+	if (ret < 0)
+		goto out_fini_expect;
+
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
 	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
@@ -1104,6 +1109,8 @@ int __init nf_conntrack_init(void)
 
 	return ret;
 
+out_fini_expect:
+	nf_ct_expect_fini();
 out_fini_proto:
 	nf_conntrack_proto_fini();
 out_free_expect_slab:
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index d7c7ab7..92d614d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -19,6 +19,8 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/kernel.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -29,6 +31,12 @@
 LIST_HEAD(nf_conntrack_expect_list);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_list);
 
+static struct hlist_head *nf_conntrack_expect_hash __read_mostly;
+static unsigned int nf_conntrack_expect_hsize __read_mostly;
+static unsigned int nf_conntrack_expect_hash_rnd __read_mostly;
+static int nf_conntrack_expect_hash_rnd_initted __read_mostly;
+static int nf_conntrack_expect_vmalloc;
+
 struct kmem_cache *nf_conntrack_expect_cachep __read_mostly;
 static unsigned int nf_conntrack_expect_next_id;
 
@@ -41,6 +49,8 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
 	list_del(&exp->list);
+	hlist_del(&exp->hlist);
+
 	NF_CT_STAT_INC(expect_delete);
 	master_help->expecting--;
 	nf_conntrack_expect_put(exp);
@@ -57,6 +67,19 @@ static void expectation_timed_out(unsigned long ul_expect)
 	nf_conntrack_expect_put(exp);
 }
 
+static unsigned int nf_ct_exp_hash(const struct nf_conntrack_tuple *tuple)
+{
+	if (unlikely(!nf_conntrack_expect_hash_rnd_initted)) {
+		get_random_bytes(&nf_conntrack_expect_hash_rnd, 4);
+		nf_conntrack_expect_hash_rnd_initted = 1;
+	}
+
+	return jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
+		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
+		       tuple->dst.u.all) ^ nf_conntrack_expect_hash_rnd) &
+	       nf_conntrack_expect_hsize;
+}
+
 static int nf_ct_exp_mask_equal(const struct nf_conntrack_expect_mask *m1,
 				const struct nf_conntrack_expect_mask *m2)
 {
@@ -90,8 +113,10 @@ struct nf_conntrack_expect *
 __nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
+	struct hlist_node *n;
+	unsigned int h = nf_ct_exp_hash(tuple);
 
-	list_for_each_entry(i, &nf_conntrack_expect_list, list) {
+	hlist_for_each_entry(i, n, &nf_conntrack_expect_hash[h], hlist) {
 		if (nf_ct_exp_tuple_cmp(tuple, &i->tuple, &i->mask))
 			return i;
 	}
@@ -288,10 +313,13 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_put);
 static void nf_conntrack_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
+	unsigned int h = nf_ct_exp_hash(&exp->tuple);
 
 	atomic_inc(&exp->use);
 	master_help->expecting++;
+
 	list_add(&exp->list, &nf_conntrack_expect_list);
+	hlist_add_head(&exp->hlist, &nf_conntrack_expect_hash[h]);
 
 	setup_timer(&exp->timeout, expectation_timed_out, (unsigned long)exp);
 	exp->timeout.expires = jiffies + master_help->helper->timeout * HZ;
@@ -440,7 +468,7 @@ static int exp_open(struct inode *inode, struct file *file)
 	return seq_open(file, &exp_seq_ops);
 }
 
-const struct file_operations exp_file_ops = {
+static const struct file_operations exp_file_ops = {
 	.owner   = THIS_MODULE,
 	.open    = exp_open,
 	.read    = seq_read,
@@ -448,3 +476,90 @@ const struct file_operations exp_file_ops = {
 	.release = seq_release
 };
 #endif /* CONFIG_PROC_FS */
+
+static int __init exp_proc_init(void)
+{
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc;
+
+	proc = proc_net_fops_create("nf_conntrack_expect", 0440, &exp_file_ops);
+	if (!proc)
+		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
+	return 0;
+}
+
+static void exp_proc_remove(void)
+{
+#ifdef CONFIG_PROC_FS
+	proc_net_remove("nf_conntrack_expect");
+#endif /* CONFIG_PROC_FS */
+}
+
+static struct hlist_head *alloc_hashtable(unsigned int *sizep, int *vmalloced)
+{
+	struct hlist_head *hash;
+	unsigned int size, i;
+
+	size = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_head));
+	hash = (void *)__get_free_pages(GFP_KERNEL,
+					get_order(sizeof(struct hlist_head) *
+						  size));
+	if (!hash) {
+		*vmalloced = 1;
+		printk(KERN_WARNING "nf_conntrack_expect: falling back to "
+				    "vmalloc.\n");
+		hash = vmalloc(sizeof(struct hlist_head) * size);
+	}
+
+	if (hash)
+		for (i = 0; i < size; i++)
+			INIT_HLIST_HEAD(&hash[i]);
+
+	return hash;
+}
+
+static void free_hashtable(struct hlist_head *hash, unsigned int size,
+			   int vmalloced)
+{
+	if (vmalloced)
+		vfree(hash);
+	else
+		free_pages((unsigned long)hash,
+			   get_order(sizeof(struct hlist_head) * size));
+}
+
+module_param_named(expect_hashsize, nf_conntrack_expect_hsize, uint, 0600);
+
+int __init nf_ct_expect_init(void)
+{
+	int err;
+
+	if (!nf_conntrack_expect_hsize) {
+		nf_conntrack_expect_hsize = nf_conntrack_htable_size / 256;
+		if (!nf_conntrack_expect_hsize)
+			nf_conntrack_expect_hsize = 1;
+	}
+
+	nf_conntrack_expect_hash = alloc_hashtable(&nf_conntrack_expect_hsize,
+						   &nf_conntrack_expect_vmalloc);
+	if (nf_conntrack_expect_hash == NULL)
+		return -ENOMEM;
+
+	err = exp_proc_init();
+	if (err < 0)
+		goto err1;
+	return 0;
+
+err1:
+	free_hashtable(nf_conntrack_expect_hash, nf_conntrack_expect_hsize,
+		       nf_conntrack_expect_vmalloc);
+	return err;
+}
+
+void nf_ct_expect_fini(void)
+{
+	exp_proc_remove();
+	free_hashtable(nf_conntrack_expect_hash, nf_conntrack_expect_hsize,
+		       nf_conntrack_expect_vmalloc);
+}
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 45baeb0..f14f307 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -410,7 +410,7 @@ EXPORT_SYMBOL_GPL(nf_ct_log_invalid);
 static int __init nf_conntrack_standalone_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+	struct proc_dir_entry *proc, *proc_stat;
 #endif
 	int ret = 0;
 
@@ -422,13 +422,9 @@ static int __init nf_conntrack_standalone_init(void)
 	proc = proc_net_fops_create("nf_conntrack", 0440, &ct_file_ops);
 	if (!proc) goto cleanup_init;
 
-	proc_exp = proc_net_fops_create("nf_conntrack_expect", 0440,
-					&exp_file_ops);
-	if (!proc_exp) goto cleanup_proc;
-
 	proc_stat = create_proc_entry("nf_conntrack", S_IRUGO, proc_net_stat);
 	if (!proc_stat)
-		goto cleanup_proc_exp;
+		goto cleanup_proc;
 
 	proc_stat->proc_fops = &ct_cpu_seq_fops;
 	proc_stat->owner = THIS_MODULE;
@@ -448,8 +444,6 @@ static int __init nf_conntrack_standalone_init(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_conntrack", proc_net_stat);
- cleanup_proc_exp:
-	proc_net_remove("nf_conntrack_expect");
  cleanup_proc:
 	proc_net_remove("nf_conntrack");
  cleanup_init:
@@ -465,7 +459,6 @@ static void __exit nf_conntrack_standalone_fini(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_conntrack", proc_net_stat);
-	proc_net_remove("nf_conntrack_expect");
 	proc_net_remove("nf_conntrack");
 #endif /* CNFIG_PROC_FS */
 	nf_conntrack_cleanup();

--------------020501010407020705010501--
