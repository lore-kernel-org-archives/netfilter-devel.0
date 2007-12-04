From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/49]: x_tables: add rateest match
Date: Tue,  4 Dec 2007 13:02:19 +0100 (MET)
Message-ID: <20071204120219.2442.14986.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62145 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbXLDMCU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:20 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: add rateest match

Add rate estimator match. The rate estimator match can match on
estimated rates by the RATEEST target. It supports matching on
absolute bps/pps values, comparing two rate estimators and matching
on the difference between two rate estimators.

This is what I use to route outgoing data connections from a FTP
server over two lines based on the  available bandwidth:

# estimate outgoing rates
iptables -t mangle -A POSTROUTING -o eth0 -j RATEEST --rateest-name eth0 \
                                                     --rateest-interval 250ms \
                                                     --rateest-ewma 0.5s
iptables -t mangle -A POSTROUTING -o ppp0 -j RATEEST --rateest-name ppp0 \
                                                     --rateest-interval 250ms \
                                                     --rateest-ewma 0.5s

# mark based on available bandwidth
iptables -t mangle -A BALANCE -m state --state NEW \
                              -m helper --helper ftp \
                              -m rateest --rateest-delta \
                                         --rateest1 eth0 \
                                         --rateest-bps1 2.5mbit \
                                         --rateest-gt \
                                         --rateest2 ppp0 \
                                         --rateest-bps2 2mbit \
                              -j CONNMARK --set-mark 0x1

iptables -t mangle -A BALANCE -m state --state NEW \
                              -m helper --helper ftp \
                              -m rateest --rateest-delta \
                                         --rateest1 ppp0 \
                                         --rateest-bps1 2mbit \
                                         --rateest-gt \
                                         --rateest2 eth0 \
                                         --rateest-bps2 2.5mbit \
                              -j CONNMARK --set-mark 0x2

iptables -t mangle -A BALANCE -j CONNMARK --restore-mark

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 57b89170e9765f9ce899abf12ac4e0a91b5cc42c
tree 157fc15b8c40f19194d24c4d10a83400a19db591
parent 8c6e468fc5afd31f405d87c2977f013b8343fe1d
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:26:52 +0100

 include/linux/netfilter/Kbuild       |    1 
 include/linux/netfilter/xt_rateest.h |   33 ++++++
 net/netfilter/Kconfig                |   10 ++
 net/netfilter/Makefile               |    1 
 net/netfilter/xt_rateest.c           |  178 ++++++++++++++++++++++++++++++++++
 5 files changed, 223 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 707a158..ac9e642 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -30,6 +30,7 @@ header-y += xt_multiport.h
 header-y += xt_owner.h
 header-y += xt_pkttype.h
 header-y += xt_policy.h
+header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
new file mode 100644
index 0000000..51948e1
--- /dev/null
+++ b/include/linux/netfilter/xt_rateest.h
@@ -0,0 +1,33 @@
+#ifndef _XT_RATEEST_MATCH_H
+#define _XT_RATEEST_MATCH_H
+
+enum xt_rateest_match_flags {
+	XT_RATEEST_MATCH_INVERT	= 1<<0,
+	XT_RATEEST_MATCH_ABS	= 1<<1,
+	XT_RATEEST_MATCH_REL	= 1<<2,
+	XT_RATEEST_MATCH_DELTA	= 1<<3,
+	XT_RATEEST_MATCH_BPS	= 1<<4,
+	XT_RATEEST_MATCH_PPS	= 1<<5,
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
index 22d1f10..4182393 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -631,6 +631,16 @@ config NETFILTER_XT_MATCH_QUOTA
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
index 413afaa..3b9ea8f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
new file mode 100644
index 0000000..fdb86a5
--- /dev/null
+++ b/net/netfilter/xt_rateest.c
@@ -0,0 +1,178 @@
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
+	struct gnet_stats_rate_est *r;
+	u_int32_t bps1, bps2, pps1, pps2;
+	bool ret = true;
+
+	spin_lock_bh(&info->est1->lock);
+	r = &info->est1->rstats;
+	if (info->flags & XT_RATEEST_MATCH_DELTA) {
+		bps1 = info->bps1 >= r->bps ? info->bps1 - r->bps : 0;
+		pps1 = info->pps1 >= r->pps ? info->pps1 - r->pps : 0;
+	} else {
+		bps1 = r->bps;
+		pps1 = r->pps;
+	}
+	spin_unlock_bh(&info->est1->lock);
+
+	if (info->flags & XT_RATEEST_MATCH_ABS) {
+		bps2 = info->bps2;
+		pps2 = info->pps2;
+	} else {
+		spin_lock_bh(&info->est2->lock);
+		r = &info->est2->rstats;
+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
+			bps2 = info->bps2 >= r->bps ? info->bps2 - r->bps : 0;
+			pps2 = info->pps2 >= r->pps ? info->pps2 - r->pps : 0;
+		} else {
+			bps2 = r->bps;
+			pps2 = r->pps;
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
