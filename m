From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 46/79: iptables tproxy core
Date: Wed,  8 Oct 2008 12:47:23 +0200 (MEST)
Message-ID: <20081008104723.10423.3499.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46006 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYJHKrY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:24 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9ad2d745a23853927a19789b034d9eb2e62d78ee
Author: KOVACS Krisztian <hidden@sch.bme.hu>
Date:   Wed Oct 8 11:35:12 2008 +0200

    netfilter: iptables tproxy core
    
    The iptables tproxy core is a module that contains the common routines used by
    various tproxy related modules (TPROXY target and socket match)
    
    Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_tproxy_core.h b/include/net/netfilter/nf_tproxy_core.h
new file mode 100644
index 0000000..208b46f
--- /dev/null
+++ b/include/net/netfilter/nf_tproxy_core.h
@@ -0,0 +1,32 @@
+#ifndef _NF_TPROXY_CORE_H
+#define _NF_TPROXY_CORE_H
+
+#include <linux/types.h>
+#include <linux/in.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+#include <net/inet_sock.h>
+#include <net/tcp.h>
+
+/* look up and get a reference to a matching socket */
+extern struct sock *
+nf_tproxy_get_sock_v4(struct net *net, const u8 protocol,
+		      const __be32 saddr, const __be32 daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in, bool listening);
+
+static inline void
+nf_tproxy_put_sock(struct sock *sk)
+{
+	/* TIME_WAIT inet sockets have to be handled differently */
+	if ((sk->sk_protocol == IPPROTO_TCP) && (sk->sk_state == TCP_TIME_WAIT))
+		inet_twsk_put(inet_twsk(sk));
+	else
+		sock_put(sk);
+}
+
+/* assign a socket to the skb -- consumes sk */
+int
+nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk);
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4a46485..ed1dcfb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -287,6 +287,21 @@ config NF_CT_NETLINK
 	help
 	  This option enables support for a netlink-based userspace interface
 
+# transparent proxy support
+config NETFILTER_TPROXY
+	tristate "Transparent proxying support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on IP_NF_MANGLE
+	depends on NETFILTER_ADVANCED
+	help
+	  This option enables transparent proxying support, that is,
+	  support for handling non-locally bound IPv4 TCP and UDP sockets.
+	  For it to work you will have to configure certain iptables rules
+	  and use policy routing. For more information on how to set it up
+	  see Documentation/networking/tproxy.txt.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f101cf6..fc8bbb4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -34,6 +34,9 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
+# transparent proxy support
+obj-$(CONFIG_NETFILTER_TPROXY) += nf_tproxy_core.o
+
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
diff --git a/net/netfilter/nf_tproxy_core.c b/net/netfilter/nf_tproxy_core.c
new file mode 100644
index 0000000..fe34f4b
--- /dev/null
+++ b/net/netfilter/nf_tproxy_core.c
@@ -0,0 +1,96 @@
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
+#include <linux/version.h>
+#include <linux/module.h>
+
+#include <linux/net.h>
+#include <linux/if.h>
+#include <linux/netdevice.h>
+#include <net/udp.h>
+#include <net/netfilter/nf_tproxy_core.h>
+
+struct sock *
+nf_tproxy_get_sock_v4(struct net *net, const u8 protocol,
+		      const __be32 saddr, const __be32 daddr,
+		      const __be16 sport, const __be16 dport,
+		      const struct net_device *in, bool listening_only)
+{
+	struct sock *sk;
+
+	/* look up socket */
+	switch (protocol) {
+	case IPPROTO_TCP:
+		if (listening_only)
+			sk = __inet_lookup_listener(net, &tcp_hashinfo,
+						    daddr, ntohs(dport),
+						    in->ifindex);
+		else
+			sk = __inet_lookup(net, &tcp_hashinfo,
+					   saddr, sport, daddr, dport,
+					   in->ifindex);
+		break;
+	case IPPROTO_UDP:
+		sk = udp4_lib_lookup(net, saddr, sport, daddr, dport,
+				     in->ifindex);
+		break;
+	default:
+		WARN_ON(1);
+		sk = NULL;
+	}
+
+	pr_debug("tproxy socket lookup: proto %u %08x:%u -> %08x:%u, listener only: %d, sock %p\n",
+		 protocol, ntohl(saddr), ntohs(sport), ntohl(daddr), ntohs(dport), listening_only, sk);
+
+	return sk;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_get_sock_v4);
+
+static void
+nf_tproxy_destructor(struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	skb->sk = NULL;
+	skb->destructor = NULL;
+
+	if (sk)
+		nf_tproxy_put_sock(sk);
+}
+
+/* consumes sk */
+int
+nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
+{
+	if (inet_sk(sk)->transparent) {
+		skb->sk = sk;
+		skb->destructor = nf_tproxy_destructor;
+		return 1;
+	} else
+		nf_tproxy_put_sock(sk);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_tproxy_assign_sock);
+
+static int __init nf_tproxy_init(void)
+{
+	pr_info("NF_TPROXY: Transparent proxy support initialized, version 4.1.0\n");
+	pr_info("NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.\n");
+	return 0;
+}
+
+module_init(nf_tproxy_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Krisztian Kovacs");
+MODULE_DESCRIPTION("Transparent proxy support core routines");
