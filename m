From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] ctnetlink: optional reliable event delivery
Date: Fri, 27 Mar 2009 10:40:31 +0100
Message-ID: <20090327094031.8259.81782.stgit@Decadence>
References: <20090327093822.8259.50902.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42611 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbZC0Jkp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:40:45 -0400
In-Reply-To: <20090327093822.8259.50902.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch improves ctnetlink event reliability if one broadcast
listener has set the NETLINK_BROADCAST_ERROR socket option.

The logic is the following: if the event delivery fails, ctnetlink
sets IPCT_DELIVERY_FAILED event bit and keep the undelivered
events in the conntrack event cache. Thus, once the next packet
arrives, we trigger another event delivery in nf_conntrack_in(). If
things don't go well in this second try, we accumulate the pending
events in the cache but we try to deliver the current state as soon
as possible. Therefore, we may lost state transitions but the
userspace process gets in sync at some point.

At worst case, if no events were delivered to userspace, we make
sure that destroy events are successfully delivered. This happens
because if ctnetlink fails to deliver the destroy event, we re-add
the conntrack timer with an extra grace timeout of 15 seconds to
trigger the event again (this grace timeout is tunable via /proc).

If a packet closing the flow (like a TCP RST) kills the conntrack
entry but the event delivery fails, we drop the packet and keep
the entry in the kernel. This is the only case in which we may drop
a packets.

For expectations, the logic is more simple, if the event delivery
fails, we drop the packet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_core.h   |    6 +-
 include/net/netfilter/nf_conntrack_ecache.h |   37 +++++++++----
 include/net/netns/conntrack.h               |    1 
 net/netfilter/nf_conntrack_core.c           |   31 +++++++----
 net/netfilter/nf_conntrack_ecache.c         |   29 +++++++++-
 net/netfilter/nf_conntrack_expect.c         |   12 +++-
 net/netfilter/nf_conntrack_netlink.c        |   76 ++++++++++++++++++---------
 net/netfilter/nf_conntrack_pptp.c           |   25 ++++++---
 net/netfilter/nf_conntrack_proto_dccp.c     |    5 +-
 net/netfilter/nf_conntrack_proto_tcp.c      |    5 +-
 10 files changed, 157 insertions(+), 70 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 5a449b4..1be51ba 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -62,8 +62,10 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
-		if (likely(ret == NF_ACCEPT))
-			nf_ct_deliver_cached_events(ct);
+		if (unlikely(ret == NF_DROP))
+			return NF_DROP;
+		if (unlikely(nf_ct_deliver_cached_events(ct) < 0))
+			nf_conntrack_event_cache(IPCT_DELIVERY_FAILED, ct);
 	}
 	return ret;
 }
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 89cf298..2e86eac 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -74,6 +74,10 @@ enum ip_conntrack_events
 	/* Secmark is set */
 	IPCT_SECMARK_BIT = 14,
 	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+
+	/* An event delivery has failed */
+	IPCT_DELIVERY_FAILED_BIT = 31,
+	IPCT_DELIVERY_FAILED = (1 << IPCT_DELIVERY_FAILED_BIT),
 };
 
 enum ip_conntrack_expect_events {
@@ -114,7 +118,7 @@ extern struct atomic_notifier_head nf_conntrack_chain;
 extern int nf_conntrack_register_notifier(struct notifier_block *nb);
 extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
 
-extern void nf_ct_deliver_cached_events(struct nf_conn *ct);
+extern int nf_ct_deliver_cached_events(struct nf_conn *ct);
 
 static inline void
 __nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
@@ -138,7 +142,7 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	spin_unlock_bh(&nf_conntrack_lock);
 }
 
-static inline void
+static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event,
 			  struct nf_conn *ct,
 			  u32 pid,
@@ -150,18 +154,23 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 		.report = report
 	};
 	struct net *net = nf_ct_net(ct);
+	int ret = 0;
 
 	if (!net->ct.sysctl_events)
-		return;
-
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
+		return 0;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
+		ret = atomic_notifier_call_chain(&nf_conntrack_chain,
+						 event, &item);
+		ret = notifier_to_errno(ret);
+	}
+	return ret;
 }
 
-static inline void
+static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
-	nf_conntrack_event_report(event, ct, 0, 0);
+	return nf_conntrack_event_report(event, ct, 0, 0);
 }
 
 struct nf_exp_event {
@@ -174,7 +183,7 @@ extern struct atomic_notifier_head nf_ct_expect_chain;
 extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
 extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
 
-static inline void
+static inline int
 nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  struct nf_conntrack_expect *exp,
 			  u32 pid,
@@ -186,18 +195,20 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 		.report = report
 	};
 	struct net *net = nf_ct_exp_net(exp);
+	int ret;
 
 	if (!net->ct.sysctl_events)
-		return;
+		return 0;
 
-	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	ret = atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	return notifier_to_errno(ret);
 }
 
-static inline void
+static inline int
 nf_ct_expect_event(enum ip_conntrack_expect_events event,
 		   struct nf_conntrack_expect *exp)
 {
-	nf_ct_expect_event_report(event, exp, 0, 0);
+	return nf_ct_expect_event_report(event, exp, 0, 0);
 }
 
 extern int nf_conntrack_ecache_init(struct net *net);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 69dd322..4e7fb0c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -15,6 +15,7 @@ struct netns_ct {
 	struct hlist_head	unconfirmed;
 	struct ip_conntrack_stat *stat;
 	int			sysctl_events;
+	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d5cae75..1f0fcc0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -181,10 +181,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
-	if (!test_bit(IPS_DYING_BIT, &ct->status))
-		nf_conntrack_event(IPCT_DESTROY, ct);
-	set_bit(IPS_DYING_BIT, &ct->status);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -218,13 +214,23 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	nf_conntrack_free(ct);
 }
 
-static void death_by_timeout(unsigned long ul_conntrack)
+static bool kill_conntrack(struct nf_conn *ct)
 {
-	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_helper *helper;
 
+	if (!test_bit(IPS_DYING_BIT, &ct->status) && 
+	    nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
+		/* event was not deliverd, retry again later */
+		ct->timeout.expires =
+			jiffies + net->ct.sysctl_events_retry_timeout;
+		add_timer(&ct->timeout);
+		/* ... say sorry, we failed to delete the entry */
+		return false;
+	}
+	set_bit(IPS_DYING_BIT, &ct->status);
+
 	if (help) {
 		rcu_read_lock();
 		helper = rcu_dereference(help->helper);
@@ -240,6 +246,12 @@ static void death_by_timeout(unsigned long ul_conntrack)
 	clean_from_lists(ct);
 	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_put(ct);
+	return true;
+}
+
+static void death_by_timeout(unsigned long ul_conntrack)
+{
+	kill_conntrack((struct nf_conn *)(void *)ul_conntrack);
 }
 
 struct nf_conntrack_tuple_hash *
@@ -854,10 +866,9 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 		spin_unlock_bh(&nf_conntrack_lock);
 	}
 
-	if (del_timer(&ct->timeout)) {
-		ct->timeout.function((unsigned long)ct);
-		return true;
-	}
+	if (del_timer(&ct->timeout))
+		return kill_conntrack(ct);
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 7522ea0..c483ba6 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -32,13 +32,14 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_chain);
 
 /* Deliver all cached events for a particular conntrack. This is called
  * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(struct nf_conn *ct)
+int nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
 	struct nf_conntrack_ecache *e;
+	int ret = 0, delivered = 0;
 
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
-		return;
+		return 0;
 
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct) && e->cache) {
 		struct nf_ct_event item = {
@@ -46,9 +47,16 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 			.pid	= 0,
 			.report	= 0
 		};
-		atomic_notifier_call_chain(&nf_conntrack_chain, e->cache,&item);
+		ret = atomic_notifier_call_chain(&nf_conntrack_chain,
+						 e->cache,&item);
+		ret = notifier_to_errno(ret);
+		if (ret == 0)
+			delivered = 1;
 	}
-	xchg(&e->cache, 0);
+	if (delivered)
+		xchg(&e->cache, 0);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
@@ -83,9 +91,12 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 #endif
 
 static int nf_ct_events_switch __read_mostly = NF_CT_EVENTS_DEFAULT;
+static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 module_param_named(event, nf_ct_events_switch, bool, 0644);
 MODULE_PARM_DESC(event, "Enable connection tracking event delivery");
+module_param_named(retry_timeout, nf_ct_events_retry_timeout, bool, 0644);
+MODULE_PARM_DESC(retry_timeout, "Event delivery retry timeout");
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -97,6 +108,14 @@ static struct ctl_table event_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nf_conntrack_events_retry_timeout",
+		.data		= &init_net.ct.sysctl_events_retry_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 	{}
 };
 #endif /* CONFIG_SYSCTL */
@@ -118,6 +137,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
+	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	net->ct.event_sysctl_header =
 		register_net_sysctl_table(net,
@@ -158,6 +178,7 @@ int nf_conntrack_ecache_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_events = nf_ct_events_switch;
+	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
 
 	if (net_eq(net, &init_net)) {
 		ret = nf_ct_extend_register(&event_extend);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 3a8a34a..e653e15 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -423,7 +423,10 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	nf_ct_expect_insert(expect);
 	atomic_inc(&expect->use);
 	spin_unlock_bh(&nf_conntrack_lock);
-	nf_ct_expect_event(IPEXP_NEW, expect);
+	ret = nf_ct_expect_event(IPEXP_NEW, expect);
+	if (ret < 0)
+		nf_ct_unexpect_related(expect);
+
 	nf_ct_expect_put(expect);
 	return ret;
 out:
@@ -444,8 +447,11 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	nf_ct_expect_insert(expect);
 out:
 	spin_unlock_bh(&nf_conntrack_lock);
-	if (ret == 0)
-		nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
+	if (ret == 0) {
+		ret = nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
+		if (ret < 0)
+			nf_ct_unexpect_related(expect);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cdc09bd..971d0aa 100644
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
@@ -716,6 +720,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int8_t u3 = nfmsg->nfgen_family;
+	struct net *net = nf_ct_net(ct);
 	int err = 0;
 
 	if (cda[CTA_TUPLE_ORIG])
@@ -747,10 +752,18 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	nf_conntrack_event_report(IPCT_DESTROY,
-				  ct,
-				  NETLINK_CB(skb).pid,
-				  nlmsg_report(nlh));
+	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
+				      NETLINK_CB(skb).pid,
+				      nlmsg_report(nlh)) < 0) {
+		/* we failed to report the event, shorten the timeout */
+		if (del_timer(&ct->timeout)) {
+			ct->timeout.expires =
+				jiffies + net->ct.sysctl_events_retry_timeout;
+			add_timer(&ct->timeout);
+		}
+		nf_ct_put(ct);
+		return -ENOBUFS;
+	}
 
 	/* death_by_timeout would report the event again */
 	set_bit(IPS_DYING_BIT, &ct->status);
@@ -1107,7 +1120,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 	return 0;
 }
 
-static inline void
+static inline int
 ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 {
 	unsigned int events = 0;
@@ -1117,16 +1130,13 @@ ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
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
+					 events, ct, pid, report);
 }
 
 static struct nf_conn *
@@ -1317,9 +1327,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = 0;
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				nf_conntrack_event_cache(IPCT_DELIVERY_FAILED,
+							 ct);
+				nf_ct_put(ct);
+				return -ENOBUFS;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1338,9 +1353,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				nf_conntrack_event_cache(IPCT_DELIVERY_FAILED,
+							 ct);
+				nf_ct_put(ct);
+				return -ENOBUFS;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1494,7 +1514,7 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
-	int flags = 0;
+	int flags = 0, err;
 
 	if (events & IPEXP_NEW) {
 		type = IPCTNL_MSG_EXP_NEW;
@@ -1527,13 +1547,17 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW, item->report);
+	err = nfnetlink_send(skb, item->pid,
+			     NFNLGRP_CONNTRACK_EXP_NEW, item->report);
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
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 5ca1780..c67299b 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -152,9 +152,11 @@ static int destroy_sibling_or_exp(struct net *net,
 		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
 		sibling->proto.gre.timeout	  = 0;
 		sibling->proto.gre.stream_timeout = 0;
-		nf_ct_kill(sibling);
-		nf_ct_put(sibling);
-		return 1;
+		if (nf_ct_kill(sibling)) {
+			nf_ct_put(sibling);
+			return 1;
+		}
+		return 0;
 	} else {
 		exp = nf_ct_expect_find_get(net, t);
 		if (exp) {
@@ -168,11 +170,12 @@ static int destroy_sibling_or_exp(struct net *net,
 }
 
 /* timeout GRE data connections */
-static void pptp_destroy_siblings(struct nf_conn *ct)
+static bool pptp_destroy_siblings(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	const struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_tuple t;
+	bool ret = true;
 
 	nf_ct_gre_keymap_destroy(ct);
 
@@ -181,16 +184,21 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
-	if (!destroy_sibling_or_exp(net, &t))
+	if (!destroy_sibling_or_exp(net, &t)) {
 		pr_debug("failed to timeout original pns->pac ct/exp\n");
+		ret = false;
+	}
 
 	/* try reply (pac->pns) tuple */
 	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
-	if (!destroy_sibling_or_exp(net, &t))
+	if (!destroy_sibling_or_exp(net, &t)) {
 		pr_debug("failed to timeout reply pac->pns ct/exp\n");
+		ret = false;
+	}
+	return ret;
 }
 
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
@@ -357,7 +365,8 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
-		pptp_destroy_siblings(ct);
+		if (!pptp_destroy_siblings(ct))
+			return NF_DROP;
 		break;
 
 	case PPTP_WAN_ERROR_NOTIFY:
@@ -593,7 +602,7 @@ static struct nf_conntrack_helper pptp __read_mostly = {
 	.tuple.src.u.tcp.port	= cpu_to_be16(PPTP_CONTROL_PORT),
 	.tuple.dst.protonum	= IPPROTO_TCP,
 	.help			= conntrack_pptp_help,
-	.destroy		= pptp_destroy_siblings,
+	.destroy		= &pptp_destroy_siblings,
 	.expect_policy		= &pptp_exp_policy,
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 8fcf176..c2c4b28 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -477,8 +477,9 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	if (type == DCCP_PKT_RESET &&
 	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* Tear down connection immediately if only reply is a RESET */
-		nf_ct_kill_acct(ct, ctinfo, skb);
-		return NF_ACCEPT;
+		if (nf_ct_kill_acct(ct, ctinfo, skb))
+			return NF_ACCEPT;
+		return NF_DROP;
 	}
 
 	write_lock_bh(&dccp_lock);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 78bce2a..d272432 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -982,8 +982,9 @@ static int tcp_packet(struct nf_conn *ct,
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			nf_ct_kill_acct(ct, ctinfo, skb);
-			return NF_ACCEPT;
+			if (nf_ct_kill_acct(ct, ctinfo, skb))
+				return NF_ACCEPT;
+			return NF_DROP;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV

