From: Patrick McHardy <kaber@trash.net>
Subject: [RFC NETFILTER 1/4]: add xt_RATEEST target
Date: Sun, 25 Nov 2007 18:11:43 +0100
Message-ID: <4749ACCF.3020806@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080006030003080004040602"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64258 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXKYRMV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:12:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080006030003080004040602
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------080006030003080004040602
Content-Type: text/x-patch;
 name="01-xt_RATEEST.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-xt_RATEEST.diff"

commit 1b34dd10f004f7490b80ae52ec662d00c4c268e0
Author: Patrick McHardy <kaber@trash.net>
Date:   Sun Nov 25 17:11:01 2007 +0100

    [NETFILTER]: add xt_RATEEST target
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index b87e83a..e293ace 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -10,6 +10,7 @@ header-y += xt_DSCP.h
 header-y += xt_MARK.h
 header-y += xt_NFLOG.h
 header-y += xt_NFQUEUE.h
+header-y += xt_RATEEST.h
 header-y += xt_SECMARK.h
 header-y += xt_TCPMSS.h
 header-y += xt_comment.h
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
new file mode 100644
index 0000000..ed9665f
--- /dev/null
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -0,0 +1,11 @@
+#ifndef _XT_RATEEST_TARGET_H
+#define _XT_RATEEST_TARGET_H
+
+struct xt_rateest_target_info {
+	char			name[IFNAMSIZ];
+	signed char		interval;
+	unsigned char		ewma_log;
+	struct xt_rateest	*est __attribute__((aligned(8)));
+};
+
+#endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/net/netfilter/xt_rateest.h b/include/net/netfilter/xt_rateest.h
new file mode 100644
index 0000000..65d594d
--- /dev/null
+++ b/include/net/netfilter/xt_rateest.h
@@ -0,0 +1,17 @@
+#ifndef _XT_RATEEST_H
+#define _XT_RATEEST_H
+
+struct xt_rateest {
+	struct hlist_node		list;
+	char				name[IFNAMSIZ];
+	unsigned int			refcnt;
+	spinlock_t			lock;
+	struct gnet_estimator		params;
+	struct gnet_stats_rate_est	rstats;
+	struct gnet_stats_basic		bstats;
+};
+
+extern struct xt_rateest *xt_rateest_lookup(const char *name);
+extern void xt_rateest_put(struct xt_rateest *est);
+
+#endif /* _XT_RATEEST_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21a9fcc..6685645 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -353,6 +353,16 @@ config NETFILTER_XT_TARGET_NOTRACK
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_RATEEST
+	tristate '"RATEEST" target support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `RATEEST' target, which allows to measure
+	  rates similar to TC estimators. The `rateest' match can be
+	  used to match on the measured rates.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ad0e36e..e498282 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
new file mode 100644
index 0000000..c008883
--- /dev/null
+++ b/net/netfilter/xt_RATEEST.c
@@ -0,0 +1,204 @@
+/*
+ * (C) 2007 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/gen_stats.h>
+#include <linux/jhash.h>
+#include <linux/rtnetlink.h>
+#include <linux/random.h>
+#include <net/gen_stats.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_RATEEST.h>
+#include <net/netfilter/xt_rateest.h>
+
+static DEFINE_MUTEX(xt_rateest_mutex);
+
+#define RATEEST_HSIZE	16
+static struct hlist_head rateest_hash[RATEEST_HSIZE] __read_mostly;
+static unsigned int jhash_rnd __read_mostly;
+
+static unsigned int xt_rateest_hash(const char *name)
+{
+	return jhash(name, FIELD_SIZEOF(struct xt_rateest, name), jhash_rnd) &
+	       (RATEEST_HSIZE - 1);
+}
+
+static void xt_rateest_hash_insert(struct xt_rateest *est)
+{
+	unsigned int h;
+
+	h = xt_rateest_hash(est->name);
+	hlist_add_head(&est->list, &rateest_hash[h]);
+}
+
+struct xt_rateest *xt_rateest_lookup(const char *name)
+{
+	struct xt_rateest *est;
+	struct hlist_node *n;
+	unsigned int h;
+
+	h = xt_rateest_hash(name);
+	mutex_lock(&xt_rateest_mutex);
+	hlist_for_each_entry(est, n, &rateest_hash[h], list) {
+		if (strcmp(est->name, name) == 0) {
+			est->refcnt++;
+			mutex_unlock(&xt_rateest_mutex);
+			return est;
+		}
+	}
+	mutex_unlock(&xt_rateest_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt_rateest_lookup);
+
+void xt_rateest_put(struct xt_rateest *est)
+{
+	mutex_lock(&xt_rateest_mutex);
+	if (--est->refcnt == 0) {
+		hlist_del(&est->list);
+		gen_kill_estimator(&est->bstats, &est->rstats);
+		kfree(est);
+	}
+	mutex_unlock(&xt_rateest_mutex);
+}
+EXPORT_SYMBOL_GPL(xt_rateest_put);
+
+static unsigned int
+xt_rateest_tg(struct sk_buff *skb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      unsigned int hooknum,
+	      const struct xt_target *target,
+	      const void *targinfo)
+{
+	const struct xt_rateest_target_info *info = targinfo;
+	struct gnet_stats_basic *stats = &info->est->bstats;
+
+	spin_lock_bh(&info->est->lock);
+	stats->bytes += skb->len;
+	stats->packets++;
+	spin_unlock_bh(&info->est->lock);
+
+	return XT_CONTINUE;
+}
+
+static bool
+xt_rateest_tg_checkentry(const char *tablename,
+			 const void *entry,
+			 const struct xt_target *target,
+			 void *targinfo,
+			 unsigned int hook_mask)
+{
+	struct xt_rateest_target_info *info = (void *)targinfo;
+	struct xt_rateest *est;
+	struct {
+		struct rtattr		opt;
+		struct gnet_estimator	est;
+	} cfg;
+
+	est = xt_rateest_lookup(info->name);
+	if (est) {
+		/*
+		 * If estimator parameters are specified, they must match the
+		 * existing estimator.
+		 */
+		if ((!info->interval && !info->ewma_log) ||
+		    (info->interval != est->params.interval ||
+		     info->ewma_log != est->params.ewma_log)) {
+			xt_rateest_put(est);
+			return false;
+		}
+		info->est = est;
+		return true;
+	}
+
+	est = kzalloc(sizeof(*est), GFP_KERNEL);
+	if (!est)
+		goto err1;
+
+	strlcpy(est->name, info->name, sizeof(est->name));
+	spin_lock_init(&est->lock);
+	est->refcnt		= 1;
+	est->params.interval	= info->interval;
+	est->params.ewma_log	= info->ewma_log;
+
+	cfg.opt.rta_len		= RTA_LENGTH(sizeof(cfg.est));
+	cfg.opt.rta_type	= TCA_STATS_RATE_EST;
+	cfg.est.interval	= info->interval;
+	cfg.est.ewma_log	= info->ewma_log;
+
+	if (gen_new_estimator(&est->bstats, &est->rstats, &est->lock,
+			      &cfg.opt) < 0)
+		goto err2;
+
+	info->est = est;
+	xt_rateest_hash_insert(est);
+
+	return true;
+
+err2:
+	kfree(est);
+err1:
+	return false;
+}
+
+static void xt_rateest_tg_destroy(const struct xt_target *target,
+				  void *targinfo)
+{
+	struct xt_rateest_target_info *info = targinfo;
+
+	xt_rateest_put(info->est);
+}
+
+static struct xt_target xt_rateest_target[] __read_mostly = {
+	{
+		.family		= AF_INET,
+		.name		= "RATEEST",
+		.target		= xt_rateest_tg,
+		.checkentry	= xt_rateest_tg_checkentry,
+		.destroy	= xt_rateest_tg_destroy,
+		.targetsize	= sizeof(struct xt_rateest_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.family		= AF_INET6,
+		.name		= "RATEEST",
+		.target		= xt_rateest_tg,
+		.checkentry	= xt_rateest_tg_checkentry,
+		.destroy	= xt_rateest_tg_destroy,
+		.targetsize	= sizeof(struct xt_rateest_target_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_rateest_tg_init(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rateest_hash); i++)
+		INIT_HLIST_HEAD(&rateest_hash[i]);
+
+	get_random_bytes(&jhash_rnd, sizeof(jhash_rnd));
+	return xt_register_targets(xt_rateest_target,
+				   ARRAY_SIZE(xt_rateest_target));
+}
+
+static void __exit xt_rateest_tg_fini(void)
+{
+	xt_unregister_targets(xt_rateest_target, ARRAY_SIZE(xt_rateest_target));
+}
+
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("xtables rate estimator");
+MODULE_ALIAS("ipt_RATEEST");
+MODULE_ALIAS("ip6t_RATEEST");
+module_init(xt_rateest_tg_init);
+module_exit(xt_rateest_tg_fini);

--------------080006030003080004040602--
