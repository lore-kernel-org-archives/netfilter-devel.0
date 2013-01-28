From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] Add the "NOTRACK" alias to the "CT" target
Date: Mon, 28 Jan 2013 21:32:55 +0100
Message-ID: <1359405175-4394-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49366 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3A1Ujl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:39:41 -0500
In-Reply-To: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 extensions/libxt_CT.c           |   48 +++++++++++++++++++++++++++++++++++++++
 extensions/libxt_NOTRACK.man    |    4 +-
 include/linux/netfilter/xt_CT.h |    5 +++-
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index a576a95..dbafea9 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -191,6 +191,10 @@ ct_print_v1(const void *ip, const struct xt_entry_target *target, int numeric)
 	const struct xt_ct_target_info_v1 *info =
 		(const struct xt_ct_target_info_v1 *)target->data;
 
+	if (info->flags & XT_CT_NOTRACK_ALIAS) {
+		printf (" NOTRACK");
+		return;
+	}
 	printf(" CT");
 	if (info->flags & XT_CT_NOTRACK)
 		printf(" notrack");
@@ -213,6 +217,8 @@ static void ct_save(const void *ip, const struct xt_entry_target *target)
 	const struct xt_ct_target_info *info =
 		(const struct xt_ct_target_info *)target->data;
 
+	if (info->flags & XT_CT_NOTRACK_ALIAS)
+		return;
 	if (info->flags & XT_CT_NOTRACK)
 		printf(" --notrack");
 	if (info->helper[0])
@@ -232,6 +238,8 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 	const struct xt_ct_target_info_v1 *info =
 		(const struct xt_ct_target_info_v1 *)target->data;
 
+	if (info->flags & XT_CT_NOTRACK_ALIAS)
+		return;
 	if (info->flags & XT_CT_NOTRACK)
 		printf(" --notrack");
 	if (info->helper[0])
@@ -248,6 +256,14 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 		printf(" --zone %u", info->zone);
 }
 
+static const char *
+ct_print_name_alias(const struct xt_entry_target *target)
+{
+	struct xt_ct_target_info *info = (void *)target->data;
+
+	return info->flags & XT_CT_NOTRACK_ALIAS ? "NOTRACK" : "CT";
+}
+
 static void notrack_ct0_tg_init(struct xt_entry_target *target)
 {
 	struct xt_ct_target_info *info = (void *)target->data;
@@ -262,6 +278,13 @@ static void notrack_ct1_tg_init(struct xt_entry_target *target)
 	info->flags = XT_CT_NOTRACK;
 }
 
+static void notrack_ct2_tg_init(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info_v1 *info = (void *)target->data;
+
+	info->flags = XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS;
+}
+
 static struct xtables_target ct_target_reg[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -289,6 +312,20 @@ static struct xtables_target ct_target_reg[] = {
 		.x6_options	= ct_opts_v1,
 	},
 	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "CT",
+		.revision	= 2,
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
+		.userspacesize	= offsetof(struct xt_ct_target_info_v1, ct),
+		.help		= ct_help_v1,
+		.print		= ct_print_v1,
+		.save		= ct_save_v1,
+		.alias		= ct_print_name_alias,
+		.x6_parse	= ct_parse_v1,
+		.x6_options	= ct_opts_v1,
+	},
+	{
 		.family        = NFPROTO_UNSPEC,
 		.name          = "NOTRACK",
 		.real_name     = "CT",
@@ -311,6 +348,17 @@ static struct xtables_target ct_target_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
 		.name          = "NOTRACK",
+		.real_name     = "CT",
+		.revision      = 2,
+		.ext_flags     = XTABLES_EXT_ALIAS,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
+		.userspacesize = offsetof(struct xt_ct_target_info_v1, ct),
+		.init          = notrack_ct2_tg_init,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "NOTRACK",
 		.revision      = 0,
 		.version       = XTABLES_VERSION,
 	},
diff --git a/extensions/libxt_NOTRACK.man b/extensions/libxt_NOTRACK.man
index 633b965..4302b93 100644
--- a/extensions/libxt_NOTRACK.man
+++ b/extensions/libxt_NOTRACK.man
@@ -1,3 +1,3 @@
-This target disables connection tracking for all packets matching that rule.
-It is obsoleted by \-j CT \-\-notrack. Like CT, NOTRACK can only be used in
+This extension disables connection tracking for all packets matching that rule.
+It is equivalent with \-j CT \-\-notrack. Like CT, NOTRACK can only be used in
 the \fBraw\fP table.
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index a064b8a..54528fd 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -3,7 +3,10 @@
 
 #include <linux/types.h>
 
-#define XT_CT_NOTRACK	0x1
+enum {
+	XT_CT_NOTRACK		= 1 << 0,
+	XT_CT_NOTRACK_ALIAS	= 1 << 1,
+};
 
 struct xt_ct_target_info {
 	__u16 flags;
-- 
1.7.0.4

