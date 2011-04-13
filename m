From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/26] libxt_length: use guided option parser
Date: Wed, 13 Apr 2011 18:13:31 +0200
Message-ID: <1302711228-15947-11-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42453 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab1DMQOB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:01 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_length.c |   92 ++++++++------------------------------------
 1 files changed, 17 insertions(+), 75 deletions(-)

diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index a12aefe..4f3a331 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -1,14 +1,11 @@
-/* Shared library add-on to iptables to add packet length matching support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_length.h>
 
+enum {
+	O_LENGTH = 0,
+};
+
 static void length_help(void)
 {
 	printf(
@@ -17,75 +14,21 @@ static void length_help(void)
 "                                of values (inclusive)\n");
 }
   
-static const struct option length_opts[] = {
-	{.name = "length", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry length_opts[] = {
+	{.name = "length", .id = O_LENGTH, .type = XTTYPE_UINT16RC,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static uint16_t
-parse_length(const char *s)
-{
-	unsigned int len;
-	
-	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
-		xtables_error(PARAMETER_PROBLEM, "length invalid: \"%s\"\n", s);
-	else
-		return len;
-}
-
-/* If a single value is provided, min and max are both set to the value */
-static void
-parse_lengths(const char *s, struct xt_length_info *info)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		info->min = info->max = parse_length(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		info->min = buffer[0] ? parse_length(buffer) : 0;
-		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
-	}
-	free(buffer);
-	
-	if (info->min > info->max)
-		xtables_error(PARAMETER_PROBLEM,
-		           "length min. range value `%u' greater than max. "
-		           "range value `%u'", info->min, info->max);
-	
-}
-
-static int
-length_parse(int c, char **argv, int invert, unsigned int *flags,
-             const void *entry, struct xt_entry_match **match)
+static void length_parse(struct xt_option_call *cb)
 {
-	struct xt_length_info *info = (struct xt_length_info *)(*match)->data;
-
-	switch (c) {
-		case '1':
-			if (*flags)
-				xtables_error(PARAMETER_PROBLEM,
-				           "length: `--length' may only be "
-				           "specified once");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			parse_lengths(optarg, info);
-			if (invert)
-				info->invert = 1;
-			*flags = 1;
-			break;
-	}
-	return 1;
-}
+	struct xt_length_info *info = cb->data;
 
-static void length_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "length: You must specify `--length'");
+	xtables_option_parse(cb);
+	info->min = cb->val.u16_range[0];
+	info->max = (cb->nvals == 2) ? cb->val.u16_range[1] : UINT16_MAX;
+	if (cb->invert)
+		info->invert = 1;
 }
 
 static void
@@ -118,11 +61,10 @@ static struct xtables_match length_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
 	.help		= length_help,
-	.parse		= length_parse,
-	.final_check	= length_check,
 	.print		= length_print,
 	.save		= length_save,
-	.extra_opts	= length_opts,
+	.x6_parse	= length_parse,
+	.x6_options	= length_opts,
 };
 
 void _init(void)
-- 
1.7.1

