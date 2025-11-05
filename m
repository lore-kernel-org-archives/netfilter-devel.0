Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE86337B8D
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361346; cv=none; b=cxztyR7v1UeTJQH6sJ+hIXs6Vlqmn3+y+Wwj6WYDT6jg619X80udvpxdiSUTfF9dVh9VZD/D+tlrB8SsGmsOvHb7M2Injx8DpANv1WZn+bW+iEZ4K9iapNZPCI2rkyqO2m1P+lYK0uNu6+SbtfsCalGvIKJMjr7FFw9lAsZ7+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361346; c=relaxed/simple;
	bh=L3tdXJ9N6eWjVe0HWRmKi0S/af5Feo+VH5fBpVLz3e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrNgHER5i+quO+3zxUsuCBxLFndAItxxy/Iu5SaAMX+LI5mCBEhOnk9O0ApvMjY6JugT11r0TYoqFcDkOnfqJlBuoPyrUBqg99VqAgHYF2cGFhV0/igHxCUG1BJUtRyjVG9QmtjaM+05T54z2UovQWwts07AFFOdTELWaLTqvwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EE4CD604A8; Wed,  5 Nov 2025 17:49:02 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 11/11] netfilter: nf_nat: make bysource hash table pernet
Date: Wed,  5 Nov 2025 17:48:05 +0100
Message-ID: <20251105164805.3992-12-fw@strlen.de>
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

Improve netns isolation by providing each net namespace
with its own table.

Table is allocated when the namespace requests nat
functionality.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 100 ++++++++++++++++++++++++++----------
 1 file changed, 74 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2e660f4d4ac1..2add90e3d636 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -35,10 +35,6 @@ static spinlock_t nf_nat_locks[CONNTRACK_LOCKS];
 static DEFINE_MUTEX(nf_nat_proto_mutex);
 static unsigned int nat_net_id __read_mostly;
 
-static struct hlist_head *nf_nat_bysource __read_mostly;
-static unsigned int nf_nat_htable_size __read_mostly;
-static siphash_aligned_key_t nf_nat_hash_rnd;
-
 struct nf_nat_lookup_hook_priv {
 	struct nf_hook_entries __rcu *entries;
 
@@ -51,9 +47,18 @@ struct nf_nat_hooks_net {
 };
 
 struct nat_net {
+	struct hlist_head *nf_nat_bysource;
+	unsigned int nf_nat_htable_size;
+	siphash_key_t hash_rnd;
+
 	struct nf_nat_hooks_net nat_proto_net[NFPROTO_NUMPROTO];
 };
 
+static struct nat_net *nf_nat_get_pernet(const struct net *net)
+{
+	return net_generic(net, nat_net_id);
+}
+
 #ifdef CONFIG_XFRM
 static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 				       const struct nf_conn *ct,
@@ -153,30 +158,27 @@ hash_by_src(const struct net *net,
 	    const struct nf_conntrack_zone *zone,
 	    const struct nf_conntrack_tuple *tuple)
 {
+	struct nat_net *nat_pernet = nf_nat_get_pernet(net);
 	unsigned int hash;
 	struct {
 		struct nf_conntrack_man src;
-		u32 net_mix;
 		u32 protonum;
 		u32 zone;
 	} __aligned(SIPHASH_ALIGNMENT) combined;
 
-	get_random_once(&nf_nat_hash_rnd, sizeof(nf_nat_hash_rnd));
-
 	memset(&combined, 0, sizeof(combined));
 
 	/* Original src, to ensure we map it consistently if poss. */
 	combined.src = tuple->src;
-	combined.net_mix = net_hash_mix(net);
 	combined.protonum = tuple->dst.protonum;
 
 	/* Zone ID can be used provided its valid for both directions */
 	if (zone->dir == NF_CT_DEFAULT_ZONE_DIR)
 		combined.zone = zone->id;
 
-	hash = siphash(&combined, sizeof(combined), &nf_nat_hash_rnd);
+	hash = siphash(&combined, sizeof(combined), &nat_pernet->hash_rnd);
 
-	return reciprocal_scale(hash, nf_nat_htable_size);
+	return reciprocal_scale(hash, nat_pernet->nf_nat_htable_size);
 }
 
 /**
@@ -481,10 +483,12 @@ find_appropriate_src(struct net *net,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range2 *range)
 {
+	struct nat_net *nat_pernet = nf_nat_get_pernet(net);
 	unsigned int h = hash_by_src(net, zone, tuple);
 	const struct nf_conn *ct;
 
-	hlist_for_each_entry_rcu(ct, &nf_nat_bysource[h], nat_bysource) {
+	hlist_for_each_entry_rcu(ct, &nat_pernet->nf_nat_bysource[h],
+				 nat_bysource) {
 		if (same_src(ct, tuple) &&
 		    net_eq(net, nf_ct_net(ct)) &&
 		    nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL)) {
@@ -826,6 +830,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 	}
 
 	if (maniptype == NF_NAT_MANIP_SRC) {
+		struct nat_net *nat_net = nf_nat_get_pernet(net);
 		unsigned int srchash;
 		spinlock_t *lock;
 
@@ -834,7 +839,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
 		spin_lock_bh(lock);
 		hlist_add_head_rcu(&ct->nat_bysource,
-				   &nf_nat_bysource[srchash]);
+				   &nat_net->nf_nat_bysource[srchash]);
 		spin_unlock_bh(lock);
 	}
 
@@ -1189,6 +1194,22 @@ static struct nf_ct_helper_expectfn follow_master_nat = {
 	.expectfn	= nf_nat_follow_master,
 };
 
+static bool nf_nat_alloc_bysource(struct nat_net *nat_net, unsigned int size)
+{
+	struct hlist_head *nf_nat_bysource;
+
+	nf_nat_bysource = nf_ct_alloc_hashtable(&size, 0);
+	if (!nf_nat_bysource)
+		return false;
+
+	get_random_bytes_wait(&nat_net->hash_rnd,
+			      sizeof(nat_net->hash_rnd));
+
+	nat_net->nf_nat_bysource = nf_nat_bysource;
+	nat_net->nf_nat_htable_size = size;
+	return true;
+}
+
 int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *orig_nat_ops, unsigned int ops_count)
 {
@@ -1215,6 +1236,13 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		return -EINVAL;
 
 	mutex_lock(&nf_nat_proto_mutex);
+
+	if (!nat_net->nf_nat_bysource &&
+	    !nf_nat_alloc_bysource(nat_net, net->ct.nf_conntrack_htable_size)) {
+		mutex_unlock(&nf_nat_proto_mutex);
+		return -ENOMEM;
+	}
+
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
@@ -1312,8 +1340,41 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	mutex_unlock(&nf_nat_proto_mutex);
 }
 
+static int __net_init nf_nat_net_init(struct net *net)
+{
+	unsigned int nf_nat_htable_size;
+
+	/* Leave them the same for the moment. */
+	nf_nat_htable_size = net->ct.nf_conntrack_htable_size;
+	if (nf_nat_htable_size < CONNTRACK_LOCKS)
+		nf_nat_htable_size = CONNTRACK_LOCKS;
+
+	return 0;
+}
+
+static void __net_exit nf_nat_net_exit_batch(struct list_head *net_exit_list)
+{
+	struct nf_nat_proto_clean clean = {};
+	struct net *net;
+
+	/* all nat hooks must have been removed at this point */
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		struct nat_net *nat_net = nf_nat_get_pernet(net);
+		struct nf_ct_iter_data iter_data = {
+			.data = &clean,
+			.net = net,
+		};
+
+		nf_ct_iterate_cleanup_net(nf_nat_proto_clean, &iter_data);
+
+		kvfree(nat_net->nf_nat_bysource);
+	}
+}
+
 static struct pernet_operations nat_net_ops = {
 	.id = &nat_net_id,
+	.init = nf_nat_net_init,
+	.exit_batch = nf_nat_net_exit_batch,
 	.size = sizeof(struct nat_net),
 };
 
@@ -1329,23 +1390,12 @@ static int __init nf_nat_init(void)
 {
 	int ret, i;
 
-	/* Leave them the same for the moment. */
-	nf_nat_htable_size = init_net.ct.nf_conntrack_htable_size;
-	if (nf_nat_htable_size < CONNTRACK_LOCKS)
-		nf_nat_htable_size = CONNTRACK_LOCKS;
-
-	nf_nat_bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size, 0);
-	if (!nf_nat_bysource)
-		return -ENOMEM;
-
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_nat_locks[i]);
 
 	ret = register_pernet_subsys(&nat_net_ops);
-	if (ret < 0) {
-		kvfree(nf_nat_bysource);
+	if (ret < 0)
 		return ret;
-	}
 
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
@@ -1358,7 +1408,6 @@ static int __init nf_nat_init(void)
 		nf_ct_helper_expectfn_unregister(&follow_master_nat);
 		synchronize_net();
 		unregister_pernet_subsys(&nat_net_ops);
-		kvfree(nf_nat_bysource);
 	}
 
 	return ret;
@@ -1374,7 +1423,6 @@ static void __exit nf_nat_cleanup(void)
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
 	synchronize_net();
-	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
 }
 
-- 
2.51.0

