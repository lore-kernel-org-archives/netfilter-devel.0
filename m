From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: reject set references in set elements
Date: Mon, 29 Feb 2016 17:50:39 +0100
Message-ID: <1456764639-28299-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46872 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbcB2QuW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 11:50:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

given

table filter {
  set local {
    type iface_index
    elements = { lo }
  }
  chain input {
    type filter hook input priority 0;
    iif { @lan, } accept;
  }
}

nft BUG()s.  I don't see how we could support sets-in-set; add a sanity
check and error out instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index ed78896..a49cdd9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -920,6 +920,11 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
+		if (i->ops->type == EXPR_SET_ELEM &&
+		    i->key->ops->type == EXPR_SET_REF)
+			return expr_error(ctx->msgs, i,
+					  "Set reference cannot be part of another set");
+
 		if (!expr_is_constant(i))
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
-- 
2.4.10

