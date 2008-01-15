From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/38]: xt_iprange match, revision 1
Date: Tue, 15 Jan 2008 07:19:36 +0100 (MET)
Message-ID: <20080115061931.3184.67644.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62208 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYAOGTi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:38 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_iprange match, revision 1

Adds IPv6 support to xt_iprange, making it possible to match on IPv6
address ranges with ip6tables.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ba17e28b907c34daf0278e6c3c5d3413a3082649
tree 1f576e5bb0a1e44a911e0a7ddbcd11f9fcabc131
parent bb44619d743106e32849e7a6d98464506c73f9f5
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:43 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:22 +0100

 net/netfilter/xt_iprange.c |  122 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index c57a6cf..dbea0e0 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -2,6 +2,7 @@
  *	xt_iprange - Netfilter module to match IP address ranges
  *
  *	(C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *	(C) CC Computer Consultants GmbH, 2008
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2 as
@@ -10,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
@@ -51,26 +53,128 @@ iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static struct xt_match iprange_mt_reg __read_mostly = {
-	.name		= "iprange",
-	.family		= AF_INET,
-	.match		= iprange_mt_v0,
-	.matchsize	= sizeof(struct ipt_iprange_info),
-	.me		= THIS_MODULE
+static bool
+iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
+{
+	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct iphdr *iph = ip_hdr(skb);
+	bool m;
+
+	if (info->flags & IPRANGE_SRC) {
+		m  = ntohl(iph->saddr) < ntohl(info->src_min.ip);
+		m |= ntohl(iph->saddr) > ntohl(info->src_max.ip);
+		m ^= info->flags & IPRANGE_SRC_INV;
+		if (m) {
+			pr_debug("src IP " NIPQUAD_FMT " NOT in range %s"
+			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
+			         NIPQUAD(iph->saddr),
+			         (info->flags & IPRANGE_SRC_INV) ? "(INV) " : "",
+			         NIPQUAD(info->src_max.ip),
+			         NIPQUAD(info->src_max.ip));
+			return false;
+		}
+	}
+	if (info->flags & IPRANGE_DST) {
+		m  = ntohl(iph->daddr) < ntohl(info->dst_min.ip);
+		m |= ntohl(iph->daddr) > ntohl(info->dst_max.ip);
+		m ^= info->flags & IPRANGE_DST_INV;
+		if (m) {
+			pr_debug("dst IP " NIPQUAD_FMT " NOT in range %s"
+			         NIPQUAD_FMT "-" NIPQUAD_FMT "\n",
+			         NIPQUAD(iph->daddr),
+			         (info->flags & IPRANGE_DST_INV) ? "(INV) " : "",
+			         NIPQUAD(info->dst_min.ip),
+			         NIPQUAD(info->dst_max.ip));
+			return false;
+		}
+	}
+	return true;
+}
+
+static inline int
+iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
+{
+	unsigned int i;
+	int r;
+
+	for (i = 0; i < 4; ++i) {
+		r = a->s6_addr32[i] - b->s6_addr32[i];
+		if (r != 0)
+			return r;
+	}
+
+	return 0;
+}
+
+static bool
+iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
+            const struct net_device *out, const struct xt_match *match,
+            const void *matchinfo, int offset, unsigned int protoff,
+            bool *hotdrop)
+{
+	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	bool m;
+
+	if (info->flags & IPRANGE_SRC) {
+		m  = iprange_ipv6_sub(&iph->saddr, &info->src_min.in6) < 0;
+		m |= iprange_ipv6_sub(&iph->saddr, &info->src_max.in6) > 0;
+		m ^= info->flags & IPRANGE_SRC_INV;
+		if (m)
+			return false;
+	}
+	if (info->flags & IPRANGE_DST) {
+		m  = iprange_ipv6_sub(&iph->daddr, &info->dst_min.in6) < 0;
+		m |= iprange_ipv6_sub(&iph->daddr, &info->dst_max.in6) > 0;
+		m ^= info->flags & IPRANGE_DST_INV;
+		if (m)
+			return false;
+	}
+	return true;
+}
+
+static struct xt_match iprange_mt_reg[] __read_mostly = {
+	{
+		.name      = "iprange",
+		.revision  = 0,
+		.family    = AF_INET,
+		.match     = iprange_mt_v0,
+		.matchsize = sizeof(struct ipt_iprange_info),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "iprange",
+		.revision  = 1,
+		.family    = AF_INET6,
+		.match     = iprange_mt4,
+		.matchsize = sizeof(struct xt_iprange_mtinfo),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "iprange",
+		.revision  = 1,
+		.family    = AF_INET6,
+		.match     = iprange_mt6,
+		.matchsize = sizeof(struct xt_iprange_mtinfo),
+		.me        = THIS_MODULE,
+	},
 };
 
 static int __init iprange_mt_init(void)
 {
-	return xt_register_match(&iprange_mt_reg);
+	return xt_register_matches(iprange_mt_reg, ARRAY_SIZE(iprange_mt_reg));
 }
 
 static void __exit iprange_mt_exit(void)
 {
-	xt_unregister_match(&iprange_mt_reg);
+	xt_unregister_matches(iprange_mt_reg, ARRAY_SIZE(iprange_mt_reg));
 }
 
 module_init(iprange_mt_init);
 module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
