Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F91BA2D;
	Thu, 13 Jun 2024 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240557; cv=none; b=gpp9IKFME2e6WNqwFhhj9d/9L5tQ7i2OKN8C7Isg7RzlV9IobFETDaNUGB7R02nlCIhGoWK4N79g3OyQeysdA/Ug605ZioQ7AmSX4gP9szUty/nfcoy8nVgi38iQC1PGWlwZ0gzXHoWtTJVAXdhNyxDAtOPc+hBb8rgA/WDL1JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240557; c=relaxed/simple;
	bh=ULS+boLMoW5iPv/10bMmR8Jl8Vti8fpmHLYBLrmQoyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iNa/kRLyKtYvGDiqvzpmWCU6gLTGfCXHQkmmANIAO4JeoodKvtU6+cXR1+QFFWTn+usspBwQeA1LPdy8ZpvOc/NhxVJw9F/lJx7eVlFedt8S8xCzAQAiA+0swLRumE9qUrxyGJ6t5x1EkV5fgjyFSQUOjLQSk5Uzd3GfD/0KzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 27/40] netfilter: nft_dynset: fix timeouts later than 23 days
Date: Thu, 13 Jun 2024 03:01:56 +0200
Message-Id: <20240613010209.104423-28-pablo@netfilter.org>
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

commit 917d80d376ffbaa9725fde9e3c0282f63643f278 upstream.

Use nf_msecs_to_jiffies64 and nf_jiffies64_to_msecs as provided by
8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23
days"), otherwise ruleset listing breaks.

Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 3 +++
 net/netfilter/nf_tables_api.c     | 4 ++--
 net/netfilter/nft_dynset.c        | 8 +++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b97a8f9e9e8..9ce7837520f3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1423,4 +1423,7 @@ struct nftables_pernet {
 	unsigned int		gc_seq;
 };
 
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
+__be64 nf_jiffies64_to_msecs(u64 input);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bac994847327..b23d7c3455de 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3294,7 +3294,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
+int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 {
 	u64 ms = be64_to_cpu(nla_get_be64(nla));
 	u64 max = (u64)(~((u64)0));
@@ -3308,7 +3308,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 	return 0;
 }
 
-static __be64 nf_jiffies64_to_msecs(u64 input)
+__be64 nf_jiffies64_to_msecs(u64 input)
 {
 	u64 ms = jiffies64_to_nsecs(input);
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index a4c6aba7da7e..7f79e877671b 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -169,8 +169,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						tb[NFTA_DYNSET_TIMEOUT])));
+
+		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
+		if (err)
+			return err;
 	}
 
 	err = nft_parse_register_load(tb[NFTA_DYNSET_SREG_KEY], &priv->sreg_key,
@@ -284,7 +286,7 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_string(skb, NFTA_DYNSET_SET_NAME, priv->set->name))
 		goto nla_put_failure;
 	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
+			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
-- 
2.30.2

