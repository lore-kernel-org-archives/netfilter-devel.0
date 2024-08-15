Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BA51714C5
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721848; cv=none; b=PSL11dobi4Q6HaVUbXctxV28GaGCuYnGYMpjFMPP3NlJe/uA9lXBM1b+G0qN1L1+fUM5H29SvxgVavifGPhw2rbQul5kKyMSCuxsKN8w6mo3RGOtw416bQeb8Nlt/YOjVdX6KHHepSwsXqi3S/miroNPe2WJVLFtgIdD8iZIwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721848; c=relaxed/simple;
	bh=PpJ3aT3C+CkXXvd2dZNh+h54IyOAiqSp+v5zk8ek7Zw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sHrdaQ63Jmo9x3j45VJZnFgJzYIfautjWpBQf5bSxugFkugSWJ2PyEIGU9qSRtSsZ+mz66/pvUYgGzhKVF7PLFDE+2bIjwhi6w7tVY0xX/lbXJ7fdr9cov2BD5Zs5aWcSiYYBFqfu1mX7CIq82v0GoVPf3Hj124g2vW1eR26iV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 2/5] cache: populate chains on demand from error path
Date: Thu, 15 Aug 2024 13:37:09 +0200
Message-Id: <20240815113712.1266545-3-pablo@netfilter.org>
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

Updates on verdict maps that require many non-base chains are slowed
down due to fetching existing non-base chains into the cache.

Chains are only required for error reporting hints if kernel reports
ENOENT. Populate the cache from this error path only.

Similar approach already exists from rule ENOENT error path since:

  deb7c5927fad ("cmd: add misspelling suggestions for rule commands")

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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fetch cache for EOPNOTSUPP errors too.
    update nft_slew results.

 include/cache.h |  1 -
 src/cache.c     |  4 ----
 src/cmd.c       | 11 +++++++++++
 3 files changed, 11 insertions(+), 5 deletions(-)

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
index 42e60dfa1286..36c6f12d8720 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -30,7 +30,6 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 			break;
 
 		flags |= NFT_CACHE_TABLE |
-			 NFT_CACHE_CHAIN |
 			 NFT_CACHE_SET |
 			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_FLOWTABLE;
@@ -54,14 +53,12 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
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
@@ -435,7 +432,6 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		case CMD_DELETE:
 		case CMD_DESTROY:
 			flags |= NFT_CACHE_TABLE |
-				 NFT_CACHE_CHAIN |
 				 NFT_CACHE_SET |
 				 NFT_CACHE_FLOWTABLE |
 				 NFT_CACHE_OBJECT;
diff --git a/src/cmd.c b/src/cmd.c
index 37d93abc2cd4..381f404266de 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -75,6 +75,10 @@ static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
 	if (!cmd->handle.chain.name)
 		return 0;
 
+	if (nft_cache_update(ctx->nft, NFT_CACHE_TABLE | NFT_CACHE_CHAIN,
+			     ctx->msgs, NULL) < 0)
+		return 0;
+
 	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
 	/* check table first. */
 	if (!table)
@@ -271,6 +275,13 @@ static int nft_cmd_chain_error(struct netlink_ctx *ctx, struct cmd *cmd,
 			return netlink_io_error(ctx, &chain->priority.loc,
 						"Chains of type \"nat\" must have a priority value above -200");
 
+		if (nft_cache_update(ctx->nft, NFT_CACHE_TABLE | NFT_CACHE_CHAIN,
+				     ctx->msgs, NULL) < 0) {
+			return netlink_io_error(ctx, &chain->loc,
+						"Chain of type \"%s\" is not supported, perhaps kernel support is missing?",
+						chain->type.str);
+		}
+
 		table = table_cache_find(&ctx->nft->cache.table_cache,
 					 cmd->handle.table.name, cmd->handle.family);
 		if (table) {
-- 
2.30.2

