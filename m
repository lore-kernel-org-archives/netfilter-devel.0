Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF005C43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A3F64FEC
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbhCDBPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454277AbhCDBIb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:08:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4627C061760
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:07:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lHcSz-0005NG-B3; Thu, 04 Mar 2021 02:07:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] parser: compact map RHS type
Date:   Thu,  4 Mar 2021 02:07:34 +0100
Message-Id: <20210304010735.28683-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210304010735.28683-1-fw@strlen.de>
References: <20210304010735.28683-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to previous patch, we can avoid duplication.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 363569ffacb6..c4f3e341333d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -627,6 +627,7 @@ int nft_lex(void *, void *, void *);
 
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
+%type <val>			map_block_obj_type
 
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
@@ -1877,6 +1878,12 @@ map_block_alloc		:	/* empty */
 			}
 			;
 
+map_block_obj_type	:	COUNTER	{ $$ = NFT_OBJECT_COUNTER; }
+			|	QUOTA { $$ = NFT_OBJECT_QUOTA; }
+			|	LIMIT { $$ = NFT_OBJECT_LIMIT; }
+			|	SECMARK { $$ = NFT_OBJECT_SECMARK; }
+			;
+
 map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	common_block
 			|	map_block	stmt_separator
@@ -1930,38 +1937,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$$ = $1;
 			}
 			|	map_block	TYPE
-						data_type_expr	COLON	COUNTER
-						stmt_separator
-			{
-				$1->key = $3;
-				$1->objtype = NFT_OBJECT_COUNTER;
-				$1->flags  |= NFT_SET_OBJECT;
-				$$ = $1;
-			}
-			|	map_block	TYPE
-						data_type_expr	COLON	QUOTA
-						stmt_separator
-			{
-				$1->key = $3;
-				$1->objtype = NFT_OBJECT_QUOTA;
-				$1->flags  |= NFT_SET_OBJECT;
-				$$ = $1;
-			}
-			|	map_block	TYPE
-						data_type_expr	COLON	LIMIT
-						stmt_separator
-			{
-				$1->key = $3;
-				$1->objtype = NFT_OBJECT_LIMIT;
-				$1->flags  |= NFT_SET_OBJECT;
-				$$ = $1;
-			}
-			|	map_block	TYPE
-						data_type_expr	COLON	SECMARK
+						data_type_expr	COLON	map_block_obj_type
 						stmt_separator
 			{
 				$1->key = $3;
-				$1->objtype = NFT_OBJECT_SECMARK;
+				$1->objtype = $5;
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
-- 
2.26.2

