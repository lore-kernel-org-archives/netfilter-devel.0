From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] IPv6 Hop Limit match/target
Date: Tue, 7 Jan 2003 15:33:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301071517060.9908-200000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1339159786-1041949819=:9908"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Content-ID: <Pine.LNX.4.44.0301071530430.9908@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-1339159786-1041949819=:9908
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0301071530431.9908@dns.toxicfilms.tv>

Hello,

this patch contains a bit corrected (typos) patch i sent earlier.

Best Regards,
Maciej Soltysiak


diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6 netfilter/patch-o-matic/base/HL.patch.ipv6
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/HL.patch.ipv6	2002-12-16 18:05:55.000000000 +0100
@@ -0,0 +1,135 @@
+diff -Nru linux-2.4.20/include/linux/netfilter_ipv6/ip6t_HL.h linux.new/include/linux/netfilter_ipv6/ip6t_HL.h
+--- linux-2.4.20/include/linux/netfilter_ipv6/ip6t_HL.h	1970-01-01 01:00:00.000000000 +0100
++++ linux.new/include/linux/netfilter_ipv6/ip6t_HL.h	2002-12-16 17:12:29.000000000 +0100
+@@ -0,0 +1,22 @@
++/* Hop Limit modification module for ip6tables
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ * Based on HW's TTL module */
++
++#ifndef _IP6T_HL_H
++#define _IP6T_HL_H
++
++enum {
++	IP6T_HL_SET = 0,
++	IP6T_HL_INC,
++	IP6T_HL_DEC
++};
++
++#define IP6T_HL_MAXMODE	IP6T_HL_DEC
++
++struct ip6t_HL_info {
++	u_int8_t	mode;
++	u_int8_t	hop_limit;
++};
++
++
++#endif
+diff -Nru linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c linux.new/net/ipv6/netfilter/ip6t_HL.c
+--- linux-2.4.20/net/ipv6/netfilter/ip6t_HL.c	1970-01-01 01:00:00.000000000 +0100
++++ linux.new/net/ipv6/netfilter/ip6t_HL.c	2002-12-16 17:08:23.000000000 +0100
+@@ -0,0 +1,105 @@
++/*
++ * Hop Limit modification target for ip6tables
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ * Based on HW's TTL module
++ *
++ * This software is distributed under the terms of GNU GPL
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/ip.h>
++
++#include <linux/netfilter_ipv6/ip6_tables.h>
++#include <linux/netfilter_ipv6/ip6t_HL.h>
++
++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
++MODULE_DESCRIPTION("IP tables Hop Limit modification module");
++MODULE_LICENSE("GPL");
++
++static unsigned int ip6t_hl_target(struct sk_buff **pskb, unsigned int hooknum,
++		const struct net_device *in, const struct net_device *out,
++		const void *targinfo, void *userinfo)
++{
++	struct ipv6hdr *ip6h = (*pskb)->nh.ipv6h;
++	const struct ip6t_HL_info *info = targinfo;
++	u_int16_t diffs[2];
++	int new_hl;
++
++	switch (info->mode) {
++		case IP6T_HL_SET:
++			new_hl = info->hop_limit;
++			break;
++		case IP6T_HL_INC:
++			new_hl = ip6h->hop_limit + info->hop_limit;
++			if (new_hl > 255)
++				new_hl = 255;
++			break;
++		case IP6T_HL_DEC:
++			new_hl = ip6h->hop_limit + info->hop_limit;
++			if (new_hl < 0)
++				new_hl = 0;
++			break;
++		default:
++			new_hl = ip6h->hop_limit;
++			break;
++	}
++
++	if (new_hl != ip6h->hop_limit) {
++		diffs[0] = htons(((unsigned)ip6h->hop_limit) << 8) ^ 0xFFFF;
++		ip6h->hop_limit = new_hl;
++		diffs[1] = htons(((unsigned)ip6h->hop_limit) << 8);
++	}
++
++	return IP6T_CONTINUE;
++}
++
++static int ip6t_hl_checkentry(const char *tablename,
++		const struct ip6t_entry *e,
++		void *targinfo,
++		unsigned int targinfosize,
++		unsigned int hook_mask)
++{
++	struct ip6t_HL_info *info = targinfo;
++
++	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_HL_info))) {
++		printk(KERN_WARNING "HL: targinfosize %u != %Zu\n",
++				targinfosize,
++				IP6T_ALIGN(sizeof(struct ip6t_HL_info)));
++		return 0;
++	}
++
++	if (strcmp(tablename, "mangle")) {
++		printk(KERN_WARNING "HL: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
++		return 0;
++	}
++
++	if (info->mode > IP6T_HL_MAXMODE) {
++		printk(KERN_WARNING "HL: invalid or unknown Mode %u\n",
++			info->mode);
++		return 0;
++	}
++
++	if ((info->mode != IP6T_HL_SET) && (info->hop_limit == 0)) {
++		printk(KERN_WARNING "HL: increment/decrement doesn't make sense with value 0\n");
++		return 0;
++	}
++
++	return 1;
++}
++
++static struct ip6t_target ip6t_HL = { { NULL, NULL }, "HL",
++	ip6t_hl_target, ip6t_hl_checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	return ip6t_register_target(&ip6t_HL);
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_target(&ip6t_HL);
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6.config.in netfilter/patch-o-matic/base/HL.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/HL.patch.ipv6.config.in	2002-12-16 18:32:27.000000000 +0100
@@ -0,0 +1,4 @@
+  dep_tristate '  Packet filtering' CONFIG_IP6_NF_FILTER $CONFIG_IP6_NF_IPTABLES
+  if [ "$CONFIG_IP6_NF_FILTER" != "n" ]; then
+    dep_tristate '    HL target support' CONFIG_IP6_NF_TARGET_HL $CONFIG_IP6_NF_FILTER
+  fi
diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6.configure.help netfilter/patch-o-matic/base/HL.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/HL.patch.ipv6.configure.help	2002-12-16 18:02:32.000000000 +0100
@@ -0,0 +1,8 @@
+CONFIG_IP6_NF_TARGET_LOG
+HL target support
+CONFIG_IP6_NF_TARGET_HL
+  This option adds a `HL' target, which allows you to modify the value of
+  IPv6 Hop Limit field.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6.help netfilter/patch-o-matic/base/HL.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/HL.patch.ipv6.help	2002-12-16 18:23:09.000000000 +0100
@@ -0,0 +1,10 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Works for me.
+
+This allows the user to set the IPv6 Hop Limit value on a packet or
+to increment or decrement it by a given value.
+
+Example:
+# ip6tables -t mangle -A OUTPUT -j HL --hl-inc 1
+# ip6tables -t mangle -A INPUT -j HL --hl-eq 64
+# ip6tables -t mangle -A OUTPUT -j HL --hl-dec 2
diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile netfilter/patch-o-matic/base/HL.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/HL.patch.ipv6.makefile	2002-12-16 18:10:45.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_HL) += ipt_HL.o
diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6 netfilter/patch-o-matic/base/hl.patch.ipv6
--- netfilter.orig/patch-o-matic/base/hl.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/hl.patch.ipv6	2002-12-16 18:05:19.000000000 +0100
@@ -0,0 +1,104 @@
+diff -Nru linux-2.4.20/include/linux/netfilter_ipv6/ip6t_hl.h linux.new/include/linux/netfilter_ipv6/ip6t_hl.h
+--- linux-2.4.20/include/linux/netfilter_ipv6/ip6t_hl.h	1970-01-01 01:00:00.000000000 +0100
++++ linux.new/include/linux/netfilter_ipv6/ip6t_hl.h	2002-12-16 17:11:56.000000000 +0100
+@@ -0,0 +1,22 @@
++/* ip6tables module for matching the Hop Limit value
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ * Based on HW's ttl module */
++
++#ifndef _IP6T_HL_H
++#define _IP6T_HL_H
++
++enum {
++	IP6T_HL_EQ = 0,		/* equals */
++	IP6T_HL_NE,		/* not equals */
++	IP6T_HL_LT,		/* less than */
++	IP6T_HL_GT,		/* greater than */
++};
++
++
++struct ip6t_hl_info {
++	u_int8_t	mode;
++	u_int8_t	hop_limit;
++};
++
++
++#endif
+diff -Nru linux-2.4.20/net/ipv6/netfilter/ip6t_hl.c linux.new/net/ipv6/netfilter/ip6t_hl.c
+--- linux-2.4.20/net/ipv6/netfilter/ip6t_hl.c	1970-01-01 01:00:00.000000000 +0100
++++ linux.new/net/ipv6/netfilter/ip6t_hl.c	2002-12-16 17:09:53.000000000 +0100
+@@ -0,0 +1,74 @@
++/*
++ * Hop Limit matching module
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
++ * Based on HW's ttl module
++ *
++ * This software is distributed under the terms  GNU GPL
++ */
++
++#include <linux/module.h>
++#include <linux/skbuff.h>
++
++#include <linux/netfilter_ipv6/ip6t_hl.h>
++#include <linux/netfilter_ipv6/ip6_tables.h>
++
++MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
++MODULE_DESCRIPTION("IP tables Hop Limit matching module");
++MODULE_LICENSE("GPL");
++
++static int match(const struct sk_buff *skb, const struct net_device *in,
++		 const struct net_device *out, const void *matchinfo,
++		 int offset, const void *hdr, u_int16_t datalen,
++		 int *hotdrop)
++{
++	const struct ip6t_hl_info *info = matchinfo;
++	const struct ipv6hdr *ip6h = skb->nh.ipv6h;
++
++	switch (info->mode) {
++		case IP6T_HL_EQ:
++			return (ip6h->hop_limit == info->hop_limit);
++			break;
++		case IP6T_HL_NE:
++			return (!(ip6h->hop_limit == info->hop_limit));
++			break;
++		case IP6T_HL_LT:
++			return (ip6h->hop_limit < info->hop_limit);
++			break;
++		case IP6T_HL_GT:
++			return (ip6h->hop_limit > info->hop_limit);
++			break;
++		default:
++			printk(KERN_WARNING "ip6t_hl: unknown mode %d\n",
++				info->mode);
++			return 0;
++	}
++
++	return 0;
++}
++
++static int checkentry(const char *tablename, const struct ip6t_ip6 *ip,
++		      void *matchinfo, unsigned int matchsize,
++		      unsigned int hook_mask)
++{
++	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_hl_info)))
++		return 0;
++
++	return 1;
++}
++
++static struct ip6t_match hl_match = { { NULL, NULL }, "hl", &match,
++		&checkentry, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	return ip6t_register_match(&hl_match);
++}
++
++static void __exit fini(void)
++{
++	ip6t_unregister_match(&hl_match);
++
++}
++
++module_init(init);
++module_exit(fini);
diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6.config.in netfilter/patch-o-matic/base/hl.patch.ipv6.config.in
--- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/hl.patch.ipv6.config.in	2002-12-16 18:08:55.000000000 +0100
@@ -0,0 +1,2 @@
+  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  HL match support' CONFIG_IP6_NF_MATCH_HL $CONFIG_IP6_NF_IPTABLES
diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6.configure.help netfilter/patch-o-matic/base/hl.patch.ipv6.configure.help
--- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.configure.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/hl.patch.ipv6.configure.help	2002-12-16 18:04:01.000000000 +0100
@@ -0,0 +1,8 @@
+CONFIG_IP6_NF_TARGET_LOG
+HL match support
+CONFIG_IP6_NF_MATCH_HL
+  This option adds a `hl' match, which allows you match the value of
+  the IPv6 Hop Limit field.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `N'.
diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6.help netfilter/patch-o-matic/base/hl.patch.ipv6.help
--- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/hl.patch.ipv6.help	2002-12-16 18:22:25.000000000 +0100
@@ -0,0 +1,9 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Works for me.
+
+This allows the user to match the IPv6 Hop Limit value on a packet.
+
+Examples:
+# ip6tables -A INPUT -m hl --hl-eq 63 -j LOG --log-prefix "Blah: "
+# ip6tables -A FORWARD -m hl --hl-gt 64 -j DROP
+# ip6tables -A OUTPUT -m hl --hl-lt 64 -j ACCEPT
diff -Nru netfilter.orig/patch-o-matic/base/hl.patch.ipv6.makefile netfilter/patch-o-matic/base/hl.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/hl.patch.ipv6.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/base/hl.patch.ipv6.makefile	2002-12-16 18:11:03.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
+obj-$(CONFIG_IP_NF_MATCH_HL) += ipt_hl.o
diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile	2002-12-09 10:31:23.000000000 +0100
+++ netfilter/userspace/extensions/Makefile	2002-12-16 16:57:44.000000000 +0100
@@ -1,7 +1,7 @@
 #! /usr/bin/make

 PF_EXT_SLIB:=ah conntrack dscp ecn esp helper icmp length limit mac mark multiport owner pkttype standard state tcp tcpmss tos ttl udp unclean DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS ULOG
-PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK
+PF6_EXT_SLIB:=eui64 icmpv6 length limit mac mark multiport owner standard tcp udp LOG MARK hl HL

 # The following may not be present, but compile them anyway.
 PF_EXT_SLIB+=TTL iplimit
diff -Nru netfilter.orig/userspace/extensions/libip6t_HL.c netfilter/userspace/extensions/libip6t_HL.c
--- netfilter.orig/userspace/extensions/libip6t_HL.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_HL.c	2002-12-16 17:05:57.000000000 +0100
@@ -0,0 +1,164 @@
+/*
+ * IPv6 Hop Limit Target module
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's ttl target
+ * This program is distributed under the terms of GNU GPL
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ip6tables.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_HL.h>
+
+#define IP6T_HL_USED	1
+
+static void init(struct ip6t_entry_target *t, unsigned int *nfcache)
+{
+}
+
+static void help(void)
+{
+	printf(
+"HL target v%s options\n"
+"  --hl-set value		Set HL to <value>\n"
+"  --hl-dec value		Decrement HL by <value>\n"
+"  --hl-inc value		Increment HL by <value>\n"
+, IPTABLES_VERSION);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const struct ip6t_entry *entry,
+		struct ip6t_entry_target **target)
+{
+	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
+	u_int8_t value;
+
+	if (*flags & IP6T_HL_USED) {
+		exit_error(PARAMETER_PROBLEM,
+				"Can't specify HL option twice");
+	}
+
+	if (!optarg)
+		exit_error(PARAMETER_PROBLEM,
+				"HL: You must specify a value");
+
+	if (check_inverse(optarg, &invert, NULL, 0))
+		exit_error(PARAMETER_PROBLEM,
+				"HL: unexpected `!'");
+
+	value = atoi(optarg);
+
+	switch (c) {
+
+		case '1':
+			info->mode = IP6T_HL_SET;
+			break;
+
+		case '2':
+			if (value == 0) {
+				exit_error(PARAMETER_PROBLEM,
+					"HL: decreasing by 0?");
+			}
+
+			info->mode = IP6T_HL_DEC;
+			break;
+
+		case '3':
+			if (value == 0) {
+				exit_error(PARAMETER_PROBLEM,
+					"HL: increasing by 0?");
+			}
+
+			info->mode = IP6T_HL_INC;
+			break;
+
+		default:
+			return 0;
+
+	}
+
+	info->hop_limit = value;
+	*flags |= IP6T_HL_USED;
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!(flags & IP6T_HL_USED))
+		exit_error(PARAMETER_PROBLEM,
+				"HL: You must specify an action");
+}
+
+static void save(const struct ip6t_ip6 *ip,
+		const struct ip6t_entry_target *target)
+{
+	const struct ip6t_HL_info *info =
+		(struct ip6t_HL_info *) target->data;
+
+	switch (info->mode) {
+		case IP6T_HL_SET:
+			printf("--hl-set ");
+			break;
+		case IP6T_HL_DEC:
+			printf("--hl-dec ");
+			break;
+
+		case IP6T_HL_INC:
+			printf("--hl-inc ");
+			break;
+	}
+	printf("%u ", info->hop_limit);
+}
+
+static void print(const struct ip6t_ip6 *ip,
+		const struct ip6t_entry_target *target, int numeric)
+{
+	const struct ip6t_HL_info *info =
+		(struct ip6t_HL_info *) target->data;
+
+	printf("HL ");
+	switch (info->mode) {
+		case IP6T_HL_SET:
+			printf("set to ");
+			break;
+		case IP6T_HL_DEC:
+			printf("decrement by ");
+			break;
+		case IP6T_HL_INC:
+			printf("increment by ");
+			break;
+	}
+	printf("%u ", info->hop_limit);
+}
+
+static struct option opts[] = {
+	{ "hl-set", 1, 0, '1' },
+	{ "hl-dec", 1, 0, '2' },
+	{ "hl-inc", 1, 0, '3' },
+	{ 0 }
+};
+
+static
+struct ip6tables_target HL = { NULL,
+	"HL",
+	IPTABLES_VERSION,
+	IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
+	IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+void _init(void)
+{
+	register_target6(&HL);
+}
diff -Nru netfilter.orig/userspace/extensions/libip6t_hl.c netfilter/userspace/extensions/libip6t_hl.c
--- netfilter.orig/userspace/extensions/libip6t_hl.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libip6t_hl.c	2002-12-16 17:05:14.000000000 +0100
@@ -0,0 +1,177 @@
+/*
+ * IPv6 Hop Limit matching module
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's ttl match
+ * This program is released under the terms of GNU GPL
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <ip6tables.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_hl.h>
+
+static void help(void)
+{
+	printf(
+"HL match v%s options:\n"
+"  --hl-eq value	Match hop limit value\n"
+"  --hl-lt value	Match HL < value\n"
+"  --hl-gt value	Match HL > value\n"
+, IPTABLES_VERSION);
+}
+
+static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
+{
+	/* caching not yet implemented */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+		const struct ip6t_entry *entry, unsigned int *nfcache,
+		struct ip6t_entry_match **match)
+{
+	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
+	u_int8_t value;
+
+	check_inverse(optarg, &invert, &optind, 0);
+	value = atoi(argv[optind-1]);
+
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+				"Can't specify HL option twice");
+
+	if (!optarg)
+		exit_error(PARAMETER_PROBLEM,
+				"hl: You must specify a value");
+	switch (c) {
+		case '2':
+			if (invert)
+				info->mode = IP6T_HL_NE;
+			else
+				info->mode = IP6T_HL_EQ;
+
+			/* is 0 allowed? */
+			info->hop_limit = value;
+			*flags = 1;
+
+			break;
+		case '3':
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+						"hl: unexpected `!'");
+
+			info->mode = IP6T_HL_LT;
+			info->hop_limit = value;
+			*flags = 1;
+
+			break;
+		case '4':
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+						"hl: unexpected `!'");
+
+			info->mode = IP6T_HL_GT;
+			info->hop_limit = value;
+			*flags = 1;
+
+			break;
+		default:
+			return 0;
+
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"HL match: You must specify one of "
+			"`--hl-eq', `--hl-lt', `--hl-gt");
+}
+
+static void print(const struct ip6t_ip6 *ip,
+		const struct ip6t_entry_match *match,
+		int numeric)
+{
+	const struct ip6t_hl_info *info =
+		(struct ip6t_hl_info *) match->data;
+
+	printf("HL match ");
+	switch (info->mode) {
+		case IP6T_HL_EQ:
+			printf("HL == ");
+			break;
+		case IP6T_HL_NE:
+			printf("HL != ");
+			break;
+		case IP6T_HL_LT:
+			printf("HL < ");
+			break;
+		case IP6T_HL_GT:
+			printf("HL > ");
+			break;
+	}
+	printf("%u ", info->hop_limit);
+}
+
+static void save(const struct ip6t_ip6 *ip,
+		const struct ip6t_entry_match *match)
+{
+	const struct ip6t_hl_info *info =
+		(struct ip6t_hl_info *) match->data;
+
+	switch (info->mode) {
+		case IP6T_HL_EQ:
+			printf("--hl-eq ");
+			break;
+		case IP6T_HL_NE:
+			printf("! --hl-eq ");
+			break;
+		case IP6T_HL_LT:
+			printf("--hl-lt ");
+			break;
+		case IP6T_HL_GT:
+			printf("--hl-gt ");
+			break;
+		default:
+			/* error */
+			break;
+	}
+	printf("%u ", info->hop_limit);
+}
+
+static struct option opts[] = {
+	{ "hl", 1, 0, '2' },
+	{ "hl-eq", 1, 0, '2'},
+	{ "hl-lt", 1, 0, '3'},
+	{ "hl-gt", 1, 0, '4'},
+	{ 0 }
+};
+
+static
+struct ip6tables_match hl = {
+	NULL,
+	"hl",
+	IPTABLES_VERSION,
+	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
+	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+
+void _init(void)
+{
+	register_match6(&hl);
+}
diff -Nru netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_HL.h netfilter/userspace/include/linux/netfilter_ipv6/ip6t_HL.h
--- netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_HL.h	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/include/linux/netfilter_ipv6/ip6t_HL.h	2002-12-16 17:12:29.000000000 +0100
@@ -0,0 +1,22 @@
+/* Hop Limit modification module for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's TTL module */
+
+#ifndef _IP6T_HL_H
+#define _IP6T_HL_H
+
+enum {
+	IP6T_HL_SET = 0,
+	IP6T_HL_INC,
+	IP6T_HL_DEC
+};
+
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC
+
+struct ip6t_HL_info {
+	u_int8_t	mode;
+	u_int8_t	hop_limit;
+};
+
+
+#endif
diff -Nru netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_hl.h netfilter/userspace/include/linux/netfilter_ipv6/ip6t_hl.h
--- netfilter.orig/userspace/include/linux/netfilter_ipv6/ip6t_hl.h	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/include/linux/netfilter_ipv6/ip6t_hl.h	2002-12-16 17:11:56.000000000 +0100
@@ -0,0 +1,22 @@
+/* ip6tables module for matching the Hop Limit value
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's ttl module */
+
+#ifndef _IP6T_HL_H
+#define _IP6T_HL_H
+
+enum {
+	IP6T_HL_EQ = 0,		/* equals */
+	IP6T_HL_NE,		/* not equals */
+	IP6T_HL_LT,		/* less than */
+	IP6T_HL_GT,		/* greater than */
+};
+
+
+struct ip6t_hl_info {
+	u_int8_t	mode;
+	u_int8_t	hop_limit;
+};
+
+
+#endif

---23717851-1339159786-1041949819=:9908
Content-Type: TEXT/PLAIN; NAME="hl.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0301071530190.9908@dns.toxicfilms.tv>
Content-Description: hl.diff
Content-Disposition: ATTACHMENT; FILENAME="hl.diff"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9I
TC5wYXRjaC5pcHY2IG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvSEwu
cGF0Y2guaXB2Ng0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMv
YmFzZS9ITC5wYXRjaC5pcHY2CTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9I
TC5wYXRjaC5pcHY2CTIwMDItMTItMTYgMTg6MDU6NTUuMDAwMDAwMDAwICsw
MTAwDQpAQCAtMCwwICsxLDEzNSBAQA0KK2RpZmYgLU5ydSBsaW51eC0yLjQu
MjAvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X0hMLmggbGlu
dXgubmV3L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5o
DQorLS0tIGxpbnV4LTIuNC4yMC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9p
cHY2L2lwNnRfSEwuaAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCAr
MDEwMA0KKysrKyBsaW51eC5uZXcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJf
aXB2Ni9pcDZ0X0hMLmgJMjAwMi0xMi0xNiAxNzoxMjoyOS4wMDAwMDAwMDAg
KzAxMDANCitAQCAtMCwwICsxLDIyIEBADQorKy8qIEhvcCBMaW1pdCBtb2Rp
ZmljYXRpb24gbW9kdWxlIGZvciBpcDZ0YWJsZXMNCisrICogTWFjaWVqIFNv
bHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisrICogQmFzZWQg
b24gSFcncyBUVEwgbW9kdWxlICovDQorKw0KKysjaWZuZGVmIF9JUDZUX0hM
X0gNCisrI2RlZmluZSBfSVA2VF9ITF9IDQorKw0KKytlbnVtIHsNCisrCUlQ
NlRfSExfU0VUID0gMCwNCisrCUlQNlRfSExfSU5DLA0KKysJSVA2VF9ITF9E
RUMNCisrfTsNCisrDQorKyNkZWZpbmUgSVA2VF9ITF9NQVhNT0RFCUlQNlRf
SExfREVDDQorKw0KKytzdHJ1Y3QgaXA2dF9ITF9pbmZvIHsNCisrCXVfaW50
OF90CW1vZGU7DQorKwl1X2ludDhfdAlob3BfbGltaXQ7DQorK307DQorKw0K
KysNCisrI2VuZGlmDQorZGlmZiAtTnJ1IGxpbnV4LTIuNC4yMC9uZXQvaXB2
Ni9uZXRmaWx0ZXIvaXA2dF9ITC5jIGxpbnV4Lm5ldy9uZXQvaXB2Ni9uZXRm
aWx0ZXIvaXA2dF9ITC5jDQorLS0tIGxpbnV4LTIuNC4yMC9uZXQvaXB2Ni9u
ZXRmaWx0ZXIvaXA2dF9ITC5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysrIGxpbnV4Lm5ldy9uZXQvaXB2Ni9uZXRmaWx0ZXIv
aXA2dF9ITC5jCTIwMDItMTItMTYgMTc6MDg6MjMuMDAwMDAwMDAwICswMTAw
DQorQEAgLTAsMCArMSwxMDUgQEANCisrLyogDQorKyAqIEhvcCBMaW1pdCBt
b2RpZmljYXRpb24gdGFyZ2V0IGZvciBpcDZ0YWJsZXMNCisrICogTWFjaWVq
IFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisrICogQmFz
ZWQgb24gSFcncyBUVEwgbW9kdWxlDQorKyAqDQorKyAqIFRoaXMgc29mdHdh
cmUgaXMgZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIEdOVSBHUEwN
CisrICovDQorKw0KKysjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQorKyNp
bmNsdWRlIDxsaW51eC9za2J1ZmYuaD4NCisrI2luY2x1ZGUgPGxpbnV4L2lw
Lmg+DQorKw0KKysjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2
X3RhYmxlcy5oPg0KKysjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYv
aXA2dF9ITC5oPg0KKysNCisrTU9EVUxFX0FVVEhPUigiTWFjaWVqIFNvbHR5
c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4iKTsNCisrTU9EVUxFX0RF
U0NSSVBUSU9OKCJJUCB0YWJsZXMgSG9wIExpbWl0IG1vZGlmaWNhdGlvbiBt
b2R1bGUiKTsNCisrTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KKysNCisrc3Rh
dGljIHVuc2lnbmVkIGludCBpcDZ0X2hsX3RhcmdldChzdHJ1Y3Qgc2tfYnVm
ZiAqKnBza2IsIHVuc2lnbmVkIGludCBob29rbnVtLA0KKysJCWNvbnN0IHN0
cnVjdCBuZXRfZGV2aWNlICppbiwgY29uc3Qgc3RydWN0IG5ldF9kZXZpY2Ug
Km91dCwNCisrCQljb25zdCB2b2lkICp0YXJnaW5mbywgdm9pZCAqdXNlcmlu
Zm8pDQorK3sNCisrCXN0cnVjdCBpcHY2aGRyICppcDZoID0gKCpwc2tiKS0+
bmguaXB2Nmg7DQorKwljb25zdCBzdHJ1Y3QgaXA2dF9ITF9pbmZvICppbmZv
ID0gdGFyZ2luZm87DQorKwl1X2ludDE2X3QgZGlmZnNbMl07DQorKwlpbnQg
bmV3X2hsOw0KKysJCQkgDQorKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsNCisr
CQljYXNlIElQNlRfSExfU0VUOg0KKysJCQluZXdfaGwgPSBpbmZvLT5ob3Bf
bGltaXQ7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9JTkM6DQor
KwkJCW5ld19obCA9IGlwNmgtPmhvcF9saW1pdCArIGluZm8tPmhvcF9saW1p
dDsNCisrCQkJaWYgKG5ld19obCA+IDI1NSkNCisrCQkJCW5ld19obCA9IDI1
NTsNCisrCQkJYnJlYWs7DQorKwkJY2FzZSBJUDZUX0hMX0RFQzoNCisrCQkJ
bmV3X2hsID0gaXA2aC0+aG9wX2xpbWl0ICsgaW5mby0+aG9wX2xpbWl0Ow0K
KysJCQlpZiAobmV3X2hsIDwgMCkNCisrCQkJCW5ld19obCA9IDA7DQorKwkJ
CWJyZWFrOw0KKysJCWRlZmF1bHQ6DQorKwkJCW5ld19obCA9IGlwNmgtPmhv
cF9saW1pdDsNCisrCQkJYnJlYWs7DQorKwl9DQorKw0KKysJaWYgKG5ld19o
bCAhPSBpcDZoLT5ob3BfbGltaXQpIHsNCisrCQlkaWZmc1swXSA9IGh0b25z
KCgodW5zaWduZWQpaXA2aC0+aG9wX2xpbWl0KSA8PCA4KSBeIDB4RkZGRjsN
CisrCQlpcDZoLT5ob3BfbGltaXQgPSBuZXdfaGw7DQorKwkJZGlmZnNbMV0g
PSBodG9ucygoKHVuc2lnbmVkKWlwNmgtPmhvcF9saW1pdCkgPDwgOCk7DQor
Kwl9DQorKw0KKysJcmV0dXJuIElQNlRfQ09OVElOVUU7DQorK30NCisrDQor
K3N0YXRpYyBpbnQgaXA2dF9obF9jaGVja2VudHJ5KGNvbnN0IGNoYXIgKnRh
YmxlbmFtZSwNCisrCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeSAqZSwNCisr
CQl2b2lkICp0YXJnaW5mbywNCisrCQl1bnNpZ25lZCBpbnQgdGFyZ2luZm9z
aXplLA0KKysJCXVuc2lnbmVkIGludCBob29rX21hc2spDQorK3sNCisrCXN0
cnVjdCBpcDZ0X0hMX2luZm8gKmluZm8gPSB0YXJnaW5mbzsNCisrDQorKwlp
ZiAodGFyZ2luZm9zaXplICE9IElQNlRfQUxJR04oc2l6ZW9mKHN0cnVjdCBp
cDZ0X0hMX2luZm8pKSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcgIkhM
OiB0YXJnaW5mb3NpemUgJXUgIT0gJVp1XG4iLA0KKysJCQkJdGFyZ2luZm9z
aXplLA0KKysJCQkJSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfSExf
aW5mbykpKTsNCisrCQlyZXR1cm4gMDsJDQorKwl9CQ0KKysNCisrCWlmIChz
dHJjbXAodGFibGVuYW1lLCAibWFuZ2xlIikpIHsNCisrCQlwcmludGsoS0VS
Tl9XQVJOSU5HICJITDogY2FuIG9ubHkgYmUgY2FsbGVkIGZyb20gXCJtYW5n
bGVcIiB0YWJsZSwgbm90IFwiJXNcIlxuIiwgdGFibGVuYW1lKTsNCisrCQly
ZXR1cm4gMDsNCisrCX0NCisrDQorKwlpZiAoaW5mby0+bW9kZSA+IElQNlRf
SExfTUFYTU9ERSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcgIkhMOiBp
bnZhbGlkIG9yIHVua25vd24gTW9kZSAldVxuIiwgDQorKwkJCWluZm8tPm1v
ZGUpOw0KKysJCXJldHVybiAwOw0KKysJfQ0KKysNCisrCWlmICgoaW5mby0+
bW9kZSAhPSBJUDZUX0hMX1NFVCkgJiYgKGluZm8tPmhvcF9saW1pdCA9PSAw
KSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcgIkhMOiBpbmNyZW1lbnQv
ZGVjcmVtZW50IGRvZXNuJ3QgbWFrZSBzZW5zZSB3aXRoIHZhbHVlIDBcbiIp
Ow0KKysJCXJldHVybiAwOw0KKysJfQ0KKysJDQorKwlyZXR1cm4gMTsNCisr
fQ0KKysNCisrc3RhdGljIHN0cnVjdCBpcDZ0X3RhcmdldCBpcDZ0X0hMID0g
eyB7IE5VTEwsIE5VTEwgfSwgIkhMIiwgDQorKwlpcDZ0X2hsX3RhcmdldCwg
aXA2dF9obF9jaGVja2VudHJ5LCBOVUxMLCBUSElTX01PRFVMRSB9Ow0KKysN
Cisrc3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQ0KKyt7DQorKwlyZXR1
cm4gaXA2dF9yZWdpc3Rlcl90YXJnZXQoJmlwNnRfSEwpOw0KKyt9DQorKw0K
KytzdGF0aWMgdm9pZCBfX2V4aXQgZmluaSh2b2lkKQ0KKyt7DQorKwlpcDZ0
X3VucmVnaXN0ZXJfdGFyZ2V0KCZpcDZ0X0hMKTsNCisrfQ0KKysNCisrbW9k
dWxlX2luaXQoaW5pdCk7DQorK21vZHVsZV9leGl0KGZpbmkpOw0KZGlmZiAt
TnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRj
aC5pcHY2LmNvbmZpZy5pbiBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNl
L0hMLnBhdGNoLmlwdjYuY29uZmlnLmluDQotLS0gbmV0ZmlsdGVyLm9yaWcv
cGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlnLmluCTE5
NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0Zmls
dGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2LmNvbmZpZy5p
bgkyMDAyLTEyLTE2IDE4OjMyOjI3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTAs
MCArMSw0IEBADQorICBkZXBfdHJpc3RhdGUgJyAgUGFja2V0IGZpbHRlcmlu
ZycgQ09ORklHX0lQNl9ORl9GSUxURVIgJENPTkZJR19JUDZfTkZfSVBUQUJM
RVMgDQorICBpZiBbICIkQ09ORklHX0lQNl9ORl9GSUxURVIiICE9ICJuIiBd
OyB0aGVuDQorICAgIGRlcF90cmlzdGF0ZSAnICAgIEhMIHRhcmdldCBzdXBw
b3J0JyBDT05GSUdfSVA2X05GX1RBUkdFVF9ITCAkQ09ORklHX0lQNl9ORl9G
SUxURVINCisgIGZpDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gt
by1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2LmNvbmZp
Z3VyZS5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9i
YXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMTk3MC0wMS0wMSAw
MTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gt
by1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMjAw
Mi0xMi0xNiAxODowMjozMi4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEs
OCBAQA0KK0NPTkZJR19JUDZfTkZfVEFSR0VUX0xPRw0KK0hMIHRhcmdldCBz
dXBwb3J0DQorQ09ORklHX0lQNl9ORl9UQVJHRVRfSEwNCisgIFRoaXMgb3B0
aW9uIGFkZHMgYSBgSEwnIHRhcmdldCwgd2hpY2ggYWxsb3dzIHlvdSB0byBt
b2RpZnkgdGhlIHZhbHVlIG9mDQorICBJUHY2IEhvcCBMaW1pdCBmaWVsZC4N
CisNCisgIElmIHlvdSB3YW50IHRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUs
IHNheSBNIGhlcmUgYW5kIHJlYWQNCisgIDxmaWxlOkRvY3VtZW50YXRpb24v
bW9kdWxlcy50eHQ+LiAgSWYgdW5zdXJlLCBzYXkgYE4nLg0KZGlmZiAtTnJ1
IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5p
cHY2LmhlbHAgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRj
aC5pcHY2LmhlbHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGlj
L2Jhc2UvSEwucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEtMDEgMDE6MDA6MDAu
MDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMv
YmFzZS9ITC5wYXRjaC5pcHY2LmhlbHAJMjAwMi0xMi0xNiAxODoyMzowOS4w
MDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsMTAgQEANCitBdXRob3I6IE1h
Y2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRveGljZmlsbXMudHY+DQorU3Rh
dHVzOiBXb3JrcyBmb3IgbWUuDQorDQorVGhpcyBhbGxvd3MgdGhlIHVzZXIg
dG8gc2V0IHRoZSBJUHY2IEhvcCBMaW1pdCB2YWx1ZSBvbiBhIHBhY2tldCBv
cg0KK3RvIGluY3JlbWVudCBvciBkZWNyZW1lbnQgaXQgYnkgYSBnaXZlbiB2
YWx1ZS4NCisNCitFeGFtcGxlOg0KKyMgaXA2dGFibGVzIC10IG1hbmdsZSAt
QSBPVVRQVVQgLWogSEwgLS1obC1pbmMgMQ0KKyMgaXA2dGFibGVzIC10IG1h
bmdsZSAtQSBJTlBVVCAtaiBITCAtLWhsLWVxIDY0DQorIyBpcDZ0YWJsZXMg
LXQgbWFuZ2xlIC1BIE9VVFBVVCAtaiBITCAtLWhsLWRlYyAyDQpkaWZmIC1O
cnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNo
LmlwdjYubWFrZWZpbGUgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9I
TC5wYXRjaC5pcHY2Lm1ha2VmaWxlDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0
Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYubWFrZWZpbGUJMTk3MC0w
MS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIv
cGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYubWFrZWZpbGUJMjAw
Mi0xMi0xNiAxODoxMDo0NS4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEs
MiBAQA0KK29iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX0xPRykgKz0gaXA2
dF9MT0cubw0KK29iai0kKENPTkZJR19JUF9ORl9UQVJHRVRfSEwpICs9IGlw
dF9ITC5vDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRp
Yy9iYXNlL2hsLnBhdGNoLmlwdjYgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMv
YmFzZS9obC5wYXRjaC5pcHY2DQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gt
by1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYJMTk3MC0wMS0wMSAwMTowMDow
MC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRp
Yy9iYXNlL2hsLnBhdGNoLmlwdjYJMjAwMi0xMi0xNiAxODowNToxOS4wMDAw
MDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsMTA0IEBADQorZGlmZiAtTnJ1IGxp
bnV4LTIuNC4yMC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRf
aGwuaCBsaW51eC5uZXcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9p
cDZ0X2hsLmgNCistLS0gbGludXgtMi40LjIwL2luY2x1ZGUvbGludXgvbmV0
ZmlsdGVyX2lwdjYvaXA2dF9obC5oCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAw
MDAwMDAwICswMTAwDQorKysrIGxpbnV4Lm5ldy9pbmNsdWRlL2xpbnV4L25l
dGZpbHRlcl9pcHY2L2lwNnRfaGwuaAkyMDAyLTEyLTE2IDE3OjExOjU2LjAw
MDAwMDAwMCArMDEwMA0KK0BAIC0wLDAgKzEsMjIgQEANCisrLyogaXA2dGFi
bGVzIG1vZHVsZSBmb3IgbWF0Y2hpbmcgdGhlIEhvcCBMaW1pdCB2YWx1ZQ0K
KysgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2
Pg0KKysgKiBCYXNlZCBvbiBIVydzIHR0bCBtb2R1bGUgKi8NCisrDQorKyNp
Zm5kZWYgX0lQNlRfSExfSA0KKysjZGVmaW5lIF9JUDZUX0hMX0gNCisrDQor
K2VudW0gew0KKysJSVA2VF9ITF9FUSA9IDAsCQkvKiBlcXVhbHMgKi8NCisr
CUlQNlRfSExfTkUsCQkvKiBub3QgZXF1YWxzICovDQorKwlJUDZUX0hMX0xU
LAkJLyogbGVzcyB0aGFuICovDQorKwlJUDZUX0hMX0dULAkJLyogZ3JlYXRl
ciB0aGFuICovDQorK307DQorKw0KKysNCisrc3RydWN0IGlwNnRfaGxfaW5m
byB7DQorKwl1X2ludDhfdAltb2RlOw0KKysJdV9pbnQ4X3QJaG9wX2xpbWl0
Ow0KKyt9Ow0KKysNCisrDQorKyNlbmRpZg0KK2RpZmYgLU5ydSBsaW51eC0y
LjQuMjAvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYyBsaW51eC5uZXcv
bmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYw0KKy0tLSBsaW51eC0yLjQu
MjAvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYwkxOTcwLTAxLTAxIDAx
OjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrKyBsaW51eC5uZXcvbmV0L2lw
djYvbmV0ZmlsdGVyL2lwNnRfaGwuYwkyMDAyLTEyLTE2IDE3OjA5OjUzLjAw
MDAwMDAwMCArMDEwMA0KK0BAIC0wLDAgKzEsNzQgQEANCisrLyoNCisrICog
SG9wIExpbWl0IG1hdGNoaW5nIG1vZHVsZQ0KKysgKiBNYWNpZWogU29sdHlz
aWFrIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2Pg0KKysgKiBCYXNlZCBvbiBI
VydzIHR0bCBtb2R1bGUNCisrICoNCisrICogVGhpcyBzb2Z0d2FyZSBpcyBk
aXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMgIEdOVSBHUEwNCisrICovDQor
Kw0KKysjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQorKyNpbmNsdWRlIDxs
aW51eC9za2J1ZmYuaD4NCisrDQorKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0
ZXJfaXB2Ni9pcDZ0X2hsLmg+DQorKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0
ZXJfaXB2Ni9pcDZfdGFibGVzLmg+DQorKw0KKytNT0RVTEVfQVVUSE9SKCJN
YWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2PiIpOw0K
KytNT0RVTEVfREVTQ1JJUFRJT04oIklQIHRhYmxlcyBIb3AgTGltaXQgbWF0
Y2hpbmcgbW9kdWxlIik7DQorK01PRFVMRV9MSUNFTlNFKCJHUEwiKTsNCisr
DQorK3N0YXRpYyBpbnQgbWF0Y2goY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNr
YiwgY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmluLA0KKysJCSBjb25zdCBz
dHJ1Y3QgbmV0X2RldmljZSAqb3V0LCBjb25zdCB2b2lkICptYXRjaGluZm8s
DQorKwkJIGludCBvZmZzZXQsIGNvbnN0IHZvaWQgKmhkciwgdV9pbnQxNl90
IGRhdGFsZW4sDQorKwkJIGludCAqaG90ZHJvcCkNCisrew0KKysJY29uc3Qg
c3RydWN0IGlwNnRfaGxfaW5mbyAqaW5mbyA9IG1hdGNoaW5mbzsNCisrCWNv
bnN0IHN0cnVjdCBpcHY2aGRyICppcDZoID0gc2tiLT5uaC5pcHY2aDsNCisr
DQorKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsNCisrCQljYXNlIElQNlRfSExf
RVE6DQorKwkJCXJldHVybiAoaXA2aC0+aG9wX2xpbWl0ID09IGluZm8tPmhv
cF9saW1pdCk7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9ORToN
CisrCQkJcmV0dXJuICghKGlwNmgtPmhvcF9saW1pdCA9PSBpbmZvLT5ob3Bf
bGltaXQpKTsNCisrCQkJYnJlYWs7DQorKwkJY2FzZSBJUDZUX0hMX0xUOg0K
KysJCQlyZXR1cm4gKGlwNmgtPmhvcF9saW1pdCA8IGluZm8tPmhvcF9saW1p
dCk7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9HVDoNCisrCQkJ
cmV0dXJuIChpcDZoLT5ob3BfbGltaXQgPiBpbmZvLT5ob3BfbGltaXQpOw0K
KysJCQlicmVhazsNCisrCQlkZWZhdWx0Og0KKysJCQlwcmludGsoS0VSTl9X
QVJOSU5HICJpcDZ0X2hsOiB1bmtub3duIG1vZGUgJWRcbiIsIA0KKysJCQkJ
aW5mby0+bW9kZSk7DQorKwkJCXJldHVybiAwOw0KKysJfQ0KKysNCisrCXJl
dHVybiAwOw0KKyt9DQorKw0KKytzdGF0aWMgaW50IGNoZWNrZW50cnkoY29u
c3QgY2hhciAqdGFibGVuYW1lLCBjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlw
LA0KKysJCSAgICAgIHZvaWQgKm1hdGNoaW5mbywgdW5zaWduZWQgaW50IG1h
dGNoc2l6ZSwNCisrCQkgICAgICB1bnNpZ25lZCBpbnQgaG9va19tYXNrKQ0K
Kyt7DQorKwlpZiAobWF0Y2hzaXplICE9IElQNlRfQUxJR04oc2l6ZW9mKHN0
cnVjdCBpcDZ0X2hsX2luZm8pKSkNCisrCQlyZXR1cm4gMDsNCisrDQorKwly
ZXR1cm4gMTsNCisrfQ0KKysNCisrc3RhdGljIHN0cnVjdCBpcDZ0X21hdGNo
IGhsX21hdGNoID0geyB7IE5VTEwsIE5VTEwgfSwgImhsIiwgJm1hdGNoLA0K
KysJCSZjaGVja2VudHJ5LCBOVUxMLCBUSElTX01PRFVMRSB9Ow0KKysNCisr
c3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQ0KKyt7DQorKwlyZXR1cm4g
aXA2dF9yZWdpc3Rlcl9tYXRjaCgmaGxfbWF0Y2gpOw0KKyt9DQorKw0KKytz
dGF0aWMgdm9pZCBfX2V4aXQgZmluaSh2b2lkKQ0KKyt7DQorKwlpcDZ0X3Vu
cmVnaXN0ZXJfbWF0Y2goJmhsX21hdGNoKTsNCisrDQorK30NCisrDQorK21v
ZHVsZV9pbml0KGluaXQpOw0KKyttb2R1bGVfZXhpdChmaW5pKTsNCmRpZmYg
LU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0
Y2guaXB2Ni5jb25maWcuaW4gbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFz
ZS9obC5wYXRjaC5pcHY2LmNvbmZpZy5pbg0KLS0tIG5ldGZpbHRlci5vcmln
L3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZpZy5pbgkx
OTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZp
bHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5jb25maWcu
aW4JMjAwMi0xMi0xNiAxODowODo1NS4wMDAwMDAwMDAgKzAxMDANCkBAIC0w
LDAgKzEsMiBAQA0KKyAgZGVwX3RyaXN0YXRlICcgIE1BQyBhZGRyZXNzIG1h
dGNoIHN1cHBvcnQnIENPTkZJR19JUDZfTkZfTUFUQ0hfTUFDICRDT05GSUdf
SVA2X05GX0lQVEFCTEVTDQorICBkZXBfdHJpc3RhdGUgJyAgSEwgbWF0Y2gg
c3VwcG9ydCcgQ09ORklHX0lQNl9ORl9NQVRDSF9ITCAkQ09ORklHX0lQNl9O
Rl9JUFRBQkxFUw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8t
bWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZpZ3VyZS5oZWxwIG5ldGZp
bHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5jb25maWd1
cmUuaGVscA0KLS0tIG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFz
ZS9obC5wYXRjaC5pcHY2LmNvbmZpZ3VyZS5oZWxwCTE5NzAtMDEtMDEgMDE6
MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8t
bWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZpZ3VyZS5oZWxwCTIwMDIt
MTItMTYgMTg6MDQ6MDEuMDAwMDAwMDAwICswMTAwDQpAQCAtMCwwICsxLDgg
QEANCitDT05GSUdfSVA2X05GX1RBUkdFVF9MT0cNCitITCBtYXRjaCBzdXBw
b3J0DQorQ09ORklHX0lQNl9ORl9NQVRDSF9ITA0KKyAgVGhpcyBvcHRpb24g
YWRkcyBhIGBobCcgbWF0Y2gsIHdoaWNoIGFsbG93cyB5b3UgbWF0Y2ggdGhl
IHZhbHVlIG9mDQorICB0aGUgSVB2NiBIb3AgTGltaXQgZmllbGQuDQorDQor
ICBJZiB5b3Ugd2FudCB0byBjb21waWxlIGl0IGFzIGEgbW9kdWxlLCBzYXkg
TSBoZXJlIGFuZCByZWFkDQorICA8ZmlsZTpEb2N1bWVudGF0aW9uL21vZHVs
ZXMudHh0Pi4gIElmIHVuc3VyZSwgc2F5IGBOJy4NCmRpZmYgLU5ydSBuZXRm
aWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5o
ZWxwIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2
Ni5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNl
L2hsLnBhdGNoLmlwdjYuaGVscAkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAw
MDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2Uv
aGwucGF0Y2guaXB2Ni5oZWxwCTIwMDItMTItMTYgMTg6MjI6MjUuMDAwMDAw
MDAwICswMTAwDQpAQCAtMCwwICsxLDkgQEANCitBdXRob3I6IE1hY2llaiBT
b2x0eXNpYWsgPHNvbHRAZG5zLnRveGljZmlsbXMudHY+DQorU3RhdHVzOiBX
b3JrcyBmb3IgbWUuDQorDQorVGhpcyBhbGxvd3MgdGhlIHVzZXIgdG8gbWF0
Y2ggdGhlIElQdjYgSG9wIExpbWl0IHZhbHVlIG9uIGEgcGFja2V0Lg0KKw0K
K0V4YW1wbGVzOg0KKyMgaXA2dGFibGVzIC1BIElOUFVUIC1tIGhsIC0taGwt
ZXEgNjMgLWogTE9HIC0tbG9nLXByZWZpeCAiQmxhaDogIg0KKyMgaXA2dGFi
bGVzIC1BIEZPUldBUkQgLW0gaGwgLS1obC1ndCA2NCAtaiBEUk9QDQorIyBp
cDZ0YWJsZXMgLUEgT1VUUFVUIC1tIGhsIC0taGwtbHQgNjQgLWogQUNDRVBU
DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNl
L2hsLnBhdGNoLmlwdjYubWFrZWZpbGUgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0
aWMvYmFzZS9obC5wYXRjaC5pcHY2Lm1ha2VmaWxlDQotLS0gbmV0ZmlsdGVy
Lm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYubWFrZWZp
bGUJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBu
ZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYubWFr
ZWZpbGUJMjAwMi0xMi0xNiAxODoxMTowMy4wMDAwMDAwMDAgKzAxMDANCkBA
IC0wLDAgKzEsMiBAQA0KK29iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX0xP
RykgKz0gaXA2dF9MT0cubw0KK29iai0kKENPTkZJR19JUF9ORl9NQVRDSF9I
TCkgKz0gaXB0X2hsLm8NCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy91c2Vy
c3BhY2UvZXh0ZW5zaW9ucy9NYWtlZmlsZSBuZXRmaWx0ZXIvdXNlcnNwYWNl
L2V4dGVuc2lvbnMvTWFrZWZpbGUNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vy
c3BhY2UvZXh0ZW5zaW9ucy9NYWtlZmlsZQkyMDAyLTEyLTA5IDEwOjMxOjIz
LjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0
ZW5zaW9ucy9NYWtlZmlsZQkyMDAyLTEyLTE2IDE2OjU3OjQ0LjAwMDAwMDAw
MCArMDEwMA0KQEAgLTEsNyArMSw3IEBADQogIyEgL3Vzci9iaW4vbWFrZQ0K
IA0KIFBGX0VYVF9TTElCOj1haCBjb25udHJhY2sgZHNjcCBlY24gZXNwIGhl
bHBlciBpY21wIGxlbmd0aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBvcnQgb3du
ZXIgcGt0dHlwZSBzdGFuZGFyZCBzdGF0ZSB0Y3AgdGNwbXNzIHRvcyB0dGwg
dWRwIHVuY2xlYW4gRE5BVCBEU0NQIEVDTiBMT0cgTUFSSyBNQVNRVUVSQURF
IE1JUlJPUiBSRURJUkVDVCBSRUpFQ1QgU0FNRSBTTkFUIFRBUlBJVCBUQ1BN
U1MgVE9TIFVMT0cNCi1QRjZfRVhUX1NMSUI6PWV1aTY0IGljbXB2NiBsZW5n
dGggbGltaXQgbWFjIG1hcmsgbXVsdGlwb3J0IG93bmVyIHN0YW5kYXJkIHRj
cCB1ZHAgTE9HIE1BUksNCitQRjZfRVhUX1NMSUI6PWV1aTY0IGljbXB2NiBs
ZW5ndGggbGltaXQgbWFjIG1hcmsgbXVsdGlwb3J0IG93bmVyIHN0YW5kYXJk
IHRjcCB1ZHAgTE9HIE1BUksgaGwgSEwNCiANCiAjIFRoZSBmb2xsb3dpbmcg
bWF5IG5vdCBiZSBwcmVzZW50LCBidXQgY29tcGlsZSB0aGVtIGFueXdheS4N
CiBQRl9FWFRfU0xJQis9VFRMIGlwbGltaXQNCmRpZmYgLU5ydSBuZXRmaWx0
ZXIub3JpZy91c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJpcDZ0X0hMLmMgbmV0
ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfSEwuYw0KLS0t
IG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRf
SEwuYwkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysr
IG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJpcDZ0X0hMLmMJ
MjAwMi0xMi0xNiAxNzowNTo1Ny4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAg
KzEsMTY0IEBADQorLyoNCisgKiBJUHY2IEhvcCBMaW1pdCBUYXJnZXQgbW9k
dWxlDQorICogTWFjaWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxt
cy50dj4NCisgKiBCYXNlZCBvbiBIVydzIHR0bCB0YXJnZXQNCisgKiBUaGlz
IHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIEdO
VSBHUEwNCisgKi8NCisNCisjaW5jbHVkZSA8c3RkaW8uaD4NCisjaW5jbHVk
ZSA8c3RyaW5nLmg+DQorI2luY2x1ZGUgPHN0ZGxpYi5oPg0KKyNpbmNsdWRl
IDxnZXRvcHQuaD4NCisjaW5jbHVkZSA8aXA2dGFibGVzLmg+DQorDQorI2lu
Y2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9pcHY2L2lwNl90YWJsZXMuaD4NCisj
aW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oPg0KKw0K
KyNkZWZpbmUgSVA2VF9ITF9VU0VECTENCisNCitzdGF0aWMgdm9pZCBpbml0
KHN0cnVjdCBpcDZ0X2VudHJ5X3RhcmdldCAqdCwgdW5zaWduZWQgaW50ICpu
ZmNhY2hlKSANCit7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIGhlbHAodm9pZCkg
DQorew0KKwlwcmludGYoDQorIkhMIHRhcmdldCB2JXMgb3B0aW9uc1xuIg0K
KyIgIC0taGwtc2V0IHZhbHVlCQlTZXQgSEwgdG8gPHZhbHVlPlxuIg0KKyIg
IC0taGwtZGVjIHZhbHVlCQlEZWNyZW1lbnQgSEwgYnkgPHZhbHVlPlxuIg0K
KyIgIC0taGwtaW5jIHZhbHVlCQlJbmNyZW1lbnQgSEwgYnkgPHZhbHVlPlxu
Ig0KKywgSVBUQUJMRVNfVkVSU0lPTik7DQorfQ0KKw0KK3N0YXRpYyBpbnQg
cGFyc2UoaW50IGMsIGNoYXIgKiphcmd2LCBpbnQgaW52ZXJ0LCB1bnNpZ25l
ZCBpbnQgKmZsYWdzLA0KKwkJY29uc3Qgc3RydWN0IGlwNnRfZW50cnkgKmVu
dHJ5LA0KKwkJc3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICoqdGFyZ2V0KQ0K
K3sNCisJc3RydWN0IGlwNnRfSExfaW5mbyAqaW5mbyA9IChzdHJ1Y3QgaXA2
dF9ITF9pbmZvICopICgqdGFyZ2V0KS0+ZGF0YTsNCisJdV9pbnQ4X3QgdmFs
dWU7DQorDQorCWlmICgqZmxhZ3MgJiBJUDZUX0hMX1VTRUQpIHsNCisJCWV4
aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sIA0KKwkJCQkiQ2FuJ3Qgc3Bl
Y2lmeSBITCBvcHRpb24gdHdpY2UiKTsNCisJfQ0KKw0KKwlpZiAoIW9wdGFy
ZykgDQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLCANCisJCQkJ
IkhMOiBZb3UgbXVzdCBzcGVjaWZ5IGEgdmFsdWUiKTsNCisNCisJaWYgKGNo
ZWNrX2ludmVyc2Uob3B0YXJnLCAmaW52ZXJ0LCBOVUxMLCAwKSkNCisJCWV4
aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJCSJITDogdW5leHBl
Y3RlZCBgISciKTsNCisJDQorCXZhbHVlID0gYXRvaShvcHRhcmcpOw0KKw0K
Kwlzd2l0Y2ggKGMpIHsNCisNCisJCWNhc2UgJzEnOg0KKwkJCWluZm8tPm1v
ZGUgPSBJUDZUX0hMX1NFVDsNCisJCQlicmVhazsNCisNCisJCWNhc2UgJzIn
Og0KKwkJCWlmICh2YWx1ZSA9PSAwKSB7DQorCQkJCWV4aXRfZXJyb3IoUEFS
QU1FVEVSX1BST0JMRU0sDQorCQkJCQkiSEw6IGRlY3JlYXNpbmcgYnkgMD8i
KTsNCisJCQl9DQorDQorCQkJaW5mby0+bW9kZSA9IElQNlRfSExfREVDOw0K
KwkJCWJyZWFrOw0KKw0KKwkJY2FzZSAnMyc6DQorCQkJaWYgKHZhbHVlID09
IDApIHsNCisJCQkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJ
CQkJCSJITDogaW5jcmVhc2luZyBieSAwPyIpOw0KKwkJCX0NCisNCisJCQlp
bmZvLT5tb2RlID0gSVA2VF9ITF9JTkM7DQorCQkJYnJlYWs7DQorDQorCQlk
ZWZhdWx0Og0KKwkJCXJldHVybiAwOw0KKw0KKwl9DQorCQ0KKwlpbmZvLT5o
b3BfbGltaXQgPSB2YWx1ZTsNCisJKmZsYWdzIHw9IElQNlRfSExfVVNFRDsN
CisNCisJcmV0dXJuIDE7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIGZpbmFsX2No
ZWNrKHVuc2lnbmVkIGludCBmbGFncykNCit7DQorCWlmICghKGZsYWdzICYg
SVA2VF9ITF9VU0VEKSkNCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JM
RU0sDQorCQkJCSJITDogWW91IG11c3Qgc3BlY2lmeSBhbiBhY3Rpb24iKTsN
Cit9DQorDQorc3RhdGljIHZvaWQgc2F2ZShjb25zdCBzdHJ1Y3QgaXA2dF9p
cDYgKmlwLA0KKwkJY29uc3Qgc3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICp0
YXJnZXQpDQorew0KKwljb25zdCBzdHJ1Y3QgaXA2dF9ITF9pbmZvICppbmZv
ID0gDQorCQkoc3RydWN0IGlwNnRfSExfaW5mbyAqKSB0YXJnZXQtPmRhdGE7
DQorDQorCXN3aXRjaCAoaW5mby0+bW9kZSkgew0KKwkJY2FzZSBJUDZUX0hM
X1NFVDoNCisJCQlwcmludGYoIi0taGwtc2V0ICIpOw0KKwkJCWJyZWFrOw0K
KwkJY2FzZSBJUDZUX0hMX0RFQzoNCisJCQlwcmludGYoIi0taGwtZGVjICIp
Ow0KKwkJCWJyZWFrOw0KKw0KKwkJY2FzZSBJUDZUX0hMX0lOQzoNCisJCQlw
cmludGYoIi0taGwtaW5jICIpOw0KKwkJCWJyZWFrOw0KKwl9DQorCXByaW50
ZigiJXUgIiwgaW5mby0+aG9wX2xpbWl0KTsNCit9DQorDQorc3RhdGljIHZv
aWQgcHJpbnQoY29uc3Qgc3RydWN0IGlwNnRfaXA2ICppcCwNCisJCWNvbnN0
IHN0cnVjdCBpcDZ0X2VudHJ5X3RhcmdldCAqdGFyZ2V0LCBpbnQgbnVtZXJp
YykNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X0hMX2luZm8gKmluZm8gPQ0K
KwkJKHN0cnVjdCBpcDZ0X0hMX2luZm8gKikgdGFyZ2V0LT5kYXRhOw0KKw0K
KwlwcmludGYoIkhMICIpOw0KKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsNCisJ
CWNhc2UgSVA2VF9ITF9TRVQ6DQorCQkJcHJpbnRmKCJzZXQgdG8gIik7DQor
CQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExfREVDOg0KKwkJCXByaW50Zigi
ZGVjcmVtZW50IGJ5ICIpOw0KKwkJCWJyZWFrOw0KKwkJY2FzZSBJUDZUX0hM
X0lOQzoNCisJCQlwcmludGYoImluY3JlbWVudCBieSAiKTsNCisJCQlicmVh
azsNCisJfQ0KKwlwcmludGYoIiV1ICIsIGluZm8tPmhvcF9saW1pdCk7DQor
fQ0KKw0KK3N0YXRpYyBzdHJ1Y3Qgb3B0aW9uIG9wdHNbXSA9IHsNCisJeyAi
aGwtc2V0IiwgMSwgMCwgJzEnIH0sDQorCXsgImhsLWRlYyIsIDEsIDAsICcy
JyB9LA0KKwl7ICJobC1pbmMiLCAxLCAwLCAnMycgfSwNCisJeyAwIH0NCit9
Ow0KKw0KK3N0YXRpYw0KK3N0cnVjdCBpcDZ0YWJsZXNfdGFyZ2V0IEhMID0g
eyBOVUxMLCANCisJIkhMIiwNCisJSVBUQUJMRVNfVkVSU0lPTiwNCisJSVA2
VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfSExfaW5mbykpLA0KKwlJUDZU
X0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9ITF9pbmZvKSksDQorCSZoZWxw
LA0KKwkmaW5pdCwNCisJJnBhcnNlLA0KKwkmZmluYWxfY2hlY2ssDQorCSZw
cmludCwNCisJJnNhdmUsDQorCW9wdHMgDQorfTsNCisNCit2b2lkIF9pbml0
KHZvaWQpDQorew0KKwlyZWdpc3Rlcl90YXJnZXQ2KCZITCk7DQorfQ0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xp
YmlwNnRfaGwuYyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGli
aXA2dF9obC5jDQotLS0gbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVu
c2lvbnMvbGliaXA2dF9obC5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25z
L2xpYmlwNnRfaGwuYwkyMDAyLTEyLTE2IDE3OjA1OjE0LjAwMDAwMDAwMCAr
MDEwMA0KQEAgLTAsMCArMSwxNzcgQEANCisvKg0KKyAqIElQdjYgSG9wIExp
bWl0IG1hdGNoaW5nIG1vZHVsZQ0KKyAqIE1hY2llaiBTb2x0eXNpYWsgPHNv
bHRAZG5zLnRveGljZmlsbXMudHY+DQorICogQmFzZWQgb24gSFcncyB0dGwg
bWF0Y2gNCisgKiBUaGlzIHByb2dyYW0gaXMgcmVsZWFzZWQgdW5kZXIgdGhl
IHRlcm1zIG9mIEdOVSBHUEwNCisgKi8NCisNCisjaW5jbHVkZSA8c3RkaW8u
aD4NCisjaW5jbHVkZSA8c3RkbGliLmg+DQorI2luY2x1ZGUgPHN0cmluZy5o
Pg0KKyNpbmNsdWRlIDxnZXRvcHQuaD4NCisjaW5jbHVkZSA8aXA2dGFibGVz
Lmg+DQorDQorI2luY2x1ZGUgPGxpbnV4L25ldGZpbHRlcl9pcHY2L2lwNl90
YWJsZXMuaD4NCisjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2
dF9obC5oPg0KKw0KK3N0YXRpYyB2b2lkIGhlbHAodm9pZCkgDQorew0KKwlw
cmludGYoDQorIkhMIG1hdGNoIHYlcyBvcHRpb25zOlxuIg0KKyIgIC0taGwt
ZXEgdmFsdWUJTWF0Y2ggaG9wIGxpbWl0IHZhbHVlXG4iDQorIiAgLS1obC1s
dCB2YWx1ZQlNYXRjaCBITCA8IHZhbHVlXG4iDQorIiAgLS1obC1ndCB2YWx1
ZQlNYXRjaCBITCA+IHZhbHVlXG4iDQorLCBJUFRBQkxFU19WRVJTSU9OKTsN
Cit9DQorDQorc3RhdGljIHZvaWQgaW5pdChzdHJ1Y3QgaXA2dF9lbnRyeV9t
YXRjaCAqbSwgdW5zaWduZWQgaW50ICpuZmNhY2hlKQ0KK3sNCisJLyogY2Fj
aGluZyBub3QgeWV0IGltcGxlbWVudGVkICovDQorCSpuZmNhY2hlIHw9IE5G
Q19VTktOT1dOOw0KK30NCisNCitzdGF0aWMgaW50IHBhcnNlKGludCBjLCBj
aGFyICoqYXJndiwgaW50IGludmVydCwgdW5zaWduZWQgaW50ICpmbGFncywN
CisJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5ICplbnRyeSwgdW5zaWduZWQg
aW50ICpuZmNhY2hlLA0KKwkJc3RydWN0IGlwNnRfZW50cnlfbWF0Y2ggKipt
YXRjaCkNCit7DQorCXN0cnVjdCBpcDZ0X2hsX2luZm8gKmluZm8gPSAoc3Ry
dWN0IGlwNnRfaGxfaW5mbyAqKSAoKm1hdGNoKS0+ZGF0YTsNCisJdV9pbnQ4
X3QgdmFsdWU7DQorDQorCWNoZWNrX2ludmVyc2Uob3B0YXJnLCAmaW52ZXJ0
LCAmb3B0aW5kLCAwKTsNCisJdmFsdWUgPSBhdG9pKGFyZ3Zbb3B0aW5kLTFd
KTsNCisNCisJaWYgKCpmbGFncykgDQorCQlleGl0X2Vycm9yKFBBUkFNRVRF
Ul9QUk9CTEVNLCANCisJCQkJIkNhbid0IHNwZWNpZnkgSEwgb3B0aW9uIHR3
aWNlIik7DQorDQorCWlmICghb3B0YXJnKQ0KKwkJZXhpdF9lcnJvcihQQVJB
TUVURVJfUFJPQkxFTSwNCisJCQkJImhsOiBZb3UgbXVzdCBzcGVjaWZ5IGEg
dmFsdWUiKTsNCisJc3dpdGNoIChjKSB7DQorCQljYXNlICcyJzoNCisJCQlp
ZiAoaW52ZXJ0KQ0KKwkJCQlpbmZvLT5tb2RlID0gSVA2VF9ITF9ORTsNCisJ
CQllbHNlDQorCQkJCWluZm8tPm1vZGUgPSBJUDZUX0hMX0VROw0KKw0KKwkJ
CS8qIGlzIDAgYWxsb3dlZD8gKi8NCisJCQlpbmZvLT5ob3BfbGltaXQgPSB2
YWx1ZTsNCisJCQkqZmxhZ3MgPSAxOw0KKw0KKwkJCWJyZWFrOw0KKwkJY2Fz
ZSAnMyc6DQorCQkJaWYgKGludmVydCkgDQorCQkJCWV4aXRfZXJyb3IoUEFS
QU1FVEVSX1BST0JMRU0sDQorCQkJCQkJImhsOiB1bmV4cGVjdGVkIGAhJyIp
Ow0KKw0KKwkJCWluZm8tPm1vZGUgPSBJUDZUX0hMX0xUOw0KKwkJCWluZm8t
PmhvcF9saW1pdCA9IHZhbHVlOw0KKwkJCSpmbGFncyA9IDE7DQorDQorCQkJ
YnJlYWs7DQorCQljYXNlICc0JzoNCisJCQlpZiAoaW52ZXJ0KQ0KKwkJCQll
eGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0KKwkJCQkJCSJobDogdW5l
eHBlY3RlZCBgISciKTsNCisNCisJCQlpbmZvLT5tb2RlID0gSVA2VF9ITF9H
VDsNCisJCQlpbmZvLT5ob3BfbGltaXQgPSB2YWx1ZTsNCisJCQkqZmxhZ3Mg
PSAxOw0KKw0KKwkJCWJyZWFrOw0KKwkJZGVmYXVsdDoNCisJCQlyZXR1cm4g
MDsNCisNCisJfQ0KKw0KKwlyZXR1cm4gMTsNCit9DQorDQorc3RhdGljIHZv
aWQgZmluYWxfY2hlY2sodW5zaWduZWQgaW50IGZsYWdzKQ0KK3sNCisJaWYg
KCFmbGFncykgDQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0K
KwkJCSJITCBtYXRjaDogWW91IG11c3Qgc3BlY2lmeSBvbmUgb2YgIg0KKwkJ
CSJgLS1obC1lcScsIGAtLWhsLWx0JywgYC0taGwtZ3QiKTsNCit9DQorDQor
c3RhdGljIHZvaWQgcHJpbnQoY29uc3Qgc3RydWN0IGlwNnRfaXA2ICppcCwg
DQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRjaCAqbWF0Y2gsDQor
CQlpbnQgbnVtZXJpYykNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X2hsX2lu
Zm8gKmluZm8gPSANCisJCShzdHJ1Y3QgaXA2dF9obF9pbmZvICopIG1hdGNo
LT5kYXRhOw0KKw0KKwlwcmludGYoIkhMIG1hdGNoICIpOw0KKwlzd2l0Y2gg
KGluZm8tPm1vZGUpIHsNCisJCWNhc2UgSVA2VF9ITF9FUToNCisJCQlwcmlu
dGYoIkhMID09ICIpOw0KKwkJCWJyZWFrOw0KKwkJY2FzZSBJUDZUX0hMX05F
Og0KKwkJCXByaW50ZigiSEwgIT0gIik7DQorCQkJYnJlYWs7DQorCQljYXNl
IElQNlRfSExfTFQ6DQorCQkJcHJpbnRmKCJITCA8ICIpOw0KKwkJCWJyZWFr
Ow0KKwkJY2FzZSBJUDZUX0hMX0dUOg0KKwkJCXByaW50ZigiSEwgPiAiKTsN
CisJCQlicmVhazsNCisJfQ0KKwlwcmludGYoIiV1ICIsIGluZm8tPmhvcF9s
aW1pdCk7DQorfQ0KKw0KK3N0YXRpYyB2b2lkIHNhdmUoY29uc3Qgc3RydWN0
IGlwNnRfaXA2ICppcCwgDQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeV9t
YXRjaCAqbWF0Y2gpDQorew0KKwljb25zdCBzdHJ1Y3QgaXA2dF9obF9pbmZv
ICppbmZvID0NCisJCShzdHJ1Y3QgaXA2dF9obF9pbmZvICopIG1hdGNoLT5k
YXRhOw0KKw0KKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsNCisJCWNhc2UgSVA2
VF9ITF9FUToNCisJCQlwcmludGYoIi0taGwtZXEgIik7DQorCQkJYnJlYWs7
DQorCQljYXNlIElQNlRfSExfTkU6DQorCQkJcHJpbnRmKCIhIC0taGwtZXEg
Iik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExfTFQ6DQorCQkJcHJp
bnRmKCItLWhsLWx0ICIpOw0KKwkJCWJyZWFrOw0KKwkJY2FzZSBJUDZUX0hM
X0dUOg0KKwkJCXByaW50ZigiLS1obC1ndCAiKTsNCisJCQlicmVhazsNCisJ
CWRlZmF1bHQ6DQorCQkJLyogZXJyb3IgKi8NCisJCQlicmVhazsNCisJfQ0K
KwlwcmludGYoIiV1ICIsIGluZm8tPmhvcF9saW1pdCk7DQorfQ0KKw0KK3N0
YXRpYyBzdHJ1Y3Qgb3B0aW9uIG9wdHNbXSA9IHsNCisJeyAiaGwiLCAxLCAw
LCAnMicgfSwNCisJeyAiaGwtZXEiLCAxLCAwLCAnMid9LA0KKwl7ICJobC1s
dCIsIDEsIDAsICczJ30sDQorCXsgImhsLWd0IiwgMSwgMCwgJzQnfSwNCisJ
eyAwIH0NCit9Ow0KKw0KK3N0YXRpYw0KK3N0cnVjdCBpcDZ0YWJsZXNfbWF0
Y2ggaGwgPSB7DQorCU5VTEwsDQorCSJobCIsDQorCUlQVEFCTEVTX1ZFUlNJ
T04sDQorCUlQNlRfQUxJR04oc2l6ZW9mKHN0cnVjdCBpcDZ0X2hsX2luZm8p
KSwNCisJSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfaGxfaW5mbykp
LA0KKwkmaGVscCwNCisJJmluaXQsDQorCSZwYXJzZSwNCisJJmZpbmFsX2No
ZWNrLA0KKwkmcHJpbnQsDQorCSZzYXZlLA0KKwlvcHRzDQorfTsNCisNCisN
Cit2b2lkIF9pbml0KHZvaWQpIA0KK3sNCisJcmVnaXN0ZXJfbWF0Y2g2KCZo
bCk7DQorfQ0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9p
bmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfSEwuaCBuZXRmaWx0
ZXIvdXNlcnNwYWNlL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2
dF9ITC5oDQotLS0gbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2luY2x1ZGUv
bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oCTE5NzAtMDEtMDEgMDE6
MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFj
ZS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfSEwuaAkyMDAy
LTEyLTE2IDE3OjEyOjI5LjAwMDAwMDAwMCArMDEwMA0KQEAgLTAsMCArMSwy
MiBAQA0KKy8qIEhvcCBMaW1pdCBtb2RpZmljYXRpb24gbW9kdWxlIGZvciBp
cDZ0YWJsZXMNCisgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hp
Y2ZpbG1zLnR2Pg0KKyAqIEJhc2VkIG9uIEhXJ3MgVFRMIG1vZHVsZSAqLw0K
Kw0KKyNpZm5kZWYgX0lQNlRfSExfSA0KKyNkZWZpbmUgX0lQNlRfSExfSA0K
Kw0KK2VudW0gew0KKwlJUDZUX0hMX1NFVCA9IDAsDQorCUlQNlRfSExfSU5D
LA0KKwlJUDZUX0hMX0RFQw0KK307DQorDQorI2RlZmluZSBJUDZUX0hMX01B
WE1PREUJSVA2VF9ITF9ERUMNCisNCitzdHJ1Y3QgaXA2dF9ITF9pbmZvIHsN
CisJdV9pbnQ4X3QJbW9kZTsNCisJdV9pbnQ4X3QJaG9wX2xpbWl0Ow0KK307
DQorDQorDQorI2VuZGlmDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNl
cnNwYWNlL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9obC5o
IG5ldGZpbHRlci91c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJf
aXB2Ni9pcDZ0X2hsLmgNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2Uv
aW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X2hsLmgJMTk3MC0w
MS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIv
dXNlcnNwYWNlL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9o
bC5oCTIwMDItMTItMTYgMTc6MTE6NTYuMDAwMDAwMDAwICswMTAwDQpAQCAt
MCwwICsxLDIyIEBADQorLyogaXA2dGFibGVzIG1vZHVsZSBmb3IgbWF0Y2hp
bmcgdGhlIEhvcCBMaW1pdCB2YWx1ZQ0KKyAqIE1hY2llaiBTb2x0eXNpYWsg
PHNvbHRAZG5zLnRveGljZmlsbXMudHY+DQorICogQmFzZWQgb24gSFcncyB0
dGwgbW9kdWxlICovDQorDQorI2lmbmRlZiBfSVA2VF9ITF9IDQorI2RlZmlu
ZSBfSVA2VF9ITF9IDQorDQorZW51bSB7DQorCUlQNlRfSExfRVEgPSAwLAkJ
LyogZXF1YWxzICovDQorCUlQNlRfSExfTkUsCQkvKiBub3QgZXF1YWxzICov
DQorCUlQNlRfSExfTFQsCQkvKiBsZXNzIHRoYW4gKi8NCisJSVA2VF9ITF9H
VCwJCS8qIGdyZWF0ZXIgdGhhbiAqLw0KK307DQorDQorDQorc3RydWN0IGlw
NnRfaGxfaW5mbyB7DQorCXVfaW50OF90CW1vZGU7DQorCXVfaW50OF90CWhv
cF9saW1pdDsNCit9Ow0KKw0KKw0KKyNlbmRpZg0K
---23717851-1339159786-1041949819=:9908--
