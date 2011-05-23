From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/13] libxt_rateest: use guided option parser
Date: Mon, 23 May 2011 16:39:22 +0200
Message-ID: <1306161564-4370-13-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44650 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab1EWOjk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:40 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c |  256 +++++++++++++++-----------------------------
 1 files changed, 88 insertions(+), 168 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 2244558..92b8d50 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -8,9 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_rateest.h>
 
-/* Ugly hack to pass info to final_check function. We should fix the API */
-static struct xt_rateest_match_info *rateest_info;
-
 static void rateest_help(void)
 {
 	printf(
@@ -29,8 +26,11 @@ static void rateest_help(void)
 }
 
 enum rateest_options {
+	OPT_RATEEST_A,
 	OPT_RATEEST1,
 	OPT_RATEEST2,
+	OPT_RATEEST_ABPS,
+	OPT_RATEEST_APPS,
 	OPT_RATEEST_BPS1,
 	OPT_RATEEST_PPS1,
 	OPT_RATEEST_BPS2,
@@ -41,26 +41,71 @@ enum rateest_options {
 	OPT_RATEEST_EQ,
 	OPT_RATEEST_BYTES,
 	OPT_RATEEST_PACKETS,
+	F_RATEEST_A       = 1 << OPT_RATEEST_A,
+	F_RATEEST1        = 1 << OPT_RATEEST1,
+	F_RATEEST2        = 1 << OPT_RATEEST2,
+	F_RATEEST_ABPS    = 1 << OPT_RATEEST_ABPS,
+	F_RATEEST_APPS    = 1 << OPT_RATEEST_APPS,
+	F_RATEEST_BPS1    = 1 << OPT_RATEEST_BPS1,
+	F_RATEEST_BPS2    = 1 << OPT_RATEEST_BPS2,
+	F_RATEEST_PPS1    = 1 << OPT_RATEEST_PPS1,
+	F_RATEEST_PPS2    = 1 << OPT_RATEEST_PPS2,
+	F_RATEEST_BYTES   = 1 << OPT_RATEEST_BYTES,
+	F_RATEEST_PACKETS = 1 << OPT_RATEEST_PACKETS,
 };
 
-static const struct option rateest_opts[] = {
-	{.name = "rateest1",      .has_arg = true,  .val = OPT_RATEEST1},
-	{.name = "rateest",       .has_arg = true,  .val = OPT_RATEEST1}, /* alias for absolute mode */
-	{.name = "rateest2",      .has_arg = true,  .val = OPT_RATEEST2},
-	{.name = "rateest-bps1",  .has_arg = true, .val = OPT_RATEEST_BPS1},
-	{.name = "rateest-pps1",  .has_arg = true, .val = OPT_RATEEST_PPS1},
-	{.name = "rateest-bps2",  .has_arg = true, .val = OPT_RATEEST_BPS2},
-	{.name = "rateest-pps2",  .has_arg = true, .val = OPT_RATEEST_PPS2},
-	{.name = "rateest-bps",   .has_arg = true, .val = OPT_RATEEST_BPS2}, /* alias for absolute mode */
-	{.name = "rateest-pps",   .has_arg = true, .val = OPT_RATEEST_PPS2}, /* alias for absolute mode */
-	{.name = "rateest-delta", .has_arg = false, .val = OPT_RATEEST_DELTA},
-	{.name = "rateest-lt",    .has_arg = false, .val = OPT_RATEEST_LT},
-	{.name = "rateest-gt",    .has_arg = false, .val = OPT_RATEEST_GT},
-	{.name = "rateest-eq",    .has_arg = false, .val = OPT_RATEEST_EQ},
-	{.name = "bytes",   .has_arg = false, .val = OPT_RATEEST_BYTES},
-	{.name = "packets", .has_arg = false, .val = OPT_RATEEST_PACKETS},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_rateest_match_info
+static const struct xt_option_entry rateest_opts[] = {
+	{.name = "rateest-delta", .id = OPT_RATEEST_DELTA, .type = XTTYPE_NONE},
+	{.name = "rateest-lt", .id = OPT_RATEEST_LT, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "rateest-gt", .id = OPT_RATEEST_GT, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "rateest-eq", .id = OPT_RATEEST_EQ, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+
+	{.name = "rateest", .id = OPT_RATEEST_A, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST1 | F_RATEEST2,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, name1)},
+	{.name = "rateest1", .id = OPT_RATEEST1, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST_A, .also = F_RATEEST2,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, name1)},
+	{.name = "rateest2", .id = OPT_RATEEST2, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST_A, .also = F_RATEEST1,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, name2)},
+
+	{.name = "rateest-bps", .id = OPT_RATEEST_ABPS, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST_BPS1 | F_RATEEST_BPS2 | F_RATEEST_APPS,
+	 F_RATEEST_PPS1 | F_RATEEST_PPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_A},
+	{.name = "rateest-pps", .id = OPT_RATEEST_APPS, .type = XTTYPE_UINT32,
+	 .excl = F_RATEEST_BPS1 | F_RATEEST_BPS2 | F_RATEEST_ABPS,
+	 F_RATEEST_PPS1 | F_RATEEST_PPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_A, .flags = XTOPT_PUT, XTOPT_POINTER(s, pps2)},
+	{.name = "bytes", .id = OPT_RATEEST_BYTES, .type = XTTYPE_NONE,
+	 .excl = F_RATEEST_PACKETS, .also = F_RATEEST2},
+	{.name = "packets", .id = OPT_RATEEST_PACKETS, .type = XTTYPE_NONE,
+	 .excl = F_RATEEST_BYTES, .also = F_RATEEST2},
+
+	{.name = "rateest-bps1", .id = OPT_RATEEST_BPS1, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST_ABPS | F_RATEEST_APPS | F_RATEEST_PPS1 |
+	  F_RATEEST_PPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_BPS2},
+	{.name = "rateest-bps2", .id = OPT_RATEEST_BPS2, .type = XTTYPE_STRING,
+	 .excl = F_RATEEST_ABPS | F_RATEEST_APPS | F_RATEEST_PPS1 |
+	 F_RATEEST_PPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_BPS1},
+	{.name = "rateest-pps1", .id = OPT_RATEEST_PPS1, .type = XTTYPE_UINT32,
+	 .excl = F_RATEEST_ABPS | F_RATEEST_APPS | F_RATEEST_BPS1 |
+	 F_RATEEST_BPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_PPS2, .flags = XTOPT_PUT, XTOPT_POINTER(s, pps1)},
+	{.name = "rateest-pps2", .id = OPT_RATEEST_PPS2, .type = XTTYPE_UINT32,
+	 .excl = F_RATEEST_ABPS | F_RATEEST_APPS | F_RATEEST_BPS1 |
+	 F_RATEEST_BPS2 | F_RATEEST_BYTES | F_RATEEST_PACKETS,
+	 .also = F_RATEEST_PPS1, .flags = XTOPT_PUT, XTOPT_POINTER(s, pps2)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 /* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.html */
 static const struct rate_suffix {
@@ -113,173 +158,51 @@ rateest_get_rate(uint32_t *rate, const char *str)
 	return -1;
 }
 
-static int
-rateest_parse(int c, char **argv, int invert, unsigned int *flags,
-	      const void *entry, struct xt_entry_match **match)
+static void rateest_parse(struct xt_option_call *cb)
 {
-	struct xt_rateest_match_info *info = (void *)(*match)->data;
-	unsigned int val;
-
-	rateest_info = info;
+	struct xt_rateest_match_info *info = cb->data;
 
-	switch (c) {
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
 	case OPT_RATEEST1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest1 twice");
-		*flags |= 1 << c;
-
-		strncpy(info->name1, optarg, sizeof(info->name1) - 1);
-		break;
-
 	case OPT_RATEEST2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest2 twice");
-		*flags |= 1 << c;
-
-		strncpy(info->name2, optarg, sizeof(info->name2) - 1);
 		info->flags |= XT_RATEEST_MATCH_REL;
 		break;
-
+	case OPT_RATEEST_APPS:
+	case OPT_RATEEST_PPS1:
+	case OPT_RATEEST_PPS2:
+		info->flags |= XT_RATEEST_MATCH_PPS;
+		break;
+	case OPT_RATEEST_ABPS:
 	case OPT_RATEEST_BPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest-bps can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest-bps1 twice");
-		*flags |= 1 << c;
-
 		info->flags |= XT_RATEEST_MATCH_BPS;
-
-		if (rateest_get_rate(&info->bps1, optarg) < 0)
+		if (rateest_get_rate(&info->bps1, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
-				   optarg);
-		break;
-
-	case OPT_RATEEST_PPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest-pps can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest-pps1 twice");
-		*flags |= 1 << c;
-
-		info->flags |= XT_RATEEST_MATCH_PPS;
-
-		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: could not parse pps `%s'",
-				   optarg);
-		info->pps1 = val;
-		break;
-
+				   cb->arg);
 	case OPT_RATEEST_BPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest-bps can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest-bps2 twice");
-		*flags |= 1 << c;
-
 		info->flags |= XT_RATEEST_MATCH_BPS;
-
-		if (rateest_get_rate(&info->bps2, optarg) < 0)
+		if (rateest_get_rate(&info->bps2, cb->arg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
-				   optarg);
+				   cb->arg);
 		break;
-
-	case OPT_RATEEST_PPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest-pps can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest-pps2 twice");
-		*flags |= 1 << c;
-
-		info->flags |= XT_RATEEST_MATCH_PPS;
-
-		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: could not parse pps `%s'",
-				   optarg);
-		info->pps2 = val;
-		break;
-
 	case OPT_RATEEST_DELTA:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: rateest-delta can't be inverted");
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify --rateest-delta twice");
-		*flags |= 1 << c;
-
 		info->flags |= XT_RATEEST_MATCH_DELTA;
 		break;
-
 	case OPT_RATEEST_EQ:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify lt/gt/eq twice");
-		*flags |= 1 << c;
-
 		info->mode = XT_RATEEST_MATCH_EQ;
-		if (invert)
+		if (cb->invert)
 			info->flags |= XT_RATEEST_MATCH_INVERT;
 		break;
-
 	case OPT_RATEEST_LT:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify lt/gt/eq twice");
-		*flags |= 1 << c;
-
 		info->mode = XT_RATEEST_MATCH_LT;
-		if (invert)
+		if (cb->invert)
 			info->flags |= XT_RATEEST_MATCH_INVERT;
 		break;
-
 	case OPT_RATEEST_GT:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
-		if (*flags & (1 << c))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rateest: can't specify lt/gt/eq twice");
-		*flags |= 1 << c;
-
 		info->mode = XT_RATEEST_MATCH_GT;
-		if (invert)
+		if (cb->invert)
 			info->flags |= XT_RATEEST_MATCH_INVERT;
 		break;
 
@@ -291,16 +214,13 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->flags |= XT_RATEEST_MATCH_PPS;
 		break;
 	}
-
-	return 1;
 }
 
-static void
-rateest_final_check(unsigned int flags)
+static void rateest_final_check(struct xt_fcheck_call *cb)
 {
-	struct xt_rateest_match_info *info = rateest_info;
+	struct xt_rateest_match_info *info = cb->data;
 
-	if (info == NULL)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM, "rateest match: "
 		           "you need to specify some flags");
 	if (!(info->flags & XT_RATEEST_MATCH_REL))
@@ -468,11 +388,11 @@ static struct xtables_match rateest_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
 	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
 	.help		= rateest_help,
-	.parse		= rateest_parse,
-	.final_check	= rateest_final_check,
+	.x6_parse	= rateest_parse,
+	.x6_fcheck	= rateest_final_check,
 	.print		= rateest_print,
 	.save		= rateest_save,
-	.extra_opts	= rateest_opts,
+	.x6_options	= rateest_opts,
 };
 
 void _init(void)
-- 
1.7.3.4

