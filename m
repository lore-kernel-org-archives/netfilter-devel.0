From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Tue, 28 Aug 2012 19:16:39 +0200
Message-ID: <9829027.jsWF3AolUh@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <20120828105235.GA22669@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2571972.0CCy95y4dV"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:35936 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2H1RRA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:17:00 -0400
In-Reply-To: <20120828105235.GA22669@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nextPart2571972.0CCy95y4dV
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Pablo,

On Tuesday 28 August 2012 12:52:35 you wrote:
> It seems we're hitting death_by_event twice, which should not happen.
> 
> Would you give a try to the following patch?
> 
> Thanks.

I've tried applying the patch against 3.4.10 and found that it doesn't work 
due to having rewritten nf_ct_iterate_cleanup() to take two additional 
arguments and the nf_conntrack_proto.c in your source tree being divergent 
from anything I could find.

So, I've taken a different approach; nf_ct_iterate_cleanup() is a wrapper for 
nf_ct_iterate_cleanup_new() that simply passes 0 for the last two args so as 
to save having to edit every module.

Please take a look at the attached patch and let me know your thoughts; I'd 
Ideally like to have this fix in 3.4 since that's long-term stable.

During testing I found that the kernel is indeed solid and does not panic; 
however, I managed to make conntrackd eat 100% of a CPU core on one of the 
pair and conntrack entries remained unevicted from the kernel until I killed 
the conntrackd process.

Kind Regards,
Oliver
--nextPart2571972.0CCy95y4dV
Content-Disposition: attachment; filename="0002-netfilter-nf_conntrack-fix-race-in-timer-handling-wi-in-kernel-3.4.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-netfilter-nf_conntrack-fix-race-in-timer-handling-wi-in-kernel-3.4.patch"

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index ab86036..8f92f77 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -210,8 +210,7 @@ __nf_conntrack_find(struct net *net, u16 zone,
 		    const struct nf_conntrack_tuple *tuple);
 
 extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
-extern void nf_ct_delete_from_lists(struct nf_conn *ct);
-extern void nf_ct_insert_dying_list(struct nf_conn *ct);
+bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
@@ -278,7 +277,8 @@ extern void nf_ct_untracked_status_or(unsigned long bits);
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data);
+nf_ct_iterate_cleanup_new(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data, u32 pid, int report);
+extern void nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data);
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
 nf_conntrack_alloc(struct net *net, u16 zone,
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index a88fb69..2f7b0ac 100644
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
index 729f157..bdc9473 100644
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
@@ -1124,8 +1124,8 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 		}
 	}
 
-	if (del_timer(&ct->timeout)) {
-		ct->timeout.function((unsigned long)ct);
+	if (!nf_ct_is_dying(ct) && del_timer(&ct->timeout)) {
+		nf_ct_delete(ct, 0, 0);
 		return true;
 	}
 	return false;
@@ -1225,8 +1225,7 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 	}
 	hlist_nulls_for_each_entry(h, n, &net->ct.unconfirmed, hnnode) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (iter(ct, data))
-			set_bit(IPS_DYING_BIT, &ct->status);
+		iter(ct, data);
 	}
 	spin_unlock_bh(&nf_conntrack_lock);
 	return NULL;
@@ -1236,50 +1235,40 @@ found:
 	return ct;
 }
 
-void nf_ct_iterate_cleanup(struct net *net,
+void nf_ct_iterate_cleanup_new(struct net *net,
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
 	}
 }
-EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
+EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_new);
 
-struct __nf_ct_flush_report {
-	u32 pid;
-	int report;
-};
+void nf_ct_iterate_cleanup(struct net *net,
+			   int (*iter)(struct nf_conn *i, void *data),
+			   void *data)
+{
+	nf_ct_iterate_cleanup_new(net, iter, data, 0, 0);
+}
+EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
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
 
@@ -1295,11 +1284,7 @@ EXPORT_SYMBOL_GPL(nf_ct_free_hashtable);
 
 void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 {
-	struct __nf_ct_flush_report fr = {
-		.pid 	= pid,
-		.report = report,
-	};
-	nf_ct_iterate_cleanup(net, kill_report, &fr);
+	nf_ct_iterate_cleanup_new(net, kill_all, NULL, pid, report);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ca7e835..2b0c9c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -967,21 +967,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
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

--nextPart2571972.0CCy95y4dV--

