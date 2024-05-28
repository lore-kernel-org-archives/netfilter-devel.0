Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D67F9D6
	for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2024 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910111; cv=none; b=HvhUUbVdyrq4e//fAGBoipbg9rpf4TTqBSSK9/aEWBtY5yzeB/ym2CkaPlqHa9bnxoIeFFyTHHK7Ib5qAYjZgD4CkXtxPg3vMd/ZyjUy/iSkVltlpYTbj25ygeXSiuKMDl3YLF6bgW01pnP7JyV8myYyYmGF6RsPKzW9GGIWQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910111; c=relaxed/simple;
	bh=sgxg1Hs6h83ebPPnQmKO2HKZZU/LNzhG3KKykQ8BnVw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KYKBmhhizRN8UMvHsshYnQY8c47zUF3cE7HiEESqmnhTOrRVki9ILMsWhsebMB/2OY0W2avVeOjvrHDiXuPyz7Qy6d2tpVnfde3z9p8ybcuTwcWmoGbOGE7Xkrf21CM+KbPiekyhdQbhGGywupUC3oc5cDRGy8DMVBQaC6Buw2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de
Subject: [PATCH nft 1/2,v2] cache: check for NFT_CACHE_REFRESH in current requested cache too
Date: Tue, 28 May 2024 17:28:16 +0200
Message-Id: <20240528152817.856211-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFT_CACHE_REFRESH is set on inconditionally by ruleset list commands to
deal with stateful information in this ruleset. This flag results in
dropping the existing cache and fully fetching all objects from the
kernel.

Set on this flag for reset commands too, this is missing.

List/reset commands allow for filtering by specific family and object,
therefore, NFT_CACHE_REFRESH also signals that the cache is partially
populated.

Check if this flag is requested by the current list/reset command, as
well as cache->flags which represents the cache after the _previous_
list of commands.

A follow up patch allows to recycle the existing cache if the flags
report that the same objects are already available in the cache,
NFT_CACHE_REFRESH is useful to report that cache cannot be recycled.

Fixes: 407c54f71255 ("src: cache gets out of sync in interactive mode")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: cache filtering, eg. list table inet test, could result in partial
    cache that cannot be recycle, use NFT_CACHE_REFRESH to signal that
    cache cannot be reused.

 src/cache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index c000e32c497f..e88cbae2ad95 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -297,6 +297,7 @@ static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
 		flags |= NFT_CACHE_TABLE;
 		break;
 	}
+	flags |= NFT_CACHE_REFRESH;
 
 	return flags;
 }
@@ -1177,9 +1178,10 @@ static bool nft_cache_is_complete(struct nft_cache *cache, unsigned int flags)
 	return (cache->flags & flags) == flags;
 }
 
-static bool nft_cache_needs_refresh(struct nft_cache *cache)
+static bool nft_cache_needs_refresh(struct nft_cache *cache, unsigned int flags)
 {
-	return cache->flags & NFT_CACHE_REFRESH;
+	return (cache->flags & NFT_CACHE_REFRESH) ||
+	       (flags & NFT_CACHE_REFRESH);
 }
 
 static bool nft_cache_is_updated(struct nft_cache *cache, uint16_t genid)
@@ -1207,7 +1209,7 @@ int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-	if (!nft_cache_needs_refresh(cache) &&
+	if (!nft_cache_needs_refresh(cache, flags) &&
 	    nft_cache_is_complete(cache, flags) &&
 	    nft_cache_is_updated(cache, genid))
 		return 0;
-- 
2.30.2

