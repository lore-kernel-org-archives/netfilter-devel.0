Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBD4C6FD18
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Apr 2023 08:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjDYIqk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 04:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbjDYIqZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 04:46:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C80D2D301
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2023 01:44:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] json: allow to specify comment on chain
Date:   Tue, 25 Apr 2023 10:44:27 +0200
Message-Id: <20230425084427.220768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow users to add a comment when declaring a chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/json.c        |  3 +++
 src/parser_json.c | 24 +++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/src/json.c b/src/json.c
index ae00055d71f5..1b42ebc06dd3 100644
--- a/src/json.c
+++ b/src/json.c
@@ -263,6 +263,9 @@ static json_t *chain_print_json(const struct chain *chain)
 			 "name", chain->handle.chain.name,
 			 "handle", chain->handle.handle.id);
 
+	if (chain->comment)
+		json_object_set_new(root, "comment", json_string(chain->comment));
+
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		mpz_export_data(&priority, chain->priority.expr->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
diff --git a/src/parser_json.c b/src/parser_json.c
index 95f6bdcd943d..95720b448103 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2851,17 +2851,19 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	struct handle h = {
 		.table.location = *int_loc,
 	};
-	const char *family = "", *policy = "", *type, *hookstr, *name;
-	struct chain *chain;
+	const char *family = "", *policy = "", *type, *hookstr, *name, *comment = NULL;
+	struct chain *chain = NULL;
 	int prio;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name))
 		return NULL;
-	if (op != CMD_DELETE &&
-	    json_unpack_err(ctx, root, "{s:s}", "name", &h.chain.name)) {
-		return NULL;
+	if (op != CMD_DELETE) {
+		if (json_unpack_err(ctx, root, "{s:s}", "name", &h.chain.name))
+			return NULL;
+
+		json_unpack(root, "{s:s}", "comment", &comment);
 	} else if (op == CMD_DELETE &&
 		   json_unpack(root, "{s:s}", "name", &h.chain.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
@@ -2876,14 +2878,22 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	if (h.chain.name)
 		h.chain.name = xstrdup(h.chain.name);
 
+	if (comment) {
+		chain = chain_alloc(NULL);
+		handle_merge(&chain->handle, &h);
+		chain->comment = xstrdup(comment);
+	}
+
 	if (op == CMD_DELETE ||
 	    op == CMD_LIST ||
 	    op == CMD_FLUSH ||
 	    json_unpack(root, "{s:s, s:s, s:i}",
 			"type", &type, "hook", &hookstr, "prio", &prio))
-		return cmd_alloc(op, obj, &h, int_loc, NULL);
+		return cmd_alloc(op, obj, &h, int_loc, chain);
+
+	if (!comment)
+		chain = chain_alloc(NULL);
 
-	chain = chain_alloc(NULL);
 	chain->flags |= CHAIN_F_BASECHAIN;
 	chain->type.str = xstrdup(type);
 	chain->priority.expr = constant_expr_alloc(int_loc, &integer_type,
-- 
2.30.2

