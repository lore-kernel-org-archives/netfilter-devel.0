From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next V2] netfilter: nf_ct_helper: use nf_ct_iterate_destroy to unlink helper objs
Date: Sun, 28 May 2017 22:35:52 +0800
Message-ID: <1495982152-16918-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:54597 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbdE1Ogp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2017 10:36:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When we unlink the helper objects, we will iterate the nf_conntrack_hash,
iterate the unconfirmed list, handle the hash resize situation, etc.

Actually this logic is same as the nf_ct_iterate_destroy, so we can use
it to remove these copy & paste codes.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: rebase on Florian's patch set "netfilter: conntrack: rework nf_ct_iterate,
     part 1."

 net/netfilter/nf_conntrack_helper.c | 50 +++----------------------------------
 1 file changed, 4 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3a60efa..e9c1962 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -274,16 +274,16 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
 /* appropriate ct lock protecting must be taken by caller */
-static inline int unhelp(struct nf_conntrack_tuple_hash *i,
-			 const struct nf_conntrack_helper *me)
+static int unhelp(struct nf_conn *ct, void *me)
 {
-	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
 	struct nf_conn_help *help = nfct_help(ct);
 
 	if (help && rcu_dereference_raw(help->helper) == me) {
 		nf_conntrack_event(IPCT_HELPER, ct);
 		RCU_INIT_POINTER(help->helper, NULL);
 	}
+
+	/* We are not intended to delete this conntrack. */
 	return 0;
 }
 
@@ -425,33 +425,10 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
-static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
-					     struct net *net)
-{
-	struct nf_conntrack_tuple_hash *h;
-	const struct hlist_nulls_node *nn;
-	int cpu;
-
-	/* Get rid of expecteds, set helpers to NULL. */
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_bh(&pcpu->lock);
-		hlist_nulls_for_each_entry(h, nn, &pcpu->unconfirmed, hnnode)
-			unhelp(h, me);
-		spin_unlock_bh(&pcpu->lock);
-	}
-}
-
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
-	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
-	const struct hlist_nulls_node *nn;
-	unsigned int last_hsize;
-	spinlock_t *lock;
-	struct net *net;
 	unsigned int i;
 
 	mutex_lock(&nf_ct_helper_mutex);
@@ -479,26 +456,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 
-	rtnl_lock();
-	for_each_net(net)
-		__nf_conntrack_helper_unregister(me, net);
-	rtnl_unlock();
-
-	local_bh_disable();
-restart:
-	last_hsize = nf_conntrack_htable_size;
-	for (i = 0; i < last_hsize; i++) {
-		lock = &nf_conntrack_locks[i % CONNTRACK_LOCKS];
-		nf_conntrack_lock(lock);
-		if (last_hsize != nf_conntrack_htable_size) {
-			spin_unlock(lock);
-			goto restart;
-		}
-		hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
-			unhelp(h, me);
-		spin_unlock(lock);
-	}
-	local_bh_enable();
+	nf_ct_iterate_destroy(unhelp, me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
-- 
2.5.5


