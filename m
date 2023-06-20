Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2E0EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 10:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjFTKd7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjFTKd6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 06:33:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC6BECE
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 03:33:56 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add json support for last statement
Date:   Tue, 20 Jun 2023 12:33:52 +0200
Message-Id: <20230620103352.80728-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds json support for the last statement, it works for me here.

However, tests/py still displays a warning:

any/last.t: WARNING: line 12: '{"nftables": [{"add": {"rule": {"family": "ip", "table": "test-ip4", "chain": "input", "expr": [{"last": {"used": 300000}}]}}}]}': '[{"last": {"used": 300000}}]' mismatches '[{"last": null}]'

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/json.h           |  2 ++
 src/json.c               |  8 ++++++++
 src/parser_json.c        | 22 ++++++++++++++++++++++
 src/statement.c          |  1 +
 tests/py/any/last.t.json | 16 ++++++++++++++++
 5 files changed, 49 insertions(+)
 create mode 100644 tests/py/any/last.t.json

diff --git a/include/json.h b/include/json.h
index f691678d4d72..da605ed9e83d 100644
--- a/include/json.h
+++ b/include/json.h
@@ -74,6 +74,7 @@ json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *exthdr_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *quota_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *ct_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *last_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *limit_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *fwd_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *notrack_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
@@ -177,6 +178,7 @@ STMT_PRINT_STUB(payload)
 STMT_PRINT_STUB(exthdr)
 STMT_PRINT_STUB(quota)
 STMT_PRINT_STUB(ct)
+STMT_PRINT_STUB(last)
 STMT_PRINT_STUB(limit)
 STMT_PRINT_STUB(fwd)
 STMT_PRINT_STUB(notrack)
diff --git a/src/json.c b/src/json.c
index 981d177b75d4..305eb6e397fe 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1482,6 +1482,14 @@ json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 			 "bytes", stmt->counter.bytes);
 }
 
+json_t *last_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	if (nft_output_stateless(octx) || stmt->last.set == 0)
+		return json_pack("{s:n}", "last");
+
+	return json_pack("{s:{s:I}}", "last", "used", stmt->last.used);
+}
+
 json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root;
diff --git a/src/parser_json.c b/src/parser_json.c
index f1cc39505382..605dcc49f715 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1731,6 +1731,27 @@ static struct stmt *json_parse_counter_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static struct stmt *json_parse_last_stmt(struct json_ctx *ctx,
+					 const char *key, json_t *value)
+{
+	struct stmt *stmt;
+	int64_t used;
+
+	if (json_is_null(value))
+		return last_stmt_alloc(int_loc);
+
+	if (!json_unpack(value, "{s:I}", "used", &used)) {
+		stmt = last_stmt_alloc(int_loc);
+		if (used != -1) {
+			stmt->last.used = used;
+			stmt->last.set = 1;
+		}
+		return stmt;
+	}
+
+	return NULL;
+}
+
 static struct stmt *json_parse_verdict_stmt(struct json_ctx *ctx,
 					    const char *key, json_t *value)
 {
@@ -2747,6 +2768,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "counter", json_parse_counter_stmt },
 		{ "mangle", json_parse_mangle_stmt },
 		{ "quota", json_parse_quota_stmt },
+		{ "last", json_parse_last_stmt },
 		{ "limit", json_parse_limit_stmt },
 		{ "flow", json_parse_flow_offload_stmt },
 		{ "fwd", json_parse_fwd_stmt },
diff --git a/src/statement.c b/src/statement.c
index 72455522c2c9..9ca7e208cf79 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -268,6 +268,7 @@ static const struct stmt_ops last_stmt_ops = {
 	.type		= STMT_LAST,
 	.name		= "last",
 	.print		= last_stmt_print,
+	.json		= last_stmt_json,
 };
 
 struct stmt *last_stmt_alloc(const struct location *loc)
diff --git a/tests/py/any/last.t.json b/tests/py/any/last.t.json
new file mode 100644
index 000000000000..2a2b9e7278f3
--- /dev/null
+++ b/tests/py/any/last.t.json
@@ -0,0 +1,16 @@
+# last
+[
+    {
+        "last": null
+    }
+]
+
+# last used 300s
+[
+    {
+        "last": {
+		"used": 300000
+	}
+    }
+]
+
-- 
2.30.2

