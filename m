From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/9] netfilter: nf_tables: pass context to object destroy indirection
Date: Sun,  3 Jun 2018 01:14:07 +0200
Message-ID: <20180602231413.31974-4-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The new connlimit object needs this to properly deal with conntrack
dependencies.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 12 ++++++------
 net/netfilter/nft_counter.c       |  3 ++-
 net/netfilter/nft_ct.c            |  3 ++-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 435c32d8a995..81ec070582b6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1070,7 +1070,8 @@ struct nft_object_ops {
 	int				(*init)(const struct nft_ctx *ctx,
 						const struct nlattr *const tb[],
 						struct nft_object *obj);
-	void				(*destroy)(struct nft_object *obj);
+	void				(*destroy)(const struct nft_ctx *ctx,
+						   struct nft_object *obj);
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c785bc5a66f1..177658f4007e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4787,7 +4787,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	kfree(obj->name);
 err2:
 	if (obj->ops->destroy)
-		obj->ops->destroy(obj);
+		obj->ops->destroy(&ctx, obj);
 	kfree(obj);
 err1:
 	module_put(type->owner);
@@ -4997,10 +4997,10 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-static void nft_obj_destroy(struct nft_object *obj)
+static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 {
 	if (obj->ops->destroy)
-		obj->ops->destroy(obj);
+		obj->ops->destroy(ctx, obj);
 
 	module_put(obj->ops->type->owner);
 	kfree(obj->name);
@@ -6003,7 +6003,7 @@ static void nft_commit_release(struct nft_trans *trans)
 					   nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
-		nft_obj_destroy(nft_trans_obj(trans));
+		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_DELFLOWTABLE:
 		nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
@@ -6328,7 +6328,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 				     nft_trans_elem(trans).priv, true);
 		break;
 	case NFT_MSG_NEWOBJ:
-		nft_obj_destroy(nft_trans_obj(trans));
+		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
@@ -7022,7 +7022,7 @@ static void __nft_release_tables(struct net *net)
 		list_for_each_entry_safe(obj, ne, &table->objects, list) {
 			list_del(&obj->list);
 			table->use--;
-			nft_obj_destroy(obj);
+			nft_obj_destroy(&ctx, obj);
 		}
 		list_for_each_entry_safe(chain, nc, &table->chains, list) {
 			ctx.chain = chain;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index eefe3b409925..e59a74d6b7d6 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -96,7 +96,8 @@ static void nft_counter_do_destroy(struct nft_counter_percpu_priv *priv)
 	free_percpu(priv->counter);
 }
 
-static void nft_counter_obj_destroy(struct nft_object *obj)
+static void nft_counter_obj_destroy(const struct nft_ctx *ctx,
+				    struct nft_object *obj)
 {
 	struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index ea737fd789e8..f8b19eacfa0c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -826,7 +826,8 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_ct_helper_obj_destroy(struct nft_object *obj)
+static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
+				      struct nft_object *obj)
 {
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
-- 
2.11.0
