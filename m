From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/4] evaluate: Avoid undefined behaviour in concat_subtype_id()
Date: Fri, 12 Aug 2016 18:00:10 +0200
Message-ID: <1471017610-3473-5-git-send-email-phil@nwl.cc>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39745 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbcHLQAs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 12:00:48 -0400
In-Reply-To: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looking at expr_evaluate_concat(), 'off' might be zero and the error
checks not triggering (by having dtype != NULL and i->dtype->size > 0).
Decrementing it will then lead to casting -1 to unsigned during the call
to concat_subtype_lookup() will lead to bit-shifting in
concat_subtype_id() by a value bigger than the number of bits in 'type'
(which is 32bit).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This patch is just an ugly sanitization hack and should probably be
substituted by  an additional error check in expr_evaluate_concat()
giving an explanation of what went wrong.
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 523eedabe84ac..c8568690f6338 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -950,7 +950,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 						 "expressions",
 						 i->dtype->name);
 
-		tmp = concat_subtype_lookup(type, --off);
+		tmp = concat_subtype_lookup(type, off > 0 ? --off : 0);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
 		if (list_member_evaluate(ctx, &i) < 0)
-- 
2.8.2

