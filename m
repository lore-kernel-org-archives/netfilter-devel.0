From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_pkttype match revision 1
Date: Sat, 22 Dec 2007 03:42:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220341300.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55162 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXLVCmG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:42:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_pkttype match revision 1. All members with unfixated
size have been exchanged by types of fixed width. Support for IPv6
multicast has also been added.

Signed-off-by: Jan Engelhart <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_pkttype.h |    5 ++++
 net/netfilter/xt_pkttype.c           |   41 +++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

Index: linux-2.6_nosov/include/linux/netfilter/xt_pkttype.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_pkttype.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_pkttype.h
@@ -5,4 +5,9 @@ struct xt_pkttype_info {
 	int	pkttype;
 	int	invert;
 };
+
+struct xt_pkttype_match_info {
+	u_int8_t pkttype, invert;
+};
+
 #endif /*_XT_PKTTYPE_H*/
Index: linux-2.6_nosov/net/netfilter/xt_pkttype.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_pkttype.c
+++ linux-2.6_nosov/net/netfilter/xt_pkttype.c
@@ -41,9 +41,33 @@ pkttype_mt(const struct sk_buff *skb, co
 	return (type == info->pkttype) ^ info->invert;
 }
 
+static bool
+pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
+           const struct net_device *out, const struct xt_match *match,
+           const void *matchinfo, int offset, unsigned int protoff,
+           bool *hotdrop)
+{
+	const struct xt_pkttype_match_info *info = matchinfo;
+	u_int8_t type;
+
+	if (skb->pkt_type != PACKET_LOOPBACK)
+		type = skb->pkt_type;
+	else if (match->family == AF_INET &&
+	    ipv4_is_multicast(ip_hdr(skb)->daddr))
+		type = PACKET_MULTICAST;
+	else if (match->family == AF_INET6 &&
+	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
+		type = PACKET_MULTICAST;
+	else
+		type = PACKET_BROADCAST;
+
+	return (type == info->pkttype) ^ info->invert;
+}
+
 static struct xt_match pkttype_mt_reg[] __read_mostly = {
 	{
 		.name		= "pkttype",
+		.revision	= 0,
 		.family		= AF_INET,
 		.match		= pkttype_mt,
 		.matchsize	= sizeof(struct xt_pkttype_info),
@@ -51,11 +75,28 @@ static struct xt_match pkttype_mt_reg[] 
 	},
 	{
 		.name		= "pkttype",
+		.revision	= 0,
 		.family		= AF_INET6,
 		.match		= pkttype_mt,
 		.matchsize	= sizeof(struct xt_pkttype_info),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name           = "pkttype",
+		.revision       = 1,
+		.family         = AF_INET,
+		.match          = pkttype_mt,
+		.matchsize      = sizeof(struct xt_pkttype_match_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name           = "pkttype",
+		.revision       = 1,
+		.family         = AF_INET6,
+		.match          = pkttype_mt,
+		.matchsize      = sizeof(struct xt_pkttype_match_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init pkttype_mt_init(void)

