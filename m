Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A0AC3DA6F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbjHYLxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243757AbjHYLwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:52:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A77FE7F
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vNkl8+7tFg5AxEeDua1j3sL8qZsePdHsU/URRmRajec=; b=LZIjaLk/iyKEa7iSARy1QF+61U
        3CpCvWV+sb/ADgOnuVNlxQoy4EHLgKs3MMx71JqbLpqB8843uaIVpv161tdk+AHv2WR6WHb71IXCm
        SGqivxjx7hVXOW6ME3HiugA1nSCjElP+ahEOktpEgzvqG5d/QUAnXtRLlYUcKJD7EC0hl+h24OJ79
        xjwIW6y9lAg3w0QisZYwS9fbm8xbiNMYPCQPzZy7rky7weehSOG3WpO81+ORwLpk5HqK69ZgHMy6G
        9aL4/vqkcbhbskA2Ed6buLYUOfLTqFN62QfRsSIFdjaZw6EZE9V7bci2ikJHlGzlKdOZlBAA0U2z8
        1m9wqs4w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qZVMp-0001i7-Q2; Fri, 25 Aug 2023 13:52:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] evaluate: Drop dead code from expr_evaluate_mapping()
Date:   Fri, 25 Aug 2023 13:55:30 +0200
Message-ID: <20230825115530.28539-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit 343a51702656a ("src: store expr, not dtype to track data in
sets"), set->data is allocated for object maps in set_evaluate(), all
other map types have set->data initialized by the parser already,
set_evaluate() also checks that.

Drop the confusing check, later in the function set->data is
dereferenced unconditionally.

Fixes: 343a51702656a ("src: store expr, not dtype to track data in sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2b158aee720bd..5d22a04294ca7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2061,17 +2061,14 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 				  "Key must be a constant");
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
-	if (set->data) {
-		if (!set_is_anonymous(set->flags) &&
-		    set->data->flags & EXPR_F_INTERVAL)
-			datalen = set->data->len / 2;
-		else
-			datalen = set->data->len;
-
-		__expr_set_context(&ctx->ectx, set->data->dtype, set->data->byteorder, datalen, 0);
-	} else {
-		assert((set->flags & NFT_SET_MAP) == 0);
-	}
+	assert(set->data != NULL);
+	if (!set_is_anonymous(set->flags) &&
+	    set->data->flags & EXPR_F_INTERVAL)
+		datalen = set->data->len / 2;
+	else
+		datalen = set->data->len;
+	__expr_set_context(&ctx->ectx, set->data->dtype,
+			   set->data->byteorder, datalen, 0);
 
 	if (expr_evaluate(ctx, &mapping->right) < 0)
 		return -1;
-- 
2.41.0

