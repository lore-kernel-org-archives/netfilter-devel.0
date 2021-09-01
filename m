Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE45C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 14:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BBD61074
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 14:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhIAO6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Sep 2021 10:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhIAO6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Sep 2021 10:58:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC8CC061575
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Sep 2021 07:57:48 -0700 (PDT)
Received: from localhost ([::1]:44838 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mLRgP-0007jY-5H; Wed, 01 Sep 2021 16:57:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Fix error reporting for invalid syntax
Date:   Wed,  1 Sep 2021 16:58:19 +0200
Message-Id: <20210901145819.22567-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Errors emitted by the JSON parser caused BUG() in erec_print() due to
input descriptor values being bogus.

Due to lack of 'include' support, JSON parser uses a single input
descriptor only and it lived inside the json_ctx object on stack of
nft_parse_json_*() functions.

By the time errors are printed though, that scope is not valid anymore.
Move the static input descriptor object to avoid this.

Fixes: 586ad210368b7 ("libnftables: Implement JSON parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 666aa2fcc9ec3..3cd21175b2364 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -44,7 +44,6 @@
 #define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
 
 struct json_ctx {
-	struct input_descriptor indesc;
 	struct nft_ctx *nft;
 	struct list_head *msgs;
 	struct list_head *cmds;
@@ -107,11 +106,12 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root);
 /* parsing helpers */
 
 const struct location *int_loc = &internal_location;
+static struct input_descriptor json_indesc;
 
 static void json_lib_error(struct json_ctx *ctx, json_error_t *err)
 {
 	struct location loc = {
-		.indesc = &ctx->indesc,
+		.indesc = &json_indesc,
 		.line_offset = err->position - err->column,
 		.first_line = err->line,
 		.last_line = err->line,
@@ -3923,16 +3923,15 @@ int nft_parse_json_buffer(struct nft_ctx *nft, const char *buf,
 			  struct list_head *msgs, struct list_head *cmds)
 {
 	struct json_ctx ctx = {
-		.indesc = {
-			.type = INDESC_BUFFER,
-			.data = buf,
-		},
 		.nft = nft,
 		.msgs = msgs,
 		.cmds = cmds,
 	};
 	int ret;
 
+	json_indesc.type = INDESC_BUFFER;
+	json_indesc.data = buf;
+
 	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->json_root = json_loads(buf, 0, NULL);
 	if (!nft->json_root)
@@ -3951,10 +3950,6 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 			    struct list_head *msgs, struct list_head *cmds)
 {
 	struct json_ctx ctx = {
-		.indesc = {
-			.type = INDESC_FILE,
-			.name = filename,
-		},
 		.nft = nft,
 		.msgs = msgs,
 		.cmds = cmds,
@@ -3962,6 +3957,9 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	json_error_t err;
 	int ret;
 
+	json_indesc.type = INDESC_FILE;
+	json_indesc.name = filename;
+
 	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->json_root = json_load_file(filename, 0, &err);
 	if (!nft->json_root)
-- 
2.33.0

