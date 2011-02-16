From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] extensions: fix indent of vtable
Date: Wed, 16 Feb 2011 03:18:56 +0100
Message-ID: <1297822737-11204-4-git-send-email-jengelh@medozas.de>
References: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36206 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1BPCTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:19:03 -0500
In-Reply-To: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c  |   22 +++++++++++-----------
 extensions/libipt_LOG.c   |   22 +++++++++++-----------
 extensions/libipt_ecn.c   |   22 +++++++++++-----------
 extensions/libxt_recent.c |   24 ++++++++++++------------
 4 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index af53705..e9c738f 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -257,17 +257,17 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target log_tg6_reg = {
-    .name          = "LOG",
-    .version       = XTABLES_VERSION,
-    .family        = NFPROTO_IPV6,
-    .size          = XT_ALIGN(sizeof(struct ip6t_log_info)),
-    .userspacesize = XT_ALIGN(sizeof(struct ip6t_log_info)),
-    .help          = LOG_help,
-    .init          = LOG_init,
-    .parse         = LOG_parse,
-    .print         = LOG_print,
-    .save          = LOG_save,
-    .extra_opts    = LOG_opts,
+	.name          = "LOG",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_IPV6,
+	.size          = XT_ALIGN(sizeof(struct ip6t_log_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct ip6t_log_info)),
+	.help          = LOG_help,
+	.init          = LOG_init,
+	.parse         = LOG_parse,
+	.print         = LOG_print,
+	.save          = LOG_save,
+	.extra_opts    = LOG_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 233bd9a..ba6af04 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -259,17 +259,17 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target log_tg_reg = {
-    .name          = "LOG",
-    .version       = XTABLES_VERSION,
-    .family        = NFPROTO_IPV4,
-    .size          = XT_ALIGN(sizeof(struct ipt_log_info)),
-    .userspacesize = XT_ALIGN(sizeof(struct ipt_log_info)),
-    .help          = LOG_help,
-    .init          = LOG_init,
-    .parse         = LOG_parse,
-    .print         = LOG_print,
-    .save          = LOG_save,
-    .extra_opts    = LOG_opts,
+	.name          = "LOG",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_IPV4,
+	.size          = XT_ALIGN(sizeof(struct ipt_log_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct ipt_log_info)),
+	.help          = LOG_help,
+	.init          = LOG_init,
+	.parse         = LOG_parse,
+	.print         = LOG_print,
+	.save          = LOG_save,
+	.extra_opts    = LOG_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 81d7b58..d6b521f 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -138,17 +138,17 @@ static void ecn_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match ecn_mt_reg = {
-    .name          = "ecn",
-    .version       = XTABLES_VERSION,
-    .family        = NFPROTO_IPV4,
-    .size          = XT_ALIGN(sizeof(struct ipt_ecn_info)),
-    .userspacesize = XT_ALIGN(sizeof(struct ipt_ecn_info)),
-    .help          = ecn_help,
-    .parse         = ecn_parse,
-    .final_check   = ecn_check,
-    .print         = ecn_print,
-    .save          = ecn_save,
-    .extra_opts    = ecn_opts,
+	.name          = "ecn",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_IPV4,
+	.size          = XT_ALIGN(sizeof(struct ipt_ecn_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct ipt_ecn_info)),
+	.help          = ecn_help,
+	.parse         = ecn_parse,
+	.final_check   = ecn_check,
+	.print         = ecn_print,
+	.save          = ecn_save,
+	.extra_opts    = ecn_opts,
 };
 
 void _init(void)
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index e4a7f4d..f8a5a18 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -211,18 +211,18 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match recent_mt_reg = {
-    .name          = "recent",
-    .version       = XTABLES_VERSION,
-    .family        = NFPROTO_UNSPEC,
-    .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
-    .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
-    .help          = recent_help,
-    .init          = recent_init,
-    .parse         = recent_parse,
-    .final_check   = recent_check,
-    .print         = recent_print,
-    .save          = recent_save,
-    .extra_opts    = recent_opts,
+	.name          = "recent",
+	.version       = XTABLES_VERSION,
+	.family        = NFPROTO_UNSPEC,
+	.size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+	.help          = recent_help,
+	.init          = recent_init,
+	.parse         = recent_parse,
+	.final_check   = recent_check,
+	.print         = recent_print,
+	.save          = recent_save,
+	.extra_opts    = recent_opts,
 };
 
 void _init(void)
-- 
1.7.1

