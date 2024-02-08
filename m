Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48C71B45
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707389850; cv=none; b=spJM+nincQkGxXmzX2FNmIrKrRl92gpni1wpaeoK9ROpG4ff3QURM9sq6EM736jmjIuxmXMiDtQjxxjgPp/CvmDxeyzg4RvjfwRUdWQ5ZMH2b+kJ/L6yv+2mpLBu59OCr6kHzbKr2r9wtNuLOgbjgWh/RrRo3J3U+drpQ9L+DkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707389850; c=relaxed/simple;
	bh=Q2gnqLmWVEbyCTn4fLKMNEAZu3otjCSQUU25Iyb/NnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gsHpWR6WDT3Ou6Pt0um8RfJplEKkdNsSRft1rTpzOs52rWa3cwCfnE/GeJ+zcNqbATthJwc7LhoHrSa9QaTGY0QIRX7D0z0Az37MLyoe39xJ/w9RJXqpEccZDVo4OTOtvRG1eGDN5YrRZGLZfOb8j8Eb6qCFjCD3fOK6v+2Bido=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=n54RAdVY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="n54RAdVY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9/OQs+sI8jw1SWqg0wwi0GngrJ1GSHj9QHPF6/b5DF4=; b=n54RAdVYiU4OVXsysKx4c/WjxQ
	UKCcynJr5LjLbpMkpubZqxiWx6CNwZZmZ+C9C2P3GdaJmap7WnibqrmqFX4tqDwyF+OZzD1PsSz4P
	AyP4gg7g169vUOLmADW2dBqT7g2Glwu3rQ4n7q1qyceL72NcOgKRB4dHiwXK4yyoB1ANqnJ0g2WVX
	PuUPzGdkmC1WKPvpSOnsZ/OizvlFIKzriO22cPle1qXrAJ7pNG+slBZhaMWzBAjlb7hP/ne9DyscW
	Ct1qg/+ag+UCJQTZQMiwGI3oruO1cb1Jr9nOsBd5imHJdxBp24e1qRKyr84og7ydLtehONMraLSij
	EK+z6j3Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rY25s-000000000Q7-2aXR;
	Thu, 08 Feb 2024 11:57:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	anton.khazan@gmail.com
Subject: [nft PATCH] cache: Reduce caching when terse listing a table
Date: Thu,  8 Feb 2024 11:57:22 +0100
Message-ID: <20240208105722.12529-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If user specified --terse, set NFT_CACHE_TERSE bit.

Reported-by: anton.khazan@gmail.com
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1735
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 97f50ccaf6ba1..d642c0985736a 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -212,6 +212,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 			filter->list.table = cmd->handle.table.name;
 		}
 		flags |= NFT_CACHE_FULL;
+		if (nft_output_terse(&nft->output))
+			flags |= NFT_CACHE_TERSE;
 		break;
 	case CMD_OBJ_CHAIN:
 		if (filter && cmd->handle.chain.name) {
-- 
2.43.0

