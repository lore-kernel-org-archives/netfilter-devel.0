From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/20]: nf_nat: use hlists for bysource hash
Date: Fri, 29 Jun 2007 02:45:02 +0200 (MEST)
Message-ID: <20070629004400.25566.97963.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: use hlists for bysource hash

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7599a8b2b7da30aadebe9ca6233cb54be3d927c8
tree 25a16e0d34f8db93721035ca9a48425039ad9185
parent d5335110471f0a0b025c92ac283a740a25705c67
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:04:25 +0200

 include/net/netfilter/nf_nat.h   |    2 +-
 net/ipv4/netfilter/nf_nat_core.c |   21 +++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index d0e5e43..6ae52f7 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -66,7 +66,7 @@ struct nf_conn;
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat
 {
-	struct list_head bysource;
+	struct hlist_node bysource;
 	struct nf_nat_seq seq[IP_CT_DIR_MAX];
 	struct nf_conn *ct;
 	union nf_conntrack_nat_help help;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 04691ed..f242ac6 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/skbuff.h>
-#include <linux/vmalloc.h>
 #include <net/checksum.h>
 #include <net/icmp.h>
 #include <net/ip.h>
@@ -44,8 +43,9 @@ static struct nf_conntrack_l3proto *l3proto = NULL;
 
 /* Calculated at init based on memory size */
 static unsigned int nf_nat_htable_size;
+static int nf_nat_vmalloced;
 
-static struct list_head *bysource;
+static struct hlist_head *bysource;
 
 #define MAX_IP_NAT_PROTO 256
 static struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
@@ -153,9 +153,10 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 	unsigned int h = hash_by_src(tuple);
 	struct nf_conn_nat *nat;
 	struct nf_conn *ct;
+	struct hlist_node *n;
 
 	read_lock_bh(&nf_nat_lock);
-	list_for_each_entry(nat, &bysource[h], bysource) {
+	hlist_for_each_entry(nat, n, &bysource[h], bysource) {
 		ct = nat->ct;
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
@@ -336,7 +337,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
 		nat = nfct_nat(ct);
 		nat->ct = ct;
-		list_add(&nat->bysource, &bysource[srchash]);
+		hlist_add_head(&nat->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
 	}
 
@@ -600,7 +601,7 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 	NF_CT_ASSERT(nat->ct->status & IPS_NAT_DONE_MASK);
 
 	write_lock_bh(&nf_nat_lock);
-	list_del(&nat->bysource);
+	hlist_del(&nat->bysource);
 	nat->ct = NULL;
 	write_unlock_bh(&nf_nat_lock);
 }
@@ -618,7 +619,7 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	write_lock_bh(&nf_nat_lock);
-	list_replace(&old_nat->bysource, &new_nat->bysource);
+	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;
 	write_unlock_bh(&nf_nat_lock);
 }
@@ -646,8 +647,8 @@ static int __init nf_nat_init(void)
 	/* Leave them the same for the moment. */
 	nf_nat_htable_size = nf_conntrack_htable_size;
 
-	/* One vmalloc for both hash tables */
-	bysource = vmalloc(sizeof(struct list_head) * nf_nat_htable_size);
+	bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size,
+					 &nf_nat_vmalloced);
 	if (!bysource) {
 		ret = -ENOMEM;
 		goto cleanup_extend;
@@ -663,7 +664,7 @@ static int __init nf_nat_init(void)
 	write_unlock_bh(&nf_nat_lock);
 
 	for (i = 0; i < nf_nat_htable_size; i++) {
-		INIT_LIST_HEAD(&bysource[i]);
+		INIT_HLIST_HEAD(&bysource[i]);
 	}
 
 	/* Initialize fake conntrack so that NAT will skip it */
@@ -693,7 +694,7 @@ static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
 	synchronize_rcu();
-	vfree(bysource);
+	nf_ct_free_hashtable(bysource, nf_nat_vmalloced, nf_nat_htable_size);
 	nf_ct_l3proto_put(l3proto);
 	nf_ct_extend_unregister(&nat_extend);
 }
