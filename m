Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F4AC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 09:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCNJpV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNJpU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 05:45:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE506911C5
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 02:45:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] Revert "evaluate: relax type-checking for integer arguments in mark statements"
Date:   Tue, 14 Mar 2023 10:45:13 +0100
Message-Id: <20230314094513.738041-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch reverts eab3eb7f146c ("evaluate: relax type-checking for
integer arguments in mark statements") since it might cause ruleset
portability issues when moving a ruleset from little to big endian
host (and vice-versa).

Let's revert this until we agree on what to do in this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c             |  8 ++------
 tests/py/ip/meta.t         |  2 --
 tests/py/ip/meta.t.json    | 20 --------------------
 tests/py/ip/meta.t.payload |  8 --------
 4 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 47caf3b0d716..edc3c5cb04f3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2733,12 +2733,8 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 "expression has type %s with length %d",
 					 dtype->desc, (*expr)->dtype->desc,
 					 (*expr)->len);
-
-	if ((dtype->type == TYPE_MARK &&
-	     !datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype))) ||
-	    (dtype->type != TYPE_MARK &&
-	     (*expr)->dtype->type != TYPE_INTEGER &&
-	     !datatype_equal((*expr)->dtype, dtype)))
+	else if ((*expr)->dtype->type != TYPE_INTEGER &&
+		 !datatype_equal((*expr)->dtype, dtype))
 		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 85eaf54ce723..5a05923a1ce1 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -15,5 +15,3 @@ meta obrname "br0";fail
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
-
-meta mark set ip dscp;ok
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index a93d7e781ce1..3df31ce381fc 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -156,23 +156,3 @@
         }
     }
 ]
-
-# meta mark set ip dscp
-[
-    {
-        "mangle": {
-            "key": {
-                "meta": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "payload": {
-                    "field": "dscp",
-                    "protocol": "ip"
-                }
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 1aa8d003b1d4..afde5cc13ac5 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -51,11 +51,3 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
-
-# meta mark set ip dscp
-ip test-ip4 input
-  [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
-  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
-  [ meta set mark with reg 1 ]
-
-- 
2.30.2

