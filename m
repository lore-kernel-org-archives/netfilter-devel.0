Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CEA2C86D
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 12:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757421933; cv=none; b=CooIKAarQw4o66h5jQit1uf4UhdSDMq3AdpvzJqtlU/sEExAzl1KhHfm/K244dK+Xn1oxDHozgr4AzQJbuUr0GkIH4LcmOfW67gaKsWPpZ8GregdDF4IN/dpNumAQ862FGBlxlx8ymSSYUoeiUmgT+6hEF3tBG5Wc2LnlN4eRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757421933; c=relaxed/simple;
	bh=i6cahLhx2mZxHjLPUkR8UFtNQpNYUb7GJbD5OK5a9sU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DVdhAsK7SvCx+bwuLYhCV3greRvECaypbNLDGuq+8wnove08Fz4w52obDGzK7+71DW7NTgvgnte6NW0zhOuufH+yvUsr0tZ2iVHiDQmCrhDszUnk+erVCfbn+dbAiJdSMOB5IJv7Zn/WvrAesX0rxFllz6RxBe0FMKj7gFqmibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1BA1960329; Tue,  9 Sep 2025 14:45:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation
Date: Tue,  9 Sep 2025 14:45:21 +0200
Message-ID: <20250909124524.28435-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 6aa649856d3e..9a0085fd8cee 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -228,7 +228,8 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
 
-	list_for_each_entry_rcu(be, &priv->list, head) {
+	list_for_each_entry_rcu(be, &priv->list, head,
+				lockdep_is_held(&nft_pernet(ctx->net)->commit_mutex)) {
 		if (iter->count < iter->skip)
 			goto cont;
 
-- 
2.49.1

