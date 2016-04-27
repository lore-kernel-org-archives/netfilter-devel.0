From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 2/7] set: allow non-constant implicit set declarations
Date: Wed, 27 Apr 2016 12:29:45 +0100
Message-ID: <1461756590-22880-3-git-send-email-kaber@trash.net>
References: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbcD0L34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:29:56 -0400
In-Reply-To: <1461756590-22880-1-git-send-email-kaber@trash.net>
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
index 63c0091..9c8add3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -96,7 +96,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct handle h;
 
 	set = set_alloc(&expr->location);
-	set->flags	= SET_F_CONSTANT | SET_F_ANONYMOUS | expr->set_flags;
+	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(set->flags & SET_F_MAP ? "map%d" : "set%d");
 	set->keytype 	= keytype;
 	set->keylen	= keylen;
@@ -963,6 +963,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= SET_F_INTERVAL;
 	}
 
+	set->set_flags |= SET_F_CONSTANT;
+
 	set->dtype = ctx->ectx.dtype;
 	set->len   = ctx->ectx.len;
 	set->flags |= EXPR_F_CONSTANT;
-- 
2.5.5

