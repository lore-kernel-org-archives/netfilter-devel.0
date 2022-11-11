Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6658C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 17:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiKKRcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 12:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiKKRce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 12:32:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BC11A815
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 09:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FIZYluGn3o/zKANKRf9lcK45kN37XaErEGmiMkpYuP0=; b=pRF3daHWiq9Ch5ysB2cciAcHUh
        aOYreAnqo2jhS/8Mp0AjlZz9+BtZcKr2L66PNLLJDeNFL0/NSdjypNcWIfxpJYSg4LPy4Wj0adWml
        pkyGLckHHrE0eWJL5w6vYU/UkzCiwha28nzeSy3w2mn2opV13NJcbQIcuDU8EPssvuGe3uzcIi4hy
        3IybV8xFS0m+VgE2cXx/kMoTa83QIIcB/0KyZwa6ZN8Oa/s0judYmRYK/ODZjPiiztG9PfUbfqzTK
        sRlLXSlBoXxyrDXoPDkCCpNz3wlFc8mWJkCei1DKowEpdHQHgkhR+FCqnMFPqLBXZWNUR+w+KIEvi
        kK5SHb8g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1otXtG-0006F6-F3; Fri, 11 Nov 2022 18:32:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] xt: Delay libxtables access until translation
Date:   Fri, 11 Nov 2022 18:32:19 +0100
Message-Id: <20221111173221.23631-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221111173221.23631-1-phil@nwl.cc>
References: <20221111173221.23631-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no point in spending efforts setting up the xt match/target
when it is not printed afterwards. So just store the statement data from
libnftnl in struct xt_stmt and perform the extension lookup from
xt_stmt_xlate() instead.

This means some data structures are only temporarily allocated for the
sake of passing to libxtables callbacks, no need to drag them around.
Also no need to clone the looked up extension, it is needed only to call
the functions it provides.

While being at it, select numeric output in xt_xlate_*_params -
otherwise there will be reverse DNS lookups which should not happen by
default.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/statement.h |   9 +--
 src/xt.c            | 192 ++++++++++++++++++--------------------------
 2 files changed, 80 insertions(+), 121 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 2a2d300106181..8651fc78892c9 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -264,12 +264,11 @@ struct xtables_target;
 struct xt_stmt {
 	const char			*name;
 	enum nft_xt_type		type;
+	uint32_t			rev;
+	uint32_t			family;
+	size_t				infolen;
+	void				*info;
 	uint32_t			proto;
-	union {
-		struct xtables_match	*match;
-		struct xtables_target	*target;
-	};
-	void				*entry;
 };
 
 extern struct stmt *xt_stmt_alloc(const struct location *loc);
diff --git a/src/xt.c b/src/xt.c
index 789de9926261b..f14f40157ba10 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -28,51 +28,94 @@
 
 #ifdef HAVE_LIBXTABLES
 #include <xtables.h>
+
+static void *xt_entry_alloc(const struct xt_stmt *xt, uint32_t af);
 #endif
 
 void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 {
 #ifdef HAVE_LIBXTABLES
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
+	struct xtables_target *tg;
+	struct xt_entry_target *t;
+	struct xtables_match *mt;
+	struct xt_entry_match *m;
+	size_t size;
+	void *entry;
+
+	xtables_set_nfproto(stmt->xt.family);
+	entry = xt_entry_alloc(&stmt->xt, stmt->xt.family);
 
 	switch (stmt->xt.type) {
 	case NFT_XT_MATCH:
-		if (stmt->xt.match->xlate) {
+		mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
+		if (!mt) {
+			fprintf(stderr, "XT match %s not found\n",
+				stmt->xt.name);
+			return;
+		}
+		size = XT_ALIGN(sizeof(*m)) + stmt->xt.infolen;
+
+		m = xzalloc(size);
+		memcpy(&m->data, stmt->xt.info, stmt->xt.infolen);
+
+		m->u.match_size = size;
+		m->u.user.revision = stmt->xt.rev;
+
+		if (mt->xlate) {
 			struct xt_xlate_mt_params params = {
-				.ip		= stmt->xt.entry,
-				.match		= stmt->xt.match->m,
-				.numeric        = 0,
+				.ip		= entry,
+				.match		= m,
+				.numeric        = 1,
 			};
 
-			stmt->xt.match->xlate(xl, &params);
+			mt->xlate(xl, &params);
 			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (stmt->xt.match->print) {
+		} else if (mt->print) {
 			printf("#");
-			stmt->xt.match->print(&stmt->xt.entry,
-					      stmt->xt.match->m, 0);
+			mt->print(&entry, m, 0);
 		}
+		xfree(m);
 		break;
 	case NFT_XT_WATCHER:
 	case NFT_XT_TARGET:
-		if (stmt->xt.target->xlate) {
+		tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
+		if (!tg) {
+			fprintf(stderr, "XT target %s not found\n",
+				stmt->xt.name);
+			return;
+		}
+		size = XT_ALIGN(sizeof(*t)) + stmt->xt.infolen;
+
+		t = xzalloc(size);
+		memcpy(&t->data, stmt->xt.info, stmt->xt.infolen);
+
+		t->u.target_size = size;
+		t->u.user.revision = stmt->xt.rev;
+
+		strcpy(t->u.user.name, tg->name);
+
+		if (tg->xlate) {
 			struct xt_xlate_tg_params params = {
-				.ip		= stmt->xt.entry,
-				.target		= stmt->xt.target->t,
-				.numeric        = 0,
+				.ip		= entry,
+				.target		= t,
+				.numeric        = 1,
 			};
 
-			stmt->xt.target->xlate(xl, &params);
+			tg->xlate(xl, &params);
 			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (stmt->xt.target->print) {
+		} else if (tg->print) {
 			printf("#");
-			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
+			tg->print(NULL, t, 0);
 		}
+		xfree(t);
 		break;
 	default:
 		break;
 	}
 
 	xt_xlate_free(xl);
+	xfree(entry);
 #else
 	nft_print(octx, "# xt_%s", stmt->xt.name);
 #endif
@@ -80,33 +123,12 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 void xt_stmt_destroy(struct stmt *stmt)
 {
-#ifdef HAVE_LIBXTABLES
-	switch (stmt->xt.type) {
-	case NFT_XT_MATCH:
-		if (!stmt->xt.match)
-			break;
-		if (stmt->xt.match->m)
-			xfree(stmt->xt.match->m);
-		xfree(stmt->xt.match);
-		break;
-	case NFT_XT_WATCHER:
-	case NFT_XT_TARGET:
-		if (!stmt->xt.target)
-			break;
-		if (stmt->xt.target->t)
-			xfree(stmt->xt.target->t);
-		xfree(stmt->xt.target);
-		break;
-	default:
-		break;
-	}
-#endif
-	xfree(stmt->xt.entry);
 	xfree(stmt->xt.name);
+	xfree(stmt->xt.info);
 }
 
 #ifdef HAVE_LIBXTABLES
-static void *xt_entry_alloc(struct xt_stmt *xt, uint32_t af)
+static void *xt_entry_alloc(const struct xt_stmt *xt, uint32_t af)
 {
 	union nft_entry {
 		struct ipt_entry ipt;
@@ -173,24 +195,6 @@ static uint32_t xt_proto(const struct proto_ctx *pctx)
 
 	return 0;
 }
-
-static struct xtables_target *xt_target_clone(struct xtables_target *t)
-{
-	struct xtables_target *clone;
-
-	clone = xzalloc(sizeof(struct xtables_target));
-	memcpy(clone, t, sizeof(struct xtables_target));
-	return clone;
-}
-
-static struct xtables_match *xt_match_clone(struct xtables_match *m)
-{
-	struct xtables_match *clone;
-
-	clone = xzalloc(sizeof(struct xtables_match));
-	memcpy(clone, m, sizeof(struct xtables_match));
-	return clone;
-}
 #endif
 
 /*
@@ -201,43 +205,22 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 			 const struct location *loc,
 			 const struct nftnl_expr *nle)
 {
-	struct stmt *stmt;
-	const char *name;
-#ifdef HAVE_LIBXTABLES
-	struct xtables_match *mt;
 	const char *mtinfo;
-	struct xt_entry_match *m;
+	struct stmt *stmt;
 	uint32_t mt_len;
 
-	xtables_set_nfproto(ctx->table->handle.family);
-
-	name = nftnl_expr_get_str(nle, NFTNL_EXPR_MT_NAME);
-
-	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
-	if (!mt) {
-		fprintf(stderr, "XT match %s not found\n", name);
-		return;
-	}
 	mtinfo = nftnl_expr_get(nle, NFTNL_EXPR_MT_INFO, &mt_len);
 
-	m = xzalloc(sizeof(struct xt_entry_match) + mt_len);
-	memcpy(&m->data, mtinfo, mt_len);
-
-	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
-	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
-
 	stmt = xt_stmt_alloc(loc);
-	stmt->xt.name = strdup(name);
+	stmt->xt.name = strdup(nftnl_expr_get_str(nle, NFTNL_EXPR_MT_NAME));
 	stmt->xt.type = NFT_XT_MATCH;
-	stmt->xt.match = xt_match_clone(mt);
-	stmt->xt.match->m = m;
-#else
-	name = nftnl_expr_get_str(nle, NFTNL_EXPR_MT_NAME);
+	stmt->xt.rev = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
+	stmt->xt.family = ctx->table->handle.family;
+
+	stmt->xt.infolen = mt_len;
+	stmt->xt.info = xmalloc(mt_len);
+	memcpy(stmt->xt.info, mtinfo, mt_len);
 
-	stmt = xt_stmt_alloc(loc);
-	stmt->xt.name = strdup(name);
-	stmt->xt.type = NFT_XT_MATCH;
-#endif
 	rule_stmt_append(ctx->rule, stmt);
 }
 
@@ -245,44 +228,22 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 			  const struct location *loc,
 			  const struct nftnl_expr *nle)
 {
-	struct stmt *stmt;
-	const char *name;
-#ifdef HAVE_LIBXTABLES
-	struct xtables_target *tg;
 	const void *tginfo;
-	struct xt_entry_target *t;
-	size_t size;
+	struct stmt *stmt;
 	uint32_t tg_len;
 
-	xtables_set_nfproto(ctx->table->handle.family);
-
-	name = nftnl_expr_get_str(nle, NFTNL_EXPR_TG_NAME);
-	tg = xtables_find_target(name, XTF_TRY_LOAD);
-	if (!tg) {
-		fprintf(stderr, "XT target %s not found\n", name);
-		return;
-	}
 	tginfo = nftnl_expr_get(nle, NFTNL_EXPR_TG_INFO, &tg_len);
 
-	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
-	t = xzalloc(size);
-	memcpy(&t->data, tginfo, tg_len);
-	t->u.target_size = size;
-	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
-	strcpy(t->u.user.name, tg->name);
-
 	stmt = xt_stmt_alloc(loc);
-	stmt->xt.name = strdup(name);
+	stmt->xt.name = strdup(nftnl_expr_get_str(nle, NFTNL_EXPR_TG_NAME));
 	stmt->xt.type = NFT_XT_TARGET;
-	stmt->xt.target = xt_target_clone(tg);
-	stmt->xt.target->t = t;
-#else
-	name = nftnl_expr_get_str(nle, NFTNL_EXPR_TG_NAME);
+	stmt->xt.rev = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
+	stmt->xt.family = ctx->table->handle.family;
+
+	stmt->xt.infolen = tg_len;
+	stmt->xt.info = xmalloc(tg_len);
+	memcpy(stmt->xt.info, tginfo, tg_len);
 
-	stmt = xt_stmt_alloc(loc);
-	stmt->xt.name = strdup(name);
-	stmt->xt.type = NFT_XT_TARGET;
-#endif
 	rule_stmt_append(ctx->rule, stmt);
 }
 
@@ -309,7 +270,6 @@ void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
 		stmt->xt.type = NFT_XT_WATCHER;
 
 	stmt->xt.proto = xt_proto(&rctx->pctx);
-	stmt->xt.entry = xt_entry_alloc(&stmt->xt, rctx->pctx.family);
 }
 
 static int nft_xt_compatible_revision(const char *name, uint8_t rev, int opt)
-- 
2.38.0

