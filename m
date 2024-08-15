Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D8617A5A4
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721849; cv=none; b=Kbjo4STP/bdrK8y7iCmdeDnYXWIEHXwovuUziCG+lcOS9DaXNg149DuiVpxyxHIL3BXnHHgF+Lot6Fzgu6CYXkxxv8BjMwB6u9UvwhQR91N0+bovp2Gshw1o9Fs+aPtsL9uXHG7PpAqhUrUpBI2RPq4F9Sao+0BwsSBdYjVI2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721849; c=relaxed/simple;
	bh=rbe+hrkDq8QAY5p3ZvJn3qoUelMZZaYQxIpr6aLLbao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=epKIjiItaSWTAjJd7o8pdVPJ6J2r/sasDWrdqBmgsiAznZibUA9rZ1JpUELnOLUA1baqlxI/rCet9WZZme0/osGAheP8Rof7yuEhQnuVZRkhGg0VrrY2q6WtxMRBGPuBfvyNz/HzhxIgC/bgrtLYXXOAQ1NebRfUe3r6N7lZgDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nhofmeyr@sysmocom.de,
	eric@garver.life,
	phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 5/5] cache: do not fetch set inconditionally on delete
Date: Thu, 15 Aug 2024 13:37:12 +0200
Message-Id: <20240815113712.1266545-6-pablo@netfilter.org>
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

This is only required to remove elements, relax cache requirements for
anything else.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 6 +++---
 src/cmd.c   | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 1fc03f2bbe50..233147649263 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -73,7 +73,8 @@ static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		flags |= NFT_CACHE_SETELEM_MAYBE;
+		flags |= NFT_CACHE_SET |
+			 NFT_CACHE_SETELEM_MAYBE;
 		break;
 	default:
 		break;
@@ -426,8 +427,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			break;
 		case CMD_DELETE:
 		case CMD_DESTROY:
-			flags |= NFT_CACHE_TABLE |
-				 NFT_CACHE_SET;
+			flags |= NFT_CACHE_TABLE;
 
 			flags = evaluate_cache_del(cmd, flags);
 			break;
diff --git a/src/cmd.c b/src/cmd.c
index e64171e7c4df..9a572b5660c7 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -140,6 +140,10 @@ static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 	if (!cmd->handle.set.name)
 		return 0;
 
+	if (nft_cache_update(ctx->nft, NFT_CACHE_TABLE | NFT_CACHE_SET,
+			     ctx->msgs, NULL) < 0)
+		return 0;
+
 	set = set_lookup_fuzzy(cmd->handle.set.name, &ctx->nft->cache, &table);
 	/* check table first. */
 	if (!table)
-- 
2.30.2

