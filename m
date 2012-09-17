From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: xt_time: add support to ignore day transition
Date: Mon, 17 Sep 2012 12:23:09 +0200
Message-ID: <1347877389-15728-2-git-send-email-fw@strlen.de>
References: <1347877389-15728-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35388 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab2IQKVR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:21:17 -0400
In-Reply-To: <1347877389-15728-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, if you want to do something like:
"match Monday, starting 23:00, for two hours"
You need two rules, one for Mon 23:00 to 0:00 and one for Tue 0:00-1:00.
The rule
--weekdays Mo --timestart 23:00  --timestop 01:00
looks correct, but it will first match on monday from midnight to 1 a.m.
and then again for another hour from 23:00 onwards.

This permits userspace to explicitly ignore the day transition and
match for a single, continuous time period instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/xt_time.h |    7 +++++++
 net/netfilter/xt_time.c           |   24 +++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
index 7c37fac..39cc3c4 100644
--- a/include/linux/netfilter/xt_time.h
+++ b/include/linux/netfilter/xt_time.h
@@ -17,6 +17,9 @@ enum {
 	/* Match against local time (instead of UTC) */
 	XT_TIME_LOCAL_TZ = 1 << 0,
 
+	/* treat timestart > timestop (e.g. 23:00-01:00) as single period */
+	XT_TIME_CONTIGUOUS = 1 << 1,
+
 	/* Shortcuts */
 	XT_TIME_ALL_MONTHDAYS = 0xFFFFFFFE,
 	XT_TIME_ALL_WEEKDAYS  = 0xFE,
@@ -24,4 +27,8 @@ enum {
 	XT_TIME_MAX_DAYTIME   = 24 * 60 * 60 - 1,
 };
 
+#ifdef __KERNEL__
+#define XT_TIME_ALL_FLAGS (XT_TIME_LOCAL_TZ|XT_TIME_CONTIGUOUS)
+#endif
+
 #endif /* _XT_TIME_H */
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index c48975f..0ae55a3 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -42,6 +42,7 @@ static const u_int16_t days_since_leapyear[] = {
  */
 enum {
 	DSE_FIRST = 2039,
+	SECONDS_PER_DAY = 86400,
 };
 static const u_int16_t days_since_epoch[] = {
 	/* 2039 - 2030 */
@@ -78,7 +79,7 @@ static inline unsigned int localtime_1(struct xtm *r, time_t time)
 	unsigned int v, w;
 
 	/* Each day has 86400s, so finding the hour/minute is actually easy. */
-	v         = time % 86400;
+	v         = time % SECONDS_PER_DAY;
 	r->second = v % 60;
 	w         = v / 60;
 	r->minute = w % 60;
@@ -199,6 +200,18 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		if (packet_time < info->daytime_start &&
 		    packet_time > info->daytime_stop)
 			return false;
+
+		/** if user asked to ignore 'next day', then e.g.
+		 *  '1 PM Wed, August 1st' should be treated
+		 *  like 'Tue 1 PM July 31st'.
+		 *
+		 * This also causes
+		 * 'Monday, "23:00 to 01:00", to match for 2 hours, starting
+		 * Monday 23:00 to Tuesday 01:00.
+		 */
+		if ((info->flags & XT_TIME_CONTIGUOUS) &&
+		     packet_time <= info->daytime_stop)
+			stamp -= SECONDS_PER_DAY;
 	}
 
 	localtime_2(&current_time, stamp);
@@ -227,6 +240,15 @@ static int time_mt_check(const struct xt_mtchk_param *par)
 		return -EDOM;
 	}
 
+	if (info->flags & ~XT_TIME_ALL_FLAGS) {
+		pr_info("unknown flags 0x%x\n", info->flags & ~XT_TIME_ALL_FLAGS);
+		return -EINVAL;
+	}
+
+	if ((info->flags & XT_TIME_CONTIGUOUS) &&
+	     info->daytime_start < info->daytime_stop)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
1.7.8.6

