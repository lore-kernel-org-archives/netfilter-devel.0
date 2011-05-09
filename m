From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/17] libxt_osf: use guided option parser
Date: Mon,  9 May 2011 21:55:05 +0200
Message-ID: <1304970912-11520-12-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49355 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1EITz2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:28 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_osf.c |   97 ++++++++++++++---------------------------------
 1 files changed, 29 insertions(+), 68 deletions(-)

diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 20acfea..88274a0 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -20,23 +20,19 @@
 /*
  * xtables interface for OS fingerprint matching module.
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-
-#include <linux/types.h>
-
 #include <xtables.h>
-
 #include <netinet/ip.h>
 #include <netinet/tcp.h>
-
 #include <linux/netfilter/xt_osf.h>
 
+enum {
+	O_GENRE = 0,
+	O_TTL,
+	O_LOGLEVEL,
+};
+
 static void osf_help(void)
 {
 	printf("OS fingerprint match options:\n"
@@ -52,71 +48,37 @@ static void osf_help(void)
 		);
 }
 
-
-static const struct option osf_opts[] = {
-	{.name = "genre", .has_arg = true, .val = '1'},
-	{.name = "ttl",   .has_arg = true, .val = '2'},
-	{.name = "log",   .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_osf_info
+static const struct xt_option_entry osf_opts[] = {
+	{.name = "genre", .id = O_GENRE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, genre)},
+	{.name = "ttl", .id = O_TTL, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, ttl), .min = 0, .max = 2},
+	{.name = "log", .id = O_LOGLEVEL, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, loglevel), .min = 0, .max = 2},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-
-static void osf_parse_string(const char *s, struct xt_osf_info *info)
+static void osf_parse(struct xt_option_call *cb)
 {
-	if (strlen(s) < MAXGENRELEN)
-		strcpy(info->genre, s);
-	else
-		xtables_error(PARAMETER_PROBLEM,
-			      "Genre string too long `%s' [%zd], max=%d",
-			      s, strlen(s), MAXGENRELEN);
-}
-
-static int osf_parse(int c, char **argv, int invert, unsigned int *flags,
-      			const void *entry,
-      			struct xt_entry_match **match)
-{
-	struct xt_osf_info *info = (struct xt_osf_info *)(*match)->data;
+	struct xt_osf_info *info = cb->data;
 
-	switch(c) {
-		case '1': /* --genre */
-			if (*flags & XT_OSF_GENRE)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't specify multiple genre parameter");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			osf_parse_string(argv[optind-1], info);
-			if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+		case O_GENRE:
+			if (cb->invert)
 				info->flags |= XT_OSF_INVERT;
-			info->len=strlen(info->genre);
-			*flags |= XT_OSF_GENRE;
+			info->len = strlen(info->genre);
 			break;
-		case '2': /* --ttl */
-			if (*flags & XT_OSF_TTL)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't specify multiple ttl parameter");
-			*flags |= XT_OSF_TTL;
+		case O_TTL:
 			info->flags |= XT_OSF_TTL;
-			if (!xtables_strtoui(argv[optind-1], NULL, &info->ttl, 0, 2))
-				xtables_error(PARAMETER_PROBLEM, "TTL parameter is too big");
 			break;
-		case '3': /* --log */
-			if (*flags & XT_OSF_LOG)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't specify multiple log parameter");
-			*flags |= XT_OSF_LOG;
-			if (!xtables_strtoui(argv[optind-1], NULL, &info->loglevel, 0, 2))
-				xtables_error(PARAMETER_PROBLEM, "Log level parameter is too big");
+		case O_LOGLEVEL:
 			info->flags |= XT_OSF_LOG;
 			break;
 	}
-
-	return 1;
-}
-
-static void osf_final_check(unsigned int flags)
-{
-	if (!(flags & XT_OSF_GENRE))
-		xtables_error(PARAMETER_PROBLEM,
-			      "OS fingerprint match: You must specify `--genre'");
 }
 
 static void osf_print(const void *ip, const struct xt_entry_match *match, int numeric)
@@ -139,12 +101,11 @@ static struct xtables_match osf_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_osf_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_osf_info)),
 	.help		= osf_help,
-	.parse		= osf_parse,
+	.x6_parse	= osf_parse,
 	.print		= osf_print,
-	.final_check	= osf_final_check,
 	.save		= osf_save,
-	.extra_opts	= osf_opts,
-	.family		= NFPROTO_IPV4
+	.x6_options	= osf_opts,
+	.family		= NFPROTO_IPV4,
 };
 
 void _init(void)
-- 
1.7.1

