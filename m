Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1405C74A5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCVVxX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVVxW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D5131815B
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 5/8] evaluate: relax type-checking for integer arguments in mark statements
Date:   Wed, 22 Mar 2023 22:53:00 +0100
Message-Id: <20230322215303.239763-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to be able to set ct and meta marks to values derived from
payload expressions, we need to relax the requirement that the type of
the statement argument must match that of the statement key.  Instead,
we require that the base-type of the argument is integer and that the
argument is small enough to fit.

Moreover, swap expression byteorder before to make it compatible with
the statement byteorder, to ensure rulesets are portable.

 # nft --debug=netlink add rule ip t c 'meta mark set ip saddr'
 ip t c
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ byteorder reg 1 = ntoh(reg 1, 4, 4) ] <----------- byteorder swap
  [ meta set mark with reg 1 ]

The following patches are required for this to work:

evaluate: get length from statement instead of lhs expression
evaluate: don't eval unary arguments
evaluate: support shifts larger than the width of the left operand
netlink_delinearize: correct type and byte-order of shifts
evaluate: insert byte-order conversions for expressions between 9 and 15 bits

Add one testcase for tests/py.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c             | 13 +++++++++++--
 tests/py/ip/meta.t         |  2 ++
 tests/py/ip/meta.t.json    | 20 ++++++++++++++++++++
 tests/py/ip/meta.t.payload |  8 ++++++++
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 613daa974971..273d0a9e069e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2742,13 +2742,22 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 					 "expression has type %s with length %d",
 					 dtype->desc, (*expr)->dtype->desc,
 					 (*expr)->len);
-	else if ((*expr)->dtype->type != TYPE_INTEGER &&
-		 !datatype_equal((*expr)->dtype, dtype))
+
+	if ((dtype->type == TYPE_MARK &&
+	     !datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype))) ||
+	    (dtype->type != TYPE_MARK &&
+	     (*expr)->dtype->type != TYPE_INTEGER &&
+	     !datatype_equal((*expr)->dtype, dtype)))
 		return stmt_binary_error(ctx, *expr, stmt,		/* verdict vs invalid? */
 					 "datatype mismatch: expected %s, "
 					 "expression has type %s",
 					 dtype->desc, (*expr)->dtype->desc);
 
+	if (dtype->type == TYPE_MARK &&
+	    datatype_equal(datatype_basetype(dtype), datatype_basetype((*expr)->dtype)) &&
+	    !expr_is_constant(*expr))
+		return byteorder_conversion(ctx, expr, byteorder);
+
 	/* we are setting a value, we can't use a set */
 	switch ((*expr)->etype) {
 	case EXPR_SET:
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 5a05923a1ce1..85eaf54ce723 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -15,3 +15,5 @@ meta obrname "br0";fail
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
+
+meta mark set ip dscp;ok
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index 3df31ce381fc..a93d7e781ce1 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -156,3 +156,23 @@
         }
     }
 ]
+
+# meta mark set ip dscp
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index afde5cc13ac5..1aa8d003b1d4 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -51,3 +51,11 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta mark set ip dscp
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ meta set mark with reg 1 ]
+
-- 
2.30.2

