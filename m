From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: nft_compat: use-after-free when deleting targets
Date: Wed, 13 Feb 2019 18:47:58 +0100
Message-ID: <20190213174758.17275-4-pablo@netfilter.org>
References: <20190213174758.17275-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213174758.17275-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fetch pointer to module before target object is released.

Fixes: 29e3880109e3 ("netfilter: nf_tables: fix use-after-free when deleting compat expressions")
Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index fe64df848365..0a4bad55a8aa 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -315,6 +315,7 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	struct xt_target *target = expr->ops->data;
 	void *info = nft_expr_priv(expr);
+	struct module *me = target->me;
 	struct xt_tgdtor_param par;
 
 	par.net = ctx->net;
@@ -325,7 +326,7 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 		par.target->destroy(&par);
 
 	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
-		module_put(target->me);
+		module_put(me);
 }
 
 static int nft_extension_dump_info(struct sk_buff *skb, int attr,
-- 
2.11.0
