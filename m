From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: refine gc worker heuristics
Date: Tue,  1 Nov 2016 21:01:40 +0100
Message-ID: <1478030500-28981-1-git-send-email-fw@strlen.de>
Cc: nicolas.dichtel@6wind.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49844 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754162AbcKAUB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 16:01:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicholas Dichtel says:
  After commit b87a2f9199ea ("netfilter: conntrack: add gc worker to
  remove timed-out entries"), netlink conntrack deletion events may be
  sent with a huge delay.

Nicholas further points at this line:

  goal = min(nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV, GC_MAX_BUCKETS);

and indeed, this isn't optimal at all.  Rationale here was to ensure that
we don't block other work items for too long, even if
nf_conntrack_htable_size is huge.  But in order to have some guarantee
about maximum time period where a scan of the full conntrack table
completes we should always use a fixed slice size, so that once every
N scans the full table has been examined at least once.

We also need to balance this vs. the case where the system is either idle
(i.e., conntrack table (almost) empty) or very busy (i.e. eviction happens
from packet path).

So, after some discussion with Nicholas:

1. want hard guarantee that we scan entire table at least once every X s
-> need to scan fraction of table (get rid of upper bound)

2. don't want to eat cycles on idle or very busy system
-> increase interval if we did not evict any entries

3. don't want to block other worker items for too long
-> make fraction really small, and prefer small scan interval instead

4. Want reasonable short time where we detect timed-out entry when
system went idle after a burst of traffic, while not doing scans
all the time.
-> Store next gc scan in worker, increasing delays when no eviction
happened and shrinking delay when we see timed out entries.

The old gc interval is turned into a max number, scans can now happen
every jiffy if stale entries are present.

Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Nicholas is currently away; I would like to get his feedback on this
 one before it gets applied.

 I am submitting it now so others can review too.

 net/netfilter/nf_conntrack_core.c | 53 +++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index df2f5a3901df..0ff2a4c79e18 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -76,6 +76,7 @@ struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			last_bucket;
 	bool			exiting;
+	long			next_gc_run;
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
@@ -83,9 +84,11 @@ static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
 static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
-#define GC_MAX_BUCKETS_DIV	64u
-#define GC_MAX_BUCKETS		8192u
-#define GC_INTERVAL		(5 * HZ)
+/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
+#define GC_MAX_BUCKETS_DIV	1024u
+/* upper bound of scan intervals */
+#define GC_INTERVAL_MAX		(10 * HZ)
+/* maximum conntracks to evict per gc run */
 #define GC_MAX_EVICTS		256u
 
 static struct conntrack_gc_work conntrack_gc_work;
@@ -936,14 +939,16 @@ static noinline int early_drop(struct net *net, unsigned int _hash)
 static void gc_worker(struct work_struct *work)
 {
 	unsigned int i, goal, buckets = 0, expired_count = 0;
-	unsigned long next_run = GC_INTERVAL;
-	unsigned int ratio, scanned = 0;
+	unsigned long end_time, next_run;
 	struct conntrack_gc_work *gc_work;
+	unsigned int ratio, scanned = 0;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
-	goal = min(nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV, GC_MAX_BUCKETS);
+	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
+	next_run = gc_work->next_gc_run;
 	i = gc_work->last_bucket;
+	end_time = jiffies + 2u;
 
 	do {
 		struct nf_conntrack_tuple_hash *h;
@@ -977,14 +982,45 @@ static void gc_worker(struct work_struct *work)
 		rcu_read_unlock();
 		cond_resched_rcu_qs();
 	} while (++buckets < goal &&
+		 i != gc_work->last_bucket &&
 		 expired_count < GC_MAX_EVICTS);
 
 	if (gc_work->exiting)
 		return;
 
+	/*
+	 * Eviction will normally happen from the packet path, and not
+	 * from this gc worker.
+	 *
+	 * This worker is only here to reap expired entries when system went
+	 * idle after a busy period.
+	 *
+	 * The heuristics below are supposed to balance conflicting goals:
+	 *
+	 * 1. Minimize time until we notice a stale entry
+	 * 2. Maximize scan intervals to not waste cycles
+	 *
+	 * Normally, expired_count will be 0, this increases the next_run time
+	 * to prioritize 2) above.
+	 *
+	 * As soon as a timed-out entry is found, move towards 1) and increase
+	 * the scan frequency.
+	 * In case we have lots of evictions (more than 75% stale
+	 * entries or entire budget consumed), ask for instant re-scan.
+	 */
 	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio >= 90 || expired_count == GC_MAX_EVICTS)
+	if (ratio >= 90 || expired_count == GC_MAX_EVICTS) {
+		gc_work->next_gc_run = 0;
 		next_run = 0;
+	} else if (expired_count) {
+		gc_work->next_gc_run /= 2U;
+		next_run = msecs_to_jiffies(1);
+	} else {
+		if (gc_work->next_gc_run < GC_INTERVAL_MAX)
+			gc_work->next_gc_run += msecs_to_jiffies(1);
+
+		next_run = gc_work->next_gc_run;
+	}
 
 	gc_work->last_bucket = i;
 	schedule_delayed_work(&gc_work->dwork, next_run);
@@ -993,6 +1029,7 @@ static void gc_worker(struct work_struct *work)
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
 	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
+	gc_work->next_gc_run = GC_INTERVAL_MAX;
 	gc_work->exiting = false;
 }
 
@@ -1885,7 +1922,7 @@ int nf_conntrack_init_start(void)
 	nf_ct_untracked_status_or(IPS_CONFIRMED | IPS_UNTRACKED);
 
 	conntrack_gc_work_init(&conntrack_gc_work);
-	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL);
+	schedule_delayed_work(&conntrack_gc_work.dwork, GC_INTERVAL_MAX);
 
 	return 0;
 
-- 
2.7.3

