Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D887C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF2620674
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Ir6zgTs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgBDLWi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 06:22:38 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:25402 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbgBDLWh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 06:22:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580815356; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=UiiXTIg8yx64/9nLsGPbL/maCjX2i/v0FRlQrM+qMLk=; b=Ir6zgTs3WryGJq8sWGNLw4pPVfyLzMmRSaole6PUf9q26l+GkyFYgxc53kO3jQQCWQLGtvwn
 VPi6HSFwvqGUNhfIJ76os4pcYNtZ/w05f03V1WFE3KDjokcwu44QnwfF1pejxkwVqqMP5E9X
 jk7P9t/9kgwF/FzMBzlQcQsdQ9k=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3953fb.7fc8449bec38-smtp-out-n03;
 Tue, 04 Feb 2020 11:22:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E25A4C447A1; Tue,  4 Feb 2020 11:22:34 +0000 (UTC)
Received: from manojbm-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AE87C43383;
        Tue,  4 Feb 2020 11:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AE87C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=manojbm@codeaurora.org
From:   Manoj Basapathi <manojbm@codeaurora.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, pablo@netfilter.org, sharathv@qti.qualcomm.com,
        ssaha@qti.qualcomm.com, vidulak@qti.qualcomm.com,
        manojbm@qti.qualcomm.com, Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH] [nf-next v3] netfilter: xtables: Add snapshot of hardidletimer target
Date:   Tue,  4 Feb 2020 16:51:53 +0530
Message-Id: <20200204112153.24063-1-manojbm@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

/sys/class/xt_idletimer/timers/<label>

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
 include/uapi/linux/netfilter/xt_IDLETIMER.h |  11 +
 net/netfilter/xt_IDLETIMER.c                | 236 +++++++++++++++++++-
 2 files changed, 239 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 3c586a19baea..0899d140fda4 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -33,6 +33,7 @@
 #include <linux/types.h>
 
 #define MAX_IDLETIMER_LABEL_SIZE 28
+#define XT_IDLETIMER_ALARM 0x01
 
 struct idletimer_tg_info {
 	__u32 timeout;
@@ -43,4 +44,14 @@ struct idletimer_tg_info {
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
 
+struct idletimer_tg_info_v1 {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	__u8 timer_type;
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute__((aligned(8)));
+};
 #endif
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f56d3ed93e56..7fd9b952550b 100644
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
+							  ktime_t now)
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
@@ -160,6 +183,68 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 	return ret;
 }
 
+static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
+{
+	int ret;
+
+	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	if (!info->timer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = idletimer_check_sysfs_name(info->label, sizeof(info->label));
+	if (ret < 0)
+		goto out_free_timer;
+
+	sysfs_attr_init(&info->timer->attr.attr);
+	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	if (!info->timer->attr.attr.name) {
+		ret = -ENOMEM;
+		goto out_free_timer;
+	}
+	info->timer->attr.attr.mode = 0444;
+	info->timer->attr.show = idletimer_tg_show;
+
+	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	if (ret < 0) {
+		pr_debug("couldn't add file to sysfs");
+		goto out_free_attr;
+	}
+
+	/*  notify userspace  */
+	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
+
+	list_add(&info->timer->entry, &idletimer_tg_list);
+		pr_debug("timer type value is %u", info->timer_type);
+	info->timer->timer_type = info->timer_type;
+	info->timer->refcnt = 1;
+
+	INIT_WORK(&info->timer->work, idletimer_tg_work);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout;
+		alarm_init(&info->timer->alarm, ALARM_BOOTTIME,
+			   idletimer_tg_alarmproc);
+		info->timer->alarm.data = info->timer;
+		tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
+		timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
+	mod_timer(&info->timer->timer,
+		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
+
+	return 0;
+
+out_free_attr:
+	kfree(info->timer->attr.attr.name);
+out_free_timer:
+	kfree(info->timer);
+out:
+	return ret;
+}
+
 /*
  * The actual xt_tables plugin.
  */
@@ -177,6 +262,28 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 	return XT_CONTINUE;
 }
 
+/*
+ * The actual xt_tables plugin.
+ */
+static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
+					 const struct xt_action_param *par)
+{
+	const struct idletimer_tg_info_v1 *info = par->targinfo;
+
+	pr_debug("resetting timer %s, timeout period %u\n",
+		 info->label, info->timeout);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
+	mod_timer(&info->timer->timer,
+		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
+
+	return XT_CONTINUE;
+}
+
 static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 {
 	struct idletimer_tg_info *info = par->targinfo;
@@ -222,6 +329,73 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	return 0;
 }
 
+static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
+{
+	struct idletimer_tg_info_v1 *info = par->targinfo;
+	int ret;
+
+	pr_debug("checkentry targinfo%s\n", info->label);
+
+	if (info->timeout == 0) {
+		pr_debug("timeout value is zero\n");
+		return -EINVAL;
+	}
+	if (info->timeout >= INT_MAX / 1000) {
+		pr_debug("timeout value is too big\n");
+		return -EINVAL;
+	}
+	if (info->label[0] == '\0' ||
+		strnlen(info->label,
+			MAX_IDLETIMER_LABEL_SIZE) == MAX_IDLETIMER_LABEL_SIZE) {
+		pr_debug("label is empty or not nul-terminated\n");
+		return -EINVAL;
+	}
+
+	if (info->timer_type > XT_IDLETIMER_ALARM) {
+		pr_debug("invalid value for timer type\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&list_mutex);
+
+	info->timer = __idletimer_tg_find_by_label(info->label);
+	if (info->timer) {
+		if (info->timer->timer_type != info->timer_type) {
+			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
+			mutex_unlock(&list_mutex);
+			return -EINVAL;
+		}
+
+		info->timer->refcnt++;
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
+		mod_timer(&info->timer->timer,
+			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
+		}
+		pr_debug("increased refcnt of timer %s to %u\n",
+			 info->label, info->timer->refcnt);
+	} else {
+		ret = idletimer_tg_create_v1(info);
+		if (ret < 0) {
+			pr_debug("failed to create timer\n");
+			mutex_unlock(&list_mutex);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&list_mutex);
+	return 0;
+}
+
 static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	const struct idletimer_tg_info *info = par->targinfo;
@@ -247,7 +421,38 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 	mutex_unlock(&list_mutex);
 }
 
-static struct xt_target idletimer_tg __read_mostly = {
+static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
+{
+	const struct idletimer_tg_info_v1 *info = par->targinfo;
+
+	pr_debug("destroy targinfo %s\n", info->label);
+
+	mutex_lock(&list_mutex);
+
+	if (--info->timer->refcnt == 0) {
+		pr_debug("deleting timer %s\n", info->label);
+
+		list_del(&info->timer->entry);
+		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+			alarm_cancel(&info->timer->alarm);
+		} else {
+			del_timer_sync(&info->timer->timer);
+		}
+		cancel_work_sync(&info->timer->work);
+		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+		kfree(info->timer->attr.attr.name);
+		kfree(info->timer);
+	} else {
+		pr_debug("decreased refcnt of timer %s to %u\n",
+			 info->label, info->timer->refcnt);
+	}
+
+	mutex_unlock(&list_mutex);
+}
+
+
+static struct xt_target idletimer_tg[] __read_mostly = {
+	{
 	.name		= "IDLETIMER",
 	.family		= NFPROTO_UNSPEC,
 	.target		= idletimer_tg_target,
@@ -256,6 +461,20 @@ static struct xt_target idletimer_tg __read_mostly = {
 	.checkentry	= idletimer_tg_checkentry,
 	.destroy        = idletimer_tg_destroy,
 	.me		= THIS_MODULE,
+	},
+	{
+	.name		= "IDLETIMER",
+	.family		= NFPROTO_UNSPEC,
+	.revision   = 1,
+	.target		= idletimer_tg_target_v1,
+	.targetsize     = sizeof(struct idletimer_tg_info_v1),
+	.usersize	= offsetof(struct idletimer_tg_info_v1, timer),
+	.checkentry	= idletimer_tg_checkentry_v1,
+	.destroy        = idletimer_tg_destroy_v1,
+	.me		= THIS_MODULE,
+	},
+
+
 };
 
 static struct class *idletimer_tg_class;
@@ -283,7 +502,8 @@ static int __init idletimer_tg_init(void)
 
 	idletimer_tg_kobj = &idletimer_tg_device->kobj;
 
-	err = xt_register_target(&idletimer_tg);
+	err = xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
+
 	if (err < 0) {
 		pr_debug("couldn't register xt target\n");
 		goto out_dev;
@@ -300,7 +520,7 @@ static int __init idletimer_tg_init(void)
 
 static void __exit idletimer_tg_exit(void)
 {
-	xt_unregister_target(&idletimer_tg);
+	xt_unregister_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
 
 	device_destroy(idletimer_tg_class, MKDEV(0, 0));
 	class_destroy(idletimer_tg_class);
-- 
2.25.0
