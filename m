From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/15]: ip6_tables: support MH match
Date: Wed,  7 Feb 2007 09:23:06 +0100 (MET)
Message-ID: <20070207082305.27478.45854.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_tables: support MH match

This introduces match for Mobility Header (MH) described by Mobile IPv6
specification (RFC3775). User can specify the MH type or its range to be
matched.

Signed-off-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
Signed-off-by: Yasuyuki Kozakai <kozakai@linux-ipv6.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5a5812610d318df713ca8b2a63894ceafc503441
tree 98373ccceea06243d766d69903005fa6448cadb9
parent 23ef10d3c0fcfacd86d3e566ba55504ea6de8a74
author Masahide NAKAMURA <nakam@linux-ipv6.org> Tue, 06 Feb 2007 07:37:08 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:13 +0100

 include/linux/netfilter_ipv6/ip6t_mh.h |   15 ++++
 net/ipv6/netfilter/Kconfig             |    8 ++
 net/ipv6/netfilter/Makefile            |    1 
 net/ipv6/netfilter/ip6t_mh.c           |  108 ++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6t_mh.h b/include/linux/netfilter_ipv6/ip6t_mh.h
new file mode 100644
index 0000000..b9ca9a5
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_mh.h
@@ -0,0 +1,15 @@
+#ifndef _IP6T_MH_H
+#define _IP6T_MH_H
+
+/* MH matching stuff */
+struct ip6t_mh
+{
+	u_int8_t types[2];	/* MH type range */
+	u_int8_t invflags;	/* Inverse flags */
+};
+
+/* Values for "invflags" field in struct ip6t_mh. */
+#define IP6T_MH_INV_TYPE	0x01	/* Invert the sense of type. */
+#define IP6T_MH_INV_MASK	0x01	/* All possible flags. */
+
+#endif /*_IP6T_MH_H*/
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index adcd613..cd549ae 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -114,6 +114,14 @@ config IP6_NF_MATCH_AH
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_MH
+	tristate "MH match support"
+	depends on IP6_NF_IPTABLES
+	help
+	  This module allows one to match MH packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_MATCH_EUI64
 	tristate "EUI64 address check"
 	depends on IP6_NF_IPTABLES
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index ac1dfeb..4513eab 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
+obj-$(CONFIG_IP6_NF_MATCH_MH) += ip6t_mh.o
 
 # objects for l3 independent conntrack
 nf_conntrack_ipv6-objs  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o nf_conntrack_reasm.o
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
new file mode 100644
index 0000000..2c7efc6
--- /dev/null
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C)2006 USAGI/WIDE Project
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Author:
+ *	Masahide NAKAMURA @USAGI <masahide.nakamura.cz@hitachi.com>
+ *
+ * Based on net/netfilter/xt_tcpudp.c
+ *
+ */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <net/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/mip6.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv6/ip6t_mh.h>
+
+MODULE_DESCRIPTION("ip6t_tables match for MH");
+MODULE_LICENSE("GPL");
+
+#ifdef DEBUG_IP_FIREWALL_USER
+#define duprintf(format, args...) printk(format , ## args)
+#else
+#define duprintf(format, args...)
+#endif
+
+/* Returns 1 if the type is matched by the range, 0 otherwise */
+static inline int
+type_match(u_int8_t min, u_int8_t max, u_int8_t type, int invert)
+{
+	int ret;
+
+	ret = (type >= min && type <= max) ^ invert;
+	return ret;
+}
+
+static int
+match(const struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 const struct xt_match *match,
+	 const void *matchinfo,
+	 int offset,
+	 unsigned int protoff,
+	 int *hotdrop)
+{
+	struct ip6_mh _mh, *mh;
+	const struct ip6t_mh *mhinfo = matchinfo;
+
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	mh = skb_header_pointer(skb, protoff, sizeof(_mh), &_mh);
+	if (mh == NULL) {
+		/* We've been asked to examine this packet, and we
+		   can't.  Hence, no choice but to drop. */
+		duprintf("Dropping evil MH tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return type_match(mhinfo->types[0], mhinfo->types[1], mh->ip6mh_type,
+			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int
+mh_checkentry(const char *tablename,
+	      const void *entry,
+	      const struct xt_match *match,
+	      void *matchinfo,
+	      unsigned int hook_mask)
+{
+	const struct ip6t_mh *mhinfo = matchinfo;
+
+	/* Must specify no unknown invflags */
+	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
+}
+
+static struct xt_match mh_match = {
+	.name		= "mh",
+	.family		= AF_INET6,
+	.checkentry	= mh_checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_mh),
+	.proto		= IPPROTO_MH,
+	.me		= THIS_MODULE,
+};
+
+static int __init ip6t_mh_init(void)
+{
+	return xt_register_match(&mh_match);
+}
+
+static void __exit ip6t_mh_fini(void)
+{
+	xt_unregister_match(&mh_match);
+}
+
+module_init(ip6t_mh_init);
+module_exit(ip6t_mh_fini);
