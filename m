Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D752C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3497420661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="gSW/EOMJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgA3AiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:38:24 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:56736 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgA3AiY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:38:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580344702; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=NydfmcSZGXmPToYm5WsIL7tRre37KHnFnsFr4TVJbTs=; b=gSW/EOMJvloV4LyahgO6HwVlzxdw7334tJZxNS/3HnzCcBwyTS8uAGWRHg5lOJ67qNbmPnb5
 owgPDgajuae3xtpM7C0uP39nfrr0gKNUv/BoRD6YAbL0git+OyFiwEEqknSDrcJqZjQG/K/E
 0DtBRuZyek2dLxA2khhldC05SIw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e32257c.7f7180d72068-smtp-out-n03;
 Thu, 30 Jan 2020 00:38:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03DADC433A2; Thu, 30 Jan 2020 00:38:20 +0000 (UTC)
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA3B4C433CB;
        Thu, 30 Jan 2020 00:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA3B4C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Cc:     Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: xtables: Add snapshot of hardidletimer target
Date:   Wed, 29 Jan 2020 17:37:07 -0700
Message-Id: <1580344627-2452-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Manoj Basapathi <manojbm@codeaurora.org>

This is a snapshot of hardidletimer netfilter target.

This patch implements a hardidletimer Xtables target that can be
used to identify when interfaces have been idle for a certain period
of time.

Timers are identified by labels and are created when a rule is set
with a new label. The rules also take a timeout value (in seconds) as
an option. If more than one rule uses the same timer label, the timer
will be restarted whenever any of the rules get a hit.

One entry for each timer is created in sysfs. This attribute contains
the timer remaining for the timer to expire. The attributes are
located under the xt_idletimer class:

/sys/class/xt_hardidletimer/timers/<label>

When the timer expires, the target module sends a sysfs notification
to the userspace, which can then decide what to do (eg. disconnect to
save power)

Compared to IDLETIMER, HARDIDLETIMER can send notifications when
CPU is in suspend too, to notify the timer expiry.

v1->v2: Moved all functionality into IDLETIMER module to avoid
code duplication per comment from Florian.

Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h |  3 +
 net/netfilter/xt_IDLETIMER.c                | 85 ++++++++++++++++++++++++++---
 2 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 3c586a1..10a40bb 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -33,12 +33,15 @@
 #include <linux/types.h>
 
 #define MAX_IDLETIMER_LABEL_SIZE 28
+#define XT_IDLETIMER_ALARM 0x01
 
 struct idletimer_tg_info {
 	__u32 timeout;
 
 	char label[MAX_IDLETIMER_LABEL_SIZE];
 
+	__u8 timer_type;
+
 	/* for kernel module internal use only */
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f56d3ed..0df1599 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/timer.h>
+#include <linux/alarmtimer.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/netfilter.h>
@@ -30,6 +31,7 @@
 
 struct idletimer_tg {
 	struct list_head entry;
+	struct alarm alarm;
 	struct timer_list timer;
 	struct work_struct work;
 
@@ -37,6 +39,7 @@ struct idletimer_tg {
 	struct device_attribute attr;
 
 	unsigned int refcnt;
+	u8 timer_type;
 };
 
 static LIST_HEAD(idletimer_tg_list);
@@ -62,20 +65,30 @@ static ssize_t idletimer_tg_show(struct device *dev,
 {
 	struct idletimer_tg *timer;
 	unsigned long expires = 0;
+	struct timespec64 ktimespec = {};
+	long time_diff = 0;
 
 	mutex_lock(&list_mutex);
 
 	timer =	__idletimer_tg_find_by_label(attr->attr.name);
-	if (timer)
+	if (timer) {
+		if (timer->timer_type & XT_IDLETIMER_ALARM) {
+			ktime_t expires_alarm = alarm_expires_remaining(&timer->alarm);
+			ktimespec = ktime_to_timespec64(expires_alarm);
+			time_diff = ktimespec.tv_sec;
+		} else {
 		expires = timer->timer.expires;
+			time_diff = jiffies_to_msecs(
+				expires - jiffies) / 1000;
+		}
+	}
 
 	mutex_unlock(&list_mutex);
 
-	if (time_after(expires, jiffies))
-		return sprintf(buf, "%u\n",
-			       jiffies_to_msecs(expires - jiffies) / 1000);
+	if (time_after(expires, jiffies) || ktimespec.tv_sec > 0)
+		return snprintf(buf, PAGE_SIZE, "%ld\n", time_diff);
 
-	return sprintf(buf, "0\n");
+	return snprintf(buf, PAGE_SIZE, "0\n");
 }
 
 static void idletimer_tg_work(struct work_struct *work)
@@ -95,6 +108,16 @@ static void idletimer_tg_expired(struct timer_list *t)
 	schedule_work(&timer->work);
 }
 
+static enum alarmtimer_restart idletimer_tg_alarmproc(struct alarm *alarm,
+						      ktime_t now)
+{
+	struct idletimer_tg *timer = alarm->data;
+
+	pr_debug("alarm %s expired\n", timer->attr.attr.name);
+	schedule_work(&timer->work);
+	return ALARMTIMER_NORESTART;
+}
+
 static int idletimer_check_sysfs_name(const char *name, unsigned int size)
 {
 	int ret;
@@ -140,15 +163,28 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 		goto out_free_attr;
 	}
 
-	list_add(&info->timer->entry, &idletimer_tg_list);
+        /*  notify userspace  */
+	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
 
-	timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
+	list_add(&info->timer->entry, &idletimer_tg_list);
+        pr_debug("timer type value is %u", info->timer_type);
+	info->timer->timer_type = info->timer_type;
 	info->timer->refcnt = 1;
 
 	INIT_WORK(&info->timer->work, idletimer_tg_work);
 
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout;
+		alarm_init(&info->timer->alarm, ALARM_BOOTTIME,
+			   idletimer_tg_alarmproc);
+		info->timer->alarm.data = info->timer;
+		tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
+		timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
 	mod_timer(&info->timer->timer,
 		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
 
 	return 0;
 
@@ -171,8 +207,13 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 	pr_debug("resetting timer %s, timeout period %u\n",
 		 info->label, info->timeout);
 
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
 	mod_timer(&info->timer->timer,
 		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
 
 	return XT_CONTINUE;
 }
@@ -199,14 +240,36 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 		return -EINVAL;
 	}
 
+	if (info->timer_type > XT_IDLETIMER_ALARM) {
+		pr_debug("invalid value for timer type\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&list_mutex);
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
+		if (info->timer->timer_type != info->timer_type) {
+			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
+			mutex_unlock(&list_mutex);
+			return -EINVAL;
+		}
+
 		info->timer->refcnt++;
+		if (info->timer_type & XT_IDLETIMER_ALARM) {
+			/* calculate remaining expiry time */
+			ktime_t tout = alarm_expires_remaining(&info->timer->alarm);
+			struct timespec64 ktimespec = ktime_to_timespec64(tout);
+
+			if (ktimespec.tv_sec > 0) {
+				pr_debug("time_expiry_remaining %ld\n",
+					 ktimespec.tv_sec);
+				alarm_start_relative(&info->timer->alarm, tout);
+			}
+		} else {
 		mod_timer(&info->timer->timer,
 			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
-
+		}
 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
 	} else {
@@ -234,7 +297,11 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 		pr_debug("deleting timer %s\n", info->label);
 
 		list_del(&info->timer->entry);
-		del_timer_sync(&info->timer->timer);
+		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+			alarm_cancel(&info->timer->alarm);
+		} else {
+	                del_timer_sync(&info->timer->timer);
+		}
 		cancel_work_sync(&info->timer->work);
 		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
 		kfree(info->timer->attr.attr.name);
-- 
1.9.1
