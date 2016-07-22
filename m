From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 2/2] xtables-translate: fix issue with quotes
Date: Fri, 22 Jul 2016 17:48:34 +0200
Message-ID: <20160722154834.1802-2-pablombg@gmail.com>
References: <20160722154834.1802-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33300 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcGVPtk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 11:49:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so6706647wme.0
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 08:49:39 -0700 (PDT)
In-Reply-To: <20160722154834.1802-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some translations included escaped quotes when they were called from
nft:

$ sudo nft list ruleset
table ip mangle {
    chain FORWARD {
        type filter hook forward priority -150; policy accept;
        ct helper \"ftp\" counter packets 0 bytes 0
                  ^^   ^^
    }
}

This behavior is only correct when xlate functions are called from a
xtables-translate command. This patch solves that issue if nft revision
is using the field added to the xt_xlate struct with "xtables-translate:
add new field to identify the caller" commit.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libip6t_LOG.c  | 8 ++++++--
 extensions/libipt_LOG.c   | 8 ++++++--
 extensions/libxt_NFLOG.c  | 9 +++++++--
 extensions/libxt_helper.c | 8 ++++++--
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 3c5075e..ec4b9cc 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -190,8 +190,12 @@ static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
 			(const struct ip6t_log_info *)target->data;
 
 	xt_xlate_add(xl, "log ");
-	if (strcmp(loginfo->prefix, "") != 0)
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		if (xt_xlate_get_nft_compat(xl))
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
 		if (loginfo->level == ip6t_log_xlate_names[i].level &&
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index f81eb8d..c87d5fe 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -190,8 +190,12 @@ static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
 			(const struct ipt_log_info *)target->data;
 
 	xt_xlate_add(xl, "log ");
-	if (strcmp(loginfo->prefix, "") != 0)
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		if (xt_xlate_get_nft_compat(xl))
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
 		if (loginfo->level != LOG_DEFAULT_LEVEL &&
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 8c67066..f0b92de 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -110,8 +110,13 @@ static void nflog_print_xlate(const struct xt_nflog_info *info,
 			      struct xt_xlate *xl)
 {
 	xt_xlate_add(xl, "log ");
-	if (info->prefix[0] != '\0')
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
+	if (info->prefix[0] != '\0') {
+		if (xt_xlate_get_nft_compat(xl))
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
+
+	}
 	if (info->len)
 		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 26e9569..7b06e50 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -50,8 +50,12 @@ static int helper_xlate(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_helper_info *info = (const void *)match->data;
 
-	xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
-		   info->invert ? " !=" : "", info->name);
+	if (xt_xlate_get_nft_compat(xl))
+		xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
+			   info->invert ? " !=" : "", info->name);
+	else
+		xt_xlate_add(xl, "ct helper%s \"%s\"",
+			   info->invert ? " !=" : "", info->name);
 
 	return 1;
 }
-- 
2.9.0

