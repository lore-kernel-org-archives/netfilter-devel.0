From: dmitry pervushin <dpervushin@gmail.com>
Subject: Android netfilter patches (xt_IDLETIMER) [2/3]
Date: Mon, 25 Mar 2013 23:09:16 +0100
Message-ID: <5150CB0C.2090406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Send notifications when the label becomes active after an idle period.
Send netlink message notifications in addition to sysfs notifications.
Using a uevent with
      subsystem=xt_idletimer
      INTERFACE=...
      STATE={active,inactive}

This is backport from common android-3.0
commit: beb914e987cbbd368988d2b94a6661cb907c4d5a
with uevent support instead of a new netlink message type.

Cc: netdev@vger.kernel.org
Cc: JP Abgrall <jpa@google.com>
Cc: Ashish Sharma <ashishsharma@google.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Ashish Sharma <ashishsharma@google.com>
Signed-off-by: JP Abgrall <jpa@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: dmitry pervushin <dpervushin@gmail.com>

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 208ae93..96ed520 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -42,4 +42,18 @@ struct idletimer_tg_info {
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };

+#define NL_EVENT_TYPE_INACTIVE 0
+#define NL_EVENT_TYPE_ACTIVE 1
+
+struct idletimer_tg_info_v1 {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	/* Use netlink messages for notification in addition to sysfs */
+	__u8 send_nl_msg;
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute__((aligned(8)));
+};
 #endif
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 3540c04..cbf059c 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -40,6 +40,11 @@
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
+#include <linux/skbuff.h>
+#include <net/net_namespace.h>
+#include <uapi/linux/netfilter/xt_IDLETIMER.h>
+
+#define NLMSG_MAX_SIZE 64

 struct idletimer_tg_attr {
 	struct attribute attr;
@@ -56,6 +61,8 @@ struct idletimer_tg {
 	struct idletimer_tg_attr attr;

 	unsigned int refcnt;
+	bool send_nl_msg;
+	bool active;
 };

 static LIST_HEAD(idletimer_tg_list);
@@ -63,6 +70,30 @@ static DEFINE_MUTEX(list_mutex);

 static struct kobject *idletimer_tg_kobj;

+static void notify_netlink_uevent(const char *iface, struct idletimer_tg *timer)
+{
+	char iface_msg[NLMSG_MAX_SIZE];
+	char state_msg[NLMSG_MAX_SIZE];
+	char *envp[] = { iface_msg, state_msg, NULL };
+	int res;
+
+	res = snprintf(iface_msg, NLMSG_MAX_SIZE, "INTERFACE=%s",
+		       iface);
+	if (NLMSG_MAX_SIZE <= res) {
+		pr_err("message too long (%d)", res);
+		return;
+	}
+	res = snprintf(state_msg, NLMSG_MAX_SIZE, "STATE=%s",
+		       timer->active ? "active" : "inactive");
+	if (NLMSG_MAX_SIZE <= res) {
+		pr_err("message too long (%d)", res);
+		return;
+	}
+	pr_debug("putting nlmsg: <%s> <%s>\n", iface_msg, state_msg);
+	kobject_uevent_env(idletimer_tg_kobj, KOBJ_CHANGE, envp);
+	return;
+}
+
 static
 struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
 {
@@ -83,6 +114,7 @@ static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,
 {
 	struct idletimer_tg *timer;
 	unsigned long expires = 0;
+	unsigned long now = jiffies;

 	mutex_lock(&list_mutex);

@@ -92,11 +124,15 @@ static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,

 	mutex_unlock(&list_mutex);

-	if (time_after(expires, jiffies))
+	if (time_after(expires, now))
 		return sprintf(buf, "%u\n",
-			       jiffies_to_msecs(expires - jiffies) / 1000);
+			       jiffies_to_msecs(expires - now) / 1000);

-	return sprintf(buf, "0\n");
+	if (timer->send_nl_msg)
+		return sprintf(buf, "0 %d\n",
+			jiffies_to_msecs(now - expires) / 1000);
+	else
+		return sprintf(buf, "0\n");
 }

 static void idletimer_tg_work(struct work_struct *work)
@@ -105,6 +141,9 @@ static void idletimer_tg_work(struct work_struct *work)
 						  work);

 	sysfs_notify(idletimer_tg_kobj, NULL, timer->attr.attr.name);
+
+	if (timer->send_nl_msg)
+		notify_netlink_uevent(timer->attr.attr.name, timer);
 }

 static void idletimer_tg_expired(unsigned long data)
@@ -113,12 +152,15 @@ static void idletimer_tg_expired(unsigned long data)

 	pr_debug("timer %s expired\n", timer->attr.attr.name);

+	timer->active = false;
 	schedule_work(&timer->work);
 }

-static int idletimer_tg_create(struct idletimer_tg_info *info)
+static int idletimer_tg_create(void *pinfo, int revision)
 {
 	int ret;
+	struct idletimer_tg_info *info = (struct idletimer_tg_info*)pinfo;
+	struct idletimer_tg_info_v1 *info1 = (struct idletimer_tg_info_v1*)pinfo;

 	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
 	if (!info->timer) {
@@ -144,6 +186,10 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)

 	setup_timer(&info->timer->timer, idletimer_tg_expired,
 		    (unsigned long) info->timer);
+	info->timer->send_nl_msg = false;
+	info->timer->active = true;
+	if (revision == 1 && info1->send_nl_msg)
+		info->timer->send_nl_msg = true;
 	info->timer->refcnt = 1;

 	mod_timer(&info->timer->timer,
@@ -175,6 +221,8 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,

 	BUG_ON(!info->timer);

+	info->timer->active = true;
+
 	if (time_before(info->timer->timer.expires, now)) {
 		schedule_work(&info->timer->work);
 		pr_debug("Starting timer %s (Expired, Jiffies): %lu, %lu\n",
@@ -188,7 +236,7 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 	return XT_CONTINUE;
 }

-static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
+static int idletimer_tg_checkentry_rev(const struct xt_tgchk_param *par, int revision)
 {
 	struct idletimer_tg_info *info = par->targinfo;
 	int ret;
@@ -213,18 +261,21 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	info->timer = __idletimer_tg_find_by_label(info->label);
 	if (info->timer) {
 		info->timer->refcnt++;
+		info->timer->active = true;
+
 		if (time_before(info->timer->timer.expires, now)) {
 			schedule_work(&info->timer->work);
 			pr_debug("Starting Checkentry timer (Expired, Jiffies): %lu, %lu\n",
 				info->timer->timer.expires, now);
 		}
+
 		mod_timer(&info->timer->timer,
 			  msecs_to_jiffies(info->timeout * 1000) + now);

 		pr_debug("increased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
 	} else {
-		ret = idletimer_tg_create(info);
+		ret = idletimer_tg_create(info, revision);
 		if (ret < 0) {
 			pr_debug("failed to create timer\n");
 			mutex_unlock(&list_mutex);
@@ -236,6 +287,16 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	return 0;
 }

+static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	return idletimer_tg_checkentry_rev(par, 0);
+}
+
+static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
+{
+	return idletimer_tg_checkentry_rev(par, 1);
+}
+
 static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	const struct idletimer_tg_info *info = par->targinfo;
@@ -260,14 +321,27 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 	mutex_unlock(&list_mutex);
 }

-static struct xt_target idletimer_tg __read_mostly = {
+static struct xt_target idletimer_tg[] __read_mostly = {
+{
 	.name		= "IDLETIMER",
+	.revision	= 0,
 	.family		= NFPROTO_UNSPEC,
 	.target		= idletimer_tg_target,
 	.targetsize     = sizeof(struct idletimer_tg_info),
 	.checkentry	= idletimer_tg_checkentry,
 	.destroy        = idletimer_tg_destroy,
 	.me		= THIS_MODULE,
+},
+{
+	.name		= "IDLETIMER",
+	.revision	= 1,
+	.family		= NFPROTO_UNSPEC,
+	.target		= idletimer_tg_target,
+	.targetsize     = sizeof(struct idletimer_tg_info_v1),
+	.checkentry	= idletimer_tg_checkentry_v1,
+	.destroy        = idletimer_tg_destroy,
+	.me		= THIS_MODULE,
+},
 };

 static struct class *idletimer_tg_class;
@@ -295,7 +369,7 @@ static int __init idletimer_tg_init(void)

 	idletimer_tg_kobj = &idletimer_tg_device->kobj;

-	err =  xt_register_target(&idletimer_tg);
+	err =  xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
 	if (err < 0) {
 		pr_debug("couldn't register xt target\n");
 		goto out_dev;
@@ -312,7 +386,7 @@ out:

 static void __exit idletimer_tg_exit(void)
 {
-	xt_unregister_target(&idletimer_tg);
+	xt_unregister_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));

 	device_destroy(idletimer_tg_class, MKDEV(0, 0));
 	class_destroy(idletimer_tg_class);
@@ -327,3 +401,4 @@ MODULE_DESCRIPTION("Xtables: idle time monitor");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("ipt_IDLETIMER");
 MODULE_ALIAS("ip6t_IDLETIMER");
+MODULE_ALIAS("arpt_IDLETIMER");
