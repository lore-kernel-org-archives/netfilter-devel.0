From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] ctnetlink: optional packet drop to make event delivery
	reliable
Date: Tue, 24 Mar 2009 12:07:06 +0100
Message-ID: <20090324110706.13981.24167.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36885 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbZCXLHU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:07:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds reliable ctnetlink event delivery at the cost of
dropping packets or aborting a ctnetlink operation (returning
ENOBUFS to userspace). This behaviour is optional and it is set
if one broadcast listener has set the NETLINK_BROADCAST_ERROR
socket option. Thus, if the delivery fails, the packet is drop.

If the request comes from userspace, in case that the event
was not delivered, we return -ENOBUFS. This means that the change
has been applied but the event was not delivering. This error
is not that easy to trigger as netlink retries one more time if
the receiver buffer is full for request in user context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_core.h   |    7 ++-
 include/net/netfilter/nf_conntrack_ecache.h |   21 ++++++--
 net/netfilter/nf_conntrack_ecache.c         |   18 +++++--
 net/netfilter/nf_conntrack_expect.c         |    2 -
 net/netfilter/nf_conntrack_netlink.c        |   69 +++++++++++++++++----------
 5 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 5a449b4..98078b2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -62,8 +62,11 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
-		if (likely(ret == NF_ACCEPT))
-			nf_ct_deliver_cached_events(ct);
+		if (likely(ret == NF_ACCEPT) &&
+		    nf_ct_deliver_cached_events(ct) < 0) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
 	}
 	return ret;
 }
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0ff0dc6..e0d5157 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -28,7 +28,7 @@ extern struct atomic_notifier_head nf_conntrack_chain;
 extern int nf_conntrack_register_notifier(struct notifier_block *nb);
 extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
 
-extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
+extern int nf_ct_deliver_cached_events(const struct nf_conn *ct);
 extern void __nf_ct_event_cache_init(struct nf_conn *ct);
 extern void nf_ct_event_cache_flush(struct net *net);
 
@@ -46,7 +46,7 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	local_bh_enable();
 }
 
-static inline void
+static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event,
 			  struct nf_conn *ct,
 			  u32 pid,
@@ -57,8 +57,14 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 		.pid	= pid,
 		.report = report
 	};
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
+	int ret = 0;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
+		ret = atomic_notifier_call_chain(&nf_conntrack_chain, 
+						 event, &item);
+		ret = notifier_to_errno(ret);
+	}
+	return ret;
 }
 
 static inline void
@@ -77,7 +83,7 @@ extern struct atomic_notifier_head nf_ct_expect_chain;
 extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
 extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
 
-static inline void
+static inline int
 nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  struct nf_conntrack_expect *exp,
 			  u32 pid,
@@ -88,7 +94,10 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 		.pid	= pid,
 		.report = report
 	};
-	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	int ret;
+
+	ret = atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	return notifier_to_errno(ret);
 }
 
 static inline void
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index dee4190..9c21269 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -31,9 +31,11 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_chain);
 
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
-static inline void
+static inline int
 __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 {
+	int ret = 0;
+
 	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
 	    && ecache->events) {
 		struct nf_ct_event item = {
@@ -42,28 +44,32 @@ __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 			.report	= 0
 		};
 
-		atomic_notifier_call_chain(&nf_conntrack_chain,
-					   ecache->events,
-					   &item);
+		ret = atomic_notifier_call_chain(&nf_conntrack_chain,
+						 ecache->events,
+						 &item);
+		ret = notifier_to_errno(ret);
 	}
 
 	ecache->events = 0;
 	nf_ct_put(ecache->ct);
 	ecache->ct = NULL;
+	return ret;
 }
 
 /* Deliver all cached events for a particular conntrack. This is called
  * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(const struct nf_conn *ct)
+int nf_ct_deliver_cached_events(const struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *ecache;
+	int ret = 0;
 
 	local_bh_disable();
 	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
 	if (ecache->ct == ct)
-		__nf_ct_deliver_cached_events(ecache);
+		ret = __nf_ct_deliver_cached_events(ecache);
 	local_bh_enable();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 3a8a34a..91aa218 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -445,7 +445,7 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 out:
 	spin_unlock_bh(&nf_conntrack_lock);
 	if (ret == 0)
-		nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
+		ret = nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3c49d62..b23917b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -416,6 +416,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	unsigned int type;
 	sk_buff_data_t b;
 	unsigned int flags = 0, group;
+	int err;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -512,13 +513,16 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, item->pid, group, item->report);
+	err = nfnetlink_send(skb, item->pid, group, item->report);
+	if ((err == -ENOBUFS) || (err == -EAGAIN))
+		return notifier_from_errno(-ENOBUFS);
+
 	return NOTIFY_DONE;
 
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
-	nfnetlink_set_err(0, group, -ENOBUFS);
+	nfnetlink_set_err(item->pid, group, -ENOBUFS);
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }
@@ -747,10 +751,13 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	nf_conntrack_event_report(IPCT_DESTROY,
-				  ct,
-				  NETLINK_CB(skb).pid,
-				  nlmsg_report(nlh));
+	if (nf_conntrack_event_report(IPCT_DESTROY,
+				      ct,
+				      NETLINK_CB(skb).pid,
+				      nlmsg_report(nlh)) < 0) {
+		nf_ct_put(ct);
+		return -ENOBUFS;
+	}
 
 	/* death_by_timeout would report the event again */
 	set_bit(IPS_DYING_BIT, &ct->status);
@@ -1107,7 +1114,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 	return 0;
 }
 
-static inline void
+static inline int
 ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 {
 	unsigned int events = 0;
@@ -1117,16 +1124,16 @@ ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 	else
 		events |= IPCT_NEW;
 
-	nf_conntrack_event_report(IPCT_STATUS |
-				  IPCT_HELPER |
-				  IPCT_REFRESH |
-				  IPCT_PROTOINFO |
-				  IPCT_NATSEQADJ |
-				  IPCT_MARK |
-				  events,
-				  ct,
-				  pid,
-				  report);
+	return nf_conntrack_event_report(IPCT_STATUS |
+					 IPCT_HELPER |
+					 IPCT_REFRESH |
+					 IPCT_PROTOINFO |
+					 IPCT_NATSEQADJ |
+					 IPCT_MARK |
+					 events,
+					 ct,
+					 pid,
+					 report);
 }
 
 static struct nf_conn *
@@ -1316,9 +1323,12 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = 0;
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				nf_ct_put(ct);
+				return -ENOBUFS;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1337,9 +1347,12 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				nf_ct_put(ct);
+				return -ENOBUFS;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1493,7 +1506,7 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
-	int flags = 0;
+	int flags = 0, err;
 
 	if (events & IPEXP_NEW) {
 		type = IPCTNL_MSG_EXP_NEW;
@@ -1526,13 +1539,17 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW, item->report);
+	err = nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW,
+			     item->report);
+	if ((err == -ENOBUFS) || (err == -EAGAIN))
+		return notifier_from_errno(-ENOBUFS);
+
 	return NOTIFY_DONE;
 
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
-	nfnetlink_set_err(0, 0, -ENOBUFS);
+	nfnetlink_set_err(item->pid, 0, -ENOBUFS);
 	kfree_skb(skb);
 	return NOTIFY_DONE;
 }

