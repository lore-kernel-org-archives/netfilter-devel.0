From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] evaluate: set: Allow for set elems to be sets
Date: Mon, 20 Mar 2017 17:38:55 +0100
Message-ID: <20170320163856.6064-2-phil@nwl.cc>
References: <20170320163856.6064-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46739 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753229AbdCTRDE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 13:03:04 -0400
In-Reply-To: <20170320163856.6064-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Recursive use of sets is handled in parts by parser_bison.y, which
has a rule for inline unnamed sets in set_list_member_expr, e.g. like
this:

| add rule ip saddr { { 1.1.1.0, 2.2.2.0 }, 3.3.3.0 }

Yet there is another way to have an unnamed set inline, which is via
define:

| define myset = {
| 	1.1.1.0,
| 	2.2.2.0,
| }
| add rule ip saddr { $myset, 3.3.3.0 }

This didn't work because the inline set comes in as EXPR_SET_ELEM with
EXPR_SET as key. This patch handles that case by replacing the former by
a copy of the latter, so the following set list merging can take place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8fb716c062449..86ff8ebd17629 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1132,6 +1132,15 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "Set reference cannot be part of another set");
 
+		if (i->ops->type == EXPR_SET_ELEM &&
+		    i->key->ops->type == EXPR_SET) {
+			struct expr *new = expr_clone(i->key);
+
+			list_replace(&i->list, &new->list);
+			expr_free(i);
+			i = new;
+		}
+
 		if (!expr_is_constant(i))
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
-- 
2.11.0

