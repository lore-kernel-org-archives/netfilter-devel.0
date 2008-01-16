From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [16/19] libxt_iprange r0
Date: Wed, 16 Jan 2008 14:53:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAPNxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:53:38 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move libipt_iprange to libxt_iprange.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_iprange.c                |  175 -----------------------------
 extensions/libipt_iprange.man              |    7 -
 extensions/libxt_iprange.c                 |  170 ++++++++++++++++++++++++++++
 extensions/libxt_iprange.man               |    7 +
 include/linux/netfilter/xt_iprange.h       |   17 ++
 include/linux/netfilter_ipv4/ipt_iprange.h |    8 -
 7 files changed, 198 insertions(+), 188 deletions(-)

Index: iptables-modules/extensions/libipt_iprange.c
===================================================================
--- iptables-modules.orig/extensions/libipt_iprange.c
+++ /dev/null
@@ -1,175 +0,0 @@
-/* Shared library add-on to iptables to add IP range matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_iprange.h>
-
-/* Function which prints out usage message. */
-static void iprange_help(void)
-{
-	printf(
-"iprange match v%s options:\n"
-"[!] --src-range ip-ip        Match source IP in the specified range\n"
-"[!] --dst-range ip-ip        Match destination IP in the specified range\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static const struct option iprange_opts[] = {
-	{ "src-range", 1, NULL, '1' },
-	{ "dst-range", 1, NULL, '2' },
-	{ }
-};
-
-static void
-parse_iprange(char *arg, struct ipt_iprange *range)
-{
-	char *dash;
-	const struct in_addr *ip;
-
-	dash = strchr(arg, '-');
-	if (dash)
-		*dash = '\0';
-		
-	ip = numeric_to_ipaddr(arg);
-	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n", 
-			   arg);
-	range->min_ip = ip->s_addr;
-
-	if (dash) {
-		ip = numeric_to_ipaddr(dash+1);
-		if (!ip)
-			exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
-				   dash+1);
-		range->max_ip = ip->s_addr;
-	} else
-		range->max_ip = range->min_ip;
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IPRANGE_SRC)
-			exit_error(PARAMETER_PROBLEM,
-				   "iprange match: Only use --src-range ONCE!");
-		*flags |= IPRANGE_SRC;
-
-		info->flags |= IPRANGE_SRC;
-		check_inverse(optarg, &invert, &optind, 0);
-		if (invert) {
-			info->flags |= IPRANGE_SRC_INV;
-		}
-		parse_iprange(optarg, &info->src);		
-
-		break;
-
-	case '2':
-		if (*flags & IPRANGE_DST)
-			exit_error(PARAMETER_PROBLEM,
-				   "iprange match: Only use --dst-range ONCE!");
-		*flags |= IPRANGE_DST;
-
-		info->flags |= IPRANGE_DST;
-		check_inverse(optarg, &invert, &optind, 0);
-		if (invert)
-			info->flags |= IPRANGE_DST_INV;
-
-		parse_iprange(optarg, &info->dst);		
-
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-/* Final check; must have specified --src-range or --dst-range. */
-static void iprange_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "iprange match: You must specify `--src-range' or `--dst-range'");
-}
-
-static void
-print_iprange(const struct ipt_iprange *range)
-{
-	const unsigned char *byte_min, *byte_max;
-
-	byte_min = (const unsigned char *) &(range->min_ip);
-	byte_max = (const unsigned char *) &(range->max_ip);
-	printf("%d.%d.%d.%d-%d.%d.%d.%d ", 
-		byte_min[0], byte_min[1], byte_min[2], byte_min[3],
-		byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
-}
-
-/* Prints out the info. */
-static void iprange_print(const void *ip, const struct xt_entry_match *match,
-                          int numeric)
-{
-	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
-
-	if (info->flags & IPRANGE_SRC) {
-		printf("source IP range ");
-		if (info->flags & IPRANGE_SRC_INV)
-			printf("! ");
-		print_iprange(&info->src);
-	}
-	if (info->flags & IPRANGE_DST) {
-		printf("destination IP range ");
-		if (info->flags & IPRANGE_DST_INV)
-			printf("! ");
-		print_iprange(&info->dst);
-	}
-}
-
-/* Saves the union ipt_info in parsable form to stdout. */
-static void iprange_save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
-
-	if (info->flags & IPRANGE_SRC) {
-		if (info->flags & IPRANGE_SRC_INV)
-			printf("! ");
-		printf("--src-range ");
-		print_iprange(&info->src);
-		if (info->flags & IPRANGE_DST)
-			fputc(' ', stdout);
-	}
-	if (info->flags & IPRANGE_DST) {
-		if (info->flags & IPRANGE_DST_INV)
-			printf("! ");
-		printf("--dst-range ");
-		print_iprange(&info->dst);
-	}
-}
-
-static struct iptables_match iprange_match = {
-	.name		= "iprange",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
-	.help		= iprange_help,
-	.parse		= iprange_parse,
-	.final_check	= iprange_check,
-	.print		= iprange_print,
-	.save		= iprange_save,
-	.extra_opts	= iprange_opts,
-};
-
-void _init(void)
-{
-	register_match(&iprange_match);
-}
Index: iptables-modules/extensions/libipt_iprange.man
===================================================================
--- iptables-modules.orig/extensions/libipt_iprange.man
+++ /dev/null
@@ -1,7 +0,0 @@
-This matches on a given arbitrary range of IPv4 addresses
-.TP
-.BI "[!]" "--src-range " "ip-ip"
-Match source IP in the specified range.
-.TP
-.BI "[!]" "--dst-range " "ip-ip"
-Match destination IP in the specified range.
Index: iptables-modules/extensions/libxt_iprange.c
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_iprange.c
@@ -0,0 +1,170 @@
+/* Shared library add-on to iptables to add IP range matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_iprange.h>
+
+static void iprange_mt_help(void)
+{
+	printf(
+"iprange match options:\n"
+"[!] --src-range ip-ip        Match source IP in the specified range\n"
+"[!] --dst-range ip-ip        Match destination IP in the specified range\n"
+"\n");
+}
+
+static const struct option iprange_mt_opts[] = {
+	{.name = "src-range", .has_arg = true, .val = '1'},
+	{.name = "dst-range", .has_arg = true, .val = '2'},
+	{},
+};
+
+static void
+parse_iprange(char *arg, struct ipt_iprange *range)
+{
+	char *dash;
+	const struct in_addr *ip;
+
+	dash = strchr(arg, '-');
+	if (dash != NULL)
+		*dash = '\0';
+
+	ip = numeric_to_ipaddr(arg);
+	if (ip != NULL)
+		exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
+			   arg);
+	range->min_ip = ip->s_addr;
+
+	if (dash != NULL) {
+		ip = numeric_to_ipaddr(dash+1);
+		if (ip != NULL)
+			exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
+				   dash+1);
+		range->max_ip = ip->s_addr;
+	} else {
+		range->max_ip = range->min_ip;
+	}
+}
+
+static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_match **match)
+{
+	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & IPRANGE_SRC)
+			exit_error(PARAMETER_PROBLEM,
+				   "iprange match: Only use --src-range ONCE!");
+		*flags |= IPRANGE_SRC;
+
+		info->flags |= IPRANGE_SRC;
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= IPRANGE_SRC_INV;
+		parse_iprange(optarg, &info->src);
+
+		break;
+
+	case '2':
+		if (*flags & IPRANGE_DST)
+			exit_error(PARAMETER_PROBLEM,
+				   "iprange match: Only use --dst-range ONCE!");
+		*flags |= IPRANGE_DST;
+
+		info->flags |= IPRANGE_DST;
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			info->flags |= IPRANGE_DST_INV;
+
+		parse_iprange(optarg, &info->dst);
+
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void iprange_mt_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM,
+			   "iprange match: You must specify `--src-range' or `--dst-range'");
+}
+
+static void
+print_iprange(const struct ipt_iprange *range)
+{
+	const unsigned char *byte_min, *byte_max;
+
+	byte_min = (const unsigned char *)&range->min_ip;
+	byte_max = (const unsigned char *)&range->max_ip;
+	printf("%u.%u.%u.%u-%u.%u.%u.%u ",
+		byte_min[0], byte_min[1], byte_min[2], byte_min[3],
+		byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
+}
+
+static void iprange_print(const void *ip, const struct xt_entry_match *match,
+                          int numeric)
+{
+	const struct ipt_iprange_info *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		printf("source IP range ");
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		print_iprange(&info->src);
+	}
+	if (info->flags & IPRANGE_DST) {
+		printf("destination IP range ");
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		print_iprange(&info->dst);
+	}
+}
+
+static void iprange_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_iprange_info *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		printf("--src-range ");
+		print_iprange(&info->src);
+		if (info->flags & IPRANGE_DST)
+			fputc(' ', stdout);
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		printf("--dst-range ");
+		print_iprange(&info->dst);
+	}
+}
+
+static struct xtables_match iprange_match = {
+	.version       = IPTABLES_VERSION,
+	.name          = "iprange",
+	.revision      = 0,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct ipt_iprange_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct ipt_iprange_info)),
+	.help          = iprange_mt_help,
+	.parse         = iprange_parse,
+	.final_check   = iprange_mt_check,
+	.print         = iprange_print,
+	.save          = iprange_save,
+	.extra_opts    = iprange_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&iprange_match);
+}
Index: iptables-modules/extensions/libxt_iprange.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_iprange.man
@@ -0,0 +1,7 @@
+This matches on a given arbitrary range of IP addresses.
+.TP
+[\fB!\fR] \fB--src-range\fR \fIfrom\fR-\fIto\fR
+Match source IP in the specified range.
+.TP
+[\fB!\fR] \fB--dst-range\fR \fIfrom\fR-\fIto\fR
+Match destination IP in the specified range.
Index: iptables-modules/include/linux/netfilter/xt_iprange.h
===================================================================
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_iprange.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_NETFILTER_XT_IPRANGE_H
+#define _LINUX_NETFILTER_XT_IPRANGE_H 1
+
+enum {
+	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
+	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
+	IPRANGE_SRC_INV = 1 << 4,	/* negate the condition */
+	IPRANGE_DST_INV = 1 << 5,	/* -"- */
+};
+
+struct xt_iprange_mtinfo {
+	union nf_inet_addr src_min, src_max;
+	union nf_inet_addr dst_min, dst_max;
+	u_int8_t flags;
+};
+
+#endif /* _LINUX_NETFILTER_XT_IPRANGE_H */
Index: iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_iprange.h
+++ iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
@@ -1,14 +1,12 @@
 #ifndef _IPT_IPRANGE_H
 #define _IPT_IPRANGE_H
 
-#define IPRANGE_SRC		0x01	/* Match source IP address */
-#define IPRANGE_DST		0x02	/* Match destination IP address */
-#define IPRANGE_SRC_INV		0x10	/* Negate the condition */
-#define IPRANGE_DST_INV		0x20	/* Negate the condition */
+#include <linux/types.h>
+#include <linux/netfilter/xt_iprange.h>
 
 struct ipt_iprange {
 	/* Inclusive: network order. */
-	u_int32_t min_ip, max_ip;
+	__be32 min_ip, max_ip;
 };
 
 struct ipt_iprange_info
