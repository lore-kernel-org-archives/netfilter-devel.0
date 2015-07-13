From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf RFC] netfilter: fix netns dependencies with conntrack templates
Date: Mon, 13 Jul 2015 15:11:48 +0200
Message-ID: <1436793108-3807-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, daniel@iogearbox.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53090 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbbGMNGR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 09:06:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quoting Daniel Borkmann:

"When adding connection tracking template rules to a netns, f.e. to
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
be invoked earlier in the cleanup chain."

Here, I cannot reproduce the problem described above since I can see this
sequence in the netns exit path:

 ip_tables_net_exit()
 xt_net_exit()
 nf_conntrack_cleanup_net_list()

I guess this has to be related to the order in which modules are loaded or
having compiled nf_conntrack built-in while x_tables being a module. So we have
no guarantees regarding the order netns callbacks are executed.

Fix this by allocating the templates through kmalloc() from the respective
SYNPROXY and CT targets, so they don't depend on the conntrack kmem cache.
Then, release then via kfree() from nf_conntrack_free(). This branch is marked
as unlikely since conntrack templates are rarely allocated and only from the
configuration plane path. This patch also makes sure from the netns exit path
of x_tables infrastructure that there are no conntrack templates still
referenced.

Based on original work from Daniel Borkmann.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Daniel,

I basically took your initial v1 patch and I have reworked this to use kmalloc
instead.

Let me know if you have any concern with this approach, thanks.

 include/net/netfilter/nf_conntrack.h |    2 +
 include/net/netns/conntrack.h        |    1 +
 net/netfilter/nf_conntrack_core.c    |   81 +++++++++++++++++++++++++++++++++-
 net/netfilter/nf_synproxy_core.c     |    4 +-
 net/netfilter/x_tables.c             |   11 +++++
 net/netfilter/xt_CT.c                |    4 +-
 6 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 095433b..3f16859 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -291,7 +291,9 @@ extern unsigned int nf_conntrack_max;
 extern unsigned int nf_conntrack_hash_rnd;
 void init_nf_conntrack_hash_rnd(void);
 
+struct nf_conn *nf_ct_tmpl_alloc(struct net *net, u16 zone, gfp_t flags);
 void nf_conntrack_tmpl_insert(struct net *net, struct nf_conn *tmpl);
+void nf_ct_tmpl_cleanup(struct net *net);
 
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 29d6a94..30b500c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -73,6 +73,7 @@ struct ct_pcpu {
 
 struct netns_ct {
 	atomic_t		count;
+	atomic_t		tmpl_count;
 	unsigned int		expect_count;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct delayed_work ecache_dwork;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..a639ddf 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -540,13 +540,50 @@ out:
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
+/* Released via nf_conntrack_free(). */
+struct nf_conn *nf_ct_tmpl_alloc(struct net *net, u16 zone, gfp_t flags)
+{
+	struct nf_conn *tmpl;
+
+	tmpl = kzalloc(sizeof(struct nf_conn), GFP_KERNEL);
+	if (tmpl == NULL)
+		return NULL;
+
+	tmpl->status = IPS_TEMPLATE | IPS_CONFIRMED;
+	write_pnet(&tmpl->ct_net, net);
+
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	if (zone) {
+		struct nf_conntrack_zone *nf_ct_zone;
+
+		nf_ct_zone = nf_ct_ext_add(tmpl, NF_CT_EXT_ZONE, GFP_ATOMIC);
+		if (!nf_ct_zone)
+			goto out_free;
+		nf_ct_zone->id = zone;
+	}
+#endif
+	atomic_set(&tmpl->ct_general.use, 0);
+	atomic_inc(&net->ct.tmpl_count);
+
+	return tmpl;
+out_free:
+	kfree(tmpl);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
+
+static void nf_ct_tmpl_free(struct net *net, struct nf_conn *ct)
+{
+	kfree(ct);
+	smp_mb__before_atomic();
+	atomic_dec(&net->ct.tmpl_count);
+}
+
 /* deletion from this larval template list happens via nf_ct_put() */
 void nf_conntrack_tmpl_insert(struct net *net, struct nf_conn *tmpl)
 {
 	struct ct_pcpu *pcpu;
 
-	__set_bit(IPS_TEMPLATE_BIT, &tmpl->status);
-	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
 	nf_conntrack_get(&tmpl->ct_general);
 
 	/* add this conntrack to the (per cpu) tmpl list */
@@ -879,6 +916,10 @@ void nf_conntrack_free(struct nf_conn *ct)
 
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
+	if (unlikely(ct->status & IPS_TEMPLATE)) {
+		nf_ct_tmpl_free(net, ct);
+		return;
+	}
 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
 	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
@@ -1414,6 +1455,41 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
+static struct nf_conn *get_next_tmpl(struct net *net)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	struct nf_conn *ct = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+
+		spin_lock_bh(&pcpu->lock);
+		hlist_nulls_for_each_entry(h, n, &pcpu->tmpl, hnnode) {
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			break;
+		}
+		spin_unlock_bh(&pcpu->lock);
+	}
+	return ct;
+}
+
+void nf_ct_tmpl_cleanup(struct net *net)
+{
+	struct nf_conn *tmpl;
+
+i_see_dead_people:
+	while ((tmpl = get_next_tmpl(net)) != NULL)
+		nf_ct_put(tmpl);
+
+	if (atomic_read(&net->ct.tmpl_count) != 0) {
+		schedule();
+		goto i_see_dead_people;
+	}
+}
+EXPORT_SYMBOL_GPL(nf_ct_tmpl_cleanup);
+
 void nf_ct_free_hashtable(void *hash, unsigned int size)
 {
 	if (is_vmalloc_addr(hash))
@@ -1739,6 +1815,7 @@ int nf_conntrack_init_net(struct net *net)
 	int cpu;
 
 	atomic_set(&net->ct.count, 0);
+	atomic_set(&net->ct.tmpl_count, 0);
 	seqcount_init(&net->ct.generation);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 789feea..f0cb426 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -349,12 +349,10 @@ static void __net_exit synproxy_proc_exit(struct net *net)
 static int __net_init synproxy_net_init(struct net *net)
 {
 	struct synproxy_net *snet = synproxy_pernet(net);
-	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
 	int err = -ENOMEM;
 
-	memset(&t, 0, sizeof(t));
-	ct = nf_conntrack_alloc(net, 0, &t, &t, GFP_KERNEL);
+	ct = nf_ct_tmpl_alloc(net, 0, GFP_KERNEL);
 	if (IS_ERR(ct)) {
 		err = PTR_ERR(ct);
 		goto err1;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d324fe7..df13a39 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -27,6 +27,9 @@
 #include <linux/slab.h>
 #include <linux/audit.h>
 #include <net/net_namespace.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+#endif
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp.h>
@@ -1296,8 +1299,16 @@ static int __net_init xt_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	nf_ct_tmpl_cleanup(net);
+#endif
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 75747ae..aa355e3 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -184,7 +184,6 @@ out:
 static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
-	struct nf_conntrack_tuple t;
 	struct nf_conn *ct;
 	int ret = -EOPNOTSUPP;
 
@@ -202,8 +201,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	if (ret < 0)
 		goto err1;
 
-	memset(&t, 0, sizeof(t));
-	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
+	ct = nf_ct_tmpl_alloc(par->net, info->zone, GFP_KERNEL);
 	ret = PTR_ERR(ct);
 	if (IS_ERR(ct))
 		goto err2;
-- 
1.7.10.4

