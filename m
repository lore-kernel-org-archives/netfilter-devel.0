From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 15 Nov 2011 10:56:42 +0100
Message-ID: <20111115095642.GA28944@1984>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Cc: alex@alex.org.uk, kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43842 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab1KOJ4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:56:47 -0500
Content-Disposition: inline
In-Reply-To: <20111109143423.GA24158@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 09, 2011 at 03:34:23PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 09, 2011 at 01:16:35AM +0300, Alexey Dobriyan wrote:
> > Sorry for delay.
> > 
> > I recall myself writing that net->nfnl NULL check is racy or
> > something like that (but I can't find this email in archives).
> > 
> > I've read the code once again, and I'm quite sure,
> > NULL ->nfnl check is correct if RCU precautions are made.
> > 
> > Regarding ->report check, I think it's bogus.
> > 
> > If there are no listeners, there are NO listeners
> > and whether to report back to userspace doesn't matter.
> > 
> > I'm sure I'm missing something obvious here.
> > 
> > Please, review.
> 
> Alexey. This is a workaround. We have to make ctnl_notifier
> container-aware which is the real problem.

I made this patch. It makes the ctnl_notifier container-aware.

I'm trying to set some lxc container to test it (it's not that
straight forward in debian).

btw: if it's fine, i'll add the credits (reported-by and other tags
before final submission, this is still a RFC).

--oyUTqETQ0mS9luUI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ct.patch"

netfilter: make ctnetlink event callback registration netns aware

From: Pablo Neira Ayuso <pablo@netfilter.org>

This fixes an oops with the following recipe:

1) container is created.
2) nf_conntrack_netlink is enabled and there are some entries in the
   conntrack table.
3) one container is destroyed, oops because the conntrack table cleanup
   tries to report the destroy event to user-space but the nfnetlink
   socket has already gone (as the nfnetlink socket is net_namespace-aware).

To fix this situation, we make the ctnl_notifier netns aware so the
callback is registered/unregistered if the container is
created/destroyed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |   19 ++++---
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_ecache.c         |   37 +++++++-------
 net/netfilter/nf_conntrack_netlink.c        |   73 +++++++++++++++++++--------
 4 files changed, 82 insertions(+), 49 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 4283508..a88fb69 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -67,18 +67,18 @@ struct nf_ct_event_notifier {
 	int (*fcn)(unsigned int events, struct nf_ct_event *item);
 };
 
-extern struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
-extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier *nb);
-extern void nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *nb);
+extern int nf_conntrack_register_notifier(struct net *net, struct nf_ct_event_notifier *nb);
+extern void nf_conntrack_unregister_notifier(struct net *net, struct nf_ct_event_notifier *nb);
 
 extern void nf_ct_deliver_cached_events(struct nf_conn *ct);
 
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
-	if (nf_conntrack_event_cb == NULL)
+	if (net->ct.nf_conntrack_event_cb == NULL)
 		return;
 
 	e = nf_ct_ecache_find(ct);
@@ -95,11 +95,12 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 			      int report)
 {
 	int ret = 0;
+	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
-	notify = rcu_dereference(nf_conntrack_event_cb);
+	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (notify == NULL)
 		goto out_unlock;
 
@@ -164,9 +165,8 @@ struct nf_exp_event_notifier {
 	int (*fcn)(unsigned int events, struct nf_exp_event *item);
 };
 
-extern struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
-extern int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *nb);
-extern void nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *nb);
+extern int nf_ct_expect_register_notifier(struct net *net, struct nf_exp_event_notifier *nb);
+extern void nf_ct_expect_unregister_notifier(struct net *net, struct nf_exp_event_notifier *nb);
 
 static inline void
 nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
@@ -174,11 +174,12 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  u32 pid,
 			  int report)
 {
+	struct net *net = nf_ct_exp_net(exp);
 	struct nf_exp_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
-	notify = rcu_dereference(nf_expect_event_cb);
+	notify = rcu_dereference(net->ct.nf_expect_event_cb);
 	if (notify == NULL)
 		goto out_unlock;
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 0249399..7a911ec 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -18,6 +18,8 @@ struct netns_ct {
 	struct hlist_nulls_head	unconfirmed;
 	struct hlist_nulls_head	dying;
 	struct ip_conntrack_stat __percpu *stat;
+	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
+	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	int			sysctl_events;
 	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 3add994..362b3fa 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -26,22 +26,17 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
-struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_event_cb);
-
-struct nf_exp_event_notifier __rcu *nf_expect_event_cb __read_mostly;
-EXPORT_SYMBOL_GPL(nf_expect_event_cb);
-
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
+	struct net *net = nf_ct_net(ct);
 	unsigned long events;
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
-	notify = rcu_dereference(nf_conntrack_event_cb);
+	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (notify == NULL)
 		goto out_unlock;
 
@@ -82,19 +77,20 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
-int nf_conntrack_register_notifier(struct nf_ct_event_notifier *new)
+int nf_conntrack_register_notifier(struct net *net,
+				   struct nf_ct_event_notifier *new)
 {
 	int ret = 0;
 	struct nf_ct_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(nf_conntrack_event_cb,
+	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	if (notify != NULL) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	RCU_INIT_POINTER(nf_conntrack_event_cb, new);
+	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, new);
 	mutex_unlock(&nf_ct_ecache_mutex);
 	return ret;
 
@@ -104,32 +100,34 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-void nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *new)
+void nf_conntrack_unregister_notifier(struct net *net,
+				      struct nf_ct_event_notifier *new)
 {
 	struct nf_ct_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(nf_conntrack_event_cb,
+	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	BUG_ON(notify != new);
-	RCU_INIT_POINTER(nf_conntrack_event_cb, NULL);
+	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
-int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *new)
+int nf_ct_expect_register_notifier(struct net *net,
+				   struct nf_exp_event_notifier *new)
 {
 	int ret = 0;
 	struct nf_exp_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(nf_expect_event_cb,
+	notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	if (notify != NULL) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	RCU_INIT_POINTER(nf_expect_event_cb, new);
+	RCU_INIT_POINTER(net->ct.nf_expect_event_cb, new);
 	mutex_unlock(&nf_ct_ecache_mutex);
 	return ret;
 
@@ -139,15 +137,16 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
-void nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
+void nf_ct_expect_unregister_notifier(struct net *net,
+				      struct nf_exp_event_notifier *new)
 {
 	struct nf_exp_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(nf_expect_event_cb,
+	notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	BUG_ON(notify != new);
-	RCU_INIT_POINTER(nf_expect_event_cb, NULL);
+	RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e58aa9b..ef21b22 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2011 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -2163,6 +2163,54 @@ MODULE_ALIAS("ip_conntrack_netlink");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
+static int __net_init ctnetlink_net_init(struct net *net)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	int ret;
+
+	ret = nf_conntrack_register_notifier(net, &ctnl_notifier);
+	if (ret < 0) {
+		pr_err("ctnetlink_init: cannot register notifier.\n");
+		goto err_out;
+	}
+
+	ret = nf_ct_expect_register_notifier(net, &ctnl_notifier_exp);
+	if (ret < 0) {
+		pr_err("ctnetlink_init: cannot expect register notifier.\n");
+		goto err_unreg_notifier;
+	}
+#endif
+	return 0;
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+err_unreg_notifier:
+	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
+err_out:
+	return ret;
+#endif
+}
+
+static void ctnetlink_net_exit(struct net *net)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	nf_ct_expect_unregister_notifier(net, &ctnl_notifier_exp);
+	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
+#endif
+}
+
+static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list)
+		ctnetlink_net_exit(net);
+}
+
+static struct pernet_operations ctnetlink_net_ops = {
+	.init		= ctnetlink_net_init,
+	.exit_batch	= ctnetlink_net_exit_batch,
+};
+
 static int __init ctnetlink_init(void)
 {
 	int ret;
@@ -2180,28 +2228,15 @@ static int __init ctnetlink_init(void)
 		goto err_unreg_subsys;
 	}
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	ret = nf_conntrack_register_notifier(&ctnl_notifier);
-	if (ret < 0) {
-		pr_err("ctnetlink_init: cannot register notifier.\n");
+	if (register_pernet_subsys(&ctnetlink_net_ops)) {
+		pr_err("ctnetlink_init: cannot register pernet operations\n");
 		goto err_unreg_exp_subsys;
 	}
 
-	ret = nf_ct_expect_register_notifier(&ctnl_notifier_exp);
-	if (ret < 0) {
-		pr_err("ctnetlink_init: cannot expect register notifier.\n");
-		goto err_unreg_notifier;
-	}
-#endif
-
 	return 0;
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-err_unreg_notifier:
-	nf_conntrack_unregister_notifier(&ctnl_notifier);
 err_unreg_exp_subsys:
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
-#endif
 err_unreg_subsys:
 	nfnetlink_subsys_unregister(&ctnl_subsys);
 err_out:
@@ -2213,11 +2248,7 @@ static void __exit ctnetlink_exit(void)
 	pr_info("ctnetlink: unregistering from nfnetlink.\n");
 
 	nf_ct_remove_userspace_expectations();
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_ct_expect_unregister_notifier(&ctnl_notifier_exp);
-	nf_conntrack_unregister_notifier(&ctnl_notifier);
-#endif
-
+	unregister_pernet_subsys(&ctnetlink_net_ops);
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 	nfnetlink_subsys_unregister(&ctnl_subsys);
 }

--oyUTqETQ0mS9luUI--
