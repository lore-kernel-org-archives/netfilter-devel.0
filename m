From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/7] deliver events for conntracks created via ctnetlink
Date: Wed, 30 Jul 2008 13:47:12 +0200
Message-ID: <489054C0.6080502@netfilter.org>
References: <48904AEE.2000009@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080705010901000607080803"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57600 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752918AbYG3LrY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:47:24 -0400
In-Reply-To: <48904AEE.2000009@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080705010901000607080803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Index: net-next-2.6.git/include/net/netfilter/nf_conntrack.h
> ===================================================================
> --- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2008-07-30 11:11:11.000000000 +0200
> +++ net-next-2.6.git/include/net/netfilter/nf_conntrack.h	2008-07-30 11:20:03.000000000 +0200
> @@ -192,7 +192,7 @@ __nf_conntrack_find(const struct nf_conn
>  
>  extern void nf_conntrack_hash_insert(struct nf_conn *ct);
>  
> -extern void nf_conntrack_flush(void);
> +extern void nf_conntrack_flush(u32 pid, bool report);
>  
>  extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
>  			      unsigned int nhoff, u_int16_t l3num,

I just noticed a minor inconsistency in the report var type, sorry. Now
it is consistent. Patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080705010901000607080803
Content-Type: text/x-diff;
 name="05.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.patch"

[PATCH] deliver events for conntracks created via ctnetlink

As for now, the creation and update of conntracks via ctnetlink do not
propagate an event to userspace. This can result in inconsistent situations
if several userspace processes modify the connection tracking table by means
of ctnetlink at the same time. Specifically, using the conntrack command
line tool and conntrackd at the same time can trigger unconsistencies. 

This patch also modifies the event cache infrastructure to pass the
process PID and the ECHO flag to nfnetlink_send() if the change is 
triggered from userspace as Patrick McHardy suggested.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-30 13:33:13.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-30 13:43:38.000000000 +0200
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -407,7 +408,8 @@ static int ctnetlink_conntrack_event(str
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	struct nf_conn *ct = (struct nf_conn *)ptr;
+	struct nf_ct_event *item = (struct nf_ct_event *)ptr;
+	struct nf_conn *ct = item->ct;
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
@@ -440,7 +442,7 @@ static int ctnetlink_conntrack_event(str
 	b = skb->tail;
 
 	type |= NFNL_SUBSYS_CTNETLINK << 8;
-	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
+	nlh   = NLMSG_PUT(skb, item->pid, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = flags;
@@ -513,7 +515,7 @@ static int ctnetlink_conntrack_event(str
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, 0, group, 0);
+	nfnetlink_send(skb, item->pid, group, item->report);
 	return NOTIFY_DONE;
 
 nla_put_failure:
@@ -785,7 +787,7 @@ ctnetlink_del_conntrack(struct sock *ctn
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY, u3);
 	else {
 		/* Flush the whole table */
-		nf_conntrack_flush();
+		nf_conntrack_flush(NETLINK_CB(skb).pid, nlmsg_report(nlh));
 		return 0;
 	}
 
@@ -806,6 +808,14 @@ ctnetlink_del_conntrack(struct sock *ctn
 		}
 	}
 
+	nf_conntrack_event_report(IPCT_DESTROY,
+				  ct,
+				  NETLINK_CB(skb).pid,
+				  nlmsg_report(nlh));
+
+	/* do not report the deletion twice */
+	set_bit(IPS_DYING_BIT, &ct->status);
+
 	nf_ct_kill(ct);
 	nf_ct_put(ct);
 
@@ -1112,11 +1122,35 @@ ctnetlink_change_conntrack(struct nf_con
 	return 0;
 }
 
+static inline void
+ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
+{
+	unsigned int events = 0;
+
+	if (test_bit(IPS_EXPECTED_BIT, &ct->status))
+		events |= IPCT_RELATED;
+	else
+		events |= IPCT_NEW;
+
+	nf_conntrack_event_report(IPCT_STATUS |
+				  IPCT_HELPER |
+				  IPCT_REFRESH |
+				  IPCT_PROTOINFO |
+				  IPCT_NATSEQADJ |
+				  IPCT_MARK |
+				  events,
+				  ct,
+				  pid,
+				  report);
+}
+
 static int
 ctnetlink_create_conntrack(struct nlattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
 			   struct nf_conntrack_tuple *rtuple,
-			   struct nf_conn *master_ct)
+			   struct nf_conn *master_ct,
+			   u32 pid,
+			   int report)
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
@@ -1162,9 +1196,12 @@ ctnetlink_create_conntrack(struct nlattr
 		ct->master = master_ct;
 	}
 
+	nf_conntrack_get(&ct->ct_general);
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 	rcu_read_unlock();
+	ctnetlink_event_report(ct, pid, report);
+	nf_ct_put(ct);
 
 	return 0;
 
@@ -1229,7 +1266,9 @@ ctnetlink_new_conntrack(struct sock *ctn
 			err = ctnetlink_create_conntrack(cda,
 							 &otuple,
 							 &rtuple,
-							 master_ct);
+							 master_ct,
+							 NETLINK_CB(skb).pid,
+							 nlmsg_report(nlh));
 		if (err < 0 && master_ct)
 			nf_ct_put(master_ct);
 
@@ -1241,6 +1280,8 @@ ctnetlink_new_conntrack(struct sock *ctn
 	 * so there's no need to increase the refcount */
 	err = -EEXIST;
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
 		/* we only allow nat config for new conntracks */
 		if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
 			err = -EOPNOTSUPP;
@@ -1251,8 +1292,19 @@ ctnetlink_new_conntrack(struct sock *ctn
 			err = -EOPNOTSUPP;
 			goto out_unlock;
 		}
-		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
-						 cda);
+
+		err = ctnetlink_change_conntrack(ct, cda);
+		if (err == 0) {
+			nf_conntrack_get(&ct->ct_general);
+			spin_unlock_bh(&nf_conntrack_lock);
+			ctnetlink_event_report(ct,
+					       NETLINK_CB(skb).pid,
+					       nlmsg_report(nlh));
+			nf_ct_put(ct);
+		} else
+			spin_unlock_bh(&nf_conntrack_lock);
+
+		return err;
 	}
 
 out_unlock:
@@ -1387,7 +1439,8 @@ static int ctnetlink_expect_event(struct
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct nf_conntrack_expect *exp = (struct nf_conntrack_expect *)ptr;
+	struct nf_exp_event *item = (struct nf_exp_event *)ptr;
+	struct nf_conntrack_expect *exp = item->exp;
 	struct sk_buff *skb;
 	unsigned int type;
 	sk_buff_data_t b;
@@ -1409,7 +1462,7 @@ static int ctnetlink_expect_event(struct
 	b = skb->tail;
 
 	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
-	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
+	nlh   = NLMSG_PUT(skb, item->pid, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 
 	nlh->nlmsg_flags    = flags;
@@ -1423,7 +1476,7 @@ static int ctnetlink_expect_event(struct
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, 0, NFNLGRP_CONNTRACK_EXP_NEW, 0);
+	nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW, item->report);
 	return NOTIFY_DONE;
 
 nla_put_failure:
@@ -1636,7 +1689,7 @@ ctnetlink_change_expect(struct nf_conntr
 }
 
 static int
-ctnetlink_create_expect(struct nlattr *cda[], u_int8_t u3)
+ctnetlink_create_expect(struct nlattr *cda[], u_int8_t u3, u32 pid, int report)
 {
 	struct nf_conntrack_tuple tuple, mask, master_tuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
@@ -1698,7 +1751,9 @@ ctnetlink_create_expect(struct nlattr *c
 	memcpy(&exp->mask.src.u3, &mask.src.u3, sizeof(exp->mask.src.u3));
 	exp->mask.src.u.all = mask.src.u.all;
 
-	err = nf_ct_expect_related(exp);
+	err = nf_ct_expect_related_user(exp);
+	if (err == 0)
+		nf_ct_expect_event_report(IPEXP_NEW, exp, pid, report);
 	nf_ct_expect_put(exp);
 
 out:
@@ -1731,8 +1786,12 @@ ctnetlink_new_expect(struct sock *ctnl, 
 	if (!exp) {
 		spin_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
-		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_expect(cda, u3);
+		if (nlh->nlmsg_flags & NLM_F_CREATE) {
+			err = ctnetlink_create_expect(cda,
+						      u3,
+						      NETLINK_CB(skb).pid,
+						      nlmsg_report(nlh));
+		}
 		return err;
 	}
 
Index: net-next-2.6.git/include/net/netfilter/nf_conntrack_ecache.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack_ecache.h	2008-07-30 13:30:55.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack_ecache.h	2008-07-30 13:34:40.000000000 +0200
@@ -19,6 +19,13 @@ DECLARE_PER_CPU(struct nf_conntrack_ecac
 
 #define CONNTRACK_ECACHE(x)	(__get_cpu_var(nf_conntrack_ecache).x)
 
+/* This structure is passed to event handler */
+struct nf_ct_event {
+	struct nf_conn *ct;
+	u32 pid;
+	int report;
+};
+
 extern struct atomic_notifier_head nf_conntrack_chain;
 extern int nf_conntrack_register_notifier(struct notifier_block *nb);
 extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
@@ -42,22 +49,58 @@ nf_conntrack_event_cache(enum ip_conntra
 	local_bh_enable();
 }
 
-static inline void nf_conntrack_event(enum ip_conntrack_events event,
-				      struct nf_conn *ct)
+static inline void
+nf_conntrack_event_report(enum ip_conntrack_events event,
+			  struct nf_conn *ct,
+			  u32 pid,
+			  int report)
 {
+	struct nf_ct_event item = {
+		.ct 	= ct,
+		.pid	= pid,
+		.report = report
+	};
+
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-		atomic_notifier_call_chain(&nf_conntrack_chain, event, ct);
+		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
+}
+
+static inline void
+nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
+{
+	nf_conntrack_event_report(event, ct, 0, 0);
 }
 
+struct nf_exp_event {
+	struct nf_conntrack_expect *exp;
+	u32 pid;
+	int report;
+};
+
 extern struct atomic_notifier_head nf_ct_expect_chain;
 extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
 extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
 
 static inline void
+nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
+			  struct nf_conntrack_expect *exp,
+			  u32 pid,
+			  int report)
+{
+	struct nf_exp_event item = {
+		.exp	= exp,
+		.pid	= pid,
+		.report = report
+	};
+
+	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+}
+
+static inline void
 nf_ct_expect_event(enum ip_conntrack_expect_events event,
 		   struct nf_conntrack_expect *exp)
 {
-	atomic_notifier_call_chain(&nf_ct_expect_chain, event, exp);
+	nf_ct_expect_event_report(event, exp, 0, 0);
 }
 
 #else /* CONFIG_NF_CONNTRACK_EVENTS */
@@ -66,9 +109,17 @@ static inline void nf_conntrack_event_ca
 					    const struct sk_buff *skb) {}
 static inline void nf_conntrack_event(enum ip_conntrack_events event,
 				      struct nf_conn *ct) {}
+static inline void nf_conntrack_event_report(enum ip_conntrack_events event,
+					     struct nf_conn *ct,
+					     u32 pid,
+					     int report) {}
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
 static inline void nf_ct_expect_event(enum ip_conntrack_expect_events event,
 				      struct nf_conntrack_expect *exp) {}
+static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
+					     struct nf_conntrack_expect *exp,
+					     u32 pid,
+					     int report) {}
 static inline void nf_ct_event_cache_flush(void) {}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
Index: net-next-2.6.git/net/netfilter/nf_conntrack_ecache.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_ecache.c	2008-07-30 13:30:55.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_ecache.c	2008-07-30 13:34:40.000000000 +0200
@@ -38,9 +38,17 @@ static inline void
 __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 {
 	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
-	    && ecache->events)
-		atomic_notifier_call_chain(&nf_conntrack_chain, ecache->events,
-				    ecache->ct);
+	    && ecache->events) {
+		struct nf_ct_event item = {
+			.ct 	= ecache->ct,
+			.pid	= 0,
+			.report	= 0
+		};
+
+		atomic_notifier_call_chain(&nf_conntrack_chain,
+					   ecache->events,
+					   &item);
+	}
 
 	ecache->events = 0;
 	nf_ct_put(ecache->ct);
Index: net-next-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2008-07-30 13:32:34.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_core.c	2008-07-30 13:43:31.000000000 +0200
@@ -185,7 +185,8 @@ destroy_conntrack(struct nf_conntrack *n
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
-	nf_conntrack_event(IPCT_DESTROY, ct);
+	if (!test_bit(IPS_DYING_BIT, &ct->status))
+		nf_conntrack_event(IPCT_DESTROY, ct);
 	set_bit(IPS_DYING_BIT, &ct->status);
 
 	/* To make sure we don't get any weird locking issues here:
@@ -951,8 +952,24 @@ nf_ct_iterate_cleanup(int (*iter)(struct
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
+struct __nf_ct_flush_report {
+	u32 pid;
+	int report;
+};
+
 static int kill_all(struct nf_conn *i, void *data)
 {
+	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
+
+	if (!fr->report)
+		return 1;
+
+	set_bit(IPS_DYING_BIT, &i->status);
+	nf_conntrack_event_report(IPCT_DESTROY,
+				  i,
+				  fr->pid,
+				  fr->report);
+
 	return 1;
 }
 
@@ -966,9 +983,14 @@ void nf_ct_free_hashtable(struct hlist_h
 }
 EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
-void nf_conntrack_flush(void)
+void nf_conntrack_flush(u32 pid, int report)
 {
-	nf_ct_iterate_cleanup(kill_all, NULL);
+	struct __nf_ct_flush_report fr = {
+		.pid 	= pid,
+		.report = report,
+	};
+
+	nf_ct_iterate_cleanup(kill_all, &fr);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush);
 
@@ -985,7 +1007,7 @@ void nf_conntrack_cleanup(void)
 
 	nf_ct_event_cache_flush();
  i_see_dead_people:
-	nf_conntrack_flush();
+	nf_conntrack_flush(0, 0);
 	if (atomic_read(&nf_conntrack_count) != 0) {
 		schedule();
 		goto i_see_dead_people;
Index: net-next-2.6.git/include/net/netfilter/nf_conntrack_expect.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack_expect.h	2008-07-30 13:30:55.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack_expect.h	2008-07-30 13:34:40.000000000 +0200
@@ -92,6 +92,7 @@ void nf_ct_expect_init(struct nf_conntra
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related(struct nf_conntrack_expect *expect);
+int nf_ct_expect_related_user(struct nf_conntrack_expect *expect);
 
 #endif /*_NF_CONNTRACK_EXPECT_H*/
 
Index: net-next-2.6.git/net/netfilter/nf_conntrack_expect.c
===================================================================
--- net-next-2.6.git.orig/net/netfilter/nf_conntrack_expect.c	2008-07-30 13:30:55.000000000 +0200
+++ net-next-2.6.git/net/netfilter/nf_conntrack_expect.c	2008-07-30 13:34:40.000000000 +0200
@@ -365,7 +365,7 @@ static inline int refresh_timer(struct n
 	return 1;
 }
 
-int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
@@ -373,11 +373,8 @@ int nf_ct_expect_related(struct nf_connt
 	struct nf_conn_help *master_help = nfct_help(master);
 	struct hlist_node *n;
 	unsigned int h;
-	int ret;
+	int ret = 0;
 
-	NF_CT_ASSERT(master_help);
-
-	spin_lock_bh(&nf_conntrack_lock);
 	if (!master_help->helper) {
 		ret = -ESHUTDOWN;
 		goto out;
@@ -411,18 +408,47 @@ int nf_ct_expect_related(struct nf_connt
 			printk(KERN_WARNING
 			       "nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
-		goto out;
 	}
+out:
+	return ret;
+}
+
+int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+{
+	int ret;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	ret = __nf_ct_expect_check(expect);
+	if (ret < 0)
+		goto out;
 
 	nf_ct_expect_insert(expect);
+	atomic_inc(&expect->use);
+	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_expect_event(IPEXP_NEW, expect);
-	ret = 0;
+	nf_ct_expect_put(expect);
+	return ret;
 out:
 	spin_unlock_bh(&nf_conntrack_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related);
 
+int nf_ct_expect_related_user(struct nf_conntrack_expect *expect)
+{
+	int ret;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	ret = __nf_ct_expect_check(expect);
+	if (ret < 0)
+		goto out;
+	nf_ct_expect_insert(expect);
+out:
+	spin_unlock_bh(&nf_conntrack_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_expect_related_user);
+
 #ifdef CONFIG_PROC_FS
 struct ct_expect_iter_state {
 	unsigned int bucket;
Index: net-next-2.6.git/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-next-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2008-07-30 13:30:55.000000000 +0200
+++ net-next-2.6.git/include/net/netfilter/nf_conntrack.h	2008-07-30 13:43:21.000000000 +0200
@@ -192,7 +192,7 @@ __nf_conntrack_find(const struct nf_conn
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
 
-extern void nf_conntrack_flush(void);
+extern void nf_conntrack_flush(u32 pid, int report);
 
 extern bool nf_ct_get_tuplepr(const struct sk_buff *skb,
 			      unsigned int nhoff, u_int16_t l3num,

--------------080705010901000607080803--
