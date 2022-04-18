Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525B6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Apr 2022 10:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiDRKMT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiDRKMS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 06:12:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9706917AAB
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:09:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ngOK5-0008Qc-1j; Mon, 18 Apr 2022 12:09:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] src: allow use of base integer types as set keys in concatenations
Date:   Mon, 18 Apr 2022 12:09:23 +0200
Message-Id: <20220418100924.5669-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418100924.5669-1-fw@strlen.de>
References: <20220418100924.5669-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"typeof ip saddr . ipsec in reqid" won't work because reqid uses
integer type, i.e. dtype->size is 0.

With "typeof", the size can be derived from the expression length,
via set->key.

This computes the concat length based either on dtype->size or
expression length.

It also updates concat evaluation to permit a zero datatype size
if the subkey expression has nonzero length (i.e., typeof was used).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 503b4f036655..b5f74d2f5051 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1270,7 +1270,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
-		unsigned dsize_bytes;
+		enum byteorder bo = BYTEORDER_INVALID;
+		unsigned dsize_bytes, dsize = 0;
 
 		if (i->etype == EXPR_CT &&
 		    (i->ct.key == NFT_CT_SRC ||
@@ -1286,14 +1287,18 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 		if (key) {
 			tmp = key->dtype;
+			dsize = key->len;
+			bo = key->byteorder;
 			off--;
 		} else if (dtype == NULL) {
 			tmp = datatype_lookup(TYPE_INVALID);
 		} else {
 			tmp = concat_subtype_lookup(type, --off);
+			dsize = tmp->size;
+			bo = tmp->byteorder;
 		}
 
-		expr_set_context(&ctx->ectx, tmp, tmp->size);
+		__expr_set_context(&ctx->ectx, tmp, bo, dsize, 0);
 
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
@@ -1315,12 +1320,14 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 						 "data types (%s) in concat "
 						 "expressions",
 						 i->dtype->name);
+		if (dsize == 0) /* reload after evaluation or clone above */
+			dsize = i->dtype->size;
 
 		ntype = concat_subtype_add(ntype, i->dtype->type);
 
-		dsize_bytes = div_round_up(i->dtype->size, BITS_PER_BYTE);
+		dsize_bytes = div_round_up(dsize, BITS_PER_BYTE);
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
-		size += netlink_padded_len(i->dtype->size);
+		size += netlink_padded_len(dsize);
 		if (key)
 			key = list_next_entry(key, list);
 	}
@@ -4046,20 +4053,23 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			i->dtype = dtype;
 		}
 
-		if (i->dtype->size == 0)
+		if (i->dtype->size == 0 && i->len == 0)
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "can not use variable sized "
 						 "data types (%s) in concat "
 						 "expressions",
 						 i->dtype->name);
 
+		if (i->dtype->size)
+			assert(i->len == i->dtype->size);
+
 		flags &= i->flags;
 
 		ntype = concat_subtype_add(ntype, i->dtype->type);
 
-		dsize_bytes = div_round_up(i->dtype->size, BITS_PER_BYTE);
+		dsize_bytes = div_round_up(i->len, BITS_PER_BYTE);
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
-		size += netlink_padded_len(i->dtype->size);
+		size += netlink_padded_len(i->len);
 	}
 
 	(*expr)->flags |= flags;
-- 
2.35.1

