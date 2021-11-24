Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B3AC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237537AbhKXR1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhKXR1L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E439C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:01 -0800 (PST)
Received: from localhost ([::1]:44874 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzz-00018j-GQ; Wed, 24 Nov 2021 18:23:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 11/15] evaluate: Fix key byteorder value in range sets/maps
Date:   Wed, 24 Nov 2021 18:22:47 +0100
Message-Id: <20211124172251.11539-12-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In interval sets/maps, elements are always Big Endian, set
key->byteorder accordingly. This becomes relevant when dumping set
elements for debug output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index fbf3aa8d19139..983808d65714b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1617,9 +1617,12 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
-	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
-	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
-		return -1;
+	if (map->mappings->set->flags & NFT_SET_INTERVAL) {
+		if (byteorder_conversion(ctx, &map->map,
+					 BYTEORDER_BIG_ENDIAN) < 0)
+			return -1;
+		map->mappings->set->key->byteorder = BYTEORDER_BIG_ENDIAN;
+	}
 
 	return 0;
 }
@@ -2077,10 +2080,14 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				return expr_error(ctx->msgs, left,
 						  "specify either ip or ip6 for address matching");
 
+			if (!(right->set->flags & NFT_SET_INTERVAL))
+				break;
+
 			/* Data for range lookups needs to be in big endian order */
-			if (right->set->flags & NFT_SET_INTERVAL &&
-			    byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
+			if (byteorder_conversion(ctx, &rel->left,
+						 BYTEORDER_BIG_ENDIAN) < 0)
 				return -1;
+			right->set->key->byteorder = BYTEORDER_BIG_ENDIAN;
 			break;
 		case EXPR_CONCAT:
 			return expr_binary_error(ctx->msgs, left, right,
@@ -3759,9 +3766,12 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
-	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
-	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
-		return -1;
+	if (map->mappings->set->flags & NFT_SET_INTERVAL) {
+		if (byteorder_conversion(ctx, &map->map,
+					 BYTEORDER_BIG_ENDIAN) < 0)
+			return -1;
+		map->mappings->set->key->byteorder = BYTEORDER_BIG_ENDIAN;
+	}
 
 	return 0;
 }
-- 
2.33.0

