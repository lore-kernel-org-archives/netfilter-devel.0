From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 47/69]: nf_nat: switch rwlock to spinlock
Date: Wed, 30 Jan 2008 21:18:06 +0100 (MET)
Message-ID: <20080130201804.29874.71761.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765179AbYA3USH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:07 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: switch rwlock to spinlock

Since we're using RCU, all users of nf_nat_lock take a write_lock.
Switch it to a spinlock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5cf331a51d8fed16e2e12142d8dc66eef5cb7bca
tree bd9226e5403ac965a26f9aa792a5951126d4c197
parent 9a797e6248868e23d468f801ec67b98a44ef689b
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:10 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:10 +0100

 net/ipv4/netfilter/nf_nat_core.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index c7a985f..dd07362 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -31,7 +31,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-static DEFINE_RWLOCK(nf_nat_lock);
+static DEFINE_SPINLOCK(nf_nat_lock);
 
 static struct nf_conntrack_l3proto *l3proto __read_mostly;
 
@@ -330,12 +330,12 @@ nf_nat_setup_info(struct nf_conn *ct,
 		unsigned int srchash;
 
 		srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		write_lock_bh(&nf_nat_lock);
+		spin_lock_bh(&nf_nat_lock);
 		/* nf_conntrack_alter_reply might re-allocate exntension aera */
 		nat = nfct_nat(ct);
 		nat->ct = ct;
 		hlist_add_head_rcu(&nat->bysource, &bysource[srchash]);
-		write_unlock_bh(&nf_nat_lock);
+		spin_unlock_bh(&nf_nat_lock);
 	}
 
 	/* It's done. */
@@ -521,14 +521,14 @@ int nf_nat_protocol_register(const struct nf_nat_protocol *proto)
 {
 	int ret = 0;
 
-	write_lock_bh(&nf_nat_lock);
+	spin_lock_bh(&nf_nat_lock);
 	if (nf_nat_protos[proto->protonum] != &nf_nat_unknown_protocol) {
 		ret = -EBUSY;
 		goto out;
 	}
 	rcu_assign_pointer(nf_nat_protos[proto->protonum], proto);
  out:
-	write_unlock_bh(&nf_nat_lock);
+	spin_unlock_bh(&nf_nat_lock);
 	return ret;
 }
 EXPORT_SYMBOL(nf_nat_protocol_register);
@@ -536,10 +536,10 @@ EXPORT_SYMBOL(nf_nat_protocol_register);
 /* Noone stores the protocol anywhere; simply delete it. */
 void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto)
 {
-	write_lock_bh(&nf_nat_lock);
+	spin_lock_bh(&nf_nat_lock);
 	rcu_assign_pointer(nf_nat_protos[proto->protonum],
 			   &nf_nat_unknown_protocol);
-	write_unlock_bh(&nf_nat_lock);
+	spin_unlock_bh(&nf_nat_lock);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_nat_protocol_unregister);
@@ -594,10 +594,10 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 
 	NF_CT_ASSERT(nat->ct->status & IPS_NAT_DONE_MASK);
 
-	write_lock_bh(&nf_nat_lock);
+	spin_lock_bh(&nf_nat_lock);
 	hlist_del_rcu(&nat->bysource);
 	nat->ct = NULL;
-	write_unlock_bh(&nf_nat_lock);
+	spin_unlock_bh(&nf_nat_lock);
 }
 
 static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
@@ -609,10 +609,10 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
 	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
 		return;
 
-	write_lock_bh(&nf_nat_lock);
+	spin_lock_bh(&nf_nat_lock);
 	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;
-	write_unlock_bh(&nf_nat_lock);
+	spin_unlock_bh(&nf_nat_lock);
 }
 
 static struct nf_ct_ext_type nat_extend __read_mostly = {
@@ -646,13 +646,13 @@ static int __init nf_nat_init(void)
 	}
 
 	/* Sew in builtin protocols. */
-	write_lock_bh(&nf_nat_lock);
+	spin_lock_bh(&nf_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
 		rcu_assign_pointer(nf_nat_protos[i], &nf_nat_unknown_protocol);
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_TCP], &nf_nat_protocol_tcp);
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_UDP], &nf_nat_protocol_udp);
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
-	write_unlock_bh(&nf_nat_lock);
+	spin_unlock_bh(&nf_nat_lock);
 
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
