From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: refine gc worker heuristics, redux
Date: Mon, 16 Jan 2017 11:56:06 +0100
Message-ID: <1484564166-5886-1-git-send-email-fw@strlen.de>
Cc: nuclearcat@nuclearcat.com, Florian Westphal <fw@strlen.de>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49518 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750939AbdAPKzy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 05:55:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This further refines the changes made to conntrack gc_worker in
commit e0df8cae6c16 ("netfilter: conntrack: refine gc worker heuristics").

The main of this change is to reduce the scan interval when evictions
take place.

However, on the reporters' setup, there are 1-2 Million conntrack entries
in total, and roughly 8k new connections per second.

In this case we'll always evict at least one entry per gc cycle and scan
interval is always at 1 jiffy.

Given we scan ~10k entries per run its clearly wrong to reduce interval
based on number of evictions, it will only waste cpu cycles.

Thus only look at the ratio (scanned entries vs. evicted entries) to make
a decision on whether to reduce or not.

Given the fact that evictor is supposed to only kick in when system turns
idle after a busy period, we should pick a high ratio -- this makes it 50%.

Also, get rid of GC_MAX_EVICTS.  Instead of breaking loop and instant
resched, just don't bother checking this at all (the loop calls
cond_resched for every bucket anyway).

Removal of GC_MAX_EVICTS was suggested by Nicolas in the past; I
should have listened.

I tested this with a vm under synflood (with
sysctl net.netfilter.nf_conntrack_tcp_timeout_syn_recv=3).

While flood is ongoing, interval now stays at 2 seconds even though
evictions are ongoing.

After stopping flood, table got cleaned up in less than 10 seconds.

Reported-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Fixes: b87a2f9199ea82eaadc ("netfilter: conntrack: add gc worker to remove timed-out entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3a073cd9fcf4..6c4a1311f401 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -88,8 +88,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_MAX_BUCKETS_DIV	64u
 /* upper bound of scan intervals */
 #define GC_INTERVAL_MAX		(2 * HZ)
-/* maximum conntracks to evict per gc run */
-#define GC_MAX_EVICTS		256u
+/* desired ratio of entries found to be expired */
+#define GC_EVICT_RATIO	50u
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -979,8 +979,7 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched_rcu_qs();
-	} while (++buckets < goal &&
-		 expired_count < GC_MAX_EVICTS);
+	} while (++buckets < goal);
 
 	if (gc_work->exiting)
 		return;
@@ -997,26 +996,19 @@ static void gc_worker(struct work_struct *work)
 	 * 1. Minimize time until we notice a stale entry
 	 * 2. Maximize scan intervals to not waste cycles
 	 *
-	 * Normally, expired_count will be 0, this increases the next_run time
-	 * to priorize 2) above.
+	 * Normally, expire ratio will be close to 0.
 	 *
-	 * As soon as a timed-out entry is found, move towards 1) and increase
-	 * the scan frequency.
-	 * In case we have lots of evictions next scan is done immediately.
+	 * As soon as a sizeable fraction of the entries have expired
+	 * increase scan frequency.
 	 */
+	if (gc_work->next_gc_run < GC_INTERVAL_MAX)
+		gc_work->next_gc_run += msecs_to_jiffies(10);
+
 	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio >= 90 || expired_count == GC_MAX_EVICTS) {
-		gc_work->next_gc_run = 0;
-		next_run = 0;
-	} else if (expired_count) {
+	if (ratio > GC_EVICT_RATIO)
 		gc_work->next_gc_run /= 2U;
-		next_run = msecs_to_jiffies(1);
-	} else {
-		if (gc_work->next_gc_run < GC_INTERVAL_MAX)
-			gc_work->next_gc_run += msecs_to_jiffies(1);
 
-		next_run = gc_work->next_gc_run;
-	}
+	next_run = gc_work->next_gc_run;
 
 	gc_work->last_bucket = i;
 	queue_delayed_work(system_long_wq, &gc_work->dwork, next_run);
-- 
2.7.3

