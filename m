From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Mon, 30 Dec 2002 21:09:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212301950480.6450-200000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-158185776-1041274371=:6450"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Content-ID: <Pine.LNX.4.44.0212302108080.15671@dns.toxicfilms.tv>
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

---23717851-158185776-1041274371=:6450
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0212302108081.15671@dns.toxicfilms.tv>

Hello,

this is a Hop Limit match and target (similar to the TTL modules) for
IPv6.

There was no response on the list to this :(
It's a resend.

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
++ * Maciej Soltysiak <solt@dns.toxicfilms.tv> */
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
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv> */
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

---23717851-158185776-1041274371=:6450
Content-Type: TEXT/plain; name="hl.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0212302109330.15671@dns.toxicfilms.tv>
Content-Description: hl
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
bHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4gKi8NCisrICogQmFz
ZWQgb24gSFcncyBUVEwgbW9kdWxlICovDQorKw0KKysjaWZuZGVmIF9JUDZU
X0hMX0gNCisrI2RlZmluZSBfSVA2VF9ITF9IDQorKw0KKytlbnVtIHsNCisr
CUlQNlRfSExfU0VUID0gMCwNCisrCUlQNlRfSExfSU5DLA0KKysJSVA2VF9I
TF9ERUMNCisrfTsNCisrDQorKyNkZWZpbmUgSVA2VF9ITF9NQVhNT0RFCUlQ
NlRfSExfREVDDQorKw0KKytzdHJ1Y3QgaXA2dF9ITF9pbmZvIHsNCisrCXVf
aW50OF90CW1vZGU7DQorKwl1X2ludDhfdAlob3BfbGltaXQ7DQorK307DQor
Kw0KKysNCisrI2VuZGlmDQorZGlmZiAtTnJ1IGxpbnV4LTIuNC4yMC9uZXQv
aXB2Ni9uZXRmaWx0ZXIvaXA2dF9ITC5jIGxpbnV4Lm5ldy9uZXQvaXB2Ni9u
ZXRmaWx0ZXIvaXA2dF9ITC5jDQorLS0tIGxpbnV4LTIuNC4yMC9uZXQvaXB2
Ni9uZXRmaWx0ZXIvaXA2dF9ITC5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAw
MDAwMDAwICswMTAwDQorKysrIGxpbnV4Lm5ldy9uZXQvaXB2Ni9uZXRmaWx0
ZXIvaXA2dF9ITC5jCTIwMDItMTItMTYgMTc6MDg6MjMuMDAwMDAwMDAwICsw
MTAwDQorQEAgLTAsMCArMSwxMDUgQEANCisrLyogDQorKyAqIEhvcCBMaW1p
dCBtb2RpZmljYXRpb24gdGFyZ2V0IGZvciBpcDZ0YWJsZXMNCisrICogTWFj
aWVqIFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisrICog
QmFzZWQgb24gSFcncyBUVEwgbW9kdWxlDQorKyAqDQorKyAqIFRoaXMgc29m
dHdhcmUgaXMgZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIHRlcm1zIG9mIEdOVSBH
UEwNCisrICovDQorKw0KKysjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQor
KyNpbmNsdWRlIDxsaW51eC9za2J1ZmYuaD4NCisrI2luY2x1ZGUgPGxpbnV4
L2lwLmg+DQorKw0KKysjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYv
aXA2X3RhYmxlcy5oPg0KKysjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lw
djYvaXA2dF9ITC5oPg0KKysNCisrTU9EVUxFX0FVVEhPUigiTWFjaWVqIFNv
bHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4iKTsNCisrTU9EVUxF
X0RFU0NSSVBUSU9OKCJJUCB0YWJsZXMgSG9wIExpbWl0IG1vZGlmaWNhdGlv
biBtb2R1bGUiKTsNCisrTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KKysNCisr
c3RhdGljIHVuc2lnbmVkIGludCBpcDZ0X2hsX3RhcmdldChzdHJ1Y3Qgc2tf
YnVmZiAqKnBza2IsIHVuc2lnbmVkIGludCBob29rbnVtLA0KKysJCWNvbnN0
IHN0cnVjdCBuZXRfZGV2aWNlICppbiwgY29uc3Qgc3RydWN0IG5ldF9kZXZp
Y2UgKm91dCwNCisrCQljb25zdCB2b2lkICp0YXJnaW5mbywgdm9pZCAqdXNl
cmluZm8pDQorK3sNCisrCXN0cnVjdCBpcHY2aGRyICppcDZoID0gKCpwc2ti
KS0+bmguaXB2Nmg7DQorKwljb25zdCBzdHJ1Y3QgaXA2dF9ITF9pbmZvICpp
bmZvID0gdGFyZ2luZm87DQorKwl1X2ludDE2X3QgZGlmZnNbMl07DQorKwlp
bnQgbmV3X2hsOw0KKysJCQkgDQorKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsN
CisrCQljYXNlIElQNlRfSExfU0VUOg0KKysJCQluZXdfaGwgPSBpbmZvLT5o
b3BfbGltaXQ7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9JTkM6
DQorKwkJCW5ld19obCA9IGlwNmgtPmhvcF9saW1pdCArIGluZm8tPmhvcF9s
aW1pdDsNCisrCQkJaWYgKG5ld19obCA+IDI1NSkNCisrCQkJCW5ld19obCA9
IDI1NTsNCisrCQkJYnJlYWs7DQorKwkJY2FzZSBJUDZUX0hMX0RFQzoNCisr
CQkJbmV3X2hsID0gaXA2aC0+aG9wX2xpbWl0ICsgaW5mby0+aG9wX2xpbWl0
Ow0KKysJCQlpZiAobmV3X2hsIDwgMCkNCisrCQkJCW5ld19obCA9IDA7DQor
KwkJCWJyZWFrOw0KKysJCWRlZmF1bHQ6DQorKwkJCW5ld19obCA9IGlwNmgt
PmhvcF9saW1pdDsNCisrCQkJYnJlYWs7DQorKwl9DQorKw0KKysJaWYgKG5l
d19obCAhPSBpcDZoLT5ob3BfbGltaXQpIHsNCisrCQlkaWZmc1swXSA9IGh0
b25zKCgodW5zaWduZWQpaXA2aC0+aG9wX2xpbWl0KSA8PCA4KSBeIDB4RkZG
RjsNCisrCQlpcDZoLT5ob3BfbGltaXQgPSBuZXdfaGw7DQorKwkJZGlmZnNb
MV0gPSBodG9ucygoKHVuc2lnbmVkKWlwNmgtPmhvcF9saW1pdCkgPDwgOCk7
DQorKwl9DQorKw0KKysJcmV0dXJuIElQNlRfQ09OVElOVUU7DQorK30NCisr
DQorK3N0YXRpYyBpbnQgaXA2dF9obF9jaGVja2VudHJ5KGNvbnN0IGNoYXIg
KnRhYmxlbmFtZSwNCisrCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeSAqZSwN
CisrCQl2b2lkICp0YXJnaW5mbywNCisrCQl1bnNpZ25lZCBpbnQgdGFyZ2lu
Zm9zaXplLA0KKysJCXVuc2lnbmVkIGludCBob29rX21hc2spDQorK3sNCisr
CXN0cnVjdCBpcDZ0X0hMX2luZm8gKmluZm8gPSB0YXJnaW5mbzsNCisrDQor
KwlpZiAodGFyZ2luZm9zaXplICE9IElQNlRfQUxJR04oc2l6ZW9mKHN0cnVj
dCBpcDZ0X0hMX2luZm8pKSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcg
IkhMOiB0YXJnaW5mb3NpemUgJXUgIT0gJVp1XG4iLA0KKysJCQkJdGFyZ2lu
Zm9zaXplLA0KKysJCQkJSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRf
SExfaW5mbykpKTsNCisrCQlyZXR1cm4gMDsJDQorKwl9CQ0KKysNCisrCWlm
IChzdHJjbXAodGFibGVuYW1lLCAibWFuZ2xlIikpIHsNCisrCQlwcmludGso
S0VSTl9XQVJOSU5HICJITDogY2FuIG9ubHkgYmUgY2FsbGVkIGZyb20gXCJt
YW5nbGVcIiB0YWJsZSwgbm90IFwiJXNcIlxuIiwgdGFibGVuYW1lKTsNCisr
CQlyZXR1cm4gMDsNCisrCX0NCisrDQorKwlpZiAoaW5mby0+bW9kZSA+IElQ
NlRfSExfTUFYTU9ERSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcgIkhM
OiBpbnZhbGlkIG9yIHVua25vd24gTW9kZSAldVxuIiwgDQorKwkJCWluZm8t
Pm1vZGUpOw0KKysJCXJldHVybiAwOw0KKysJfQ0KKysNCisrCWlmICgoaW5m
by0+bW9kZSAhPSBJUDZUX0hMX1NFVCkgJiYgKGluZm8tPmhvcF9saW1pdCA9
PSAwKSkgew0KKysJCXByaW50ayhLRVJOX1dBUk5JTkcgIkhMOiBpbmNyZW1l
bnQvZGVjcmVtZW50IGRvZXNuJ3QgbWFrZSBzZW5zZSB3aXRoIHZhbHVlIDBc
biIpOw0KKysJCXJldHVybiAwOw0KKysJfQ0KKysJDQorKwlyZXR1cm4gMTsN
CisrfQ0KKysNCisrc3RhdGljIHN0cnVjdCBpcDZ0X3RhcmdldCBpcDZ0X0hM
ID0geyB7IE5VTEwsIE5VTEwgfSwgIkhMIiwgDQorKwlpcDZ0X2hsX3Rhcmdl
dCwgaXA2dF9obF9jaGVja2VudHJ5LCBOVUxMLCBUSElTX01PRFVMRSB9Ow0K
KysNCisrc3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQ0KKyt7DQorKwly
ZXR1cm4gaXA2dF9yZWdpc3Rlcl90YXJnZXQoJmlwNnRfSEwpOw0KKyt9DQor
Kw0KKytzdGF0aWMgdm9pZCBfX2V4aXQgZmluaSh2b2lkKQ0KKyt7DQorKwlp
cDZ0X3VucmVnaXN0ZXJfdGFyZ2V0KCZpcDZ0X0hMKTsNCisrfQ0KKysNCisr
bW9kdWxlX2luaXQoaW5pdCk7DQorK21vZHVsZV9leGl0KGZpbmkpOw0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5w
YXRjaC5pcHY2LmNvbmZpZy5pbiBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9i
YXNlL0hMLnBhdGNoLmlwdjYuY29uZmlnLmluDQotLS0gbmV0ZmlsdGVyLm9y
aWcvcGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlnLmlu
CTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2LmNvbmZp
Zy5pbgkyMDAyLTEyLTE2IDE4OjMyOjI3LjAwMDAwMDAwMCArMDEwMA0KQEAg
LTAsMCArMSw0IEBADQorICBkZXBfdHJpc3RhdGUgJyAgUGFja2V0IGZpbHRl
cmluZycgQ09ORklHX0lQNl9ORl9GSUxURVIgJENPTkZJR19JUDZfTkZfSVBU
QUJMRVMgDQorICBpZiBbICIkQ09ORklHX0lQNl9ORl9GSUxURVIiICE9ICJu
IiBdOyB0aGVuDQorICAgIGRlcF90cmlzdGF0ZSAnICAgIEhMIHRhcmdldCBz
dXBwb3J0JyBDT05GSUdfSVA2X05GX1RBUkdFVF9ITCAkQ09ORklHX0lQNl9O
Rl9GSUxURVINCisgIGZpDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0
Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAg
bmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2LmNv
bmZpZ3VyZS5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRp
Yy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMTk3MC0wMS0w
MSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0
Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJ
MjAwMi0xMi0xNiAxODowMjozMi4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAg
KzEsOCBAQA0KK0NPTkZJR19JUDZfTkZfVEFSR0VUX0xPRw0KK0hMIHRhcmdl
dCBzdXBwb3J0DQorQ09ORklHX0lQNl9ORl9UQVJHRVRfSEwNCisgIFRoaXMg
b3B0aW9uIGFkZHMgYSBgSEwnIHRhcmdldCwgd2hpY2ggYWxsb3dzIHlvdSB0
byBtb2RpZnkgdGhlIHZhbHVlIG9mDQorICBJUHY2IEhvcCBMaW1pdCBmaWVs
ZC4NCisNCisgIElmIHlvdSB3YW50IHRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1
bGUsIHNheSBNIGhlcmUgYW5kIHJlYWQNCisgIDxmaWxlOkRvY3VtZW50YXRp
b24vbW9kdWxlcy50eHQ+LiAgSWYgdW5zdXJlLCBzYXkgYE4nLg0KZGlmZiAt
TnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRj
aC5pcHY2LmhlbHAgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5w
YXRjaC5pcHY2LmhlbHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1h
dGljL2Jhc2UvSEwucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEtMDEgMDE6MDA6
MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0
aWMvYmFzZS9ITC5wYXRjaC5pcHY2LmhlbHAJMjAwMi0xMi0xNiAxODoyMzow
OS4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsMTAgQEANCitBdXRob3I6
IE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRveGljZmlsbXMudHY+DQor
U3RhdHVzOiBXb3JrcyBmb3IgbWUuDQorDQorVGhpcyBhbGxvd3MgdGhlIHVz
ZXIgdG8gc2V0IHRoZSBJUHY2IEhvcCBMaW1pdCB2YWx1ZSBvbiBhIHBhY2tl
dCBvcg0KK3RvIGluY3JlbWVudCBvciBkZWNyZW1lbnQgaXQgYnkgYSBnaXZl
biB2YWx1ZS4NCisNCitFeGFtcGxlOg0KKyMgaXA2dGFibGVzIC10IG1hbmds
ZSAtQSBPVVRQVVQgLWogSEwgLS1obC1pbmMgMQ0KKyMgaXA2dGFibGVzIC10
IG1hbmdsZSAtQSBJTlBVVCAtaiBITCAtLWhsLWVxIDY0DQorIyBpcDZ0YWJs
ZXMgLXQgbWFuZ2xlIC1BIE9VVFBVVCAtaiBITCAtLWhsLWRlYyAyDQpkaWZm
IC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBh
dGNoLmlwdjYubWFrZWZpbGUgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFz
ZS9ITC5wYXRjaC5pcHY2Lm1ha2VmaWxlDQotLS0gbmV0ZmlsdGVyLm9yaWcv
cGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYubWFrZWZpbGUJMTk3
MC0wMS0wMSAwMTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0
ZXIvcGF0Y2gtby1tYXRpYy9iYXNlL0hMLnBhdGNoLmlwdjYubWFrZWZpbGUJ
MjAwMi0xMi0xNiAxODoxMDo0NS4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAg
KzEsMiBAQA0KK29iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX0xPRykgKz0g
aXA2dF9MT0cubw0KK29iai0kKENPTkZJR19JUF9ORl9UQVJHRVRfSEwpICs9
IGlwdF9ITC5vDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1t
YXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0
aWMvYmFzZS9obC5wYXRjaC5pcHY2DQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0
Y2gtby1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYJMTk3MC0wMS0wMSAwMTow
MDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gtby1t
YXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYJMjAwMi0xMi0xNiAxODowNToxOS4w
MDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsMTA0IEBADQorZGlmZiAtTnJ1
IGxpbnV4LTIuNC4yMC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lw
NnRfaGwuaCBsaW51eC5uZXcvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2
Ni9pcDZ0X2hsLmgNCistLS0gbGludXgtMi40LjIwL2luY2x1ZGUvbGludXgv
bmV0ZmlsdGVyX2lwdjYvaXA2dF9obC5oCTE5NzAtMDEtMDEgMDE6MDA6MDAu
MDAwMDAwMDAwICswMTAwDQorKysrIGxpbnV4Lm5ldy9pbmNsdWRlL2xpbnV4
L25ldGZpbHRlcl9pcHY2L2lwNnRfaGwuaAkyMDAyLTEyLTE2IDE3OjExOjU2
LjAwMDAwMDAwMCArMDEwMA0KK0BAIC0wLDAgKzEsMjIgQEANCisrLyogaXA2
dGFibGVzIG1vZHVsZSBmb3IgbWF0Y2hpbmcgdGhlIEhvcCBMaW1pdCB2YWx1
ZQ0KKysgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1z
LnR2Pg0KKysgKiBCYXNlZCBvbiBIVydzIHR0bCBtb2R1bGUgKi8NCisrDQor
KyNpZm5kZWYgX0lQNlRfSExfSA0KKysjZGVmaW5lIF9JUDZUX0hMX0gNCisr
DQorK2VudW0gew0KKysJSVA2VF9ITF9FUSA9IDAsCQkvKiBlcXVhbHMgKi8N
CisrCUlQNlRfSExfTkUsCQkvKiBub3QgZXF1YWxzICovDQorKwlJUDZUX0hM
X0xULAkJLyogbGVzcyB0aGFuICovDQorKwlJUDZUX0hMX0dULAkJLyogZ3Jl
YXRlciB0aGFuICovDQorK307DQorKw0KKysNCisrc3RydWN0IGlwNnRfaGxf
aW5mbyB7DQorKwl1X2ludDhfdAltb2RlOw0KKysJdV9pbnQ4X3QJaG9wX2xp
bWl0Ow0KKyt9Ow0KKysNCisrDQorKyNlbmRpZg0KK2RpZmYgLU5ydSBsaW51
eC0yLjQuMjAvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYyBsaW51eC5u
ZXcvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYw0KKy0tLSBsaW51eC0y
LjQuMjAvbmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYwkxOTcwLTAxLTAx
IDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrKyBsaW51eC5uZXcvbmV0
L2lwdjYvbmV0ZmlsdGVyL2lwNnRfaGwuYwkyMDAyLTEyLTE2IDE3OjA5OjUz
LjAwMDAwMDAwMCArMDEwMA0KK0BAIC0wLDAgKzEsNzQgQEANCisrLyoNCisr
ICogSG9wIExpbWl0IG1hdGNoaW5nIG1vZHVsZQ0KKysgKiBNYWNpZWogU29s
dHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2Pg0KKysgKiBCYXNlZCBv
biBIVydzIHR0bCBtb2R1bGUNCisrICoNCisrICogVGhpcyBzb2Z0d2FyZSBp
cyBkaXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMgIEdOVSBHUEwNCisrICov
DQorKw0KKysjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQorKyNpbmNsdWRl
IDxsaW51eC9za2J1ZmYuaD4NCisrDQorKyNpbmNsdWRlIDxsaW51eC9uZXRm
aWx0ZXJfaXB2Ni9pcDZ0X2hsLmg+DQorKyNpbmNsdWRlIDxsaW51eC9uZXRm
aWx0ZXJfaXB2Ni9pcDZfdGFibGVzLmg+DQorKw0KKytNT0RVTEVfQVVUSE9S
KCJNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2PiIp
Ow0KKytNT0RVTEVfREVTQ1JJUFRJT04oIklQIHRhYmxlcyBIb3AgTGltaXQg
bWF0Y2hpbmcgbW9kdWxlIik7DQorK01PRFVMRV9MSUNFTlNFKCJHUEwiKTsN
CisrDQorK3N0YXRpYyBpbnQgbWF0Y2goY29uc3Qgc3RydWN0IHNrX2J1ZmYg
KnNrYiwgY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmluLA0KKysJCSBjb25z
dCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0LCBjb25zdCB2b2lkICptYXRjaGlu
Zm8sDQorKwkJIGludCBvZmZzZXQsIGNvbnN0IHZvaWQgKmhkciwgdV9pbnQx
Nl90IGRhdGFsZW4sDQorKwkJIGludCAqaG90ZHJvcCkNCisrew0KKysJY29u
c3Qgc3RydWN0IGlwNnRfaGxfaW5mbyAqaW5mbyA9IG1hdGNoaW5mbzsNCisr
CWNvbnN0IHN0cnVjdCBpcHY2aGRyICppcDZoID0gc2tiLT5uaC5pcHY2aDsN
CisrDQorKwlzd2l0Y2ggKGluZm8tPm1vZGUpIHsNCisrCQljYXNlIElQNlRf
SExfRVE6DQorKwkJCXJldHVybiAoaXA2aC0+aG9wX2xpbWl0ID09IGluZm8t
PmhvcF9saW1pdCk7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9O
RToNCisrCQkJcmV0dXJuICghKGlwNmgtPmhvcF9saW1pdCA9PSBpbmZvLT5o
b3BfbGltaXQpKTsNCisrCQkJYnJlYWs7DQorKwkJY2FzZSBJUDZUX0hMX0xU
Og0KKysJCQlyZXR1cm4gKGlwNmgtPmhvcF9saW1pdCA8IGluZm8tPmhvcF9s
aW1pdCk7DQorKwkJCWJyZWFrOw0KKysJCWNhc2UgSVA2VF9ITF9HVDoNCisr
CQkJcmV0dXJuIChpcDZoLT5ob3BfbGltaXQgPiBpbmZvLT5ob3BfbGltaXQp
Ow0KKysJCQlicmVhazsNCisrCQlkZWZhdWx0Og0KKysJCQlwcmludGsoS0VS
Tl9XQVJOSU5HICJpcDZ0X2hsOiB1bmtub3duIG1vZGUgJWRcbiIsIA0KKysJ
CQkJaW5mby0+bW9kZSk7DQorKwkJCXJldHVybiAwOw0KKysJfQ0KKysNCisr
CXJldHVybiAwOw0KKyt9DQorKw0KKytzdGF0aWMgaW50IGNoZWNrZW50cnko
Y29uc3QgY2hhciAqdGFibGVuYW1lLCBjb25zdCBzdHJ1Y3QgaXA2dF9pcCAq
aXAsDQorKwkJICAgICAgdm9pZCAqbWF0Y2hpbmZvLCB1bnNpZ25lZCBpbnQg
bWF0Y2hzaXplLA0KKysJCSAgICAgIHVuc2lnbmVkIGludCBob29rX21hc2sp
DQorK3sNCisrCWlmIChtYXRjaHNpemUgIT0gSVA2VF9BTElHTihzaXplb2Yo
c3RydWN0IGlwNnRfaGxfaW5mbykpKQ0KKysJCXJldHVybiAwOw0KKysNCisr
CXJldHVybiAxOw0KKyt9DQorKw0KKytzdGF0aWMgc3RydWN0IGlwNnRfbWF0
Y2ggaGxfbWF0Y2ggPSB7IHsgTlVMTCwgTlVMTCB9LCAiaGwiLCAmbWF0Y2gs
DQorKwkJJmNoZWNrZW50cnksIE5VTEwsIFRISVNfTU9EVUxFIH07DQorKw0K
KytzdGF0aWMgaW50IF9faW5pdCBpbml0KHZvaWQpDQorK3sNCisrCXJldHVy
biBpcDZ0X3JlZ2lzdGVyX21hdGNoKCZobF9tYXRjaCk7DQorK30NCisrDQor
K3N0YXRpYyB2b2lkIF9fZXhpdCBmaW5pKHZvaWQpDQorK3sNCisrCWlwNnRf
dW5yZWdpc3Rlcl9tYXRjaCgmaGxfbWF0Y2gpOw0KKysNCisrfQ0KKysNCisr
bW9kdWxlX2luaXQoaW5pdCk7DQorK21vZHVsZV9leGl0KGZpbmkpOw0KZGlm
ZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5w
YXRjaC5pcHY2LmNvbmZpZy5pbiBuZXRmaWx0ZXIvcGF0Y2gtby1tYXRpYy9i
YXNlL2hsLnBhdGNoLmlwdjYuY29uZmlnLmluDQotLS0gbmV0ZmlsdGVyLm9y
aWcvcGF0Y2gtby1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlnLmlu
CTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZp
Zy5pbgkyMDAyLTEyLTE2IDE4OjA4OjU1LjAwMDAwMDAwMCArMDEwMA0KQEAg
LTAsMCArMSwyIEBADQorICBkZXBfdHJpc3RhdGUgJyAgTUFDIGFkZHJlc3Mg
bWF0Y2ggc3VwcG9ydCcgQ09ORklHX0lQNl9ORl9NQVRDSF9NQUMgJENPTkZJ
R19JUDZfTkZfSVBUQUJMRVMNCisgIGRlcF90cmlzdGF0ZSAnICBITCBtYXRj
aCBzdXBwb3J0JyBDT05GSUdfSVA2X05GX01BVENIX0hMICRDT05GSUdfSVA2
X05GX0lQVEFCTEVTDQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvcGF0Y2gt
by1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2LmNvbmZp
Z3VyZS5oZWxwDQotLS0gbmV0ZmlsdGVyLm9yaWcvcGF0Y2gtby1tYXRpYy9i
YXNlL2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMTk3MC0wMS0wMSAw
MTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvcGF0Y2gt
by1tYXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYuY29uZmlndXJlLmhlbHAJMjAw
Mi0xMi0xNiAxODowNDowMS4wMDAwMDAwMDAgKzAxMDANCkBAIC0wLDAgKzEs
OCBAQA0KK0NPTkZJR19JUDZfTkZfVEFSR0VUX0xPRw0KK0hMIG1hdGNoIHN1
cHBvcnQNCitDT05GSUdfSVA2X05GX01BVENIX0hMDQorICBUaGlzIG9wdGlv
biBhZGRzIGEgYGhsJyBtYXRjaCwgd2hpY2ggYWxsb3dzIHlvdSBtYXRjaCB0
aGUgdmFsdWUgb2YNCisgIHRoZSBJUHY2IEhvcCBMaW1pdCBmaWVsZC4NCisN
CisgIElmIHlvdSB3YW50IHRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUsIHNh
eSBNIGhlcmUgYW5kIHJlYWQNCisgIDxmaWxlOkRvY3VtZW50YXRpb24vbW9k
dWxlcy50eHQ+LiAgSWYgdW5zdXJlLCBzYXkgYE4nLg0KZGlmZiAtTnJ1IG5l
dGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5pcHY2
LmhlbHAgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9obC5wYXRjaC5p
cHY2LmhlbHANCi0tLSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jh
c2UvaGwucGF0Y2guaXB2Ni5oZWxwCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAw
MDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFz
ZS9obC5wYXRjaC5pcHY2LmhlbHAJMjAwMi0xMi0xNiAxODoyMjoyNS4wMDAw
MDAwMDAgKzAxMDANCkBAIC0wLDAgKzEsOSBAQA0KK0F1dGhvcjogTWFjaWVq
IFNvbHR5c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCitTdGF0dXM6
IFdvcmtzIGZvciBtZS4NCisNCitUaGlzIGFsbG93cyB0aGUgdXNlciB0byBt
YXRjaCB0aGUgSVB2NiBIb3AgTGltaXQgdmFsdWUgb24gYSBwYWNrZXQuDQor
DQorRXhhbXBsZXM6DQorIyBpcDZ0YWJsZXMgLUEgSU5QVVQgLW0gaGwgLS1o
bC1lcSA2MyAtaiBMT0cgLS1sb2ctcHJlZml4ICJCbGFoOiAiDQorIyBpcDZ0
YWJsZXMgLUEgRk9SV0FSRCAtbSBobCAtLWhsLWd0IDY0IC1qIERST1ANCisj
IGlwNnRhYmxlcyAtQSBPVVRQVVQgLW0gaGwgLS1obC1sdCA2NCAtaiBBQ0NF
UFQNCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jh
c2UvaGwucGF0Y2guaXB2Ni5tYWtlZmlsZSBuZXRmaWx0ZXIvcGF0Y2gtby1t
YXRpYy9iYXNlL2hsLnBhdGNoLmlwdjYubWFrZWZpbGUNCi0tLSBuZXRmaWx0
ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5tYWtl
ZmlsZQkxOTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysr
IG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2UvaGwucGF0Y2guaXB2Ni5t
YWtlZmlsZQkyMDAyLTEyLTE2IDE4OjExOjAzLjAwMDAwMDAwMCArMDEwMA0K
QEAgLTAsMCArMSwyIEBADQorb2JqLSQoQ09ORklHX0lQNl9ORl9UQVJHRVRf
TE9HKSArPSBpcDZ0X0xPRy5vDQorb2JqLSQoQ09ORklHX0lQX05GX01BVENI
X0hMKSArPSBpcHRfaGwubw0KZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3Vz
ZXJzcGFjZS9leHRlbnNpb25zL01ha2VmaWxlIG5ldGZpbHRlci91c2Vyc3Bh
Y2UvZXh0ZW5zaW9ucy9NYWtlZmlsZQ0KLS0tIG5ldGZpbHRlci5vcmlnL3Vz
ZXJzcGFjZS9leHRlbnNpb25zL01ha2VmaWxlCTIwMDItMTItMDkgMTA6MzE6
MjMuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9l
eHRlbnNpb25zL01ha2VmaWxlCTIwMDItMTItMTYgMTY6NTc6NDQuMDAwMDAw
MDAwICswMTAwDQpAQCAtMSw3ICsxLDcgQEANCiAjISAvdXNyL2Jpbi9tYWtl
DQogDQogUEZfRVhUX1NMSUI6PWFoIGNvbm50cmFjayBkc2NwIGVjbiBlc3Ag
aGVscGVyIGljbXAgbGVuZ3RoIGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBv
d25lciBwa3R0eXBlIHN0YW5kYXJkIHN0YXRlIHRjcCB0Y3Btc3MgdG9zIHR0
bCB1ZHAgdW5jbGVhbiBETkFUIERTQ1AgRUNOIExPRyBNQVJLIE1BU1FVRVJB
REUgTUlSUk9SIFJFRElSRUNUIFJFSkVDVCBTQU1FIFNOQVQgVEFSUElUIFRD
UE1TUyBUT1MgVUxPRw0KLVBGNl9FWFRfU0xJQjo9ZXVpNjQgaWNtcHY2IGxl
bmd0aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBvcnQgb3duZXIgc3RhbmRhcmQg
dGNwIHVkcCBMT0cgTUFSSw0KK1BGNl9FWFRfU0xJQjo9ZXVpNjQgaWNtcHY2
IGxlbmd0aCBsaW1pdCBtYWMgbWFyayBtdWx0aXBvcnQgb3duZXIgc3RhbmRh
cmQgdGNwIHVkcCBMT0cgTUFSSyBobCBITA0KIA0KICMgVGhlIGZvbGxvd2lu
ZyBtYXkgbm90IGJlIHByZXNlbnQsIGJ1dCBjb21waWxlIHRoZW0gYW55d2F5
Lg0KIFBGX0VYVF9TTElCKz1UVEwgaXBsaW1pdA0KZGlmZiAtTnJ1IG5ldGZp
bHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfSEwuYyBu
ZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2dF9ITC5jDQot
LS0gbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvbGliaXA2
dF9ITC5jCTE5NzAtMDEtMDEgMDE6MDA6MDAuMDAwMDAwMDAwICswMTAwDQor
KysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlwNnRfSEwu
YwkyMDAyLTEyLTE2IDE3OjA1OjU3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTAs
MCArMSwxNjQgQEANCisvKg0KKyAqIElQdjYgSG9wIExpbWl0IFRhcmdldCBt
b2R1bGUNCisgKiBNYWNpZWogU29sdHlzaWFrIDxzb2x0QGRucy50b3hpY2Zp
bG1zLnR2Pg0KKyAqIEJhc2VkIG9uIEhXJ3MgdHRsIHRhcmdldA0KKyAqIFRo
aXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCB1bmRlciB0aGUgdGVybXMgb2Yg
R05VIEdQTA0KKyAqLw0KKw0KKyNpbmNsdWRlIDxzdGRpby5oPg0KKyNpbmNs
dWRlIDxzdHJpbmcuaD4NCisjaW5jbHVkZSA8c3RkbGliLmg+DQorI2luY2x1
ZGUgPGdldG9wdC5oPg0KKyNpbmNsdWRlIDxpcDZ0YWJsZXMuaD4NCisNCisj
aW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2X3RhYmxlcy5oPg0K
KyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X0hMLmg+DQor
DQorI2RlZmluZSBJUDZUX0hMX1VTRUQJMQ0KKw0KK3N0YXRpYyB2b2lkIGlu
aXQoc3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICp0LCB1bnNpZ25lZCBpbnQg
Km5mY2FjaGUpIA0KK3sNCit9DQorDQorc3RhdGljIHZvaWQgaGVscCh2b2lk
KSANCit7DQorCXByaW50ZigNCisiSEwgdGFyZ2V0IHYlcyBvcHRpb25zXG4i
DQorIiAgLS1obC1zZXQgdmFsdWUJCVNldCBITCB0byA8dmFsdWU+XG4iDQor
IiAgLS1obC1kZWMgdmFsdWUJCURlY3JlbWVudCBITCBieSA8dmFsdWU+XG4i
DQorIiAgLS1obC1pbmMgdmFsdWUJCUluY3JlbWVudCBITCBieSA8dmFsdWU+
XG4iDQorLCBJUFRBQkxFU19WRVJTSU9OKTsNCit9DQorDQorc3RhdGljIGlu
dCBwYXJzZShpbnQgYywgY2hhciAqKmFyZ3YsIGludCBpbnZlcnQsIHVuc2ln
bmVkIGludCAqZmxhZ3MsDQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeSAq
ZW50cnksDQorCQlzdHJ1Y3QgaXA2dF9lbnRyeV90YXJnZXQgKip0YXJnZXQp
DQorew0KKwlzdHJ1Y3QgaXA2dF9ITF9pbmZvICppbmZvID0gKHN0cnVjdCBp
cDZ0X0hMX2luZm8gKikgKCp0YXJnZXQpLT5kYXRhOw0KKwl1X2ludDhfdCB2
YWx1ZTsNCisNCisJaWYgKCpmbGFncyAmIElQNlRfSExfVVNFRCkgew0KKwkJ
ZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwgDQorCQkJCSJDYW4ndCBz
cGVjaWZ5IEhMIG9wdGlvbiB0d2ljZSIpOw0KKwl9DQorDQorCWlmICghb3B0
YXJnKSANCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sIA0KKwkJ
CQkiSEw6IFlvdSBtdXN0IHNwZWNpZnkgYSB2YWx1ZSIpOw0KKw0KKwlpZiAo
Y2hlY2tfaW52ZXJzZShvcHRhcmcsICZpbnZlcnQsIE5VTEwsIDApKQ0KKwkJ
ZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwNCisJCQkJIkhMOiB1bmV4
cGVjdGVkIGAhJyIpOw0KKwkNCisJdmFsdWUgPSBhdG9pKG9wdGFyZyk7DQor
DQorCXN3aXRjaCAoYykgew0KKw0KKwkJY2FzZSAnMSc6DQorCQkJaW5mby0+
bW9kZSA9IElQNlRfSExfU0VUOw0KKwkJCWJyZWFrOw0KKw0KKwkJY2FzZSAn
Mic6DQorCQkJaWYgKHZhbHVlID09IDApIHsNCisJCQkJZXhpdF9lcnJvcihQ
QVJBTUVURVJfUFJPQkxFTSwNCisJCQkJCSJITDogZGVjcmVhc2luZyBieSAw
PyIpOw0KKwkJCX0NCisNCisJCQlpbmZvLT5tb2RlID0gSVA2VF9ITF9ERUM7
DQorCQkJYnJlYWs7DQorDQorCQljYXNlICczJzoNCisJCQlpZiAodmFsdWUg
PT0gMCkgew0KKwkJCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0K
KwkJCQkJIkhMOiBpbmNyZWFzaW5nIGJ5IDA/Iik7DQorCQkJfQ0KKw0KKwkJ
CWluZm8tPm1vZGUgPSBJUDZUX0hMX0lOQzsNCisJCQlicmVhazsNCisNCisJ
CWRlZmF1bHQ6DQorCQkJcmV0dXJuIDA7DQorDQorCX0NCisJDQorCWluZm8t
PmhvcF9saW1pdCA9IHZhbHVlOw0KKwkqZmxhZ3MgfD0gSVA2VF9ITF9VU0VE
Ow0KKw0KKwlyZXR1cm4gMTsNCit9DQorDQorc3RhdGljIHZvaWQgZmluYWxf
Y2hlY2sodW5zaWduZWQgaW50IGZsYWdzKQ0KK3sNCisJaWYgKCEoZmxhZ3Mg
JiBJUDZUX0hMX1VTRUQpKQ0KKwkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJP
QkxFTSwNCisJCQkJIkhMOiBZb3UgbXVzdCBzcGVjaWZ5IGFuIGFjdGlvbiIp
Ow0KK30NCisNCitzdGF0aWMgdm9pZCBzYXZlKGNvbnN0IHN0cnVjdCBpcDZ0
X2lwNiAqaXAsDQorCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeV90YXJnZXQg
KnRhcmdldCkNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X0hMX2luZm8gKmlu
Zm8gPSANCisJCShzdHJ1Y3QgaXA2dF9ITF9pbmZvICopIHRhcmdldC0+ZGF0
YTsNCisNCisJc3dpdGNoIChpbmZvLT5tb2RlKSB7DQorCQljYXNlIElQNlRf
SExfU0VUOg0KKwkJCXByaW50ZigiLS1obC1zZXQgIik7DQorCQkJYnJlYWs7
DQorCQljYXNlIElQNlRfSExfREVDOg0KKwkJCXByaW50ZigiLS1obC1kZWMg
Iik7DQorCQkJYnJlYWs7DQorDQorCQljYXNlIElQNlRfSExfSU5DOg0KKwkJ
CXByaW50ZigiLS1obC1pbmMgIik7DQorCQkJYnJlYWs7DQorCX0NCisJcHJp
bnRmKCIldSAiLCBpbmZvLT5ob3BfbGltaXQpOw0KK30NCisNCitzdGF0aWMg
dm9pZCBwcmludChjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlwLA0KKwkJY29u
c3Qgc3RydWN0IGlwNnRfZW50cnlfdGFyZ2V0ICp0YXJnZXQsIGludCBudW1l
cmljKQ0KK3sNCisJY29uc3Qgc3RydWN0IGlwNnRfSExfaW5mbyAqaW5mbyA9
DQorCQkoc3RydWN0IGlwNnRfSExfaW5mbyAqKSB0YXJnZXQtPmRhdGE7DQor
DQorCXByaW50ZigiSEwgIik7DQorCXN3aXRjaCAoaW5mby0+bW9kZSkgew0K
KwkJY2FzZSBJUDZUX0hMX1NFVDoNCisJCQlwcmludGYoInNldCB0byAiKTsN
CisJCQlicmVhazsNCisJCWNhc2UgSVA2VF9ITF9ERUM6DQorCQkJcHJpbnRm
KCJkZWNyZW1lbnQgYnkgIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRf
SExfSU5DOg0KKwkJCXByaW50ZigiaW5jcmVtZW50IGJ5ICIpOw0KKwkJCWJy
ZWFrOw0KKwl9DQorCXByaW50ZigiJXUgIiwgaW5mby0+aG9wX2xpbWl0KTsN
Cit9DQorDQorc3RhdGljIHN0cnVjdCBvcHRpb24gb3B0c1tdID0gew0KKwl7
ICJobC1zZXQiLCAxLCAwLCAnMScgfSwNCisJeyAiaGwtZGVjIiwgMSwgMCwg
JzInIH0sDQorCXsgImhsLWluYyIsIDEsIDAsICczJyB9LA0KKwl7IDAgfQ0K
K307DQorDQorc3RhdGljDQorc3RydWN0IGlwNnRhYmxlc190YXJnZXQgSEwg
PSB7IE5VTEwsIA0KKwkiSEwiLA0KKwlJUFRBQkxFU19WRVJTSU9OLA0KKwlJ
UDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9ITF9pbmZvKSksDQorCUlQ
NlRfQUxJR04oc2l6ZW9mKHN0cnVjdCBpcDZ0X0hMX2luZm8pKSwNCisJJmhl
bHAsDQorCSZpbml0LA0KKwkmcGFyc2UsDQorCSZmaW5hbF9jaGVjaywNCisJ
JnByaW50LA0KKwkmc2F2ZSwNCisJb3B0cyANCit9Ow0KKw0KK3ZvaWQgX2lu
aXQodm9pZCkNCit7DQorCXJlZ2lzdGVyX3RhcmdldDYoJkhMKTsNCit9DQpk
aWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMv
bGliaXA2dF9obC5jIG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0ZW5zaW9ucy9s
aWJpcDZ0X2hsLmMNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2UvZXh0
ZW5zaW9ucy9saWJpcDZ0X2hsLmMJMTk3MC0wMS0wMSAwMTowMDowMC4wMDAw
MDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNwYWNlL2V4dGVuc2lv
bnMvbGliaXA2dF9obC5jCTIwMDItMTItMTYgMTc6MDU6MTQuMDAwMDAwMDAw
ICswMTAwDQpAQCAtMCwwICsxLDE3NyBAQA0KKy8qDQorICogSVB2NiBIb3Ag
TGltaXQgbWF0Y2hpbmcgbW9kdWxlDQorICogTWFjaWVqIFNvbHR5c2lhayA8
c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisgKiBCYXNlZCBvbiBIVydzIHR0
bCBtYXRjaA0KKyAqIFRoaXMgcHJvZ3JhbSBpcyByZWxlYXNlZCB1bmRlciB0
aGUgdGVybXMgb2YgR05VIEdQTA0KKyAqLw0KKw0KKyNpbmNsdWRlIDxzdGRp
by5oPg0KKyNpbmNsdWRlIDxzdGRsaWIuaD4NCisjaW5jbHVkZSA8c3RyaW5n
Lmg+DQorI2luY2x1ZGUgPGdldG9wdC5oPg0KKyNpbmNsdWRlIDxpcDZ0YWJs
ZXMuaD4NCisNCisjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2
X3RhYmxlcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2Ni9p
cDZ0X2hsLmg+DQorDQorc3RhdGljIHZvaWQgaGVscCh2b2lkKSANCit7DQor
CXByaW50ZigNCisiSEwgbWF0Y2ggdiVzIG9wdGlvbnM6XG4iDQorIiAgLS1o
bC1lcSB2YWx1ZQlNYXRjaCBob3AgbGltaXQgdmFsdWVcbiINCisiICAtLWhs
LWx0IHZhbHVlCU1hdGNoIEhMIDwgdmFsdWVcbiINCisiICAtLWhsLWd0IHZh
bHVlCU1hdGNoIEhMID4gdmFsdWVcbiINCissIElQVEFCTEVTX1ZFUlNJT04p
Ow0KK30NCisNCitzdGF0aWMgdm9pZCBpbml0KHN0cnVjdCBpcDZ0X2VudHJ5
X21hdGNoICptLCB1bnNpZ25lZCBpbnQgKm5mY2FjaGUpDQorew0KKwkvKiBj
YWNoaW5nIG5vdCB5ZXQgaW1wbGVtZW50ZWQgKi8NCisJKm5mY2FjaGUgfD0g
TkZDX1VOS05PV047DQorfQ0KKw0KK3N0YXRpYyBpbnQgcGFyc2UoaW50IGMs
IGNoYXIgKiphcmd2LCBpbnQgaW52ZXJ0LCB1bnNpZ25lZCBpbnQgKmZsYWdz
LA0KKwkJY29uc3Qgc3RydWN0IGlwNnRfZW50cnkgKmVudHJ5LCB1bnNpZ25l
ZCBpbnQgKm5mY2FjaGUsDQorCQlzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRjaCAq
Km1hdGNoKQ0KK3sNCisJc3RydWN0IGlwNnRfaGxfaW5mbyAqaW5mbyA9IChz
dHJ1Y3QgaXA2dF9obF9pbmZvICopICgqbWF0Y2gpLT5kYXRhOw0KKwl1X2lu
dDhfdCB2YWx1ZTsNCisNCisJY2hlY2tfaW52ZXJzZShvcHRhcmcsICZpbnZl
cnQsICZvcHRpbmQsIDApOw0KKwl2YWx1ZSA9IGF0b2koYXJndltvcHRpbmQt
MV0pOw0KKw0KKwlpZiAoKmZsYWdzKSANCisJCWV4aXRfZXJyb3IoUEFSQU1F
VEVSX1BST0JMRU0sIA0KKwkJCQkiQ2FuJ3Qgc3BlY2lmeSBITCBvcHRpb24g
dHdpY2UiKTsNCisNCisJaWYgKCFvcHRhcmcpDQorCQlleGl0X2Vycm9yKFBB
UkFNRVRFUl9QUk9CTEVNLA0KKwkJCQkiaGw6IFlvdSBtdXN0IHNwZWNpZnkg
YSB2YWx1ZSIpOw0KKwlzd2l0Y2ggKGMpIHsNCisJCWNhc2UgJzInOg0KKwkJ
CWlmIChpbnZlcnQpDQorCQkJCWluZm8tPm1vZGUgPSBJUDZUX0hMX05FOw0K
KwkJCWVsc2UNCisJCQkJaW5mby0+bW9kZSA9IElQNlRfSExfRVE7DQorDQor
CQkJLyogaXMgMCBhbGxvd2VkPyAqLw0KKwkJCWluZm8tPmhvcF9saW1pdCA9
IHZhbHVlOw0KKwkJCSpmbGFncyA9IDE7DQorDQorCQkJYnJlYWs7DQorCQlj
YXNlICczJzoNCisJCQlpZiAoaW52ZXJ0KSANCisJCQkJZXhpdF9lcnJvcihQ
QVJBTUVURVJfUFJPQkxFTSwNCisJCQkJCQkiaGw6IHVuZXhwZWN0ZWQgYCEn
Iik7DQorDQorCQkJaW5mby0+bW9kZSA9IElQNlRfSExfTFQ7DQorCQkJaW5m
by0+aG9wX2xpbWl0ID0gdmFsdWU7DQorCQkJKmZsYWdzID0gMTsNCisNCisJ
CQlicmVhazsNCisJCWNhc2UgJzQnOg0KKwkJCWlmIChpbnZlcnQpDQorCQkJ
CWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJCQkJImhsOiB1
bmV4cGVjdGVkIGAhJyIpOw0KKw0KKwkJCWluZm8tPm1vZGUgPSBJUDZUX0hM
X0dUOw0KKwkJCWluZm8tPmhvcF9saW1pdCA9IHZhbHVlOw0KKwkJCSpmbGFn
cyA9IDE7DQorDQorCQkJYnJlYWs7DQorCQlkZWZhdWx0Og0KKwkJCXJldHVy
biAwOw0KKw0KKwl9DQorDQorCXJldHVybiAxOw0KK30NCisNCitzdGF0aWMg
dm9pZCBmaW5hbF9jaGVjayh1bnNpZ25lZCBpbnQgZmxhZ3MpDQorew0KKwlp
ZiAoIWZsYWdzKSANCisJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0s
DQorCQkJIkhMIG1hdGNoOiBZb3UgbXVzdCBzcGVjaWZ5IG9uZSBvZiAiDQor
CQkJImAtLWhsLWVxJywgYC0taGwtbHQnLCBgLS1obC1ndCIpOw0KK30NCisN
CitzdGF0aWMgdm9pZCBwcmludChjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlw
LCANCisJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRjaCwN
CisJCWludCBudW1lcmljKQ0KK3sNCisJY29uc3Qgc3RydWN0IGlwNnRfaGxf
aW5mbyAqaW5mbyA9IA0KKwkJKHN0cnVjdCBpcDZ0X2hsX2luZm8gKikgbWF0
Y2gtPmRhdGE7DQorDQorCXByaW50ZigiSEwgbWF0Y2ggIik7DQorCXN3aXRj
aCAoaW5mby0+bW9kZSkgew0KKwkJY2FzZSBJUDZUX0hMX0VROg0KKwkJCXBy
aW50ZigiSEwgPT0gIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRfSExf
TkU6DQorCQkJcHJpbnRmKCJITCAhPSAiKTsNCisJCQlicmVhazsNCisJCWNh
c2UgSVA2VF9ITF9MVDoNCisJCQlwcmludGYoIkhMIDwgIik7DQorCQkJYnJl
YWs7DQorCQljYXNlIElQNlRfSExfR1Q6DQorCQkJcHJpbnRmKCJITCA+ICIp
Ow0KKwkJCWJyZWFrOw0KKwl9DQorCXByaW50ZigiJXUgIiwgaW5mby0+aG9w
X2xpbWl0KTsNCit9DQorDQorc3RhdGljIHZvaWQgc2F2ZShjb25zdCBzdHJ1
Y3QgaXA2dF9pcDYgKmlwLCANCisJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5
X21hdGNoICptYXRjaCkNCit7DQorCWNvbnN0IHN0cnVjdCBpcDZ0X2hsX2lu
Zm8gKmluZm8gPQ0KKwkJKHN0cnVjdCBpcDZ0X2hsX2luZm8gKikgbWF0Y2gt
PmRhdGE7DQorDQorCXN3aXRjaCAoaW5mby0+bW9kZSkgew0KKwkJY2FzZSBJ
UDZUX0hMX0VROg0KKwkJCXByaW50ZigiLS1obC1lcSAiKTsNCisJCQlicmVh
azsNCisJCWNhc2UgSVA2VF9ITF9ORToNCisJCQlwcmludGYoIiEgLS1obC1l
cSAiKTsNCisJCQlicmVhazsNCisJCWNhc2UgSVA2VF9ITF9MVDoNCisJCQlw
cmludGYoIi0taGwtbHQgIik7DQorCQkJYnJlYWs7DQorCQljYXNlIElQNlRf
SExfR1Q6DQorCQkJcHJpbnRmKCItLWhsLWd0ICIpOw0KKwkJCWJyZWFrOw0K
KwkJZGVmYXVsdDoNCisJCQkvKiBlcnJvciAqLw0KKwkJCWJyZWFrOw0KKwl9
DQorCXByaW50ZigiJXUgIiwgaW5mby0+aG9wX2xpbWl0KTsNCit9DQorDQor
c3RhdGljIHN0cnVjdCBvcHRpb24gb3B0c1tdID0gew0KKwl7ICJobCIsIDEs
IDAsICcyJyB9LA0KKwl7ICJobC1lcSIsIDEsIDAsICcyJ30sDQorCXsgImhs
LWx0IiwgMSwgMCwgJzMnfSwNCisJeyAiaGwtZ3QiLCAxLCAwLCAnNCd9LA0K
Kwl7IDAgfQ0KK307DQorDQorc3RhdGljDQorc3RydWN0IGlwNnRhYmxlc19t
YXRjaCBobCA9IHsNCisJTlVMTCwNCisJImhsIiwNCisJSVBUQUJMRVNfVkVS
U0lPTiwNCisJSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfaGxfaW5m
bykpLA0KKwlJUDZUX0FMSUdOKHNpemVvZihzdHJ1Y3QgaXA2dF9obF9pbmZv
KSksDQorCSZoZWxwLA0KKwkmaW5pdCwNCisJJnBhcnNlLA0KKwkmZmluYWxf
Y2hlY2ssDQorCSZwcmludCwNCisJJnNhdmUsDQorCW9wdHMNCit9Ow0KKw0K
Kw0KK3ZvaWQgX2luaXQodm9pZCkgDQorew0KKwlyZWdpc3Rlcl9tYXRjaDYo
JmhsKTsNCit9DQpkaWZmIC1OcnUgbmV0ZmlsdGVyLm9yaWcvdXNlcnNwYWNl
L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oIG5ldGZp
bHRlci91c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9p
cDZ0X0hMLmgNCi0tLSBuZXRmaWx0ZXIub3JpZy91c2Vyc3BhY2UvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0X0hMLmgJMTk3MC0wMS0wMSAw
MTowMDowMC4wMDAwMDAwMDAgKzAxMDANCisrKyBuZXRmaWx0ZXIvdXNlcnNw
YWNlL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjYvaXA2dF9ITC5oCTIw
MDItMTItMTYgMTc6MTI6MjkuMDAwMDAwMDAwICswMTAwDQpAQCAtMCwwICsx
LDIyIEBADQorLyogSG9wIExpbWl0IG1vZGlmaWNhdGlvbiBtb2R1bGUgZm9y
IGlwNnRhYmxlcw0KKyAqIE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRv
eGljZmlsbXMudHY+ICovDQorICogQmFzZWQgb24gSFcncyBUVEwgbW9kdWxl
ICovDQorDQorI2lmbmRlZiBfSVA2VF9ITF9IDQorI2RlZmluZSBfSVA2VF9I
TF9IDQorDQorZW51bSB7DQorCUlQNlRfSExfU0VUID0gMCwNCisJSVA2VF9I
TF9JTkMsDQorCUlQNlRfSExfREVDDQorfTsNCisNCisjZGVmaW5lIElQNlRf
SExfTUFYTU9ERQlJUDZUX0hMX0RFQw0KKw0KK3N0cnVjdCBpcDZ0X0hMX2lu
Zm8gew0KKwl1X2ludDhfdAltb2RlOw0KKwl1X2ludDhfdAlob3BfbGltaXQ7
DQorfTsNCisNCisNCisjZW5kaWYNCmRpZmYgLU5ydSBuZXRmaWx0ZXIub3Jp
Zy91c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9pcDZ0
X2hsLmggbmV0ZmlsdGVyL3VzZXJzcGFjZS9pbmNsdWRlL2xpbnV4L25ldGZp
bHRlcl9pcHY2L2lwNnRfaGwuaA0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJz
cGFjZS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2L2lwNnRfaGwuaAkx
OTcwLTAxLTAxIDAxOjAwOjAwLjAwMDAwMDAwMCArMDEwMA0KKysrIG5ldGZp
bHRlci91c2Vyc3BhY2UvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni9p
cDZ0X2hsLmgJMjAwMi0xMi0xNiAxNzoxMTo1Ni4wMDAwMDAwMDAgKzAxMDAN
CkBAIC0wLDAgKzEsMjIgQEANCisvKiBpcDZ0YWJsZXMgbW9kdWxlIGZvciBt
YXRjaGluZyB0aGUgSG9wIExpbWl0IHZhbHVlDQorICogTWFjaWVqIFNvbHR5
c2lhayA8c29sdEBkbnMudG94aWNmaWxtcy50dj4NCisgKiBCYXNlZCBvbiBI
VydzIHR0bCBtb2R1bGUgKi8NCisNCisjaWZuZGVmIF9JUDZUX0hMX0gNCisj
ZGVmaW5lIF9JUDZUX0hMX0gNCisNCitlbnVtIHsNCisJSVA2VF9ITF9FUSA9
IDAsCQkvKiBlcXVhbHMgKi8NCisJSVA2VF9ITF9ORSwJCS8qIG5vdCBlcXVh
bHMgKi8NCisJSVA2VF9ITF9MVCwJCS8qIGxlc3MgdGhhbiAqLw0KKwlJUDZU
X0hMX0dULAkJLyogZ3JlYXRlciB0aGFuICovDQorfTsNCisNCisNCitzdHJ1
Y3QgaXA2dF9obF9pbmZvIHsNCisJdV9pbnQ4X3QJbW9kZTsNCisJdV9pbnQ4
X3QJaG9wX2xpbWl0Ow0KK307DQorDQorDQorI2VuZGlmDQo=
---23717851-158185776-1041274371=:6450--
