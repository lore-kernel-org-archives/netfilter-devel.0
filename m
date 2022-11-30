Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D66AC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 09:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiK3JdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiK3Jch (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 04:32:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C36E571
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 01:32:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p0JRl-00030o-OQ; Wed, 30 Nov 2022 10:32:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 iptables-nft 1/3] xlate: get rid of escape_quotes
Date:   Wed, 30 Nov 2022 10:31:52 +0100
Message-Id: <20221130093154.29004-2-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130093154.29004-1-fw@strlen.de>
References: <20221130093154.29004-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its not necessary to escape " characters, we can let xtables-translate
print the entire translation/command enclosed in '' chracters, i.e. nft
'add rule ...', this also takes care of [, { and other special characters
that some shells might parse otherwise (when copy-pasting translated output).

The escape_quotes struct member is retained to avoid an ABI breakage.

This breaks all xlate test cases, fixup in followup patches.

v3: no need to escape ', replace strcmp(x, "") with x[0] (Phil Sutter)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libebt_log.c         |  8 ++------
 extensions/libebt_nflog.c       |  8 ++------
 extensions/libxt_LOG.c          | 10 +++-------
 extensions/libxt_NFLOG.c        | 12 ++++--------
 extensions/libxt_comment.c      |  7 +------
 extensions/libxt_helper.c       |  8 ++------
 include/xtables.h               |  4 ++--
 iptables/nft-bridge.c           |  2 --
 iptables/xtables-eb-translate.c | 12 ++++++------
 iptables/xtables-translate.c    | 22 ++++++++++------------
 10 files changed, 32 insertions(+), 61 deletions(-)

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 13c7fafecb11..045062196d20 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -181,12 +181,8 @@ static int brlog_xlate(struct xt_xlate *xl,
 	const struct ebt_log_info *loginfo = (const void *)params->target->data;
 
 	xt_xlate_add(xl, "log");
-	if (loginfo->prefix[0]) {
-		if (params->escape_quotes)
-			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
-		else
-			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
-	}
+	if (loginfo->prefix[0])
+		xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
 
 	if (loginfo->loglevel != LOG_DEFAULT_LEVEL)
 		xt_xlate_add(xl, " level %s", eight_priority[loginfo->loglevel].c_name);
diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index 9801f358c81b..115e15da4584 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -130,12 +130,8 @@ static int brnflog_xlate(struct xt_xlate *xl,
 	const struct ebt_nflog_info *info = (void *)params->target->data;
 
 	xt_xlate_add(xl, "log ");
-	if (info->prefix[0] != '\0') {
-		if (params->escape_quotes)
-			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
-		else
-			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
-	}
+	if (info->prefix[0] != '\0')
+		xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
 
 	xt_xlate_add(xl, "group %u ", info->group);
 
diff --git a/extensions/libxt_LOG.c b/extensions/libxt_LOG.c
index e3f4290ba003..cfde0c7bca6a 100644
--- a/extensions/libxt_LOG.c
+++ b/extensions/libxt_LOG.c
@@ -116,7 +116,7 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 			printf(" unknown-flags");
 	}
 
-	if (strcmp(loginfo->prefix, "") != 0)
+	if (loginfo->prefix[0] != 0)
 		printf(" prefix \"%s\"", loginfo->prefix);
 }
 
@@ -151,12 +151,8 @@ static int LOG_xlate(struct xt_xlate *xl,
 	const char *pname = priority2name(loginfo->level);
 
 	xt_xlate_add(xl, "log");
-	if (strcmp(loginfo->prefix, "") != 0) {
-		if (params->escape_quotes)
-			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
-		else
-			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
-	}
+	if (strcmp(loginfo->prefix, "") != 0)
+		xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL && pname)
 		xt_xlate_add(xl, " level %s", pname);
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 7a12e5aca40f..d12ef044f0ed 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -112,16 +112,12 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void nflog_print_xlate(const struct xt_nflog_info *info,
-			      struct xt_xlate *xl, bool escape_quotes)
+			      struct xt_xlate *xl)
 {
 	xt_xlate_add(xl, "log ");
-	if (info->prefix[0] != '\0') {
-		if (escape_quotes)
-			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
-		else
-			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
+	if (info->prefix[0] != '\0')
+		xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
 
-	}
 	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
@@ -135,7 +131,7 @@ static int NFLOG_xlate(struct xt_xlate *xl,
 	const struct xt_nflog_info *info =
 		(struct xt_nflog_info *)params->target->data;
 
-	nflog_print_xlate(info, xl, params->escape_quotes);
+	nflog_print_xlate(info, xl);
 
 	return 1;
 }
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 69795b6c6ed5..e9c539f68ff3 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -55,12 +55,7 @@ static int comment_xlate(struct xt_xlate *xl,
 	char comment[XT_MAX_COMMENT_LEN + sizeof("\\\"\\\"")];
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
-	if (params->escape_quotes)
-		snprintf(comment, sizeof(comment), "\\\"%s\\\"",
-			 commentinfo->comment);
-	else
-		snprintf(comment, sizeof(comment), "\"%s\"",
-			 commentinfo->comment);
+	snprintf(comment, sizeof(comment), "\"%s\"", commentinfo->comment);
 
 	xt_xlate_add_comment(xl, comment);
 
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 2afbf996a699..0f72eec68264 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -50,12 +50,8 @@ static int helper_xlate(struct xt_xlate *xl,
 {
 	const struct xt_helper_info *info = (const void *)params->match->data;
 
-	if (params->escape_quotes)
-		xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
-			   info->invert ? " !=" : "", info->name);
-	else
-		xt_xlate_add(xl, "ct helper%s \"%s\"",
-			   info->invert ? " !=" : "", info->name);
+	xt_xlate_add(xl, "ct helper%s \"%s\"",
+		     info->invert ? " !=" : "", info->name);
 
 	return 1;
 }
diff --git a/include/xtables.h b/include/xtables.h
index dad1949e5537..4ffc8ec5a17e 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -211,14 +211,14 @@ struct xt_xlate_mt_params {
 	const void			*ip;
 	const struct xt_entry_match	*match;
 	int				numeric;
-	bool				escape_quotes;
+	bool				escape_quotes;	/* not used anymore, retained for ABI */
 };
 
 struct xt_xlate_tg_params {
 	const void			*ip;
 	const struct xt_entry_target	*target;
 	int				numeric;
-	bool				escape_quotes;
+	bool				escape_quotes; /* not used anymore, retained for ABI */
 };
 
 /* Include file for additions: new matches and targets. */
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 3180091364fa..15dfc585c14a 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -786,7 +786,6 @@ static int xlate_ebmatches(const struct iptables_command_state *cs, struct xt_xl
 			struct xt_xlate_mt_params mt_params = {
 				.ip		= (const void *)&cs->eb,
 				.numeric	= numeric,
-				.escape_quotes	= false,
 				.match		= matchp->m,
 			};
 
@@ -799,7 +798,6 @@ static int xlate_ebmatches(const struct iptables_command_state *cs, struct xt_xl
 			struct xt_xlate_tg_params wt_params = {
 				.ip		= (const void *)&cs->eb,
 				.numeric	= numeric,
-				.escape_quotes	= false,
 				.target		= watcherp->t,
 			};
 
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index f09883cd518c..13b6b864a5f2 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -156,17 +156,17 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
 				 const struct iptables_command_state *cs, bool append)
 {
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
+	const char *tick = cs->restore ? "" : "'";
 	int ret;
 
-	if (append) {
-		xt_xlate_add(xl, "add rule bridge %s %s ", p->table, p->chain);
-	} else {
-		xt_xlate_add(xl, "insert rule bridge %s %s ", p->table, p->chain);
-	}
+	xt_xlate_add(xl, "%s%s rule bridge %s %s ", tick,
+		     append ? "add" : "insert", p->table, p->chain);
 
 	ret = h->ops->xlate(cs, xl);
 	if (ret)
-		printf("%s\n", xt_xlate_get(xl));
+		printf("%s%s\n", xt_xlate_get(xl), tick);
+	else
+		printf("%s ", tick);
 
 	xt_xlate_free(xl);
 	return ret;
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 4e8db4bedff8..1f16e726d3a7 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -87,7 +87,6 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
 				.numeric	= numeric,
-				.escape_quotes	= !cs->restore,
 			};
 			ret = cs->target->xlate(xl, &params);
 		}
@@ -114,7 +113,6 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.ip		= (const void *)&cs->fw,
 			.match		= matchp->match->m,
 			.numeric	= numeric,
-			.escape_quotes	= !cs->restore,
 		};
 
 		if (!matchp->match->xlate)
@@ -150,6 +148,7 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 			      bool append)
 {
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
+	const char *tick = cs->restore ? "" : "\'";
 	const char *set;
 	int ret;
 
@@ -160,21 +159,20 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 
 	set = xt_xlate_set_get(xl);
 	if (set[0]) {
-		printf("add set %s %s %s\n", family2str[h->family], p->table,
-		       xt_xlate_set_get(xl));
+		printf("%sadd set %s %s %s%s\n",
+		       tick, family2str[h->family], p->table,
+		       xt_xlate_set_get(xl), tick);
 
 		if (!cs->restore && p->command != CMD_NONE)
 			printf("nft ");
 	}
 
-	if (append) {
-		printf("add rule %s %s %s ",
-		       family2str[h->family], p->table, p->chain);
-	} else {
-		printf("insert rule %s %s %s ",
-		       family2str[h->family], p->table, p->chain);
-	}
-	printf("%s\n", xt_xlate_rule_get(xl));
+	printf("%s%s rule %s %s %s ",
+	       tick,
+	       append ? "add" : "insert",
+	       family2str[h->family], p->table, p->chain);
+
+	printf("%s%s\n", xt_xlate_rule_get(xl), tick);
 
 err_out:
 	xt_xlate_free(xl);
-- 
2.38.1

