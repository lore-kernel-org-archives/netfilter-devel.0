Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B5E1714C4
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721848; cv=none; b=fRWN/ex/q6MYm0Kc4XeK4w206bzwpr0OEZhVUt9JpvoZoEPCUnOdO7UUrfx8CO56nmpyjtLpOZf8P4GQZlFFuOWlxz045/fvpKlL1UnQsSkATHE8rL4U6gnY5mXT8dO8od81ms/nZd2JkygxuE8XE/m+GoLH4g5JoWRdpFyq2dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721848; c=relaxed/simple;
	bh=YDrObgj+/VLxpomSFs4QCiLuTveQ8yfKRfiBhPeDmmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NktJa8ab2MjgtfOzOPqgqWYHhcMrt8yJ2cfYsZYWG7CiK3DrQG8PhcKmSIXkM7zdLDC0zIsTdlD7UCcq4zTLtXwsOPBjrDmP+f+enQ8ZXWEhB/l7JTr/jdgLrkiXeyt3b2c/s4LDNFOzeuVwf0uw1kzyQ1fMpOo7kcS1LI/vUWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 1/5] cache: rule by index requires full cache
Date: Thu, 15 Aug 2024 13:37:08 +0200
Message-Id: <20240815113712.1266545-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240815113712.1266545-1-pablo@netfilter.org>
References: <20240815113712.1266545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for on-demand cache population with errors, set on
NFT_CACHE_FULL if rule index is used since this requires a full cache
with rules.

This is not a fix, follow up patches relax cache requirements, add
this patch in first place to make sure index does not break.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index e88cbae2ad95..42e60dfa1286 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -68,7 +68,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
-			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;
+			flags |= NFT_CACHE_FULL | NFT_CACHE_UPDATE;
 		break;
 	default:
 		break;
-- 
2.30.2

