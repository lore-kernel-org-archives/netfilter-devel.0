Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3F921E0A2;
	Tue, 20 May 2025 00:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700566; cv=none; b=hRStpTZBppG5SbRcbkpoIhb4273cJe8nJWGJmkmZlepEe+ByE/jt9tHSZAbE/MuwhWvfUH+kl+bJ7gcNk3jajdtmJQ8cwSW7N8A/yuICEQTP8/3I49cauBu+bZetCu6gaBk0zy/nIqPAg6zqKnXrdatKai32Tj9qbX52JfYGWFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700566; c=relaxed/simple;
	bh=hKZ+H1WwZ4x3lTYsB6YWT/oA5EmqyhXU4hA6iCXUdPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tOXlUPzup3J6wjZuoC44Kt77Yg0hFz+h9wpHL9chnvZeiqWAVdYQ0OkITFoLuqOSWrxnzAKPW/6wGnwuU4tduTsKQe6UMoUFxijEKwzbnYzRqvurF3bdslzDKLv6X/8O41QJ82SaG9oAFfn7L2polLSkMKs9szkIvAd8pV7OKQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FHcdkpII; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hbmEtNqv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FHcdkpII";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hbmEtNqv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 596A66027A; Tue, 20 May 2025 02:22:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700562;
	bh=U+rRjl9s1p5NGYNjhlVAEHbxUwkm2Gi0n0DDtVAG0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHcdkpIIYOODo7r8cxRIGAeI0woO/YjGb4atH+s1xU1qTibEObVvseEE0L+H5ywys
	 QC9Vapo0ShFkBIft9J7lPzie06+cR0matn5ONrHdVOw3qHRzvFoNm6K2rIRNVRCoOn
	 g+pf3xXf7Yy/3/wpze+OHIWoa0n/j5G9WGuLe0hKrbLPj0ZHbZEioAjPEeWoPjitA+
	 eoBenJTP/lbiHKfP7qGZkRD3ovM1luRHp4RJ8v8Bo/P/7BX3mJguZdt4d2qd2mBjN0
	 0nuUEvg0/0hZIMUlUFc9YJAZynIcX6l+1HkeBEVTP4zDBJJqMy4h42JsWeneSiAm5I
	 3w/0olt/wp0OA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 40DC760264;
	Tue, 20 May 2025 02:22:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700561;
	bh=U+rRjl9s1p5NGYNjhlVAEHbxUwkm2Gi0n0DDtVAG0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbmEtNqv1PeFqqi5Baw6FzKnGb/UUau177QvMKcuGfrZ8Ygz0g2MF8dMCBx04rdEN
	 EQudYT2ncS27IFhRONC1zeTCKxE0ztcgYVJFqUa+ZTo2rjwVseUZxKM95zrZ/2nsHP
	 +c5FROil2c1o1XnNW2kV475Cd8jzByBQVoyhSSk+Z7BoVP4043rD+T0MhTKb9fYAke
	 1xzD2yLfcX/AXV5mVHhLUeKW13cnw9Msm3Nc6uXyVqmAF4G2GsEkDiAEeZ2sLzsZc/
	 xd88kRV6t0C17UCIbjys9xIUE8q+xoPSNrfb7QcQaLfkBOOtl2OGm3yS3sdkFHQ6iG
	 A7gtIuWf/o96A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 1/3] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Tue, 20 May 2025 02:22:34 +0200
Message-Id: <20250520002236.185365-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250520002236.185365-1-pablo@netfilter.org>
References: <20250520002236.185365-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 8965d42bcf54d42cbc72fe34a9d0ec3f8527debd upstream.

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
index cb13e604dc34..25dd157728a3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1018,7 +1018,7 @@ static inline bool nft_chain_is_bound(struct nft_chain *chain)
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 04fda8c14e04..1e84c8564450 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1911,9 +1911,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->rules_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -1925,7 +1925,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2367,7 +2367,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -7999,7 +7999,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -8840,7 +8840,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -9574,7 +9574,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -9646,10 +9646,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
-		ctx.chain = chain;
 		nft_chain_del(chain);
 		nft_use_dec(&table->use);
-		nf_tables_chain_destroy(&ctx);
+		nf_tables_chain_destroy(chain);
 	}
 	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index d154fe67ca8a..a889cf1d863e 100644
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

