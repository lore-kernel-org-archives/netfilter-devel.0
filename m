From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next V2] netfilter: cttimeout: use nf_ct_iterate_cleanup_net to unlink timeout objs
Date: Sun, 28 May 2017 22:37:19 +0800
Message-ID: <1495982239-17054-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:48243 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbdE1Oh4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2017 10:37:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Similar to nf_conntrack_helper, we can use nf_ct_iterare_cleanup_net to
remove these copy & paste codes.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: rebase on Florian's patch set "netfilter: conntrack: rework nf_ct_iterate,
     part 1."

 net/netfilter/nfnetlink_cttimeout.c | 39 +++++--------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a3e7bb5..49638b0 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -287,49 +287,20 @@ static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
 	return ret;
 }
 
-static void untimeout(struct nf_conntrack_tuple_hash *i,
-		      struct ctnl_timeout *timeout)
+static int untimeout(struct nf_conn *ct, void *timeout)
 {
-	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
 	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
 
 	if (timeout_ext && (!timeout || timeout_ext->timeout == timeout))
 		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+
+	/* We are not intended to delete this conntrack. */
+	return 0;
 }
 
 static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
 {
-	struct nf_conntrack_tuple_hash *h;
-	const struct hlist_nulls_node *nn;
-	unsigned int last_hsize;
-	spinlock_t *lock;
-	int i, cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_bh(&pcpu->lock);
-		hlist_nulls_for_each_entry(h, nn, &pcpu->unconfirmed, hnnode)
-			untimeout(h, timeout);
-		spin_unlock_bh(&pcpu->lock);
-	}
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
-
-		hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
-			untimeout(h, timeout);
-		spin_unlock(lock);
-	}
-	local_bh_enable();
+	nf_ct_iterate_cleanup_net(net, untimeout, timeout, 0, 0);
 }
 
 /* try to delete object, fail if it is still in use. */
-- 
2.5.5


