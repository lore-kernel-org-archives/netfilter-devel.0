From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: helper: avoid extra expectation iterations on unregister
Date: Sun, 15 May 2016 19:50:14 +0200
Message-ID: <1463334614-10189-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44425 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbcEORt5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 May 2016 13:49:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The expectation table is not duplicated per net namespace anymore, so we can move
the expectation table and conntrack table iteration out of the per-net loop.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_helper.c | 61 +++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f703adb..7ba16e9 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -390,11 +390,38 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 					     struct net *net)
 {
 	struct nf_conntrack_tuple_hash *h;
+	const struct hlist_nulls_node *nn;
+	int cpu;
+
+	/* Get rid of expecteds, set helpers to NULL. */
+	for_each_possible_cpu(cpu) {
+		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+
+		spin_lock_bh(&pcpu->lock);
+		hlist_nulls_for_each_entry(h, nn, &pcpu->unconfirmed, hnnode)
+			unhelp(h, me);
+		spin_unlock_bh(&pcpu->lock);
+	}
+}
+
+void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+{
+	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
+	struct net *net;
 	unsigned int i;
-	int cpu;
+
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
+	nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	/* Make sure every nothing is still using the helper unless its a
+	 * connection in the hash.
+	 */
+	synchronize_rcu();
 
 	/* Get rid of expectations */
 	spin_lock_bh(&nf_conntrack_expect_lock);
@@ -414,15 +441,11 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 
-	/* Get rid of expecteds, set helpers to NULL. */
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+	rtnl_lock();
+	for_each_net(net)
+		__nf_conntrack_helper_unregister(me, net);
+	rtnl_unlock();
 
-		spin_lock_bh(&pcpu->lock);
-		hlist_nulls_for_each_entry(h, nn, &pcpu->unconfirmed, hnnode)
-			unhelp(h, me);
-		spin_unlock_bh(&pcpu->lock);
-	}
 	local_bh_disable();
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
 		nf_conntrack_lock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
@@ -434,26 +457,6 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 	}
 	local_bh_enable();
 }
-
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
-{
-	struct net *net;
-
-	mutex_lock(&nf_ct_helper_mutex);
-	hlist_del_rcu(&me->hnode);
-	nf_ct_helper_count--;
-	mutex_unlock(&nf_ct_helper_mutex);
-
-	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
-	 */
-	synchronize_rcu();
-
-	rtnl_lock();
-	for_each_net(net)
-		__nf_conntrack_helper_unregister(me, net);
-	rtnl_unlock();
-}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 static struct nf_ct_ext_type helper_extend __read_mostly = {
-- 
2.7.3

