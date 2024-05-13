Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30651509BA
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605809; cv=none; b=kt7CW5dIPDUMgH3t4j0lVVdQH3fLR6MkznzB43vBWAQOztTtA+zwOJbIuYHqw/JwlsEKTI3ufaak1GKjBFqqHb5VuCeDkYFNK4ItF5zvvA2HkS/szrVnehfkb3zdXim/5hbGGPfAR0V9FTlI+7RE6ehavMIkIjV3XkUJIJmFBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605809; c=relaxed/simple;
	bh=8mm9bv8BRKstSG31HLIfxs9zOI0CLOA3eUDlOkJoeUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZiPk/A3Nk9Gw4EwPGQBIVGSTdmmnk1hoICNGbhFLpwbO1NJR7R3/1p2qwkgJ4Ial3BJPCgryINbIK03JPub4SAJ7JQkXVSvwpKVlp436hijBVeiW8wdMLYTo2BnFWyYkjDvcI67okXJ3wUAmrQ3PssR/ksfk2UOat0cvmnx/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VRO-0001Qd-8e; Mon, 13 May 2024 15:10:06 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 10/11] netfilter: nf_tables: pass nft_table to destroy function
Date: Mon, 13 May 2024 15:00:50 +0200
Message-ID: <20240513130057.11014-11-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240513130057.11014-1-fw@strlen.de>
References: <20240513130057.11014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 70d65a09787b..769c5ced7f2e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1655,15 +1655,15 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 	return nft_flush_table(&ctx);
 }
 
-static void nf_tables_table_destroy(struct nft_ctx *ctx)
+static void nf_tables_table_destroy(struct nft_table *table)
 {
-	if (WARN_ON(ctx->table->use > 0))
+	if (WARN_ON(table->use > 0))
 		return;
 
-	rhltable_destroy(&ctx->table->chains_ht);
-	kfree(ctx->table->name);
-	kfree(ctx->table->udata);
-	kfree(ctx->table);
+	rhltable_destroy(&table->chains_ht);
+	kfree(table->name);
+	kfree(table->udata);
+	kfree(table);
 }
 
 void nft_register_chain_type(const struct nft_chain_type *ctype)
@@ -9520,7 +9520,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DESTROYTABLE:
-		nf_tables_table_destroy(&trans->ctx);
+		nf_tables_table_destroy(trans->ctx.table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		free_percpu(nft_trans_chain_stats(trans));
@@ -10517,7 +10517,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWTABLE:
-		nf_tables_table_destroy(&trans->ctx);
+		nf_tables_table_destroy(trans->ctx.table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (nft_trans_chain_update(trans))
@@ -11489,7 +11489,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_use_dec(&table->use);
 		nf_tables_chain_destroy(chain);
 	}
-	nf_tables_table_destroy(&ctx);
+	nf_tables_table_destroy(table);
 }
 
 static void __nft_release_tables(struct net *net)
-- 
2.43.2

