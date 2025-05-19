Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09753EAD0;
	Mon, 19 May 2025 23:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697691; cv=none; b=PXwpc1dSIksiEHHGBZoVNTKcs7svNdcZ7M89Oopj3SuRw6Th8AelrpkAz/Nu3ATFRBKps7Oy2L72eP1Me0dV8859V2agGKI7NkETRMtYg+AzoBDkzQdGfJTNmt11FYVrAGqGJsLCuMnHJQ0h+5f/NKj6lzODrwnyl/M+zVKpNqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697691; c=relaxed/simple;
	bh=2UoqyuENMSGGTzfnBceZgzWmNProqd5E4FTe7So03gw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RWLFsfcbawg+wAZcwqYL2W7SiNfaOLW4i8bwNDtAqyqbBqlkZqPw8WD0KtVNCepU74VVCBUsR6iCJxuqBq1x9z137HwLbGwyRBDzb/2ub+cY/J63N4+eUcQofl9+pJGpPgxPknhRAIAOvT0lEd/zfQQ+xvefWGtJV/5J1la7+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AJTwok33; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N+CEXP91; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AJTwok33";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N+CEXP91"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 45F536029E; Tue, 20 May 2025 01:34:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697686;
	bh=3zIkReVz6ZCBaZu/mlJ/kU6t8UC5KO18aiMI69CYXCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJTwok33iq3+kAXckw3xgw3MVkhd7UN4Zms7s9Uta5Yd9DChGTA4y7RrgEI0BmA1m
	 KcUcXUJZEchJqubZX8h5SX29X+mJSAUojm3I9dJTOZgR/NOkC+Qui/FIkVOsn5ExuH
	 mItbc9OZSfhNSmRPQDc9TVUaoiKqWxX+Ukc8cmUUKCzZhNBilCn+Srvbg3LVzZcscU
	 G3zO24qMMlzPZP6gWUER8D1rGIcw/66qzAduiqb7nmWqso1GB4X1h0mT6i2ALK61MI
	 zXgBZ1Zt34KqgeKNQe/e5Ye10O2qj4XgSnMarnf1wdN24ymzaddOZYmfpA2kZ0exVv
	 wfhydslYaLp6Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 15A3360296;
	Tue, 20 May 2025 01:34:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697685;
	bh=3zIkReVz6ZCBaZu/mlJ/kU6t8UC5KO18aiMI69CYXCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+CEXP91LtLE3Qm0/b655H2wwbTNjUvHTAnIUXSSRu7aybMx71Mgm47QFQZLHDNkr
	 nux0Kn+qyo7Loq7XCyUlcd99kaWrf7wBiXXhbtIDAgvdCgWtSrCPFApJSSUZFm+5r/
	 gn82527I4+j3zXwTWHuYfNN4qjco1Z4Fj7wHdVjjAhFfoXLtxxrdbmmxuSLOHk1SQR
	 7NjunZ25LJXQ0BqTuJ6PBwCNaoi+v9YLgl+qU9UUisu1SxPWykSluzjfMwVKquXlBS
	 YgSuPaiUcMBnaa2ea0THpk1PL6X8oNx6bspNH7hKHLJf6FIhIT2MJAamNdX/bcE2th
	 SHmMlUSjgqmmw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 1/3] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Tue, 20 May 2025 01:34:36 +0200
Message-Id: <20250519233438.22640-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250519233438.22640-1-pablo@netfilter.org>
References: <20250519233438.22640-1-pablo@netfilter.org>
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
Stable-dep-of: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 17 ++++++++---------
 net/netfilter/nft_immediate.c     |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d11398aa642e..41abb5982348 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1121,7 +1121,7 @@ static inline bool nft_chain_is_bound(struct nft_chain *chain)
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 656c4fb76773..dc1e11c0b168 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2034,9 +2034,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -2048,7 +2048,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2515,7 +2515,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_trans:
 	nft_use_dec_restore(&table->use);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -8994,7 +8994,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -9955,7 +9955,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -10677,7 +10677,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -10753,10 +10753,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
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
index 55fcf0280c5c..731511d58b7c 100644
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

