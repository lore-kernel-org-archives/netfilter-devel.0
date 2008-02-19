From: "Tseng, Kuo-Lang" <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Add IPv6 support
Date: Mon, 18 Feb 2008 18:05:01 -0800
Message-ID: <3F25FE8C477E9E4FB3D42C2FF937C08A8D090D@orsmsx423.amr.corp.intel.com>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net>
	<3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com>
	<3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com>
	<1201303354.2909.1.camel@localhost.localdomain>
	<3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>,
	ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.0802070130120.23855-vVwEwcwQeYFPkBl3ERsXe1l1cybopEuJUBSOeVevoDU@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

This is the corresponding br-netfilter patch. 

It implements matching functions for IPv6 address & traffic class
(merged from the patch sent by Jan Engelhardt [jengelh-bdq14YP6qtRlEiWPh9xO2Q@public.gmane.org]
http://marc.info/?l=netfilter-devel&m=120182168424052&w=2), protocol,
and layer-4 port id. Corresponding watcher logging function is also
added for IPv6. 

Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



diff -ruNp a/include/linux/netfilter_bridge/ebt_ip6.h
b/include/linux/netfilter_bridge/ebt_ip6.h
--- a/include/linux/netfilter_bridge/ebt_ip6.h	1969-12-31
16:00:00.000000000 -0800
+++ b/include/linux/netfilter_bridge/ebt_ip6.h	2008-02-18
16:34:57.000000000 -0800
@@ -0,0 +1,40 @@
+/*
+ *  ebt_ip6
+ *
+ *	Authors:
+ * Kuo-Lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ * Manohar Castelino <manohar.r.castelino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *
+ *  Jan 11, 2008
+ *
+ */
+
+#ifndef __LINUX_BRIDGE_EBT_IP6_H
+#define __LINUX_BRIDGE_EBT_IP6_H
+
+#define EBT_IP6_SOURCE 0x01
+#define EBT_IP6_DEST 0x02
+#define EBT_IP6_TCLASS 0x04
+#define EBT_IP6_PROTO 0x08
+#define EBT_IP6_SPORT 0x10
+#define EBT_IP6_DPORT 0x20
+#define EBT_IP6_MASK (EBT_IP6_SOURCE | EBT_IP6_DEST | EBT_IP6_TCLASS |\
+ EBT_IP6_PROTO | EBT_IP6_SPORT | EBT_IP6_DPORT )
+#define EBT_IP6_MATCH "ip6"
+
+/* the same values are used for the invflags */
+struct ebt_ip6_info
+{
+	struct in6_addr saddr;
+	struct in6_addr daddr;
+	struct in6_addr smsk;
+	struct in6_addr dmsk;
+	uint8_t  tclass;
+	uint8_t  protocol;
+	uint8_t  bitmask;
+	uint8_t  invflags;
+	uint16_t sport[2];
+	uint16_t dport[2];
+};
+
+#endif
diff -ruNp a/include/linux/netfilter_bridge/ebt_log.h
b/include/linux/netfilter_bridge/ebt_log.h
--- a/include/linux/netfilter_bridge/ebt_log.h	2008-02-18
16:32:34.000000000 -0800
+++ b/include/linux/netfilter_bridge/ebt_log.h	2008-02-18
16:34:57.000000000 -0800
@@ -4,7 +4,8 @@
 #define EBT_LOG_IP 0x01 /* if the frame is made by ip, log the ip
information */
 #define EBT_LOG_ARP 0x02
 #define EBT_LOG_NFLOG 0x04
-#define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP)
+#define EBT_LOG_IP6 0x08
+#define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP | EBT_LOG_IP6)
 #define EBT_LOG_PREFIX_SIZE 30
 #define EBT_LOG_WATCHER "log"
 
diff -ruNp a/net/bridge/netfilter/ebt_ip6.c
b/net/bridge/netfilter/ebt_ip6.c
--- a/net/bridge/netfilter/ebt_ip6.c	1969-12-31 16:00:00.000000000
-0800
+++ b/net/bridge/netfilter/ebt_ip6.c	2008-02-18 16:26:59.000000000
-0800
@@ -0,0 +1,141 @@
+/*
+ *  ebt_ip6
+ *
+ *	Authors:
+ *	Manohar Castelino <manohar.r.castelino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *	Kuo-Lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *	Jan Engelhardt <jengelh-bdq14YP6qtRlEiWPh9xO2Q@public.gmane.org>
+ *
+ * Summary:
+ * This is just a modification of the IPv4 code written by 
+ * Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
+ * with the changes required to support IPv6
+ *
+ *  Jan, 2008
+ */
+
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_ip6.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <linux/in.h>
+#include <linux/module.h>
+#include <net/dsfield.h>
+
+struct tcpudphdr {
+	uint16_t src;
+	uint16_t dst;
+};
+
+static int ebt_filter_ip6(const struct sk_buff *skb, const struct
net_device *in,
+   const struct net_device *out, const void *data,
+   unsigned int datalen)
+{
+	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
+	struct ipv6hdr _ip6h, *ih6;
+	struct in6_addr tmp_addr;
+	int i;
+
+	ih6 = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
+	if (ih6 == NULL)
+		return EBT_NOMATCH;
+	if (info->bitmask & EBT_IP6_TCLASS &&
+	   FWINV(info->tclass != ipv6_get_dsfield(ih6), EBT_IP6_TCLASS))
+		return EBT_NOMATCH;
+	for (i = 0; i < 4; i++)
+	   tmp_addr.in6_u.u6_addr32[i] = ih6->saddr.in6_u.u6_addr32[i] &

+			info->smsk.in6_u.u6_addr32[i];
+	if (info->bitmask & EBT_IP6_SOURCE &&
+	   FWINV((ipv6_addr_cmp(&tmp_addr, &info->saddr) != 0),
EBT_IP6_SOURCE))
+		return EBT_NOMATCH;
+	for (i = 0; i < 4; i++)
+	   tmp_addr.in6_u.u6_addr32[i] = ih6->daddr.in6_u.u6_addr32[i] &

+			info->dmsk.in6_u.u6_addr32[i];
+	if (info->bitmask & EBT_IP6_DEST &&
+	   FWINV((ipv6_addr_cmp(&tmp_addr, &info->daddr) != 0),
EBT_IP6_DEST))
+		return EBT_NOMATCH;
+	if (info->bitmask & EBT_IP6_PROTO) {
+		struct tcpudphdr _phdr, *pptr;
+		uint8_t *nexthdrp = &ih6->nexthdr;
+		int offset_ph;
+
+		offset_ph = ipv6_skip_exthdr(skb, sizeof(_ip6h),
nexthdrp);
+		if (offset_ph == -1)
+			return EBT_NOMATCH;
+		if (FWINV(info->protocol != *nexthdrp, EBT_IP6_PROTO))
+			return EBT_NOMATCH;
+
+		if (!(info->bitmask & EBT_IP6_DPORT) &&
+			!(info->bitmask & EBT_IP6_SPORT))
+			return EBT_MATCH;
+		pptr = skb_header_pointer(skb, offset_ph, sizeof(_phdr),
&_phdr);
+		if (pptr == NULL)
+			return EBT_NOMATCH;
+		if (info->bitmask & EBT_IP6_DPORT) {
+			u32 dst = ntohs(pptr->dst);
+			if (FWINV(dst < info->dport[0] ||
+			          dst > info->dport[1],
+			          EBT_IP6_DPORT))
+				return EBT_NOMATCH;
+		}
+		if (info->bitmask & EBT_IP6_SPORT) {
+			u32 src = ntohs(pptr->src);
+			if (FWINV(src < info->sport[0] ||
+			          src > info->sport[1],
+			          EBT_IP6_SPORT))
+			return EBT_NOMATCH;
+		}
+		return EBT_MATCH;
+	}
+	return EBT_MATCH;
+}
+
+static int ebt_ip6_check(const char *tablename, unsigned int hookmask,
+   const struct ebt_entry *e, void *data, unsigned int datalen)
+{
+	struct ebt_ip6_info *info = (struct ebt_ip6_info *)data;
+
+	if (datalen != EBT_ALIGN(sizeof(struct ebt_ip6_info)))
+		return -EINVAL;
+	if (e->ethproto != htons(ETH_P_IPV6) ||
+	   e->invflags & EBT_IPROTO)
+		return -EINVAL;
+	if (info->bitmask & ~EBT_IP6_MASK || info->invflags &
~EBT_IP6_MASK)
+		return -EINVAL;
+	if (info->bitmask & (EBT_IP6_DPORT | EBT_IP6_SPORT)) {
+		if (info->invflags & EBT_IP6_PROTO)
+			return -EINVAL;
+		if (info->protocol != IPPROTO_TCP &&
+		    info->protocol != IPPROTO_UDP &&
+		    info->protocol != IPPROTO_SCTP &&
+		    info->protocol != IPPROTO_DCCP)
+			 return -EINVAL;
+	}
+	if (info->bitmask & EBT_IP6_DPORT && info->dport[0] >
info->dport[1])
+		return -EINVAL;
+	if (info->bitmask & EBT_IP6_SPORT && info->sport[0] >
info->sport[1])
+		return -EINVAL;
+	return 0;
+}
+
+static struct ebt_match filter_ip6 =
+{
+	.name		= EBT_IP6_MATCH,
+	.match		= ebt_filter_ip6,
+	.check		= ebt_ip6_check,
+	.me		= THIS_MODULE,
+};
+
+static int __init ebt_ip6_init(void)
+{
+	return ebt_register_match(&filter_ip6);
+}
+
+static void __exit ebt_ip6_fini(void)
+{
+	ebt_unregister_match(&filter_ip6);
+}
+
+module_init(ebt_ip6_init);
+module_exit(ebt_ip6_fini);
+MODULE_LICENSE("GPL");
diff -ruNp a/net/bridge/netfilter/ebt_log.c
b/net/bridge/netfilter/ebt_log.c
--- a/net/bridge/netfilter/ebt_log.c	2008-02-18 16:26:37.000000000
-0800
+++ b/net/bridge/netfilter/ebt_log.c	2008-02-18 16:26:58.000000000
-0800
@@ -18,6 +18,8 @@
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/spinlock.h>
+#include <linux/ipv6.h>
+#include <linux/in6.h>
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
@@ -112,6 +114,43 @@ ebt_log_packet(unsigned int pf, unsigned
 		goto out;
 	}
 
+	if ((bitmask & EBT_LOG_IP6) && eth_hdr(skb)->h_proto ==
+	   htons(ETH_P_IPV6)){
+		struct ipv6hdr _iph, *ih;
+		uint8_t *nexthdrp;
+		int offset_ph;
+
+		ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
+		if (ih == NULL) {
+			printk(" INCOMPLETE IPv6 header");
+			goto out;
+		}
+		printk(" IPv6 SRC=%x:%x:%x:%x:%x:%x:%x:%x "
+		       "IPv6 DST=%x:%x:%x:%x:%x:%x:%x:%x, IPv6 "
+		       "priority=0x%01X, Next Header=%d",
NIP6(ih->saddr),
+		       NIP6(ih->daddr), ih->priority, ih->nexthdr);
+		nexthdrp = &ih->nexthdr;
+		offset_ph = ipv6_skip_exthdr(skb, sizeof(_iph),
nexthdrp);
+		if (offset_ph == -1)
+			goto out;
+		if (*nexthdrp == IPPROTO_TCP ||
+		    *nexthdrp == IPPROTO_UDP ||
+		    *nexthdrp == IPPROTO_SCTP ||
+		    *nexthdrp == IPPROTO_DCCP) {
+			struct tcpudphdr _ports, *pptr;
+
+			pptr = skb_header_pointer(skb, offset_ph, 
+						  sizeof(_ports),
&_ports);
+			if (pptr == NULL) {
+				printk(" INCOMPLETE TCP/UDP header");
+				goto out;
+			}
+			printk(" SPT=%u DPT=%u", ntohs(pptr->src),
+			   ntohs(pptr->dst));
+		}
+		goto out;
+	}
+
 	if ((bitmask & EBT_LOG_ARP) &&
 	    ((eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) ||
 	     (eth_hdr(skb)->h_proto == htons(ETH_P_RARP)))) {
diff -ruNp a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
--- a/net/bridge/netfilter/Kconfig	2008-02-18 16:26:37.000000000
-0800
+++ b/net/bridge/netfilter/Kconfig	2008-02-18 16:26:58.000000000
-0800
@@ -83,6 +83,15 @@ config BRIDGE_EBT_IP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config BRIDGE_EBT_IP6
+	tristate "ebt: IP6 filter support"
+	depends on BRIDGE_NF_EBTABLES
+	help
+	  This option adds the IP6 match, which allows basic IPV6 header
field
+	  filtering.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config BRIDGE_EBT_LIMIT
 	tristate "ebt: limit match support"
 	depends on BRIDGE_NF_EBTABLES
diff -ruNp a/net/bridge/netfilter/Makefile
b/net/bridge/netfilter/Makefile
--- a/net/bridge/netfilter/Makefile	2008-02-18 16:26:37.000000000
-0800
+++ b/net/bridge/netfilter/Makefile	2008-02-18 16:26:59.000000000
-0800
@@ -14,6 +14,7 @@ obj-$(CONFIG_BRIDGE_EBT_802_3) += ebt_80
 obj-$(CONFIG_BRIDGE_EBT_AMONG) += ebt_among.o
 obj-$(CONFIG_BRIDGE_EBT_ARP) += ebt_arp.o
 obj-$(CONFIG_BRIDGE_EBT_IP) += ebt_ip.o
+obj-$(CONFIG_BRIDGE_EBT_IP6) += ebt_ip6.o
 obj-$(CONFIG_BRIDGE_EBT_LIMIT) += ebt_limit.o
 obj-$(CONFIG_BRIDGE_EBT_MARK) += ebt_mark_m.o
 obj-$(CONFIG_BRIDGE_EBT_PKTTYPE) += ebt_pkttype.o

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
