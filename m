Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6CFC43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 13:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKXNt7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 08:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKXNt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 08:49:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CCA116060
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 05:49:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oyCbs-0000U7-UN; Thu, 24 Nov 2022 14:49:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 1/3] xlate: get rid of escape_quotes
Date:   Thu, 24 Nov 2022 14:49:37 +0100
Message-Id: <20221124134939.8245-2-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221124134939.8245-1-fw@strlen.de>
References: <20221124134939.8245-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its not necessary to escape " characters, we can simply
let xtables-translate print the entire translation/command
enclosed in '' chracters, i.e. nft 'add rule ...', this also takes
care of [, { and other special characters that some shells might
parse otherwise (when copy-pasting translated output).

This breaks all xlate test cases, fixup in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libebt_log.c         |  8 ++------
 extensions/libebt_nflog.c       |  8 ++------
 extensions/libxt_LOG.c          |  8 ++------
 extensions/libxt_NFLOG.c        | 12 ++++--------
 extensions/libxt_comment.c      |  7 +------
 extensions/libxt_helper.c       |  8 ++------
 include/xtables.h               |  2 --
 iptables/nft-bridge.c           |  2 --
 iptables/xtables-eb-translate.c |  7 ++++---
 iptables/xtables-translate.c    | 14 ++++++++++----
 10 files changed, 27 insertions(+), 49 deletions(-)

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
index e3f4290ba003..b6fe0b2edda1 100644
--- a/extensions/libxt_LOG.c
+++ b/extensions/libxt_LOG.c
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
index 9eba4f619d35..150d40bfafd9 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -211,14 +211,12 @@ struct xt_xlate_mt_params {
 	const void			*ip;
 	const struct xt_entry_match	*match;
 	int				numeric;
-	bool				escape_quotes;
 };
 
 struct xt_xlate_tg_params {
 	const void			*ip;
 	const struct xt_entry_target	*target;
 	int				numeric;
-	bool				escape_quotes;
 };
 
 /* Include file for additions: new matches and targets. */
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 4367d072906d..1a38ecccc9c9 100644
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
index f09883cd518c..0cf215b9c6b6 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -159,15 +159,16 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
 	int ret;
 
 	if (append) {
-		xt_xlate_add(xl, "add rule bridge %s %s ", p->table, p->chain);
+		xt_xlate_add(xl, "'add rule bridge %s %s ", p->table, p->chain);
 	} else {
-		xt_xlate_add(xl, "insert rule bridge %s %s ", p->table, p->chain);
+		xt_xlate_add(xl, "'insert rule bridge %s %s ", p->table, p->chain);
 	}
 
 	ret = h->ops->xlate(cs, xl);
 	if (ret)
-		printf("%s\n", xt_xlate_get(xl));
+		printf("%s", xt_xlate_get(xl));
 
+	puts("'");
 	xt_xlate_free(xl);
 	return ret;
 }
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index d1e87f167df7..0589ac229746 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -88,7 +88,6 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
 				.numeric	= numeric,
-				.escape_quotes	= !cs->restore,
 			};
 			ret = cs->target->xlate(xl, &params);
 		}
@@ -115,7 +114,6 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.ip		= (const void *)&cs->fw,
 			.match		= matchp->match->m,
 			.numeric	= numeric,
-			.escape_quotes	= !cs->restore,
 		};
 
 		if (!matchp->match->xlate)
@@ -165,13 +163,16 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 
 	set = xt_xlate_set_get(xl);
 	if (set[0]) {
-		printf("add set %s %s %s\n", family2str[h->family], p->table,
+		printf("'add set %s %s %s'\n", family2str[h->family], p->table,
 		       xt_xlate_set_get(xl));
 
 		if (!cs->restore && p->command != CMD_NONE)
 			printf("nft ");
 	}
 
+	if (!cs->restore)
+		printf("%c", '\'');
+
 	if (append) {
 		printf("add rule %s %s %s ",
 		       family2str[h->family], p->table, p->chain);
@@ -179,7 +180,12 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 		printf("insert rule %s %s %s ",
 		       family2str[h->family], p->table, p->chain);
 	}
-	printf("%s\n", xt_xlate_rule_get(xl));
+	printf("%s", xt_xlate_rule_get(xl));
+
+	if (!cs->restore)
+		printf("%c", '\'');
+
+	puts("");
 
 err_out:
 	xt_xlate_free(xl);
-- 
2.37.4

