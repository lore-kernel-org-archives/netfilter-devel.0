Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465A337BB2
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361307; cv=none; b=n22irLT0y+xXpTZBcXPjOySBzBIzinN8l4fUWjDPYazKwHjwDhmzjTxjQ7WT6y+kqVTaVCcs+zhDboo9MSqA0yfWeJeCgi0gmrCo/w54v5jKCdQ69zunlrVc6PSkL2bFXgx9FyTXSqE4D4MvZYrLzO583NdTiqZXlvxVnn5IiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361307; c=relaxed/simple;
	bh=XIWgS3ovNUwLyxOVJ6ba5HZUex1kyVyNutEM2y7WlYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVlxS7GgikM3RZRtN6bUQiIsAbunENmO3uSDuLNSTU2G2B/EayPgL2uuhpRUqOlQddjLscCp6UXL0PvZKUp+hgEjxOWdeCHUKs86isgg1rfCws7V1jPW6mHioPeuzjPeliZ5zC1RxqNipwYxxa6uJvYGs70f3SKItgWdQx2xD10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 85564603CA; Wed,  5 Nov 2025 17:48:23 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 02/11] netfilter: conntrack: don't schedule gc worker when table is empty
Date: Wed,  5 Nov 2025 17:47:56 +0100
Message-ID: <20251105164805.3992-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to wakeup every minute when there are no entries.

Instead of doing a scan at least once a minute, check of the worker
is pending (its expected to be except on idle system) and queue it
if its not.

In case the gc worker was executing at time of check (means, it wasn't
pending), then the gc worker should re-run at the newly computed next_run
interval.  Switch it to mod_delayed_work() to allow this.

While at it, get rid of 'exiting' toggle:
use disable_delayed_work_sync instead of the 'cancel_' version at exit
time to prevent rearming.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 210792a2275d..fa6e5047d15b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -69,7 +69,6 @@ struct conntrack_gc_work {
 	u32			avg_timeout;
 	u32			count;
 	u32			start_time;
-	bool			exiting;
 	bool			early_drop;
 };
 
@@ -91,7 +90,7 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
  * allowing non-idle machines to wakeup more often when needed.
  */
 #define GC_SCAN_INITIAL_COUNT	100
-#define GC_SCAN_INTERVAL_INIT	GC_SCAN_INTERVAL_MAX
+#define GC_SCAN_INTERVAL_INIT	(GC_SCAN_INTERVAL_MAX / 2)
 
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
@@ -1639,19 +1638,17 @@ static void gc_worker(struct work_struct *work)
 		next_run = 1;
 
 early_exit:
-	if (gc_work->exiting)
-		return;
-
 	if (next_run)
 		gc_work->early_drop = false;
 
-	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
+	if (gc_work->count > GC_SCAN_INITIAL_COUNT || gc_work->next_bucket > 0)
+		mod_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
+	/* work is started on first conntrack allocation. */
 	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
-	gc_work->exiting = false;
 }
 
 static struct nf_conn *
@@ -1709,6 +1706,15 @@ __nf_conntrack_alloc(struct net *net,
 	 * this is inserted in any list.
 	 */
 	refcount_set(&ct->ct_general.use, 0);
+
+	/* Re-arm gc_work if needed, but do not modify
+	 * in case it was already pending.
+	 */
+	if (unlikely(!delayed_work_pending(&conntrack_gc_work.dwork)))
+		queue_delayed_work(system_power_efficient_wq,
+				   &conntrack_gc_work.dwork,
+				   GC_SCAN_INTERVAL_INIT);
+
 	return ct;
 out:
 	atomic_dec(&cnet->count);
@@ -2458,13 +2464,12 @@ static int kill_all(struct nf_conn *i, void *data)
 void nf_conntrack_cleanup_start(void)
 {
 	cleanup_nf_conntrack_bpf();
-	conntrack_gc_work.exiting = true;
 }
 
 void nf_conntrack_cleanup_end(void)
 {
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
-	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
+	disable_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
 
 	nf_conntrack_proto_fini();
@@ -2687,7 +2692,6 @@ int nf_conntrack_init_start(void)
 		goto err_proto;
 
 	conntrack_gc_work_init(&conntrack_gc_work);
-	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
 	ret = register_nf_conntrack_bpf();
 	if (ret < 0)
-- 
2.51.0

