From: Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 1/7] netlink: add __binop_adjust helper
Date: Wed, 27 Jul 2016 02:43:10 +0200
Message-ID: <1469580196-2100-2-git-send-email-fw@strlen.de>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60758 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbcG0BPT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 21:15:19 -0400
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

binop_adjust takes an expression whose LHS is expected to be
the binop expression that we use to adjust a payload expression
based on a mask (to match sub-byte headers like iphdr->version).

A followup patch has to pass the binop directly, so add
add a helper for it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 257473a..ae87280 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1265,10 +1265,10 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 	}
 }
 
-static void binop_adjust(struct expr *expr, unsigned int shift)
+static void __binop_adjust(const struct expr *binop, struct expr *right,
+			   unsigned int shift)
 {
-	const struct expr *binop = expr->left;
-	struct expr *right = expr->right, *i;
+	struct expr *i;
 
 	switch (right->ops->type) {
 	case EXPR_VALUE:
@@ -1293,11 +1293,16 @@ static void binop_adjust(struct expr *expr, unsigned int shift)
 		}
 		break;
 	default:
-		BUG("unknown expression type %s\n", expr->ops->name);
+		BUG("unknown expression type %s\n", right->ops->name);
 		break;
 	}
 }
 
+static void binop_adjust(struct expr *expr, unsigned int shift)
+{
+	__binop_adjust(expr->left, expr->right, shift);
+}
+
 static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	struct expr *binop = expr->left;
-- 
2.7.3

