From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next RFC 5/5] netfilter: complete the netns support for the kernel built-in cthelpers
Date: Sun,  4 Jun 2017 23:25:09 +0800
Message-ID: <1496589909-56730-6-git-send-email-zlpnobody@163.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:51748 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdFDP0A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 11:26:00 -0400
In-Reply-To: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

In order to support net namespace for these built-in cthelpers, we
must kmemdup the nf_conntrack_helper and the related _expect_policy
before we insert them to the nf_ct_helper_hash. Then free them after
unregistration. These are all done by helper_register/unregister.

But another issue is that for the user cthelper, it's unnecessary to
do kmemdup, as the cthelper is not shared between each netns. And we
need to know the refcnt to check whether it is in use. So add a
variant of helper_register/unregister function, this is only used
by user cthelper, the memory alloction/free is handled by the caller.

Now we complete the net namespace support for ct helpers.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 12 ++--
 net/netfilter/nf_conntrack_helper.c         | 92 ++++++++++++++++++++++++-----
 net/netfilter/nfnetlink_cthelper.c          |  6 +-
 3 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index a63451f..1689f93 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -55,6 +55,8 @@ struct nf_conntrack_helper {
 	unsigned int queue_num;
 	/* length of userspace private data stored in nf_conn_help->data */
 	u16 data_len;
+
+	const struct nf_conntrack_helper *orig_helper;
 };
 
 /* Must be kept in sync with the classes defined by helpers */
@@ -85,10 +87,8 @@ static inline struct net *nf_ct_helper_net(struct nf_conntrack_helper *helper)
 static inline void nf_ct_helper_put(struct nf_conntrack_helper *helper)
 {
 	if (refcount_dec_and_test(&helper->refcnt)) {
-		if (helper->flags & NF_CT_HELPER_F_USERSPACE) {
-			kfree(helper->expect_policy);
-			kfree(helper);
-		}
+		kfree(helper->expect_policy);
+		kfree(helper);
 	}
 }
 
@@ -114,8 +114,12 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 					  struct nf_conn *ct),
 		       struct module *module);
 
+int __nf_conntrack_helper_register(struct net *net,
+				   struct nf_conntrack_helper *me);
 int nf_conntrack_helper_register(struct net *net,
 				 struct nf_conntrack_helper *me);
+void __nf_conntrack_helper_unregister(struct net *net,
+				      struct nf_conntrack_helper *me);
 void nf_conntrack_helper_unregister(struct net *net,
 				    struct nf_conntrack_helper *me);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 248310d..5afa2c7 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -406,17 +406,14 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
-int nf_conntrack_helper_register(struct net *net,
-				 struct nf_conntrack_helper *me)
+int __nf_conntrack_helper_register(struct net *net,
+				   struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h = helper_hash(net, &me->tuple);
 	struct nf_conntrack_helper *cur;
 	int ret = 0, i;
 
-	if (!net_eq(net, &init_net))
-		return 0;
-
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
@@ -462,23 +459,44 @@ int nf_conntrack_helper_register(struct net *net,
 	mutex_unlock(&nf_ct_helper_mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__nf_conntrack_helper_register);
+
+int nf_conntrack_helper_register(struct net *net,
+				 struct nf_conntrack_helper *me)
+{
+	struct nf_conntrack_helper *helper;
+	int epol_sz, ret;
+
+	helper = kmemdup(me, sizeof(*me), GFP_KERNEL);
+	if (!helper)
+		return -ENOMEM;
+
+	epol_sz = (me->expect_class_max + 1) * sizeof(*me->expect_policy);
+	helper->expect_policy = kmemdup(me->expect_policy, epol_sz,
+					GFP_KERNEL);
+	if (!helper->expect_policy) {
+		kfree(helper);
+		return -ENOMEM;
+	}
+
+	helper->orig_helper = me;
+	ret = __nf_conntrack_helper_register(net, helper);
+	if (ret) {
+		kfree(helper->expect_policy);
+		kfree(helper);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
-void nf_conntrack_helper_unregister(struct net *net,
-				    struct nf_conntrack_helper *me)
+static void nf_conntrack_helper_cleanup(struct net *net,
+					struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
 	unsigned int i;
 
-	if (!net_eq(net, &init_net))
-		return 0;
-
-	mutex_lock(&nf_ct_helper_mutex);
-	hlist_del_rcu(&me->hnode);
-	net->ct.nf_ct_helper_count--;
-	mutex_unlock(&nf_ct_helper_mutex);
-
 	/* Make sure every nothing is still using the helper unless its a
 	 * connection in the hash.
 	 */
@@ -501,6 +519,50 @@ void nf_conntrack_helper_unregister(struct net *net,
 
 	nf_ct_iterate_cleanup_net(net, unhelp, me, 0, 0);
 }
+
+void __nf_conntrack_helper_unregister(struct net *net,
+				      struct nf_conntrack_helper *me)
+{
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
+	net->ct.nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	nf_conntrack_helper_cleanup(net, me);
+}
+EXPORT_SYMBOL_GPL(__nf_conntrack_helper_unregister);
+
+void nf_conntrack_helper_unregister(struct net *net,
+				    struct nf_conntrack_helper *me)
+{
+	struct nf_conntrack_helper *helper;
+	bool found = false;
+	int i;
+
+	mutex_lock(&nf_ct_helper_mutex);
+	for (i = 0; i < nf_ct_helper_hsize; i++) {
+		hlist_for_each_entry(helper, &nf_ct_helper_hash[i], hnode) {
+			if (net_eq(net, nf_ct_helper_net(helper)) &&
+			    helper->orig_helper == me) {
+				found = true;
+				goto out;
+			}
+		}
+	}
+out:
+	if (!found) {
+		WARN_ON_ONCE(1);
+		mutex_unlock(&nf_ct_helper_mutex);
+		return;
+	}
+
+	hlist_del_rcu(&helper->hnode);
+	net->ct.nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	nf_conntrack_helper_cleanup(net, helper);
+	nf_ct_helper_put(helper);
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5c4a45a..471e6d0 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -264,7 +264,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		}
 	}
 
-	ret = nf_conntrack_helper_register(net, helper);
+	ret = __nf_conntrack_helper_register(net, helper);
 	if (ret < 0)
 		goto err2;
 
@@ -704,7 +704,7 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 
 		if (refcount_dec_if_one(&cur->refcnt)) {
 			found = true;
-			nf_conntrack_helper_unregister(net, cur);
+			__nf_conntrack_helper_unregister(net, cur);
 			kfree(cur->expect_policy);
 
 			list_del(&nlcth->list);
@@ -759,7 +759,7 @@ static void __net_exit nfnl_cthelper_net_exit(struct net *net)
 	list_for_each_entry_safe(nlcth, n, &net->ct.nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 
-		nf_conntrack_helper_unregister(net, cur);
+		__nf_conntrack_helper_unregister(net, cur);
 		list_del(&nlcth->list);
 
 		nf_ct_helper_put(cur);
-- 
2.5.5


