Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830224176F;
	Wed, 21 Feb 2024 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515019; cv=none; b=EP/W3UWr6S6yuGmmhqnEPp4s6quIon5z8KQgnq4b5w6IXktnTAIvU1ccV3eoVrACEerAICJosh2B0h3isq2WSm3y6PJhSsHUUSGaurXm3sKDSiUnjyDRmsSeSN9VFDwBo6aujfeI4MYFpuXd2fQnOpGDpS4FfMKT1yCpGqecrQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515019; c=relaxed/simple;
	bh=g7AhCM3To+xt3ACwNHgUnMvSsnNFjm6wIoZPafUupB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSfFogVCZIkpdRI3naxUElt4nBmDWKhc+8PoWOfytdboV16fKRoytxQm2c/6dFL/RA8CDOaahmfabSYff8f7BFOVNWrDn7a4RPeBjOMZ8HSGQn0VYV2X6w+I4dIhx9qCaRxd1sUWwK2pccJIqJPvpV7ENCL+twbovyodHJ2kg18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcknO-0003si-1G; Wed, 21 Feb 2024 12:29:50 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 04/12] netfilter: nft_osf: simplify init path
Date: Wed, 21 Feb 2024 12:26:06 +0100
Message-ID: <20240221112637.5396-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Remove useless branch to check for errors in nft_parse_register_store().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_osf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 7f61506e5b44..7fec57ff736f 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -63,7 +63,6 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 {
 	struct nft_osf *priv = nft_expr_priv(expr);
 	u32 flags;
-	int err;
 	u8 ttl;
 
 	if (!tb[NFTA_OSF_DREG])
@@ -83,13 +82,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 		priv->flags = flags;
 	}
 
-	err = nft_parse_register_store(ctx, tb[NFTA_OSF_DREG], &priv->dreg,
-				       NULL, NFT_DATA_VALUE,
-				       NFT_OSF_MAXGENRELEN);
-	if (err < 0)
-		return err;
-
-	return 0;
+	return nft_parse_register_store(ctx, tb[NFTA_OSF_DREG], &priv->dreg,
+					NULL, NFT_DATA_VALUE,
+					NFT_OSF_MAXGENRELEN);
 }
 
 static int nft_osf_dump(struct sk_buff *skb,
-- 
2.43.0

