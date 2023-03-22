Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4E2C77B60
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCVVxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCVVxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5930118155
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 4/8] evaluate: get length from statement instead of lhs expression
Date:   Wed, 22 Mar 2023 22:52:59 +0100
Message-Id: <20230322215303.239763-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get length from statement, instead infering it from the expression that
is used to set the value. In the particular case of {ct|meta} mark, this
is 32 bits.

Otherwise, bytecode generation is not correct:

 # nft -c --debug=netlink 'add rule ip6 x y ct mark set ip6 dscp << 2 | 0x10'
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]    <--- incorrect!
  [ ct set mark with reg 1 ]

the previous bitwise shift already upgraded to 32-bits (not visible from
the netlink debug output above).

After this patch, the last | 0x10 uses 32-bits:

 [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]

note that mask 0xffffffef is used instead of 0x00000fef.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index dfb1236e3b8a..613daa974971 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1325,7 +1325,7 @@ static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 
 	op->dtype     = left->dtype;
 	op->byteorder = left->byteorder;
-	op->len	      = left->len;
+	op->len	      = ctx->ectx.len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
-- 
2.30.2

