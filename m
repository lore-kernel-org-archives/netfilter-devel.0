Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B3222EEF
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723649902; cv=none; b=apwoHjUpfi7Rxu7THZ/Q1KiP6MpHL286ja+QmEIImti8ivqcXy33qNtyZQfzjCixEillbQE8eSDpsxiZpJphSrFD+28eXM2XenESGNKh5B2ZKp2Xi8i2qEgxk27pu+0g0j5vaNZiOzS/D1flhNwpAfwuHZzD+WutOHEX/eNjexE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723649902; c=relaxed/simple;
	bh=Tt8bENeTCsMDNbPudWImSVgabsSc7n42NAwwN8UqbjY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jWNUcXySJdceSmNnRhh8aPa/AbPCUIUdJJZ7tr7Hcaxeyro0IjKXOAkfc/noEnXNcQMhwKVQ9uP18EGL72T8A5b/Yl4kX/dguf8npqrU+hwlZMwopnxi3R7ffbgjn4NOnOm6+YNzV99Ui1nX6tmqzljgeDlNYVcGz7A/WDla1ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de
Subject: [PATCH nft] cache: populate chains on demand from error path
Date: Wed, 14 Aug 2024 17:38:12 +0200
Message-Id: <20240814153812.834332-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates on verdict maps that require many non-base chains are slowed
down due to fetching existing non-base chains into the cache.

Chains are only required for error reporting hints if kernel reports
ENOENT. Populate the cache from this error path only.

Similar approach already exists from rule ENOENT error path since:

  3f1d3912c3a6 ("cache: filter out tables that are not requested")

however, NFT_CACHE_CHAIN was toggled inconditionally for rule
commands, rendering this on-demand cache population useless.

before this patch, running Neels' nft_slew benchmark (peak values):

  created idx 4992 in 52587950 ns   (128 in 7122 ms)
  ...
  deleted idx  128 in 43542500 ns   (127 in 6187 ms)

after this patch:

  created idx 4992 in 11361299 ns   (128 in 1612 ms)
  ...
  deleted idx 1664 in  5239633 ns   (128 in 733 ms)

cache is still populated when index is used.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
A new attempt to address this issue, now that

"cache: recycle existing cache with incremental updates"

has been reverted.

 include/cache.h | 1 -
 src/cache.c     | 5 +----
 src/cmd.c       | 5 +++++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 8ca4a9a79c03..44e8430ce1fd 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -31,7 +31,6 @@ enum cache_level_flags {
 				  NFT_CACHE_SET_BIT |
 				  NFT_CACHE_SETELEM_BIT,
 	NFT_CACHE_RULE		= NFT_CACHE_TABLE_BIT |
-				  NFT_CACHE_CHAIN_BIT |
 				  NFT_CACHE_RULE_BIT,
 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
 	NFT_CACHE_TERSE		= (1 << 27),
diff --git a/src/cache.c b/src/cache.c
index e88cbae2ad95..06b12024003e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -54,21 +54,19 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 		break;
 	case CMD_OBJ_ELEMENTS:
 		flags |= NFT_CACHE_TABLE |
-			 NFT_CACHE_CHAIN |
 			 NFT_CACHE_SET |
 			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_SETELEM_MAYBE;
 		break;
 	case CMD_OBJ_RULE:
 		flags |= NFT_CACHE_TABLE |
-			 NFT_CACHE_CHAIN |
 			 NFT_CACHE_SET |
 			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_FLOWTABLE;
 
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
-			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;
+			flags |= NFT_CACHE_CHAIN | NFT_CACHE_RULE | NFT_CACHE_UPDATE;
 		break;
 	default:
 		break;
@@ -435,7 +433,6 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		case CMD_DELETE:
 		case CMD_DESTROY:
 			flags |= NFT_CACHE_TABLE |
-				 NFT_CACHE_CHAIN |
 				 NFT_CACHE_SET |
 				 NFT_CACHE_FLOWTABLE |
 				 NFT_CACHE_OBJECT;
diff --git a/src/cmd.c b/src/cmd.c
index 37d93abc2cd4..37a8d0e62aaa 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -69,12 +69,17 @@ static int table_fuzzy_check(struct netlink_ctx *ctx, const struct cmd *cmd,
 static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
 				const struct location *loc)
 {
+	unsigned int flags = NFT_CACHE_TABLE |
+			     NFT_CACHE_CHAIN;
 	const struct table *table = NULL;
 	struct chain *chain;
 
 	if (!cmd->handle.chain.name)
 		return 0;
 
+	if (nft_cache_update(ctx->nft, flags, ctx->msgs, NULL) < 0)
+		return 0;
+
 	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
 	/* check table first. */
 	if (!table)
-- 
2.30.2

