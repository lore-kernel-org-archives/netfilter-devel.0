Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F61D530;
	Thu, 13 Jun 2024 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240541; cv=none; b=P5rNWdushD4v3rk0yTJXKJdz2woBSUrdXEhTxBjja4O7LiPdQLv0C6j2sm3drg7n0Pjf7M5qddBaj0w0KzwCbuExOClfnwEFNdrlveUATJulEYYfH+Rmae1bKoMX8Vnv6NwT8nhHz9TcQVmx+c2/XqPQhnH/zxKYbe4kMOXx/j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240541; c=relaxed/simple;
	bh=YLuureGmQfkuPrjUQXbNLUoriKjcE7frI8cKUoHUuuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kpidgajc2fZpdsDzjSExN4I0+nkUXPXJ6gy9uT6rkUSwwPDtdzv17YljiLNCNixe95VmuH6Bq4fbpCfRAcH0UYWDHXjYY3LP1qYKXEANmchBGWTLrwQNtQq40GtPdwVfHqrqpSKXpJ/0OGRPT9jfAI3pXZnzLYlGF9+LVQLYR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 01/40] netfilter: nf_tables: pass context to nft_set_destroy()
Date: Thu, 13 Jun 2024 03:01:30 +0200
Message-Id: <20240613010209.104423-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 0c2a85edd143162b3a698f31e94bf8cdc041da87 upstream.

The patch that adds support for stateful expressions in set definitions
require this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index db453d19f2a0..36bbbd2c0762 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3753,7 +3753,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-static void nft_set_destroy(struct nft_set *set)
+static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (WARN_ON(set->use > 0))
 		return;
@@ -3926,7 +3926,7 @@ EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
-		nft_set_destroy(set);
+		nft_set_destroy(ctx, set);
 }
 EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
 
@@ -6503,7 +6503,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
@@ -6857,7 +6857,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -7604,7 +7604,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
 		list_del(&set->list);
 		nft_use_dec(&table->use);
-		nft_set_destroy(set);
+		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
 		list_del(&obj->list);
-- 
2.30.2

