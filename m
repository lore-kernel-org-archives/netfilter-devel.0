From: Darren Willis <djw@google.com>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Wed, 15 Feb 2012 18:00:13 +0900
Message-ID: <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
	<alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47899 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab2BOJAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:00:14 -0500
Received: by vcge1 with SMTP id e1so610073vcg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2012 01:00:13 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the feedback! See below for a revised version.

On Mon, Feb 13, 2012 at 18:55, Jan Engelhardt <jengelh@medozas.de> wrote:
> You probably want to add a test for the skb actually being a
> DHCP message type that desires a reply (DHCPOFFER, etc.)
> before creating the exp.

I think every (or almost every) message a client sends in DHCPv6 can
expect a REPLY message. The code is now checking the message type
though, just in case a client is doing something silly like sending
out advertises to ff02::1:2 (in which case it won't get an
expectation).

> In all cases, NF_ACCEPT is returned - makes some eyebrows raise.
> Upon looking for it, nf_conntrack_ftp.c returns NF_DROP on exp==NULL, so
> should you.

OK, doing that.

> It is probably a sane thing to also check that the DHCP packet is
> looking valid (packet size, flag combinations, etc.)
> ....
> The timeout value for the exp could depend on the message type; RFC
> 3315 defines different timeouts for different message types, up to 600
> seconds for RENEW/REBOUND. (Is 600 seconds a wise thing?)

I was trying to avoid digging around in the packet too much, but this
is necessary (I had thought server_unicast was more widespread than it
is).
I've set it up to check the output message type and set the timeout
appropriately. Since there's now 8 different timeouts I've dropped the
parameter configuration. Client software doesn't seem too interested
in letting people set these anyway.

For checking the validity of a DHCP packet, there's not really very
much that can be done without parsing the DHCPv6 options. I've added a
length check to make sure the outgoing message has at least a message
type and transaction ID, and the timeout setting-code implicitly
checks that the message has a known DHCPv6 message type.

It would be possible to capture outgoing messages' transaction IDs and
require that incoming advertise/reply responses match it, but I'm not
sure that's really going to be a big help (the clients are surely
doing this already).

> Thirdly, your module does not seem to make any attempt (yet) to handle
> the DHCP v6 RECONFIGURE message.

Right. I'm not sure of a good way to handle this; I suppose I could
check initial ADVERTISE messages for the 'accept reconfigure' option,
and allow the source of that advertise to have access to port 546.
There's no time limit on reconfigure messages, though, so it'd
basically be "throw open this port to this IP for <very long time
period>." (possibly the timeout for accepting reconfiguration requests
could be a parameter). Reconfigure messages require authentication,
though, so this might not be so bad.

> Would you know whether somebody is using UDPLITE for DHCP?

I wouldn't expect it, and the DHCPv6 rfc specifically states that it uses UDP.

Revised module source:
------
diff -ruN linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c
--- linux-orig/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	1970-01-01
00:00:00.000000000 +0000
+++ linux-dhcpv6/net/ipv6/netfilter/nf_conntrack_dhcpv6.c	2012-02-11
08:13:49.000000000 +0000
@@ -0,0 +1,123 @@
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
+	int timeout = 0;
+	short udp_len = 0;
+	char typebuf = 0;
+	unsigned char *type = 0;
+
+	if (iph->version != 6 || skb->sk == NULL  ||
+	    !ipv6_addr_is_multicast(&iph->daddr))
+	  return NF_ACCEPT;
+
+	udph = skb_header_pointer(skb, protoff, sizeof(_udph), &_udph);
+	udp_len = ntohs(udph->len);
+	/* DHCPv6 messages are at least 4 bytes long. */
+	if (udph == NULL || udp_len < 12) {
+	  return NF_ACCEPT;
+	}
+
+	type = skb_header_pointer(skb, protoff + sizeof(_udph),
+				  sizeof(typebuf), &typebuf);
+	if (type == NULL || *type >= ARRAY_SIZE(dhcpv6_timeouts) ||
+            dhcpv6_timeouts[*type] == 0)
+	  return NF_ACCEPT;
+	timeout = dhcpv6_timeouts[*type];
+
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
