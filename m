Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D658AC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBED360231
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 15:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhHPPRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 11:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbhHPPRN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 11:17:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D88C061764
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2021 08:16:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mFeLw-0007DH-3C; Mon, 16 Aug 2021 17:16:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/5] netfilter: ecache: remove another indent level
Date:   Mon, 16 Aug 2021 17:16:23 +0200
Message-Id: <20210816151626.28770-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816151626.28770-1-fw@strlen.de>
References: <20210816151626.28770-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... by changing:

if (unlikely(ret < 0 || missed)) {
	if (ret < 0) {
to
if (likely(ret >= 0 && !missed))
	goto out;

if (ret < 0) {

After this nf_conntrack_eventmask_report and nf_ct_deliver_cached_events
look pretty much the same, next patch moves common code to a helper.

This patch has no effect on generated code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ecache.c | 34 +++++++++++++++--------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 3f1e0add58bc..127a0fa6ae43 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -165,25 +165,27 @@ int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 		goto out_unlock;
 
 	ret = notify->fcn(eventmask | missed, &item);
-	if (unlikely(ret < 0 || missed)) {
-		spin_lock_bh(&ct->lock);
-		if (ret < 0) {
-			/* This is a destroy event that has been
-			 * triggered by a process, we store the PORTID
-			 * to include it in the retransmission.
-			 */
-			if (eventmask & (1 << IPCT_DESTROY)) {
-				if (e->portid == 0 && portid != 0)
-					e->portid = portid;
-				e->state = NFCT_ECACHE_DESTROY_FAIL;
-			} else {
-				e->missed |= eventmask;
-			}
+	if (likely(ret >= 0 && !missed))
+		goto out_unlock;
+
+	spin_lock_bh(&ct->lock);
+	if (ret < 0) {
+		/* This is a destroy event that has been
+		 * triggered by a process, we store the PORTID
+		 * to include it in the retransmission.
+		 */
+		if (eventmask & (1 << IPCT_DESTROY)) {
+			if (e->portid == 0 && portid != 0)
+				e->portid = portid;
+			e->state = NFCT_ECACHE_DESTROY_FAIL;
 		} else {
-			e->missed &= ~missed;
+			e->missed |= eventmask;
 		}
-		spin_unlock_bh(&ct->lock);
+	} else {
+		e->missed &= ~missed;
 	}
+	spin_unlock_bh(&ct->lock);
+
 out_unlock:
 	rcu_read_unlock();
 	return ret;
-- 
2.31.1

