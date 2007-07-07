From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/50]: nf_nat: add reference to conntrack from entry of
	bysource list
Date: Sat,  7 Jul 2007 14:23:25 +0200 (MEST)
Message-ID: <20070707122240.1589.14207.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: add reference to conntrack from entry of bysource list

I will split 'struct nf_nat_info' out from conntrack. So I cannot use
'offsetof' to get the pointer to conntrack from it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ca8862eb04148d8064245018a18d17dc618db19c
tree 96279a852daddddd0b71b016cbfffba3eb5261fb
parent 45ec366242d356c7f5c2c0b44fffc120fa376a6b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:30 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:30 +0200

 include/net/netfilter/nf_nat.h   |    5 +++--
 net/ipv4/netfilter/nf_nat_core.c |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 47d3dc1..575dc8a 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -53,11 +53,14 @@ struct nf_nat_multi_range_compat
 #include <linux/list.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
+struct nf_conn;
+
 /* The structure embedded in the conntrack structure. */
 struct nf_nat_info
 {
 	struct list_head bysource;
 	struct nf_nat_seq seq[IP_CT_DIR_MAX];
+	struct nf_conn *ct;
 };
 
 /* per conntrack: nat application helper private data */
@@ -77,8 +80,6 @@ struct nf_conn_nat
 #endif
 };
 
-struct nf_conn;
-
 /* Set up the info structure to map into this range. */
 extern unsigned int nf_nat_setup_info(struct nf_conn *ct,
 				      const struct nf_nat_range *range,
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index ea02f00..ac7e8ab 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -97,6 +97,7 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *conn)
 	nat = nfct_nat(conn);
 	write_lock_bh(&nf_nat_lock);
 	list_del(&nat->info.bysource);
+	nat->info.ct = NULL;
 	write_unlock_bh(&nf_nat_lock);
 }
 
@@ -169,7 +170,7 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 
 	read_lock_bh(&nf_nat_lock);
 	list_for_each_entry(nat, &bysource[h], info.bysource) {
-		ct = (struct nf_conn *)((char *)nat - offsetof(struct nf_conn, data));
+		ct = nat->info.ct;
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
@@ -337,6 +338,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 
 		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		write_lock_bh(&nf_nat_lock);
+		info->ct = ct;
 		list_add(&info->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
 	}
