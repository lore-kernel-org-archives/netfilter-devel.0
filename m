From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 6/7] netfilter: conntrack: resched gc again if eviction rate is high
Date: Thu, 25 Aug 2016 15:33:34 +0200
Message-ID: <1472132015-10264-7-git-send-email-fw@strlen.de>
References: <1472132015-10264-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933975AbcHYNdq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 09:33:46 -0400
In-Reply-To: <1472132015-10264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we evicted a large fraction of the scanned conntrack entries re-schedule
the next gc cycle for immediate execution.

This triggers during tests where load is high, then drops to zero and
many connections will be in TW/CLOSE state with < 30 second timeouts.

Without this change it will take several minutes until conntrack count
comes back to normal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f95a9e9..7c66ce40 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -945,6 +945,7 @@ static void gc_worker(struct work_struct *work)
 {
 	unsigned int i, goal, buckets = 0, expired_count = 0;
 	unsigned long next_run = GC_INTERVAL;
+	unsigned int ratio, scanned = 0;
 	struct conntrack_gc_work *gc_work;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
@@ -969,6 +970,7 @@ static void gc_worker(struct work_struct *work)
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
+			scanned++;
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				expired_count++;
@@ -988,6 +990,10 @@ static void gc_worker(struct work_struct *work)
 	if (gc_work->exiting)
 		return;
 
+	ratio = scanned ? expired_count * 100 / scanned : 0;
+	if (ratio >= 90)
+		next_run = 0;
+
 	gc_work->last_bucket = i;
 	schedule_delayed_work(&gc_work->dwork, next_run);
 }
-- 
2.7.3

