From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Thu, 2 Jan 2003 21:00:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301022100140.21609-200000@dns.toxicfilms.tv>
References: <1041536390.938.1.camel@arwen.middleearth.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1609057221-1041537651=:21609"
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andras Kis-Szabo <kisza@securityaudit.hu>
In-Reply-To: <1041536390.938.1.camel@arwen.middleearth.hu>
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

---23717851-1609057221-1041537651=:21609
Content-Type: TEXT/PLAIN; charset=US-ASCII

The patch.

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
++static int checkentry(const char *tablename, const struct ip6t_ip *ip,
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


---23717851-1609057221-1041537651=:21609
Content-Type: TEXT/plain; name="hl.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0301022100510.21609@dns.toxicfilms.tv>
Content-Description: hl.diff
Content-Disposition: attachment; filename="hl.diff"

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
c3QgY2hhciAqdGFibGVuYW1lLCBjb25zdCBzdHJ1Y3QgaXA2dF9pcCAqaXAs
DQorKwkJICAgICAgdm9pZCAqbWF0Y2hpbmZvLCB1bnNpZ25lZCBpbnQgbWF0
Y2hzaXplLA0KKysJCSAgICAgIHVuc2lnbmVkIGludCBob29rX21hc2spDQor
K3sNCisrCWlmIChtYXRjaHNpemUgIT0gSVA2VF9BTElHTihzaXplb2Yoc3Ry
dWN0IGlwNnRfaGxfaW5mbykpKQ0KKysJCXJldHVybiAwOw0KKysNCisrCXJl
dHVybiAxOw0KKyt9DQorKw0KKytzdGF0aWMgc3RydWN0IGlwNnRfbWF0Y2gg
aGxfbWF0Y2ggPSB7IHsgTlVMTCwgTlVMTCB9LCAiaGwiLCAmbWF0Y2gsDQor
KwkJJmNoZWNrZW50cnksIE5VTEwsIFRISVNfTU9EVUxFIH07DQorKw0KKytz
dGF0aWMgaW50IF9faW5pdCBpbml0KHZvaWQpDQorK3sNCisrCXJldHVybiBp
cDZ0X3JlZ2lzdGVyX21hdGNoKCZobF9tYXRjaCk7DQorK30NCisrDQorK3N0
YXRpYyB2b2lkIF9fZXhpdCBmaW5pKHZvaWQpDQorK3sNCisrCWlwNnRfdW5y
ZWdpc3Rlcl9tYXRjaCgmaGxfbWF0Y2gpOw0KKysNCisrfQ0KKysNCisrbW9k
dWxlX2luaXQoaW5pdCk7DQorK21vZHVsZV9leGl0KGZpbmkpOw0KZGlmZiAt
TnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRj
aC5pcHY2LmNvbmZpZy5pbiBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9iYXNl
L2hsLnBhdGNoLmlwdjYuY29uZmlnLmluDQotLS0gbmV0ZmlsdGVyLm9yaWcv
cGF0Y2gtby1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlnLmluCTE5
NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0Zmls
dGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZpZy5p
bgkyMDAyLTEyLTE2IDE4OjA4OjU1LjAwMDAwMDAwMCArMDEwMA0KQEAgLTAs
MCArMSwyIEBADQorICBkZXBfdHJpc3RhdGUgJyAgTUFDIGFkZHJlc3MgbWF0
Y2ggc3VwcG9ydCcgQ09ORklHX0lQNl9ORl9NQVRDSF9NQUMgJENPTkZJR19J
UDZfTkZfSVBUQUJMRVMNCisgIGRlcF90cmlzdGF0ZSAnICBITCBtYXRjaCBz
dXBwb3J0JyBDT05GSUdfSVA2X05GX01BVENIX0hMICRDT05GSUdfSVA2X05G
X0lQVEFCTEVTDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1t
YXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAgbmV0Zmls
dGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZpZ3Vy
ZS5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNl
L2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMTk3MC0wMS0wMSAwMTow
MDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1t
YXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMjAwMi0x
Mi0xNiAxODowNDowMS4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsOCBA
QA0KK0NPTkZJR19JUDZfTkZfVEFSR0VUX0xPRw0KK0hMIG1hdGNoIHN1cHBv
cnQNCitDT05GSUdfSVA2X05GX01BVENIX0hMDQorICBUaGlzIG9wdGlvbiBh
ZGRzIGEgYGhsJyBtYXRjaCwgd2hpY2ggYWxsb3dzIHlvdSBtYXRjaCB0aGUg
dmFsdWUgb2YNCisgIHRoZSBJUHY2IEhvcCBMaW1pdCBmaWVsZC4NCisNCisg
IElmIHlvdSB3YW50IHRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUsIHNheSBN
IGhlcmUgYW5kIHJlYWQNCisgIDxmaWxlOkRvY3VtZW50YXRpb24vbW9kdWxl
cy50eHQ+LiAgSWYgdW5zdXJlLCBzYXkgYE4nLg0KZGlmZiAtTnJ1IG5ldGZp
bHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2Lmhl
bHAgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2
LmhlbHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2Uv
aGwucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAw
MDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9o
bC5wYXRjaC5pcHY2LmhlbHAJMjAwMi0xMi0xNiAxODoyMjoyNS4wMDAwMDAw
MDAgKzAxMDANCkBAIC0wLDAgKzEsOSBAQA0KK0F1dGhvcjogTWFjaWVqIFNv
bHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCitTdGF0dXM6IFdv
cmtzIGZvciBtZS4NCisNCitUaGlzIGFsbG93cyB0aGUgdXNlciB0byBtYXRj
aCB0aGUgSVB2NiBIb3AgTGltaXQgdmFsdWUgb24gYSBwYWNrZXQuDQorDQor
RXhhbXBsZXM6DQorIyBpcDZ0YWJsZXMgLUEgSU5QVVQgLW0gaGwgLS1obC1l
cSA2MyAtaiBMT0cgLS1sb2ctcHJlZml4ICJCbGFoOiAiDQorIyBpcDZ0YWJs
ZXMgLUEgRk9SV0FSRCAtbSBobCAtLWhsLWd0IDY0IC1qIERST1ANCisjIGlw
NnRhYmxlcyAtQSBPVVRQVVQgLW0gaGwgLS1obC1sdCA2NCAtaiBBQ0NFUFQN
CmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2Uv
aGwucGF0Y2guaXB2Ni5tYWtlZmlsZSBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRp
Yy9iYXNlL2hsLnBhdGNoLmlwdjYubWFrZWZpbGUNCi0tLSBuZXRmaWx0ZXIu
b3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5tYWtlZmls
ZQkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5l
dGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5tYWtl
ZmlsZQkyMDAyLTEyLTE2IDE4OjExOjAzLjAwMDAwMDAwMCArMDEwMA0KQEAg
LTAsMCArMSwyIEBADQorb2JqLSQoQ09ORklHX0lQNl9ORl9UQVJHRVRfTE9H
KSArPSBpcDZ0X0xPRy5vDQorb2JqLSQoQ09ORklHX0lQX05GX01BVENIX0hM
KSArPSBpcHRfaGwubw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3VzZXJz
cGFjZS9leHRlbnNpb25zL01ha2VmaWxlIG5ldGZpbHRlci91c2Vyc3BhY2Uv
ZXh0ZW5zaW9ucy9NYWtlZmlsZQ0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJz
cGFjZS9leHRlbnNpb25zL01ha2VmaWxlCTIwMDItMTItMDkgMTA6MzE6MjMu
MDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRl
bnNpb25zL01ha2VmaWxlCTIwMDItMTItMTYgMTY6NTc6NDQuMDAwMDAwMDAw
ICswMTAwDQpAQCAtMSw3ICsxLDcgQEANCiAjISAvdXNyL2Jpbi9tYWtlDQog
DQogUEZfRVhUX1NMSUI6PWFoIGNvbm50cmFjayBkc2NwIGVjbiBlc3AgaGVs
cGVyIGljbXAgbGVuZ3RoIGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBvd25l
ciBwa3R0eXBlIHN0YW5kYXJkIHN0YXRlIHRjcCB0Y3Btc3MgdG9zIHR0bCB1
ZHAgdW5jbGVhbiBETkFUIERTQ1AgRUNOIExPRyBNQVJLIE1BU1FVRVJBREUg
TUlSUk9SIFJFRElSRUNUIFJFSkVDVCBTQU1FIFNOQVQgVEFSUElUIFRDUE1T
UyBUT1MgVUxPRw0KLVBGNl9FWFRfU0xJQjo9ZXVpNjQgaWNtcHY2IGxlbmd0
aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBvcnQgb3duZXIgc3RhbmRhcmQgdGNw
IHVkcCBMT0cgTUFSSw0KK1BGNl9FWFRfU0xJQjo9ZXVpNjQgaWNtcHY2IGxl
bmd0aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBvcnQgb3duZXIgc3RhbmRhcmQg
dGNwIHVkcCBMT0cgTUFSSyBobCBITA0KIA0KICMgVGhlIGZvbGxvd2luZyBt
YXkgbm90IGJlIHByZXNlbnQsIGJ1dCBjb21waWxlIHRoZW0gYW55d2F5Lg0K
IFBGX0VYVF9TTElCKz1UVEwgaXBsaW1pdA0KZGlmZiAtTnJ1IG5ldGZpbHRl
ci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfSEwuYyBuZXRm
aWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9ITC5jDQotLS0g
bmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9I
TC5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysg
bmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfSEwuYwky
MDAyLTEyLTE2IDE3OjA1OjU3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTAsMCAr
MSwxNjQgQEANCisvKg0KKyAqIElQdjYgSG9wIExpbWl0IFRhcmdldCBtb2R1
bGUNCisgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1z
LnR2Pg0KKyAqIEJhc2VkIG9uIEhXJ3MgdHRsIHRhcmdldA0KKyAqIFRoaXMg
cHJvZ3JhbSBpcyBkaXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMgb2YgR05V
IEdQTA0KKyAqLw0KKw0KKyNpbmNsdWRlIDxzdGRpby5oPg0KKyNpbmNsdWRl
IDxzdHJpbmcuaD4NCisjaW5jbHVkZSA8c3RkbGliLmg+DQorI2luY2x1ZGUg
PGdldG9wdC5oPg0KKyNpbmNsdWRlIDxpcDZ0YWJsZXMuaD4NCisNCisjaW5j
bHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2X3RhYmxlcy5oPg0KKyNp
bmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X0hMLmg+DQorDQor
I2RlZmluZSBJUDZUX0hMX1VTRUQJMQ0KKw0KK3N0YXRpYyB2b2lkIGluaXQo
c3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICp0LCB1bnNpZ25lZCBpbnQgKm5m
Y2FjaGUpIA0KK3sNCit9DQorDQorc3RhdGljIHZvaWQgaGVscCh2b2lkKSAN
Cit7DQorCXByaW50ZigNCisiSEwgdGFyZ2V0IHYlcyBvcHRpb25zXG4iDQor
IiAgLS1obC1zZXQgdmFsdWUJCVNldCBITCB0byA8dmFsdWU+XG4iDQorIiAg
LS1obC1kZWMgdmFsdWUJCURlY3JlbWVudCBITCBieSA8dmFsdWU+XG4iDQor
IiAgLS1obC1pbmMgdmFsdWUJCUluY3JlbWVudCBITCBieSA8dmFsdWU+XG4i
DQorLCBJUFRBQkxFU19WRVJTSU9OKTsNCit9DQorDQorc3RhdGljIGludCBw
YXJzZShpbnQgYywgY2hhciAqKmFyZ3YsIGludCBpbnZlcnQsIHVuc2lnbmVk
IGludCAqZmxhZ3MsDQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeSAqZW50
cnksDQorCQlzdHJ1Y3QgaXA2dF9lbnRyeV90YXJnZXQgKip0YXJnZXQpDQor
ew0KKwlzdHJ1Y3QgaXA2dF9ITF9pbmZvICppbmZvID0gKHN0cnVjdCBpcDZ0
X0hMX2luZm8gKikgKCp0YXJnZXQpLT5kYXRhOw0KKwl1X2ludDhfdCB2YWx1
ZTsNCisNCisJaWYgKCpmbGFncyAmIElQNlRfSExfVVNFRCkgew0KKwkJZXhp
dF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwgDQorCQkJCSJDYW4ndCBzcGVj
aWZ5IEhMIG9wdGlvbiB0d2ljZSIpOw0KKwl9DQorDQorCWlmICghb3B0YXJn
KSANCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sIA0KKwkJCQki
SEw6IFlvdSBtdXN0IHNwZWNpZnkgYSB2YWx1ZSIpOw0KKw0KKwlpZiAoY2hl
Y2tfaW52ZXJzZShvcHRhcmcsICZpbnZlcnQsIE5VTEwsIDApKQ0KKwkJZXhp
dF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJIkhMOiB1bmV4cGVj
dGVkIGAhJyIpOw0KKwkNCisJdmFsdWUgPSBhdG9pKG9wdGFyZyk7DQorDQor
CXN3aXRjaCAoYykgew0KKw0KKwkJY2FzZSAnMSc6DQorCQkJaW5mby0+bW9k
ZSA9IElQNlRfSExfU0VUOw0KKwkJCWJyZWFrOw0KKw0KKwkJY2FzZSAnMic6
DQorCQkJaWYgKHZhbHVlID09IDApIHsNCisJCQkJZXhpdF9lcnJvcihQQVJB
TUVURVJfUFJPQkxFTSwNCisJCQkJCSJITDogZGVjcmVhc2luZyBieSAwPyIp
Ow0KKwkJCX0NCisNCisJCQlpbmZvLT5tb2RlID0gSVA2VF9ITF9ERUM7DQor
CQkJYnJlYWs7DQorDQorCQljYXNlICczJzoNCisJCQlpZiAodmFsdWUgPT0g
MCkgew0KKwkJCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0KKwkJ
CQkJIkhMOiBpbmNyZWFzaW5nIGJ5IDA/Iik7DQorCQkJfQ0KKw0KKwkJCWlu
Zm8tPm1vZGUgPSBJUDZUX0hMX0lOQzsNCisJCQlicmVhazsNCisNCisJCWRl
ZmF1bHQ6DQorCQkJcmV0dXJuIDA7DQorDQorCX0NCisJDQorCWluZm8tPmhv
cF9saW1pdCA9IHZhbHVlOw0KKwkqZmxhZ3MgfD0gSVA2VF9ITF9VU0VEOw0K
Kw0KKwlyZXR1cm4gMTsNCit9DQorDQorc3RhdGljIHZvaWQgZmluYWxfY2hl
Y2sodW5zaWduZWQgaW50IGZsYWdzKQ0KK3sNCisJaWYgKCEoZmxhZ3MgJiBJ
UDZUX0hMX1VTRUQpKQ0KKwkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxF
TSwNCisJCQkJIkhMOiBZb3UgbXVzdCBzcGVjaWZ5IGFuIGFjdGlvbiIpOw0K
K30NCisNCitzdGF0aWMgdm9pZCBzYXZlKGNvbnN0IHN0cnVjdCBpcDZ0X2lw
NiAqaXAsDQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeV90YXJnZXQgKnRh
cmdldCkNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X0hMX2luZm8gKmluZm8g
PSANCisJCShzdHJ1Y3QgaXA2dF9ITF9pbmZvICopIHRhcmdldC0+ZGF0YTsN
CisNCisJc3dpdGNoIChpbmZvLT5tb2RlKSB7DQorCQljYXNlIElQNlRfSExf
U0VUOg0KKwkJCXByaW50ZigiLS1obC1zZXQgIik7DQorCQkJYnJlYWs7DQor
CQljYXNlIElQNlRfSExfREVDOg0KKwkJCXByaW50ZigiLS1obC1kZWMgIik7
DQorCQkJYnJlYWs7DQorDQorCQljYXNlIElQNlRfSExfSU5DOg0KKwkJCXBy
aW50ZigiLS1obC1pbmMgIik7DQorCQkJYnJlYWs7DQorCX0NCisJcHJpbnRm
KCIldSAiLCBpbmZvLT5ob3BfbGltaXQpOw0KK30NCisNCitzdGF0aWMgdm9p
ZCBwcmludChjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlwLA0KKwkJY29uc3Qg
c3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICp0YXJnZXQsIGludCBudW1lcmlj
KQ0KK3sNCisJY29uc3Qgc3RydWN0IGlwNnRfSExfaW5mbyAqaW5mbyA9DQor
CQkoc3RydWN0IGlwNnRfSExfaW5mbyAqKSB0YXJnZXQtPmRhdGE7DQorDQor
CXByaW50ZigiSEwgIik7DQorCXN3aXRjaCAoaW5mby0+bW9kZSkgew0KKwkJ
Y2FzZSBJUDZUX0hMX1NFVDoNCisJCQlwcmludGYoInNldCB0byAiKTsNCisJ
CQlicmVhazsNCisJCWNhc2UgSVA2VF9ITF9ERUM6DQorCQkJcHJpbnRmKCJk
ZWNyZW1lbnQgYnkgIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExf
SU5DOg0KKwkJCXByaW50ZigiaW5jcmVtZW50IGJ5ICIpOw0KKwkJCWJyZWFr
Ow0KKwl9DQorCXByaW50ZigiJXUgIiwgaW5mby0+aG9wX2xpbWl0KTsNCit9
DQorDQorc3RhdGljIHN0cnVjdCBvcHRpb24gb3B0c1tdID0gew0KKwl7ICJo
bC1zZXQiLCAxLCAwLCAnMScgfSwNCisJeyAiaGwtZGVjIiwgMSwgMCwgJzIn
IH0sDQorCXsgImhsLWluYyIsIDEsIDAsICczJyB9LA0KKwl7IDAgfQ0KK307
DQorDQorc3RhdGljDQorc3RydWN0IGlwNnRhYmxlc190YXJnZXQgSEwgPSB7
IE5VTEwsIA0KKwkiSEwiLA0KKwlJUFRBQkxFU19WRVJTSU9OLA0KKwlJUDZU
X0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9ITF9pbmZvKSksDQorCUlQNlRf
QUxJR04oc2l6ZW9mKHN0cnVjdCBpcDZ0X0hMX2luZm8pKSwNCisJJmhlbHAs
DQorCSZpbml0LA0KKwkmcGFyc2UsDQorCSZmaW5hbF9jaGVjaywNCisJJnBy
aW50LA0KKwkmc2F2ZSwNCisJb3B0cyANCit9Ow0KKw0KK3ZvaWQgX2luaXQo
dm9pZCkNCit7DQorCXJlZ2lzdGVyX3RhcmdldDYoJkhMKTsNCit9DQpkaWZm
IC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGli
aXA2dF9obC5jIG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJp
cDZ0X2hsLmMNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2UvZXh0ZW5z
aW9ucy9saWJpcDZ0X2hsLmMJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAwMDAw
MDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMv
bGliaXA2dF9obC5jCTIwMDItMTItMTYgMTc6MDU6MTQuMDAwMDAwMDAwICsw
MTAwDQpAQCAtMCwwICsxLDE3NyBAQA0KKy8qDQorICogSVB2NiBIb3AgTGlt
aXQgbWF0Y2hpbmcgbW9kdWxlDQorICogTWFjaWVqIFNvbHR5c2lhayA8c29s
dEBkbnMudG94aWNmaWxtcy50dj4NCisgKiBCYXNlZCBvbiBIVydzIHR0bCBt
YXRjaA0KKyAqIFRoaXMgcHJvZ3JhbSBpcyByZWxlYXNlZCB1bmRlciB0aGUg
dGVybXMgb2YgR05VIEdQTA0KKyAqLw0KKw0KKyNpbmNsdWRlIDxzdGRpby5o
Pg0KKyNpbmNsdWRlIDxzdGRsaWIuaD4NCisjaW5jbHVkZSA8c3RyaW5nLmg+
DQorI2luY2x1ZGUgPGdldG9wdC5oPg0KKyNpbmNsdWRlIDxpcDZ0YWJsZXMu
aD4NCisNCisjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2X3Rh
Ymxlcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0
X2hsLmg+DQorDQorc3RhdGljIHZvaWQgaGVscCh2b2lkKSANCit7DQorCXBy
aW50ZigNCisiSEwgbWF0Y2ggdiVzIG9wdGlvbnM6XG4iDQorIiAgLS1obC1l
cSB2YWx1ZQlNYXRjaCBob3AgbGltaXQgdmFsdWVcbiINCisiICAtLWhsLWx0
IHZhbHVlCU1hdGNoIEhMIDwgdmFsdWVcbiINCisiICAtLWhsLWd0IHZhbHVl
CU1hdGNoIEhMID4gdmFsdWVcbiINCissIElQVEFCTEVTX1ZFUlNJT04pOw0K
K30NCisNCitzdGF0aWMgdm9pZCBpbml0KHN0cnVjdCBpcDZ0X2VudHJ5X21h
dGNoICptLCB1bnNpZ25lZCBpbnQgKm5mY2FjaGUpDQorew0KKwkvKiBjYWNo
aW5nIG5vdCB5ZXQgaW1wbGVtZW50ZWQgKi8NCisJKm5mY2FjaGUgfD0gTkZD
X1VOS05PV047DQorfQ0KKw0KK3N0YXRpYyBpbnQgcGFyc2UoaW50IGMsIGNo
YXIgKiphcmd2LCBpbnQgaW52ZXJ0LCB1bnNpZ25lZCBpbnQgKmZsYWdzLA0K
KwkJY29uc3Qgc3RydWN0IGlwNnRfZW50cnkgKmVudHJ5LCB1bnNpZ25lZCBp
bnQgKm5mY2FjaGUsDQorCQlzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRjaCAqKm1h
dGNoKQ0KK3sNCisJc3RydWN0IGlwNnRfaGxfaW5mbyAqaW5mbyA9IChzdHJ1
Y3QgaXA2dF9obF9pbmZvICopICgqbWF0Y2gpLT5kYXRhOw0KKwl1X2ludDhf
dCB2YWx1ZTsNCisNCisJY2hlY2tfaW52ZXJzZShvcHRhcmcsICZpbnZlcnQs
ICZvcHRpbmQsIDApOw0KKwl2YWx1ZSA9IGF0b2koYXJndltvcHRpbmQtMV0p
Ow0KKw0KKwlpZiAoKmZsYWdzKSANCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVS
X1BST0JMRU0sIA0KKwkJCQkiQ2FuJ3Qgc3BlY2lmeSBITCBvcHRpb24gdHdp
Y2UiKTsNCisNCisJaWYgKCFvcHRhcmcpDQorCQlleGl0X2Vycm9yKFBBUkFN
RVRFUl9QUk9CTEVNLA0KKwkJCQkiaGw6IFlvdSBtdXN0IHNwZWNpZnkgYSB2
YWx1ZSIpOw0KKwlzd2l0Y2ggKGMpIHsNCisJCWNhc2UgJzInOg0KKwkJCWlm
IChpbnZlcnQpDQorCQkJCWluZm8tPm1vZGUgPSBJUDZUX0hMX05FOw0KKwkJ
CWVsc2UNCisJCQkJaW5mby0+bW9kZSA9IElQNlRfSExfRVE7DQorDQorCQkJ
LyogaXMgMCBhbGxvd2VkPyAqLw0KKwkJCWluZm8tPmhvcF9saW1pdCA9IHZh
bHVlOw0KKwkJCSpmbGFncyA9IDE7DQorDQorCQkJYnJlYWs7DQorCQljYXNl
ICczJzoNCisJCQlpZiAoaW52ZXJ0KSANCisJCQkJZXhpdF9lcnJvcihQQVJB
TUVURVJfUFJPQkxFTSwNCisJCQkJCQkiaGw6IHVuZXhwZWN0ZWQgYCEnIik7
DQorDQorCQkJaW5mby0+bW9kZSA9IElQNlRfSExfTFQ7DQorCQkJaW5mby0+
aG9wX2xpbWl0ID0gdmFsdWU7DQorCQkJKmZsYWdzID0gMTsNCisNCisJCQli
cmVhazsNCisJCWNhc2UgJzQnOg0KKwkJCWlmIChpbnZlcnQpDQorCQkJCWV4
aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJCQkJImhsOiB1bmV4
cGVjdGVkIGAhJyIpOw0KKw0KKwkJCWluZm8tPm1vZGUgPSBJUDZUX0hMX0dU
Ow0KKwkJCWluZm8tPmhvcF9saW1pdCA9IHZhbHVlOw0KKwkJCSpmbGFncyA9
IDE7DQorDQorCQkJYnJlYWs7DQorCQlkZWZhdWx0Og0KKwkJCXJldHVybiAw
Ow0KKw0KKwl9DQorDQorCXJldHVybiAxOw0KK30NCisNCitzdGF0aWMgdm9p
ZCBmaW5hbF9jaGVjayh1bnNpZ25lZCBpbnQgZmxhZ3MpDQorew0KKwlpZiAo
IWZsYWdzKSANCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQor
CQkJIkhMIG1hdGNoOiBZb3UgbXVzdCBzcGVjaWZ5IG9uZSBvZiAiDQorCQkJ
ImAtLWhsLWVxJywgYC0taGwtbHQnLCBgLS1obC1ndCIpOw0KK30NCisNCitz
dGF0aWMgdm9pZCBwcmludChjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlwLCAN
CisJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRjaCwNCisJ
CWludCBudW1lcmljKQ0KK3sNCisJY29uc3Qgc3RydWN0IGlwNnRfaGxfaW5m
byAqaW5mbyA9IA0KKwkJKHN0cnVjdCBpcDZ0X2hsX2luZm8gKikgbWF0Y2gt
PmRhdGE7DQorDQorCXByaW50ZigiSEwgbWF0Y2ggIik7DQorCXN3aXRjaCAo
aW5mby0+bW9kZSkgew0KKwkJY2FzZSBJUDZUX0hMX0VROg0KKwkJCXByaW50
ZigiSEwgPT0gIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExfTkU6
DQorCQkJcHJpbnRmKCJITCAhPSAiKTsNCisJCQlicmVhazsNCisJCWNhc2Ug
SVA2VF9ITF9MVDoNCisJCQlwcmludGYoIkhMIDwgIik7DQorCQkJYnJlYWs7
DQorCQljYXNlIElQNlRfSExfR1Q6DQorCQkJcHJpbnRmKCJITCA+ICIpOw0K
KwkJCWJyZWFrOw0KKwl9DQorCXByaW50ZigiJXUgIiwgaW5mby0+aG9wX2xp
bWl0KTsNCit9DQorDQorc3RhdGljIHZvaWQgc2F2ZShjb25zdCBzdHJ1Y3Qg
aXA2dF9pcDYgKmlwLCANCisJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21h
dGNoICptYXRjaCkNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X2hsX2luZm8g
KmluZm8gPQ0KKwkJKHN0cnVjdCBpcDZ0X2hsX2luZm8gKikgbWF0Y2gtPmRh
dGE7DQorDQorCXN3aXRjaCAoaW5mby0+bW9kZSkgew0KKwkJY2FzZSBJUDZU
X0hMX0VROg0KKwkJCXByaW50ZigiLS1obC1lcSAiKTsNCisJCQlicmVhazsN
CisJCWNhc2UgSVA2VF9ITF9ORToNCisJCQlwcmludGYoIiEgLS1obC1lcSAi
KTsNCisJCQlicmVhazsNCisJCWNhc2UgSVA2VF9ITF9MVDoNCisJCQlwcmlu
dGYoIi0taGwtbHQgIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExf
R1Q6DQorCQkJcHJpbnRmKCItLWhsLWd0ICIpOw0KKwkJCWJyZWFrOw0KKwkJ
ZGVmYXVsdDoNCisJCQkvKiBlcnJvciAqLw0KKwkJCWJyZWFrOw0KKwl9DQor
CXByaW50ZigiJXUgIiwgaW5mby0+aG9wX2xpbWl0KTsNCit9DQorDQorc3Rh
dGljIHN0cnVjdCBvcHRpb24gb3B0c1tdID0gew0KKwl7ICJobCIsIDEsIDAs
ICcyJyB9LA0KKwl7ICJobC1lcSIsIDEsIDAsICcyJ30sDQorCXsgImhsLWx0
IiwgMSwgMCwgJzMnfSwNCisJeyAiaGwtZ3QiLCAxLCAwLCAnNCd9LA0KKwl7
IDAgfQ0KK307DQorDQorc3RhdGljDQorc3RydWN0IGlwNnRhYmxlc19tYXRj
aCBobCA9IHsNCisJTlVMTCwNCisJImhsIiwNCisJSVBUQUJMRVNfVkVSU0lP
TiwNCisJSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfaGxfaW5mbykp
LA0KKwlJUDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9obF9pbmZvKSks
DQorCSZoZWxwLA0KKwkmaW5pdCwNCisJJnBhcnNlLA0KKwkmZmluYWxfY2hl
Y2ssDQorCSZwcmludCwNCisJJnNhdmUsDQorCW9wdHMNCit9Ow0KKw0KKw0K
K3ZvaWQgX2luaXQodm9pZCkgDQorew0KKwlyZWdpc3Rlcl9tYXRjaDYoJmhs
KTsNCit9DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2lu
Y2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oIG5ldGZpbHRl
ci91c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0
X0hMLmgNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2UvaW5jbHVkZS9s
aW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X0hMLmgJMTk3MC0wMS0wMSAwMTow
MDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNl
L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oCTIwMDIt
MTItMTYgMTc6MTI6MjkuMDAwMDAwMDAwICswMTAwDQpAQCAtMCwwICsxLDIy
IEBADQorLyogSG9wIExpbWl0IG1vZGlmaWNhdGlvbiBtb2R1bGUgZm9yIGlw
NnRhYmxlcw0KKyAqIE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRveGlj
ZmlsbXMudHY+DQorICogQmFzZWQgb24gSFcncyBUVEwgbW9kdWxlICovDQor
DQorI2lmbmRlZiBfSVA2VF9ITF9IDQorI2RlZmluZSBfSVA2VF9ITF9IDQor
DQorZW51bSB7DQorCUlQNlRfSExfU0VUID0gMCwNCisJSVA2VF9ITF9JTkMs
DQorCUlQNlRfSExfREVDDQorfTsNCisNCisjZGVmaW5lIElQNlRfSExfTUFY
TU9ERQlJUDZUX0hMX0RFQw0KKw0KK3N0cnVjdCBpcDZ0X0hMX2luZm8gew0K
Kwl1X2ludDhfdAltb2RlOw0KKwl1X2ludDhfdAlob3BfbGltaXQ7DQorfTsN
CisNCisNCisjZW5kaWYNCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy91c2Vy
c3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X2hsLmgg
bmV0ZmlsdGVyL3VzZXJzcGFjZS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9p
cHY2L2lwNnRfaGwuaA0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9p
bmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfaGwuaAkxOTcwLTAx
LTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZpbHRlci91
c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X2hs
LmgJMjAwMi0xMi0xNiAxNzoxMTo1Ni4wMDAwMDAwMDAgKzAxMDANCkBAIC0w
LDAgKzEsMjIgQEANCisvKiBpcDZ0YWJsZXMgbW9kdWxlIGZvciBtYXRjaGlu
ZyB0aGUgSG9wIExpbWl0IHZhbHVlDQorICogTWFjaWVqIFNvbHR5c2lhayA8
c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisgKiBCYXNlZCBvbiBIVydzIHR0
bCBtb2R1bGUgKi8NCisNCisjaWZuZGVmIF9JUDZUX0hMX0gNCisjZGVmaW5l
IF9JUDZUX0hMX0gNCisNCitlbnVtIHsNCisJSVA2VF9ITF9FUSA9IDAsCQkv
KiBlcXVhbHMgKi8NCisJSVA2VF9ITF9ORSwJCS8qIG5vdCBlcXVhbHMgKi8N
CisJSVA2VF9ITF9MVCwJCS8qIGxlc3MgdGhhbiAqLw0KKwlJUDZUX0hMX0dU
LAkJLyogZ3JlYXRlciB0aGFuICovDQorfTsNCisNCisNCitzdHJ1Y3QgaXA2
dF9obF9pbmZvIHsNCisJdV9pbnQ4X3QJbW9kZTsNCisJdV9pbnQ4X3QJaG9w
X2xpbWl0Ow0KK307DQorDQorDQorI2VuZGlmDQo=
---23717851-1609057221-1041537651=:21609--
