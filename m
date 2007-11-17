From: Phil Oester <kernel@linuxace.com>
Subject: [RFC] Per-conntrack timeout target
Date: Sat, 17 Nov 2007 10:11:23 -0800
Message-ID: <20071117181123.GA15156@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44439
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755727AbXKQSLY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:11:24 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

Please review, comment, criticize, etc.  Note that at present it only
handles TCP/UDP traffic.  If deemed "merge-worthy", support for other
protos will be added.

Phil




--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xt_TIMEOUT-kernel

diff -ruN linux-orig/include/linux/netfilter/xt_TIMEOUT.h linux-test/include/linux/netfilter/xt_TIMEOUT.h
--- linux-orig/include/linux/netfilter/xt_TIMEOUT.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-test/include/linux/netfilter/xt_TIMEOUT.h	2007-11-16 19:55:23.000000000 -0500
@@ -0,0 +1,8 @@
+#ifndef _XT_TIMEOUT_H
+#define _XT_TIMEOUT_H
+
+struct xt_timeout_info {
+	u_int32_t	timeout;
+};
+
+#endif /*_XT_TIMEOUT_H*/
diff -ruN linux-orig/include/net/netfilter/nf_conntrack.h linux-test/include/net/netfilter/nf_conntrack.h
--- linux-orig/include/net/netfilter/nf_conntrack.h	2007-10-23 23:50:57.000000000 -0400
+++ linux-test/include/net/netfilter/nf_conntrack.h	2007-11-10 19:13:37.000000000 -0500
@@ -124,6 +124,10 @@
 	u_int32_t secmark;
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	u_int32_t xt_target_timeout;
+#endif
+
 	/* Storage reserved for other modules: */
 	union nf_conntrack_proto proto;
 
diff -ruN linux-orig/net/netfilter/Kconfig linux-test/net/netfilter/Kconfig
--- linux-orig/net/netfilter/Kconfig	2007-11-17 12:40:48.000000000 -0500
+++ linux-test/net/netfilter/Kconfig	2007-11-10 19:14:56.000000000 -0500
@@ -87,6 +87,17 @@
 
 	  If unsure, say `N'.
 
+config NF_CONNTRACK_TIMEOUT
+	bool  'Connection tracking timeouts'
+	depends on NF_CONNTRACK
+	help
+	  This option enables support for per-conntrack timeouts.  When used
+	  with the TIMEOUT target, specific conntracks can be given shorter or
+	  longer timeouts.  This provides more flexibility than altering
+	  the global timeouts.
+
+	  If unsure, say `N'.
+
 config NF_CT_PROTO_GRE
 	tristate
 	depends on NF_CONNTRACK
@@ -365,6 +376,18 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_TIMEOUT
+	tristate  '"TIMEOUT" target support'
+	depends on NETFILTER_XTABLES
+	depends on NF_CONNTRACK
+	depends on NF_CONNTRACK_TIMEOUT
+	help
+	  The TIMEOUT target allows you to alter the timeout of sessions
+	  in the conntrack/NAT subsystem.  This provides more flexibility
+	  than altering the global timeouts.
+
+	  If unsure, say `N'.
+
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
 	depends on NETFILTER_XTABLES && NETWORK_SECMARK
diff -ruN linux-orig/net/netfilter/Makefile linux-test/net/netfilter/Makefile
--- linux-orig/net/netfilter/Makefile	2007-10-23 23:50:57.000000000 -0400
+++ linux-test/net/netfilter/Makefile	2007-11-02 16:09:36.000000000 -0400
@@ -45,6 +45,7 @@
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TIMEOUT) += xt_TIMEOUT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
diff -ruN linux-orig/net/netfilter/nf_conntrack_core.c linux-test/net/netfilter/nf_conntrack_core.c
--- linux-orig/net/netfilter/nf_conntrack_core.c	2007-11-17 12:40:48.000000000 -0500
+++ linux-test/net/netfilter/nf_conntrack_core.c	2007-11-17 12:46:24.000000000 -0500
@@ -544,6 +544,9 @@
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 		conntrack->secmark = exp->master->secmark;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+		conntrack->xt_target_timeout = exp->master->xt_target_timeout;
+#endif
 		nf_conntrack_get(&conntrack->master->ct_general);
 		NF_CT_STAT_INC(expect_new);
 	} else {
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_tcp.c linux-test/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_tcp.c	2007-10-23 23:50:57.000000000 -0400
+++ linux-test/net/netfilter/nf_conntrack_proto_tcp.c	2007-11-16 19:41:43.000000000 -0500
@@ -944,6 +944,11 @@
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	if (conntrack->xt_target_timeout
+	    && new_state == TCP_CONNTRACK_ESTABLISHED)
+		timeout = conntrack->xt_target_timeout;
+#endif
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
diff -ruN linux-orig/net/netfilter/nf_conntrack_proto_udp.c linux-test/net/netfilter/nf_conntrack_proto_udp.c
--- linux-orig/net/netfilter/nf_conntrack_proto_udp.c	2007-10-23 23:50:57.000000000 -0400
+++ linux-test/net/netfilter/nf_conntrack_proto_udp.c	2007-11-17 12:48:03.000000000 -0500
@@ -74,11 +74,18 @@
 		      int pf,
 		      unsigned int hooknum)
 {
+	unsigned long timeout;
+
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+		timeout = nf_ct_udp_timeout_stream;
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+		if (conntrack->xt_target_timeout)
+			timeout = conntrack->xt_target_timeout;
+#endif
 		nf_ct_refresh_acct(conntrack, ctinfo, skb,
-				   nf_ct_udp_timeout_stream);
+				   timeout);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
 			nf_conntrack_event_cache(IPCT_STATUS, skb);
diff -ruN linux-orig/net/netfilter/xt_TIMEOUT.c linux-test/net/netfilter/xt_TIMEOUT.c
--- linux-orig/net/netfilter/xt_TIMEOUT.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-test/net/netfilter/xt_TIMEOUT.c	2007-11-17 12:50:42.000000000 -0500
@@ -0,0 +1,92 @@
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
+	const struct xt_timeout_info *timeoutinfo = targinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct)
+		ct->xt_target_timeout = timeoutinfo->timeout * HZ;
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
+	const struct xt_timeout_info *timeoutinfo = targinfo;
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
+		.targetsize	= sizeof(struct xt_timeout_info),
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "TIMEOUT",
+		.family		= AF_INET6,
+		.checkentry	= checkentry,
+		.destroy	= destroy,
+		.target		= target,
+		.targetsize	= sizeof(struct xt_timeout_info),
+		.me		= THIS_MODULE
+	},
+};
+
+static int __init xt_timeout_init(void)
+{
+	return xt_register_targets(xt_timeout,
+				   ARRAY_SIZE(xt_timeout));
+}
+
+static void __exit xt_timeout_fini(void)
+{
+	xt_unregister_targets(xt_timeout,
+			      ARRAY_SIZE(xt_timeout));
+}
+
+module_init(xt_timeout_init);
+module_exit(xt_timeout_fini);

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xt_TIMEOUT-user

diff -ruN ipt-orig/extensions/libxt_TIMEOUT.c ipt-new/extensions/libxt_TIMEOUT.c
--- ipt-orig/extensions/libxt_TIMEOUT.c	1969-12-31 16:00:00.000000000 -0800
+++ ipt-new/extensions/libxt_TIMEOUT.c	2007-11-17 09:57:16.000000000 -0800
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
+	struct xt_timeout_info *info = (struct xt_timeout_info *) (*target)->data;
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
+	const struct xt_timeout_info *info = 
+		(struct xt_timeout_info *) target->data;
+
+	printf("--timeout %u ", info->timeout);
+}
+
+static void TIMEOUT_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
+{
+	const struct xt_timeout_info *info =
+		(struct xt_timeout_info *) target->data;
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
+	.size		= XT_ALIGN(sizeof(struct xt_timeout_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_timeout_info)),
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
+++ ipt-new/include/linux/netfilter/xt_TIMEOUT.h	2007-11-16 16:56:03.000000000 -0800
@@ -0,0 +1,8 @@
+#ifndef _XT_TIMEOUT_H
+#define _XT_TIMEOUT_H
+
+struct xt_timeout_info {
+	u_int32_t	timeout;
+};
+
+#endif /*_XT_TIMEOUT_H*/

--gBBFr7Ir9EOA20Yy--
