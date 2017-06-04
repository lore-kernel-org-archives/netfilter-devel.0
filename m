From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next RFC 4/5] netfilter: complete the netns support for the user cthelpers
Date: Sun,  4 Jun 2017 23:25:08 +0800
Message-ID: <1496589909-56730-5-git-send-email-zlpnobody@163.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:51608 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdFDPZz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 11:25:55 -0400
In-Reply-To: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

First, we should make the global nfnl_cthelper_list become per-net,
so different netns's user cthelpers will be linked to the different
global lists.

Second, when we do the netns cleanup work, we may invoke the
nfnl_cthelper_net_exit and nf_conntrack_helper_put in different orders,
so we should free the cthelper only when the refcnt is decreased to 0,
this is similar to nfnetlink_cttimeout.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 10 +++++
 include/net/netns/conntrack.h               |  3 ++
 net/netfilter/nf_conntrack_helper.c         |  2 +-
 net/netfilter/nfnetlink_cthelper.c          | 68 ++++++++++++++++++++---------
 4 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 7ac67c4..a63451f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -82,6 +82,16 @@ static inline struct net *nf_ct_helper_net(struct nf_conntrack_helper *helper)
 	return read_pnet(&helper->net);
 }
 
+static inline void nf_ct_helper_put(struct nf_conntrack_helper *helper)
+{
+	if (refcount_dec_and_test(&helper->refcnt)) {
+		if (helper->flags & NF_CT_HELPER_F_USERSPACE) {
+			kfree(helper->expect_policy);
+			kfree(helper);
+		}
+	}
+}
+
 struct nf_conntrack_helper *__nf_conntrack_helper_find(struct net *net,
 						       const char *name,
 						       u16 l3num, u8 protonum);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 244b794..8b1d2f9 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -111,6 +111,9 @@ struct netns_ct {
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 
+#if IS_ENABLED(CONFIG_NF_CT_NETLINK_HELPER)
+	struct list_head	nfnl_cthelper_list;
+#endif
 	unsigned int		nf_ct_helper_count;
 
 	struct ct_pcpu __percpu *pcpu_lists;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 3f3eeb9..248310d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -201,8 +201,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
 
 void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 {
-	refcount_dec(&helper->refcnt);
 	module_put(helper->me);
+	nf_ct_helper_put(helper);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 90603b1..5c4a45a 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -33,12 +33,10 @@ MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_DESCRIPTION("nfnl_cthelper: User-space connection tracking helpers");
 
 struct nfnl_cthelper {
-	struct list_head		list;
 	struct nf_conntrack_helper	helper;
+	struct list_head		list;
 };
 
-static LIST_HEAD(nfnl_cthelper_list);
-
 static int
 nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
@@ -214,7 +212,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 
 static int
 nfnl_cthelper_create(const struct nlattr * const tb[],
-		     struct nf_conntrack_tuple *tuple)
+		     struct nf_conntrack_tuple *tuple,
+		     struct net *net)
 {
 	struct nf_conntrack_helper *helper;
 	struct nfnl_cthelper *nfcth;
@@ -265,11 +264,11 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		}
 	}
 
-	ret = nf_conntrack_helper_register(&init_net, helper);
+	ret = nf_conntrack_helper_register(net, helper);
 	if (ret < 0)
 		goto err2;
 
-	list_add_tail(&nfcth->list, &nfnl_cthelper_list);
+	list_add_tail(&nfcth->list, &net->ct.nfnl_cthelper_list);
 	return 0;
 err2:
 	kfree(helper->expect_policy);
@@ -415,7 +414,7 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	if (ret < 0)
 		return ret;
 
-	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
+	list_for_each_entry(nlcth, &net->ct.nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 
 		if (strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
@@ -433,7 +432,7 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	}
 
 	if (helper == NULL)
-		ret = nfnl_cthelper_create(tb, &tuple);
+		ret = nfnl_cthelper_create(tb, &tuple, net);
 	else
 		ret = nfnl_cthelper_update(tb, helper);
 
@@ -561,6 +560,7 @@ static int
 nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_helper *cur, *last;
+	struct net *net = sock_net(skb->sk);
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_helper *)cb->args[1];
@@ -568,6 +568,8 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 restart:
 		hlist_for_each_entry_rcu(cur,
 				&nf_ct_helper_hash[cb->args[0]], hnode) {
+			if (!net_eq(net, nf_ct_helper_net(cur)))
+				continue;
 
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
@@ -627,7 +629,7 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 		tuple_set = true;
 	}
 
-	list_for_each_entry(nlcth, &nfnl_cthelper_list, list) {
+	list_for_each_entry(nlcth, &net->ct.nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 		if (helper_name &&
 		    strncmp(cur->name, helper_name, NF_CT_HELPER_NAME_LEN))
@@ -687,7 +689,7 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 	}
 
 	ret = -ENOENT;
-	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
+	list_for_each_entry_safe(nlcth, n, &net->ct.nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 		j++;
 
@@ -743,34 +745,58 @@ static const struct nfnetlink_subsystem nfnl_cthelper_subsys = {
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTHELPER);
 
+static int __net_init nfnl_cthelper_net_init(struct net *net)
+{
+	INIT_LIST_HEAD(&net->ct.nfnl_cthelper_list);
+	return 0;
+}
+
+static void __net_exit nfnl_cthelper_net_exit(struct net *net)
+{
+	struct nf_conntrack_helper *cur;
+	struct nfnl_cthelper *nlcth, *n;
+
+	list_for_each_entry_safe(nlcth, n, &net->ct.nfnl_cthelper_list, list) {
+		cur = &nlcth->helper;
+
+		nf_conntrack_helper_unregister(net, cur);
+		list_del(&nlcth->list);
+
+		nf_ct_helper_put(cur);
+	}
+}
+
+static struct pernet_operations nfnl_cthelper_net_ops = {
+	.init	= nfnl_cthelper_net_init,
+	.exit	= nfnl_cthelper_net_exit,
+};
+
 static int __init nfnl_cthelper_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON(offsetof(struct nfnl_cthelper, helper) != 0);
+
+	ret = register_pernet_subsys(&nfnl_cthelper_net_ops);
+	if (ret < 0)
+		return ret;
+
 	ret = nfnetlink_subsys_register(&nfnl_cthelper_subsys);
 	if (ret < 0) {
 		pr_err("nfnl_cthelper: cannot register with nfnetlink.\n");
 		goto err_out;
 	}
 	return 0;
+
 err_out:
+	unregister_pernet_subsys(&nfnl_cthelper_net_ops);
 	return ret;
 }
 
 static void __exit nfnl_cthelper_exit(void)
 {
-	struct nf_conntrack_helper *cur;
-	struct nfnl_cthelper *nlcth, *n;
-
 	nfnetlink_subsys_unregister(&nfnl_cthelper_subsys);
-
-	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
-		cur = &nlcth->helper;
-
-		nf_conntrack_helper_unregister(&init_net, cur);
-		kfree(cur->expect_policy);
-		kfree(nlcth);
-	}
+	unregister_pernet_subsys(&nfnl_cthelper_net_ops);
 }
 
 module_init(nfnl_cthelper_init);
-- 
2.5.5


