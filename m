From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: nf_tables: fix oob access
Date: Thu,  5 Jan 2017 12:19:50 +0100
Message-ID: <1483615193-2931-4-git-send-email-pablo@netfilter.org>
References: <1483615193-2931-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1483615193-2931-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

BUG: KASAN: slab-out-of-bounds in nf_tables_rule_destroy+0xf1/0x130 at addr ffff88006a4c35c8
Read of size 8 by task nft/1607

When we've destroyed last valid expr, nft_expr_next() returns an invalid expr.
We must not dereference it unless it passes != nft_expr_last() check.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.1.4
