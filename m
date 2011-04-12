From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/28] libip6t_ipv6header: use guided option parser
Date: Tue, 12 Apr 2011 16:23:28 +0200
Message-ID: <1302618224-9449-14-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54657 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1DLOYA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:00 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ipv6header.c |   88 ++++++++++++---------------------------
 1 files changed, 27 insertions(+), 61 deletions(-)

diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index c05cedb..fca6f32 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -3,24 +3,18 @@ on whether they contain certain headers */
 
 /* Original idea: Brad Chapman 
  * Rewritten by: Andras Kis-Szabo <kisza@sch.bme.hu> */
-
-#include <getopt.h>
-#include <xtables.h>
-#include <stdbool.h>
-#include <stddef.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <netdb.h>
-#include <sys/types.h>
-
+#include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
-/* This maybe required 
-#include <linux/in.h>
-#include <linux/in6.h>
-*/
-
+enum {
+	O_HEADER = 0,
+	O_SOFT,
+};
 
 /* A few hardcoded protocols for 'all' and in case the user has no
  *    /etc/protocols */
@@ -140,10 +134,11 @@ static void ipv6header_help(void)
 "--soft                    The header CONTAINS the specified extensions\n");
 }
 
-static const struct option ipv6header_opts[] = {
-	{.name = "header", .has_arg = true,  .val = '1'},
-	{.name = "soft",   .has_arg = false, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry ipv6header_opts[] = {
+	{.name = "header", .id = O_HEADER, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	{.name = "soft", .id = O_SOFT, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
 static unsigned int
@@ -161,50 +156,22 @@ parse_header(const char *flags) {
         return ret;
 }
 
-#define IPV6_HDR_HEADER	0x01
-#define IPV6_HDR_SOFT	0x02
-
-static int
-ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_match **match)
+static void ipv6header_parse(struct xt_option_call *cb)
 {
-	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)(*match)->data;
-
-	switch (c) {
-		case '1' : 
-			/* Parse the provided header names */
-			if (*flags & IPV6_HDR_HEADER)
-				xtables_error(PARAMETER_PROBLEM,
-					"Only one `--header' allowed");
-
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-			if (! (info->matchflags = parse_header(optarg)) )
-				xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
-
-			if (invert) 
-				info->invflags |= 0xFF;
-			*flags |= IPV6_HDR_HEADER;
-			break;
-		case '2' : 
-			/* Soft-mode requested? */
-			if (*flags & IPV6_HDR_SOFT)
-				xtables_error(PARAMETER_PROBLEM,
-					"Only one `--soft' allowed");
-
-			info->modeflag |= 0xFF;
-			*flags |= IPV6_HDR_SOFT;
-			break;
+	struct ip6t_ipv6header_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_HEADER:
+		if (!(info->matchflags = parse_header(cb->arg)))
+			xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
+		if (cb->invert) 
+			info->invflags |= 0xFF;
+		break;
+	case O_SOFT:
+		info->modeflag |= 0xFF;
+		break;
 	}
-
-	return 1;
-}
-
-static void ipv6header_check(unsigned int flags)
-{
-	if (!(flags & IPV6_HDR_HEADER))
-		xtables_error(PARAMETER_PROBLEM,
-			"ip6t_ipv6header: no options specified");
 }
 
 static void
@@ -266,11 +233,10 @@ static struct xtables_match ipv6header_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.help		= ipv6header_help,
-	.parse		= ipv6header_parse,
-	.final_check	= ipv6header_check,
 	.print		= ipv6header_print,
 	.save		= ipv6header_save,
-	.extra_opts	= ipv6header_opts,
+	.x6_parse	= ipv6header_parse,
+	.x6_options	= ipv6header_opts,
 };
 
 void _init(void)
-- 
1.7.1

