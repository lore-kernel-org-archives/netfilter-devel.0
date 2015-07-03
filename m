From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [RFC PATCH v2] netfilter: nf_conntrack: fix endless loop on netns deletion
Date: Fri,  3 Jul 2015 17:03:30 +0200
Message-ID: <1187cedc8e51dae04947491baa5578f1e32cc228.1435935405.git.daniel@iogearbox.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44308 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbbGCPDf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jul 2015 11:03:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When adding connection tracking template rules to a netns, f.e. to
configure netfilter zones, the kernel will endlessly busy-loop as soon
as we try to delete the given netns in case there's at least one
template present, which is problematic i.e. if there is such bravery that
the priviledged user inside the netns is assumed untrusted.

Minimal example:

  ip netns add foo
  ip netns exec foo iptables -t raw -A PREROUTING -d 1.2.3.4 -j CT --zone 1
  ip netns del foo

What happens is that when nf_ct_iterate_cleanup() is being called from
nf_conntrack_cleanup_net_list() for a provided netns, we always end up
with a net->ct.count > 0 and thus jump back to i_see_dead_people. We
don't get a soft-lockup as we still have a schedule() point, but the
serving CPU spins on 100% from that point onwards.

Since templates are normally allocated with nf_conntrack_alloc(), we
also bump net->ct.count. The issue why they are not yet nf_ct_put() is
because the per netns .exit() handler from x_tables (which would eventually
invoke xt_CT's xt_ct_tg_destroy() that drops reference on info->ct) is
called in the dependency chain at a *later* point in time than the per
netns .exit() handler for the connection tracker.

This is clearly a chicken'n'egg problem: after the connection tracker
.exit() handler, we've teared down all the connection tracking
infrastructure already, so rightfully, xt_ct_tg_destroy() cannot be
invoked at a later point in time during the netns cleanup, as that would
lead to a use-after-free. At the same time, we cannot make x_tables depend
on the connection tracker module, so that the xt_ct_tg_destroy() would
be invoked earlier in the cleanup chain.

I first thought about adding an extra pernet subsystem with only an
.exit() handler for each nf_conntrack_tmpl_insert() user, so that their
.exit() handlers are then being called *before* nf_conntrack_cleanup_net_list()
(since these users depend on nf_conntrack), but at that time, packets
could still be residing in the connection tracker.

Current approach that resolves this layering violation for me, would
be to add a destructor with a callback handler to the private protocol
area union and have that invoked from nf_ct_tmpls_cleanup() via
nf_conntrack_cleanup_net_list() when we made sure no other non-template
ct object is still in the system.

The callback could then invoke f.e. __xt_ct_tg_destroy(), which then sets
a flag in the info structure that the ct object should not be touched at a
later point in time again. Since ct pointer locations are different for
various xt_CT revisions, I was using a private flag to indicate this to
info as this overlaps in any case.

If the target would have been removed otherwise (f.e. flush), then it's
also not present in the per cpu tmpl list anymore. Since we have info but
not par available, we need to drop the module referencere in xt_CT case
via nf_ct_l3proto_module_put() at a later point in time than the callback.

I believe this issue should be present since xt_CT.

Fixes: 84f3bb9ae9db ("netfilter: xtables: add CT target")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 RFC in the meaning of: are there any better ideas? ;)

 There's some extra churn due to avoiding any forward declarations in
 xt_CT, I could still split this out into a separate patch in case we
 find that it's an acceptable way forward. Thanks!

 include/net/netfilter/nf_conntrack.h |   7 ++
 include/net/netns/conntrack.h        |   1 +
 include/uapi/linux/netfilter/xt_CT.h |   2 +
 net/netfilter/nf_conntrack_core.c    |  41 +++++++++-
 net/netfilter/nf_synproxy_core.c     |  14 +++-
 net/netfilter/xt_CT.c                | 140 +++++++++++++++++++++--------------
 6 files changed, 147 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 095433b..fb7e7b0 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -26,6 +26,12 @@
 
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+/* template private data */
+struct nf_ct_tmpl {
+	void (*dest_cb)(struct nf_conn *tmpl, void *arg);
+	void *arg;
+};
+
 /* per conntrack: protocol private data */
 union nf_conntrack_proto {
 	/* insert conntrack proto private data here */
@@ -33,6 +39,7 @@ union nf_conntrack_proto {
 	struct ip_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
 	struct nf_ct_gre gre;
+	struct nf_ct_tmpl tmpl;
 };
 
 union nf_conntrack_expect_proto {
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 29d6a94..9eff3db 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -112,5 +112,6 @@ struct netns_ct {
 	struct hlist_head	*nat_bysource;
 	unsigned int		nat_htable_size;
 #endif
+	atomic_t		tmpl_count;
 };
 #endif
diff --git a/include/uapi/linux/netfilter/xt_CT.h b/include/uapi/linux/netfilter/xt_CT.h
index 5a688c1..18cb880 100644
--- a/include/uapi/linux/netfilter/xt_CT.h
+++ b/include/uapi/linux/netfilter/xt_CT.h
@@ -6,6 +6,8 @@
 enum {
 	XT_CT_NOTRACK		= 1 << 0,
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
+	XT_CT_DEAD		= 1 << 2, /* Only used internally */
+
 	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS,
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..600ce97 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -554,6 +554,8 @@ void nf_conntrack_tmpl_insert(struct net *net, struct nf_conn *tmpl)
 	tmpl->cpu = smp_processor_id();
 	pcpu = per_cpu_ptr(nf_ct_net(tmpl)->ct.pcpu_lists, tmpl->cpu);
 
+	atomic_inc(&net->ct.tmpl_count);
+
 	spin_lock(&pcpu->lock);
 	/* Overload tuple linked list to put us in template list. */
 	hlist_nulls_add_head_rcu(&tmpl->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
@@ -870,6 +872,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
 void nf_conntrack_free(struct nf_conn *ct)
 {
+	bool tmpl = nf_ct_is_template(ct);
 	struct net *net = nf_ct_net(ct);
 
 	/* A freed object has refcnt == 0, that's
@@ -880,8 +883,11 @@ void nf_conntrack_free(struct nf_conn *ct)
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
+
 	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
+	if (unlikely(tmpl))
+		atomic_dec(&net->ct.tmpl_count);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
 
@@ -1409,6 +1415,36 @@ void nf_ct_iterate_cleanup(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
+static struct nf_conn *get_next_tmpl(struct ct_pcpu *pcpu)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	struct nf_conn *ct = NULL;
+
+	spin_lock_bh(&pcpu->lock);
+	hlist_nulls_for_each_entry(h, n, &pcpu->tmpl, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		WARN_ON(atomic_read(&ct->ct_general.use) != 1);
+		break;
+	}
+	spin_unlock_bh(&pcpu->lock);
+
+	return ct;
+}
+
+static void nf_ct_tmpls_cleanup(struct net *net)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+		struct nf_conn *ct;
+
+		while ((ct = get_next_tmpl(pcpu)) != NULL)
+			ct->proto.tmpl.dest_cb(ct, ct->proto.tmpl.arg);
+	}
+}
+
 static int kill_all(struct nf_conn *i, void *data)
 {
 	return 1;
@@ -1488,7 +1524,8 @@ i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_ct_iterate_cleanup(net, kill_all, NULL, 0, 0);
-		if (atomic_read(&net->ct.count) != 0)
+		if (atomic_read(&net->ct.count) -
+		    atomic_read(&net->ct.tmpl_count) != 0)
 			busy = 1;
 	}
 	if (busy) {
@@ -1497,6 +1534,7 @@ i_see_dead_people:
 	}
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
+		nf_ct_tmpls_cleanup(net);
 		nf_ct_free_hashtable(net->ct.hash, net->ct.htable_size);
 		nf_conntrack_proto_pernet_fini(net);
 		nf_conntrack_helper_pernet_fini(net);
@@ -1739,6 +1777,7 @@ int nf_conntrack_init_net(struct net *net)
 	int cpu;
 
 	atomic_set(&net->ct.count, 0);
+	atomic_set(&net->ct.tmpl_count, 0);
 	seqcount_init(&net->ct.generation);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 789feea..a6676e1 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -346,6 +346,14 @@ static void __net_exit synproxy_proc_exit(struct net *net)
 }
 #endif /* CONFIG_PROC_FS */
 
+static void synproxy_destroy_cb(struct nf_conn *ct, void *arg)
+{
+	struct synproxy_net *snet = arg;
+
+	nf_ct_put(ct);
+	snet->tmpl = NULL;
+}
+
 static int __net_init synproxy_net_init(struct net *net)
 {
 	struct synproxy_net *snet = synproxy_pernet(net);
@@ -365,6 +373,9 @@ static int __net_init synproxy_net_init(struct net *net)
 	if (!nfct_synproxy_ext_add(ct))
 		goto err2;
 
+	ct->proto.tmpl.dest_cb = synproxy_destroy_cb;
+	ct->proto.tmpl.arg = snet;
+
 	nf_conntrack_tmpl_insert(net, ct);
 	snet->tmpl = ct;
 
@@ -390,7 +401,8 @@ static void __net_exit synproxy_net_exit(struct net *net)
 {
 	struct synproxy_net *snet = synproxy_pernet(net);
 
-	nf_ct_put(snet->tmpl);
+	if (snet->tmpl)
+		nf_ct_put(snet->tmpl);
 	synproxy_proc_exit(net);
 	free_percpu(snet->stats);
 }
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 75747ae..713252c 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -54,6 +54,82 @@ static unsigned int xt_ct_target_v1(struct sk_buff *skb,
 	return xt_ct_target(skb, ct);
 }
 
+static void xt_ct_destroy_timeout(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	struct nf_conn_timeout *timeout_ext;
+	typeof(nf_ct_timeout_put_hook) timeout_put;
+
+	rcu_read_lock();
+	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
+
+	if (timeout_put) {
+		timeout_ext = nf_ct_timeout_find(ct);
+		if (timeout_ext)
+			timeout_put(timeout_ext->timeout);
+	}
+	rcu_read_unlock();
+#endif
+}
+
+static int __xt_ct_tg_destroy(struct nf_conn *ct, bool ct_dead)
+{
+	if (ct && !ct_dead && !nf_ct_is_untracked(ct)) {
+		struct nf_conn_help *help = nfct_help(ct);
+
+		if (help)
+			module_put(help->helper->me);
+
+		xt_ct_destroy_timeout(ct);
+		nf_ct_put(ct);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
+			     struct xt_ct_target_info_v1 *info)
+{
+	bool ct_dead = info->flags & XT_CT_DEAD;
+	struct nf_conn *ct = info->ct;
+
+	if (ct && (ct_dead || !nf_ct_is_untracked(ct))) {
+		__xt_ct_tg_destroy(ct, ct_dead);
+
+		nf_ct_l3proto_module_put(par->family);
+	}
+}
+
+static void xt_ct_tg_destroy_v0(const struct xt_tgdtor_param *par)
+{
+	struct xt_ct_target_info *info = par->targinfo;
+	struct xt_ct_target_info_v1 info_v1 = {
+		.flags 		= info->flags,
+		.zone		= info->zone,
+		.ct_events	= info->ct_events,
+		.exp_events	= info->exp_events,
+		.ct		= info->ct,
+	};
+	memcpy(info_v1.helper, info->helper, sizeof(info->helper));
+
+	xt_ct_tg_destroy(par, &info_v1);
+}
+
+static void xt_ct_tg_destroy_v1(const struct xt_tgdtor_param *par)
+{
+	xt_ct_tg_destroy(par, par->targinfo);
+}
+
+static void xt_ct_tg_destroy_cb(struct nf_conn *ct, void *arg)
+{
+	struct xt_ct_target_info *info = arg;
+
+	/* Common offset for flags is the same. */
+	if (__xt_ct_tg_destroy(ct, false))
+		info->flags |= XT_CT_DEAD;
+}
+
 static u8 xt_ct_find_proto(const struct xt_tgchk_param *par)
 {
 	if (par->family == NFPROTO_IPV4) {
@@ -193,6 +269,11 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto out;
 	}
 
+	if (info->flags & XT_CT_DEAD) {
+		ret = -EINVAL;
+		goto err1;
+	}
+
 #ifndef CONFIG_NF_CONNTRACK_ZONES
 	if (info->zone)
 		goto err1;
@@ -228,6 +309,9 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err3;
 	}
 
+	ct->proto.tmpl.dest_cb = xt_ct_tg_destroy_cb;
+	ct->proto.tmpl.arg = par->targinfo;
+
 	nf_conntrack_tmpl_insert(par->net, ct);
 out:
 	info->ct = ct;
@@ -286,62 +370,6 @@ static int xt_ct_tg_check_v2(const struct xt_tgchk_param *par)
 	return xt_ct_tg_check(par, par->targinfo);
 }
 
-static void xt_ct_destroy_timeout(struct nf_conn *ct)
-{
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-	struct nf_conn_timeout *timeout_ext;
-	typeof(nf_ct_timeout_put_hook) timeout_put;
-
-	rcu_read_lock();
-	timeout_put = rcu_dereference(nf_ct_timeout_put_hook);
-
-	if (timeout_put) {
-		timeout_ext = nf_ct_timeout_find(ct);
-		if (timeout_ext)
-			timeout_put(timeout_ext->timeout);
-	}
-	rcu_read_unlock();
-#endif
-}
-
-static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
-			     struct xt_ct_target_info_v1 *info)
-{
-	struct nf_conn *ct = info->ct;
-	struct nf_conn_help *help;
-
-	if (ct && !nf_ct_is_untracked(ct)) {
-		help = nfct_help(ct);
-		if (help)
-			module_put(help->helper->me);
-
-		nf_ct_l3proto_module_put(par->family);
-
-		xt_ct_destroy_timeout(ct);
-		nf_ct_put(info->ct);
-	}
-}
-
-static void xt_ct_tg_destroy_v0(const struct xt_tgdtor_param *par)
-{
-	struct xt_ct_target_info *info = par->targinfo;
-	struct xt_ct_target_info_v1 info_v1 = {
-		.flags 		= info->flags,
-		.zone		= info->zone,
-		.ct_events	= info->ct_events,
-		.exp_events	= info->exp_events,
-		.ct		= info->ct,
-	};
-	memcpy(info_v1.helper, info->helper, sizeof(info->helper));
-
-	xt_ct_tg_destroy(par, &info_v1);
-}
-
-static void xt_ct_tg_destroy_v1(const struct xt_tgdtor_param *par)
-{
-	xt_ct_tg_destroy(par, par->targinfo);
-}
-
 static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 	{
 		.name		= "CT",
-- 
1.9.3

