From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 11:25:09 +0900 (JST)
Message-ID: <200601200225.k0K2PAVI018072@toshiba.co.jp>
References: <200601160936.k0G9aXWH026971@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Jan_20_11_25_09_2006_682)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200601160936.k0G9aXWH026971@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Fri_Jan_20_11_25_09_2006_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Mon, 16 Jan 2006 18:36:33 +0900 (JST)

> These patches are just for cleanup. I didn't cleanup ip6t_esp.c because
> I have a patch for xt_esp.c. It looks unnecessary to skip IPv6 extension
> headers before ESP in match() if ip6_packet_match() does it.
> After some tests, I'll send it.

Hmm.. we cannot do that without breaking compatibility of ip6t_esp.
Because this forces us to add '-p esp' to ip6tables command. The current
ip6t_esp doesn't require it.

JFYI, I attached a patch for xt_esp I wrote at first time. It's sad to drop it,
but let's keep the current code...
 
-- Yasuyuki Kozakai

----Next_Part(Fri_Jan_20_11_25_09_2006_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="xt_esp.patch"

[NETFILTER] x_tables: add support for ESP match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 341cadc1dc4c6295b8017c8c1596b3b2f220c58f
tree 8c909bf9459905b0534956b3fb73572790afe9ce
parent 7eb9b2f56c9812d03ac63031869bcc42151067b1
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 17 Jan 2006 00:45:14 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 18 Jan 2006 22:16:39 +0900

 include/linux/netfilter/xt_esp.h |   14 +++
 net/ipv4/netfilter/Kconfig       |    8 +-
 net/ipv4/netfilter/Makefile      |    2 
 net/ipv4/netfilter/ipt_esp.c     |  120 ---------------------------
 net/ipv6/netfilter/Kconfig       |    6 +
 net/ipv6/netfilter/Makefile      |    2 
 net/ipv6/netfilter/ip6t_esp.c    |  117 --------------------------
 net/netfilter/Kconfig            |    9 ++
 net/netfilter/Makefile           |    1 
 net/netfilter/xt_esp.c           |  171 ++++++++++++++++++++++++++++++++++++++
 10 files changed, 204 insertions(+), 246 deletions(-)

diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
new file mode 100644
index 0000000..9380fb1
--- /dev/null
+++ b/include/linux/netfilter/xt_esp.h
@@ -0,0 +1,14 @@
+#ifndef _XT_ESP_H
+#define _XT_ESP_H
+
+struct xt_esp
+{
+	u_int32_t spis[2];	/* Security Parameter Index */
+	u_int8_t  invflags;	/* Inverse flags */
+};
+
+/* Values for "invflags" field in struct xt_esp. */
+#define XT_ESP_INV_SPI	0x01	/* Invert the sense of spi. */
+#define XT_ESP_INV_MASK	0x01	/* All possible flags. */
+
+#endif /*_XT_ESP_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db78303..32171f7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -252,12 +252,12 @@ config IP_NF_MATCH_DSCP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_AH_ESP
-	tristate "AH/ESP match support"
+config IP_NF_MATCH_AH
+	tristate "AH match support"
 	depends on IP_NF_IPTABLES
 	help
-	  These two match extensions (`ah' and `esp') allow you to match a
-	  range of SPIs inside AH or ESP headers of IPSec packets.
+	  This match extension allows you to match a range of SPIs
+	  inside AH header of IPSec packets.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index e5c5b32..cebc463 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -54,7 +54,7 @@ obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp.o
-obj-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah.o ipt_esp.o
+obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_POLICY) += ipt_policy.o
diff --git a/net/ipv4/netfilter/ipt_esp.c b/net/ipv4/netfilter/ipt_esp.c
deleted file mode 100644
index 9de191a..0000000
--- a/net/ipv4/netfilter/ipt_esp.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/* Kernel module to match ESP parameters. */
-
-/* (C) 1999-2000 Yon Uriarte <yon@astaro.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-
-#include <linux/netfilter_ipv4/ipt_esp.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
-MODULE_DESCRIPTION("iptables ESP SPI match module");
-
-#ifdef DEBUG_CONNTRACK
-#define duprintf(format, args...) printk(format , ## args)
-#else
-#define duprintf(format, args...)
-#endif
-
-/* Returns 1 if the spi is matched by the range, 0 otherwise */
-static inline int
-spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
-{
-	int r=0;
-        duprintf("esp spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-        	min,spi,max);
-	r=(spi >= min && spi <= max) ^ invert;
-	duprintf(" result %s\n",r? "PASS" : "FAILED");
-	return r;
-}
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	struct ip_esp_hdr _esp, *eh;
-	const struct ipt_esp *espinfo = matchinfo;
-
-	/* Must not be a fragment. */
-	if (offset)
-		return 0;
-
-	eh = skb_header_pointer(skb, protoff,
-				sizeof(_esp), &_esp);
-	if (eh == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("Dropping evil ESP tinygram.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	return spi_match(espinfo->spis[0], espinfo->spis[1],
-			 ntohl(eh->spi),
-			 !!(espinfo->invflags & IPT_ESP_INV_SPI));
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int
-checkentry(const char *tablename,
-	   const void *ip_void,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
-{
-	const struct ipt_esp *espinfo = matchinfo;
-	const struct ipt_ip *ip = ip_void;
-
-	/* Must specify proto == ESP, and no unknown invflags */
-	if (ip->proto != IPPROTO_ESP || (ip->invflags & IPT_INV_PROTO)) {
-		duprintf("ipt_esp: Protocol %u != %u\n", ip->proto,
-			 IPPROTO_ESP);
-		return 0;
-	}
-	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_esp))) {
-		duprintf("ipt_esp: matchsize %u != %u\n",
-			 matchinfosize, IPT_ALIGN(sizeof(struct ipt_esp)));
-		return 0;
-	}
-	if (espinfo->invflags & ~IPT_ESP_INV_MASK) {
-		duprintf("ipt_esp: unknown flags %X\n",
-			 espinfo->invflags);
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct ipt_match esp_match = {
-	.name		= "esp",
-	.match		= &match,
-	.checkentry	= &checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&esp_match);
-}
-
-static void __exit cleanup(void)
-{
-	ipt_unregister_match(&esp_match);
-}
-
-module_init(init);
-module_exit(cleanup);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 2d6f8ec..acee19c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -115,11 +115,11 @@ config IP6_NF_MATCH_IPV6HEADER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_AHESP
-	tristate "AH/ESP match support"
+config IP6_NF_MATCH_AH
+	tristate "AH match support"
 	depends on IP6_NF_IPTABLES
 	help
-	  This module allows one to match AH and ESP packets.
+	  This module allows one to match AH packets.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index db6073c..220d323 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o ip6t_dst.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
-obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o
+obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_POLICY) += ip6t_policy.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
deleted file mode 100644
index 724285d..0000000
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ /dev/null
@@ -1,117 +0,0 @@
-/* Kernel module to match ESP parameters. */
-/* (C) 2001-2002 Andras Kis-Szabo <kisza@sch.bme.hu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/types.h>
-#include <net/checksum.h>
-#include <net/ipv6.h>
-
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_esp.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 ESP match");
-MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-/* Returns 1 if the spi is matched by the range, 0 otherwise */
-static inline int
-spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
-{
-	int r=0;
-	DEBUGP("esp spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-	       min,spi,max);
-	r=(spi >= min && spi <= max) ^ invert;
-	DEBUGP(" result %s\n",r? "PASS\n" : "FAILED\n");
-	return r;
-}
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	struct ip_esp_hdr _esp, *eh;
-	const struct ip6t_esp *espinfo = matchinfo;
-	unsigned int ptr;
-
-	/* Make sure this isn't an evil packet */
-	/*DEBUGP("ipv6_esp entered \n");*/
-
-	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ESP, NULL) < 0)
-		return 0;
-
-	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
-	if (eh == NULL) {
-		*hotdrop = 1;
-		return 0;
-	}
-
-	DEBUGP("IPv6 ESP SPI %u %08X\n", ntohl(eh->spi), ntohl(eh->spi));
-
-	return (eh != NULL)
-		&& spi_match(espinfo->spis[0], espinfo->spis[1],
-			      ntohl(eh->spi),
-			      !!(espinfo->invflags & IP6T_ESP_INV_SPI));
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
-{
-	const struct ip6t_esp *espinfo = matchinfo;
-
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_esp))) {
-		DEBUGP("ip6t_esp: matchsize %u != %u\n",
-			 matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_esp)));
-		return 0;
-	}
-	if (espinfo->invflags & ~IP6T_ESP_INV_MASK) {
-		DEBUGP("ip6t_esp: unknown flags %X\n",
-			 espinfo->invflags);
-		return 0;
-	}
-	return 1;
-}
-
-static struct ip6t_match esp_match = {
-	.name		= "esp",
-	.match		= &match,
-	.checkentry	= &checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ip6t_register_match(&esp_match);
-}
-
-static void __exit cleanup(void)
-{
-	ip6t_unregister_match(&esp_match);
-}
-
-module_init(init);
-module_exit(cleanup);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 99c0a0f..966729f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -233,6 +233,15 @@ config NETFILTER_XT_MATCH_DCCP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_ESP
+	tristate "ESP match support"
+	depends on NETFILTER_XTABLES
+	help
+	  This match extension allows you to match a range of SPIs
+	  inside ESP header of IPSec packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 746172e..bc289e7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTE
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) += xt_length.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) += xt_limit.o
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
new file mode 100644
index 0000000..85910f3
--- /dev/null
+++ b/net/netfilter/xt_esp.c
@@ -0,0 +1,171 @@
+/* Kernel module to match ESP parameters. */
+
+/* (C) 1999-2000 Yon Uriarte <yon@astaro.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+
+#include <linux/netfilter/xt_esp.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
+MODULE_DESCRIPTION("iptables ESP SPI match module");
+MODULE_ALIAS("ipt_esp");
+MODULE_ALIAS("ip6t_esp");
+
+#if 0
+#define duprintf(format, args...) printk(format , ## args)
+#else
+#define duprintf(format, args...)
+#endif
+
+/* Returns 1 if the spi is matched by the range, 0 otherwise */
+static inline int
+spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
+{
+	int r=0;
+        duprintf("esp spi_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
+        	min,spi,max);
+	r=(spi >= min && spi <= max) ^ invert;
+	duprintf(" result %s\n",r? "PASS" : "FAILED");
+	return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	struct ip_esp_hdr _esp, *eh;
+	const struct xt_esp *espinfo = matchinfo;
+
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	eh = skb_header_pointer(skb, protoff, sizeof(_esp), &_esp);
+	if (eh == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("Dropping evil ESP tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return spi_match(espinfo->spis[0], espinfo->spis[1],
+			 ntohl(eh->spi),
+			 !!(espinfo->invflags & XT_ESP_INV_SPI));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+	   const void *ip_void,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
+{
+	const struct xt_esp *espinfo = matchinfo;
+	const struct ipt_ip *ip = ip_void;
+
+	/* Must specify proto == ESP, and no unknown invflags */
+	if (ip->proto != IPPROTO_ESP || (ip->invflags & XT_INV_PROTO)) {
+		duprintf("xt_esp: Protocol %u != %u\n", ip->proto,
+			 IPPROTO_ESP);
+		return 0;
+	}
+	if (matchinfosize != XT_ALIGN(sizeof(struct xt_esp))) {
+		duprintf("xt_esp: matchsize %u != %u\n",
+			 matchinfosize, XT_ALIGN(sizeof(struct xt_esp)));
+		return 0;
+	}
+	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
+		duprintf("xt_esp: unknown flags %X\n", espinfo->invflags);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+checkentry6(const char *tablename,
+	    const void *ip_void,
+	    void *matchinfo,
+	    unsigned int matchinfosize,
+	    unsigned int hook_mask)
+{
+	const struct xt_esp *espinfo = matchinfo;
+	const struct ip6t_ip6 *ip = ip_void;
+
+	/* Must specify proto == ESP, and no unknown invflags */
+	if ((ip->flags & IP6T_F_PROTO) == 0 || ip->proto != IPPROTO_ESP ||
+	    (ip->invflags & XT_INV_PROTO)) {
+		duprintf("xt_esp: Protocol %u != %u\n", ip->proto,
+			 IPPROTO_ESP);
+		return 0;
+	}
+	if (matchinfosize != XT_ALIGN(sizeof(struct xt_esp))) {
+		duprintf("xt_esp: matchsize %u != %u\n",
+			 matchinfosize, XT_ALIGN(sizeof(struct xt_esp)));
+		return 0;
+	}
+	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
+		duprintf("xt_esp: unknown flags %X\n", espinfo->invflags);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_match esp_match = {
+	.name		= "esp",
+	.match		= &match,
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match esp6_match = {
+	.name		= "esp",
+	.match		= &match,
+	.checkentry	= &checkentry6,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret = xt_register_match(AF_INET, &esp_match);
+	if (ret)
+		return ret;
+
+	ret = xt_register_match(AF_INET6, &esp6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &esp_match);
+
+	return ret;
+}
+
+static void __exit cleanup(void)
+{
+	xt_unregister_match(AF_INET, &esp_match);
+	xt_unregister_match(AF_INET6, &esp6_match);
+}
+
+module_init(init);
+module_exit(cleanup);

----Next_Part(Fri_Jan_20_11_25_09_2006_682)----
