From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] New target: DUMP
Date: Tue, 3 Jun 2003 19:35:43 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306031932430.18676@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I wrote a target to DUMP packets in a tcpdump -x -X style:
It supports prefixes (like LOG) and length of the packet to dump.
This patch introduces both ipv4 and ipv6 versions.

# diffstat DUMP.patch
 patch-o-matic/extra/DUMP.patch                     |  179 ++++++++++++++++++++
 patch-o-matic/extra/DUMP.patch.config.in           |    2
 patch-o-matic/extra/DUMP.patch.configure.help      |    7
 patch-o-matic/extra/DUMP.patch.help                |   10 +
 patch-o-matic/extra/DUMP.patch.ipv6                |  180 +++++++++++++++++++++
 patch-o-matic/extra/DUMP.patch.ipv6.config.in      |    2
 patch-o-matic/extra/DUMP.patch.ipv6.configure.help |    7
 patch-o-matic/extra/DUMP.patch.ipv6.help           |   10 +
 patch-o-matic/extra/DUMP.patch.ipv6.makefile       |    2
 patch-o-matic/extra/DUMP.patch.makefile            |    2
 userspace/extensions/.DUMP-test                    |    2
 userspace/extensions/.DUMP-test6                   |    2
 userspace/extensions/libip6t_DUMP.c                |  158 ++++++++++++++++++
 userspace/extensions/libipt_DUMP.c                 |  158 ++++++++++++++++++
 14 files changed, 721 insertions(+)

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch netfilter/patch-o-matic/extra/DUMP.patch
--- netfilter.orig/patch-o-matic/extra/DUMP.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch	2003-06-03 18:57:13.000000000 +0200
@@ -0,0 +1,179 @@
+diff -Nru linux-2.5.68/include/linux/netfilter_ipv4/ipt_DUMP.h linux-2.5.70/include/linux/netfilter_ipv4/ipt_DUMP.h
+--- linux-2.5.68/include/linux/netfilter_ipv4/ipt_DUMP.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.5.70/include/linux/netfilter_ipv4/ipt_DUMP.h	2003-06-03 17:36:19.000000000 +0200
+@@ -0,0 +1,9 @@
++#ifndef _IPT_DUMP_H
++#define _IPT_DUMP_H
++
++struct ipt_dump_info {
++	int length;
++	char prefix[30];
++};
++
++#endif /*_IPT_DUMP_H*/
+diff -Nru linux-2.5.68/net/ipv4/netfilter/ipt_DUMP.c linux-2.5.70/net/ipv4/netfilter/ipt_DUMP.c
+--- linux-2.5.68/net/ipv4/netfilter/ipt_DUMP.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.5.70/net/ipv4/netfilter/ipt_DUMP.c	2003-06-03 18:16:24.000000000 +0200
+@@ -0,0 +1,162 @@
++/*
++ * Hi, how are you ?
++ * My dame is ipt_DUMP and I dump packets to the logs
++ */
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/spinlock.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_DUMP.h>
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++/* This gives the tcpdump look and feel */
++#define GRAIN	16
++
++static spinlock_t dump_lock = SPIN_LOCK_UNLOCKED;
++
++//static void add_line(unsigned char *ptr, int str);
++//static void dump_packet(unsigned char *data, int len);
++
++static void add_line(unsigned char *ptr, int str)
++{
++	int orig_str = str;
++	int pptr = GRAIN;
++	unsigned char *orig_ptr=ptr;
++	while(pptr > 0)
++	{
++		if (str > 0)
++			printk("%02x", *ptr);
++		else
++			printk("  ");
++		ptr++;
++		str--;
++		pptr--;
++
++		if (str > 0)
++			printk("%02x", *ptr);
++		else
++			printk("  ");
++		printk(" ");
++
++		ptr++;
++		str--;
++		pptr--;
++	}
++	ptr = orig_ptr;
++	pptr = GRAIN;
++	printk("        ");
++	while(pptr > 0)
++	{
++		if (orig_str>0)
++		{
++			if (*ptr < '!' || *ptr > 'z')
++				printk(".");
++			else
++				printk("%c", *ptr);
++		}
++		else
++			printk(" ");
++		orig_str--;
++		ptr++;
++		pptr--;
++	}
++	printk("\n");
++	return;
++}
++
++static void dump_packet(unsigned char *data, int len)
++{
++	int pos=0, str=0;
++	unsigned char *ptr;
++
++	ptr = data;
++	while (pos < len)
++	{
++		if (pos % GRAIN == 0)
++			printk("0x%03X0   ", pos / GRAIN);
++
++		str = (len-pos) < GRAIN ? len-pos : GRAIN;
++		add_line(ptr, str);
++		pos += str;
++		ptr += str;
++	}
++	return;
++}
++
++static unsigned int
++ipt_dump_target(struct sk_buff **pskb,
++	       const struct net_device *in,
++	       const struct net_device *out,
++	       unsigned int hooknum,
++	       const void *targinfo,
++	       void *userinfo)
++{
++	const struct ipt_dump_info *dumpinfo = targinfo;
++	int len = (*pskb)->len;
++
++	if (dumpinfo->length != -1)
++		len = dumpinfo->length < len ? dumpinfo->length : len;
++
++	spin_lock_bh(&dump_lock);
++
++	printk("DUMP: %s\n", dumpinfo->prefix);
++	dump_packet((char *) (*pskb)->nh.raw, len);
++	printk("\n");
++	spin_unlock_bh(&dump_lock);
++
++	return IPT_CONTINUE;
++}
++
++static int ipt_dump_checkentry(const char *tablename,
++			      const struct ipt_entry *e,
++			      void *targinfo,
++			      unsigned int targinfosize,
++			      unsigned int hook_mask)
++{
++	const struct ipt_dump_info *dumpinfo = targinfo;
++
++	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_dump_info))) {
++		DEBUGP("DUMP: targinfosize %u != %u\n",
++		       targinfosize, IPT_ALIGN(sizeof(struct ipt_dump_info)));
++		return 0;
++	}
++
++	if (dumpinfo->prefix[sizeof(dumpinfo->prefix)-1] != '\0') {
++		DEBUGP("DUMP: prefix term %i\n",
++		       dumpinfo->prefix[sizeof(dumpinfo->prefix)-1]);
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ipt_target ipt_dump_reg = {
++	.name		= "DUMP",
++	.target		= ipt_dump_target,
++	.checkentry	= ipt_dump_checkentry,
++	.me		= THIS_MODULE,
++};
++
++static int __init init(void)
++{
++	if (ipt_register_target(&ipt_dump_reg))
++		return -EINVAL;
++
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_target(&ipt_dump_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
++MODULE_DESCRIPTION("IP tables DUMP module");
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.config.in netfilter/patch-o-matic/extra/DUMP.patch.config.in
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.config.in	2003-06-03 19:15:10.000000000 +0200
@@ -0,0 +1,2 @@
+    dep_tristate '  Unclean match support (EXPERIMENTAL)' CONFIG_IP_NF_MATCH_UNCLEAN $CONFIG_IP_NF_IPTABLES
+    dep_tristate '  DUMP target support' CONFIG_IP_NF_TARGET_DUMP $CONFIG_IP_NF_FILTER
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.configure.help netfilter/patch-o-matic/extra/DUMP.patch.configure.help
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.configure.help	2003-06-03 19:07:01.000000000 +0200
@@ -0,0 +1,7 @@
+CONFIG_IP_NF_TARGET_LOG
+DUMP target support
+CONFIG_IP_NF_TARGET_DUMP
+  This module allows you to dump packets to the log file.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.help netfilter/patch-o-matic/extra/DUMP.patch.help
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.help	2003-06-03 19:11:02.000000000 +0200
@@ -0,0 +1,10 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: First release, open for improvements, although it works fine.
+
+This patch adds a DUMP target which allows to dump matched packet
+content to the logs in a tcpdump -x -X style.
+
+Examples:
+# iptables -A INPUT -p udp -j DUMP --dump-prefix "Dump #1" --dump-length 150
+
+This is an IPv4 version.
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6 netfilter/patch-o-matic/extra/DUMP.patch.ipv6
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.ipv6	2003-06-03 18:57:31.000000000 +0200
@@ -0,0 +1,180 @@
+diff -Nru linux-2.5.68/include/linux/netfilter_ipv6/ip6t_DUMP.h linux-2.5.70/include/linux/netfilter_ipv6/ip6t_DUMP.h
+--- linux-2.5.68/include/linux/netfilter_ipv6/ip6t_DUMP.h	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.5.70/include/linux/netfilter_ipv6/ip6t_DUMP.h	2003-06-03 18:19:23.000000000 +0200
+@@ -0,0 +1,9 @@
++#ifndef _IP6T_DUMP_H
++#define _IP6T_DUMP_H
++
++struct ip6t_dump_info {
++	int length;
++	char prefix[30];
++};
++
++#endif /*_IP6T_DUMP_H*/
+diff -Nru linux-2.5.68/net/ipv6/netfilter/ip6t_DUMP.c linux-2.5.70/net/ipv6/netfilter/ip6t_DUMP.c
+--- linux-2.5.68/net/ipv6/netfilter/ip6t_DUMP.c	1970-01-01 01:00:00.000000000 +0100
++++ linux-2.5.70/net/ipv6/netfilter/ip6t_DUMP.c	2003-06-03 18:24:16.000000000 +0200
+@@ -0,0 +1,163 @@
++/*
++ * Hi, how are you ?
++ * My dame is ip6t_DUMP and I dump packets to the logs
++ *
++ */
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/spinlock.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_DUMP.h>
++
++#if 0
++#define DEBUGP printk
++#else
++#define DEBUGP(format, args...)
++#endif
++
++/* This gives the tcpdump look and feel: 16 octets per line */
++#define GRAIN	16
++
++static spinlock_t dump_lock = SPIN_LOCK_UNLOCKED;
++
++//static void add_line(unsigned char *ptr, int str);
++//static void dump_packet(unsigned char *data, int len);
++
++static void add_line(unsigned char *ptr, int str)
++{
++	int orig_str = str;
++	int pptr = GRAIN;
++	unsigned char *orig_ptr=ptr;
++	while(pptr > 0)
++	{
++		if (str > 0)
++			printk("%02x", *ptr);
++		else
++			printk("  ");
++		ptr++;
++		str--;
++		pptr--;
++
++		if (str > 0)
++			printk("%02x", *ptr);
++		else
++			printk("  ");
++		printk(" ");
++
++		ptr++;
++		str--;
++		pptr--;
++	}
++	ptr = orig_ptr;
++	pptr = GRAIN;
++	printk("        ");
++	while(pptr > 0)
++	{
++		if (orig_str>0)
++		{
++			if (*ptr < '!' || *ptr > 'z')
++				printk(".");
++			else
++				printk("%c", *ptr);
++		}
++		else
++			printk(" ");
++		orig_str--;
++		ptr++;
++		pptr--;
++	}
++	printk("\n");
++	return;
++}
++
++static void dump_packet(unsigned char *data, int len)
++{
++	int pos=0, str=0;
++	unsigned char *ptr;
++
++	ptr = data;
++	while (pos < len)
++	{
++		if (pos % GRAIN == 0)
++			printk("0x%03X0   ", pos / GRAIN);
++
++		str = (len-pos) < GRAIN ? len-pos : GRAIN;
++		add_line(ptr, str);
++		pos += str;
++		ptr += str;
++	}
++	return;
++}
++
++static unsigned int
++ip6t_dump_target(struct sk_buff **pskb,
++	       const struct net_device *in,
++	       const struct net_device *out,
++	       unsigned int hooknum,
++	       const void *targinfo,
++	       void *userinfo)
++{
++	const struct ip6t_dump_info *dumpinfo = targinfo;
++	int len = (*pskb)->len;
++
++	if (dumpinfo->length != -1)
++		len = dumpinfo->length < len ? dumpinfo->length : len;
++
++	spin_lock_bh(&dump_lock);
++
++	printk("DUMP: %s\n", dumpinfo->prefix);
++	dump_packet((char *) (*pskb)->nh.raw, len);
++	printk("\n");
++	spin_unlock_bh(&dump_lock);
++
++	return IP6T_CONTINUE;
++}
++
++static int ip6t_dump_checkentry(const char *tablename,
++			      const struct ip6t_entry *e,
++			      void *targinfo,
++			      unsigned int targinfosize,
++			      unsigned int hook_mask)
++{
++	const struct ip6t_dump_info *dumpinfo = targinfo;
++
++	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_dump_info))) {
++		DEBUGP("DUMP: targinfosize %u != %u\n",
++		       targinfosize, IP6T_ALIGN(sizeof(struct ip6t_dump_info)));
++		return 0;
++	}
++
++	if (dumpinfo->prefix[sizeof(dumpinfo->prefix)-1] != '\0') {
++		DEBUGP("DUMP: prefix term %i\n",
++		       dumpinfo->prefix[sizeof(dumpinfo->prefix)-1]);
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ip6t_target ip6t_dump_reg = {
++	.name		= "DUMP",
++	.target		= ip6t_dump_target,
++	.checkentry	= ip6t_dump_checkentry,
++	.me		= THIS_MODULE,
++};
++
++static int __init init(void)
++{
++	if (ip6t_register_target(&ip6t_dump_reg))
++		return -EINVAL;
++
++	return 0;
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_target(&ip6t_dump_reg);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
++MODULE_DESCRIPTION("IP tables DUMP module");
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.config.in netfilter/patch-o-matic/extra/DUMP.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.ipv6.config.in	2003-06-03 19:16:42.000000000 +0200
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  DUMP target support' CONFIG_IP6_NF_TARGET_DUMP $CONFIG_IP6_NF_FILTER
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.configure.help netfilter/patch-o-matic/extra/DUMP.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.ipv6.configure.help	2003-06-03 19:07:30.000000000 +0200
@@ -0,0 +1,7 @@
+CONFIG_IP6_NF_TARGET_LOG
+DUMP target support
+CONFIG_IP6_NF_TARGET_DUMP
+  This module allows you to dump packets to the log file.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.help netfilter/patch-o-matic/extra/DUMP.patch.ipv6.help
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.ipv6.help	2003-06-03 19:10:54.000000000 +0200
@@ -0,0 +1,10 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: First release, open for improvements, although it works fine.
+
+This patch adds a DUMP target which allows to dump matched packet
+content to the logs in a tcpdump -x -X style.
+
+Examples:
+# iptables -A INPUT -p udp -j DUMP --dump-prefix "Dump #1" --dump-length 150
+
+This is an IPv6 version.
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.makefile netfilter/patch-o-matic/extra/DUMP.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.ipv6.makefile	2003-06-03 19:10:02.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP6_NF_TARGET_DUMP) += ip6t_DUMP.o
diff -Nru netfilter.orig/patch-o-matic/extra/DUMP.patch.makefile netfilter/patch-o-matic/extra/DUMP.patch.makefile
--- netfilter.orig/patch-o-matic/extra/DUMP.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/DUMP.patch.makefile	2003-06-03 19:09:54.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_DUMP) += ipt_DUMP.o
diff -Nru netfilter.orig/userspace/extensions/.DUMP-test netfilter/userspace/extensions/.DUMP-test
--- netfilter.orig/userspace/extensions/.DUMP-test	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.DUMP-test	2003-06-03 19:11:21.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_DUMP.c ] && echo DUMP
diff -Nru netfilter.orig/userspace/extensions/.DUMP-test6 netfilter/userspace/extensions/.DUMP-test6
--- netfilter.orig/userspace/extensions/.DUMP-test6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.DUMP-test6	2003-06-03 19:11:21.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv6/netfilter/ip6t_DUMP.c ] && echo DUMP


diff -Nru netfilter.orig/userspace/extensions/libip6t_DUMP.c netfilter/userspace/extensions/libip6t_DUMP.c
--- netfilter.orig/userspace/extensions/libip6t_DUMP.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_DUMP.c	2003-06-03 19:11:22.000000000 +0200
@@ -0,0 +1,158 @@
+/* Shared library add-on to iptables to add DUMP support.
+ * (C) 2003 by Maciej Soltysiak <solt@dns.toxicfilms.tv> */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_DUMP.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"DUMP v%s options:\n"
+" --dump-prefix prefix		Prefix dump messages with this prefix.\n"
+"				Default is: Default dump.\n"
+" --dump-length length		Specify how much to dump with length.\n"
+"				Default is: -1 which mean the whole packet\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "dump-prefix", 1, 0, '1' },
+	{ "dump-length", 1, 0, '2' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_target *t, unsigned int *nfcache)
+{
+	struct ip6t_dump_info *dumpinfo = (struct ip6t_dump_info *) t->data;
+
+	dumpinfo->length = -1;
+	strcpy(dumpinfo->prefix, "Default Dump");
+
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+#define IP6T_DUMP_OPT_PREFIX 0x01
+#define IP6T_DUMP_OPT_LENGTH 0x02
+
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      struct ip6t_entry_target **target)
+{
+	struct ip6t_dump_info *dumpinfo = (struct ip6t_dump_info *)(*target)->data;
+	int value;
+
+	switch (c) {
+	case '1':
+		if (*flags & IP6T_DUMP_OPT_PREFIX)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --dump-prefix twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --dump-prefix");
+
+		if (strlen(optarg) > sizeof(dumpinfo->prefix) - 1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Maximum prefix length %u for --dump-prefix",
+				   sizeof(dumpinfo->prefix) - 1);
+
+		strcpy(dumpinfo->prefix, optarg);
+		*flags |= IP6T_DUMP_OPT_PREFIX;
+		break;
+
+	case '2':
+		if (*flags & IP6T_DUMP_OPT_LENGTH)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --dump-length twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --dump-length");
+
+		value = atoi(optarg);
+		if (value < -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "length must not be lower than -1");
+
+		dumpinfo->length = value;
+		*flags |= IP6T_DUMP_OPT_LENGTH;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_target *target,
+      int numeric)
+{
+	const struct ip6t_dump_info *dumpinfo
+		= (const struct ip6t_dump_info *)target->data;
+
+	printf("DUMP ");
+
+	if (strcmp(dumpinfo->prefix, "") != 0)
+		printf("prefix `%s' ", dumpinfo->prefix);
+
+	printf("length `%d' ", dumpinfo->length);
+
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+{
+	const struct ip6t_dump_info *dumpinfo
+		= (const struct ip6t_dump_info *)target->data;
+
+	if (strcmp(dumpinfo->prefix, "") != 0)
+		printf("--dump-prefix \"%s\" ", dumpinfo->prefix);
+
+	printf("--dump-length %d ", dumpinfo->length);
+
+}
+
+static
+struct ip6tables_target dump = {
+	.name		= "DUMP",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_dump_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_dump_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target6(&dump);
+}
diff -Nru netfilter.orig/userspace/extensions/libipt_DUMP.c netfilter/userspace/extensions/libipt_DUMP.c
--- netfilter.orig/userspace/extensions/libipt_DUMP.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libipt_DUMP.c	2003-06-03 19:11:22.000000000 +0200
@@ -0,0 +1,158 @@
+/* Shared library add-on to iptables to add DUMP support.
+ * (C) 2003 by Maciej Soltysiak <solt@dns.toxicfilms.tv> */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_DUMP.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"DUMP v%s options:\n"
+" --dump-prefix prefix		Prefix dump messages with this prefix.\n"
+"				Default is: Default dump.\n"
+" --dump-length length		Specify how much to dump with length.\n"
+"				Default is: -1 which mean the whole packet\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "dump-prefix", 1, 0, '1' },
+	{ "dump-length", 1, 0, '2' },
+	{ 0 }
+};
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+	struct ipt_dump_info *dumpinfo = (struct ipt_dump_info *) t->data;
+
+	dumpinfo->length = -1;
+	strcpy(dumpinfo->prefix, "Default Dump");
+
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+#define IPT_DUMP_OPT_PREFIX 0x01
+#define IPT_DUMP_OPT_LENGTH 0x02
+
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      struct ipt_entry_target **target)
+{
+	struct ipt_dump_info *dumpinfo = (struct ipt_dump_info *)(*target)->data;
+	int value;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPT_DUMP_OPT_PREFIX)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --dump-prefix twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --dump-prefix");
+
+		if (strlen(optarg) > sizeof(dumpinfo->prefix) - 1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Maximum prefix length %u for --dump-prefix",
+				   sizeof(dumpinfo->prefix) - 1);
+
+		strcpy(dumpinfo->prefix, optarg);
+		*flags |= IPT_DUMP_OPT_PREFIX;
+		break;
+
+	case '2':
+		if (*flags & IPT_DUMP_OPT_LENGTH)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --dump-length twice");
+
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --dump-length");
+
+		value = atoi(optarg);
+		if (value < -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "length must not be lower than -1");
+
+		dumpinfo->length = value;
+		*flags |= IPT_DUMP_OPT_LENGTH;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; nothing. */
+static void final_check(unsigned int flags)
+{
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_target *target,
+      int numeric)
+{
+	const struct ipt_dump_info *dumpinfo
+		= (const struct ipt_dump_info *)target->data;
+
+	printf("DUMP ");
+
+	if (strcmp(dumpinfo->prefix, "") != 0)
+		printf("prefix `%s' ", dumpinfo->prefix);
+
+	printf("length `%d' ", dumpinfo->length);
+
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	const struct ipt_dump_info *dumpinfo
+		= (const struct ipt_dump_info *)target->data;
+
+	if (strcmp(dumpinfo->prefix, "") != 0)
+		printf("--dump-prefix \"%s\" ", dumpinfo->prefix);
+
+	printf("--dump-length %d ", dumpinfo->length);
+
+}
+
+static
+struct iptables_target dump = {
+	.name		= "DUMP",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_dump_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_dump_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_target(&dump);
+}
