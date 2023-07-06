Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BA7EB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 15:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjGFPCq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 11:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjGFPCp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 11:02:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 817B3E70
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 08:02:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] netlink_linearize: use div_round_up in byteorder length
Date:   Thu,  6 Jul 2023 17:02:37 +0200
Message-Id: <20230706150237.47694-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use div_round_up() to calculate the byteorder length, otherwise fields
that take % BITS_PER_BYTE != 0 are not considered by the byteorder
expression.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c     |  2 +-
 tests/py/ip6/ct.t.payload   | 10 +++++-----
 tests/py/ip6/meta.t.payload |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 11cf48a3f9d0..f5b2d6bb6cea 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -806,7 +806,7 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_SREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_LEN,
-			   expr->len / BITS_PER_BYTE);
+			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_SIZE,
 			   byte_size);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_OP,
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 164149e93d17..9b85c75aca30 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -3,7 +3,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
@@ -13,7 +13,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
@@ -23,7 +23,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
   [ ct set mark with reg 1 ]
 
@@ -32,7 +32,7 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 & 0x00ffffff ) ^ 0xff000000 ]
   [ ct set mark with reg 1 ]
 
@@ -41,6 +41,6 @@ ip6 test-ip6 output
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index f0507dc47073..379a9c133c4a 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -66,7 +66,7 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
@@ -76,7 +76,7 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
-  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ meta set mark with reg 1 ]
-- 
2.30.2

