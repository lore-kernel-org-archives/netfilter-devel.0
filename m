From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: .26: Deploy a prefix length to network mask mapping table
Date: Thu, 20 Mar 2008 16:06:22 +0100 (CET)
Message-ID: <alpine.LNX.1.00.0803201600290.10642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48855 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYCTPGY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:06:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Since I see it unlikely that the memory reduction patch will still find 
its way into 2.6.25, the following patch I propose for review for 
2.6.26.


commit 55d5fcc7c810901104feb3edd1283ea76694c7ae
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 21 16:33:32 2008 +0100

     [NETFILTER]: Deploy a prefix length to network mask mapping table

     Userspace utilities commonly transform a prefix length (CIDR notation
     like 192.168.222.1/32) into a full netmask before submitting it to
     the kernel.

     The size of struct xt_conntrack_mtinfo1 is currently 152 bytes, of
     which 64 bytes are for masks. By submitting prefix lengths to the
     kernel instead, 60 bytes (almost 40%) memory per rule can be saved as
     prefix lengths can fit into one uint8_t. Since we do not want to
     recompute the mask for each invocation of the match function, a
     static translation table will be used (net/core/pfxlen.c).

     The patch changes xt_conntrack revision 1 into revision 2.
     Userspace can easily fall back to revision 0.
     The patch also removes xt_hashlimit's obsolete mask computation.

     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index f3fd83e..79540e6 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -67,17 +67,19 @@ struct xt_conntrack_info
  	u_int8_t invflags;
  };

-struct xt_conntrack_mtinfo1 {
-	union nf_inet_addr origsrc_addr, origsrc_mask;
-	union nf_inet_addr origdst_addr, origdst_mask;
-	union nf_inet_addr replsrc_addr, replsrc_mask;
-	union nf_inet_addr repldst_addr, repldst_mask;
+struct xt_conntrack_mtinfo2 {
+	union nf_inet_addr origsrc_addr;
+	union nf_inet_addr origdst_addr;
+	union nf_inet_addr replsrc_addr;
+	union nf_inet_addr repldst_addr;
  	u_int32_t expires_min, expires_max;
  	u_int16_t l4proto;
  	__be16 origsrc_port, origdst_port;
  	__be16 replsrc_port, repldst_port;
  	u_int16_t match_flags, invert_flags;
  	u_int8_t state_mask, status_mask;
+	u_int8_t origsrc_pfx, origdst_pfx;
+	u_int8_t replsrc_pfx, repldst_pfx;
  };

  #endif /*_XT_CONNTRACK_H*/
diff --git a/include/net/pfxlen.h b/include/net/pfxlen.h
new file mode 100644
index 0000000..203a494
--- /dev/null
+++ b/include/net/pfxlen.h
@@ -0,0 +1,8 @@
+#ifndef _NET_PFXLEN_H
+#define _NET_PFXLEN_H 1
+
+#include <linux/netfilter.h>
+
+extern union nf_inet_addr prefixlen_netmask_map[];
+
+#endif /* _NET_PFXLEN_H */
diff --git a/net/Kconfig b/net/Kconfig
index acbf7c6..c355f08 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -27,6 +27,12 @@ if NET

  menu "Networking options"

+config NET_PFXLEN
+	tristate
+	---help---
+	This option adds a translation table from prefix length to
+	expanded netmasks (e.g. /28 => 255.255.255.240)
+
  config NET_NS
  	bool "Network namespace support"
  	default n
diff --git a/net/core/Makefile b/net/core/Makefile
index b1332f6..cc818dd 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_NET_PKTGEN) += pktgen.o
  obj-$(CONFIG_NETPOLL) += netpoll.o
  obj-$(CONFIG_NET_DMA) += user_dma.o
  obj-$(CONFIG_FIB_RULES) += fib_rules.o
+obj-$(CONFIG_NET_PFXLEN) += pfxlen.o
diff --git a/net/core/pfxlen.c b/net/core/pfxlen.c
new file mode 100644
index 0000000..5667c03
--- /dev/null
+++ b/net/core/pfxlen.c
@@ -0,0 +1,146 @@
+#include <linux/netfilter.h>
+
+#define E(a, b, c, d) \
+	{.ip6 = { \
+		__constant_htonl(a), __constant_htonl(b), \
+		__constant_htonl(c), __constant_htonl(d), \
+	}}
+
+/*
+ * This table works for both IPv4 and IPv6;
+ * just use prefixlen_netmask_map[prefixlength].ip.
+ */
+const union nf_inet_addr prefixlen_netmask_map[] = {
+	E(0x00000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0x80000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xC0000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xE0000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xF0000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xF8000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFC000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFE000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFF000000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFF800000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFC00000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFE00000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFF00000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFF80000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFC0000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFE0000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFF0000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFF8000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFC000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFE000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFF000, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFF800, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFC00, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFE00, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFF00, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFF80, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFC0, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFE0, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFF0, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFF8, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFC, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFE, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0x80000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xC0000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xE0000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xF0000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xF8000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFC000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFE000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFF000000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFF800000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFC00000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFE00000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFF00000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFF80000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFC0000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFE0000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFF0000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFF8000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFC000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFE000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFF000, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFF800, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFC00, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFE00, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFF00, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFF80, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFC0, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFE0, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFF0, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFF8, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFC, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFE, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0x80000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xC0000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xE0000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xF0000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xF8000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFC000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFE000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFF800000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFC00000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFE00000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFF00000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFF80000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFC0000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFE0000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF0000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF8000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFC000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFE000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF000, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF800, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFC00, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFE00, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFF00, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFF80, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFC0, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFE0, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFF0, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFF8, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFC, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x80000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xC0000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xE0000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xF0000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xF8000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFC000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFE000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFF800000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFC00000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFE00000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFF00000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFF80000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFC0000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFE0000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF0000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF8000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFC000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFE000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF000),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFF800),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFC00),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFE00),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFF00),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFF80),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFC0),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFE0),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFF0),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFF8),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFC),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE),
+	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF),
+};
+EXPORT_SYMBOL(prefixlen_netmask_map);
+
+MODULE_LICENSE("GPL");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 222aa07..c1a7ea4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -27,6 +27,7 @@ config NETFILTER_NETLINK_LOG
  config NF_CONNTRACK
  	tristate "Netfilter connection tracking support"
  	default m if NETFILTER_ADVANCED=n
+	select NET_PFXLEN
  	help
  	  Connection tracking keeps a record of what packets have passed
  	  through your machine, in order to figure out how they are related
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index f0e0fce..5b6dc74 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -13,6 +13,7 @@
  #include <linux/module.h>
  #include <linux/skbuff.h>
  #include <net/ipv6.h>
+#include <net/pfxlen.h>
  #include <linux/netfilter/x_tables.h>
  #include <linux/netfilter/xt_conntrack.h>
  #include <net/netfilter/nf_conntrack.h>
@@ -136,7 +137,8 @@ conntrack_mt_origsrc(const struct nf_conn *ct,
                       unsigned int family)
  {
  	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3,
-	       &info->origsrc_addr, &info->origsrc_mask, family);
+	       &info->origsrc_addr, &prefixlen_netmask_map[info->origsrc_pfx],
+	       family);
  }

  static inline bool
@@ -145,7 +147,8 @@ conntrack_mt_origdst(const struct nf_conn *ct,
                       unsigned int family)
  {
  	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3,
-	       &info->origdst_addr, &info->origdst_mask, family);
+	       &info->origdst_addr, &prefixlen_netmask_map[info->origdst_pfx],
+	       family);
  }

  static inline bool
@@ -154,7 +157,8 @@ conntrack_mt_replsrc(const struct nf_conn *ct,
                       unsigned int family)
  {
  	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3,
-	       &info->replsrc_addr, &info->replsrc_mask, family);
+	       &info->replsrc_addr, &prefixlen_netmask_map[info->replsrc_pfx],
+	       family);
  }

  static inline bool
@@ -163,7 +167,8 @@ conntrack_mt_repldst(const struct nf_conn *ct,
                       unsigned int family)
  {
  	return conntrack_addrcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3,
-	       &info->repldst_addr, &info->repldst_mask, family);
+	       &info->repldst_addr, &prefixlen_netmask_map[info->repldst_pfx],
+	       family);
  }

  static inline bool
@@ -292,6 +297,16 @@ conntrack_mt_check(const char *tablename, const void *ip,
                     const struct xt_match *match, void *matchinfo,
                     unsigned int hook_mask)
  {
+	const struct xt_conntrack_mtinfo1 *info = matchinfo;
+
+	if (match->family == AF_INET && (info->origsrc_pfx > 32 ||
+	    info->origdst_pfx > 32 || info->replsrc_pfx > 32 ||
+	    info->repldst_pfx > 32))
+		return false;
+	if (match->family == AF_INET6 && (info->origsrc_pfx > 128 ||
+	    info->origdst_pfx > 128 || info->replsrc_pfx > 128 ||
+	    info->repldst_pfx > 128))
+		return false;
  	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
  		printk(KERN_WARNING "can't load conntrack support for "
  				    "proto=%u\n", match->family);
@@ -373,9 +388,9 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
  	},
  	{
  		.name       = "conntrack",
-		.revision   = 1,
+		.revision   = 2,
  		.family     = AF_INET,
-		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
+		.matchsize  = sizeof(struct xt_conntrack_mtinfo2),
  		.match      = conntrack_mt,
  		.checkentry = conntrack_mt_check,
  		.destroy    = conntrack_mt_destroy,
@@ -383,9 +398,9 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
  	},
  	{
  		.name       = "conntrack",
-		.revision   = 1,
+		.revision   = 2,
  		.family     = AF_INET6,
-		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
+		.matchsize  = sizeof(struct xt_conntrack_mtinfo2),
  		.match      = conntrack_mt,
  		.checkentry = conntrack_mt_check,
  		.destroy    = conntrack_mt_destroy,
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5418ce5..c3ade12 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -26,6 +26,7 @@
  #endif

  #include <net/net_namespace.h>
+#include <net/pfxlen.h>

  #include <linux/netfilter/x_tables.h>
  #include <linux/netfilter_ipv4/ip_tables.h>
@@ -466,43 +467,18 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)

  static inline __be32 maskl(__be32 a, unsigned int l)
  {
-	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
+	return a & prefixlen_netmask_map[l].ip;
  }

  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
  static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
  {
-	switch (p) {
-	case 0:
-		i[0] = i[1] = 0;
-		i[2] = i[3] = 0;
-		break;
-	case 1 ... 31:
-		i[0] = maskl(i[0], p);
-		i[1] = i[2] = i[3] = 0;
-		break;
-	case 32:
-		i[1] = i[2] = i[3] = 0;
-		break;
-	case 33 ... 63:
-		i[1] = maskl(i[1], p - 32);
-		i[2] = i[3] = 0;
-		break;
-	case 64:
-		i[2] = i[3] = 0;
-		break;
-	case 65 ... 95:
-		i[2] = maskl(i[2], p - 64);
-		i[3] = 0;
-	case 96:
-		i[3] = 0;
-		break;
-	case 97 ... 127:
-		i[3] = maskl(i[3], p - 96);
-		break;
-	case 128:
-		break;
-	}
+	const union nf_inet_addr *mask = &prefixlen_netmask_map[p];
+
+	i[0] &= mask->ip6[0];
+	i[1] &= mask->ip6[1];
+	i[2] &= mask->ip6[2];
+	i[3] &= mask->ip6[3];
  }
  #endif


