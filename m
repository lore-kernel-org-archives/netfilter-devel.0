From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/28] libipt_ECN: use guided option parser
Date: Tue, 12 Apr 2011 16:23:29 +0200
Message-ID: <1302618224-9449-15-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54661 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1DLOYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:01 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_ECN.c |   95 ++++++++++++++++++----------------------------
 extensions/libipt_ecn.c |   82 +++++++++++++++-------------------------
 2 files changed, 68 insertions(+), 109 deletions(-)

diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 2aa1a00..ee09f29 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -6,15 +6,20 @@
  *
  * libipt_ECN.c borrowed heavily from libipt_DSCP.c
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
+enum {
+	O_ECN_TCP_REMOVE = 0,
+	O_ECN_TCP_CWR,
+	O_ECN_TCP_ECE,
+	O_ECN_IP_ECT,
+	F_ECN_TCP_REMOVE = 1 << O_ECN_TCP_REMOVE,
+	F_ECN_TCP_CWR    = 1 << O_ECN_TCP_CWR,
+	F_ECN_TCP_ECE    = 1 << O_ECN_TCP_ECE,
+};
+
 static void ECN_help(void)
 {
 	printf(
@@ -29,73 +34,47 @@ static void ECN_help(void)
 "  --ecn-tcp-ece		Set the IPv4 ECE bit (0 or 1)\n",
 #endif
 
-
-static const struct option ECN_opts[] = {
-	{.name = "ecn-tcp-remove", .has_arg = false, .val = 'F'},
-	{.name = "ecn-tcp-cwr",    .has_arg = true,  .val = 'G'},
-	{.name = "ecn-tcp-ece",    .has_arg = true,  .val = 'H'},
-	{.name = "ecn-ip-ect",     .has_arg = true,  .val = '9'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry ECN_opts[] = {
+	{.name = "ecn-tcp-remove", .id = O_ECN_TCP_REMOVE, .type = XTTYPE_NONE,
+	 .excl = F_ECN_TCP_CWR | F_ECN_TCP_ECE},
+	{.name = "ecn-tcp-cwr", .id = O_ECN_TCP_CWR, .type = XTTYPE_UINT8,
+	 .min = 0, .max = 1, .excl = F_ECN_TCP_REMOVE},
+	{.name = "ecn-tcp-ece", .id = O_ECN_TCP_ECE, .type = XTTYPE_UINT8,
+	 .min = 0, .max = 1, .excl = F_ECN_TCP_REMOVE},
+	{.name = "ecn-ip-ect", .id = O_ECN_IP_ECT, .type = XTTYPE_UINT8,
+	 .min = 0, .max = 3},
+	XTOPT_TABLEEND,
 };
 
-static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
+static void ECN_parse(struct xt_option_call *cb)
 {
-	unsigned int result;
-	struct ipt_ECN_info *einfo
-		= (struct ipt_ECN_info *)(*target)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-			        "ECN target: Only use --ecn-tcp-remove ONCE!");
+	struct ipt_ECN_info *einfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_ECN_TCP_REMOVE:
 		einfo->operation = IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR;
 		einfo->proto.tcp.ece = 0;
 		einfo->proto.tcp.cwr = 0;
-		*flags |= IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR;
 		break;
-	case 'G':
-		if (*flags & IPT_ECN_OP_SET_CWR)
-			xtables_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-tcp-cwr ONCE!");
-		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN target: Value out of range");
+	case O_ECN_TCP_CWR:
 		einfo->operation |= IPT_ECN_OP_SET_CWR;
-		einfo->proto.tcp.cwr = result;
-		*flags |= IPT_ECN_OP_SET_CWR;
+		einfo->proto.tcp.cwr = cb->val.u8;
 		break;
-	case 'H':
-		if (*flags & IPT_ECN_OP_SET_ECE)
-			xtables_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-tcp-ece ONCE!");
-		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN target: Value out of range");
+	case O_ECN_TCP_ECE:
 		einfo->operation |= IPT_ECN_OP_SET_ECE;
-		einfo->proto.tcp.ece = result;
-		*flags |= IPT_ECN_OP_SET_ECE;
+		einfo->proto.tcp.ece = cb->val.u8;
 		break;
-	case '9':
-		if (*flags & IPT_ECN_OP_SET_IP)
-			xtables_error(PARAMETER_PROBLEM,
-				"ECN target: Only use --ecn-ip-ect ONCE!");
-		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN target: Value out of range");
+	case O_ECN_IP_ECT:
 		einfo->operation |= IPT_ECN_OP_SET_IP;
-		einfo->ip_ect = result;
-		*flags |= IPT_ECN_OP_SET_IP;
+		einfo->ip_ect = cb->val.u8;
 		break;
 	}
-
-	return 1;
 }
 
-static void ECN_check(unsigned int flags)
+static void ECN_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "ECN target: An operation is required");
 }
@@ -153,11 +132,11 @@ static struct xtables_target ecn_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.help		= ECN_help,
-	.parse		= ECN_parse,
-	.final_check	= ECN_check,
 	.print		= ECN_print,
 	.save		= ECN_save,
-	.extra_opts	= ECN_opts,
+	.x6_parse	= ECN_parse,
+	.x6_fcheck	= ECN_check,
+	.x6_options	= ECN_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index d6b521f..56a0347 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -7,15 +7,16 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
+enum {
+	O_ECN_TCP_CWR = 0,
+	O_ECN_TCP_ECE,
+	O_ECN_IP_ECT,
+};
+
 static void ecn_help(void)
 {
 	printf(
@@ -25,65 +26,44 @@ static void ecn_help(void)
 "[!] --ecn-ip-ect [0..3]	Match ECN codepoint in IPv4 header\n");
 }
 
-static const struct option ecn_opts[] = {
-	{.name = "ecn-tcp-cwr", .has_arg = false, .val = 'F'},
-	{.name = "ecn-tcp-ece", .has_arg = false, .val = 'G'},
-	{.name = "ecn-ip-ect",  .has_arg = true,  .val = 'H'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry ecn_opts[] = {
+	{.name = "ecn-tcp-cwr", .id = O_ECN_TCP_CWR, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "ecn-tcp-ece", .id = O_ECN_TCP_ECE, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "ecn-ip-ect", .id = O_ECN_IP_ECT, .type = XTTYPE_UINT8,
+	 .min = 0, .max = 3, .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
-static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_match **match)
+static void ecn_parse(struct xt_option_call *cb)
 {
-	unsigned int result;
-	struct ipt_ecn_info *einfo
-		= (struct ipt_ecn_info *)(*match)->data;
-
-	switch (c) {
-	case 'F':
-		if (*flags & IPT_ECN_OP_MATCH_CWR)
-			xtables_error(PARAMETER_PROBLEM,
-			           "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	struct ipt_ecn_info *einfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_ECN_TCP_CWR:
 		einfo->operation |= IPT_ECN_OP_MATCH_CWR;
-		if (invert)
+		if (cb->invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_CWR;
-		*flags |= IPT_ECN_OP_MATCH_CWR;
 		break;
-
-	case 'G':
-		if (*flags & IPT_ECN_OP_MATCH_ECE)
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_ECN_TCP_ECE:
 		einfo->operation |= IPT_ECN_OP_MATCH_ECE;
-		if (invert)
+		if (cb->invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_ECE;
-		*flags |= IPT_ECN_OP_MATCH_ECE;
 		break;
-
-	case 'H':
-		if (*flags & IPT_ECN_OP_MATCH_IP)
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
+	case O_ECN_IP_ECT:
+		if (cb->invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_IP;
-		*flags |= IPT_ECN_OP_MATCH_IP;
 		einfo->operation |= IPT_ECN_OP_MATCH_IP;
-		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
-			xtables_error(PARAMETER_PROBLEM,
-				   "ECN match: Value out of range");
-		einfo->ip_ect = result;
+		einfo->ip_ect = cb->val.u8;
 		break;
 	}
-
-	return 1;
 }
 
-static void ecn_check(unsigned int flags)
+static void ecn_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 		           "ECN match: some option required");
 }
@@ -144,11 +124,11 @@ static struct xtables_match ecn_mt_reg = {
 	.size          = XT_ALIGN(sizeof(struct ipt_ecn_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_ecn_info)),
 	.help          = ecn_help,
-	.parse         = ecn_parse,
-	.final_check   = ecn_check,
 	.print         = ecn_print,
 	.save          = ecn_save,
-	.extra_opts    = ecn_opts,
+	.x6_parse      = ecn_parse,
+	.x6_fcheck     = ecn_check,
+	.x6_options    = ecn_opts,
 };
 
 void _init(void)
-- 
1.7.1

