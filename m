From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expression: provide clone operation for set element ops
Date: Thu,  1 Oct 2015 00:46:46 +0200
Message-ID: <1443653206-25841-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46513 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbbI3Wqw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 18:46:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

define addrs={ 1.2.3.4 }
table ip filter {
	chain input {
		type filter hook input priority 0;
		ip saddr $addrs accept
	}
}

segfaults. Using saddr { 1.2.3.4 } instead of $addrs works.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index 3edc550..70f18e2 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -48,6 +48,7 @@ struct expr *expr_clone(const struct expr *expr)
 			 expr->byteorder, expr->len);
 	new->flags = expr->flags;
 	new->op    = expr->op;
+	assert(expr->ops->clone);
 	expr->ops->clone(new, expr);
 	return new;
 }
@@ -907,9 +908,19 @@ static void set_elem_expr_destroy(struct expr *expr)
 	expr_free(expr->key);
 }
 
+static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->key = expr_clone(expr->key);
+	new->expiration = expr->expiration;
+	new->timeout = expr->timeout;
+	if (expr->comment)
+		new->comment = xstrdup(expr->comment);
+}
+
 static const struct expr_ops set_elem_expr_ops = {
 	.type		= EXPR_SET_ELEM,
 	.name		= "set element",
+	.clone		= set_elem_expr_clone,
 	.print		= set_elem_expr_print,
 	.destroy	= set_elem_expr_destroy,
 };
-- 
2.0.5

