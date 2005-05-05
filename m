From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Open Port match
Date: Thu, 05 May 2005 13:48:44 +1000
Message-ID: <1115264925.2118.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xo39zROVHUpXqg8lGPZP"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: works_five_times545.epsilon.ssokolow@spamgourmet.com
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-xo39zROVHUpXqg8lGPZP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ssokolow asked for this.  Someone can enhance to cover UDP and put in
patch-o-matic if they're enthusiastic about it.

Works for me!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman

--=-xo39zROVHUpXqg8lGPZP
Content-Disposition: attachment; filename=open_port-iptables.diff
Content-Type: text/x-patch; name=open_port-iptables.diff; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Index: extensions/.open_port-test
===================================================================
--- extensions/.open_port-test	(revision 0)
+++ extensions/.open_port-test	(revision 0)
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_open_port.h ] && echo open_port

Property changes on: extensions/.open_port-test
___________________________________________________________________
Name: svn:executable
   + *

Index: extensions/libipt_open_port.man
===================================================================
--- extensions/libipt_open_port.man	(revision 0)
+++ extensions/libipt_open_port.man	(revision 0)
@@ -0,0 +1,4 @@
+This allows you to match whether a TCP port is open to receive a
+packet.  You must specify "-p tcp" in your rule.  This mathc takes no
+options, can be inverted, and can currently only be used from the INPUT
+chain.
Index: extensions/libipt_open_port.c
===================================================================
--- extensions/libipt_open_port.c	(revision 0)
+++ extensions/libipt_open_port.c	(revision 0)
@@ -0,0 +1,67 @@
+/* Shared library add-on to iptables for open_port matching
+ *
+ * Copyright (C) 2005 Rusty Russell <rusty@rustcorp.com.au>
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_open_port.h>
+
+static void help(void) 
+{
+	printf("open_port match v%s takes no options\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ .name = 0 }
+};
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	return 0;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+}
+
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+}
+
+static
+struct iptables_match open_port
+= { .name          = "open_port",
+    .version       = IPTABLES_VERSION,
+    .size          = IPT_ALIGN(0),
+    .userspacesize = IPT_ALIGN(0),
+    .help          = &help,
+    .parse         = &parse,
+    .final_check   = &final_check,
+    .print         = &print,
+    .save          = &save,
+    .extra_opts    = opts
+};
+
+void _init(void)
+{
+	register_match(&open_port);
+}

--=-xo39zROVHUpXqg8lGPZP
Content-Disposition: attachment; filename=open_port-kernel.diff
Content-Type: text/x-patch; name=open_port-kernel.diff; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Index: linux-2.6.12-rc3-Netfilter/include/linux/netfilter_ipv4/ipt_open_port.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.12-rc3-Netfilter/include/linux/netfilter_ipv4/ipt_open_port.h	2005-05-05 13:39:38.881764336 +1000
@@ -0,0 +1,5 @@
+#ifndef _IPT_OPEN_PORT_H
+#define _IPT_OPEN_PORT_H
+
+/* For future expansion, and to indicate that this extension exists. */
+#endif /*_IPT_OPEN_PORT_H */
Index: linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/Kconfig
===================================================================
--- linux-2.6.12-rc3-Netfilter.orig/net/ipv4/netfilter/Kconfig	2005-03-02 23:28:18.000000000 +1100
+++ linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/Kconfig	2005-05-05 12:12:02.000000000 +1000
@@ -375,6 +375,16 @@
 	  destination IP' or `500pps from any given source IP'  with a single
 	  IPtables rule.
 
+config IP_NF_MATCH_OPEN_PORT
+	tristate  'TCP open port match support'
+	depends on IP_NF_IPTABLES && EXPERIMENTAL
+	help
+	  This option adds a new iptables `open_port' match.  
+
+	  This matches TCP packets in the INPUT (LOCAL_IN) chain which
+	  are headed for an open TCP port.  Some users like to drop packets
+	  which would otherwise simply generate TCP RST responses.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
Index: linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.12-rc3-Netfilter.orig/net/ipv4/netfilter/Makefile	2005-03-02 23:28:18.000000000 +1100
+++ linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/Makefile	2005-05-05 12:35:46.000000000 +1000
@@ -59,6 +59,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) += ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_OPEN_PORT) += ipt_open_port.o
 
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
Index: linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/ipt_open_port.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.12-rc3-Netfilter/net/ipv4/netfilter/ipt_open_port.c	2005-05-05 13:44:41.515756976 +1000
@@ -0,0 +1,111 @@
+/* Kernel module to match open (TCP) ports. */
+
+/* Copyright (C) 2005 Rusty Russell, IBM Corporation.
+ * Part stolen from ipt_tcpmss.c Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/ipt_open_port.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("iptables open TCP port matching module.");
+
+/* From tcp_ipv4.c */
+struct sock *tcp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport,int dif);
+
+/* Stolen from tcp_ipv4.c */
+static __inline__ int tcp_v4_iif(const struct sk_buff *skb)
+{
+	return ((struct rtable *)skb->dst)->rt_iif;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	struct tcphdr _tcph, *th;
+	struct sock *sk;
+
+	/* If we don't have the whole header, drop packet. */
+	th = skb_header_pointer(skb, skb->nh.iph->ihl * 4,
+				sizeof(_tcph), &_tcph);
+	if (th == NULL)
+		goto dropit;
+
+	/* Malformed. */
+	if (th->doff*4 < sizeof(*th))
+		goto dropit;
+
+	sk = tcp_v4_lookup(skb->nh.iph->saddr, th->source,
+			   skb->nh.iph->daddr, th->dest, tcp_v4_iif(skb));
+	if (sk) {
+		if (sk->sk_state == TCP_TIME_WAIT) {
+			tcp_tw_put((struct tcp_tw_bucket *)sk);
+			return 0;
+		}
+		sock_put(sk);
+		return 1;
+	}
+	return 0;
+
+dropit:
+	*hotdrop = 1;
+	return 0;
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	if (matchsize != IPT_ALIGN(0))
+		return 0;
+
+        if (hook_mask & ~((1 << NF_IP_LOCAL_IN))) {
+                printk("ipt_open_port: only valid for LOCAL_IN.\n");
+                return 0;
+        }
+
+	/* Must specify -p tcp */
+	if (ip->proto != IPPROTO_TCP || (ip->invflags & IPT_INV_PROTO)) {
+		printk("open_port: Only works on TCP packets\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_match open_port_match = {
+	.name		= "open_port",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&open_port_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&open_port_match);
+}
+
+module_init(init);
+module_exit(fini);

--=-xo39zROVHUpXqg8lGPZP--
