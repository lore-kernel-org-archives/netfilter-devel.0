From: dmitry pervushin <dpervushin@gmail.com>
Subject: Android netfilter patches (xt_IDLETIMER) [1/3]
Date: Mon, 25 Mar 2013 23:09:06 +0100
Message-ID: <5150CB02.2090105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41051 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981Ab3CYWJI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:09:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the case in which timer has expired and we refresh it without
sending the notification

Signed-off-by: Ashish Sharma <ashishsharma@google.com>
Signed-off-by: JP Abgrall <jpa@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: dmitry pervushin <dpervushin@gmail.com>

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f407ebc1..3540c04 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -168,14 +168,22 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 					 const struct xt_action_param *par)
 {
 	const struct idletimer_tg_info *info = par->targinfo;
+	unsigned long now = jiffies;

 	pr_debug("resetting timer %s, timeout period %u\n",
 		 info->label, info->timeout);

 	BUG_ON(!info->timer);

+	if (time_before(info->timer->timer.expires, now)) {
+		schedule_work(&info->timer->work);
+		pr_debug("Starting timer %s (Expired, Jiffies): %lu, %lu\n",
+			 info->label, info->timer->timer.expires, now);
+	}
+
+	/* TODO: Avoid modifying timers on each packet */
 	mod_timer(&info->timer->timer,
-		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+		  msecs_to_jiffies(info->timeout * 1000) + now);

 	return XT_CONTINUE;
 }
@@ -184,6 +192,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 {
 	struct idletimer_tg_info *info = par->targinfo;
 	int ret;
+	unsigned long now = jiffies;

 	pr_debug("checkentry targinfo%s\n", info->label);

@@ -204,8 +213,13 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
 		info->timer->refcnt++;
+		if (time_before(info->timer->timer.expires, now)) {
+			schedule_work(&info->timer->work);
+			pr_debug("Starting Checkentry timer (Expired, Jiffies): %lu, %lu\n",
+				info->timer->timer.expires, now);
+		}
 		mod_timer(&info->timer->timer,
-			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+			  msecs_to_jiffies(info->timeout * 1000) + now);

 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
