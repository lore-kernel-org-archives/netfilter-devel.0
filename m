From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 25/79: netns nf_conntrack: cleanup after L3 and L4 proto unregister in every netns
Date: Wed,  8 Oct 2008 12:46:55 +0200 (MEST)
Message-ID: <20081008104655.10423.80219.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45931 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYJHKq4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:56 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 678d66753091a4102910392fb6198a6c6ce7f510
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:07 2008 +0200

    netfilter: netns nf_conntrack: cleanup after L3 and L4 proto unregister in every netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 3a2f7ef..a59a307 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -207,6 +207,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_register);
 
 void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 {
+	struct net *net;
+
 	BUG_ON(proto->l3proto >= AF_MAX);
 
 	mutex_lock(&nf_ct_proto_mutex);
@@ -219,7 +221,8 @@ void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(&init_net, kill_l3proto, proto);
+	for_each_net(net)
+		nf_ct_iterate_cleanup(net, kill_l3proto, proto);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -316,6 +319,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_register);
 
 void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 {
+	struct net *net;
+
 	BUG_ON(l4proto->l3proto >= PF_MAX);
 
 	mutex_lock(&nf_ct_proto_mutex);
@@ -328,7 +333,8 @@ void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(&init_net, kill_l4proto, l4proto);
+	for_each_net(net)
+		nf_ct_iterate_cleanup(net, kill_l4proto, l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
 
