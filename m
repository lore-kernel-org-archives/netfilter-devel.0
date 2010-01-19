From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Tue, 19 Jan 2010 17:03:55 +0100
Message-ID: <4B55D7EB.9090906@trash.net>
References: <4B5575CB.5050207@trash.net> <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu> <4B558C11.9020607@trash.net> <4B55A05E.6010107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060500080705050100090707"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0ASQD7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:03:59 -0500
In-Reply-To: <4B55A05E.6010107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060500080705050100090707
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> or something like that. Are the existing event types fine grained
>> enough for this? Also, should the CT target override the global
>> sysctl setting?
> 
> Regarding the override, what I'm adding right now is:
> 
> - sysctl=1 enables all events unless specific events are requested
> - sysctl=0 disables all events unless specific events are requested
> 
> This should be fine from a backwards-compatibility POV.

I'm using this patch for selective delivery and a small patch on top
of the CT target to initialize the masks. Besides the masks, it also
removes a couple of ctnetlink sysctl checks in the direct delivery
paths since they prevent overriding the sysctl. It also seems
inconsistent that we continue delivering cached events for conntracks
with an ecache entry, but stop delivering direct events when the sysctl
is set to zero.

One remaining question is whether we should initialize the masks
of an expected connection to those of its master. This seems useful
since in the raw table (where the CT target can be used) its unknown
whether its an expected connection.

--------------060500080705050100090707
Content-Type: text/x-patch;
 name="ev.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ev.diff"

commit 1019e6a541bac66266cdfbc0acae5c3ce655d3f6
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Jan 19 16:48:25 2010 +0100

    netfilter: ctnetlink: support selective event delivery
    
    Add two masks for conntrack end expectation events to struct nf_conntrack_ecache
    and use them to filter events. Their default value is "all events" when the
    event sysctl is on and "no events" when it is off. A following patch will add
    specific initializations. Expectation events depend on the ecache struct of
    their master conntrack.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index a374787..3a57c14 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -74,6 +74,23 @@ enum ip_conntrack_status {
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
 };
 
+/* Connection tracking event types */
+enum ip_conntrack_events {
+	IPCT_NEW		= 0,	/* new conntrack */
+	IPCT_RELATED		= 1,	/* related conntrack */
+	IPCT_DESTROY		= 2,	/* destroyed conntrack */
+	IPCT_STATUS		= 3,	/* status has changed */
+	IPCT_PROTOINFO		= 4,	/* protocol information has changed */
+	IPCT_HELPER		= 5,	/* new helper has been set */
+	IPCT_MARK		= 6,	/* new mark has been set */
+	IPCT_NATSEQADJ		= 7,	/* NAT is doing sequence adjustment */
+	IPCT_SECMARK		= 8,	/* new security mark has been set */
+};
+
+enum ip_conntrack_expect_events {
+	IPEXP_NEW		= 0,	/* new expectation */
+};
+
 #ifdef __KERNEL__
 struct ip_conntrack_stat {
 	unsigned int searched;
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 475facc..96ba5f7 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -12,27 +12,12 @@
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-/* Connection tracking event types */
-enum ip_conntrack_events {
-	IPCT_NEW		= 0,	/* new conntrack */
-	IPCT_RELATED		= 1,	/* related conntrack */
-	IPCT_DESTROY		= 2,	/* destroyed conntrack */
-	IPCT_STATUS		= 3,	/* status has changed */
-	IPCT_PROTOINFO		= 4,	/* protocol information has changed */
-	IPCT_HELPER		= 5,	/* new helper has been set */
-	IPCT_MARK		= 6,	/* new mark has been set */
-	IPCT_NATSEQADJ		= 7,	/* NAT is doing sequence adjustment */
-	IPCT_SECMARK		= 8,	/* new security mark has been set */
-};
-
-enum ip_conntrack_expect_events {
-	IPEXP_NEW		= 0,	/* new expectation */
-};
-
 struct nf_conntrack_ecache {
-	unsigned long cache;		/* bitops want long */
-	unsigned long missed;		/* missed events */
-	u32 pid;			/* netlink pid of destroyer */
+	unsigned long cache;	/* bitops want long */
+	unsigned long missed;	/* missed events */
+	u16 ctmask;		/* bitmask of ct events to be delivered */
+	u16 expmask;		/* bitmask of expect events to be delivered */
+	u32 pid;		/* netlink pid of destroyer */
 };
 
 static inline struct nf_conntrack_ecache *
@@ -42,14 +27,24 @@ nf_ct_ecache_find(const struct nf_conn *ct)
 }
 
 static inline struct nf_conntrack_ecache *
-nf_ct_ecache_ext_add(struct nf_conn *ct, gfp_t gfp)
+nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
 {
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *e;
 
-	if (!net->ct.sysctl_events)
+	if (!ctmask && !expmask && net->ct.sysctl_events) {
+		ctmask = ~0;
+		expmask = ~0;
+	}
+	if (!ctmask && !expmask)
 		return NULL;
 
-	return nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
+	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
+	if (e) {
+		e->ctmask  = ctmask;
+		e->expmask = expmask;
+	}
+	return e;
 };
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -82,6 +77,9 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	if (e == NULL)
 		return;
 
+	if (!(e->ctmask & (1 << event)))
+		return;
+
 	set_bit(event, &e->cache);
 }
 
@@ -92,7 +90,6 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 			      int report)
 {
 	int ret = 0;
-	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
@@ -101,9 +98,6 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 	if (notify == NULL)
 		goto out_unlock;
 
-	if (!net->ct.sysctl_events)
-		goto out_unlock;
-
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
 		goto out_unlock;
@@ -117,6 +111,9 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 		/* This is a resent of a destroy event? If so, skip missed */
 		unsigned long missed = e->pid ? 0 : e->missed;
 
+		if (!((eventmask | missed) & e->ctmask))
+			goto out_unlock;
+
 		ret = notify->fcn(eventmask | missed, &item);
 		if (unlikely(ret < 0 || missed)) {
 			spin_lock_bh(&ct->lock);
@@ -172,18 +169,19 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  u32 pid,
 			  int report)
 {
-	struct net *net = nf_ct_exp_net(exp);
 	struct nf_exp_event_notifier *notify;
+	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
 	notify = rcu_dereference(nf_expect_event_cb);
 	if (notify == NULL)
 		goto out_unlock;
 
-	if (!net->ct.sysctl_events)
+	e = nf_ct_ecache_find(exp->master);
+	if (e == NULL)
 		goto out_unlock;
 
-	{
+	if (e->expmask & (1 << event)) {
 		struct nf_exp_event item = {
 			.exp	= exp,
 			.pid	= pid,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0e98c32..4d75e21 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -648,7 +648,7 @@ init_conntrack(struct net *net,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
-	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 
 	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(net, tuple);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 79478df..ec69442 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1276,7 +1276,7 @@ ctnetlink_create_conntrack(struct net *net,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
-	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])

--------------060500080705050100090707--
