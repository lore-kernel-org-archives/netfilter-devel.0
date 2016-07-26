From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v2 2/2] xtables-translate: fix issue with quotes
Date: Tue, 26 Jul 2016 18:45:24 +0200
Message-ID: <20160726164524.29906-2-pablombg@gmail.com>
References: <20160726164524.29906-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32882 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbcGZQqd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 12:46:33 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so2564974wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 09:46:32 -0700 (PDT)
In-Reply-To: <20160726164524.29906-1-pablombg@gmail.com>
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
xtables-translate command. This patch solves that issue using a new
parameter (escape_quotes) in the xlate functions.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 extensions/libip6t_LOG.c     |  8 ++++++--
 extensions/libipt_LOG.c      |  8 ++++++--
 extensions/libxt_NFLOG.c     | 13 +++++++++----
 extensions/libxt_helper.c    |  8 ++++++--
 include/xtables.h            |  2 ++
 iptables/xtables-translate.c |  2 ++
 6 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index cf5f8df..af77b9a 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -190,8 +190,12 @@ static int LOG_xlate(struct xt_xlate *xl,
 	unsigned int i = 0;
 
 	xt_xlate_add(xl, "log ");
-	if (strcmp(loginfo->prefix, "") != 0)
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		if (params->escape_quotes)
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
 		if (loginfo->level == ip6t_log_xlate_names[i].level &&
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 996dfb6..2784d9b 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -190,8 +190,12 @@ static int LOG_xlate(struct xt_xlate *xl,
 	unsigned int i = 0;
 
 	xt_xlate_add(xl, "log ");
-	if (strcmp(loginfo->prefix, "") != 0)
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		if (params->escape_quotes)
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", loginfo->prefix);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
 		if (loginfo->level != LOG_DEFAULT_LEVEL &&
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index e6d627a..02a1b4a 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -107,11 +107,16 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void nflog_print_xlate(const struct xt_nflog_info *info,
-			      struct xt_xlate *xl)
+			      struct xt_xlate *xl, bool escape_quotes)
 {
 	xt_xlate_add(xl, "log ");
-	if (info->prefix[0] != '\0')
-		xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
+	if (info->prefix[0] != '\0') {
+		if (escape_quotes)
+			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
+		else
+			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
+
+	}
 	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
@@ -125,7 +130,7 @@ static int NFLOG_xlate(struct xt_xlate *xl,
 	const struct xt_nflog_info *info =
 		(struct xt_nflog_info *)params->target->data;
 
-	nflog_print_xlate(info, xl);
+	nflog_print_xlate(info, xl, params->escape_quotes);
 
 	return 1;
 }
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 6860127..2afbf99 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -50,8 +50,12 @@ static int helper_xlate(struct xt_xlate *xl,
 {
 	const struct xt_helper_info *info = (const void *)params->match->data;
 
-	xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
-		   info->invert ? " !=" : "", info->name);
+	if (params->escape_quotes)
+		xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
+			   info->invert ? " !=" : "", info->name);
+	else
+		xt_xlate_add(xl, "ct helper%s \"%s\"",
+			   info->invert ? " !=" : "", info->name);
 
 	return 1;
 }
diff --git a/include/xtables.h b/include/xtables.h
index 73ab825..e9bc3b7 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -211,12 +211,14 @@ struct xt_xlate_mt_params {
 	const void			*ip;
 	const struct xt_entry_match	*match;
 	int				numeric;
+	bool				escape_quotes;
 };
 
 struct xt_xlate_tg_params {
 	const void			*ip;
 	const struct xt_entry_target	*target;
 	int				numeric;
+	bool				escape_quotes;
 };
 
 /* Include file for additions: new matches and targets. */
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 678228b..9044d27 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -53,6 +53,7 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
 				.numeric	= numeric,
+				.escape_quotes	= true,
 			};
 			ret = cs->target->xlate(xl, &params);
 		}
@@ -79,6 +80,7 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.ip		= (const void *)&cs->fw,
 			.match		= matchp->match->m,
 			.numeric	= numeric,
+			.escape_quotes	= true,
 		};
 
 		if (!matchp->match->xlate)
-- 
2.9.0

