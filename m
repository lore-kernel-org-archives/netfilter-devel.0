Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238B1C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04FEA6052B
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhG0Wjd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:39:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36890 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbhG0Wjd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 18:39:33 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 51C1D642B2;
        Wed, 28 Jul 2021 00:39:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft,v2 2/3] netlink_delinearize: skip flags / mask notation for singleton bitmask
Date:   Wed, 28 Jul 2021 00:39:20 +0200
Message-Id: <20210727223921.29746-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210727223921.29746-1-pablo@netfilter.org>
References: <20210727223921.29746-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not transform 'tcp flags & flag == flag' to 'flag / flag'.
The parser does not accept this notation yet.

Fixes: c3d57114f119 ("parser_bison: add shortcut syntax for matching flags without binary operations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: skip transformation to flag / flag from delinearize path.

 src/netlink_delinearize.c   |  8 ++++++++
 tests/py/inet/tcp.t         |  2 ++
 tests/py/inet/tcp.t.json    | 21 +++++++++++++++++++++
 tests/py/inet/tcp.t.payload |  8 ++++++++
 4 files changed, 39 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c7dae26684cd..49870eeadd57 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2285,6 +2285,14 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 					BUG("unknown operation type %d\n", expr->op);
 				}
 				expr_free(binop);
+			} else if (binop->right->etype == EXPR_VALUE &&
+				   value->etype == EXPR_VALUE &&
+				   expr->op == OP_EQ &&
+				   !mpz_cmp(value->value, binop->right->value)) {
+				/* Skip flag / flag representation for:
+				 * data & flag == flag
+				 */
+				;
 			} else {
 				*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
 							    expr_get(binop->left),
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 5e2830b679a8..17e0d9b6df9f 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -70,6 +70,8 @@ tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
 tcp flags != syn / fin,syn;ok
 tcp flags & syn != 0;ok;tcp flags syn
+# it should be possible to transform this to: tcp flags syn
+tcp flags & syn == syn;ok
 tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 6155c81f6150..c1e4fb35a87c 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1537,6 +1537,27 @@
     }
 ]
 
+# tcp flags & syn == syn
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
+                    "syn"
+                ]
+            },
+            "op": "==",
+            "right": "syn"
+        }
+    }
+]
+
 # tcp flags & (fin | syn | rst | ack) syn
 [
     {
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 6b8b4ecdb4ac..77b301883a15 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -378,6 +378,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
+# tcp flags & syn == syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
 # tcp flags & (fin | syn | rst | ack) syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

