From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 20/26] libxt_string: use guided option parser
Date: Wed, 13 Apr 2011 18:13:41 +0200
Message-ID: <1302711228-15947-21-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42475 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078Ab1DMQOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:12 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |  138 +++++++++++++++-----------------------------
 1 files changed, 47 insertions(+), 91 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 1030d2e..eef0b08 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -20,18 +20,25 @@
  *             updated to work with slightly modified
  *             ipt_string_info.
  */
-#define _GNU_SOURCE 1
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <ctype.h>
 #include <xtables.h>
-#include <stddef.h>
 #include <linux/netfilter/xt_string.h>
 
+enum {
+	O_FROM = 0,
+	O_TO,
+	O_ALGO,
+	O_ICASE,
+	O_STRING,
+	O_HEX_STRING,
+	F_STRING     = 1 << O_STRING,
+	F_HEX_STRING = 1 << O_HEX_STRING,
+	F_OP_ANY     = F_STRING | F_HEX_STRING,
+};
+
 static void string_help(void)
 {
 	printf(
@@ -44,15 +51,22 @@ static void string_help(void)
 "[!] --hex-string string      Match a hex string in a packet\n");
 }
 
-static const struct option string_opts[] = {
-	{.name = "from",       .has_arg = true,  .val = '1'},
-	{.name = "to",         .has_arg = true,  .val = '2'},
-	{.name = "algo",       .has_arg = true,  .val = '3'},
-	{.name = "string",     .has_arg = true,  .val = '4'},
-	{.name = "hex-string", .has_arg = true,  .val = '5'},
-	{.name = "icase",      .has_arg = false, .val = '6'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_string_info
+static const struct xt_option_entry string_opts[] = {
+	{.name = "from", .id = O_FROM, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, from_offset)},
+	{.name = "to", .id = O_TO, .type = XTTYPE_UINT16,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, to_offset)},
+	{.name = "algo", .id = O_ALGO, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, algo)},
+	{.name = "string", .id = O_STRING, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT, .excl = F_HEX_STRING},
+	{.name = "hex-string", .id = O_HEX_STRING, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT, .excl = F_STRING},
+	{.name = "icase", .id = O_ICASE, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void string_init(struct xt_entry_match *m)
 {
@@ -74,17 +88,6 @@ parse_string(const char *s, struct xt_string_info *info)
 }
 
 static void
-parse_algo(const char *s, struct xt_string_info *info)
-{
-	/* xt_string needs \0 for algo name */
-	if (strlen(s) < XT_STRING_MAX_ALGO_NAME_SIZE) {
-		strncpy(info->algo, s, XT_STRING_MAX_ALGO_NAME_SIZE);
-		return;
-	}
-	xtables_error(PARAMETER_PROBLEM, "ALGO too long \"%s\"", s);
-}
-
-static void
 parse_hex_string(const char *s, struct xt_string_info *info)
 {
 	int i=0, slen, sindex=0, schar;
@@ -162,94 +165,47 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 	info->patlen = sindex;
 }
 
-#define STRING 0x1
-#define ALGO   0x2
-#define FROM   0x4
-#define TO     0x8
-#define ICASE  0x10
-
-static int
-string_parse(int c, char **argv, int invert, unsigned int *flags,
-             const void *entry, struct xt_entry_match **match)
+static void string_parse(struct xt_option_call *cb)
 {
-	struct xt_string_info *stringinfo =
-	    (struct xt_string_info *)(*match)->data;
-	const int revision = (*match)->u.user.revision;
+	struct xt_string_info *stringinfo = cb->data;
+	const unsigned int revision = (*cb->match)->u.user.revision;
 
-	switch (c) {
-	case '1':
-		if (*flags & FROM)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple --from");
-		stringinfo->from_offset = atoi(optarg);
-		*flags |= FROM;
-		break;
-	case '2':
-		if (*flags & TO)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple --to");
-		stringinfo->to_offset = atoi(optarg);
-		*flags |= TO;
-		break;
-	case '3':
-		if (*flags & ALGO)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple --algo");
-		parse_algo(optarg, stringinfo);
-		*flags |= ALGO;
-		break;
-	case '4':
-		if (*flags & STRING)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple --string");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_string(optarg, stringinfo);
-		if (invert) {
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_STRING:
+		parse_string(cb->arg, stringinfo);
+		if (cb->invert) {
 			if (revision == 0)
 				stringinfo->u.v0.invert = 1;
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
-		*flags |= STRING;
 		break;
-
-	case '5':
-		if (*flags & STRING)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple --hex-string");
-
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_hex_string(optarg, stringinfo);  /* sets length */
-		if (invert) {
+	case O_HEX_STRING:
+		parse_hex_string(cb->arg, stringinfo);  /* sets length */
+		if (cb->invert) {
 			if (revision == 0)
 				stringinfo->u.v0.invert = 1;
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
-		*flags |= STRING;
 		break;
-
-	case '6':
+	case O_ICASE:
 		if (revision == 0)
 			xtables_error(VERSION_PROBLEM,
 				   "Kernel doesn't support --icase");
 
 		stringinfo->u.v1.flags |= XT_STRING_FLAG_IGNORECASE;
-		*flags |= ICASE;
 		break;
 	}
-	return 1;
 }
 
-static void string_check(unsigned int flags)
+static void string_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & STRING))
+	if (!(cb->xflags & F_OP_ANY))
 		xtables_error(PARAMETER_PROBLEM,
 			   "STRING match: You must specify `--string' or "
 			   "`--hex-string'");
-	if (!(flags & ALGO))
-		xtables_error(PARAMETER_PROBLEM,
-			   "STRING match: You must specify `--algo'");
 }
 
 /* Test to see if the string contains non-printable chars or quotes */
@@ -357,11 +313,11 @@ static struct xtables_match string_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_string_info, config),
 		.help          = string_help,
 		.init          = string_init,
-		.parse         = string_parse,
-		.final_check   = string_check,
 		.print         = string_print,
 		.save          = string_save,
-		.extra_opts    = string_opts,
+		.x6_parse      = string_parse,
+		.x6_fcheck     = string_check,
+		.x6_options    = string_opts,
 	},
 	{
 		.name          = "string",
@@ -372,11 +328,11 @@ static struct xtables_match string_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_string_info, config),
 		.help          = string_help,
 		.init          = string_init,
-		.parse         = string_parse,
-		.final_check   = string_check,
 		.print         = string_print,
 		.save          = string_save,
-		.extra_opts    = string_opts,
+		.x6_parse      = string_parse,
+		.x6_fcheck     = string_check,
+		.x6_options    = string_opts,
 	},
 };
 
-- 
1.7.1

