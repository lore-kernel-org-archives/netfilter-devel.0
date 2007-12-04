From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/49]: IPv6 capable xt_TOS v1 target
Date: Tue,  4 Dec 2007 13:02:15 +0100 (MET)
Message-ID: <20071204120215.2442.60829.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62142 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbXLDMCQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:16 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: IPv6 capable xt_TOS v1 target

Extends the xt_DSCP target by xt_TOS v1 to add support for selectively
setting and flipping any bit in the IPv4 TOS and IPv6 Priority fields.
(ipt_TOS and xt_DSCP only accepted a limited range of possible
values.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 76a21a5927f267f96a9049c77627d2983652686a
tree 088243b4cd84c7bef3fd4fd6176a95d858cee65c
parent ef44af12ba911ba711ac38989aabfaeee0fedd71
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:47:06 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:24:03 +0100

 include/linux/netfilter/xt_DSCP.h |    5 +++
 net/netfilter/Kconfig             |    2 +
 net/netfilter/xt_DSCP.c           |   63 +++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
index 3c7c963..14da196 100644
--- a/include/linux/netfilter/xt_DSCP.h
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -17,4 +17,9 @@ struct xt_DSCP_info {
 	u_int8_t dscp;
 };
 
+struct xt_tos_target_info {
+	u_int8_t tos_value;
+	u_int8_t tos_mask;
+};
+
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9c82d4c..7bde631 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -304,7 +304,7 @@ config NETFILTER_XT_TARGET_DSCP
 
 	  It also adds the "TOS" target, which allows you to create rules in
 	  the "mangle" table which alter the Type Of Service field of an IPv4
-	  packet prior to routing.
+	  or the Priority field of an IPv6 packet, prior to routing.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 40a4f1d..fd7500e 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -26,6 +26,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
 MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
 
 static unsigned int
 dscp_tg(struct sk_buff *skb, const struct net_device *in,
@@ -117,6 +118,50 @@ tos_tg_check_v0(const char *tablename, const void *e_void,
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
@@ -146,6 +191,24 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 		.checkentry	= tos_tg_check_v0,
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= AF_INET,
+		.table		= "mangle",
+		.target		= tos_tg,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= AF_INET6,
+		.table		= "mangle",
+		.target		= tos_tg6,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init dscp_tg_init(void)
