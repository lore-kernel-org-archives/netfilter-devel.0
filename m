From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_mac match revision 1
Date: Sat, 22 Dec 2007 03:40:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220340220.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXLVCkt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:40:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce the xt_mac match revision 1. All members with unfixated
size have been exchanged by types of fixed width. I have also taken
the freedom to decouple the long if() condition.

Signed-off-by: Jan Engelhart <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_mac.h |    6 ++++
 net/netfilter/xt_mac.c           |   51 +++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 5 deletions(-)

Index: linux-2.6_nosov/include/linux/netfilter/xt_mac.h
===================================================================
--- linux-2.6_nosov.orig/include/linux/netfilter/xt_mac.h
+++ linux-2.6_nosov/include/linux/netfilter/xt_mac.h
@@ -5,4 +5,10 @@ struct xt_mac_info {
     unsigned char srcaddr[ETH_ALEN];
     int invert;
 };
+
+struct xt_mac_match_info {
+	unsigned char srcaddr[ETH_ALEN];
+	u_int8_t invert;
+};
+
 #endif /*_XT_MAC_H*/
Index: linux-2.6_nosov/net/netfilter/xt_mac.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_mac.c
+++ linux-2.6_nosov/net/netfilter/xt_mac.c
@@ -25,9 +25,9 @@ MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
 static bool
-mac_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+mac_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
     const struct xt_mac_info *info = matchinfo;
 
@@ -39,11 +39,29 @@ mac_mt(const struct sk_buff *skb, const 
 		^ info->invert);
 }
 
+static bool
+mac_mt(const struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, const struct xt_match *match,
+       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_mac_match_info *info = matchinfo;
+	const unsigned char *mac = skb_mac_header(skb);
+
+	/* Is MAC pointer valid? */
+	if (!(mac >= skb->head && mac + ETH_HLEN <= skb->data))
+		return info->invert;
+
+	/* If so, compare */
+	return (compare_ether_addr(eth_hdr(skb)->h_source,
+	       info->srcaddr) == 0) ^ info->invert;
+}
+
 static struct xt_match mac_mt_reg[] __read_mostly = {
 	{
 		.name		= "mac",
+		.revision	= 0,
 		.family		= AF_INET,
-		.match		= mac_mt,
+		.match		= mac_mt_v0,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN) |
@@ -52,14 +70,37 @@ static struct xt_match mac_mt_reg[] __re
 	},
 	{
 		.name		= "mac",
+		.revision	= 0,
 		.family		= AF_INET6,
-		.match		= mac_mt,
+		.match		= mac_mt_v0,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN) |
 				  (1 << NF_INET_FORWARD),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name           = "mac",
+		.revision       = 1,
+		.family         = AF_INET,
+		.match          = mac_mt,
+		.matchsize      = sizeof(struct xt_mac_info),
+		.hooks          = (1 << NF_INET_PRE_ROUTING) |
+		                  (1 << NF_INET_LOCAL_IN) |
+		                  (1 << NF_INET_FORWARD),
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "mac",
+		.revision       = 1,
+		.family         = AF_INET6,
+		.match          = mac_mt,
+		.matchsize      = sizeof(struct xt_mac_info),
+		.hooks          = (1 << NF_INET_PRE_ROUTING) |
+		                  (1 << NF_INET_LOCAL_IN) |
+		                  (1 << NF_INET_FORWARD),
+		.me             = THIS_MODULE,
+	},
 };
 
 static int __init mac_mt_init(void)

