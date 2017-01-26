From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/14] netfilter: conntrack: remove GC_MAX_EVICTS break
Date: Thu, 26 Jan 2017 17:38:01 +0100
Message-ID: <1485448687-6072-9-git-send-email-pablo@netfilter.org>
References: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of breaking loop and instant resched, don't bother checking
this in first place (the loop calls cond_resched for every bucket anyway).

Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

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
2.1.4
