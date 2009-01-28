From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Wed, 28 Jan 2009 15:58:26 +0100
Message-ID: <20090128145826.7501.34671.stgit@Decadence>
References: <20090128145801.7501.44459.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53853 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbZA1O6c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:58:32 -0500
In-Reply-To: <20090128145801.7501.44459.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the PKTTYPE target which can be used to mangle the
skbuff packet type field. This target is useful in conjunction with
the arptables mcmangle target to TCP working again when a
multicast hardware address is used. An example of its use:

iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
	-j PKTTYPE --to-pkt-type unicast

Given the following arptables rule-set:

arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6
	\ --mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01
	\ -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

See arptables mcmangle target for further information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/xt_PKTTYPE.h |    8 ++++
 net/netfilter/Kconfig                |   18 ++++++++++
 net/netfilter/Makefile               |    1 +
 net/netfilter/xt_PKTTYPE.c           |   61 ++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 0 deletions(-)
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
index 25dcef9..9ed1ccf 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -489,6 +489,24 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
 	  TCP options from TCP packets.
 
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
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index da3d909..dd43ba9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_PKTTYPE) += xt_PKTTYPE.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
diff --git a/net/netfilter/xt_PKTTYPE.c b/net/netfilter/xt_PKTTYPE.c
new file mode 100644
index 0000000..db68dc4
--- /dev/null
+++ b/net/netfilter/xt_PKTTYPE.c
@@ -0,0 +1,61 @@
+/*
+ * (C) 2008 Pablo Neira Ayuso <pablo@netfilter.org>
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
+static struct xt_target xt_pkttype_target[] __read_mostly = {
+	{
+		.family		= AF_INET,
+		.name		= "PKTTYPE",
+		.table		= "mangle",
+		.target		= xt_pkttype_tg,
+		.targetsize	= sizeof(struct xt_pkttype_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.family		= AF_INET6,
+		.name		= "PKTTYPE",
+		.table		= "mangle",
+		.target		= xt_pkttype_tg,
+		.targetsize	= sizeof(struct xt_pkttype_target_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_pkttype_tg_init(void)
+{
+	return xt_register_targets(xt_pkttype_target,
+				   ARRAY_SIZE(xt_pkttype_target));
+}
+
+static void __exit xt_pkttype_tg_fini(void)
+{
+	xt_unregister_targets(xt_pkttype_target, ARRAY_SIZE(xt_pkttype_target));
+}
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Xtables: xt_PKTTYPE target");
+MODULE_ALIAS("ipt_PKTTYPE");
+MODULE_ALIAS("ip6t_PKTTYPE");
+module_init(xt_pkttype_tg_init);
+module_exit(xt_pkttype_tg_fini);

