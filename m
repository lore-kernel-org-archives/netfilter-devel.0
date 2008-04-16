From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 09/13] [NETFILTER]: Give AF-independent extensions an arpt_ alias
Date: Wed, 16 Apr 2008 17:31:01 +0200
Message-ID: <91861f4c76b9ab7aab029d495028ec29269e3975.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38090 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbYDPPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:09 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/xt_CLASSIFY.c  |    1 +
 net/netfilter/xt_MARK.c      |    1 +
 net/netfilter/xt_RATEEST.c   |    1 +
 net/netfilter/xt_limit.c     |    1 +
 net/netfilter/xt_mark.c      |    1 +
 net/netfilter/xt_quota.c     |    1 +
 net/netfilter/xt_rateest.c   |    1 +
 net/netfilter/xt_statistic.c |    1 +
 net/netfilter/xt_time.c      |    1 +
 net/netfilter/xt_u32.c       |    1 +
 10 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 8cffa29..37093e0 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -25,6 +25,7 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: Qdisc classification");
 MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
+MODULE_ALIAS("arpt_CLASSIFY");
 
 static unsigned int
 classify_tg(struct sk_buff *skb, const struct net_device *in,
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index c8ea7a8..d1ef197 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -23,6 +23,7 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("Xtables: packet mark modification");
 MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
+MODULE_ALIAS("arpt_MARK");
 
 static unsigned int
 mark_tg_v0(struct sk_buff *skb, const struct net_device *in,
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index da7946e..d717131 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -190,5 +190,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: packet rate estimator");
 MODULE_ALIAS("ipt_RATEEST");
 MODULE_ALIAS("ip6t_RATEEST");
+MODULE_ALIAS("arpt_RATEEST");
 module_init(xt_rateest_tg_init);
 module_exit(xt_rateest_tg_fini);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 00247bd..d776a8a 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -19,6 +19,7 @@ MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
 MODULE_DESCRIPTION("Xtables: rate-limit match");
 MODULE_ALIAS("ipt_limit");
 MODULE_ALIAS("ip6t_limit");
+MODULE_ALIAS("arpt_limit");
 
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
  * see net/sched/sch_tbf.c in the linux source tree
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 96dd2b6..ec4e8ad 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -21,6 +21,7 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("Xtables: packet mark match");
 MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
+MODULE_ALIAS("arpt_mark");
 
 static bool
 mark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index a3c8798..91016f7 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -14,6 +14,7 @@ MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: countdown quota match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
+MODULE_ALIAS("arpt_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4dcfd73..2b304f7 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -163,5 +163,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("xtables rate estimator match");
 MODULE_ALIAS("ipt_rateest");
 MODULE_ALIAS("ip6t_rateest");
+MODULE_ALIAS("arpt_rateest");
 module_init(xt_rateest_mt_init);
 module_exit(xt_rateest_mt_fini);
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index f41a923..1dfb8e5 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -21,6 +21,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
+MODULE_ALIAS("arpt_statistic");
 
 static DEFINE_SPINLOCK(nth_lock);
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 26648a1..2d9cb6f 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -261,3 +261,4 @@ MODULE_DESCRIPTION("Xtables: time-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_time");
 MODULE_ALIAS("ip6t_time");
+MODULE_ALIAS("arpt_time");
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index a6b971d..3c2f02d 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -125,3 +125,4 @@ MODULE_DESCRIPTION("Xtables: arbitrary byte matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_u32");
 MODULE_ALIAS("ip6t_u32");
+MODULE_ALIAS("arpt_u32");
-- 
1.5.5

