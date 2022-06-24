Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6BCC43334
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 09:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiFXJ0M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 05:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiFXJ0L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 05:26:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9436F490
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 02:26:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1o4fZp-0003or-GJ; Fri, 24 Jun 2022 11:26:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] parser: add missing synproxy scope closure
Date:   Fri, 24 Jun 2022 11:25:54 +0200
Message-Id: <20220624092555.1572-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220624092555.1572-1-fw@strlen.de>
References: <20220624092555.1572-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 232f2c3287fc ("scanner: synproxy: Move to own scope")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2a0240fb9862..73a2702dcec1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2015,7 +2015,7 @@ map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
 			|	SECMARK close_scope_secmark { $$ = NFT_OBJECT_SECMARK; }
-			|	SYNPROXY { $$ = NFT_OBJECT_SYNPROXY; }
+			|	SYNPROXY close_scope_synproxy { $$ = NFT_OBJECT_SYNPROXY; }
 			;
 
 map_block		:	/* empty */	{ $$ = $<set>-1; }
-- 
2.35.1

