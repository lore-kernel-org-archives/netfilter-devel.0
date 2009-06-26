From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] extensions: collapse data variables to use multi-reg calls
Date: Fri, 26 Jun 2009 21:19:50 +0200
Message-ID: <1246043992-379-9-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39675 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761321AbZFZTUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:13 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_addrtype.c |   58 ++++++++++----------
 extensions/libxt_CONNMARK.c  |   64 +++++++++++-----------
 extensions/libxt_MARK.c      |   90 +++++++++++++++----------------
 extensions/libxt_TOS.c       |   60 ++++++++++----------
 extensions/libxt_connlimit.c |   60 ++++++++++----------
 extensions/libxt_connmark.c  |   60 ++++++++++----------
 extensions/libxt_conntrack.c |   90 +++++++++++++++----------------
 extensions/libxt_hashlimit.c |   96 ++++++++++++++++-----------------
 extensions/libxt_iprange.c   |   90 +++++++++++++++----------------
 extensions/libxt_mark.c      |   60 ++++++++++----------
 extensions/libxt_multiport.c |  120 ++++++++++++++++++++----------------------
 extensions/libxt_owner.c     |   90 +++++++++++++++----------------
 extensions/libxt_policy.c    |   56 ++++++++++----------
 extensions/libxt_string.c    |   64 +++++++++++-----------
 extensions/libxt_tos.c       |   60 ++++++++++----------
 15 files changed, 552 insertions(+), 566 deletions(-)

diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index ecd51b5..cda7051 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -323,38 +323,38 @@ static const struct option addrtype_opts_v1[] = {
 	{ .name = NULL }
 };
 
-static struct xtables_match addrtype_mt_reg_v0 = {
-	.name 		= "addrtype",
-	.version 	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.help 		= addrtype_help_v0,
-	.parse 		= addrtype_parse_v0,
-	.final_check 	= addrtype_check_v0,
-	.print 		= addrtype_print_v0,
-	.save 		= addrtype_save_v0,
-	.extra_opts 	= addrtype_opts_v0,
-};
-
-static struct xtables_match addrtype_mt_reg_v1 = {
-	.name 		= "addrtype",
-	.version 	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
-	.help 		= addrtype_help_v1,
-	.parse 		= addrtype_parse_v1,
-	.final_check 	= addrtype_check_v1,
-	.print 		= addrtype_print_v1,
-	.save 		= addrtype_save_v1,
-	.extra_opts 	= addrtype_opts_v1,
-	.revision	= 1,
+static struct xtables_match addrtype_mt_reg[] = {
+	{
+		.name          = "addrtype",
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info)),
+		.help          = addrtype_help_v0,
+		.parse         = addrtype_parse_v0,
+		.final_check   = addrtype_check_v0,
+		.print         = addrtype_print_v0,
+		.save          = addrtype_save_v0,
+		.extra_opts    = addrtype_opts_v0,
+	},
+	{
+		.name          = "addrtype",
+		.revision      = 1,
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
+		.help          = addrtype_help_v1,
+		.parse         = addrtype_parse_v1,
+		.final_check   = addrtype_check_v1,
+		.print         = addrtype_print_v1,
+		.save          = addrtype_save_v1,
+		.extra_opts    = addrtype_opts_v1,
+	},
 };
 
 
 void _init(void) 
 {
-	xtables_register_match(&addrtype_mt_reg_v0);
-	xtables_register_match(&addrtype_mt_reg_v1);
+	xtables_register_matches(addrtype_mt_reg, ARRAY_SIZE(addrtype_mt_reg));
 }
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 5e9c374..3cf62f0 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -398,40 +398,40 @@ connmark_tg_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static struct xtables_target connmark_target = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "CONNMARK",
-	.revision	= 0,
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
-	.help		= CONNMARK_help,
-	.init           = CONNMARK_init,
-	.parse		= CONNMARK_parse,
-	.final_check	= connmark_tg_check,
-	.print		= CONNMARK_print,
-	.save		= CONNMARK_save,
-	.extra_opts	= CONNMARK_opts,
-};
-
-static struct xtables_target connmark_tg_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "CONNMARK",
-	.revision       = 1,
-	.family         = NFPROTO_UNSPEC,
-	.size           = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
-	.help           = connmark_tg_help,
-	.init           = connmark_tg_init,
-	.parse          = connmark_tg_parse,
-	.final_check    = connmark_tg_check,
-	.print          = connmark_tg_print,
-	.save           = connmark_tg_save,
-	.extra_opts     = connmark_tg_opts,
+static struct xtables_target connmark_tg_reg[] = {
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "CONNMARK",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_target_info)),
+		.help          = CONNMARK_help,
+		.init          = CONNMARK_init,
+		.parse         = CONNMARK_parse,
+		.final_check   = connmark_tg_check,
+		.print         = CONNMARK_print,
+		.save          = CONNMARK_save,
+		.extra_opts    = CONNMARK_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "CONNMARK",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
+		.help          = connmark_tg_help,
+		.init          = connmark_tg_init,
+		.parse         = connmark_tg_parse,
+		.final_check   = connmark_tg_check,
+		.print         = connmark_tg_print,
+		.save          = connmark_tg_save,
+		.extra_opts    = connmark_tg_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&connmark_target);
-	xtables_register_target(&connmark_tg_reg);
+	xtables_register_targets(connmark_tg_reg, ARRAY_SIZE(connmark_tg_reg));
 }
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index cab052b..f6a2c5c 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -277,54 +277,52 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf("--set-xmark 0x%x/0x%x ", info->mark, info->mask);
 }
 
-static struct xtables_target mark_target_v0 = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "MARK",
-	.version	= XTABLES_VERSION,
-	.revision	= 0,
-	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
-	.help		= MARK_help,
-	.parse		= MARK_parse_v0,
-	.final_check	= MARK_check,
-	.print		= MARK_print_v0,
-	.save		= MARK_save_v0,
-	.extra_opts	= MARK_opts,
-};
-
-static struct xtables_target mark_target_v1 = {
-	.family		= NFPROTO_IPV4,
-	.name		= "MARK",
-	.version	= XTABLES_VERSION,
-	.revision	= 1,
-	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
-	.help		= MARK_help,
-	.parse		= MARK_parse_v1,
-	.final_check	= MARK_check,
-	.print		= MARK_print_v1,
-	.save		= MARK_save_v1,
-	.extra_opts	= MARK_opts,
-};
-
-static struct xtables_target mark_tg_reg_v2 = {
-	.version       = XTABLES_VERSION,
-	.name          = "MARK",
-	.revision      = 2,
-	.family        = NFPROTO_UNSPEC,
-	.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
-	.help          = mark_tg_help,
-	.parse         = mark_tg_parse,
-	.final_check   = mark_tg_check,
-	.print         = mark_tg_print,
-	.save          = mark_tg_save,
-	.extra_opts    = mark_tg_opts,
+static struct xtables_target mark_tg_reg[] = {
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "MARK",
+		.version       = XTABLES_VERSION,
+		.revision      = 0,
+		.size          = XT_ALIGN(sizeof(struct xt_mark_target_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info)),
+		.help          = MARK_help,
+		.parse         = MARK_parse_v0,
+		.final_check   = MARK_check,
+		.print         = MARK_print_v0,
+		.save          = MARK_save_v0,
+		.extra_opts    = MARK_opts,
+	},
+	{
+		.family        = NFPROTO_IPV4,
+		.name          = "MARK",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.size          = XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
+		.help          = MARK_help,
+		.parse         = MARK_parse_v1,
+		.final_check   = MARK_check,
+		.print         = MARK_print_v1,
+		.save          = MARK_save_v1,
+		.extra_opts    = MARK_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "MARK",
+		.revision      = 2,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
+		.help          = mark_tg_help,
+		.parse         = mark_tg_parse,
+		.final_check   = mark_tg_check,
+		.print         = mark_tg_print,
+		.save          = mark_tg_save,
+		.extra_opts    = mark_tg_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&mark_target_v0);
-	xtables_register_target(&mark_target_v1);
-	xtables_register_target(&mark_tg_reg_v2);
+	xtables_register_targets(mark_tg_reg, ARRAY_SIZE(mark_tg_reg));
 }
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index e6382e1..bf751a4 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -205,38 +205,38 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf("--set-tos 0x%02x/0x%02x ", info->tos_value, info->tos_mask);
 }
 
-static struct xtables_target tos_tg_reg_v0 = {
-	.version       = XTABLES_VERSION,
-	.name          = "TOS",
-	.revision      = 0,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
-	.help          = tos_tg_help_v0,
-	.parse         = tos_tg_parse_v0,
-	.final_check   = tos_tg_check,
-	.print         = tos_tg_print_v0,
-	.save          = tos_tg_save_v0,
-	.extra_opts    = tos_tg_opts_v0,
-};
-
-static struct xtables_target tos_tg_reg = {
-	.version       = XTABLES_VERSION,
-	.name          = "TOS",
-	.revision      = 1,
-	.family        = NFPROTO_UNSPEC,
-	.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
-	.help          = tos_tg_help,
-	.parse         = tos_tg_parse,
-	.final_check   = tos_tg_check,
-	.print         = tos_tg_print,
-	.save          = tos_tg_save,
-	.extra_opts    = tos_tg_opts,
+static struct xtables_target tos_tg_reg[] = {
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "TOS",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
+		.help          = tos_tg_help_v0,
+		.parse         = tos_tg_parse_v0,
+		.final_check   = tos_tg_check,
+		.print         = tos_tg_print_v0,
+		.save          = tos_tg_save_v0,
+		.extra_opts    = tos_tg_opts_v0,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "TOS",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
+		.help          = tos_tg_help,
+		.parse         = tos_tg_parse,
+		.final_check   = tos_tg_check,
+		.print         = tos_tg_print,
+		.save          = tos_tg_save,
+		.extra_opts    = tos_tg_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&tos_tg_reg_v0);
-	xtables_register_target(&tos_tg_reg);
+	xtables_register_targets(tos_tg_reg, ARRAY_SIZE(tos_tg_reg));
 }
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 403e7e6..1698561 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -179,38 +179,38 @@ static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 	       count_bits6(info->v6_mask));
 }
 
-static struct xtables_match connlimit_match = {
-	.name          = "connlimit",
-	.family        = NFPROTO_IPV4,
-	.version       = XTABLES_VERSION,
-	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
-	.userspacesize = offsetof(struct xt_connlimit_info, data),
-	.help          = connlimit_help,
-	.init          = connlimit_init,
-	.parse         = connlimit_parse4,
-	.final_check   = connlimit_check,
-	.print         = connlimit_print4,
-	.save          = connlimit_save4,
-	.extra_opts    = connlimit_opts,
-};
-
-static struct xtables_match connlimit_match6 = {
-	.name          = "connlimit",
-	.family        = NFPROTO_IPV6,
-	.version       = XTABLES_VERSION,
-	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
-	.userspacesize = offsetof(struct xt_connlimit_info, data),
-	.help          = connlimit_help,
-	.init          = connlimit_init,
-	.parse         = connlimit_parse6,
-	.final_check   = connlimit_check,
-	.print         = connlimit_print6,
-	.save          = connlimit_save6,
-	.extra_opts    = connlimit_opts,
+static struct xtables_match connlimit_mt_reg[] = {
+	{
+		.name          = "connlimit",
+		.family        = NFPROTO_IPV4,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+		.userspacesize = offsetof(struct xt_connlimit_info, data),
+		.help          = connlimit_help,
+		.init          = connlimit_init,
+		.parse         = connlimit_parse4,
+		.final_check   = connlimit_check,
+		.print         = connlimit_print4,
+		.save          = connlimit_save4,
+		.extra_opts    = connlimit_opts,
+	},
+	{
+		.name          = "connlimit",
+		.family        = NFPROTO_IPV6,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
+		.userspacesize = offsetof(struct xt_connlimit_info, data),
+		.help          = connlimit_help,
+		.init          = connlimit_init,
+		.parse         = connlimit_parse6,
+		.final_check   = connlimit_check,
+		.print         = connlimit_print6,
+		.save          = connlimit_save6,
+		.extra_opts    = connlimit_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&connlimit_match);
-	xtables_register_match(&connlimit_match6);
+	xtables_register_matches(connlimit_mt_reg, ARRAY_SIZE(connlimit_mt_reg));
 }
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index db7c3a1..48c10b5 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -163,38 +163,38 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
 
-static struct xtables_match connmark_mt_reg_v0 = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "connmark",
-	.revision	= 0,
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.help		= connmark_mt_help,
-	.parse		= connmark_parse,
-	.final_check	= connmark_mt_check,
-	.print		= connmark_print,
-	.save		= connmark_save,
-	.extra_opts	= connmark_mt_opts,
-};
-
-static struct xtables_match connmark_mt_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "connmark",
-	.revision       = 1,
-	.family         = NFPROTO_UNSPEC,
-	.size           = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
-	.help           = connmark_mt_help,
-	.parse          = connmark_mt_parse,
-	.final_check    = connmark_mt_check,
-	.print          = connmark_mt_print,
-	.save           = connmark_mt_save,
-	.extra_opts     = connmark_mt_opts,
+static struct xtables_match connmark_mt_reg[] = {
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "connmark",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_connmark_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_info)),
+		.help          = connmark_mt_help,
+		.parse         = connmark_parse,
+		.final_check   = connmark_mt_check,
+		.print         = connmark_print,
+		.save          = connmark_save,
+		.extra_opts    = connmark_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "connmark",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
+		.help          = connmark_mt_help,
+		.parse         = connmark_mt_parse,
+		.final_check   = connmark_mt_check,
+		.print         = connmark_mt_print,
+		.save          = connmark_mt_save,
+		.extra_opts    = connmark_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&connmark_mt_reg_v0);
-	xtables_register_match(&connmark_mt_reg);
+	xtables_register_matches(connmark_mt_reg, ARRAY_SIZE(connmark_mt_reg));
 }
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 96ea3ec..edcaaa8 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1034,54 +1034,52 @@ static void conntrack_mt6_save(const void *ip,
 	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true);
 }
 
-static struct xtables_match conntrack_match = {
-	.version       = XTABLES_VERSION,
-	.name          = "conntrack",
-	.revision      = 0,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct xt_conntrack_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_info)),
-	.help          = conntrack_mt_help,
-	.parse         = conntrack_parse,
-	.final_check   = conntrack_mt_check,
-	.print         = conntrack_print,
-	.save          = conntrack_save,
-	.extra_opts    = conntrack_mt_opts_v0,
-};
-
-static struct xtables_match conntrack_mt_reg = {
-	.version       = XTABLES_VERSION,
-	.name          = "conntrack",
-	.revision      = 1,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
-	.help          = conntrack_mt_help,
-	.parse         = conntrack_mt4_parse,
-	.final_check   = conntrack_mt_check,
-	.print         = conntrack_mt_print,
-	.save          = conntrack_mt_save,
-	.extra_opts    = conntrack_mt_opts,
-};
-
-static struct xtables_match conntrack_mt6_reg = {
-	.version       = XTABLES_VERSION,
-	.name          = "conntrack",
-	.revision      = 1,
-	.family        = NFPROTO_IPV6,
-	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
-	.help          = conntrack_mt_help,
-	.parse         = conntrack_mt6_parse,
-	.final_check   = conntrack_mt_check,
-	.print         = conntrack_mt6_print,
-	.save          = conntrack_mt6_save,
-	.extra_opts    = conntrack_mt_opts,
+static struct xtables_match conntrack_mt_reg[] = {
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "conntrack",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_info)),
+		.help          = conntrack_mt_help,
+		.parse         = conntrack_parse,
+		.final_check   = conntrack_mt_check,
+		.print         = conntrack_print,
+		.save          = conntrack_save,
+		.extra_opts    = conntrack_mt_opts_v0,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "conntrack",
+		.revision      = 1,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.help          = conntrack_mt_help,
+		.parse         = conntrack_mt4_parse,
+		.final_check   = conntrack_mt_check,
+		.print         = conntrack_mt_print,
+		.save          = conntrack_mt_save,
+		.extra_opts    = conntrack_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "conntrack",
+		.revision      = 1,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.help          = conntrack_mt_help,
+		.parse         = conntrack_mt6_parse,
+		.final_check   = conntrack_mt_check,
+		.print         = conntrack_mt6_print,
+		.save          = conntrack_mt6_save,
+		.extra_opts    = conntrack_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&conntrack_match);
-	xtables_register_match(&conntrack_mt_reg);
-	xtables_register_match(&conntrack_mt6_reg);
+	xtables_register_matches(conntrack_mt_reg, ARRAY_SIZE(conntrack_mt_reg));
 }
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 9d8c86a..cdb407a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -659,57 +659,55 @@ hashlimit_mt6_save(const void *ip, const struct xt_entry_match *match)
 	hashlimit_mt_save(info, 128);
 }
 
-static struct xtables_match hashlimit_match = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "hashlimit",
-	.version	= XTABLES_VERSION,
-	.revision	= 0,
-	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
-	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
-	.help		= hashlimit_help,
-	.init		= hashlimit_init,
-	.parse		= hashlimit_parse,
-	.final_check	= hashlimit_check,
-	.print		= hashlimit_print,
-	.save		= hashlimit_save,
-	.extra_opts	= hashlimit_opts,
-};
-
-static struct xtables_match hashlimit_mt_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "hashlimit",
-	.revision       = 1,
-	.family         = NFPROTO_IPV4,
-	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
-	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
-	.help           = hashlimit_mt_help,
-	.init           = hashlimit_mt4_init,
-	.parse          = hashlimit_mt4_parse,
-	.final_check	= hashlimit_mt_check,
-	.print          = hashlimit_mt4_print,
-	.save           = hashlimit_mt4_save,
-	.extra_opts     = hashlimit_mt_opts,
-};
-
-static struct xtables_match hashlimit_mt6_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "hashlimit",
-	.revision       = 1,
-	.family         = NFPROTO_IPV6,
-	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
-	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
-	.help           = hashlimit_mt_help,
-	.init           = hashlimit_mt6_init,
-	.parse          = hashlimit_mt6_parse,
-	.final_check	= hashlimit_mt_check,
-	.print          = hashlimit_mt6_print,
-	.save           = hashlimit_mt6_save,
-	.extra_opts     = hashlimit_mt_opts,
+static struct xtables_match hashlimit_mt_reg[] = {
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "hashlimit",
+		.version       = XTABLES_VERSION,
+		.revision      = 0,
+		.size          = XT_ALIGN(sizeof(struct xt_hashlimit_info)),
+		.userspacesize = offsetof(struct xt_hashlimit_info, hinfo),
+		.help          = hashlimit_help,
+		.init          = hashlimit_init,
+		.parse         = hashlimit_parse,
+		.final_check   = hashlimit_check,
+		.print         = hashlimit_print,
+		.save          = hashlimit_save,
+		.extra_opts    = hashlimit_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "hashlimit",
+		.revision      = 1,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
+		.userspacesize = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
+		.help          = hashlimit_mt_help,
+		.init          = hashlimit_mt4_init,
+		.parse         = hashlimit_mt4_parse,
+		.final_check   = hashlimit_mt_check,
+		.print         = hashlimit_mt4_print,
+		.save          = hashlimit_mt4_save,
+		.extra_opts    = hashlimit_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "hashlimit",
+		.revision      = 1,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
+		.userspacesize = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
+		.help          = hashlimit_mt_help,
+		.init          = hashlimit_mt6_init,
+		.parse         = hashlimit_mt6_parse,
+		.final_check   = hashlimit_mt_check,
+		.print         = hashlimit_mt6_print,
+		.save          = hashlimit_mt6_save,
+		.extra_opts    = hashlimit_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&hashlimit_match);
-	xtables_register_match(&hashlimit_mt_reg);
-	xtables_register_match(&hashlimit_mt6_reg);
+	xtables_register_matches(hashlimit_mt_reg, ARRAY_SIZE(hashlimit_mt_reg));
 }
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index bc5b2ae..7b3ccc2 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -344,54 +344,52 @@ static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static struct xtables_match iprange_match = {
-	.version       = XTABLES_VERSION,
-	.name          = "iprange",
-	.revision      = 0,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct ipt_iprange_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ipt_iprange_info)),
-	.help          = iprange_mt_help,
-	.parse         = iprange_parse,
-	.final_check   = iprange_mt_check,
-	.print         = iprange_print,
-	.save          = iprange_save,
-	.extra_opts    = iprange_mt_opts,
-};
-
-static struct xtables_match iprange_mt_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "iprange",
-	.revision       = 1,
-	.family         = NFPROTO_IPV4,
-	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
-	.help           = iprange_mt_help,
-	.parse          = iprange_mt4_parse,
-	.final_check    = iprange_mt_check,
-	.print          = iprange_mt4_print,
-	.save           = iprange_mt4_save,
-	.extra_opts     = iprange_mt_opts,
-};
-
-static struct xtables_match iprange_mt6_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "iprange",
-	.revision       = 1,
-	.family         = NFPROTO_IPV6,
-	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
-	.help           = iprange_mt_help,
-	.parse          = iprange_mt6_parse,
-	.final_check    = iprange_mt_check,
-	.print          = iprange_mt6_print,
-	.save           = iprange_mt6_save,
-	.extra_opts     = iprange_mt_opts,
+static struct xtables_match iprange_mt_reg[] = {
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "iprange",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_iprange_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_iprange_info)),
+		.help          = iprange_mt_help,
+		.parse         = iprange_parse,
+		.final_check   = iprange_mt_check,
+		.print         = iprange_print,
+		.save          = iprange_save,
+		.extra_opts    = iprange_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "iprange",
+		.revision      = 1,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+		.help          = iprange_mt_help,
+		.parse         = iprange_mt4_parse,
+		.final_check   = iprange_mt_check,
+		.print         = iprange_mt4_print,
+		.save          = iprange_mt4_save,
+		.extra_opts    = iprange_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "iprange",
+		.revision      = 1,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+		.help          = iprange_mt_help,
+		.parse         = iprange_mt6_parse,
+		.final_check   = iprange_mt_check,
+		.print         = iprange_mt6_print,
+		.save          = iprange_mt6_save,
+		.extra_opts    = iprange_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&iprange_match);
-	xtables_register_match(&iprange_mt_reg);
-	xtables_register_match(&iprange_mt6_reg);
+	xtables_register_matches(iprange_mt_reg, ARRAY_SIZE(iprange_mt_reg));
 }
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 6f8cc57..fc3d646 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -143,38 +143,38 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
 
-static struct xtables_match mark_match = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "mark",
-	.revision	= 0,
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.help		= mark_mt_help,
-	.parse		= mark_parse,
-	.final_check	= mark_mt_check,
-	.print		= mark_print,
-	.save		= mark_save,
-	.extra_opts	= mark_mt_opts,
-};
-
-static struct xtables_match mark_mt_reg = {
-	.version        = XTABLES_VERSION,
-	.name           = "mark",
-	.revision       = 1,
-	.family         = NFPROTO_UNSPEC,
-	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
-	.help           = mark_mt_help,
-	.parse          = mark_mt_parse,
-	.final_check    = mark_mt_check,
-	.print          = mark_mt_print,
-	.save           = mark_mt_save,
-	.extra_opts     = mark_mt_opts,
+static struct xtables_match mark_mt_reg[] = {
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "mark",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_mark_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_info)),
+		.help          = mark_mt_help,
+		.parse         = mark_parse,
+		.final_check   = mark_mt_check,
+		.print         = mark_print,
+		.save          = mark_save,
+		.extra_opts    = mark_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "mark",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
+		.help          = mark_mt_help,
+		.parse         = mark_mt_parse,
+		.final_check   = mark_mt_check,
+		.print         = mark_mt_print,
+		.save          = mark_mt_save,
+		.extra_opts    = mark_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&mark_match);
-	xtables_register_match(&mark_mt_reg);
+	xtables_register_matches(mark_mt_reg, ARRAY_SIZE(mark_mt_reg));
 }
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 9959a20..d9b6e74 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -509,71 +509,67 @@ static void multiport_save6_v1(const void *ip_void,
 	__multiport_save_v1(match, ip->proto);
 }
 
-static struct xtables_match multiport_match = {
-	.family		= NFPROTO_IPV4,
-	.name		= "multiport",
-	.revision	= 0,
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
-	.help		= multiport_help,
-	.parse		= multiport_parse,
-	.final_check	= multiport_check,
-	.print		= multiport_print,
-	.save		= multiport_save,
-	.extra_opts	= multiport_opts,
-};
-
-static struct xtables_match multiport_match6 = {
-	.family		= NFPROTO_IPV6,
-	.name		= "multiport",
-	.revision	= 0,
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
-	.help		= multiport_help,
-	.parse		= multiport_parse6,
-	.final_check	= multiport_check,
-	.print		= multiport_print6,
-	.save		= multiport_save6,
-	.extra_opts	= multiport_opts,
-};
-
-static struct xtables_match multiport_match_v1 = {
-	.family		= NFPROTO_IPV4,
-	.name		= "multiport",
-	.version	= XTABLES_VERSION,
-	.revision	= 1,
-	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.help		= multiport_help_v1,
-	.parse		= multiport_parse_v1,
-	.final_check	= multiport_check,
-	.print		= multiport_print_v1,
-	.save		= multiport_save_v1,
-	.extra_opts	= multiport_opts,
-};
-
-static struct xtables_match multiport_match6_v1 = {
-	.family		= NFPROTO_IPV6,
-	.name		= "multiport",
-	.version	= XTABLES_VERSION,
-	.revision	= 1,
-	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.help		= multiport_help_v1,
-	.parse		= multiport_parse6_v1,
-	.final_check	= multiport_check,
-	.print		= multiport_print6_v1,
-	.save		= multiport_save6_v1,
-	.extra_opts	= multiport_opts,
+static struct xtables_match multiport_mt_reg[] = {
+	{
+		.family        = NFPROTO_IPV4,
+		.name          = "multiport",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_multiport)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport)),
+		.help          = multiport_help,
+		.parse         = multiport_parse,
+		.final_check   = multiport_check,
+		.print         = multiport_print,
+		.save          = multiport_save,
+		.extra_opts    = multiport_opts,
+	},
+	{
+		.family        = NFPROTO_IPV6,
+		.name          = "multiport",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_multiport)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport)),
+		.help          = multiport_help,
+		.parse         = multiport_parse6,
+		.final_check   = multiport_check,
+		.print         = multiport_print6,
+		.save          = multiport_save6,
+		.extra_opts    = multiport_opts,
+	},
+	{
+		.family        = NFPROTO_IPV4,
+		.name          = "multiport",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.size          = XT_ALIGN(sizeof(struct xt_multiport_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport_v1)),
+		.help          = multiport_help_v1,
+		.parse         = multiport_parse_v1,
+		.final_check   = multiport_check,
+		.print         = multiport_print_v1,
+		.save          = multiport_save_v1,
+		.extra_opts    = multiport_opts,
+	},
+	{
+		.family        = NFPROTO_IPV6,
+		.name          = "multiport",
+		.version       = XTABLES_VERSION,
+		.revision      = 1,
+		.size          = XT_ALIGN(sizeof(struct xt_multiport_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport_v1)),
+		.help          = multiport_help_v1,
+		.parse         = multiport_parse6_v1,
+		.final_check   = multiport_check,
+		.print         = multiport_print6_v1,
+		.save          = multiport_save6_v1,
+		.extra_opts    = multiport_opts,
+	},
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&multiport_match);
-	xtables_register_match(&multiport_match6);
-	xtables_register_match(&multiport_match_v1);
-	xtables_register_match(&multiport_match6_v1);
+	xtables_register_matches(multiport_mt_reg, ARRAY_SIZE(multiport_mt_reg));
 }
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index f1d6b4a..2544138 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -533,54 +533,52 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    false);
 }
 
-static struct xtables_match owner_mt_reg_v0 = {
-	.version       = XTABLES_VERSION,
-	.name          = "owner",
-	.revision      = 0,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct ipt_owner_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ipt_owner_info)),
-	.help          = owner_mt_help_v0,
-	.parse         = owner_mt_parse_v0,
-	.final_check   = owner_mt_check,
-	.print         = owner_mt_print_v0,
-	.save          = owner_mt_save_v0,
-	.extra_opts    = owner_mt_opts_v0,
-};
-
-static struct xtables_match owner_mt6_reg_v0 = {
-	.version       = XTABLES_VERSION,
-	.name          = "owner",
-	.revision      = 0,
-	.family        = NFPROTO_IPV6,
-	.size          = XT_ALIGN(sizeof(struct ip6t_owner_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ip6t_owner_info)),
-	.help          = owner_mt6_help_v0,
-	.parse         = owner_mt6_parse_v0,
-	.final_check   = owner_mt_check,
-	.print         = owner_mt6_print_v0,
-	.save          = owner_mt6_save_v0,
-	.extra_opts    = owner_mt6_opts_v0,
-};
-
-static struct xtables_match owner_mt_reg = {
-	.version       = XTABLES_VERSION,
-	.name          = "owner",
-	.revision      = 1,
-	.family        = NFPROTO_UNSPEC,
-	.size          = XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_owner_match_info)),
-	.help          = owner_mt_help,
-	.parse         = owner_mt_parse,
-	.final_check   = owner_mt_check,
-	.print         = owner_mt_print,
-	.save          = owner_mt_save,
-	.extra_opts    = owner_mt_opts,
+static struct xtables_match owner_mt_reg[] = {
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "owner",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct ipt_owner_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_owner_info)),
+		.help          = owner_mt_help_v0,
+		.parse         = owner_mt_parse_v0,
+		.final_check   = owner_mt_check,
+		.print         = owner_mt_print_v0,
+		.save          = owner_mt_save_v0,
+		.extra_opts    = owner_mt_opts_v0,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "owner",
+		.revision      = 0,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct ip6t_owner_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ip6t_owner_info)),
+		.help          = owner_mt6_help_v0,
+		.parse         = owner_mt6_parse_v0,
+		.final_check   = owner_mt_check,
+		.print         = owner_mt6_print_v0,
+		.save          = owner_mt6_save_v0,
+		.extra_opts    = owner_mt6_opts_v0,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "owner",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.size          = XT_ALIGN(sizeof(struct xt_owner_match_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_owner_match_info)),
+		.help          = owner_mt_help,
+		.parse         = owner_mt_parse,
+		.final_check   = owner_mt_check,
+		.print         = owner_mt_print,
+		.save          = owner_mt_save,
+		.extra_opts    = owner_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&owner_mt_reg_v0);
-	xtables_register_match(&owner_mt6_reg_v0);
-	xtables_register_match(&owner_mt_reg);
+	xtables_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
 }
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index d17b1bb..858eaaa 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -478,36 +478,36 @@ static void policy6_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static struct xtables_match policy_mt_reg = {
-	.name		= "policy",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct xt_policy_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_policy_info)),
-	.help		= policy_help,
-	.parse		= policy4_parse,
-	.final_check	= policy_check,
-	.print		= policy4_print,
-	.save		= policy4_save,
-	.extra_opts	= policy_opts,
-};
-
-static struct xtables_match policy_mt6_reg = {
-	.name		= "policy",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV6,
-	.size		= XT_ALIGN(sizeof(struct xt_policy_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_policy_info)),
-	.help		= policy_help,
-	.parse		= policy6_parse,
-	.final_check	= policy_check,
-	.print		= policy6_print,
-	.save		= policy6_save,
-	.extra_opts	= policy_opts,
+static struct xtables_match policy_mt_reg[] = {
+	{
+		.name          = "policy",
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV4,
+		.size          = XT_ALIGN(sizeof(struct xt_policy_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_policy_info)),
+		.help          = policy_help,
+		.parse         = policy4_parse,
+		.final_check   = policy_check,
+		.print         = policy4_print,
+		.save          = policy4_save,
+		.extra_opts    = policy_opts,
+	},
+	{
+		.name          = "policy",
+		.version       = XTABLES_VERSION,
+		.family        = NFPROTO_IPV6,
+		.size          = XT_ALIGN(sizeof(struct xt_policy_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_policy_info)),
+		.help          = policy_help,
+		.parse         = policy6_parse,
+		.final_check   = policy_check,
+		.print         = policy6_print,
+		.save          = policy6_save,
+		.extra_opts    = policy_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&policy_mt_reg);
-	xtables_register_match(&policy_mt6_reg);
+	xtables_register_matches(policy_mt_reg, ARRAY_SIZE(policy_mt_reg));
 }
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 18e3ed2..62c3a97 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -350,40 +350,40 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 }
 
 
-static struct xtables_match string_match = {
-    .name		= "string",
-    .revision		= 0,
-    .family		= NFPROTO_UNSPEC,
-    .version		= XTABLES_VERSION,
-    .size		= XT_ALIGN(sizeof(struct xt_string_info)),
-    .userspacesize	= offsetof(struct xt_string_info, config),
-    .help		= string_help,
-    .init		= string_init,
-    .parse		= string_parse,
-    .final_check	= string_check,
-    .print		= string_print,
-    .save		= string_save,
-    .extra_opts		= string_opts,
-};
-
-static struct xtables_match string_match_v1 = {
-    .name		= "string",
-    .revision		= 1,
-    .family		= NFPROTO_UNSPEC,
-    .version		= XTABLES_VERSION,
-    .size		= XT_ALIGN(sizeof(struct xt_string_info)),
-    .userspacesize	= offsetof(struct xt_string_info, config),
-    .help		= string_help,
-    .init		= string_init,
-    .parse		= string_parse,
-    .final_check	= string_check,
-    .print		= string_print,
-    .save		= string_save,
-    .extra_opts		= string_opts,
+static struct xtables_match string_mt_reg[] = {
+	{
+		.name          = "string",
+		.revision      = 0,
+		.family        = NFPROTO_UNSPEC,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_string_info)),
+		.userspacesize = offsetof(struct xt_string_info, config),
+		.help          = string_help,
+		.init          = string_init,
+		.parse         = string_parse,
+		.final_check   = string_check,
+		.print         = string_print,
+		.save          = string_save,
+		.extra_opts    = string_opts,
+	},
+	{
+		.name          = "string",
+		.revision      = 1,
+		.family        = NFPROTO_UNSPEC,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_string_info)),
+		.userspacesize = offsetof(struct xt_string_info, config),
+		.help          = string_help,
+		.init          = string_init,
+		.parse         = string_parse,
+		.final_check   = string_check,
+		.print         = string_print,
+		.save          = string_save,
+		.extra_opts    = string_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&string_match);
-	xtables_register_match(&string_match_v1);
+	xtables_register_matches(string_mt_reg, ARRAY_SIZE(string_mt_reg));
 }
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 1f7b2cd..0a81f46 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -137,38 +137,38 @@ static void tos_mt_save(const void *ip, const struct xt_entry_match *match)
 	printf("--tos 0x%02x/0x%02x ", info->tos_value, info->tos_mask);
 }
 
-static struct xtables_match tos_mt_reg_v0 = {
-	.version       = XTABLES_VERSION,
-	.name          = "tos",
-	.family        = NFPROTO_IPV4,
-	.revision      = 0,
-	.size          = XT_ALIGN(sizeof(struct ipt_tos_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ipt_tos_info)),
-	.help          = tos_mt_help,
-	.parse         = tos_mt_parse_v0,
-	.final_check   = tos_mt_check,
-	.print         = tos_mt_print_v0,
-	.save          = tos_mt_save_v0,
-	.extra_opts    = tos_mt_opts,
-};
-
-static struct xtables_match tos_mt_reg = {
-	.version       = XTABLES_VERSION,
-	.name          = "tos",
-	.family        = NFPROTO_UNSPEC,
-	.revision      = 1,
-	.size          = XT_ALIGN(sizeof(struct xt_tos_match_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_match_info)),
-	.help          = tos_mt_help,
-	.parse         = tos_mt_parse,
-	.final_check   = tos_mt_check,
-	.print         = tos_mt_print,
-	.save          = tos_mt_save,
-	.extra_opts    = tos_mt_opts,
+static struct xtables_match tos_mt_reg[] = {
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "tos",
+		.family        = NFPROTO_IPV4,
+		.revision      = 0,
+		.size          = XT_ALIGN(sizeof(struct ipt_tos_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct ipt_tos_info)),
+		.help          = tos_mt_help,
+		.parse         = tos_mt_parse_v0,
+		.final_check   = tos_mt_check,
+		.print         = tos_mt_print_v0,
+		.save          = tos_mt_save_v0,
+		.extra_opts    = tos_mt_opts,
+	},
+	{
+		.version       = XTABLES_VERSION,
+		.name          = "tos",
+		.family        = NFPROTO_UNSPEC,
+		.revision      = 1,
+		.size          = XT_ALIGN(sizeof(struct xt_tos_match_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tos_match_info)),
+		.help          = tos_mt_help,
+		.parse         = tos_mt_parse,
+		.final_check   = tos_mt_check,
+		.print         = tos_mt_print,
+		.save          = tos_mt_save,
+		.extra_opts    = tos_mt_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&tos_mt_reg_v0);
-	xtables_register_match(&tos_mt_reg);
+	xtables_register_matches(tos_mt_reg, ARRAY_SIZE(tos_mt_reg));
 }
-- 
1.6.3.2

