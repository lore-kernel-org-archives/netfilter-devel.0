From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 4/4] evaluate: Avoid undefined behaviour in concat_subtype_id()
Date: Tue, 30 Aug 2016 19:39:52 +0200
Message-ID: <1472578792-2991-5-git-send-email-phil@nwl.cc>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46273 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932463AbcH3RkY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 13:40:24 -0400
In-Reply-To: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the left side of a concat expression, dtype is NULL and therefore
off is 0. In that case the code expects to get a datatype of
TYPE_INVALID, but this is fragile as the output of concat_subtype_id()
is undefined for n > 32 / TYPE_BITS.

To fix this, call datatype_lookup() directly passing the expected
TYPE_INVALID as argument if off is 0.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Understood (and reproduced) when the situation causing the undefined
  behaviour happens.
- Understood what the code is supposed to do in that situation.
- Based on the information at hand, implemented a solution which avoids
  undefined behaviour.
---
 src/evaluate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 194a03495b5fd..c1ee6b1929551 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -962,7 +962,10 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 						 "expressions",
 						 i->dtype->name);
 
-		tmp = concat_subtype_lookup(type, --off);
+		if (dtype == NULL)
+			tmp = datatype_lookup(TYPE_INVALID);
+		else
+			tmp = concat_subtype_lookup(type, --off);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
 		if (list_member_evaluate(ctx, &i) < 0)
-- 
2.8.2

