Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C41FC38A02
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Oct 2022 11:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJaLQ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 07:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJaLQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 07:16:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F14FDF21
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2022 04:16:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] payload: do not kill dependency for proto_unknown
Date:   Mon, 31 Oct 2022 12:16:16 +0100
Message-Id: <20221031111616.96702-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031111616.96702-1-pablo@netfilter.org>
References: <20221031111616.96702-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unsupported meta match on layer 4 protocol sets on protocol context to
proto_unknown, handle anything coming after it as a raw expression in
payload_expr_expand().

Moreover, payload_dependency_kill() skips dependency removal if protocol
is unknown, so raw payload expression leaves meta layer 4 protocol
remains in place.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1641
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c                     |  6 ++++--
 tests/py/any/rawpayload.t         |  2 ++
 tests/py/any/rawpayload.t.json    | 31 +++++++++++++++++++++++++++++++
 tests/py/any/rawpayload.t.payload |  8 ++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 2c0d0ac9e8ae..101bfbda5878 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -848,7 +848,8 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 			     unsigned int family)
 {
-	if (payload_dependency_exists(ctx, expr->payload.base) &&
+	if (expr->payload.desc != &proto_unknown &&
+	    payload_dependency_exists(ctx, expr->payload.base) &&
 	    payload_may_dependency_kill(ctx, family, expr))
 		payload_dependency_release(ctx, expr->payload.base);
 }
@@ -1058,8 +1059,9 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 	assert(expr->etype == EXPR_PAYLOAD);
 
 	desc = ctx->protocol[expr->payload.base].desc;
-	if (desc == NULL)
+	if (desc == NULL || desc == &proto_unknown)
 		goto raw;
+
 	assert(desc->base == expr->payload.base);
 
 	desc = get_stacked_desc(ctx, desc, expr, &total);
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 128e8088c4e5..5bc9d35f7465 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -19,4 +19,6 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 @ll,0,8 & 0x80 == 0x80;ok
 @ll,0,128 0xfedcba987654321001234567890abcde;ok
 
+meta l4proto 91 @th,400,16 0x0 accept;ok
+
 @ih,32,32 0x14000000;ok
diff --git a/tests/py/any/rawpayload.t.json b/tests/py/any/rawpayload.t.json
index b5115e0ddacf..4cae4d493da3 100644
--- a/tests/py/any/rawpayload.t.json
+++ b/tests/py/any/rawpayload.t.json
@@ -156,6 +156,37 @@
     }
 ]
 
+# meta l4proto 91 @th,400,16 0x0 accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 91
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "th",
+                    "len": 16,
+                    "offset": 400
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
 # @ih,32,32 0x14000000
 [
     {
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index 61c41cb976d6..fe2377e65a77 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -48,6 +48,14 @@ inet test-inet input
   [ payload load 16b @ link header + 0 => reg 1 ]
   [ cmp eq reg 1 0x98badcfe 0x10325476 0x67452301 0xdebc0a89 ]
 
+# meta l4proto 91 @th,400,16 0x0 accept
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000005b ]
+  [ payload load 2b @ transport header + 50 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+  [ immediate reg 0 accept ]
+
 # @ih,32,32 0x14000000
 inet test-inet input
   [ payload load 4b @ inner header + 4 => reg 1 ]
-- 
2.30.2

