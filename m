From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 6/6] xt_TOS v1 target
Date: Tue, 27 Nov 2007 00:43:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270043430.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49985 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbXKZXn4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:43:56 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Import xt_tos v1 target

Extends the xt_DSCP target by xt_TOS v1 to add support for selectively
setting and flipping any bit in the IPv4 TOS and IPv6 Priority fields.
(ipt_TOS and xt_DSCP only accepted a limited range of possible
values.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_DSCP.h |    5 +++
 net/netfilter/Kconfig             |    2 -
 net/netfilter/xt_DSCP.c           |   63 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/netfilter/xt_DSCP.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_DSCP.h
+++ linux-2.6/include/linux/netfilter/xt_DSCP.h
@@ -17,4 +17,9 @@ struct xt_DSCP_info {
 	u_int8_t dscp;
 };
 
+struct xt_tos_target_info {
+	u_int8_t tos_value;
+	u_int8_t tos_mask;
+};
+
 #endif /* _XT_DSCP_TARGET_H */
Index: linux-2.6/net/netfilter/Kconfig
===================================================================
--- linux-2.6.orig/net/netfilter/Kconfig
+++ linux-2.6/net/netfilter/Kconfig
@@ -304,7 +304,7 @@ config NETFILTER_XT_TARGET_DSCP
 
 	  It also adds the "TOS" target, which allows you to create rules in
 	  the "mangle" table which alter the Type Of Service field of an IPv4
-	  packet prior to routing.
+	  or the Priority field of an IPv6 packet, prior to routing.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
Index: linux-2.6/net/netfilter/xt_DSCP.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_DSCP.c
+++ linux-2.6/net/netfilter/xt_DSCP.c
@@ -26,6 +26,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
 MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
 
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct net_device *in,
@@ -117,6 +118,50 @@ tos_tg_check_v0(const char *tablename, c
 	return true;
 }
 
+static unsigned int
+tos_tg(struct sk_buff *skb, const struct net_device *in,
+       const struct net_device *out, unsigned int hooknum,
+       const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tos_target_info *info = targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u_int8_t orig, nv;
+
+	orig = ipv4_get_dsfield(iph);
+	nv   = (orig & info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ip_hdr(skb);
+		ipv4_change_dsfield(iph, ~0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct net_device *in,
+        const struct net_device *out, unsigned int hooknum,
+        const struct xt_target *target, const void *targinfo)
+{
+	const struct xt_tos_target_info *info = targinfo;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	u_int8_t orig, nv;
+
+	orig = ipv6_get_dsfield(iph);
+	nv   = (orig & info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ipv6_hdr(skb);
+		ipv6_change_dsfield(iph, ~0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
 static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "DSCP",
@@ -146,6 +191,24 @@ static struct xt_target dscp_tg_reg[] __
 		.checkentry = tos_tg_check_v0,
 		.me         = THIS_MODULE,
 	},
+	{
+		.name       = "TOS",
+		.revision   = 1,
+		.family     = AF_INET,
+		.table      = "mangle",
+		.target     = tos_tg,
+		.targetsize = sizeof(struct xt_tos_target_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "TOS",
+		.revision   = 1,
+		.family     = AF_INET6,
+		.table      = "mangle",
+		.target     = tos_tg6,
+		.targetsize = sizeof(struct xt_tos_target_info),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init dscp_tg_init(void)
