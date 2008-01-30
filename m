From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 38/69]: nf_conntrack: use RCU for conntrack hash
Date: Wed, 30 Jan 2008 21:17:53 +0100 (MET)
Message-ID: <20080130201751.29874.2648.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765143AbYA3URz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:55 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: use RCU for conntrack hash

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b3deb266341ef2957c9386657243bfdf3480cf84
tree a0f6f7efa7464a3fd81e5bbab659ee83b1362698
parent 504ca298fd3846f894b3979666df5bf5021707ff
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:12 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:07 +0100

 include/net/netfilter/nf_conntrack.h               |    2 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   18 ++++---
 net/netfilter/nf_conntrack_core.c                  |   63 +++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c               |   11 ++-
 net/netfilter/nf_conntrack_standalone.c            |   18 +++---
 net/netfilter/xt_connlimit.c                       |    4 +
 6 files changed, 73 insertions(+), 43 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index dada041..561ae76 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -129,6 +129,8 @@ struct nf_conn
 
 	/* Extensions */
 	struct nf_ct_ext *ext;
+
+	struct rcu_head rcu;
 };
 
 static inline struct nf_conn *
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 2fdcd92..0ee87ed 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -39,12 +39,14 @@ struct ct_iter_state {
 static struct hlist_node *ct_get_first(struct seq_file *seq)
 {
 	struct ct_iter_state *st = seq->private;
+	struct hlist_node *n;
 
 	for (st->bucket = 0;
 	     st->bucket < nf_conntrack_htable_size;
 	     st->bucket++) {
-		if (!hlist_empty(&nf_conntrack_hash[st->bucket]))
-			return nf_conntrack_hash[st->bucket].first;
+		n = rcu_dereference(nf_conntrack_hash[st->bucket].first);
+		if (n)
+			return n;
 	}
 	return NULL;
 }
@@ -54,11 +56,11 @@ static struct hlist_node *ct_get_next(struct seq_file *seq,
 {
 	struct ct_iter_state *st = seq->private;
 
-	head = head->next;
+	head = rcu_dereference(head->next);
 	while (head == NULL) {
 		if (++st->bucket >= nf_conntrack_htable_size)
 			return NULL;
-		head = nf_conntrack_hash[st->bucket].first;
+		head = rcu_dereference(nf_conntrack_hash[st->bucket].first);
 	}
 	return head;
 }
@@ -74,8 +76,9 @@ static struct hlist_node *ct_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
 {
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	return ct_get_idx(seq, *pos);
 }
 
@@ -86,8 +89,9 @@ static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
+	__releases(RCU)
 {
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 }
 
 static int ct_seq_show(struct seq_file *s, void *v)
@@ -226,6 +230,7 @@ static struct hlist_node *ct_expect_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *exp_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
 {
 	rcu_read_lock();
 	return ct_expect_get_idx(seq, *pos);
@@ -238,6 +243,7 @@ static void *exp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void exp_seq_stop(struct seq_file *seq, void *v)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1025607..a54bfec 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -166,8 +166,8 @@ static void
 clean_from_lists(struct nf_conn *ct)
 {
 	pr_debug("clean_from_lists(%p)\n", ct);
-	hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
-	hlist_del(&ct->tuplehash[IP_CT_DIR_REPLY].hnode);
+	hlist_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
+	hlist_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnode);
 
 	/* Destroy all pending expectations */
 	nf_ct_remove_expectations(ct);
@@ -253,7 +253,7 @@ __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 	struct hlist_node *n;
 	unsigned int hash = hash_conntrack(tuple);
 
-	hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+	hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash], hnode) {
 		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
@@ -271,12 +271,16 @@ struct nf_conntrack_tuple_hash *
 nf_conntrack_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	h = __nf_conntrack_find(tuple, NULL);
-	if (h)
-		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
-	read_unlock_bh(&nf_conntrack_lock);
+	if (h) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+			h = NULL;
+	}
+	rcu_read_unlock();
 
 	return h;
 }
@@ -286,10 +290,10 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 				       unsigned int hash,
 				       unsigned int repl_hash)
 {
-	hlist_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
-		       &nf_conntrack_hash[hash]);
-	hlist_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnode,
-		       &nf_conntrack_hash[repl_hash]);
+	hlist_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
+			   &nf_conntrack_hash[hash]);
+	hlist_add_head_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnode,
+			   &nf_conntrack_hash[repl_hash]);
 }
 
 void nf_conntrack_hash_insert(struct nf_conn *ct)
@@ -392,9 +396,9 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 {
 	struct nf_conntrack_tuple_hash *h;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	h = __nf_conntrack_find(tuple, ignored_conntrack);
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 
 	return h != NULL;
 }
@@ -413,21 +417,23 @@ static int early_drop(unsigned int hash)
 	unsigned int i, cnt = 0;
 	int dropped = 0;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+		hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash],
+					 hnode) {
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
 				ct = tmp;
 			cnt++;
 		}
+
+		if (ct && unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+			ct = NULL;
 		if (ct || cnt >= NF_CT_EVICTION_RANGE)
 			break;
 		hash = (hash + 1) % nf_conntrack_htable_size;
 	}
-	if (ct)
-		atomic_inc(&ct->ct_general.use);
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 
 	if (!ct)
 		return dropped;
@@ -480,17 +486,25 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	/* Don't set timer yet: wait for confirmation */
 	setup_timer(&conntrack->timeout, death_by_timeout,
 		    (unsigned long)conntrack);
+	INIT_RCU_HEAD(&conntrack->rcu);
 
 	return conntrack;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
-void nf_conntrack_free(struct nf_conn *conntrack)
+static void nf_conntrack_free_rcu(struct rcu_head *head)
 {
-	nf_ct_ext_free(conntrack);
-	kmem_cache_free(nf_conntrack_cachep, conntrack);
+	struct nf_conn *ct = container_of(head, struct nf_conn, rcu);
+
+	nf_ct_ext_free(ct);
+	kmem_cache_free(nf_conntrack_cachep, ct);
 	atomic_dec(&nf_conntrack_count);
 }
+
+void nf_conntrack_free(struct nf_conn *conntrack)
+{
+	call_rcu(&conntrack->rcu, nf_conntrack_free_rcu);
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
 
 /* Allocate a new conntrack: we return -ENOMEM if classification
@@ -1036,12 +1050,17 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	 * use a newrandom seed */
 	get_random_bytes(&rnd, 4);
 
+	/* Lookups in the old hash might happen in parallel, which means we
+	 * might get false negatives during connection lookup. New connections
+	 * created because of a false negative won't make it into the hash
+	 * though since that required taking the lock.
+	 */
 	write_lock_bh(&nf_conntrack_lock);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
 		while (!hlist_empty(&nf_conntrack_hash[i])) {
 			h = hlist_entry(nf_conntrack_hash[i].first,
 					struct nf_conntrack_tuple_hash, hnode);
-			hlist_del(&h->hnode);
+			hlist_del_rcu(&h->hnode);
 			bucket = __hash_conntrack(&h->tuple, hashsize, rnd);
 			hlist_add_head(&h->hnode, &hash[bucket]);
 		}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 557f471..b701dcc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -545,12 +545,12 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
 restart:
-		hlist_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
-				     hnode) {
+		hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[cb->args[0]],
+					 hnode) {
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
@@ -568,7 +568,8 @@ restart:
 						cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW,
 						1, ct) < 0) {
-				nf_conntrack_get(&ct->ct_general);
+				if (!atomic_inc_not_zero(&ct->ct_general.use))
+					continue;
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
@@ -584,7 +585,7 @@ restart:
 		}
 	}
 out:
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 	if (last)
 		nf_ct_put(last);
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 28c5ae8..98f0cd3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -58,12 +58,14 @@ struct ct_iter_state {
 static struct hlist_node *ct_get_first(struct seq_file *seq)
 {
 	struct ct_iter_state *st = seq->private;
+	struct hlist_node *n;
 
 	for (st->bucket = 0;
 	     st->bucket < nf_conntrack_htable_size;
 	     st->bucket++) {
-		if (!hlist_empty(&nf_conntrack_hash[st->bucket]))
-			return nf_conntrack_hash[st->bucket].first;
+		n = rcu_dereference(nf_conntrack_hash[st->bucket].first);
+		if (n)
+			return n;
 	}
 	return NULL;
 }
@@ -73,11 +75,11 @@ static struct hlist_node *ct_get_next(struct seq_file *seq,
 {
 	struct ct_iter_state *st = seq->private;
 
-	head = head->next;
+	head = rcu_dereference(head->next);
 	while (head == NULL) {
 		if (++st->bucket >= nf_conntrack_htable_size)
 			return NULL;
-		head = nf_conntrack_hash[st->bucket].first;
+		head = rcu_dereference(nf_conntrack_hash[st->bucket].first);
 	}
 	return head;
 }
@@ -93,9 +95,9 @@ static struct hlist_node *ct_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(nf_conntrack_lock)
+	__acquires(RCU)
 {
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 	return ct_get_idx(seq, *pos);
 }
 
@@ -106,9 +108,9 @@ static void *ct_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void ct_seq_stop(struct seq_file *s, void *v)
-	__releases(nf_conntrack_lock)
+	__releases(RCU)
 {
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 }
 
 /* return 0 on success, 1 in case of error */
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index e00ecd9..f9b59a6 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -120,7 +120,7 @@ static int count_them(struct xt_connlimit_data *data,
 	else
 		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
 
-	read_lock_bh(&nf_conntrack_lock);
+	rcu_read_lock();
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, tmp, hash, list) {
@@ -163,7 +163,7 @@ static int count_them(struct xt_connlimit_data *data,
 			++matches;
 	}
 
-	read_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 
 	if (addit) {
 		/* save the new connection in our list */
