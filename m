Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3632208E
	for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716848289; cv=none; b=sZTL/dceXZsGm/1an8Z04p8HgYjDscFF9Low5Y1R4Sny23yY4w348BbDdL6ReNvB33dUM/K4KuvAaeCJT09LGcbv5g6R8acaMlZlOOFrHFEj94ngEKxAmyJ0vt61ZDld6ryfWrt2B+y2aAA07tLGGPWh+f20RrG/CBA7wTI91fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716848289; c=relaxed/simple;
	bh=J/YFELsexEdNn3EdhT+r4f91Um8g4SqR0ANUaoR4zRU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+v16CMU4QKIkWp9tlflG4xwiQocJU47Ia9sqjRsyCXzvlkBwFaQ+aKLTUIX7ZTN1tgB3Qs1G1A97Mh1wPAIb+4rLIdFpnrhrjjuqz0OrWL19RgWEEb2+rvae1SD22bDzte8DOb8+5t+BWJlMFLq1tQYeLg82c3O9U3EEHugu3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] cache: recycle existing cache with incremental updates
Date: Tue, 28 May 2024 00:17:57 +0200
Message-Id: <20240527221757.834892-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240527221757.834892-1-pablo@netfilter.org>
References: <20240527221757.834892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cache tracking has improved over time by incrementally adding/deleting
objects when evaluating commands that are going to be sent to the kernel.

nft_cache_is_complete() already checks that the cache contains objects
that are required to handle this batch of commands by comparing cache
flags.

Infer from the current generation ID if no other transaction has
invalidated the existing cache, this allows to skip unnecessary cache
flush then refill situations which slow down incremental updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 7cc84d714b08..2cfc4af7280e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1182,9 +1182,21 @@ static bool nft_cache_needs_refresh(unsigned int flags)
 	return flags & NFT_CACHE_REFRESH;
 }
 
-static bool nft_cache_is_updated(struct nft_cache *cache, uint16_t genid)
+static bool nft_cache_is_updated(struct nft_cache *cache, unsigned int flags,
+				 uint16_t genid)
 {
-	return genid && genid == cache->genid;
+	if (!genid)
+		return false;
+
+	if (genid == cache->genid)
+		return true;
+
+	if (genid == cache->genid + 1) {
+		cache->genid++;
+		return true;
+	}
+
+	return false;
 }
 
 bool nft_cache_needs_update(struct nft_cache *cache)
@@ -1209,7 +1221,7 @@ replay:
 	genid = mnl_genid_get(&ctx);
 	if (!nft_cache_needs_refresh(flags) &&
 	    nft_cache_is_complete(cache, flags) &&
-	    nft_cache_is_updated(cache, genid))
+	    nft_cache_is_updated(cache, flags, genid))
 		return 0;
 
 	if (cache->genid)
-- 
2.30.2

