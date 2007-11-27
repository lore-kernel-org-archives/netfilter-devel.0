From: Phil Oester <kernel@linuxace.com>
Subject: [RFC][PATCH] Per-conntrack timeout target v3
Date: Tue, 27 Nov 2007 11:07:45 -0800
Message-ID: <20071127190745.GA2080@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:49618
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758005AbXK0THq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:07:46 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some further updates/optimizations to my original posting.  This version
handles all protocols now.  Anyone besides me think this is useful?

***

I use a fairly short 2 hour established timeout on firewalls I operate,
which works fine for most purposes.  Occasionally, however, it would
be nice to have a longer timeout for *certain* types of traffic
such as SSH or telnet sessions.  

So, below find a TIMEOUT target to enable such per-conntrack timeouts.
Syntax for SSH would be something like:

        iptables -A foo -p tcp --dport 22 -j TIMEOUT --timeout 123456
        iptables -A foo -p tcp --dport 22 -j ACCEPT

It could of course also be used to lower the timeouts on some traffic,
such as HTTP.

Phil



--2oS5YaxWCcQjTEyO
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
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_generic.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_generic.c
--- linux-orig/net/netfilter/nf_conntrack_proto_generic.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_generic.c	2007-11-27 13:00:36.000000000 -0500
@@ -11,6 +11,7 @@
 #include <linux/timer.h>
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 
@@ -55,7 +56,14 @@
 		  int pf,
 		  unsigned int hooknum)
 {
-	nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_generic_timeout);
+	unsigned int timeout;
+
+	if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status))
+		timeout = nfct_timeout(conntrack)->timeout;
+	else
+		timeout = nf_ct_generic_timeout;
+
+	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 	return NF_ACCEPT;
 }
 
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_gre.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_gre.c
--- linux-orig/net/netfilter/nf_conntrack_proto_gre.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_gre.c	2007-11-27 12:59:57.000000000 -0500
@@ -36,6 +36,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 #define GRE_TIMEOUT		(30 * HZ)
 #define GRE_STREAM_TIMEOUT	(180 * HZ)
@@ -217,11 +218,16 @@
 		      int pf,
 		      unsigned int hooknum)
 {
+	unsigned int timeout;
+
 	/* If we've seen traffic both ways, this is a GRE connection.
 	 * Extend timeout. */
 	if (ct->status & IPS_SEEN_REPLY) {
-		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   ct->proto.gre.stream_timeout);
+		if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &ct->status))
+			timeout = nfct_timeout(ct)->timeout;
+		else
+			timeout = ct->proto.gre.stream_timeout;
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeout);
 		/* Also, more likely to be important, and not a probe. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_STATUS, skb);
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_sctp.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_sctp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_sctp.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_sctp.c	2007-11-27 12:58:39.000000000 -0500
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 /* Protects conntrack->proto.sctp */
 static DEFINE_RWLOCK(sctp_lock);
@@ -298,6 +299,7 @@
 	sctp_chunkhdr_t _sch, *sch;
 	u_int32_t offset, count;
 	char map[256 / sizeof (char)] = {0};
+	unsigned int timeout;
 
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
@@ -387,7 +389,13 @@
 		write_unlock_bh(&sctp_lock);
 	}
 
-	nf_ct_refresh_acct(conntrack, ctinfo, skb, *sctp_timeouts[newconntrack]);
+	if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status)
+	    && newconntrack == SCTP_CONNTRACK_ESTABLISHED)
+		timeout = nfct_timeout(conntrack)->timeout;
+	else
+		timeout = *sctp_timeouts[newconntrack];
+
+	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
 	if (oldsctpstate == SCTP_CONNTRACK_COOKIE_ECHOED
 		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_tcp.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_tcp.c	2007-11-27 13:02:03.000000000 -0500
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 /* Protects conntrack->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
@@ -941,9 +942,13 @@
 	    && (new_state == TCP_CONNTRACK_FIN_WAIT
 		|| new_state == TCP_CONNTRACK_CLOSE))
 		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
-	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
-		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
-		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+	if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status)
+	    && new_state == TCP_CONNTRACK_ESTABLISHED)
+		timeout = nfct_timeout(conntrack)->timeout;
+	else
+	    timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
+		      && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
+		      ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_udp.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_udp.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udp.c	2007-11-27 13:04:30.000000000 -0500
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
-		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udp_timeout_stream);
+		if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status))
+			timeout = nfct_timeout(conntrack)->timeout;
+		else
+			timeout = nf_ct_udp_timeout_stream;
+		nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
 			nf_conntrack_event_cache(IPCT_STATUS, skb);
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_udplite.c linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udplite.c
--- linux-orig/net/netfilter/nf_conntrack_proto_udplite.c	2007-11-17 00:16:36.000000000 -0500
+++ linux-TIMEOUT/net/netfilter/nf_conntrack_proto_udplite.c	2007-11-27 13:06:03.000000000 -0500
@@ -22,6 +22,7 @@
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <linux/netfilter/xt_TIMEOUT.h>
 
 static unsigned int nf_ct_udplite_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udplite_timeout_stream __read_mostly = 180*HZ;
@@ -73,11 +74,16 @@
 			  int pf,
 			  unsigned int hooknum)
 {
+	unsigned long timeout;
+
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
-		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udplite_timeout_stream);
+		if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &conntrack->status))
+			timeout = nfct_timeout(conntrack)->timeout;
+		else
+			timeout = nf_ct_udplite_timeout_stream;
+		nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
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

--2oS5YaxWCcQjTEyO
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

--2oS5YaxWCcQjTEyO--
