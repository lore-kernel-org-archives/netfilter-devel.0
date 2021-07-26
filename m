Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4BFC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 22:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6DA60F6E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 22:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGZVtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhGZVtL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 17:49:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB559C061757
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jul 2021 15:29:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m896O-0003Yy-T0; Tue, 27 Jul 2021 00:29:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH nf] netfilter: conntrack: collect all entries in one cycle
Date:   Tue, 27 Jul 2021 00:29:19 +0200
Message-Id: <20210726222919.5659-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michal Kubecek reports that conntrack gc is responsible for frequent
wakeups (every 125ms) on idle systems.

On busy systems, timed out entries are evicted during lookup.
The gc worker is only needed to remove entries after system becomes idle
after a busy period.

To resolve this, always scan the entire table.
If the scan is taking too long, reschedule so other work_structs can run
and resume from next bucket.

After a completed scan, wait for 2 minutes before the next cycle.
Heuristics for faster re-schedule are removed.

GC_SCAN_INTERVAL could be exposed as a sysctl in the future to allow
tuning this as-needed or even turn the gc worker off.

Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 67 +++++++++----------------------
 1 file changed, 19 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5c03e5106751..3fdcf251ec1f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,22 +66,17 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
-	u32			last_bucket;
+	u32			next_bucket;
 	bool			exiting;
 	bool			early_drop;
-	long			next_gc_run;
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
-/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
-#define GC_MAX_BUCKETS_DIV	128u
-/* upper bound of full table scan */
-#define GC_MAX_SCAN_JIFFIES	(16u * HZ)
-/* desired ratio of entries found to be expired */
-#define GC_EVICT_RATIO	50u
+#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -1363,17 +1358,13 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int min_interval = max(HZ / GC_MAX_BUCKETS_DIV, 1u);
-	unsigned int i, goal, buckets = 0, expired_count = 0;
-	unsigned int nf_conntrack_max95 = 0;
+	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
+	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
-	unsigned int ratio, scanned = 0;
-	unsigned long next_run;
-
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
-	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
-	i = gc_work->last_bucket;
+	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
@@ -1381,15 +1372,13 @@ static void gc_worker(struct work_struct *work)
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
 		struct hlist_nulls_node *n;
-		unsigned int hashsz;
 		struct nf_conn *tmp;
 
-		i++;
 		rcu_read_lock();
 
 		nf_conntrack_get_ht(&ct_hash, &hashsz);
 		if (i >= hashsz)
-			i = 0;
+			break;
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
@@ -1397,7 +1386,6 @@ static void gc_worker(struct work_struct *work)
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			scanned++;
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
 				continue;
@@ -1405,7 +1393,6 @@ static void gc_worker(struct work_struct *work)
 
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
-				expired_count++;
 				continue;
 			}
 
@@ -1438,7 +1425,14 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched();
-	} while (++buckets < goal);
+		i++;
+
+		if (time_after(jiffies, end_time) && i < hashsz) {
+			gc_work->next_bucket = i;
+			next_run = 0;
+			break;
+		}
+	} while (i < hashsz);
 
 	if (gc_work->exiting)
 		return;
@@ -1449,40 +1443,17 @@ static void gc_worker(struct work_struct *work)
 	 *
 	 * This worker is only here to reap expired entries when system went
 	 * idle after a busy period.
-	 *
-	 * The heuristics below are supposed to balance conflicting goals:
-	 *
-	 * 1. Minimize time until we notice a stale entry
-	 * 2. Maximize scan intervals to not waste cycles
-	 *
-	 * Normally, expire ratio will be close to 0.
-	 *
-	 * As soon as a sizeable fraction of the entries have expired
-	 * increase scan frequency.
 	 */
-	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio > GC_EVICT_RATIO) {
-		gc_work->next_gc_run = min_interval;
-	} else {
-		unsigned int max = GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV;
-
-		BUILD_BUG_ON((GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV) == 0);
-
-		gc_work->next_gc_run += min_interval;
-		if (gc_work->next_gc_run > max)
-			gc_work->next_gc_run = max;
+	if (next_run) {
+		gc_work->early_drop = false;
+		gc_work->next_bucket = 0;
 	}
-
-	next_run = gc_work->next_gc_run;
-	gc_work->last_bucket = i;
-	gc_work->early_drop = false;
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
 	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
-	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
 
-- 
2.31.1

