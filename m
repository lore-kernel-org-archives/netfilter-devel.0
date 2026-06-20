Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3027B3537F7;
	Sat, 20 Jun 2026 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994476; cv=none; b=e8MXUISociJKuLnZYRsLs6GlyF+Qnrz+w3jpvumVfGAi9+VMV/YYqPgeru7oizYDregUI3ngyhtcWzZSBO8dpjXhTxCAWts/4ANAQm7bpscAnG5Ex+/pZCvbecOWRSoKUGv2aFJkAYXEQcc8XUb1k/81OEUdfCUo/yzAS4ZAXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994476; c=relaxed/simple;
	bh=HB/32bdmHR7Ejjg1kT0jsPFkOkTO9wTCEE06ELCRD4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtv3XBVPASSjuwqu0OD7JEba4HV9VxIgDv69UAHDvpQraOErG9YNekwXWOdSUKbHo0CN41f4D9hYESseAtqAY5uhO43VI30kAvrnbJVC4pUePhKYQ9+SWxA8EXywm98AbvjHj6vNnYp7HqgJLCG8Y6u7dz89kZsbRyJSBSvQtbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hiAehTsQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hiAehTsQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BAD286017F;
	Sun, 21 Jun 2026 00:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994473;
	bh=O4aVlfIoU2Pc1AqTgkRYRepCW47AfnJQSsWwmjFGj20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiAehTsQ6xWEwqQWplJcmBRD6A846GpKjE/s7zIfIvPR+/MrZG/NdbIHCLcZwf1xf
	 1Q54dz4H/L7t7znkcpj2CwHDodQDZBtsI2iJ7RHs+WIs6ydC4o2HyMMVtiY+I5rjI/
	 5WaxUUGqpqn4kNl65ruJe816N+roMaFs0YUNTVbYUUEHXBvdTAi8Sf+hgS3EYCYiDb
	 VJ563Za7pavGLaAvsTjEsxoW3/mQd28JI0GFT06N/yS+DGUl/DNYgKnUxZ2HgewQoo
	 GyulUVgocGY8Ujj/EYpQ7oL5gfhLq82V+/TqmaQRO489mwCNL2LGorAqnKT1QXvwiB
	 TB43eHbJg9F9g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/14] netfilter: nft_payload: reject offsets exceeding 65535 bytes
Date: Sun, 21 Jun 2026 00:27:33 +0200
Message-ID: <20260620222738.112506-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
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

