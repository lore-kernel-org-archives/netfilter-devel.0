Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0EBC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 12:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358556AbiBDMN2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 07:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbiBDMN2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 07:13:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21C4C061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 04:13:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFxSw-0007d1-5O; Fri, 04 Feb 2022 13:13:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ecache: don't use nf_conn spinlock
Date:   Fri,  4 Feb 2022 13:13:20 +0100
Message-Id: <20220204121320.3549-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For updating eache missed value we can use cmpxchg.
This also avoids need to disable BH.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ecache.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 873908054f7f..e99b39173198 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -135,9 +135,9 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 					   const unsigned long missed,
 					   const struct nf_ct_event *item)
 {
-	struct nf_conn *ct = item->ct;
 	struct net *net = nf_ct_net(item->ct);
 	struct nf_ct_event_notifier *notify;
+	unsigned long old, want;
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
-- 
2.34.1

