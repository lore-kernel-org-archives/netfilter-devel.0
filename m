From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/04]: Netfilter Update
Date: Fri, 31 Mar 2006 12:28:56 +0200
Message-ID: <442D0468.7080300@trash.net>
References: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
	<20060331.021518.94936868.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050005060003050007000708"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060331.021518.94936868.davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------050005060003050007000708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 31 Mar 2006 03:09:05 +0200 (MEST)
> 
> 
>>Yasuyuki Kozakai:
>>      [NETFILTER]: x_tables: unify IPv4/IPv6 multiport match
> 
> 
> This first patch didn't apply, so I'm going to pass on all of these
> until you figure out what's wrong here.
> 
> The problem is the net/ipv6/netfilter/Makefile hunk.
> 
> @@ -10,7 +10,6 @@ obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=
>  obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
>  obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
>  obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
> -obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
> 
> in my current tree the ip6t_ah.o line instead reads as:
> 
> obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o
> 
> It seems something is wrong with the tree you generated these
> patches against.
> 
> Please resubmit once you've fixed this, thanks.

Sorry, I accidentally missed the first patch. I've attached it to
this mail, with it the patches apply cleanly against the current tree.
If you want me to resubmit the entire set anyway please say so.
Thanks.


--------------050005060003050007000708
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: x_tables: unify IPv4/IPv6 esp match

This unifies ipt_esp and ip6t_esp to xt_esp. Please note that now
a user program needs to specify IPPROTO_ESP as protocol to use esp match
with IPv6. This means that ip6tables requires '-p esp' like iptables.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6b0b3ab9f047358723d8b3116b71318f64088a1a
tree 0e8d7dcd24ee91e251d8451a7dec51eed50ea338
parent 91b9a1a505eb4b947318aaba4aed65fec9ccc88b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 29 Mar 2006 10:05:53 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 29 Mar 2006 10:05:53 +0200

 include/linux/netfilter/xt_esp.h        |   14 +++
 include/linux/netfilter_ipv4/ipt_esp.h  |   14 +--
 include/linux/netfilter_ipv6/ip6t_esp.h |   12 +--
 net/ipv4/netfilter/Kconfig              |    8 +-
 net/ipv4/netfilter/Makefile             |    2 
 net/ipv4/netfilter/ipt_esp.c            |  111 -------------------------
 net/ipv6/netfilter/Kconfig              |    6 +
 net/ipv6/netfilter/Makefile             |    2 
 net/ipv6/netfilter/ip6t_esp.c           |  115 --------------------------
 net/netfilter/Kconfig                   |    9 ++
 net/netfilter/Makefile                  |    1 
 net/netfilter/xt_esp.c                  |  136 +++++++++++++++++++++++++++++++
 12 files changed, 177 insertions(+), 253 deletions(-)

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
diff --git a/include/linux/netfilter_ipv4/ipt_esp.h b/include/linux/netfilter_ipv4/ipt_esp.h
index c782a83..78296e7 100644
--- a/include/linux/netfilter_ipv4/ipt_esp.h
+++ b/include/linux/netfilter_ipv4/ipt_esp.h
@@ -1,16 +1,10 @@
 #ifndef _IPT_ESP_H
 #define _IPT_ESP_H
 
-struct ipt_esp
-{
-	u_int32_t spis[2];			/* Security Parameter Index */
-	u_int8_t  invflags;			/* Inverse flags */
-};
+#include <linux/netfilter/xt_esp.h>
 
-
-
-/* Values for "invflags" field in struct ipt_esp. */
-#define IPT_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
-#define IPT_ESP_INV_MASK	0x01	/* All possible flags. */
+#define ipt_esp xt_esp
+#define IPT_ESP_INV_SPI		XT_ESP_INV_SPI
+#define IPT_ESP_INV_MASK	XT_ESP_INV_MASK
 
 #endif /*_IPT_ESP_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_esp.h b/include/linux/netfilter_ipv6/ip6t_esp.h
index a91b6ab..f62eaf5 100644
--- a/include/linux/netfilter_ipv6/ip6t_esp.h
+++ b/include/linux/netfilter_ipv6/ip6t_esp.h
@@ -1,14 +1,10 @@
 #ifndef _IP6T_ESP_H
 #define _IP6T_ESP_H
 
-struct ip6t_esp
-{
-	u_int32_t spis[2];			/* Security Parameter Index */
-	u_int8_t  invflags;			/* Inverse flags */
-};
+#include <linux/netfilter/xt_esp.h>
 
-/* Values for "invflags" field in struct ip6t_esp. */
-#define IP6T_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
-#define IP6T_ESP_INV_MASK	0x01	/* All possible flags. */
+#define ip6t_esp xt_esp
+#define IP6T_ESP_INV_SPI	XT_ESP_INV_SPI
+#define IP6T_ESP_INV_MASK	XT_ESP_INV_MASK
 
 #endif /*_IP6T_ESP_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 882b842..ebbd644 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -272,12 +272,12 @@ config IP_NF_MATCH_DSCP
 
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
index f2cd9a6..09ae167 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) += ipt_dscp.o
-obj-$(CONFIG_IP_NF_MATCH_AH_ESP) += ipt_ah.o ipt_esp.o
+obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 
diff --git a/net/ipv4/netfilter/ipt_esp.c b/net/ipv4/netfilter/ipt_esp.c
deleted file mode 100644
index 3840b41..0000000
--- a/net/ipv4/netfilter/ipt_esp.c
+++ /dev/null
@@ -1,111 +0,0 @@
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
-      const struct xt_match *match,
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
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
-{
-	const struct ipt_esp *espinfo = matchinfo;
-
-	/* Must specify no unknown invflags */
-	if (espinfo->invflags & ~IPT_ESP_INV_MASK) {
-		duprintf("ipt_esp: unknown flags %X\n", espinfo->invflags);
-		return 0;
-	}
-	return 1;
-}
-
-static struct ipt_match esp_match = {
-	.name		= "esp",
-	.match		= match,
-	.matchsize	= sizeof(struct ipt_esp),
-	.proto		= IPPROTO_ESP,
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init ipt_esp_init(void)
-{
-	return ipt_register_match(&esp_match);
-}
-
-static void __exit ipt_esp_fini(void)
-{
-	ipt_unregister_match(&esp_match);
-}
-
-module_init(ipt_esp_init);
-module_exit(ipt_esp_fini);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 98f7875..bdd569f 100644
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
index 8436a1a..c387170 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o ip6t_dst.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
-obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o
+obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) += ip6t_owner.o
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
deleted file mode 100644
index 36bedad..0000000
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ /dev/null
@@ -1,115 +0,0 @@
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
-      const struct xt_match *match,
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
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchinfosize,
-	   unsigned int hook_mask)
-{
-	const struct ip6t_esp *espinfo = matchinfo;
-
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
-	.match		= match,
-	.matchsize	= sizeof(struct ip6t_esp),
-	.checkentry	= checkentry,
-	.me		= THIS_MODULE,
-};
-
-static int __init ip6t_esp_init(void)
-{
-	return ip6t_register_match(&esp_match);
-}
-
-static void __exit ip6t_esp_fini(void)
-{
-	ip6t_unregister_match(&esp_match);
-}
-
-module_init(ip6t_esp_init);
-module_exit(ip6t_esp_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 332acb3..5fe5189 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -231,6 +231,15 @@ config NETFILTER_XT_MATCH_DCCP
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_ESP
+	tristate '"ESP" match support'
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
index 9558727..8f02486 100644
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
index 0000000..9dad628
--- /dev/null
+++ b/net/netfilter/xt_esp.c
@@ -0,0 +1,136 @@
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
+MODULE_DESCRIPTION("x_tables ESP SPI match module");
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
+	int r = 0;
+	duprintf("esp spi_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
+		 min, spi, max);
+	r = (spi >= min && spi <= max) ^ invert;
+	duprintf(" result %s\n", r ? "PASS" : "FAILED");
+	return r;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
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
+	return spi_match(espinfo->spis[0], espinfo->spis[1], ntohl(eh->spi),
+			 !!(espinfo->invflags & XT_ESP_INV_SPI));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+checkentry(const char *tablename,
+	   const void *ip_void,
+	   const struct xt_match *match,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
+{
+	const struct xt_esp *espinfo = matchinfo;
+
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
+	.family		= AF_INET,
+	.proto		= IPPROTO_ESP,
+	.match		= &match,
+	.matchsize	= sizeof(struct xt_esp),
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match esp6_match = {
+	.name		= "esp",
+	.family		= AF_INET6,
+	.proto		= IPPROTO_ESP,
+	.match		= &match,
+	.matchsize	= sizeof(struct xt_esp),
+	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_esp_init(void)
+{
+	int ret;
+	ret = xt_register_match(&esp_match);
+	if (ret)
+		return ret;
+
+	ret = xt_register_match(&esp6_match);
+	if (ret)
+		xt_unregister_match(&esp_match);
+
+	return ret;
+}
+
+static void __exit xt_esp_cleanup(void)
+{
+	xt_unregister_match(&esp_match);
+	xt_unregister_match(&esp6_match);
+}
+
+module_init(xt_esp_init);
+module_exit(xt_esp_cleanup);

--------------050005060003050007000708--
