Return-Path: <SRS0=Y4cQ=YG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CF9C4360C
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Oct 2019 18:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4579206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Oct 2019 18:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfJMSc6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Oct 2019 14:32:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34850 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbfJMSc6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Oct 2019 14:32:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iJifo-0007KM-B8; Sun, 13 Oct 2019 20:32:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ecache: document extension area access rules
Date:   Sun, 13 Oct 2019 20:19:45 +0200
Message-Id: <20191013181945.21578-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Once ct->ext gets free'd via kfree() rather than kfree_rcu we can't
access the extension area anymore without owning the conntrack.

This is a special case:

The worker is walking the pcpu dying list while holding dying list lock:
Neither ct nor ct->ext can be free'd until after the walk has completed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ecache.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 6fba74b5aaf7..0d83c159671c 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -30,6 +30,7 @@
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
 #define ECACHE_RETRY_WAIT (HZ/10)
+#define ECACHE_STACK_ALLOC (256 / sizeof(void *))
 
 enum retry_state {
 	STATE_CONGESTED,
@@ -39,11 +40,11 @@ enum retry_state {
 
 static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 {
-	struct nf_conn *refs[16];
+	struct nf_conn *refs[ECACHE_STACK_ALLOC];
+	enum retry_state ret = STATE_DONE;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	unsigned int evicted = 0;
-	enum retry_state ret = STATE_DONE;
 
 	spin_lock(&pcpu->lock);
 
@@ -54,10 +55,22 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 		if (!nf_ct_is_confirmed(ct))
 			continue;
 
+		/* This ecache access is safe because the ct is on the
+		 * pcpu dying list and we hold the spinlock -- the entry
+		 * cannot be free'd until after the lock is released.
+		 *
+		 * This is true even if ct has a refcount of 0: the
+		 * cpu that is about to free the entry must remove it
+		 * from the dying list and needs the lock to do so.
+		 */
 		e = nf_ct_ecache_find(ct);
 		if (!e || e->state != NFCT_ECACHE_DESTROY_FAIL)
 			continue;
 
+		/* ct is in NFCT_ECACHE_DESTROY_FAIL state, this means
+		 * the worker owns this entry: the ct will remain valid
+		 * until the worker puts its ct reference.
+		 */
 		if (nf_conntrack_event(IPCT_DESTROY, ct)) {
 			ret = STATE_CONGESTED;
 			break;
-- 
2.21.0

