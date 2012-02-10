From: Darren Willis <djw@google.com>
Subject: [PATCH] DHCPv6 connection tracker helper
Date: Fri, 10 Feb 2012 11:30:33 +0900
Message-ID: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48952 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2BJCae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:30:34 -0500
Received: by vcge1 with SMTP id e1so1539760vcg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2012 18:30:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds a connection tracker helper for DHCPv6, which relies on UDP
multicast solicitations to discover DHCPv6 servers.

This allows DHCPv6 to work through ip6tables rulesets where
non-related traffic is dropped (e.g., default fedora iptables).
https://bugzilla.redhat.com/show_bug.cgi?id=656334

Signed-off-by: Darren Willis <djw@google.com>

diff -rupN linux-orig/net/ipv6/netfilter/Kconfig
linux-dhcpv6/net/ipv6/netfilter/Kconfig
--- linux-orig/net/ipv6/netfilter/Kconfig	2011-10-24 07:10:05.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/Kconfig	2012-02-10 02:05:54.000000000 +0000
@@ -25,6 +25,22 @@ config NF_CONNTRACK_IPV6

 	  To compile it as a module, choose M here.  If unsure, say N.

+if NF_CONNTRACK_IPV6
+
+config NF_CONNTRACK_DHCPV6
+       tristate "DHCPv6 connection tracking support"
+       depends on NF_CONNTRACK_IPV6
+       default m
+       help
+         DHCPv6 is an autoconfiguration protocol for IPv6 that makes use of
+	 IPv6's mulitcast addresses to solicit configuration providers. This
+	 module makes it possible for connection tracker to track replies to
+	 these multicast solicitations, allowing DHCPv6 to function correctly.
+
+	 To compile it as a module, choose M here. If unsure, say N.
+
+endif # NF_CONNTRACK_IPV6
+
 config IP6_NF_QUEUE
 	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
 	depends on INET && IPV6 && NETFILTER
diff -rupN linux-orig/net/ipv6/netfilter/Makefile
linux-dhcpv6/net/ipv6/netfilter/Makefile
--- linux-orig/net/ipv6/netfilter/Makefile	2011-10-24 07:10:05.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/Makefile	2012-02-09 07:54:18.000000000 +0000
@@ -16,6 +16,9 @@ nf_conntrack_ipv6-y  :=  nf_conntrack_l3
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o nf_defrag_ipv6.o

+# IPv6-only connection tracker protocol.
+obj-$(CONFIG_NF_CONNTRACK_DHCPV6) += nf_conntrack_dhcpv6.o
+
 # defrag
 nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
diff -rupN linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
--- linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	1970-01-01
00:00:00.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	2012-02-09
07:54:32.000000000 +0000
@@ -0,0 +1,94 @@
+/*
+ *      DHCPv6 multicast connection tracking helper.
+ *
+ *      (c) 2012 Google Inc.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/ip.h>
+#include <net/addrconf.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+
+#define DHCPV6_SERVER_PORT 547
+
+MODULE_AUTHOR("Darren Willis <djw@google.com>");
+MODULE_DESCRIPTION("DHCPv6 multicast connection tracking helper");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipv6_conntrack_dhcpv6");
+MODULE_ALIAS_NFCT_HELPER("dhcpv6");
+
+static unsigned int timeout __read_mostly = 120;
+module_param(timeout, uint, S_IRUSR);
+MODULE_PARM_DESC(timeout, "timeout for DHCPv6 replies in seconds");
+
+static int dhcpv6_help(struct sk_buff *skb,
+		       unsigned int protoff,
+		       struct nf_conn *ct,
+		       enum ip_conntrack_info ctinfo)
+{
+	struct nf_conntrack_expect *exp;
+	struct iphdr *iph = ip_hdr(skb);
+	if (iph->version == 6) {
+		struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		if (skb->sk == NULL)
+			goto out;
+		if (ipv6_addr_is_multicast(&ip6h->daddr)) {
+			exp = nf_ct_expect_alloc(ct);
+			if (exp == NULL)
+				goto out;
+			exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+			exp->tuple.src.u.udp.port = htons(DHCPV6_SERVER_PORT);
+			exp->mask.src.u.udp.port = htons(0xFFFF);
+			exp->mask.src.u.all = 0x0;
+
+			exp->expectfn = NULL;
+			exp->flags = NF_CT_EXPECT_PERMANENT;
+			exp->class = NF_CT_EXPECT_CLASS_DEFAULT;
+			exp->helper = NULL;
+
+			nf_ct_expect_related(exp);
+			nf_ct_expect_put(exp);
+
+			nf_ct_refresh(ct, skb, timeout * HZ);
+		}
+	}
+	out:
+		return NF_ACCEPT;
+}
+
+static struct nf_conntrack_expect_policy exp_policy = {
+	.max_expected   = 1,
+};
+
+static struct nf_conntrack_helper helper __read_mostly = {
+	.name                   = "dhcpv6",
+	.tuple.src.l3num        = AF_INET6,
+	.tuple.src.u.udp.port   = htons(DHCPV6_SERVER_PORT),
+	.tuple.dst.protonum     = IPPROTO_UDP,
+	.me                     = THIS_MODULE,
+	.help                   = dhcpv6_help,
+	.expect_policy          = &exp_policy,
+};
+
+static int __init nf_conntrack_dhcpv6_init(void)
+{
+	exp_policy.timeout = timeout;
+	return nf_conntrack_helper_register(&helper);
+}
+
+static void __exit nf_conntrack_dhcpv6_fini(void)
+{
+	nf_conntrack_helper_unregister(&helper);
+}
+
+module_init(nf_conntrack_dhcpv6_init);
+module_exit(nf_conntrack_dhcpv6_fini);
