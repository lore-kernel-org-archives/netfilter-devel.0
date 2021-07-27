Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7D7C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AC761B5F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhG0Phz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 11:37:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35398 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG0Phu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:37:50 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id DCD18608E0;
        Tue, 27 Jul 2021 17:37:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft 1/3] expression: missing != in flagcmp expression print function
Date:   Tue, 27 Jul 2021 17:37:39 +0200
Message-Id: <20210727153741.14406-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing != when printing the expression.

Fixes: c3d57114f119 ("parser_bison: add shortcut syntax for matching flags without binary operations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c            |  7 ++++++-
 tests/py/inet/tcp.t         |  1 +
 tests/py/inet/tcp.t.json    | 25 +++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload |  8 ++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index c6be000107f2..4c0874fe9950 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1358,7 +1358,12 @@ struct expr *set_elem_catchall_expr_alloc(const struct location *loc)
 static void flagcmp_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	expr_print(expr->flagcmp.expr, octx);
-	nft_print(octx, " ");
+
+	if (expr->op == OP_NEQ)
+		nft_print(octx, " != ");
+	else
+		nft_print(octx, " ");
+
 	expr_print(expr->flagcmp.value, octx);
 	nft_print(octx, " / ");
 	expr_print(expr->flagcmp.mask, octx);
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 532da2776d24..16e15b9f76c1 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -68,6 +68,7 @@ tcp flags cwr;ok
 tcp flags != cwr;ok
 tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
+tcp flags != syn / fin,syn;ok
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 8c2a376b2e60..590a3dee5d3f 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1496,3 +1496,28 @@
         }
     }
 ]
+
+# tcp flags != syn / fin,syn
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
+            "op": "!=",
+            "right": "syn"
+        }
+    }
+]
+
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index ee61b1a722d5..7f302080f02a 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -362,6 +362,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000003 ]
 
+# tcp flags != syn / fin,syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000002 ]
+
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

