From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: nf_conncount: fix garbage collection confirm race
Date: Wed, 27 Jun 2018 17:22:23 +0200
Message-ID: <20180627152223.3633-7-pablo@netfilter.org>
References: <20180627152223.3633-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627152223.3633-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Yi-Hung Wei and Justin Pettit found a race in the garbage collection scheme
used by nf_conncount.

When doing list walk, we lookup the tuple in the conntrack table.
If the lookup fails we remove this tuple from our list because
the conntrack entry is gone.

This is the common cause, but turns out its not the only one.
The list entry could have been created just before by another cpu, i.e. the
conntrack entry might not yet have been inserted into the global hash.

The avoid this, we introduce a timestamp and the owning cpu.
If the entry appears to be stale, evict only if:
 1. The current cpu is the one that added the entry, or,
 2. The timestamp is older than two jiffies

The second constraint allows GC to be taken over by other
cpu too (e.g. because a cpu was offlined or napi got moved to another
cpu).

We can't pretend the 'doubtful' entry wasn't in our list.
Instead, when we don't find an entry indicate via IS_ERR
that entry was removed ('did not exist' or withheld
('might-be-unconfirmed').

This most likely also fixes a xt_connlimit imbalance earlier reported by
Dmitry Andrianov.

Cc: Dmitry Andrianov <dmitry.andrianov@alertme.com>
Reported-by: Justin Pettit <jpettit@vmware.com>
Reported-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Yi-Hung Wei <yihung.wei@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 52 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index d8383609fe28..510039862aa9 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -47,6 +47,8 @@ struct nf_conncount_tuple {
 	struct hlist_node		node;
 	struct nf_conntrack_tuple	tuple;
 	struct nf_conntrack_zone	zone;
+	int				cpu;
+	u32				jiffies32;
 };
 
 struct nf_conncount_rb {
@@ -91,11 +93,42 @@ bool nf_conncount_add(struct hlist_head *head,
 		return false;
 	conn->tuple = *tuple;
 	conn->zone = *zone;
+	conn->cpu = raw_smp_processor_id();
+	conn->jiffies32 = (u32)jiffies;
 	hlist_add_head(&conn->node, head);
 	return true;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_add);
 
+static const struct nf_conntrack_tuple_hash *
+find_or_evict(struct net *net, struct nf_conncount_tuple *conn)
+{
+	const struct nf_conntrack_tuple_hash *found;
+	unsigned long a, b;
+	int cpu = raw_smp_processor_id();
+	__s32 age;
+
+	found = nf_conntrack_find_get(net, &conn->zone, &conn->tuple);
+	if (found)
+		return found;
+	b = conn->jiffies32;
+	a = (u32)jiffies;
+
+	/* conn might have been added just before by another cpu and
+	 * might still be unconfirmed.  In this case, nf_conntrack_find()
+	 * returns no result.  Thus only evict if this cpu added the
+	 * stale entry or if the entry is older than two jiffies.
+	 */
+	age = a - b;
+	if (conn->cpu == cpu || age >= 2) {
+		hlist_del(&conn->node);
+		kmem_cache_free(conncount_conn_cachep, conn);
+		return ERR_PTR(-ENOENT);
+	}
+
+	return ERR_PTR(-EAGAIN);
+}
+
 unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 				 const struct nf_conntrack_tuple *tuple,
 				 const struct nf_conntrack_zone *zone,
@@ -103,18 +136,27 @@ unsigned int nf_conncount_lookup(struct net *net, struct hlist_head *head,
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct nf_conncount_tuple *conn;
-	struct hlist_node *n;
 	struct nf_conn *found_ct;
+	struct hlist_node *n;
 	unsigned int length = 0;
 
 	*addit = tuple ? true : false;
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
-		found = nf_conntrack_find_get(net, &conn->zone, &conn->tuple);
-		if (found == NULL) {
-			hlist_del(&conn->node);
-			kmem_cache_free(conncount_conn_cachep, conn);
+		found = find_or_evict(net, conn);
+		if (IS_ERR(found)) {
+			/* Not found, but might be about to be confirmed */
+			if (PTR_ERR(found) == -EAGAIN) {
+				length++;
+				if (!tuple)
+					continue;
+
+				if (nf_ct_tuple_equal(&conn->tuple, tuple) &&
+				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
+				    nf_ct_zone_id(zone, zone->dir))
+					*addit = false;
+			}
 			continue;
 		}
 
-- 
2.11.0
