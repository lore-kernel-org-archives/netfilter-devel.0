From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf-next-2.6] xt_rateest: Better struct xt_rateest layout
Date: Mon, 07 Jun 2010 22:17:17 +0200
Message-ID: <1275941837.2775.7.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We currently dirty two cache lines in struct xt_rateest, this hurts SMP
performance.

This patch moves lock/bstats/rstats at beginning of structure so that
they share a single cache line.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/netfilter/xt_rateest.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_rateest.h b/include/net/netfilter/xt_rateest.h
index ddbf37e..b1d780e 100644
--- a/include/net/netfilter/xt_rateest.h
+++ b/include/net/netfilter/xt_rateest.h
@@ -2,13 +2,17 @@
 #define _XT_RATEEST_H
 
 struct xt_rateest {
+	/* keep lock and bstats on same cache line to speedup xt_rateest_tg() */
+	struct gnet_stats_basic_packed	bstats;
+	spinlock_t			lock;
+	/* keep rstats and lock on same cache line to speedup xt_rateest_mt() */
+	struct gnet_stats_rate_est	rstats;
+
+	/* following fields not accessed in hot path */
 	struct hlist_node		list;
 	char				name[IFNAMSIZ];
 	unsigned int			refcnt;
-	spinlock_t			lock;
 	struct gnet_estimator		params;
-	struct gnet_stats_rate_est	rstats;
-	struct gnet_stats_basic_packed	bstats;
 };
 
 extern struct xt_rateest *xt_rateest_lookup(const char *name);


