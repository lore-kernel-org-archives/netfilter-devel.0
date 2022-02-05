Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23ABC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Feb 2022 12:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379721AbiBEMA1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Feb 2022 07:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359398AbiBEMAN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Feb 2022 07:00:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C335C061346
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Feb 2022 04:00:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nGJjb-00050d-8I; Sat, 05 Feb 2022 13:00:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2] netfilter: ecache: don't use nf_conn spinlock
Date:   Sat,  5 Feb 2022 13:00:04 +0100
Message-Id: <20220205120004.98531-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For updating eache missed value we can use cmpxchg.
This also avoids need to disable BH.

kernel robot reported build failure on v1 because not all arches support
cmpxchg for u16, so extend this to u32.

This doesn't increase struct size, existing padding is used.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2, changed u16 missed to u32; some arches don't support
 cmpxchg for u16.

 include/net/netfilter/nf_conntrack_ecache.h |  2 +-
 net/netfilter/nf_conntrack_ecache.c         | 25 +++++++++++----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 16bcff809b18..6c4c490a3e34 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -21,10 +21,10 @@ enum nf_ct_ecache_state {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
-	u16 missed;			/* missed events */
 	u16 ctmask;			/* bitmask of ct events to be delivered */
 	u16 expmask;			/* bitmask of expect events to be delivered */
 	enum nf_ct_ecache_state state:8;/* ecache state */
+	u32 missed;			/* missed events */
 	u32 portid;			/* netlink portid of destroyer */
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 873908054f7f..07e65b4e92f8 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -131,13 +131,13 @@ static void ecache_work(struct work_struct *work)
 }
 
 static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
-					   const unsigned int events,
-					   const unsigned long missed,
+					   const u32 events,
+					   const u32 missed,
 					   const struct nf_ct_event *item)
 {
-	struct nf_conn *ct = item->ct;
 	struct net *net = nf_ct_net(item->ct);
 	struct nf_ct_event_notifier *notify;
+	u32 old, want;
 	int ret;
 
 	if (!((events | missed) & e->ctmask))
@@ -157,12 +157,13 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 	if (likely(ret >= 0 && missed == 0))
 		return 0;
 
-	spin_lock_bh(&ct->lock);
-	if (ret < 0)
-		e->missed |= events;
-	else
-		e->missed &= ~missed;
-	spin_unlock_bh(&ct->lock);
+	do {
+		old = READ_ONCE(e->missed);
+		if (ret < 0)
+			want = old | events;
+		else
+			want = old & ~missed;
+	} while (cmpxchg(&e->missed, old, want) != old);
 
 	return ret;
 }
@@ -172,7 +173,7 @@ int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 {
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
-	unsigned long missed;
+	unsigned int missed;
 	int ret;
 
 	if (!nf_ct_is_confirmed(ct))
@@ -211,7 +212,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
 	struct nf_conntrack_ecache *e;
 	struct nf_ct_event item;
-	unsigned long events;
+	unsigned int events;
 
 	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
 		return;
@@ -312,7 +313,7 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	cnet->ct_net = &net->ct;
 	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
 
-	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* ctmask, missed use u16 */
+	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
-- 
2.34.1

