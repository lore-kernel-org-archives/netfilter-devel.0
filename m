Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFD23358B6
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361333; cv=none; b=tDuOdaI8Q4hI6yhNcnt46RK/xqAZV8kBph53ZhqTg/wGgLVq2TdWNG0PYXnBDPTyQ8GwfpLvd0+jFtmokSv1irOCT2Cl5UxGND6/xeq1CTMzJzM1RFQ0FEa/SfMaPZSRpiFEpyv66APnI6c8blB8EExBdyDaR4OwdNwvp2tQoxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361333; c=relaxed/simple;
	bh=Bj7UE/TERL0k6R4LGGs+U3NelL8JgWnWqPOv4jrxMzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVRimtlGUJMcS6y8UWwcW9klchuXkrBSU/4emPTtDRWx8GWyp90MyQT7pnPK3aNkUVMfpFcUbUMvyKJxOiSWEd2i0QgyV67NnHCWrvrFqtaX7MDX9lHwvH3A9vlVTz63OdL9+RO17TI3VINw6zBwx0BCdlcY0Bdwz3h1RbQg7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D5D8F6031F; Wed,  5 Nov 2025 17:48:49 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 08/11] netfilter: conntrack: make nf_conntrack hash table pernet
Date: Wed,  5 Nov 2025 17:48:02 +0100
Message-ID: <20251105164805.3992-9-fw@strlen.de>
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

Make net->ct.hashtable distinct for each netns.

Allocation is done from nf_conntrack_init_net().
This is not optimal, as we register conntrack hooks on demand.

A followup patch will delay the allocation until after conntrack
functionality is requested by userspace.

Earlier hack to prefer init_net.ct.nf_conntrack_hash is removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h    |  12 +--
 include/net/netns/conntrack.h           |   3 +-
 net/netfilter/nf_conntrack_core.c       | 120 ++++++++++++++----------
 net/netfilter/nf_conntrack_expect.c     |   2 +-
 net/netfilter/nf_conntrack_netlink.c    |   8 +-
 net/netfilter/nf_conntrack_proto.c      |   2 +-
 net/netfilter/nf_conntrack_standalone.c |  34 +++----
 net/netfilter/nf_nat_core.c             |   2 +-
 8 files changed, 99 insertions(+), 84 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d3e419c08cc1..e6c3a7dba8dd 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -77,6 +77,7 @@ struct nf_conntrack_net {
 	unsigned int users6;
 	unsigned int users_bridge;
 #ifdef CONFIG_SYSCTL
+	unsigned int htable_size_user;
 	struct ctl_table_header	*sysctl_header;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -345,10 +346,8 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
-int nf_conntrack_hash_resize(unsigned int hashsize);
+int nf_conntrack_hash_resize(struct net *net, unsigned int hashsize);
 
-extern struct hlist_nulls_head *nf_conntrack_hash;
-extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
 
 /* must be called with rcu read lock held */
@@ -361,9 +360,8 @@ nf_conntrack_get_ht(struct net *net, struct hlist_nulls_head **hash,
 
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
-		hsz = nf_conntrack_htable_size;
+		hsz = net->ct.nf_conntrack_htable_size;
 		hptr = net->ct.nf_conntrack_hash;
-		hptr = init_net.ct.nf_conntrack_hash;
 	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
 
 	*hash = hptr;
@@ -394,9 +392,7 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 static inline unsigned int nf_conntrack_max(const struct net *net)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return min(init_net.ct.sysctl_max, net->ct.sysctl_max);
-#else
-	return 0;
+	return net->ct.nf_conntrack_max;
 #endif
 }
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 96b326bc1cd7..32c9e6ee9c2c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -89,10 +89,11 @@ struct netns_ct {
 	u8			sysctl_acct;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
-	unsigned int		sysctl_max;
 
+	unsigned int nf_conntrack_htable_size;
 	struct ip_conntrack_stat __percpu *stat;
 	struct hlist_nulls_head *nf_conntrack_hash;
+	unsigned int nf_conntrack_max;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b2f0dffb7f79..bbe195f34904 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -63,6 +63,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
+static unsigned int conntrack_htable_autosize __ro_after_init;
 
 /* serialize hash resizes and nf_ct_iterate_cleanup */
 static DEFINE_MUTEX(nf_conntrack_mutex);
@@ -184,9 +185,6 @@ static void nf_conntrack_all_unlock(void)
 	spin_unlock(&nf_conntrack_locks_all_lock);
 }
 
-unsigned int nf_conntrack_htable_size __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
-
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -208,9 +206,9 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 			&key);
 }
 
-static u32 scale_hash(u32 hash)
+static u32 scale_hash(const struct net *net, u32 hash)
 {
-	return reciprocal_scale(hash, nf_conntrack_htable_size);
+	return reciprocal_scale(hash, net->ct.nf_conntrack_htable_size);
 }
 
 static u32 __hash_conntrack(const struct net *net,
@@ -225,7 +223,7 @@ static u32 hash_conntrack(const struct net *net,
 			  const struct nf_conntrack_tuple *tuple,
 			  unsigned int zoneid)
 {
-	return scale_hash(hash_conntrack_raw(tuple, zoneid, net));
+	return scale_hash(net, hash_conntrack_raw(tuple, zoneid, net));
 }
 
 static bool nf_ct_get_tuple_ports(const struct sk_buff *skb,
@@ -722,9 +720,12 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 	struct hlist_nulls_head *ct_hash;
 	struct hlist_nulls_node *n;
 	unsigned int bucket, hsize;
+	bool restart;
 
 begin:
-	nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
+	restart = false;
+
+	nf_conntrack_get_ht(net, &ct_hash, &hsize);
 	bucket = reciprocal_scale(hash, hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[bucket], hnnode) {
@@ -738,13 +739,19 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
 
 		if (nf_ct_key_equal(h, tuple, zone, net))
 			return h;
+
+		if (net_eq(net, nf_ct_net(ct)))
+			continue;
+
+		restart = true;
+		break;
 	}
 	/*
 	 * if the nulls value we got at the end of this lookup is
 	 * not the expected one, we must restart lookup.
 	 * We probably met an item that was moved to another chain.
 	 */
-	if (get_nulls_value(n) != bucket) {
+	if (restart || get_nulls_value(n) != bucket) {
 		NF_CT_STAT_INC_ATOMIC(net, search_restart);
 		goto begin;
 	}
@@ -876,7 +883,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
-	ct_hash = init_net.ct.nf_conntrack_hash;
+	ct_hash = net->ct.nf_conntrack_hash;
 	max_chainlen = MIN_CHAINLEN + get_random_u32_below(MAX_CHAINLEN);
 
 	/* See if there's one in the list already, including reverse */
@@ -1077,7 +1084,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 	zone = nf_ct_zone(loser_ct);
 	net = nf_ct_net(loser_ct);
 
-	ct_hash = init_net.ct.nf_conntrack_hash;
+	ct_hash = net->ct.nf_conntrack_hash;
 
 	/* Reply direction must never result in a clash, unless both origin
 	 * and reply tuples are identical.
@@ -1219,13 +1226,13 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
 		/* reuse the hash saved before */
 		hash = *(unsigned long *)&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev;
-		hash = scale_hash(hash);
+		hash = scale_hash(net, hash);
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
 	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
-	ct_hash = init_net.ct.nf_conntrack_hash;
+	ct_hash = net->ct.nf_conntrack_hash;
 
 	/* We're not in hash table, and we refuse to set up related
 	 * connections for unconfirmed conns.  But packet copies and
@@ -1356,7 +1363,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 
 	rcu_read_lock();
  begin:
-	nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
+	nf_conntrack_get_ht(net, &ct_hash, &hsize);
 	hash = __hash_conntrack(net, tuple, nf_ct_zone_id(zone, IP_CT_DIR_REPLY), hsize);
 
 	hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[hash], hnnode) {
@@ -1463,7 +1470,7 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 		unsigned int hsize, drops;
 
 		rcu_read_lock();
-		nf_conntrack_get_ht(&init_net, &ct_hash, &hsize);
+		nf_conntrack_get_ht(net, &ct_hash, &hsize);
 		if (!i)
 			bucket = reciprocal_scale(hash, hsize);
 		else
@@ -2328,14 +2335,17 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 		const struct nf_ct_iter_data *iter_data, unsigned int *bucket)
 {
 	struct nf_conntrack_tuple_hash *h;
+	struct net *net = iter_data->net;
 	struct nf_conn *ct;
 	struct hlist_nulls_node *n;
+	unsigned int htable_size;
 	spinlock_t *lockp;
 
-	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
+	htable_size = net->ct.nf_conntrack_htable_size;
+	for (; *bucket < htable_size; (*bucket)++) {
 		struct hlist_nulls_head *hslot;
 
-		hslot = &init_net.ct.nf_conntrack_hash[*bucket];
+		hslot = &net->ct.nf_conntrack_hash[*bucket];
 		if (hlist_nulls_empty(hslot))
 			continue;
 
@@ -2543,8 +2553,8 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	if (nr_slots > (INT_MAX / sizeof(struct hlist_nulls_head)))
 		return NULL;
 
-	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
-
+	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head),
+			GFP_KERNEL_ACCOUNT);
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)
 			INIT_HLIST_NULLS_HEAD(&hash[i], i);
@@ -2553,7 +2563,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 }
 EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable);
 
-int nf_conntrack_hash_resize(unsigned int hashsize)
+int nf_conntrack_hash_resize(struct net *net, unsigned int hashsize)
 {
 	int i, bucket;
 	unsigned int old_size;
@@ -2569,7 +2579,7 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 		return -ENOMEM;
 
 	mutex_lock(&nf_conntrack_mutex);
-	old_size = nf_conntrack_htable_size;
+	old_size = net->ct.nf_conntrack_htable_size;
 	if (old_size == hashsize) {
 		mutex_unlock(&nf_conntrack_mutex);
 		kvfree(hash);
@@ -2586,11 +2596,12 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	 * though since that required taking the locks.
 	 */
 
-	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		while (!hlist_nulls_empty(&init_net.ct.nf_conntrack_hash[i])) {
+	old_size = net->ct.nf_conntrack_htable_size;
+	for (i = 0; i < old_size; i++) {
+		while (!hlist_nulls_empty(&net->ct.nf_conntrack_hash[i])) {
 			unsigned int zone_id;
 
-			h = hlist_nulls_entry(init_net.ct.nf_conntrack_hash[i].first,
+			h = hlist_nulls_entry(net->ct.nf_conntrack_hash[i].first,
 					      struct nf_conntrack_tuple_hash, hnnode);
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
@@ -2602,11 +2613,11 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 		}
 	}
 
-	old_size = nf_conntrack_htable_size;
-	old_hash = init_net.ct.nf_conntrack_hash;
+	old_size = net->ct.nf_conntrack_htable_size;
+	old_hash = net->ct.nf_conntrack_hash;
 
-	init_net.ct.nf_conntrack_hash = hash;
-	nf_conntrack_htable_size = hashsize;
+	net->ct.nf_conntrack_hash = hash;
+	net->ct.nf_conntrack_htable_size = hashsize;
 
 	write_seqcount_end(&nf_conntrack_generation);
 	nf_conntrack_all_unlock();
@@ -2635,7 +2646,7 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 	if (rc)
 		return rc;
 
-	return nf_conntrack_hash_resize(hashsize);
+	return nf_conntrack_hash_resize(&init_net, hashsize);
 }
 
 static unsigned int nf_conntrack_htable_autosize(void)
@@ -2651,7 +2662,7 @@ static unsigned int nf_conntrack_htable_autosize(void)
 	else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 		ht_size = 65536;
 
-	if (nf_conntrack_htable_size < 1024)
+	if (ht_size < 1024)
 		ht_size = 1024;
 
 	return ht_size;
@@ -2659,7 +2670,6 @@ static unsigned int nf_conntrack_htable_autosize(void)
 
 int nf_conntrack_init_start(void)
 {
-	int max_factor = 8;
 	int ret = -ENOMEM;
 	int i;
 
@@ -2669,23 +2679,7 @@ int nf_conntrack_init_start(void)
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
-	if (!nf_conntrack_htable_size) {
-		nf_conntrack_htable_size = nf_conntrack_htable_autosize();
-
-		/* Use a max. factor of one by default to keep the average
-		 * hash chain length at 2 entries.  Each entry has to be added
-		 * twice (once for original direction, once for reply).
-		 * When a table size is given we use the old value of 8 to
-		 * avoid implicit reduction of the max entries setting.
-		 */
-		max_factor = 1;
-	}
-
-	init_net.ct.nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
-	if (!init_net.ct.nf_conntrack_hash)
-		return -ENOMEM;
-
-	init_net.ct.sysctl_max = max_factor * nf_conntrack_htable_size;
+	conntrack_htable_autosize = nf_conntrack_htable_autosize();
 
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn),
@@ -2721,7 +2715,6 @@ int nf_conntrack_init_start(void)
 err_expect:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_cachep:
-	kvfree(init_net.ct.nf_conntrack_hash);
 	return ret;
 }
 
@@ -2759,7 +2752,31 @@ void nf_conntrack_init_end(void)
 int nf_conntrack_init_net(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
+	unsigned int ht_size = conntrack_htable_autosize;
 	int ret = -ENOMEM;
+	int max_factor = 1;
+
+	net->ct.nf_conntrack_max = conntrack_htable_autosize;
+
+	if (&init_net == net &&
+	    init_net.ct.nf_conntrack_htable_size) {
+		/* Use a max. factor of one by default to keep the average
+		 * hash chain length at 2 entries.  Each entry has to be added
+		 * twice (once for original direction, once for reply).
+		 * When a table size is given we use the old value of 8 to
+		 * avoid implicit reduction of the max entries setting.
+		 */
+		ht_size = init_net.ct.nf_conntrack_htable_size;
+		max_factor = 8;
+	}
+
+	net->ct.nf_conntrack_hash = nf_ct_alloc_hashtable(&ht_size, 1);
+	if (!net->ct.nf_conntrack_hash)
+		return ret;
+
+	net->ct.nf_conntrack_htable_size = ht_size;
+	cnet->htable_size_user = ht_size;
+	net->ct.nf_conntrack_max = ht_size * max_factor;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
 	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
@@ -2767,7 +2784,7 @@ int nf_conntrack_init_net(struct net *net)
 
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat)
-		return ret;
+		goto err_stat;
 
 	ret = nf_conntrack_expect_pernet_init(net);
 	if (ret < 0)
@@ -2778,15 +2795,14 @@ int nf_conntrack_init_net(struct net *net)
 	nf_conntrack_ecache_pernet_init(net);
 	nf_conntrack_proto_pernet_init(net);
 
-	if (!net_eq(net, &init_net))
-		net->ct.nf_conntrack_hash = init_net.ct.nf_conntrack_hash;
-
 	conntrack_gc_work_init(&cnet->gc_work, net);
 
 	return 0;
 
 err_expect:
 	free_percpu(net->ct.stat);
+err_stat:
+	kvfree(net->ct.nf_conntrack_hash);
 	return ret;
 }
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f..a3b9539e1036 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -717,7 +717,7 @@ void nf_conntrack_expect_pernet_fini(struct net *net)
 int nf_conntrack_expect_init(void)
 {
 	if (!nf_ct_expect_hsize) {
-		nf_ct_expect_hsize = nf_conntrack_htable_size / 256;
+		nf_ct_expect_hsize = init_net.ct.nf_conntrack_htable_size / 256;
 		if (!nf_ct_expect_hsize)
 			nf_ct_expect_hsize = 1;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 068e831545ec..d707ef7e2d75 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1221,6 +1221,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
+	unsigned int htable_size;
 	struct nf_conn *nf_ct_evict[8];
 	struct nf_conn *ct;
 	int res, i;
@@ -1229,7 +1230,8 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	i = 0;
 
 	local_bh_disable();
-	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
+	htable_size = net->ct.nf_conntrack_htable_size;
+	for (; cb->args[0] < htable_size; cb->args[0]++) {
 restart:
 		while (i) {
 			i--;
@@ -1240,12 +1242,12 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 
 		lockp = &nf_conntrack_locks[cb->args[0] % CONNTRACK_LOCKS];
 		nf_conntrack_lock(lockp);
-		if (cb->args[0] >= nf_conntrack_htable_size) {
+		if (cb->args[0] >= htable_size) {
 			spin_unlock(lockp);
 			goto out;
 		}
 		hlist_nulls_for_each_entry(h, n,
-					   &init_net.ct.nf_conntrack_hash[cb->args[0]],
+					   &net->ct.nf_conntrack_hash[cb->args[0]],
 					   hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index bc1d96686b9c..01eec82f4cba 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -687,7 +687,7 @@ void nf_conntrack_proto_pernet_init(struct net *net)
 }
 
 module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
-		  &nf_conntrack_htable_size, 0600);
+		  &init_net.ct.nf_conntrack_htable_size, 0600);
 
 MODULE_ALIAS("ip_conntrack");
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e980213ef602..f31c95b77041 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -156,7 +156,7 @@ static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 	st->time_now = ktime_get_real_ns();
 	rcu_read_lock();
 
-	nf_conntrack_get_ht(&init_net, &st->hash, &st->htable_size);
+	nf_conntrack_get_ht(net, &st->hash, &st->htable_size);
 
 	if (*pos == 0) {
 		st->skip_elems = 0;
@@ -536,27 +536,27 @@ EXPORT_SYMBOL_GPL(nf_conntrack_count);
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
-/* size the user *wants to set */
-static unsigned int nf_conntrack_htable_size_user __read_mostly;
-
 static int
 nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
+	struct net *net = table->extra1;
+	struct nf_conntrack_net *cnet;
+	unsigned int size_old;
 	int ret;
 
-	/* module_param hashsize could have changed value */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	cnet = nf_ct_pernet(net);
+	size_old = net->ct.nf_conntrack_htable_size;
 
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
 
 	/* update ret, we might not be able to satisfy request */
-	ret = nf_conntrack_hash_resize(nf_conntrack_htable_size_user);
+	ret = nf_conntrack_hash_resize(net, cnet->htable_size_user);
 
 	/* update it to the actual value used by conntrack */
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	cnet->htable_size_user = net->ct.nf_conntrack_htable_size;
 	return ret;
 }
 
@@ -645,7 +645,7 @@ enum nf_ct_sysctl_index {
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
-		.data		= &init_net.ct.sysctl_max,
+		.data		= &init_net.ct.nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -660,10 +660,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_BUCKETS] = {
 		.procname       = "nf_conntrack_buckets",
-		.data           = &nf_conntrack_htable_size_user,
+		.data           = &init_net.ct.nf_conntrack_htable_size,
 		.maxlen         = sizeof(unsigned int),
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
+		.extra1		= &init_net,
+		.maxlen         = sizeof(unsigned int),
 	},
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
@@ -926,7 +928,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-		.data		= &init_net.ct.sysctl_max,
+		.data		= &init_net.ct.nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -1017,8 +1019,10 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		return -ENOMEM;
 
 	table[NF_SYSCTL_CT_COUNT].data = &cnet->count;
+	table[NF_SYSCTL_CT_BUCKETS].data = &cnet->htable_size_user;
+	table[NF_SYSCTL_CT_BUCKETS].extra1 = net;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
-	table[NF_SYSCTL_CT_MAX].data = &net->ct.sysctl_max;
+	table[NF_SYSCTL_CT_MAX].data = &net->ct.nf_conntrack_max;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -1097,7 +1101,6 @@ static int nf_conntrack_pernet_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_checksum = 1;
-	net->ct.sysctl_max = init_net.ct.sysctl_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
@@ -1138,8 +1141,7 @@ static void nf_conntrack_pernet_exit(struct list_head *net_exit_list)
 	nf_conntrack_cleanup_net_list(net_exit_list);
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
-		if (net_eq(net, &init_net))
-			kvfree(net->ct.nf_conntrack_hash);
+		kvfree(net->ct.nf_conntrack_hash);
 		net->ct.nf_conntrack_hash = NULL;
 	}
 }
@@ -1167,8 +1169,6 @@ static int __init nf_conntrack_standalone_init(void)
 		ret = -ENOMEM;
 		goto out_sysctl;
 	}
-
-	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
 #endif
 
 	nf_conntrack_init_end();
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 78a61dac4ade..2e660f4d4ac1 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1330,7 +1330,7 @@ static int __init nf_nat_init(void)
 	int ret, i;
 
 	/* Leave them the same for the moment. */
-	nf_nat_htable_size = nf_conntrack_htable_size;
+	nf_nat_htable_size = init_net.ct.nf_conntrack_htable_size;
 	if (nf_nat_htable_size < CONNTRACK_LOCKS)
 		nf_nat_htable_size = CONNTRACK_LOCKS;
 
-- 
2.51.0

