From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 48/79: iptables TPROXY target
Date: Wed,  8 Oct 2008 12:47:26 +0200 (MEST)
Message-ID: <20081008104725.10423.76152.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbYJHKr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:27 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit e84392707e10301b93121e1b74e2823db50cdf9e
Author: KOVACS Krisztian <hidden@sch.bme.hu>
Date:   Wed Oct 8 11:35:12 2008 +0200

    netfilter: iptables TPROXY target
    
    The TPROXY target implements redirection of non-local TCP/UDP traffic to local
    sockets. Additionally, it's possible to manipulate the packet mark if and only
    if a socket has been found. (We need this because we cannot use multiple
    targets in the same iptables rule.)
    
    Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
new file mode 100644
index 0000000..152e8f9
--- /dev/null
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -0,0 +1,14 @@
+#ifndef _XT_TPROXY_H_target
+#define _XT_TPROXY_H_target
+
+/* TPROXY target is capable of marking the packet to perform
+ * redirection. We can get rid of that whenever we get support for
+ * mutliple targets in the same rule. */
+struct xt_tproxy_target_info {
+	u_int32_t mark_mask;
+	u_int32_t mark_value;
+	__be32 laddr;
+	__be16 lport;
+};
+
+#endif /* _XT_TPROXY_H_target */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f6c8072..de18bba 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -421,6 +421,21 @@ config NETFILTER_XT_TARGET_RATEEST
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_TPROXY
+	tristate '"TPROXY" target support (EXPERIMENTAL)'
+	depends on EXPERIMENTAL
+	depends on NETFILTER_TPROXY
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	select NF_DEFRAG_IPV4
+	help
+	  This option adds a `TPROXY' target, which is somewhat similar to
+	  REDIRECT.  It can only be used in the mangle table and is useful
+	  to redirect traffic to a transparent proxy.  It does _not_ depend
+	  on Netfilter connection tracking and NAT, unlike REDIRECT.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1cdc3a1..8ce6766 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
new file mode 100644
index 0000000..183f251
--- /dev/null
+++ b/net/netfilter/xt_TPROXY.c
@@ -0,0 +1,112 @@
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
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <net/udp.h>
+#include <net/inet_sock.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/xt_TPROXY.h>
+
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/nf_tproxy_core.h>
+
+static unsigned int
+tproxy_tg(struct sk_buff *skb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  unsigned int hooknum,
+	  const struct xt_target *target,
+	  const void *targinfo)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct xt_tproxy_target_info *tgi = targinfo;
+	struct udphdr _hdr, *hp;
+	struct sock *sk;
+
+	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return NF_DROP;
+
+	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), iph->protocol,
+				   iph->saddr, tgi->laddr ? tgi->laddr : iph->daddr,
+				   hp->source, tgi->lport ? tgi->lport : hp->dest,
+				   in, true);
+
+	/* NOTE: assign_sock consumes our sk reference */
+	if (sk && nf_tproxy_assign_sock(skb, sk)) {
+		/* This should be in a separate target, but we don't do multiple
+		   targets on the same rule yet */
+		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
+
+		pr_debug("redirecting: proto %u %08x:%u -> %08x:%u, mark: %x\n",
+			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
+			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
+		return NF_ACCEPT;
+	}
+
+	pr_debug("no socket, dropping: proto %u %08x:%u -> %08x:%u, mark: %x\n",
+		 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
+		 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
+	return NF_DROP;
+}
+
+static bool
+tproxy_tg_check(const char *tablename,
+		const void *entry,
+		const struct xt_target *target,
+		void *targetinfo,
+		unsigned int hook_mask)
+{
+	const struct ipt_ip *i = entry;
+
+	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
+	    && !(i->invflags & IPT_INV_PROTO))
+		return true;
+
+	pr_info("xt_TPROXY: Can be used only in combination with "
+		"either -p tcp or -p udp\n");
+	return false;
+}
+
+static struct xt_target tproxy_tg_reg __read_mostly = {
+	.name		= "TPROXY",
+	.family		= AF_INET,
+	.table		= "mangle",
+	.target		= tproxy_tg,
+	.targetsize	= sizeof(struct xt_tproxy_target_info),
+	.checkentry	= tproxy_tg_check,
+	.hooks		= 1 << NF_INET_PRE_ROUTING,
+	.me		= THIS_MODULE,
+};
+
+static int __init tproxy_tg_init(void)
+{
+	nf_defrag_ipv4_enable();
+	return xt_register_target(&tproxy_tg_reg);
+}
+
+static void __exit tproxy_tg_exit(void)
+{
+	xt_unregister_target(&tproxy_tg_reg);
+}
+
+module_init(tproxy_tg_init);
+module_exit(tproxy_tg_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Krisztian Kovacs");
+MODULE_DESCRIPTION("Netfilter transparent proxy (TPROXY) target module.");
+MODULE_ALIAS("ipt_TPROXY");
