Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A37C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhK3Veu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 16:34:50 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51732 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344179AbhK3Ves (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 16:34:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5463C6063B;
        Tue, 30 Nov 2021 22:29:11 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:31:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
Message-ID: <YaaYK9i2hixxbs70@salvia>
References: <20211121170514.2595-1-fw@strlen.de>
 <YZzrgVYskeXzLuM5@salvia>
 <20211123133045.GM6326@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JHzOMhs8HO/w5pMi"
Content-Disposition: inline
In-Reply-To: <20211123133045.GM6326@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--JHzOMhs8HO/w5pMi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Nov 23, 2021 at 02:30:45PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi,
> > 
> > On Sun, Nov 21, 2021 at 06:05:14PM +0100, Florian Westphal wrote:
> > > as of commit 4608fdfc07e1
> > > ("netfilter: conntrack: collect all entries in one cycle")
> > > conntrack gc was changed to run periodically every 2 minutes.
> > > 
> > > On systems where conntrack hash table is set to large value,
> > > almost all evictions happen from gc worker rather than the packet
> > > path due to hash table distribution.
> > > 
> > > This causes netlink event overflows when the events are collected.
> > 
> > If the issue is netlink, it should be possible to batch netlink
> > events.
> 
> I do not see how.

I started a patchset, but the single hashtable for every netns might
defeat the batching, if there is a table per netns then it should be
similar to 67cc570edaa0.

But this would be a large patch though to address this issue, so see
below.

> > > 1. gc interval (milliseconds, default: 2 minutes)
> > > 2. buckets per cycle (default: UINT_MAX / all)
> > > 
> > > This allows to increase the scan intervals but also to reduce bustiness
> > > by switching to partial scans of the table for each cycle.
> > 
> > Is there a way to apply autotuning? I know, this question might be
> > hard, but when does the user has update this new toggle?
> 
> Whenever you need to timely delivery of events, or you need timely
> reaping of outdated entries.
> 
> And we can't increase scan frequency because that will cause
> more wakeups on otherwise idle systems, that was the entire reason
> for going with 2m.

Default 2m is probably too large? This should be set at least to the
UDP unreplied timeout, ie. 30s?

> > And do we know what value should be placed here?
> 
> I tried, did not work out (see history of gc worker).

Probably set default scan interval to 20s and reduce it if there is
workload coming in the next scan round? It is possible to count for
the number of entries that will expired in the next round, if this
represents a large % of entries, then reduce the scan interval of the
vgarbage collector.

I'm attaching a patch.

--JHzOMhs8HO/w5pMi
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="ct-gc-adapt.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..3f6731a9c722 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -77,7 +77,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 /* serialize hash resizes and nf_ct_iterate_cleanup */
 static DEFINE_MUTEX(nf_conntrack_mutex);
 
-#define GC_SCAN_INTERVAL	(120u * HZ)
+/* Scan every 20 seconds which is 2/3 of the UDP unreplied timeout. */
+#define GC_SCAN_INTERVAL	(20u * HZ)
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
 #define MIN_CHAINLEN	8u
@@ -1418,12 +1419,22 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	return false;
 }
 
+static bool nf_ct_is_expired_next_run(const struct nf_conn *ct)
+{
+	unsigned long next_timestamp = nfct_time_stamp + GC_SCAN_INTERVAL;
+
+	return (__s32)(ct->timeout - next_timestamp) <= 0;
+}
+
 static void gc_worker(struct work_struct *work)
 {
+	unsigned long next_run_expired_entries = 0, entries = 0, idle;
 	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
 	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
+	bool next_run_expired;
+
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
@@ -1448,6 +1459,8 @@ static void gc_worker(struct work_struct *work)
 			struct nf_conntrack_net *cnet;
 			struct net *net;
 
+			next_run_expired = false;
+			entries++;
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
@@ -1458,6 +1471,9 @@ static void gc_worker(struct work_struct *work)
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				continue;
+			} else if (nf_ct_is_expired_next_run(tmp)) {
+				next_run_expired = true;
+				next_run_expired_entries++;
 			}
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
@@ -1477,8 +1493,12 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
-			if (gc_worker_can_early_drop(tmp))
+			if (gc_worker_can_early_drop(tmp)) {
+				if (next_run_expired)
+					next_run_expired_entries--;
+
 				nf_ct_kill(tmp);
+			}
 
 			nf_ct_put(tmp);
 		}
@@ -1511,7 +1531,22 @@ static void gc_worker(struct work_struct *work)
 	if (next_run) {
 		gc_work->early_drop = false;
 		gc_work->next_bucket = 0;
+		/*
+		 * Calculate gc workload for the next run, adjust the gc
+		 * interval not to reap expired entries in bursts.
+		 *
+		 * Adjust scan interval linearly based on the percentage of
+		 * entries that will expire in the next run. The scan interval
+		 * is inversely proportional to the workload.
+		 */
+		if (entries == 0) {
+			next_run = GC_SCAN_INTERVAL;
+		} else {
+			idle = 100u - (next_run_expired_entries * 100u / entries);
+			next_run = GC_SCAN_INTERVAL * idle / 100u;
+		}
 	}
+
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 

--JHzOMhs8HO/w5pMi--
