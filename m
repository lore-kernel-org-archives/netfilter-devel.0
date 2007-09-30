From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 11/13] xtables TPROXY target
Date: Sun, 30 Sep 2007 23:40:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709302339290.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205335.10969.91031.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46555 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXI3Vko (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:40:44 -0400
In-Reply-To: <20070930205335.10969.91031.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 22:53, KOVACS Krisztian wrote:
>The TPROXY target implements redirection of non-local TCP/UDP traffic to local
>sockets. Additionally, it's possible to manipulate the packet mark if and only
>if a socket has been found. (We need this because we cannot use multiple
>targets in the same iptables rule.)

This provides xt_TPROXY.

===
iptables TPROXY target

From: KOVACS Krisztian <hidden@balabit.hu>

The TPROXY target implements redirection of non-local TCP/UDP traffic
to local sockets. It is simply a wrapper around functionality exported
from iptable_tproxy.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---

 include/linux/netfilter/xt_TPROXY.h |    9 ++++
 net/ipv4/netfilter/Kconfig          |   11 +++++
 net/netfilter/Makefile              |    1 
 net/netfilter/xt_TPROXY.c           |   76 ++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+)

Index: linux-2.6.22.1/include/linux/netfilter/xt_TPROXY.h
===================================================================
--- /dev/null
+++ linux-2.6.22.1/include/linux/netfilter/xt_TPROXY.h
@@ -0,0 +1,9 @@
+#ifndef _XT_TPROXY_H
+#define _XT_TPROXY_H
+
+struct xt_tproxy_info {
+	u_int32_t laddr;
+	u_int16_t lport;
+};
+
+#endif /* _XT_TPROXY_H */
Index: linux-2.6.22.1/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.22.1.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6.22.1/net/ipv4/netfilter/Kconfig
@@ -403,6 +403,17 @@ config IP_NF_TPROXY_TABLE
 
 	  To compile it as a module, choose M here.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_TPROXY
+	tristate "TPROXY target support"
+	depends on IP_NF_TPROXY_TABLE
+	help
+	  This option adds a `TPROXY' target, which is somewhat similar to
+	  REDIRECT.  It can only be used in the tproxy table and is useful
+	  to redirect traffic to a transparent proxy.  It does _not_ depend
+	  on Netfilter connection tracking.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
Index: linux-2.6.22.1/net/netfilter/Makefile
===================================================================
--- linux-2.6.22.1.orig/net/netfilter/Makefile
+++ linux-2.6.22.1/net/netfilter/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) 
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TARPIT) += xt_TARPIT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 
 # matches
Index: linux-2.6.22.1/net/netfilter/xt_TPROXY.c
===================================================================
--- /dev/null
+++ linux-2.6.22.1/net/netfilter/xt_TPROXY.c
@@ -0,0 +1,76 @@
+/*
+ * Transparent proxy support for Linux/iptables
+ *
+ * Copyright (c) 2006-2007 BalaBit IT Ltd.
+ * Author: Balazs Scheidler, Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/ip.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_tproxy.h>
+#include <linux/netfilter/xt_TPROXY.h>
+#include <net/checksum.h>
+#include <net/inet_sock.h>
+#include <net/udp.h>
+
+static unsigned int
+tproxy_target(struct sk_buff **pskb, const struct net_device *in,
+              const struct net_device *out, unsigned int hooknum,
+              const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tproxy_info *tgi = targinfo;
+	const struct iphdr *iph = ip_hdr(*pskb);
+	struct sk_buff *skb = *pskb;
+	struct udphdr _hdr, *hp;
+
+	/* TCP/UDP only */
+	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
+		return NF_ACCEPT;
+
+	hp = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return NF_DROP;
+
+	skb->nf_tproxy.redirect_address = tgi->laddr ? : iph->daddr;
+	skb->nf_tproxy.redirect_port    = tgi->lport ? : hp->dest;
+
+	pr_debug(KERN_DEBUG "redirecting: proto %d %08x:%d -> %08x:%d\n",
+	         iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
+	         ntohl(skb->nf_tproxy.redirect_address),
+	         ntohs(skb->nf_tproxy.redirect_port));
+
+	return NF_ACCEPT;
+}
+
+static struct xt_target xt_tproxy_reg __read_mostly = {
+	.name       = "TPROXY",
+	.family     = AF_INET,
+	.table      = "tproxy",
+	.target     = tproxy_target,
+	.targetsize = sizeof(struct xt_tproxy_info),
+	.me         = THIS_MODULE,
+};
+
+static int __init xt_tproxy_init(void)
+{
+	return xt_register_target(&xt_tproxy_reg);
+}
+
+static void __exit xt_tproxy_exit(void)
+{
+	xt_unregister_target(&xt_tproxy_reg);
+}
+
+module_init(xt_tproxy_init);
+module_exit(xt_tproxy_exit);
+MODULE_AUTHOR("Krisztian Kovacs <hidden@balabit.hu>");
+MODULE_DESCRIPTION("Netfilter transparent proxy TPROXY target module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TPROXY");
