From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 18/28] libxt_DSCP: use guided option parser
Date: Tue, 12 Apr 2011 16:23:33 +0200
Message-ID: <1302618224-9449-19-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54674 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab1DLOYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:06 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_DSCP.c |   87 +++++++++++++------------------------------
 extensions/libxt_dscp.c |   94 ++++++++++++++---------------------------------
 2 files changed, 54 insertions(+), 127 deletions(-)

diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index db27d68..e16e93c 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -9,19 +9,21 @@
  *
  * --set-class added by Iain Barnes
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_DSCP.h>
 
 /* This is evil, but it's my code - HW*/
 #include "dscp_helper.c"
 
+enum {
+	O_SET_DSCP = 0,
+	O_SET_DSCP_CLASS,
+	F_SET_DSCP       = 1 << O_SET_DSCP,
+	F_SET_DSCP_CLASS = 1 << O_SET_DSCP_CLASS,
+};
+
 static void DSCP_help(void)
 {
 	printf(
@@ -38,68 +40,31 @@ static void DSCP_help(void)
 );
 }
 
-static const struct option DSCP_opts[] = {
-	{.name = "set-dscp",       .has_arg = true, .val = 'F'},
-	{.name = "set-dscp-class", .has_arg = true, .val = 'G'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry DSCP_opts[] = {
+	{.name = "set-dscp", .id = O_SET_DSCP, .excl = F_SET_DSCP_CLASS,
+	 .type = XTTYPE_UINT8, .min = 0, .max = XT_DSCP_MAX,
+	 .flags = XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_DSCP_info, dscp)},
+	{.name = "set-dscp-class", .id = O_SET_DSCP_CLASS, .excl = F_SET_DSCP,
+	 .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
-static void
-parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
-{
-	unsigned int dscp;
-       
-	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid dscp `%s'\n", s);
-
-	if (dscp > XT_DSCP_MAX)
-		xtables_error(PARAMETER_PROBLEM,
-			   "DSCP `%d` out of range\n", dscp);
-
-	dinfo->dscp = dscp;
-}
-
-
-static void
-parse_class(const char *s, struct xt_DSCP_info *dinfo)
-{
-	unsigned int dscp = class_to_dscp(s);
-
-	/* Assign the value */
-	dinfo->dscp = dscp;
-}
-
-
-static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_target **target)
+static void DSCP_parse(struct xt_option_call *cb)
 {
-	struct xt_DSCP_info *dinfo
-		= (struct xt_DSCP_info *)(*target)->data;
+	struct xt_DSCP_info *dinfo = cb->data;
 
-	switch (c) {
-	case 'F':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "DSCP target: Only use --set-dscp ONCE!");
-		parse_dscp(optarg, dinfo);
-		*flags = 1;
-		break;
-	case 'G':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-				   "DSCP target: Only use --set-dscp-class ONCE!");
-		parse_class(optarg, dinfo);
-		*flags = 1;
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET_DSCP_CLASS:
+		dinfo->dscp = class_to_dscp(cb->arg);
 		break;
 	}
-
-	return 1;
 }
 
-static void DSCP_check(unsigned int flags)
+static void DSCP_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "DSCP target: Parameter --set-dscp is required");
 }
@@ -134,11 +99,11 @@ static struct xtables_target dscp_target = {
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= DSCP_help,
-	.parse		= DSCP_parse,
-	.final_check	= DSCP_check,
 	.print		= DSCP_print,
 	.save		= DSCP_save,
-	.extra_opts	= DSCP_opts,
+	.x6_parse	= DSCP_parse,
+	.x6_fcheck	= DSCP_check,
+	.x6_options	= DSCP_opts,
 };
 
 void _init(void)
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index b07f83b..69533d6 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -12,19 +12,21 @@
  * http://www.iana.org/assignments/dscp-registry
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_dscp.h>
 
 /* This is evil, but it's my code - HW*/
 #include "dscp_helper.c"
 
+enum {
+	O_DSCP = 0,
+	O_DSCP_CLASS,
+	F_DSCP       = 1 << O_DSCP,
+	F_DSCP_CLASS = 1 << O_DSCP_CLASS,
+};
+
 static void dscp_help(void)
 {
 	printf(
@@ -38,76 +40,36 @@ static void dscp_help(void)
 "				These two options are mutually exclusive !\n");
 }
 
-static const struct option dscp_opts[] = {
-	{.name = "dscp",       .has_arg = true, .val = 'F'},
-	{.name = "dscp-class", .has_arg = true, .val = 'G'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry dscp_opts[] = {
+	{.name = "dscp", .id = O_DSCP, .excl = F_DSCP_CLASS,
+	 .type = XTTYPE_UINT8, .min = 0, .max = XT_DSCP_MAX,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_dscp_info, dscp)},
+	{.name = "dscp-class", .id = O_DSCP_CLASS, .excl = F_DSCP,
+	 .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
-static void
-parse_dscp(const char *s, struct xt_dscp_info *dinfo)
-{
-	unsigned int dscp;
-       
-	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
-		xtables_error(PARAMETER_PROBLEM,
-			   "Invalid dscp `%s'\n", s);
-
-	if (dscp > XT_DSCP_MAX)
-		xtables_error(PARAMETER_PROBLEM,
-			   "DSCP `%d` out of range\n", dscp);
-
-	dinfo->dscp = dscp;
-}
-
-
-static void
-parse_class(const char *s, struct xt_dscp_info *dinfo)
-{
-	unsigned int dscp = class_to_dscp(s);
-
-	/* Assign the value */
-	dinfo->dscp = dscp;
-}
-
-
-static int
-dscp_parse(int c, char **argv, int invert, unsigned int *flags,
-           const void *entry, struct xt_entry_match **match)
+static void dscp_parse(struct xt_option_call *cb)
 {
-	struct xt_dscp_info *dinfo
-		= (struct xt_dscp_info *)(*match)->data;
+	struct xt_dscp_info *dinfo = cb->data;
 
-	switch (c) {
-	case 'F':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			           "DSCP match: Only use --dscp ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_dscp(optarg, dinfo);
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_DSCP:
+		if (cb->invert)
 			dinfo->invert = 1;
-		*flags = 1;
 		break;
-
-	case 'G':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-					"DSCP match: Only use --dscp-class ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_class(optarg, dinfo);
-		if (invert)
+	case O_DSCP_CLASS:
+		dinfo->dscp = class_to_dscp(cb->arg);
+		if (cb->invert)
 			dinfo->invert = 1;
-		*flags = 1;
 		break;
 	}
-
-	return 1;
 }
 
-static void dscp_check(unsigned int flags)
+static void dscp_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "DSCP match: Parameter --dscp is required");
 }
@@ -135,11 +97,11 @@ static struct xtables_match dscp_match = {
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.help		= dscp_help,
-	.parse		= dscp_parse,
-	.final_check	= dscp_check,
 	.print		= dscp_print,
 	.save		= dscp_save,
-	.extra_opts	= dscp_opts,
+	.x6_parse	= dscp_parse,
+	.x6_fcheck	= dscp_check,
+	.x6_options	= dscp_opts,
 };
 
 void _init(void)
-- 
1.7.1

