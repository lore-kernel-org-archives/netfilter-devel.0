From: Patrick McHardy <kaber@trash.net>
Subject: [NEW TARGET]: CLASSIFY
Date: Thu, 30 Jan 2003 09:16:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E38DF6A.3000504@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020404010703090001040402"
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
--------------020404010703090001040402
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've written the attached target a couple of days ago for someone else.
It is used to classify packets for qdiscs by setting skb->priority. i 
haven't
tested it myself but according to Abraham van der Merwe who cared to test
it "works great".
I think other people might consider this useful, please consider for 
inclusion
in patch-o-matic.

Regards,
Patrick


--------------020404010703090001040402
Content-Type: text/plain;
 name="nf_CLASSIFY.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf_CLASSIFY.diff"

diff -urN netfilter-clean/patch-o-matic/extra/CLASSIFY.patch netfilter/patch-o-matic/extra/CLASSIFY.patch
--- netfilter-clean/patch-o-matic/extra/CLASSIFY.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/CLASSIFY.patch	2003-01-25 12:31:35.000000000 +0100
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
diff -urN netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.config.in netfilter/patch-o-matic/extra/CLASSIFY.patch.config.in
--- netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/CLASSIFY.patch.config.in	2003-01-25 12:33:24.000000000 +0100
@@ -0,0 +1,2 @@
+    dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CONFIG_IP_NF_MANGLE
+    dep_tristate '    CLASSIFY target support (EXPERIMENTAL)' CONFIG_IP_NF_TARGET_CLASSIFY $CONFIG_IP_NF_FILTER
diff -urN netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.help netfilter/patch-o-matic/extra/CLASSIFY.patch.help
--- netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/CLASSIFY.patch.help	2003-01-25 12:31:35.000000000 +0100
@@ -0,0 +1,5 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: untested
+
+This patch adds support for the CLASSIFY target which sets skb->priority.
+Some qdiscs can use this value for classifying packets.
diff -urN netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.makefile netfilter/patch-o-matic/extra/CLASSIFY.patch.makefile
--- netfilter-clean/patch-o-matic/extra/CLASSIFY.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/CLASSIFY.patch.makefile	2003-01-25 12:31:35.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_MIRROR) += ipt_MIRROR.o
+obj-$(CONFIG_IP_NF_TARGET_CLASSIFY) += ipt_CLASSIFY.o
diff -urN netfilter-clean/userspace/extensions/.CLASSIFY-test netfilter/userspace/extensions/.CLASSIFY-test
--- netfilter-clean/userspace/extensions/.CLASSIFY-test	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.CLASSIFY-test	2003-01-25 12:31:35.000000000 +0100
@@ -0,0 +1,3 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CLASSIFY.c ] && echo CLASSIFY
+
diff -urN netfilter-clean/userspace/extensions/libipt_CLASSIFY.c netfilter/userspace/extensions/libipt_CLASSIFY.c
--- netfilter-clean/userspace/extensions/libipt_CLASSIFY.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libipt_CLASSIFY.c	2003-01-25 12:24:24.000000000 +0100
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
+	printf("%.4x:%.4x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
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

--------------020404010703090001040402--
