From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 6/7]: nf_nat: Kills global 'destroy' operation
Date: Mon, 07 May 2007 21:01:59 +0900 (JST)
Message-ID: <200705071202.l47C20ai007167@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, kaber@trash.net, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: netfilter-devel@lists.netfilter.org
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
 net/ipv4/netfilter/nf_nat_core.c     |   44 ++++++++++++++++-----------------
 net/netfilter/nf_conntrack_core.c    |    8 ------
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 15408c2..43d1923 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -214,9 +214,6 @@ extern void nf_conntrack_tcp_update(stru
 				    struct nf_conn *conntrack,
 				    int dir);
 
-/* Call me when a conntrack is destroyed. */
-extern void (*nf_conntrack_destroyed)(struct nf_conn *conntrack);
-
 /* Fake conntrack entry for untracked connections */
 extern struct nf_conn nf_conntrack_untracked;
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 278c6d3..c95661a 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -87,20 +87,6 @@ hash_by_src(const struct nf_conntrack_tu
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
@@ -603,6 +589,22 @@ nf_nat_port_nfattr_to_range(struct nfatt
 EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
 #endif
 
+/* Noone using conntrack by the time this called. */
+static void nf_nat_cleanup_conntrack(struct ct_extend *ext)
+{
+	struct nf_conn_nat *nat = ct_extend_find(ext, CTE_NAT);
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
 static void nf_nat_move_storage(struct ct_extend *new, struct ct_extend *old)
 {
 	struct nf_conn_nat *new_nat = ct_extend_find(new, CTE_NAT);
@@ -623,10 +625,11 @@ static void nf_nat_move_storage(struct c
 }
 
 struct ct_extend_type nat_extend = {
-	.len	= sizeof(struct nf_conn_nat),
-	.align	= __alignof__(struct nf_conn_nat),
-	.move	= nf_nat_move_storage,
-	.type	= CTE_NAT,
+	.len		= sizeof(struct nf_conn_nat),
+	.align		= __alignof__(struct nf_conn_nat),
+	.destroy	= nf_nat_cleanup_conntrack,
+	.move		= nf_nat_move_storage,
+	.type		= CTE_NAT,
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
 
@@ -694,7 +693,6 @@ static int clean_nat(struct nf_conn *i,
 static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
-	rcu_assign_pointer(nf_conntrack_destroyed, NULL);
 	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 99fc52f..41d0921 100644
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
 
@@ -158,7 +155,6 @@ destroy_conntrack(struct nf_conntrack *n
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_l4proto *l4proto;
-	typeof(nf_conntrack_destroyed) destroyed;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
@@ -181,10 +177,6 @@ destroy_conntrack(struct nf_conntrack *n
 
 	ct_extend_destroy(ct->ext);
 
-	destroyed = rcu_dereference(nf_conntrack_destroyed);
-	if (destroyed)
-		destroyed(ct);
-
 	rcu_read_unlock();
 
 	write_lock_bh(&nf_conntrack_lock);
-- 
1.4.4
