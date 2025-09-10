Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ECD2C235C;
	Wed, 10 Sep 2025 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531001; cv=none; b=jLLRVmu+O1GO0ITQ4VWh56/qs3k033MVIZSQTAM3aAbY85C7qL75F4bZMtftvgPdh+BhJlOV5Y25L4AYVQnI17rGWmA4RK2wM6M5qMGgaLvXFP7aHpcZalZyI/rmh9nX3b3oZ+P7Xw8gxENbk2WTUfi4vuUM8npsclQdQr4KaDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531001; c=relaxed/simple;
	bh=jIkd2xnZncXzTE2NJjK8JvBbdeSImjESn1pwHRZpV5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz/TAyJLB8zn7rGAmlQ9eoCrgEThTpeJU/H0B6hjPXrYtHbSZezA8DrzSKAqEKdCJ2GN0CpNv6KrqBevtWzHr6U84G7Zux+yBSSXmmc7OVxCPXPsd/AVOjIjXefmmP0JT/anX4S9+UyH36NKAtkZ9xxgGnQ1K+2+iJiwh+Wcm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 144886062D; Wed, 10 Sep 2025 21:03:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/7] netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation
Date: Wed, 10 Sep 2025 21:03:02 +0200
Message-ID: <20250910190308.13356-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250910190308.13356-1-fw@strlen.de>
References: <20250910190308.13356-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running new 'set_flush_add_atomic_bitmap' test case for nftables.git
with CONFIG_PROVE_RCU_LIST=y yields:

net/netfilter/nft_set_bitmap.c:231 RCU-list traversed in non-reader section!!
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/4008:
 #0: ffff888147f79cd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x2f/0xd0

 lockdep_rcu_suspicious+0x116/0x160
 nft_bitmap_walk+0x22d/0x240
 nf_tables_delsetelem+0x1010/0x1a00
 ..

This is a false positive, the list cannot be altered while the
transaction mutex is held, so pass the relevant argument to the iterator.

Fixes tag intentionally wrong; no point in picking this up if earlier
false-positive-fixups were not applied.

Fixes: 28b7a6b84c0a ("netfilter: nf_tables: avoid false-positive lockdep splats in set walker")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index c24c922f895d..8d3f040a904a 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -226,7 +226,8 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
 
-	list_for_each_entry_rcu(be, &priv->list, head) {
+	list_for_each_entry_rcu(be, &priv->list, head,
+				lockdep_is_held(&nft_pernet(ctx->net)->commit_mutex)) {
 		if (iter->count < iter->skip)
 			goto cont;
 
-- 
2.49.1

