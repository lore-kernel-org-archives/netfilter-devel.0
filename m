Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FCA1CB31E;
	Fri, 28 Jun 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590729; cv=none; b=RlXPBz8PyqQK2BN3Kko/GMItejqXEqzu7dju08h1ZX+Du9vYCuV84q1AnYTTK8dJ5Vwr/NSk5lAVRa/cJaSOAc2aFP83wCwnlzp2DHlqHXhuZLAi2W6wDIVpcQCPcSLsjj4CStfNKl1SbDp2HaNsC0FJJ9B1ViIQsJwuQPnraCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590729; c=relaxed/simple;
	bh=+9h5KlLqjJd5g6ibxCp7ZnxzSn1h/vDAGYUDfd3wOGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6Q7/Lhv2b1r1IRRi09HydIferbYHC9VQOEDVknEP99c9betl9I76zuX3uozZ/uK5ry+3PEVOquk6hkdkDl2/6KLee4epyir21CyJ4cbina/T/tHb6ue/1GnEHsHk/q6AIgL+XitnxnboF71dgZJuvMRxP0VWx5apyENgzp8Oc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 10/17] netfilter: nf_tables: pass nft_table to destroy function
Date: Fri, 28 Jun 2024 18:04:58 +0200
Message-Id: <20240628160505.161283-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

No functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bd311b37fc61..6958f922f95a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1656,15 +1656,15 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -9521,7 +9521,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
 	case NFT_MSG_DESTROYTABLE:
-		nf_tables_table_destroy(&trans->ctx);
+		nf_tables_table_destroy(trans->ctx.table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		free_percpu(nft_trans_chain_stats(trans));
@@ -10518,7 +10518,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_NEWTABLE:
-		nf_tables_table_destroy(&trans->ctx);
+		nf_tables_table_destroy(trans->ctx.table);
 		break;
 	case NFT_MSG_NEWCHAIN:
 		if (nft_trans_chain_update(trans))
@@ -11490,7 +11490,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_use_dec(&table->use);
 		nf_tables_chain_destroy(chain);
 	}
-	nf_tables_table_destroy(&ctx);
+	nf_tables_table_destroy(table);
 }
 
 static void __nft_release_tables(struct net *net)
-- 
2.30.2

