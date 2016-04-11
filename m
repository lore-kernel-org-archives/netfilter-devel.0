From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: conntrack: move expectation event helper to ecache.c
Date: Mon, 11 Apr 2016 21:52:36 +0200
Message-ID: <1460404356-29893-3-git-send-email-fw@strlen.de>
References: <1460404356-29893-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35555 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbcDKTwZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 15:52:25 -0400
In-Reply-To: <1460404356-29893-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not performance critical, it is only invoked when an expectation is
added/destroyed.

While at it, kill unused nf_ct_expect_event() wrapper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h | 42 +++--------------------------
 net/netfilter/nf_conntrack_ecache.c         | 30 +++++++++++++++++++++
 2 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 019a5b8..fa36447 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -130,43 +130,9 @@ int nf_ct_expect_register_notifier(struct net *net,
 void nf_ct_expect_unregister_notifier(struct net *net,
 				      struct nf_exp_event_notifier *nb);
 
-static inline void
-nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
-			  struct nf_conntrack_expect *exp,
-			  u32 portid,
-			  int report)
-{
-	struct net *net = nf_ct_exp_net(exp);
-	struct nf_exp_event_notifier *notify;
-	struct nf_conntrack_ecache *e;
-
-	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_expect_event_cb);
-	if (notify == NULL)
-		goto out_unlock;
-
-	e = nf_ct_ecache_find(exp->master);
-	if (e == NULL)
-		goto out_unlock;
-
-	if (e->expmask & (1 << event)) {
-		struct nf_exp_event item = {
-			.exp	= exp,
-			.portid	= portid,
-			.report = report
-		};
-		notify->fcn(1 << event, &item);
-	}
-out_unlock:
-	rcu_read_unlock();
-}
-
-static inline void
-nf_ct_expect_event(enum ip_conntrack_expect_events event,
-		   struct nf_conntrack_expect *exp)
-{
-	nf_ct_expect_event_report(event, exp, 0, 0);
-}
+void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
+			       struct nf_conntrack_expect *exp,
+			       u32 portid, int report);
 
 int nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
@@ -203,8 +169,6 @@ static inline int nf_conntrack_event_report(enum ip_conntrack_events event,
 					    u32 portid,
 					    int report) { return 0; }
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
-static inline void nf_ct_expect_event(enum ip_conntrack_expect_events event,
-				      struct nf_conntrack_expect *exp) {}
 static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
 					     struct nf_conntrack_expect *exp,
  					     u32 portid,
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index a0ebab9..d28011b 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -221,6 +221,36 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
+void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
+			       struct nf_conntrack_expect *exp,
+			       u32 portid, int report)
+
+{
+	struct net *net = nf_ct_exp_net(exp);
+	struct nf_exp_event_notifier *notify;
+	struct nf_conntrack_ecache *e;
+
+	rcu_read_lock();
+	notify = rcu_dereference(net->ct.nf_expect_event_cb);
+	if (!notify)
+		goto out_unlock;
+
+	e = nf_ct_ecache_find(exp->master);
+	if (!e)
+		goto out_unlock;
+
+	if (e->expmask & (1 << event)) {
+		struct nf_exp_event item = {
+			.exp	= exp,
+			.portid	= portid,
+			.report = report
+		};
+		notify->fcn(1 << event, &item);
+	}
+out_unlock:
+	rcu_read_unlock();
+}
+
 int nf_conntrack_register_notifier(struct net *net,
 				   struct nf_ct_event_notifier *new)
 {
-- 
2.7.3

