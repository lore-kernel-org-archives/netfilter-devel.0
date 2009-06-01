From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] extensions: use NFPROTO_UNSPEC for .family field
Date: Mon,  1 Jun 2009 12:06:33 +0200
Message-ID: <1243850793-9526-6-git-send-email-jengelh@medozas.de>
References: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbZFAKGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:06:35 -0400
In-Reply-To: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This constant would be the designated one for the .family field; it
also, given recent changes, makes grep for NFPROTO_UNSPEC work to
finally recollect all manpages.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CLASSIFY.c  |    2 +-
 extensions/libxt_MARK.c      |    2 +-
 extensions/libxt_RATEEST.c   |    2 +-
 extensions/libxt_SECMARK.c   |    2 +-
 extensions/libxt_TRACE.c     |    2 +-
 extensions/libxt_cluster.c   |    2 +-
 extensions/libxt_length.c    |    2 +-
 extensions/libxt_limit.c     |    2 +-
 extensions/libxt_mark.c      |    4 ++--
 extensions/libxt_pkttype.c   |    2 +-
 extensions/libxt_quota.c     |    2 +-
 extensions/libxt_rateest.c   |    2 +-
 extensions/libxt_standard.c  |    2 +-
 extensions/libxt_statistic.c |    2 +-
 extensions/libxt_string.c    |    4 ++--
 extensions/libxt_time.c      |    2 +-
 extensions/libxt_u32.c       |    2 +-
 17 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 7db2e4c..82b8f4e 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -96,7 +96,7 @@ CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target classify_target = { 
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "CLASSIFY",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ec2fe96..ff48a76 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -326,7 +326,7 @@ static struct xtables_target mark_tg_reg_v2 = {
 	.version       = XTABLES_VERSION,
 	.name          = "MARK",
 	.revision      = 2,
-	.family        = AF_UNSPEC,
+	.family        = NFPROTO_UNSPEC,
 	.size          = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_mark_tginfo2)),
 	.help          = mark_tg_help,
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 1a7b0a9..4b7831f 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -202,7 +202,7 @@ RATEEST_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target rateest_tg_reg = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "RATEEST",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 0c09c88..2152b6f 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -93,7 +93,7 @@ static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target secmark_target = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "SECMARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index b8eb969..344b80d 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -19,7 +19,7 @@ static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_target trace_target = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "TRACE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index 1659a60..c80afe6 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -219,7 +219,7 @@ cluster_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match cluster_mt_reg = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "cluster",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_cluster_match_info)),
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 7bb31a8..0f954cf 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -114,7 +114,7 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match length_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "length",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 498f009..8ca921c 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -158,7 +158,7 @@ static void limit_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match limit_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "limit",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 0edff74..6f8cc57 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -144,7 +144,7 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match mark_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "mark",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -162,7 +162,7 @@ static struct xtables_match mark_mt_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "mark",
 	.revision       = 1,
-	.family         = AF_UNSPEC,
+	.family         = NFPROTO_UNSPEC,
 	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.help           = mark_mt_help,
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index e3db2aa..7586c7f 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -139,7 +139,7 @@ static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match pkttype_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "pkttype",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 4c1bcb0..0ccc94b 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -74,7 +74,7 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_match quota_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "quota",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 9f3a436..54a7579 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -432,7 +432,7 @@ rateest_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match rateest_mt_reg = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "rateest",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 54e1348..56dc2d2 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -21,7 +21,7 @@ static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_target standard_target = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "standard",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 5b03686..913aa2c 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -160,7 +160,7 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match statistic_match = {
-	.family		= AF_UNSPEC,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "statistic",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index ba4b720..18e3ed2 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -353,7 +353,7 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match string_match = {
     .name		= "string",
     .revision		= 0,
-    .family		= AF_UNSPEC,
+    .family		= NFPROTO_UNSPEC,
     .version		= XTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
@@ -369,7 +369,7 @@ static struct xtables_match string_match = {
 static struct xtables_match string_match_v1 = {
     .name		= "string",
     .revision		= 1,
-    .family		= AF_UNSPEC,
+    .family		= NFPROTO_UNSPEC,
     .version		= XTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 1c81260..098fc9c 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -467,7 +467,7 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match time_match = {
 	.name          = "time",
-	.family        = AF_UNSPEC,
+	.family        = NFPROTO_UNSPEC,
 	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_time_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_time_info)),
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index c2aeb27..8e149c1 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -267,7 +267,7 @@ static void u32_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match u32_match = {
 	.name          = "u32",
-	.family        = AF_UNSPEC,
+	.family        = NFPROTO_UNSPEC,
 	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_u32)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
-- 
1.6.3.1

