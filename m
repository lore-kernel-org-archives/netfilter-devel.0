From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/41]: nf_nat: add DCCP protocol support
Date: Mon, 14 Apr 2008 12:16:52 +0200 (MEST)
Message-ID: <20080414101649.32717.6222.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYDNKQx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:53 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: add DCCP protocol support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 657f0294023ce9bfb5e2cca56ccaa64197414665
tree f29f26e9bf57d872316b733bca61ec3472185318
parent c079ea10a3255bda269c0d1696805979b207318e
author Patrick McHardy <kaber@trash.net> Thu, 20 Mar 2008 15:15:57 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:52 +0200

 net/ipv4/netfilter/Kconfig             |    5 +
 net/ipv4/netfilter/Makefile            |    1 
 net/ipv4/netfilter/nf_nat_proto_dccp.c |  108 ++++++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_standalone.c |    6 +-
 4 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c5bd284..fde3eac 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -241,6 +241,11 @@ config NF_NAT_SNMP_BASIC
 #           <expr> '&&' <expr>                   (6)
 #
 # (6) Returns the result of min(/expr/, /expr/).
+config NF_NAT_PROTO_DCCP
+	tristate
+	depends on NF_NAT && NF_CT_PROTO_DCCP
+	default NF_NAT && NF_CT_PROTO_DCCP
+
 config NF_NAT_PROTO_GRE
 	tristate
 	depends on NF_NAT && NF_CT_PROTO_GRE
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 332f46f..74d8dbd 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 
 # NAT protocols (nf_nat)
+obj-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 obj-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_dccp.c b/net/ipv4/netfilter/nf_nat_proto_dccp.c
new file mode 100644
index 0000000..12b51b3
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_dccp.c
@@ -0,0 +1,108 @@
+/*
+ * DCCP NAT protocol helper
+ *
+ * Copyright (c) 2005, 2006. 2008 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/dccp.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+static u_int16_t dccp_port_rover;
+
+static int
+dccp_unique_tuple(struct nf_conntrack_tuple *tuple,
+		  const struct nf_nat_range *range,
+		  enum nf_nat_manip_type maniptype,
+		  const struct nf_conn *ct)
+{
+	return nf_nat_proto_unique_tuple(tuple, range, maniptype, ct,
+					 &dccp_port_rover);
+}
+
+static int
+dccp_manip_pkt(struct sk_buff *skb,
+	       unsigned int iphdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	struct dccp_hdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl * 4;
+	__be32 oldip, newip;
+	__be16 *portptr, oldport, newport;
+	int hdrsize = 8; /* DCCP connection tracking guarantees this much */
+
+	if (skb->len >= hdroff + sizeof(struct dccp_hdr))
+		hdrsize = sizeof(struct dccp_hdr);
+
+	if (!skb_make_writable(skb, hdroff + hdrsize))
+		return 0;
+
+	iph = (struct iphdr *)(skb->data + iphdroff);
+	hdr = (struct dccp_hdr *)(skb->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		oldip = iph->saddr;
+		newip = tuple->src.u3.ip;
+		newport = tuple->src.u.dccp.port;
+		portptr = &hdr->dccph_sport;
+	} else {
+		oldip = iph->daddr;
+		newip = tuple->dst.u3.ip;
+		newport = tuple->dst.u.dccp.port;
+		portptr = &hdr->dccph_dport;
+	}
+
+	oldport = *portptr;
+	*portptr = newport;
+
+	if (hdrsize < sizeof(*hdr))
+		return 1;
+
+	inet_proto_csum_replace4(&hdr->dccph_checksum, skb, oldip, newip, 1);
+	inet_proto_csum_replace2(&hdr->dccph_checksum, skb, oldport, newport,
+				 0);
+	return 1;
+}
+
+static const struct nf_nat_protocol nf_nat_protocol_dccp = {
+	.protonum		= IPPROTO_DCCP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= dccp_manip_pkt,
+	.in_range		= nf_nat_proto_in_range,
+	.unique_tuple		= dccp_unique_tuple,
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
+#endif
+};
+
+static int __init nf_nat_proto_dccp_init(void)
+{
+	return nf_nat_protocol_register(&nf_nat_protocol_dccp);
+}
+
+static void __exit nf_nat_proto_dccp_fini(void)
+{
+	nf_nat_protocol_unregister(&nf_nat_protocol_dccp);
+}
+
+module_init(nf_nat_proto_dccp_init);
+module_exit(nf_nat_proto_dccp_fini);
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("DCCP NAT protocol helper");
+MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index dc316b9..b759ffa 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -51,7 +51,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		fl->fl4_dst = t->dst.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE)
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP)
 			fl->fl_ip_dport = t->dst.u.tcp.port;
 	}
 
@@ -61,7 +62,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		fl->fl4_src = t->src.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE)
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP)
 			fl->fl_ip_sport = t->src.u.tcp.port;
 	}
 }
