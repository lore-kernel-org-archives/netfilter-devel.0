From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] CLASSIFY target
Date: Tue, 08 Apr 2003 18:04:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E92F2F8.1020707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050104030600000303040505"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050104030600000303040505
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a new target "CLASSIFY" which sets skb->priority.
Several qdiscs can use this for classification. A list of the qdiscs
currently capable of doing so is in the help text. Please consider
for inclusion.

Bye,
Patrick


--------------050104030600000303040505
Content-Type: text/plain;
 name="nf-CLASSIFY.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-CLASSIFY.diff"

diff -urN a/patch-o-matic/extra/CLASSIFY.patch b/patch-o-matic/extra/CLASSIFY.patch
--- a/patch-o-matic/extra/CLASSIFY.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/CLASSIFY.patch	2003-04-07 21:53:09.000000000 +0200
@@ -0,0 +1,83 @@
+diff -urN linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_CLASSIFY.h linux-2.4.20_nfclassify/include/linux/netfilter_ipv4/ipt_CLASSIFY.h
+--- linux-2.4.20-clean/include/linux/netfilter_ipv4/ipt_CLASSIFY.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20_nfclassify/include/linux/netfilter_ipv4/ipt_CLASSIFY.h	2003-01-25 02:11:35.000000000 +0100
+@@ -0,0 +1,8 @@
++#ifndef _IPT_CLASSIFY_H
++#define _IPT_CLASSIFY_H
++
++struct ipt_classify_target_info {
++	unsigned int priority;
++};
++
++#endif /*_IPT_CLASSIFY_H */
+diff -urN linux-2.4.20-clean/net/ipv4/netfilter/ipt_CLASSIFY.c linux-2.4.20_nfclassify/net/ipv4/netfilter/ipt_CLASSIFY.c
+--- linux-2.4.20-clean/net/ipv4/netfilter/ipt_CLASSIFY.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.20_nfclassify/net/ipv4/netfilter/ipt_CLASSIFY.c	2003-01-25 02:09:36.000000000 +0100
+@@ -0,0 +1,67 @@
++/* This is a module which is used for setting the skb->priority field of an skb for qdisc classification. */
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <net/checksum.h>
++
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_CLASSIFY.h>
++
++static unsigned int
++target(struct sk_buff **pskb,
++       unsigned int hooknum,
++       const struct net_device *in,
++       const struct net_device *out,
++       const void *targinfo,
++       void *userinfo)
++{
++	const struct ipt_classify_target_info *clinfo = targinfo;
++
++	if((*pskb)->priority != clinfo->priority) {
++		(*pskb)->priority = clinfo->priority;
++		(*pskb)->nfcache |= NFC_ALTERED;
++	}
++	return IPT_CONTINUE;
++}
++
++static int
++checkentry(const char *tablename,
++	   const struct ipt_entry *e,
++           void *targinfo,
++           unsigned int targinfosize,
++           unsigned int hook_mask)
++{
++	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_classify_target_info))) {
++		printk(KERN_WARNING "CLASSIFY: targinfosize %u != %Zu\n",
++		       targinfosize,
++		       IPT_ALIGN(sizeof(struct ipt_classify_target_info)));
++		return 0;
++	}
++
++	if (strcmp(tablename, "mangle") != 0) {
++		printk(KERN_WARNING "CLASSIFY: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_target ipt_classify_reg
++= { { NULL, NULL }, "CLASSIFY", target, checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	if (ipt_register_target(&ipt_classify_reg))
++		return -EINVAL;
++
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_target(&ipt_classify_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
diff -urN a/patch-o-matic/extra/CLASSIFY.patch.config.in b/patch-o-matic/extra/CLASSIFY.patch.config.in
--- a/patch-o-matic/extra/CLASSIFY.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/CLASSIFY.patch.config.in	2003-04-07 21:53:09.000000000 +0200
@@ -0,0 +1,2 @@
+    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CONFIG_IP_NF_MANGLE
+    dep_tristate '    CLASSIFY target support (EXPERIMENTAL)' CONFIG_IP_NF_TARGET_CLASSIFY $CONFIG_IP_NF_FILTER
diff -urN a/patch-o-matic/extra/CLASSIFY.patch.help b/patch-o-matic/extra/CLASSIFY.patch.help
--- a/patch-o-matic/extra/CLASSIFY.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/CLASSIFY.patch.help	2003-04-07 21:59:52.000000000 +0200
@@ -0,0 +1,16 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: working
+
+This patch adds support for the CLASSIFY target which sets skb->priority.
+Some qdiscs can use this value for classification, among these are
+
+- atm
+- cbq
+- dsmark
+- pfifo_fast
+- htb
+- prio
+
+Usage:
+	iptables -t mangle ... -j CLASSIFY --set-class MAJOR:MINOR
+
diff -urN a/patch-o-matic/extra/CLASSIFY.patch.makefile b/patch-o-matic/extra/CLASSIFY.patch.makefile
--- a/patch-o-matic/extra/CLASSIFY.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ b/patch-o-matic/extra/CLASSIFY.patch.makefile	2003-04-07 21:53:09.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_MIRROR) += ipt_MIRROR.o
+obj-$(CONFIG_IP_NF_TARGET_CLASSIFY) += ipt_CLASSIFY.o
diff -urN a/userspace/extensions/.CLASSIFY-test b/userspace/extensions/.CLASSIFY-test
--- a/userspace/extensions/.CLASSIFY-test	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/.CLASSIFY-test	2003-04-07 21:53:09.000000000 +0200
@@ -0,0 +1,3 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CLASSIFY.c ] && echo CLASSIFY
+
diff -urN a/userspace/extensions/libipt_CLASSIFY.c b/userspace/extensions/libipt_CLASSIFY.c
--- a/userspace/extensions/libipt_CLASSIFY.c	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/extensions/libipt_CLASSIFY.c	2003-04-07 21:53:09.000000000 +0200
@@ -0,0 +1,130 @@
+/* Shared library add-on to iptables to add CLASSIFY target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_CLASSIFY.h>
+#include <linux/types.h>
+#include <linux/pkt_sched.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"CLASSIFY target v%s options:\n"
+"  --set-class [MAJOR:MINOR]    Set skb->priority value\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "set-class", 1, 0, '1' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+int string_to_priority(const unsigned char *s, unsigned int *p)
+{
+	unsigned int i, j;
+
+	if (sscanf(s, "%x:%x", &i, &j) != 2)
+		return 1;
+	
+	*p = TC_H_MAKE(i<<16, j);
+	return 0;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_classify_target_info *clinfo
+		= (struct ipt_classify_target_info *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (string_to_priority(optarg, &clinfo->priority))
+			exit_error(PARAMETER_PROBLEM,
+				   "Bad class value `%s'", optarg);
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "CLASSIFY: Can't specify --set-class twice");
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+		           "CLASSIFY: Parameter --set-class is required");
+}
+
+static void
+print_class(unsigned int priority, int numeric)
+{
+	printf("%x:%x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+	const struct ipt_classify_target_info *clinfo =
+		(const struct ipt_classify_target_info *)target->data;
+	printf("CLASSIFY set ");
+	print_class(clinfo->priority, numeric);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	const struct ipt_classify_target_info *clinfo =
+		(const struct ipt_classify_target_info *)target->data;
+
+	printf("--set-class %.4x:%.4x ",
+	       TC_H_MAJ(clinfo->priority)>>16, TC_H_MIN(clinfo->priority));
+}
+
+static
+struct iptables_target classify
+= { NULL,
+    "CLASSIFY",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_classify_target_info)),
+    IPT_ALIGN(sizeof(struct ipt_classify_target_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_target(&classify);
+}

--------------050104030600000303040505--
