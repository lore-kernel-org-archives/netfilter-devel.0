Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792840489;
	b=cgOY9kymD3treggoCBR5kZndheIDlKaoJoMeKLL4e0kl+Yv3lgL+sLx7k65A9FEbLp/W
	 2sE3OXibcBvsmBn2SFeb50bngY4Xx0qon2UtrXl/cSdRy0RWqoEFbAMVypCY7/QVElwYE
	 +ivibpEf/77AMVkjsfHMzDCT0OY+6uJzL36LbCFtcxv71sUFUzq7xmSaY5SkTCrCIMqrQ
	 mGn+fiHOpAwRfzZ++M2q9wHenZxBwla+cPYlD9KISudKmVxV4kqihbkiouvW42jpchNo9
	 GpGoA6tdKD/k5g2+WxaFhH4xpQkbp3QhCRpoH127sGWHZwA9OoVHEdGjcZcPWTnryrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792840489;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=0wnwhBBpOzdqMsUIaIUutpRF6KdHwLi1ULdqncAFHjE=;
	b=3oiFuEe9KdQl5Gmuvvn8kpGcTH2WlmCCNeCXFybD2Y2v1bZxHcC8H+CQh6khK/Atzypo
	 lfjfA1q2vfGpOtf2aSVPG9LNZQK13u7uZpUhp0BzJuZuaiuD6a4VaDYdwuPL6PdsvL7uD
	 fw9JhtMBcIDX/DlT033zPxqRb++cxbtLEdUbNrRmJc2Es7QlTBgezzxXJvOl3LjrBoqp+
	 tpTfattVyATTX+ypsZnvGCsFzZQNQJFq/di3f4tJtDRVSWaGrDwK8keORlmf0pzlKDW/u
	 neIkugE79xYgFEm9VZ3Ru7ouR/0CJIjRtPmfgBXh/MUzIxXj+dsLHVIVWpZ/e1Ljlvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.131
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC70606A31A;
	Sat, 24 Oct 2026 11:14:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDC70606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue010
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MjjSt-1wshkU2Qgd-00dtlW; Sat, 24
 Oct 2026 13:14:29 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.15.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sat, 24 Oct 2026 13:14:25 +0200
Message-ID: <20261024111425.50052-1-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:MIzE5JaVKNdQjPoLoYDvGbzgEoQuTScFeYlEnFSOb2B6k0T+ABP
 DwXGXJFfNRAV+bsqAm5DjK9blzYIsh+DF8CYTIdHDUXmqGHFiwKNAW0UC2PRur0EVyjT/uf
 OVPH8F/yNlnDia0hDH5bN9Ba5GRPf4pFmxzkm24nEtWLGkBJ2Np039O+0Vu3mkHDvzveNDQ
 kHRl/f1bqCvvNc3Otw1Wg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HjtgxPqmLgI=;WWcLUxJ8SOMFJh0qG2Wq5RnNzE1
 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
 dXZUai3

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.15.y: 5.15 has no nft_set_maxsize() helper (introduced by
  8d738c1869f6 "netfilter: nf_tables: fix set size with rbtree backend",
  not in 5.15), so the per-set ceiling is inlined using 5.15's own
  accounting: max = set->size + set->ndeact, and the element is only
  counted when set->size is non-zero (unlimited sets are untracked, as
  before). The matching atomic_dec() on the error path is guarded the
  same way. The update-path hunk from the upstream commit does not apply:
  5.15 has no in-place element-update path here. ]
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
Not a clean cherry-pick, please see the bracketed backport note: 5.15
lacks nft_set_maxsize(), so the ceiling is inlined using 5.15's existing
accounting. A review of the adaptation from the netfilter side would be
appreciated.

Build-tested on arm64, and boot-tested under QEMU with KASAN: the set size
limit is still enforced (ENFILE), element counts stay correct across
delete/re-add and flush, unlimited sets are unaffected, no KASAN reports.

 net/netfilter/nf_tables_api.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5273255b738..70f28038d1ad 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6255,6 +6255,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u64 timeout;
 	u64 expiration;
 	int err, i;
@@ -6541,10 +6542,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_expr;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size) {
+		unsigned int max = set->size + set->ndeact, nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -6576,20 +6585,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size)
+		atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.50.1 (Apple Git-155)

