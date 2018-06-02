From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/9] netfilter: nf_tables: garbage collection for stateful expressions
Date: Sun,  3 Jun 2018 01:14:10 +0200
Message-ID: <20180602231413.31974-7-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use garbage collector to schedule removal of elements based of feedback
from expression that this element comes with. Therefore, the garbage
collector is not guided by timeout expirations in this new mode.

The new connlimit expression sets on the NFT_EXPR_GC flag to enable this
behaviour, the dynset expression needs to explicitly enable the garbage
collector via set->ops->gc_init call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_dynset.c        |  9 +++++++++
 net/netfilter/nft_set_hash.c      | 21 +++++++++++++++++++--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e3d1bac9b0d5..871cb3b012e9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -342,6 +342,7 @@ struct nft_set_ops {
 						const struct nft_set_desc *desc,
 						const struct nlattr * const nla[]);
 	void				(*destroy)(const struct nft_set *set);
+	void				(*gc_init)(const struct nft_set *set);
 
 	unsigned int			elemsize;
 };
@@ -712,6 +713,7 @@ struct nft_expr_type {
 };
 
 #define NFT_EXPR_STATEFUL		0x1
+#define NFT_EXPR_GC			0x2
 
 /**
  *	struct nft_expr_ops - nf_tables expression operations
@@ -748,6 +750,8 @@ struct nft_expr_ops {
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
+	bool				(*gc)(struct net *net,
+					      const struct nft_expr *expr);
 	const struct nft_expr_type	*type;
 	void				*data;
 };
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index b07a3fd9eeea..4d49529cff61 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -195,6 +195,15 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		err = -EOPNOTSUPP;
 		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
 			goto err1;
+
+		if (priv->expr->ops->type->flags & NFT_EXPR_GC) {
+			if (set->flags & NFT_SET_TIMEOUT)
+				goto err1;
+			if (!set->ops->gc_init)
+				goto err1;
+			set->ops->gc_init(set);
+		}
+
 	} else if (set->flags & NFT_SET_EVAL)
 		return -EINVAL;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index dbf1f4ad077c..6f9a1365a09f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -311,8 +311,16 @@ static void nft_rhash_gc(struct work_struct *work)
 			continue;
 		}
 
+		if (nft_set_ext_exists(&he->ext, NFT_SET_EXT_EXPR)) {
+			struct nft_expr *expr = nft_set_ext_expr(&he->ext);
+
+			if (expr->ops->gc &&
+			    expr->ops->gc(read_pnet(&set->net), expr))
+				goto gc;
+		}
 		if (!nft_set_elem_expired(&he->ext))
 			continue;
+gc:
 		if (nft_set_elem_mark_busy(&he->ext))
 			continue;
 
@@ -339,6 +347,14 @@ static unsigned int nft_rhash_privsize(const struct nlattr * const nla[],
 	return sizeof(struct nft_rhash);
 }
 
+static void nft_rhash_gc_init(const struct nft_set *set)
+{
+	struct nft_rhash *priv = nft_set_priv(set);
+
+	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
+			   nft_set_gc_interval(set));
+}
+
 static int nft_rhash_init(const struct nft_set *set,
 			  const struct nft_set_desc *desc,
 			  const struct nlattr * const tb[])
@@ -356,8 +372,8 @@ static int nft_rhash_init(const struct nft_set *set,
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rhash_gc);
 	if (set->flags & NFT_SET_TIMEOUT)
-		queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
-				   nft_set_gc_interval(set));
+		nft_rhash_gc_init(set);
+
 	return 0;
 }
 
@@ -647,6 +663,7 @@ static struct nft_set_type nft_rhash_type __read_mostly = {
 		.elemsize	= offsetof(struct nft_rhash_elem, ext),
 		.estimate	= nft_rhash_estimate,
 		.init		= nft_rhash_init,
+		.gc_init	= nft_rhash_gc_init,
 		.destroy	= nft_rhash_destroy,
 		.insert		= nft_rhash_insert,
 		.activate	= nft_rhash_activate,
-- 
2.11.0
