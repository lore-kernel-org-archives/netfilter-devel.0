Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BE9C47098
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 431476141C
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFDLmt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFDLms (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C159CC06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 04:41:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp8CD-0004vg-7G; Fri, 04 Jun 2021 13:41:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] evaluate: remove anon sets with exactly one element
Date:   Fri,  4 Jun 2021 13:40:42 +0200
Message-Id: <20210604114043.4153-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210604114043.4153-1-fw@strlen.de>
References: <20210604114043.4153-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Auto-replace lookups in single-element anon sets with a standard compare.

'add rule foo bar meta iif { "lo" }' gets replaced with
'add rule foo bar meta iif "lo"'.

The former is a set lookup, the latter is a comparision.
Comparisions are faster for the one-element case.

Only prefixes, ranges and values are handled at this time.

Anonymous maps are left alone, same for concatenations.

Concatenations could be handled, but it would require more work:
the concatenation would have to be replaced with a singleton value.
Evaluation step rejects concat RHS on a relational expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 384e2fa786e0..2ed68aad0392 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1455,8 +1455,25 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
-	if (ctx->set && (ctx->set->flags & NFT_SET_CONCAT))
-		set->set_flags |= NFT_SET_CONCAT;
+	if (ctx->set) {
+		if (ctx->set->flags & NFT_SET_CONCAT)
+			set->set_flags |= NFT_SET_CONCAT;
+	} else if (set->size == 1) {
+		i = list_first_entry(&set->expressions, struct expr, list);
+		if (i->etype == EXPR_SET_ELEM) {
+			switch (i->key->etype) {
+			case EXPR_PREFIX:
+			case EXPR_RANGE:
+			case EXPR_VALUE:
+				*expr = i->key;
+				i->key = NULL;
+				expr_free(set);
+				return 0;
+			default:
+				break;
+			}
+		}
+	}
 
 	set->set_flags |= NFT_SET_CONSTANT;
 
-- 
2.26.3

