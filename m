From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: conntrack: de-inline nf_conntrack_eventmask_report
Date: Mon, 11 Apr 2016 21:52:35 +0200
Message-ID: <1460404356-29893-2-git-send-email-fw@strlen.de>
References: <1460404356-29893-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35553 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbcDKTwW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 15:52:22 -0400
In-Reply-To: <1460404356-29893-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Way too large; move it to nf_conntrack_ecache.c.
Reduces total object size by 1216 byte on my machine.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h | 66 ++++++-----------------------
 net/netfilter/nf_conntrack_ecache.c         | 54 +++++++++++++++++++++++
 2 files changed, 66 insertions(+), 54 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 57c8803..019a5b8 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -73,6 +73,8 @@ void nf_conntrack_unregister_notifier(struct net *net,
 				      struct nf_ct_event_notifier *nb);
 
 void nf_ct_deliver_cached_events(struct nf_conn *ct);
+int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
+				  u32 portid, int report);
 
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
@@ -91,69 +93,25 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 }
 
 static inline int
-nf_conntrack_eventmask_report(unsigned int eventmask,
-			      struct nf_conn *ct,
-			      u32 portid,
-			      int report)
-{
-	int ret = 0;
-	struct net *net = nf_ct_net(ct);
-	struct nf_ct_event_notifier *notify;
-	struct nf_conntrack_ecache *e;
-
-	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
-	if (notify == NULL)
-		goto out_unlock;
-
-	e = nf_ct_ecache_find(ct);
-	if (e == NULL)
-		goto out_unlock;
-
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
-		struct nf_ct_event item = {
-			.ct 	= ct,
-			.portid	= e->portid ? e->portid : portid,
-			.report = report
-		};
-		/* This is a resent of a destroy event? If so, skip missed */
-		unsigned long missed = e->portid ? 0 : e->missed;
-
-		if (!((eventmask | missed) & e->ctmask))
-			goto out_unlock;
-
-		ret = notify->fcn(eventmask | missed, &item);
-		if (unlikely(ret < 0 || missed)) {
-			spin_lock_bh(&ct->lock);
-			if (ret < 0) {
-				/* This is a destroy event that has been
-				 * triggered by a process, we store the PORTID
-				 * to include it in the retransmission. */
-				if (eventmask & (1 << IPCT_DESTROY) &&
-				    e->portid == 0 && portid != 0)
-					e->portid = portid;
-				else
-					e->missed |= eventmask;
-			} else
-				e->missed &= ~missed;
-			spin_unlock_bh(&ct->lock);
-		}
-	}
-out_unlock:
-	rcu_read_unlock();
-	return ret;
-}
-
-static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
+	const struct net *net = nf_ct_net(ct);
+
+	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
+		return 0;
+
 	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
 }
 
 static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+	const struct net *net = nf_ct_net(ct);
+
+	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
+		return 0;
+
 	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
 }
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 4e78c57..a0ebab9 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -113,6 +113,60 @@ static void ecache_work(struct work_struct *work)
 		schedule_delayed_work(&ctnet->ecache_dwork, delay);
 }
 
+int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
+				  u32 portid, int report)
+{
+	int ret = 0;
+	struct net *net = nf_ct_net(ct);
+	struct nf_ct_event_notifier *notify;
+	struct nf_conntrack_ecache *e;
+
+	rcu_read_lock();
+	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
+	if (!notify)
+		goto out_unlock;
+
+	e = nf_ct_ecache_find(ct);
+	if (!e)
+		goto out_unlock;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
+		struct nf_ct_event item = {
+			.ct	= ct,
+			.portid	= e->portid ? e->portid : portid,
+			.report = report
+		};
+		/* This is a resent of a destroy event? If so, skip missed */
+		unsigned long missed = e->portid ? 0 : e->missed;
+
+		if (!((eventmask | missed) & e->ctmask))
+			goto out_unlock;
+
+		ret = notify->fcn(eventmask | missed, &item);
+		if (unlikely(ret < 0 || missed)) {
+			spin_lock_bh(&ct->lock);
+			if (ret < 0) {
+				/* This is a destroy event that has been
+				 * triggered by a process, we store the PORTID
+				 * to include it in the retransmission.
+				 */
+				if (eventmask & (1 << IPCT_DESTROY) &&
+				    e->portid == 0 && portid != 0)
+					e->portid = portid;
+				else
+					e->missed |= eventmask;
+			} else {
+				e->missed &= ~missed;
+			}
+			spin_unlock_bh(&ct->lock);
+		}
+	}
+out_unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_eventmask_report);
+
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
-- 
2.7.3

