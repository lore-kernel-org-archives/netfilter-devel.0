From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 11/13] iptables TPROXY target
Date: Sun, 30 Sep 2007 22:53:35 +0200
Message-ID: <20070930205335.10969.91031.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40443 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXI3VL6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:58 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The TPROXY target implements redirection of non-local TCP/UDP traffic to local
sockets. Additionally, it's possible to manipulate the packet mark if and only
if a socket has been found. (We need this because we cannot use multiple
targets in the same iptables rule.)

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/linux/netfilter_ipv4/ipt_TPROXY.h |   14 +++
 net/netfilter/Kconfig                     |   12 +++
 net/netfilter/Makefile                    |    1 
 net/netfilter/xt_TPROXY.c                 |  139 +++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_TPROXY.h b/include/linux/netfilter_ipv4/ipt_TPROXY.h
new file mode 100644
index 0000000..4a2dfa1
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_TPROXY.h
@@ -0,0 +1,14 @@
+#ifndef _IPT_TPROXY_H_target
+#define _IPT_TPROXY_H_target
+
+/* TPROXY target is capable of marking the packet to perform
+ * redirection. We can get rid of that whenever we get support for
+ * mutliple targets in the same rule. */
+struct ipt_tproxy_target_info {
+	__be32 laddr;
+	__be16 lport;
+	unsigned long mark_mask;
+	unsigned long mark_value;
+};
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 899fdde..21e39eb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -363,6 +363,18 @@ config NETFILTER_XT_TARGET_NOTRACK
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_TPROXY
+	tristate "TPROXY target support"
+	depends on NETFILTER_TPROXY
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `TPROXY' target, which is somewhat similar to
+	  REDIRECT.  It can only be used in the tproxy table and is useful
+	  to redirect traffic to a transparent proxy.  It does _not_ depend
+	  on Netfilter connection tracking.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7d7dbd6..0684e2b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
new file mode 100644
index 0000000..8603421
--- /dev/null
+++ b/net/netfilter/xt_TPROXY.c
@@ -0,0 +1,139 @@
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
+#include <linux/netfilter_ipv4/ipt_TPROXY.h>
+
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/nf_tproxy_core.h>
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo)
+{
+	const struct iphdr *iph = ip_hdr(*pskb);
+	const struct ipt_tproxy_target_info *tgi =
+		(const struct ipt_tproxy_target_info *) targinfo;
+	struct sk_buff *skb = *pskb;
+	struct udphdr _hdr, *hp;
+	struct sock *sk;
+
+	/* TCP/UDP only */
+	if ((iph->protocol != IPPROTO_TCP) &&
+	    (iph->protocol != IPPROTO_UDP))
+		return NF_ACCEPT;
+
+	hp = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return NF_DROP;
+
+	sk = nf_tproxy_get_sock_v4(iph->protocol,
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
+		pr_debug("redirecting: proto %d %08x:%d -> %08x:%d, mark: %x\n",
+			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
+			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
+		return NF_ACCEPT;
+	}
+	else {
+		pr_debug("no socket, dropping: proto %d %08x:%d -> %08x:%d, mark: %x\n",
+			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
+			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
+		return NF_DROP;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_ipt_tproxy_target_info {
+	__be32 laddr;
+	__be16 lport;
+	__be16 __pad1;
+	compat_ulong_t mark_mask;
+	compat_ulong_t mark_value;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	const struct compat_ipt_tproxy_target_info *c = src;
+	struct ipt_tproxy_target_info m = {
+		.laddr		= c->laddr,
+		.lport		= c->lport,
+		.mark_mask	= c->mark_mask,
+		.mark_value	= c->mark_value,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static void compat_to_user(void __user *dst, void *src)
+{
+	const struct ipt_tproxy_target_info *m = src;
+	struct compat_ipt_tproxy_target_info c = {
+		.laddr		= m->laddr,
+		.lport		= m->lport,
+		.mark_mask	= m->mark_mask,
+		.mark_value	= m->mark_value,
+	};
+	return copy_to_user(dst, &c, sizeof(c)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
+static struct xt_target xt_tproxy_reg = {
+	.name		= "TPROXY",
+	.family		= AF_INET,
+	.target		= target,
+	.targetsize	= sizeof(struct ipt_tproxy_target_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ipt_tproxy_target_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
+	.table		= "mangle",
+	.hooks		= (1 << NF_IP_PRE_ROUTING),
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	nf_defrag_ipv4_enable();
+	return xt_register_target(&xt_tproxy_reg);
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_target(&xt_tproxy_reg);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Krisztian Kovacs");
+MODULE_DESCRIPTION("Netfilter transparent proxy (TPROXY) target module.");
+MODULE_ALIAS("ipt_TPROXY");

