From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/13] xt_socket
Date: Mon, 1 Oct 2007 00:15:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710010007290.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205325.10969.26708.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXI3WQB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:16:01 -0400
In-Reply-To: <20070930205325.10969.26708.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 22:53, KOVACS Krisztian wrote:
>+
>+	hp = skb_header_pointer(skb, iph->ihl * 4, sizeof(_hdr), &_hdr);
>+	if (hp == NULL)
>+		return false;

ip_hdrlen(skb) for 2nd arg.

>+	pr_debug("socket match: proto %d %08x:%d -> %08x:%d sock %p\n",
>+		 iph->protocol, ntohl(iph->saddr), ntohs(hp->source),
>+		 ntohl(iph->daddr), ntohs(hp->dest), sk);

Should be %u.

>+static struct xt_match socket_matches[] = {

A single struct suffices.

>+		.name		= "socket",
>+		.family		= AF_INET,
>+		.match		= match,

This goes against debugging. If everyone names their match function 
"match" (and it's done too often in netfilter and iptables-userspace 
already), it is hard to find out which is meant (e.g. in an oops). It 
also makes debugging quite impossible because setting a breakpoint will 
be ambiguous.

Find below a patch that makes me happy, and compiles. :)

===

Add the xt_socket match, which matches packets for which a TCP/UDP
socket lookup succeeds.

(originally from: KOVACS Krisztian <hidden@sch.bme.hu>)

A few cleanups.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---

 net/netfilter/Kconfig     |   12 +++++++
 net/netfilter/Makefile    |    1 
 net/netfilter/xt_socket.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

Index: linux-2.6.23/net/netfilter/Kconfig
===================================================================
--- linux-2.6.23.orig/net/netfilter/Kconfig
+++ linux-2.6.23/net/netfilter/Kconfig
@@ -632,6 +632,18 @@ config NETFILTER_XT_MATCH_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_SOCKET
+	tristate '"socket" match support'
+	depends on NETFILTER_TPROXY
+	depends on NETFILTER_XTABLES
+	select NF_DEFRAG_IPV4
+	help
+	  This option adds a "socket" match, which can be used to match
+	  packets for which a TCP or UDP socket lookup finds a valid socket.
+	  It can only be used in the tproxy table.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.23/net/netfilter/Makefile
===================================================================
--- linux-2.6.23.orig/net/netfilter/Makefile
+++ linux-2.6.23/net/netfilter/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE)
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
Index: linux-2.6.23/net/netfilter/xt_socket.c
===================================================================
--- /dev/null
+++ linux-2.6.23/net/netfilter/xt_socket.c
@@ -0,0 +1,76 @@
+/*
+ * Transparent proxy support for Linux/iptables
+ *
+ * Copyright (c) 2007 BalaBit IT Ltd.
+ * Author: Krisztian Kovacs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/inet_sock.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+#include <net/netfilter/nf_tproxy_core.h>
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+
+static bool
+socket_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct udphdr _hdr, *hp;
+	struct sock *sk;
+
+	/* TCP/UDP only */
+	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
+		return false;
+
+	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return false;
+
+	sk = nf_tproxy_get_sock_v4(iph->protocol, iph->saddr, iph->daddr,
+	                           hp->source, hp->dest, in, false);
+	if (sk != NULL)
+		nf_tproxy_put_sock(sk);
+
+	pr_debug("socket match: proto %u %08x:%u -> %08x:%u sock %p\n",
+	         iph->protocol, ntohl(iph->saddr), ntohs(hp->source),
+	         ntohl(iph->daddr), ntohs(hp->dest), sk);
+	return sk != NULL;
+}
+
+static struct xt_match socket_reg __read_mostly = {
+	.name   = "socket",
+	.family = AF_INET,
+	.hooks  = 1 << NF_IP_PRE_ROUTING,
+	.match  = socket_match,
+	.me     = THIS_MODULE,
+};
+
+static int __init xt_socket_init(void)
+{
+	nf_defrag_ipv4_enable();
+	return xt_register_match(&socket_reg);
+}
+
+static void __exit xt_socket_exit(void)
+{
+	xt_unregister_match(&socket_reg);
+}
+
+module_init(xt_socket_init);
+module_exit(xt_socket_exit);
+MODULE_AUTHOR("Krisztian Kovacs");
+MODULE_DESCRIPTION("netfilter socket match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_socket");
