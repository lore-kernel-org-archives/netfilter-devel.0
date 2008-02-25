From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_nat: add helpers for common NAT protocol operations
Date: Mon, 25 Feb 2008 16:29:12 +0100
Message-ID: <47C2DEC8.8030703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080901070800000405090108"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep25-int.chello.at ([62.179.121.45]:29755 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYBYP3V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:29:21 -0500
Received: from edge.upc.biz ([192.168.13.237]) by viefep25-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080225152917.TCMX17058.viefep25-int.chello.at@edge.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 25 Feb 2008 16:29:17 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080901070800000405090108
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I've queued this and the following two patches for 2.6.26
to add UDP-Lite NAT support. I'm also have some unfinished
conntrack/NAT support for DCCP and almost-finished NAT
support for SCTP. I'll post those patches once I've completed
them.


--------------080901070800000405090108
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_nat: add helpers for common NAT protocol operations

Add generic ->in_range and ->unique_tuple ops to avoid duplicating them
again and again for future NAT modules and save a few bytes of text:

net/ipv4/netfilter/nf_nat_proto_tcp.c:
  tcp_in_range     |  -62 (removed)
  tcp_unique_tuple | -259 # 271 -> 12, # inlines: 1 -> 0, size inlines: 7 -> 0
 2 functions changed, 321 bytes removed

net/ipv4/netfilter/nf_nat_proto_udp.c:
  udp_in_range     |  -62 (removed)
  udp_unique_tuple | -259 # 271 -> 12, # inlines: 1 -> 0, size inlines: 7 -> 0
 2 functions changed, 321 bytes removed

net/ipv4/netfilter/nf_nat_proto_gre.c:
  gre_in_range |  -62 (removed)
 1 function changed, 62 bytes removed

vmlinux:
 5 functions changed, 704 bytes removed

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bde9b6732e54a36d59a85dcf2fbcc29e202185fb
tree 6d61196d0e75bfa0a54d47fe583a9234e3170655
parent 072a69bf9f5cdf316b6d49b7ae943827ecc3eaf8
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:20:28 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:20:28 +0100

 include/net/netfilter/nf_nat_protocol.h  |   11 ++++
 net/ipv4/netfilter/Makefile              |    2 -
 net/ipv4/netfilter/nf_nat_proto_common.c |   87 ++++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_proto_gre.c    |   20 -------
 net/ipv4/netfilter/nf_nat_proto_tcp.c    |   65 +---------------------
 net/ipv4/netfilter/nf_nat_proto_udp.c    |   64 +---------------------
 6 files changed, 108 insertions(+), 141 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index 4aa0edb..fa06f6d 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -62,6 +62,17 @@ extern int init_protocols(void) __init;
 extern void cleanup_protocols(void);
 extern const struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
 
+extern int nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
+				 enum nf_nat_manip_type maniptype,
+				 const union nf_conntrack_man_proto *min,
+				 const union nf_conntrack_man_proto *max);
+
+extern int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+				     const struct nf_nat_range *range,
+				     enum nf_nat_manip_type maniptype,
+				     const struct nf_conn *ct,
+				     u_int16_t *rover);
+
 extern int nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 				       const struct nf_nat_range *range);
 extern int nf_nat_port_nlattr_to_range(struct nlattr *tb[],
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 0c7dc78..e73d0eb 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -10,7 +10,7 @@ nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
 endif
 endif
 
-nf_nat-objs		:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
+nf_nat-objs		:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_common.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
 iptable_nat-objs	:= nf_nat_rule.o nf_nat_standalone.o
 
 # connection tracking
diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
new file mode 100644
index 0000000..7f56f6b
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -0,0 +1,87 @@
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
+#include <linux/random.h>
+#include <linux/ip.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_rule.h>
+#include <net/netfilter/nf_nat_protocol.h>
+
+int
+nf_nat_proto_in_range(const struct nf_conntrack_tuple *tuple,
+		      enum nf_nat_manip_type maniptype,
+		      const union nf_conntrack_man_proto *min,
+		      const union nf_conntrack_man_proto *max)
+{
+	__be16 port;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		port = tuple->src.u.all;
+	else
+		port = tuple->dst.u.all;
+
+	return ntohs(port) >= ntohs(min->all) &&
+	       ntohs(port) <= ntohs(max->all);
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_in_range);
+
+int
+nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+			  const struct nf_nat_range *range,
+			  enum nf_nat_manip_type maniptype,
+			  const struct nf_conn *ct,
+			  u_int16_t *rover)
+{
+	unsigned int range_size, min, i;
+	__be16 *portptr;
+
+	if (maniptype == IP_NAT_MANIP_SRC)
+		portptr = &tuple->src.u.all;
+	else
+		portptr = &tuple->dst.u.all;
+
+	/* If no range specified... */
+	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
+		/* If it's dst rewrite, can't change port */
+		if (maniptype == IP_NAT_MANIP_DST)
+			return 0;
+
+		if (ntohs(*portptr) < 1024) {
+			/* Loose convention: >> 512 is credential passing */
+			if (ntohs(*portptr) < 512) {
+				min = 1;
+				range_size = 511 - min + 1;
+			} else {
+				min = 600;
+				range_size = 1023 - min + 1;
+			}
+		} else {
+			min = 1024;
+			range_size = 65535 - 1024 + 1;
+		}
+	} else {
+		min = ntohs(range->min.all);
+		range_size = ntohs(range->max.all) - min + 1;
+	}
+
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
+		*rover = net_random();
+
+	for (i = 0; i < range_size; i++, (*rover)++) {
+		*portptr = htons(min + *rover % range_size);
+		if (!nf_nat_used_tuple(tuple, ct))
+			return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_unique_tuple);
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index a1e4da1..87af63d 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -36,24 +36,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
 
-/* is key in given range between min and max */
-static int
-gre_in_range(const struct nf_conntrack_tuple *tuple,
-	     enum nf_nat_manip_type maniptype,
-	     const union nf_conntrack_man_proto *min,
-	     const union nf_conntrack_man_proto *max)
-{
-	__be16 key;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		key = tuple->src.u.gre.key;
-	else
-		key = tuple->dst.u.gre.key;
-
-	return ntohs(key) >= ntohs(min->gre.key) &&
-	       ntohs(key) <= ntohs(max->gre.key);
-}
-
 /* generate unique tuple ... */
 static int
 gre_unique_tuple(struct nf_conntrack_tuple *tuple,
@@ -140,7 +122,7 @@ static const struct nf_nat_protocol gre = {
 	.protonum		= IPPROTO_GRE,
 	.me			= THIS_MODULE,
 	.manip_pkt		= gre_manip_pkt,
-	.in_range		= gre_in_range,
+	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= gre_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index ffd5d15..f8c498f 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/random.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 
@@ -19,22 +18,7 @@
 #include <net/netfilter/nf_nat_protocol.h>
 #include <net/netfilter/nf_nat_core.h>
 
-static int
-tcp_in_range(const struct nf_conntrack_tuple *tuple,
-	     enum nf_nat_manip_type maniptype,
-	     const union nf_conntrack_man_proto *min,
-	     const union nf_conntrack_man_proto *max)
-{
-	__be16 port;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		port = tuple->src.u.tcp.port;
-	else
-		port = tuple->dst.u.tcp.port;
-
-	return ntohs(port) >= ntohs(min->tcp.port) &&
-	       ntohs(port) <= ntohs(max->tcp.port);
-}
+static u_int16_t tcp_port_rover;
 
 static int
 tcp_unique_tuple(struct nf_conntrack_tuple *tuple,
@@ -42,49 +26,8 @@ tcp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	static u_int16_t port;
-	__be16 *portptr;
-	unsigned int range_size, min, i;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		portptr = &tuple->src.u.tcp.port;
-	else
-		portptr = &tuple->dst.u.tcp.port;
-
-	/* If no range specified... */
-	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
-		/* If it's dst rewrite, can't change port */
-		if (maniptype == IP_NAT_MANIP_DST)
-			return 0;
-
-		/* Map privileged onto privileged. */
-		if (ntohs(*portptr) < 1024) {
-			/* Loose convention: >> 512 is credential passing */
-			if (ntohs(*portptr)<512) {
-				min = 1;
-				range_size = 511 - min + 1;
-			} else {
-				min = 600;
-				range_size = 1023 - min + 1;
-			}
-		} else {
-			min = 1024;
-			range_size = 65535 - 1024 + 1;
-		}
-	} else {
-		min = ntohs(range->min.tcp.port);
-		range_size = ntohs(range->max.tcp.port) - min + 1;
-	}
-
-	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
-		port =  net_random();
-
-	for (i = 0; i < range_size; i++, port++) {
-		*portptr = htons(min + port % range_size);
-		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
-	}
-	return 0;
+	return nf_nat_proto_unique_tuple(tuple, range, maniptype, ct,
+					 &tcp_port_rover);
 }
 
 static int
@@ -142,7 +85,7 @@ const struct nf_nat_protocol nf_nat_protocol_tcp = {
 	.protonum		= IPPROTO_TCP,
 	.me			= THIS_MODULE,
 	.manip_pkt		= tcp_manip_pkt,
-	.in_range		= tcp_in_range,
+	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= tcp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 4b8f499..a182f5a 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/random.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 
@@ -18,22 +17,7 @@
 #include <net/netfilter/nf_nat_rule.h>
 #include <net/netfilter/nf_nat_protocol.h>
 
-static int
-udp_in_range(const struct nf_conntrack_tuple *tuple,
-	     enum nf_nat_manip_type maniptype,
-	     const union nf_conntrack_man_proto *min,
-	     const union nf_conntrack_man_proto *max)
-{
-	__be16 port;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		port = tuple->src.u.udp.port;
-	else
-		port = tuple->dst.u.udp.port;
-
-	return ntohs(port) >= ntohs(min->udp.port) &&
-	       ntohs(port) <= ntohs(max->udp.port);
-}
+static u_int16_t udp_port_rover;
 
 static int
 udp_unique_tuple(struct nf_conntrack_tuple *tuple,
@@ -41,48 +25,8 @@ udp_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 enum nf_nat_manip_type maniptype,
 		 const struct nf_conn *ct)
 {
-	static u_int16_t port;
-	__be16 *portptr;
-	unsigned int range_size, min, i;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		portptr = &tuple->src.u.udp.port;
-	else
-		portptr = &tuple->dst.u.udp.port;
-
-	/* If no range specified... */
-	if (!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)) {
-		/* If it's dst rewrite, can't change port */
-		if (maniptype == IP_NAT_MANIP_DST)
-			return 0;
-
-		if (ntohs(*portptr) < 1024) {
-			/* Loose convention: >> 512 is credential passing */
-			if (ntohs(*portptr)<512) {
-				min = 1;
-				range_size = 511 - min + 1;
-			} else {
-				min = 600;
-				range_size = 1023 - min + 1;
-			}
-		} else {
-			min = 1024;
-			range_size = 65535 - 1024 + 1;
-		}
-	} else {
-		min = ntohs(range->min.udp.port);
-		range_size = ntohs(range->max.udp.port) - min + 1;
-	}
-
-	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
-		port = net_random();
-
-	for (i = 0; i < range_size; i++, port++) {
-		*portptr = htons(min + port % range_size);
-		if (!nf_nat_used_tuple(tuple, ct))
-			return 1;
-	}
-	return 0;
+	return nf_nat_proto_unique_tuple(tuple, range, maniptype, ct,
+					 &udp_port_rover);
 }
 
 static int
@@ -132,7 +76,7 @@ const struct nf_nat_protocol nf_nat_protocol_udp = {
 	.protonum		= IPPROTO_UDP,
 	.me			= THIS_MODULE,
 	.manip_pkt		= udp_manip_pkt,
-	.in_range		= udp_in_range,
+	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= udp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.range_to_nlattr	= nf_nat_port_range_to_nlattr,

--------------080901070800000405090108--
