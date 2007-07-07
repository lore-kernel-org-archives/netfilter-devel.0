From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/50]: nf_conntrack: move expectaton related init code
	to nf_conntrack_expect.c
Date: Sat,  7 Jul 2007 14:23:49 +0200 (MEST)
Message-ID: <20070707122304.1589.74977.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: move expectaton related init code to nf_conntrack_expect.c

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 176fd66aa1e61026a719d91dbec2cbe3fd64a105
tree e4755d10980772c898c060081c6c288a91fc6ac5
parent f977268d35c8525e93ec61d6ccb18d643d0ae8cd
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:51 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:51 +0200

 include/net/netfilter/nf_conntrack_expect.h |    4 +-
 net/netfilter/nf_conntrack_core.c           |   20 +++++------
 net/netfilter/nf_conntrack_expect.c         |   48 ++++++++++++++++++++++++++-
 net/netfilter/nf_conntrack_standalone.c     |   11 +-----
 4 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 13643f7..cf6a619 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -7,8 +7,6 @@
 #include <net/netfilter/nf_conntrack.h>
 
 extern struct list_head nf_ct_expect_list;
-extern struct kmem_cache *nf_ct_expect_cachep;
-extern const struct file_operations exp_file_ops;
 
 struct nf_conntrack_expect
 {
@@ -53,6 +51,8 @@ struct nf_conntrack_expect
 
 #define NF_CT_EXPECT_PERMANENT 0x1
 
+int nf_conntrack_expect_init(void);
+void nf_conntrack_expect_fini(void);
 
 struct nf_conntrack_expect *
 __nf_ct_expect_find(const struct nf_conntrack_tuple *tuple);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 793f12f..ed44a09 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -961,12 +961,12 @@ void nf_conntrack_cleanup(void)
 	rcu_assign_pointer(nf_ct_destroy, NULL);
 
 	kmem_cache_destroy(nf_conntrack_cachep);
-	kmem_cache_destroy(nf_ct_expect_cachep);
 	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_vmalloc,
 			     nf_conntrack_htable_size);
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
+	nf_conntrack_expect_fini();
 }
 
 struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced)
@@ -1088,21 +1088,17 @@ int __init nf_conntrack_init(void)
 		goto err_free_hash;
 	}
 
-	nf_ct_expect_cachep = kmem_cache_create("nf_conntrack_expect",
-					sizeof(struct nf_conntrack_expect),
-					0, 0, NULL, NULL);
-	if (!nf_ct_expect_cachep) {
-		printk(KERN_ERR "Unable to create nf_expect slab cache\n");
+	ret = nf_conntrack_proto_init();
+	if (ret < 0)
 		goto err_free_conntrack_slab;
-	}
 
-	ret = nf_conntrack_proto_init();
+	ret = nf_conntrack_expect_init();
 	if (ret < 0)
-		goto out_free_expect_slab;
+		goto out_fini_proto;
 
 	ret = nf_conntrack_helper_init();
 	if (ret < 0)
-		goto out_fini_proto;
+		goto out_fini_expect;
 
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, __nf_conntrack_attach);
@@ -1116,10 +1112,10 @@ int __init nf_conntrack_init(void)
 
 	return ret;
 
+out_fini_expect:
+	nf_conntrack_expect_fini();
 out_fini_proto:
 	nf_conntrack_proto_fini();
-out_free_expect_slab:
-	kmem_cache_destroy(nf_ct_expect_cachep);
 err_free_conntrack_slab:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_free_hash:
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 5c8cb0f..ad197bc 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -29,7 +29,7 @@
 LIST_HEAD(nf_ct_expect_list);
 EXPORT_SYMBOL_GPL(nf_ct_expect_list);
 
-struct kmem_cache *nf_ct_expect_cachep __read_mostly;
+static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 static unsigned int nf_ct_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
@@ -413,3 +413,49 @@ const struct file_operations exp_file_ops = {
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
+int __init nf_conntrack_expect_init(void)
+{
+	int err;
+
+	nf_ct_expect_cachep = kmem_cache_create("nf_conntrack_expect",
+					sizeof(struct nf_conntrack_expect),
+					0, 0, NULL, NULL);
+	if (!nf_ct_expect_cachep)
+		return -ENOMEM;
+
+	err = exp_proc_init();
+	if (err < 0)
+		goto err1;
+
+	return 0;
+
+err1:
+	kmem_cache_destroy(nf_ct_expect_cachep);
+	return err;
+}
+
+void nf_conntrack_expect_fini(void)
+{
+	exp_proc_remove();
+	kmem_cache_destroy(nf_ct_expect_cachep);
+}
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index fe536b2..098e799 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -411,7 +411,7 @@ EXPORT_SYMBOL_GPL(nf_ct_log_invalid);
 static int __init nf_conntrack_standalone_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+	struct proc_dir_entry *proc, *proc_stat;
 #endif
 	int ret = 0;
 
@@ -423,13 +423,9 @@ static int __init nf_conntrack_standalone_init(void)
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
@@ -449,8 +445,6 @@ static int __init nf_conntrack_standalone_init(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_conntrack", proc_net_stat);
- cleanup_proc_exp:
-	proc_net_remove("nf_conntrack_expect");
  cleanup_proc:
 	proc_net_remove("nf_conntrack");
  cleanup_init:
@@ -466,7 +460,6 @@ static void __exit nf_conntrack_standalone_fini(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_conntrack", proc_net_stat);
-	proc_net_remove("nf_conntrack_expect");
 	proc_net_remove("nf_conntrack");
 #endif /* CNFIG_PROC_FS */
 	nf_conntrack_cleanup();
