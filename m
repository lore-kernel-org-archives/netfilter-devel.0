From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 4/6] netfilter: nf_tables: Allow chain name of up to 255 chars
Date: Thu, 27 Jul 2017 16:56:42 +0200
Message-ID: <20170727145644.16888-5-phil@nwl.cc>
References: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49299 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751623AbdG0O5e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:57:34 -0400
In-Reply-To: <20170727145644.16888-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same conversion as for table names, use NFT_NAME_MAXLEN as upper
boundary as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Introduce NFT_NAME_MAXLEN as an upper boundary to restrict overly long
  names but still allow to use e.g. domain names.
- Adjust commit messages accordingly.

Changes since v2:
- Adjust commit summary - length is not really unlimited.
- Don't drop NFT_CHAIN_MAXNAMELEN macro since it's UAPI.
- Keep using NFT_CHAIN_MAXNAMELEN in netlink policies to reduce patch
  size.
- Be more pedantic when checking for existence of
  info->verdict->chain->name.
---
 include/net/netfilter/nf_tables.h        |  4 ++--
 include/uapi/linux/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c            | 34 ++++++++++++++++++++++++--------
 net/netfilter/nf_tables_trace.c          | 27 +++++++++++++++++++++++--
 4 files changed, 54 insertions(+), 13 deletions(-)

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
index f796da401672b..6b586f43bd53a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -3,7 +3,7 @@
 
 #define NFT_NAME_MAXLEN		256
 #define NFT_TABLE_MAXNAMELEN	NFT_NAME_MAXLEN
-#define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_CHAIN_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dd824def0a182..55368ad7b9e7a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
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
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 62787d985e9d3..e1dc527a493b8 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -162,6 +162,27 @@ static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 			    NFTA_TRACE_PAD);
 }
 
+static bool nft_trace_have_verdict_chain(struct nft_traceinfo *info)
+{
+	switch (info->type) {
+	case NFT_TRACETYPE_RETURN:
+	case NFT_TRACETYPE_RULE:
+		break;
+	default:
+		return false;
+	}
+
+	switch (info->verdict->code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 void nft_trace_notify(struct nft_traceinfo *info)
 {
 	const struct nft_pktinfo *pkt = info->pkt;
@@ -176,12 +197,11 @@ void nft_trace_notify(struct nft_traceinfo *info)
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
 		nla_total_size(strlen(info->chain->table->name)) +
-		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
+		nla_total_size(strlen(info->chain->name)) +
 		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
 		nla_total_size(sizeof(__be32)) +	/* trace type */
 		nla_total_size(0) +			/* VERDICT, nested */
 			nla_total_size(sizeof(u32)) +	/* verdict code */
-			nla_total_size(NFT_CHAIN_MAXNAMELEN) + /* jump target */
 		nla_total_size(sizeof(u32)) +		/* id */
 		nla_total_size(NFT_TRACETYPE_LL_HSIZE) +
 		nla_total_size(NFT_TRACETYPE_NETWORK_HSIZE) +
@@ -194,6 +214,9 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		nla_total_size(sizeof(u32)) +		/* nfproto */
 		nla_total_size(sizeof(u32));		/* policy */
 
+	if (nft_trace_have_verdict_chain(info))
+		size += nla_total_size(strlen(info->verdict->chain->name)); /* jump target */
+
 	skb = nlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
 		return;
-- 
2.13.1

