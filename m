From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: nat: use keyed locks
Date: Wed,  6 Sep 2017 14:39:52 +0200
Message-ID: <20170906123952.12555-3-fw@strlen.de>
References: <20170906123952.12555-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Ivan Babrou <ibobrik@gmail.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34888 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753933AbdIFMjk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 08:39:40 -0400
In-Reply-To: <20170906123952.12555-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

no need to serialize on a single lock, we can partition the table and
add/delete in parallel to different slots.
This restores one of the advantages that got lost with the rhlist
revert.

Cc: Ivan Babrou <ibobrik@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2fb80a4bfb34..ad29637d1b62 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -30,7 +30,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_nat.h>
 
-static DEFINE_SPINLOCK(nf_nat_lock);
+static spinlock_t nf_nat_locks[CONNTRACK_LOCKS];
 
 static DEFINE_MUTEX(nf_nat_proto_mutex);
 static const struct nf_nat_l3proto __rcu *nf_nat_l3protos[NFPROTO_NUMPROTO]
@@ -423,13 +423,15 @@ nf_nat_setup_info(struct nf_conn *ct,
 
 	if (maniptype == NF_NAT_MANIP_SRC) {
 		unsigned int srchash;
+		spinlock_t *lock;
 
 		srchash = hash_by_src(net,
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		spin_lock_bh(&nf_nat_lock);
+		lock = &nf_nat_locks[srchash % ARRAY_SIZE(nf_nat_locks)];
+		spin_lock_bh(lock);
 		hlist_add_head_rcu(&ct->nat_bysource,
 				   &nf_nat_bysource[srchash]);
-		spin_unlock_bh(&nf_nat_lock);
+		spin_unlock_bh(lock);
 	}
 
 	/* It's done. */
@@ -523,6 +525,16 @@ static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
+static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
+{
+	unsigned int h;
+
+	h = hash_by_src(nf_ct_net(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	spin_lock_bh(&nf_nat_locks[h % ARRAY_SIZE(nf_nat_locks)]);
+	hlist_del_rcu(&ct->nat_bysource);
+	spin_unlock_bh(&nf_nat_locks[h % ARRAY_SIZE(nf_nat_locks)]);
+}
+
 static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 {
 	if (nf_nat_proto_remove(ct, data))
@@ -538,9 +550,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	 * will delete entry from already-freed table.
 	 */
 	clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
-	spin_lock_bh(&nf_nat_lock);
-	hlist_del_rcu(&ct->nat_bysource);
-	spin_unlock_bh(&nf_nat_lock);
+	__nf_nat_cleanup_conntrack(ct);
 
 	/* don't delete conntrack.  Although that would make things a lot
 	 * simpler, we'd end up flushing all conntracks on nat rmmod.
@@ -668,11 +678,8 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_unregister);
 /* No one using conntrack by the time this called. */
 static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
-	if (ct->status & IPS_SRC_NAT_DONE) {
-		spin_lock_bh(&nf_nat_lock);
-		hlist_del_rcu(&ct->nat_bysource);
-		spin_unlock_bh(&nf_nat_lock);
-	}
+	if (ct->status & IPS_SRC_NAT_DONE)
+		__nf_nat_cleanup_conntrack(ct);
 }
 
 static struct nf_ct_ext_type nat_extend __read_mostly = {
@@ -794,10 +801,12 @@ static struct nf_ct_helper_expectfn follow_master_nat = {
 
 static int __init nf_nat_init(void)
 {
-	int ret;
+	int ret, i;
 
 	/* Leave them the same for the moment. */
 	nf_nat_htable_size = nf_conntrack_htable_size;
+	if (nf_nat_htable_size < ARRAY_SIZE(nf_nat_locks))
+		nf_nat_htable_size = ARRAY_SIZE(nf_nat_locks);
 
 	nf_nat_bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size, 0);
 	if (!nf_nat_bysource)
@@ -810,6 +819,9 @@ static int __init nf_nat_init(void)
 		return ret;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(nf_nat_locks); i++)
+		spin_lock_init(&nf_nat_locks[i]);
+
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
 	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
-- 
2.13.0

