From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Re: TCPFLAG <New>
Date: Mon, 30 Jun 2003 11:59:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306301156001.22434@dns.toxicfilms.tv>
References: <1056887495.5490.844.camel@teratron>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Craig Shelley <craig@microtron.org.uk>
In-Reply-To: <1056887495.5490.844.camel@teratron>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Craig,

I took privilege to make a propoper CVS patch for the netfilter tree out
of the tarball you sent:

 patch-o-matic/extra/ipt_TCPFLAG.patch                |  137 ++++++++++++
 patch-o-matic/extra/ipt_TCPFLAG.patch.config.in      |    2
 patch-o-matic/extra/ipt_TCPFLAG.patch.configure.help |    7
 patch-o-matic/extra/ipt_TCPFLAG.patch.help           |   38 +++
 patch-o-matic/extra/ipt_TCPFLAG.patch.makefile       |    2
 userspace/extensions/.ipt_TCPFLAG-test               |    3
 userspace/extensions/libipt_TCPFLAG.c                |  212 +++++++++++++++++++

Craig, please look into the patch, correct ipt_TCPFLAG.patch.help and
ipt_TCPFLAG.patch.configure.help.

This is the best way of sending patches.

Note that this email does not express my judgement nor opinion about this
patch. Here goes:

diff -Nru netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch
--- netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch	2003-06-30 11:42:07.000000000 +0200
@@ -0,0 +1,137 @@
+diff -Nru linux-2.4.21.orig/include/linux/netfilter_ipv4/ipt_TCPFLAG.h linux-2.4.21/include/linux/netfilter_ipv4/ipt_TCPFLAG.h
+--- linux-2.4.21.orig/include/linux/netfilter_ipv4/ipt_TCPFLAG.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/include/linux/netfilter_ipv4/ipt_TCPFLAG.h	2002-11-01 11:01:49.000000000 +0100
+@@ -0,0 +1,17 @@
++/*
++ * TCP FLAG modification (Craig Shelley)
++ */
++
++#define TCPFLAG_FIN 1
++#define TCPFLAG_SYN 2
++#define TCPFLAG_RST 4
++#define TCPFLAG_PSH 8
++#define TCPFLAG_ACK 16
++#define TCPFLAG_URG 32
++#define TCPFLAG_ALL 63
++
++struct ipt_TCPFLAG_info
++{
++        u_int8_t mask;
++	u_int8_t comp;
++};
+diff -Nru linux-2.4.21.orig/net/ipv4/netfilter/ipt_TCPFLAG.c linux-2.4.21/net/ipv4/netfilter/ipt_TCPFLAG.c
+--- linux-2.4.21.orig/net/ipv4/netfilter/ipt_TCPFLAG.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.4.21/net/ipv4/netfilter/ipt_TCPFLAG.c	2003-05-02 21:05:54.000000000 +0200
+@@ -0,0 +1,112 @@
++/*
++ * This is a module which is used to modify the TCP flags of packets.
++ * by Craig Shelley (craig@microtron.ath.cx)
++ * based on TTL modification module by Harald Welte
++ * To be distributed under the terms of the GNU GPL
++ */
++
++#include <linux/config.h>
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++#include <net/icmp.h>
++#include <net/ip.h>
++#include <net/tcp.h>
++struct in_device;
++#include <net/route.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_TCPFLAG.h>
++
++MODULE_AUTHOR("Craig Shelley <craigshelley@yahoo.com>");
++MODULE_DESCRIPTION("IP tables TCPFLAG modification module");
++MODULE_LICENSE("GPL");
++
++static unsigned int ipt_tcpflag_target(struct sk_buff **pskb, unsigned int hooknum,
++		const struct net_device *in, const struct net_device *out,
++		const void *targinfo, void *userinfo)
++{
++	const struct ipt_TCPFLAG_info *info = targinfo;
++	struct iphdr *iph;
++	struct tcphdr *tcph;
++	void *th;
++
++	iph = (*pskb)->nh.iph;
++	tcph = (struct tcphdr *)((u_int32_t*)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl);
++	th = (u_int32_t *)iph + iph->ihl;
++
++	/*Modify the TCP FLAGS to the masks and comps*/
++
++
++	if (info->mask & TCPFLAG_FIN) tcph->fin = ((info->comp & TCPFLAG_FIN) == TCPFLAG_FIN);
++	if (info->mask & TCPFLAG_SYN) tcph->syn = ((info->comp & TCPFLAG_SYN) == TCPFLAG_SYN);
++	if (info->mask & TCPFLAG_RST) tcph->rst = ((info->comp & TCPFLAG_RST) == TCPFLAG_RST);
++	if (info->mask & TCPFLAG_PSH) tcph->psh = ((info->comp & TCPFLAG_PSH) == TCPFLAG_PSH);
++	if (info->mask & TCPFLAG_ACK) tcph->ack = ((info->comp & TCPFLAG_ACK) == TCPFLAG_ACK);
++	if (info->mask & TCPFLAG_URG) tcph->urg = ((info->comp & TCPFLAG_URG) == TCPFLAG_URG);
++
++
++	/*Produce a new TCP checksum*/
++
++	tcph->check = 0;
++	tcph->check = tcp_v4_check(
++		th,
++		(*pskb)->len - 4*iph->ihl,
++		iph->saddr,
++		iph->daddr,
++		csum_partial(
++			(char *)th,
++			(*pskb)->len - 4*iph->ihl,
++			0));
++
++
++	return IPT_CONTINUE;
++
++}
++
++
++static int ipt_tcpflag_checkentry(const char *tablename,
++				const struct ipt_entry *e,
++				void *targinfo,
++				unsigned int targinfosize,
++				unsigned int hook_mask)
++{
++	struct ipt_TCPFLAG_info *info = targinfo;
++
++	if (strcmp(tablename, "mangle"))
++	{
++		printk(KERN_WARNING "TCPFLAG: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
++		return 0;
++	}
++
++	if (info->mask == 0)
++	{
++		printk(KERN_WARNING "TCPFLAG: NULL mask not allowed\n");
++		return 0;
++	}
++
++	if ( (~ info->mask) & info->comp)
++	{
++		printk(KERN_WARNING "TCPFLAG: Unmasked flags not allowed\n");
++		return 0;
++	}
++
++
++	return 1;
++}
++
++static struct ipt_target ipt_TCPFLAG = { { NULL, NULL }, "TCPFLAG",
++	ipt_tcpflag_target, ipt_tcpflag_checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	return ipt_register_target(&ipt_TCPFLAG);
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_target(&ipt_TCPFLAG);
++}
++
++module_init(init);
++module_exit(fini);
++
diff -Nru netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.config.in netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.config.in
--- netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.config.in	2003-06-30 11:43:34.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
+  dep_tristate '  TCPFLAG target support' CONFIG_IP_NF_TARGET_TCPFLAG $CONFIG_IP_NF_IPTABLES
diff -Nru netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.configure.help netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.configure.help	2003-06-30 11:50:31.000000000 +0200
@@ -0,0 +1,7 @@
+CONFIG_IP_NF_TARGET_LOG
+TCPFLAG target support
+CONFIG_IP_NF_TARGET_TCPFLAG
+  This option adds a `TCPFLAG' target.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.makefile netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.makefile
--- netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.makefile	2003-06-30 11:44:02.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_TCPFLAG) += ipt_TCPFLAG.o
diff -Nru netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.help netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.help
--- netfilter.orig/patch-o-matic/extra/ipt_TCPFLAG.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/ipt_TCPFLAG.patch.help	2003-06-30 11:50:22.000000000 +0200
@@ -0,0 +1,38 @@
+Author: Craig Shelley <craig@microtron.org.uk>
+Status: Working, has a bug noted below.
+
+This adds CONFIG_IP_NF_TARGET_TCPFLAG option.
+
+Quote from the author:
+I use this module to open connections through a packet filter firewall
+that is unfortunately between two of my boxes. The firewall drops all
+inbound packets with the SYN flag set, so I use TCPFLAG masquerade SYN
+packets as RST packets. (A bit crude, but it does the job!)
+At the receiving end, I convert the RST packets that I sent from my host
+back to SYN packets.
+
+The target manipulates the flags using two parameters. The first
+parameter being the mask (the flags that will be modified), and the
+second parameter is the flags in the mask that will be turned on.
+This method provides flexibility,
+and is similar to the syntax of --tcp-flags
+
+Here is an example of what I run on the machine outside the firewall...
+
+iptables -t mangle -A POSTROUTING -d 123.123.123.123 -p tcp --tcp-flags
+FIN,SYN,RST,ACK SYN -j TCPFLAG --mask SYN,RST --comp RST
+
+And here's what I run on the machine behind the firewall...
+
+iptables -t mangle -A PREROUTING -s 195.137.47.43 -p tcp --tcp-flags
+FIN,SYN,RST,ACK RST -j TCPFLAG --mask SYN,RST --comp SYN
+
+This module probably has some other uses, but I haven't thought of any.
+
+The only bug I know of is that it doesn't handle connection tracking at
+all :( so one of the machines (I can't remember which) does not see the
+connection being made.  (nor does the firewall for that matter)
+Since I am only using this code to do a temporary job, I don't
+anticipate maintaining it. This is the reason I have not submitted it
+before.
+
diff -Nru netfilter.orig/userspace/extensions/.ipt_TCPFLAG-test netfilter/userspace/extensions/.ipt_TCPFLAG-test
--- netfilter.orig/userspace/extensions/.ipt_TCPFLAG-test	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.ipt_TCPFLAG-test	2003-06-30 11:39:28.000000000 +0200
@@ -0,0 +1,3 @@
+#!/bin/sh
+# True if TCPFLAG is applied.
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_TCPFLAG.h ] && echo TCPFLAG
diff -Nru netfilter.orig/userspace/extensions/libipt_TCPFLAG.c netfilter/userspace/extensions/libipt_TCPFLAG.c
--- netfilter.orig/userspace/extensions/libipt_TCPFLAG.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libipt_TCPFLAG.c	2003-05-02 21:08:43.000000000 +0200
@@ -0,0 +1,212 @@
+/*
+ * Userspace library for the TCPFLAG target module
+ * by Craig Shelley (craig@microtron.ath.cx)
+ * based on the TTL target module by Harald Welte
+ *
+ * To be Distributed under the terms of the GNU GPL
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_TCPFLAG.h>
+
+#define IPT_TCPFLAG_USED 1
+
+
+static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+        printf(
+"TCPFLAG v%s options:\n"
+" --mask mask  --comp comp	Modify TCP flags specified in mask\n"
+"				turn on all flags present in mask and comp\n"
+"				turn off all flags present in mask but not comp\n"
+"				all other flags are not affected\n"
+"                               (Flags: SYN ACK FIN RST URG PSH ALL NONE)\n",
+IPTABLES_VERSION);
+}
+
+
+
+
+char parse_tcp_flags(const char *flagstring)
+{
+	char *ptr, *buffer, tcp_flags=0;
+
+        buffer = strdup(flagstring);
+
+	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
+
+		if (strcasecmp(ptr,"FIN") == 0) tcp_flags |= TCPFLAG_FIN;
+		if (strcasecmp(ptr,"SYN") == 0) tcp_flags |= TCPFLAG_SYN;
+		if (strcasecmp(ptr,"RST") == 0) tcp_flags |= TCPFLAG_RST;
+		if (strcasecmp(ptr,"PSH") == 0) tcp_flags |= TCPFLAG_PSH;
+		if (strcasecmp(ptr,"ACK") == 0) tcp_flags |= TCPFLAG_ACK;
+		if (strcasecmp(ptr,"URG") == 0) tcp_flags |= TCPFLAG_URG;
+		if (strcasecmp(ptr,"ALL") == 0) tcp_flags |= TCPFLAG_ALL;
+
+		if (	strcasecmp(ptr,"SYN") &&
+			strcasecmp(ptr,"ACK") &&
+			strcasecmp(ptr,"FIN") &&
+			strcasecmp(ptr,"RST") &&
+			strcasecmp(ptr,"URG") &&
+			strcasecmp(ptr,"PSH") &&
+			strcasecmp(ptr,"ALL") &&
+			strcasecmp(ptr,"NONE")	)
+			exit_error(PARAMETER_PROBLEM,
+                                   "Unknown TCP flag `%s'", buffer);
+	}
+        free(buffer);
+
+	return tcp_flags;
+}
+
+
+void output_tcp_flags(char tcp_flags)
+{
+	if ((tcp_flags & TCPFLAG_ALL) == TCPFLAG_ALL)
+	{
+		printf("ALL");
+		return;
+	}
+	if ((tcp_flags & TCPFLAG_ALL) == 0)
+	{
+		printf("NONE");
+		return;
+	}
+	if (tcp_flags & TCPFLAG_FIN) printf("FIN");
+	if ((tcp_flags & (TCPFLAG_FIN | TCPFLAG_SYN))
+			== (TCPFLAG_FIN | TCPFLAG_SYN)) printf(",");
+	if (tcp_flags & TCPFLAG_SYN) printf("SYN");
+	if ((tcp_flags & (TCPFLAG_SYN | TCPFLAG_RST))
+			== (TCPFLAG_SYN | TCPFLAG_RST)) printf(",");
+	if (tcp_flags & TCPFLAG_RST) printf("RST");
+	if ((tcp_flags & (TCPFLAG_RST | TCPFLAG_PSH))
+			== (TCPFLAG_RST | TCPFLAG_PSH)) printf(",");
+	if (tcp_flags & TCPFLAG_PSH) printf("PSH");
+	if ((tcp_flags & (TCPFLAG_PSH | TCPFLAG_ACK))
+			== (TCPFLAG_PSH | TCPFLAG_ACK)) printf(",");
+	if (tcp_flags & TCPFLAG_ACK) printf("ACK");
+	if ((tcp_flags & (TCPFLAG_ACK | TCPFLAG_URG))
+			== (TCPFLAG_ACK | TCPFLAG_URG)) printf(",");
+	if (tcp_flags & TCPFLAG_URG) printf("URG");
+}
+
+static void final_check(unsigned int flags)
+{
+        if (flags != 3)
+                exit_error(PARAMETER_PROBLEM,
+                                "TCPFLAG: You must specify some flag modifiers");
+}
+
+
+/* Function which parses command options; returns true if it
+   ate an option. */
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ipt_entry *entry,
+	struct ipt_entry_target **target)
+{
+        struct ipt_TCPFLAG_info *info = (struct ipt_TCPFLAG_info *) (*target)->data;
+
+	check_inverse(optarg, &invert, &optind, 0);
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+				"TCPFLAG: unexpected '!'");
+
+
+	switch (c) {
+
+	case '1':
+		if (*flags & 1)
+			exit_error(PARAMETER_PROBLEM,
+				"TCPFLAG: --mask can only be specified once");
+
+		info->mask = parse_tcp_flags(optarg);
+
+		*flags |= 1;
+		break;
+	case '2':
+		if (*flags & 2)
+			exit_error(PARAMETER_PROBLEM,
+				"TCPFLAG: --comp can only be specified once");
+
+		info->comp = parse_tcp_flags(optarg);
+
+		*flags |= 2;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+
+
+
+static void save(const struct ipt_ip *ip,
+        const struct ipt_entry_target *target)
+{
+        const struct ipt_TCPFLAG_info *info =
+                (struct ipt_TCPFLAG_info *) target->data;
+
+	printf("--mask ");
+	output_tcp_flags(info->mask);
+
+	printf(" --comp ");
+	output_tcp_flags(info->comp);
+}
+
+static void print(const struct ipt_ip *ip,
+	const struct ipt_entry_target *target, int numeric)
+{
+	const struct ipt_TCPFLAG_info *info =
+		(struct ipt_TCPFLAG_info *) target->data;
+
+	printf("TCPFLAG mask ");
+	output_tcp_flags(info->mask);
+	printf(" comp ");
+	output_tcp_flags(info->comp);
+	printf (" ");
+}
+
+
+static struct option opts[] = {
+        { "mask", 1, 0, '1'},
+	{ "comp", 1, 0, '2'},
+        {0}
+};
+
+static
+struct iptables_target TCPFLAG = { NULL,
+        "TCPFLAG",
+        IPTABLES_VERSION,
+        IPT_ALIGN(sizeof(struct ipt_TCPFLAG_info)),
+        IPT_ALIGN(sizeof(struct ipt_TCPFLAG_info)),
+        &help,
+        &init,
+        &parse,
+        &final_check,
+        &print,
+        &save,
+        opts
+};
+
+void _init(void)
+{
+        register_target(&TCPFLAG);
+}
+
