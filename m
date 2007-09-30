From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 10/13] iptables socket match
Date: Sun, 30 Sep 2007 22:53:25 +0200
Message-ID: <20070930205325.10969.26708.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40441 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXI3VL5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:57 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add iptables 'socket' match, which matches packets for which a TCP/UDP
socket lookup succeeds.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 net/netfilter/Kconfig     |   12 ++++++
 net/netfilter/Makefile    |    1 +
 net/netfilter/xt_socket.c |   87 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2187cca..899fdde 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -632,6 +632,18 @@ config NETFILTER_XT_MATCH_SCTP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_SOCKET
+	tristate '"socket" match support'
+	depends on NETFILTER_TPROXY
+	depends on NETFILTER_XTABLES
+	select NF_DEFRAG_IPV4
+	help
+	  This option adds a `socket' match, which can be used to match
+	  packets for which a TCP or UDP socket lookup finds a valid socket.
+	  It can only be used in the tproxy table.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 76e16ea..7d7dbd6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
new file mode 100644
index 0000000..b1b0103
--- /dev/null
+++ b/net/netfilter/xt_socket.c
@@ -0,0 +1,87 @@
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
+#include <net/netfilter/nf_tproxy_core.h>
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+#include <net/sock.h>
+#include <net/inet_sock.h>
+
+static bool
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      bool *hotdrop)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct udphdr _hdr, *hp;
+	struct sock *sk;
+
+	/* TCP/UDP only */
+	if ((iph->protocol != IPPROTO_TCP) &&
+	    (iph->protocol != IPPROTO_UDP))
+		return false;
+
+	hp = skb_header_pointer(skb, iph->ihl * 4, sizeof(_hdr), &_hdr);
+	if (hp == NULL)
+		return false;
+
+	sk = nf_tproxy_get_sock_v4(iph->protocol,
+				   iph->saddr, iph->daddr,
+				   hp->source, hp->dest, in, false);
+	if (sk != NULL)
+		nf_tproxy_put_sock(sk);
+
+	pr_debug("socket match: proto %d %08x:%d -> %08x:%d sock %p\n",
+		 iph->protocol, ntohl(iph->saddr), ntohs(hp->source),
+		 ntohl(iph->daddr), ntohs(hp->dest), sk);
+
+	return (sk != NULL);
+}
+
+static struct xt_match socket_matches[] = {
+	{
+		.name		= "socket",
+		.family		= AF_INET,
+		.match		= match,
+		.matchsize	= 0,
+		.hooks		= (1 << NF_IP_PRE_ROUTING),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init ipt_socket_init(void)
+{
+	nf_defrag_ipv4_enable();
+	return xt_register_matches(socket_matches, ARRAY_SIZE(socket_matches));
+}
+
+static void __exit ipt_socket_fini(void)
+{
+	xt_unregister_matches(socket_matches, ARRAY_SIZE(socket_matches));
+}
+
+module_init(ipt_socket_init);
+module_exit(ipt_socket_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Krisztian Kovacs");
+MODULE_DESCRIPTION("x_tables socket match module");
+MODULE_ALIAS("ipt_socket");

