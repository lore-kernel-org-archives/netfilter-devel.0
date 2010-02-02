From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/06: ctnetlink: only assign helpers for matching protocols
Date: Tue,  2 Feb 2010 17:52:59 +0100 (MET)
Message-ID: <20100202165258.25160.58213.sendpatchset@x2.localnet>
References: <20100202165253.25160.18314.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33893 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab0BBQxA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:53:00 -0500
In-Reply-To: <20100202165253.25160.18314.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 331b603738531949ab227d0671e204080231166c
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Feb 2 17:17:17 2010 +0100

    netfilter: ctnetlink: only assign helpers for matching protocols
    
    Make sure not to assign a helper for a different network or transport
    layer protocol to a connection.
    
    Additionally change expectation deletion by helper to compare the name
    directly - there might be multiple helper registrations using the same
    name, currently one of them is chosen in an unpredictable manner and
    only those expectations are removed.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index d015de9..86be7c4 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -40,7 +40,7 @@ struct nf_conntrack_helper {
 };
 
 extern struct nf_conntrack_helper *
-__nf_conntrack_helper_find_byname(const char *name);
+__nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum);
 
 extern int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 extern void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 65c2a7b..c0e461f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -65,7 +65,7 @@ __nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
 }
 
 struct nf_conntrack_helper *
-__nf_conntrack_helper_find_byname(const char *name)
+__nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
 	struct nf_conntrack_helper *h;
 	struct hlist_node *n;
@@ -73,13 +73,15 @@ __nf_conntrack_helper_find_byname(const char *name)
 
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
 		hlist_for_each_entry_rcu(h, n, &nf_ct_helper_hash[i], hnode) {
-			if (!strcmp(h->name, name))
+			if (!strcmp(h->name, name) &&
+			    h->tuple.src.l3num == l3num &&
+			    h->tuple.dst.protonum == protonum)
 				return h;
 		}
 	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find_byname);
+EXPORT_SYMBOL_GPL(__nf_conntrack_helper_find);
 
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 20e49ab..f5c0b09 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1001,7 +1001,8 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
 		return 0;
 	}
 
-	helper = __nf_conntrack_helper_find_byname(helpname);
+	helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+					    nf_ct_protonum(ct));
 	if (helper == NULL) {
 #ifdef CONFIG_MODULES
 		spin_unlock_bh(&nf_conntrack_lock);
@@ -1012,7 +1013,8 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
 		}
 
 		spin_lock_bh(&nf_conntrack_lock);
-		helper = __nf_conntrack_helper_find_byname(helpname);
+		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+						    nf_ct_protonum(ct));
 		if (helper)
 			return -EAGAIN;
 #endif
@@ -1211,7 +1213,8 @@ ctnetlink_create_conntrack(struct net *net,
  		if (err < 0)
 			goto err2;
 
-		helper = __nf_conntrack_helper_find_byname(helpname);
+		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
+						    nf_ct_protonum(ct));
 		if (helper == NULL) {
 			rcu_read_unlock();
 #ifdef CONFIG_MODULES
@@ -1221,7 +1224,9 @@ ctnetlink_create_conntrack(struct net *net,
 			}
 
 			rcu_read_lock();
-			helper = __nf_conntrack_helper_find_byname(helpname);
+			helper = __nf_conntrack_helper_find(helpname,
+							    nf_ct_l3num(ct),
+							    nf_ct_protonum(ct));
 			if (helper) {
 				err = -EAGAIN;
 				goto err2;
@@ -1716,7 +1721,6 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 	struct net *net = sock_net(ctnl);
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
-	struct nf_conntrack_helper *h;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct hlist_node *n, *next;
 	u_int8_t u3 = nfmsg->nfgen_family;
@@ -1753,18 +1757,13 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 
 		/* delete all expectations for this helper */
 		spin_lock_bh(&nf_conntrack_lock);
-		h = __nf_conntrack_helper_find_byname(name);
-		if (!h) {
-			spin_unlock_bh(&nf_conntrack_lock);
-			return -EOPNOTSUPP;
-		}
 		for (i = 0; i < nf_ct_expect_hsize; i++) {
 			hlist_for_each_entry_safe(exp, n, next,
 						  &net->ct.expect_hash[i],
 						  hnode) {
 				m_help = nfct_help(exp->master);
-				if (m_help->helper == h
-				    && del_timer(&exp->timeout)) {
+				if (!strcmp(m_help->helper->name, name) &&
+				    del_timer(&exp->timeout)) {
 					nf_ct_unlink_expect(exp);
 					nf_ct_expect_put(exp);
 				}
