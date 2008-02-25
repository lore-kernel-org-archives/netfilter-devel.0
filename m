From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_nat: add UDP-Lite support
Date: Mon, 25 Feb 2008 16:29:49 +0100
Message-ID: <47C2DEED.8060509@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060905040006000507020505"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:16244 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYBYP34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:29:56 -0500
Received: from edge.upc.biz ([192.168.13.239]) by viefep18-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080225152953.EIGZ3275.viefep18-int.chello.at@edge.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 25 Feb 2008 16:29:53 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060905040006000507020505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------060905040006000507020505
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

[NETFILTER]: nf_nat: add UDP-Lite support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a5c44007dada00240b0bafce2f452fc59408aace
tree e298386a5d8fc40c21c281073e4c92a735c3acd3
parent a12512d2930b16ec0e66f7fceb698109d97aa857
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 16:21:12 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 16:21:12 +0100

 net/ipv4/netfilter/Kconfig                |    5 ++
 net/ipv4/netfilter/Makefile               |    1 
 net/ipv4/netfilter/nf_nat_proto_udplite.c |   95 +++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_standalone.c    |    6 +-
 4 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9a077cb..c5bd284 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -245,6 +245,11 @@ config NF_NAT_PROTO_GRE
 	tristate
 	depends on NF_NAT && NF_CT_PROTO_GRE
 
+config NF_NAT_PROTO_UDPLITE
+	tristate
+	depends on NF_NAT && NF_CT_PROTO_UDPLITE
+	default NF_NAT && NF_CT_PROTO_UDPLITE
+
 config NF_NAT_FTP
 	tristate
 	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index e73d0eb..332f46f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
+obj-$(CONFIG_NF_NAT_PROTO_UDPLITE) += nf_nat_proto_udplite.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_nat_proto_udplite.c b/net/ipv4/netfilter/nf_nat_proto_udplite.c
new file mode 100644
index 0000000..1cbad08
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_udplite.c
@@ -0,0 +1,95 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+static u_int16_t udplite_port_rover;
+
+static int
+udplite_unique_tuple(struct nf_conntrack_tuple *tuple,
+		     const struct nf_nat_range *range,
+		     enum nf_nat_manip_type maniptype,
+		     const struct nf_conn *ct)
+{
+	return nf_nat_proto_unique_tuple(tuple, range, maniptype, ct,
+					 &udplite_port_rover);
+}
+
+static int
+udplite_manip_pkt(struct sk_buff *skb,
+		  unsigned int iphdroff,
+		  const struct nf_conntrack_tuple *tuple,
+		  enum nf_nat_manip_type maniptype)
+{
+	const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	struct udphdr *hdr;
+	unsigned int hdroff = iphdroff + iph->ihl*4;
+	__be32 oldip, newip;
+	__be16 *portptr, newport;
+
+	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+		return 0;
+
+	iph = (struct iphdr *)(skb->data + iphdroff);
+	hdr = (struct udphdr *)(skb->data + hdroff);
+
+	if (maniptype == IP_NAT_MANIP_SRC) {
+		/* Get rid of src ip and src pt */
+		oldip = iph->saddr;
+		newip = tuple->src.u3.ip;
+		newport = tuple->src.u.udp.port;
+		portptr = &hdr->source;
+	} else {
+		/* Get rid of dst ip and dst pt */
+		oldip = iph->daddr;
+		newip = tuple->dst.u3.ip;
+		newport = tuple->dst.u.udp.port;
+		portptr = &hdr->dest;
+	}
+
+	inet_proto_csum_replace4(&hdr->check, skb, oldip, newip, 1);
+	inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport, 0);
+	if (!hdr->check)
+		hdr->check = CSUM_MANGLED_0;
+
+	*portptr = newport;
+	return 1;
+}
+
+static const struct nf_nat_protocol nf_nat_protocol_udplite = {
+	.protonum		= IPPROTO_UDPLITE,
+	.me			= THIS_MODULE,
+	.manip_pkt		= udplite_manip_pkt,
+	.in_range		= nf_nat_proto_in_range,
+	.unique_tuple		= udplite_unique_tuple,
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
+#endif
+};
+
+static int __init nf_nat_proto_udplite_init(void)
+{
+	return nf_nat_protocol_register(&nf_nat_protocol_udplite);
+}
+
+static void __exit nf_nat_proto_udplite_fini(void)
+{
+	nf_nat_protocol_unregister(&nf_nat_protocol_udplite);
+}
+
+module_init(nf_nat_proto_udplite_init);
+module_exit(nf_nat_proto_udplite_fini);
+MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 99b2c78..e6e7979 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -50,7 +50,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 	if (ct->status & statusbit) {
 		fl->fl4_dst = t->dst.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP)
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE)
 			fl->fl_ip_dport = t->dst.u.tcp.port;
 	}
 
@@ -59,7 +60,8 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 	if (ct->status & statusbit) {
 		fl->fl4_src = t->src.u3.ip;
 		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP)
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE)
 			fl->fl_ip_sport = t->src.u.tcp.port;
 	}
 }

--------------060905040006000507020505--
