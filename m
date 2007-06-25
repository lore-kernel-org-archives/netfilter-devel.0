From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 08/10] nf_nat: Kills global 'destroy' operation
Date: Tue, 26 Jun 2007 02:22:24 +0900 (JST)
Message-ID: <200706251722.l5PHMPRl004655@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


This kills the global 'destroy' operation which was used by NAT.
Instead it uses the extension infrastructure so that multiple
extensions can register own operations.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack.h |    3 --
 net/ipv4/netfilter/nf_nat_core.c     |   46 ++++++++++++++++-----------------
 net/netfilter/nf_conntrack_core.c    |    8 ------
 3 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 71386e5..ef4a403 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -213,9 +213,6 @@ extern void nf_conntrack_tcp_update(struct sk_buff *skb,
 				    struct nf_conn *conntrack,
 				    int dir);
 
-/* Call me when a conntrack is destroyed. */
-extern void (*nf_conntrack_destroyed)(struct nf_conn *conntrack);
-
 /* Fake conntrack entry for untracked connections */
 extern struct nf_conn nf_conntrack_untracked;
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 5a0e90f..fd10584 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -87,20 +87,6 @@ hash_by_src(const struct nf_conntrack_tuple *tuple)
 			    tuple->dst.protonum, 0) % nf_nat_htable_size;
 }
 
-/* Noone using conntrack by the time this called. */
-static void nf_nat_cleanup_conntrack(struct nf_conn *conn)
-{
-	struct nf_conn_nat *nat;
-	if (!(conn->status & IPS_NAT_DONE_MASK))
-		return;
-
-	nat = nfct_nat(conn);
-	write_lock_bh(&nf_nat_lock);
-	list_del(&nat->info.bysource);
-	nat->info.ct = NULL;
-	write_unlock_bh(&nf_nat_lock);
-}
-
 /* Is this tuple already taken? (not by us) */
 int
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
@@ -603,6 +589,22 @@ nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
 EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
 #endif
 
+/* Noone using conntrack by the time this called. */
+static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
+{
+	struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
+
+	if (nat == NULL || nat->info.ct == NULL)
+		return;
+
+	NF_CT_ASSERT(nat->info.ct->status & IPS_NAT_DONE_MASK);
+
+	write_lock_bh(&nf_nat_lock);
+	list_del(&nat->info.bysource);
+	nat->info.ct = NULL;
+	write_unlock_bh(&nf_nat_lock);
+}
+
 static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 {
 	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
@@ -622,11 +624,12 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 }
 
 struct nf_ct_ext_type nat_extend = {
-	.len	= sizeof(struct nf_conn_nat),
-	.align	= __alignof__(struct nf_conn_nat),
-	.move	= nf_nat_move_storage,
-	.id	= NF_CT_EXT_NAT,
-	.flags	= NF_CT_EXT_F_PREALLOC,
+	.len		= sizeof(struct nf_conn_nat),
+	.align		= __alignof__(struct nf_conn_nat),
+	.destroy	= nf_nat_cleanup_conntrack,
+	.move		= nf_nat_move_storage,
+	.id		= NF_CT_EXT_NAT,
+	.flags		= NF_CT_EXT_F_PREALLOC,
 };
 
 static int __init nf_nat_init(void)
@@ -663,10 +666,6 @@ static int __init nf_nat_init(void)
 		INIT_LIST_HEAD(&bysource[i]);
 	}
 
-	/* FIXME: Man, this is a hack.  <SIGH> */
-	NF_CT_ASSERT(rcu_dereference(nf_conntrack_destroyed) == NULL);
-	rcu_assign_pointer(nf_conntrack_destroyed, nf_nat_cleanup_conntrack);
-
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
@@ -693,7 +692,6 @@ static int clean_nat(struct nf_conn *i, void *data)
 static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
-	rcu_assign_pointer(nf_conntrack_destroyed, NULL);
 	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0571c64..7f3b131 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -53,9 +53,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 atomic_t nf_conntrack_count = ATOMIC_INIT(0);
 EXPORT_SYMBOL_GPL(nf_conntrack_count);
 
-void (*nf_conntrack_destroyed)(struct nf_conn *conntrack);
-EXPORT_SYMBOL_GPL(nf_conntrack_destroyed);
-
 unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
@@ -157,7 +154,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 	struct nf_conntrack_l4proto *l4proto;
-	typeof(nf_conntrack_destroyed) destroyed;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
@@ -177,10 +173,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 
 	nf_ct_ext_destroy(ct);
 
-	destroyed = rcu_dereference(nf_conntrack_destroyed);
-	if (destroyed)
-		destroyed(ct);
-
 	rcu_read_unlock();
 
 	write_lock_bh(&nf_conntrack_lock);
-- 
1.5.2.2
