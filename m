Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D272BC47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3042610CB
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhFBSkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhFBSkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 14:40:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE21C06174A
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 11:38:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1loVlS-0001ds-Hp; Wed, 02 Jun 2021 20:38:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: catchall element support
Date:   Wed,  2 Jun 2021 20:38:46 +0200
Message-Id: <20210602183846.60628-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Treat '*' as catchall element, not as a symbol.
Also add missing json test cases for wildcard set support.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/json.h          |  1 +
 src/expression.c        |  1 +
 src/json.c              |  5 +++
 src/parser_json.c       | 11 +-----
 tests/py/ip/sets.t.json | 84 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/include/json.h b/include/json.h
index dd594bd03e1c..015e3ac780f8 100644
--- a/include/json.h
+++ b/include/json.h
@@ -37,6 +37,7 @@ json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx);
+json_t *set_elem_catchall_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *prefix_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *list_expr_json(const struct expr *expr, struct output_ctx *octx);
 json_t *unary_expr_json(const struct expr *expr, struct output_ctx *octx);
diff --git a/src/expression.c b/src/expression.c
index c91333631ad0..c6be000107f2 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1341,6 +1341,7 @@ static const struct expr_ops set_elem_catchall_expr_ops = {
 	.type		= EXPR_SET_ELEM_CATCHALL,
 	.name		= "catch-all set element",
 	.print		= set_elem_catchall_expr_print,
+	.json		= set_elem_catchall_expr_json,
 };
 
 struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
diff --git a/src/json.c b/src/json.c
index e588ef4c1722..b08c004ae9c9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -889,6 +889,11 @@ static json_t *symbolic_constant_json(const struct symbol_table *tbl,
 		return json_string(s->identifier);
 }
 
+json_t *set_elem_catchall_expr_json(const struct expr *expr, struct output_ctx *octx)
+{
+	return json_string("*");
+}
+
 static json_t *datatype_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
diff --git a/src/parser_json.c b/src/parser_json.c
index 2e791807cce6..e6a0233ab6ce 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -315,15 +315,6 @@ static struct expr *json_parse_constant(struct json_ctx *ctx, const char *name)
 	return NULL;
 }
 
-static struct expr *wildcard_expr_alloc(void)
-{
-	struct expr *expr;
-
-	expr = constant_expr_alloc(int_loc, &integer_type,
-				   BYTEORDER_HOST_ENDIAN, 0, NULL);
-	return prefix_expr_alloc(int_loc, expr, 0);
-}
-
 /* this is a combination of symbol_expr, integer_expr, boolean_expr ... */
 static struct expr *json_parse_immediate(struct json_ctx *ctx, json_t *root)
 {
@@ -338,7 +329,7 @@ static struct expr *json_parse_immediate(struct json_ctx *ctx, json_t *root)
 			symtype = SYMBOL_SET;
 			str++;
 		} else if (str[0] == '*' && str[1] == '\0') {
-			return wildcard_expr_alloc();
+			return set_elem_catchall_expr_alloc(int_loc);
 		} else if (is_keyword(str)) {
 			return symbol_expr_alloc(int_loc,
 						 SYMBOL_VALUE, NULL, str);
diff --git a/tests/py/ip/sets.t.json b/tests/py/ip/sets.t.json
index 65d2df873623..d24b3918dc6d 100644
--- a/tests/py/ip/sets.t.json
+++ b/tests/py/ip/sets.t.json
@@ -188,3 +188,87 @@
     }
 ]
 
+# ip saddr @set6 drop
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "@set6"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# ip saddr vmap { 1.1.1.1 : drop, * : accept }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        "1.1.1.1",
+                        {
+                            "drop": null
+                        }
+                    ],
+                    [
+                        "*",
+                        {
+                            "accept": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            }
+        }
+    }
+]
+
+# meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 }
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "1.1.1.1",
+                                1
+                            ],
+                            [
+                                "*",
+                                2
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
+
-- 
2.31.1

