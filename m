From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/5] netfilter: conntrack: don't call iter for non-confirmed conntracks
Date: Sun, 21 May 2017 12:52:56 +0200
Message-ID: <20170521105259.10239-3-fw@strlen.de>
References: <20170521105259.10239-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37102 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752440AbdEUKwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:52:53 -0400
In-Reply-To: <20170521105259.10239-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_ct_iterate_cleanup_net currently calls iter() callback also for
conntracks on the unconfirmed list, but this is unsafe.

Acesses to nf_conn are fine, but some users access the extension area
in the iter() callback, but that does only work reliably for confirmed
conntracks (ct->ext can be reallocated at any time for unconfirmed
conntrack).

The seond issue is that there is a short window where a conntrack entry
is neither on the list nor in the table: To confirm an entry, it is first
removed from the unconfirmed list, then insert into the table.

Fix this by iterating the unconfirmed list first and marking all entries
as dying, then wait for rcu grace period.

This makes sure all entries that were about to be confirmed either are
in the main table, or will be dropped soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2730f9df33b7..08733685d732 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1592,7 +1592,6 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 	struct hlist_nulls_node *n;
-	int cpu;
 	spinlock_t *lockp;
 
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
@@ -1614,24 +1613,40 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 		cond_resched();
 	}
 
+	return NULL;
+found:
+	atomic_inc(&ct->ct_general.use);
+	spin_unlock(lockp);
+	local_bh_enable();
+	return ct;
+}
+
+static void
+__nf_ct_unconfirmed_destroy(struct net *net)
+{
+	int cpu;
+
 	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
+		struct nf_conntrack_tuple_hash *h;
+		struct hlist_nulls_node *n;
+		struct ct_pcpu *pcpu;
+
+		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 
 		spin_lock_bh(&pcpu->lock);
 		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
+			struct nf_conn *ct;
+
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (iter(ct, data))
-				set_bit(IPS_DYING_BIT, &ct->status);
+
+			/* we cannot call iter() on unconfirmed list, the
+			 * owning cpu can reallocate ct->ext at any time.
+			 */
+			set_bit(IPS_DYING_BIT, &ct->status);
 		}
 		spin_unlock_bh(&pcpu->lock);
 		cond_resched();
 	}
-	return NULL;
-found:
-	atomic_inc(&ct->ct_general.use);
-	spin_unlock(lockp);
-	local_bh_enable();
-	return ct;
 }
 
 void nf_ct_iterate_cleanup_net(struct net *net,
@@ -1646,6 +1661,10 @@ void nf_ct_iterate_cleanup_net(struct net *net,
 	if (atomic_read(&net->ct.count) == 0)
 		return;
 
+	__nf_ct_unconfirmed_destroy(net);
+
+	synchronize_net();
+
 	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 
-- 
2.13.0

