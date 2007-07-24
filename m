From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 05/13] Unifies libip[6]t_connmark into libxt_connmark
Date: Tue, 24 Jul 2007 15:58:23 +0900 (JST)
Message-ID: <200707240658.l6O6wOeV010494@toshiba.co.jp>
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
 extensions/libipt_connmark.c                       |  151 --------------------
 .../{libip6t_connmark.c => libxt_connmark.c}       |   59 +++++----
 .../ipt_connmark.h => netfilter/xt_connmark.h}     |    8 +-
 4 files changed, 40 insertions(+), 184 deletions(-)
 delete mode 100644 extensions/libipt_connmark.c
 rename extensions/{libip6t_connmark.c => libxt_connmark.c} (72%)
 rename include/linux/{netfilter_ipv4/ipt_connmark.h => netfilter/xt_connmark.h} (81%)

diff --git a/extensions/Makefile b/extensions/Makefile
index 6918759..6b70bd5 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype connlimit connmark conntrack ecn helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state HL LOG TRACE
-PFX_EXT_SLIB:=comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
+PF_EXT_SLIB:=ah addrtype connlimit conntrack ecn helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY DNAT DSCP ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit eui64 hl icmp6 owner policy state HL LOG TRACE
+PFX_EXT_SLIB:=connmark comment dscp esp hashlimit length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp CONNMARK MARK NFQUEUE NOTRACK TCPMSS
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=
diff --git a/extensions/libipt_connmark.c b/extensions/libipt_connmark.c
deleted file mode 100644
index 86248d9..0000000
--- a/extensions/libipt_connmark.c
+++ /dev/null
@@ -1,151 +0,0 @@
-/* Shared library add-on to iptables to add connmark matching support.
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
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
-#include <iptables.h>
-#include "../include/linux/netfilter_ipv4/ipt_connmark.h"
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"CONNMARK match v%s options:\n"
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
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_connmark_info *markinfo = (struct ipt_connmark_info *)(*match)->data;
-
-	switch (c) {
-		char *end;
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		markinfo->mark = strtoul(optarg, &end, 0);
-		markinfo->mask = 0xffffffffUL;
-		
-		if (*end == '/')
-			markinfo->mask = strtoul(end+1, &end, 0);
-
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
-	if(mask != 0xffffffffUL)
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
-	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
-
-	printf("CONNMARK match ");
-	if (info->invert)
-		printf("!");
-	print_mark(info->mark, info->mask, numeric);
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
-
-	if (info->invert)
-		printf("! ");
-
-	printf("--mark ");
-	print_mark(info->mark, info->mask, 0);
-}
-
-static struct iptables_match connmark_match = {
-    .name          = "connmark",
-    .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_connmark_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_connmark_info)),
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
-	register_match(&connmark_match);
-}
diff --git a/extensions/libip6t_connmark.c b/extensions/libxt_connmark.c
similarity index 72%
rename from extensions/libip6t_connmark.c
rename to extensions/libxt_connmark.c
index 0a67c3a..b05bac2 100644
--- a/extensions/libip6t_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -25,8 +25,8 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <ip6tables.h>
-#include "../include/linux/netfilter_ipv4/ipt_connmark.h"
+#include <xtables.h>
+#include <linux/netfilter/xt_connmark.h>
 
 /* Function which prints out usage message. */
 static void
@@ -44,14 +44,6 @@ static struct option opts[] = {
 	{0}
 };
 
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -60,7 +52,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_connmark_info *markinfo = (struct ipt_connmark_info *)(*match)->data;
+	struct xt_connmark_info *markinfo = (struct xt_connmark_info *)(*match)->data;
 
 	switch (c) {
 		char *end;
@@ -110,7 +102,7 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
+	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
 
 	printf("CONNMARK match ");
 	if (info->invert)
@@ -122,7 +114,7 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
+	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
 
 	if (info->invert)
 		printf("! ");
@@ -131,21 +123,36 @@ save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask, 0);
 }
 
-static struct ip6tables_match connmark_match = {
-    .name          = "connmark",
-    .version       = IPTABLES_VERSION,
-    .size          = IP6T_ALIGN(sizeof(struct ipt_connmark_info)),
-    .userspacesize = IP6T_ALIGN(sizeof(struct ipt_connmark_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+static struct xtables_match connmark_match = {
+	.family		= AF_INET,
+	.name		= "connmark",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match connmark_match6 = {
+	.family		= AF_INET6,
+	.name		= "connmark",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
+	.help		= &help,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
 };
 
 void _init(void)
 {
-	register_match6(&connmark_match);
+	xtables_register_match(&connmark_match);
+	xtables_register_match(&connmark_match6);
 }
diff --git a/include/linux/netfilter_ipv4/ipt_connmark.h b/include/linux/netfilter/xt_connmark.h
similarity index 81%
rename from include/linux/netfilter_ipv4/ipt_connmark.h
rename to include/linux/netfilter/xt_connmark.h
index 4657327..c592f6a 100644
--- a/include/linux/netfilter_ipv4/ipt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -1,5 +1,5 @@
-#ifndef _IPT_CONNMARK_H
-#define _IPT_CONNMARK_H
+#ifndef _XT_CONNMARK_H
+#define _XT_CONNMARK_H
 
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
@@ -10,9 +10,9 @@
  * (at your option) any later version.
  */
 
-struct ipt_connmark_info {
+struct xt_connmark_info {
 	unsigned long mark, mask;
 	u_int8_t invert;
 };
 
-#endif /*_IPT_CONNMARK_H*/
+#endif /*_XT_CONNMARK_H*/
-- 
1.5.2.2
