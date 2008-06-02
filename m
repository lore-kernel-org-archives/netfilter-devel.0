From: Krzysztof Oledzki <ole@ans.pl>
Subject: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Mon, 02 Jun 2008 19:24:40 +0200
Message-ID: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:34828 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYFBRYz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:24:55 -0400
Received: from bizon.gios.gov.pl (ole@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.2/8.14.1) with ESMTP id m52HOeh1031793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 2 Jun 2008 19:24:44 +0200
Received: (from ole@localhost)
	by bizon.gios.gov.pl (8.14.2/8.14.1/Submit) id m52HOe8e031792
	for netfilter-devel@vger.kernel.org; Mon, 2 Jun 2008 19:24:40 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER] Accounting rework: ct_extend + 64bit counters

Initially netfilter has had 64bit counters for conntrack-based accounting, but
it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit counters are
still required, for example for "connbytes" extension. However, 64bit counters
waste a lot of memory and it was not possible to enable/disable it runtime.

This patch:
 - reimplements accounting with respect to the extension infrastructure,
 - makes one global version of seq_print_acct() instead of two seq_print_counters(),
 - makes it possible to enable it at boot time (for SYSFS=n),
 - makes it possible to enable/disable it at runtime by sysctl or sysfs,
 - extents counters from 32bit to 64bit,
 - enables accounting code unconditionally (no more CONFIG_NF_CT_ACCT),
 - keeps accounting disabled by default,
 - removes buggy IPCT_COUNTER_FILLING event handling.

If accounting is enabled newly created connections get additional acct extent.
Old connections are not changed as it is not possible to add a ct_extend area
to confirmed conntrack. Accounting is performed for all connections with
acct extent regardless of a current state of net.netfilter.nf_conntrack_acct.

Patch against 2.6.26-rc4, it would be nice if it can be included
in 2.6.27.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt
--- linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt	2008-06-02 18:28:30.000000000 +0200
@@ -1234,6 +1234,11 @@
 			This usage is only documented in each driver source
 			file if at all.
 
+	nf_conntrack.acct=
+			[NETFILTER] Enable connection tracking flow accounting
+			0 to disable accounting (default)
+			1 to enable accounting
+
 	nfsaddrs=	[NFS]
 			See Documentation/filesystems/nfsroot.txt.
 
diff -Nur linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.h
--- linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.h	2008-06-02 17:19:05.000000000 +0200
@@ -122,10 +122,6 @@
 	IPCT_NATINFO_BIT = 10,
 	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
 
-	/* Counter highest bit has been set */
-	IPCT_COUNTER_FILLING_BIT = 11,
-	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
-
 	/* Mark is set */
 	IPCT_MARK_BIT = 12,
 	IPCT_MARK = (1 << IPCT_MARK_BIT),
@@ -145,12 +141,6 @@
 };
 
 #ifdef __KERNEL__
-struct ip_conntrack_counter
-{
-	u_int32_t packets;
-	u_int32_t bytes;
-};
-
 struct ip_conntrack_stat
 {
 	unsigned int searched;
diff -Nur linux-2.6.26-rc4-net/include/linux/netfilter/nfnetlink_conntrack.h linux-2.6.26-rc4-64bitc/include/linux/netfilter/nfnetlink_conntrack.h
--- linux-2.6.26-rc4-net/include/linux/netfilter/nfnetlink_conntrack.h	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/include/linux/netfilter/nfnetlink_conntrack.h	2008-06-02 17:18:27.000000000 +0200
@@ -105,10 +105,10 @@
 
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
-	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
-	CTA_COUNTERS_BYTES,		/* old 64bit counters */
-	CTA_COUNTERS32_PACKETS,
-	CTA_COUNTERS32_BYTES,
+	CTA_COUNTERS_PACKETS,		/* 64bit counters */
+	CTA_COUNTERS_BYTES,		/* 64bit counters */
+	CTA_COUNTERS32_PACKETS,		/* old 32bit counters, unused */
+	CTA_COUNTERS32_BYTES,		/* old 32bit counters, unused */
 	__CTA_COUNTERS_MAX
 };
 #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
diff -Nur linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack.h linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack.h
--- linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack.h	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack.h	2008-06-02 17:18:27.000000000 +0200
@@ -88,7 +88,6 @@
 	u8 expecting[NF_CT_MAX_EXPECT_CLASSES];
 };
 
-
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
@@ -111,11 +110,6 @@
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
 
-#ifdef CONFIG_NF_CT_ACCT
-	/* Accounting Information (same cache line as other written members) */
-	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
-#endif
-
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	u_int32_t mark;
 #endif
diff -Nur linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack_acct.h linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack_acct.h
--- linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack_acct.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack_acct.h	2008-06-02 17:53:18.000000000 +0200
@@ -0,0 +1,24 @@
+#ifndef _NF_CONNTRACK_ACCT_H
+#define _NF_CONNTRACK_ACCT_H
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_acct {
+	u_int64_t packets[IP_CT_DIR_MAX];
+	u_int64_t bytes[IP_CT_DIR_MAX];
+};
+
+static inline struct nf_conn_acct *nf_conn_acct_find(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_ACCT);
+}
+
+struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp);
+unsigned int seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
+
+void nf_conntrack_acct_cleanup(void);
+int nf_conntrack_acct_init(void);
+
+#endif /* _NF_CONNTRACK_ACCT_H */
diff -Nur linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack_extend.h linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack_extend.h
--- linux-2.6.26-rc4-net/include/net/netfilter/nf_conntrack_extend.h	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/include/net/netfilter/nf_conntrack_extend.h	2008-06-02 17:54:22.000000000 +0200
@@ -7,11 +7,13 @@
 {
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
+	NF_CT_EXT_ACCT,
 	NF_CT_EXT_NUM,
 };
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
+#define NF_CT_EXT_ACCT_TYPE struct nf_conn_acct
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff -Nur linux-2.6.26-rc4-net/include/net/netlink.h linux-2.6.26-rc4-64bitc/include/net/netlink.h
--- linux-2.6.26-rc4-net/include/net/netlink.h	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/include/net/netlink.h	2008-06-02 17:18:27.000000000 +0200
@@ -898,6 +898,9 @@
 #define NLA_PUT_U64(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u64, attrtype, value)
 
+#define NLA_PUT_BE64(skb, attrtype, value) \
+	NLA_PUT_TYPE(skb, __be64, attrtype, value)
+
 #define NLA_PUT_STRING(skb, attrtype, value) \
 	NLA_PUT(skb, attrtype, strlen(value) + 1, value)
 
diff -Nur linux-2.6.26-rc4-net/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c linux-2.6.26-rc4-64bitc/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
--- linux-2.6.26-rc4-net/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2008-06-02 17:22:53.000000000 +0200
@@ -18,19 +18,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
-
-#ifdef CONFIG_NF_CT_ACCT
-static unsigned int
-seq_print_counters(struct seq_file *s,
-		   const struct ip_conntrack_counter *counter)
-{
-	return seq_printf(s, "packets=%llu bytes=%llu ",
-			  (unsigned long long)counter->packets,
-			  (unsigned long long)counter->bytes);
-}
-#else
-#define seq_print_counters(x, y)	0
-#endif
+#include <net/netfilter/nf_conntrack_acct.h>
 
 struct ct_iter_state {
 	unsigned int bucket;
@@ -127,7 +115,7 @@
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_ORIGINAL]))
+	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL));
 		return -ENOSPC;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
@@ -138,7 +126,7 @@
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_REPLY]))
+	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		return -ENOSPC;
 
 	if (test_bit(IPS_ASSURED_BIT, &ct->status))
diff -Nur linux-2.6.26-rc4-net/net/netfilter/Kconfig linux-2.6.26-rc4-64bitc/net/netfilter/Kconfig
--- linux-2.6.26-rc4-net/net/netfilter/Kconfig	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/Kconfig	2008-06-02 18:33:50.000000000 +0200
@@ -39,19 +39,6 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NF_CT_ACCT
-	bool "Connection tracking flow accounting"
-	depends on NETFILTER_ADVANCED
-	depends on NF_CONNTRACK
-	help
-	  If this option is enabled, the connection tracking code will
-	  keep per-flow packet and byte counters.
-
-	  Those counters can be used for flow-based accounting or the
-	  `connbytes' match.
-
-	  If unsure, say `N'.
-
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on NETFILTER_ADVANCED
@@ -485,11 +472,15 @@
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
-	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
 
+	  Please note that accounting is disabled by default, to enable
+	  it boot your kernel with nf_conntrack.acct=1 or load the nf_conntrack
+	  module with acct=1. You may also disable/enable it on a running
+	  system: "sysctl net.netfilter.nf_conntrack_acct".
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
diff -Nur linux-2.6.26-rc4-net/net/netfilter/Makefile linux-2.6.26-rc4-64bitc/net/netfilter/Makefile
--- linux-2.6.26-rc4-net/net/netfilter/Makefile	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/Makefile	2008-06-02 17:23:08.000000000 +0200
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff -Nur linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_acct.c linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_acct.c
--- linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_acct.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_acct.c	2008-06-02 17:58:59.000000000 +0200
@@ -0,0 +1,97 @@
+/* Accouting handling for netfilter. */
+
+/*
+ * (C) 2008 Krzysztof Piotr Oledzki <ole@ans.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_acct.h>
+
+static unsigned int nf_ct_acct __read_mostly;
+
+module_param_named(acct, nf_ct_acct, bool, 0644);
+MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *acct_sysctl_header;
+static struct ctl_table acct_sysctl_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nf_conntrack_acct",
+		.data		= &nf_ct_acct,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+};
+#endif /* CONFIG_SYSCTL */
+
+struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
+{
+	struct nf_conn_acct *acct;
+
+	if (!nf_ct_acct)
+		return NULL;
+
+	acct = nf_ct_ext_add(ct, NF_CT_EXT_ACCT, gfp);
+	if (!acct)
+		pr_debug("failed to add accounting extension area");
+
+	return acct;
+};
+
+unsigned int
+seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
+{
+	struct nf_conn_acct *acct;
+
+	acct = nf_conn_acct_find(ct);
+	if (!acct)
+		return 0;
+
+	return seq_printf(s, "packets=%llu bytes=%llu ",
+			  acct->packets[dir],
+			  acct->bytes[dir]);
+};
+
+EXPORT_SYMBOL_GPL(seq_print_acct);
+
+static struct nf_ct_ext_type acct_extend __read_mostly = {
+	.len	= sizeof(struct nf_conn_acct),
+	.align	= __alignof__(struct nf_conn_acct),
+	.id	= NF_CT_EXT_ACCT,
+};
+
+int nf_conntrack_acct_init(void)
+{
+	int ret;
+
+	ret = nf_ct_extend_register(&acct_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
+		return ret;
+	}
+
+#ifdef CONFIG_SYSCTL
+	acct_sysctl_header = register_sysctl_paths(nf_net_netfilter_sysctl_path, acct_sysctl_table);
+#endif
+
+	return 0;
+}
+
+void nf_conntrack_acct_cleanup(void)
+{
+#ifdef CONFIG_SYSCTL
+	unregister_sysctl_table(acct_sysctl_header);
+#endif
+	nf_ct_extend_unregister(&acct_extend);
+}
diff -Nur linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_core.c linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_core.c
--- linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_core.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_core.c	2008-06-02 17:45:37.000000000 +0200
@@ -37,6 +37,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
@@ -555,6 +556,8 @@
 		return NULL;
 	}
 
+	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+
 	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(tuple);
 	if (exp) {
@@ -828,17 +831,16 @@
 	}
 
 acct:
-#ifdef CONFIG_NF_CT_ACCT
 	if (do_acct) {
-		ct->counters[CTINFO2DIR(ctinfo)].packets++;
-		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
-			skb->len - skb_network_offset(skb);
-
-		if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-		    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-			event |= IPCT_COUNTER_FILLING;
+		struct nf_conn_acct *acct;
+
+		acct = nf_conn_acct_find(ct);
+		if (acct) {
+			acct->packets[CTINFO2DIR(ctinfo)]++;
+			acct->bytes[CTINFO2DIR(ctinfo)] +=
+				skb->len - skb_network_offset(skb);
+		}
 	}
-#endif
 
 	spin_unlock_bh(&nf_conntrack_lock);
 
@@ -1007,6 +1009,7 @@
 	nf_conntrack_proto_fini();
 	nf_conntrack_helper_fini();
 	nf_conntrack_expect_fini();
+	nf_conntrack_acct_cleanup();
 }
 
 struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced)
@@ -1146,6 +1149,10 @@
 	if (ret < 0)
 		goto out_fini_expect;
 
+	ret = nf_conntrack_acct_init();
+	if (ret < 0)
+		goto out_fini_acct;
+
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
 	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
@@ -1158,6 +1165,7 @@
 
 	return ret;
 
+out_fini_acct:
 out_fini_expect:
 	nf_conntrack_expect_fini();
 out_fini_proto:
diff -Nur linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_netlink.c linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_netlink.c
--- linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_netlink.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_netlink.c	2008-06-02 17:33:54.000000000 +0200
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -205,22 +206,26 @@
 	return -1;
 }
 
-#ifdef CONFIG_NF_CT_ACCT
 static int
-ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
+ctnetlink_dump_acct(struct sk_buff *skb, const struct nf_conn *ct,
 			enum ip_conntrack_dir dir)
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
 	struct nlattr *nest_count;
+	const struct nf_conn_acct *acct;
+
+	acct = nf_conn_acct_find(ct);
+	if (!acct)
+		return 0;
 
 	nest_count = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_count)
 		goto nla_put_failure;
 
-	NLA_PUT_BE32(skb, CTA_COUNTERS32_PACKETS,
-		     htonl(ct->counters[dir].packets));
-	NLA_PUT_BE32(skb, CTA_COUNTERS32_BYTES,
-		     htonl(ct->counters[dir].bytes));
+	NLA_PUT_BE64(skb, CTA_COUNTERS_PACKETS,
+		     cpu_to_be64(acct->packets[dir]));
+	NLA_PUT_BE64(skb, CTA_COUNTERS_BYTES,
+		     cpu_to_be64(acct->bytes[dir]));
 
 	nla_nest_end(skb, nest_count);
 
@@ -229,9 +234,6 @@
 nla_put_failure:
 	return -1;
 }
-#else
-#define ctnetlink_dump_counters(a, b, c) (0)
-#endif
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
 static inline int
@@ -389,8 +391,8 @@
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
+	    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+	    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_REPLY) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
@@ -476,8 +478,8 @@
 		goto nla_put_failure;
 
 	if (events & IPCT_DESTROY) {
-		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+		if (ctnetlink_dump_acct(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+		    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_REPLY) < 0)
 			goto nla_put_failure;
 	} else {
 		if (ctnetlink_dump_status(skb, ct) < 0)
@@ -500,11 +502,6 @@
 			goto nla_put_failure;
 #endif
 
-		if (events & IPCT_COUNTER_FILLING &&
-		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
-			goto nla_put_failure;
-
 		if (events & IPCT_RELATED &&
 		    ctnetlink_dump_master(skb, ct) < 0)
 			goto nla_put_failure;
@@ -575,11 +572,15 @@
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
-#ifdef CONFIG_NF_CT_ACCT
+
 			if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) ==
-						IPCTNL_MSG_CT_GET_CTRZERO)
-				memset(&ct->counters, 0, sizeof(ct->counters));
-#endif
+						IPCTNL_MSG_CT_GET_CTRZERO) {
+				struct nf_conn_acct *acct;
+
+				acct = nf_conn_acct_find(ct);
+				if (acct)
+					memset(acct, 0, sizeof(*acct));
+			}
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -832,14 +833,9 @@
 	u_int8_t u3 = nfmsg->nfgen_family;
 	int err = 0;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-#ifndef CONFIG_NF_CT_ACCT
-		if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO)
-			return -ENOTSUPP;
-#endif
+	if (nlh->nlmsg_flags & NLM_F_DUMP)
 		return netlink_dump_start(ctnl, skb, nlh, ctnetlink_dump_table,
 					  ctnetlink_done);
-	}
 
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG, u3);
@@ -1153,6 +1149,8 @@
 			goto err;
 	}
 
+	nf_ct_acct_ext_add(ct, GFP_KERNEL);
+
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
diff -Nur linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_standalone.c linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_standalone.c
--- linux-2.6.26-rc4-net/net/netfilter/nf_conntrack_standalone.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/nf_conntrack_standalone.c	2008-06-02 17:34:09.000000000 +0200
@@ -25,6 +25,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 MODULE_LICENSE("GPL");
 
@@ -38,19 +39,6 @@
 }
 EXPORT_SYMBOL_GPL(print_tuple);
 
-#ifdef CONFIG_NF_CT_ACCT
-static unsigned int
-seq_print_counters(struct seq_file *s,
-		   const struct ip_conntrack_counter *counter)
-{
-	return seq_printf(s, "packets=%llu bytes=%llu ",
-			  (unsigned long long)counter->packets,
-			  (unsigned long long)counter->bytes);
-}
-#else
-#define seq_print_counters(x, y)	0
-#endif
-
 struct ct_iter_state {
 	unsigned int bucket;
 };
@@ -146,7 +134,7 @@
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_ORIGINAL]))
+	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
 		return -ENOSPC;
 
 	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
@@ -157,7 +145,7 @@
 			l3proto, l4proto))
 		return -ENOSPC;
 
-	if (seq_print_counters(s, &ct->counters[IP_CT_DIR_REPLY]))
+	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		return -ENOSPC;
 
 	if (test_bit(IPS_ASSURED_BIT, &ct->status))
diff -Nur linux-2.6.26-rc4-net/net/netfilter/xt_connbytes.c linux-2.6.26-rc4-64bitc/net/netfilter/xt_connbytes.c
--- linux-2.6.26-rc4-net/net/netfilter/xt_connbytes.c	2008-05-26 20:08:11.000000000 +0200
+++ linux-2.6.26-rc4-64bitc/net/netfilter/xt_connbytes.c	2008-06-02 17:43:06.000000000 +0200
@@ -8,6 +8,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connbytes.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -27,57 +28,62 @@
 	u_int64_t what = 0;	/* initialize to make gcc happy */
 	u_int64_t bytes = 0;
 	u_int64_t pkts = 0;
-	const struct ip_conntrack_counter *counters;
+	const struct nf_conn_acct *acct;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
 		return false;
-	counters = ct->counters;
+
+	acct = nf_conn_acct_find(ct);
+	if (!acct)
+		return false;
 
 	switch (sinfo->what) {
 	case XT_CONNBYTES_PKTS:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what = counters[IP_CT_DIR_ORIGINAL].packets;
+			what = acct->packets[IP_CT_DIR_ORIGINAL];
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what = counters[IP_CT_DIR_REPLY].packets;
+			what = acct->packets[IP_CT_DIR_REPLY];
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			what = counters[IP_CT_DIR_ORIGINAL].packets;
-			what += counters[IP_CT_DIR_REPLY].packets;
+			what = acct->packets[IP_CT_DIR_ORIGINAL] +
+			       acct->packets[IP_CT_DIR_REPLY];
 			break;
 		}
 		break;
+
 	case XT_CONNBYTES_BYTES:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			what = counters[IP_CT_DIR_ORIGINAL].bytes;
+			what = acct->bytes[IP_CT_DIR_ORIGINAL];
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			what = counters[IP_CT_DIR_REPLY].bytes;
+			what = acct->bytes[IP_CT_DIR_REPLY];
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			what = counters[IP_CT_DIR_ORIGINAL].bytes;
-			what += counters[IP_CT_DIR_REPLY].bytes;
+			what = acct->bytes[IP_CT_DIR_ORIGINAL] +
+			       acct->bytes[IP_CT_DIR_REPLY];
 			break;
 		}
 		break;
+
 	case XT_CONNBYTES_AVGPKT:
 		switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
-			bytes = counters[IP_CT_DIR_ORIGINAL].bytes;
-			pkts  = counters[IP_CT_DIR_ORIGINAL].packets;
+			bytes = acct->bytes[IP_CT_DIR_ORIGINAL];
+			pkts  = acct->packets[IP_CT_DIR_ORIGINAL];
 			break;
 		case XT_CONNBYTES_DIR_REPLY:
-			bytes = counters[IP_CT_DIR_REPLY].bytes;
-			pkts  = counters[IP_CT_DIR_REPLY].packets;
+			bytes = acct->bytes[IP_CT_DIR_REPLY];
+			pkts  = acct->packets[IP_CT_DIR_REPLY];
 			break;
 		case XT_CONNBYTES_DIR_BOTH:
-			bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
-				counters[IP_CT_DIR_REPLY].bytes;
-			pkts  = counters[IP_CT_DIR_ORIGINAL].packets +
-				counters[IP_CT_DIR_REPLY].packets;
+			bytes = acct->bytes[IP_CT_DIR_ORIGINAL] +
+				acct->bytes[IP_CT_DIR_REPLY];
+			pkts  = acct->packets[IP_CT_DIR_ORIGINAL] +
+				acct->packets[IP_CT_DIR_REPLY];
 			break;
 		}
 		if (pkts != 0)
