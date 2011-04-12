From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 22/28] libxt_comment: use guided option parser
Date: Tue, 12 Apr 2011 16:23:37 +0200
Message-ID: <1302618224-9449-23-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54688 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab1DLOYK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:10 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_comment.c |   61 ++++++++------------------------------------
 1 files changed, 11 insertions(+), 50 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index c10a254..6ed2ff9 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -6,15 +6,14 @@
  *     2004-05-12: Brad Fisher <brad@info-link.net>
  *         Port to patch-o-matic-ng
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_comment.h>
 
+enum {
+	O_COMMENT = 0,
+};
+
 static void comment_help(void)
 {
 	printf(
@@ -22,51 +21,14 @@ static void comment_help(void)
 		"--comment COMMENT             Attach a comment to a rule\n");
 }
 
-static const struct option comment_opts[] = {
-	{.name = "comment", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry comment_opts[] = {
+	{.name = "comment", .id = O_COMMENT, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_comment_info, comment)},
+	XTOPT_TABLEEND,
 };
 
 static void
-parse_comment(const char *s, struct xt_comment_info *info)
-{	
-	int slen = strlen(s);
-
-	if (slen >= XT_MAX_COMMENT_LEN) {
-		xtables_error(PARAMETER_PROBLEM,
-			"COMMENT must be shorter than %i characters", XT_MAX_COMMENT_LEN);
-	}
-	strcpy((char *)info->comment, s);
-}
-
-static int
-comment_parse(int c, char **argv, int invert, unsigned int *flags,
-              const void *entry, struct xt_entry_match **match)
-{
-	struct xt_comment_info *commentinfo = (struct xt_comment_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert) {
-			xtables_error(PARAMETER_PROBLEM,
-					"Sorry, you can't have an inverted comment");
-		}
-		parse_comment(optarg, commentinfo);
-		*flags = 1;
-		break;
-	}
-	return 1;
-}
-
-static void comment_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "COMMENT match: You must specify `--comment'");
-}
-
-static void
 comment_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_comment_info *commentinfo = (void *)match->data;
@@ -93,11 +55,10 @@ static struct xtables_match comment_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.help		= comment_help,
-	.parse		= comment_parse,
-	.final_check	= comment_check,
 	.print 		= comment_print,
 	.save 		= comment_save,
-	.extra_opts	= comment_opts,
+	.x6_parse	= xtables_option_parse,
+	.x6_options	= comment_opts,
 };
 
 void _init(void)
-- 
1.7.1

