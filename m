Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA802E229C
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361325; cv=none; b=WssiHumGkdxfzruRUJGMC0ew7ROBiZ0Vew1moDZ1904bgcIk0xrqQikYyj6m9EydJnrUrSWu7i1OWP/JdfwwZV7yJIsfIE7+XphcElcfVHIdq3YPoK9dryVThjr1r9K4ippu1pPojHVGAxUHa+xi0L35D5D+TLLE8vUZnDXXaC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361325; c=relaxed/simple;
	bh=P1UPSwcJOYwxRj+m6f5IgI9/XJnXfPizq5wR3u2DzFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu1a2uMSF9IVKFUROkB4iHqQuNvU+X7Egh69efJ6TRp04CWkNhQHWrO9cTdrvkJUO9Oj87FGtvjuPvdhmJYOJz2f23B60eYkiNvKmVmsdSNqWfPMwzETSbs7IJvQvI7Bk+rEWIcRZEL7kgAF1CJbByN7tIVvvSNOZ3TxW7WkEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 239E96020C; Wed,  5 Nov 2025 17:48:41 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 06/11] netfilter: conntrack: move nf_conntrack_hash to struct net
Date: Wed,  5 Nov 2025 17:48:00 +0100
Message-ID: <20251105164805.3992-7-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This preparation change moves the nf_conntrack_hash to pernet scope,
but only the init_net one is allocated.

net->ct.nf_conntrack_hash aliases init_net->ct.nf_conntrack_hash.
Without this, the actual pernet conversion patch would grow too large.

1. nf_conntrack_get_ht() returns inet_net table, not pernet one.
2. Same for __nf_conntrack_confirm.

This is because hash resize would result in UaF due to stale
net->ct.nf_conntrack_hash.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h    |   6 +-
 include/net/netns/conntrack.h           |   1 +
 net/netfilter/nf_conntrack_core.c       | 114 +++++++++++++-----------
 net/netfilter/nf_conntrack_netlink.c    |   3 +-
 net/netfilter/nf_conntrack_standalone.c |   8 +-
 5 files changed, 74 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d404e1352737..a90654bb2410 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -332,7 +332,8 @@ extern seqcount_spinlock_t nf_conntrack_generation;
 
 /* must be called with rcu read lock held */
 static inline void
-nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
+nf_conntrack_get_ht(struct net *net, struct hlist_nulls_head **hash,
+		    unsigned int *hsize)
 {
 	struct hlist_nulls_head *hptr;
 	unsigned int sequence, hsz;
@@ -340,7 +341,8 @@ nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
 		hsz = nf_conntrack_htable_size;
-		hptr = nf_conntrack_hash;
+		hptr = net->ct.nf_conntrack_hash;
+		hptr = init_net.ct.nf_conntrack_hash;
 	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
 
 	*hash = hptr;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 2e7707b7d349..96b326bc1cd7 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -92,6 +92,7 @@ struct netns_ct {
 	unsigned int		sysctl_max;
 
 	struct ip_conntrack_stat __percpu *stat;
+	struct hlist_nulls_head *nf_conntrack_hash;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1f938ef8e59a..f2ff0e70f5ab 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -60,9 +60,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(nf_conntrack_expect_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 
-struct hlist_nulls_head *nf_conntrack_hash __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_hash);
-
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
@@ -738,7 +735,7 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 	unsigned int bucket, hsize;
 
 begin:
-	nf_conntrack_get_ht(&ct_hash, &hsize);
+	nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
 	bucket = reciprocal_scale(hash, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
@@ -853,7 +850,7 @@ static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
 	if (ext->gen_id != atomic_read(&nf_conntrack_ext_genid))
 		return false;
 
-	/* inserted into conntrack table, nf_ct_iterate_cleanup()
+	/* inserted into conntrack table, nf_ct_iterate_cleanup_net()
 	 * will find it.  Disable nf_ct_ext_find() id check.
 	 */
 	WRITE_ONCE(ext->gen_id, 0);
@@ -867,6 +864,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_head *ct_hash;
 	struct hlist_nulls_node *n;
 	unsigned int max_chainlen;
 	unsigned int chainlen = 0;
@@ -889,10 +887,11 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
+	ct_hash = init_net.ct.nf_conntrack_hash;
 	max_chainlen = MIN_CHAINLEN + get_random_u32_below(MAX_CHAINLEN);
 
 	/* See if there's one in the list already, including reverse */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
+	hlist_nulls_for_each_entry(h, n, &ct_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
@@ -903,7 +902,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	chainlen = 0;
 
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
+	hlist_nulls_for_each_entry(h, n, &ct_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
@@ -926,9 +925,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
-	__nf_conntrack_hash_insert(ct,
-				   &nf_conntrack_hash[hash],
-				   &nf_conntrack_hash[reply_hash]);
+	__nf_conntrack_hash_insert(ct, &ct_hash[hash], &ct_hash[reply_hash]);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
@@ -1084,16 +1081,19 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 	struct nf_conn *loser_ct = (struct nf_conn *)skb_nfct(skb);
 	const struct nf_conntrack_zone *zone;
 	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_head *ct_hash;
 	struct hlist_nulls_node *n;
 	struct net *net;
 
 	zone = nf_ct_zone(loser_ct);
 	net = nf_ct_net(loser_ct);
 
+	ct_hash = init_net.ct.nf_conntrack_hash;
+
 	/* Reply direction must never result in a clash, unless both origin
 	 * and reply tuples are identical.
 	 */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[repl_idx], hnnode) {
+	hlist_nulls_for_each_entry(h, n, &ct_hash[repl_idx], hnnode) {
 		if (nf_ct_key_equal(h,
 				    &loser_ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
@@ -1119,7 +1119,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 	hlist_nulls_add_fake(&loser_ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 
 	hlist_nulls_add_head_rcu(&loser_ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
-				 &nf_conntrack_hash[repl_idx]);
+				 &ct_hash[repl_idx]);
 	/* confirmed bit must be set after hlist add, not before:
 	 * loser_ct can still be visible to other cpu due to
 	 * SLAB_TYPESAFE_BY_RCU.
@@ -1205,6 +1205,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	const struct nf_conntrack_zone *zone;
 	unsigned int hash, reply_hash;
 	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_head *ct_hash;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct hlist_nulls_node *n;
@@ -1235,6 +1236,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
+	ct_hash = init_net.ct.nf_conntrack_hash;
+
 	/* We're not in hash table, and we refuse to set up related
 	 * connections for unconfirmed conns.  But packet copies and
 	 * REJECT will give spurious warnings here.
@@ -1271,7 +1274,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* See if there's one in the list already, including reverse:
 	   NAT could have grabbed it without realizing, since we're
 	   not in the hash.  If there is, we lost race. */
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[hash], hnnode) {
+	hlist_nulls_for_each_entry(h, n, &ct_hash[hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				    zone, net))
 			goto out;
@@ -1280,7 +1283,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	}
 
 	chainlen = 0;
-	hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[reply_hash], hnnode) {
+	hlist_nulls_for_each_entry(h, n, &ct_hash[reply_hash], hnnode) {
 		if (nf_ct_key_equal(h, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    zone, net))
 			goto out;
@@ -1304,9 +1307,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * setting ct->timeout. The RCU barriers guarantee that no other CPU
 	 * can find the conntrack before the above stores are visible.
 	 */
-	__nf_conntrack_hash_insert(ct,
-				   &nf_conntrack_hash[hash],
-				   &nf_conntrack_hash[reply_hash]);
+	__nf_conntrack_hash_insert(ct, &ct_hash[hash], &ct_hash[reply_hash]);
 
 	/* IPS_CONFIRMED unset means 'ct not (yet) in hash', conntrack lookups
 	 * skip entries that lack this bit.  This happens when a CPU is looking
@@ -1366,7 +1367,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 
 	rcu_read_lock();
  begin:
-	nf_conntrack_get_ht(&ct_hash, &hsize);
+	nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
 	hash = __hash_conntrack(net, tuple, nf_ct_zone_id(zone, IP_CT_DIR_REPLY), hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[hash], hnnode) {
@@ -1473,7 +1474,7 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 		unsigned int hsize, drops;
 
 		rcu_read_lock();
-		nf_conntrack_get_ht(&ct_hash, &hsize);
+		nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
 		if (!i)
 			bucket = reciprocal_scale(hash, hsize);
 		else
@@ -1544,7 +1545,7 @@ static void gc_worker(struct work_struct *work)
 
 		rcu_read_lock();
 
-		nf_conntrack_get_ht(&ct_hash, &hashsz);
+		nf_conntrack_get_ht(&init_net, &ct_hash, &hashsz);
 		if (i >= hashsz) {
 			rcu_read_unlock();
 			break;
@@ -2327,8 +2328,9 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	spinlock_t *lockp;
 
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
-		struct hlist_nulls_head *hslot = &nf_conntrack_hash[*bucket];
+		struct hlist_nulls_head *hslot;
 
+		hslot = &init_net.ct.nf_conntrack_hash[*bucket];
 		if (hlist_nulls_empty(hslot))
 			continue;
 
@@ -2351,8 +2353,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 			 */
 			ct = nf_ct_tuplehash_to_ctrack(h);
 
-			if (iter_data->net &&
-			    !net_eq(iter_data->net, nf_ct_net(ct)))
+			if (!net_eq(iter_data->net, nf_ct_net(ct)))
 				continue;
 
 			if (iter(ct, iter_data->data))
@@ -2371,14 +2372,19 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	return ct;
 }
 
-static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
-				  const struct nf_ct_iter_data *iter_data)
+void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
+			       const struct nf_ct_iter_data *iter_data)
 {
+	struct net *net = iter_data->net;
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	unsigned int bucket = 0;
 	struct nf_conn *ct;
 
 	might_sleep();
 
+	if (atomic_read(&cnet->count) == 0)
+		return;
+
 	mutex_lock(&nf_conntrack_mutex);
 	while ((ct = get_next_corpse(iter, iter_data, &bucket)) != NULL) {
 		/* Time to push up daises... */
@@ -2389,20 +2395,6 @@ static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 	}
 	mutex_unlock(&nf_conntrack_mutex);
 }
-
-void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
-			       const struct nf_ct_iter_data *iter_data)
-{
-	struct net *net = iter_data->net;
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	might_sleep();
-
-	if (atomic_read(&cnet->count) == 0)
-		return;
-
-	nf_ct_iterate_cleanup(iter, iter_data);
-}
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 
 /**
@@ -2410,16 +2402,18 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
  * @iter: callback to invoke for each conntrack
  * @data: data to pass to @iter
  *
- * Like nf_ct_iterate_cleanup, but first marks conntracks on the
- * unconfirmed list as dying (so they will not be inserted into
- * main table).
+ * Like nf_ct_iterate_cleanup_net, but bumps extension genid so
+ * extensions with stale data will not be accessible for conntracks not yet
+ * confirmed to main table.
  *
  * Can only be called in module exit path.
  */
 void
 nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
-	struct nf_ct_iter_data iter_data = {};
+	struct nf_ct_iter_data iter_data = {
+		.data = data,
+	};
 	struct net *net;
 
 	down_read(&net_rwsem);
@@ -2429,6 +2423,8 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 		if (atomic_read(&cnet->count) == 0)
 			continue;
 		nf_queue_nf_hook_drop(net);
+		iter_data.net = net;
+		nf_ct_iterate_cleanup_net(iter, &iter_data);
 	}
 	up_read(&net_rwsem);
 
@@ -2447,8 +2443,14 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	synchronize_net();
 
 	nf_ct_ext_bump_genid();
-	iter_data.data = data;
-	nf_ct_iterate_cleanup(iter, &iter_data);
+
+	down_read(&net_rwsem);
+	for_each_net(net) {
+		iter_data.net = net;
+		nf_ct_iterate_cleanup_net(iter, &iter_data);
+	}
+
+	up_read(&net_rwsem);
 
 	/* Another cpu might be in a rcu read section with
 	 * rcu protected pointer cleared in iter callback
@@ -2474,7 +2476,6 @@ void nf_conntrack_cleanup_end(void)
 {
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	disable_delayed_work_sync(&conntrack_gc_work.dwork);
-	kvfree(nf_conntrack_hash);
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
@@ -2587,10 +2588,10 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	 */
 
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		while (!hlist_nulls_empty(&nf_conntrack_hash[i])) {
+		while (!hlist_nulls_empty(&init_net.ct.nf_conntrack_hash[i])) {
 			unsigned int zone_id;
 
-			h = hlist_nulls_entry(nf_conntrack_hash[i].first,
+			h = hlist_nulls_entry(init_net.ct.nf_conntrack_hash[i].first,
 					      struct nf_conntrack_tuple_hash, hnnode);
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
@@ -2601,9 +2602,11 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
 	}
-	old_hash = nf_conntrack_hash;
 
-	nf_conntrack_hash = hash;
+	old_size = nf_conntrack_htable_size;
+	old_hash = init_net.ct.nf_conntrack_hash;
+
+	init_net.ct.nf_conntrack_hash = hash;
 	nf_conntrack_htable_size = hashsize;
 
 	write_seqcount_end(&nf_conntrack_generation);
@@ -2626,7 +2629,7 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 		return -EOPNOTSUPP;
 
 	/* On boot, we can set this without any fancy locking. */
-	if (!nf_conntrack_hash)
+	if (!init_net.ct.nf_conntrack_hash)
 		return param_set_uint(val, kp);
 
 	rc = kstrtouint(val, 0, &hashsize);
@@ -2679,8 +2682,8 @@ int nf_conntrack_init_start(void)
 		max_factor = 1;
 	}
 
-	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
-	if (!nf_conntrack_hash)
+	init_net.ct.nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
+	if (!init_net.ct.nf_conntrack_hash)
 		return -ENOMEM;
 
 	init_net.ct.sysctl_max = max_factor * nf_conntrack_htable_size;
@@ -2722,7 +2725,7 @@ int nf_conntrack_init_start(void)
 err_expect:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_cachep:
-	kvfree(nf_conntrack_hash);
+	kvfree(init_net.ct.nf_conntrack_hash);
 	return ret;
 }
 
@@ -2779,6 +2782,9 @@ int nf_conntrack_init_net(struct net *net)
 	nf_conntrack_ecache_pernet_init(net);
 	nf_conntrack_proto_pernet_init(net);
 
+	if (!net_eq(net, &init_net))
+		net->ct.nf_conntrack_hash = init_net.ct.nf_conntrack_hash;
+
 	return 0;
 
 err_expect:
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index df243d494afd..068e831545ec 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1244,7 +1244,8 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			spin_unlock(lockp);
 			goto out;
 		}
-		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
+		hlist_nulls_for_each_entry(h, n,
+					   &init_net.ct.nf_conntrack_hash[cb->args[0]],
 					   hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 787c506c15bd..e610a0887cc2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -155,7 +155,7 @@ static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 	st->time_now = ktime_get_real_ns();
 	rcu_read_lock();
 
-	nf_conntrack_get_ht(&st->hash, &st->htable_size);
+	nf_conntrack_get_ht(&init_net, &st->hash, &st->htable_size);
 
 	if (*pos == 0) {
 		st->skip_elems = 0;
@@ -1131,6 +1131,12 @@ static void nf_conntrack_pernet_exit(struct list_head *net_exit_list)
 		nf_conntrack_fini_net(net);
 
 	nf_conntrack_cleanup_net_list(net_exit_list);
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (net_eq(net, &init_net))
+			kvfree(net->ct.nf_conntrack_hash);
+		net->ct.nf_conntrack_hash = NULL;
+	}
 }
 
 static struct pernet_operations nf_conntrack_net_ops = {
-- 
2.51.0

