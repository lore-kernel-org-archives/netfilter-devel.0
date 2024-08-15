Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B167DA7A
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721847; cv=none; b=j3/t+AhDpHt1qq8nUFRNzwGZ5ZbrbVbaRBZTLriEioi7cTwCthp1omdoPIEC/Vc/4U79Rn8ZEE3lV/I5f512LE6KyBCFWHasshDv6AIDdjvThIsszNPJRrLpPCfo63Conzw7ycwkCEd+5lH9aWEKEWnZ1lJjJAgxeWEtMNNHTa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721847; c=relaxed/simple;
	bh=XK3u6QP8Eo0zYfOvc8Y0kN0H9J17crWwDy7kRml3n5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gP06gtWo2qVlt9V+e6rf/d+ECqUc6GWtHSBsEhr5Z/MWfp3AyfQuIV4eu9W/IK/0H637fztSGpgwYL0ehVGgp3Cx09M9AzXLX2lekg5oMZDWj5idsHMWhFkHmVSqKaGvYDFdQ9yx9gyOTeq4iT5zog8YVTinJnItw/cV97G7CRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 3/5] cache: populate objecs on demand from error path
Date: Thu, 15 Aug 2024 13:37:10 +0200
Message-Id: <20240815113712.1266545-4-pablo@netfilter.org>
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

Objects are only required for error reporting hints if kernel reports
ENOENT. Populate the cache from this error path only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 6 +-----
 src/cmd.c   | 4 ++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 36c6f12d8720..6ad8e2587806 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -31,7 +31,6 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_SET |
-			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_FLOWTABLE;
 		list_for_each_entry(set, &cmd->table->sets, list) {
 			if (set->automerge)
@@ -54,13 +53,11 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 	case CMD_OBJ_ELEMENTS:
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_SET |
-			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_SETELEM_MAYBE;
 		break;
 	case CMD_OBJ_RULE:
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_SET |
-			 NFT_CACHE_OBJECT |
 			 NFT_CACHE_FLOWTABLE;
 
 		if (cmd->handle.index.id ||
@@ -433,8 +430,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		case CMD_DESTROY:
 			flags |= NFT_CACHE_TABLE |
 				 NFT_CACHE_SET |
-				 NFT_CACHE_FLOWTABLE |
-				 NFT_CACHE_OBJECT;
+				 NFT_CACHE_FLOWTABLE;
 
 			flags = evaluate_cache_del(cmd, flags);
 			break;
diff --git a/src/cmd.c b/src/cmd.c
index 381f404266de..507796bdd6a8 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -169,6 +169,10 @@ static int nft_cmd_enoent_obj(struct netlink_ctx *ctx, const struct cmd *cmd,
 	if (!cmd->handle.obj.name)
 		return 0;
 
+	if (nft_cache_update(ctx->nft, NFT_CACHE_TABLE | NFT_CACHE_OBJECT,
+			     ctx->msgs, NULL) < 0)
+		return 0;
+
 	obj = obj_lookup_fuzzy(cmd->handle.obj.name, &ctx->nft->cache, &table);
 	/* check table first. */
 	if (!table)
-- 
2.30.2

