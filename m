From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] libxt_conntrack: restore network-byte order for v1,v2
Date: Sun, 10 Jul 2011 20:22:17 +0200
Message-ID: <1310322139-28505-6-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58443 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1GJSW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:26 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/632804
References: http://marc.info/?l=netfilter-devel&m=130999299016674&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   46 +++++++++++++++++++++++++++++++++++------
 1 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index e1d8575..96400a1 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -110,9 +110,41 @@ static const struct xt_option_entry conntrack_mt_opts_v0[] = {
 };
 #undef s
 
+#define s struct xt_conntrack_mtinfo2 /* for v1-v2 */
+/* We exploit the fact that v1-v2 share the same layout */
+static const struct xt_option_entry conntrack2_mt_opts[] = {
+	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctorigsrc", .id = O_CTORIGSRC, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctorigdst", .id = O_CTORIGDST, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctreplsrc", .id = O_CTREPLSRC, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctrepldst", .id = O_CTREPLDST, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctstatus", .id = O_CTSTATUS, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctexpire", .id = O_CTEXPIRE, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT},
+	{.name = "ctorigsrcport", .id = O_CTORIGSRCPORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_NBO},
+	{.name = "ctorigdstport", .id = O_CTORIGDSTPORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_NBO},
+	{.name = "ctreplsrcport", .id = O_CTREPLSRCPORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_NBO},
+	{.name = "ctrepldstport", .id = O_CTREPLDSTPORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_NBO},
+	{.name = "ctdir", .id = O_CTDIR, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
+};
+#undef s
+
 #define s struct xt_conntrack_mtinfo3 /* for v1-v3 */
 /* We exploit the fact that v1-v3 share the same layout */
-static const struct xt_option_entry conntrack_mt_opts[] = {
+static const struct xt_option_entry conntrack3_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "ctproto", .id = O_CTPROTO, .type = XTTYPE_PROTOCOL,
@@ -992,7 +1024,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt4_print,
 		.save          = conntrack1_mt4_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack2_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1006,7 +1038,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt6_print,
 		.save          = conntrack1_mt6_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack2_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1020,7 +1052,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt_print,
 		.save          = conntrack2_mt_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack2_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1034,7 +1066,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt6_print,
 		.save          = conntrack2_mt6_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack2_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1048,7 +1080,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt_print,
 		.save          = conntrack3_mt_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack3_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -1062,7 +1094,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt6_print,
 		.save          = conntrack3_mt6_save,
-		.x6_options    = conntrack_mt_opts,
+		.x6_options    = conntrack3_mt_opts,
 	},
 };
 
-- 
1.7.3.4

