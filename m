From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 024/123] netfilter: nf_tables: fix use-after-free when deleting compat expressions
Date: Wed,  5 Dec 2018 04:34:16 -0500
Message-ID: <20181205093555.5386-24-sashal@kernel.org>
References: <20181205093555.5386-1-sashal@kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205093555.5386-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 29e3880109e357fdc607b4393f8308cef6af9413 ]

nft_compat ops do not have static storage duration, unlike all other
expressions.

When nf_tables_expr_destroy() returns, expr->ops might have been
free'd already, so we need to store next address before calling
expression destructor.

For same reason, we can't deref match pointer after nft_xt_put().

This can be easily reproduced by adding msleep() before
nft_match_destroy() returns.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 net/netfilter/nft_compat.c    | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4c016b49fe2b..06ed55cef962 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2432,7 +2432,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
-	struct nft_expr *expr;
+	struct nft_expr *expr, *next;
 
 	lockdep_assert_held(&ctx->net->nft.commit_mutex);
 	/*
@@ -2441,8 +2441,9 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	 */
 	expr = nft_expr_first(rule);
 	while (expr != nft_expr_last(rule) && expr->ops) {
+		next = nft_expr_next(expr);
 		nf_tables_expr_destroy(ctx, expr);
-		expr = nft_expr_next(expr);
+		expr = next;
 	}
 	kfree(rule);
 }
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index ad2fe6a7e47d..29d6fc73caf9 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -501,6 +501,7 @@ __nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		    void *info)
 {
 	struct xt_match *match = expr->ops->data;
+	struct module *me = match->me;
 	struct xt_mtdtor_param par;
 
 	par.net = ctx->net;
@@ -511,7 +512,7 @@ __nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		par.match->destroy(&par);
 
 	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
-		module_put(match->me);
+		module_put(me);
 }
 
 static void
-- 
2.17.1
