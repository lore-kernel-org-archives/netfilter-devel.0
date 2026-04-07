Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBD03B9607;
	Tue,  7 Apr 2026 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571382; cv=none; b=Xjxt05nf+uPtOuyAvf8qnjwD7HgR/Z+cwKHijr2Ojddv0ED8MszdNjYlYwWAzWHLkfTeNcF81hEiH6FbzDvshFL+nWKEEBCfECEC7F3V5tWRYk2z8cKzPZMN+a9sY5DTrKZf6nHGxa6yXJqO6z7ecunPUabdiEUOIg/voY+oyYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571382; c=relaxed/simple;
	bh=zzhHtBDG2+dgm8Uy5LJABLi8U4eTR8DZUjUh2PbktCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlebJZxPaJE5Ljgx/HyQbljF07iwrsreeOgFxvlsAmr1cqpvfnirAQHNgBC3fn/2m7ebUPOACJoMVjilpe+tmp6gJoHA+nCs4ORkoPSg/lmT7VOiDyYufAgmx/HpPkz7akHs3V/Zttl5t+IqAnoUSYDNNcug+FE7/X50B6KSIQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CD7876066A; Tue, 07 Apr 2026 16:16:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 08/13] netfilter: nft_set_pipapo: increment data in one step
Date: Tue,  7 Apr 2026 16:15:35 +0200
Message-ID: <20260407141540.11549-9-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit e807b13cb3e3 ("nft_set_pipapo: Generalise group size for buckets")
there is no longer a need to increment the data pointer in two steps.
Switch to a single invocation of NFT_PIPAPO_GROUPS_PADDED_SIZE() helper,
like the avx2 implementation.

[ Stefano: Improve commit message ]

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 4 +---
 net/netfilter/nft_set_pipapo.h | 3 ---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7fd24e0cc428..50d4a4f04309 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -452,8 +452,6 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 			pipapo_and_field_buckets_4bit(f, res_map, data);
 		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
 
-		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
-
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
 		 * pointer if any.
@@ -498,7 +496,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
 		map_index = !map_index;
 		swap(res_map, fill_map);
 
-		data += NFT_PIPAPO_GROUPS_PADDING(f);
+		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
 	__local_unlock_nested_bh(&scratch->bh_lock);
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 9aee9a9eaeb7..b82abb03576e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -42,9 +42,6 @@
 /* Fields are padded to 32 bits in input registers */
 #define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
 	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(f)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
-					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
 
 /* Number of buckets given by 2 ^ n, with n bucket bits */
 #define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
-- 
2.52.0

