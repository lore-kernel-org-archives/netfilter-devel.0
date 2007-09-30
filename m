From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 10/13] iptables socket match
Date: Sun, 30 Sep 2007 23:43:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709302342220.7130@fbirervta.pbzchgretzou.qr>
References: <20070930205141.10969.27205.stgit@nessa.odu>
 <20070930205325.10969.26708.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46563 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXI3Vna (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:43:30 -0400
In-Reply-To: <20070930205325.10969.26708.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 22:53, KOVACS Krisztian wrote:
>
>Add iptables 'socket' match, which matches packets for which a TCP/UDP
>socket lookup succeeds.
>
>---

And here is the xt_socket that I had..

===
iptables socket match

From: KOVACS Krisztian <hidden@balabit.hu>

Add iptables 'socket' match, which matches packets for which a TCP/UDP
socket lookup succeeds.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---

 net/ipv4/netfilter/Kconfig |   10 +++++
 net/netfilter/Makefile     |    1 
 net/netfilter/xt_socket.c  |   80 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

Index: linux-2.6.22.1/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.22.1.orig/net/ipv4/netfilter/Kconfig
+++ linux-2.6.22.1/net/ipv4/netfilter/Kconfig
@@ -414,6 +414,16 @@ config NETFILTER_XT_TARGET_TPROXY
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_SOCKET
+	tristate "socket match support"
+	depends on IP_NF_TPROXY_TABLE
+	help
+	  This option adds a `socket' match, which can be used to match
+	  packets for which a TCP or UDP socket lookup finds a valid socket.
+	  It can only be used in the tproxy table.
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
@@ -76,6 +76,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE)
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
Index: linux-2.6.22.1/net/netfilter/xt_socket.c
===================================================================
--- /dev/null
+++ linux-2.6.22.1/net/netfilter/xt_socket.c
@@ -0,0 +1,80 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tproxy.h>
+#include <net/inet_sock.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+static int
+socket_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             int *hotdrop)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct udphdr _hdr, *hp;
+	struct sock *sk;
+
+	/* TCP/UDP only */
+	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
+		return false;
+
+	hp = skb_header_pointer(skb, iph->ihl * 4, sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return false;
+
+	sk = ip_tproxy_get_sock(iph->protocol, iph->saddr, iph->daddr,
+ 	                        hp->source, hp->dest, in);
+	if (sk != NULL) {
+		if (iph->protocol == IPPROTO_TCP &&
+		    sk->sk_state == TCP_TIME_WAIT)
+			inet_twsk_put(inet_twsk(sk));
+		else
+			sock_put(sk);
+	}
+
+	pr_debug(KERN_DEBUG "socket match: proto %d %08x:%d -> %08x:%d sock %p\n",
+	         iph->protocol, ntohl(iph->saddr), ntohs(hp->source),
+	         ntohl(iph->daddr), ntohs(hp->dest), sk);
+
+	return sk != NULL;
+}
+
+static struct xt_match socket_reg __read_mostly = {
+	.name      = "socket",
+	.family    = AF_INET,
+	.table     = "tproxy",
+	.match     = socket_match,
+	.me        = THIS_MODULE,
+};
+
+static int __init xt_socket_init(void)
+{
+	return xt_register_match(&socket_reg);
+}
+
+static void __exit xt_socket_fini(void)
+{
+	xt_unregister_match(&socket_reg);
+}
+
+module_init(xt_socket_init);
+module_exit(xt_socket_fini);
+MODULE_AUTHOR("Krisztian Kovacs <hidden@balabit.hu>");
+MODULE_DESCRIPTION("netfilter socket match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_socket");
