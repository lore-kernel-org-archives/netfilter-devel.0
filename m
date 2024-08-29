Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C391922FC
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931122; cv=none; b=kTmB/+u+QONDP81dggLwQJQLVRxd8CDzGXLSPz6CzvBt2ht/0AetFZ3nHP1SymD1yny+5kNgzdlSKwhTz3Gjt053p1PLIzTySrDZ9MaBu8JB1QNw0C4032sZNJStvevUY3pMiwphsFRtrR94IaPcYfGCYZoWLLC/Lr73SwrUCFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931122; c=relaxed/simple;
	bh=g8hSIChQB4/xJbtJCOJNdFJZxs42oJVlaaaFpeCJUfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NttJa5rwSX66Yt+sLXsc40VF1joLTLXrrT9/Y1q76r10OZ3dD1KZniO/Ek4D16bcopOjB68eXh2YDZH1Deu1tEtkXhvKJHkeyeLJ5DiZsICM5P/DaTEORltQw9fuOxXWJ9LNbsDSsOebBhtVHMcCUuN6rtCzdLeb/zz83Q3pFmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: eric@garver.life
Subject: [PATCH nft 5/5] cache: position does not require full cache
Date: Thu, 29 Aug 2024 13:31:53 +0200
Message-Id: <20240829113153.1553089-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240829113153.1553089-1-pablo@netfilter.org>
References: <20240829113153.1553089-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

position refers to the rule handle, it has similar cache requirements as
replace rule command, relax cache requirements.

Commit e5382c0d08e3 ("src: Support intra-transaction rule references")
uses position.id for index support which requires a full cache, but
only in such case.

Fixes: 01e5c6f0ed03 ("src: add cache level flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index db7dfd96081d..3f1324a2f98b 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -58,8 +58,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_SET;
 
-		if (cmd->handle.index.id ||
-		    cmd->handle.position.id)
+		if (cmd->handle.index.id)
 			flags |= NFT_CACHE_FULL | NFT_CACHE_UPDATE;
 		break;
 	default:
-- 
2.30.2

