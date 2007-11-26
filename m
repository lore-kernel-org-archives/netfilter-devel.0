From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 5/6] xt_tos v1 match
Date: Tue, 27 Nov 2007 00:43:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270043210.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49983 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXKZXnn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:43:43 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Import xt_tos v1 match

Extends the xt_dscp match by xt_tos v1 to add support for selectively
matching any bit in the IPv4 TOS and IPv6 Priority fields. (ipt_tos
and xt_dscp only accepted a limited range of possible values.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_dscp.h |    6 ++++++
 net/netfilter/xt_dscp.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: linux-2.6/include/linux/netfilter/xt_dscp.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_dscp.h
+++ linux-2.6/include/linux/netfilter/xt_dscp.h
@@ -20,4 +20,10 @@ struct xt_dscp_info {
 	u_int8_t invert;
 };
 
+struct xt_tos_match_info {
+	u_int8_t tos_mask;
+	u_int8_t tos_value;
+	u_int8_t invert;
+};
+
 #endif /* _XT_DSCP_H */
Index: linux-2.6/net/netfilter/xt_dscp.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_dscp.c
+++ linux-2.6/net/netfilter/xt_dscp.c
@@ -23,6 +23,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
+MODULE_ALIAS("ip6t_tos");
 
 static bool
 dscp_mt(const struct sk_buff *skb, const struct net_device *in,
@@ -72,6 +73,21 @@ static bool tos_mt_v0(const struct sk_bu
 	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
 }
 
+static bool tos_mt(const struct sk_buff *skb, const struct net_device *in,
+                   const struct net_device *out, const struct xt_match *match,
+                   const void *matchinfo, int offset, unsigned int protoff,
+                   bool *hotdrop)
+{
+	const struct xt_tos_match_info *info = matchinfo;
+
+	if (match->family == AF_INET)
+		return ((ip_hdr(skb)->tos & info->tos_mask) ==
+		       info->tos_value) ^ !!info->invert;
+	else
+		return ((ipv6_get_dsfield(ipv6_hdr(skb)) & info->tos_mask) ==
+		       info->tos_value) ^ !!info->invert;
+}
+
 static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "dscp",
@@ -97,6 +113,22 @@ static struct xt_match dscp_mt_reg[] __r
 		.matchsize = sizeof(struct ipt_tos_info),
 		.me        = THIS_MODULE,
 	},
+	{
+		.name      = "tos",
+		.revision  = 1,
+		.family    = AF_INET,
+		.match     = tos_mt,
+		.matchsize = sizeof(struct xt_tos_match_info),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "tos",
+		.revision  = 1,
+		.family    = AF_INET6,
+		.match     = tos_mt,
+		.matchsize = sizeof(struct xt_tos_match_info),
+		.me        = THIS_MODULE,
+	},
 };
 
 static int __init dscp_mt_init(void)
