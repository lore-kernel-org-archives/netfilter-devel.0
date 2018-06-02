From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: nf_tables: add destroy_clone expression
Date: Sun,  3 Jun 2018 01:14:11 +0200
Message-ID: <20180602231413.31974-8-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Before this patch, cloned expressions are released via ->destroy. This
is a problem for the new connlimit expression since the ->destroy path
drop a reference on the conntrack modules and it unregisters hooks. The
new ->destroy_clone provides context that this expression is being
released from the packet path, so it is mirroring ->clone(), where
neither module reference is dropped nor hooks need to be unregistered -
because this done from the control plane path from the ->init() path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 12 ++++++++++--
 net/netfilter/nft_counter.c       |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 871cb3b012e9..83e7b83ecf3e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -745,6 +745,8 @@ struct nft_expr_ops {
 						      const struct nft_expr *expr);
 	void				(*destroy)(const struct nft_ctx *ctx,
 						   const struct nft_expr *expr);
+	void				(*destroy_clone)(const struct nft_ctx *ctx,
+							 const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
 	int				(*validate)(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 12463984dd5c..0a6eafa49879 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4046,8 +4046,16 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
-	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-		nf_tables_expr_destroy(&ctx, nft_set_ext_expr(ext));
+	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
+		struct nft_expr *expr = nft_set_ext_expr(ext);
+
+		if (expr->ops->destroy_clone) {
+			expr->ops->destroy_clone(&ctx, expr);
+			module_put(expr->ops->type->owner);
+		} else {
+			nf_tables_expr_destroy(&ctx, expr);
+		}
+	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		(*nft_set_ext_obj(ext))->use--;
 	kfree(elem);
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index e59a74d6b7d6..a61d7edfc290 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -258,6 +258,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.eval		= nft_counter_eval,
 	.init		= nft_counter_init,
 	.destroy	= nft_counter_destroy,
+	.destroy_clone	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
 	.clone		= nft_counter_clone,
 };
-- 
2.11.0
