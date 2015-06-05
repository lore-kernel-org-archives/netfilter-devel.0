From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 1/9] eval: prohibit variable sized types in concat expressions
Date: Fri,  5 Jun 2015 15:42:43 +0200
Message-ID: <1433511771-4620-2-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59934 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbFENmy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:54 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since we need to calculate the length of the entire concat type, we can
not support variable sized types where the length can't be determined
by the type.

This only affects base types since all higher types include a length.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index e260a80..d99b38f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -620,6 +620,13 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 						 "expecting %s",
 						 dtype->desc);
 
+		if (dtype == NULL && i->dtype->size == 0)
+			return expr_binary_error(ctx->msgs, i, *expr,
+						 "can not use variable sized "
+						 "data types (%s) in concat "
+						 "expressions",
+						 i->dtype->name);
+
 		tmp = concat_subtype_lookup(type, --off);
 		expr_set_context(&ctx->ectx, tmp, tmp->size);
 
-- 
2.1.0

