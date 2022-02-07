Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E65C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 13:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387158AbiBGNt1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379179AbiBGN21 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 08:28:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D323C043188
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:28:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nH449-00078x-0D; Mon, 07 Feb 2022 14:28:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] json: add flow statement json export + parser
Date:   Mon,  7 Feb 2022 14:28:14 +0100
Message-Id: <20220207132816.21129-2-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207132816.21129-1-fw@strlen.de>
References: <20220207132816.21129-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

flow statement has no export, its shown as:
".. }, "flow add @ft" ] } }"

With this patch:

".. }, {"flow": {"op": "add", "flowtable": "@ft"}}]}}"

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/json.h    |  2 ++
 src/ct.c          |  1 +
 src/json.c        |  7 +++++++
 src/parser_json.c | 23 +++++++++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/include/json.h b/include/json.h
index 3db9f2782d11..a753f359aa52 100644
--- a/include/json.h
+++ b/include/json.h
@@ -69,6 +69,7 @@ json_t *uid_type_json(const struct expr *expr, struct output_ctx *octx);
 json_t *gid_type_json(const struct expr *expr, struct output_ctx *octx);
 
 json_t *expr_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *flow_offload_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *exthdr_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *quota_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
@@ -169,6 +170,7 @@ EXPR_PRINT_STUB(uid_type)
 EXPR_PRINT_STUB(gid_type)
 
 STMT_PRINT_STUB(expr)
+STMT_PRINT_STUB(flow_offload)
 STMT_PRINT_STUB(payload)
 STMT_PRINT_STUB(exthdr)
 STMT_PRINT_STUB(quota)
diff --git a/src/ct.c b/src/ct.c
index 6049157198ad..e246d3039240 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -578,6 +578,7 @@ static const struct stmt_ops flow_offload_stmt_ops = {
 	.name		= "flow_offload",
 	.print		= flow_offload_stmt_print,
 	.destroy	= flow_offload_stmt_destroy,
+	.json		= flow_offload_stmt_json,
 };
 
 struct stmt *flow_offload_stmt_alloc(const struct location *loc,
diff --git a/src/json.c b/src/json.c
index 63b325afc8d1..4f800c908c66 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1122,6 +1122,13 @@ json_t *expr_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	return expr_print_json(stmt->expr, octx);
 }
 
+json_t *flow_offload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	return json_pack("{s:{s:s, s:s+}}", "flow",
+			 "op", "add", "flowtable",
+			 "@", stmt->flow.table_name);
+}
+
 json_t *payload_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	return json_pack("{s: {s:o, s:o}}", "mangle",
diff --git a/src/parser_json.c b/src/parser_json.c
index 2fad308f7783..f07b798adecd 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1903,6 +1903,28 @@ out_err:
 	return NULL;
 }
 
+static struct stmt *json_parse_flow_offload_stmt(struct json_ctx *ctx,
+						 const char *key, json_t *value)
+{
+	const char *opstr, *flowtable;
+
+	if (json_unpack_err(ctx, value, "{s:s, s:s}",
+			    "op", &opstr, "flowtable", &flowtable))
+		return NULL;
+
+	if (strcmp(opstr, "add")) {
+		json_error(ctx, "Unknown flow offload statement op '%s'.", opstr);
+		return NULL;
+	}
+
+	if (flowtable[0] != '@') {
+		json_error(ctx, "Illegal flowtable reference in flow offload statement.");
+		return NULL;
+	}
+
+	return flow_offload_stmt_alloc(int_loc, xstrdup(flowtable + 1));
+}
+
 static struct stmt *json_parse_notrack_stmt(struct json_ctx *ctx,
 					const char *key, json_t *value)
 {
@@ -2647,6 +2669,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "mangle", json_parse_mangle_stmt },
 		{ "quota", json_parse_quota_stmt },
 		{ "limit", json_parse_limit_stmt },
+		{ "flow", json_parse_flow_offload_stmt },
 		{ "fwd", json_parse_fwd_stmt },
 		{ "notrack", json_parse_notrack_stmt },
 		{ "dup", json_parse_dup_stmt },
-- 
2.34.1

