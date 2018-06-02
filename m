From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/9] netfilter: nf_tables: pass ctx to nf_tables_expr_destroy()
Date: Sun,  3 Jun 2018 01:14:09 +0200
Message-ID: <20180602231413.31974-6-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

nft_set_elem_destroy() can be called from call_rcu context. Annotate
netns and table in set object so we can populate the context object.
Moreover, pass context object to nf_tables_set_elem_destroy() from the
commit phase, since it is already available from there.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 81ec070582b6..e3d1bac9b0d5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -370,6 +370,8 @@ void nft_unregister_set(struct nft_set_type *type);
  *
  *	@list: table set list node
  *	@bindings: list of set bindings
+ *	@table: table this set belongs to
+ *	@net: netnamespace this set belongs to
  * 	@name: name of the set
  *	@handle: unique handle of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
@@ -393,6 +395,8 @@ void nft_unregister_set(struct nft_set_type *type);
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
+	struct nft_table		*table;
+	possible_net_t			net;
 	char				*name;
 	u64				handle;
 	u32				ktype;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 177658f4007e..12463984dd5c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3359,6 +3359,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	set->table = table;
+	write_pnet(&set->net, net);
 	set->ops   = ops;
 	set->ktype = ktype;
 	set->klen  = desc.klen;
@@ -4036,12 +4038,16 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
+	struct nft_ctx ctx = {
+		.net	= read_pnet(&set->net),
+		.family	= set->table->family,
+	};
 
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
 	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
+		nf_tables_expr_destroy(&ctx, nft_set_ext_expr(ext));
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		(*nft_set_ext_obj(ext))->use--;
 	kfree(elem);
@@ -4051,12 +4057,13 @@ EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 /* Only called from commit path, nft_set_elem_deactivate() already deals with
  * the refcounting from the preparation phase.
  */
-static void nf_tables_set_elem_destroy(const struct nft_set *set, void *elem)
+static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
+				       const struct nft_set *set, void *elem)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-		nf_tables_expr_destroy(NULL, nft_set_ext_expr(ext));
+		nf_tables_expr_destroy(ctx, nft_set_ext_expr(ext));
 	kfree(elem);
 }
 
@@ -5999,7 +6006,8 @@ static void nft_commit_release(struct nft_trans *trans)
 		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
-		nf_tables_set_elem_destroy(nft_trans_elem_set(trans),
+		nf_tables_set_elem_destroy(&trans->ctx,
+					   nft_trans_elem_set(trans),
 					   nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
-- 
2.11.0
