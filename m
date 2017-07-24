From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v2 3/5] netfilter: nf_tables: Unlimit chain name length
Date: Mon, 24 Jul 2017 20:56:49 +0200
Message-ID: <20170724185651.24063-4-phil@nwl.cc>
References: <20170724185651.24063-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51313 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756020AbdGXS5W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 14:57:22 -0400
In-Reply-To: <20170724185651.24063-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same conversion as for table names, use NFT_NAME_MAXLEN as upper
boundary as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  4 ++--
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 40 +++++++++++++++++++++++---------
 net/netfilter/nf_tables_trace.c          |  8 ++++---
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 05ecf78ec0787..be1610162ee02 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -859,7 +859,7 @@ struct nft_chain {
 	u16				level;
 	u8				flags:6,
 					genmask:2;
-	char				name[NFT_CHAIN_MAXNAMELEN];
+	char				*name;
 };
 
 enum nft_chain_type {
@@ -1272,7 +1272,7 @@ struct nft_trans_set {
 
 struct nft_trans_chain {
 	bool				update;
-	char				name[NFT_CHAIN_MAXNAMELEN];
+	char				*name;
 	struct nft_stats __percpu	*stats;
 	u8				policy;
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 35d1d9a21508e..29e57df26530f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2,7 +2,6 @@
 #define _LINUX_NF_TABLES_H
 
 #define NFT_NAME_MAXLEN		256
-#define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf12f63606aaf..002898e557a92 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -944,7 +944,7 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
@@ -1248,8 +1248,10 @@ static void nf_tables_chain_destroy(struct nft_chain *chain)
 		free_percpu(basechain->stats);
 		if (basechain->ops[0].dev != NULL)
 			dev_put(basechain->ops[0].dev);
+		kfree(chain->name);
 		kfree(basechain);
 	} else {
+		kfree(chain->name);
 		kfree(chain);
 	}
 }
@@ -1474,8 +1476,13 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 			nft_trans_chain_policy(trans) = -1;
 
 		if (nla[NFTA_CHAIN_HANDLE] && name) {
-			nla_strlcpy(nft_trans_chain_name(trans), name,
-				    NFT_CHAIN_MAXNAMELEN);
+			nft_trans_chain_name(trans) =
+				nla_strdup(name, GFP_KERNEL);
+			if (!nft_trans_chain_name(trans)) {
+				kfree(trans);
+				free_percpu(stats);
+				return -ENOMEM;
+			}
 		}
 		list_add_tail(&trans->list, &net->nft.commit_list);
 		return 0;
@@ -1549,7 +1556,11 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	INIT_LIST_HEAD(&chain->rules);
 	chain->handle = nf_tables_alloc_handle(table);
 	chain->table = table;
-	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
+	chain->name = nla_strdup(name, GFP_KERNEL);
+	if (!chain->name) {
+		err = -ENOMEM;
+		goto err1;
+	}
 
 	err = nf_tables_register_hooks(net, table, chain, afi->nops);
 	if (err < 0)
@@ -1881,7 +1892,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_TABLE]	= { .type = NLA_STRING,
 				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
@@ -1984,7 +1995,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 struct nft_rule_dump_ctx {
 	char *table;
-	char chain[NFT_CHAIN_MAXNAMELEN];
+	char *chain;
 };
 
 static int nf_tables_dump_rules(struct sk_buff *skb,
@@ -2052,6 +2063,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 
 	if (ctx) {
 		kfree(ctx->table);
+		kfree(ctx->chain);
 		kfree(ctx);
 	}
 	return 0;
@@ -2093,9 +2105,15 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 					return -ENOMEM;
 				}
 			}
-			if (nla[NFTA_RULE_CHAIN])
-				nla_strlcpy(ctx->chain, nla[NFTA_RULE_CHAIN],
-					    sizeof(ctx->chain));
+			if (nla[NFTA_RULE_CHAIN]) {
+				ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN],
+							GFP_KERNEL);
+				if (!ctx->chain) {
+					kfree(ctx->table);
+					kfree(ctx);
+					return -ENOMEM;
+				}
+			}
 			c.data = ctx;
 		}
 
@@ -4865,7 +4883,7 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	struct nft_base_chain *basechain;
 
-	if (nft_trans_chain_name(trans)[0])
+	if (nft_trans_chain_name(trans))
 		strcpy(trans->ctx.chain->name, nft_trans_chain_name(trans));
 
 	if (!nft_is_base_chain(trans->ctx.chain))
@@ -5464,7 +5482,7 @@ EXPORT_SYMBOL_GPL(nft_validate_register_store);
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
 	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 };
 
 static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e95098c1faaf0..37e664baeb18c 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -175,12 +175,10 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		return;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
-		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
 		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
 		nla_total_size(sizeof(__be32)) +	/* trace type */
 		nla_total_size(0) +			/* VERDICT, nested */
 			nla_total_size(sizeof(u32)) +	/* verdict code */
-			nla_total_size(NFT_CHAIN_MAXNAMELEN) + /* jump target */
 		nla_total_size(sizeof(u32)) +		/* id */
 		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
@@ -194,7 +192,11 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		nla_total_size(sizeof(u32));		/* policy */
 
 	if (info->chain)
-		size += nla_total_size(strlen(info->chain->table->name));
+		size += nla_total_size(strlen(info->chain->table->name)) +
+			nla_total_size(strlen(info->chain->name));
+
+	if (info->verdict->chain)
+		size += nla_total_size(strlen(info->verdict->chain->name)); /* jump target */
 
 	skb = nlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
-- 
2.13.1

