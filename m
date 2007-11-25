From: Phil Oester <kernel@linuxace.com>
Subject: [RFC][PATCH] Per-conntrack timeout target v2
Date: Sat, 24 Nov 2007 17:03:08 -0800
Message-ID: <20071125010308.GA2782@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:34426
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752738AbXKYBDK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:03:10 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a second attempt at a per-conntrack timeout target.
As Patrick McHardy rightly observed, my previous attempt added
another 4 bytes to the conntrack structure.  The attached patch
uses the extension infrastructure to avoid this problem. 

As before, only TCP/UDP protos are supported ATM.  I'm sure
I've missed something in the conversion, so would appreciate
any comments/review.

Phil


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xt_TIMEOUT-kernel

diff -ruN linux-orig/include/linux/netfilter/nf_conntrack_common.h linux-TIMEOUT/include/linux/netfilter/nf_conntrack_common.h
--- linux-orig/include/linux/netfilter/nf_conntrack_common.h	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/include/linux/netfilter/nf_conntrack_common.h	2007-11-24 19:44:21.000000000 -0500
@@ -73,6 +73,10 @@
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Connection has a manually configured timeout. */
+	IPS_MANUAL_TIMEOUT_BIT = 11,
+	IPS_MANUAL_TIMEOUT = (1 << IPS_MANUAL_TIMEOUT_BIT),
 };
 
 /* Connection tracking event bits */
diff -ruN linux-orig/include/linux/netfilter/xt_TIMEOUT.h linux-TIMEOUT/include/linux/netfilter/xt_TIMEOUT.h
--- linux-orig/include/linux/netfilter/xt_TIMEOUT.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-TIMEOUT/include/linux/netfilter/xt_TIMEOUT.h	2007-11-24 19:59:26.000000000 -0500
@@ -0,0 +1,17 @@
+#ifndef _XT_TIMEOUT_H
+#define _XT_TIMEOUT_H
+
+struct nf_conn_timeout {
+	u_int32_t	timeout;
+};
+
+#ifdef __KERNEL__
+#include <net/netfilter/nf_conntrack_extend.h>
+
+static inline struct nf_conn_timeout *nfct_timeout(const struct nf_conn *ct)
+{
+        return nf_ct_ext_find(ct, NF_CT_EXT_TIMEOUT);
+}
+#endif
+
+#endif /*_XT_TIMEOUT_H*/
diff -ruN linux-orig/include/net/netfilter/nf_conntrack_extend.h linux-TIMEOUT/include/net/netfilter/nf_conntrack_extend.h
--- linux-orig/include/net/netfilter/nf_conntrack_extend.h	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/include/net/netfilter/nf_conntrack_extend.h	2007-11-24 19:44:21.000000000 -0500
@@ -7,11 +7,13 @@
 {
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
+	NF_CT_EXT_TIMEOUT,
 	NF_CT_EXT_NUM,
 };
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
+#define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff -ruN linux-orig/net/netfilter/Kconfig linux-TIMEOUT/net/netfilter/Kconfig
--- linux-orig/net/netfilter/Kconfig	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/Kconfig	2007-11-24 19:44:21.000000000 -0500
@@ -365,6 +365,17 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_TIMEOUT
+	tristate  '"TIMEOUT" target support'
+	depends on NETFILTER_XTABLES
+	depends on NF_CONNTRACK
+	help
+	  The TIMEOUT target allows you to alter the timeout of specific
+	  sessions in the conntrack/NAT subsystem.  Specific conntracks can
+	  be given longer or shorter timeouts than the global defaults.
+
+	  If unsure, say `N'.
+
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
 	depends on NETFILTER_XTABLES && NETWORK_SECMARK
diff -ruN linux-orig/net/netfilter/Makefile linux-TIMEOUT/net/netfilter/Makefile
--- linux-orig/net/netfilter/Makefile	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/Makefile	2007-11-24 19:48:24.000000000 -0500
@@ -48,6 +48,7 @@
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TIMEOUT) += xt_TIMEOUT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 
 # matches
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_tcp.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_tcp.c	2007-11-24 19:44:21.000000000 -0500
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 /* Protects conntrack->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
@@ -944,6 +945,9 @@
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+	if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status)
+	    && new_state == TCP_CONNTRACK_ESTABLISHED)
+		timeout = nfct_timeout(conntrack)->timeout;
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_udp.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_udp.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udp.c	2007-11-24 19:44:21.000000000 -0500
@@ -21,6 +21,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
@@ -74,11 +75,16 @@
 		      int pf,
 		      unsigned int hooknum)
 {
+	unsigned long timeout;
+
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+		timeout = nf_ct_udp_timeout_stream;
+		if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status))
+			timeout = nfct_timeout(conntrack)->timeout;
 		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udp_timeout_stream);
+				   timeout);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
 			nf_conntrack_event_cache(IPCT_STATUS, skb);
diff -ruN linux-orig/net/netfilter/xt_TIMEOUT.c linux-TIMEOUT/net/netfilter/xt_TIMEOUT.c
--- linux-orig/net/netfilter/xt_TIMEOUT.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/xt_TIMEOUT.c	2007-11-24 19:44:21.000000000 -0500
@@ -0,0 +1,121 @@
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+MODULE_AUTHOR("Phil Oester <kernel@linuxace.com>");
+MODULE_DESCRIPTION("x_tables per-conntrack TIMEOUT target");
+MODULE_LICENSE("GPL");
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
+#include <net/netfilter/nf_conntrack.h>
+
+static unsigned int
+target(struct sk_buff *skb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo)
+{
+	const struct nf_conn_timeout *timeoutinfo = targinfo;
+	struct nf_conn *ct;
+	struct nf_conn_timeout *timeout_ext;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		timeout_ext = nfct_timeout(ct);
+		if (!timeout_ext) {
+			timeout_ext = nf_ct_ext_add(ct, NF_CT_EXT_TIMEOUT,
+						    GFP_ATOMIC);
+			if (timeout_ext == NULL) {
+				pr_debug("failed to add TIMEOUT extension\n");
+				return XT_CONTINUE;
+			}
+		}
+		timeout_ext->timeout = timeoutinfo->timeout * HZ;
+		set_bit(IPS_MANUAL_TIMEOUT_BIT, &ct->status);
+	}
+
+	return XT_CONTINUE;
+}
+
+static bool
+checkentry(const char *tablename,
+	   const void *entry,
+	   const struct xt_target *target,
+	   void *targinfo,
+	   unsigned int hook_mask)
+{
+	const struct nf_conn_timeout *timeoutinfo = targinfo;
+
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
+	if (timeoutinfo->timeout > LONG_MAX / HZ)
+		return false;
+
+	return true;
+}
+
+static void
+destroy(const struct xt_target *target, void *targinfo)
+{
+	nf_ct_l3proto_module_put(target->family);
+}
+
+static struct xt_target xt_timeout[] __read_mostly = {
+	{
+		.name		= "TIMEOUT",
+		.family		= AF_INET,
+		.checkentry	= checkentry,
+		.destroy	= destroy,
+		.target		= target,
+		.targetsize	= sizeof(struct nf_conn_timeout),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "TIMEOUT",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.destroy	= destroy,
+		.target		= target,
+		.targetsize	= sizeof(struct nf_conn_timeout),
+		.me		= THIS_MODULE
+	},
+};
+
+static struct nf_ct_ext_type timeout_extend __read_mostly = {
+	.len		= sizeof(struct nf_conn_timeout),
+	.align		= __alignof__(struct nf_conn_timeout),
+	.id		= NF_CT_EXT_TIMEOUT,
+};
+
+static int __init xt_timeout_init(void)
+{
+	int ret;
+
+	ret = nf_ct_extend_register(&timeout_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "xt_TIMEOUT: Unable to register extension\n");
+		return ret;
+	}
+
+	ret = xt_register_targets(xt_timeout, ARRAY_SIZE(xt_timeout));
+	if (ret < 0)
+		nf_ct_extend_unregister(&timeout_extend);
+
+	return ret;
+}
+
+static void __exit xt_timeout_fini(void)
+{
+	nf_ct_extend_unregister(&timeout_extend);
+	xt_unregister_targets(xt_timeout, ARRAY_SIZE(xt_timeout));
+}
+
+module_init(xt_timeout_init);
+module_exit(xt_timeout_fini);

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xt_TIMEOUT-user

diff -ruN ipt-orig/extensions/libxt_TIMEOUT.c ipt-new/extensions/libxt_TIMEOUT.c
--- ipt-orig/extensions/libxt_TIMEOUT.c	1969-12-31 16:00:00.000000000 -0800
+++ ipt-new/extensions/libxt_TIMEOUT.c	2007-11-24 16:55:18.000000000 -0800
@@ -0,0 +1,111 @@
+/* Shared library add-on to iptables for the TIMEOUT target
+ * (C) 2007 by Phil Oester <kernel@linuxace.com>
+ *
+ * This program is distributed under the terms of GNU GPL
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
+
+#define XT_TIMEOUT_USED	1
+
+static void TIMEOUT_help(void)
+{
+	printf(
+"TIMEOUT target v%s options\n"
+"  --timeout value		Set conntrack TIMEOUT to <value in seconds>\n"
+, IPTABLES_VERSION);
+}
+
+static int TIMEOUT_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
+{
+	struct nf_conn_timeout *info = (struct nf_conn_timeout *) (*target)->data;
+	unsigned int value;
+
+	if (*flags & XT_TIMEOUT_USED) {
+		exit_error(PARAMETER_PROBLEM, 
+				"Can't specify TIMEOUT option twice");
+	}
+
+	if (!optarg) 
+		exit_error(PARAMETER_PROBLEM, 
+				"TIMEOUT: You must specify a value");
+
+	if (check_inverse(optarg, &invert, NULL, 0))
+		exit_error(PARAMETER_PROBLEM,
+				"TIMEOUT: unexpected `!'");
+	
+	if (string_to_number(optarg, 0, 0xFFFFFFFF, &value) == -1)
+		exit_error(PARAMETER_PROBLEM,
+		           "TIMEOUT: Value overflow");
+
+	switch (c) {
+
+		case '1':
+			break;
+
+		default:
+			return 0;
+
+	}
+	
+	info->timeout = value;
+	*flags |= XT_TIMEOUT_USED;
+
+	return 1;
+}
+
+static void TIMEOUT_check(unsigned int flags)
+{
+	if (!(flags & XT_TIMEOUT_USED))
+		exit_error(PARAMETER_PROBLEM,
+				"TIMEOUT: You must specify an action");
+}
+
+static void TIMEOUT_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct nf_conn_timeout *info = 
+		(struct nf_conn_timeout *) target->data;
+
+	printf("--timeout %u ", info->timeout);
+}
+
+static void TIMEOUT_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
+{
+	const struct nf_conn_timeout *info =
+		(struct nf_conn_timeout *) target->data;
+
+	printf("timeout %u ", info->timeout);
+}
+
+static const struct option TIMEOUT_opts[] = {
+	{ "timeout", 1, NULL, '1' },
+	{ }
+};
+
+static struct iptables_target timeout_target = {
+	.next		= NULL, 
+	.name		= "TIMEOUT",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct nf_conn_timeout)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_conn_timeout)),
+	.help		= TIMEOUT_help,
+	.parse		= TIMEOUT_parse,
+	.final_check	= TIMEOUT_check,
+	.print		= TIMEOUT_print,
+	.save		= TIMEOUT_save,
+	.extra_opts	= TIMEOUT_opts,
+};
+
+void _init(void)
+{
+	register_target(&timeout_target);
+}
diff -ruN ipt-orig/extensions/Makefile ipt-new/extensions/Makefile
--- ipt-orig/extensions/Makefile	2007-10-31 04:46:40.000000000 -0700
+++ ipt-new/extensions/Makefile	2007-11-02 14:14:22.000000000 -0700
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE TIMEOUT
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
diff -ruN ipt-orig/include/linux/netfilter/xt_TIMEOUT.h ipt-new/include/linux/netfilter/xt_TIMEOUT.h
--- ipt-orig/include/linux/netfilter/xt_TIMEOUT.h	1969-12-31 16:00:00.000000000 -0800
+++ ipt-new/include/linux/netfilter/xt_TIMEOUT.h	2007-11-24 16:59:37.000000000 -0800
@@ -0,0 +1,17 @@
+#ifndef _XT_TIMEOUT_H
+#define _XT_TIMEOUT_H
+
+struct nf_conn_timeout {
+	u_int32_t	timeout;
+};
+
+#ifdef __KERNEL__
+#include <net/netfilter/nf_conntrack_extend.h>
+
+static inline struct nf_conn_timeout *nfct_timeout(const struct nf_conn *ct)
+{
+        return nf_ct_ext_find(ct, NF_CT_EXT_TIMEOUT);
+}
+#endif
+
+#endif /*_XT_TIMEOUT_H*/

--azLHFNyN32YCQGCU--
