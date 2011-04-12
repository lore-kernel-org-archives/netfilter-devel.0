From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/28] libip[6]t_icmp: use guided option parser
Date: Tue, 12 Apr 2011 16:23:27 +0200
Message-ID: <1302618224-9449-13-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54649 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1DLOX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:58 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_icmp6.c |   53 ++++++++++++++-----------------------------
 extensions/libipt_icmp.c   |   47 +++++++++++++++------------------------
 2 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index fa87b69..68b940b 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -1,14 +1,14 @@
-/* Shared library add-on to ip6tables to add ICMP support. */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip6_tables.h */
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
+enum {
+	O_ICMPV6_TYPE = 0,
+};
+
 struct icmpv6_names {
 	const char *name;
 	uint8_t type;
@@ -84,9 +84,10 @@ static void icmp6_help(void)
 	print_icmpv6types();
 }
 
-static const struct option icmp6_opts[] = {
-	{.name = "icmpv6-type", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry icmp6_opts[] = {
+	{.name = "icmpv6-type", .id = O_ICMPV6_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static void
@@ -149,26 +150,14 @@ static void icmp6_init(struct xt_entry_match *m)
 	icmpv6info->code[1] = 0xFF;
 }
 
-static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_match **match)
+static void icmp6_parse(struct xt_option_call *cb)
 {
-	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags == 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "icmpv6 match: only use --icmpv6-type once!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_icmpv6(optarg, &icmpv6info->type, 
-			     icmpv6info->code);
-		if (invert)
-			icmpv6info->invflags |= IP6T_ICMP_INV;
-		*flags = 1;
-		break;
-	}
+	struct ip6t_icmp *icmpv6info = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	parse_icmpv6(cb->arg, &icmpv6info->type, icmpv6info->code);
+	if (cb->invert)
+		icmpv6info->invflags |= IP6T_ICMP_INV;
 }
 
 static void print_icmpv6type(uint8_t type,
@@ -230,13 +219,6 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 		printf("/%u", icmpv6->code[0]);
 }
 
-static void icmp6_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "icmpv6 match: You must specify `--icmpv6-type'");
-}
-
 static struct xtables_match icmp6_mt6_reg = {
 	.name 		= "icmp6",
 	.version 	= XTABLES_VERSION,
@@ -245,11 +227,10 @@ static struct xtables_match icmp6_mt6_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_icmp)),
 	.help		= icmp6_help,
 	.init		= icmp6_init,
-	.parse		= icmp6_parse,
-	.final_check	= icmp6_check,
 	.print		= icmp6_print,
 	.save		= icmp6_save,
-	.extra_opts	= icmp6_opts,
+	.x6_parse	= icmp6_parse,
+	.x6_options	= icmp6_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index c75713d..666e7da 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -1,12 +1,8 @@
-/* Shared library add-on to iptables to add ICMP support. */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
-#include <limits.h> /* INT_MAX in ip_tables.h */
+#include <limits.h> /* INT_MAX in ip6_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 /* special hack for icmp-type 'any': 
@@ -17,6 +13,10 @@
  * See: https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=37
  */
 
+enum {
+	O_ICMP_TYPE = 0,
+};
+
 struct icmp_names {
 	const char *name;
 	uint8_t type;
@@ -108,9 +108,10 @@ static void icmp_help(void)
 	print_icmptypes();
 }
 
-static const struct option icmp_opts[] = {
-	{.name = "icmp-type", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry icmp_opts[] = {
+	{.name = "icmp-type", .id = O_ICMP_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static void 
@@ -174,26 +175,14 @@ static void icmp_init(struct xt_entry_match *m)
 	icmpinfo->code[1] = 0xFF;
 }
 
-static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_match **match)
+static void icmp_parse(struct xt_option_call *cb)
 {
-	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags == 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "icmp match: only use --icmp-type once!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_icmp(optarg, &icmpinfo->type, 
-			   icmpinfo->code);
-		if (invert)
-			icmpinfo->invflags |= IPT_ICMP_INV;
-		*flags = 1;
-		break;
-	}
+	struct ipt_icmp *icmpinfo = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	parse_icmp(cb->arg, &icmpinfo->type, icmpinfo->code);
+	if (cb->invert)
+		icmpinfo->invflags |= IPT_ICMP_INV;
 }
 
 static void print_icmptype(uint8_t type,
@@ -268,10 +257,10 @@ static struct xtables_match icmp_mt_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_icmp)),
 	.help		= icmp_help,
 	.init		= icmp_init,
-	.parse		= icmp_parse,
 	.print		= icmp_print,
 	.save		= icmp_save,
-	.extra_opts	= icmp_opts,
+	.x6_parse	= icmp_parse,
+	.x6_options	= icmp_opts,
 };
 
 void _init(void)
-- 
1.7.1

