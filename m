Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FA3C00528
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 23:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjHDXP5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjHDXPy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 19:15:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03F7E60
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 16:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qa8GiFRmwZTnc653Ok4NDvj+uf+0V1JKcWUx9KXHn4Y=; b=FqYiMPuMhh6VGMoo/+m+XrrhJW
        iEOky5IcGW8eKmIvcN4Fr0oAQV+C4Be20Q7wJmfkjpksUjuXZu1ftX3eYnGvcSmlrDBnupO5kPtMg
        JX9wh5scKg7UAHd/Ax3gk56Bfr3/MvwD5FhXPP0gb/pIUBQCeMr+qg4+bzL9JHTZ8JEjhJE/OEt1W
        B8YzUxRHa6I36SF5GrsNczqjUXw9mwCk6jdZgfMvWQLPSY8RGbL4xuTWIiPzrIPOfB9o6M5Re1+8h
        R1o/a3HG0lB+8TKJHLZ+uejPeT1xWjDHYCbK64xxO7hBcgMuoRBt/rGIsPu34oVEG80ku9io6ZgJa
        jA0K7/IQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qS41P-0008KK-7G; Sat, 05 Aug 2023 01:15:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 1/2] nft-ruleparse: Introduce nft_create_target()
Date:   Sat,  5 Aug 2023 01:15:36 +0200
Message-Id: <20230804231537.17705-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Like nft_create_match(), this is a small wrapper around the typical
target extension lookup and (standard) init code.

To use it from nft_parse_target() and nft_parse_log(), introduce an
inner variant which accepts the target payload size as parameter.

The call to rule_parse_ops::target callback was problematic with
standard target, because the callbacks initialized
iptables_command_state::jumpto with the target name, "standard" in that
case. Perform its tasks in nft_create_target(), keep it only for bridge
family's special handling of watcher "targets".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse-arp.c    |   1 -
 iptables/nft-ruleparse-bridge.c |   5 +-
 iptables/nft-ruleparse-ipv4.c   |   1 -
 iptables/nft-ruleparse-ipv6.c   |   1 -
 iptables/nft-ruleparse.c        | 126 ++++++++++++--------------------
 iptables/nft-ruleparse.h        |   5 +-
 6 files changed, 52 insertions(+), 87 deletions(-)

diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index b68fb06d8e0f9..d80ca922955cf 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -164,5 +164,4 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 struct nft_ruleparse_ops nft_ruleparse_ops_arp = {
 	.meta		= nft_arp_parse_meta,
 	.payload	= nft_arp_parse_payload,
-	.target		= nft_ipv46_parse_target,
 };
diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridge.c
index 50fb92833046a..c6cc9af5ea198 100644
--- a/iptables/nft-ruleparse-bridge.c
+++ b/iptables/nft-ruleparse-bridge.c
@@ -406,11 +406,10 @@ static void nft_bridge_parse_target(struct xtables_target *t,
 	if (strcmp(t->name, "log") == 0 ||
 	    strcmp(t->name, "nflog") == 0) {
 		parse_watcher(t, &cs->match_list, false);
+		cs->jumpto = NULL;
+		cs->target = NULL;
 		return;
 	}
-
-	cs->target = t;
-	cs->jumpto = t->name;
 }
 
 struct nft_ruleparse_ops nft_ruleparse_ops_bridge = {
diff --git a/iptables/nft-ruleparse-ipv4.c b/iptables/nft-ruleparse-ipv4.c
index c87e159cc5fec..491cbf42c7754 100644
--- a/iptables/nft-ruleparse-ipv4.c
+++ b/iptables/nft-ruleparse-ipv4.c
@@ -131,5 +131,4 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 struct nft_ruleparse_ops nft_ruleparse_ops_ipv4 = {
 	.meta		= nft_ipv4_parse_meta,
 	.payload	= nft_ipv4_parse_payload,
-	.target		= nft_ipv46_parse_target,
 };
diff --git a/iptables/nft-ruleparse-ipv6.c b/iptables/nft-ruleparse-ipv6.c
index af55420b73766..7581b8636e601 100644
--- a/iptables/nft-ruleparse-ipv6.c
+++ b/iptables/nft-ruleparse-ipv6.c
@@ -108,5 +108,4 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 struct nft_ruleparse_ops nft_ruleparse_ops_ipv6 = {
 	.meta		= nft_ipv6_parse_meta,
 	.payload	= nft_ipv6_parse_payload,
-	.target		= nft_ipv46_parse_target,
 };
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index edbbfa40e9c43..a5eb6d098084a 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -84,6 +84,40 @@ nft_create_match(struct nft_xt_ctx *ctx,
 	return match->m->data;
 }
 
+static void *
+__nft_create_target(struct nft_xt_ctx *ctx, const char *name, size_t tgsize)
+{
+	struct xtables_target *target;
+	size_t size;
+
+	target = xtables_find_target(name, XTF_TRY_LOAD);
+	if (!target)
+		return NULL;
+
+	size = XT_ALIGN(sizeof(*target->t)) + tgsize ?: target->size;
+
+	target->t = xtables_calloc(1, size);
+	target->t->u.target_size = size;
+	target->t->u.user.revision = target->revision;
+	strcpy(target->t->u.user.name, name);
+
+	xs_init_target(target);
+
+	ctx->cs->jumpto = name;
+	ctx->cs->target = target;
+
+	if (ctx->h->ops->rule_parse->target)
+		ctx->h->ops->rule_parse->target(target, ctx->cs);
+
+	return target->t->data;
+}
+
+void *
+nft_create_target(struct nft_xt_ctx *ctx, const char *name)
+{
+	return __nft_create_target(ctx, name, 0);
+}
+
 static void nft_parse_counter(struct nftnl_expr *e, struct xt_counters *counters)
 {
 	counters->pcnt = nftnl_expr_get_u64(e, NFTNL_EXPR_CTR_PACKETS);
@@ -123,11 +157,8 @@ static bool nft_parse_meta_set_common(struct nft_xt_ctx* ctx,
 static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 			       struct nftnl_expr *e)
 {
-	struct xtables_target *target;
 	struct nft_xt_ctx_reg *sreg;
 	enum nft_registers sregnum;
-	struct xt_entry_target *t;
-	unsigned int size;
 	const char *targname;
 
 	sregnum = nftnl_expr_get_u32(e, NFTNL_EXPR_META_SREG);
@@ -153,22 +184,8 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 		return;
 	}
 
-	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target == NULL) {
+	if (!nft_create_target(ctx, targname))
 		ctx->errmsg = "target TRACE not found";
-		return;
-	}
-
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + target->size;
-
-	t = xtables_calloc(1, size);
-	t->u.target_size = size;
-	t->u.user.revision = target->revision;
-	strcpy(t->u.user.name, targname);
-
-	target->t = t;
-
-	ctx->h->ops->rule_parse->target(target, ctx->cs);
 }
 
 static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -515,8 +532,6 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	const char *chain = nftnl_expr_get_str(e, NFTNL_EXPR_IMM_CHAIN);
 	struct iptables_command_state *cs = ctx->cs;
-	struct xt_entry_target *t;
-	uint32_t size;
 	int verdict;
 
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_IMM_DATA)) {
@@ -566,18 +581,8 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		return;
 	}
 
-	cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
-	if (!cs->target) {
+	if (!nft_create_target(ctx, cs->jumpto))
 		ctx->errmsg = "verdict extension not found";
-		return;
-	}
-
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + cs->target->size;
-	t = xtables_calloc(1, size);
-	t->u.target_size = size;
-	t->u.user.revision = cs->target->revision;
-	strcpy(t->u.user.name, cs->jumpto);
-	cs->target->t = t;
 }
 
 static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -624,27 +629,13 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	uint32_t tg_len;
 	const char *targname = nftnl_expr_get_str(e, NFTNL_EXPR_TG_NAME);
 	const void *targinfo = nftnl_expr_get(e, NFTNL_EXPR_TG_INFO, &tg_len);
-	struct xtables_target *target;
-	struct xt_entry_target *t;
-	size_t size;
+	void *data;
 
-	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target == NULL) {
+	data = __nft_create_target(ctx, targname, tg_len);
+	if (!data)
 		ctx->errmsg = "target extension not found";
-		return;
-	}
-
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
-
-	t = xtables_calloc(1, size);
-	memcpy(&t->data, targinfo, tg_len);
-	t->u.target_size = size;
-	t->u.user.revision = nftnl_expr_get_u32(e, NFTNL_EXPR_TG_REV);
-	strcpy(t->u.user.name, target->name);
-
-	target->t = t;
-
-	ctx->h->ops->rule_parse->target(target, ctx->cs);
+	else
+		memcpy(data, targinfo, tg_len);
 }
 
 static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -684,9 +675,6 @@ static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 
 static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
-	struct xtables_target *target;
-	struct xt_entry_target *t;
-	size_t target_size;
 	/*
 	 * In order to handle the longer log-prefix supported by nft, instead of
 	 * using struct xt_nflog_info, we use a struct with a compatible layout, but
@@ -703,6 +691,8 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		.group     = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_GROUP),
 		.threshold = nftnl_expr_get_u16(e, NFTNL_EXPR_LOG_QTHRESHOLD),
 	};
+	void *data;
+
 	if (nftnl_expr_is_set(e, NFTNL_EXPR_LOG_SNAPLEN)) {
 		info.len = nftnl_expr_get_u32(e, NFTNL_EXPR_LOG_SNAPLEN);
 		info.flags = XT_NFLOG_F_COPY_LEN;
@@ -711,25 +701,12 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		snprintf(info.prefix, sizeof(info.prefix), "%s",
 			 nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
 
-	target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
-	if (target == NULL) {
+	data = __nft_create_target(ctx, "NFLOG",
+				   XT_ALIGN(sizeof(struct xt_nflog_info_nft)));
+	if (!data)
 		ctx->errmsg = "NFLOG target extension not found";
-		return;
-	}
-
-	target_size = XT_ALIGN(sizeof(struct xt_entry_target)) +
-		      XT_ALIGN(sizeof(struct xt_nflog_info_nft));
-
-	t = xtables_calloc(1, target_size);
-	t->u.target_size = target_size;
-	strcpy(t->u.user.name, target->name);
-	t->u.user.revision = target->revision;
-
-	target->t = t;
-
-	memcpy(&target->t->data, &info, sizeof(info));
-
-	ctx->h->ops->rule_parse->target(target, ctx->cs);
+	else
+		memcpy(data, &info, sizeof(info));
 }
 
 static void nft_parse_udp_range(struct nft_xt_ctx *ctx,
@@ -1137,13 +1114,6 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	return 0;
 }
 
-void nft_ipv46_parse_target(struct xtables_target *t,
-			    struct iptables_command_state *cs)
-{
-	cs->target = t;
-	cs->jumpto = t->name;
-}
-
 int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		 struct iptables_command_state *cs)
 {
diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index fd083c08ff343..25ce05d2e8644 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -117,6 +117,8 @@ extern struct nft_ruleparse_ops nft_ruleparse_ops_ipv6;
 void *nft_create_match(struct nft_xt_ctx *ctx,
 		       struct iptables_command_state *cs,
 		       const char *name, bool reuse);
+void *nft_create_target(struct nft_xt_ctx *ctx, const char *name);
+
 
 bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
@@ -129,9 +131,6 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       char *iniface, unsigned char *iniface_mask, char *outiface,
 	       unsigned char *outiface_mask, uint8_t *invflags);
 
-void nft_ipv46_parse_target(struct xtables_target *t,
-			    struct iptables_command_state *cs);
-
 int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		 struct iptables_command_state *cs);
 
-- 
2.40.0

