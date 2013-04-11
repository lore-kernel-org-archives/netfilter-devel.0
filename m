From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nf_nat: fix race when unloading protocol modules
Date: Thu, 11 Apr 2013 16:22:39 +0200
Message-ID: <1365690159-31122-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51207 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab3DKOUa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:20:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

following oops was reported:
RIP: 0010:[<ffffffffa03227f2>]  [<ffffffffa03227f2>] nf_nat_cleanup_conntrack+0x42/0x70 [nf_nat]
RSP: 0018:ffff880202c63d40  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8801ac7bec28 RCX: ffff8801d0eedbe0
RDX: dead000000200200 RSI: 0000000000000011 RDI: ffffffffa03265b8
[..]
Call Trace:
 [..]
 [<ffffffffa02febed>] destroy_conntrack+0xbd/0x110 [nf_conntrack]

Happens when a conntrack timeout expires right after first part
of the nat cleanup has completed (bysrc hash removal), but before
part 2 has completed (re-initialization of nat area).

[ destroy callback tries to delete bysrc again ]

Patrick suggested to just remove the affected conntracks -- the
connections won't work properly anyway without nat transformation.

So, lets do that.

Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c |   40 +++++++---------------------------------
 1 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 346f871..2e469ca 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -468,33 +468,22 @@ EXPORT_SYMBOL_GPL(nf_nat_packet);
 struct nf_nat_proto_clean {
 	u8	l3proto;
 	u8	l4proto;
-	bool	hash;
 };
 
-/* Clear NAT section of all conntracks, in case we're loaded again. */
-static int nf_nat_proto_clean(struct nf_conn *i, void *data)
+/* kill conntracks with affected NAT section */
+static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 {
 	const struct nf_nat_proto_clean *clean = data;
 	struct nf_conn_nat *nat = nfct_nat(i);
 
 	if (!nat)
 		return 0;
-	if (!(i->status & IPS_SRC_NAT_DONE))
-		return 0;
+
 	if ((clean->l3proto && nf_ct_l3num(i) != clean->l3proto) ||
 	    (clean->l4proto && nf_ct_protonum(i) != clean->l4proto))
 		return 0;
 
-	if (clean->hash) {
-		spin_lock_bh(&nf_nat_lock);
-		hlist_del_rcu(&nat->bysource);
-		spin_unlock_bh(&nf_nat_lock);
-	} else {
-		memset(nat, 0, sizeof(*nat));
-		i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK |
-			       IPS_SEQ_ADJUST);
-	}
-	return 0;
+	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
 static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
@@ -506,16 +495,8 @@ static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
 	struct net *net;
 
 	rtnl_lock();
-	/* Step 1 - remove from bysource hash */
-	clean.hash = true;
 	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
-	synchronize_rcu();
-
-	/* Step 2 - clean NAT section */
-	clean.hash = false;
-	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
+		nf_ct_iterate_cleanup(net, nf_nat_proto_remove, &clean);
 	rtnl_unlock();
 }
 
@@ -527,16 +508,9 @@ static void nf_nat_l3proto_clean(u8 l3proto)
 	struct net *net;
 
 	rtnl_lock();
-	/* Step 1 - remove from bysource hash */
-	clean.hash = true;
-	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
-	synchronize_rcu();
 
-	/* Step 2 - clean NAT section */
-	clean.hash = false;
 	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
+		nf_ct_iterate_cleanup(net, nf_nat_proto_remove, &clean);
 	rtnl_unlock();
 }
 
@@ -774,7 +748,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
 {
 	struct nf_nat_proto_clean clean = {};
 
-	nf_ct_iterate_cleanup(net, &nf_nat_proto_clean, &clean);
+	nf_ct_iterate_cleanup(net, &nf_nat_proto_remove, &clean);
 	synchronize_rcu();
 	nf_ct_free_hashtable(net->ct.nat_bysource, net->ct.nat_htable_size);
 }
-- 
1.7.8.6

