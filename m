Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633E91E886
	for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2024 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910110; cv=none; b=YRMC5vAHL3GP81EW/Souy2/ft6Ea5fBOCuUbGmV9d6z+W/zAa0TSHjbHY+Plqf7L0bs71jF6JcOeYwgorwFlW7u06feETpuuqqcM3xmFKJZGuKHvbUeUhYr/0F5Xz4cJtSZlcGE23XVUo5DmXov/J60YFyLkqD28nmQj6as5Q/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910110; c=relaxed/simple;
	bh=b7To6oNrHVnQ2zHF1EvPVdR0fKCLg0ZW0o8lLzb1Erw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RNQ5lmR4cWEKWHxTXGWp5vHNsKIca9T39DWTOAXQiedRTYVC0/pOSYmtzhM//99z6CkTYL0aeE9OOoNEbhr0ZyfUWUGNDLYABDmXHjC3loBWiGI1jbP2xVoab5THayyWrr/MXnVIB7b6N+650OwFDvL/xSve32Vt47BVgPiTJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de
Subject: [PATCH nft 2/2,v2] cache: recycle existing cache with incremental updates
Date: Tue, 28 May 2024 17:28:17 +0200
Message-Id: <20240528152817.856211-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240528152817.856211-1-pablo@netfilter.org>
References: <20240528152817.856211-1-pablo@netfilter.org>
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
v2: no changes

    nft_slew.c provided by Neels (on Cc) show better numbers now after this
    series.

 src/cache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index e88cbae2ad95..4b797ec79ae5 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1184,9 +1184,21 @@ static bool nft_cache_needs_refresh(struct nft_cache *cache, unsigned int flags)
 	       (flags & NFT_CACHE_REFRESH);
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
@@ -1211,7 +1223,7 @@ replay:
 	genid = mnl_genid_get(&ctx);
 	if (!nft_cache_needs_refresh(cache, flags) &&
 	    nft_cache_is_complete(cache, flags) &&
-	    nft_cache_is_updated(cache, genid))
+	    nft_cache_is_updated(cache, flags, genid))
 		return 0;
 
 	if (cache->genid)
-- 
2.30.2

