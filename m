From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/41]: nf_nat: add UDP-Lite support
Date: Mon, 14 Apr 2008 12:16:48 +0200 (MEST)
Message-ID: <20080414101645.32717.41950.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYDNKQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:49 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: add UDP-Lite support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3eee75c01a5589393289a81daf19215a45f802b9
tree f48fae969c0ad8606df2ac17312e94b03fe2e457
parent 0caae257342d590b5dbe846fdb4519286f94bd78
author Patrick McHardy <kaber@trash.net> Thu, 20 Mar 2008 15:15:51 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:51 +0200

 net/ipv4/netfilter/Kconfig                |    5 +
 net/ipv4/netfilter/Makefile               |    1 
 net/ipv4/netfilter/nf_nat_proto_udplite.c |   99 +++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_standalone.c    |    6 +-
 4 files changed, 109 insertions(+), 2 deletions(-)

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
index 0000000..b29346d
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_udplite.c
@@ -0,0 +1,99 @@
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2008 Patrick McHardy <kaber@trash.net>
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
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
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
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("UDP-Lite NAT protocol helper");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 9fba42d..dc316b9 100644
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
