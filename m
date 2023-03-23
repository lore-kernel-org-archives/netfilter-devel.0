Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573F0C76196
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjCWQ7M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjCWQ7J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6216FC5
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 07/12] evaluate: honor statement length in bitwise evaluation
Date:   Thu, 23 Mar 2023 17:58:50 +0100
Message-Id: <20230323165855.559837-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323165855.559837-1-pablo@netfilter.org>
References: <20230323165855.559837-1-pablo@netfilter.org>
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

Patch ("evaluate: support shifts larger than the width of the left operand")
provides the statement length through eval context. Use it to evaluate the
bitwise expression accordingly, otherwise bytecode is incorrect:

 # nft --debug=netlink add rule ip x y 'ct mark set ip dscp & 0x0f << 1 | 0xff000000'
 ip x y
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x1e000000 ) ^ 0x000000ff ]  <-- incorrect byteorder for OR
  [ byteorder reg 1 = ntoh(reg 1, 4, 4) ]		   <-- no needed for single ip dscp byte
  [ ct set mark with reg 1 ]

Correct bytecode:

 # nft --debug=netlink add rule ip x y 'ct mark set ip dscp & 0x0f << 1 | 0xff000000
 ip x y
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0xff000000 ]
  [ ct set mark with reg 1 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7c3b5b4ddddb..1db990903810 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1326,13 +1326,32 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_bitwise(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *op = *expr, *left = op->left;
+	const struct datatype *dtype;
+	unsigned int max_len;
+	int byteorder;
+
+	if (ctx->stmt_len > left->len) {
+		max_len = ctx->stmt_len;
+		byteorder = BYTEORDER_HOST_ENDIAN;
+		dtype = &integer_type;
+
+		/* Both sides need to be in host byte order */
+		if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
+			return -1;
+
+		left = op->left;
+	} else {
+		max_len = left->len;
+		byteorder = left->byteorder;
+		dtype = left->dtype;
+	}
 
-	if (byteorder_conversion(ctx, &op->right, left->byteorder) < 0)
+	if (byteorder_conversion(ctx, &op->right, byteorder) < 0)
 		return -1;
 
-	op->dtype     = left->dtype;
-	op->byteorder = left->byteorder;
-	op->len	      = left->len;
+	op->dtype     = dtype;
+	op->byteorder = byteorder;
+	op->len	      = max_len;
 
 	if (expr_is_constant(left))
 		return constant_binop_simplify(ctx, expr);
-- 
2.30.2

