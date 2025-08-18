Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B052701C3;
	Mon, 18 Aug 2025 10:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755512440; cv=none; b=RcXRRR+yBEOOxaZcAdqMhrpr/obsFLCk45S3du74pKp6ze78YX7LNbS2R0wIbLZ2SKoTi7d1L8+x4I4sKKjKCecvOXx03F7Ua7gNwHVvkKNiT5gL1LdSsMAqDnZhJWoUEo+mVPj6KWJrtKIVyoY3xAv4MmfIO+1eUMPQV5S6/9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755512440; c=relaxed/simple;
	bh=gi1XBiPa+Y9s7F0E7yYhrqUCfP7ER/mlAOwnS69M9ng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=te2G9oBt92Whq5Kzzh9E2CLyW4VrVfwg8uQ/gOqGDwZ+hzL1YlYr7raGlHsE0IZhqpT60oUOhVJpdhs+9QdTqbm++mtGBKVjpTahgkgKZMkw5FK6CXSgMxtlo5fRFjdy3cfV2gti6rC1Kj5DGC0kl9unCnALe21a+bh+BRva55k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c57Fj32R9z9sSY;
	Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v4Dqw6h7vKWf; Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c57Fj2DGkz9sSC;
	Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 363608B764;
	Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id nZLLT_AYuvrt; Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 0F32C8B763;
	Mon, 18 Aug 2025 11:48:41 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] netfilter: nft_payload: Use csum_replace4() instead of opencoding
Date: Mon, 18 Aug 2025 11:48:30 +0200
Message-ID: <e35d9dca6ce3a67b5a0fb067e02b35f3f53ce561.1755510324.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755510516; l=892; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=gi1XBiPa+Y9s7F0E7yYhrqUCfP7ER/mlAOwnS69M9ng=; b=P1rymAuoU44cHcNRzxv+AAep0JyXqqQEoidtcFyR4aEiH+vmLVBt88Caboz7pYShYjwOIi/bI KQCkRxUQD+2CEd+6njYAuwJQ/QbJYAo/3RyMcVMREZYYauv99G/INzb
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit

Open coded calculation can be avoided and replaced by the
equivalent csum_replace4() in nft_csum_replace().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Add cast to __be32 to match csum_replace4() expected param types
---
 net/netfilter/nft_payload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7dfc5343dae4..059b28ffad0e 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -684,7 +684,7 @@ static const struct nft_expr_ops nft_payload_inner_ops = {
 
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
 {
-	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
+	csum_replace4(sum, (__force __be32)fsum, (__force __be32)tsum);
 	if (*sum == 0)
 		*sum = CSUM_MANGLED_0;
 }
-- 
2.49.0

