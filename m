Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B18455898
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 08:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662505; cv=none; b=ag50h4HorfHEkAT6pK77etTjTzk/gq6ej4oxWkaAdPi2/clLedDDEwf/dBdAkQe24t9aEG0tgqR0ahzkp/TGCz4+u9HiocCaYXLWlo2l84dXgyUYTLdrX/2g7PScdCbMq0NU5DCtLarNOgRowh0qmscrtKtnejhtgFck0xnYAQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662505; c=relaxed/simple;
	bh=0YVWssDg0V8OyTglX6O2Gfz88qhR8vXrkMLSKjWMLVE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ND4lzaKQveY96FZ/FaIAUWuNzczxheZ+FU0wjOwg11B4pffByNXoN+NRdLj5iIFki4WnMjKwc/O1WtOl9lkN/USoF6Pb8yH+piLQ7EPgYLXZhPPVoxJ7WrPam5pAZ86lwTdat7Pv6IHHmPmZdKBbNXs51LS28OW1B4Ti1mSlcdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/7] cache: accumulate flags in batch
Date: Mon, 26 Aug 2024 10:54:50 +0200
Message-Id: <20240826085455.163392-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240826085455.163392-1-pablo@netfilter.org>
References: <20240826085455.163392-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent updates are relaxing cache requirements:

  babc6ee8773c ("cache: populate chains on demand from error path")

Flags describe cache requirements for a given batch, accumulate flags
that are inferred from commands in this batch.

Fixes: 7df42800cf89 ("src: single cache_update() call to build cache before evaluation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 src/cache.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 5442da35a129..082fd30b462d 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -409,13 +409,14 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		       struct list_head *msgs, struct nft_cache_filter *filter,
 		       unsigned int *pflags)
 {
-	unsigned int flags = NFT_CACHE_EMPTY;
+	unsigned int flags, batch_flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
 
 	list_for_each_entry(cmd, cmds, list) {
 		if (nft_handle_validate(cmd, msgs) < 0)
 			return -1;
 
+		flags = NFT_CACHE_EMPTY;
 		reset_filter(filter);
 
 		switch (cmd->op) {
@@ -439,13 +440,13 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags = evaluate_cache_get(cmd, flags);
 			break;
 		case CMD_RESET:
-			flags |= evaluate_cache_reset(cmd, flags, filter);
+			flags = evaluate_cache_reset(cmd, flags, filter);
 			break;
 		case CMD_LIST:
-			flags |= evaluate_cache_list(nft, cmd, flags, filter);
+			flags = evaluate_cache_list(nft, cmd, flags, filter);
 			break;
 		case CMD_MONITOR:
-			flags |= NFT_CACHE_FULL;
+			flags = NFT_CACHE_FULL;
 			break;
 		case CMD_FLUSH:
 			flags = evaluate_cache_flush(cmd, flags, filter);
@@ -460,8 +461,9 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		default:
 			break;
 		}
+		batch_flags |= flags;
 	}
-	*pflags = flags;
+	*pflags = batch_flags;
 
 	return 0;
 }
-- 
2.30.2

