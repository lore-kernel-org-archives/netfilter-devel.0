Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663E8C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 15:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjHBPsg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjHBPsf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 11:48:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E711999
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 08:48:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qRE5R-0005Pa-32; Wed, 02 Aug 2023 17:48:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: deduplicate map with data interval
Date:   Wed,  2 Aug 2023 17:48:24 +0200
Message-ID: <20230802154828.19126-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its copypasted, the copy is same as original
except that it specifies a map key that maps to an interval.

Add an exra rule that returns 0 or EXPR_F_INTERVAL, then
use that in a single rule.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 36172713470a..5637829332ce 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -727,7 +727,7 @@ int nft_lex(void *, void *, void *);
 
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
-%type <val>			map_block_obj_type
+%type <val>			map_block_obj_type map_block_data_interval
 
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
@@ -2225,6 +2225,10 @@ map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	SYNPROXY close_scope_synproxy { $$ = NFT_OBJECT_SYNPROXY; }
 			;
 
+map_block_data_interval :	INTERVAL { $$ = EXPR_F_INTERVAL; }
+			|	{ $$ = 0; }
+			;
+
 map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_separator
@@ -2234,22 +2238,12 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$$ = $1;
 			}
 			|	map_block	TYPE
-						data_type_expr	COLON	data_type_expr
-						stmt_separator	close_scope_type
-			{
-				$1->key = $3;
-				$1->data = $5;
-
-				$1->flags |= NFT_SET_MAP;
-				$$ = $1;
-			}
-			|	map_block	TYPE
-						data_type_expr	COLON	INTERVAL	data_type_expr
+						data_type_expr	COLON	map_block_data_interval data_type_expr
 						stmt_separator	close_scope_type
 			{
 				$1->key = $3;
 				$1->data = $6;
-				$1->data->flags |= EXPR_F_INTERVAL;
+				$1->data->flags |= $5;
 
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
-- 
2.41.0

