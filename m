From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ipt_addrtype: rename to xt_addrtype
Date: Sat,  5 Mar 2011 17:08:47 +0100
Message-ID: <1299341328-4663-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55424 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577Ab1CEQOg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:14:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fwestphal@astaro.com>

followup patch will add ipv6 support.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 include/linux/netfilter/Kbuild                     |    1 +
 .../ipt_addrtype.h => netfilter/xt_addrtype.h}     |   16 +++++-----
 include/linux/netfilter_ipv4/Kbuild                |    1 -
 net/ipv4/netfilter/Kconfig                         |   10 ------
 net/ipv4/netfilter/Makefile                        |    1 -
 net/netfilter/Kconfig                              |   10 ++++++
 net/netfilter/Makefile                             |    1 +
 .../ipt_addrtype.c => netfilter/xt_addrtype.c}     |   31 ++++++++++---------
 8 files changed, 36 insertions(+), 35 deletions(-)
 rename include/linux/{netfilter_ipv4/ipt_addrtype.h => netfilter/xt_addrtype.h} (51%)
 rename net/{ipv4/netfilter/ipt_addrtype.c => netfilter/xt_addrtype.c} (79%)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 15e83bf..a1b410c 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -29,6 +29,7 @@ header-y += xt_TCPMSS.h
 header-y += xt_TCPOPTSTRIP.h
 header-y += xt_TEE.h
 header-y += xt_TPROXY.h
+header-y += xt_addrtype.h
 header-y += xt_cluster.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter/xt_addrtype.h
similarity index 51%
rename from include/linux/netfilter_ipv4/ipt_addrtype.h
rename to include/linux/netfilter/xt_addrtype.h
index 0da4223..b492fc8 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter/xt_addrtype.h
@@ -1,23 +1,23 @@
-#ifndef _IPT_ADDRTYPE_H
-#define _IPT_ADDRTYPE_H
+#ifndef _XT_ADDRTYPE_H
+#define _XT_ADDRTYPE_H
 
 #include <linux/types.h>
 
 enum {
-	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
-	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
-	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
-	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+	XT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	XT_ADDRTYPE_INVERT_DEST		= 0x0002,
+	XT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	XT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
 };
 
-struct ipt_addrtype_info_v1 {
+struct xt_addrtype_info_v1 {
 	__u16	source;		/* source-type mask */
 	__u16	dest;		/* dest-type mask */
 	__u32	flags;
 };
 
 /* revision 0 */
-struct ipt_addrtype_info {
+struct xt_addrtype_info {
 	__u16	source;		/* source-type mask */
 	__u16	dest;		/* dest-type mask */
 	__u32	invert_source;
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index f9930c8..8e6362b 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -7,7 +7,6 @@ header-y += ipt_REJECT.h
 header-y += ipt_SAME.h
 header-y += ipt_TTL.h
 header-y += ipt_ULOG.h
-header-y += ipt_addrtype.h
 header-y += ipt_ah.h
 header-y += ipt_ecn.h
 header-y += ipt_realm.h
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index f926a31..1dfc18a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -64,16 +64,6 @@ config IP_NF_IPTABLES
 if IP_NF_IPTABLES
 
 # The matches.
-config IP_NF_MATCH_ADDRTYPE
-	tristate '"addrtype" address type match support'
-	depends on NETFILTER_ADVANCED
-	help
-	  This option allows you to match what routing thinks of an address,
-	  eg. UNICAST, LOCAL, BROADCAST, ...
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
-
 config IP_NF_MATCH_AH
 	tristate '"ah" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 19eb59d..dca2082 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -48,7 +48,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 
 # matches
-obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 82a6e0d..32bff6d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -649,6 +649,16 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 
 comment "Xtables matches"
 
+config NETFILTER_XT_MATCH_ADDRTYPE
+	tristate '"addrtype" address type match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	  This option allows you to match what routing thinks of an address,
+	  eg. UNICAST, LOCAL, BROADCAST, ...
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+
 config NETFILTER_XT_MATCH_CLUSTER
 	tristate '"cluster" match support'
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d57a890..1a02853 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
 
 # matches
+obj-$(CONFIG_NETFILTER_XT_MATCH_ADDRTYPE) += xt_addrtype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/netfilter/xt_addrtype.c
similarity index 79%
rename from net/ipv4/netfilter/ipt_addrtype.c
rename to net/netfilter/xt_addrtype.c
index db8bff0..e89c0b8 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -16,12 +16,13 @@
 #include <linux/ip.h>
 #include <net/route.h>
 
-#include <linux/netfilter_ipv4/ipt_addrtype.h>
+#include <linux/netfilter/xt_addrtype.h>
 #include <linux/netfilter/x_tables.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: address type match for IPv4");
+MODULE_DESCRIPTION("Xtables: address type match");
+MODULE_ALIAS("ipt_addrtype");
 
 static inline bool match_type(struct net *net, const struct net_device *dev,
 			      __be32 addr, u_int16_t mask)
@@ -33,7 +34,7 @@ static bool
 addrtype_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = dev_net(par->in ? par->in : par->out);
-	const struct ipt_addrtype_info *info = par->matchinfo;
+	const struct xt_addrtype_info *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool ret = true;
 
@@ -51,31 +52,31 @@ static bool
 addrtype_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = dev_net(par->in ? par->in : par->out);
-	const struct ipt_addrtype_info_v1 *info = par->matchinfo;
+	const struct xt_addrtype_info_v1 *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct net_device *dev = NULL;
 	bool ret = true;
 
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN)
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
 		dev = par->in;
-	else if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT)
+	else if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
 		dev = par->out;
 
 	if (info->source)
 		ret &= match_type(net, dev, iph->saddr, info->source) ^
-		       (info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
+		       (info->flags & XT_ADDRTYPE_INVERT_SOURCE);
 	if (ret && info->dest)
 		ret &= match_type(net, dev, iph->daddr, info->dest) ^
-		       !!(info->flags & IPT_ADDRTYPE_INVERT_DEST);
+		       !!(info->flags & XT_ADDRTYPE_INVERT_DEST);
 	return ret;
 }
 
 static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 {
-	struct ipt_addrtype_info_v1 *info = par->matchinfo;
+	struct xt_addrtype_info_v1 *info = par->matchinfo;
 
-	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN &&
-	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		pr_info("both incoming and outgoing "
 			"interface limitation cannot be selected\n");
 		return -EINVAL;
@@ -83,7 +84,7 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) &&
-	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		pr_info("output interface limitation "
 			"not valid in PREROUTING and INPUT\n");
 		return -EINVAL;
@@ -91,7 +92,7 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
 	    (1 << NF_INET_LOCAL_OUT)) &&
-	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
 		pr_info("input interface limitation "
 			"not valid in POSTROUTING and OUTPUT\n");
 		return -EINVAL;
@@ -105,7 +106,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.name		= "addrtype",
 		.family		= NFPROTO_IPV4,
 		.match		= addrtype_mt_v0,
-		.matchsize	= sizeof(struct ipt_addrtype_info),
+		.matchsize	= sizeof(struct xt_addrtype_info),
 		.me		= THIS_MODULE
 	},
 	{
@@ -114,7 +115,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
 		.checkentry	= addrtype_mt_checkentry_v1,
-		.matchsize	= sizeof(struct ipt_addrtype_info_v1),
+		.matchsize	= sizeof(struct xt_addrtype_info_v1),
 		.me		= THIS_MODULE
 	}
 };
-- 
1.7.2.2

