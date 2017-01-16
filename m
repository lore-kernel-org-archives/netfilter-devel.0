From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: remove GC_MAX_EVICTS break
Date: Mon, 16 Jan 2017 18:24:56 +0100
Message-ID: <1484587496-24177-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51140 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751039AbdAPRYj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 12:24:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of breaking loop and instant resched, don't bother checking
this in first place (the loop calls cond_resched for every bucket anyway).

Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
As Nicolas suggested, split this part in its own commit.

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3a073cd9fcf4..6feb5d370319 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -88,8 +88,6 @@ static __read_mostly bool nf_conntrack_locks_all;
 #define GC_MAX_BUCKETS_DIV	64u
 /* upper bound of scan intervals */
 #define GC_INTERVAL_MAX		(2 * HZ)
-/* maximum conntracks to evict per gc run */
-#define GC_MAX_EVICTS		256u
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -979,8 +977,7 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched_rcu_qs();
-	} while (++buckets < goal &&
-		 expired_count < GC_MAX_EVICTS);
+	} while (++buckets < goal);
 
 	if (gc_work->exiting)
 		return;
@@ -1005,7 +1002,7 @@ static void gc_worker(struct work_struct *work)
 	 * In case we have lots of evictions next scan is done immediately.
 	 */
 	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio >= 90 || expired_count == GC_MAX_EVICTS) {
+	if (ratio >= 90) {
 		gc_work->next_gc_run = 0;
 		next_run = 0;
 	} else if (expired_count) {
-- 
2.7.3

