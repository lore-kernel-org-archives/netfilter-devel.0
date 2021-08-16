Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00434C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFD160E97
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhHPPRR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 11:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhHPPRR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 11:17:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7059C061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 08:16:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mFeM0-0007Da-7u; Mon, 16 Aug 2021 17:16:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/5] netfilter: ecache: add common helper for nf_conntrack_eventmask_report
Date:   Mon, 16 Aug 2021 17:16:24 +0200
Message-Id: <20210816151626.28770-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816151626.28770-1-fw@strlen.de>
References: <20210816151626.28770-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_ct_deliver_cached_events and nf_conntrack_eventmask_report are very
similar.  Split nf_conntrack_eventmask_report into a common helper
function that can be used for both cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ecache.c | 124 +++++++++++++---------------
 1 file changed, 56 insertions(+), 68 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 127a0fa6ae43..fbe04e16280a 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -130,27 +130,57 @@ static void ecache_work(struct work_struct *work)
 		schedule_delayed_work(&cnet->ecache_dwork, delay);
 }
 
-int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
-				  u32 portid, int report)
+static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
+					   const unsigned int events,
+					   const unsigned long missed,
+					   const struct nf_ct_event *item)
 {
-	struct net *net = nf_ct_net(ct);
+	struct nf_conn *ct = item->ct;
+	struct net *net = nf_ct_net(item->ct);
 	struct nf_ct_event_notifier *notify;
+	int ret;
+
+	if (!((events | missed) & e->ctmask))
+		return 0;
+
+	rcu_read_lock();
+
+	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
+	if (!notify) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	ret = notify->fcn(events | missed, item);
+	rcu_read_unlock();
+
+	if (likely(ret >= 0 && missed == 0))
+		return 0;
+
+	spin_lock_bh(&ct->lock);
+	if (ret < 0)
+		e->missed |= events;
+	else
+		e->missed &= ~missed;
+	spin_unlock_bh(&ct->lock);
+
+	return ret;
+}
+
+int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
+				  u32 portid, int report)
+{
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
 	unsigned long missed;
-	int ret = 0;
+	int ret;
 
 	if (!nf_ct_is_confirmed(ct))
-		return ret;
-
-	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
-	if (!notify)
-		goto out_unlock;
+		return 0;
 
 	e = nf_ct_ecache_find(ct);
 	if (!e)
-		goto out_unlock;
+		return 0;
 
 	memset(&item, 0, sizeof(item));
 
@@ -161,33 +191,16 @@ int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 	/* This is a resent of a destroy event? If so, skip missed */
 	missed = e->portid ? 0 : e->missed;
 
-	if (!((eventmask | missed) & e->ctmask))
-		goto out_unlock;
-
-	ret = notify->fcn(eventmask | missed, &item);
-	if (likely(ret >= 0 && !missed))
-		goto out_unlock;
-
-	spin_lock_bh(&ct->lock);
-	if (ret < 0) {
-		/* This is a destroy event that has been
-		 * triggered by a process, we store the PORTID
-		 * to include it in the retransmission.
+	ret = __nf_conntrack_eventmask_report(e, events, missed, &item);
+	if (unlikely(ret < 0 && (events & (1 << IPCT_DESTROY)))) {
+		/* This is a destroy event that has been triggered by a process,
+		 * we store the PORTID to include it in the retransmission.
 		 */
-		if (eventmask & (1 << IPCT_DESTROY)) {
-			if (e->portid == 0 && portid != 0)
-				e->portid = portid;
-			e->state = NFCT_ECACHE_DESTROY_FAIL;
-		} else {
-			e->missed |= eventmask;
-		}
-	} else {
-		e->missed &= ~missed;
+		if (e->portid == 0 && portid != 0)
+			e->portid = portid;
+		e->state = NFCT_ECACHE_DESTROY_FAIL;
 	}
-	spin_unlock_bh(&ct->lock);
 
-out_unlock:
-	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_eventmask_report);
@@ -196,53 +209,28 @@ EXPORT_SYMBOL_GPL(nf_conntrack_eventmask_report);
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
-	struct net *net = nf_ct_net(ct);
-	unsigned long events, missed;
-	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
-	int ret;
-
-	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
-	if (notify == NULL)
-		goto out_unlock;
+	unsigned long events;
 
 	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
-		goto out_unlock;
+		return;
 
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
-		goto out_unlock;
+		return;
 
 	events = xchg(&e->cache, 0);
 
-	/* We make a copy of the missed event cache without taking
-	 * the lock, thus we may send missed events twice. However,
-	 * this does not harm and it happens very rarely. */
-	missed = e->missed;
-
-	if (!((events | missed) & e->ctmask))
-		goto out_unlock;
-
 	item.ct = ct;
 	item.portid = 0;
 	item.report = 0;
 
-	ret = notify->fcn(events | missed, &item);
-
-	if (likely(ret == 0 && !missed))
-		goto out_unlock;
-
-	spin_lock_bh(&ct->lock);
-	if (ret < 0)
-		e->missed |= events;
-	else
-		e->missed &= ~missed;
-	spin_unlock_bh(&ct->lock);
-
-out_unlock:
-	rcu_read_unlock();
+	/* We make a copy of the missed event cache without taking
+	 * the lock, thus we may send missed events twice. However,
+	 * this does not harm and it happens very rarely.
+	 */
+	__nf_conntrack_eventmask_report(e, events, e->missed, &item);
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
-- 
2.31.1

