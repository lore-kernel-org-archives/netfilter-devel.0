From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack: use hlists for conntrack hash
Date: Tue, 26 Jun 2007 21:05:13 +0200
Message-ID: <46816369.4070407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020006020405040609030704"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020006020405040609030704
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I've added this patch to my tree to finally switch the
conntrack hash to hlists.



--------------020006020405040609030704
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack: use hlists for conntrack hash

Convert conntrack hash to hlists to reduce its size and cache
footprint. Since the default hashsize to max. entries ratio
sucks (1:16), this patch doesn't reduce the amount of memory
used for the hash by default, but instead uses a better ratio
of 1:8, which results in the same max. entries value.

One thing worth noting is early_drop. It really should use LRU,
so it now has to iterate over the entire chain to find the last
unconfirmed entry. Since chains shouldn't be very long and the
entire operation is very rare this shouldn't be a problem.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a9a166c66b0ecd0e4dca6d001f59e3addadc88a8
tree 06bb59bc750719fd901c82650124c28d640f126d
parent 4cd5de7bf8f83abbedc540ade295cb39996a8a97
author Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 21:03:50 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 21:03:50 +0200

 include/net/netfilter/nf_conntrack_core.h          |    4 -
 include/net/netfilter/nf_conntrack_tuple.h         |    3 -
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   17 ++--
 net/netfilter/nf_conntrack_core.c                  |   93 +++++++++++---------
 net/netfilter/nf_conntrack_helper.c                |    5 +
 net/netfilter/nf_conntrack_netlink.c               |    6 +
 net/netfilter/nf_conntrack_standalone.c            |   17 ++--
 7 files changed, 76 insertions(+), 69 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3bf7d05..6351948 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -84,9 +84,9 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 	    struct nf_conntrack_l3proto *l3proto,
 	    struct nf_conntrack_l4proto *proto);
 
-extern struct list_head *nf_conntrack_hash;
+extern struct hlist_head *nf_conntrack_hash;
 extern struct list_head nf_conntrack_expect_list;
 extern rwlock_t nf_conntrack_lock ;
-extern struct list_head unconfirmed;
+extern struct hlist_head unconfirmed;
 
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 5d72b16..d02ce87 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -125,8 +125,7 @@ DEBUGP("tuple %p: %u %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",	    \
 /* Connections have two entries in the hash table: one for each way */
 struct nf_conntrack_tuple_hash
 {
-	struct list_head list;
-
+	struct hlist_node hnode;
 	struct nf_conntrack_tuple tuple;
 };
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 89f933e..888f27f 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -41,35 +41,36 @@ struct ct_iter_state {
 	unsigned int bucket;
 };
 
-static struct list_head *ct_get_first(struct seq_file *seq)
+static struct hlist_node *ct_get_first(struct seq_file *seq)
 {
 	struct ct_iter_state *st = seq->private;
 
 	for (st->bucket = 0;
 	     st->bucket < nf_conntrack_htable_size;
 	     st->bucket++) {
-		if (!list_empty(&nf_conntrack_hash[st->bucket]))
-			return nf_conntrack_hash[st->bucket].next;
+		if (!hlist_empty(&nf_conntrack_hash[st->bucket]))
+			return nf_conntrack_hash[st->bucket].first;
 	}
 	return NULL;
 }
 
-static struct list_head *ct_get_next(struct seq_file *seq, struct list_head *head)
+static struct hlist_node *ct_get_next(struct seq_file *seq,
+				      struct hlist_node *head)
 {
 	struct ct_iter_state *st = seq->private;
 
 	head = head->next;
-	while (head == &nf_conntrack_hash[st->bucket]) {
+	while (head == NULL) {
 		if (++st->bucket >= nf_conntrack_htable_size)
 			return NULL;
-		head = nf_conntrack_hash[st->bucket].next;
+		head = nf_conntrack_hash[st->bucket].first;
 	}
 	return head;
 }
 
-static struct list_head *ct_get_idx(struct seq_file *seq, loff_t pos)
+static struct hlist_node *ct_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct list_head *head = ct_get_first(seq);
+	struct hlist_node *head = ct_get_first(seq);
 
 	if (head)
 		while (pos && (head = ct_get_next(seq, head)))
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 16794b0..b597b3c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -59,14 +59,14 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
 
-struct list_head *nf_conntrack_hash __read_mostly;
+struct hlist_head *nf_conntrack_hash __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 struct nf_conn nf_conntrack_untracked __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_untracked);
 
 unsigned int nf_ct_log_invalid __read_mostly;
-LIST_HEAD(unconfirmed);
+HLIST_HEAD(unconfirmed);
 static int nf_conntrack_vmalloc __read_mostly;
 static struct kmem_cache *nf_conntrack_cachep __read_mostly;
 static unsigned int nf_conntrack_next_id;
@@ -142,8 +142,8 @@ static void
 clean_from_lists(struct nf_conn *ct)
 {
 	DEBUGP("clean_from_lists(%p)\n", ct);
-	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
-	list_del(&ct->tuplehash[IP_CT_DIR_REPLY].list);
+	hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
+	hlist_del(&ct->tuplehash[IP_CT_DIR_REPLY].hnode);
 
 	/* Destroy all pending expectations */
 	nf_ct_remove_expectations(ct);
@@ -184,8 +184,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!nf_ct_is_confirmed(ct)) {
-		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
-		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+		BUG_ON(hlist_unhashed(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode));
+		hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
 	}
 
 	NF_CT_STAT_INC(delete);
@@ -226,9 +226,10 @@ __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack)
 {
 	struct nf_conntrack_tuple_hash *h;
+	struct hlist_node *n;
 	unsigned int hash = hash_conntrack(tuple);
 
-	list_for_each_entry(h, &nf_conntrack_hash[hash], list) {
+	hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
 		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
@@ -263,10 +264,10 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int repl_hash)
 {
 	ct->id = ++nf_conntrack_next_id;
-	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list,
-		 &nf_conntrack_hash[hash]);
-	list_add(&ct->tuplehash[IP_CT_DIR_REPLY].list,
-		 &nf_conntrack_hash[repl_hash]);
+	hlist_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
+		       &nf_conntrack_hash[hash]);
+	hlist_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnode,
+		       &nf_conntrack_hash[repl_hash]);
 }
 
 void nf_conntrack_hash_insert(struct nf_conn *ct)
@@ -290,6 +291,7 @@ __nf_conntrack_confirm(struct sk_buff **pskb)
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
+	struct hlist_node *n;
 	enum ip_conntrack_info ctinfo;
 
 	ct = nf_ct_get(*pskb, &ctinfo);
@@ -319,17 +321,17 @@ __nf_conntrack_confirm(struct sk_buff **pskb)
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-	list_for_each_entry(h, &nf_conntrack_hash[hash], list)
+	hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				      &h->tuple))
 			goto out;
-	list_for_each_entry(h, &nf_conntrack_hash[repl_hash], list)
+	hlist_for_each_entry(h, n, &nf_conntrack_hash[repl_hash], hnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				      &h->tuple))
 			goto out;
 
 	/* Remove from unconfirmed list */
-	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+	hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
 
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
 	/* Timer relative to confirmation time, not original
@@ -378,22 +380,22 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(struct list_head *chain)
+static int early_drop(struct hlist_head *chain)
 {
-	/* Traverse backwards: gives us oldest, which is roughly LRU */
+	/* Use oldest entry, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct = NULL, *tmp;
+	struct hlist_node *n;
 	int dropped = 0;
 
 	read_lock_bh(&nf_conntrack_lock);
-	list_for_each_entry_reverse(h, chain, list) {
+	hlist_for_each_entry(h, n, chain, hnode) {
 		tmp = nf_ct_tuplehash_to_ctrack(h);
-		if (!test_bit(IPS_ASSURED_BIT, &tmp->status)) {
+		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
 			ct = tmp;
-			atomic_inc(&ct->ct_general.use);
-			break;
-		}
 	}
+	if (ct)
+		atomic_inc(&ct->ct_general.use);
 	read_unlock_bh(&nf_conntrack_lock);
 
 	if (!ct)
@@ -535,7 +537,8 @@ init_conntrack(const struct nf_conntrack_tuple *tuple,
 	}
 
 	/* Overload tuple linked list to put us in unconfirmed list. */
-	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
+	hlist_add_head(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
+		       &unconfirmed);
 
 	write_unlock_bh(&nf_conntrack_lock);
 
@@ -873,16 +876,17 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
+	struct hlist_node *n;
 
 	write_lock_bh(&nf_conntrack_lock);
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
-		list_for_each_entry(h, &nf_conntrack_hash[*bucket], list) {
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[*bucket], hnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (iter(ct, data))
 				goto found;
 		}
 	}
-	list_for_each_entry(h, &unconfirmed, list) {
+	hlist_for_each_entry(h, n, &unconfirmed, hnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (iter(ct, data))
 			set_bit(IPS_DYING_BIT, &ct->status);
@@ -917,13 +921,14 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
-static void free_conntrack_hash(struct list_head *hash, int vmalloced, int size)
+static void free_conntrack_hash(struct hlist_head *hash, int vmalloced,
+				int size)
 {
 	if (vmalloced)
 		vfree(hash);
 	else
 		free_pages((unsigned long)hash,
-			   get_order(sizeof(struct list_head) * size));
+			   get_order(sizeof(struct hlist_head) * size));
 }
 
 void nf_conntrack_flush(void)
@@ -966,26 +971,26 @@ void nf_conntrack_cleanup(void)
 	nf_ct_expect_fini();
 }
 
-static struct list_head *alloc_hashtable(int *sizep, int *vmalloced)
+static struct hlist_head *alloc_hashtable(int *sizep, int *vmalloced)
 {
-	struct list_head *hash;
+	struct hlist_head *hash;
 	unsigned int size, i;
 
 	*vmalloced = 0;
 
-	size = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct list_head));
+	size = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_head));
 	hash = (void*)__get_free_pages(GFP_KERNEL,
-				       get_order(sizeof(struct list_head)
+				       get_order(sizeof(struct hlist_head)
 						 * size));
 	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		hash = vmalloc(sizeof(struct list_head) * size);
+		hash = vmalloc(sizeof(struct hlist_head) * size);
 	}
 
 	if (hash)
 		for (i = 0; i < size; i++)
-			INIT_LIST_HEAD(&hash[i]);
+			INIT_HLIST_HEAD(&hash[i]);
 
 	return hash;
 }
@@ -995,7 +1000,7 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 	int i, bucket, hashsize, vmalloced;
 	int old_vmalloced, old_size;
 	int rnd;
-	struct list_head *hash, *old_hash;
+	struct hlist_head *hash, *old_hash;
 	struct nf_conntrack_tuple_hash *h;
 
 	/* On boot, we can set this without any fancy locking. */
@@ -1016,12 +1021,12 @@ int set_hashsize(const char *val, struct kernel_param *kp)
 
 	write_lock_bh(&nf_conntrack_lock);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		while (!list_empty(&nf_conntrack_hash[i])) {
-			h = list_entry(nf_conntrack_hash[i].next,
-				       struct nf_conntrack_tuple_hash, list);
-			list_del(&h->list);
+		while (!hlist_empty(&nf_conntrack_hash[i])) {
+			h = hlist_entry(nf_conntrack_hash[i].first,
+					struct nf_conntrack_tuple_hash, hnode);
+			hlist_del(&h->hnode);
 			bucket = __hash_conntrack(&h->tuple, hashsize, rnd);
-			list_add_tail(&h->list, &hash[bucket]);
+			hlist_add_head(&h->hnode, &hash[bucket]);
 		}
 	}
 	old_size = nf_conntrack_htable_size;
@@ -1046,15 +1051,15 @@ int __init nf_conntrack_init(void)
 	int ret;
 
 	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
-	 * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */
+	 * machine has 512 buckets.  >= 1GB machines have 16384 buckets. */
 	if (!nf_conntrack_htable_size) {
 		nf_conntrack_htable_size
 			= (((num_physpages << PAGE_SHIFT) / 16384)
-			   / sizeof(struct list_head));
+			   / sizeof(struct hlist_head));
 		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
-			nf_conntrack_htable_size = 8192;
-		if (nf_conntrack_htable_size < 16)
-			nf_conntrack_htable_size = 16;
+			nf_conntrack_htable_size = 16384;
+		if (nf_conntrack_htable_size < 32)
+			nf_conntrack_htable_size = 32;
 	}
 	nf_conntrack_hash = alloc_hashtable(&nf_conntrack_htable_size,
 					    &nf_conntrack_vmalloc);
@@ -1063,7 +1068,7 @@ int __init nf_conntrack_init(void)
 		goto err_out;
 	}
 
-	nf_conntrack_max = 8 * nf_conntrack_htable_size;
+	nf_conntrack_max = 4 * nf_conntrack_htable_size;
 
 	printk("nf_conntrack version %s (%u buckets, %d max)\n",
 	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index dc352f5..3fc6e9f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -116,6 +116,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	unsigned int i;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp, *tmp;
+	struct hlist_node *n;
 
 	/* Need write lock here, to delete helper. */
 	write_lock_bh(&nf_conntrack_lock);
@@ -132,10 +133,10 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	}
 
 	/* Get rid of expecteds, set helpers to NULL. */
-	list_for_each_entry(h, &unconfirmed, list)
+	hlist_for_each_entry(h, n, &unconfirmed, hnode)
 		unhelp(h, me);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		list_for_each_entry(h, &nf_conntrack_hash[i], list)
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[i], hnode)
 			unhelp(h, me);
 	}
 	write_unlock_bh(&nf_conntrack_lock);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 35a2c27..4e56749 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -428,7 +428,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
-	struct list_head *i;
+	struct hlist_node *n;
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
@@ -436,8 +436,8 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
 restart:
-		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
-			h = (struct nf_conntrack_tuple_hash *) i;
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
+				     hnode) {
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f14f307..098e799 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -60,35 +60,36 @@ struct ct_iter_state {
 	unsigned int bucket;
 };
 
-static struct list_head *ct_get_first(struct seq_file *seq)
+static struct hlist_node *ct_get_first(struct seq_file *seq)
 {
 	struct ct_iter_state *st = seq->private;
 
 	for (st->bucket = 0;
 	     st->bucket < nf_conntrack_htable_size;
 	     st->bucket++) {
-		if (!list_empty(&nf_conntrack_hash[st->bucket]))
-			return nf_conntrack_hash[st->bucket].next;
+		if (!hlist_empty(&nf_conntrack_hash[st->bucket]))
+			return nf_conntrack_hash[st->bucket].first;
 	}
 	return NULL;
 }
 
-static struct list_head *ct_get_next(struct seq_file *seq, struct list_head *head)
+static struct hlist_node *ct_get_next(struct seq_file *seq,
+				      struct hlist_node *head)
 {
 	struct ct_iter_state *st = seq->private;
 
 	head = head->next;
-	while (head == &nf_conntrack_hash[st->bucket]) {
+	while (head == NULL) {
 		if (++st->bucket >= nf_conntrack_htable_size)
 			return NULL;
-		head = nf_conntrack_hash[st->bucket].next;
+		head = nf_conntrack_hash[st->bucket].first;
 	}
 	return head;
 }
 
-static struct list_head *ct_get_idx(struct seq_file *seq, loff_t pos)
+static struct hlist_node *ct_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct list_head *head = ct_get_first(seq);
+	struct hlist_node *head = ct_get_first(seq);
 
 	if (head)
 		while (pos && (head = ct_get_next(seq, head)))

--------------020006020405040609030704--
