From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 42/47] netfilter: nf_tables: rename to nft_set_lookup_global()
Date: Fri, 30 Mar 2018 13:46:14 +0200
Message-ID: <20180330114619.18797-3-pablo@netfilter.org>
References: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114619.18797-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

To prepare shorter introduction of shorter function prefix.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 10 +++++-----
 net/netfilter/nf_tables_api.c     | 12 ++++++------
 net/netfilter/nft_dynset.c        |  5 +++--
 net/netfilter/nft_lookup.c        |  4 ++--
 net/netfilter/nft_objref.c        |  5 +++--
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e26b94a61a99..bd2a18d66189 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -434,11 +434,11 @@ static inline struct nft_set *nft_set_container_of(const void *priv)
 	return (void *)priv - offsetof(struct nft_set, data);
 }
 
-struct nft_set *nft_set_lookup(const struct net *net,
-			       const struct nft_table *table,
-			       const struct nlattr *nla_set_name,
-			       const struct nlattr *nla_set_id,
-			       u8 genmask);
+struct nft_set *nft_set_lookup_global(const struct net *net,
+				      const struct nft_table *table,
+				      const struct nlattr *nla_set_name,
+				      const struct nlattr *nla_set_id,
+				      u8 genmask);
 
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af8b6a7488bd..769d84015073 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2633,11 +2633,11 @@ static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
-struct nft_set *nft_set_lookup(const struct net *net,
-			       const struct nft_table *table,
-			       const struct nlattr *nla_set_name,
-			       const struct nlattr *nla_set_id,
-			       u8 genmask)
+struct nft_set *nft_set_lookup_global(const struct net *net,
+				      const struct nft_table *table,
+				      const struct nlattr *nla_set_name,
+				      const struct nlattr *nla_set_id,
+				      u8 genmask)
 {
 	struct nft_set *set;
 
@@ -2650,7 +2650,7 @@ struct nft_set *nft_set_lookup(const struct net *net,
 	}
 	return set;
 }
-EXPORT_SYMBOL_GPL(nft_set_lookup);
+EXPORT_SYMBOL_GPL(nft_set_lookup_global);
 
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index fc83e29d6634..04863fad05dd 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -132,8 +132,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			priv->invert = true;
 	}
 
-	set = nft_set_lookup(ctx->net, ctx->table, tb[NFTA_DYNSET_SET_NAME],
-			     tb[NFTA_DYNSET_SET_ID], genmask);
+	set = nft_set_lookup_global(ctx->net, ctx->table,
+				    tb[NFTA_DYNSET_SET_NAME],
+				    tb[NFTA_DYNSET_SET_ID], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 475570e89ede..f52da5e2199f 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -71,8 +71,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	    tb[NFTA_LOOKUP_SREG] == NULL)
 		return -EINVAL;
 
-	set = nft_set_lookup(ctx->net, ctx->table, tb[NFTA_LOOKUP_SET],
-			     tb[NFTA_LOOKUP_SET_ID], genmask);
+	set = nft_set_lookup_global(ctx->net, ctx->table, tb[NFTA_LOOKUP_SET],
+				    tb[NFTA_LOOKUP_SET_ID], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7bcdc48f3d73..0b02407773ad 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -117,8 +117,9 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	struct nft_set *set;
 	int err;
 
-	set = nft_set_lookup(ctx->net, ctx->table, tb[NFTA_OBJREF_SET_NAME],
-			     tb[NFTA_OBJREF_SET_ID], genmask);
+	set = nft_set_lookup_global(ctx->net, ctx->table,
+				    tb[NFTA_OBJREF_SET_NAME],
+				    tb[NFTA_OBJREF_SET_ID], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-- 
2.11.0
