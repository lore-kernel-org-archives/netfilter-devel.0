From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [RFC] netfilter: WIP: Xtables idletimer target implementation
Date: Thu, 27 May 2010 23:54:49 +0300
Message-ID: <1274993689-23928-1-git-send-email-luciano.coelho@nokia.com>
Cc: netdev@vger.kernel.or, kaber@trash.net,
	Timo Teras <timo.teras@iki.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63860 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab0E0UzN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:55:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements an idletimer Xtables target that can be used to
identify when interfaces have been idle for a certain period of time.

It adds a file to the sysfs for each interface that is brought up.  The file
contains the time remaining before the event is triggered.

The timeout should be set when the Xtable rule is defined with the --timeout
parameter set.

There are still some issues to be resolved:

How to treat several rules for the same interface?

We need a key for the timer list.  I'm using the targinfo pointer for that,
but this looks shaky, because there is no assurance that this pointer will
live for the entire lifetime of the rule.

This is now an x_tables target, so other protocols need to be implemented.
I've only implemented the ipv4 part so far.

Cc: Timo Teras <timo.teras@iki.fi>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/linux/netfilter/xt_IDLETIMER.h |   36 +++
 net/netfilter/Kconfig                  |    9 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_IDLETIMER.c           |  388 ++++++++++++++++++++++++++++++++
 4 files changed, 434 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_IDLETIMER.h
 create mode 100644 net/netfilter/xt_IDLETIMER.c

diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
new file mode 100644
index 0000000..f372c0c
--- /dev/null
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -0,0 +1,36 @@
+/*
+ * linux/include/linux/netfilter/xt_IDLETIMER.h
+ *
+ * Header file for Xtables timer target module.
+ *
+ * Copyright (C) 2004, 2010 Nokia Corporation
+ * Written by Timo Teras <ext-timo.teras@nokia.com>
+ *
+ * Converted to x_tables and forward-ported to 2.6.34
+ * by Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef _XT_TIMER_H
+#define _XT_TIMER_H
+
+struct xt_idletimer_info {
+	unsigned int timeout;
+};
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8593a77..b5aa336 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -584,6 +584,15 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
 	  TCP options from TCP packets.
 
+config NETFILTER_XT_TARGET_IDLETIMER
+	tristate  "IDLETIMER target support"
+	help
+	  This option adds an `IDLETIMER' target. Each matching packet resets
+	  the timer associated with input and/or output interfaces. Timer
+	  expiry causes kobject uevent. Idle timer can be read via sysfs.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # alphabetically ordered list of matches
 
 comment "Xtables matches"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 14e3a8f..e28420a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
new file mode 100644
index 0000000..3be8e8e
--- /dev/null
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -0,0 +1,388 @@
+/*
+ * linux/net/netfilter/xt_IDLETIMER.c
+ *
+ * Netfilter module to trigger a timer when packet matches.
+ * After timer expires a kevent will be sent.
+ *
+ * Copyright (C) 2004, 2010 Nokia Corporation
+ * Written by Timo Teras <ext-timo.teras@nokia.com>
+ *
+ * Converted to x_tables and reworked for upstream inclusion
+ * by Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/notifier.h>
+#include <linux/netfilter.h>
+#include <linux/rtnetlink.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_IDLETIMER.h>
+#include <linux/kobject.h>
+#include <linux/workqueue.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+static ssize_t utimer_attr_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+struct utimer_t {
+	char name[IFNAMSIZ];
+	struct net *net;
+
+	struct list_head entry;
+	struct timer_list timer;
+	struct work_struct work;
+
+	const struct xt_idletimer_info *info;
+};
+
+static LIST_HEAD(active_utimer_head);
+static DEFINE_SPINLOCK(list_lock);
+static DEVICE_ATTR(idletimer, 0444, utimer_attr_show, NULL);
+
+/* TODO: instead of finding by name, we need to iterate all with this name */
+static
+struct utimer_t *__utimer_find_by_name(const char *name, const struct net *net)
+{
+	struct utimer_t *entry;
+
+	list_for_each_entry(entry, &active_utimer_head, entry) {
+		if (!strcmp(name, entry->name) &&
+		    (net == entry->net)) {
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+static
+struct utimer_t *__utimer_find_by_info(const struct xt_idletimer_info *info)
+{
+	struct utimer_t *entry;
+
+	list_for_each_entry(entry, &active_utimer_head, entry) {
+		if (info == entry->info) {
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+static void utimer_delete(const struct xt_idletimer_info *info)
+{
+	struct utimer_t *timer;
+
+	spin_lock_bh(&list_lock);
+	timer = __utimer_find_by_info(info);
+	if (!timer)
+		goto out;
+
+	pr_debug("xt_idletimer: deleting timer '%s' ns %p\n",
+		 timer->name, timer->net);
+
+	list_del(&timer->entry);
+	del_timer_sync(&timer->timer);
+	put_net(timer->net);
+	kfree(timer);
+
+out:
+	spin_unlock_bh(&list_lock);
+}
+
+static void utimer_work(struct work_struct *work)
+{
+	struct utimer_t *timer = container_of(work, struct utimer_t, work);
+	struct net_device *netdev;
+
+	netdev = dev_get_by_name(timer->net, timer->name);
+
+	if (netdev != NULL) {
+		sysfs_notify(&netdev->dev.kobj, NULL,
+			     "idletimer");
+		dev_put(netdev);
+	}
+}
+
+static void utimer_expired(unsigned long data)
+{
+	struct utimer_t *timer = (struct utimer_t *) data;
+
+	pr_debug("xt_idletimer: timer '%s' ns %p expired\n",
+		 timer->name, timer->net);
+
+	schedule_work(&timer->work);
+}
+
+static struct utimer_t *utimer_create(const char *name,
+				      struct net *net,
+				      const struct xt_idletimer_info *info)
+{
+	struct utimer_t *timer;
+
+	timer = kmalloc(sizeof(struct utimer_t), GFP_ATOMIC);
+	if (timer == NULL)
+		return NULL;
+
+	list_add(&timer->entry, &active_utimer_head);
+	strlcpy(timer->name, name, sizeof(timer->name));
+	timer->net = get_net(net);
+
+	init_timer(&timer->timer);
+	setup_timer(&timer->timer, utimer_expired, (unsigned long) timer);
+
+	timer->info = info;
+
+	INIT_WORK(&timer->work, utimer_work);
+
+	pr_debug("xt_idletimer: created timer '%s' ns %p, timeout period %u\n",
+		 timer->name, timer->net, timer->info->timeout);
+
+	return timer;
+}
+
+static void utimer_reset(const struct xt_idletimer_info *info)
+{
+	struct utimer_t *timer;
+
+	spin_lock_bh(&list_lock);
+	timer = __utimer_find_by_info(info);
+	if (timer) {
+		pr_debug("xt_idletimer: resetting timer '%s' ns %p\n",
+			 timer->name, timer->net);
+		mod_timer(&timer->timer,
+			  msecs_to_jiffies(timer->info->timeout * 1000) + jiffies);
+	}
+	spin_unlock_bh(&list_lock);
+}
+
+static ssize_t utimer_attr_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct utimer_t *timer;
+	struct net_device *netdev = to_net_dev(dev);
+	unsigned long expires = 0;
+
+	spin_lock_bh(&list_lock);
+	timer = __utimer_find_by_name(netdev->name, dev_net(netdev));
+	if (timer)
+		expires = timer->timer.expires;
+	spin_unlock_bh(&list_lock);
+
+	if (expires > jiffies)
+		return sprintf(buf, "%u\n",
+			       jiffies_to_msecs(expires - jiffies) / 1000);
+
+	return sprintf(buf, "0\n");
+}
+
+static int utimer_notifier_call(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct net_device *netdev = ptr;
+	struct utimer_t *timer;
+	int ret;
+
+	/*
+	 * FIXME: Currently namespaces and sysfs don't coexist very nicely,
+	 * so we need to make sure that the kobject associated with this
+	 * device has a valid sysfs dirent in this namespace
+	 */
+	if (!netdev->dev.kobj.sd) {
+		pr_debug("xt_idletimer: event ignored: interface %s doesn't "
+			 "have an associated sd in this namespace.\n",
+			 netdev->name);
+		goto out;
+	}
+
+	spin_lock_bh(&list_lock);
+	timer = __utimer_find_by_name(netdev->name, dev_net(netdev));
+	spin_unlock_bh(&list_lock);
+	if (!timer)
+		goto out;
+
+	switch (event) {
+	case NETDEV_UP:
+		pr_debug("xt_idletimer: NETDEV_UP: %s\n", netdev->name);
+
+		ret = device_create_file(&netdev->dev,
+					 &dev_attr_idletimer);
+		WARN_ON(ret);
+
+		/*
+		 * TODO: need to loop over all timers associated with this
+		 * name and net and start their timers them
+		 */
+		utimer_reset(timer->info);
+
+		break;
+	case NETDEV_DOWN:
+		pr_debug("xt_idletimer: NETDEV_DOWN: %s\n", netdev->name);
+
+		device_remove_file(&netdev->dev,
+				   &dev_attr_idletimer);
+		/*
+		 * TODO: need to loop over all timers associated with this
+		 * name and net and stop their timers them
+		 */
+		del_timer_sync(&timer->timer);
+
+		break;
+	default:
+		break;
+	}
+
+out:
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block utimer_notifier_block = {
+	.notifier_call	= utimer_notifier_call,
+};
+
+
+static int utimer_init(void)
+{
+	return register_netdevice_notifier(&utimer_notifier_block);
+}
+
+static void utimer_fini(void)
+{
+	struct net_device *dev;
+	struct net *net;
+
+	unregister_netdevice_notifier(&utimer_notifier_block);
+	rtnl_lock();
+	for_each_net(net) {
+		for_each_netdev(net, dev) {
+			utimer_notifier_call(&utimer_notifier_block,
+					     NETDEV_DOWN, dev);
+		}
+	}
+	rtnl_unlock();
+}
+
+/*
+ * The actual xt_tables plugin.
+ */
+static unsigned int xt_idletimer_target(struct sk_buff *skb,
+					 const struct xt_action_param *par)
+{
+	const struct xt_idletimer_info *info = par->targinfo;
+
+	if (par->in != NULL)
+		utimer_reset(info);
+
+	if (par->out != NULL) {
+		utimer_reset(info);
+	}
+
+	return XT_CONTINUE;
+}
+
+static int xt_idletimer_checkentry(const struct xt_tgchk_param *par)
+{
+	const struct xt_idletimer_info *info = par->targinfo;
+	const struct ipt_entry *entryinfo = par->entryinfo;
+	const struct ipt_ip *ip = &entryinfo->ip;
+
+	pr_debug("xt_idletimer: checkentry targinfo %p\n", par->targinfo);
+
+	if (info->timeout == 0) {
+		pr_debug("xt_idletimer: timeout value is zero\n");
+		return -EINVAL;
+	}
+
+	/* FIXME: implement support for other protocol families */
+	switch (par->family) {
+	case NFPROTO_IPV4   :
+		pr_debug("xt_idletimer: NFPROTO_IPV4\n");
+		break;
+
+	default:
+		pr_debug("xt_idletimer: Unsupported protocol family family!\n");
+		return -EINVAL;
+	}
+
+	if (strlen(ip->iniface) == 0 && strlen(ip->outiface) == 0) {
+		pr_debug("xt_idletimer: in or out interface must "
+			 "be specified\n");
+		return -EINVAL;
+	}
+
+	if (utimer_create(ip->iniface, par->net, info) == NULL) {
+		pr_debug("xt_idletimer: failed to create timer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void xt_idletimer_destroy(const struct xt_tgdtor_param *par)
+{
+	const struct xt_idletimer_info *info = par->targinfo;
+
+	pr_debug("xt_idletimer: destroy targinfo %p\n", par->targinfo);
+
+	utimer_delete(info);
+}
+
+static struct xt_target xt_idletimer = {
+	.name		= "IDLETIMER",
+	.family		= NFPROTO_IPV4,
+	.target		= xt_idletimer_target,
+	.targetsize     = sizeof(struct xt_idletimer_info),
+	.checkentry	= xt_idletimer_checkentry,
+	.destroy        = xt_idletimer_destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret = utimer_init();
+	if (ret)
+		return ret;
+
+	ret =  xt_register_target(&xt_idletimer);
+	if (ret < 0) {
+		utimer_fini();
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_target(&xt_idletimer);
+	utimer_fini();
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_AUTHOR("Timo Teras <ext-timo.teras@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_DESCRIPTION("Xtables idletimer target module");
+MODULE_LICENSE("GPL");
-- 
1.6.3.3

