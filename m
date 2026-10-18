Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FA73090C4;
	Sun, 18 Oct 2026 00:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285021; cv=none; b=Ls2lW0GxVVitG9vq9HdBtbpK+uDTz55ivNRXZOBjXJYL44WHO5ME5RBaE5VQdE+0oD5OPJ+SgltYofsU9RgeZGuYE0hZ99aZutlBghQL3tc45GfBHk+aOClt3M61BAKy/4C5s9+WqPRnS+w3jAHK/dLx8PCQUIhLyNB87bu09wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285021; c=relaxed/simple;
	bh=279YLB9yTa/sM8/WQYbnx8GXNV7Z6RB187SgWM0xauM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC/7zXvA8EOLnnc4KY5WOlxCU6ulKXJA5j+jPvnVFVk10EAv0jSOsDS0kL7O9m7ma6I1Rwu94nCcAm5LBeNkzVo3vc/o1UeMTiSe97hYeD7VPSmR6aLP3T8BBGwCT5K1yu4VDVDoiS7FPQ/Yz8HEWX2Q7aROkodX7odCWlKkY8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PYeTJPSZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PYeTJPSZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285018;
	bh=qXTguC4FrN5AR5rNSXAFsgyeCYh+9+GI0SJacSdF0LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYeTJPSZJq5l+D5IqDGobsxV8xna3pyQKeEKgtBHgoRtc3AVj/IMYwOj2CYQSQxFS
	 9+0eZ6e6rVwk6vs8jA7RjfZPJfQJ8tQU3lD53KElRiESUq9/sZSvKPD07OPJrKq+zR
	 jPinrfX28RIXbmyn9lcALrtPtG7CHitM2Br6A5GuEZ2649DHWwqI6f22lfdo6RGhJz
	 f5HRxm1X0PKyCEWvUeQ7hjGPKnada+LMo/TgCEP9szkdnQvIBMZNqBF7FIDz2AziET
	 Ygz1fYvwvRI5BfzSQZ2+wB98Iuw0oPLekP/1rERB3JHILEsTSkkqzkZVIGOiLeeQUr
	 i90NjJBLaB26w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E604C60078;
	Sun, 18 Oct 2026 02:56:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/15] netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
Date: Sun, 18 Oct 2026 02:56:31 +0200
Message-ID: <20261018005638.1776148-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

The nft_exthdr_tcp_set_init() function is exclusively used for TCP
options. Therefore, parsing the NFTA_EXTHDR_OP attribute from user
space is redundant, as the operation type must always be
NFT_EXTHDR_OP_TCPOPT.

Remove the unnecessary netlink attribute parsing and hardcode priv->op
to NFT_EXTHDR_OP_TCPOPT, which simplifies the code and reduces the
object size.

./scripts/bloat-o-meter exthdr_before.o exthdr_after.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-54 (-54)
Function                                     old     new   delta
nft_exthdr_tcp_set_init                      412     358     -54
Total: Before=6581, After=6527, chg -0.82%

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 8abf8e8145ce..3492426dccf7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -551,7 +551,7 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
+	u32 offset, len, flags = 0;
 	int err;
 
 	if (!tb[NFTA_EXTHDR_SREG] ||
@@ -581,15 +581,11 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OP], U8_MAX, &op);
-	if (err < 0)
-		return err;
-
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
 	priv->flags  = flags;
-	priv->op     = op;
+	priv->op     = NFT_EXTHDR_OP_TCPOPT;
 
 	return nft_parse_register_load(ctx, tb[NFTA_EXTHDR_SREG], &priv->sreg,
 				       priv->len);
-- 
2.47.3

