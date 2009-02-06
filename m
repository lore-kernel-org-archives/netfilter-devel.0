From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Fri, 06 Feb 2009 08:42:19 +0100
Message-ID: <20090206074219.6408.28785.stgit@Decadence>
References: <20090206074155.6408.93173.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36983 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbZBFHmk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:42:40 -0500
In-Reply-To: <20090206074155.6408.93173.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the PKTTYPE target which can be used to mangle the
skbuff packet type field. This target is useful in conjunction with
the arptables mcmangle target to TCP working again when a
multicast hardware address is used. An example of its use:

iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
	-m pkttype --pkt-type multicast \
	-j PKTTYPE --to-pkt-type unicast

Given the following arptables rule-set:

arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6 \
	--mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01 \
	-j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

See arptables mcmangle target for further information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/xt_PKTTYPE.h |    8 +++++
 net/netfilter/Kconfig                |   18 ++++++++++++
 net/netfilter/Makefile               |    1 +
 net/netfilter/xt_PKTTYPE.c           |   50 ++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_PKTTYPE.h
 create mode 100644 net/netfilter/xt_PKTTYPE.c

diff --git a/include/linux/netfilter/xt_PKTTYPE.h b/include/linux/netfilter/xt_PKTTYPE.h
new file mode 100644
index 0000000..cc67cbf
--- /dev/null
+++ b/include/linux/netfilter/xt_PKTTYPE.h
@@ -0,0 +1,8 @@
+#ifndef _XT_PKTTYPE_TARGET_H
+#define _XT_PKTTYPE_TARGET_H
+
+struct xt_pkttype_target_info {
+	u_int8_t pkt_type;
+};
+
+#endif /* _XT_PKTTYPE_TARGET_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c2bac9c..843463f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -405,6 +405,24 @@ config NETFILTER_XT_TARGET_NOTRACK
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_PKTTYPE
+	tristate  '"PKTTYPE" target support'
+	depends on IP_NF_RAW || IP6_NF_RAW
+	depends on NETFILTER_ADVANCED
+	help
+	  The PKTTYPE target allows you to change the link layer packet type.
+	  This target is useful if you have set up a multicast MAC address (via
+	  arptables) for a given interface and you want the packets to reach
+	  the layer 4 stack (which would drop packet tagged as multicast
+	  from the link layer).
+
+	  This target can be used in conjunction with arptables and the cluster
+	  match to setup cluster of stateful firewalls which are connected
+	  through a switch.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index da3d909..1f1315a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_PKTTYPE) += xt_PKTTYPE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
diff --git a/net/netfilter/xt_PKTTYPE.c b/net/netfilter/xt_PKTTYPE.c
new file mode 100644
index 0000000..2ed6185
--- /dev/null
+++ b/net/netfilter/xt_PKTTYPE.c
@@ -0,0 +1,50 @@
+/*
+ * (C) 2008-2009 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/jhash.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/xt_PKTTYPE.h>
+
+static unsigned int
+xt_pkttype_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_pkttype_target_info *info = par->targinfo;
+
+	skb->pkt_type = info->pkt_type;
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target xt_pkttype_target __read_mostly = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "PKTTYPE",
+	.table		= "mangle",
+	.target		= xt_pkttype_tg,
+	.targetsize	= sizeof(struct xt_pkttype_target_info),
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_pkttype_tg_init(void)
+{
+	return xt_register_target(&xt_pkttype_target);
+}
+
+static void __exit xt_pkttype_tg_fini(void)
+{
+	xt_unregister_target(&xt_pkttype_target);
+}
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: set skbuff packet type");
+MODULE_ALIAS("ipt_PKTTYPE");
+MODULE_ALIAS("ip6t_PKTTYPE");
+module_init(xt_pkttype_tg_init);
+module_exit(xt_pkttype_tg_fini);

