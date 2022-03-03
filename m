Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA6EC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiCCNzb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiCCNza (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:55:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A4318BA45
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:54:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlul-0001Vi-JC; Thu, 03 Mar 2022 14:54:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 04/15] netfilter: ecache: use dedicated list for event redelivery
Date:   Thu,  3 Mar 2022 14:54:08 +0100
Message-Id: <20220303135419.10837-5-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This disentangles event redelivery and the percpu dying list.

Because entries are now stored on a dedicated list, all
entries are in NFCT_ECACHE_DESTROY_FAIL state and all entries
still have confirmed bit set -- the reference count is at least 1.

The 'struct net' back-pointer can be removed as well.

The pcpu dying list will be removed eventually, it has no functionality.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h        |   3 +-
 include/net/netfilter/nf_conntrack_ecache.h |   1 -
 net/netfilter/nf_conntrack_core.c           |  33 +++++-
 net/netfilter/nf_conntrack_ecache.c         | 118 +++++++++-----------
 4 files changed, 83 insertions(+), 72 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 20fefe043850..dbbb0e206901 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,7 +45,8 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_net_ecache {
 	struct delayed_work dwork;
-	struct netns_ct *ct_net;
+	spinlock_t dying_lock;
+	struct hlist_nulls_head dying_list;
 };
 
 struct nf_conntrack_net {
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index ebd816af9c40..c63a8fc3225e 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -14,7 +14,6 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 
 enum nf_ct_ecache_state {
-	NFCT_ECACHE_UNKNOWN,		/* destroy event not sent */
 	NFCT_ECACHE_DESTROY_FAIL,	/* tried but failed to send destroy event */
 	NFCT_ECACHE_DESTROY_SENT,	/* sent destroy event after failure */
 };
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9b7f9c966f73..7eefcfa55fc2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -647,15 +647,12 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 }
 EXPORT_SYMBOL(nf_ct_destroy);
 
-static void nf_ct_delete_from_lists(struct nf_conn *ct)
+static void __nf_ct_delete_from_lists(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, reply_hash;
 	unsigned int sequence;
 
-	nf_ct_helper_destroy(ct);
-
-	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&nf_conntrack_generation);
 		hash = hash_conntrack(net,
@@ -668,12 +665,33 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 
 	clean_from_lists(ct);
 	nf_conntrack_double_unlock(hash, reply_hash);
+}
 
+static void nf_ct_delete_from_lists(struct nf_conn *ct)
+{
+	nf_ct_helper_destroy(ct);
+	local_bh_disable();
+
+	__nf_ct_delete_from_lists(ct);
 	nf_ct_add_to_dying_list(ct);
 
 	local_bh_enable();
 }
 
+static void nf_ct_add_to_ecache_list(struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct nf_conntrack_net *cnet = nf_ct_pernet(nf_ct_net(ct));
+
+	spin_lock(&cnet->ecache.dying_lock);
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &cnet->ecache.dying_list);
+	spin_unlock(&cnet->ecache.dying_lock);
+#else
+	nf_ct_add_to_dying_list(ct);
+#endif
+}
+
 bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 {
 	struct nf_conn_tstamp *tstamp;
@@ -696,7 +714,12 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 		/* destroy event was not delivered. nf_ct_put will
 		 * be done by event cache worker on redelivery.
 		 */
-		nf_ct_delete_from_lists(ct);
+		nf_ct_helper_destroy(ct);
+		local_bh_disable();
+		__nf_ct_delete_from_lists(ct);
+		nf_ct_add_to_ecache_list(ct);
+		local_bh_enable();
+
 		nf_conntrack_ecache_work(nf_ct_net(ct), NFCT_ECACHE_DESTROY_FAIL);
 		return false;
 	}
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index d7a07873e605..be111218899d 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -16,7 +16,6 @@
 #include <linux/vmalloc.h>
 #include <linux/stddef.h>
 #include <linux/err.h>
-#include <linux/percpu.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/slab.h>
@@ -29,8 +28,9 @@
 
 const struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
 
-#define ECACHE_RETRY_WAIT (HZ/10)
-#define ECACHE_STACK_ALLOC (256 / sizeof(void *))
+#define DYING_NULLS_VAL			((1 << 30) + 1)
+#define ECACHE_MAX_JIFFIES		msecs_to_jiffies(10)
+#define ECACHE_RETRY_JIFFIES		msecs_to_jiffies(10)
 
 enum retry_state {
 	STATE_CONGESTED,
@@ -38,58 +38,59 @@ enum retry_state {
 	STATE_DONE,
 };
 
-static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
+static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 {
-	struct nf_conn *refs[ECACHE_STACK_ALLOC];
+	unsigned long stop = jiffies + ECACHE_MAX_JIFFIES;
+	struct hlist_nulls_head evicted_list;
 	enum retry_state ret = STATE_DONE;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	unsigned int evicted = 0;
+	unsigned int sent;
 
-	spin_lock(&pcpu->lock);
+	INIT_HLIST_NULLS_HEAD(&evicted_list, DYING_NULLS_VAL);
 
-	hlist_nulls_for_each_entry(h, n, &pcpu->dying, hnnode) {
+next:
+	sent = 0;
+	spin_lock_bh(&cnet->ecache.dying_lock);
+
+	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
-		struct nf_conntrack_ecache *e;
-
-		if (!nf_ct_is_confirmed(ct))
-			continue;
-
-		/* This ecache access is safe because the ct is on the
-		 * pcpu dying list and we hold the spinlock -- the entry
-		 * cannot be free'd until after the lock is released.
-		 *
-		 * This is true even if ct has a refcount of 0: the
-		 * cpu that is about to free the entry must remove it
-		 * from the dying list and needs the lock to do so.
-		 */
-		e = nf_ct_ecache_find(ct);
-		if (!e || e->state != NFCT_ECACHE_DESTROY_FAIL)
-			continue;
 
-		/* ct is in NFCT_ECACHE_DESTROY_FAIL state, this means
-		 * the worker owns this entry: the ct will remain valid
-		 * until the worker puts its ct reference.
+		/* The worker owns all entries, ct remains valid until nf_ct_put
+		 * in the loop below.
 		 */
 		if (nf_conntrack_event(IPCT_DESTROY, ct)) {
 			ret = STATE_CONGESTED;
 			break;
 		}
 
-		e->state = NFCT_ECACHE_DESTROY_SENT;
-		refs[evicted] = ct;
+		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+		hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode, &evicted_list);
 
-		if (++evicted >= ARRAY_SIZE(refs)) {
+		if (time_after(stop, jiffies)) {
 			ret = STATE_RESTART;
 			break;
 		}
+
+		if (sent++ > 16) {
+			spin_unlock_bh(&cnet->ecache.dying_lock);
+			cond_resched();
+			spin_lock_bh(&cnet->ecache.dying_lock);
+			goto next;
+		}
 	}
 
-	spin_unlock(&pcpu->lock);
+	spin_unlock_bh(&cnet->ecache.dying_lock);
 
-	/* can't _put while holding lock */
-	while (evicted)
-		nf_ct_put(refs[--evicted]);
+	hlist_nulls_for_each_entry_safe(h, n, &evicted_list, hnnode) {
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+		hlist_nulls_add_fake(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode);
+		nf_ct_put(ct);
+
+		cond_resched();
+	}
 
 	return ret;
 }
@@ -97,35 +98,20 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 static void ecache_work(struct work_struct *work)
 {
 	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache.dwork.work);
-	struct netns_ct *ctnet = cnet->ecache.ct_net;
-	int cpu, delay = -1;
-	struct ct_pcpu *pcpu;
-
-	local_bh_disable();
-
-	for_each_possible_cpu(cpu) {
-		enum retry_state ret;
-
-		pcpu = per_cpu_ptr(ctnet->pcpu_lists, cpu);
-
-		ret = ecache_work_evict_list(pcpu);
-
-		switch (ret) {
-		case STATE_CONGESTED:
-			delay = ECACHE_RETRY_WAIT;
-			goto out;
-		case STATE_RESTART:
-			delay = 0;
-			break;
-		case STATE_DONE:
-			break;
-		}
+	int ret, delay = -1;
+
+	ret = ecache_work_evict_list(cnet);
+	switch (ret) {
+	case STATE_CONGESTED:
+		delay = ECACHE_RETRY_JIFFIES;
+		break;
+	case STATE_RESTART:
+		delay = 0;
+		break;
+	case STATE_DONE:
+		break;
 	}
 
- out:
-	local_bh_enable();
-
-	ctnet->ecache_dwork_pending = delay > 0;
 	if (delay >= 0)
 		schedule_delayed_work(&cnet->ecache.dwork, delay);
 }
@@ -198,7 +184,6 @@ int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 		 */
 		if (e->portid == 0 && portid != 0)
 			e->portid = portid;
-		e->state = NFCT_ECACHE_DESTROY_FAIL;
 	}
 
 	return ret;
@@ -285,8 +270,10 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 		schedule_delayed_work(&cnet->ecache.dwork, HZ);
 		net->ct.ecache_dwork_pending = true;
 	} else if (state == NFCT_ECACHE_DESTROY_SENT) {
-		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &cnet->ecache.dwork, 0);
+		if (!hlist_nulls_empty(&cnet->ecache.dying_list))
+			mod_delayed_work(system_wq, &cnet->ecache.dwork, 0);
+		else
+			net->ct.ecache_dwork_pending = false;
 	}
 }
 
@@ -299,8 +286,9 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 
 	net->ct.sysctl_events = nf_ct_events;
 
-	cnet->ecache.ct_net = &net->ct;
 	INIT_DELAYED_WORK(&cnet->ecache.dwork, ecache_work);
+	INIT_HLIST_NULLS_HEAD(&cnet->ecache.dying_list, DYING_NULLS_VAL);
+	spin_lock_init(&cnet->ecache.dying_lock);
 
 	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
-- 
2.34.1

