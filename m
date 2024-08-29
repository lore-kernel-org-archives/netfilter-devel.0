Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D4B1922D0
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931122; cv=none; b=I1SRBtTHfDixRhxHj73luwul/oelOzPGeT2mHlPCcK2yV2v4zk0qAV6Cnp9r/RkM3Zi5bV1EQJakacsuUwSWZh5K07SF0KG5SytQ8ddFl4GvIausEOE5hh1uR9Z/sF4GUTcimUZfm4BJU2c/ys3vhPsXj7WE+ihOwnyVYNhdvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931122; c=relaxed/simple;
	bh=Ux2Ere/pZ8lOIqa3LQtstoXn+PnMNp+cTw5fC8lTz10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hLgdsos0+g4zsAX9BclITA5RITswsocVKi6maEBs+2kXtQ+J1odKU6xe2CLuZLYj6pLB3P6ZwtXtqFbI4sZMXbAxdQm8M6Lo9Yz6RLL553dYfF10zipvbKVgTTZA6W2z1Gxp1zkejn3Fg+rRm2rwVXqWQ+RsB0HYi5zk7m68jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: eric@garver.life
Subject: [PATCH nft 3/5] cache: remove full cache requirement when echo flag is set on
Date: Thu, 29 Aug 2024 13:31:51 +0200
Message-Id: <20240829113153.1553089-3-pablo@netfilter.org>
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

The echo flags does not use the cache infrastructure yet, it relies on
the monitor cache which follows the netlink_echo_callback() path.

Fixes: 01e5c6f0ed03 ("src: add cache level flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index bed98bb71655..fce71eed3452 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -493,8 +493,6 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		case CMD_INSERT:
 		case CMD_CREATE:
 			flags = evaluate_cache_add(cmd, flags);
-			if (nft_output_echo(&nft->output))
-				flags |= NFT_CACHE_FULL;
 			break;
 		case CMD_REPLACE:
 			flags = NFT_CACHE_FULL;
-- 
2.30.2

