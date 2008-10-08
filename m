From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 24/79: netns nf_conntrack: unregister helper in every netns
Date: Wed,  8 Oct 2008 12:46:53 +0200 (MEST)
Message-ID: <20081008104653.10423.87271.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45928 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYJHKqz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:55 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 68047937677f2dffb5c47b57ce8baba5714b2142
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:06 2008 +0200

    netfilter: netns nf_conntrack: unregister helper in every netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 920e778..9c06b9f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -123,29 +123,18 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
+					     struct net *net)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *n, *next;
 	unsigned int i;
 
-	mutex_lock(&nf_ct_helper_mutex);
-	hlist_del_rcu(&me->hnode);
-	nf_ct_helper_count--;
-	mutex_unlock(&nf_ct_helper_mutex);
-
-	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
-	 */
-	synchronize_rcu();
-
-	spin_lock_bh(&nf_conntrack_lock);
-
 	/* Get rid of expectations */
 	for (i = 0; i < nf_ct_expect_hsize; i++) {
 		hlist_for_each_entry_safe(exp, n, next,
-					  &init_net.ct.expect_hash[i], hnode) {
+					  &net->ct.expect_hash[i], hnode) {
 			struct nf_conn_help *help = nfct_help(exp->master);
 			if ((help->helper == me || exp->helper == me) &&
 			    del_timer(&exp->timeout)) {
@@ -156,12 +145,31 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	}
 
 	/* Get rid of expecteds, set helpers to NULL. */
-	hlist_for_each_entry(h, n, &init_net.ct.unconfirmed, hnode)
+	hlist_for_each_entry(h, n, &net->ct.unconfirmed, hnode)
 		unhelp(h, me);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		hlist_for_each_entry(h, n, &init_net.ct.hash[i], hnode)
+		hlist_for_each_entry(h, n, &net->ct.hash[i], hnode)
 			unhelp(h, me);
 	}
+}
+
+void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+{
+	struct net *net;
+
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
+	nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	/* Make sure every nothing is still using the helper unless its a
+	 * connection in the hash.
+	 */
+	synchronize_rcu();
+
+	spin_lock_bh(&nf_conntrack_lock);
+	for_each_net(net)
+		__nf_conntrack_helper_unregister(me, net);
 	spin_unlock_bh(&nf_conntrack_lock);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
