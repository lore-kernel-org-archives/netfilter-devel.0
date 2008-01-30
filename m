From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 46/69]: nf_nat: use RCU for bysource hash
Date: Wed, 30 Jan 2008 21:18:05 +0100 (MET)
Message-ID: <20080130201802.29874.49533.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765768AbYA3USG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:06 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: use RCU for bysource hash

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a797e6248868e23d468f801ec67b98a44ef689b
tree 5d08e94eede5551cc1f0188da7074d9b285b41be
parent cd3672c2df98db3eb29b793ec537f8382e268dc8
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:09 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:09 +0100

 net/ipv4/netfilter/nf_nat_core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index c07575d..c7a985f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -154,8 +154,8 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 	struct nf_conn *ct;
 	struct hlist_node *n;
 
-	read_lock_bh(&nf_nat_lock);
-	hlist_for_each_entry(nat, n, &bysource[h], bysource) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(nat, n, &bysource[h], bysource) {
 		ct = nat->ct;
 		if (same_src(ct, tuple)) {
 			/* Copy source part from reply tuple. */
@@ -164,12 +164,12 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 			result->dst = tuple->dst;
 
 			if (in_range(result, range)) {
-				read_unlock_bh(&nf_nat_lock);
+				rcu_read_unlock();
 				return 1;
 			}
 		}
 	}
-	read_unlock_bh(&nf_nat_lock);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -334,7 +334,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
 		nat = nfct_nat(ct);
 		nat->ct = ct;
-		hlist_add_head(&nat->bysource, &bysource[srchash]);
+		hlist_add_head_rcu(&nat->bysource, &bysource[srchash]);
 		write_unlock_bh(&nf_nat_lock);
 	}
 
@@ -595,7 +595,7 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 	NF_CT_ASSERT(nat->ct->status & IPS_NAT_DONE_MASK);
 
 	write_lock_bh(&nf_nat_lock);
-	hlist_del(&nat->bysource);
+	hlist_del_rcu(&nat->bysource);
 	nat->ct = NULL;
 	write_unlock_bh(&nf_nat_lock);
 }
