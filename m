From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/21] libxt_hashlimit: remove inversion from hashlimit rev 0
Date: Sun, 21 Aug 2011 13:09:28 +0200
Message-ID: <1313924977-8623-14-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38759 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1HULJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:54 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Revision 0 indeed did not have inversion support, nor presence of
--hashlimit-above. This glitch was added in v1.4.11~16^2~10.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 89320bb..eb52b16 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -89,7 +89,7 @@ static void hashlimit_mt_help(void)
 #define s struct xt_hashlimit_info
 static const struct xt_option_entry hashlimit_opts[] = {
 	{.name = "hashlimit", .id = O_UPTO, .excl = F_ABOVE,
-	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT},
+	 .type = XTTYPE_STRING},
 	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_UINT32,
 	 .min = 1, .max = 10000, .flags = XTOPT_PUT,
 	 XTOPT_POINTER(s, cfg.burst)},
@@ -251,19 +251,10 @@ static void hashlimit_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_UPTO:
-		if (cb->invert)
-			info->cfg.mode |= XT_HASHLIMIT_INVERT;
 		if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-upto", cb->arg);
 		break;
-	case O_ABOVE:
-		if (!cb->invert)
-			info->cfg.mode |= XT_HASHLIMIT_INVERT;
-		if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
-			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
-			          "--hashlimit-above", cb->arg);
-		break;
 	case O_MODE:
 		if (parse_mode(&info->cfg.mode, cb->arg) < 0)
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
@@ -529,7 +520,7 @@ static struct xtables_match hashlimit_mt_reg[] = {
 		.x6_fcheck     = hashlimit_check,
 		.print         = hashlimit_print,
 		.save          = hashlimit_save,
-		.x6_options    = hashlimit_mt_opts,
+		.x6_options    = hashlimit_opts,
 		.udata_size    = sizeof(struct hashlimit_mt_udata),
 	},
 	{
-- 
1.7.3.4

