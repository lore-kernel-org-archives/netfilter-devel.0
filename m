From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] netfilter: add APPROVE target
Date: Thu, 20 Jan 2011 23:47:06 +0100
Message-ID: <1295563629-14996-3-git-send-email-richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
 <1295563629-14996-2-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39946 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab1ATWr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:29 -0500
In-Reply-To: <1295563629-14996-2-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new target is related to the ruleid extension.
It accepts a packet and stores it's rule id into
the connection tracking entry.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/netfilter/xt_APPROVE.h |    8 +++
 net/netfilter/Kconfig                |   12 +++++
 net/netfilter/Makefile               |    1 +
 net/netfilter/xt_APPROVE.c           |   85 ++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_APPROVE.h
 create mode 100644 net/netfilter/xt_APPROVE.c

diff --git a/include/linux/netfilter/xt_APPROVE.h b/include/linux/netfilter/xt_APPROVE.h
new file mode 100644
index 0000000..c62c6bc
--- /dev/null
+++ b/include/linux/netfilter/xt_APPROVE.h
@@ -0,0 +1,8 @@
+#ifndef _XT_APPROVE_H
+#define _XT_APPROVE_H
+
+struct nf_approve_info {
+	u_int16_t ruleid;
+};
+
+#endif /* _XT_APPROVE_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1534f2b..34cd76c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -546,6 +546,18 @@ config NETFILTER_XT_TARGET_TRACE
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_APPROVE
+	tristate  '"APPROVE" target support'
+	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
+	help
+	  The APPROVE target allows you to add a rule ID to the
+	  connection tracking entry. So you can see which rules
+	  allowed a connection.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
 	depends on NETWORK_SECMARK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f5bff47..db8a342 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_APPROVE) += xt_APPROVE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
 
 # matches
diff --git a/net/netfilter/xt_APPROVE.c b/net/netfilter/xt_APPROVE.c
new file mode 100644
index 0000000..345465b
--- /dev/null
+++ b/net/netfilter/xt_APPROVE.c
@@ -0,0 +1,85 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/xt_APPROVE.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ruleid.h>
+
+MODULE_DESCRIPTION("Xtables: Accept a packet and mark connection with an ID");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_APPROVE");
+MODULE_ALIAS("ip6t_APPROVE");
+
+static unsigned int
+approve_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	enum ip_conntrack_info cti;
+	struct nf_conn *nfc;
+	struct nf_conn_ruleid *nfcr;
+	const struct nf_approve_info *ri = par->targinfo;
+
+	nfc = nf_ct_get(skb, &cti);
+	if (!nfc)
+		goto out;
+
+	if (nf_ct_is_untracked(nfc))
+		goto out;
+
+	spin_lock_bh(&nfc->lock);
+
+	nfcr = nf_ct_ext_find(nfc, NF_CT_EXT_RULEID);
+
+	if (!nfcr) {
+		nfcr = nf_ct_ext_add(nfc, NF_CT_EXT_RULEID, GFP_ATOMIC);
+
+		/* we're out of memory */
+		if (!nfcr)
+			goto out;
+	}
+
+	nfcr->rule[cti] = ri->ruleid;
+
+	spin_unlock_bh(&nfc->lock);
+
+out:
+	return NF_ACCEPT;
+}
+
+static int approve_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct nf_approve_info *ri = par->targinfo;
+
+	if (ri->ruleid < 1)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct xt_target approve_tg_reg __read_mostly = {
+	.name       = "APPROVE",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.table			= "filter",
+	.target     = approve_tg,
+	.targetsize	= sizeof(struct nf_approve_info),
+	.checkentry	= approve_tg_check,
+	.me         = THIS_MODULE,
+};
+
+static int __init approve_tg_init(void)
+{
+	return xt_register_target(&approve_tg_reg);
+}
+
+static void __exit approve_tg_exit(void)
+{
+	xt_unregister_target(&approve_tg_reg);
+}
+
+module_init(approve_tg_init);
+module_exit(approve_tg_exit);
-- 
1.6.6.1

