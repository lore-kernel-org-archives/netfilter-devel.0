From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: nft_compat: use the match->table to validate dependencies
Date: Tue, 11 Nov 2014 14:24:57 +0100
Message-ID: <1415712298-8592-2-git-send-email-pablo@netfilter.org>
References: <1415712298-8592-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39381 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKKNXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:23:13 -0500
In-Reply-To: <1415712298-8592-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of the match->name, which is of course not relevant.

Fixes: f3f5dde ("netfilter: nft_compat: validate chain type in match/target")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 2bd4ec7..3821452 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -346,7 +346,7 @@ nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	union nft_entry e = {};
 	int ret;
 
-	ret = nft_compat_chain_validate_dependency(match->name, ctx->chain);
+	ret = nft_compat_chain_validate_dependency(match->table, ctx->chain);
 	if (ret < 0)
 		goto err;
 
@@ -420,7 +420,7 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		if (!(hook_mask & match->hooks))
 			return -EINVAL;
 
-		ret = nft_compat_chain_validate_dependency(match->name,
+		ret = nft_compat_chain_validate_dependency(match->table,
 							   ctx->chain);
 		if (ret < 0)
 			return ret;
-- 
1.7.10.4

