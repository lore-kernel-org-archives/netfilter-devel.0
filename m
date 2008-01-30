From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 37/69]: nf_conntrack_expect: use RCU for expectation hash
Date: Wed, 30 Jan 2008 21:17:52 +0100 (MET)
Message-ID: <20080130201749.29874.10153.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbYA3URx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:53 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: use RCU for expectation hash

Use RCU for expectation hash. This doesn't buy much for conntrack runtime
performance, but allows to reduce the use of nf_conntrack_lock for /proc
and nf_netlink_conntrack.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 504ca298fd3846f894b3979666df5bf5021707ff
tree 2b94fd833ebb414fd8305ada3295a3fd5fb5e516
parent 23cf79fc3f39291ad9e98a00584d1f0c0b8c5d25
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:11 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:06 +0100

 include/net/netfilter/nf_conntrack_expect.h        |    2 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   14 ++++---
 net/netfilter/nf_conntrack_expect.c                |   43 +++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c               |    7 ++-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 6c3fd25..cb608a1 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -49,6 +49,8 @@ struct nf_conntrack_expect
 	/* Direction relative to the master connection. */
 	enum ip_conntrack_dir dir;
 #endif
+
+	struct rcu_head rcu;
 };
 
 #define NF_CT_EXPECT_PERMANENT 0x1
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 543c02b..2fdcd92 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -191,10 +191,12 @@ struct ct_expect_iter_state {
 static struct hlist_node *ct_expect_get_first(struct seq_file *seq)
 {
 	struct ct_expect_iter_state *st = seq->private;
+	struct hlist_node *n;
 
 	for (st->bucket = 0; st->bucket < nf_ct_expect_hsize; st->bucket++) {
-		if (!hlist_empty(&nf_ct_expect_hash[st->bucket]))
-			return nf_ct_expect_hash[st->bucket].first;
+		n = rcu_dereference(nf_ct_expect_hash[st->bucket].first);
+		if (n)
+			return n;
 	}
 	return NULL;
 }
@@ -204,11 +206,11 @@ static struct hlist_node *ct_expect_get_next(struct seq_file *seq,
 {
 	struct ct_expect_iter_state *st = seq->private;
 
-	head = head->next;
+	head = rcu_dereference(head->next);
 	while (head == NULL) {
 		if (++st->bucket >= nf_ct_expect_hsize)
 			return NULL;
-		head = nf_ct_expect_hash[st->bucket].first;
+		head = rcu_dereference(nf_ct_expect_hash[st->bucket].first);
 	}
 	return head;
 }
@@ -225,7 +227,7 @@ static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 
 static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	return ct_expect_get_idx(seq, *pos);
 }
 
@@ -237,7 +239,7 @@ static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 static void exp_seq_stop(struct seq_file *seq, void *v)
 {
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e405079..a5c8ef0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -50,7 +50,7 @@ void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 	NF_CT_ASSERT(master_help);
 	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 
-	hlist_del(&exp->hnode);
+	hlist_del_rcu(&exp->hnode);
 	nf_ct_expect_count--;
 
 	hlist_del(&exp->lnode);
@@ -97,7 +97,7 @@ __nf_ct_expect_find(const struct nf_conntrack_tuple *tuple)
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(tuple);
-	hlist_for_each_entry(i, n, &nf_ct_expect_hash[h], hnode) {
+	hlist_for_each_entry_rcu(i, n, &nf_ct_expect_hash[h], hnode) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask))
 			return i;
 	}
@@ -111,11 +111,11 @@ nf_ct_expect_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	i = __nf_ct_expect_find(tuple);
-	if (i)
-		atomic_inc(&i->use);
-	read_unlock_bh(&nf_conntrack_lock);
+	if (i && !atomic_inc_not_zero(&i->use))
+		i = NULL;
+	rcu_read_unlock();
 
 	return i;
 }
@@ -223,6 +223,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 
 	new->master = me;
 	atomic_set(&new->use, 1);
+	INIT_RCU_HEAD(&new->rcu);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
@@ -278,10 +279,18 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
+static void nf_ct_expect_free_rcu(struct rcu_head *head)
+{
+	struct nf_conntrack_expect *exp;
+
+	exp = container_of(head, struct nf_conntrack_expect, rcu);
+	kmem_cache_free(nf_ct_expect_cachep, exp);
+}
+
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (atomic_dec_and_test(&exp->use))
-		kmem_cache_free(nf_ct_expect_cachep, exp);
+		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
@@ -295,7 +304,7 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	hlist_add_head(&exp->lnode, &master_help->expectations);
 	master_help->expecting++;
 
-	hlist_add_head(&exp->hnode, &nf_ct_expect_hash[h]);
+	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
 	nf_ct_expect_count++;
 
 	setup_timer(&exp->timeout, nf_ct_expectation_timed_out,
@@ -394,10 +403,12 @@ struct ct_expect_iter_state {
 static struct hlist_node *ct_expect_get_first(struct seq_file *seq)
 {
 	struct ct_expect_iter_state *st = seq->private;
+	struct hlist_node *n;
 
 	for (st->bucket = 0; st->bucket < nf_ct_expect_hsize; st->bucket++) {
-		if (!hlist_empty(&nf_ct_expect_hash[st->bucket]))
-			return nf_ct_expect_hash[st->bucket].first;
+		n = rcu_dereference(nf_ct_expect_hash[st->bucket].first);
+		if (n)
+			return n;
 	}
 	return NULL;
 }
@@ -407,11 +418,11 @@ static struct hlist_node *ct_expect_get_next(struct seq_file *seq,
 {
 	struct ct_expect_iter_state *st = seq->private;
 
-	head = head->next;
+	head = rcu_dereference(head->next);
 	while (head == NULL) {
 		if (++st->bucket >= nf_ct_expect_hsize)
 			return NULL;
-		head = nf_ct_expect_hash[st->bucket].first;
+		head = rcu_dereference(nf_ct_expect_hash[st->bucket].first);
 	}
 	return head;
 }
@@ -427,9 +438,9 @@ static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(nf_conntrack_lock)
+	__acquires(RCU)
 {
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	return ct_expect_get_idx(seq, *pos);
 }
 
@@ -440,9 +451,9 @@ static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void exp_seq_stop(struct seq_file *seq, void *v)
-	__releases(nf_conntrack_lock)
+	__releases(RCU)
 {
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 }
 
 static int exp_seq_show(struct seq_file *s, void *v)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b6c0935..557f471 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1471,7 +1471,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_node *n;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
@@ -1488,7 +1488,8 @@ restart:
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
 						    1, exp) < 0) {
-				atomic_inc(&exp->use);
+				if (!atomic_inc_not_zero(&exp->use))
+					continue;
 				cb->args[1] = (unsigned long)exp;
 				goto out;
 			}
@@ -1499,7 +1500,7 @@ restart:
 		}
 	}
 out:
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 	if (last)
 		nf_ct_expect_put(last);
 
