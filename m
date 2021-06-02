Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A78C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E8261263
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhFBLyl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 07:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhFBLyl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 07:54:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE68C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 04:52:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1loPQe-0007cI-Ph; Wed, 02 Jun 2021 13:52:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: fix parse of flagcmp expression
Date:   Wed,  2 Jun 2021 13:39:39 +0200
Message-Id: <20210602113939.25291-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The json test case for the flagcmp notation ('tcp flags syn,fin / syn,fin') fails with:
command: {"nftables": [{"add": {"rule": {"family": "ip", "table": "test-ip4", "chain": "input", "expr": [{"match": {"left": {"&": [{"payload": {"field": "flags", "protocol": "tcp"}}, ["fin", "syn"]]}, "op": "==", "right": ["fin", "syn"]}}]}}}]}
internal:0:0-0: Error: List expression only allowed on RHS or in statement expression.
internal:0:0-0: Error: Failed to parse RHS of binop expression.
internal:0:0-0: Error: Invalid LHS of relational.
internal:0:0-0: Error: Parsing expr array at index 0 failed.
internal:0:0-0: Error: Parsing command array at index 0 failed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c        |  2 +-
 tests/py/inet/tcp.t.json | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index fd0d4fd85a2d..2e791807cce6 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1135,7 +1135,7 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 		json_error(ctx, "Failed to parse LHS of binop expression.");
 		return NULL;
 	}
-	right = json_parse_primary_expr(ctx, jright);
+	right = json_parse_rhs_expr(ctx, jright);
 	if (!right) {
 		json_error(ctx, "Failed to parse RHS of binop expression.");
 		expr_free(left);
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 922ab91c9f0e..b04556769c81 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1749,3 +1749,30 @@
         }
     }
 ]
+
+# tcp flags fin,syn / fin,syn
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    [
+                        "fin",
+                        "syn"
+                    ]
+                ]
+            },
+            "op": "==",
+            "right": [
+                "fin",
+                "syn"
+            ]
+        }
+    }
+]
-- 
2.26.3

