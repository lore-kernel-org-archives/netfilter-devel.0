From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: conntrack: resched gc again if eviction rate is high
Date: Fri, 19 Aug 2016 13:36:14 +0200
Message-ID: <1471606575-2197-6-git-send-email-fw@strlen.de>
References: <1471606575-2197-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56092 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753120AbcHSLgN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 07:36:13 -0400
In-Reply-To: <1471606575-2197-1-git-send-email-fw@strlen.de>
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
index 3b778d2..d5f8f34 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -938,6 +938,7 @@ static void gc_worker(struct work_struct *work)
 {
 	unsigned int i, goal, buckets = 0, expired_count = 0;
 	unsigned long next_run = GC_INTERVAL;
+	unsigned int ratio, scanned = 0;
 	struct conntrack_gc_work *gc_work;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
@@ -965,6 +966,7 @@ static void gc_worker(struct work_struct *work)
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
+			scanned++;
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				expired_count++;
@@ -980,6 +982,10 @@ static void gc_worker(struct work_struct *work)
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

