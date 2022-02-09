Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DC8C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 16:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiBIQLO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 11:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiBIQLM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 11:11:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B73CC0613C9
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 08:11:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nHpYn-0004U8-Mm; Wed, 09 Feb 2022 17:11:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/7] netfilter: ctnetlink: make ecache event cb global again
Date:   Wed,  9 Feb 2022 17:10:52 +0100
Message-Id: <20220209161057.30688-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209161057.30688-1-fw@strlen.de>
References: <20220209161057.30688-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This was pernet to make sure we do not trip over already closed nfnl sk.

After moving nfnl validity checks to nfnetlink core this can be global
again, it only needs to be set to NULL when the module is removed.

This also avoids the need for pernet ops in ctnetlink and register mutex.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h | 18 +++++------
 include/net/netns/conntrack.h               |  1 -
 net/netfilter/nf_conntrack_ecache.c         | 32 ++++++-------------
 net/netfilter/nf_conntrack_netlink.c        | 35 ++++-----------------
 4 files changed, 23 insertions(+), 63 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 6c4c490a3e34..ebd816af9c40 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -83,9 +83,8 @@ struct nf_ct_event_notifier {
 	int (*exp_event)(unsigned int events, const struct nf_exp_event *item);
 };
 
-void nf_conntrack_register_notifier(struct net *net,
-				   const struct nf_ct_event_notifier *nb);
-void nf_conntrack_unregister_notifier(struct net *net);
+void nf_conntrack_register_notifier(const struct nf_ct_event_notifier *nb);
+void nf_conntrack_unregister_notifier(void);
 
 void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
@@ -107,14 +106,15 @@ static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
 
 #endif
 
+extern const struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
+
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
+	if (!rcu_access_pointer(nf_conntrack_event_cb))
 		return;
 
 	e = nf_ct_ecache_find(ct);
@@ -130,9 +130,7 @@ nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
+	if (!rcu_access_pointer(nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
@@ -145,9 +143,7 @@ static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
+	if (!rcu_access_pointer(nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 0294f3d473af..3bb62e938fa9 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -112,7 +112,6 @@ struct netns_ct {
 
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
-	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 07e65b4e92f8..13ba6aa82ec1 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -27,7 +27,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-static DEFINE_MUTEX(nf_ct_ecache_mutex);
+const struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
 
 #define ECACHE_RETRY_WAIT (HZ/10)
 #define ECACHE_STACK_ALLOC (256 / sizeof(void *))
@@ -135,8 +135,7 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 					   const u32 missed,
 					   const struct nf_ct_event *item)
 {
-	struct net *net = nf_ct_net(item->ct);
-	struct nf_ct_event_notifier *notify;
+	const struct nf_ct_event_notifier *notify;
 	u32 old, want;
 	int ret;
 
@@ -145,7 +144,7 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 
 	rcu_read_lock();
 
-	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
+	notify = rcu_dereference(nf_conntrack_event_cb);
 	if (!notify) {
 		rcu_read_unlock();
 		return 0;
@@ -240,12 +239,11 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			       u32 portid, int report)
 
 {
-	struct net *net = nf_ct_exp_net(exp);
-	struct nf_ct_event_notifier *notify;
+	const struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
+	notify = rcu_dereference(nf_conntrack_event_cb);
 	if (!notify)
 		goto out_unlock;
 
@@ -265,26 +263,16 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	rcu_read_unlock();
 }
 
-void nf_conntrack_register_notifier(struct net *net,
-				    const struct nf_ct_event_notifier *new)
+void nf_conntrack_register_notifier(const struct nf_ct_event_notifier *new)
 {
-	struct nf_ct_event_notifier *notify;
-
-	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
-					   lockdep_is_held(&nf_ct_ecache_mutex));
-	WARN_ON_ONCE(notify);
-	rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
-	mutex_unlock(&nf_ct_ecache_mutex);
+	WARN_ON_ONCE(rcu_access_pointer(nf_conntrack_event_cb));
+	rcu_assign_pointer(nf_conntrack_event_cb, new);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-void nf_conntrack_unregister_notifier(struct net *net)
+void nf_conntrack_unregister_notifier(void)
 {
-	mutex_lock(&nf_ct_ecache_mutex);
-	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
-	mutex_unlock(&nf_ct_ecache_mutex);
-	/* synchronize_rcu() is called after netns pre_exit */
+	RCU_INIT_POINTER(nf_conntrack_event_cb, NULL);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d9f9ee50294..db1d27e88ae4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3771,7 +3771,7 @@ static int ctnetlink_stat_exp_cpu(struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-static struct nf_ct_event_notifier ctnl_notifier = {
+static const struct nf_ct_event_notifier ctnl_notifier = {
 	.ct_event = ctnetlink_conntrack_event,
 	.exp_event = ctnetlink_expect_event,
 };
@@ -3863,26 +3863,6 @@ MODULE_ALIAS("ip_conntrack_netlink");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
-static int __net_init ctnetlink_net_init(struct net *net)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_conntrack_register_notifier(net, &ctnl_notifier);
-#endif
-	return 0;
-}
-
-static void ctnetlink_net_pre_exit(struct net *net)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_conntrack_unregister_notifier(net);
-#endif
-}
-
-static struct pernet_operations ctnetlink_net_ops = {
-	.init		= ctnetlink_net_init,
-	.pre_exit	= ctnetlink_net_pre_exit,
-};
-
 static int __init ctnetlink_init(void)
 {
 	int ret;
@@ -3901,19 +3881,14 @@ static int __init ctnetlink_init(void)
 		goto err_unreg_subsys;
 	}
 
-	ret = register_pernet_subsys(&ctnetlink_net_ops);
-	if (ret < 0) {
-		pr_err("ctnetlink_init: cannot register pernet operations\n");
-		goto err_unreg_exp_subsys;
-	}
+	nf_conntrack_register_notifier(&ctnl_notifier);
+
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
 	/* setup interaction between nf_queue and nf_conntrack_netlink. */
 	RCU_INIT_POINTER(nfnl_ct_hook, &ctnetlink_glue_hook);
 #endif
 	return 0;
 
-err_unreg_exp_subsys:
-	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 err_unreg_subsys:
 	nfnetlink_subsys_unregister(&ctnl_subsys);
 err_out:
@@ -3922,7 +3897,9 @@ static int __init ctnetlink_init(void)
 
 static void __exit ctnetlink_exit(void)
 {
-	unregister_pernet_subsys(&ctnetlink_net_ops);
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	nf_conntrack_unregister_notifier();
+#endif
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 	nfnetlink_subsys_unregister(&ctnl_subsys);
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
-- 
2.34.1

