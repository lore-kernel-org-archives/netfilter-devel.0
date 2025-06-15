Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8731FA15E
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981629; cv=none; b=dYiYDFNQ8c8GV+bFBpPr7zc9/M7dYZzLhlR7eBX6QnbY73bzUdh+WTc8RT1Uokwzkhqw0h3Mai2IKIrPrPTa8Kkkc3zcCIUwR3anK0Kt6MZTc+tzDGhFpzZ1urZbyq5u64lbvufgQjgWd6/XThCWrjgUVD6V5o8BBkfdEi4dnoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981629; c=relaxed/simple;
	bh=bWzqzFQAUN0hRjVKcavTSnmBXkIqTbhNU5lxdetsXI0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MpM4aKfaUEVhPb5RiGLUuFvpg0wpjHHubpJorcPR2h/ZHT3OGllyNRrZ8RUeEWvz+4MbJPfFkBfLcQ58thjBHadK0u9bbsVOA7vavWG05EoSjZgoyB6V0pwTDOgRLYcgw8d/AdWtqk1IYXCoYp2f5/0RYI4EVLS8RuBs4yjNhog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UDFpIDUi; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UDFpIDUi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UDFpIDUi";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UDFpIDUi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E2A31602C1; Sun, 15 Jun 2025 12:00:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981624;
	bh=z6JNrv/goGVBnLxRGtUI7ld0T2y783LiJsQ/kFH3YZI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UDFpIDUiPUCkApUw0pIT6hIBmxumyULPxSB68TPNVT86IWWaIOfikT5nv0sDj4SqN
	 +EU8HQDWCRkjYn+0fkMzUX8rMjWGdZvKAGjst9zS/WGf4kBcatme2/sGl0hUacZWr7
	 Bt2ZrFAbAH3aUpz6Pnbj9dgdaySO5qmy2czJ/qwoYQ2VTmpSWmbimSY4epdlVb8eAa
	 QJsuB3tgka2SI3/tuhDU7nyOXsCMjEWTSBoZ/3/0/SrN6FM0uZ1eIcC5+KJvqPw3bd
	 YZfPEfYqCXsLkkWInPle5bXHdtI2oXXcvkOpWHp3kily2ItD+WYBn8QFM8gZ9m7awv
	 ui/o5jwuuC/Hg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 812A7602BC
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981624;
	bh=z6JNrv/goGVBnLxRGtUI7ld0T2y783LiJsQ/kFH3YZI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UDFpIDUiPUCkApUw0pIT6hIBmxumyULPxSB68TPNVT86IWWaIOfikT5nv0sDj4SqN
	 +EU8HQDWCRkjYn+0fkMzUX8rMjWGdZvKAGjst9zS/WGf4kBcatme2/sGl0hUacZWr7
	 Bt2ZrFAbAH3aUpz6Pnbj9dgdaySO5qmy2czJ/qwoYQ2VTmpSWmbimSY4epdlVb8eAa
	 QJsuB3tgka2SI3/tuhDU7nyOXsCMjEWTSBoZ/3/0/SrN6FM0uZ1eIcC5+KJvqPw3bd
	 YZfPEfYqCXsLkkWInPle5bXHdtI2oXXcvkOpWHp3kily2ItD+WYBn8QFM8gZ9m7awv
	 ui/o5jwuuC/Hg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/5] cache: assert name is non-nul when looking up
Date: Sun, 15 Jun 2025 12:00:16 +0200
Message-Id: <20250615100019.2988872-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250615100019.2988872-1-pablo@netfilter.org>
References: <20250615100019.2988872-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

{table,chain,set,obj,flowtable}_cache_find() should not be called when
handles are used

Fixes: 5ec5c706d993 ("cache: add hashtable cache for table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 3ac819cf68fb..d16052c608d5 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -551,8 +551,7 @@ struct table *table_cache_find(const struct cache *cache,
 	struct table *table;
 	uint32_t hash;
 
-	if (!name)
-		return NULL;
+	assert(name);
 
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(table, &cache->ht[hash], cache.hlist) {
@@ -672,6 +671,8 @@ struct chain *chain_cache_find(const struct table *table, const char *name)
 	struct chain *chain;
 	uint32_t hash;
 
+	assert(name);
+
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(chain, &table->chain_cache.ht[hash], cache.hlist) {
 		if (!strcmp(chain->handle.chain.name, name))
@@ -840,6 +841,8 @@ struct set *set_cache_find(const struct table *table, const char *name)
 	struct set *set;
 	uint32_t hash;
 
+	assert(name);
+
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(set, &table->set_cache.ht[hash], cache.hlist) {
 		if (!strcmp(set->handle.set.name, name))
@@ -954,6 +957,8 @@ struct obj *obj_cache_find(const struct table *table, const char *name,
 	struct obj *obj;
 	uint32_t hash;
 
+	assert(name);
+
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(obj, &table->obj_cache.ht[hash], cache.hlist) {
 		if (!strcmp(obj->handle.obj.name, name) &&
@@ -1058,6 +1063,8 @@ struct flowtable *ft_cache_find(const struct table *table, const char *name)
 	struct flowtable *ft;
 	uint32_t hash;
 
+	assert(name);
+
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(ft, &table->ft_cache.ht[hash], cache.hlist) {
 		if (!strcmp(ft->handle.flowtable.name, name))
-- 
2.30.2

