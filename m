From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] libxt_tos: use guided option parser
Date: Sun,  1 May 2011 13:50:25 +0200
Message-ID: <1304250630-6150-6-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50014 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab1EALuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:39 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tos.c |   88 ++++++++++++++++++------------------------------
 1 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 8b83e18..7646a4f 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -21,12 +21,19 @@ struct ipt_tos_info {
 };
 
 enum {
-	FLAG_TOS = 1 << 0,
+	O_TOS = 1 << 0,
 };
 
-static const struct option tos_mt_opts[] = {
-	{.name = "tos", .has_arg = true, .val = 't'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry tos_mt_opts_v0[] = {
+	{.name = "tos", .id = O_TOS, .type = XTTYPE_TOSMASK,
+	 .flags = XTOPT_MAND, .max = 0xFF},
+	XTOPT_TABLEEND,
+};
+
+static const struct xt_option_entry tos_mt_opts[] = {
+	{.name = "tos", .id = O_TOS, .type = XTTYPE_TOSMASK,
+	 .flags = XTOPT_MAND, .max = 0x3F},
+	XTOPT_TABLEEND,
 };
 
 static void tos_mt_help(void)
@@ -46,56 +53,29 @@ static void tos_mt_help(void)
 	printf("\n");
 }
 
-static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_match **match)
+static void tos_mt_parse_v0(struct xt_option_call *cb)
 {
-	struct ipt_tos_info *info = (void *)(*match)->data;
-	struct tos_value_mask tvm;
-
-	switch (c) {
-	case 't':
-		xtables_param_act(XTF_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
-		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
-			xtables_param_act(XTF_BAD_VALUE, "tos", "--tos", optarg);
-		if (tvm.mask != 0xFF)
-			xtables_error(PARAMETER_PROBLEM, "tos: Your kernel is "
-			           "too old to support anything besides /0xFF "
-				   "as a mask.");
-		info->tos = tvm.value;
-		if (invert)
-			info->invert = true;
-		*flags |= FLAG_TOS;
-		return true;
-	}
-	return false;
+	struct ipt_tos_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	if (cb->val.tos_mask != 0xFF)
+		xtables_error(PARAMETER_PROBLEM, "tos: Your kernel is "
+		           "too old to support anything besides /0xFF "
+			   "as a mask.");
+	info->tos = cb->val.tos_value;
+	if (cb->invert)
+		info->invert = true;
 }
 
-static int tos_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_match **match)
+static void tos_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_tos_match_info *info = (void *)(*match)->data;
-	struct tos_value_mask tvm = {.mask = 0xFF};
-
-	switch (c) {
-	case 't':
-		xtables_param_act(XTF_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
-		if (!tos_parse_symbolic(optarg, &tvm, 0x3F))
-			xtables_param_act(XTF_BAD_VALUE, "tos", "--tos", optarg);
-		info->tos_value = tvm.value;
-		info->tos_mask  = tvm.mask;
-		if (invert)
-			info->invert = true;
-		*flags |= FLAG_TOS;
-		return true;
-	}
-	return false;
-}
+	struct xt_tos_match_info *info = cb->data;
 
-static void tos_mt_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-		           "tos: --tos parameter required");
+	xtables_option_parse(cb);
+	info->tos_value = cb->val.tos_value;
+	info->tos_mask  = cb->val.tos_mask;
+	if (cb->invert)
+		info->invert = true;
 }
 
 static void tos_mt_print_v0(const void *ip, const struct xt_entry_match *match,
@@ -150,11 +130,10 @@ static struct xtables_match tos_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct ipt_tos_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct ipt_tos_info)),
 		.help          = tos_mt_help,
-		.parse         = tos_mt_parse_v0,
-		.final_check   = tos_mt_check,
 		.print         = tos_mt_print_v0,
 		.save          = tos_mt_save_v0,
-		.extra_opts    = tos_mt_opts,
+		.x6_parse      = tos_mt_parse_v0,
+		.x6_options    = tos_mt_opts_v0,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -164,11 +143,10 @@ static struct xtables_match tos_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_tos_match_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_tos_match_info)),
 		.help          = tos_mt_help,
-		.parse         = tos_mt_parse,
-		.final_check   = tos_mt_check,
 		.print         = tos_mt_print,
 		.save          = tos_mt_save,
-		.extra_opts    = tos_mt_opts,
+		.x6_parse      = tos_mt_parse,
+		.x6_options    = tos_mt_opts,
 	},
 };
 
-- 
1.7.1

