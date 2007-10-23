From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add xt_tos
Date: Tue, 23 Oct 2007 16:12:50 +0200
Message-ID: <471E0162.7060702@trash.net>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr> <471A2338.6060501@trash.net> <Pine.LNX.4.64.0710201809380.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020102030002030308050901"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46799 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbXJWONr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:13:47 -0400
In-Reply-To: <Pine.LNX.4.64.0710201809380.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020102030002030308050901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Oct 20 2007 17:48, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> --- /dev/null
>>> +++ gitone/include/linux/netfilter/xt_tos.h
>>> @@ -0,0 +1,13 @@
>>> +#ifndef _XT_TOS_MATCH_H
>>> +#define _XT_TOS_MATCH_H
>>> +
>>> +struct xt_tos_info {
>>> +	u_int8_t tos;
>>> +	u_int8_t invert;
>>> +};
>>>   
>> I think this will break compatiblity on CRIS, which IIRC doesn't
>> perform any alignment (XT_ALIGN becomes a NOP) and thus the
>> structure size increases.
> 
> Alignment, where? There are no holes here.

XT_ALIGN - it pads to multiples of the highest alignment
requirement of u{8,16,32,64} - which is 1 one CRIS.

> Note that ipt_tos(_match)_info also had these two fields.

Right, I mixed something up. So the patch I queued (attached
again for reference) seems to be fine.

--------------020102030002030308050901
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: x_tables: convert ipt_tos to xt_tos

Convert ipt_tos to xt_tos, adding support for IPv6

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f8abb93075208dcfe0986dfbbfdb26681fa1325a
tree 0770c5ad87498a6b60970de451ba5acb3380740f
parent 21509062e54afc85b230256e61a91a6f5a66de06
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 23 Oct 2007 16:09:24 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 23 Oct 2007 16:09:24 +0200

 include/linux/netfilter/Kbuild         |    1 
 include/linux/netfilter/xt_tos.h       |   13 ++++++
 include/linux/netfilter_ipv4/ipt_tos.h |    9 +---
 net/ipv4/netfilter/Kconfig             |    9 ----
 net/ipv4/netfilter/Makefile            |    1 
 net/ipv4/netfilter/ipt_tos.c           |   55 ---------------------------
 net/netfilter/Kconfig                  |   10 +++++
 net/netfilter/Makefile                 |    1 
 net/netfilter/xt_tos.c                 |   65 ++++++++++++++++++++++++++++++++
 9 files changed, 92 insertions(+), 72 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index f2eaea2..2b91869 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -32,6 +32,7 @@ header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
+header-y += xt_tos.h
 header-y += xt_SECMARK.h
 header-y += xt_CONNSECMARK.h
 header-y += xt_TCPMSS.h
diff --git a/include/linux/netfilter/xt_tos.h b/include/linux/netfilter/xt_tos.h
new file mode 100644
index 0000000..5453032
--- /dev/null
+++ b/include/linux/netfilter/xt_tos.h
@@ -0,0 +1,13 @@
+#ifndef _XT_TOS_MATCH_H
+#define _XT_TOS_MATCH_H
+
+struct xt_tos_info {
+	u_int8_t tos;
+	u_int8_t invert;
+};
+
+#ifndef IPTOS_NORMALSVC
+#	define IPTOS_NORMALSVC 0
+#endif
+
+#endif /* _XT_TOS_MATCH_H */
diff --git a/include/linux/netfilter_ipv4/ipt_tos.h b/include/linux/netfilter_ipv4/ipt_tos.h
index a21f5df..3b610cc 100644
--- a/include/linux/netfilter_ipv4/ipt_tos.h
+++ b/include/linux/netfilter_ipv4/ipt_tos.h
@@ -1,13 +1,8 @@
 #ifndef _IPT_TOS_H
 #define _IPT_TOS_H
 
-struct ipt_tos_info {
-    u_int8_t tos;
-    u_int8_t invert;
-};
+#include <linux/netfilter/xt_tos.h>
 
-#ifndef IPTOS_NORMALSVC
-#define IPTOS_NORMALSVC 0
-#endif
+#define ipt_tos_info	xt_tos_info
 
 #endif /*_IPT_TOS_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index fa97947..27cd7cd 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -63,15 +63,6 @@ config IP_NF_MATCH_IPRANGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_TOS
-	tristate "TOS match support"
-	depends on IP_NF_IPTABLES
-	help
-	  TOS matching allows you to match packets based on the Type Of
-	  Service fields of the IP packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_RECENT
 	tristate "recent match support"
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7456833..c5d906b 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
-obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
 # targets
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
deleted file mode 100644
index e740441..0000000
--- a/net/ipv4/netfilter/ipt_tos.c
+++ /dev/null
@@ -1,55 +0,0 @@
-/* Kernel module to match TOS values. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/ip.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_tos.h>
-#include <linux/netfilter/x_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables TOS match module");
-
-static bool
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      bool *hotdrop)
-{
-	const struct ipt_tos_info *info = matchinfo;
-
-	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
-}
-
-static struct xt_match tos_match __read_mostly = {
-	.name		= "tos",
-	.family		= AF_INET,
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_tos_info),
-	.me		= THIS_MODULE,
-};
-
-static int __init ipt_multiport_init(void)
-{
-	return xt_register_match(&tos_match);
-}
-
-static void __exit ipt_multiport_fini(void)
-{
-	xt_unregister_match(&tos_match);
-}
-
-module_init(ipt_multiport_init);
-module_exit(ipt_multiport_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 607cc8a..0f7af69 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -686,6 +686,16 @@ config NETFILTER_XT_MATCH_TIME
 	  If you want to compile it as a module, say M here.
 	  If unsure, say N.
 
+config NETFILTER_XT_MATCH_TOS
+	tristate '"tos" match support'
+	depends on NETFILTER_XTABLES
+	---help---
+	TOS matching allows you to match packets based on the Type Of
+	Service field of the IPv4 packet or Traffic Class field of
+	the IPv6 packet.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 7763dea..4d40040 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -78,4 +78,5 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TOS) += xt_tos.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
diff --git a/net/netfilter/xt_tos.c b/net/netfilter/xt_tos.c
new file mode 100644
index 0000000..f625cc1
--- /dev/null
+++ b/net/netfilter/xt_tos.c
@@ -0,0 +1,65 @@
+/* Kernel module to match TOS values. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * © 2007 CC Computer Consultants GmbH <jengelh@computergmbh.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tos.h>
+
+static bool
+xt_tos_match(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_tos_info *info = matchinfo;
+
+	if (match->family == AF_INET)
+		return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
+	else
+		return (ipv6_hdr(skb)->priority == info->tos) ^ info->invert;
+}
+
+static struct xt_match xt_tos_reg[] __read_mostly = {
+	{
+		.name      = "tos",
+		.family    = AF_INET,
+		.match     = xt_tos_match,
+		.matchsize = sizeof(struct xt_tos_info),
+		.me        = THIS_MODULE,
+	},
+	{
+		.name      = "tos",
+		.family    = AF_INET6,
+		.match     = xt_tos_match,
+		.matchsize = sizeof(struct xt_tos_info),
+		.me        = THIS_MODULE,
+	},
+};
+
+static int __init xt_tos_init(void)
+{
+	return xt_register_matches(xt_tos_reg, ARRAY_SIZE(xt_tos_reg));
+}
+
+static void __exit xt_tos_exit(void)
+{
+	xt_unregister_matches(xt_tos_reg, ARRAY_SIZE(xt_tos_reg));
+}
+
+module_init(xt_tos_init);
+module_exit(xt_tos_exit);
+MODULE_DESCRIPTION("netfilter \"tos\" match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_tos");
+MODULE_ALIAS("ip6t_tos");

--------------020102030002030308050901--
