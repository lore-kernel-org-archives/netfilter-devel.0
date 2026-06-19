Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403EF38332E;
	Fri, 19 Jun 2026 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870113; cv=none; b=r+xUIRQNR93qMWeFowi0kZBSsISw4KnHiXGUk9MsQh7T88mBh4Xn6dQNGyzb6WB7Gg9opR/r0L3QIbPgAeFvjKJEu9MAn5s1zP3UX+SvTqh22tGkT+G9rcFLrOSIskGSeog1rnvR5dXypj9caorL7ftFikaKUU3NXGKs3b7FyJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870113; c=relaxed/simple;
	bh=HB/32bdmHR7Ejjg1kT0jsPFkOkTO9wTCEE06ELCRD4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9H6Dz8RGzDLMrJxkrXyYn3gDBV1z8fdlLou1tAtNNyLo0zLkU7pEn2K9tEHmRav2OMXFzph4UEU2kyRfagbTy83eOSdAxHbN9G4Rf5tpK0mKN1FlCv9zO4055SXl7eBKBYtpo7Il5cXeygNPp4tB8jmTV5G5FhEIad0yWh/O08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MAq6P61z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MAq6P61z"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 825A860196;
	Fri, 19 Jun 2026 13:55:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870110;
	bh=O4aVlfIoU2Pc1AqTgkRYRepCW47AfnJQSsWwmjFGj20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAq6P61z/TobdXpGYQmqjhMnlvHkJg2tAAzkHqWqzqbNavCbdEoKnn17lF6I2kKKd
	 ssacaNLQ/Nb2AOZG5lQ0eTp9lnvxCJv4H9pFtCnudmU6zJmfpt7Hf5RfBLbh/GBojy
	 FcUei5itTxtZoKW+bvkckgLvO3tu2gQ7rXq/KSLwIqzqsHibLJYqQyqn3LP8PykjDa
	 ly10WozkGl+gZWrW3YugJsYmviP429hk9biWN8LQrJjhX5wZ7qNS2Obgj+HfjO4IKu
	 7MHYbNPIkwGJiSgF2N4h6xwLSFkpr0yUTr9N8GTbtVFQ1mmmI182MPRl/jlfkwq4qW
	 FhwDu86dcT+5g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/16] netfilter: nft_payload: reject offsets exceeding 65535 bytes
Date: Fri, 19 Jun 2026 13:54:45 +0200
Message-ID: <20260619115452.93949-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Large offsets were rejected based on netlink policy, but blamed commit
removed the policy without updating nft_payload_inner_init() to use the
truncation-check helper.

Silent truncation is not a problem, but not wanted either, so add a
check.

Fixes: 077dc4a27579 ("netfilter: nft_payload: extend offset to 65535 bytes")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index ef2a80dfc68f..345eff140d56 100644
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
2.47.3

