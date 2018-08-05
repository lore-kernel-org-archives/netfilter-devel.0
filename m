From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/21] netfilter: nf_tables: simplify NLM_F_CREATE handling
Date: Sun,  5 Aug 2018 23:21:38 +0200
Message-ID: <20180805212141.3033-19-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* From nf_tables_newchain(), codepath provides context that allows us to
  infer if we are updating a chain (in that case, no module autoload is
  required) or adding a new one (then, module autoload is indeed
  needed).
* We only need it in one single spot in nf_tables_newrule().
* Not needed for nf_tables_newset() at all.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index debc1680607c..67cdd5c4f4f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1442,7 +1442,7 @@ struct nft_chain_hook {
 static int nft_chain_parse_hook(struct net *net,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				bool create)
+				bool autoload)
 {
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	const struct nft_chain_type *type;
@@ -1467,7 +1467,7 @@ static int nft_chain_parse_hook(struct net *net,
 	type = chain_type[family][NFT_CHAIN_T_DEFAULT];
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
-						   family, create);
+						   family, autoload);
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
@@ -1534,7 +1534,7 @@ static struct nft_rule **nf_tables_chain_alloc_rules(const struct nft_chain *cha
 }
 
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
-			      u8 policy, bool create)
+			      u8 policy)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -1552,7 +1552,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		struct nft_chain_hook hook;
 		struct nf_hook_ops *ops;
 
-		err = nft_chain_parse_hook(net, nla, &hook, family, create);
+		err = nft_chain_parse_hook(net, nla, &hook, family, true);
 		if (err < 0)
 			return err;
 
@@ -1643,8 +1643,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	return err;
 }
 
-static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
-			      bool create)
+static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -1661,7 +1660,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EBUSY;
 
 		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   create);
+					   false);
 		if (err < 0)
 			return err;
 
@@ -1761,9 +1760,6 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	u8 policy = NF_ACCEPT;
 	struct nft_ctx ctx;
 	u64 handle = 0;
-	bool create;
-
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
@@ -1828,10 +1824,10 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		return nf_tables_updchain(&ctx, genmask, policy, create);
+		return nf_tables_updchain(&ctx, genmask, policy);
 	}
 
-	return nf_tables_addchain(&ctx, family, genmask, policy, create);
+	return nf_tables_addchain(&ctx, family, genmask, policy);
 }
 
 static int nf_tables_delchain(struct net *net, struct sock *nlsk,
@@ -2529,13 +2525,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	struct nlattr *tmp;
 	unsigned int size, i, n, ulen = 0, usize = 0;
 	int err, rem;
-	bool create;
 	u64 handle, pos_handle;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
 
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
@@ -2565,7 +2558,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		else
 			return -EOPNOTSUPP;
 	} else {
-		if (!create || nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (!(nlh->nlmsg_flags & NLM_F_CREATE) ||
+		    nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EINVAL;
 		handle = nf_tables_alloc_handle(table);
 
@@ -3361,7 +3355,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	char *name;
 	unsigned int size;
-	bool create;
 	u64 timeout;
 	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct nft_set_desc desc;
@@ -3462,8 +3455,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
-	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
-
 	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
-- 
2.11.0
