Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544D282F35
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 04:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781758723; cv=none; b=qFRNHDkgxAUgbnq0Go//k/K43bepATw9JtiUNI98slEwpqEUEi0CZM5PTWcOgnXB4Sku2bfH2aTfDH8isM9faoNXpX++bDquE7PrivBeRBfHof7VCgYY5rw2/tDnVkiWUjFy1XYaftfxTFq2vHDDlaZA3CdhQWS1VMUZOrMXphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781758723; c=relaxed/simple;
	bh=ziifld510nPk6CuzHM0nlI+lkKmdm+sVg1nahiODimU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JBmDwyfHcRdNnOgmOanKojKLY2oi3gUYDu3xtN91w0VNdrr8haAdCPLKtXAIfpLIQCnVhOOmUyRdeL1sMkBaoB/fyCofCuriuMN+NAYlX/7LqOcjup8iX/z9LP514YB/RsAd4roXZs0+Ua+m0+LqOx1TqAIDQxPeqa/Qv1Y+iLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5C0D460541; Thu, 18 Jun 2026 06:58:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_payload: reject offsets exceeding 65535 bytes
Date: Thu, 18 Jun 2026 06:58:24 +0200
Message-ID: <20260618045826.2449-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large offsets were rejected based on netlink policy, but blamed commit
removed the policy without updating nft_payload_inner_init() to use the
truncation-check helper.

Silent truncation is not a problem, but not wanted either, so add a
check.

Fixes: 077dc4a27579 ("netfilter: nft_payload: extend offset to 65535 bytes")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 484a5490832e..4438d05f8018 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -224,11 +224,17 @@ static int nft_payload_init(const struct nft_ctx *ctx,
 			    const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
+	u32 offset;
+	int err;
 
 	priv->base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
+
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
 					priv->len);
@@ -621,7 +627,8 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[])
 {
 	struct nft_payload *priv = nft_expr_priv(expr);
-	u32 base;
+	u32 base, offset;
+	int err;
 
 	if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
 	    !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
@@ -639,8 +646,11 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 	}
 
 	priv->base   = base;
-	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
 
 	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
 					&priv->dreg, NULL, NFT_DATA_VALUE,
-- 
2.53.0

