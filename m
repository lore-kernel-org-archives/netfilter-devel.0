From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/17]: x_tables: add statistic match
Date: Tue, 30 May 2006 00:34:12 +0200 (MEST)
Message-ID: <20060529223411.24834.87030.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: x_tables: add statistic match

Add statistic match which is a combination of the nth and random matches.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3c167b1cf18ce1e39aa9ae2a519f4689b183f3ac
tree eeccf3380dc1d42cc4dd17d0099e1a3d9793ebd7
parent 659702e42d110153954d98e895bdc2236e3d9b98
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:40 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:40 +0200

 include/linux/netfilter/xt_statistic.h |   32 +++++++++
 net/netfilter/Kconfig                  |    6 ++
 net/netfilter/Makefile                 |    1 
 net/netfilter/xt_statistic.c           |  112 ++++++++++++++++++++++++++++++++
 4 files changed, 151 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
new file mode 100644
index 0000000..c344e99
--- /dev/null
+++ b/include/linux/netfilter/xt_statistic.h
@@ -0,0 +1,32 @@
+#ifndef _XT_STATISTIC_H
+#define _XT_STATISTIC_H
+
+enum xt_statistic_mode {
+	XT_STATISTIC_MODE_RANDOM,
+	XT_STATISTIC_MODE_NTH,
+	__XT_STATISTIC_MODE_MAX
+};
+#define XT_STATISTIC_MODE_MAX (__XT_STATISTIC_MODE_MAX - 1)
+
+enum xt_statistic_flags {
+	XT_STATISTIC_INVERT		= 0x1,
+};
+#define XT_STATISTIC_MASK		0x1
+
+struct xt_statistic_info {
+	u_int16_t			mode;
+	u_int16_t			flags;
+	union {
+		struct {
+			u_int32_t	probability;
+		} random;
+		struct {
+			u_int32_t	every;
+			u_int32_t	packet;
+			u_int32_t	count;
+		} nth;
+	} u;
+	struct xt_statistic_info	*master __attribute__((aligned(8)));
+};
+
+#endif /* _XT_STATISTIC_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5543c7b..85a7e17 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -375,6 +375,12 @@ config NETFILTER_XT_MATCH_STATE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_STATISTIC
+	tristate '"statistic" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  statistic module
+
 config NETFILTER_XT_MATCH_STRING
 	tristate  '"string" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4b6a6ea..df1da25 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) +
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
new file mode 100644
index 0000000..de1037f
--- /dev/null
+++ b/net/netfilter/xt_statistic.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on ipt_random and ipt_nth by Fabrice MARIE <fabrice@netfilter.org>.
+ */
+
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/net.h>
+
+#include <linux/netfilter/xt_statistic.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("xtables statistical match module");
+MODULE_ALIAS("ipt_statistic");
+MODULE_ALIAS("ip6t_statistic");
+
+static DEFINE_SPINLOCK(nth_lock);
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in, const struct net_device *out,
+      const struct xt_match *match, const void *matchinfo,
+      int offset, unsigned int protoff, int *hotdrop)
+{
+	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
+	int ret = info->flags & XT_STATISTIC_INVERT ? 1 : 0;
+
+	switch (info->mode) {
+	case XT_STATISTIC_MODE_RANDOM:
+		if ((net_random() & 0x7FFFFFFF) < info->u.random.probability)
+			ret ^= 1;
+		break;
+	case XT_STATISTIC_MODE_NTH:
+		info = info->master;
+		spin_lock_bh(&nth_lock);
+		if (info->u.nth.count++ == info->u.nth.every) {
+			info->u.nth.count = 0;
+			ret ^= 1;
+		}
+		spin_unlock_bh(&nth_lock);
+		break;
+	}
+
+	return ret;
+}
+
+static int
+checkentry(const char *tablename, const void *entry,
+	   const struct xt_match *match, void *matchinfo,
+	   unsigned int matchsize, unsigned int hook_mask)
+{
+	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
+
+	if (info->mode > XT_STATISTIC_MODE_MAX ||
+	    info->flags & ~XT_STATISTIC_MASK)
+		return 0;
+	info->master = info;
+	return 1;
+}
+
+static struct xt_match statistic_match = {
+	.name		= "statistic",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_statistic_info),
+	.checkentry	= checkentry,
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match statistic_match6 = {
+	.name		= "statistic",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_statistic_info),
+	.checkentry	= checkentry,
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_statistic_init(void)
+{
+	int ret;
+
+	ret = xt_register_match(&statistic_match);
+	if (ret)
+		goto err1;
+
+	ret = xt_register_match(&statistic_match6);
+	if (ret)
+		goto err2;
+	return ret;
+err2:
+	xt_unregister_match(&statistic_match);
+err1:
+	return ret;
+}
+
+static void __exit xt_statistic_fini(void)
+{
+	xt_unregister_match(&statistic_match6);
+	xt_unregister_match(&statistic_match);
+}
+
+module_init(xt_statistic_init);
+module_exit(xt_statistic_fini);
