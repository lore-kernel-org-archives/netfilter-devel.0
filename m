Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA047C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726406109F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhHOMwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 08:52:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53202 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHOMwD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 08:52:03 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2675960074
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 14:50:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: skip flags / mask notation for singleton bitmask again
Date:   Sun, 15 Aug 2021 14:51:24 +0200
Message-Id: <20210815125124.5153-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

!= operation should also be covered too.

Fixes: 347a4aa16e64 ("netlink_delinearize: skip flags / mask notation for singleton bitmask")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c   |  2 +-
 tests/py/inet/tcp.t         |  1 +
 tests/py/inet/tcp.t.json    | 21 +++++++++++++++++++++
 tests/py/inet/tcp.t.payload |  8 ++++++++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 49870eeadd57..5b545701e8b7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2287,10 +2287,10 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 				expr_free(binop);
 			} else if (binop->right->etype == EXPR_VALUE &&
 				   value->etype == EXPR_VALUE &&
-				   expr->op == OP_EQ &&
 				   !mpz_cmp(value->value, binop->right->value)) {
 				/* Skip flag / flag representation for:
 				 * data & flag == flag
+				 * data & flag != flag
 				 */
 				;
 			} else {
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index afa70d85d6b4..aa07c3ba8ca7 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -75,6 +75,7 @@ tcp flags & (syn | ack) != 0;ok;tcp flags syn,ack
 tcp flags & (syn | ack) == 0;ok;tcp flags ! syn,ack
 # it should be possible to transform this to: tcp flags syn
 tcp flags & syn == syn;ok
+tcp flags & syn != syn;ok
 tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) == syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 615bc68f881f..8439c2b5931d 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1612,6 +1612,27 @@
     }
 ]
 
+# tcp flags & syn != syn
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
+            "op": "!=",
+            "right": "syn"
+        }
+    }
+]
+
 # tcp flags & (fin | syn | rst | ack) syn
 [
     {
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 8aeeaee39aea..1cfe500bff1a 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -410,6 +410,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
+# tcp flags & syn != syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000002 ]
+
 # tcp flags & (fin | syn | rst | ack) syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

