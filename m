From: Sven Anders <anders@anduras.de>
Subject: [PATCH] new match (equal)
Date: Thu, 06 Jul 2006 11:30:24 +0200
Message-ID: <44ACD830.30108@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000909000100040003010604"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000909000100040003010604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Hello!

This is a new match to check for equal IPs and/or devices.
Maybe it's of any use to somebody else...

Please add it patch-o-matic-ng.

Comments welcome!

Regards
 Sven Anders

-- 
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraﬂe 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

--------------000909000100040003010604
Content-Type: text/x-diff;
 name="pom-equal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pom-equal.patch"

diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/help patch-o-matic-ng-20060704/patchlets/equal/help
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/help	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/help	2006-06-29 19:41:06.000000000 +0200
@@ -0,0 +1,4 @@
+Kernel module to match 
+ - equal src/dest addresses
+ - equal in/out devices 
+ - equal physical in/out devices
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/info patch-o-matic-ng-20060704/patchlets/equal/info
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/info	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/info	2006-06-29 19:53:52.000000000 +0200
@@ -0,0 +1,7 @@
+Title: iptables `equal' match
+Author: Sven Anders <anders@anduras.de>
+Status: Stable
+Requires: linux-2.6 >= 2.6.16
+Recompile: netfilter, iptables
+Repository: extra
+
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/.equal-test patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/.equal-test
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/.equal-test	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/.equal-test	2006-06-29 20:17:47.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_equal.h ] && echo equal
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/.equal-test6 patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/.equal-test6
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/.equal-test6	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/.equal-test6	2006-06-29 20:17:36.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_equal.h ] && echo equal
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libip6t_equal.c patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libip6t_equal.c
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libip6t_equal.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libip6t_equal.c	2006-06-30 23:15:50.000000000 +0200
@@ -0,0 +1,153 @@
+/* Shared library add-on to iptables to add ip/device equality matching support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv6/ip6t_equal.h>
+
+
+static void
+help(void)
+{
+	printf(
+"equal v%s options:\n"
+" [!] --ips				match, if IPs are (un)equal\n"
+" [!] --devices				match, if devices are (un)equal\n"
+" [!] --phys-devices			match, if devices are (un)equal\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "ips", 0, 0, '1' },
+	{ "devices", 0, 0, '2' },
+	{ "phys-devices", 0, 0, '3' },
+	{0}
+};
+
+static void
+init(struct ip6t_entry_match *match, unsigned int *nfcache)
+{
+	struct ip6t_equal_info *info =
+		(struct ip6t_equal_info*)match->data;
+
+	info->flags = IP6T_EQUAL_NONE;
+	info->inv = IP6T_EQUAL_NONE;
+
+        *nfcache |= NFC_UNKNOWN;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ip6t_entry *entry,
+      unsigned int *nfcache,
+      struct ip6t_entry_match **match)
+{
+	struct ip6t_equal_info *info =
+		(struct ip6t_equal_info*)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IP6T_EQUAL_IPS)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IP6T_EQUAL_IPS;
+		if (invert)
+			info->inv |= IP6T_EQUAL_IPS;
+		*flags |= IP6T_EQUAL_IPS;
+		break;
+
+	case '2':
+		if (*flags & IP6T_EQUAL_DEVICES)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IP6T_EQUAL_DEVICES;
+		if (invert)
+			info->inv |= IP6T_EQUAL_DEVICES;
+		*flags |= IP6T_EQUAL_DEVICES;
+		break;
+
+	case '3':
+		if (*flags & IP6T_EQUAL_PHYS_DEVICES)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IP6T_EQUAL_PHYS_DEVICES;
+		if (invert)
+			info->inv |= IP6T_EQUAL_PHYS_DEVICES;
+		*flags |= IP6T_EQUAL_PHYS_DEVICES;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+
+multiple_use:
+	exit_error(PARAMETER_PROBLEM,
+	   "multiple use of the same equal option is not allowed");
+
+}
+
+static void final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "equal match: no equal option specified");
+}
+
+static void
+print(const struct ip6t_ip6 *ip,
+      const struct ip6t_entry_match *match,
+      int numeric)
+{
+	struct ip6t_equal_info *info =
+		(struct ip6t_equal_info*)match->data;
+
+	if (info->flags & IP6T_EQUAL_IPS)
+		printf("%sequal ips ",
+		       info->inv & IP6T_EQUAL_IPS ? "un":"");
+	if (info->flags & IP6T_EQUAL_DEVICES)
+		printf("%sequal devices ",
+		       info->inv & IP6T_EQUAL_DEVICES ? "un":"");
+	if (info->flags & IP6T_EQUAL_PHYS_DEVICES)
+		printf("%sequal phys-devices ",
+		       info->inv & IP6T_EQUAL_PHYS_DEVICES ? "un":"");
+}
+
+static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+{
+	struct ip6t_equal_info *info =
+		(struct ip6t_equal_info*)match->data;
+
+	if (info->flags & IP6T_EQUAL_IPS)
+		printf("%s --ips ",
+		       info->inv & IP6T_EQUAL_IPS ? " !":"");
+	if (info->flags & IP6T_EQUAL_DEVICES)
+		printf("%s --devices ",
+		       info->inv & IP6T_EQUAL_DEVICES ? " !":"");
+	if (info->flags & IP6T_EQUAL_PHYS_DEVICES)
+		printf("%s --phys-devices ",
+		       info->inv & IP6T_EQUAL_PHYS_DEVICES ? " !":"");
+	printf(" ");
+}
+
+static struct ip6tables_match equal = {
+	.name 		= "equal",
+	.version	= IPTABLES_VERSION,
+	.size		= IP6T_ALIGN(sizeof(struct ip6t_equal_info)),
+	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_equal_info)),
+	.help		= &help,
+	.init           = &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+void _init(void)
+{
+	register_match(&equal);
+}
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libip6t_equal.man patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libip6t_equal.man
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libip6t_equal.man	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libip6t_equal.man	2006-06-30 23:15:50.000000000 +0200
@@ -0,0 +1,12 @@
+This module matches on equal or unequal source and destination IP addresses,
+on equal or unequal input and output devices (normal and physical devices).
+.TP
+.BI "--ips"
+Test if source and destination IP addresses are equal.
+.TP
+.BI "--devices"
+Test if input and output devices are equal.
+.TP
+.BI "--phys-devices"
+Test if the physical input and output devices are equal.
+This is only useful if your are using bridged devices.
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libipt_equal.c patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libipt_equal.c
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libipt_equal.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libipt_equal.c	2006-06-30 23:15:50.000000000 +0200
@@ -0,0 +1,154 @@
+/* Shared library add-on to iptables to add ip/device equality matching support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_equal.h>
+
+
+static void
+help(void)
+{
+	printf(
+"equal v%s options:\n"
+" [!] --ips				match, if IPs are (un)equal\n"
+" [!] --devices				match, if devices are (un)equal\n"
+" [!] --phys-devices			match, if devices are (un)equal\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "ips", 0, 0, '1' },
+	{ "devices", 0, 0, '2' },
+	{ "phys-devices", 0, 0, '3' },
+	{0}
+};
+
+static void
+init(struct ipt_entry_match *match, unsigned int *nfcache)
+{
+	struct ipt_equal_info *info =
+		(struct ipt_equal_info*)match->data;
+
+	info->flags = IPT_EQUAL_NONE;
+	info->inv = IPT_EQUAL_NONE;
+
+        *nfcache |= NFC_UNKNOWN;
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_equal_info *info =
+		(struct ipt_equal_info*)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPT_EQUAL_IPS)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IPT_EQUAL_IPS;
+		if (invert)
+			info->inv |= IPT_EQUAL_IPS;
+		*flags |= IPT_EQUAL_IPS;
+		break;
+
+	case '2':
+		if (*flags & IPT_EQUAL_DEVICES)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IPT_EQUAL_DEVICES;
+		if (invert)
+			info->inv |= IPT_EQUAL_DEVICES;
+		*flags |= IPT_EQUAL_DEVICES;
+		break;
+
+	case '3':
+		if (*flags & IPT_EQUAL_PHYS_DEVICES)
+			goto multiple_use;
+		check_inverse(optarg, &invert, &optind, 0);
+		info->flags |= IPT_EQUAL_PHYS_DEVICES;
+		if (invert)
+			info->inv |= IPT_EQUAL_PHYS_DEVICES;
+		*flags |= IPT_EQUAL_PHYS_DEVICES;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+
+multiple_use:
+	exit_error(PARAMETER_PROBLEM,
+	   "multiple use of the same equal option is not allowed");
+
+}
+
+static void final_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "equal match: no equal option specified");
+}
+
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_equal_info *info =
+		(struct ipt_equal_info*)match->data;
+
+	if (info->flags & IPT_EQUAL_IPS)
+		printf("%sequal ips ",
+		       info->inv & IPT_EQUAL_IPS ? "un":"");
+	if (info->flags & IPT_EQUAL_DEVICES)
+		printf("%sequal devices ",
+		       info->inv & IPT_EQUAL_DEVICES ? "un":"");
+	if (info->flags & IPT_EQUAL_PHYS_DEVICES)
+		printf("%sequal phys-devices ",
+		       info->inv & IPT_EQUAL_PHYS_DEVICES ? "un":"");
+}
+
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_equal_info *info =
+		(struct ipt_equal_info*)match->data;
+
+	if (info->flags & IPT_EQUAL_IPS)
+		printf("%s --ips ",
+		       info->inv & IPT_EQUAL_IPS ? " !":"");
+	if (info->flags & IPT_EQUAL_DEVICES)
+		printf("%s --devices ",
+		       info->inv & IPT_EQUAL_DEVICES ? " !":"");
+	if (info->flags & IPT_EQUAL_PHYS_DEVICES)
+		printf("%s --phys-devices ",
+		       info->inv & IPT_EQUAL_PHYS_DEVICES ? " !":"");
+	printf(" ");
+}
+
+static struct iptables_match equal = { 
+	.next		= NULL,
+	.name		= "equal",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_equal_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_equal_info)),
+	.help		= &help,
+	.init           = &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&equal);
+}
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libipt_equal.man patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libipt_equal.man
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/iptables/extensions/libipt_equal.man	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/iptables/extensions/libipt_equal.man	2006-06-30 23:15:50.000000000 +0200
@@ -0,0 +1,12 @@
+This module matches on equal or unequal source and destination IP addresses,
+on equal or unequal input and output devices (normal and physical devices).
+.TP
+.BI "--ips"
+Test if source and destination IP addresses are equal.
+.TP
+.BI "--devices"
+Test if input and output devices are equal.
+.TP
+.BI "--phys-devices"
+Test if the physical input and output devices are equal.
+This is only useful if your are using bridged devices.
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/Documentation/Configure.help.ladd patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/Documentation/Configure.help.ladd
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/Documentation/Configure.help.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/Documentation/Configure.help.ladd	2006-06-29 19:43:53.000000000 +0200
@@ -0,0 +1,8 @@
+NETFILTER_XT_MATCH_TCPMSS
+"equal" match support
+NETFILTER_XT_MATCH_EQUAL
+  This option adds a `equal' match, which allows you to match for
+  equal source and destination addresses, equal in and out devices
+  and/or equal physical in and out devices.
+
+  To compile it as a module, choose M here.  If unsure, say N.
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter/xt_equal.h patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter/xt_equal.h
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter/xt_equal.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter/xt_equal.h	2006-06-29 19:45:29.000000000 +0200
@@ -0,0 +1,17 @@
+#ifndef _XT_EQUAL_H
+#define _XT_EQUAL_H
+
+#define XT_EQUAL_NONE         0x00
+
+#define XT_EQUAL_IPS          0x01    /* test for (un)equal source/dest IPs */
+#define XT_EQUAL_DEVICES      0x02    /* test for (un)equal in/out devices */
+#define XT_EQUAL_PHYS_DEVICES 0x04    /* test for (un)equal physical in/out devices */
+
+#define XT_EQUAL_ALL          0xFF
+
+struct xt_equal_info {
+        u_int8_t inv;
+        u_int8_t flags;
+};
+
+#endif /*_XT_EQUAL_H*/
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter_ipv4/ipt_equal.h patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter_ipv4/ipt_equal.h
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter_ipv4/ipt_equal.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter_ipv4/ipt_equal.h	2006-06-29 19:44:44.000000000 +0200
@@ -0,0 +1,16 @@
+#ifndef _IPT_EQUAL_H
+#define _IPT_EQUAL_H
+
+/* Backwards compatibility for old userspace */
+
+#include <linux/netfilter/xt_equal.h>
+
+#define IPT_EQUAL_NONE         XT_EQUAL_NONE
+#define IPT_EQUAL_IPS          XT_EQUAL_IPS
+#define IPT_EQUAL_DEVICES      XT_EQUAL_DEVICES
+#define IPT_EQUAL_PHYS_DEVICES XT_EQUAL_PHYS_DEVICES
+#define IPT_EQUAL_ALL          XT_EQUAL_ALL
+
+#define ipt_equal_info xt_equal_info
+
+#endif /*_IPT_EQUAL_H*/
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter_ipv6/ip6t_equal.h patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter_ipv6/ip6t_equal.h
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/include/linux/netfilter_ipv6/ip6t_equal.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/include/linux/netfilter_ipv6/ip6t_equal.h	2006-06-29 19:45:05.000000000 +0200
@@ -0,0 +1,16 @@
+#ifndef _IP6T_EQUAL_H
+#define _IP6T_EQUAL_H
+
+/* Backwards compatibility for old userspace */
+
+#include <linux/netfilter/xt_equal.h>
+
+#define IP6T_EQUAL_NONE         XT_EQUAL_NONE
+#define IP6T_EQUAL_IPS          XT_EQUAL_IPS
+#define IP6T_EQUAL_DEVICES      XT_EQUAL_DEVICES
+#define IP6T_EQUAL_PHYS_DEVICES XT_EQUAL_PHYS_DEVICES
+#define IP6T_EQUAL_ALL          XT_EQUAL_ALL
+
+#define ip6t_equal_info xt_equal_info
+
+#endif /*_IP6T_EQUAL_H*/
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/Kconfig.ladd patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/Kconfig.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/Kconfig.ladd	2006-06-29 19:49:42.000000000 +0200
@@ -0,0 +1,9 @@
+config NETFILTER_XT_MATCH_EQUAL
+	tristate '"equal" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `equal' match, which allows you to match for
+	  equal source and destination addresses, equal in and out devices
+	  and/or equal physical in and out devices.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/Makefile.ladd patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/Makefile.ladd
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/Makefile.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/Makefile.ladd	2006-06-29 19:50:17.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_EQUAL) += xt_equal.o
diff -u -r -N patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/xt_equal.c patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/xt_equal.c
--- patch-o-matic-ng-20060704.vanilla/patchlets/equal/linux-2.6/net/netfilter/xt_equal.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20060704/patchlets/equal/linux-2.6/net/netfilter/xt_equal.c	2006-07-06 11:08:13.000000000 +0200
@@ -0,0 +1,154 @@
+/*
+ * Kernel module to match equal src/dest addresses and/or equal in/out devices
+ *  and/or equal physical in/out devices.
+ *
+ * (C) 2004-2006 Sven Anders <anders@anduras.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+#include <linux/netfilter/xt_equal.h>
+#include <linux/netfilter/x_tables.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sven Anders <anders@anduas.de>");
+MODULE_DESCRIPTION("iptables equal address / (phys.) device match module");
+MODULE_ALIAS("ipt_equal");
+MODULE_ALIAS("ip6t_equal");
+
+static unsigned int 
+device_name_cmp(const struct net_device *dev1, const struct net_device *dev2)
+{
+	static const char nulldevname[IFNAMSIZ];
+	const char *indev, *outdev;
+	unsigned int i, ret = 0;
+
+	indev = dev1 ? dev1->name : nulldevname;
+	outdev = dev2 ? dev2->name : nulldevname;
+
+	for (i = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
+		ret |= (((const unsigned long *)indev)[i]
+			^ ((const unsigned long *)outdev)[i]);
+	}
+
+	DEBUGP("in DEV %s AND out DEV %s are %s EQUAL\n",
+	       indev, outdev, (ret ? "" : "NOT"));
+
+	return ret;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_equal_info *info = matchinfo;
+	const struct nf_bridge_info *nf_bridge = skb->nf_bridge;
+	const struct iphdr *iph = skb->nh.iph;
+	const struct ipv6hdr *ipv6h = skb->nh.ipv6h;
+	int eq_ips = 1, eq_devs = 1, eq_phys_devs = 1;
+
+	/* Compare source and destination IPs */
+	if (info->flags & XT_EQUAL_IPS) {
+
+		if (match->family == AF_INET)
+		  eq_ips = (iph->saddr == iph->daddr);
+		else if (match->family == AF_INET6)
+		  eq_ips = !ipv6_addr_cmp(&ipv6h->saddr, &ipv6h->daddr);
+
+		DEBUGP("src IP %u.%u.%u.%u AND "
+		       "dest IP %u.%u.%u.%u are %s EQUAL\n",
+		       NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr),
+		       ((iph->saddr == iph->daddr) ? "" : "NOT"));
+
+		if (info->inv & XT_EQUAL_IPS)
+		  eq_ips = !eq_ips;
+	}
+
+	/* Compare in and out devices */
+	if (info->flags & XT_EQUAL_DEVICES) {
+
+		if (device_name_cmp(in, out) == 0)
+		  eq_devs = !(info->inv & XT_EQUAL_DEVICES); /* 1 */
+		else
+		  eq_devs = (info->inv & XT_EQUAL_DEVICES); /* 0 */
+	}
+
+	/* Compare physical in and out devices 
+	 *
+	 * (But only if this is a bridged IP packet or and we
+	 *  have the info available yet. (LOCAL_OUT/mangle and 
+	 * LOCAL_OUT/nat don't know if the destination device will
+	 * be a bridge.
+	 */
+
+	if ((info->flags & XT_EQUAL_PHYS_DEVICES) && nf_bridge) {
+	
+		if (device_name_cmp(nf_bridge->physindev,
+				    nf_bridge->physoutdev) == 0)
+		  eq_phys_devs = !(info->inv & XT_EQUAL_PHYS_DEVICES); /* 1 */
+		else
+		  eq_phys_devs = (info->inv & XT_EQUAL_PHYS_DEVICES); /* 0 */
+	}
+
+        return (eq_ips && eq_devs && eq_phys_devs);
+}
+
+static struct xt_match equal_match = {
+	.name		= "equal",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_equal_info),
+	.family		= AF_INET,
+	.me		= THIS_MODULE,
+};
+
+static struct xt_match equal6_match = {
+	.name		= "equal",
+	.match		= match,
+	.matchsize	= sizeof(struct xt_equal_info),
+	.family		= AF_INET6,
+	.me		= THIS_MODULE,
+};
+
+static int __init xt_equal_init(void)
+{
+	int ret;
+
+	ret = xt_register_match(&equal_match);
+	if (ret < 0)
+		return ret;
+
+	ret = xt_register_match(&equal6_match);
+	if (ret < 0)
+		xt_unregister_match(&equal_match);
+
+	return ret;
+}
+
+static void __exit xt_equal_fini(void)
+{
+	xt_unregister_match(&equal_match);
+	xt_unregister_match(&equal6_match);
+}
+
+module_init(xt_equal_init);
+module_exit(xt_equal_fini);
y
--------------000909000100040003010604--
