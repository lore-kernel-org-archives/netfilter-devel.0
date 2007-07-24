From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 01/13] Add IPv6 support to CONNMARK match
Date: Tue, 24 Jul 2007 15:57:53 +0900 (JST)
Message-ID: <200707240657.l6O6vrN4018921@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
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


 extensions/Makefile                                |    6 +-
 extensions/libip6t_CONNMARK.c                      |  220 --------------------
 extensions/{libipt_CONNMARK.c => libxt_CONNMARK.c} |   79 +++++---
 .../ipt_CONNMARK.h => netfilter/xt_CONNMARK.h}     |   14 +-
 4 files changed, 58 insertions(+), 261 deletions(-)
 delete mode 100644 extensions/libip6t_CONNMARK.c
 rename extensions/{libipt_CONNMARK.c => libxt_CONNMARK.c} (74%)
 rename include/linux/{netfilter_ipv4/ipt_CONNMARK.h => netfilter/xt_CONNMARK.h} (70%)

diff --git a/extensions/Makefile b/extensions/Makefile
index fa3fdb5..7956dbd 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG MARK TRACE
-PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state HL LOG MARK TRACE
+PFX_EXT_SLIB:=comment dscp esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=CONNSECMARK
diff --git a/extensions/libip6t_CONNMARK.c b/extensions/libip6t_CONNMARK.c
deleted file mode 100644
index 69d3a5a..0000000
--- a/extensions/libip6t_CONNMARK.c
+++ /dev/null
@@ -1,220 +0,0 @@
-/* Shared library add-on to iptables to add CONNMARK target support.
- *
- * (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
- * by Henrik Nordstrom <hno@marasystems.com>
- *
- * Version 1.1
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include "../include/linux/netfilter_ipv4/ipt_CONNMARK.h"
-
-#if 0
-struct markinfo {
-	struct ipt_entry_target t;
-	struct ipt_connmark_target_info mark;
-};
-#endif
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"CONNMARK target v%s options:\n"
-"  --set-mark value[/mask]       Set conntrack mark value\n"
-"  --save-mark [--mask mask]     Save the packet nfmark in the connection\n"
-"  --restore-mark [--mask mask]  Restore saved nfmark value\n"
-"\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "set-mark", 1, 0, '1' },
-	{ "save-mark", 0, 0, '2' },
-	{ "restore-mark", 0, 0, '3' },
-	{ "mask", 1, 0, '4' },
-	{ 0 }
-};
-
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
-{
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
-{
-	struct ipt_connmark_target_info *markinfo
-		= (struct ipt_connmark_target_info *)(*target)->data;
-
-	markinfo->mask = 0xffffffffUL;
-
-	switch (c) {
-		char *end;
-	case '1':
-		markinfo->mode = IPT_CONNMARK_SET;
-
-		markinfo->mark = strtoul(optarg, &end, 0);
-		if (*end == '/' && end[1] != '\0')
-		    markinfo->mask = strtoul(end+1, &end, 0);
-
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --set-mark twice");
-		*flags = 1;
-		break;
-	case '2':
-		markinfo->mode = IPT_CONNMARK_SAVE;
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --save-mark twice");
-		*flags = 1;
-		break;
-	case '3':
-		markinfo->mode = IPT_CONNMARK_RESTORE;
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --restore-mark twice");
-		*flags = 1;
-		break;
-	case '4':
-		if (!*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "CONNMARK target: Can't specify --mask without a operation");
-		markinfo->mask = strtoul(optarg, &end, 0);
-
-		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MASK value `%s'", optarg);
-		break;
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
-		           "CONNMARK target: No operation specified");
-}
-
-static void
-print_mark(unsigned long mark)
-{
-	printf("0x%lx", mark);
-}
-
-static void
-print_mask(const char *text, unsigned long mask)
-{
-	if (mask != 0xffffffffUL)
-		printf("%s0x%lx", text, mask);
-}
-
-
-/* Prints out the target info. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
-{
-	const struct ipt_connmark_target_info *markinfo =
-		(const struct ipt_connmark_target_info *)target->data;
-	switch (markinfo->mode) {
-	case IPT_CONNMARK_SET:
-	    printf("CONNMARK set ");
-	    print_mark(markinfo->mark);
-	    print_mask("/", markinfo->mask);
-	    printf(" ");
-	    break;
-	case IPT_CONNMARK_SAVE:
-	    printf("CONNMARK save ");
-	    print_mask("mask ", markinfo->mask);
-	    printf(" ");
-	    break;
-	case IPT_CONNMARK_RESTORE:
-	    printf("CONNMARK restore ");
-	    print_mask("mask ", markinfo->mask);
-	    break;
-	default:
-	    printf("ERROR: UNKNOWN CONNMARK MODE ");
-	    break;
-	}
-}
-
-/* Saves the target into in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ipt_connmark_target_info *markinfo =
-		(const struct ipt_connmark_target_info *)target->data;
-
-	switch (markinfo->mode) {
-	case IPT_CONNMARK_SET:
-	    printf("--set-mark ");
-	    print_mark(markinfo->mark);
-	    print_mask("/", markinfo->mask);
-	    printf(" ");
-	    break;
-	case IPT_CONNMARK_SAVE:
-	    printf("--save-mark ");
-	    print_mask("--mask ", markinfo->mask);
-	    break;
-	case IPT_CONNMARK_RESTORE:
-	    printf("--restore-mark ");
-	    print_mask("--mask ", markinfo->mask);
-	    break;
-	default:
-	    printf("ERROR: UNKNOWN CONNMARK MODE ");
-	    break;
-	}
-}
-
-static struct ip6tables_target connmark_target = {
-    .name          = "CONNMARK",
-    .version       = IPTABLES_VERSION,
-    .size          = IP6T_ALIGN(sizeof(struct ipt_connmark_target_info)),
-    .userspacesize = IP6T_ALIGN(sizeof(struct ipt_connmark_target_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
-};
-
-void _init(void)
-{
-	register_target6(&connmark_target);
-}
diff --git a/extensions/libipt_CONNMARK.c b/extensions/libxt_CONNMARK.c
similarity index 74%
rename from extensions/libipt_CONNMARK.c
rename to extensions/libxt_CONNMARK.c
index fbf0d4d..8752fce 100644
--- a/extensions/libipt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -24,9 +24,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include "../include/linux/netfilter_ipv4/ipt_CONNMARK.h"
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_CONNMARK.h>
 
 #if 0
 struct markinfo {
@@ -69,15 +69,15 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
 {
-	struct ipt_connmark_target_info *markinfo
-		= (struct ipt_connmark_target_info *)(*target)->data;
+	struct xt_connmark_target_info *markinfo
+		= (struct xt_connmark_target_info *)(*target)->data;
 
 	markinfo->mask = 0xffffffffUL;
 
 	switch (c) {
 		char *end;
 	case '1':
-		markinfo->mode = IPT_CONNMARK_SET;
+		markinfo->mode = XT_CONNMARK_SET;
 
 		markinfo->mark = strtoul(optarg, &end, 0);
 		if (*end == '/' && end[1] != '\0')
@@ -91,14 +91,14 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags = 1;
 		break;
 	case '2':
-		markinfo->mode = IPT_CONNMARK_SAVE;
+		markinfo->mode = XT_CONNMARK_SAVE;
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --save-mark twice");
 		*flags = 1;
 		break;
 	case '3':
-		markinfo->mode = IPT_CONNMARK_RESTORE;
+		markinfo->mode = XT_CONNMARK_RESTORE;
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --restore-mark twice");
@@ -148,21 +148,21 @@ print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
-	const struct ipt_connmark_target_info *markinfo =
-		(const struct ipt_connmark_target_info *)target->data;
+	const struct xt_connmark_target_info *markinfo =
+		(const struct xt_connmark_target_info *)target->data;
 	switch (markinfo->mode) {
-	case IPT_CONNMARK_SET:
+	case XT_CONNMARK_SET:
 	    printf("CONNMARK set ");
 	    print_mark(markinfo->mark);
 	    print_mask("/", markinfo->mask);
 	    printf(" ");
 	    break;
-	case IPT_CONNMARK_SAVE:
+	case XT_CONNMARK_SAVE:
 	    printf("CONNMARK save ");
 	    print_mask("mask ", markinfo->mask);
 	    printf(" ");
 	    break;
-	case IPT_CONNMARK_RESTORE:
+	case XT_CONNMARK_RESTORE:
 	    printf("CONNMARK restore ");
 	    print_mask("mask ", markinfo->mask);
 	    break;
@@ -176,21 +176,21 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_connmark_target_info *markinfo =
-		(const struct ipt_connmark_target_info *)target->data;
+	const struct xt_connmark_target_info *markinfo =
+		(const struct xt_connmark_target_info *)target->data;
 
 	switch (markinfo->mode) {
-	case IPT_CONNMARK_SET:
+	case XT_CONNMARK_SET:
 	    printf("--set-mark ");
 	    print_mark(markinfo->mark);
 	    print_mask("/", markinfo->mask);
 	    printf(" ");
 	    break;
-	case IPT_CONNMARK_SAVE:
+	case XT_CONNMARK_SAVE:
 	    printf("--save-mark ");
 	    print_mask("--mask ", markinfo->mask);
 	    break;
-	case IPT_CONNMARK_RESTORE:
+	case XT_CONNMARK_RESTORE:
 	    printf("--restore-mark ");
 	    print_mask("--mask ", markinfo->mask);
 	    break;
@@ -200,21 +200,38 @@ save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static struct iptables_target connmark_target = {
-    .name          = "CONNMARK",
-    .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_connmark_target_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_connmark_target_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+static struct xtables_target connmark_target = {
+	.family		= AF_INET,
+	.name		= "CONNMARK",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+static struct xtables_target connmark_target6 = {
+	.family		= AF_INET6,
+	.name		= "CONNMARK",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
 };
 
 void _init(void)
 {
-	register_target(&connmark_target);
+	xtables_register_target(&connmark_target);
+	xtables_register_target(&connmark_target6);
 }
diff --git a/include/linux/netfilter_ipv4/ipt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
similarity index 70%
rename from include/linux/netfilter_ipv4/ipt_CONNMARK.h
rename to include/linux/netfilter/xt_CONNMARK.h
index d3c0253..9f74468 100644
--- a/include/linux/netfilter_ipv4/ipt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -1,5 +1,5 @@
-#ifndef _IPT_CONNMARK_H_target
-#define _IPT_CONNMARK_H_target
+#ifndef _XT_CONNMARK_H_target
+#define _XT_CONNMARK_H_target
 
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
@@ -11,15 +11,15 @@
  */
 
 enum {
-	IPT_CONNMARK_SET = 0,
-	IPT_CONNMARK_SAVE,
-	IPT_CONNMARK_RESTORE
+	XT_CONNMARK_SET = 0,
+	XT_CONNMARK_SAVE,
+	XT_CONNMARK_RESTORE
 };
 
-struct ipt_connmark_target_info {
+struct xt_connmark_target_info {
 	unsigned long mark;
 	unsigned long mask;
 	u_int8_t mode;
 };
 
-#endif /*_IPT_CONNMARK_H_target*/
+#endif /*_XT_CONNMARK_H_target*/
-- 
1.5.2.2
