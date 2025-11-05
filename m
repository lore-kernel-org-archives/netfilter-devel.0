Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D82F337115
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361330; cv=none; b=BXaFBiejheRuD/pfVK4c+GKl2V/QNq8jAF1quQ/FZ0MI38oZ4o8LSovS9qvSVnIOwnJYFN2r0oacvnZj/hTYO8kUyg4kN47EbXXBlmJeDKws1udfwdPZV/bhmtbK1htNLvfe2csLlBS8Iga8yFoMMBo2p6TfpP9Jlt00u8hDMW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361330; c=relaxed/simple;
	bh=yl1VuidYihFKf1hXaJnNO5epsbF86la8cPxBUiFVqts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+8XUhTOLArupYiRxoJr638m5K+TAMy85NrA2gCu1ztxX//L5B82xg3niljkCuA9tsO9FPFYHpLVi9A+1PajqxZWCjAumqNCkJUtf3vodCFwlEzCsqnH7zKDH+YEgdkSmerFdGvgCYDrZm3L7APIi6ikziVgpdJKGnfU2D+Nn8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7C2B46020C; Wed,  5 Nov 2025 17:48:45 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 07/11] netfilter: conntrack: init and start independent gc workers when needed
Date: Wed,  5 Nov 2025 17:48:01 +0100
Message-ID: <20251105164805.3992-8-fw@strlen.de>
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

Next step in pernet coversion: make the gc worker pernet.

Because net->ct.nf_conntrack_hash still aliases the init_net one this
patch makes little sense, its just preparation work to keep this change
separate.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h      | 21 ++++++++
 include/net/netfilter/nf_conntrack_core.h |  1 -
 net/netfilter/nf_conntrack_core.c         | 58 +++++++++++------------
 net/netfilter/nf_conntrack_standalone.c   |  7 ++-
 4 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a90654bb2410..d3e419c08cc1 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -47,6 +47,26 @@ struct nf_conntrack_net_ecache {
 	struct hlist_nulls_head dying_list;
 };
 
+/**
+ *	struct conntrack_gc_work - gc state
+ *	@dwork: delayed GC work item
+ *	@net: net namespace the gc worker belongs to
+ *	@next_bucket: next conntrack hash bucket to work on
+ *	@avg_timeout: average timeout of conntracks seen
+ *	@count: non-expired conntracks seen
+ *	@start_time: nfct_time_stamp taken on start of work function
+ *	@early_drop: remove non-assured and closing conntracks too
+ */
+struct conntrack_gc_work {
+	struct delayed_work	dwork;
+	possible_net_t		net;
+	u32			next_bucket;
+	u32			avg_timeout;
+	u32			count;
+	u32			start_time;
+	bool			early_drop;
+};
+
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
@@ -62,6 +82,7 @@ struct nf_conntrack_net {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct nf_conntrack_net_ecache ecache;
 #endif
+	struct conntrack_gc_work gc_work;
 };
 
 #include <linux/types.h>
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3384859a8921..eb6e05c654b2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -35,7 +35,6 @@ int nf_conntrack_proto_init(void);
 void nf_conntrack_proto_fini(void);
 
 int nf_conntrack_init_start(void);
-void nf_conntrack_cleanup_start(void);
 
 void nf_conntrack_init_end(void);
 void nf_conntrack_cleanup_end(void);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f2ff0e70f5ab..b2f0dffb7f79 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -60,15 +60,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(nf_conntrack_expect_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 
-struct conntrack_gc_work {
-	struct delayed_work	dwork;
-	u32			next_bucket;
-	u32			avg_timeout;
-	u32			count;
-	u32			start_time;
-	bool			early_drop;
-};
-
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
@@ -95,8 +86,6 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define MIN_CHAINLEN	50u
 #define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
-static struct conntrack_gc_work conntrack_gc_work;
-
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
 {
 	/* 1) Acquire the lock */
@@ -1518,11 +1507,15 @@ static void gc_worker(struct work_struct *work)
 	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
 	unsigned int expired_count = 0;
+	struct nf_conntrack_net *cnet;
 	unsigned long next_run;
+	struct net *net;
 	s32 delta_time;
 	long count;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
+	net = read_pnet(&gc_work->net);
+	cnet = nf_ct_pernet(net);
 
 	i = gc_work->next_bucket;
 
@@ -1545,7 +1538,7 @@ static void gc_worker(struct work_struct *work)
 
 		rcu_read_lock();
 
-		nf_conntrack_get_ht(&init_net, &ct_hash, &hashsz);
+		nf_conntrack_get_ht(net, &ct_hash, &hashsz);
 		if (i >= hashsz) {
 			rcu_read_unlock();
 			break;
@@ -1553,8 +1546,6 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			unsigned int nf_conntrack_max95 = 0;
-			struct nf_conntrack_net *cnet;
-			struct net *net;
 			long expires;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
@@ -1573,6 +1564,9 @@ static void gc_worker(struct work_struct *work)
 				goto early_exit;
 			}
 
+			if (!net_eq(net, nf_ct_net(tmp)))
+				break;
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				expired_count++;
@@ -1582,7 +1576,6 @@ static void gc_worker(struct work_struct *work)
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
 			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
-			net = nf_ct_net(tmp);
 
 			if (gc_work->early_drop)
 				nf_conntrack_max95 = nf_conntrack_max(net) / 100u * 95u;
@@ -1590,7 +1583,6 @@ static void gc_worker(struct work_struct *work)
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
-			cnet = nf_ct_pernet(net);
 			if (atomic_read(&cnet->count) < nf_conntrack_max95)
 				continue;
 
@@ -1601,6 +1593,11 @@ static void gc_worker(struct work_struct *work)
 			/* load ->status after refcount increase */
 			smp_acquire__after_ctrl_dep();
 
+			if (!net_eq(net, nf_ct_net(tmp))) {
+				nf_ct_put(tmp);
+				break;
+			}
+
 			if (gc_worker_skip_ct(tmp)) {
 				nf_ct_put(tmp);
 				continue;
@@ -1650,10 +1647,19 @@ static void gc_worker(struct work_struct *work)
 		mod_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
-static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
+static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work, struct net *net)
 {
 	/* work is started on first conntrack allocation. */
 	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
+	write_pnet(&gc_work->net, net);
+}
+
+static void gc_set_early_drop(struct net *net)
+{
+	struct nf_conntrack_net *n = nf_ct_pernet(net);
+
+	if (!n->gc_work.early_drop)
+		n->gc_work.early_drop = true;
 }
 
 static struct nf_conn *
@@ -1674,8 +1680,7 @@ __nf_conntrack_alloc(struct net *net,
 
 	if (unlikely(ct_count > ct_max)) {
 		if (!early_drop(net, hash)) {
-			if (!conntrack_gc_work.early_drop)
-				conntrack_gc_work.early_drop = true;
+			gc_set_early_drop(net);
 			atomic_dec(&cnet->count);
 			if (net == &init_net)
 				net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
@@ -1715,9 +1720,9 @@ __nf_conntrack_alloc(struct net *net,
 	/* Re-arm gc_work if needed, but do not modify
 	 * in case it was already pending.
 	 */
-	if (unlikely(!delayed_work_pending(&conntrack_gc_work.dwork)))
+	if (unlikely(!delayed_work_pending(&cnet->gc_work.dwork)))
 		queue_delayed_work(system_power_efficient_wq,
-				   &conntrack_gc_work.dwork,
+				   &cnet->gc_work.dwork,
 				   GC_SCAN_INTERVAL_INIT);
 
 	return ct;
@@ -2467,15 +2472,9 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
-void nf_conntrack_cleanup_start(void)
-{
-	cleanup_nf_conntrack_bpf();
-}
-
 void nf_conntrack_cleanup_end(void)
 {
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
-	disable_delayed_work_sync(&conntrack_gc_work.dwork);
 
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
@@ -2707,8 +2706,6 @@ int nf_conntrack_init_start(void)
 	if (ret < 0)
 		goto err_proto;
 
-	conntrack_gc_work_init(&conntrack_gc_work);
-
 	ret = register_nf_conntrack_bpf();
 	if (ret < 0)
 		goto err_kfunc;
@@ -2716,7 +2713,6 @@ int nf_conntrack_init_start(void)
 	return 0;
 
 err_kfunc:
-	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	nf_conntrack_proto_fini();
 err_proto:
 	nf_conntrack_helper_fini();
@@ -2785,6 +2781,8 @@ int nf_conntrack_init_net(struct net *net)
 	if (!net_eq(net, &init_net))
 		net->ct.nf_conntrack_hash = init_net.ct.nf_conntrack_hash;
 
+	conntrack_gc_work_init(&cnet->gc_work, net);
+
 	return 0;
 
 err_expect:
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e610a0887cc2..e980213ef602 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -16,6 +16,7 @@
 
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -1080,9 +1081,13 @@ static void nf_conntrack_standalone_fini_sysctl(struct net *net)
 
 static void nf_conntrack_fini_net(struct net *net)
 {
+	struct nf_conntrack_net *ctnet = nf_ct_pernet(net);
+
 	if (enable_hooks)
 		nf_ct_netns_put(net, NFPROTO_INET);
 
+	disable_delayed_work_sync(&ctnet->gc_work.dwork);
+
 	nf_conntrack_standalone_fini_proc(net);
 	nf_conntrack_standalone_fini_sysctl(net);
 }
@@ -1186,7 +1191,7 @@ static int __init nf_conntrack_standalone_init(void)
 
 static void __exit nf_conntrack_standalone_fini(void)
 {
-	nf_conntrack_cleanup_start();
+	cleanup_nf_conntrack_bpf();
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(nf_ct_netfilter_header);
-- 
2.51.0

