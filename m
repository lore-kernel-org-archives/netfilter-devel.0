From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/49]: IPv6 capable xt_tos v1 match
Date: Tue,  4 Dec 2007 13:02:14 +0100 (MET)
Message-ID: <20071204120213.2442.20355.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62139 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXLDMCP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:15 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: IPv6 capable xt_tos v1 match

Extends the xt_dscp match by xt_tos v1 to add support for selectively
matching any bit in the IPv4 TOS and IPv6 Priority fields. (ipt_tos
and xt_dscp only accepted a limited range of possible values.)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ef44af12ba911ba711ac38989aabfaeee0fedd71
tree 88d954f58ab6413c0104c8ead3d5cdccc8951389
parent 8566a393780f1db8d84bd066f2d1734ffa90d709
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:47:05 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:23:37 +0100

 include/linux/netfilter/xt_dscp.h |    6 ++++++
 net/netfilter/xt_dscp.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index 1da61e6..f49bc1a 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
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
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 75b0df9..834e437 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -23,6 +23,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
+MODULE_ALIAS("ip6t_tos");
 
 static bool
 dscp_mt(const struct sk_buff *skb, const struct net_device *in,
@@ -72,6 +73,21 @@ static bool tos_mt_v0(const struct sk_buff *skb, const struct net_device *in,
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
@@ -97,6 +113,22 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.matchsize	= sizeof(struct ipt_tos_info),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "tos",
+		.revision	= 1,
+		.family		= AF_INET,
+		.match		= tos_mt,
+		.matchsize	= sizeof(struct xt_tos_match_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "tos",
+		.revision	= 1,
+		.family		= AF_INET6,
+		.match		= tos_mt,
+		.matchsize	= sizeof(struct xt_tos_match_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init dscp_mt_init(void)
