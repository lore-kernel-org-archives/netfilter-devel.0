From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 19/24] Implement AF_UNSPEC as a wildcard for extensions
Date: Tue, 4 Mar 2008 17:12:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041711410.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36684 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763683AbYCDQMm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:12:42 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is independent from the AF_UNSPEC patches I send in for the linux 
kernel.

===
commit def94a790c6c55ce6c96683f2eb60a0c2f99ac87
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 04:23:04 2008 +0100

    Implement AF_UNSPEC as a wildcard for extensions
    
    When a match or target is registered using
    xtables_register_{match,target}, xtables.c will consider AF_UNSPEC as
    a wildcard when specified as the .family member. Rules between
    two competing matches/targets are:
    
    - higher revision (if usable in kernel) wins over lower revision
    - in case of same revision: generic AF_UNSPEC loses to specific AF_...
---
 extensions/libxt_CLASSIFY.c  |   17 +---------------
 extensions/libxt_MARK.c      |   18 +----------------
 extensions/libxt_RATEEST.c   |   22 ++-----------------
 extensions/libxt_SECMARK.c   |   18 +----------------
 extensions/libxt_TRACE.c     |   13 +-----------
 extensions/libxt_length.c    |   17 +---------------
 extensions/libxt_limit.c     |   17 +---------------
 extensions/libxt_mark.c      |   36 +--------------------------------
 extensions/libxt_pkttype.c   |   17 +---------------
 extensions/libxt_quota.c     |   16 +--------------
 extensions/libxt_rateest.c   |   21 ++-----------------
 extensions/libxt_standard.c  |   13 +-----------
 extensions/libxt_statistic.c |   18 +----------------
 extensions/libxt_string.c    |   19 +-----------------
 extensions/libxt_time.c      |   17 +---------------
 extensions/libxt_u32.c       |   17 +---------------
 xtables.c                    |   22 +++++++++++++++-----
 17 files changed, 37 insertions(+), 281 deletions(-)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index ea6cdbe..1bf9494 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -103,21 +103,7 @@ CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target classify_target = { 
-	.family		= AF_INET,
-	.name		= "CLASSIFY",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.help		= CLASSIFY_help,
-	.parse		= CLASSIFY_parse,
-	.final_check	= CLASSIFY_final_check,
-	.print		= CLASSIFY_print,
-	.save		= CLASSIFY_save,
-	.extra_opts	= CLASSIFY_opts,
-};
-
-static struct xtables_target classify_target6 = { 
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "CLASSIFY",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
@@ -134,5 +120,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_target(&classify_target);
-	xtables_register_target(&classify_target6);
 }
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 2994e75..4003d26 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -333,22 +333,7 @@ static struct xtables_target mark_tg_reg_v2 = {
 	.version       = IPTABLES_VERSION,
 	.name          = "MARK",
 	.revision      = 2,
-	.family        = AF_INET,
-	.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
-	.help          = mark_tg_help,
-	.parse         = mark_tg_parse,
-	.final_check   = mark_tg_check,
-	.print         = mark_tg_print,
-	.save          = mark_tg_save,
-	.extra_opts    = mark_tg_opts,
-};
-
-static struct xtables_target mark_tg6_reg_v2 = {
-	.version       = IPTABLES_VERSION,
-	.name          = "MARK",
-	.revision      = 2,
-	.family        = AF_INET6,
+	.family        = AF_UNSPEC,
 	.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 	.help          = mark_tg_help,
@@ -366,5 +351,4 @@ void _init(void)
 	xtables_register_target(&mark_target_v1);
 	xtables_register_target(&mark_target6_v0);
 	xtables_register_target(&mark_tg_reg_v2);
-	xtables_register_target(&mark_tg6_reg_v2);
 }
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index df16581..6918f76 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -203,23 +203,8 @@ RATEEST_save(const void *ip, const struct xt_entry_target *target)
 	__RATEEST_print(target, "--rateest-");
 }
 
-static struct xtables_target rateest_target4 = {
-	.family		= AF_INET,
-	.name		= "RATEEST",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
-	.help		= RATEEST_help,
-	.init		= RATEEST_init,
-	.parse		= RATEEST_parse,
-	.final_check	= RATEEST_final_check,
-	.print		= RATEEST_print,
-	.save		= RATEEST_save,
-	.extra_opts	= RATEEST_opts,
-};
-
-static struct xtables_target rateest_target6 = {
-	.family		= AF_INET6,
+static struct xtables_target rateest_tg_reg = {
+	.family		= AF_UNSPEC,
 	.name		= "RATEEST",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
@@ -236,6 +221,5 @@ static struct xtables_target rateest_target6 = {
 void _init(void);
 void _init(void)
 {
-	xtables_register_target(&rateest_target4);
-	xtables_register_target(&rateest_target6);
+	xtables_register_target(&rateest_tg_reg);
 }
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 5dfd21e..d143037 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -100,22 +100,7 @@ static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target secmark_target = {
-	.family		= AF_INET,
-	.name		= "SECMARK",
-	.version	= IPTABLES_VERSION,
-	.revision	= 0,
-	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= SECMARK_help,
-	.parse		= SECMARK_parse,
-	.final_check	= SECMARK_check,
-	.print		= SECMARK_print,
-	.save		= SECMARK_save,
-	.extra_opts	= SECMARK_opts,
-};
-
-static struct xtables_target secmark_target6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "SECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
@@ -133,5 +118,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_target(&secmark_target);
-	xtables_register_target(&secmark_target6);
 }
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index f1d2d94..7241f2b 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -24,17 +24,7 @@ static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_target trace_target = {
-	.family		= AF_INET,
-	.name		= "TRACE",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
-	.help		= TRACE_help,
-	.parse		= TRACE_parse,
-};
-
-static struct xtables_target trace_target6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "TRACE",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(0),
@@ -47,5 +37,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_target(&trace_target);
-	xtables_register_target(&trace_target6);
 }
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 8fb2150..136034c 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -125,21 +125,7 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match length_match = {
-	.family		= AF_INET,
-	.name		= "length",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
-	.help		= length_help,
-	.parse		= length_parse,
-	.final_check	= length_check,
-	.print		= length_print,
-	.save		= length_save,
-	.extra_opts	= length_opts,
-};
-
-static struct xtables_match length_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
@@ -156,5 +142,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&length_match);
-	xtables_register_match(&length_match6);
 }
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index e93388b..da64750 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -165,21 +165,7 @@ static void limit_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match limit_match = {
-	.family		= AF_INET,
-	.name		= "limit",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
-	.userspacesize	= offsetof(struct xt_rateinfo, prev),
-	.help		= limit_help,
-	.init		= limit_init,
-	.parse		= limit_parse,
-	.print		= limit_print,
-	.save		= limit_save,
-	.extra_opts	= limit_opts,
-};
-
-static struct xtables_match limit_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
@@ -196,5 +182,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&limit_match);
-	xtables_register_match(&limit_match6);
 }
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 1e07736..e805a2b 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -149,22 +149,7 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match mark_match = {
-	.family		= AF_INET,
-	.name		= "mark",
-	.revision	= 0,
-	.version	= IPTABLES_VERSION,
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
-static struct xtables_match mark_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "mark",
 	.revision	= 0,
 	.version	= IPTABLES_VERSION,
@@ -182,22 +167,7 @@ static struct xtables_match mark_mt_reg = {
 	.version        = IPTABLES_VERSION,
 	.name           = "mark",
 	.revision       = 1,
-	.family         = AF_INET,
-	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
-	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
-	.help           = mark_mt_help,
-	.parse          = mark_mt_parse,
-	.final_check    = mark_mt_check,
-	.print          = mark_mt_print,
-	.save           = mark_mt_save,
-	.extra_opts     = mark_mt_opts,
-};
-
-static struct xtables_match mark_mt6_reg = {
-	.version        = IPTABLES_VERSION,
-	.name           = "mark",
-	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = AF_UNSPEC,
 	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.help           = mark_mt_help,
@@ -212,7 +182,5 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&mark_match);
-	xtables_register_match(&mark_match6);
 	xtables_register_match(&mark_mt_reg);
-	xtables_register_match(&mark_mt6_reg);
 }
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 893fe43..a5cf90a 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -147,21 +147,7 @@ static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match pkttype_match = {
-	.family		= AF_INET,
-	.name		= "pkttype",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
-	.help		= pkttype_help,
-	.parse		= pkttype_parse,
-	.final_check	= pkttype_check,
-	.print		= pkttype_print,
-	.save		= pkttype_save,
-	.extra_opts	= pkttype_opts,
-};
-
-static struct xtables_match pkttype_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "pkttype",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
@@ -178,5 +164,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&pkttype_match);
-	xtables_register_match(&pkttype_match6);
 }
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 9ce350d..f73089d 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -78,20 +78,7 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 struct xtables_match quota_match = {
-	.family		= AF_INET,
-	.name		= "quota",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
-	.userspacesize	= offsetof(struct xt_quota_info, quota),
-	.help		= quota_help,
-	.parse		= quota_parse,
-	.print		= quota_print,
-	.save		= quota_save,
-	.extra_opts	= quota_opts,
-};
-
-struct xtables_match quota_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
@@ -107,5 +94,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&quota_match);
-	xtables_register_match(&quota_match6);
 }
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 0771fcd..69edaba 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -426,22 +426,8 @@ rateest_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static struct xtables_match rateest_match4 = {
-	.family		= AF_INET,
-	.name		= "rateest",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
-	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
-	.help		= rateest_help,
-	.parse		= rateest_parse,
-	.final_check	= rateest_final_check,
-	.print		= rateest_print,
-	.save		= rateest_save,
-	.extra_opts	= rateest_opts,
-};
-
-static struct xtables_match rateest_match6 = {
-	.family		= AF_INET6,
+static struct xtables_match rateest_mt_reg = {
+	.family		= AF_UNSPEC,
 	.name		= "rateest",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
@@ -457,6 +443,5 @@ static struct xtables_match rateest_match6 = {
 void _init(void);
 void _init(void)
 {
-	xtables_register_match(&rateest_match4);
-	xtables_register_match(&rateest_match6);
+	xtables_register_match(&rateest_mt_reg);
 }
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 2417f09..68bf16d 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -24,17 +24,7 @@ static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_target standard_target = {
-	.family		= AF_INET,
-	.name		= "standard",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(int)),
-	.userspacesize	= XT_ALIGN(sizeof(int)),
-	.help		= standard_help,
-	.parse		= standard_parse,
-};
-
-static struct xtables_target standard_target6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "standard",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
@@ -47,5 +37,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_target(&standard_target);
-	xtables_register_target(&standard_target6);
 }
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 5ac77b6..67cf9e3 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -164,22 +164,7 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match statistic_match = {
-	.family		= AF_INET,
-	.name		= "statistic",
-	.version	= IPTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
-	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
-	.init		= statistic_mt_init,
-	.help		= statistic_help,
-	.parse		= statistic_parse,
-	.final_check	= statistic_check,
-	.print		= statistic_print,
-	.save		= statistic_save,
-	.extra_opts	= statistic_opts,
-};
-
-static struct xtables_match statistic_match6 = {
-	.family		= AF_INET6,
+	.family		= AF_UNSPEC,
 	.name		= "statistic",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
@@ -197,5 +182,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&statistic_match);
-	xtables_register_match(&statistic_match6);
 }
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 5be14ef..182d474 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -327,23 +327,7 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match string_match = {
     .name		= "string",
-    .family		= AF_INET,
-    .version		= IPTABLES_VERSION,
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
-
-static struct xtables_match string_match6 = {
-    .name		= "string",
-    .family		= AF_INET6,
+    .family		= AF_UNSPEC,
     .version		= IPTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
@@ -360,5 +344,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&string_match);
-	xtables_register_match(&string_match6);
 }
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 3efc727..3a9ccd6 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -466,21 +466,7 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match time_match = {
 	.name          = "time",
-	.family        = AF_INET,
-	.version       = IPTABLES_VERSION,
-	.size          = XT_ALIGN(sizeof(struct xt_time_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_time_info)),
-	.help          = time_help,
-	.init          = time_init,
-	.parse         = time_parse,
-	.print         = time_print,
-	.save          = time_save,
-	.extra_opts    = time_opts,
-};
-
-static struct xtables_match time_match6 = {
-	.name          = "time",
-	.family        = AF_INET6,
+	.family        = AF_UNSPEC,
 	.version       = IPTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_time_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_time_info)),
@@ -496,5 +482,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&time_match);
-	xtables_register_match(&time_match6);
 }
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 1e79c57..2dff28f 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -272,20 +272,7 @@ static void u32_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match u32_match = {
 	.name          = "u32",
-	.family        = AF_INET,
-	.version       = IPTABLES_VERSION,
-	.size          = XT_ALIGN(sizeof(struct xt_u32)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
-	.help          = u32_help,
-	.parse         = u32_parse,
-	.print         = u32_print,
-	.save          = u32_save,
-	.extra_opts    = u32_opts,
-};
-
-static struct xtables_match u32_match6 = {
-	.name          = "u32",
-	.family        = AF_INET6,
+	.family        = AF_UNSPEC,
 	.version       = IPTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_u32)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
@@ -300,6 +287,4 @@ void _init(void);
 void _init(void)
 {
 	xtables_register_match(&u32_match);
-	xtables_register_match(&u32_match6);
-	return;
 }
diff --git a/xtables.c b/xtables.c
index 0405e3e..1ff76f2 100644
--- a/xtables.c
+++ b/xtables.c
@@ -549,12 +549,13 @@ void xtables_register_match(struct xtables_match *me)
 	}
 
 	/* ignore not interested match */
-	if (me->family != afinfo.family)
+	if (me->family != afinfo.family && me->family != AF_UNSPEC)
 		return;
 
 	old = find_match(me->name, DURING_LOAD, NULL);
 	if (old) {
-		if (old->revision == me->revision) {
+		if (old->revision == me->revision &&
+		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: match `%s' already registered.\n",
 				program_name, me->name);
@@ -566,10 +567,14 @@ void xtables_register_match(struct xtables_match *me)
 		    && old->revision > me->revision)
 			return;
 
-		/* Replace if compatible. */
+		/* See if new match can be used. */
 		if (!compatible_match_revision(me->name, me->revision))
 			return;
 
+		/* Prefer !AF_UNSPEC over AF_UNSPEC for same revision. */
+		if (old->revision == me->revision && me->family == AF_UNSPEC)
+			return;
+
 		/* Delete old one. */
 		for (i = &xtables_matches; *i!=old; i = &(*i)->next);
 		*i = old->next;
@@ -615,14 +620,15 @@ void xtables_register_target(struct xtables_target *me)
 	}
 
 	/* ignore not interested target */
-	if (me->family != afinfo.family)
+	if (me->family != afinfo.family && me->family != AF_UNSPEC)
 		return;
 
 	old = find_target(me->name, DURING_LOAD);
 	if (old) {
 		struct xtables_target **i;
 
-		if (old->revision == me->revision) {
+		if (old->revision == me->revision &&
+		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: target `%s' already registered.\n",
 				program_name, me->name);
@@ -634,10 +640,14 @@ void xtables_register_target(struct xtables_target *me)
 		    && old->revision > me->revision)
 			return;
 
-		/* Replace if compatible. */
+		/* See if new target can be used. */
 		if (!compatible_target_revision(me->name, me->revision))
 			return;
 
+		/* Prefer !AF_UNSPEC over AF_UNSPEC for same revision. */
+		if (old->revision == me->revision && me->family == AF_UNSPEC)
+			return;
+
 		/* Delete old one. */
 		for (i = &xtables_targets; *i!=old; i = &(*i)->next);
 		*i = old->next;
