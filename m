From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 38/43] Add IPv6 support to dscp match.
Date: Sun, 15 Jul 2007 03:13:01 +0900 (JST)
Message-ID: <200707141813.l6EID1kT000782@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


---
 extensions/Makefile                     |    4 +-
 extensions/libipt_dscp.c                |  172 ----------------------------
 extensions/libxt_dscp.c                 |  189 +++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_dscp.h       |   23 ++++
 include/linux/netfilter_ipv4/ipt_dscp.h |   23 ----
 5 files changed, 214 insertions(+), 197 deletions(-)
 delete mode 100644 extensions/libipt_dscp.c
 create mode 100644 extensions/libxt_dscp.c
 create mode 100644 include/linux/netfilter/xt_dscp.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_dscp.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 6b9a3e9..1a757e7 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PFX_EXT_SLIB:=dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libipt_dscp.c b/extensions/libipt_dscp.c
deleted file mode 100644
index 6a8cac8..0000000
--- a/extensions/libipt_dscp.c
+++ /dev/null
@@ -1,172 +0,0 @@
-/* Shared library add-on to iptables for DSCP
- *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *
- * This program is distributed under the terms of GNU GPL v2, 1991
- *
- * libipt_dscp.c borrowed heavily from libipt_tos.c
- *
- * --class support added by Iain Barnes
- * 
- * For a list of DSCP codepoints see 
- * http://www.iana.org/assignments/dscp-registry
- *
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_dscp.h>
-
-/* This is evil, but it's my code - HW*/
-#include "libipt_dscp_helper.c"
-
-static void help(void) 
-{
-	printf(
-"DSCP match v%s options\n"
-"[!] --dscp value		Match DSCP codepoint with numerical value\n"
-"  		                This value can be in decimal (ex: 32)\n"
-"               		or in hex (ex: 0x20)\n"
-"[!] --dscp-class name		Match the DiffServ class. This value may\n"
-"				be any of the BE,EF, AFxx or CSx classes\n"
-"\n"
-"				These two options are mutually exclusive !\n"
-				, IPTABLES_VERSION
-);
-}
-
-static struct option opts[] = {
-	{ "dscp", 1, 0, 'F' },
-	{ "dscp-class", 1, 0, 'G' },
-	{ 0 }
-};
-
-static void
-parse_dscp(const char *s, struct ipt_dscp_info *dinfo)
-{
-	unsigned int dscp;
-       
-	if (string_to_number(s, 0, 255, &dscp) == -1)
-		exit_error(PARAMETER_PROBLEM,
-			   "Invalid dscp `%s'\n", s);
-
-	if (dscp > IPT_DSCP_MAX)
-		exit_error(PARAMETER_PROBLEM,
-			   "DSCP `%d` out of range\n", dscp);
-
-    	dinfo->dscp = (u_int8_t )dscp;
-    	return;
-}
-
-
-static void
-parse_class(const char *s, struct ipt_dscp_info *dinfo)
-{
-	unsigned int dscp = class_to_dscp(s);
-
-	/* Assign the value */
-	dinfo->dscp = (u_int8_t)dscp;
-}
-
-
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_dscp_info *dinfo
-		= (struct ipt_dscp_info *)(*match)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "DSCP match: Only use --dscp ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_dscp(argv[optind-1], dinfo);
-		if (invert)
-			dinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	case 'G':
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-					"DSCP match: Only use --dscp-class ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_class(argv[optind - 1], dinfo);
-		if (invert)
-			dinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-		           "DSCP match: Parameter --dscp is required");
-}
-
-static void
-print_dscp(u_int8_t dscp, int invert, int numeric)
-{
-	if (invert)
-		fputc('!', stdout);
-
- 	printf("0x%02x ", dscp);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	const struct ipt_dscp_info *dinfo =
-		(const struct ipt_dscp_info *)match->data;
-	printf("DSCP match ");
-	print_dscp(dinfo->dscp, dinfo->invert, numeric);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_dscp_info *dinfo =
-		(const struct ipt_dscp_info *)match->data;
-
-	printf("--dscp ");
-	print_dscp(dinfo->dscp, dinfo->invert, 1);
-}
-
-static struct iptables_match dscp = { 
-	.next 		= NULL,
-	.name 		= "dscp",
-	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct ipt_dscp_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_dscp_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void _init(void)
-{
-	register_match(&dscp);
-}
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
new file mode 100644
index 0000000..8ca7444
--- /dev/null
+++ b/extensions/libxt_dscp.c
@@ -0,0 +1,189 @@
+/* Shared library add-on to iptables for DSCP
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This program is distributed under the terms of GNU GPL v2, 1991
+ *
+ * libipt_dscp.c borrowed heavily from libipt_tos.c
+ *
+ * --class support added by Iain Barnes
+ * 
+ * For a list of DSCP codepoints see 
+ * http://www.iana.org/assignments/dscp-registry
+ *
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_dscp.h>
+
+/* This is evil, but it's my code - HW*/
+#include "libipt_dscp_helper.c"
+
+static void help(void) 
+{
+	printf(
+"DSCP match v%s options\n"
+"[!] --dscp value		Match DSCP codepoint with numerical value\n"
+"  		                This value can be in decimal (ex: 32)\n"
+"               		or in hex (ex: 0x20)\n"
+"[!] --dscp-class name		Match the DiffServ class. This value may\n"
+"				be any of the BE,EF, AFxx or CSx classes\n"
+"\n"
+"				These two options are mutually exclusive !\n"
+				, IPTABLES_VERSION
+);
+}
+
+static struct option opts[] = {
+	{ "dscp", 1, 0, 'F' },
+	{ "dscp-class", 1, 0, 'G' },
+	{ 0 }
+};
+
+static void
+parse_dscp(const char *s, struct xt_dscp_info *dinfo)
+{
+	unsigned int dscp;
+       
+	if (string_to_number(s, 0, 255, &dscp) == -1)
+		exit_error(PARAMETER_PROBLEM,
+			   "Invalid dscp `%s'\n", s);
+
+	if (dscp > XT_DSCP_MAX)
+		exit_error(PARAMETER_PROBLEM,
+			   "DSCP `%d` out of range\n", dscp);
+
+    	dinfo->dscp = (u_int8_t )dscp;
+    	return;
+}
+
+
+static void
+parse_class(const char *s, struct xt_dscp_info *dinfo)
+{
+	unsigned int dscp = class_to_dscp(s);
+
+	/* Assign the value */
+	dinfo->dscp = (u_int8_t)dscp;
+}
+
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_dscp_info *dinfo
+		= (struct xt_dscp_info *)(*match)->data;
+
+	switch (c) {
+	case 'F':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+			           "DSCP match: Only use --dscp ONCE!");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_dscp(argv[optind-1], dinfo);
+		if (invert)
+			dinfo->invert = 1;
+		*flags = 1;
+		break;
+
+	case 'G':
+		if (*flags)
+			exit_error(PARAMETER_PROBLEM,
+					"DSCP match: Only use --dscp-class ONCE!");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_class(argv[optind - 1], dinfo);
+		if (invert)
+			dinfo->invert = 1;
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
+		           "DSCP match: Parameter --dscp is required");
+}
+
+static void
+print_dscp(u_int8_t dscp, int invert, int numeric)
+{
+	if (invert)
+		fputc('!', stdout);
+
+ 	printf("0x%02x ", dscp);
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	const struct xt_dscp_info *dinfo =
+		(const struct xt_dscp_info *)match->data;
+	printf("DSCP match ");
+	print_dscp(dinfo->dscp, dinfo->invert, numeric);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_dscp_info *dinfo =
+		(const struct xt_dscp_info *)match->data;
+
+	printf("--dscp ");
+	print_dscp(dinfo->dscp, dinfo->invert, 1);
+}
+
+static struct xtables_match dscp = { 
+	.next 		= NULL,
+	.family		= AF_INET,
+	.name 		= "dscp",
+	.version 	= IPTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match dscp6 = { 
+	.next 		= NULL,
+	.family		= AF_INET6,
+	.name 		= "dscp",
+	.version 	= IPTABLES_VERSION,
+	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	xtables_register_match(&dscp);
+	xtables_register_match(&dscp6);
+}
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
new file mode 100644
index 0000000..1da61e6
--- /dev/null
+++ b/include/linux/netfilter/xt_dscp.h
@@ -0,0 +1,23 @@
+/* x_tables module for matching the IPv4/IPv6 DSCP field
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * This software is distributed under GNU GPL v2, 1991
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
+ *
+ * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
+*/
+#ifndef _XT_DSCP_H
+#define _XT_DSCP_H
+
+#define XT_DSCP_MASK	0xfc	/* 11111100 */
+#define XT_DSCP_SHIFT	2
+#define XT_DSCP_MAX	0x3f	/* 00111111 */
+
+/* match info */
+struct xt_dscp_info {
+	u_int8_t dscp;
+	u_int8_t invert;
+};
+
+#endif /* _XT_DSCP_H */
diff --git a/include/linux/netfilter_ipv4/ipt_dscp.h b/include/linux/netfilter_ipv4/ipt_dscp.h
deleted file mode 100644
index b6c59bd..0000000
--- a/include/linux/netfilter_ipv4/ipt_dscp.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* iptables module for matching the IPv4 DSCP field
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- * This software is distributed under GNU GPL v2, 1991
- * 
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * Id: ipt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
-*/
-#ifndef _IPT_DSCP_H
-#define _IPT_DSCP_H
-
-#define IPT_DSCP_MASK	0xfc	/* 11111100 */
-#define IPT_DSCP_SHIFT	2
-#define IPT_DSCP_MAX	0x3f	/* 00111111 */
-
-/* match info */
-struct ipt_dscp_info {
-	u_int8_t dscp;
-	u_int8_t invert;
-};
-
-#endif /* _IPT_DSCP_H */
-- 
1.5.2.2
