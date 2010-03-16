From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] netfilter: xtables: merge xt_NOTRACK into xt_CT
Date: Tue, 16 Mar 2010 02:32:10 +0100
Message-ID: <1268703135-2622-7-git-send-email-jengelh@medozas.de>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49810 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965928Ab0CPBca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:30 -0400
In-Reply-To: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://marc.info/?l=netfilter-devel&m=126443812131414&w=2
References: Message-Id: <4B5DCB63.7020704@trash.net>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig      |   21 +++++------------
 net/netfilter/Makefile     |    1 -
 net/netfilter/xt_CT.c      |   54 ++++++++++++++++++++++++++++++++++---------
 net/netfilter/xt_NOTRACK.c |   53 -------------------------------------------
 4 files changed, 48 insertions(+), 81 deletions(-)
 delete mode 100644 net/netfilter/xt_NOTRACK.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8550dfd..b68f2f9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -382,7 +382,7 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_CT
-	tristate '"CT" target support'
+	tristate '"CT" and "NOTRACK"'
 	depends on NF_CONNTRACK
 	depends on IP_NF_RAW || IP6_NF_RAW
 	depends on NETFILTER_ADVANCED
@@ -391,6 +391,11 @@ config NETFILTER_XT_TARGET_CT
 	  connection tracking parameters like events to be delivered and
 	  the helper to be used.
 
+	  The NOTRACK target allows a select rule to specify
+	  which packets *not* to enter the conntrack/NAT
+	  subsystem with all the consequences (no ICMP error tracking,
+	  no protocol helpers for the selected packets).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_DSCP
@@ -478,20 +483,6 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NETFILTER_XT_TARGET_NOTRACK
-	tristate  '"NOTRACK" target support'
-	depends on IP_NF_RAW || IP6_NF_RAW
-	depends on NF_CONNTRACK
-	depends on NETFILTER_ADVANCED
-	help
-	  The NOTRACK target allows a select rule to specify
-	  which packets *not* to enter the conntrack/NAT
-	  subsystem with all the consequences (no ICMP error tracking,
-	  no protocol helpers for the selected packets).
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
-
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index cd31afe..e1a46fe 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index fda603e..afe40f3 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -134,31 +134,61 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
 	nf_ct_put(info->ct);
 }
 
-static struct xt_target xt_ct_tg __read_mostly = {
-	.name		= "CT",
-	.family		= NFPROTO_UNSPEC,
-	.targetsize	= XT_ALIGN(sizeof(struct xt_ct_target_info)),
-	.checkentry	= xt_ct_tg_check,
-	.destroy	= xt_ct_tg_destroy,
-	.target		= xt_ct_target,
-	.table		= "raw",
-	.me		= THIS_MODULE,
+static unsigned int
+notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	/* Previously seen (loopback)? Ignore. */
+	if (skb->nfct != NULL)
+		return XT_CONTINUE;
+
+	/* Attach fake conntrack entry.
+	   If there is a real ct entry correspondig to this packet,
+	   it'll hang aroun till timing out. We don't deal with it
+	   for performance reasons. JK */
+	skb->nfct = &nf_conntrack_untracked.ct_general;
+	skb->nfctinfo = IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target xt_ct_tg_reg[] __read_mostly = {
+	{
+		.name		= "CT",
+		.family		= NFPROTO_UNSPEC,
+		.targetsize	= XT_ALIGN(sizeof(struct xt_ct_target_info)),
+		.checkentry	= xt_ct_tg_check,
+		.destroy	= xt_ct_tg_destroy,
+		.target		= xt_ct_target,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name     = "NOTRACK",
+		.revision = 0,
+		.family   = NFPROTO_UNSPEC,
+		.target   = notrack_tg,
+		.table    = "raw",
+		.me       = THIS_MODULE,
+	},
 };
 
 static int __init xt_ct_tg_init(void)
 {
-	return xt_register_target(&xt_ct_tg);
+	return xt_register_targets(xt_ct_tg_reg, ARRAY_SIZE(xt_ct_tg_reg));
 }
 
 static void __exit xt_ct_tg_exit(void)
 {
-	xt_unregister_target(&xt_ct_tg);
+	xt_unregister_targets(xt_ct_tg_reg, ARRAY_SIZE(xt_ct_tg_reg));
 }
 
 module_init(xt_ct_tg_init);
 module_exit(xt_ct_tg_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Xtables: connection tracking target");
+MODULE_DESCRIPTION("Xtables: connection tracking targets");
 MODULE_ALIAS("ipt_CT");
 MODULE_ALIAS("ip6t_CT");
+MODULE_ALIAS("ipt_NOTRACK");
+MODULE_ALIAS("ip6t_NOTRACK");
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
deleted file mode 100644
index e7a0a54..0000000
--- a/net/netfilter/xt_NOTRACK.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/* This is a module which is used for setting up fake conntracks
- * on packets so that they are not seen by the conntrack/NAT code.
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <net/netfilter/nf_conntrack.h>
-
-MODULE_DESCRIPTION("Xtables: Disabling connection tracking for packets");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_NOTRACK");
-MODULE_ALIAS("ip6t_NOTRACK");
-
-static unsigned int
-notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
-{
-	/* Previously seen (loopback)? Ignore. */
-	if (skb->nfct != NULL)
-		return XT_CONTINUE;
-
-	/* Attach fake conntrack entry.
-	   If there is a real ct entry correspondig to this packet,
-	   it'll hang aroun till timing out. We don't deal with it
-	   for performance reasons. JK */
-	skb->nfct = &nf_conntrack_untracked.ct_general;
-	skb->nfctinfo = IP_CT_NEW;
-	nf_conntrack_get(skb->nfct);
-
-	return XT_CONTINUE;
-}
-
-static struct xt_target notrack_tg_reg __read_mostly = {
-	.name     = "NOTRACK",
-	.revision = 0,
-	.family   = NFPROTO_UNSPEC,
-	.target   = notrack_tg,
-	.table    = "raw",
-	.me       = THIS_MODULE,
-};
-
-static int __init notrack_tg_init(void)
-{
-	return xt_register_target(&notrack_tg_reg);
-}
-
-static void __exit notrack_tg_exit(void)
-{
-	xt_unregister_target(&notrack_tg_reg);
-}
-
-module_init(notrack_tg_init);
-module_exit(notrack_tg_exit);
-- 
1.7.0.2

