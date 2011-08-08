From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] extensions: use multi-target registration
Date: Mon,  8 Aug 2011 02:42:17 +0200
Message-ID: <1312764144-23849-2-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44403 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1HHAm2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:28 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPMSS.c |   56 ++++++++++++++++++++++----------------------
 extensions/libxt_TEE.c    |   56 ++++++++++++++++++++++----------------------
 2 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 2266326..48ab044 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -91,36 +91,36 @@ static void TCPMSS_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --set-mss %u", mssinfo->mss);
 }
 
-static struct xtables_target tcpmss_target = {
-	.family		= NFPROTO_IPV4,
-	.name		= "TCPMSS",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.help		= TCPMSS_help,
-	.print		= TCPMSS_print,
-	.save		= TCPMSS_save,
-	.x6_parse	= TCPMSS_parse,
-	.x6_fcheck	= TCPMSS_check,
-	.x6_options	= TCPMSS4_opts,
-};
-
-static struct xtables_target tcpmss_target6 = {
-	.family		= NFPROTO_IPV6,
-	.name		= "TCPMSS",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.help		= TCPMSS_help6,
-	.print		= TCPMSS_print,
-	.save		= TCPMSS_save,
-	.x6_parse	= TCPMSS_parse,
-	.x6_fcheck	= TCPMSS_check,
-	.x6_options	= TCPMSS6_opts,
+static struct xtables_target tcpmss_tg_reg[] = {
+	{
+		.family        = NFPROTO_IPV4,
+		.name          = "TCPMSS",
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+		.help          = TCPMSS_help,
+		.print         = TCPMSS_print,
+		.save          = TCPMSS_save,
+		.x6_parse      = TCPMSS_parse,
+		.x6_fcheck     = TCPMSS_check,
+		.x6_options    = TCPMSS4_opts,
+	},
+	{
+		.family        = NFPROTO_IPV6,
+		.name          = "TCPMSS",
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tcpmss_info)),
+		.help          = TCPMSS_help6,
+		.print         = TCPMSS_print,
+		.save          = TCPMSS_save,
+		.x6_parse      = TCPMSS_parse,
+		.x6_fcheck     = TCPMSS_check,
+		.x6_options    = TCPMSS6_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&tcpmss_target);
-	xtables_register_target(&tcpmss_target6);
+	xtables_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index c89e580..92c7601 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -92,36 +92,36 @@ static void tee_tg6_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --oif %s", info->oif);
 }
 
-static struct xtables_target tee_tg_reg = {
-	.name          = "TEE",
-	.version       = XTABLES_VERSION,
-	.revision      = 1,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-	.help          = tee_tg_help,
-	.print         = tee_tg_print,
-	.save          = tee_tg_save,
-	.x6_parse      = xtables_option_parse,
-	.x6_options    = tee_tg_opts,
-};
-
-static struct xtables_target tee_tg6_reg = {
-	.name          = "TEE",
-	.version       = XTABLES_VERSION,
-	.revision      = 1,
-	.family        = NFPROTO_IPV6,
-	.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
-	.help          = tee_tg_help,
-	.print         = tee_tg6_print,
-	.save          = tee_tg6_save,
-	.x6_parse      = xtables_option_parse,
-	.x6_options    = tee_tg_opts,
+static struct xtables_target tee_tg_reg[] = {
+	{
+		.name          = "TEE",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.help          = tee_tg_help,
+		.print         = tee_tg_print,
+		.save          = tee_tg_save,
+		.x6_parse      = xtables_option_parse,
+		.x6_options    = tee_tg_opts,
+	},
+	{
+		.name          = "TEE",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
+		.help          = tee_tg_help,
+		.print         = tee_tg6_print,
+		.save          = tee_tg6_save,
+		.x6_parse      = xtables_option_parse,
+		.x6_options    = tee_tg_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&tee_tg_reg);
-	xtables_register_target(&tee_tg6_reg);
+	xtables_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
 }
-- 
1.7.3.4

