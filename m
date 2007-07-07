From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/50]: nf_nat: merge nf_conn and nf_nat_info
Date: Sat,  7 Jul 2007 14:23:32 +0200 (MEST)
Message-ID: <20070707122248.1589.50822.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: merge nf_conn and nf_nat_info

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f2bd54e891a73950d8b8fd8c625ed7ac5d2c0f8
tree 9f87f34eb249be82ea3031fd8b71e7dfc4255817
parent e4d1f8c1725bee2e4c14a17a7188da46b400ab62
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:36 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:36 +0200

 include/net/netfilter/nf_nat.h     |   17 ++++++-----------
 net/ipv4/netfilter/nf_nat_core.c   |   25 ++++++++++++-------------
 net/ipv4/netfilter/nf_nat_helper.c |   11 +++++------
 3 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0541eed..d0e5e43 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -54,16 +54,6 @@ struct nf_nat_multi_range_compat
 #include <linux/netfilter/nf_conntrack_pptp.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-struct nf_conn;
-
-/* The structure embedded in the conntrack structure. */
-struct nf_nat_info
-{
-	struct list_head bysource;
-	struct nf_nat_seq seq[IP_CT_DIR_MAX];
-	struct nf_conn *ct;
-};
-
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help
 {
@@ -71,9 +61,14 @@ union nf_conntrack_nat_help
 	struct nf_nat_pptp nat_pptp_info;
 };
 
+struct nf_conn;
+
+/* The structure embedded in the conntrack structure. */
 struct nf_conn_nat
 {
-	struct nf_nat_info info;
+	struct list_head bysource;
+	struct nf_nat_seq seq[IP_CT_DIR_MAX];
+	struct nf_conn *ct;
 	union nf_conntrack_nat_help help;
 #if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
     defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE)
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index e370d15..7e31777 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -155,8 +155,8 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 	struct nf_conn *ct;
 
 	read_lock_bh(&nf_nat_lock);
-	list_for_each_entry(nat, &bysource[h], info.bysource) {
-		ct = nat->info.ct;
+	list_for_each_entry(nat, &bysource[h], bysource) {
+		ct = nat->ct;
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
@@ -284,7 +284,6 @@ nf_nat_setup_info(struct nf_conn *ct,
 {
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
 	struct nf_conn_nat *nat;
-	struct nf_nat_info *info;
 	int have_to_hash = !(ct->status & IPS_NAT_DONE_MASK);
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
@@ -335,9 +334,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		write_lock_bh(&nf_nat_lock);
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
-		info = &nfct_nat(ct)->info;
-		info->ct = ct;
-		list_add(&info->bysource, &bysource[srchash]);
+		nat = nfct_nat(ct);
+		nat->ct = ct;
+		list_add(&nat->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
 	}
 
@@ -595,14 +594,14 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
 	struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
 
-	if (nat == NULL || nat->info.ct == NULL)
+	if (nat == NULL || nat->ct == NULL)
 		return;
 
-	NF_CT_ASSERT(nat->info.ct->status & IPS_NAT_DONE_MASK);
+	NF_CT_ASSERT(nat->ct->status & IPS_NAT_DONE_MASK);
 
 	write_lock_bh(&nf_nat_lock);
-	list_del(&nat->info.bysource);
-	nat->info.ct = NULL;
+	list_del(&nat->bysource);
+	nat->ct = NULL;
 	write_unlock_bh(&nf_nat_lock);
 }
 
@@ -610,7 +609,7 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 {
 	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
 	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
-	struct nf_conn *ct = old_nat->info.ct;
+	struct nf_conn *ct = old_nat->ct;
 	unsigned int srchash;
 
 	if (!(ct->status & IPS_NAT_DONE_MASK))
@@ -619,8 +618,8 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 
 	write_lock_bh(&nf_nat_lock);
-	list_replace(&old_nat->info.bysource, &new_nat->info.bysource);
-	new_nat->info.ct = ct;
+	list_replace(&old_nat->bysource, &new_nat->bysource);
+	new_nat->ct = ct;
 	write_unlock_bh(&nf_nat_lock);
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index ef0a99e..f3383fc 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -52,8 +52,8 @@ adjust_tcp_sequence(u32 seq,
 
 	dir = CTINFO2DIR(ctinfo);
 
-	this_way = &nat->info.seq[dir];
-	other_way = &nat->info.seq[!dir];
+	this_way = &nat->seq[dir];
+	other_way = &nat->seq[!dir];
 
 	DEBUGP("nf_nat_resize_packet: Seq_offset before: ");
 	DUMP_OFFSET(this_way);
@@ -372,8 +372,7 @@ nf_nat_sack_adjust(struct sk_buff **pskb,
 			    op[1] >= 2+TCPOLEN_SACK_PERBLOCK &&
 			    ((op[1] - 2) % TCPOLEN_SACK_PERBLOCK) == 0)
 				sack_adjust(*pskb, tcph, optoff+2,
-					    optoff+op[1],
-					    &nat->info.seq[!dir]);
+					    optoff+op[1], &nat->seq[!dir]);
 			optoff += op[1];
 		}
 	}
@@ -394,8 +393,8 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 
 	dir = CTINFO2DIR(ctinfo);
 
-	this_way = &nat->info.seq[dir];
-	other_way = &nat->info.seq[!dir];
+	this_way = &nat->seq[dir];
+	other_way = &nat->seq[!dir];
 
 	if (!skb_make_writable(pskb, ip_hdrlen(*pskb) + sizeof(*tcph)))
 		return 0;
