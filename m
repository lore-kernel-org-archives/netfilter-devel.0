Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC39A17E8EF
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716848290; cv=none; b=YgV5Dy+k4NlLjn3Xx304mQFt0b+iZYSUv6TVz9JtcGcPueqW3POAXokPtgpK02VNSveOpfwRnLtrWHKMFBn6wfyOLtOJoSEU02SYvZlsgMFajyoCSd0iWdJX0S4gsUKiktUK4cZLVVoJkYnMKFOGWxEQZUwVPNY/AvlLhTFM2xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716848290; c=relaxed/simple;
	bh=XssGgBESfxHx5pvksbwkunzCQexQxKG5kyPVths0a5U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=lH1m2uEp7rA+MRkAYnsQvDkn06IXAdfM12qUxKOoV3my7ie6s2oXRxBUQ9l4WRssoQRoj2BnrVzcLdqNDNXaGBzAgs6MHurrM49aC0J0BBd1GjVg8f93XU91CVi9NFiNq1F0jf5Bao0yBHKUtWkv0OiqwNvJBYYyVOcMb5wze/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] cache: check for NFT_CACHE_REFRESH in current requested cache
Date: Tue, 28 May 2024 00:17:56 +0200
Message-Id: <20240527221757.834892-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFT_CACHE_REFRESH is set on inconditionally by ruleset listing commands
to deal with stateful information in this ruleset. This flag results in
dropping the existing cache and fully fetching all objects from the
kernel.

Check if this flag is requested by the current list of commands, instead
of checking at cache->flags which represents the cache after the
_previous_ list of commands.

Fixes: 407c54f71255 ("src: cache gets out of sync in interactive mode")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index c000e32c497f..7cc84d714b08 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1177,9 +1177,9 @@ static bool nft_cache_is_complete(struct nft_cache *cache, unsigned int flags)
 	return (cache->flags & flags) == flags;
 }
 
-static bool nft_cache_needs_refresh(struct nft_cache *cache)
+static bool nft_cache_needs_refresh(unsigned int flags)
 {
-	return cache->flags & NFT_CACHE_REFRESH;
+	return flags & NFT_CACHE_REFRESH;
 }
 
 static bool nft_cache_is_updated(struct nft_cache *cache, uint16_t genid)
@@ -1207,7 +1207,7 @@ int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-	if (!nft_cache_needs_refresh(cache) &&
+	if (!nft_cache_needs_refresh(flags) &&
 	    nft_cache_is_complete(cache, flags) &&
 	    nft_cache_is_updated(cache, genid))
 		return 0;
-- 
2.30.2

