Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE7AC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C0461B3E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 15:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhG0PiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 11:38:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35404 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhG0Phu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:37:50 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id C26376411D;
        Tue, 27 Jul 2021 17:37:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode with binary operation and flags
Date:   Tue, 27 Jul 2021 17:37:40 +0200
Message-Id: <20210727153741.14406-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210727153741.14406-1-pablo@netfilter.org>
References: <20210727153741.14406-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft generates incorrect bytecode when combining flag datatype and binary
operations:

  # nft --debug=netlink add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
ip
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]

Note the double bitwise expression. The last two expressions are not
correct either since it should match on the syn flag, ie. 0x2.

After this patch, netlink bytecode generation looks correct:

 # nft --debug=netlink add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
ip
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000002 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c     | 38 ++++++++++++++++-----------
 tests/py/inet/tcp.t         |  2 ++
 tests/py/inet/tcp.t.json    | 52 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload | 16 ++++++++++++
 4 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9ab3ec3ef2ff..eb53ccec1154 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -481,23 +481,31 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
 	netlink_gen_data(expr->right, &nld2);
 
-	nle = alloc_nft_expr("bitwise");
-	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
-	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
-	nft_rule_add_expr(ctx, nle, &expr->location);
-
-	nle = alloc_nft_expr("cmp");
-	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
-	if (expr->op == OP_NEG)
+	if (expr->left->etype == EXPR_BINOP) {
+		nle = alloc_nft_expr("cmp");
+		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
-	else
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
+		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld2.value, nld2.len);
+		nft_rule_add_expr(ctx, nle, &expr->location);
+	} else {
+		nle = alloc_nft_expr("bitwise");
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
+		netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
+		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
+		nft_rule_add_expr(ctx, nle, &expr->location);
 
-	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-	nft_rule_add_expr(ctx, nle, &expr->location);
+		nle = alloc_nft_expr("cmp");
+		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
+		if (expr->op == OP_NEG)
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
+		else
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
+
+		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
+		nft_rule_add_expr(ctx, nle, &expr->location);
+	}
 
 	mpz_clear(zero);
 	release_register(ctx, expr->left);
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 16e15b9f76c1..983564ec5b75 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -69,6 +69,8 @@ tcp flags != cwr;ok
 tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
 tcp flags != syn / fin,syn;ok
+tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
+tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 590a3dee5d3f..033a4f22e0fd 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1521,3 +1521,55 @@
     }
 ]
 
+# tcp flags & (fin | syn | rst | ack) syn
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
+                        "syn",
+                        "rst",
+                        "ack"
+                    ]
+                ]
+            },
+            "op": "==",
+            "right": "syn"
+        }
+    }
+]
+
+# tcp flags & (fin | syn | rst | ack) != syn
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
+                        "syn",
+                        "rst",
+                        "ack"
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
index 7f302080f02a..eaa7cd099bd6 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -370,6 +370,22 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000002 ]
 
+# tcp flags & (fin | syn | rst | ack) syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# tcp flags & (fin | syn | rst | ack) != syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000002 ]
+
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

