Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682DA3A1DC;
	Thu, 18 Apr 2024 01:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713402598; cv=none; b=CbKwKiiJZaMw6RXhXNZFlnzQPi1Dr7QX78MRn86wblVk02TWDxZARQ7LEomxgqkzaVQpqLBZdpcQuHrht3dFb2x4E16NvcUWDJ/04dtoYM8WDxBpA+s1oOe0xBBT1kGIoTXChIiSb20ZXip9V+etbJvcUc0w8eJWEImxQSN8Wx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713402598; c=relaxed/simple;
	bh=+nkDRMlf7TRDAQR14/4dtHb7e4ein7g9gkbpk5P2eVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kiTZKqulY/MKEqcwyBwfYwUImgEzTLgFwx3AfwnH+W/kMP5oL9wOX0MPoOs5DnoX7BeIc/l/GK/FnBOF+nev1bV/yrOvR88fYJ1yRpegejKZumCAHB1oZbEwRP18GfW9tXjq4vsZhU7TbKdgk7FLvjdxigA72t9U4VcvvKgz2rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 1/3] netfilter: nf_tables: missing iterator type in lookup walk
Date: Thu, 18 Apr 2024 03:09:46 +0200
Message-Id: <20240418010948.3332346-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240418010948.3332346-1-pablo@netfilter.org>
References: <20240418010948.3332346-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_lookup.c     | 1 +
 net/netfilter/nft_set_pipapo.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index a0055f510e31..b314ca728a29 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -216,6 +216,7 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index eeaf05ffba95..0f903d18bbea 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2123,7 +2123,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_field *f;
 	unsigned int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)
-- 
2.30.2

