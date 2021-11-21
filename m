Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CB8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 17:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhKURI3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 12:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhKURI3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 12:08:29 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DDAC061574
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 09:05:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1moqHK-0005mR-5o; Sun, 21 Nov 2021 18:05:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
Date:   Sun, 21 Nov 2021 18:05:14 +0100
Message-Id: <20211121170514.2595-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

as of commit 4608fdfc07e1
("netfilter: conntrack: collect all entries in one cycle")
conntrack gc was changed to run periodically every 2 minutes.

On systems where conntrack hash table is set to large value,
almost all evictions happen from gc worker rather than the packet
path due to hash table distribution.

This causes netlink event overflows when the events are collected.
This change exposes two sysctls:

1. gc interval (milliseconds, default: 2 minutes)
2. buckets per cycle (default: UINT_MAX / all)

This allows to increase the scan intervals but also to reduce bustiness
by switching to partial scans of the table for each cycle.

If scan is changed to partial mode, next cycle resumes with next bucket.

The defaults keep current behaviour.

Reported-by: Karel Rericha <karel@maxtel.cz>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is an alternative to Eyals patch.
 gc_interval is in millseconds rather than seconds and
 new gc_buckets can be used to switch the gc behaviour to
 a partial scan.

 For example you could configure it to scan at most 100
 buckets every 10ms, which would scan about 10k entries/s.

 If you think the extra complexity of gc_buckets is unwanted
 I would suggest that Eyal submits a v3 with gc_interval in ms
 units.

 .../networking/nf_conntrack-sysctl.rst        | 13 ++++++++++
 include/net/netfilter/nf_conntrack.h          |  2 ++
 net/netfilter/nf_conntrack_core.c             | 25 ++++++++++++++-----
 net/netfilter/nf_conntrack_standalone.c       | 24 ++++++++++++++++++
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 311128abb768..26767a495406 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -61,6 +61,19 @@ nf_conntrack_frag6_timeout - INTEGER (seconds)
 
 	Time to keep an IPv6 fragment in memory.
 
+nf_conntrack_gc_buckets - INTEGER
+        default 4294967295
+
+	Number of buckets to scan during one gc cycle.
+        If the value is less than nf_conntrack_buckets, gc will return
+        early and next cycle resumes at the next unscanned bucket.
+        Default is to scan entire table per cycle.
+
+nf_conntrack_gc_interval - INTEGER (milliseconds)
+        default 120000 (2 minutes)
+
+        Garbage collector Interval (in milliseconds).
+
 nf_conntrack_generic_timeout - INTEGER (seconds)
 	default 600
 
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index cc663c68ddc4..ebaf36917c36 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -313,6 +313,8 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
+extern unsigned long nf_conntrack_gc_interval;
+extern unsigned int nf_conntrack_gc_buckets;
 extern unsigned int nf_conntrack_max;
 
 /* must be called with rcu read lock held */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 054ee9d25efe..0c789ee65e71 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,6 +66,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
+	u32			buckets;
 	bool			exiting;
 	bool			early_drop;
 };
@@ -83,6 +84,9 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
 
+unsigned long __read_mostly nf_conntrack_gc_interval = GC_SCAN_INTERVAL;
+unsigned int __read_mostly nf_conntrack_gc_buckets = UINT_MAX;
+
 static struct conntrack_gc_work conntrack_gc_work;
 
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
@@ -1421,12 +1425,17 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 static void gc_worker(struct work_struct *work)
 {
 	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
+	unsigned long next_run = nf_conntrack_gc_interval;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
+	unsigned int buckets;
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
+	buckets = gc_work->buckets;
+	gc_work->buckets = 0;
+
 	i = gc_work->next_bucket;
+	gc_work->next_bucket = 0;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
@@ -1491,7 +1500,12 @@ static void gc_worker(struct work_struct *work)
 		cond_resched();
 		i++;
 
+		if (++buckets >= nf_conntrack_gc_buckets) {
+			gc_work->next_bucket = i;
+			break;
+		}
 		if (time_after(jiffies, end_time) && i < hashsz) {
+			gc_work->buckets = buckets;
 			gc_work->next_bucket = i;
 			next_run = 0;
 			break;
@@ -1508,16 +1522,15 @@ static void gc_worker(struct work_struct *work)
 	 * This worker is only here to reap expired entries when system went
 	 * idle after a busy period.
 	 */
-	if (next_run) {
+	if (next_run)
 		gc_work->early_drop = false;
-		gc_work->next_bucket = 0;
-	}
+
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
+	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
 	gc_work->exiting = false;
 }
 
@@ -2743,7 +2756,7 @@ int nf_conntrack_init_start(void)
 		goto err_proto;
 
 	conntrack_gc_work_init(&conntrack_gc_work);
-	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
+	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, 10 * HZ);
 
 	return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 80f675d884b2..38c9d0a3c898 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -554,6 +554,8 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_MAX,
 	NF_SYSCTL_CT_COUNT,
 	NF_SYSCTL_CT_BUCKETS,
+	NF_SYSCTL_CT_GC_BUCKETS,
+	NF_SYSCTL_CT_GC_INTERVAL,
 	NF_SYSCTL_CT_CHECKSUM,
 	NF_SYSCTL_CT_LOG_INVALID,
 	NF_SYSCTL_CT_EXPECT_MAX,
@@ -624,6 +626,9 @@ enum nf_ct_sysctl_index {
 
 #define NF_SYSCTL_CT_LAST_SYSCTL (__NF_SYSCTL_CT_LAST_SYSCTL + 1)
 
+static const unsigned long max_scan_interval = 1 * 24 * 60 * 60 * HZ;
+static const unsigned long min_scan_interval = 1;
+
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
@@ -645,6 +650,23 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = nf_conntrack_hash_sysctl,
 	},
+	[NF_SYSCTL_CT_GC_BUCKETS] = {
+		.procname       = "nf_conntrack_gc_buckets",
+		.data           = &nf_conntrack_gc_buckets,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+	[NF_SYSCTL_CT_GC_INTERVAL] = {
+		.procname       = "nf_conntrack_gc_interval",
+		.data           = &nf_conntrack_gc_interval,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
+		.extra1		= (void *)&min_scan_interval,
+		.extra2		= (void *)&max_scan_interval,
+	},
 	[NF_SYSCTL_CT_CHECKSUM] = {
 		.procname	= "nf_conntrack_checksum",
 		.data		= &init_net.ct.sysctl_checksum,
@@ -1123,6 +1145,8 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
+		table[NF_SYSCTL_CT_GC_BUCKETS].mode = 0444;
+		table[NF_SYSCTL_CT_GC_INTERVAL].mode = 0444;
 	}
 
 	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
-- 
2.32.0

