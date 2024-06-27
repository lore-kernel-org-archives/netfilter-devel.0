Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E7514EC4E;
	Thu, 27 Jun 2024 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487644; cv=none; b=rCHWhCnwgfUGO9H7UlOAinShOk01YWvju1UrOlKt7rBddOXxiQPysFsxDWYpNT4Hs4ZqsxE0pLVHlFs2vyizfiZE6aRZbwjY2Hw4DQ5yXjLyay6ZrA41mSac2ZJ5RZ25JCGGEeEP2rh30dK4WuCK+zLzo11Z4v5ZhzADDwsTEzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487644; c=relaxed/simple;
	bh=CWN6ZMTU2zDpXqEPXVximbwv431J+f/R1JuLAZKdn2I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jBUKrRJZU0dNM1qUYHZJQJuw75t7vMDFbcsSHvyk4C+uHQGtVUhvj3imlgM2KMjvS7j6X2crUAt0d94pvquruZlixlqedcULIKenu0F8D5PL6NuaI3ik3ml9dKAkMWiRd5TzKrvdSFyQOX8s63/taSuosH9X3OXey2a4cypbQcg=
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
Subject: [PATCH nf-next 05/19] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Thu, 27 Jun 2024 13:26:59 +0200
Message-Id: <20240627112713.4846-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

It would be better to not store nft_ctx inside nft_trans object,
the netlink ctx strucutre is huge and most of its information is
never needed in places that use trans->ctx.

Avoid/reduce its usage if possible, no runtime behaviour change
intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 17 ++++++++---------
 net/netfilter/nft_immediate.c     |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1f0607b671ac..328fdc140551 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1171,7 +1171,7 @@ static inline bool nft_chain_is_bound(struct nft_chain *chain)
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 60c435774db8..bdc2d7f781ca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2118,9 +2118,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -2132,7 +2132,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2621,7 +2621,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_trans:
 	nft_use_dec_restore(&table->use);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -9532,7 +9532,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		if (nft_trans_chain_update(trans))
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
 		else
-			nf_tables_chain_destroy(&trans->ctx);
+			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DESTROYRULE:
@@ -10524,7 +10524,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		if (nft_trans_chain_update(trans))
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
 		else
-			nf_tables_chain_destroy(&trans->ctx);
+			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -11411,7 +11411,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -11486,10 +11486,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
-		ctx.chain = chain;
 		nft_chain_del(chain);
 		nft_use_dec(&table->use);
-		nf_tables_chain_destroy(&ctx);
+		nf_tables_chain_destroy(chain);
 	}
 	nf_tables_table_destroy(&ctx);
 }
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 6475c7abc1fe..ac2422c215e5 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -221,7 +221,7 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 			list_del(&rule->list);
 			nf_tables_rule_destroy(&chain_ctx, rule);
 		}
-		nf_tables_chain_destroy(&chain_ctx);
+		nf_tables_chain_destroy(chain);
 		break;
 	default:
 		break;
-- 
2.30.2

