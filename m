Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E342F5311;
	Wed, 29 Oct 2025 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746198; cv=none; b=ZRwJx0Ct3zbkysSOt70pno3hfj+mC86CdoiQwaGE8d1kxYCQRuGfgCINIfRShrHbvpNFZrLfzbkoP6DE3cBZ4vo75AcEQvSz/Xki+Hjsnd4BLNVaPdWW9P5wASWrDznPdgA1KcvsqDqiBMHTDLiUSOiUx6Mkg5LHgcMmtdZWFu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746198; c=relaxed/simple;
	bh=04RwQCuZU/qBf5rxPpywszf7amIuZA9F+R3is+N2rKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0LPsDz0iqASuLqP5bIAXDthRtsISNyPwHTJDYooX1aKPy+esw92hKN7Yq6TWFa74EQInDMGD3ZC3btPUyIauqSAp5DzcdVuuOgznOmzvsFmdcCHZfsH92tpQ0yyq5KgWU9JA5ncVoT8xmMobTt2DMJAgqTpFobe9p0y9Eb15CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 37EB1601A6; Wed, 29 Oct 2025 14:56:35 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/3] netfilter: nft_connlimit: fix possible data race on connection count
Date: Wed, 29 Oct 2025 14:56:16 +0100
Message-ID: <20251029135617.18274-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029135617.18274-1-fw@strlen.de>
References: <20251029135617.18274-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

nft_connlimit_eval() reads priv->list->count to check if the connection
limit has been exceeded. This value is being read without a lock and can
be modified by a different process. Use READ_ONCE() for correctness.

Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_connlimit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 92b984fa8175..fc35a11cdca2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -48,7 +48,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	count = priv->list->count;
+	count = READ_ONCE(priv->list->count);
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
-- 
2.51.0

