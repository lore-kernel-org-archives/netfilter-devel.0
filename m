From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 25/43] Unifies mark match of ip[6]tables
Date: Sun, 15 Jul 2007 03:10:50 +0900 (JST)
Message-ID: <200707141810.l6EIApxq008410@toshiba.co.jp>
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
 extensions/Makefile                      |    6 +-
 extensions/libip6t_mark.c                |  123 --------------------------
 extensions/libipt_mark.c                 |  125 --------------------------
 extensions/libxt_mark.c                  |  141 ++++++++++++++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_mark.h |    9 --
 5 files changed, 144 insertions(+), 260 deletions(-)
 delete mode 100644 extensions/libip6t_mark.c
 delete mode 100644 extensions/libipt_mark.c
 create mode 100644 extensions/libxt_mark.c
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_mark.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 0dd6bc6..62054f7 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=multiport NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mark multiport NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_mark.c b/extensions/libip6t_mark.c
deleted file mode 100644
index 9b801a4..0000000
--- a/extensions/libip6t_mark.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/* Shared library add-on to ip6tables to add NFMARK matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv6/ip6t_mark.h"
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MARK match v%s options:\n"
-"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "mark", 1, 0, '1' },
-	{0}
-};
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_mark_info *markinfo = (struct ip6t_mark_info *)(*match)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		markinfo->mark = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			markinfo->mask = strtoul(end+1, &end, 0);
-		} else
-			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (invert)
-			markinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_mark(unsigned long mark, unsigned long mask, int numeric)
-{
-	if(mask != 0xffffffff)
-		printf("0x%lx/0x%lx ", mark, mask);
-	else
-		printf("0x%lx ", mark);
-}
-
-/* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "MARK match: You must specify `--mark'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
-
-	printf("MARK match ");
-
-	if (info->invert)
-		printf("!");
-	
-	print_mark(info->mark, info->mask, numeric);
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
-
-	if (info->invert)
-		printf("! ");
-	
-	printf("--mark ");
-	print_mark(info->mark, info->mask, 0);
-}
-
-static struct ip6tables_match mark = {
-	.name		= "mark",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_mark_info)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mark_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void _init(void)
-{
-	register_match6(&mark);
-}
diff --git a/extensions/libipt_mark.c b/extensions/libipt_mark.c
deleted file mode 100644
index 47cc4ea..0000000
--- a/extensions/libipt_mark.c
+++ /dev/null
@@ -1,125 +0,0 @@
-/* Shared library add-on to iptables to add NFMARK matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <xtables.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter/xt_mark.h"
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"MARK match v%s options:\n"
-"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "mark", 1, 0, '1' },
-	{0}
-};
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-		markinfo->mark = strtoul(optarg, &end, 0);
-		if (*end == '/') {
-			markinfo->mask = strtoul(end+1, &end, 0);
-		} else
-			markinfo->mask = 0xffffffff;
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (invert)
-			markinfo->invert = 1;
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-static void
-print_mark(unsigned long mark, unsigned long mask, int numeric)
-{
-	if(mask != 0xffffffff)
-		printf("0x%lx/0x%lx ", mark, mask);
-	else
-		printf("0x%lx ", mark);
-}
-
-/* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "MARK match: You must specify `--mark'");
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
-
-	printf("MARK match ");
-
-	if (info->invert)
-		printf("!");
-	
-	print_mark(info->mark, info->mask, numeric);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
-
-	if (info->invert)
-		printf("! ");
-	
-	printf("--mark ");
-	print_mark(info->mark, info->mask, 0);
-}
-
-static struct xtables_match mark = { 
-	.next		= NULL,
-	.family		= AF_INET,
-	.name		= "mark",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
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
-	xtables_register_match(&mark);
-}
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
new file mode 100644
index 0000000..97771b0
--- /dev/null
+++ b/extensions/libxt_mark.c
@@ -0,0 +1,141 @@
+/* Shared library add-on to iptables to add NFMARK matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+/* For 64bit kernel / 32bit userspace */
+#include "../include/linux/netfilter/xt_mark.h"
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"MARK match v%s options:\n"
+"[!] --mark value[/mask]         Match nfmark value with optional mask\n"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "mark", 1, 0, '1' },
+	{0}
+};
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
+
+	switch (c) {
+		char *end;
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+		markinfo->mark = strtoul(optarg, &end, 0);
+		if (*end == '/') {
+			markinfo->mask = strtoul(end+1, &end, 0);
+		} else
+			markinfo->mask = 0xffffffff;
+		if (*end != '\0' || end == optarg)
+			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		if (invert)
+			markinfo->invert = 1;
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+print_mark(unsigned long mark, unsigned long mask, int numeric)
+{
+	if(mask != 0xffffffff)
+		printf("0x%lx/0x%lx ", mark, mask);
+	else
+		printf("0x%lx ", mark);
+}
+
+/* Final check; must have specified --mark. */
+static void
+final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "MARK match: You must specify `--mark'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
+
+	printf("MARK match ");
+
+	if (info->invert)
+		printf("!");
+	
+	print_mark(info->mark, info->mask, numeric);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void
+save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
+
+	if (info->invert)
+		printf("! ");
+	
+	printf("--mark ");
+	print_mark(info->mark, info->mask, 0);
+}
+
+static struct xtables_match mark = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "mark",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match mark6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "mark",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
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
+	xtables_register_match(&mark);
+	xtables_register_match(&mark6);
+}
diff --git a/include/linux/netfilter_ipv6/ip6t_mark.h b/include/linux/netfilter_ipv6/ip6t_mark.h
deleted file mode 100644
index 917c243..0000000
--- a/include/linux/netfilter_ipv6/ip6t_mark.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _IP6T_MARK_H
-#define _IP6T_MARK_H
-
-struct ip6t_mark_info {
-	unsigned long mark, mask;
-	u_int8_t invert;
-};
-
-#endif /*_IPT_MARK_H*/
-- 
1.5.2.2
