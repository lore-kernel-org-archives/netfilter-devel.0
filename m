Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F62144CF;
	Mon, 19 May 2025 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697724; cv=none; b=aLuaX4MVBWcO1SZUBg13HAFqpq4KhohuL4oDSMu+7KSoRoMch/+MagobTTngkWVtn8Wv1fBBtsK6AFw3aNoJYNSOm09NzM59U1gPfjXCRXOZWEmKlObCrV7P9wr0CULFTNKwuJSB0w9fWXCQvIsnAtDdUlUz0y72k0lQVTFBDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697724; c=relaxed/simple;
	bh=yNryvLFNe+gGbDaa5rY4blif6ZO8MVyDPNIWpJwfJkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNEXUraXbW1TBiQlI0pEqhDONjPsLbn98wzsPkOQNe62DvuEGUctUP6ZBi7eAFj7cgr2EKVPb4Q4JHDwwthvZ66KYLlheOjHeJMItW2NWrQliZZxBvYzvp0GVtBTfa4vaB6cA+8N/VyIfhBMNWMaRv0PdtsgPsRLBdzKWRFPz0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B/u3WJo4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b/xeKZ5f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B/u3WJo4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b/xeKZ5f"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0C8BC602A4; Tue, 20 May 2025 01:35:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697722;
	bh=Ev2ALxjrfSsq6/1wteDv9q4yCW0FUSRYz2foC80qK3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/u3WJo4blov/IuMoHKM6ti7iHV23mDrFfyFwRW+MLuMYCjRndY71EfgQgGz979OE
	 0QaB5BzpaliC+24jXiKHdYFtOY8yWpSeH+TYQd7wxrW1aLwRq8hoT9TELDhIUcAPKC
	 WSJUvCIpUbNCzcWI1AdlhAnW+cjii4wuLnqTCpvOPEJWhC6nWwnhuaFcll3aNKW4Ah
	 4++mYKnrJIvwUE1A/tC3HgkI9QXxtw/6gbsBaakCd1DA+QnriZ6RkWvrAbzJq8cqZz
	 2tbL2Q13n410Jf+h96fTcgXg+BDvQOFv9xxzFJH1WsB7w3sGpexEfha2WdCu4/xpzF
	 /O43jGSKsRyBA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2A250602A3;
	Tue, 20 May 2025 01:35:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697721;
	bh=Ev2ALxjrfSsq6/1wteDv9q4yCW0FUSRYz2foC80qK3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/xeKZ5f8AU6sp7B2gjJqqnz+x7uifPBx3aHlZD6EwrirIq41aJIn1BJ/UvKeQOOl
	 CzTL9iqMKTVVoH8Gf11qfGn4lTCmQ3x/3SUvaKvJMZozXUgzqBwe86NyoSonK4Uy2o
	 Y1vs1KnY9zdigGvHEuYf63uF+6+X52qorZ3M7pawtYUFuJhai2pPPVNMxhBagpgsFu
	 JSiijoBKwqkftlveXtABOA54VAU1lQ0ESiCWEB9wIBqOir7/xXfaRXke2SFRQH6NPX
	 pNAbvO8C5XamXMkFjIfjEuf+EkD0jNSE249FPozhYaroj9Y6v/+VM7pHcCX6pmEur/
	 mCbYvHwSRTT3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15 1/3] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Tue, 20 May 2025 01:35:13 +0200
Message-Id: <20250519233515.25539-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250519233515.25539-1-pablo@netfilter.org>
References: <20250519233515.25539-1-pablo@netfilter.org>
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
index 9ee225cff611..605d4c0a63e9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1088,7 +1088,7 @@ static inline bool nft_chain_is_bound(struct nft_chain *chain)
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 07fdd5f18f3c..e82c5dfdef2e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1981,9 +1981,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->rules_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -1995,7 +1995,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2445,7 +2445,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_use:
 	nf_tables_unregister_hook(net, table, chain);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -8809,7 +8809,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -9721,7 +9721,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -10443,7 +10443,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -10519,10 +10519,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
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

