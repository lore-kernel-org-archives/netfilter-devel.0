Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDDB194141;
	Wed, 26 Jun 2024 23:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719445140; cv=none; b=gnjPyIFZtdoSue4/lExq7oSno+154OdGVZgiuQxZ2ffAO88Gq/OUQ1EiyTL62hSWWzdgYbnksYml1AvcgpacHYgLJ2/i360B8fKJ2EzLJ5RrbWUbCKik2Cv8b17dz+KdB7vi639ySlHrneUBz5R0yAK1OcUMsvUIxi6dvpGf7fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719445140; c=relaxed/simple;
	bh=Ai2WoGSkZmZxVZLmj1Z/CgnlYz0b2ZYj+heCCrJG43o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pNjWBTUrewsbPzKbwnEw18DroAa8MuoUgP2yPZv0zQ8U1oJYADFv1CZOEkDJBaNw+ToLk9Iki4bj7FAyLAhABkGslrEypjChq7TSGt4Pf8MOPpqLXZ79BgIg44J9M84aDIw7f2iEw+pZwPL+2U3Wyj+kas/wgDy+wu8ZjDmWrE4=
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
	fw@strlen.de,
	torvalds@linuxfoundation.org
Subject: [PATCH net 2/2] netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers
Date: Thu, 27 Jun 2024 01:38:45 +0200
Message-Id: <20240626233845.151197-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240626233845.151197-1-pablo@netfilter.org>
References: <20240626233845.151197-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

register store validation for NFT_DATA_VALUE is conditional, however,
the datatype is always either NFT_DATA_VALUE or NFT_DATA_VERDICT. This
only requires a new helper function to infer the register type from the
set datatype so this conditional check can be removed. Otherwise,
pointer to chain object can be leaked through the registers.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_lookup.c        | 3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2796153b03da..188d41da1a40 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -619,6 +619,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
+static inline enum nft_data_types nft_set_datatype(const struct nft_set *set)
+{
+	return set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE;
+}
+
 static inline bool nft_set_gc_is_pending(const struct nft_set *s)
 {
 	return refcount_read(&s->refs) != 1;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be3b4c90d2ed..e8dcf41d360d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5740,8 +5740,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
-			  set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
-			  set->dlen) < 0)
+			  nft_set_datatype(set), set->dlen) < 0)
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
@@ -11073,6 +11072,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 
 		return 0;
 	default:
+		if (type != NFT_DATA_VALUE)
+			return -EINVAL;
+
 		if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
 			return -EINVAL;
 		if (len == 0)
@@ -11081,8 +11083,6 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 		    sizeof_field(struct nft_regs, data))
 			return -ERANGE;
 
-		if (data != NULL && type != NFT_DATA_VALUE)
-			return -EINVAL;
 		return 0;
 	}
 }
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b314ca728a29..f3080fa1b226 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -132,7 +132,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 
 		err = nft_parse_register_store(ctx, tb[NFTA_LOOKUP_DREG],
-					       &priv->dreg, NULL, set->dtype,
+					       &priv->dreg, NULL,
+					       nft_set_datatype(set),
 					       set->dlen);
 		if (err < 0)
 			return err;
-- 
2.30.2

