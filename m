Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE823A785A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 04:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778731575; cv=none; b=bpHEl5zmboy7cJ2HPRcFkFxYgsdy2uQxSC5m7V+XpvTPxLCPS/alvEvyPfhcEhi57+ev8y/3n4esyrq5kD8JJy0LX9U6kIhRCJHxJRbU5b89094eLRPFSDN/zBleCRWuy5G69Mhvx+E//y/F566uHaJ7ZZ6gbl+agnbmFyKNcCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778731575; c=relaxed/simple;
	bh=IaVW4isoh1cBa2Zla8PC+HhdItWXyxViwWNrweT7hnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9ICU+q8vAuFE71SF2/2b+68eFH+IvjwLgUfHWhx8WrpFim+U0th1S9DoRFIxmDLL7BmVVGjpCtNmQK+LZFpKXuwwKUsnIbMehl8WnAirfTMuMnADfaWajBcdzyOTxnJQgkZUOlysUDvYfxInUFwsYbSJQblAwy9GyYte460WD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowAA3Q_4ZSgVqCukAAA--.1036S3;
	Thu, 14 May 2026 12:05:56 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	luciano.coelho@nokia.com,
	kaber@trash.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	royenheart@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: xt_IDLETIMER: scope timer reuse to the owning netns
Date: Thu, 14 May 2026 12:05:41 +0800
Message-ID: <9c5661fad291777d8e998e23f3cb27cac37aa607.1775353240.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1775353240.git.royenheart@gmail.com>
References: <cover.1775353240.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowAA3Q_4ZSgVqCukAAA--.1036S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr17CrWxtw45Jr1UJF1UKFg_yoWfArW7pF
	WUJw13Kr4rXF48WF4kuF4Duayakr48XrnxGr97C3y8C3Z7Jr4IqF10yFWF9FWfCrZYgrZ3
	JF40vwn0kr1UJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEHCWoEFm8VKAAAsk

From: Haoze Xie <royenheart@gmail.com>

IDLETIMER keeps timers in a module-global list and reuses them
solely by label text.

The existing rev0 ALARM guard avoids the panic when rev0 reuses
a rev1 ALARM timer from another netns, but it still lets same
labels in different netns share the same timer object and the
same sysfs entry.

Track the owning netns in struct idletimer_tg and only reuse
timers when both the label and netns match. For non-init_net
timers, derive a namespace-scoped sysfs name from the netns
inode so non-init namespaces no longer collide in the global
xt_idletimer sysfs directory.

This keeps init_net sysfs paths unchanged for ABI compatibility
and preserves same-netns label reuse, while preventing the
cross-netns timer-object aliasing that caused refcount, expiry,
and teardown interference.

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/xt_IDLETIMER.c | 74 ++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 517106165ad2..c45af0cecb52 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -28,6 +28,7 @@
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
+#include <net/net_namespace.h>
 
 struct idletimer_tg {
 	struct list_head entry;
@@ -37,6 +38,8 @@ struct idletimer_tg {
 
 	struct kobject *kobj;
 	struct device_attribute attr;
+	struct net *net;
+	char label[MAX_IDLETIMER_LABEL_SIZE];
 
 	unsigned int refcnt;
 	u8 timer_type;
@@ -48,38 +51,46 @@ static DEFINE_MUTEX(list_mutex);
 static struct kobject *idletimer_tg_kobj;
 
 static
-struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
+struct idletimer_tg *__idletimer_tg_find_by_label(const struct net *net,
+						  const char *label)
 {
 	struct idletimer_tg *entry;
 
 	list_for_each_entry(entry, &idletimer_tg_list, entry) {
-		if (!strcmp(label, entry->attr.attr.name))
+		if (net_eq(entry->net, net) && !strcmp(label, entry->label))
 			return entry;
 	}
 
 	return NULL;
 }
 
+static char *idletimer_tg_sysfs_name(struct net *net, const char *label)
+{
+	if (net_eq(net, &init_net))
+		return kstrdup(label, GFP_KERNEL);
+
+	return kasprintf(GFP_KERNEL, "%u_%s", net->ns.inum, label);
+}
+
 static ssize_t idletimer_tg_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	struct idletimer_tg *timer;
+	struct idletimer_tg *timer = container_of(attr, struct idletimer_tg,
+						  attr);
 	unsigned long expires = 0;
 	struct timespec64 ktimespec = {};
 	long time_diff = 0;
 
 	mutex_lock(&list_mutex);
 
-	timer =	__idletimer_tg_find_by_label(attr->attr.name);
-	if (timer) {
-		if (timer->timer_type & XT_IDLETIMER_ALARM) {
-			ktime_t expires_alarm = alarm_expires_remaining(&timer->alarm);
-			ktimespec = ktime_to_timespec64(expires_alarm);
-			time_diff = ktimespec.tv_sec;
-		} else {
-			expires = timer->timer.expires;
-			time_diff = jiffies_to_msecs(expires - jiffies) / 1000;
-		}
+	if (timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t expires_alarm = alarm_expires_remaining(&timer->alarm);
+
+		ktimespec = ktime_to_timespec64(expires_alarm);
+		time_diff = ktimespec.tv_sec;
+	} else {
+		expires = timer->timer.expires;
+		time_diff = jiffies_to_msecs(expires - jiffies) / 1000;
 	}
 
 	mutex_unlock(&list_mutex);
@@ -102,7 +113,7 @@ static void idletimer_tg_expired(struct timer_list *t)
 {
 	struct idletimer_tg *timer = timer_container_of(timer, t, timer);
 
-	pr_debug("timer %s expired\n", timer->attr.attr.name);
+	pr_debug("timer %s expired\n", timer->label);
 
 	schedule_work(&timer->work);
 }
@@ -111,7 +122,7 @@ static void idletimer_tg_alarmproc(struct alarm *alarm, ktime_t now)
 {
 	struct idletimer_tg *timer = alarm->data;
 
-	pr_debug("alarm %s expired\n", timer->attr.attr.name);
+	pr_debug("alarm %s expired\n", timer->label);
 	schedule_work(&timer->work);
 }
 
@@ -131,7 +142,7 @@ static int idletimer_check_sysfs_name(const char *name, unsigned int size)
 	return 0;
 }
 
-static int idletimer_tg_create(struct idletimer_tg_info *info)
+static int idletimer_tg_create(struct idletimer_tg_info *info, struct net *net)
 {
 	int ret;
 
@@ -145,11 +156,14 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 	if (ret < 0)
 		goto out_free_timer;
 
+	info->timer->net = get_net(net);
+	strscpy(info->timer->label, info->label, sizeof(info->timer->label));
+
 	sysfs_attr_init(&info->timer->attr.attr);
-	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	info->timer->attr.attr.name = idletimer_tg_sysfs_name(net, info->label);
 	if (!info->timer->attr.attr.name) {
 		ret = -ENOMEM;
-		goto out_free_timer;
+		goto out_put_net;
 	}
 	info->timer->attr.attr.mode = 0444;
 	info->timer->attr.show = idletimer_tg_show;
@@ -174,13 +188,16 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 
 out_free_attr:
 	kfree(info->timer->attr.attr.name);
+out_put_net:
+	put_net(info->timer->net);
 out_free_timer:
 	kfree(info->timer);
 out:
 	return ret;
 }
 
-static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
+static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info,
+				  struct net *net)
 {
 	int ret;
 
@@ -194,11 +211,14 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 	if (ret < 0)
 		goto out_free_timer;
 
+	info->timer->net = get_net(net);
+	strscpy(info->timer->label, info->label, sizeof(info->timer->label));
+
 	sysfs_attr_init(&info->timer->attr.attr);
-	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	info->timer->attr.attr.name = idletimer_tg_sysfs_name(net, info->label);
 	if (!info->timer->attr.attr.name) {
 		ret = -ENOMEM;
-		goto out_free_timer;
+		goto out_put_net;
 	}
 	info->timer->attr.attr.mode = 0444;
 	info->timer->attr.show = idletimer_tg_show;
@@ -236,6 +256,8 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 
 out_free_attr:
 	kfree(info->timer->attr.attr.name);
+out_put_net:
+	put_net(info->timer->net);
 out_free_timer:
 	kfree(info->timer);
 out:
@@ -316,7 +338,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	}
 	mutex_lock(&list_mutex);
 
-	info->timer = __idletimer_tg_find_by_label(info->label);
+	info->timer = __idletimer_tg_find_by_label(par->net, info->label);
 	if (info->timer) {
 		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
 			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
@@ -331,7 +353,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
 	} else {
-		ret = idletimer_tg_create(info);
+		ret = idletimer_tg_create(info, par->net);
 		if (ret < 0) {
 			pr_debug("failed to create timer\n");
 			mutex_unlock(&list_mutex);
@@ -367,7 +389,7 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 
 	mutex_lock(&list_mutex);
 
-	info->timer = __idletimer_tg_find_by_label(info->label);
+	info->timer = __idletimer_tg_find_by_label(par->net, info->label);
 	if (info->timer) {
 		if (info->timer->timer_type != info->timer_type) {
 			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
@@ -393,7 +415,7 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
 	} else {
-		ret = idletimer_tg_create_v1(info);
+		ret = idletimer_tg_create_v1(info, par->net);
 		if (ret < 0) {
 			pr_debug("failed to create timer\n");
 			mutex_unlock(&list_mutex);
@@ -429,6 +451,7 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 	cancel_work_sync(&info->timer->work);
 	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
 	kfree(info->timer->attr.attr.name);
+	put_net(info->timer->net);
 	kfree(info->timer);
 }
 
@@ -460,6 +483,7 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 	cancel_work_sync(&info->timer->work);
 	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
 	kfree(info->timer->attr.attr.name);
+	put_net(info->timer->net);
 	kfree(info->timer);
 }
 
-- 
2.52.0

