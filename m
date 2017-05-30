From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: move table iteration out of netns exit paths
Date: Tue, 30 May 2017 11:31:06 +0200
Message-ID: <20170530093106.10138-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35322 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751002AbdE3Jav (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 05:30:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We only need to iterate & remove in case of module removal;
for netns destruction all conntracks will be removed anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index b7d01f27d463..6a36623e897c 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -265,6 +265,8 @@ void nf_ct_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 	mutex_unlock(&nf_ct_proto_mutex);
 
 	synchronize_rcu();
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_destroy(kill_l3proto, proto);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l3proto_unregister);
 
@@ -280,9 +282,6 @@ void nf_ct_l3proto_pernet_unregister(struct net *net,
 	 */
 	if (proto->net_ns_put)
 		proto->net_ns_put(net);
-
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup_net(net, kill_l3proto, proto, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l3proto_pernet_unregister);
 
@@ -421,17 +420,23 @@ int nf_ct_l4proto_pernet_register_one(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register_one);
 
-void nf_ct_l4proto_unregister_one(struct nf_conntrack_l4proto *l4proto)
+static void __nf_ct_l4proto_unregister_one(struct nf_conntrack_l4proto *l4proto)
+
 {
 	BUG_ON(l4proto->l3proto >= PF_MAX);
 
-	mutex_lock(&nf_ct_proto_mutex);
 	BUG_ON(rcu_dereference_protected(
 			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			lockdep_is_held(&nf_ct_proto_mutex)
 			) != l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
+}
+
+void nf_ct_l4proto_unregister_one(struct nf_conntrack_l4proto *l4proto)
+{
+	mutex_lock(&nf_ct_proto_mutex);
+	__nf_ct_l4proto_unregister_one(l4proto);
 	mutex_unlock(&nf_ct_proto_mutex);
 
 	synchronize_rcu();
@@ -448,9 +453,6 @@ void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 
 	pn->users--;
 	nf_ct_l4proto_unregister_sysctl(net, pn, l4proto);
-
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup_net(net, kill_l4proto, l4proto, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister_one);
 
@@ -500,8 +502,14 @@ EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register);
 void nf_ct_l4proto_unregister(struct nf_conntrack_l4proto *l4proto[],
 			      unsigned int num_proto)
 {
+	mutex_lock(&nf_ct_proto_mutex);
 	while (num_proto-- != 0)
-		nf_ct_l4proto_unregister_one(l4proto[num_proto]);
+		__nf_ct_l4proto_unregister_one(l4proto[num_proto]);
+	mutex_unlock(&nf_ct_proto_mutex);
+
+	synchronize_net();
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_destroy(kill_l4proto, l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister);
 
-- 
2.13.0

