From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4] evaluate: use flagcmp for single RHS bitmask expression
Date: Mon, 17 Feb 2014 17:20:49 +0000
Message-ID: <1392657652-9815-2-git-send-email-kaber@trash.net>
References: <1392657652-9815-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51562 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBQRU7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:20:59 -0500
In-Reply-To: <1392657652-9815-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Always use flagcmp for RHS bitmask expressions, independant of whether
only one or an entire list of bitmask expression is specified.

This makes sure that f.i. "tcp flags ack" will match any combinations
of ACK instead of ACK and only ACK.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8e51a63..f10d0d9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -885,7 +885,11 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			rel->op = OP_FLAGCMP;
 			break;
 		default:
-			rel->op = OP_EQ;
+			if (right->dtype->basetype != NULL &&
+			    right->dtype->basetype->type == TYPE_BITMASK)
+				rel->op = OP_FLAGCMP;
+			else
+				rel->op = OP_EQ;
 			break;
 		}
 	}
-- 
1.8.5.3

