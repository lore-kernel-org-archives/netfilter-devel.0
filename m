From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH 3/5] netfilter: nf_tables: Unlimit chain name length
Date: Thu, 20 Jul 2017 17:24:48 +0200
Message-ID: <20170720152450.27693-4-phil@nwl.cc>
References: <20170720152450.27693-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34389 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965393AbdGTPZJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 11:25:09 -0400
In-Reply-To: <20170720152450.27693-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  4 +--
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 43 +++++++++++++++++++++-----------
 net/netfilter/nf_tables_trace.c          |  8 +++---
 4 files changed, 36 insertions(+), 20 deletions(-)

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
index 97f339245c446..08349c9faecda 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d22e8bad123b4..a83438ce89391 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -941,8 +941,7 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
-	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
@@ -1246,8 +1245,10 @@ static void nf_tables_chain_destroy(struct nft_chain *chain)
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
@@ -1472,8 +1473,13 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
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
@@ -1547,7 +1553,11 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
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
@@ -1877,8 +1887,7 @@ static struct nft_rule *nf_tables_rule_lookup(const struct nft_chain *chain,
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_TABLE]	= { .type = NLA_STRING },
-	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
@@ -1981,7 +1990,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 struct nft_rule_dump_ctx {
 	char *table;
-	char chain[NFT_CHAIN_MAXNAMELEN];
+	char *chain;
 };
 
 static int nf_tables_dump_rules(struct sk_buff *skb,
@@ -2049,6 +2058,7 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 
 	if (ctx) {
 		kfree(ctx->table);
+		kfree(ctx->chain);
 		kfree(ctx);
 	}
 	return 0;
@@ -2090,9 +2100,15 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
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
 
@@ -4859,7 +4875,7 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	struct nft_base_chain *basechain;
 
-	if (nft_trans_chain_name(trans)[0])
+	if (nft_trans_chain_name(trans))
 		strcpy(trans->ctx.chain->name, nft_trans_chain_name(trans));
 
 	if (!nft_is_base_chain(trans->ctx.chain))
@@ -5457,8 +5473,7 @@ EXPORT_SYMBOL_GPL(nft_validate_register_store);
 
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
-	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
-				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING },
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

