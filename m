From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/41]: nf_nat: add SCTP protocol support
Date: Mon, 14 Apr 2008 12:16:54 +0200 (MEST)
Message-ID: <20080414101650.32717.79598.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYDNKQy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:54 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: add SCTP protocol support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a5d5b6924c527ebc0a64791a198257c3ffe98a5a
tree 7018c997e620e180899110537df638b228aeae57
parent 657f0294023ce9bfb5e2cca56ccaa64197414665
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:53 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:53 +0200

 net/ipv4/netfilter/Kconfig             |    5 ++
 net/ipv4/netfilter/Makefile            |    1 
 net/ipv4/netfilter/nf_nat_proto_sctp.c |   96 ++++++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_standalone.c |    6 +-
 4 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index fde3eac..0c95cd5 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -255,6 +255,11 @@ config NF_NAT_PROTO_UDPLITE
 	depends on NF_NAT && NF_CT_PROTO_UDPLITE
 	default NF_NAT && NF_CT_PROTO_UDPLITE
 
+config NF_NAT_PROTO_SCTP
+	tristate
+	default NF_NAT && NF_CT_PROTO_SCTP
+	depends on NF_NAT && NF_CT_PROTO_SCTP
+
 config NF_NAT_FTP
 	tristate
 	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 74d8dbd..d9b92fb 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 obj-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 obj-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
+obj-$(CONFIG_NF_NAT_PROTO_SCTP) += nf_nat_proto_sctp.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_nat_proto_sctp.c b/net/ipv4/netfilter/nf_nat_proto_sctp.c
new file mode 100644
index 0000000..3d3faa9
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_sctp.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/sctp.h>
+#include <net/sctp/checksum.h>
+
+#include <net/netfilter/nf_nat_protocol.h>
+
+static u_int16_t nf_sctp_port_rover;
+
+static int
+sctp_unique_tuple(struct nf_conntrack_tuple *tuple,
+		  const struct nf_nat_range *range,
+		  enum nf_nat_manip_type maniptype,
+		  const struct nf_conn *ct)
+{
+	return nf_nat_proto_unique_tuple(tuple, range, maniptype, ct,
+					 &nf_sctp_port_rover);
+}
+
+static int
+sctp_manip_pkt(struct sk_buff *skb,
+	       unsigned int iphdroff,
+	       const struct nf_conntrack_tuple *tuple,
+	       enum nf_nat_manip_type maniptype)
+{
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	sctp_sctphdr_t *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
+	__be32 oldip, newip;
+	u32 crc32;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return 0;
+
+	iph = (struct iphdr *)(skb->data + iphdroff);
+	hdr = (struct sctphdr *)(skb->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		/* Get rid of src ip and src pt */
+		oldip = iph->saddr;
+		newip = tuple->src.u3.ip;
+		hdr->source = tuple->src.u.sctp.port;
+	} else {
+		/* Get rid of dst ip and dst pt */
+		oldip = iph->daddr;
+		newip = tuple->dst.u3.ip;
+		hdr->dest = tuple->dst.u.sctp.port;
+	}
+
+	crc32 = sctp_start_cksum((u8 *)hdr, skb_headlen(skb) - hdroff);
+	for (skb = skb_shinfo(skb)->frag_list; skb; skb = skb->next)
+		crc32 = sctp_update_cksum((u8 *)skb->data, skb_headlen(skb),
+					  crc32);
+	crc32 = sctp_end_cksum(crc32);
+	hdr->checksum = htonl(crc32);
+
+	return 1;
+}
+
+static const struct nf_nat_protocol nf_nat_protocol_sctp = {
+	.protonum		= IPPROTO_SCTP,
+	.me			= THIS_MODULE,
+	.manip_pkt		= sctp_manip_pkt,
+	.in_range		= nf_nat_proto_in_range,
+	.unique_tuple		= sctp_unique_tuple,
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
+#endif
+};
+
+static int __init nf_nat_proto_sctp_init(void)
+{
+	return nf_nat_protocol_register(&nf_nat_protocol_sctp);
+}
+
+static void __exit nf_nat_proto_sctp_exit(void)
+{
+	nf_nat_protocol_unregister(&nf_nat_protocol_sctp);
+}
+
+module_init(nf_nat_proto_sctp_init);
+module_exit(nf_nat_proto_sctp_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCTP NAT protocol helper");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index b759ffa..4a3e0f8 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -52,7 +52,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
 		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP)
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
 			fl->fl_ip_dport = t->dst.u.tcp.port;
 	}
 
@@ -63,7 +64,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		if (t->dst.protonum == IPPROTO_TCP ||
 		    t->dst.protonum == IPPROTO_UDP ||
 		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP)
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
 			fl->fl_ip_sport = t->src.u.tcp.port;
 	}
 }
