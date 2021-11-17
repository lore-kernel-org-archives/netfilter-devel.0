Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2273C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 10:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD97E61BA2
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 10:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhKQKOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:14:16 -0500
Received: from mail.netfilter.org ([217.70.188.207]:39666 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhKQKOP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 05:14:15 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 76B5960056
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 11:09:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_json: add raw payload inner header match support
Date:   Wed, 17 Nov 2021 11:11:14 +0100
Message-Id: <20211117101114.733139-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing "ih" base raw payload and extend tests/py to cover this new
usecase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c                 |  2 ++
 tests/py/any/rawpayload.t         |  2 ++
 tests/py/any/rawpayload.t.json    | 17 +++++++++++++++++
 tests/py/any/rawpayload.t.payload |  6 ++++++
 4 files changed, 27 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 3cd21175b236..7a2d30ff665c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -558,6 +558,8 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 			val = PROTO_BASE_NETWORK_HDR;
 		} else if (!strcmp(base, "th")) {
 			val = PROTO_BASE_TRANSPORT_HDR;
+		} else if (!strcmp(base, "ih")) {
+			val = PROTO_BASE_INNER_HDR;
 		} else {
 			json_error(ctx, "Invalid payload base '%s'.", base);
 			return NULL;
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 9fe377e24397..128e8088c4e5 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -18,3 +18,5 @@ meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
 @ll,0,1 1;ok;@ll,0,8 & 0x80 == 0x80
 @ll,0,8 & 0x80 == 0x80;ok
 @ll,0,128 0xfedcba987654321001234567890abcde;ok
+
+@ih,32,32 0x14000000;ok
diff --git a/tests/py/any/rawpayload.t.json b/tests/py/any/rawpayload.t.json
index 9481d9bf543b..b5115e0ddacf 100644
--- a/tests/py/any/rawpayload.t.json
+++ b/tests/py/any/rawpayload.t.json
@@ -156,3 +156,20 @@
     }
 ]
 
+# @ih,32,32 0x14000000
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "base": "ih",
+                    "len": 32,
+                    "offset": 32
+                }
+            },
+            "op": "==",
+            "right": 335544320
+        }
+    }
+]
+
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index d2b38183cc95..61c41cb976d6 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -47,3 +47,9 @@ inet test-inet input
 inet test-inet input
   [ payload load 16b @ link header + 0 => reg 1 ]
   [ cmp eq reg 1 0x98badcfe 0x10325476 0x67452301 0xdebc0a89 ]
+
+# @ih,32,32 0x14000000
+inet test-inet input
+  [ payload load 4b @ inner header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00000014 ]
+
-- 
2.30.2

