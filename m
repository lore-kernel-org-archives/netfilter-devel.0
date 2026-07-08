Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B543FBEC4;
	Wed,  8 Jul 2026 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519423; cv=none; b=WVlrSrPU5TH4rcZ4p0hJndRWAf0q5B4ySvDbC6/4HhmM1Kx3JNUpjpyJbgi+M/BHCs4skmHn5qOAf+RWcHX8cVuiRWMfPuL6+GDZNAXVaqhW5Jl1Ke9aYcbKyC+/ml3Z1FbPYDcacZwOZrqKeRiRmr832WvGOvjnBCT3cbKecEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519423; c=relaxed/simple;
	bh=tGBLdw5Xy1zshtM3lf24fX4xCfN1o24SQRbto1utn1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE/qp6eEqpLR8Kj8nTKc/THnPoK7DtFvoShqFPY9DEgv5l4f5BHFcM5rX8p06GhrrauCfCslkMcTbmzLGiERGW1JdkFtlzFqyKOCDod0rOvaPrKE23B5GO17FZk722qePjOtOZlmjV4k77io6kfHpwyPMRwsL3m6WdIzfnMU04k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 938A76059E; Wed, 08 Jul 2026 16:03:40 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 05/17] netfilter: nft_lookup: fix catchall element handling with inverted lookups
Date: Wed,  8 Jul 2026 16:02:57 +0200
Message-ID: <20260708140309.19633-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tamaki Yanagawa <ty@000ty.net>

nft_lookup_eval() decides whether a lookup matched (`found`) from the
direct set lookup and priv->invert before falling back to the
catchall element used by interval sets (e.g. nft_set_rbtree) for the
open-ended default range. Since `found` is never recomputed after
`ext` is replaced by the catchall lookup, inverted lookups
(NFT_LOOKUP_F_INV, "!= @set") can wrongly match or wrongly skip the
catchall element, producing the wrong verdict. Fold the catchall
lookup into `ext` before computing `found`, matching the order
already used by nft_objref_map_eval().

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_lookup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index ba512e94b402..19887439847d 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -103,13 +103,13 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	bool found;
 
 	ext = nft_set_do_lookup(net, set, &regs->data[priv->sreg]);
+	if (!ext)
+		ext = nft_set_catchall_lookup(net, set);
+
 	found = !!ext ^ priv->invert;
 	if (!found) {
-		ext = nft_set_catchall_lookup(net, set);
-		if (!ext) {
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		regs->verdict.code = NFT_BREAK;
+		return;
 	}
 
 	if (ext) {
-- 
2.54.0

