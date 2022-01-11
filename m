Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1EFC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 19:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiAKTo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 14:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiAKTo5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 14:44:57 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9BCC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 11:44:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n7N4g-0008Rk-Dk; Tue, 11 Jan 2022 20:44:54 +0100
Date:   Tue, 11 Jan 2022 20:44:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
Message-ID: <20220111194454.GF32500@breakpoint.cc>
References: <20211121170514.2595-1-fw@strlen.de>
 <YZzrgVYskeXzLuM5@salvia>
 <20211123133045.GM6326@breakpoint.cc>
 <YaaYK9i2hixxbs70@salvia>
 <20211201112454.GA2315@breakpoint.cc>
 <CAHsH6Gs9wX7-_DS8MA8QQZEFzzP1A2AMhAeqMcSOLda2GE_-5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHsH6Gs9wX7-_DS8MA8QQZEFzzP1A2AMhAeqMcSOLda2GE_-5Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eyal Birger <eyal.birger@gmail.com> wrote:

Hi Eyal,

> > AFAICS we may now schedule next run for 'right now' even though that
> > would not find any expired entries (they might all have a timeout of
> > 19s). Next round would reap no entries, then resched again immediately
> >
> > (the nf_ct_is_expired_next_run expire count assumes next run is in
> >  20s, not before).
> >
> > This would burn cycles for 19s before those entries can be expired.
> >
> > Not sure how to best avoid this, perhaps computing the remaining avg timeout
> > of the nf_ct_is_expired_next_run() candidates would help?
> 
> At least for us - where our load is mostly constant - using an avg
> seems like a good approach.

I gave avg a shot, here it is.
This restarts the gc worker whenever it ran for too long, just like
before, but this time there is also an inital limit on events/s
generated per cycle.

Next run is done based on the average (non-expired) timeouts.
There is an inital bias towards large values, this is to avoid a
immediate scan if there are just a few entries (users might have
lowered e.g. udp timeout to 1 second).

For Karels use case I fear that its not enough and sysctl patch
is still superior (provided default tuneables were changed).

Karel, Eyal, it would be nice if you could have a look or test this
is a more realistic scenario than my synflood one.

From 0ce5d16de93e0d33435734b3f267fd591572dcec Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 8 Nov 2021 12:32:03 +0100
Subject: [RFC] netfilter: conntrack: revisit gc autotuning

Please don't apply yet, contains a few stats+pr_debug that should
not be needed.

as of commit 4608fdfc07e1
("netfilter: conntrack: collect all entries in one cycle")
conntrack gc was changed to run every 2 minutes.

On systems where conntrack hash table is set to large value,
almost all evictions happen from gc worker rather than the packet
path due to hash table distribution.

This causes netlink event overflows when the events are collected.

This change collects average expiry of scanned entries and
reschedules to the average value, within 1 to 60 second interval.

To avoid event overflows, add upper threshold and ratelimit
to avoid this.  If more entries have to be evicted, reschedule
and restart 1 jiffy into the future.

Reported-by: Karel Rericha <karel@maxtel.cz>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 102 +++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 894a325d39f2..e7778218fa7c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -67,6 +67,10 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
+	u32			avg_timeout;
+	u32			start_time;
+	u32			resched;
+	u32			expired;
 	bool			exiting;
 	bool			early_drop;
 };
@@ -78,9 +82,24 @@ static __read_mostly bool nf_conntrack_locks_all;
 /* serialize hash resizes and nf_ct_iterate_cleanup */
 static DEFINE_MUTEX(nf_conntrack_mutex);
 
-#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_INTERVAL_MAX	(60ul * HZ)
+#define GC_SCAN_INTERVAL_MIN	(1ul * HZ)
+
+/* clamp timeouts to this value (TCP unacked) */
+#define GC_SCAN_INTERVAL_CLAMP	(300ul * HZ)
+
+/* large initial bias so that we don't scan often just because we have
+ * three entries with a 1s timeout.
+ */
+#define GC_SCAN_INTERVAL_INIT	INT_MAX
+
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
+#define CT_SINGLE_EVENT_SIZE	164	/* estimated size in byte of single event */
+
+/* inital throttling, about 8mb/s of event data */
+#define GC_SCAN_EXPIRED_MAX	(8 * 1024 * 1024 / CT_SINGLE_EVENT_SIZE / HZ)
+
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
@@ -1421,16 +1440,30 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
+	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
+	unsigned int expired_count = 0;
+	unsigned long next_run;
+	s32 delta_time;
+
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
+	if (i == 0) {
+		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->start_time = start_time;
+		gc_work->resched = 0;
+		gc_work->expired = 0;
+	}
+
+	next_run = gc_work->avg_timeout;
+
+	end_time = start_time + GC_SCAN_MAX_DURATION;
+
 	do {
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
@@ -1447,6 +1480,7 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
+			unsigned long expires;
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
@@ -1456,11 +1490,30 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
+			if (expired_count > GC_SCAN_EXPIRED_MAX) {
+				rcu_read_unlock();
+
+				gc_work->next_bucket = i;
+				gc_work->avg_timeout = next_run;
+				gc_work->resched++;
+
+				delta_time = nfct_time_stamp - gc_work->start_time;
+
+				next_run = delta_time < GC_SCAN_INTERVAL_MIN;
+				goto early_exit;
+			}
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
+				expired_count++;
+				gc_work->expired++;
 				continue;
 			}
 
+			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			next_run += expires;
+			next_run /= 2u;
+
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
@@ -1478,8 +1531,11 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
-			if (gc_worker_can_early_drop(tmp))
+			if (gc_worker_can_early_drop(tmp)) {
 				nf_ct_kill(tmp);
+				expired_count++;
+				gc_work->expired++;
+			}
 
 			nf_ct_put(tmp);
 		}
@@ -1492,33 +1548,45 @@ static void gc_worker(struct work_struct *work)
 		cond_resched();
 		i++;
 
-		if (time_after(jiffies, end_time) && i < hashsz) {
+		delta_time = nfct_time_stamp - end_time;
+		if (delta_time > 0 && i < hashsz) {
+			gc_work->avg_timeout = next_run;
 			gc_work->next_bucket = i;
+			gc_work->resched++;
 			next_run = 0;
-			break;
+			goto early_exit;
 		}
 	} while (i < hashsz);
 
+	gc_work->next_bucket = 0;
+
+	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
+
+	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
+	if (next_run > (unsigned long)delta_time)
+		next_run -= delta_time;
+	else
+		next_run = 1;
+
+early_exit:
 	if (gc_work->exiting)
 		return;
 
-	/*
-	 * Eviction will normally happen from the packet path, and not
-	 * from this gc worker.
-	 *
-	 * This worker is only here to reap expired entries when system went
-	 * idle after a busy period.
-	 */
-	if (next_run) {
+	cond_resched();
+
+	if (next_run)
 		gc_work->early_drop = false;
-		gc_work->next_bucket = 0;
-	}
+
+	gc_work->resched++;
+	if (next_run > 1)
+		pr_debug("next run in %u ms expired %u in %u ms, re-sched count %u\n", jiffies_to_msecs(next_run), gc_work->expired, jiffies_to_msecs(delta_time), gc_work->resched - 1);
+
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
+	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
 	gc_work->exiting = false;
 }
 
-- 
2.34.1

