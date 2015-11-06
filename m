From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 1/6] set: allow non-constant implicit set declarations
Date: Fri,  6 Nov 2015 18:34:18 +0000
Message-ID: <1446834863-18610-2-git-send-email-kaber@trash.net>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47968 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751312AbbKFSe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:27 -0500
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently all implicitly declared sets are marked as constant. The flow
statement needs to implicitly declare non-constant sets, so instead of
unconditionally marking the set as constant, only do so if the declaring
expression is itself a constant set.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 7842471..f53ba5e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -90,7 +90,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct handle h;
 
 	set = set_alloc(&expr->location);
-	set->flags	= SET_F_CONSTANT | SET_F_ANONYMOUS | expr->set_flags;
+	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(set->flags & SET_F_MAP ? "map%d" : "set%d");
 	set->keytype 	= keytype;
 	set->keylen	= keylen;
@@ -887,6 +887,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= SET_F_INTERVAL;
 	}
 
+	set->set_flags |= SET_F_CONSTANT;
+
 	set->dtype = ctx->ectx.dtype;
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
-- 
2.4.3

