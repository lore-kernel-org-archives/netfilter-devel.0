Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3C9C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Nov 2022 17:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiKQRqO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Nov 2022 12:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKQRqO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Nov 2022 12:46:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F076710D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2022 09:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DT/eXSVYPX4WugtCYvwZXfSl83mx8tTUYSIxnlm9wVw=; b=MvGUbx5oQQphsn7ngLc4/Ju+Jl
        9hQLQbEgf35vY9Z7yLqKGQf9Wsg/9yQELsw2hav8aIZimdlN4TRskO0HlMEFMCWUFTA6g0O2S8Dfz
        YxQ60wl1CGg63/hIpFQA2oCew/9Bje2j6H936fyPdPMAyWNxz8y/VSwVG/+Pr2drbZ/fUxczwxqSr
        TM/FsyORZfHD6bWlEO0ep15kgyjZW4uSAGGw7ghNgbk5+/HU2Zsd2NdD10Jr71+9JgSvQCXio+kif
        scP/qYSfg2guE856aHxnyvw9stqMS8IOvnJvLeFMy3llfwlqYIWCSfJgiHc8eO8RHvx1i5ArHyhNC
        NYHWZ2qw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ovixn-0001kT-Gv; Thu, 17 Nov 2022 18:46:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 3/4] xt: Put match/target translation into own functions
Date:   Thu, 17 Nov 2022 18:45:45 +0100
Message-Id: <20221117174546.21715-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221117174546.21715-1-phil@nwl.cc>
References: <20221117174546.21715-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reduce the size and indenting level of xt_stmt_xlate() a bit, also fix
for error printing to stderr irrespective of octx->error_fp value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Change fprintf() calls to respect octx.
---
 src/xt.c | 144 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 78 insertions(+), 66 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index 9a326fd313233..e3063612c353e 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -104,6 +104,75 @@ int xt_stmt_blob_decode(struct stmt *stmt, const char *b64_string,
 	return ret;
 }
 
+#ifdef HAVE_LIBXTABLES
+static bool xt_stmt_xlate_match(const struct stmt *stmt, void *entry,
+				struct xt_xlate *xl, struct output_ctx *octx)
+{
+	size_t size = XT_ALIGN(sizeof(struct xt_entry_match))
+			+ stmt->xt.infolen;
+	struct xt_xlate_mt_params params = {
+		.ip		= entry,
+		.numeric        = 1,
+	};
+	struct xtables_match *mt;
+	struct xt_entry_match *m;
+
+	mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
+	if (!mt) {
+		fprintf(octx->error_fp,
+			"XT match %s not found\n", stmt->xt.name);
+		return false;
+	}
+	if (!mt->xlate)
+		return false;
+
+	m = xzalloc(size);
+	m->u.match_size = size;
+	m->u.user.revision = stmt->xt.rev;
+	memcpy(&m->data, stmt->xt.info, stmt->xt.infolen);
+
+	params.match = m;
+	mt->xlate(xl, &params);
+
+	xfree(m);
+	return true;
+}
+
+static bool xt_stmt_xlate_target(const struct stmt *stmt, void *entry,
+				 struct xt_xlate *xl, struct output_ctx *octx)
+{
+	size_t size = XT_ALIGN(sizeof(struct xt_entry_target))
+			+ stmt->xt.infolen;
+	struct xt_xlate_tg_params params = {
+		.ip		= entry,
+		.numeric        = 1,
+	};
+	struct xtables_target *tg;
+	struct xt_entry_target *t;
+
+	tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
+	if (!tg) {
+		fprintf(octx->error_fp,
+			"XT target %s not found\n", stmt->xt.name);
+		return false;
+	}
+	if (!tg->xlate)
+		return false;
+
+	t = xzalloc(size);
+	t->u.target_size = size;
+	t->u.user.revision = stmt->xt.rev;
+	memcpy(&t->data, stmt->xt.info, stmt->xt.infolen);
+	strcpy(t->u.user.name, tg->name);
+
+	params.target = t;
+	tg->xlate(xl, &params);
+
+	xfree(t);
+	return true;
+}
+#endif
+
 void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 {
 	static const char *xt_typename[] = {
@@ -115,11 +184,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 	unsigned char *b64_buf;
 #ifdef HAVE_LIBXTABLES
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
-	struct xtables_target *tg;
-	struct xt_entry_target *t;
-	struct xtables_match *mt;
-	struct xt_entry_match *m;
-	size_t size;
+	bool xlated = false;
 	void *entry;
 
 	xtables_set_nfproto(stmt->xt.family);
@@ -127,76 +192,23 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 	switch (stmt->xt.type) {
 	case NFT_XT_MATCH:
-		mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
-		if (!mt) {
-			fprintf(stderr, "XT match %s not found\n",
-				stmt->xt.name);
-			return;
-		}
-		size = XT_ALIGN(sizeof(*m)) + stmt->xt.infolen;
-
-		m = xzalloc(size);
-		memcpy(&m->data, stmt->xt.info, stmt->xt.infolen);
-
-		m->u.match_size = size;
-		m->u.user.revision = stmt->xt.rev;
-
-		if (mt->xlate) {
-			struct xt_xlate_mt_params params = {
-				.ip		= entry,
-				.match		= m,
-				.numeric        = 1,
-			};
-
-			mt->xlate(xl, &params);
-			nft_print(octx, "%s", xt_xlate_get(xl));
-			xfree(m);
-			xfree(entry);
-			xt_xlate_free(xl);
-			return;
-		}
-		xfree(m);
+		xlated = xt_stmt_xlate_match(stmt, entry, xl, octx);
 		break;
 	case NFT_XT_WATCHER:
 	case NFT_XT_TARGET:
-		tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
-		if (!tg) {
-			fprintf(stderr, "XT target %s not found\n",
-				stmt->xt.name);
-			return;
-		}
-		size = XT_ALIGN(sizeof(*t)) + stmt->xt.infolen;
-
-		t = xzalloc(size);
-		memcpy(&t->data, stmt->xt.info, stmt->xt.infolen);
-
-		t->u.target_size = size;
-		t->u.user.revision = stmt->xt.rev;
-
-		strcpy(t->u.user.name, tg->name);
-
-		if (tg->xlate) {
-			struct xt_xlate_tg_params params = {
-				.ip		= entry,
-				.target		= t,
-				.numeric        = 1,
-			};
-
-			tg->xlate(xl, &params);
-			nft_print(octx, "%s", xt_xlate_get(xl));
-			xfree(t);
-			xfree(entry);
-			xt_xlate_free(xl);
-			return;
-		}
-		xfree(t);
+		xlated = xt_stmt_xlate_target(stmt, entry, xl, octx);
 		break;
 	default:
 		break;
 	}
 
-	xt_xlate_free(xl);
 	xfree(entry);
+	if (xlated) {
+		nft_print(octx, "%s", xt_xlate_get(xl));
+		xt_xlate_free(xl);
+		return;
+	}
+	xt_xlate_free(xl);
 #endif
 	b64_buf = xt_stmt_blob_encode(stmt);
 	nft_print(octx, "xt %s %s %s",
-- 
2.38.0

