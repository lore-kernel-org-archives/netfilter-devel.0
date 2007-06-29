From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/20]: nf_conntrack: use hashtable for expectations
Date: Fri, 29 Jun 2007 02:45:12 +0200 (MEST)
Message-ID: <20070629004410.25566.12414.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: use hashtable for expectations

Currently all expectations are kept on a global list that

- needs to be searched for every new conncetion
- needs to be walked for evicting expectations when a master connection
  has reached its limit
- needs to be walked on connection destruction for connections that
  have open expectations

This is obviously not good, especially when considering helpers like
H.323 that register *lots* of expectations and can set up permanent
expectations, but it also allows for an easy DoS against firewalls
using connection tracking helpers.

Use a hashtable for expectations to avoid incurring the search overhead
for every new connection. The default hash size is 1/256 of the conntrack
hash table size, this can be overriden using a module parameter.

This patch only introduces the hash table for expectation lookups and
keeps other users to reduce the noise, the following patches will get
rid of it completely.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6c6d2912994c266361333f8d904b5e10dc21b5f7
tree a17c0e2bd295f78ceee5b600a033e91b6f6f8941
parent 0986445682ffdf6988ec197b9025b0947591e43b
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:12:34 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:12:34 +0200

 include/net/netfilter/nf_conntrack_core.h   |    1 
 include/net/netfilter/nf_conntrack_expect.h |    5 ++
 net/netfilter/nf_conntrack_expect.c         |   67 +++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index a18f79c..4056f5f 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -84,7 +84,6 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l4proto *proto);
 
 extern struct hlist_head *nf_conntrack_hash;
-extern struct list_head nf_ct_expect_list;
 extern rwlock_t nf_conntrack_lock ;
 extern struct hlist_head unconfirmed;
 
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index cf6a619..424d4bd 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -7,12 +7,17 @@
 #include <net/netfilter/nf_conntrack.h>
 
 extern struct list_head nf_ct_expect_list;
+extern struct hlist_head *nf_ct_expect_hash;
+extern unsigned int nf_ct_expect_hsize;
 
 struct nf_conntrack_expect
 {
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
 
+	/* Hash member */
+	struct hlist_node hnode;
+
 	/* We expect this tuple, with the following mask */
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index ad197bc..d92f817 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/kernel.h>
+#include <linux/jhash.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -29,6 +30,17 @@
 LIST_HEAD(nf_ct_expect_list);
 EXPORT_SYMBOL_GPL(nf_ct_expect_list);
 
+struct hlist_head *nf_ct_expect_hash __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ct_expect_hash);
+
+unsigned int nf_ct_expect_hsize __read_mostly;
+EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
+
+static unsigned int nf_ct_expect_hash_rnd __read_mostly;
+static unsigned int nf_ct_expect_count;
+static int nf_ct_expect_hash_rnd_initted __read_mostly;
+static int nf_ct_expect_vmalloc;
+
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 static unsigned int nf_ct_expect_next_id;
 
@@ -41,6 +53,9 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
 	list_del(&exp->list);
+	hlist_del(&exp->hnode);
+	nf_ct_expect_count--;
+
 	NF_CT_STAT_INC(expect_delete);
 	master_help->expecting--;
 	nf_ct_expect_put(exp);
@@ -57,12 +72,31 @@ static void nf_ct_expectation_timed_out(unsigned long ul_expect)
 	nf_ct_expect_put(exp);
 }
 
+static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple)
+{
+	if (unlikely(!nf_ct_expect_hash_rnd_initted)) {
+		get_random_bytes(&nf_ct_expect_hash_rnd, 4);
+		nf_ct_expect_hash_rnd_initted = 1;
+	}
+
+	return jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
+		      (((tuple->dst.protonum ^ tuple->src.l3num) << 16) |
+		       tuple->dst.u.all) ^ nf_ct_expect_hash_rnd) %
+	       nf_ct_expect_hsize;
+}
+
 struct nf_conntrack_expect *
 __nf_ct_expect_find(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
+	struct hlist_node *n;
+	unsigned int h;
+
+	if (!nf_ct_expect_count)
+		return NULL;
 
-	list_for_each_entry(i, &nf_ct_expect_list, list) {
+	h = nf_ct_expect_dst_hash(tuple);
+	hlist_for_each_entry(i, n, &nf_ct_expect_hash[h], hnode) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
 			return i;
 	}
@@ -252,10 +286,14 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
+	unsigned int h = nf_ct_expect_dst_hash(&exp->tuple);
 
 	atomic_inc(&exp->use);
 	master_help->expecting++;
+
 	list_add(&exp->list, &nf_ct_expect_list);
+	hlist_add_head(&exp->hnode, &nf_ct_expect_hash[h]);
+	nf_ct_expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
 		    (unsigned long)exp);
@@ -300,6 +338,8 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	struct nf_conntrack_expect *i;
 	struct nf_conn *master = expect->master;
 	struct nf_conn_help *master_help = nfct_help(master);
+	struct hlist_node *n;
+	unsigned int h;
 	int ret;
 
 	NF_CT_ASSERT(master_help);
@@ -309,7 +349,8 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
-	list_for_each_entry(i, &nf_ct_expect_list, list) {
+	h = nf_ct_expect_dst_hash(&expect->tuple);
+	hlist_for_each_entry(i, n, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
 			if (refresh_timer(i)) {
@@ -433,23 +474,39 @@ static void exp_proc_remove(void)
 #endif /* CONFIG_PROC_FS */
 }
 
+module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0600);
+
 int __init nf_conntrack_expect_init(void)
 {
 	int err;
 
+	if (!nf_ct_expect_hsize) {
+		nf_ct_expect_hsize = nf_conntrack_htable_size / 256;
+		if (!nf_ct_expect_hsize)
+			nf_ct_expect_hsize = 1;
+	}
+
+	nf_ct_expect_hash = nf_ct_alloc_hashtable(&nf_ct_expect_hsize,
+						  &nf_ct_expect_vmalloc);
+	if (nf_ct_expect_hash == NULL)
+		return -ENOMEM;
+
 	nf_ct_expect_cachep = kmem_cache_create("nf_conntrack_expect",
 					sizeof(struct nf_conntrack_expect),
 					0, 0, NULL, NULL);
 	if (!nf_ct_expect_cachep)
-		return -ENOMEM;
+		goto err1;
 
 	err = exp_proc_init();
 	if (err < 0)
-		goto err1;
+		goto err2;
 
 	return 0;
 
 err1:
+	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_vmalloc,
+			     nf_ct_expect_hsize);
+err2:
 	kmem_cache_destroy(nf_ct_expect_cachep);
 	return err;
 }
@@ -458,4 +515,6 @@ void nf_conntrack_expect_fini(void)
 {
 	exp_proc_remove();
 	kmem_cache_destroy(nf_ct_expect_cachep);
+	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_vmalloc,
+			     nf_ct_expect_hsize);
 }
