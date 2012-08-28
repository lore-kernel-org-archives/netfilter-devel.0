From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Tue, 28 Aug 2012 12:52:35 +0200
Message-ID: <20120828105235.GA22669@1984>
References: <7353554.n89QJXU3eh@gentoovm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60903 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2H1Kwr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:52:47 -0400
Content-Disposition: inline
In-Reply-To: <7353554.n89QJXU3eh@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Oliver,

On Mon, Aug 27, 2012 at 11:33:29AM +0200, Oliver wrote:
> In a previous version of ctnetlink, a race condition could be caused as a 
> result of ctnetlink_del_conntrack not setting the IPS_DYING_BIT that is 
> checked by death_by_timeout()
> 
> I found that in 3.4.9 I could trigger a soft-lockup by packet flooding a pair 
> of systems running conntrackd with NetlinkEventsReliable On.
> 
> I found that death_by_event() does not currently check the IPS_DYING_BIT and 
> therefore, based on the panic stack trace, I added the bit check to 
> death_by_event() and have since been unable to reproduce the crash.
> 
> I hope this patch is correct/useful - I'm not innately familiar with the 
> conntrack code so perhaps I'm breaking the reliable event reporting with this 
> change.

It seems we're hitting death_by_event twice, which should not happen.

Would you give a try to the following patch?

Thanks.

--UlVJffcvxoiEqYs2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_conntrack-fix-race-in-timer-handling-wi.patch"

>From 5d76750a082c85d032bc0ed9783b169c9bbe1cdc Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 27 Aug 2012 14:15:14 +0200
Subject: [PATCH] netfilter: nf_conntrack: fix race in timer handling with
 reliable events

This patch fixes a rare race condition running conntrackd in reliable
events mode with the following conditions:

1) ctnetlink holds a reference to one conntrack in the
   initial ctnetlink_del_conntrack path.
2) the conntrack timer expires so we remove it from hashes.
3) we fail to deliver the event, thus, the entry is reinserted in
   the dying list and the timer is restarted.
4) ctnetlink deletes the timer (while the conntrack is in the dying
   list) and it reinserts the conntrack in the dying list.

This patch fixes this by using the following logic:

1) all entries deleted from the hashes that we failed to insert in
   the dying list has the IPS_DYING bit set.
2) we always check for IPS_DYING, if set, we don't delete the
   timer since the object is already in the dying list.
3) The new function nf_ct_delete sets the IPS_DYING bit (if not set
   already) and deliver the event. If IPS_DYING is not set, the
   event is not delivered.

The functions nf_ct_delete_from_lists and nf_ct_insert_dying_list
are not exported anymore. Instead nf_ct_delete is exported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h        |    5 +-
 include/net/netfilter/nf_conntrack_ecache.h |    2 +-
 net/netfilter/nf_conntrack_core.c           |   75 ++++++++++-----------------
 net/netfilter/nf_conntrack_netlink.c        |   18 ++-----
 net/netfilter/nf_conntrack_proto.c          |    4 +-
 5 files changed, 34 insertions(+), 70 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f1494fe..0433065 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -181,8 +181,7 @@ __nf_conntrack_find(struct net *net, u16 zone,
 		    const struct nf_conntrack_tuple *tuple);
 
 extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
-extern void nf_ct_delete_from_lists(struct nf_conn *ct);
-extern void nf_ct_insert_dying_list(struct nf_conn *ct);
+bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
@@ -249,7 +248,7 @@ extern void nf_ct_untracked_status_or(unsigned long bits);
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data);
+nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data, u32 pid, int report);
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
 nf_conntrack_alloc(struct net *net, u16 zone,
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index e1ce104..2de13b9 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -108,7 +108,7 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 	if (e == NULL)
 		goto out_unlock;
 
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
+	if (nf_ct_is_confirmed(ct)) {
 		struct nf_ct_event item = {
 			.ct 	= ct,
 			.pid	= e->pid ? e->pid : pid,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fc61f40..f84ad9a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -231,7 +231,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	nf_conntrack_free(ct);
 }
 
-void nf_ct_delete_from_lists(struct nf_conn *ct)
+static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 
@@ -243,7 +243,6 @@ void nf_ct_delete_from_lists(struct nf_conn *ct)
 	clean_from_lists(ct);
 	spin_unlock_bh(&nf_conntrack_lock);
 }
-EXPORT_SYMBOL_GPL(nf_ct_delete_from_lists);
 
 static void death_by_event(unsigned long ul_conntrack)
 {
@@ -257,15 +256,13 @@ static void death_by_event(unsigned long ul_conntrack)
 		add_timer(&ct->timeout);
 		return;
 	}
-	/* we've got the event delivered, now it's dying */
-	set_bit(IPS_DYING_BIT, &ct->status);
 	spin_lock(&nf_conntrack_lock);
 	hlist_nulls_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 	spin_unlock(&nf_conntrack_lock);
 	nf_ct_put(ct);
 }
 
-void nf_ct_insert_dying_list(struct nf_conn *ct)
+static void nf_ct_insert_dying_list(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 
@@ -280,27 +277,32 @@ void nf_ct_insert_dying_list(struct nf_conn *ct)
 		(random32() % net->ct.sysctl_events_retry_timeout);
 	add_timer(&ct->timeout);
 }
-EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
 
-static void death_by_timeout(unsigned long ul_conntrack)
+bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report)
 {
-	struct nf_conn *ct = (void *)ul_conntrack;
 	struct nf_conn_tstamp *tstamp;
 
 	tstamp = nf_conn_tstamp_find(ct);
 	if (tstamp && tstamp->stop == 0)
 		tstamp->stop = ktime_to_ns(ktime_get_real());
 
-	if (!test_bit(IPS_DYING_BIT, &ct->status) &&
-	    unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
+	if (!test_and_set_bit(IPS_DYING_BIT, &ct->status) &&
+	    unlikely(nf_conntrack_event_report(IPCT_DESTROY, ct, pid,
+								report) < 0)) {
 		/* destroy event was not delivered */
 		nf_ct_delete_from_lists(ct);
 		nf_ct_insert_dying_list(ct);
-		return;
+		return false;
 	}
-	set_bit(IPS_DYING_BIT, &ct->status);
 	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
+	return true;
+}
+EXPORT_SYMBOL_GPL(nf_ct_delete);
+
+static void death_by_timeout(unsigned long ul_conntrack)
+{
+	nf_ct_delete((struct nf_conn *)ul_conntrack, 0, 0);
 }
 
 /*
@@ -634,11 +636,9 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 	if (!ct)
 		return dropped;
 
-	if (del_timer(&ct->timeout)) {
-		death_by_timeout((unsigned long)ct);
-		/* Check if we indeed killed this entry. Reliable event
-		   delivery may have inserted it into the dying list. */
-		if (test_bit(IPS_DYING_BIT, &ct->status)) {
+	if (!nf_ct_is_dying(ct) && del_timer(&ct->timeout)) {
+		/* Check if we indeed killed this entry */
+		if (nf_ct_delete(ct, 0, 0)) {
 			dropped = 1;
 			NF_CT_STAT_INC_ATOMIC(net, early_drop);
 		}
@@ -1117,8 +1117,8 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 		}
 	}
 
-	if (del_timer(&ct->timeout)) {
-		ct->timeout.function((unsigned long)ct);
+	if (!nf_ct_is_dying(ct) && del_timer(&ct->timeout)) {
+		nf_ct_delete(ct, 0, 0);
 		return true;
 	}
 	return false;
@@ -1219,8 +1219,7 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 	}
 	hlist_nulls_for_each_entry(h, n, &net->ct.unconfirmed, hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (iter(ct, data))
-			set_bit(IPS_DYING_BIT, &ct->status);
+		iter(ct, data);
 	}
 	spin_unlock_bh(&nf_conntrack_lock);
 	return NULL;
@@ -1232,15 +1231,15 @@ found:
 
 void nf_ct_iterate_cleanup(struct net *net,
 			   int (*iter)(struct nf_conn *i, void *data),
-			   void *data)
+			   void *data, u32 pid, int report)
 {
 	struct nf_conn *ct;
 	unsigned int bucket = 0;
 
 	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
-		if (del_timer(&ct->timeout))
-			death_by_timeout((unsigned long)ct);
+		if (!nf_ct_is_dying(ct) && del_timer(&ct->timeout))
+			nf_ct_delete(ct, pid, report);
 		/* ... else the timer will get him soon. */
 
 		nf_ct_put(ct);
@@ -1248,32 +1247,14 @@ void nf_ct_iterate_cleanup(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
-struct __nf_ct_flush_report {
-	u32 pid;
-	int report;
-};
-
-static int kill_report(struct nf_conn *i, void *data)
+static int kill_all(struct nf_conn *i, void *data)
 {
-	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
 	struct nf_conn_tstamp *tstamp;
 
 	tstamp = nf_conn_tstamp_find(i);
 	if (tstamp && tstamp->stop == 0)
 		tstamp->stop = ktime_to_ns(ktime_get_real());
 
-	/* If we fail to deliver the event, death_by_timeout() will retry */
-	if (nf_conntrack_event_report(IPCT_DESTROY, i,
-				      fr->pid, fr->report) < 0)
-		return 1;
-
-	/* Avoid the delivery of the destroy event in death_by_timeout(). */
-	set_bit(IPS_DYING_BIT, &i->status);
-	return 1;
-}
-
-static int kill_all(struct nf_conn *i, void *data)
-{
 	return 1;
 }
 
@@ -1289,11 +1270,7 @@ EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
 void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 {
-	struct __nf_ct_flush_report fr = {
-		.pid 	= pid,
-		.report = report,
-	};
-	nf_ct_iterate_cleanup(net, kill_report, &fr);
+	nf_ct_iterate_cleanup(net, kill_all, NULL, pid, report);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
@@ -1337,7 +1314,7 @@ static void nf_conntrack_cleanup_init_net(void)
 static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
-	nf_ct_iterate_cleanup(net, kill_all, NULL);
+	nf_ct_iterate_cleanup(net, kill_all, NULL, 0, 0);
 	nf_ct_release_dying_list(net);
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index da4fc37..9d01635 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -983,21 +983,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	if (del_timer(&ct->timeout)) {
-		if (nf_conntrack_event_report(IPCT_DESTROY, ct,
-					      NETLINK_CB(skb).pid,
-					      nlmsg_report(nlh)) < 0) {
-			nf_ct_delete_from_lists(ct);
-			/* we failed to report the event, try later */
-			nf_ct_insert_dying_list(ct);
-			nf_ct_put(ct);
-			return 0;
-		}
-		/* death_by_timeout would report the event again */
-		set_bit(IPS_DYING_BIT, &ct->status);
-		nf_ct_delete_from_lists(ct);
-		nf_ct_put(ct);
-	}
+	if (!nf_ct_is_dying(ct) && del_timer(&ct->timeout))
+		nf_ct_delete(ct, NETLINK_CB(skb).pid, nlmsg_report(nlh));
+
 	nf_ct_put(ct);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 51e928d..5e0d547 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -293,7 +293,7 @@ void nf_conntrack_l3proto_unregister(struct net *net,
 	nf_ct_l3proto_unregister_sysctl(net, proto);
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(net, kill_l3proto, proto);
+	nf_ct_iterate_cleanup(net, kill_l3proto, proto, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -499,7 +499,7 @@ void nf_conntrack_l4proto_unregister(struct net *net,
 	nf_ct_l4proto_unregister_sysctl(net, pn, l4proto);
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(net, kill_l4proto, l4proto);
+	nf_ct_iterate_cleanup(net, kill_l4proto, l4proto, 0, 0);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
 
-- 
1.7.10.4


--UlVJffcvxoiEqYs2--
