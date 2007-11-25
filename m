From: Patrick McHardy <kaber@trash.net>
Subject: [RFC NETFILTER 2/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:11:48 +0100
Message-ID: <4749ACD4.4010407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050607010203060408040306"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXKYRM0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:12:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050607010203060408040306
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------050607010203060408040306
Content-Type: text/x-patch;
 name="02-xt_rateest.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-xt_rateest.diff"

commit 2bc64ffb3599d4dd8bb3e9bc9b98e07d404c5b3e
Author: Patrick McHardy <kaber@trash.net>
Date:   Sun Nov 25 17:20:18 2007 +0100

    [NETFILTER]: Add xt_rateest match
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index e293ace..cc7fa00 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -29,6 +29,7 @@ header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_pkttype.h
 header-y += xt_policy.h
+header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
new file mode 100644
index 0000000..e4e0653
--- /dev/null
+++ b/include/linux/netfilter/xt_rateest.h
@@ -0,0 +1,33 @@
+#ifndef _XT_RATEEST_MATCH_H
+#define _XT_RATEEST_MATCH_H
+
+enum xt_rateest_match_flags {
+	XT_RATEEST_MATCH_INVERT	= 0x01,
+	XT_RATEEST_MATCH_ABS	= 0x02,
+	XT_RATEEST_MATCH_REL	= 0x04,
+	XT_RATEEST_MATCH_DELTA	= 0x08,
+	XT_RATEEST_MATCH_BPS	= 0x10,
+	XT_RATEEST_MATCH_PPS	= 0x20,
+};
+
+enum xt_rateest_match_mode {
+	XT_RATEEST_MATCH_NONE,
+	XT_RATEEST_MATCH_EQ,
+	XT_RATEEST_MATCH_LT,
+	XT_RATEEST_MATCH_GT,
+};
+
+struct xt_rateest_match_info {
+	char			name1[IFNAMSIZ];
+	char			name2[IFNAMSIZ];
+	u_int16_t		flags;
+	u_int16_t		mode;
+	u_int32_t		bps1;
+	u_int32_t		pps1;
+	u_int32_t		bps2;
+	u_int32_t		pps2;
+	struct xt_rateest	*est1 __attribute__((aligned(8)));
+	struct xt_rateest	*est2 __attribute__((aligned(8)));
+};
+
+#endif /* _XT_RATEEST_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6685645..a96033d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -607,6 +607,16 @@ config NETFILTER_XT_MATCH_QUOTA
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_RATEEST
+	tristate '"rateest" match support'
+	depends on NETFILTER_XTABLES
+	select NETFILTER_XT_TARGET_RATEEST
+	help
+	  This option adds a `rateest' match, which allows to match on the
+	  rate estimated by the RATEEST target.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e498282..2177dad 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
new file mode 100644
index 0000000..8027324
--- /dev/null
+++ b/net/netfilter/xt_rateest.c
@@ -0,0 +1,182 @@
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
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_rateest.h>
+#include <net/netfilter/xt_rateest.h>
+
+
+static bool xt_rateest_mt(const struct sk_buff *skb,
+			  const struct net_device *in,
+			  const struct net_device *out,
+			  const struct xt_match *match,
+			  const void *matchinfo,
+			  int offset,
+			  unsigned int protoff,
+			  bool *hotdrop)
+{
+	const struct xt_rateest_match_info *info = matchinfo;
+	struct gnet_stats_rate_est *rstats;
+	u_int32_t bps1, bps2, pps1, pps2;
+	bool ret = true;
+
+	spin_lock_bh(&info->est1->lock);
+	rstats	= &info->est1->rstats;
+	if (info->flags & XT_RATEEST_MATCH_DELTA) {
+		bps1	= info->bps1 >= rstats->bps ?
+					info->bps1 - rstats->bps : 0;
+		pps1	= info->pps1 >= rstats->pps ?
+					info->pps1 - rstats->pps : 0;
+	} else {
+		bps1	= rstats->bps;
+		pps1	= rstats->pps;
+	}
+	spin_unlock_bh(&info->est1->lock);
+
+	if (info->flags & XT_RATEEST_MATCH_ABS) {
+		bps2	= info->bps2;
+		pps2	= info->pps2;
+	} else {
+		spin_lock_bh(&info->est2->lock);
+		rstats	= &info->est2->rstats;
+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
+			bps2	= info->bps2 >= rstats->bps ?
+						info->bps2 - rstats->bps : 0;
+			pps2	= info->pps2 >= rstats->pps ?
+						info->pps2 - rstats->pps : 0;
+		} else {
+			bps2	= rstats->bps;
+			pps2	= rstats->pps;
+		}
+		spin_unlock_bh(&info->est2->lock);
+	}
+
+	switch (info->mode) {
+	case XT_RATEEST_MATCH_LT:
+		if (info->flags & XT_RATEEST_MATCH_BPS)
+			ret &= bps1 < bps2;
+		if (info->flags & XT_RATEEST_MATCH_PPS)
+			ret &= pps1 < pps2;
+		break;
+	case XT_RATEEST_MATCH_GT:
+		if (info->flags & XT_RATEEST_MATCH_BPS)
+			ret &= bps1 > bps2;
+		if (info->flags & XT_RATEEST_MATCH_PPS)
+			ret &= pps1 > pps2;
+		break;
+	case XT_RATEEST_MATCH_EQ:
+		if (info->flags & XT_RATEEST_MATCH_BPS)
+			ret &= bps1 == bps2;
+		if (info->flags & XT_RATEEST_MATCH_PPS)
+			ret &= pps2 == pps2;
+		break;
+	}
+
+	ret ^= info->flags & XT_RATEEST_MATCH_INVERT ? true : false;
+	return ret;
+}
+
+static bool xt_rateest_mt_checkentry(const char *tablename,
+				     const void *ip,
+				     const struct xt_match *match,
+				     void *matchinfo,
+				     unsigned int hook_mask)
+{
+	struct xt_rateest_match_info *info = (void *)matchinfo;
+	struct xt_rateest *est1, *est2;
+
+	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
+				     XT_RATEEST_MATCH_REL)) != 1)
+		goto err1;
+
+	if (!(info->flags & (XT_RATEEST_MATCH_BPS | XT_RATEEST_MATCH_PPS)))
+		goto err1;
+
+	switch (info->mode) {
+	case XT_RATEEST_MATCH_EQ:
+	case XT_RATEEST_MATCH_LT:
+	case XT_RATEEST_MATCH_GT:
+		break;
+	default:
+		goto err1;
+	}
+
+	est1 = xt_rateest_lookup(info->name1);
+	if (!est1)
+		goto err1;
+
+	if (info->flags & XT_RATEEST_MATCH_REL) {
+		est2 = xt_rateest_lookup(info->name2);
+		if (!est2)
+			goto err2;
+	} else
+		est2 = NULL;
+
+
+	info->est1 = est1;
+	info->est2 = est2;
+	return true;
+
+err2:
+	xt_rateest_put(est1);
+err1:
+	return false;
+}
+
+static void xt_rateest_mt_destroy(const struct xt_match *match,
+				  void *matchinfo)
+{
+	struct xt_rateest_match_info *info = (void *)matchinfo;
+
+	xt_rateest_put(info->est1);
+	if (info->est2)
+		xt_rateest_put(info->est2);
+}
+
+static struct xt_match xt_rateest_match[] __read_mostly = {
+	{
+		.family		= AF_INET,
+		.name		= "rateest",
+		.match		= xt_rateest_mt,
+		.checkentry	= xt_rateest_mt_checkentry,
+		.destroy	= xt_rateest_mt_destroy,
+		.matchsize	= sizeof(struct xt_rateest_match_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.family		= AF_INET6,
+		.name		= "rateest",
+		.match		= xt_rateest_mt,
+		.checkentry	= xt_rateest_mt_checkentry,
+		.destroy	= xt_rateest_mt_destroy,
+		.matchsize	= sizeof(struct xt_rateest_match_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_rateest_mt_init(void)
+{
+	return xt_register_matches(xt_rateest_match,
+				   ARRAY_SIZE(xt_rateest_match));
+}
+
+static void __exit xt_rateest_mt_fini(void)
+{
+	xt_unregister_matches(xt_rateest_match, ARRAY_SIZE(xt_rateest_match));
+}
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("xtables rate estimator match");
+MODULE_ALIAS("ipt_rateest");
+MODULE_ALIAS("ip6t_rateest");
+module_init(xt_rateest_mt_init);
+module_exit(xt_rateest_mt_fini);

--------------050607010203060408040306--
