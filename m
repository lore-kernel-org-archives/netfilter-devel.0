Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53691C5798;
	Fri, 15 Nov 2024 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677542; cv=none; b=Cov5zBzCczh/od3MBRlW5oyc3xEJNNHXZq7LF8sTZXDXm6Pwh9nYlksfcbyRMArRUc9a9B3c9kCoOUnw1WId6KeNdGlYAMHFparwxyFaBeobZkPa+Lxnjo9fT/H2r2jB+WqgTpJWkr0ug5V6Kbg3INj4evwMKLK+4B+lAADlxaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677542; c=relaxed/simple;
	bh=fsqVCtkIKMvzTYxtYJlNJmh89UY495eE7v2LKMsCypA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CQiaP2bX1n5xKiwRs/ityVgwRoaqBu7aCRUso3GnuoCxIKz8MQB6OnO8Zm2mqaGHi2ZkKP+mabXwWqJDlcvySKLqgt3QwPrWKvV7NmGAmsFpZ652aE+jNeiwAwSkJ0AU7stJoljjjefHwHXrf54aVpvrQBBlANmg6DwLTaUAqGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 03/14] netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
Date: Fri, 15 Nov 2024 14:31:56 +0100
Message-Id: <20241115133207.8907-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add and use a wrapper to append trans_elem structures to the
transaction log.

Unlike the existing helper, pass a gfp_t to indicate if sleeping
is allowed.

This will be used by a followup patch to realloc nft_trans_elem
structures after they gain a flexible array member to reduce
number of such container structures on the transaction list.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6090ba9f1bb2..75c84b17ab99 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -421,6 +421,17 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
+					   gfp_t gfp)
+{
+	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
+		     trans->msg_type != NFT_MSG_DELSETELEM);
+
+	might_alloc(gfp);
+
+	nft_trans_commit_list_add_tail(net, trans);
+}
+
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
@@ -7205,7 +7216,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					if (update_flags) {
 						nft_trans_elem_priv(trans) = elem_priv;
 						nft_trans_elem_update_flags(trans) = update_flags;
-						nft_trans_commit_list_add_tail(ctx->net, trans);
+						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 						goto err_elem_free;
 					}
 				}
@@ -7229,7 +7240,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 err_set_full:
@@ -7446,7 +7457,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_elem_priv(trans) = elem.priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 	return 0;
 
 fail_ops:
@@ -7482,7 +7493,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
 
 	return 0;
 }
@@ -7499,7 +7510,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_elem_priv(trans) = elem_priv;
-	nft_trans_commit_list_add_tail(ctx->net, trans);
+	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
 
 	return 0;
 }
-- 
2.30.2

