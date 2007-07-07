From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/50]: nf_nat: kill global 'destroy' operation
Date: Sat,  7 Jul 2007 14:23:31 +0200 (MEST)
Message-ID: <20070707122246.1589.70349.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: kill global 'destroy' operation

This kills the global 'destroy' operation which was used by NAT.
Instead it uses the extension infrastructure so that multiple
extensions can register own operations.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e4d1f8c1725bee2e4c14a17a7188da46b400ab62
tree 316ee8ce8de2a7bb1e9c1157a3cdc677e546eda3
parent 663fb8a857c9f68b1cf5addf7946023d345070f1
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:35 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:35 +0200

 include/net/netfilter/nf_conntrack.h |    3 --
 net/ipv4/netfilter/nf_nat_core.c     |   46 ++++++++++++++++------------------
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
index 4ce82d7..e370d15 100644
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
@@ -604,6 +590,22 @@ nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
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
@@ -623,11 +625,12 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
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
@@ -664,10 +667,6 @@ static int __init nf_nat_init(void)
 		INIT_LIST_HEAD(&bysource[i]);
 	}
 
-	/* FIXME: Man, this is a hack.  <SIGH> */
-	NF_CT_ASSERT(rcu_dereference(nf_conntrack_destroyed) == NULL);
-	rcu_assign_pointer(nf_conntrack_destroyed, nf_nat_cleanup_conntrack);
-
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 
@@ -694,7 +693,6 @@ static int clean_nat(struct nf_conn *i, void *data)
 static void __exit nf_nat_cleanup(void)
 {
 	nf_ct_iterate_cleanup(&clean_nat, NULL);
-	rcu_assign_pointer(nf_conntrack_destroyed, NULL);
 	synchronize_rcu();
 	vfree(bysource);
 	nf_ct_l3proto_put(l3proto);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a713666..035eb9f 100644
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
