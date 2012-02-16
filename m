From: Darren Willis <djw@google.com>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Thu, 16 Feb 2012 13:56:01 +0900
Message-ID: <CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
	<alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
	<CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
	<alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34126 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab2BPE4D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:56:03 -0500
Received: by vbjk17 with SMTP id k17so1240320vbj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2012 20:56:01 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 16, 2012 at 02:13, Jan Engelhardt <jengelh@medozas.de> wrote:
>>It would be possible to capture outgoing messages' transaction IDs and
>>require that incoming advertise/reply responses match it, but I'm not
>>sure that's really going to be a big help (the clients are surely
>>doing this already).
>
> Certainly would be on my wishlist if such an extension does not look
> too ugly.

Probably not too ugly. Transaction IDs are effectively one-shot,
except for solicit/advertise, so just keeping a couple of arrays of
sent transaction IDs and checking incoming messages for a match could
work (one array for solicit transaction IDs, which can get multiple
replies, and one array for 'normal' transaction IDs, which can't).
Array size could reasonably be expected to be 1 entry per DHCPv6
server, I think. There'd need to be a scheme for evicting old IDs as
well. I'm considering this a bit of a to-do-later though.

Oh, right now this module has an expect_policy with max expected of 1,
which I'm assuming is a hard limit of 1 expectation. Not sure what the
usual decision is on this - typical case is going to be 1 DHCPv6
server, but more are allowed.

> Irk. I would suggest doing like the ICMPv6 tracker does,
> marking it unconditionally as INVALID to indicate that the
> implementation chose to not track RECONFIGURE on purpose.

The thing with reconfigure is I've got nowhere to track it (sensibly).
RECONFIGURE just appears out of the blue from a DHCPv6 server. Right
now this module's only deals with messages from the client, I don't
examine incoming DHCPv6 packets at all, I just set up expectations for
them.

Another revision with your changes and a bugfix (I was dereferencing
udph before checking it was NULL in the last one...)
----
diff -ruN linux-orig/net/ipv6/netfilter/Kconfig
linux-dhcpv6/net/ipv6/netfilter/Kconfig
--- linux-orig/net/ipv6/netfilter/Kconfig	2011-10-24 07:10:05.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/Kconfig	2012-02-10 02:05:54.000000000 +0000
@@ -25,6 +25,22 @@

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
diff -ruN linux-orig/net/ipv6/netfilter/Makefile
linux-dhcpv6/net/ipv6/netfilter/Makefile
--- linux-orig/net/ipv6/netfilter/Makefile	2011-10-24 07:10:05.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/Makefile	2012-02-09 07:54:18.000000000 +0000
@@ -16,6 +16,9 @@
 # l3 independent conntrack
 obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o nf_defrag_ipv6.o

+# IPv6-only connection tracker protocol.
+obj-$(CONFIG_NF_CONNTRACK_DHCPV6) += nf_conntrack_dhcpv6.o
+
 # defrag
 nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
diff -ruN linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
--- linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	1970-01-01
00:00:00.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	2012-02-12
04:47:32.000000000 +0000
@@ -0,0 +1,122 @@
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
+MODULE_ALIAS_NFCT_HELPER("dhcpv6");
+
+/* Timeouts for DHCPv6 replies, in seconds, indexed by message type. */
+const static int dhcpv6_timeouts[] = {
+  0,    /* No message has type 0. */
+  120,  /* Solicit. */
+  0,    /* Advertise. */
+  30,   /* Request. */
+  4,    /* Confirm. */
+  600,  /* Renew. */
+  600,  /* Rebind. */
+  0,    /* Reply. */
+  1,    /* Release. */
+  1,    /* Decline. */
+  0,    /* Reconfigure. */
+  120,  /* Information Request. */
+  0,    /* Relay-forward. */
+  0     /* Relay-reply. */
+};
+
+static int dhcpv6_help(struct sk_buff *skb,
+		       unsigned int protoff,
+		       struct nf_conn *ct,
+		       enum ip_conntrack_info ctinfo)
+{
+	struct nf_conntrack_expect *exp;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	const struct udphdr *udph;
+	struct udphdr _udph;
+	int typeint = 0;
+	int timeout = 0;
+	char typebuf = 0;
+	unsigned char *type = NULL;
+
+	if (iph->version != 6 || skb->sk == NULL  ||
+	    !ipv6_addr_is_multicast(&iph->daddr))
+	  return NF_ACCEPT;
+
+	udph = skb_header_pointer(skb, protoff, sizeof(_udph), &_udph);
+	/* DHCPv6 messages are at least 4 bytes long. */
+	if (udph == NULL || ntohs(udph->len) < 12 ||
+	    ntohs(udph->len) != skb->len - protoff) {
+	  return NF_ACCEPT;
+	}
+
+	type = skb_header_pointer(skb, protoff + sizeof(_udph),
sizeof(typebuf), &typebuf);
+	if (type == NULL || *type >= ARRAY_SIZE(dhcpv6_timeouts) ||
+	    dhcpv6_timeouts[*type] == 0) {
+	  return NF_ACCEPT;
+	}
+	timeout = dhcpv6_timeouts[*type];
+	exp = nf_ct_expect_alloc(ct);
+	if (exp == NULL)
+	  return NF_DROP;
+	exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	exp->tuple.src.u.udp.port = htons(DHCPV6_SERVER_PORT);
+	exp->mask.src.u.udp.port = htons(0xFFFF);
+	exp->mask.src.u.all = 0x0;
+	
+	exp->expectfn = NULL;
+	exp->flags = NF_CT_EXPECT_PERMANENT;
+	exp->class = NF_CT_EXPECT_CLASS_DEFAULT;
+	exp->helper = NULL;
+
+	nf_ct_expect_related(exp);
+	nf_ct_expect_put(exp);
+
+	nf_ct_refresh(ct, skb, timeout * HZ);
+	return NF_ACCEPT;
+}
+
+static struct nf_conntrack_expect_policy exp_policy = {
+	.max_expected   = 1,
+};
+
+static struct nf_conntrack_helper helper __read_mostly = {
+	.name                   = "dhcpv6",
+	.tuple.src.l3num        = NFPROTO_IPV6,
+	.tuple.src.u.udp.port   = htons(DHCPV6_SERVER_PORT),
+	.tuple.dst.protonum     = IPPROTO_UDP,
+	.me                     = THIS_MODULE,
+	.help                   = dhcpv6_help,
+	.expect_policy          = &exp_policy,
+};
+
+static int __init nf_conntrack_dhcpv6_init(void)
+{
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
