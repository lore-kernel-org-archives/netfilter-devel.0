Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689F1C33C99
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 11:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BCBC2077B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 11:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgAGLZW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 06:25:22 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbgAGLZV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 06:25:21 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iomz9-0002rQ-QH; Tue, 07 Jan 2020 12:25:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: hashlimit: do not use indirect calls during gc
Date:   Tue,  7 Jan 2020 12:25:10 +0100
Message-Id: <20200107112510.5744-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

no need, just use a simple boolean to indicate we want to reap all
entries.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is an old patch I had floating around in an odd working branch,
 I think this makes the cleanup logic easier to follow.
 If you disagree just drop this.

 net/netfilter/xt_hashlimit.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index ced3fc8fad7c..bccd47cd7190 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -357,21 +357,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	return 0;
 }
 
-static bool select_all(const struct xt_hashlimit_htable *ht,
-		       const struct dsthash_ent *he)
-{
-	return true;
-}
-
-static bool select_gc(const struct xt_hashlimit_htable *ht,
-		      const struct dsthash_ent *he)
-{
-	return time_after_eq(jiffies, he->expires);
-}
-
-static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-			bool (*select)(const struct xt_hashlimit_htable *ht,
-				      const struct dsthash_ent *he))
+static void htable_selective_cleanup(struct xt_hashlimit_htable *ht, bool select_all)
 {
 	unsigned int i;
 
@@ -381,7 +367,7 @@ static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
 
 		spin_lock_bh(&ht->lock);
 		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
-			if ((*select)(ht, dh))
+			if (time_after_eq(jiffies, dh->expires) || select_all)
 				dsthash_free(ht, dh);
 		}
 		spin_unlock_bh(&ht->lock);
@@ -395,7 +381,7 @@ static void htable_gc(struct work_struct *work)
 
 	ht = container_of(work, struct xt_hashlimit_htable, gc_work.work);
 
-	htable_selective_cleanup(ht, select_gc);
+	htable_selective_cleanup(ht, false);
 
 	queue_delayed_work(system_power_efficient_wq,
 			   &ht->gc_work, msecs_to_jiffies(ht->cfg.gc_interval));
@@ -419,7 +405,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
 	cancel_delayed_work_sync(&hinfo->gc_work);
 	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, select_all);
+	htable_selective_cleanup(hinfo, true);
 	kfree(hinfo->name);
 	vfree(hinfo);
 }
-- 
2.24.1

