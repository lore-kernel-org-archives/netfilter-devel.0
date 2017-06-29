From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/29] netfilter: cttimeout: use nf_ct_iterate_cleanup_net to unlink timeout objs
Date: Fri, 30 Jun 2017 00:53:18 +0200
Message-ID: <1498776807-11124-21-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

Similar to nf_conntrack_helper, we can use nf_ct_iterare_cleanup_net to
remove these copy & paste code.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 39 +++++--------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a3e7bb54d96a..49638b03ccc9 100644
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
2.1.4
