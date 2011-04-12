From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/28] libipt_addrtype: use guided option parser
Date: Tue, 12 Apr 2011 16:23:30 +0200
Message-ID: <1302618224-9449-16-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54665 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1DLOYC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:02 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_addrtype.c |  160 +++++++++++++++---------------------------
 1 files changed, 57 insertions(+), 103 deletions(-)

diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index a592f0d..3dec626 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -1,15 +1,22 @@
 /* Shared library add-on to iptables to add addrtype matching support 
  * 
  * This program is released under the terms of GNU GPL */
-#include <stdbool.h>
 #include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
-
 #include <linux/netfilter_ipv4/ipt_addrtype.h>
 
+enum {
+	O_SRC_TYPE = 0,
+	O_DST_TYPE,
+	O_LIMIT_IFACE_IN,
+	O_LIMIT_IFACE_OUT,
+	F_SRC_TYPE        = 1 << O_SRC_TYPE,
+	F_DST_TYPE        = 1 << O_DST_TYPE,
+	F_LIMIT_IFACE_IN  = 1 << O_LIMIT_IFACE_IN,
+	F_LIMIT_IFACE_OUT = 1 << O_LIMIT_IFACE_OUT,
+};
+
 /* from linux/rtnetlink.h, must match order of enumeration */
 static const char *const rtn_names[] = {
 	"UNSPEC",
@@ -89,110 +96,57 @@ static void parse_types(const char *arg, uint16_t *mask)
 		xtables_error(PARAMETER_PROBLEM, "addrtype: bad type \"%s\"", arg);
 }
 	
-#define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
-#define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
-#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN		0x4
-#define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
-
-static int
-addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void addrtype_parse_v0(struct xt_option_call *cb)
 {
-	struct ipt_addrtype_info *info =
-		(struct ipt_addrtype_info *) (*match)->data;
+	struct ipt_addrtype_info *info = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify src-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_types(optarg, &info->source);
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_TYPE:
+		parse_types(cb->arg, &info->source);
+		if (cb->invert)
 			info->invert_source = 1;
-		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
 		break;
-	case '2':
-		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify dst-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_types(optarg, &info->dest);
-		if (invert)
+	case O_DST_TYPE:
+		parse_types(cb->arg, &info->dest);
+		if (cb->invert)
 			info->invert_dest = 1;
-		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
 		break;
 	}
-	
-	return 1;
 }
 
-static int
-addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void addrtype_parse_v1(struct xt_option_call *cb)
 {
-	struct ipt_addrtype_info_v1 *info =
-		(struct ipt_addrtype_info_v1 *) (*match)->data;
+	struct ipt_addrtype_info_v1 *info = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify src-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_types(optarg, &info->source);
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_TYPE:
+		parse_types(cb->arg, &info->source);
+		if (cb->invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
-		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
 		break;
-	case '2':
-		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify dst-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_types(optarg, &info->dest);
-		if (invert)
+	case O_DST_TYPE:
+		parse_types(cb->arg, &info->dest);
+		if (cb->invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
-		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
 		break;
-	case '3':
-		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify limit-iface-in twice");
+	case O_LIMIT_IFACE_IN:
 		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
-		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
 		break;
-	case '4':
-		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
-			xtables_error(PARAMETER_PROBLEM,
-			           "addrtype: can't specify limit-iface-out twice");
+	case O_LIMIT_IFACE_OUT:
 		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
-		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
 		break;
 	}
-	
-	return 1;
 }
 
-static void addrtype_check_v0(unsigned int flags)
+static void addrtype_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
+	if (!(cb->xflags & (F_SRC_TYPE | F_DST_TYPE)))
 		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
 
-static void addrtype_check_v1(unsigned int flags)
-{
-	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
-		xtables_error(PARAMETER_PROBLEM,
-			   "addrtype: you must specify --src-type or --dst-type");
-	if (flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
-	    flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
-		xtables_error(PARAMETER_PROBLEM,
-			   "addrtype: you can't specify both --limit-iface-in "
-			   "and --limit-iface-out");
-}
-
 static void print_types(uint16_t mask)
 {
 	const char *sep = "";
@@ -297,24 +251,24 @@ static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static const struct option addrtype_opts[] = {
-	{.name = "src-type", .has_arg = true, .val = '1'},
-	{.name = "dst-type", .has_arg = true, .val = '2'},
-	XT_GETOPT_TABLEEND,
-};
-
-static const struct option addrtype_opts_v0[] = {
-	{.name = "src-type", .has_arg = true, .val = '1'},
-	{.name = "dst-type", .has_arg = true, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry addrtype_opts_v0[] = {
+	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static const struct option addrtype_opts_v1[] = {
-	{.name = "src-type",        .has_arg = true,  .val = '1'},
-	{.name = "dst-type",        .has_arg = true,  .val = '2'},
-	{.name = "limit-iface-in",  .has_arg = false, .val = '3'},
-	{.name = "limit-iface-out", .has_arg = false, .val = '4'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry addrtype_opts_v1[] = {
+	{.name = "src-type", .id = O_SRC_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-type", .id = O_DST_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "limit-iface-in", .id = O_LIMIT_IFACE_IN,
+	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_OUT},
+	{.name = "limit-iface-out", .id = O_LIMIT_IFACE_OUT,
+	 .type = XTTYPE_NONE, .excl = F_LIMIT_IFACE_IN},
+	XTOPT_TABLEEND,
 };
 
 static struct xtables_match addrtype_mt_reg[] = {
@@ -325,11 +279,11 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
 		.help          = addrtype_help_v0,
-		.parse         = addrtype_parse_v0,
-		.final_check   = addrtype_check_v0,
 		.print         = addrtype_print_v0,
 		.save          = addrtype_save_v0,
-		.extra_opts    = addrtype_opts_v0,
+		.x6_parse      = addrtype_parse_v0,
+		.x6_fcheck     = addrtype_check,
+		.x6_options    = addrtype_opts_v0,
 	},
 	{
 		.name          = "addrtype",
@@ -339,11 +293,11 @@ static struct xtables_match addrtype_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 		.help          = addrtype_help_v1,
-		.parse         = addrtype_parse_v1,
-		.final_check   = addrtype_check_v1,
 		.print         = addrtype_print_v1,
 		.save          = addrtype_save_v1,
-		.extra_opts    = addrtype_opts_v1,
+		.x6_parse      = addrtype_parse_v1,
+		.x6_fcheck     = addrtype_check,
+		.x6_options    = addrtype_opts_v1,
 	},
 };
 
-- 
1.7.1

