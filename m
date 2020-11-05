Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AC7C4741F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1370A206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgKEOMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730681AbgKEOMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:12:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BAAC0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:12:21 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzw-0006HJ-2H; Thu, 05 Nov 2020 15:12:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/7] json: tcp: add raw tcp option match support
Date:   Thu,  5 Nov 2020 15:11:44 +0100
Message-Id: <20201105141144.31430-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To similar change as in previous one, this time for the
jason (de)serialization.

Re-uses the raw payload match syntax, i.e. base,offset,length.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c                 | 22 ++++++++--------
 src/parser_json.c          | 52 ++++++++++++++++++++++++++------------
 tests/py/any/tcpopt.t.json | 34 +++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/src/json.c b/src/json.c
index 3c4654d6dada..ac3b1c833d86 100644
--- a/src/json.c
+++ b/src/json.c
@@ -665,30 +665,32 @@ json_t *map_expr_json(const struct expr *expr, struct output_ctx *octx)
 json_t *exthdr_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const char *desc = expr->exthdr.desc ?
-			   expr->exthdr.desc->name :
-			   "unknown-exthdr";
+			   expr->exthdr.desc->name : NULL;
 	const char *field = expr->exthdr.tmpl->token;
 	json_t *root;
 	bool is_exists = expr->exthdr.flags & NFT_EXTHDR_F_PRESENT;
 
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
+		static const char *offstrs[] = { "", "1", "2", "3" };
 		unsigned int offset = expr->exthdr.offset / 64;
+		const char *offstr = "";
 
-		if (offset) {
-			const char *offstrs[] = { "0", "1", "2", "3" };
-			const char *offstr = "";
-
+		if (desc) {
 			if (offset < 4)
 				offstr = offstrs[offset];
 
 			root = json_pack("{s:s+}", "name", desc, offstr);
+
+			if (!is_exists)
+				json_object_set_new(root, "field", json_string(field));
 		} else {
-			root = json_pack("{s:s}", "name", desc);
+			root = json_pack("{s:i, s:i, s:i}",
+					 "base", expr->exthdr.raw_type,
+					 "offset", expr->exthdr.offset,
+					 "len", expr->len);
+			is_exists = false;
 		}
 
-		if (!is_exists)
-			json_object_set_new(root, "field", json_string(field));
-
 		return json_pack("{s:o}", "tcp option", root);
 	}
 	if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
diff --git a/src/parser_json.c b/src/parser_json.c
index 6e1333659f81..b1de56a4a0d2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -502,6 +502,8 @@ static int json_parse_tcp_option_field(int type, const char *name, int *val)
 		return 1;
 
 	desc = tcpopt_protocols[type];
+	if (!desc)
+		return 1;
 
 	for (i = 0; i < array_size(desc->templates); i++) {
 		if (desc->templates[i].token &&
@@ -601,30 +603,48 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 					       const char *type, json_t *root)
 {
+	int fieldval, kind, offset, len;
 	const char *desc, *field;
-	int descval, fieldval;
 	struct expr *expr;
 
-	if (json_unpack_err(ctx, root, "{s:s}", "name", &desc))
-		return NULL;
-
-	if (json_parse_tcp_option_type(desc, &descval)) {
-		json_error(ctx, "Unknown tcp option name '%s'.", desc);
-		return NULL;
-	}
+	if (!json_unpack(root, "{s:i, s:i, s:i}",
+			"base", &kind, "offset", &offset, "len", &len)) {
+		uint32_t flag = 0;
 
-	if (json_unpack(root, "{s:s}", "field", &field)) {
-		expr = tcpopt_expr_alloc(int_loc, descval,
+		expr = tcpopt_expr_alloc(int_loc, kind,
 					 TCPOPT_COMMON_KIND);
-		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 
+		if (kind < 0 || kind > 255)
+			return NULL;
+
+		if (offset == TCPOPT_COMMON_KIND && len == 8)
+			flag = NFT_EXTHDR_F_PRESENT;
+
+		tcpopt_init_raw(expr, kind, offset, len, flag);
 		return expr;
+	} else if (!json_unpack(root, "{s:s}", "name", &desc)) {
+		if (json_parse_tcp_option_type(desc, &kind)) {
+			json_error(ctx, "Unknown tcp option name '%s'.", desc);
+			return NULL;
+		}
+
+		if (json_unpack(root, "{s:s}", "field", &field)) {
+			expr = tcpopt_expr_alloc(int_loc, kind,
+						 TCPOPT_COMMON_KIND);
+			expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			return expr;
+		}
+
+		if (json_parse_tcp_option_field(kind, field, &fieldval)) {
+			json_error(ctx, "Unknown tcp option field '%s'.", field);
+			return NULL;
+		}
+
+		return tcpopt_expr_alloc(int_loc, kind, fieldval);
 	}
-	if (json_parse_tcp_option_field(descval, field, &fieldval)) {
-		json_error(ctx, "Unknown tcp option field '%s'.", field);
-		return NULL;
-	}
-	return tcpopt_expr_alloc(int_loc, descval, fieldval);
+
+	json_error(ctx, "Invalid tcp option expression properties.");
+	return NULL;
 }
 
 static int json_parse_ip_option_type(const char *name, int *val)
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index b15e36ee7f4c..139e97d8f043 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -414,6 +414,40 @@
     }
 ]
 
+# tcp option 255 missing
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "base": 255,
+                    "len": 8,
+                    "offset": 0
+                }
+            },
+            "op": "==",
+            "right": false
+        }
+    }
+]
+
+# tcp option @255,8,8 255
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "base": 255,
+                    "len": 8,
+                    "offset": 8
+                }
+            },
+            "op": "==",
+            "right": 255
+        }
+    }
+]
+
 # tcp option window exists
 [
     {
-- 
2.26.2

