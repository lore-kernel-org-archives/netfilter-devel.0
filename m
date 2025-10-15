Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909E118FDBD;
	Wed, 15 Oct 2025 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760535165; cv=none; b=aqyJC4iLgSDtY0Y3lEijC6/8lhMipdLnH1dDqhnVYPYqiY8jkDPrvAq9YOiv0JTh3wd+UtjpMZLaggDg9jxIDiQ1mVbjD2xIsF6qweKbVzg+6Bft+Pl/t14WYUqRVJEZ/pqx2vZ59pJWRDiRFBUdyTvkY8D5T/2FVJN+2lq7dng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760535165; c=relaxed/simple;
	bh=1BsLPLiMHPjgSqzewUxFT8Vz1eESX/i1E7QgjO2YW6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBPmp/J7Nis+jPDvT4Rnr6GXH5bTRlSioDRE4ZwPg9thKRZTe/14PKf+i9carAW/T5lnXckGFjelvlPICHRg2bTEBYUjH42Y78ZHscLDvfKKeg3wkVl7CSY3vCkflpYCwdJGVVIxWUnJDwe0A6OqxyWMA68T3t5psxh4vl/OyfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2ECBD60186; Wed, 15 Oct 2025 15:32:40 +0200 (CEST)
Date: Wed, 15 Oct 2025 15:32:39 +0200
From: Florian Westphal <fw@strlen.de>
To: avimalin@gmail.com
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	anirudh.gupta@sophos.com
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
Message-ID: <aO-id5W6Tr7frdHN@strlen.de>
References: <20250430071140.GA29525@breakpoint.cc>
 <20250430072810.63169-1-vimal.agrawal@sophos.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430072810.63169-1-vimal.agrawal@sophos.com>

avimalin@gmail.com <avimalin@gmail.com> wrote:
> Default initial gc scan interval of 60 secs is too long for system
> with low number of conntracks causing delay in conntrack deletion.
> It is affecting userspace which are replying on timely arrival of
> conntrack destroy event. So it is better that this is controlled
> through sysctl

Patch is fine.  I do wonder however if there are alternatives.
Rather than expose the gc interval (gc worker is internal implementation
detail, e.g. we could move back to per-ct timers theoretically).

What about something like this (untested):

[RFC] netfilter: conntrack: expedite evictions when userspace is subscribed to destroy events

Track number of soon-to-expire conntracks.
If enough entries are likely to expire within 1/2/4/8/16/32 second buckets,
then reschedule earlier than what the normal next value would be.

Do this only when userspace is listening to destroy event notifcations
via ctnetlink, otherwise its not relevant when a conntrack entry is
released.

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 210792a2275d..22274193b093 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -52,6 +52,8 @@
 #include <net/netns/hash.h>
 #include <net/ip.h>
 
+#include <uapi/linux/netfilter/nfnetlink.h>
+
 #include "nf_internals.h"
 
 __cacheline_aligned_in_smp spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
@@ -63,12 +65,15 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 struct hlist_nulls_head *nf_conntrack_hash __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
+#define GC_HORIZON_BUCKETS	6
+
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
 	u32			avg_timeout;
 	u32			count;
 	u32			start_time;
+	u8			horizon_count[GC_HORIZON_BUCKETS];
 	bool			exiting;
 	bool			early_drop;
 };
@@ -96,6 +101,10 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
+/* schedule worker earlier if this many entries are about to expire
+ * in the near future */
+#define GC_SCAN_EXPEDITED	min(255, (GC_HORIZON_BUCKETS * GC_SCAN_EXPIRED_MAX))
+
 #define MIN_CHAINLEN	50u
 #define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
@@ -1508,6 +1517,71 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 	return false;
 }
 
+static unsigned int gc_horizon_max(unsigned int i)
+{
+	return (1 << i) * HZ;
+}
+
+static void gc_horizon_account(struct conntrack_gc_work *gc, unsigned long expires)
+{
+	int i = ARRAY_SIZE(gc->horizon_count);
+
+	BUILD_BUG_ON(GC_SCAN_EXPEDITED > 255);
+
+	for (i = 0; i < ARRAY_SIZE(gc->horizon_count); i++) {
+		unsigned int max = gc_horizon_max(i);
+
+		if (gc->horizon_count[i] >= GC_SCAN_EXPEDITED)
+			return;
+
+		if (expires <= max) {
+			gc->horizon_count[i]++;
+			return;
+		}
+	}
+}
+
+static bool nf_ctnetlink_has_listeners(void)
+{
+	u8 v = READ_ONCE(nf_ctnetlink_has_listener);
+
+	return v & (1 << NFNLGRP_CONNTRACK_DESTROY);
+}
+
+/* schedule worker early if we have ctnetlink listeners that subscribed
+ * to CONNTRACK_DESTROY events so they receive more timely notifications.
+ *
+ * ->horizon_count[] contains the number of conntrack entries that are
+ *  about the expire in 1, 2, 4, 8, 16 and 32 seconds.
+ */
+static noinline unsigned long
+gc_horizon_next_run(const struct conntrack_gc_work *gc_work,
+		    unsigned long next_run, unsigned long delta_time)
+{
+	unsigned int count = 0;
+	unsigned int i;
+
+	if (next_run <= (unsigned long)delta_time)
+		return 1;
+
+	next_run -= delta_time;
+
+	if (!nf_ctnetlink_has_listeners())
+		return next_run;
+
+	for (i = 0; i < ARRAY_SIZE(gc_work->horizon_count); i++) {
+		count += gc_work->horizon_count[i];
+
+		if (count >= GC_SCAN_EXPEDITED) {
+			unsigned long new_next_run = gc_horizon_max(i);
+
+			return min(new_next_run, next_run);
+		}
+	}
+
+	return next_run;
+}
+
 static void gc_worker(struct work_struct *work)
 {
 	unsigned int i, hashsz;
@@ -1526,6 +1600,7 @@ static void gc_worker(struct work_struct *work)
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
 		gc_work->count = GC_SCAN_INITIAL_COUNT;
 		gc_work->start_time = start_time;
+		memset(gc_work->horizon_count, 0, sizeof(gc_work->horizon_count));
 	}
 
 	next_run = gc_work->avg_timeout;
@@ -1575,7 +1650,11 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
-			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			expires = nf_ct_expires(tmp);
+
+			gc_horizon_account(gc_work, expires);
+
+			expires = clamp(expires, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
 			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
 			net = nf_ct_net(tmp);
@@ -1633,10 +1712,7 @@ static void gc_worker(struct work_struct *work)
 	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
 
 	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
-	if (next_run > (unsigned long)delta_time)
-		next_run -= delta_time;
-	else
-		next_run = 1;
+	next_run = gc_horizon_next_run(gc_work, next_run, delta_time);
 
 early_exit:
 	if (gc_work->exiting)
