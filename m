From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:27 +0100
Message-ID: <1206468391-368-25-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-19-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-20-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-21-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-22-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-23-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-24-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52563 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbYCYSGj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:39 -0400
In-Reply-To: <1206468391-368-24-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: Give AF-independent extensions an arpt_ alias
    
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
index 268fb28..4629bdf 100644
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
index f2498f9..4c81ec4 100644
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
index 2014f2a..5a9b0d4 100644
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
index 88be2cc..27df112 100644
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
index 1697ba9..31332a2 100644
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
index 60be101..e143b1b 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -14,6 +14,7 @@ MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: countdown quota match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
+MODULE_ALIAS("arpt_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 917fe41..32a5853 100644
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
index 422090c..8c6d866 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -21,6 +21,7 @@ MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
+MODULE_ALIAS("arpt_statistic");
 
 static DEFINE_SPINLOCK(nth_lock);
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 9507c5b..1d08183 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -261,3 +261,4 @@ MODULE_DESCRIPTION("Xtables: time-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_time");
 MODULE_ALIAS("ip6t_time");
+MODULE_ALIAS("arpt_time");
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 343b8d1..0101a71 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -125,3 +125,4 @@ MODULE_DESCRIPTION("Xtables: arbitrary byte matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_u32");
 MODULE_ALIAS("ip6t_u32");
+MODULE_ALIAS("arpt_u32");
