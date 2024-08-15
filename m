Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34251AC8B4
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721847; cv=none; b=e3maaeQo7Xg9DkqsQ3pB7q9x0SIJqV4v6KcAAAn0SqD+a6ye45qb9pmRh31uUIYYHEh/P66AaLs284iaPNNdT3WKPOZZv2AjQ3Wit3Njc9Ez7U8bdUrSxcOstNLVOn1OXJsgKbgpwv3GgLv5PsaT0LWYCJuMxV2Ea2cnlnOWsMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721847; c=relaxed/simple;
	bh=H3qeJxro9rRL5LsjXc3CyanbgmmdQRx6VD4xQHq7NNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kWyadFXVU5W0nWZxtJ7JW2lMKN0CpxZ+oFcumR8I8e8N6HTkfPe7uN/qL4n6teuNoIGRQBZXp1IV/eIl0JQwxOVQ04usZe1v8yFSZZrR5TQBBxi/T3NideuHLq5PhPXiT1Vlo4AcMeSh42NB7XJEArlXn/QH8zK4Rxwv9oBkQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 4/5] cache: populate flowtable on demand from error path
Date: Thu, 15 Aug 2024 13:37:11 +0200
Message-Id: <20240815113712.1266545-5-pablo@netfilter.org>
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

Flowtables are only required for error reporting hints if kernel reports
ENOENT. Populate the cache from this error path only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 9 +++------
 src/cmd.c   | 4 ++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 6ad8e2587806..1fc03f2bbe50 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -30,8 +30,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 			break;
 
 		flags |= NFT_CACHE_TABLE |
-			 NFT_CACHE_SET |
-			 NFT_CACHE_FLOWTABLE;
+			 NFT_CACHE_SET;
 		list_for_each_entry(set, &cmd->table->sets, list) {
 			if (set->automerge)
 				 flags |= NFT_CACHE_SETELEM_MAYBE;
@@ -57,8 +56,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 		break;
 	case CMD_OBJ_RULE:
 		flags |= NFT_CACHE_TABLE |
-			 NFT_CACHE_SET |
-			 NFT_CACHE_FLOWTABLE;
+			 NFT_CACHE_SET;
 
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
@@ -429,8 +427,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		case CMD_DELETE:
 		case CMD_DESTROY:
 			flags |= NFT_CACHE_TABLE |
-				 NFT_CACHE_SET |
-				 NFT_CACHE_FLOWTABLE;
+				 NFT_CACHE_SET;
 
 			flags = evaluate_cache_del(cmd, flags);
 			break;
diff --git a/src/cmd.c b/src/cmd.c
index 507796bdd6a8..e64171e7c4df 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -201,6 +201,10 @@ static int nft_cmd_enoent_flowtable(struct netlink_ctx *ctx,
 	if (!cmd->handle.flowtable.name)
 		return 0;
 
+	if (nft_cache_update(ctx->nft, NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE,
+			     ctx->msgs, NULL) < 0)
+		return 0;
+
 	ft = flowtable_lookup_fuzzy(cmd->handle.flowtable.name,
 				    &ctx->nft->cache, &table);
 	/* check table first. */
-- 
2.30.2

