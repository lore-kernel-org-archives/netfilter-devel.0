From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: fix oob access
Date: Tue, 13 Dec 2016 13:59:33 +0100
Message-ID: <1481633973-11621-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41922 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750703AbcLMM7R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 07:59:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BUG: KASAN: slab-out-of-bounds in nf_tables_rule_destroy+0xf1/0x130 at addr ffff88006a4c35c8
Read of size 8 by task nft/1607

When we've destroyed last valid expr, nft_expr_next() returns an invalid expr.
We must not dereference it unless it passes != nft_expr_last() check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I dislike nft_expr_last() naming, it doesn't return last
 valid expression but an invalid address...

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a019a87e58ee..0db5f9782265 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2115,7 +2115,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	 * is called on error from nf_tables_newrule().
 	 */
 	expr = nft_expr_first(rule);
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (expr != nft_expr_last(rule) && expr->ops) {
 		nf_tables_expr_destroy(ctx, expr);
 		expr = nft_expr_next(expr);
 	}
-- 
2.7.3

