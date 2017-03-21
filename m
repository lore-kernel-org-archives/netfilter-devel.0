From: fgao@ikuai8.com
Subject: [PATCH nf v3 1/2] netfilter: helper: Rename struct nf_ct_helper_expectfn to nf_ct_nat_helper
Date: Tue, 21 Mar 2017 14:06:25 +0800
Message-ID: <6c1a82ddb0a9d0c387c906823e4ed613d8f9f7b4.1490060879.git.fgao@ikuai8.com>
References: <cover.1490060879.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree_wind@126.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast1.qq.com ([54.204.34.129]:51496 "EHLO
        smtpbguseast1.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755006AbdCUGH7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 02:07:59 -0400
In-Reply-To: <cover.1490060879.git.fgao@ikuai8.com>
In-Reply-To: <cover.1490060879.git.fgao@ikuai8.com>
References: <cover.1490060879.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Rename struct nf_ct_helper_expectfn to nf_ct_nat_helper, and rename
other functions or variables which refer to it.
The new name is better than the old one.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v3: Rename the nf_ct_helper_expectfn, func, and member, per Pablo,
 v2: Use the module as the identifier when flush expect
 v1: initial version

 include/net/netfilter/nf_conntrack_helper.h | 14 ++++++-------
 net/ipv4/netfilter/nf_nat_h323.c            | 12 +++++------
 net/netfilter/nf_conntrack_helper.c         | 32 ++++++++++++++---------------
 net/netfilter/nf_conntrack_netlink.c        | 16 +++++++--------
 net/netfilter/nf_nat_core.c                 |  6 +++---
 net/netfilter/nf_nat_sip.c                  |  6 +++---
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 1eaac1f..d14fe493 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -111,7 +111,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
 				enum ip_conntrack_info ctinfo,
 				unsigned int timeout);
 
-struct nf_ct_helper_expectfn {
+struct nf_ct_nat_helper {
 	struct list_head head;
 	const char *name;
 	void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
@@ -121,12 +121,12 @@ struct nf_ct_helper_expectfn {
 void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 		      const char *fmt, ...);
 
-void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n);
-void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n);
-struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_name(const char *name);
-struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
+void nf_ct_nat_helper_register(struct nf_ct_nat_helper *n);
+void nf_ct_nat_helper_unregister(struct nf_ct_nat_helper *n);
+struct nf_ct_nat_helper *
+nf_ct_nat_helper_find_by_name(const char *name);
+struct nf_ct_nat_helper *
+nf_ct_nat_helper_find_by_symbol(const void *symbol);
 
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 574f7eb..346e764 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -567,12 +567,12 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	return 0;
 }
 
-static struct nf_ct_helper_expectfn q931_nat = {
+static struct nf_ct_nat_helper q931_nat = {
 	.name		= "Q.931",
 	.expectfn	= ip_nat_q931_expect,
 };
 
-static struct nf_ct_helper_expectfn callforwarding_nat = {
+static struct nf_ct_nat_helper callforwarding_nat = {
 	.name		= "callforwarding",
 	.expectfn	= ip_nat_callforwarding_expect,
 };
@@ -599,8 +599,8 @@ static int __init init(void)
 	RCU_INIT_POINTER(nat_h245_hook, nat_h245);
 	RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
 	RCU_INIT_POINTER(nat_q931_hook, nat_q931);
-	nf_ct_helper_expectfn_register(&q931_nat);
-	nf_ct_helper_expectfn_register(&callforwarding_nat);
+	nf_ct_nat_helper_register(&q931_nat);
+	nf_ct_nat_helper_register(&callforwarding_nat);
 	return 0;
 }
 
@@ -616,8 +616,8 @@ static void __exit fini(void)
 	RCU_INIT_POINTER(nat_h245_hook, NULL);
 	RCU_INIT_POINTER(nat_callforwarding_hook, NULL);
 	RCU_INIT_POINTER(nat_q931_hook, NULL);
-	nf_ct_helper_expectfn_unregister(&q931_nat);
-	nf_ct_helper_expectfn_unregister(&callforwarding_nat);
+	nf_ct_nat_helper_unregister(&q931_nat);
+	nf_ct_nat_helper_unregister(&callforwarding_nat);
 	synchronize_rcu();
 }
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..0eaa01e 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -293,32 +293,32 @@ void nf_ct_helper_destroy(struct nf_conn *ct)
 	}
 }
 
-static LIST_HEAD(nf_ct_helper_expectfn_list);
+static LIST_HEAD(nf_ct_nat_helper_list);
 
-void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n)
+void nf_ct_nat_helper_register(struct nf_ct_nat_helper *n)
 {
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	list_add_rcu(&n->head, &nf_ct_helper_expectfn_list);
+	list_add_rcu(&n->head, &nf_ct_nat_helper_list);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
-EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_register);
+EXPORT_SYMBOL_GPL(nf_ct_nat_helper_register);
 
-void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
+void nf_ct_nat_helper_unregister(struct nf_ct_nat_helper *n)
 {
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	list_del_rcu(&n->head);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
-EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
+EXPORT_SYMBOL_GPL(nf_ct_nat_helper_unregister);
 
-struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_name(const char *name)
+struct nf_ct_nat_helper *
+nf_ct_nat_helper_find_by_name(const char *name)
 {
-	struct nf_ct_helper_expectfn *cur;
+	struct nf_ct_nat_helper *cur;
 	bool found = false;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
+	list_for_each_entry_rcu(cur, &nf_ct_nat_helper_list, head) {
 		if (!strcmp(cur->name, name)) {
 			found = true;
 			break;
@@ -327,16 +327,16 @@ struct nf_ct_helper_expectfn *
 	rcu_read_unlock();
 	return found ? cur : NULL;
 }
-EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);
+EXPORT_SYMBOL_GPL(nf_ct_nat_helper_find_by_name);
 
-struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_symbol(const void *symbol)
+struct nf_ct_nat_helper *
+nf_ct_nat_helper_find_by_symbol(const void *symbol)
 {
-	struct nf_ct_helper_expectfn *cur;
+	struct nf_ct_nat_helper *cur;
 	bool found = false;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
+	list_for_each_entry_rcu(cur, &nf_ct_nat_helper_list, head) {
 		if (cur->expectfn == symbol) {
 			found = true;
 			break;
@@ -345,7 +345,7 @@ struct nf_ct_helper_expectfn *
 	rcu_read_unlock();
 	return found ? cur : NULL;
 }
-EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_symbol);
+EXPORT_SYMBOL_GPL(nf_ct_nat_helper_find_by_symbol);
 
 __printf(3, 4)
 void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6806b5e..66817a5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2508,7 +2508,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
 #endif
-	struct nf_ct_helper_expectfn *expfn;
+	struct nf_ct_nat_helper *nat_helper;
 
 	if (timeout < 0)
 		timeout = 0;
@@ -2557,9 +2557,9 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 		    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
 			goto nla_put_failure;
 	}
-	expfn = nf_ct_helper_expectfn_find_by_symbol(exp->expectfn);
-	if (expfn != NULL &&
-	    nla_put_string(skb, CTA_EXPECT_FN, expfn->name))
+	nat_helper = nf_ct_nat_helper_find_by_symbol(exp->expectfn);
+	if (!nat_helper &&
+	    nla_put_string(skb, CTA_EXPECT_FN, nat_helper->name))
 		goto nla_put_failure;
 
 	return 0;
@@ -3070,14 +3070,14 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
-		struct nf_ct_helper_expectfn *expfn;
+		struct nf_ct_nat_helper *nat_helper;
 
-		expfn = nf_ct_helper_expectfn_find_by_name(name);
-		if (expfn == NULL) {
+		nat_helper = nf_ct_nat_helper_find_by_name(name);
+		if (!nat_helper) {
 			err = -EINVAL;
 			goto err_out;
 		}
-		exp->expectfn = expfn->expectfn;
+		exp->expectfn = nat_helper->expectfn;
 	} else
 		exp->expectfn = NULL;
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 94b14c5..eae9bec 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -848,7 +848,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
 	.exit = nf_nat_net_exit,
 };
 
-static struct nf_ct_helper_expectfn follow_master_nat = {
+static struct nf_ct_nat_helper follow_master_nat = {
 	.name		= "nat-follow-master",
 	.expectfn	= nf_nat_follow_master,
 };
@@ -872,7 +872,7 @@ static int __init nf_nat_init(void)
 	if (ret < 0)
 		goto cleanup_extend;
 
-	nf_ct_helper_expectfn_register(&follow_master_nat);
+	nf_ct_nat_helper_register(&follow_master_nat);
 
 	/* Initialize fake conntrack so that NAT will skip it */
 	nf_ct_untracked_status_or(IPS_NAT_DONE_MASK);
@@ -898,7 +898,7 @@ static void __exit nf_nat_cleanup(void)
 
 	unregister_pernet_subsys(&nf_nat_net_ops);
 	nf_ct_extend_unregister(&nat_extend);
-	nf_ct_helper_expectfn_unregister(&follow_master_nat);
+	nf_ct_nat_helper_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
 #ifdef CONFIG_XFRM
 	RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 791fac4..d27c5a2 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -618,7 +618,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 	return NF_DROP;
 }
 
-static struct nf_ct_helper_expectfn sip_nat = {
+static struct nf_ct_nat_helper sip_nat = {
 	.name		= "sip",
 	.expectfn	= nf_nat_sip_expected,
 };
@@ -627,7 +627,7 @@ static void __exit nf_nat_sip_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
 
-	nf_ct_helper_expectfn_unregister(&sip_nat);
+	nf_ct_nat_helper_unregister(&sip_nat);
 	synchronize_rcu();
 }
 
@@ -645,7 +645,7 @@ static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hooks != NULL);
 	RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
-	nf_ct_helper_expectfn_register(&sip_nat);
+	nf_ct_nat_helper_register(&sip_nat);
 	return 0;
 }
 
-- 
1.9.1



