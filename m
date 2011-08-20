From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] libxt_set: put differing variable names in directly
Date: Sat, 20 Aug 2011 21:24:52 +0200
Message-ID: <1313868294-21471-6-git-send-email-jengelh@medozas.de>
References: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40069 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab1HTTZE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:25:04 -0400
In-Reply-To: <1313868294-21471-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_SET.c |   13 +++----------
 extensions/libxt_set.c |   11 +++--------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index 0446603..a11db39 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -143,9 +143,6 @@ set_target_save_v0(const void *ip, const struct xt_entry_target *target)
 }
 
 /* Revision 1 */
-
-#define set_target_help_v1	set_target_help_v0
-
 static void
 set_target_init_v1(struct xt_entry_target *target)
 {
@@ -204,8 +201,6 @@ set_target_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-#define set_target_check_v1	set_target_check_v0
-
 static void
 print_target(const char *prefix, const struct xt_set_info *info)
 {
@@ -242,8 +237,6 @@ set_target_save_v1(const void *ip, const struct xt_entry_target *target)
 	print_target("--del-set", &info->del_set);
 }
 
-#define set_target_opts_v1	set_target_opts_v0
-
 /* Revision 2 */
 
 static void
@@ -376,13 +369,13 @@ static struct xtables_target set_tg_reg[] = {
 		.family		= NFPROTO_UNSPEC,
 		.size		= XT_ALIGN(sizeof(struct xt_set_info_target_v1)),
 		.userspacesize	= XT_ALIGN(sizeof(struct xt_set_info_target_v1)),
-		.help		= set_target_help_v1,
+		.help		= set_target_help_v0,
 		.init		= set_target_init_v1,
 		.parse		= set_target_parse_v1,
-		.final_check	= set_target_check_v1,
+		.final_check	= set_target_check_v0,
 		.print		= set_target_print_v1,
 		.save		= set_target_save_v1,
-		.extra_opts	= set_target_opts_v1,
+		.extra_opts	= set_target_opts_v0,
 	},
 	{
 		.name		= "SET",
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 6b39147..77e3f07 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -128,11 +128,6 @@ set_save_v0(const void *ip, const struct xt_entry_match *match)
 }
 
 /* Revision 1 */
-
-#define set_help_v1	set_help_v0
-#define set_opts_v1	set_opts_v0
-#define set_check_v1	set_check_v0
-
 static int
 set_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	     const void *entry, struct xt_entry_match **match)
@@ -232,12 +227,12 @@ static struct xtables_match set_mt_reg[] = {
 		.family		= NFPROTO_UNSPEC,
 		.size		= XT_ALIGN(sizeof(struct xt_set_info_match_v1)),
 		.userspacesize	= XT_ALIGN(sizeof(struct xt_set_info_match_v1)),
-		.help		= set_help_v1,
+		.help		= set_help_v0,
 		.parse		= set_parse_v1,
-		.final_check	= set_check_v1,
+		.final_check	= set_check_v0,
 		.print		= set_print_v1,
 		.save		= set_save_v1,
-		.extra_opts	= set_opts_v1,
+		.extra_opts	= set_opts_v0,
 	},
 };
 
-- 
1.7.3.4

