From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/20]: nf_conntrack: early_drop improvement
Date: Fri, 29 Jun 2007 02:45:20 +0200 (MEST)
Message-ID: <20070629004418.25566.8938.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: early_drop improvement

When the maximum number of conntrack entries is reached and a new
one needs to be allocated, conntrack tries to drop an unassured
connection from the same hash bucket the new conntrack would hash
to. Since with a properly sized hash the average number of entries
per bucket is 1, the chances of actually finding one are not very
good. This patch makes it walk the hash until a minimum number of
8 entries are checked.

Based on patch by Vasily Averin <vvs@sw.ru>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7a171312164be3cc200fbc04c8c93c32dc4f0649
tree 4efac6249264b9e45e47020aafd9564ac207683b
parent 5c63a5d17f6f9e49fcdfa80e1b86c281fa496e34
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:57 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:57 +0200

 net/netfilter/nf_conntrack_core.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d1fc019..e76fd28 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -377,21 +377,30 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
+#define NF_CT_EVICTION_RANGE	8
+
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(struct hlist_head *chain)
+static int early_drop(unsigned int hash)
 {
 	/* Use oldest entry, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct = NULL, *tmp;
 	struct hlist_node *n;
-	int dropped = 0;
+	unsigned int i;
+	int dropped = 0, cnt = 0;
 
 	read_lock_bh(&nf_conntrack_lock);
-	hlist_for_each_entry(h, n, chain, hnode) {
-		tmp = nf_ct_tuplehash_to_ctrack(h);
-		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
-			ct = tmp;
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
+			tmp = nf_ct_tuplehash_to_ctrack(h);
+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+				ct = tmp;
+			cnt++;
+		}
+		if (ct || cnt >= NF_CT_EVICTION_RANGE)
+			break;
+		hash = (hash + 1) % nf_conntrack_htable_size;
 	}
 	if (ct)
 		atomic_inc(&ct->ct_general.use);
@@ -425,8 +434,7 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	if (nf_conntrack_max
 	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
 		unsigned int hash = hash_conntrack(orig);
-		/* Try dropping from this hash chain. */
-		if (!early_drop(&nf_conntrack_hash[hash])) {
+		if (!early_drop(hash)) {
 			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
