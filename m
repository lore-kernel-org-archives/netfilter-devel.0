From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: nf_tables: don't allow to rename to already-pending name
Date: Tue, 24 Jul 2018 18:31:31 +0200
Message-ID: <20180724163133.14586-8-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its possible to rename two chains to the same name in one
transaction:

nft add chain t c1
nft add chain t c2
nft 'rename chain t c1 c3;rename chain t c2 c3'

This creates two chains named 'c3'.

Appears to be harmless, both chains can still be deleted both
by name or handle, but, nevertheless, its a bug.

Walk transaction log and also compare vs. the pending renames.

Both chains can still be deleted, but nevertheless it is a bug as
we don't allow to create chains with identical names, so we should
prevent this from happening-by-rename too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 91230d713190..d7b9748e338e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1598,7 +1598,6 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_base_chain *basechain;
 	struct nft_stats *stats = NULL;
 	struct nft_chain_hook hook;
-	const struct nlattr *name;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
 	int err;
@@ -1646,12 +1645,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return PTR_ERR(stats);
 	}
 
+	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
-	if (trans == NULL) {
-		free_percpu(stats);
-		return -ENOMEM;
-	}
+	if (trans == NULL)
+		goto err;
 
 	nft_trans_chain_stats(trans) = stats;
 	nft_trans_chain_update(trans) = true;
@@ -1661,19 +1659,37 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	else
 		nft_trans_chain_policy(trans) = -1;
 
-	name = nla[NFTA_CHAIN_NAME];
-	if (nla[NFTA_CHAIN_HANDLE] && name) {
-		nft_trans_chain_name(trans) =
-			nla_strdup(name, GFP_KERNEL);
-		if (!nft_trans_chain_name(trans)) {
-			kfree(trans);
-			free_percpu(stats);
-			return -ENOMEM;
+	if (nla[NFTA_CHAIN_HANDLE] &&
+	    nla[NFTA_CHAIN_NAME]) {
+		struct nft_trans *tmp;
+		char *name;
+
+		err = -ENOMEM;
+		name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL);
+		if (!name)
+			goto err;
+
+		err = -EEXIST;
+		list_for_each_entry(tmp, &ctx->net->nft.commit_list, list) {
+			if (tmp->msg_type == NFT_MSG_NEWCHAIN &&
+			    tmp->ctx.table == table &&
+			    nft_trans_chain_update(tmp) &&
+			    nft_trans_chain_name(tmp) &&
+			    strcmp(name, nft_trans_chain_name(tmp)) == 0) {
+				kfree(name);
+				goto err;
+			}
 		}
+
+		nft_trans_chain_name(trans) = name;
 	}
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
+err:
+	free_percpu(stats);
+	kfree(trans);
+	return err;
 }
 
 static int nf_tables_newchain(struct net *net, struct sock *nlsk,
-- 
2.11.0
