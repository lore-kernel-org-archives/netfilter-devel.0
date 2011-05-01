From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/9] libxt_TEE: use guided option parser
Date: Sun,  1 May 2011 13:50:22 +0200
Message-ID: <1304250630-6150-3-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50002 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab1EALug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:36 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TEE.c |  103 ++++++-----------------------------------------
 1 files changed, 14 insertions(+), 89 deletions(-)

diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index 00a4de6..fd9a1b2 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -25,15 +25,19 @@
 #include <linux/netfilter/xt_TEE.h>
 
 enum {
-	FLAG_GATEWAY = 1 << 0,
-	FLAG_OIF     = 1 << 1,
+	O_GATEWAY = 0,
+	O_OIF,
 };
 
-static const struct option tee_tg_opts[] = {
-	{.name = "gateway", .has_arg = true, .val = 'g'},
-	{.name = "oif",     .has_arg = true, .val = 'o'},
-	{NULL},
+#define s struct xt_tee_tginfo
+static const struct xt_option_entry tee_tg_opts[] = {
+	{.name = "gateway", .id = O_GATEWAY, .type = XTTYPE_ONEHOST,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, gw)},
+	{.name = "oif", .id = O_OIF, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, oif)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void tee_tg_help(void)
 {
@@ -44,83 +48,6 @@ static void tee_tg_help(void)
 "\n");
 }
 
-static int tee_tg_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_target **target)
-{
-	struct xt_tee_tginfo *info = (void *)(*target)->data;
-	const struct in_addr *ia;
-
-	switch (c) {
-	case 'g':
-		if (*flags & FLAG_GATEWAY)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --gateway more than once");
-
-		ia = xtables_numeric_to_ipaddr(optarg);
-		if (ia == NULL)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Invalid IP address %s", optarg);
-
-		memcpy(&info->gw, ia, sizeof(*ia));
-		*flags |= FLAG_GATEWAY;
-		return true;
-	case 'o':
-		if (*flags & FLAG_OIF)
-			xtables_error(PARAMETER_PROBLEM,
-				"Cannot specify --oif more than once");
-		if (strlen(optarg) >= sizeof(info->oif))
-			xtables_error(PARAMETER_PROBLEM,
-				"oif name too long");
-		strcpy(info->oif, optarg);
-		*flags |= FLAG_OIF;
-		return true;
-	}
-
-	return false;
-}
-
-static int tee_tg6_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_target **target)
-{
-	struct xt_tee_tginfo *info = (void *)(*target)->data;
-	const struct in6_addr *ia;
-
-	switch (c) {
-	case 'g':
-		if (*flags & FLAG_GATEWAY)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --gateway more than once");
-
-		ia = xtables_numeric_to_ip6addr(optarg);
-		if (ia == NULL)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Invalid IP address %s", optarg);
-
-		memcpy(&info->gw, ia, sizeof(*ia));
-		*flags |= FLAG_GATEWAY;
-		return true;
-	case 'o':
-		if (*flags & FLAG_OIF)
-			xtables_error(PARAMETER_PROBLEM,
-				"Cannot specify --oif more than once");
-		if (strlen(optarg) >= sizeof(info->oif))
-			xtables_error(PARAMETER_PROBLEM,
-				"oif name too long");
-		strcpy(info->oif, optarg);
-		*flags |= FLAG_OIF;
-		return true;
-	}
-
-	return false;
-}
-
-static void tee_tg_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM, "TEE target: "
-		           "--gateway parameter required");
-}
-
 static void tee_tg_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
@@ -173,11 +100,10 @@ static struct xtables_target tee_tg_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
 	.help          = tee_tg_help,
-	.parse         = tee_tg_parse,
-	.final_check   = tee_tg_check,
 	.print         = tee_tg_print,
 	.save          = tee_tg_save,
-	.extra_opts    = tee_tg_opts,
+	.x6_parse      = xtables_option_parse,
+	.x6_options    = tee_tg_opts,
 };
 
 static struct xtables_target tee_tg6_reg = {
@@ -188,11 +114,10 @@ static struct xtables_target tee_tg6_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tee_tginfo)),
 	.help          = tee_tg_help,
-	.parse         = tee_tg6_parse,
-	.final_check   = tee_tg_check,
 	.print         = tee_tg6_print,
 	.save          = tee_tg6_save,
-	.extra_opts    = tee_tg_opts,
+	.x6_parse      = xtables_option_parse,
+	.x6_options    = tee_tg_opts,
 };
 
 void _init(void)
-- 
1.7.1

