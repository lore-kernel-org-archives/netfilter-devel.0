Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12142146013
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2024 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713368932; cv=none; b=DizPzu4mqjGhPzBmD14vRHwVZdnfyyK/mw0TTKAypbB8yLNfpGGTvvx6HeMfSHKUuLaSfjuj75jNFgiEED5Jt55RHkgh1SEmuPiiarPeynWfREZRA7h05QnQXRRnrSRQ028sz4om+szSQ75fFhWYaj9A6Kydduustvh+hQaxo40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713368932; c=relaxed/simple;
	bh=+nkDRMlf7TRDAQR14/4dtHb7e4ein7g9gkbpk5P2eVA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=juyrV68q72CARtPnMU2UUD2Xr59vXBLF1HFGuN2Ru3skXMCG/9mDOszij7+62x4TDD5Le7Y8+YG4MsnwQ9XrCkEXOmvwbGFfisUDj3ljIYkF257Pgr4is6bdQ78paEIKT9A/F4NkKVBT1sHqXKOOLlh9zwRAM03EJFhmS018ayQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: nf_tables: missing iterator type in lookup walk
Date: Wed, 17 Apr 2024 17:48:36 +0200
Message-Id: <20240417154838.2047344-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_lookup.c     | 1 +
 net/netfilter/nft_set_pipapo.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index a0055f510e31..b314ca728a29 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -216,6 +216,7 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index eeaf05ffba95..0f903d18bbea 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2123,7 +2123,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_field *f;
 	unsigned int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)
-- 
2.30.2

