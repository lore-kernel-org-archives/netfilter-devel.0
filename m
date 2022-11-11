Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4651DC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 17:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiKKRcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiKKRcu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 12:32:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531935C779
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 09:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+iBL1VTTifBxCsplq3kKog4MZs+v5Cfd6kZ06Ffjnns=; b=b7ghpYjlGak7fbshbXaOUuiqz4
        0DNnaJaNgNeJjMMoJc5nPpRyNcOf9h2goC9tyKJFTy/ZDI3SWXcxAHGy8gOFAlLHaarcJCTS1x78H
        zXpwpGYDXsSJh0p8ncV2GsFnMX+0HrWNK4b09rKdEMfOOIyooTOq3UR7+Abho907RjpEjvqrsQ+z9
        lp38lyUCvGpPBbtOFWH3AKz+T13hgGDYc7FWohJbOLlcT0lvydIQEnIr8DTeK6ZloPdQ1yAy9KU+r
        bQWtxX7e0ZV3swAamWcIOXOvCQ3PXwPpevhca7ec4lTg5oC5bIPdt7Paeej9HeDEFNLzfDonlx78K
        kv1D87CA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1otXtW-0006Fc-O6; Fri, 11 Nov 2022 18:32:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] xt: Put match/target translation into own functions
Date:   Fri, 11 Nov 2022 18:32:21 +0100
Message-Id: <20221111173221.23631-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221111173221.23631-1-phil@nwl.cc>
References: <20221111173221.23631-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reduce the size and indenting level of xt_stmt_xlate() a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/xt.c | 142 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 66 deletions(-)

diff --git a/src/xt.c b/src/xt.c
index 9a326fd313233..db6463457467a 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -104,6 +104,73 @@ int xt_stmt_blob_decode(struct stmt *stmt, const char *b64_string,
 	return ret;
 }
 
+#ifdef HAVE_LIBXTABLES
+static bool xt_stmt_xlate_match(const struct stmt *stmt,
+			        void *entry, struct xt_xlate *xl)
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
+		fprintf(stderr, "XT match %s not found\n", stmt->xt.name);
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
+static bool xt_stmt_xlate_target(const struct stmt *stmt,
+			         void *entry, struct xt_xlate *xl)
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
+		fprintf(stderr, "XT target %s not found\n", stmt->xt.name);
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
@@ -115,11 +182,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
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
@@ -127,76 +190,23 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
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
+		xlated = xt_stmt_xlate_match(stmt, entry, xl);
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
+		xlated = xt_stmt_xlate_target(stmt, entry, xl);
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

