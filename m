From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/33] netfilter: nf_tables: prepare nft_object for lookups via hashtable
Date: Tue, 29 Jan 2019 00:57:18 +0100
Message-ID: <20190128235750.18412-2-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add a 'key' structure for object, so we can look them up by name + table
combination (the name can be the same in each table).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 19 ++++++++++++++-----
 net/netfilter/nf_tables_api.c     | 27 ++++++++++++++++-----------
 net/netfilter/nft_objref.c        |  2 +-
 net/netfilter/nft_quota.c         |  2 +-
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 841835a387e1..325d0a6b808b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1012,11 +1012,21 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
 		     const struct nft_verdict *v);
 
 /**
+ *	struct nft_object_hash_key - key to lookup nft_object
+ *
+ *	@name: name of the stateful object to look up
+ *	@table: table the object belongs to
+ */
+struct nft_object_hash_key {
+	const char                      *name;
+	const struct nft_table          *table;
+};
+
+/**
  *	struct nft_object - nf_tables stateful object
  *
  *	@list: table stateful object list node
- *	@table: table this object belongs to
- *	@name: name of this stateful object
+ *	@key:  keys that identify this object
  *	@genmask: generation mask
  *	@use: number of references to this stateful object
  *	@handle: unique object handle
@@ -1025,8 +1035,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  */
 struct nft_object {
 	struct list_head		list;
-	char				*name;
-	struct nft_table		*table;
+	struct nft_object_hash_key	key;
 	u32				genmask:2,
 					use:30;
 	u64				handle;
@@ -1047,7 +1056,7 @@ struct nft_object *nft_obj_lookup(const struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask);
 
-void nft_obj_notify(struct net *net, struct nft_table *table,
+void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq,
 		    int event, int family, int report, gfp_t gfp);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2b0a93300dd7..5e213941e85b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3853,7 +3853,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
 	    nla_put_string(skb, NFTA_SET_ELEM_OBJREF,
-			   (*nft_set_ext_obj(ext))->name) < 0)
+			   (*nft_set_ext_obj(ext))->key.name) < 0)
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
@@ -4826,7 +4826,7 @@ struct nft_object *nft_obj_lookup(const struct nft_table *table,
 	struct nft_object *obj;
 
 	list_for_each_entry_rcu(obj, &table->objects, list) {
-		if (!nla_strcmp(nla, obj->name) &&
+		if (!nla_strcmp(nla, obj->key.name) &&
 		    objtype == obj->ops->type->type &&
 		    nft_active_genmask(obj, genmask))
 			return obj;
@@ -5014,11 +5014,11 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		err = PTR_ERR(obj);
 		goto err1;
 	}
-	obj->table = table;
+	obj->key.table = table;
 	obj->handle = nf_tables_alloc_handle(table);
 
-	obj->name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
-	if (!obj->name) {
+	obj->key.name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
+	if (!obj->key.name) {
 		err = -ENOMEM;
 		goto err2;
 	}
@@ -5031,7 +5031,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	table->use++;
 	return 0;
 err3:
-	kfree(obj->name);
+	kfree(obj->key.name);
 err2:
 	if (obj->ops->destroy)
 		obj->ops->destroy(&ctx, obj);
@@ -5060,7 +5060,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
-	    nla_put_string(skb, NFTA_OBJ_NAME, obj->name) ||
+	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
 	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset) ||
@@ -5246,7 +5246,7 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 		obj->ops->destroy(ctx, obj);
 
 	module_put(obj->ops->type->owner);
-	kfree(obj->name);
+	kfree(obj->key.name);
 	kfree(obj);
 }
 
@@ -5297,7 +5297,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	return nft_delobj(&ctx, obj);
 }
 
-void nft_obj_notify(struct net *net, struct nft_table *table,
+void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
 		    int family, int report, gfp_t gfp)
 {
@@ -6404,6 +6404,11 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
+static void nft_obj_del(struct nft_object *obj)
+{
+	list_del_rcu(&obj->list);
+}
+
 static void nft_chain_del(struct nft_chain *chain)
 {
 	struct nft_table *table = chain->table;
@@ -6580,7 +6585,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELOBJ:
-			list_del_rcu(&nft_trans_obj(trans)->list);
+			nft_obj_del(nft_trans_obj(trans));
 			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
 					     NFT_MSG_DELOBJ);
 			break;
@@ -7330,7 +7335,7 @@ static void __nft_release_tables(struct net *net)
 			nft_set_destroy(set);
 		}
 		list_for_each_entry_safe(obj, ne, &table->objects, list) {
-			list_del(&obj->list);
+			nft_obj_del(obj);
 			table->use--;
 			nft_obj_destroy(&ctx, obj);
 		}
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index a3185ca2a3a9..58eb75ad61bf 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -53,7 +53,7 @@ static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_object *obj = nft_objref_priv(expr);
 
-	if (nla_put_string(skb, NFTA_OBJREF_IMM_NAME, obj->name) ||
+	if (nla_put_string(skb, NFTA_OBJREF_IMM_NAME, obj->key.name) ||
 	    nla_put_be32(skb, NFTA_OBJREF_IMM_TYPE,
 			 htonl(obj->ops->type->type)))
 		goto nla_put_failure;
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0ed124a93fcf..354cde67bca9 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -61,7 +61,7 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 
 	if (overquota &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
-		nft_obj_notify(nft_net(pkt), obj->table, obj, 0, 0,
+		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
 			       NFT_MSG_NEWOBJ, nft_pf(pkt), 0, GFP_ATOMIC);
 }
 
-- 
2.11.0
