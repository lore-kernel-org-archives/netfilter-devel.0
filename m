From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 40/50]: nf_conntrack_helper: use hashtable for conntrack
	helpers
Date: Sat,  7 Jul 2007 14:23:57 +0200 (MEST)
Message-ID: <20070707122312.1589.51890.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_helper: use hashtable for conntrack helpers

Eliminate the last global list searched for every new connection.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 13ab190cf5d5872340ef1d36e9da215cb7bceed8
tree d1c75546f6592faf67f3059f904077114f06ff6d
parent 7993e12c4d5d18b227a18402f5f4298f13a650ba
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:59 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:59 +0200

 include/net/netfilter/nf_conntrack_helper.h |    4 +-
 net/netfilter/nf_conntrack_helper.c         |   70 ++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 2c0e2e0..d04f999 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,8 +15,8 @@
 struct module;
 
 struct nf_conntrack_helper
-{	
-	struct list_head list; 		/* Internal use. */
+{
+	struct hlist_node hnode;	/* Internal use. */
 
 	const char *name;		/* name of the module */
 	struct module *me;		/* pointer to self */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 66c209d..b1179dd 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -28,23 +28,41 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-static __read_mostly LIST_HEAD(helpers);
+static struct hlist_head *nf_ct_helper_hash __read_mostly;
+static unsigned int nf_ct_helper_hsize __read_mostly;
+static unsigned int nf_ct_helper_count __read_mostly;
+static int nf_ct_helper_vmalloc;
+
+
+/* Stupid hash, but collision free for the default registrations of the
+ * helpers currently in the kernel. */
+static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
+{
+	return (((tuple->src.l3num << 8) | tuple->dst.protonum) ^
+		tuple->src.u.all) % nf_ct_helper_hsize;
+}
 
 struct nf_conntrack_helper *
 __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_helper *h;
+	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
+	struct hlist_node *n;
+	unsigned int h;
 
-	list_for_each_entry(h, &helpers, list) {
-		if (nf_ct_tuple_src_mask_cmp(tuple, &h->tuple, &mask))
-			return h;
+	if (!nf_ct_helper_count)
+		return NULL;
+
+	h = helper_hash(tuple);
+	hlist_for_each_entry(helper, n, &nf_ct_helper_hash[h], hnode) {
+		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
+			return helper;
 	}
 	return NULL;
 }
 
 struct nf_conntrack_helper *
-nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
+nf_ct_helper_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_helper *helper;
 
@@ -77,12 +95,15 @@ struct nf_conntrack_helper *
 __nf_conntrack_helper_find_byname(const char *name)
 {
 	struct nf_conntrack_helper *h;
+	struct hlist_node *n;
+	unsigned int i;
 
-	list_for_each_entry(h, &helpers, list) {
-		if (!strcmp(h->name, name))
-			return h;
+	for (i = 0; i < nf_ct_helper_hsize; i++) {
+		hlist_for_each_entry(h, n, &nf_ct_helper_hash[i], hnode) {
+			if (!strcmp(h->name, name))
+				return h;
+		}
 	}
-
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find_byname);
@@ -115,10 +136,13 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
+	unsigned int h = helper_hash(&me->tuple);
+
 	BUG_ON(me->timeout == 0);
 
 	write_lock_bh(&nf_conntrack_lock);
-	list_add(&me->list, &helpers);
+	hlist_add_head(&me->hnode, &nf_ct_helper_hash[h]);
+	nf_ct_helper_count++;
 	write_unlock_bh(&nf_conntrack_lock);
 
 	return 0;
@@ -134,7 +158,8 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&nf_conntrack_lock);
-	list_del(&me->list);
+	hlist_del(&me->hnode);
+	nf_ct_helper_count--;
 
 	/* Get rid of expectations */
 	for (i = 0; i < nf_ct_expect_hsize; i++) {
@@ -171,10 +196,29 @@ static struct nf_ct_ext_type helper_extend __read_mostly = {
 
 int nf_conntrack_helper_init()
 {
-	return nf_ct_extend_register(&helper_extend);
+	int err;
+
+	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
+	nf_ct_helper_hash = nf_ct_alloc_hashtable(&nf_ct_helper_hsize,
+						  &nf_ct_helper_vmalloc);
+	if (!nf_ct_helper_hash)
+		return -ENOMEM;
+
+	err = nf_ct_extend_register(&helper_extend);
+	if (err < 0)
+		goto err1;
+
+	return 0;
+
+err1:
+	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_vmalloc,
+			     nf_ct_helper_hsize);
+	return err;
 }
 
 void nf_conntrack_helper_fini()
 {
 	nf_ct_extend_unregister(&helper_extend);
+	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_vmalloc,
+			     nf_ct_helper_hsize);
 }
