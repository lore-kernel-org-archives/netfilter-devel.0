From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/14] netfilter: nft_compat: ebtables 'nat' table is normal chain type
Date: Tue,  6 Nov 2018 00:28:31 +0100
Message-ID: <20181105232832.21896-14-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Unlike ip(6)tables, the ebtables nat table has no special properties.
This bug causes 'ebtables -A' to fail when using a target such as
'snat' (ebt_snat target sets ".table = "nat"').  Targets that have
no table restrictions work fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 768292eac2a4..9d0ede474224 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -54,9 +54,11 @@ static bool nft_xt_put(struct nft_xt *xt)
 	return false;
 }
 
-static int nft_compat_chain_validate_dependency(const char *tablename,
-						const struct nft_chain *chain)
+static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
+						const char *tablename)
 {
+	enum nft_chain_types type = NFT_CHAIN_T_DEFAULT;
+	const struct nft_chain *chain = ctx->chain;
 	const struct nft_base_chain *basechain;
 
 	if (!tablename ||
@@ -64,9 +66,12 @@ static int nft_compat_chain_validate_dependency(const char *tablename,
 		return 0;
 
 	basechain = nft_base_chain(chain);
-	if (strcmp(tablename, "nat") == 0 &&
-	    basechain->type->type != NFT_CHAIN_T_NAT)
-		return -EINVAL;
+	if (strcmp(tablename, "nat") == 0) {
+		if (ctx->family != NFPROTO_BRIDGE)
+			type = NFT_CHAIN_T_NAT;
+		if (basechain->type->type != type)
+			return -EINVAL;
+	}
 
 	return 0;
 }
@@ -342,8 +347,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
-		ret = nft_compat_chain_validate_dependency(target->table,
-							   ctx->chain);
+		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
 	}
@@ -590,8 +594,7 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		if (match->hooks && !(hook_mask & match->hooks))
 			return -EINVAL;
 
-		ret = nft_compat_chain_validate_dependency(match->table,
-							   ctx->chain);
+		ret = nft_compat_chain_validate_dependency(ctx, match->table);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.11.0
